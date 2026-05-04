-- REVERT SellingPrice column to allow NULL values
-- This fixes the invoice capture error

PRINT 'Making SellingPrice column nullable again...'

ALTER TABLE Demo_Retail_Price 
ALTER COLUMN SellingPrice DECIMAL(18,2) NULL

PRINT '✓ SellingPrice column now allows NULL values'
PRINT ''
PRINT 'Invoice capture should work now!'
