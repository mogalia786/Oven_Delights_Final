Imports System.Drawing
Imports System.Windows.Forms

Namespace Manufacturing
    Public Class BOMCreateForm
        Inherits Form

        Private ReadOnly lblTitle As New Label()
        Private ReadOnly btnOpenEditor As New Button()
        Private ReadOnly btnClose As New Button()
        Private ReadOnly info As New Label()

        Public Sub New()
            Me.Text = "Manufacturing - BOM Create"
            Me.Name = "BOMCreateForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.Sizable
            Me.WindowState = FormWindowState.Maximized

            lblTitle.Text = "BOM Create"
            lblTitle.Font = New Font("Segoe UI", 16, FontStyle.Bold)
            lblTitle.AutoSize = True
            lblTitle.Location = New Point(20, 20)

            info.Text = "Use this screen to create a BOM request (materials pull). Click 'Open Editor' to create or edit BOM details."
            info.Font = New Font("Segoe UI", 10, FontStyle.Regular)
            info.AutoSize = True
            info.Location = New Point(22, 60)

            btnOpenEditor.Text = "Open BOM Editor"
            btnOpenEditor.Size = New Size(180, 34)
            btnOpenEditor.Location = New Point(22, 100)
            AddHandler btnOpenEditor.Click, AddressOf OnOpenEditor

            btnClose.Text = "Close"
            btnClose.Size = New Size(120, 34)
            btnClose.Location = New Point(220, 100)
            AddHandler btnClose.Click, Sub() Me.Close()

            Controls.Add(lblTitle)
            Controls.Add(info)
            Controls.Add(btnOpenEditor)
            Controls.Add(btnClose)
        End Sub

        Private Sub OnOpenEditor(sender As Object, e As EventArgs)
            Try
                ' Open existing BOMEditorForm full-screen as modal for now
                Using frm As New Manufacturing.BOMEditorForm()
                    frm.SetMode("Create")
                    frm.StartPosition = FormStartPosition.CenterParent
                    frm.WindowState = FormWindowState.Maximized
                    frm.ShowDialog(Me)
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, ex.Message, "BOM Create", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
