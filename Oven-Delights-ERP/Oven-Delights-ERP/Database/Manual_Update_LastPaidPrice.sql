-- Manual test to update LastPaidPrice for a specific material
-- This will help verify the update mechanism works

-- Step 1: Find a material you're testing with
SELECT TOP 5 
    MaterialID, 
    MaterialCode, 
    MaterialName,
    LastPaidPrice,
    LastCost
FROM RawMaterials
ORDER BY MaterialName
GO

-- Step 2: Manually update LastPaidPrice for MaterialID 2155 (Almond Essence from your screenshot)
-- Replace 2155 with the MaterialID you're testing and 123.45 with the price you entered
UPDATE RawMaterials 
SET LastPaidPrice = 123.45, LastPurchaseDate = GETDATE() 
WHERE MaterialID = 2155
GO

-- Step 3: Verify the update
SELECT MaterialID, MaterialCode, MaterialName, LastPaidPrice, LastPurchaseDate
FROM RawMaterials 
WHERE MaterialID = 2155
GO

-- Step 4: Now create a new PO for this material and check if "Last Paid" shows 123.45
