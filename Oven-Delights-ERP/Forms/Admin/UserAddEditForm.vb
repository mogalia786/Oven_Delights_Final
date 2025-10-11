Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms

Public Class UserAddEditForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _userId As Integer?
    Private ReadOnly _isEditMode As Boolean

    Private ReadOnly txtUsername As New TextBox()
    Private ReadOnly txtEmail As New TextBox()
    Private ReadOnly txtPassword As New TextBox()
    Private ReadOnly cboRole As New ComboBox()
    Private ReadOnly cboBranch As New ComboBox()
    Private ReadOnly chkIsActive As New CheckBox()
    Private ReadOnly btnSave As New Button()
    Private ReadOnly btnCancel As New Button()

    Public Sub New(Optional userId As Integer? = Nothing)
        _userId = userId
        _isEditMode = userId.HasValue
        InitializeComponent()
        InitializeFormProperties()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        SetupUI()
        LoadRoles()
        LoadBranches()
        If _isEditMode Then LoadUserData()
    End Sub

    Private Sub InitializeFormProperties()
        Me.Text = If(_isEditMode, "Edit User", "Add User")
        Me.Size = New Size(450, 400)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
    End Sub

    Private Sub SetupUI()
        Dim y = 20

        ' Username
        Dim lblUsername As New Label()
        lblUsername.Text = "Username:"
        lblUsername.Location = New Point(20, y)
        lblUsername.AutoSize = True
        Me.Controls.Add(lblUsername)

        txtUsername.Location = New Point(120, y)
        txtUsername.Size = New Size(280, 20)
        Me.Controls.Add(txtUsername)
        y += 40

        ' Email
        Dim lblEmail As New Label()
        lblEmail.Text = "Email:"
        lblEmail.Location = New Point(20, y)
        lblEmail.AutoSize = True
        Me.Controls.Add(lblEmail)

        txtEmail.Location = New Point(120, y)
        txtEmail.Size = New Size(280, 20)
        Me.Controls.Add(txtEmail)
        y += 40

        ' Password
        Dim lblPassword As New Label()
        lblPassword.Text = If(_isEditMode, "New Password:", "Password:")
        lblPassword.Location = New Point(20, y)
        lblPassword.AutoSize = True
        Me.Controls.Add(lblPassword)

        txtPassword.Location = New Point(120, y)
        txtPassword.Size = New Size(280, 20)
        txtPassword.PasswordChar = "*"c
        Me.Controls.Add(txtPassword)
        y += 40

        ' Role
        Dim lblRole As New Label()
        lblRole.Text = "Role:"
        lblRole.Location = New Point(20, y)
        lblRole.AutoSize = True
        Me.Controls.Add(lblRole)

        cboRole.Location = New Point(120, y)
        cboRole.Size = New Size(280, 20)
        cboRole.DropDownStyle = ComboBoxStyle.DropDownList
        Me.Controls.Add(cboRole)
        y += 40

        ' Branch
        Dim lblBranch As New Label()
        lblBranch.Text = "Branch:"
        lblBranch.Location = New Point(20, y)
        lblBranch.AutoSize = True
        Me.Controls.Add(lblBranch)

        cboBranch.Location = New Point(120, y)
        cboBranch.Size = New Size(280, 20)
        cboBranch.DropDownStyle = ComboBoxStyle.DropDownList
        Me.Controls.Add(cboBranch)
        y += 40

        ' Is Active
        chkIsActive.Text = "Active"
        chkIsActive.Location = New Point(120, y)
        chkIsActive.Checked = True
        Me.Controls.Add(chkIsActive)
        y += 40

        ' Buttons
        btnSave.Text = "Save"
        btnSave.Location = New Point(240, y + 20)
        btnSave.Size = New Size(75, 30)
        AddHandler btnSave.Click, AddressOf OnSave
        Me.Controls.Add(btnSave)

        btnCancel.Text = "Cancel"
        btnCancel.Location = New Point(325, y + 20)
        btnCancel.Size = New Size(75, 30)
        AddHandler btnCancel.Click, AddressOf OnCancel
        Me.Controls.Add(btnCancel)
    End Sub

    Private Sub LoadRoles()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT RoleID, RoleName FROM Roles ORDER BY RoleName"
                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    
                    ' Add default "Select Role" option
                    Dim defaultRow = dt.NewRow()
                    defaultRow("RoleID") = DBNull.Value
                    defaultRow("RoleName") = "-- Select Role --"
                    dt.Rows.InsertAt(defaultRow, 0)
                    
                    cboRole.DataSource = dt
                    cboRole.DisplayMember = "RoleName"
                    cboRole.ValueMember = "RoleID"
                    cboRole.SelectedIndex = 0
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading roles: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadBranches()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT BranchID, BranchName FROM Branches ORDER BY BranchName"
                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    
                    ' Add "No Branch" option
                    Dim noBranchRow = dt.NewRow()
                    noBranchRow("BranchID") = DBNull.Value
                    noBranchRow("BranchName") = "(No Branch)"
                    dt.Rows.InsertAt(noBranchRow, 0)
                    
                    cboBranch.DataSource = dt
                    cboBranch.DisplayMember = "BranchName"
                    cboBranch.ValueMember = "BranchID"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadUserData()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT Username, Email, RoleID, BranchID, IsActive FROM Users WHERE UserID = @userId"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@userId", _userId.Value)
                    conn.Open()
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            txtUsername.Text = reader("Username").ToString()
                            txtEmail.Text = reader("Email").ToString()
                            
                            If Not IsDBNull(reader("RoleID")) Then
                                cboRole.SelectedValue = reader("RoleID")
                            End If
                            
                            If Not IsDBNull(reader("BranchID")) Then
                                cboBranch.SelectedValue = reader("BranchID")
                            Else
                                cboBranch.SelectedIndex = 0 ' No Branch option
                            End If
                            
                            chkIsActive.Checked = Convert.ToBoolean(reader("IsActive"))
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading user data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnSave(sender As Object, e As EventArgs)
        Try
            If Not ValidateInput() Then Return

            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                If _isEditMode Then
                    UpdateUser(conn)
                Else
                    CreateUser(conn)
                End If
                
                Me.DialogResult = DialogResult.OK
                Me.Close()
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error saving user: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnCancel(sender As Object, e As EventArgs)
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub

    Private Function ValidateInput() As Boolean
        If String.IsNullOrWhiteSpace(txtUsername.Text) Then
            MessageBox.Show("Username is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtUsername.Focus()
            Return False
        End If

        If String.IsNullOrWhiteSpace(txtEmail.Text) Then
            MessageBox.Show("Email is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtEmail.Focus()
            Return False
        End If

        If Not _isEditMode AndAlso String.IsNullOrWhiteSpace(txtPassword.Text) Then
            MessageBox.Show("Password is required for new users.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtPassword.Focus()
            Return False
        End If

        If cboRole.SelectedValue Is Nothing Then
            MessageBox.Show("Please select a role.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            cboRole.Focus()
            Return False
        End If

        Return True
    End Function

    Private Sub CreateUser(conn As SqlConnection)
        Dim sql = "INSERT INTO Users (Username, Email, Password, RoleID, BranchID, IsActive, CreatedDate, FirstName, LastName) " &
                 "VALUES (@username, @email, @password, @roleId, @branchId, @isActive, GETDATE(), @firstName, @lastName)"
        
        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@username", txtUsername.Text.Trim())
            cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim())
            cmd.Parameters.AddWithValue("@password", HashPassword(txtPassword.Text))
            cmd.Parameters.AddWithValue("@roleId", cboRole.SelectedValue)
            cmd.Parameters.AddWithValue("@branchId", If(cboBranch.SelectedValue Is DBNull.Value, DBNull.Value, cboBranch.SelectedValue))
            cmd.Parameters.AddWithValue("@isActive", chkIsActive.Checked)
            cmd.Parameters.AddWithValue("@firstName", txtUsername.Text.Trim()) ' Use username as firstname for now
            cmd.Parameters.AddWithValue("@lastName", txtUsername.Text.Trim()) ' Use username as lastname for now
            cmd.ExecuteNonQuery()
        End Using
        
        MessageBox.Show("User created successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub UpdateUser(conn As SqlConnection)
        Dim sql = "UPDATE Users SET Username = @username, Email = @email, RoleID = @roleId, " &
                 "BranchID = @branchId, IsActive = @isActive"
        
        If Not String.IsNullOrWhiteSpace(txtPassword.Text) Then
            sql &= ", Password = @password"
        End If
        
        sql &= " WHERE UserID = @userId"
        
        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@username", txtUsername.Text.Trim())
            cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim())
            cmd.Parameters.AddWithValue("@roleId", cboRole.SelectedValue)
            cmd.Parameters.AddWithValue("@branchId", If(cboBranch.SelectedValue Is DBNull.Value, DBNull.Value, cboBranch.SelectedValue))
            cmd.Parameters.AddWithValue("@isActive", chkIsActive.Checked)
            cmd.Parameters.AddWithValue("@userId", _userId.Value)
            
            If Not String.IsNullOrWhiteSpace(txtPassword.Text) Then
                cmd.Parameters.AddWithValue("@password", HashPassword(txtPassword.Text))
            End If
            
            cmd.ExecuteNonQuery()
        End Using
        
        MessageBox.Show("User updated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Function HashPassword(password As String) As String
        ' Simple hash for demo - in production use proper password hashing
        Using sha256 = System.Security.Cryptography.SHA256.Create()
            Dim hashedBytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password))
            Return Convert.ToBase64String(hashedBytes)
        End Using
    End Function
End Class
