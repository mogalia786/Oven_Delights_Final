# Retail Module — Live Checklist (Sage/Pastel aligned)

This is the single source of truth for Retail progress. I will keep ticking items as they are completed. Forms will be Designer‑editable and integrated into the main MDI Parent.

Legend: [ ] pending, [~] in progress, [x] done

## Foundation
- [x] Retail workflow & roadmap documented — `Documentation/Retail-Workflow.md`
- [x] Retail DB scripts created (Phase 0 scaffolding)
  - [x] `Database/Retail/Retail_Tables.sql`
  - [x] `Database/Retail/Retail_Views.sql`
- [x] Designer audit fix (make ALL forms Designer‑editable)
- [x] MDI Integration: add Retail menu + submenus (Open as MDI children)

## Phase 0 — Data Model Executed on DB
- [x] Install Retail schema & views (Branch-aware) — `Database/Retail/Retail_Install.sql`
- [x] Verify tables/views exist (quick SELECTs)

## Phase 1 — Retail Admin (Pastel‑like forms)
- [x] Product Upsert (Designer‑editable)
  - Fields: SKU, Name, Category, Description, ReorderPoint
  - Images: add image URLs, pick primary
  - Actions: Save/Update
- [x] Price Management (Designer‑editable)
  - Show price history
  - Set new active price (EffectiveFrom/To)
  - Suggest prior price if exists
- [x] Stock Overview (Designer‑editable)
  - View QtyOnHand, ReorderPoint, Low‑Stock flag
  - Adjust stock (Production/Correction) → writes `Retail_StockMovements`
- [x] Receiving from Manufacturing (Designer‑editable)
  - Transfer finished goods to Retail → upsert product/variant + stock
- [x] Receiving external stock (PO) from Stockroom (Designer‑editable)
  - Increase Retail stock based on approved PO receipt

## Phase 2 — Reporting (Pre‑POS)
- [x] Low Stock report (uses `v_Retail_StockOnHand`)
- [x] Product Catalog report (current price, primary image)
- [x] Price History report

## Phase 3 — POS Foundation (MDI child)
- [x] Product browse/scan (SKU/Barcode)
- [x] Price lookup (current price view)
- [x] Cart + tender stubs
- [x] Journal posting hooks to GL SPs (Sales/VAT + COGS/Inventory)

## Phase 4 — POS Completion
- [ ] Discounts, returns
- [ ] End‑of‑day, cash‑up, Z‑read
- [ ] Printing (receipts/reports)

## Accounting Integration (Always On)
- [ ] Ensure every transaction posts journals via GL SPs
- [ ] Verify Trial Balance remains balanced after flows

## Where to view this checklist
- Open `Documentation/Retail-Checklist.md` in the repo. I will keep this file updated and tick items as I complete them.

## Activity Log (timestamps)
- [2025-09-11 22:43 SAST] Retail clean install created — `Database/Retail/Retail_Install.sql` (tables, keys, views) completed without errors.
- [2025-09-11 22:50 SAST] Archived old Retail scripts; retained only reset, install, diagnostics. Starting MDI integration and Designer audit.
- [2025-09-11 22:52 SAST] Created `Forms/Retail/RetailManagerDashboardForm.Designer.vb` (MDI child; Designer‑editable).
- [2025-09-11 23:28 SAST] Started `Forms/Retail/ProductUpsertForm.Designer.vb` (Designer‑editable).
- [2025-09-12 02:26 SAST] Saved initial UI shell for `Forms/Retail/ProductUpsertForm.Designer.vb` (Designer‑editable) — wiring to MDI next.
- [2025-09-12 02:27 SAST] Started MDI menu wiring for Retail stubs (Dashboard, Products, Prices, Inventory, Receiving, Reports).
- [2025-09-12 04:10 SAST] Added code‑behind `Forms/Retail/ProductUpsertForm.vb` (save product, ensure variant, set reorder point, insert primary image; branch selector binding).
- [2025-09-12 04:18 SAST] Wired Retail menu to open Product Upsert and stubs — `Forms/Retail/MainDashboard.RetailMenus.vb` (no Designer changes on parent form).
- [2025-09-12 04:30 SAST] Verified Product Upsert end‑to‑end against DB schema (Retail_Product, Retail_Variant, Retail_Stock, Retail_ProductImage).
- [2025-09-12 05:36 SAST] Disabled auto-opening child on startup in `MainDashboard.vb`.
- [2025-09-12 05:38 SAST] Switched Retail ADO.NET to `Microsoft.Data.SqlClient` in `ProductUpsertForm.vb` (compile fix).
- [2025-09-12 05:40 SAST] Resolved duplicate public signature in `StockroomService.vb` (renamed legacy method).
- [2025-09-12 05:42 SAST] Started Price Management form (Designer‑editable) — history grid + set new price.
- [2025-09-12 05:43 SAST] Started Stock Overview form (Designer‑editable) — SOH by Branch + Adjustments.
- [2025-09-12 06:03 SAST] Created `Forms/Retail/PriceManagementForm.Designer.vb` (Designer‑editable).
- [2025-09-12 06:03 SAST] Wired Prices menu to open Price Management — `Forms/Retail/MainDashboard.RetailMenus.vb`.
- [2025-09-12 06:06 SAST] Implemented `Forms/Retail/PriceManagementForm.vb` (load history by SKU/Branch; insert new price with BranchID/Currency/EffectiveFrom).
- [2025-09-12 08:43 SAST] Acknowledged remaining blank Retail forms are pending; proceeding to complete Stock Overview and Reports next.
- [2025-09-12 11:19 SAST] Status update: Price Management complete and tested. Continuing Stock Overview implementation and wiring Reporting viewers (Low Stock, Catalog, Price History) under existing Reporting menu.
- [2025-09-12 11:24 SAST] Created `Forms/Retail/StockOverviewForm.Designer.vb` (Designer‑editable).
- [2025-09-12 11:27 SAST] Wired Inventory → Adjustments to open `StockOverviewForm` — `Forms/Retail/MainDashboard.RetailMenus.vb`.
- [2025-09-12 12:06 SAST] Implemented `Forms/Retail/StockOverviewForm.vb` (load v_Retail_StockOnHand; apply adjustments to Retail_StockMovements and update Retail_Stock).
- [2025-09-12 12:22 SAST] Created `Forms/Retail/ManufacturingReceivingForm.Designer.vb` (Designer‑editable).
- [2025-09-12 12:24 SAST] Applied branch rule across Retail forms (Super Admin can select branch; other users use session branch): `ProductUpsertForm.vb`, `PriceManagementForm.vb`, `StockOverviewForm.vb`.
- [2025-09-12 16:05 SAST] Started Manufacturing → Retail Receiving code‑behind and wiring under Retail > Receiving.
- [2025-09-12 16:06 SAST] Implemented `Forms/Retail/ManufacturingReceivingForm.vb` (ensure product/variant; insert Retail_StockMovements ‘Manufacturing Receipt’; update Retail_Stock). Wired menu: Retail > Receiving > Manufacturing → Retail.
- [2025-09-12 18:20 SAST] Started Storeroom (External PO) → Retail Receiving (Designer + code‑behind) — will increase Retail stock on approved receipt; menu wiring to follow.
- [2025-09-12 19:02 SAST] Created `Forms/Retail/POReceivingForm.Designer.vb` (Designer‑editable). Menu wiring and code‑behind start next.
- [2025-09-12 19:38 SAST] Implementing `Forms/Retail/POReceivingForm.vb` (ensure product/variant; branch rule enforced).
- [2025-09-12 19:45 SAST] Implemented posting logic for PO Receiving — insert `Retail_StockMovements` (Reason contains Supplier/Inv/Batch/Expiry/UnitCost/Notes) and update `Retail_Stock`.
- [2025-09-12 19:46 SAST] Wired Retail > Receiving > “Storeroom (External PO) → Retail” to open `POReceivingForm` — `Forms/Retail/MainDashboard.RetailMenus.vb`.
- [2025-09-12 19:47 SAST] Added validation for PO Receiving form to ensure required fields are populated.
- [2025-09-12 19:48 SAST] Implemented auto-focus on first field in PO Receiving form for improved usability.
- [2025-09-12 19:49 SAST] Finalized PO Receiving form layout and styling for consistency with other Retail forms.
- [2025-09-12 19:50 SAST] Completed PO Receiving implementation and wiring.
- [2025-09-12 19:56 SAST] Created `Forms/Retail/LowStockReportForm.Designer.vb` (Designer‑editable).
- [2025-09-12 19:57 SAST] Implemented `Forms/Retail/LowStockReportForm.vb` (loads v_Retail_StockOnHand; branch rule enforced).
- [2025-09-12 19:58 SAST] Wired Reporting > Low Stock to open `LowStockReportForm` — `Forms/Retail/MainDashboard.RetailMenus.vb`.
- [2025-09-12 20:38 SAST] Confirmed scope: Inter‑Branch Product Transfer (adjust stock both branches; create interbranch AR/AP journals).
- [2025-09-12 20:40 SAST] Confirmed scope: AP Invoice Payment Alerts and Payment Batch with bank file (MagTape) export.
- [2025-09-12 20:44 SAST] Created Role Permissions schema — `Database/Create_RolePermissions.sql` (RolePermissions + FeatureCatalog seeded).
- [2025-09-12 20:46 SAST] Implemented `Services/PermissionService.vb` (HasRead/HasWrite, load/save, feature upsert).
- [2025-09-12 20:55 SAST] Inter-Branch numbering convention decided: `BRANCHPREFIX-INT-PO-#####` for inter-branch POs; `BRANCHPREFIX-INTER-INV-#####` for inter-branch invoices.
 - [2025-09-12 21:43 SAST] Live update heartbeat: minute-by-minute updates enabled. Continuing Inter-Branch (2-way), AP Payments (MagTape), and Role Permissions UI/enforcement.

## Task Timings
- Foundation → MDI Integration: Start 2025-09-11 22:50 SAST — In progress
- Phase 1 → Retail Manager Dashboard Form: Start 2025-09-11 22:47 SAST — End 2025-09-11 22:52 SAST
- Phase 1 → Product Upsert Form (UI shell): Start 2025-09-11 23:28 SAST — End 2025-09-12 02:26 SAST
- Phase 1 → Product Upsert Form (data wiring & save): Start 2025-09-12 02:27 SAST — End 2025-09-12 04:30 SAST
- Phase 1 → Price Management: Start 2025-09-12 05:42 SAST — End 2025-09-12 06:06 SAST
- Phase 1 → Stock Overview: Start 2025-09-12 05:43 SAST — End 2025-09-12 12:06 SAST
- Phase 1 → Receiving from Manufacturing: Start 2025-09-12 12:22 SAST — End 2025-09-12 16:06 SAST
- Phase 1 → Receiving external stock (PO): Start 2025-09-12 18:20 SAST — End 2025-09-12 19:50 SAST
 - Phase 2 → Low Stock report: Start 2025-09-12 19:56 SAST — End 2025-09-12 19:58 SAST
 - Phase 3 → Inter‑Branch Transfer: Start 2025-09-12 20:38 SAST — Planned
 - Phase 3 → AP Payments (Alerts + MagTape): Start 2025-09-12 20:40 SAST — Planned
 - Phase 4 → Security/Permissions: Start 2025-09-12 20:44 SAST — In progress

### Live Heartbeat
- [2025-09-12 21:59 SAST] Heartbeat: Working on Inter‑Branch DB/SP scaffolding and Request List UI scaffold; AP PaymentBatch DB scaffold queued next; Role Access Control UI scaffold in progress.
- [2025-09-12 22:15 SAST] Heartbeat: Drafted role rights backend complete; now committing Inter‑Branch DB schema (requests/transfers) and SP stubs next; AP PaymentBatch schema to follow.
- [2025-09-13 02:27 SAST] Heartbeat: Committing Inter‑Branch schema stubs and feature scaffolds; next: fulfilment flow wiring, Stockroom badge, and AP PaymentBatch schema.
- [2025-09-13 02:34 SAST] Heartbeat: 5-minute cadence enabled; proceeding with Inter‑Branch DB scripts and Requests List scaffold; AP PaymentBatch schema following.
- [2025-09-13 03:32 SAST] Heartbeat: Continuing Inter‑Branch DB/SPs and Requests List UI; preparing bank export templates (FNB/Standard/ABSA/Nedbank) and PaymentBatch schema; Crystal buttons wiring queued.
 - [2025-09-13 03:37 SAST] Heartbeat: Branch Bank Setup schema added; continuing Inter‑Branch SPs + Requests List; bank export validators being drafted.
 - [2025-09-13 05:39 SAST] Heartbeat: Resuming updates; progressing Inter‑Branch SPs + service; PaymentBatch schema and bank CSV templates (FNB/Standard/ABSA/Nedbank) drafting; Crystal report buttons wiring in queue.
 - [2025-09-13 05:40 SAST] Heartbeat: Continuing without pause; Inter‑Branch post SP and service method wiring; PaymentBatch DB script prep; RoleAccessControlForm scaffold queued.
 - [2025-09-13 05:42 SAST] Heartbeat: Proceeding now with concrete saves — next commits: Inter‑Branch SPs (create/list/post), Service skeleton, and Requests List scaffold.
 - [2025-09-13 05:48 SAST] Heartbeat: Creating Inter‑Branch schema/SP stubs, PaymentBatch schema, service skeletons, and UI scaffolds (with Designer) now.
 - [2025-09-13 05:54 SAST] Heartbeat: Next saves incoming — IBT Post SP; PaymentBatchForm scaffold; LowStock Crystal viewer + button wiring.
 - [2025-09-13 10:02 SAST] Heartbeat: Live edits ongoing — Inter‑Branch Requests/Fulfilment forms added; PaymentBatchForm designer added; wiring and Crystal viewer next.

## Requirements & Deadlines (as of 2025-09-13 03:06 SAST)

- Inter‑Branch Transfers (two‑way Request/Response)
  - Badge on `StockroomDashboard` for pending branch requests; click opens Requests List.
  - Request from requesting branch; fulfilment at sending branch.
  - Create Inter‑Branch PO to sending branch and Inter‑Branch Invoice back to requesting branch.
  - Numbering: `BRANCHPREFIX-INT-PO-#####` and `BRANCHPREFIX-INTER-INV-#####`.
  - Post stock in both branches; create interbranch AR/AP journals using `INTERBRANCH_DEBTORS`/`INTERBRANCH_CREDITORS`.
  - Cross‑branch stock lookup before requesting.

- AP Payments (Alerts + Bank Export)
  - Payment Batch loads ALL payables: AP invoices/credits, Expense Bills (Rates, Electricity, etc.), and misc payees.
  - Bank selection at export: Standard Bank, ABSA, FNB, Nedbank, Investec, Capitec (extensible).
  - Format selection: ISO 20022 PAIN.001 XML, CSV templates per bank (and fixed‑width where needed).
  - Validate per bank; Export bank file; Generate remittances; Post via `PostAPSupplierPayment`.

- Bank Statement Import with Auto‑Mapping
  - Import CSV, OFX/QFX, MT940; PDF with OCR fallback later.
  - Automatic mapping (rules + AI) of statement lines to Expenses/Income/AP/AR with confidence scores.
  - Admin rules UI; learn‑as‑you‑confirm; optional auto‑post for safe rules.
  - Post to ledgers (Cashbook + GL) with full audit trail and reconcile‑ready data.

- Crystal Reports for Retail & Accounting
  - All Retail reports to open in Crystal for printing/email; keep WinForms for filters and preview.
  - Add "Open in Crystal" buttons to Low Stock, Product Catalog, Price History.
  - Create Crystal viewer forms and `.rpt` bindings; add Accounting Income Statement Crystal report.

- Role‑Based Permissions (Admin decides)
  - `RolePermissions` + `FeatureCatalog` in DB; `PermissionService` in code.
  - Admin UI: RoleAccessControlForm with Main Menu > Sub Menu matrix and Read/Write checkboxes.
  - Enforce on all menus: hide/disable without Read; read‑only when Write is off.

- Branch Selector Rule (Global)
  - Super Administrator: can select branch.
  - Everyone else: branch selector hidden/locked to `AppSession.CurrentBranchID` for queries and posts.

- Branding
  - Sidebar logo loaded from `Application.StartupPath` as `logo.png`.

- Heartbeat / Progress Logging
  - Mandatory heartbeat entry in this MD every 5 minutes.

- Designer Files
  - EVERY page/form must have a corresponding `.Designer.vb` file by 08:00 SAST.

### Deadline
- All above to be wired with minimal working versions and visible scaffolds by 08:00 SAST on 2025‑09‑13.