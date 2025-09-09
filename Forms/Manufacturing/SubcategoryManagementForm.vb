Imports System.Windows.Forms
Imports System.Drawing

Namespace Manufacturing
    Public Class SubcategoryManagementForm
        Inherits Form

        Public Sub New()
            Me.Text = "Manufacturing - Subcategories"
            Me.Name = "SubcategoryManagementForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.FromArgb(245, 247, 250)
            Me.Width = 1100
            Me.Height = 750

            Dim header As New Label() With {
                .Text = "Product Subcategories",
                .Dock = DockStyle.Top,
                .Height = 44,
                .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                .ForeColor = Color.White,
                .BackColor = Color.FromArgb(0, 99, 99),
                .Padding = New Padding(12, 8, 12, 8)
            }
            Controls.Add(header)
        End Sub
    End Class
End Namespace
