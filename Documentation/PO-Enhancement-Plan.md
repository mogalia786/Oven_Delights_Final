# Purchase Order Enhancements Plan (Inventory Leaves + External Products)

## Goals
- Allow Stockroom PO lines for:
  - Raw Materials (existing)
  - Inventory leaf items (final node in catalog)
  - External non-manufactured products (e.g., Coca-Cola, bread, sweets)
- Show per-line preferred supplier; allow override.
- Keep current PO save, totals, and journal posting stable.

## Database
1. ExternalProducts table
   - ProductID (PK, IDENTITY)
   - ProductName (nvarchar 150, NOT NULL)
   - SKU (nvarchar 64, NULL)
   - Unit (nvarchar 16, NULL)
   - VATRate (decimal(5,2), NOT NULL default 15.00)
   - PreferredSupplierID (int, NULL, FK Suppliers)
   - LastCost (decimal(18,4), NULL)
   - IsActive (bit, NOT NULL default 1)
   - CreatedDate/By, ModifiedDate/By

2. Optional SupplierProducts map
   - SupplierID (int, FK)
   - ItemType (varchar 16: RawMaterial | InventoryItem | External)
   - ItemID (int)
   - SupplierSKU (nvarchar 64, NULL)
   - LastPrice (decimal(18,4), NULL)
   - Preferred (bit, default 0)
   - PK: SupplierID + ItemType + ItemID

3. Unified selectable items view: v_PurchaseSelectableItems
   - Columns: ItemType, ItemID, DisplayName, PreferredSupplierID, LastCost
   - UNION of:
     - RawMaterials
     - Inventory leaves (using existing inventory views; leaf = no child)
     - ExternalProducts

## Application changes
1. PurchaseOrderForm.vb
   - Replace column "Material" with new combo "Item" (DisplayMember=DisplayName, Value=(ItemType, ItemID)).
   - Add columns:
     - PreferredSupplier (read-only hint from view)
     - SupplierOverride (editable ComboBox bound to Suppliers)
   - Keep Qty/UnitCost/LastPaid/LastCost/LineTotal behavior as-is.

2. Services
   - StockroomService: add GetPurchaseSelectableItems(); resolve hints (LastPaid/LastCost) by ItemType.
   - Save: extend CreatePurchaseOrder to accept a table-valued parameter with ItemType/ItemID. Map RawMaterial as today; store InventoryItem/External with new line type fields (non-breaking shim if needed).

3. New maintenance form: ExternalProductsForm.vb
   - CRUD grid: ProductName, SKU, Unit, VATRate, PreferredSupplier, LastCost, Active.
   - Menu entry under Inventory or Stockroom.

## Migration scripts
- 37_ExternalProducts.sql (table + indexes)
- 38_SupplierProducts.sql (optional map)
- 39_v_PurchaseSelectableItems.sql (view)
- Seed example ExternalProducts rows

## Testing
- Create PO with:
  - Raw material line
  - Inventory leaf line (e.g., Decorations > Sprinkles > Rainbow Sprinkles)
  - External product line (e.g., Coca-Cola 330ml)
- Verify preferred supplier hint, optional override, totals, and journal posting.

## Notes
- No breaking change to existing raw-material-only POs.
- Can add per-branch behavior later if required.
