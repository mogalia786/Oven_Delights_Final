Imports System
Imports System.Data
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient

Public Class StaffAddEditForm
    Inherits Form

    Public Property Saved As Boolean = False
    Public Property EditedUserId As Integer = 0 ' 0 = new

    Private ReadOnly txtUsername As New TextBox()
    Private ReadOnly txtFirstName As New TextBox()
    Private ReadOnly txtLastName As New TextBox()
    Private ReadOnly cboRole As New ComboBox() With {.DropDownStyle = ComboBoxStyle.DropDownList}
    Private ReadOnly cboBranch As New ComboBox() With {.DropDownStyle = ComboBoxStyle.DropDownList}
    Private ReadOnly chkActive As New CheckBox() With {.Text = "Active", .Checked = True}

    Private ReadOnly btnSave As New Button() With {.Text = "Save"}
    Private ReadOnly btnCancel As New Button() With {.Text = "Cancel"}

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Public Sub New(Optional userId As Integer = 0)
        Me.EditedUserId = userId
        Me.Text = If(userId = 0, "Add Staff", "Edit Staff")
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.StartPosition = FormStartPosition.CenterParent
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Size = New Size(520, 360)

        ' Styling
        Me.BackColor = Color.FromArgb(247, 249, 252)
        Me.Padding = New Padding(16)

        btnSave.BackColor = Color.FromArgb(0, 120, 215)
        btnSave.ForeColor = Color.White
        btnSave.FlatStyle = FlatStyle.Flat
        btnSave.FlatAppearance.BorderSize = 0

        btnCancel.BackColor = Color.FromArgb(220, 53, 69)
        btnCancel.ForeColor = Color.White
        btnCancel.FlatStyle = FlatStyle.Flat
        btnCancel.FlatAppearance.BorderSize = 0

        Dim layout As New TableLayoutPanel() With {
            .Dock = DockStyle.Fill,
            .ColumnCount = 2,
            .RowCount = 7,
            .Padding = New Padding(8)
        }
        layout.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 35))
        layout.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 65))
        For i = 0 To 5
            layout.RowStyles.Add(New RowStyle(SizeType.Absolute, 40))
        Next
        layout.RowStyles.Add(New RowStyle(SizeType.AutoSize))

        layout.Controls.Add(New Label() With {.Text = "Username:", .AutoSize = True, .Margin = New Padding(0, 10, 0, 0)}, 0, 0)
        layout.Controls.Add(txtUsername, 1, 0)

        layout.Controls.Add(New Label() With {.Text = "First name:", .AutoSize = True, .Margin = New Padding(0, 10, 0, 0)}, 0, 1)
        layout.Controls.Add(txtFirstName, 1, 1)

        layout.Controls.Add(New Label() With {.Text = "Last name:", .AutoSize = True, .Margin = New Padding(0, 10, 0, 0)}, 0, 2)
        layout.Controls.Add(txtLastName, 1, 2)

        layout.Controls.Add(New Label() With {.Text = "Role:", .AutoSize = True, .Margin = New Padding(0, 10, 0, 0)}, 0, 3)
        layout.Controls.Add(cboRole, 1, 3)

        layout.Controls.Add(New Label() With {.Text = "Branch:", .AutoSize = True, .Margin = New Padding(0, 10, 0, 0)}, 0, 4)
        layout.Controls.Add(cboBranch, 1, 4)

        layout.Controls.Add(chkActive, 1, 5)

        Dim btnPanel As New FlowLayoutPanel() With {.Dock = DockStyle.Fill, .FlowDirection = FlowDirection.RightToLeft}
        btnPanel.Controls.Add(btnCancel)
        btnPanel.Controls.Add(btnSave)
        layout.Controls.Add(btnPanel, 0, 6)
        layout.SetColumnSpan(btnPanel, 2)

        Controls.Add(layout)

        AddHandler btnCancel.Click, Sub() Me.Close()
        AddHandler btnSave.Click, AddressOf OnSave

        LoadRoles()
        LoadBranches()
        If EditedUserId > 0 Then LoadUser()
    End Sub

    Private Sub LoadRoles()
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using cmd As New SqlCommand("SELECT RoleID, RoleName FROM Roles ORDER BY RoleName", con)
                Dim dt As New DataTable()
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
                cboRole.DisplayMember = "RoleName"
                cboRole.ValueMember = "RoleID"
                cboRole.DataSource = dt
            End Using
        End Using
    End Sub

    Private Sub LoadBranches()
        Try
            Dim bs As New BranchService()
            Dim dt As DataTable = bs.GetAllBranches()
            cboBranch.DisplayMember = "BranchName"
            cboBranch.ValueMember = "ID"
            cboBranch.DataSource = dt
            cboBranch.SelectedIndex = -1
        Catch
            ' ignore
        End Try
    End Sub

    Private Sub LoadUser()
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using cmd As New SqlCommand("SELECT Username, FirstName, LastName, RoleID, BranchID, IsActive FROM Users WHERE UserID=@id", con)
                cmd.Parameters.AddWithValue("@id", EditedUserId)
                Using r = cmd.ExecuteReader()
                    If r.Read() Then
                        txtUsername.Text = If(r("Username") Is DBNull.Value, "", r("Username").ToString())
                        txtFirstName.Text = If(r("FirstName") Is DBNull.Value, "", r("FirstName").ToString())
                        txtLastName.Text = If(r("LastName") Is DBNull.Value, "", r("LastName").ToString())
                        If Not IsDBNull(r("RoleID")) Then cboRole.SelectedValue = CInt(r("RoleID"))
                        If Not IsDBNull(r("BranchID")) Then cboBranch.SelectedValue = CInt(r("BranchID"))
                        chkActive.Checked = If(IsDBNull(r("IsActive")), True, CBool(r("IsActive")))
                    End If
                End Using
            End Using
        End Using
        ' Username typically immutable on edit
        If EditedUserId > 0 Then txtUsername.Enabled = False
    End Sub

    Private Sub OnSave(sender As Object, e As EventArgs)
        Try
            Dim username = txtUsername.Text.Trim()
            Dim firstName = txtFirstName.Text.Trim()
            Dim lastName = txtLastName.Text.Trim()
            Dim roleId As Integer = If(cboRole.SelectedItem Is Nothing, 0, CInt(DirectCast(cboRole.SelectedItem, DataRowView).Row("RoleID")))
            Dim branchId As Object = If(cboBranch.SelectedItem Is Nothing, DBNull.Value, CObj(CInt(DirectCast(cboBranch.SelectedItem, DataRowView).Row("ID"))))
            Dim isActive = chkActive.Checked

            If EditedUserId = 0 AndAlso String.IsNullOrWhiteSpace(username) Then
                MessageBox.Show("Username is required.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            If roleId = 0 Then
                MessageBox.Show("Please select a role.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Using con As New SqlConnection(connectionString)
                con.Open()
                If EditedUserId = 0 Then
                    ' Insert
                    Using cmd As New SqlCommand("INSERT INTO Users (Username, FirstName, LastName, RoleID, BranchID, IsActive, CreatedDate) VALUES (@u,@f,@l,@r,@b,@a,GETDATE())", con)
                        cmd.Parameters.AddWithValue("@u", username)
                        cmd.Parameters.AddWithValue("@f", If(String.IsNullOrWhiteSpace(firstName), DBNull.Value, CObj(firstName)))
                        cmd.Parameters.AddWithValue("@l", If(String.IsNullOrWhiteSpace(lastName), DBNull.Value, CObj(lastName)))
                        cmd.Parameters.AddWithValue("@r", roleId)
                        cmd.Parameters.AddWithValue("@b", branchId)
                        cmd.Parameters.AddWithValue("@a", isActive)
                        cmd.ExecuteNonQuery()
                    End Using
                Else
                    ' Update
                    Using cmd As New SqlCommand("UPDATE Users SET FirstName=@f, LastName=@l, RoleID=@r, BranchID=@b, IsActive=@a, ModifiedDate=GETDATE() WHERE UserID=@id", con)
                        cmd.Parameters.AddWithValue("@id", EditedUserId)
                        cmd.Parameters.AddWithValue("@f", If(String.IsNullOrWhiteSpace(firstName), DBNull.Value, CObj(firstName)))
                        cmd.Parameters.AddWithValue("@l", If(String.IsNullOrWhiteSpace(lastName), DBNull.Value, CObj(lastName)))
                        cmd.Parameters.AddWithValue("@r", roleId)
                        cmd.Parameters.AddWithValue("@b", branchId)
                        cmd.Parameters.AddWithValue("@a", isActive)
                        cmd.ExecuteNonQuery()
                    End Using
                End If
            End Using

            Me.Saved = True
            Me.DialogResult = DialogResult.OK
            Me.Close()
        Catch ex As Exception
            MessageBox.Show("Save error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
