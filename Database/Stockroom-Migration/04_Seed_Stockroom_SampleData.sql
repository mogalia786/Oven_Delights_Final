-- Step 4 — Seed sample data (optional, schema-compatible)
-- This script detects optional columns and builds INSERTs accordingly to avoid invalid column errors.

-- Flags for Suppliers optional columns
DECLARE @hasSup_PaymentTerms bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Suppliers]') AND name = 'PaymentTerms') THEN 1 ELSE 0 END;
DECLARE @hasSup_CreatedBy bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Suppliers]') AND name = 'CreatedBy') THEN 1 ELSE 0 END;
DECLARE @hasSup_ContactPerson bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Suppliers]') AND name = 'ContactPerson') THEN 1 ELSE 0 END;
DECLARE @hasSup_Email bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Suppliers]') AND name = 'Email') THEN 1 ELSE 0 END;
DECLARE @hasSup_Phone bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Suppliers]') AND name = 'Phone') THEN 1 ELSE 0 END;

DECLARE @sql NVARCHAR(MAX);

-- Helper to build and execute dynamic insert into Suppliers
DECLARE @cols NVARCHAR(MAX), @vals NVARCHAR(MAX);

-- Supplier rows
DECLARE @sup TABLE (SupplierCode nvarchar(20), CompanyName nvarchar(100), ContactPerson nvarchar(100), Email nvarchar(100), Phone nvarchar(20), PaymentTerms int, CreatedBy int);
INSERT INTO @sup VALUES
('SUP001','Premium Flour Mills','John Smith','orders@premiumflour.co.za','011-123-4567',30,1),
('SUP002','Fresh Dairy Supplies','Mary Johnson','sales@freshdairy.co.za','021-987-6543',15,1),
('SUP003','Sugar & Spice Co','Peter Brown','info@sugarspice.co.za','031-555-0123',30,1);

DECLARE @SupplierCode nvarchar(20), @CompanyName nvarchar(100), @ContactPerson nvarchar(100), @Email nvarchar(100), @Phone nvarchar(20), @PaymentTerms int, @CreatedBy int;
DECLARE sup_cursor CURSOR FOR SELECT SupplierCode, CompanyName, ContactPerson, Email, Phone, PaymentTerms, CreatedBy FROM @sup;
OPEN sup_cursor;
FETCH NEXT FROM sup_cursor INTO @SupplierCode, @CompanyName, @ContactPerson, @Email, @Phone, @PaymentTerms, @CreatedBy;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @cols = N'SupplierCode, CompanyName';
    SET @vals = N'''' + REPLACE(@SupplierCode,'''','''''') + ''', ''' + REPLACE(@CompanyName,'''','''''') + '''';

    IF @hasSup_ContactPerson = 1 BEGIN SET @cols = @cols + N', ContactPerson'; SET @vals = @vals + N', ''' + REPLACE(@ContactPerson,'''','''''') + ''''; END
    IF @hasSup_Email = 1 BEGIN SET @cols = @cols + N', Email'; SET @vals = @vals + N', ''' + REPLACE(@Email,'''','''''') + ''''; END
    IF @hasSup_Phone = 1 BEGIN SET @cols = @cols + N', Phone'; SET @vals = @vals + N', ''' + REPLACE(@Phone,'''','''''') + ''''; END
    IF @hasSup_PaymentTerms = 1 BEGIN SET @cols = @cols + N', PaymentTerms'; SET @vals = @vals + N', ' + CAST(@PaymentTerms AS nvarchar(10)); END
    IF @hasSup_CreatedBy = 1 BEGIN SET @cols = @cols + N', CreatedBy'; SET @vals = @vals + N', ' + CAST(@CreatedBy AS nvarchar(10)); END

    SET @sql = N'IF NOT EXISTS (SELECT 1 FROM dbo.Suppliers WHERE SupplierCode = ''' + REPLACE(@SupplierCode,'''','''''') + N''') '
             + N'INSERT INTO dbo.Suppliers (' + @cols + N') VALUES (' + @vals + N');';
    EXEC sys.sp_executesql @sql;

    FETCH NEXT FROM sup_cursor INTO @SupplierCode, @CompanyName, @ContactPerson, @Email, @Phone, @PaymentTerms, @CreatedBy;
END
CLOSE sup_cursor; DEALLOCATE sup_cursor;

-- Flags for RawMaterials optional columns
DECLARE @hasRM_Category bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[RawMaterials]') AND name = 'Category') THEN 1 ELSE 0 END;
DECLARE @hasRM_PreferredSupplierID bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[RawMaterials]') AND name = 'PreferredSupplierID') THEN 1 ELSE 0 END;
DECLARE @hasRM_CreatedBy bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[RawMaterials]') AND name = 'CreatedBy') THEN 1 ELSE 0 END;
DECLARE @hasRM_BaseUnit bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[RawMaterials]') AND name = 'BaseUnit') THEN 1 ELSE 0 END;
DECLARE @hasRM_UnitOfMeasure bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[RawMaterials]') AND name = 'UnitOfMeasure') THEN 1 ELSE 0 END;
DECLARE @hasRM_CostingMethod bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[RawMaterials]') AND name = 'CostingMethod') THEN 1 ELSE 0 END;

-- RawMaterials rows
DECLARE @rm TABLE (
    MaterialCode nvarchar(20), MaterialName nvarchar(100), Description nvarchar(500), Category nvarchar(50), UnitOfMeasure nvarchar(20), ReorderLevel decimal(18,3), StandardCost decimal(18,4), CostingMethod nvarchar(10), PreferredSupplierID int, CreatedBy int
);
INSERT INTO @rm VALUES
('RM001','Bread Flour','High quality bread flour','Flour','kg',100.000,12.50,'FIFO',1,1),
('RM002','Fresh Milk','Full cream fresh milk','Dairy','liters',50.000,18.75,'FIFO',2,1),
('RM003','Caster Sugar','Fine caster sugar','Sugar','kg',75.000,22.00,'FIFO',3,1),
('RM004','Butter','Salted butter','Dairy','kg',25.000,85.00,'FIFO',2,1),
('RM005','Eggs','Fresh large eggs','Dairy','dozen',20.000,35.00,'FIFO',2,1);

DECLARE @MaterialCode nvarchar(20), @MaterialName nvarchar(100), @Description nvarchar(500), @Category nvarchar(50), @UnitOfMeasure nvarchar(20), @ReorderLevel decimal(18,3), @StandardCost decimal(18,4), @CostingMethod nvarchar(10), @PreferredSupplierID int, @RMCreatedBy int;
DECLARE rm_cursor CURSOR FOR SELECT MaterialCode, MaterialName, Description, Category, UnitOfMeasure, ReorderLevel, StandardCost, CostingMethod, PreferredSupplierID, CreatedBy FROM @rm;
OPEN rm_cursor;
FETCH NEXT FROM rm_cursor INTO @MaterialCode, @MaterialName, @Description, @Category, @UnitOfMeasure, @ReorderLevel, @StandardCost, @CostingMethod, @PreferredSupplierID, @RMCreatedBy;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @cols = N'MaterialCode, MaterialName, Description, ReorderLevel, StandardCost';
    SET @vals = N'''' + REPLACE(@MaterialCode,'''','''''') + ''', ''' + REPLACE(@MaterialName,'''','''''') + ''', ''' + REPLACE(@Description,'''','''''') + ''', ' + CAST(@ReorderLevel AS nvarchar(32)) + N', ' + CAST(@StandardCost AS nvarchar(32));

    IF @hasRM_BaseUnit = 1 BEGIN SET @cols = @cols + N', BaseUnit'; SET @vals = @vals + N', ''' + REPLACE(@UnitOfMeasure,'''','''''') + ''''; END
    IF @hasRM_UnitOfMeasure = 1 BEGIN SET @cols = @cols + N', UnitOfMeasure'; SET @vals = @vals + N', ''' + REPLACE(@UnitOfMeasure,'''','''''') + ''''; END

    IF @hasRM_CostingMethod = 1 BEGIN SET @cols = @cols + N', CostingMethod'; SET @vals = @vals + N', ''' + REPLACE(@CostingMethod,'''','''''') + ''''; END

    IF @hasRM_Category = 1 BEGIN SET @cols = @cols + N', Category'; SET @vals = @vals + N', ''' + REPLACE(@Category,'''','''''') + ''''; END
    -- Resolve PreferredSupplierID by SupplierCode mapping if present (avoids FK issues if IDs differ)
    DECLARE @PreferredSupplierID_Resolved int = NULL;
    IF @hasRM_PreferredSupplierID = 1 AND @PreferredSupplierID IS NOT NULL
    BEGIN
        SELECT @PreferredSupplierID_Resolved = s.SupplierID
        FROM dbo.Suppliers s
        WHERE s.SupplierCode = CASE @PreferredSupplierID WHEN 1 THEN 'SUP001' WHEN 2 THEN 'SUP002' WHEN 3 THEN 'SUP003' ELSE NULL END;
        IF @PreferredSupplierID_Resolved IS NOT NULL
        BEGIN
            SET @cols = @cols + N', PreferredSupplierID';
            SET @vals = @vals + N', ' + CAST(@PreferredSupplierID_Resolved AS nvarchar(10));
        END
    END
    IF @hasRM_CreatedBy = 1 BEGIN SET @cols = @cols + N', CreatedBy'; SET @vals = @vals + N', ' + CAST(@RMCreatedBy AS nvarchar(10)); END

    SET @sql = N'IF NOT EXISTS (SELECT 1 FROM dbo.RawMaterials WHERE MaterialCode = ''' + REPLACE(@MaterialCode,'''','''''') + N''') '
             + N'INSERT INTO dbo.RawMaterials (' + @cols + N') VALUES (' + @vals + N');';
    EXEC sys.sp_executesql @sql;

    FETCH NEXT FROM rm_cursor INTO @MaterialCode, @MaterialName, @Description, @Category, @UnitOfMeasure, @ReorderLevel, @StandardCost, @CostingMethod, @PreferredSupplierID, @RMCreatedBy;
END
CLOSE rm_cursor; DEALLOCATE rm_cursor;
