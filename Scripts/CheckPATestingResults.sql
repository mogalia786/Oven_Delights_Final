-- Query to check AI PA testing results and status
-- Run this to see what the PA has tested and any issues found

-- 1. Check if PA tables exist and service status
SELECT 'Service Status' as QueryType, 
       ServiceName, 
       Status, 
       LastRun, 
       NextRun, 
       RunCount, 
       ErrorCount,
       LastError
FROM BackgroundServiceStatus 
WHERE ServiceName LIKE '%AI%'
ORDER BY ServiceID DESC;

-- 2. Recent testing activity (last 24 hours) - using correct column names
SELECT 'Recent Tests' as QueryType,
       TestType,
       FormName,
       CASE WHEN Success = 1 THEN 'Pass' ELSE 'Fail' END as TestResult,
       Message as ErrorMessage,
       Timestamp,
       Duration
FROM TestResults 
WHERE Timestamp >= DATEADD(HOUR, -24, GETDATE())
ORDER BY Timestamp DESC;

-- 3. Critical issues found by PA - using correct column names
SELECT 'Critical Issues' as QueryType,
       Module,
       Feature,
       Message as Description,
       Priority as Severity,
       Status,
       Timestamp as DateFound,
       ResolvedDate as DateResolved
FROM CriticalIssues 
WHERE Status = 'Open'
ORDER BY Priority DESC, Timestamp DESC;

-- 4. Auto-fix history (what PA has repaired)
SELECT 'Auto Fixes' as QueryType,
       IssueType,
       FormName,
       FixApplied as Description,
       FixApplied,
       Success,
       Timestamp
FROM AutoFixHistory 
WHERE Timestamp >= DATEADD(HOUR, -24, GETDATE())
ORDER BY Timestamp DESC;

-- 5. Test coverage summary - using correct column names
SELECT 'Coverage Summary' as QueryType,
       Module as ModuleName,
       COUNT(*) as TotalForms,
       SUM(CASE WHEN LastTested IS NOT NULL THEN 1 ELSE 0 END) as TestedForms,
       SUM(CASE WHEN LastResult = 1 THEN 1 ELSE 0 END) as PassedTests,
       SUM(CASE WHEN LastResult = 0 THEN 1 ELSE 0 END) as FailedTests,
       MAX(LastTested) as LastTested
FROM TestCoverage 
GROUP BY Module
ORDER BY Module;

-- 6. Performance metrics - using correct column names
SELECT 'Performance' as QueryType,
       MetricType as MetricName,
       Value as MetricValue,
       Unit,
       Timestamp
FROM PerformanceMetrics 
WHERE Timestamp >= DATEADD(HOUR, -24, GETDATE())
ORDER BY Timestamp DESC;

-- 7. Overall system health check - using correct column names
SELECT 'System Health' as QueryType,
       COUNT(*) as TotalTests,
       SUM(CASE WHEN Success = 1 THEN 1 ELSE 0 END) as PassedTests,
       SUM(CASE WHEN Success = 0 THEN 1 ELSE 0 END) as FailedTests,
       CAST(SUM(CASE WHEN Success = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as DECIMAL(5,2)) as SuccessRate
FROM TestResults 
WHERE Timestamp >= DATEADD(HOUR, -24, GETDATE());

-- 8. Check if tables exist
SELECT 'Table Status' as QueryType,
       'TestSessions' as TableName,
       CASE WHEN EXISTS (SELECT * FROM sys.tables WHERE name = 'TestSessions') THEN 'EXISTS' ELSE 'MISSING' END as Status
UNION ALL
SELECT 'Table Status' as QueryType,
       'TestResults' as TableName,
       CASE WHEN EXISTS (SELECT * FROM sys.tables WHERE name = 'TestResults') THEN 'EXISTS' ELSE 'MISSING' END as Status
UNION ALL
SELECT 'Table Status' as QueryType,
       'AITestingLog' as TableName,
       CASE WHEN EXISTS (SELECT * FROM sys.tables WHERE name = 'AITestingLog') THEN 'EXISTS' ELSE 'MISSING' END as Status
UNION ALL
SELECT 'Table Status' as QueryType,
       'CriticalIssues' as TableName,
       CASE WHEN EXISTS (SELECT * FROM sys.tables WHERE name = 'CriticalIssues') THEN 'EXISTS' ELSE 'MISSING' END as Status
UNION ALL
SELECT 'Table Status' as QueryType,
       'AutoFixHistory' as TableName,
       CASE WHEN EXISTS (SELECT * FROM sys.tables WHERE name = 'AutoFixHistory') THEN 'EXISTS' ELSE 'MISSING' END as Status;
