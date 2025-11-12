# POS DEMO ENVIRONMENT SETUP

**Bismillah** - Complete safe demo environment for POS development

---

## 📋 OVERVIEW

This folder contains scripts to create a **completely isolated demo environment** for POS development without touching production data.

### ✅ Safety Guarantees
- Demo tables are **separate** from production tables
- Master `Products` table remains **untouched** (read-only)
- Easy switch to production with **one config change**
- Can delete all demo data without affecting production

---

## 🚀 QUICK START

### Step 1: Create Demo Tables
```sql
-- Run in SQL Server Management Studio
-- File: 01_Create_Demo_Tables.sql
-- Creates 11 demo tables with Demo_ prefix
```

### Step 2: Populate Demo Data
```sql
-- File: 02_Populate_Demo_Data.sql
-- Copies products from master Products table
-- Generates simulated prices
-- Creates stock for all branches
```

### Step 3: Verify Setup
```sql
-- File: 03_Verification_Queries.sql
-- Checks all data populated correctly
-- Verifies master table untouched
```

---

## 📊 DEMO TABLES CREATED

### Core POS Tables
1. `Demo_Retail_Product` - Product master
2. `Demo_Retail_Variant` - Product variants
3. `Demo_Retail_Price` - Selling prices (simulated)
4. `Demo_Retail_Stock` - Stock quantities per branch
5. `Demo_Retail_StockMovements` - Stock movement audit
6. `Demo_Retail_ProductImage` - Product images

### Transaction Tables
7. `Demo_Sales` - Sales headers
8. `Demo_SalesDetails` - Sales line items
9. `Demo_Payments` - Payment records
10. `Demo_Returns` - Return headers
11. `Demo_ReturnDetails` - Return line items

---

## 💰 SIMULATED PRICE RANGES

| Category | Min Price | Max Price |
|----------|-----------|-----------|
| Bread | R15 | R50 |
| Rolls | R5 | R20 |
| Pastries | R25 | R80 |
| Cakes | R50 | R500 |
| Cookies | R10 | R40 |
| Pies | R30 | R100 |
| Tarts | R20 | R150 |
| Donuts | R8 | R35 |
| Muffins | R15 | R45 |

**Cost Price**: Automatically set to 60% of selling price (40% markup)

---

## ⚙️ APPLICATION CONFIGURATION

### Option 1: App.config (Recommended)

Add to your `App.config`:

```xml
<appSettings>
  <add key="UseDemoTables" value="true" />
</appSettings>
```

### Option 2: Code Implementation

```vb
Public Class POSDataService
    Private ReadOnly _tablePrefix As String
    
    Public Sub New()
        Dim useDemoTables = Boolean.Parse(ConfigurationManager.AppSettings("UseDemoTables"))
        _tablePrefix = If(useDemoTables, "Demo_", "")
    End Sub
    
    Private Function GetTableName(baseName As String) As String
        Return $"{_tablePrefix}{baseName}"
    End Function
    
    Public Function GetStock(branchId As Integer) As DataTable
        Dim tableName = GetTableName("Retail_Stock")
        Dim sql = $"SELECT * FROM {tableName} WHERE BranchID = @BranchID"
        ' Execute query...
    End Function
End Class
```

---

## 🎯 GO-LIVE PROCESS

### When Ready for Production:

1. **Backup Database**
   ```sql
   BACKUP DATABASE OvenDelightsERP TO DISK = 'C:\Backups\PreGoLive.bak'
   ```

2. **Update Configuration**
   ```xml
   <add key="UseDemoTables" value="false" />
   ```

3. **Restart Application**

4. **Test First Transaction**

5. **Verify Stock Deduction**

### Emergency Rollback
If issues occur, simply change config back to `true` and restart.

---

## 📁 FILE STRUCTURE

```
POS_Demo/
├── README.md (this file)
├── 01_Create_Demo_Tables.sql      - Creates all demo tables
├── 02_Populate_Demo_Data.sql      - Populates from Products master
├── 03_Verification_Queries.sql    - Verify setup complete
└── 99_Go_Live_Checklist.sql       - Go-live instructions
```

---

## ✅ VERIFICATION CHECKLIST

After running setup scripts:

- [ ] All 11 demo tables created
- [ ] Products copied from master table
- [ ] Prices generated for all products
- [ ] Stock created for all branches
- [ ] Master Products table unchanged
- [ ] Transaction tables empty (ready for use)
- [ ] App.config updated with UseDemoTables flag

---

## 🔒 SAFETY FEATURES

### What's Protected
✅ Master `Products` table (read-only)  
✅ Production `Retail_Stock` table  
✅ Production `Retail_Price` table  
✅ All production transaction data  
✅ Chart of Accounts  
✅ Customer data  
✅ Supplier data  

### What's Isolated
🔒 All demo tables have `Demo_` prefix  
🔒 Separate identity columns  
🔒 No foreign keys to production  
🔒 Can be deleted without impact  

---

## 📊 SAMPLE QUERIES

### View Products with Prices
```sql
SELECT 
    p.SKU,
    p.Name,
    p.Category,
    pr.SellingPrice,
    pr.CostPrice
FROM Demo_Retail_Product p
INNER JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID
ORDER BY p.Name;
```

### Check Stock by Branch
```sql
SELECT 
    b.BranchName,
    p.Name,
    s.QtyOnHand,
    s.ReorderPoint
FROM Demo_Retail_Stock s
INNER JOIN Demo_Retail_Variant v ON s.VariantID = v.VariantID
INNER JOIN Demo_Retail_Product p ON v.ProductID = p.ProductID
INNER JOIN Branches b ON s.BranchID = b.BranchID
WHERE b.BranchName = 'Your Branch Name'
ORDER BY p.Name;
```

### View Sales Transactions
```sql
SELECT 
    s.SaleNumber,
    s.SaleDate,
    s.TotalAmount,
    s.TenderType,
    COUNT(sd.SaleDetailID) AS ItemCount
FROM Demo_Sales s
LEFT JOIN Demo_SalesDetails sd ON s.SaleID = sd.SaleID
GROUP BY s.SaleNumber, s.SaleDate, s.TotalAmount, s.TenderType
ORDER BY s.SaleDate DESC;
```

---

## 🆘 TROUBLESHOOTING

### Issue: No products showing in POS
**Solution**: Check `UseDemoTables` config flag is set to `true`

### Issue: Prices not displaying
**Solution**: Run `02_Populate_Demo_Data.sql` again

### Issue: Stock shows zero
**Solution**: Verify `Demo_Retail_Stock` has records for your branch

### Issue: Can't create sale
**Solution**: Check `Demo_Sales` table exists and has no constraints blocking insert

---

## 📞 SUPPORT

If you encounter issues:

1. Run `03_Verification_Queries.sql` to diagnose
2. Check error messages in application logs
3. Verify database connection string
4. Ensure user has permissions on Demo tables

---

## 🎓 TRAINING ENVIRONMENT

This demo environment is perfect for:
- Staff training on new POS system
- Testing new features safely
- Demonstrating to stakeholders
- Load testing without risk
- Troubleshooting issues

---

## 📝 NOTES

- Demo tables can coexist with production indefinitely
- Recommended to keep demo environment for 30 days after go-live
- Can recreate demo environment anytime by re-running scripts
- Archive demo transaction data before cleanup

---

**Alhamdulillah** - May this system benefit your business! 🤲
