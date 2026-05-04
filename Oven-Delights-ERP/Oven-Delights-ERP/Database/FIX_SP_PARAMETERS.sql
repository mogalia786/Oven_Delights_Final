-- Check current parameters
SELECT 
    p.name AS ParameterName,
    TYPE_NAME(p.user_type_id) AS DataType,
    p.max_length,
    p.is_output
FROM sys.parameters p
WHERE p.object_id = OBJECT_ID('sp_CreateReOrderBook')
ORDER BY p.parameter_id

-- The form passes these parameters:
-- @BranchID INT
-- @ManufacturerUserID INT
-- @OrderDate DATETIME
-- @RequiredDate DATETIME
-- @CreatedBy NVARCHAR
-- @IsUrgent BIT
-- @Notes NVARCHAR
-- @ReOrderBookID INT OUTPUT
-- @ReOrderNumber NVARCHAR(50) OUTPUT
