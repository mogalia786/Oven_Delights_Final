-- Additional tables for AI Background Testing Service

-- AI Testing Log for background activity tracking
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AITestingLog')
BEGIN
    CREATE TABLE dbo.AITestingLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        Timestamp DATETIME2 DEFAULT GETDATE(),
        Message NVARCHAR(MAX) NOT NULL,
        LogType NVARCHAR(50) DEFAULT 'Background',
        Severity NVARCHAR(20) DEFAULT 'Info'
    );
END

-- Critical Issues table for high-priority problems
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CriticalIssues')
BEGIN
    CREATE TABLE dbo.CriticalIssues (
        IssueID INT IDENTITY(1,1) PRIMARY KEY,
        Timestamp DATETIME2 DEFAULT GETDATE(),
        Module NVARCHAR(100) NOT NULL,
        Feature NVARCHAR(100) NOT NULL,
        Message NVARCHAR(MAX) NOT NULL,
        Priority NVARCHAR(20) DEFAULT 'High',
        Status NVARCHAR(20) DEFAULT 'Open',
        ResolvedBy NVARCHAR(100) NULL,
        ResolvedDate DATETIME2 NULL,
        Resolution NVARCHAR(MAX) NULL
    );
END

-- Auto-Fix History table to track automated repairs
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AutoFixHistory')
BEGIN
    CREATE TABLE dbo.AutoFixHistory (
        FixID INT IDENTITY(1,1) PRIMARY KEY,
        Timestamp DATETIME2 DEFAULT GETDATE(),
        FormName NVARCHAR(100) NOT NULL,
        IssueType NVARCHAR(100) NOT NULL,
        FixApplied NVARCHAR(MAX) NOT NULL,
        Success BIT DEFAULT 1,
        ErrorMessage NVARCHAR(MAX) NULL
    );
END

-- Background Service Status table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BackgroundServiceStatus')
BEGIN
    CREATE TABLE dbo.BackgroundServiceStatus (
        ServiceID INT IDENTITY(1,1) PRIMARY KEY,
        ServiceName NVARCHAR(100) NOT NULL,
        LastRun DATETIME2 NULL,
        NextRun DATETIME2 NULL,
        Status NVARCHAR(20) DEFAULT 'Stopped',
        RunCount INT DEFAULT 0,
        ErrorCount INT DEFAULT 0,
        LastError NVARCHAR(MAX) NULL
    );
END

-- Insert initial service status
INSERT INTO dbo.BackgroundServiceStatus (ServiceName, Status, NextRun) 
VALUES ('AI Testing Background Service', 'Ready', DATEADD(MINUTE, 30, GETDATE()));

-- Create indexes for performance (with IF NOT EXISTS checks)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_AITestingLog_Timestamp' AND object_id = OBJECT_ID('dbo.AITestingLog'))
    CREATE NONCLUSTERED INDEX IX_AITestingLog_Timestamp ON dbo.AITestingLog(Timestamp);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CriticalIssues_Status' AND object_id = OBJECT_ID('dbo.CriticalIssues'))
    CREATE NONCLUSTERED INDEX IX_CriticalIssues_Status ON dbo.CriticalIssues(Status);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CriticalIssues_Priority' AND object_id = OBJECT_ID('dbo.CriticalIssues'))
    CREATE NONCLUSTERED INDEX IX_CriticalIssues_Priority ON dbo.CriticalIssues(Priority);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_AutoFixHistory_Timestamp' AND object_id = OBJECT_ID('dbo.AutoFixHistory'))
    CREATE NONCLUSTERED INDEX IX_AutoFixHistory_Timestamp ON dbo.AutoFixHistory(Timestamp);

PRINT 'AI Background Testing tables created successfully';
