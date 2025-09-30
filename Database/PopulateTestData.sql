-- Simple test data for RawMaterials and Products only

-- Insert test raw materials
INSERT INTO RawMaterials (MaterialCode, MaterialName, CategoryID, BaseUnit, CurrentStock, ReorderLevel, MaxStockLevel, StandardCost, LastCost, AverageCost, IsActive, CreatedDate, CreatedBy)
SELECT 'RM001', 'Flour - White Bread', 1, 'kg', 100.00, 50.00, 500.00, 25.50, 26.00, 25.75, 1, GETDATE(), 1
WHERE NOT EXISTS (SELECT 1 FROM RawMaterials WHERE MaterialCode = 'RM001')

INSERT INTO RawMaterials (MaterialCode, MaterialName, CategoryID, BaseUnit, CurrentStock, ReorderLevel, MaxStockLevel, StandardCost, LastCost, AverageCost, IsActive, CreatedDate, CreatedBy)
SELECT 'RM002', 'Sugar - Granulated', 1, 'kg', 75.00, 25.00, 300.00, 18.75, 19.00, 18.88, 1, GETDATE(), 1
WHERE NOT EXISTS (SELECT 1 FROM RawMaterials WHERE MaterialCode = 'RM002')

-- Insert test products
INSERT INTO Products (ProductCode, ProductName, CategoryID, ItemType)
SELECT 'PRD001', 'Chocolate Croissant', 1, 'External Product'
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PRD001')

INSERT INTO Products (ProductCode, ProductName, CategoryID, ItemType)
SELECT 'PRD002', 'Sourdough Bread Loaf', 1, 'External Product'
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PRD002')

-- Insert test supplier
INSERT INTO Suppliers (SupplierCode, CompanyName, IsActive, CreatedDate, CreatedBy)
SELECT 'SUP001', 'Test Supplier 1', 1, GETDATE(), 1
WHERE NOT EXISTS (SELECT 1 FROM Suppliers WHERE SupplierCode = 'SUP001')
