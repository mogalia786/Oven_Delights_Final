-- =============================================
-- Create GLBatches table for batch tracking
-- =============================================

USE OvenDelightsERP
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GLBatches]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[GLBatches] (
        BatchID INT IDENTITY(1,1) PRIMARY KEY,
        BatchNumber NVARCHAR(50) UNIQUE NOT NULL,
        BatchDate DATE NOT NULL,
        Description NVARCHAR(500),
        TotalDebits DECIMAL(18,2) DEFAULT 0,
        TotalCredits DECIMAL(18,2) DEFAULT 0,
        Status NVARCHAR(50) DEFAULT 'Draft', -- 'Draft', 'Posted', 'Reversed'
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        PostedBy NVARCHAR(100),
        PostedDate DATETIME,
        ReversedBy NVARCHAR(100),
        ReversedDate DATETIME,
        Notes NVARCHAR(MAX)
    )
    
    PRINT 'GLBatches table created successfully'
END
ELSE
BEGIN
    PRINT 'GLBatches table already exists'
END
GO
