-- Import ALL Candle products
-- Generated: 2025-12-07 01:34:55

BEGIN TRANSACTION;

COMMIT TRANSACTION;

PRINT 'Candle product import completed!';
PRINT 'Total Candle products processed: 0';

-- Show results
SELECT COUNT(*) AS TotalCandleProducts
FROM Demo_Retail_Product
WHERE Category = 'candle' AND IsActive = 1;

