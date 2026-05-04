-- =============================================
-- Create Bank Statement Keyword Mapping Table
-- Simple keyword-based account assignment
-- =============================================

-- Drop existing table if it exists
IF OBJECT_ID('BankStatementKeywordMapping', 'U') IS NOT NULL
    DROP TABLE BankStatementKeywordMapping;
GO

-- Create keyword mapping table
CREATE TABLE BankStatementKeywordMapping (
    MappingID INT IDENTITY(1,1) PRIMARY KEY,
    Keyword NVARCHAR(100) NOT NULL,
    TransactionType NVARCHAR(10) NOT NULL, -- 'Credit' or 'Debit'
    AccountCode NVARCHAR(10) NOT NULL,
    AccountName NVARCHAR(200) NOT NULL,
    Priority INT NOT NULL DEFAULT 100, -- Lower number = higher priority
    IsActive BIT NOT NULL DEFAULT 1,
    Notes NVARCHAR(500) NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT 'System'
);
GO

-- Insert keyword mappings with correct priorities
-- PRIORITY 1: Cash deposits and transfers (highest priority)
INSERT INTO BankStatementKeywordMapping (Keyword, TransactionType, AccountCode, AccountName, Priority, Notes)
VALUES 
    ('DEPOSIT', 'Credit', '1110', 'Cash on Hand', 10, 'Cash deposits to bank'),
    ('TD TO', 'Credit', '1110', 'Cash on Hand', 10, 'Transfers done to bank'),
    ('CASH DEPOSIT', 'Credit', '1110', 'Cash on Hand', 10, 'Cash deposits');

-- PRIORITY 2: Interest income
INSERT INTO BankStatementKeywordMapping (Keyword, TransactionType, AccountCode, AccountName, Priority, Notes)
VALUES 
    ('INTEREST', 'Credit', '4300', 'Interest Income', 20, 'Bank interest earned'),
    ('INT EARNED', 'Credit', '4300', 'Interest Income', 20, 'Interest earned');

-- PRIORITY 3: Supplier payments (invoice-based)
INSERT INTO BankStatementKeywordMapping (Keyword, TransactionType, AccountCode, AccountName, Priority, Notes)
VALUES 
    ('INV-', 'Debit', '2100', 'Accounts Payable', 30, 'Supplier invoice payments'),
    ('FNB OB PMT VODS', 'Debit', '2100', 'Accounts Payable', 30, 'Supplier payments via FNB');

-- PRIORITY 4: Customer receipts
INSERT INTO BankStatementKeywordMapping (Keyword, TransactionType, AccountCode, AccountName, Priority, Notes)
VALUES 
    ('FNB OB COLL', 'Credit', '1200', 'Accounts Receivable', 40, 'Customer collections'),
    ('FNB OB PMT', 'Credit', '1200', 'Accounts Receivable', 50, 'Customer payments (lower priority than deposits)');

-- PRIORITY 5: Bank charges and fees
INSERT INTO BankStatementKeywordMapping (Keyword, TransactionType, AccountCode, AccountName, Priority, Notes)
VALUES 
    ('BANK CHARGES', 'Debit', '6080', 'Bank Charges', 60, 'Bank fees'),
    ('BANK FEE', 'Debit', '6080', 'Bank Charges', 60, 'Bank fees'),
    ('SERVICE FEE', 'Debit', '6080', 'Bank Charges', 60, 'Service fees');

-- PRIORITY 6: Other expenses
INSERT INTO BankStatementKeywordMapping (Keyword, TransactionType, AccountCode, AccountName, Priority, Notes)
VALUES 
    ('RENT', 'Debit', '6010', 'Rent Expense', 70, 'Rent payments'),
    ('UTILITIES', 'Debit', '6020', 'Utilities Expense', 70, 'Utility payments'),
    ('ELECTRICITY', 'Debit', '6021', 'Electricity Expense', 70, 'Electricity bills'),
    ('WATER', 'Debit', '6022', 'Water Expense', 70, 'Water bills');

GO

-- Create index for faster lookups
CREATE NONCLUSTERED INDEX IX_BankStatementKeywordMapping_Keyword
ON BankStatementKeywordMapping (Keyword, TransactionType, Priority)
WHERE IsActive = 1;
GO

PRINT 'BankStatementKeywordMapping table created successfully';
PRINT '';
PRINT 'Sample query to view mappings:';
PRINT 'SELECT * FROM BankStatementKeywordMapping ORDER BY Priority, Keyword';
GO
