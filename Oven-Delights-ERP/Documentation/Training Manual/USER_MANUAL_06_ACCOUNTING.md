# Accounting Module
## User Training Manual - Complete Guide

**Version:** 1.0  
**Last Updated:** October 2025  
**Module:** Accounting & Finance

---

## Table of Contents

1. [Module Overview](#module-overview)
2. [Menu Structure](#menu-structure)
3. [Master Data](#master-data)
4. [Cash Book](#cash-book)
5. [Banking](#banking)
6. [Reports](#reports)
7. [Accounts Payable](#accounts-payable)

---

## Module Overview

### Purpose

The Accounting module manages all financial transactions and reporting. It controls:

- Cash book management (Main and Petty Cash)
- General ledger
- Accounts payable
- Financial reporting
- Bank reconciliation
- Expense management

### Who Can Access

**Primary Users:**
- Accountant (full access)
- Financial Manager (full access)
- Branch Manager (cash book access)
- Bookkeeper (data entry)

### Financial Flow

```
Transactions → Cash Books → General Ledger → Financial Statements
```

---

## Menu Structure

```
Accounting
├── Master Data
│   ├── Expense Types
│   └── Expenses
├── Cash Book
│   ├── Main Cash Book
│   ├── Petty Cash
│   └── Ledger Viewer
├── Cash Book Journal (Legacy)
├── Timesheet Entry
├── Accounts Payable
├── SARS Compliance
├── Banking
│   └── Bank Statement Import
└── Reports
    └── Income Statement
```

---

## Master Data

### Purpose
Maintain master data for accounting operations.

### Menu: Master Data

```
Master Data
├── Expense Types
└── Expenses
```

### Expense Types

#### Purpose
Define categories of expenses for classification and reporting.

#### Accessing Expense Types

1. Click **Accounting** → **Master Data** → **Expense Types**
2. Expense types form opens

**📸 Screenshot Required:** `Accounting_ExpenseTypes_List.png`
- Show expense types grid
- Show add/edit buttons
- Show sample expense types

#### Expense Types List

**Common Expense Types:**
- Rent
- Utilities (Electricity, Water)
- Salaries & Wages
- Telephone & Internet
- Insurance
- Repairs & Maintenance
- Advertising & Marketing
- Office Supplies
- Professional Fees
- Bank Charges

**📸 Screenshot Required:** `Accounting_ExpenseTypes_Examples.png`
- Show list of expense types
- Show GL account mapping
- Show active/inactive status

#### Creating Expense Type

**Step 1: New Expense Type**
1. Click **New** button
2. Expense type form opens

**📸 Screenshot Required:** `Accounting_ExpenseTypes_New.png`
- Show blank form
- Show required fields
- Show GL account dropdown

**Step 2: Enter Details**
- **Expense Type Name:** Descriptive name
  * Example: "Electricity"
- **Description:** What it's for
- **GL Account:** Link to chart of accounts
- **Budget Category:** For budgeting
- **Requires Approval:** Yes/No
- **Approval Limit:** Amount requiring approval

**Step 3: Save**
1. Review information
2. Click **Save**
3. Expense type available for use

### Expenses

#### Purpose
Record and manage business expenses.

#### Accessing Expenses

1. Click **Accounting** → **Master Data** → **Expenses**
2. Expenses form opens

**📸 Screenshot Required:** `Accounting_Expenses_List.png`
- Show expenses grid
- Show filter options
- Show status indicators

#### Expenses List View

**Grid Columns:**
- Expense Date
- Expense Type
- Description
- Amount
- Supplier
- Status (Pending/Approved/Paid)
- Payment Due Date

**📸 Screenshot Required:** `Accounting_Expenses_Grid.png`
- Show multiple expenses
- Show different statuses
- Show overdue highlighted

#### Creating Expense

**Step 1: New Expense**
1. Click **New Expense** button
2. Expense form opens

**📸 Screenshot Required:** `Accounting_Expenses_New.png`
- Show expense entry form
- Show all fields
- Show attachment option

**Step 2: Enter Expense Details**
- **Expense Date:** When incurred
- **Expense Type:** Select from dropdown
- **Description:** What it's for
- **Amount:** Expense amount
- **Supplier:** Who to pay
- **Invoice Number:** Supplier invoice #
- **Due Date:** When payment due
- **Branch:** Which branch

**📸 Screenshot Required:** `Accounting_Expenses_Details.png`
- Show filled form
- Show amount entry
- Show due date picker

**Step 3: Attach Supporting Documents**
1. Click **Attach Document**
2. Browse to file (invoice, receipt)
3. Upload document
4. Document stored with expense

**📸 Screenshot Required:** `Accounting_Expenses_Attachment.png`
- Show attachment dialog
- Show uploaded document
- Show view button

**Step 4: Submit for Approval**
1. Review expense
2. Click **Submit for Approval**
3. Approver notified
4. Status: "Pending Approval"

**📸 Screenshot Required:** `Accounting_Expenses_Submit.png`
- Show submit confirmation
- Show approval workflow
- Show status change

#### Approving Expenses

**Approval Process:**
1. Approver receives notification
2. Opens expense
3. Reviews details and documents
4. Approves or rejects
5. If approved, moves to payment queue

**📸 Screenshot Required:** `Accounting_Expenses_Approve.png`
- Show approval dialog
- Show approve/reject buttons
- Show comments field

#### Paying Expenses

**Payment Process:**
1. Approved expenses in payment queue
2. Select expenses to pay
3. Generate payment batch
4. Process payments
5. Update status to "Paid"

**📸 Screenshot Required:** `Accounting_Expenses_Payment.png`
- Show payment queue
- Show batch selection
- Show payment processing

---

## Cash Book

### Purpose
Manage daily cash transactions and reconciliation.

### Menu: Cash Book

```
Cash Book
├── Main Cash Book
└── Petty Cash
```

### Main Cash Book

#### Purpose
Record all cash receipts and payments for the main cash drawer.

#### Accessing Main Cash Book

1. Click **Accounting** → **Cash Book** → **Main Cash Book**
2. Main Cash Book form opens

**📸 Screenshot Required:** `Accounting_CashBook_Main.png`
- Show complete cash book interface
- Show opening balance
- Show transactions list
- Show closing balance

#### Main Cash Book Interface

**Screen Sections:**
```
┌─────────────────────────────────────────────────────────┐
│ Header: Branch | Date | Cash Book Status                │
├─────────────────────────────────────────────────────────┤
│ Opening Balance: R 5,000.00                             │
├──────────────────────┬──────────────────────────────────┤
│                      │                                  │
│  Receipts (Cash In)  │    Payments (Cash Out)          │
│                      │                                  │
├──────────────────────┴──────────────────────────────────┤
│ Closing Balance: R 4,750.00 | Reconcile Button         │
└─────────────────────────────────────────────────────────┘
```

**📸 Screenshot Required:** `Accounting_CashBook_Layout.png`
- Annotate each section
- Show receipts vs payments
- Show balance calculation

#### Opening Cash Book

**Daily Opening Process:**
1. Open Main Cash Book
2. System checks if already opened today
3. If not opened:
   - Click **Open Cash Book**
   - Enter opening float amount
   - System creates opening entry
   - Status: "Open"

**📸 Screenshot Required:** `Accounting_CashBook_Opening.png`
- Show opening dialog
- Show float amount entry
- Show confirmation

**Opening Float:**
- Standard amount to start day
- Usually R5,000 or R10,000
- Counted from previous day's closing
- Or from bank if new period

#### Recording Cash Receipts

**Types of Receipts:**
- Cash sales from POS
- Customer payments
- Refunds received
- Other cash received

**To Record Receipt:**
1. Click **New Receipt** button
2. Receipt form opens

**📸 Screenshot Required:** `Accounting_CashBook_Receipt.png`
- Show receipt entry form
- Show all fields
- Show save button

**Receipt Details:**
- **Date:** Receipt date
- **Receipt Number:** Auto-generated
- **Received From:** Customer/source
- **Amount:** Cash received
- **Payment Method:** Cash/Cheque
- **Reference:** Invoice/receipt #
- **Description:** What it's for
- **GL Account:** Revenue account

**Step-by-Step:**
1. Enter receipt date
2. Enter received from
3. Enter amount
4. Select payment method
5. Enter reference
6. Add description
7. Select GL account
8. Click **Save**

**📸 Screenshot Required:** `Accounting_CashBook_ReceiptSaved.png`
- Show saved receipt
- Show in receipts list
- Show updated balance

**System Actions:**
- Receipt saved
- Cash book balance increased
- GL entry created:
  ```
  Debit:  Cash in Hand
  Credit: Revenue Account
  ```

#### Recording Cash Payments

**Types of Payments:**
- Supplier payments
- Expense payments
- Petty cash top-ups
- Other cash paid out

**To Record Payment:**
1. Click **New Payment** button
2. Payment form opens

**📸 Screenshot Required:** `Accounting_CashBook_Payment.png`
- Show payment entry form
- Show all fields
- Show save button

**Payment Details:**
- **Date:** Payment date
- **Payment Number:** Auto-generated
- **Paid To:** Supplier/recipient
- **Amount:** Cash paid
- **Payment Method:** Cash/Cheque
- **Reference:** Invoice/receipt #
- **Description:** What it's for
- **GL Account:** Expense account

**Step-by-Step:**
1. Enter payment date
2. Enter paid to
3. Enter amount
4. Select payment method
5. Enter reference
6. Add description
7. Select GL account
8. Click **Save**

**📸 Screenshot Required:** `Accounting_CashBook_PaymentSaved.png`
- Show saved payment
- Show in payments list
- Show updated balance

**System Actions:**
- Payment saved
- Cash book balance decreased
- GL entry created:
  ```
  Debit:  Expense Account
  Credit: Cash in Hand
  ```

#### Cash Book Reconciliation

**Purpose:**
- Verify physical cash matches system
- Identify discrepancies
- Ensure accuracy

**When to Reconcile:**
- End of each day
- Before closing cash book
- After significant transactions

**Reconciliation Process:**

**Step 1: Start Reconciliation**
1. Click **Reconcile** button
2. Reconciliation form opens

**📸 Screenshot Required:** `Accounting_CashBook_ReconcileStart.png`
- Show reconcile button
- Show reconciliation form
- Show expected balance

**Step 2: Count Physical Cash**

**Count by Denomination:**
- R200 notes × quantity
- R100 notes × quantity
- R50 notes × quantity
- R20 notes × quantity
- R10 notes × quantity
- R5 coins × quantity
- R2 coins × quantity
- R1 coins × quantity
- 50c coins × quantity
- 20c coins × quantity
- 10c coins × quantity

**📸 Screenshot Required:** `Accounting_CashBook_CountCash.png`
- Show denomination fields
- Show quantity entry
- Show running total

**System Calculates:**
- Total per denomination
- Grand total counted
- Compares to expected

**Step 3: Review Variance**

**System Shows:**
- Expected balance: R4,750.00
- Actual counted: R4,730.00
- Variance: R20.00 SHORT

**📸 Screenshot Required:** `Accounting_CashBook_Variance.png`
- Show variance calculation
- Show over/short indicator
- Show reason field

**If Variance Exists:**
1. Enter reason for variance
2. Options:
   - Counting error (recount)
   - Missing cash (investigate)
   - Unrecorded transaction
   - Other (explain)

**📸 Screenshot Required:** `Accounting_CashBook_VarianceReason.png`
- Show reason dropdown
- Show notes field
- Show manager approval

**Step 4: Complete Reconciliation**

**If Balanced (no variance):**
1. Click **Complete Reconciliation**
2. System posts reconciliation
3. Status: "Reconciled"

**If Variance:**
1. Manager approval required
2. Enter manager PIN
3. Confirm reconciliation
4. Variance posted to GL:
   ```
   If SHORT:
   Debit:  Cash Shortage Account
   Credit: Cash in Hand
   
   If OVER:
   Debit:  Cash in Hand
   Credit: Cash Overage Account
   ```

**📸 Screenshot Required:** `Accounting_CashBook_ReconcileComplete.png`
- Show completion message
- Show reconciliation report
- Show GL entries

**Step 5: Print Reconciliation Report**
1. Click **Print Report**
2. Report shows:
   - Opening balance
   - Total receipts
   - Total payments
   - Expected closing
   - Actual count
   - Variance
   - Denomination breakdown

**📸 Screenshot Required:** `Accounting_CashBook_ReconcileReport.png`
- Show printed report
- Show all sections
- Show signatures section

#### Closing Cash Book

**End of Day Close:**
1. Ensure reconciled
2. Click **Close Cash Book**
3. System verifies:
   - All transactions recorded
   - Reconciliation complete
   - No pending items
4. Status: "Closed"
5. Tomorrow's opening = Today's closing

**📸 Screenshot Required:** `Accounting_CashBook_Close.png`
- Show close confirmation
- Show final balance
- Show status change

### Petty Cash

#### Purpose
Manage small cash expenses and petty cash float.

#### Accessing Petty Cash

1. Click **Accounting** → **Cash Book** → **Petty Cash**
2. Petty Cash form opens

**📸 Screenshot Required:** `Accounting_PettyCash_Main.png`
- Show petty cash interface
- Show float amount
- Show vouchers list

#### Petty Cash Interface

**Screen Sections:**
- Opening float
- Today's vouchers
- Total expenses
- Remaining cash
- Top up and reconcile buttons

**📸 Screenshot Required:** `Accounting_PettyCash_Layout.png`
- Show all sections
- Show vouchers grid
- Show action buttons

#### Creating Petty Cash Voucher

**When to Use:**
- Small purchases (under R100)
- Emergency expenses
- Office supplies
- Refreshments
- Courier fees
- Parking

**Step 1: New Voucher**
1. Click **New Voucher** button
2. Voucher form opens

**📸 Screenshot Required:** `Accounting_PettyCash_NewVoucher.png`
- Show voucher form
- Show all fields
- Show amount limit

**Step 2: Enter Voucher Details**
- **Date:** Today
- **Voucher Number:** Auto-generated
- **Paid To:** Recipient/supplier
- **Amount:** Cash paid (max R100)
- **Expense Type:** Select category
- **Description:** What purchased
- **Receipt Attached:** Yes/No

**📸 Screenshot Required:** `Accounting_PettyCash_VoucherDetails.png`
- Show filled form
- Show amount validation
- Show receipt checkbox

**Step 3: Approval**

**If Amount ≤ R100:**
- No approval needed
- Save and pay immediately

**If Amount > R100:**
- Manager approval required
- Enter manager PIN
- Manager reviews and approves

**📸 Screenshot Required:** `Accounting_PettyCash_Approval.png`
- Show approval dialog
- Show manager PIN entry
- Show approval confirmation

**Step 4: Pay and Record**
1. Click **Pay**
2. Give cash to recipient
3. Get receipt
4. Attach receipt to voucher
5. File voucher

**📸 Screenshot Required:** `Accounting_PettyCash_Paid.png`
- Show payment confirmation
- Show voucher in list
- Show updated balance

**System Actions:**
- Voucher saved
- Petty cash reduced
- GL entry created:
  ```
  Debit:  Expense Account
  Credit: Petty Cash
  ```

#### Topping Up Petty Cash

**When to Top Up:**
- Float running low
- After reconciliation
- Start of new period

**Top Up Process:**

**Step 1: Initiate Top Up**
1. Click **Top Up** button
2. Top up form opens

**📸 Screenshot Required:** `Accounting_PettyCash_TopUp.png`
- Show top up form
- Show current balance
- Show amount entry

**Step 2: Enter Top Up Amount**
- Current balance shown
- Enter amount to add
- Enter reason
- Example: "Weekly float replenishment"

**📸 Screenshot Required:** `Accounting_PettyCash_TopUpAmount.png`
- Show amount entry
- Show reason field
- Show confirmation

**Step 3: Transfer Cash**
- Cash taken from Main Cash Book
- Added to Petty Cash
- Both books updated

**System Actions:**
```
Main Cash Book:
Debit:  Petty Cash Account
Credit: Cash in Hand

Petty Cash:
Debit:  Petty Cash
Credit: Main Cash Book
```

**📸 Screenshot Required:** `Accounting_PettyCash_TopUpComplete.png`
- Show completion message
- Show updated balance
- Show GL entries

#### Petty Cash Reconciliation

**Reconciliation Process:**

**Step 1: Start Reconciliation**
1. Click **Reconcile** button
2. Reconciliation form opens

**📸 Screenshot Required:** `Accounting_PettyCash_ReconcileStart.png`
- Show reconcile form
- Show expected balance
- Show vouchers summary

**Step 2: Calculate Expected**
```
Opening Float:     R 500.00
Less: Vouchers:    R 350.00
Expected Cash:     R 150.00
```

**📸 Screenshot Required:** `Accounting_PettyCash_Expected.png`
- Show calculation
- Show vouchers total
- Show expected balance

**Step 3: Count Actual Cash**
- Count physical cash
- Count all vouchers
- Verify receipts attached

**Step 4: Enter Actual Amount**
- Enter counted cash
- System calculates variance

**📸 Screenshot Required:** `Accounting_PettyCash_ActualCount.png`
- Show actual amount entry
- Show variance calculation
- Show over/short indicator

**Step 5: Handle Variance**

**If Balanced:**
- Click **Complete**
- Reconciliation saved

**If Variance:**
- Enter reason (MANDATORY)
- Manager approval
- Variance posted to GL

**📸 Screenshot Required:** `Accounting_PettyCash_VarianceHandling.png`
- Show variance reason
- Show manager approval
- Show GL posting

**Step 6: Complete Reconciliation**
- Reconciliation saved
- Report generated
- File with vouchers

**📸 Screenshot Required:** `Accounting_PettyCash_ReconcileComplete.png`
- Show completion message
- Show reconciliation report
- Show next steps

### Cash Book Ledger Viewer

#### Purpose
View complete transaction history across all cash books with filtering and analysis.

#### Accessing Ledger Viewer

1. Click **Accounting** → **Cash Book** → **Ledger Viewer**
2. Ledger viewer opens

**📸 Screenshot Required:** `Accounting_CashBook_LedgerViewer.png`
- Show complete ledger interface
- Show filter options
- Show transaction grid
- Show summary panel

#### Ledger Viewer Interface

**Screen Layout:**
```
┌─────────────────────────────────────────────────────────┐
│ Header: Cash Book Ledger Viewer                         │
├─────────────────────────────────────────────────────────┤
│ Filters: Date Range | Cash Book Type | Transaction Type│
│ [From] [To] [Main/Petty/All] [Receipt/Payment/All]     │
│ [Apply Filter] [Export Excel] [Print]                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│              Transaction Grid                            │
│  Date | Trans# | Type | Description | Receipt | Payment│
│                                                          │
├─────────────────────────────────────────────────────────┤
│ Summary: Opening | Receipts | Payments | Closing        │
└─────────────────────────────────────────────────────────┘
```

**📸 Screenshot Required:** `Accounting_CashBook_LedgerLayout.png`
- Annotate each section
- Show filter panel
- Show grid with data
- Show summary calculations

#### Using Filters

**Date Range Filter:**
1. Set **From Date** (default: 1 month ago)
2. Set **To Date** (default: today)
3. Click **Apply Filter**

**📸 Screenshot Required:** `Accounting_CashBook_LedgerDateFilter.png`
- Show date pickers
- Show date range selection
- Show filtered results

**Cash Book Type Filter:**
- **All:** Shows both Main Cash Book and Petty Cash
- **Main Cash Book:** Only main cash transactions
- **Petty Cash:** Only petty cash vouchers

**📸 Screenshot Required:** `Accounting_CashBook_LedgerTypeFilter.png`
- Show cash book dropdown
- Show filtered by type
- Show type indicator in grid

**Transaction Type Filter:**
- **All:** All transaction types
- **Receipt:** Cash received only
- **Payment:** Cash paid only
- **Opening Balance:** Opening entries
- **Closing Balance:** Closing entries

**📸 Screenshot Required:** `Accounting_CashBook_LedgerTransFilter.png`
- Show transaction type dropdown
- Show filtered results
- Show type-specific data

#### Transaction Grid Columns

**Grid Shows:**
- **Date:** Transaction date
- **Transaction #:** Receipt/payment/voucher number
- **Cash Book:** Main or Petty
- **Type:** Receipt/Payment
- **Description:** Transaction description
- **Received From / Paid To:** Party name
- **Receipt:** Amount received (green)
- **Payment:** Amount paid (red)
- **Balance:** Running balance (bold)
- **Recorded By:** User who entered
- **GL Account:** Linked general ledger account

**📸 Screenshot Required:** `Accounting_CashBook_LedgerGrid.png`
- Show all columns
- Show color coding
- Show running balance
- Show multiple transactions

**Color Coding:**
- 🟢 **Green:** Receipt amounts
- 🔴 **Red:** Payment amounts
- **Bold:** Running balance
- **Alternating rows:** Better readability

#### Summary Panel

**Summary Shows:**
- **Opening Balance:** Starting balance for period
- **Total Receipts:** Sum of all receipts (green)
- **Total Payments:** Sum of all payments (red)
- **Closing Balance:** Final balance (green if positive, red if negative)

**📸 Screenshot Required:** `Accounting_CashBook_LedgerSummary.png`
- Show summary panel
- Show all totals
- Show color coding
- Show closing balance calculation

**Calculation:**
```
Closing Balance = Opening Balance + Total Receipts - Total Payments
```

#### Running Balance

**How It Works:**
- Each transaction shows cumulative balance
- Receipts increase balance
- Payments decrease balance
- Balance updates line by line

**Example:**
```
Date       | Description      | Receipt | Payment | Balance
-----------|------------------|---------|---------|--------
01/10/2025 | Opening Balance  |         |         | 5,000.00
01/10/2025 | Cash Sale        | 1,500.00|         | 6,500.00
01/10/2025 | Supplier Payment |         | 800.00  | 5,700.00
01/10/2025 | Customer Payment | 2,000.00|         | 7,700.00
```

**📸 Screenshot Required:** `Accounting_CashBook_RunningBalance.png`
- Show running balance column
- Show balance changes
- Show calculation flow

#### Exporting Ledger

**Export to Excel:**
1. Set desired filters
2. Click **Export Excel** button
3. Choose save location
4. File downloads with:
   - All filtered transactions
   - Summary totals
   - Formatted for analysis

**📸 Screenshot Required:** `Accounting_CashBook_LedgerExport.png`
- Show export button
- Show save dialog
- Show exported Excel file

**Excel File Contains:**
- Transaction details
- Running balance
- Summary sheet
- Pivot-ready format

#### Printing Ledger

**Print Report:**
1. Set filters
2. Click **Print** button
3. Print preview opens
4. Review report
5. Click **Print**

**📸 Screenshot Required:** `Accounting_CashBook_LedgerPrint.png`
- Show print button
- Show print preview
- Show formatted report

**Report Includes:**
- Company header
- Date range
- Filter criteria
- Transaction list
- Summary totals
- Page numbers
- Print date

#### Use Cases

**Scenario 1: Daily Cash Verification**
1. Set date to today
2. Select "Main Cash Book"
3. View all transactions
4. Verify closing balance matches physical cash

**Scenario 2: Monthly Reconciliation**
1. Set date range to full month
2. Select "All" cash books
3. Export to Excel
4. Reconcile with GL

**Scenario 3: Audit Trail**
1. Set date range for audit period
2. Select specific transaction type
3. Print report
4. Provide to auditors

**Scenario 4: Variance Investigation**
1. Filter by date when variance occurred
2. Review all transactions
3. Check running balance
4. Identify discrepancy

**📸 Screenshot Required:** `Accounting_CashBook_LedgerUseCases.png`
- Show different filter combinations
- Show various scenarios
- Show analysis examples

#### Ledger Viewer Best Practices

✅ **DO:**
- Review ledger daily
- Export monthly for records
- Verify running balance
- Check for unusual transactions
- Use filters to focus analysis
- Print for audit trail

❌ **DON'T:**
- Ignore discrepancies
- Skip daily verification
- Forget to export backups
- Overlook small variances
- Mix date ranges incorrectly

---

## Banking

### Purpose
Manage bank transactions and reconciliation.

### Menu: Banking

```
Banking
└── Bank Statement Import
```

### Bank Statement Import

#### Purpose
Import bank statements for reconciliation.

#### Accessing Bank Statement Import

1. Click **Accounting** → **Banking** → **Bank Statement Import**
2. Import form opens

**📸 Screenshot Required:** `Accounting_Banking_Import.png`
- Show import interface
- Show file selection
- Show import button

#### Import Process

**Step 1: Prepare Statement**
- Download from bank (Excel/CSV)
- Ensure correct format
- Check date range

**Step 2: Select File**
1. Click **Browse**
2. Select statement file
3. File loads

**📸 Screenshot Required:** `Accounting_Banking_FileSelect.png`
- Show file browser
- Show file selected
- Show preview

**Step 3: Map Columns**
- Date column
- Description column
- Debit column
- Credit column
- Balance column

**📸 Screenshot Required:** `Accounting_Banking_ColumnMap.png`
- Show column mapping
- Show sample data
- Show mapping dropdowns

**Step 4: Import**
1. Click **Import**
2. System validates data
3. Transactions imported
4. Ready for reconciliation

**📸 Screenshot Required:** `Accounting_Banking_ImportComplete.png`
- Show import summary
- Show transactions imported
- Show errors if any

---

## Reports

### Purpose
Generate financial reports and statements.

### Menu: Reports

```
Reports
└── Income Statement
```

### Income Statement

#### Purpose
View profit and loss for a period.

#### Accessing Income Statement

1. Click **Accounting** → **Reports** → **Income Statement**
2. Report parameters form opens

**📸 Screenshot Required:** `Accounting_Reports_IncomeStatement.png`
- Show parameter form
- Show date range selection
- Show generate button

#### Report Parameters

**Filters:**
- From Date
- To Date
- Branch (specific or all)
- Comparison period (optional)

**📸 Screenshot Required:** `Accounting_Reports_Parameters.png`
- Show all parameters
- Show date pickers
- Show branch dropdown

#### Income Statement Report

**Report Sections:**

**Revenue:**
- Sales revenue
- Other income
- Total revenue

**Cost of Sales:**
- Opening stock
- Purchases
- Less: Closing stock
- Cost of goods sold

**Gross Profit:**
- Revenue - Cost of Sales

**Operating Expenses:**
- Salaries
- Rent
- Utilities
- Other expenses
- Total expenses

**Net Profit:**
- Gross Profit - Operating Expenses

**📸 Screenshot Required:** `Accounting_Reports_IncomeStatementFull.png`
- Show complete report
- Show all sections
- Show calculations

#### Exporting Report

**Export Options:**
- PDF (formatted)
- Excel (data)
- CSV (raw data)
- Email

**📸 Screenshot Required:** `Accounting_Reports_Export.png`
- Show export options
- Show format selection
- Show email dialog

---

## Accounts Payable

### Purpose
Manage supplier invoices and payments.

#### Accessing Accounts Payable

1. Click **Accounting** → **Accounts Payable**
2. Accounts payable form opens

**📸 Screenshot Required:** `Accounting_AP_Main.png`
- Show AP dashboard
- Show outstanding invoices
- Show payment due

#### AP Dashboard

**Dashboard Shows:**
- Total outstanding
- Overdue invoices
- Due this week
- Due this month
- Aged analysis

**📸 Screenshot Required:** `Accounting_AP_Dashboard.png`
- Show KPI tiles
- Show aging chart
- Show action items

#### Processing Payments

**Payment Process:**
1. Select invoices to pay
2. Generate payment batch
3. Process payments
4. Update invoice status

**📸 Screenshot Required:** `Accounting_AP_Payment.png`
- Show invoice selection
- Show batch creation
- Show payment processing

---

## Accounting Module Summary

### Key Takeaways

✅ **Master Data**
- Expense types for classification
- Expense recording and approval
- Document attachment

✅ **Cash Book**
- Main cash book for daily transactions
- Petty cash for small expenses
- Daily reconciliation
- Variance management

✅ **Banking**
- Bank statement import
- Transaction reconciliation
- Automated matching

✅ **Reports**
- Income statement
- Financial analysis
- Export capabilities

✅ **Accounts Payable**
- Invoice management
- Payment processing
- Aging analysis

### Common Tasks Quick Reference

| Task | Steps |
|------|-------|
| Open Cash Book | Accounting → Cash Book → Main Cash Book → Open |
| Record Receipt | Cash Book → New Receipt |
| Record Payment | Cash Book → New Payment |
| Reconcile Cash | Cash Book → Reconcile |
| Petty Cash Voucher | Petty Cash → New Voucher |
| Top Up Petty Cash | Petty Cash → Top Up |
| Income Statement | Accounting → Reports → Income Statement |

### Critical Reminders

⚠️ **Cash Handling:**
- Reconcile daily
- Document all variances
- Manager approval for discrepancies
- Keep physical cash secure

⚠️ **Petty Cash:**
- Receipts MANDATORY
- Stay within limits
- Regular reconciliation
- Top up when low

⚠️ **GL Accuracy:**
- Correct account selection
- Proper descriptions
- Supporting documents
- Regular review

### Support and Help

**Need Help?**
- Press F1 for context-sensitive help
- Check [User Manual Index](USER_MANUAL_00_INDEX.md)
- Contact Financial Manager
- IT Support: support@ovendelights.co.za

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Next Review:** January 2026

---

## Training Manual Series Complete

You have completed all module manuals:
1. ✅ [Getting Started](USER_MANUAL_01_GETTING_STARTED.md)
2. ✅ [Administration](USER_MANUAL_02_ADMINISTRATION.md)
3. ✅ [Stockroom](USER_MANUAL_03_STOCKROOM.md)
4. ✅ [Manufacturing](USER_MANUAL_04_MANUFACTURING.md)
5. ✅ [Retail](USER_MANUAL_05_RETAIL.md)
6. ✅ [Accounting](USER_MANUAL_06_ACCOUNTING.md)

**Return to:** [Master Index](USER_MANUAL_00_INDEX.md)
