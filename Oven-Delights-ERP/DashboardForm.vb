Imports System.Windows.Forms
Imports Microsoft.Web.WebView2.WinForms
Imports System.IO

Partial Class DashboardForm
    Inherits Form

    Private chartsService As New DashboardChartsService()
    Private WithEvents webView As WebView2
    Private dashboardTimer As Timer

    Public Sub New()
        InitializeComponent()
        InitializeWebView()
        SetupAutoRefresh()
    End Sub

    Private Sub InitializeWebView()
        webView = New WebView2()
        webView.Dock = DockStyle.Fill
        Me.Controls.Add(webView)
        
        AddHandler webView.NavigationCompleted, AddressOf WebView_NavigationCompleted
        AddHandler webView.WebMessageReceived, AddressOf WebView_WebMessageReceived
        
        ' Load the dashboard HTML file
        Dim htmlPath As String = Path.Combine(Application.StartupPath, "Resources", "DashboardCharts.html")
        
        ' If not found in output directory, try source directory
        If Not File.Exists(htmlPath) Then
            Dim sourceHtmlPath As String = Path.Combine(Directory.GetParent(Application.StartupPath).Parent.Parent.FullName, "Resources", "DashboardCharts.html")
            If File.Exists(sourceHtmlPath) Then
                htmlPath = sourceHtmlPath
            End If
        End If
        
        If File.Exists(htmlPath) Then
            webView.Source = New Uri(String.Format("file:///{0}", htmlPath.Replace("\", "/")))
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

            Dim loginFrequencyData As String = chartsService.GetLoginFrequencyChartData()
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
