-- =============================================
-- Create stored procedure for getting all branches
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Branch_GetAll')
BEGIN
    EXEC('CREATE PROCEDURE [dbo].[sp_Branch_GetAll] AS BEGIN SET NOCOUNT ON; SELECT * FROM Branches WHERE 1=0; END')
    PRINT 'Created empty sp_Branch_GetAll procedure'
END
GO

ALTER PROCEDURE [dbo].[sp_Branch_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ID,
        BranchName,
        BranchCode,
        Prefix,
        Address,
        City,
        Province,
        PostalCode,
        Phone,
        Email,
        ManagerName,
        IsActive,
        CreatedDate,
        ModifiedDate,
        CreatedBy,
        ModifiedBy
    FROM 
        Branches
    ORDER BY 
        BranchName;
END
GO

PRINT 'sp_Branch_GetAll procedure created/updated successfully'
GO
