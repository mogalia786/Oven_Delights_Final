# Oven Delights ERP — Accounting Module (Sage/Pastel Aligned)

This document tracks the live rollout of the full double-entry accounting module aligned with Sage/Pastel practices. I will update this log and the checklists as I deliver each piece so you can see progress at a glance.

## Overview
- Double-entry GL core: Accounts, Journals, JournalLines, SystemAccounts (account mapping keys).
- Centralized posting service for AP, AR, Expenses, and Bank (Cashbook).
- Reporting: Journal drill, Ledger drill with running balance, Trial Balance, Income Statement (P&L), Balance Sheet, AP/AR Ageing.
- Inventory/COGS and GRNI clearing wired where applicable.

## System Account Keys (mapping)
The posting service resolves account IDs from a mapping table (SystemAccounts or SystemSettings) using these keys:
- AP_CONTROL, AR_CONTROL
- INVENTORY, GRNI, PURCHASE_RETURNS
- SALES, SALES_RETURNS, COS
- VAT_INPUT, VAT_OUTPUT
- BANK_DEFAULT, BANK_CHARGES, ROUNDING

You can change the actual AccountIDs later without code changes; the service will pick up the new mappings.

## Posting Coverage (checklist)
- [ ] AP: Supplier Invoice (DR Inventory/GRNI; CR AP Control)
- [x] AP: Supplier Credit Note on returns (DR AP Control; CR Purchase Returns/Inventory)
- [ ] AP: Supplier Payment (DR AP Control; CR Bank)
- [ ] AR: Customer Invoice (DR AR; CR Sales [+VAT]; DR COGS; CR Inventory)
- [ ] AR: Customer Credit Note (reverse Sales/VAT; adjust Inventory if goods returned)
- [ ] AR: Customer Receipt (DR Bank; CR AR)
- [ ] Expenses: Bill (DR Expense [+VAT Input]; CR AP/Bank)
- [ ] Expenses: Payment (DR AP; CR Bank) or direct cashbook (DR Expense; CR Bank)
- [ ] Bank: Journal/Charges/Transfers (cashbook with reconciliation flags)

## Reporting Views (to be provided in Database/GL_Core_Views.sql)
- v_JournalLines_ByJournal (JournalID)
- v_JournalLines_ByAccountWithRunning (AccountID, dates)
- v_TrialBalance (period)
- v_IncomeStatement (period)
- v_BalanceSheet (period)
- v_AP_AgeAnalysis, v_AR_AgeAnalysis

## How to Test (quick)
1) Journal drill: `SELECT * FROM v_JournalLines_ByJournal WHERE JournalID = @id;`
2) Ledger drill: `SELECT * FROM v_JournalLines_ByAccountWithRunning WHERE AccountID = @id AND JournalDate BETWEEN @From AND @To ORDER BY JournalDate, JournalID, LineNumber;`
3) TB/P&L/BS: run the respective views for a period.
4) AP/AR Ageing: run v_AP_AgeAnalysis and v_AR_AgeAnalysis.

## Progress Log (live)
- 2025-09-09 — Added `Services/StockroomService.UpdateInvoiceWithJournal` to persist edits, create supplier credit note (when ReturnQty > 0), and attempt AP reduction posting through AccountingPostingService.
- 2025-09-10 — Starting GL core scripts (idempotent): tables (Accounts, Journals, JournalLines), SystemAccounts, posting SPs (Create/Add/Post), and reporting views. Wiring AccountingPostingService with generic posting routines.
- [10-Sep-2025 09:39 SAST] DB: added `Database/GL_Core_Tables.sql` (Accounts, Journals, JournalLines with cashbook fields, SystemAccounts). Idempotent and ready for SPs/Views.

- [10-Sep-2025 13:04 SAST] DB: added `Database/GL_SystemAccounts_Seed.sql` (creates if missing and seeds keys: AP_CONTROL, AR_CONTROL, INVENTORY, GRNI, PURCHASE_RETURNS, SALES, SALES_RETURNS, COS, VAT_INPUT, VAT_OUTPUT, BANK_DEFAULT, BANK_CHARGES, ROUNDING).
- [10-Sep-2025 13:06 SAST] DB: added `Database/GL_Core_SPs.sql` (idempotent) providing: `sp_CreateJournalEntry`, `sp_AddJournalDetail`, `sp_PostJournal`.
- [10-Sep-2025 13:08 SAST] DB: added `Database/GL_Core_Views.sql` (idempotent) providing: `v_JournalLines_ByJournal`, `v_JournalLines_ByAccountWithRunning`, `v_TrialBalance`, `v_IncomeStatement`, `v_BalanceSheet`, `v_AP_AgeAnalysis`, `v_AR_AgeAnalysis`.
- [10-Sep-2025 13:09 SAST] Code: updated `Services/AccountingPostingService.vb` — `GetSystemAccountId(key)` now queries `dbo.SystemAccounts`.

- [10-Sep-2025 13:48 SAST] DB: added `Database/GL_Posting_Procedures.sql` (AP/AR/Expenses/Bank posting procs: `sp_AP_Post_SupplierInvoice`, `sp_AP_Post_SupplierCredit`, `sp_AP_Post_SupplierPayment`, `sp_AR_Post_CustomerInvoice`, `sp_AR_Post_CustomerCredit`, `sp_AR_Post_CustomerReceipt`, `sp_Exp_Post_Bill`, `sp_Exp_Post_Payment`, `sp_Bank_Post_Charge`, `sp_Bank_Post_Transfer`) and helper `dbo.ufn_GetSystemAccountId`.

- [10-Sep-2025 17:05 SAST] Docs: added Setup & Run Order and Smoke Test sections below.

## Notes
- All SQL will be idempotent (safe to re-run).
- Posting routines are centralized so AP/AR/Expenses/Bank all follow Sage-like double-entry patterns.
- Cashbook (Bank) includes receipts, payments, transfers, charges, and running balances with reconciliation-ready flags.

## Setup and Run Order (Azure SQL)
Run these scripts in this exact order against your database:
1) `Database/GL_Core_Tables.sql`
2) `Database/GL_SystemAccounts_Seed.sql`
3) `Database/GL_Core_SPs.sql`
4) `Database/GL_Core_Views.sql`
5) EITHER set your own mappings in `dbo.SystemAccounts` OR run `Database/GL_Accounts_MinimalSeed.sql`
6) `Database/GL_Posting_Procedures.sql`

After running, verify mappings:
```sql
SELECT * FROM dbo.SystemAccounts ORDER BY SysKey;
```

## Smoke Test
Run this script to post sample AP/AR/Expense/Bank journals and query views:
- `Database/GL_SmokeTest.sql`

Quick verification queries:
```sql
SELECT TOP 50 * FROM dbo.v_TrialBalance ORDER BY AccountCode;
SELECT TOP 50 * FROM dbo.v_JournalLines_ByJournal ORDER BY JournalID, LineNumber;
SELECT TOP 50 * FROM dbo.v_JournalLines_ByAccountWithRunning ORDER BY AccountID, JournalDate, JournalID, LineNumber;
```
