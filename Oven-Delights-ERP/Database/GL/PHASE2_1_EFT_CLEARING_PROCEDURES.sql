-- =============================================
-- PHASE 2.1: EFT CLEARING PROCEDURES
-- Handle clearing of EFT payments (POS and AP)
-- =============================================

PRINT '========================================='
PRINT 'PHASE 2.1: EFT CLEARING PROCEDURES'
PRINT '========================================='
PRINT ''

-- =============================================
-- Drop existing procedures if they exist
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_AP_PostEFTClearingToGL' AND type = 'P')
    DROP PROCEDURE sp_AP_PostEFTClearingToGL
GO

PRINT '✓ Dropped old procedures (if existed)'
PRINT ''
GO

-- =============================================
-- sp_AP_PostEFTClearingToGL
-- Clear AP EFT payments (move from Uncleared to Bank)
-- =============================================
CREATE PROCEDURE sp_AP_PostEFTClearingToGL
    @ClearingReference NVARCHAR(50),
    @ClearingDate DATE,
    @BranchID INT,
    @ClearingAmount DECIMAL(18,2),
    @SupplierName NVARCHAR(200),
    @OriginalPaymentReference NVARCHAR(50),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(20)
        DECLARE @FiscalPeriodID INT
        
        -- Account IDs
        DECLARE @BankAccountID INT
        DECLARE @EFTDebtorsAccountID INT
        
        -- Get Account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @EFTDebtorsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1050' AND IsActive = 1
        
        -- Validate accounts exist
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found or inactive', 16, 1)
            
        IF @EFTDebtorsAccountID IS NULL
            RAISERROR('Debtors - Uncleared EFT account 1050 not found or inactive', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'EFTC-AP-' + @ClearingReference
        
        -- Get fiscal period
        SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@ClearingDate)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @ClearingDate,
            @ClearingReference,
            'AP EFT Clearing - ' + @SupplierName,
            @FiscalPeriodID,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- DEBIT: Bank (EFT cleared to bank)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
        VALUES (@JournalID, 1, @BankAccountID, @ClearingAmount, 0, 'AP EFT cleared to bank', @ClearingReference, @OriginalPaymentReference)
        
        -- CREDIT: Debtors - Uncleared EFT (Clear pending EFT)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
        VALUES (@JournalID, 2, @EFTDebtorsAccountID, 0, @ClearingAmount, 'Clear pending AP EFT', @ClearingReference, @OriginalPaymentReference)
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'AP EFT clearing posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_AP_PostEFTClearingToGL'
GO

-- =============================================
-- sp_EFT_GetUnclearedTransactions
-- Get all uncleared EFT transactions (POS and AP)
-- =============================================
CREATE PROCEDURE sp_EFT_GetUnclearedTransactions
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON
    
    -- Get uncleared EFT balance from GL
    SELECT 
        jh.JournalID,
        jh.JournalNumber,
        jh.JournalDate,
        jh.Reference,
        jh.Description,
        jh.BranchID,
        b.BranchName,
        jd.Debit AS EFTAmount,
        jd.Reference1,
        jd.Reference2,
        CASE 
            WHEN jh.JournalNumber LIKE 'POS-%' THEN 'POS Sale'
            WHEN jh.JournalNumber LIKE 'PAY-%' THEN 'AP Payment'
            WHEN jh.JournalNumber LIKE 'BP-%' THEN 'AP Batch Payment'
            ELSE 'Other'
        END AS TransactionType,
        DATEDIFF(DAY, jh.JournalDate, GETDATE()) AS DaysUncleared
    FROM JournalHeaders jh
    INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
    INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
    LEFT JOIN Branches b ON jh.BranchID = b.BranchID
    WHERE coa.AccountCode = '1050'  -- Debtors - Uncleared EFT
        AND jd.Debit > 0  -- Only debits (EFTs received)
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
        -- Exclude already cleared transactions
        AND NOT EXISTS (
            SELECT 1 
            FROM JournalHeaders jh2
            INNER JOIN JournalDetails jd2 ON jh2.JournalID = jd2.JournalID
            INNER JOIN ChartOfAccounts coa2 ON jd2.AccountID = coa2.AccountID
            WHERE coa2.AccountCode = '1050'
                AND jd2.Credit > 0  -- Credits clear the debit
                AND jd2.Reference2 = jh.Reference  -- Match by original reference
        )
    ORDER BY jh.JournalDate, jh.JournalNumber
END
GO

PRINT '✓ Created sp_EFT_GetUnclearedTransactions'
GO

-- =============================================
-- sp_EFT_GetClearingHistory
-- Get history of cleared EFT transactions
-- =============================================
CREATE PROCEDURE sp_EFT_GetClearingHistory
    @BranchID INT = NULL,
    @FromDate DATE = NULL,
    @ToDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON
    
    -- Get cleared EFT transactions
    SELECT 
        jh.JournalID,
        jh.JournalNumber,
        jh.JournalDate AS ClearingDate,
        jh.Reference AS ClearingReference,
        jh.Description,
        jh.BranchID,
        b.BranchName,
        jd.Credit AS ClearedAmount,
        jd.Reference1,
        jd.Reference2 AS OriginalReference
    FROM JournalHeaders jh
    INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
    INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
    LEFT JOIN Branches b ON jh.BranchID = b.BranchID
    WHERE coa.AccountCode = '1050'  -- Debtors - Uncleared EFT
        AND jd.Credit > 0  -- Credits = clearings
        AND (jh.JournalNumber LIKE 'EFTC-%' OR jh.JournalNumber LIKE 'EFTC-AP-%')
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
        AND (@FromDate IS NULL OR jh.JournalDate >= @FromDate)
        AND (@ToDate IS NULL OR jh.JournalDate <= @ToDate)
    ORDER BY jh.JournalDate DESC, jh.JournalNumber
END
GO

PRINT '✓ Created sp_EFT_GetClearingHistory'
GO

PRINT ''
PRINT '========================================='
PRINT 'PHASE 2.1 COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Created Procedures:'
PRINT '1. sp_AP_PostEFTClearingToGL - Clear AP EFT payments'
PRINT '2. sp_EFT_GetUnclearedTransactions - View pending EFTs'
PRINT '3. sp_EFT_GetClearingHistory - View cleared EFTs'
PRINT ''
PRINT 'Note: POS EFT clearing uses sp_POS_PostEFTClearingToGL (already created)'
PRINT ''
