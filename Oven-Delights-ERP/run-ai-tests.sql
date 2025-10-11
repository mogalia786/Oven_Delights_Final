-- Execute comprehensive AI testing with login credentials
-- This will run the AI Testing service as your personal assistant

-- First check if AI Testing tables exist
SELECT 'Checking AI Testing Infrastructure' as Status;

-- Check for required tables
SELECT 
    CASE WHEN EXISTS (SELECT * FROM sys.tables WHERE name = 'TestSessions') THEN 'EXISTS' ELSE 'MISSING' END as TestSessions,
    CASE WHEN EXISTS (SELECT * FROM sys.tables WHERE name = 'TestResults') THEN 'EXISTS' ELSE 'MISSING' END as TestResults,
    CASE WHEN EXISTS (SELECT * FROM sys.tables WHERE name = 'TestCoverage') THEN 'EXISTS' ELSE 'MISSING' END as TestCoverage;

-- Check for any existing test results
SELECT TOP 10 
    SessionID,
    Module,
    Feature,
    FormName,
    Success,
    Message,
    StartTime
FROM TestResults 
ORDER BY StartTime DESC;

-- Check login credentials exist
SELECT 
    UserID,
    Username,
    FirstName + ' ' + LastName as FullName,
    IsActive,
    RoleName
FROM Users u
LEFT JOIN Roles r ON u.RoleID = r.RoleID
WHERE Username = 'faizel';
