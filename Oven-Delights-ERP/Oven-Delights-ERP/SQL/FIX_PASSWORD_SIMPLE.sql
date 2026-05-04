-- ========================================
-- SIMPLE FIX - Just update existing passwords to plain text
-- ========================================

-- First, check current Users table structure
SELECT TOP 5 * FROM Users;

-- Update all passwords to plain text
-- This will reset all passwords to "password123"
UPDATE Users
SET Password = 'password123',
    PasswordLastChanged = GETDATE()
WHERE Password LIKE '%$2%'  -- BCrypt hashed passwords
   OR LEN(Password) > 50;    -- Long hashed passwords

SELECT 'Updated ' + CAST(@@ROWCOUNT AS VARCHAR) + ' passwords' AS Result;

-- Verify
SELECT UserID, Username, Password, Email FROM Users;

-- If you want specific passwords for specific users:
/*
UPDATE Users SET Password = 'admin123' WHERE Username = 'admin';
UPDATE Users SET Password = '123456' WHERE Username IN ('Rabia', 'KATHRIN', 'nazrana');
*/
