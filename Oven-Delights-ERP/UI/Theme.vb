Imports System.Drawing

Namespace UI
    Public Module Theme
        ' Modern professional palette with enhanced colors
        Public Primary As Color = Color.FromArgb(33, 150, 243) ' Modern blue
        Public Accent As Color = Color.FromArgb(255, 152, 0)   ' Vibrant orange
        Public Secondary As Color = Color.FromArgb(21, 101, 192) ' Darker blue
        Public Success As Color = Color.FromArgb(76, 175, 80)  ' Green for success states
        Public Warning As Color = Color.FromArgb(255, 193, 7)  ' Yellow for warnings
        Public Danger As Color = Color.FromArgb(244, 67, 54)   ' Red for errors
        Public Background As Color = Color.FromArgb(248, 249, 250) ' Light gray background
        Public Surface As Color = Color.White
        Public SurfaceElevated As Color = Color.FromArgb(255, 255, 255) ' Cards/panels
        Public Border As Color = Color.FromArgb(224, 224, 224) ' Subtle borders
        Public TextPrimary As Color = Color.FromArgb(33, 37, 41)
        Public TextSecondary As Color = Color.FromArgb(108, 117, 125)
        Public TextMuted As Color = Color.FromArgb(173, 181, 189)

        ' Apply base theme to a form. Optional: pass a logo to render in the top-left corner.
        Public Sub Apply(form As Form, Optional logo As Image = Nothing)
            ' If a logo is supplied, derive the brand palette from it first.
            If logo IsNot Nothing Then
                DeriveBrandFromLogo(logo)
            End If
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
            grid.ColumnHeadersDefaultCellStyle.BackColor = Primary
            grid.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            grid.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 9.5F, FontStyle.Bold)
            grid.ColumnHeadersDefaultCellStyle.Padding = New Padding(8, 6, 8, 6)
            grid.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(250, 250, 250)
            grid.DefaultCellStyle.BackColor = Surface
            grid.DefaultCellStyle.ForeColor = TextPrimary
            grid.DefaultCellStyle.SelectionBackColor = Lighten(Primary, 0.8F)
            grid.DefaultCellStyle.SelectionForeColor = TextPrimary
            grid.GridColor = Border
            grid.RowHeadersVisible = False
            grid.BorderStyle = BorderStyle.None
            grid.CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal
            grid.ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.None
            grid.ColumnHeadersHeight = 40
            grid.RowTemplate.Height = 32
        End Sub

        Public Function SuccessButtonStyle() As DataGridViewCellStyle
            Dim s As New DataGridViewCellStyle()
            s.BackColor = Success
            s.ForeColor = Color.White
            s.Alignment = DataGridViewContentAlignment.MiddleCenter
            s.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)
            Return s
        End Function

        Public Function DangerButtonStyle() As DataGridViewCellStyle
            Dim s As New DataGridViewCellStyle()
            s.BackColor = Danger
            s.ForeColor = Color.White
            s.Alignment = DataGridViewContentAlignment.MiddleCenter
            s.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)
            Return s
        End Function

        Public Function WarningButtonStyle() As DataGridViewCellStyle
            Dim s As New DataGridViewCellStyle()
            s.BackColor = Warning
            s.ForeColor = TextPrimary
            s.Alignment = DataGridViewContentAlignment.MiddleCenter
            s.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)
            Return s
        End Function

        ' Modern card-style panel
        Public Sub StyleCard(panel As Panel)
            panel.BackColor = SurfaceElevated
            panel.Padding = New Padding(16)
            panel.Margin = New Padding(8)
        End Sub

        ' Modern input styling
        Public Sub StyleTextBox(textBox As TextBox)
            textBox.BorderStyle = BorderStyle.FixedSingle
            textBox.BackColor = Surface
            textBox.ForeColor = TextPrimary
            textBox.Font = New Font("Segoe UI", 9.5F)
            textBox.Padding = New Padding(8)
        End Sub

        Public Sub StyleComboBox(comboBox As ComboBox)
            comboBox.FlatStyle = FlatStyle.Flat
            comboBox.BackColor = Surface
            comboBox.ForeColor = TextPrimary
            comboBox.Font = New Font("Segoe UI", 9.5F)
        End Sub

        ' Simple spacing helpers
        Public Sub Pad(control As Control, Optional all As Integer = 8)
            control.Padding = New Padding(all)
        End Sub

        Public Sub Margin(control As Control, Optional all As Integer = 8)
            control.Margin = New Padding(all)
        End Sub

        ' --- Auto-apply to all forms ---
        Private _autoTimer As System.Windows.Forms.Timer
        Private _themed As New HashSet(Of IntPtr)()
        Private _autoLogoPath As String

        ' Call once at startup (e.g., from MainDashboard) to ensure every form gets themed using the logo.
        Public Sub EnableAutoApply(logoPath As String)
            _autoLogoPath = logoPath
            If _autoTimer Is Nothing Then
                _autoTimer = New System.Windows.Forms.Timer()
                _autoTimer.Interval = 750 ' light touch; sub-1s feedback without heavy overhead
                AddHandler _autoTimer.Tick, AddressOf AutoApplyTick
                _autoTimer.Start()
            End If
        End Sub

        Private Sub AutoApplyTick(sender As Object, e As EventArgs)
            Try
                Dim img As Image = Nothing
                If Not String.IsNullOrWhiteSpace(_autoLogoPath) AndAlso IO.File.Exists(_autoLogoPath) Then
                    img = Image.FromFile(_autoLogoPath)
                Else
                    Dim fallback As String = IO.Path.Combine(Application.StartupPath, "LOGO.png")
                    If IO.File.Exists(fallback) Then img = Image.FromFile(fallback)
                End If
                For Each f As Form In Application.OpenForms
                    If f Is Nothing OrElse f.IsDisposed Then Continue For
                    Dim key = f.Handle
                    If key = IntPtr.Zero Then Continue For
                    If Not _themed.Contains(key) Then
                        Apply(f, img)
                        _themed.Add(key)
                    End If
                Next
            Catch
                ' best effort; never throw
            End Try
        End Sub

        ' --- Brand derivation helpers ---
        ' Derive primary/secondary/accent colors from a supplied logo image.
        Public Sub DeriveBrandFromLogo(logo As Image)
            Try
                If logo Is Nothing Then Return
                Dim avg = GetAverageColor(logo)
                Primary = avg
                Secondary = Darken(avg, 0.8F)
                Accent = Complementary(avg)
                ' Update backgrounds to harmonize with primary
                Background = Lighten(avg, 0.97F)
                Surface = Color.White
                TextPrimary = Color.FromArgb(43, 43, 43)
                TextMuted = Color.FromArgb(128, 128, 128)
            Catch
                ' Keep defaults on failure
            End Try
        End Sub

        Private Function GetAverageColor(img As Image) As Color
            Using bmp As New Bitmap(img)
                Dim stepX As Integer = Math.Max(1, bmp.Width \ 20)
                Dim stepY As Integer = Math.Max(1, bmp.Height \ 20)
                Dim r As Long = 0, g As Long = 0, b As Long = 0, n As Long = 0
                For y As Integer = 0 To bmp.Height - 1 Step stepY
                    For x As Integer = 0 To bmp.Width - 1 Step stepX
                        Dim c = bmp.GetPixel(x, y)
                        ' Ignore near-white/near-transparent pixels to avoid backgrounds dominating
                        If c.A > 10 AndAlso Not (c.R > 240 AndAlso c.G > 240 AndAlso c.B > 240) Then
                            r += c.R : g += c.G : b += c.B : n += 1
                        End If
                    Next
                Next
                If n = 0 Then Return Color.FromArgb(0, 153, 102)
                Return Color.FromArgb(CInt(r \ n), CInt(g \ n), CInt(b \ n))
            End Using
        End Function

        Private Function Lighten(c As Color, factor As Single) As Color
            factor = Math.Max(0.0F, Math.Min(1.0F, factor))
            Dim r = CInt(c.R + (255 - c.R) * factor)
            Dim g = CInt(c.G + (255 - c.G) * factor)
            Dim b = CInt(c.B + (255 - c.B) * factor)
            Return Color.FromArgb(r, g, b)
        End Function

        Private Function Darken(c As Color, factor As Single) As Color
            factor = Math.Max(0.0F, Math.Min(1.0F, factor))
            Dim r = CInt(c.R * factor)
            Dim g = CInt(c.G * factor)
            Dim b = CInt(c.B * factor)
            Return Color.FromArgb(r, g, b)
        End Function

        Private Function Complementary(c As Color) As Color
            Return Color.FromArgb(255 - c.R, 255 - c.G, 255 - c.B)
        End Function
    End Module
End Namespace

