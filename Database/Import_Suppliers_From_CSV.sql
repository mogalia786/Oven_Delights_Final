-- =============================================
-- Import Suppliers from CSV Template
-- Run this after client sends back populated CSV
-- =============================================

-- Step 1: Create temporary staging table
IF OBJECT_ID('tempdb..#SupplierStaging') IS NOT NULL DROP TABLE #SupplierStaging;
CREATE TABLE #SupplierStaging (
    CompanyName NVARCHAR(150),
    ContactPerson NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Mobile NVARCHAR(20),
    Address NVARCHAR(200),
    City NVARCHAR(100),
    Province NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    VATNumber NVARCHAR(50),
    BankName NVARCHAR(100),
    BranchCode NVARCHAR(20),
    AccountNumber NVARCHAR(50),
    PaymentTerms NVARCHAR(50),
    CreditLimit DECIMAL(18,2),
    IsActive BIT,
    Notes NVARCHAR(500)
);

-- Step 2: Bulk insert from CSV
-- IMPORTANT: Update file path to actual location
BULK INSERT #SupplierStaging
FROM 'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\IMPORT_TEMPLATE_SUPPLIERS.csv'
WITH (
    FIRSTROW = 2,  -- Skip header row
    FIELDTERMINATOR = ' | ',  -- Pipe delimiter with spaces
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'  -- UTF-8
);

-- Step 3: Import Suppliers
INSERT INTO Suppliers (
    CompanyName,
    ContactPerson,
    Email,
    Phone,
    Mobile,
    Address,
    City,
    Province,
    PostalCode,
    Country,
    VATNumber,
    BankName,
    BranchCode,
    AccountNumber,
    PaymentTerms,
    CreditLimit,
    IsActive,
    Notes,
    CreatedDate
)
SELECT 
    CompanyName,
    ContactPerson,
    Email,
    Phone,
    Mobile,
    Address,
    City,
    Province,
    PostalCode,
    Country,
    VATNumber,
    BankName,
    BranchCode,
    AccountNumber,
    PaymentTerms,
    CreditLimit,
    IsActive,
    Notes,
    GETDATE()
FROM #SupplierStaging
WHERE CompanyName NOT IN (SELECT CompanyName FROM Suppliers WHERE CompanyName IS NOT NULL);

-- Step 4: Verification queries
PRINT '=== IMPORT SUMMARY ===';
PRINT 'Suppliers imported: ' + CAST((SELECT COUNT(*) FROM Suppliers) AS VARCHAR);
PRINT 'Active suppliers: ' + CAST((SELECT COUNT(*) FROM Suppliers WHERE IsActive = 1) AS VARCHAR);

-- Show imported suppliers
SELECT 
    SupplierID,
    CompanyName,
    ContactPerson,
    Email,
    Phone,
    PaymentTerms,
    CreditLimit,
    IsActive
FROM Suppliers
ORDER BY CompanyName;

-- Show suppliers by payment terms
SELECT 
    PaymentTerms,
    COUNT(*) AS SupplierCount,
    SUM(CreditLimit) AS TotalCreditLimit
FROM Suppliers
WHERE IsActive = 1
GROUP BY PaymentTerms
ORDER BY SupplierCount DESC;

-- Clean up
DROP TABLE #SupplierStaging;

PRINT 'Supplier import completed successfully!';
GO
