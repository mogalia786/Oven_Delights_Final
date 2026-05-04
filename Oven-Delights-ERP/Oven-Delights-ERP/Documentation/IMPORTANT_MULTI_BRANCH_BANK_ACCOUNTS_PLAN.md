# ⚠️ IMPORTANT: MULTI-BRANCH BANK ACCOUNTS IMPLEMENTATION PLAN

**Status:** APPROVED - READY FOR IMPLEMENTATION  
**Priority:** HIGH  
**Date Created:** April 13, 2026  
**Business Context:** Company currently uses 1 bank account, but will use separate bank accounts per branch in the future.

---

## 📋 EXECUTIVE SUMMARY

**Problem:** The current system uses a single hardcoded bank account (1010) for all branches. Different branches will have different bank accounts in the future.

**Solution:** Add bank account fields to the Branches table and update all GL posting procedures to use branch-specific bank accounts based on BranchID.

**Impact:** All accounting modules (POS, Bank Statements, Payments, Receipts) will post to the correct branch-specific bank account.

---

## 🎯 BUSINESS REQUIREMENTS

1. ✅ Each branch must have its own bank account details
2. ✅ All GL postings must use the correct branch bank account
3. ✅ Bank statement processing must filter by branch
4. ✅ Backward compatibility - existing data remains unchanged
5. ✅ Default all branches to current bank details initially
6. ✅ Admin can manage bank details per branch

---

## 📊 PHASE 1: DATABASE SCHEMA CHANGES

### 1.1 Add Bank Fields to Branches Table

**Script:** `ADD_BRANCH_BANK_ACCOUNTS.sql`

```sql
-- Add bank account fields to Branches table
ALTER TABLE Branches ADD 
    BankName NVARCHAR(200) NULL,
    BankAccountNumber NVARCHAR(50) NULL,
    BankAccountName NVARCHAR(200) NULL,
    BankBranchCode NVARCHAR(20) NULL,
    BankAccountType NVARCHAR(50) NULL, -- 'Current', 'Savings'
    BankGLAccountID INT NULL, -- FK to ChartOfAccounts
    BankStatementEmail NVARCHAR(200) NULL,
    BankIsActive BIT DEFAULT 1
GO

-- Add foreign key constraint
ALTER TABLE Branches ADD 
    CONSTRAINT FK_Branch_BankGLAccount 
    FOREIGN KEY (BankGLAccountID) REFERENCES ChartOfAccounts(AccountID)
GO

-- Create index for performance
CREATE INDEX IX_Branch_BankAccount ON Branches(BankGLAccountID, IsActive)
GO
```

### 1.2 Create Branch Bank Account View

```sql
CREATE VIEW vw_BranchBankAccounts AS
SELECT 
    b.BranchID,
    b.BranchCode,
    b.BranchName,
    b.BankName,
    b.BankAccountNumber,
    b.BankAccountName,
    b.BankBranchCode,
    b.BankAccountType,
    b.BankStatementEmail,
    coa.AccountID AS BankGLAccountID,
    coa.AccountCode AS BankGLAccountCode,
    coa.AccountName AS BankGLAccountName,
    b.BankIsActive
FROM Branches b
LEFT JOIN ChartOfAccounts coa ON b.BankGLAccountID = coa.AccountID
WHERE b.IsActive = 1
GO
```

### 1.3 Data Migration - Default All Branches

```sql
-- Get the current bank account (1010)
DECLARE @BankAccountID INT
SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1

-- Update all branches with default bank details
UPDATE Branches
SET 
    BankName = 'First National Bank', -- Update with actual bank name
    BankAccountNumber = '[CURRENT_ACCOUNT_NUMBER]', -- Update with actual number
    BankAccountName = 'Oven Delights',
    BankBranchCode = '[CURRENT_BRANCH_CODE]', -- Update with actual code
    BankAccountType = 'Current',
    BankGLAccountID = @BankAccountID,
    BankStatementEmail = 'accounts@ovendelights.co.za', -- Update with actual email
    BankIsActive = 1
WHERE IsActive = 1
GO

PRINT '✓ All branches defaulted to current bank account details'
```

**Estimated Time:** 30 minutes

---

## 🖥️ PHASE 2: ADMIN - BRANCH SETUP FORM

### 2.1 Update Branch Setup Form

**File:** `Forms\Administration\BranchSetupForm.vb`

**New Section: "Bank Account Details"**

**Fields to Add:**
- **Bank Name** (TextBox) - e.g., "First National Bank"
- **Account Number** (TextBox) - e.g., "62012345678"
- **Account Name** (TextBox) - e.g., "Oven Delights - Sandton Branch"
- **Branch Code** (TextBox) - e.g., "250655"
- **Account Type** (ComboBox) - Options: "Current", "Savings", "Transmission"
- **GL Account** (ComboBox) - Load from ChartOfAccounts WHERE AccountCode LIKE '1%' AND AccountType = 'Bank'
- **Statement Email** (TextBox) - e.g., "sandton@ovendelights.co.za"
- **Active** (CheckBox) - Enable/disable bank account

**Layout:**
```
┌─────────────────────────────────────────────────┐
│  Bank Account Details                           │
├─────────────────────────────────────────────────┤
│  Bank Name:         [First National Bank     ]  │
│  Account Number:    [62012345678             ]  │
│  Account Name:      [Oven Delights - Sandton]  │
│  Branch Code:       [250655                  ]  │
│  Account Type:      [Current            ▼]     │
│  GL Account:        [1010 - Bank        ▼]     │
│  Statement Email:   [sandton@ovendelights.co.za]│
│  Active:            [✓]                         │
└─────────────────────────────────────────────────┘
```

**Save Logic:**
```vb
' Save bank account details
UPDATE Branches
SET 
    BankName = @BankName,
    BankAccountNumber = @AccountNumber,
    BankAccountName = @AccountName,
    BankBranchCode = @BranchCode,
    BankAccountType = @AccountType,
    BankGLAccountID = @GLAccountID,
    BankStatementEmail = @Email,
    BankIsActive = @IsActive
WHERE BranchID = @BranchID
```

**Estimated Time:** 1 hour

---

## 🔧 PHASE 3: UPDATE GL POSTING PROCEDURES

### 3.1 Current vs New Approach

**CURRENT (Hardcoded):**
```sql
SELECT @BankAccountID = AccountID 
FROM ChartOfAccounts 
WHERE AccountCode = '1010' AND IsActive = 1
```

**NEW (Branch-Specific):**
```sql
SELECT @BankAccountID = BankGLAccountID 
FROM Branches 
WHERE BranchID = @BranchID AND IsActive = 1 AND BankIsActive = 1

-- Fallback to default if branch bank not configured
IF @BankAccountID IS NULL
BEGIN
    SELECT @BankAccountID = AccountID 
    FROM ChartOfAccounts 
    WHERE AccountCode = '1010' AND IsActive = 1
END
```

### 3.2 Procedures to Update

#### **3.2.1 sp_POS_PostCashDepositToGL**

**File:** `Database\GL\10_POS_GL_COMPLETE_INTEGRATION.sql`

**Changes:**
- Add `@BranchID INT` parameter (if not already present)
- Replace hardcoded 1010 lookup with branch-specific lookup
- Add fallback to default bank account

**Current:**
```sql
SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010'
```

**New:**
```sql
-- Get branch-specific bank account
SELECT @BankAccountID = BankGLAccountID 
FROM Branches 
WHERE BranchID = @BranchID AND IsActive = 1 AND BankIsActive = 1

-- Fallback to default
IF @BankAccountID IS NULL
    SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010'
```

#### **3.2.2 sp_BankStatement_CompletePayment**

**File:** `Database\GL\UPDATE_BANK_POSTING_PROCEDURES_FINAL.sql`

**Changes:**
- Already has `@BranchID` from AP_StatementTransactions
- Replace hardcoded 1010 lookup with branch-specific lookup

**Current:**
```sql
SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010'
```

**New:**
```sql
-- Get branch-specific bank account
SELECT @BankAccountID = BankGLAccountID 
FROM Branches 
WHERE BranchID = @BranchID AND IsActive = 1 AND BankIsActive = 1

-- Fallback to default
IF @BankAccountID IS NULL
    SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010'
```

#### **3.2.3 sp_BankStatement_CompleteReceipt**

**File:** `Database\GL\UPDATE_BANK_POSTING_PROCEDURES_FINAL.sql`

**Changes:** Same as sp_BankStatement_CompletePayment

#### **3.2.4 sp_AR_PostCustomerPayment** (if exists)

**Changes:**
- Add `@BranchID INT` parameter
- Use branch-specific bank account

#### **3.2.5 sp_AP_PostSupplierPayment** (if exists)

**Changes:**
- Add `@BranchID INT` parameter
- Use branch-specific bank account

**Estimated Time:** 2 hours

---

## 🏦 PHASE 4: BANK STATEMENT PROCESSING

### 4.1 Update AP_StatementTransactions Table

```sql
-- Add BranchID if not exists
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'BranchID')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD BranchID INT NULL
    
    -- Add foreign key
    ALTER TABLE AP_StatementTransactions ADD 
        CONSTRAINT FK_StatementTrans_Branch 
        FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    
    -- Create index
    CREATE INDEX IX_StatementTrans_Branch ON AP_StatementTransactions(BranchID, TransactionDate)
    
    PRINT '✓ Added BranchID to AP_StatementTransactions'
END
GO
```

### 4.2 Update Bank Statement Import Form

**File:** `Forms\Accounting\BankStatementImportForm.vb` (or similar)

**Changes:**
1. Add branch selection dropdown at top of form
2. Filter imported transactions by branch bank account number
3. Populate `BranchID` in `AP_StatementTransactions` on import

**UI Addition:**
```
┌─────────────────────────────────────────────────┐
│  Select Branch:  [Sandton - OD100      ▼]      │
│  Bank Account:   [FNB - 62012345678]           │
└─────────────────────────────────────────────────┘
```

### 4.3 Update Bank Reconciliation Dashboard

**File:** `Forms\Accounting\BankReconciliationDashboard.vb`

**Changes:**
1. Add branch filter dropdown
2. Filter transactions by selected branch
3. Display branch-specific bank balance
4. Show branch bank account details

**Estimated Time:** 1 hour

---

## 📊 PHASE 5: REPORTING UPDATES

### 5.1 Reports to Update

| Report | Change Required |
|--------|----------------|
| **Bank Reconciliation Report** | Add branch filter, show branch bank details |
| **Cash Flow Report** | Filter by branch, show branch-specific cash flows |
| **Financial Dashboard** | Display branch-specific bank balances |
| **General Ledger Report** | Filter by branch when viewing bank account |
| **Bank Statement Report** | Filter by branch |

### 5.2 LedgerHierarchyForm Update

**File:** `Forms\Accounting\LedgerHierarchyForm.vb`

**Change:** When drilling into Bank account (1010), show branch breakdown

```sql
-- When user clicks on Bank account, show branch detail
SELECT 
    b.BranchCode,
    b.BranchName,
    b.BankAccountNumber,
    SUM(CASE WHEN gl.BranchID = b.BranchID THEN gl.DebitAmount ELSE 0 END) AS Debits,
    SUM(CASE WHEN gl.BranchID = b.BranchID THEN gl.CreditAmount ELSE 0 END) AS Credits,
    SUM(CASE WHEN gl.BranchID = b.BranchID THEN gl.DebitAmount - gl.CreditAmount ELSE 0 END) AS Balance
FROM Branches b
LEFT JOIN GeneralLedger gl ON gl.BranchID = b.BranchID AND gl.AccountID = @BankAccountID
WHERE b.IsActive = 1
GROUP BY b.BranchCode, b.BranchName, b.BankAccountNumber
ORDER BY b.BranchCode
```

**Estimated Time:** 1 hour

---

## 🎨 PHASE 6: CHART OF ACCOUNTS STRATEGY

### Option A: Single Bank Account (1010) - ✅ RECOMMENDED

**Approach:**
- Keep single GL account 1010 "Bank"
- All branches post to same account
- Use BranchID in GeneralLedger and AP_StatementTransactions to track branch-specific transactions
- Branch breakdown available via reporting

**Pros:**
- ✅ Simpler to implement
- ✅ Consolidated bank balance view
- ✅ Easier reconciliation
- ✅ No chart of accounts changes needed

**Cons:**
- ❌ Can't see branch bank balances directly in GL (need to drill down)

### Option B: Multiple Bank Accounts (1010, 1011, 1012...)

**Approach:**
- Create separate GL accounts per branch
  - 1010 - Bank - Sandton (OD100)
  - 1011 - Bank - Rosebank (OD101)
  - 1012 - Bank - Fourways (OD102)
- Each branch posts to its own GL account
- Branches.BankGLAccountID points to branch-specific account

**Pros:**
- ✅ Branch bank balances visible directly in GL
- ✅ Clearer separation

**Cons:**
- ❌ More complex to implement
- ❌ More accounts to manage
- ❌ Requires chart of accounts restructuring
- ❌ Harder to get consolidated bank balance

**DECISION: Use Option A (Single Account with BranchID tracking)**

---

## 🔄 IMPLEMENTATION SEQUENCE

### Step 1: Database Schema (30 min) ✅
- [ ] Run `ADD_BRANCH_BANK_ACCOUNTS.sql`
- [ ] Verify Branches table has new bank fields
- [ ] Verify all branches have default bank details
- [ ] Test view `vw_BranchBankAccounts`

### Step 2: Admin Form (1 hour) ✅
- [ ] Update Branch Setup form with bank fields
- [ ] Add validation (account number format, etc.)
- [ ] Test save/load functionality
- [ ] Test with multiple branches

### Step 3: GL Procedures (2 hours) ✅
- [ ] Update `sp_POS_PostCashDepositToGL`
- [ ] Update `sp_BankStatement_CompletePayment`
- [ ] Update `sp_BankStatement_CompleteReceipt`
- [ ] Update any other payment/receipt procedures
- [ ] Test each procedure with different BranchIDs

### Step 4: Bank Statement Processing (1 hour) ✅
- [ ] Add BranchID to AP_StatementTransactions
- [ ] Update import form with branch selection
- [ ] Update reconciliation dashboard
- [ ] Test import with branch-specific data

### Step 5: Reporting (1 hour) ✅
- [ ] Update LedgerHierarchyForm for branch drill-down
- [ ] Update other reports as needed
- [ ] Test branch filtering

### Step 6: End-to-End Testing (1 hour) ✅
- [ ] Test cash deposit from POS (branch-specific)
- [ ] Test bank statement import (branch-specific)
- [ ] Test supplier payment (branch-specific)
- [ ] Test customer receipt (branch-specific)
- [ ] Verify GL postings use correct branch bank account
- [ ] Verify balances reconcile

**Total Estimated Time: 6.5 hours**

---

## ⚠️ CRITICAL CONSIDERATIONS

### Backward Compatibility
- ✅ All existing transactions remain unchanged
- ✅ Existing procedures work with fallback to default bank account
- ✅ No data loss
- ✅ Gradual migration - branches can be configured one at a time

### Data Validation
- ✅ Bank account number format validation
- ✅ Ensure BankGLAccountID points to valid bank account
- ✅ Prevent deletion of bank account if transactions exist
- ✅ Warn if branch has no bank account configured

### Security
- ✅ Only admin users can modify bank account details
- ✅ Audit log for bank account changes
- ✅ Require confirmation before changing bank account

### Performance
- ✅ Indexes on BranchID in transaction tables
- ✅ View for quick branch bank account lookup
- ✅ Cached bank account lookups in procedures

---

## 📝 TESTING CHECKLIST

### Unit Tests
- [ ] Branch bank account CRUD operations
- [ ] GL procedures with valid BranchID
- [ ] GL procedures with invalid BranchID (fallback)
- [ ] GL procedures with NULL BranchID (fallback)

### Integration Tests
- [ ] POS cash deposit → GL posting (branch-specific)
- [ ] Bank statement import → GL posting (branch-specific)
- [ ] Supplier payment → GL posting (branch-specific)
- [ ] Customer receipt → GL posting (branch-specific)

### Regression Tests
- [ ] Existing transactions still display correctly
- [ ] Reports still work with existing data
- [ ] No performance degradation

### User Acceptance Tests
- [ ] Admin can configure branch bank accounts
- [ ] Transactions post to correct branch bank account
- [ ] Reports show correct branch-specific data
- [ ] Bank reconciliation works per branch

---

## 🚀 DEPLOYMENT PLAN

### Pre-Deployment
1. Backup database
2. Test all scripts in staging environment
3. Document current bank account details
4. Prepare rollback plan

### Deployment Steps
1. Run database schema changes (5 min)
2. Deploy updated application (10 min)
3. Verify all branches have default bank details (5 min)
4. Test one transaction per module (15 min)
5. Monitor for errors (30 min)

### Post-Deployment
1. Train admin users on bank account configuration
2. Configure branch-specific bank accounts as needed
3. Monitor GL postings for correctness
4. Update documentation

### Rollback Plan
If issues occur:
1. Revert application to previous version
2. Database changes are backward compatible (no rollback needed)
3. Existing functionality continues to work

---

## 📞 SUPPORT & MAINTENANCE

### Known Limitations
- Branch bank account changes don't affect historical transactions
- Bank reconciliation must be done per branch
- Consolidated bank balance requires report or query

### Future Enhancements
- Multi-currency support per branch bank account
- Bank account hierarchy (main account + sub-accounts)
- Automated bank statement import via API
- Bank account balance synchronization

---

## ✅ APPROVAL & SIGN-OFF

**Approved By:** [User Name]  
**Date:** April 13, 2026  
**Status:** READY FOR IMPLEMENTATION

**Key Decisions:**
- ✅ Use single GL account (1010) with BranchID tracking
- ✅ Default all branches to current bank details
- ✅ Implement fallback to default bank account
- ✅ Add bank account management to Branch Setup form

---

## 📚 RELATED DOCUMENTS

- `FIX_ALL_AP_PROCEDURES.sql` - AP account fixes (2100)
- `CREATE_BANK_TRANSACTION_MAPPING_FIXED.sql` - Bank transaction mapping
- `UPDATE_BANK_POSTING_PROCEDURES_FINAL.sql` - Bank posting procedures
- `COMPREHENSIVE_AP_ACCOUNT_FIX.sql` - AP diagnostic script

---

**END OF PLAN**
