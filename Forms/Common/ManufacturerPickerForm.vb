Imports System.Data
Imports System.Drawing
Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports Oven_Delights_ERP.Services

Namespace Common
    Public Class ManufacturerPickerForm
        Inherits Form

        Private ReadOnly cbo As New ComboBox()
        Private ReadOnly btnOk As New Button()
        Private ReadOnly btnCancel As New Button()

        Public Property SelectedUserID As Integer
        Public Property SelectedUserName As String

        Public Sub New()
            Me.Text = "Select Manufacturer"
            Me.Size = New Size(420, 160)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False
            Me.BackColor = Color.White

            Dim lbl As New Label() With {.Text = "Manufacturer:", .AutoSize = True, .Location = New Point(16, 22)}
            cbo.DropDownStyle = ComboBoxStyle.DropDownList
            cbo.Location = New Point(120, 18)
            cbo.Width = 260

            btnOk.Text = "OK"
            btnOk.Location = New Point(200, 70)
            btnOk.Width = 80
            AddHandler btnOk.Click, AddressOf OnOk

            btnCancel.Text = "Cancel"
            btnCancel.Location = New Point(300, 70)
            btnCancel.Width = 80
            AddHandler btnCancel.Click, Sub() Me.DialogResult = DialogResult.Cancel

            Controls.Add(lbl)
            Controls.Add(cbo)
            Controls.Add(btnOk)
            Controls.Add(btnCancel)

            AddHandler Me.Shown, Sub()
                                       LoadManufacturers()
                                       Try
                                           If cbo.Items IsNot Nothing AndAlso cbo.Items.Count > 0 Then
                                               cbo.SelectedIndex = 0
                                               cbo.DroppedDown = True
                                           End If
                                       Catch
                                       End Try
                                   End Sub
        End Sub

        Private Sub LoadManufacturers()
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim sql As String = "SELECT u.UserID, (u.FirstName + ' ' + u.LastName) AS FullName " & _
                                        "FROM dbo.Users u " & _
                                        "JOIN dbo.Roles r ON r.RoleID = u.RoleID " & _
                                        "WHERE r.RoleName = N'Manufacturer' AND (@b IS NULL OR u.BranchID = @b) " & _
                                        "ORDER BY FullName;"
                    Using cmd As New SqlCommand(sql, cn)
                        Dim branchId As Integer = AppSession.CurrentBranchID
                        If branchId > 0 Then
                            cmd.Parameters.AddWithValue("@b", branchId)
                        Else
                            cmd.Parameters.AddWithValue("@b", DBNull.Value)
                        End If
                        Using rdr = cmd.ExecuteReader()
                            Dim items As New List(Of KeyValuePair(Of Integer, String))()
                            While rdr.Read()
                                Dim id As Integer = Convert.ToInt32(rdr("UserID"))
                                Dim nm As String = Convert.ToString(rdr("FullName"))
                                items.Add(New KeyValuePair(Of Integer, String)(id, nm))
                            End While
                            cbo.DataSource = items
                            cbo.DisplayMember = "Value"
                            cbo.ValueMember = "Key"
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, "Failed to load manufacturers: " & ex.Message, "Manufacturers", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnOk(sender As Object, e As EventArgs)
            If cbo.SelectedItem Is Nothing Then
                MessageBox.Show(Me, "Please select a manufacturer.", "Manufacturers", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            Dim kv As KeyValuePair(Of Integer, String) = CType(cbo.SelectedItem, KeyValuePair(Of Integer, String))
            SelectedUserID = kv.Key
            SelectedUserName = kv.Value
            Me.DialogResult = DialogResult.OK
        End Sub

        Public Shared Function Pick(owner As IWin32Window) As (UserID As Integer, UserName As String, Ok As Boolean)
            Using f As New ManufacturerPickerForm()
                If f.ShowDialog(owner) = DialogResult.OK Then
                    Return (f.SelectedUserID, f.SelectedUserName, True)
                End If
            End Using
            Return (0, String.Empty, False)
        End Function
    End Class
End Namespace
