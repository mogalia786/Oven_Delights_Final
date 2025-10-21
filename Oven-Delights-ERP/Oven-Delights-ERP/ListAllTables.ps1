# PowerShell script to list all tables in the Azure SQL database
$connectionString = "Server=tcp:mogalia.database.windows.net,1433;Initial Catalog=OvenDelightsERP;Persist Security Info=False;User ID=faroq786;Password=Faroq#786;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

Try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()
    
    Write-Host "Successfully connected to Azure SQL database" -ForegroundColor Green
    
    # Get all tables
    $query = @"
    SELECT 
        SCHEMA_NAME(schema_id) AS SchemaName,
        name AS TableName
    FROM sys.tables
    ORDER BY SchemaName, TableName;
"@
    
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $reader = $command.ExecuteReader()
    
    $tables = @()
    while ($reader.Read()) {
        $tables += [PSCustomObject]@{
            Schema = $reader["SchemaName"]
            Table = $reader["TableName"]
        }
    }
    
    $reader.Close()
    $connection.Close()
    
    # Display tables
    Write-Host "`n=== Tables in OvenDelightsERP ===" -ForegroundColor Cyan
    if ($tables.Count -gt 0) {
        $tables | Format-Table -AutoSize
        Write-Host "`nTotal tables found: $($tables.Count)" -ForegroundColor Green
        
        # Save to file
        $outputFile = "$PSScriptRoot\DatabaseTables_List.txt"
        $tables | Format-Table -AutoSize | Out-File -FilePath $outputFile -Force
        Write-Host "Table list saved to: $outputFile" -ForegroundColor Yellow
    } else {
        Write-Host "No tables found in the database." -ForegroundColor Yellow
    }
    
} Catch {
    Write-Host "Error connecting to database: $_" -ForegroundColor Red
    Write-Host "Connection string used: $($connectionString)" -ForegroundColor Yellow
}

Write-Host "`nPress any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
