Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms

Public Class RoleAssignmentForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _userId As Integer
    Private ReadOnly _username As String

    Private ReadOnly lblUser As New Label()
    Private ReadOnly cboRole As New ComboBox()
    Private ReadOnly cboBranch As New ComboBox()
    Private ReadOnly btnAssign As New Button()
    Private ReadOnly btnCancel As New Button()

    Public Sub New(userId As Integer, username As String)
        _userId = userId
        _username = username
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        SetupUI()
        LoadRoles()
        LoadBranches()
        LoadCurrentAssignment()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Role Assignment"
        Me.Size = New Size(400, 250)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
    End Sub

    Private Sub SetupUI()
        Dim y = 20

        ' User info
        lblUser.Text = $"Assigning role for user: {_username}"
        lblUser.Font = New Font("Segoe UI", 9, FontStyle.Bold)
        lblUser.Location = New Point(20, y)
        lblUser.AutoSize = True
        Me.Controls.Add(lblUser)
        y += 40

        ' Role selection
        Dim lblRole As New Label()
        lblRole.Text = "Role:"
        lblRole.Location = New Point(20, y)
        lblRole.AutoSize = True
        Me.Controls.Add(lblRole)

        cboRole.Location = New Point(80, y)
        cboRole.Size = New Size(280, 20)
        cboRole.DropDownStyle = ComboBoxStyle.DropDownList
        Me.Controls.Add(cboRole)
        y += 40

        ' Branch selection
        Dim lblBranch As New Label()
        lblBranch.Text = "Branch:"
        lblBranch.Location = New Point(20, y)
        lblBranch.AutoSize = True
        Me.Controls.Add(lblBranch)

        cboBranch.Location = New Point(80, y)
        cboBranch.Size = New Size(280, 20)
        cboBranch.DropDownStyle = ComboBoxStyle.DropDownList
        Me.Controls.Add(cboBranch)
        y += 60

        ' Buttons
        btnAssign.Text = "Assign"
        btnAssign.Location = New Point(200, y)
        btnAssign.Size = New Size(75, 30)
        AddHandler btnAssign.Click, AddressOf OnAssign
        Me.Controls.Add(btnAssign)

        btnCancel.Text = "Cancel"
        btnCancel.Location = New Point(285, y)
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
                    cboRole.DataSource = dt
                    cboRole.DisplayMember = "RoleName"
                    cboRole.ValueMember = "RoleID"
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

    Private Sub LoadCurrentAssignment()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT RoleID, BranchID FROM Users WHERE UserID = @userId"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@userId", _userId)
                    conn.Open()
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            If Not IsDBNull(reader("RoleID")) Then
                                cboRole.SelectedValue = reader("RoleID")
                            End If
                            
                            If Not IsDBNull(reader("BranchID")) Then
                                cboBranch.SelectedValue = reader("BranchID")
                            Else
                                cboBranch.SelectedIndex = 0 ' No Branch option
                            End If
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading current assignment: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnAssign(sender As Object, e As EventArgs)
        Try
            If cboRole.SelectedValue Is Nothing Then
                MessageBox.Show("Please select a role.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Using conn As New SqlConnection(_connString)
                Dim sql = "UPDATE Users SET RoleID = @roleId, BranchID = @branchId WHERE UserID = @userId"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@roleId", cboRole.SelectedValue)
                    cmd.Parameters.AddWithValue("@branchId", If(cboBranch.SelectedValue Is DBNull.Value, DBNull.Value, cboBranch.SelectedValue))
                    cmd.Parameters.AddWithValue("@userId", _userId)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            MessageBox.Show("Role assigned successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Me.DialogResult = DialogResult.OK
            Me.Close()
        Catch ex As Exception
            MessageBox.Show($"Error assigning role: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnCancel(sender As Object, e As EventArgs)
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub
End Class
