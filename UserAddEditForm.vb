Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Partial Class UserAddEditForm
    Inherits Form

    Private userService As New UserService()
    Private userID As Integer?
    Private isEditMode As Boolean = False

    Public Sub New()
        InitializeComponent()
        isEditMode = False
        Me.Text = "Add New User"
        LoadBranches()
        LoadRoles()
    End Sub

    Public Sub New(userID As Integer)
        InitializeComponent()
        Me.userID = userID
        isEditMode = True
        Me.Text = "Edit User"
        LoadBranches()
        LoadRoles()
        LoadUserData()
    End Sub

    Private Sub LoadBranches()
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            Try
                conn.Open()
                ' Standardized schema: BranchID exists; Branches has no IsActive filter
                Dim sql As String = "SELECT BranchID, BranchName FROM Branches ORDER BY BranchName"
                Dim cmd As New SqlCommand(sql, conn)
                cmd.CommandType = CommandType.Text
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)

                Dim emptyRow As DataRow = dt.NewRow()
                emptyRow("BranchID") = DBNull.Value
                emptyRow("BranchName") = "-- Select Branch --"
                dt.Rows.InsertAt(emptyRow, 0)

                cboBranch.DataSource = dt
                cboBranch.DisplayMember = "BranchName"
                cboBranch.ValueMember = "BranchID"
            Catch ex As Exception
                MessageBox.Show("Error loading branches: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
    End Sub

    Private Sub LoadRoles()
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            Try
                conn.Open()
                ' Roles table does not have IsActive in our schema; load all
                Dim query As String = "SELECT RoleID, RoleName FROM Roles ORDER BY RoleName"
                
                Dim cmd As New SqlCommand(query, conn)
                cmd.CommandType = CommandType.Text
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)
                
                ' Add default empty item
                Dim emptyRow As DataRow = dt.NewRow()
                emptyRow("RoleID") = DBNull.Value
                emptyRow("RoleName") = "-- Select Role --"
                dt.Rows.InsertAt(emptyRow, 0)
                
                cboRole.DataSource = dt
                cboRole.DisplayMember = "RoleName"
                cboRole.ValueMember = "RoleID"
                
                ' Leave at placeholder by default; user must choose explicitly
            Catch ex As Exception
                MessageBox.Show($"Error loading roles: {ex.Message}", "Database Error", 
                             MessageBoxButtons.OK, MessageBoxIcon.Error)
                ' Avoid closing the form here to prevent disposed object issues; let user retry or cancel
                Return
            End Try
        End Using
    End Sub

    Private Sub LoadUserData()
        If Not userID.HasValue Then Return
        
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            Try
                conn.Open()
                
                ' Direct SQL query to get user data (explicit CommandType.Text and single-line string)
                Dim query As String = "SELECT UserID, Username, Email, FirstName, LastName, RoleID, BranchID, IsActive, TwoFactorEnabled FROM Users WHERE UserID = @UserID"
                
                Using cmd As New SqlCommand(query, conn)
                    cmd.CommandType = CommandType.Text
                    cmd.Parameters.AddWithValue("@UserID", userID.Value)
                    
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            txtUsername.Text = reader("Username").ToString()
                            txtEmail.Text = reader("Email").ToString()
                            txtFirstName.Text = reader("FirstName").ToString()
                            txtLastName.Text = reader("LastName").ToString()
                            
                            ' Handle Role selection
                            If Not IsDBNull(reader("RoleID")) Then
                                cboRole.SelectedValue = reader("RoleID")
                            End If
                            
                            ' Handle Branch selection
                            If Not IsDBNull(reader("BranchID")) Then
                                cboBranch.SelectedValue = reader("BranchID")
                            End If
                            
                            ' Handle IsActive and TwoFactorEnabled
                            chkIsActive.Checked = Convert.ToBoolean(reader("IsActive"))
                            chkTwoFactorEnabled.Checked = Convert.ToBoolean(reader("TwoFactorEnabled"))
                            
                            ' Disable username editing in edit mode
                            txtUsername.Enabled = False
                            
                            ' Hide password fields in edit mode (unless implementing password reset)
                            lblPassword.Visible = False
                            txtPassword.Visible = False
                            lblConfirmPassword.Visible = False
                            txtConfirmPassword.Visible = False
                        Else
                            MessageBox.Show("User not found.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                            Me.DialogResult = DialogResult.Abort
                            Me.Close()
                        End If
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading user data: {ex.Message}", "Database Error", 
                             MessageBoxButtons.OK, MessageBoxIcon.Error)
                Me.DialogResult = DialogResult.Abort
                Me.Close()
            End Try
        End Using
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If Not ValidateForm() Then Return
        
        ' Get selected values with proper null handling
        Dim roleID As Integer
        If cboRole.SelectedValue IsNot Nothing AndAlso Not IsDBNull(cboRole.SelectedValue) AndAlso cboRole.SelectedValue IsNot Nothing Then
            roleID = Convert.ToInt32(cboRole.SelectedValue)
        Else
            MessageBox.Show("Please select a valid role.", "Validation Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Warning)
            cboRole.Focus()
            Return
        End If
        
        ' Handle BranchID (can be null)
        Dim branchID As Integer? = Nothing
        If cboBranch.SelectedValue IsNot Nothing AndAlso Not IsDBNull(cboBranch.SelectedValue) Then
            branchID = Convert.ToInt32(cboBranch.SelectedValue)
        End If
        
        ' Get form values
        Dim username As String = txtUsername.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()
        Dim firstName As String = txtFirstName.Text.Trim()
        Dim lastName As String = txtLastName.Text.Trim()
        Dim isActive As Boolean = chkIsActive.Checked
        
        Try
            If isEditMode Then
                ' Update existing user
                If userService.UpdateUserInline(userID.Value, username, email, firstName, lastName, 
                                       roleID, branchID, isActive, chkTwoFactorEnabled.Checked) Then
                    MessageBox.Show("User updated successfully!", "Success", 
                                  MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.DialogResult = DialogResult.OK
                    Me.Close()
                End If
            Else
                ' Create new user
                Dim password As String = txtPassword.Text
                
                ' Additional validation for new users
                If String.IsNullOrWhiteSpace(password) Then
                    MessageBox.Show("Password is required for new users.", "Validation Error", 
                                 MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtPassword.Focus()
                    Return
                End If
                
                If password.Length < 8 Then
                    MessageBox.Show("Password must be at least 8 characters long.", "Validation Error", 
                                 MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtPassword.Focus()
                    Return
                End If
                
                If userService.CreateUserInline(username, password, email, firstName, lastName, roleID, branchID, isActive, chkTwoFactorEnabled.Checked) Then
                    MessageBox.Show("User created successfully!", "Success", 
                                  MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.DialogResult = DialogResult.OK
                    Me.Close()
                End If
            End If
        Catch ex As Microsoft.Data.SqlClient.SqlException
            ' SQL unique constraint violations
            If ex.Number = 2601 OrElse ex.Number = 2627 Then
                ' Try to infer which field from message; default to email
                Dim msg = ex.Message
                If msg.IndexOf("username", StringComparison.OrdinalIgnoreCase) >= 0 Then
                    MessageBox.Show("A user with this username already exists. Please choose a different username.", "Duplicate Username", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtUsername.Focus()
                Else
                    MessageBox.Show("A user with this email already exists. Please use a different email.", "Duplicate Email", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtEmail.Focus()
                End If
            Else
                MessageBox.Show($"Database error while saving user: {ex.Message}", "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
        Catch ex As InvalidOperationException
            ' Friendly message for duplicate username/email (thrown by service on 2601/2627 or custom 50002)
            Dim msg = ex.Message
            If msg.IndexOf("email", StringComparison.OrdinalIgnoreCase) >= 0 Then
                MessageBox.Show("A user with this email already exists. Please use a different email.", "Duplicate Email", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtEmail.Focus()
            ElseIf msg.IndexOf("username", StringComparison.OrdinalIgnoreCase) >= 0 Then
                MessageBox.Show("A user with this username already exists. Please choose a different username.", "Duplicate Username", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtUsername.Focus()
            Else
                MessageBox.Show(msg, "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End If
        Catch ex As Exception
            ' Generic fallback
            MessageBox.Show($"Error saving user: {ex.Message}", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function ValidateForm() As Boolean
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

        ' Normalize common variations to '@' and strip spaces to reduce user input friction.
        Dim normalizedEmail As String = txtEmail.Text.Trim()
        normalizedEmail = normalizedEmail.Replace("(at)", "@").Replace("[at]", "@").Replace(" at ", "@")
        normalizedEmail = normalizedEmail.Replace(" AT ", "@").Replace(" At ", "@").Replace(" a t ", "@")
        normalizedEmail = normalizedEmail.Replace(" ", "")
        If Not String.Equals(txtEmail.Text, normalizedEmail, StringComparison.Ordinal) Then
            txtEmail.Text = normalizedEmail
        End If

        ' Email format relaxed per request: only require an '@' character to be present.
        If Not txtEmail.Text.Contains("@") Then
            MessageBox.Show("Email must contain '@'.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtEmail.Focus()
            Return False
        End If

        If String.IsNullOrWhiteSpace(txtFirstName.Text) Then
            MessageBox.Show("First Name is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtFirstName.Focus()
            Return False
        End If

        
        If Not isEditMode AndAlso String.IsNullOrWhiteSpace(txtPassword.Text) Then
            MessageBox.Show("Password is required for new users.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtPassword.Focus()
            Return False
        End If

        ' Validate role selection using SelectedValue to avoid placeholder/null
        If cboRole.SelectedValue Is Nothing OrElse IsDBNull(cboRole.SelectedValue) Then
            MessageBox.Show("Please select a role.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            cboRole.Focus()
            Return False
        End If

        Return True
    End Function

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub
End Class
