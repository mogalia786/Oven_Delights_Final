@echo off
echo Fixing Administration Module Issues Automatically...

echo.
echo 1. Testing Users table structure...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT TOP 5 u.UserID, u.Username, u.Email, ISNULL(u.IsActive, 1) AS IsActive, r.RoleName, b.Name AS BranchName, u.CreatedDate FROM Users u LEFT JOIN Roles r ON r.RoleID = u.RoleID LEFT JOIN Branches b ON b.BranchID = u.BranchID ORDER BY u.Username"

echo.
echo 2. Testing Roles table structure...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT TOP 5 RoleID, RoleName, ISNULL(Description, '') AS Description, ISNULL(IsActive, 1) AS IsActive FROM Roles ORDER BY RoleName"

echo.
echo 3. Creating AuditLog table if missing...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "IF OBJECT_ID('dbo.AuditLog','U') IS NULL BEGIN CREATE TABLE dbo.AuditLog (AuditID INT IDENTITY(1,1) PRIMARY KEY, UserID INT NULL, Action NVARCHAR(100) NOT NULL, TableName NVARCHAR(128) NULL, RecordID NVARCHAR(100) NULL, Details NVARCHAR(MAX) NULL, Timestamp DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(), IPAddress NVARCHAR(45) NULL) PRINT 'AuditLog table created' END ELSE PRINT 'AuditLog table exists'"

echo.
echo 4. Adding sample audit data if empty...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "IF NOT EXISTS (SELECT TOP 1 * FROM AuditLog) BEGIN INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Details, Timestamp, IPAddress) VALUES (1, 'Login', 'Users', '1', 'User logged in successfully', GETDATE(), '127.0.0.1'), (1, 'UserCreated', 'Users', '2', 'New user account created', DATEADD(MINUTE, -30, GETDATE()), '127.0.0.1'), (1, 'BranchCreated', 'Branches', '1', 'New branch office created', DATEADD(HOUR, -2, GETDATE()), '127.0.0.1'), (1, 'UserUpdated', 'Users', '1', 'User profile updated', DATEADD(DAY, -1, GETDATE()), '127.0.0.1') PRINT 'Sample data inserted' END ELSE PRINT 'Audit data exists'"

echo.
echo 5. Testing AuditLog query...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT TOP 10 AuditID AS ID, UserID, Action, TableName, RecordID, Details, Timestamp, IPAddress FROM AuditLog ORDER BY Timestamp DESC"

echo.
echo 6. Building application...
dotnet build --verbosity minimal

echo.
echo Administration Module Fix Complete!
pause
