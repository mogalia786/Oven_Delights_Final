-- =============================================
-- Manufacturing GL Integration Procedures
-- =============================================

-- =============================================
-- sp_MFG_PostProductionToGL - Post Manufacturing Production to GL
-- =============================================
CREATE OR ALTER PROCEDURE sp_MFG_PostProductionToGL
    @ProductionID INT,
    @ProductionNumber NVARCHAR(50),
    @ProductionDate DATE,
    @ProductName NVARCHAR(200),
    @BranchID INT,
    @RawMaterialsCost DECIMAL(18,2),
    @LaborCost DECIMAL(18,2),
    @OverheadCost DECIMAL(18,2),
    @TotalCost DECIMAL(18,2),
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @FinishedGoodsAccountID INT
        DECLARE @RawMaterialsAccountID INT
        DECLARE @LaborAccountID INT
        DECLARE @OverheadAccountID INT
        
        -- Get account IDs
        SELECT @FinishedGoodsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1210' AND IsActive = 1
        SELECT @RawMaterialsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1200' AND IsActive = 1
        SELECT @LaborAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '5040' AND IsActive = 1
        SELECT @OverheadAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '6090' AND IsActive = 1
        
        -- Generate journal number
        SET @JournalNumber = 'PROD-' + @ProductionNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @ProductionDate,
            @ProductionNumber,
            'Production - ' + @ProductName,
            NULL,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        DECLARE @LineNumber INT = 1
        
        -- Debit: Finished Goods (Product manufactured)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, @LineNumber, @FinishedGoodsAccountID, @TotalCost, 0,
            'Finished Goods', @ProductionNumber, @ProductName
        )
        SET @LineNumber = @LineNumber + 1
        
        -- Credit: Raw Materials (Materials consumed)
        IF @RawMaterialsCost > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, @LineNumber, @RawMaterialsAccountID, 0, @RawMaterialsCost,
                'Raw Materials Consumed', @ProductionNumber, @ProductName
            )
            SET @LineNumber = @LineNumber + 1
        END
        
        -- Credit: Direct Labor (Labor cost)
        IF @LaborCost > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, @LineNumber, @LaborAccountID, 0, @LaborCost,
                'Direct Labor', @ProductionNumber, @ProductName
            )
            SET @LineNumber = @LineNumber + 1
        END
        
        -- Credit: Manufacturing Overhead (Overhead allocation)
        IF @OverheadCost > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, @LineNumber, @OverheadAccountID, 0, @OverheadCost,
                'Manufacturing Overhead', @ProductionNumber, @ProductName
            )
        END
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Production posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =============================================
-- sp_MFG_PostInventoryTransferToGL - Post Inter-Branch Inventory Transfer to GL
-- =============================================
CREATE OR ALTER PROCEDURE sp_MFG_PostInventoryTransferToGL
    @TransferID INT,
    @TransferNumber NVARCHAR(50),
    @TransferDate DATE,
    @FromBranchID INT,
    @ToBranchID INT,
    @TotalValue DECIMAL(18,2),
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @InterBranchDebtorsAccountID INT
        DECLARE @InventoryAccountID INT
        
        -- Get account IDs
        SELECT @InterBranchDebtorsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1600' AND IsActive = 1
        SELECT @InventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        
        -- Generate journal number
        SET @JournalNumber = 'XFER-' + @TransferNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @FromBranchID,
            @TransferDate,
            @TransferNumber,
            'Inventory Transfer to Branch ' + CAST(@ToBranchID AS NVARCHAR(10)),
            NULL,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: Inter-Branch Debtors (Receiving branch owes)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 1, @InterBranchDebtorsAccountID, @TotalValue, 0,
            'Inter-Branch Transfer Out', @TransferNumber, 'To Branch ' + CAST(@ToBranchID AS NVARCHAR(10))
        )
        
        -- Credit: Inventory (Sending branch reduces stock)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 2, @InventoryAccountID, 0, @TotalValue,
            'Inventory Transfer Out', @TransferNumber, 'To Branch ' + CAST(@ToBranchID AS NVARCHAR(10))
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Inventory transfer posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'Manufacturing Integration procedures created successfully'
GO
