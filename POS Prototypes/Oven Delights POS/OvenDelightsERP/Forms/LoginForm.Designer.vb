<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class LoginForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()>
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.txtUsername = New System.Windows.Forms.TextBox()
        Me.txtPassword = New System.Windows.Forms.TextBox()
        Me.btnLogin = New System.Windows.Forms.Button()
        Me.btnForgotPassword = New System.Windows.Forms.Button()
        Me.chkRememberMe = New System.Windows.Forms.CheckBox()
        Me.lblPasswordStrength = New System.Windows.Forms.Label()
        Me.progressPasswordStrength = New System.Windows.Forms.ProgressBar()
        Me.panelLogin = New System.Windows.Forms.Panel()
        Me.lblTitle = New System.Windows.Forms.Label()
        Me.lblSubtitle = New System.Windows.Forms.Label()
        Me.picLogo = New System.Windows.Forms.PictureBox()
        Me.lblUsername = New System.Windows.Forms.Label()
        Me.lblPassword = New System.Windows.Forms.Label()
        Me.panelBackground = New System.Windows.Forms.Panel()
        Me.btnTogglePassword = New System.Windows.Forms.Button()
        Me.panelLogin.SuspendLayout()
        CType(Me.picLogo, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.panelBackground.SuspendLayout()
        Me.SuspendLayout()
        '
        'txtUsername
        '
        Me.txtUsername.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.txtUsername.Location = New System.Drawing.Point(50, 245)
        Me.txtUsername.Name = "txtUsername"
        Me.txtUsername.Size = New System.Drawing.Size(300, 27)
        Me.txtUsername.TabIndex = 0
        '
        'txtPassword
        '
        Me.txtPassword.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.txtPassword.Location = New System.Drawing.Point(50, 315)
        Me.txtPassword.Name = "txtPassword"
        Me.txtPassword.Size = New System.Drawing.Size(260, 27)
        Me.txtPassword.TabIndex = 1
        Me.txtPassword.UseSystemPasswordChar = True
        '
        'btnLogin
        '
        Me.btnLogin.BackColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(152, Byte), Integer), CType(CType(219, Byte), Integer))
        Me.btnLogin.FlatAppearance.BorderSize = 0
        Me.btnLogin.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnLogin.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.btnLogin.ForeColor = System.Drawing.Color.White
        Me.btnLogin.Location = New System.Drawing.Point(50, 430)
        Me.btnLogin.Name = "btnLogin"
        Me.btnLogin.Size = New System.Drawing.Size(300, 45)
        Me.btnLogin.TabIndex = 4
        Me.btnLogin.Text = "Sign In"
        Me.btnLogin.UseVisualStyleBackColor = False
        '
        'btnForgotPassword
        '
        Me.btnForgotPassword.BackColor = System.Drawing.Color.Transparent
        Me.btnForgotPassword.FlatAppearance.BorderSize = 0
        Me.btnForgotPassword.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnForgotPassword.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.btnForgotPassword.ForeColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(152, Byte), Integer), CType(CType(219, Byte), Integer))
        Me.btnForgotPassword.Location = New System.Drawing.Point(200, 485)
        Me.btnForgotPassword.Name = "btnForgotPassword"
        Me.btnForgotPassword.Size = New System.Drawing.Size(150, 25)
        Me.btnForgotPassword.TabIndex = 5
        Me.btnForgotPassword.Text = "Forgot Password?"
        Me.btnForgotPassword.UseVisualStyleBackColor = False
        '
        'chkRememberMe
        '
        Me.chkRememberMe.AutoSize = True
        Me.chkRememberMe.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.chkRememberMe.ForeColor = System.Drawing.Color.FromArgb(CType(CType(108, Byte), Integer), CType(CType(117, Byte), Integer), CType(CType(125, Byte), Integer))
        Me.chkRememberMe.Location = New System.Drawing.Point(50, 395)
        Me.chkRememberMe.Name = "chkRememberMe"
        Me.chkRememberMe.Size = New System.Drawing.Size(104, 19)
        Me.chkRememberMe.TabIndex = 3
        Me.chkRememberMe.Text = "Remember me"
        Me.chkRememberMe.UseVisualStyleBackColor = True
        '
        'lblPasswordStrength
        '
        Me.lblPasswordStrength.AutoSize = True
        Me.lblPasswordStrength.Font = New System.Drawing.Font("Segoe UI", 8.0!)
        Me.lblPasswordStrength.ForeColor = System.Drawing.Color.FromArgb(CType(CType(108, Byte), Integer), CType(CType(117, Byte), Integer), CType(CType(125, Byte), Integer))
        Me.lblPasswordStrength.Location = New System.Drawing.Point(50, 355)
        Me.lblPasswordStrength.Name = "lblPasswordStrength"
        Me.lblPasswordStrength.Size = New System.Drawing.Size(96, 13)
        Me.lblPasswordStrength.TabIndex = 7
        Me.lblPasswordStrength.Text = "Password Strength"
        Me.lblPasswordStrength.Visible = False
        '
        'progressPasswordStrength
        '
        Me.progressPasswordStrength.Location = New System.Drawing.Point(50, 375)
        Me.progressPasswordStrength.Name = "progressPasswordStrength"
        Me.progressPasswordStrength.Size = New System.Drawing.Size(300, 8)
        Me.progressPasswordStrength.TabIndex = 8
        Me.progressPasswordStrength.Visible = False
        '
        'panelLogin
        '
        Me.panelLogin.BackColor = System.Drawing.Color.White
        Me.panelLogin.Controls.Add(Me.btnTogglePassword)
        Me.panelLogin.Controls.Add(Me.lblPassword)
        Me.panelLogin.Controls.Add(Me.lblUsername)
        Me.panelLogin.Controls.Add(Me.picLogo)
        Me.panelLogin.Controls.Add(Me.lblSubtitle)
        Me.panelLogin.Controls.Add(Me.lblTitle)
        Me.panelLogin.Controls.Add(Me.txtUsername)
        Me.panelLogin.Controls.Add(Me.progressPasswordStrength)
        Me.panelLogin.Controls.Add(Me.txtPassword)
        Me.panelLogin.Controls.Add(Me.lblPasswordStrength)
        Me.panelLogin.Controls.Add(Me.btnLogin)
        Me.panelLogin.Controls.Add(Me.chkRememberMe)
        Me.panelLogin.Controls.Add(Me.btnForgotPassword)
        Me.panelLogin.Location = New System.Drawing.Point(300, 50)
        Me.panelLogin.Name = "panelLogin"
        Me.panelLogin.Size = New System.Drawing.Size(400, 500)
        Me.panelLogin.TabIndex = 9
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 18.0!, System.Drawing.FontStyle.Bold)
        Me.lblTitle.ForeColor = System.Drawing.Color.FromArgb(CType(CType(45, Byte), Integer), CType(CType(52, Byte), Integer), CType(CType(67, Byte), Integer))
        Me.lblTitle.Location = New System.Drawing.Point(100, 140)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(200, 32)
        Me.lblTitle.TabIndex = 10
        Me.lblTitle.Text = "Oven Delights ERP"
        '
        'lblSubtitle
        '
        Me.lblSubtitle.AutoSize = True
        Me.lblSubtitle.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.lblSubtitle.ForeColor = System.Drawing.Color.FromArgb(CType(CType(108, Byte), Integer), CType(CType(117, Byte), Integer), CType(CType(125, Byte), Integer))
        Me.lblSubtitle.Location = New System.Drawing.Point(130, 170)
        Me.lblSubtitle.Name = "lblSubtitle"
        Me.lblSubtitle.Size = New System.Drawing.Size(140, 19)
        Me.lblSubtitle.TabIndex = 11
        Me.lblSubtitle.Text = "Sign in to your account"
        '
        'picLogo
        '
        Me.picLogo.BackColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(152, Byte), Integer), CType(CType(219, Byte), Integer))
        Me.picLogo.Location = New System.Drawing.Point(160, 40)
        Me.picLogo.Name = "picLogo"
        Me.picLogo.Size = New System.Drawing.Size(80, 80)
        Me.picLogo.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage
        Me.picLogo.TabIndex = 12
        Me.picLogo.TabStop = False
        '
        'lblUsername
        '
        Me.lblUsername.AutoSize = True
        Me.lblUsername.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.lblUsername.ForeColor = System.Drawing.Color.FromArgb(CType(CType(45, Byte), Integer), CType(CType(52, Byte), Integer), CType(CType(67, Byte), Integer))
        Me.lblUsername.Location = New System.Drawing.Point(50, 220)
        Me.lblUsername.Name = "lblUsername"
        Me.lblUsername.Size = New System.Drawing.Size(63, 15)
        Me.lblUsername.TabIndex = 13
        Me.lblUsername.Text = "Username"
        '
        'lblPassword
        '
        Me.lblPassword.AutoSize = True
        Me.lblPassword.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.lblPassword.ForeColor = System.Drawing.Color.FromArgb(CType(CType(45, Byte), Integer), CType(CType(52, Byte), Integer), CType(CType(67, Byte), Integer))
        Me.lblPassword.Location = New System.Drawing.Point(50, 290)
        Me.lblPassword.Name = "lblPassword"
        Me.lblPassword.Size = New System.Drawing.Size(57, 15)
        Me.lblPassword.TabIndex = 14
        Me.lblPassword.Text = "Password"
        '
        'panelBackground
        '
        Me.panelBackground.BackColor = System.Drawing.Color.FromArgb(CType(CType(45, Byte), Integer), CType(CType(52, Byte), Integer), CType(CType(67, Byte), Integer))
        Me.panelBackground.Controls.Add(Me.panelLogin)
        Me.panelBackground.Dock = System.Windows.Forms.DockStyle.Fill
        Me.panelBackground.Location = New System.Drawing.Point(0, 0)
        Me.panelBackground.Name = "panelBackground"
        Me.panelBackground.Size = New System.Drawing.Size(1000, 600)
        Me.panelBackground.TabIndex = 15
        '
        'btnTogglePassword
        '
        Me.btnTogglePassword.BackColor = System.Drawing.Color.FromArgb(CType(CType(248, Byte), Integer), CType(CType(249, Byte), Integer), CType(CType(250, Byte), Integer))
        Me.btnTogglePassword.FlatAppearance.BorderSize = 1
        Me.btnTogglePassword.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnTogglePassword.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.btnTogglePassword.Location = New System.Drawing.Point(320, 315)
        Me.btnTogglePassword.Name = "btnTogglePassword"
        Me.btnTogglePassword.Size = New System.Drawing.Size(30, 27)
        Me.btnTogglePassword.TabIndex = 2
        Me.btnTogglePassword.Text = "👁"
        Me.btnTogglePassword.UseVisualStyleBackColor = False
        '
        'LoginForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.FromArgb(CType(CType(240, Byte), Integer), CType(CType(244, Byte), Integer), CType(CType(248, Byte), Integer))
        Me.ClientSize = New System.Drawing.Size(1000, 600)
        Me.Controls.Add(Me.panelBackground)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.Name = "LoginForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Oven Delights ERP - Login"
        Me.panelLogin.ResumeLayout(False)
        Me.panelLogin.PerformLayout()
        CType(Me.picLogo, System.ComponentModel.ISupportInitialize).EndInit()
        Me.panelBackground.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents txtUsername As TextBox
    Friend WithEvents txtPassword As TextBox
    Friend WithEvents btnLogin As Button
    Friend WithEvents btnForgotPassword As Button
    Friend WithEvents chkRememberMe As CheckBox
    Friend WithEvents lblPasswordStrength As Label
    Friend WithEvents progressPasswordStrength As ProgressBar
    Friend WithEvents panelLogin As Panel
    Friend WithEvents lblTitle As Label
    Friend WithEvents lblSubtitle As Label
    Friend WithEvents picLogo As PictureBox
    Friend WithEvents lblUsername As Label
    Friend WithEvents lblPassword As Label
    Friend WithEvents panelBackground As Panel
    Friend WithEvents btnTogglePassword As Button
End Class
