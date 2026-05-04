-- Check actual invoice number format
SELECT TOP 5
    InvoiceNumber,
    LEN(InvoiceNumber) AS Length,
    CASE 
        WHEN InvoiceNumber LIKE '%-%' THEN 'Has dash'
        ELSE 'No dash - just numbers'
    END AS Format
FROM Demo_Sales
ORDER BY SaleDate DESC

-- The issue: Invoice numbers are just "620061" not "INV-PH-TILL-01-620061"
-- So we need to use the invoice number directly for the journal number

-- For now, let's just use the invoice number as-is for the journal
-- Journal format: POS-620061 (11 chars, fits in 20-char limit)
