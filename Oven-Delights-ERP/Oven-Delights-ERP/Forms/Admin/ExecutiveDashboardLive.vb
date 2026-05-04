Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing.Drawing2D

Namespace Admin
    Public Class ExecutiveDashboardLive
        Inherits Form

    ' Mogalia Color Scheme (from www.mogalia.co.za)
    Private ReadOnly MogaliaPrimary As Color = Color.FromArgb(41, 128, 185)      ' Blue
    Private ReadOnly MogaliaSecondary As Color = Color.FromArgb(52, 73, 94)     ' Dark Blue
    Private ReadOnly MogaliaAccent As Color = Color.FromArgb(22, 160, 133)      ' Teal
    Private ReadOnly MogaliaSuccess As Color = Color.FromArgb(39, 174, 96)      ' Green
    Private ReadOnly MogaliaDanger As Color = Color.FromArgb(231, 76, 60)       ' Red
    Private ReadOnly MogaliaWarning As Color = Color.FromArgb(243, 156, 18)     ' Orange
    Private ReadOnly MogaliaLight As Color = Color.FromArgb(236, 240, 241)      ' Light Gray
    Private ReadOnly MogaliaDark As Color = Color.FromArgb(44, 62, 80)          ' Dark Gray

    Private connString As String
    Private cboBranch As ComboBox
    Private selectedBranchID As Integer = 0
    Private scrollPanel As Panel
    Private lblDateTime As Label

    ' KPI Panels with comparison arrows
    Private pnlTotalSales, pnlTransactions, pnlAvgOrderValue, pnlProfitMargin As Panel
    Private pnlTotalOrders, pnlOrdersCompleted, pnlOrdersPickedUp, pnlOrdersNotPickedUp As Panel
    Private pnlInvoicesPaid, pnlInvoicesDue As Panel

    Public Sub New()
        connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        
        Me.Text = "Executive Live Report for Today"
        Me.Size = New Size(1600, 900)
        Me.WindowState = FormWindowState.Maximized
        Me.BackColor = MogaliaLight
        Me.StartPosition = FormStartPosition.CenterScreen
        
        SetupUI()
        LoadLiveData()
        
        ' Auto-refresh every 30 seconds
        Dim refreshTimer As New Timer With {.Interval = 30000}
        AddHandler refreshTimer.Tick, Sub()
            LoadLiveData()
            If lblDateTime IsNot Nothing Then
                lblDateTime.Text = DateTime.Now.ToString("dddd, MMMM dd, yyyy - HH:mm:ss")
            End If
        End Sub
        refreshTimer.Start()
    End Sub

    Private Sub SetupUI()
        ' Header Panel
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 100,
            .BackColor = MogaliaPrimary,
            .Padding = New Padding(30, 20, 30, 20)
        }

        Dim lblTitle As New Label With {
            .Text = "Executive Live Report for Today",
            .Font = New Font("Segoe UI", 28, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(30, 30)
        }

        lblDateTime = New Label With {
            .Text = DateTime.Now.ToString("dddd, MMMM dd, yyyy - HH:mm:ss"),
            .Font = New Font("Segoe UI", 12, FontStyle.Regular),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(30, 65)
        }

        ' Branch Filter
        Dim lblBranch As New Label With {
            .Text = "Branch:",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(1200, 35)
        }

        cboBranch = New ComboBox With {
            .Font = New Font("Segoe UI", 11),
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Width = 200,
            .Location = New Point(1280, 32)
        }
        AddHandler cboBranch.SelectedIndexChanged, AddressOf CboBranch_SelectedIndexChanged

        pnlHeader.Controls.AddRange({lblTitle, lblDateTime, lblBranch, cboBranch})
        Me.Controls.Add(pnlHeader)

        ' Scrollable Content Panel
        scrollPanel = New Panel With {
            .Dock = DockStyle.Fill,
            .AutoScroll = True,
            .BackColor = MogaliaLight,
            .Padding = New Padding(20)
        }
        Me.Controls.Add(scrollPanel)

        ' KPI Grid Layout
        Dim yPos As Integer = 20
        
        ' Row 1: Sales Metrics
        CreateKPIRow(yPos, {
            CreateKPIPanel("Total Sales Today", "R 0.00", "vs Yesterday", 0),
            CreateKPIPanel("Transactions", "0", "vs Yesterday", 1),
            CreateKPIPanel("Avg Order Value", "R 0.00", "vs Yesterday", 2),
            CreateKPIPanel("Profit Margin", "0%", "vs Yesterday", 3)
        })
        yPos += 180

        ' Row 2: Order Metrics
        CreateKPIRow(yPos, {
            CreateKPIPanel("Total Orders", "0", "vs Yesterday", 4),
            CreateKPIPanel("Orders Completed", "0", "vs Yesterday", 5),
            CreateKPIPanel("Orders Picked Up", "0", "vs Yesterday", 6),
            CreateKPIPanel("Not Picked Up", "0", "vs Yesterday", 7)
        })
        yPos += 180

        ' Row 3: Invoice Metrics
        CreateKPIRow(yPos, {
            CreateKPIPanel("Invoices Paid", "0", "vs Yesterday", 8),
            CreateKPIPanel("Invoices Due", "0", "vs Yesterday", 9),
            New Panel With {.Visible = False},
            New Panel With {.Visible = False}
        })

        LoadBranches()
    End Sub

    Private Function CreateKPIPanel(title As String, value As String, comparison As String, index As Integer) As Panel
        Dim panel As New Panel With {
            .Size = New Size(350, 150),
            .BackColor = Color.White,
            .Margin = New Padding(10)
        }

        ' Add shadow effect
        AddHandler panel.Paint, Sub(s, e)
            Dim rect As New Rectangle(0, 0, panel.Width - 1, panel.Height - 1)
            Using pen As New Pen(Color.FromArgb(200, 200, 200), 1)
                e.Graphics.DrawRectangle(pen, rect)
            End Using
        End Sub

        Dim lblTitle As New Label With {
            .Text = title,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = MogaliaSecondary,
            .Location = New Point(20, 15),
            .AutoSize = True
        }

        Dim lblValue As New Label With {
            .Name = $"lblValue{index}",
            .Text = value,
            .Font = New Font("Segoe UI", 24, FontStyle.Bold),
            .ForeColor = MogaliaPrimary,
            .Location = New Point(20, 45),
            .AutoSize = True
        }

        Dim lblComparison As New Label With {
            .Name = $"lblComparison{index}",
            .Text = comparison,
            .Font = New Font("Segoe UI", 9, FontStyle.Regular),
            .ForeColor = Color.Gray,
            .Location = New Point(20, 90),
            .AutoSize = True
        }

        Dim lblArrow As New Label With {
            .Name = $"lblArrow{index}",
            .Text = "",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .Location = New Point(20, 110),
            .AutoSize = True
        }

        panel.Controls.AddRange({lblTitle, lblValue, lblComparison, lblArrow})

        ' Store panel reference
        Select Case index
            Case 0 : pnlTotalSales = panel
            Case 1 : pnlTransactions = panel
            Case 2 : pnlAvgOrderValue = panel
            Case 3 : pnlProfitMargin = panel
            Case 4 : pnlTotalOrders = panel
            Case 5 : pnlOrdersCompleted = panel
            Case 6 : pnlOrdersPickedUp = panel
            Case 7 : pnlOrdersNotPickedUp = panel
            Case 8 : pnlInvoicesPaid = panel
            Case 9 : pnlInvoicesDue = panel
        End Select

        Return panel
    End Function

    Private Sub CreateKPIRow(yPos As Integer, panels As Panel())
        Dim xPos As Integer = 20
        For Each panel In panels
            If panel.Visible Then
                panel.Location = New Point(xPos, yPos)
                scrollPanel.Controls.Add(panel)
                xPos += 370
            End If
        Next
    End Sub

    Private Sub LoadBranches()
        Try
            cboBranch.Items.Clear()
            cboBranch.Items.Add(New With {.BranchID = 0, .BranchName = "All Branches", .Display = "All Branches"})

            Using conn As New SqlConnection(connString)
                conn.Open()
                Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            cboBranch.Items.Add(New With {
                                .BranchID = reader.GetInt32(0),
                                .BranchName = reader.GetString(1),
                                .Display = reader.GetString(1)
                            })
                        End While
                    End Using
                End Using
            End Using

            cboBranch.DisplayMember = "Display"
            If cboBranch.Items.Count > 0 Then
                cboBranch.SelectedIndex = 0
            End If

        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub CboBranch_SelectedIndexChanged(sender As Object, e As EventArgs)
        If cboBranch.SelectedItem IsNot Nothing Then
            selectedBranchID = CInt(cboBranch.SelectedItem.BranchID)
            LoadLiveData()
        End If
    End Sub

    Private Sub LoadLiveData()
        Try
            Using conn As New SqlConnection(connString)
                conn.Open()

                ' Get today's data
                Dim todayData = GetDailyMetrics(conn, DateTime.Today, selectedBranchID)
                
                ' Get yesterday's data for comparison
                Dim yesterdayData = GetDailyMetrics(conn, DateTime.Today.AddDays(-1), selectedBranchID)

                ' Update KPIs with comparison
                UpdateKPI(pnlTotalSales, 0, todayData.TotalSales, yesterdayData.TotalSales, "R {0:N2}")
                UpdateKPI(pnlTransactions, 1, todayData.Transactions, yesterdayData.Transactions, "{0:N0}")
                UpdateKPI(pnlAvgOrderValue, 2, todayData.AvgOrderValue, yesterdayData.AvgOrderValue, "R {0:N2}")
                UpdateKPI(pnlProfitMargin, 3, todayData.ProfitMargin, yesterdayData.ProfitMargin, "{0:N1}%")
                
                UpdateKPI(pnlTotalOrders, 4, todayData.TotalOrders, yesterdayData.TotalOrders, "{0:N0}")
                UpdateKPI(pnlOrdersCompleted, 5, todayData.OrdersCompleted, yesterdayData.OrdersCompleted, "{0:N0}")
                UpdateKPI(pnlOrdersPickedUp, 6, todayData.OrdersPickedUp, yesterdayData.OrdersPickedUp, "{0:N0}")
                UpdateKPI(pnlOrdersNotPickedUp, 7, todayData.OrdersNotPickedUp, yesterdayData.OrdersNotPickedUp, "{0:N0}")
                
                UpdateKPI(pnlInvoicesPaid, 8, todayData.InvoicesPaid, yesterdayData.InvoicesPaid, "{0:N0}")
                UpdateKPI(pnlInvoicesDue, 9, todayData.InvoicesDue, yesterdayData.InvoicesDue, "{0:N0}")
            End Using

        Catch ex As Exception
            MessageBox.Show($"Error loading live data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function GetDailyMetrics(conn As SqlConnection, targetDate As Date, branchID As Integer) As DailyMetrics
        Dim metrics As New DailyMetrics()

        Dim branchFilter = If(branchID = 0, "", " AND BranchID = @BranchID")

        ' Sales Metrics
        Dim sql = $"
            SELECT 
                ISNULL(SUM(TotalAmount), 0) AS TotalSales,
                COUNT(*) AS Transactions,
                ISNULL(AVG(TotalAmount), 0) AS AvgOrderValue,
                0 AS ProfitMargin
            FROM Sales
            WHERE CAST(SaleDate AS DATE) = @TargetDate {branchFilter}"

        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@TargetDate", targetDate)
            If branchID > 0 Then cmd.Parameters.AddWithValue("@BranchID", branchID)

            Using reader = cmd.ExecuteReader()
                If reader.Read() Then
                    metrics.TotalSales = reader.GetDecimal(0)
                    metrics.Transactions = reader.GetInt32(1)
                    metrics.AvgOrderValue = reader.GetDecimal(2)
                    metrics.ProfitMargin = reader.GetDecimal(3)
                End If
            End Using
        End Using

        ' Order Metrics - Using ReOrderProducts table for manufacturing orders
        sql = $"
            SELECT 
                COUNT(*) AS TotalOrders,
                SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS OrdersCompleted,
                SUM(CASE WHEN Status = 'Picked Up' OR Status = 'Completed' THEN 1 ELSE 0 END) AS OrdersPickedUp,
                SUM(CASE WHEN Status NOT IN ('Completed', 'Picked Up') THEN 1 ELSE 0 END) AS OrdersNotPickedUp
            FROM ReOrderProducts
            WHERE CAST(OrderDate AS DATE) = @TargetDate {branchFilter}"

        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@TargetDate", targetDate)
            If branchID > 0 Then cmd.Parameters.AddWithValue("@BranchID", branchID)

            Using reader = cmd.ExecuteReader()
                If reader.Read() Then
                    metrics.TotalOrders = reader.GetInt32(0)
                    metrics.OrdersCompleted = reader.GetInt32(1)
                    metrics.OrdersPickedUp = reader.GetInt32(2)
                    metrics.OrdersNotPickedUp = reader.GetInt32(3)
                End If
            End Using
        End Using

        ' Invoice Metrics
        sql = $"
            SELECT 
                SUM(CASE WHEN Status = 'Paid' THEN 1 ELSE 0 END) AS InvoicesPaid,
                SUM(CASE WHEN Status = 'Due' OR Status = 'Overdue' THEN 1 ELSE 0 END) AS InvoicesDue
            FROM Invoices
            WHERE CAST(InvoiceDate AS DATE) = @TargetDate {branchFilter}"

        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@TargetDate", targetDate)
            If branchID > 0 Then cmd.Parameters.AddWithValue("@BranchID", branchID)

            Using reader = cmd.ExecuteReader()
                If reader.Read() Then
                    metrics.InvoicesPaid = If(reader.IsDBNull(0), 0, reader.GetInt32(0))
                    metrics.InvoicesDue = If(reader.IsDBNull(1), 0, reader.GetInt32(1))
                End If
            End Using
        End Using

        Return metrics
    End Function

    Private Sub UpdateKPI(panel As Panel, index As Integer, todayValue As Decimal, yesterdayValue As Decimal, format As String)
        If panel Is Nothing Then Return

        Dim lblValue = TryCast(panel.Controls($"lblValue{index}"), Label)
        Dim lblComparison = TryCast(panel.Controls($"lblComparison{index}"), Label)
        Dim lblArrow = TryCast(panel.Controls($"lblArrow{index}"), Label)

        If lblValue IsNot Nothing Then
            lblValue.Text = String.Format(format, todayValue)
        End If

        If lblComparison IsNot Nothing AndAlso lblArrow IsNot Nothing Then
            Dim difference = todayValue - yesterdayValue
            Dim percentChange = If(yesterdayValue <> 0, (difference / yesterdayValue) * 100, 0)

            If difference > 0 Then
                lblArrow.Text = "▲"
                lblArrow.ForeColor = MogaliaSuccess
                lblComparison.Text = $"+{Math.Abs(percentChange):N1}% vs Yesterday"
                lblComparison.ForeColor = MogaliaSuccess
            ElseIf difference < 0 Then
                lblArrow.Text = "▼"
                lblArrow.ForeColor = MogaliaDanger
                lblComparison.Text = $"-{Math.Abs(percentChange):N1}% vs Yesterday"
                lblComparison.ForeColor = MogaliaDanger
            Else
                lblArrow.Text = "━"
                lblArrow.ForeColor = Color.Gray
                lblComparison.Text = "No change vs Yesterday"
                lblComparison.ForeColor = Color.Gray
            End If
        End If
    End Sub

    Private Class DailyMetrics
        Public Property TotalSales As Decimal
        Public Property Transactions As Integer
        Public Property AvgOrderValue As Decimal
        Public Property ProfitMargin As Decimal
        Public Property TotalOrders As Integer
        Public Property OrdersCompleted As Integer
        Public Property OrdersPickedUp As Integer
        Public Property OrdersNotPickedUp As Integer
        Public Property InvoicesPaid As Integer
        Public Property InvoicesDue As Integer
    End Class
    End Class
End Namespace
