Imports System.Windows.Forms.DataVisualization.Charting
Imports System.Drawing

Namespace Admin
    Partial Public Class ExecutiveDashboard
        
        Private Sub LoadInvoicesByBranch()
            Try
                chartInvoicesByBranch.Series.Clear()
                Dim series As New Series("Sales") With {
                    .ChartType = SeriesChartType.Pie,
                    .IsValueShownAsLabel = True,
                    .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                    .LabelForeColor = JarvisCyan
                }

                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()
                    ' Use Demo_Sales data grouped by branch
                    Dim sql As String = "SELECT b.BranchName, ISNULL(SUM(s.TotalAmount), 0) AS Total " &
                                       "FROM Branches b " &
                                       "LEFT JOIN Demo_Sales s ON b.BranchID = s.BranchID " &
                                       "WHERE b.IsActive = 1 AND s.SaleDate >= DATEADD(DAY, -90, (SELECT MAX(SaleDate) FROM Demo_Sales)) " &
                                       "GROUP BY b.BranchName " &
                                       "HAVING SUM(s.TotalAmount) > 0 " &
                                       "ORDER BY Total DESC"

                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                Dim branchName = reader("BranchName").ToString().ToUpper()
                                Dim pt = series.Points.AddXY(branchName, Convert.ToDecimal(reader("Total")))
                                
                                ' Use branch-specific color
                                If branchColors.ContainsKey(branchName) Then
                                    series.Points(pt).Color = branchColors(branchName)
                                Else
                                    series.Points(pt).Color = JarvisCyan
                                End If
                                series.Points(pt).LegendText = branchName
                            End While
                        End Using
                    End Using
                End Using

                chartInvoicesByBranch.Series.Add(series)

                Dim legend As New Legend("Legend1") With {
                    .Docking = Docking.Bottom,
                    .ForeColor = JarvisCyan,
                    .BackColor = JarvisDarkGray
                }
                chartInvoicesByBranch.Legends.Add(legend)
            Catch ex As Exception
            End Try
        End Sub

        Private Sub LoadOrderTypes()
            Try
                chartOrderTypes.Series.Clear()
                chartOrderTypes.Legends.Clear()

                ' Create pie chart series for product categories
                Dim series As New Series("Categories") With {
                    .ChartType = SeriesChartType.Pie,
                    .IsValueShownAsLabel = True,
                    .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                    .LabelForeColor = JarvisCyan
                }

                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()
                    
                    Dim dateFilter = GetSalesDateFilter()
                    
                    ' Get sales by product category
                    Dim sql As String = $"SELECT " &
                                       $"SUM(CASE WHEN s.ProductName LIKE '%cake%' THEN 1 ELSE 0 END) AS Cakes, " &
                                       $"SUM(CASE WHEN s.ProductName LIKE '%pastry%' OR s.ProductName LIKE '%tart%' THEN 1 ELSE 0 END) AS Pastries, " &
                                       $"SUM(CASE WHEN s.ProductName LIKE '%bread%' OR s.ProductName LIKE '%loaf%' THEN 1 ELSE 0 END) AS Bread, " &
                                       $"SUM(CASE WHEN s.ProductName NOT LIKE '%cake%' AND s.ProductName NOT LIKE '%pastry%' AND s.ProductName NOT LIKE '%tart%' AND s.ProductName NOT LIKE '%bread%' AND s.ProductName NOT LIKE '%loaf%' THEN 1 ELSE 0 END) AS Other " &
                                       $"FROM Demo_Sales s WHERE {dateFilter}"

                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                Dim cakes = Convert.ToInt32(reader("Cakes"))
                                Dim pastries = Convert.ToInt32(reader("Pastries"))
                                Dim bread = Convert.ToInt32(reader("Bread"))
                                Dim other = Convert.ToInt32(reader("Other"))
                                
                                If cakes > 0 Then
                                    Dim pt = series.Points.AddXY("Cakes", cakes)
                                    series.Points(pt).Color = BranchGold
                                End If
                                If pastries > 0 Then
                                    Dim pt = series.Points.AddXY("Pastries", pastries)
                                    series.Points(pt).Color = BranchOrange
                                End If
                                If bread > 0 Then
                                    Dim pt = series.Points.AddXY("Bread", bread)
                                    series.Points(pt).Color = BranchGreen
                                End If
                                If other > 0 Then
                                    Dim pt = series.Points.AddXY("Other", other)
                                    series.Points(pt).Color = JarvisCyan
                                End If
                            End If
                        End Using
                    End Using
                End Using

                chartOrderTypes.Series.Add(series)

                Dim legend As New Legend("Legend1") With {
                    .Docking = Docking.Bottom,
                    .ForeColor = JarvisCyan,
                    .BackColor = JarvisDarkGray
                }
                chartOrderTypes.Legends.Add(legend)
            Catch ex As Exception
            End Try
        End Sub

        Private Sub LoadOutstandingInvoices()
            Try
                chartOutstandingInvoices.Series.Clear()

                ' Show Paid vs Outstanding as pie chart
                Dim series As New Series("Status") With {
                    .ChartType = SeriesChartType.Pie,
                    .IsValueShownAsLabel = True,
                    .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                    .LabelForeColor = JarvisCyan
                }

                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()

                    Dim dateFilter = GetSalesDateFilter()
                    
                    ' Get paid amount from Demo_Sales
                    Dim sql As String = $"SELECT ISNULL(SUM(s.TotalAmount), 0) AS Paid FROM Demo_Sales s WHERE {dateFilter}"
                    Dim paidAmount As Decimal = 0
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        paidAmount = Convert.ToDecimal(cmd.ExecuteScalar())
                    End Using
                    
                    ' For demo purposes, calculate outstanding as 10% of paid
                    Dim outstandingAmount As Decimal = paidAmount * 0.1D
                    
                    If paidAmount > 0 Then
                        Dim pt1 = series.Points.AddXY("Paid", paidAmount)
                        series.Points(pt1).Color = BranchGreen
                        series.Points(pt1).LegendText = $"Paid: R {paidAmount:N0}"
                    End If
                    
                    If outstandingAmount > 0 Then
                        Dim pt2 = series.Points.AddXY("Outstanding", outstandingAmount)
                        series.Points(pt2).Color = BranchRed
                        series.Points(pt2).LegendText = $"Outstanding: R {outstandingAmount:N0}"
                    End If
                End Using

                chartOutstandingInvoices.Series.Add(series)

                Dim legend As New Legend("Legend1") With {
                    .Docking = Docking.Bottom,
                    .ForeColor = JarvisCyan,
                    .BackColor = JarvisDarkGray
                }
                chartOutstandingInvoices.Legends.Add(legend)
            Catch ex As Exception
            End Try
        End Sub

    End Class
End Namespace
