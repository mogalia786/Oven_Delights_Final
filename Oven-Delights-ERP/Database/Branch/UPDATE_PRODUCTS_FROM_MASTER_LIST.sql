-- =============================================
-- AUTO-GENERATED: UPDATE PRODUCTS FROM MASTER LIST
-- Generated: 11/20/2025 00:07:51
-- Source: MASTER_PRODUCT_LIST.csv
-- =============================================

PRINT '========================================';
PRINT 'UPDATING PRODUCTS FROM MASTER LIST';
PRINT '========================================';
PRINT '';

BEGIN TRANSACTION;
-- Update or Insert: BIS- CHC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS- CHC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Choc Chip',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS- CHC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS- CHC-EAC', 'Biscuit Choc Chip', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-ABB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-ABB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Assorted Pure Butter',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-ABB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-ABB-EAC', 'Biscuit Assorted Pure Butter', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-BCV-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-BCV-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Choc Vanilla 300g',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-BCV-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-BCV-EAC', 'Biscuit Choc Vanilla 300g', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-BUB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-BUB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Butter Biscuit',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-BUB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-BUB-EAC', 'Biscuit Butter Biscuit', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-CCC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-CCC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Choc Chip Cookie',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-CCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-CCC-EAC', 'Biscuit Choc Chip Cookie', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-CHD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-CHD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Choc Delights 300G',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-CHD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-CHD-EAC', 'Biscuit Choc Delights 300G', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-CJN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-CJN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Jam Nest 300G',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 43.48,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-CJN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-CJN-EAC', 'Biscuit Jam Nest 300G', 85.00, 85.00, 43.48, 'internal', 1);
END

-- Update or Insert: BIS-COC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-COC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Coconut',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-COC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-COC-EAC', 'Biscuit Coconut', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-CRU-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-CRU-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'GLUTEN FREE RUSKS',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-CRU-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-CRU-EACH', 'GLUTEN FREE RUSKS', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-CUS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-CUS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Custard',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-CUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-CUS-EAC', 'Biscuit Custard', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-DAT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-DAT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Date Roll 300G',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-DAT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-DAT-EAC', 'Biscuit Date Roll 300G', 100.00, 100.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-DEB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-DEB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Designer Biscuits 300G',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-DEB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-DEB-EAC', 'Designer Biscuits 300G', 100.00, 100.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-FEB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-FEB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Fego 300G',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-FEB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-FEB-EAC', 'Biscuit Fego 300G', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-FLF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-FLF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit choc Fingers 300G',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-FLF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-FLF-EAC', 'Biscuit choc Fingers 300G', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-HSB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-HSB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Horse Shoe 300G',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-HSB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-HSB-EAC', 'Biscuit Horse Shoe 300G', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-NAK-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-NAK-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Naan Katai 300G',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-NAK-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-NAK-EAC', 'Biscuit Naan Katai 300G', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-PAO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-PAO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Pcn & almnd 300G',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-PAO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-PAO-EAC', 'Biscuit Pcn & almnd 300G', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-PNS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-PNS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Pecan Nut Squares 300G',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-PNS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-PNS-EAC', 'Biscuit Pecan Nut Squares 300G', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-RMC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-RMC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Romany Creams',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-RMC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-RMC-EAC', 'Biscuit Romany Creams', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-ROC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-ROC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Romany Creams',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-ROC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-ROC-EAC', 'Biscuit Romany Creams', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: BIS-SBB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'BIS-SBB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Short Bread',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'BIS-SBB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('BIS-SBB-EAC', 'Biscuit Short Bread', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CAN-CMS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-CMS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candles 10s- Silver',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-CMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-CMS-EAC', 'Candles 10s- Silver', 20.00, 20.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-DOU-010
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-DOU-010')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral Double',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-DOU-010';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-DOU-010', 'Candle Numeral Double', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-DOU-080
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-DOU-080')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral Double',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-DOU-080';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-DOU-080', 'Candle Numeral Double', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-GOL-000
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-GOL-000')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 0 Gold',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-GOL-000';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-GOL-000', 'Candle Numeral 0 Gold', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-GOL-001
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-GOL-001')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 1 Gold',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-GOL-001';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-GOL-001', 'Candle Numeral 1 Gold', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-GOL-002
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-GOL-002')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 2 Gold',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-GOL-002';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-GOL-002', 'Candle Numeral 2 Gold', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-GOL-003
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-GOL-003')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 3 Gold',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-GOL-003';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-GOL-003', 'Candle Numeral 3 Gold', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-GOL-004
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-GOL-004')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 4 Gold',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-GOL-004';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-GOL-004', 'Candle Numeral 4 Gold', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-GOL-005
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-GOL-005')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 5 Gold',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-GOL-005';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-GOL-005', 'Candle Numeral 5 Gold', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-GOL-006
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-GOL-006')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 6 Gold',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-GOL-006';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-GOL-006', 'Candle Numeral 6 Gold', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-GOL-007
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-GOL-007')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 7 Gold',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-GOL-007';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-GOL-007', 'Candle Numeral 7 Gold', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-GOL-008
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-GOL-008')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 8 Gold',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-GOL-008';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-GOL-008', 'Candle Numeral 8 Gold', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-GOL-009
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-GOL-009')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 9 Gold',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-GOL-009';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-GOL-009', 'Candle Numeral 9 Gold', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-MAG-24S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-MAG-24S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Magic Assorted',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-MAG-24S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-MAG-24S', 'Candle Magic Assorted', 30.00, 30.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-MCA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-MCA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Magic Candles',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-MCA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-MCA-EAC', 'Magic Candles', 30.00, 30.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-MIX-24S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-MIX-24S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Mixed - 24x24',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-MIX-24S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-MIX-24S', 'Candle Mixed - 24x24', 30.00, 30.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-RAI-000
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-RAI-000')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 0 Rainbow',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-RAI-000';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-RAI-000', 'Candle Numeral 0 Rainbow', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-RAI-001
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-RAI-001')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 1 Rainbow',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-RAI-001';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-RAI-001', 'Candle Numeral 1 Rainbow', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-RAI-002
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-RAI-002')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 2 Rainbow',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 43.50,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-RAI-002';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-RAI-002', 'Candle Numeral 2 Rainbow', 22.00, 22.00, 43.50, 'external', 1);
END

-- Update or Insert: CAN-RAI-003
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-RAI-003')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 3 Rainbow',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 7.19,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-RAI-003';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-RAI-003', 'Candle Numeral 3 Rainbow', 13.00, 13.00, 7.19, 'external', 1);
END

-- Update or Insert: CAN-RAI-004
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-RAI-004')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 4 Rainbow',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-RAI-004';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-RAI-004', 'Candle Numeral 4 Rainbow', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-RAI-005
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-RAI-005')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 5 Rainbow',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-RAI-005';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-RAI-005', 'Candle Numeral 5 Rainbow', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-RAI-006
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-RAI-006')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 6 Rainbow',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-RAI-006';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-RAI-006', 'Candle Numeral 6 Rainbow', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-RAI-007
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-RAI-007')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 7 Rainbow',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-RAI-007';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-RAI-007', 'Candle Numeral 7 Rainbow', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-RAI-009
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-RAI-009')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 9 Rainbow',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-RAI-009';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-RAI-009', 'Candle Numeral 9 Rainbow', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-SIL-000
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-SIL-000')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 0 Silver',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-SIL-000';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-SIL-000', 'Candle Numeral 0 Silver', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-SIL-001
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-SIL-001')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 1 Silver',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-SIL-001';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-SIL-001', 'Candle Numeral 1 Silver', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-SIL-002
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-SIL-002')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 2 Silver',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-SIL-002';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-SIL-002', 'Candle Numeral 2 Silver', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-SIL-003
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-SIL-003')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 3 Silver',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-SIL-003';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-SIL-003', 'Candle Numeral 3 Silver', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-SIL-004
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-SIL-004')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 4 Silver',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-SIL-004';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-SIL-004', 'Candle Numeral 4 Silver', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-SIL-005
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-SIL-005')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 5 Silver',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-SIL-005';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-SIL-005', 'Candle Numeral 5 Silver', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-SIL-006
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-SIL-006')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 6 Silver',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-SIL-006';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-SIL-006', 'Candle Numeral 6 Silver', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-SIL-007
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-SIL-007')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 7 Silver',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-SIL-007';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-SIL-007', 'Candle Numeral 7 Silver', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-SIL-008
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-SIL-008')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 8 Silver',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-SIL-008';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-SIL-008', 'Candle Numeral 8 Silver', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-SIL-009
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-SIL-009')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 9 Silver',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-SIL-009';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-SIL-009', 'Candle Numeral 9 Silver', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-WHI-000
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-WHI-000')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 0 White',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-WHI-000';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-WHI-000', 'Candle Numeral 0 White', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-WHI-001
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-WHI-001')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 1 White',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-WHI-001';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-WHI-001', 'Candle Numeral 1 White', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-WHI-002
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-WHI-002')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 2 White',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-WHI-002';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-WHI-002', 'Candle Numeral 2 White', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-WHI-003
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-WHI-003')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 3 White',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-WHI-003';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-WHI-003', 'Candle Numeral 3 White', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-WHI-004
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-WHI-004')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 4 White',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-WHI-004';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-WHI-004', 'Candle Numeral 4 White', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-WHI-005
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-WHI-005')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 5 White',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-WHI-005';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-WHI-005', 'Candle Numeral 5 White', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-WHI-006
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-WHI-006')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 6 White',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-WHI-006';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-WHI-006', 'Candle Numeral 6 White', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-WHI-007
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-WHI-007')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 7 White',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-WHI-007';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-WHI-007', 'Candle Numeral 7 White', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-WHI-008
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-WHI-008')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 8 White',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-WHI-008';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-WHI-008', 'Candle Numeral 8 White', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CAN-WHI-009
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CAN-WHI-009')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Numeral 9 White',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CAN-WHI-009';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CAN-WHI-009', 'Candle Numeral 9 White', 22.00, 22.00, 0.00, 'external', 1);
END

-- Update or Insert: CBA-BAC-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBA-BAC-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 14'''' Buttercream Alphabet Cake',
        RecommendedSellingPrice = 640.00,
        LastPaidPrice = 640.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CBA-BAC-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBA-BAC-014', 'BD 14'''' Buttercream Alphabet Cake', 640.00, 640.00, 0.00, 'internal', 1);
END

-- Update or Insert: CBA-BEA-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBA-BEA-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 16'''' Eggless Buttercream Alphabet Cake',
        RecommendedSellingPrice = 830.00,
        LastPaidPrice = 830.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CBA-BEA-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBA-BEA-016', 'BD 16'''' Eggless Buttercream Alphabet Cake', 830.00, 830.00, 0.00, 'internal', 1);
END

-- Update or Insert: CBC-BBG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BBG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Birthday Gateaux',
        RecommendedSellingPrice = 120.00,
        LastPaidPrice = 120.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BBG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BBG-EAC', 'BC Birthday Gateaux', 120.00, 120.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-BCC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BCC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Icing Cup Cakes',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BCC-EAC', 'Icing Cup Cakes', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-BCD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BCD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Chocolate Delight',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BCD-EAC', 'BC Chocolate Delight', 22.00, 22.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-BCE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BCE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Eggless Vanilla Gateaux',
        RecommendedSellingPrice = 120.00,
        LastPaidPrice = 120.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BCE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BCE-EAC', 'BC Eggless Vanilla Gateaux', 120.00, 120.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-BCG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BCG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Chocolate Gateaux',
        RecommendedSellingPrice = 125.00,
        LastPaidPrice = 125.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BCG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BCG-EAC', 'BC Chocolate Gateaux', 125.00, 125.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-BCN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BCN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Icing Cup Cakes With Name',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BCN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BCN-EAC', 'Icing Cup Cakes With Name', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-BCS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BCS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Chocolate Slice',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BCS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BCS-EAC', 'BC Chocolate Slice', 22.00, 22.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-BDN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BDN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Doughnut',
        RecommendedSellingPrice = 16.00,
        LastPaidPrice = 16.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BDN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BDN-EAC', 'BC Doughnut', 16.00, 16.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-BEG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BEG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Eggless Birthday Gateaux',
        RecommendedSellingPrice = 125.00,
        LastPaidPrice = 125.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BEG-EAC', 'BC Eggless Birthday Gateaux', 125.00, 125.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-BET-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BET-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Triple Layer Eggless Drip Gateaux',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BET-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BET-EAC', 'BC Triple Layer Eggless Drip Gateaux', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-BRG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BRG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Smash Choc Rose Pattern Gateaux',
        RecommendedSellingPrice = 600,
        LastPaidPrice = 600,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BRG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BRG-EAC', 'BC Smash Choc Rose Pattern Gateaux', 600, 600, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-BTD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-BTD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Triple Layer Drip Gateaux',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-BTD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-BTD-EAC', 'BC Triple Layer Drip Gateaux', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-CBG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-CBG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Buttercream Gateaux',
        RecommendedSellingPrice = 160.00,
        LastPaidPrice = 160.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-CBG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-CBG-EAC', 'Christmas Buttercream Gateaux', 160.00, 160.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-CDB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-CDB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Choc Drip Gateaux',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-CDB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-CDB-EAC', 'BC Choc Drip Gateaux', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-CDN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-CDN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Doughnut',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-CDN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-CDN-EAC', 'Chocolate Doughnut', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-CNL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-CNL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coconut Tartlet',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-CNL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-CNL-EAC', 'Coconut Tartlet', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-CNR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-CNR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coconut Ring',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-CNR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-CNR-EAC', 'Coconut Ring', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-CNS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-CNS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coconut Slice',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-CNS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-CNS-EAC', 'Coconut Slice', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-CNT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-CNT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coconut Tart',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-CNT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-CNT-EAC', 'Coconut Tart', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-CRP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-CRP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream Puff',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-CRP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-CRP-EAC', 'Cream Puff', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-CUS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-CUS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Currant Square',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-CUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-CUS-EAC', 'Currant Square', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-EB1-1M
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-EB1-1M')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 1MX500 BC Eggless',
        RecommendedSellingPrice = 2400.00,
        LastPaidPrice = 2400.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-EB1-1M';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-EB1-1M', 'BD 1MX500 BC Eggless', 2400.00, 2400.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-FLA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-FLA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Flakey Bits',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-FLA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-FLA-EAC', 'Flakey Bits', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-JAP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-JAP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jam Puff',
        RecommendedSellingPrice = 17.00,
        LastPaidPrice = 17.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-JAP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-JAP-EAC', 'Jam Puff', 17.00, 17.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-JAT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-JAT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jam Tart',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-JAT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-JAT-EAC', 'Jam Tart', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-JDN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-JDN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jam Doughnut',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-JDN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-JDN-EAC', 'Jam Doughnut', 15.00, 15.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-JTO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-JTO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jam Turnover',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-JTO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-JTO-EAC', 'Jam Turnover', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-KOE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-KOE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Koeksuster 1s',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-KOE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-KOE-EAC', 'Koeksuster 1s', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-LPC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-LPC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Choc Lamington Plain',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-LPC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-LPC-EAC', 'Choc Lamington Plain', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-LPR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-LPR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Raspberry Lamington Plain',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-LPR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-LPR-EAC', 'Raspberry Lamington Plain', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-MBD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-MBD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Buttercream D/N',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CBC-MBD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-MBD-EAC', 'Mini Buttercream D/N', 12.00, 12.00, 0.00, 'internal', 1);
END

-- Update or Insert: CBC-MBG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-MBG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mothers Day Buttercream Gateaux',
        RecommendedSellingPrice = 140.00,
        LastPaidPrice = 140.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-MBG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-MBG-EAC', 'Mothers Day Buttercream Gateaux', 140.00, 140.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-MCD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-MCD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Chocolate D/N',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-MCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-MCD-EAC', 'Mini Chocolate D/N', 13.00, 13.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-MCL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-MCL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Lamington Chocolate Plain',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CBC-MCL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-MCL-EAC', 'Mini Lamington Chocolate Plain', 13.00, 13.00, 0.00, 'internal', 1);
END

-- Update or Insert: CBC-MEL-40G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-MEL-40G')
BEGIN
    UPDATE Products 
    SET ProductName = 'Melting Moments 40g (Round)',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-MEL-40G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-MEL-40G', 'Melting Moments 40g (Round)', 15.00, 15.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-MEL-60G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-MEL-60G')
BEGIN
    UPDATE Products 
    SET ProductName = 'Melting Moments 60g (Long)',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-MEL-60G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-MEL-60G', 'Melting Moments 60g (Long)', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-MFL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-MFL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini F/BITS',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-MFL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-MFL-EAC', 'Mini F/BITS', 13.00, 13.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-MRL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-MRL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Lamington Raspberry Plain',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-MRL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-MRL-EAC', 'Mini Lamington Raspberry Plain', 13.00, 13.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-MSB-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-MSB-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini S/B',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-MSB-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-MSB-EACH', 'Mini S/B', 13.00, 13.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-MUE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-MUE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Muesli Slice',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-MUE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-MUE-EAC', 'Muesli Slice', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-PCC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-PCC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Picture Cup Cakes',
        RecommendedSellingPrice = 24.00,
        LastPaidPrice = 24.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-PCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-PCC-EAC', 'BD Picture Cup Cakes', 24.00, 24.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-QUC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-QUC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Queen Cakes 1s',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-QUC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-QUC-EAC', 'Queen Cakes 1s', 12.00, 12.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBC-SNO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBC-SNO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Snowballs 1s',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBC-SNO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBC-SNO-EAC', 'Snowballs 1s', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-BCF-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-BCF-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream Figure 18',
        RecommendedSellingPrice = 850.00,
        LastPaidPrice = 850.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-BCF-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-BCF-018', 'BD Buttercream Figure 18', 850.00, 850.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-BCF-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-BCF-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream Figure 18',
        RecommendedSellingPrice = 850.00,
        LastPaidPrice = 850.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-BCF-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-BCF-018', 'BD Buttercream Figure 18', 850.00, 850.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-BCF-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-BCF-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream Figure 20',
        RecommendedSellingPrice = 900.00,
        LastPaidPrice = 900.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-BCF-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-BCF-020', 'BD Buttercream Figure 20', 900.00, 900.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-BCF-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-BCF-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream Figure 20',
        RecommendedSellingPrice = 900.00,
        LastPaidPrice = 900.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-BCF-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-BCF-020', 'BD Buttercream Figure 20', 900.00, 900.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-BCK-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-BCK-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream Key',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CBF-BCK-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-BCK-020', 'BD Buttercream Key', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CBF-BFE-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-BFE-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 20 Buttercream Figure on Base Eggless',
        RecommendedSellingPrice = 1350.00,
        LastPaidPrice = 1350.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-BFE-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-BFE-020', 'BD 20 Buttercream Figure on Base Eggless', 1350.00, 1350.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-BFS-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-BFS-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream Fig on SL 18',
        RecommendedSellingPrice = 940.00,
        LastPaidPrice = 940.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-BFS-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-BFS-018', 'BD Buttercream Fig on SL 18', 940.00, 940.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-BFS-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-BFS-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream Fig on SL 18',
        RecommendedSellingPrice = 940.00,
        LastPaidPrice = 940.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-BFS-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-BFS-018', 'BD Buttercream Fig on SL 18', 940.00, 940.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-BFS-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-BFS-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream Fig on SL 20',
        RecommendedSellingPrice = 990.00,
        LastPaidPrice = 990.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-BFS-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-BFS-020', 'BD Buttercream Fig on SL 20', 990.00, 990.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-BLF-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-BLF-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 14 Black Forest',
        RecommendedSellingPrice = 740.00,
        LastPaidPrice = 740.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-BLF-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-BLF-014', 'BD Freshcream 14 Black Forest', 740.00, 740.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-BLF-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-BLF-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 16 Blackforest',
        RecommendedSellingPrice = 800.00,
        LastPaidPrice = 800.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-BLF-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-BLF-016', 'BD Freshcream 16 Blackforest', 800.00, 800.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-FCD-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-FCD-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 14 DL',
        RecommendedSellingPrice = 470.00,
        LastPaidPrice = 470.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-FCD-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-FCD-014', 'BD Freshcream 14 DL', 470.00, 470.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-FCF-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-FCF-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream Figure 18',
        RecommendedSellingPrice = 900.00,
        LastPaidPrice = 900.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-FCF-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-FCF-018', 'BD Freshcream Figure 18', 900.00, 900.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-FCF-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-FCF-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream Figure 20',
        RecommendedSellingPrice = 950.00,
        LastPaidPrice = 950.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-FCF-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-FCF-020', 'BD Freshcream Figure 20', 950.00, 950.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-FCK-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-FCK-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream Key',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CBF-FCK-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-FCK-020', 'BD Freshcream Key', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CBF-FF0-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-FF0-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 20 Freshcream Figure Only Eggless',
        RecommendedSellingPrice = 1300,
        LastPaidPrice = 1300,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-FF0-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-FF0-020', 'BD 20 Freshcream Figure Only Eggless', 1300, 1300, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-FFE-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-FFE-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream Figure on Base Eggless 20',
        RecommendedSellingPrice = 1450.00,
        LastPaidPrice = 1450.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-FFE-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-FFE-020', 'BD Freshcream Figure on Base Eggless 20', 1450.00, 1450.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-FFS-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-FFS-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream Fig on SL 18',
        RecommendedSellingPrice = 990.00,
        LastPaidPrice = 990.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-FFS-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-FFS-018', 'BD Freshcream Fig on SL 18', 990.00, 990.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-FFS-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-FFS-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream Fig on SL 20',
        RecommendedSellingPrice = 1040.00,
        LastPaidPrice = 1040.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-FFS-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-FFS-020', 'BD Freshcream Fig on SL 20', 1040.00, 1040.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBF-FOE-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBF-FOE-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 20 Buttercream Figure Only Eggless',
        RecommendedSellingPrice = 1250,
        LastPaidPrice = 1250,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBF-FOE-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBF-FOE-020', 'BD 20 Buttercream Figure Only Eggless', 1250, 1250, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBN-B1M-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBN-B1M-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 1MX1M',
        RecommendedSellingPrice = 5500.00,
        LastPaidPrice = 5500.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CBN-B1M-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBN-B1M-EACH', 'BD Buttercream 1MX1M', 5500.00, 5500.00, 0.00, 'internal', 1);
END

-- Update or Insert: CBN-F1M-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBN-F1M-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 1M X1M',
        RecommendedSellingPrice = 5700.00,
        LastPaidPrice = 5700.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CBN-F1M-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBN-F1M-EACH', 'BD Freshcream 1M X1M', 5700.00, 5700.00, 0.00, 'internal', 1);
END

-- Update or Insert: CBR-BCR-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBR-BCR-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 12 Round',
        RecommendedSellingPrice = 420.00,
        LastPaidPrice = 420.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBR-BCR-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBR-BCR-012', 'BD Buttercream 12 Round', 420.00, 420.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBR-BCR-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBR-BCR-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 14 Round',
        RecommendedSellingPrice = 450.00,
        LastPaidPrice = 450.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBR-BCR-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBR-BCR-014', 'BD Buttercream 14 Round', 450.00, 450.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBR-BCR-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBR-BCR-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 16 Round',
        RecommendedSellingPrice = 480.00,
        LastPaidPrice = 480.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBR-BCR-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBR-BCR-016', 'BD Buttercream 16 Round', 480.00, 480.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBR-BCR-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBR-BCR-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 18 Round',
        RecommendedSellingPrice = 570.00,
        LastPaidPrice = 570.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBR-BCR-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBR-BCR-018', 'BD Buttercream 18 Round', 570.00, 570.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBR-BCR-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBR-BCR-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 20 Round',
        RecommendedSellingPrice = 610.00,
        LastPaidPrice = 610.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBR-BCR-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBR-BCR-020', 'BD Buttercream 20 Round', 610.00, 610.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBR-FCR-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBR-FCR-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 12 Round',
        RecommendedSellingPrice = 460.00,
        LastPaidPrice = 460.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBR-FCR-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBR-FCR-012', 'BD Freshcream 12 Round', 460.00, 460.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBR-FCR-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBR-FCR-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 14 Round',
        RecommendedSellingPrice = 490.00,
        LastPaidPrice = 490.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBR-FCR-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBR-FCR-014', 'BD Freshcream 14 Round', 490.00, 490.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBR-FCR-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBR-FCR-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 16 Round',
        RecommendedSellingPrice = 520.00,
        LastPaidPrice = 520.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBR-FCR-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBR-FCR-016', 'BD Freshcream 16 Round', 520.00, 520.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBR-FCR-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBR-FCR-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 18 Round',
        RecommendedSellingPrice = 620.00,
        LastPaidPrice = 620.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBR-FCR-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBR-FCR-018', 'BD Freshcream 18 Round', 620.00, 620.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBR-FCR-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBR-FCR-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 20 Round',
        RecommendedSellingPrice = 660.00,
        LastPaidPrice = 660.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBR-FCR-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBR-FCR-020', 'BD Freshcream 20 Round', 660.00, 660.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-BCD-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-BCD-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 12 DL',
        RecommendedSellingPrice = 400.00,
        LastPaidPrice = 400.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-BCD-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-BCD-012', 'BD Buttercream 12 DL', 400.00, 400.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-BCD-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-BCD-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 14 DL',
        RecommendedSellingPrice = 430.00,
        LastPaidPrice = 430.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-BCD-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-BCD-014', 'BD Buttercream 14 DL', 430.00, 430.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-BCD-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-BCD-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 16 DL',
        RecommendedSellingPrice = 460.00,
        LastPaidPrice = 460.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-BCD-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-BCD-016', 'BD Buttercream 16 DL', 460.00, 460.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-BCD-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-BCD-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 18 DL',
        RecommendedSellingPrice = 550.00,
        LastPaidPrice = 550.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-BCD-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-BCD-018', 'BD Buttercream 18 DL', 550.00, 550.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-BCD-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-BCD-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 20 DL',
        RecommendedSellingPrice = 590.00,
        LastPaidPrice = 590.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-BCD-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-BCD-020', 'BD Buttercream 20 DL', 590.00, 590.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-BCD-022
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-BCD-022')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 22 DL',
        RecommendedSellingPrice = 770.00,
        LastPaidPrice = 770.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-BCD-022';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-BCD-022', 'BD Buttercream 22 DL', 770.00, 770.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-BCE-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-BCE-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 16 BC DL Eggless',
        RecommendedSellingPrice = 520.00,
        LastPaidPrice = 520.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-BCE-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-BCE-016', 'BD 16 BC DL Eggless', 520.00, 520.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-BLF-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-BLF-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 12 Black Forest',
        RecommendedSellingPrice = 670.00,
        LastPaidPrice = 670.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-BLF-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-BLF-012', 'BD Freshcream 12 Black Forest', 670.00, 670.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-FCD-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-FCD-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 12 DL',
        RecommendedSellingPrice = 440.00,
        LastPaidPrice = 440.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-FCD-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-FCD-012', 'BD Freshcream 12 DL', 440.00, 440.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-FCD-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-FCD-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 16 DL',
        RecommendedSellingPrice = 500.00,
        LastPaidPrice = 500.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-FCD-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-FCD-016', 'BD Freshcream 16 DL', 500.00, 500.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-FCD-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-FCD-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 18 DL',
        RecommendedSellingPrice = 600.00,
        LastPaidPrice = 600.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-FCD-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-FCD-018', 'BD Freshcream 18 DL', 600.00, 600.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-FCD-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-FCD-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 20 DL',
        RecommendedSellingPrice = 640.00,
        LastPaidPrice = 640.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-FCD-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-FCD-020', 'BD Freshcream 20 DL', 640.00, 640.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-FCD-022
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-FCD-022')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 22 DL',
        RecommendedSellingPrice = 830.00,
        LastPaidPrice = 830.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-FCD-022';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-FCD-022', 'BD Freshcream 22 DL', 830.00, 830.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-FCE-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-FCE-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 16 Freshcream Eggless',
        RecommendedSellingPrice = 560.00,
        LastPaidPrice = 560.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-FCE-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-FCE-016', 'BD 16 Freshcream Eggless', 560.00, 560.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBS-SBE-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBS-SBE-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Eggless Small Buttercream Gateaux',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBS-SBE-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBS-SBE-EACH', 'Eggless Small Buttercream Gateaux', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBW-CAK-003
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBW-CAK-003')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 3 Tier Stacked',
        RecommendedSellingPrice = 2900.00,
        LastPaidPrice = 2900.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBW-CAK-003';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBW-CAK-003', 'BD Buttercream 3 Tier Stacked', 2900.00, 2900.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBW-CKE-003
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBW-CKE-003')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Wedding Cake BC 10 12 14 Loose',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBW-CKE-003';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBW-CKE-003', 'BD Wedding Cake BC 10 12 14 Loose', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CBW-STA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CBW-STA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 2Tier Stacked 12 16',
        RecommendedSellingPrice = 2100.00,
        LastPaidPrice = 2100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CBW-STA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CBW-STA-EAC', 'BD Buttercream 2Tier Stacked 12 16', 2100.00, 2100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX- BDC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX- BDC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bar One 6 Layer Drip With Toppings',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX- BDC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX- BDC-EAC', 'Bar One 6 Layer Drip With Toppings', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX- BEG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX- BEG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Bar One Eggless Drip',
        RecommendedSellingPrice = 230.00,
        LastPaidPrice = 230.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX- BEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX- BEG-EAC', 'FC Bar One Eggless Drip', 230.00, 230.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX CCD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX CCD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cheese Cake Dessert',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX CCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX CCD-EAC', 'Cheese Cake Dessert', 40.00, 40.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX- LFD-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX- LFD-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = '20cmBC4LayerDrip Cake- Fresh Flowers Macaroon/topp',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX- LFD-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX- LFD-EACH', '20cmBC4LayerDrip Cake- Fresh Flowers Macaroon/topp', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX- MCP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX- MCP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Moist Chocolate Pudding',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX- MCP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX- MCP-EAC', 'Moist Chocolate Pudding', 60.00, 60.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX- MDB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX- MDB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Buttercream 6 Layer Drip Cake with toppings',
        RecommendedSellingPrice = 1400.00,
        LastPaidPrice = 1400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX- MDB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX- MDB-EAC', 'Buttercream 6 Layer Drip Cake with toppings', 1400.00, 1400.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX- NBS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX- NBS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'New York Blueberry Cheese Cake Slice',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX- NBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX- NBS-EAC', 'New York Blueberry Cheese Cake Slice', 50.00, 50.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX -NYW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX -NYW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'New York Baked Cheese Cake Round',
        RecommendedSellingPrice = 400.00,
        LastPaidPrice = 400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX -NYW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX -NYW-EAC', 'New York Baked Cheese Cake Round', 400.00, 400.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX- RTR-12
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX- RTR-12')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC 12'''' Round Triple Layer Rose Pattern',
        RecommendedSellingPrice = 950.00,
        LastPaidPrice = 950.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX- RTR-12';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX- RTR-12', 'BC 12'''' Round Triple Layer Rose Pattern', 950.00, 950.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-AMB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-AMB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'American Brownie',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-AMB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-AMB-EAC', 'American Brownie', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-APP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-APP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Apple Tart',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-APP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-APP-EAC', 'Apple Tart', 80.00, 80.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-ATS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-ATS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Apple Tartlet',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-ATS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-ATS-EAC', 'Apple Tartlet', 30.00, 30.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BAR-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BAR-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Bar One Square 12',
        RecommendedSellingPrice = 1000.00,
        LastPaidPrice = 1000.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BAR-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BAR-012', 'BD Bar One Square 12', 1000.00, 1000.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BAR-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BAR-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Bar One Square 14',
        RecommendedSellingPrice = 1200.00,
        LastPaidPrice = 1200.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BAR-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BAR-014', 'BD Bar One Square 14', 1200.00, 1200.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BAR-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BAR-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Bar One Square 16',
        RecommendedSellingPrice = 1400.00,
        LastPaidPrice = 1400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BAR-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BAR-016', 'BD Bar One Square 16', 1400.00, 1400.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BAR-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BAR-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Bar One Square 18',
        RecommendedSellingPrice = 1700,
        LastPaidPrice = 1700,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BAR-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BAR-018', 'BD Bar One Square 18', 1700, 1700, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BAR-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BAR-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Bar One Square 20',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BAR-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BAR-020', 'BD Bar One Square 20', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BCC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BCC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Baked Citrus Cheese Cake',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BCC-EAC', 'Baked Citrus Cheese Cake', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BOL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BOL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bar One Log',
        RecommendedSellingPrice = 185.00,
        LastPaidPrice = 185.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BOL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BOL-EAC', 'Bar One Log', 185.00, 185.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BOM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BOM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mothers Day Bar One Round with rose and leaves',
        RecommendedSellingPrice = 290.00,
        LastPaidPrice = 290.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BOM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BOM-EAC', 'Mothers Day Bar One Round with rose and leaves', 290.00, 290.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BOR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BOR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bar One Round',
        RecommendedSellingPrice = 290.00,
        LastPaidPrice = 290.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BOR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BOR-EAC', 'Bar One Round', 290.00, 290.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BOS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BOS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bar One Slice',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BOS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BOS-EAC', 'Bar One Slice', 45.00, 45.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BRC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BRC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Baked Red Velvet Cheese Cake',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BRC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BRC-EAC', 'Baked Red Velvet Cheese Cake', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-BVC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-BVC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Baked Vanilla Cheese Cake',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-BVC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-BVC-EAC', 'Baked Vanilla Cheese Cake', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CAC-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CAC-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 12 Carrot Cake square wit cream cheese',
        RecommendedSellingPrice = 1000.00,
        LastPaidPrice = 1000.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CAC-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CAC-012', 'BD 12 Carrot Cake square wit cream cheese', 1000.00, 1000.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CAC-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CAC-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 14'' Carrot cake square with cream cheese',
        RecommendedSellingPrice = 1300,
        LastPaidPrice = 1300,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CAC-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CAC-014', 'BD 14'' Carrot cake square with cream cheese', 1300, 1300, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CAC-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CAC-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 16'' Carrot Cake Square with cream cheese',
        RecommendedSellingPrice = 1400.00,
        LastPaidPrice = 1400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CAC-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CAC-016', 'BD 16'' Carrot Cake Square with cream cheese', 1400.00, 1400.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CAC-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CAC-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 18 Carrot Cake Square with cream cheese',
        RecommendedSellingPrice = 1700,
        LastPaidPrice = 1700,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CAC-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CAC-018', 'BD 18 Carrot Cake Square with cream cheese', 1700, 1700, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CAC-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CAC-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 20 Carrot Cake Square with cream cheese',
        RecommendedSellingPrice = 1800.00,
        LastPaidPrice = 1800.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CAC-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CAC-020', 'BD 20 Carrot Cake Square with cream cheese', 1800.00, 1800.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CAC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CAC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Carrot Cake Cupcake',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CAC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CAC-EAC', 'Carrot Cake Cupcake', 25.00, 25.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CBD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CBD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Bar One 6 Layer Drip Cake',
        RecommendedSellingPrice = 1400.00,
        LastPaidPrice = 1400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CBD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CBD-EAC', 'Chocolate Bar One 6 Layer Drip Cake', 1400.00, 1400.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CBO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CBO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Bar One Round',
        RecommendedSellingPrice = 280.00,
        LastPaidPrice = 280.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CBO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CBO-EAC', 'Christmas Bar One Round', 280.00, 280.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CCC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CCC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Baked Choclate Cheese Cake',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CCC-EAC', 'Baked Choclate Cheese Cake', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CCP-6S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CCP-6S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Cake Pops (6s)',
        RecommendedSellingPrice = 42.00,
        LastPaidPrice = 42.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CCP-6S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CCP-6S', 'Chocolate Cake Pops (6s)', 42.00, 42.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CCS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CCS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cheese Cake Slice',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CCS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CCS-EAC', 'Cheese Cake Slice', 50.00, 50.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CCT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CCT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cheese Cake Tart',
        RecommendedSellingPrice = 67.00,
        LastPaidPrice = 67.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CCT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CCT-EAC', 'Cheese Cake Tart', 67.00, 67.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CEG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CEG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Caramel Exotic Gateaux',
        RecommendedSellingPrice = 230.00,
        LastPaidPrice = 230.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CEG-EAC', 'Caramel Exotic Gateaux', 230.00, 230.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CFD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CFD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Fererro 6 Layer Drip Cake',
        RecommendedSellingPrice = 1400.00,
        LastPaidPrice = 1400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CFD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CFD-EAC', 'Chocolate Fererro 6 Layer Drip Cake', 1400.00, 1400.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CFE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CFE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Ferrero Cake',
        RecommendedSellingPrice = 280.00,
        LastPaidPrice = 280.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CFE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CFE-EAC', 'Christmas Ferrero Cake', 280.00, 280.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CHC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CHC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Cheese Cake Cup',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CHC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CHC-EAC', 'Chocolate Cheese Cake Cup', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CIC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CIC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Citrus Cheese Cake Cup',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CIC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CIC-EAC', 'Citrus Cheese Cake Cup', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CRM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CRM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Moist Choc Cake With Cream Cheese',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CRM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CRM-EAC', 'Moist Choc Cake With Cream Cheese', 180.00, 180.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-CUS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-CUS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Custard & Jelly',
        RecommendedSellingPrice = 19,
        LastPaidPrice = 19,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-CUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-CUS-EAC', 'Custard & Jelly', 19, 19, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-DCV-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-DCV-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Decorative Chocolate Vanilla Gateaux',
        RecommendedSellingPrice = 280.00,
        LastPaidPrice = 280.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-DCV-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-DCV-EAC', 'Decorative Chocolate Vanilla Gateaux', 280.00, 280.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-EBC-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-EBC-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bar One Cupcake Eggless',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-EBC-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-EBC-EACH', 'Bar One Cupcake Eggless', 20.00, 20.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-FEM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-FEM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mothers Day Ferrero Round with rose and leaves',
        RecommendedSellingPrice = 290.00,
        LastPaidPrice = 290.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-FEM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-FEM-EAC', 'Mothers Day Ferrero Round with rose and leaves', 290.00, 290.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-FER-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-FER-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Ferrero Cake 12',
        RecommendedSellingPrice = 1000.00,
        LastPaidPrice = 1000.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-FER-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-FER-012', 'BD Ferrero Cake 12', 1000.00, 1000.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-FER-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-FER-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Ferrero Cake 14',
        RecommendedSellingPrice = 1200.00,
        LastPaidPrice = 1200.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-FER-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-FER-014', 'BD Ferrero Cake 14', 1200.00, 1200.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-FER-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-FER-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Ferrero Cake 16',
        RecommendedSellingPrice = 1400.00,
        LastPaidPrice = 1400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-FER-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-FER-016', 'BD Ferrero Cake 16', 1400.00, 1400.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-FER-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-FER-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Ferrero Cake 18',
        RecommendedSellingPrice = 1600.00,
        LastPaidPrice = 1600.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-FER-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-FER-018', 'BD Ferrero Cake 18', 1600.00, 1600.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-FER-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-FER-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Ferrero Cake 20',
        RecommendedSellingPrice = 1800.00,
        LastPaidPrice = 1800.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-FER-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-FER-020', 'BD Ferrero Cake 20', 1800.00, 1800.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-FRC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-FRC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ferrero Rocher Cake',
        RecommendedSellingPrice = 290.00,
        LastPaidPrice = 290.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-FRC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-FRC-EAC', 'Ferrero Rocher Cake', 290.00, 290.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-FRT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-FRT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ferrero',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-FRT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-FRT-EAC', 'Ferrero', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-GCA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-GCA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Giant Cappuchino Muffin',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-GCA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-GCA-EAC', 'Giant Cappuchino Muffin', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-GCC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-GCC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Giant Corn & Chives Muffin',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-GCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-GCC-EAC', 'Giant Corn & Chives Muffin', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-GCH-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-GCH-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Giant Choc Muffin',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-GCH-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-GCH-EAC', 'Giant Choc Muffin', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-GCM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-GCM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Giant Chicken & Mushroom Muffin',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-GCM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-GCM-EAC', 'Giant Chicken & Mushroom Muffin', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-GIM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-GIM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Giant Muffins',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-GIM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-GIM-EAC', 'Giant Muffins', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-GLP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-GLP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Giant Lemon Poppy& Nuts',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-GLP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-GLP-EAC', 'Giant Lemon Poppy& Nuts', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-GPC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-GPC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Giant Pecan & Carrot Muffin',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-GPC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-GPC-EAC', 'Giant Pecan & Carrot Muffin', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-GSF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-GSF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Giant Spinach & Feta Muffin',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-GSF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-GSF-EAC', 'Giant Spinach & Feta Muffin', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-GVA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-GVA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Giant Vanilla Muffins',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-GVA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-GVA-EAC', 'Giant Vanilla Muffins', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-LMS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-LMS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Lemon Meringue Tart Small',
        RecommendedSellingPrice = 20,
        LastPaidPrice = 20,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-LMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-LMS-EAC', 'Lemon Meringue Tart Small', 20, 20, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-LMT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-LMT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Lemon Meringue Tart Large',
        RecommendedSellingPrice = 60,
        LastPaidPrice = 60,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-LMT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-LMT-EAC', 'Lemon Meringue Tart Large', 60, 60, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MAC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MAC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Macaroons (4s)',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MAC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MAC-EAC', 'Macaroons (4s)', 60.00, 60.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MAL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MAL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Malva Pudding',
        RecommendedSellingPrice = 34,
        LastPaidPrice = 34,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MAL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MAL-EAC', 'Malva Pudding', 34, 34, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MAO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MAO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Macaroons (1s)',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 10.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MAO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MAO-EAC', 'Macaroons (1s)', 18.00, 18.00, 10.00, 'internal', 1);
END

-- Update or Insert: CEX-MBE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MBE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milky Bar Exotic',
        RecommendedSellingPrice = 250.00,
        LastPaidPrice = 250.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MBE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MBE-EAC', 'Milky Bar Exotic', 250.00, 250.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MBS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MBS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bar One Swissroll Slice',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MBS-EAC', 'Bar One Swissroll Slice', 40.00, 40.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MCL-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MCL-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Moist Chocolate Cake Large With Cream Cheese',
        RecommendedSellingPrice = 350.00,
        LastPaidPrice = 350.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MCL-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MCL-EACH', 'Moist Chocolate Cake Large With Cream Cheese', 350.00, 350.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MDF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MDF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Freshcream 6 Layer Drip Cake with Toppings',
        RecommendedSellingPrice = 1400.00,
        LastPaidPrice = 1400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MDF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MDF-EAC', 'Freshcream 6 Layer Drip Cake with Toppings', 1400.00, 1400.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MIL-12
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MIL-12')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Milky Bar 12''''',
        RecommendedSellingPrice = 950.00,
        LastPaidPrice = 950.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MIL-12';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MIL-12', 'BD Milky Bar 12''''', 950.00, 950.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MIL-14
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MIL-14')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Milky Bar 14''''',
        RecommendedSellingPrice = 1050.00,
        LastPaidPrice = 1050.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MIL-14';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MIL-14', 'BD Milky Bar 14''''', 1050.00, 1050.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MIL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MIL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milky Bar Swissroll Slice',
        RecommendedSellingPrice = 36.00,
        LastPaidPrice = 36.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MIL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MIL-EAC', 'Milky Bar Swissroll Slice', 36.00, 36.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MPN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MPN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Pecan Nut Tart',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MPN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MPN-EAC', 'Mini Pecan Nut Tart', 25.00, 25.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MPT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MPT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Malva Pudding Tartlet',
        RecommendedSellingPrice = 16,
        LastPaidPrice = 16,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MPT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MPT-EAC', 'Malva Pudding Tartlet', 16, 16, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MRC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MRC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream Cheese Rainbow Cake',
        RecommendedSellingPrice = 350,
        LastPaidPrice = 350,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MRC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MRC-EAC', 'Cream Cheese Rainbow Cake', 350, 350, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MRS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MRS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream Cheese Rainbow Slice',
        RecommendedSellingPrice = 43,
        LastPaidPrice = 43,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MRS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MRS-EAC', 'Cream Cheese Rainbow Slice', 43, 43, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-MVC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-MVC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Moist Vanilla Cake with Caramel Drizzle',
        RecommendedSellingPrice = 75.00,
        LastPaidPrice = 75.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-MVC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-MVC-EAC', 'Moist Vanilla Cake with Caramel Drizzle', 75.00, 75.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-NBC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-NBC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'New York Baked Blueberry Cheesecake Round',
        RecommendedSellingPrice = 360.00,
        LastPaidPrice = 360.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-NBC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-NBC-EAC', 'New York Baked Blueberry Cheesecake Round', 360.00, 360.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-NRV-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-NRV-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'New Red Velvet Cake',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-NRV-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-NRV-EAC', 'New Red Velvet Cake', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-NUT-12
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-NUT-12')
BEGIN
    UPDATE Products 
    SET ProductName = '12'''' Nibbed Nuts Only',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-NUT-12';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-NUT-12', '12'''' Nibbed Nuts Only', 80.00, 80.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-NUT-14
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-NUT-14')
BEGIN
    UPDATE Products 
    SET ProductName = '14'''' Nibbed Nuts Only',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-NUT-14';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-NUT-14', '14'''' Nibbed Nuts Only', 80.00, 80.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-NUT-16
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-NUT-16')
BEGIN
    UPDATE Products 
    SET ProductName = '16'''' Nibbed Nuts Only',
        RecommendedSellingPrice = 120.00,
        LastPaidPrice = 120.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-NUT-16';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-NUT-16', '16'''' Nibbed Nuts Only', 120.00, 120.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-NUT-18
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-NUT-18')
BEGIN
    UPDATE Products 
    SET ProductName = '18'''' Nibbed Nuts Only',
        RecommendedSellingPrice = 120.00,
        LastPaidPrice = 120.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-NUT-18';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-NUT-18', '18'''' Nibbed Nuts Only', 120.00, 120.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-NUT-20
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-NUT-20')
BEGIN
    UPDATE Products 
    SET ProductName = '20'''' Nibbed Nuts Only',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-NUT-20';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-NUT-20', '20'''' Nibbed Nuts Only', 180.00, 180.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-NUT-22
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-NUT-22')
BEGIN
    UPDATE Products 
    SET ProductName = '22'''' Nibbed Nuts Only',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-NUT-22';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-NUT-22', '22'''' Nibbed Nuts Only', 180.00, 180.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-NYC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-NYC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'New York Baked Cheese Cake Slice',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-NYC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-NYC-EAC', 'New York Baked Cheese Cake Slice', 50.00, 50.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-PCT-4S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-PCT-4S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Portuguese Custard Tart (4S)',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CEX-PCT-4S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-PCT-4S', 'Portuguese Custard Tart (4S)', 60.00, 60.00, 0.00, 'external', 1);
END

-- Update or Insert: CEX-PCT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-PCT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Portuguese Custard Tart',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 10.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CEX-PCT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-PCT-EAC', 'Portuguese Custard Tart', 22.00, 22.00, 10.00, 'external', 1);
END

-- Update or Insert: CEX-PEA-12
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-PEA-12')
BEGIN
    UPDATE Products 
    SET ProductName = '12'''' Peaches Slices Only',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-PEA-12';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-PEA-12', '12'''' Peaches Slices Only', 80.00, 80.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-PEA-14
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-PEA-14')
BEGIN
    UPDATE Products 
    SET ProductName = '14'''' Peaches Slices Only',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-PEA-14';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-PEA-14', '14'''' Peaches Slices Only', 80.00, 80.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-PEA-16
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-PEA-16')
BEGIN
    UPDATE Products 
    SET ProductName = '16'''' Peaches Slices Only',
        RecommendedSellingPrice = 120.00,
        LastPaidPrice = 120.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-PEA-16';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-PEA-16', '16'''' Peaches Slices Only', 120.00, 120.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-PEA-18
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-PEA-18')
BEGIN
    UPDATE Products 
    SET ProductName = '18'''' Peaches Slices Only',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-PEA-18';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-PEA-18', '18'''' Peaches Slices Only', 180.00, 180.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-PEA-20
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-PEA-20')
BEGIN
    UPDATE Products 
    SET ProductName = '20'''' Peaches Slices Only',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-PEA-20';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-PEA-20', '20'''' Peaches Slices Only', 180.00, 180.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-PEA-22
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-PEA-22')
BEGIN
    UPDATE Products 
    SET ProductName = '22'''' Peaches Slices Only',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CEX-PEA-22';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-PEA-22', '22'''' Peaches Slices Only', 180.00, 180.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CEX-PET-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-PET-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pecan Nut Tartlet',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-PET-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-PET-EACH', 'Pecan Nut Tartlet', 20.00, 20.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-PMC-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-PMC-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Peppermint Crisp Cake',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-PMC-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-PMC-EACH', 'Peppermint Crisp Cake', 100.00, 100.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-PNT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-PNT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pecan Nut Tart',
        RecommendedSellingPrice = 35.00,
        LastPaidPrice = 35.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-PNT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-PNT-EAC', 'Pecan Nut Tart', 35.00, 35.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RCC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RCC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'CARROT CAKE ROUND',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RCC-EAC', 'CARROT CAKE ROUND', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-REC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-REC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Redvelvet Cheese Cake Cup',
        RecommendedSellingPrice = 32.00,
        LastPaidPrice = 32.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-REC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-REC-EAC', 'Redvelvet Cheese Cake Cup', 32.00, 32.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RED-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RED-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 16 Red Velvet Square',
        RecommendedSellingPrice = 1200.00,
        LastPaidPrice = 1200.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RED-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RED-016', 'BD 16 Red Velvet Square', 1200.00, 1200.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RMC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RMC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OREO CAKE',
        RecommendedSellingPrice = 350,
        LastPaidPrice = 350,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RMC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RMC-EAC', 'OREO CAKE', 350, 350, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RSW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RSW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Red velvet Swissroll',
        RecommendedSellingPrice = 35,
        LastPaidPrice = 35,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RSW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RSW-EAC', 'Red velvet Swissroll', 35, 35, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RTR-14
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RTR-14')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC 14'''' Round Triple Layer Rose Pattern',
        RecommendedSellingPrice = 1000.00,
        LastPaidPrice = 1000.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RTR-14';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RTR-14', 'BC 14'''' Round Triple Layer Rose Pattern', 1000.00, 1000.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RTR-16
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RTR-16')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC 16'''' Round Triple Layer Rose Pattern',
        RecommendedSellingPrice = 1100.00,
        LastPaidPrice = 1100.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RTR-16';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RTR-16', 'BC 16'''' Round Triple Layer Rose Pattern', 1100.00, 1100.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RTR-18
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RTR-18')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC 18'''' Round Triple Layer Rose Pattern',
        RecommendedSellingPrice = 1250.00,
        LastPaidPrice = 1250.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RTR-18';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RTR-18', 'BC 18'''' Round Triple Layer Rose Pattern', 1250.00, 1250.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RTR-20
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RTR-20')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC 20'''' Round Triple Layer Rose Pattern',
        RecommendedSellingPrice = 1500.00,
        LastPaidPrice = 1500.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RTR-20';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RTR-20', 'BC 20'''' Round Triple Layer Rose Pattern', 1500.00, 1500.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RVB-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RVB-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 18 Red Velvet Square',
        RecommendedSellingPrice = 1200.00,
        LastPaidPrice = 1200.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RVB-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RVB-018', 'BD 18 Red Velvet Square', 1200.00, 1200.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RVB-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RVB-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 20 Red Velvet Square',
        RecommendedSellingPrice = 1400.00,
        LastPaidPrice = 1400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RVB-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RVB-020', 'BD 20 Red Velvet Square', 1400.00, 1400.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RVC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RVC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Red Velvet Cupcakes',
        RecommendedSellingPrice = 21.00,
        LastPaidPrice = 21.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RVC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RVC-EAC', 'Red Velvet Cupcakes', 21.00, 21.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RVG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RVG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Red Velvet Gateaux',
        RecommendedSellingPrice = 150.00,
        LastPaidPrice = 150.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RVG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RVG-EAC', 'Red Velvet Gateaux', 150.00, 150.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RVL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RVL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Red Velvet Log',
        RecommendedSellingPrice = 70.00,
        LastPaidPrice = 70.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RVL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RVL-EAC', 'Red Velvet Log', 70.00, 70.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-RVS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-RVS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Red Velvet Slice',
        RecommendedSellingPrice = 35.00,
        LastPaidPrice = 35.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-RVS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-RVS-EAC', 'Red Velvet Slice', 35.00, 35.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-TID-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-TID-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tirumisu Dessert',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-TID-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-TID-EAC', 'Tirumisu Dessert', 20.00, 20.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-TIR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-TIR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cake Tiramisu',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-TIR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-TIR-EAC', 'Cake Tiramisu', 180.00, 180.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-TIS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-TIS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'tirumisu slice',
        RecommendedSellingPrice = 33.00,
        LastPaidPrice = 33.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-TIS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-TIS-EAC', 'tirumisu slice', 33.00, 33.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-TRE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-TRE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Truffles Eggless 6s',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-TRE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-TRE-EAC', 'Truffles Eggless 6s', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-TRF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-TRF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Truffles (1)s',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-TRF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-TRF-EAC', 'Truffles (1)s', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-TRO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-TRO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tirumisu round',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-TRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-TRO-EAC', 'Tirumisu round', 180.00, 180.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-TRU-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-TRU-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Truffles (6s)',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-TRU-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-TRU-EAC', 'Truffles (6s)', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-VAC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-VAC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Vanilla Cheese Cake Cup',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-VAC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-VAC-EAC', 'Vanilla Cheese Cake Cup', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEX-VGB-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEX-VGB-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Vegan Chocolate Brownie',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEX-VGB-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEX-VGB-EACH', 'Vegan Chocolate Brownie', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CEZ-MIL-16
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CEZ-MIL-16')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Milky Bar 16''''',
        RecommendedSellingPrice = 1200.00,
        LastPaidPrice = 1200.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CEZ-MIL-16';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CEZ-MIL-16', 'BD Milky Bar 16''''', 1200.00, 1200.00, 0.00, 'internal', 1);
END

-- Update or Insert: CFA-FAC-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFA-FAC-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 14'''' Freshcream Alphabet Cake',
        RecommendedSellingPrice = 630.00,
        LastPaidPrice = 630.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CFA-FAC-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFA-FAC-014', 'BD 14'''' Freshcream Alphabet Cake', 630.00, 630.00, 0.00, 'internal', 1);
END

-- Update or Insert: CFA-FAE-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFA-FAE-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 16'''' Eggless Freshcream Alphabet Cake',
        RecommendedSellingPrice = 800.00,
        LastPaidPrice = 800.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CFA-FAE-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFA-FAE-016', 'BD 16'''' Eggless Freshcream Alphabet Cake', 800.00, 800.00, 0.00, 'internal', 1);
END

-- Update or Insert: CFC-BET-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-BET-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Belgica Tart',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-BET-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-BET-EAC', 'Belgica Tart', 80.00, 80.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-BTL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-BTL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Belgica Tartlet',
        RecommendedSellingPrice = 35.00,
        LastPaidPrice = 35.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-BTL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-BTL-EAC', 'Belgica Tartlet', 35.00, 35.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-CBS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-CBS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Black Forest Slice',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-CBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-CBS-EAC', 'FC Black Forest Slice', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-CCC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-CCC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Carrot Cake With Cream Cheese',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-CCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-CCC-EAC', 'Carrot Cake With Cream Cheese', 85.00, 85.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-CCD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-CCD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Custard Doughnut',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-CCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-CCD-EAC', 'Custard Doughnut', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-CCT-15CM
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-CCT-15CM')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gluten Free Carrot Cake Tub 15cm',
        RecommendedSellingPrice = 22,
        LastPaidPrice = 22,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CFC-CCT-15CM';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-CCT-15CM', 'Gluten Free Carrot Cake Tub 15cm', 22, 22, 0.00, 'internal', 1);
END

-- Update or Insert: CFC-CFD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-CFD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Choc Drip Gateaux',
        RecommendedSellingPrice = 200.00,
        LastPaidPrice = 200.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-CFD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-CFD-EAC', 'FC Choc Drip Gateaux', 200.00, 200.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-CFE-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-CFE-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Freshcream Eggless Gateaux',
        RecommendedSellingPrice = 170.00,
        LastPaidPrice = 170.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-CFE-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-CFE-EACH', 'Christmas Freshcream Eggless Gateaux', 170.00, 170.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-CUD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-CUD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Custard Danish',
        RecommendedSellingPrice = 28.00,
        LastPaidPrice = 28.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-CUD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-CUD-EAC', 'Custard Danish', 28.00, 28.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-CUS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-CUS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Custard Slice',
        RecommendedSellingPrice = 28.00,
        LastPaidPrice = 28.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-CUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-CUS-EAC', 'Custard Slice', 28.00, 28.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-EF1-1M
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-EF1-1M')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 1M X500 FC Eggless',
        RecommendedSellingPrice = 3500.00,
        LastPaidPrice = 3500.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-EF1-1M';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-EF1-1M', 'BD 1M X500 FC Eggless', 3500.00, 3500.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-EMT-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-EMT-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Eggless Milk Tartlet',
        RecommendedSellingPrice = 28.00,
        LastPaidPrice = 28.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-EMT-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-EMT-EACH', 'Eggless Milk Tartlet', 28.00, 28.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FBF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FBF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Black Forest Gateaux',
        RecommendedSellingPrice = 290.00,
        LastPaidPrice = 290.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FBF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FBF-EAC', 'FC Black Forest Gateaux', 290.00, 290.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FBG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FBG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Birthday Gateaux',
        RecommendedSellingPrice = 130.00,
        LastPaidPrice = 130.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FBG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FBG-EAC', 'FC Birthday Gateaux', 130.00, 130.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FCD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FCD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fresh Cream Doughnut',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FCD-EAC', 'Fresh Cream Doughnut', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FCE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FCE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Eclair Chocolate',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FCE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FCE-EAC', 'FC Eclair Chocolate', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FCG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FCG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Chocolate Gateaux',
        RecommendedSellingPrice = 140.00,
        LastPaidPrice = 140.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FCG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FCG-EAC', 'FC Chocolate Gateaux', 140.00, 140.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FCJ-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FCJ-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Freshcream Choc Gateaux',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FCJ-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FCJ-EAC', 'Christmas Freshcream Choc Gateaux', 180.00, 180.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FCL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FCL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Fresh Cream Slice',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FCL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FCL-EAC', 'FC Fresh Cream Slice', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FCM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FCM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Lamington Chocolate',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FCM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FCM-EAC', 'FC Lamington Chocolate', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FCP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FCP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Caramel Sponge',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CFC-FCP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FCP-EAC', 'FC Caramel Sponge', 80.00, 80.00, 0.00, 'internal', 1);
END

-- Update or Insert: CFC-FCR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FCR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Croissant 80g',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FCR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FCR-EAC', 'FC Croissant 80g', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FCS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FCS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Chocolate Swiss Roll',
        RecommendedSellingPrice = 95.00,
        LastPaidPrice = 95.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FCS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FCS-EAC', 'FC Chocolate Swiss Roll', 95.00, 95.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FDD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FDD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cake Freshcream In Dome Eggless',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FDD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FDD-EAC', 'Cake Freshcream In Dome Eggless', 100.00, 100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FDI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FDI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cake Buttercream In Dome Eggless',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FDI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FDI-EAC', 'Cake Buttercream In Dome Eggless', 80.00, 80.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FEB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FEB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Eggless Birthday Gateaux',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FEB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FEB-EAC', 'FC Eggless Birthday Gateaux', 180.00, 180.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FEG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FEG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Eggless Vanilla Gateaux',
        RecommendedSellingPrice = 160.00,
        LastPaidPrice = 160.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FEG-EAC', 'FC Eggless Vanilla Gateaux', 160.00, 160.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FES-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FES-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Eggless Slice',
        RecommendedSellingPrice = 26.00,
        LastPaidPrice = 26.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FES-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FES-EAC', 'FC Eggless Slice', 26.00, 26.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FLM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FLM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Choc Mini Lamington',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FLM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FLM-EAC', 'Choc Mini Lamington', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FMS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FMS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Milky Bar Slice',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CFC-FMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FMS-EAC', 'FC Milky Bar Slice', 18.00, 18.00, 0.00, 'internal', 1);
END

-- Update or Insert: CFC-FOS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FOS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Freshcream Oreo Slice',
        RecommendedSellingPrice = 32.00,
        LastPaidPrice = 32.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FOS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FOS-EAC', 'Freshcream Oreo Slice', 32.00, 32.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FRL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FRL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Lamington Raspberry',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FRL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FRL-EAC', 'FC Lamington Raspberry', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FRM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FRM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Jam TurnOvers',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FRM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FRM-EAC', 'Mini Jam TurnOvers', 13.00, 13.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FRU-010
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FRU-010')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Fruit Cake 10',
        RecommendedSellingPrice = 950.00,
        LastPaidPrice = 950.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FRU-010';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FRU-010', 'BD Fruit Cake 10', 950.00, 950.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FRU-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FRU-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'BDFruit Cake 12',
        RecommendedSellingPrice = 1000.00,
        LastPaidPrice = 1000.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FRU-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FRU-012', 'BDFruit Cake 12', 1000.00, 1000.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FRU-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FRU-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Fruit Cake 14',
        RecommendedSellingPrice = 1100.00,
        LastPaidPrice = 1100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FRU-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FRU-014', 'BD Fruit Cake 14', 1100.00, 1100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FRU-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FRU-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Fruit Cake 16',
        RecommendedSellingPrice = 1150.00,
        LastPaidPrice = 1150.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FRU-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FRU-016', 'BD Fruit Cake 16', 1150.00, 1150.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FRU-EAU
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FRU-EAU')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fruit Cake Pieces Unwrapped',
        RecommendedSellingPrice = 9.00,
        LastPaidPrice = 9.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FRU-EAU';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FRU-EAU', 'Fruit Cake Pieces Unwrapped', 9.00, 9.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FRU-EAW
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FRU-EAW')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fruit Cake Pieces Wrapped',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FRU-EAW';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FRU-EAW', 'Fruit Cake Pieces Wrapped', 12.00, 12.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FSM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FSM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Freshcream Swissroll',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FSM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FSM-EAC', 'Mini Freshcream Swissroll', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-FSS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-FSS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'FC Strawberry Sponge',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-FSS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-FSS-EAC', 'FC Strawberry Sponge', 100.00, 100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-MEG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-MEG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mothers Day Eggless Freshcream Gateaux',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-MEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-MEG-EAC', 'Mothers Day Eggless Freshcream Gateaux', 180.00, 180.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-MFD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-MFD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini FC D/N',
        RecommendedSellingPrice = 14.00,
        LastPaidPrice = 14.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-MFD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-MFD-EAC', 'Mini FC D/N', 14.00, 14.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-MFE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-MFE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Freshcream Eclairs',
        RecommendedSellingPrice = 14.00,
        LastPaidPrice = 14.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-MFE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-MFE-EAC', 'Mini Freshcream Eclairs', 14.00, 14.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-MFG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-MFG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mothers Day FC Choc Gateaux with rose and leaves',
        RecommendedSellingPrice = 160.00,
        LastPaidPrice = 160.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-MFG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-MFG-EAC', 'Mothers Day FC Choc Gateaux with rose and leaves', 160.00, 160.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-MFL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-MFL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini CreamPuffs',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-MFL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-MFL-EAC', 'Mini CreamPuffs', 13.00, 13.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-MMT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-MMT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Milk Tart',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-MMT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-MMT-EAC', 'Mini Milk Tart', 15.00, 15.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-MTA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-MTA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milk Tart Large',
        RecommendedSellingPrice = 55.00,
        LastPaidPrice = 55.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-MTA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-MTA-EAC', 'Milk Tart Large', 55.00, 55.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-MTL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-MTL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milk Tartlet',
        RecommendedSellingPrice = 24.00,
        LastPaidPrice = 24.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-MTL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-MTL-EAC', 'Milk Tartlet', 24.00, 24.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-NOB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-NOB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'No Bake Cake',
        RecommendedSellingPrice = 24.00,
        LastPaidPrice = 24.00,
        AverageCost = 61.20,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-NOB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-NOB-EAC', 'No Bake Cake', 24.00, 24.00, 61.20, 'RawMaterial', 1);
END

-- Update or Insert: CFC-SEF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-SEF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Eggless Small Freshcream Gateaux',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFC-SEF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-SEF-EAC', 'Eggless Small Freshcream Gateaux', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFC-VVB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFC-VVB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Vegan Vanilla 4 Layer -Berry Garnish',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CFC-VVB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFC-VVB-EAC', 'Vegan Vanilla 4 Layer -Berry Garnish', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: CFR-CFR-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFR-CFR-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Round Fruitcake 12',
        RecommendedSellingPrice = 1100.00,
        LastPaidPrice = 1100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFR-CFR-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFR-CFR-012', 'BD Round Fruitcake 12', 1100.00, 1100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFR-CFR-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFR-CFR-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Round Fruitcake 12',
        RecommendedSellingPrice = 1100.00,
        LastPaidPrice = 1100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFR-CFR-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFR-CFR-012', 'BD Round Fruitcake 12', 1100.00, 1100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFR-CFR-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFR-CFR-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Round Fruitcake 14',
        RecommendedSellingPrice = 1200.00,
        LastPaidPrice = 1200.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFR-CFR-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFR-CFR-014', 'BD Round Fruitcake 14', 1200.00, 1200.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFR-CFR-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFR-CFR-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Round Fruitcake 16',
        RecommendedSellingPrice = 1300.00,
        LastPaidPrice = 1300.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFR-CFR-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFR-CFR-016', 'BD Round Fruitcake 16', 1300.00, 1300.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFR-CFR-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFR-CFR-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Round Fruitcake 16',
        RecommendedSellingPrice = 1300.00,
        LastPaidPrice = 1300.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFR-CFR-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFR-CFR-016', 'BD Round Fruitcake 16', 1300.00, 1300.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFW-CAF-002
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFW-CAF-002')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD WC Fruit 2 Layer',
        RecommendedSellingPrice = 3900.00,
        LastPaidPrice = 3900.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFW-CAF-002';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFW-CAF-002', 'BD WC Fruit 2 Layer', 3900.00, 3900.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFW-CAF-003
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFW-CAF-003')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD WC Fruit 3 Layer',
        RecommendedSellingPrice = 4900.00,
        LastPaidPrice = 4900.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFW-CAF-003';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFW-CAF-003', 'BD WC Fruit 3 Layer', 4900.00, 4900.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFW-CAF-003
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFW-CAF-003')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD WC Fruit 3 Layer',
        RecommendedSellingPrice = 4900.00,
        LastPaidPrice = 4900.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFW-CAF-003';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFW-CAF-003', 'BD WC Fruit 3 Layer', 4900.00, 4900.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CFW-CKE-003
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CFW-CKE-003')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Wedding Cake FC 10 12 14 Loose',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CFW-CKE-003';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CFW-CKE-003', 'BD Wedding Cake FC 10 12 14 Loose', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CLE-BGS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CLE-BGS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Betasan Gel Sanitizer Refills',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 140.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CLE-BGS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CLE-BGS-EAC', 'Betasan Gel Sanitizer Refills', 0, 0, 140.00, 'external', 1);
END

-- Update or Insert: CLE-MPP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CLE-MPP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Monthly Pest Control',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 850.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CLE-MPP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CLE-MPP-EAC', 'Monthly Pest Control', 0, 0, 850.00, 'RawMaterial', 1);
END

-- Update or Insert: CLE-TPR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CLE-TPR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tad Paper Refil',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CLE-TPR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CLE-TPR-EAC', 'Tad Paper Refil', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: CLE-VIB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CLE-VIB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Viper Boards',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 50.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'CLE-VIB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CLE-VIB-EAC', 'Viper Boards', 0, 0, 50.00, 'external', 1);
END

-- Update or Insert: CNO-BC1-1X5
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BC1-1X5')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 1mx500',
        RecommendedSellingPrice = 2400.00,
        LastPaidPrice = 2400.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CNO-BC1-1X5';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BC1-1X5', 'BD Buttercream 1mx500', 2400.00, 2400.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CNO-BC1-1X5
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BC1-1X5')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 1mx500',
        RecommendedSellingPrice = 2400.00,
        LastPaidPrice = 2400.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CNO-BC1-1X5';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BC1-1X5', 'BD Buttercream 1mx500', 2400.00, 2400.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CNO-BCB-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BCB-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 16 Bible',
        RecommendedSellingPrice = 870.00,
        LastPaidPrice = 870.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BCB-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BCB-016', 'BD Buttercream 16 Bible', 870.00, 870.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BCB-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BCB-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 18 Bible',
        RecommendedSellingPrice = 920.00,
        LastPaidPrice = 920.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BCB-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BCB-018', 'BD Buttercream 18 Bible', 920.00, 920.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BCB-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BCB-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 20 Bible',
        RecommendedSellingPrice = 980.00,
        LastPaidPrice = 980.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BCB-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BCB-020', 'BD Buttercream 20 Bible', 980.00, 980.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BCE-1X5
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BCE-1X5')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 1mx500 Eggless',
        RecommendedSellingPrice = 3100.00,
        LastPaidPrice = 3100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CNO-BCE-1X5';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BCE-1X5', 'BD Buttercream 1mx500 Eggless', 3100.00, 3100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CNO-BCH-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BCH-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 16 Heart',
        RecommendedSellingPrice = 870.00,
        LastPaidPrice = 870.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BCH-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BCH-016', 'BD Buttercream 16 Heart', 870.00, 870.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BCH-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BCH-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 18 Heart',
        RecommendedSellingPrice = 920.00,
        LastPaidPrice = 920.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BCH-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BCH-018', 'BD Buttercream 18 Heart', 920.00, 920.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BCH-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BCH-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 20 Heart',
        RecommendedSellingPrice = 980.00,
        LastPaidPrice = 980.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BCH-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BCH-020', 'BD Buttercream 20 Heart', 980.00, 980.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BCS-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BCS-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 14 Soccer',
        RecommendedSellingPrice = 720.00,
        LastPaidPrice = 720.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BCS-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BCS-014', 'BD Buttercream 14 Soccer', 720.00, 720.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BCS-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BCS-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 14 Soccer',
        RecommendedSellingPrice = 720.00,
        LastPaidPrice = 720.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BCS-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BCS-014', 'BD Buttercream 14 Soccer', 720.00, 720.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BCS-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BCS-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 16 Soccer',
        RecommendedSellingPrice = 760.00,
        LastPaidPrice = 760.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BCS-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BCS-016', 'BD Buttercream 16 Soccer', 760.00, 760.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BNY-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BNY-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Mould On SL 18',
        RecommendedSellingPrice = 1500.00,
        LastPaidPrice = 1500.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BNY-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BNY-018', 'BD Mould On SL 18', 1500.00, 1500.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BNY-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BNY-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Mould On SL 18',
        RecommendedSellingPrice = 1500.00,
        LastPaidPrice = 1500.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BNY-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BNY-018', 'BD Mould On SL 18', 1500.00, 1500.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BUT-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BUT-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 14 Butterfly',
        RecommendedSellingPrice = 950.00,
        LastPaidPrice = 950.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BUT-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BUT-014', 'BD Buttercream 14 Butterfly', 950.00, 950.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-BUT-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-BUT-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 16 Butterfly',
        RecommendedSellingPrice = 1000.00,
        LastPaidPrice = 1000.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-BUT-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-BUT-016', 'BD Buttercream 16 Butterfly', 1000.00, 1000.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-CAS-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-CAS-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Castle',
        RecommendedSellingPrice = 1700.00,
        LastPaidPrice = 1700.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-CAS-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-CAS-018', 'BD Castle', 1700.00, 1700.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-DHB-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-DHB-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 20 Double Heart With Base',
        RecommendedSellingPrice = 1400.00,
        LastPaidPrice = 1400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-DHB-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-DHB-020', 'BD Buttercream 20 Double Heart With Base', 1400.00, 1400.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-DOLL-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-DOLL-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 14 Doll',
        RecommendedSellingPrice = 870.00,
        LastPaidPrice = 870.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-DOLL-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-DOLL-014', 'BD Buttercream 14 Doll', 870.00, 870.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-DOLL-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-DOLL-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 16 Doll',
        RecommendedSellingPrice = 920.00,
        LastPaidPrice = 920.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-DOLL-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-DOLL-016', 'BD Buttercream 16 Doll', 920.00, 920.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-DOLL-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-DOLL-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Buttercream 16 Doll',
        RecommendedSellingPrice = 920.00,
        LastPaidPrice = 920.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-DOLL-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-DOLL-016', 'BD Buttercream 16 Doll', 920.00, 920.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FC1-1X5
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FC1-1X5')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 1mx500',
        RecommendedSellingPrice = 2700.00,
        LastPaidPrice = 2700.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CNO-FC1-1X5';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FC1-1X5', 'BD Freshcream 1mx500', 2700.00, 2700.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CNO-FCB-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCB-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 16 Freshcream BIBLE',
        RecommendedSellingPrice = 920.00,
        LastPaidPrice = 920.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCB-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCB-016', 'BD 16 Freshcream BIBLE', 920.00, 920.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FCB-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCB-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 16 Freshcream BIBLE',
        RecommendedSellingPrice = 920.00,
        LastPaidPrice = 920.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCB-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCB-016', 'BD 16 Freshcream BIBLE', 920.00, 920.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FCB-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCB-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 18 Bible',
        RecommendedSellingPrice = 970.00,
        LastPaidPrice = 970.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCB-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCB-018', 'BD Freshcream 18 Bible', 970.00, 970.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FCB-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCB-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 18 Bible',
        RecommendedSellingPrice = 970.00,
        LastPaidPrice = 970.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCB-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCB-018', 'BD Freshcream 18 Bible', 970.00, 970.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FCB-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCB-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 20 Bible',
        RecommendedSellingPrice = 1050.00,
        LastPaidPrice = 1050.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCB-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCB-020', 'BD Freshcream 20 Bible', 1050.00, 1050.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FCE-1X5
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCE-1X5')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 1m x 500 Eggless',
        RecommendedSellingPrice = 3600.00,
        LastPaidPrice = 3600.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCE-1X5';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCE-1X5', 'BD Freshcream 1m x 500 Eggless', 3600.00, 3600.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: CNO-FCH-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCH-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 16 Heart',
        RecommendedSellingPrice = 920.00,
        LastPaidPrice = 920.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCH-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCH-016', 'BD Freshcream 16 Heart', 920.00, 920.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FCH-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCH-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 16 Heart',
        RecommendedSellingPrice = 920.00,
        LastPaidPrice = 920.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCH-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCH-016', 'BD Freshcream 16 Heart', 920.00, 920.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FCH-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCH-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 18 Heart',
        RecommendedSellingPrice = 970.00,
        LastPaidPrice = 970.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCH-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCH-018', 'BD Freshcream 18 Heart', 970.00, 970.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FCH-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCH-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 20 Heart',
        RecommendedSellingPrice = 1050.00,
        LastPaidPrice = 1050.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCH-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCH-020', 'BD Freshcream 20 Heart', 1050.00, 1050.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FCS-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCS-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 14 Soccer',
        RecommendedSellingPrice = 760.00,
        LastPaidPrice = 760.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCS-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCS-014', 'BD Freshcream 14 Soccer', 760.00, 760.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FCS-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FCS-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Freshcream 16 Soccer',
        RecommendedSellingPrice = 800.00,
        LastPaidPrice = 800.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FCS-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FCS-016', 'BD Freshcream 16 Soccer', 800.00, 800.00, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-FSF-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-FSF-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD FC With Strawberries & Fence',
        RecommendedSellingPrice = 950,
        LastPaidPrice = 950,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-FSF-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-FSF-014', 'BD FC With Strawberries & Fence', 950, 950, 0.00, 'internal', 1);
END

-- Update or Insert: CNO-SPI-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'CNO-SPI-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD Spiderman On SL 18',
        RecommendedSellingPrice = 1600.00,
        LastPaidPrice = 1600.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'CNO-SPI-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('CNO-SPI-018', 'BD Spiderman On SL 18', 1600.00, 1600.00, 0.00, 'internal', 1);
END

-- Update or Insert: DRI- CZE-440
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI- CZE-440')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coke Zero 440ml can',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 6.41,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI- CZE-440';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI- CZE-440', 'Coke Zero 440ml can', 18.00, 18.00, 6.41, 'RawMaterial', 1);
END

-- Update or Insert: DRI-AMA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-AMA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Clover Amasi 2kg',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-AMA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-AMA-EAC', 'Clover Amasi 2kg', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-AME-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-AME-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Americano Short',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-AME-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-AME-250ML', 'Americano Short', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-AME-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-AME-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Americano Tall',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-AME-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-AME-350ML', 'Americano Tall', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-APT-275
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-APT-275')
BEGIN
    UPDATE Products 
    SET ProductName = 'Appletiser 275ml NRB',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-APT-275';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-APT-275', 'Appletiser 275ml NRB', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-APT-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-APT-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Appletiser 330ml CAN',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 10.67,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-APT-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-APT-330', 'Appletiser 330ml CAN', 20.00, 20.00, 10.67, 'RawMaterial', 1);
END

-- Update or Insert: DRI-BAA-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-BAA-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bonaqua 500ml',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-BAA-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-BAA-500', 'Bonaqua 500ml', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-BAN-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-BAN-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bonaqua 500ml Naartjie',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-BAN-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-BAN-500', 'Bonaqua 500ml Naartjie', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-BLI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-BLI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Clover Bliss Double cream yogurt',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 29.57,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-BLI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-BLI-EAC', 'Clover Bliss Double cream yogurt', 15.00, 15.00, 29.57, 'RawMaterial', 1);
END

-- Update or Insert: DRI-BON-500ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-BON-500ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Water Bonaqua Still 500ml',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-BON-500ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-BON-500ML', 'Water Bonaqua Still 500ml', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CAF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CAF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Caramel Freezo',
        RecommendedSellingPrice = 35.00,
        LastPaidPrice = 35.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CAF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CAF-EAC', 'Caramel Freezo', 35.00, 35.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CBB-1500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CBB-1500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cappy Breakfast Blend 1.5litre',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CBB-1500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CBB-1500', 'Cappy Breakfast Blend 1.5litre', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CBB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CBB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cappy Breakfast Blend 330ml',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 11.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CBB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CBB-EAC', 'Cappy Breakfast Blend 330ml', 20.00, 20.00, 11.29, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CFR=EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CFR=EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coffee Freezo',
        RecommendedSellingPrice = 4040,
        LastPaidPrice = 4040,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CFR=EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CFR=EAC', 'Coffee Freezo', 4040, 4040, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CHA-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CHA-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chai Latte Short',
        RecommendedSellingPrice = 32.00,
        LastPaidPrice = 32.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CHA-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CHA-350ML', 'Chai Latte Short', 32.00, 32.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CHF-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CHF-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Freezo Short',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CHF-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CHF-250ML', 'Chocolate Freezo Short', 45.00, 45.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CHF-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CHF-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Freezo Tall',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CHF-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CHF-350ML', 'Chocolate Freezo Tall', 50.00, 50.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CHF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CHF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Freezo',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CHF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CHF-EAC', 'Chocolate Freezo', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CHL-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CHL-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chai Latte Tall',
        RecommendedSellingPrice = 36.00,
        LastPaidPrice = 36.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CHL-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CHL-EACH', 'Chai Latte Tall', 36.00, 36.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COC-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COC-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola 1250ml',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COC-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COC-125', 'Coca-Cola 1250ml', 12.00, 12.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COC-1LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COC-1LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola 1L',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 13.73,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COC-1LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COC-1LT', 'Coca-Cola 1L', 22.00, 22.00, 13.73, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COC-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COC-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 21.72,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COC-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COC-2LT', 'Coca-Cola 2l', 30.00, 30.00, 21.72, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COC-300
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COC-300')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola 300ml Bottle',
        RecommendedSellingPrice = 7.00,
        LastPaidPrice = 7.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COC-300';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COC-300', 'Coca-Cola 300ml Bottle', 7.00, 7.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COC-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COC-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola 300ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 8.98,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COC-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COC-330', 'Coca-Cola 300ml Can', 15.00, 15.00, 8.98, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COC-440
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COC-440')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca- Cola 500ml Can',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COC-440';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COC-440', 'Coca- Cola 500ml Can', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COC-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COC-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola 440ml Buddy',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 10.01,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COC-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COC-500', 'Coca-Cola 440ml Buddy', 20.00, 20.00, 10.01, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COL-1.5LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COL-1.5LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola Zero 1.5ltr',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 10.39,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COL-1.5LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COL-1.5LT', 'Coca-Cola Zero 1.5ltr', 20.00, 20.00, 10.39, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COL-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COL-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola Light 1250ml',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 9.67,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COL-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COL-125', 'Coca-Cola Light 1250ml', 12.00, 12.00, 9.67, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COL-225
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COL-225')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coke Light 2250ml',
        RecommendedSellingPrice = 28.00,
        LastPaidPrice = 28.00,
        AverageCost = 15.10,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COL-225';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COL-225', 'Coke Light 2250ml', 28.00, 28.00, 15.10, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COL-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COL-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola Light 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 17.33,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COL-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COL-2LT', 'Coca-Cola Light 2l', 30.00, 30.00, 17.33, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COL-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COL-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola Light 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 17.33,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COL-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COL-2LT', 'Coca-Cola Light 2l', 30.00, 30.00, 17.33, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COL-300C
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COL-300C')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coke 300ml Can',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COL-300C';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COL-300C', 'Coke 300ml Can', 13.00, 13.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COL-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COL-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola Light 330ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 9.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COL-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COL-330', 'Coca-Cola Light 330ml Can', 15.00, 15.00, 9.17, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COL-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COL-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola Light 500ml',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 10.01,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COL-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COL-500', 'Coca-Cola Light 500ml', 18.00, 18.00, 10.01, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COR-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COR-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cortado Short',
        RecommendedSellingPrice = 35.00,
        LastPaidPrice = 35.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COR-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COR-250ML', 'Cortado Short', 35.00, 35.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COZ-2250
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COZ-2250')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coke Zero 2250ml',
        RecommendedSellingPrice = 28.00,
        LastPaidPrice = 28.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COZ-2250';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COZ-2250', 'Coke Zero 2250ml', 28.00, 28.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COZ-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COZ-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola Zero 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 17.34,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COZ-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COZ-2LT', 'Coca-Cola Zero 2l', 30.00, 30.00, 17.34, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COZ-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COZ-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola Zero 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 17.34,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COZ-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COZ-2LT', 'Coca-Cola Zero 2l', 30.00, 30.00, 17.34, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COZ-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COZ-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola Zero 300ml Can',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COZ-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COZ-330', 'Coca-Cola Zero 300ml Can', 13.00, 13.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-COZ-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-COZ-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coca-Cola Zero 500ml',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 10.01,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-COZ-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-COZ-500', 'Coca-Cola Zero 500ml', 18.00, 18.00, 10.01, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CPP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CPP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cappy Passion Peach',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 11.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CPP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CPP-EAC', 'Cappy Passion Peach', 20.00, 20.00, 11.29, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CRE-400ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CRE-400ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream Soda 400ml',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CRE-400ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CRE-400ML', 'Cream Soda 400ml', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-CTP-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-CTP-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cappy Trop Punch 330ml',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-CTP-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-CTP-330', 'Cappy Trop Punch 330ml', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-ESS-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-ESS-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Espresso Short',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-ESS-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-ESS-250ML', 'Espresso Short', 22.00, 22.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-ESS-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-ESS-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Espresso Tall',
        RecommendedSellingPrice = 26.00,
        LastPaidPrice = 26.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-ESS-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-ESS-350ML', 'Espresso Tall', 26.00, 26.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAG-1LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAG-1LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Grape',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 10.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAG-1LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAG-1LT', 'Fanta Grape', 22.00, 22.00, 10.29, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAG-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAG-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Grape 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 18.03,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAG-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAG-2LT', 'Fanta Grape 2l', 30.00, 30.00, 18.03, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAG-300
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAG-300')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Grape 300ml Bottle',
        RecommendedSellingPrice = 9.00,
        LastPaidPrice = 9.00,
        AverageCost = 6.63,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAG-300';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAG-300', 'Fanta Grape 300ml Bottle', 9.00, 9.00, 6.63, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAG-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAG-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Grape 300ml CAN',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 6.41,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAG-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAG-330', 'Fanta Grape 300ml CAN', 13.00, 13.00, 6.41, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAG-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAG-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Grape 440ml Buddy',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 8.83,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAG-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAG-500', 'Fanta Grape 440ml Buddy', 20.00, 20.00, 8.83, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAN-300C
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAN-300C')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Orange 300ml Can',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAN-300C';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAN-300C', 'Fanta Orange 300ml Can', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAN-440
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAN-440')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Orange 400ml can',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAN-440';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAN-440', 'Fanta Orange 400ml can', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAO-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAO-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Orange 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 19.48,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAO-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAO-2LT', 'Fanta Orange 2l', 30.00, 30.00, 19.48, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAO-300
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAO-300')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Orange 300ml Bottle',
        RecommendedSellingPrice = 7.00,
        LastPaidPrice = 7.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAO-300';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAO-300', 'Fanta Orange 300ml Bottle', 7.00, 7.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAO-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAO-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Orange 300ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 9.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAO-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAO-330', 'Fanta Orange 300ml Can', 15.00, 15.00, 9.17, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAO-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAO-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Orange 440ml Buddy',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 10.01,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAO-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAO-500', 'Fanta Orange 440ml Buddy', 20.00, 20.00, 10.01, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAP-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAP-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Pineapple 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 18.75,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAP-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAP-2LT', 'Fanta Pineapple 2l', 30.00, 30.00, 18.75, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAP-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAP-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Pineapple 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 18.75,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAP-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAP-2LT', 'Fanta Pineapple 2l', 30.00, 30.00, 18.75, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAP-300
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAP-300')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Pine 300ml Bottle',
        RecommendedSellingPrice = 9.00,
        LastPaidPrice = 9.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAP-300';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAP-300', 'Fanta Pine 300ml Bottle', 9.00, 9.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAP-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAP-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Pineapple 330ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAP-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAP-330', 'Fanta Pineapple 330ml Can', 15.00, 15.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAP-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAP-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Pineapple 440ml Buddy',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 9.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAP-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAP-500', 'Fanta Pineapple 440ml Buddy', 20.00, 20.00, 9.29, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FAS-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FAS-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta 1 litre',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 10.94,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FAS-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FAS-125', 'Fanta 1 litre', 22.00, 22.00, 10.94, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FLW-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FLW-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Flat White Short',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FLW-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FLW-250ML', 'Flat White Short', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FLW-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FLW-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Flat White Tall',
        RecommendedSellingPrice = 35.00,
        LastPaidPrice = 35.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FLW-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FLW-350ML', 'Flat White Tall', 35.00, 35.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FOC-500ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FOC-500ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta Orange Can 500ml',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 9.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FOC-500ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FOC-500ML', 'Fanta Orange Can 500ml', 18.00, 18.00, 9.17, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FRT-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FRT-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Five Roses Tea Short',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FRT-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FRT-250ML', 'Five Roses Tea Short', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FRT-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FRT-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Five Roses Tea Tall',
        RecommendedSellingPrice = 28.00,
        LastPaidPrice = 28.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FRT-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FRT-350ML', 'Five Roses Tea Tall', 28.00, 28.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-FWT-400ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-FWT-400ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta What The Flavour 400ml Buddy',
        RecommendedSellingPrice = 14.50,
        LastPaidPrice = 14.50,
        AverageCost = 8.58,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-FWT-400ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-FWT-400ML', 'Fanta What The Flavour 400ml Buddy', 14.50, 14.50, 8.58, 'RawMaterial', 1);
END

-- Update or Insert: DRI-GRA-275
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-GRA-275')
BEGIN
    UPDATE Products 
    SET ProductName = 'Grapetiser 275ml NRB',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-GRA-275';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-GRA-275', 'Grapetiser 275ml NRB', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-GRA-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-GRA-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Grapetiser 330ml Can',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 10.67,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-GRA-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-GRA-330', 'Grapetiser 330ml Can', 20.00, 20.00, 10.67, 'RawMaterial', 1);
END

-- Update or Insert: DRI-GRW-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-GRW-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Grapetiser Wht 330ml Can',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-GRW-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-GRW-330', 'Grapetiser Wht 330ml Can', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-HAF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-HAF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hazelnut Freezo',
        RecommendedSellingPrice = 35.00,
        LastPaidPrice = 35.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-HAF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-HAF-EAC', 'Hazelnut Freezo', 35.00, 35.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-HOC-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-HOC-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hot Chocolate Short',
        RecommendedSellingPrice = 38.00,
        LastPaidPrice = 38.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-HOC-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-HOC-250ML', 'Hot Chocolate Short', 38.00, 38.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-HOC-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-HOC-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hot Chocolate Tall',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-HOC-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-HOC-350ML', 'Hot Chocolate Tall', 45.00, 45.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-HWT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-HWT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tall White Hot Chocolate',
        RecommendedSellingPrice = 34.00,
        LastPaidPrice = 34.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-HWT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-HWT-EAC', 'Tall White Hot Chocolate', 34.00, 34.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-IAM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-IAM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iced Americano',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-IAM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-IAM-EAC', 'Iced Americano', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-IBR-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-IBR-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iron Brew1.25ml',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-IBR-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-IBR-125', 'Iron Brew1.25ml', 12.00, 12.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-ICC-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-ICC-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iced Cappuccino Short',
        RecommendedSellingPrice = 32.00,
        LastPaidPrice = 32.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-ICC-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-ICC-250ML', 'Iced Cappuccino Short', 32.00, 32.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-ICC-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-ICC-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iced Cappuccino Tall',
        RecommendedSellingPrice = 38.00,
        LastPaidPrice = 38.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-ICC-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-ICC-350ML', 'Iced Cappuccino Tall', 38.00, 38.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-ICF-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-ICF-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iced Coffee Freezo Short',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-ICF-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-ICF-250ML', 'Iced Coffee Freezo Short', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-ICF-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-ICF-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iced Coffee Freezo Tall',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-ICF-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-ICF-350ML', 'Iced Coffee Freezo Tall', 45.00, 45.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-ICF-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-ICF-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Instabean Coffee Freezo',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-ICF-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-ICF-KGR', 'Instabean Coffee Freezo', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-ICL-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-ICL-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iced Chai Latte Short',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-ICL-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-ICL-250ML', 'Iced Chai Latte Short', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-ICL-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-ICL-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iced Chai Latte Tall',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-ICL-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-ICL-350ML', 'Iced Chai Latte Tall', 45.00, 45.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-ILA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-ILA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iced Latte',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-ILA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-ILA-EAC', 'Iced Latte', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-IMO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-IMO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iced Mocha',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'DRI-IMO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-IMO-EAC', 'Iced Mocha', 30.00, 30.00, 0.00, 'internal', 1);
END

-- Update or Insert: DRI-IRO-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-IRO-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iron Brew 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-IRO-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-IRO-2LT', 'Iron Brew 2l', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-IRO-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-IRO-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iron Brew 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-IRO-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-IRO-2LT', 'Iron Brew 2l', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-IRO-300
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-IRO-300')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iron Brew 300ml',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-IRO-300';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-IRO-300', 'Iron Brew 300ml', 15.00, 15.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-IRO-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-IRO-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iron Brew 330ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-IRO-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-IRO-330', 'Iron Brew 330ml Can', 15.00, 15.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-IWM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-IWM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iced White Mocha',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-IWM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-IWM-EAC', 'Iced White Mocha', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-KAPP-500ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-KAPP-500ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Clover Krush 100% Apple',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 16.52,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-KAPP-500ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-KAPP-500ML', 'Clover Krush 100% Apple', 25.00, 25.00, 16.52, 'RawMaterial', 1);
END

-- Update or Insert: DRI-KFF-500ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-KFF-500ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Clover Krush 6 Fruit £ Fibre',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 17.39,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-KFF-500ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-KFF-500ML', 'Clover Krush 6 Fruit £ Fibre', 25.00, 25.00, 17.39, 'RawMaterial', 1);
END

-- Update or Insert: DRI-KOR-500ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-KOR-500ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Clover Krush 100% Orange',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 17.39,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-KOR-500ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-KOR-500ML', 'Clover Krush 100% Orange', 25.00, 25.00, 17.39, 'RawMaterial', 1);
END

-- Update or Insert: DRI-LAT-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-LAT-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Latte Tall',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-LAT-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-LAT-350ML', 'Latte Tall', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-LATT-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-LATT-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Latte Short',
        RecommendedSellingPrice = 32.00,
        LastPaidPrice = 32.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-LATT-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-LATT-250ML', 'Latte Short', 32.00, 32.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MAC-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MAC-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Macchiato Short',
        RecommendedSellingPrice = 26.00,
        LastPaidPrice = 26.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MAC-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MAC-250ML', 'Macchiato Short', 26.00, 26.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MAC-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MAC-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Macchiato Tall',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MAC-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MAC-350ML', 'Macchiato Tall', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MBO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MBO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Bombay Crush',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MBO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MBO-EAC', 'OD Bombay Crush', 45.00, 45.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MBU-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MBU-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Bubblegum Milkshake',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MBU-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MBU-EAC', 'OD Bubblegum Milkshake', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MCH-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MCH-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Chocolate Milkshake',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MCH-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MCH-EAC', 'OD Chocolate Milkshake', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MCO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MCO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Coffee Milkshake',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MCO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MCO-EAC', 'OD Coffee Milkshake', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MEN-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MEN-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Monster Engery 500ml',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 15.70,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MEN-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MEN-500', 'Monster Engery 500ml', 25.00, 25.00, 15.70, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MLI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MLI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Lime Milkshake',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MLI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MLI-EAC', 'OD Lime Milkshake', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MML-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MML-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Monster Mucho Logo 500ml',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 15.70,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MML-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MML-500', 'Monster Mucho Logo 500ml', 25.00, 25.00, 15.70, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MOC-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MOC-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mocha Short',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MOC-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MOC-250ML', 'Mocha Short', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MOC-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MOC-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mocha Tall',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MOC-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MOC-350ML', 'Mocha Tall', 45.00, 45.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MOF-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MOF-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mocha Freezo Short',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MOF-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MOF-250ML', 'Mocha Freezo Short', 50.00, 50.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MOF-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MOF-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mocha Freezo Tall',
        RecommendedSellingPrice = 55.00,
        LastPaidPrice = 55.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MOF-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MOF-350ML', 'Mocha Freezo Tall', 55.00, 55.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MON-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MON-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Monster Original',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 15.70,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MON-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MON-330', 'Monster Original', 25.00, 25.00, 15.70, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MON-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MON-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Monster',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MON-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MON-EAC', 'Monster', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MSC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MSC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Salted Caramel Milkshake',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MSC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MSC-EAC', 'OD Salted Caramel Milkshake', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MSC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MSC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Malora Spicey Chai Latte',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MSC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MSC-KGR', 'Malora Spicey Chai Latte', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MST-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MST-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Strawberry Milkshake',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MST-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MST-EAC', 'OD Strawberry Milkshake', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-MVA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-MVA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Vanilla Milkshake',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-MVA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-MVA-EAC', 'OD Vanilla Milkshake', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-OBS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-OBS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Berry Smoothie',
        RecommendedSellingPrice = 65.00,
        LastPaidPrice = 65.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-OBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-OBS-EAC', 'OD Berry Smoothie', 65.00, 65.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-OMS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-OMS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Mango Smoothie',
        RecommendedSellingPrice = 65.00,
        LastPaidPrice = 65.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-OMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-OMS-EAC', 'OD Mango Smoothie', 65.00, 65.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-OOM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-OOM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Oreo Milkshake',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-OOM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-OOM-EAC', 'OD Oreo Milkshake', 45.00, 45.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-OSP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-OSP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Peanut Butter Smoothie',
        RecommendedSellingPrice = 65.00,
        LastPaidPrice = 65.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-OSP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-OSP-EAC', 'OD Peanut Butter Smoothie', 65.00, 65.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-PBB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-PBB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Powerade Blueberry 500ml',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 11.44,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-PBB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-PBB-EAC', 'Powerade Blueberry 500ml', 20.00, 20.00, 11.44, 'RawMaterial', 1);
END

-- Update or Insert: DRI-PGE-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-PGE-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Predator Gold Energy Drink 500ml',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 6.80,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-PGE-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-PGE-500', 'Predator Gold Energy Drink 500ml', 20.00, 20.00, 6.80, 'RawMaterial', 1);
END

-- Update or Insert: DRI-PJI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-PJI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Powerade Jagged Ice',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 11.44,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-PJI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-PJI-EAC', 'Powerade Jagged Ice', 20.00, 20.00, 11.44, 'RawMaterial', 1);
END

-- Update or Insert: DRI-PNA-500ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-PNA-500ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Powerade Naartjie',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 10.64,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-PNA-500ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-PNA-500ML', 'Powerade Naartjie', 20.00, 20.00, 10.64, 'RawMaterial', 1);
END

-- Update or Insert: DRI-PPL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-PPL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Powerplay',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-PPL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-PPL-EAC', 'Powerplay', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-REB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-REB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Red Bull 250ml',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 13.04,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-REB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-REB-EAC', 'Red Bull 250ml', 25.00, 25.00, 13.04, 'RawMaterial', 1);
END

-- Update or Insert: DRI-REC-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-REC-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Red Cappuccino',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-REC-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-REC-350ML', 'Red Cappuccino', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-ROB-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-ROB-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rooibos Tea Short',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-ROB-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-ROB-250ML', 'Rooibos Tea Short', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-RSF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-RSF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Red Bull Sugar Free',
        RecommendedSellingPrice = 23.50,
        LastPaidPrice = 23.50,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-RSF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-RSF-EAC', 'Red Bull Sugar Free', 23.50, 23.50, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SCS-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SCS-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar C/Soda 1250ml',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SCS-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SCS-125', 'Spar C/Soda 1250ml', 12.00, 12.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SCS-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SCS-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar C\Soda 2lt',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 16.90,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SCS-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SCS-2LT', 'Spar C\Soda 2lt', 30.00, 30.00, 16.90, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SCS-300
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SCS-300')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar C/Soda 300ml',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 9.67,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SCS-300';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SCS-300', 'Spar C/Soda 300ml', 15.00, 15.00, 9.67, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SCS-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SCS-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar C/Soda 330ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 8.02,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SCS-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SCS-330', 'Spar C/Soda 330ml Can', 15.00, 15.00, 8.02, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SCS-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SCS-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar Cream Soda 440ml Buddy',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 10.01,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SCS-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SCS-500', 'Spar Cream Soda 440ml Buddy', 20.00, 20.00, 10.01, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SIB-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SIB-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar Iron Brew 1250ml',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SIB-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SIB-125', 'Spar Iron Brew 1250ml', 12.00, 12.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SPN-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SPN-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar Pine Nut 1250ml',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SPN-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SPN-125', 'Spar Pine Nut 1250ml', 12.00, 12.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SPN-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SPN-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar Sparbry Pine Nut 2ltr',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 12.59,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SPN-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SPN-2LT', 'Spar Sparbry Pine Nut 2ltr', 30.00, 30.00, 12.59, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SPR-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SPR-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sprite 1 litre',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 10.94,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SPR-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SPR-125', 'Sprite 1 litre', 22.00, 22.00, 10.94, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SPR-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SPR-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sprite 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 19.48,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SPR-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SPR-2LT', 'Sprite 2l', 30.00, 30.00, 19.48, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SPR-300
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SPR-300')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sprite 300ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 8.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SPR-300';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SPR-300', 'Sprite 300ml Can', 15.00, 15.00, 8.29, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SPR-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SPR-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sprite 330ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 8.47,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SPR-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SPR-330', 'Sprite 330ml Can', 15.00, 15.00, 8.47, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SPR-440
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SPR-440')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sprite 400ml can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 9.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SPR-440';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SPR-440', 'Sprite 400ml can', 15.00, 15.00, 9.17, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SPR-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SPR-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sprite 440ml Buddy',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 10.01,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SPR-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SPR-500', 'Sprite 440ml Buddy', 20.00, 20.00, 10.01, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SPZ-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SPZ-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sprite Zero 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SPZ-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SPZ-2LT', 'Sprite Zero 2l', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SPZ-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SPZ-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sprite Zero 330ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SPZ-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SPZ-330', 'Sprite Zero 330ml Can', 15.00, 15.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SPZ-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SPZ-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sprite Zero 500ml',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 8.47,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SPZ-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SPZ-500', 'Sprite Zero 500ml', 18.00, 18.00, 8.47, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SRB-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SRB-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sparletta Raspberry 440ml Buddy',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 10.01,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SRB-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SRB-500', 'Sparletta Raspberry 440ml Buddy', 20.00, 20.00, 10.01, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SSB-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SSB-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sparletta 1250ml',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SSB-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SSB-125', 'Sparletta 1250ml', 12.00, 12.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SSB-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SSB-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar Sparberry 2LTR',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 16.90,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SSB-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SSB-2LT', 'Spar Sparberry 2LTR', 30.00, 30.00, 16.90, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SSB-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SSB-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar Sparbry 300ml Can',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 9.67,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SSB-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SSB-330', 'Spar Sparbry 300ml Can', 13.00, 13.00, 9.67, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SST-300
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SST-300')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar Stoney 300ml',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SST-300';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SST-300', 'Spar Stoney 300ml', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SST-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SST-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spar Stoney 330ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 7.28,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SST-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SST-330', 'Spar Stoney 330ml Can', 15.00, 15.00, 7.28, 'RawMaterial', 1);
END

-- Update or Insert: DRI-STO-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-STO-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Stoney 1 litre',
        RecommendedSellingPrice = 22.00,
        LastPaidPrice = 22.00,
        AverageCost = 10.94,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-STO-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-STO-125', 'Stoney 1 litre', 22.00, 22.00, 10.94, 'RawMaterial', 1);
END

-- Update or Insert: DRI-STO-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-STO-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Stoney Ginger Beer 2lt',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 19.48,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-STO-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-STO-2LT', 'Stoney Ginger Beer 2lt', 30.00, 30.00, 19.48, 'RawMaterial', 1);
END

-- Update or Insert: DRI-STO-440
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-STO-440')
BEGIN
    UPDATE Products 
    SET ProductName = 'Stoney 400ml can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 9.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-STO-440';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-STO-440', 'Stoney 400ml can', 15.00, 15.00, 9.17, 'RawMaterial', 1);
END

-- Update or Insert: DRI-STO-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-STO-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Stoney -gingerbeer 440ml Buddy',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 10.01,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-STO-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-STO-500', 'Stoney -gingerbeer 440ml Buddy', 20.00, 20.00, 10.01, 'RawMaterial', 1);
END

-- Update or Insert: DRI-STW-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-STW-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Water 500ml Still',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-STW-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-STW-500', 'Water 500ml Still', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-STW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-STW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Still Water',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-STW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-STW-EAC', 'Still Water', 15.00, 15.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-SWM-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-SWM-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Short White Mocha',
        RecommendedSellingPrice = 34.00,
        LastPaidPrice = 34.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-SWM-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-SWM-250ML', 'Short White Mocha', 34.00, 34.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TGR-1.5L
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TGR-1.5L')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Grandilla 1.5ltr',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 10.09,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TGR-1.5L';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TGR-1.5L', 'Twist Grandilla 1.5ltr', 15.00, 15.00, 10.09, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWG-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWG-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Gran 1250ml',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWG-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWG-125', 'Twist Gran 1250ml', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWG-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWG-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Gran 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 12.59,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWG-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWG-2LT', 'Twist Gran 2l', 30.00, 30.00, 12.59, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWG-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWG-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Gran 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 12.59,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWG-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWG-2LT', 'Twist Gran 2l', 30.00, 30.00, 12.59, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWG-300
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWG-300')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Gran 300ml',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWG-300';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWG-300', 'Twist Gran 300ml', 15.00, 15.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWG-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWG-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Gran 300ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 6.63,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWG-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWG-330', 'Twist Gran 300ml Can', 15.00, 15.00, 6.63, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWG-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWG-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Gran 440ml Buddy',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 9.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWG-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWG-500', 'Twist Gran 440ml Buddy', 20.00, 20.00, 9.29, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWL-1.5L
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWL-1.5L')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Lemon 1.5 Litre',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWL-1.5L';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWL-1.5L', 'Twist Lemon 1.5 Litre', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWL-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWL-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Lemon 1250ml',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWL-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWL-125', 'Twist Lemon 1250ml', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWL-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWL-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Lemon 2l',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 12.59,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWL-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWL-2LT', 'Twist Lemon 2l', 30.00, 30.00, 12.59, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWL-330
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWL-330')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Lemon 300ml Can',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 8.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWL-330';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWL-330', 'Twist Lemon 300ml Can', 15.00, 15.00, 8.29, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWL-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWL-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Twist Lemon 500ml',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 9.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWL-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWL-500', 'Twist Lemon 500ml', 18.00, 18.00, 9.29, 'RawMaterial', 1);
END

-- Update or Insert: DRI-TWM-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-TWM-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tall White Mocha',
        RecommendedSellingPrice = 42.00,
        LastPaidPrice = 42.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-TWM-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-TWM-350ML', 'Tall White Mocha', 42.00, 42.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-VAF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-VAF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Vanilla Freezo',
        RecommendedSellingPrice = 40,
        LastPaidPrice = 40,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-VAF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-VAF-EAC', 'Vanilla Freezo', 40, 40, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-VAL-150
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-VAL-150')
BEGIN
    UPDATE Products 
    SET ProductName = 'Water valpre still 1500ml',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-VAL-150';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-VAL-150', 'Water valpre still 1500ml', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-VAL-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-VAL-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Water Valpre Still 500ml',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-VAL-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-VAL-500', 'Water Valpre Still 500ml', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-WCF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-WCF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'White Chocolate Freezo',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-WCF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-WCF-EAC', 'White Chocolate Freezo', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-WHS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-WHS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Short White Hot Chocolate',
        RecommendedSellingPrice = 26.00,
        LastPaidPrice = 26.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-WHS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-WHS-EAC', 'Short White Hot Chocolate', 26.00, 26.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: DRI-WTF-2LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'DRI-WTF-2LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fanta What The Flavour 2litre',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'DRI-WTF-2LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('DRI-WTF-2LTR', 'Fanta What The Flavour 2litre', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ICE-SMO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ICE-SMO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'GLUTEN FREE LEMON FRIDGE CHEESECAKE TUB',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'ICE-SMO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ICE-SMO-EAC', 'GLUTEN FREE LEMON FRIDGE CHEESECAKE TUB', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: ICE-SRP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ICE-SRP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'GLUTEN FREE CHOCOLATE GANACHE TUB',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'ICE-SRP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ICE-SRP-EAC', 'GLUTEN FREE CHOCOLATE GANACHE TUB', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: JUI- FNB-500ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI- FNB-500ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Juice Krush Fruit Nectar 500ml',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI- FNB-500ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI- FNB-500ML', 'Juice Krush Fruit Nectar 500ml', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: JUI-DBY-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-DBY-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dairy Bel Double Cream Yogurt 1kg',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-DBY-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-DBY-EAC', 'Dairy Bel Double Cream Yogurt 1kg', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: JUI-EBL-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-EBL-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Energade 500ml Blueberry',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 8.33,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-EBL-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-EBL-500', 'Energade 500ml Blueberry', 20.00, 20.00, 8.33, 'RawMaterial', 1);
END

-- Update or Insert: JUI-EGR-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-EGR-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Energade 500ml Grape',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 9.42,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-EGR-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-EGR-500', 'Energade 500ml Grape', 20.00, 20.00, 9.42, 'RawMaterial', 1);
END

-- Update or Insert: JUI-ELL-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-ELL-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Energade 500ml Lemon & Lime',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-ELL-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-ELL-500', 'Energade 500ml Lemon & Lime', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: JUI-EMB-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-EMB-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Energade 500ml Mixed Berry',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 8.33,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-EMB-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-EMB-500', 'Energade 500ml Mixed Berry', 20.00, 20.00, 8.33, 'RawMaterial', 1);
END

-- Update or Insert: JUI-ENA-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-ENA-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Energade 500ml Naartjie',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 7.25,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-ENA-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-ENA-500', 'Energade 500ml Naartjie', 20.00, 20.00, 7.25, 'RawMaterial', 1);
END

-- Update or Insert: JUI-ENO-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-ENO-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Energade 500ml Orange',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-ENO-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-ENO-500', 'Energade 500ml Orange', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: JUI-ETR-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-ETR-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Energade 500ml Tropical',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 8.33,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-ETR-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-ETR-500', 'Energade 500ml Tropical', 20.00, 20.00, 8.33, 'RawMaterial', 1);
END

-- Update or Insert: JUI-KRM-500ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-KRM-500ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Clover Krush 100% Mango',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 17.39,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-KRM-500ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-KRM-500ML', 'Clover Krush 100% Mango', 25.00, 25.00, 17.39, 'RawMaterial', 1);
END

-- Update or Insert: JUI-MAA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-MAA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Maas 500g Low Fat',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-MAA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-MAA-EAC', 'Maas 500g Low Fat', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: JUI-ORA-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-ORA-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Juice 2l Orange Nectar',
        RecommendedSellingPrice = 32.00,
        LastPaidPrice = 32.00,
        AverageCost = 20.86,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-ORA-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-ORA-2LT', 'Juice 2l Orange Nectar', 32.00, 32.00, 20.86, 'RawMaterial', 1);
END

-- Update or Insert: JUI-ORA-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-ORA-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Juice 500ml Orange Nectar',
        RecommendedSellingPrice = 16.00,
        LastPaidPrice = 16.00,
        AverageCost = 11.30,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-ORA-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-ORA-500', 'Juice 500ml Orange Nectar', 16.00, 16.00, 11.30, 'RawMaterial', 1);
END

-- Update or Insert: JUI-PIN-1LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-PIN-1LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Juice Tropika 1Litre',
        RecommendedSellingPrice = 21.00,
        LastPaidPrice = 21.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-PIN-1LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-PIN-1LT', 'Juice Tropika 1Litre', 21.00, 21.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: JUI-TRO-1.5L
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-TRO-1.5L')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tropika 1.5lt pineapple',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-TRO-1.5L';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-TRO-1.5L', 'Tropika 1.5lt pineapple', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: JUI-TRO-1.5Lt
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-TRO-1.5Lt')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tropika 1.5lt Orange',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-TRO-1.5Lt';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-TRO-1.5Lt', 'Tropika 1.5lt Orange', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: JUI-TRO-1LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-TRO-1LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tropika 1l Orange',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-TRO-1LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-TRO-1LT', 'Tropika 1l Orange', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: JUI-TRO-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-TRO-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tropika 500ml Orange',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 12.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-TRO-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-TRO-500', 'Tropika 500ml Orange', 20.00, 20.00, 12.17, 'RawMaterial', 1);
END

-- Update or Insert: JUI-TRP-1LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-TRP-1LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tropika 1l Pineapple',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-TRP-1LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-TRP-1LT', 'Tropika 1l Pineapple', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: JUI-TRP-250
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-TRP-250')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tropika 250ml Pineapple',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-TRP-250';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-TRP-250', 'Tropika 250ml Pineapple', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: JUI-TRP-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'JUI-TRP-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tropika 500ml Pineapple',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 12.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'JUI-TRP-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('JUI-TRP-500', 'Tropika 500ml Pineapple', 20.00, 20.00, 12.17, 'RawMaterial', 1);
END

-- Update or Insert: MIL-ALM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-ALM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Almond Milk',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-ALM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-ALM-EAC', 'Almond Milk', 10.00, 10.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIL-CON-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-CON-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Clover Condensed Milk 385g',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-CON-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-CON-EAC', 'Clover Condensed Milk 385g', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIL-MFC-1LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-MFC-1LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milk 1l Full Cream',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 19.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-MFC-1LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-MFC-1LT', 'Milk 1l Full Cream', 30.00, 30.00, 19.00, 'RawMaterial', 1);
END

-- Update or Insert: MIL-MFC-250
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-MFC-250')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milk 250ml Full Cream',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 9.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-MFC-250';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-MFC-250', 'Milk 250ml Full Cream', 18.00, 18.00, 9.50, 'RawMaterial', 1);
END

-- Update or Insert: MIL-MFC-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-MFC-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milk 2ltr Full Cream',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-MFC-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-MFC-2LT', 'Milk 2ltr Full Cream', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIL-MFC-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-MFC-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milk 500ml Full Cream',
        RecommendedSellingPrice = 16.00,
        LastPaidPrice = 16.00,
        AverageCost = 11.71,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-MFC-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-MFC-500', 'Milk 500ml Full Cream', 16.00, 16.00, 11.71, 'RawMaterial', 1);
END

-- Update or Insert: MIL-OAT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-OAT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Oat Milk',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-OAT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-OAT-EAC', 'Oat Milk', 10.00, 10.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIL-SMB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-SMB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Super M 300ml Banana',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 11.30,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-SMB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-SMB-EAC', 'Super M 300ml Banana', 18.00, 18.00, 11.30, 'RawMaterial', 1);
END

-- Update or Insert: MIL-SMC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-SMC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Super M 300ml Chocolate',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 11.30,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-SMC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-SMC-EAC', 'Super M 300ml Chocolate', 18.00, 18.00, 11.30, 'RawMaterial', 1);
END

-- Update or Insert: MIL-SMO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-SMO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Super M 300ml Cream Soda',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 11.30,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-SMO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-SMO-EAC', 'Super M 300ml Cream Soda', 18.00, 18.00, 11.30, 'RawMaterial', 1);
END

-- Update or Insert: MIL-SMS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-SMS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Super M 300ml Strawberry',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 11.30,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-SMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-SMS-EAC', 'Super M 300ml Strawberry', 18.00, 18.00, 11.30, 'RawMaterial', 1);
END

-- Update or Insert: MIL-SOY-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIL-SOY-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Soy Milk',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIL-SOY-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIL-SOY-EAC', 'Soy Milk', 10.00, 10.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS - CCB-12
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS - CCB-12')
BEGIN
    UPDATE Products 
    SET ProductName = 'Colour Cream - 12''''',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS - CCB-12';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS - CCB-12', 'Colour Cream - 12''''', 80.00, 80.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS - SCB-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS - SCB-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Solid Colour Buttercream',
        RecommendedSellingPrice = 100,
        LastPaidPrice = 100,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS - SCB-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS - SCB-KGR', 'Solid Colour Buttercream', 100, 100, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS- CCB-14
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS- CCB-14')
BEGIN
    UPDATE Products 
    SET ProductName = 'Colour Cream - 14''''',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS- CCB-14';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS- CCB-14', 'Colour Cream - 14''''', 80.00, 80.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS- FIT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS- FIT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Happy Anniversary Cake Topper',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 52.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS- FIT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS- FIT-EAC', 'Happy Anniversary Cake Topper', 100.00, 100.00, 52.17, 'RawMaterial', 1);
END

-- Update or Insert: MIS- FON-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS- FON-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fondant Writing',
        RecommendedSellingPrice = 150.00,
        LastPaidPrice = 150.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS- FON-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS- FON-EAC', 'Fondant Writing', 150.00, 150.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-ACC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-ACC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Plastic Icing Baby Accessory Set',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-ACC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-ACC-EAC', 'Plastic Icing Baby Accessory Set', 60.00, 60.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-AES-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-AES-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Additional Espresso Shot',
        RecommendedSellingPrice = 10,
        LastPaidPrice = 10,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-AES-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-AES-EACH', 'Additional Espresso Shot', 10, 10, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-API-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-API-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Picture',
        RecommendedSellingPrice = 90.00,
        LastPaidPrice = 90.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-API-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-API-EAC', 'Picture', 90.00, 90.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-BAB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-BAB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Plastic icing Baby with blanket',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-BAB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-BAB-EAC', 'Plastic icing Baby with blanket', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-BGM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-BGM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bride & Groom Meduim',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-BGM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-BGM-EAC', 'Bride & Groom Meduim', 80.00, 80.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-BGS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-BGS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bride & Groom Small',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-BGS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-BGS-EAC', 'Bride & Groom Small', 60.00, 60.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-BLI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-BLI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Braai Lighter',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'MIS-BLI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-BLI-EAC', 'Braai Lighter', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: MIS-BMV-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-BMV-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mvutu Bar One',
        RecommendedSellingPrice = 9.00,
        LastPaidPrice = 9.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-BMV-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-BMV-EAC', 'Mvutu Bar One', 9.00, 9.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-BOO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-BOO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Plastic icing Booties',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-BOO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-BOO-EAC', 'Plastic icing Booties', 60.00, 60.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-BRP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-BRP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Big Roses With Polysterene',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-BRP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-BRP-EAC', 'Big Roses With Polysterene', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CAN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CAN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cancellation',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CAN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CAN-EAC', 'Cancellation', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CAT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CAT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cake Toppers Acyrlic',
        RecommendedSellingPrice = 120,
        LastPaidPrice = 120,
        AverageCost = 52.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CAT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CAT-EAC', 'Cake Toppers Acyrlic', 120, 120, 52.17, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CBC-BDC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CBC-BDC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Buttercream -Birthday Cake',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CBC-BDC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CBC-BDC', 'Chocolate Buttercream -Birthday Cake', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CCB-16
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CCB-16')
BEGIN
    UPDATE Products 
    SET ProductName = 'Colour Cream - 16''''',
        RecommendedSellingPrice = 120.00,
        LastPaidPrice = 120.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CCB-16';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CCB-16', 'Colour Cream - 16''''', 120.00, 120.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CCB-18
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CCB-18')
BEGIN
    UPDATE Products 
    SET ProductName = 'Colour Cream - 18''''',
        RecommendedSellingPrice = 120.00,
        LastPaidPrice = 120.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CCB-18';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CCB-18', 'Colour Cream - 18''''', 120.00, 120.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CCB-20
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CCB-20')
BEGIN
    UPDATE Products 
    SET ProductName = 'Colour Cream - 20''''',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CCB-20';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CCB-20', 'Colour Cream - 20''''', 180.00, 180.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CCB-22
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CCB-22')
BEGIN
    UPDATE Products 
    SET ProductName = 'Colour Cream - 22''''',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CCB-22';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CCB-22', 'Colour Cream - 22''''', 180.00, 180.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CGR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CGR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Custom Google Review Sign',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'MIS-CGR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CGR-EAC', 'Custom Google Review Sign', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: MIS-CHA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CHA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Service Charge for Changes',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CHA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CHA-EAC', 'Service Charge for Changes', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CHT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CHT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Figure Cake Topper',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CHT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CHT-EAC', 'Figure Cake Topper', 100.00, 100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CHW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CHW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Choc Writing',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CHW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CHW-EAC', 'Choc Writing', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CRS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CRS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'C20 Red Stamp',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'MIS-CRS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CRS-EAC', 'C20 Red Stamp', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: MIS-CSA-(6S)
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CSA-(6S)')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Assorted Sparkle (6s)',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'MIS-CSA-(6S)';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CSA-(6S)', 'Candle Assorted Sparkle (6s)', 100.00, 100.00, 0.00, 'external', 1);
END

-- Update or Insert: MIS-CSG-(6s)
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CSG-(6s)')
BEGIN
    UPDATE Products 
    SET ProductName = 'Candle Sparkle Gold (6s)',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'MIS-CSG-(6s)';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CSG-(6s)', 'Candle Sparkle Gold (6s)', 100.00, 100.00, 0.00, 'external', 1);
END

-- Update or Insert: MIS-CUP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CUP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Foam Cups 250ml',
        RecommendedSellingPrice = 1.00,
        LastPaidPrice = 1.00,
        AverageCost = 0.30,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CUP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CUP-EAC', 'Foam Cups 250ml', 1.00, 1.00, 0.30, 'RawMaterial', 1);
END

-- Update or Insert: MIS-CWR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-CWR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Customised Writing',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-CWR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-CWR-EAC', 'Customised Writing', 10.00, 10.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DAO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DAO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Day Old Cakes',
        RecommendedSellingPrice = 8.00,
        LastPaidPrice = 8.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DAO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DAO-EAC', 'Day Old Cakes', 8.00, 8.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBC-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBC-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Choc 12',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBC-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBC-012', 'Dbl Choc 12', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBC-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBC-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Choc 14',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBC-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBC-014', 'Dbl Choc 14', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBC-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBC-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Choc 16',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBC-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBC-016', 'Dbl Choc 16', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBC-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBC-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Choc 18',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBC-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBC-018', 'Dbl Choc 18', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBC-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBC-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Choc 20',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBC-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBC-020', 'Dbl Choc 20', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBC-022
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBC-022')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Choc 22',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBC-022';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBC-022', 'Dbl Choc 22', 25.00, 25.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBV-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBV-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Vanilla 12',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBV-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBV-012', 'Dbl Vanilla 12', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBV-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBV-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Vanilla 14',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBV-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBV-014', 'Dbl Vanilla 14', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBV-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBV-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Vanilla 16',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBV-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBV-016', 'Dbl Vanilla 16', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBV-018
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBV-018')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Vanilla 18',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBV-018';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBV-018', 'Dbl Vanilla 18', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBV-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBV-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Vanilla 20',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBV-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBV-020', 'Dbl Vanilla 20', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DBV-022
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DBV-022')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dbl Vanilla 22',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DBV-022';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DBV-022', 'Dbl Vanilla 22', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DEL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DEL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Delivery',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 30.43,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DEL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DEL-EAC', 'Delivery', 0, 0, 30.43, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DMV-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DMV-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mvutu Donut 4s',
        RecommendedSellingPrice = 6.00,
        LastPaidPrice = 6.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DMV-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DMV-EACH', 'Mvutu Donut 4s', 6.00, 6.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-DOR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DOR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Oven Delights Flags',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 800.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'MIS-DOR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DOR-EAC', 'Oven Delights Flags', 15.00, 15.00, 800.00, 'internal', 1);
END

-- Update or Insert: MIS-DOS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-DOS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Day Old Scones',
        RecommendedSellingPrice = 17.00,
        LastPaidPrice = 17.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-DOS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-DOS-EAC', 'Day Old Scones', 17.00, 17.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-EPO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-EPO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Edible Picture Only',
        RecommendedSellingPrice = 200.00,
        LastPaidPrice = 200.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-EPO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-EPO-EAC', 'Edible Picture Only', 200.00, 200.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-FAK-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-FAK-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'First Aid Kit',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'MIS-FAK-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-FAK-EAC', 'First Aid Kit', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: MIS-FCB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-FCB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Balloons -Foil Character',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-FCB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-FCB-EAC', 'Balloons -Foil Character', 50.00, 50.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-FFL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-FFL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fresh Flowers Each',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-FFL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-FFL-EAC', 'Fresh Flowers Each', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-FGB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-FGB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Balloons-Foil General',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-FGB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-FGB-EAC', 'Balloons-Foil General', 50.00, 50.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-FMG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-FMG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Balloons- Foil Number Gold',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-FMG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-FMG-EAC', 'Balloons- Foil Number Gold', 100.00, 100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-FNG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-FNG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Balloons- Foil Number Rose Gold',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-FNG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-FNG-EAC', 'Balloons- Foil Number Rose Gold', 100.00, 100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-FNR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-FNR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Balloons-Foil Number Rainbow Splash',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-FNR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-FNR-EAC', 'Balloons-Foil Number Rainbow Splash', 100.00, 100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-FNS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-FNS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Balloons- Foil Number Silver',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-FNS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-FNS-EAC', 'Balloons- Foil Number Silver', 100.00, 100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-FNW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-FNW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Balloons-Foil Number White Gold',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-FNW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-FNW-EAC', 'Balloons-Foil Number White Gold', 100.00, 100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-FWO-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-FWO-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fondant Wording',
        RecommendedSellingPrice = 150.00,
        LastPaidPrice = 150.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-FWO-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-FWO-EACH', 'Fondant Wording', 150.00, 150.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-GBE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-GBE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gold Beads',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-GBE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-GBE-EAC', 'Gold Beads', 10.00, 10.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-GWR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-GWR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gold Writing',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-GWR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-GWR-EAC', 'Gold Writing', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-HBT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-HBT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Happy Birthday Cake Topper',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 52.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-HBT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-HBT-EAC', 'Happy Birthday Cake Topper', 100.00, 100.00, 52.17, 'RawMaterial', 1);
END

-- Update or Insert: MIS-HEL-5LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-HEL-5LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Heluim Small Cylinder',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'MIS-HEL-5LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-HEL-5LTR', 'Heluim Small Cylinder', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: MIS-HEL-LAR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-HEL-LAR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Heluim Large',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 24.35,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-HEL-LAR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-HEL-LAR', 'Heluim Large', 100.00, 100.00, 24.35, 'RawMaterial', 1);
END

-- Update or Insert: MIS-HEL-SML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-HEL-SML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Heluim Small',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 14.78,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-HEL-SML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-HEL-SML', 'Heluim Small', 50.00, 50.00, 14.78, 'RawMaterial', 1);
END

-- Update or Insert: MIS-LEA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-LEA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Leaves',
        RecommendedSellingPrice = 3.00,
        LastPaidPrice = 3.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-LEA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-LEA-EAC', 'Leaves', 3.00, 3.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-MAT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-MAT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Matches',
        RecommendedSellingPrice = 1.00,
        LastPaidPrice = 1.00,
        AverageCost = 34.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'MIS-MAT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-MAT-EAC', 'Matches', 1.00, 1.00, 34.00, 'external', 1);
END

-- Update or Insert: MIS-MGR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-MGR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rib Metallic Gold',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-MGR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-MGR-EAC', 'Rib Metallic Gold', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-MSR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-MSR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rib Metallic Silver',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-MSR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-MSR-EAC', 'Rib Metallic Silver', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-MVU-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-MVU-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mvutu',
        RecommendedSellingPrice = 6.00,
        LastPaidPrice = 6.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-MVU-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-MVU-EAC', 'Mvutu', 6.00, 6.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-NOV-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-NOV-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Novelities Sets',
        RecommendedSellingPrice = 120.00,
        LastPaidPrice = 120.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-NOV-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-NOV-EAC', 'Novelities Sets', 120.00, 120.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-OOH-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-OOH-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Overheads',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'MIS-OOH-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-OOH-EACH', 'Overheads', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: MIS-PAN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-PAN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Panado',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'MIS-PAN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-PAN-EAC', 'Panado', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: MIS-PLA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-PLA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Plasters',
        RecommendedSellingPrice = 0.80,
        LastPaidPrice = 0.80,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'MIS-PLA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-PLA-EAC', 'Plasters', 0.80, 0.80, 0.00, 'external', 1);
END

-- Update or Insert: MIS-PLD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-PLD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Dip 70ml',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-PLD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-PLD-EAC', 'Platter Dip 70ml', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-RAS-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-RAS-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rakhi String',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 20.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-RAS-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-RAS-EACH', 'Rakhi String', 30.00, 30.00, 20.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-RIP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-RIP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ribbon Picture',
        RecommendedSellingPrice = 150,
        LastPaidPrice = 150,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-RIP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-RIP-EAC', 'Ribbon Picture', 150, 150, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-RMV-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-RMV-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mvutu Rainbow',
        RecommendedSellingPrice = 5.00,
        LastPaidPrice = 5.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-RMV-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-RMV-EAC', 'Mvutu Rainbow', 5.00, 5.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-ROS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-ROS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Roses',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-ROS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-ROS-EAC', 'Roses', 12.00, 12.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-RSS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-RSS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Roses Small New Assorted Colours',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-RSS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-RSS-EAC', 'Roses Small New Assorted Colours', 12.00, 12.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-SBE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-SBE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Silver Beads',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-SBE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-SBE-EAC', 'Silver Beads', 10.00, 10.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-SCB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-SCB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Balloons- Stick Character',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-SCB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-SCB-EAC', 'Balloons- Stick Character', 50.00, 50.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-SDC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-SDC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Same Day Charge',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-SDC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-SDC-EAC', 'Same Day Charge', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-SFB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-SFB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sign Happy Birthday Gold Foil',
        RecommendedSellingPrice = 8.00,
        LastPaidPrice = 8.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-SFB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-SFB-EAC', 'Sign Happy Birthday Gold Foil', 8.00, 8.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-SGA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-SGA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sign H.A. Gold',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-SGA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-SGA-EAC', 'Sign H.A. Gold', 10.00, 10.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-SGB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-SGB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sign H.B. Gold',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-SGB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-SGB-EAC', 'Sign H.B. Gold', 10.00, 10.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-STG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-STG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Balloons-Stick General',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-STG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-STG-EAC', 'Balloons-Stick General', 50.00, 50.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-STR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-STR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Strawberry',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-STR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-STR-EAC', 'Strawberry', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-SWR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-SWR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Silver Writing',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-SWR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-SWR-EAC', 'Silver Writing', 15.00, 15.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-TOO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-TOO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Toothpicks 1000s',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-TOO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-TOO-EAC', 'Toothpicks 1000s', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-WHC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-WHC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Additional Whipped Cream',
        RecommendedSellingPrice = 7.00,
        LastPaidPrice = 7.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-WHC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-WHC-EAC', 'Additional Whipped Cream', 7.00, 7.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: MIS-XSR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'MIS-XSR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Xmas Sticker Scroll English',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'MIS-XSR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('MIS-XSR-EAC', 'Xmas Sticker Scroll English', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: M-KOK-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'M-KOK-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Kokomix Pettina',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'M-KOK-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('M-KOK-KGR', 'Kokomix Pettina', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC- BTL-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC- BTL-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bag Brown Thrifty Paper Bag Large',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC- BTL-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC- BTL-EACH', 'Bag Brown Thrifty Paper Bag Large', 0, 0, 2.40, 'RawMaterial', 1);
END

-- Update or Insert: PAC- CUC-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC- CUC-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cup Clear 350ML',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC- CUC-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC- CUC-350ML', 'Cup Clear 350ML', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC -F3D-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC -F3D-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'F3 Double Wall Pie box',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC -F3D-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC -F3D-EAC', 'F3 Double Wall Pie box', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC- HAB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC- HAB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hamburger Base Black F60',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.24,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC- HAB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC- HAB-EAC', 'Hamburger Base Black F60', 0, 0, 0.24, 'RawMaterial', 1);
END

-- Update or Insert: PAC- LIC- 350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC- LIC- 350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Lids Clear 350ML',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC- LIC- 350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC- LIC- 350ML', 'Lids Clear 350ML', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC- MIN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC- MIN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cup Cake Boxes With Inserts',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC- MIN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC- MIN-EAC', 'Cup Cake Boxes With Inserts', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC- NAB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC- NAB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Name Badges',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 20.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'PAC- NAB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC- NAB-EAC', 'Name Badges', 0, 0, 20.00, 'external', 1);
END

-- Update or Insert: PAC- SDL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC- SDL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Square Desert Lid',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.02,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC- SDL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC- SDL-EAC', 'Square Desert Lid', 0, 0, 1.02, 'RawMaterial', 1);
END

-- Update or Insert: PAC-083-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-083-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '83X54X300 30mic',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.35,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-083-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-083-EAC', '83X54X300 30mic', 0, 0, 0.35, 'RawMaterial', 1);
END

-- Update or Insert: PAC-12X-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-12X-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '12x12x6',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 12.86,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-12X-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-12X-EAC', '12x12x6', 0, 0, 12.86, 'RawMaterial', 1);
END

-- Update or Insert: PAC-14X-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-14X-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '14X14X6',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 13.35,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-14X-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-14X-EAC', '14X14X6', 0, 0, 13.35, 'RawMaterial', 1);
END

-- Update or Insert: PAC-16X-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-16X-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '16x16x6',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 15.79,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-16X-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-16X-EAC', '16x16x6', 0, 0, 15.79, 'RawMaterial', 1);
END

-- Update or Insert: PAC-18H-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-18H-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '18X18X5 High',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 14.44,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-18H-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-18H-EAC', '18X18X5 High', 0, 0, 14.44, 'RawMaterial', 1);
END

-- Update or Insert: PAC-18X-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-18X-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '18X18X6',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 19.27,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-18X-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-18X-EAC', '18X18X6', 0, 0, 19.27, 'RawMaterial', 1);
END

-- Update or Insert: PAC-196-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-196-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '196T swissroll folder',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.85,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-196-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-196-EAC', '196T swissroll folder', 0, 0, 1.85, 'RawMaterial', 1);
END

-- Update or Insert: PAC-200-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-200-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Foil Container 100 (200IL)',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.32,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-200-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-200-EAC', 'Foil Container 100 (200IL)', 0, 0, 0.32, 'RawMaterial', 1);
END

-- Update or Insert: PAC-20H-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-20H-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '20X20X5 High',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-20H-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-20H-EAC', '20X20X5 High', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-20X-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-20X-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '20X20X6',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 28.57,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-20X-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-20X-EAC', '20X20X6', 0, 0, 28.57, 'RawMaterial', 1);
END

-- Update or Insert: PAC-214-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-214-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '214 Gateaux Dome',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 3.02,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-214-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-214-EAC', '214 Gateaux Dome', 0, 0, 3.02, 'RawMaterial', 1);
END

-- Update or Insert: PAC-215-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-215-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '215 Gateaux Base',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.61,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-215-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-215-EAC', '215 Gateaux Base', 0, 0, 1.61, 'RawMaterial', 1);
END

-- Update or Insert: PAC-225-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-225-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '225X270X30MIC Scone bag medium',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.27,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-225-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-225-EAC', '225X270X30MIC Scone bag medium', 0, 0, 0.27, 'RawMaterial', 1);
END

-- Update or Insert: PAC-260-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-260-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '260*450*25mic',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.22,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-260-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-260-EAC', '260*450*25mic', 0, 0, 0.22, 'RawMaterial', 1);
END

-- Update or Insert: PAC-300-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-300-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Foil Container 100 (3001P)',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.27,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-300-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-300-EAC', 'Foil Container 100 (3001P)', 0, 0, 1.27, 'RawMaterial', 1);
END

-- Update or Insert: PAC-310-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-310-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '310*450*30mic',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.53,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-310-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-310-EAC', '310*450*30mic', 0, 0, 0.53, 'RawMaterial', 1);
END

-- Update or Insert: PAC-315-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-315-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '315 bar one dome',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 3.30,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-315-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-315-EAC', '315 bar one dome', 0, 0, 3.30, 'RawMaterial', 1);
END

-- Update or Insert: PAC-317-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-317-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '317 bar one base',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-317-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-317-EAC', '317 bar one base', 0, 0, 2.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-400-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-400-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '250*400*40mic Rolls large',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.48,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-400-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-400-EAC', '250*400*40mic Rolls large', 0, 0, 0.48, 'RawMaterial', 1);
END

-- Update or Insert: PAC-405-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-405-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '4051 foil container',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.12,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-405-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-405-EAC', '4051 foil container', 0, 0, 1.12, 'RawMaterial', 1);
END

-- Update or Insert: PAC-419-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-419-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '4191 Foil Container',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-419-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-419-EAC', '4191 Foil Container', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-450-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-450-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '250*450*30mic Naan exlarge',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-450-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-450-EAC', '250*450*30mic Naan exlarge', 0, 0, 0.40, 'RawMaterial', 1);
END

-- Update or Insert: PAC-552-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-552-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '5*5*2.5',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.34,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-552-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-552-EAC', '5*5*2.5', 0, 0, 1.34, 'RawMaterial', 1);
END

-- Update or Insert: PAC-572-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-572-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '5*5*2.5',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.52,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-572-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-572-EAC', '5*5*2.5', 0, 0, 1.52, 'RawMaterial', 1);
END

-- Update or Insert: PAC-573-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-573-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '5*7*3',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.67,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-573-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-573-EAC', '5*7*3', 0, 0, 1.67, 'RawMaterial', 1);
END

-- Update or Insert: PAC-73D-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-73D-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'No 73D Foam Tray',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.35,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-73D-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-73D-EAC', 'No 73D Foam Tray', 0, 0, 0.35, 'RawMaterial', 1);
END

-- Update or Insert: PAC-773-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-773-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '7*7*3 Diwali Boxes',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.63,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-773-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-773-EAC', '7*7*3 Diwali Boxes', 0, 0, 2.63, 'RawMaterial', 1);
END

-- Update or Insert: PAC-835-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-835-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bag 1000 83*54*300mm',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-835-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-835-EAC', 'Bag 1000 83*54*300mm', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-882-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-882-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '8X8X2',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.15,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-882-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-882-EAC', '8X8X2', 0, 0, 2.15, 'RawMaterial', 1);
END

-- Update or Insert: PAC-884-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-884-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '8X8X4',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 3.60,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-884-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-884-EAC', '8X8X4', 0, 0, 3.60, 'RawMaterial', 1);
END

-- Update or Insert: PAC-A34-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-A34-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'A34 Round Cake Dome',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.80,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-A34-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-A34-EAC', 'A34 Round Cake Dome', 0, 0, 1.80, 'RawMaterial', 1);
END

-- Update or Insert: PAC-A35-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-A35-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'A35 Round Cake Base',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.05,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-A35-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-A35-EAC', 'A35 Round Cake Base', 0, 0, 1.05, 'RawMaterial', 1);
END

-- Update or Insert: PAC-B75-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-B75-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'K75 Base',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.02,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-B75-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-B75-EAC', 'K75 Base', 0, 0, 2.02, 'RawMaterial', 1);
END

-- Update or Insert: PAC-BAG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-BAG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bags 1000 White Midi',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.74,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-BAG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-BAG-EAC', 'Bags 1000 White Midi', 0, 0, 0.74, 'RawMaterial', 1);
END

-- Update or Insert: PAC-BAG-JUM
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-BAG-JUM')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bags 1000 White Jumbo',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.86,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-BAG-JUM';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-BAG-JUM', 'Bags 1000 White Jumbo', 0, 0, 0.86, 'RawMaterial', 1);
END

-- Update or Insert: PAC-BBC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-BBC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bon Bon Biscuit Container',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.94,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-BBC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-BBC-EAC', 'Bon Bon Biscuit Container', 0, 0, 1.94, 'RawMaterial', 1);
END

-- Update or Insert: PAC-BBL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-BBL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bon Bon Biscuit Lid',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.94,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-BBL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-BBL-EAC', 'Bon Bon Biscuit Lid', 0, 0, 1.94, 'RawMaterial', 1);
END

-- Update or Insert: PAC-BEB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-BEB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Empty Bandini Box',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 8.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-BEB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-BEB-EAC', 'Empty Bandini Box', 0, 0, 8.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-BOR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-BOR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bag on Roll (30x45)',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.08,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-BOR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-BOR-EAC', 'Bag on Roll (30x45)', 0, 0, 0.08, 'RawMaterial', 1);
END

-- Update or Insert: PAC-BPB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-BPB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bag Brown Thrifty Paper Bag meduim',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.42,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-BPB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-BPB-EAC', 'Bag Brown Thrifty Paper Bag meduim', 0, 0, 2.42, 'RawMaterial', 1);
END

-- Update or Insert: PAC-BRE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-BRE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Packaging New 76x91 Black Refuse',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-BRE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-BRE-EAC', 'Packaging New 76x91 Black Refuse', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-BUB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-BUB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'bubble wrap',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-BUB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-BUB-EAC', 'bubble wrap', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-CHO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-CHO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Oven Delight Cake Box Choc',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 3.32,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-CHO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-CHO-EAC', 'Oven Delight Cake Box Choc', 0, 0, 3.32, 'RawMaterial', 1);
END

-- Update or Insert: PAC-CLE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-CLE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'CLEAR BIN BAGS',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-CLE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-CLE-EAC', 'CLEAR BIN BAGS', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-CON-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-CON-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '7119P Foil container',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 3.24,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-CON-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-CON-EAC', '7119P Foil container', 0, 0, 3.24, 'RawMaterial', 1);
END

-- Update or Insert: PAC-CUC-500ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-CUC-500ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cup Clear 500ML',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-CUC-500ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-CUC-500ML', 'Cup Clear 500ML', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-D75-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-D75-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'K75 Dome',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.45,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-D75-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-D75-EAC', 'K75 Dome', 0, 0, 1.45, 'RawMaterial', 1);
END

-- Update or Insert: PAC-DCW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-DCW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'High Window Box For Drip cake',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 50.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-DCW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-DCW-EAC', 'High Window Box For Drip cake', 0, 0, 50.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-EPI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-EPI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Faze 3 Boxes Empty for Pies',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 20.90,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-EPI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-EPI-EAC', 'Faze 3 Boxes Empty for Pies', 0, 0, 20.90, 'RawMaterial', 1);
END

-- Update or Insert: PAC-F5B-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-F5B-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'F50 High Cake Base',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.83,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-F5B-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-F5B-EAC', 'F50 High Cake Base', 0, 0, 1.83, 'RawMaterial', 1);
END

-- Update or Insert: PAC-F5D-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-F5D-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'F50 High Cake Dome',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.71,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-F5D-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-F5D-EAC', 'F50 High Cake Dome', 0, 0, 2.71, 'RawMaterial', 1);
END

-- Update or Insert: PAC-FLP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-FLP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Foil - Loaf Pan 4161P',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.25,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-FLP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-FLP-EAC', 'Foil - Loaf Pan 4161P', 0, 0, 2.25, 'RawMaterial', 1);
END

-- Update or Insert: PAC-FOI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-FOI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Foil Buns 4051D',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-FOI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-FOI-EAC', 'Foil Buns 4051D', 0, 0, 1.40, 'RawMaterial', 1);
END

-- Update or Insert: PAC-GP2-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-GP2-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bag GP 2',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.11,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-GP2-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-GP2-EAC', 'Bag GP 2', 0, 0, 0.11, 'RawMaterial', 1);
END

-- Update or Insert: PAC-HAM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-HAM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hamburger Dome F60',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.10,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-HAM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-HAM-EAC', 'Hamburger Dome F60', 0, 0, 1.10, 'RawMaterial', 1);
END

-- Update or Insert: PAC-JBU-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-JBU-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jumbo bag unprinted',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-JBU-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-JBU-EAC', 'Jumbo bag unprinted', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-JUM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-JUM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jumbo Econo White',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-JUM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-JUM-EAC', 'Jumbo Econo White', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-K96-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-K96-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'K 96 milk tart domes',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.18,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-K96-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-K96-EAC', 'K 96 milk tart domes', 0, 0, 2.18, 'RawMaterial', 1);
END

-- Update or Insert: PAC-LCB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-LCB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Laser Cut Box Only',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-LCB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-LCB-EAC', 'Laser Cut Box Only', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-LEV-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-LEV-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'EPR LEVY',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-LEV-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-LEV-EACH', 'EPR LEVY', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-LIC-500ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-LIC-500ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Lid Clear 500ML',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-LIC-500ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-LIC-500ML', 'Lid Clear 500ML', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-LID-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-LID-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '7119P Clear lids',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.07,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-LID-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-LID-EAC', '7119P Clear lids', 0, 0, 2.07, 'RawMaterial', 1);
END

-- Update or Insert: PAC-LLB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-LLB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Large Log Base',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.59,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-LLB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-LLB-EAC', 'Large Log Base', 0, 0, 1.59, 'RawMaterial', 1);
END

-- Update or Insert: PAC-LLD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-LLD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Large Log Dome',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-LLD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-LLD-EAC', 'Large Log Dome', 0, 0, 2.40, 'RawMaterial', 1);
END

-- Update or Insert: PAC-MAD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-MAD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Madeira Packaging Small B',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-MAD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-MAD-EAC', 'Madeira Packaging Small B', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-MCC-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-MCC-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milkshake Cup 350ml',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1280.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-MCC-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-MCC-350ML', 'Milkshake Cup 350ml', 0, 0, 1280.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-MCL-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-MCL-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milkshake Cup Lids 350ml',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 460.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-MCL-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-MCL-350ML', 'Milkshake Cup Lids 350ml', 0, 0, 460.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-MFO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-MFO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mince pie foil',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.26,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-MFO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-MFO-EAC', 'Mince pie foil', 0, 0, 0.26, 'RawMaterial', 1);
END

-- Update or Insert: PAC-MIN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-MIN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Foil Container Mince Pie Tray',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.19,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-MIN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-MIN-EAC', 'Foil Container Mince Pie Tray', 0, 0, 0.19, 'RawMaterial', 1);
END

-- Update or Insert: PAC-MLA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-MLA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Lamington trays',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-MLA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-MLA-EAC', 'Mini Lamington trays', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-NDI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-NDI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'New Diwali Cake Boxes',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-NDI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-NDI-EAC', 'New Diwali Cake Boxes', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-P45-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-P45-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'P45 Round platter',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 10.33,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-P45-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-P45-EAC', 'P45 Round platter', 0, 0, 10.33, 'RawMaterial', 1);
END

-- Update or Insert: PAC-PBH-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-PBH-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter base - half',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 3.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-PBH-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-PBH-EAC', 'Platter base - half', 0, 0, 3.50, 'RawMaterial', 1);
END

-- Update or Insert: PAC-PFB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-PFB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter foil base',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 11.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-PFB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-PFB-EAC', 'Platter foil base', 0, 0, 11.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-PLD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-PLD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Dome',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 8.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-PLD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-PLD-EAC', 'Platter Dome', 30.00, 30.00, 8.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-PLH-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-PLH-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Lid -Half',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 3.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-PLH-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-PLH-EAC', 'Platter Lid -Half', 0, 0, 3.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-PRD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-PRD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'P45 platter dome',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 8.48,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-PRD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-PRD-EAC', 'P45 platter dome', 0, 0, 8.48, 'RawMaterial', 1);
END

-- Update or Insert: PAC-PTC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-PTC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Paper Tulip Cups giant cup cakes',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.81,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-PTC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-PTC-EAC', 'Paper Tulip Cups giant cup cakes', 0, 0, 0.81, 'RawMaterial', 1);
END

-- Update or Insert: PAC-REC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-REC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rectangle Pie Foil',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.55,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-REC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-REC-EAC', 'Rectangle Pie Foil', 0, 0, 0.55, 'RawMaterial', 1);
END

-- Update or Insert: PAC-REF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-REF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Packaging Black Refuse',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-REF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-REF-EAC', 'Packaging Black Refuse', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-SDT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-SDT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Square Desert Tub',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.25,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-SDT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-SDT-EAC', 'Square Desert Tub', 0, 0, 1.25, 'RawMaterial', 1);
END

-- Update or Insert: PAC-SLI-70ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-SLI-70ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sauce Lids 70ml',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.22,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-SLI-70ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-SLI-70ML', 'Sauce Lids 70ml', 0, 0, 0.22, 'RawMaterial', 1);
END

-- Update or Insert: PAC-SO6-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-SO6-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bag Brown BB3',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.37,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-SO6-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-SO6-EAC', 'Bag Brown BB3', 0, 0, 0.37, 'RawMaterial', 1);
END

-- Update or Insert: PAC-STL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-STL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'GLUTEN FREE COFFEE CAKE TUB',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PAC-STL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-STL-EAC', 'GLUTEN FREE COFFEE CAKE TUB', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: PAC-STR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-STR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Oven Delight Cake Box Strbery',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.87,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-STR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-STR-EAC', 'Oven Delight Cake Box Strbery', 0, 0, 2.87, 'RawMaterial', 1);
END

-- Update or Insert: PAC-STU-70ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-STU-70ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sauce Tub 70ml',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.35,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-STU-70ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-STU-70ML', 'Sauce Tub 70ml', 0, 0, 0.35, 'RawMaterial', 1);
END

-- Update or Insert: PAC-SWI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-SWI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Swissroll Box',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 5.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-SWI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-SWI-EAC', 'Swissroll Box', 0, 0, 5.50, 'RawMaterial', 1);
END

-- Update or Insert: PAC-TAL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-TAL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'GLUTEN FREE CHOC MOUSSE CAKE TUB',
        RecommendedSellingPrice = 45,
        LastPaidPrice = 45,
        AverageCost = 25.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PAC-TAL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-TAL-EAC', 'GLUTEN FREE CHOC MOUSSE CAKE TUB', 45, 45, 25.00, 'internal', 1);
END

-- Update or Insert: PAC-VPC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-VPC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Vinyl Print Coffee Boards',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'PAC-VPC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-VPC-EAC', 'Vinyl Print Coffee Boards', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: PAC-VUT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-VUT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bread Bags (Vutu) PPG',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-VUT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-VUT-EAC', 'Bread Bags (Vutu) PPG', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-WIN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-WIN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Windsor X-Small B',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-WIN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-WIN-EAC', 'Windsor X-Small B', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PAC-WRG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-WRG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Wrist Guard',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.74,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'PAC-WRG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-WRG-EAC', 'Wrist Guard', 0, 0, 0.74, 'external', 1);
END

-- Update or Insert: PAC-ZIP-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PAC-ZIP-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ziplock Bags',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PAC-ZIP-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PAC-ZIP-EACH', 'Ziplock Bags', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE -CSR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE -CSR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Premium Chicken Tikka Sausage Roll',
        RecommendedSellingPrice = 28.00,
        LastPaidPrice = 28.00,
        AverageCost = 12.77,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE -CSR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE -CSR-EAC', 'OD Premium Chicken Tikka Sausage Roll', 28.00, 28.00, 12.77, 'RawMaterial', 1);
END

-- Update or Insert: PIE- FSK-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE- FSK-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Steak & Kidney Foil',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE- FSK-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE- FSK-EAC', 'Pie Steak & Kidney Foil', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE-APP-KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-APP-KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Apple',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 74.90,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-APP-KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-APP-KG', 'Pie Apple', 0, 0, 74.90, 'RawMaterial', 1);
END

-- Update or Insert: PIE-BBP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-BBP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie - Burger Beef',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-BBP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-BBP-EAC', 'Pie - Burger Beef', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE-BRC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-BRC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie - Burger Chicken Cheese / Sweet Chilli',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-BRC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-BRC-EAC', 'Pie - Burger Chicken Cheese / Sweet Chilli', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE-CCG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-CCG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Chicken Cheese Griller',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-CCG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-CCG-EAC', 'Pie Chicken Cheese Griller', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE-CMS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-CMS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Chicken and Mayo Slice',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-CMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-CMS-EAC', 'Pie Chicken and Mayo Slice', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE-COD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-COD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie OD Chicken & Mushroom',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 13.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-COD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-COD-EAC', 'Pie OD Chicken & Mushroom', 30.00, 30.00, 13.50, 'RawMaterial', 1);
END

-- Update or Insert: PIE-CPP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-CPP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Chicken Peri Peri',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 16.85,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-CPP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-CPP-EAC', 'Pie Chicken Peri Peri', 30.00, 30.00, 16.85, 'RawMaterial', 1);
END

-- Update or Insert: PIE-CRP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-CRP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie - Cornish Pastry',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-CRP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-CRP-EAC', 'Pie - Cornish Pastry', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE-FCP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-FCP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Chicken Peri Peri Foil',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-FCP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-FCP-EAC', 'Pie Chicken Peri Peri Foil', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE-FVE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-FVE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Vegetable Curry Foil',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-FVE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-FVE-EAC', 'Pie Vegetable Curry Foil', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE-MCB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-MCB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Mutton Curry Burger',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-MCB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-MCB-EAC', 'Pie Mutton Curry Burger', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE-MSR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-MSR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'OD Premium Mutton Oriental Sausage Roll',
        RecommendedSellingPrice = 28.00,
        LastPaidPrice = 28.00,
        AverageCost = 7.80,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-MSR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-MSR-EAC', 'OD Premium Mutton Oriental Sausage Roll', 28.00, 28.00, 7.80, 'RawMaterial', 1);
END

-- Update or Insert: PIE-ODM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-ODM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie OD Mutton Curry',
        RecommendedSellingPrice = 35.00,
        LastPaidPrice = 35.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-ODM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-ODM-EAC', 'Pie OD Mutton Curry', 35.00, 35.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE-PPS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-PPS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Pepper Steak',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 16.85,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-PPS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-PPS-EAC', 'Pie Pepper Steak', 30.00, 30.00, 16.85, 'RawMaterial', 1);
END

-- Update or Insert: PIE-PRS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-PRS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Prime Steak',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-PRS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-PRS-EAC', 'Pie Prime Steak', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: PIE-SAF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-SAF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Spinach & Feta',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 14.95,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-SAF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-SAF-EAC', 'Pie Spinach & Feta', 30.00, 30.00, 14.95, 'RawMaterial', 1);
END

-- Update or Insert: PIE-SAK-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-SAK-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Steak & Kidney',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 16.85,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-SAK-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-SAK-EAC', 'Pie Steak & Kidney', 30.00, 30.00, 16.85, 'RawMaterial', 1);
END

-- Update or Insert: PIE-SRB-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-SRB-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Sausage Roll( Beef)',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 16.85,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-SRB-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-SRB-EACH', 'Pie Sausage Roll( Beef)', 30.00, 30.00, 16.85, 'RawMaterial', 1);
END

-- Update or Insert: PIE-VEG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PIE-VEG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie OD Vegetable',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 13.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'PIE-VEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PIE-VEG-EAC', 'Pie OD Vegetable', 30.00, 30.00, 13.50, 'RawMaterial', 1);
END

-- Update or Insert: PLA- MIX-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA- MIX-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mixy Delight',
        RecommendedSellingPrice = 650.00,
        LastPaidPrice = 650.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA- MIX-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA- MIX-EAC', 'Platter Mixy Delight', 650.00, 650.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA- PEM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA- PEM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mini Pecan Nut Tarts 24s',
        RecommendedSellingPrice = 620.00,
        LastPaidPrice = 620.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA- PEM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA- PEM-EAC', 'Platter Mini Pecan Nut Tarts 24s', 620.00, 620.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA -SCO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA -SCO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Scone Delight 18s',
        RecommendedSellingPrice = 400.00,
        LastPaidPrice = 400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA -SCO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA -SCO-EAC', 'Platter Scone Delight 18s', 400.00, 400.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-CHE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-CHE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Cheeky Delight',
        RecommendedSellingPrice = 650.00,
        LastPaidPrice = 650.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-CHE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-CHE-EAC', 'Platter Cheeky Delight', 650.00, 650.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-CRM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-CRM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mini Cream Puffs 24s',
        RecommendedSellingPrice = 350.00,
        LastPaidPrice = 350.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-CRM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-CRM-EAC', 'Platter Mini Cream Puffs 24s', 350.00, 350.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-CRO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-CRO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Croissant Delight 20s',
        RecommendedSellingPrice = 400.00,
        LastPaidPrice = 400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-CRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-CRO-EAC', 'Platter Croissant Delight 20s', 400.00, 400.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-ECM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-ECM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mini Freshcream Eclairs',
        RecommendedSellingPrice = 380.00,
        LastPaidPrice = 380.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-ECM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-ECM-EAC', 'Platter Mini Freshcream Eclairs', 380.00, 380.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-FLM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-FLM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mini Flakey Bits 24s',
        RecommendedSellingPrice = 350.00,
        LastPaidPrice = 350.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-FLM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-FLM-EAC', 'Platter Mini Flakey Bits 24s', 350.00, 350.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-FRM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-FRM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mini Freshcream Donuts',
        RecommendedSellingPrice = 380.00,
        LastPaidPrice = 380.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-FRM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-FRM-EAC', 'Platter Mini Freshcream Donuts', 380.00, 380.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-JAM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-JAM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mini Jam Turnovers 24s',
        RecommendedSellingPrice = 350.00,
        LastPaidPrice = 350.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-JAM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-JAM-EAC', 'Platter Mini Jam Turnovers 24s', 350.00, 350.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-MBD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-MBD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mini Buttercream Donuts 24s',
        RecommendedSellingPrice = 320.00,
        LastPaidPrice = 320.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-MBD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-MBD-EAC', 'Platter Mini Buttercream Donuts 24s', 320.00, 320.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-MCD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-MCD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mini Chocolate Donut 24s',
        RecommendedSellingPrice = 350.00,
        LastPaidPrice = 350.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-MCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-MCD-EAC', 'Platter Mini Chocolate Donut 24s', 350.00, 350.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-MEA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-MEA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Meaty Delight',
        RecommendedSellingPrice = 650.00,
        LastPaidPrice = 650.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-MEA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-MEA-EAC', 'Platter Meaty Delight', 650.00, 650.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-MIM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-MIM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mini Milk Tarts 24S',
        RecommendedSellingPrice = 400.00,
        LastPaidPrice = 400.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-MIM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-MIM-EAC', 'Platter Mini Milk Tarts 24S', 400.00, 400.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-MLP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-MLP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mini Lamingtons 24s',
        RecommendedSellingPrice = 350.00,
        LastPaidPrice = 350.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-MLP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-MLP-EAC', 'Platter Mini Lamingtons 24s', 350.00, 350.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-MUFF- EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-MUFF- EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Muffin Delight 30s',
        RecommendedSellingPrice = 380.00,
        LastPaidPrice = 380.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-MUFF- EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-MUFF- EAC', 'Platter Muffin Delight 30s', 380.00, 380.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-SMA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-SMA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Snacky Delight',
        RecommendedSellingPrice = 650.00,
        LastPaidPrice = 650.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-SMA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-SMA-EAC', 'Platter Snacky Delight', 650.00, 650.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-SNM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-SNM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Mini Snowballs 24s',
        RecommendedSellingPrice = 350.00,
        LastPaidPrice = 350.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-SNM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-SNM-EAC', 'Platter Mini Snowballs 24s', 350.00, 350.00, 0.00, 'internal', 1);
END

-- Update or Insert: PLA-VEG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'PLA-VEG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Platter Veggy Delights',
        RecommendedSellingPrice = 600.00,
        LastPaidPrice = 600.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'PLA-VEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('PLA-VEG-EAC', 'Platter Veggy Delights', 600.00, 600.00, 0.00, 'internal', 1);
END

-- Update or Insert: REP-BRE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'REP-BRE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bread Slicer Blades',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'REP-BRE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('REP-BRE-EAC', 'Bread Slicer Blades', 45.00, 45.00, 0.00, 'external', 1);
END

-- Update or Insert: SAV-CCS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-CCS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Crumbed Chicken Samoosa',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-CCS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-CCS-EAC', 'Crumbed Chicken Samoosa', 12.00, 12.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-CJF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-CJF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Frozen Cheese And Jalapeno',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-CJF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-CJF-EAC', 'Frozen Cheese And Jalapeno', 15.00, 15.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-CJR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-CJR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chicken & Jalapeno Rissoles',
        RecommendedSellingPrice = 8.00,
        LastPaidPrice = 8.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-CJR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-CJR-EAC', 'Chicken & Jalapeno Rissoles', 8.00, 8.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-CSA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-CSA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chicken Samoosa',
        RecommendedSellingPrice = 8.00,
        LastPaidPrice = 8.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-CSA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-CSA-EAC', 'Chicken Samoosa', 8.00, 8.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-FCM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-FCM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Frozen Chicken And Mushroom Pie',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SAV-FCM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-FCM-EAC', 'Frozen Chicken And Mushroom Pie', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SAV-FCR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-FCR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Frozen Chicken Sausage Rolls',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-FCR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-FCR-EAC', 'Frozen Chicken Sausage Rolls', 15.00, 15.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-FFI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-FFI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Frozen Fish Cake',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-FFI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-FFI-EAC', 'Frozen Fish Cake', 15.00, 15.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-FIS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-FIS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fish Cake',
        RecommendedSellingPrice = 8.00,
        LastPaidPrice = 8.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-FIS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-FIS-EAC', 'Fish Cake', 8.00, 8.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-FJC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-FJC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Frozen Chicken And Jalapeno',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-FJC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-FJC-EAC', 'Frozen Chicken And Jalapeno', 15.00, 15.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-FKE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-FKE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Frozen Kebabs',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-FKE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-FKE-EAC', 'Frozen Kebabs', 15.00, 15.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-FMV-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-FMV-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Frozen Mix Veg Pie',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-FMV-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-FMV-EAC', 'Frozen Mix Veg Pie', 15.00, 15.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-FPA-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-FPA-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Frozen Patha Wheel',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-FPA-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-FPA-EACH', 'Frozen Patha Wheel', 15.00, 15.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-LMS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-LMS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Lamb Mince Samoosa',
        RecommendedSellingPrice = 8.00,
        LastPaidPrice = 8.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-LMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-LMS-EAC', 'Lamb Mince Samoosa', 8.00, 8.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-PAP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-PAP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Puri & Patha (3s)',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-PAP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-PAP-EAC', 'Puri & Patha (3s)', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-PAS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-PAS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Patha Samoosa',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-PAS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-PAS-EAC', 'Patha Samoosa', 12.00, 12.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-PUP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-PUP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Puri Plain',
        RecommendedSellingPrice = 8.00,
        LastPaidPrice = 8.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-PUP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-PUP-EAC', 'Puri Plain', 8.00, 8.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-RCJ-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-RCJ-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cheese & Jalapeno Rissoles',
        RecommendedSellingPrice = 8.00,
        LastPaidPrice = 8.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-RCJ-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-RCJ-EAC', 'Cheese & Jalapeno Rissoles', 8.00, 8.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-RRC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-RRC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Roti Roll Chicken',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-RRC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-RRC-EAC', 'Roti Roll Chicken', 25.00, 25.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-RRP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-RRP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Roti Roll Potatoe',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-RRP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-RRP-EAC', 'Roti Roll Potatoe', 25.00, 25.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-SAM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-SAM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Samoosa 3s',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-SAM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-SAM-EAC', 'Samoosa 3s', 20.00, 20.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-SCC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-SCC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cheese And Corn Samoosa',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-SCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-SCC-EAC', 'Cheese And Corn Samoosa', 12.00, 12.00, 0.00, 'internal', 1);
END

-- Update or Insert: SAV-VED-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SAV-VED-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Veda',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SAV-VED-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SAV-VED-EAC', 'Veda', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP - JAL-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP - JAL-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jalebi 250g',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 70.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP - JAL-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP - JAL-EACH', 'Jalebi 250g', 100.00, 100.00, 70.00, 'external', 1);
END

-- Update or Insert: SHP- BAN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP- BAN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Banana Loaf',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 199.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP- BAN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP- BAN-EAC', 'Banana Loaf', 50.00, 50.00, 199.00, 'internal', 1);
END

-- Update or Insert: SHP- CRW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP- CRW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Roti Chicken Wrap',
        RecommendedSellingPrice = 20,
        LastPaidPrice = 20,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP- CRW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP- CRW-EAC', 'Roti Chicken Wrap', 20, 20, 0.00, 'internal', 1);
END

-- Update or Insert: SHP- GUL-1KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP- GUL-1KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gulab Jamun 1kg',
        RecommendedSellingPrice = 280.00,
        LastPaidPrice = 280.00,
        AverageCost = 190.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP- GUL-1KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP- GUL-1KG', 'Gulab Jamun 1kg', 280.00, 280.00, 190.00, 'external', 1);
END

-- Update or Insert: SHP- GUL-4S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP- GUL-4S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gulab Jamun 4s Pure Butter',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP- GUL-4S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP- GUL-4S', 'Gulab Jamun 4s Pure Butter', 60.00, 60.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP- IDH-32S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP- IDH-32S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Idhli Platter 32s',
        RecommendedSellingPrice = 350.00,
        LastPaidPrice = 350.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP- IDH-32S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP- IDH-32S', 'Idhli Platter 32s', 350.00, 350.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP- MOL-6S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP- MOL-6S')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Sweetmeats Mini Oval Laser Cut Wooden (6s)',
        RecommendedSellingPrice = 170.00,
        LastPaidPrice = 170.00,
        AverageCost = 65.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP- MOL-6S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP- MOL-6S', 'DC Sweetmeats Mini Oval Laser Cut Wooden (6s)', 170.00, 170.00, 65.00, 'external', 1);
END

-- Update or Insert: SHP- PRW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP- PRW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Roti Potatoe Wrap',
        RecommendedSellingPrice = 15,
        LastPaidPrice = 15,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP- PRW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP- PRW-EAC', 'Roti Potatoe Wrap', 15, 15, 0.00, 'internal', 1);
END

-- Update or Insert: SHP- RAE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP- RAE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Eggless Rainbow Sponge Log',
        RecommendedSellingPrice = 85.00,
        LastPaidPrice = 85.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP- RAE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP- RAE-EAC', 'Eggless Rainbow Sponge Log', 85.00, 85.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP- SWEE-250G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP- SWEE-250G')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Sweet Meats Assorted 250g',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 62.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP- SWEE-250G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP- SWEE-250G', 'DC Sweet Meats Assorted 250g', 80.00, 80.00, 62.00, 'external', 1);
END

-- Update or Insert: SHP-AUA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-AUA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Authentic Assorted Sweetmeats 11 pieces',
        RecommendedSellingPrice = 200.00,
        LastPaidPrice = 200.00,
        AverageCost = 110.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-AUA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-AUA-EAC', 'DC Authentic Assorted Sweetmeats 11 pieces', 200.00, 200.00, 110.00, 'external', 1);
END

-- Update or Insert: SHP-AUT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-AUT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Authentic Ladoo',
        RecommendedSellingPrice = 160.00,
        LastPaidPrice = 160.00,
        AverageCost = 190.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-AUT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-AUT-EAC', 'Authentic Ladoo', 160.00, 160.00, 190.00, 'external', 1);
END

-- Update or Insert: SHP-BAN-6S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BAN-6S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Banana Puri (6s)',
        RecommendedSellingPrice = 70.00,
        LastPaidPrice = 70.00,
        AverageCost = 40.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-BAN-6S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BAN-6S', 'Banana Puri (6s)', 70.00, 70.00, 40.00, 'external', 1);
END

-- Update or Insert: SHP-BBS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BBS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sweetmeats Boujee Singles',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-BBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BBS-EAC', 'Sweetmeats Boujee Singles', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-BCC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BCC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Buttercream Christmas cakes',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BCC-EAC', 'Buttercream Christmas cakes', 50.00, 50.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BCG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BCG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'ButterCream Christmas Gateaux',
        RecommendedSellingPrice = 150.00,
        LastPaidPrice = 150.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BCG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BCG-EAC', 'ButterCream Christmas Gateaux', 150.00, 150.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BRB-400
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BRB-400')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bread Brown 400g',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BRB-400';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BRB-400', 'Bread Brown 400g', 10.00, 10.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BRB-400G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BRB-400G')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bread Bunny Loaf 400g',
        RecommendedSellingPrice = 12.00,
        LastPaidPrice = 12.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BRB-400G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BRB-400G', 'Bread Bunny Loaf 400g', 12.00, 12.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BRB-800
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BRB-800')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sun Bread Brown 800g',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BRB-800';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BRB-800', 'Sun Bread Brown 800g', 15.00, 15.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BRG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BRG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bread Garlic 300g',
        RecommendedSellingPrice = 29.00,
        LastPaidPrice = 29.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BRG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BRG-EAC', 'Bread Garlic 300g', 29.00, 29.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BRO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BRO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Butter Roti (6s)',
        RecommendedSellingPrice = 45,
        LastPaidPrice = 45,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BRO-EAC', 'Butter Roti (6s)', 45, 45, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BRR-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BRR-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bread Tea Ring',
        RecommendedSellingPrice = 36.00,
        LastPaidPrice = 36.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BRR-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BRR-500', 'Bread Tea Ring', 36.00, 36.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BRT-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BRT-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bread Tea Loaf 500g',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BRT-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BRT-500', 'Bread Tea Loaf 500g', 40.00, 40.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BRW-400
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BRW-400')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bread White 400g',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BRW-400';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BRW-400', 'Bread White 400g', 10.00, 10.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BRW-800
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BRW-800')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sun Bread White 800',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BRW-800';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BRW-800', 'Sun Bread White 800', 15.00, 15.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BSC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BSC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Butter Scones (4s)',
        RecommendedSellingPrice = 42.00,
        LastPaidPrice = 42.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BSC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BSC-EAC', 'Butter Scones (4s)', 42.00, 42.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BSP-24S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BSP-24S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Butter Scone Platter 24s',
        RecommendedSellingPrice = 500.00,
        LastPaidPrice = 500.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BSP-24S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BSP-24S', 'Butter Scone Platter 24s', 500.00, 500.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BTW-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BTW-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bread 500g Twist',
        RecommendedSellingPrice = 19.00,
        LastPaidPrice = 19.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BTW-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BTW-500', 'Bread 500g Twist', 19.00, 19.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BUN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BUN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Buns 100g Soft 6s',
        RecommendedSellingPrice = 27.00,
        LastPaidPrice = 27.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BUN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BUN-EAC', 'Buns 100g Soft 6s', 27.00, 27.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-BUR-1KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BUR-1KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Burfee 1kg',
        RecommendedSellingPrice = 300.00,
        LastPaidPrice = 300.00,
        AverageCost = 220.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BUR-1KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BUR-1KG', 'Burfee 1kg', 300.00, 300.00, 220.00, 'internal', 1);
END

-- Update or Insert: SHP-BUR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BUR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Burfee 9pc',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 72.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-BUR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BUR-KGR', 'Burfee 9pc', 100.00, 100.00, 72.00, 'internal', 1);
END

-- Update or Insert: SHP-BVS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-BVS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC Vanilla Swiss Roll',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SHP-BVS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-BVS-EAC', 'BC Vanilla Swiss Roll', 50.00, 50.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SHP-CFI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CFI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas fruit Cake Round Iced',
        RecommendedSellingPrice = 140.00,
        LastPaidPrice = 140.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CFI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CFI-EAC', 'Christmas fruit Cake Round Iced', 140.00, 140.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-CFP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CFP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Fruit Cake Round Plain',
        RecommendedSellingPrice = 120.00,
        LastPaidPrice = 120.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CFP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CFP-EAC', 'Christmas Fruit Cake Round Plain', 120.00, 120.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-CHA-1KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CHA-1KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chana Magaj 1kg',
        RecommendedSellingPrice = 300.00,
        LastPaidPrice = 300.00,
        AverageCost = 220.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CHA-1KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CHA-1KG', 'Chana Magaj 1kg', 300.00, 300.00, 220.00, 'internal', 1);
END

-- Update or Insert: SHP-CHB-04S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CHB-04S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chelsea Buns (6s)',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CHB-04S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CHB-04S', 'Chelsea Buns (6s)', 45.00, 45.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-CHO-PLN
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CHO-PLN')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Gateaux Plain',
        RecommendedSellingPrice = 28.00,
        LastPaidPrice = 28.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CHO-PLN';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CHO-PLN', 'Chocolate Gateaux Plain', 28.00, 28.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-COC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-COC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coconut Ice',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SHP-COC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-COC-KGR', 'Coconut Ice', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SHP-CPN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CPN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Carrot and Pecan Nut Slab',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CPN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CPN-EAC', 'Carrot and Pecan Nut Slab', 50.00, 50.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-CRB-06S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CRB-06S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream Buns 6s',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CRB-06S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CRB-06S', 'Cream Buns 6s', 45.00, 45.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-CRM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CRM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Round Mini Cake',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CRM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CRM-EAC', 'Christmas Round Mini Cake', 60.00, 60.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-CRO-06S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CRO-06S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rolls 70g Soft Hotdog Cheese 6',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CRO-06S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CRO-06S', 'Rolls 70g Soft Hotdog Cheese 6', 40.00, 40.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-CSC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CSC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Sponge Cake',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CSC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CSC-EAC', 'Chocolate Sponge Cake', 50.00, 50.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-CTP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CTP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Steamed Pudding',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CTP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CTP-EAC', 'Christmas Steamed Pudding', 180.00, 180.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-CTR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CTR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cocktail Rolls',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CTR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CTR-EAC', 'Cocktail Rolls', 30.00, 30.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-CWP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CWP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Windsor Plain',
        RecommendedSellingPrice = 140.00,
        LastPaidPrice = 140.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CWP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CWP-EAC', 'Christmas Windsor Plain', 140.00, 140.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-CWS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-CWS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Windsor Slice',
        RecommendedSellingPrice = 110,
        LastPaidPrice = 110,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-CWS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-CWS-EAC', 'Christmas Windsor Slice', 110, 110, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-DBB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DBB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Bandhani Box',
        RecommendedSellingPrice = 95.00,
        LastPaidPrice = 95.00,
        AverageCost = 62.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DBB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DBB-EAC', 'DC Diwali Bandhani Box', 95.00, 95.00, 62.00, 'external', 1);
END

-- Update or Insert: SHP-DDB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DDB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Designer Biscuit',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DDB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DDB-EAC', 'DC Diwali Designer Biscuit', 100.00, 100.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-DDD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DDD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Designer Burfee',
        RecommendedSellingPrice = 160.00,
        LastPaidPrice = 160.00,
        AverageCost = 220.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DDD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DDD-EAC', 'DC Diwali Designer Burfee', 160.00, 160.00, 220.00, 'external', 1);
END

-- Update or Insert: SHP-DEG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DEG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Eggless Cake',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-DEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DEG-EAC', 'DC Diwali Eggless Cake', 60.00, 60.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-DIB-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DIB-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Authentic Diya Boxes',
        RecommendedSellingPrice = 200.00,
        LastPaidPrice = 200.00,
        AverageCost = 145.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DIB-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DIB-EACH', 'DC Authentic Diya Boxes', 200.00, 200.00, 145.00, 'external', 1);
END

-- Update or Insert: SHP-DJA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DJA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Jalebi',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 70.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DJA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DJA-EAC', 'DC Diwali Jalebi', 100.00, 100.00, 70.00, 'external', 1);
END

-- Update or Insert: SHP-DLB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DLB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Large Bag',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 77.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DLB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DLB-EAC', 'DC Diwali Large Bag', 40.00, 40.00, 77.00, 'external', 1);
END

-- Update or Insert: SHP-DLD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DLD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Large Designer Box',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 115.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DLD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DLD-EAC', 'DC Diwali Large Designer Box', 180.00, 180.00, 115.00, 'external', 1);
END

-- Update or Insert: SHP-DMA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DMA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Macaroons',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 65.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DMA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DMA-EAC', 'DC Diwali Macaroons', 100.00, 100.00, 65.00, 'external', 1);
END

-- Update or Insert: SHP-DOP-10S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DOP-10S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Doughnut Pops 10s',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DOP-10S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DOP-10S', 'Doughnut Pops 10s', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-DPB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DPB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Peacock Box',
        RecommendedSellingPrice = 80.00,
        LastPaidPrice = 80.00,
        AverageCost = 18.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DPB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DPB-EAC', 'DC Diwali Peacock Box', 80.00, 80.00, 18.00, 'external', 1);
END

-- Update or Insert: SHP-DRO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DRO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dhall Roti (6s)',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DRO-EAC', 'Dhall Roti (6s)', 40.00, 40.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-DSB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-DSB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Small Bag',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 50.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-DSB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-DSB-EAC', 'DC Diwali Small Bag', 30.00, 30.00, 50.00, 'external', 1);
END

-- Update or Insert: SHP-FCE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-FCE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Fruit Cake Eggless Round',
        RecommendedSellingPrice = 190.00,
        LastPaidPrice = 190.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-FCE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-FCE-EAC', 'Christmas Fruit Cake Eggless Round', 190.00, 190.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-FRT-LRG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-FRT-LRG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Five Roses Tea Tall',
        RecommendedSellingPrice = 28.00,
        LastPaidPrice = 28.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SHP-FRT-LRG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-FRT-LRG', 'Five Roses Tea Tall', 28.00, 28.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SHP-FRT-SML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-FRT-SML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Five Roses Tea Small',
        RecommendedSellingPrice = 23.00,
        LastPaidPrice = 23.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SHP-FRT-SML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-FRT-SML', 'Five Roses Tea Small', 23.00, 23.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SHP-GAT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-GAT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Gateaux',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-GAT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-GAT-EAC', 'DC Diwali Gateaux', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-GLC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-GLC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Gold Laser Cut',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-GLC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-GLC-EAC', 'DC Diwali Gold Laser Cut', 100.00, 100.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-HBU-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-HBU-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hot x Buns 6s',
        RecommendedSellingPrice = 32.00,
        LastPaidPrice = 32.00,
        AverageCost = 27.61,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-HBU-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-HBU-EAC', 'Hot x Buns 6s', 32.00, 32.00, 27.61, 'internal', 1);
END

-- Update or Insert: SHP-ICL-LRG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-ICL-LRG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Iced Coffee Large',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SHP-ICL-LRG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-ICL-LRG', 'Iced Coffee Large', 40.00, 40.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SHP-IDH-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-IDH-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Idhli Pure Butter (4s)',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-IDH-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-IDH-EACH', 'Idhli Pure Butter (4s)', 40.00, 40.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-JSW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-JSW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Vanilla Jam Swissroll',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-JSW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-JSW-EAC', 'Vanilla Jam Swissroll', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-LAC-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-LAC-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Lamington 5 pack',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-LAC-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-LAC-EACH', 'Chocolate Lamington 5 pack', 45.00, 45.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-LAD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-LAD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ladoo 9 piece',
        RecommendedSellingPrice = 95.00,
        LastPaidPrice = 95.00,
        AverageCost = 220.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-LAD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-LAD-EAC', 'Ladoo 9 piece', 95.00, 95.00, 220.00, 'internal', 1);
END

-- Update or Insert: SHP-LAR-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-LAR-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Raspberry Lamington 5 pack',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-LAR-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-LAR-EACH', 'Raspberry Lamington 5 pack', 45.00, 45.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-LEM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-LEM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Lemon Loaf',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-LEM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-LEM-EAC', 'Lemon Loaf', 60.00, 60.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-LHS-375
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-LHS-375')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Large Hexagonal Deluxe Sweetmeats 375g',
        RecommendedSellingPrice = 270.00,
        LastPaidPrice = 270.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-LHS-375';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-LHS-375', 'DC Large Hexagonal Deluxe Sweetmeats 375g', 270.00, 270.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-LJS-350
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-LJS-350')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Large Jewels Deluxe Sweetmeats 350g',
        RecommendedSellingPrice = 250.00,
        LastPaidPrice = 250.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-LJS-350';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-LJS-350', 'DC Large Jewels Deluxe Sweetmeats 350g', 250.00, 250.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-LWC-360G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-LWC-360G')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Sweetmeats Lamp Wooden Cut 360g',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-LWC-360G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-LWC-360G', 'DC Sweetmeats Lamp Wooden Cut 360g', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-MAD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-MAD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Madeira',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.46,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-MAD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-MAD-EAC', 'Madeira', 50.00, 50.00, 0.46, 'internal', 1);
END

-- Update or Insert: SHP-MHS-165
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-MHS-165')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Mini Hexagonal Deluxe Sweetmeats 165g',
        RecommendedSellingPrice = 140.00,
        LastPaidPrice = 140.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-MHS-165';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-MHS-165', 'DC Mini Hexagonal Deluxe Sweetmeats 165g', 140.00, 140.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-MIN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-MIN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mince Pies',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-MIN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-MIN-EAC', 'Mince Pies', 50.00, 50.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-MJS-250
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-MJS-250')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Mini Jewels Deluxe Sweetmeats 250g',
        RecommendedSellingPrice = 180.00,
        LastPaidPrice = 180.00,
        AverageCost = 130.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-MJS-250';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-MJS-250', 'DC Mini Jewels Deluxe Sweetmeats 250g', 180.00, 180.00, 130.00, 'external', 1);
END

-- Update or Insert: SHP-MRO-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-MRO-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Brown Roti (6s)',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-MRO-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-MRO-EACH', 'Brown Roti (6s)', 30.00, 30.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-NAA-02S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-NAA-02S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Naan 300g 2s',
        RecommendedSellingPrice = 34.00,
        LastPaidPrice = 34.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-NAA-02S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-NAA-02S', 'Naan 300g 2s', 34.00, 34.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-NAA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-NAA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Naan 300g',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-NAA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-NAA-EAC', 'Naan 300g', 20.00, 20.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-PFC-4S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-PFC-4S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Poli With Fresh Coconut 4s',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-PFC-4S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-PFC-4S', 'Poli With Fresh Coconut 4s', 60.00, 60.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-POL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-POL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Poli (4s)',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 7.05,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-POL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-POL-EAC', 'Poli (4s)', 50.00, 50.00, 7.05, 'external', 1);
END

-- Update or Insert: SHP-PPP-30S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-PPP-30S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Puri Patha Platter 30s',
        RecommendedSellingPrice = 480.00,
        LastPaidPrice = 480.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-PPP-30S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-PPP-30S', 'Puri Patha Platter 30s', 480.00, 480.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-RAI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-RAI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rainbow Sponge Log',
        RecommendedSellingPrice = 65.00,
        LastPaidPrice = 65.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-RAI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-RAI-EAC', 'Rainbow Sponge Log', 65.00, 65.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-RAL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-RAL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Raisin Loaf',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-RAL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-RAL-EAC', 'Raisin Loaf', 18.00, 18.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-RBS-SML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-RBS-SML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rooibos Tea Small',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SHP-RBS-SML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-RBS-SML', 'Rooibos Tea Small', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SHP-RBT-LRG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-RBT-LRG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rooibos Tea Tall',
        RecommendedSellingPrice = 28.00,
        LastPaidPrice = 28.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SHP-RBT-LRG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-RBT-LRG', 'Rooibos Tea Tall', 28.00, 28.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SHP-RJS-595
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-RJS-595')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Rajasthani Jewel Sweetmeats 595g',
        RecommendedSellingPrice = 360.00,
        LastPaidPrice = 360.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-RJS-595';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-RJS-595', 'DC Rajasthani Jewel Sweetmeats 595g', 360.00, 360.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-RLC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-RLC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Round Clear Assorted',
        RecommendedSellingPrice = 160.00,
        LastPaidPrice = 160.00,
        AverageCost = 120.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-RLC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-RLC-EAC', 'DC Diwali Round Clear Assorted', 160.00, 160.00, 120.00, 'external', 1);
END

-- Update or Insert: SHP-ROLL-06S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-ROLL-06S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rolls 60g Soft Hotdog 6s',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-ROLL-06S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-ROLL-06S', 'Rolls 60g Soft Hotdog 6s', 18.00, 18.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-ROLL-12S
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-ROLL-12S')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rolls 60g Soft Hotdog 12s',
        RecommendedSellingPrice = 36.00,
        LastPaidPrice = 36.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-ROLL-12S';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-ROLL-12S', 'Rolls 60g Soft Hotdog 12s', 36.00, 36.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-ROT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-ROT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rotis 12s',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SHP-ROT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-ROT-EAC', 'Rotis 12s', 45.00, 45.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SHP-RWC-265G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-RWC-265G')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Sweetmeats Round Wooden Cut 265G',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-RWC-265G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-RWC-265G', 'DC Sweetmeats Round Wooden Cut 265G', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-RWC-380G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-RWC-380G')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Sweetmeats Rectangle Wooden Cut 380g',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-RWC-380G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-RWC-380G', 'DC Sweetmeats Rectangle Wooden Cut 380g', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-SBB-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-SBB-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Sweetmeats Boujee Burfee',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 77.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-SBB-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-SBB-EACH', 'DC Sweetmeats Boujee Burfee', 100.00, 100.00, 77.00, 'external', 1);
END

-- Update or Insert: SHP-SBC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-SBC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Burfee Soji Cake',
        RecommendedSellingPrice = 130.00,
        LastPaidPrice = 130.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-SBC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-SBC-EAC', 'Burfee Soji Cake', 130.00, 130.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-SCF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-SCF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Scones Fruit 4s',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-SCF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-SCF-EAC', 'Scones Fruit 4s', 40.00, 40.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-SCG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-SCG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dome Buttercream Christmas Cake',
        RecommendedSellingPrice = 40.00,
        LastPaidPrice = 40.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-SCG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-SCG-EAC', 'Dome Buttercream Christmas Cake', 40.00, 40.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-SCO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-SCO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Scones 4s',
        RecommendedSellingPrice = 38.00,
        LastPaidPrice = 38.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-SCO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-SCO-EAC', 'Scones 4s', 38.00, 38.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-SDB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-SDB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Diwali Small Designer Box',
        RecommendedSellingPrice = 130.00,
        LastPaidPrice = 130.00,
        AverageCost = 75.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-SDB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-SDB-EAC', 'DC Diwali Small Designer Box', 130.00, 130.00, 75.00, 'external', 1);
END

-- Update or Insert: SHP-SGL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-SGL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sweet Meats Gold Foil Large',
        RecommendedSellingPrice = 140.00,
        LastPaidPrice = 140.00,
        AverageCost = 90.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-SGL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-SGL-EAC', 'Sweet Meats Gold Foil Large', 140.00, 140.00, 90.00, 'external', 1);
END

-- Update or Insert: SHP-SGS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-SGS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sweet Meats Gold Foil Small',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 65.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-SGS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-SGS-EAC', 'Sweet Meats Gold Foil Small', 100.00, 100.00, 65.00, 'external', 1);
END

-- Update or Insert: SHP-SPF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-SPF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sweet Meats Paisley Gold Foil',
        RecommendedSellingPrice = 150.00,
        LastPaidPrice = 150.00,
        AverageCost = 100.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-SPF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-SPF-EAC', 'Sweet Meats Paisley Gold Foil', 150.00, 150.00, 100.00, 'external', 1);
END

-- Update or Insert: SHP-SPO-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-SPO-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Soji Poli (5s)',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 7.05,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-SPO-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-SPO-EACH', 'Soji Poli (5s)', 60.00, 60.00, 7.05, 'external', 1);
END

-- Update or Insert: SHP-SSC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-SSC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Strawberry Sponge Cake',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-SSC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-SSC-EAC', 'Strawberry Sponge Cake', 50.00, 50.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-STE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-STE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Eggless Trifle Sponge',
        RecommendedSellingPrice = 90.00,
        LastPaidPrice = 90.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-STE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-STE-EAC', 'Eggless Trifle Sponge', 90.00, 90.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-TLB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-TLB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Traingle Lotus Box',
        RecommendedSellingPrice = 210.00,
        LastPaidPrice = 210.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-TLB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-TLB-EAC', 'DC Traingle Lotus Box', 210.00, 210.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-TRI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-TRI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Trifle Sponge',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-TRI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-TRI-EAC', 'Trifle Sponge', 30.00, 30.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-VSA-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-VSA-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'DC Vegan Sweetmeats Assorted Authentic',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'SHP-VSA-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-VSA-EACH', 'DC Vegan Sweetmeats Assorted Authentic', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: SHP-WIC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-WIC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Christmas Windsor iced',
        RecommendedSellingPrice = 70.00,
        LastPaidPrice = 70.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-WIC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-WIC-EAC', 'Christmas Windsor iced', 70.00, 70.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-WIS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-WIS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Windsor Slab',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-WIS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-WIS-EAC', 'Windsor Slab', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SHP-WMV-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SHP-WMV-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Windsor Slice',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SHP-WMV-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SHP-WMV-EAC', 'Windsor Slice', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SNA-CHE-340
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-CHE-340')
BEGIN
    UPDATE Products 
    SET ProductName = 'DIWALI CHEVDA 250G',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-CHE-340';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-CHE-340', 'DIWALI CHEVDA 250G', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-CHE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-CHE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Maya Spices Chevda 250g',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 44.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-CHE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-CHE-EAC', 'Maya Spices Chevda 250g', 60.00, 60.00, 44.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-KMU-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-KMU-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Kashmiri Murkoo',
        RecommendedSellingPrice = 25.00,
        LastPaidPrice = 25.00,
        AverageCost = 9.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-KMU-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-KMU-EAC', 'Kashmiri Murkoo', 25.00, 25.00, 9.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-KNP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-KNP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Kara Nichhas Peanuts',
        RecommendedSellingPrice = 7.00,
        LastPaidPrice = 7.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-KNP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-KNP-EAC', 'Kara Nichhas Peanuts', 7.00, 7.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-LMP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-LMP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Murkoo Extra Large Plain',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 23.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-LMP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-LMP-EAC', 'Murkoo Extra Large Plain', 50.00, 50.00, 23.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-LMS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-LMS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Murkoo Extra Large',
        RecommendedSellingPrice = 50.00,
        LastPaidPrice = 50.00,
        AverageCost = 23.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-LMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-LMS-EAC', 'Murkoo Extra Large', 50.00, 50.00, 23.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-MOC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-MOC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Murkoo Original Crunch',
        RecommendedSellingPrice = 30.00,
        LastPaidPrice = 30.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-MOC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-MOC-EAC', 'Murkoo Original Crunch', 30.00, 30.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-MSF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-MSF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Murkoo sticks flavoured',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-MSF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-MSF-EAC', 'Murkoo sticks flavoured', 20.00, 20.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-MUS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-MUS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Murkoo Sticks',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 7.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-MUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-MUS-EAC', 'Murkoo Sticks', 20.00, 20.00, 7.50, 'RawMaterial', 1);
END

-- Update or Insert: SNA-NUT-60G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-NUT-60G')
BEGIN
    UPDATE Products 
    SET ProductName = 'ralphies nutties 60g',
        RecommendedSellingPrice = 7.00,
        LastPaidPrice = 7.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-NUT-60G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-NUT-60G', 'ralphies nutties 60g', 7.00, 7.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-NUT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-NUT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Nuts',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-NUT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-NUT-EAC', 'Nuts', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-OATS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-OATS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fine Oats',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-OATS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-OATS-EAC', 'Fine Oats', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-PGA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-PGA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Papdi Ganthiya',
        RecommendedSellingPrice = 45.00,
        LastPaidPrice = 45.00,
        AverageCost = 25.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-PGA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-PGA-EAC', 'Papdi Ganthiya', 45.00, 45.00, 25.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-PNM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-PNM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'PNS Murkoo',
        RecommendedSellingPrice = 11.80,
        LastPaidPrice = 11.80,
        AverageCost = 9.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-PNM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-PNM-EAC', 'PNS Murkoo', 11.80, 11.80, 9.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-PNM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-PNM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'PNS Murkoo',
        RecommendedSellingPrice = 11.80,
        LastPaidPrice = 11.80,
        AverageCost = 9.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-PNM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-PNM-EAC', 'PNS Murkoo', 11.80, 11.80, 9.00, 'RawMaterial', 1);
END

-- Update or Insert: snA-PNM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'snA-PNM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Serve and Nuts 400g',
        RecommendedSellingPrice = 11.80,
        LastPaidPrice = 11.80,
        AverageCost = 9.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'snA-PNM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('snA-PNM-EAC', 'Serve and Nuts 400g', 11.80, 11.80, 9.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-PNT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-PNT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'PNS Traditional Murkoo',
        RecommendedSellingPrice = 9.50,
        LastPaidPrice = 9.50,
        AverageCost = 7.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-PNT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-PNT-EAC', 'PNS Traditional Murkoo', 9.50, 9.50, 7.40, 'RawMaterial', 1);
END

-- Update or Insert: SNA-SAN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-SAN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Serv & Nuts',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 6.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-SAN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-SAN-EAC', 'Serv & Nuts', 20.00, 20.00, 6.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-SGA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-SGA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Soft Gantia',
        RecommendedSellingPrice = 55.00,
        LastPaidPrice = 55.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-SGA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-SGA-EAC', 'Soft Gantia', 55.00, 55.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SNA-SUS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-SUS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sugar Sticks',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 7.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-SUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-SUS-EAC', 'Sugar Sticks', 13.00, 13.00, 7.50, 'RawMaterial', 1);
END

-- Update or Insert: SNA-TMU-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SNA-TMU-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tub Murkoo',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SNA-TMU-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SNA-TMU-EAC', 'Tub Murkoo', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-BPE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-BPE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice- Whole Black Pepper',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-BPE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-BPE-KGR', 'Spice- Whole Black Pepper', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-CIB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-CIB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice Cook In Bag',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-CIB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-CIB-EAC', 'Spice Cook In Bag', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-CIS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-CIS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice - Cinnamon Sticks',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-CIS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-CIS-EAC', 'Spice - Cinnamon Sticks', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-DHA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-DHA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice- Dhania Powder',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 180.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-DHA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-DHA-KGR', 'Spice- Dhania Powder', 0, 0, 180.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-GAR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-GAR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice-Garum Masala',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 300.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-GAR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-GAR-KGR', 'Spice-Garum Masala', 0, 0, 300.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-GIN-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-GIN-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ginger & Garlic',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 78.26,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-GIN-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-GIN-KGR', 'Ginger & Garlic', 0, 0, 78.26, 'RawMaterial', 1);
END

-- Update or Insert: SPI-JEE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-JEE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice - Mayas Jeera Powder',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 110.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-JEE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-JEE-KGR', 'Spice - Mayas Jeera Powder', 0, 0, 110.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-JEP-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-JEP-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice Jeera Powder',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-JEP-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-JEP-KGR', 'Spice Jeera Powder', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-KNO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-KNO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice- Knorrx Mutton Flavour 12s',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-KNO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-KNO-EAC', 'Spice- Knorrx Mutton Flavour 12s', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-MAS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-MAS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice- Chilli Powder',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-MAS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-MAS-KGR', 'Spice- Chilli Powder', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-MIN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-MIN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice - Mint',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-MIN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-MIN-EAC', 'Spice - Mint', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-MIX-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-MIX-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice- Mayas Mixed Masala',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 150.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-MIX-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-MIX-KGR', 'Spice- Mayas Mixed Masala', 0, 0, 150.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-MSM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-MSM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Manilal Special Mix Masala',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-MSM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-MSM-KGR', 'Manilal Special Mix Masala', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-NAN-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-NAN-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Nandos Sauce',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-NAN-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-NAN-KGR', 'Nandos Sauce', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-NOL-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-NOL-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Nola Mayonaise',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-NOL-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-NOL-KGR', 'Nola Mayonaise', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-PAR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-PAR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Parsley',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-PAR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-PAR-EAC', 'Parsley', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-SVS-100G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-SVS-100G')
BEGIN
    UPDATE Products 
    SET ProductName = 'SVS Spices 100g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-SVS-100G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-SVS-100G', 'SVS Spices 100g', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-SVS-50G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-SVS-50G')
BEGIN
    UPDATE Products 
    SET ProductName = 'SVS Spices 50g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-SVS-50G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-SVS-50G', 'SVS Spices 50g', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-THY-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-THY-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice - Fresh Thyme',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-THY-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-THY-EACH', 'Spice - Fresh Thyme', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SPI-TUM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SPI-TUM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice Tumeric',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 80.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SPI-TUM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SPI-TUM-KGR', 'Spice Tumeric', 0, 0, 80.00, 'RawMaterial', 1);
END

-- Update or Insert: SRC-CHO-CRE
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRC-CHO-CRE')
BEGIN
    UPDATE Products 
    SET ProductName = 'Choc Cream -20 Fig On Base',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRC-CHO-CRE';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRC-CHO-CRE', 'Choc Cream -20 Fig On Base', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-AER-022
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-AER-022')
BEGIN
    UPDATE Products 
    SET ProductName = 'Aeroplane Cake 22 in Plastic Icing and B/C',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-AER-022';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-AER-022', 'Aeroplane Cake 22 in Plastic Icing and B/C', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-ANI-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-ANI-016')
BEGIN
    UPDATE Products 
    SET ProductName = '16 Buttercream Animal Farm',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-ANI-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-ANI-016', '16 Buttercream Animal Farm', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-BCE-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-BCE-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD20 Buttercream Eggless Cake',
        RecommendedSellingPrice = 1040.00,
        LastPaidPrice = 1040.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-BCE-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-BCE-020', 'BD20 Buttercream Eggless Cake', 1040.00, 1040.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-BCR-022
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-BCR-022')
BEGIN
    UPDATE Products 
    SET ProductName = 'BC 22 Cut out Figure',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-BCR-022';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-BCR-022', 'BC 22 Cut out Figure', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-BIB-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-BIB-016')
BEGIN
    UPDATE Products 
    SET ProductName = '16 Buttercream Eggless Bible Cake',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-BIB-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-BIB-016', '16 Buttercream Eggless Bible Cake', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-BIB-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-BIB-020')
BEGIN
    UPDATE Products 
    SET ProductName = '20 Fresh Cream Egless Bible Cake',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-BIB-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-BIB-020', '20 Fresh Cream Egless Bible Cake', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-BMW-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-BMW-014')
BEGIN
    UPDATE Products 
    SET ProductName = '14 Sponge in plastic icing with BMW sign',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-BMW-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-BMW-014', '14 Sponge in plastic icing with BMW sign', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-BRE-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-BRE-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'Buttercream Round Eggless with Baby',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-BRE-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-BRE-016', 'Buttercream Round Eggless with Baby', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-BSC-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-BSC-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 16Buttercream with baby grower in PI',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-BSC-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-BSC-016', 'BD 16Buttercream with baby grower in PI', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-BYK-022
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-BYK-022')
BEGIN
    UPDATE Products 
    SET ProductName = '22 Motorbike on Base with Plastic icing',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-BYK-022';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-BYK-022', '22 Motorbike on Base with Plastic icing', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-CML-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-CML-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'Caramel Spread only - on 16',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-CML-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-CML-016', 'Caramel Spread only - on 16', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-CRM-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-CRM-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream colour cream only - 16',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-CRM-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-CRM-016', 'Cream colour cream only - 16', 100.00, 100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-DAI-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-DAI-020')
BEGIN
    UPDATE Products 
    SET ProductName = '20 Buttercream with Piped Daisies',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-DAI-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-DAI-020', '20 Buttercream with Piped Daisies', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-DBF-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-DBF-020')
BEGIN
    UPDATE Products 
    SET ProductName = '20 BC Double Base With Double Figure',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-DBF-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-DBF-020', '20 BC Double Base With Double Figure', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-DIA-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-DIA-020')
BEGIN
    UPDATE Products 
    SET ProductName = '20 Round PI Diamond pattern & Daisies',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-DIA-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-DIA-020', '20 Round PI Diamond pattern & Daisies', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-DOL-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-DOL-016')
BEGIN
    UPDATE Products 
    SET ProductName = '16 Doll Cake in Plastic Icing no base',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-DOL-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-DOL-016', '16 Doll Cake in Plastic Icing no base', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-FCE-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-FCE-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD 20 Fresh Cream Eggless cake',
        RecommendedSellingPrice = 1120.00,
        LastPaidPrice = 1120.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-FCE-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-FCE-020', 'BD 20 Fresh Cream Eggless cake', 1120.00, 1120.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-FIG-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-FIG-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'Buttercream Eggless Figure on base 20',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-FIG-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-FIG-020', 'Buttercream Eggless Figure on base 20', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-FOB-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-FOB-020')
BEGIN
    UPDATE Products 
    SET ProductName = '20 FC Fig on Base with Choc Flakes',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-FOB-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-FOB-020', '20 FC Fig on Base with Choc Flakes', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-HBS-020
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-HBS-020')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hugo Boss Suitcase Belt 20 in Plastic Icing',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-HBS-020';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-HBS-020', 'Hugo Boss Suitcase Belt 20 in Plastic Icing', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-JAM-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-JAM-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'Strawberry Jam only - 12',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-JAM-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-JAM-012', 'Strawberry Jam only - 12', 100.00, 100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-JAM-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-JAM-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'Strawberry Jam only - 12',
        RecommendedSellingPrice = 100.00,
        LastPaidPrice = 100.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-JAM-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-JAM-012', 'Strawberry Jam only - 12', 100.00, 100.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-JAM-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-JAM-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'Strawberry Jam only - 14',
        RecommendedSellingPrice = 120.00,
        LastPaidPrice = 120.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-JAM-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-JAM-014', 'Strawberry Jam only - 14', 120.00, 120.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-JAM-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-JAM-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'Strawberry Jam only - 14',
        RecommendedSellingPrice = 120.00,
        LastPaidPrice = 120.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-JAM-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-JAM-014', 'Strawberry Jam only - 14', 120.00, 120.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-JAM-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-JAM-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'Strawberry Jam only - 16',
        RecommendedSellingPrice = 140.00,
        LastPaidPrice = 140.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-JAM-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-JAM-016', 'Strawberry Jam only - 16', 140.00, 140.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-JAM-18
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-JAM-18')
BEGIN
    UPDATE Products 
    SET ProductName = 'Strawberry Jam Only-18',
        RecommendedSellingPrice = 220.00,
        LastPaidPrice = 220.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-JAM-18';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-JAM-18', 'Strawberry Jam Only-18', 220.00, 220.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-JAM-20
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-JAM-20')
BEGIN
    UPDATE Products 
    SET ProductName = 'Strawberry Jam Only-20',
        RecommendedSellingPrice = 220.00,
        LastPaidPrice = 220.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-JAM-20';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-JAM-20', 'Strawberry Jam Only-20', 220.00, 220.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-LIV-022
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-LIV-022')
BEGIN
    UPDATE Products 
    SET ProductName = '22 PI Liverpool with Scarf and Boots',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-LIV-022';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-LIV-022', '22 PI Liverpool with Scarf and Boots', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-LVB-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-LVB-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'Louis Vittone Bag 16 in Plastic Icing',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-LVB-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-LVB-016', 'Louis Vittone Bag 16 in Plastic Icing', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-PAD-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-PAD-016')
BEGIN
    UPDATE Products 
    SET ProductName = '40*50 B/C cake with Ipad in PI + pic',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-PAD-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-PAD-016', '40*50 B/C cake with Ipad in PI + pic', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-PAI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-PAI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Painting on Roses',
        RecommendedSellingPrice = 5.00,
        LastPaidPrice = 5.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-PAI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-PAI-EAC', 'Painting on Roses', 5.00, 5.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-PEA-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-PEA-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'Peach Slices Only 14',
        RecommendedSellingPrice = 75.00,
        LastPaidPrice = 75.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-PEA-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-PEA-014', 'Peach Slices Only 14', 75.00, 75.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-PID-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-PID-014')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD14'' Round covered in plastic icing and daisies',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-PID-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-PID-014', 'BD14'' Round covered in plastic icing and daisies', 0, 0, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-PLI-012
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-PLI-012')
BEGIN
    UPDATE Products 
    SET ProductName = 'Plastic Icing Covering Only 12',
        RecommendedSellingPrice = 500.00,
        LastPaidPrice = 500.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-PLI-012';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-PLI-012', 'Plastic Icing Covering Only 12', 500.00, 500.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-PLI-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-PLI-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'Plastic Icing Covering Only 16',
        RecommendedSellingPrice = 500.00,
        LastPaidPrice = 500.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-PLI-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-PLI-016', 'Plastic Icing Covering Only 16', 500.00, 500.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-PLI-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-PLI-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'Plastic Icing Covering Only 16',
        RecommendedSellingPrice = 500.00,
        LastPaidPrice = 500.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SRN-PLI-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-PLI-016', 'Plastic Icing Covering Only 16', 500.00, 500.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SRN-PLR-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-PLR-016')
BEGIN
    UPDATE Products 
    SET ProductName = 'Plastic Icing 16 round with musical notes',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-PLR-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-PLR-016', 'Plastic Icing 16 round with musical notes', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-ROA-014
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-ROA-014')
BEGIN
    UPDATE Products 
    SET ProductName = '14 Buttercream with Plastic icing Road',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-ROA-014';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-ROA-014', '14 Buttercream with Plastic icing Road', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-SSC-016
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-SSC-016')
BEGIN
    UPDATE Products 
    SET ProductName = '16 BC S/Berry Short/C Figurine-PI',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-SSC-016';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-SSC-016', '16 BC S/Berry Short/C Figurine-PI', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-STA-2TI
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-STA-2TI')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD2 Tier Stack Sponge- Plastic Icing-12&14',
        RecommendedSellingPrice = 2500.00,
        LastPaidPrice = 2500.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-STA-2TI';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-STA-2TI', 'BD2 Tier Stack Sponge- Plastic Icing-12&14', 2500.00, 2500.00, 0.00, 'internal', 1);
END

-- Update or Insert: SRN-STA-2TI
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SRN-STA-2TI')
BEGIN
    UPDATE Products 
    SET ProductName = 'BD2 Tier Stack Sponge- Plastic Icing-12&14',
        RecommendedSellingPrice = 2500.00,
        LastPaidPrice = 2500.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'SRN-STA-2TI';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SRN-STA-2TI', 'BD2 Tier Stack Sponge- Plastic Icing-12&14', 2500.00, 2500.00, 0.00, 'internal', 1);
END

-- Update or Insert: SWE-ALC-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-ALC-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Almond Cones',
        RecommendedSellingPrice = 35.00,
        LastPaidPrice = 35.00,
        AverageCost = 22.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-ALC-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-ALC-EACH', 'Almond Cones', 35.00, 35.00, 22.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-BOR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-BOR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Masala Bor',
        RecommendedSellingPrice = 6.00,
        LastPaidPrice = 6.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-BOR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-BOR-EAC', 'Masala Bor', 6.00, 6.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CAC-EACK
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CAC-EACK')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cashew Cones',
        RecommendedSellingPrice = 16.00,
        LastPaidPrice = 16.00,
        AverageCost = 10.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CAC-EACK';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CAC-EACK', 'Cashew Cones', 16.00, 16.00, 10.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CCC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CCC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Coconut Cluster',
        RecommendedSellingPrice = 11.00,
        LastPaidPrice = 11.00,
        AverageCost = 8.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CCC-EAC', 'Chocolate Coconut Cluster', 11.00, 11.00, 8.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CCD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CCD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Caruchi Candy Dates',
        RecommendedSellingPrice = 6.80,
        LastPaidPrice = 6.80,
        AverageCost = 4.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CCD-EAC', 'Caruchi Candy Dates', 6.80, 6.80, 4.40, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CFW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CFW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'China fruit sweet',
        RecommendedSellingPrice = 2.50,
        LastPaidPrice = 2.50,
        AverageCost = 1.25,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CFW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CFW-EAC', 'China fruit sweet', 2.50, 2.50, 1.25, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CHF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CHF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'China Fruit',
        RecommendedSellingPrice = 5.50,
        LastPaidPrice = 5.50,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CHF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CHF-EAC', 'China Fruit', 5.50, 5.50, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CHI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CHI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chicks Violet',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 9.33,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CHI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CHI-EAC', 'Chicks Violet', 13.00, 13.00, 9.33, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CMM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CMM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Choc Marshmallow',
        RecommendedSellingPrice = 14.00,
        LastPaidPrice = 14.00,
        AverageCost = 9.38,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CMM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CMM-EAC', 'Choc Marshmallow', 14.00, 14.00, 9.38, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CNI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CNI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coconut Ice',
        RecommendedSellingPrice = 6.80,
        LastPaidPrice = 6.80,
        AverageCost = 4.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CNI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CNI-EAC', 'Coconut Ice', 6.80, 6.80, 4.40, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CNW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CNW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coconut Wheel',
        RecommendedSellingPrice = 15.00,
        LastPaidPrice = 15.00,
        AverageCost = 11.20,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CNW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CNW-EAC', 'Coconut Wheel', 15.00, 15.00, 11.20, 'RawMaterial', 1);
END

-- Update or Insert: SWE-COI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-COI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coconut ice small',
        RecommendedSellingPrice = 3.50,
        LastPaidPrice = 3.50,
        AverageCost = 1.25,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-COI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-COI-EAC', 'Coconut ice small', 3.50, 3.50, 1.25, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CPC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CPC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Peanut Cluster',
        RecommendedSellingPrice = 11.00,
        LastPaidPrice = 11.00,
        AverageCost = 8.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CPC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CPC-EAC', 'Chocolate Peanut Cluster', 11.00, 11.00, 8.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CRO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CRO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Rocher',
        RecommendedSellingPrice = 8.00,
        LastPaidPrice = 8.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CRO-EAC', 'Chocolate Rocher', 8.00, 8.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CRO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CRO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Rocher',
        RecommendedSellingPrice = 8.00,
        LastPaidPrice = 8.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CRO-EAC', 'Chocolate Rocher', 8.00, 8.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-CSP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-CSP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sour Punk Cola',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-CSP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-CSP-EAC', 'Sour Punk Cola', 13.00, 13.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-FIG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-FIG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Masala Figs',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 5.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-FIG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-FIG-EAC', 'Masala Figs', 10.00, 10.00, 5.50, 'RawMaterial', 1);
END

-- Update or Insert: SWE-KIT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-KIT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Kitkat 135g',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-KIT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-KIT-EAC', 'Kitkat 135g', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-MES-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-MES-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mebos Sweets',
        RecommendedSellingPrice = 5.00,
        LastPaidPrice = 5.00,
        AverageCost = 3.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-MES-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-MES-EAC', 'Mebos Sweets', 5.00, 5.00, 3.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-PAA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-PAA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Paan Cones',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-PAA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-PAA-EAC', 'Paan Cones', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-PBS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-PBS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Peanut Brittle Slabs Singles',
        RecommendedSellingPrice = 7.00,
        LastPaidPrice = 7.00,
        AverageCost = 20.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-PBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-PBS-EAC', 'Peanut Brittle Slabs Singles', 7.00, 7.00, 20.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-PEC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-PEC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Peanut Cones',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-PEC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-PEC-EAC', 'Peanut Cones', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-PNB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-PNB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'peanut brittle',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-PNB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-PNB-EAC', 'peanut brittle', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-PNB-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-PNB-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Peanut Brittle Slab 10s',
        RecommendedSellingPrice = 60.00,
        LastPaidPrice = 60.00,
        AverageCost = 23.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-PNB-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-PNB-EACH', 'Peanut Brittle Slab 10s', 60.00, 60.00, 23.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-PNP-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-PNP-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Peanut Brittle Pieces',
        RecommendedSellingPrice = 20.00,
        LastPaidPrice = 20.00,
        AverageCost = 11.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-PNP-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-PNP-EACH', 'Peanut Brittle Pieces', 20.00, 20.00, 11.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-SAB-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-SAB-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Almond Bar 40g single',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 11.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-SAB-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-SAB-EACH', 'Almond Bar 40g single', 18.00, 18.00, 11.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-SCB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-SCB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cashew Bar 40g single',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 11.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-SCB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-SCB-EAC', 'Cashew Bar 40g single', 18.00, 18.00, 11.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-SPA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-SPA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sour Punk Apple',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 7.70,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-SPA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-SPA-EAC', 'Sour Punk Apple', 13.00, 13.00, 7.70, 'RawMaterial', 1);
END

-- Update or Insert: SWE-SPB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-SPB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sesame Brittle Pieces',
        RecommendedSellingPrice = 18.00,
        LastPaidPrice = 18.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-SPB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-SPB-EAC', 'Sesame Brittle Pieces', 18.00, 18.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-SPS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-SPS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sour Punk',
        RecommendedSellingPrice = 13.00,
        LastPaidPrice = 13.00,
        AverageCost = 7.70,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-SPS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-SPS-EAC', 'Sour Punk', 13.00, 13.00, 7.70, 'RawMaterial', 1);
END

-- Update or Insert: SWE-SSB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-SSB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sweet & Sour Bor',
        RecommendedSellingPrice = 8.00,
        LastPaidPrice = 8.00,
        AverageCost = 6.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-SSB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-SSB-EAC', 'Sweet & Sour Bor', 8.00, 8.00, 6.00, 'RawMaterial', 1);
END

-- Update or Insert: SWE-SSF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-SSF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sweet & Sour Figs',
        RecommendedSellingPrice = 10.00,
        LastPaidPrice = 10.00,
        AverageCost = 8.80,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-SSF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-SSF-EAC', 'Sweet & Sour Figs', 10.00, 10.00, 8.80, 'RawMaterial', 1);
END

-- Update or Insert: SWE-TOA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-TOA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Toasted Jabs',
        RecommendedSellingPrice = 5.50,
        LastPaidPrice = 5.50,
        AverageCost = 4.10,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-TOA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-TOA-EAC', 'Toasted Jabs', 5.50, 5.50, 4.10, 'RawMaterial', 1);
END

-- Update or Insert: SWE-WHI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'SWE-WHI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Whispers 200g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 49.56,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'SWE-WHI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('SWE-WHI-EAC', 'Whispers 200g', 0, 0, 49.56, 'RawMaterial', 1);
END

-- Update or Insert: VEG -ONI-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'VEG -ONI-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Onions',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'VEG -ONI-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('VEG -ONI-KGR', 'Onions', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: VEG- POT-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'VEG- POT-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Potatoes',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'VEG- POT-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('VEG- POT-KGR', 'Potatoes', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: VEG-CHI-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'VEG-CHI-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Green Chillies',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'VEG-CHI-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('VEG-CHI-KGR', 'Green Chillies', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: VEG-MUS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'VEG-MUS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mushrooms',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'VEG-MUS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('VEG-MUS-KGR', 'Mushrooms', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: Water
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'Water')
BEGIN
    UPDATE Products 
    SET ProductName = 'Water',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'Water';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('Water', 'Water', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XBF-BAN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBF-BAN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fruit Banana',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBF-BAN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBF-BAN-EAC', 'Fruit Banana', 0, 0, 1.00, 'RawMaterial', 1);
END

-- Update or Insert: XBF-BAN-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBF-BAN-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Banana Essence',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 211.28,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBF-BAN-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBF-BAN-KGR', 'Banana Essence', 0, 0, 211.28, 'RawMaterial', 1);
END

-- Update or Insert: XBF-CAR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBF-CAR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Carrots',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBF-CAR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBF-CAR-KGR', 'Carrots', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XBF-CHL-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBF-CHL-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chellies Red Alpine',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 40.90,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBF-CHL-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBF-CHL-KGR', 'Chellies Red Alpine', 0, 0, 40.90, 'RawMaterial', 1);
END

-- Update or Insert: XBF-COC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBF-COC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coconut',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBF-COC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBF-COC-KGR', 'Coconut', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XBF-CUT-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBF-CUT-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fruit Cut Peel',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 64.21,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBF-CUT-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBF-CUT-KGR', 'Fruit Cut Peel', 0, 0, 64.21, 'RawMaterial', 1);
END

-- Update or Insert: XBF-FMX-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBF-FMX-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fruit Mix (Chipkins)',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 26.38,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBF-FMX-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBF-FMX-KGR', 'Fruit Mix (Chipkins)', 0, 0, 26.38, 'RawMaterial', 1);
END

-- Update or Insert: XBF-PDA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBF-PDA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pitted Dates',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBF-PDA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBF-PDA-KGR', 'Pitted Dates', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XBF-PIE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBF-PIE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fruit Pie Apples',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 16.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBF-PIE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBF-PIE-KGR', 'Fruit Pie Apples', 0, 0, 16.40, 'RawMaterial', 1);
END

-- Update or Insert: XBF-RWC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBF-RWC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Red Whole Cherries',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 71.21,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBF-RWC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBF-RWC-KGR', 'Red Whole Cherries', 0, 0, 71.21, 'RawMaterial', 1);
END

-- Update or Insert: XBR-BEB-1KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBR-BEB-1KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Berries Blend',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 67.65,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBR-BEB-1KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBR-BEB-1KGR', 'Berries Blend', 0, 0, 67.65, 'RawMaterial', 1);
END

-- Update or Insert: XBR-MDF-1KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBR-MDF-1KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mango Diced Fruit',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 97.92,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBR-MDF-1KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBR-MDF-1KGR', 'Mango Diced Fruit', 0, 0, 97.92, 'RawMaterial', 1);
END

-- Update or Insert: XBR-PEA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBR-PEA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Peach Slices',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBR-PEA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBR-PEA-KGR', 'Peach Slices', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XBR-TOM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XBR-TOM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tomatoe Paste 3.06kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XBR-TOM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XBR-TOM-KGR', 'Tomatoe Paste 3.06kg', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XCH-BAR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCH-BAR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Bar One',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'XCH-BAR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCH-BAR-EAC', 'Chocolate Bar One', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: XCH-CCB-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCH-CCB-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Choco Blocks',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 48.95,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCH-CCB-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCH-CCB-KGR', 'Chocolate Choco Blocks', 0, 0, 48.95, 'RawMaterial', 1);
END

-- Update or Insert: XCH-CCM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCH-CCM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Chockex Chips Milk',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 66.66,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCH-CCM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCH-CCM-KGR', 'Chocolate Chockex Chips Milk', 0, 0, 66.66, 'RawMaterial', 1);
END

-- Update or Insert: XCH-CCW-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCH-CCW-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Chockex Chips White',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 66.57,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCH-CCW-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCH-CCW-KGR', 'Chocolate Chockex Chips White', 0, 0, 66.57, 'RawMaterial', 1);
END

-- Update or Insert: XCH-CHO-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCH-CHO-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Choc milk block',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCH-CHO-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCH-CHO-KGR', 'Choc milk block', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XCH-POW-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCH-POW-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Powder Cocoa',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 125.84,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCH-POW-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCH-POW-KGR', 'Powder Cocoa', 0, 0, 125.84, 'RawMaterial', 1);
END

-- Update or Insert: XCH-TIN-KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCH-TIN-KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tin Glide 5kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 55.62,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCH-TIN-KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCH-TIN-KG', 'Tin Glide 5kg', 0, 0, 55.62, 'RawMaterial', 1);
END

-- Update or Insert: XCH-VER-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCH-VER-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Vermicelli Chocolate',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 52.04,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCH-VER-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCH-VER-KGR', 'Vermicelli Chocolate', 0, 0, 52.04, 'RawMaterial', 1);
END

-- Update or Insert: XCH-WCH-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCH-WCH-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Choc Milk Block White',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCH-WCH-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCH-WCH-KGR', 'Choc Milk Block White', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XCO-AES-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCO-AES-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Aniseed Essence',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 123.57,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCO-AES-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCO-AES-LTR', 'Aniseed Essence', 0, 0, 123.57, 'RawMaterial', 1);
END

-- Update or Insert: XCO-BCR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCO-BCR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bread Crumbs',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 210.55,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCO-BCR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCO-BCR-KGR', 'Bread Crumbs', 0, 0, 210.55, 'RawMaterial', 1);
END

-- Update or Insert: XCO-BLA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCO-BLA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Black Jack',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 41.74,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCO-BLA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCO-BLA-KGR', 'Black Jack', 0, 0, 41.74, 'RawMaterial', 1);
END

-- Update or Insert: XCO-LEM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCO-LEM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coloured Powder Lemon Yellow',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 160.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCO-LEM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCO-LEM-KGR', 'Coloured Powder Lemon Yellow', 0, 0, 160.29, 'RawMaterial', 1);
END

-- Update or Insert: XCO-PBL-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCO-PBL-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'powder food colouring blue',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 159.70,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCO-PBL-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCO-PBL-KGR', 'powder food colouring blue', 0, 0, 159.70, 'RawMaterial', 1);
END

-- Update or Insert: XCO-PGN-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCO-PGN-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Powder colouring green',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 160.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCO-PGN-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCO-PGN-KGR', 'Powder colouring green', 0, 0, 160.00, 'RawMaterial', 1);
END

-- Update or Insert: XCO-PIL-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCO-PIL-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pillar Box Red',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 124.14,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCO-PIL-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCO-PIL-KGR', 'Pillar Box Red', 0, 0, 124.14, 'RawMaterial', 1);
END

-- Update or Insert: XCO-REG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCO-REG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Red piping gel',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCO-REG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCO-REG-EAC', 'Red piping gel', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XCO-VES-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XCO-VES-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Vanilla Essence',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 68.31,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XCO-VES-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XCO-VES-LTR', 'Vanilla Essence', 0, 0, 68.31, 'RawMaterial', 1);
END

-- Update or Insert: XDA-BERG-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-BERG-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Berg Cheese',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 78.26,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-BERG-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-BERG-KGR', 'Berg Cheese', 0, 0, 78.26, 'RawMaterial', 1);
END

-- Update or Insert: XDA-BME-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-BME-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Boneless Mutton',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-BME-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-BME-KGR', 'Boneless Mutton', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XDA-BUT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-BUT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Buttermilk',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 40.36,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-BUT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-BUT-EAC', 'Buttermilk', 0, 0, 40.36, 'RawMaterial', 1);
END

-- Update or Insert: XDA-CBF-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-CBF-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chicken Breast Fillet',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 49.49,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-CBF-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-CBF-KGR', 'Chicken Breast Fillet', 0, 0, 49.49, 'RawMaterial', 1);
END

-- Update or Insert: XDA-CCS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-CCS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cheese Cottage Smooth',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 95.43,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-CCS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-CCS-KGR', 'Cheese Cottage Smooth', 0, 0, 95.43, 'RawMaterial', 1);
END

-- Update or Insert: XDA-CHE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-CHE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cheddar Cheese',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 101.67,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-CHE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-CHE-KGR', 'Cheddar Cheese', 0, 0, 101.67, 'RawMaterial', 1);
END

-- Update or Insert: XDA-CHI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-CHI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chicken Wings Drumettes',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 105.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-CHI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-CHI-EAC', 'Chicken Wings Drumettes', 0, 0, 105.00, 'RawMaterial', 1);
END

-- Update or Insert: XDA-CRA-1KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-CRA-1KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Crab Sticks',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 38.05,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-CRA-1KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-CRA-1KG', 'Crab Sticks', 0, 0, 38.05, 'RawMaterial', 1);
END

-- Update or Insert: XDA-CRE-250
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-CRE-250')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream Cheese',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 123.87,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-CRE-250';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-CRE-250', 'Cream Cheese', 0, 0, 123.87, 'RawMaterial', 1);
END

-- Update or Insert: XDA-CRF-250
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-CRF-250')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream Fresh 250ml',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-CRF-250';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-CRF-250', 'Cream Fresh 250ml', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XDA-CRF-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-CRF-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream Fresh 500ml',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 47.64,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-CRF-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-CRF-500', 'Cream Fresh 500ml', 0, 0, 47.64, 'RawMaterial', 1);
END

-- Update or Insert: XDA-CSS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-CSS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chicken Salsa Snack Wings 6kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 95.65,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-CSS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-CSS-KGR', 'Chicken Salsa Snack Wings 6kg', 0, 0, 95.65, 'RawMaterial', 1);
END

-- Update or Insert: XDA-CTS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-CTS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chicken Tikka Sausage',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 60.87,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-CTS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-CTS-KGR', 'Chicken Tikka Sausage', 0, 0, 60.87, 'RawMaterial', 1);
END

-- Update or Insert: XDA-DHA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-DHA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pea Dhall 5kg',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-DHA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-DHA-KGR', 'Pea Dhall 5kg', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XDA-FCR-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-FCR-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream Fresh 250ml',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 13.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-FCR-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-FCR-250ML', 'Cream Fresh 250ml', 0, 0, 13.50, 'RawMaterial', 1);
END

-- Update or Insert: XDA-FLO-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-FLO-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Flora light',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 73.79,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'XDA-FLO-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-FLO-KGR', 'Flora light', 0, 0, 73.79, 'external', 1);
END

-- Update or Insert: XDA-HAK-1KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-HAK-1KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hake Fillet -fish',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 138.45,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-HAK-1KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-HAK-1KG', 'Hake Fillet -fish', 0, 0, 138.45, 'RawMaterial', 1);
END

-- Update or Insert: XDA-JAL-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-JAL-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jalapenos',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 35.60,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-JAL-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-JAL-KGR', 'Jalapenos', 0, 0, 35.60, 'RawMaterial', 1);
END

-- Update or Insert: XDA-LAM- KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-LAM- KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Lamb Mince',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 86.09,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-LAM- KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-LAM- KGR', 'Lamb Mince', 0, 0, 86.09, 'RawMaterial', 1);
END

-- Update or Insert: XDA-MBP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-MBP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Butter Portions 8grams',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.08,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-MBP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-MBP-EAC', 'Mini Butter Portions 8grams', 0, 0, 1.08, 'RawMaterial', 1);
END

-- Update or Insert: XDA-MCP-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-MCP-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mutton Cheese Patties',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-MCP-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-MCP-KGR', 'Mutton Cheese Patties', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XDA-MJP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-MJP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mini Jam Portions 15Grams',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.15,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-MJP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-MJP-EAC', 'Mini Jam Portions 15Grams', 0, 0, 1.15, 'RawMaterial', 1);
END

-- Update or Insert: XDA-MVE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-MVE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mix Veggies Mcain',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 37.11,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-MVE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-MVE-KGR', 'Mix Veggies Mcain', 0, 0, 37.11, 'RawMaterial', 1);
END

-- Update or Insert: XDA-NON-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-NON-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Non Dairy Cream',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 46.09,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-NON-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-NON-KGR', 'Non Dairy Cream', 0, 0, 46.09, 'RawMaterial', 1);
END

-- Update or Insert: XDA-NUT-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-NUT-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Nutriday Yogurt Plain',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 22.28,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-NUT-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-NUT-LTR', 'Nutriday Yogurt Plain', 0, 0, 22.28, 'RawMaterial', 1);
END

-- Update or Insert: XDA-OGC-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-OGC-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream Fresh Orange Grove 1litre',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 50.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-OGC-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-OGC-LTR', 'Cream Fresh Orange Grove 1litre', 0, 0, 50.00, 'RawMaterial', 1);
END

-- Update or Insert: XDA-OMU-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-OMU-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Oriental Mutton Sausage',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 85.22,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-OMU-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-OMU-KGR', 'Oriental Mutton Sausage', 0, 0, 85.22, 'RawMaterial', 1);
END

-- Update or Insert: XDA-PAR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-PAR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Unbaked Patha Rolls',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 18.33,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-PAR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-PAR-EAC', 'Unbaked Patha Rolls', 0, 0, 18.33, 'RawMaterial', 1);
END

-- Update or Insert: XDA-PEA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-PEA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Peas Frozen 10kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 42.12,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-PEA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-PEA-KGR', 'Peas Frozen 10kg', 0, 0, 42.12, 'RawMaterial', 1);
END

-- Update or Insert: XDA-PUP-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-PUP-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fathimas Puff Pastry 1kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-PUP-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-PUP-KGR', 'Fathimas Puff Pastry 1kg', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XDA-SAC-1LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-SAC-1LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milk 1lt Sachet',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-SAC-1LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-SAC-1LT', 'Milk 1lt Sachet', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XDA-SMF-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-SMF-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Saldanha Middlecut Tin Fish 400g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 27.54,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-SMF-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-SMF-EAC', 'Saldanha Middlecut Tin Fish 400g', 0, 0, 27.54, 'RawMaterial', 1);
END

-- Update or Insert: XDA-SOY-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-SOY-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tommy Marinated Mince',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-SOY-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-SOY-KGR', 'Tommy Marinated Mince', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XDA-SWC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-SWC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mcain Sweetcorn 1kg',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-SWC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-SWC-KGR', 'Mcain Sweetcorn 1kg', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XDA-TUC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-TUC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tuna Chunks In Brine 1.7kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 123.53,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-TUC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-TUC-KGR', 'Tuna Chunks In Brine 1.7kg', 0, 0, 123.53, 'RawMaterial', 1);
END

-- Update or Insert: XDA-TUS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-TUS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tuna Shredded In Brine 1.7kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 132.72,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-TUS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-TUS-KGR', 'Tuna Shredded In Brine 1.7kg', 0, 0, 132.72, 'RawMaterial', 1);
END

-- Update or Insert: XDA-TWP-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-TWP-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tomato Whole Peeled',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 18.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-TWP-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-TWP-KGR', 'Tomato Whole Peeled', 0, 0, 18.40, 'RawMaterial', 1);
END

-- Update or Insert: XDA-YDR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDA-YDR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Yeast Dry',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 90.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDA-YDR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDA-YDR-KGR', 'Yeast Dry', 0, 0, 90.00, 'RawMaterial', 1);
END

-- Update or Insert: XDE-AST-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDE-AST-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Astd roses',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDE-AST-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDE-AST-EAC', 'Astd roses', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XDE-DIW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDE-DIW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Diwali Sticker',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'XDE-DIW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDE-DIW-EAC', 'Diwali Sticker', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: XDE-GBD-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDE-GBD-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gold Beads per Kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 426.51,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDE-GBD-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDE-GBD-KGR', 'Gold Beads per Kg', 0, 0, 426.51, 'RawMaterial', 1);
END

-- Update or Insert: XDE-GLI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDE-GLI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Glitter',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 17.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDE-GLI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDE-GLI-EAC', 'Glitter', 0, 0, 17.00, 'RawMaterial', 1);
END

-- Update or Insert: XDE-NOP-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDE-NOP-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Non Pareil',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 51.69,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDE-NOP-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDE-NOP-KGR', 'Non Pareil', 0, 0, 51.69, 'RawMaterial', 1);
END

-- Update or Insert: XDE-PMG-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDE-PMG-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Powder Metallic Gold',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 211.46,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDE-PMG-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDE-PMG-KGR', 'Powder Metallic Gold', 0, 0, 211.46, 'RawMaterial', 1);
END

-- Update or Insert: XDE-PMS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDE-PMS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Powder Metallic Silver',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 184.60,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDE-PMS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDE-PMS-KGR', 'Powder Metallic Silver', 0, 0, 184.60, 'RawMaterial', 1);
END

-- Update or Insert: XDE-RIB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDE-RIB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ribbon',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 24.48,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'XDE-RIB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDE-RIB-EAC', 'Ribbon', 0, 0, 24.48, 'external', 1);
END

-- Update or Insert: XDE-SIL-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDE-SIL-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Silver Beads Per Kg',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDE-SIL-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDE-SIL-KGR', 'Silver Beads Per Kg', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XDE-TEA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDE-TEA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ribbon tear 1 Roll',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDE-TEA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDE-TEA-EAC', 'Ribbon tear 1 Roll', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XDO-BTE-200G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XDO-BTE-200G')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bakers Tennis Biscuit 200g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 21.49,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XDO-BTE-200G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XDO-BTE-200G', 'Bakers Tennis Biscuit 200g', 0, 0, 21.49, 'RawMaterial', 1);
END

-- Update or Insert: XFA-COO-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-COO-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cooking Oil 5ltrs',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-COO-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-COO-LTR', 'Cooking Oil 5ltrs', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XFA-CRI-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-CRI-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Crispa Oil',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 35.61,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-CRI-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-CRI-LTR', 'Crispa Oil', 0, 0, 35.61, 'RawMaterial', 1);
END

-- Update or Insert: XFA-EGG-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-EGG-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Eggs',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 46.67,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-EGG-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-EGG-KGR', 'Eggs', 0, 0, 46.67, 'RawMaterial', 1);
END

-- Update or Insert: XFA-FPS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-FPS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fat Pastrex Super',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 26.99,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-FPS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-FPS-KGR', 'Fat Pastrex Super', 0, 0, 26.99, 'RawMaterial', 1);
END

-- Update or Insert: XFA-GHE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-GHE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Clover Ghee',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-GHE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-GHE-KGR', 'Clover Ghee', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XFA-MAR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-MAR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Margarine Marvello Yellow',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 48.58,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-MAR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-MAR-KGR', 'Margarine Marvello Yellow', 0, 0, 48.58, 'RawMaterial', 1);
END

-- Update or Insert: XFA-MAS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-MAS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Margarine Mastercraft White',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 31.44,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-MAS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-MAS-KGR', 'Margarine Mastercraft White', 0, 0, 31.44, 'RawMaterial', 1);
END

-- Update or Insert: XFA-MOO-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-MOO-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mooi river butter',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 61.42,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-MOO-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-MOO-KGR', 'Mooi river butter', 0, 0, 61.42, 'RawMaterial', 1);
END

-- Update or Insert: XFA-MRG-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-MRG-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Margarine Mr G',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 19.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-MRG-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-MRG-KGR', 'Margarine Mr G', 0, 0, 19.17, 'RawMaterial', 1);
END

-- Update or Insert: XFA-OIL-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-OIL-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Oil Crispa Gold',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 22.41,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-OIL-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-OIL-LTR', 'Oil Crispa Gold', 0, 0, 22.41, 'RawMaterial', 1);
END

-- Update or Insert: XFA-OVA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-OVA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ovalette',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 41.60,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-OVA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-OVA-KGR', 'Ovalette', 0, 0, 41.60, 'RawMaterial', 1);
END

-- Update or Insert: XFA-PTX-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-PTX-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pastrex Super',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 33.14,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-PTX-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-PTX-KGR', 'Pastrex Super', 0, 0, 33.14, 'RawMaterial', 1);
END

-- Update or Insert: XFA-RAM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-RAM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Rama',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-RAM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-RAM-KGR', 'Rama', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XFA-REL-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-REL-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Release',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 18.91,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-REL-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-REL-LTR', 'Release', 0, 0, 18.91, 'RawMaterial', 1);
END

-- Update or Insert: XFA-SOI-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-SOI-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sunflower Sunfoil 5 Ltr',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 39.52,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-SOI-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-SOI-LTR', 'Sunflower Sunfoil 5 Ltr', 0, 0, 39.52, 'RawMaterial', 1);
END

-- Update or Insert: XFA-SOR-LRT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-SOR-LRT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sorbitol 30LTR',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 19.20,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-SOR-LRT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-SOR-LRT', 'Sorbitol 30LTR', 0, 0, 19.20, 'RawMaterial', 1);
END

-- Update or Insert: XFA-YWT-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFA-YWT-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Yeast Wet',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 33.94,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFA-YWT-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFA-YWT-KGR', 'Yeast Wet', 0, 0, 33.94, 'RawMaterial', 1);
END

-- Update or Insert: XFL-BRF-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFL-BRF-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Flour Brown',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 6.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFL-BRF-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFL-BRF-125', 'Flour Brown', 0, 0, 6.17, 'RawMaterial', 1);
END

-- Update or Insert: XFL-CAF-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFL-CAF-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'FlourCake',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 11.92,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFL-CAF-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFL-CAF-125', 'FlourCake', 0, 0, 11.92, 'RawMaterial', 1);
END

-- Update or Insert: XFL-CMB-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFL-CMB-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Complete Mix - Brown Bread Flour',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 13.10,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFL-CMB-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFL-CMB-125', 'Complete Mix - Brown Bread Flour', 0, 0, 13.10, 'RawMaterial', 1);
END

-- Update or Insert: XFL-CMW-125
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFL-CMW-125')
BEGIN
    UPDATE Products 
    SET ProductName = 'Complete Mix - White Bread Flour',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 13.30,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFL-CMW-125';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFL-CMW-125', 'Complete Mix - White Bread Flour', 0, 0, 13.30, 'RawMaterial', 1);
END

-- Update or Insert: XFL-GSE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFL-GSE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Semolina Golden Cloud 1kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 16.87,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFL-GSE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFL-GSE-KGR', 'Semolina Golden Cloud 1kg', 0, 0, 16.87, 'RawMaterial', 1);
END

-- Update or Insert: XFL-NYA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XFL-NYA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Nyala Maize Meal 10kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 10.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XFL-NYA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XFL-NYA-KGR', 'Nyala Maize Meal 10kg', 0, 0, 10.40, 'RawMaterial', 1);
END

-- Update or Insert: XMO-BS6-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XMO-BS6-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Premix Bread S6002 5%',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 19.68,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XMO-BS6-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XMO-BS6-KGR', 'Premix Bread S6002 5%', 0, 0, 19.68, 'RawMaterial', 1);
END

-- Update or Insert: XMP -BFM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XMP -BFM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Premix Butter Flavoured Madeira 12.5kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 44.30,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XMP -BFM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XMP -BFM-KGR', 'Premix Butter Flavoured Madeira 12.5kg', 0, 0, 44.30, 'RawMaterial', 1);
END

-- Update or Insert: XMP-S60-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XMP-S60-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Premix S6002 Bread',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 12.54,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XMP-S60-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XMP-S60-KGR', 'Premix S6002 Bread', 0, 0, 12.54, 'RawMaterial', 1);
END

-- Update or Insert: XMP-SCC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XMP-SCC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sponge Chocolate Coastal',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 53.73,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XMP-SCC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XMP-SCC-KGR', 'Sponge Chocolate Coastal', 0, 0, 53.73, 'RawMaterial', 1);
END

-- Update or Insert: XMP-SRA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XMP-SRA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Soft Roll Alpaga Improver',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 187.08,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XMP-SRA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XMP-SRA-KGR', 'Soft Roll Alpaga Improver', 0, 0, 187.08, 'RawMaterial', 1);
END

-- Update or Insert: XMP-SRE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XMP-SRE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sponge Redvelvet Premix',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 49.93,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XMP-SRE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XMP-SRE-EAC', 'Sponge Redvelvet Premix', 0, 0, 49.93, 'RawMaterial', 1);
END

-- Update or Insert: XPM-5PB-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-5PB-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Premix bread 5%',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 18.70,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-5PB-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-5PB-KGR', 'Premix bread 5%', 0, 0, 18.70, 'RawMaterial', 1);
END

-- Update or Insert: XPM-AFG-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-AFG-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Apricot Flan Gel',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 49.05,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-AFG-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-AFG-KGR', 'Apricot Flan Gel', 0, 0, 49.05, 'RawMaterial', 1);
END

-- Update or Insert: XPM-CCM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-CCM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mix Chocomousse',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 87.95,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-CCM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-CCM-KGR', 'Mix Chocomousse', 0, 0, 87.95, 'RawMaterial', 1);
END

-- Update or Insert: XPM-EMC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-EMC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sponge Ebony Moist Choc Mix',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 75.26,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-EMC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-EMC-KGR', 'Sponge Ebony Moist Choc Mix', 0, 0, 75.26, 'RawMaterial', 1);
END

-- Update or Insert: XPM-FAI-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-FAI-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Premix 15% Sweet Fairglen',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 37.24,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-FAI-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-FAI-KGR', 'Premix 15% Sweet Fairglen', 0, 0, 37.24, 'RawMaterial', 1);
END

-- Update or Insert: XPM-FON-5KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-FON-5KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fond Suisse',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 50.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-FON-5KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-FON-5KG', 'Fond Suisse', 0, 0, 50.00, 'RawMaterial', 1);
END

-- Update or Insert: XPM-FRU-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-FRU-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fruit Mince',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 34.66,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-FRU-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-FRU-KGR', 'Fruit Mince', 0, 0, 34.66, 'RawMaterial', 1);
END

-- Update or Insert: XPM-HXB-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-HXB-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hot x bun full premix',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 30.47,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-HXB-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-HXB-KGR', 'Hot x bun full premix', 0, 0, 30.47, 'RawMaterial', 1);
END

-- Update or Insert: XPM-MUE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-MUE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mix Muesli Slice',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 37.19,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-MUE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-MUE-KGR', 'Mix Muesli Slice', 0, 0, 37.19, 'RawMaterial', 1);
END

-- Update or Insert: XPM-NOB-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-NOB-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'No-bake premix',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 67.39,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-NOB-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-NOB-KGR', 'No-bake premix', 0, 0, 67.39, 'RawMaterial', 1);
END

-- Update or Insert: XPM-PAS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-PAS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Paste 4.5% Standard Bread',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 14.24,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-PAS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-PAS-KGR', 'Paste 4.5% Standard Bread', 0, 0, 14.24, 'RawMaterial', 1);
END

-- Update or Insert: XPM-SCH-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-SCH-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sponge Chocolate',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 33.88,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-SCH-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-SCH-KGR', 'Sponge Chocolate', 0, 0, 33.88, 'RawMaterial', 1);
END

-- Update or Insert: XPM-SPC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-SPC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Stabiliser Pettina Cream',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 37.58,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-SPC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-SPC-KGR', 'Stabiliser Pettina Cream', 0, 0, 37.58, 'RawMaterial', 1);
END

-- Update or Insert: XPM-SPE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-SPE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sponge Eggless',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 84.28,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-SPE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-SPE-KGR', 'Sponge Eggless', 0, 0, 84.28, 'RawMaterial', 1);
END

-- Update or Insert: XPM-SPI-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-SPI-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sponge Pettina Instant',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 22.51,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-SPI-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-SPI-KGR', 'Sponge Pettina Instant', 0, 0, 22.51, 'RawMaterial', 1);
END

-- Update or Insert: XPM-SVC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-SVC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sponge Instant Coastal',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 43.75,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-SVC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-SVC-KGR', 'Sponge Instant Coastal', 0, 0, 43.75, 'RawMaterial', 1);
END

-- Update or Insert: XPM-SWE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPM-SWE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Premix 20% Sweet Red',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 33.72,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPM-SWE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPM-SWE-KGR', 'Premix 20% Sweet Red', 0, 0, 33.72, 'RawMaterial', 1);
END

-- Update or Insert: XPO-BCS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-BCS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Specialty-Chai',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-BCS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-BCS-KGR', 'Specialty-Chai', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XPO-BMS-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-BMS-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bubblegum Milkshake Syrup',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-BMS-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-BMS-LTR', 'Bubblegum Milkshake Syrup', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XPO-CMS-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-CMS-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Chocolate Milkshake Syrup',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-CMS-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-CMS-LTR', 'Chocolate Milkshake Syrup', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XPO-LMS-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-LMS-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Lime Milkshake Syrup',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-LMS-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-LMS-LTR', 'Lime Milkshake Syrup', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XPO-MHS-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-MHS-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Monin Hazelnut Syrup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-MHS-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-MHS-LTR', 'Monin Hazelnut Syrup', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XPO-MVS-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-MVS-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Monin Vanilla Syrup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-MVS-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-MVS-LTR', 'Monin Vanilla Syrup', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XPO-SCF-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-SCF-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Specialty - Coffee Freezo',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-SCF-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-SCF-KGR', 'Specialty - Coffee Freezo', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XPO-SCM-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-SCM-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Salted Caramel Milkshake Syrup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-SCM-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-SCM-LTR', 'Salted Caramel Milkshake Syrup', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XPO-SIC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-SIC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Specialty -Indonesian Coffee',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-SIC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-SIC-KGR', 'Specialty -Indonesian Coffee', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XPO-SMC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-SMC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Monin Caramel Sauce',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-SMC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-SMC-EAC', 'Monin Caramel Sauce', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XPO-SMC-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-SMC-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Monin Caramel Syrup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-SMC-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-SMC-LTR', 'Monin Caramel Syrup', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XPO-SMS-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XPO-SMS-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Strawberry Milkshake Syrup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XPO-SMS-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XPO-SMS-LTR', 'Strawberry Milkshake Syrup', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XSN-ANI-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSN-ANI-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Aniseed',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 103.87,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSN-ANI-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSN-ANI-KGR', 'Aniseed', 0, 0, 103.87, 'RawMaterial', 1);
END

-- Update or Insert: XSN-FLA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSN-FLA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Flaked Almonds 1Kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 176.32,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSN-FLA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSN-FLA-KGR', 'Flaked Almonds 1Kg', 0, 0, 176.32, 'RawMaterial', 1);
END

-- Update or Insert: XSN-NUT-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSN-NUT-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Nuts Nibb',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 46.60,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSN-NUT-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSN-NUT-KGR', 'Nuts Nibb', 0, 0, 46.60, 'RawMaterial', 1);
END

-- Update or Insert: XSN-PEH-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSN-PEH-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pecan Nut Halves',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 110.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSN-PEH-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSN-PEH-KGR', 'Pecan Nut Halves', 0, 0, 110.00, 'RawMaterial', 1);
END

-- Update or Insert: XSN-SDP-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSN-SDP-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'seed poppy',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 159.79,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSN-SDP-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSN-SDP-KGR', 'seed poppy', 0, 0, 159.79, 'RawMaterial', 1);
END

-- Update or Insert: XSN-SES-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSN-SES-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sesame Seed',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 79.05,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSN-SES-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSN-SES-KGR', 'Sesame Seed', 0, 0, 79.05, 'RawMaterial', 1);
END

-- Update or Insert: XSN-SJEE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSN-SJEE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice Jeera Whole',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 87.79,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSN-SJEE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSN-SJEE-KGR', 'Spice Jeera Whole', 0, 0, 87.79, 'RawMaterial', 1);
END

-- Update or Insert: XSN-SMI-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSN-SMI-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice Mixed Herbs',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 135.61,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSN-SMI-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSN-SMI-KGR', 'Spice Mixed Herbs', 0, 0, 135.61, 'RawMaterial', 1);
END

-- Update or Insert: XSN-SOR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSN-SOR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice Origanum',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 156.52,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSN-SOR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSN-SOR-KGR', 'Spice Origanum', 0, 0, 156.52, 'RawMaterial', 1);
END

-- Update or Insert: XSN-WHS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSN-WHS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Whole Somph',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSN-WHS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSN-WHS-KGR', 'Whole Somph', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XSP- DHA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSP- DHA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice- Dhania',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSP- DHA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSP- DHA-EAC', 'Spice- Dhania', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XSP-ALG-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSP-ALG-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ground Almonds',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 170.41,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSP-ALG-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSP-ALG-KGR', 'Ground Almonds', 0, 0, 170.41, 'RawMaterial', 1);
END

-- Update or Insert: XSP-BAK-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSP-BAK-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Baking Powder (Hercules)',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 50.65,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSP-BAK-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSP-BAK-KGR', 'Baking Powder (Hercules)', 0, 0, 50.65, 'RawMaterial', 1);
END

-- Update or Insert: XSP-BIC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSP-BIC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bicarbonate Soda',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 20.34,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSP-BIC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSP-BIC-KGR', 'Bicarbonate Soda', 0, 0, 20.34, 'RawMaterial', 1);
END

-- Update or Insert: XSP-CIN-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSP-CIN-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cinnamon Ground',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 72.18,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSP-CIN-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSP-CIN-KGR', 'Cinnamon Ground', 0, 0, 72.18, 'RawMaterial', 1);
END

-- Update or Insert: XSP-COR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSP-COR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'CornFlour',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 21.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSP-COR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSP-COR-KGR', 'CornFlour', 0, 0, 21.29, 'RawMaterial', 1);
END

-- Update or Insert: XSP-SAL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSP-SAL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Salt Bale',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 4.41,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSP-SAL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSP-SAL-EAC', 'Salt Bale', 0, 0, 4.41, 'RawMaterial', 1);
END

-- Update or Insert: XSP-SBN-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSP-SBN-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice Bunspice',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSP-SBN-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSP-SBN-KGR', 'Spice Bunspice', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XSP-SNU-800G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSP-SNU-800G')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spice Nutmeg Ground 800g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 440.24,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSP-SNU-800G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSP-SNU-800G', 'Spice Nutmeg Ground 800g', 0, 0, 440.24, 'RawMaterial', 1);
END

-- Update or Insert: XSP-WNM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSP-WNM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Whole Nutmeg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 169.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSP-WNM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSP-WNM-KGR', 'Whole Nutmeg', 0, 0, 169.29, 'RawMaterial', 1);
END

-- Update or Insert: XSU-ESS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSU-ESS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Equisweet Sucralose Sachets',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 186.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSU-ESS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSU-ESS-KGR', 'Equisweet Sucralose Sachets', 0, 0, 186.40, 'RawMaterial', 1);
END

-- Update or Insert: XSU-HIS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSU-HIS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Huletts Icing Sugar',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSU-HIS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSU-HIS-KGR', 'Huletts Icing Sugar', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XSU-IBS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSU-IBS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hullets Brown Sugar Tubes',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 35.60,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSU-IBS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSU-IBS-KGR', 'Hullets Brown Sugar Tubes', 0, 0, 35.60, 'RawMaterial', 1);
END

-- Update or Insert: XSU-IWS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSU-IWS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Huletts White Sugar Tubes',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 35.60,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSU-IWS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSU-IWS-KGR', 'Huletts White Sugar Tubes', 0, 0, 35.60, 'RawMaterial', 1);
END

-- Update or Insert: XSU-SBN-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSU-SBN-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sugar Brown',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 11.58,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSU-SBN-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSU-SBN-KGR', 'Sugar Brown', 0, 0, 11.58, 'RawMaterial', 1);
END

-- Update or Insert: XSU-SCH-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSU-SCH-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sugar Castor Huletts',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 24.39,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSU-SCH-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSU-SCH-KGR', 'Sugar Castor Huletts', 0, 0, 24.39, 'RawMaterial', 1);
END

-- Update or Insert: XSU-SIC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSU-SIC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sugar Icing Huletts',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 22.81,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSU-SIC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSU-SIC-KGR', 'Sugar Icing Huletts', 0, 0, 22.81, 'RawMaterial', 1);
END

-- Update or Insert: XSU-SWH-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XSU-SWH-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sugar White Huletts',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 16.09,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XSU-SWH-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XSU-SWH-KGR', 'Sugar White Huletts', 0, 0, 16.09, 'RawMaterial', 1);
END

-- Update or Insert: XTO - PIR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO - PIR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pineapple Rings 440g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO - PIR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO - PIR-KGR', 'Pineapple Rings 440g', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO- ESG-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO- ESG-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Espresso Grind Slojo Spiced Chai',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO- ESG-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO- ESG-KGR', 'Espresso Grind Slojo Spiced Chai', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO- GRT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO- GRT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Green Tea',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO- GRT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO- GRT-EAC', 'Green Tea', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO- VIC-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO- VIC-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gatti Vanilla Ice Cream',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO- VIC-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO- VIC-LTR', 'Gatti Vanilla Ice Cream', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-AJM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-AJM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jam Apricot (All Gold)',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 36.47,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-AJM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-AJM-KGR', 'Jam Apricot (All Gold)', 0, 0, 36.47, 'RawMaterial', 1);
END

-- Update or Insert: XTO-ALE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-ALE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Almond Essence',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-ALE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-ALE-KGR', 'Almond Essence', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-ALM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-ALM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Almond Icing',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 29.67,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-ALM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-ALM-KGR', 'Almond Icing', 0, 0, 29.67, 'RawMaterial', 1);
END

-- Update or Insert: XTO-ASA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-ASA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ayesha Samoosa Strips',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-ASA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-ASA-KGR', 'Ayesha Samoosa Strips', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-BAR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-BAR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bar One Spread',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 110.68,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-BAR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-BAR-KGR', 'Bar One Spread', 0, 0, 110.68, 'RawMaterial', 1);
END

-- Update or Insert: XTO-BOO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-BOO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Biscuit Original Oreo',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'XTO-BOO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-BOO-EAC', 'Biscuit Original Oreo', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: XTO-CCL-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-CCL-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Officemate Creamy Chai Latte',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 134.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-CCL-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-CCL-KGR', 'Officemate Creamy Chai Latte', 0, 0, 134.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-CFU-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-CFU-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cereal Choc Future Life 1.25kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 89.27,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-CFU-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-CFU-KGR', 'Cereal Choc Future Life 1.25kg', 0, 0, 89.27, 'RawMaterial', 1);
END

-- Update or Insert: XTO-CHE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-CHE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Filling Black Forest Pie Filling',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 79.15,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-CHE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-CHE-KGR', 'Pie Filling Black Forest Pie Filling', 0, 0, 79.15, 'RawMaterial', 1);
END

-- Update or Insert: XTO-CHI-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-CHI-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sauce Chilli 2lt',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.57,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-CHI-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-CHI-LTR', 'Sauce Chilli 2lt', 0, 0, 0.57, 'RawMaterial', 1);
END

-- Update or Insert: XTO-COB-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-COB-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coffee Beans',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 270.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-COB-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-COB-KGR', 'Coffee Beans', 0, 0, 270.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-CTS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-CTS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Carte D Toffee Sauce',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 66.49,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-CTS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-CTS-EAC', 'Carte D Toffee Sauce', 0, 0, 66.49, 'RawMaterial', 1);
END

-- Update or Insert: XTO-DHC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-DHC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Officemate Dark Hot Choc',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 94.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-DHC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-DHC-KGR', 'Officemate Dark Hot Choc', 0, 0, 94.50, 'RawMaterial', 1);
END

-- Update or Insert: XTO-GAR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-GAR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spread Garlic & Herb',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 58.80,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-GAR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-GAR-KGR', 'Spread Garlic & Herb', 0, 0, 58.80, 'RawMaterial', 1);
END

-- Update or Insert: XTO-GRA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-GRA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Filling Granadilla',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 39.58,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-GRA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-GRA-KGR', 'Pie Filling Granadilla', 0, 0, 39.58, 'RawMaterial', 1);
END

-- Update or Insert: XTO-GSP-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-GSP-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Golden Syrup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 38.11,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-GSP-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-GSP-KGR', 'Golden Syrup', 0, 0, 38.11, 'RawMaterial', 1);
END

-- Update or Insert: XTO-HAS-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-HAS-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spread Hazelnut 5kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-HAS-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-HAS-KGR', 'Spread Hazelnut 5kg', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-HCC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-HCC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hot Chocolate Coffee Merchant',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 120.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-HCC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-HCC-KGR', 'Hot Chocolate Coffee Merchant', 0, 0, 120.50, 'RawMaterial', 1);
END

-- Update or Insert: XTO-HPM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-HPM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Carte D Hot Pudding Mix',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 103.43,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-HPM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-HPM-EAC', 'Carte D Hot Pudding Mix', 0, 0, 103.43, 'RawMaterial', 1);
END

-- Update or Insert: XTO-HZL-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-HZL-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hazelnut Praline',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 112.26,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-HZL-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-HZL-KGR', 'Hazelnut Praline', 0, 0, 112.26, 'RawMaterial', 1);
END

-- Update or Insert: XTO-ICE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-ICE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ice',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-ICE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-ICE-KGR', 'Ice', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-ICK-5KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-ICK-5KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Instant Custard Kramess',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 72.58,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-ICK-5KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-ICK-5KG', 'Instant Custard Kramess', 0, 0, 72.58, 'RawMaterial', 1);
END

-- Update or Insert: XTO-JEL-KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-JEL-KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Assorted Jelly',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-JEL-KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-JEL-KG', 'Assorted Jelly', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-KBO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-KBO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Knorr Brown Onion Soup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 152.21,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-KBO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-KBO-EAC', 'Knorr Brown Onion Soup', 0, 0, 152.21, 'RawMaterial', 1);
END

-- Update or Insert: XTO-KCM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-KCM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Knorr Creamy Mushroom Sauce',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 4.63,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-KCM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-KCM-EAC', 'Knorr Creamy Mushroom Sauce', 0, 0, 4.63, 'RawMaterial', 1);
END

-- Update or Insert: XTO-KCS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-KCS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Knorr Cream of Chicken Soup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 4.63,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-KCS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-KCS-EAC', 'Knorr Cream of Chicken Soup', 0, 0, 4.63, 'RawMaterial', 1);
END

-- Update or Insert: XTO-KLI-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-KLI-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Klim 500g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 72.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-KLI-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-KLI-KGR', 'Klim 500g', 0, 0, 72.50, 'RawMaterial', 1);
END

-- Update or Insert: XTO-LEC-5KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-LEC-5KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dip Leamington Chocolate',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-LEC-5KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-LEC-5KG', 'Dip Leamington Chocolate', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-LER-5KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-LER-5KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dip Leamington Raspberry',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-LER-5KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-LER-5KG', 'Dip Leamington Raspberry', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-MAY-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-MAY-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mayonnaise Cross & Blackwell 3kg',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-MAY-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-MAY-KGR', 'Mayonnaise Cross & Blackwell 3kg', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-MBD-500ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-MBD-500ML')
BEGIN
    UPDATE Products 
    SET ProductName = 'Milky Bar Dessert Topping',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 193.06,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-MBD-500ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-MBD-500ML', 'Milky Bar Dessert Topping', 0, 0, 193.06, 'RawMaterial', 1);
END

-- Update or Insert: XTO-MHC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-MHC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Officemate Milky Hot Choc',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 109.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-MHC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-MHC-KGR', 'Officemate Milky Hot Choc', 0, 0, 109.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-MUS-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-MUS-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mustard Sauce',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-MUS-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-MUS-LTR', 'Mustard Sauce', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-NUT-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-NUT-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Nutella 3kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-NUT-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-NUT-KGR', 'Nutella 3kg', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-OAT-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-OAT-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fine Oats 25 kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 14.14,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-OAT-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-OAT-KGR', 'Fine Oats 25 kg', 0, 0, 14.14, 'RawMaterial', 1);
END

-- Update or Insert: XTO-PCH-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-PCH-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Paste Chocolate',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 77.59,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-PCH-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-PCH-KGR', 'Paste Chocolate', 0, 0, 77.59, 'RawMaterial', 1);
END

-- Update or Insert: XTO-PDA-KG
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-PDA-KG')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pitted Dates',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 45.21,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-PDA-KG';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-PDA-KG', 'Pitted Dates', 0, 0, 45.21, 'RawMaterial', 1);
END

-- Update or Insert: XTO-PEP-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-PEP-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Nestle Peppermint Topping',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-PEP-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-PEP-KGR', 'Nestle Peppermint Topping', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-PIN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-PIN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pineapple crushed',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 30.88,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-PIN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-PIN-EAC', 'Pineapple crushed', 0, 0, 30.88, 'RawMaterial', 1);
END

-- Update or Insert: XTO-PLI-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-PLI-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Icing plastic',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 28.83,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-PLI-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-PLI-KGR', 'Icing plastic', 0, 0, 28.83, 'RawMaterial', 1);
END

-- Update or Insert: XTO-RIC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-RIC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Aunt Caroline Rice',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 13.50,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-RIC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-RIC-KGR', 'Aunt Caroline Rice', 0, 0, 13.50, 'RawMaterial', 1);
END

-- Update or Insert: XTO-SAJ-900G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-SAJ-900G')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jam Strawberry All Gold 900g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 65.33,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-SAJ-900G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-SAJ-900G', 'Jam Strawberry All Gold 900g', 0, 0, 65.33, 'RawMaterial', 1);
END

-- Update or Insert: XTO-SBJ-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-SBJ-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jam Strawberry (All Gold)',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 50.46,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-SBJ-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-SBJ-KGR', 'Jam Strawberry (All Gold)', 0, 0, 50.46, 'RawMaterial', 1);
END

-- Update or Insert: XTO-SBO-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-SBO-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spread Bar One Nestle',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 96.83,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-SBO-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-SBO-KGR', 'Spread Bar One Nestle', 0, 0, 96.83, 'RawMaterial', 1);
END

-- Update or Insert: XTO-SCA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-SCA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spread caramel',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 64.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-SCA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-SCA-KGR', 'Spread caramel', 0, 0, 64.17, 'RawMaterial', 1);
END

-- Update or Insert: XTO-SCF-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-SCF-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coffee Freezo Slojo',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 230.40,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-SCF-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-SCF-KGR', 'Coffee Freezo Slojo', 0, 0, 230.40, 'RawMaterial', 1);
END

-- Update or Insert: XTO-SHC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-SHC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Specialty Hot Chocolate',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-SHC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-SHC-KGR', 'Specialty Hot Chocolate', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-SHW-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-SHW-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Specialty White Hot Chocolate',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 212.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-SHW-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-SHW-KGR', 'Specialty White Hot Chocolate', 0, 0, 212.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-SPE-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-SPE-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Spread Peanut Butter 3kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 115.02,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-SPE-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-SPE-KGR', 'Spread Peanut Butter 3kg', 0, 0, 115.02, 'RawMaterial', 1);
END

-- Update or Insert: XTO-STR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-STR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pie Filling Strawberry',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 17.23,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-STR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-STR-KGR', 'Pie Filling Strawberry', 0, 0, 17.23, 'RawMaterial', 1);
END

-- Update or Insert: XTO-TMR-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-TMR-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Taj Mahal Rice 10KG',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-TMR-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-TMR-KGR', 'Taj Mahal Rice 10KG', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: XTO-TOM-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-TOM-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tomatoe Sauce',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 21.08,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-TOM-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-TOM-LTR', 'Tomatoe Sauce', 0, 0, 21.08, 'RawMaterial', 1);
END

-- Update or Insert: XTO-VIN-LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'XTO-VIN-LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Vinegar',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 4.93,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'XTO-VIN-LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('XTO-VIN-LT', 'Vinegar', 0, 0, 4.93, 'RawMaterial', 1);
END

-- Update or Insert: YBA-BOO-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-BOO-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter - Bar One Sponge Round',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-BOO-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-BOO-MX1', 'Sub Batter - Bar One Sponge Round', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-BSC-MXI
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-BSC-MXI')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter- Butter Scones',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-BSC-MXI';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-BSC-MXI', 'Sub Batter- Butter Scones', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-CAC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-CAC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter Carrot Cake',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-CAC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-CAC-MX1', 'Sub Batter Carrot Cake', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-CCC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-CCC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter-Carrot Cake with Cream Cheese Slab',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-CCC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-CCC-MX1', 'Sub Batter-Carrot Cake with Cream Cheese Slab', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-CGS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-CGS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter- Chocolate Gateaux Sponge',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-CGS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-CGS-MX1', 'Sub Batter- Chocolate Gateaux Sponge', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-CHC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-CHC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter-Chocolate Brownie',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-CHC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-CHC-MX1', 'Sub Batter-Chocolate Brownie', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-CHO-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-CHO-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Sponge Batter -Chocolate',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-CHO-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-CHO-MX1', 'Sub Sponge Batter -Chocolate', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-CHS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-CHS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter-Chocolate Sponge Sheet',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-CHS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-CHS-MX1', 'Sub Batter-Chocolate Sponge Sheet', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-CSP-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-CSP-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter- Choc Swissroll Sponge',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-CSP-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-CSP-MX1', 'Sub Batter- Choc Swissroll Sponge', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-CSS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-CSS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter - choc sheet scratch mix',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-CSS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-CSS-MX1', 'Sub Batter - choc sheet scratch mix', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-DEG-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-DEG-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter Eggless Diwali Cake',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-DEG-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-DEG-MX1', 'Sub Batter Eggless Diwali Cake', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-DIS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-DIS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter Diwali Sponge',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-DIS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-DIS-MX1', 'Sub Batter Diwali Sponge', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-DIV-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-DIV-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Sponge Batter Diwali',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-DIV-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-DIV-MX1', 'Sub Sponge Batter Diwali', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-EFS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-EFS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter -Eggfree Sponge sheet',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-EFS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-EFS-MX1', 'Sub Batter -Eggfree Sponge sheet', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-EGS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-EGS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter Eggless Gateaux Sponge',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-EGS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-EGS-MX1', 'Sub Batter Eggless Gateaux Sponge', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-ESN-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-ESN-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter Snowball Eggles',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-ESN-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-ESN-MX1', 'Sub Batter Snowball Eggles', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-FRS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-FRS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter- Fruit Scones',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-FRS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-FRS-MX1', 'Sub Batter- Fruit Scones', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-HCB-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-HCB-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough- Hot Cross Buns',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-HCB-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-HCB-MX1', 'Sub Dough- Hot Cross Buns', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-HCC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-HCC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter Cross for Hot Cross Buns',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-HCC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-HCC-MX1', 'Sub Batter Cross for Hot Cross Buns', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-MAD-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-MAD-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter - Madeira Slab',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-MAD-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-MAD-MX1', 'Sub Batter - Madeira Slab', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-MCC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-MCC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Sponge Batter- Moist Choc Sponge C/C',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-MCC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-MCC-MX1', 'Sub Sponge Batter- Moist Choc Sponge C/C', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-QUC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-QUC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter -Queen Cake',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-QUC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-QUC-MX1', 'Sub Batter -Queen Cake', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-RBS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-RBS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter Rainbow Sponge',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-RBS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-RBS-MX1', 'Sub Batter Rainbow Sponge', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-RCS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-RCS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter Rich Choc Sponge',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-RCS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-RCS-MX1', 'Sub Batter Rich Choc Sponge', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-ROT-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-ROT-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough Roti 12s',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-ROT-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-ROT-MX1', 'Sub Dough Roti 12s', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-SCO-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-SCO-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter - Scones',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-SCO-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-SCO-MX1', 'Sub Batter - Scones', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-SMC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-SMC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Sponge Batter - Moist Choc Sponge Fererro',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-SMC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-SMC-MX1', 'Sub Sponge Batter - Moist Choc Sponge Fererro', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-SNB-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-SNB-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter -Snowball',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-SNB-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-SNB-MX1', 'Sub Batter -Snowball', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-SPO-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-SPO-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter - Strawberry Sponge',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-SPO-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-SPO-MX1', 'Sub Batter - Strawberry Sponge', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-VAN-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-VAN-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Sponge Batter - Vanilla Gateaux',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-VAN-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-VAN-MX1', 'Sub Sponge Batter - Vanilla Gateaux', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-VNS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-VNS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter Vanilla Sheets Coastal',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-VNS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-VNS-MX1', 'Sub Batter Vanilla Sheets Coastal', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-VSR-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-VSR-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter- Vanilla Swissroll Sponge',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-VSR-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-VSR-MX1', 'Sub Batter- Vanilla Swissroll Sponge', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBA-WNS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBA-WNS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter- Windsor Slab',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBA-WNS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBA-WNS-MX1', 'Sub Batter- Windsor Slab', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBU -CTR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBU -CTR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cake ring tins 170X70mm',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 77.70,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YBU -CTR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBU -CTR-EAC', 'Cake ring tins 170X70mm', 0, 0, 77.70, 'external', 1);
END

-- Update or Insert: YBU-CRE-MX6
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBU-CRE-MX6')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Buns-Cream 6s',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YBU-CRE-MX6';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBU-CRE-MX6', 'Sub Buns-Cream 6s', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YBU-JUG-2LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBU-JUG-2LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jug Plastic 2 litre',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YBU-JUG-2LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBU-JUG-2LT', 'Jug Plastic 2 litre', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YBU-JUG-5LT
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBU-JUG-5LT')
BEGIN
    UPDATE Products 
    SET ProductName = 'Jug Plastic 5 litre',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YBU-JUG-5LT';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBU-JUG-5LT', 'Jug Plastic 5 litre', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YBU-OVM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBU-OVM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Oven Mittens',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 80.50,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YBU-OVM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBU-OVM-EAC', 'Oven Mittens', 0, 0, 80.50, 'external', 1);
END

-- Update or Insert: YBU-PAL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBU-PAL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Palette Knife',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YBU-PAL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBU-PAL-EAC', 'Palette Knife', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YBU-PBR-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBU-PBR-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pastry Brush Nylon 60mm',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YBU-PBR-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBU-PBR-EACH', 'Pastry Brush Nylon 60mm', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YBU-SBP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBU-SBP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sponge for bread pan',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 29.17,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YBU-SBP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBU-SBP-EAC', 'Sponge for bread pan', 0, 0, 29.17, 'external', 1);
END

-- Update or Insert: YBU-SPR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBU-SPR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Springform Cake Pan',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 57.94,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YBU-SPR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBU-SPR-EAC', 'Springform Cake Pan', 0, 0, 57.94, 'external', 1);
END

-- Update or Insert: YBU-SSC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YBU-SSC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Scraper Steel 115x80mm',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 46.55,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YBU-SSC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YBU-SSC-EAC', 'Scraper Steel 115x80mm', 0, 0, 46.55, 'external', 1);
END

-- Update or Insert: YCC-14C-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-14C-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Case No 14 Cake',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.13,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-14C-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-14C-EAC', 'Case No 14 Cake', 0, 0, 0.13, 'RawMaterial', 1);
END

-- Update or Insert: YCC-24E-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-24E-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Madeira case 24e',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.39,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-24E-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-24E-EAC', 'Madeira case 24e', 0, 0, 0.39, 'RawMaterial', 1);
END

-- Update or Insert: YCC-APR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-APR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'White Plastic Aprons',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.50,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-APR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-APR-EAC', 'White Plastic Aprons', 0, 0, 0.50, 'external', 1);
END

-- Update or Insert: YCC-BLA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-BLA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel super black',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 6.83,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-BLA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-BLA-EAC', 'Gel super black', 0, 0, 6.83, 'RawMaterial', 1);
END

-- Update or Insert: YCC-BRA-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-BRA-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Brandy',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-BRA-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-BRA-KGR', 'Brandy', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-BUN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-BUN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Paper 10kg Bunny',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 82.17,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-BUN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-BUN-EAC', 'Paper 10kg Bunny', 0, 0, 82.17, 'external', 1);
END

-- Update or Insert: YCC-BUR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-BUR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Burgundy',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 83.90,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-BUR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-BUR-EAC', 'Gel Burgundy', 0, 0, 83.90, 'RawMaterial', 1);
END

-- Update or Insert: YCC-CHA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-CHA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Champagne Bottle',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-CHA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-CHA-EAC', 'Champagne Bottle', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-CRC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-CRC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Cream Cheese',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-CRC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-CRC-MX1', 'Sub Cream Cheese', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-CRG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-CRG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cream Gun 500g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-CRG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-CRG-EAC', 'Cream Gun 500g', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCC-CSC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-CSC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Coffee Scale',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-CSC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-CSC-EAC', 'Coffee Scale', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-CUP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-CUP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Red Cupcakes Cup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.14,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-CUP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-CUP-EAC', 'Red Cupcakes Cup', 0, 0, 0.14, 'RawMaterial', 1);
END

-- Update or Insert: YCC-DEP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-DEP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Food Deep Pink',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-DEP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-DEP-EAC', 'Gel Food Deep Pink', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-EDI-005
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-EDI-005')
BEGIN
    UPDATE Products 
    SET ProductName = 'Canon Edible Ink set 5s 480/1',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-EDI-005';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-EDI-005', 'Canon Edible Ink set 5s 480/1', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-ELE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-ELE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Electric Green Gel',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-ELE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-ELE-EAC', 'Electric Green Gel', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-EOR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-EOR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Col. Elec Orange',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 82.29,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-EOR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-EOR-EAC', 'Gel Col. Elec Orange', 0, 0, 82.29, 'RawMaterial', 1);
END

-- Update or Insert: YCC-ESL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-ESL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Electronic Scale',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-ESL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-ESL-EAC', 'Electronic Scale', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-GEL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-GEL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel liquid gold /silver/ pearl',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-GEL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-GEL-EAC', 'Gel liquid gold /silver/ pearl', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-GEP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-GEP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Food Col.Elec Purple',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 77.63,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-GEP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-GEP-EAC', 'Gel Food Col.Elec Purple', 0, 0, 77.63, 'RawMaterial', 1);
END

-- Update or Insert: YCC-GLG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-GLG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Food Col.Leaf Green',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 78.73,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-GLG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-GLG-EAC', 'Gel Food Col.Leaf Green', 0, 0, 78.73, 'external', 1);
END

-- Update or Insert: YCC-GLY-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-GLY-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Food Col. Lemon Yellow',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 76.15,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-GLY-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-GLY-EAC', 'Gel Food Col. Lemon Yellow', 0, 0, 76.15, 'RawMaterial', 1);
END

-- Update or Insert: YCC-GLY-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-GLY-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Glycerine',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-GLY-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-GLY-KGR', 'Glycerine', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-GOM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-GOM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'GlovesOven Mittens',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 98.79,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-GOM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-GOM-EAC', 'GlovesOven Mittens', 0, 0, 98.79, 'external', 1);
END

-- Update or Insert: YCC-GPP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-GPP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Grease Proof Paper',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 82.70,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-GPP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-GPP-EAC', 'Grease Proof Paper', 0, 0, 82.70, 'external', 1);
END

-- Update or Insert: YCC-GPR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-GPR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'GP REAM',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 93.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-GPR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-GPR-EAC', 'GP REAM', 0, 0, 93.00, 'external', 1);
END

-- Update or Insert: YCC-GSB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-GSB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Food ColSky Blue',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 77.60,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-GSB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-GSB-EAC', 'Gel Food ColSky Blue', 0, 0, 77.60, 'RawMaterial', 1);
END

-- Update or Insert: YCC-ICS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-ICS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Icing Sheet A4 New',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-ICS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-ICS-EAC', 'Icing Sheet A4 New', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-ISH-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-ISH-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Icing Sheet A4 Borderless',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 14.72,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-ISH-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-ISH-EAC', 'Icing Sheet A4 Borderless', 0, 0, 14.72, 'RawMaterial', 1);
END

-- Update or Insert: YCC-LEA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-LEA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Leaves No.Large',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.05,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-LEA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-LEA-EAC', 'Leaves No.Large', 0, 0, 1.05, 'RawMaterial', 1);
END

-- Update or Insert: YCC-LES-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-LES-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Lemon Essense',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-LES-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-LES-LTR', 'Lemon Essense', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-MET-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-MET-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'metallic nozzil 15mm star',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-MET-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-MET-EAC', 'metallic nozzil 15mm star', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCC-MGS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-MGS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Ed Cart Canon Mg Series',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-MGS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-MGS-EAC', 'Ed Cart Canon Mg Series', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: YCC-MIS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-MIS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mistletoe Garland ribbon',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-MIS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-MIS-EAC', 'Mistletoe Garland ribbon', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-MMC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-MMC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'RICH MOIST XMAS CAKE',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'YCC-MMC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-MMC-EAC', 'RICH MOIST XMAS CAKE', 0, 0, 0.00, 'internal', 1);
END

-- Update or Insert: YCC-MOH-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-MOH-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mop Hats',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.29,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-MOH-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-MOH-EAC', 'Mop Hats', 0, 0, 0.29, 'external', 1);
END

-- Update or Insert: YCC-MXR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-MXR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Merry xmas ribbon',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-MXR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-MXR-EAC', 'Merry xmas ribbon', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: YCC-NME-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-NME-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Nozzels metallic',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 45.26,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-NME-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-NME-EAC', 'Nozzels metallic', 0, 0, 45.26, 'external', 1);
END

-- Update or Insert: YCC-NST-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-NST-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Nozzles star tubes 5s ( 42)',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-NST-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-NST-EAC', 'Nozzles star tubes 5s ( 42)', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCC-OCC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-OCC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Old Cakes Currant Square',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-OCC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-OCC-KGR', 'Old Cakes Currant Square', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-PAS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-PAS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pastry Bag 13040 4 46cm',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-PAS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-PAS-EAC', 'Pastry Bag 13040 4 46cm', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCC-PIL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-PIL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pillars White',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-PIL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-PIL-EAC', 'Pillars White', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-PIN-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-PIN-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pink Gel',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-PIN-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-PIN-EAC', 'Pink Gel', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-PIP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-PIP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Piping Bags No 4',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 94.46,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-PIP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-PIP-EAC', 'Piping Bags No 4', 0, 0, 94.46, 'external', 1);
END

-- Update or Insert: YCC-PLG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-PLG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Plastic Gloves',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.09,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-PLG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-PLG-EAC', 'Plastic Gloves', 0, 0, 0.09, 'external', 1);
END

-- Update or Insert: YCC-POT-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-POT-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Potassium Sorbate Granular',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 59.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-POT-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-POT-KGR', 'Potassium Sorbate Granular', 0, 0, 59.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-PSR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-PSR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Paper Silicone Ream',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.99,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-PSR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-PSR-EAC', 'Paper Silicone Ream', 0, 0, 0.99, 'external', 1);
END

-- Update or Insert: YCC-PSS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-PSS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Piping Tip Star Set',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-PSS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-PSS-EAC', 'Piping Tip Star Set', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCC-PST-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-PST-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pastry Bag 13040 5 50cm Export',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-PST-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-PST-EAC', 'Pastry Bag 13040 5 50cm Export', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCC-PUR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-PUR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Food Colouring Purple',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 82.61,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-PUR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-PUR-EAC', 'Gel Food Colouring Purple', 0, 0, 82.61, 'RawMaterial', 1);
END

-- Update or Insert: YCC-ROB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-ROB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Food Royal Blue',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-ROB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-ROB-EAC', 'Gel Food Royal Blue', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-SHB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-SHB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Smartchef Heavy Duty Blender',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2645.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-SHB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-SHB-EAC', 'Smartchef Heavy Duty Blender', 0, 0, 2645.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-SIL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-SIL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Silicon Paper 500',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.07,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-SIL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-SIL-EAC', 'Silicon Paper 500', 0, 0, 1.07, 'external', 1);
END

-- Update or Insert: YCC-SOS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-SOS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Soccer Set',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 20.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-SOS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-SOS-EAC', 'Soccer Set', 0, 0, 20.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-SRD-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-SRD-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Col.Super Red',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 83.49,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-SRD-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-SRD-EAC', 'Gel Col.Super Red', 0, 0, 83.49, 'RawMaterial', 1);
END

-- Update or Insert: YCC-SUP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-SUP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Super Red',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 75.49,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-SUP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-SUP-EAC', 'Gel Super Red', 0, 0, 75.49, 'RawMaterial', 1);
END

-- Update or Insert: YCC-TEA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-TEA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gel Teal',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 23.43,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-TEA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-TEA-EAC', 'Gel Teal', 0, 0, 23.43, 'RawMaterial', 1);
END

-- Update or Insert: YCC-THF-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-THF-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Thickflo 25kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-THF-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-THF-KGR', 'Thickflo 25kg', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-VIT-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-VIT-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Vitap Starch 25kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-VIT-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-VIT-KGR', 'Vitap Starch 25kg', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-XPS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-XPS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Xmas Poinsettia Star Ribbon',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCC-XPS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-XPS-EAC', 'Xmas Poinsettia Star Ribbon', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCC-XSS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCC-XSS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Xmas stickers scroll',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCC-XSS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCC-XSS-EAC', 'Xmas stickers scroll', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCK-BAN-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCK-BAN-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub-Banana Cake',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCK-BAN-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCK-BAN-MX1', 'Sub-Banana Cake', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCK-FRC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCK-FRC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter Christmas Windsor Plain',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCK-FRC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCK-FRC-MX1', 'Sub Batter Christmas Windsor Plain', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YCL-BAG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-BAG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bag Black Refuse HD',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.77,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCL-BAG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-BAG-EAC', 'Bag Black Refuse HD', 0, 0, 0.77, 'RawMaterial', 1);
END

-- Update or Insert: YCL-BLD-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-BLD-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Black Dip',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 22.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-BLD-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-BLD-LTR', 'Black Dip', 0, 0, 22.00, 'external', 1);
END

-- Update or Insert: YCL-BLE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-BLE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Bleach 5L',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 6.33,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-BLE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-BLE-EAC', 'Bleach 5L', 0, 0, 6.33, 'external', 1);
END

-- Update or Insert: YCL-BRE-250G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-BRE-250G')
BEGIN
    UPDATE Products 
    SET ProductName = 'Detergent Brewtool 250G',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-BRE-250G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-BRE-250G', 'Detergent Brewtool 250G', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: YCL-CEM-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-CEM-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Clenzo Espresso Cleaning Detergent',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-CEM-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-CEM-KGR', 'Clenzo Espresso Cleaning Detergent', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: YCL-DIS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-DIS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Dish Washing Liquid 25L',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-DIS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-DIS-EAC', 'Dish Washing Liquid 25L', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: YCL-DOO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-DOO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Doom',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-DOO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-DOO-EAC', 'Doom', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: YCL-EMP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-EMP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Empty Boxes',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 22.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCL-EMP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-EMP-EAC', 'Empty Boxes', 0, 0, 22.00, 'RawMaterial', 1);
END

-- Update or Insert: YCL-FAS-LTR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-FAS-LTR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fat Solves',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-FAS-LTR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-FAS-LTR', 'Fat Solves', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCL-FLO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-FLO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Floor Cleaner Lav',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 7.30,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-FLO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-FLO-EAC', 'Floor Cleaner Lav', 0, 0, 7.30, 'external', 1);
END

-- Update or Insert: YCL-HHG-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-HHG-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Household Gloves',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-HHG-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-HHG-EAC', 'Household Gloves', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCL-HHH-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-HHH-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Handy Household 5l',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 6.18,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-HHH-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-HHH-EAC', 'Handy Household 5l', 0, 0, 6.18, 'external', 1);
END

-- Update or Insert: YCL-MRM-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-MRM-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Mr min',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-MRM-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-MRM-EAC', 'Mr min', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCL-OVC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-OVC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Oven Cleaner',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 10.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-OVC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-OVC-EAC', 'Oven Cleaner', 0, 0, 10.00, 'external', 1);
END

-- Update or Insert: YCL-POT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-POT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pot Scourers',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-POT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-POT-EAC', 'Pot Scourers', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCL-SAN-500
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-SAN-500')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hand Sanitiser 500ml',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 32.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-SAN-500';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-SAN-500', 'Hand Sanitiser 500ml', 0, 0, 32.00, 'external', 1);
END

-- Update or Insert: YCL-SCC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-SCC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Speciality Cleaning Chemicals -Machine Cleaner 900',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-SCC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-SCC-KGR', 'Speciality Cleaning Chemicals -Machine Cleaner 900', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCL-SLW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-SLW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Steel Wool',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-SLW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-SLW-EAC', 'Steel Wool', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YCL-SPO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-SPO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sponges',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 24.87,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YCL-SPO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-SPO-EAC', 'Sponges', 0, 0, 24.87, 'RawMaterial', 1);
END

-- Update or Insert: YCL-UCD-900G
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YCL-UCD-900G')
BEGIN
    UPDATE Products 
    SET ProductName = 'Urnex Cafiza2 Detergent',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 188.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YCL-UCD-900G';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YCL-UCD-900G', 'Urnex Cafiza2 Detergent', 0, 0, 188.00, 'external', 1);
END

-- Update or Insert: YDO-BIS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDO-BIS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough-Biscuit',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDO-BIS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDO-BIS-MX1', 'Sub Dough-Biscuit', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDO-BRB-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDO-BRB-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough Brown Bread',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDO-BRB-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDO-BRB-MX1', 'Sub Dough Brown Bread', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDO-BUN-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDO-BUN-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough - Buns',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDO-BUN-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDO-BUN-MX1', 'Sub Dough - Buns', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDO-CRO-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDO-CRO-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub dough Croissants',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDO-CRO-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDO-CRO-MX1', 'Sub dough Croissants', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDO-CUC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDO-CUC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough - Butter Biscuits',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDO-CUC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDO-CUC-MX1', 'Sub Dough - Butter Biscuits', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDO-DAN-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDO-DAN-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough -Danish',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDO-DAN-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDO-DAN-MX1', 'Sub Dough -Danish', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDO-DOU-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDO-DOU-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough-Doughnut',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDO-DOU-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDO-DOU-MX1', 'Sub Dough-Doughnut', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDO-M3M-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDO-M3M-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough Melting Moment Round 60g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDO-M3M-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDO-M3M-MX1', 'Sub Dough Melting Moment Round 60g', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDO-MML-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDO-MML-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough Melting Moments Long 95g',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDO-MML-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDO-MML-MX1', 'Sub Dough Melting Moments Long 95g', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDO-NAA-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDO-NAA-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough - Naan',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDO-NAA-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDO-NAA-MX1', 'Sub Dough - Naan', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDO-ROL-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDO-ROL-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Dough - Rolls',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDO-ROL-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDO-ROL-MX1', 'Sub Dough - Rolls', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDP-CHD-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDP-CHD-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Lamington -Dip Chocolate',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDP-CHD-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDP-CHD-MX1', 'Sub Lamington -Dip Chocolate', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDP-LAM-MX3
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDP-LAM-MX3')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Raspberry Lamington - Dip',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDP-LAM-MX3';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDP-LAM-MX3', 'Sub Raspberry Lamington - Dip', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YDP-SNO-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YDP-SNO-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Snowball Dip',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YDP-SNO-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YDP-SNO-MX1', 'Sub Snowball Dip', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YEG-SNO-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YEG-SNO-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Snowball Eggless',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YEG-SNO-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YEG-SNO-MX1', 'Sub Snowball Eggless', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YFC-FRC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YFC-FRC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Fresh Cream',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YFC-FRC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YFC-FRC-MX1', 'Sub Fresh Cream', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YFI-BOG-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YFI-BOG-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Chocolate Ganache',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YFI-BOG-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YFI-BOG-MX1', 'Sub Chocolate Ganache', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YFI-BOM-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YFI-BOM-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Choc Mousse Bar One',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YFI-BOM-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YFI-BOM-MX1', 'Sub Choc Mousse Bar One', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YFI-CCC-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YFI-CCC-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Choc Cream Cheese',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YFI-CCC-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YFI-CCC-KGR', 'Sub Choc Cream Cheese', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YFI-CUS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YFI-CUS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Custard Filing',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YFI-CUS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YFI-CUS-MX1', 'Sub Custard Filing', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YFI-FEM-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YFI-FEM-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'sub choc mousse ferrero',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YFI-FEM-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YFI-FEM-MX1', 'sub choc mousse ferrero', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YFI-MIL-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YFI-MIL-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Milk Tart Filling',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YFI-MIL-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YFI-MIL-MX1', 'Sub Milk Tart Filling', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YFI-MOU-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YFI-MOU-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Mousse Mix',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YFI-MOU-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YFI-MOU-MX1', 'Sub Mousse Mix', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YFI-SQF-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YFI-SQF-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Currant Square Filling',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YFI-SQF-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YFI-SQF-MX1', 'Sub Currant Square Filling', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YFI-STJ-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YFI-STJ-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Strawberry Jam Filling',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YFI-STJ-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YFI-STJ-MX1', 'Sub Strawberry Jam Filling', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YFI-TIR-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YFI-TIR-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Tiramisu',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YFI-TIR-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YFI-TIR-MX1', 'Sub Tiramisu', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YGA-19K-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YGA-19K-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Gas 19kg',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 485.57,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YGA-19K-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YGA-19K-EAC', 'Gas 19kg', 0, 0, 485.57, 'external', 1);
END

-- Update or Insert: YGA-AFS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YGA-AFS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Air Filled Stand 1550x500',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 639.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YGA-AFS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YGA-AFS-EAC', 'Air Filled Stand 1550x500', 0, 0, 639.00, 'RawMaterial', 1);
END

-- Update or Insert: YGA-FIR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YGA-FIR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Fire Extinguisher',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YGA-FIR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YGA-FIR-EAC', 'Fire Extinguisher', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YPA-ECL-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YPA-ECL-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Batter Eclairs',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YPA-ECL-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YPA-ECL-MX1', 'Sub Batter Eclairs', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YPA-PUF-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YPA-PUF-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Pastry-Puff',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YPA-PUF-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YPA-PUF-MX1', 'Sub Pastry-Puff', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YPA-SWE-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YPA-SWE-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Sweet Paste',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YPA-SWE-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YPA-SWE-MX1', 'Sub Sweet Paste', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YPI-PIC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YPI-PIC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Picture',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YPI-PIC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YPI-PIC-MX1', 'Sub Picture', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YRO-COR-M12
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YRO-COR-M12')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Cocktail Rolls 12s',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YRO-COR-M12';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YRO-COR-M12', 'Sub Cocktail Rolls 12s', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YSP-BSC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YSP-BSC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub- Pie Bottom Short Crust Pastry',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YSP-BSC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YSP-BSC-MX1', 'Sub- Pie Bottom Short Crust Pastry', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YSP-SCM-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YSP-SCM-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub- Chicken & Mushroom Pie Filling',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YSP-SCM-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YSP-SCM-MX1', 'Sub- Chicken & Mushroom Pie Filling', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YSP-SHE-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YSP-SHE-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Bar One Sponge - Sheets',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YSP-SHE-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YSP-SHE-MX1', 'Sub Bar One Sponge - Sheets', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YSP-SMC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YSP-SMC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub- Mutton Curry Pie Filling',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YSP-SMC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YSP-SMC-MX1', 'Sub- Mutton Curry Pie Filling', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YSP-SVP-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YSP-SVP-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub- Veg Curry Pie Filling',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YSP-SVP-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YSP-SVP-MX1', 'Sub- Veg Curry Pie Filling', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YSP-TRI-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YSP-TRI-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub -Sponge Trifle',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YSP-TRI-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YSP-TRI-MX1', 'Sub -Sponge Trifle', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YST-A4P-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-A4P-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'A4 PAPER',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-A4P-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-A4P-EAC', 'A4 PAPER', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-ABR-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-ABR-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Absa Rolls',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-ABR-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-ABR-EAC', 'Absa Rolls', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-BAT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-BAT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Battery',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-BAT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-BAT-EAC', 'Battery', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-BCI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-BCI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'New Birthday Cake Invoices',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-BCI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-BCI-EAC', 'New Birthday Cake Invoices', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-BCO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-BCO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'book cover',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-BCO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-BCO-EAC', 'book cover', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: YST-BRO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-BRO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Brother Toner Cart.7225N',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-BRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-BRO-EAC', 'Brother Toner Cart.7225N', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-BTI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-BTI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Books Tax Invoice',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-BTI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-BTI-EAC', 'Books Tax Invoice', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: YST-BTP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-BTP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Black Tape',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-BTP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-BTP-EAC', 'Black Tape', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-DIW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-DIW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Diwali Invoice Books',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-DIW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-DIW-EAC', 'Diwali Invoice Books', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: YST-DPL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-DPL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Diwali Cake Box Plates',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YST-DPL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-DPL-EAC', 'Diwali Cake Box Plates', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YST-ERC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-ERC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Epson Ribbon Cartridge',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-ERC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-ERC-EAC', 'Epson Ribbon Cartridge', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-EXE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-EXE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'A4 exercise book',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-EXE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-EXE-EAC', 'A4 exercise book', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-HCB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-HCB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Hard cover book',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-HCB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-HCB-EAC', 'Hard cover book', 0.00, 0.00, 0.00, 'external', 1);
END

-- Update or Insert: YST-HLS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-HLS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'High lighters',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-HLS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-HLS-EAC', 'High lighters', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-LMP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-LMP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Laminating Plastic',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-LMP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-LMP-EAC', 'Laminating Plastic', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-LPS-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-LPS-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Laser Payslips',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-LPS-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-LPS-EAC', 'Laser Payslips', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-PFL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-PFL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'paper file',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-PFL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-PFL-EAC', 'paper file', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-PRI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-PRI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Pritt',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-PRI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-PRI-EAC', 'Pritt', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-SQA-PAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-SQA-PAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'square white paper',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-SQA-PAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-SQA-PAC', 'square white paper', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-STA-BOX
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-STA-BOX')
BEGIN
    UPDATE Products 
    SET ProductName = 'Staples rexel no .56',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-STA-BOX';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-STA-BOX', 'Staples rexel no .56', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-TAP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-TAP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'tape',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-TAP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-TAP-EAC', 'tape', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-TIL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-TIL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Till Rolls',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 388.33,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-TIL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-TIL-EAC', 'Till Rolls', 0, 0, 388.33, 'external', 1);
END

-- Update or Insert: YST-TIP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-TIP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Tipex',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-TIP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-TIP-EAC', 'Tipex', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YST-TRL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-TRL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'toilet roll',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 7.57,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YST-TRL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-TRL-EAC', 'toilet roll', 0, 0, 7.57, 'external', 1);
END

-- Update or Insert: YST-WGE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YST-WGE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Wage Envelope',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YST-WGE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YST-WGE-EAC', 'Wage Envelope', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTB-MIL-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTB-MIL-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Milk Tart Base Large',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTB-MIL-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTB-MIL-MX1', 'Sub Milk Tart Base Large', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTB-MIS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTB-MIS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Milk Tart Base Small',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTB-MIS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTB-MIS-MX1', 'Sub Milk Tart Base Small', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTB-NOB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTB-NOB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub No Bake Cake',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTB-NOB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTB-NOB-EAC', 'Sub No Bake Cake', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-BEL-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-BEL-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Belgica Tart Topping',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-BEL-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-BEL-MX1', 'Sub Belgica Tart Topping', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-BLC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-BLC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Belgica Crumbs',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-BLC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-BLC-MX1', 'Sub Belgica Crumbs', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-BOF-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-BOF-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Bar One Filling',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-BOF-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-BOF-KGR', 'Sub Bar One Filling', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-BOG-KGR
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-BOG-KGR')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub- Bar One Ganache',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-BOG-KGR';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-BOG-KGR', 'Sub- Bar One Ganache', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-BUC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-BUC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Buttercream Chocolate',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-BUC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-BUC-MX1', 'Sub Buttercream Chocolate', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-BUW-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-BUW-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Buttercream- White',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-BUW-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-BUW-MX1', 'Sub Buttercream- White', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-BUY-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-BUY-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Buttercream Yellow',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-BUY-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-BUY-MX1', 'Sub Buttercream Yellow', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-FOC-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-FOC-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Fondant Chocolate',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-FOC-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-FOC-MX1', 'Sub Fondant Chocolate', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-NAA-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-NAA-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Naan topping',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-NAA-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-NAA-MX1', 'Sub Naan topping', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-SNO-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-SNO-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Snowball Coconut Topping',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-SNO-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-SNO-MX1', 'Sub Snowball Coconut Topping', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-SUS-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-SUS-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Sugar Syrup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-SUS-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-SUS-MX1', 'Sub Sugar Syrup', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-SUW-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-SUW-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub Glaze Sugar Water',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-SUW-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-SUW-MX1', 'Sub Glaze Sugar Water', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YTO-WFI-MX1
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YTO-WFI-MX1')
BEGIN
    UPDATE Products 
    SET ProductName = 'Sub - White Fondant Icing',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'YTO-WFI-MX1';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YTO-WFI-MX1', 'Sub - White Fondant Icing', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: YUT-CDW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YUT-CDW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Cutter Dough Wheel Divider',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YUT-CDW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YUT-CDW-EAC', 'Cutter Dough Wheel Divider', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YUT-GRU-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YUT-GRU-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Grunter Knife',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 276.71,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YUT-GRU-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YUT-GRU-EAC', 'Grunter Knife', 0, 0, 276.71, 'external', 1);
END

-- Update or Insert: YUT-PIP-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YUT-PIP-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Piping Bag No 5',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 153.70,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YUT-PIP-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YUT-PIP-EAC', 'Piping Bag No 5', 0, 0, 153.70, 'external', 1);
END

-- Update or Insert: YUT-SCA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YUT-SCA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Scale Electronic',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YUT-SCA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YUT-SCA-EAC', 'Scale Electronic', 0, 0, 0.00, 'external', 1);
END

-- Update or Insert: YUT-WHI-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'YUT-WHI-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Whisks 350mm',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 137.20,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'YUT-WHI-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('YUT-WHI-EAC', 'Whisks 350mm', 0, 0, 137.20, 'external', 1);
END

-- Update or Insert: ZBX-16B-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZBX-16B-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '16 box',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZBX-16B-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZBX-16B-EAC', '16 box', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZBX-883-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZBX-883-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '8*8*3',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZBX-883-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZBX-883-EAC', '8*8*3', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZBX-884-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZBX-884-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '8*8*4',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 3.14,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZBX-884-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZBX-884-EAC', '8*8*4', 0, 0, 3.14, 'RawMaterial', 1);
END

-- Update or Insert: ZBX-MUFF-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZBX-MUFF-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Muffin Box Rose Design',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZBX-MUFF-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZBX-MUFF-EACH', 'Muffin Box Rose Design', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZDB- FIC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZDB- FIC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Genus Eco 30 Flying Insect Catcher',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZDB- FIC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZDB- FIC-EAC', 'Genus Eco 30 Flying Insect Catcher', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZDB-351-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZDB-351-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'L 351 Domes',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.09,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZDB-351-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZDB-351-EAC', 'L 351 Domes', 0, 0, 0.09, 'RawMaterial', 1);
END

-- Update or Insert: ZDB-38B-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZDB-38B-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '38F Black Tray',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZDB-38B-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZDB-38B-EAC', '38F Black Tray', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZDB-38C-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZDB-38C-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '38F Lid',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZDB-38C-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZDB-38C-EAC', '38F Lid', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZDB-38F-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZDB-38F-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '38F Black Tray',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZDB-38F-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZDB-38F-EAC', '38F Black Tray', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZDB-S31-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZDB-S31-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Lids 300 Biscuit S312',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZDB-S31-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZDB-S31-EAC', 'Lids 300 Biscuit S312', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZDB-SDL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZDB-SDL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Square Desert Lid',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZDB-SDL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZDB-SDL-EAC', 'Square Desert Lid', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZDB-SDT-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZDB-SDT-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'GLUTEN FREE COFFEE CAKE TUB',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'internal',
        IsActive = 1
    WHERE ProductCode = 'ZDB-SDT-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZDB-SDT-EAC', 'GLUTEN FREE COFFEE CAKE TUB', 0.00, 0.00, 0.00, 'internal', 1);
END

-- Update or Insert: ZDO-DOY-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZDO-DOY-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Doyley Round 240mm',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.11,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZDO-DOY-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZDO-DOY-EAC', 'Doyley Round 240mm', 0, 0, 1.11, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-10-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-10-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'KR 10',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 9.44,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-10-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-10-EAC', 'KR 10', 0, 0, 9.44, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-14-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-14-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'KR14',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 10.74,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-14-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-14-EAC', 'KR14', 0, 0, 10.74, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-16-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-16-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'KR16',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 14.62,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-16-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-16-EAC', 'KR16', 0, 0, 14.62, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-18-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-18-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'KR18',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 18.75,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-18-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-18-EAC', 'KR18', 0, 0, 18.75, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-1M5-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-1M5-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'KS 1MX500',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 118.75,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-1M5-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-1M5-EAC', 'KS 1MX500', 0, 0, 118.75, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-20-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-20-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'KR20',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 20.17,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-20-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-20-EAC', 'KR20', 0, 0, 20.17, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-20R-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-20R-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '20 Round Board',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-20R-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-20R-EAC', '20 Round Board', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-500-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-500-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'BOX 1M*500MM*6',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-500-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-500-EAC', 'BOX 1M*500MM*6', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-NR1-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-NR1-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'NR 10',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 5.82,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-NR1-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-NR1-EAC', 'NR 10', 0, 0, 5.82, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-NR2-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-NR2-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'NR 12',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 9.01,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-NR2-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-NR2-EAC', 'NR 12', 0, 0, 9.01, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-NS1-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-NS1-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'NS 10',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 5.48,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-NS1-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-NS1-EAC', 'NS 10', 0, 0, 5.48, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-NS2-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-NS2-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'NS12',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 7.60,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-NS2-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-NS2-EAC', 'NS12', 0, 0, 7.60, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-S16-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-S16-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'KS16',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 14.98,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-S16-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-S16-EAC', 'KS16', 0, 0, 14.98, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-S18-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-S18-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'KS18',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 19.02,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-S18-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-S18-EAC', 'KS18', 0, 0, 19.02, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-S20-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-S20-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'KS20',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 21.14,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-S20-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-S20-EAC', 'KS20', 0, 0, 21.14, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-T14-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-T14-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'NS14',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 9.05,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-T14-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-T14-EAC', 'NS14', 0, 0, 9.05, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-TN6-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-TN6-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'NR 6',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 9.98,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-TN6-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-TN6-EAC', 'NR 6', 0, 0, 9.98, 'RawMaterial', 1);
END

-- Update or Insert: ZFO-TN8-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZFO-TN8-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'NS8',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 4.60,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZFO-TN8-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZFO-TN8-EAC', 'NS8', 0, 0, 4.60, 'RawMaterial', 1);
END

-- Update or Insert: ZLA- REA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZLA- REA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Label Real Butter',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZLA- REA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZLA- REA-EAC', 'Label Real Butter', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZLA-ALA-50MM
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZLA-ALA-50MM')
BEGIN
    UPDATE Products 
    SET ProductName = 'Oven Delights logo labels 50mmx40mm',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZLA-ALA-50MM';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZLA-ALA-50MM', 'Oven Delights logo labels 50mmx40mm', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZLA-LAB-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZLA-LAB-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Label 40x46 B/white Label',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.07,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZLA-LAB-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZLA-LAB-EAC', 'Label 40x46 B/white Label', 0, 0, 0.07, 'RawMaterial', 1);
END

-- Update or Insert: ZLA-LKI-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZLA-LKI-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Label White Keep In Fridge',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.04,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZLA-LKI-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZLA-LKI-EACH', 'Label White Keep In Fridge', 0, 0, 0.04, 'RawMaterial', 1);
END

-- Update or Insert: ZLA-LPL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZLA-LPL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Label For Platter Domes',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZLA-LPL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZLA-LPL-EAC', 'Label For Platter Domes', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZLA-OLA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZLA-OLA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Label Oven Delights Logo 50x50mm',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZLA-OLA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZLA-OLA-EAC', 'Label Oven Delights Logo 50x50mm', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZLA-PLA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZLA-PLA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Label Plates logo 50x50mm',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZLA-PLA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZLA-PLA-EAC', 'Label Plates logo 50x50mm', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZLA-PLL-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZLA-PLL-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Label for Platters Assorted Flavours',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZLA-PLL-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZLA-PLL-EAC', 'Label for Platters Assorted Flavours', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZLA-WLB-EACH
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZLA-WLB-EACH')
BEGIN
    UPDATE Products 
    SET ProductName = 'Label 40x29 White Label',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.09,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZLA-WLB-EACH';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZLA-WLB-EACH', 'Label 40x29 White Label', 0, 0, 0.09, 'RawMaterial', 1);
END

-- Update or Insert: ZPA- SSW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPA- SSW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Stirrer Sticks Wooden',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.12,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'ZPA- SSW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPA- SSW-EAC', 'Stirrer Sticks Wooden', 0, 0, 0.12, 'external', 1);
END

-- Update or Insert: ZPA-CDA-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPA-CDA-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '4 Cup Drinkaway Carrier P2106',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.15,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZPA-CDA-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPA-CDA-EAC', '4 Cup Drinkaway Carrier P2106', 0, 0, 0.15, 'RawMaterial', 1);
END

-- Update or Insert: ZPA-CDC-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPA-CDC-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = '2 Cup Drinkaway Carrier P2105',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.10,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZPA-CDC-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPA-CDC-EAC', '2 Cup Drinkaway Carrier P2105', 0, 0, 0.10, 'RawMaterial', 1);
END

-- Update or Insert: ZPA-DWK-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPA-DWK-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = '250ml Double Wall Kraft Cup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.48,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZPA-DWK-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPA-DWK-250ML', '250ml Double Wall Kraft Cup', 0, 0, 1.48, 'RawMaterial', 1);
END

-- Update or Insert: ZPA-DWK-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPA-DWK-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = '350ml Double Wall Kraft Cup',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 1.74,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZPA-DWK-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPA-DWK-350ML', '350ml Double Wall Kraft Cup', 0, 0, 1.74, 'RawMaterial', 1);
END

-- Update or Insert: ZPA-GRE-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPA-GRE-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Grease Proof 2(200*170)',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.16,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZPA-GRE-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPA-GRE-EAC', 'Grease Proof 2(200*170)', 0, 0, 0.16, 'RawMaterial', 1);
END

-- Update or Insert: ZPA-RSL-250ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPA-RSL-250ML')
BEGIN
    UPDATE Products 
    SET ProductName = '250ml Ripple Sip Lid',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.47,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZPA-RSL-250ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPA-RSL-250ML', '250ml Ripple Sip Lid', 0, 0, 0.47, 'RawMaterial', 1);
END

-- Update or Insert: ZPA-RSL-350ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPA-RSL-350ML')
BEGIN
    UPDATE Products 
    SET ProductName = '350ml Ripple Sip Lid',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.57,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZPA-RSL-350ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPA-RSL-350ML', '350ml Ripple Sip Lid', 0, 0, 0.57, 'RawMaterial', 1);
END

-- Update or Insert: ZPA-SER-BOX
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPA-SER-BOX')
BEGIN
    UPDATE Products 
    SET ProductName = 'Servittes 200x300',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 2.23,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'ZPA-SER-BOX';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPA-SER-BOX', 'Servittes 200x300', 0, 0, 2.23, 'external', 1);
END

-- Update or Insert: ZPA-SSW-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPA-SSW-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Stirrer Sticks Wooden',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.12,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'ZPA-SSW-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPA-SSW-EAC', 'Stirrer Sticks Wooden', 0, 0, 0.12, 'external', 1);
END

-- Update or Insert: ZPA-WHP-100ML
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPA-WHP-100ML')
BEGIN
    UPDATE Products 
    SET ProductName = '100ml White Hot Paper Cup',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZPA-WHP-100ML';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPA-WHP-100ML', '100ml White Hot Paper Cup', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZPL-70M-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPL-70M-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Plastic Lids Clear 70mm',
        RecommendedSellingPrice = 0.00,
        LastPaidPrice = 0.00,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZPL-70M-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPL-70M-EAC', 'Plastic Lids Clear 70mm', 0.00, 0.00, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZPL-DES-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPL-DES-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Desert Spoons',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.33,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'ZPL-DES-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPL-DES-EAC', 'Desert Spoons', 0, 0, 0.33, 'external', 1);
END

-- Update or Insert: ZPL-F70-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPL-F70-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'F70 BISCUIT CONTAINER',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'RawMaterial',
        IsActive = 1
    WHERE ProductCode = 'ZPL-F70-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPL-F70-EAC', 'F70 BISCUIT CONTAINER', 0, 0, 0.00, 'RawMaterial', 1);
END

-- Update or Insert: ZPL-STR-BOX
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPL-STR-BOX')
BEGIN
    UPDATE Products 
    SET ProductName = 'Wrapped Straws',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.18,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'ZPL-STR-BOX';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPL-STR-BOX', 'Wrapped Straws', 0, 0, 0.18, 'external', 1);
END

-- Update or Insert: ZPL-TRO-EAC
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPL-TRO-EAC')
BEGIN
    UPDATE Products 
    SET ProductName = 'Trolley Cover',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 70.26,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'ZPL-TRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPL-TRO-EAC', 'Trolley Cover', 0, 0, 70.26, 'external', 1);
END

-- Update or Insert: ZPL-WSS--BOX
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = 'ZPL-WSS--BOX')
BEGIN
    UPDATE Products 
    SET ProductName = 'Wrapped Smoothie Straw',
        RecommendedSellingPrice = 0,
        LastPaidPrice = 0,
        AverageCost = 0.00,
        ItemType = 'external',
        IsActive = 1
    WHERE ProductCode = 'ZPL-WSS--BOX';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('ZPL-WSS--BOX', 'Wrapped Smoothie Straw', 0, 0, 0.00, 'external', 1);
END

COMMIT TRANSACTION;

PRINT '';
PRINT 'Products updated from master list';

-- Verify
SELECT 
    ItemType,
    COUNT(*) AS ProductCount,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice
FROM Products
WHERE IsActive = 1
GROUP BY ItemType
ORDER BY ItemType;

PRINT '';
PRINT 'âœ… PRODUCTS TABLE UPDATED FROM MASTER LIST!';
PRINT '';
PRINT 'Retail products (internal/external/Manufactured) will appear in POS';
PRINT 'Raw materials will NOT appear in POS (stockroom only)';
