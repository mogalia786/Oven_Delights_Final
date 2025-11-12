-- ========================================
-- ACCOUNTING SETUP - RUN SCRIPTS IN ORDER
-- For Azure SQL Database
-- ========================================

-- IMPORTANT: You are using Azure SQL Database
-- The USE statement is not supported
-- Make sure you are connected to OvenDelightsERP database before running these scripts

PRINT '========================================';
PRINT 'ACCOUNTING SETUP - EXECUTION GUIDE';
PRINT '========================================';
PRINT '';
PRINT 'Run these scripts IN ORDER:';
PRINT '';
PRINT '1. FIX_LEDGERS_TABLE.sql';
PRINT '   → Adds missing columns to Ledgers table';
PRINT '';
PRINT '2. ADD_MISSING_COLUMNS.sql';
PRINT '   → Adds missing columns to ChartOfAccounts table';
PRINT '';
PRINT '3. POPULATE_CHART_OF_ACCOUNTS.sql';
PRINT '   → Creates all GL accounts (Cash, Inventory, Revenue, Expenses)';
PRINT '';
PRINT '4. SETUP_INVENTORY_LEDGERS.sql';
PRINT '   → Links inventory and cash accounts to ledgers';
PRINT '';
PRINT '========================================';
PRINT 'EXECUTION ORDER SUMMARY';
PRINT '========================================';
PRINT '';
PRINT 'Step 1: Fix Ledgers Table Structure';
PRINT 'Step 2: Fix ChartOfAccounts Table Structure';
PRINT 'Step 3: Populate Chart of Accounts (60+ accounts)';
PRINT 'Step 4: Setup Inventory Ledger Links';
PRINT '';
PRINT 'After completion, you will have:';
PRINT '  ✓ Complete Chart of Accounts';
PRINT '  ✓ Cash accounts (Cash on Hand, Petty Cash, etc.)';
PRINT '  ✓ Inventory accounts (Stockroom, Manufacturing, etc.)';
PRINT '  ✓ Ledger links for automated posting';
PRINT '';
PRINT '========================================';
GO
