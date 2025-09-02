Imports System.Drawing

Namespace UI
    Public Module Theme
        ' Core palette (can be tweaked later)
        Public ReadOnly Primary As Color = Color.FromArgb(0, 153, 102) ' Green brand
        Public ReadOnly Accent As Color = Color.FromArgb(255, 179, 0)  ' Amber
        Public ReadOnly Secondary As Color = Color.FromArgb(10, 127, 97)
        Public ReadOnly Background As Color = Color.FromArgb(245, 255, 245)
        Public ReadOnly Surface As Color = Color.White
        Public ReadOnly TextPrimary As Color = Color.FromArgb(43, 43, 43)
        Public ReadOnly TextMuted As Color = Color.FromArgb(158, 158, 158)

        ' Apply base theme to a form. Optional: pass a logo to render in the top-left corner.
        Public Sub Apply(form As Form, Optional logo As Image = Nothing)
            form.BackColor = Background
            form.Font = New Font("Segoe UI", 10.0F, FontStyle.Regular, GraphicsUnit.Point)

            ' Optional logo host in the top area (non-invasive)
            If logo IsNot Nothing AndAlso form.Controls("__ThemeLogo") Is Nothing Then
                Dim pic As New PictureBox()
                pic.Name = "__ThemeLogo"
                pic.SizeMode = PictureBoxSizeMode.Zoom
                pic.Width = 120
                pic.Height = 36
                pic.Image = logo
                pic.BackColor = Color.Transparent
                pic.Margin = New Padding(8)
                ' Place at top-left using a small panel
                Dim host As New Panel() With { .Dock = DockStyle.Top, .Height = 44, .BackColor = Background }
                host.Controls.Add(pic)
                pic.Location = New Point(8, 4)
                form.Controls.Add(host)
                host.BringToFront()
            End If
        End Sub

        Public Sub StyleHeaderLabel(lbl As Label)
            lbl.ForeColor = TextPrimary
            lbl.Font = New Font("Segoe UI Semibold", 10.5F, FontStyle.Bold)
        End Sub

        Public Sub StylePrimaryButton(btn As Button)
            btn.BackColor = Primary
            btn.ForeColor = Color.White
            btn.FlatStyle = FlatStyle.Flat
            btn.FlatAppearance.BorderSize = 0
            btn.FlatAppearance.MouseOverBackColor = Secondary
            btn.FlatAppearance.MouseDownBackColor = Color.FromArgb(0, 110, 73)
            btn.Padding = New Padding(10, 6, 10, 6)
        End Sub

        Public Sub StyleSecondaryButton(btn As Button)
            btn.BackColor = Color.FromArgb(230, 230, 240)
            btn.ForeColor = TextPrimary
            btn.FlatStyle = FlatStyle.Flat
            btn.FlatAppearance.BorderSize = 0
            btn.FlatAppearance.MouseOverBackColor = Color.FromArgb(215, 215, 230)
            btn.FlatAppearance.MouseDownBackColor = Color.FromArgb(200, 200, 220)
            btn.Padding = New Padding(10, 6, 10, 6)
        End Sub

        Public Sub StyleDangerButton(btn As Button)
            btn.BackColor = Color.FromArgb(198, 40, 40)
            btn.ForeColor = Color.White
            btn.FlatStyle = FlatStyle.Flat
            btn.FlatAppearance.BorderSize = 0
            btn.FlatAppearance.MouseOverBackColor = Color.FromArgb(173, 29, 29)
            btn.FlatAppearance.MouseDownBackColor = Color.FromArgb(143, 20, 20)
            btn.Padding = New Padding(10, 6, 10, 6)
        End Sub

        Public Sub StyleGrid(grid As DataGridView)
            grid.BackgroundColor = Surface
            grid.EnableHeadersVisualStyles = False
            grid.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(220, 244, 234)
            grid.ColumnHeadersDefaultCellStyle.ForeColor = TextPrimary
            grid.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI Semibold", 9.5F, FontStyle.Bold)
            grid.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(240, 252, 245)
            grid.GridColor = Color.FromArgb(0, 153, 102)
            grid.RowHeadersVisible = False
            grid.BorderStyle = BorderStyle.None
            grid.CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal
        End Sub

        Public Function GreenButtonStyle() As DataGridViewCellStyle
            Dim s As New DataGridViewCellStyle()
            s.BackColor = Color.FromArgb(0, 150, 99)
            s.ForeColor = Color.White
            s.Alignment = DataGridViewContentAlignment.MiddleCenter
            Return s
        End Function

        Public Function RedButtonStyle() As DataGridViewCellStyle
            Dim s As New DataGridViewCellStyle()
            s.BackColor = Color.FromArgb(198, 40, 40)
            s.ForeColor = Color.White
            s.Alignment = DataGridViewContentAlignment.MiddleCenter
            Return s
        End Function

        ' Simple spacing helpers
        Public Sub Pad(control As Control, Optional all As Integer = 8)
            control.Padding = New Padding(all)
        End Sub

        Public Sub Margin(control As Control, Optional all As Integer = 8)
            control.Margin = New Padding(all)
        End Sub
    End Module
End Namespace

