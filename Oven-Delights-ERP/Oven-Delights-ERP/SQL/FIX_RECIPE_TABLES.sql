-- =============================================
-- FIX RECIPE TABLES - Remove problematic constraint
-- =============================================

PRINT '🔧 Fixing Recipe Tables...';
PRINT '';

-- Drop the CHECK constraint if it exists
IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_RecipeIngredient_Type')
BEGIN
    ALTER TABLE dbo.RecipeIngredient DROP CONSTRAINT CK_RecipeIngredient_Type;
    PRINT '✅ Removed CK_RecipeIngredient_Type constraint';
END
ELSE
BEGIN
    PRINT '⚠️  Constraint already removed';
END

-- Clear existing data to allow re-migration
DELETE FROM dbo.RecipeIngredient;
PRINT '✅ Cleared RecipeIngredient data';

DELETE FROM dbo.Recipe;
PRINT '✅ Cleared Recipe data';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ Tables fixed! Now run CREATE_SIMPLIFIED_RECIPE_SYSTEM.sql again';
PRINT '═══════════════════════════════════════════════';
