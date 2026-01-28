-- =============================================
-- Manufacturing to Retail Transfer GL Integration
-- =============================================

-- =============================================
-- sp_MFG_PostManufacturingToRetailTransfer - Post finished goods transfer to retail
-- =============================================
CREATE OR ALTER PROCEDURE sp_MFG_PostManufacturingToRetailTransfer
    @TransferID INT,
    @TransferNumber NVARCHAR(50),
    @TransferDate DATE,
    @ProductName NVARCHAR(200),
    @BranchID INT,
    @TotalValue DECIMAL(18,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @RetailInventoryAccountID INT
        DECLARE @ManufacturingInventoryAccountID INT
        
        -- Get account IDs
        SELECT @RetailInventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        SELECT @ManufacturingInventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1210' AND IsActive = 1
        
        -- Validate accounts exist
        IF @RetailInventoryAccountID IS NULL
            RAISERROR('Retail Inventory account 1220 not found or inactive', 16, 1)
            
        IF @ManufacturingInventoryAccountID IS NULL
            RAISERROR('Manufacturing Inventory account 1210 not found or inactive', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'MFG-' + @TransferNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @TransferDate,
            @TransferNumber,
            'Manufacturing to Retail - ' + @ProductName,
            dbo.fn_GetCurrentFiscalPeriodID(@TransferDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: Retail Inventory (Finished goods ready for sale)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 1, @RetailInventoryAccountID, @TotalValue, 0,
            'Finished Goods to Retail', @TransferNumber, @ProductName
        )
        
        -- Credit: Manufacturing Inventory (Reduce manufacturing stock)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 2, @ManufacturingInventoryAccountID, 0, @TotalValue,
            'Transfer from Manufacturing', @TransferNumber, @ProductName
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Manufacturing to Retail transfer posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'Manufacturing to Retail Transfer procedure created successfully'
GO
