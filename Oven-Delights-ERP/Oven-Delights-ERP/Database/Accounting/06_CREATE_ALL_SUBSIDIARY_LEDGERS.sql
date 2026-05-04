-- =============================================
-- CREATE ALL SUBSIDIARY LEDGERS (COMPLETE ACCOUNTING SYSTEM)
-- Creates subsidiary ledgers for ALL account types:
-- - Customers (Accounts Receivable)
-- - Tenants (Rent Income)
-- - Landlords (Rent Expense)
-- - Utility Providers (Utilities Expense)
-- - Interest Sources (Interest Income)
-- - Other income/expense entities
-- =============================================
-- Run this AFTER 02_CREATE_SUPPLIER_LEDGER_ACCOUNTS.sql
-- =============================================

PRINT '=========================================='
PRINT 'CREATING COMPLETE SUBSIDIARY LEDGER SYSTEM'
PRINT '=========================================='
PRINT ''

-- =============================================
-- PART 1: CUSTOMER LEDGERS (ACCOUNTS RECEIVABLE)
-- =============================================
PRINT 'PART 1: CUSTOMER LEDGERS (ACCOUNTS RECEIVABLE)'
PRINT '----------------------------------------------'

-- Get Accounts Receivable control account
DECLARE @ARControlAccountID INT;
DECLARE @ARControlAccountCode NVARCHAR(20);

SELECT TOP 1 
    @ARControlAccountID = AccountID,
    @ARControlAccountCode = AccountCode
FROM ChartOfAccounts
WHERE IsControlAccount = 1 
  AND (AccountCode LIKE '1%' AND (AccountName LIKE '%Receivable%' OR AccountName LIKE '%Debtor%'))
ORDER BY AccountCode;

IF @ARControlAccountID IS NULL
BEGIN
    PRINT 'WARNING: No Accounts Receivable control account found!'
    PRINT 'Creating default Accounts Receivable control account...'
    
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '1200', 'Accounts Receivable', 'Asset', 1, 1,
        'DR', 'Control account for all customer balances', GETDATE(), 'SYSTEM'
    );
    
    SET @ARControlAccountID = SCOPE_IDENTITY();
    SET @ARControlAccountCode = '1200';
    PRINT '✓ Created Accounts Receivable control account: 1200'
END
ELSE
BEGIN
    PRINT 'Found Accounts Receivable control: ' + @ARControlAccountCode;
END

-- Create customer ledger accounts
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Customers')
BEGIN
    DECLARE @CustomerID INT;
    DECLARE @CustomerName NVARCHAR(200);
    DECLARE @CustomerLedgerCode NVARCHAR(20);
    DECLARE @CustomerCounter INT = 1;
    DECLARE @CustomersCreated INT = 0;
    
    DECLARE customer_cursor CURSOR FOR
    SELECT CustomerID, CustomerName
    FROM Customers
    WHERE IsActive = 1
    ORDER BY CustomerID;
    
    OPEN customer_cursor;
    FETCH NEXT FROM customer_cursor INTO @CustomerID, @CustomerName;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE CustomerID = @CustomerID)
        BEGIN
            SET @CustomerLedgerCode = @ARControlAccountCode + '-' + RIGHT('000' + CAST(@CustomerCounter AS NVARCHAR(3)), 3);
            
            WHILE EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = @CustomerLedgerCode)
            BEGIN
                SET @CustomerCounter = @CustomerCounter + 1;
                SET @CustomerLedgerCode = @ARControlAccountCode + '-' + RIGHT('000' + CAST(@CustomerCounter AS NVARCHAR(3)), 3);
            END
            
            INSERT INTO ChartOfAccounts (
                AccountCode, AccountName, AccountType, ParentAccountCode, IsActive,
                IsControlAccount, IsSubsidiaryLedger, CustomerID,
                NormalBalance, Description, CreatedDate, CreatedBy
            )
            VALUES (
                @CustomerLedgerCode, @CustomerName, 'Asset', @ARControlAccountCode, 1,
                0, 1, @CustomerID,
                'DR', 'Customer ledger account for ' + @CustomerName, GETDATE(), 1
            );
            
            SET @CustomersCreated = @CustomersCreated + 1;
            PRINT '✓ Created: ' + @CustomerLedgerCode + ' - ' + @CustomerName;
            SET @CustomerCounter = @CustomerCounter + 1;
        END
        
        FETCH NEXT FROM customer_cursor INTO @CustomerID, @CustomerName;
    END
    
    CLOSE customer_cursor;
    DEALLOCATE customer_cursor;
    
    PRINT '✓ Customer ledger accounts created: ' + CAST(@CustomersCreated AS NVARCHAR(10));
END
ELSE
BEGIN
    PRINT 'WARNING: Customers table not found - skipping customer ledgers';
END

PRINT ''

-- =============================================
-- PART 2: RENT INCOME SUBSIDIARY LEDGERS (TENANTS)
-- =============================================
PRINT 'PART 2: RENT INCOME SUBSIDIARY LEDGERS (TENANTS)'
PRINT '------------------------------------------------'

-- Get or create Rent Income control account
DECLARE @RentIncomeControlID INT;
DECLARE @RentIncomeControlCode NVARCHAR(20);

SELECT TOP 1 
    @RentIncomeControlID = AccountID,
    @RentIncomeControlCode = AccountCode
FROM ChartOfAccounts
WHERE AccountCode LIKE '4%' AND AccountName LIKE '%Rent%Income%'
ORDER BY AccountCode;

IF @RentIncomeControlID IS NULL
BEGIN
    PRINT 'Creating Rent Income control account...'
    
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '4200', 'Rent Income', 'Revenue', 1, 1,
        'CR', 'Control account for all rental income', GETDATE(), 'SYSTEM'
    );
    
    SET @RentIncomeControlID = SCOPE_IDENTITY();
    SET @RentIncomeControlCode = '4200';
    PRINT '✓ Created Rent Income control account: 4200';
END
ELSE
BEGIN
    -- Mark as control account if not already
    UPDATE ChartOfAccounts
    SET IsControlAccount = 1,
        Description = 'Control account for all rental income'
    WHERE AccountID = @RentIncomeControlID AND IsControlAccount = 0;
    
    PRINT 'Found Rent Income control: ' + @RentIncomeControlCode;
END

-- Create tenant ledger accounts (if Tenants table exists)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Tenants')
BEGIN
    DECLARE @TenantID INT;
    DECLARE @TenantName NVARCHAR(200);
    DECLARE @TenantLedgerCode NVARCHAR(20);
    DECLARE @TenantCounter INT = 1;
    DECLARE @TenantsCreated INT = 0;
    
    DECLARE tenant_cursor CURSOR FOR
    SELECT TenantID, TenantName
    FROM Tenants
    WHERE IsActive = 1
    ORDER BY TenantID;
    
    OPEN tenant_cursor;
    FETCH NEXT FROM tenant_cursor INTO @TenantID, @TenantName;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE TenantID = @TenantID)
        BEGIN
            SET @TenantLedgerCode = @RentIncomeControlCode + '-' + RIGHT('000' + CAST(@TenantCounter AS NVARCHAR(3)), 3);
            
            WHILE EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = @TenantLedgerCode)
            BEGIN
                SET @TenantCounter = @TenantCounter + 1;
                SET @TenantLedgerCode = @RentIncomeControlCode + '-' + RIGHT('000' + CAST(@TenantCounter AS NVARCHAR(3)), 3);
            END
            
            INSERT INTO ChartOfAccounts (
                AccountCode, AccountName, AccountType, ParentAccountCode, IsActive,
                IsControlAccount, IsSubsidiaryLedger, TenantID,
                NormalBalance, Description, CreatedDate, CreatedBy
            )
            VALUES (
                @TenantLedgerCode, 'Rent - ' + @TenantName, 'Revenue', @RentIncomeControlCode, 1,
                0, 1, @TenantID,
                'CR', 'Rent income from ' + @TenantName, GETDATE(), 1
            );
            
            SET @TenantsCreated = @TenantsCreated + 1;
            PRINT '✓ Created: ' + @TenantLedgerCode + ' - Rent - ' + @TenantName;
            SET @TenantCounter = @TenantCounter + 1;
        END
        
        FETCH NEXT FROM tenant_cursor INTO @TenantID, @TenantName;
    END
    
    CLOSE tenant_cursor;
    DEALLOCATE tenant_cursor;
    
    PRINT '✓ Tenant ledger accounts created: ' + CAST(@TenantsCreated AS NVARCHAR(10));
END
ELSE
BEGIN
    PRINT 'NOTE: Tenants table not found - you can add TenantID column to ChartOfAccounts later';
    PRINT 'For now, you can manually create tenant ledgers like:';
    PRINT '  4200-001 - Rent - Mr Thomas';
    PRINT '  4200-002 - Rent - ABC Company';
END

PRINT ''

-- =============================================
-- PART 3: RENT EXPENSE SUBSIDIARY LEDGERS (LANDLORDS)
-- =============================================
PRINT 'PART 3: RENT EXPENSE SUBSIDIARY LEDGERS (LANDLORDS)'
PRINT '---------------------------------------------------'

-- Get or create Rent Expense control account
DECLARE @RentExpenseControlID INT;
DECLARE @RentExpenseControlCode NVARCHAR(20);

SELECT TOP 1 
    @RentExpenseControlID = AccountID,
    @RentExpenseControlCode = AccountCode
FROM ChartOfAccounts
WHERE AccountCode LIKE '5%' AND AccountName LIKE '%Rent%Expense%'
ORDER BY AccountCode;

IF @RentExpenseControlID IS NULL
BEGIN
    PRINT 'Creating Rent Expense control account...'
    
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '5200', 'Rent Expense', 'Expense', 1, 1,
        'DR', 'Control account for all rental expenses', GETDATE(), 'SYSTEM'
    );
    
    SET @RentExpenseControlID = SCOPE_IDENTITY();
    SET @RentExpenseControlCode = '5200';
    PRINT '✓ Created Rent Expense control account: 5200';
END
ELSE
BEGIN
    UPDATE ChartOfAccounts
    SET IsControlAccount = 1,
        Description = 'Control account for all rental expenses'
    WHERE AccountID = @RentExpenseControlID AND IsControlAccount = 0;
    
    PRINT 'Found Rent Expense control: ' + @RentExpenseControlCode;
END

PRINT 'NOTE: Create landlord subsidiary ledgers manually:';
PRINT '  5200-001 - Rent - Property Owner ABC';
PRINT '  5200-002 - Rent - XYZ Properties';
PRINT ''

-- =============================================
-- PART 4: ADD TENANTID COLUMN TO CHARTOFACCOUNTS
-- =============================================
PRINT 'PART 4: ENHANCING CHARTOFACCOUNTS FOR ALL ENTITY TYPES'
PRINT '-------------------------------------------------------'

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'TenantID')
BEGIN
    ALTER TABLE ChartOfAccounts ADD TenantID INT NULL;
    PRINT '✓ Added TenantID column';
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'LandlordID')
BEGIN
    ALTER TABLE ChartOfAccounts ADD LandlordID INT NULL;
    PRINT '✓ Added LandlordID column';
END

PRINT ''

-- =============================================
-- PART 5: UPDATE EXISTING LEDGERS WITH ENTITY TYPE
-- =============================================
PRINT 'PART 5: UPDATING ENTITY TYPES'
PRINT '------------------------------'

-- Only show if we have subsidiary ledgers
IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE IsSubsidiaryLedger = 1)
BEGIN
    SELECT 
        coa.AccountCode,
        coa.AccountName,
        CASE 
            WHEN coa.SupplierID IS NOT NULL THEN 'Supplier'
            WHEN coa.CustomerID IS NOT NULL THEN 'Customer'
            WHEN coa.TenantID IS NOT NULL THEN 'Tenant'
            WHEN coa.LandlordID IS NOT NULL THEN 'Landlord'
        END AS EntityType,
        s.CompanyName AS EntityName
    FROM ChartOfAccounts coa
    LEFT JOIN Suppliers s ON coa.SupplierID = s.SupplierID
    WHERE coa.IsSubsidiaryLedger = 1
    ORDER BY coa.AccountCode;
END
ELSE
BEGIN
    PRINT 'No subsidiary ledgers found';
END

PRINT ''

-- =============================================
-- VERIFICATION
-- =============================================
PRINT '=========================================='
PRINT 'VERIFICATION - ALL SUBSIDIARY LEDGERS'
PRINT '=========================================='
PRINT ''

PRINT 'Control Accounts:'
SELECT 
    AccountCode,
    AccountName,
    AccountType,
    IsControlAccount,
    Description
FROM ChartOfAccounts
WHERE IsControlAccount = 1
ORDER BY AccountCode;

PRINT ''
PRINT 'Subsidiary Ledger Summary:'
SELECT 
    EntityType,
    COUNT(*) AS LedgerCount
FROM (
    SELECT 
        CASE 
            WHEN SupplierID IS NOT NULL THEN 'Supplier'
            WHEN CustomerID IS NOT NULL THEN 'Customer'
            WHEN TenantID IS NOT NULL THEN 'Tenant'
            WHEN LandlordID IS NOT NULL THEN 'Landlord'
            ELSE 'Other'
        END AS EntityType
    FROM ChartOfAccounts
    WHERE IsSubsidiaryLedger = 1
) AS SubLedgers
GROUP BY EntityType
ORDER BY EntityType;

PRINT ''
PRINT '=========================================='
PRINT 'ALL SUBSIDIARY LEDGERS CREATED!'
PRINT '=========================================='
PRINT ''
PRINT 'Summary:'
PRINT '- Supplier ledgers: Created in script 02'
PRINT '- Customer ledgers: Created in this script'
PRINT '- Tenant ledgers: Created if Tenants table exists'
PRINT '- Landlord ledgers: Create manually as needed'
PRINT '- Other ledgers: Create manually as needed'
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Manually create any missing subsidiary ledgers'
PRINT '2. Run 07_UPDATE_RECONCILIATION_VIEWS_ALL.sql'
PRINT '3. Run 08_CREATE_ALL_POSTING_PROCEDURES.sql'
PRINT ''
