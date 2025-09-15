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
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.Sizable
    End Sub

    Private Sub SetupUI()
        ' Users section
        lblUsers.Text = "System Users"
        lblUsers.Font = New Font("Segoe UI", 12, FontStyle.Bold)
        lblUsers.Location = New Point(20, 20)
        lblUsers.AutoSize = True

        dgvUsers.Location = New Point(20, 50)
        dgvUsers.Size = New Size(700, 300)
        dgvUsers.ReadOnly = True
        dgvUsers.AllowUserToAddRows = False
        dgvUsers.AllowUserToDeleteRows = False
        dgvUsers.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvUsers.MultiSelect = False
        dgvUsers.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill

        ' User management buttons
        btnAddUser.Text = "Add User"
        btnAddUser.Location = New Point(740, 50)
        btnAddUser.Size = New Size(100, 30)
        AddHandler btnAddUser.Click, AddressOf OnAddUser

        btnEditUser.Text = "Edit User"
        btnEditUser.Location = New Point(740, 90)
        btnEditUser.Size = New Size(100, 30)
        AddHandler btnEditUser.Click, AddressOf OnEditUser

        btnDeleteUser.Text = "Delete User"
        btnDeleteUser.Location = New Point(740, 130)
        btnDeleteUser.Size = New Size(100, 30)
        AddHandler btnDeleteUser.Click, AddressOf OnDeleteUser

        btnAssignRole.Text = "Assign Role"
        btnAssignRole.Location = New Point(740, 170)
        btnAssignRole.Size = New Size(100, 30)
        AddHandler btnAssignRole.Click, AddressOf OnAssignRole

        ' Roles section
        lblRoles.Text = "System Roles"
        lblRoles.Font = New Font("Segoe UI", 12, FontStyle.Bold)
        lblRoles.Location = New Point(20, 370)
        lblRoles.AutoSize = True

        dgvRoles.Location = New Point(20, 400)
        dgvRoles.Size = New Size(700, 200)
        dgvRoles.ReadOnly = True
        dgvRoles.AllowUserToAddRows = False
        dgvRoles.AllowUserToDeleteRows = False
        dgvRoles.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvRoles.MultiSelect = False
        dgvRoles.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill

        ' Close button
        btnClose.Text = "Close"
        btnClose.Location = New Point(740, 570)
        btnClose.Size = New Size(100, 30)
        AddHandler btnClose.Click, Sub() Me.Close()

        ' Add controls to form
        Me.Controls.AddRange({lblUsers, dgvUsers, btnAddUser, btnEditUser, btnDeleteUser, btnAssignRole,
                             lblRoles, dgvRoles, btnClose})
    End Sub

    Private Sub LoadUsers()
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return

            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT u.UserID, u.Username, u.Email, u.IsActive, " &
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
                Dim sql = "SELECT RoleID, RoleName, Description, IsActive FROM Roles ORDER BY RoleName"

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
