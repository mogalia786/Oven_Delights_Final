-- =============================================
-- Comprehensive Chart of Accounts for Manufacturing/Bakery Business
-- Standard GL Account Structure
-- =============================================

-- This script creates a complete chart of accounts following standard accounting principles
-- Account numbering: 1000-1999 Assets, 2000-2999 Liabilities, 3000-3999 Equity, 
--                    4000-4999 Revenue, 5000-5999 Expenses, 6000-6999 Cost of Sales

PRINT '=============================================='
PRINT 'Creating Comprehensive Chart of Accounts'
PRINT '=============================================='
PRINT ''

-- Insert accounts if they don't exist
-- ASSETS (1000-1999)
-- Current Assets (1000-1199)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1000')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1000', 'Cash on Hand', 'Asset', 'Cash', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1010')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1010', 'Petty Cash', 'Asset', 'Cash', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1100', 'Bank - Current Account', 'Asset', 'Bank', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1110')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1110', 'Bank - Savings Account', 'Asset', 'Bank', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1120')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1120', 'Bank - FNB Business Account', 'Asset', 'Bank', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1200', 'Accounts Receivable', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1210')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1210', 'Allowance for Doubtful Debts', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1300')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1300', 'Inventory - Raw Materials', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1310')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1310', 'Inventory - Work in Progress', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1320')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1320', 'Inventory - Finished Goods', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1330')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1330', 'Inventory - Packaging Materials', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1400')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1400', 'Prepaid Expenses', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1410')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1410', 'Prepaid Insurance', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1420')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1420', 'Prepaid Rent', 'Asset', NULL, 1, GETDATE())

-- Fixed Assets (1500-1799)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1500')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1500', 'Property - Land', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1510')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1510', 'Property - Buildings', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1520')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1520', 'Accumulated Depreciation - Buildings', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1600')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1600', 'Plant & Equipment - Ovens', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1610')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1610', 'Plant & Equipment - Mixers', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1620')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1620', 'Plant & Equipment - Refrigeration', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1630')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1630', 'Accumulated Depreciation - Equipment', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1700')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1700', 'Vehicles - Delivery Trucks', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1710')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1710', 'Accumulated Depreciation - Vehicles', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1800')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1800', 'Furniture & Fixtures', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1810')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1810', 'Computer Equipment', 'Asset', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1820')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('1820', 'Accumulated Depreciation - Furniture & Equipment', 'Asset', NULL, 1, GETDATE())

-- LIABILITIES (2000-2999)
-- Current Liabilities (2000-2299)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2000')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2000', 'Accounts Payable - Trade', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2100', 'Accounts Payable - General', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2110')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2110', 'Credit Card Payable', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2120')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2120', 'Customer Deposits', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2200', 'VAT Payable', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2210')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2210', 'PAYE Payable', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2220')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2220', 'UIF Payable', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2230')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2230', 'SDL Payable', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2240')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2240', 'Pension Fund Payable', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2250')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2250', 'Accrued Expenses', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2260')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2260', 'Accrued Salaries & Wages', 'Liability', NULL, 1, GETDATE())

-- Long-term Liabilities (2300-2499)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2300')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2300', 'Bank Loan - Long Term', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2310')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2310', 'Equipment Finance', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2320')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2320', 'Vehicle Finance', 'Liability', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2330')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('2330', 'Mortgage Payable', 'Liability', NULL, 1, GETDATE())

-- EQUITY (3000-3999)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '3000')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('3000', 'Owner''s Capital', 'Equity', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '3100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('3100', 'Owner''s Drawings', 'Equity', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '3200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('3200', 'Retained Earnings', 'Equity', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '3300')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('3300', 'Current Year Earnings', 'Equity', NULL, 1, GETDATE())

-- REVENUE (4000-4999)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4000')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('4000', 'Sales - Bread Products', 'Revenue', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4010')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('4010', 'Sales - Pastries', 'Revenue', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4020')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('4020', 'Sales - Cakes', 'Revenue', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4030')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('4030', 'Sales - Confectionery', 'Revenue', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4040')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('4040', 'Sales - Retail', 'Revenue', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4050')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('4050', 'Sales - Wholesale', 'Revenue', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('4100', 'Sales Returns & Allowances', 'Revenue', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('4200', 'Sales Discounts', 'Revenue', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4900')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('4900', 'Other Income', 'Revenue', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4910')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('4910', 'Interest Income', 'Revenue', NULL, 1, GETDATE())

-- COST OF SALES (5000-5999) - Changed to 6000 series to avoid conflict with expenses
-- EXPENSES (5000-5999)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5000')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5000', 'Operating Expenses', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5100', 'Salaries & Wages', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5110')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5110', 'Employee Benefits', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5120')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5120', 'Pension Contributions', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5130')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5130', 'UIF Contributions', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5140')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5140', 'SDL Contributions', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5200', 'Rent Expense', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5210')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5210', 'Property Rates & Taxes', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5300')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5300', 'Electricity', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5310')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5310', 'Water & Sewerage', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5320')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5320', 'Gas', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5400')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5400', 'Telephone & Internet', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5410')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5410', 'Postage & Courier', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5500')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5500', 'Insurance - General', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5510')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5510', 'Insurance - Vehicle', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5600')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5600', 'Repairs & Maintenance - Equipment', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5610')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5610', 'Repairs & Maintenance - Building', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5620')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5620', 'Repairs & Maintenance - Vehicles', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5700')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5700', 'Fuel & Oil', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5710')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5710', 'Vehicle License & Permits', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5800')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5800', 'Advertising & Marketing', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5810')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5810', 'Printing & Stationery', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5900')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5900', 'Bank Charges', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5910')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5910', 'Interest Expense', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5920')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5920', 'Professional Fees - Legal', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5930')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5930', 'Professional Fees - Accounting', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5940')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5940', 'Licenses & Permits', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5950')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5950', 'Depreciation Expense', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5960')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5960', 'Bad Debts', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5970')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5970', 'Cleaning & Sanitation', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5980')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5980', 'Security Services', 'Expense', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5990')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('5990', 'Miscellaneous Expenses', 'Expense', NULL, 1, GETDATE())

-- COST OF SALES (6000-6999)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6000')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('6000', 'Cost of Sales - Raw Materials', 'Cost of Sales', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6010')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('6010', 'Cost of Sales - Flour', 'Cost of Sales', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6020')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('6020', 'Cost of Sales - Sugar', 'Cost of Sales', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6030')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('6030', 'Cost of Sales - Dairy Products', 'Cost of Sales', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6040')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('6040', 'Cost of Sales - Eggs', 'Cost of Sales', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6050')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('6050', 'Cost of Sales - Yeast & Additives', 'Cost of Sales', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('6100', 'Cost of Sales - Packaging', 'Cost of Sales', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('6200', 'Cost of Sales - Direct Labor', 'Cost of Sales', NULL, 1, GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6300')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedDate)
    VALUES ('6300', 'Cost of Sales - Manufacturing Overhead', 'Cost of Sales', NULL, 1, GETDATE())

PRINT ''
PRINT '=============================================='
PRINT 'Chart of Accounts Created Successfully'
PRINT '=============================================='
PRINT ''
PRINT 'Account Summary:'
SELECT 
    AccountType,
    COUNT(*) AS AccountCount,
    MIN(AccountCode) AS FirstAccount,
    MAX(AccountCode) AS LastAccount
FROM ChartOfAccounts
GROUP BY AccountType
ORDER BY MIN(AccountCode)

PRINT ''
DECLARE @TotalCount INT = (SELECT COUNT(*) FROM ChartOfAccounts)
PRINT 'Total Accounts: ' + CAST(@TotalCount AS VARCHAR)
GO
