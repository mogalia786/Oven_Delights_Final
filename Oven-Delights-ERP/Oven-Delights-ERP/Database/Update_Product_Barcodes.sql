-- Update Demo_Retail_Variant with barcodes
-- Generated: 2025-12-07 00:44:40

BEGIN TRANSACTION;

-- BIS-ABB-EAC - Barcode: 16001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-ABB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-ABB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16001', 1);
        PRINT 'Inserted variant with barcode for: BIS-ABB-EAC';
    END
END
GO

-- BIS-BUB-EAC - Barcode: 14071
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-BUB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14071' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-BUB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14071', 1);
        PRINT 'Inserted variant with barcode for: BIS-BUB-EAC';
    END
END
GO

-- BIS-CHD-EAC - Barcode: 14079
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-CHD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14079' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-CHD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14079', 1);
        PRINT 'Inserted variant with barcode for: BIS-CHD-EAC';
    END
END
GO

-- BIS-CJN-EAC - Barcode: 14067
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-CJN-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14067' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-CJN-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14067', 1);
        PRINT 'Inserted variant with barcode for: BIS-CJN-EAC';
    END
END
GO

-- BIS-CRU-EACH - Barcode: 14099
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-CRU-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14099' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-CRU-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14099', 1);
        PRINT 'Inserted variant with barcode for: BIS-CRU-EACH';
    END
END
GO

-- BIS-CUS-EAC - Barcode: 16201
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-CUS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16201' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-CUS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16201', 1);
        PRINT 'Inserted variant with barcode for: BIS-CUS-EAC';
    END
END
GO

-- BIS-DEB-EAC - Barcode: 14073
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-DEB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14073' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-DEB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14073', 1);
        PRINT 'Inserted variant with barcode for: BIS-DEB-EAC';
    END
END
GO

-- BIS-FEB-EAC - Barcode: 16200
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-FEB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16200' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-FEB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16200', 1);
        PRINT 'Inserted variant with barcode for: BIS-FEB-EAC';
    END
END
GO

-- BIS-FLF-EAC - Barcode: 14068
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-FLF-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14068' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-FLF-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14068', 1);
        PRINT 'Inserted variant with barcode for: BIS-FLF-EAC';
    END
END
GO

-- BIS-HSB-EAC - Barcode: 14076
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-HSB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14076' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-HSB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14076', 1);
        PRINT 'Inserted variant with barcode for: BIS-HSB-EAC';
    END
END
GO

-- BIS-NAK-EAC - Barcode: 16077
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-NAK-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16077' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-NAK-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16077', 1);
        PRINT 'Inserted variant with barcode for: BIS-NAK-EAC';
    END
END
GO

-- BIS-PAO-EAC - Barcode: 16203
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-PAO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16203' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-PAO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16203', 1);
        PRINT 'Inserted variant with barcode for: BIS-PAO-EAC';
    END
END
GO

-- BIS-PNS-EAC - Barcode: 14069
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-PNS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14069' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-PNS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14069', 1);
        PRINT 'Inserted variant with barcode for: BIS-PNS-EAC';
    END
END
GO

-- BIS-RMC-EAC - Barcode: 16002
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-RMC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16002' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-RMC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16002', 1);
        PRINT 'Inserted variant with barcode for: BIS-RMC-EAC';
    END
END
GO

-- BIS-ROC-EAC - Barcode: 14070
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-ROC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14070' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-ROC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14070', 1);
        PRINT 'Inserted variant with barcode for: BIS-ROC-EAC';
    END
END
GO

-- BIS-SBB-EAC - Barcode: 16006
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'BIS-SBB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16006' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: BIS-SBB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16006', 1);
        PRINT 'Inserted variant with barcode for: BIS-SBB-EAC';
    END
END
GO

-- CBC-BBG-EAC - Barcode: 11001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-BBG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-BBG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11001', 1);
        PRINT 'Inserted variant with barcode for: CBC-BBG-EAC';
    END
END
GO

-- CBC-BCC-EAC - Barcode: 30337
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-BCC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30337' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-BCC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30337', 1);
        PRINT 'Inserted variant with barcode for: CBC-BCC-EAC';
    END
END
GO

-- CBC-BCD-EAC - Barcode: 11004
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-BCD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11004' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-BCD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11004', 1);
        PRINT 'Inserted variant with barcode for: CBC-BCD-EAC';
    END
END
GO

-- CBC-BCG-EAC - Barcode: 11003
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-BCG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11003' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-BCG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11003', 1);
        PRINT 'Inserted variant with barcode for: CBC-BCG-EAC';
    END
END
GO

-- CBC-BCN-EAC - Barcode: 30339
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-BCN-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30339' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-BCN-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30339', 1);
        PRINT 'Inserted variant with barcode for: CBC-BCN-EAC';
    END
END
GO

-- CBC-BCS-EAC - Barcode: 11005
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-BCS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11005' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-BCS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11005', 1);
        PRINT 'Inserted variant with barcode for: CBC-BCS-EAC';
    END
END
GO

-- CBC-BDN-EAC - Barcode: 11016
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-BDN-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11016' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-BDN-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11016', 1);
        PRINT 'Inserted variant with barcode for: CBC-BDN-EAC';
    END
END
GO

-- CBC-BEG-EAC - Barcode: 11040
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-BEG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11040' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-BEG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11040', 1);
        PRINT 'Inserted variant with barcode for: CBC-BEG-EAC';
    END
END
GO

-- CBC-BET-EAC - Barcode: 11041
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-BET-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11041' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-BET-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11041', 1);
        PRINT 'Inserted variant with barcode for: CBC-BET-EAC';
    END
END
GO

-- CBC-BRG-EAC - Barcode: 11042
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-BRG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11042' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-BRG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11042', 1);
        PRINT 'Inserted variant with barcode for: CBC-BRG-EAC';
    END
END
GO

-- CBC-BTD-EAC - Barcode: 11096
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-BTD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11096' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-BTD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11096', 1);
        PRINT 'Inserted variant with barcode for: CBC-BTD-EAC';
    END
END
GO

-- CBC-CBG-EAC - Barcode: 11097
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-CBG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11097' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-CBG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11097', 1);
        PRINT 'Inserted variant with barcode for: CBC-CBG-EAC';
    END
END
GO

-- CBC-CDB-EAC - Barcode: 15060
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-CDB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15060' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-CDB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15060', 1);
        PRINT 'Inserted variant with barcode for: CBC-CDB-EAC';
    END
END
GO

-- CBC-CDN-EAC - Barcode: 11018
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-CDN-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11018' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-CDN-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11018', 1);
        PRINT 'Inserted variant with barcode for: CBC-CDN-EAC';
    END
END
GO

-- CBC-CNL-EAC - Barcode: 11032
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-CNL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11032' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-CNL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11032', 1);
        PRINT 'Inserted variant with barcode for: CBC-CNL-EAC';
    END
END
GO

-- CBC-CNR-EAC - Barcode: 11030
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-CNR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11030' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-CNR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11030', 1);
        PRINT 'Inserted variant with barcode for: CBC-CNR-EAC';
    END
END
GO

-- CBC-CNS-EAC - Barcode: 11008
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-CNS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11008' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-CNS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11008', 1);
        PRINT 'Inserted variant with barcode for: CBC-CNS-EAC';
    END
END
GO

-- CBC-CNT-EAC - Barcode: 11031
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-CNT-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11031' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-CNT-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11031', 1);
        PRINT 'Inserted variant with barcode for: CBC-CNT-EAC';
    END
END
GO

-- CBC-CUS-EAC - Barcode: 11035
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-CUS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11035' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-CUS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11035', 1);
        PRINT 'Inserted variant with barcode for: CBC-CUS-EAC';
    END
END
GO

-- CBC-FLA-EAC - Barcode: 11036
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-FLA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11036' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-FLA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11036', 1);
        PRINT 'Inserted variant with barcode for: CBC-FLA-EAC';
    END
END
GO

-- CBC-JAP-EAC - Barcode: 11037
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-JAP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11037' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-JAP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11037', 1);
        PRINT 'Inserted variant with barcode for: CBC-JAP-EAC';
    END
END
GO

-- CBC-JAT-EAC - Barcode: 11038
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-JAT-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11038' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-JAT-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11038', 1);
        PRINT 'Inserted variant with barcode for: CBC-JAT-EAC';
    END
END
GO

-- CBC-JDN-EAC - Barcode: 11019
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-JDN-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11019' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-JDN-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11019', 1);
        PRINT 'Inserted variant with barcode for: CBC-JDN-EAC';
    END
END
GO

-- CBC-JTO-EAC - Barcode: 11039
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-JTO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11039' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-JTO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11039', 1);
        PRINT 'Inserted variant with barcode for: CBC-JTO-EAC';
    END
END
GO

-- CBC-KOE-EAC - Barcode: 11020
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-KOE-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11020' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-KOE-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11020', 1);
        PRINT 'Inserted variant with barcode for: CBC-KOE-EAC';
    END
END
GO

-- CBC-LPC-EAC - Barcode: 11009
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-LPC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11009' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-LPC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11009', 1);
        PRINT 'Inserted variant with barcode for: CBC-LPC-EAC';
    END
END
GO

-- CBC-LPR-EAC - Barcode: 11010
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-LPR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11010' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-LPR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11010', 1);
        PRINT 'Inserted variant with barcode for: CBC-LPR-EAC';
    END
END
GO

-- CBC-MBD-EAC - Barcode: 11043
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-MBD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11043' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-MBD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11043', 1);
        PRINT 'Inserted variant with barcode for: CBC-MBD-EAC';
    END
END
GO

-- CBC-MBG-EAC - Barcode: 11098
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-MBG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11098' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-MBG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11098', 1);
        PRINT 'Inserted variant with barcode for: CBC-MBG-EAC';
    END
END
GO

-- CBC-MCD-EAC - Barcode: 11044
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-MCD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11044' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-MCD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11044', 1);
        PRINT 'Inserted variant with barcode for: CBC-MCD-EAC';
    END
END
GO

-- CBC-MEL-40G - Barcode: 11021
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-MEL-40G';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11021' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-MEL-40G';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11021', 1);
        PRINT 'Inserted variant with barcode for: CBC-MEL-40G';
    END
END
GO

-- CBC-MEL-60G - Barcode: 11023
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-MEL-60G';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11023' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-MEL-60G';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11023', 1);
        PRINT 'Inserted variant with barcode for: CBC-MEL-60G';
    END
END
GO

-- CBC-MFL-EAC - Barcode: 11045
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-MFL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11045' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-MFL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11045', 1);
        PRINT 'Inserted variant with barcode for: CBC-MFL-EAC';
    END
END
GO

-- CBC-MSB-EACH - Barcode: 11046
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-MSB-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11046' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-MSB-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11046', 1);
        PRINT 'Inserted variant with barcode for: CBC-MSB-EACH';
    END
END
GO

-- CBC-MUE-EAC - Barcode: 11007
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-MUE-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11007' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-MUE-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11007', 1);
        PRINT 'Inserted variant with barcode for: CBC-MUE-EAC';
    END
END
GO

-- CBC-PCC-EAC - Barcode: 30338
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-PCC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30338' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-PCC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30338', 1);
        PRINT 'Inserted variant with barcode for: CBC-PCC-EAC';
    END
END
GO

-- CBC-QUC-EAC - Barcode: 11011
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-QUC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11011' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-QUC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11011', 1);
        PRINT 'Inserted variant with barcode for: CBC-QUC-EAC';
    END
END
GO

-- CBC-SNO-EAC - Barcode: 11013
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-SNO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11013' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-SNO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11013', 1);
        PRINT 'Inserted variant with barcode for: CBC-SNO-EAC';
    END
END
GO

-- CBS-SBE-EACH - Barcode: 30650
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-SBE-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30650' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-SBE-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30650', 1);
        PRINT 'Inserted variant with barcode for: CBS-SBE-EACH';
    END
END
GO

-- CFC-FDI-EAC - Barcode: 8101
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FDI-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8101' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FDI-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8101', 1);
        PRINT 'Inserted variant with barcode for: CFC-FDI-EAC';
    END
END
GO

-- SHP-BVS-EAC - Barcode: 16009
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BVS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16009' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BVS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16009', 1);
        PRINT 'Inserted variant with barcode for: SHP-BVS-EAC';
    END
END
GO

-- CBC-CRP-EAC - Barcode: 11034
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBC-CRP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '11034' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBC-CRP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '11034', 1);
        PRINT 'Inserted variant with barcode for: CBC-CRP-EAC';
    END
END
GO

-- CBF-BCF-018 - Barcode: 10088
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-BCF-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10088' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-BCF-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10088', 1);
        PRINT 'Inserted variant with barcode for: CBF-BCF-018';
    END
END
GO

-- CBF-BCF-018 - Barcode: 10088
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-BCF-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10088' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-BCF-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10088', 1);
        PRINT 'Inserted variant with barcode for: CBF-BCF-018';
    END
END
GO

-- CBF-BCF-020 - Barcode: 10090
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-BCF-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10090' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-BCF-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10090', 1);
        PRINT 'Inserted variant with barcode for: CBF-BCF-020';
    END
END
GO

-- CBF-BCF-020 - Barcode: 10090
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-BCF-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10090' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-BCF-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10090', 1);
        PRINT 'Inserted variant with barcode for: CBF-BCF-020';
    END
END
GO

-- CBF-BFE-020 - Barcode: 10199
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-BFE-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10199' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-BFE-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10199', 1);
        PRINT 'Inserted variant with barcode for: CBF-BFE-020';
    END
END
GO

-- CBF-BFS-018 - Barcode: 10092
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-BFS-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10092' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-BFS-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10092', 1);
        PRINT 'Inserted variant with barcode for: CBF-BFS-018';
    END
END
GO

-- CBF-BFS-018 - Barcode: 10092
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-BFS-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10092' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-BFS-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10092', 1);
        PRINT 'Inserted variant with barcode for: CBF-BFS-018';
    END
END
GO

-- CBF-BFS-020 - Barcode: 10094
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-BFS-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10094' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-BFS-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10094', 1);
        PRINT 'Inserted variant with barcode for: CBF-BFS-020';
    END
END
GO

-- CBR-BCR-012 - Barcode: 10105
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBR-BCR-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10105' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBR-BCR-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10105', 1);
        PRINT 'Inserted variant with barcode for: CBR-BCR-012';
    END
END
GO

-- CBR-BCR-014 - Barcode: 10107
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBR-BCR-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10107' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBR-BCR-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10107', 1);
        PRINT 'Inserted variant with barcode for: CBR-BCR-014';
    END
END
GO

-- CBR-BCR-016 - Barcode: 10109
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBR-BCR-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10109' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBR-BCR-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10109', 1);
        PRINT 'Inserted variant with barcode for: CBR-BCR-016';
    END
END
GO

-- CBR-BCR-018 - Barcode: 10104
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBR-BCR-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10104' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBR-BCR-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10104', 1);
        PRINT 'Inserted variant with barcode for: CBR-BCR-018';
    END
END
GO

-- CBR-BCR-020 - Barcode: 10112
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBR-BCR-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10112' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBR-BCR-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10112', 1);
        PRINT 'Inserted variant with barcode for: CBR-BCR-020';
    END
END
GO

-- CBS-BCD-012 - Barcode: 10005
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10005' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-BCD-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10005', 1);
        PRINT 'Inserted variant with barcode for: CBS-BCD-012';
    END
END
GO

-- CBS-BCD-014 - Barcode: 10007
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10007' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-BCD-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10007', 1);
        PRINT 'Inserted variant with barcode for: CBS-BCD-014';
    END
END
GO

-- CBS-BCD-016 - Barcode: 10011
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10011' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-BCD-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10011', 1);
        PRINT 'Inserted variant with barcode for: CBS-BCD-016';
    END
END
GO

-- CBS-BCD-018 - Barcode: 10015
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10015' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-BCD-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10015', 1);
        PRINT 'Inserted variant with barcode for: CBS-BCD-018';
    END
END
GO

-- CBS-BCD-020 - Barcode: 10018
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10018' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-BCD-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10018', 1);
        PRINT 'Inserted variant with barcode for: CBS-BCD-020';
    END
END
GO

-- CBS-BCD-022 - Barcode: 10031
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-022';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10031' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-BCD-022';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10031', 1);
        PRINT 'Inserted variant with barcode for: CBS-BCD-022';
    END
END
GO

-- CBS-BCE-016 - Barcode: 10033
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-BCE-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10033' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-BCE-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10033', 1);
        PRINT 'Inserted variant with barcode for: CBS-BCE-016';
    END
END
GO

-- CNO-BC1-1X5 - Barcode: 10083
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BC1-1X5';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10083' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BC1-1X5';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10083', 1);
        PRINT 'Inserted variant with barcode for: CNO-BC1-1X5';
    END
END
GO

-- CNO-BC1-1X5 - Barcode: 10083
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BC1-1X5';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10083' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BC1-1X5';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10083', 1);
        PRINT 'Inserted variant with barcode for: CNO-BC1-1X5';
    END
END
GO

-- CAN-DOU-010 - Barcode: 80351
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-DOU-010';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '80351' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-DOU-010';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '80351', 1);
        PRINT 'Inserted variant with barcode for: CAN-DOU-010';
    END
END
GO

-- CAN-DOU-080 - Barcode: 8034
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-DOU-080';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8034' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-DOU-080';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8034', 1);
        PRINT 'Inserted variant with barcode for: CAN-DOU-080';
    END
END
GO

-- CAN-MAG-24S - Barcode: 8004
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-MAG-24S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8004' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-MAG-24S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8004', 1);
        PRINT 'Inserted variant with barcode for: CAN-MAG-24S';
    END
END
GO

-- CAN-MCA-EAC - Barcode: 30714
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-MCA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30714' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-MCA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30714', 1);
        PRINT 'Inserted variant with barcode for: CAN-MCA-EAC';
    END
END
GO

-- CAN-MIX-24S - Barcode: 8005
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-MIX-24S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8005' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-MIX-24S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8005', 1);
        PRINT 'Inserted variant with barcode for: CAN-MIX-24S';
    END
END
GO

-- CAN-RAI-000 - Barcode: 8006
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-000';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8006' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-RAI-000';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8006', 1);
        PRINT 'Inserted variant with barcode for: CAN-RAI-000';
    END
END
GO

-- CAN-RAI-001 - Barcode: 8007
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-001';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8007' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-RAI-001';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8007', 1);
        PRINT 'Inserted variant with barcode for: CAN-RAI-001';
    END
END
GO

-- CAN-RAI-002 - Barcode: 8008
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-002';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8008' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-RAI-002';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8008', 1);
        PRINT 'Inserted variant with barcode for: CAN-RAI-002';
    END
END
GO

-- CAN-RAI-003 - Barcode: 8009
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-003';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8009' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-RAI-003';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8009', 1);
        PRINT 'Inserted variant with barcode for: CAN-RAI-003';
    END
END
GO

-- CAN-RAI-004 - Barcode: 8010
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-004';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8010' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-RAI-004';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8010', 1);
        PRINT 'Inserted variant with barcode for: CAN-RAI-004';
    END
END
GO

-- CAN-RAI-005 - Barcode: 8011
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-005';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8011' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-RAI-005';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8011', 1);
        PRINT 'Inserted variant with barcode for: CAN-RAI-005';
    END
END
GO

-- CAN-RAI-006 - Barcode: 8012
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-006';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8012' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-RAI-006';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8012', 1);
        PRINT 'Inserted variant with barcode for: CAN-RAI-006';
    END
END
GO

-- CAN-RAI-007 - Barcode: 8013
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-007';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8013' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-RAI-007';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8013', 1);
        PRINT 'Inserted variant with barcode for: CAN-RAI-007';
    END
END
GO

-- CAN-RAI-009 - Barcode: 8015
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-009';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8015' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-RAI-009';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8015', 1);
        PRINT 'Inserted variant with barcode for: CAN-RAI-009';
    END
END
GO

-- CAN-WHI-000 - Barcode: 8025
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-000';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8025' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-WHI-000';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8025', 1);
        PRINT 'Inserted variant with barcode for: CAN-WHI-000';
    END
END
GO

-- CAN-WHI-001 - Barcode: 8016
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-001';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8016' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-WHI-001';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8016', 1);
        PRINT 'Inserted variant with barcode for: CAN-WHI-001';
    END
END
GO

-- CAN-WHI-002 - Barcode: 8017
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-002';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8017' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-WHI-002';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8017', 1);
        PRINT 'Inserted variant with barcode for: CAN-WHI-002';
    END
END
GO

-- CAN-WHI-003 - Barcode: 8018
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-003';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8018' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-WHI-003';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8018', 1);
        PRINT 'Inserted variant with barcode for: CAN-WHI-003';
    END
END
GO

-- CAN-WHI-004 - Barcode: 8019
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-004';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8019' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-WHI-004';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8019', 1);
        PRINT 'Inserted variant with barcode for: CAN-WHI-004';
    END
END
GO

-- CAN-WHI-005 - Barcode: 8020
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-005';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8020' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-WHI-005';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8020', 1);
        PRINT 'Inserted variant with barcode for: CAN-WHI-005';
    END
END
GO

-- CAN-WHI-006 - Barcode: 8021
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-006';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8021' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-WHI-006';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8021', 1);
        PRINT 'Inserted variant with barcode for: CAN-WHI-006';
    END
END
GO

-- CAN-WHI-007 - Barcode: 8022
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-007';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8022' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-WHI-007';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8022', 1);
        PRINT 'Inserted variant with barcode for: CAN-WHI-007';
    END
END
GO

-- CAN-WHI-008 - Barcode: 8023
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-008';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8023' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-WHI-008';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8023', 1);
        PRINT 'Inserted variant with barcode for: CAN-WHI-008';
    END
END
GO

-- CAN-WHI-009 - Barcode: 8024
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-009';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8024' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CAN-WHI-009';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8024', 1);
        PRINT 'Inserted variant with barcode for: CAN-WHI-009';
    END
END
GO

-- DRI-APT-275 - Barcode: 6001048003323
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-APT-275';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001048003323' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-APT-275';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001048003323', 1);
        PRINT 'Inserted variant with barcode for: DRI-APT-275';
    END
END
GO

-- DRI-APT-330 - Barcode: 6001048004481
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-APT-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001048004481' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-APT-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001048004481', 1);
        PRINT 'Inserted variant with barcode for: DRI-APT-330';
    END
END
GO

-- DRI-BAA-500 - Barcode: 90492853
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-BAA-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '90492853' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-BAA-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '90492853', 1);
        PRINT 'Inserted variant with barcode for: DRI-BAA-500';
    END
END
GO

-- DRI-BAN-500 - Barcode: 5449000117816
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-BAN-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000117816' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-BAN-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000117816', 1);
        PRINT 'Inserted variant with barcode for: DRI-BAN-500';
    END
END
GO

-- DRI-CBB-EAC - Barcode: 5449000256010
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-CBB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000256010' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-CBB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000256010', 1);
        PRINT 'Inserted variant with barcode for: DRI-CBB-EAC';
    END
END
GO

-- DRI-COC-125 - Barcode: 5449000009746
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-125';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000009746' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COC-125';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000009746', 1);
        PRINT 'Inserted variant with barcode for: DRI-COC-125';
    END
END
GO

-- DRI-COC-1LT - Barcode: 5449000054227
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-1LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000054227' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COC-1LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000054227', 1);
        PRINT 'Inserted variant with barcode for: DRI-COC-1LT';
    END
END
GO

-- DRI-COC-2LT - Barcode: 5449000009067
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000009067' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COC-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000009067', 1);
        PRINT 'Inserted variant with barcode for: DRI-COC-2LT';
    END
END
GO

-- DRI-COC-300 - Barcode: 2003
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-300';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '2003' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COC-300';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '2003', 1);
        PRINT 'Inserted variant with barcode for: DRI-COC-300';
    END
END
GO

-- DRI-COC-330 - Barcode: 5449000256805
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000256805' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COC-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000256805', 1);
        PRINT 'Inserted variant with barcode for: DRI-COC-330';
    END
END
GO

-- DRI-COC-500 - Barcode: 5449000664686
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000664686' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COC-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000664686', 1);
        PRINT 'Inserted variant with barcode for: DRI-COC-500';
    END
END
GO

-- DRI-COL-1.5LT - Barcode: 5449000133335
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-1.5LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000133335' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COL-1.5LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000133335', 1);
        PRINT 'Inserted variant with barcode for: DRI-COL-1.5LT';
    END
END
GO

-- DRI-COL-125 - Barcode: 5449000140913
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-125';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000140913' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COL-125';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000140913', 1);
        PRINT 'Inserted variant with barcode for: DRI-COL-125';
    END
END
GO

-- DRI-COL-2LT - Barcode: 5449000050229
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000050229' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COL-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000050229', 1);
        PRINT 'Inserted variant with barcode for: DRI-COL-2LT';
    END
END
GO

-- DRI-COL-2LT - Barcode: 5449000050229
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000050229' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COL-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000050229', 1);
        PRINT 'Inserted variant with barcode for: DRI-COL-2LT';
    END
END
GO

-- DRI-COL-300C - Barcode: 549000256805
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-300C';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '549000256805' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COL-300C';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '549000256805', 1);
        PRINT 'Inserted variant with barcode for: DRI-COL-300C';
    END
END
GO

-- DRI-COL-330 - Barcode: 5449000050205
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000050205' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COL-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000050205', 1);
        PRINT 'Inserted variant with barcode for: DRI-COL-330';
    END
END
GO

-- DRI-COL-500 - Barcode: 5449000664709
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000664709' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COL-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000664709', 1);
        PRINT 'Inserted variant with barcode for: DRI-COL-500';
    END
END
GO

-- DRI-COZ-2LT - Barcode: 5449000131843
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COZ-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000131843' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COZ-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000131843', 1);
        PRINT 'Inserted variant with barcode for: DRI-COZ-2LT';
    END
END
GO

-- DRI-COZ-2LT - Barcode: 5449000131843
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COZ-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000131843' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COZ-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000131843', 1);
        PRINT 'Inserted variant with barcode for: DRI-COZ-2LT';
    END
END
GO

-- DRI-COZ-330 - Barcode: 5449000256898
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-COZ-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000256898' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-COZ-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000256898', 1);
        PRINT 'Inserted variant with barcode for: DRI-COZ-330';
    END
END
GO

-- DRI-CPP-EAC - Barcode: 5449000255792
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-CPP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000255792' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-CPP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000255792', 1);
        PRINT 'Inserted variant with barcode for: DRI-CPP-EAC';
    END
END
GO

-- DRI-CRE-400ML - Barcode: 5449000265364
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-CRE-400ML';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000265364' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-CRE-400ML';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000265364', 1);
        PRINT 'Inserted variant with barcode for: DRI-CRE-400ML';
    END
END
GO

-- DRI-CTP-330 - Barcode: 5449000255693
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-CTP-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000255693' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-CTP-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000255693', 1);
        PRINT 'Inserted variant with barcode for: DRI-CTP-330';
    END
END
GO

-- DRI-FAG-1LT - Barcode: 54490000252346
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAG-1LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '54490000252346' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAG-1LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '54490000252346', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAG-1LT';
    END
END
GO

-- DRI-FAG-2LT - Barcode: 5449000010070
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAG-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000010070' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAG-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000010070', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAG-2LT';
    END
END
GO

-- DRI-FAG-300 - Barcode: 2004
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAG-300';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '2004' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAG-300';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '2004', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAG-300';
    END
END
GO

-- DRI-FAG-330 - Barcode: 5449000257093
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAG-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000257093' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAG-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000257093', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAG-330';
    END
END
GO

-- DRI-FAG-500 - Barcode: 5449000664723
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAG-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000664723' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAG-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000664723', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAG-500';
    END
END
GO

-- DRI-FAN-440 - Barcode: 5449000257130
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAN-440';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000257130' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAN-440';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000257130', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAN-440';
    END
END
GO

-- DRI-FAO-2LT - Barcode: 5449000010049
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAO-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000010049' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAO-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000010049', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAO-2LT';
    END
END
GO

-- DRI-FAO-300 - Barcode: 2008
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAO-300';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '2008' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAO-300';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '2008', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAO-300';
    END
END
GO

-- DRI-FAO-330 - Barcode: 5449000257000
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAO-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000257000' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAO-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000257000', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAO-330';
    END
END
GO

-- DRI-FAO-500 - Barcode: 5449000664754
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAO-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000664754' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAO-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000664754', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAO-500';
    END
END
GO

-- DRI-FAP-2LT - Barcode: 5449000003768
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAP-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000003768' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAP-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000003768', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAP-2LT';
    END
END
GO

-- DRI-FAP-2LT - Barcode: 5449000003768
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAP-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000003768' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAP-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000003768', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAP-2LT';
    END
END
GO

-- DRI-FAP-300 - Barcode: 2007
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAP-300';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '2007' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAP-300';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '2007', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAP-300';
    END
END
GO

-- DRI-FAP-330 - Barcode: 5449000003201
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAP-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000003201' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAP-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000003201', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAP-330';
    END
END
GO

-- DRI-FAP-500 - Barcode: 5449000664747
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FAP-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000664747' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FAP-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000664747', 1);
        PRINT 'Inserted variant with barcode for: DRI-FAP-500';
    END
END
GO

-- DRI-FOC-500ML - Barcode: 5449000050809
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FOC-500ML';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000050809' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FOC-500ML';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000050809', 1);
        PRINT 'Inserted variant with barcode for: DRI-FOC-500ML';
    END
END
GO

-- DRI-FWT-400ML - Barcode: 5449000316332
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-FWT-400ML';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000316332' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-FWT-400ML';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000316332', 1);
        PRINT 'Inserted variant with barcode for: DRI-FWT-400ML';
    END
END
GO

-- DRI-GRA-275 - Barcode: 6001048003385
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-GRA-275';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001048003385' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-GRA-275';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001048003385', 1);
        PRINT 'Inserted variant with barcode for: DRI-GRA-275';
    END
END
GO

-- DRI-GRA-330 - Barcode: 6001048004511
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-GRA-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001048004511' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-GRA-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001048004511', 1);
        PRINT 'Inserted variant with barcode for: DRI-GRA-330';
    END
END
GO

-- DRI-GRW-330 - Barcode: 6001048003897
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-GRW-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001048003897' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-GRW-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001048003897', 1);
        PRINT 'Inserted variant with barcode for: DRI-GRW-330';
    END
END
GO

-- DRI-IRO-2LT - Barcode: 6001134297308
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-IRO-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001134297308' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-IRO-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001134297308', 1);
        PRINT 'Inserted variant with barcode for: DRI-IRO-2LT';
    END
END
GO

-- DRI-IRO-2LT - Barcode: 6001134297308
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-IRO-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001134297308' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-IRO-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001134297308', 1);
        PRINT 'Inserted variant with barcode for: DRI-IRO-2LT';
    END
END
GO

-- DRI-IRO-300 - Barcode: 2009
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-IRO-300';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '2009' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-IRO-300';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '2009', 1);
        PRINT 'Inserted variant with barcode for: DRI-IRO-300';
    END
END
GO

-- DRI-IRO-330 - Barcode: 5449000106261
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-IRO-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000106261' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-IRO-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000106261', 1);
        PRINT 'Inserted variant with barcode for: DRI-IRO-330';
    END
END
GO

-- DRI-KAPP-500ML - Barcode: 6001299049668
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-KAPP-500ML';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299049668' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-KAPP-500ML';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299049668', 1);
        PRINT 'Inserted variant with barcode for: DRI-KAPP-500ML';
    END
END
GO

-- DRI-KFF-500ML - Barcode: 6001299045813
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-KFF-500ML';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299045813' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-KFF-500ML';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299045813', 1);
        PRINT 'Inserted variant with barcode for: DRI-KFF-500ML';
    END
END
GO

-- DRI-KOR-500ML - Barcode: 6001299010101
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-KOR-500ML';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299010101' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-KOR-500ML';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299010101', 1);
        PRINT 'Inserted variant with barcode for: DRI-KOR-500ML';
    END
END
GO

-- DRI-MEN-500 - Barcode: 5060166698874
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-MEN-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5060166698874' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-MEN-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5060166698874', 1);
        PRINT 'Inserted variant with barcode for: DRI-MEN-500';
    END
END
GO

-- DRI-MML-500 - Barcode: 5060517888299
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-MML-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5060517888299' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-MML-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5060517888299', 1);
        PRINT 'Inserted variant with barcode for: DRI-MML-500';
    END
END
GO

-- DRI-MON-330 - Barcode: 5060517888664
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-MON-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5060517888664' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-MON-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5060517888664', 1);
        PRINT 'Inserted variant with barcode for: DRI-MON-330';
    END
END
GO

-- DRI-MON-EAC - Barcode: 5060337509411
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-MON-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5060337509411' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-MON-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5060337509411', 1);
        PRINT 'Inserted variant with barcode for: DRI-MON-EAC';
    END
END
GO

-- DRI-PBB-EAC - Barcode: 54490482
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-PBB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '54490482' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-PBB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '54490482', 1);
        PRINT 'Inserted variant with barcode for: DRI-PBB-EAC';
    END
END
GO

-- DRI-PGE-500 - Barcode: 5060517888848
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-PGE-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5060517888848' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-PGE-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5060517888848', 1);
        PRINT 'Inserted variant with barcode for: DRI-PGE-500';
    END
END
GO

-- DRI-PJI-EAC - Barcode: 90492488
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-PJI-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '90492488' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-PJI-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '90492488', 1);
        PRINT 'Inserted variant with barcode for: DRI-PJI-EAC';
    END
END
GO

-- DRI-PNA-500ML - Barcode: 90492501
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-PNA-500ML';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '90492501' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-PNA-500ML';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '90492501', 1);
        PRINT 'Inserted variant with barcode for: DRI-PNA-500ML';
    END
END
GO

-- DRI-REB-EAC - Barcode: 9002490100070
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-REB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '9002490100070' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-REB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '9002490100070', 1);
        PRINT 'Inserted variant with barcode for: DRI-REB-EAC';
    END
END
GO

-- DRI-RSF-EAC - Barcode: 9002490200220
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-RSF-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '9002490200220' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-RSF-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '9002490200220', 1);
        PRINT 'Inserted variant with barcode for: DRI-RSF-EAC';
    END
END
GO

-- DRI-SCS-125 - Barcode: 2017
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SCS-125';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '2017' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SCS-125';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '2017', 1);
        PRINT 'Inserted variant with barcode for: DRI-SCS-125';
    END
END
GO

-- DRI-SCS-2LT - Barcode: 6001134087305
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SCS-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001134087305' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SCS-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001134087305', 1);
        PRINT 'Inserted variant with barcode for: DRI-SCS-2LT';
    END
END
GO

-- DRI-SCS-300 - Barcode: 5449000257536
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SCS-300';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000257536' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SCS-300';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000257536', 1);
        PRINT 'Inserted variant with barcode for: DRI-SCS-300';
    END
END
GO

-- DRI-SCS-330 - Barcode: 5449000106322
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SCS-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000106322' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SCS-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000106322', 1);
        PRINT 'Inserted variant with barcode for: DRI-SCS-330';
    END
END
GO

-- DRI-SCS-500 - Barcode: 5449000664846
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SCS-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000664846' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SCS-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000664846', 1);
        PRINT 'Inserted variant with barcode for: DRI-SCS-500';
    END
END
GO

-- DRI-SIB-125 - Barcode: 2011
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SIB-125';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '2011' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SIB-125';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '2011', 1);
        PRINT 'Inserted variant with barcode for: DRI-SIB-125';
    END
END
GO

-- DRI-SPN-125 - Barcode: 2012
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SPN-125';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '2012' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SPN-125';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '2012', 1);
        PRINT 'Inserted variant with barcode for: DRI-SPN-125';
    END
END
GO

-- DRI-SPN-2LT - Barcode: 5449000117977
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SPN-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000117977' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SPN-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000117977', 1);
        PRINT 'Inserted variant with barcode for: DRI-SPN-2LT';
    END
END
GO

-- DRI-SPR-125 - Barcode: 5449000234612
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-125';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000234612' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SPR-125';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000234612', 1);
        PRINT 'Inserted variant with barcode for: DRI-SPR-125';
    END
END
GO

-- DRI-SPR-2LT - Barcode: 5449000234636
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000234636' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SPR-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000234636', 1);
        PRINT 'Inserted variant with barcode for: DRI-SPR-2LT';
    END
END
GO

-- DRI-SPR-300 - Barcode: 5449000257222
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-300';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000257222' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SPR-300';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000257222', 1);
        PRINT 'Inserted variant with barcode for: DRI-SPR-300';
    END
END
GO

-- DRI-SPR-330 - Barcode: 5449000014535
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000014535' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SPR-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000014535', 1);
        PRINT 'Inserted variant with barcode for: DRI-SPR-330';
    END
END
GO

-- DRI-SPR-440 - Barcode: 5449000257239
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-440';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000257239' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SPR-440';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000257239', 1);
        PRINT 'Inserted variant with barcode for: DRI-SPR-440';
    END
END
GO

-- DRI-SPR-500 - Barcode: 5449000234643
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000234643' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SPR-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000234643', 1);
        PRINT 'Inserted variant with barcode for: DRI-SPR-500';
    END
END
GO

-- DRI-SPZ-2LT - Barcode: 5449000104885
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SPZ-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000104885' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SPZ-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000104885', 1);
        PRINT 'Inserted variant with barcode for: DRI-SPZ-2LT';
    END
END
GO

-- DRI-SPZ-330 - Barcode: 5449000106704
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SPZ-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000106704' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SPZ-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000106704', 1);
        PRINT 'Inserted variant with barcode for: DRI-SPZ-330';
    END
END
GO

-- DRI-SPZ-500 - Barcode: 5449000109613
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SPZ-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000109613' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SPZ-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000109613', 1);
        PRINT 'Inserted variant with barcode for: DRI-SPZ-500';
    END
END
GO

-- DRI-SRB-500 - Barcode: 5449000664853
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SRB-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000664853' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SRB-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000664853', 1);
        PRINT 'Inserted variant with barcode for: DRI-SRB-500';
    END
END
GO

-- DRI-SSB-125 - Barcode: 6001134005507
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SSB-125';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001134005507' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SSB-125';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001134005507', 1);
        PRINT 'Inserted variant with barcode for: DRI-SSB-125';
    END
END
GO

-- DRI-SSB-2LT - Barcode: 6001134687307
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SSB-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001134687307' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SSB-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001134687307', 1);
        PRINT 'Inserted variant with barcode for: DRI-SSB-2LT';
    END
END
GO

-- DRI-SSB-330 - Barcode: 5449000257628
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SSB-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000257628' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SSB-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000257628', 1);
        PRINT 'Inserted variant with barcode for: DRI-SSB-330';
    END
END
GO

-- DRI-SST-300 - Barcode: 5449000257420
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SST-300';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000257420' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SST-300';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000257420', 1);
        PRINT 'Inserted variant with barcode for: DRI-SST-300';
    END
END
GO

-- DRI-SST-330 - Barcode: 5449000106421
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-SST-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000106421' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-SST-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000106421', 1);
        PRINT 'Inserted variant with barcode for: DRI-SST-330';
    END
END
GO

-- DRI-STO-125 - Barcode: 5449000064950
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-STO-125';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000064950' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-STO-125';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000064950', 1);
        PRINT 'Inserted variant with barcode for: DRI-STO-125';
    END
END
GO

-- DRI-STO-2LT - Barcode: 6001134707302
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-STO-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001134707302' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-STO-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001134707302', 1);
        PRINT 'Inserted variant with barcode for: DRI-STO-2LT';
    END
END
GO

-- DRI-STO-440 - Barcode: 5449000257413
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-STO-440';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000257413' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-STO-440';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000257413', 1);
        PRINT 'Inserted variant with barcode for: DRI-STO-440';
    END
END
GO

-- DRI-STO-500 - Barcode: 5449000664808
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-STO-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000664808' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-STO-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000664808', 1);
        PRINT 'Inserted variant with barcode for: DRI-STO-500';
    END
END
GO

-- DRI-STW-500 - Barcode: 6009633490022
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-STW-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009633490022' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-STW-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009633490022', 1);
        PRINT 'Inserted variant with barcode for: DRI-STW-500';
    END
END
GO

-- DRI-STW-EAC - Barcode: 30607
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-STW-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30607' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-STW-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30607', 1);
        PRINT 'Inserted variant with barcode for: DRI-STW-EAC';
    END
END
GO

-- DRI-TGR-1.5L - Barcode: 5449000180889
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-TGR-1.5L';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000180889' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-TGR-1.5L';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000180889', 1);
        PRINT 'Inserted variant with barcode for: DRI-TGR-1.5L';
    END
END
GO

-- DRI-TWG-125 - Barcode: 6001133001104
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-125';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001133001104' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-TWG-125';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001133001104', 1);
        PRINT 'Inserted variant with barcode for: DRI-TWG-125';
    END
END
GO

-- DRI-TWG-2LT - Barcode: 5449000098580
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000098580' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-TWG-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000098580', 1);
        PRINT 'Inserted variant with barcode for: DRI-TWG-2LT';
    END
END
GO

-- DRI-TWG-2LT - Barcode: 5449000098580
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000098580' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-TWG-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000098580', 1);
        PRINT 'Inserted variant with barcode for: DRI-TWG-2LT';
    END
END
GO

-- DRI-TWG-300 - Barcode: 2016
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-300';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '2016' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-TWG-300';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '2016', 1);
        PRINT 'Inserted variant with barcode for: DRI-TWG-300';
    END
END
GO

-- DRI-TWG-330 - Barcode: 5449000257567
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000257567' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-TWG-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000257567', 1);
        PRINT 'Inserted variant with barcode for: DRI-TWG-330';
    END
END
GO

-- DRI-TWG-500 - Barcode: 5449000664839
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000664839' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-TWG-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000664839', 1);
        PRINT 'Inserted variant with barcode for: DRI-TWG-500';
    END
END
GO

-- DRI-TWL-125 - Barcode: 6001134395509
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-TWL-125';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001134395509' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-TWL-125';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001134395509', 1);
        PRINT 'Inserted variant with barcode for: DRI-TWL-125';
    END
END
GO

-- DRI-TWL-2LT - Barcode: 5449000060082
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-TWL-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000060082' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-TWL-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000060082', 1);
        PRINT 'Inserted variant with barcode for: DRI-TWL-2LT';
    END
END
GO

-- DRI-TWL-330 - Barcode: 5449000257505
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-TWL-330';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000257505' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-TWL-330';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000257505', 1);
        PRINT 'Inserted variant with barcode for: DRI-TWL-330';
    END
END
GO

-- DRI-TWL-500 - Barcode: 40822747
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-TWL-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '40822747' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-TWL-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '40822747', 1);
        PRINT 'Inserted variant with barcode for: DRI-TWL-500';
    END
END
GO

-- DRI-VAL-150 - Barcode: 5449000107787
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-VAL-150';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000107787' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-VAL-150';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000107787', 1);
        PRINT 'Inserted variant with barcode for: DRI-VAL-150';
    END
END
GO

-- DRI-VAL-500 - Barcode: 5449000107664
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-VAL-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000107664' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-VAL-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000107664', 1);
        PRINT 'Inserted variant with barcode for: DRI-VAL-500';
    END
END
GO

-- DRI-WTF-2LTR - Barcode: 5449000308146
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'DRI-WTF-2LTR';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5449000308146' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: DRI-WTF-2LTR';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5449000308146', 1);
        PRINT 'Inserted variant with barcode for: DRI-WTF-2LTR';
    END
END
GO

-- JUI- FNB-500ML - Barcode: 6001299024634
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI- FNB-500ML';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299024634' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI- FNB-500ML';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299024634', 1);
        PRINT 'Inserted variant with barcode for: JUI- FNB-500ML';
    END
END
GO

-- JUI-EBL-500 - Barcode: 6001324254371
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-EBL-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001324254371' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-EBL-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001324254371', 1);
        PRINT 'Inserted variant with barcode for: JUI-EBL-500';
    END
END
GO

-- JUI-EGR-500 - Barcode: 6001324238098
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-EGR-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001324238098' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-EGR-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001324238098', 1);
        PRINT 'Inserted variant with barcode for: JUI-EGR-500';
    END
END
GO

-- JUI-ELL-500 - Barcode: 6001324217338
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-ELL-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001324217338' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-ELL-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001324217338', 1);
        PRINT 'Inserted variant with barcode for: JUI-ELL-500';
    END
END
GO

-- JUI-EMB-500 - Barcode: 6001324299556
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-EMB-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001324299556' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-EMB-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001324299556', 1);
        PRINT 'Inserted variant with barcode for: JUI-EMB-500';
    END
END
GO

-- JUI-ENA-500 - Barcode: 6001324217253
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-ENA-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001324217253' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-ENA-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001324217253', 1);
        PRINT 'Inserted variant with barcode for: JUI-ENA-500';
    END
END
GO

-- JUI-ENO-500 - Barcode: 6001324217178
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-ENO-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001324217178' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-ENO-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001324217178', 1);
        PRINT 'Inserted variant with barcode for: JUI-ENO-500';
    END
END
GO

-- JUI-ETR-500 - Barcode: 6001324238173
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-ETR-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001324238173' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-ETR-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001324238173', 1);
        PRINT 'Inserted variant with barcode for: JUI-ETR-500';
    END
END
GO

-- JUI-KRM-500ML - Barcode: 6001299010118
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-KRM-500ML';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299010118' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-KRM-500ML';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299010118', 1);
        PRINT 'Inserted variant with barcode for: JUI-KRM-500ML';
    END
END
GO

-- JUI-ORA-2LT - Barcode: 6001299043079
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-ORA-2LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299043079' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-ORA-2LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299043079', 1);
        PRINT 'Inserted variant with barcode for: JUI-ORA-2LT';
    END
END
GO

-- JUI-ORA-500 - Barcode: 6001299007521
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-ORA-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299007521' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-ORA-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299007521', 1);
        PRINT 'Inserted variant with barcode for: JUI-ORA-500';
    END
END
GO

-- JUI-PIN-1LT - Barcode: 6001299015793
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-PIN-1LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299015793' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-PIN-1LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299015793', 1);
        PRINT 'Inserted variant with barcode for: JUI-PIN-1LT';
    END
END
GO

-- JUI-TRO-1.5L - Barcode: 6001299015724
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-TRO-1.5L';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299015724' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-TRO-1.5L';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299015724', 1);
        PRINT 'Inserted variant with barcode for: JUI-TRO-1.5L';
    END
END
GO

-- JUI-TRO-1.5Lt - Barcode: 6001299015687
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-TRO-1.5Lt';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299015687' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-TRO-1.5Lt';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299015687', 1);
        PRINT 'Inserted variant with barcode for: JUI-TRO-1.5Lt';
    END
END
GO

-- JUI-TRO-1LT - Barcode: 6001299008054
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-TRO-1LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299008054' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-TRO-1LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299008054', 1);
        PRINT 'Inserted variant with barcode for: JUI-TRO-1LT';
    END
END
GO

-- JUI-TRO-500 - Barcode: 6001299007965
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-TRO-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299007965' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-TRO-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299007965', 1);
        PRINT 'Inserted variant with barcode for: JUI-TRO-500';
    END
END
GO

-- JUI-TRP-1LT - Barcode: 6001299008115
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-TRP-1LT';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299008115' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-TRP-1LT';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299008115', 1);
        PRINT 'Inserted variant with barcode for: JUI-TRP-1LT';
    END
END
GO

-- JUI-TRP-250 - Barcode: 6001299008092
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-TRP-250';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299008092' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-TRP-250';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299008092', 1);
        PRINT 'Inserted variant with barcode for: JUI-TRP-250';
    END
END
GO

-- JUI-TRP-500 - Barcode: 6001299007972
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'JUI-TRP-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299007972' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: JUI-TRP-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299007972', 1);
        PRINT 'Inserted variant with barcode for: JUI-TRP-500';
    END
END
GO

-- MIL-SMB-EAC - Barcode: 6001299044540
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIL-SMB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299044540' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIL-SMB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299044540', 1);
        PRINT 'Inserted variant with barcode for: MIL-SMB-EAC';
    END
END
GO

-- MIL-SMC-EAC - Barcode: 6001299044601
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIL-SMC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299044601' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIL-SMC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299044601', 1);
        PRINT 'Inserted variant with barcode for: MIL-SMC-EAC';
    END
END
GO

-- MIL-SMO-EAC - Barcode: 6001299044663
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIL-SMO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299044663' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIL-SMO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299044663', 1);
        PRINT 'Inserted variant with barcode for: MIL-SMO-EAC';
    END
END
GO

-- MIL-SMS-EAC - Barcode: 6001299044519
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIL-SMS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001299044519' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIL-SMS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001299044519', 1);
        PRINT 'Inserted variant with barcode for: MIL-SMS-EAC';
    END
END
GO

-- CEX- BEG-EAC - Barcode: 14050
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX- BEG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14050' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX- BEG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14050', 1);
        PRINT 'Inserted variant with barcode for: CEX- BEG-EAC';
    END
END
GO

-- CEX CCD-EAC - Barcode: 14030
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX CCD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14030' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX CCD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14030', 1);
        PRINT 'Inserted variant with barcode for: CEX CCD-EAC';
    END
END
GO

-- CEX- MCP-EAC - Barcode: 14091
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX- MCP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14091' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX- MCP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14091', 1);
        PRINT 'Inserted variant with barcode for: CEX- MCP-EAC';
    END
END
GO

-- CEX -NYW-EAC - Barcode: 30665
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX -NYW-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30665' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX -NYW-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30665', 1);
        PRINT 'Inserted variant with barcode for: CEX -NYW-EAC';
    END
END
GO

-- CEX-AMB-EAC - Barcode: 14001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-AMB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-AMB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14001', 1);
        PRINT 'Inserted variant with barcode for: CEX-AMB-EAC';
    END
END
GO

-- CEX-APP-EAC - Barcode: 14025
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-APP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14025' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-APP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14025', 1);
        PRINT 'Inserted variant with barcode for: CEX-APP-EAC';
    END
END
GO

-- CEX-BAR-012 - Barcode: 10001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-BAR-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-BAR-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10001', 1);
        PRINT 'Inserted variant with barcode for: CEX-BAR-012';
    END
END
GO

-- CEX-BAR-014 - Barcode: 10002
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-BAR-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10002' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-BAR-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10002', 1);
        PRINT 'Inserted variant with barcode for: CEX-BAR-014';
    END
END
GO

-- CEX-BAR-016 - Barcode: 10003
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-BAR-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10003' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-BAR-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10003', 1);
        PRINT 'Inserted variant with barcode for: CEX-BAR-016';
    END
END
GO

-- CEX-BCC-EAC - Barcode: 14027
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-BCC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14027' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-BCC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14027', 1);
        PRINT 'Inserted variant with barcode for: CEX-BCC-EAC';
    END
END
GO

-- CEX-BOL-EAC - Barcode: 4005
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-BOL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '4005' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-BOL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '4005', 1);
        PRINT 'Inserted variant with barcode for: CEX-BOL-EAC';
    END
END
GO

-- CEX-BOM-EAC - Barcode: 14065
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-BOM-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14065' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-BOM-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14065', 1);
        PRINT 'Inserted variant with barcode for: CEX-BOM-EAC';
    END
END
GO

-- CEX-BOR-EAC - Barcode: 14003
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-BOR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14003' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-BOR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14003', 1);
        PRINT 'Inserted variant with barcode for: CEX-BOR-EAC';
    END
END
GO

-- CEX-BOS-EAC - Barcode: 4008
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-BOS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '4008' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-BOS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '4008', 1);
        PRINT 'Inserted variant with barcode for: CEX-BOS-EAC';
    END
END
GO

-- CEX-BRC-EAC - Barcode: 14028
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-BRC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14028' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-BRC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14028', 1);
        PRINT 'Inserted variant with barcode for: CEX-BRC-EAC';
    END
END
GO

-- CEX-CBO-EAC - Barcode: 14006
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-CBO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14006' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-CBO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14006', 1);
        PRINT 'Inserted variant with barcode for: CEX-CBO-EAC';
    END
END
GO

-- CEX-CCC-EAC - Barcode: 14033
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-CCC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14033' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-CCC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14033', 1);
        PRINT 'Inserted variant with barcode for: CEX-CCC-EAC';
    END
END
GO

-- CEX-CCP-6S - Barcode: 140295
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-CCP-6S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '140295' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-CCP-6S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '140295', 1);
        PRINT 'Inserted variant with barcode for: CEX-CCP-6S';
    END
END
GO

-- CEX-CCS-EAC - Barcode: 14007
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-CCS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14007' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-CCS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14007', 1);
        PRINT 'Inserted variant with barcode for: CEX-CCS-EAC';
    END
END
GO

-- CEX-CCT-EAC - Barcode: 14008
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-CCT-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14008' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-CCT-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14008', 1);
        PRINT 'Inserted variant with barcode for: CEX-CCT-EAC';
    END
END
GO

-- CEX-CEG-EAC - Barcode: 14035
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-CEG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14035' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-CEG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14035', 1);
        PRINT 'Inserted variant with barcode for: CEX-CEG-EAC';
    END
END
GO

-- CEX-CFE-EAC - Barcode: 14010
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-CFE-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14010' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-CFE-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14010', 1);
        PRINT 'Inserted variant with barcode for: CEX-CFE-EAC';
    END
END
GO

-- CEX-CHC-EAC - Barcode: 14036
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-CHC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14036' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-CHC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14036', 1);
        PRINT 'Inserted variant with barcode for: CEX-CHC-EAC';
    END
END
GO

-- CEX-CIC-EAC - Barcode: 14037
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-CIC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14037' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-CIC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14037', 1);
        PRINT 'Inserted variant with barcode for: CEX-CIC-EAC';
    END
END
GO

-- CEX-CRM-EAC - Barcode: 14199
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-CRM-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14199' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-CRM-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14199', 1);
        PRINT 'Inserted variant with barcode for: CEX-CRM-EAC';
    END
END
GO

-- CEX-CUS-EAC - Barcode: 14042
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-CUS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14042' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-CUS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14042', 1);
        PRINT 'Inserted variant with barcode for: CEX-CUS-EAC';
    END
END
GO

-- CEX-DCV-EAC - Barcode: 14044
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-DCV-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14044' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-DCV-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14044', 1);
        PRINT 'Inserted variant with barcode for: CEX-DCV-EAC';
    END
END
GO

-- CEX-FEM-EAC - Barcode: 14045
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-FEM-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14045' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-FEM-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14045', 1);
        PRINT 'Inserted variant with barcode for: CEX-FEM-EAC';
    END
END
GO

-- CEX-FER-012 - Barcode: 10075
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-FER-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10075' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-FER-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10075', 1);
        PRINT 'Inserted variant with barcode for: CEX-FER-012';
    END
END
GO

-- CEX-FER-014 - Barcode: 10076
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-FER-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10076' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-FER-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10076', 1);
        PRINT 'Inserted variant with barcode for: CEX-FER-014';
    END
END
GO

-- CEX-FER-016 - Barcode: 10077
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-FER-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10077' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-FER-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10077', 1);
        PRINT 'Inserted variant with barcode for: CEX-FER-016';
    END
END
GO

-- CEX-FRC-EAC - Barcode: 14012
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-FRC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14012' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-FRC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14012', 1);
        PRINT 'Inserted variant with barcode for: CEX-FRC-EAC';
    END
END
GO

-- CEX-GIM-EAC - Barcode: 14046
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-GIM-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14046' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-GIM-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14046', 1);
        PRINT 'Inserted variant with barcode for: CEX-GIM-EAC';
    END
END
GO

-- CEX-MAC-EAC - Barcode: 14047
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-MAC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14047' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-MAC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14047', 1);
        PRINT 'Inserted variant with barcode for: CEX-MAC-EAC';
    END
END
GO

-- CEX-MAL-EAC - Barcode: 14048
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-MAL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14048' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-MAL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14048', 1);
        PRINT 'Inserted variant with barcode for: CEX-MAL-EAC';
    END
END
GO

-- CEX-MBE-EAC - Barcode: 14049
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-MBE-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14049' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-MBE-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14049', 1);
        PRINT 'Inserted variant with barcode for: CEX-MBE-EAC';
    END
END
GO

-- CEX-MVC-EAC - Barcode: 14092
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-MVC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14092' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-MVC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14092', 1);
        PRINT 'Inserted variant with barcode for: CEX-MVC-EAC';
    END
END
GO

-- CEX-NRV-EAC - Barcode: 14057
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-NRV-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14057' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-NRV-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14057', 1);
        PRINT 'Inserted variant with barcode for: CEX-NRV-EAC';
    END
END
GO

-- CEX-PMC-EACH - Barcode: 14014
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-PMC-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14014' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-PMC-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14014', 1);
        PRINT 'Inserted variant with barcode for: CEX-PMC-EACH';
    END
END
GO

-- CEX-PNT-EAC - Barcode: 14016
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-PNT-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14016' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-PNT-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14016', 1);
        PRINT 'Inserted variant with barcode for: CEX-PNT-EAC';
    END
END
GO

-- CEX-RCC-EAC - Barcode: 14058
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-RCC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14058' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-RCC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14058', 1);
        PRINT 'Inserted variant with barcode for: CEX-RCC-EAC';
    END
END
GO

-- CEX-REC-EAC - Barcode: 14038
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-REC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14038' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-REC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14038', 1);
        PRINT 'Inserted variant with barcode for: CEX-REC-EAC';
    END
END
GO

-- CEX-RED-016 - Barcode: 30778
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-RED-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30778' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-RED-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30778', 1);
        PRINT 'Inserted variant with barcode for: CEX-RED-016';
    END
END
GO

-- CEX-RMC-EAC - Barcode: 14059
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-RMC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14059' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-RMC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14059', 1);
        PRINT 'Inserted variant with barcode for: CEX-RMC-EAC';
    END
END
GO

-- CEX-RSW-EAC - Barcode: 14060
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-RSW-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14060' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-RSW-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14060', 1);
        PRINT 'Inserted variant with barcode for: CEX-RSW-EAC';
    END
END
GO

-- CEX-RVC-EAC - Barcode: 14017
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-RVC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14017' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-RVC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14017', 1);
        PRINT 'Inserted variant with barcode for: CEX-RVC-EAC';
    END
END
GO

-- CEX-RVG-EAC - Barcode: 30776
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-RVG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30776' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-RVG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30776', 1);
        PRINT 'Inserted variant with barcode for: CEX-RVG-EAC';
    END
END
GO

-- CEX-RVL-EAC - Barcode: 14019
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-RVL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14019' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-RVL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14019', 1);
        PRINT 'Inserted variant with barcode for: CEX-RVL-EAC';
    END
END
GO

-- CEX-RVS-EAC - Barcode: 14020
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-RVS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14020' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-RVS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14020', 1);
        PRINT 'Inserted variant with barcode for: CEX-RVS-EAC';
    END
END
GO

-- CEX-TIR-EAC - Barcode: 14021
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-TIR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14021' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-TIR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14021', 1);
        PRINT 'Inserted variant with barcode for: CEX-TIR-EAC';
    END
END
GO

-- CEX-TIS-EAC - Barcode: 14022
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-TIS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14022' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-TIS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14022', 1);
        PRINT 'Inserted variant with barcode for: CEX-TIS-EAC';
    END
END
GO

-- CEX-TRF-EAC - Barcode: 14062
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-TRF-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14062' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-TRF-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14062', 1);
        PRINT 'Inserted variant with barcode for: CEX-TRF-EAC';
    END
END
GO

-- CEX-TRO-EAC - Barcode: 14023
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-TRO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14023' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-TRO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14023', 1);
        PRINT 'Inserted variant with barcode for: CEX-TRO-EAC';
    END
END
GO

-- CEX-TRU-EAC - Barcode: 14061
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-TRU-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14061' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-TRU-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14061', 1);
        PRINT 'Inserted variant with barcode for: CEX-TRU-EAC';
    END
END
GO

-- CEX-VAC-EAC - Barcode: 14039
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-VAC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14039' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-VAC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14039', 1);
        PRINT 'Inserted variant with barcode for: CEX-VAC-EAC';
    END
END
GO

-- CFC-FCP-EAC - Barcode: 12030
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FCP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12030' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FCP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12030', 1);
        PRINT 'Inserted variant with barcode for: CFC-FCP-EAC';
    END
END
GO

-- CFC-FMS-EAC - Barcode: 12011
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FMS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12011' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FMS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12011', 1);
        PRINT 'Inserted variant with barcode for: CFC-FMS-EAC';
    END
END
GO

-- ICE-SMO-EAC - Barcode: 6001087357821
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'ICE-SMO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001087357821' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: ICE-SMO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001087357821', 1);
        PRINT 'Inserted variant with barcode for: ICE-SMO-EAC';
    END
END
GO

-- ICE-SRP-EAC - Barcode: 6001087357814
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'ICE-SRP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001087357814' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: ICE-SRP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001087357814', 1);
        PRINT 'Inserted variant with barcode for: ICE-SRP-EAC';
    END
END
GO

-- YCC-MMC-EAC - Barcode: 30831
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'YCC-MMC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30831' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: YCC-MMC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30831', 1);
        PRINT 'Inserted variant with barcode for: YCC-MMC-EAC';
    END
END
GO

-- CBF-BLF-014 - Barcode: 12001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-BLF-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-BLF-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12001', 1);
        PRINT 'Inserted variant with barcode for: CBF-BLF-014';
    END
END
GO

-- CBF-BLF-016 - Barcode: 12020
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-BLF-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12020' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-BLF-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12020', 1);
        PRINT 'Inserted variant with barcode for: CBF-BLF-016';
    END
END
GO

-- CBF-FCD-014 - Barcode: 10039
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-FCD-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10039' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-FCD-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10039', 1);
        PRINT 'Inserted variant with barcode for: CBF-FCD-014';
    END
END
GO

-- CBF-FCF-018 - Barcode: 10089
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-FCF-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10089' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-FCF-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10089', 1);
        PRINT 'Inserted variant with barcode for: CBF-FCF-018';
    END
END
GO

-- CBF-FCF-020 - Barcode: 10091
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-FCF-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10091' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-FCF-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10091', 1);
        PRINT 'Inserted variant with barcode for: CBF-FCF-020';
    END
END
GO

-- CBF-FFE-020 - Barcode: 10198
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-FFE-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10198' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-FFE-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10198', 1);
        PRINT 'Inserted variant with barcode for: CBF-FFE-020';
    END
END
GO

-- CBF-FFS-018 - Barcode: 10093
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-FFS-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10093' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-FFS-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10093', 1);
        PRINT 'Inserted variant with barcode for: CBF-FFS-018';
    END
END
GO

-- CBF-FFS-020 - Barcode: 10095
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-FFS-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10095' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-FFS-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10095', 1);
        PRINT 'Inserted variant with barcode for: CBF-FFS-020';
    END
END
GO

-- CBR-FCR-012 - Barcode: 10106
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBR-FCR-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10106' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBR-FCR-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10106', 1);
        PRINT 'Inserted variant with barcode for: CBR-FCR-012';
    END
END
GO

-- CBR-FCR-014 - Barcode: 10108
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBR-FCR-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10108' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBR-FCR-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10108', 1);
        PRINT 'Inserted variant with barcode for: CBR-FCR-014';
    END
END
GO

-- CBR-FCR-016 - Barcode: 10110
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBR-FCR-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10110' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBR-FCR-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10110', 1);
        PRINT 'Inserted variant with barcode for: CBR-FCR-016';
    END
END
GO

-- CBR-FCR-018 - Barcode: 10111
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBR-FCR-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10111' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBR-FCR-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10111', 1);
        PRINT 'Inserted variant with barcode for: CBR-FCR-018';
    END
END
GO

-- CBR-FCR-020 - Barcode: 10113
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBR-FCR-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10113' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBR-FCR-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10113', 1);
        PRINT 'Inserted variant with barcode for: CBR-FCR-020';
    END
END
GO

-- CBS-BLF-012 - Barcode: 10078
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-BLF-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10078' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-BLF-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10078', 1);
        PRINT 'Inserted variant with barcode for: CBS-BLF-012';
    END
END
GO

-- CBS-FCD-012 - Barcode: 10037
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-FCD-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10037' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-FCD-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10037', 1);
        PRINT 'Inserted variant with barcode for: CBS-FCD-012';
    END
END
GO

-- CBS-FCD-016 - Barcode: 10041
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-FCD-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10041' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-FCD-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10041', 1);
        PRINT 'Inserted variant with barcode for: CBS-FCD-016';
    END
END
GO

-- CBS-FCD-018 - Barcode: 10045
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-FCD-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10045' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-FCD-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10045', 1);
        PRINT 'Inserted variant with barcode for: CBS-FCD-018';
    END
END
GO

-- CBS-FCD-020 - Barcode: 10050
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-FCD-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10050' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-FCD-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10050', 1);
        PRINT 'Inserted variant with barcode for: CBS-FCD-020';
    END
END
GO

-- CBS-FCD-022 - Barcode: 10054
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-FCD-022';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10054' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-FCD-022';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10054', 1);
        PRINT 'Inserted variant with barcode for: CBS-FCD-022';
    END
END
GO

-- CBS-FCE-016 - Barcode: 10103
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBS-FCE-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10103' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBS-FCE-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10103', 1);
        PRINT 'Inserted variant with barcode for: CBS-FCE-016';
    END
END
GO

-- CNO-FC1-1X5 - Barcode: 10084
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FC1-1X5';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10084' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FC1-1X5';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10084', 1);
        PRINT 'Inserted variant with barcode for: CNO-FC1-1X5';
    END
END
GO

-- CFC-BET-EAC - Barcode: 12022
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-BET-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12022' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-BET-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12022', 1);
        PRINT 'Inserted variant with barcode for: CFC-BET-EAC';
    END
END
GO

-- CFC-BTL-EAC - Barcode: 12023
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-BTL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12023' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-BTL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12023', 1);
        PRINT 'Inserted variant with barcode for: CFC-BTL-EAC';
    END
END
GO

-- CFC-CBS-EAC - Barcode: 12009
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-CBS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12009' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-CBS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12009', 1);
        PRINT 'Inserted variant with barcode for: CFC-CBS-EAC';
    END
END
GO

-- CFC-CCC-EAC - Barcode: 30866
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-CCC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30866' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-CCC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30866', 1);
        PRINT 'Inserted variant with barcode for: CFC-CCC-EAC';
    END
END
GO

-- CFC-CCD-EAC - Barcode: 12035
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-CCD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12035' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-CCD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12035', 1);
        PRINT 'Inserted variant with barcode for: CFC-CCD-EAC';
    END
END
GO

-- CFC-CFD-EAC - Barcode: 15049
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-CFD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15049' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-CFD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15049', 1);
        PRINT 'Inserted variant with barcode for: CFC-CFD-EAC';
    END
END
GO

-- CFC-CUD-EAC - Barcode: 12024
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-CUD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12024' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-CUD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12024', 1);
        PRINT 'Inserted variant with barcode for: CFC-CUD-EAC';
    END
END
GO

-- CFC-CUS-EAC - Barcode: 12025
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-CUS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12025' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-CUS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12025', 1);
        PRINT 'Inserted variant with barcode for: CFC-CUS-EAC';
    END
END
GO

-- CFC-FBF-EAC - Barcode: 12004
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FBF-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12004' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FBF-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12004', 1);
        PRINT 'Inserted variant with barcode for: CFC-FBF-EAC';
    END
END
GO

-- CFC-FBG-EAC - Barcode: 12002
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FBG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12002' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FBG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12002', 1);
        PRINT 'Inserted variant with barcode for: CFC-FBG-EAC';
    END
END
GO

-- CFC-FCD-EAC - Barcode: 12015
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FCD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12015' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FCD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12015', 1);
        PRINT 'Inserted variant with barcode for: CFC-FCD-EAC';
    END
END
GO

-- CFC-FCE-EAC - Barcode: 12027
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FCE-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12027' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FCE-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12027', 1);
        PRINT 'Inserted variant with barcode for: CFC-FCE-EAC';
    END
END
GO

-- CFC-FCG-EAC - Barcode: 12006
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FCG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12006' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FCG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12006', 1);
        PRINT 'Inserted variant with barcode for: CFC-FCG-EAC';
    END
END
GO

-- CFC-FCJ-EAC - Barcode: 12037
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FCJ-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12037' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FCJ-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12037', 1);
        PRINT 'Inserted variant with barcode for: CFC-FCJ-EAC';
    END
END
GO

-- CFC-FCL-EAC - Barcode: 12010
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FCL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12010' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FCL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12010', 1);
        PRINT 'Inserted variant with barcode for: CFC-FCL-EAC';
    END
END
GO

-- CFC-FCM-EAC - Barcode: 12012
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FCM-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12012' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FCM-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12012', 1);
        PRINT 'Inserted variant with barcode for: CFC-FCM-EAC';
    END
END
GO

-- CFC-FCR-EAC - Barcode: 12026
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FCR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12026' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FCR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12026', 1);
        PRINT 'Inserted variant with barcode for: CFC-FCR-EAC';
    END
END
GO

-- CFC-FCS-EAC - Barcode: 12014
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FCS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12014' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FCS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12014', 1);
        PRINT 'Inserted variant with barcode for: CFC-FCS-EAC';
    END
END
GO

-- CFC-FDD-EAC - Barcode: 8102
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FDD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8102' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FDD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8102', 1);
        PRINT 'Inserted variant with barcode for: CFC-FDD-EAC';
    END
END
GO

-- CFC-FEB-EAC - Barcode: 30519
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FEB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30519' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FEB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30519', 1);
        PRINT 'Inserted variant with barcode for: CFC-FEB-EAC';
    END
END
GO

-- CFC-FEG-EAC - Barcode: 12007
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FEG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12007' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FEG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12007', 1);
        PRINT 'Inserted variant with barcode for: CFC-FEG-EAC';
    END
END
GO

-- CFC-FES-EAC - Barcode: 30621
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FES-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30621' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FES-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30621', 1);
        PRINT 'Inserted variant with barcode for: CFC-FES-EAC';
    END
END
GO

-- CFC-FRL-EAC - Barcode: 12013
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FRL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12013' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FRL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12013', 1);
        PRINT 'Inserted variant with barcode for: CFC-FRL-EAC';
    END
END
GO

-- CFC-FSS-EAC - Barcode: 12031
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FSS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12031' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FSS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12031', 1);
        PRINT 'Inserted variant with barcode for: CFC-FSS-EAC';
    END
END
GO

-- CFC-MEG-EAC - Barcode: 12034
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-MEG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12034' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-MEG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12034', 1);
        PRINT 'Inserted variant with barcode for: CFC-MEG-EAC';
    END
END
GO

-- CFC-MFG-EAC - Barcode: 12033
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-MFG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12033' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-MFG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12033', 1);
        PRINT 'Inserted variant with barcode for: CFC-MFG-EAC';
    END
END
GO

-- CFC-MTA-EAC - Barcode: 12028
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-MTA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12028' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-MTA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12028', 1);
        PRINT 'Inserted variant with barcode for: CFC-MTA-EAC';
    END
END
GO

-- CFC-MTL-EAC - Barcode: 12029
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-MTL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12029' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-MTL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12029', 1);
        PRINT 'Inserted variant with barcode for: CFC-MTL-EAC';
    END
END
GO

-- CFC-NOB-EAC - Barcode: 12032
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-NOB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '12032' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-NOB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '12032', 1);
        PRINT 'Inserted variant with barcode for: CFC-NOB-EAC';
    END
END
GO

-- CFC-SEF-EAC - Barcode: 30670
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-SEF-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30670' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-SEF-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30670', 1);
        PRINT 'Inserted variant with barcode for: CFC-SEF-EAC';
    END
END
GO

-- CFC-FRU-010 - Barcode: 10079
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FRU-010';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10079' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FRU-010';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10079', 1);
        PRINT 'Inserted variant with barcode for: CFC-FRU-010';
    END
END
GO

-- CFC-FRU-012 - Barcode: 10080
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FRU-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10080' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FRU-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10080', 1);
        PRINT 'Inserted variant with barcode for: CFC-FRU-012';
    END
END
GO

-- CFC-FRU-014 - Barcode: 10081
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FRU-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10081' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FRU-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10081', 1);
        PRINT 'Inserted variant with barcode for: CFC-FRU-014';
    END
END
GO

-- CFC-FRU-016 - Barcode: 10082
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFC-FRU-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10082' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFC-FRU-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10082', 1);
        PRINT 'Inserted variant with barcode for: CFC-FRU-016';
    END
END
GO

-- CFR-CFR-012 - Barcode: 30340
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFR-CFR-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30340' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFR-CFR-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30340', 1);
        PRINT 'Inserted variant with barcode for: CFR-CFR-012';
    END
END
GO

-- CFR-CFR-012 - Barcode: 30340
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFR-CFR-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30340' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFR-CFR-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30340', 1);
        PRINT 'Inserted variant with barcode for: CFR-CFR-012';
    END
END
GO

-- CFR-CFR-014 - Barcode: 30363
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFR-CFR-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30363' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFR-CFR-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30363', 1);
        PRINT 'Inserted variant with barcode for: CFR-CFR-014';
    END
END
GO

-- CFR-CFR-016 - Barcode: 30364
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFR-CFR-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30364' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFR-CFR-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30364', 1);
        PRINT 'Inserted variant with barcode for: CFR-CFR-016';
    END
END
GO

-- CFR-CFR-016 - Barcode: 30364
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFR-CFR-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30364' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFR-CFR-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30364', 1);
        PRINT 'Inserted variant with barcode for: CFR-CFR-016';
    END
END
GO

-- MIS-BGM-EAC - Barcode: 30540
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-BGM-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30540' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-BGM-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30540', 1);
        PRINT 'Inserted variant with barcode for: MIS-BGM-EAC';
    END
END
GO

-- MIS-BGS-EAC - Barcode: 30541
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-BGS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30541' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-BGS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30541', 1);
        PRINT 'Inserted variant with barcode for: MIS-BGS-EAC';
    END
END
GO

-- MIS-BMV-EAC - Barcode: 8100
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-BMV-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8100' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-BMV-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8100', 1);
        PRINT 'Inserted variant with barcode for: MIS-BMV-EAC';
    END
END
GO

-- MIS-CAN-EAC - Barcode: 30516
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-CAN-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30516' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-CAN-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30516', 1);
        PRINT 'Inserted variant with barcode for: MIS-CAN-EAC';
    END
END
GO

-- MIS-CHW-EAC - Barcode: 30523
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-CHW-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30523' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-CHW-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30523', 1);
        PRINT 'Inserted variant with barcode for: MIS-CHW-EAC';
    END
END
GO

-- MIS-CUP-EAC - Barcode: 8016
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-CUP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8016' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-CUP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8016', 1);
        PRINT 'Inserted variant with barcode for: MIS-CUP-EAC';
    END
END
GO

-- MIS-DBC-012 - Barcode: 23002
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DBC-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '23002' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DBC-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '23002', 1);
        PRINT 'Inserted variant with barcode for: MIS-DBC-012';
    END
END
GO

-- MIS-DBC-014 - Barcode: 24002
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DBC-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '24002' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DBC-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '24002', 1);
        PRINT 'Inserted variant with barcode for: MIS-DBC-014';
    END
END
GO

-- MIS-DBC-016 - Barcode: 25002
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DBC-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '25002' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DBC-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '25002', 1);
        PRINT 'Inserted variant with barcode for: MIS-DBC-016';
    END
END
GO

-- MIS-DBC-018 - Barcode: 26002
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DBC-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '26002' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DBC-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '26002', 1);
        PRINT 'Inserted variant with barcode for: MIS-DBC-018';
    END
END
GO

-- MIS-DBC-020 - Barcode: 27002
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DBC-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '27002' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DBC-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '27002', 1);
        PRINT 'Inserted variant with barcode for: MIS-DBC-020';
    END
END
GO

-- MIS-DBV-012 - Barcode: 23001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-012';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '23001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DBV-012';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '23001', 1);
        PRINT 'Inserted variant with barcode for: MIS-DBV-012';
    END
END
GO

-- MIS-DBV-014 - Barcode: 24001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '24001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DBV-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '24001', 1);
        PRINT 'Inserted variant with barcode for: MIS-DBV-014';
    END
END
GO

-- MIS-DBV-016 - Barcode: 25001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '25001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DBV-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '25001', 1);
        PRINT 'Inserted variant with barcode for: MIS-DBV-016';
    END
END
GO

-- MIS-DBV-018 - Barcode: 26001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '26001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DBV-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '26001', 1);
        PRINT 'Inserted variant with barcode for: MIS-DBV-018';
    END
END
GO

-- MIS-DBV-020 - Barcode: 27001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '27001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DBV-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '27001', 1);
        PRINT 'Inserted variant with barcode for: MIS-DBV-020';
    END
END
GO

-- MIS-DBV-022 - Barcode: 28001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-022';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '28001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DBV-022';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '28001', 1);
        PRINT 'Inserted variant with barcode for: MIS-DBV-022';
    END
END
GO

-- MIS-DMV-EACH - Barcode: 8099
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DMV-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8099' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DMV-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8099', 1);
        PRINT 'Inserted variant with barcode for: MIS-DMV-EACH';
    END
END
GO

-- MIS-DOS-EAC - Barcode: 8202
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-DOS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8202' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-DOS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8202', 1);
        PRINT 'Inserted variant with barcode for: MIS-DOS-EAC';
    END
END
GO

-- MIS-EPO-EAC - Barcode: 30422
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-EPO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30422' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-EPO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30422', 1);
        PRINT 'Inserted variant with barcode for: MIS-EPO-EAC';
    END
END
GO

-- MIS-GBE-EAC - Barcode: 8017
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-GBE-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8017' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-GBE-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8017', 1);
        PRINT 'Inserted variant with barcode for: MIS-GBE-EAC';
    END
END
GO

-- MIS-GWR-EAC - Barcode: 30521
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-GWR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30521' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-GWR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30521', 1);
        PRINT 'Inserted variant with barcode for: MIS-GWR-EAC';
    END
END
GO

-- MIS-LEA-EAC - Barcode: 8018
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-LEA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8018' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-LEA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8018', 1);
        PRINT 'Inserted variant with barcode for: MIS-LEA-EAC';
    END
END
GO

-- MIS-MGR-EAC - Barcode: 8035
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-MGR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8035' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-MGR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8035', 1);
        PRINT 'Inserted variant with barcode for: MIS-MGR-EAC';
    END
END
GO

-- MIS-MSR-EAC - Barcode: 8036
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-MSR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8036' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-MSR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8036', 1);
        PRINT 'Inserted variant with barcode for: MIS-MSR-EAC';
    END
END
GO

-- MIS-MVU-EAC - Barcode: 8032
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-MVU-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8032' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-MVU-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8032', 1);
        PRINT 'Inserted variant with barcode for: MIS-MVU-EAC';
    END
END
GO

-- MIS-NOV-EAC - Barcode: 30524
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-NOV-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30524' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-NOV-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30524', 1);
        PRINT 'Inserted variant with barcode for: MIS-NOV-EAC';
    END
END
GO

-- MIS-RMV-EAC - Barcode: 8033
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-RMV-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8033' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-RMV-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8033', 1);
        PRINT 'Inserted variant with barcode for: MIS-RMV-EAC';
    END
END
GO

-- MIS-ROS-EAC - Barcode: 8020
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-ROS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8020' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-ROS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8020', 1);
        PRINT 'Inserted variant with barcode for: MIS-ROS-EAC';
    END
END
GO

-- MIS-SBE-EAC - Barcode: 8030
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-SBE-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8030' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-SBE-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8030', 1);
        PRINT 'Inserted variant with barcode for: MIS-SBE-EAC';
    END
END
GO

-- MIS-SDC-EAC - Barcode: 30515
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-SDC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30515' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-SDC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30515', 1);
        PRINT 'Inserted variant with barcode for: MIS-SDC-EAC';
    END
END
GO

-- MIS-SGA-EAC - Barcode: 8026
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-SGA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8026' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-SGA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8026', 1);
        PRINT 'Inserted variant with barcode for: MIS-SGA-EAC';
    END
END
GO

-- MIS-SGB-EAC - Barcode: 8028
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-SGB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8028' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-SGB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8028', 1);
        PRINT 'Inserted variant with barcode for: MIS-SGB-EAC';
    END
END
GO

-- MIS-SWR-EAC - Barcode: 30522
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'MIS-SWR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30522' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: MIS-SWR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30522', 1);
        PRINT 'Inserted variant with barcode for: MIS-SWR-EAC';
    END
END
GO

-- XDE-AST-EAC - Barcode: 30836
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'XDE-AST-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30836' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: XDE-AST-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30836', 1);
        PRINT 'Inserted variant with barcode for: XDE-AST-EAC';
    END
END
GO

-- XDE-SIL-KGR - Barcode: 30202
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'XDE-SIL-KGR';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30202' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: XDE-SIL-KGR';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30202', 1);
        PRINT 'Inserted variant with barcode for: XDE-SIL-KGR';
    END
END
GO

-- XDE-TEA-EAC - Barcode: 30201
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'XDE-TEA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30201' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: XDE-TEA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30201', 1);
        PRINT 'Inserted variant with barcode for: XDE-TEA-EAC';
    END
END
GO

-- YCC-CHA-EAC - Barcode: 30630
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'YCC-CHA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30630' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: YCC-CHA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30630', 1);
        PRINT 'Inserted variant with barcode for: YCC-CHA-EAC';
    END
END
GO

-- YCC-LEA-EAC - Barcode: 30624
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'YCC-LEA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30624' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: YCC-LEA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30624', 1);
        PRINT 'Inserted variant with barcode for: YCC-LEA-EAC';
    END
END
GO

-- YCC-MIS-EAC - Barcode: 30817
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'YCC-MIS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30817' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: YCC-MIS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30817', 1);
        PRINT 'Inserted variant with barcode for: YCC-MIS-EAC';
    END
END
GO

-- YCC-PIL-EAC - Barcode: 30046
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'YCC-PIL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30046' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: YCC-PIL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30046', 1);
        PRINT 'Inserted variant with barcode for: YCC-PIL-EAC';
    END
END
GO

-- YCC-SOS-EAC - Barcode: 30701
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'YCC-SOS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30701' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: YCC-SOS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30701', 1);
        PRINT 'Inserted variant with barcode for: YCC-SOS-EAC';
    END
END
GO

-- YCC-XPS-EAC - Barcode: 30815
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'YCC-XPS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30815' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: YCC-XPS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30815', 1);
        PRINT 'Inserted variant with barcode for: YCC-XPS-EAC';
    END
END
GO

-- CBF-BCK-020 - Barcode: 10096
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-BCK-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10096' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-BCK-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10096', 1);
        PRINT 'Inserted variant with barcode for: CBF-BCK-020';
    END
END
GO

-- CBF-FCK-020 - Barcode: 10097
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBF-FCK-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10097' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBF-FCK-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10097', 1);
        PRINT 'Inserted variant with barcode for: CBF-FCK-020';
    END
END
GO

-- CNO-BCB-016 - Barcode: 10060
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BCB-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10060' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BCB-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10060', 1);
        PRINT 'Inserted variant with barcode for: CNO-BCB-016';
    END
END
GO

-- CNO-BCB-018 - Barcode: 10065
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BCB-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10065' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BCB-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10065', 1);
        PRINT 'Inserted variant with barcode for: CNO-BCB-018';
    END
END
GO

-- CNO-BCB-020 - Barcode: 10068
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BCB-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10068' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BCB-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10068', 1);
        PRINT 'Inserted variant with barcode for: CNO-BCB-020';
    END
END
GO

-- CNO-BCH-016 - Barcode: 10063
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BCH-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10063' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BCH-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10063', 1);
        PRINT 'Inserted variant with barcode for: CNO-BCH-016';
    END
END
GO

-- CNO-BCH-018 - Barcode: 10067
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BCH-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10067' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BCH-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10067', 1);
        PRINT 'Inserted variant with barcode for: CNO-BCH-018';
    END
END
GO

-- CNO-BCH-020 - Barcode: 10036
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BCH-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10036' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BCH-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10036', 1);
        PRINT 'Inserted variant with barcode for: CNO-BCH-020';
    END
END
GO

-- CNO-BCS-014 - Barcode: 10059
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BCS-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10059' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BCS-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10059', 1);
        PRINT 'Inserted variant with barcode for: CNO-BCS-014';
    END
END
GO

-- CNO-BCS-014 - Barcode: 10059
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BCS-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10059' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BCS-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10059', 1);
        PRINT 'Inserted variant with barcode for: CNO-BCS-014';
    END
END
GO

-- CNO-BCS-016 - Barcode: 10064
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BCS-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10064' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BCS-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10064', 1);
        PRINT 'Inserted variant with barcode for: CNO-BCS-016';
    END
END
GO

-- CNO-BNY-018 - Barcode: 10085
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BNY-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10085' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BNY-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10085', 1);
        PRINT 'Inserted variant with barcode for: CNO-BNY-018';
    END
END
GO

-- CNO-BNY-018 - Barcode: 10085
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BNY-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10085' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BNY-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10085', 1);
        PRINT 'Inserted variant with barcode for: CNO-BNY-018';
    END
END
GO

-- CNO-BUT-014 - Barcode: 10057
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BUT-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10057' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BUT-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10057', 1);
        PRINT 'Inserted variant with barcode for: CNO-BUT-014';
    END
END
GO

-- CNO-BUT-016 - Barcode: 10062
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-BUT-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10062' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-BUT-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10062', 1);
        PRINT 'Inserted variant with barcode for: CNO-BUT-016';
    END
END
GO

-- CNO-CAS-018 - Barcode: 10087
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-CAS-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10087' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-CAS-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10087', 1);
        PRINT 'Inserted variant with barcode for: CNO-CAS-018';
    END
END
GO

-- CNO-DHB-020 - Barcode: 10167
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-DHB-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10167' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-DHB-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10167', 1);
        PRINT 'Inserted variant with barcode for: CNO-DHB-020';
    END
END
GO

-- CNO-DOLL-014 - Barcode: 10058
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-DOLL-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10058' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-DOLL-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10058', 1);
        PRINT 'Inserted variant with barcode for: CNO-DOLL-014';
    END
END
GO

-- CNO-DOLL-016 - Barcode: 10061
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-DOLL-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10061' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-DOLL-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10061', 1);
        PRINT 'Inserted variant with barcode for: CNO-DOLL-016';
    END
END
GO

-- CNO-DOLL-016 - Barcode: 10061
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-DOLL-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10061' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-DOLL-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10061', 1);
        PRINT 'Inserted variant with barcode for: CNO-DOLL-016';
    END
END
GO

-- CNO-FCB-016 - Barcode: 30469
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FCB-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30469' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FCB-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30469', 1);
        PRINT 'Inserted variant with barcode for: CNO-FCB-016';
    END
END
GO

-- CNO-FCB-016 - Barcode: 30469
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FCB-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30469' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FCB-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30469', 1);
        PRINT 'Inserted variant with barcode for: CNO-FCB-016';
    END
END
GO

-- CNO-FCB-018 - Barcode: 10071
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FCB-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10071' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FCB-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10071', 1);
        PRINT 'Inserted variant with barcode for: CNO-FCB-018';
    END
END
GO

-- CNO-FCB-018 - Barcode: 10071
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FCB-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10071' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FCB-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10071', 1);
        PRINT 'Inserted variant with barcode for: CNO-FCB-018';
    END
END
GO

-- CNO-FCB-020 - Barcode: 10073
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FCB-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10073' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FCB-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10073', 1);
        PRINT 'Inserted variant with barcode for: CNO-FCB-020';
    END
END
GO

-- CNO-FCH-016 - Barcode: 10070
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FCH-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10070' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FCH-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10070', 1);
        PRINT 'Inserted variant with barcode for: CNO-FCH-016';
    END
END
GO

-- CNO-FCH-016 - Barcode: 10070
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FCH-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10070' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FCH-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10070', 1);
        PRINT 'Inserted variant with barcode for: CNO-FCH-016';
    END
END
GO

-- CNO-FCH-018 - Barcode: 10072
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FCH-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10072' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FCH-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10072', 1);
        PRINT 'Inserted variant with barcode for: CNO-FCH-018';
    END
END
GO

-- CNO-FCH-020 - Barcode: 10027
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FCH-020';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10027' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FCH-020';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10027', 1);
        PRINT 'Inserted variant with barcode for: CNO-FCH-020';
    END
END
GO

-- CNO-FCS-014 - Barcode: 10069
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FCS-014';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10069' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FCS-014';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10069', 1);
        PRINT 'Inserted variant with barcode for: CNO-FCS-014';
    END
END
GO

-- CNO-FCS-016 - Barcode: 10074
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-FCS-016';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10074' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-FCS-016';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10074', 1);
        PRINT 'Inserted variant with barcode for: CNO-FCS-016';
    END
END
GO

-- CNO-SPI-018 - Barcode: 10086
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CNO-SPI-018';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10086' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CNO-SPI-018';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10086', 1);
        PRINT 'Inserted variant with barcode for: CNO-SPI-018';
    END
END
GO

-- PIE -CSR-EAC - Barcode: 15002
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE -CSR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15002' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE -CSR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15002', 1);
        PRINT 'Inserted variant with barcode for: PIE -CSR-EAC';
    END
END
GO

-- PIE-CCG-EAC - Barcode: 15016
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-CCG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15016' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-CCG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15016', 1);
        PRINT 'Inserted variant with barcode for: PIE-CCG-EAC';
    END
END
GO

-- PIE-COD-EAC - Barcode: 15103
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-COD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15103' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-COD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15103', 1);
        PRINT 'Inserted variant with barcode for: PIE-COD-EAC';
    END
END
GO

-- PIE-CPP-EAC - Barcode: 15007
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-CPP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15007' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-CPP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15007', 1);
        PRINT 'Inserted variant with barcode for: PIE-CPP-EAC';
    END
END
GO

-- PIE-MCB-EAC - Barcode: 15011
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-MCB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15011' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-MCB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15011', 1);
        PRINT 'Inserted variant with barcode for: PIE-MCB-EAC';
    END
END
GO

-- PIE-MSR-EAC - Barcode: 15001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-MSR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-MSR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15001', 1);
        PRINT 'Inserted variant with barcode for: PIE-MSR-EAC';
    END
END
GO

-- PIE-ODM-EAC - Barcode: 15101
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-ODM-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15101' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-ODM-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15101', 1);
        PRINT 'Inserted variant with barcode for: PIE-ODM-EAC';
    END
END
GO

-- PIE-PPS-EAC - Barcode: 15009
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-PPS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15009' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-PPS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15009', 1);
        PRINT 'Inserted variant with barcode for: PIE-PPS-EAC';
    END
END
GO

-- PIE-PRS-EAC - Barcode: 15017
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-PRS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15017' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-PRS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15017', 1);
        PRINT 'Inserted variant with barcode for: PIE-PRS-EAC';
    END
END
GO

-- PIE-SAF-EAC - Barcode: 15005
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-SAF-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15005' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-SAF-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15005', 1);
        PRINT 'Inserted variant with barcode for: PIE-SAF-EAC';
    END
END
GO

-- PIE-SAK-EAC - Barcode: 15010
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-SAK-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15010' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-SAK-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15010', 1);
        PRINT 'Inserted variant with barcode for: PIE-SAK-EAC';
    END
END
GO

-- PIE-SRB-EACH - Barcode: 15105
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-SRB-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15105' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-SRB-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15105', 1);
        PRINT 'Inserted variant with barcode for: PIE-SRB-EACH';
    END
END
GO

-- PIE-VEG-EAC - Barcode: 15004
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PIE-VEG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '15004' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PIE-VEG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '15004', 1);
        PRINT 'Inserted variant with barcode for: PIE-VEG-EAC';
    END
END
GO

-- SHP-IDH-EACH - Barcode: 60071
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-IDH-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '60071' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-IDH-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '60071', 1);
        PRINT 'Inserted variant with barcode for: SHP-IDH-EACH';
    END
END
GO

-- SHP - JAL-EACH - Barcode: 9009
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP - JAL-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '9009' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP - JAL-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '9009', 1);
        PRINT 'Inserted variant with barcode for: SHP - JAL-EACH';
    END
END
GO

-- SHP- BAN-EAC - Barcode: 16055
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP- BAN-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16055' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP- BAN-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16055', 1);
        PRINT 'Inserted variant with barcode for: SHP- BAN-EAC';
    END
END
GO

-- SHP- GUL-4S - Barcode: 60001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP- GUL-4S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '60001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP- GUL-4S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '60001', 1);
        PRINT 'Inserted variant with barcode for: SHP- GUL-4S';
    END
END
GO

-- SHP- RAE-EAC - Barcode: 16058
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP- RAE-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16058' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP- RAE-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16058', 1);
        PRINT 'Inserted variant with barcode for: SHP- RAE-EAC';
    END
END
GO

-- SHP-AUA-EAC - Barcode: 9008
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-AUA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '9008' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-AUA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '9008', 1);
        PRINT 'Inserted variant with barcode for: SHP-AUA-EAC';
    END
END
GO

-- SHP-BAN-6S - Barcode: 8080
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BAN-6S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8080' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BAN-6S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8080', 1);
        PRINT 'Inserted variant with barcode for: SHP-BAN-6S';
    END
END
GO

-- SHP-BCC-EAC - Barcode: 16041
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BCC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16041' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BCC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16041', 1);
        PRINT 'Inserted variant with barcode for: SHP-BCC-EAC';
    END
END
GO

-- SHP-BCG-EAC - Barcode: 16042
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BCG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16042' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BCG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16042', 1);
        PRINT 'Inserted variant with barcode for: SHP-BCG-EAC';
    END
END
GO

-- SHP-BRB-400 - Barcode: 30370
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BRB-400';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30370' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BRB-400';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30370', 1);
        PRINT 'Inserted variant with barcode for: SHP-BRB-400';
    END
END
GO

-- SHP-BRB-800 - Barcode: 13005
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BRB-800';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '13005' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BRB-800';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '13005', 1);
        PRINT 'Inserted variant with barcode for: SHP-BRB-800';
    END
END
GO

-- SHP-BRG-EAC - Barcode: 16003
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BRG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16003' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BRG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16003', 1);
        PRINT 'Inserted variant with barcode for: SHP-BRG-EAC';
    END
END
GO

-- SHP-BRR-500 - Barcode: 16004
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BRR-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16004' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BRR-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16004', 1);
        PRINT 'Inserted variant with barcode for: SHP-BRR-500';
    END
END
GO

-- SHP-BRT-500 - Barcode: 16005
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BRT-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16005' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BRT-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16005', 1);
        PRINT 'Inserted variant with barcode for: SHP-BRT-500';
    END
END
GO

-- SHP-BRW-400 - Barcode: 30372
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BRW-400';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30372' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BRW-400';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30372', 1);
        PRINT 'Inserted variant with barcode for: SHP-BRW-400';
    END
END
GO

-- SHP-BRW-800 - Barcode: 13003
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BRW-800';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '13003' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BRW-800';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '13003', 1);
        PRINT 'Inserted variant with barcode for: SHP-BRW-800';
    END
END
GO

-- SHP-BSC-EAC - Barcode: 16044
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BSC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16044' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BSC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16044', 1);
        PRINT 'Inserted variant with barcode for: SHP-BSC-EAC';
    END
END
GO

-- SHP-BTW-500 - Barcode: 16007
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BTW-500';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16007' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BTW-500';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16007', 1);
        PRINT 'Inserted variant with barcode for: SHP-BTW-500';
    END
END
GO

-- SHP-BUN-EAC - Barcode: 16008
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-BUN-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16008' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-BUN-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16008', 1);
        PRINT 'Inserted variant with barcode for: SHP-BUN-EAC';
    END
END
GO

-- SHP-CFI-EAC - Barcode: 16015
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-CFI-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16015' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-CFI-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16015', 1);
        PRINT 'Inserted variant with barcode for: SHP-CFI-EAC';
    END
END
GO

-- SHP-CFP-EAC - Barcode: 16016
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-CFP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16016' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-CFP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16016', 1);
        PRINT 'Inserted variant with barcode for: SHP-CFP-EAC';
    END
END
GO

-- SHP-CHB-04S - Barcode: 30755
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-CHB-04S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30755' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-CHB-04S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30755', 1);
        PRINT 'Inserted variant with barcode for: SHP-CHB-04S';
    END
END
GO

-- SHP-CHO-PLN - Barcode: 16013
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-CHO-PLN';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16013' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-CHO-PLN';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16013', 1);
        PRINT 'Inserted variant with barcode for: SHP-CHO-PLN';
    END
END
GO

-- SHP-CPN-EAC - Barcode: 16014
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-CPN-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16014' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-CPN-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16014', 1);
        PRINT 'Inserted variant with barcode for: SHP-CPN-EAC';
    END
END
GO

-- SHP-CRB-06S - Barcode: 16017
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-CRB-06S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16017' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-CRB-06S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16017', 1);
        PRINT 'Inserted variant with barcode for: SHP-CRB-06S';
    END
END
GO

-- SHP-CRO-06S - Barcode: 16018
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-CRO-06S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16018' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-CRO-06S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16018', 1);
        PRINT 'Inserted variant with barcode for: SHP-CRO-06S';
    END
END
GO

-- SHP-CSC-EAC - Barcode: 6001651011913
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-CSC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001651011913' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-CSC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001651011913', 1);
        PRINT 'Inserted variant with barcode for: SHP-CSC-EAC';
    END
END
GO

-- SHP-CTR-EAC - Barcode: 16020
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-CTR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16020' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-CTR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16020', 1);
        PRINT 'Inserted variant with barcode for: SHP-CTR-EAC';
    END
END
GO

-- SHP-CWP-EAC - Barcode: 16038
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-CWP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16038' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-CWP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16038', 1);
        PRINT 'Inserted variant with barcode for: SHP-CWP-EAC';
    END
END
GO

-- SHP-CWS-EAC - Barcode: 16049
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-CWS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16049' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-CWS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16049', 1);
        PRINT 'Inserted variant with barcode for: SHP-CWS-EAC';
    END
END
GO

-- SHP-DOP-10S - Barcode: 110103
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-DOP-10S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '110103' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-DOP-10S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '110103', 1);
        PRINT 'Inserted variant with barcode for: SHP-DOP-10S';
    END
END
GO

-- SHP-DRO-EAC - Barcode: 16045
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-DRO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16045' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-DRO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16045', 1);
        PRINT 'Inserted variant with barcode for: SHP-DRO-EAC';
    END
END
GO

-- SHP-GAT-EAC - Barcode: 16021
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-GAT-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16021' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-GAT-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16021', 1);
        PRINT 'Inserted variant with barcode for: SHP-GAT-EAC';
    END
END
GO

-- SHP-HBU-EAC - Barcode: 16022
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-HBU-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16022' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-HBU-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16022', 1);
        PRINT 'Inserted variant with barcode for: SHP-HBU-EAC';
    END
END
GO

-- SHP-LAC-EACH - Barcode: 110102
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-LAC-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '110102' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-LAC-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '110102', 1);
        PRINT 'Inserted variant with barcode for: SHP-LAC-EACH';
    END
END
GO

-- SHP-LAR-EACH - Barcode: 110101
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-LAR-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '110101' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-LAR-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '110101', 1);
        PRINT 'Inserted variant with barcode for: SHP-LAR-EACH';
    END
END
GO

-- SHP-LHS-375 - Barcode: 9003
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-LHS-375';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '9003' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-LHS-375';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '9003', 1);
        PRINT 'Inserted variant with barcode for: SHP-LHS-375';
    END
END
GO

-- SHP-LJS-350 - Barcode: 9004
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-LJS-350';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '9004' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-LJS-350';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '9004', 1);
        PRINT 'Inserted variant with barcode for: SHP-LJS-350';
    END
END
GO

-- SHP-MAD-EAC - Barcode: 16023
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-MAD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16023' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-MAD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16023', 1);
        PRINT 'Inserted variant with barcode for: SHP-MAD-EAC';
    END
END
GO

-- SHP-MHS-165 - Barcode: 9001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-MHS-165';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '9001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-MHS-165';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '9001', 1);
        PRINT 'Inserted variant with barcode for: SHP-MHS-165';
    END
END
GO

-- SHP-MIN-EAC - Barcode: 16024
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-MIN-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16024' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-MIN-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16024', 1);
        PRINT 'Inserted variant with barcode for: SHP-MIN-EAC';
    END
END
GO

-- SHP-MJS-250 - Barcode: 9002
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-MJS-250';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '9002' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-MJS-250';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '9002', 1);
        PRINT 'Inserted variant with barcode for: SHP-MJS-250';
    END
END
GO

-- SHP-MRO-EACH - Barcode: 16048
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-MRO-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16048' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-MRO-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16048', 1);
        PRINT 'Inserted variant with barcode for: SHP-MRO-EACH';
    END
END
GO

-- SHP-NAA-02S - Barcode: 16025
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-NAA-02S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16025' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-NAA-02S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16025', 1);
        PRINT 'Inserted variant with barcode for: SHP-NAA-02S';
    END
END
GO

-- SHP-NAA-EAC - Barcode: 16026
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-NAA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16026' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-NAA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16026', 1);
        PRINT 'Inserted variant with barcode for: SHP-NAA-EAC';
    END
END
GO

-- SHP-PFC-4S - Barcode: 60074
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-PFC-4S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '60074' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-PFC-4S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '60074', 1);
        PRINT 'Inserted variant with barcode for: SHP-PFC-4S';
    END
END
GO

-- SHP-POL-EAC - Barcode: 60072
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-POL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '60072' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-POL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '60072', 1);
        PRINT 'Inserted variant with barcode for: SHP-POL-EAC';
    END
END
GO

-- SHP-RAI-EAC - Barcode: 16027
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-RAI-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16027' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-RAI-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16027', 1);
        PRINT 'Inserted variant with barcode for: SHP-RAI-EAC';
    END
END
GO

-- SHP-RAL-EAC - Barcode: 16028
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-RAL-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16028' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-RAL-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16028', 1);
        PRINT 'Inserted variant with barcode for: SHP-RAL-EAC';
    END
END
GO

-- SHP-RJS-595 - Barcode: 9006
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-RJS-595';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '9006' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-RJS-595';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '9006', 1);
        PRINT 'Inserted variant with barcode for: SHP-RJS-595';
    END
END
GO

-- SHP-ROLL-06S - Barcode: 16029
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-ROLL-06S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16029' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-ROLL-06S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16029', 1);
        PRINT 'Inserted variant with barcode for: SHP-ROLL-06S';
    END
END
GO

-- SHP-ROLL-12S - Barcode: 16030
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-ROLL-12S';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16030' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-ROLL-12S';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16030', 1);
        PRINT 'Inserted variant with barcode for: SHP-ROLL-12S';
    END
END
GO

-- SHP-ROT-EAC - Barcode: 16046
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-ROT-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16046' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-ROT-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16046', 1);
        PRINT 'Inserted variant with barcode for: SHP-ROT-EAC';
    END
END
GO

-- SHP-SBC-EAC - Barcode: 8050
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-SBC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8050' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-SBC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8050', 1);
        PRINT 'Inserted variant with barcode for: SHP-SBC-EAC';
    END
END
GO

-- SHP-SCF-EAC - Barcode: 16032
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-SCF-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16032' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-SCF-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16032', 1);
        PRINT 'Inserted variant with barcode for: SHP-SCF-EAC';
    END
END
GO

-- SHP-SCG-EAC - Barcode: 16034
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-SCG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16034' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-SCG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16034', 1);
        PRINT 'Inserted variant with barcode for: SHP-SCG-EAC';
    END
END
GO

-- SHP-SCO-EAC - Barcode: 16033
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-SCO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16033' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-SCO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16033', 1);
        PRINT 'Inserted variant with barcode for: SHP-SCO-EAC';
    END
END
GO

-- SHP-SPO-EACH - Barcode: 60073
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-SPO-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '60073' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-SPO-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '60073', 1);
        PRINT 'Inserted variant with barcode for: SHP-SPO-EACH';
    END
END
GO

-- SHP-SSC-EAC - Barcode: 6001651009125
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-SSC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001651009125' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-SSC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001651009125', 1);
        PRINT 'Inserted variant with barcode for: SHP-SSC-EAC';
    END
END
GO

-- SHP-TRI-EAC - Barcode: 16035
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-TRI-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16035' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-TRI-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16035', 1);
        PRINT 'Inserted variant with barcode for: SHP-TRI-EAC';
    END
END
GO

-- SHP-WIC-EAC - Barcode: 16037
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-WIC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16037' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-WIC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16037', 1);
        PRINT 'Inserted variant with barcode for: SHP-WIC-EAC';
    END
END
GO

-- SHP-WIS-EAC - Barcode: 16039
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-WIS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16039' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-WIS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16039', 1);
        PRINT 'Inserted variant with barcode for: SHP-WIS-EAC';
    END
END
GO

-- SHP-WMV-EAC - Barcode: 16040
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SHP-WMV-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16040' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SHP-WMV-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16040', 1);
        PRINT 'Inserted variant with barcode for: SHP-WMV-EAC';
    END
END
GO

-- SNA-CHE-340 - Barcode: 6007597000028
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-CHE-340';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6007597000028' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-CHE-340';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6007597000028', 1);
        PRINT 'Inserted variant with barcode for: SNA-CHE-340';
    END
END
GO

-- SNA-CHE-EAC - Barcode: 16047
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-CHE-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '16047' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-CHE-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '16047', 1);
        PRINT 'Inserted variant with barcode for: SNA-CHE-EAC';
    END
END
GO

-- SNA-KMU-EAC - Barcode: 6009659190678
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-KMU-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009659190678' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-KMU-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009659190678', 1);
        PRINT 'Inserted variant with barcode for: SNA-KMU-EAC';
    END
END
GO

-- SNA-LMP-EAC - Barcode: 13007
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-LMP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '13007' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-LMP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '13007', 1);
        PRINT 'Inserted variant with barcode for: SNA-LMP-EAC';
    END
END
GO

-- SNA-MOC-EAC - Barcode: 6001651026986
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-MOC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001651026986' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-MOC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001651026986', 1);
        PRINT 'Inserted variant with barcode for: SNA-MOC-EAC';
    END
END
GO

-- SNA-MSF-EAC - Barcode: 30781
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-MSF-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30781' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-MSF-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30781', 1);
        PRINT 'Inserted variant with barcode for: SNA-MSF-EAC';
    END
END
GO

-- SNA-MUS-EAC - Barcode: 5010
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-MUS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5010' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-MUS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5010', 1);
        PRINT 'Inserted variant with barcode for: SNA-MUS-EAC';
    END
END
GO

-- SNA-NUT-60G - Barcode: 6002849000177
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-NUT-60G';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6002849000177' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-NUT-60G';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6002849000177', 1);
        PRINT 'Inserted variant with barcode for: SNA-NUT-60G';
    END
END
GO

-- SNA-PGA-EAC - Barcode: 4001
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-PGA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '4001' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-PGA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '4001', 1);
        PRINT 'Inserted variant with barcode for: SNA-PGA-EAC';
    END
END
GO

-- SNA-PNM-EAC - Barcode: 30491
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-PNM-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30491' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-PNM-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30491', 1);
        PRINT 'Inserted variant with barcode for: SNA-PNM-EAC';
    END
END
GO

-- SNA-PNM-EAC - Barcode: 30491
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-PNM-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30491' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-PNM-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30491', 1);
        PRINT 'Inserted variant with barcode for: SNA-PNM-EAC';
    END
END
GO

-- snA-PNM-EAC - Barcode: 6009634280431
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'snA-PNM-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009634280431' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: snA-PNM-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009634280431', 1);
        PRINT 'Inserted variant with barcode for: snA-PNM-EAC';
    END
END
GO

-- SNA-PNT-EAC - Barcode: 6002415000501
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-PNT-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6002415000501' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-PNT-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6002415000501', 1);
        PRINT 'Inserted variant with barcode for: SNA-PNT-EAC';
    END
END
GO

-- SNA-SUS-EAC - Barcode: 6009708771438
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-SUS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009708771438' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-SUS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009708771438', 1);
        PRINT 'Inserted variant with barcode for: SNA-SUS-EAC';
    END
END
GO

-- SNA-TMU-EAC - Barcode: 5011
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SNA-TMU-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '5011' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SNA-TMU-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '5011', 1);
        PRINT 'Inserted variant with barcode for: SNA-TMU-EAC';
    END
END
GO

-- CEX-FRT-EAC - Barcode: 14013
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CEX-FRT-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '14013' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CEX-FRT-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '14013', 1);
        PRINT 'Inserted variant with barcode for: CEX-FRT-EAC';
    END
END
GO

-- SWE-BOR-EAC - Barcode: 6009625510592
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-BOR-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009625510592' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-BOR-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009625510592', 1);
        PRINT 'Inserted variant with barcode for: SWE-BOR-EAC';
    END
END
GO

-- SWE-CCC-EAC - Barcode: 1017
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CCC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '1017' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CCC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '1017', 1);
        PRINT 'Inserted variant with barcode for: SWE-CCC-EAC';
    END
END
GO

-- SWE-CCD-EAC - Barcode: 6009614200985
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CCD-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009614200985' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CCD-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009614200985', 1);
        PRINT 'Inserted variant with barcode for: SWE-CCD-EAC';
    END
END
GO

-- SWE-CFW-EAC - Barcode: 10030
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CFW-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10030' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CFW-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10030', 1);
        PRINT 'Inserted variant with barcode for: SWE-CFW-EAC';
    END
END
GO

-- SWE-CHF-EAC - Barcode: 6009625510615
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CHF-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009625510615' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CHF-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009625510615', 1);
        PRINT 'Inserted variant with barcode for: SWE-CHF-EAC';
    END
END
GO

-- SWE-CHI-EAC - Barcode: 6001200000016
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CHI-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6001200000016' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CHI-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6001200000016', 1);
        PRINT 'Inserted variant with barcode for: SWE-CHI-EAC';
    END
END
GO

-- SWE-CMM-EAC - Barcode: 30482
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CMM-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30482' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CMM-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30482', 1);
        PRINT 'Inserted variant with barcode for: SWE-CMM-EAC';
    END
END
GO

-- SWE-CNI-EAC - Barcode: 30608
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CNI-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30608' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CNI-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30608', 1);
        PRINT 'Inserted variant with barcode for: SWE-CNI-EAC';
    END
END
GO

-- SWE-CNW-EAC - Barcode: 6009614200046
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CNW-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009614200046' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CNW-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009614200046', 1);
        PRINT 'Inserted variant with barcode for: SWE-CNW-EAC';
    END
END
GO

-- SWE-CPC-EAC - Barcode: 6009614200008
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CPC-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009614200008' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CPC-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009614200008', 1);
        PRINT 'Inserted variant with barcode for: SWE-CPC-EAC';
    END
END
GO

-- SWE-CRO-EAC - Barcode: 6009614200558
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CRO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009614200558' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CRO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009614200558', 1);
        PRINT 'Inserted variant with barcode for: SWE-CRO-EAC';
    END
END
GO

-- SWE-CRO-EAC - Barcode: 6009614200558
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CRO-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009614200558' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CRO-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009614200558', 1);
        PRINT 'Inserted variant with barcode for: SWE-CRO-EAC';
    END
END
GO

-- SWE-CSP-EAC - Barcode: 8850632605164
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-CSP-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8850632605164' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-CSP-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8850632605164', 1);
        PRINT 'Inserted variant with barcode for: SWE-CSP-EAC';
    END
END
GO

-- SWE-FIG-EAC - Barcode: 6009625510608
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-FIG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009625510608' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-FIG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009625510608', 1);
        PRINT 'Inserted variant with barcode for: SWE-FIG-EAC';
    END
END
GO

-- SWE-MES-EAC - Barcode: 1024
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-MES-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '1024' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-MES-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '1024', 1);
        PRINT 'Inserted variant with barcode for: SWE-MES-EAC';
    END
END
GO

-- SWE-PNB-EAC - Barcode: 6004796000941
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-PNB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6004796000941' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-PNB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6004796000941', 1);
        PRINT 'Inserted variant with barcode for: SWE-PNB-EAC';
    END
END
GO

-- SWE-PNB-EACH - Barcode: 6009633420525
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-PNB-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009633420525' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-PNB-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009633420525', 1);
        PRINT 'Inserted variant with barcode for: SWE-PNB-EACH';
    END
END
GO

-- SWE-PNP-EACH - Barcode: 6009663420594
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-PNP-EACH';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009663420594' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-PNP-EACH';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009663420594', 1);
        PRINT 'Inserted variant with barcode for: SWE-PNP-EACH';
    END
END
GO

-- SWE-SPA-EAC - Barcode: 8850632605140
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-SPA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8850632605140' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-SPA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8850632605140', 1);
        PRINT 'Inserted variant with barcode for: SWE-SPA-EAC';
    END
END
GO

-- SWE-SPB-EAC - Barcode: 6009663420938
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-SPB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009663420938' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-SPB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009663420938', 1);
        PRINT 'Inserted variant with barcode for: SWE-SPB-EAC';
    END
END
GO

-- SWE-SPS-EAC - Barcode: 8850632603566
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-SPS-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '8850632603566' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-SPS-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '8850632603566', 1);
        PRINT 'Inserted variant with barcode for: SWE-SPS-EAC';
    END
END
GO

-- SWE-SSB-EAC - Barcode: 6009625510714
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-SSB-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009625510714' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-SSB-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009625510714', 1);
        PRINT 'Inserted variant with barcode for: SWE-SSB-EAC';
    END
END
GO

-- PAC-12X-EAC - Barcode: 30254
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-12X-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30254' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-12X-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30254', 1);
        PRINT 'Inserted variant with barcode for: PAC-12X-EAC';
    END
END
GO

-- PAC-14X-EAC - Barcode: 30255
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-14X-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30255' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-14X-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30255', 1);
        PRINT 'Inserted variant with barcode for: PAC-14X-EAC';
    END
END
GO

-- PAC-16X-EAC - Barcode: 30256
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-16X-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30256' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-16X-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30256', 1);
        PRINT 'Inserted variant with barcode for: PAC-16X-EAC';
    END
END
GO

-- PAC-18X-EAC - Barcode: 30258
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-18X-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30258' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-18X-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30258', 1);
        PRINT 'Inserted variant with barcode for: PAC-18X-EAC';
    END
END
GO

-- PAC-20X-EAC - Barcode: 30259
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-20X-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30259' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-20X-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30259', 1);
        PRINT 'Inserted variant with barcode for: PAC-20X-EAC';
    END
END
GO

-- PAC-552-EAC - Barcode: 30801
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-552-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30801' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-552-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30801', 1);
        PRINT 'Inserted variant with barcode for: PAC-552-EAC';
    END
END
GO

-- PAC-572-EAC - Barcode: 30737
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-572-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30737' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-572-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30737', 1);
        PRINT 'Inserted variant with barcode for: PAC-572-EAC';
    END
END
GO

-- PAC-573-EAC - Barcode: 30827
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-573-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30827' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-573-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30827', 1);
        PRINT 'Inserted variant with barcode for: PAC-573-EAC';
    END
END
GO

-- PAC-835-EAC - Barcode: 30303
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-835-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30303' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-835-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30303', 1);
        PRINT 'Inserted variant with barcode for: PAC-835-EAC';
    END
END
GO

-- SWE-SSF-EAC - Barcode: 6009625510721
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-SSF-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009625510721' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-SSF-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009625510721', 1);
        PRINT 'Inserted variant with barcode for: SWE-SSF-EAC';
    END
END
GO

-- PAC-884-EAC - Barcode: 30486
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-884-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30486' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-884-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30486', 1);
        PRINT 'Inserted variant with barcode for: PAC-884-EAC';
    END
END
GO

-- PAC-BAG-EAC - Barcode: 6009681740704
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-BAG-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009681740704' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-BAG-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009681740704', 1);
        PRINT 'Inserted variant with barcode for: PAC-BAG-EAC';
    END
END
GO

-- PAC-BAG-JUM - Barcode: 6009681740705
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'PAC-BAG-JUM';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '6009681740705' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: PAC-BAG-JUM';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '6009681740705', 1);
        PRINT 'Inserted variant with barcode for: PAC-BAG-JUM';
    END
END
GO

-- SWE-TOA-EAC - Barcode: 1033
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'SWE-TOA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '1033' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: SWE-TOA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '1033', 1);
        PRINT 'Inserted variant with barcode for: SWE-TOA-EAC';
    END
END
GO

-- CBW-CAK-003 - Barcode: 10102
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBW-CAK-003';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10102' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBW-CAK-003';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10102', 1);
        PRINT 'Inserted variant with barcode for: CBW-CAK-003';
    END
END
GO

-- CBW-CKE-003 - Barcode: 10098
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBW-CKE-003';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10098' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBW-CKE-003';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10098', 1);
        PRINT 'Inserted variant with barcode for: CBW-CKE-003';
    END
END
GO

-- CBW-STA-EAC - Barcode: 10289
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CBW-STA-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10289' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CBW-STA-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10289', 1);
        PRINT 'Inserted variant with barcode for: CBW-STA-EAC';
    END
END
GO

-- CFW-CAF-002 - Barcode: 10100
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFW-CAF-002';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10100' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFW-CAF-002';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10100', 1);
        PRINT 'Inserted variant with barcode for: CFW-CAF-002';
    END
END
GO

-- CFW-CAF-003 - Barcode: 10101
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFW-CAF-003';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10101' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFW-CAF-003';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10101', 1);
        PRINT 'Inserted variant with barcode for: CFW-CAF-003';
    END
END
GO

-- CFW-CAF-003 - Barcode: 10101
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFW-CAF-003';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10101' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFW-CAF-003';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10101', 1);
        PRINT 'Inserted variant with barcode for: CFW-CAF-003';
    END
END
GO

-- ZFO-NS2-EAC - Barcode: 30330
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'ZFO-NS2-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30330' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: ZFO-NS2-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30330', 1);
        PRINT 'Inserted variant with barcode for: ZFO-NS2-EAC';
    END
END
GO

-- ZFO-S16-EAC - Barcode: 30325
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'ZFO-S16-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30325' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: ZFO-S16-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30325', 1);
        PRINT 'Inserted variant with barcode for: ZFO-S16-EAC';
    END
END
GO

-- ZFO-S18-EAC - Barcode: 30326
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'ZFO-S18-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30326' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: ZFO-S18-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30326', 1);
        PRINT 'Inserted variant with barcode for: ZFO-S18-EAC';
    END
END
GO

-- ZFO-S20-EAC - Barcode: 30328
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'ZFO-S20-EAC';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '30328' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: ZFO-S20-EAC';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '30328', 1);
        PRINT 'Inserted variant with barcode for: ZFO-S20-EAC';
    END
END
GO

-- CFW-CKE-003 - Barcode: 10099
DECLARE @ProductID INT;
SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = 'CFW-CKE-003';

IF @ProductID IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Demo_Retail_Variant SET Barcode = '10099' WHERE ProductID = @ProductID;
        PRINT 'Updated barcode for: CFW-CKE-003';
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)
        VALUES (@ProductID, '10099', 1);
        PRINT 'Inserted variant with barcode for: CFW-CKE-003';
    END
END
GO

COMMIT TRANSACTION;

PRINT 'Barcode import completed!';
PRINT 'Total barcodes processed: 565';

-- Show results
SELECT COUNT(*) AS VariantsWithBarcodes
FROM Demo_Retail_Variant
WHERE Barcode IS NOT NULL AND Barcode <> '';

