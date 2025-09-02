/*
Upgrade: Add MaterialType and UnitOfMeasure to dbo.RawMaterials if missing
- MaterialType: NVARCHAR(20) NOT NULL DEFAULT 'Raw'
- UnitOfMeasure: NVARCHAR(20) NOT NULL; if BaseUnit exists, create and backfill from BaseUnit
This script is safe to run multiple times.
*/

SET NOCOUNT ON;

IF OBJECT_ID('dbo.RawMaterials','U') IS NULL
BEGIN
    PRINT 'RawMaterials table not found. Upgrade script skipped.';
    RETURN;
END

-- Add MaterialType if missing
IF COL_LENGTH('dbo.RawMaterials','MaterialType') IS NULL
BEGIN
    PRINT 'Adding column MaterialType to dbo.RawMaterials...';
    ALTER TABLE dbo.RawMaterials
      ADD MaterialType NVARCHAR(20) NOT NULL CONSTRAINT DF_RawMaterials_MaterialType DEFAULT N'Raw';
END
ELSE
BEGIN
    PRINT 'Column MaterialType already exists. No change.';
END

-- Add UnitOfMeasure if missing
IF COL_LENGTH('dbo.RawMaterials','UnitOfMeasure') IS NULL
BEGIN
    PRINT 'Adding column UnitOfMeasure to dbo.RawMaterials...';
    ALTER TABLE dbo.RawMaterials
      ADD UnitOfMeasure NVARCHAR(20) NULL;

    -- If BaseUnit exists, backfill
    IF COL_LENGTH('dbo.RawMaterials','BaseUnit') IS NOT NULL
    BEGIN
        PRINT 'Backfilling UnitOfMeasure from BaseUnit...';
        EXEC sp_executesql N'UPDATE dbo.RawMaterials SET UnitOfMeasure = BaseUnit WHERE UnitOfMeasure IS NULL;';
    END

    -- Set NOT NULL with default 'kg' for any remaining NULLs
    PRINT 'Finalizing UnitOfMeasure constraints...';
    EXEC sp_executesql N'UPDATE dbo.RawMaterials SET UnitOfMeasure = N''kg'' WHERE UnitOfMeasure IS NULL;';

    -- Add NOT NULL constraint
    ALTER TABLE dbo.RawMaterials ALTER COLUMN UnitOfMeasure NVARCHAR(20) NOT NULL;
END
ELSE
BEGIN
    PRINT 'Column UnitOfMeasure already exists. No change.';
END

PRINT 'Upgrade completed: MaterialType/UnitOfMeasure ensured on dbo.RawMaterials.';

