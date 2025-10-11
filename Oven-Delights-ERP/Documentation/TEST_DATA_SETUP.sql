-- TEST DATA SETUP FOR ERP SYSTEM
-- Run this script to create test data for all modules

USE [Oven_Delights_Main]
GO

-- =============================================
-- 1. SUPPLIERS & INVOICES (for Supplier Payment)
-- =============================================

-- Insert test supplier if not exists
IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE SupplierCode = 'TEST001')
BEGIN
    INSERT INTO Suppliers (SupplierCode, CompanyName, ContactPerson, Email, Phone, IsActive, CreatedDate)
    VALUES ('TEST001', 'Test Supplier Ltd', 'John Doe', 'test@supplier.com', '0123456789', 1, GETDATE())
END

DECLARE @SupplierID INT = (SELECT SupplierID FROM Suppliers WHERE SupplierCode = 'TEST001')
DECLARE @BranchID INT = (SELECT TOP 1 BranchID FROM Branches WHERE IsActive = 1)

-- Insert test invoices with outstanding amounts
IF NOT EXISTS (SELECT 1 FROM SupplierInvoices WHERE InvoiceNumber = 'INV-TEST-001')
BEGIN
    INSERT INTO SupplierInvoices (
        InvoiceNumber, SupplierID, BranchID, InvoiceDate, DueDate, 
        SubTotal, VATAmount, TotalAmount, AmountPaid, AmountOutstanding, 
        Status, CreatedBy, CreatedDate
    )
    VALUES (
        'INV-TEST-001', @SupplierID, @BranchID, DATEADD(DAY, -30, GETDATE()), DATEADD(DAY, -10, GETDATE()),
        1000.00, 150.00, 1150.00, 0.00, 1150.00,
        'Open', 1, GETDATE()
    )
END

IF NOT EXISTS (SELECT 1 FROM SupplierInvoices WHERE InvoiceNumber = 'INV-TEST-002')
BEGIN
    INSERT INTO SupplierInvoices (
        InvoiceNumber, SupplierID, BranchID, InvoiceDate, DueDate, 
        SubTotal, VATAmount, TotalAmount, AmountPaid, AmountOutstanding, 
        Status, CreatedBy, CreatedDate
    )
    VALUES (
        'INV-TEST-002', @SupplierID, @BranchID, DATEADD(DAY, -20, GETDATE()), DATEADD(DAY, 10, GETDATE()),
        2000.00, 300.00, 2300.00, 500.00, 1800.00,
        'PartiallyPaid', 1, GETDATE()
    )
END

-- =============================================
-- 2. PRODUCTS & STOCK (for POS and Retail)
-- =============================================

-- Insert test product if not exists
IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'TEST-PROD-001')
BEGIN
    INSERT INTO Products (
        ProductCode, SKU, ProductName, ItemType, BaseUoM, IsActive, CreatedDate
    )
    VALUES (
        'TEST-PROD-001', 'SKU-TEST-001', 'Test Product for POS', 'External', 'ea', 1, GETDATE()
    )
END

DECLARE @ProductID INT = (SELECT ProductID FROM Products WHERE ProductCode = 'TEST-PROD-001')

-- Create variant if not exists
IF NOT EXISTS (SELECT 1 FROM Retail_Variant WHERE ProductID = @ProductID)
BEGIN
    INSERT INTO Retail_Variant (ProductID, VariantName, IsActive)
    VALUES (@ProductID, 'Default', 1)
END

DECLARE @VariantID INT = (SELECT VariantID FROM Retail_Variant WHERE ProductID = @ProductID)

-- Create stock record if not exists
IF NOT EXISTS (SELECT 1 FROM Retail_Stock WHERE VariantID = @VariantID AND BranchID = @BranchID)
BEGIN
    INSERT INTO Retail_Stock (VariantID, BranchID, QtyOnHand, AverageCost)
    VALUES (@VariantID, @BranchID, 100, 50.00)
END
ELSE
BEGIN
    UPDATE Retail_Stock 
    SET QtyOnHand = 100, AverageCost = 50.00
    WHERE VariantID = @VariantID AND BranchID = @BranchID
END

-- Create price record if not exists
IF NOT EXISTS (SELECT 1 FROM Retail_Price WHERE ProductID = @ProductID AND BranchID = @BranchID)
BEGIN
    INSERT INTO Retail_Price (ProductID, BranchID, SellingPrice, EffectiveFrom, IsActive)
    VALUES (@ProductID, @BranchID, 75.00, GETDATE(), 1)
END

-- =============================================
-- 3. RAW MATERIALS (for Stockroom)
-- =============================================

IF NOT EXISTS (SELECT 1 FROM RawMaterials WHERE MaterialCode = 'RM-TEST-001')
BEGIN
    INSERT INTO RawMaterials (
        MaterialCode, MaterialName, BaseUnit, CurrentStock, ReorderLevel, IsActive, CreatedDate
    )
    VALUES (
        'RM-TEST-001', 'Test Raw Material - Flour', 'kg', 500.00, 100.00, 1, GETDATE()
    )
END

-- =============================================
-- 4. CHART OF ACCOUNTS (for Ledger Posting)
-- =============================================

-- Ensure AP account exists
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2100')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('2100', 'Accounts Payable', 'Liability', 1)
END

-- Ensure Bank account exists
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1010')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('1010', 'Bank Account', 'Asset', 1)
END

-- Ensure Inventory account exists
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1300')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('1300', 'Inventory', 'Asset', 1)
END

-- Ensure Sales Revenue account exists
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4000')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('4000', 'Sales Revenue', 'Revenue', 1)
END

-- Ensure Cost of Sales account exists
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5000')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('5000', 'Cost of Sales', 'Expense', 1)
END

-- Ensure Inter-Branch Debtors account exists
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1210')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('1210', 'Inter-Branch Debtors', 'Asset', 1)
END

-- Ensure Inter-Branch Creditors account exists
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2200')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('2200', 'Inter-Branch Creditors', 'Liability', 1)
END

-- =============================================
-- 5. CATEGORIES & SUBCATEGORIES (for Manufacturing)
-- =============================================

IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryCode = 'TEST-CAT')
BEGIN
    INSERT INTO Categories (CategoryCode, CategoryName, IsActive)
    VALUES ('TEST-CAT', 'Test Category', 1)
END

DECLARE @CategoryID INT = (SELECT CategoryID FROM Categories WHERE CategoryCode = 'TEST-CAT')

IF NOT EXISTS (SELECT 1 FROM Subcategories WHERE SubcategoryCode = 'TEST-SUB')
BEGIN
    INSERT INTO Subcategories (SubcategoryCode, SubcategoryName, CategoryID, IsActive)
    VALUES ('TEST-SUB', 'Test Subcategory', @CategoryID, 1)
END

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

PRINT '========================================='
PRINT 'TEST DATA SETUP COMPLETE'
PRINT '========================================='
PRINT ''

PRINT 'Suppliers with Active Status:'
SELECT SupplierID, SupplierCode, CompanyName, IsActive FROM Suppliers WHERE IsActive = 1
PRINT ''

PRINT 'Outstanding Supplier Invoices:'
SELECT InvoiceID, InvoiceNumber, SupplierID, TotalAmount, AmountPaid, AmountOutstanding, Status 
FROM SupplierInvoices 
WHERE ISNULL(AmountOutstanding, TotalAmount) > 0
PRINT ''

PRINT 'Products with Stock:'
SELECT p.ProductID, p.ProductCode, p.ProductName, rs.QtyOnHand, rs.AverageCost
FROM Products p
INNER JOIN Retail_Variant rv ON rv.ProductID = p.ProductID
INNER JOIN Retail_Stock rs ON rs.VariantID = rv.VariantID
WHERE p.IsActive = 1
PRINT ''

PRINT 'Raw Materials:'
SELECT MaterialID, MaterialCode, MaterialName, CurrentStock, ReorderLevel
FROM RawMaterials
WHERE IsActive = 1
PRINT ''

PRINT 'Chart of Accounts:'
SELECT AccountID, AccountCode, AccountName, AccountType
FROM ChartOfAccounts
WHERE IsActive = 1
ORDER BY AccountCode
PRINT ''

PRINT '========================================='
PRINT 'Ready for testing!'
PRINT '========================================='
