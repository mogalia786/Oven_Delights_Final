Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Text.Json

Public Class DashboardChartsService
    Private connectionString As String

    Public Sub New()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Public Function GetUserActivityChartData() As String
        Dim activeUsers As Integer = 0
        Dim inactiveUsers As Integer = 0

        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Users WHERE IsActive = 1", conn)
                activeUsers = Convert.ToInt32(cmd.ExecuteScalar())

                cmd.CommandText = "SELECT COUNT(*) FROM Users WHERE IsActive = 0"
                inactiveUsers = Convert.ToInt32(cmd.ExecuteScalar())
            Catch ex As Exception
                ' Return default data on error
                Return "{""labels"":[""Active"",""Inactive""],""data"":[0,0]}"
            End Try
        End Using

        Return $"{{""labels"":[""Active"",""Inactive""],""data"":[{activeUsers},{inactiveUsers}]}}"
    End Function

    Public Function GetLoginFrequencyChartData() As String
        Dim loginData As New List(Of Integer)()
        Dim labels As New List(Of String)()

        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                For i As Integer = 6 To 0 Step -1
                    Dim currentDate As DateTime = DateTime.Now.AddDays(-i)
                    Dim cmd As New SqlCommand("SELECT COUNT(*) FROM UserSessions WHERE CAST(LoginTime AS DATE) = @date", conn)
                    cmd.Parameters.AddWithValue("@date", currentDate.Date)
                    Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    loginData.Add(count)
                    labels.Add(currentDate.ToString("MM/dd"))
                Next
            Catch ex As Exception
                ' Return default data on error
                For i As Integer = 0 To 6
                    loginData.Add(0)
                    labels.Add(DateTime.Now.AddDays(-6 + i).ToString("MM/dd"))
                Next
            End Try
        End Using

        Dim labelsJson As String = String.Join(",", labels.Select(Function(l) $"""{l}"""))
        Dim dataJson As String = String.Join(",", loginData)
        Return $"{{""labels"":[{labelsJson}],""data"":[{dataJson}]}}"
    End Function

    Public Function GetBranchDistributionChartData() As String
        Dim branchData As New List(Of Object)()

        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT b.Name, COUNT(u.ID) as UserCount FROM Branches b LEFT JOIN Users u ON b.ID = u.BranchID WHERE b.IsActive = 1 GROUP BY b.Name", conn)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                
                While reader.Read()
                    branchData.Add(New With {
                        .BranchLabel = reader("Name").ToString(),
                        .BranchValue = Convert.ToInt32(reader("UserCount"))
                    })
                End While
                reader.Close()
            Catch ex As Exception
                ' Return default data on error
                branchData.Add(New With {.label = "No Data", .value = 0})
            End Try
        End Using

        If branchData.Count = 0 Then
            branchData.Add(New With {.BranchLabel = "No Branches", .BranchValue = 0})
        End If

        Dim labels As String = String.Join(",", branchData.Select(Function(b) $"""{b.BranchLabel}"""))
        Dim data As String = String.Join(",", branchData.Select(Function(b) b.BranchValue))
        Return $"{{""labels"":[{labels}],""data"":[{data}]}}"
    End Function

    Public Function GetRoleDistributionChartData() As String
        Dim roleData As New List(Of Object)()

        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT Role, COUNT(*) as RoleCount FROM Users WHERE IsActive = 1 GROUP BY Role", conn)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                
                While reader.Read()
                    roleData.Add(New With {
                        .RoleName = reader("Role").ToString(),
                        .RoleCount = Convert.ToInt32(reader("RoleCount"))
                    })
                End While
                reader.Close()
            Catch ex As Exception
                ' Return default data on error
                roleData.Add(New With {.role = "No Data", .count = 0})
            End Try
        End Using

        If roleData.Count = 0 Then
            roleData.Add(New With {.RoleName = "No Users", .RoleCount = 0})
        End If

        Dim labels As String = String.Join(",", roleData.Select(Function(r) $"""{r.RoleName}"""))
        Dim data As String = String.Join(",", roleData.Select(Function(r) r.RoleCount))
        Return $"{{""labels"":[{labels}],""data"":[{data}]}}"
    End Function

    Public Function GetActiveSessionsCount() As Integer
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM UserSessions WHERE IsActive = 1 AND LogoutTime IS NULL", conn)
                Return Convert.ToInt32(cmd.ExecuteScalar())
            Catch ex As Exception
                Return 0
            End Try
        End Using
    End Function

    Public Function GetUserRegistrationTrendsData() As String
        Dim registrationData As New List(Of Integer)()
        Dim labels As New List(Of String)()

        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                For i As Integer = 11 To 0 Step -1
                    Dim currentDate As DateTime = DateTime.Now.AddMonths(-i)
                    Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Users WHERE YEAR(CreatedDate) = @year AND MONTH(CreatedDate) = @month", conn)
                    cmd.Parameters.AddWithValue("@year", currentDate.Year)
                    cmd.Parameters.AddWithValue("@month", currentDate.Month)
                    Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    registrationData.Add(count)
                    labels.Add(currentDate.ToString("MMM yyyy"))
                Next
            Catch ex As Exception
                ' Return default data on error
                For i As Integer = 0 To 11
                    registrationData.Add(0)
                    labels.Add(DateTime.Now.AddMonths(-11 + i).ToString("MMM yyyy"))
                Next
            End Try
        End Using

        Dim labelsJson As String = String.Join(",", labels.Select(Function(l) $"""{l}"""))
        Dim dataJson As String = String.Join(",", registrationData)
        Return $"{{""labels"":[{labelsJson}],""data"":[{dataJson}]}}"
    End Function
End Class
