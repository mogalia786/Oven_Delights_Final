-- AI Testing Framework Database Schema
-- Creates tables to support automated testing and reporting

-- Test Sessions table to track testing runs
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TestSessions')
BEGIN
    CREATE TABLE dbo.TestSessions (
        SessionID NVARCHAR(50) PRIMARY KEY,
        StartTime DATETIME2 NOT NULL,
        EndTime DATETIME2 NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Running',
        TotalTests INT NULL,
        PassedTests INT NULL,
        FailedTests INT NULL,
        CreatedBy NVARCHAR(100) DEFAULT 'AI Testing Service',
        Notes NVARCHAR(MAX) NULL
    );
END

-- Test Results table for individual test outcomes
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TestResults')
BEGIN
    CREATE TABLE dbo.TestResults (
        ResultID INT IDENTITY(1,1) PRIMARY KEY,
        SessionID NVARCHAR(50) NOT NULL,
        Module NVARCHAR(100) NOT NULL,
        Feature NVARCHAR(100) NOT NULL,
        FormName NVARCHAR(100) NULL,
        TestType NVARCHAR(50) NOT NULL,
        Success BIT NOT NULL,
        Message NVARCHAR(MAX) NULL,
        Duration FLOAT NULL, -- milliseconds
        Warnings NVARCHAR(MAX) NULL,
        Timestamp DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (SessionID) REFERENCES TestSessions(SessionID)
    );
END

-- Test Errors table for detailed error tracking
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TestErrors')
BEGIN
    CREATE TABLE dbo.TestErrors (
        ErrorID INT IDENTITY(1,1) PRIMARY KEY,
        SessionID NVARCHAR(50) NOT NULL,
        Module NVARCHAR(100) NOT NULL,
        ErrorMessage NVARCHAR(MAX) NOT NULL,
        StackTrace NVARCHAR(MAX) NULL,
        Timestamp DATETIME2 DEFAULT GETDATE(),
        Resolved BIT DEFAULT 0,
        Resolution NVARCHAR(MAX) NULL,
        FOREIGN KEY (SessionID) REFERENCES TestSessions(SessionID)
    );
END

-- Test Coverage table to track which features have been tested
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TestCoverage')
BEGIN
    CREATE TABLE dbo.TestCoverage (
        CoverageID INT IDENTITY(1,1) PRIMARY KEY,
        Module NVARCHAR(100) NOT NULL,
        Feature NVARCHAR(100) NOT NULL,
        FormName NVARCHAR(100) NULL,
        LastTested DATETIME2 NULL,
        TestCount INT DEFAULT 0,
        LastResult BIT NULL,
        Priority NVARCHAR(20) DEFAULT 'Medium', -- High, Medium, Low
        IsActive BIT DEFAULT 1
    );
END

-- Performance Metrics table for tracking system performance
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PerformanceMetrics')
BEGIN
    CREATE TABLE dbo.PerformanceMetrics (
        MetricID INT IDENTITY(1,1) PRIMARY KEY,
        SessionID NVARCHAR(50) NOT NULL,
        Module NVARCHAR(100) NOT NULL,
        Feature NVARCHAR(100) NOT NULL,
        MetricType NVARCHAR(50) NOT NULL, -- LoadTime, MemoryUsage, QueryTime
        Value FLOAT NOT NULL,
        Unit NVARCHAR(20) NOT NULL, -- ms, MB, seconds
        Timestamp DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (SessionID) REFERENCES TestSessions(SessionID)
    );
END

-- Create indexes for better query performance (with IF NOT EXISTS checks)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TestResults_SessionID' AND object_id = OBJECT_ID('dbo.TestResults'))
    CREATE NONCLUSTERED INDEX IX_TestResults_SessionID ON dbo.TestResults(SessionID);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TestResults_Module' AND object_id = OBJECT_ID('dbo.TestResults'))
    CREATE NONCLUSTERED INDEX IX_TestResults_Module ON dbo.TestResults(Module);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TestResults_Success' AND object_id = OBJECT_ID('dbo.TestResults'))
    CREATE NONCLUSTERED INDEX IX_TestResults_Success ON dbo.TestResults(Success);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TestErrors_SessionID' AND object_id = OBJECT_ID('dbo.TestErrors'))
    CREATE NONCLUSTERED INDEX IX_TestErrors_SessionID ON dbo.TestErrors(SessionID);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TestErrors_Module' AND object_id = OBJECT_ID('dbo.TestErrors'))
    CREATE NONCLUSTERED INDEX IX_TestErrors_Module ON dbo.TestErrors(Module);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TestCoverage_Module' AND object_id = OBJECT_ID('dbo.TestCoverage'))
    CREATE NONCLUSTERED INDEX IX_TestCoverage_Module ON dbo.TestCoverage(Module);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PerformanceMetrics_SessionID' AND object_id = OBJECT_ID('dbo.PerformanceMetrics'))
    CREATE NONCLUSTERED INDEX IX_PerformanceMetrics_SessionID ON dbo.PerformanceMetrics(SessionID);

-- Insert initial test coverage data for all known modules
INSERT INTO dbo.TestCoverage (Module, Feature, FormName, Priority) VALUES
-- Administration Module
('Administration', 'User Management', 'UserManagementForm', 'High'),
('Administration', 'Branch Management', 'BranchManagementForm', 'High'),
('Administration', 'Audit Log', 'AuditLogViewer', 'Medium'),
('Administration', 'Role Access Control', 'RoleAccessControlForm', 'High'),
('Administration', 'System Settings', 'SystemSettingsForm', 'Medium'),

-- Accounting Module
('Accounting', 'General Ledger', 'GeneralLedgerForm', 'High'),
('Accounting', 'Accounts Payable', 'AccountsPayableForm', 'High'),
('Accounting', 'Accounts Receivable', 'AccountsReceivableForm', 'High'),
('Accounting', 'Bank Statement Import', 'BankStatementImportForm', 'Medium'),
('Accounting', 'SARS Compliance', 'SARSReportingForm', 'High'),

-- Manufacturing Module
('Manufacturing', 'Build Product', 'BuildProductForm', 'High'),
('Manufacturing', 'Dashboard', 'ManufacturingDashboardForm', 'Medium'),
('Manufacturing', 'BOM Management', 'BOMManagementForm', 'High'),

-- Retail Module
('Retail', 'Main Dashboard', 'RetailMainForm', 'High'),
('Retail', 'Stock on Hand', 'RetailStockOnHandForm', 'High'),
('Retail', 'Point of Sale', 'POSForm', 'High'),

-- Inventory Module
('Inventory', 'Catalog Management', 'InventoryCatalogCrudForm', 'Medium'),
('Inventory', 'Stock Management', 'StockManagementForm', 'High'),

-- Reports Module
('Reports', 'Financial Reports', NULL, 'High'),
('Reports', 'Inventory Reports', NULL, 'Medium'),
('Reports', 'Manufacturing Reports', NULL, 'Medium');

PRINT 'AI Testing Framework schema created successfully';
