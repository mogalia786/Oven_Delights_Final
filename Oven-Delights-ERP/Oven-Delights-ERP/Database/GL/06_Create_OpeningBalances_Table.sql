-- =============================================
-- Create Opening Balances Table
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OpeningBalances')
BEGIN
    CREATE TABLE OpeningBalances (
        OpeningBalanceID INT IDENTITY(1,1) PRIMARY KEY,
        AccountID INT NOT NULL,
        BranchID INT NULL,
        FiscalYear INT NOT NULL,
        DebitAmount DECIMAL(18,2) DEFAULT 0,
        CreditAmount DECIMAL(18,2) DEFAULT 0,
        Description NVARCHAR(500) NULL,
        ImportedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ImportedBy NVARCHAR(100) NOT NULL,
        IsPosted BIT DEFAULT 0,
        PostedDate DATETIME NULL,
        JournalID INT NULL,
        CONSTRAINT FK_OpeningBalances_Account FOREIGN KEY (AccountID) REFERENCES ChartOfAccounts(AccountID),
        CONSTRAINT FK_OpeningBalances_Journal FOREIGN KEY (JournalID) REFERENCES JournalHeaders(JournalID)
    )
    
    CREATE INDEX IX_OpeningBalances_Account ON OpeningBalances(AccountID)
    CREATE INDEX IX_OpeningBalances_Branch ON OpeningBalances(BranchID)
    CREATE INDEX IX_OpeningBalances_FiscalYear ON OpeningBalances(FiscalYear)
    
    PRINT 'OpeningBalances table created successfully'
END
ELSE
BEGIN
    PRINT 'OpeningBalances table already exists'
END
GO

-- =============================================
-- Stored Procedure: Import Opening Balances
-- =============================================
IF OBJECT_ID('sp_GL_ImportOpeningBalances', 'P') IS NOT NULL
    DROP PROCEDURE sp_GL_ImportOpeningBalances
GO

CREATE PROCEDURE sp_GL_ImportOpeningBalances
    @FiscalYear INT,
    @ImportedBy NVARCHAR(100),
    @PostImmediately BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @TotalDebits DECIMAL(18,2)
        DECLARE @TotalCredits DECIMAL(18,2)
        
        -- Validate opening balances balance
        SELECT 
            @TotalDebits = SUM(DebitAmount),
            @TotalCredits = SUM(CreditAmount)
        FROM OpeningBalances
        WHERE FiscalYear = @FiscalYear AND IsPosted = 0
        
        IF @TotalDebits <> @TotalCredits
        BEGIN
            DECLARE @ErrorMsg NVARCHAR(500)
            SET @ErrorMsg = 'Opening balances do not balance. Debits: ' + CAST(@TotalDebits AS NVARCHAR(20)) + ', Credits: ' + CAST(@TotalCredits AS NVARCHAR(20))
            RAISERROR(@ErrorMsg, 16, 1)
            RETURN
        END
        
        IF @PostImmediately = 1
        BEGIN
            -- Create journal header for opening balances
            SET @JournalNumber = 'OB-' + CAST(@FiscalYear AS NVARCHAR(4))
            
            INSERT INTO JournalHeaders (
                JournalNumber, JournalDate, Reference, Description, 
                FiscalPeriodID, IsPosted, CreatedBy
            )
            VALUES (
                @JournalNumber,
                CAST(@FiscalYear AS VARCHAR(4)) + '-01-01',
                'Opening Balances',
                'Opening Balances for Fiscal Year ' + CAST(@FiscalYear AS NVARCHAR(4)),
                NULL,
                1,
                @ImportedBy
            )
            
            SET @JournalID = SCOPE_IDENTITY()
            
            -- Create journal details from opening balances
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit, 
                Description
            )
            SELECT 
                @JournalID,
                ROW_NUMBER() OVER (ORDER BY AccountID),
                AccountID,
                DebitAmount,
                CreditAmount,
                'Opening Balance - ' + Description
            FROM OpeningBalances
            WHERE FiscalYear = @FiscalYear AND IsPosted = 0
            
            -- Update opening balances as posted
            UPDATE OpeningBalances
            SET IsPosted = 1,
                PostedDate = GETDATE(),
                JournalID = @JournalID
            WHERE FiscalYear = @FiscalYear AND IsPosted = 0
            
            -- Update ChartOfAccounts with opening balances
            UPDATE coa
            SET OpeningBalance = ISNULL(ob.DebitAmount, 0) - ISNULL(ob.CreditAmount, 0),
                CurrentBalance = ISNULL(ob.DebitAmount, 0) - ISNULL(ob.CreditAmount, 0)
            FROM ChartOfAccounts coa
            INNER JOIN OpeningBalances ob ON coa.AccountID = ob.AccountID
            WHERE ob.FiscalYear = @FiscalYear AND ob.IsPosted = 1
        END
        
        COMMIT TRANSACTION;
        
        SELECT 
            @JournalID AS JournalID,
            @JournalNumber AS JournalNumber,
            @TotalDebits AS TotalDebits,
            @TotalCredits AS TotalCredits,
            'Opening balances imported and posted successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'Opening Balances infrastructure created successfully'
GO
