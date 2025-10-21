-- Inter-Branch Transfer Schema (idempotent)
SET NOCOUNT ON;

IF OBJECT_ID('dbo.InterBranchTransferRequestHeader','U') IS NULL
BEGIN
    CREATE TABLE dbo.InterBranchTransferRequestHeader(
        RequestID INT IDENTITY(1,1) PRIMARY KEY,
        FromBranchID INT NOT NULL,
        ToBranchID INT NOT NULL,
        RequestDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        Status NVARCHAR(20) NOT NULL DEFAULT('Pending'), -- Pending|Approved|Rejected|Fulfilled|Cancelled
        RequestedBy INT NULL,
        Notes NVARCHAR(400) NULL
    );
END;

IF OBJECT_ID('dbo.InterBranchTransferRequestLine','U') IS NULL
BEGIN
    CREATE TABLE dbo.InterBranchTransferRequestLine(
        RequestLineID INT IDENTITY(1,1) PRIMARY KEY,
        RequestID INT NOT NULL,
        ProductID INT NOT NULL,
        VariantID INT NULL,
        Quantity DECIMAL(18,3) NOT NULL,
        Notes NVARCHAR(200) NULL,
        CONSTRAINT FK_IBTRL_Request FOREIGN KEY(RequestID) REFERENCES dbo.InterBranchTransferRequestHeader(RequestID)
    );
END;

IF OBJECT_ID('dbo.InterBranchTransferHeader','U') IS NULL
BEGIN
    CREATE TABLE dbo.InterBranchTransferHeader(
        TransferID INT IDENTITY(1,1) PRIMARY KEY,
        RequestID INT NULL,
        FromBranchID INT NOT NULL,
        ToBranchID INT NOT NULL,
        TransferDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        Status NVARCHAR(20) NOT NULL DEFAULT('Draft'), -- Draft|Posted|Cancelled
        INT_PO_Number NVARCHAR(40) NULL,
        INTER_INV_Number NVARCHAR(40) NULL,
        CreatedBy INT NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_IBTH_Request FOREIGN KEY(RequestID) REFERENCES dbo.InterBranchTransferRequestHeader(RequestID)
    );
END;

IF OBJECT_ID('dbo.InterBranchTransferLine','U') IS NULL
BEGIN
    CREATE TABLE dbo.InterBranchTransferLine(
        TransferLineID INT IDENTITY(1,1) PRIMARY KEY,
        TransferID INT NOT NULL,
        ProductID INT NOT NULL,
        VariantID INT NULL,
        Quantity DECIMAL(18,3) NOT NULL,
        UnitCost DECIMAL(18,4) NULL,
        Notes NVARCHAR(200) NULL,
        CONSTRAINT FK_IBTL_Transfer FOREIGN KEY(TransferID) REFERENCES dbo.InterBranchTransferHeader(TransferID)
    );
END;

PRINT 'Inter-Branch schema ensured.';
