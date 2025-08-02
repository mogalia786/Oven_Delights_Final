Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Data
Imports BCrypt.Net

Public Class UserService
    Private connectionString As String

    Public Sub New()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Public Function GetAllUsers() As DataTable
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT u.ID, u.Username, u.Email, u.FirstName, u.LastName, u.Role, b.Name as BranchName, u.IsActive, u.CreatedDate, u.LastLogin FROM Users u LEFT JOIN Branches b ON u.BranchID = b.ID ORDER BY u.CreatedDate DESC", conn)
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)
            Catch ex As Exception
                MessageBox.Show("Error loading users: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
        Return dt
    End Function

    Public Function SearchUsers(searchTerm As String) As DataTable
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT u.ID, u.Username, u.Email, u.FirstName, u.LastName, u.Role, b.Name as BranchName, u.IsActive, u.CreatedDate, u.LastLogin FROM Users u LEFT JOIN Branches b ON u.BranchID = b.ID WHERE u.Username LIKE @search OR u.Email LIKE @search OR u.FirstName LIKE @search OR u.LastName LIKE @search ORDER BY u.CreatedDate DESC", conn)
                cmd.Parameters.AddWithValue("@search", "%" & searchTerm & "%")
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)
            Catch ex As Exception
                MessageBox.Show("Error searching users: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
        Return dt
    End Function

    Public Function CreateUser(username As String, password As String, email As String, firstName As String, lastName As String, role As String, branchID As Integer?) As Boolean
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim hashedPassword As String = BCrypt.Net.BCrypt.HashPassword(password)
                Dim cmd As New SqlCommand("INSERT INTO Users (Username, Password, Email, FirstName, LastName, Role, BranchID, PasswordHash, CreatedDate) VALUES (@username, @password, @email, @firstName, @lastName, @role, @branchID, @passwordHash, GETDATE())", conn)
                cmd.Parameters.AddWithValue("@username", username)
                cmd.Parameters.AddWithValue("@password", password)
                cmd.Parameters.AddWithValue("@email", email)
                cmd.Parameters.AddWithValue("@firstName", firstName)
                cmd.Parameters.AddWithValue("@lastName", lastName)
                cmd.Parameters.AddWithValue("@role", role)
                cmd.Parameters.AddWithValue("@branchID", If(branchID.HasValue, branchID.Value, DBNull.Value))
                cmd.Parameters.AddWithValue("@passwordHash", hashedPassword)
                cmd.ExecuteNonQuery()
                LogAuditAction(Nothing, "UserCreated", "Users", Nothing, $"Created user: {username}")
                Return True
            Catch ex As Exception
                MessageBox.Show("Error creating user: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Using
    End Function

    Public Function UpdateUser(userID As Integer, username As String, email As String, firstName As String, lastName As String, role As String, branchID As Integer?, isActive As Boolean) As Boolean
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("UPDATE Users SET Username=@username, Email=@email, FirstName=@firstName, LastName=@lastName, Role=@role, BranchID=@branchID, IsActive=@isActive WHERE ID=@userID", conn)
                cmd.Parameters.AddWithValue("@userID", userID)
                cmd.Parameters.AddWithValue("@username", username)
                cmd.Parameters.AddWithValue("@email", email)
                cmd.Parameters.AddWithValue("@firstName", firstName)
                cmd.Parameters.AddWithValue("@lastName", lastName)
                cmd.Parameters.AddWithValue("@role", role)
                cmd.Parameters.AddWithValue("@branchID", If(branchID.HasValue, branchID.Value, DBNull.Value))
                cmd.Parameters.AddWithValue("@isActive", isActive)
                cmd.ExecuteNonQuery()
                LogAuditAction(Nothing, "UserUpdated", "Users", userID, $"Updated user: {username}")
                Return True
            Catch ex As Exception
                MessageBox.Show("Error updating user: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Using
    End Function

    Public Function DeleteUser(userID As Integer) As Boolean
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("UPDATE Users SET IsActive=0 WHERE ID=@userID", conn)
                cmd.Parameters.AddWithValue("@userID", userID)
                cmd.ExecuteNonQuery()
                LogAuditAction(Nothing, "UserDeleted", "Users", userID, $"Deactivated user ID: {userID}")
                Return True
            Catch ex As Exception
                MessageBox.Show("Error deleting user: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Using
    End Function

    Private Sub LogAuditAction(userID As Integer?, action As String, tableName As String, recordID As Integer?, details As String)
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Details, Timestamp) VALUES (@userID, @action, @tableName, @recordID, @details, GETDATE())", conn)
                cmd.Parameters.AddWithValue("@userID", If(userID.HasValue, userID.Value, DBNull.Value))
                cmd.Parameters.AddWithValue("@action", action)
                cmd.Parameters.AddWithValue("@tableName", tableName)
                cmd.Parameters.AddWithValue("@recordID", If(recordID.HasValue, recordID.Value, DBNull.Value))
                cmd.Parameters.AddWithValue("@details", details)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                ' Silent fail for audit logging to prevent cascading errors
            End Try
        End Using
    End Sub
End Class
