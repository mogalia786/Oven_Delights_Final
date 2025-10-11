Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class StaffManagementForm
    Inherits Form

    Private ReadOnly grdStaff As New DataGridView() With {.Dock = DockStyle.Fill, .AllowUserToAddRows = False, .ReadOnly = True, .SelectionMode = DataGridViewSelectionMode.FullRowSelect}
    Private ReadOnly btnAdd As New Button() With {.Text = "Add"}
    Private ReadOnly btnEdit As New Button() With {.Text = "Edit"}
    Private ReadOnly btnDelete As New Button() With {.Text = "Delete"}
    Private ReadOnly btnClose As New Button() With {.Text = "Close"}

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Public Sub New()
        Me.Text = "Staff Management"
        Me.Width = 1000
        Me.Height = 650
        Me.BackColor = Color.White
        Me.FormBorderStyle = FormBorderStyle.FixedSingle

        ' Button styling
        btnAdd.BackColor = Color.FromArgb(0, 120, 215)
        btnAdd.ForeColor = Color.White
        btnAdd.FlatStyle = FlatStyle.Flat
        btnAdd.FlatAppearance.BorderSize = 0

        btnEdit.BackColor = Color.FromArgb(40, 167, 69)
        btnEdit.ForeColor = Color.White
        btnEdit.FlatStyle = FlatStyle.Flat
        btnEdit.FlatAppearance.BorderSize = 0

        btnDelete.BackColor = Color.FromArgb(220, 53, 69)
        btnDelete.ForeColor = Color.White
        btnDelete.FlatStyle = FlatStyle.Flat
        btnDelete.FlatAppearance.BorderSize = 0

        btnClose.BackColor = Color.FromArgb(108, 117, 125)
        btnClose.ForeColor = Color.White
        btnClose.FlatStyle = FlatStyle.Flat
        btnClose.FlatAppearance.BorderSize = 0

        Dim topPanel As New FlowLayoutPanel() With {.Dock = DockStyle.Top, .Height = 48, .Padding = New Padding(8), .Margin = New Padding(0)}
        topPanel.Controls.Add(btnAdd)
        topPanel.Controls.Add(btnEdit)
        topPanel.Controls.Add(btnDelete)
        topPanel.Controls.Add(btnClose)
        ' Ensure grid is added first so Dock Fill respects top toolbar
        Controls.Add(grdStaff)
        Controls.Add(topPanel)

        AddHandler btnClose.Click, Sub() Me.Close()
        AddHandler btnAdd.Click, AddressOf OnAdd
        AddHandler btnEdit.Click, AddressOf OnEdit
        AddHandler btnDelete.Click, AddressOf OnDelete

        grdStaff.AutoGenerateColumns = True
        grdStaff.BackgroundColor = Color.White
        grdStaff.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        grdStaff.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize
        grdStaff.RowHeadersVisible = False
        grdStaff.Margin = New Padding(0)

        ' Load data from Users/Roles
        Try
            LoadStaff()
        Catch ex As Exception
            MessageBox.Show("Staff load error: " & ex.Message & Environment.NewLine & "Ensure the Users and Roles tables exist.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub LoadStaff()
        Using con As New SqlConnection(connectionString)
            con.Open()
            Dim sql As String = "SELECT u.UserID, u.Username, (ISNULL(u.FirstName,'') + CASE WHEN ISNULL(u.FirstName,'')<>'' AND ISNULL(u.LastName,'')<>'' THEN ' ' ELSE '' END + ISNULL(u.LastName,'')) AS FullName, " & _
                                "r.RoleName, u.BranchID, u.IsActive FROM Users u INNER JOIN Roles r ON r.RoleID = u.RoleID ORDER BY u.Username"
            Using cmd As New SqlCommand(sql, con)
                Dim dt As New DataTable()
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
                grdStaff.DataSource = dt
            End Using
        End Using
    End Sub

    Private Sub OnAdd(sender As Object, e As EventArgs)
        Using dlg As New StaffAddEditForm()
            If dlg.ShowDialog(Me) = DialogResult.OK AndAlso dlg.Saved Then
                LoadStaff()
            End If
        End Using
    End Sub

    Private Sub OnEdit(sender As Object, e As EventArgs)
        If grdStaff.CurrentRow Is Nothing Then Return
        Dim drv As DataRowView = TryCast(grdStaff.CurrentRow.DataBoundItem, DataRowView)
        If drv Is Nothing Then Return
        Dim userId As Integer = CInt(drv.Row("UserID"))
        Using dlg As New StaffAddEditForm(userId)
            If dlg.ShowDialog(Me) = DialogResult.OK AndAlso dlg.Saved Then
                LoadStaff()
            End If
        End Using
    End Sub

    Private Sub InitializeComponent()

    End Sub

    Private Sub OnDelete(sender As Object, e As EventArgs)
        Try
            If grdStaff.CurrentRow Is Nothing Then Return
            Dim drv As DataRowView = TryCast(grdStaff.CurrentRow.DataBoundItem, DataRowView)
            If drv Is Nothing Then Return
            Dim userId As Integer = CInt(drv.Row("UserID"))
            Dim fullName As String = Convert.ToString(drv.Row("FullName"))
            If MessageBox.Show($"Delete {fullName}?", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) <> DialogResult.Yes Then Return
            Using con As New SqlConnection(connectionString)
                con.Open()
                Using cmd As New SqlCommand("DELETE FROM Users WHERE UserID=@id", con)
                    cmd.Parameters.AddWithValue("@id", userId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            LoadStaff()
        Catch ex As Exception
            MessageBox.Show("Delete staff error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
