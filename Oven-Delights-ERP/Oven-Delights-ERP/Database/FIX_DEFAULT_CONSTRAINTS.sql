-- Drop and recreate DEFAULT constraints with QUOTED_IDENTIFIER ON
SET QUOTED_IDENTIFIER ON;
GO

-- Dynamically drop all default constraints on SupplierInvoices
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql += 'ALTER TABLE SupplierInvoices DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.default_constraints
WHERE parent_object_id = OBJECT_ID('SupplierInvoices');

IF @sql <> ''
BEGIN
    EXEC sp_executesql @sql;
    PRINT 'Dropped all default constraints';
END

-- Recreate with QUOTED_IDENTIFIER ON
ALTER TABLE SupplierInvoices ADD CONSTRAINT DF_SupplierInvoices_AmountPaid DEFAULT (0) FOR AmountPaid;
ALTER TABLE SupplierInvoices ADD CONSTRAINT DF_SupplierInvoices_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;
ALTER TABLE SupplierInvoices ADD CONSTRAINT DF_SupplierInvoices_Status DEFAULT ('Unpaid') FOR Status;
PRINT 'Recreated default constraints with QUOTED_IDENTIFIER ON';

PRINT 'Fix completed - default constraints now compatible with QUOTED_IDENTIFIER ON';
