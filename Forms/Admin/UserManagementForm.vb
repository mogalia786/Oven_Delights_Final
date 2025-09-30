Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms

Public Class UserManagementForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly dgvUsers As New DataGridView()
    Private ReadOnly dgvRoles As New DataGridView()
    Private ReadOnly btnAddUser As New Button()
    Private ReadOnly btnEditUser As New Button()
    Private ReadOnly btnDeleteUser As New Button()
    Private ReadOnly btnAssignRole As New Button()
    Private ReadOnly btnClose As New Button()
    Private ReadOnly lblUsers As New Label()
    Private ReadOnly lblRoles As New Label()

    Public Sub New()
        InitializeComponent()
        InitializeFormProperties()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrWhiteSpace(_connString) Then
            MessageBox.Show("Missing connection string 'OvenDelightsERPConnectionString' in App.config.", "Config Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
        SetupUI()
        LoadUsers()
        LoadRoles()
    End Sub

    Private Sub InitializeFormProperties()
        Me.Text = "User Management"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.WindowState = FormWindowState.Maximized
        Me.BackColor = Color.FromArgb(248, 249, 250)
    End Sub

    Private Sub SetupUI()
        ' Users section
        lblUsers.Text = "Users"
        lblUsers.Font = New Font("Segoe UI", 14, FontStyle.Bold)
        lblUsers.ForeColor = Color.FromArgb(33, 37, 41)
        lblUsers.Location = New Point(30, 30)
        lblUsers.AutoSize = True

        dgvUsers.Location = New Point(30, 70)
        dgvUsers.Size = New Size(1120, 280)
        dgvUsers.AllowUserToAddRows = False
        dgvUsers.ReadOnly = True
        dgvUsers.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvUsers.BackgroundColor = Color.White
        dgvUsers.BorderStyle = BorderStyle.None
        dgvUsers.CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal
        dgvUsers.GridColor = Color.FromArgb(233, 236, 239)
        dgvUsers.DefaultCellStyle.BackColor = Color.White
        dgvUsers.DefaultCellStyle.ForeColor = Color.FromArgb(33, 37, 41)
        dgvUsers.DefaultCellStyle.SelectionBackColor = Color.FromArgb(0, 123, 255)
        dgvUsers.DefaultCellStyle.SelectionForeColor = Color.White
        dgvUsers.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(248, 249, 250)
        dgvUsers.ColumnHeadersDefaultCellStyle.ForeColor = Color.FromArgb(33, 37, 41)
        dgvUsers.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        dgvUsers.ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.Single
        dgvUsers.EnableHeadersVisualStyles = False

        ' Modern styled buttons
        btnAddUser.Text = "Add User"
        btnAddUser.Location = New Point(30, 370)
        btnAddUser.Size = New Size(120, 40)
        btnAddUser.BackColor = Color.FromArgb(40, 167, 69)
        btnAddUser.ForeColor = Color.White
        btnAddUser.FlatStyle = FlatStyle.Flat
        btnAddUser.FlatAppearance.BorderSize = 0
        btnAddUser.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        AddHandler btnAddUser.Click, AddressOf OnAddUser

        btnEditUser.Text = "Edit User"
        btnEditUser.Location = New Point(160, 370)
        btnEditUser.Size = New Size(120, 40)
        btnEditUser.BackColor = Color.FromArgb(0, 123, 255)
        btnEditUser.ForeColor = Color.White
        btnEditUser.FlatStyle = FlatStyle.Flat
        btnEditUser.FlatAppearance.BorderSize = 0
        btnEditUser.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        AddHandler btnEditUser.Click, AddressOf OnEditUser

        btnDeleteUser.Text = "Delete User"
        btnDeleteUser.Location = New Point(290, 370)
        btnDeleteUser.Size = New Size(120, 40)
        btnDeleteUser.BackColor = Color.FromArgb(220, 53, 69)
        btnDeleteUser.ForeColor = Color.White
        btnDeleteUser.FlatStyle = FlatStyle.Flat
        btnDeleteUser.FlatAppearance.BorderSize = 0
        btnDeleteUser.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        AddHandler btnDeleteUser.Click, AddressOf OnDeleteUser

        btnAssignRole.Text = "Assign Role"
        btnAssignRole.Location = New Point(420, 370)
        btnAssignRole.Size = New Size(120, 40)
        btnAssignRole.BackColor = Color.FromArgb(108, 117, 125)
        btnAssignRole.ForeColor = Color.White
        btnAssignRole.FlatStyle = FlatStyle.Flat
        btnAssignRole.FlatAppearance.BorderSize = 0
        btnAssignRole.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        AddHandler btnAssignRole.Click, AddressOf OnAssignRole

        ' Roles section
        lblRoles.Text = "Roles"
        lblRoles.Font = New Font("Segoe UI", 14, FontStyle.Bold)
        lblRoles.ForeColor = Color.FromArgb(33, 37, 41)
        lblRoles.Location = New Point(30, 430)
        lblRoles.AutoSize = True

        dgvRoles.Location = New Point(30, 470)
        dgvRoles.Size = New Size(1120, 200)
        dgvRoles.AllowUserToAddRows = False
        dgvRoles.ReadOnly = True
        dgvRoles.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvRoles.BackgroundColor = Color.White
        dgvRoles.BorderStyle = BorderStyle.None
        dgvRoles.CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal
        dgvRoles.GridColor = Color.FromArgb(233, 236, 239)
        dgvRoles.DefaultCellStyle.BackColor = Color.White
        dgvRoles.DefaultCellStyle.ForeColor = Color.FromArgb(33, 37, 41)
        dgvRoles.DefaultCellStyle.SelectionBackColor = Color.FromArgb(0, 123, 255)
        dgvRoles.DefaultCellStyle.SelectionForeColor = Color.White
        dgvRoles.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(248, 249, 250)
        dgvRoles.ColumnHeadersDefaultCellStyle.ForeColor = Color.FromArgb(33, 37, 41)
        dgvRoles.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        dgvRoles.ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.Single
        dgvRoles.EnableHeadersVisualStyles = False

        btnClose.Text = "Close"
        btnClose.Location = New Point(1050, 680)
        btnClose.Size = New Size(100, 40)
        btnClose.BackColor = Color.FromArgb(108, 117, 125)
        btnClose.ForeColor = Color.White
        btnClose.FlatStyle = FlatStyle.Flat
        btnClose.FlatAppearance.BorderSize = 0
        btnClose.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        AddHandler btnClose.Click, Sub() Me.Close()

        ' Add controls to form
        Me.Controls.AddRange({lblUsers, dgvUsers, btnAddUser, btnEditUser, btnDeleteUser, btnAssignRole,
                             lblRoles, dgvRoles, btnClose})
    End Sub

    Private Sub LoadUsers()
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return

            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT u.UserID, u.Username, u.Email, " &
                         "ISNULL(u.IsActive, 1) AS IsActive, " &
                         "r.RoleName, b.BranchName, u.CreatedDate " &
                         "FROM Users u " &
                         "LEFT JOIN Roles r ON r.RoleID = u.RoleID " &
                         "LEFT JOIN Branches b ON b.BranchID = u.BranchID " &
                         "ORDER BY u.Username"

                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvUsers.DataSource = dt

                    ' Hide UserID column
                    If dgvUsers.Columns.Contains("UserID") Then
                        dgvUsers.Columns("UserID").Visible = False
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading users: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadRoles()
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return

            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT RoleID, RoleName " &
                         "FROM Roles ORDER BY RoleName"

                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvRoles.DataSource = dt

                    ' Hide RoleID column
                    If dgvRoles.Columns.Contains("RoleID") Then
                        dgvRoles.Columns("RoleID").Visible = False
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading roles: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnAddUser(sender As Object, e As EventArgs)
        Try
            Using frm As New UserAddEditForm()
                If frm.ShowDialog(Me) = DialogResult.OK Then
                    LoadUsers()
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error opening Add User form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnEditUser(sender As Object, e As EventArgs)
        Try
            If dgvUsers.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a user to edit.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim userId = Convert.ToInt32(dgvUsers.SelectedRows(0).Cells("UserID").Value)
            Using frm As New UserAddEditForm(userId)
                If frm.ShowDialog(Me) = DialogResult.OK Then
                    LoadUsers()
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error opening Edit User form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnDeleteUser(sender As Object, e As EventArgs)
        Try
            If dgvUsers.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a user to delete.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim username = dgvUsers.SelectedRows(0).Cells("Username").Value.ToString()
            Dim result = MessageBox.Show($"Are you sure you want to delete user '{username}'?", 
                                       "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            
            If result = DialogResult.Yes Then
                Dim userId = Convert.ToInt32(dgvUsers.SelectedRows(0).Cells("UserID").Value)
                DeleteUser(userId)
                LoadUsers()
            End If
        Catch ex As Exception
            MessageBox.Show($"Error deleting user: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnAssignRole(sender As Object, e As EventArgs)
        Try
            If dgvUsers.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a user to assign a role.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim userId = Convert.ToInt32(dgvUsers.SelectedRows(0).Cells("UserID").Value)
            Dim username = dgvUsers.SelectedRows(0).Cells("Username").Value.ToString()
            
            Using frm As New RoleAssignmentForm(userId, username)
                If frm.ShowDialog(Me) = DialogResult.OK Then
                    LoadUsers()
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error opening Role Assignment form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub DeleteUser(userId As Integer)
        Using conn As New SqlConnection(_connString)
            conn.Open()
            Using cmd As New SqlCommand("UPDATE Users SET IsActive = 0 WHERE UserID = @userId", conn)
                cmd.Parameters.AddWithValue("@userId", userId)
                cmd.ExecuteNonQuery()
            End Using
        End Using
        MessageBox.Show("User deactivated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub
End Class
