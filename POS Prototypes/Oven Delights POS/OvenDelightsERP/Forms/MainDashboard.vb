Imports System.Drawing
Imports System.Windows.Forms
Imports System.Data.SqlClient
Imports Microsoft.AspNet.SignalR.Client

Public Class MainDashboard
    Inherits Form

    ' User context
    Private currentUser As User
    Private dashboardStats As DashboardStats
    Private WithEvents hubConnection As HubConnection

    ' UI Controls - These are defined in MainDashboard.Designer.vb with WithEvents
    ' Add any additional controls that need event handling here with WithEvents

    Public Sub New(user As User)
        currentUser = user
        InitializeComponent()
        SetupModernUI()
        LoadDashboardData()
        InitializeSignalR()
        SetupChartsDashboard()

        ' All UI setup code moved inside constructor
        panelHeader.Location = New Point(0, menuStrip.Height)
        panelHeader.BackColor = Color.White
        panelHeader.BorderStyle = BorderStyle.None
        Me.Controls.Add(panelHeader)

        ' Welcome Label
        lblWelcome = New Label()
        lblWelcome.Text = $"Welcome back, {currentUser.FirstName}!"
        lblWelcome.Font = New Font("Segoe UI", 18, FontStyle.Bold)
        lblWelcome.ForeColor = Color.FromArgb(45, 52, 67)
        lblWelcome.Location = New Point(30, 15)
        lblWelcome.AutoSize = True
        panelHeader.Controls.Add(lblWelcome)

        ' User Info Label
        lblUserInfo = New Label()
        lblUserInfo.Text = $"{currentUser.DisplayRole} • {currentUser.BranchName}"
        lblUserInfo.Font = New Font("Segoe UI", 10)
        lblUserInfo.ForeColor = Color.FromArgb(108, 117, 125)
        lblUserInfo.Location = New Point(30, 45)
        lblUserInfo.AutoSize = True
        panelHeader.Controls.Add(lblUserInfo)

        ' Logout Button
        btnLogout = New Button()
        btnLogout.Text = "🚪 Logout"
        btnLogout.Size = New Size(100, 35)
        btnLogout.Location = New Point(Me.Width - 130, 22)
        btnLogout.Font = New Font("Segoe UI", 9)
        btnLogout.BackColor = Color.FromArgb(220, 53, 69)
        btnLogout.ForeColor = Color.White
        btnLogout.FlatStyle = FlatStyle.Flat
        btnLogout.FlatAppearance.BorderSize = 0
        btnLogout.Anchor = AnchorStyles.Top Or AnchorStyles.Right
        panelHeader.Controls.Add(btnLogout)

        ' Sidebar Panel
        panelSidebar = New Panel()
        panelSidebar.Size = New Size(250, Me.Height - menuStrip.Height - panelHeader.Height - statusStrip.Height)
        panelSidebar.Location = New Point(0, menuStrip.Height + panelHeader.Height)
        panelSidebar.BackColor = Color.FromArgb(52, 58, 64)
        panelSidebar.Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left
        Me.Controls.Add(panelSidebar)

        ' Main Panel
        panelMain = New Panel()
        panelMain.Size = New Size(Me.Width - panelSidebar.Width, panelSidebar.Height)
        panelMain.Location = New Point(panelSidebar.Width, menuStrip.Height + panelHeader.Height)
        panelMain.BackColor = Color.FromArgb(240, 244, 248)
        panelMain.Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right
        Me.Controls.Add(panelMain)

        ' Setup navigation buttons
        SetupNavigationButtons()

        ' Setup dashboard cards
        SetupDashboardCards()

        ' Setup charts web browser
        webBrowserCharts = New WebBrowser()
        webBrowserCharts.Size = New Size(panelMain.Width - 40, 400)
        webBrowserCharts.Location = New Point(20, 200)
        webBrowserCharts.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right
        panelMain.Controls.Add(webBrowserCharts)

        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub

    Private Sub SetupNavigationButtons()
        Dim buttonY As Integer = 20
        Dim buttonHeight As Integer = 50
        Dim buttonSpacing As Integer = 10

        ' User Management Button
        btnUserManagement = CreateNavButton("👥 User Management", buttonY)
        panelSidebar.Controls.Add(btnUserManagement)
        buttonY += buttonHeight + buttonSpacing

        ' Branch Management Button
        btnBranchManagement = CreateNavButton("🏢 Branch Management", buttonY)
        panelSidebar.Controls.Add(btnBranchManagement)
        buttonY += buttonHeight + buttonSpacing

        ' Audit Log Button
        btnAuditLog = CreateNavButton("📋 Audit Log", buttonY)
        panelSidebar.Controls.Add(btnAuditLog)
        buttonY += buttonHeight + buttonSpacing

        ' System Settings Button
        btnSystemSettings = CreateNavButton("⚙️ System Settings", buttonY)
        panelSidebar.Controls.Add(btnSystemSettings)
        buttonY += buttonHeight + buttonSpacing

        ' Reports Button
        btnReports = CreateNavButton("📊 Reports", buttonY)
        panelSidebar.Controls.Add(btnReports)
    End Sub

    Private Function CreateNavButton(text As String, y As Integer) As Button
        Dim btn As New Button()
        btn.Text = text
        btn.Size = New Size(230, 50)
        btn.Location = New Point(10, y)
        btn.Font = New Font("Segoe UI", 11)
        btn.BackColor = Color.FromArgb(73, 80, 87)
        btn.ForeColor = Color.White
        btn.FlatStyle = FlatStyle.Flat
        btn.FlatAppearance.BorderSize = 0
        btn.TextAlign = ContentAlignment.MiddleLeft
        btn.Padding = New Padding(15, 0, 0, 0)
        btn.Cursor = Cursors.Hand

        ' Add hover effect
        AddHandler btn.MouseEnter, Sub() btn.BackColor = Color.FromArgb(52, 152, 219)
        AddHandler btn.MouseLeave, Sub() btn.BackColor = Color.FromArgb(73, 80, 87)

        Return btn
    End Function

    Private Sub SetupDashboardCards()
        Dim cardWidth As Integer = 250
        Dim cardHeight As Integer = 120
        Dim cardSpacing As Integer = 20
        Dim startX As Integer = 20
        Dim startY As Integer = 20

        ' Total Users Card
        cardTotalUsers = CreateDashboardCard("Total Users", "0", Color.FromArgb(52, 152, 219), startX, startY)
        panelMain.Controls.Add(cardTotalUsers)

        ' Active Users Card
        cardActiveUsers = CreateDashboardCard("Active Users", "0", Color.FromArgb(40, 167, 69), startX + cardWidth + cardSpacing, startY)
        panelMain.Controls.Add(cardActiveUsers)

        ' Total Branches Card
        cardTotalBranches = CreateDashboardCard("Total Branches", "0", Color.FromArgb(255, 193, 7), startX + (cardWidth + cardSpacing) * 2, startY)
        panelMain.Controls.Add(cardTotalBranches)

        ' Active Sessions Card
        cardActiveSessions = CreateDashboardCard("Active Sessions", "0", Color.FromArgb(220, 53, 69), startX + (cardWidth + cardSpacing) * 3, startY)
        panelMain.Controls.Add(cardActiveSessions)
    End Sub

    Private Function CreateDashboardCard(title As String, value As String, color As Color, x As Integer, y As Integer) As Panel
        Dim card As New Panel()
        card.Size = New Size(250, 120)
        card.Location = New Point(x, y)
        card.BackColor = Color.White
        card.BorderStyle = BorderStyle.None

        ' Add shadow effect
        AddShadowEffect(card)

        ' Title label
        Dim lblTitle As New Label()
        lblTitle.Text = title
        lblTitle.Font = New Font("Segoe UI", 10)
        lblTitle.ForeColor = Color.FromArgb(108, 117, 125)
        lblTitle.Location = New Point(15, 15)
        lblTitle.AutoSize = True
        card.Controls.Add(lblTitle)

        ' Value label
        Dim lblValue As New Label()
        lblValue.Text = value
        lblValue.Font = New Font("Segoe UI", 24, FontStyle.Bold)
        lblValue.ForeColor = color
        lblValue.Location = New Point(15, 40)
        lblValue.AutoSize = True
        lblValue.Name = "value" ' For easy access when updating
        card.Controls.Add(lblValue)

        ' Icon panel
        Dim panelIcon As New Panel()
        panelIcon.Size = New Size(60, 60)
        panelIcon.Location = New Point(180, 30)
        panelIcon.BackColor = color
        card.Controls.Add(panelIcon)

        Return card
    End Function

    Private Sub AddShadowEffect(control As Control)
        ' Create shadow effect
        Dim shadow As New Panel()
        shadow.Size = New Size(control.Width + 5, control.Height + 5)
        shadow.Location = New Point(control.Location.X + 3, control.Location.Y + 3)
        shadow.BackColor = Color.FromArgb(30, 0, 0, 0)
        control.Parent.Controls.Add(shadow)
        shadow.SendToBack()
    End Sub

    Private Sub SetupModernUI()
        ' Apply modern styling to all controls
        ApplyRoundedCorners(panelHeader, 0)
        ApplyRoundedCorners(panelSidebar, 0)
        
        ' Add hover effects to navigation buttons
        For Each ctrl As Control In panelSidebar.Controls
            If TypeOf ctrl Is Button Then
                Dim btn As Button = CType(ctrl, Button)
                AddHoverEffect(btn, Color.FromArgb(52, 152, 219), Color.FromArgb(73, 80, 87))
            End If
        Next
    End Sub

    Private Sub ApplyRoundedCorners(control As Control, radius As Integer)
        If radius > 0 Then
            Dim path As New System.Drawing.Drawing2D.GraphicsPath()
            path.AddArc(0, 0, radius, radius, 180, 90)
            path.AddArc(control.Width - radius, 0, radius, radius, 270, 90)
            path.AddArc(control.Width - radius, control.Height - radius, radius, radius, 0, 90)
            path.AddArc(0, control.Height - radius, radius, radius, 90, 90)
            path.CloseAllFigures()
            control.Region = New Region(path)
        End If
    End Sub

    Private Sub AddHoverEffect(btn As Button, hoverColor As Color, normalColor As Color)
        AddHandler btn.MouseEnter, Sub() btn.BackColor = hoverColor
        AddHandler btn.MouseLeave, Sub() btn.BackColor = normalColor
    End Sub

    Private Sub LoadDashboardData()
        Try
            Dim dataManager As New DashboardDataManager()
            dashboardStats = dataManager.GetDashboardStats()
            
            ' Update dashboard cards
            UpdateDashboardCards()
        Catch ex As Exception
            MessageBox.Show($"Error loading dashboard data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub UpdateDashboardCards()
        If dashboardStats IsNot Nothing Then
            ' Update Total Users card
            Dim lblTotalUsers As Label = CType(cardTotalUsers.Controls("value"), Label)
            lblTotalUsers.Text = dashboardStats.TotalUsers.ToString()

            ' Update Active Users card
            Dim lblActiveUsers As Label = CType(cardActiveUsers.Controls("value"), Label)
            lblActiveUsers.Text = dashboardStats.ActiveUsers.ToString()

            ' Update Total Branches card
            Dim lblTotalBranches As Label = CType(cardTotalBranches.Controls("value"), Label)
            lblTotalBranches.Text = dashboardStats.TotalBranches.ToString()

            ' Update Active Sessions card
            Dim lblActiveSessions As Label = CType(cardActiveSessions.Controls("value"), Label)
            lblActiveSessions.Text = dashboardStats.ActiveSessions.ToString()
        End If
    End Sub

    Private Sub SetupChartsDashboard()
        ' Create a WebBrowser control to display the charts
        Dim webBrowser As New WebBrowser()
        webBrowser.Dock = DockStyle.Fill
        
        ' Set the HTML content from the embedded resource
        Dim htmlPath As String = System.IO.Path.Combine(Application.StartupPath, "Resources", "DashboardCharts.html")
        
        If System.IO.File.Exists(htmlPath) Then
            webBrowser.Url = New Uri(htmlPath)
        Else
            webBrowser.DocumentText = "<h3>Charts not found. Please ensure DashboardCharts.html exists in the Resources folder.</h3>"
        End If
        
        ' Add the WebBrowser to the main panel
        panelMain.Controls.Add(webBrowser)
    End Sub

    Private Sub InitializeSignalR()
        Try
            ' Initialize SignalR connection
            hubConnection = New HubConnection("http://localhost:8080/signalr")
            Dim hubProxy = hubConnection.CreateHubProxy("DashboardHub")
            
            ' Handle real-time updates
            hubProxy.On("UpdateDashboard", Sub(data As String)
                                              ' Update dashboard with real-time data
                                              Me.Invoke(Sub() RefreshDashboard())
                                          End Sub)
            
            hubConnection.Start()
        Catch ex As Exception
            ' SignalR connection failed - continue without real-time updates
            Console.WriteLine($"SignalR connection failed: {ex.Message}")
        End Try
    End Sub

    Private Sub RefreshDashboard()
        LoadDashboardData()
        SetupChartsDashboard()
    End Sub

    ' Navigation button event handlers
    Private Sub btnUserManagement_Click(sender As Object, e As EventArgs) Handles btnUserManagement.Click
        Dim userMgmtForm As New UserManagementForm(currentUser)
        userMgmtForm.ShowDialog()
    End Sub

    Private Sub btnBranchManagement_Click(sender As Object, e As EventArgs) Handles btnBranchManagement.Click
        Dim branchMgmtForm As New BranchManagementForm(currentUser)
        branchMgmtForm.ShowDialog()
    End Sub

    Private Sub btnAuditLog_Click(sender As Object, e As EventArgs) Handles btnAuditLog.Click
        Dim auditForm As New AuditLogViewer(currentUser)
        auditForm.ShowDialog()
    End Sub

    Private Sub btnSystemSettings_Click(sender As Object, e As EventArgs) Handles btnSystemSettings.Click
        Dim settingsForm As New SystemSettingsForm(currentUser)
        settingsForm.ShowDialog()
    End Sub

    Private Sub btnReports_Click(sender As Object, e As EventArgs) Handles btnReports.Click
        Dim reportsForm As New ReportsForm(currentUser)
        reportsForm.ShowDialog()
    End Sub

    Private Sub btnLogout_Click(sender As Object, e As EventArgs) Handles btnLogout.Click
        If MessageBox.Show("Are you sure you want to logout?", "Confirm Logout", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
            Try
                ' Log logout event
                Dim auditLogger As New AuditLogger()
                auditLogger.LogEvent(currentUser.ID, "LOGOUT", "Users", currentUser.ID.ToString(), Nothing, Nothing, $"User {currentUser.Username} logged out", "LOGIN")
                
                ' Close SignalR connection
                If hubConnection IsNot Nothing Then
                    hubConnection.Stop()
                End If
                
                ' Show login form
                Dim loginForm As New LoginForm()
                loginForm.Show()
                Me.Close()
            Catch ex As Exception
                MessageBox.Show($"Error during logout: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

    Protected Overrides Sub OnFormClosing(e As FormClosingEventArgs)
        If hubConnection IsNot Nothing Then
            hubConnection.Stop()
        End If
        MyBase.OnFormClosing(e)
    End Sub
End Class
