# BANK RECONCILIATION - SIMPLE INSTALLATION GUIDE

## EXECUTE THESE SCRIPTS IN ORDER

### Step 1: Create GLBatches Table
```sql
-- Execute: CREATE_GLBATCHES_TABLE.sql
```

### Step 2: Create Bank Reconciliation Tables
```sql
-- Execute: CREATE_BANK_RECONCILIATION_SYSTEM.sql
```

### Step 3: Create Stored Procedures
```sql
-- Execute in this order:
1. sp_GeneratePaymentReference.sql
2. sp_AutoMatchBankTransactions.sql
3. sp_PostBankTransactionsToGL.sql
```

### Step 4: Validate Installation
```sql
-- Execute: INSTALL_BANK_RECONCILIATION.sql
-- This will check if everything is installed correctly
```

### Step 5: Test System
```sql
-- Execute: TEST_BANK_RECONCILIATION.sql
-- This will run automated tests
```

## IMPORTANT NOTES

1. **Do NOT use SQLCMD mode** - Execute each script separately in SSMS
2. **Remove "USE" statement** if you get database switch errors
3. **Check for errors** after each script execution
4. **All 6 tests should pass** in the test script

## TROUBLESHOOTING

**Error: "USE statement is not supported"**
- Solution: You're connected to Azure SQL or restricted environment
- Fix: Connect directly to OvenDelightsERP database, remove USE statements

**Error: "Invalid column name"**
- Solution: Tables not created yet
- Fix: Execute CREATE_BANK_RECONCILIATION_SYSTEM.sql first

**Error: "Could not find stored procedure"**
- Solution: Stored procedures not created yet
- Fix: Execute the 3 stored procedure scripts in order
