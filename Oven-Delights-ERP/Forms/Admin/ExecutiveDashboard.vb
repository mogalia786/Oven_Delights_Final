Imports System.Windows.Forms
Imports System.Windows.Forms.DataVisualization.Charting
Imports System.Configuration
Imports System.Drawing.Drawing2D

Namespace Admin
    Public Class ExecutiveDashboard
        Inherits Form

        ' Iron Man JARVIS Color Scheme
        ' PRIMARY UI COLOR: Cyan for all UI elements (titles, labels, borders)
        Private ReadOnly JarvisCyan As Color = Color.FromArgb(0, 255, 255)
        Private ReadOnly JarvisBlack As Color = Color.FromArgb(0, 0, 0)
        Private ReadOnly JarvisDarkGray As Color = Color.FromArgb(20, 20, 20)
        
        ' BRANCH DATA COLORS: Red/Gold/Green for branch-specific chart data
        Private ReadOnly BranchRed As Color = Color.FromArgb(220, 20, 20)
        Private ReadOnly BranchGold As Color = Color.FromArgb(255, 215, 0)
        Private ReadOnly BranchGreen As Color = Color.FromArgb(0, 255, 100)
        Private ReadOnly BranchOrange As Color = Color.FromArgb(255, 140, 0)
        
        ' Branch-specific colors for charts
        Private branchColors As New Dictionary(Of String, Color) From {
            {"HEAD OFFICE", BranchRed},
            {"ATHLONE", BranchGold},
            {"DURBAN", BranchGreen},
            {"JOHANNESBURG", BranchOrange}
        }

        ' Time period filter
        Private cboTimePeriod As ComboBox
        Private currentPeriod As String = "Today"
        
        ' Branch and Month filters
        Private cboBranch As ComboBox
        Private cboMonth As ComboBox
        Private selectedBranchID As Integer = 0
        Private selectedMonth As Integer = DateTime.Now.Month
        Private selectedYear As Integer = DateTime.Now.Year

        ' Main scroll panel
        Private scrollPanel As Panel

        ' KPI Panels
        Private pnlTotalSales, pnlTransactions, pnlAvgOrderValue, pnlProfitMargin As Panel
        Private pnlGrowthVsLastMonth, pnlGrowthVsLastYear As Panel
        Private pnlInvoicesPaid, pnlInvoicesDue, pnlTotalOrders, pnlCakeOrders As Panel
        Private pnlOrdersRequested, pnlOrdersCompleted, pnlOrdersPickedUp, pnlOrdersNotPickedUp As Panel

        ' Charts
        Private chartSalesByBranch As Chart
        Private chartTopProducts As Chart
        Private chartHourlySales As Chart
        Private chartCategoryBreakdown As Chart
        Private chartSalesTrend As Chart
        Private chartBranchComparison As Chart
        Private chartInvoicesByBranch As Chart
        Private chartOrderTypes As Chart
        Private chartOutstandingInvoices As Chart

        Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        Public Sub New()
            Me.Text = "JARVIS - Executive Sales Dashboard"
            Me.Width = 1920
            Me.Height = 1080
            Me.WindowState = FormWindowState.Maximized
            Me.BackColor = JarvisBlack
            Me.FormBorderStyle = FormBorderStyle.None

            SetupUI()
            LoadDashboardData()

            ' Auto-refresh every 30 seconds
            Dim refreshTimer As New Timer() With {.Interval = 30000}
            AddHandler refreshTimer.Tick, Sub() LoadDashboardData()
            refreshTimer.Start()

            ' ESC key to exit
            Me.KeyPreview = True
            AddHandler Me.KeyDown, Sub(s, e)
                                       If e.KeyCode = Keys.Escape Then
                                           Me.FormBorderStyle = FormBorderStyle.Sizable
                                           Me.WindowState = FormWindowState.Normal
                                       End If
                                   End Sub
        End Sub

        Private Sub SetupUI()
            ' Header with title and time filter
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = JarvisBlack,
                .Padding = New Padding(20, 10, 20, 10)
            }

            Dim lblTitle As New Label() With {
                .Text = "◆ EXECUTIVE DASHBOARD FOR TODAY ◆",
                .Font = New Font("Segoe UI", 24, FontStyle.Bold),
                .ForeColor = BranchRed,
                .Location = New Point(20, 15),
                .AutoSize = True
            }
            ' Add glossy effect with shadow using AddHandler
            AddHandler lblTitle.Paint, Sub(sender As Object, e As PaintEventArgs)
                                           Dim lbl = DirectCast(sender, Label)
                                           ' Draw shadow
                                           Using shadowBrush As New SolidBrush(Color.FromArgb(100, 100, 0, 0))
                                               e.Graphics.DrawString(lbl.Text, lbl.Font, shadowBrush, 2, 2)
                                           End Using
                                           ' Draw main text
                                           Using mainBrush As New SolidBrush(BranchRed)
                                               e.Graphics.DrawString(lbl.Text, lbl.Font, mainBrush, 0, 0)
                                           End Using
                                       End Sub
            pnlHeader.Controls.Add(lblTitle)

            ' Branch Filter
            Dim lblBranch As New Label() With {
                .Text = "Branch:",
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = JarvisCyan,
                .Location = New Point(1200, 20),
                .AutoSize = True
            }
            pnlHeader.Controls.Add(lblBranch)

            cboBranch = New ComboBox() With {
                .Location = New Point(1280, 17),
                .Size = New Size(180, 30),
                .Font = New Font("Segoe UI", 10),
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .BackColor = JarvisDarkGray,
                .ForeColor = JarvisCyan
            }
            LoadBranchFilter()
            AddHandler cboBranch.SelectedIndexChanged, AddressOf Filter_Changed
            pnlHeader.Controls.Add(cboBranch)

            Me.Controls.Add(pnlHeader)

            ' Scrollable main panel
            scrollPanel = New Panel() With {
                .Dock = DockStyle.Fill,
                .BackColor = JarvisBlack,
                .AutoScroll = True,
                .Padding = New Padding(10, 10, 10, 10)
            }

            Dim contentPanel As New Panel() With {
                .Location = New Point(0, 0),
                .Width = 1880,
                .Height = 3650,
                .BackColor = JarvisBlack
            }

            Dim yPos As Integer = 100

            ' KPI Cards Row 1
            pnlTotalSales = CreateKPICard("TOTAL SALES", "R 0", "", JarvisCyan, 10, yPos, 450)
            pnlTransactions = CreateKPICard("TRANSACTIONS", "0", "", JarvisCyan, 470, yPos, 450)
            pnlAvgOrderValue = CreateKPICard("AVG ORDER VALUE", "R 0", "", JarvisCyan, 930, yPos, 450)
            pnlProfitMargin = CreateKPICard("PROFIT MARGIN", "0%", "", JarvisCyan, 1390, yPos, 450)

            contentPanel.Controls.AddRange({pnlTotalSales, pnlTransactions, pnlAvgOrderValue, pnlProfitMargin})
            yPos += 130

            ' KPI Cards Row 2 - Growth Metrics
            pnlGrowthVsLastMonth = CreateKPICard("VS LAST MONTH", "+0%", "", BranchGreen, 10, yPos, 920)
            pnlGrowthVsLastYear = CreateKPICard("VS LAST YEAR", "+0%", "", BranchOrange, 940, yPos, 900)

            contentPanel.Controls.AddRange({pnlGrowthVsLastMonth, pnlGrowthVsLastYear})
            yPos += 130

            ' KPI Cards Row 3 - Invoice & Order Metrics
            pnlInvoicesPaid = CreateKPICard("INVOICES PAID", "R 0", "", BranchGreen, 10, yPos, 450)
            pnlInvoicesDue = CreateKPICard("INVOICES DUE", "R 0", "", BranchRed, 470, yPos, 450)
            pnlTotalOrders = CreateKPICard("TOTAL TRANSACTIONS", "0", "", JarvisCyan, 930, yPos, 450)
            pnlCakeOrders = CreateKPICard("CAKE ORDERS", "0", "", BranchGold, 1390, yPos, 450)

            contentPanel.Controls.AddRange({pnlInvoicesPaid, pnlInvoicesDue, pnlTotalOrders, pnlCakeOrders})
            yPos += 130

            ' KPI Cards Row 4 - TODAY'S ORDER STATUS (LIVE)
            pnlOrdersRequested = CreateKPICard("ORDERS DUE TODAY", "0", "", BranchOrange, 10, yPos, 450)
            pnlOrdersCompleted = CreateKPICard("ORDERS COMPLETED", "0", "", BranchGreen, 470, yPos, 450)
            pnlOrdersPickedUp = CreateKPICard("ORDERS PICKED UP", "0", "", BranchGreen, 930, yPos, 450)
            pnlOrdersNotPickedUp = CreateKPICard("COMPLETED NOT PICKED UP", "0", "", BranchRed, 1390, yPos, 450)

            contentPanel.Controls.AddRange({pnlOrdersRequested, pnlOrdersCompleted, pnlOrdersPickedUp, pnlOrdersNotPickedUp})
            yPos += 130

            ' Sales by Branch (Large)
            chartSalesByBranch = CreateChart("LIVE SALES BY BRANCH", 10, yPos, 1220, 400)
            contentPanel.Controls.Add(chartSalesByBranch)

            ' Top 10 Products (Side by side)
            chartTopProducts = CreateChart("TOP 10 BEST SELLING PRODUCTS", 1240, yPos, 600, 400)
            contentPanel.Controls.Add(chartTopProducts)
            yPos += 420

            ' Hourly Sales Pattern
            chartHourlySales = CreateChart("HOURLY SALES PATTERN", 10, yPos, 920, 350)
            contentPanel.Controls.Add(chartHourlySales)

            ' Category Breakdown
            chartCategoryBreakdown = CreateChart("SALES BY CATEGORY", 940, yPos, 900, 350)
            contentPanel.Controls.Add(chartCategoryBreakdown)
            yPos += 370

            ' Sales Trend (7/30 days)
            chartSalesTrend = CreateChart("SALES TREND - LAST 30 DAYS", 10, yPos, 1220, 400)
            contentPanel.Controls.Add(chartSalesTrend)

            ' Branch Comparison with Prior Period
            chartBranchComparison = CreateChart("BRANCH PERFORMANCE - CURRENT VS PRIOR PERIOD", 1240, yPos, 600, 400)
            contentPanel.Controls.Add(chartBranchComparison)
            yPos += 420

            ' Invoices by Branch (Pie)
            chartInvoicesByBranch = CreateChart("OUTSTANDING INVOICES BY BRANCH", 10, yPos, 600, 400)
            contentPanel.Controls.Add(chartInvoicesByBranch)

            ' Order Types (Pie)
            chartOrderTypes = CreateChart("ORDER TYPES BREAKDOWN", 620, yPos, 600, 400)
            contentPanel.Controls.Add(chartOrderTypes)

            ' Outstanding Invoices Detail
            chartOutstandingInvoices = CreateChart("INVOICES: PAID VS OUTSTANDING", 1230, yPos, 610, 400)
            contentPanel.Controls.Add(chartOutstandingInvoices)

            scrollPanel.Controls.Add(contentPanel)
            Me.Controls.Add(scrollPanel)
        End Sub

        Private Function CreateKPICard(title As String, value As String, subtitle As String, color As Color, x As Integer, y As Integer, width As Integer) As Panel
            Dim pnl As New Panel() With {
                .Location = New Point(x, y),
                .Size = New Size(width, 110),
                .BackColor = JarvisDarkGray,
                .BorderStyle = BorderStyle.FixedSingle
            }

            Dim lblTitle As New Label() With {
                .Text = title,
                .Location = New Point(15, 10),
                .Size = New Size(width - 30, 25),
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .ForeColor = JarvisCyan
            }
            pnl.Controls.Add(lblTitle)

            Dim lblValue As New Label() With {
                .Text = value,
                .Location = New Point(15, 40),
                .Size = New Size(width - 30, 45),
                .Font = New Font("Segoe UI", 32, FontStyle.Bold),
                .ForeColor = color,
                .Tag = "value"
            }
            pnl.Controls.Add(lblValue)

            If Not String.IsNullOrEmpty(subtitle) Then
                Dim lblSubtitle As New Label() With {
                    .Text = subtitle,
                    .Location = New Point(15, 85),
                    .Size = New Size(width - 30, 20),
                    .Font = New Font("Segoe UI", 9),
                    .ForeColor = Color.LightGray,
                    .Tag = "subtitle"
                }
                pnl.Controls.Add(lblSubtitle)
            End If

            Return pnl
        End Function

        Private Function CreateChart(title As String, x As Integer, y As Integer, width As Integer, height As Integer) As Chart
            Dim chart As New Chart() With {
                .Location = New Point(x, y),
                .Size = New Size(width, height),
                .BackColor = JarvisDarkGray,
                .BorderlineColor = JarvisCyan,
                .BorderlineWidth = 2
            }

            Dim ca As New ChartArea("ca1") With {
                .BackColor = JarvisDarkGray
            }
            ca.AxisX.MajorGrid.LineColor = JarvisBlack
            ca.AxisY.MajorGrid.LineColor = JarvisBlack
            ca.AxisX.LabelStyle.ForeColor = JarvisCyan
            ca.AxisY.LabelStyle.ForeColor = JarvisCyan
            ca.AxisX.LineColor = JarvisCyan
            ca.AxisY.LineColor = JarvisCyan
            ca.AxisX.LabelStyle.Font = New Font("Segoe UI", 9)
            ca.AxisY.LabelStyle.Font = New Font("Segoe UI", 9)
            chart.ChartAreas.Add(ca)

            chart.Titles.Add(New Title(title) With {
                .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                .ForeColor = JarvisCyan,
                .Alignment = ContentAlignment.TopLeft
            })

            Return chart
        End Function

        Private Sub LoadBranchFilter()
            Try
                cboBranch.Items.Clear()
                cboBranch.Items.Add(New With {.Text = "All Branches", .Value = 0})
                cboBranch.DisplayMember = "Text"
                cboBranch.ValueMember = "Value"
                
                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()
                    Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                cboBranch.Items.Add(New With {
                                    .Text = reader("BranchName").ToString(),
                                    .Value = Convert.ToInt32(reader("BranchID"))
                                })
                            End While
                        End Using
                    End Using
                End Using
                cboBranch.SelectedIndex = 0
            Catch ex As Exception
                cboBranch.Items.Add(New With {.Text = "All Branches", .Value = 0})
                cboBranch.SelectedIndex = 0
            End Try
        End Sub
        
        Private Sub LoadMonthFilter()
            Try
                cboMonth.Items.Clear()
                For i As Integer = 1 To 12
                    Dim monthDate = New DateTime(selectedYear, i, 1)
                    cboMonth.Items.Add(New With {
                        .Text = monthDate.ToString("MMMM yyyy"),
                        .Value = i
                    })
                Next
                cboMonth.DisplayMember = "Text"
                cboMonth.ValueMember = "Value"
                cboMonth.SelectedIndex = DateTime.Now.Month - 1
            Catch ex As Exception
                cboMonth.Items.Add(New With {.Text = DateTime.Now.ToString("MMMM yyyy"), .Value = DateTime.Now.Month})
                cboMonth.SelectedIndex = 0
            End Try
        End Sub
        
        Private Sub Filter_Changed(sender As Object, e As EventArgs)
            Try
                If cboBranch.SelectedItem IsNot Nothing Then
                    selectedBranchID = CInt(cboBranch.SelectedItem.Value)
                End If
                
                If cboMonth.SelectedItem IsNot Nothing Then
                    selectedMonth = CInt(cboMonth.SelectedItem.Value)
                End If
                
                If cboTimePeriod.SelectedItem IsNot Nothing Then
                    currentPeriod = cboTimePeriod.SelectedItem.ToString()
                End If
                
                LoadDashboardData()
            Catch ex As Exception
            End Try
        End Sub
        
        Private Sub TimePeriod_Changed(sender As Object, e As EventArgs)
            currentPeriod = cboTimePeriod.SelectedItem.ToString()
            LoadDashboardData()
        End Sub

        Private Sub LoadDashboardData()
            Try
                LoadKPIs()
            Catch ex As Exception
                Debug.WriteLine($"LoadKPIs Error: {ex.Message}")
            End Try
            
            Try
                LoadInvoiceAndOrderKPIs()
            Catch ex As Exception
                Debug.WriteLine($"LoadInvoiceAndOrderKPIs Error: {ex.Message}")
            End Try
            
            Try
                LoadTodayOrderStats()
            Catch ex As Exception
                Debug.WriteLine($"LoadTodayOrderStats Error: {ex.Message}")
            End Try
            
            Try
                LoadSalesByBranch()
            Catch ex As Exception
                Debug.WriteLine($"LoadSalesByBranch Error: {ex.Message}")
            End Try
            
            Try
                LoadTopProducts()
            Catch ex As Exception
                Debug.WriteLine($"LoadTopProducts Error: {ex.Message}")
            End Try
            
            Try
                LoadHourlySales()
            Catch ex As Exception
                Debug.WriteLine($"LoadHourlySales Error: {ex.Message}")
            End Try
            
            Try
                LoadCategoryBreakdown()
            Catch ex As Exception
                Debug.WriteLine($"LoadCategoryBreakdown Error: {ex.Message}")
            End Try
            
            Try
                LoadSalesTrend()
            Catch ex As Exception
                Debug.WriteLine($"LoadSalesTrend Error: {ex.Message}")
            End Try
            
            Try
                LoadBranchComparison()
            Catch ex As Exception
                Debug.WriteLine($"LoadBranchComparison Error: {ex.Message}")
            End Try
            
            Try
                LoadInvoicesByBranch()
            Catch ex As Exception
                Debug.WriteLine($"LoadInvoicesByBranch Error: {ex.Message}")
            End Try
            
            Try
                LoadOrderTypes()
            Catch ex As Exception
                Debug.WriteLine($"LoadOrderTypes Error: {ex.Message}")
            End Try
            
            Try
                LoadOutstandingInvoices()
            Catch ex As Exception
                Debug.WriteLine($"LoadOutstandingInvoices Error: {ex.Message}")
            End Try
        End Sub

        Private Sub LoadKPIs()
            Try
                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()

                    Dim dateFilter = GetSalesDateFilter()

                    ' Total Sales
                    Dim sql As String = $"SELECT ISNULL(SUM(TotalAmount), 0) FROM Demo_Sales s WHERE {dateFilter}"
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Dim totalSales = Convert.ToDecimal(cmd.ExecuteScalar())
                        UpdateKPIValue(pnlTotalSales, $"R {totalSales:N0}")
                    End Using

                    ' Growth vs Last Month
                    Dim priorFilter = dateFilter.Replace($"MONTH(s.SaleDate) = {selectedMonth}", $"MONTH(s.SaleDate) = {If(selectedMonth = 1, 12, selectedMonth - 1)}")
                    sql = $"SELECT ISNULL(SUM(TotalAmount), 0) FROM Demo_Sales s WHERE {priorFilter}"
                    Using cmd2 As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Dim lastMonthSales = Convert.ToDecimal(cmd2.ExecuteScalar())
                        sql = $"SELECT ISNULL(SUM(TotalAmount), 0) FROM Demo_Sales s WHERE {dateFilter}"
                        cmd2.CommandText = sql
                        Dim currentSales = Convert.ToDecimal(cmd2.ExecuteScalar())

                        Dim growthPercent As Decimal = 0
                        If lastMonthSales > 0 Then
                            growthPercent = ((currentSales - lastMonthSales) / lastMonthSales) * 100
                        End If

                        Dim growthColor = If(growthPercent >= 0, BranchGreen, BranchRed)
                        Dim growthSign = If(growthPercent >= 0, "+", "")
                        UpdateKPIValue(pnlGrowthVsLastMonth, $"{growthSign}{growthPercent:F1}%", growthColor)
                    End Using

                    ' Transactions
                    sql = $"SELECT COUNT(*) FROM Demo_Sales s WHERE {dateFilter}"
                    Using cmd3 As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Dim transactions = Convert.ToInt32(cmd3.ExecuteScalar())
                        UpdateKPIValue(pnlTransactions, transactions.ToString("N0"))
                    End Using

                    ' Avg Order Value
                    sql = $"SELECT ISNULL(AVG(TotalAmount), 0) FROM Demo_Sales s WHERE {dateFilter}"
                    Using cmd4 As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Dim avgOrder = Convert.ToDecimal(cmd4.ExecuteScalar())
                        UpdateKPIValue(pnlAvgOrderValue, $"R {avgOrder:N0}")
                    End Using

                    ' Profit Margin (assuming 30%)
                    UpdateKPIValue(pnlProfitMargin, "30%")

                    ' Year over Year Growth
                    Dim yearAgoFilter = dateFilter.Replace($"YEAR(s.SaleDate) = {selectedYear}", $"YEAR(s.SaleDate) = {selectedYear - 1}")
                    sql = $"SELECT ISNULL(SUM(TotalAmount), 0) FROM Demo_Sales s WHERE {yearAgoFilter}"
                    Using cmd5 As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Dim yearAgoSales = Convert.ToDecimal(cmd5.ExecuteScalar())
                        sql = $"SELECT ISNULL(SUM(TotalAmount), 0) FROM Demo_Sales s WHERE {dateFilter}"
                        cmd5.CommandText = sql
                        Dim currentSales = Convert.ToDecimal(cmd5.ExecuteScalar())

                        Dim yoyGrowth As Decimal = 0
                        If yearAgoSales > 0 Then
                            yoyGrowth = ((currentSales - yearAgoSales) / yearAgoSales) * 100
                        End If

                        Dim yoyColor = If(yoyGrowth >= 0, BranchGreen, BranchRed)
                        Dim yoySign = If(yoyGrowth >= 0, "+", "")
                        UpdateKPIValue(pnlGrowthVsLastYear, $"{yoySign}{yoyGrowth:F1}%", yoyColor)
                    End Using
                End Using
            Catch ex As Exception
            End Try
        End Sub

        Private Sub LoadInvoiceAndOrderKPIs()
            Try
                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()

                    Dim dateFilter = GetInvoiceDateFilter()

                    ' Invoices Paid - from Invoices table where PaymentStatus = 'Paid'
                    Dim sql As String = $"SELECT ISNULL(SUM(i.TotalAmount), 0) FROM Invoices i WHERE {dateFilter} AND i.PaymentStatus = 'Paid'"
                    Dim invoicesPaid As Decimal = 0
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        invoicesPaid = Convert.ToDecimal(cmd.ExecuteScalar())
                        UpdateKPIValue(pnlInvoicesPaid, $"R {invoicesPaid:N0}")
                    End Using

                    ' Invoices Due - from Invoices table where PaymentStatus != 'Paid'
                    sql = $"SELECT ISNULL(SUM(i.TotalAmount), 0) FROM Invoices i WHERE {dateFilter} AND (i.PaymentStatus IS NULL OR i.PaymentStatus != 'Paid')"
                    Dim invoicesDue As Decimal = 0
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        invoicesDue = Convert.ToDecimal(cmd.ExecuteScalar())
                        UpdateKPIValue(pnlInvoicesDue, $"R {invoicesDue:N0}")
                    End Using

                    ' Total Orders - count from Invoices
                    sql = $"SELECT COUNT(DISTINCT i.InvoiceNumber) FROM Invoices i WHERE {dateFilter}"
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Dim totalOrders = Convert.ToInt32(cmd.ExecuteScalar())
                        UpdateKPIValue(pnlTotalOrders, totalOrders.ToString("N0"))
                    End Using

                    ' Cake Orders - from custom orders table
                    sql = $"SELECT COUNT(*) FROM POS_CustomOrders o WHERE CAST(o.OrderDate AS DATE) >= CAST(DATEADD(DAY, -30, GETDATE()) AS DATE)"
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Dim cakeOrders = Convert.ToInt32(cmd.ExecuteScalar())
                        UpdateKPIValue(pnlCakeOrders, cakeOrders.ToString("N0"))
                    End Using
                End Using
            Catch ex As Exception
            End Try
        End Sub

        Private Sub LoadTodayOrderStats()
            Try
                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()
                    
                    Dim sql As String = "EXEC sp_GetTodayOrderStats @BranchID"
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@BranchID", If(selectedBranchID = 0, DBNull.Value, CObj(selectedBranchID)))
                        
                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                Dim ordersRequested = If(IsDBNull(reader("OrdersRequested")), 0, Convert.ToInt32(reader("OrdersRequested")))
                                Dim ordersCompleted = If(IsDBNull(reader("OrdersCompleted")), 0, Convert.ToInt32(reader("OrdersCompleted")))
                                Dim ordersPickedUp = If(IsDBNull(reader("OrdersPickedUp")), 0, Convert.ToInt32(reader("OrdersPickedUp")))
                                Dim ordersNotPickedUp = If(IsDBNull(reader("OrdersCompletedNotPickedUp")), 0, Convert.ToInt32(reader("OrdersCompletedNotPickedUp")))
                                Dim ordersDueNotCompleted = If(IsDBNull(reader("OrdersDueTodayNotCompleted")), 0, Convert.ToInt32(reader("OrdersDueTodayNotCompleted")))
                                
                                ' Update KPI cards with live data
                                UpdateKPIValue(pnlOrdersRequested, ordersRequested.ToString("N0"), If(ordersDueNotCompleted > 0, BranchRed, BranchOrange))
                                UpdateKPIValue(pnlOrdersCompleted, ordersCompleted.ToString("N0"), BranchGreen)
                                UpdateKPIValue(pnlOrdersPickedUp, ordersPickedUp.ToString("N0"), BranchGreen)
                                UpdateKPIValue(pnlOrdersNotPickedUp, ordersNotPickedUp.ToString("N0"), If(ordersNotPickedUp > 0, BranchRed, BranchGreen))
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                Debug.WriteLine($"LoadTodayOrderStats Error: {ex.Message}")
            End Try
        End Sub

        Private Sub LoadSalesByBranch()
            Try
                chartSalesByBranch.Series.Clear()
                Dim series As New Series("Sales") With {
                    .ChartType = SeriesChartType.Column,
                    .IsValueShownAsLabel = True,
                    .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                    .LabelForeColor = JarvisCyan
                }

                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()
                    
                    Dim sql As String
                    If selectedBranchID > 0 Then
                        ' Show only selected branch
                        sql = $"SELECT b.BranchName, ISNULL(SUM(s.TotalAmount), 0) AS Total " &
                              $"FROM Branches b " &
                              $"LEFT JOIN Demo_Sales s ON b.BranchID = s.BranchID AND {GetSalesDateFilter()} " &
                              $"WHERE b.IsActive = 1 AND b.BranchID = {selectedBranchID} " &
                              $"GROUP BY b.BranchName ORDER BY Total DESC"
                    Else
                        ' Show all branches
                        sql = $"SELECT b.BranchName, ISNULL(SUM(s.TotalAmount), 0) AS Total " &
                              $"FROM Branches b " &
                              $"LEFT JOIN Demo_Sales s ON b.BranchID = s.BranchID AND {GetSalesDateFilter()} " &
                              $"WHERE b.IsActive = 1 " &
                              $"GROUP BY b.BranchName ORDER BY Total DESC"
                    End If

                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                Dim branchName = reader("BranchName").ToString().ToUpper()
                                Dim pt = series.Points.AddXY(branchName, Convert.ToDecimal(reader("Total")))
                                
                                ' Use branch-specific color or default to cyan
                                If branchColors.ContainsKey(branchName) Then
                                    series.Points(pt).Color = branchColors(branchName)
                                Else
                                    series.Points(pt).Color = JarvisCyan
                                End If
                            End While
                        End Using
                    End Using
                End Using

                chartSalesByBranch.Series.Add(series)
            Catch ex As Exception
            End Try
        End Sub

        Private Sub LoadTopProducts()
            Try
                chartTopProducts.Series.Clear()
                Dim series As New Series("Quantity") With {
                    .ChartType = SeriesChartType.Bar,
                    .IsValueShownAsLabel = True,
                    .Font = New Font("Segoe UI", 9, FontStyle.Bold),
                    .LabelForeColor = JarvisCyan,
                    .Color = JarvisCyan
                }

                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()
                    Dim sql As String = "SELECT TOP 10 i.ProductName, SUM(i.Quantity) AS TotalQty " &
                                       "FROM Invoices i " &
                                       "WHERE i.SaleDate >= DATEADD(DAY, -90, (SELECT MAX(SaleDate) FROM Invoices)) " &
                                       "GROUP BY i.ProductName ORDER BY TotalQty DESC"

                    Dim pointCount As Integer = 0
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                Dim productName = reader("ProductName").ToString()
                                If productName.Length > 25 Then productName = productName.Substring(0, 22) & "..."
                                series.Points.AddXY(productName, Convert.ToInt32(reader("TotalQty")))
                                pointCount += 1
                            End While
                        End Using
                    End Using
                End Using

                chartTopProducts.Series.Add(series)
            Catch ex As Exception
                MessageBox.Show($"LoadTopProducts Error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadHourlySales()
            Try
                chartHourlySales.Series.Clear()
                Dim series As New Series("Sales") With {
                    .ChartType = SeriesChartType.SplineArea,
                    .Color = Color.FromArgb(100, 0, 255, 255),
                    .BorderColor = JarvisCyan,
                    .BorderWidth = 3,
                    .IsValueShownAsLabel = False
                }

                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()
                    Dim sql As String = $"SELECT DATEPART(HOUR, SaleDate) AS Hour, SUM(TotalAmount) AS Total " &
                                       $"FROM Demo_Sales " &
                                       $"WHERE SaleDate >= DATEADD(DAY, -7, (SELECT MAX(SaleDate) FROM Demo_Sales)) " &
                                       $"GROUP BY DATEPART(HOUR, SaleDate) ORDER BY Hour"

                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                series.Points.AddXY($"{reader("Hour")}:00", Convert.ToDecimal(reader("Total")))
                            End While
                        End Using
                    End Using
                End Using

                chartHourlySales.Series.Add(series)
            Catch ex As Exception
            End Try
        End Sub

        Private Sub LoadCategoryBreakdown()
            Try
                chartCategoryBreakdown.Series.Clear()
                chartCategoryBreakdown.Legends.Clear()
                
                Dim series As New Series("Sales") With {
                    .ChartType = SeriesChartType.Bar,
                    .IsValueShownAsLabel = True,
                    .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                    .LabelForeColor = JarvisCyan
                }

                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()
                    Dim sql As String = "SELECT TOP 5 p.Category, SUM(i.LineTotal) AS Total " &
                                       "FROM Invoices i " &
                                       "LEFT JOIN Demo_Retail_Product p ON p.ProductID = i.ProductID " &
                                       "WHERE i.SaleDate >= DATEADD(DAY, -90, (SELECT MAX(SaleDate) FROM Invoices)) " &
                                       "AND p.Category IS NOT NULL " &
                                       "GROUP BY p.Category ORDER BY Total DESC"

                    Dim pointCount As Integer = 0
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            Dim colors() As Color = {BranchRed, BranchGold, BranchGreen, BranchOrange, JarvisCyan}
                            Dim i As Integer = 0
                            While reader.Read()
                                Dim pt = series.Points.AddXY(reader("Category").ToString(), Convert.ToDecimal(reader("Total")))
                                series.Points(pt).Color = colors(i Mod colors.Length)
                                i += 1
                                pointCount += 1
                            End While
                        End Using
                    End Using
                End Using

                chartCategoryBreakdown.Series.Add(series)
            Catch ex As Exception
                MessageBox.Show($"LoadCategoryBreakdown Error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadSalesTrend()
            Try
                chartSalesTrend.Series.Clear()
                chartSalesTrend.Legends.Clear()

                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()
                    Dim days As Integer = If(currentPeriod = "This Week", 7, 30)
                    
                    ' Get all branches with sales
                    Dim branchSql As String = "SELECT DISTINCT b.BranchID, b.BranchName " &
                                             "FROM Branches b " &
                                             "INNER JOIN Demo_Sales s ON b.BranchID = s.BranchID " &
                                             $"WHERE b.IsActive = 1 AND s.SaleDate >= DATEADD(DAY, -{days}, (SELECT MAX(SaleDate) FROM Demo_Sales)) " &
                                             "ORDER BY b.BranchName"
                    
                    Dim branches As New List(Of Tuple(Of Integer, String))()
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(branchSql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                branches.Add(New Tuple(Of Integer, String)(reader.GetInt32(0), reader.GetString(1)))
                            End While
                        End Using
                    End Using
                    
                    ' Create a series for each branch
                    For Each branch In branches
                        Dim branchName = branch.Item2.ToUpper()
                        Dim series As New Series(branchName) With {
                            .ChartType = SeriesChartType.Line,
                            .BorderWidth = 3,
                            .IsValueShownAsLabel = False,
                            .MarkerStyle = MarkerStyle.Circle,
                            .MarkerSize = 8
                        }
                        
                        ' Set branch-specific color
                        If branchColors.ContainsKey(branchName) Then
                            series.Color = branchColors(branchName)
                            series.MarkerColor = branchColors(branchName)
                        Else
                            series.Color = JarvisCyan
                            series.MarkerColor = JarvisCyan
                        End If
                        
                        ' Get sales data for this branch
                        Dim sql As String = $"SELECT CAST(SaleDate AS DATE) AS SaleDay, SUM(TotalAmount) AS Total " &
                                           $"FROM Demo_Sales " &
                                           $"WHERE BranchID = {branch.Item1} AND SaleDate >= DATEADD(DAY, -{days}, (SELECT MAX(SaleDate) FROM Demo_Sales)) " &
                                           $"GROUP BY CAST(SaleDate AS DATE) ORDER BY SaleDay"
                        
                        Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                            Using reader = cmd.ExecuteReader()
                                While reader.Read()
                                    Dim dateLabel = Convert.ToDateTime(reader("SaleDay")).ToString("MMM dd")
                                    series.Points.AddXY(dateLabel, Convert.ToDecimal(reader("Total")))
                                End While
                            End Using
                        End Using
                        
                        chartSalesTrend.Series.Add(series)
                    Next
                End Using
                
                ' Add legend
                Dim legend As New Legend("Legend1") With {
                    .Docking = Docking.Top,
                    .ForeColor = JarvisCyan,
                    .BackColor = JarvisDarkGray
                }
                chartSalesTrend.Legends.Add(legend)
            Catch ex As Exception
            End Try
        End Sub

        Private Sub LoadBranchComparison()
            Try
                chartBranchComparison.Series.Clear()

                Dim currentSeries As New Series("Current Period") With {
                    .ChartType = SeriesChartType.Column,
                    .Color = JarvisCyan,
                    .IsValueShownAsLabel = True,
                    .Font = New Font("Segoe UI", 8, FontStyle.Bold),
                    .LabelForeColor = JarvisCyan
                }

                Dim priorSeries As New Series("Prior Period") With {
                    .ChartType = SeriesChartType.Column,
                    .Color = BranchGold,
                    .IsValueShownAsLabel = True,
                    .Font = New Font("Segoe UI", 8, FontStyle.Bold),
                    .LabelForeColor = JarvisCyan
                }

                Using conn As New Microsoft.Data.SqlClient.SqlConnection(connectionString)
                    conn.Open()

                    ' Current period - use GetSalesDateFilter for Demo_Sales
                    Dim currentFilter = GetSalesDateFilter()
                    Dim sql As String = $"SELECT b.BranchName, ISNULL(SUM(s.TotalAmount), 0) AS Total " &
                                       $"FROM Branches b " &
                                       $"LEFT JOIN Demo_Sales s ON b.BranchID = s.BranchID AND {currentFilter} " &
                                       $"WHERE b.IsActive = 1 " &
                                       $"GROUP BY b.BranchName ORDER BY b.BranchName"

                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                currentSeries.Points.AddXY(reader("BranchName").ToString(), Convert.ToDecimal(reader("Total")))
                            End While
                        End Using
                    End Using

                    ' Prior period - calculate prior month
                    Dim priorMonth = If(selectedMonth = 1, 12, selectedMonth - 1)
                    Dim priorYear = If(selectedMonth = 1, selectedYear - 1, selectedYear)
                    Dim priorFilter = GetSalesDateFilter().Replace($"MONTH(s.SaleDate) = {selectedMonth}", $"MONTH(s.SaleDate) = {priorMonth}")
                    priorFilter = priorFilter.Replace($"YEAR(s.SaleDate) = {selectedYear}", $"YEAR(s.SaleDate) = {priorYear}")
                    
                    sql = $"SELECT b.BranchName, ISNULL(SUM(s.TotalAmount), 0) AS Total " &
                         $"FROM Branches b " &
                         $"LEFT JOIN Demo_Sales s ON b.BranchID = s.BranchID AND {priorFilter} " &
                         $"WHERE b.IsActive = 1 " &
                         $"GROUP BY b.BranchName ORDER BY b.BranchName"

                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                priorSeries.Points.AddXY(reader("BranchName").ToString(), Convert.ToDecimal(reader("Total")))
                            End While
                        End Using
                    End Using
                End Using

                chartBranchComparison.Series.Add(currentSeries)
                chartBranchComparison.Series.Add(priorSeries)

                Dim legend As New Legend("Legend1") With {
                    .Docking = Docking.Top,
                    .ForeColor = JarvisCyan,
                    .BackColor = JarvisDarkGray
                }
                chartBranchComparison.Legends.Add(legend)
            Catch ex As Exception
            End Try
        End Sub


        Private Function GetDateFilter() As String
            Dim filter As String = ""
            
            Select Case currentPeriod
                Case "Today"
                    filter = "CAST(i.SaleDate AS DATE) = CAST(GETDATE() AS DATE)"
                Case "Week"
                    filter = "i.SaleDate >= DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE()), 0)"
                Case "Month"
                    filter = $"YEAR(i.SaleDate) = {selectedYear} AND MONTH(i.SaleDate) = {selectedMonth}"
                Case "Year"
                    filter = $"YEAR(i.SaleDate) = {selectedYear}"
                Case Else
                    filter = $"YEAR(i.SaleDate) = {selectedYear} AND MONTH(i.SaleDate) = {selectedMonth}"
            End Select
            
            ' Add branch filter if specific branch selected
            If selectedBranchID > 0 Then
                filter &= $" AND i.BranchID = {selectedBranchID}"
            End If
            
            Return filter
        End Function
        
        Private Function GetSalesDateFilter() As String
            Dim filter As String = ""
            
            Select Case currentPeriod
                Case "Today"
                    filter = "CAST(s.SaleDate AS DATE) = CAST(GETDATE() AS DATE)"
                Case "Week"
                    filter = "s.SaleDate >= DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE()), 0)"
                Case "Month"
                    filter = $"YEAR(s.SaleDate) = {selectedYear} AND MONTH(s.SaleDate) = {selectedMonth}"
                Case "Year"
                    filter = $"YEAR(s.SaleDate) = {selectedYear}"
                Case Else
                    filter = $"YEAR(s.SaleDate) = {selectedYear} AND MONTH(s.SaleDate) = {selectedMonth}"
            End Select
            
            ' Add branch filter if specific branch selected
            If selectedBranchID > 0 Then
                filter &= $" AND s.BranchID = {selectedBranchID}"
            End If
            
            Return filter
        End Function

        Private Function GetInvoiceDateFilter() As String
            Dim filter As String = ""
            
            Select Case currentPeriod
                Case "Today"
                    filter = "CAST(i.SaleDate AS DATE) = CAST(GETDATE() AS DATE)"
                Case "Week"
                    filter = "i.SaleDate >= DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE()), 0)"
                Case "Month"
                    filter = $"YEAR(i.SaleDate) = {selectedYear} AND MONTH(i.SaleDate) = {selectedMonth}"
                Case "Year"
                    filter = $"YEAR(i.SaleDate) = {selectedYear}"
                Case Else
                    filter = $"YEAR(i.SaleDate) = {selectedYear} AND MONTH(i.SaleDate) = {selectedMonth}"
            End Select
            
            ' Add branch filter if specific branch selected
            If selectedBranchID > 0 Then
                filter &= $" AND i.BranchID = {selectedBranchID}"
            End If
            
            Return filter
        End Function

        Private Function GetPriorDateFilter() As String
            ' Use actual data range for prior period comparison
            Select Case currentPeriod
                Case "Today"
                    Return "CAST(i.SaleDate AS DATE) = CAST(DATEADD(DAY, -2, (SELECT MAX(SaleDate) FROM Invoices)) AS DATE)"
                Case "This Week"
                    Return "i.SaleDate >= DATEADD(DAY, -14, (SELECT MAX(SaleDate) FROM Invoices)) AND i.SaleDate < DATEADD(DAY, -7, (SELECT MAX(SaleDate) FROM Invoices))"
                Case "This Month"
                    Return "i.SaleDate >= DATEADD(DAY, -60, (SELECT MAX(SaleDate) FROM Invoices)) AND i.SaleDate < DATEADD(DAY, -30, (SELECT MAX(SaleDate) FROM Invoices))"
                Case "This Year"
                    Return "i.SaleDate >= DATEADD(YEAR, -2, (SELECT MAX(SaleDate) FROM Invoices)) AND i.SaleDate < DATEADD(YEAR, -1, (SELECT MAX(SaleDate) FROM Invoices))"
                Case Else
                    Return "CAST(i.SaleDate AS DATE) = CAST(DATEADD(DAY, -2, (SELECT MAX(SaleDate) FROM Invoices)) AS DATE)"
            End Select
        End Function

        Private Function GetYearAgoDateFilter() As String
            ' Use actual data range for year-over-year comparison
            Select Case currentPeriod
                Case "Today"
                    Return "CAST(i.SaleDate AS DATE) = CAST(DATEADD(YEAR, -1, (SELECT MAX(SaleDate) FROM Invoices)) AS DATE)"
                Case "This Week"
                    Return "i.SaleDate >= DATEADD(YEAR, -1, DATEADD(DAY, -7, (SELECT MAX(SaleDate) FROM Invoices))) AND i.SaleDate < DATEADD(YEAR, -1, (SELECT MAX(SaleDate) FROM Invoices))"
                Case "This Month"
                    Return "i.SaleDate >= DATEADD(YEAR, -1, DATEADD(DAY, -30, (SELECT MAX(SaleDate) FROM Invoices))) AND i.SaleDate < DATEADD(YEAR, -1, (SELECT MAX(SaleDate) FROM Invoices))"
                Case "This Year"
                    Return "i.SaleDate >= DATEADD(YEAR, -2, (SELECT MAX(SaleDate) FROM Invoices)) AND i.SaleDate < DATEADD(YEAR, -1, (SELECT MAX(SaleDate) FROM Invoices))"
                Case Else
                    Return "CAST(i.SaleDate AS DATE) = CAST(DATEADD(YEAR, -1, (SELECT MAX(SaleDate) FROM Invoices)) AS DATE)"
            End Select
        End Function

        Private Sub UpdateKPIValue(pnl As Panel, value As String, Optional color As Color = Nothing)
            For Each ctrl As Control In pnl.Controls
                If TypeOf ctrl Is Label AndAlso ctrl.Tag IsNot Nothing AndAlso ctrl.Tag.ToString() = "value" Then
                    DirectCast(ctrl, Label).Text = value
                    If color <> Nothing Then
                        DirectCast(ctrl, Label).ForeColor = color
                    End If
                    Exit For
                End If
            Next
        End Sub
    End Class
End Namespace
