Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Text.Json
Imports Oven_Delights_ERP.Services

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

    Public Function GetLastLoginFrequencyChartData() As String
        Dim loginData As New List(Of Integer)()
        Dim labels As New List(Of String)()

        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                For i As Integer = 6 To 0 Step -1
                    Dim currentDate As DateTime = TimeProvider.Now().AddDays(-i)
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
                    labels.Add(TimeProvider.Now().AddDays(-6 + i).ToString("MM/dd"))
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
                ' First attempt: Branches has ID PK and BranchName, Users has UserID and BranchID
                Dim sql1 As String = "SELECT b.BranchName AS BranchName, COUNT(u.UserID) AS UserCount " & _
                                     "FROM Branches b LEFT JOIN Users u ON u.BranchID = b.ID " & _
                                     "GROUP BY b.BranchName"
                Using cmd As New SqlCommand(sql1, conn)
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            branchData.Add(New With {
                                .BranchLabel = reader("BranchName").ToString(),
                                .BranchValue = Convert.ToInt32(reader("UserCount"))
                            })
                        End While
                    End Using
                End Using
            Catch ex1 As Exception
                ' Fallback: Branches has BranchID as PK
                Try
                    Dim sql2 As String = "SELECT b.BranchName AS BranchName, COUNT(u.UserID) AS UserCount " & _
                                         "FROM Branches b LEFT JOIN Users u ON u.BranchID = b.BranchID " & _
                                         "GROUP BY b.BranchName"
                    Using cmd2 As New SqlCommand(sql2, conn)
                        Using reader2 As SqlDataReader = cmd2.ExecuteReader()
                            While reader2.Read()
                                branchData.Add(New With {
                                    .BranchLabel = reader2("BranchName").ToString(),
                                    .BranchValue = Convert.ToInt32(reader2("UserCount"))
                                })
                            End While
                        End Using
                    End Using
                Catch
                    ' Return default data on error
                End Try
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
                Dim sql As String = "SELECT r.RoleName AS RoleName, COUNT(*) AS RoleCount " & _
                                    "FROM Users u LEFT JOIN Roles r ON u.RoleID = r.RoleID " & _
                                    "WHERE u.IsActive = 1 " & _
                                    "GROUP BY r.RoleName"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            roleData.Add(New With {
                                .Role = Convert.ToString(reader("RoleName")),
                                .RoleCount = Convert.ToInt32(reader("RoleCount"))
                            })
                        End While
                    End Using
                End Using
            Catch
                ' Return default data on error
            End Try
        End Using

        If roleData.Count = 0 Then
            roleData.Add(New With {.Role = "No Users", .RoleCount = 0})
        End If

        Dim labels As String = String.Join(",", roleData.Select(Function(r) $"""{r.Role}"""))
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
                    Dim currentDate As DateTime = TimeProvider.Now().AddMonths(-i)
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
                    labels.Add(TimeProvider.Now().AddMonths(-11 + i).ToString("MMM yyyy"))
                Next
            End Try
        End Using

        Dim labelsJson As String = String.Join(",", labels.Select(Function(l) $"""{l}"""))
        Dim dataJson As String = String.Join(",", registrationData)
        Return $"{{""labels"":[{labelsJson}],""data"":[{dataJson}]}}"
    End Function
End Class
