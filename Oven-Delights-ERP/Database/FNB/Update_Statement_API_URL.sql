-- =============================================
-- Update FNB Statement API URL to QA/Preprod Environment
-- =============================================
-- The Statement Execution API requires the preprod environment
-- Integration environment may not have statement data available
-- =============================================

SET NOCOUNT ON;
GO

PRINT ''
PRINT '=============================================='
PRINT 'FNB Statement API URL Update'
PRINT '=============================================='
PRINT ''

-- Show current URL
PRINT 'Current Configuration:'
SELECT 
    Environment, 
    BaseURL, 
    TokenURL,
    DebtorAccountNumber
FROM FNB_APICredentials 
WHERE Environment = 'Sandbox'
GO

PRINT ''
PRINT 'Updating to Preprod/QA endpoint for Statement API...'
GO

-- Update BaseURL to Preprod endpoint (same as Bulk Payment)
UPDATE FNB_APICredentials
SET BaseURL = 'https://api.p.fnb.co.za/apigateway',
    TokenURL = 'https://api.p.fnb.co.za/apigateway/oauth2/token/v2'
WHERE Environment = 'Sandbox'
GO

PRINT ''
PRINT 'Updated Configuration:'
SELECT 
    Environment, 
    BaseURL, 
    TokenURL,
    DebtorAccountNumber
FROM FNB_APICredentials 
WHERE Environment = 'Sandbox'
GO

PRINT ''
PRINT '=============================================='
PRINT 'FNB Statement API URL updated successfully'
PRINT 'BaseURL: https://api.p.fnb.co.za/apigateway'
PRINT 'TokenURL: https://api.p.fnb.co.za/apigateway/oauth2/token/v2'
PRINT ''
PRINT 'NOTE: Both Statement and Bulk Payment APIs'
PRINT 'now use the same preprod environment'
PRINT '=============================================='
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Rebuild the solution'
PRINT '2. Restart the application'
PRINT '3. Try fetching the statement again'
PRINT '=============================================='
GO
