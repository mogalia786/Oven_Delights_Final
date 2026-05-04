-- =============================================
-- Update All Beneficiary Bank Details to FNB Test Accounts
-- This script updates all beneficiaries to use FNB test bank details
-- for testing the FNB Payment Execution API
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'Updating Beneficiary Bank Details';
PRINT 'Setting all to FNB Test Accounts';
PRINT '========================================';
PRINT '';

-- Backup current bank details (optional - comment out if not needed)
IF OBJECT_ID('tempdb..#BeneficiaryBankBackup') IS NOT NULL
    DROP TABLE #BeneficiaryBankBackup;

SELECT 
    BeneficiaryID,
    BeneficiaryName,
    BankName,
    BranchCode,
    AccountNumber,
    AccountType
INTO #BeneficiaryBankBackup
FROM AP_Beneficiaries;

PRINT 'Backed up current bank details to temp table';
PRINT '';

-- Update all beneficiaries to FNB test RECIPIENT accounts
-- IMPORTANT: These must be DIFFERENT from our company accounts (63001723469, 63001731248)
-- Using FNB-provided test recipient accounts
UPDATE AP_Beneficiaries
SET 
    BankName = 'First National Bank',
    BranchCode = '250655',  -- FNB Universal Branch Code
    AccountNumber = CASE 
        -- Distribute beneficiaries across FNB test RECIPIENT accounts
        WHEN BeneficiaryID % 2 = 0 THEN '63001730117'  -- Test Recipient Account 1 (Durban Electricity)
        ELSE '63001731222'                              -- Test Recipient Account 2 (Other Beneficiaries)
    END,
    AccountType = 'CACC',  -- Current Account (CACC) or Savings Account (SVGS)
    ModifiedDate = GETDATE();

PRINT 'Updated all beneficiaries to FNB test accounts';
PRINT '';

-- Display summary of changes
PRINT '========================================';
PRINT 'SUMMARY OF CHANGES';
PRINT '========================================';
PRINT '';

SELECT 
    COUNT(*) AS TotalBeneficiaries,
    COUNT(DISTINCT AccountNumber) AS UniqueTestAccounts
FROM AP_Beneficiaries;

PRINT '';
PRINT 'Beneficiaries by Test Account:';
SELECT 
    AccountNumber,
    COUNT(*) AS BeneficiaryCount,
    STRING_AGG(BeneficiaryName, ', ') AS Beneficiaries
FROM AP_Beneficiaries
GROUP BY AccountNumber
ORDER BY AccountNumber;

PRINT '';
PRINT '========================================';
PRINT 'FNB Test Account Details';
PRINT '========================================';
PRINT 'Bank Name: First National Bank';
PRINT 'Branch Code: 250655 (FNB Universal Branch Code)';
PRINT 'Account Type: CACC (Current Account)';
PRINT '';
PRINT 'OUR COMPANY ACCOUNTS (Debtor - Paying Out):';
PRINT '  - 63001723469 (Primary)';
PRINT '  - 63001731248 (Secondary)';
PRINT '';
PRINT 'BENEFICIARY ACCOUNTS (Creditor - Receiving Payment):';
PRINT '  - 63001730117 (Durban Electricity)';
PRINT '  - 63001731222 (Other Beneficiaries)';
PRINT '';
PRINT '========================================';
PRINT 'IMPORTANT NOTES';
PRINT '========================================';
PRINT '1. These are FNB SANDBOX test accounts';
PRINT '2. Use these ONLY for testing the API';
PRINT '3. DO NOT use in production environment';
PRINT '4. Beneficiaries use DIFFERENT accounts than our company';
PRINT '5. This prevents paying ourselves (which would fail)';
PRINT '6. Backup table created: #BeneficiaryBankBackup';
PRINT '7. To restore original data, run the restore script';
PRINT '';

-- Optional: Create restore script
PRINT '========================================';
PRINT 'To restore original bank details, run:';
PRINT '========================================';
PRINT '';
PRINT 'UPDATE b';
PRINT 'SET ';
PRINT '    b.BankName = bk.BankName,';
PRINT '    b.BranchCode = bk.BranchCode,';
PRINT '    b.AccountNumber = bk.AccountNumber,';
PRINT '    b.AccountType = bk.AccountType,';
PRINT '    b.ModifiedDate = GETDATE()';
PRINT 'FROM AP_Beneficiaries b';
PRINT 'INNER JOIN #BeneficiaryBankBackup bk ON b.BeneficiaryID = bk.BeneficiaryID';
PRINT '';

-- Display updated beneficiaries
PRINT '========================================';
PRINT 'Updated Beneficiary Details';
PRINT '========================================';
PRINT '';

SELECT 
    BeneficiaryID,
    BeneficiaryName,
    BankName,
    BranchCode,
    AccountNumber,
    AccountType
FROM AP_Beneficiaries
ORDER BY BeneficiaryID;

PRINT '';
PRINT 'Script completed successfully!';
GO
