Imports System.Drawing
Imports System.Windows.Forms

Namespace Manufacturing
    Public Class BOMCompleteForm
        Inherits Form

        Private ReadOnly lblTitle As New Label()
        Private ReadOnly btnOpenCompletion As New Button()
        Private ReadOnly btnClose As New Button()
        Private ReadOnly info As New Label()

        Public Sub New()
            Me.Text = "Manufacturing - BOM Complete"
            Me.Name = "BOMCompleteForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.Sizable
            Me.WindowState = FormWindowState.Maximized

            lblTitle.Text = "BOM Complete"
            lblTitle.Font = New Font("Segoe UI", 16, FontStyle.Bold)
            lblTitle.AutoSize = True
            lblTitle.Location = New Point(20, 20)

            info.Text = "Use this screen to complete BOMs and move finished goods to Retail. Click 'Open Completion' to proceed."
            info.Font = New Font("Segoe UI", 10, FontStyle.Regular)
            info.AutoSize = True
            info.Location = New Point(22, 60)

            btnOpenCompletion.Text = "Open Completion"
            btnOpenCompletion.Size = New Size(180, 34)
            btnOpenCompletion.Location = New Point(22, 100)
            AddHandler btnOpenCompletion.Click, AddressOf OnOpenCompletion

            btnClose.Text = "Close"
            btnClose.Size = New Size(120, 34)
            btnClose.Location = New Point(220, 100)
            AddHandler btnClose.Click, Sub() Me.Close()

            Controls.Add(lblTitle)
            Controls.Add(info)
            Controls.Add(btnOpenCompletion)
            Controls.Add(btnClose)
        End Sub

        Private Sub OnOpenCompletion(sender As Object, e As EventArgs)
            Try
                ' Use existing CompleteBuildForm full-screen as modal for now
                Using frm As New Manufacturing.BOMEditorForm()
                    frm.SetMode("Complete")
                    frm.StartPosition = FormStartPosition.CenterParent
                    frm.WindowState = FormWindowState.Maximized
                    frm.ShowDialog(Me)
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, ex.Message, "BOM Complete", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
