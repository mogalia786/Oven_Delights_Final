Imports System.Windows.Forms
Imports System.Drawing

Public Class ManufacturingWelcomeForm
    Inherits Form

    Public Sub New(displayName As String)
        Me.Text = "Manufacturing Manager - Welcome"
        Me.StartPosition = FormStartPosition.CenterParent
        Me.BackColor = Color.WhiteSmoke
        Me.Width = 900
        Me.Height = 600

        ' Manufacturing menu
        Dim menu As New MenuStrip()
        Dim mManufacturing As New ToolStripMenuItem("Manufacturing")
        Dim miCategories As New ToolStripMenuItem("Categories")
        AddHandler miCategories.Click, AddressOf OnOpenCategories
        Dim miSubcategories As New ToolStripMenuItem("Subcategories")
        AddHandler miSubcategories.Click, AddressOf OnOpenSubcategories
        mManufacturing.DropDownItems.Add(miCategories)
        mManufacturing.DropDownItems.Add(miSubcategories)

        menu.Items.Add(mManufacturing)
        Me.MainMenuStrip = menu
        menu.Dock = DockStyle.Top
        Controls.Add(menu)

        Dim header As New Label() With {
            .Text = $"Welcome Manufacturing Manager {displayName}",
            .Dock = DockStyle.Top,
            .Height = 56,
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.White,
            .BackColor = Color.FromArgb(0, 99, 99),
            .Padding = New Padding(16, 12, 16, 12)
        }
        Controls.Add(header)

        Dim body As New Label() With {
            .Text = "Use the Manufacturing menu to manage categories, products and BOMs.",
            .Dock = DockStyle.Fill,
            .TextAlign = ContentAlignment.MiddleCenter,
            .Font = New Font("Segoe UI", 12, FontStyle.Regular)
        }
        Controls.Add(body)
    End Sub

    Private Sub OnOpenCategories(sender As Object, e As EventArgs)
        Using f As New Manufacturing.CategoriesForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenSubcategories(sender As Object, e As EventArgs)
        Using f As New Manufacturing.SubcategoriesForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub
End Class
