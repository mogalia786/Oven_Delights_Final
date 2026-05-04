-- =============================================
-- Printer Configuration System
-- Stores printer settings and form field positions
-- =============================================

-- Table 1: Printer Configuration (Till Slip & Continuous Form printers)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PrinterConfiguration')
BEGIN
    CREATE TABLE PrinterConfiguration (
        ConfigID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NULL, -- NULL = applies to all branches
        PrinterType NVARCHAR(50) NOT NULL, -- 'TillSlip' or 'ContinuousForm'
        PrinterName NVARCHAR(200) NOT NULL, -- Windows printer name
        PortName NVARCHAR(50) NULL, -- e.g., 'COM1', 'LPT1', 'USB001'
        PaperWidthMM INT NOT NULL, -- Paper width in millimeters
        PaperHeightMM INT NOT NULL, -- Paper height in millimeters
        IsDefault BIT DEFAULT 0,
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME DEFAULT GETDATE()
    );
    
    PRINT 'Table PrinterConfiguration created successfully.';
END
ELSE
BEGIN
    PRINT 'Table PrinterConfiguration already exists.';
END
GO

-- Table 2: Form Field Positions (for continuous forms)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FormFieldPositions')
BEGIN
    CREATE TABLE FormFieldPositions (
        FieldID INT IDENTITY(1,1) PRIMARY KEY,
        FormType NVARCHAR(50) NOT NULL, -- e.g., 'CustomOrder', 'Invoice', 'Receipt'
        FieldName NVARCHAR(100) NOT NULL, -- e.g., 'CustomerName', 'OrderNumber'
        FieldLabel NVARCHAR(100) NULL, -- Display label for setup UI
        XPositionMM DECIMAL(10,2) NOT NULL, -- X position from left edge in mm
        YPositionMM DECIMAL(10,2) NOT NULL, -- Y position from top edge in mm
        WidthMM DECIMAL(10,2) NULL, -- Field width (for boxes/rectangles)
        HeightMM DECIMAL(10,2) NULL, -- Field height (for boxes/rectangles)
        FontName NVARCHAR(50) DEFAULT 'Arial',
        FontSize INT DEFAULT 9,
        FontBold BIT DEFAULT 0,
        Alignment NVARCHAR(20) DEFAULT 'Left', -- 'Left', 'Center', 'Right'
        IsActive BIT DEFAULT 1,
        DisplayOrder INT DEFAULT 0, -- For UI ordering
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME DEFAULT GETDATE()
    );
    
    PRINT 'Table FormFieldPositions created successfully.';
END
ELSE
BEGIN
    PRINT 'Table FormFieldPositions already exists.';
END
GO

-- Insert default printer configurations
IF NOT EXISTS (SELECT * FROM PrinterConfiguration WHERE PrinterType = 'TillSlip')
BEGIN
    INSERT INTO PrinterConfiguration (BranchID, PrinterType, PrinterName, PortName, PaperWidthMM, PaperHeightMM, IsDefault, IsActive)
    VALUES (NULL, 'TillSlip', 'Default Till Printer', 'USB001', 80, 297, 1, 1);
    
    PRINT 'Default Till Slip printer configuration inserted.';
END
GO

IF NOT EXISTS (SELECT * FROM PrinterConfiguration WHERE PrinterType = 'ContinuousForm')
BEGIN
    INSERT INTO PrinterConfiguration (BranchID, PrinterType, PrinterName, PortName, PaperWidthMM, PaperHeightMM, IsDefault, IsActive)
    VALUES (NULL, 'ContinuousForm', 'Default Dot Matrix Printer', 'LPT1', 216, 279, 1, 1); -- 8.5" x 11"
    
    PRINT 'Default Continuous Form printer configuration inserted.';
END
GO

-- Insert default form field positions for Custom Order form
IF NOT EXISTS (SELECT * FROM FormFieldPositions WHERE FormType = 'CustomOrder')
BEGIN
    -- Customer Information Section
    INSERT INTO FormFieldPositions (FormType, FieldName, FieldLabel, XPositionMM, YPositionMM, WidthMM, HeightMM, FontSize, DisplayOrder)
    VALUES 
    ('CustomOrder', 'AccountNumber', 'Account Number', 16.5, 62.2, 60, 6, 9, 1),
    ('CustomOrder', 'CustomerName', 'Customer Name', 16.5, 68.6, 60, 6, 9, 2),
    ('CustomOrder', 'Telephone', 'Telephone', 16.5, 75.0, 60, 6, 9, 3),
    ('CustomOrder', 'CellNumber', 'Cell Number', 16.5, 81.3, 60, 6, 9, 4),
    
    -- Cake Details Section
    ('CustomOrder', 'CakeColour', 'Cake Colour', 119.4, 62.2, 60, 6, 9, 5),
    ('CustomOrder', 'CakePicture', 'Cake Picture', 119.4, 68.6, 60, 6, 9, 6),
    ('CustomOrder', 'CollectionDate', 'Collection Date', 119.4, 75.0, 60, 6, 9, 7),
    ('CustomOrder', 'CollectionDay', 'Collection Day', 119.4, 81.3, 60, 6, 9, 8),
    ('CustomOrder', 'CollectionTime', 'Collection Time', 119.4, 87.6, 60, 6, 9, 9),
    
    -- Order Header Section
    ('CustomOrder', 'CollectionPoint', 'Collection Point', 16.5, 96.5, 40, 6, 9, 10),
    ('CustomOrder', 'OrderNumber', 'Order Number', 61.0, 96.5, 40, 6, 9, 11),
    ('CustomOrder', 'OrderDate', 'Order Date', 101.6, 96.5, 30, 6, 9, 12),
    ('CustomOrder', 'OrderTakenBy', 'Order Taken By', 139.7, 96.5, 40, 6, 9, 13),
    
    -- Line Items Section (starting positions)
    ('CustomOrder', 'LineItem_Description', 'Item Description', 16.5, 109.2, 50, 6, 9, 14),
    ('CustomOrder', 'LineItem_Quantity', 'Quantity', 71.1, 109.2, 25, 6, 9, 15),
    ('CustomOrder', 'LineItem_UnitPrice', 'Unit Price', 101.6, 109.2, 25, 6, 9, 16),
    ('CustomOrder', 'LineItem_TotalPrice', 'Total Price', 152.4, 109.2, 25, 6, 9, 17),
    
    -- Totals Section
    ('CustomOrder', 'InvoiceTotal', 'Invoice Total', 152.4, 160.0, 25, 6, 9, 18),
    ('CustomOrder', 'DepositPaid', 'Deposit Paid', 152.4, 166.4, 25, 6, 9, 19),
    ('CustomOrder', 'BalanceOwing', 'Balance Owing', 152.4, 172.7, 25, 6, 9, 20);
    
    PRINT 'Default Custom Order form field positions inserted.';
END
GO

-- Create view for easy printer lookup
IF OBJECT_ID('v_ActivePrinters', 'V') IS NOT NULL
    DROP VIEW v_ActivePrinters;
GO

CREATE VIEW v_ActivePrinters AS
SELECT 
    pc.ConfigID,
    pc.BranchID,
    b.BranchName,
    pc.PrinterType,
    pc.PrinterName,
    pc.PortName,
    pc.PaperWidthMM,
    pc.PaperHeightMM,
    pc.IsDefault,
    pc.IsActive
FROM PrinterConfiguration pc
LEFT JOIN Branches b ON pc.BranchID = b.BranchID
WHERE pc.IsActive = 1;
GO

PRINT 'Printer Configuration System setup complete!';
