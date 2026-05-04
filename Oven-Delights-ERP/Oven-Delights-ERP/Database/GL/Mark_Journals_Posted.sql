-- Mark all existing journals as posted so they appear in ledgers

-- First, check current status
SELECT 
    'Before Update' AS Status,
    IsPosted,
    COUNT(*) AS Count
FROM JournalHeaders
GROUP BY IsPosted

-- Update all journals to posted
UPDATE JournalHeaders
SET IsPosted = 1,
    PostedBy = 1,
    PostedDate = GETDATE()
WHERE IsPosted = 0

-- Check after update
SELECT 
    'After Update' AS Status,
    IsPosted,
    COUNT(*) AS Count
FROM JournalHeaders
GROUP BY IsPosted

-- Show sample of posted journals
SELECT TOP 10
    JournalID,
    JournalNumber,
    JournalDate,
    Description,
    IsPosted,
    BranchID
FROM JournalHeaders
WHERE IsPosted = 1
ORDER BY JournalDate DESC
