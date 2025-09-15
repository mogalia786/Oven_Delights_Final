-- sp_IBT_Post: Post Inter-Branch Transfer (adjust stock + create journals + numbering)
SET NOCOUNT ON;
GO
IF OBJECT_ID('dbo.sp_IBT_Post','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_IBT_Post AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.sp_IBT_Post
    @TransferID INT,
    @PostedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FromBranchID INT, @ToBranchID INT, @INT_PO NVARCHAR(40), @INTER_INV NVARCHAR(40);
    SELECT @FromBranchID = FromBranchID, @ToBranchID = ToBranchID
    FROM dbo.InterBranchTransferHeader WHERE TransferID=@TransferID;

    IF @FromBranchID IS NULL OR @ToBranchID IS NULL
    BEGIN
        RAISERROR('Invalid TransferID', 16, 1);
        RETURN;
    END

    -- Numbering (placeholder: use BranchCode if available)
    DECLARE @FromCode NVARCHAR(10) = (SELECT TOP 1 BranchCode FROM dbo.Branches WHERE BranchID=@FromBranchID);
    SET @INT_PO = CONCAT(ISNULL(@FromCode,'BR'),'-INT-PO-',FORMAT(@TransferID,'00000'));
    SET @INTER_INV = CONCAT(ISNULL(@FromCode,'BR'),'-INTER-INV-',FORMAT(@TransferID,'00000'));

    UPDATE dbo.InterBranchTransferHeader
    SET Status='Posted', TransferDate=SYSUTCDATETIME(), INT_PO_Number=@INT_PO, INTER_INV_Number=@INTER_INV
    WHERE TransferID=@TransferID;

    BEGIN TRY
        BEGIN TRAN;

        -- Adjust stock per line
        DECLARE @vVariantID INT, @prod INT, @var INT, @qty DECIMAL(18,3), @lineId INT;
        DECLARE c CURSOR LOCAL FAST_FORWARD FOR
            SELECT TransferLineID, ProductID, ISNULL(VariantID,0), Quantity
            FROM dbo.InterBranchTransferLine
            WHERE TransferID=@TransferID;
        OPEN c;
        FETCH NEXT FROM c INTO @lineId, @prod, @var, @qty;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @vVariantID = @var;
            IF @vVariantID IS NULL OR @vVariantID = 0
            BEGIN
                -- Ensure a variant exists for the product (no-barcode default)
                IF OBJECT_ID('dbo.sp_Retail_EnsureVariant','P') IS NOT NULL
                BEGIN
                    EXEC dbo.sp_Retail_EnsureVariant @ProductID=@prod, @Barcode=NULL, @VariantID=@vVariantID OUTPUT;
                END
            END

            -- From branch: decrement stock
            IF NOT EXISTS (SELECT 1 FROM dbo.Retail_Stock WHERE VariantID=@vVariantID AND ISNULL(BranchID,-1)=ISNULL(@FromBranchID,-1) AND ISNULL(Location,'')='')
            BEGIN
                INSERT INTO dbo.Retail_Stock(VariantID, BranchID, QtyOnHand, ReorderPoint, Location)
                VALUES(@vVariantID, @FromBranchID, 0, 0, NULL);
            END
            UPDATE dbo.Retail_Stock
                SET QtyOnHand = QtyOnHand - @qty,
                    UpdatedAt = SYSUTCDATETIME()
            WHERE VariantID=@vVariantID AND ISNULL(BranchID,-1)=ISNULL(@FromBranchID,-1) AND ISNULL(Location,'')='';
            IF OBJECT_ID('dbo.Retail_StockMovements','U') IS NOT NULL
            BEGIN
                INSERT INTO dbo.Retail_StockMovements(VariantID, BranchID, QtyDelta, Reason, Ref1, Ref2, CreatedAt, CreatedBy)
                VALUES(@vVariantID, @FromBranchID, -@qty, 'InterBranch Out', @INT_PO, CAST(@TransferID AS VARCHAR(20)), SYSUTCDATETIME(), @PostedBy);
            END

            -- To branch: increment stock
            IF NOT EXISTS (SELECT 1 FROM dbo.Retail_Stock WHERE VariantID=@vVariantID AND ISNULL(BranchID,-1)=ISNULL(@ToBranchID,-1) AND ISNULL(Location,'')='')
            BEGIN
                INSERT INTO dbo.Retail_Stock(VariantID, BranchID, QtyOnHand, ReorderPoint, Location)
                VALUES(@vVariantID, @ToBranchID, 0, 0, NULL);
            END
            UPDATE dbo.Retail_Stock
                SET QtyOnHand = QtyOnHand + @qty,
                    UpdatedAt = SYSUTCDATETIME()
            WHERE VariantID=@vVariantID AND ISNULL(BranchID,-1)=ISNULL(@ToBranchID,-1) AND ISNULL(Location,'')='';
            IF OBJECT_ID('dbo.Retail_StockMovements','U') IS NOT NULL
            BEGIN
                INSERT INTO dbo.Retail_StockMovements(VariantID, BranchID, QtyDelta, Reason, Ref1, Ref2, CreatedAt, CreatedBy)
                VALUES(@vVariantID, @ToBranchID, @qty, 'InterBranch In', @INTER_INV, CAST(@TransferID AS VARCHAR(20)), SYSUTCDATETIME(), @PostedBy);
            END

            FETCH NEXT FROM c INTO @lineId, @prod, @var, @qty;
        END
        CLOSE c; DEALLOCATE c;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRAN;
        DECLARE @errmsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('IBT Post failed: %s', 16, 1, @errmsg);
        RETURN;
    END CATCH

    -- Create GL journals (guarded): From (Dr Interbranch Debtors, Cr Inventory); To (Dr Inventory, Cr Interbranch Creditors)
    BEGIN TRY
        DECLARE @amount DECIMAL(18,4) = (SELECT SUM(ISNULL(UnitCost,0) * ISNULL(Quantity,0)) FROM dbo.InterBranchTransferLine WHERE TransferID=@TransferID);
        IF @amount IS NULL SET @amount = 0;
        IF @amount > 0
        BEGIN
            DECLARE @accInventory INT = (SELECT AccountID FROM dbo.SystemAccounts WHERE SysKey='INVENTORY');
            DECLARE @accIBDebtors INT = (SELECT AccountID FROM dbo.SystemAccounts WHERE SysKey='IB_DEBTORS');
            DECLARE @accIBCreditors INT = (SELECT AccountID FROM dbo.SystemAccounts WHERE SysKey='IB_CREDITORS');
            DECLARE @accSuspense INT = (SELECT AccountID FROM dbo.SystemAccounts WHERE SysKey='SUSPENSE');
            IF @accInventory IS NULL SET @accInventory = @accSuspense;
            IF @accIBDebtors IS NULL SET @accIBDebtors = @accSuspense;
            IF @accIBCreditors IS NULL SET @accIBCreditors = @accSuspense;

            IF @accInventory IS NOT NULL AND @accIBDebtors IS NOT NULL AND @accIBCreditors IS NOT NULL
            BEGIN
                DECLARE @fiscalId INT = (SELECT TOP 1 PeriodID FROM dbo.FiscalPeriods WHERE CAST(SYSUTCDATETIME() AS DATE) BETWEEN StartDate AND EndDate AND IsClosed=0 ORDER BY StartDate DESC);
                IF @fiscalId IS NULL SET @fiscalId = (SELECT TOP 1 PeriodID FROM dbo.FiscalPeriods WHERE IsClosed=0 ORDER BY StartDate DESC);

                DECLARE @jId INT;
                EXEC dbo.sp_CreateJournalEntry @JournalDate = CAST(SYSUTCDATETIME() AS DATE), @Reference = @INT_PO, @Description = 'Inter-Branch Transfer Posting', @FiscalPeriodID = @fiscalId, @CreatedBy = @PostedBy, @BranchID = @FromBranchID, @JournalID = @jId OUTPUT;

                -- From branch
                EXEC dbo.sp_AddJournalDetail @JournalID=@jId, @AccountID=@accIBDebtors, @Debit=@amount, @Credit=0, @Description='Inter-Branch Debtor', @Reference1=@INT_PO, @Reference2=@INTER_INV, @CostCenterID=NULL, @ProjectID=NULL, @LineNumber=NULL;
                EXEC dbo.sp_AddJournalDetail @JournalID=@jId, @AccountID=@accInventory, @Debit=0, @Credit=@amount, @Description='Inventory Out (Inter-Branch)', @Reference1=@INT_PO, @Reference2=@INTER_INV, @CostCenterID=NULL, @ProjectID=NULL, @LineNumber=NULL;

                -- To branch
                EXEC dbo.sp_AddJournalDetail @JournalID=@jId, @AccountID=@accInventory, @Debit=@amount, @Credit=0, @Description='Inventory In (Inter-Branch)', @Reference1=@INT_PO, @Reference2=@INTER_INV, @CostCenterID=NULL, @ProjectID=NULL, @LineNumber=NULL;
                EXEC dbo.sp_AddJournalDetail @JournalID=@jId, @AccountID=@accIBCreditors, @Debit=0, @Credit=@amount, @Description='Inter-Branch Creditor', @Reference1=@INT_PO, @Reference2=@INTER_INV, @CostCenterID=NULL, @ProjectID=NULL, @LineNumber=NULL;

                EXEC dbo.sp_PostJournal @JournalID=@jId, @PostedBy=@PostedBy;
            END
        END
    END TRY
    BEGIN CATCH
        -- Do not fail IBT posting if GL posting encounters a mapping error
        -- Optionally, write to an audit table here
    END CATCH

    SELECT @INT_PO AS INT_PO_Number, @INTER_INV AS INTER_INV_Number;
END;
