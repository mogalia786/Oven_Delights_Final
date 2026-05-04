# OVEN DELIGHTS ERP - COMPLETE GL POSTING TRIGGERS MAP

**Document Version:** 1.0  
**Date:** January 27, 2026  
**Purpose:** Complete mapping of all posting triggers across ERP and POS systems

---

## TABLE OF CONTENTS

1. [Point of Sale (POS) Transactions](#1-point-of-sale-pos-transactions)
2. [Purchase Orders & Procurement](#2-purchase-orders--procurement)
3. [Manufacturing & Production](#3-manufacturing--production)
4. [Cashbook & Banking](#4-cashbook--banking)
5. [Accounts Payable](#5-accounts-payable)
6. [Inventory Movements](#6-inventory-movements)
7. [Inter-Branch Transfers](#7-inter-branch-transfers)
8. [Manual Journal Entries](#8-manual-journal-entries)
9. [Opening Balances](#9-opening-balances)
10. [Account Mapping Reference](#10-account-mapping-reference)
11. [Posting Flow Diagrams](#11-posting-flow-diagrams)

---

## 1. POINT OF SALE (POS) TRANSACTIONS

### 1.1 POS SALE COMPLETION

**Trigger:** When cashier completes a sale and payment is tendered  
**Location:** POS System → PaymentTenderForm.vb  
**Stored Procedure:** `sp_POS_PostSaleToGL`  
**Posting Status:** Automatically posted (`IsPosted = 1`)

**Journal Entry:**
```
Journal Number: POS-{InvoiceNumber}
Description: POS Sale - Invoice {InvoiceNumber}

Debit:  1010 Bank Account          (Card payment amount)
Debit:  1030 Cash on Hand           (Cash payment amount)
Credit: 4010 Sales Revenue          (Subtotal excluding VAT)
Credit: 2020 VAT Output             (VAT amount)

Debit:  5010 Cost of Goods Sold     (Total cost)
Credit: 1220 Inventory              (Total cost)
```

**Parameters:**
- `@InvoiceNumber` - POS invoice number
- `@SaleDate` - Transaction date
- `@BranchID` - Branch where sale occurred
- `@CashierID` - Cashier who processed sale
- `@Subtotal` - Sale amount excluding VAT
- `@TaxAmount` - VAT amount (15%)
- `@TotalAmount` - Total including VAT
- `@CashAmount` - Cash portion of payment
- `@CardAmount` - Card portion of payment
- `@TotalCost` - Cost of goods sold
- `@CreatedBy` - User who processed transaction

**VAT Tracking:**
- VAT Output (2020) credited for sales VAT collected
- Tracks output VAT for SARS VAT201 return

**Business Rules:**
- Split payments supported (Cash + Card)
- COGS and inventory reduction posted simultaneously
- Error in GL posting does NOT fail the sale (logged only)
- Card payments go to Bank (1010)
- Cash payments go to Cash on Hand (1030)

---

### 1.2 POS REFUND/RETURN

**Trigger:** When cashier processes a product return  
**Location:** POS System → ReturnTenderForm.vb  
**Stored Procedure:** `sp_POS_PostRefundToGL`  
**Posting Status:** Automatically posted (`IsPosted = 1`)

**Journal Entry:**
```
Journal Number: REF-{InvoiceNumber}
Description: POS Refund - Invoice {InvoiceNumber}

Debit:  4010 Sales Revenue          (Subtotal - reversal)
Debit:  2020 VAT Output             (VAT - reversal)
Credit: 1010 Bank Account           (Card refund) OR
Credit: 1030 Cash on Hand           (Cash refund)

Debit:  1220 Inventory              (Restore stock)
Credit: 5010 Cost of Goods Sold     (COGS reversal)
```

**Parameters:**
- `@InvoiceNumber` - Original invoice number
- `@RefundDate` - Refund date
- `@BranchID` - Branch processing refund
- `@CashierID` - Cashier processing refund
- `@Subtotal` - Amount excluding VAT
- `@TaxAmount` - VAT amount
- `@TotalAmount` - Total refund amount
- `@RefundMethod` - 'Cash' or 'Card'
- `@TotalCost` - Cost to restore to inventory
- `@CreatedBy` - User processing refund

**VAT Tracking:**
- VAT Output (2020) debited to reverse sales VAT
- Reduces output VAT for SARS reporting

**Business Rules:**
- Reverses original sale entries
- Restores inventory and reverses COGS
- Refund method matches original payment method (typically)

---

## 2. PURCHASE ORDERS & PROCUREMENT

### 2.1 GOODS RECEIPT (GRV)

**Trigger:** When goods are received from supplier (before invoice)  
**Location:** ERP → InvoiceGRVForm.vb / InvoiceCaptureForm.vb  
**Stored Procedure:** `sp_PO_PostGRVToGL`  
**Posting Status:** Automatically posted (`IsPosted = 1`)  
**Method:** GRIR (Goods Receipt/Invoice Receipt) Accounting

**Journal Entry:**
```
Journal Number: GRV-{GRVNumber}
Description: GRV - {SupplierName}

Debit:  1220 Inventory                      (Goods value at PO price)
Credit: 2050 GRIR (Goods Received/Invoice Receipt) (Liability - invoice pending)
```

**Parameters:**
- `@GRVID` - GRV record ID
- `@GRVNumber` - GRV document number
- `@GRVDate` - Date goods received
- `@SupplierName` - Supplier name
- `@BranchID` - Branch receiving goods
- `@TotalAmount` - Total value of goods received
- `@CreatedBy` - User who processed GRV

**Business Rules:**
- Inventory increased immediately upon receipt
- GRIR account holds liability until invoice received
- Physical stock updated in Demo_Retail_Product.CurrentStock
- Prices updated in Demo_Retail_Price.LastPaidPrice and AverageCost

---

### 2.2 SUPPLIER INVOICE RECEIPT

**Trigger:** When supplier invoice is received and matched to GRV  
**Location:** ERP → InvoiceCaptureForm.vb  
**Stored Procedure:** `sp_PO_PostInvoiceToGL`  
**Posting Status:** Automatically posted (`IsPosted = 1`)

**Journal Entry:**
```
Journal Number: INV-{InvoiceNumber}
Description: Supplier Invoice - {SupplierName}

Debit:  2050 GRIR (Clear pending liability)
Credit: 2010 Accounts Payable               (Supplier invoice liability)
```

**Parameters:**
- `@InvoiceID` - Invoice record ID
- `@InvoiceNumber` - Supplier invoice number
- `@InvoiceDate` - Invoice date
- `@SupplierName` - Supplier name
- `@BranchID` - Branch
- `@TotalAmount` - Invoice total (including VAT)
- `@CreatedBy` - User who captured invoice

**VAT Tracking:**
- VAT Input (2021) should be debited if VAT is separately tracked
- Currently NOT implemented - needs enhancement for VAT Input tracking

**Business Rules:**
- Clears GRIR temporary account
- Creates Accounts Payable liability
- Invoice must match GRV (3-way matching)
- Price variances should be investigated

**ENHANCEMENT NEEDED:**
```sql
-- Add VAT Input tracking to sp_PO_PostInvoiceToGL
Debit:  2050 GRIR                   (Goods value excluding VAT)
Debit:  2021 VAT Input              (VAT amount - claimable from SARS)
Credit: 2010 Accounts Payable       (Total including VAT)
```

---

### 2.3 SUPPLIER PAYMENT

**Trigger:** When payment is made to supplier (manual or batch)  
**Location:** ERP → SupplierPaymentForm.vb / BatchPaymentForm.vb  
**Stored Procedure:** `sp_AP_PostPaymentToGL`  
**Posting Status:** Automatically posted (`IsPosted = 1`)

**Journal Entry:**
```
Journal Number: PAY-{PaymentNumber}
Description: Supplier Payment - {SupplierName}

Debit:  2010 Accounts Payable       (Clear supplier liability)
Credit: 1010 Bank Account           (Payment from bank)
```

**Parameters:**
- `@InvoiceID` - Invoice being paid
- `@PaymentBatchID` - Batch ID if part of batch payment
- `@PostingDate` - Payment date
- `@CreatedBy` - User processing payment

**Business Rules:**
- Reduces Accounts Payable balance
- Reduces Bank balance
- Can be part of bulk payment batch
- EFT/Bank file generated for electronic payments

---

### 2.4 BULK PAYMENT BATCH (FNB API)

**Trigger:** When batch payment is submitted to bank via FNB API  
**Location:** ERP → BatchPaymentForm.vb / EFTPaymentsManagementForm.vb  
**Stored Procedure:** `sp_AP_UpdatePaymentBatchStatus`  
**Posting Trigger:** Bank response received with success status

**Journal Entry (Per Invoice in Batch):**
```
Journal Number: PAY-{InvoiceNumber}
Description: Batch Payment - {SupplierName}

Debit:  2010 Accounts Payable       (Per invoice amount)
Credit: 1010 Bank Account           (Per invoice amount)
```

**Batch Statuses:**
1. **Pending** - Batch created, not submitted
2. **Submitted** - Sent to FNB API, awaiting response
3. **Completed** - Bank confirms successful processing → **POST TO GL**
4. **Failed** - Bank rejects batch → No posting

**Parameters:**
- `@BatchID` - Payment batch ID
- `@Status` - 'Pending', 'Submitted', 'Completed', 'Failed'
- `@InstructionID` - FNB instruction ID
- `@MessageID` - FNB message ID
- `@StatusMessage` - Bank response message
- `@ResponseJSON` - Full bank response

**Business Rules:**
- GL posting ONLY occurs when bank confirms success
- Failed payments do NOT post to GL
- Batch can contain multiple supplier invoices
- Each invoice posts separately to GL
- Bank response triggers posting

**FNB Integration Flow:**
1. User creates batch → Status: Pending
2. User submits to FNB API → Status: Submitted
3. FNB processes → Response received
4. If successful → Status: Completed → **TRIGGER GL POSTING**
5. If failed → Status: Failed → No GL posting

---

## 3. MANUFACTURING & PRODUCTION

### 3.1 PRODUCTION COMPLETION

**Trigger:** When manufacturing completes production of finished goods  
**Location:** ERP → CompleteBuildForm.vb / BakerProductionViewForm.vb  
**Stored Procedure:** `sp_MFG_PostProductionToGL`  
**Posting Status:** Automatically posted (`IsPosted = 1`)

**Journal Entry:**
```
Journal Number: PROD-{ProductionNumber}
Description: Production - {ProductName}

Debit:  1210 Finished Goods Inventory       (Total production cost)
Credit: 1200 Raw Materials Inventory        (Materials consumed)
Credit: 5040 Direct Labor                   (Labor cost allocated)
Credit: 6090 Manufacturing Overhead         (Overhead allocated)
```

**Parameters:**
- `@ProductionID` - Production batch ID
- `@ProductionNumber` - Production batch number
- `@ProductionDate` - Completion date
- `@ProductName` - Product manufactured
- `@BranchID` - Manufacturing branch
- `@RawMaterialsCost` - Cost of materials consumed
- `@LaborCost` - Direct labor cost
- `@OverheadCost` - Overhead allocation
- `@TotalCost` - Total production cost
- `@CreatedBy` - User completing production

**Business Rules:**
- Raw materials reduced from stockroom
- Finished goods added to manufacturing inventory
- Cost accumulation: Materials + Labor + Overhead
- Sub-recipes consumed from Demo_SubRecipe_Inventory
- Physical stock updated in Demo_Retail_Product

**Cost Components:**
1. **Raw Materials** - Ingredients consumed (from BOM)
2. **Direct Labor** - Baker/production staff time
3. **Manufacturing Overhead** - Utilities, depreciation, indirect costs

---

### 3.2 MANUFACTURING TO RETAIL TRANSFER

**Trigger:** When finished goods transferred from manufacturing to retail  
**Location:** ERP → ManufacturingReceivingForm.vb  
**Stored Procedure:** Currently NOT implemented - needs creation  
**Posting Status:** Should be posted

**Journal Entry (NEEDED):**
```
Journal Number: MFG-RET-{TransferNumber}
Description: Manufacturing to Retail Transfer

Debit:  1220 Retail Inventory (Finished Goods)  (At cost price)
Credit: 1210 Manufacturing Inventory            (At cost price)
```

**Parameters (Proposed):**
- `@TransferID` - Transfer record ID
- `@TransferNumber` - Transfer document number
- `@TransferDate` - Date of transfer
- `@BranchID` - Branch receiving goods
- `@TotalValue` - Total cost value
- `@CreatedBy` - User processing transfer

**Business Rules:**
- Finished goods move from manufacturing to retail
- Cost price maintained (no markup at this stage)
- Retail sets selling price separately
- Physical stock updated in Demo_Retail_Product

**ENHANCEMENT NEEDED:** Create `sp_MFG_PostManufacturingToRetailTransfer`

---

## 4. CASHBOOK & BANKING

### 4.1 CASH RECEIPT

**Trigger:** When cash/bank receipt is recorded  
**Location:** ERP → CashBookForm.vb / CashTransactionForm.vb  
**Stored Procedure:** `sp_CB_PostCashReceiptToGL`  
**Posting Status:** Automatically posted (`IsPosted = 1`)

**Journal Entry:**
```
Journal Number: CR-{ReceiptNumber}
Description: Cash Receipt - {ReceivedFrom}

Debit:  1010 Bank Account (if Bank) OR
Debit:  1030 Cash on Hand (if Cash)         (Receipt amount)
Credit: {SourceAccount}                     (Revenue or AR account)
```

**Parameters:**
- `@ReceiptID` - Receipt record ID
- `@ReceiptNumber` - Receipt document number
- `@ReceiptDate` - Receipt date
- `@Amount` - Receipt amount
- `@ReceivedFrom` - Payer name
- `@PaymentMethod` - 'Cash' or 'Bank'
- `@SourceAccountCode` - Account code (e.g., '4010' for Sales, '1200' for AR)
- `@BranchID` - Branch
- `@CreatedBy` - User recording receipt

**Common Source Accounts:**
- **4010** - Sales Revenue (cash sales)
- **1200** - Accounts Receivable (customer payment)
- **4020** - Other Income

**Business Rules:**
- Bank receipts increase Bank Account (1010)
- Cash receipts increase Cash on Hand (1030)
- Source account credited (revenue or AR clearance)

---

### 4.2 CASH PAYMENT

**Trigger:** When cash/bank payment is recorded  
**Location:** ERP → CashBookForm.vb / CashTransactionForm.vb  
**Stored Procedure:** `sp_CB_PostCashPaymentToGL`  
**Posting Status:** Automatically posted (`IsPosted = 1`)

**Journal Entry:**
```
Journal Number: CP-{PaymentNumber}
Description: Cash Payment - {PaidTo}

Debit:  {ExpenseAccount}                    (Expense or AP account)
Credit: 1010 Bank Account (if Bank) OR
Credit: 1030 Cash on Hand (if Cash)         (Payment amount)
```

**Parameters:**
- `@PaymentID` - Payment record ID
- `@PaymentNumber` - Payment document number
- `@PaymentDate` - Payment date
- `@Amount` - Payment amount
- `@PaidTo` - Payee name
- `@PaymentMethod` - 'Cash' or 'Bank'
- `@ExpenseAccountCode` - Account code (e.g., '6010' for Rent, '2010' for AP)
- `@BranchID` - Branch
- `@CreatedBy` - User recording payment

**Common Expense Accounts:**
- **6010** - Rent Expense
- **6020** - Utilities
- **6030** - Salaries
- **2010** - Accounts Payable (supplier payment)
- **5030** - Petty Cash Expenses

**Business Rules:**
- Bank payments reduce Bank Account (1010)
- Cash payments reduce Cash on Hand (1030)
- Expense account debited

---

### 4.3 BANK DEPOSIT

**Trigger:** When cash is deposited to bank  
**Location:** ERP → CashBookForm.vb  
**Stored Procedure:** `sp_CB_PostBankDepositToGL`  
**Posting Status:** Automatically posted (`IsPosted = 1`)

**Journal Entry:**
```
Journal Number: DEP-{DepositNumber}
Description: Bank Deposit

Debit:  1010 Bank Account           (Deposit amount)
Credit: 1030 Cash on Hand           (Cash deposited)
```

**Parameters:**
- `@DepositID` - Deposit record ID
- `@DepositNumber` - Deposit slip number
- `@DepositDate` - Deposit date
- `@Amount` - Deposit amount
- `@BranchID` - Branch
- `@CreatedBy` - User recording deposit

**Business Rules:**
- Moves cash from Cash on Hand to Bank
- Typically done at end of day
- Reconciled against bank statement

---

### 4.4 PETTY CASH TOP-UP

**Trigger:** When petty cash float is replenished  
**Location:** ERP → PettyCashTopUpForm.vb  
**Stored Procedure:** Currently uses direct INSERT - should use GL posting  
**Posting Status:** Currently NOT posted to GL

**Journal Entry (NEEDED):**
```
Journal Number: PCT-{TopUpNumber}
Description: Petty Cash Top-Up

Debit:  1025 Petty Cash              (Top-up amount)
Credit: 1010 Bank Account            (Withdrawal from bank)
```

**ENHANCEMENT NEEDED:** Create `sp_CB_PostPettyCashTopUpToGL`

---

## 5. ACCOUNTS PAYABLE

### 5.1 SUPPLIER INVOICE CAPTURE

**Trigger:** When supplier invoice is captured (without GRV)  
**Location:** ERP → AccountsPayableInvoiceForm.vb / AdhocInvoiceCaptureForm.vb  
**Stored Procedure:** Direct INSERT to AP_Invoices - should post to GL  
**Posting Status:** Currently NOT posted to GL

**Journal Entry (NEEDED):**
```
Journal Number: AP-{InvoiceNumber}
Description: AP Invoice - {SupplierName}

Debit:  {ExpenseAccount}             (Expense category)
Debit:  2021 VAT Input               (VAT claimable)
Credit: 2010 Accounts Payable        (Total invoice amount)
```

**ENHANCEMENT NEEDED:** Create `sp_AP_PostInvoiceToGL` for non-PO invoices

---

### 5.2 CREDIT NOTE FROM SUPPLIER

**Trigger:** When credit note received from supplier  
**Location:** ERP → CreditNoteViewerForm.vb  
**Stored Procedure:** Currently NOT implemented  
**Posting Status:** NOT posted to GL

**Journal Entry (NEEDED):**
```
Journal Number: CN-{CreditNoteNumber}
Description: Credit Note - {SupplierName}

Debit:  2010 Accounts Payable        (Reduce liability)
Credit: {ExpenseAccount}             (Reverse expense)
Credit: 2021 VAT Input               (Reverse VAT)
```

**ENHANCEMENT NEEDED:** Create `sp_AP_PostCreditNoteToGL`

---

## 6. INVENTORY MOVEMENTS

### 6.1 STOCK ADJUSTMENT

**Trigger:** When stock is adjusted (count variance, damage, theft)  
**Location:** ERP → StockAdjustmentForm.vb  
**Stored Procedure:** Currently NOT posted to GL  
**Posting Status:** NOT posted to GL

**Journal Entry (NEEDED):**
```
Journal Number: ADJ-{AdjustmentNumber}
Description: Stock Adjustment - {Reason}

FOR INCREASE:
Debit:  1220 Inventory               (Increase value)
Credit: 4030 Other Income            (Found stock)

FOR DECREASE:
Debit:  6080 Stock Loss/Shrinkage    (Loss value)
Credit: 1220 Inventory               (Reduce inventory)
```

**ENHANCEMENT NEEDED:** Create `sp_INV_PostStockAdjustmentToGL`

---

### 6.2 STOCK TRANSFER (INTERNAL)

**Trigger:** When stock moves between locations within same branch  
**Location:** ERP → StockTransferForm.vb  
**Stored Procedure:** Currently NOT posted to GL  
**Posting Status:** NOT posted to GL (memo entry only)

**Journal Entry:**
```
NO GL POSTING REQUIRED - Internal movement only
Physical stock location updated in inventory system
```

**Business Rules:**
- No GL impact (same branch, same value)
- Physical location tracking only
- Audit trail in StockMovements table

---

## 7. INTER-BRANCH TRANSFERS

### 7.1 INTER-BRANCH TRANSFER (IBT) - SENDING BRANCH

**Trigger:** When goods are dispatched to another branch  
**Location:** ERP → CreateDeliveryNoteForm.vb  
**Stored Procedure:** `sp_MFG_PostInventoryTransferToGL`  
**Posting Status:** Automatically posted (`IsPosted = 1`)

**Journal Entry (Sending Branch):**
```
Journal Number: XFER-{TransferNumber}
Description: Inventory Transfer to Branch {ToBranchID}

Debit:  1600 Inter-Branch Debtors    (Receiving branch owes)
Credit: 1220 Inventory               (Goods sent)
```

**Parameters:**
- `@TransferID` - Transfer record ID
- `@TransferNumber` - Transfer document number
- `@TransferDate` - Dispatch date
- `@FromBranchID` - Sending branch
- `@ToBranchID` - Receiving branch
- `@TotalValue` - Transfer value at cost
- `@CreatedBy` - User creating transfer

**Business Rules:**
- Sending branch reduces inventory
- Creates inter-branch debtor (receivable)
- Goods valued at cost price
- Receiving branch becomes debtor

---

### 7.2 INTER-BRANCH TRANSFER (IBT) - RECEIVING BRANCH

**Trigger:** When goods are received from another branch  
**Location:** ERP → ReceiveDeliveryForm.vb  
**Stored Procedure:** Currently NOT implemented  
**Posting Status:** Should be posted

**Journal Entry (Receiving Branch - NEEDED):**
```
Journal Number: XFER-RCV-{TransferNumber}
Description: Inventory Received from Branch {FromBranchID}

Debit:  1220 Inventory               (Goods received)
Credit: 1610 Inter-Branch Creditors  (Owe sending branch)
```

**ENHANCEMENT NEEDED:** Create `sp_IBT_PostReceiptToGL`

---

### 7.3 INTER-BRANCH SETTLEMENT

**Trigger:** When receiving branch pays sending branch  
**Location:** ERP → InterBranchLedger (currently view only)  
**Stored Procedure:** Currently NOT implemented  
**Posting Status:** NOT posted to GL

**Journal Entry (NEEDED):**

**Sending Branch:**
```
Debit:  1010 Bank Account            (Payment received)
Credit: 1600 Inter-Branch Debtors    (Clear receivable)
```

**Receiving Branch:**
```
Debit:  1610 Inter-Branch Creditors  (Clear payable)
Credit: 1010 Bank Account            (Payment made)
```

**ENHANCEMENT NEEDED:** Create `sp_IBT_PostSettlementToGL`

---

## 8. MANUAL JOURNAL ENTRIES

### 8.1 MANUAL JOURNAL ENTRY

**Trigger:** When accountant creates manual journal entry  
**Location:** ERP → ManualJournalEntryForm.vb  
**Stored Procedure:** `sp_GL_CreateJournalEntry` (from 07_Core_GL_Procedures.sql)  
**Posting Status:** Can be draft or posted

**Journal Entry:**
```
Journal Number: JE-{SequenceNumber}
Description: {User-defined description}

Debit:  {Account1}                   (Amount1)
Debit:  {Account2}                   (Amount2)
Credit: {Account3}                   (Amount3)
Credit: {Account4}                   (Amount4)

MUST BALANCE: Total Debits = Total Credits
```

**Parameters:**
- `@JournalNumber` - Journal entry number
- `@JournalDate` - Entry date
- `@Reference` - Reference document
- `@Description` - Entry description
- `@BranchID` - Branch
- `@FiscalPeriodID` - Accounting period
- `@IsPosted` - 0 (draft) or 1 (posted)
- `@CreatedBy` - User creating entry

**Business Rules:**
- Must balance (debits = credits)
- Can be saved as draft (`IsPosted = 0`)
- Must be posted to affect GL (`IsPosted = 1`)
- Used for adjustments, accruals, corrections

**Common Uses:**
- Month-end accruals
- Depreciation entries
- Error corrections
- Reclassifications
- Period-end adjustments

---

## 9. OPENING BALANCES

### 9.1 OPENING BALANCE IMPORT

**Trigger:** When opening balances are imported for new fiscal year  
**Location:** ERP → OpeningBalancesForm.vb  
**Stored Procedure:** `sp_GL_ImportOpeningBalances`  
**Posting Status:** Posted when imported (`IsPosted = 1`)

**Journal Entry:**
```
Journal Number: OB-{FiscalYear}
Description: Opening Balances for Fiscal Year {FiscalYear}

Debit:  {Asset/Expense Accounts}     (Debit balances)
Credit: {Liability/Equity/Revenue}   (Credit balances)

MUST BALANCE: Total Debits = Total Credits
```

**Parameters:**
- `@FiscalYear` - Fiscal year (e.g., 2026)
- `@ImportedBy` - User importing balances
- `@PostImmediately` - 1 (post now) or 0 (save as draft)

**Business Rules:**
- Opening balances must balance
- Typically done once per fiscal year
- Updates ChartOfAccounts.OpeningBalance
- Updates ChartOfAccounts.CurrentBalance
- Creates journal entry for audit trail

**Account Types:**
- **Assets** - Debit opening balances
- **Liabilities** - Credit opening balances
- **Equity** - Credit opening balances
- **Revenue** - Credit opening balances (if mid-year)
- **Expenses** - Debit opening balances (if mid-year)

---

## 10. ACCOUNT MAPPING REFERENCE

### 10.1 BALANCE SHEET ACCOUNTS

| Account Code | Account Name | Type | Used In |
|---|---|---|---|
| **ASSETS** |
| 1010 | Bank Account | Asset | POS Sales, Payments, Receipts, Deposits |
| 1030 | Cash on Hand | Asset | POS Sales, Cash Receipts, Cash Payments |
| 1025 | Petty Cash | Asset | Petty Cash Top-Up |
| 1028 | Sundries Cash | Asset | Miscellaneous cash |
| 1200 | Accounts Receivable | Asset | Customer invoices, payments |
| 1210 | Finished Goods Inventory | Asset | Manufacturing completion |
| 1220 | Retail Inventory | Asset | GRV, POS Sales, Stock Adjustments |
| 1310 | Stockroom Inventory | Asset | Raw materials |
| 1320 | Manufacturing Inventory | Asset | Work in progress |
| 1600 | Inter-Branch Debtors | Asset | IBT sending branch |
| **LIABILITIES** |
| 2010 | Accounts Payable | Liability | Supplier invoices, payments |
| 2020 | VAT Output (Sales VAT) | Liability | POS Sales, Refunds |
| 2021 | VAT Input (Purchase VAT) | Asset | Purchase invoices (NEEDED) |
| 2050 | GRIR (Goods Received/Invoice Receipt) | Liability | GRV, Invoice matching |
| 1610 | Inter-Branch Creditors | Liability | IBT receiving branch (NEEDED) |

### 10.2 INCOME STATEMENT ACCOUNTS

| Account Code | Account Name | Type | Used In |
|---|---|---|---|
| **REVENUE** |
| 4010 | Sales Revenue | Revenue | POS Sales, Refunds |
| 4020 | Other Income | Revenue | Miscellaneous income |
| 4030 | Found Stock Income | Revenue | Stock adjustments (NEEDED) |
| **COST OF SALES** |
| 5010 | Cost of Goods Sold | Expense | POS Sales, Refunds |
| **EXPENSES** |
| 5030 | Petty Cash Expenses | Expense | Petty cash |
| 5040 | Direct Labor | Expense | Manufacturing |
| 6010 | Rent Expense | Expense | Cash payments |
| 6020 | Utilities | Expense | Cash payments |
| 6030 | Salaries | Expense | Payroll |
| 6080 | Stock Loss/Shrinkage | Expense | Stock adjustments (NEEDED) |
| 6090 | Manufacturing Overhead | Expense | Manufacturing |

---

## 11. POSTING FLOW DIAGRAMS

### 11.1 POS SALE FLOW

```
Customer Purchase
        ↓
[POS System - PaymentTenderForm]
        ↓
Payment Tendered (Cash/Card)
        ↓
Sale Saved to Database
        ↓
[TRIGGER: sp_POS_PostSaleToGL]
        ↓
GL Journal Created (IsPosted=1)
        ↓
┌─────────────────────────────────┐
│ Dr: Bank/Cash (Payment)         │
│ Cr: Sales Revenue (Subtotal)    │
│ Cr: VAT Output (VAT)             │
│ Dr: COGS (Cost)                  │
│ Cr: Inventory (Cost)             │
└─────────────────────────────────┘
        ↓
Receipt Printed
        ↓
END
```

---

### 11.2 PURCHASE ORDER FLOW (3-WAY MATCHING)

```
Purchase Order Created
        ↓
Goods Received (GRV)
        ↓
[TRIGGER: sp_PO_PostGRVToGL]
        ↓
┌─────────────────────────────────┐
│ Dr: Inventory                    │
│ Cr: GRIR (Invoice Pending)       │
└─────────────────────────────────┘
        ↓
Supplier Invoice Received
        ↓
Invoice Matched to GRV
        ↓
[TRIGGER: sp_PO_PostInvoiceToGL]
        ↓
┌─────────────────────────────────┐
│ Dr: GRIR (Clear Pending)         │
│ Cr: Accounts Payable             │
└─────────────────────────────────┘
        ↓
Payment Due Date Reached
        ↓
Payment Processed
        ↓
[TRIGGER: sp_AP_PostPaymentToGL]
        ↓
┌─────────────────────────────────┐
│ Dr: Accounts Payable             │
│ Cr: Bank Account                 │
└─────────────────────────────────┘
        ↓
END
```

---

### 11.3 BULK PAYMENT FLOW (FNB API)

```
Multiple Invoices Selected
        ↓
Batch Created (Status: Pending)
        ↓
User Reviews Batch
        ↓
Submit to FNB API
        ↓
Batch Status: Submitted
        ↓
FNB Processes Payments
        ↓
Bank Response Received
        ↓
┌─────────────┬─────────────┐
│  SUCCESS    │   FAILED    │
└─────────────┴─────────────┘
      ↓              ↓
Status: Completed   Status: Failed
      ↓              ↓
[TRIGGER GL POST]   NO GL POST
      ↓              ↓
For Each Invoice:   User Notified
┌─────────────────────────────────┐
│ Dr: Accounts Payable             │
│ Cr: Bank Account                 │
└─────────────────────────────────┘
      ↓
Supplier Notified
      ↓
END
```

---

### 11.4 MANUFACTURING FLOW

```
Production Order Created (BOM)
        ↓
Raw Materials Issued to Manufacturing
        ↓
Production Completed
        ↓
[TRIGGER: sp_MFG_PostProductionToGL]
        ↓
┌─────────────────────────────────┐
│ Dr: Finished Goods Inventory     │
│ Cr: Raw Materials Inventory      │
│ Cr: Direct Labor                 │
│ Cr: Manufacturing Overhead       │
└─────────────────────────────────┘
        ↓
Finished Goods to Retail
        ↓
[TRIGGER: sp_MFG_PostManufacturingToRetailTransfer] (NEEDED)
        ↓
┌─────────────────────────────────┐
│ Dr: Retail Inventory             │
│ Cr: Manufacturing Inventory      │
└─────────────────────────────────┘
        ↓
Available for Sale in POS
        ↓
END
```

---

### 11.5 INTER-BRANCH TRANSFER FLOW

```
Branch A Requests Stock from Branch B
        ↓
Branch B Creates Delivery Note
        ↓
[TRIGGER: sp_MFG_PostInventoryTransferToGL]
        ↓
Branch B Journal:
┌─────────────────────────────────┐
│ Dr: Inter-Branch Debtors         │
│ Cr: Inventory                    │
└─────────────────────────────────┘
        ↓
Goods Dispatched
        ↓
Branch A Receives Goods
        ↓
[TRIGGER: sp_IBT_PostReceiptToGL] (NEEDED)
        ↓
Branch A Journal:
┌─────────────────────────────────┐
│ Dr: Inventory                    │
│ Cr: Inter-Branch Creditors       │
└─────────────────────────────────┘
        ↓
Branch A Pays Branch B
        ↓
[TRIGGER: sp_IBT_PostSettlementToGL] (NEEDED)
        ↓
Branch B Journal:
┌─────────────────────────────────┐
│ Dr: Bank Account                 │
│ Cr: Inter-Branch Debtors         │
└─────────────────────────────────┘
Branch A Journal:
┌─────────────────────────────────┐
│ Dr: Inter-Branch Creditors       │
│ Cr: Bank Account                 │
└─────────────────────────────────┘
        ↓
END
```

---

## 12. VAT TRACKING FOR SARS

### 12.1 VAT OUTPUT (Sales VAT Collected)

**Account:** 2020 - VAT Output  
**Nature:** Liability (owed to SARS)

**Posted From:**
- POS Sales (`sp_POS_PostSaleToGL`) - Credit
- POS Refunds (`sp_POS_PostRefundToGL`) - Debit (reversal)

**Calculation:**
```sql
SELECT SUM(Credit - Debit) AS VATOutput
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE coa.AccountCode = '2020'
  AND jh.IsPosted = 1
  AND jh.JournalDate BETWEEN @FromDate AND @ToDate
```

---

### 12.2 VAT INPUT (Purchase VAT Claimable)

**Account:** 2021 - VAT Input  
**Nature:** Asset (claimable from SARS)

**Posted From:**
- Purchase Invoices (NEEDS IMPLEMENTATION)
- Expense Invoices (NEEDS IMPLEMENTATION)

**Calculation:**
```sql
SELECT SUM(Debit - Credit) AS VATInput
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE coa.AccountCode = '2021'
  AND jh.IsPosted = 1
  AND jh.JournalDate BETWEEN @FromDate AND @ToDate
```

---

### 12.3 NET VAT PAYABLE/REFUNDABLE

**Calculation:**
```sql
DECLARE @VATOutput DECIMAL(18,2)
DECLARE @VATInput DECIMAL(18,2)

-- VAT Output (Sales VAT collected)
SELECT @VATOutput = SUM(Credit - Debit)
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE coa.AccountCode = '2020'
  AND jh.IsPosted = 1
  AND jh.JournalDate BETWEEN @FromDate AND @ToDate

-- VAT Input (Purchase VAT paid)
SELECT @VATInput = SUM(Debit - Credit)
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE coa.AccountCode = '2021'
  AND jh.IsPosted = 1
  AND jh.JournalDate BETWEEN @FromDate AND @ToDate

-- Net VAT Payable (positive) or Refundable (negative)
SELECT (@VATOutput - @VATInput) AS NetVATPayable
```

**SARS VAT201 Mapping:**
- **Box 5** (Output Tax) = VAT Output (2020)
- **Box 14** (Input Tax) = VAT Input (2021)
- **Box 19** (Net VAT Payable) = Output - Input

---

### 12.4 ENHANCEMENTS NEEDED FOR COMPLETE VAT TRACKING

**1. Purchase Invoice VAT Tracking:**
```sql
-- Modify sp_PO_PostInvoiceToGL to include VAT Input
Debit:  2050 GRIR                   (Goods value excluding VAT)
Debit:  2021 VAT Input              (VAT amount - 15%)
Credit: 2010 Accounts Payable       (Total including VAT)
```

**2. Expense Invoice VAT Tracking:**
```sql
-- Create sp_AP_PostExpenseInvoiceToGL
Debit:  {ExpenseAccount}            (Expense excluding VAT)
Debit:  2021 VAT Input              (VAT amount - 15%)
Credit: 2010 Accounts Payable       (Total including VAT)
```

**3. VAT Reconciliation Report:**
- Create form to generate VAT201 report
- Show VAT Output by period
- Show VAT Input by period
- Calculate net VAT payable/refundable
- Export to Excel for SARS submission

---

## 13. MISSING INTEGRATIONS & ENHANCEMENTS

### 13.1 HIGH PRIORITY (Needed for Complete GL)

1. **VAT Input Tracking on Purchases**
   - Modify `sp_PO_PostInvoiceToGL` to split VAT
   - Create `sp_AP_PostExpenseInvoiceToGL` with VAT split
   - **Impact:** SARS VAT returns incomplete without this

2. **Manufacturing to Retail Transfer**
   - Create `sp_MFG_PostManufacturingToRetailTransfer`
   - **Impact:** Finished goods not properly tracked

3. **IBT Receipt Posting**
   - Create `sp_IBT_PostReceiptToGL`
   - **Impact:** Receiving branch inventory not posted

4. **IBT Settlement Posting**
   - Create `sp_IBT_PostSettlementToGL`
   - **Impact:** Inter-branch balances not cleared

5. **Stock Adjustment Posting**
   - Create `sp_INV_PostStockAdjustmentToGL`
   - **Impact:** Stock variances not in GL

---

### 13.2 MEDIUM PRIORITY (Operational Improvements)

6. **Petty Cash Top-Up Posting**
   - Create `sp_CB_PostPettyCashTopUpToGL`
   - **Impact:** Petty cash movements not tracked in GL

7. **Credit Note Posting**
   - Create `sp_AP_PostCreditNoteToGL`
   - **Impact:** Supplier credit notes not in GL

8. **SARS VAT Return Form**
   - Create VB.NET form for VAT201 generation
   - **Impact:** Manual VAT calculation required

9. **Bank Reconciliation Integration**
   - Link bank statements to GL postings
   - **Impact:** Manual reconciliation required

---

### 13.3 LOW PRIORITY (Nice to Have)

10. **Depreciation Posting**
    - Automated monthly depreciation journals
    - **Impact:** Manual journal entries required

11. **Payroll Integration**
    - Post payroll to GL automatically
    - **Impact:** Manual payroll journals required

12. **Customer Invoicing (AR)**
    - Post customer invoices to GL
    - **Impact:** Currently no formal AR system

---

## 14. POSTING CHECKLIST FOR DEVELOPERS

### Before Implementing New Feature:

- [ ] Identify the business transaction
- [ ] Determine which accounts are affected
- [ ] Decide if posting should be automatic or manual
- [ ] Create stored procedure for GL posting
- [ ] Add error handling (TRY/CATCH)
- [ ] Set `IsPosted = 1` for automatic posting
- [ ] Include BranchID for multi-branch tracking
- [ ] Add audit fields (CreatedBy, CreatedDate)
- [ ] Test posting with sample data
- [ ] Verify journal balances (Debits = Credits)
- [ ] Test error scenarios (missing accounts, etc.)
- [ ] Document in this file

---

## 15. TESTING SCENARIOS

### 15.1 POS Sale Test

1. Create test sale with R100 subtotal + R15 VAT = R115 total
2. Payment: R50 cash + R65 card
3. COGS: R60
4. Expected GL entries:
   - Dr: 1030 Cash R50
   - Dr: 1010 Bank R65
   - Cr: 4010 Sales R100
   - Cr: 2020 VAT Output R15
   - Dr: 5010 COGS R60
   - Cr: 1220 Inventory R60
5. Verify: Debits (R175) = Credits (R175)

---

### 15.2 Purchase Order Test

1. Create PO for R1000 goods
2. Receive GRV
3. Expected GL entries:
   - Dr: 1220 Inventory R1000
   - Cr: 2050 GRIR R1000
4. Receive invoice for R1150 (R1000 + R150 VAT)
5. Expected GL entries:
   - Dr: 2050 GRIR R1000
   - Dr: 2021 VAT Input R150 (NEEDS IMPLEMENTATION)
   - Cr: 2010 AP R1150
6. Make payment
7. Expected GL entries:
   - Dr: 2010 AP R1150
   - Cr: 1010 Bank R1150

---

### 15.3 Bulk Payment Test

1. Create batch with 3 invoices: R1000, R2000, R3000
2. Submit to FNB API
3. Receive success response
4. Expected GL entries (3 separate journals):
   - Journal 1: Dr: 2010 AP R1000, Cr: 1010 Bank R1000
   - Journal 2: Dr: 2010 AP R2000, Cr: 1010 Bank R2000
   - Journal 3: Dr: 2010 AP R3000, Cr: 1010 Bank R3000
5. Verify: Total bank reduction = R6000

---

## 16. TROUBLESHOOTING

### Issue: Journal Not Posted

**Symptoms:** Transaction saved but no GL journal created

**Possible Causes:**
1. Stored procedure not called
2. Error in stored procedure (check SQL error log)
3. Missing account in ChartOfAccounts
4. `IsPosted` set to 0 instead of 1

**Solution:**
1. Check application log for errors
2. Run stored procedure manually with test data
3. Verify all accounts exist and are active
4. Check `IsPosted` flag in JournalHeaders table

---

### Issue: Unbalanced Journal

**Symptoms:** Debits ≠ Credits

**Possible Causes:**
1. Missing journal line
2. Incorrect amount calculation
3. Rounding errors

**Solution:**
1. Query journal details:
```sql
SELECT 
    jh.JournalNumber,
    SUM(jd.Debit) AS TotalDebits,
    SUM(jd.Credit) AS TotalCredits,
    SUM(jd.Debit) - SUM(jd.Credit) AS Difference
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
WHERE jh.JournalNumber = 'POS-12345'
GROUP BY jh.JournalNumber
```
2. Identify missing or incorrect line
3. Correct stored procedure logic

---

### Issue: VAT Not Tracking

**Symptoms:** VAT Output shows data but VAT Input is zero

**Cause:** VAT Input posting not implemented on purchases

**Solution:** Implement VAT Input tracking (see Section 12.4)

---

## 17. SUMMARY

### Total Posting Triggers Identified: 15

**Implemented (9):**
1. ✅ POS Sale
2. ✅ POS Refund
3. ✅ GRV (Goods Receipt)
4. ✅ Supplier Invoice
5. ✅ Supplier Payment
6. ✅ Cash Receipt
7. ✅ Cash Payment
8. ✅ Bank Deposit
9. ✅ Manufacturing Production
10. ✅ IBT Sending Branch
11. ✅ Manual Journal Entry
12. ✅ Opening Balances

**Needs Implementation (6):**
13. ❌ VAT Input on Purchases (HIGH PRIORITY)
14. ❌ Manufacturing to Retail Transfer
15. ❌ IBT Receipt (Receiving Branch)
16. ❌ IBT Settlement
17. ❌ Stock Adjustment
18. ❌ Petty Cash Top-Up
19. ❌ Credit Note
20. ❌ Bulk Payment (FNB API) - Partially implemented

**Posting Coverage:** 75% (12 of 16 core transactions)

---

## DOCUMENT CONTROL

**Created By:** Cascade AI Assistant  
**Date:** January 27, 2026  
**Version:** 1.0  
**Last Updated:** January 27, 2026  
**Next Review:** When new posting triggers are implemented

**Change Log:**
- v1.0 (2026-01-27): Initial comprehensive documentation created

---

**END OF DOCUMENT**
