-- Script to create a default Super Admin account
DECLARE @RoleID INT;
-- Plain text password (for development only)
DECLARE @PasswordHash NVARCHAR(255) = 'Admin@123';
DECLARE @DefaultBranchID INT;

-- Check if Super Admin role exists, if not create it
IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleName = 'Super Admin')
BEGIN
    INSERT INTO Roles (RoleName, Description, CreatedDate, IsActive)
    VALUES ('Super Admin', 'System administrator with full access', GETDATE(), 1);
    SET @RoleID = SCOPE_IDENTITY();
    PRINT 'Created Super Admin role';
END
ELSE
BEGIN
    SELECT @RoleID = RoleID FROM Roles WHERE RoleName = 'Super Admin';
    PRINT 'Super Admin role already exists';
END

-- Get or create default branch
IF NOT EXISTS (SELECT 1 FROM Branches WHERE BranchName = 'Head Office')
BEGIN
    -- Create default branch with all required fields
    DECLARE @BranchCode varchar(10) = 'HO';
    DECLARE @BranchAddress NVARCHAR(500) = '123 Main St';
    DECLARE @BranchPhone NVARCHAR(20) = '0123456789';
    DECLARE @BranchEmail NVARCHAR(100) = 'info@ovendelights.com';
    DECLARE @BranchPrefix NVARCHAR(10) = 'HO';
    
    INSERT INTO Branches (
        BranchName, 
        BranchCode, 
        Phone,
        Email,
        Address,
        IsActive, 
        CreatedDate,
        Prefix
    )
    VALUES (
        'Head Office', 
        @BranchCode, 
        @BranchPhone,
        @BranchEmail,
        @BranchAddress,
        1, -- IsActive
        GETDATE(),
        @BranchPrefix
    );
    
    SET @DefaultBranchID = SCOPE_IDENTITY();
    PRINT 'Created default branch: Head Office';
END
ELSE
BEGIN
    SELECT @DefaultBranchID = BranchID FROM Branches WHERE BranchName = 'Head Office';
    PRINT 'Using existing branch: Head Office';
END

-- Create the default admin user if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'admin')
BEGIN
    -- Ensure we have valid RoleID and BranchID
    IF @RoleID IS NULL OR @DefaultBranchID IS NULL
    BEGIN
        RAISERROR('Missing required RoleID or BranchID', 16, 1);
        RETURN;
    END
    
   -- Create admin user with exact field names matching the database
INSERT INTO Users (
    UserID,
    Username,
    Password,
    FullName,
    Email,
    RoleID,
    BranchID,
    IsActive,
    CreatedDate,
    FailedLoginAttempts,
    IsLocked
)
VALUES (
    IDENT_CURRENT('Users') + 1,  -- Get next available UserID as INT
    'admin',
    'Admin@123',  -- Plain text password
    'System Administrator',
    'admin@ovendelights.com',
    @RoleID,
    @DefaultBranchID,
    1,        -- IsActive
    GETDATE(),
    0,        -- FailedLoginAttempts
    0         -- IsLocked
);
    
    PRINT 'Created default admin user with username: admin and password: Admin@123';
    PRINT 'IMPORTANT: Change the default password after first login!';
END
ELSE
BEGIN
    PRINT 'Admin user already exists';
END