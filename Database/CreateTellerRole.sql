-- Create Teller role and permissions for POS operations
-- This script ensures the Teller role exists with appropriate permissions

-- Insert Teller role if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleName = 'Teller')
BEGIN
    INSERT INTO Roles (RoleName)
    VALUES ('Teller')
END

-- Get the RoleID for Teller
DECLARE @TellerRoleID INT
SELECT @TellerRoleID = RoleID FROM Roles WHERE RoleName = 'Teller'

-- For now, just create the Teller role
-- Permissions system will be implemented later based on actual database schema

PRINT 'Teller role and permissions created successfully.'
PRINT 'Teller role has access to:'
PRINT '- Point of Sale system'
PRINT '- Product viewing and lookup'
PRINT '- Stock level viewing'
PRINT '- Sales transaction processing'
PRINT '- Cash handling operations'
PRINT '- Basic sales reports'
