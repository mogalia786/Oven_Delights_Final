Imports System.Windows.Forms
Imports System.Drawing

Public Class RetailWelcomeForm
    Inherits Form

    Public Sub New(displayName As String)
        Me.Text = "Retail Manager - Welcome"
        Me.StartPosition = FormStartPosition.CenterParent
        Me.BackColor = Color.WhiteSmoke
        Me.Width = 900
        Me.Height = 600

        Dim header As New Label() With {
            .Text = $"Welcome Retail Manager {displayName}",
            .Dock = DockStyle.Top,
            .Height = 56,
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.White,
            .BackColor = Color.FromArgb(39, 174, 96),
            .Padding = New Padding(16, 12, 16, 12)
        }
        Controls.Add(header)

        Dim body As New Label() With {
            .Text = "Use the Retail menu to manage POS operations and retail workflows.",
            .Dock = DockStyle.Fill,
            .TextAlign = ContentAlignment.MiddleCenter,
            .Font = New Font("Segoe UI", 12, FontStyle.Regular)
        }
        Controls.Add(body)
    End Sub
End Class
