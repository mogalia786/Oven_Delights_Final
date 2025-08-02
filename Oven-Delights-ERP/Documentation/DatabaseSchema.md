# Oven Delights ERP - Database Schema Documentation

## Overview
This document provides a comprehensive reference for the actual database schema in the OvenDelightsERP Azure SQL database.

**Database Server:** mogalia.database.windows.net  
**Database Name:** OvenDelightsERP  
**Last Updated:** 2025-08-02

---

## Tables Overview

Based on the existing database structure, the following tables are available:

1. **AuditLog** - System audit logging
2. **Branches** - Branch/location management
3. **JournalEntries** - General ledger entries
4. **JournalEntryLines** - GL entry line items
5. **PurchaseOrders** - Purchase order management
6. **RawMaterials** - Inventory/materials management
7. **Roles** - User role definitions
8. **Suppliers** - Supplier/vendor management
9. **SystemSettings** - System configuration
10. **UserPermissions** - User access control
11. **UserSessions** - User session tracking

---

## Table Structures

### 1. Suppliers Table
**Purpose:** Manage supplier/vendor information for procurement

| Column Name | Data Type | Nullable | Default | Description |
|-------------|-----------|----------|---------|-------------|
| ID | int | No | IDENTITY | Primary key |
| SupplierCode | nvarchar | Yes | NULL | Unique supplier code |
| Name | nvarchar | Yes | NULL | Supplier company name |
| ContactPerson | nvarchar | Yes | NULL | Primary contact person |
| Email | nvarchar | Yes | NULL | Email address |
| Phone | nvarchar | Yes | NULL | Phone number |
| Address | nvarchar | Yes | NULL | Physical address |
| PaymentTerms | int | Yes | NULL | Payment terms in days |
| TaxNumber | nvarchar | Yes | NULL | Tax registration number |
| IsActive | bit | Yes | 1 | Active status |
| CreatedDate | datetime2 | Yes | getdate() | Record creation date |
| CreatedBy | int | Yes | NULL | User who created record |
| ModifiedDate | datetime2 | Yes | NULL | Last modification date |
| ModifiedBy | int | Yes | NULL | User who modified record |
| CreditLimit | decimal | Yes | NULL | Credit limit amount |
| CurrentBalance | decimal | Yes | NULL | Current outstanding balance |
| DefaultIncomeAccountID | int | Yes | NULL | Default income account |
| DefaultExpenseAccountID | int | Yes | NULL | Default expense account |

### 2. RawMaterials Table
**Purpose:** Manage inventory items and raw materials

| Column Name | Data Type | Nullable | Default | Description |
|-------------|-----------|----------|---------|-------------|
| ID | int | No | IDENTITY | Primary key |
| MaterialCode | nvarchar | Yes | NULL | Unique material code |
| Name | nvarchar | Yes | NULL | Material name |
| Description | nvarchar | Yes | NULL | Material description |
| Category | nvarchar | Yes | NULL | Material category |
| Unit | nvarchar | Yes | NULL | Unit of measure |
| CurrentStock | decimal | Yes | NULL | Current stock quantity |
| ReorderLevel | decimal | Yes | NULL | Reorder level threshold |
| StandardCost | decimal | Yes | NULL | Standard cost per unit |
| LastCost | decimal | Yes | NULL | Last purchase cost |
| AverageCost | decimal | Yes | NULL | Weighted average cost |
| PreferredSupplierID | int | Yes | NULL | Preferred supplier reference |
| IsActive | bit | Yes | 1 | Active status |
| CreatedDate | datetime2 | Yes | getdate() | Record creation date |
| CreatedBy | int | Yes | NULL | User who created record |
| ModifiedDate | datetime2 | Yes | NULL | Last modification date |
| ModifiedBy | int | Yes | NULL | User who modified record |
| InventoryAccountID | int | Yes | NULL | Inventory GL account |
| COGSAccountID | int | Yes | NULL | Cost of goods sold account |
| VarianceAccountID | int | Yes | NULL | Inventory variance account |

### 3. PurchaseOrders Table
**Purpose:** Manage purchase orders to suppliers

| Column Name | Data Type | Nullable | Default | Description |
|-------------|-----------|----------|---------|-------------|
| ID | int | No | IDENTITY | Primary key |
| PONumber | nvarchar | Yes | NULL | Purchase order number |
| SupplierID | int | Yes | NULL | Supplier reference |
| OrderDate | datetime2 | Yes | getdate() | Order date |
| RequiredDate | datetime2 | Yes | NULL | Required delivery date |
| Status | nvarchar | Yes | 'Draft' | Order status |
| SubTotal | decimal | Yes | NULL | Subtotal amount |
| VATAmount | decimal | Yes | NULL | VAT/tax amount |
| TotalAmount | decimal | Yes | NULL | Total order amount |
| Notes | nvarchar | Yes | NULL | Order notes |
| CreatedDate | datetime2 | Yes | getdate() | Record creation date |
| CreatedBy | int | Yes | NULL | User who created record |
| ModifiedDate | datetime2 | Yes | NULL | Last modification date |
| ModifiedBy | int | Yes | NULL | User who modified record |
| ApprovedBy | int | Yes | NULL | User who approved order |
| ApprovedDate | datetime2 | Yes | NULL | Approval date |

---

## Key Relationships

1. **Suppliers ↔ RawMaterials**: RawMaterials.PreferredSupplierID → Suppliers.ID
2. **Suppliers ↔ PurchaseOrders**: PurchaseOrders.SupplierID → Suppliers.ID
3. **Users ↔ All Tables**: CreatedBy, ModifiedBy, ApprovedBy → Users.UserID

---

## Important Notes

### Column Name Conventions
- Primary keys use **ID** (not TableNameID)
- Foreign keys use **TableNameID** format
- All tables have audit fields: CreatedDate, CreatedBy, ModifiedDate, ModifiedBy
- Most tables have IsActive bit field for soft deletes

### Data Types
- **nvarchar**: Variable length Unicode strings
- **decimal**: Precise decimal numbers for monetary values
- **datetime2**: High precision date/time values
- **bit**: Boolean values (0/1)
- **int**: 32-bit integers

### Nullable Fields
- Most fields are nullable to allow gradual data entry
- Primary keys and some system fields are NOT NULL
- Default values are provided where appropriate

---

## SQL Query Guidelines

### Correct Column References
```sql
-- ✅ CORRECT - Use actual column names
SELECT 
    s.ID AS SupplierID,
    s.Name AS CompanyName,
    s.ContactPerson,
    s.Email,
    s.Phone
FROM Suppliers s

-- ❌ INCORRECT - These columns don't exist
SELECT 
    s.SupplierID,  -- Should be s.ID
    s.CompanyName, -- Should be s.Name
    s.CurrentBalance, -- May not exist in all environments
    s.CreditLimit     -- May not exist in all environments
FROM Suppliers s
```

### Safe Querying with ISNULL
```sql
-- Always use ISNULL for nullable fields
SELECT 
    rm.ID AS MaterialID,
    ISNULL(rm.Name, 'Unknown Material') AS MaterialName,
    ISNULL(rm.CurrentStock, 0) AS CurrentStock,
    ISNULL(rm.ReorderLevel, 0) AS ReorderLevel
FROM RawMaterials rm
```

---

## StockroomService Query Templates

### Suppliers Query
```sql
SELECT 
    s.ID AS SupplierID,
    ISNULL(s.SupplierCode, 'SUP' + RIGHT('000' + CAST(s.ID AS VARCHAR), 3)) AS SupplierCode,
    ISNULL(s.Name, 'Unknown Supplier') AS CompanyName,
    ISNULL(s.ContactPerson, '') AS ContactPerson,
    ISNULL(s.Email, '') AS Email,
    ISNULL(s.Phone, '') AS Phone,
    ISNULL(s.Address, '') AS Location,
    ISNULL(s.PaymentTerms, 30) AS PaymentTerms,
    ISNULL(s.IsActive, 1) AS IsActive
FROM Suppliers s
ORDER BY s.Name
```

### RawMaterials Query
```sql
SELECT 
    rm.ID AS MaterialID,
    ISNULL(rm.MaterialCode, 'RM' + RIGHT('000' + CAST(rm.ID AS VARCHAR), 3)) AS MaterialCode,
    ISNULL(rm.Name, 'Unknown Material') AS MaterialName,
    ISNULL(rm.Category, 'General') AS CategoryName,
    ISNULL(rm.Unit, 'kg') AS BaseUnit,
    ISNULL(rm.CurrentStock, 0) AS CurrentStock,
    ISNULL(rm.ReorderLevel, 0) AS ReorderLevel,
    ISNULL(rm.StandardCost, 0) AS StandardCost,
    ISNULL(rm.LastCost, 0) AS LastCost,
    ISNULL(rm.AverageCost, 0) AS AverageCost
FROM RawMaterials rm
ORDER BY rm.Name
```

### PurchaseOrders Query
```sql
SELECT 
    po.ID AS PurchaseOrderID,
    ISNULL(po.PONumber, 'PO-' + RIGHT('0000' + CAST(po.ID AS VARCHAR), 4)) AS PONumber,
    ISNULL(s.Name, 'Unknown Supplier') AS SupplierName,
    ISNULL(po.OrderDate, GETDATE()) AS OrderDate,
    ISNULL(po.Status, 'Draft') AS Status,
    ISNULL(po.SubTotal, 0) AS SubTotal,
    ISNULL(po.VATAmount, 0) AS VATAmount,
    ISNULL(po.TotalAmount, 0) AS TotalAmount
FROM PurchaseOrders po
LEFT JOIN Suppliers s ON po.SupplierID = s.ID
ORDER BY po.OrderDate DESC
```

---

*This documentation should be updated whenever database schema changes are made.*
