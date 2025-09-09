<!-- LIVE EDIT: This file was modified at your request for verification. -->
# Sage Pastel Evolution ERP – Features & Module Guidelines

This document summarizes the core features, modules, and best practices of Sage Pastel Evolution ERP, serving as a guideline for developing and evaluating ERP modules for Oven-Delights-ERP.

---

## Core Modules & Features

### 1. User Defined Fields (UDFs)
- Add custom fields to master files (customers, suppliers, inventory, etc.) and transactions.
- Supports business-specific data, reporting customization, filtering, grouping, and analytics.
- Admin UI for adding fields (name, type, length, default).

### 2. General Ledger (GL)
- Central repository for all financial transactions.
- Chart of accounts (COA): code, description, type, reporting group.
- Journal entries: standard, recurring, reversing, adjustments/accruals.
- Multi-period (13), batch/approval, multi-currency, budgeting, drill-down, audit trail.
- Integrates with all modules for double-entry.

### 3. Accounts Receivable (AR)
- Customer master file: details, credit terms/limits, sales rep, tax, group/category.
- Transactions: invoices, credit notes, receipts, journals (batch/real-time GL posting).
- Statements, aging analysis, reminders.

### 4. Contact Management (CRM Basics)
- Centralized contacts (customers, suppliers, prospects, agents).
- Multi-contact per account, comms history, document/interaction tracking, scheduling.
- CRM/accounting integration.

### 5. Inventory Management
- Stock master file: code, desc, barcode, UOM, price, serial/batch, categories.
- Warehousing: multi-warehouse, bin/location, transfers.
- Costing: FIFO, weighted avg, standard, last cost.
- Transactions: receipts, issues, adjustments, transfers.
- Integration: sales, invoicing, POS, purchase, GRN, GL auto-journal.
- Reporting: valuation, movement, reorder, transaction history.
- Add-ons: BOM, serial/lot/multi-warehouse.

### 6. Order Entry
- Quotations, sales orders, stock allocation, backorders.
- Invoicing (partial/multi-stage), delivery notes.
- Discounts/pricing (lists, structures, promos).
- Document control, audit trail.

### 7. Bill of Materials (BOM) & Manufacturing
- BOM: recipes, components, quantities, multi-level/sub-assemblies.
- Manufacturing: advance/kit, WIP, cost tracking, by-products, reporting, audit trail.
- Production planning/scheduling, real-time inventory updates, profitability analysis.

### 8. Warehousing
- Multi-warehouse, bin locations, stock tracking, transfers, reorder levels.
- Warehouse-specific transactions, stock takes, reporting/analysis.
- Integration: sales, purchase, job costing, BOM, serial/batch.
- User permissions, advanced add-ons (bin zoning, WMS, multi-currency/language).

### 9. Segmented Inventory
- Track inventory by multiple user-defined segments (size, color, etc.).
- Variant-level costing, reporting, integration with core inventory, BOM.

### 10. Segmented Accounts & GL Master/Sub-Account
- Multi-segment GL (up to 10 segments: main + sub-accounts).
- Flexible setup, segment value assignment, reporting/drill-down, data integrity.
- Master/sub-account hierarchy, inheritance, granular reporting.

### 11. Bank Manager
- Automated bank statement import (OFC, CSV, QIF, MT940).
- Intelligent mapping (GL, suppliers, customers, projects).
- Batch export/reconciliation, split transactions, summaries, mapping improvements.

### 12. Retail (POS)
- Integrated POS for cash/card sales, stock, customer accounts.
- Fast transactions, cash management, real-time inventory, loyalty, multi-store, security.
- Offline/online, LAN/WAN, SDK for integration.

### 13. SIC Report Manager & Report Writer
- Advanced report designer (drag-drop, dynamic fields, grouping, filters, export, Crystal Reports).
- Custom layouts, branding, management reports.

### 14. Branch Accounting
- Centralized control, branch autonomy, inter-branch transactions, branch-level/consolidated reporting, data sync, branch-specific controls.
- Master file distribution (items, customers, suppliers from head office).

### 15. System Audit Manager
- Tracks/logs all DB activity (who/what/when/how), supports compliance, fraud detection, audit trail.
- Configurable per table/action, logs filter/export.

### 16. Delivery Management
- Structured dispatch, partial deliveries, search/tracking, documentation, status, enquiry interface.
- Centralized queue, status visibility, compliance, efficiency, flexibility.

### 17. Mobility (Evolution Mobile)
- Real-time access to inventory, sales, quotes, orders via mobile (Android/iOS).
- Dashboards/KPIs, offline sync, signature capture, mapping, email confirmations.
- Integrates with core modules, third-party solutions.

### 18. Inventory Optimisation
- Stock/reorder/min-max/multi-warehouse management.
- Add-ons: forecasting, reorder point, safety stock, ABC analysis, reporting/alerts.

---

## Best Practices & Implementation Notes
- Align all code, models, queries, forms, and logic with the above features.
- Ensure all modules support extensibility, reporting, and auditability.
- Use this document as a checklist and reference for module development.
- Update as new features or changes are introduced.
