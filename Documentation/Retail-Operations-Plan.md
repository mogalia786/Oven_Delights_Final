# Retail Operations & Inventory Movement Plan

Author: Finance & Systems
Date: 2025-08-28

## Objectives
- Ensure seamless movement of goods from Manufacturing/Stockroom to Retail.
- Support barcodes (GS1-compliant) and optional serial/lot tracking.
- Enable accurate accounting for COGS, inventory, and inter-branch transfers (IBT).
- Prepare for POS integration and product scanning.

## Scope
- Stock Transfers: Factory/Stockroom -> Retail Branch stores.
- POS Sales: Decrement retail stock, post revenue and COGS.
- Barcodes: GTIN/EAN/UPC support; internal SKUs maintained.
- Serial/Lot: Optional per product.

## Process Design

### 1) Inter-Branch Transfer (IBT)
- Use a 2-step process (Transfer Order + Receipt) per retail best practice.
  - Create Transfer Order (From Location, To Branch/Store, Items, Quantities, Cost).
  - Dispatch: reduce stock at Source (in-transit status if needed).
  - Receive at Retail: increase stock at Destination.
- References:
  - Inventory transfers 2-step model (ERPLY): https://wiki.erply.com/article/904-inventory-transfers
  - IBT overview (Alice POS): https://alicepos.com/ibt-retail/

### 2) Accounting for Transfers
- No P&L impact on IBT; move inventory at cost between branches.
- Journal entries at transfer receipt (within same company):
  - DR Retail Inventory
  - CR Manufacturing/Raw or FG Inventory (or Inter-Branch Clearing if using clearing accounts)
- Option A (direct): DR RetailInventory; CR FGInventory.
- Option B (clearing):
  - At dispatch: DR Inter-Branch Out; CR FGInventory.
  - At receipt: DR RetailInventory; CR Inter-Branch In (net zero).
- Configure via `GLAccountMappings`:
  - "RetailInventory", "FinishedGoodsInventory", "InterBranchOut", "InterBranchIn".

### 3) POS Sales & COGS
- POS transaction reduces Retail Inventory and posts COGS and Revenue:
  - DR COGS
  - CR RetailInventory
  - DR Cash/Bank/AR
  - CR Sales Revenue
- Ensure category-level mappings: Revenue, COGS, Inventory, Write-Offs.
  - Ref: https://www.hubifi.com/blog/point-of-sale-accounting

## Barcoding & Product Identification

### 4) SKU vs GTIN
- Maintain internal SKU per product variant (size, flavor, pack).
- Store external barcode (GTIN: EAN-13/UPC, etc.).
- If we sell own-branded items externally, acquire GS1 company prefix.
- References:
  - GS1 Barcodes: https://www.gs1.org/standards/barcodes
  - Get barcodes/GTIN: https://www.gs1.org/standards/get-barcodes
  - GTIN vs SKU: https://coastlabel.com/what-is-a-gtin-number/

### 5) Symbologies in scope
- Retail scanning: EAN-13/UPC-A.
- Cases/logistics: ITF-14 or GS1-128.
- Extended data (expiry, lot): GS1-128 with AIs (e.g., (10)=Lot, (17)=Expiry).
  - References: GS1-128: https://www.gs1us.org/upcs-barcodes-prefixes/gs1-128 , GS1 General Spec.

## Serial and Lot Tracking (Optional per Product)
- Enable flags per product: `IsSerialTracked`, `IsLotTracked`, `ExpiryRequired`.
- Capture on receipt to Retail (or GRN at factory), propagate through POS/returns.
- References:
  - Lot/Serial best practices: https://www.netsuite.com/portal/resource/articles/inventory-management/understanding-how-lot-and-serial-numbers-are-used-for-inventory-management.shtml
  - Microsoft guidance: https://learn.microsoft.com/en-us/dynamics365/business-central/inventory-how-work-item-tracking

## Data Model Changes

Tables (new or extended):
- Products: add `Barcode` (nvarchar(32)), `IsSerialTracked` bit, `IsLotTracked` bit, `ExpiryRequired` bit.
- BranchStocks (existing or new): `ProductID`, `BranchID`, `OnHand`, `Reserved`.
- IBTHeaders: `IBTID`, `FromLocationID`, `ToBranchID`, `Status`, `DispatchDate`, `ReceiveDate`, `CreatedBy`.
- IBTLines: `IBTLineID`, `IBTID`, `ProductID`, `Quantity`, `UnitCost`, `LotNo` (nullable), `SerialNo` (nullable), `ExpiryDate` (nullable).
- POSHeaders/POSLines (or extend existing Sales tables): hold branch, cashier, tender lines.
- SerialLots: For tracked items at branch level: `ProductID`, `BranchID`, `LotNo`/`SerialNo`, `Qty`, `ExpiryDate`.

Constraints/Indexes:
- Unique `(BranchID, ProductID)` on BranchStocks.
- Barcode index on Products.Barcode.
- Optional uniqueness on SerialNo per Product.

## Services & Logic

### IBT Service
- Create Transfer Order (pending).
- Dispatch: validate stock, reserve/decrement at source, write audit, create GL lines (if clearing used).
- Receive: increment destination stock, handle lot/serial capture, finalize GL.

### POS Service
- Scan barcode → resolve `ProductID` via `Products.Barcode`.
- Price from price list; tax rules per branch.
- Commit sale: inventory decrement at branch, COGS & revenue posting.

### GRN & PO Integration
- Allow PO lines for products (already added via `38_Add_POL_Product_Support.sql`).
- GRN supports products without adjusting RawMaterials stock (already added via `39_Add_GRNL_Product_Support.sql`).
- For finished goods produced internally, use WIP → FG capitalization before IBT to retail.

## GL Mapping Keys (proposed)
- `FinishedGoodsInventory`
- `RetailInventory`
- `InterBranchOut`
- `InterBranchIn`
- `SalesRevenue:<Category>` (optional by category)
- `COGS:<Category>` (optional by category)

## UI/UX
- Retail Transfer screen (TO/Dispatch/Receive tabs).
- POS screen: barcode input, product grid, quantities, price override with role control.
- Serial/lot capture dialog on receive/sale when item requires it.

## Retail Navigation Menus

Proposed menu map for the Retail module. This reflects the flows in this document and keeps Inventory (raw materials) vs Products (finished goods) distinct.

```text
Retail
  ├─ POS
  │   ├─ New Sale (Scan/Lookup)
  │   ├─ Hold/Resume Sales
  │   ├─ Returns/Refunds
  │   └─ Daily Z Report (Close)
  │
  ├─ Products
  │   ├─ Internal Products (Manufactured)
  │   │    ├─ List & Search (Today-only toggle)
  │   │    ├─ Reorder (Create BOM Bundle → select Manufacturer)
  │   │    └─ Labels/Barcodes
  │   ├─ External Products (Purchased)
  │   │    ├─ List & Search
  │   │    ├─ Price Lists
  │   │    └─ Labels/Barcodes
  │   └─ Categories & Taxes
  │
  ├─ Inventory (Retail Branch)
  │   ├─ Stock on Hand
  │   ├─ Adjustments (Write-off, Count)
  │   ├─ Serial/Lot (Query) [if enabled]
  │   └─ Reorder Points (Alerts)
  │
  ├─ Transfers (IBT)
  │   ├─ Transfer Orders
  │   │    ├─ Create
  │   │    ├─ Dispatch
  │   │    └─ Receive
  │   └─ In-Transit
  │
  ├─ Purchasing
  │   ├─ Purchase Orders
  │   │    ├─ New PO (Inventory or Product)
  │   │    ├─ Approve
  │   │    └─ Receive (GRN)
  │   ├─ Suppliers
  │   └─ Price Agreements
  │
  ├─ Manufacturing (Hand-off)
  │   ├─ Producer Dashboard (Today-only)
  │   └─ Complete Build (BOM → FG to Retail)
  │
  ├─ Reports
  │   ├─ Stock on Hand by Branch
  │   ├─ Sales by Product/Category
  │   ├─ Margins
  │   ├─ Transfers (In-Transit)
  │   └─ Adjustments & Write-offs
  │
  └─ Settings
      ├─ Barcodes (GTIN mapping)
      ├─ GL Mappings (RetailInventory, FGInventory, InterBranch, COGS/Revenue)
      ├─ Serial/Lot Policies
      └─ Roles & Access (POS overrides, approvals)
```

## Implementation Phasing
1. Schema: add Products.Barcode and tracking flags; create IBT tables.
2. Services: IBT create/dispatch/receive with GL; branch stock updates.
3. POS (MVP): scan → sell → post inventory/COGS/revenue.
4. Serial/Lot optional layer.
5. Reporting: stock on hand by branch, transfers in transit, sales by product, margin.

## Open Issues / Next Actions
- Fix PO visibility and false "already GRV'd" condition in invoice capture list.
- Ensure product list shows actual products (e.g., Coke) in GRN/PO UI.
- Configure GL mappings for Retail.

## References
- Inter-Branch Transfer: https://alicepos.com/ibt-retail/
- Inventory Transfer 2-step: https://wiki.erply.com/article/904-inventory-transfers
- POS accounting mapping: https://www.hubifi.com/blog/point-of-sale-accounting
- GS1 Barcodes overview: https://www.gs1.org/standards/barcodes
- Get GTIN/Barcodes: https://www.gs1.org/standards/get-barcodes
- GS1-128: https://www.gs1us.org/upcs-barcodes-prefixes/gs1-128
- Lot/Serial Tracking: https://www.netsuite.com/portal/resource/articles/inventory-management/understanding-how-lot-and-serial-numbers-are-used-for-inventory-management.shtml
- Microsoft BC Item Tracking: https://learn.microsoft.com/en-us/dynamics365/business-central/inventory-how-work-item-tracking

---

## Manufacturing Model: Inventory → Components → Product

Concepts and flow used by Build My Product (BOM):

```text
[Inventory (Raw Materials)]
  - Flour, Sugar, Salt, Toppings, Flavourings, etc.
        |
        |  (BOM step: combine inventories)
        v
[Components (Subassemblies)]
  - Dough = Flour + Salt + Water
  - Fresh Cream = Milk + Sugar + etc.
        |
        |  (BOM step: combine components [+ optional inventory])
        v
[Product (Finished Good)]
  - Ready-made, sellable item
        |
        |  (Manufacturing completion)
        v
[Retail Products (Sellable Stock)]
```

Example BOM tree:

```text
Product: Chocolate Cake
  ├─ Component: Cake Base
  │    ├─ Inventory: Flour
  │    ├─ Inventory: Sugar
  │    ├─ Inventory: Eggs
  │    └─ Inventory: Butter
  ├─ Component: Filling (Fresh Cream)
  │    ├─ Inventory: Milk
  │    ├─ Inventory: Sugar
  │    └─ Inventory: Vanilla
  └─ Component: Topping
       ├─ Inventory: Chocolate
       └─ Inventory: Sprinkles
```

Key distinctions:

- Inventory = inputs for production (not sellable directly as products in retail)
- Components = intermediate builds from inventory
- Products = final output of manufacturing; goes to Retail Products and is sold

## Purchase Order (PO) Routing

```text
                  +--------------------+
PO Line: Inventory| Flour / Sugar / ...|  --->  Increases [Inventory], not retail products
                  +--------------------+

                  +--------------------+
PO Line: Product  | Cake / Pastry / ...|  --->  Increases [Retail Products] directly
                  +--------------------+
```

Notes:

- PO for Inventory (raw materials, subsidiaries, toppings, flavorings): increases Inventory stock; does not enter Retail Products.
- PO for Product (finished goods): increases Retail Products directly.
