/* Seed role 'Manufacturer' if it does not exist.
   This role is intended for manufacturing floor staff (bakers/operators).
   Non-destructive: it will not modify or remove any existing roles such as 'Manufacturing Manager'. */

SET NOCOUNT ON;

IF NOT EXISTS (
    SELECT 1 FROM dbo.Roles WHERE UPPER(RoleName) = UPPER('Manufacturer')
)
BEGIN
    INSERT INTO dbo.Roles(RoleName)
    VALUES ('Manufacturer');
END
GO
