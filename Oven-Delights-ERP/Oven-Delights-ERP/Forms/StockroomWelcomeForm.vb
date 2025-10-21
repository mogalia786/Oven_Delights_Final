Imports System.Windows.Forms
Imports System.Drawing

Public Class StockroomWelcomeForm
    Inherits Form

    Public Sub New(displayName As String)
        Me.Text = "Stockroom Manager - Welcome"
        Me.StartPosition = FormStartPosition.CenterParent
        Me.BackColor = Color.WhiteSmoke
        Me.Width = 900
        Me.Height = 600

        Dim header As New Label() With {
            .Text = $"Welcome Stockroom Manager {displayName}",
            .Dock = DockStyle.Top,
            .Height = 56,
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.White,
            .BackColor = Color.FromArgb(52, 73, 94),
            .Padding = New Padding(16, 12, 16, 12)
        }
        Controls.Add(header)

        Dim body As New Label() With {
            .Text = "Use the Stockroom menu to manage inventory, suppliers, POs, transfers and adjustments.",
            .Dock = DockStyle.Fill,
            .TextAlign = ContentAlignment.MiddleCenter,
            .Font = New Font("Segoe UI", 12, FontStyle.Regular)
        }
        Controls.Add(body)
    End Sub
End Class
