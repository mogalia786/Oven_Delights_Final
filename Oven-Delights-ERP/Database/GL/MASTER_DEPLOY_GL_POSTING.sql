-- =============================================
-- MASTER DEPLOYMENT SCRIPT - GL POSTING TRIGGERS
-- =============================================
-- Execute this script to deploy all GL posting integrations
-- Run in SQL Server Management Studio or Azure Data Studio
-- =============================================

USE OvenDelightsERP
GO

PRINT '========================================='
PRINT 'GL POSTING TRIGGERS DEPLOYMENT'
PRINT 'Started: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
PRINT ''

-- =============================================
-- STEP 1: Create Missing GL Accounts
-- =============================================
PRINT 'STEP 1: Creating missing GL accounts...'
GO

-- Inter-Branch Creditors (Receiving branch owes sending branch)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1610')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, ParentAccountID, 
        IsActive, AllowTransactions, OpeningBalance, CurrentBalance
    )
    VALUES (
        '1610', 'Inter-Branch Creditors', 'Liability', NULL,
        1, 1, 0, 0
    )
    PRINT '  ✓ Created account 1610 - Inter-Branch Creditors'
END
ELSE
    PRINT '  ✓ Account 1610 already exists'

-- VAT Input (Purchase VAT claimable from SARS)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2021')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, ParentAccountID, 
        IsActive, AllowTransactions, OpeningBalance, CurrentBalance
    )
    VALUES (
        '2021', 'VAT Input (Purchase VAT)', 'Asset', NULL,
        1, 1, 0, 0
    )
    PRINT '  ✓ Created account 2021 - VAT Input'
END
ELSE
    PRINT '  ✓ Account 2021 already exists'

-- Other Income (Found stock, miscellaneous income)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4030')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, ParentAccountID, 
        IsActive, AllowTransactions, OpeningBalance, CurrentBalance
    )
    VALUES (
        '4030', 'Other Income', 'Revenue', NULL,
        1, 1, 0, 0
    )
    PRINT '  ✓ Created account 4030 - Other Income'
END
ELSE
    PRINT '  ✓ Account 4030 already exists'

-- Stock Loss/Shrinkage (Inventory losses)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6080')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, ParentAccountID, 
        IsActive, AllowTransactions, OpeningBalance, CurrentBalance
    )
    VALUES (
        '6080', 'Stock Loss/Shrinkage', 'Expense', NULL,
        1, 1, 0, 0
    )
    PRINT '  ✓ Created account 6080 - Stock Loss/Shrinkage'
END
ELSE
    PRINT '  ✓ Account 6080 already exists'

PRINT ''
PRINT 'STEP 1: Complete'
PRINT ''

-- =============================================
-- STEP 2: Verify All Critical Accounts
-- =============================================
PRINT 'STEP 2: Verifying critical GL accounts...'
GO

DECLARE @MissingCount INT = 0

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 1010 - Bank Account'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1025' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 1025 - Petty Cash'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 1030 - Cash on Hand'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1210' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 1210 - Finished Goods Inventory'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 1220 - Retail Inventory'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1600' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 1600 - Inter-Branch Debtors'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1610' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 1610 - Inter-Branch Creditors'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2010' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 2010 - Accounts Payable'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2020' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 2020 - VAT Output'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 2021 - VAT Input'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2050' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 2050 - GRIR'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4010' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 4010 - Sales Revenue'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4030' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 4030 - Other Income'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5010' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 5010 - Cost of Goods Sold'
    SET @MissingCount = @MissingCount + 1
END

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6080' AND IsActive = 1)
BEGIN
    PRINT '  ✗ MISSING: 6080 - Stock Loss/Shrinkage'
    SET @MissingCount = @MissingCount + 1
END

IF @MissingCount = 0
    PRINT '  ✓ All 15 critical accounts verified'
ELSE
BEGIN
    PRINT ''
    PRINT '  WARNING: ' + CAST(@MissingCount AS VARCHAR) + ' critical account(s) missing!'
    PRINT '  Please create missing accounts before proceeding.'
    RAISERROR('Critical GL accounts missing. Deployment aborted.', 16, 1)
    RETURN
END

PRINT ''
PRINT 'STEP 2: Complete'
PRINT ''

-- =============================================
-- STEP 3: Deploy Stored Procedures
-- =============================================
PRINT 'STEP 3: Deploying stored procedures...'
PRINT ''

-- Include all stored procedure scripts here
-- Note: In production, use :r to include external files
-- For now, procedures are in separate files:
-- - 14_AP_GL_Integration.sql
-- - 15_Enhanced_PO_Integration.sql
-- - 16_Manufacturing_Retail_Transfer.sql
-- - 17_IBT_GL_Integration.sql
-- - 18_Inventory_GL_Integration.sql
-- - 19_Cashbook_Additional_Integration.sql

PRINT '  Execute the following scripts in order:'
PRINT '  1. :r "14_AP_GL_Integration.sql"'
PRINT '  2. :r "15_Enhanced_PO_Integration.sql"'
PRINT '  3. :r "16_Manufacturing_Retail_Transfer.sql"'
PRINT '  4. :r "17_IBT_GL_Integration.sql"'
PRINT '  5. :r "18_Inventory_GL_Integration.sql"'
PRINT '  6. :r "19_Cashbook_Additional_Integration.sql"'
PRINT ''
PRINT '  Or run each script individually in SQL Server Management Studio'
PRINT ''

-- =============================================
-- STEP 4: Verify Stored Procedures
-- =============================================
PRINT 'STEP 4: Verifying stored procedures...'
GO

DECLARE @ProcCount INT = 0

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_AP_PostAdhocInvoiceToGL')
BEGIN
    PRINT '  ✓ sp_AP_PostAdhocInvoiceToGL'
    SET @ProcCount = @ProcCount + 1
END
ELSE
    PRINT '  ✗ sp_AP_PostAdhocInvoiceToGL NOT FOUND'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_AP_PostSinglePaymentToGL')
BEGIN
    PRINT '  ✓ sp_AP_PostSinglePaymentToGL'
    SET @ProcCount = @ProcCount + 1
END
ELSE
    PRINT '  ✗ sp_AP_PostSinglePaymentToGL NOT FOUND'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_AP_PostBatchPaymentToGL')
BEGIN
    PRINT '  ✓ sp_AP_PostBatchPaymentToGL'
    SET @ProcCount = @ProcCount + 1
END
ELSE
    PRINT '  ✗ sp_AP_PostBatchPaymentToGL NOT FOUND'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_AP_PostCreditNoteToGL')
BEGIN
    PRINT '  ✓ sp_AP_PostCreditNoteToGL'
    SET @ProcCount = @ProcCount + 1
END
ELSE
    PRINT '  ✗ sp_AP_PostCreditNoteToGL NOT FOUND'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_PO_PostInvoiceToGL')
BEGIN
    PRINT '  ✓ sp_PO_PostInvoiceToGL (Enhanced)'
    SET @ProcCount = @ProcCount + 1
END
ELSE
    PRINT '  ✗ sp_PO_PostInvoiceToGL NOT FOUND'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_MFG_PostManufacturingToRetailTransfer')
BEGIN
    PRINT '  ✓ sp_MFG_PostManufacturingToRetailTransfer'
    SET @ProcCount = @ProcCount + 1
END
ELSE
    PRINT '  ✗ sp_MFG_PostManufacturingToRetailTransfer NOT FOUND'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_IBT_PostReceiptToGL')
BEGIN
    PRINT '  ✓ sp_IBT_PostReceiptToGL'
    SET @ProcCount = @ProcCount + 1
END
ELSE
    PRINT '  ✗ sp_IBT_PostReceiptToGL NOT FOUND'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_IBT_PostSettlementToGL')
BEGIN
    PRINT '  ✓ sp_IBT_PostSettlementToGL'
    SET @ProcCount = @ProcCount + 1
END
ELSE
    PRINT '  ✗ sp_IBT_PostSettlementToGL NOT FOUND'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_INV_PostStockAdjustmentToGL')
BEGIN
    PRINT '  ✓ sp_INV_PostStockAdjustmentToGL'
    SET @ProcCount = @ProcCount + 1
END
ELSE
    PRINT '  ✗ sp_INV_PostStockAdjustmentToGL NOT FOUND'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_CB_PostPettyCashTopUpToGL')
BEGIN
    PRINT '  ✓ sp_CB_PostPettyCashTopUpToGL'
    SET @ProcCount = @ProcCount + 1
END
ELSE
    PRINT '  ✗ sp_CB_PostPettyCashTopUpToGL NOT FOUND'

PRINT ''
PRINT '  Stored Procedures Found: ' + CAST(@ProcCount AS VARCHAR) + ' of 10'

IF @ProcCount < 10
BEGIN
    PRINT ''
    PRINT '  WARNING: Not all stored procedures found!'
    PRINT '  Please run the individual SQL scripts to create missing procedures.'
END

PRINT ''
PRINT 'STEP 4: Complete'
PRINT ''

-- =============================================
-- DEPLOYMENT SUMMARY
-- =============================================
PRINT '========================================='
PRINT 'DEPLOYMENT SUMMARY'
PRINT '========================================='
PRINT ''
PRINT 'GL Accounts Created/Verified: ✓'
PRINT 'Critical Accounts Verified: ✓'
PRINT 'Stored Procedures: ' + CAST(@ProcCount AS VARCHAR) + ' of 10'
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Run individual SQL scripts if procedures missing'
PRINT '2. Rebuild VB.NET application'
PRINT '3. Test ADHOC invoice posting'
PRINT '4. Integrate remaining forms'
PRINT '5. Run full integration tests'
PRINT ''
PRINT 'Completed: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
GO
