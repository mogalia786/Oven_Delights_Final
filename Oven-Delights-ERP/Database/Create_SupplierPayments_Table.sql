-- Create SupplierPayments table to track all payments made to suppliers

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SupplierPayments')
BEGIN
    CREATE TABLE dbo.SupplierPayments (
        PaymentID INT IDENTITY(1,1) PRIMARY KEY,
        PaymentNumber VARCHAR(50) NOT NULL,
        SupplierID INT NOT NULL,
        BranchID INT NOT NULL,
        PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
        PaymentMethod VARCHAR(50) NOT NULL, -- Cash, EFT, Cheque, etc.
        PaymentAmount DECIMAL(18,2) NOT NULL,
        Reference VARCHAR(100) NULL,
        CheckNumber VARCHAR(50) NULL,
        Notes NVARCHAR(500) NULL,
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_SupplierPayments_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
        CONSTRAINT FK_SupplierPayments_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    PRINT 'SupplierPayments table created successfully!';
    
    -- Create index for fast lookups
    CREATE INDEX IX_SupplierPayments_Supplier ON dbo.SupplierPayments(SupplierID, PaymentDate DESC);
    
    PRINT 'Index created on SupplierPayments table.';
END
ELSE
BEGIN
    PRINT 'SupplierPayments table already exists.';
END

GO

PRINT '';
PRINT 'SupplierPayments table is ready!';
PRINT 'Use this table to record all payments made to suppliers.';
PRINT '';
PRINT 'When a payment is made:';
PRINT '1. INSERT into SupplierPayments';
PRINT '2. UPDATE SupplierInvoices SET AmountPaid += @amount, AmountOutstanding -= @amount';
PRINT '3. CREATE journal entry: DR Accounts Payable, CR Bank';
