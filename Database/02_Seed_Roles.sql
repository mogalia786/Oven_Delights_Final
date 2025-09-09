-- Seed required application roles (idempotent)
SET NOCOUNT ON;

DECLARE @HasDescription bit = CASE WHEN COL_LENGTH('Roles','Description') IS NOT NULL THEN 1 ELSE 0 END;
DECLARE @HasIsActive  bit = CASE WHEN COL_LENGTH('Roles','IsActive')    IS NOT NULL THEN 1 ELSE 0 END;

IF OBJECT_ID('tempdb..#RolesToInsert') IS NOT NULL DROP TABLE #RolesToInsert;
CREATE TABLE #RolesToInsert (
  RoleName     nvarchar(50) NOT NULL,
  [Description] nvarchar(255) NULL
);

INSERT INTO #RolesToInsert (RoleName, [Description]) VALUES
('Super Administrator', 'Full system access'),
('Administrator', 'Administrative access'),
('Stockroom Manager', 'Stock management'),
('Manufacturing Manager', 'Manufacturing operations'),
('Retail Manager', 'Retail operations'),
('Accounting Manager', 'Accounting and finance operations'),
('Brand Manager', 'Branding and marketing operations'),
('Teller', 'Point-of-sale cashier role');

IF (@HasDescription = 1 AND @HasIsActive = 1)
BEGIN
    EXEC sp_executesql N'
        INSERT INTO Roles (RoleName, Description, IsActive)
        SELECT r.RoleName, r.[Description], 1
        FROM #RolesToInsert r
        WHERE NOT EXISTS (SELECT 1 FROM Roles x WHERE x.RoleName = r.RoleName);
    ';
END
ELSE IF (@HasDescription = 1 AND @HasIsActive = 0)
BEGIN
    EXEC sp_executesql N'
        INSERT INTO Roles (RoleName, Description)
        SELECT r.RoleName, r.[Description]
        FROM #RolesToInsert r
        WHERE NOT EXISTS (SELECT 1 FROM Roles x WHERE x.RoleName = r.RoleName);
    ';
END
ELSE
BEGIN
    EXEC sp_executesql N'
        INSERT INTO Roles (RoleName)
        SELECT r.RoleName
        FROM #RolesToInsert r
        WHERE NOT EXISTS (SELECT 1 FROM Roles x WHERE x.RoleName = r.RoleName);
    ';
END

DROP TABLE #RolesToInsert;

PRINT 'Seeded roles (if missing).';