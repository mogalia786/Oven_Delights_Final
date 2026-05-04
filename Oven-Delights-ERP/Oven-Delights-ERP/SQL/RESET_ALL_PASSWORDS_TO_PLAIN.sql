-- ========================================
-- RESET ALL HASHED PASSWORDS TO PLAIN TEXT
-- ========================================

-- This script will reset all currently hashed passwords to plain text

-- Option 1: Reset all passwords to "password123"
UPDATE Users
SET Password = 'password123',
    PasswordHash = 'password123',
    PasswordLastChanged = GETDATE()
WHERE Password LIKE '%$2%'  -- BCrypt hashed passwords contain $2
   OR LEN(Password) > 50;    -- Hashed passwords are typically longer

SELECT 'Updated ' + CAST(@@ROWCOUNT AS VARCHAR) + ' user passwords to plain text' AS Result;

-- Option 2: Set specific passwords for specific users
-- Uncomment and modify as needed:

/*
-- Reset admin password
UPDATE Users
SET Password = 'admin123',
    PasswordHash = 'admin123',
    PasswordLastChanged = GETDATE()
WHERE Username = 'admin';

-- Reset other users
UPDATE Users
SET Password = '123456',
    PasswordHash = '123456',
    PasswordLastChanged = GETDATE()
WHERE Username IN ('Rabia', 'KATHRIN', 'nazrana');
*/

-- Verify the update
SELECT 
    UserID,
    Username,
    Password,
    Email,
    FirstName,
    LastName,
    IsActive
FROM Users
ORDER BY UserID;
