-- Check if BOM tables exist and have data
SELECT 'BOM_Header count' AS Info, COUNT(*) AS Count FROM BOM_Header WHERE IsActive = 1
UNION ALL
SELECT 'BOM_Lines count', COUNT(*) FROM BOM_Lines
UNION ALL
SELECT 'Products with BOMs', COUNT(DISTINCT ProductID) FROM BOM_Header WHERE IsActive = 1

-- Show sample BOM data
SELECT TOP 5 
    bh.BOMID,
    bh.ProductID,
    p.ProductName,
    p.ProductCode,
    bh.BatchSize,
    bh.IsActive
FROM BOM_Header bh
INNER JOIN Products p ON bh.ProductID = p.ProductID
WHERE bh.IsActive = 1

-- Show sample BOM lines
SELECT TOP 10
    bl.BOMID,
    bl.LineNumber,
    bl.ProductName,
    bl.Quantity,
    bl.UnitOfMeasure
FROM BOM_Lines bl
INNER JOIN BOM_Header bh ON bl.BOMID = bh.BOMID
WHERE bh.IsActive = 1
ORDER BY bl.BOMID, bl.LineNumber
