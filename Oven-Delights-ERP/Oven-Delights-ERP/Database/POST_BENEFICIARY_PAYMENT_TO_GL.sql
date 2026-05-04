-- =============================================
-- Post Beneficiary Payment to General Ledger (Manual Testing)
-- =============================================

DECLARE @PaymentID INT
DECLARE @Amount DECIMAL(18,2)
DECLARE @PaymentDate DATE
DECLARE @Description NVARCHAR(500)
DECLARE @Category NVARCHAR(100)
DECLARE @PaymentReference NVARCHAR(50)
DECLARE @ExpenseAccountID INT
DECLARE @BankAccountID INT = 1 -- Default bank account

-- Get the most recent pending beneficiary payment
SELECT TOP 1
    @PaymentID = PaymentID,
    @Amount = Amount,
    @PaymentDate = PaymentDate,
    @Description = Description,
    @Category = Category,
    @PaymentReference = PaymentReference,
    @ExpenseAccountID = ExpenseAccountID
FROM BeneficiaryPayments
WHERE Status IN ('Pending', 'Approved')
ORDER BY PaymentID DESC

IF @PaymentID IS NULL
BEGIN
    PRINT '❌ No pending beneficiary payments found'
    RETURN
END

PRINT '=============================================='
PRINT 'Posting Beneficiary Payment to General Ledger'
PRINT '=============================================='
PRINT ''
PRINT 'Payment Details:'
PRINT '  Payment ID: ' + CAST(@PaymentID AS VARCHAR)
PRINT '  Reference: ' + @PaymentReference
PRINT '  Amount: R ' + CAST(@Amount AS VARCHAR)
PRINT '  Date: ' + CONVERT(VARCHAR, @PaymentDate, 106)
PRINT '  Category: ' + @Category
PRINT '  Description: ' + @Description
PRINT ''

-- Get or determine expense account
IF @ExpenseAccountID IS NULL
BEGIN
    -- Default to Operating Expenses account (5000)
    SELECT @ExpenseAccountID = AccountID 
    FROM ChartOfAccounts 
    WHERE AccountCode = '5000'
    
    IF @ExpenseAccountID IS NULL
    BEGIN
        PRINT '⚠ WARNING: No expense account found. Using first expense account.'
        SELECT TOP 1 @ExpenseAccountID = AccountID
        FROM ChartOfAccounts
        WHERE AccountCode LIKE '5%'
        ORDER BY AccountCode
    END
END

-- Get bank account GL account ID
DECLARE @BankGLAccountID INT
SELECT @BankGLAccountID = GLAccountID
FROM BankAccounts
WHERE BankAccountID = @BankAccountID

IF @BankGLAccountID IS NULL
BEGIN
    -- Default to Bank account (1120)
    SELECT @BankGLAccountID = AccountID
    FROM ChartOfAccounts
    WHERE AccountCode = '1120'
END

PRINT 'GL Accounts:'
PRINT '  Expense Account ID: ' + CAST(@ExpenseAccountID AS VARCHAR)
PRINT '  Bank Account ID: ' + CAST(@BankGLAccountID AS VARCHAR)
PRINT ''

-- Generate journal entry number
DECLARE @JournalEntryNumber NVARCHAR(50)
SET @JournalEntryNumber = 'JE-' + FORMAT(GETDATE(), 'yyyyMMdd') + '-' + RIGHT('0000' + CAST(@PaymentID AS VARCHAR), 4)

BEGIN TRANSACTION

BEGIN TRY
    -- Debit Expense Account
    INSERT INTO GeneralLedger (
        TransactionDate,
        AccountID,
        DebitAmount,
        CreditAmount,
        Description,
        ReferenceType,
        ReferenceID,
        JournalEntryNumber,
        CreatedBy,
        CreatedDate,
        IsReversed
    )
    VALUES (
        @PaymentDate,
        @ExpenseAccountID,
        @Amount,
        0,
        @Description + ' - ' + @PaymentReference,
        'BeneficiaryPayment',
        @PaymentID,
        @JournalEntryNumber,
        'SYSTEM',
        GETDATE(),
        0
    )
    
    PRINT '✓ Debit posted to Expense Account'
    
    -- Credit Bank Account
    INSERT INTO GeneralLedger (
        TransactionDate,
        AccountID,
        DebitAmount,
        CreditAmount,
        Description,
        ReferenceType,
        ReferenceID,
        JournalEntryNumber,
        CreatedBy,
        CreatedDate,
        IsReversed
    )
    VALUES (
        @PaymentDate,
        @BankGLAccountID,
        0,
        @Amount,
        @Description + ' - ' + @PaymentReference,
        'BeneficiaryPayment',
        @PaymentID,
        @JournalEntryNumber,
        'SYSTEM',
        GETDATE(),
        0
    )
    
    PRINT '✓ Credit posted to Bank Account'
    
    -- Update payment status to Paid
    UPDATE BeneficiaryPayments
    SET Status = 'Paid',
        PaidDate = GETDATE()
    WHERE PaymentID = @PaymentID
    
    PRINT '✓ Payment status updated to Paid'
    
    COMMIT TRANSACTION
    
    PRINT ''
    PRINT '=============================================='
    PRINT '✓ SUCCESS: Payment posted to General Ledger'
    PRINT '=============================================='
    PRINT ''
    PRINT 'Journal Entry: ' + @JournalEntryNumber
    PRINT ''
    PRINT 'You can now view this transaction in:'
    PRINT '  - Accounting > View Transaction Log (General Ledger Viewer)'
    PRINT '  - Financial Dashboard (expenses will now be 0 since payment is marked as Paid)'
    
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    
    PRINT ''
    PRINT '=============================================='
    PRINT '❌ ERROR: Failed to post payment'
    PRINT '=============================================='
    PRINT 'Error: ' + ERROR_MESSAGE()
END CATCH
GO
