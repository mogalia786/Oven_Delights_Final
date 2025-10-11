-- Test BOM Fulfillment Process
-- This simulates the exact SQL statements from OnFulfill button click

DECLARE @id INT = 122; -- InternalOrderID
DECLARE @branchId INT = 1;
DECLARE @manId INT = 1;
DECLARE @userId INT = 1;

BEGIN TRANSACTION;

BEGIN TRY
    PRINT '=== Starting BOM Fulfillment Test ===';
    PRINT '';
    
    -- Step 1: Get BranchID from InternalOrderHeader
    PRINT '1. Getting BranchID...';
    SELECT @branchId = ISNULL(BranchID, 0) FROM dbo.InternalOrderHeader WHERE InternalOrderID=@id;
    IF @branchId <= 0 SET @branchId = 1;
    PRINT '   BranchID: ' + CAST(@branchId AS NVARCHAR);
    PRINT '';
    
    -- Step 2: Load InternalOrderLines
    PRINT '2. Loading materials needed...';
    DECLARE @materials TABLE (MaterialID INT, Quantity DECIMAL(18,4));
    INSERT INTO @materials (MaterialID, Quantity)
    SELECT MaterialID, Quantity FROM dbo.InternalOrderLines WHERE InternalOrderID=@id AND MaterialID IS NOT NULL;
    
    SELECT * FROM @materials;
    PRINT '';
    
    -- Step 3: Process each material
    DECLARE @MaterialID INT, @Quantity DECIMAL(18,4);
    DECLARE @availableQty DECIMAL(18,4), @unitCost DECIMAL(18,4);
    DECLARE @totalValue DECIMAL(18,2) = 0;
    
    DECLARE mat_cursor CURSOR FOR SELECT MaterialID, Quantity FROM @materials;
    OPEN mat_cursor;
    FETCH NEXT FROM mat_cursor INTO @MaterialID, @Quantity;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '3. Processing MaterialID: ' + CAST(@MaterialID AS NVARCHAR) + ', Qty: ' + CAST(@Quantity AS NVARCHAR);
        
        -- Check stock availability
        PRINT '   3a. Checking stock from RawMaterials...';
        SELECT @availableQty = ISNULL(CurrentStock, 0), @unitCost = ISNULL(AverageCost, 0) 
        FROM dbo.RawMaterials WHERE MaterialID=@MaterialID;
        PRINT '      Available: ' + CAST(@availableQty AS NVARCHAR) + ', Cost: ' + CAST(@unitCost AS NVARCHAR);
        
        IF @availableQty < @Quantity
        BEGIN
            PRINT '   ERROR: Insufficient stock!';
            RAISERROR('Insufficient stock', 16, 1);
        END
        
        -- Reduce Stockroom Inventory
        PRINT '   3b. Reducing RawMaterials stock...';
        UPDATE dbo.RawMaterials SET CurrentStock = CurrentStock - @Quantity WHERE MaterialID=@MaterialID;
        PRINT '      Updated RawMaterials';
        
        -- Check if exists in Manufacturing_Inventory
        PRINT '   3c. Checking Manufacturing_Inventory...';
        DECLARE @exists BIT = 0;
        IF EXISTS (SELECT 1 FROM dbo.Manufacturing_Inventory WHERE MaterialID=@MaterialID AND BranchID=@branchId)
            SET @exists = 1;
        
        IF @exists = 1
        BEGIN
            PRINT '      Updating existing Manufacturing_Inventory...';
            UPDATE dbo.Manufacturing_Inventory 
            SET QtyOnHand = QtyOnHand + @Quantity, AverageCost = @unitCost, LastUpdated = GETDATE(), UpdatedBy = @userId 
            WHERE MaterialID=@MaterialID AND BranchID=@branchId;
            PRINT '      Updated';
        END
        ELSE
        BEGIN
            PRINT '      Inserting new Manufacturing_Inventory...';
            INSERT INTO dbo.Manufacturing_Inventory (MaterialID, BranchID, QtyOnHand, AverageCost, LastUpdated, UpdatedBy) 
            VALUES (@MaterialID, @branchId, @Quantity, @unitCost, GETDATE(), @userId);
            PRINT '      Inserted';
        END
        
        -- Insert Manufacturing_InventoryMovements
        PRINT '   3d. Inserting Manufacturing_InventoryMovements...';
        INSERT INTO dbo.Manufacturing_InventoryMovements (MaterialID, BranchID, MovementType, QtyDelta, CostPerUnit, Reference, Notes, MovementDate, CreatedBy) 
        VALUES (@MaterialID, @branchId, 'Issue from Stockroom', @Quantity, @unitCost, 'IO-' + CAST(@id AS NVARCHAR), 'BOM Fulfillment', GETDATE(), @userId);
        PRINT '      Inserted movement record';
        
        SET @totalValue = @totalValue + (@Quantity * @unitCost);
        PRINT '   Total value so far: ' + CAST(@totalValue AS NVARCHAR);
        PRINT '';
        
        FETCH NEXT FROM mat_cursor INTO @MaterialID, @Quantity;
    END
    
    CLOSE mat_cursor;
    DEALLOCATE mat_cursor;
    
    -- Step 4: Create Journal Entry
    IF @totalValue > 0
    BEGIN
        PRINT '4. Creating Journal Entry...';
        
        -- Get current fiscal period
        DECLARE @fiscalPeriodId INT = 0;
        SELECT TOP 1 @fiscalPeriodId = PeriodID 
        FROM dbo.FiscalPeriods 
        WHERE GETDATE() BETWEEN StartDate AND EndDate AND IsClosed = 0 
        ORDER BY StartDate DESC;
        
        IF @fiscalPeriodId <= 0
        BEGIN
            PRINT '   WARNING: No open fiscal period found. Skipping journal entry.';
        END
        ELSE
        BEGIN
            DECLARE @journalNumber NVARCHAR(50) = 'JNL-BOM-' + CAST(@id AS NVARCHAR) + '-TEST';
            DECLARE @journalId INT;
            
            PRINT '   4a. Inserting JournalHeaders...';
            PRINT '      FiscalPeriodID: ' + CAST(@fiscalPeriodId AS NVARCHAR);
            INSERT INTO dbo.JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy) 
            VALUES (@journalNumber, @branchId, GETDATE(), 'IO-' + CAST(@id AS NVARCHAR), 'BOM Fulfillment - Issue to Manufacturing', @fiscalPeriodId, 1, @userId);
            SET @journalId = SCOPE_IDENTITY();
            PRINT '      JournalID: ' + CAST(@journalId AS NVARCHAR);
        
        -- Get account IDs
        DECLARE @mfgInvAcct INT, @stockInvAcct INT;
        
        SELECT @mfgInvAcct = AccountID FROM dbo.ChartOfAccounts WHERE AccountName = 'Manufacturing Inventory';
        IF @mfgInvAcct IS NULL
        BEGIN
            PRINT '   Creating Manufacturing Inventory account...';
            INSERT INTO dbo.ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive) 
            VALUES ('1320', 'Manufacturing Inventory', 'Asset', 1);
            SET @mfgInvAcct = SCOPE_IDENTITY();
        END
        
        SELECT @stockInvAcct = AccountID FROM dbo.ChartOfAccounts WHERE AccountName = 'Stockroom Inventory';
        IF @stockInvAcct IS NULL
        BEGIN
            PRINT '   Creating Stockroom Inventory account...';
            INSERT INTO dbo.ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive) 
            VALUES ('1310', 'Stockroom Inventory', 'Asset', 1);
            SET @stockInvAcct = SCOPE_IDENTITY();
        END
        
        PRINT '   4b. DR Manufacturing Inventory...';
        INSERT INTO dbo.JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description) 
        VALUES (@journalId, 1, @mfgInvAcct, ROUND(@totalValue, 2), 0, 'Materials issued to manufacturing');
        PRINT '      Inserted DR entry';
        
        PRINT '   4c. CR Stockroom Inventory...';
        INSERT INTO dbo.JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description) 
        VALUES (@journalId, 2, @stockInvAcct, 0, ROUND(@totalValue, 2), 'Materials issued to manufacturing');
        PRINT '      Inserted CR entry';
        END
    END
    PRINT '';
    
    -- Step 5: Update status
    PRINT '5. Updating InternalOrderHeader status to Issued...';
    UPDATE dbo.InternalOrderHeader SET Status = N'Issued' WHERE InternalOrderID=@id;
    PRINT '   Status updated';
    PRINT '';
    
    PRINT '=== SUCCESS! All steps completed ===';
    PRINT 'Total value transferred: R ' + CAST(@totalValue AS NVARCHAR);
    
    -- ROLLBACK for testing (change to COMMIT to actually save)
    ROLLBACK TRANSACTION;
    PRINT '';
    PRINT 'Transaction ROLLED BACK (test mode)';
    PRINT 'Change ROLLBACK to COMMIT to actually save changes';
    
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT '';
    PRINT '=== ERROR OCCURRED ===';
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
    PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
    PRINT '';
    PRINT 'This is the exact error that would occur in the application!';
END CATCH;
