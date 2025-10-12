-- =============================================
-- Create stored procedure for adding a new user
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_User_Create]
    @Username NVARCHAR(50),
    @Email NVARCHAR(128),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @RoleID INT,
    @BranchID INT = NULL,
    @Password NVARCHAR(255),
    @IsActive BIT = 1,
    @TwoFactorEnabled BIT = 0,
    @PhoneNumber NVARCHAR(20) = NULL,
    @ProfilePicture NVARCHAR(255) = NULL,
    @UserID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Check if username or email already exists
        IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username)
        BEGIN
            THROW 50001, 'A user with this username already exists.', 1;
        END
        
        IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
        BEGIN
            THROW 50002, 'A user with this email already exists.', 1;
        END
        
        -- Insert the new user
        INSERT INTO Users (
            Username, 
            Email, 
            FirstName, 
            LastName, 
            RoleID, 
            BranchID, 
            [Password],
            IsActive,
            TwoFactorEnabled,
            CreatedDate,
            PasswordLastChanged,
            PhoneNumber,
            ProfilePicture,
            IsLocked,
            FailedLoginAttempts
        )
        VALUES (
            @Username,
            @Email,
            @FirstName,
            @LastName,
            @RoleID,
            @BranchID,
            @Password,
            @IsActive,
            @TwoFactorEnabled,
            GETDATE(),
            GETDATE(),
            @PhoneNumber,
            @ProfilePicture,
            0, -- IsLocked
            0  -- FailedLoginAttempts
        )
        
        SET @UserID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        RETURN 0; -- Success
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        THROW;
        RETURN -1; -- Error
    END CATCH
END
GO

-- =============================================
-- Create stored procedure for updating a user
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_User_Update]
    @UserID INT,
    @Username NVARCHAR(50),
    @Email NVARCHAR(128),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @RoleID INT,
    @BranchID INT = NULL,
    @IsActive BIT = 1,
    @TwoFactorEnabled BIT = 0,
    @PhoneNumber NVARCHAR(20) = NULL,
    @ProfilePicture NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Check if user exists
        IF NOT EXISTS (SELECT 1 FROM Users WHERE UserID = @UserID)
        BEGIN
            THROW 50003, 'User not found.', 1;
        END
        
        -- Check if username or email is already taken by another user
        IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username AND UserID <> @UserID)
        BEGIN
            THROW 50001, 'A user with this username already exists.', 1;
        END
        
        IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email AND UserID <> @UserID)
        BEGIN
            THROW 50002, 'A user with this email already exists.', 1;
        END
        
        -- Update the user
        UPDATE Users
        SET 
            Username = @Username,
            Email = @Email,
            FirstName = @FirstName,
            LastName = @LastName,
            RoleID = @RoleID,
            BranchID = @BranchID,
            IsActive = @IsActive,
            TwoFactorEnabled = @TwoFactorEnabled,
            PhoneNumber = @PhoneNumber,
            ProfilePicture = @ProfilePicture
        WHERE UserID = @UserID;
        
        COMMIT TRANSACTION;
        RETURN 0; -- Success
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        THROW;
        RETURN -1; -- Error
    END CATCH
END
GO

-- =============================================
-- Create stored procedure for getting a user by ID
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_User_GetByID]
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        UserID,
        Username,
        Email,
        FirstName,
        LastName,
        RoleID,
        BranchID,
        IsActive,
        TwoFactorEnabled,
        CreatedDate,
        LastLogin,
        LastFailedLogin,
        FailedLoginAttempts,
        PasswordLastChanged,
        PhoneNumber,
        ProfilePicture,
        IsLocked
    FROM Users
    WHERE UserID = @UserID;
END
GO

-- =============================================
-- Create stored procedure for getting all users
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_User_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        u.UserID,
        u.Username,
        u.Email,
        u.FirstName,
        u.LastName,
        u.RoleID,
        r.RoleName,
        u.BranchID,
        b.BranchName,
        u.IsActive,
        u.TwoFactorEnabled,
        u.CreatedDate,
        u.LastLogin,
        u.LastFailedLogin,
        u.FailedLoginAttempts,
        u.PasswordLastChanged,
        u.PhoneNumber,
        u.ProfilePicture,
        u.IsLocked
    FROM Users u
    LEFT JOIN Roles r ON u.RoleID = r.RoleID
    LEFT JOIN Branches b ON u.BranchID = b.ID
    ORDER BY u.CreatedDate DESC;
END
GO

-- =============================================
-- Create stored procedure for searching users
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_User_Search]
    @SearchTerm NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SearchPattern NVARCHAR(102) = '%' + @SearchTerm + '%';
    
    SELECT 
        u.UserID,
        u.Username,
        u.Email,
        u.FirstName,
        u.LastName,
        u.RoleID,
        r.RoleName,
        u.BranchID,
        b.BranchName,
        u.IsActive,
        u.TwoFactorEnabled,
        u.CreatedDate,
        u.LastLogin,
        u.LastFailedLogin,
        u.FailedLoginAttempts,
        u.PasswordLastChanged,
        u.PhoneNumber,
        u.ProfilePicture,
        u.IsLocked
    FROM Users u
    LEFT JOIN Roles r ON u.RoleID = r.RoleID
    LEFT JOIN Branches b ON u.BranchID = b.ID
    WHERE u.Username LIKE @SearchPattern
       OR u.Email LIKE @SearchPattern
       OR u.FirstName LIKE @SearchPattern
       OR u.LastName LIKE @SearchPattern
    ORDER BY u.Username;
END
GO
