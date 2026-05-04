-- =============================================
-- Fix SupplierInvoices QUOTED_IDENTIFIER Error
-- The unique index on InvoiceNumber requires QUOTED_IDENTIFIER ON
-- =============================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

PRINT 'Fixing SupplierInvoices QUOTED_IDENTIFIER issue...'

-- Drop the unique index if it exists
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'UQ_SupplierInvoices_Number' AND object_id = OBJECT_ID('SupplierInvoices'))
BEGIN
    DROP INDEX UQ_SupplierInvoices_Number ON SupplierInvoices;
    PRINT 'Dropped existing unique index UQ_SupplierInvoices_Number'
END
GO

-- Find and report duplicates
PRINT ''
PRINT 'Checking for duplicate invoice numbers...'

SELECT 
    InvoiceNumber, 
    SupplierID, 
    COUNT(*) AS DuplicateCount,
    STRING_AGG(CAST(InvoiceID AS NVARCHAR(10)), ', ') AS InvoiceIDs
FROM SupplierInvoices
GROUP BY InvoiceNumber, SupplierID
HAVING COUNT(*) > 1;

-- Delete duplicate invoices (keep the oldest one based on InvoiceID)
PRINT ''
PRINT 'Removing duplicate invoice records (keeping oldest)...'

DELETE FROM SupplierInvoices
WHERE InvoiceID IN (
    SELECT InvoiceID
    FROM (
        SELECT 
            InvoiceID,
            ROW_NUMBER() OVER (PARTITION BY InvoiceNumber, SupplierID ORDER BY InvoiceID ASC) AS rn
        FROM SupplierInvoices
    ) AS duplicates
    WHERE rn > 1
);

PRINT 'Duplicates removed'
GO

-- Recreate the unique index with QUOTED_IDENTIFIER ON
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;

CREATE UNIQUE INDEX UQ_SupplierInvoices_Number ON dbo.SupplierInvoices(InvoiceNumber, SupplierID);
PRINT 'Recreated unique index UQ_SupplierInvoices_Number with QUOTED_IDENTIFIER ON'
GO

PRINT ''
PRINT 'Fix completed successfully!'
PRINT 'SupplierInvoices table can now accept INSERT statements'
