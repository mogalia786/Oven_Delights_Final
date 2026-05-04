-- Recreate ALL indexes on SupplierLedger and GeneralLedger with QUOTED_IDENTIFIER ON
SET QUOTED_IDENTIFIER ON;
GO

PRINT 'Recreating indexes on SupplierLedger...'

-- Drop and recreate indexes on SupplierLedger
DROP INDEX IF EXISTS IX_SupplierLedger_Supplier ON SupplierLedger;
DROP INDEX IF EXISTS IX_SupplierLedger_Date ON SupplierLedger;

CREATE INDEX IX_SupplierLedger_Supplier ON SupplierLedger(SupplierID);
CREATE INDEX IX_SupplierLedger_Date ON SupplierLedger(TransactionDate);
PRINT 'SupplierLedger indexes recreated'

PRINT 'Recreating indexes on GeneralLedger...'

-- Drop and recreate indexes on GeneralLedger  
DROP INDEX IF EXISTS IX_GeneralLedger_Account ON GeneralLedger;
DROP INDEX IF EXISTS IX_GeneralLedger_Date ON GeneralLedger;
DROP INDEX IF EXISTS IX_GeneralLedger_Reference ON GeneralLedger;
DROP INDEX IF EXISTS IX_GeneralLedger_JournalEntry ON GeneralLedger;

CREATE INDEX IX_GeneralLedger_Account ON GeneralLedger(AccountID);
CREATE INDEX IX_GeneralLedger_Date ON GeneralLedger(TransactionDate);
CREATE INDEX IX_GeneralLedger_Reference ON GeneralLedger(ReferenceID);
CREATE INDEX IX_GeneralLedger_JournalEntry ON GeneralLedger(JournalEntryNumber);
PRINT 'GeneralLedger indexes recreated'

PRINT ''
PRINT 'All indexes recreated with QUOTED_IDENTIFIER ON'
