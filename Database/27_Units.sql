-- 27_Units.sql
-- Scalable Units of Measure lookup and UoMID FK across catalogs

SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Units' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Units (
        UoMID       INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Units PRIMARY KEY,
        UnitName    NVARCHAR(32) NOT NULL CONSTRAINT UQ_Units_UnitName UNIQUE,
        IsActive    BIT NOT NULL CONSTRAINT DF_Units_IsActive DEFAULT(1),
        CreatedDate DATETIME2(0) NOT NULL CONSTRAINT DF_Units_CreatedDate DEFAULT(SYSUTCDATETIME()),
        ModifiedDate DATETIME2(0) NULL
    );
END
GO

-- Seed common units (idempotent)
MERGE dbo.Units AS t
USING (VALUES
    (N'kg'), (N'g'), (N'L'), (N'ml'), (N'each'), (N'pack'), (N'box'), (N'dozen')
) AS s(UnitName)
ON t.UnitName = s.UnitName
WHEN NOT MATCHED BY TARGET THEN
    INSERT(UnitName, IsActive) VALUES(s.UnitName, 1);
GO

-- Helper: add UoMID column if missing, then add FK
DECLARE @tables TABLE(Name SYSNAME);
INSERT INTO @tables(Name)
VALUES (N'RawMaterials'), (N'SubAssemblies'), (N'Decorations'), (N'Toppings'), (N'Accessories'), (N'Packaging');

DECLARE @t SYSNAME;
DECLARE c CURSOR LOCAL FAST_FORWARD FOR SELECT Name FROM @tables;
OPEN c;
FETCH NEXT FROM c INTO @t;
WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = @t AND COLUMN_NAME = 'UoMID'
    )
    BEGIN
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'ALTER TABLE dbo.' + N'[' + @t + N'] ADD UoMID INT NULL';
        EXEC sp_executesql @sql;
    END;

    -- Add FK if not exists
    IF NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys fk
        WHERE fk.parent_object_id = OBJECT_ID('dbo.' + @t) AND fk.name = 'FK_' + @t + '_Units'
    )
    BEGIN
        DECLARE @sql2 NVARCHAR(MAX);
        SET @sql2 = N'ALTER TABLE dbo.' + N'[' + @t + N'] WITH NOCHECK ' +
                     N'ADD CONSTRAINT FK_' + @t + N'_Units FOREIGN KEY(UoMID) ' +
                     N'REFERENCES dbo.Units(UoMID)';
        EXEC sp_executesql @sql2;
    END;

    FETCH NEXT FROM c INTO @t;
END
CLOSE c; DEALLOCATE c;
GO

-- NOTE: Update unified inventory views separately to include UnitName if required.
