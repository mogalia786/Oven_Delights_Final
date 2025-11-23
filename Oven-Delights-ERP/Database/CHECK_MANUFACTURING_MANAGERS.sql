-- Check for Manufacturing Manager role and users
SELECT r.RoleID, r.RoleName
FROM Roles r
WHERE r.RoleName LIKE '%Manufact%' OR r.RoleName LIKE '%Manager%'

-- Check users with Manufacturing Manager role
SELECT u.UserID, u.Username, u.FirstName, u.LastName, r.RoleName
FROM Users u
INNER JOIN Roles r ON u.RoleID = r.RoleID
WHERE r.RoleName = 'Manufacturing Manager'
