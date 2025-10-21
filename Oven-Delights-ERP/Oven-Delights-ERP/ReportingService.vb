Imports System.Data
Imports System.IO
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class ReportingService
    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Public Function GenerateUserReport(Optional branchID As Integer? = Nothing) As DataTable
        Try
            Using connection As New SqlConnection(connectionString)
                Dim query As String = "
                    SELECT 
                        u.UserID,
                        u.Username,
                        u.Email,
                        u.FirstName,
                        u.LastName,
                        u.RoleID,
                        u.BranchID,
                        u.LastLogin,
                        u.IsActive,
                        u.CreatedDate
                    FROM Users u
                    WHERE u.IsActive = 1"
                
                If branchID.HasValue Then
                    query += " AND u.BranchID = @BranchID"
                End If
                
                query += " ORDER BY u.CreatedDate DESC"

                Using command As New SqlCommand(query, connection)
                    If branchID.HasValue Then
                        command.Parameters.AddWithValue("@BranchID", branchID.Value)
                    End If

                    Dim adapter As New SqlDataAdapter(command)
                    Dim dataTable As New DataTable()
                    adapter.Fill(dataTable)
                    Return dataTable
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error generating user report: " & ex.Message)
        End Try
    End Function

    Public Function GenerateAuditReport(startDate As DateTime, endDate As DateTime, Optional branchID As Integer? = Nothing) As DataTable
        Try
            Using connection As New SqlConnection(connectionString)
                Dim query As String = "
                    SELECT 
                        a.AuditID,
                        a.Action,
                        a.TableName,
                        a.RecordID,
                        a.OldValues,
                        a.NewValues,
                        a.Timestamp,
                        a.IPAddress,
                        a.UserAgent,
                        u.Username,
                        u.FirstName,
                        u.LastName
                    FROM AuditLog a
                    LEFT JOIN Users u ON a.UserID = u.UserID
                    WHERE a.Timestamp BETWEEN @StartDate AND @EndDate"
                
                If branchID.HasValue Then
                    query += " AND u.BranchID = @BranchID"
                End If
                
                query += " ORDER BY a.Timestamp DESC"

                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@StartDate", startDate)
                    command.Parameters.AddWithValue("@EndDate", endDate)
                    If branchID.HasValue Then
                        command.Parameters.AddWithValue("@BranchID", branchID.Value)
                    End If

                    Dim adapter As New SqlDataAdapter(command)
                    Dim dataTable As New DataTable()
                    adapter.Fill(dataTable)
                    Return dataTable
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error generating audit report: " & ex.Message)
        End Try
    End Function

    Public Function GenerateSessionReport(Optional isActive As Boolean? = Nothing) As DataTable
        Try
            Using connection As New SqlConnection(connectionString)
                Dim query As String = "
                    SELECT 
                        s.ID,
                        s.LoginTime,
                        s.LastActivity,
                        s.LogoutTime,
                        s.IPAddress,
                        s.UserAgent,
                        s.IsActive,
                        u.Username,
                        u.FirstName,
                        u.LastName,
                        u.BranchID
                    FROM UserSessions s
                    LEFT JOIN Users u ON s.UserID = u.UserID"
                
                If isActive.HasValue Then
                    query += " WHERE s.IsActive = @IsActive"
                End If
                
                query += " ORDER BY s.LoginTime DESC"

                Using command As New SqlCommand(query, connection)
                    If isActive.HasValue Then
                        command.Parameters.AddWithValue("@IsActive", isActive.Value)
                    End If

                    Dim adapter As New SqlDataAdapter(command)
                    Dim dataTable As New DataTable()
                    adapter.Fill(dataTable)
                    Return dataTable
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error generating session report: " & ex.Message)
        End Try
    End Function

    Public Function GenerateBranchReport() As DataTable
        Try
            Using connection As New SqlConnection(connectionString)
                Dim query As String = "
                    SELECT 
                        b.ID,
                        b.Name,
                        b.BranchCode,
                        b.Address,
                        b.City,
                        b.Province,
                        b.PostalCode,
                        b.Phone,
                        b.Email,
                        b.IsActive,
                        b.CreatedDate,
                        COUNT(u.UserID) as UserCount,
                        COUNT(CASE WHEN u.IsActive = 1 THEN 1 END) as ActiveUserCount
                    FROM Branches b
                    LEFT JOIN Users u ON b.ID = u.BranchID
                    GROUP BY b.ID, b.Name, b.BranchCode, b.Address, 
                             b.City, b.Province, b.PostalCode, b.Phone, b.Email, 
                             b.IsActive, b.CreatedDate
                    ORDER BY b.Name"

                Using command As New SqlCommand(query, connection)
                    Dim adapter As New SqlDataAdapter(command)
                    Dim dataTable As New DataTable()
                    adapter.Fill(dataTable)
                    Return dataTable
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error generating branch report: " & ex.Message)
        End Try
    End Function

    Public Function GenerateSecurityReport(days As Integer) As DataTable
        Try
            Using connection As New SqlConnection(connectionString)
                Dim query As String = "
                    SELECT 
                        a.Action,
                        COUNT(*) as ActionCount,
                        COUNT(DISTINCT a.UserID) as UniqueUsers,
                        MIN(a.Timestamp) as FirstOccurrence,
                        MAX(a.Timestamp) as LastOccurrence
                    FROM AuditLog a
                    WHERE a.Timestamp >= DATEADD(day, -@Days, GETDATE())
                    AND a.Action IN ('LOGIN_SUCCESS', 'LOGIN_FAILED', 'LOGOUT', 'PASSWORD_CHANGE', 'ACCOUNT_LOCKED')
                    GROUP BY a.Action
                    ORDER BY ActionCount DESC"

                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@Days", days)

                    Dim adapter As New SqlDataAdapter(command)
                    Dim dataTable As New DataTable()
                    adapter.Fill(dataTable)
                    Return dataTable
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error generating security report: " & ex.Message)
        End Try
    End Function

    Public Function ExportToCSV(dataTable As DataTable, filePath As String) As Boolean
        Try
            Using writer As New StreamWriter(filePath)
                ' Write headers
                Dim headers As String = String.Join(",", dataTable.Columns.Cast(Of DataColumn)().Select(Function(column) """" & column.ColumnName & """"))
                writer.WriteLine(headers)

                ' Write data rows
                For Each row As DataRow In dataTable.Rows
                    Dim values As String = String.Join(",", row.ItemArray.Select(Function(field) """" & field.ToString().Replace("""", """""") & """"))
                    writer.WriteLine(values)
                Next
            End Using
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Function ExportToExcel(dataTable As DataTable, filePath As String) As Boolean
        Try
            ' This would require Excel interop or EPPlus library
            ' For now, we'll export as CSV with .xlsx extension
            Return ExportToCSV(dataTable, filePath.Replace(".xlsx", ".csv"))
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Function GetDashboardStats() As Dictionary(Of String, Object)
        Try
            Using connection As New SqlConnection(connectionString)
                Dim stats As New Dictionary(Of String, Object)

                ' Total users
                Dim totalUsersQuery As String = "SELECT COUNT(*) FROM Users WHERE IsActive = 1"
                Using command As New SqlCommand(totalUsersQuery, connection)
                    connection.Open()
                    stats("TotalUsers") = command.ExecuteScalar()
                End Using

                ' Active sessions
                Dim activeSessionsQuery As String = "SELECT COUNT(*) FROM UserSessions WHERE IsActive = 1"
                Using command As New SqlCommand(activeSessionsQuery, connection)
                    stats("ActiveSessions") = command.ExecuteScalar()
                End Using

                ' Total branches
                Dim totalBranchesQuery As String = "SELECT COUNT(*) FROM Branches WHERE IsActive = 1"
                Using command As New SqlCommand(totalBranchesQuery, connection)
                    stats("TotalBranches") = command.ExecuteScalar()
                End Using

                ' Recent logins (last 24 hours)
                Dim recentLoginsQuery As String = "SELECT COUNT(*) FROM AuditLog WHERE Action = 'LOGIN_SUCCESS' AND Timestamp >= DATEADD(hour, -24, GETDATE())"
                Using command As New SqlCommand(recentLoginsQuery, connection)
                    stats("RecentLogins") = command.ExecuteScalar()
                End Using

                connection.Close()
                Return stats
            End Using
        Catch ex As Exception
            Throw New Exception("Error getting dashboard stats: " & ex.Message)
        End Try
    End Function
End Class
