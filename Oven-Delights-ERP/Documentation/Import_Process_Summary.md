# Import Process Summary

## Overview
This document explains how CSV data is imported into the ERP system, covering all tables and business rules.

---

## Data Classification

### 1. **Raw Materials (Ingredients)**
- **Category**: `ingredients`
- **Destination**: `RawMaterials` table
- **Branch**: NOT branch-specific (master data)
- **Examples**: Flour, Butter, Salt, Sugar
- **NOT included in**: Products table, POS system

### 2. **Sub-Assemblies (Sub-components)**
- **Category**: `buttercream`, `freshcream 1mx500`, `sub recipe`
- **Destination**: `SubAssemblies` table
- **Branch**: NOT branch-specific (master data)
- **Examples**: Buttercream mix, Fresh cream preparations
- **NOT included in**: Products table, POS system

### 3. **Finished Products - Internal**
- **Category**: `biscuit`, `biscuits`, `exotic`, `cakes`, `drinks`, etc.
- **Item Category**: `internal`
- **Destination**: 
  - `Products` table (master)
  - `ProductInventory` (branch-specific)
  - `Demo_Retail_Product` (POS)
- **Examples**: Biscuit Choc Chip, BD Bar One Square
- **Barcode**: Generated from Code field (2 + 8-digit padded)

### 4. **Finished Products - External**
- **Category**: `candle`, etc.
- **Item Category**: `external`
- **Destination**: 
  - `Products` table (master)
  - `ProductInventory` (branch-specific)
  - `Demo_Retail_Product` (POS)
- **Examples**: Candles, pre-packaged goods
- **Barcode**: Uses existing barcode from supplier

### 5. **Accessories**
- **Category**: `consumables`, `miscellaneous`
- **Destination**: Same as Finished Products
- **Examples**: Packaging, disposables

---

## Table Structure

### Master Tables (Branch-Independent)

#### **Products Table**
- Contains: External products + Internal finished goods + Accessories
- Does NOT contain: Raw materials, Sub-assemblies
- Fields:
  - `ProductCode`: Item code from CSV
  - `ProductName`: Item description
  - `SKU`: Generated barcode (or external barcode)
  - `ItemType`: 'Internal', 'External', or 'Accessory'
  - `LastPaidPrice`: Cost from CSV
  - `AverageCost`: Average cost across branches
  - `SellingPrice`: Average selling price (InclVAT)

#### **RawMaterials Table**
- Contains: Ingredients only
- Fields:
  - `MaterialCode`: Item code
  - `MaterialName`: Item description
  - `LastPaidPrice`: Cost from CSV

---

### Branch-Specific Tables

#### **ProductInventory Table**
- Links Products to Branches
- One record per Product per Branch
- Fields:
  - `ProductID`: FK to Products
  - `BranchID`: 6 (OD200) or 4 (OD400)
  - `QtyOnHand`: Current stock level
  - `ReorderLevel`: Minimum stock threshold

---

### POS Tables (Demo_Retail)

#### **Demo_Retail_Product**
- Mirror of Products table for POS
- Fields:
  - `Code`: Item code from CSV
  - `Name`: Item description
  - `ProductType`: 'Internal' or 'External'
  - `ExternalBarcode`: Real barcode (external products only)
  - `SKU`: Generated or external barcode

#### **Demo_Retail_Variant**
- One default variant per product
- Fields:
  - `VariantName`: 'Default'
  - `IsDefault`: 1

#### **Demo_Retail_Price**
- Branch-specific pricing with VAT
- Fields:
  - `ProductID`: FK to Demo_Retail_Product
  - `BranchID`: 6 (OD200) or 4 (OD400)
  - `SellingPrice`: Price including 15% VAT
  - `SellingPriceExVAT`: Price excluding VAT (calculated: InclVAT / 1.15)
  - `CostPrice`: Cost from CSV

#### **Demo_Retail_Stock**
- Branch-specific stock levels
- Fields:
  - `VariantID`: FK to Demo_Retail_Variant
  - `BranchID`: 6 (OD200) or 4 (OD400)
  - `QtyOnHand`: Current stock level

---

## Barcode Generation Logic

### Internal Products
```
Code: "BIS-CHC-EAC"
Generated Barcode: "2" + RIGHT('00000000' + 'BISCHCEAC', 8)
Result: "2CHCEAC" (2 + 8 digits)
```

### External Products
```
Code: "CAN-MAG-24S"
Barcode from CSV: "8004"
Result: "8004" (use as-is)
```

---

## VAT Calculations

### Pricing Structure
- **CSV Price**: Includes 15% VAT
- **SellingPrice (InclVAT)**: Direct from CSV
- **SellingPriceExVAT**: Calculated as `InclVAT / 1.15`

### Example
```
CSV Price: R115.00 (InclVAT)
ExVAT Price: R115.00 / 1.15 = R100.00
VAT Amount: R15.00
```

---

## Branch Handling

### Both Branches Imported
- OD200 (Ayesha Centre) → BranchID = 6
- OD400 (Umhlanga) → BranchID = 4

### Branch-Specific Data
Each product gets:
1. One record in `Products` (master, branch-independent)
2. Two records in `ProductInventory` (one per branch)
3. One record in `Demo_Retail_Product` (master)
4. Two records in `Demo_Retail_Price` (one per branch with different prices)
5. Two records in `Demo_Retail_Stock` (one per branch)

### Example
```
Product: "Biscuit Choc Chip"
Code: "BIS-CHC-EAC"

Products table: 1 record
  - ProductCode: "BIS-CHC-EAC"
  - SellingPrice: Average of R80 and R85 = R82.50

ProductInventory: 2 records
  - BranchID 6, QtyOnHand: 0
  - BranchID 4, QtyOnHand: 0

Demo_Retail_Price: 2 records
  - BranchID 6, SellingPrice: R80.00, ExVAT: R69.57
  - BranchID 4, SellingPrice: R85.00, ExVAT: R73.91
```

---

## Import Process Steps

### 1. Run Schema Update
```sql
-- Run: Update_Demo_Retail_Product_Schema.sql
-- This adds required columns and clears old data
```

### 2. Generate SQL from CSV
```
1. Open ERP → Utilities → CSV to SQL Converter
2. Click "Convert CSV Files to SQL"
3. Copy generated SQL
```

### 3. Run Comprehensive Import
```sql
-- Run: Comprehensive_Import_Script.sql
-- Paste generated INSERT statements into staging section
-- Execute full script
```

### 4. Verify Import
Check summary report at end of script:
- Raw Materials count
- Products count
- Product Inventory records (should be 2x products)
- Demo_Retail_Product count
- Demo_Retail_Price records (should be 2x products)
- Demo_Retail_Stock records (should be 2x products)

---

## What's Covered

✅ **Products Table (Master)**: External + Internal finished goods only  
✅ **Branch Independence**: Master table not tied to specific branch  
✅ **Branch-Specific Pricing**: Different prices per branch  
✅ **VAT Calculations**: InclVAT and ExVAT columns  
✅ **Both Branches**: OD200 and OD400 imported separately  
✅ **Barcode Generation**: Code → SKU with proper formatting  
✅ **Raw Materials**: Separate table, not in Products  
✅ **Sub-Assemblies**: Separate table, not in Products  
✅ **Last Paid Price**: Cost from CSV used as LastPaidPrice  
✅ **Stockroom Integration**: ProductInventory created per branch  

---

## Notes

- Initial stock levels set to 0 (adjust via Stock Adjustment forms)
- Categories and Subcategories need manual mapping (CategoryID = NULL initially)
- UoM defaults to 'EA' (Each) - adjust as needed
- Products with missing codes are skipped
- Duplicate products (same code) are skipped
