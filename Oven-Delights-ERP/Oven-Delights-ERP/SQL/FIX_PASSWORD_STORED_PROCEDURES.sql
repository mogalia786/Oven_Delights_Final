-- ========================================
-- FIX STORED PROCEDURES TO NOT HASH PASSWORDS
-- ========================================

-- 1. Fix sp_User_Create - Remove password hashing
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_User_Create')
BEGIN
    DROP PROCEDURE sp_User_Create
END
GO

CREATE PROCEDURE sp_User_Create
    @Username NVARCHAR(50),
    @Email NVARCHAR(100),
    @Password NVARCHAR(255),  -- Plain password, no hashing
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @RoleID INT,
    @BranchID INT = NULL,
    @IsActive BIT = 1,
    @TwoFactorEnabled BIT = 0,
    @PhoneNumber NVARCHAR(20) = NULL,
    @ProfilePicture NVARCHAR(255) = NULL,
    @UserID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if username already exists
    IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username)
    BEGIN
        RAISERROR('Username already exists', 16, 1)
        RETURN
    END
    
    -- Check if email already exists
    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        RAISERROR('Email already exists', 16, 1)
        RETURN
    END
    
    -- Insert user with plain password
    INSERT INTO Users (
        Username, Email, Password, PasswordHash,
        FirstName, LastName, RoleID, BranchID,
        IsActive, TwoFactorEnabled, PhoneNumber, ProfilePicture,
        CreatedDate, PasswordLastChanged
    )
    VALUES (
        @Username, @Email, @Password, @Password,  -- Store same value in both columns
        @FirstName, @LastName, @RoleID, @BranchID,
        @IsActive, @TwoFactorEnabled, @PhoneNumber, @ProfilePicture,
        GETDATE(), GETDATE()
    )
    
    SET @UserID = SCOPE_IDENTITY()
END
GO

-- 2. Fix sp_User_Update - Don't touch password
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_User_Update')
BEGIN
    DROP PROCEDURE sp_User_Update
END
GO

CREATE PROCEDURE sp_User_Update
    @UserID INT,
    @Username NVARCHAR(50),
    @Email NVARCHAR(100),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @RoleID INT,
    @BranchID INT = NULL,
    @IsActive BIT,
    @TwoFactorEnabled BIT = 0,
    @PhoneNumber NVARCHAR(20) = NULL,
    @ProfilePicture NVARCHAR(255) = NULL,
    @ModifiedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if username exists for another user
    IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username AND UserID <> @UserID)
    BEGIN
        RAISERROR('Username already exists', 16, 1)
        RETURN
    END
    
    -- Check if email exists for another user
    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email AND UserID <> @UserID)
    BEGIN
        RAISERROR('Email already exists', 16, 1)
        RETURN
    END
    
    -- Update user (don't touch password)
    UPDATE Users
    SET Username = @Username,
        Email = @Email,
        FirstName = @FirstName,
        LastName = @LastName,
        RoleID = @RoleID,
        BranchID = @BranchID,
        IsActive = @IsActive,
        TwoFactorEnabled = @TwoFactorEnabled,
        PhoneNumber = @PhoneNumber,
        ProfilePicture = @ProfilePicture,
        ModifiedDate = GETDATE(),
        ModifiedBy = @ModifiedBy
    WHERE UserID = @UserID
END
GO

-- 3. Fix sp_User_ResetPassword - Store plain password
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_User_ResetPassword')
BEGIN
    DROP PROCEDURE sp_User_ResetPassword
END
GO

CREATE PROCEDURE sp_User_ResetPassword
    @UserID INT,
    @NewPassword NVARCHAR(255),  -- Plain password, no hashing
    @ModifiedBy INT = NULL,
    @Success BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update password with plain text
    UPDATE Users
    SET Password = @NewPassword,
        PasswordHash = @NewPassword,  -- Store same value in both columns
        PasswordLastChanged = GETDATE(),
        ModifiedDate = GETDATE(),
        ModifiedBy = @ModifiedBy
    WHERE UserID = @UserID
    
    IF @@ROWCOUNT > 0
        SET @Success = 1
    ELSE
        SET @Success = 0
END
GO

-- 4. Update existing hashed passwords to plain text (OPTIONAL - only if you want to reset all passwords)
-- UNCOMMENT BELOW TO RESET ALL PASSWORDS TO "password123"
/*
UPDATE Users
SET Password = 'password123',
    PasswordHash = 'password123',
    PasswordLastChanged = GETDATE()
WHERE Password LIKE '%$2%'  -- BCrypt hashed passwords contain $2
*/

PRINT 'Stored procedures updated successfully!'
PRINT 'Passwords will now be stored as plain text.'
PRINT ''
PRINT 'IMPORTANT: To reset existing hashed passwords, uncomment and run the UPDATE statement at the end of this script.'
