# POS GL INTEGRATION - ACTION PLAN FOR TOMORROW

## Current Status
- GL posting procedures created and modified
- POS code updated to call GL procedures
- Executive Dashboard UI fixes applied
- **Issue:** Sales not appearing in GL Inquiry, no VAT data, negative balances

---

## STEP 1: RUN DIAGNOSTIC (5 minutes)

Run this on Azure database:
```sql
:r "Database\GL\TOMORROW_DIAGNOSTIC_PLAN.sql"
```

This will check:
- ✓ Procedures exist
- ✓ GL accounts exist
- ✓ Recent POS sales
- ✓ POS journals created
- ✓ GL balances
- ✓ Fiscal period function works
- ✓ Manual test of GL posting

**Save the output** - it will tell us exactly what's broken.

---

## STEP 2: DEPLOY PROCEDURES (if not already done)

If diagnostic shows procedures missing or old version:

```sql
-- Deploy in order:
:r "Database\GL\08_Fiscal_Period_Function.sql"
:r "Database\GL\09_POS_Integration_Procedures.sql"
```

---

## STEP 3: VERIFY GL ACCOUNTS

If diagnostic shows missing accounts, create them:

```sql
-- Run this if accounts are missing
INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
VALUES 
('1010', 'Bank Account - Current', 'Asset', 1),
('1030', 'Cash on Hand', 'Asset', 1),
('4010', 'Sales Revenue - Retail', 'Revenue', 1),
('2020', 'VAT Output (Payable)', 'Liability', 1),
('2021', 'VAT Input (Receivable)', 'Asset', 1),
('5010', 'Cost of Goods Sold', 'Expense', 1),
('1220', 'Inventory - Retail Stock', 'Asset', 1)
```

---

## STEP 4: REBUILD APPLICATIONS

**ERP:**
1. Build → Rebuild Solution
2. Close ERP completely
3. Restart ERP
4. Verify Executive Dashboard looks correct

**POS:**
1. Build → Rebuild Solution
2. Deploy to POS terminals
3. Verify GL posting code is in PaymentTenderForm.vb (lines 772-794)

---

## STEP 5: TEST POS SALE

1. Do a small cash sale (e.g., R10.00)
2. Note the invoice number (e.g., 620062)
3. Check for error popup (should be none if working)
4. Run this query:

```sql
-- Check if journal was created
DECLARE @Invoice NVARCHAR(50) = '620062' -- Use actual invoice number
DECLARE @JournalNum NVARCHAR(20) = 'POS-' + @Invoice

SELECT * FROM JournalHeaders WHERE JournalNumber = @JournalNum

-- If found, check details
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = @JournalNum
ORDER BY jd.LineNumber
```

---

## STEP 6: VERIFY IN GL INQUIRY

1. Open GL Inquiry in ERP
2. Select account **4010** (not 4000)
3. Set date range to include today
4. Click Search
5. Should see the POS sale

---

## EXPECTED RESULTS

**For a R115 cash sale (R100 + R15 VAT, R60 cost):**

| Account | Name | Debit | Credit |
|---------|------|-------|--------|
| 1030 | Cash on Hand | 115.00 | 0.00 |
| 4010 | Sales Revenue | 0.00 | 100.00 |
| 2020 | VAT Output | 0.00 | 15.00 |
| 5010 | Cost of Goods Sold | 60.00 | 0.00 |
| 1220 | Inventory | 0.00 | 60.00 |

**Total Debits: 175.00**
**Total Credits: 175.00**
**Balanced: ✓**

---

## TROUBLESHOOTING

### If no journal created:
1. Check diagnostic output for errors
2. Verify procedure was deployed
3. Check if POS was rebuilt
4. Look for error in manual test (section 7 of diagnostic)

### If negative balances:
- This is normal for revenue/liability accounts (credit balance)
- Sales Revenue (4010) should have credit balance (negative)
- VAT Output (2020) should have credit balance (negative)

### If COGS not posted:
- Check if `CalculateTotalCost()` function works in POS
- Verify Demo_Retail_Price table has cost prices
- Check diagnostic manual test output

### If VAT not showing:
- Verify account 2020 (VAT Output) exists
- Check if @TaxAmount parameter is being passed correctly
- Review journal details in diagnostic output

---

## FILES MODIFIED TODAY

**Database:**
- `09_POS_Integration_Procedures.sql` - Fixed journal number generation for invoice format without dashes

**ERP:**
- `ExecutiveDashboard.vb` - Header height 60px, "TOTAL TRANSACTIONS" label
- `GeneralLedgerInquiryForm.vb` - Grid header height 40px

**POS:**
- `PaymentTenderForm.vb` - Added GL posting with error popup (line 792)
- `ReturnLineItemsForm.vb` - Added GL posting for refunds

---

## CONTACT POINTS

If still not working after all steps:
1. Share diagnostic output
2. Share error message from POS (if any)
3. Share screenshot of GL Inquiry showing no results
4. Share journal details query results

---

## REST NOW

Get some sleep. Tomorrow morning:
1. Run diagnostic (5 min)
2. Review output
3. Follow action plan based on findings
4. Test and verify

Everything is documented and ready for tomorrow.
