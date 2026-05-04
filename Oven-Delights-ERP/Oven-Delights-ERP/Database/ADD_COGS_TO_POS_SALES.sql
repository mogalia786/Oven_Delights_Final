-- =============================================
-- ADD COST OF SALES POSTING TO POS
-- When a sale or order is completed, post COGS to ledger
-- This enables Profit & Loss reporting
-- =============================================

-- =============================================
-- STEP 1: Ensure COGS Ledger Account Exists
-- =============================================
PRINT 'Checking Cost of Sales ledger account...';

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5000')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('5000', 'Cost of Sales', 'Expense', 1, 'SYSTEM', GETDATE());
    PRINT '✓ Created Cost of Sales account (5000)';
END
ELSE
BEGIN
    PRINT '✓ Cost of Sales account already exists';
END
GO

-- =============================================
-- STEP 2: Ensure Inventory Account Exists
-- =============================================
PRINT 'Checking Inventory account...';

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1300')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('1300', 'Inventory', 'Asset', 1, 'SYSTEM', GETDATE());
    PRINT '✓ Created Inventory account (1300)';
END
ELSE
BEGIN
    PRINT '✓ Inventory account already exists';
END
GO

-- =============================================
-- STEP 3: Create Stored Procedure to Post COGS
-- =============================================
PRINT 'Creating sp_PostCostOfSales procedure...';

IF OBJECT_ID('sp_PostCostOfSales', 'P') IS NOT NULL
    DROP PROCEDURE sp_PostCostOfSales;
GO

CREATE PROCEDURE sp_PostCostOfSales
    @SaleID INT,
    @SaleNumber NVARCHAR(50),
    @BranchID INT,
    @UserName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalCOGS DECIMAL(18,2) = 0;
    DECLARE @JournalNumber NVARCHAR(50);
    
    -- Calculate total COGS from sale items
    -- Use Demo_Retail_Price.CostPrice which includes VAT + Adhoc for manufactured products
    SELECT @TotalCOGS = SUM(
        sd.Quantity * ISNULL(rp.CostPrice, 0)
    )
    FROM Demo_Sales_Details sd
    INNER JOIN Demo_Retail_Product p ON sd.ProductID = p.ProductID AND sd.BranchID = p.BranchID
    LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
    WHERE sd.SaleID = @SaleID;
    
    -- Only post if COGS > 0
    IF @TotalCOGS > 0
    BEGIN
        SET @JournalNumber = 'SALE-' + @SaleNumber;
        
        -- DR: Cost of Sales (Expense increases)
        INSERT INTO GeneralLedger (
            JournalEntryNumber, BranchID, AccountID, TransactionDate, 
            Description, DebitAmount, CreditAmount, 
            ReferenceType, ReferenceID, CreatedBy, CreatedDate, IsReversed
        )
        SELECT 
            @JournalNumber,
            @BranchID,
            (SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '5000'),
            GETDATE(),
            'Cost of goods sold - Sale ' + @SaleNumber,
            @TotalCOGS,
            0,
            'Sale',
            @SaleID,
            @UserName,
            GETDATE(),
            0;
        
        -- CR: Inventory (Asset decreases)
        INSERT INTO GeneralLedger (
            JournalEntryNumber, BranchID, AccountID, TransactionDate,
            Description, DebitAmount, CreditAmount,
            ReferenceType, ReferenceID, CreatedBy, CreatedDate, IsReversed
        )
        SELECT 
            @JournalNumber,
            @BranchID,
            (SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '1300'),
            GETDATE(),
            'Inventory reduction - Sale ' + @SaleNumber,
            0,
            @TotalCOGS,
            'Sale',
            @SaleID,
            @UserName,
            GETDATE(),
            0;
    END
    
    RETURN @TotalCOGS;
END
GO

PRINT '✓ Created sp_PostCostOfSales procedure';
GO

-- =============================================
-- STEP 4: Create Stored Procedure for Order COGS
-- =============================================
PRINT 'Creating sp_PostOrderCostOfSales procedure...';

IF OBJECT_ID('sp_PostOrderCostOfSales', 'P') IS NOT NULL
    DROP PROCEDURE sp_PostOrderCostOfSales;
GO

CREATE PROCEDURE sp_PostOrderCostOfSales
    @OrderID INT,
    @OrderNumber NVARCHAR(50),
    @BranchID INT,
    @UserName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalCOGS DECIMAL(18,2) = 0;
    DECLARE @JournalNumber NVARCHAR(50);
    
    -- Calculate total COGS from order items
    SELECT @TotalCOGS = SUM(
        od.Quantity * ISNULL(rp.CostPrice, 0)
    )
    FROM Demo_CustomOrders_Details od
    INNER JOIN Demo_Retail_Product p ON od.ProductID = p.ProductID AND od.BranchID = p.BranchID
    LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
    WHERE od.OrderID = @OrderID;
    
    -- Only post if COGS > 0
    IF @TotalCOGS > 0
    BEGIN
        SET @JournalNumber = 'ORDER-' + @OrderNumber;
        
        -- DR: Cost of Sales (Expense increases)
        INSERT INTO GeneralLedger (
            JournalEntryNumber, BranchID, AccountID, TransactionDate,
            Description, DebitAmount, CreditAmount,
            ReferenceType, ReferenceID, CreatedBy, CreatedDate, IsReversed
        )
        SELECT 
            @JournalNumber,
            @BranchID,
            (SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '5000'),
            GETDATE(),
            'Cost of goods sold - Order ' + @OrderNumber,
            @TotalCOGS,
            0,
            'Order',
            @OrderID,
            @UserName,
            GETDATE(),
            0;
        
        -- CR: Inventory (Asset decreases)
        INSERT INTO GeneralLedger (
            JournalEntryNumber, BranchID, AccountID, TransactionDate,
            Description, DebitAmount, CreditAmount,
            ReferenceType, ReferenceID, CreatedBy, CreatedDate, IsReversed
        )
        SELECT 
            @JournalNumber,
            @BranchID,
            (SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '1300'),
            GETDATE(),
            'Inventory reduction - Order ' + @OrderNumber,
            0,
            @TotalCOGS,
            'Order',
            @OrderID,
            @UserName,
            GETDATE(),
            0;
    END
    
    RETURN @TotalCOGS;
END
GO

PRINT '✓ Created sp_PostOrderCostOfSales procedure';
GO

-- =============================================
-- VERIFICATION
-- =============================================
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT 'COST OF SALES POSTING - SETUP COMPLETE';
PRINT '═══════════════════════════════════════════════';
PRINT '';
PRINT 'WHAT WAS CREATED:';
PRINT '1. ✓ Chart of Accounts:';
PRINT '   - 5000: Cost of Sales (Expense)';
PRINT '   - 1300: Inventory (Asset)';
PRINT '';
PRINT '2. ✓ Stored Procedures:';
PRINT '   - sp_PostCostOfSales (for regular sales)';
PRINT '   - sp_PostOrderCostOfSales (for custom orders)';
PRINT '';
PRINT 'HOW IT WORKS:';
PRINT '- When POS completes a sale/order, call the SP';
PRINT '- SP calculates total COGS from Demo_Retail_Price.CostPrice';
PRINT '- Posts: DR Cost of Sales, CR Inventory';
PRINT '- Uses CostPrice which includes VAT + Adhoc for manufactured products';
PRINT '';
PRINT 'PROFIT & LOSS CALCULATION:';
PRINT '- Revenue = Sum of Sales (Account 4000)';
PRINT '- COGS = Sum of Cost of Sales (Account 5000)';
PRINT '- Gross Profit = Revenue - COGS';
PRINT '';
PRINT 'NEXT STEPS:';
PRINT '1. Update POS code to call sp_PostCostOfSales after sale completion';
PRINT '2. Update POS code to call sp_PostOrderCostOfSales after order collection';
PRINT '3. Test with a sale to verify COGS posting';
PRINT '═══════════════════════════════════════════════';
GO
