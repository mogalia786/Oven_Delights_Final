-- =============================================
-- RESET AND REMAP ALL BANK STATEMENT LEDGERS
-- Deactivates all existing mappings and creates fresh mappings
-- =============================================

SET NOCOUNT ON
GO

PRINT ''
PRINT '========================================='
PRINT 'RESETTING BANK STATEMENT MAPPINGS'
PRINT '========================================='
PRINT ''

-- =============================================
-- STEP 1: DEACTIVATE ALL EXISTING MAPPINGS
-- =============================================
PRINT 'Step 1: Deactivating all existing mappings...'

UPDATE BankStatementMappingRules
SET IsActive = 0
PRINT '✓ All existing mappings set to IsActive = 0'
PRINT ''

-- =============================================
-- STEP 2: DELETE OLD MAPPINGS (CLEAN SLATE)
-- =============================================
PRINT 'Step 2: Removing all old mappings...'

DELETE FROM BankStatementMappingRules
PRINT '✓ All old mappings deleted'
PRINT ''

-- =============================================
-- STEP 3: CREATE FRESH MAPPINGS - EXPENSES (DEBIT)
-- =============================================
PRINT 'Step 3: Creating fresh expense mappings...'
PRINT '-------------------------------------------'

-- Bank Charges & Fees: 6080
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('BANK CHARGES', '6080', 'Bank Charges & Fees', 1, 1, 1, GETDATE())
PRINT '✓ Bank Charges (6080)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('SERVICE FEE', '6080', 'Bank Charges & Fees', 2, 1, 1, GETDATE())
PRINT '✓ Service Fee (6080)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('BANK FEE', '6080', 'Bank Charges & Fees', 3, 1, 1, GETDATE())
PRINT '✓ Bank Fee (6080)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('MONTHLY FEE', '6080', 'Bank Charges & Fees', 4, 1, 1, GETDATE())
PRINT '✓ Monthly Fee (6080)'

-- Rent Expense: 6010
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('RENT', '6010', 'Rent Expense', 1, 1, 1, GETDATE())
PRINT '✓ Rent (6010)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('LEASE', '6010', 'Rent Expense', 2, 1, 1, GETDATE())
PRINT '✓ Lease (6010)'

-- Utilities - Electricity: 6020
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('ELECTRICITY', '6020', 'Utilities - Electricity', 1, 1, 1, GETDATE())
PRINT '✓ Electricity (6020)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('ESKOM', '6020', 'Utilities - Electricity', 2, 1, 1, GETDATE())
PRINT '✓ Eskom (6020)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('CITY POWER', '6020', 'Utilities - Electricity', 3, 1, 1, GETDATE())
PRINT '✓ City Power (6020)'

-- Utilities - Water: 6021
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('WATER', '6021', 'Utilities - Water', 1, 1, 1, GETDATE())
PRINT '✓ Water (6021)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('MUNICIPAL', '6021', 'Utilities - Water', 2, 1, 1, GETDATE())
PRINT '✓ Municipal (6021)'

-- Telephone & Internet: 6023
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('TELEPHONE', '6023', 'Telephone & Internet', 1, 1, 1, GETDATE())
PRINT '✓ Telephone (6023)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('INTERNET', '6023', 'Telephone & Internet', 2, 1, 1, GETDATE())
PRINT '✓ Internet (6023)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('VODACOM', '6023', 'Telephone & Internet', 3, 1, 1, GETDATE())
PRINT '✓ Vodacom (6023)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('MTN', '6023', 'Telephone & Internet', 4, 1, 1, GETDATE())
PRINT '✓ MTN (6023)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('TELKOM', '6023', 'Telephone & Internet', 5, 1, 1, GETDATE())
PRINT '✓ Telkom (6023)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('CELL C', '6023', 'Telephone & Internet', 6, 1, 1, GETDATE())
PRINT '✓ Cell C (6023)'

-- Salaries & Wages: 6030
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('SALARY', '6030', 'Salaries & Wages', 1, 1, 1, GETDATE())
PRINT '✓ Salary (6030)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('WAGES', '6030', 'Salaries & Wages', 2, 1, 1, GETDATE())
PRINT '✓ Wages (6030)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('PAYROLL', '6030', 'Salaries & Wages', 3, 1, 1, GETDATE())
PRINT '✓ Payroll (6030)'

-- Office Supplies: 6050
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('OFFICE SUPPLIES', '6050', 'Office Supplies', 1, 1, 1, GETDATE())
PRINT '✓ Office Supplies (6050)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('STATIONERY', '6050', 'Office Supplies', 2, 1, 1, GETDATE())
PRINT '✓ Stationery (6050)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('PRINTING', '6050', 'Office Supplies', 3, 1, 1, GETDATE())
PRINT '✓ Printing (6050)'

-- Insurance Expense: 6060
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('INSURANCE', '6060', 'Insurance Expense', 1, 1, 1, GETDATE())
PRINT '✓ Insurance (6060)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('PREMIUM', '6060', 'Insurance Expense', 2, 1, 1, GETDATE())
PRINT '✓ Premium (6060)'

-- Repairs & Maintenance: 6090
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('REPAIRS', '6090', 'Repairs & Maintenance', 1, 1, 1, GETDATE())
PRINT '✓ Repairs (6090)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('MAINTENANCE', '6090', 'Repairs & Maintenance', 2, 1, 1, GETDATE())
PRINT '✓ Maintenance (6090)'

-- Vehicle Fuel: 6100
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('FUEL', '6100', 'Vehicle Fuel', 1, 1, 1, GETDATE())
PRINT '✓ Fuel (6100)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('PETROL', '6100', 'Vehicle Fuel', 2, 1, 1, GETDATE())
PRINT '✓ Petrol (6100)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('DIESEL', '6100', 'Vehicle Fuel', 3, 1, 1, GETDATE())
PRINT '✓ Diesel (6100)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('ENGEN', '6100', 'Vehicle Fuel', 4, 1, 1, GETDATE())
PRINT '✓ Engen (6100)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('SHELL', '6100', 'Vehicle Fuel', 5, 1, 1, GETDATE())
PRINT '✓ Shell (6100)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('BP', '6100', 'Vehicle Fuel', 6, 1, 1, GETDATE())
PRINT '✓ BP (6100)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('SASOL', '6100', 'Vehicle Fuel', 7, 1, 1, GETDATE())
PRINT '✓ Sasol (6100)'

-- Interest Expense: 7010
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('INTEREST PAID', '7010', 'Interest Expense', 1, 1, 1, GETDATE())
PRINT '✓ Interest Paid (7010)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('LOAN', '7010', 'Interest Expense', 2, 1, 1, GETDATE())
PRINT '✓ Loan (7010)'

-- VAT Payable: 2030
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('VAT', '2030', 'VAT Payable', 1, 1, 1, GETDATE())
PRINT '✓ VAT (2030)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('SARS', '2030', 'VAT Payable', 2, 1, 1, GETDATE())
PRINT '✓ SARS (2030)'

PRINT ''

-- =============================================
-- STEP 4: CREATE FRESH MAPPINGS - INCOME (CREDIT)
-- =============================================
PRINT 'Step 4: Creating fresh income mappings...'
PRINT '------------------------------------------'

-- Sales Revenue: 4010
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('SALES', '4010', 'Sales Revenue', 1, 1, 1, GETDATE())
PRINT '✓ Sales (4010)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('POS', '4010', 'Sales Revenue', 2, 1, 1, GETDATE())
PRINT '✓ POS (4010)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('PAYMENT RECEIVED', '4010', 'Sales Revenue', 3, 1, 1, GETDATE())
PRINT '✓ Payment Received (4010)'

-- Interest Income: 4300
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('INTEREST RECEIVED', '4300', 'Interest Income', 1, 1, 1, GETDATE())
PRINT '✓ Interest Received (4300)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('INTEREST CREDIT', '4300', 'Interest Income', 2, 1, 1, GETDATE())
PRINT '✓ Interest Credit (4300)'

PRINT ''

-- =============================================
-- STEP 5: CREATE FRESH MAPPINGS - ASSET TRANSFERS
-- =============================================
PRINT 'Step 5: Creating asset transfer mappings...'
PRINT '--------------------------------------------'

-- Cash on Hand: 1030
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('CASH DEPOSIT', '1030', 'Cash on Hand', 1, 1, 1, GETDATE())
PRINT '✓ Cash Deposit (1030)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('ATM DEPOSIT', '1030', 'Cash on Hand', 2, 1, 1, GETDATE())
PRINT '✓ ATM Deposit (1030)'

INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('BRANCH DEPOSIT', '1030', 'Cash on Hand', 3, 1, 1, GETDATE())
PRINT '✓ Branch Deposit (1030)'

-- Petty Cash: 1020
INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy, CreatedDate)
VALUES ('PETTY CASH', '1020', 'Petty Cash', 1, 1, 1, GETDATE())
PRINT '✓ Petty Cash (1020)'

PRINT ''

-- =============================================
-- SUMMARY
-- =============================================
PRINT '========================================='
PRINT 'BANK STATEMENT MAPPING RESET COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'All old mappings deactivated and deleted'
PRINT 'Fresh mappings created for:'
PRINT ''
PRINT 'EXPENSES (Debit Transactions):'
PRINT '- 6080: Bank Charges & Fees'
PRINT '- 6010: Rent Expense'
PRINT '- 6020: Utilities - Electricity'
PRINT '- 6021: Utilities - Water'
PRINT '- 6023: Telephone & Internet'
PRINT '- 6030: Salaries & Wages'
PRINT '- 6050: Office Supplies'
PRINT '- 6060: Insurance Expense'
PRINT '- 6090: Repairs & Maintenance'
PRINT '- 6100: Vehicle Fuel'
PRINT '- 7010: Interest Expense'
PRINT '- 2030: VAT Payable'
PRINT ''
PRINT 'INCOME (Credit Transactions):'
PRINT '- 4010: Sales Revenue'
PRINT '- 4300: Interest Income'
PRINT ''
PRINT 'ASSET TRANSFERS:'
PRINT '- 1030: Cash on Hand'
PRINT '- 1020: Petty Cash'
PRINT ''
PRINT 'Bank account: 1010 (Bank Account - Current)'
PRINT ''
PRINT 'NOTE: Supplier payments and customer receipts'
PRINT 'will be matched to subsidiary ledgers first'
PRINT 'before falling back to these pattern mappings.'
PRINT ''
