# Proposed System Enhancements
**Oven Delights ERP - Feature Roadmap**

## 1. Bank Statement Auto-Mapping & Reconciliation

### Overview
Automate the matching of bank statement transactions against supplier/beneficiary payments using intelligent name matching and fuzzy logic.

### Current State
- Manual bank reconciliation process
- `CashReconciliationForm.vb` handles cash book reconciliation
- `BatchPaymentForm.vb` processes payments but no automatic statement matching
- FNB API integration exists for payment execution

### Proposed Features

#### 1.1 Bank Statement Import
- **Excel/CSV Import**: Upload bank statements in standard formats
- **Column Mapping**: Map bank columns (Date, Description, Reference, Debit, Credit, Balance)
- **Multi-Bank Support**: Templates for FNB, Standard Bank, ABSA, Nedbank, Capitec
- **Automatic Detection**: Detect bank format from file structure

#### 1.2 Intelligent Transaction Matching
- **Recipient Name Matching**: 
  - Fuzzy string matching against `AP_Beneficiaries.BeneficiaryName`
  - Levenshtein distance algorithm (threshold: 85% similarity)
  - Handle common variations (PTY LTD, (Pty) Ltd, CC, etc.)
  - Acronym matching (e.g., "OD" → "Oven Delights")
  
- **Reference Matching**:
  - Match bank reference against `AP_Invoices.InvoiceNumber`
  - Match against `FNB_PaymentBatches.InstructionID`
  - Match against custom payment references

- **Amount Matching**:
  - Exact amount match with tolerance (±R0.01 for rounding)
  - Match multiple invoices that sum to bank transaction amount
  - Handle partial payments

- **Date Range Matching**:
  - Match within ±3 business days of payment date
  - Account for bank processing delays

#### 1.3 Auto-Reconciliation Rules Engine
```vb
' Matching confidence levels:
' - 95-100%: Auto-match (green)
' - 80-94%: Suggest match (yellow) - requires user confirmation
' - Below 80%: Manual review (red)
```

#### 1.4 Reconciliation Dashboard
- **Matched Transactions**: Auto-matched with high confidence
- **Suggested Matches**: Require user confirmation
- **Unmatched Bank Transactions**: Need manual investigation
- **Unmatched Payments**: Payments not yet reflected in bank statement
- **Variance Analysis**: Identify timing differences vs actual discrepancies

#### 1.5 Implementation Approach
```sql
-- New Tables Required:
CREATE TABLE BankStatements (
    StatementID INT PRIMARY KEY IDENTITY,
    BankAccountID INT,
    StatementDate DATE,
    OpeningBalance DECIMAL(18,2),
    ClosingBalance DECIMAL(18,2),
    ImportedBy INT,
    ImportedDate DATETIME,
    IsReconciled BIT DEFAULT 0
);

CREATE TABLE BankStatementLines (
    LineID INT PRIMARY KEY IDENTITY,
    StatementID INT,
    TransactionDate DATE,
    ValueDate DATE,
    Description NVARCHAR(500),
    Reference NVARCHAR(100),
    DebitAmount DECIMAL(18,2),
    CreditAmount DECIMAL(18,2),
    Balance DECIMAL(18,2),
    IsMatched BIT DEFAULT 0,
    MatchConfidence DECIMAL(5,2),
    MatchedPaymentID INT NULL,
    MatchedInvoiceID INT NULL,
    ManuallyReviewed BIT DEFAULT 0
);

CREATE TABLE BankReconciliationRules (
    RuleID INT PRIMARY KEY IDENTITY,
    RuleName NVARCHAR(100),
    MatchType VARCHAR(50), -- 'Name', 'Reference', 'Amount', 'Combined'
    MinConfidence DECIMAL(5,2),
    IsActive BIT DEFAULT 1,
    Priority INT
);
```

---

## 2. Automated Till Reset Job

### Overview
Scheduled job to automatically reset POS tills for the next business day, ensuring clean start for daily operations.

### Current State
- Manual till reset process
- Cash reconciliation handled in `CashReconciliationForm.vb`
- No automated daily reset mechanism

### Proposed Features

#### 2.1 Daily Till Reset Automation
- **Scheduled Execution**: Run at configurable time (e.g., 2:00 AM daily)
- **Pre-Reset Validation**:
  - Check all tills are reconciled for previous day
  - Verify all transactions are closed
  - Ensure no pending sales/orders
  
- **Reset Operations**:
  - Archive previous day's till data
  - Reset till counters (transaction numbers, receipt numbers)
  - Set opening float from previous day's closing balance
  - Clear temporary/session data
  - Generate daily opening report

#### 2.2 Till Reconciliation Enforcement
- **Mandatory Reconciliation**: Block till reset if previous day not reconciled
- **Variance Alerts**: Email/SMS alerts for variances > R50
- **Manager Override**: Allow authorized users to force reset with reason

#### 2.3 Multi-Branch Support
- **Branch-Specific Timing**: Different reset times per branch/timezone
- **Centralized Monitoring**: Dashboard showing reset status across all branches
- **Failure Notifications**: Alert IT/management if reset fails

#### 2.4 Implementation Approach
```vb
' Windows Service or SQL Server Agent Job
Public Class TillResetService
    Private Sub ExecuteDailyReset()
        ' 1. Check all tills reconciled
        ' 2. Archive previous day data
        ' 3. Reset till counters
        ' 4. Set opening floats
        ' 5. Generate reports
        ' 6. Send notifications
    End Sub
End Class
```

```sql
-- Stored Procedure
CREATE PROCEDURE sp_AutomatedTillReset
    @BranchID INT,
    @ResetDate DATE,
    @ExecutedBy INT
AS BEGIN
    -- Validation checks
    -- Archive operations
    -- Reset operations
    -- Audit logging
END
```

---

## 3. Bulk Price Update with Activation/Expiry Dates

### Overview
Schedule price changes (promotions, specials, seasonal pricing) with automatic activation and expiry, eliminating manual price updates.

### Current State
- `Demo_Retail_Price` table has `EffectiveFrom` and `EffectiveTo` columns
- `StockTakeForm.vb` handles manual price updates
- No bulk scheduling or automatic activation

### Proposed Features

#### 3.1 Bulk Price Schedule Management
- **Excel Import**: Upload bulk price changes with activation dates
- **Price Templates**: Predefined templates for common scenarios:
  - Seasonal specials (Easter, Christmas, Valentine's)
  - Clearance sales (% discount on categories)
  - Volume-based pricing
  - Branch-specific pricing

#### 3.2 Price Change Types
- **Fixed Price**: Set specific price (e.g., R19.99)
- **Percentage Discount**: Reduce by % (e.g., 20% off)
- **Percentage Markup**: Increase by % (e.g., 10% increase)
- **Fixed Amount Discount**: Reduce by amount (e.g., R5 off)
- **Cost-Plus Pricing**: Set based on cost + margin %

#### 3.3 Scheduling Features
- **Activation Date/Time**: Exact date/time when price becomes active
- **Expiry Date/Time**: Automatic reversion to previous price
- **Recurring Schedules**: Weekly/monthly specials (e.g., "Friday Special")
- **Priority Levels**: Handle overlapping price schedules

#### 3.4 Approval Workflow
- **Draft Status**: Create price changes without activation
- **Approval Required**: Manager approval for price changes > threshold
- **Bulk Approval**: Approve entire schedule at once
- **Audit Trail**: Track who created, approved, activated price changes

#### 3.5 Automated Price Activation Job
- **Scheduled Check**: Run every 15 minutes to check for pending activations
- **Batch Activation**: Apply all prices scheduled for current time
- **Automatic Expiry**: Revert prices when expiry time reached
- **POS Sync**: Push price updates to all POS terminals immediately

#### 3.6 Reporting & Analytics
- **Active Promotions**: Dashboard showing current active specials
- **Upcoming Changes**: Preview scheduled price changes
- **Promotion Performance**: Sales impact analysis for promotions
- **Price History**: Complete audit trail of all price changes

#### 3.7 Implementation Approach
```sql
-- New Tables
CREATE TABLE PriceSchedules (
    ScheduleID INT PRIMARY KEY IDENTITY,
    ScheduleName NVARCHAR(200),
    Description NVARCHAR(500),
    ScheduleType VARCHAR(50), -- 'Special', 'Seasonal', 'Clearance', 'Regular'
    ActivationDate DATETIME,
    ExpiryDate DATETIME,
    IsRecurring BIT DEFAULT 0,
    RecurrencePattern NVARCHAR(100), -- 'Weekly', 'Monthly', 'Custom'
    Status VARCHAR(20), -- 'Draft', 'Pending', 'Active', 'Expired', 'Cancelled'
    CreatedBy INT,
    CreatedDate DATETIME,
    ApprovedBy INT NULL,
    ApprovedDate DATETIME NULL,
    BranchID INT NULL -- NULL = All branches
);

CREATE TABLE PriceScheduleItems (
    ItemID INT PRIMARY KEY IDENTITY,
    ScheduleID INT,
    ProductID INT,
    Category NVARCHAR(100) NULL, -- Apply to entire category
    ChangeType VARCHAR(50), -- 'FixedPrice', 'PercentDiscount', 'AmountDiscount', 'PercentMarkup'
    NewPrice DECIMAL(18,2) NULL,
    DiscountPercent DECIMAL(5,2) NULL,
    DiscountAmount DECIMAL(18,2) NULL,
    MarkupPercent DECIMAL(5,2) NULL,
    PreviousPrice DECIMAL(18,2) NULL, -- Store for reversion
    IsApplied BIT DEFAULT 0,
    AppliedDate DATETIME NULL
);

-- Activation Job Stored Procedure
CREATE PROCEDURE sp_ActivateScheduledPrices
AS BEGIN
    -- Find schedules due for activation
    -- Apply price changes to Demo_Retail_Price
    -- Update POS_Product prices
    -- Mark items as applied
    -- Send notifications
    
    -- Find expired schedules
    -- Revert to previous prices
    -- Mark schedules as expired
END
```

```vb
' Windows Service for Price Activation
Public Class PriceActivationService
    Private _timer As Timer
    
    Public Sub StartService()
        _timer = New Timer(900000) ' 15 minutes
        AddHandler _timer.Elapsed, AddressOf CheckScheduledPrices
        _timer.Start()
    End Sub
    
    Private Sub CheckScheduledPrices()
        ' Execute sp_ActivateScheduledPrices
        ' Log results
        ' Send alerts for failures
    End Sub
End Class
```

---

## 4. Manufacturing Process Improvements

### 4.1 Production Scheduling Optimization
- **Capacity Planning**: Calculate max daily production based on oven capacity, staff, ingredients
- **Order Prioritization**: Auto-prioritize orders by due date, customer type, profit margin
- **Ingredient Availability Check**: Prevent scheduling if ingredients insufficient
- **Staff Scheduling Integration**: Match production schedule with staff availability

### 4.2 Batch Production Tracking
- **Batch Numbering**: Unique batch IDs for traceability
- **Quality Control Checkpoints**: Mandatory QC checks at key stages
- **Waste Tracking**: Record wastage by batch, reason, responsible person
- **Yield Analysis**: Compare actual vs expected yield per batch

### 4.3 Real-Time Production Dashboard
- **Live Status**: Current production status per product line
- **Completion Progress**: Visual progress bars for each order
- **Bottleneck Alerts**: Highlight production delays/issues
- **Staff Performance**: Track individual/team productivity metrics

### 4.4 Automated Ingredient Deduction
- **Recipe-Based Deduction**: Auto-deduct ingredients when production marked complete
- **Variance Tracking**: Compare expected vs actual ingredient usage
- **Reorder Triggers**: Auto-generate purchase orders when stock below minimum

### 4.5 Mobile Production App
- **Tablet Interface**: Production staff mark tasks complete on shop floor
- **Barcode Scanning**: Scan batch labels, ingredient bins
- **Photo Documentation**: Attach photos for quality issues
- **Offline Mode**: Work without internet, sync when connected

---

## 5. Additional Quick Wins

### 5.1 Supplier Performance Scoring
- **Delivery Timeliness**: Track on-time delivery %
- **Quality Issues**: Record defects, returns
- **Price Competitiveness**: Compare prices across suppliers
- **Payment Terms**: Track early payment discounts taken

### 5.2 Customer Order Portal
- **Online Ordering**: Customers place custom cake orders online
- **Real-Time Pricing**: Calculate price based on specifications
- **Availability Check**: Show available pickup dates
- **Order Tracking**: Customers track order status

### 5.3 Inventory Optimization
- **ABC Analysis**: Classify products by value/turnover
- **Reorder Point Calculation**: Dynamic reorder points based on lead time, demand variability
- **Expiry Management**: FEFO (First Expire First Out) alerts
- **Dead Stock Identification**: Flag slow-moving items for clearance

### 5.4 Financial Automation
- **Auto-Invoice Matching**: Match supplier invoices to purchase orders
- **Payment Terms Optimization**: Alert for early payment discounts
- **Cash Flow Forecasting**: Predict cash position based on receivables/payables
- **Expense Categorization**: AI-based expense classification

---

## Implementation Priority

### Phase 1 (Immediate - 1-2 months)
1. **Bulk Price Update with Scheduling** - High business impact, moderate complexity
2. **Automated Till Reset Job** - Reduces daily manual work, low complexity

### Phase 2 (Short-term - 2-4 months)
3. **Bank Statement Auto-Mapping** - High value, moderate complexity
4. **Production Dashboard Enhancements** - Improves manufacturing visibility

### Phase 3 (Medium-term - 4-6 months)
5. **Mobile Production App** - Requires mobile development expertise
6. **Customer Order Portal** - Requires web development, customer-facing

### Phase 4 (Long-term - 6-12 months)
7. **Advanced Analytics & AI** - Predictive analytics, demand forecasting
8. **Full ERP Integration** - Connect all modules seamlessly

---

## Technical Requirements

### Infrastructure
- **Windows Service Host**: For scheduled jobs (till reset, price activation)
- **SQL Server Agent**: Alternative for scheduled jobs
- **Web Server**: For customer portal (IIS/Apache)
- **Mobile Framework**: Xamarin or React Native for production app

### Development Tools
- **Fuzzy String Matching**: Levenshtein distance library (FuzzyString.NET)
- **Excel Processing**: ClosedXML (already in use)
- **Job Scheduling**: Quartz.NET or Hangfire
- **Notification Service**: SMTP for email, SMS gateway integration

### Database Changes
- New tables for bank reconciliation, price schedules, production tracking
- Indexes for performance on matching queries
- Stored procedures for batch operations
- Audit tables for compliance

---

## Success Metrics

### Bank Auto-Mapping
- **Time Savings**: Reduce reconciliation time from 2 hours to 15 minutes
- **Accuracy**: 95%+ auto-match rate
- **Error Reduction**: 90% reduction in manual matching errors

### Automated Till Reset
- **Time Savings**: Eliminate 30 minutes daily manual work per branch
- **Consistency**: 100% on-time resets
- **Error Reduction**: Zero missed resets

### Bulk Price Updates
- **Time Savings**: Reduce price update time from 4 hours to 10 minutes
- **Accuracy**: 100% accurate activation/expiry
- **Revenue Impact**: Enable more frequent promotions, increase sales 10-15%

### Manufacturing Improvements
- **Efficiency**: 20% increase in production throughput
- **Waste Reduction**: 15% reduction in ingredient wastage
- **On-Time Delivery**: 95%+ orders completed by due date

---

**Document Version**: 1.0  
**Created**: 2026-02-04  
**Author**: Cascade AI Assistant  
**Status**: Proposal - Awaiting Review
