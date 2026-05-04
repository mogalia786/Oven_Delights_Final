-- =============================================
-- Helper Function: Get Current Fiscal Period ID
-- =============================================
-- Returns the FiscalPeriodID for a given date
-- If no fiscal period exists, returns 1 (default)
-- =============================================

-- First, check if FiscalPeriods table exists
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FiscalPeriods')
BEGIN
    PRINT 'FiscalPeriods table does not exist. Creating default fiscal period...'
    
    -- Create FiscalPeriods table if it doesn't exist
    CREATE TABLE FiscalPeriods (
        PeriodID INT IDENTITY(1,1) PRIMARY KEY,
        PeriodName NVARCHAR(50) NOT NULL,
        StartDate DATE NOT NULL,
        EndDate DATE NOT NULL,
        IsClosed BIT DEFAULT 0
    )
    
    -- Insert default fiscal period for current year (March to February)
    DECLARE @CurrentYear INT = YEAR(GETDATE())
    DECLARE @CurrentMonth INT = MONTH(GETDATE())
    DECLARE @FiscalYear INT
    
    -- If we're in Jan or Feb, fiscal year started last March
    IF @CurrentMonth <= 2
        SET @FiscalYear = @CurrentYear - 1
    ELSE
        SET @FiscalYear = @CurrentYear
    
    DECLARE @StartDate DATE = CAST(CAST(@FiscalYear AS NVARCHAR(4)) + '-03-01' AS DATE)
    DECLARE @EndDate DATE = CAST(CAST(@FiscalYear + 1 AS NVARCHAR(4)) + '-02-28' AS DATE)
    
    INSERT INTO FiscalPeriods (PeriodName, StartDate, EndDate, IsClosed)
    VALUES 
        ('FY ' + CAST(@FiscalYear AS NVARCHAR(4)) + '/' + CAST(@FiscalYear + 1 AS NVARCHAR(4)), 
         @StartDate, 
         @EndDate, 
         0)
    
    PRINT 'Default fiscal period created: ' + CAST(@StartDate AS NVARCHAR(10)) + ' to ' + CAST(@EndDate AS NVARCHAR(10))
END
GO

-- Create or alter function to get current fiscal period
CREATE OR ALTER FUNCTION dbo.fn_GetCurrentFiscalPeriodID(@TransactionDate DATE)
RETURNS INT
AS
BEGIN
    DECLARE @PeriodID INT
    
    -- Try to find fiscal period for the given date
    SELECT TOP 1 @PeriodID = PeriodID
    FROM FiscalPeriods
    WHERE @TransactionDate BETWEEN StartDate AND EndDate
    AND IsClosed = 0
    ORDER BY StartDate DESC
    
    -- If no period found, get the first available period
    IF @PeriodID IS NULL
    BEGIN
        SELECT TOP 1 @PeriodID = PeriodID
        FROM FiscalPeriods
        ORDER BY PeriodID ASC
    END
    
    -- If still null, return 1 as default
    IF @PeriodID IS NULL
        SET @PeriodID = 1
    
    RETURN @PeriodID
END
GO

PRINT 'Function fn_GetCurrentFiscalPeriodID created successfully'
GO
