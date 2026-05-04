-- Fix sp_CreateReOrderBook to use 'Pending' status instead of 'Draft'
-- This matches the original ReOrderBooks Status constraint

USE OvenDelightsERP
GO

PRINT 'Fixing sp_CreateReOrderBook stored procedure...'
GO

CREATE OR ALTER PROCEDURE sp_CreateReOrderBook
    @BranchID INT,
    @ManufacturerUserID INT,
    @OrderDate DATETIME,
    @RequiredDate DATETIME,
    @CreatedBy NVARCHAR(100),
    @IsUrgent BIT,
    @Notes NVARCHAR(500),
    @ReOrderBookID INT OUTPUT,
    @ReOrderNumber NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @BranchPrefix NVARCHAR(10)
    SELECT @BranchPrefix = ISNULL(Prefix, 'BR') FROM Branches WHERE BranchID = @BranchID
    
    SET @ReOrderNumber = 'RO-' + @BranchPrefix + '-' + FORMAT(GETDATE(), 'yyyyMMdd-HHmmss')
    
    INSERT INTO ReOrderBooks (
        ReOrderNumber, ManufacturerUserID, BranchID, OrderDate, RequiredDate,
        IsUrgent, Status, Notes, CreatedBy, CreatedDate
    )
    VALUES (
        @ReOrderNumber, @ManufacturerUserID, @BranchID, @OrderDate, @RequiredDate,
        @IsUrgent, 'Posted', @Notes, @ManufacturerUserID, GETDATE()
    )
    
    SET @ReOrderBookID = SCOPE_IDENTITY()
END
GO

PRINT '✓ sp_CreateReOrderBook fixed - now uses Status = ''Pending'''
GO
