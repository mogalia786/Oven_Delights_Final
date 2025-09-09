-- Simple Test Script for User Management Stored Procedures
-- Compatible with sqlcmd

-- 1. Test sp_User_GetAll
PRINT 'Testing sp_User_GetAll...';
EXEC sp_User_GetAll;
GO

-- 2. Test sp_User_GetByID with an existing user
PRINT 'Testing sp_User_GetByID...';
EXEC sp_User_GetByID @UserID = 1;
GO

-- 3. Test sp_User_Search with a search term
PRINT 'Testing sp_User_Search...';
EXEC sp_User_Search @SearchTerm = 'faizel';
GO

-- 4. Test sp_User_Create
PRINT 'Testing sp_User_Create...';
DECLARE @TestUsername NVARCHAR(50) = 'testuser_' + CONVERT(NVARCHAR(36), NEWID());
DECLARE @TestEmail NVARCHAR(128) = 'test_' + CONVERT(NVARCHAR(36), NEWID()) + '@test.com';

EXEC sp_User_Create
    @Username = @TestUsername,
    @Password = 'Test@1234',
    @Email = @TestEmail,
    @FirstName = 'Test',
    @LastName = 'User',
    @RoleID = 1,
    @CreatedBy = 1;
GO

-- 5. Test sp_User_Update
PRINT 'Testing sp_User_Update...';
-- Get the ID of the test user we just created
DECLARE @TestUserID INT = (SELECT TOP 1 UserID FROM Users WHERE Username LIKE 'testuser_%' ORDER BY UserID DESC);

IF @TestUserID IS NOT NULL
BEGIN
    EXEC sp_User_Update
        @UserID = @TestUserID,
        @Username = 'updated_' + CONVERT(NVARCHAR(36), @TestUserID),
        @Email = 'updated_' + CONVERT(NVARCHAR(36), @TestUserID) + '@test.com',
        @FirstName = 'Updated',
        @LastName = 'User',
        @RoleID = 1,
        @IsActive = 1,
        @TwoFactorEnabled = 0,
        @UpdatedBy = 1;
    
    -- Verify the update
    EXEC sp_User_GetByID @UserID = @TestUserID;
END
ELSE
BEGIN
    PRINT 'No test user found to update.';
END
GO

-- 6. Test sp_User_ResetPassword
PRINT 'Testing sp_User_ResetPassword...';
DECLARE @TestUserID2 INT = (SELECT TOP 1 UserID FROM Users WHERE Username LIKE 'updated_%' ORDER BY UserID DESC);

IF @TestUserID2 IS NOT NULL
BEGIN
    EXEC sp_User_ResetPassword
        @UserID = @TestUserID2,
        @NewPassword = 'NewTest@1234',
        @ResetByUserID = 1;
    
    -- Verify the password was updated
    SELECT UserID, Username, PasswordLastChanged 
    FROM Users 
    WHERE UserID = @TestUserID2;
END
ELSE
BEGIN
    PRINT 'No test user found to reset password.';
END
GO

-- 7. Test sp_User_Delete
PRINT 'Testing sp_User_Delete...';
DECLARE @TestUserID3 INT = (SELECT TOP 1 UserID FROM Users WHERE Username LIKE 'updated_%' ORDER BY UserID DESC);

IF @TestUserID3 IS NOT NULL
BEGIN
    EXEC sp_User_Delete
        @UserID = @TestUserID3,
        @DeletedBy = 1;
    
    -- Verify the user was deactivated
    SELECT UserID, Username, IsActive 
    FROM Users 
    WHERE UserID = @TestUserID3;
END
ELSE
BEGIN
    PRINT 'No test user found to delete.';
END
GO
