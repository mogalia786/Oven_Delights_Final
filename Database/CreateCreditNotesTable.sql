-- Create CreditNotes table for Invoice Capture module
IF OBJECT_ID('dbo.CreditNotes','U') IS NULL
BEGIN
    CREATE TABLE dbo.CreditNotes (
        CreditNoteID     INT IDENTITY(1,1) PRIMARY KEY,
        CreditNoteNumber NVARCHAR(20) NOT NULL UNIQUE,
        SupplierID       INT NOT NULL,
        MaterialID       INT NOT NULL,
        ReturnQuantity   DECIMAL(18,4) NOT NULL,
        UnitCost         DECIMAL(18,4) NOT NULL,
        TotalAmount      DECIMAL(18,4) NOT NULL,
        Reason           NVARCHAR(100) NOT NULL,
        Comments         NVARCHAR(500) NULL,
        Status           NVARCHAR(20) NOT NULL DEFAULT 'Pending',
        CreatedDate      DATETIME2 NOT NULL DEFAULT GETDATE(),
        CreatedBy        INT NOT NULL,
        ModifiedDate     DATETIME2 NULL,
        ModifiedBy       INT NULL,
        CONSTRAINT FK_CreditNotes_Supplier FOREIGN KEY (SupplierID) REFERENCES dbo.Suppliers(SupplierID),
        CONSTRAINT FK_CreditNotes_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_CreditNotes_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.Users(UserID)
    );
END;

-- Add Status column to PurchaseOrders if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.PurchaseOrders') AND name = 'Status')
BEGIN
    ALTER TABLE dbo.PurchaseOrders ADD Status NVARCHAR(20) NOT NULL DEFAULT 'Pending';
END;

-- Update existing PurchaseOrders to have 'Pending' status if NULL
UPDATE dbo.PurchaseOrders SET Status = 'Pending' WHERE Status IS NULL OR Status = '';
