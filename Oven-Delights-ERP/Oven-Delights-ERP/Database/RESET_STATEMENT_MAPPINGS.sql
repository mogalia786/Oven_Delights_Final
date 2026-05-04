-- =============================================
-- Reset Statement Transaction Mappings
-- Purpose: Clear all mappings to allow re-testing auto-map functionality
-- =============================================

UPDATE AP_StatementTransactions
SET 
    IsMapped = 0,
    MappedLedgerAccount = NULL,
    MappedDate = NULL,
    MappedBy = NULL
WHERE IsMapped = 1

PRINT 'All statement transaction mappings have been reset'
GO

-- Show count of reset transactions
SELECT 
    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN IsMapped = 1 THEN 1 ELSE 0 END) AS MappedCount,
    SUM(CASE WHEN IsMapped = 0 OR IsMapped IS NULL THEN 1 ELSE 0 END) AS UnmappedCount
FROM AP_StatementTransactions
GO
