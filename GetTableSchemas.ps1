# PowerShell script to get detailed schema information for all tables
$connectionString = "Server=tcp:mogalia.database.windows.net,1433;Initial Catalog=OvenDelightsERP;Persist Security Info=False;User ID=faroq786;Password=Faroq#786;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
$outputFile = "$PSScriptRoot\DatabaseSchema_Detailed.txt"

# Clear the output file
"=== Oven Delights ERP - Database Schema ===`nGenerated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n" | Out-File -FilePath $outputFile -Force

Try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()
    
    Write-Host "Successfully connected to Azure SQL database" -ForegroundColor Green
    
    # Get all tables
    $tablesQuery = @"
    SELECT 
        SCHEMA_NAME(schema_id) AS SchemaName,
        name AS TableName
    FROM sys.tables
    ORDER BY SchemaName, TableName;
"@
    
    $command = $connection.CreateCommand()
    $command.CommandText = $tablesQuery
    $reader = $command.ExecuteReader()
    
    $tables = @()
    while ($reader.Read()) {
        $tables += [PSCustomObject]@{
            Schema = $reader["SchemaName"]
            Table = $reader["TableName"]
        }
    }
    $reader.Close()
    
    # Get schema for each table
    foreach ($table in $tables) {
        $schemaQuery = @"
        SELECT 
            c.name AS ColumnName,
            t.name AS DataType,
            c.max_length,
            c.precision,
            c.scale,
            c.is_nullable,
            ISNULL(ISNULL(i.is_primary_key, 0), 0) AS is_primary_key,
            c.is_identity,
            ISNULL(OBJECT_NAME(fk.referenced_object_id), '') AS referenced_table,
            ISNULL(COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id), '') AS referenced_column
        FROM 
            sys.columns c
        INNER JOIN 
            sys.types t ON c.user_type_id = t.user_type_id
        LEFT JOIN 
            sys.index_columns ic ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        LEFT JOIN 
            sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id AND i.is_primary_key = 1
        LEFT JOIN
            sys.foreign_key_columns fkc ON c.object_id = fkc.parent_object_id AND c.column_id = fkc.parent_column_id
        LEFT JOIN
            sys.foreign_keys fk ON fkc.constraint_object_id = fk.object_id
        WHERE 
            c.object_id = OBJECT_ID('[$($table.Schema)].[$($table.Table)]')
        ORDER BY 
            c.column_id;
"@
        $command.CommandText = $schemaQuery
        $schemaReader = $command.ExecuteReader()
        
        "`n=== TABLE: [$($table.Schema)].[$($table.Table)] ===" | Out-File -FilePath $outputFile -Append
        
        $schemaTable = New-Object System.Data.DataTable
        $schemaTable.Load($schemaReader)
        
        # Format and output the schema
        $schemaTable | Format-Table -AutoSize | Out-String -Width 200 | Out-File -FilePath $outputFile -Append
        
        # Add foreign key information
        $fkQuery = @"
        SELECT 
            fk.name AS ForeignKeyName,
            SCHEMA_NAME(fk.schema_id) AS SchemaName,
            OBJECT_NAME(fk.parent_object_id) AS TableName,
            COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
            SCHEMA_NAME(o.schema_id) AS ReferencedSchemaName,
            OBJECT_NAME(fk.referenced_object_id) AS ReferencedTableName,
            COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferencedColumnName
        FROM 
            sys.foreign_keys fk
        INNER JOIN 
            sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
        INNER JOIN
            sys.objects o ON fk.referenced_object_id = o.object_id
        WHERE 
            fk.parent_object_id = OBJECT_ID('[$($table.Schema)].[$($table.Table)]')
        ORDER BY 
            fk.name;
"@
        $command.CommandText = $fkQuery
        $fkReader = $command.ExecuteReader()
        
        $fkTable = New-Object System.Data.DataTable
        $fkTable.Load($fkReader)
        
        if ($fkTable.Rows.Count -gt 0) {
            "`nFOREIGN KEYS:" | Out-File -FilePath $outputFile -Append
            $fkTable | Format-Table -AutoSize | Out-String -Width 200 | Out-File -FilePath $outputFile -Append
        }
        
        $schemaReader.Close()
    }
    
    $connection.Close()
    Write-Host "Database schema has been saved to: $outputFile" -ForegroundColor Green
    
} Catch {
    Write-Host "Error: $_" -ForegroundColor Red
    $errorMessage = $_.Exception.Message
    Write-Host "Error details: $errorMessage" -ForegroundColor Red
    Write-Host "Stack Trace: $($_.ScriptStackTrace)" -ForegroundColor Red
}

# Open the output file
Invoke-Item $outputFile
