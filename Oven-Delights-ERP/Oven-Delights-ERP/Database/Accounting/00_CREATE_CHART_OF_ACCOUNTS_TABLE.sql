-- =============================================
-- CREATE CHART OF ACCOUNTS TABLE (BASE)
-- This is the foundation table for the entire accounting system
-- Run this FIRST before any other accounting scripts
-- =============================================

-- Drop foreign key constraint if exists (self-referencing)
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_ChartOfAccounts_Parent')
    ALTER TABLE ChartOfAccounts DROP CONSTRAINT FK_ChartOfAccounts_Parent;
GO

-- Drop table if exists (for clean install)
IF OBJECT_ID('ChartOfAccounts', 'U') IS NOT NULL
    DROP TABLE ChartOfAccounts;
GO

-- Create Chart of Accounts table
CREATE TABLE ChartOfAccounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    AccountCode NVARCHAR(20) NOT NULL UNIQUE,
    AccountName NVARCHAR(200) NOT NULL,
    AccountType NVARCHAR(50) NOT NULL, -- Asset, Liability, Equity, Revenue, Expense
    ParentAccountCode NVARCHAR(20) NULL, -- For hierarchical structure
    IsActive BIT NOT NULL DEFAULT 1,
    IsSubsidiaryLedger BIT NOT NULL DEFAULT 0, -- TRUE for individual supplier/customer accounts
    IsControlAccount BIT NOT NULL DEFAULT 0, -- TRUE for control accounts (e.g., 2100 - Accounts Payable)
    NormalBalance NVARCHAR(2) NULL, -- 'DR' for debit, 'CR' for credit
    
    -- Subsidiary Ledger Links
    SupplierID INT NULL, -- Links to Suppliers table
    CustomerID INT NULL, -- Links to Customers table
    TenantID INT NULL, -- Links to Tenants table (if applicable)
    LandlordID INT NULL, -- Links to Landlords table (if applicable)
    
    -- Additional Information
    Description NVARCHAR(500) NULL,
    TaxCode NVARCHAR(20) NULL,
    CurrencyCode NVARCHAR(10) DEFAULT 'ZAR',
    
    -- Audit Fields
    CreatedBy INT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedBy INT NULL,
    ModifiedDate DATETIME NULL,
    
    -- Constraints
    CONSTRAINT CK_AccountType CHECK (AccountType IN ('Asset', 'Liability', 'Equity', 'Revenue', 'Expense')),
    CONSTRAINT FK_ChartOfAccounts_Parent FOREIGN KEY (ParentAccountCode) REFERENCES ChartOfAccounts(AccountCode)
);
GO

-- Create indexes for performance
CREATE INDEX IX_ChartOfAccounts_AccountCode ON ChartOfAccounts(AccountCode);
CREATE INDEX IX_ChartOfAccounts_AccountType ON ChartOfAccounts(AccountType);
CREATE INDEX IX_ChartOfAccounts_ParentAccountCode ON ChartOfAccounts(ParentAccountCode);
CREATE INDEX IX_ChartOfAccounts_SupplierID ON ChartOfAccounts(SupplierID);
CREATE INDEX IX_ChartOfAccounts_CustomerID ON ChartOfAccounts(CustomerID);
GO

-- Insert main account categories (Level 1)
INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountCode, IsActive, IsSubsidiaryLedger, NormalBalance)
VALUES
    -- ASSETS (1000-1999) - Normal Balance: DEBIT
    ('1000', 'Assets', 'Asset', NULL, 1, 0, 'DR'),
    ('1100', 'Current Assets', 'Asset', '1000', 1, 0, 'DR'),
    ('1110', 'Cash on Hand', 'Asset', '1100', 1, 0, 'DR'),
    ('1120', 'Bank Account', 'Asset', '1100', 1, 0, 'DR'),
    ('1200', 'Accounts Receivable', 'Asset', '1100', 1, 0, 'DR'),
    ('1300', 'VAT Input', 'Asset', '1100', 1, 0, 'DR'),
    ('1400', 'Inventory', 'Asset', '1100', 1, 0, 'DR'),
    ('1500', 'Fixed Assets', 'Asset', '1000', 1, 0, 'DR'),
    ('1510', 'Equipment', 'Asset', '1500', 1, 0, 'DR'),
    ('1520', 'Vehicles', 'Asset', '1500', 1, 0, 'DR'),
    ('1530', 'Furniture & Fixtures', 'Asset', '1500', 1, 0, 'DR'),
    
    -- LIABILITIES (2000-2999) - Normal Balance: CREDIT
    ('2000', 'Liabilities', 'Liability', NULL, 1, 0, 'CR'),
    ('2100', 'Accounts Payable', 'Liability', '2000', 1, 0, 'CR'),
    ('2200', 'VAT Output', 'Liability', '2000', 1, 0, 'CR'),
    ('2300', 'Loans Payable', 'Liability', '2000', 1, 0, 'CR'),
    ('2400', 'Accrued Expenses', 'Liability', '2000', 1, 0, 'CR'),
    
    -- EQUITY (3000-3999) - Normal Balance: CREDIT
    ('3000', 'Equity', 'Equity', NULL, 1, 0, 'CR'),
    ('3100', 'Owner''s Equity', 'Equity', '3000', 1, 0, 'CR'),
    ('3200', 'Retained Earnings', 'Equity', '3000', 1, 0, 'CR'),
    ('3300', 'Current Year Earnings', 'Equity', '3000', 1, 0, 'CR'),
    
    -- REVENUE (4000-4999) - Normal Balance: CREDIT
    ('4000', 'Revenue', 'Revenue', NULL, 1, 0, 'CR'),
    ('4100', 'Sales Revenue', 'Revenue', '4000', 1, 0, 'CR'),
    ('4200', 'Service Revenue', 'Revenue', '4000', 1, 0, 'CR'),
    ('4300', 'Other Income', 'Revenue', '4000', 1, 0, 'CR'),
    ('4310', 'Interest Income', 'Revenue', '4300', 1, 0, 'CR'),
    ('4320', 'Rental Income', 'Revenue', '4300', 1, 0, 'CR'),
    
    -- EXPENSES (5000-5999) - Normal Balance: DEBIT
    ('5000', 'Expenses', 'Expense', NULL, 1, 0, 'DR'),
    ('5100', 'Cost of Goods Sold', 'Expense', '5000', 1, 0, 'DR'),
    ('5200', 'Operating Expenses', 'Expense', '5000', 1, 0, 'DR'),
    ('5210', 'Salaries & Wages', 'Expense', '5200', 1, 0, 'DR'),
    ('5220', 'Rent Expense', 'Expense', '5200', 1, 0, 'DR'),
    ('5230', 'Utilities', 'Expense', '5200', 1, 0, 'DR'),
    ('5240', 'Telephone & Internet', 'Expense', '5200', 1, 0, 'DR'),
    ('5250', 'Insurance', 'Expense', '5200', 1, 0, 'DR'),
    ('5260', 'Repairs & Maintenance', 'Expense', '5200', 1, 0, 'DR'),
    ('5270', 'Fuel & Transport', 'Expense', '5200', 1, 0, 'DR'),
    ('5280', 'Office Supplies', 'Expense', '5200', 1, 0, 'DR'),
    ('5290', 'Bank Charges', 'Expense', '5200', 1, 0, 'DR'),
    ('5300', 'Marketing & Advertising', 'Expense', '5000', 1, 0, 'DR'),
    ('5400', 'Professional Fees', 'Expense', '5000', 1, 0, 'DR'),
    ('5500', 'Depreciation', 'Expense', '5000', 1, 0, 'DR'),
    ('5600', 'Interest Expense', 'Expense', '5000', 1, 0, 'DR'),
    ('5700', 'Bad Debts', 'Expense', '5000', 1, 0, 'DR'),
    ('5800', 'Miscellaneous Expenses', 'Expense', '5000', 1, 0, 'DR');
GO

-- Mark Accounts Payable as control account
UPDATE ChartOfAccounts
SET IsControlAccount = 1,
    Description = 'Control account for all supplier balances'
WHERE AccountCode = '2100';
GO

PRINT '✓ ChartOfAccounts table created successfully';
PRINT '✓ Main account categories inserted';
PRINT '';
PRINT 'NEXT STEP: Run 01_ENHANCE_CHART_OF_ACCOUNTS.sql';
GO
