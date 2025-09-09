-- 40_Seed_GLAccountMappings_PerBranch.sql
-- Purpose: Seed per-branch GLAccountMappings for 'GRIR' and 'Creditors' without requiring manual account numbers.
--          Pulls from SystemSettings (GRIRAccountID, APControlAccountID) first, then falls back to any existing
--          global mappings (BranchID IS NULL). Idempotent: safe to re-run.
--
-- Affects:
--   - dbo.GLAccountMappings (per-branch rows for MappingKey 'GRIR' and 'Creditors')
-- Reads:
--   - dbo.SystemSettings (keys: 'GRIRAccountID', 'APControlAccountID')
--   - dbo.GLAccountMappings (global rows)
--   - dbo.Branches (BranchID)
--   - dbo.GLAccounts (validates AccountID existence)

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRAN;

    -- Resolve source accounts from SystemSettings
    DECLARE @GRIR_FromSettings INT = (SELECT TRY_CAST([Value] AS INT) FROM dbo.SystemSettings WHERE [Key] = 'GRIRAccountID');
    DECLARE @AP_FromSettings   INT = (SELECT TRY_CAST([Value] AS INT) FROM dbo.SystemSettings WHERE [Key] = 'APControlAccountID');

    -- Fallback: global mappings (BranchID IS NULL)
    DECLARE @GRIR_Global INT = (
        SELECT AccountID FROM dbo.GLAccountMappings
        WHERE MappingKey = 'GRIR' AND BranchID IS NULL
    );
    DECLARE @AP_Global INT = (
        SELECT AccountID FROM dbo.GLAccountMappings
        WHERE MappingKey = 'Creditors' AND BranchID IS NULL
    );

    -- Choose final sources (prefer SystemSettings if present and > 0)
    DECLARE @GRIR_Final INT = CASE WHEN @GRIR_FromSettings IS NOT NULL AND @GRIR_FromSettings > 0 THEN @GRIR_FromSettings ELSE @GRIR_Global END;
    DECLARE @AP_Final   INT = CASE WHEN @AP_FromSettings   IS NOT NULL AND @AP_FromSettings   > 0 THEN @AP_FromSettings   ELSE @AP_Global   END;

    -- Validate against GLAccounts to avoid orphan AccountID usage
    IF @GRIR_Final IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.GLAccounts WHERE AccountID = @GRIR_Final)
        SET @GRIR_Final = NULL;
    IF @AP_Final IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.GLAccounts WHERE AccountID = @AP_Final)
        SET @AP_Final = NULL;

    -- Prepare branch list
    IF OBJECT_ID('tempdb..#Branches') IS NOT NULL DROP TABLE #Branches;
    SELECT BranchID AS BranchID INTO #Branches FROM dbo.Branches;

    -- 1) UPDATE existing per-branch rows where a valid source is available
    IF @GRIR_Final IS NOT NULL
    BEGIN
        UPDATE m
        SET m.AccountID = @GRIR_Final, m.ModifiedDate = GETDATE()
        FROM dbo.GLAccountMappings m
        INNER JOIN #Branches b ON b.BranchID = m.BranchID
        WHERE m.MappingKey = 'GRIR' AND (m.AccountID IS NULL OR m.AccountID <> @GRIR_Final);
    END

    IF @AP_Final IS NOT NULL
    BEGIN
        UPDATE m
        SET m.AccountID = @AP_Final, m.ModifiedDate = GETDATE()
        FROM dbo.GLAccountMappings m
        INNER JOIN #Branches b ON b.BranchID = m.BranchID
        WHERE m.MappingKey = 'Creditors' AND (m.AccountID IS NULL OR m.AccountID <> @AP_Final);
    END

    -- 2) INSERT missing per-branch rows where a valid source is available
    IF @GRIR_Final IS NOT NULL
    BEGIN
        INSERT INTO dbo.GLAccountMappings (MappingKey, AccountID, BranchID)
        SELECT 'GRIR', @GRIR_Final, b.BranchID
        FROM #Branches b
        WHERE NOT EXISTS (
            SELECT 1 FROM dbo.GLAccountMappings m WHERE m.MappingKey = 'GRIR' AND m.BranchID = b.BranchID
        );
    END

    IF @AP_Final IS NOT NULL
    BEGIN
        INSERT INTO dbo.GLAccountMappings (MappingKey, AccountID, BranchID)
        SELECT 'Creditors', @AP_Final, b.BranchID
        FROM #Branches b
        WHERE NOT EXISTS (
            SELECT 1 FROM dbo.GLAccountMappings m WHERE m.MappingKey = 'Creditors' AND m.BranchID = b.BranchID
        );
    END

    COMMIT TRAN;

    -- Reports (run outside the transaction for clarity)
    PRINT 'Per-branch mappings (GRIR, Creditors):';
    SELECT m.BranchID, b.BranchName, b.Prefix, m.MappingKey, m.AccountID
    FROM dbo.GLAccountMappings m
    LEFT JOIN dbo.Branches b ON b.BranchID = m.BranchID
    WHERE m.MappingKey IN ('GRIR','Creditors')
    ORDER BY b.BranchName, m.MappingKey;

    PRINT 'Branches missing mappings (no valid source found from SystemSettings or global):';
    SELECT b.BranchID AS BranchID, b.BranchName, b.Prefix
    FROM dbo.Branches b
    WHERE NOT EXISTS (SELECT 1 FROM dbo.GLAccountMappings m WHERE m.BranchID = b.BranchID AND m.MappingKey = 'GRIR')
       OR NOT EXISTS (SELECT 1 FROM dbo.GLAccountMappings m WHERE m.BranchID = b.BranchID AND m.MappingKey = 'Creditors');

END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrNum INT = ERROR_NUMBER();
    DECLARE @ErrSev INT = ERROR_SEVERITY();
    DECLARE @ErrSta INT = ERROR_STATE();
    RAISERROR('40_Seed_GLAccountMappings_PerBranch failed: (%d) %s', @ErrSev, @ErrSta, @ErrNum, @ErrMsg);
END CATCH;
