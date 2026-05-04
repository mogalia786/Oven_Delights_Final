-- Create Chart of Accounts table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ChartOfAccounts')
BEGIN
    CREATE TABLE ChartOfAccounts (
        AccountID INT IDENTITY(1,1) PRIMARY KEY,
        AccountCode NVARCHAR(20) NOT NULL UNIQUE,
        AccountName NVARCHAR(100) NOT NULL,
        AccountType NVARCHAR(50) NOT NULL, -- Asset, Liability, Equity, Revenue, Expense
        ParentAccountCode NVARCHAR(20) NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        Description NVARCHAR(500) NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        UpdatedDate DATETIME NULL
    )
    
    CREATE INDEX IX_ChartOfAccounts_Code ON ChartOfAccounts(AccountCode)
    CREATE INDEX IX_ChartOfAccounts_Type ON ChartOfAccounts(AccountType)
    
    PRINT 'ChartOfAccounts table created successfully'
END
ELSE
BEGIN
    PRINT 'ChartOfAccounts table already exists'
END
GO

-- Insert standard Chart of Accounts
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts)
BEGIN
    -- ASSETS (1000-1999)
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType) VALUES
    ('1000', 'Assets', 'Asset'),
    ('1100', 'Current Assets', 'Asset'),
    ('1110', 'Cash and Bank', 'Asset'),
    ('1120', 'Accounts Receivable', 'Asset'),
    ('1130', 'Inter-Branch Receivables', 'Asset'),
    ('1200', 'Inventory', 'Asset'),
    ('1210', 'Raw Materials Inventory', 'Asset'),
    ('1220', 'Work in Progress', 'Asset'),
    ('1300', 'Finished Goods Inventory', 'Asset'),
    ('1310', 'Work in Progress', 'Asset'),
    ('1400', 'Fixed Assets', 'Asset'),
    ('1410', 'Equipment', 'Asset'),
    ('1420', 'Furniture & Fixtures', 'Asset'),
    ('1430', 'Accumulated Depreciation', 'Asset'),
    
    -- LIABILITIES (2000-2999)
    ('2000', 'Liabilities', 'Liability'),
    ('2100', 'Current Liabilities', 'Liability'),
    ('2110', 'Accounts Payable', 'Liability'),
    ('2120', 'Inter-Branch Payables', 'Liability'),
    ('2130', 'VAT Payable', 'Liability'),
    ('2140', 'Salaries Payable', 'Liability'),
    ('2200', 'Long-term Liabilities', 'Liability'),
    ('2210', 'Loans Payable', 'Liability'),
    
    -- EQUITY (3000-3999)
    ('3000', 'Equity', 'Equity'),
    ('3100', 'Capital', 'Equity'),
    ('3200', 'Retained Earnings', 'Equity'),
    ('3300', 'Current Year Earnings', 'Equity'),
    
    -- REVENUE (4000-4999)
    ('4000', 'Revenue', 'Revenue'),
    ('4100', 'Sales Revenue', 'Revenue'),
    ('4110', 'Retail Sales', 'Revenue'),
    ('4120', 'Wholesale Sales', 'Revenue'),
    ('4200', 'Other Income', 'Revenue'),
    
    -- EXPENSES (5000-5999)
    ('5000', 'Cost of Sales', 'Expense'),
    ('5100', 'Operating Expenses', 'Expense'),
    ('5110', 'Salaries & Wages', 'Expense'),
    ('5120', 'Rent', 'Expense'),
    ('5130', 'Utilities', 'Expense'),
    ('5140', 'Marketing & Advertising', 'Expense'),
    ('5150', 'Depreciation', 'Expense'),
    ('5160', 'Insurance', 'Expense'),
    ('5170', 'Repairs & Maintenance', 'Expense'),
    ('5180', 'Office Supplies', 'Expense'),
    ('5190', 'Bank Charges', 'Expense'),
    ('5200', 'Stock Adjustments', 'Expense')
    
    PRINT 'Chart of Accounts populated with standard accounts'
END
GO
