-- =============================================
-- CREATE SUPPLIER LEDGER ACCOUNTS
-- Creates individual ledger account for each supplier
-- Format: 2100-XXX where XXX is sequential number
-- =============================================
-- Run this AFTER 01_ENHANCE_CHART_OF_ACCOUNTS.sql
-- =============================================

PRINT '=========================================='
PRINT 'CREATING SUPPLIER LEDGER ACCOUNTS'
PRINT '=========================================='
PRINT ''

-- Get the AccountID of the Accounts Payable control account
DECLARE @ControlAccountID INT;
DECLARE @ControlAccountCode NVARCHAR(20);

SELECT TOP 1 
    @ControlAccountID = AccountID,
    @ControlAccountCode = AccountCode
FROM ChartOfAccounts
WHERE IsControlAccount = 1 
  AND (AccountCode = '2100' OR AccountName LIKE '%Accounts Payable%' OR AccountName LIKE '%Creditors%')
ORDER BY AccountCode;

IF @ControlAccountID IS NULL
BEGIN
    PRINT 'ERROR: No Accounts Payable control account found!'
    PRINT 'Please run 01_ENHANCE_CHART_OF_ACCOUNTS.sql first'
    RETURN;
END

PRINT 'Control Account: ' + @ControlAccountCode + ' (AccountID: ' + CAST(@ControlAccountID AS NVARCHAR(10)) + ')'
PRINT ''

-- Check if Suppliers table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Suppliers')
BEGIN
    PRINT 'ERROR: Suppliers table does not exist!'
    PRINT 'Cannot create supplier ledger accounts without Suppliers table'
    RETURN;
END

-- Get count of suppliers
DECLARE @SupplierCount INT;
SELECT @SupplierCount = COUNT(*) FROM Suppliers WHERE IsActive = 1;
PRINT 'Found ' + CAST(@SupplierCount AS NVARCHAR(10)) + ' active suppliers'
PRINT ''

-- Create ledger accounts for suppliers that don't have one
DECLARE @SupplierID INT;
DECLARE @SupplierName NVARCHAR(200);
DECLARE @LedgerCode NVARCHAR(20);
DECLARE @Counter INT = 1;
DECLARE @Created INT = 0;
DECLARE @Skipped INT = 0;

DECLARE supplier_cursor CURSOR FOR
SELECT SupplierID, COALESCE(CompanyName, 'Supplier-' + CAST(SupplierID AS NVARCHAR(10)))
FROM Suppliers
WHERE IsActive = 1
ORDER BY SupplierID;

OPEN supplier_cursor;
FETCH NEXT FROM supplier_cursor INTO @SupplierID, @SupplierName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Check if supplier already has a ledger account
    IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE SupplierID = @SupplierID)
    BEGIN
        -- Generate ledger code (2100-001, 2100-002, etc.)
        SET @LedgerCode = @ControlAccountCode + '-' + RIGHT('000' + CAST(@Counter AS NVARCHAR(3)), 3);
        
        -- Ensure code is unique
        WHILE EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = @LedgerCode)
        BEGIN
            SET @Counter = @Counter + 1;
            SET @LedgerCode = @ControlAccountCode + '-' + RIGHT('000' + CAST(@Counter AS NVARCHAR(3)), 3);
        END
        
        -- Create the ledger account
        INSERT INTO ChartOfAccounts (
            AccountCode,
            AccountName,
            AccountType,
            ParentAccountCode,
            IsActive,
            IsControlAccount,
            IsSubsidiaryLedger,
            SupplierID,
            NormalBalance,
            Description,
            CreatedDate,
            CreatedBy
        )
        VALUES (
            @LedgerCode,
            @SupplierName,
            'Liability',
            @ControlAccountCode,
            1,
            0,
            1,
            @SupplierID,
            'CR',
            'Supplier ledger account for ' + @SupplierName,
            GETDATE(),
            1
        );
        
        SET @Created = @Created + 1;
        PRINT '✓ Created: ' + @LedgerCode + ' - ' + @SupplierName;
        
        SET @Counter = @Counter + 1;
    END
    ELSE
    BEGIN
        SET @Skipped = @Skipped + 1;
        -- Get existing ledger code for info
        SELECT @LedgerCode = AccountCode 
        FROM ChartOfAccounts 
        WHERE SupplierID = @SupplierID;
        
        PRINT '  Skipped: ' + @SupplierName + ' (already has account: ' + @LedgerCode + ')';
    END
    
    FETCH NEXT FROM supplier_cursor INTO @SupplierID, @SupplierName;
END

CLOSE supplier_cursor;
DEALLOCATE supplier_cursor;

PRINT ''
PRINT '=========================================='
PRINT 'SUMMARY'
PRINT '=========================================='
PRINT 'Supplier ledger accounts created: ' + CAST(@Created AS NVARCHAR(10))
PRINT 'Suppliers already with accounts: ' + CAST(@Skipped AS NVARCHAR(10))
PRINT 'Total suppliers processed: ' + CAST((@Created + @Skipped) AS NVARCHAR(10))
PRINT ''

-- Verification query
PRINT '=========================================='
PRINT 'VERIFICATION - SUPPLIER LEDGER ACCOUNTS'
PRINT '=========================================='
PRINT ''

SELECT 
    coa.AccountCode,
    coa.AccountName,
    s.SupplierID,
    s.SupplierName AS ActualSupplierName,
    coa.IsSubsidiaryLedger,
    coa.ControlAccountID,
    ctrl.AccountCode AS ControlAccountCode
FROM ChartOfAccounts coa
INNER JOIN Suppliers s ON coa.SupplierID = s.SupplierID
LEFT JOIN ChartOfAccounts ctrl ON coa.ControlAccountID = ctrl.AccountID
WHERE coa.IsSubsidiaryLedger = 1
ORDER BY coa.AccountCode;

PRINT ''
PRINT '=========================================='
PRINT 'SUPPLIER LEDGER ACCOUNTS CREATED!'
PRINT '=========================================='
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Run 03_FIX_AP_INVOICES_TABLE.sql'
PRINT '2. Run 04_CREATE_RECONCILIATION_VIEWS.sql'
PRINT '3. Run 05_CREATE_ACCOUNTING_PROCEDURES.sql'
PRINT ''
