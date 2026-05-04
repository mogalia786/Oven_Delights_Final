-- Get the full definition of vw_POS_Products view
EXEC sp_helptext 'vw_POS_Products';

-- First, see what columns exist in the view
SELECT TOP 5 *
FROM vw_POS_Products;

-- Then check for Bar One Slice (using wildcard to find the right column)
SELECT TOP 10 *
FROM vw_POS_Products
WHERE CAST(ProductID AS VARCHAR) LIKE '%56082%'
   OR CAST(ProductID AS VARCHAR) LIKE '%57390%';
