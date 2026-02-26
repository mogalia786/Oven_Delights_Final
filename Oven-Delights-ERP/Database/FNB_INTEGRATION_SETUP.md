# FNB BANKING INTEGRATION SETUP GUIDE

## Overview
The Bank Reconciliation System supports **TWO OPTIONS** for importing bank statements:

### ✅ OPTION 1: FNB API Integration (Automatic)
- Real-time statement downloads
- Automated transaction imports
- Full payload/response logging

### ✅ OPTION 2: CSV Import (Manual)
- Upload bank statement CSV files
- No API credentials required
- Same reconciliation features

---

## OPTION 1: FNB API SETUP

### Step 1: Register for FNB Business API Access
1. Visit FNB Business Banking Portal
2. Navigate to API Services
3. Register your application
4. Obtain credentials:
   - API Key
   - Client ID
   - Client Secret
   - Account ID

### Step 2: Configure App.config
Open `App.config` and update the FNB settings:

```xml
<!-- FNB Banking API Configuration -->
<add key="FNB_API_BaseUrl" value="https://api.fnb.co.za/v1" />
<add key="FNB_API_Key" value="YOUR_ACTUAL_API_KEY" />
<add key="FNB_ClientId" value="YOUR_ACTUAL_CLIENT_ID" />
<add key="FNB_ClientSecret" value="YOUR_ACTUAL_CLIENT_SECRET" />
```

### Step 3: Link Bank Accounts
1. Open **Bank Reconciliation Dashboard**
2. For each bank account, ensure `FNBAccountID` is populated
3. This links your ERP bank account to FNB's account identifier

### Step 4: Test API Connection
1. Select a bank account
2. Set date range (last 7 days recommended for testing)
3. Click **📥 Download FNB**
4. Check **FNB API STATUS LOG** (black panel at bottom)
   - Green text shows payload sent
   - Green text shows response received
   - Errors displayed in red

---

## OPTION 2: CSV IMPORT SETUP

### Step 1: Download Statement from FNB
1. Log into FNB Business Banking
2. Navigate to Statements
3. Select account and date range
4. Download as **CSV format**

### Step 2: Import CSV File
1. Open **Bank Reconciliation Dashboard**
2. Select the bank account
3. Click **📂 Import CSV**
4. Browse to downloaded CSV file
5. Click Open

### Step 3: Verify Import
- Check **FNB API STATUS LOG** for import details
- Review imported transactions in grid
- Statistics panel shows transaction counts

---

## STATUS LOG FEATURES

### Visual Display
- **Black background** with **green text** (matrix style)
- Real-time logging of all operations
- Timestamp on every entry

### Information Logged

#### FNB API Downloads:
```
[09:15:23] ========================================
[09:15:23] FNB STATEMENT DOWNLOAD INITIATED
[09:15:23] >>> REQUEST PAYLOAD
[09:15:23] BankAccountID: 1, StartDate: 2026-02-01, EndDate: 2026-02-24
[09:15:23] 
[09:15:25] <<< RESPONSE
[09:15:25] SUCCESS: Downloaded 47 transactions
[09:15:25] ========================================
```

#### CSV Imports:
```
[09:20:15] ========================================
[09:20:15] CSV IMPORT INITIATED
[09:20:15] >>> IMPORT DETAILS
[09:20:15] BankAccountID: 1, File: FNB_Statement_Feb2026.csv
[09:20:15] 
[09:20:16] <<< RESPONSE
[09:20:16] SUCCESS: Imported 47 transactions from CSV
[09:20:16] ========================================
```

#### Errors:
```
[09:25:30] ========================================
[09:25:30] FNB STATEMENT DOWNLOAD INITIATED
[09:25:30] >>> REQUEST PAYLOAD
[09:25:30] BankAccountID: 1, StartDate: 2026-02-01, EndDate: 2026-02-24
[09:25:30] 
[09:25:31] <<< ERROR
[09:25:31] FAILED: Invalid API credentials
[09:25:31] ========================================
```

---

## CSV FILE FORMAT

The system expects FNB CSV files with these columns:

```csv
TransactionDate,Description,DebitAmount,CreditAmount,Balance,Reference
2026-02-01,"PAYMENT TO SUPPLIER ABC",5000.00,0.00,45000.00,"SUP-2026-000123"
2026-02-02,"DEPOSIT",0.00,10000.00,55000.00,"DEP-001"
2026-02-03,"PAYMENT TO LANDLORD",3000.00,0.00,52000.00,"BEN-2026-000045"
```

**Required Columns:**
- `TransactionDate` - Format: YYYY-MM-DD or DD/MM/YYYY
- `Description` - Transaction description
- `DebitAmount` - Money out (0.00 if credit)
- `CreditAmount` - Money in (0.00 if debit)
- `Balance` - Running balance
- `Reference` - Payment reference (optional but recommended)

---

## TROUBLESHOOTING

### FNB API Issues

**Problem:** "Invalid API credentials"
- **Solution:** Verify API Key, Client ID, and Client Secret in App.config
- Check if credentials have expired
- Ensure API access is enabled for your FNB account

**Problem:** "Account not found"
- **Solution:** Ensure `FNBAccountID` is set in BankAccounts table
- Verify the FNB Account ID matches your actual account

**Problem:** "No transactions returned"
- **Solution:** Check date range
- Verify account has transactions in that period
- Check FNB API status (may be down for maintenance)

### CSV Import Issues

**Problem:** "Error importing CSV"
- **Solution:** Verify CSV format matches expected structure
- Check for special characters in description
- Ensure dates are in correct format

**Problem:** "Duplicate transactions"
- **Solution:** System automatically prevents duplicates
- Check if transactions were already imported
- Review by date and amount

---

## SECURITY BEST PRACTICES

### API Credentials
1. **Never commit** App.config with real credentials to source control
2. Use **environment variables** or **Azure Key Vault** for production
3. Rotate credentials regularly
4. Limit API permissions to read-only where possible

### CSV Files
1. Store downloaded statements securely
2. Delete CSV files after import
3. Use encrypted folders for sensitive data

---

## NEXT STEPS AFTER IMPORT

1. **Auto-Match Transactions**
   - Click **🔗 Auto-Match** button
   - System matches to supplier invoices and beneficiary payments

2. **Review Unmatched**
   - Check transactions highlighted in red
   - Manually match if needed

3. **Post to General Ledger**
   - Click **💰 Post to GL** button
   - Verify debits = credits
   - Check Financial Dashboard for updated balances

---

## SUPPORT

For FNB API issues:
- Contact FNB Business Banking API Support
- Phone: 087 575 9404
- Email: api.support@fnb.co.za

For ERP System issues:
- Check STATUS LOG for detailed error messages
- Review transaction grid for import results
- Verify database connectivity

---

**✅ SYSTEM READY FOR BOTH FNB API AND CSV IMPORTS**
