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
                Dim cmd As New SqlCommand("SELECT ID, Name FROM Branches WHERE IsActive = 1", conn)
                Dim adapter As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                adapter.Fill(dt)
                
                Dim emptyRow As DataRow = dt.NewRow()
                emptyRow("ID") = DBNull.Value
                emptyRow("Name") = "-- Select Branch --"
                dt.Rows.InsertAt(emptyRow, 0)
                
                cboBranch.DataSource = dt
                cboBranch.DisplayMember = "Name"
                cboBranch.ValueMember = "ID"
            Catch ex As Exception
                MessageBox.Show("Error loading branches: " & ex.Message)
            End Try
        End Using
    End Sub

    Private Sub LoadRoles()
        cboRole.Items.Clear()
        cboRole.Items.Add("SuperAdmin")
        cboRole.Items.Add("BranchAdmin")
        cboRole.Items.Add("User")
        cboRole.SelectedIndex = 2 ' Default to "User"
    End Sub

    Private Sub LoadUserData()
        If userID.HasValue Then
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                Try
                    conn.Open()
                    Dim cmd As New SqlCommand("SELECT Username, Email, FirstName, LastName, Role, BranchID, IsActive FROM Users WHERE ID = @userID", conn)
                    cmd.Parameters.AddWithValue("@userID", userID.Value)
                    Dim reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtUsername.Text = reader("Username").ToString()
                        txtEmail.Text = reader("Email").ToString()
                        txtFirstName.Text = reader("FirstName").ToString()
                        txtLastName.Text = reader("LastName").ToString()
                        cboRole.Text = reader("Role").ToString()
                        If Not IsDBNull(reader("BranchID")) Then
                            cboBranch.SelectedValue = reader("BranchID")
                        End If
                        chkIsActive.Checked = Convert.ToBoolean(reader("IsActive"))
                    End If
                    reader.Close()
                Catch ex As Exception
                    MessageBox.Show("Error loading user data: " & ex.Message)
                End Try
            End Using
        End If
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If ValidateForm() Then
            Dim branchID As Integer? = Nothing
            If cboBranch.SelectedValue IsNot Nothing AndAlso Not IsDBNull(cboBranch.SelectedValue) Then
                branchID = Convert.ToInt32(cboBranch.SelectedValue)
            End If

            If isEditMode Then
                If userService.UpdateUser(userID.Value, txtUsername.Text.Trim(), txtEmail.Text.Trim(), txtFirstName.Text.Trim(), txtLastName.Text.Trim(), cboRole.Text, branchID, chkIsActive.Checked) Then
                    MessageBox.Show("User updated successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.DialogResult = DialogResult.OK
                    Me.Close()
                End If
            Else
                If userService.CreateUser(txtUsername.Text.Trim(), txtPassword.Text, txtEmail.Text.Trim(), txtFirstName.Text.Trim(), txtLastName.Text.Trim(), cboRole.Text, branchID) Then
                    MessageBox.Show("User created successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.DialogResult = DialogResult.OK
                    Me.Close()
                End If
            End If
        End If
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

        If String.IsNullOrWhiteSpace(txtFirstName.Text) Then
            MessageBox.Show("First Name is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtFirstName.Focus()
            Return False
        End If

        If String.IsNullOrWhiteSpace(txtLastName.Text) Then
            MessageBox.Show("Last Name is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtLastName.Focus()
            Return False
        End If

        If Not isEditMode AndAlso String.IsNullOrWhiteSpace(txtPassword.Text) Then
            MessageBox.Show("Password is required for new users.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtPassword.Focus()
            Return False
        End If

        If cboRole.SelectedIndex = -1 Then
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
