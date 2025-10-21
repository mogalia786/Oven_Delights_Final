Imports System.Data
Imports System.Drawing
Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class ManufacturerSelectDialog
    Inherits Form

    Private cbo As New ComboBox()
    Private btnOk As New Button()
    Private btnCancel As New Button()

    Public Property SelectedUserId As Integer

    Public Sub New()
        Me.Text = "Select Manufacturer"
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MinimizeBox = False
        Me.MaximizeBox = False
        Me.Width = 420
        Me.Height = 160
        Me.BackColor = Color.White

        Dim lbl As New Label() With {
            .Text = "Manufacturer:",
            .AutoSize = True,
            .Location = New Point(16, 22)
        }
        cbo.DropDownStyle = ComboBoxStyle.DropDownList
        cbo.Location = New Point(130, 18)
        cbo.Width = 250

        btnOk.Text = "OK"
        btnOk.Location = New Point(200, 70)
        AddHandler btnOk.Click, AddressOf OnOk

        btnCancel.Text = "Cancel"
        btnCancel.Location = New Point(290, 70)
        AddHandler btnCancel.Click, Sub() Me.DialogResult = DialogResult.Cancel

        Controls.Add(lbl)
        Controls.Add(cbo)
        Controls.Add(btnOk)
        Controls.Add(btnCancel)

        LoadManufacturers()
    End Sub

    Private Sub LoadManufacturers()
        Try
            Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Using cn As New SqlConnection(cs)
                cn.Open()
                ' Role name assumed to be 'Manufacturer' from 27_Add_Role_Manufacturer.sql
                Dim sql As String = "SELECT u.UserID, (u.FirstName + ' ' + u.LastName) AS DisplayName " & _
                                    "FROM dbo.Users u INNER JOIN dbo.Roles r ON r.RoleID = u.RoleID " & _
                                    "WHERE r.RoleName = 'Manufacturer' AND u.IsActive = 1 " & _
                                    "ORDER BY DisplayName;"
                Using cmd As New SqlCommand(sql, cn)
                    Using rdr = cmd.ExecuteReader()
                        Dim dt As New DataTable()
                        dt.Load(rdr)
                        cbo.DataSource = dt
                        cbo.ValueMember = "UserID"
                        cbo.DisplayMember = "DisplayName"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to load manufacturers: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnOk(sender As Object, e As EventArgs)
        If cbo.SelectedValue Is Nothing Then
            MessageBox.Show("Select a manufacturer.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        SelectedUserId = Convert.ToInt32(cbo.SelectedValue)
        Me.DialogResult = DialogResult.OK
    End Sub
End Class
