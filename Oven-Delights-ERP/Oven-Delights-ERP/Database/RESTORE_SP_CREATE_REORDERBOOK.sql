-- Restore the original sp_CreateReOrderBook stored procedure
CREATE OR ALTER PROCEDURE sp_CreateReOrderBook
    @BranchID INT,
    @ManufacturerUserID INT,
    @OrderDate DATETIME,
    @RequiredDate DATETIME,
    @CreatedBy NVARCHAR(100),
    @IsUrgent BIT,
    @Notes NVARCHAR(MAX) = NULL,
    @ReOrderBookID INT OUTPUT,
    @ReOrderNumber NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @BranchPrefix NVARCHAR(10)
    DECLARE @NextNumber INT
    
    -- Get branch prefix (use BranchID if BranchCode is not numeric-friendly)
    SELECT @BranchPrefix = ISNULL(BranchCode, 'B' + CAST(@BranchID AS NVARCHAR))
    FROM Branches 
    WHERE BranchID = @BranchID
    
    -- If BranchCode is too long or contains spaces, use simple prefix
    IF LEN(@BranchPrefix) > 5 OR @BranchPrefix LIKE '% %'
        SET @BranchPrefix = 'B' + CAST(@BranchID AS NVARCHAR)
    
    -- Get next re-order book number for this branch
    SELECT @NextNumber = ISNULL(MAX(
        CASE 
            WHEN ReOrderNumber LIKE @BranchPrefix + '-RO-%' 
            THEN TRY_CAST(SUBSTRING(ReOrderNumber, LEN(@BranchPrefix) + 5, LEN(ReOrderNumber)) AS INT)
            ELSE 0
        END
    ), 0) + 1
    FROM ReOrderBooks
    WHERE BranchID = @BranchID
    
    -- Generate re-order number
    SET @ReOrderNumber = @BranchPrefix + '-RO-' + RIGHT('000000' + CAST(@NextNumber AS NVARCHAR), 6)
    
    -- Get manufacturer name
    DECLARE @ManufacturerName NVARCHAR(200)
    SELECT @ManufacturerName = FirstName + ' ' + LastName
    FROM Users
    WHERE UserID = @ManufacturerUserID
    
    -- Insert re-order book
    INSERT INTO ReOrderBooks (
        ReOrderNumber,
        BranchID,
        ManufacturerUserID,
        ManufacturerName,
        OrderDate,
        RequiredDate,
        Status,
        Priority,
        Notes,
        CreatedBy,
        CreatedDate,
        TotalProducts,
        TotalQuantity
    )
    VALUES (
        @ReOrderNumber,
        @BranchID,
        @ManufacturerUserID,
        @ManufacturerName,
        @OrderDate,
        @RequiredDate,
        'Pending',
        CASE WHEN @IsUrgent = 1 THEN 'Urgent' ELSE 'Normal' END,
        @Notes,
        @CreatedBy,
        GETDATE(),
        0,
        0
    )
    
    SET @ReOrderBookID = SCOPE_IDENTITY()
END
GO
