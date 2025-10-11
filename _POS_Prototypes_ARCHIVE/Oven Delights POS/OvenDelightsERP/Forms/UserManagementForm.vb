Imports System.Drawing
Imports System.Windows.Forms
Imports System.Data.SqlClient
Imports System.Configuration

Public Class UserManagementForm
    Inherits Form

    ' Current user context
    Private currentUser As User
    Private auditLogger As AuditLogger
    Private authManager As AuthenticationManager

    ' UI Controls
    Private WithEvents dgvUsers As DataGridView
    Private WithEvents txtSearch As TextBox
    Private WithEvents cmbBranchFilter As ComboBox
    Private WithEvents cmbRoleFilter As ComboBox
    Private WithEvents cmbStatusFilter As ComboBox
    Private WithEvents btnAdd As Button
    Private WithEvents btnEdit As Button
    Private WithEvents btnDelete As Button
    Private WithEvents btnResetPassword As Button
    Private WithEvents btnExport As Button
    Private WithEvents btnRefresh As Button
    Private WithEvents lblTotalUsers As Label
    Private WithEvents lblActiveUsers As Label
    Private WithEvents lblInactiveUsers As Label

    ' Panels
    Private WithEvents panelHeader As Panel
    Private WithEvents panelFilters As Panel
    Private WithEvents panelButtons As Panel
    Private WithEvents panelStats As Panel

    Public Sub New(user As User)
        currentUser = user
        auditLogger = New AuditLogger()
        authManager = New AuthenticationManager()
        InitializeComponent()
        SetupModernUI()
        LoadData()
    End Sub

    Private Sub InitializeComponent()
        Me.SuspendLayout()

        ' Form properties
        Me.Text = "User Management - Oven Delights ERP"
        Me.Size = New Size(1200, 800)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.BackColor = Color.FromArgb(240, 244, 248)

        ' Header Panel
        panelHeader = New Panel()
        panelHeader.Size = New Size(Me.Width, 60)
        panelHeader.Location = New Point(0, 0)
        panelHeader.BackColor = Color.FromArgb(45, 52, 67)
        panelHeader.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right
        Me.Controls.Add(panelHeader)

        ' Header Title
        Dim lblTitle As New Label()
        lblTitle.Text = "👥 User Management"
        lblTitle.Font = New Font("Segoe UI", 16, FontStyle.Bold)
        lblTitle.ForeColor = Color.White
        lblTitle.Location = New Point(20, 15)
        lblTitle.AutoSize = True
        panelHeader.Controls.Add(lblTitle)

        ' Stats Panel
        panelStats = New Panel()
        panelStats.Size = New Size(Me.Width, 50)
        panelStats.Location = New Point(0, 60)
        panelStats.BackColor = Color.White
        panelStats.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right
        Me.Controls.Add(panelStats)

        ' Stats Labels
        lblTotalUsers = New Label()
        lblTotalUsers.Text = "Total: 0"
        lblTotalUsers.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        lblTotalUsers.ForeColor = Color.FromArgb(52, 152, 219)
        lblTotalUsers.Location = New Point(20, 15)
        lblTotalUsers.AutoSize = True
        panelStats.Controls.Add(lblTotalUsers)

        lblActiveUsers = New Label()
        lblActiveUsers.Text = "Active: 0"
        lblActiveUsers.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        lblActiveUsers.ForeColor = Color.FromArgb(40, 167, 69)
        lblActiveUsers.Location = New Point(120, 15)
        lblActiveUsers.AutoSize = True
        panelStats.Controls.Add(lblActiveUsers)

        lblInactiveUsers = New Label()
        lblInactiveUsers.Text = "Inactive: 0"
        lblInactiveUsers.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        lblInactiveUsers.ForeColor = Color.FromArgb(220, 53, 69)
        lblInactiveUsers.Location = New Point(220, 15)
        lblInactiveUsers.AutoSize = True
        panelStats.Controls.Add(lblInactiveUsers)

        ' Filters Panel
        panelFilters = New Panel()
        panelFilters.Size = New Size(Me.Width, 80)
        panelFilters.Location = New Point(0, 110)
        panelFilters.BackColor = Color.FromArgb(248, 249, 250)
        panelFilters.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right
        Me.Controls.Add(panelFilters)

        ' Search TextBox
        Dim lblSearch As New Label()
        lblSearch.Text = "Search:"
        lblSearch.Font = New Font("Segoe UI", 9)
        lblSearch.Location = New Point(20, 15)
        lblSearch.AutoSize = True
        panelFilters.Controls.Add(lblSearch)

        txtSearch = New TextBox()
        txtSearch.Size = New Size(200, 25)
        txtSearch.Location = New Point(20, 35)
        txtSearch.Font = New Font("Segoe UI", 9)
        txtSearch.' PlaceholderText removed for .NET Framework compatibility = "Search by name, username, or email..."
        panelFilters.Controls.Add(txtSearch)

        ' Branch Filter
        Dim lblBranch As New Label()
        lblBranch.Text = "Branch:"
        lblBranch.Font = New Font("Segoe UI", 9)
        lblBranch.Location = New Point(240, 15)
        lblBranch.AutoSize = True
        panelFilters.Controls.Add(lblBranch)

        cmbBranchFilter = New ComboBox()
        cmbBranchFilter.Size = New Size(150, 25)
        cmbBranchFilter.Location = New Point(240, 35)
        cmbBranchFilter.Font = New Font("Segoe UI", 9)
        cmbBranchFilter.DropDownStyle = ComboBoxStyle.DropDownList
        panelFilters.Controls.Add(cmbBranchFilter)

        ' Role Filter
        Dim lblRole As New Label()
        lblRole.Text = "Role:"
        lblRole.Font = New Font("Segoe UI", 9)
        lblRole.Location = New Point(410, 15)
        lblRole.AutoSize = True
        panelFilters.Controls.Add(lblRole)

        cmbRoleFilter = New ComboBox()
        cmbRoleFilter.Size = New Size(120, 25)
        cmbRoleFilter.Location = New Point(410, 35)
        cmbRoleFilter.Font = New Font("Segoe UI", 9)
        cmbRoleFilter.DropDownStyle = ComboBoxStyle.DropDownList
        panelFilters.Controls.Add(cmbRoleFilter)

        ' Status Filter
        Dim lblStatus As New Label()
        lblStatus.Text = "Status:"
        lblStatus.Font = New Font("Segoe UI", 9)
        lblStatus.Location = New Point(550, 15)
        lblStatus.AutoSize = True
        panelFilters.Controls.Add(lblStatus)

        cmbStatusFilter = New ComboBox()
        cmbStatusFilter.Size = New Size(100, 25)
        cmbStatusFilter.Location = New Point(550, 35)
        cmbStatusFilter.Font = New Font("Segoe UI", 9)
        cmbStatusFilter.DropDownStyle = ComboBoxStyle.DropDownList
        panelFilters.Controls.Add(cmbStatusFilter)

        ' Buttons Panel
        panelButtons = New Panel()
        panelButtons.Size = New Size(Me.Width, 60)
        panelButtons.Location = New Point(0, 190)
        panelButtons.BackColor = Color.White
        panelButtons.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right
        Me.Controls.Add(panelButtons)

        ' Action Buttons
        btnAdd = CreateButton("➕ Add User", New Point(20, 15), Color.FromArgb(40, 167, 69))
        panelButtons.Controls.Add(btnAdd)

        btnEdit = CreateButton("✏️ Edit", New Point(140, 15), Color.FromArgb(52, 152, 219))
        panelButtons.Controls.Add(btnEdit)

        btnDelete = CreateButton("🗑️ Delete", New Point(220, 15), Color.FromArgb(220, 53, 69))
        panelButtons.Controls.Add(btnDelete)

        btnResetPassword = CreateButton("🔑 Reset Password", New Point(320, 15), Color.FromArgb(255, 193, 7))
        panelButtons.Controls.Add(btnResetPassword)

        btnExport = CreateButton("📊 Export", New Point(480, 15), Color.FromArgb(108, 117, 125))
        panelButtons.Controls.Add(btnExport)

        btnRefresh = CreateButton("🔄 Refresh", New Point(560, 15), Color.FromArgb(23, 162, 184))
        panelButtons.Controls.Add(btnRefresh)

        ' DataGridView
        dgvUsers = New DataGridView()
        dgvUsers.Size = New Size(Me.Width - 40, Me.Height - 290)
        dgvUsers.Location = New Point(20, 260)
        dgvUsers.Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right
        dgvUsers.BackgroundColor = Color.White
        dgvUsers.BorderStyle = BorderStyle.None
        dgvUsers.CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal
        dgvUsers.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(45, 52, 67)
        dgvUsers.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvUsers.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        dgvUsers.ColumnHeadersHeight = 40
        dgvUsers.RowHeadersVisible = False
        dgvUsers.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvUsers.MultiSelect = False
        dgvUsers.AllowUserToAddRows = False
        dgvUsers.AllowUserToDeleteRows = False
        dgvUsers.ReadOnly = True
        Me.Controls.Add(dgvUsers)

        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub

    Private Function CreateButton(text As String, location As Point, color As Color) As Button
        Dim btn As New Button()
        btn.Text = text
        btn.Size = New Size(100, 30)
        btn.Location = location
        btn.Font = New Font("Segoe UI", 9)
        btn.BackColor = color
        btn.ForeColor = Color.White
        btn.FlatStyle = FlatStyle.Flat
        btn.FlatAppearance.BorderSize = 0
        btn.Cursor = Cursors.Hand
        Return btn
    End Function

    Private Sub SetupModernUI()
        ' Setup DataGridView columns
        SetupDataGridColumns()
        
        ' Load filter data
        LoadFilterData()
        
        ' Add event handlers
        AddHandler txtSearch.TextChanged, AddressOf FilterData
        AddHandler cmbBranchFilter.SelectedIndexChanged, AddressOf FilterData
        AddHandler cmbRoleFilter.SelectedIndexChanged, AddressOf FilterData
        AddHandler cmbStatusFilter.SelectedIndexChanged, AddressOf FilterData
    End Sub

    Private Sub SetupDataGridColumns()
        dgvUsers.Columns.Clear()
        
        ' ID Column (hidden)
        dgvUsers.Columns.Add("ID", "ID")
        dgvUsers.Columns("ID").Visible = False
        
        ' Username Column
        dgvUsers.Columns.Add("Username", "Username")
        dgvUsers.Columns("Username").Width = 120
        
        ' Full Name Column
        dgvUsers.Columns.Add("FullName", "Full Name")
        dgvUsers.Columns("FullName").Width = 180
        
        ' Email Column
        dgvUsers.Columns.Add("Email", "Email")
        dgvUsers.Columns("Email").Width = 200
        
        ' Role Column
        dgvUsers.Columns.Add("Role", "Role")
        dgvUsers.Columns("Role").Width = 120
        
        ' Branch Column
        dgvUsers.Columns.Add("Branch", "Branch")
        dgvUsers.Columns("Branch").Width = 150
        
        ' Last Login Column
        dgvUsers.Columns.Add("LastLogin", "Last Login")
        dgvUsers.Columns("LastLogin").Width = 140
        
        ' Status Column
        dgvUsers.Columns.Add("Status", "Status")
        dgvUsers.Columns("Status").Width = 80
        
        ' Actions Column
        Dim actionsColumn As New DataGridViewButtonColumn()
        actionsColumn.Name = "Actions"
        actionsColumn.HeaderText = "Actions"
        actionsColumn.Text = "View"
        actionsColumn.UseColumnTextForButtonValue = True
        actionsColumn.Width = 80
        dgvUsers.Columns.Add(actionsColumn)
    End Sub

    Private Sub LoadFilterData()
        Try
            ' Load branches
            cmbBranchFilter.Items.Clear()
            cmbBranchFilter.Items.Add("All Branches")
            
            Using connection As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERP").ConnectionString)
                connection.Open()
                
                Dim query As String = "SELECT ID, Name FROM Branches WHERE IsActive = 1 ORDER BY Name"
                Using command As New SqlCommand(query, connection)
                    Using reader As SqlDataReader = command.ExecuteReader()
                        While reader.Read()
                            cmbBranchFilter.Items.Add(New ComboBoxItem With {
                                .Text = reader("Name").ToString(),
                                .Value = CInt(reader("ID"))
                            })
                        End While
                    End Using
                End Using
            End Using
            
            cmbBranchFilter.SelectedIndex = 0
            
            ' Load roles
            cmbRoleFilter.Items.Clear()
            cmbRoleFilter.Items.AddRange({"All Roles", "SuperAdmin", "BranchAdmin", "Manager", "Employee"})
            cmbRoleFilter.SelectedIndex = 0
            
            ' Load status options
            cmbStatusFilter.Items.Clear()
            cmbStatusFilter.Items.AddRange({"All Status", "Active", "Inactive", "Locked"})
            cmbStatusFilter.SelectedIndex = 0
            
        Catch ex As Exception
            MessageBox.Show($"Error loading filter data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadData()
        Try
            Using connection As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERP").ConnectionString)
                connection.Open()
                
                Dim query As String = "
                    SELECT 
                        u.ID,
                        u.Username,
                        u.FirstName + ' ' + u.LastName as FullName,
                        u.Email,
                        u.Role,
                        b.Name as BranchName,
                        u.LastLogin,
                        CASE 
                            WHEN u.IsLocked = 1 THEN 'Locked'
                            WHEN u.IsActive = 1 THEN 'Active'
                            ELSE 'Inactive'
                        END as Status,
                        u.IsActive,
                        u.IsLocked,
                        u.BranchID
                    FROM Users u
                    INNER JOIN Branches b ON u.BranchID = b.ID
                    ORDER BY u.FirstName, u.LastName"
                
                Using command As New SqlCommand(query, connection)
                    Using reader As SqlDataReader = command.ExecuteReader()
                        dgvUsers.Rows.Clear()
                        
                        Dim totalUsers As Integer = 0
                        Dim activeUsers As Integer = 0
                        Dim inactiveUsers As Integer = 0
                        
                        While reader.Read()
                            Dim lastLogin As String = If(IsDBNull(reader("LastLogin")), "Never", CDate(reader("LastLogin")).ToString("yyyy-MM-dd HH:mm"))
                            
                            dgvUsers.Rows.Add(
                                reader("ID"),
                                reader("Username"),
                                reader("FullName"),
                                reader("Email"),
                                reader("Role"),
                                reader("BranchName"),
                                lastLogin,
                                reader("Status")
                            )
                            
                            totalUsers += 1
                            If CBool(reader("IsActive")) AndAlso Not CBool(reader("IsLocked")) Then
                                activeUsers += 1
                            Else
                                inactiveUsers += 1
                            End If
                        End While
                        
                        ' Update stats
                        lblTotalUsers.Text = $"Total: {totalUsers}"
                        lblActiveUsers.Text = $"Active: {activeUsers}"
                        lblInactiveUsers.Text = $"Inactive: {inactiveUsers}"
                    End Using
                End Using
            End Using
            
            ' Apply row styling
            ApplyRowStyling()
            
        Catch ex As Exception
            MessageBox.Show($"Error loading user data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ApplyRowStyling()
        For Each row As DataGridViewRow In dgvUsers.Rows
            Dim status As String = row.Cells("Status").Value.ToString()
            
            Select Case status
                Case "Active"
                    row.DefaultCellStyle.BackColor = Color.FromArgb(248, 255, 248)
                    row.DefaultCellStyle.ForeColor = Color.FromArgb(40, 167, 69)
                Case "Inactive"
                    row.DefaultCellStyle.BackColor = Color.FromArgb(255, 248, 248)
                    row.DefaultCellStyle.ForeColor = Color.FromArgb(220, 53, 69)
                Case "Locked"
                    row.DefaultCellStyle.BackColor = Color.FromArgb(255, 252, 230)
                    row.DefaultCellStyle.ForeColor = Color.FromArgb(255, 193, 7)
            End Select
        Next
    End Sub

    Private Sub FilterData(sender As Object, e As EventArgs)
        Dim searchText As String = txtSearch.Text.ToLower()
        Dim selectedBranch As String = If(cmbBranchFilter.SelectedIndex > 0, 
                                        CType(cmbBranchFilter.SelectedItem, ComboBoxItem).Text, "")
        Dim selectedRole As String = If(cmbRoleFilter.SelectedIndex > 0, cmbRoleFilter.SelectedItem.ToString(), "")
        Dim selectedStatus As String = If(cmbStatusFilter.SelectedIndex > 0, cmbStatusFilter.SelectedItem.ToString(), "")
        
        For Each row As DataGridViewRow In dgvUsers.Rows
            Dim visible As Boolean = True
            
            ' Search filter
            If Not String.IsNullOrEmpty(searchText) Then
                Dim username As String = row.Cells("Username").Value.ToString().ToLower()
                Dim fullName As String = row.Cells("FullName").Value.ToString().ToLower()
                Dim email As String = row.Cells("Email").Value.ToString().ToLower()
                
                visible = visible AndAlso (username.Contains(searchText) OrElse 
                                         fullName.Contains(searchText) OrElse 
                                         email.Contains(searchText))
            End If
            
            ' Branch filter
            If Not String.IsNullOrEmpty(selectedBranch) Then
                visible = visible AndAlso row.Cells("Branch").Value.ToString() = selectedBranch
            End If
            
            ' Role filter
            If Not String.IsNullOrEmpty(selectedRole) Then
                visible = visible AndAlso row.Cells("Role").Value.ToString() = selectedRole
            End If
            
            ' Status filter
            If Not String.IsNullOrEmpty(selectedStatus) Then
                visible = visible AndAlso row.Cells("Status").Value.ToString() = selectedStatus
            End If
            
            row.Visible = visible
        Next
    End Sub

    ' Button Event Handlers
    Private Sub btnAdd_Click(sender As Object, e As EventArgs) Handles btnAdd.Click
        If Not currentUser.HasPermission("UserManagement", "write") Then
            MessageBox.Show("You don't have permission to add users.", "Access Denied", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim addForm As New UserAddEditForm(currentUser, Nothing)
        If addForm.ShowDialog() = DialogResult.OK Then
            LoadData()
            auditLogger.LogEvent(currentUser.ID, "USER_ADDED", "Users", addForm.SavedUserId.ToString(), 
                               Nothing, Nothing, "New user added", "USER_MANAGEMENT")
        End If
    End Sub

    Private Sub btnEdit_Click(sender As Object, e As EventArgs) Handles btnEdit.Click
        If dgvUsers.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select a user to edit.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        If Not currentUser.HasPermission("UserManagement", "write") Then
            MessageBox.Show("You don't have permission to edit users.", "Access Denied", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim userId As Integer = CInt(dgvUsers.SelectedRows(0).Cells("ID").Value)
        Dim editForm As New UserAddEditForm(currentUser, userId)
        If editForm.ShowDialog() = DialogResult.OK Then
            LoadData()
            auditLogger.LogEvent(currentUser.ID, "USER_UPDATED", "Users", userId.ToString(), 
                               Nothing, Nothing, "User information updated", "USER_MANAGEMENT")
        End If
    End Sub

    Private Sub btnDelete_Click(sender As Object, e As EventArgs) Handles btnDelete.Click
        If dgvUsers.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select a user to delete.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        If Not currentUser.HasPermission("UserManagement", "delete") Then
            MessageBox.Show("You don't have permission to delete users.", "Access Denied", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim userId As Integer = CInt(dgvUsers.SelectedRows(0).Cells("ID").Value)
        Dim username As String = dgvUsers.SelectedRows(0).Cells("Username").Value.ToString()
        
        If MessageBox.Show($"Are you sure you want to delete user '{username}'?", "Confirm Delete", 
                          MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
            Try
                Using connection As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERP").ConnectionString)
                    connection.Open()
                    
                    Dim query As String = "UPDATE Users SET IsActive = 0 WHERE ID = @UserID"
                    Using command As New SqlCommand(query, connection)
                        command.Parameters.AddWithValue("@UserID", userId)
                        command.ExecuteNonQuery()
                    End Using
                End Using
                
                LoadData()
                auditLogger.LogEvent(currentUser.ID, "USER_DELETED", "Users", userId.ToString(), 
                                   Nothing, Nothing, $"User '{username}' deactivated", "USER_MANAGEMENT")
                
                MessageBox.Show("User has been deactivated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Catch ex As Exception
                MessageBox.Show($"Error deleting user: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

    Private Sub btnResetPassword_Click(sender As Object, e As EventArgs) Handles btnResetPassword.Click
        If dgvUsers.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select a user to reset password.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        If Not currentUser.HasPermission("UserManagement", "write") Then
            MessageBox.Show("You don't have permission to reset passwords.", "Access Denied", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim userId As Integer = CInt(dgvUsers.SelectedRows(0).Cells("ID").Value)
        Dim username As String = dgvUsers.SelectedRows(0).Cells("Username").Value.ToString()
        
        Dim resetForm As New PasswordResetForm(currentUser, userId, username)
        If resetForm.ShowDialog() = DialogResult.OK Then
            auditLogger.LogEvent(currentUser.ID, "PASSWORD_RESET", "Users", userId.ToString(), 
                               Nothing, Nothing, $"Password reset for user '{username}'", "USER_MANAGEMENT")
        End If
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Try
            Dim saveDialog As New SaveFileDialog()
            saveDialog.Filter = "CSV files (*.csv)|*.csv|Excel files (*.xlsx)|*.xlsx"
            saveDialog.FileName = $"Users_Export_{DateTime.Now:yyyyMMdd_HHmmss}"
            
            If saveDialog.ShowDialog() = DialogResult.OK Then
                ExportData(saveDialog.FileName)
                MessageBox.Show("Data exported successfully!", "Export Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error exporting data: {ex.Message}", "Export Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadData()
    End Sub

    Private Sub ExportData(fileName As String)
        ' Implementation for CSV/Excel export would go here
        ' For now, just create a simple CSV export
        Dim csv As New System.Text.StringBuilder()
        
        ' Add headers
        csv.AppendLine("Username,Full Name,Email,Role,Branch,Last Login,Status")
        
        ' Add data rows
        For Each row As DataGridViewRow In dgvUsers.Rows
            If row.Visible Then
                csv.AppendLine($"{row.Cells("Username").Value},{row.Cells("FullName").Value},{row.Cells("Email").Value},{row.Cells("Role").Value},{row.Cells("Branch").Value},{row.Cells("LastLogin").Value},{row.Cells("Status").Value}")
            End If
        Next
        
        System.IO.File.WriteAllText(fileName, csv.ToString())
    End Sub

    Private Sub dgvUsers_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvUsers.CellDoubleClick
        If e.RowIndex >= 0 Then
            btnEdit_Click(sender, e)
        End If
    End Sub
End Class

Public Class ComboBoxItem
    Public Property Text As String
    Public Property Value As Object
    
    Public Overrides Function ToString() As String
        Return Text
    End Function
End Class
