-- =============================================
-- Fix FNB Token URL - Restore correct /v2 endpoint
-- =============================================

USE Oven_Delights_Main
GO

PRINT 'Fixing Token URL to correct endpoint...'
GO

-- Restore the correct token URL with /v2
UPDATE FNB_APICredentials
SET TokenURL = 'https://api.i.fnb.co.za/apigateway/oauth2/token/v2'
WHERE Environment = 'Sandbox'
GO

PRINT 'Token URL fixed to: https://api.i.fnb.co.za/apigateway/oauth2/token/v2'
GO

SELECT Environment, TokenURL FROM FNB_APICredentials WHERE Environment = 'Sandbox'
GO

PRINT ''
PRINT '=============================================='
PRINT 'Token URL corrected - rebuild and test again'
PRINT '=============================================='
GO
