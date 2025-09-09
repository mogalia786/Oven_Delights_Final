-- Test Script for User Management Stored Procedures
-- Compatible with sqlcmd

-- 1. Test sp_User_GetAll
PRINT 'Testing sp_User_GetAll...';
EXEC sp_User_GetAll;
GO

-- 2. Test sp_User_GetByID with an existing user
PRINT 'Testing sp_User_GetByID...';
DECLARE @TestUserID INT = (SELECT TOP 1 UserID FROM Users ORDER BY UserID);
IF @TestUserID IS NOT NULL
    EXEC sp_User_GetByID @UserID = @TestUserID;
ELSE
    PRINT 'No users found in the database.';
GO

-- 3. Test sp_User_Search
PRINT 'Testing sp_User_Search...';
-- Get first user's username to search for
DECLARE @TestUsername NVARCHAR(50) = (SELECT TOP 1 Username FROM Users);
IF @TestUsername IS NOT NULL
    EXEC sp_User_Search @SearchTerm = @TestUsername;
ELSE
    PRINT 'No users found to test search.';
GO

-- 4. Test sp_User_Create
PRINT 'Testing sp_User_Create...';
DECLARE @NewUsername NVARCHAR(50) = 'testuser_' + CONVERT(NVARCHAR(36), NEWID());
DECLARE @NewEmail NVARCHAR(128) = 'test_' + CONVERT(NVARCHAR(36), NEWID()) + '@test.com';
DECLARE @NewUserID INT;

-- Get an existing role ID
DECLARE @RoleID INT = (SELECT TOP 1 RoleID FROM Roles);

IF @RoleID IS NOT NULL
BEGIN
    EXEC sp_User_Create
        @Username = @NewUsername,
        @Password = 'Test@1234',
        @Email = @NewEmail,
        @FirstName = 'Test',
        @LastName = 'User',
        @RoleID = @RoleID,
        @CreatedBy = 1; -- Assuming user ID 1 exists
    
    SET @NewUserID = SCOPE_IDENTITY();
    PRINT 'Created test user with ID: ' + CAST(ISNULL(@NewUserID, -1) AS NVARCHAR(10));
    
    -- Verify the user was created
    IF @NewUserID IS NOT NULL
        EXEC sp_User_GetByID @UserID = @NewUserID;
END
ELSE
BEGIN
    PRINT 'No roles found in the database. Cannot create test user.';
END
GO

-- 5. Test sp_User_Update with the newly created user
PRINT 'Testing sp_User_Update...';
DECLARE @UserToUpdateID INT = (SELECT TOP 1 UserID FROM Users WHERE Username LIKE 'testuser_%' ORDER BY UserID DESC);
DECLARE @UpdateRoleID INT = (SELECT TOP 1 RoleID FROM Roles);

IF @UserToUpdateID IS NOT NULL AND @UpdateRoleID IS NOT NULL
BEGIN
    EXEC sp_User_Update
        @UserID = @UserToUpdateID,
        @Username = 'updated_' + CAST(@UserToUpdateID AS NVARCHAR(10)),
        @Email = 'updated_' + CAST(@UserToUpdateID AS NVARCHAR(10)) + '@test.com',
        @FirstName = 'Updated',
        @LastName = 'User',
        @RoleID = @UpdateRoleID,
        @IsActive = 1,
        @TwoFactorEnabled = 0,
        @UpdatedBy = 1;
    
    -- Verify the update
    EXEC sp_User_GetByID @UserID = @UserToUpdateID;
END
ELSE
BEGIN
    PRINT 'No test user found to update or no roles available.';
END
GO

-- 6. Test sp_User_ResetPassword
PRINT 'Testing sp_User_ResetPassword...';
DECLARE @UserToResetID INT = (SELECT TOP 1 UserID FROM Users WHERE Username LIKE 'updated_%' OR Username LIKE 'testuser_%' ORDER BY UserID DESC);

IF @UserToResetID IS NOT NULL
BEGIN
    EXEC sp_User_ResetPassword
        @UserID = @UserToResetID,
        @NewPassword = 'NewTest@1234',
        @ResetByUserID = 1;
    
    -- Verify the password was updated
    SELECT UserID, Username, PasswordLastChanged 
    FROM Users 
    WHERE UserID = @UserToResetID;
END
ELSE
BEGIN
    PRINT 'No test user found to reset password.';
END
GO

-- 7. Test sp_User_Delete (soft delete)
PRINT 'Testing sp_User_Delete...';
DECLARE @UserToDeleteID INT = (SELECT TOP 1 UserID FROM Users WHERE (Username LIKE 'updated_%' OR Username LIKE 'testuser_%') AND IsActive = 1 ORDER BY UserID DESC);

IF @UserToDeleteID IS NOT NULL
BEGIN
    EXEC sp_User_Delete
        @UserID = @UserToDeleteID,
        @DeletedBy = 1;
    
    -- Verify the user was deactivated
    SELECT UserID, Username, IsActive 
    FROM Users 
    WHERE UserID = @UserToDeleteID;
END
ELSE
BEGIN
    PRINT 'No active test user found to delete.';
END
GO

PRINT 'Test script completed.';
