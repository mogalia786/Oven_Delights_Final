Imports System.Windows.Forms

Namespace UI
    Public Module GridExportAttacher
        Private ReadOnly AttachedTagKey As String = "__PrintExportAttached__"

        Public Sub AttachOnForm(frm As Form)
            If frm Is Nothing OrElse frm.IsDisposed Then Return
            AttachRecursive(frm)
        End Sub

        Private Sub AttachRecursive(ctrl As Control)
            If ctrl Is Nothing Then Return
            Dim dgv = TryCast(ctrl, DataGridView)
            If dgv IsNot Nothing Then
                EnsureContextMenu(dgv)
            End If
            ' Recurse
            For Each child As Control In ctrl.Controls
                AttachRecursive(child)
            Next
        End Sub

        Private Sub EnsureContextMenu(dgv As DataGridView)
            Try
                ' Avoid re-attaching
                If dgv.Tag IsNot Nothing AndAlso TypeOf dgv.Tag Is Dictionary(Of String, Object) Then
                    Dim dict = DirectCast(dgv.Tag, Dictionary(Of String, Object))
                    If dict.ContainsKey(AttachedTagKey) Then Return
                End If

                Dim cms As ContextMenuStrip = dgv.ContextMenuStrip
                If cms Is Nothing Then
                    cms = New ContextMenuStrip()
                    dgv.ContextMenuStrip = cms
                End If

                ' If our item already exists, skip
                For Each it As ToolStripItem In cms.Items
                    If String.Equals(it.Text, "Print / Export…", StringComparison.OrdinalIgnoreCase) Then Return
                Next

                Dim mi As New ToolStripMenuItem("Print / Export…")
                AddHandler mi.Click, Sub(sender, e)
                                         Try
                                             Dim title As String = If(dgv.FindForm() IsNot Nothing, dgv.FindForm().Text, "Report")
                                             Dim ts As String = DateTime.Now.ToString("yyyyMMdd_HHmmss")
                                             Dim path As String = PdfService.SaveDataGridViewAsPdf(dgv, title, $"GRID_{ts}")
                                             Process.Start(New ProcessStartInfo() With {.FileName = path, .UseShellExecute = True})
                                         Catch ex As Exception
                                             MessageBox.Show("Export failed: " & ex.Message, "Export", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                         End Try
                                     End Sub
                cms.Items.Add(New ToolStripSeparator())
                cms.Items.Add(mi)

                ' Mark attached
                If dgv.Tag Is Nothing OrElse Not TypeOf dgv.Tag Is Dictionary(Of String, Object) Then
                    dgv.Tag = New Dictionary(Of String, Object)()
                End If
                DirectCast(dgv.Tag, Dictionary(Of String, Object))(AttachedTagKey) = True
            Catch
                ' best effort
            End Try
        End Sub
    End Module
End Namespace
