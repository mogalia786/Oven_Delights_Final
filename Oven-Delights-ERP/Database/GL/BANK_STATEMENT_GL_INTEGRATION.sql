-- =============================================
-- BANK STATEMENT TO GL INTEGRATION
-- Properly posts bank statement transactions to GL
-- =============================================

SET NOCOUNT ON
GO

PRINT ''
PRINT '========================================='
PRINT 'BANK STATEMENT GL INTEGRATION'
PRINT '========================================='
PRINT ''

-- =============================================
-- 1. CREATE BANK STATEMENT MAPPING TABLE
-- =============================================

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BankStatementTransactions')
BEGIN
    CREATE TABLE BankStatementTransactions (
        TransactionID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        TransactionDate DATE NOT NULL,
        Description NVARCHAR(500) NOT NULL,
        Reference NVARCHAR(100) NULL,
        DebitAmount DECIMAL(18,2) NULL,
        CreditAmount DECIMAL(18,2) NULL,
        Balance DECIMAL(18,2) NULL,
        AccountCode NVARCHAR(20) NULL,
        AccountName NVARCHAR(200) NULL,
        SupplierMatch NVARCHAR(200) NULL,
        InvoiceMatch NVARCHAR(100) NULL,
        IsPostedToGL BIT NOT NULL DEFAULT(0),
        JournalID INT NULL,
        ImportedBy INT NOT NULL,
        ImportedDate DATETIME NOT NULL DEFAULT(GETDATE()),
        PostedBy INT NULL,
        PostedDate DATETIME NULL,
        CONSTRAINT FK_BankStatement_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    )
    
    PRINT '✓ Created BankStatementTransactions table'
END
ELSE
    PRINT '✓ BankStatementTransactions table already exists'
GO

-- =============================================
-- 2. CREATE ACCOUNT MAPPING RULES TABLE
-- =============================================

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BankStatementMappingRules')
BEGIN
    CREATE TABLE BankStatementMappingRules (
        RuleID INT IDENTITY(1,1) PRIMARY KEY,
        Keyword NVARCHAR(100) NOT NULL,
        AccountCode NVARCHAR(20) NOT NULL,
        AccountName NVARCHAR(200) NOT NULL,
        Priority INT NOT NULL DEFAULT(10),
        IsActive BIT NOT NULL DEFAULT(1),
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT(GETDATE()),
        CONSTRAINT FK_MappingRule_Account FOREIGN KEY (AccountCode) REFERENCES ChartOfAccounts(AccountCode)
    )
    
    PRINT '✓ Created BankStatementMappingRules table'
    
    -- Insert default mapping rules
    INSERT INTO BankStatementMappingRules (Keyword, AccountCode, AccountName, Priority, IsActive, CreatedBy)
    VALUES 
        ('RENT', '6010', 'Rent Expense', 1, 1, 1),
        ('RATES', '6010', 'Rent Expense', 2, 1, 1),
        ('MUNICIPAL', '6010', 'Rent Expense', 2, 1, 1),
        ('ELECTRICITY', '6020', 'Utilities Expense', 1, 1, 1),
        ('ESKOM', '6020', 'Utilities Expense', 1, 1, 1),
        ('WATER', '6020', 'Utilities Expense', 2, 1, 1),
        ('TELEPHONE', '6030', 'Telephone & Internet', 1, 1, 1),
        ('INTERNET', '6030', 'Telephone & Internet', 1, 1, 1),
        ('VODACOM', '6030', 'Telephone & Internet', 2, 1, 1),
        ('MTN', '6030', 'Telephone & Internet', 2, 1, 1),
        ('TELKOM', '6030', 'Telephone & Internet', 2, 1, 1),
        ('OFFICE SUPPLIES', '6040', 'Office Supplies', 1, 1, 1),
        ('STATIONERY', '6040', 'Office Supplies', 2, 1, 1),
        ('BANK CHARGES', '6030', 'Telephone & Internet', 1, 1, 1),
        ('SERVICE FEE', '6030', 'Telephone & Internet', 2, 1, 1),
        ('SALARY', '5020', 'Direct Labor', 1, 1, 1),
        ('WAGES', '5020', 'Direct Labor', 1, 1, 1),
        ('EFT CREDIT', '4010', 'Sales Revenue', 1, 1, 1),
        ('DEPOSIT', '4010', 'Sales Revenue', 2, 1, 1)
    
    PRINT '✓ Inserted default mapping rules'
END
ELSE
    PRINT '✓ BankStatementMappingRules table already exists'
GO

-- =============================================
-- 3. POST BANK STATEMENT TRANSACTION TO GL
-- =============================================

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_BankStatement_PostToGL' AND type = 'P')
    DROP PROCEDURE sp_BankStatement_PostToGL
GO

CREATE PROCEDURE sp_BankStatement_PostToGL
    @TransactionID INT,
    @AccountCode NVARCHAR(20),
    @BranchID INT,
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @TransactionDate DATE, @Description NVARCHAR(500), @Reference NVARCHAR(100)
        DECLARE @DebitAmount DECIMAL(18,2), @CreditAmount DECIMAL(18,2)
        DECLARE @AccountName NVARCHAR(200), @JournalID INT, @JournalNumber NVARCHAR(50)
        DECLARE @BankAccountID INT, @ExpenseAccountID INT, @FiscalPeriodID INT
        DECLARE @Amount DECIMAL(18,2), @IsDebit BIT
        
        -- Get transaction details
        SELECT 
            @TransactionDate = TransactionDate,
            @Description = Description,
            @Reference = Reference,
            @DebitAmount = ISNULL(DebitAmount, 0),
            @CreditAmount = ISNULL(CreditAmount, 0)
        FROM BankStatementTransactions
        WHERE TransactionID = @TransactionID
        
        IF @TransactionDate IS NULL
            RAISERROR('Transaction not found', 16, 1)
        
        -- Check if already posted
        IF EXISTS (SELECT 1 FROM BankStatementTransactions WHERE TransactionID = @TransactionID AND IsPostedToGL = 1)
            RAISERROR('Transaction already posted to GL', 16, 1)
        
        -- Determine amount and direction
        IF @DebitAmount > 0
        BEGIN
            SET @Amount = @DebitAmount
            SET @IsDebit = 0  -- Bank debit = money out = expense
        END
        ELSE
        BEGIN
            SET @Amount = @CreditAmount
            SET @IsDebit = 1  -- Bank credit = money in = revenue
        END
        
        -- Get account details
        SELECT @ExpenseAccountID = AccountID, @AccountName = AccountName
        FROM ChartOfAccounts
        WHERE AccountCode = @AccountCode AND IsActive = 1
        
        IF @ExpenseAccountID IS NULL
            RAISERROR('Account code not found or inactive', 16, 1)
        
        -- Get bank account (1010)
        SELECT @BankAccountID = AccountID
        FROM ChartOfAccounts
        WHERE AccountCode = '1010' AND IsActive = 1
        
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found', 16, 1)
        
        -- Get fiscal period
        SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@TransactionDate)
        
        -- Generate journal number
        SET @JournalNumber = 'BANK-' + CONVERT(VARCHAR(10), @TransactionID)
        
        -- Create journal header
        INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy)
        VALUES (@JournalNumber, @BranchID, @TransactionDate, @Reference, 'Bank Statement: ' + @Description, @FiscalPeriodID, 1, @PostedBy)
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Create journal details based on transaction type
        IF @IsDebit = 0  -- Money out (expense)
        BEGIN
            -- DR Expense Account
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 1, @ExpenseAccountID, @Amount, 0, @Description, @Reference, 'Bank Statement')
            
            -- CR Bank Account
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 2, @BankAccountID, 0, @Amount, 'Payment via bank', @Reference, 'Bank Statement')
        END
        ELSE  -- Money in (revenue)
        BEGIN
            -- DR Bank Account
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 1, @BankAccountID, @Amount, 0, 'Receipt via bank', @Reference, 'Bank Statement')
            
            -- CR Revenue Account
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 2, @ExpenseAccountID, 0, @Amount, @Description, @Reference, 'Bank Statement')
        END
        
        -- Update bank statement transaction
        UPDATE BankStatementTransactions
        SET IsPostedToGL = 1,
            JournalID = @JournalID,
            AccountCode = @AccountCode,
            AccountName = @AccountName,
            PostedBy = @PostedBy,
            PostedDate = GETDATE()
        WHERE TransactionID = @TransactionID
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'Bank statement transaction posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_BankStatement_PostToGL'
GO

-- =============================================
-- 4. AUTO-MAP BANK STATEMENT TRANSACTION
-- =============================================

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_BankStatement_AutoMap' AND type = 'P')
    DROP PROCEDURE sp_BankStatement_AutoMap
GO

CREATE PROCEDURE sp_BankStatement_AutoMap
    @TransactionID INT
AS
BEGIN
    SET NOCOUNT ON
    
    DECLARE @Description NVARCHAR(500)
    DECLARE @AccountCode NVARCHAR(20), @AccountName NVARCHAR(200)
    
    -- Get transaction description
    SELECT @Description = UPPER(Description)
    FROM BankStatementTransactions
    WHERE TransactionID = @TransactionID
    
    -- Find matching rule (highest priority first)
    SELECT TOP 1 
        @AccountCode = AccountCode,
        @AccountName = AccountName
    FROM BankStatementMappingRules
    WHERE IsActive = 1
        AND @Description LIKE '%' + Keyword + '%'
    ORDER BY Priority ASC
    
    -- Update transaction with suggested mapping
    IF @AccountCode IS NOT NULL
    BEGIN
        UPDATE BankStatementTransactions
        SET AccountCode = @AccountCode,
            AccountName = @AccountName
        WHERE TransactionID = @TransactionID
        
        SELECT 1 AS Success, @AccountCode AS AccountCode, @AccountName AS AccountName, 'Auto-mapped successfully' AS Message
    END
    ELSE
    BEGIN
        SELECT 0 AS Success, NULL AS AccountCode, NULL AS AccountName, 'No matching rule found' AS Message
    END
END
GO

PRINT '✓ Created sp_BankStatement_AutoMap'
GO

-- =============================================
-- 5. BULK POST BANK STATEMENTS TO GL
-- =============================================

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_BankStatement_BulkPostToGL' AND type = 'P')
    DROP PROCEDURE sp_BankStatement_BulkPostToGL
GO

CREATE PROCEDURE sp_BankStatement_BulkPostToGL
    @BranchID INT,
    @FromDate DATE,
    @ToDate DATE,
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    DECLARE @TransactionID INT, @AccountCode NVARCHAR(20)
    DECLARE @SuccessCount INT = 0, @ErrorCount INT = 0
    
    DECLARE transaction_cursor CURSOR FOR
    SELECT TransactionID, AccountCode
    FROM BankStatementTransactions
    WHERE BranchID = @BranchID
        AND TransactionDate BETWEEN @FromDate AND @ToDate
        AND IsPostedToGL = 0
        AND AccountCode IS NOT NULL
    
    OPEN transaction_cursor
    FETCH NEXT FROM transaction_cursor INTO @TransactionID, @AccountCode
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            EXEC sp_BankStatement_PostToGL @TransactionID, @AccountCode, @BranchID, @PostedBy
            SET @SuccessCount = @SuccessCount + 1
        END TRY
        BEGIN CATCH
            SET @ErrorCount = @ErrorCount + 1
        END CATCH
        
        FETCH NEXT FROM transaction_cursor INTO @TransactionID, @AccountCode
    END
    
    CLOSE transaction_cursor
    DEALLOCATE transaction_cursor
    
    SELECT @SuccessCount AS SuccessCount, @ErrorCount AS ErrorCount, 
           'Posted ' + CAST(@SuccessCount AS VARCHAR(10)) + ' transactions, ' + 
           CAST(@ErrorCount AS VARCHAR(10)) + ' errors' AS Message
END
GO

PRINT '✓ Created sp_BankStatement_BulkPostToGL'
GO

PRINT ''
PRINT '========================================='
PRINT 'BANK STATEMENT GL INTEGRATION COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Created:'
PRINT '1. BankStatementTransactions table'
PRINT '2. BankStatementMappingRules table (with default rules)'
PRINT '3. sp_BankStatement_PostToGL - Post single transaction'
PRINT '4. sp_BankStatement_AutoMap - Auto-map transaction to account'
PRINT '5. sp_BankStatement_BulkPostToGL - Post multiple transactions'
PRINT ''
PRINT 'Usage Examples:'
PRINT ''
PRINT '-- Auto-map a transaction:'
PRINT 'EXEC sp_BankStatement_AutoMap @TransactionID = 1'
PRINT ''
PRINT '-- Post single transaction to GL:'
PRINT 'EXEC sp_BankStatement_PostToGL @TransactionID = 1, @AccountCode = ''6010'', @BranchID = 1, @PostedBy = 1'
PRINT ''
PRINT '-- Bulk post transactions:'
PRINT 'EXEC sp_BankStatement_BulkPostToGL @BranchID = 1, @FromDate = ''2026-01-01'', @ToDate = ''2026-01-31'', @PostedBy = 1'
PRINT ''
PRINT '-- View mapping rules:'
PRINT 'SELECT * FROM BankStatementMappingRules WHERE IsActive = 1 ORDER BY Priority'
PRINT ''
PRINT '-- View unposted transactions:'
PRINT 'SELECT * FROM BankStatementTransactions WHERE IsPostedToGL = 0'
PRINT ''
