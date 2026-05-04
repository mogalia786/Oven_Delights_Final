-- Comprehensive Expense Categories for Accounts Payable System
-- This script creates/updates AP_Categories table with comprehensive expense types

-- Check if AP_Categories table exists, if not create it
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_Categories')
BEGIN
    CREATE TABLE AP_Categories (
        CategoryID INT IDENTITY(1,1) PRIMARY KEY,
        CategoryName NVARCHAR(100) NOT NULL UNIQUE,
        Description NVARCHAR(255),
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE()
    )
    PRINT 'AP_Categories table created'
END
ELSE
BEGIN
    PRINT 'AP_Categories table already exists'
END
GO

-- Clear existing categories (optional - comment out if you want to keep existing)
-- DELETE FROM AP_Categories
-- GO

-- Insert comprehensive expense categories using simple INSERT statements
-- (MERGE with IDENTITY_INSERT can cause issues, using INSERT instead)

-- First, check if categories already exist
IF NOT EXISTS (SELECT * FROM AP_Categories WHERE CategoryID = 1)
BEGIN
    SET IDENTITY_INSERT AP_Categories ON
    
    -- COST OF GOODS SOLD
    INSERT INTO AP_Categories (CategoryID, CategoryName, Description, IsActive) VALUES
    (1, 'Supplier Invoice', 'Supplier invoices for raw materials and inventory', 1),
    (2, 'Raw Materials', 'Raw materials and ingredients for production', 1),
    (3, 'Packaging Materials', 'Packaging, boxes, bags, labels', 1),
    (4, 'Freight & Delivery', 'Freight, shipping, and delivery costs', 1)
    
    -- OPERATING EXPENSES
    INSERT INTO AP_Categories (CategoryID, CategoryName, Description, IsActive) VALUES
    (10, 'Rent & Lease', 'Rent, lease payments for premises', 1),
    (11, 'Utilities', 'Electricity, water, gas, sewage', 1),
    (12, 'Telephone & Internet', 'Phone, internet, data services', 1),
    (13, 'Insurance', 'Business insurance, liability, property', 1),
    (14, 'Security Services', 'Security guards, alarm monitoring', 1),
    (15, 'Cleaning & Sanitation', 'Cleaning services, sanitation supplies', 1),
    (16, 'Waste Removal', 'Garbage collection, waste disposal', 1)
    
    -- EMPLOYEE RELATED
    INSERT INTO AP_Categories (CategoryID, CategoryName, Description, IsActive) VALUES
    (20, 'Salaries & Wages', 'Employee salaries and wages', 1),
    (21, 'UIF Contributions', 'Unemployment Insurance Fund contributions', 1),
    (22, 'PAYE', 'Pay As You Earn tax deductions', 1),
    (23, 'Medical Aid', 'Employee medical aid contributions', 1),
    (24, 'Pension Fund', 'Pension and provident fund contributions', 1),
    (25, 'Staff Training', 'Employee training and development', 1),
    (26, 'Staff Uniforms', 'Employee uniforms and protective gear', 1),
    (27, 'Staff Welfare', 'Staff meals, refreshments, welfare', 1),
    (28, 'Recruitment', 'Recruitment and hiring costs', 1)
    
    -- EQUIPMENT & MAINTENANCE
    INSERT INTO AP_Categories (CategoryID, CategoryName, Description, IsActive) VALUES
    (30, 'Equipment Purchase', 'Purchase of equipment and machinery', 1),
    (31, 'Equipment Rental', 'Equipment rental and leasing', 1),
    (32, 'Equipment Maintenance', 'Equipment repairs and maintenance', 1),
    (33, 'Vehicle Expenses', 'Vehicle fuel, maintenance, repairs', 1),
    (34, 'Vehicle Insurance', 'Vehicle insurance and licensing', 1),
    (35, 'IT Equipment', 'Computers, printers, IT hardware', 1),
    (36, 'IT Support', 'IT support, software licenses', 1)
    
    -- MARKETING & SALES
    INSERT INTO AP_Categories (CategoryID, CategoryName, Description, IsActive) VALUES
    (40, 'Advertising', 'Advertising and marketing campaigns', 1),
    (41, 'Promotions', 'Promotional materials and events', 1),
    (42, 'Social Media', 'Social media marketing and management', 1),
    (43, 'Website', 'Website hosting, domain, maintenance', 1),
    (44, 'Printing & Stationery', 'Business cards, flyers, stationery', 1),
    (45, 'Signage', 'Shop signage and displays', 1)
    
    -- PROFESSIONAL SERVICES
    INSERT INTO AP_Categories (CategoryID, CategoryName, Description, IsActive) VALUES
    (50, 'Accounting Fees', 'Accountant and bookkeeping fees', 1),
    (51, 'Legal Fees', 'Legal services and consultation', 1),
    (52, 'Consulting Fees', 'Business consulting and advisory', 1),
    (53, 'Audit Fees', 'External audit fees', 1),
    (54, 'Bank Charges', 'Bank fees, transaction charges', 1),
    (55, 'Merchant Fees', 'Card payment processing fees', 1)
    
    -- LICENSES & COMPLIANCE
    INSERT INTO AP_Categories (CategoryID, CategoryName, Description, IsActive) VALUES
    (60, 'Business Licenses', 'Business licenses and permits', 1),
    (61, 'Health Certificates', 'Health and safety certificates', 1),
    (62, 'CIPC Fees', 'CIPC annual returns and fees', 1),
    (63, 'Municipal Rates', 'Municipal rates and taxes', 1)
    
    -- OFFICE & ADMIN
    INSERT INTO AP_Categories (CategoryID, CategoryName, Description, IsActive) VALUES
    (70, 'Office Supplies', 'Office supplies and consumables', 1),
    (71, 'Postage & Courier', 'Postage, courier, delivery services', 1),
    (72, 'Subscriptions', 'Magazine, software subscriptions', 1),
    (73, 'Entertainment', 'Client entertainment and hospitality', 1),
    (74, 'Travel', 'Business travel and accommodation', 1),
    (75, 'Petty Cash', 'Petty cash expenses', 1)
    
    -- PROPERTY & FACILITIES
    INSERT INTO AP_Categories (CategoryID, CategoryName, Description, IsActive) VALUES
    (80, 'Building Maintenance', 'Building repairs and maintenance', 1),
    (81, 'Renovations', 'Building renovations and improvements', 1),
    (82, 'Furniture & Fixtures', 'Furniture and fixtures', 1),
    (83, 'Property Taxes', 'Property taxes and assessments', 1)
    
    -- FINANCIAL
    INSERT INTO AP_Categories (CategoryID, CategoryName, Description, IsActive) VALUES
    (90, 'Interest Expense', 'Interest on loans and overdrafts', 1),
    (91, 'Loan Repayment', 'Loan principal repayments', 1),
    (92, 'Bad Debts', 'Bad debts written off', 1),
    (93, 'Donations', 'Charitable donations', 1)
    
    -- OTHER
    INSERT INTO AP_Categories (CategoryID, CategoryName, Description, IsActive) VALUES
    (99, 'Miscellaneous', 'Miscellaneous expenses', 1),
    (100, 'Other', 'Other uncategorized expenses', 1)
    
    SET IDENTITY_INSERT AP_Categories OFF
    
    PRINT 'Comprehensive expense categories inserted successfully!'
END
ELSE
BEGIN
    PRINT 'Categories already exist. Skipping insert.'
END
GO

-- Display all categories
SELECT 
    CategoryID,
    CategoryName,
    Description,
    IsActive
FROM AP_Categories
ORDER BY CategoryID
GO

-- Display total count
DECLARE @TotalCount INT
SELECT @TotalCount = COUNT(*) FROM AP_Categories
PRINT 'Total categories: ' + CAST(@TotalCount AS VARCHAR(10))
GO
