-- Add Print Barcode Labels menu to MenuRegistry
-- This ensures the menu appears in Role Access Management

-- Check if MenuRegistry table exists
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'MenuRegistry')
BEGIN
    -- Add Print Barcode Labels to Retail menu
    IF NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Retail' AND SubMenuName = 'Print Barcode Labels')
    BEGIN
        INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
        VALUES ('Retail', 'Print Barcode Labels', 99, 1);
        
        PRINT 'Print Barcode Labels menu added to MenuRegistry';
    END
    ELSE
    BEGIN
        PRINT 'Print Barcode Labels menu already exists in MenuRegistry';
    END
    
    -- Verify the menu was added
    SELECT MenuID, MenuName, SubMenuName, DisplayOrder, IsActive 
    FROM MenuRegistry 
    WHERE MenuName = 'Retail' AND SubMenuName = 'Print Barcode Labels';
END
ELSE
BEGIN
    PRINT 'ERROR: MenuRegistry table does not exist. Please run Create_MenuRegistry.sql first.';
END
GO
