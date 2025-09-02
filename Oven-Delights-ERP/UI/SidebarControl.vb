Imports System.Windows.Forms
Imports System.Drawing
Imports System.IO

Namespace UI
    Public Class SidebarControl
        Inherits UserControl

        Public Event Navigate(moduleKey As String)

        Private header As Panel
        Private picHeaderLogo As PictureBox
        Private lblTitle As Label
        Private contextHost As Panel

        Public Sub New()
            Me.Width = 220
            Me.Dock = DockStyle.Left
            ' Slightly warm canvas to differentiate from header for logo contrast
            Me.BackColor = Color.FromArgb(250, 248, 247)
            Me.Padding = New Padding(0)
            Build()
        End Sub

        Private Sub Build()
            ' Very light header to contrast with potential brand-colored logo
            header = New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 84,
                .BackColor = Color.FromArgb(255, 253, 252)
            }
            ' Optional logo area above the title
            picHeaderLogo = New PictureBox() With {
                .Dock = DockStyle.Top,
                .Height = 48,
                .SizeMode = PictureBoxSizeMode.Zoom,
                .BackColor = Color.Transparent
            }
            ' Try to load a logo from application or parent folders using common filenames; ignore failures
            Try
                Dim candidates As String() = {"logo.png", "logo.jpg", "OvenDelightsLogo.png", "OvenDelightsLogo.jpg"}
                Dim probe As DirectoryInfo = New DirectoryInfo(AppDomain.CurrentDomain.BaseDirectory)
                For i As Integer = 0 To 3 ' probe up to 3 parent levels
                    For Each fname In candidates
                        Dim full = Path.Combine(probe.FullName, fname)
                        If File.Exists(full) Then
                            picHeaderLogo.Image = Image.FromFile(full)
                            Throw New Exception("__LogoLoaded__") ' break out of both loops
                        End If
                    Next
                    If probe.Parent Is Nothing Then Exit For
                    probe = probe.Parent
                Next
            Catch ex As Exception
                ' swallow, including the synthetic __LogoLoaded__ exit
            End Try
            lblTitle = New Label() With {
                .Text = "Oven Delights",
                .AutoSize = False,
                .Dock = DockStyle.Fill,
                .TextAlign = ContentAlignment.MiddleLeft,
                .Font = New Font("Segoe UI Semibold", 11.0F, FontStyle.Bold),
                .Padding = New Padding(16, 0, 8, 0)
            }
            header.Controls.Add(lblTitle)
            header.Controls.Add(picHeaderLogo)
            ' Thin separator to further distinguish header from content area
            Dim sep As New Panel() With {
                .Dock = DockStyle.Bottom,
                .Height = 1,
                .BackColor = Color.FromArgb(225, 225, 225)
            }
            header.Controls.Add(sep)
            Controls.Add(header)

            ' Context area for adaptive content from child forms (place at bottom)
            contextHost = New Panel() With {
                .Dock = DockStyle.Bottom,
                .Height = 160,
                .BackColor = Color.FromArgb(248, 250, 255)
            }
            Controls.Add(contextHost)

            ' Nav buttons
            AddNavButton("Dashboard", "dashboard")
            AddNavButton("Materials", "materials")
            AddNavButton("Suppliers", "suppliers")
            AddNavButton("Purchase Orders", "po")
            AddNavButton("GRV", "grv")
            AddNavButton("Accounts Payable", "ap")
            AddNavButton("Reports", "reports")
            AddHandler Me.Resize, Sub() Invalidate()
        End Sub

        Private Sub AddNavButton(text As String, key As String)
            Dim btn As New Button() With {
                .Text = text,
                .Dock = DockStyle.Top,
                .Height = 42,
                .FlatStyle = FlatStyle.Flat,
                .TextAlign = ContentAlignment.MiddleLeft,
                .BackColor = Color.White,
                .ForeColor = Color.FromArgb(43, 43, 43),
                .Padding = New Padding(16, 0, 8, 0),
                .Tag = key
            }
            btn.FlatAppearance.BorderSize = 0
            AddHandler btn.Click, Sub() RaiseEvent Navigate(CStr(btn.Tag))
            Controls.Add(btn)
            ' Ensure nav buttons stack directly below header (context panel is docked to bottom)
            Controls.SetChildIndex(btn, 1)
        End Sub

        Public Sub SetTitle(text As String)
            lblTitle.Text = text
        End Sub

        ' Optional: allow caller to set the header logo programmatically
        Public Sub SetHeaderLogoImage(img As Image)
            If img Is Nothing Then Return
            picHeaderLogo.Image = img
        End Sub

        Public Sub SetContext(panel As Panel)
            ' Clear previous
            contextHost.Controls.Clear()
            If panel Is Nothing Then Return
            panel.Dock = DockStyle.Fill
            contextHost.Height = panel.Height
            contextHost.Controls.Add(panel)
        End Sub

        Public Sub ClearContext()
            contextHost.Controls.Clear()
        End Sub
    End Class
End Namespace
