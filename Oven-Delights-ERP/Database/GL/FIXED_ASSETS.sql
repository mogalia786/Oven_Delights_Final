-- =============================================
-- FIXED ASSETS MANAGEMENT
-- =============================================
-- This script creates tables and procedures for managing fixed assets
-- including depreciation calculation and integration with GL

PRINT 'Creating Fixed Assets tables and procedures...'
GO

-- =============================================
-- 1. FIXED ASSETS TABLE
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FixedAssets')
BEGIN
    CREATE TABLE FixedAssets (
        AssetID INT IDENTITY(1,1) PRIMARY KEY,
        AssetCode VARCHAR(20) NOT NULL UNIQUE,
        AssetName VARCHAR(200) NOT NULL,
        AssetCategory VARCHAR(50) NOT NULL, -- Building, Equipment, Vehicle, Furniture, Computer, etc.
        Description VARCHAR(500),
        
        -- Purchase Information
        PurchaseDate DATE NOT NULL,
        PurchasePrice DECIMAL(18,2) NOT NULL,
        SupplierID INT NULL,
        InvoiceNumber VARCHAR(50),
        
        -- Location & Ownership
        BranchID INT NOT NULL,
        LocationDetails VARCHAR(200),
        SerialNumber VARCHAR(100),
        
        -- Depreciation Settings
        DepreciationMethod VARCHAR(20) NOT NULL DEFAULT 'StraightLine', -- StraightLine, DecliningBalance
        UsefulLifeYears INT NOT NULL, -- Expected useful life
        SalvageValue DECIMAL(18,2) NOT NULL DEFAULT 0,
        
        -- GL Account Mapping
        AssetAccountID INT NOT NULL, -- Link to ChartOfAccounts (Asset account)
        DepreciationAccountID INT NOT NULL, -- Link to ChartOfAccounts (Accumulated Depreciation)
        ExpenseAccountID INT NOT NULL, -- Link to ChartOfAccounts (Depreciation Expense)
        
        -- Current Status
        CurrentBookValue DECIMAL(18,2) NOT NULL,
        AccumulatedDepreciation DECIMAL(18,2) NOT NULL DEFAULT 0,
        LastDepreciationDate DATE NULL,
        
        -- Disposal Information
        IsDisposed BIT NOT NULL DEFAULT 0,
        DisposalDate DATE NULL,
        DisposalAmount DECIMAL(18,2) NULL,
        DisposalNotes VARCHAR(500),
        
        -- Audit Fields
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        
        CONSTRAINT FK_FixedAssets_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_FixedAssets_AssetAccount FOREIGN KEY (AssetAccountID) REFERENCES ChartOfAccounts(AccountID),
        CONSTRAINT FK_FixedAssets_DepreciationAccount FOREIGN KEY (DepreciationAccountID) REFERENCES ChartOfAccounts(AccountID),
        CONSTRAINT FK_FixedAssets_ExpenseAccount FOREIGN KEY (ExpenseAccountID) REFERENCES ChartOfAccounts(AccountID)
    )
    
    PRINT '✓ Created FixedAssets table'
END
ELSE
    PRINT '  FixedAssets table already exists'
GO

-- =============================================
-- 2. DEPRECIATION HISTORY TABLE
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DepreciationHistory')
BEGIN
    CREATE TABLE DepreciationHistory (
        DepreciationID INT IDENTITY(1,1) PRIMARY KEY,
        AssetID INT NOT NULL,
        
        -- Period Information
        DepreciationPeriod DATE NOT NULL, -- Month/Year of depreciation
        DepreciationAmount DECIMAL(18,2) NOT NULL,
        AccumulatedDepreciation DECIMAL(18,2) NOT NULL,
        BookValue DECIMAL(18,2) NOT NULL,
        
        -- GL Integration
        JournalID INT NULL, -- Link to JournalHeaders if posted
        IsPosted BIT NOT NULL DEFAULT 0,
        PostedDate DATETIME NULL,
        PostedBy INT NULL,
        
        -- Audit
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NOT NULL,
        
        CONSTRAINT FK_DepreciationHistory_Asset FOREIGN KEY (AssetID) REFERENCES FixedAssets(AssetID),
        CONSTRAINT FK_DepreciationHistory_Journal FOREIGN KEY (JournalID) REFERENCES JournalHeaders(JournalID)
    )
    
    CREATE INDEX IX_DepreciationHistory_Asset ON DepreciationHistory(AssetID)
    CREATE INDEX IX_DepreciationHistory_Period ON DepreciationHistory(DepreciationPeriod)
    
    PRINT '✓ Created DepreciationHistory table'
END
ELSE
    PRINT '  DepreciationHistory table already exists'
GO

-- =============================================
-- 3. CALCULATE MONTHLY DEPRECIATION
-- =============================================

IF OBJECT_ID('fn_CalculateMonthlyDepreciation', 'FN') IS NOT NULL
    DROP FUNCTION fn_CalculateMonthlyDepreciation
GO

CREATE FUNCTION fn_CalculateMonthlyDepreciation
(
    @PurchasePrice DECIMAL(18,2),
    @SalvageValue DECIMAL(18,2),
    @UsefulLifeYears INT,
    @DepreciationMethod VARCHAR(20)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @MonthlyDepreciation DECIMAL(18,2)
    DECLARE @DepreciableAmount DECIMAL(18,2) = @PurchasePrice - @SalvageValue
    DECLARE @TotalMonths INT = @UsefulLifeYears * 12
    
    IF @DepreciationMethod = 'StraightLine'
    BEGIN
        SET @MonthlyDepreciation = @DepreciableAmount / @TotalMonths
    END
    ELSE -- DecliningBalance or other methods
    BEGIN
        SET @MonthlyDepreciation = @DepreciableAmount / @TotalMonths
    END
    
    RETURN ISNULL(@MonthlyDepreciation, 0)
END
GO

PRINT '✓ Created fn_CalculateMonthlyDepreciation'
GO

-- =============================================
-- 4. ADD NEW FIXED ASSET
-- =============================================

IF OBJECT_ID('sp_FixedAsset_Add', 'P') IS NOT NULL
    DROP PROCEDURE sp_FixedAsset_Add
GO

CREATE PROCEDURE sp_FixedAsset_Add
    @AssetCode VARCHAR(20),
    @AssetName VARCHAR(200),
    @AssetCategory VARCHAR(50),
    @Description VARCHAR(500) = NULL,
    @PurchaseDate DATE,
    @PurchasePrice DECIMAL(18,2),
    @SupplierID INT = NULL,
    @InvoiceNumber VARCHAR(50) = NULL,
    @BranchID INT,
    @LocationDetails VARCHAR(200) = NULL,
    @SerialNumber VARCHAR(100) = NULL,
    @DepreciationMethod VARCHAR(20) = 'StraightLine',
    @UsefulLifeYears INT,
    @SalvageValue DECIMAL(18,2) = 0,
    @AssetAccountID INT,
    @DepreciationAccountID INT,
    @ExpenseAccountID INT,
    @CreatedBy INT,
    @AssetID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Validate accounts exist
        IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountID = @AssetAccountID AND IsActive = 1)
            THROW 50001, 'Invalid Asset Account', 1
            
        IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountID = @DepreciationAccountID AND IsActive = 1)
            THROW 50002, 'Invalid Depreciation Account', 1
            
        IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountID = @ExpenseAccountID AND IsActive = 1)
            THROW 50003, 'Invalid Expense Account', 1
        
        -- Insert asset
        INSERT INTO FixedAssets (
            AssetCode, AssetName, AssetCategory, Description,
            PurchaseDate, PurchasePrice, SupplierID, InvoiceNumber,
            BranchID, LocationDetails, SerialNumber,
            DepreciationMethod, UsefulLifeYears, SalvageValue,
            AssetAccountID, DepreciationAccountID, ExpenseAccountID,
            CurrentBookValue, AccumulatedDepreciation,
            CreatedBy
        )
        VALUES (
            @AssetCode, @AssetName, @AssetCategory, @Description,
            @PurchaseDate, @PurchasePrice, @SupplierID, @InvoiceNumber,
            @BranchID, @LocationDetails, @SerialNumber,
            @DepreciationMethod, @UsefulLifeYears, @SalvageValue,
            @AssetAccountID, @DepreciationAccountID, @ExpenseAccountID,
            @PurchasePrice, 0,
            @CreatedBy
        )
        
        SET @AssetID = SCOPE_IDENTITY()
        
        COMMIT TRANSACTION
        
        SELECT @AssetID AS AssetID, 'Asset added successfully' AS Message
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END
GO

PRINT '✓ Created sp_FixedAsset_Add'
GO

-- =============================================
-- 5. PROCESS MONTHLY DEPRECIATION
-- =============================================

IF OBJECT_ID('sp_FixedAsset_ProcessDepreciation', 'P') IS NOT NULL
    DROP PROCEDURE sp_FixedAsset_ProcessDepreciation
GO

CREATE PROCEDURE sp_FixedAsset_ProcessDepreciation
    @DepreciationPeriod DATE, -- Month to process (e.g., '2026-01-31')
    @PostToGL BIT = 1,
    @ProcessedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    DECLARE @AssetsProcessed INT = 0
    DECLARE @TotalDepreciation DECIMAL(18,2) = 0
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Get all active assets that need depreciation
        DECLARE @AssetID INT, @MonthlyDepreciation DECIMAL(18,2)
        DECLARE @AssetAccountID INT, @DepreciationAccountID INT, @ExpenseAccountID INT
        DECLARE @BranchID INT, @AssetName VARCHAR(200)
        
        DECLARE asset_cursor CURSOR FOR
        SELECT 
            AssetID,
            AssetName,
            BranchID,
            AssetAccountID,
            DepreciationAccountID,
            ExpenseAccountID,
            dbo.fn_CalculateMonthlyDepreciation(
                PurchasePrice, 
                SalvageValue, 
                UsefulLifeYears, 
                DepreciationMethod
            ) AS MonthlyDepreciation
        FROM FixedAssets
        WHERE IsActive = 1 
          AND IsDisposed = 0
          AND PurchaseDate <= @DepreciationPeriod
          AND (LastDepreciationDate IS NULL OR LastDepreciationDate < @DepreciationPeriod)
          AND CurrentBookValue > SalvageValue
        
        OPEN asset_cursor
        FETCH NEXT FROM asset_cursor INTO @AssetID, @AssetName, @BranchID, @AssetAccountID, @DepreciationAccountID, @ExpenseAccountID, @MonthlyDepreciation
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @NewAccumulatedDep DECIMAL(18,2)
            DECLARE @NewBookValue DECIMAL(18,2)
            DECLARE @JournalID INT = NULL
            
            -- Calculate new values
            SELECT 
                @NewAccumulatedDep = AccumulatedDepreciation + @MonthlyDepreciation,
                @NewBookValue = CurrentBookValue - @MonthlyDepreciation
            FROM FixedAssets
            WHERE AssetID = @AssetID
            
            -- Don't depreciate below salvage value
            DECLARE @SalvageValue DECIMAL(18,2)
            SELECT @SalvageValue = SalvageValue FROM FixedAssets WHERE AssetID = @AssetID
            
            IF @NewBookValue < @SalvageValue
            BEGIN
                SET @MonthlyDepreciation = @NewBookValue - @SalvageValue
                SET @NewBookValue = @SalvageValue
                SET @NewAccumulatedDep = (SELECT PurchasePrice FROM FixedAssets WHERE AssetID = @AssetID) - @SalvageValue
            END
            
            -- Post to GL if requested
            IF @PostToGL = 1 AND @MonthlyDepreciation > 0
            BEGIN
                DECLARE @JournalNumber VARCHAR(50) = 'DEP-' + FORMAT(@DepreciationPeriod, 'yyyyMM') + '-' + CAST(@AssetID AS VARCHAR(10))
                DECLARE @FiscalPeriodID INT
                
                SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@DepreciationPeriod)
                
                -- Create journal header
                INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy)
                VALUES (@JournalNumber, @BranchID, @DepreciationPeriod, 'Depreciation', 'Depreciation - ' + @AssetName, @FiscalPeriodID, 1, @ProcessedBy)
                
                SET @JournalID = SCOPE_IDENTITY()
                
                -- DR Depreciation Expense
                INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1)
                VALUES (@JournalID, 1, @ExpenseAccountID, @MonthlyDepreciation, 0, 'Depreciation expense', @AssetName)
                
                -- CR Accumulated Depreciation
                INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1)
                VALUES (@JournalID, 2, @DepreciationAccountID, 0, @MonthlyDepreciation, 'Accumulated depreciation', @AssetName)
            END
            
            -- Record depreciation history
            INSERT INTO DepreciationHistory (AssetID, DepreciationPeriod, DepreciationAmount, AccumulatedDepreciation, BookValue, JournalID, IsPosted, PostedDate, PostedBy, CreatedBy)
            VALUES (@AssetID, @DepreciationPeriod, @MonthlyDepreciation, @NewAccumulatedDep, @NewBookValue, @JournalID, @PostToGL, CASE WHEN @PostToGL = 1 THEN GETDATE() ELSE NULL END, CASE WHEN @PostToGL = 1 THEN @ProcessedBy ELSE NULL END, @ProcessedBy)
            
            -- Update asset
            UPDATE FixedAssets
            SET AccumulatedDepreciation = @NewAccumulatedDep,
                CurrentBookValue = @NewBookValue,
                LastDepreciationDate = @DepreciationPeriod,
                ModifiedBy = @ProcessedBy,
                ModifiedDate = GETDATE()
            WHERE AssetID = @AssetID
            
            SET @AssetsProcessed = @AssetsProcessed + 1
            SET @TotalDepreciation = @TotalDepreciation + @MonthlyDepreciation
            
            FETCH NEXT FROM asset_cursor INTO @AssetID, @AssetName, @BranchID, @AssetAccountID, @DepreciationAccountID, @ExpenseAccountID, @MonthlyDepreciation
        END
        
        CLOSE asset_cursor
        DEALLOCATE asset_cursor
        
        COMMIT TRANSACTION
        
        SELECT 
            @AssetsProcessed AS AssetsProcessed,
            @TotalDepreciation AS TotalDepreciation,
            'Depreciation processed successfully' AS Message
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        IF CURSOR_STATUS('global', 'asset_cursor') >= 0 
        BEGIN
            CLOSE asset_cursor
            DEALLOCATE asset_cursor
        END
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END
GO

PRINT '✓ Created sp_FixedAsset_ProcessDepreciation'
GO

-- =============================================
-- 6. GET FIXED ASSETS REGISTER
-- =============================================

IF OBJECT_ID('sp_FixedAsset_GetRegister', 'P') IS NOT NULL
    DROP PROCEDURE sp_FixedAsset_GetRegister
GO

CREATE PROCEDURE sp_FixedAsset_GetRegister
    @BranchID INT = NULL,
    @AssetCategory VARCHAR(50) = NULL,
    @IncludeDisposed BIT = 0
AS
BEGIN
    SET NOCOUNT ON
    
    SELECT 
        fa.AssetID,
        fa.AssetCode,
        fa.AssetName,
        fa.AssetCategory,
        fa.Description,
        fa.PurchaseDate,
        fa.PurchasePrice,
        fa.UsefulLifeYears,
        fa.SalvageValue,
        fa.DepreciationMethod,
        fa.CurrentBookValue,
        fa.AccumulatedDepreciation,
        fa.LastDepreciationDate,
        fa.BranchID,
        b.BranchName,
        fa.LocationDetails,
        fa.SerialNumber,
        fa.IsDisposed,
        fa.DisposalDate,
        fa.DisposalAmount,
        coa_asset.AccountName AS AssetAccount,
        coa_dep.AccountName AS DepreciationAccount,
        coa_exp.AccountName AS ExpenseAccount,
        DATEDIFF(MONTH, fa.PurchaseDate, ISNULL(fa.DisposalDate, GETDATE())) AS AgeMonths,
        fa.PurchasePrice - fa.CurrentBookValue AS TotalDepreciated
    FROM FixedAssets fa
    INNER JOIN Branches b ON fa.BranchID = b.BranchID
    INNER JOIN ChartOfAccounts coa_asset ON fa.AssetAccountID = coa_asset.AccountID
    INNER JOIN ChartOfAccounts coa_dep ON fa.DepreciationAccountID = coa_dep.AccountID
    INNER JOIN ChartOfAccounts coa_exp ON fa.ExpenseAccountID = coa_exp.AccountID
    WHERE fa.IsActive = 1
      AND (@BranchID IS NULL OR fa.BranchID = @BranchID)
      AND (@AssetCategory IS NULL OR fa.AssetCategory = @AssetCategory)
      AND (@IncludeDisposed = 1 OR fa.IsDisposed = 0)
    ORDER BY fa.AssetCategory, fa.AssetName
END
GO

PRINT '✓ Created sp_FixedAsset_GetRegister'
GO

-- =============================================
-- 7. DISPOSE FIXED ASSET
-- =============================================

IF OBJECT_ID('sp_FixedAsset_Dispose', 'P') IS NOT NULL
    DROP PROCEDURE sp_FixedAsset_Dispose
GO

CREATE PROCEDURE sp_FixedAsset_Dispose
    @AssetID INT,
    @DisposalDate DATE,
    @DisposalAmount DECIMAL(18,2),
    @DisposalNotes VARCHAR(500) = NULL,
    @PostToGL BIT = 1,
    @DisposedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @AssetName VARCHAR(200), @PurchasePrice DECIMAL(18,2), @AccumulatedDep DECIMAL(18,2)
        DECLARE @BranchID INT, @AssetAccountID INT, @DepreciationAccountID INT
        DECLARE @GainLossAmount DECIMAL(18,2), @BookValue DECIMAL(18,2)
        
        -- Get asset details
        SELECT 
            @AssetName = AssetName,
            @PurchasePrice = PurchasePrice,
            @AccumulatedDep = AccumulatedDepreciation,
            @BookValue = CurrentBookValue,
            @BranchID = BranchID,
            @AssetAccountID = AssetAccountID,
            @DepreciationAccountID = DepreciationAccountID
        FROM FixedAssets
        WHERE AssetID = @AssetID AND IsActive = 1 AND IsDisposed = 0
        
        IF @AssetName IS NULL
            THROW 50004, 'Asset not found or already disposed', 1
        
        -- Calculate gain/loss
        SET @GainLossAmount = @DisposalAmount - @BookValue
        
        -- Post disposal to GL
        IF @PostToGL = 1
        BEGIN
            DECLARE @JournalNumber VARCHAR(50) = 'DISP-' + CAST(@AssetID AS VARCHAR(10))
            DECLARE @FiscalPeriodID INT
            DECLARE @JournalID INT
            
            SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@DisposalDate)
            
            -- Create journal header
            INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy)
            VALUES (@JournalNumber, @BranchID, @DisposalDate, 'Asset Disposal', 'Disposal - ' + @AssetName, @FiscalPeriodID, 1, @DisposedBy)
            
            SET @JournalID = SCOPE_IDENTITY()
            
            DECLARE @LineNum INT = 1
            
            -- DR Cash/Bank (disposal proceeds)
            IF @DisposalAmount > 0
            BEGIN
                INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1)
                VALUES (@JournalID, @LineNum, 1010, @DisposalAmount, 0, 'Disposal proceeds', @AssetName) -- Assuming 1010 is bank
                SET @LineNum = @LineNum + 1
            END
            
            -- DR Accumulated Depreciation
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1)
            VALUES (@JournalID, @LineNum, @DepreciationAccountID, @AccumulatedDep, 0, 'Remove accumulated depreciation', @AssetName)
            SET @LineNum = @LineNum + 1
            
            -- CR Asset Account
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1)
            VALUES (@JournalID, @LineNum, @AssetAccountID, 0, @PurchasePrice, 'Remove asset', @AssetName)
            SET @LineNum = @LineNum + 1
            
            -- DR/CR Gain or Loss on Disposal
            IF @GainLossAmount <> 0
            BEGIN
                DECLARE @GainLossAccountID INT = 7500 -- Assuming 7500 is Gain/Loss on Asset Disposal
                
                IF @GainLossAmount > 0 -- Gain
                BEGIN
                    INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1)
                    VALUES (@JournalID, @LineNum, @GainLossAccountID, 0, ABS(@GainLossAmount), 'Gain on disposal', @AssetName)
                END
                ELSE -- Loss
                BEGIN
                    INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1)
                    VALUES (@JournalID, @LineNum, @GainLossAccountID, ABS(@GainLossAmount), 0, 'Loss on disposal', @AssetName)
                END
            END
        END
        
        -- Mark asset as disposed
        UPDATE FixedAssets
        SET IsDisposed = 1,
            DisposalDate = @DisposalDate,
            DisposalAmount = @DisposalAmount,
            DisposalNotes = @DisposalNotes,
            ModifiedBy = @DisposedBy,
            ModifiedDate = GETDATE()
        WHERE AssetID = @AssetID
        
        COMMIT TRANSACTION
        
        SELECT 
            @AssetID AS AssetID,
            @GainLossAmount AS GainLossAmount,
            CASE WHEN @GainLossAmount > 0 THEN 'Gain' WHEN @GainLossAmount < 0 THEN 'Loss' ELSE 'No Gain/Loss' END AS GainLossType,
            'Asset disposed successfully' AS Message
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END
GO

PRINT '✓ Created sp_FixedAsset_Dispose'
GO

PRINT ''
PRINT '========================================='
PRINT 'FIXED ASSETS SYSTEM COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Usage Examples:'
PRINT ''
PRINT '-- Add a new asset:'
PRINT 'DECLARE @AssetID INT'
PRINT 'EXEC sp_FixedAsset_Add'
PRINT '  @AssetCode = ''EQUIP-001'','
PRINT '  @AssetName = ''Industrial Oven'','
PRINT '  @AssetCategory = ''Equipment'','
PRINT '  @PurchaseDate = ''2026-01-15'','
PRINT '  @PurchasePrice = 150000,'
PRINT '  @BranchID = 1,'
PRINT '  @UsefulLifeYears = 10,'
PRINT '  @SalvageValue = 15000,'
PRINT '  @AssetAccountID = 1510,'
PRINT '  @DepreciationAccountID = 1520,'
PRINT '  @ExpenseAccountID = 6200,'
PRINT '  @CreatedBy = 1,'
PRINT '  @AssetID = @AssetID OUTPUT'
PRINT ''
PRINT '-- Process monthly depreciation:'
PRINT 'EXEC sp_FixedAsset_ProcessDepreciation'
PRINT '  @DepreciationPeriod = ''2026-01-31'','
PRINT '  @PostToGL = 1,'
PRINT '  @ProcessedBy = 1'
PRINT ''
PRINT '-- View assets register:'
PRINT 'EXEC sp_FixedAsset_GetRegister'
PRINT ''
