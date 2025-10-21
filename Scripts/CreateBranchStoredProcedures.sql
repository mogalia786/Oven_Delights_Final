-- =============================================
-- Create stored procedure for saving/updating a branch
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Branch_Save')
BEGIN
    EXEC('CREATE PROCEDURE [dbo].[sp_Branch_Save] AS BEGIN SET NOCOUNT ON; END')
    PRINT 'Created empty sp_Branch_Save procedure'
END
GO

ALTER PROCEDURE [dbo].[sp_Branch_Save]
    @ID INT = NULL,
    @BranchName NVARCHAR(100),
    @BranchCode NVARCHAR(20),
    @Prefix NVARCHAR(10),
    @Address NVARCHAR(255) = NULL,
    @City NVARCHAR(100) = NULL,
    @Province NVARCHAR(100) = NULL,
    @PostalCode NVARCHAR(20) = NULL,
    @Phone NVARCHAR(20) = NULL,
    @Email NVARCHAR(128) = NULL,
    @ManagerName NVARCHAR(100) = NULL,
    @IsActive BIT = 1,
    @CurrentUserID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF @ID IS NULL OR @ID = 0
        BEGIN
            -- Insert new branch
            INSERT INTO Branches (
                BranchName, BranchCode, Prefix, Address, City, 
                Province, PostalCode, Phone, Email, ManagerName, 
                IsActive, CreatedBy, CreatedDate
            ) VALUES (
                @BranchName, @BranchCode, @Prefix, @Address, @City,
                @Province, @PostalCode, @Phone, @Email, @ManagerName,
                @IsActive, @CurrentUserID, GETDATE()
            )
            
            SELECT SCOPE_IDENTITY() AS NewID
        END
        ELSE
        BEGIN
            -- Update existing branch
            UPDATE Branches SET
                BranchName = @BranchName,
                BranchCode = @BranchCode,
                Prefix = @Prefix,
                Address = @Address,
                City = @City,
                Province = @Province,
                PostalCode = @PostalCode,
                Phone = @Phone,
                Email = @Email,
                ManagerName = @ManagerName,
                IsActive = @IsActive,
                ModifiedBy = @CurrentUserID,
                ModifiedDate = GETDATE()
            WHERE ID = @ID
            
            SELECT @ID AS NewID
        END
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO

PRINT 'sp_Branch_Save procedure created/updated successfully'
GO
