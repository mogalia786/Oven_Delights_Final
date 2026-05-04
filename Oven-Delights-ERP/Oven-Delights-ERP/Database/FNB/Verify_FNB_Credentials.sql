-- =============================================
-- Verify FNB API Credentials
-- =============================================

USE Oven_Delights_Main
GO

PRINT '=============================================='
PRINT 'Checking FNB API Credentials'
PRINT '=============================================='
PRINT ''

-- Check if table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FNB_APICredentials')
BEGIN
    PRINT '❌ ERROR: FNB_APICredentials table does not exist!'
    PRINT 'Please run Create_FNB_Payment_Tables.sql first'
END
ELSE
BEGIN
    PRINT '✓ FNB_APICredentials table exists'
    PRINT ''
    
    -- Show all credentials
    SELECT 
        CredentialID,
        Environment,
        ClientID,
        LEFT(ClientSecret, 10) + '...' as ClientSecret_Preview,
        BaseURL,
        TokenURL,
        DebtorAccountNumber,
        DebtorBranchID,
        IsActive,
        IsSandbox
    FROM FNB_APICredentials
    ORDER BY Environment
    
    PRINT ''
    
    -- Check Sandbox credentials specifically
    IF EXISTS (SELECT 1 FROM FNB_APICredentials WHERE Environment = 'Sandbox' AND IsActive = 1)
    BEGIN
        PRINT '✓ Sandbox credentials found and active'
        
        DECLARE @ClientID NVARCHAR(50)
        DECLARE @ClientSecret NVARCHAR(200)
        
        SELECT 
            @ClientID = ClientID,
            @ClientSecret = ClientSecret
        FROM FNB_APICredentials 
        WHERE Environment = 'Sandbox' AND IsActive = 1
        
        PRINT ''
        PRINT 'Sandbox Credentials Details:'
        PRINT '  Client ID: ' + @ClientID
        PRINT '  Client Secret Length: ' + CAST(LEN(@ClientSecret) AS VARCHAR(10)) + ' characters'
        PRINT '  Expected Client ID: E84OOE'
        PRINT '  Expected Client Secret: 621NZsDknRDWjqf8sKhyH0ktjPXtbsr4'
        
        IF @ClientID = 'E84OOE'
            PRINT '  ✓ Client ID matches expected value'
        ELSE
            PRINT '  ❌ Client ID does NOT match! Found: ' + @ClientID
            
        IF @ClientSecret = '621NZsDknRDWjqf8sKhyH0ktjPXtbsr4'
            PRINT '  ✓ Client Secret matches expected value'
        ELSE
            PRINT '  ❌ Client Secret does NOT match!'
    END
    ELSE
    BEGIN
        PRINT '❌ ERROR: No active Sandbox credentials found!'
        PRINT ''
        PRINT 'Inserting Sandbox credentials now...'
        
        -- Insert sandbox credentials
        INSERT INTO FNB_APICredentials (
            Environment,
            ClientID,
            ClientSecret,
            BaseURL,
            TokenURL,
            DebtorAccountNumber,
            DebtorBranchID,
            IsActive,
            IsSandbox,
            Notes
        )
        VALUES (
            'Sandbox',
            'E84OOE',
            '621NZsDknRDWjqf8sKhyH0ktjPXtbsr4',
            'https://api.i.fnb.co.za/apigateway',
            'https://api.i.fnb.co.za/apigateway/oauth2/token/v2',
            '63001723469',
            '250655',
            1,
            1,
            '*** SANDBOX - For testing only ***'
        )
        
        PRINT '✓ Sandbox credentials inserted successfully'
    END
END

PRINT ''
PRINT '=============================================='
PRINT 'Verification Complete'
PRINT '=============================================='
GO
