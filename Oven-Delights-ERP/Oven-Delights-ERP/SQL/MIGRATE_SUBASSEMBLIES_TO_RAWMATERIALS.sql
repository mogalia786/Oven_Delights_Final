/*
    MIGRATE SubAssemblies to RawMaterials Table
    
    PURPOSE:
    - Copy all SubAssemblies into RawMaterials table
    - Assign MaterialType = 'Sub Recipe'
    - This eliminates the need for separate SubAssemblies table
    - Simplifies recipe building - everything is a "material"
    
    BENEFITS:
    - Single FK constraint (MaterialID)
    - No more SubAssemblyID vs MaterialID confusion
    - Unified ingredient selector
    - Branch prefix filtering works the same for both
*/

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'MIGRATING SubAssemblies to RawMaterials';
PRINT '========================================';
PRINT '';

-- Step 1: Check if SubAssemblies exist
DECLARE @SubAssemblyCount INT = 0;
SELECT @SubAssemblyCount = COUNT(*) FROM SubAssemblies WHERE IsActive = 1;

PRINT 'Found ' + CAST(@SubAssemblyCount AS VARCHAR) + ' active SubAssemblies';
PRINT '';

-- Step 2: Migrate SubAssemblies to RawMaterials
-- Only migrate if they don't already exist (based on MaterialCode = SubAssemblyCode)
-- Extract BaseUnit from last 3 characters of SubAssemblyCode (e.g., ACYBB-BDO-MX1 -> MX1)
-- Provide defaults for all NOT NULL columns
INSERT INTO RawMaterials (
    MaterialCode,
    MaterialName,
    MaterialType,
    BaseUnit,
    UnitOfMeasure,
    UoMID,
    IsActive,
    CreatedDate,
    CreatedBy,
    Description
)
SELECT 
    sa.SubAssemblyCode AS MaterialCode,
    sa.SubAssemblyName AS MaterialName,
    'Sub Recipe' AS MaterialType,
    RIGHT(sa.SubAssemblyCode, 3) AS BaseUnit,  -- Extract last 3 chars (MX1, MX6, etc.)
    RIGHT(sa.SubAssemblyCode, 3) AS UnitOfMeasure,  -- Same as BaseUnit
    sa.DefaultUoMID AS UoMID,
    sa.IsActive,
    ISNULL(sa.CreatedDate, GETDATE()) AS CreatedDate,
    1 AS CreatedBy,  -- Default to UserID 1 (system/admin)
    sa.Description
FROM SubAssemblies sa
WHERE sa.IsActive = 1
AND NOT EXISTS (
    SELECT 1 
    FROM RawMaterials rm 
    WHERE rm.MaterialCode = sa.SubAssemblyCode
);

DECLARE @MigratedCount INT = @@ROWCOUNT;
PRINT 'Migrated ' + CAST(@MigratedCount AS VARCHAR) + ' SubAssemblies to RawMaterials';
PRINT '';

-- Step 3: Show summary
PRINT 'SUMMARY:';
PRINT '--------';

SELECT 
    MaterialType,
    COUNT(*) AS Count,
    COUNT(CASE WHEN LEFT(MaterialCode, 2) = 'AC' THEN 1 END) AS AC_Count,
    COUNT(CASE WHEN LEFT(MaterialCode, 2) = 'UM' THEN 1 END) AS UM_Count
FROM RawMaterials
WHERE IsActive = 1
GROUP BY MaterialType
ORDER BY MaterialType;

PRINT '';
PRINT '✅ Migration complete!';
PRINT '';
PRINT 'NEXT STEPS:';
PRINT '1. Update RawMaterialSelectorDialog to show both types';
PRINT '2. Remove SubAssembly-specific code';
PRINT '3. Use MaterialID for everything';
PRINT '';
