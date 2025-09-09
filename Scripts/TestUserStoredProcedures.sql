-- Test Script for User Management Stored Procedures
-- Run this in SQL Server Management Studio or sqlcmd

-- 1. Test sp_User_GetAll
PRINT 'Testing sp_User_GetAll...';
EXEC sp_User_GetAll;

-- 2. Test sp_User_GetByID with an existing user (change the ID as needed)
PRINT '\nTesting sp_User_GetByID...';
DECLARE @TestUserID INT = 1; -- Change this to an existing UserID
EXEC sp_User_GetByID @UserID = @TestUserID;

-- 3. Test sp_User_Search with various criteria
PRINT '\nTesting sp_User_Search with different criteria...';
-- Search by name
PRINT 'Search by name ("faizel")...';
EXEC sp_User_Search @SearchTerm = 'faizel';

-- Search by role (change RoleID as needed)
PRINT '\nSearch by RoleID (1)...';
EXEC sp_User_Search @RoleID = 1;

-- Search by active status
PRINT '\nSearch for active users...';
EXEC sp_User_Search @IsActive = 1;

-- 4. Test sp_User_Create (create a test user)
PRINT '\nTesting sp_User_Create...';
DECLARE @NewUserID INT;
DECLARE @TestUsername NVARCHAR(50) = 'testuser_' + CAST(NEWID() AS NVARCHAR(36));
DECLARE @TestEmail NVARCHAR(128) = 'test_' + CAST(NEWID() AS NVARCHAR(36)) + '@test.com';

EXEC sp_User_Create
    @Username = @TestUsername,
    @Password = 'Test@1234', -- In production, this should be hashed
    @Email = @TestEmail,
    @FirstName = 'Test',
    @LastName = 'User',
    @RoleID = 2, -- Change to an existing RoleID
    @BranchID = 1, -- Change to an existing BranchID or NULL
    @CreatedBy = 1; -- Change to an existing UserID

-- Get the new user's ID
SELECT @NewUserID = SCOPE_IDENTITY();
PRINT 'Created test user with ID: ' + ISNULL(CAST(@NewUserID AS NVARCHAR(10)), 'NULL');

-- 5. Test sp_User_Update (update the test user)
IF @NewUserID IS NOT NULL
BEGIN
    PRINT '\nTesting sp_User_Update...';
    EXEC sp_User_Update
        @UserID = @NewUserID,
        @Username = @TestUsername + '_updated',
        @Email = 'updated_' + @TestEmail,
        @FirstName = 'Test_Updated',
        @LastName = 'User_Updated',
        @RoleID = 2, -- Change to a different RoleID
        @BranchID = 1, -- Change to a different BranchID or NULL
        @IsActive = 1,
        @TwoFactorEnabled = 0,
        @UpdatedBy = 1; -- Change to an existing UserID
    
    -- Verify the update
    PRINT 'After update:';
    EXEC sp_User_GetByID @UserID = @NewUserID;
END

-- 6. Test sp_User_ResetPassword (reset the test user's password)
IF @NewUserID IS NOT NULL
BEGIN
    PRINT '\nTesting sp_User_ResetPassword...';
    EXEC sp_User_ResetPassword
        @UserID = @NewUserID,
        @NewPassword = 'NewTest@1234', -- In production, this should be hashed
        @ResetByUserID = 1; -- Change to an existing UserID
    
    -- Verify the password was updated
    PRINT 'Password reset timestamp updated:';
    SELECT UserID, Username, PasswordLastChanged 
    FROM Users 
    WHERE UserID = @NewUserID;
END

-- 7. Test sp_User_Delete (deactivate the test user)
IF @NewUserID IS NOT NULL
BEGIN
    PRINT '\nTesting sp_User_Delete (soft delete)...';
    EXEC sp_User_Delete
        @UserID = @NewUserID,
        @DeletedBy = 1; -- Change to an existing UserID
    
    -- Verify the user was deactivated
    PRINT 'After deactivation (should be inactive):';
    EXEC sp_User_GetByID @UserID = @NewUserID;
END

-- 8. Test error handling (try to create a user with an existing username)
PRINT '\nTesting error handling - duplicate username...';
BEGIN TRY
    EXEC sp_User_Create
        @Username = 'admin', -- This should be an existing username
        @Password = 'Test@1234',
        @Email = 'duplicate_test@test.com',
        @FirstName = 'Duplicate',
        @LastName = 'User',
        @RoleID = 1,
        @CreatedBy = 1;
    
    PRINT 'ERROR: Should not reach here - duplicate username was allowed';
END TRY
BEGIN CATCH
    PRINT 'Expected error (duplicate username): ' + ERROR_MESSAGE();
END CATCH

-- 9. Test error handling (try to update a non-existent user)
PRINT '\nTesting error handling - update non-existent user...';
BEGIN TRY
    EXEC sp_User_Update
        @UserID = 999999, -- Non-existent UserID
        @Username = 'nonexistent',
        @Email = 'nonexistent@test.com',
        @FirstName = 'Non',
        @LastName = 'Existent',
        @RoleID = 1,
        @IsActive = 1,
        @TwoFactorEnabled = 0,
        @UpdatedBy = 1;
    
    PRINT 'ERROR: Should not reach here - updated non-existent user';
END TRY
BEGIN CATCH
    PRINT 'Expected error (user not found): ' + ERROR_MESSAGE();
END CATCH

PRINT '\nTest script completed.';
