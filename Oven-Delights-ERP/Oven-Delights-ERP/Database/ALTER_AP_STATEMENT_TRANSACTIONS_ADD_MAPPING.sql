-- =============================================
-- Add Mapping Columns to AP_StatementTransactions
-- Purpose: Enable ledger account mapping for bank statement transactions
-- =============================================

-- Add IsMapped column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[AP_StatementTransactions]') AND name = 'IsMapped')
BEGIN
    ALTER TABLE [dbo].[AP_StatementTransactions]
    ADD [IsMapped] [bit] NULL DEFAULT 0
    
    PRINT 'Column IsMapped added to AP_StatementTransactions'
END
ELSE
BEGIN
    PRINT 'Column IsMapped already exists in AP_StatementTransactions'
END
GO

-- Add MappedLedgerAccount column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[AP_StatementTransactions]') AND name = 'MappedLedgerAccount')
BEGIN
    ALTER TABLE [dbo].[AP_StatementTransactions]
    ADD [MappedLedgerAccount] [nvarchar](200) NULL
    
    PRINT 'Column MappedLedgerAccount added to AP_StatementTransactions'
END
ELSE
BEGIN
    PRINT 'Column MappedLedgerAccount already exists in AP_StatementTransactions'
END
GO

-- Add MappedDate column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[AP_StatementTransactions]') AND name = 'MappedDate')
BEGIN
    ALTER TABLE [dbo].[AP_StatementTransactions]
    ADD [MappedDate] [datetime] NULL
    
    PRINT 'Column MappedDate added to AP_StatementTransactions'
END
ELSE
BEGIN
    PRINT 'Column MappedDate already exists in AP_StatementTransactions'
END
GO

-- Add MappedBy column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[AP_StatementTransactions]') AND name = 'MappedBy')
BEGIN
    ALTER TABLE [dbo].[AP_StatementTransactions]
    ADD [MappedBy] [nvarchar](100) NULL
    
    PRINT 'Column MappedBy added to AP_StatementTransactions'
END
ELSE
BEGIN
    PRINT 'Column MappedBy already exists in AP_StatementTransactions'
END
GO

-- Create index for faster lookups on mapped transactions
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_AP_StatementTransactions_IsMapped' AND object_id = OBJECT_ID('AP_StatementTransactions'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_AP_StatementTransactions_IsMapped]
    ON [dbo].[AP_StatementTransactions] ([IsMapped])
    INCLUDE ([MappedLedgerAccount], [MappedDate])
    
    PRINT 'Index IX_AP_StatementTransactions_IsMapped created successfully'
END
ELSE
BEGIN
    PRINT 'Index IX_AP_StatementTransactions_IsMapped already exists'
END
GO

-- Update existing records to set IsMapped = 0 where NULL
UPDATE [dbo].[AP_StatementTransactions]
SET IsMapped = 0
WHERE IsMapped IS NULL
GO

PRINT 'AP_StatementTransactions table updated successfully with mapping columns'
GO

-- =============================================
-- Sample Queries
-- =============================================
/*
-- View all unmapped transactions
SELECT 
    TransactionID,
    TransactionDate,
    Amount,
    CreditDebitIndicator,
    Description,
    Reference,
    IsMapped,
    MappedLedgerAccount
FROM AP_StatementTransactions
WHERE IsMapped = 0 OR IsMapped IS NULL
ORDER BY TransactionDate DESC

-- View all mapped transactions
SELECT 
    TransactionID,
    TransactionDate,
    Amount,
    CreditDebitIndicator,
    Description,
    MappedLedgerAccount,
    MappedDate,
    MappedBy
FROM AP_StatementTransactions
WHERE IsMapped = 1
ORDER BY TransactionDate DESC

-- Count of mapped vs unmapped
SELECT 
    CASE WHEN IsMapped = 1 THEN 'Mapped' ELSE 'Unmapped' END AS Status,
    COUNT(*) AS Count,
    SUM(Amount) AS TotalAmount
FROM AP_StatementTransactions
GROUP BY IsMapped
*/
