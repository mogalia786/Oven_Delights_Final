-- Comprehensive GRV (Goods Received Voucher) System
-- Proper control for receiving goods, matching to POs, and invoice processing

SET NOCOUNT ON;

-- Drop existing tables if they exist (in correct order)
IF OBJECT_ID('dbo.GRVLines','U') IS NOT NULL DROP TABLE dbo.GRVLines;
IF OBJECT_ID('dbo.GRVInvoiceMatching','U') IS NOT NULL DROP TABLE dbo.GRVInvoiceMatching;
IF OBJECT_ID('dbo.CreditNoteLines','U') IS NOT NULL DROP TABLE dbo.CreditNoteLines;
IF OBJECT_ID('dbo.CreditNotes','U') IS NOT NULL DROP TABLE dbo.CreditNotes;
IF OBJECT_ID('dbo.GoodsReceivedVouchers','U') IS NOT NULL DROP TABLE dbo.GoodsReceivedVouchers;

-- Main GRV Header Table
CREATE TABLE dbo.GoodsReceivedVouchers (
    GRVID INT IDENTITY(1,1) PRIMARY KEY,
    GRVNumber NVARCHAR(20) NOT NULL UNIQUE,
    PurchaseOrderID INT NOT NULL,
    SupplierID INT NOT NULL,
    BranchID INT NOT NULL,
    
    -- Delivery Information
    DeliveryNoteNumber NVARCHAR(50),
    DeliveryDate DATE,
    ReceivedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ReceivedBy INT NOT NULL,
    
    -- Status and Control
    Status NVARCHAR(20) NOT NULL DEFAULT 'Draft', -- Draft, Received, Matched, Invoiced, Closed
    IsFullyReceived BIT NOT NULL DEFAULT 0,
    
    -- Financial Totals
    SubTotal DECIMAL(18,2) NOT NULL DEFAULT 0,
    VATAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Audit Fields
    Notes NVARCHAR(1000),
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME,
    ModifiedBy INT,
    
    -- Constraints
    CONSTRAINT CK_GRV_Status CHECK (Status IN ('Draft', 'Received', 'Matched', 'Invoiced', 'Closed')),
    CONSTRAINT CK_GRV_Amounts CHECK (TotalAmount = SubTotal + VATAmount)
);

-- GRV Line Items
CREATE TABLE dbo.GRVLines (
    GRVLineID INT IDENTITY(1,1) PRIMARY KEY,
    GRVID INT NOT NULL,
    POLineID INT NOT NULL,
    
    -- Item Information
    MaterialID INT,
    ProductID INT,
    ItemType NVARCHAR(2) NOT NULL, -- 'RM' = Raw Material, 'PR' = Product
    
    -- Quantities and Costs
    OrderedQuantity DECIMAL(18,2) NOT NULL,
    ReceivedQuantity DECIMAL(18,2) NOT NULL,
    RejectedQuantity DECIMAL(18,2) NOT NULL DEFAULT 0,
    AcceptedQuantity AS (ReceivedQuantity - RejectedQuantity),
    
    UnitCost DECIMAL(18,2) NOT NULL,
    LineTotal AS (AcceptedQuantity * UnitCost),
    
    -- Quality Control
    QualityStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Passed, Failed, Partial
    QualityNotes NVARCHAR(500),
    QualityCheckedBy INT,
    QualityCheckedDate DATETIME,
    
    -- Rejection Information
    RejectionReason NVARCHAR(500),
    
    -- Audit
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    
    -- Foreign Keys
    FOREIGN KEY (GRVID) REFERENCES dbo.GoodsReceivedVouchers(GRVID),
    
    -- Constraints
    CONSTRAINT CK_GRVLine_ItemType CHECK (ItemType IN ('RM', 'PR')),
    CONSTRAINT CK_GRVLine_ItemExclusive CHECK (
        (ItemType = 'RM' AND MaterialID IS NOT NULL AND ProductID IS NULL) OR
        (ItemType = 'PR' AND ProductID IS NOT NULL AND MaterialID IS NULL)
    ),
    CONSTRAINT CK_GRVLine_Quantities CHECK (
        OrderedQuantity >= 0 AND 
        ReceivedQuantity >= 0 AND 
        RejectedQuantity >= 0 AND
        RejectedQuantity <= ReceivedQuantity
    ),
    CONSTRAINT CK_GRVLine_QualityStatus CHECK (QualityStatus IN ('Pending', 'Passed', 'Failed', 'Partial'))
);

-- GRV to Invoice Matching Table
CREATE TABLE dbo.GRVInvoiceMatching (
    MatchingID INT IDENTITY(1,1) PRIMARY KEY,
    GRVID INT NOT NULL,
    InvoiceID INT NOT NULL,
    GRVLineID INT,
    InvoiceLineID INT,
    
    -- Matching Details
    MatchedQuantity DECIMAL(18,2) NOT NULL,
    MatchedAmount DECIMAL(18,2) NOT NULL,
    VarianceQuantity DECIMAL(18,2) NOT NULL DEFAULT 0,
    VarianceAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Status
    MatchingStatus NVARCHAR(20) NOT NULL DEFAULT 'Matched', -- Matched, Variance, Disputed
    VarianceReason NVARCHAR(500),
    
    -- Audit
    MatchedDate DATETIME NOT NULL DEFAULT GETDATE(),
    MatchedBy INT NOT NULL,
    
    -- Foreign Keys
    FOREIGN KEY (GRVID) REFERENCES dbo.GoodsReceivedVouchers(GRVID),
    FOREIGN KEY (GRVLineID) REFERENCES dbo.GRVLines(GRVLineID),
    
    -- Constraints
    CONSTRAINT CK_GRVMatch_Status CHECK (MatchingStatus IN ('Matched', 'Variance', 'Disputed')),
    CONSTRAINT CK_GRVMatch_Quantities CHECK (MatchedQuantity >= 0)
);

-- Credit Notes Header
CREATE TABLE dbo.CreditNotes (
    CreditNoteID INT IDENTITY(1,1) PRIMARY KEY,
    CreditNoteNumber NVARCHAR(20) NOT NULL UNIQUE,
    
    -- References
    GRVID INT,
    InvoiceID INT,
    SupplierID INT NOT NULL,
    BranchID INT NOT NULL,
    
    -- Credit Information
    CreditType NVARCHAR(20) NOT NULL, -- 'Quality', 'Quantity', 'Pricing', 'Return', 'Other'
    CreditReason NVARCHAR(500) NOT NULL,
    
    -- Dates
    CreditDate DATE NOT NULL,
    RequestedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ApprovedDate DATETIME,
    ProcessedDate DATETIME,
    
    -- Status
    Status NVARCHAR(20) NOT NULL DEFAULT 'Requested', -- Requested, Approved, Processed, Rejected, Cancelled
    
    -- Financial
    SubTotal DECIMAL(18,2) NOT NULL DEFAULT 0,
    VATAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    -- Approval
    ApprovedBy INT,
    ApprovalNotes NVARCHAR(500),
    
    -- Audit
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME,
    ModifiedBy INT,
    
    -- Foreign Keys
    FOREIGN KEY (GRVID) REFERENCES dbo.GoodsReceivedVouchers(GRVID),
    
    -- Constraints
    CONSTRAINT CK_CN_Type CHECK (CreditType IN ('Quality', 'Quantity', 'Pricing', 'Return', 'Other')),
    CONSTRAINT CK_CN_Status CHECK (Status IN ('Requested', 'Approved', 'Processed', 'Rejected', 'Cancelled')),
    CONSTRAINT CK_CN_Amounts CHECK (TotalAmount = SubTotal + VATAmount)
);

-- Credit Note Lines
CREATE TABLE dbo.CreditNoteLines (
    CreditNoteLineID INT IDENTITY(1,1) PRIMARY KEY,
    CreditNoteID INT NOT NULL,
    GRVLineID INT,
    
    -- Item Information
    MaterialID INT,
    ProductID INT,
    ItemType NVARCHAR(2) NOT NULL,
    
    -- Credit Details
    CreditQuantity DECIMAL(18,2) NOT NULL,
    UnitCost DECIMAL(18,2) NOT NULL,
    LineTotal AS (CreditQuantity * UnitCost),
    
    -- Reason
    LineReason NVARCHAR(500),
    
    -- Audit
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    
    -- Foreign Keys
    FOREIGN KEY (CreditNoteID) REFERENCES dbo.CreditNotes(CreditNoteID),
    FOREIGN KEY (GRVLineID) REFERENCES dbo.GRVLines(GRVLineID),
    
    -- Constraints
    CONSTRAINT CK_CNLine_ItemType CHECK (ItemType IN ('RM', 'PR')),
    CONSTRAINT CK_CNLine_ItemExclusive CHECK (
        (ItemType = 'RM' AND MaterialID IS NOT NULL AND ProductID IS NULL) OR
        (ItemType = 'PR' AND ProductID IS NOT NULL AND MaterialID IS NULL)
    ),
    CONSTRAINT CK_CNLine_Quantity CHECK (CreditQuantity > 0)
);

-- Indexes for Performance
CREATE INDEX IX_GRV_PO ON dbo.GoodsReceivedVouchers(PurchaseOrderID);
CREATE INDEX IX_GRV_Supplier ON dbo.GoodsReceivedVouchers(SupplierID);
CREATE INDEX IX_GRV_Status ON dbo.GoodsReceivedVouchers(Status);
CREATE INDEX IX_GRV_Date ON dbo.GoodsReceivedVouchers(ReceivedDate);

CREATE INDEX IX_GRVLine_GRV ON dbo.GRVLines(GRVID);
CREATE INDEX IX_GRVLine_POLine ON dbo.GRVLines(POLineID);
CREATE INDEX IX_GRVLine_Material ON dbo.GRVLines(MaterialID) WHERE MaterialID IS NOT NULL;
CREATE INDEX IX_GRVLine_Product ON dbo.GRVLines(ProductID) WHERE ProductID IS NOT NULL;

CREATE INDEX IX_GRVMatch_GRV ON dbo.GRVInvoiceMatching(GRVID);
CREATE INDEX IX_GRVMatch_Invoice ON dbo.GRVInvoiceMatching(InvoiceID);

CREATE INDEX IX_CN_GRV ON dbo.CreditNotes(GRVID);
CREATE INDEX IX_CN_Supplier ON dbo.CreditNotes(SupplierID);
CREATE INDEX IX_CN_Status ON dbo.CreditNotes(Status);

PRINT 'Comprehensive GRV System created successfully';
