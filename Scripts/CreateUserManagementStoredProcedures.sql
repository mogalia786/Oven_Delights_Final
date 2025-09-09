-- =============================================
-- Create User Management Stored Procedures
-- =============================================

-- Drop existing procedures if they exist
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_User_GetAll')
    DROP PROCEDURE [dbo].[sp_User_GetAll]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_User_GetByID')
    DROP PROCEDURE [dbo].[sp_User_GetByID]
GO

-- =============================================
-- sp_User_GetAll - Gets all users with role and branch information
-- =============================================
CREATE PROCEDURE [dbo].[sp_User_GetAll]
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
        u.FailedLoginAttempts,
        u.LastFailedLogin,
        u.PasswordLastChanged,
        u.PhoneNumber,
        u.IsLocked
    FROM Users u
    LEFT JOIN Roles r ON u.RoleID = r.RoleID
    LEFT JOIN Branches b ON u.BranchID = b.ID
    ORDER BY u.LastName, u.FirstName;
END
GO

-- =============================================
-- sp_User_GetByID - Gets a single user by ID with role and branch information
-- =============================================
CREATE PROCEDURE [dbo].[sp_User_GetByID]
    @UserID INT
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
        u.FailedLoginAttempts,
        u.LastFailedLogin,
        u.PasswordLastChanged,
        u.PhoneNumber,
        u.IsLocked
    FROM Users u
    LEFT JOIN Roles r ON u.RoleID = r.RoleID
    LEFT JOIN Branches b ON u.BranchID = b.ID
    WHERE u.UserID = @UserID;
END
GO

-- Grant execute permissions to the appropriate roles
GRANT EXECUTE ON [dbo].[sp_User_GetAll] TO [public];
GRANT EXECUTE ON [dbo].[sp_User_GetByID] TO [public];
GO

PRINT 'User management stored procedures created successfully.';
