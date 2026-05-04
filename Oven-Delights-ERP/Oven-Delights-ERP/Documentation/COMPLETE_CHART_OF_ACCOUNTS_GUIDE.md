# COMPLETE CHART OF ACCOUNTS - ALL SCENARIOS

## Decision Matrix: When to Use Subsidiary Ledgers

### ✅ USE SUBSIDIARY LEDGERS when:
- Multiple entities of the same type (multiple suppliers, customers, landlords)
- Need to track individual balances
- Need detailed transaction history per entity
- Need reconciliation to control account

### ❌ DON'T USE SUBSIDIARY LEDGERS when:
- Single entity (one insurance company, one bank)
- Infrequent transactions
- No need for individual tracking
- Simple expense categories

---

## COMPLETE CHART OF ACCOUNTS STRUCTURE

### 1000-1999: ASSETS

#### 1100-1199: Current Assets
```
1100 - Cash on Hand
1110 - Petty Cash - Head Office
1111 - Petty Cash - Branch 1
1112 - Petty Cash - Branch 2

1120 - Bank Account - FNB Current
1121 - Bank Account - FNB Savings
1122 - Bank Account - Nedbank

1130 - Accounts Receivable (CONTROL) ⭐
  ├── 1130-001 - Customer A
  ├── 1130-002 - Customer B
  └── 1130-003 - Corporate Client XYZ

1140 - Inventory - Raw Materials
1141 - Inventory - Finished Goods
1142 - Inventory - Work in Progress

1150 - Prepaid Expenses (CONTROL) ⭐
  ├── 1150-001 - Prepaid Rent
  ├── 1150-002 - Prepaid Insurance
  └── 1150-003 - Prepaid Subscriptions

1160 - Loans Receivable (CONTROL) ⭐
  ├── 1160-001 - Loan to Employee A
  └── 1160-002 - Loan to Subsidiary
```

#### 1200-1299: Fixed Assets
```
1200 - Land & Buildings
1210 - Vehicles (CONTROL) ⭐
  ├── 1210-001 - Vehicle - ABC123GP
  ├── 1210-002 - Vehicle - XYZ456GP
  └── 1210-003 - Vehicle - DEF789GP

1220 - Equipment & Machinery
1230 - Furniture & Fittings
1240 - Computer Equipment

1250 - Accumulated Depreciation - Buildings
1251 - Accumulated Depreciation - Vehicles
1252 - Accumulated Depreciation - Equipment
```

---

### 2000-2999: LIABILITIES

#### 2100-2199: Current Liabilities
```
2100 - Accounts Payable (CONTROL) ⭐
  ├── 2100-001 - ABC Suppliers
  ├── 2100-002 - XYZ Trading
  └── 2100-003 - Eskom

2110 - Salaries Payable
2120 - VAT Payable
2130 - PAYE Payable
2140 - UIF Payable
2150 - SDL Payable

2160 - Accrued Expenses (CONTROL) ⭐
  ├── 2160-001 - Accrued Utilities
  ├── 2160-002 - Accrued Professional Fees
  └── 2160-003 - Accrued Interest

2170 - Deferred Revenue (CONTROL) ⭐
  ├── 2170-001 - Deferred - Customer A
  └── 2170-002 - Deferred - Customer B
```

#### 2200-2299: Long-term Liabilities
```
2200 - Loans Payable (CONTROL) ⭐
  ├── 2200-001 - Loan - FNB
  ├── 2200-002 - Loan - Nedbank
  └── 2200-003 - Loan - Director

2210 - Mortgage Payable
2220 - Vehicle Finance (CONTROL) ⭐
  ├── 2220-001 - Finance - Vehicle ABC123GP
  └── 2220-002 - Finance - Vehicle XYZ456GP
```

---

### 3000-3999: EQUITY

```
3000 - Share Capital
3100 - Retained Earnings
3200 - Current Year Profit/Loss
3300 - Drawings
```

---

### 4000-4999: INCOME

#### 4000-4099: Sales Revenue
```
4000 - Sales Revenue - Product A
4010 - Sales Revenue - Product B
4020 - Sales Revenue - Services
4030 - Sales Revenue - Wholesale
4040 - Sales Revenue - Retail
```

#### 4100-4199: Rent Income
```
4100 - Rent Income (CONTROL) ⭐
  ├── 4100-001 - Rent - Mr Thomas
  ├── 4100-002 - Rent - ABC Company
  └── 4100-003 - Rent - Retail Shop 1
```

#### 4200-4299: Interest Income
```
4200 - Interest Income (CONTROL) ⭐
  ├── 4200-001 - Interest - FNB Savings
  ├── 4200-002 - Interest - Investment Account
  └── 4200-003 - Interest - Fixed Deposit
```

#### 4300-4399: Other Income
```
4300 - Commission Income (CONTROL) ⭐
  ├── 4300-001 - Commission - Agent A
  └── 4300-002 - Commission - Agent B

4310 - Dividend Income (CONTROL) ⭐
  ├── 4310-001 - Dividend - Company A Shares
  └── 4310-002 - Dividend - Company B Shares

4320 - Royalty Income
4330 - Service Income
4340 - Discount Received
4350 - Foreign Exchange Gains
4360 - Asset Sale Gains
4370 - Insurance Claims Received
4380 - Sundry Income
```

---

### 5000-5999: COST OF SALES

```
5000 - Cost of Goods Sold
5010 - Purchases
5020 - Freight Inwards
5030 - Customs & Duties
```

---

### 6000-6999: OPERATING EXPENSES

#### 6000-6099: Employee Costs
```
6000 - Salaries & Wages (CONTROL) ⭐
  ├── 6000-001 - Salary - John Doe
  ├── 6000-002 - Salary - Jane Smith
  └── 6000-003 - Salary - Department Manager

6010 - PAYE
6020 - UIF
6030 - SDL
6040 - Pension Contributions
6050 - Medical Aid Contributions
6060 - Staff Training
6070 - Staff Welfare
```

#### 6100-6199: Premises Costs
```
6100 - Rent Expense (CONTROL) ⭐
  ├── 6100-001 - Rent - Property Owner ABC
  └── 6100-002 - Rent - XYZ Properties

6110 - Rates & Taxes
6120 - Property Insurance
6130 - Security
6140 - Cleaning
6150 - Repairs & Maintenance - Building
```

#### 6200-6299: Utilities
```
6200 - Electricity (CONTROL) ⭐
  ├── 6200-001 - Electricity - Eskom Head Office
  └── 6200-002 - Electricity - Eskom Branch 1

6210 - Water & Sewerage (CONTROL) ⭐
  ├── 6210-001 - Water - City of Cape Town
  └── 6210-002 - Water - Johannesburg Water

6220 - Telephone & Internet (CONTROL) ⭐
  ├── 6220-001 - Telephone - Telkom
  ├── 6220-002 - Internet - Vumatel
  └── 6220-003 - Mobile - Vodacom

6230 - Gas
```

#### 6300-6399: Vehicle Expenses
```
6300 - Fuel (CONTROL) ⭐
  ├── 6300-001 - Fuel - Vehicle ABC123GP
  └── 6300-002 - Fuel - Vehicle XYZ456GP

6310 - Vehicle Maintenance (CONTROL) ⭐
  ├── 6310-001 - Maintenance - Vehicle ABC123GP
  └── 6310-002 - Maintenance - Vehicle XYZ456GP

6320 - Vehicle Insurance (CONTROL) ⭐
  ├── 6320-001 - Insurance - Vehicle ABC123GP
  └── 6320-002 - Insurance - Vehicle XYZ456GP

6330 - Vehicle Licensing
6340 - Toll Fees
```

#### 6400-6499: Office Expenses
```
6400 - Stationery & Supplies
6410 - Printing & Photocopying
6420 - Postage & Courier
6430 - Computer Expenses
6440 - Software Subscriptions (CONTROL) ⭐
  ├── 6440-001 - Subscription - Microsoft 365
  ├── 6440-002 - Subscription - Adobe Creative Cloud
  └── 6440-003 - Subscription - Accounting Software
```

#### 6500-6599: Professional Fees
```
6500 - Accounting Fees
6510 - Legal Fees
6520 - Consulting Fees
6530 - Audit Fees
6540 - Bank Charges (CONTROL) ⭐
  ├── 6540-001 - Bank Charges - FNB
  └── 6540-002 - Bank Charges - Nedbank
```

#### 6600-6699: Marketing & Sales
```
6600 - Advertising
6610 - Marketing Campaigns (CONTROL) ⭐
  ├── 6610-001 - Campaign - Summer 2026
  └── 6610-002 - Campaign - Black Friday

6620 - Website & Hosting
6630 - Social Media Marketing
6640 - Trade Shows & Events
6650 - Sales Commissions
```

#### 6700-6799: Insurance
```
6700 - Business Insurance (CONTROL) ⭐
  ├── 6700-001 - Insurance - Santam Business
  └── 6700-002 - Insurance - OUTsurance Commercial

6710 - Public Liability Insurance
6720 - Professional Indemnity Insurance
```

#### 6800-6899: Other Expenses
```
6800 - Depreciation Expense
6810 - Bad Debts
6820 - Discount Given
6830 - Foreign Exchange Losses
6840 - Asset Sale Losses
6850 - Donations & Sponsorships
6860 - Entertainment
6870 - Travel & Accommodation
6880 - Licenses & Permits
6890 - Sundry Expenses
```

---

## SUBSIDIARY LEDGER SUMMARY

### ✅ Accounts Requiring Subsidiary Ledgers:

**Assets:**
- Accounts Receivable (customers)
- Prepaid Expenses (by supplier/type)
- Loans Receivable (by borrower)
- Vehicles (by registration)

**Liabilities:**
- Accounts Payable (suppliers)
- Accrued Expenses (by supplier)
- Deferred Revenue (by customer)
- Loans Payable (by lender)
- Vehicle Finance (by vehicle)

**Income:**
- Rent Income (tenants)
- Interest Income (by source)
- Commission Income (agents)
- Dividend Income (by investment)

**Expenses:**
- Salaries & Wages (employees)
- Rent Expense (landlords)
- Electricity (by location/account)
- Water (by location/account)
- Telephone & Internet (by provider/account)
- Fuel (by vehicle)
- Vehicle Maintenance (by vehicle)
- Vehicle Insurance (by vehicle)
- Software Subscriptions (by service)
- Bank Charges (by bank)
- Marketing Campaigns (by campaign)
- Business Insurance (by policy)

---

## IMPLEMENTATION PRIORITY

### Phase 1: Critical (Implement First)
1. Accounts Payable (Suppliers) ✅ DONE
2. Accounts Receivable (Customers) ✅ DONE
3. Rent Income (Tenants) ✅ DONE
4. Rent Expense (Landlords) ✅ DONE

### Phase 2: Important (Implement Next)
5. Bank Accounts (multiple banks)
6. Loans Payable (by lender)
7. Salaries & Wages (by employee)
8. Vehicle Expenses (by vehicle)

### Phase 3: Nice to Have
9. Utilities (by provider/location)
10. Insurance (by policy)
11. Marketing Campaigns
12. Software Subscriptions

### Phase 4: Optional
13. Commission Income (by agent)
14. Dividend Income (by investment)
15. Prepaid Expenses
16. Accrued Expenses

---

## WHEN NOT TO USE SUBSIDIARY LEDGERS

**Simple Accounts (No Subsidiaries Needed):**
- Petty Cash (unless multiple custodians)
- Inventory (unless multiple locations)
- Stationery & Supplies
- Postage & Courier
- Depreciation
- Bad Debts
- Donations
- Entertainment
- Sundry Income/Expenses

**Rule of Thumb:**
- If you have **3+ entities** of the same type → Use subsidiary ledgers
- If you have **1-2 entities** → Simple account is fine
- If you need **individual balances** → Use subsidiary ledgers
- If you only need **totals** → Simple account is fine

---

## EXAMPLE SCENARIOS

### Scenario 1: Multiple Vehicles
**Problem:** Track fuel, maintenance, insurance per vehicle

**Solution:**
```
6300 - Fuel (Control)
  ├── 6300-001 - Fuel - ABC123GP
  └── 6300-002 - Fuel - XYZ456GP

6310 - Vehicle Maintenance (Control)
  ├── 6310-001 - Maintenance - ABC123GP
  └── 6310-002 - Maintenance - XYZ456GP
```

### Scenario 2: Multiple Bank Accounts
**Problem:** Track charges per bank

**Solution:**
```
1120 - Bank Account - FNB Current
1121 - Bank Account - FNB Savings
1122 - Bank Account - Nedbank

6540 - Bank Charges (Control)
  ├── 6540-001 - Bank Charges - FNB
  └── 6540-002 - Bank Charges - Nedbank
```

### Scenario 3: Multiple Locations (Utilities)
**Problem:** Track electricity per branch

**Solution:**
```
6200 - Electricity (Control)
  ├── 6200-001 - Electricity - Head Office
  ├── 6200-002 - Electricity - Branch 1
  └── 6200-003 - Electricity - Branch 2
```

---

## SQL TO CREATE COMPLETE STRUCTURE

See: `Database/Accounting/09_CREATE_COMPLETE_CHART_OF_ACCOUNTS.sql`

This script will create:
- All control accounts
- All subsidiary ledger templates
- Proper account hierarchy
- Account type classifications
- Normal balance settings

---

**STATUS:** This guide covers 95%+ of typical business scenarios. Adjust based on your specific business needs.
