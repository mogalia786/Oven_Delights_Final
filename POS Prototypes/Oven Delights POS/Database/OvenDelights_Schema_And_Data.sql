-- Create the database (uncomment and run separately if needed)
-- CREATE DATABASE OvenDelightsDB;
-- GO

-- Use the database
USE OvenDelightsDB;
GO

-- Create Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(200) NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    Description NVARCHAR(1000),
    UnitPrice DECIMAL(10, 2) NOT NULL,
    CostPrice DECIMAL(10, 2) NOT NULL,
    Barcode NVARCHAR(50),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255),
    Phone NVARCHAR(20),
    Address NVARCHAR(500),
    JoinDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

-- Create Sales table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    SaleDate DATETIME DEFAULT GETDATE(),
    SubTotal DECIMAL(10, 2) NOT NULL,
    TaxAmount DECIMAL(10, 2) DEFAULT 0,
    DiscountAmount DECIMAL(10, 2) DEFAULT 0,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    PaymentMethod NVARCHAR(50),
    Status NVARCHAR(20) DEFAULT 'Completed',
    Notes NVARCHAR(1000)
);

-- Create SaleDetails table
CREATE TABLE SaleDetails (
    SaleDetailID INT PRIMARY KEY IDENTITY(1,1),
    SaleID INT FOREIGN KEY REFERENCES Sales(SaleID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    Discount DECIMAL(10, 2) DEFAULT 0,
    TotalPrice DECIMAL(10, 2) NOT NULL
);

-- Create Inventory table
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    QuantityInStock INT NOT NULL DEFAULT 0,
    LastStockUpdate DATETIME DEFAULT GETDATE(),
    ReorderLevel INT DEFAULT 10,
    LastRestockedDate DATETIME
);

-- Create InventoryTransactions table
CREATE TABLE InventoryTransactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    TransactionType NVARCHAR(20) NOT NULL, -- 'Purchase', 'Sale', 'Adjustment', 'Return'
    Quantity INT NOT NULL,
    TransactionDate DATETIME DEFAULT GETDATE(),
    ReferenceID INT, -- Could be SaleID, PurchaseOrderID, etc.
    ReferenceType NVARCHAR(50), -- 'Sale', 'Purchase', 'Adjustment'
    Notes NVARCHAR(1000)
);

-- Insert sample categories
INSERT INTO Categories (CategoryName, Description) VALUES
('Bread', 'Freshly baked breads and rolls'),
('Cakes', 'Delicious cakes for all occasions'),
('Pastries', 'Sweet and savory pastries'),
('Cookies', 'Assorted cookies and biscuits'),
('Desserts', 'Sweet treats and desserts');

-- Insert sample products
INSERT INTO Products (ProductName, CategoryID, Description, UnitPrice, CostPrice, Barcode) VALUES
('Sourdough Loaf', 1, 'Classic sourdough bread', 5.99, 2.50, 'BREAD001'),
('Whole Wheat Bread', 1, 'Healthy whole wheat bread', 4.99, 2.00, 'BREAD002'),
('Chocolate Cake', 2, 'Rich chocolate cake with buttercream', 24.99, 10.00, 'CAKE001'),
('Croissant', 3, 'Buttery French croissant', 2.99, 1.00, 'PAST001'),
('Chocolate Chip Cookie', 4, 'Classic chocolate chip cookie', 1.50, 0.50, 'COOK001'),
('Apple Pie', 5, 'Homemade apple pie', 12.99, 5.00, 'DESS001');

-- Insert sample customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES
('John', 'Smith', 'john.smith@email.com', '555-0123', '123 Bakery Lane, Breadville'),
('Sarah', 'Johnson', 'sarahj@email.com', '555-0456', '456 Pastry Street, Caketown'),
('Mike', 'Williams', 'mikew@email.com', '555-0789', '789 Cookie Road, Sweetcity');

-- Insert sample inventory
INSERT INTO Inventory (ProductID, QuantityInStock, ReorderLevel) VALUES
(1, 50, 10),  -- Sourdough Loaf
(2, 40, 10),  -- Whole Wheat Bread
(3, 15, 5),   -- Chocolate Cake
(4, 100, 20), -- Croissant
(5, 200, 50), -- Chocolate Chip Cookie
(6, 25, 5);   -- Apple Pie

-- Create a sample sale
DECLARE @SaleID INT;

-- Create sale header
INSERT INTO Sales (CustomerID, SubTotal, TaxAmount, TotalAmount, PaymentMethod, Status)
VALUES (1, 19.47, 1.56, 21.03, 'Credit Card', 'Completed');

SET @SaleID = SCOPE_IDENTITY();

-- Add sale details
INSERT INTO SaleDetails (SaleID, ProductID, Quantity, UnitPrice, TotalPrice)
VALUES 
(@SaleID, 1, 2, 5.99, 11.98),  -- 2 Sourdough Loaves
(@SaleID, 5, 5, 1.50, 7.49);    -- 5 Chocolate Chip Cookies

-- Update inventory for the sale
INSERT INTO InventoryTransactions (ProductID, TransactionType, Quantity, ReferenceID, ReferenceType)
VALUES 
(1, 'Sale', -2, @SaleID, 'Sale'),
(5, 'Sale', -5, @SaleID, 'Sale');

-- Update inventory quantities
UPDATE Inventory 
SET QuantityInStock = QuantityInStock - 2 
WHERE ProductID = 1;

UPDATE Inventory 
SET QuantityInStock = QuantityInStock - 5 
WHERE ProductID = 5;

-- Create views for common queries
GO
CREATE VIEW vw_ProductInventory AS
SELECT 
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.UnitPrice,
    i.QuantityInStock,
    i.ReorderLevel,
    CASE WHEN i.QuantityInStock <= i.ReorderLevel THEN 1 ELSE 0 END AS NeedsReorder
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Inventory i ON p.ProductID = i.ProductID
WHERE p.IsActive = 1;

GO
CREATE VIEW vw_SalesSummary AS
SELECT 
    s.SaleID,
    s.SaleDate,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    s.TotalAmount,
    s.PaymentMethod,
    s.Status,
    STRING_AGG(p.ProductName + ' (' + CAST(sd.Quantity AS VARCHAR) + ')', ', ') AS ItemsPurchased
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
JOIN SaleDetails sd ON s.SaleID = sd.SaleID
JOIN Products p ON sd.ProductID = p.ProductID
GROUP BY s.SaleID, s.SaleDate, c.FirstName, c.LastName, s.TotalAmount, s.PaymentMethod, s.Status;

-- Create stored procedures
GO
CREATE PROCEDURE sp_GetLowStockItems
AS
BEGIN
    SELECT * FROM vw_ProductInventory WHERE QuantityInStock <= ReorderLevel;
END;

GO
CREATE PROCEDURE sp_GetSalesByDateRange
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        CONVERT(DATE, s.SaleDate) AS SaleDate,
        COUNT(DISTINCT s.SaleID) AS TotalSales,
        SUM(s.TotalAmount) AS TotalRevenue,
        AVG(s.TotalAmount) AS AverageSaleAmount
    FROM Sales s
    WHERE CONVERT(DATE, s.SaleDate) BETWEEN @StartDate AND @EndDate
    GROUP BY CONVERT(DATE, s.SaleDate)
    ORDER BY SaleDate;
END;

-- Create index for better performance
CREATE INDEX IX_Products_CategoryID ON Products(CategoryID);
CREATE INDEX IX_Sales_CustomerID ON Sales(CustomerID);
CREATE INDEX IX_SaleDetails_SaleID ON SaleDetails(SaleID);
CREATE INDEX IX_Inventory_ProductID ON Inventory(ProductID);
CREATE INDEX IX_InventoryTransactions_ProductID ON InventoryTransactions(ProductID);
CREATE INDEX IX_InventoryTransactions_TransactionDate ON InventoryTransactions(TransactionDate);
