-- =============================================
-- POS GO-LIVE CHECKLIST & CLEANUP
-- =============================================
-- Purpose: Steps to switch from Demo to Production
-- WARNING: Only run this when ready to go live!
-- =============================================




PRINT '========================================';
PRINT 'POS GO-LIVE CHECKLIST';
PRINT '========================================';
PRINT '';
PRINT 'BEFORE RUNNING THIS SCRIPT:';
PRINT '1. Backup your database';
PRINT '2. Test POS thoroughly with demo data';
PRINT '3. Train staff on new POS system';
PRINT '4. Verify production tables are ready';
PRINT '5. Update App.config: UseDemoTables = false';
PRINT '';
PRINT '========================================';
GO

-- =============================================
-- STEP 1: Archive Demo Transaction Data
-- =============================================
PRINT '';
PRINT 'STEP 1: Archive Demo Transaction Data';
PRINT '----------------------------------------';
GO

-- Archive sales for reference
IF OBJECT_ID('dbo.Archive_Demo_Sales', 'U') IS NOT NULL
    DROP TABLE dbo.Archive_Demo_Sales;
GO

SELECT * INTO Archive_Demo_Sales FROM Demo_Sales;
GO

PRINT '✓ Archived ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' demo sales';
GO

-- Archive sales details
IF OBJECT_ID('dbo.Archive_Demo_SalesDetails', 'U') IS NOT NULL
    DROP TABLE dbo.Archive_Demo_SalesDetails;
GO

SELECT * INTO Archive_Demo_SalesDetails FROM Demo_SalesDetails;
GO

PRINT '✓ Archived demo sales details';
GO

-- =============================================
-- STEP 2: Verify Production Tables Ready
-- =============================================
PRINT '';
PRINT 'STEP 2: Verify Production Tables';
PRINT '----------------------------------------';
GO

-- Check if production tables exist
IF OBJECT_ID('dbo.Retail_Stock', 'U') IS NULL
BEGIN
    PRINT '✗ ERROR: Retail_Stock table does not exist!';
    PRINT '  Action: Create production Retail tables first';
    RETURN;
END

IF OBJECT_ID('dbo.Retail_Price', 'U') IS NULL
BEGIN
    PRINT '✗ ERROR: Retail_Price table does not exist!';
    PRINT '  Action: Create production Retail tables first';
    RETURN;
END

PRINT '✓ Production tables exist';
GO

-- Check if production has data
DECLARE @ProdStock INT = (SELECT COUNT(*) FROM Retail_Stock);
DECLARE @ProdPrice INT = (SELECT COUNT(*) FROM Retail_Price);

IF @ProdStock = 0
BEGIN
    PRINT '⚠ WARNING: Retail_Stock is empty!';
    PRINT '  Action: Populate production stock before go-live';
END
ELSE
BEGIN
    PRINT '✓ Production stock has ' + CAST(@ProdStock AS VARCHAR(10)) + ' records';
END

IF @ProdPrice = 0
BEGIN
    PRINT '⚠ WARNING: Retail_Price is empty!';
    PRINT '  Action: Set production prices before go-live';
END
ELSE
BEGIN
    PRINT '✓ Production prices has ' + CAST(@ProdPrice AS VARCHAR(10)) + ' records';
END
GO

-- =============================================
-- STEP 3: Configuration Change Instructions
-- =============================================
PRINT '';
PRINT 'STEP 3: Update Application Configuration';
PRINT '----------------------------------------';
PRINT '';
PRINT 'In App.config or Web.config, change:';
PRINT '';
PRINT '  FROM:  <add key="UseDemoTables" value="true" />';
PRINT '  TO:    <add key="UseDemoTables" value="false" />';
PRINT '';
PRINT 'OR in database configuration table:';
PRINT '';
PRINT '  UPDATE SystemConfig SET ConfigValue = ''false''';
PRINT '  WHERE ConfigKey = ''UseDemoTables'';';
PRINT '';
PRINT '----------------------------------------';
GO

-- =============================================
-- STEP 4: Optional - Keep Demo Tables for Testing
-- =============================================
PRINT '';
PRINT 'STEP 4: Demo Tables Management';
PRINT '----------------------------------------';
PRINT '';
PRINT 'OPTION A: Keep demo tables for future testing';
PRINT '  - No action needed';
PRINT '  - Demo tables remain in database';
PRINT '  - Can switch back for training';
PRINT '';
PRINT 'OPTION B: Remove demo tables to save space';
PRINT '  - Run: 99b_Remove_Demo_Tables.sql';
PRINT '  - Frees up database space';
PRINT '  - Can recreate later if needed';
PRINT '';
PRINT '----------------------------------------';
GO

-- =============================================
-- STEP 5: Post Go-Live Verification
-- =============================================
PRINT '';
PRINT 'STEP 5: Post Go-Live Verification';
PRINT '----------------------------------------';
PRINT '';
PRINT 'After changing config and restarting app:';
PRINT '';
PRINT '1. Test a small sale transaction';
PRINT '2. Verify stock deduction in Retail_Stock';
PRINT '3. Check sales record in production tables';
PRINT '4. Test return transaction';
PRINT '5. Verify all reports show production data';
PRINT '';
PRINT '----------------------------------------';
GO

-- =============================================
-- GO-LIVE CHECKLIST
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'GO-LIVE CHECKLIST';
PRINT '========================================';
PRINT '';
PRINT '□ 1. Database backed up';
PRINT '□ 2. Demo data archived';
PRINT '□ 3. Production tables verified';
PRINT '□ 4. Production stock populated';
PRINT '□ 5. Production prices set';
PRINT '□ 6. App.config updated (UseDemoTables=false)';
PRINT '□ 7. Application restarted';
PRINT '□ 8. Test transaction completed';
PRINT '□ 9. Stock deduction verified';
PRINT '□ 10. Staff trained on live system';
PRINT '';
PRINT '========================================';
PRINT 'IMPORTANT NOTES';
PRINT '========================================';
PRINT '';
PRINT '• Keep demo tables for 30 days after go-live';
PRINT '• Monitor first week of live transactions';
PRINT '• Have rollback plan ready';
PRINT '• Document any issues immediately';
PRINT '';
PRINT '========================================';
GO

-- =============================================
-- Quick Switch Back to Demo (Emergency)
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'EMERGENCY: SWITCH BACK TO DEMO';
PRINT '========================================';
PRINT '';
PRINT 'If you need to switch back to demo:';
PRINT '';
PRINT '1. In App.config:';
PRINT '   <add key="UseDemoTables" value="true" />';
PRINT '';
PRINT '2. Restart application';
PRINT '';
PRINT '3. Investigate production issue';
PRINT '';
PRINT '========================================';
GO
