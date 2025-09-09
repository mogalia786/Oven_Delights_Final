/*
06_CreateInvoicePO_Link.sql
Purpose: Ensure there is a strong, enforced relationship between Invoices and PurchaseOrders.
- If Invoices.POID exists: create a proper FOREIGN KEY and supporting index
- Else: create a simple link table InvoicePOMap (InvoiceID, POID) with PK and FKs

Run safely multiple times: guarded by IF NOT EXISTS checks
*/

SET NOCOUNT ON;

-- 1) Ensure base tables exist (no-op if already present)
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invoices]') AND type = N'U')
BEGIN
    RAISERROR('Table [dbo].[Invoices] not found. Create it first before applying this link script.', 10, 1);
END
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PurchaseOrders]') AND type = N'U')
BEGIN
    RAISERROR('Table [dbo].[PurchaseOrders] not found. Create it first before applying this link script.', 10, 1);
END

-- 2) If Invoices has a PurchaseOrderID or POID column, attach a FOREIGN KEY to PurchaseOrders(PurchaseOrderID)
DECLARE @InvoicePOLinkCol sysname;
IF EXISTS (
    SELECT 1
    FROM sys.columns c
    INNER JOIN sys.objects o ON o.object_id = c.object_id
    WHERE o.name = 'Invoices' AND o.type = 'U' AND c.name = 'PurchaseOrderID'
)
    SET @InvoicePOLinkCol = 'PurchaseOrderID';
ELSE IF EXISTS (
    SELECT 1
    FROM sys.columns c
    INNER JOIN sys.objects o ON o.object_id = c.object_id
    WHERE o.name = 'Invoices' AND o.type = 'U' AND c.name = 'POID'
)
    SET @InvoicePOLinkCol = 'POID';

IF @InvoicePOLinkCol IS NOT NULL
BEGIN
    -- Add an index on Invoices.POID if missing
    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes WHERE name = 'IX_Invoices_PO_Link' AND object_id = OBJECT_ID(N'[dbo].[Invoices]')
    )
    BEGIN
        DECLARE @sqlCreateIdx nvarchar(max) = N'CREATE INDEX IX_Invoices_PO_Link ON dbo.Invoices(' + QUOTENAME(@InvoicePOLinkCol) + N');';
        EXEC(@sqlCreateIdx);
    END

    -- Add the FK if missing
    IF NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Invoices_PurchaseOrders_PO_Link'
    )
    BEGIN
        DECLARE @sqlAddFK nvarchar(max) = N'ALTER TABLE dbo.Invoices WITH CHECK ADD CONSTRAINT FK_Invoices_PurchaseOrders_PO_Link FOREIGN KEY (' + QUOTENAME(@InvoicePOLinkCol) + N') REFERENCES dbo.PurchaseOrders(PurchaseOrderID);';
        EXEC(@sqlAddFK);

        ALTER TABLE dbo.Invoices CHECK CONSTRAINT FK_Invoices_PurchaseOrders_PO_Link;
    END
END
ELSE
BEGIN
    -- 3) Fallback: create simple link table InvoicePOMap (InvoiceID, POID)
    IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePOMap]') AND type = N'U')
    BEGIN
        CREATE TABLE dbo.InvoicePOMap
        (
            InvoiceID INT NOT NULL,
            PurchaseOrderID INT NOT NULL,
            CONSTRAINT PK_InvoicePOMap PRIMARY KEY (InvoiceID, PurchaseOrderID),
            CONSTRAINT FK_InvoicePOMap_Invoices       FOREIGN KEY (InvoiceID) REFERENCES dbo.Invoices(InvoiceID),
            CONSTRAINT FK_InvoicePOMap_PurchaseOrders FOREIGN KEY (PurchaseOrderID) REFERENCES dbo.PurchaseOrders(PurchaseOrderID)
        );

        -- Helpful indexes
        CREATE INDEX IX_InvoicePOMap_PurchaseOrderID ON dbo.InvoicePOMap(PurchaseOrderID);
        CREATE INDEX IX_InvoicePOMap_InvoiceID ON dbo.InvoicePOMap(InvoiceID);
    END
END
-- GO removed to preserve variable scope

-- 4) Optional backfill from existing data if both columns exist in base tables
-- If Invoices has POID but the link table was chosen, skip. This section only backfills link table
IF OBJECT_ID(N'[dbo].[InvoicePOMap]', 'U') IS NOT NULL
BEGIN
    -- Backfill from Invoices.PurchaseOrderID if present
    IF COL_LENGTH('dbo.Invoices','PurchaseOrderID') IS NOT NULL
    BEGIN
        INSERT INTO dbo.InvoicePOMap (InvoiceID, PurchaseOrderID)
        SELECT i.InvoiceID, i.PurchaseOrderID
        FROM dbo.Invoices i
        LEFT JOIN dbo.InvoicePOMap m ON m.InvoiceID = i.InvoiceID AND m.PurchaseOrderID = i.PurchaseOrderID
        WHERE i.PurchaseOrderID IS NOT NULL AND m.InvoiceID IS NULL;
    END
    -- Or backfill from Invoices.POID if that is the column in use
    ELSE IF COL_LENGTH('dbo.Invoices','POID') IS NOT NULL
    BEGIN
        INSERT INTO dbo.InvoicePOMap (InvoiceID, PurchaseOrderID)
        SELECT i.InvoiceID, i.POID
        FROM dbo.Invoices i
        LEFT JOIN dbo.InvoicePOMap m ON m.InvoiceID = i.InvoiceID AND m.PurchaseOrderID = i.POID
        WHERE i.POID IS NOT NULL AND m.InvoiceID IS NULL;
    END
END

PRINT 'Invoice–PO link ensured (FK on Invoices.PurchaseOrderID/POID; or InvoicePOMap created).';
