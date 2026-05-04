-- =============================================
-- BANK STATEMENT TRANSACTION MAPPING SYSTEM (FIXED)
-- =============================================
-- Corrected table and column names for actual database schema
-- =============================================

-- Drop existing table if exists
IF OBJECT_ID('BankTransactionMappingRules', 'U') IS NOT NULL
    DROP TABLE BankTransactionMappingRules
GO

-- Create mapping rules table
CREATE TABLE BankTransactionMappingRules (
    RuleID INT IDENTITY(1,1) PRIMARY KEY,
    RuleName NVARCHAR(100) NOT NULL,
    MatchType NVARCHAR(20) NOT NULL, -- 'Prefix', 'Contains', 'Exact', 'Suffix'
    MatchValue NVARCHAR(100) NOT NULL, -- The text to match (e.g., 'INV-', 'TD TO', 'DEPOSIT')
    TransactionType NVARCHAR(20) NOT NULL, -- 'Payment', 'Receipt', 'Transfer', 'Fee'
    TargetLedger NVARCHAR(50) NOT NULL, -- 'AccountsPayable', 'AccountsReceivable', 'BankFees', 'InterBranch', etc.
    AccountCode NVARCHAR(20) NULL, -- GL Account code (e.g., '2030' for AP, '1200' for AR)
    SupplierID INT NULL, -- If specific supplier, link here
    ExtractEntityFromDescription BIT DEFAULT 0, -- If 1, extract supplier/customer name from description
    EntityExtractionPattern NVARCHAR(200) NULL, -- Regex or pattern to extract entity name
    Priority INT DEFAULT 100, -- Lower number = higher priority (checked first)
    IsActive BIT DEFAULT 1,
    CreatedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedBy NVARCHAR(100) NULL,
    ModifiedDate DATETIME NULL,
    Notes NVARCHAR(500) NULL,
    CONSTRAINT FK_MappingRule_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
)
GO

-- Create index for fast lookups
CREATE INDEX IX_BankTransactionMapping_MatchValue ON BankTransactionMappingRules(MatchValue, IsActive, Priority)
GO

-- =============================================
-- INSERT DEFAULT MAPPING RULES
-- =============================================

PRINT 'Inserting default bank transaction mapping rules...'

-- Supplier invoice payments (highest priority)
INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, Priority, IsActive)
VALUES 
    ('Supplier Invoice - INV Prefix', 'Prefix', 'INV-', 'Payment', 'AccountsPayable', '2100', 10, 1),
    ('Supplier Payment - FNB OB PMT', 'Contains', 'FNB OB PMT', 'Payment', 'AccountsPayable', '2100', 20, 1)

-- Rule 2: TP- prefix = Supplier Payment (Accounts Payable)
INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, ExtractEntityFromDescription, Priority, Notes)
VALUES ('Supplier Payment - TP Prefix', 'Prefix', 'TP-', 'Payment', 'AccountsPayable', '2100', 1, 10, 'Matches payments with TP- prefix')

-- Rule 3: TD TO = Transfer/Payment to Supplier (Accounts Payable)
INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, ExtractEntityFromDescription, Priority, Notes)
VALUES ('Supplier Payment - TD TO', 'Prefix', 'TD TO', 'Payment', 'AccountsPayable', '2100', 1, 20, 'Matches "TD TO [Supplier Name]" payments, extracts supplier name')

-- Rule 4: DEPOSIT = Customer Receipt (Accounts Receivable)
INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, ExtractEntityFromDescription, Priority, Notes)
VALUES ('Customer Deposit - DEPOSIT', 'Contains', 'DEPOSIT', 'Receipt', 'AccountsReceivable', '1200', 1, 30, 'Matches deposits from customers')

-- Rule 5: OD- prefix = Inter-branch transfer
INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, Priority, Notes)
VALUES ('Inter-Branch Transfer - OD Prefix', 'Prefix', 'OD-', 'Transfer', 'InterBranch', '1600', 40, 'Inter-branch transfers between Oven Delights branches')

-- Rule 6: FNB OB COLL = Credit Card Collections (already working)
INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, Priority, Notes)
VALUES ('Credit Card Collection', 'Contains', 'FNB OB COLL', 'Receipt', 'Bank', '1010', 50, 'Credit card collections from POS')

-- Rule 7: FNB OB TRF = Bank Transfer
INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, Priority, Notes)
VALUES ('Bank Transfer - TRF', 'Contains', 'FNB OB TRF', 'Transfer', 'Bank', '1010', 60, 'Bank transfers')

-- Rule 8: FNB OB PMT = Payment (generic)
INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, ExtractEntityFromDescription, Priority, Notes)
VALUES ('Generic Payment - PMT', 'Contains', 'FNB OB PMT', 'Payment', 'AccountsPayable', '2100', 1, 70, 'Generic payments, extract beneficiary from description')

PRINT '✓ Default mapping rules created'
PRINT ''

-- =============================================
-- CREATE ENTITY PREFIX LOOKUP TABLE
-- =============================================

IF OBJECT_ID('BankTransactionEntityPrefixes', 'U') IS NOT NULL
    DROP TABLE BankTransactionEntityPrefixes
GO

CREATE TABLE BankTransactionEntityPrefixes (
    PrefixID INT IDENTITY(1,1) PRIMARY KEY,
    Prefix NVARCHAR(50) NOT NULL, -- e.g., 'TP-1234', 'TD TO TSHEPO'
    EntityType NVARCHAR(20) NOT NULL, -- 'Supplier' or 'Customer'
    SupplierID INT NULL,
    CustomerID INT NULL,
    EntityName NVARCHAR(200) NOT NULL, -- Denormalized for display
    IsActive BIT DEFAULT 1,
    CreatedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_EntityPrefix_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT CK_EntityPrefix_Type CHECK (EntityType IN ('Supplier', 'Customer')),
    CONSTRAINT CK_EntityPrefix_ID CHECK (
        (EntityType = 'Supplier' AND SupplierID IS NOT NULL AND CustomerID IS NULL) OR
        (EntityType = 'Customer' AND CustomerID IS NOT NULL AND SupplierID IS NULL)
    )
)
GO

CREATE INDEX IX_EntityPrefix_Lookup ON BankTransactionEntityPrefixes(Prefix, IsActive)
GO

PRINT 'Entity prefix lookup table created'
PRINT ''

-- =============================================
-- ADD COLUMNS TO AP_StatementTransactions
-- =============================================

-- Add SupplierID column if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'SupplierID')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD SupplierID INT NULL
    PRINT '✓ Added SupplierID column to AP_StatementTransactions'
END
ELSE
    PRINT '✓ SupplierID column already exists in AP_StatementTransactions'

-- Add MappingType column if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'MappingType')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD MappingType NVARCHAR(20) NULL
    PRINT '✓ Added MappingType column to AP_StatementTransactions'
END
ELSE
    PRINT '✓ MappingType column already exists in AP_StatementTransactions'

-- Add AccountCode column if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'AccountCode')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD AccountCode NVARCHAR(20) NULL
    PRINT '✓ Added AccountCode column to AP_StatementTransactions'
END
ELSE
    PRINT '✓ AccountCode column already exists in AP_StatementTransactions'

-- Add IsMapped column if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'IsMapped')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD IsMapped BIT DEFAULT 0
    PRINT '✓ Added IsMapped column to AP_StatementTransactions'
END
ELSE
    PRINT '✓ IsMapped column already exists in AP_StatementTransactions'

-- Add MappedDate column if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'MappedDate')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD MappedDate DATETIME NULL
    PRINT '✓ Added MappedDate column to AP_StatementTransactions'
END
ELSE
    PRINT '✓ MappedDate column already exists in AP_StatementTransactions'

PRINT ''

-- =============================================
-- SAMPLE SUPPLIER PREFIX MAPPINGS
-- =============================================

PRINT 'Sample supplier prefix mappings (user can add more via UI):'
PRINT '  - Add "TP-1234" → Supplier XYZ'
PRINT '  - Add "TD TO TSHEPO" → Supplier Tshepo'
PRINT ''

-- =============================================
-- CREATE STORED PROCEDURE: Auto-Map Transaction
-- =============================================

IF OBJECT_ID('sp_BankStatement_AutoMapWithRules', 'P') IS NOT NULL
    DROP PROCEDURE sp_BankStatement_AutoMapWithRules
GO

CREATE PROCEDURE sp_BankStatement_AutoMapWithRules
    @TransactionID INT
AS
BEGIN
    SET NOCOUNT ON
    
    DECLARE @Description NVARCHAR(500)
    DECLARE @Amount DECIMAL(18,2)
    DECLARE @CreditDebit NVARCHAR(10)
    DECLARE @MatchedRuleID INT
    DECLARE @TargetLedger NVARCHAR(50)
    DECLARE @AccountCode NVARCHAR(20)
    DECLARE @SupplierID INT
    DECLARE @TransactionType NVARCHAR(20)
    
    -- Get transaction details from AP_StatementTransactions
    SELECT 
        @Description = Description,
        @Amount = Amount,
        @CreditDebit = CreditDebitIndicator
    FROM AP_StatementTransactions
    WHERE TransactionID = @TransactionID
    
    -- Find matching rule (highest priority first)
    SELECT TOP 1
        @MatchedRuleID = RuleID,
        @TargetLedger = TargetLedger,
        @AccountCode = AccountCode,
        @SupplierID = SupplierID,
        @TransactionType = TransactionType
    FROM BankTransactionMappingRules
    WHERE IsActive = 1
        AND (
            (MatchType = 'Prefix' AND @Description LIKE MatchValue + '%')
            OR (MatchType = 'Contains' AND @Description LIKE '%' + MatchValue + '%')
            OR (MatchType = 'Exact' AND @Description = MatchValue)
            OR (MatchType = 'Suffix' AND @Description LIKE '%' + MatchValue)
        )
    ORDER BY Priority ASC, RuleID ASC
    
    -- If no rule matched, return
    IF @MatchedRuleID IS NULL
    BEGIN
        PRINT 'No matching rule found for: ' + @Description
        RETURN
    END
    
    -- Check supplier prefix lookup for specific supplier
    IF @SupplierID IS NULL
    BEGIN
        -- Try to find supplier by prefix lookup
        SELECT TOP 1
            @SupplierID = SupplierID
        FROM BankTransactionSupplierPrefixes
        WHERE IsActive = 1
            AND @Description LIKE Prefix + '%'
        ORDER BY LEN(Prefix) DESC -- Longest match first
    END
    
    -- Update transaction with mapping
    UPDATE AP_StatementTransactions
    SET 
        MappingType = @TransactionType,
        SupplierID = @SupplierID,
        AccountCode = @AccountCode,
        IsMapped = 1,
        MappedDate = GETDATE()
    WHERE TransactionID = @TransactionID
    
    PRINT 'Transaction mapped: ' + @Description + ' → ' + @TargetLedger + ' (' + ISNULL(@AccountCode, 'N/A') + ')'
END
GO

PRINT '✓ Auto-mapping stored procedure created'
PRINT ''

-- =============================================
-- SUMMARY
-- =============================================

PRINT '========================================='
PRINT 'BANK TRANSACTION MAPPING SYSTEM CREATED'
PRINT '========================================='
PRINT ''
PRINT 'Tables Created:'
PRINT '  1. BankTransactionMappingRules - Define mapping rules'
PRINT '  2. BankTransactionSupplierPrefixes - Map prefixes to suppliers'
PRINT ''
PRINT 'Stored Procedures:'
PRINT '  1. sp_BankStatement_AutoMapWithRules - Auto-map transactions using rules'
PRINT ''
PRINT 'Default Rules Configured:'
PRINT '  - INV- → Accounts Payable (2030)'
PRINT '  - TP- → Accounts Payable (2030)'
PRINT '  - TD TO → Accounts Payable (2030)'
PRINT '  - DEPOSIT → Accounts Receivable (1200)'
PRINT '  - OD- → Inter-Branch Transfer (1600)'
PRINT '  - FNB OB COLL → Credit Card Collections (1010)'
PRINT ''
PRINT 'Next Steps:'
PRINT '  1. Use BankTransactionMappingForm.vb to manage mapping rules'
PRINT '  2. Add supplier prefixes via UI (e.g., "TD TO TSHEPO" → Supplier)'
PRINT '  3. Run UPDATE_BANK_POSTING_PROCEDURES.sql to update posting logic'
PRINT '  4. Test fetch/map/post workflow'
PRINT ''
