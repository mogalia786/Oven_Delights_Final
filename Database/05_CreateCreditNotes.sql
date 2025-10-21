/*
    05_CreateCreditNotes.sql
    Purpose: Create Credit Notes schema for returns to supplier, idempotently.
    - Tables: CreditNotes (header), CreditNoteLines (details)
    - Constraints, indexes, and guard trigger to prevent over-returns vs GRN lines
    - No data destructive operations. Safe to run multiple times.
*/

SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = N'CreditNotes' AND schema_id = SCHEMA_ID(N'dbo'))
BEGIN
    CREATE TABLE dbo.CreditNotes
    (
        CreditNoteID      INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CreditNotes PRIMARY KEY,
        CreditNoteNumber  VARCHAR(30) NOT NULL,
        SupplierID        INT NOT NULL,
        BranchID          INT NOT NULL,
        GRNID             INT NULL,
        PurchaseOrderID   INT NULL,
        CreditDate        DATE NOT NULL,
        TotalAmount       DECIMAL(18,2) NOT NULL CONSTRAINT DF_CreditNotes_TotalAmount DEFAULT(0),
        Status            NVARCHAR(20) NOT NULL CONSTRAINT DF_CreditNotes_Status DEFAULT(N'Draft'),
        Reason            NVARCHAR(255) NULL,
        Reference         NVARCHAR(50) NULL,
        Notes             NVARCHAR(255) NULL,
        CreatedDate       DATETIME2(0) NOT NULL CONSTRAINT DF_CreditNotes_CreatedDate DEFAULT (SYSUTCDATETIME()),
        CreatedBy         INT NOT NULL,
        IsPosted          BIT NOT NULL CONSTRAINT DF_CreditNotes_IsPosted DEFAULT(0),
        PostedDate        DATETIME2(0) NULL,
        PostedBy          INT NULL
    );

    CREATE UNIQUE INDEX UX_CreditNotes_Number ON dbo.CreditNotes (CreditNoteNumber);
END

/* Ensure Reason and Comments columns exist even if table already created */
IF COL_LENGTH('dbo.CreditNoteLines', 'Reason') IS NULL
    ALTER TABLE dbo.CreditNoteLines ADD Reason VARCHAR(30) NULL;

IF COL_LENGTH('dbo.CreditNoteLines', 'Comments') IS NULL
    ALTER TABLE dbo.CreditNoteLines ADD Comments NVARCHAR(255) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = N'CreditNoteLines' AND schema_id = SCHEMA_ID(N'dbo'))
BEGIN
    CREATE TABLE dbo.CreditNoteLines
    (
        CreditNoteLineID  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CreditNoteLines PRIMARY KEY,
        CreditNoteID      INT NOT NULL,
        GRNLineID         INT NULL,
        MaterialID        INT NOT NULL,
        ReturnQuantity    DECIMAL(18,4) NOT NULL,
        UnitCost          DECIMAL(18,4) NOT NULL,
        LineTotal         AS (CONVERT(DECIMAL(18,2), ReturnQuantity * UnitCost)) PERSISTED,
        Reason            VARCHAR(30) NULL,
        Comments          NVARCHAR(255) NULL
    );

    CREATE INDEX IX_CreditNoteLines_CreditNoteID ON dbo.CreditNoteLines (CreditNoteID);
    CREATE INDEX IX_CreditNoteLines_GRNLineID ON dbo.CreditNoteLines (GRNLineID) WHERE GRNLineID IS NOT NULL;
    CREATE INDEX IX_CreditNoteLines_MaterialID ON dbo.CreditNoteLines (MaterialID);
END

/* Foreign Keys - add if not present */
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CreditNotes_Suppliers')
    ALTER TABLE dbo.CreditNotes ADD CONSTRAINT FK_CreditNotes_Suppliers FOREIGN KEY (SupplierID) REFERENCES dbo.Suppliers(SupplierID);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CreditNotes_Branches')
    ALTER TABLE dbo.CreditNotes ADD CONSTRAINT FK_CreditNotes_Branches FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CreditNotes_GRN')
    ALTER TABLE dbo.CreditNotes ADD CONSTRAINT FK_CreditNotes_GRN FOREIGN KEY (GRNID) REFERENCES dbo.GoodsReceivedNotes(GRNID);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CreditNotes_PO')
    ALTER TABLE dbo.CreditNotes ADD CONSTRAINT FK_CreditNotes_PO FOREIGN KEY (PurchaseOrderID) REFERENCES dbo.PurchaseOrders(PurchaseOrderID);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CreditNotes_CreatedBy')
    ALTER TABLE dbo.CreditNotes ADD CONSTRAINT FK_CreditNotes_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CreditNotes_PostedBy')
    ALTER TABLE dbo.CreditNotes ADD CONSTRAINT FK_CreditNotes_PostedBy FOREIGN KEY (PostedBy) REFERENCES dbo.Users(UserID);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CreditNoteLines_Notes')
    ALTER TABLE dbo.CreditNoteLines ADD CONSTRAINT FK_CreditNoteLines_Notes FOREIGN KEY (CreditNoteID) REFERENCES dbo.CreditNotes(CreditNoteID) ON DELETE CASCADE;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CreditNoteLines_GRNLine')
    ALTER TABLE dbo.CreditNoteLines ADD CONSTRAINT FK_CreditNoteLines_GRNLine FOREIGN KEY (GRNLineID) REFERENCES dbo.GRNLines(GRNLineID);

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_CreditNoteLines_Material')
    ALTER TABLE dbo.CreditNoteLines ADD CONSTRAINT FK_CreditNoteLines_Material FOREIGN KEY (MaterialID) REFERENCES dbo.RawMaterials(MaterialID);

/* Guard trigger to prevent over-returns against GRN lines */
IF NOT EXISTS (SELECT 1 FROM sys.triggers WHERE name = N'trg_CreditNoteLines_PreventOverReturn')
EXEC ('
CREATE TRIGGER dbo.trg_CreditNoteLines_PreventOverReturn ON dbo.CreditNoteLines
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.GRNLineID IS NOT NULL AND EXISTS (
            SELECT 1
            FROM dbo.GRNLines gl
            WHERE gl.GRNLineID = i.GRNLineID
              AND (
                    (SELECT ISNULL(SUM(ReturnQuantity),0.0) FROM dbo.CreditNoteLines WHERE GRNLineID = i.GRNLineID)
                    > gl.ReceivedQuantity
                  )
        )
    )
    BEGIN
        RAISERROR (''Return quantity exceeds received quantity for one or more GRN lines.'', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
');

/* Helper view: Remaining returnable qty per GRN line */
IF NOT EXISTS (SELECT 1 FROM sys.views WHERE name = N'vw_GRNLine_ReturnableQty')
EXEC ('
CREATE VIEW dbo.vw_GRNLine_ReturnableQty AS
SELECT 
    gl.GRNLineID,
    gl.GRNID,
    gl.MaterialID,
    gl.ReceivedQuantity,
    ReturnQty = ISNULL((SELECT SUM(cnl.ReturnQuantity) FROM dbo.CreditNoteLines cnl WHERE cnl.GRNLineID = gl.GRNLineID), 0.0),
    RemainingQty = gl.ReceivedQuantity - ISNULL((SELECT SUM(cnl.ReturnQuantity) FROM dbo.CreditNoteLines cnl WHERE cnl.GRNLineID = gl.GRNLineID), 0.0)
FROM dbo.GRNLines gl;
');

GO
