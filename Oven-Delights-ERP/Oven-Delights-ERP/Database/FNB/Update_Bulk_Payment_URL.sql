-- =============================================
-- Update FNB Bulk Payment API URL to QA Environment
-- =============================================
-- This updates the BaseURL for Bulk Payment integration
-- as per FNB Bulk Payment Integrations team email
-- =============================================

PRINT '=============================================='
PRINT 'Updating FNB Bulk Payment API URL to QA'
PRINT '=============================================='
PRINT ''

-- Show current URL
PRINT 'Current BaseURL:'
SELECT Environment, BaseURL, TokenURL 
FROM FNB_APICredentials 
WHERE Environment = 'Sandbox'
GO

PRINT ''
PRINT 'Updating to QA endpoint...'
GO

-- Update BaseURL to QA endpoint
UPDATE FNB_APICredentials
SET BaseURL = 'https://api.p.fnb.co.za/apigateway',
    TokenURL = 'https://api.p.fnb.co.za/apigateway/oauth2/token/v2'
WHERE Environment = 'Sandbox'
GO

PRINT ''
PRINT 'Updated URLs:'
SELECT Environment, BaseURL, TokenURL 
FROM FNB_APICredentials 
WHERE Environment = 'Sandbox'
GO

PRINT ''
PRINT '=============================================='
PRINT 'FNB Bulk Payment API URL updated successfully'
PRINT 'BaseURL: https://api.p.fnb.co.za/apigateway'
PRINT 'TokenURL: https://api.p.fnb.co.za/apigateway/oauth2/token/v2'
PRINT '=============================================='
PRINT ''
PRINT 'NOTE: This is for BULK PAYMENT integration'
PRINT 'Terminal transactions still use: https://test.figment.co.za:49410/api/'
PRINT '=============================================='
GO
