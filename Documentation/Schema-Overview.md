# Oven Delights ERP – Database Schema Overview

- Database name: `Oven_Delights_Main`
- Platform: Microsoft SQL Server
- Default schema: `dbo`
- Monetary fields: `decimal(18,2)` (unless noted)
- Date fields: `date` or `datetime`/`datetime2` as per script

## Core Security and Admin

- Users (`dbo.Users`)
  - Keys: `UserID` (PK)
  - Important fields: `Username` (unique), `Email` (unique), `PasswordHash`, `Salt`, `RoleID` (FK), `BranchID` (FK), audit fields
- Roles (`dbo.Roles`)
  - Keys: `RoleID` (PK), `RoleName` unique
- Permissions (`dbo.Permissions`), RolePermissions (`dbo.RolePermissions`)
  - FKs: `RoleID` → `Roles`, `PermissionID` → `Permissions`
- Branches (`dbo.Branches`)
  - Keys: `BranchID` (PK), branch profile info
- AuditLog (`dbo.AuditLog`)
  - Logs user actions, FKs to `Users`
- SystemSettings (`dbo.SystemSettings`)
  - Key/value settings, optional FK to `Users`
- UserSessions, UserPreferences, PasswordHistory, Notifications, UserNotifications

## Accounting Core

- GLAccounts (`dbo.GLAccounts`)
  - `AccountID` (PK), `AccountNumber` unique, `AccountName`, `AccountType` (Asset/Liability/Equity/Revenue/Expense), `BalanceType` (D/C), parent self-FK, `OpeningBalance`
- FiscalPeriods (`dbo.FiscalPeriods`)
  - `PeriodID` (PK), `StartDate`, `EndDate`, `IsClosed`
  - Constraint: `CK_FiscalPeriods_DateRange (StartDate <= EndDate)`
- JournalHeaders (`dbo.JournalHeaders`)
  - `JournalID` (PK), `JournalDate`, `Reference`, `Description`, `FiscalPeriodID` (FK), `CreatedBy`, `BranchID`, `IsPosted`, `PostedDate`, `PostedBy`
- JournalDetails (`dbo.JournalDetails`)
  - `JournalDetailID` (PK), `JournalID` (FK, cascade delete), `LineNumber`, `AccountID` (FK), `Debit`, `Credit`, optional references
  - Index: `IX_JournalDetails_AccountID`
- Stored Procedures
  - `sp_CreateJournalEntry(@JournalDate, @Reference, @Description, @FiscalPeriodID, @CreatedBy, @BranchID, @JournalID OUTPUT)`
  - `sp_AddJournalDetail(@JournalID, @AccountID, @Debit, @Credit, ..., @LineNumber OUTPUT)`
  - `sp_PostJournal(@JournalID, @PostedBy)` – validates existence, posting state, balanced Dr/Cr; sets posted flags
  - `sp_GenerateTrialBalance(@AsOfDate, @BranchID = NULL, @IncludeZeroBalances = 1)` – computes balances from posted journals + opening balances

## Stockroom Module

- Suppliers (`dbo.Suppliers`)
  - `SupplierID` (PK), `SupplierCode` unique, company/contact info, credit terms/limits, audit FKs
- ProductCategories (`dbo.ProductCategories`)
  - `CategoryID` (PK), `CategoryCode` unique, name, audit
- RawMaterials (`dbo.RawMaterials`)
  - `MaterialID` (PK), `MaterialCode` unique, `CategoryID` (FK), costs and stock levels, `PreferredSupplierID` (FK)
  - Indexes: `IX_RawMaterials_CategoryID`, `IX_RawMaterials_Code`
- PurchaseOrders (`dbo.PurchaseOrders`)
  - `PurchaseOrderID` (PK), `PONumber` unique, `SupplierID` (FK), `BranchID` (FK), amounts, approval and audit fields
- PurchaseOrderLines (`dbo.PurchaseOrderLines`)
  - `POLineID` (PK), `PurchaseOrderID` (FK), `MaterialID` (FK), quantities/costs; index on `PurchaseOrderID`
- GoodsReceivedNotes (`dbo.GoodsReceivedNotes`)
  - `GRNID` (PK), `GRNNumber` unique, link to `PurchaseOrders`/`Suppliers`, amounts, audit
- GRNLines (`dbo.GRNLines`)
  - `GRNLineID` (PK), `GRNID` (FK), `POLineID` (FK), `MaterialID` (FK)
- StockMovements (`dbo.StockMovements`)
  - `MovementID` (PK), `MaterialID` (FK), types, quantities/values, references; index on `(MaterialID, MovementDate DESC)`
- StockAdjustments (`dbo.StockAdjustments`) and StockAdjustmentLines (`dbo.StockAdjustmentLines`)
  - Headers with approval/audit; lines compute adjustment qty and value
- StockTransfers (`dbo.StockTransfers`) and StockTransferLines (`dbo.StockTransferLines`)
  - Inter-branch transfers with approval/audit

## Database Management Utilities

- ErrorLog (`dbo.ErrorLog`) and `dbo.uspLogError` – centralized error capture
- `dbo.sp_ExecuteSQLScript` – dynamic execution with logging
- DatabaseVersion (`dbo.DatabaseVersion`) and `dbo.usp_LogDatabaseVersion` – track schema versioning

## Conventions and Notes

- Posting control: Journals rely on `IsPosted`; balances derived from details; no direct running balance in `GLAccounts`.
- Branch-awareness: Many transactional tables include `BranchID` for multi-branch operations (align with warehousing requirements).
- UI guideline: All reference data must be searchable/autocomplete on capture forms (per project rule).
- Sage-aligned: Design follows Sage Pastel Evolution features; see `Documentation/pastel_features.md` for canonical behavior.

## Next Steps / Gaps

- Document numbering (`DocumentNumbering`) object(s) to be added and referenced by PO/GRN/Adjustments/Journals where applicable.
- Add warehousing granularity (multi-warehouse/bin locations) per requirements memory; tie into stock movements.
- Add indexes/constraints review for performance and data integrity across Stockroom and Accounting.

Last updated: 2025-08-17
