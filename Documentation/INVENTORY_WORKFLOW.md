# OVEN DELIGHTS ERP - COMPLETE INVENTORY WORKFLOW

## OVERVIEW
This document describes the complete inventory flow from purchase to sale, including manufacturing and inter-branch transfers.

---

## 1. PURCHASE ORDER → INVOICE CAPTURE FLOW

### A. EXTERNAL PRODUCTS (Finished Goods)
**Examples:** Coke, Bread, Water, Ready-made items  
**ItemType:** `'External'` in Products table

**Flow:**
```
Purchase Order (External Product)
    ↓
Capture Invoice
    ↓
DIRECTLY Updates: Retail_Products_Inventory (Retail_Stock)
    ↓
Updates: Products.LastPaidPrice (tracks supplier price)
    ↓
Available for Retail Sale
```

**Database Impact:**
- Table: `Products` (ItemType='External') / `Retail_Stock`
- Updates: `LastPaidPrice` column with purchase price
- Ledger: DR Inventory (Products), CR Accounts Payable

---

### B. RAW MATERIALS (Ingredients)
**Examples:** Butter, Flour, Salt, Sugar, Eggs

**Flow:**
```
Purchase Order (Raw Material)
    ↓
Capture Invoice
    ↓
Updates: Stockroom_Inventory (RawMaterials)
    ↓
Updates: RawMaterials.LastPaidPrice (tracks supplier price)
    ↓
Available for Manufacturing
```

**Database Impact:**
- Table: `RawMaterials` / `Stockroom_Inventory`
- Updates: `LastPaidPrice` column with purchase price
- Ledger: DR Inventory (Raw Materials), CR Accounts Payable

---

## 2. MANUFACTURING FLOW (Bill of Materials)

### STEP 1: Issue to Manufacturing
**Process:**
```
Manufacturer Requests Ingredients (BOM)
    ↓
System REDUCES: Stockroom_Inventory (Ingredients)
    ↓
System ADDS: Manufacturing_Inventory (Ingredients)
```

**Database Impact:**
- Reduce: `Stockroom_Inventory` quantities
- Increase: `Manufacturing_Inventory` quantities
- Ledger: DR Manufacturing Inventory, CR Stockroom Inventory

---

### STEP 2: Complete Build (Product Created)
**Process:**
```
Manufacturer Completes Build
    ↓
System REDUCES: Manufacturing_Inventory (Ingredients consumed)
    ↓
System CALCULATES: Cost of Sale (sum of ingredient costs)
    ↓
System CREATES/UPDATES: Product with ItemType='Manufactured'
    ↓
System ADDS: Retail_Products_Inventory (Finished Product)
```

**Database Impact:**
- Reduce: `Manufacturing_Inventory` (ingredients used)
- Increase: `Retail_Products_Inventory` (finished product)
- Update: `Products` table with ItemType='Manufactured'
- Update: Product cost with calculated cost of sale (NOT LastPaidPrice)
- Ledger: DR Finished Goods Inventory, CR Manufacturing Inventory

**Note:** Manufactured products do NOT have LastPaidPrice - their cost comes from BOM calculation

---

## 3. INVENTORY TABLES (THREE LEVELS)

### A. STOCKROOM INVENTORY
**Table:** `RawMaterials` / `Stockroom_Inventory`
**Contains:**
- Raw Materials (Ingredients): Butter, Flour, Salt
- External Products (before retail): Items awaiting retail transfer

**Purpose:** Central warehouse for ingredients and incoming external products

---

### B. MANUFACTURING INVENTORY
**Table:** `Manufacturing_Inventory` (Work-in-Progress)
**Contains:**
- Ingredients issued to manufacturing
- Work-in-progress items

**Purpose:** Track ingredients allocated to manufacturing

---

### C. RETAIL PRODUCTS INVENTORY
**Table:** `Products` / `Retail_Stock`
**Contains:**
- Manufactured products (ItemType='Manufactured') from manufacturing
- External products (ItemType='External') purchased complete

**Purpose:** Products available for retail sale

**Product Differentiation:**
- **Manufactured Products**: Created via BOM, cost from ingredients
- **External Products**: Purchased complete, LastPaidPrice tracked

---

## 4. STOCK REPORTS REQUIRED

### A. Stockroom Stock Report
**Shows:**
- Raw Materials (Ingredients) quantities and values
- External Products awaiting retail transfer
- By Branch
- Stock movements (in/out)

---

### B. Manufacturing Stock Report
**Shows:**
- Work-in-progress ingredients
- Issued to manufacturing
- By Branch
- Manufacturing orders in progress

---

### C. Retail Products Report
**Shows:**
- Finished products available for sale
- By Branch
- Stock levels, reorder points
- Cost of sale per product

---

## 5. STOCK ADJUSTMENTS

### When Adjustments are Made:
**Actions Required:**
1. Update physical stock quantities
2. Update corresponding General Ledger accounts:
   - **Cost of Sale** (for write-offs)
   - **Inventory Accounts** (asset values)
   - **Variance Accounts** (gains/losses)

**Ledger Entries:**
- **Stock Write-off:** DR Cost of Sale, CR Inventory
- **Stock Gain:** DR Inventory, CR Variance Income
- **Stock Loss:** DR Variance Expense, CR Inventory

---

## 6. INTER-BRANCH TRANSFER WORKFLOW

### CURRENT ISSUES:
- Missing: From Branch dropdown
- Missing: To Branch dropdown
- Missing: Product selection dropdown

---

### REQUIRED FEATURES:

#### A. Transfer Form Fields
```
From Branch: [Dropdown - Sender Branch]
To Branch: [Dropdown - Receiver Branch]
Product: [Dropdown - Product Selection]
Quantity: [Number]
Transfer Date: [Date]
Reference: [Auto-generated: BranchPrefix-iTrans-Number]
```

---

### B. Transfer Process

#### SENDER BRANCH (From Branch):
```
1. Reduce Inventory Quantity
2. Create Document: BranchPrefix-iTrans-Number
3. Ledger Entry:
   DR Inter-Branch Debtors (Receivable)
   CR Inventory
```

**Example:**
- Branch A sends 10 units of Product X to Branch B
- Document: BRA-iTrans-00001
- DR Inter-Branch Debtors (Branch B) R1,000
- CR Inventory (Product X) R1,000

---

#### RECEIVER BRANCH (To Branch):
```
1. Increase Inventory Quantity
2. Reference Same Document: BranchPrefix-iTrans-Number
3. Ledger Entry:
   DR Inventory
   CR Inter-Branch Creditors (Payable)
```

**Example:**
- Branch B receives 10 units of Product X from Branch A
- Document: BRA-iTrans-00001 (same reference)
- DR Inventory (Product X) R1,000
- CR Inter-Branch Creditors (Branch A) R1,000

---

### C. Reconciliation
- Both branches use **same document reference**
- Sender's Debtor = Receiver's Creditor
- Amounts must match for reconciliation
- Inter-branch accounts should net to zero across all branches

---

## 7. COMPLETE FLOW DIAGRAM

```
┌─────────────────────────────────────────────────────────┐
│              PURCHASE ORDER ENTRY                       │
│                 (Entry Point)                           │
└─────────────────┬───────────────────────────────────────┘
                  │
        ┌─────────┴─────────┐
        │                   │
┌───────▼────────┐  ┌──────▼──────────┐
│ EXTERNAL       │  │ RAW MATERIALS   │
│ PRODUCTS       │  │ (Ingredients)   │
│ (Finished)     │  │                 │
└───────┬────────┘  └──────┬──────────┘
        │                   │
        │           ┌───────▼──────────┐
        │           │ STOCKROOM        │
        │           │ INVENTORY        │
        │           └───────┬──────────┘
        │                   │
        │           ┌───────▼──────────┐
        │           │ Issue to         │
        │           │ MANUFACTURING    │
        │           └───────┬──────────┘
        │                   │
        │           ┌───────▼──────────┐
        │           │ MANUFACTURING    │
        │           │ INVENTORY (WIP)  │
        │           └───────┬──────────┘
        │                   │
        │           ┌───────▼──────────┐
        │           │ Complete Build   │
        │           │ (Product Created)│
        │           └───────┬──────────┘
        │                   │
        └───────┬───────────┘
                │
        ┌───────▼──────────┐
        │ RETAIL PRODUCTS  │
        │ INVENTORY        │
        │ (Ready for Sale) │
        └──────────────────┘
```

---

## 8. LEDGER ACCOUNTS SUMMARY

### Inventory Accounts (Assets):
- **Stockroom Inventory** (Raw Materials + External Products)
- **Manufacturing Inventory** (Work-in-Progress)
- **Finished Goods Inventory** (Retail Products)

### Inter-Branch Accounts:
- **Inter-Branch Debtors** (Receivables from other branches)
- **Inter-Branch Creditors** (Payables to other branches)

### Expense Accounts:
- **Cost of Sale** (when products sold or written off)
- **Variance Expense** (stock losses)

### Income Accounts:
- **Variance Income** (stock gains)

---

## 9. BRANCH-SPECIFIC CONSIDERATIONS

### All Inventory Operations MUST Include:
- **BranchID** in all transactions
- **Stock levels are branch-specific**
- **Each branch has separate inventory**
- **Inter-branch transfers required for stock movement**

### User Access:
- **Regular Users:** See only their branch inventory
- **Super Admin:** See all branches, can transfer between branches

---

## 10. IMPLEMENTATION CHECKLIST

### Purchase Order & Invoice Capture:
- [x] Purchase Order form with Product Type selection
- [x] Material dropdown filters by type (External/Raw Material)
- [ ] Invoice capture updates correct inventory table based on type
- [ ] Ledger entries for purchases

### Manufacturing:
- [ ] Bill of Materials (BOM) management
- [ ] Issue to Manufacturing form
- [ ] Manufacturing Inventory tracking
- [ ] Complete Build form
- [ ] Cost of Sale calculation
- [ ] Ledger entries for manufacturing

### Stock Reports:
- [ ] Stockroom Stock Report
- [ ] Manufacturing Stock Report
- [ ] Retail Products Report
- [ ] All reports branch-aware

### Stock Adjustments:
- [ ] Stock adjustment form
- [ ] Automatic ledger entries
- [ ] Variance tracking

### Inter-Branch Transfer:
- [x] From Branch dropdown
- [x] To Branch dropdown
- [x] Product selection dropdown
- [x] Document numbering: BranchPrefix-iTrans-Number
- [ ] Sender: DR Debtors, CR Inventory (placeholder)
- [ ] Receiver: DR Inventory, CR Creditors (placeholder)
- [ ] Reconciliation report

### Product ItemType and LastPaidPrice:
- [x] Products.ItemType: 'Manufactured' or 'External'
- [x] Products.LastPaidPrice: For external products only
- [x] RawMaterials.LastPaidPrice: For all raw materials
- [x] Database script created: Update_Products_ItemType_And_LastPaid.sql

---

**Document Version:** 1.1  
**Last Updated:** 2025-09-30 20:00  
**Status:** ACTIVE SPECIFICATION
