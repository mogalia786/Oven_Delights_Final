-- =============================================
-- Core General Ledger Stored Procedures
-- =============================================

-- =============================================
-- sp_GL_CreateJournal - Create a new journal entry
-- =============================================
CREATE OR ALTER PROCEDURE sp_GL_CreateJournal
    @JournalDate DATE,
    @Reference NVARCHAR(100) = NULL,
    @Description NVARCHAR(500),
    @BranchID INT = NULL,
    @CreatedBy NVARCHAR(100),
    @AutoPost BIT = 1,
    @JournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalNumber NVARCHAR(50)
        
        -- Generate journal number
        SET @JournalNumber = 'JNL-' + FORMAT(@JournalDate, 'yyyyMMdd') + '-' + 
                            RIGHT('000000' + CAST(NEXT VALUE FOR seq_JournalNumber AS VARCHAR(6)), 6)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber, @BranchID, @JournalDate, @Reference, @Description,
            NULL, CASE WHEN @AutoPost = 1 THEN 1 ELSE 0 END, @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, @JournalNumber AS JournalNumber
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- Create sequence for journal numbering if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = 'seq_JournalNumber')
BEGIN
    CREATE SEQUENCE seq_JournalNumber START WITH 1 INCREMENT BY 1
END
GO

-- =============================================
-- sp_GL_AddJournalLine - Add line to journal
-- =============================================
CREATE OR ALTER PROCEDURE sp_GL_AddJournalLine
    @JournalID INT,
    @AccountCode NVARCHAR(20),
    @Debit DECIMAL(18,2) = 0,
    @Credit DECIMAL(18,2) = 0,
    @Description NVARCHAR(500) = NULL,
    @Reference1 NVARCHAR(100) = NULL,
    @Reference2 NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @AccountID INT
    DECLARE @LineNumber INT
    
    -- Get AccountID
    SELECT @AccountID = AccountID 
    FROM ChartOfAccounts 
    WHERE AccountCode = @AccountCode AND IsActive = 1
    
    IF @AccountID IS NULL
    BEGIN
        RAISERROR ('Account code %s not found or inactive', 16, 1, @AccountCode)
        RETURN
    END
    
    -- Get next line number
    SELECT @LineNumber = ISNULL(MAX(LineNumber), 0) + 1
    FROM JournalDetails
    WHERE JournalID = @JournalID
    
    -- Insert journal line
    INSERT INTO JournalDetails (
        JournalID, LineNumber, AccountID, Debit, Credit,
        Description, Reference1, Reference2
    )
    VALUES (
        @JournalID, @LineNumber, @AccountID, @Debit, @Credit,
        @Description, @Reference1, @Reference2
    )
END
GO

-- =============================================
-- sp_GL_PostJournal - Post journal to ledger
-- =============================================
CREATE OR ALTER PROCEDURE sp_GL_PostJournal
    @JournalID INT,
    @PostedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @TotalDebits DECIMAL(18,2)
        DECLARE @TotalCredits DECIMAL(18,2)
        
        -- Validate journal balances
        SELECT 
            @TotalDebits = SUM(Debit),
            @TotalCredits = SUM(Credit)
        FROM JournalDetails
        WHERE JournalID = @JournalID
        
        IF @TotalDebits <> @TotalCredits
        BEGIN
            DECLARE @ErrorMsg NVARCHAR(500)
            SET @ErrorMsg = 'Journal does not balance. Debits: ' + CONVERT(NVARCHAR(20), @TotalDebits) + ', Credits: ' + CONVERT(NVARCHAR(20), @TotalCredits)
            RAISERROR (@ErrorMsg, 16, 1)
            RETURN
        END
        
        -- Update account balances
        UPDATE coa
        SET CurrentBalance = CurrentBalance + ISNULL(jd.Debit, 0) - ISNULL(jd.Credit, 0)
        FROM ChartOfAccounts coa
        INNER JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
        WHERE jd.JournalID = @JournalID
        
        -- Mark journal as posted
        UPDATE JournalHeaders
        SET IsPosted = 1,
            PostedDate = GETDATE(),
            PostedBy = @PostedBy
        WHERE JournalID = @JournalID
        
        COMMIT TRANSACTION;
        
        SELECT 'Journal posted successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =============================================
-- sp_GL_ReverseJournal - Reverse a journal entry
-- =============================================
CREATE OR ALTER PROCEDURE sp_GL_ReverseJournal
    @JournalID INT,
    @ReversalDate DATE,
    @ReversalReason NVARCHAR(500),
    @CreatedBy NVARCHAR(100),
    @ReversalJournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @OriginalJournalNumber NVARCHAR(50)
        DECLARE @OriginalDescription NVARCHAR(500)
        DECLARE @ReversalJournalNumber NVARCHAR(50)
        DECLARE @ReversalDescription NVARCHAR(500)
        
        -- Get original journal info
        SELECT 
            @OriginalJournalNumber = JournalNumber,
            @OriginalDescription = Description
        FROM JournalHeaders
        WHERE JournalID = @JournalID
        
        -- Generate reversal journal number
        SET @ReversalJournalNumber = 'REV-' + @OriginalJournalNumber + '-' + CONVERT(NVARCHAR(20), GETDATE(), 112) + REPLACE(CONVERT(NVARCHAR(20), GETDATE(), 108), ':', '')
        
        -- Build reversal description
        SET @ReversalDescription = 'REVERSAL: ' + @OriginalDescription + ' - ' + @ReversalReason
        
        -- Create reversal journal
        EXEC sp_GL_CreateJournal
            @JournalDate = @ReversalDate,
            @Reference = @OriginalJournalNumber,
            @Description = @ReversalDescription,
            @BranchID = NULL,
            @CreatedBy = @CreatedBy,
            @AutoPost = 0,
            @JournalID = @ReversalJournalID OUTPUT
        
        -- Create reversal journal lines (swap debits and credits)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        SELECT 
            @ReversalJournalID,
            LineNumber,
            AccountID,
            Credit, -- Swap: original credit becomes debit
            Debit,  -- Swap: original debit becomes credit
            'REVERSAL: ' + Description,
            Reference1,
            Reference2
        FROM JournalDetails
        WHERE JournalID = @JournalID
        
        -- Post the reversal
        EXEC sp_GL_PostJournal @ReversalJournalID, @CreatedBy
        
        COMMIT TRANSACTION;
        
        SELECT @ReversalJournalID AS ReversalJournalID, 'Journal reversed successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'Core GL procedures created successfully'
GO
