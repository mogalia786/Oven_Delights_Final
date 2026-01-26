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

        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM Users WHERE IsActive = 1", conn)
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

        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                For i As Integer = 6 To 0 Step -1
                    Dim currentDate As DateTime = TimeProvider.Now().AddDays(-i)
                    Dim cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM UserSessions WHERE CAST(LoginTime AS DATE) = @date", conn)
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

        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                ' First attempt: Branches has ID PK and BranchName, Users has UserID and BranchID
                Dim sql1 As String = "SELECT b.BranchName AS BranchName, COUNT(u.UserID) AS UserCount " & _
                                     "FROM Branches b LEFT JOIN Users u ON u.BranchID = b.ID " & _
                                     "GROUP BY b.BranchName"
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql1, conn)
                    Using reader As Microsoft.Data.SqlClient.SqlDataReader = cmd.ExecuteReader()
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
                    Using cmd2 As New Microsoft.Data.SqlClient.SqlCommand(sql2, conn)
                        Using reader2 As Microsoft.Data.SqlClient.SqlDataReader = cmd2.ExecuteReader()
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

        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                Dim sql As String = "SELECT r.RoleName AS RoleName, COUNT(*) AS RoleCount " & _
                                    "FROM Users u LEFT JOIN Roles r ON u.RoleID = r.RoleID " & _
                                    "WHERE u.IsActive = 1 " & _
                                    "GROUP BY r.RoleName"
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                    Using reader As Microsoft.Data.SqlClient.SqlDataReader = cmd.ExecuteReader()
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
        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM UserSessions WHERE IsActive = 1 AND LogoutTime IS NULL", conn)
                Return Convert.ToInt32(cmd.ExecuteScalar())
            Catch ex As Exception
                Return 0
            End Try
        End Using
    End Function

    Public Function GetUserRegistrationTrendsData() As String
        Dim registrationData As New List(Of Integer)()
        Dim labels As New List(Of String)()

        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                For i As Integer = 11 To 0 Step -1
                    Dim currentDate As DateTime = TimeProvider.Now().AddMonths(-i)
                    Dim cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM Users WHERE YEAR(CreatedDate) = @year AND MONTH(CreatedDate) = @month", conn)
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

    ' ========== SALES ANALYTICS FOR SUPER ADMIN DASHBOARD ==========

    Public Function GetDailySalesChartData(Optional branchId As Integer = 0) As String
        Dim salesData As New List(Of Decimal)()
        Dim labels As New List(Of String)()

        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                For i As Integer = 6 To 0 Step -1
                    Dim currentDate As DateTime = DateTime.Now.AddDays(-i)
                    Dim sql As String = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Demo_Sales " &
                                       "WHERE CAST(SaleDate AS DATE) = @date"
                    
                    If branchId > 0 Then
                        sql &= " AND BranchID = @branchId"
                    End If

                    Dim cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@date", currentDate.Date)
                    If branchId > 0 Then cmd.Parameters.AddWithValue("@branchId", branchId)
                    
                    Dim total As Decimal = Convert.ToDecimal(cmd.ExecuteScalar())
                    salesData.Add(total)
                    labels.Add(currentDate.ToString("MM/dd"))
                Next
            Catch ex As Exception
                For i As Integer = 0 To 6
                    salesData.Add(0)
                    labels.Add(DateTime.Now.AddDays(-6 + i).ToString("MM/dd"))
                Next
            End Try
        End Using

        Dim labelsJson As String = String.Join(",", labels.Select(Function(l) $"""{l}"""))
        Dim dataJson As String = String.Join(",", salesData)
        Return $"{{""labels"":[{labelsJson}],""data"":[{dataJson}]}}"
    End Function

    Public Function GetMonthlySalesChartData(Optional branchId As Integer = 0) As String
        Dim salesData As New List(Of Decimal)()
        Dim labels As New List(Of String)()

        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                For i As Integer = 11 To 0 Step -1
                    Dim currentDate As DateTime = DateTime.Now.AddMonths(-i)
                    Dim sql As String = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Demo_Sales " &
                                       "WHERE YEAR(SaleDate) = @year AND MONTH(SaleDate) = @month"
                    
                    If branchId > 0 Then
                        sql &= " AND BranchID = @branchId"
                    End If

                    Dim cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@year", currentDate.Year)
                    cmd.Parameters.AddWithValue("@month", currentDate.Month)
                    If branchId > 0 Then cmd.Parameters.AddWithValue("@branchId", branchId)
                    
                    Dim total As Decimal = Convert.ToDecimal(cmd.ExecuteScalar())
                    salesData.Add(total)
                    labels.Add(currentDate.ToString("MMM yyyy"))
                Next
            Catch ex As Exception
                For i As Integer = 0 To 11
                    salesData.Add(0)
                    labels.Add(DateTime.Now.AddMonths(-11 + i).ToString("MMM yyyy"))
                Next
            End Try
        End Using

        Dim labelsJson As String = String.Join(",", labels.Select(Function(l) $"""{l}"""))
        Dim dataJson As String = String.Join(",", salesData)
        Return $"{{""labels"":[{labelsJson}],""data"":[{dataJson}]}}"
    End Function

    Public Function GetSalesByBranchChartData() As String
        Dim branchData As New List(Of Object)()

        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                Dim sql As String = "SELECT b.BranchName, ISNULL(SUM(s.TotalAmount), 0) AS TotalSales " &
                                   "FROM Branches b " &
                                   "LEFT JOIN Demo_Sales s ON s.BranchID = b.BranchID " &
                                   "WHERE s.SaleDate >= DATEADD(MONTH, -1, GETDATE()) OR s.SaleDate IS NULL " &
                                   "GROUP BY b.BranchName " &
                                   "ORDER BY TotalSales DESC"
                
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                    Using reader As Microsoft.Data.SqlClient.SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            branchData.Add(New With {
                                .BranchLabel = reader("BranchName").ToString(),
                                .BranchValue = Convert.ToDecimal(reader("TotalSales"))
                            })
                        End While
                    End Using
                End Using
            Catch ex As Exception
                branchData.Add(New With {.BranchLabel = "No Data", .BranchValue = 0D})
            End Try
        End Using

        If branchData.Count = 0 Then
            branchData.Add(New With {.BranchLabel = "No Sales", .BranchValue = 0D})
        End If

        Dim labels As String = String.Join(",", branchData.Select(Function(b) $"""{b.BranchLabel}"""))
        Dim data As String = String.Join(",", branchData.Select(Function(b) b.BranchValue))
        Return $"{{""labels"":[{labels}],""data"":[{data}]}}"
    End Function

    Public Function GetTopProductsChartData(Optional top As Integer = 10, Optional branchId As Integer = 0) As String
        Dim productData As New List(Of Object)()

        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                Dim sql As String = $"SELECT TOP {top} p.Name AS ProductName, " &
                                   "ISNULL(SUM(sl.Quantity), 0) AS TotalQuantity " &
                                   "FROM Demo_SalesLines sl " &
                                   "INNER JOIN Demo_Sales s ON sl.SaleID = s.SaleID " &
                                   "INNER JOIN Demo_Retail_Product p ON sl.ProductID = p.ProductID " &
                                   "WHERE s.SaleDate >= DATEADD(MONTH, -1, GETDATE())"
                
                If branchId > 0 Then
                    sql &= " AND s.BranchID = @branchId"
                End If
                
                sql &= " GROUP BY p.Name ORDER BY TotalQuantity DESC"
                
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                    If branchId > 0 Then cmd.Parameters.AddWithValue("@branchId", branchId)
                    
                    Using reader As Microsoft.Data.SqlClient.SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            productData.Add(New With {
                                .ProductLabel = reader("ProductName").ToString(),
                                .ProductValue = Convert.ToInt32(reader("TotalQuantity"))
                            })
                        End While
                    End Using
                End Using
            Catch ex As Exception
                productData.Add(New With {.ProductLabel = "No Data", .ProductValue = 0})
            End Try
        End Using

        If productData.Count = 0 Then
            productData.Add(New With {.ProductLabel = "No Sales", .ProductValue = 0})
        End If

        Dim labels As String = String.Join(",", productData.Select(Function(p) $"""{p.ProductLabel}"""))
        Dim data As String = String.Join(",", productData.Select(Function(p) p.ProductValue))
        Return $"{{""labels"":[{labels}],""data"":[{data}]}}"
    End Function

    Public Function GetSalesVsCostChartData(Optional branchId As Integer = 0) As String
        Dim salesData As New List(Of Decimal)()
        Dim costData As New List(Of Decimal)()
        Dim labels As New List(Of String)()

        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                For i As Integer = 6 To 0 Step -1
                    Dim currentDate As DateTime = DateTime.Now.AddDays(-i)
                    
                    Dim salesSql As String = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Demo_Sales " &
                                            "WHERE CAST(SaleDate AS DATE) = @date"
                    Dim costSql As String = "SELECT ISNULL(SUM(sl.Quantity * ISNULL(p.AverageCost, 0)), 0) " &
                                           "FROM Demo_SalesLines sl " &
                                           "INNER JOIN Demo_Sales s ON sl.SaleID = s.SaleID " &
                                           "INNER JOIN Demo_Retail_Product p ON sl.ProductID = p.ProductID " &
                                           "WHERE CAST(s.SaleDate AS DATE) = @date"
                    
                    If branchId > 0 Then
                        salesSql &= " AND BranchID = @branchId"
                        costSql &= " AND s.BranchID = @branchId"
                    End If

                    Dim cmdSales As New Microsoft.Data.SqlClient.SqlCommand(salesSql, conn)
                    cmdSales.Parameters.AddWithValue("@date", currentDate.Date)
                    If branchId > 0 Then cmdSales.Parameters.AddWithValue("@branchId", branchId)
                    
                    Dim cmdCost As New Microsoft.Data.SqlClient.SqlCommand(costSql, conn)
                    cmdCost.Parameters.AddWithValue("@date", currentDate.Date)
                    If branchId > 0 Then cmdCost.Parameters.AddWithValue("@branchId", branchId)
                    
                    salesData.Add(Convert.ToDecimal(cmdSales.ExecuteScalar()))
                    costData.Add(Convert.ToDecimal(cmdCost.ExecuteScalar()))
                    labels.Add(currentDate.ToString("MM/dd"))
                Next
            Catch ex As Exception
                For i As Integer = 0 To 6
                    salesData.Add(0)
                    costData.Add(0)
                    labels.Add(DateTime.Now.AddDays(-6 + i).ToString("MM/dd"))
                Next
            End Try
        End Using

        Dim labelsJson As String = String.Join(",", labels.Select(Function(l) $"""{l}"""))
        Dim salesJson As String = String.Join(",", salesData)
        Dim costJson As String = String.Join(",", costData)
        Return $"{{""labels"":[{labelsJson}],""sales"":[{salesJson}],""cost"":[{costJson}]}}"
    End Function

    Public Function GetTodaysSalesTotal(Optional branchId As Integer = 0) As Decimal
        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                Dim sql As String = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Demo_Sales " &
                                   "WHERE CAST(SaleDate AS DATE) = CAST(GETDATE() AS DATE)"
                
                If branchId > 0 Then
                    sql &= " AND BranchID = @branchId"
                End If

                Dim cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                If branchId > 0 Then cmd.Parameters.AddWithValue("@branchId", branchId)
                
                Return Convert.ToDecimal(cmd.ExecuteScalar())
            Catch ex As Exception
                Return 0D
            End Try
        End Using
    End Function

    Public Function GetMonthSalesTotal(Optional branchId As Integer = 0) As Decimal
        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                Dim sql As String = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Demo_Sales " &
                                   "WHERE YEAR(SaleDate) = YEAR(GETDATE()) AND MONTH(SaleDate) = MONTH(GETDATE())"
                
                If branchId > 0 Then
                    sql &= " AND BranchID = @branchId"
                End If

                Dim cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                If branchId > 0 Then cmd.Parameters.AddWithValue("@branchId", branchId)
                
                Return Convert.ToDecimal(cmd.ExecuteScalar())
            Catch ex As Exception
                Return 0D
            End Try
        End Using
    End Function

    Public Function GetYearSalesTotal(Optional branchId As Integer = 0) As Decimal
        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                Dim sql As String = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Demo_Sales " &
                                   "WHERE YEAR(SaleDate) = YEAR(GETDATE())"
                
                If branchId > 0 Then
                    sql &= " AND BranchID = @branchId"
                End If

                Dim cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                If branchId > 0 Then cmd.Parameters.AddWithValue("@branchId", branchId)
                
                Return Convert.ToDecimal(cmd.ExecuteScalar())
            Catch ex As Exception
                Return 0D
            End Try
        End Using
    End Function

    Public Function GetTotalTransactionsCount(Optional branchId As Integer = 0) As Integer
        Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
            Try
                conn.Open()
                Dim sql As String = "SELECT COUNT(*) FROM Demo_Sales WHERE CAST(SaleDate AS DATE) = CAST(GETDATE() AS DATE)"
                
                If branchId > 0 Then
                    sql &= " AND BranchID = @branchId"
                End If

                Dim cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                If branchId > 0 Then cmd.Parameters.AddWithValue("@branchId", branchId)
                
                Return Convert.ToInt32(cmd.ExecuteScalar())
            Catch ex As Exception
                Return 0
            End Try
        End Using
    End Function
End Class
