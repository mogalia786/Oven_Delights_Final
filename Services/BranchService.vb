Imports System
Imports System.Data
Imports System.Configuration
Imports Oven_Delights_ERP.Logging
Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient

Public Class BranchService
    Private ReadOnly _logger As ILogger = New DebugLogger()
    Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Public Function GetBranchById(branchId As Integer) As Branch
        Try
            Using connection As New SqlConnection(_connectionString)
                connection.Open()
                ' Determine key column at runtime to support schemas with ID or BranchID
                Dim keyColumn As String = "ID"
                Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Branches' AND COLUMN_NAME = 'ID'", connection)
                    cmdCheck.CommandType = CommandType.Text
                    Dim hasID = Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0
                    If Not hasID Then keyColumn = "BranchID"
                End Using

                Dim query As String = $"SELECT * FROM Branches WHERE {keyColumn} = @BranchID"
                Using cmd As New SqlCommand(query, connection)
                    cmd.CommandType = CommandType.Text
                    cmd.Parameters.AddWithValue("@BranchID", branchId)
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            ' Map ID even if underlying column is BranchID
                            Dim idValue As Integer = If(ColumnExists(reader, "ID"), Convert.ToInt32(reader(If(ColumnExists(reader, "ID"), "ID", "BranchID"))), Convert.ToInt32(reader("BranchID")))
                            Return New Branch() With {
                                .ID = idValue,
                                .BranchCode = If(reader("BranchCode") IsNot DBNull.Value, reader("BranchCode").ToString(), String.Empty),
                                .BranchName = If(reader("BranchName") IsNot DBNull.Value, reader("BranchName").ToString(), String.Empty),
                                .Prefix = If(reader("Prefix") IsNot DBNull.Value, reader("Prefix").ToString(), String.Empty),
                                .Address = If(reader("Address") IsNot DBNull.Value, reader("Address").ToString(), String.Empty),
                                .City = If(reader("City") IsNot DBNull.Value, reader("City").ToString(), String.Empty),
                                .Province = If(reader("Province") IsNot DBNull.Value, reader("Province").ToString(), String.Empty),
                                .PostalCode = If(reader("PostalCode") IsNot DBNull.Value, reader("PostalCode").ToString(), String.Empty),
                                .Phone = If(reader("Phone") IsNot DBNull.Value, reader("Phone").ToString(), String.Empty),
                                .Email = If(reader("Email") IsNot DBNull.Value, reader("Email").ToString(), String.Empty),
                                .ManagerName = If(reader("ManagerName") IsNot DBNull.Value, reader("ManagerName").ToString(), String.Empty),
                                .IsActive = If(reader("IsActive") IsNot DBNull.Value, Convert.ToBoolean(reader("IsActive")), True),
                                .CreatedBy = If(reader("CreatedBy") IsNot DBNull.Value, Convert.ToInt32(reader("CreatedBy")), CType(Nothing, Integer?)),
                                .CreatedDate = If(reader("CreatedDate") IsNot DBNull.Value, Convert.ToDateTime(reader("CreatedDate")), CType(Nothing, DateTime?)),
                                .ModifiedBy = If(reader("ModifiedBy") IsNot DBNull.Value, Convert.ToInt32(reader("ModifiedBy")), CType(Nothing, Integer?)),
                                .ModifiedDate = If(reader("ModifiedDate") IsNot DBNull.Value, Convert.ToDateTime(reader("ModifiedDate")), CType(Nothing, DateTime?))
                            }
                        End If
                    End Using
                End Using
            End Using
            Return Nothing
        Catch ex As Exception
            _logger.LogError($"Error in GetBranchById: {ex.Message}")
            Throw
        End Try
    End Function

    Private Function ColumnExists(reader As IDataRecord, columnName As String) As Boolean
        For i = 0 To reader.FieldCount - 1
            If String.Equals(reader.GetName(i), columnName, StringComparison.OrdinalIgnoreCase) Then
                Return True
            End If
        Next
        Return False
    End Function

    ' ... rest of the BranchService class remains the same ...

    Private Function GetBranchKeyColumn(connection As SqlConnection, Optional transaction As SqlTransaction = Nothing) As String
        Using cmd As New SqlCommand("SELECT CASE WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Branches' AND COLUMN_NAME='ID') THEN 1 ELSE 0 END", connection, transaction)
            cmd.CommandType = CommandType.Text
            Dim hasId As Boolean = Convert.ToInt32(cmd.ExecuteScalar()) = 1
            Return If(hasId, "ID", "BranchID")
        End Using
    End Function

    Public Function GetAllBranches() As DataTable
        Dim dtBranches As New DataTable()
        Try
            Using connection As New SqlConnection(_connectionString)
                connection.Open()
                ' Use SELECT * to avoid invalid column errors across schema variants
                Dim query As String = "SELECT * FROM Branches ORDER BY BranchName"
                Using cmd As New SqlCommand(query, connection)
                    cmd.CommandType = CommandType.Text
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dtBranches)
                    End Using
                End Using
                ' Normalize ID column if only BranchID exists
                If Not dtBranches.Columns.Contains("ID") AndAlso dtBranches.Columns.Contains("BranchID") Then
                    dtBranches.Columns.Add("ID", GetType(Integer))
                    For Each row As DataRow In dtBranches.Rows
                        row("ID") = Convert.ToInt32(row("BranchID"))
                    Next
                End If
            End Using
        Catch ex As Exception
            _logger.LogError($"Error in GetAllBranches: {ex.Message}")
            Throw
        End Try
        Return dtBranches
    End Function

    Public Function SaveBranch(branchId As Integer, branchCode As String, branchName As String, 
                             prefix As String, address As String, city As String, 
                             province As String, postalCode As String, phone As String, 
                             email As String, managerName As String, isActive As Boolean, 
                             currentUserId As Integer) As Boolean
        Try
            Using connection As New SqlConnection(_connectionString)
                connection.Open()
                Using transaction As SqlTransaction = connection.BeginTransaction()
                    Try
                        Dim query As String
                        
                        If branchId = 0 Then
                            ' Insert new branch
                            query = "INSERT INTO Branches (BranchCode, BranchName, Prefix, Address, City, Province, " & _
                                   "PostalCode, Phone, Email, ManagerName, IsActive, CreatedBy, CreatedDate) " & _
                                   "VALUES (@BranchCode, @BranchName, @Prefix, @Address, @City, @Province, " & _
                                   "@PostalCode, @Phone, @Email, @ManagerName, @IsActive, @CreatedBy, GETDATE())"
                            
                            Using cmd As New SqlCommand(query, connection, transaction)
                                cmd.CommandType = CommandType.Text
                                cmd.Parameters.AddWithValue("@BranchCode", If(String.IsNullOrEmpty(branchCode), DBNull.Value, CObj(branchCode)))
                                cmd.Parameters.AddWithValue("@BranchName", If(String.IsNullOrEmpty(branchName), DBNull.Value, CObj(branchName)))
                                cmd.Parameters.AddWithValue("@Prefix", If(String.IsNullOrEmpty(prefix), DBNull.Value, CObj(prefix)))
                                cmd.Parameters.AddWithValue("@Address", If(String.IsNullOrEmpty(address), DBNull.Value, CObj(address)))
                                cmd.Parameters.AddWithValue("@City", If(String.IsNullOrEmpty(city), DBNull.Value, CObj(city)))
                                cmd.Parameters.AddWithValue("@Province", If(String.IsNullOrEmpty(province), DBNull.Value, CObj(province)))
                                cmd.Parameters.AddWithValue("@PostalCode", If(String.IsNullOrEmpty(postalCode), DBNull.Value, CObj(postalCode)))
                                cmd.Parameters.AddWithValue("@Phone", If(String.IsNullOrEmpty(phone), DBNull.Value, CObj(phone)))
                                cmd.Parameters.AddWithValue("@Email", If(String.IsNullOrEmpty(email), DBNull.Value, CObj(email)))
                                cmd.Parameters.AddWithValue("@ManagerName", If(String.IsNullOrEmpty(managerName), DBNull.Value, CObj(managerName)))
                                cmd.Parameters.AddWithValue("@IsActive", isActive)
                                cmd.Parameters.AddWithValue("@CreatedBy", currentUserId)
                                cmd.ExecuteNonQuery()
                            End Using
                        Else
                            ' Update existing branch
                            Dim keyCol As String = GetBranchKeyColumn(connection, transaction)
                            query = "UPDATE Branches SET " & _
                                   "BranchCode = @BranchCode, " & _
                                   "BranchName = @BranchName, " & _
                                   "Prefix = @Prefix, " & _
                                   "Address = @Address, " & _
                                   "City = @City, " & _
                                   "Province = @Province, " & _
                                   "PostalCode = @PostalCode, " & _
                                   "Phone = @Phone, " & _
                                   "Email = @Email, " & _
                                   "ManagerName = @ManagerName, " & _
                                   "IsActive = @IsActive, " & _
                                   "ModifiedBy = @ModifiedBy, " & _
                                   "ModifiedDate = GETDATE() " & _
                                   $"WHERE {keyCol} = @BranchID"
                            
                            Using cmd As New SqlCommand(query, connection, transaction)
                                cmd.CommandType = CommandType.Text
                                cmd.Parameters.AddWithValue("@BranchID", branchId)
                                cmd.Parameters.AddWithValue("@BranchCode", If(String.IsNullOrEmpty(branchCode), DBNull.Value, CObj(branchCode)))
                                cmd.Parameters.AddWithValue("@BranchName", If(String.IsNullOrEmpty(branchName), DBNull.Value, CObj(branchName)))
                                cmd.Parameters.AddWithValue("@Prefix", If(String.IsNullOrEmpty(prefix), DBNull.Value, CObj(prefix)))
                                cmd.Parameters.AddWithValue("@Address", If(String.IsNullOrEmpty(address), DBNull.Value, CObj(address)))
                                cmd.Parameters.AddWithValue("@City", If(String.IsNullOrEmpty(city), DBNull.Value, CObj(city)))
                                cmd.Parameters.AddWithValue("@Province", If(String.IsNullOrEmpty(province), DBNull.Value, CObj(province)))
                                cmd.Parameters.AddWithValue("@PostalCode", If(String.IsNullOrEmpty(postalCode), DBNull.Value, CObj(postalCode)))
                                cmd.Parameters.AddWithValue("@Phone", If(String.IsNullOrEmpty(phone), DBNull.Value, CObj(phone)))
                                cmd.Parameters.AddWithValue("@Email", If(String.IsNullOrEmpty(email), DBNull.Value, CObj(email)))
                                cmd.Parameters.AddWithValue("@ManagerName", If(String.IsNullOrEmpty(managerName), DBNull.Value, CObj(managerName)))
                                cmd.Parameters.AddWithValue("@IsActive", isActive)
                                cmd.Parameters.AddWithValue("@ModifiedBy", currentUserId)
                                cmd.ExecuteNonQuery()
                            End Using
                        End If
                        
                        transaction.Commit()
                        Return True
                        
                    Catch ex As Exception
                        transaction.Rollback()
                        _logger.LogError($"Error in SaveBranch: {ex.Message}")
                        Throw
                    End Try
                End Using
            End Using
        Catch ex As Exception
            _logger.LogError($"Error in SaveBranch: {ex.Message}")
            Throw
        End Try
    End Function

    Public Function DeleteBranch(branchId As Integer, currentUserId As Integer) As Boolean
        Try
            Using connection As New SqlConnection(_connectionString)
                connection.Open()
                Using transaction As SqlTransaction = connection.BeginTransaction()
                    Try
                        ' Check for active users
                        Dim userCount As Integer
                        Using cmd As New SqlCommand(
                            "SELECT COUNT(*) FROM Users WHERE BranchID = @BranchID AND IsActive = 1", 
                            connection, transaction)
                            cmd.CommandType = CommandType.Text
                            cmd.Parameters.AddWithValue("@BranchID", branchId)
                            userCount = Convert.ToInt32(cmd.ExecuteScalar())
                        End Using
                        
                        If userCount > 0 Then
                            transaction.Rollback()
                            MessageBox.Show(
                                $"Cannot delete branch. There are {userCount} active user(s) assigned to this branch.", 
                                "Cannot Delete", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                            Return False
                        End If
                        
                        ' Delete branch
                        Dim keyCol As String = GetBranchKeyColumn(connection, transaction)
                        Using cmd As New SqlCommand(
                            $"DELETE FROM Branches WHERE {keyCol} = @BranchID", connection, transaction)
                            cmd.CommandType = CommandType.Text
                            cmd.Parameters.AddWithValue("@BranchID", branchId)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        transaction.Commit()
                        Return True
                        
                    Catch ex As Exception
                        transaction.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        Catch ex As Exception
            _logger.LogError($"Error deleting branch: {ex.Message}")
            Throw
        End Try
    End Function
End Class