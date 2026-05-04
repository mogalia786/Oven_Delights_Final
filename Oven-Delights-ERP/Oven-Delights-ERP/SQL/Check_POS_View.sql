-- Check if vw_POS_Products view exists
IF OBJECT_ID('vw_POS_Products', 'V') IS NOT NULL
BEGIN
    PRINT 'View vw_POS_Products EXISTS';
    
    -- Show view definition
    SELECT OBJECT_DEFINITION(OBJECT_ID('vw_POS_Products')) AS ViewDefinition;
    
    -- Check data in view
    SELECT 
        BranchID,
        COUNT(*) AS ProductCount
    FROM vw_POS_Products
    GROUP BY BranchID;
    
    -- Sample data
    SELECT TOP 10 * FROM vw_POS_Products WHERE BranchID = 6;
    SELECT TOP 10 * FROM vw_POS_Products WHERE BranchID = 4;
END
ELSE
BEGIN
    PRINT 'View vw_POS_Products DOES NOT EXIST - Need to create it!';
END
