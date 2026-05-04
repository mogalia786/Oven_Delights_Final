# END OF DAY CASH-UP REPORT GUIDE
## Professional Till Reconciliation System

---

## 🎯 OVERVIEW

The End of Day Cash-Up Report is a **WOW FACTOR** feature that provides:
- ✅ **Professional printed reports** for each till
- ✅ **Automatic calculation** of expected cash
- ✅ **Cash denomination breakdown** for physical counting
- ✅ **Variance tracking** (Over/Short)
- ✅ **Signature sections** for accountability
- ✅ **Beautiful, easy-to-read design**

---

## 📍 HOW TO ACCESS

### **In ERP Application:**
```
Retail → Reports → End of Day Cash-Up
```

---

## 🚀 QUICK START

### **Step 1: Run SQL Script**
```sql
SQL\CREATE_END_OF_DAY_CASHUP_SP.sql
```

### **Step 2: Rebuild ERP**
```
Build → Rebuild Solution
```

### **Step 3: Open Report**
```
ERP → Retail → Reports → End of Day Cash-Up
```

---

## 📊 REPORT FEATURES

### **1. SALES SUMMARY**
Shows complete sales breakdown:
- Total Sales (Excl VAT)
- VAT Amount
- Total Sales (Incl VAT)
- Number of Transactions

### **2. PAYMENT BREAKDOWN**
Breaks down by payment method:
- Cash Payments
- Card Payments (Debit/Credit)
- EFT Payments
- Account Payments

### **3. EXPECTED CASH**
Calculates what SHOULD be in the till:
- Cash sales
- Cash portion of split payments
- Opening float (if tracked)

### **4. CASH DENOMINATION BREAKDOWN**
Physical counting section with:
- R200 notes
- R100 notes
- R50 notes
- R20 notes
- R10 notes/coins
- R5 coins
- R2 coins
- R1 coins
- 50c, 20c, 10c, 5c coins

**Cashier fills in quantity of each denomination**

### **5. VARIANCE CALCULATION**
Automatic calculation:
```
Variance = Actual Cash Counted - Expected Cash

Positive = Cash Over (excess)
Negative = Cash Short (shortage)
```

### **6. SIGNATURE SECTION**
Accountability:
- Cashier Signature
- Manager Signature

---

## 💼 DAILY WORKFLOW

### **End of Day Process:**

**1. Close Till for the Day**
- Stop taking new transactions
- Complete any pending sales

**2. Generate Report in ERP**
```
Retail → Reports → End of Day Cash-Up
Select: Branch, Date, Till
Click: Generate Report
```

**3. Print Report**
```
Click: Print Report
Print 2 copies (one for cashier, one for office)
```

**4. Count Physical Cash**
- Count each denomination
- Fill in quantities on printed report
- Calculate total

**5. Compare & Reconcile**
```
Expected Cash: R 5,234.50 (from system)
Actual Cash:   R 5,230.00 (counted)
Variance:      R   -4.50 (short)
```

**6. Sign Off**
- Cashier signs report
- Manager verifies and signs
- File report with daily paperwork

**7. Bank Cash**
- Remove excess cash for banking
- Leave opening float for next day
- Record banking slip number

---

## 📋 REPORT SECTIONS EXPLAINED

### **SALES SUMMARY**
```
Total Sales (Excl VAT):  R 4,551.74
VAT Amount:              R   682.76
Total Sales (Incl VAT):  R 5,234.50
Number of Transactions:  47
```

### **PAYMENT BREAKDOWN**
```
Cash Payments:     R 3,450.00
Card Payments:     R 1,234.50
EFT Payments:      R   350.00
Account Payments:  R   200.00
```

### **EXPECTED CASH IN TILL**
```
Expected Cash (System):  R 3,450.00
```
*This is what SHOULD be in the till based on cash sales*

### **ACTUAL CASH COUNTED**
```
R200 x  10  = R 2,000.00
R100 x   8  = R   800.00
R50  x   6  = R   300.00
R20  x  12  = R   240.00
R10  x   8  = R    80.00
R5   x   4  = R    20.00
R2   x   3  = R     6.00
R1   x   2  = R     2.00
50c  x   2  = R     1.00
20c  x   1  = R     0.20
10c  x   3  = R     0.30
5c   x   2  = R     0.10
─────────────────────────
TOTAL ACTUAL CASH: R 3,449.60
```

### **VARIANCE**
```
VARIANCE (Over/Short): R -0.40 (SHORT)
```

---

## 🎨 REPORT DESIGN

### **Color Coding:**
- **Red Header**: Company branding
- **Green**: Expected cash (system)
- **Orange**: Actual cash (counted)
- **Red**: Variance (if any)

### **Professional Layout:**
- Large, clear fonts
- Organized sections
- Easy-to-read tables
- Signature lines
- Print-friendly design

---

## 🔍 TROUBLESHOOTING

### **Problem: Report Shows Zero Sales**

**Possible Causes:**
1. Wrong date selected
2. Wrong till selected
3. No sales recorded for that date

**Solution:**
- Verify date is correct
- Check till selection
- Verify sales were posted to correct till

---

### **Problem: Expected Cash Doesn't Match**

**Possible Causes:**
1. Split payments not tracked correctly
2. Refunds not accounted for
3. Opening float not set

**Solution:**
- Check split payment tracking
- Verify refund transactions
- Set opening float in system

---

### **Problem: Can't Print Report**

**Solution:**
1. Check printer connection
2. Verify printer is default
3. Try Print Preview first

---

## 📝 BEST PRACTICES

### **1. Daily Consistency**
- Generate report same time every day
- Use same process every time
- Keep reports organized

### **2. Accuracy**
- Count cash twice
- Use coin counter if available
- Check large notes for counterfeits

### **3. Documentation**
- File all reports
- Note any variances
- Keep for audit trail

### **4. Security**
- Lock till during counting
- Count in secure area
- Two-person verification for large amounts

### **5. Variance Management**
```
Acceptable Variance: ±R5.00
Small Variance (R5-R20): Manager approval
Large Variance (>R20): Investigation required
```

---

## 🎯 KEY BENEFITS

### **For Cashiers:**
- ✅ Clear, easy-to-follow format
- ✅ No manual calculations needed
- ✅ Professional documentation

### **For Managers:**
- ✅ Quick verification process
- ✅ Automatic variance detection
- ✅ Audit trail for accountability

### **For Business:**
- ✅ Reduced cash discrepancies
- ✅ Better cash management
- ✅ Professional appearance
- ✅ Improved accountability

---

## 📊 REPORTING CAPABILITIES

### **Per Till Reports:**
- Individual till cash-up
- Separate reports for each till
- Till-specific accountability

### **All Tills Summary:**
- Select "All Tills" option
- See branch-wide summary
- Compare till performance

### **Historical Reports:**
- Select any past date
- Review previous cash-ups
- Trend analysis

---

## 🔐 SECURITY FEATURES

### **Access Control:**
- Only authorized users can access
- Branch-specific data
- Audit trail of report generation

### **Data Integrity:**
- Read-only system data
- Manual entry only for actual cash
- Variance automatically calculated

---

## 📈 VARIANCE ANALYSIS

### **Common Causes of Variances:**

**Cash Short:**
- Incorrect change given
- Unrecorded sales
- Theft/pilferage
- Counting errors

**Cash Over:**
- Incorrect change given
- Duplicate entries
- Counting errors
- Unreported refunds

---

## ✅ COMPLETION CHECKLIST

Daily Cash-Up Process:

- [ ] Generate report for each till
- [ ] Print 2 copies per till
- [ ] Count physical cash
- [ ] Fill in denomination breakdown
- [ ] Calculate total actual cash
- [ ] Compare with expected cash
- [ ] Note variance (if any)
- [ ] Cashier signs report
- [ ] Manager verifies and signs
- [ ] File one copy
- [ ] Give one copy to cashier
- [ ] Bank excess cash
- [ ] Leave opening float
- [ ] Record banking details

---

## 🎉 WOW FACTORS

### **What Makes This Special:**

1. **Professional Design**
   - Beautiful, modern layout
   - Color-coded sections
   - Easy to read

2. **Complete Automation**
   - No manual calculations
   - Automatic variance detection
   - Real-time data

3. **Physical Reconciliation**
   - Cash denomination breakdown
   - Matches physical counting process
   - Industry-standard format

4. **Accountability**
   - Signature sections
   - Audit trail
   - Clear responsibility

5. **Flexibility**
   - Per till or all tills
   - Any date range
   - Multiple branches

---

## 📞 SUPPORT

If you encounter issues:
1. Check this guide first
2. Verify SQL script ran successfully
3. Ensure till data is correct
4. Check date/branch selection

---

**Your professional cash-up system is ready!** 🎉

This report will impress auditors, managers, and cashiers alike with its professional appearance and comprehensive functionality.
