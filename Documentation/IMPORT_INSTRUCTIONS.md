# 📊 DATA IMPORT INSTRUCTIONS
## Oven Delights ERP - Product & Supplier Import Templates

**Date:** 2025-10-03  
**Purpose:** Import existing products and suppliers into the ERP system

---

## 📋 TEMPLATES PROVIDED

### **1. IMPORT_TEMPLATE_PRODUCTS.csv**
Template for importing all products (both External and Manufactured)

### **2. IMPORT_TEMPLATE_SUPPLIERS.csv**
Template for importing all suppliers

---

## 📝 PRODUCT TEMPLATE INSTRUCTIONS

### **Column Definitions:**

| Column | Required | Description | Example |
|--------|----------|-------------|---------|
| **ProductCode** | ✅ Yes | Unique product code (max 50 chars) | `BRD-WHT-001` |
| **ProductName** | ✅ Yes | Full product name (max 150 chars) | `White Bread Loaf 700g` |
| **SKU** | ✅ Yes | Barcode/SKU for scanning (max 50 chars) | `7001234567890` |
| **ItemType** | ✅ Yes | `External` or `Manufactured` | `External` |
| **CategoryName** | ✅ Yes | Product category | `Bread` |
| **SubcategoryName** | ⚠️ Optional | Product subcategory | `Loaves` |
| **UnitOfMeasure** | ✅ Yes | Unit (ea, kg, L, box, etc.) | `ea` |
| **ReorderPoint** | ⚠️ Optional | Minimum stock level before reorder | `50` |
| **SellingPrice** | ✅ Yes | Retail selling price (ZAR) | `25.00` |
| **LastPaidPrice** | ⚠️ Optional | Last purchase price (for External only) | `18.50` |
| **AverageCost** | ⚠️ Optional | Average cost (calculated for Manufactured) | `19.00` |
| **Description** | ⚠️ Optional | Product description | `Fresh white bread loaf` |
| **IsActive** | ✅ Yes | `TRUE` or `FALSE` | `TRUE` |

### **ItemType Rules:**

**External Products:**
- Purchased finished goods (Coke, Bread from suppliers, Chips, etc.)
- Set `ItemType = External`
- Must have `LastPaidPrice` (what you pay supplier)
- Goes directly to Retail_Stock when invoice captured

**Manufactured Products:**
- Products you make (Cakes, Croissants, Artisan Bread, etc.)
- Set `ItemType = Manufactured`
- `LastPaidPrice = 0.00` (you don't buy these)
- `AverageCost` calculated from BOM ingredients
- Goes to Retail_Stock after Complete Build

### **Example Rows:**

**External Product (Purchased):**
```csv
BEV-COKE-330,Coca-Cola 330ml Can,5449000000996,External,Beverages,Soft Drinks,ea,100,12.00,8.50,9.00,Coca-Cola 330ml can,TRUE
```

**Manufactured Product (Made In-House):**
```csv
CKE-CHOC-001,Chocolate Cake Slice,CAKE001,Manufactured,Cakes,Slices,ea,20,45.00,0.00,25.00,Homemade chocolate cake slice,TRUE
```

---

## 📝 SUPPLIER TEMPLATE INSTRUCTIONS

### **Column Definitions:**

| Column | Required | Description | Example |
|--------|----------|-------------|---------|
| **CompanyName** | ✅ Yes | Supplier company name | `Coca-Cola Beverages SA` |
| **ContactPerson** | ⚠️ Optional | Primary contact name | `John Smith` |
| **Email** | ✅ Yes | Supplier email | `orders@ccbsa.co.za` |
| **Phone** | ⚠️ Optional | Office phone | `011-123-4567` |
| **Mobile** | ⚠️ Optional | Mobile phone | `082-123-4567` |
| **Address** | ⚠️ Optional | Street address | `123 Main Road` |
| **City** | ⚠️ Optional | City | `Johannesburg` |
| **Province** | ⚠️ Optional | Province | `Gauteng` |
| **PostalCode** | ⚠️ Optional | Postal code | `2000` |
| **Country** | ⚠️ Optional | Country | `South Africa` |
| **VATNumber** | ⚠️ Optional | VAT registration number | `4123456789` |
| **BankName** | ⚠️ Optional | Supplier's bank name | `FNB`, `ABSA`, `Nedbank`, `Standard Bank`, `Capitec` |
| **BranchCode** | ⚠️ Optional | Bank branch code | `250655` |
| **AccountNumber** | ⚠️ Optional | Supplier's bank account number | `62123456789` |
| **PaymentTerms** | ⚠️ Optional | Payment terms | `30 Days` |
| **CreditLimit** | ⚠️ Optional | Credit limit (ZAR) | `50000.00` |
| **IsActive** | ✅ Yes | `TRUE` or `FALSE` | `TRUE` |
| **Notes** | ⚠️ Optional | Additional notes | `Main beverage supplier` |

### **Example Row:**
```csv
Coca-Cola Beverages SA,John Smith,orders@ccbsa.co.za,011-123-4567,082-123-4567,123 Main Road,Johannesburg,Gauteng,2000,South Africa,4123456789,ACC001,30 Days,50000.00,TRUE,Main beverage supplier
```

---

## 📋 FILLING OUT THE TEMPLATES

### **Step 1: Download Templates**
1. Open `IMPORT_TEMPLATE_PRODUCTS.csv` in Excel/Google Sheets
2. Open `IMPORT_TEMPLATE_SUPPLIERS.csv` in Excel/Google Sheets

### **Step 2: Delete Example Rows**
- Keep the header row (first row)
- Delete all example data rows
- Start entering your actual data

### **Step 3: Fill in Your Data**

**For Products:**
1. List ALL products you sell (both purchased and manufactured)
2. Mark purchased items as `External`
3. Mark items you make as `Manufactured`
4. Include barcodes/SKUs for scanning
5. Set realistic selling prices
6. For External products, include what you pay suppliers

**For Suppliers:**
1. List ALL suppliers you purchase from
2. Include complete contact information
3. Include VAT numbers for tax compliance
4. Set payment terms (e.g., "30 Days", "COD", "45 Days")
5. Set credit limits if applicable

### **Step 4: Save Files**
- Save as CSV format (not Excel format)
- Keep original filenames
- Send both files back

---

## 🔧 IMPORT PROCESS (We Will Handle This)

### **Step 1: Import Suppliers First**
```sql
-- We will run this script to import suppliers
BULK INSERT Suppliers
FROM 'IMPORT_TEMPLATE_SUPPLIERS.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
```

### **Step 2: Import Products**
```sql
-- We will run this script to import products
-- Categories and Subcategories will be auto-created if they don't exist
-- Products will be created with correct ItemType
```

### **Step 3: Verify Import**
- Check all products imported correctly
- Check all suppliers imported correctly
- Verify ItemType is correct (External vs Manufactured)
- Verify prices are correct

---

## ⚠️ IMPORTANT NOTES

### **Product Codes:**
- Must be UNIQUE
- Use a consistent naming convention
- Examples:
  - `BRD-WHT-001` (Bread - White - 001)
  - `BEV-COKE-330` (Beverage - Coke - 330ml)
  - `CKE-CHOC-001` (Cake - Chocolate - 001)

### **Barcodes/SKUs:**
- Must be UNIQUE
- Use actual barcodes for External products
- Create custom codes for Manufactured products
- Format: Numbers only or alphanumeric

### **ItemType:**
- **External** = You BUY this finished product from suppliers
  - Examples: Coke, Bread from bakery, Chips, Sweets
  - Will have LastPaidPrice
  
- **Manufactured** = You MAKE this product in-house
  - Examples: Cakes, Croissants, Artisan Bread, Pastries
  - LastPaidPrice = 0.00
  - Cost calculated from ingredients (BOM)

### **Prices:**
- Use decimal format: `25.00` not `R25` or `25`
- No currency symbols
- No spaces or commas in numbers

### **Boolean Values:**
- Use `TRUE` or `FALSE` (not Yes/No or 1/0)
- Case-insensitive (TRUE, True, true all work)

---

## 📊 SAMPLE DATA INCLUDED

### **Products (10 examples):**
- 5 External products (Bread, Beverages, Snacks)
- 5 Manufactured products (Cakes, Croissants, Artisan Bread)

### **Suppliers (10 examples):**
- Major SA suppliers (Coca-Cola, Tiger Brands, Nestlé, etc.)
- Complete contact information
- Realistic payment terms

**Delete these examples and replace with your actual data!**

---

## ✅ CHECKLIST BEFORE SENDING

- [ ] All required columns filled in
- [ ] ProductCode is unique for each product
- [ ] SKU/Barcode is unique for each product
- [ ] ItemType is correct (External or Manufactured)
- [ ] Selling prices are correct
- [ ] LastPaidPrice filled for External products
- [ ] Supplier emails are correct
- [ ] Supplier VAT numbers included
- [ ] Files saved as CSV format
- [ ] Example rows deleted (only your data remains)

---

## 📧 SEND FILES TO

**Email:** your-email@ovendelights.co.za  
**Subject:** Product & Supplier Data Import  
**Attachments:**
- IMPORT_TEMPLATE_PRODUCTS.csv
- IMPORT_TEMPLATE_SUPPLIERS.csv

---

## 🆘 NEED HELP?

**Questions about:**
- Which products are External vs Manufactured?
- How to format data?
- Missing information?

**Contact:** your-phone-number

---

## 📝 NOTES SECTION (For Client)

Use this space to note any special requirements or questions:

_____________________________________________
_____________________________________________
_____________________________________________
_____________________________________________
_____________________________________________
