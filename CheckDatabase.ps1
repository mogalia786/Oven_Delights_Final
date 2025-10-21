# PowerShell script to check database connection and list tables
$server = "localhost"
$database = "OvenDelightsERP"
$connectionString = "Server=$server;Database=$database;Trusted_Connection=True;"

Try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()
    
    Write-Host "Successfully connected to $database on $server" -ForegroundColor Green
    
    # Get all tables
    $query = @"
    SELECT SCHEMA_NAME(schema_id) AS SchemaName,
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
    Write-Host "`n=== Tables in $database ===" -ForegroundColor Cyan
    if ($tables.Count -gt 0) {
        $tables | Format-Table -AutoSize
    } else {
        Write-Host "No tables found in the database." -ForegroundColor Yellow
    }
    
} Catch {
    Write-Host "Error connecting to database: $_" -ForegroundColor Red
    Write-Host "Connection string used: $connectionString" -ForegroundColor Yellow
}

Write-Host "`nPress any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
