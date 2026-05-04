-- =============================================
-- BANK STATEMENT TRANSACTION MAPPING SYSTEM
-- =============================================
-- Allows users to configure how bank transactions
-- are automatically mapped to GL accounts and
-- subsidiary ledgers (Suppliers/Customers)
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
    AccountCode NVARCHAR(20) NULL, -- GL Account code (e.g., '2010' for AP, '1200' for AR)
    SupplierID INT NULL, -- If specific supplier, link here
    CustomerID INT NULL, -- If specific customer, link here
    ExtractEntityFromDescription BIT DEFAULT 0, -- If 1, extract supplier/customer name from description
    EntityExtractionPattern NVARCHAR(200) NULL, -- Regex or pattern to extract entity name
    Priority INT DEFAULT 100, -- Lower number = higher priority (checked first)
    IsActive BIT DEFAULT 1,
    CreatedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedBy NVARCHAR(100) NULL,
    ModifiedDate DATETIME NULL,
    Notes NVARCHAR(500) NULL
)
GO

-- Create index for fast lookups
CREATE INDEX IX_BankTransactionMapping_MatchValue ON BankTransactionMappingRules(MatchValue, IsActive, Priority)
GO

-- =============================================
-- INSERT DEFAULT MAPPING RULES
-- =============================================

PRINT 'Inserting default bank transaction mapping rules...'

-- Rule 1: INV- prefix = Supplier Invoice (Accounts Payable)
INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, ExtractEntityFromDescription, Priority, Notes)
VALUES ('Supplier Invoice - INV Prefix', 'Prefix', 'INV-', 'Payment', 'AccountsPayable', '2030', 1, 10, 'Matches invoices with INV- prefix, extracts supplier from description')

-- Rule 2: TP- prefix = Supplier Payment (Accounts Payable)
INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, ExtractEntityFromDescription, Priority, Notes)
VALUES ('Supplier Payment - TP Prefix', 'Prefix', 'TP-', 'Payment', 'AccountsPayable', '2030', 1, 10, 'Matches payments with TP- prefix')

-- Rule 3: TD TO = Transfer/Payment to Supplier (Accounts Payable)
INSERT INTO BankTransactionMappingRules (RuleName, MatchType, MatchValue, TransactionType, TargetLedger, AccountCode, ExtractEntityFromDescription, Priority, Notes)
VALUES ('Supplier Payment - TD TO', 'Prefix', 'TD TO', 'Payment', 'AccountsPayable', '2030', 1, 20, 'Matches "TD TO [Supplier Name]" payments, extracts supplier name')

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
VALUES ('Generic Payment - PMT', 'Contains', 'FNB OB PMT', 'Payment', 'AccountsPayable', '2030', 1, 70, 'Generic payments, extract beneficiary from description')

PRINT '✓ Default mapping rules created'
PRINT ''

-- =============================================
-- CREATE SUPPLIER/CUSTOMER PREFIX LOOKUP TABLE
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
    EntityName NVARCHAR(200) NOT NULL, -- Supplier/Customer name for display
    IsActive BIT DEFAULT 1,
    CreatedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_EntityPrefix_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT FK_EntityPrefix_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)
GO

CREATE INDEX IX_EntityPrefix_Lookup ON BankTransactionEntityPrefixes(Prefix, IsActive)
GO

PRINT 'Entity prefix lookup table created'
PRINT ''

-- =============================================
-- SAMPLE ENTITY PREFIX MAPPINGS
-- =============================================

PRINT 'Sample entity prefix mappings (user can add more via UI):'
PRINT '  - Add "TP-1234" → Supplier XYZ'
PRINT '  - Add "TD TO TSHEPO" → Supplier Tshepo'
PRINT '  - Add "DEPOSIT TEST1" → Customer Test Account'
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
    DECLARE @CustomerID INT
    DECLARE @TransactionType NVARCHAR(20)
    
    -- Get transaction details
    SELECT 
        @Description = Description,
        @Amount = Amount,
        @CreditDebit = CreditDebit
    FROM BankStatementTransactions
    WHERE TransactionID = @TransactionID
    
    -- Find matching rule (highest priority first)
    SELECT TOP 1
        @MatchedRuleID = RuleID,
        @TargetLedger = TargetLedger,
        @AccountCode = AccountCode,
        @SupplierID = SupplierID,
        @CustomerID = CustomerID,
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
    
    -- Check entity prefix lookup for specific supplier/customer
    IF @SupplierID IS NULL AND @CustomerID IS NULL
    BEGIN
        -- Try to find entity by prefix lookup
        SELECT TOP 1
            @SupplierID = SupplierID,
            @CustomerID = CustomerID
        FROM BankTransactionEntityPrefixes
        WHERE IsActive = 1
            AND @Description LIKE Prefix + '%'
        ORDER BY LEN(Prefix) DESC -- Longest match first
    END
    
    -- Update transaction with mapping
    UPDATE BankStatementTransactions
    SET 
        MappingType = @TransactionType,
        SupplierID = @SupplierID,
        CustomerID = @CustomerID,
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
PRINT '  2. BankTransactionEntityPrefixes - Map prefixes to suppliers/customers'
PRINT ''
PRINT 'Stored Procedures:'
PRINT '  1. sp_BankStatement_AutoMapWithRules - Auto-map transactions using rules'
PRINT ''
PRINT 'Default Rules Configured:'
PRINT '  - INV- → Accounts Payable'
PRINT '  - TP- → Accounts Payable'
PRINT '  - TD TO → Accounts Payable'
PRINT '  - DEPOSIT → Accounts Receivable'
PRINT '  - OD- → Inter-Branch Transfer'
PRINT '  - FNB OB COLL → Credit Card Collections'
PRINT ''
PRINT 'Next Steps:'
PRINT '  1. Create UI form to manage mapping rules'
PRINT '  2. Create UI form to manage entity prefixes'
PRINT '  3. Update auto-map button to use sp_BankStatement_AutoMapWithRules'
PRINT '  4. Update posting procedures to use mapped SupplierID/CustomerID'
PRINT ''
