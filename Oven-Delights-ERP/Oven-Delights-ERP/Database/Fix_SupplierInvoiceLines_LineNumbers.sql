-- Fix LineNumber for existing records in SupplierInvoiceLines
-- This script populates LineNumber for any records that don't have it

-- Use CTE to assign line numbers, then update
;WITH NumberedLines AS (
    SELECT 
        InvoiceLineID,
        ROW_NUMBER() OVER (PARTITION BY InvoiceID ORDER BY InvoiceLineID) AS NewLineNumber
    FROM dbo.SupplierInvoiceLines
    WHERE LineNumber IS NULL
)
UPDATE dbo.SupplierInvoiceLines
SET LineNumber = nl.NewLineNumber
FROM dbo.SupplierInvoiceLines sil
INNER JOIN NumberedLines nl ON sil.InvoiceLineID = nl.InvoiceLineID
GO

PRINT 'LineNumbers updated successfully'
GO

-- Verify the update
SELECT InvoiceID, InvoiceLineID, LineNumber, ProductCode, ProductName, Quantity, UnitPrice, LineTotal
FROM dbo.SupplierInvoiceLines
ORDER BY InvoiceID, LineNumber
GO
