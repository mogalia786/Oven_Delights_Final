Imports System.Windows.Forms
Imports Microsoft.Web.WebView2.WinForms
Imports Microsoft.Web.WebView2.Core

Partial Class MainDashboard
    Inherits Form

    Private logoutAllowed As Boolean = False
    Private currentUser As User
    Private dashboardService As DashboardChartsService
    Private signalRService As SignalRService
    Private reportingService As ReportingService

    Public Sub New()
        InitializeComponent()
        Me.IsMdiContainer = True
        Me.WindowState = FormWindowState.Maximized
        Me.Text = "Oven Delights ERP - Main Dashboard"
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.ControlBox = False
        Me.MenuStrip1.Dock = DockStyle.Top
        Me.MenuStrip1.Visible = True
        Me.MenuStrip1.Enabled = True
        
        ' Initialize services
        InitializeServices()
    End Sub
    
    Private Async Sub InitializeServices()
        Try
            ' Initialize reporting service
            reportingService = New ReportingService()
            
            ' Initialize dashboard service
            dashboardService = New DashboardChartsService()
            
            ' Initialize SignalR service (optional - don't fail if connection fails)
            Try
                signalRService = New SignalRService()
                AddHandler signalRService.UserLoggedIn, AddressOf OnUserLoggedIn
                AddHandler signalRService.UserLoggedOut, AddressOf OnUserLoggedOut
                AddHandler signalRService.SecurityAlert, AddressOf OnSecurityAlert
                AddHandler signalRService.SystemNotification, AddressOf OnSystemNotification
                
                ' Start SignalR connection (optional)
                Await signalRService.StartAsync()
            Catch signalREx As Exception
                ' SignalR connection failed - continue without real-time features
                ' This is expected if no SignalR hub is running
                signalRService = Nothing
            End Try
            
        Catch ex As Exception
            MessageBox.Show("Error initializing core services: " & ex.Message, "Initialization Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Protected Overrides Sub OnFormClosing(e As FormClosingEventArgs)
        If Not logoutAllowed AndAlso Not allowExit Then
            e.Cancel = True
        End If
        MyBase.OnFormClosing(e)
    End Sub

    ' Call this method to allow logout and close
    Public Sub AllowLogoutAndClose()
        logoutAllowed = True
        Me.Close()
    End Sub

    Private allowExit As Boolean = False
    Private Sub ExitToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ExitToolStripMenuItem.Click
        allowExit = True
        Application.Exit()
    End Sub

    Private Sub OpenUserManagement()
        Dim userMgmtForm As New UserManagementForm()
        userMgmtForm.MdiParent = Me
        userMgmtForm.Show()
    End Sub

    Private Sub UserManagementMenuItem_Click(sender As Object, e As EventArgs)
        Try
            Dim userMgmtForm As New UserManagementForm()
            userMgmtForm.MdiParent = Me
            userMgmtForm.Show()
        Catch ex As Exception
            MessageBox.Show($"Error opening User Management: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenDashboard()
        Dim dashboardForm As New DashboardForm()
        dashboardForm.MdiParent = Me
        dashboardForm.Show()
    End Sub

    Private Sub DashboardMenuItem_Click(sender As Object, e As EventArgs)
        OpenDashboard()
    End Sub

    ' SignalR Event Handlers
    Private Sub OnUserLoggedIn(sender As Object, username As String)
        Me.Invoke(Sub()
                      ' Update UI to show user logged in
                      ' You can add a status bar or notification area
                  End Sub)
    End Sub
    
    Private Sub OnUserLoggedOut(sender As Object, username As String)
        Me.Invoke(Sub()
                      ' Update UI to show user logged out
                  End Sub)
    End Sub
    
    Private Sub OnSecurityAlert(sender As Object, message As String)
        Me.Invoke(Sub()
                      MessageBox.Show(message, "Security Alert", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                  End Sub)
    End Sub
    
    Private Sub OnSystemNotification(sender As Object, message As String)
        Me.Invoke(Sub()
                      ' Show system notification in UI
                      ' You can implement a notification panel or toast
                  End Sub)
    End Sub
    
    ' Cleanup on form closing
    Protected Overrides Sub OnFormClosed(e As FormClosedEventArgs)
        Try
            If signalRService IsNot Nothing Then
                signalRService.StopAsync().Wait()
                signalRService.Dispose()
            End If
        Catch ex As Exception
            ' Silent cleanup
        End Try
        MyBase.OnFormClosed(e)
    End Sub
    
    ' Stockroom Menu Event Handlers
    Private Sub StockroomToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles StockroomToolStripMenuItem.Click
        ' Create stockroom submenu dynamically
        StockroomToolStripMenuItem.DropDownItems.Clear()
        
        Dim inventoryItem As New ToolStripMenuItem("Inventory")
        AddHandler inventoryItem.Click, AddressOf InventoryMenuItem_Click
        
        Dim stockTransfersItem As New ToolStripMenuItem("Stock Transfers")
        AddHandler stockTransfersItem.Click, AddressOf StockTransfersMenuItem_Click
        
        Dim stockAdjustmentsItem As New ToolStripMenuItem("Stock Adjustments")
        AddHandler stockAdjustmentsItem.Click, AddressOf StockAdjustmentsMenuItem_Click
        
        Dim suppliersItem As New ToolStripMenuItem("Suppliers")
        AddHandler suppliersItem.Click, AddressOf SuppliersMenuItem_Click
        
        StockroomToolStripMenuItem.DropDownItems.AddRange(New ToolStripItem() {
            inventoryItem, stockTransfersItem, stockAdjustmentsItem, suppliersItem
        })
    End Sub

    Private Sub InventoryMenuItem_Click(sender As Object, e As EventArgs)
        Try
            If currentUser Is Nothing Then
                MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim stockroomForm As New StockroomManagementForm(currentUser)
            stockroomForm.MdiParent = Me
            stockroomForm.Show()
        Catch ex As Exception
            MessageBox.Show($"Error opening Inventory: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub StockTransfersMenuItem_Click(sender As Object, e As EventArgs)
        Try
            If currentUser Is Nothing Then
                MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim stockTransferForm As New StockTransferForm(currentUser)
            stockTransferForm.MdiParent = Me
            stockTransferForm.Show()
        Catch ex As Exception
            MessageBox.Show($"Error opening Stock Transfers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub StockAdjustmentsMenuItem_Click(sender As Object, e As EventArgs)
        Try
            If currentUser Is Nothing Then
                MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim stockAdjustmentForm As New StockAdjustmentForm(currentUser)
            stockAdjustmentForm.MdiParent = Me
            stockAdjustmentForm.Show()
        Catch ex As Exception
            MessageBox.Show($"Error opening Stock Adjustments: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SuppliersMenuItem_Click(sender As Object, e As EventArgs)
        Try
            If currentUser Is Nothing Then
                MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim stockroomForm As New StockroomManagementForm(currentUser)
            stockroomForm.MdiParent = Me
            stockroomForm.Show()
        Catch ex As Exception
            MessageBox.Show($"Error opening Suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' Set current user when dashboard is opened
    Public Sub SetCurrentUser(user As User)
        currentUser = user
        Me.Text = $"Oven Delights ERP - Main Dashboard - {user.DisplayName}"
    End Sub
End Class
