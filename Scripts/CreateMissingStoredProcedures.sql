-- =============================================
-- Create stored procedure for getting all users
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_User_GetAll')
BEGIN
    EXEC('CREATE PROCEDURE [dbo].[sp_User_GetAll] AS BEGIN SET NOCOUNT ON; END')
    PRINT 'Created empty sp_User_GetAll procedure'
END
GO

ALTER PROCEDURE [dbo].[sp_User_GetAll]
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
        u.PasswordLastChanged
    FROM Users u
    LEFT JOIN Roles r ON u.RoleID = r.RoleID
    LEFT JOIN Branches b ON u.BranchID = b.ID
    ORDER BY u.CreatedDate DESC;
END
GO

PRINT 'sp_User_GetAll procedure updated successfully'
GO

-- =============================================
-- Create stored procedure for searching users
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_User_Search')
BEGIN
    EXEC('CREATE PROCEDURE [dbo].[sp_User_Search] AS BEGIN SET NOCOUNT ON; END')
    PRINT 'Created empty sp_User_Search procedure'
END
GO

ALTER PROCEDURE [dbo].[sp_User_Search]
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
        u.PasswordLastChanged
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

PRINT 'sp_User_Search procedure updated successfully'
GO
