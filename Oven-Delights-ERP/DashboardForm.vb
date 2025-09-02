Option Strict On
Option Explicit On
Imports System.Windows.Forms
Imports Microsoft.Web.WebView2.WinForms
Imports System.IO
' Charting types are referenced fully-qualified below

' Toggle this to True when the environment has the Windows Desktop targeting pack/Charting installed
#Const HAS_CHART = False

Partial Class DashboardForm
    Inherits Form

    Private chartsService As New DashboardChartsService()
    Private WithEvents webView As WebView2
    Private dashboardTimer As Timer
#If HAS_CHART Then
    Private stockChart As System.Windows.Forms.DataVisualization.Charting.Chart
#End If

    Public Sub New()
        InitializeComponent()
#If HAS_CHART Then
        InitializeChartsUI()
#End If
        InitializeWebView() ' keep but hidden to avoid HTML charts
        SetupAutoRefresh()
    End Sub

#If HAS_CHART Then
    Private Sub InitializeChartsUI()
        stockChart = New System.Windows.Forms.DataVisualization.Charting.Chart()
        stockChart.Dock = DockStyle.Fill
        stockChart.BackColor = Color.White

        Dim area As New System.Windows.Forms.DataVisualization.Charting.ChartArea("Main")
        area.BackColor = Color.White
        area.AxisX.MajorGrid.Enabled = False
        area.AxisY.MajorGrid.LineColor = Color.FromArgb(230, 235, 245)
        area.AxisX.LabelStyle.Font = New Font("Segoe UI", 9.0F)
        area.AxisY.LabelStyle.Font = New Font("Segoe UI", 9.0F)
        stockChart.ChartAreas.Add(area)

        Dim series As New System.Windows.Forms.DataVisualization.Charting.Series("Stock On Hand")
        series.ChartType = System.Windows.Forms.DataVisualization.Charting.SeriesChartType.Column
        series.ChartArea = "Main"
        series.Color = Color.FromArgb(79, 172, 254) ' blue
        series.BorderColor = Color.FromArgb(70, 130, 230)
        series.BorderWidth = 1
        series.IsValueShownAsLabel = True
        series.Font = New Font("Segoe UI", 9.0F)

        ' Sample data
        series.Points.AddXY("Flour", 120)
        series.Points.AddXY("Sugar", 85)
        series.Points.AddXY("Yeast", 40)
        series.Points.AddXY("Oil", 60)

        stockChart.Series.Add(series)

        Dim legend As New System.Windows.Forms.DataVisualization.Charting.Legend("Legend1") With {
            .Docking = Docking.Bottom,
            .Font = New Font("Segoe UI", 9.0F)
        }
        stockChart.Legends.Add(legend)

        Controls.Add(stockChart)
        Controls.SetChildIndex(stockChart, 0)
    End Sub
#End If

    Private Async Sub InitializeWebView()
        webView = New WebView2()
        webView.Dock = DockStyle.Fill
        webView.Visible = True ' HTML charts are the primary surface
        Me.Controls.Add(webView)
        
        AddHandler webView.NavigationCompleted, AddressOf WebView_NavigationCompleted
        AddHandler webView.WebMessageReceived, AddressOf WebView_WebMessageReceived
        
        ' Load the freshest dashboard HTML file
        Dim outputHtml As String = Path.Combine(System.Windows.Forms.Application.StartupPath, "Resources", "DashboardCharts.html")
        Dim sourceHtml As String = Nothing
        Try
            ' Probe up to 6 parent levels for source Resources/DashboardCharts.html
            Dim probe As DirectoryInfo = New DirectoryInfo(System.Windows.Forms.Application.StartupPath)
            For i As Integer = 0 To 6
                Dim candidate As String = Path.Combine(probe.FullName, "Resources", "DashboardCharts.html")
                If File.Exists(candidate) Then
                    sourceHtml = candidate
                    Exit For
                End If
                If probe.Parent Is Nothing Then Exit For
                probe = probe.Parent
            Next
        Catch
            ' ignore probe errors
        End Try

        Try
            ' Always copy latest source to output so user edits take effect immediately
            If Not Directory.Exists(Path.GetDirectoryName(outputHtml)) Then
                Directory.CreateDirectory(Path.GetDirectoryName(outputHtml))
            End If
            If Not String.IsNullOrEmpty(sourceHtml) AndAlso File.Exists(sourceHtml) Then
                File.Copy(sourceHtml, outputHtml, True)
            End If
        Catch ex As Exception
            ' Non-fatal
        End Try

        Dim htmlPath As String = If(File.Exists(outputHtml), outputHtml, If(Not String.IsNullOrEmpty(sourceHtml) AndAlso File.Exists(sourceHtml), sourceHtml, outputHtml))
        If File.Exists(htmlPath) Then
            ' Ensure WebView2 runtime is initialized before navigating
            Try
                Await webView.EnsureCoreWebView2Async(Nothing)
            Catch
                ' continue; navigate anyway
            End Try
            webView.Source = New Uri(String.Format("file:///{0}", htmlPath.Replace("\\", "/")))
        Else
            MessageBox.Show("Dashboard HTML file not found: " & htmlPath, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
    End Sub

    Private Sub SetupAutoRefresh()
        dashboardTimer = New Timer()
        dashboardTimer.Interval = 30000 ' 30 seconds
        AddHandler dashboardTimer.Tick, AddressOf RefreshDashboard
        dashboardTimer.Start()
    End Sub

    Private Async Sub WebView_NavigationCompleted(sender As Object, e As Microsoft.Web.WebView2.Core.CoreWebView2NavigationCompletedEventArgs)
        If e.IsSuccess Then
            ' Initial data load
            Await LoadDashboardData()
        End If
    End Sub

    Private Sub WebView_WebMessageReceived(sender As Object, e As Microsoft.Web.WebView2.Core.CoreWebView2WebMessageReceivedEventArgs)
        Dim message As String = e.TryGetWebMessageAsString()
        If message = "refreshDashboard" Then
            RefreshDashboard(Nothing, Nothing)
        End If
    End Sub

    Private Async Sub RefreshDashboard(sender As Object, e As EventArgs)
        Await LoadDashboardData()
    End Sub

    Private Async Function LoadDashboardData() As Task
        Try
            ' Update stat cards
            Await webView.ExecuteScriptAsync($"updateStatCard('totalUsers', '{GetTotalUsersCount()}');")
            Await webView.ExecuteScriptAsync($"updateStatCard('activeUsers', '{GetActiveUsersCount()}');")
            Await webView.ExecuteScriptAsync($"updateStatCard('activeSessions', '{chartsService.GetActiveSessionsCount()}');")
            Await webView.ExecuteScriptAsync($"updateStatCard('totalBranches', '{GetTotalBranchesCount()}');")

            ' Update charts
            Dim userActivityData As String = chartsService.GetUserActivityChartData()
            Await webView.ExecuteScriptAsync($"updateChartData('userActivity', '{userActivityData}');")

            Dim loginFrequencyData As String = chartsService.GetLastLoginFrequencyChartData()
            Await webView.ExecuteScriptAsync($"updateChartData('loginFrequency', '{loginFrequencyData}');")

            Dim branchDistributionData As String = chartsService.GetBranchDistributionChartData()
            Await webView.ExecuteScriptAsync($"updateChartData('branchDistribution', '{branchDistributionData}');")

            Dim roleDistributionData As String = chartsService.GetRoleDistributionChartData()
            Await webView.ExecuteScriptAsync($"updateChartData('roleDistribution', '{roleDistributionData}');")

            Dim registrationTrendsData As String = chartsService.GetUserRegistrationTrendsData()
            Await webView.ExecuteScriptAsync($"updateChartData('registrationTrends', '{registrationTrendsData}');")

        Catch ex As Exception
            MessageBox.Show("Error loading dashboard data: " & ex.Message, "Dashboard Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Function

    Private Function GetTotalUsersCount() As Integer
        Using conn As New Microsoft.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            Try
                conn.Open()
                Dim cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM Users", conn)
                Return Convert.ToInt32(cmd.ExecuteScalar())
            Catch ex As Exception
                Return 0
            End Try
        End Using
    End Function

    Private Function GetActiveUsersCount() As Integer
        Using conn As New Microsoft.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            Try
                conn.Open()
                Dim cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM Users WHERE IsActive = 1", conn)
                Return Convert.ToInt32(cmd.ExecuteScalar())
            Catch ex As Exception
                Return 0
            End Try
        End Using
    End Function

    Private Function GetTotalBranchesCount() As Integer
        Using conn As New Microsoft.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            Try
                conn.Open()
                Dim cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM Branches WHERE IsActive = 1", conn)
                Return Convert.ToInt32(cmd.ExecuteScalar())
            Catch ex As Exception
                Return 0
            End Try
        End Using
    End Function

    Protected Overrides Sub OnFormClosed(e As FormClosedEventArgs)
        If dashboardTimer IsNot Nothing Then
            dashboardTimer.Stop()
            dashboardTimer.Dispose()
        End If
        MyBase.OnFormClosed(e)
    End Sub
End Class
