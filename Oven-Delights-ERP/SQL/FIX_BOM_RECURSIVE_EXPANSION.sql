-- =============================================
-- CRITICAL FIX: Recursive BOM Expansion
-- This ensures ALL raw materials are shown, even from sub-assemblies
-- =============================================

-- Drop and recreate the stored procedure with recursive expansion
IF OBJECT_ID('dbo.sp_MO_CreateBundleFromBOM', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_MO_CreateBundleFromBOM;
GO

CREATE PROCEDURE dbo.sp_MO_CreateBundleFromBOM
    @Items dbo.BOMRequestItem READONLY,
    @BranchID INT = NULL,
    @UserID INT = NULL,
    @FromLocationCode NVARCHAR(50) = 'STOCKROOM',
    @ToLocationCode NVARCHAR(50) = 'MFG'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get LocationIDs from LocationCode
    DECLARE @FromLocationID INT;
    DECLARE @ToLocationID INT;
    
    SELECT @FromLocationID = LocationID 
    FROM InventoryLocations 
    WHERE LocationCode = @FromLocationCode 
    AND (@BranchID IS NULL OR BranchID = @BranchID)
    AND IsActive = 1;
    
    SELECT @ToLocationID = LocationID 
    FROM InventoryLocations 
    WHERE LocationCode = @ToLocationCode 
    AND (@BranchID IS NULL OR BranchID = @BranchID)
    AND IsActive = 1;
    
    IF @FromLocationID IS NULL
    BEGIN
        RAISERROR('Invalid From location: %s for BranchID %d', 16, 1, @FromLocationCode, @BranchID);
        RETURN;
    END
    
    IF @ToLocationID IS NULL
    BEGIN
        RAISERROR('Invalid To location: %s for BranchID %d', 16, 1, @ToLocationCode, @BranchID);
        RETURN;
    END
    
    -- Create temp table for aggregated components with RECURSIVE expansion
    CREATE TABLE #AggregatedComponents (
        ComponentType NVARCHAR(50),
        RawMaterialID INT NULL,
        ComponentProductID INT NULL,
        ComponentName NVARCHAR(255),
        TotalQty DECIMAL(18,4),
        UoM NVARCHAR(50),
        LineNumber INT
    );
    
    -- Recursive CTE to expand ALL sub-assemblies into raw materials
    WITH RecursiveBOM AS (
        -- Level 0: Direct components from requested products
        SELECT 
            bi.ComponentType,
            bi.RawMaterialID,
            bi.ComponentProductID,
            bi.NonStockDesc,
            bi.QuantityPerBatch * i.OutputQty / bh.BatchYieldQty AS TotalQty,
            bi.UoM,
            0 AS Level,
            bi.ComponentProductID AS SubAssemblyID
        FROM @Items i
        INNER JOIN BOMHeader bh ON bh.ProductID = i.ProductID AND bh.IsActive = 1
        INNER JOIN BOMItems bi ON bi.BOMID = bh.BOMID
        
        UNION ALL
        
        -- Recursive: Expand sub-assemblies (NO LEFT JOIN allowed in recursive part)
        SELECT 
            bi2.ComponentType,
            bi2.RawMaterialID,
            bi2.ComponentProductID,
            bi2.NonStockDesc,
            rb.TotalQty * bi2.QuantityPerBatch / bh2.BatchYieldQty AS TotalQty,
            bi2.UoM,
            rb.Level + 1,
            bi2.ComponentProductID
        FROM RecursiveBOM rb
        INNER JOIN BOMHeader bh2 ON bh2.ProductID = rb.SubAssemblyID AND bh2.IsActive = 1
        INNER JOIN BOMItems bi2 ON bi2.BOMID = bh2.BOMID
        WHERE rb.ComponentType = 'Product' -- Only expand products (sub-assemblies)
        AND rb.Level < 10 -- Prevent infinite recursion
    )
    
    -- Now join to get names AFTER the recursion
    INSERT INTO #AggregatedComponents
    SELECT 
        rb.ComponentType,
        rb.RawMaterialID,
        rb.ComponentProductID,
        CASE 
            WHEN rb.ComponentType = 'RawMaterial' THEN rm.MaterialName
            WHEN rb.ComponentType = 'Product' THEN p.Name
            ELSE rb.NonStockDesc
        END AS ComponentName,
        SUM(rb.TotalQty) AS TotalQty,
        MAX(rb.UoM) AS UoM,
        ROW_NUMBER() OVER (ORDER BY 
            CASE 
                WHEN rb.ComponentType = 'RawMaterial' THEN rm.MaterialName
                WHEN rb.ComponentType = 'Product' THEN p.Name
                ELSE rb.NonStockDesc
            END
        ) AS LineNumber
    FROM RecursiveBOM rb
    LEFT JOIN RawMaterials rm ON rm.MaterialID = rb.RawMaterialID
    LEFT JOIN dbo.Demo_Retail_Product p ON p.ProductID = rb.ComponentProductID
    WHERE rb.ComponentType = 'RawMaterial' -- Only include raw materials in final list
    GROUP BY rb.ComponentType, rb.RawMaterialID, rb.ComponentProductID, rb.NonStockDesc, rm.MaterialName, p.Name;
    
    -- Create Internal Order Header
    DECLARE @InternalOrderID INT;
    DECLARE @InternalOrderNo NVARCHAR(50);
    
    -- Generate order number
    SET @InternalOrderNo = 'BOM-' + FORMAT(GETDATE(), 'yyyyMMdd') + '-' + 
                           RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS NVARCHAR), 4);
    
    INSERT INTO InternalOrderHeader (
        InternalOrderNo,
        BranchID,
        RequestedBy,
        RequestedDate,
        Status,
        FromLocationID,
        ToLocationID,
        Notes
    )
    VALUES (
        @InternalOrderNo,
        @BranchID,
        @UserID,
        GETDATE(),
        'Open',
        @FromLocationID,
        @ToLocationID,
        'BOM Request - Recursive expansion'
    );
    
    SET @InternalOrderID = SCOPE_IDENTITY();
    
    -- Insert raw material lines (what's needed from stockroom)
    INSERT INTO InternalOrderLines (
        InternalOrderID,
        LineNumber,
        ItemType,
        RawMaterialID,
        ProductID,
        Quantity,
        UoM,
        Notes
    )
    SELECT 
        @InternalOrderID,
        LineNumber,
        'RawMaterial',
        RawMaterialID,
        ComponentProductID,
        TotalQty,
        UoM,
        'Aggregated from BOM bundle'
    FROM #AggregatedComponents
    ORDER BY LineNumber;
    
    -- Insert finished product lines (what will be manufactured)
    DECLARE @MaxLineNumber INT = (SELECT ISNULL(MAX(LineNumber), 0) FROM #AggregatedComponents);
    
    INSERT INTO InternalOrderLines (
        InternalOrderID,
        LineNumber,
        ItemType,
        ProductID,
        Quantity,
        UoM,
        Notes
    )
    SELECT 
        @InternalOrderID,
        @MaxLineNumber + ROW_NUMBER() OVER (ORDER BY ProductID),
        'Finished',
        ProductID,
        OutputQty,
        'ea',
        'Finished product from BOM'
    FROM @Items;
    
    -- Return header and lines
    SELECT 
        @InternalOrderID AS InternalOrderID,
        @InternalOrderNo AS InternalOrderNumber,
        @BranchID AS BranchID,
        @FromLocationID AS FromLocationID,
        @ToLocationID AS ToLocationID,
        COUNT(*) AS TotalLines
    FROM #AggregatedComponents;
    
    SELECT 
        LineNumber,
        ComponentType,
        RawMaterialID,
        ComponentProductID,
        ComponentName,
        TotalQty,
        UoM
    FROM #AggregatedComponents
    ORDER BY LineNumber;
    
    DROP TABLE #AggregatedComponents;
END
GO

PRINT 'Stored procedure sp_MO_CreateBundleFromBOM created with RECURSIVE expansion!';
