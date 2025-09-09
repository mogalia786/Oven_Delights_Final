/* Sage/Pastel Compliant Accounting Schema for Oven Delights ERP */
/* Part 1: Core Accounting Tables */

-- 1. Chart of Accounts
CREATE TABLE GLAccounts (
    AccountID INT PRIMARY KEY IDENTITY(1000,1),
    AccountNumber VARCHAR(20) NOT NULL UNIQUE,
    AccountName NVARCHAR(100) NOT NULL,
    AccountType VARCHAR(20) NOT NULL CHECK (AccountType IN ('Asset', 'Liability', 'Equity', 'Income', 'Expense', 'Bank', 'AR', 'AP')),
    ParentAccountID INT NULL,
    IsActive BIT DEFAULT 1,
    IsSummary BIT DEFAULT 0,
    BalanceType CHAR(1) CHECK (BalanceType IN ('D', 'C')), -- D for Debit, C for Credit
    IsSystem BIT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT,
    ModifiedDate DATETIME NULL,
    ModifiedBy INT NULL,
    FOREIGN KEY (ParentAccountID) REFERENCES GLAccounts(AccountID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- 2. Fiscal Periods
CREATE TABLE FiscalPeriods (
    PeriodID INT PRIMARY KEY IDENTITY(1,1),
    PeriodName NVARCHAR(50) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsClosed BIT DEFAULT 0,
    ClosedDate DATETIME NULL,
    ClosedBy INT NULL,
    FOREIGN KEY (ClosedBy) REFERENCES Users(UserID),
    CONSTRAINT CHK_ValidPeriod CHECK (EndDate > StartDate)
);

-- 3. Journal Headers
CREATE TABLE JournalHeaders (
    JournalID INT PRIMARY KEY IDENTITY(1,1),
    JournalNumber VARCHAR(20) NOT NULL UNIQUE,
    JournalDate DATE NOT NULL,
    Reference NVARCHAR(50) NULL,
    Description NVARCHAR(255) NULL,
    FiscalPeriodID INT NOT NULL,
    IsPosted BIT DEFAULT 0,
    IsReversed BIT DEFAULT 0,
    ReversalRef INT NULL,
    CreatedBy INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME NULL,
    ModifiedBy INT NULL,
    PostedDate DATETIME NULL,
    PostedBy INT NULL,
    BranchID INT NOT NULL,
    FOREIGN KEY (FiscalPeriodID) REFERENCES FiscalPeriods(PeriodID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (PostedBy) REFERENCES Users(UserID),
    FOREIGN KEY (BranchID) REFERENCES Branches(ID),
    FOREIGN KEY (ReversalRef) REFERENCES JournalHeaders(JournalID)
);

-- 4. Journal Details
CREATE TABLE JournalDetails (
    JournalDetailID INT PRIMARY KEY IDENTITY(1,1),
    JournalID INT NOT NULL,
    LineNumber INT NOT NULL,
    AccountID INT NOT NULL,
    Debit DECIMAL(18,2) DEFAULT 0,
    Credit DECIMAL(18,2) DEFAULT 0,
    Description NVARCHAR(255) NULL,
    Reference1 NVARCHAR(50) NULL,
    Reference2 NVARCHAR(50) NULL,
    Reference3 NVARCHAR(50) NULL,
    CostCenterID INT NULL,
    ProjectID INT NULL,
    FOREIGN KEY (JournalID) REFERENCES JournalHeaders(JournalID) ON DELETE CASCADE,
    FOREIGN KEY (AccountID) REFERENCES GLAccounts(AccountID),
    CONSTRAINT CHK_ValidEntry CHECK ((Debit > 0 AND Credit = 0) OR (Credit > 0 AND Debit = 0)),
    CONSTRAINT UQ_JournalLine UNIQUE (JournalID, LineNumber)
);

-- 5. Account Balances
CREATE TABLE AccountBalances (
    AccountID INT NOT NULL,
    FiscalPeriodID INT NOT NULL,
    BranchID INT NOT NULL,
    OpeningBalance DECIMAL(18,2) DEFAULT 0,
    DebitTotal DECIMAL(18,2) DEFAULT 0,
    CreditTotal DECIMAL(18,2) DEFAULT 0,
    ClosingBalance DECIMAL(18,2) DEFAULT 0,
    LastUpdated DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (AccountID, FiscalPeriodID, BranchID),
    FOREIGN KEY (AccountID) REFERENCES GLAccounts(AccountID),
    FOREIGN KEY (FiscalPeriodID) REFERENCES FiscalPeriods(PeriodID),
    FOREIGN KEY (BranchID) REFERENCES Branches(ID)
);

-- 6. Document Numbering
CREATE TABLE DocumentNumbering (
    DocumentType VARCHAR(20) PRIMARY KEY, -- PO, INV, PAY, RC, JN, etc.
    Prefix VARCHAR(10) NOT NULL,
    NextNumber INT NOT NULL DEFAULT 1,
    NumberLength INT NOT NULL DEFAULT 6,
    BranchSpecific BIT DEFAULT 1,
    LastUsedNumber VARCHAR(50) NULL,
    LastUsedDate DATETIME NULL,
    ModifiedDate DATETIME DEFAULT GETDATE(),
    ModifiedBy INT NULL,
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- 7. Cost Centers
CREATE TABLE CostCenters (
    CostCenterID INT PRIMARY KEY IDENTITY(1,1),
    CostCenterCode VARCHAR(20) NOT NULL UNIQUE,
    CostCenterName NVARCHAR(100) NOT NULL,
    IsActive BIT DEFAULT 1,
    ParentID INT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT,
    FOREIGN KEY (ParentID) REFERENCES CostCenters(CostCenterID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- 8. Projects
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY IDENTITY(1,1),
    ProjectCode VARCHAR(20) NOT NULL UNIQUE,
    ProjectName NVARCHAR(100) NOT NULL,
    StartDate DATE NULL,
    EndDate DATE NULL,
    Status VARCHAR(20) DEFAULT 'Active',
    Budget DECIMAL(18,2) NULL,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT,
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

/* Part 2: Stored Procedures for Accounting Operations */

-- 1. Create Journal Entry
CREATE OR ALTER PROCEDURE sp_CreateJournalEntry
    @JournalDate DATE,
    @Reference NVARCHAR(50) = NULL,
    @Description NVARCHAR(255) = NULL,
    @FiscalPeriodID INT,
    @CreatedBy INT,
    @BranchID INT,
    @JournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @JournalNumber VARCHAR(20);
    DECLARE @NextNumber INT;
    
    BEGIN TRANSACTION;
    
    -- Get next journal number
    UPDATE DocumentNumbering WITH (TABLOCK)
    SET @NextNumber = NextNumber,
        @JournalNumber = Prefix + RIGHT('000000' + CAST(NextNumber AS VARCHAR(10)), NumberLength),
        NextNumber = NextNumber + 1,
        LastUsedNumber = Prefix + RIGHT('000000' + CAST(NextNumber AS VARCHAR(10)), NumberLength),
        LastUsedDate = GETDATE(),
        ModifiedDate = GETDATE(),
        ModifiedBy = @CreatedBy
    WHERE DocumentType = 'JN';
    
    -- Insert journal header
    INSERT INTO JournalHeaders (
        JournalNumber, JournalDate, Reference, Description, 
        FiscalPeriodID, CreatedBy, BranchID
    )
    VALUES (
        @JournalNumber, @JournalDate, @Reference, @Description,
        @FiscalPeriodID, @CreatedBy, @BranchID
    );
    
    SET @JournalID = SCOPE_IDENTITY();
    
    COMMIT TRANSACTION;
    
    RETURN @JournalID;
END;

-- 2. Add Journal Detail Line
CREATE OR ALTER PROCEDURE sp_AddJournalDetail
    @JournalID INT,
    @AccountID INT,
    @Debit DECIMAL(18,2) = 0,
    @Credit DECIMAL(18,2) = 0,
    @Description NVARCHAR(255) = NULL,
    @Reference1 NVARCHAR(50) = NULL,
    @Reference2 NVARCHAR(50) = NULL,
    @CostCenterID INT = NULL,
    @ProjectID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @LineNumber INT;
    
    -- Get next line number
    SELECT @LineNumber = ISNULL(MAX(LineNumber), 0) + 1 
    FROM JournalDetails 
    WHERE JournalID = @JournalID;
    
    -- Insert journal detail
    INSERT INTO JournalDetails (
        JournalID, LineNumber, AccountID, Debit, Credit,
        Description, Reference1, Reference2, CostCenterID, ProjectID
    )
    VALUES (
        @JournalID, @LineNumber, @AccountID, @Debit, @Credit,
        @Description, @Reference1, @Reference2, @CostCenterID, @ProjectID
    );
    
    RETURN @LineNumber;
END;

-- 3. Post Journal
CREATE OR ALTER PROCEDURE sp_PostJournal
    @JournalID INT,
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FiscalPeriodID INT;
    DECLARE @BranchID INT;
    DECLARE @IsPosted BIT;
    
    -- Get journal status
    SELECT 
        @FiscalPeriodID = FiscalPeriodID,
        @BranchID = BranchID,
        @IsPosted = IsPosted
    FROM JournalHeaders
    WHERE JournalID = @JournalID;
    
    -- Check if already posted
    IF @IsPosted = 1
    BEGIN
        RAISERROR('Journal has already been posted.', 16, 1);
        RETURN -1;
    END;
    
    -- Check fiscal period status
    IF EXISTS (SELECT 1 FROM FiscalPeriods WHERE PeriodID = @FiscalPeriodID AND IsClosed = 1)
    BEGIN
        RAISERROR('Cannot post to a closed fiscal period.', 16, 1);
        RETURN -2;
    END;
    
    -- Verify journal is balanced
    IF NOT EXISTS (
        SELECT 1
        FROM (
            SELECT SUM(Debit) AS TotalDebit, SUM(Credit) AS TotalCredit
            FROM JournalDetails
            WHERE JournalID = @JournalID
        ) AS T
        WHERE TotalDebit = TotalCredit
    )
    BEGIN
        RAISERROR('Journal is not balanced. Debits must equal credits.', 16, 1);
        RETURN -3;
    END;
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Update journal header
        UPDATE JournalHeaders
        SET IsPosted = 1,
            PostedDate = GETDATE(),
            PostedBy = @PostedBy
        WHERE JournalID = @JournalID;
        
        -- Update account balances
        MERGE AccountBalances AS target
        USING (
            SELECT 
                AccountID,
                SUM(Debit) AS Debit,
                SUM(Credit) AS Credit
            FROM JournalDetails
            WHERE JournalID = @JournalID
            GROUP BY AccountID
        ) AS source
        ON target.AccountID = source.AccountID 
           AND target.FiscalPeriodID = @FiscalPeriodID
           AND target.BranchID = @BranchID
        WHEN MATCHED THEN
            UPDATE SET 
                DebitTotal = target.DebitTotal + source.Debit,
                CreditTotal = target.CreditTotal + source.Credit,
                LastUpdated = GETDATE()
        WHEN NOT MATCHED THEN
            INSERT (AccountID, FiscalPeriodID, BranchID, DebitTotal, CreditTotal)
            VALUES (source.AccountID, @FiscalPeriodID, @BranchID, source.Debit, source.Credit);
        
        COMMIT TRANSACTION;
        RETURN 0; -- Success
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
        RETURN -100; -- General error
    END CATCH;
END;

-- 4. Generate Trial Balance
CREATE OR ALTER PROCEDURE sp_GenerateTrialBalance
    @AsOfDate DATE = NULL,
    @BranchID INT = NULL,
    @IncludeZeroBalances BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @AsOfDate IS NULL
        SET @AsOfDate = GETDATE();
    
    -- Get the current fiscal period
    DECLARE @FiscalPeriodID INT;
    
    SELECT TOP 1 @FiscalPeriodID = PeriodID
    FROM FiscalPeriods
    WHERE @AsOfDate BETWEEN StartDate AND EndDate
    ORDER BY PeriodID DESC;
    
    IF @FiscalPeriodID IS NULL
    BEGIN
        RAISERROR('No fiscal period found for the specified date.', 16, 1);
        RETURN;
    END;
    
    -- Generate trial balance
    SELECT 
        a.AccountNumber,
        a.AccountName,
        a.AccountType,
        ISNULL(ab.OpeningBalance, 0) AS OpeningBalance,
        ISNULL(ab.DebitTotal, 0) AS DebitTotal,
        ISNULL(ab.CreditTotal, 0) AS CreditTotal,
        CASE 
            WHEN a.BalanceType = 'D' THEN 
                ISNULL(ab.OpeningBalance, 0) + ISNULL(ab.DebitTotal, 0) - ISNULL(ab.CreditTotal, 0)
            ELSE
                ISNULL(ab.OpeningBalance, 0) + ISNULL(ab.CreditTotal, 0) - ISNULL(ab.DebitTotal, 0)
        END AS CurrentBalance
    FROM GLAccounts a
    LEFT JOIN AccountBalances ab ON a.AccountID = ab.AccountID 
        AND ab.FiscalPeriodID = @FiscalPeriodID
        AND (@BranchID IS NULL OR ab.BranchID = @BranchID)
    WHERE a.IsActive = 1
        AND (@IncludeZeroBalances = 1 OR 
             (ISNULL(ab.DebitTotal, 0) <> 0 OR ISNULL(ab.CreditTotal, 0) <> 0 OR 
              ISNULL(ab.OpeningBalance, 0) <> 0))
    ORDER BY a.AccountNumber;
END;

/* Part 3: Initial Setup Data */

-- Insert default document numbering
INSERT INTO DocumentNumbering (DocumentType, Prefix, NextNumber, NumberLength, BranchSpecific)
VALUES 
    ('JN', 'JN-', 1, 6, 0),      -- Journal Numbers
    ('PO', 'PO-', 1, 6, 1),      -- Purchase Orders
    ('INV', 'INV-', 1, 6, 1),    -- Invoices
    ('PY', 'PY-', 1, 6, 1),      -- Payments
    ('RC', 'RC-', 1, 6, 1),      -- Receipts
    ('CN', 'CN-', 1, 6, 1),      -- Credit Notes
    ('DN', 'DN-', 1, 6, 1);      -- Debit Notes

-- Create default fiscal year
DECLARE @CurrentYear INT = YEAR(GETDATE());
DECLARE @StartDate DATE = DATEFROMPARTS(@CurrentYear, 1, 1);
DECLARE @EndDate DATE = DATEFROMPARTS(@CurrentYear, 12, 31);

INSERT INTO FiscalPeriods (PeriodName, StartDate, EndDate, IsClosed)
VALUES 
    (CONCAT('FY', @CurrentYear, ' Q1'), DATEFROMPARTS(@CurrentYear, 1, 1), DATEFROMPARTS(@CurrentYear, 3, 31), 0),
    (CONCAT('FY', @CurrentYear, ' Q2'), DATEFROMPARTS(@CurrentYear, 4, 1), DATEFROMPARTS(@CurrentYear, 6, 30), 0),
    (CONCAT('FY', @CurrentYear, ' Q3'), DATEFROMPARTS(@CurrentYear, 7, 1), DATEFROMPARTS(@CurrentYear, 9, 30), 0),
    (CONCAT('FY', @CurrentYear, ' Q4'), DATEFROMPARTS(@CurrentYear, 10, 1), DATEFROMPARTS(@CurrentYear, 12, 31), 0);

-- Create chart of accounts (simplified example)
-- Note: In a real implementation, this would be more comprehensive
INSERT INTO GLAccounts (AccountNumber, AccountName, AccountType, BalanceType, IsSystem, IsActive)
VALUES 
    -- Assets
    ('1000', 'Current Assets', 'Asset', 'D', 1, 1),
    ('1100', 'Bank Accounts', 'Asset', 'D', 1, 1),
    ('1200', 'Accounts Receivable', 'AR', 'D', 1, 1),
    ('1300', 'Inventory', 'Asset', 'D', 1, 1),
    
    -- Liabilities
    ('2000', 'Current Liabilities', 'Liability', 'C', 1, 1),
    ('2100', 'Accounts Payable', 'AP', 'C', 1, 1),
    
    -- Equity
    ('3000', 'Equity', 'Equity', 'C', 1, 1),
    
    -- Income
    ('4000', 'Revenue', 'Income', 'C', 1, 1),
    
    -- Expenses
    ('5000', 'Cost of Sales', 'Expense', 'D', 1, 1),
    ('6000', 'Operating Expenses', 'Expense', 'D', 1, 1);

-- Update parent accounts
UPDATE GLAccounts SET ParentAccountID = 1000 WHERE AccountNumber IN ('1100', '1200', '1300');
UPDATE GLAccounts SET ParentAccountID = 2000 WHERE AccountNumber = '2100';

/* Part 4: Document Numbering Function */

CREATE OR ALTER FUNCTION dbo.fn_GetNextDocumentNumber
(
    @DocumentType VARCHAR(20),
    @BranchID INT = NULL,
    @UserID INT = NULL
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @NextNumber INT;
    DECLARE @Prefix VARCHAR(20);
    DECLARE @NumberLength INT;
    DECLARE @BranchPrefix VARCHAR(10) = '';
    DECLARE @UserRoleCode VARCHAR(5) = '';
    
    -- Get branch prefix if applicable
    IF @BranchID IS NOT NULL
    BEGIN
        SELECT @BranchPrefix = ISNULL(Prefix, '') + '-'
        FROM Branches 
        WHERE ID = @BranchID;
    END
    
    -- Get user role code if applicable
    IF @UserID IS NOT NULL
    BEGIN
        SELECT @UserRoleCode = 
            CASE 
                WHEN r.Name = 'Super-Admin' THEN 'SA'
                WHEN r.Name = 'Admin' THEN 'A'
                WHEN r.Name = 'Stockroom-Manager' THEN 'SM'
                WHEN r.Name = 'Manufacturing-Manager' THEN 'MM'
                WHEN r.Name = 'Retail-Manager' THEN 'RM'
                ELSE ''
            END + '-'
        FROM Users u
        JOIN Roles r ON u.RoleID = r.RoleID
        WHERE u.UserID = @UserID;
    END
    
    -- Get next number and update sequence
    UPDATE DocumentNumbering WITH (TABLOCK)
    SET @NextNumber = NextNumber,
        @Prefix = Prefix,
        @NumberLength = NumberLength,
        NextNumber = NextNumber + 1,
        LastUsedNumber = @BranchPrefix + @UserRoleCode + Prefix + RIGHT('000000' + CAST(NextNumber AS VARCHAR(10)), NumberLength),
        LastUsedDate = GETDATE(),
        ModifiedDate = GETDATE(),
        ModifiedBy = @UserID
    WHERE DocumentType = @DocumentType;
    
    -- Format the document number
    RETURN @BranchPrefix + @UserRoleCode + @Prefix + RIGHT('000000' + CAST(@NextNumber AS VARCHAR(10)), @NumberLength);
END;

/* Part 5: Integration with Existing Tables */

-- Add JournalID to InventoryTransactions
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('InventoryTransactions') AND name = 'JournalID')
BEGIN
    ALTER TABLE InventoryTransactions
    ADD JournalID INT NULL,
        CONSTRAINT FK_InventoryTransactions_Journal FOREIGN KEY (JournalID) REFERENCES JournalHeaders(JournalID);
END

-- Add JournalID to PurchaseOrders
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PurchaseOrders') AND name = 'JournalID')
BEGIN
    ALTER TABLE PurchaseOrders
    ADD JournalID INT NULL,
        CONSTRAINT FK_PurchaseOrders_Journal FOREIGN KEY (JournalID) REFERENCES JournalHeaders(JournalID);
END

-- Add IsPosted to other transaction tables if they don't have it
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PurchaseOrders') AND name = 'IsPosted')
BEGIN
    ALTER TABLE PurchaseOrders
    ADD IsPosted BIT DEFAULT 0,
        PostedDate DATETIME NULL,
        PostedBy INT NULL,
        CONSTRAINT FK_PurchaseOrders_PostedByUser FOREIGN KEY (PostedBy) REFERENCES Users(UserID);
END

-- Create index for better performance
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_JournalDetails_AccountID')
BEGIN
    CREATE NONCLUSTERED INDEX IX_JournalDetails_AccountID ON JournalDetails(AccountID);
END

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_JournalHeaders_Period_Branch')
BEGIN
    CREATE NONCLUSTERED INDEX IX_JournalHeaders_Period_Branch ON JournalHeaders(FiscalPeriodID, BranchID, IsPosted);
END
