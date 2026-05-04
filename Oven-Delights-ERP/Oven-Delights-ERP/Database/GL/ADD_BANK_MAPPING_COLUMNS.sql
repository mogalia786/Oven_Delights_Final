-- =============================================
-- Add Missing Columns to AP_StatementTransactions
-- =============================================
-- This script adds IsMapped and MappedLedgerAccount columns
-- needed for bank statement auto-mapping functionality
-- =============================================

USE OvenDelightsERP
GO

PRINT '=========================================='
PRINT 'Adding Bank Statement Mapping Columns'
PRINT '=========================================='

-- Add IsMapped column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'AP_StatementTransactions') AND name = 'IsMapped')
BEGIN
    ALTER TABLE AP_StatementTransactions
    ADD IsMapped BIT DEFAULT 0
    
    PRINT '✓ Added IsMapped column to AP_StatementTransactions'
END
ELSE
    PRINT '✓ IsMapped column already exists'

-- Add MappedLedgerAccount column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'AP_StatementTransactions') AND name = 'MappedLedgerAccount')
BEGIN
    ALTER TABLE AP_StatementTransactions
    ADD MappedLedgerAccount NVARCHAR(20) NULL
    
    PRINT '✓ Added MappedLedgerAccount column to AP_StatementTransactions'
END
ELSE
    PRINT '✓ MappedLedgerAccount column already exists'

-- Update existing records to set IsMapped based on MappedCategoryID
UPDATE AP_StatementTransactions
SET IsMapped = 1
WHERE MappedCategoryID IS NOT NULL
    AND (IsMapped IS NULL OR IsMapped = 0)

PRINT '✓ Updated existing records with IsMapped flag'

-- Create index for IsMapped if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_AP_StatementTransactions_IsMapped')
BEGIN
    CREATE INDEX IX_AP_StatementTransactions_IsMapped 
    ON AP_StatementTransactions(IsMapped)
    INCLUDE (TransactionID, TransactionDate, Amount, CreditDebitIndicator)
    
    PRINT '✓ Created index IX_AP_StatementTransactions_IsMapped'
END
ELSE
    PRINT '✓ Index IX_AP_StatementTransactions_IsMapped already exists'

PRINT '=========================================='
PRINT 'Bank Statement Mapping Columns Complete'
PRINT '=========================================='
GO
