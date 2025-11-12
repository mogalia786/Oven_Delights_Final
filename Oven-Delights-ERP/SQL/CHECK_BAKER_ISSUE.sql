-- =============================================
-- CHECK: Why "Muhammmad Mall" not appearing
-- =============================================

PRINT '🔍 Checking baker "Muhammmad Mall"...';
PRINT '';

-- Check if user exists
PRINT '1️⃣ Searching for user with name containing "Muhammad" or "Muhammmad":';
SELECT 
    UserID,
    FirstName,
    LastName,
    FirstName + ' ' + LastName AS FullName,
    RoleID,
    IsActive,
    BranchID
FROM Users
WHERE (FirstName LIKE '%Muhammad%' OR FirstName LIKE '%Muhammmad%' 
    OR LastName LIKE '%Muhammad%' OR LastName LIKE '%Muhammmad%'
    OR LastName LIKE '%Mall%')
ORDER BY FirstName, LastName;

IF @@ROWCOUNT = 0
BEGIN
    PRINT '';
    PRINT '❌ No user found with name containing "Muhammad" or "Mall"';
    PRINT '   User may not exist or name is spelled differently';
END
ELSE
    PRINT '';
    PRINT '✅ User(s) found - checking details...';
END

PRINT '';
PRINT '═══════════════════════════════════════════════';

-- Check Manufacturer role
PRINT '2️⃣ Checking Manufacturer role:';
SELECT 
    RoleID,
    RoleName,
    Description
FROM Roles
WHERE RoleName = 'Manufacturer';

IF @@ROWCOUNT = 0
BEGIN
    PRINT '';
    PRINT '❌ Manufacturer role does not exist!';
END
ELSE
BEGIN
    PRINT '';
    PRINT '✅ Manufacturer role exists';
    
    -- Check if Muhammad has this role
    DECLARE @ManufacturerRoleID INT;
    SELECT @ManufacturerRoleID = RoleID FROM Roles WHERE RoleName = 'Manufacturer';
    
    PRINT '';
    PRINT '3️⃣ Users with Manufacturer role:';
    SELECT 
        UserID,
        FirstName + ' ' + LastName AS FullName,
        RoleID,
        IsActive,
        BranchID
    FROM Users
    WHERE RoleID = @ManufacturerRoleID
    ORDER BY FirstName, LastName;
    
    IF @@ROWCOUNT = 0
        PRINT '❌ No users have Manufacturer role!';
    ELSE
        PRINT '✅ Manufacturers found';
END

PRINT '';
PRINT '═══════════════════════════════════════════════';

-- Check what the query returns (same as used in forms)
PRINT '4️⃣ Testing the actual query used in forms:';
SELECT 
    UserID, 
    FirstName + ' ' + LastName AS FullName 
FROM Users 
WHERE RoleID IN (SELECT RoleID FROM Roles WHERE RoleName = 'Manufacturer') 
  AND IsActive = 1 
ORDER BY FirstName;

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 DIAGNOSIS:';
PRINT '';
PRINT 'If Muhammad Mall is NOT in the list above, check:';
PRINT '1. Is the name spelled correctly? (Muhammmad with 3 m''s?)';
PRINT '2. Is IsActive = 1?';
PRINT '3. Does the user have RoleID for Manufacturer role?';
PRINT '4. Is the user in the correct branch?';
PRINT '';
PRINT '🔧 TO FIX:';
PRINT '-- Update user to be active:';
PRINT 'UPDATE Users SET IsActive = 1 WHERE UserID = <ID>;';
PRINT '';
PRINT '-- Assign Manufacturer role:';
PRINT 'UPDATE Users SET RoleID = (SELECT RoleID FROM Roles WHERE RoleName = ''Manufacturer'') WHERE UserID = <ID>;';
PRINT '═══════════════════════════════════════════════';
