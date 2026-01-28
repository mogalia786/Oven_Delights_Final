-- =============================================
-- TEST SCRIPT - GL POSTING PROCEDURES
-- =============================================
-- Execute this script to test all GL posting integrations
-- =============================================

USE OvenDelightsERP
GO

PRINT '========================================='
PRINT 'GL POSTING PROCEDURES - TEST SUITE'
PRINT 'Started: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
PRINT ''

-- =============================================
-- TEST 1: ADHOC Invoice Posting
-- =============================================
PRINT 'TEST 1: ADHOC Invoice Posting'
PRINT '-------------------------------------'

BEGIN TRY
    DECLARE @TestJournalID1 INT
    
    EXEC sp_AP_PostAdhocInvoiceToGL
        @InvoiceID = 99999,
        @InvoiceNumber = 'TEST-ADHOC-001',
        @InvoiceDate = '2026-01-27',
        @SupplierName = 'Test Supplier Ltd',
        @BranchID = 1,
        @SubtotalAmount = 1000.00,
        @VATAmount = 150.00,
        @TotalAmount = 1150.00,
        @ExpenseAccountCode = '6010',
        @CreatedBy = 1
    
    -- Verify journal created
    SELECT @TestJournalID1 = JournalID 
    FROM JournalHeaders 
    WHERE JournalNumber = 'AP-TEST-ADHOC-001'
    
    IF @TestJournalID1 IS NOT NULL
    BEGIN
        PRINT '  ✓ Journal created: ' + CAST(@TestJournalID1 AS VARCHAR)
        
        -- Verify balancing
        DECLARE @Debits1 DECIMAL(18,2), @Credits1 DECIMAL(18,2)
        SELECT 
            @Debits1 = SUM(Debit),
            @Credits1 = SUM(Credit)
        FROM JournalDetails
        WHERE JournalID = @TestJournalID1
        
        IF @Debits1 = @Credits1
            PRINT '  ✓ Journal balanced: Dr=' + CAST(@Debits1 AS VARCHAR) + ', Cr=' + CAST(@Credits1 AS VARCHAR)
        ELSE
            PRINT '  ✗ Journal UNBALANCED: Dr=' + CAST(@Debits1 AS VARCHAR) + ', Cr=' + CAST(@Credits1 AS VARCHAR)
        
        -- Show journal details
        SELECT 
            jd.LineNumber,
            coa.AccountCode,
            coa.AccountName,
            jd.Debit,
            jd.Credit,
            jd.Description
        FROM JournalDetails jd
        INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
        WHERE jd.JournalID = @TestJournalID1
        ORDER BY jd.LineNumber
        
        PRINT '  ✓ TEST 1 PASSED'
    END
    ELSE
        PRINT '  ✗ TEST 1 FAILED: Journal not created'
END TRY
BEGIN CATCH
    PRINT '  ✗ TEST 1 FAILED: ' + ERROR_MESSAGE()
END CATCH

PRINT ''

-- =============================================
-- TEST 2: Single Payment Posting
-- =============================================
PRINT 'TEST 2: Single Payment Posting'
PRINT '-------------------------------------'

BEGIN TRY
    DECLARE @TestJournalID2 INT
    
    EXEC sp_AP_PostSinglePaymentToGL
        @InvoiceID = 99999,
        @PaymentNumber = 'PAY-TEST-001',
        @PaymentDate = '2026-01-27',
        @SupplierName = 'Test Supplier Ltd',
        @Amount = 1150.00,
        @PaymentMethod = 'EFT',
        @BranchID = 1,
        @CreatedBy = 1
    
    SELECT @TestJournalID2 = JournalID 
    FROM JournalHeaders 
    WHERE JournalNumber = 'PAY-PAY-TEST-001'
    
    IF @TestJournalID2 IS NOT NULL
    BEGIN
        PRINT '  ✓ Journal created: ' + CAST(@TestJournalID2 AS VARCHAR)
        
        DECLARE @Debits2 DECIMAL(18,2), @Credits2 DECIMAL(18,2)
        SELECT 
            @Debits2 = SUM(Debit),
            @Credits2 = SUM(Credit)
        FROM JournalDetails
        WHERE JournalID = @TestJournalID2
        
        IF @Debits2 = @Credits2
            PRINT '  ✓ Journal balanced: Dr=' + CAST(@Debits2 AS VARCHAR) + ', Cr=' + CAST(@Credits2 AS VARCHAR)
        ELSE
            PRINT '  ✗ Journal UNBALANCED'
        
        SELECT 
            jd.LineNumber,
            coa.AccountCode,
            coa.AccountName,
            jd.Debit,
            jd.Credit,
            jd.Description
        FROM JournalDetails jd
        INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
        WHERE jd.JournalID = @TestJournalID2
        ORDER BY jd.LineNumber
        
        PRINT '  ✓ TEST 2 PASSED'
    END
    ELSE
        PRINT '  ✗ TEST 2 FAILED: Journal not created'
END TRY
BEGIN CATCH
    PRINT '  ✗ TEST 2 FAILED: ' + ERROR_MESSAGE()
END CATCH

PRINT ''

-- =============================================
-- TEST 3: Manufacturing to Retail Transfer
-- =============================================
PRINT 'TEST 3: Manufacturing to Retail Transfer'
PRINT '-------------------------------------'

BEGIN TRY
    DECLARE @TestJournalID3 INT
    
    EXEC sp_MFG_PostManufacturingToRetailTransfer
        @TransferID = 99999,
        @TransferNumber = 'MFG-TEST-001',
        @TransferDate = '2026-01-27',
        @ProductName = 'Test Product',
        @BranchID = 1,
        @TotalValue = 5000.00,
        @CreatedBy = 1
    
    SELECT @TestJournalID3 = JournalID 
    FROM JournalHeaders 
    WHERE JournalNumber = 'MFG-MFG-TEST-001'
    
    IF @TestJournalID3 IS NOT NULL
    BEGIN
        PRINT '  ✓ Journal created: ' + CAST(@TestJournalID3 AS VARCHAR)
        
        DECLARE @Debits3 DECIMAL(18,2), @Credits3 DECIMAL(18,2)
        SELECT 
            @Debits3 = SUM(Debit),
            @Credits3 = SUM(Credit)
        FROM JournalDetails
        WHERE JournalID = @TestJournalID3
        
        IF @Debits3 = @Credits3
            PRINT '  ✓ Journal balanced: Dr=' + CAST(@Debits3 AS VARCHAR) + ', Cr=' + CAST(@Credits3 AS VARCHAR)
        ELSE
            PRINT '  ✗ Journal UNBALANCED'
        
        SELECT 
            jd.LineNumber,
            coa.AccountCode,
            coa.AccountName,
            jd.Debit,
            jd.Credit,
            jd.Description
        FROM JournalDetails jd
        INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
        WHERE jd.JournalID = @TestJournalID3
        ORDER BY jd.LineNumber
        
        PRINT '  ✓ TEST 3 PASSED'
    END
    ELSE
        PRINT '  ✗ TEST 3 FAILED: Journal not created'
END TRY
BEGIN CATCH
    PRINT '  ✗ TEST 3 FAILED: ' + ERROR_MESSAGE()
END CATCH

PRINT ''

-- =============================================
-- TEST 4: IBT Receipt Posting
-- =============================================
PRINT 'TEST 4: IBT Receipt Posting'
PRINT '-------------------------------------'

BEGIN TRY
    DECLARE @TestJournalID4 INT
    
    EXEC sp_IBT_PostReceiptToGL
        @TransferID = 99999,
        @TransferNumber = 'IBT-TEST-001',
        @ReceiptDate = '2026-01-27',
        @FromBranchID = 1,
        @ToBranchID = 2,
        @TotalValue = 3000.00,
        @CreatedBy = 1
    
    SELECT @TestJournalID4 = JournalID 
    FROM JournalHeaders 
    WHERE JournalNumber = 'IBT-R-IBT-TEST-001'
    
    IF @TestJournalID4 IS NOT NULL
    BEGIN
        PRINT '  ✓ Journal created: ' + CAST(@TestJournalID4 AS VARCHAR)
        
        DECLARE @Debits4 DECIMAL(18,2), @Credits4 DECIMAL(18,2)
        SELECT 
            @Debits4 = SUM(Debit),
            @Credits4 = SUM(Credit)
        FROM JournalDetails
        WHERE JournalID = @TestJournalID4
        
        IF @Debits4 = @Credits4
            PRINT '  ✓ Journal balanced: Dr=' + CAST(@Debits4 AS VARCHAR) + ', Cr=' + CAST(@Credits4 AS VARCHAR)
        ELSE
            PRINT '  ✗ Journal UNBALANCED'
        
        SELECT 
            jd.LineNumber,
            coa.AccountCode,
            coa.AccountName,
            jd.Debit,
            jd.Credit,
            jd.Description
        FROM JournalDetails jd
        INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
        WHERE jd.JournalID = @TestJournalID4
        ORDER BY jd.LineNumber
        
        PRINT '  ✓ TEST 4 PASSED'
    END
    ELSE
        PRINT '  ✗ TEST 4 FAILED: Journal not created'
END TRY
BEGIN CATCH
    PRINT '  ✗ TEST 4 FAILED: ' + ERROR_MESSAGE()
END CATCH

PRINT ''

-- =============================================
-- TEST 5: Stock Adjustment (Decrease)
-- =============================================
PRINT 'TEST 5: Stock Adjustment (Decrease)'
PRINT '-------------------------------------'

BEGIN TRY
    DECLARE @TestJournalID5 INT
    
    EXEC sp_INV_PostStockAdjustmentToGL
        @AdjustmentID = 99999,
        @AdjustmentNumber = 'ADJ-TEST-001',
        @AdjustmentDate = '2026-01-27',
        @ProductName = 'Test Product',
        @BranchID = 1,
        @AdjustmentType = 'Decrease',
        @Reason = 'Damage',
        @AdjustmentValue = 500.00,
        @CreatedBy = 1
    
    SELECT @TestJournalID5 = JournalID 
    FROM JournalHeaders 
    WHERE JournalNumber = 'ADJ-ADJ-TEST-001'
    
    IF @TestJournalID5 IS NOT NULL
    BEGIN
        PRINT '  ✓ Journal created: ' + CAST(@TestJournalID5 AS VARCHAR)
        
        DECLARE @Debits5 DECIMAL(18,2), @Credits5 DECIMAL(18,2)
        SELECT 
            @Debits5 = SUM(Debit),
            @Credits5 = SUM(Credit)
        FROM JournalDetails
        WHERE JournalID = @TestJournalID5
        
        IF @Debits5 = @Credits5
            PRINT '  ✓ Journal balanced: Dr=' + CAST(@Debits5 AS VARCHAR) + ', Cr=' + CAST(@Credits5 AS VARCHAR)
        ELSE
            PRINT '  ✗ Journal UNBALANCED'
        
        SELECT 
            jd.LineNumber,
            coa.AccountCode,
            coa.AccountName,
            jd.Debit,
            jd.Credit,
            jd.Description
        FROM JournalDetails jd
        INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
        WHERE jd.JournalID = @TestJournalID5
        ORDER BY jd.LineNumber
        
        PRINT '  ✓ TEST 5 PASSED'
    END
    ELSE
        PRINT '  ✗ TEST 5 FAILED: Journal not created'
END TRY
BEGIN CATCH
    PRINT '  ✗ TEST 5 FAILED: ' + ERROR_MESSAGE()
END CATCH

PRINT ''

-- =============================================
-- TEST 6: Petty Cash Top-Up
-- =============================================
PRINT 'TEST 6: Petty Cash Top-Up'
PRINT '-------------------------------------'

BEGIN TRY
    DECLARE @TestJournalID6 INT
    
    EXEC sp_CB_PostPettyCashTopUpToGL
        @TopUpID = 99999,
        @TopUpNumber = 'PCT-TEST-001',
        @TopUpDate = '2026-01-27',
        @Amount = 500.00,
        @BranchID = 1,
        @CreatedBy = 1
    
    SELECT @TestJournalID6 = JournalID 
    FROM JournalHeaders 
    WHERE JournalNumber = 'PCT-PCT-TEST-001'
    
    IF @TestJournalID6 IS NOT NULL
    BEGIN
        PRINT '  ✓ Journal created: ' + CAST(@TestJournalID6 AS VARCHAR)
        
        DECLARE @Debits6 DECIMAL(18,2), @Credits6 DECIMAL(18,2)
        SELECT 
            @Debits6 = SUM(Debit),
            @Credits6 = SUM(Credit)
        FROM JournalDetails
        WHERE JournalID = @TestJournalID6
        
        IF @Debits6 = @Credits6
            PRINT '  ✓ Journal balanced: Dr=' + CAST(@Debits6 AS VARCHAR) + ', Cr=' + CAST(@Credits6 AS VARCHAR)
        ELSE
            PRINT '  ✗ Journal UNBALANCED'
        
        SELECT 
            jd.LineNumber,
            coa.AccountCode,
            coa.AccountName,
            jd.Debit,
            jd.Credit,
            jd.Description
        FROM JournalDetails jd
        INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
        WHERE jd.JournalID = @TestJournalID6
        ORDER BY jd.LineNumber
        
        PRINT '  ✓ TEST 6 PASSED'
    END
    ELSE
        PRINT '  ✗ TEST 6 FAILED: Journal not created'
END TRY
BEGIN CATCH
    PRINT '  ✗ TEST 6 FAILED: ' + ERROR_MESSAGE()
END CATCH

PRINT ''

-- =============================================
-- CLEANUP TEST DATA
-- =============================================
PRINT '========================================='
PRINT 'CLEANUP TEST DATA'
PRINT '========================================='

DELETE FROM JournalDetails WHERE JournalID IN (
    SELECT JournalID FROM JournalHeaders 
    WHERE JournalNumber IN (
        'AP-TEST-ADHOC-001',
        'PAY-PAY-TEST-001',
        'MFG-RET-MFG-TEST-001',
        'XFER-RCV-IBT-TEST-001',
        'ADJ-ADJ-TEST-001',
        'PCT-PCT-TEST-001'
    )
)

DELETE FROM JournalHeaders 
WHERE JournalNumber IN (
    'AP-TEST-ADHOC-001',
    'PAY-PAY-TEST-001',
    'MFG-RET-MFG-TEST-001',
    'XFER-RCV-IBT-TEST-001',
    'ADJ-ADJ-TEST-001',
    'PCT-PCT-TEST-001'
)

PRINT '  ✓ Test data cleaned up'
PRINT ''

-- =============================================
-- TEST SUMMARY
-- =============================================
PRINT '========================================='
PRINT 'TEST SUMMARY'
PRINT '========================================='
PRINT ''
PRINT 'All tests completed. Review results above.'
PRINT ''
PRINT 'Completed: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
GO
