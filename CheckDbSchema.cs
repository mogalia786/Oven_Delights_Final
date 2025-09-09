using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

class Program
{
    static void Main()
    {
        string connectionString = ConfigurationManager.ConnectionStrings["OvenDelightsERPConnectionString"].ConnectionString;
        
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            try
            {
                connection.Open();
                Console.WriteLine("Successfully connected to the database.");
                
                // Get Users table schema
                Console.WriteLine("\nUsers Table Schema:");
                GetTableSchema(connection, "Users");
                
                // Get Roles table schema
                Console.WriteLine("\nRoles Table Schema:");
                GetTableSchema(connection, "Roles");
                
                // Get Branches table schema
                Console.WriteLine("\nBranches Table Schema:");
                GetTableSchema(connection, "Branches");
                
                // Get Permissions table schema
                Console.WriteLine("\nPermissions Table Schema:");
                GetTableSchema(connection, "Permissions");
                
                // Get RolePermissions table schema
                Console.WriteLine("\nRolePermissions Table Schema:");
                GetTableSchema(connection, "RolePermissions");
                
                // Check if there's any data in Users table
                CheckTableData(connection, "Users");
                
                // Check if there's any data in Roles table
                CheckTableData(connection, "Roles");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                Console.WriteLine(ex.StackTrace);
            }
        }
        
        Console.WriteLine("\nPress any key to exit...");
        Console.ReadKey();
    }
    
    static void GetTableSchema(SqlConnection connection, string tableName)
    {
        try
        {
            string query = $"SELECT TOP 1 * FROM {tableName}";
            using (SqlCommand command = new SqlCommand(query, connection))
            using (SqlDataReader reader = command.ExecuteReader(CommandBehavior.KeyInfo))
            {
                DataTable schemaTable = reader.GetSchemaTable();
                
                if (schemaTable != null)
                {
                    Console.WriteLine($"\nColumns in {tableName} table:");
                    Console.WriteLine("Column Name\t\tData Type\tNullable\tMax Length");
                    Console.WriteLine(new string('-', 60));
                    
                    foreach (DataRow row in schemaTable.Rows)
                    {
                        string columnName = row["ColumnName"].ToString();
                        string dataType = row["DataType"].ToString();
                        bool isNullable = (bool)row["AllowDBNull"];
                        int maxLength = row["ColumnSize"] is int ? (int)row["ColumnSize"] : 0;
                        
                        Console.WriteLine($"{columnName,-20}\t{dataType,-15}\t{isNullable,-8}\t{maxLength}");
                    }
                }
                else
                {
                    Console.WriteLine($"No schema information available for table: {tableName}");
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error getting schema for table {tableName}: {ex.Message}");
        }
    }
    
    static void CheckTableData(SqlConnection connection, string tableName)
    {
        try
        {
            string query = $"SELECT COUNT(*) FROM {tableName}";
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                int count = (int)command.ExecuteScalar();
                Console.WriteLine($"\n{tableName} table has {count} rows.");
                
                if (count > 0)
                {
                    query = $"SELECT TOP 5 * FROM {tableName}";
                    using (SqlCommand selectCommand = new SqlCommand(query, connection))
                    using (SqlDataReader reader = selectCommand.ExecuteReader())
                    {
                        Console.WriteLine($"\nFirst 5 rows in {tableName}:");
                        
                        // Print column headers
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            Console.Write($"{reader.GetName(i),-20}");
                        }
                        Console.WriteLine("\n" + new string('-', 20 * reader.FieldCount));
                        
                        // Print rows
                        while (reader.Read())
                        {
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                object value = reader[i];
                                string displayValue = (value == DBNull.Value) ? "NULL" : value.ToString();
                                Console.Write($"{displayValue,-20}");
                            }
                            Console.WriteLine();
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error checking data in table {tableName}: {ex.Message}");
        }
    }
}
