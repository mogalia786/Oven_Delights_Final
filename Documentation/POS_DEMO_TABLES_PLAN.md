# POS DEMO TABLES STRATEGY
## Complete Plan for Demo Environment Without Corrupting Production Data

---

## PROBLEM STATEMENT
1. **Current State**: 
   - `Retail_Stock` table contains real production stock data
   - `Products` master table has clean data without prices
   - POS system needs stock + prices to function
   - Cannot risk corrupting production data during POS development

2. **Requirements**:
   - Build POS system with demo data
   - Keep production tables untouched
   - Easy switch from demo to production when going live
   - Simulate realistic prices for all products
   - Populate demo stock from Products master table

---

## SOLUTION: PARALLEL DEMO TABLE STRUCTURE

### Core Strategy
Create `Demo_` prefixed tables that mirror production structure. POS application will use a **configuration flag** to switch between demo and production tables.

---

## TABLES TO DUPLICATE

### 1. **Stock & Inventory Tables**

#### Production Tables → Demo Tables

| Production Table | Demo Table | Purpose |
|-----------------|------------|---------|
| `Retail_Stock` | `Demo_Retail_Stock` | Branch stock levels |
| `Retail_Product` | `Demo_Retail_Product` | Product master (if needed) |
| `Retail_Variant` | `Demo_Retail_Variant` | Product variants |
| `Retail_Price` | `Demo_Retail_Price` | Selling prices (SIMULATED) |
| `Retail_StockMovements` | `Demo_Retail_StockMovements` | Stock movement audit |
| `Retail_ProductImage` | `Demo_Retail_ProductImage` | Product images |

### 2. **Transaction Tables**

| Production Table (if exists) | Demo Table | Purpose |
|------------------------------|------------|---------|
| `Sales` or `Retail_Sales` | `Demo_Sales` | Sales transactions |
| `SalesDetails` or `Retail_SalesDetails` | `Demo_SalesDetails` | Line items |
| `Returns` or `Retail_Returns` | `Demo_Returns` | Return transactions |
| `ReturnDetails` or `Retail_ReturnDetails` | `Demo_ReturnDetails` | Return line items |
| `CustomerOrders` | `Demo_CustomerOrders` | Customer orders |
| `OrderDetails` | `Demo_OrderDetails` | Order line items |
| `Payments` or `Retail_Payments` | `Demo_Payments` | Payment records |
| `Receipts` or `Retail_Receipts` | `Demo_Receipts` | Receipt records |

### 3. **Supporting Tables**

| Production Table | Demo Table | Purpose |
|-----------------|------------|---------|
| `Retail_Promotions` | `Demo_Retail_Promotions` | Price promotions |
| `Retail_Discounts` | `Demo_Retail_Discounts` | Discount rules |
| `Retail_Loyalty` | `Demo_Retail_Loyalty` | Loyalty points |

---

## DATA POPULATION STRATEGY

### Phase 1: Copy Structure
```sql
-- Create demo tables with identical structure
SELECT * INTO Demo_Retail_Stock FROM Retail_Stock WHERE 1=0;
SELECT * INTO Demo_Retail_Product FROM Retail_Product WHERE 1=0;
-- etc...
```

### Phase 2: Populate Demo Stock from Products Master
```sql
-- Insert products from master Products table into demo retail tables
INSERT INTO Demo_Retail_Product (SKU, Name, Category, Description, IsActive)
SELECT 
    ProductCode AS SKU,
    ProductName AS Name,
    Category,
    Description,
    CASE WHEN IsActive = 1 THEN 1 ELSE 0 END AS IsActive
FROM Products
WHERE ItemType IN ('Internal Product', 'External Product'); -- Exclude Raw Materials
```

### Phase 3: Generate Simulated Prices
```sql
-- Create realistic price simulation based on product category
INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, EffectiveFrom)
SELECT 
    p.ProductID,
    NULL AS BranchID, -- NULL = all branches
    CASE 
        WHEN p.Category LIKE '%Bread%' THEN ROUND(RAND(CHECKSUM(NEWID())) * (50 - 15) + 15, 2)
        WHEN p.Category LIKE '%Pastry%' THEN ROUND(RAND(CHECKSUM(NEWID())) * (80 - 25) + 25, 2)
        WHEN p.Category LIKE '%Cake%' THEN ROUND(RAND(CHECKSUM(NEWID())) * (200 - 50) + 50, 2)
        WHEN p.Category LIKE '%Cookie%' THEN ROUND(RAND(CHECKSUM(NEWID())) * (40 - 10) + 10, 2)
        ELSE ROUND(RAND(CHECKSUM(NEWID())) * (100 - 20) + 20, 2)
    END AS SellingPrice,
    GETDATE() AS EffectiveFrom
FROM Demo_Retail_Product p;
```

### Phase 4: Generate Demo Stock Quantities
```sql
-- Create variants for each product
INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
SELECT 
    ProductID,
    SKU AS Barcode,
    IsActive
FROM Demo_Retail_Product;

-- Populate stock with realistic quantities per branch
INSERT INTO Demo_Retail_Stock (VariantID, BranchID, QtyOnHand, ReorderPoint)
SELECT 
    v.VariantID,
    b.BranchID,
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * (100 - 10) + 10, 0) AS DECIMAL(18,3)) AS QtyOnHand,
    CAST(ROUND(RAND(CHECKSUM(NEWID())) * (20 - 5) + 5, 0) AS DECIMAL(18,3)) AS ReorderPoint
FROM Demo_Retail_Variant v
CROSS JOIN Branches b
WHERE b.IsActive = 1;
```

---

## APPLICATION CONFIGURATION

### Option 1: Configuration Flag (RECOMMENDED)
```vb
' In App.config or database configuration table
<add key="UseDemoTables" value="true" />

' In code
Public Class POSDataService
    Private ReadOnly _useDemoTables As Boolean
    Private ReadOnly _tablePrefix As String
    
    Public Sub New()
        _useDemoTables = Boolean.Parse(ConfigurationManager.AppSettings("UseDemoTables"))
        _tablePrefix = If(_useDemoTables, "Demo_", "")
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

### Option 2: Database Views (ALTERNATIVE)
```sql
-- Create switchable views
CREATE VIEW vw_POS_Stock AS
SELECT * FROM Demo_Retail_Stock; -- Switch to Retail_Stock when live

CREATE VIEW vw_POS_Price AS
SELECT * FROM Demo_Retail_Price; -- Switch to Retail_Price when live

-- POS always queries views, not tables directly
```

---

## GO-LIVE STRATEGY

### When Ready for Production:

**Option 1 (Config Flag):**
```xml
<!-- Change in App.config -->
<add key="UseDemoTables" value="false" />
```

**Option 2 (Views):**
```sql
-- Recreate views to point to production tables
ALTER VIEW vw_POS_Stock AS SELECT * FROM Retail_Stock;
ALTER VIEW vw_POS_Price AS SELECT * FROM Retail_Price;
```

**Option 3 (Rename Tables):**
```sql
-- Backup demo data
EXEC sp_rename 'Demo_Retail_Stock', 'Archive_Demo_Retail_Stock';

-- No code changes needed if using views
```

---

## PRICE SIMULATION RULES

### Realistic Price Ranges by Category

| Category | Min Price (ZAR) | Max Price (ZAR) | Logic |
|----------|----------------|----------------|-------|
| Bread | 15 | 50 | Basic to artisan |
| Rolls | 5 | 20 | Single to pack |
| Pastries | 25 | 80 | Danish to croissant |
| Cakes | 50 | 500 | Cupcake to wedding |
| Cookies | 10 | 40 | Single to box |
| Pies | 30 | 100 | Individual to family |
| Tarts | 20 | 150 | Mini to full size |
| Donuts | 8 | 35 | Single to dozen |
| Muffins | 15 | 45 | Single to pack |
| Biscuits | 12 | 60 | Pack sizes |

### Cost Calculation (if needed)
```sql
-- Simulate cost as 60% of selling price
UPDATE Demo_Retail_Price
SET CostPrice = ROUND(SellingPrice * 0.60, 2);
```

---

## BENEFITS OF THIS APPROACH

✅ **Zero Risk**: Production data remains untouched  
✅ **Realistic Testing**: Full POS functionality with simulated data  
✅ **Easy Switch**: Single config change or view alteration  
✅ **Parallel Development**: Can work on POS while production runs  
✅ **Data Integrity**: Demo transactions don't affect real inventory  
✅ **Rollback Safety**: Can delete all demo tables without impact  
✅ **Training Environment**: Perfect for staff training  

---

## IMPLEMENTATION CHECKLIST

- [ ] Create all `Demo_` tables with identical structure
- [ ] Populate `Demo_Retail_Product` from `Products` master
- [ ] Generate simulated prices for all products
- [ ] Create variants for all products
- [ ] Populate stock quantities for all branches
- [ ] Add product images (copy from production or use placeholders)
- [ ] Create demo customers for testing
- [ ] Implement table prefix configuration in POS code
- [ ] Test POS with demo data
- [ ] Document go-live procedure
- [ ] Create backup of demo data for future testing

---

## NEXT STEPS

1. **Create SQL Script**: `Create_Demo_Tables.sql`
2. **Create SQL Script**: `Populate_Demo_Data.sql`
3. **Update POS Code**: Add table prefix configuration
4. **Test**: Full POS workflow with demo data
5. **Document**: Go-live checklist

---

## TABLES THAT DON'T NEED DEMO VERSIONS

These tables can be shared between demo and production:

- `Branches` - Same branches for demo and production
- `Users` - Same users
- `Customers` - Can use real customers or create demo customers
- `Suppliers` - Reference data
- `GLAccounts` - Chart of accounts
- `PaymentMethods` - Reference data
- `TaxRates` - Reference data

---

**RECOMMENDATION**: Use **Option 1 (Configuration Flag)** for maximum flexibility and clarity in code.
