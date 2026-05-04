-- =============================================
-- Fix FNB Client Secret - Update to Full Value
-- =============================================

USE Oven_Delights_Main
GO

PRINT 'Checking current Client Secret length...'
GO

SELECT 
    Environment, 
    ClientID, 
    ClientSecret,
    LEN(ClientSecret) AS SecretLength,
    CASE 
        WHEN LEN(ClientSecret) < 30 THEN 'TRUNCATED - NEEDS FIX'
        ELSE 'OK'
    END AS Status
FROM FNB_APICredentials 
WHERE Environment = 'Sandbox'
GO

PRINT ''
PRINT 'Updating to full Client Secret...'
GO

-- Update with FULL client secret
UPDATE FNB_APICredentials
SET ClientSecret = '621NZsDknRDWjqf8sKhyH0ktjPXtbsr4'
WHERE Environment = 'Sandbox'
GO

PRINT 'Client Secret updated'
GO

-- Verify the fix
SELECT 
    Environment, 
    ClientID, 
    ClientSecret,
    LEN(ClientSecret) AS SecretLength,
    CASE 
        WHEN LEN(ClientSecret) = 32 THEN 'CORRECT LENGTH'
        ELSE 'STILL WRONG'
    END AS Status
FROM FNB_APICredentials 
WHERE Environment = 'Sandbox'
GO

PRINT ''
PRINT '=============================================='
PRINT 'Client Secret fixed - rebuild and test again'
PRINT 'Full secret: 621NZsDknRDWjqf8sKhyH0ktjPXtbsr4'
PRINT 'Length should be: 32 characters'
PRINT '=============================================='
GO
