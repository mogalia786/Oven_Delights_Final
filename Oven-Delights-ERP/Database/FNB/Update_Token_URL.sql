-- =============================================
-- Update FNB Token URL - Try without /v2
-- =============================================

USE Oven_Delights_Main
GO

PRINT 'Checking current Token URL...'
GO

SELECT Environment, TokenURL FROM FNB_APICredentials WHERE Environment = 'Sandbox'
GO

PRINT ''
PRINT 'Updating to try without /v2 suffix...'
GO

-- Try the token URL without /v2
UPDATE FNB_APICredentials
SET TokenURL = 'https://api.i.fnb.co.za/apigateway/oauth2/token'
WHERE Environment = 'Sandbox'
GO

PRINT 'Updated Token URL'
GO

SELECT Environment, TokenURL FROM FNB_APICredentials WHERE Environment = 'Sandbox'
GO

PRINT ''
PRINT '=============================================='
PRINT 'Token URL updated - try testing again'
PRINT 'If this still fails, revert with:'
PRINT 'UPDATE FNB_APICredentials SET TokenURL = ''https://api.i.fnb.co.za/apigateway/oauth2/token/v2'' WHERE Environment = ''Sandbox'''
PRINT '=============================================='
GO
