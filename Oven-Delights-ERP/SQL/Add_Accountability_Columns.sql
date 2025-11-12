-- =============================================
-- ADD ACCOUNTABILITY COLUMNS TO STOCKMOVEMENTS
-- Full tracking: Who requested, approved, received
-- =============================================

-- Add accountability columns if they don't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StockMovements' AND COLUMN_NAME = 'RequestedBy')
    ALTER TABLE StockMovements ADD RequestedBy NVARCHAR(100) NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StockMovements' AND COLUMN_NAME = 'RequestedDate')
    ALTER TABLE StockMovements ADD RequestedDate DATETIME NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StockMovements' AND COLUMN_NAME = 'ApprovedBy')
    ALTER TABLE StockMovements ADD ApprovedBy NVARCHAR(100) NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StockMovements' AND COLUMN_NAME = 'ApprovedDate')
    ALTER TABLE StockMovements ADD ApprovedDate DATETIME NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StockMovements' AND COLUMN_NAME = 'ReceivedBy')
    ALTER TABLE StockMovements ADD ReceivedBy NVARCHAR(100) NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StockMovements' AND COLUMN_NAME = 'ReceivedDate')
    ALTER TABLE StockMovements ADD ReceivedDate DATETIME NULL;

-- Add FromLocation and ToLocation for better tracking
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StockMovements' AND COLUMN_NAME = 'FromLocation')
    ALTER TABLE StockMovements ADD FromLocation NVARCHAR(50) NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'StockMovements' AND COLUMN_NAME = 'ToLocation')
    ALTER TABLE StockMovements ADD ToLocation NVARCHAR(50) NULL;

PRINT '✅ Accountability columns added to StockMovements';

-- Create index for performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_StockMovements_RequestedBy')
    CREATE INDEX IX_StockMovements_RequestedBy ON StockMovements(RequestedBy);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_StockMovements_ReceivedBy')
    CREATE INDEX IX_StockMovements_ReceivedBy ON StockMovements(ReceivedBy);

PRINT '✅ Indexes created';
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ STOCKMOVEMENTS TABLE ENHANCED!';
PRINT '   Added: RequestedBy, RequestedDate';
PRINT '   Added: ApprovedBy, ApprovedDate';
PRINT '   Added: ReceivedBy, ReceivedDate';
PRINT '   Added: FromLocation, ToLocation';
PRINT '═══════════════════════════════════════════════';
