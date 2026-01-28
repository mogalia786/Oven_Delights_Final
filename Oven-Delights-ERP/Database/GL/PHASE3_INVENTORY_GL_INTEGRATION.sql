-- =============================================
-- PHASE 3: INVENTORY GL INTEGRATION
-- Stock Adjustments, Wastage, and Movements
-- =============================================

PRINT '========================================='
PRINT 'PHASE 3: INVENTORY GL INTEGRATION'
PRINT '========================================='
PRINT ''

-- =============================================
-- Drop existing procedures if they exist
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_Inventory_PostAdjustmentToGL' AND type = 'P')
    DROP PROCEDURE sp_Inventory_PostAdjustmentToGL
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_Inventory_PostWastageToGL' AND type = 'P')
    DROP PROCEDURE sp_Inventory_PostWastageToGL
GO

PRINT '✓ Dropped old procedures (if existed)'
PRINT ''
GO

-- =============================================
-- sp_Inventory_PostAdjustmentToGL
-- Post stock adjustments (increase or decrease)
-- =============================================
CREATE PROCEDURE sp_Inventory_PostAdjustmentToGL
    @AdjustmentID INT,
    @AdjustmentNumber NVARCHAR(50),
    @AdjustmentDate DATE,
    @BranchID INT,
    @ProductID INT,
    @ProductName NVARCHAR(200),
    @AdjustmentType NVARCHAR(20), -- 'Increase' or 'Decrease'
    @Quantity DECIMAL(18,2),
    @UnitCost DECIMAL(18,2),
    @TotalValue DECIMAL(18,2),
    @Reason NVARCHAR(500),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @FiscalPeriodID INT
        
        -- Account IDs
        DECLARE @InventoryAccountID INT
        DECLARE @InventoryVarianceAccountID INT
        
        -- Get Account IDs
        SELECT @InventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        SELECT @InventoryVarianceAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '6050' AND IsActive = 1
        
        -- Validate accounts exist
        IF @InventoryAccountID IS NULL
            RAISERROR('Inventory account 1220 not found or inactive', 16, 1)
            
        IF @InventoryVarianceAccountID IS NULL
            RAISERROR('Inventory Variance account 6050 not found or inactive', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'ADJ-' + @AdjustmentNumber
        
        -- Get fiscal period
        SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@AdjustmentDate)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @AdjustmentDate,
            @AdjustmentNumber,
            'Stock Adjustment - ' + @ProductName + ' (' + @AdjustmentType + ')',
            @FiscalPeriodID,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Post journal entries based on adjustment type
        IF @AdjustmentType = 'Increase'
        BEGIN
            -- Stock increase (found extra stock)
            -- DEBIT: Inventory (increase asset)
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 1, @InventoryAccountID, @TotalValue, 0, 
                    'Stock increase - ' + @ProductName, @AdjustmentNumber, @Reason)
            
            -- CREDIT: Inventory Variance (offset - gain)
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 2, @InventoryVarianceAccountID, 0, @TotalValue, 
                    'Variance - stock gain', @AdjustmentNumber, @Reason)
        END
        ELSE IF @AdjustmentType = 'Decrease'
        BEGIN
            -- Stock decrease (missing stock)
            -- DEBIT: Inventory Variance (expense - loss)
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 1, @InventoryVarianceAccountID, @TotalValue, 0, 
                    'Variance - stock loss', @AdjustmentNumber, @Reason)
            
            -- CREDIT: Inventory (decrease asset)
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 2, @InventoryAccountID, 0, @TotalValue, 
                    'Stock decrease - ' + @ProductName, @AdjustmentNumber, @Reason)
        END
        ELSE
        BEGIN
            RAISERROR('Invalid adjustment type. Must be Increase or Decrease', 16, 1)
        END
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'Stock adjustment posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_Inventory_PostAdjustmentToGL'
GO

-- =============================================
-- sp_Inventory_PostWastageToGL
-- Post wastage (damaged/expired stock)
-- =============================================
CREATE PROCEDURE sp_Inventory_PostWastageToGL
    @WastageID INT,
    @WastageNumber NVARCHAR(50),
    @WastageDate DATE,
    @BranchID INT,
    @ProductID INT,
    @ProductName NVARCHAR(200),
    @Quantity DECIMAL(18,2),
    @UnitCost DECIMAL(18,2),
    @TotalValue DECIMAL(18,2),
    @WastageReason NVARCHAR(500), -- 'Damaged', 'Expired', 'Spoiled', etc.
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @FiscalPeriodID INT
        
        -- Account IDs
        DECLARE @InventoryAccountID INT
        DECLARE @WastageAccountID INT
        
        -- Get Account IDs
        SELECT @InventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        SELECT @WastageAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '6060' AND IsActive = 1
        
        -- Validate accounts exist
        IF @InventoryAccountID IS NULL
            RAISERROR('Inventory account 1220 not found or inactive', 16, 1)
            
        IF @WastageAccountID IS NULL
            RAISERROR('Wastage Expense account 6060 not found or inactive', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'WST-' + @WastageNumber
        
        -- Get fiscal period
        SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@WastageDate)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @WastageDate,
            @WastageNumber,
            'Wastage - ' + @ProductName + ' (' + @WastageReason + ')',
            @FiscalPeriodID,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- DEBIT: Wastage Expense (recognize loss)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
        VALUES (@JournalID, 1, @WastageAccountID, @TotalValue, 0, 
                'Wastage - ' + @WastageReason, @WastageNumber, @ProductName)
        
        -- CREDIT: Inventory (reduce asset)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
        VALUES (@JournalID, 2, @InventoryAccountID, 0, @TotalValue, 
                'Remove wasted stock', @WastageNumber, @ProductName)
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'Wastage posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_Inventory_PostWastageToGL'
GO

PRINT ''
PRINT '========================================='
PRINT 'PHASE 3 COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Created Procedures:'
PRINT '1. sp_Inventory_PostAdjustmentToGL - Stock adjustments (increase/decrease)'
PRINT '2. sp_Inventory_PostWastageToGL - Wastage (damaged/expired stock)'
PRINT ''
PRINT 'Journal Entry Examples:'
PRINT ''
PRINT 'Stock Increase (Found extra stock):'
PRINT '  DR 1220 Inventory           R500'
PRINT '  CR 6050 Inventory Variance       R500'
PRINT ''
PRINT 'Stock Decrease (Missing stock):'
PRINT '  DR 6050 Inventory Variance  R500'
PRINT '  CR 1220 Inventory                R500'
PRINT ''
PRINT 'Wastage (Damaged/Expired):'
PRINT '  DR 6060 Wastage Expense     R300'
PRINT '  CR 1220 Inventory                R300'
PRINT ''
