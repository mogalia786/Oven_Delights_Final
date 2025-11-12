-- =============================================
-- FIX EXPIRED BOM - Remove EffectiveTo dates
-- Run this if BOMs are expired and preventing generation
-- =============================================

PRINT '🔧 Fixing Expired BOMs...';
PRINT '';

-- Show current expired BOMs
PRINT '=== EXPIRED BOMs (Before Fix) ===';
SELECT 
    bh.BOMID,
    bh.ProductID,
    p.Name AS ProductName,
    bh.IsActive,
    bh.EffectiveFrom,
    bh.EffectiveTo,
    CASE 
        WHEN bh.EffectiveTo IS NOT NULL AND bh.EffectiveTo < CAST(GETDATE() AS DATE) THEN '❌ EXPIRED'
        WHEN bh.EffectiveTo IS NULL THEN '✅ No Expiry'
        ELSE '✅ Still Valid'
    END AS Status
FROM dbo.BOMHeader bh
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = bh.ProductID
WHERE bh.IsActive = 1
ORDER BY p.Name;

PRINT '';
PRINT '=== Removing EffectiveTo dates from expired BOMs ===';

-- Update expired BOMs to have no expiry date
UPDATE dbo.BOMHeader
SET EffectiveTo = NULL
WHERE IsActive = 1
  AND EffectiveTo IS NOT NULL
  AND EffectiveTo < CAST(GETDATE() AS DATE);

DECLARE @UpdatedCount INT = @@ROWCOUNT;
PRINT CONCAT('✅ Updated ', @UpdatedCount, ' expired BOM(s)');

PRINT '';
PRINT '=== BOMs (After Fix) ===';
SELECT 
    bh.BOMID,
    bh.ProductID,
    p.Name AS ProductName,
    bh.IsActive,
    bh.EffectiveFrom,
    bh.EffectiveTo,
    CASE 
        WHEN bh.EffectiveTo IS NOT NULL AND bh.EffectiveTo < CAST(GETDATE() AS DATE) THEN '❌ EXPIRED'
        WHEN bh.EffectiveTo IS NULL THEN '✅ No Expiry'
        ELSE '✅ Still Valid'
    END AS Status
FROM dbo.BOMHeader bh
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = bh.ProductID
WHERE bh.IsActive = 1
ORDER BY p.Name;

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ FIX COMPLETE!';
PRINT '';
PRINT 'All active BOMs now have no expiry date (EffectiveTo = NULL)';
PRINT 'Try BOM Generate again - it should now populate items!';
PRINT '═══════════════════════════════════════════════';
