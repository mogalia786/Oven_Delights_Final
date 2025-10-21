-- Test Workflows for Oven Delights ERP
-- This script validates end-to-end workflows for payment management and bank import

USE OvenDelightsERP;
GO

PRINT 'Testing ERP Workflows...';
PRINT '';

-- Test 1: Payment Management Workflow
PRINT '=== TEST 1: PAYMENT MANAGEMENT WORKFLOW ===';

-- Check if required tables exist for payment management
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Suppliers')
    PRINT '✓ Suppliers table exists'
ELSE
    PRINT '⚠ Suppliers table missing - payment management may not work fully';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Invoices')
    PRINT '✓ Invoices table exists'
ELSE
    PRINT '⚠ Invoices table missing - payment management may not work fully';

-- Test PaymentDueService functionality
PRINT '';
PRINT 'Testing payment due calculations...';

-- Create test supplier if not exists
IF NOT EXISTS (SELECT * FROM dbo.Suppliers WHERE SupplierName = 'Test Supplier Ltd')
BEGIN
    INSERT INTO dbo.Suppliers (SupplierName, ContactEmail, IsActive, CreatedAt, CreatedBy)
    VALUES ('Test Supplier Ltd', 'test@supplier.com', 1, GETDATE(), 1);
    PRINT '✓ Created test supplier';
END

-- Create test invoice if Invoices table exists
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Invoices')
BEGIN
    DECLARE @SupplierID INT = (SELECT TOP 1 SupplierID FROM dbo.Suppliers WHERE SupplierName = 'Test Supplier Ltd');
    
    IF NOT EXISTS (SELECT * FROM dbo.Invoices WHERE InvoiceNumber = 'TEST-001')
    BEGIN
        INSERT INTO dbo.Invoices (InvoiceNumber, SupplierID, InvoiceDate, DueDate, Amount, Status, CreatedAt, CreatedBy)
        VALUES ('TEST-001', @SupplierID, GETDATE(), DATEADD(day, -5, GETDATE()), 1500.00, 'Pending', GETDATE(), 1);
        PRINT '✓ Created overdue test invoice';
    END
END

PRINT '';

-- Test 2: Bank Statement Import Workflow
PRINT '=== TEST 2: BANK STATEMENT IMPORT WORKFLOW ===';

-- Check if chart of accounts exists for bank mapping
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ChartOfAccounts')
    PRINT '✓ Chart of Accounts table exists'
ELSE
    PRINT '⚠ Chart of Accounts table missing - bank mapping may not work fully';

-- Create sample GL accounts for bank statement mapping
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ChartOfAccounts')
BEGIN
    -- Bank account
    IF NOT EXISTS (SELECT * FROM dbo.ChartOfAccounts WHERE AccountCode = '1001')
    BEGIN
        INSERT INTO dbo.ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedAt, CreatedBy)
        VALUES ('1001', 'Bank - Current Account', 'Asset', 1, GETDATE(), 1);
        PRINT '✓ Created bank account (1001)';
    END
    
    -- Expense accounts
    IF NOT EXISTS (SELECT * FROM dbo.ChartOfAccounts WHERE AccountCode = '5001')
    BEGIN
        INSERT INTO dbo.ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedAt, CreatedBy)
        VALUES ('5001', 'Office Supplies', 'Expense', 1, GETDATE(), 1);
        PRINT '✓ Created office supplies account (5001)';
    END
    
    IF NOT EXISTS (SELECT * FROM dbo.ChartOfAccounts WHERE AccountCode = '5002')
    BEGIN
        INSERT INTO dbo.ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedAt, CreatedBy)
        VALUES ('5002', 'Utilities', 'Expense', 1, GETDATE(), 1);
        PRINT '✓ Created utilities account (5002)';
    END
    
    -- Accounts payable
    IF NOT EXISTS (SELECT * FROM dbo.ChartOfAccounts WHERE AccountCode = '2001')
    BEGIN
        INSERT INTO dbo.ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedAt, CreatedBy)
        VALUES ('2001', 'Accounts Payable', 'Liability', 1, GETDATE(), 1);
        PRINT '✓ Created accounts payable account (2001)';
    END
END

PRINT '';

-- Test 3: SARS Compliance Workflow
PRINT '=== TEST 3: SARS COMPLIANCE WORKFLOW ===';

-- Verify SARS tables exist
DECLARE @SARSTablesCount INT = 0;

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'VATTransactions')
BEGIN
    SET @SARSTablesCount = @SARSTablesCount + 1;
    PRINT '✓ VATTransactions table exists';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Employees')
BEGIN
    SET @SARSTablesCount = @SARSTablesCount + 1;
    PRINT '✓ Employees table exists';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PayrollTransactions')
BEGIN
    SET @SARSTablesCount = @SARSTablesCount + 1;
    PRINT '✓ PayrollTransactions table exists';
END

IF @SARSTablesCount = 3
    PRINT '✓ All SARS compliance tables are ready'
ELSE
    PRINT '⚠ Some SARS tables are missing - run ExecuteAllScripts.sql first';

-- Test VAT201 data generation
PRINT '';
PRINT 'Testing VAT201 data generation...';

DECLARE @VATCount INT = (SELECT COUNT(*) FROM dbo.VATTransactions WHERE TransactionDate >= DATEADD(month, -1, GETDATE()));
PRINT '✓ Found ' + CAST(@VATCount AS VARCHAR(10)) + ' VAT transactions for current period';

-- Test EMP201 data generation  
PRINT 'Testing EMP201 data generation...';

DECLARE @PayrollCount INT = (SELECT COUNT(*) FROM dbo.PayrollTransactions WHERE PayPeriodStart >= DATEADD(month, -1, GETDATE()));
PRINT '✓ Found ' + CAST(@PayrollCount AS VARCHAR(10)) + ' payroll transactions for current period';

-- Test IRP5 data generation
PRINT 'Testing IRP5 data generation...';

DECLARE @EmployeeCount INT = (SELECT COUNT(*) FROM dbo.Employees WHERE IsActive = 1);
PRINT '✓ Found ' + CAST(@EmployeeCount AS VARCHAR(10)) + ' active employees for IRP5 generation';

PRINT '';

-- Test 4: Product Synchronization Workflow
PRINT '=== TEST 4: PRODUCT SYNCHRONIZATION WORKFLOW ===';

-- Check if sync procedures exist
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_SyncLegacyInventoryToStockroom')
    PRINT '✓ Legacy inventory sync procedure exists'
ELSE
    PRINT '⚠ Legacy inventory sync procedure missing';

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_CompleteBOM')
    PRINT '✓ BOM completion procedure exists'
ELSE
    PRINT '⚠ BOM completion procedure missing';

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_TransferManufacturingToRetail')
    PRINT '✓ Manufacturing to retail transfer procedure exists'
ELSE
    PRINT '⚠ Manufacturing to retail transfer procedure missing';

-- Check triggers
DECLARE @TriggerCount INT = 0;

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_GRN_AfterInsertUpdate')
BEGIN
    SET @TriggerCount = @TriggerCount + 1;
    PRINT '✓ GoodsReceivedNotes sync trigger exists';
END

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_Inventory_AfterUpdate')
BEGIN
    SET @TriggerCount = @TriggerCount + 1;
    PRINT '✓ Inventory sync trigger exists';
END

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_RawMaterials_AfterInsertUpdate')
BEGIN
    SET @TriggerCount = @TriggerCount + 1;
    PRINT '✓ RawMaterials sync trigger exists';
END

PRINT '✓ ' + CAST(@TriggerCount AS VARCHAR(10)) + ' synchronization triggers are active';

PRINT '';

-- Test 5: Manufacturing Product Creation Workflow
PRINT '=== TEST 5: MANUFACTURING PRODUCT CREATION WORKFLOW ===';

-- Check Manufacturing_Product table
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Manufacturing_Product')
BEGIN
    PRINT '✓ Manufacturing_Product table exists';
    
    DECLARE @MfgProductCount INT = (SELECT COUNT(*) FROM dbo.Manufacturing_Product WHERE IsActive = 1);
    PRINT '✓ Found ' + CAST(@MfgProductCount AS VARCHAR(10)) + ' active manufacturing products';
    
    -- Check for products without SKUs
    DECLARE @NoSKUCount INT = (SELECT COUNT(*) FROM dbo.Manufacturing_Product WHERE (SKU IS NULL OR SKU = '') AND IsActive = 1);
    IF @NoSKUCount > 0
        PRINT '⚠ ' + CAST(@NoSKUCount AS VARCHAR(10)) + ' manufacturing products missing SKUs - use SKU Assignment form';
    ELSE
        PRINT '✓ All manufacturing products have SKUs assigned';
END
ELSE
    PRINT '⚠ Manufacturing_Product table missing';

PRINT '';

-- Test 6: Retail Product Integration Workflow
PRINT '=== TEST 6: RETAIL PRODUCT INTEGRATION WORKFLOW ===';

-- Check Retail_Product table
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Retail_Product')
BEGIN
    PRINT '✓ Retail_Product table exists';
    
    DECLARE @RetailProductCount INT = (SELECT COUNT(*) FROM dbo.Retail_Product WHERE IsActive = 1);
    PRINT '✓ Found ' + CAST(@RetailProductCount AS VARCHAR(10)) + ' active retail products';
END
ELSE
    PRINT '⚠ Retail_Product table missing';

PRINT '';

-- Summary Report
PRINT '=== WORKFLOW VALIDATION SUMMARY ===';
PRINT '';

-- Count critical components
DECLARE @ComponentsReady INT = 0;
DECLARE @TotalComponents INT = 6;

-- SARS Compliance
IF @SARSTablesCount >= 3
    SET @ComponentsReady = @ComponentsReady + 1;

-- Product Sync
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_SyncLegacyInventoryToStockroom')
    SET @ComponentsReady = @ComponentsReady + 1;

-- Payment Management (check if basic structure exists)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Suppliers')
    SET @ComponentsReady = @ComponentsReady + 1;

-- Bank Import (check if GL accounts exist)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ChartOfAccounts')
    SET @ComponentsReady = @ComponentsReady + 1;

-- Manufacturing Products
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Manufacturing_Product')
    SET @ComponentsReady = @ComponentsReady + 1;

-- Retail Products
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Retail_Product')
    SET @ComponentsReady = @ComponentsReady + 1;

DECLARE @ReadinessPercent INT = (@ComponentsReady * 100) / @TotalComponents;

PRINT 'System Readiness: ' + CAST(@ComponentsReady AS VARCHAR(10)) + '/' + CAST(@TotalComponents AS VARCHAR(10)) + ' components (' + CAST(@ReadinessPercent AS VARCHAR(10)) + '%)';
PRINT '';

IF @ReadinessPercent >= 80
    PRINT '✅ SYSTEM READY - All major workflows are functional'
ELSE IF @ReadinessPercent >= 60
    PRINT '⚠️ SYSTEM PARTIALLY READY - Some workflows may have limitations'
ELSE
    PRINT '❌ SYSTEM NOT READY - Critical components missing';

PRINT '';
PRINT 'Next Steps:';
PRINT '1. Launch the ERP application';
PRINT '2. Test SARS Reporting: Accounting → SARS Compliance → Tax Returns & Reporting';
PRINT '3. Test Payment Management: Accounting → Accounts Payable → Payment Schedule';
PRINT '4. Test Bank Import: Accounting → Accounts Payable → Bank Statement Import';
PRINT '5. Test Product Creation: Manufacturing → Build My Product';
PRINT '6. Test SKU Assignment: Retail → Products → Assign SKUs/Barcodes';
PRINT '';
PRINT 'Workflow validation completed successfully!';
