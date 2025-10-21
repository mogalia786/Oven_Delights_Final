# Database Script Execution Instructions for Azure SQL Server

## Database Execution Instructions

## Overview
This document provides step-by-step instructions for executing all database scripts for the Oven Delights ERP system, including the new SARS compliance features.

## Prerequisites
- SQL Server Management Studio (SSMS) or sqlcmd
- Access to the OvenDelightsERP database
- Appropriate permissions to create tables, triggers, and stored procedures

## Quick Start - Execute All Scripts
For a complete setup, run this single comprehensive script:

```sql
-- Execute the complete setup script
sqlcmd -S . -d OvenDelightsERP -i "ExecuteAllScripts.sql"
```

Or in SSMS:
1. Open `ExecuteAllScripts.sql`
2. Ensure you're connected to the `OvenDelightsERP` database
3. Execute the entire script (F5)

## Manual Execution Order (if needed)

### 1. SARS Compliance Tables
Execute the SARS compliance schema first:

```sql
-- SARS compliance tables for tax reporting
sqlcmd -S . -d OvenDelightsERP -i "SARS\Create_SARS_Tables.sql"
```

### 2. Product Synchronization Triggers
After core tables are created, execute trigger scripts:

```sql
-- Product synchronization triggers
sqlcmd -S . -d OvenDelightsERP -i "CreateProductSyncTriggers.sql"
```

### 3. Additional Scripts (as needed)
Execute any additional stored procedures or views:

```sql
-- Execute other database scripts as required
```

## New SARS Compliance Features

The system now includes comprehensive SARS tax compliance features:

### Tables Created:
- **VATTransactions** - VAT transaction records for VAT201 reporting
- **VATReturns** - VAT return tracking and submission history
- **Employees** - Employee master data for payroll
- **PayrollTransactions** - Payroll data for EMP201 and IRP5 reporting
- **EMP201Returns** - Monthly PAYE return tracking
- **IRP5Certificates** - Annual employee tax certificates
- **SARSSubmissionLog** - Audit trail for all SARS submissions

### Sample Data Included:
- 3 sample employees with payroll data
- Sample VAT transactions for testing
- Ready-to-use data for generating reports

## Accessing SARS Features

After database setup:

1. **Launch the ERP application**
2. **Navigate to**: Accounting → SARS Compliance → Tax Returns & Reporting
3. **Available reports**:
   - VAT201 (VAT returns)
   - EMP201 (Monthly PAYE)
   - IRP5 (Employee tax certificates)
   - Compliance checking

## Verification Steps

After execution, verify the installation:

```sql
-- Check SARS tables exist
SELECT name FROM sys.tables WHERE name IN (
    'VATTransactions', 'VATReturns', 'Employees', 
    'PayrollTransactions', 'EMP201Returns', 'IRP5Certificates'
);

-- Verify sample data
SELECT COUNT(*) as EmployeeCount FROM Employees;
SELECT COUNT(*) as PayrollCount FROM PayrollTransactions;
SELECT COUNT(*) as VATCount FROM VATTransactions;
```

## Testing SARS Features

1. **Open SARS Reporting Form** from the Accounting menu
2. **Generate VAT201** for current month
3. **Generate EMP201** for current month  
4. **Generate IRP5** certificates for current tax year
5. **Run compliance check** to identify any issues
6. **Export reports** to CSV for eFiling submission

## Troubleshooting

### Common Issues:
- **Permission errors**: Ensure you have db_owner or sysadmin permissions
- **Foreign key constraints**: Tables are created in dependency order automatically
- **Duplicate objects**: Script checks for existing objects before creation
- **Missing Branches table**: Ensure core ERP tables exist first

### SARS-Specific Issues:
- **No data in reports**: Insert sample employees and payroll transactions
- **Form won't open**: Check that all SARS service classes are compiled
- **Export errors**: Ensure write permissions to export directory

## Production Deployment Notes

- **Backup database** before running scripts
- **Test in development** environment first
- **Review sample data** - remove or replace with real data in production
- **Configure tax rates** according to current SARS requirements (15% VAT as of 2024)
- **Set up proper user permissions** for SARS reporting access

## Support

For issues with:
- **Database scripts**: Check SQL Server error logs
- **SARS compliance**: Refer to SARS eFiling documentation
- **Application errors**: Check application event logs

## Execution Methods for Azure SQL

### Option 1: SQL Server Management Studio (SSMS)
1. Connect to your Azure SQL Server
2. Select `OvenDelightsERP` database
3. Open each script file
4. Execute in the order listed above

### Option 2: Azure Data Studio
1. Connect to Azure SQL Server
2. Open script files
3. Execute against `OvenDelightsERP` database

### Option 3: Azure Portal Query Editor
1. Navigate to your SQL Database in Azure Portal
2. Use Query Editor (preview)
3. Copy/paste script contents
4. Execute

### Option 4: PowerShell with SqlServer Module
```powershell
# Install SqlServer module if not already installed
Install-Module -Name SqlServer -Force

# Execute scripts
Invoke-Sqlcmd -ServerInstance "your-azure-server.database.windows.net" -Database "Oven_Delights_Main" -Username "your-username" -Password "your-password" -InputFile "AddCategorySubcategoryStructure.sql"

Invoke-Sqlcmd -ServerInstance "your-azure-server.database.windows.net" -Database "Oven_Delights_Main" -Username "your-username" -Password "your-password" -InputFile "EnforceMandatoryCategorySubcategory.sql"

Invoke-Sqlcmd -ServerInstance "your-azure-server.database.windows.net" -Database "Oven_Delights_Main" -Username "your-username" -Password "your-password" -InputFile "SyncLegacyInventoryWithStockroom.sql"
```

## Post-Execution Verification

After executing all scripts, run these queries to verify:

```sql
-- Check orphaned products
SELECT * FROM vw_OrphanedProducts WHERE ClassificationStatus LIKE '%ORPHANED%'

-- Verify POS-ready products
SELECT COUNT(*) AS POSReadyProducts FROM vw_POSProducts

-- Test legacy sync
EXEC sp_SyncLegacyInventoryToStockroom

-- Validate category structure
SELECT * FROM fn_GetCategorySubcategoryOptions()
```

## Implementation Status

### ✅ Completed Components:
1. **Database Schema**: Category/Subcategory structure with sample bakery data
2. **Orphaned Product Detection**: `vw_OrphanedProducts` view identifies products needing classification
3. **POS Integration**: `vw_POSProducts` shows only properly classified products
4. **UI Integration**: `CategorySubcategorySelector.vb` integrated into `ProductUpsertForm.vb`
5. **Legacy Compatibility**: Purchase Order workflow preserved with sync system

### 🔄 Business Rules Enforced:
- **NO ORPHANED PRODUCTS**: All products must have Category + Subcategory
- **BUILD MY PRODUCT**: Cannot save without proper classification
- **POS FILTERING**: Only classified products appear in Point of Sale
- **LEGACY SYNC**: Existing inventory system remains functional

### 📋 Example Workflow:
1. User creates "Coca-Cola" product
2. Must select: Category = "Beverages", Subcategory = "Soft Drinks"
3. Save button disabled until classification selected
4. Product appears in POS under Beverages → Soft Drinks
5. Legacy inventory sync maintains Purchase Order compatibility

## Next Steps:
1. Execute the three SQL scripts in Azure
2. Test the integrated ProductUpsertForm with CategorySubcategorySelector
3. Verify orphaned product detection works
4. Confirm POS displays products by Category → Subcategory
5. Test legacy inventory synchronization
