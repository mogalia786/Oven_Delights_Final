<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class SystemSettingsForm
    Inherits System.Windows.Forms.Form

    Private components As System.ComponentModel.IContainer
    Friend WithEvents tabControl As System.Windows.Forms.TabControl
    Friend WithEvents tabSecurity As System.Windows.Forms.TabPage
    Friend WithEvents tabNotifications As System.Windows.Forms.TabPage
    Friend WithEvents tabBackup As System.Windows.Forms.TabPage
    Friend WithEvents tabGeneral As System.Windows.Forms.TabPage
    
    ' Security Tab Controls
    Friend WithEvents lblSessionTimeout As System.Windows.Forms.Label
    Friend WithEvents txtSessionTimeout As System.Windows.Forms.TextBox
    Friend WithEvents lblMaxLoginAttempts As System.Windows.Forms.Label
    Friend WithEvents txtMaxLoginAttempts As System.Windows.Forms.TextBox
    Friend WithEvents lblPasswordExpiry As System.Windows.Forms.Label
    Friend WithEvents txtPasswordExpiry As System.Windows.Forms.TextBox
    Friend WithEvents chkTwoFactorRequired As System.Windows.Forms.CheckBox
    Friend WithEvents chkIPWhitelisting As System.Windows.Forms.CheckBox
    
    ' Notifications Tab Controls
    Friend WithEvents chkEmailNotifications As System.Windows.Forms.CheckBox
    Friend WithEvents chkSMSNotifications As System.Windows.Forms.CheckBox
    Friend WithEvents lblSMTPServer As System.Windows.Forms.Label
    Friend WithEvents txtSMTPServer As System.Windows.Forms.TextBox
    Friend WithEvents lblSMTPPort As System.Windows.Forms.Label
    Friend WithEvents txtSMTPPort As System.Windows.Forms.TextBox
    Friend WithEvents chkSMTPSSL As System.Windows.Forms.CheckBox
    
    ' Backup Tab Controls
    Friend WithEvents chkAutoBackup As System.Windows.Forms.CheckBox
    Friend WithEvents lblBackupFrequency As System.Windows.Forms.Label
    Friend WithEvents cboBackupFrequency As System.Windows.Forms.ComboBox
    Friend WithEvents lblBackupPath As System.Windows.Forms.Label
    Friend WithEvents txtBackupPath As System.Windows.Forms.TextBox
    Friend WithEvents btnBrowseBackupPath As System.Windows.Forms.Button
    Friend WithEvents lblBackupRetention As System.Windows.Forms.Label
    Friend WithEvents txtBackupRetention As System.Windows.Forms.TextBox
    
    ' General Tab Controls
    Friend WithEvents lblCompanyName As System.Windows.Forms.Label
    Friend WithEvents txtCompanyName As System.Windows.Forms.TextBox
    Friend WithEvents lblDefaultLanguage As System.Windows.Forms.Label
    Friend WithEvents cboDefaultLanguage As System.Windows.Forms.ComboBox
    Friend WithEvents lblDefaultTheme As System.Windows.Forms.Label
    Friend WithEvents cboDefaultTheme As System.Windows.Forms.ComboBox
    Friend WithEvents chkMaintenanceMode As System.Windows.Forms.CheckBox
    
    ' Action Buttons
    Friend WithEvents btnSave As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents btnTestConnection As System.Windows.Forms.Button

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.tabControl = New System.Windows.Forms.TabControl()
        Me.tabSecurity = New System.Windows.Forms.TabPage()
        Me.tabNotifications = New System.Windows.Forms.TabPage()
        Me.tabBackup = New System.Windows.Forms.TabPage()
        Me.tabGeneral = New System.Windows.Forms.TabPage()
        
        ' Security Tab Controls
        Me.lblSessionTimeout = New System.Windows.Forms.Label()
        Me.txtSessionTimeout = New System.Windows.Forms.TextBox()
        Me.lblMaxLoginAttempts = New System.Windows.Forms.Label()
        Me.txtMaxLoginAttempts = New System.Windows.Forms.TextBox()
        Me.lblPasswordExpiry = New System.Windows.Forms.Label()
        Me.txtPasswordExpiry = New System.Windows.Forms.TextBox()
        Me.chkTwoFactorRequired = New System.Windows.Forms.CheckBox()
        Me.chkIPWhitelisting = New System.Windows.Forms.CheckBox()
        
        ' Notifications Tab Controls
        Me.chkEmailNotifications = New System.Windows.Forms.CheckBox()
        Me.chkSMSNotifications = New System.Windows.Forms.CheckBox()
        Me.lblSMTPServer = New System.Windows.Forms.Label()
        Me.txtSMTPServer = New System.Windows.Forms.TextBox()
        Me.lblSMTPPort = New System.Windows.Forms.Label()
        Me.txtSMTPPort = New System.Windows.Forms.TextBox()
        Me.chkSMTPSSL = New System.Windows.Forms.CheckBox()
        
        ' Backup Tab Controls
        Me.chkAutoBackup = New System.Windows.Forms.CheckBox()
        Me.lblBackupFrequency = New System.Windows.Forms.Label()
        Me.cboBackupFrequency = New System.Windows.Forms.ComboBox()
        Me.lblBackupPath = New System.Windows.Forms.Label()
        Me.txtBackupPath = New System.Windows.Forms.TextBox()
        Me.btnBrowseBackupPath = New System.Windows.Forms.Button()
        Me.lblBackupRetention = New System.Windows.Forms.Label()
        Me.txtBackupRetention = New System.Windows.Forms.TextBox()
        
        ' General Tab Controls
        Me.lblCompanyName = New System.Windows.Forms.Label()
        Me.txtCompanyName = New System.Windows.Forms.TextBox()
        Me.lblDefaultLanguage = New System.Windows.Forms.Label()
        Me.cboDefaultLanguage = New System.Windows.Forms.ComboBox()
        Me.lblDefaultTheme = New System.Windows.Forms.Label()
        Me.cboDefaultTheme = New System.Windows.Forms.ComboBox()
        Me.chkMaintenanceMode = New System.Windows.Forms.CheckBox()
        
        ' Action Buttons
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.btnTestConnection = New System.Windows.Forms.Button()
        
        Me.tabControl.SuspendLayout()
        Me.tabSecurity.SuspendLayout()
        Me.tabNotifications.SuspendLayout()
        Me.tabBackup.SuspendLayout()
        Me.tabGeneral.SuspendLayout()
        Me.SuspendLayout()
        
        ' tabControl
        Me.tabControl.Controls.Add(Me.tabSecurity)
        Me.tabControl.Controls.Add(Me.tabNotifications)
        Me.tabControl.Controls.Add(Me.tabBackup)
        Me.tabControl.Controls.Add(Me.tabGeneral)
        Me.tabControl.Location = New System.Drawing.Point(12, 12)
        Me.tabControl.Name = "tabControl"
        Me.tabControl.SelectedIndex = 0
        Me.tabControl.Size = New System.Drawing.Size(560, 400)
        Me.tabControl.TabIndex = 0
        
        ' tabSecurity
        Me.tabSecurity.Controls.Add(Me.chkIPWhitelisting)
        Me.tabSecurity.Controls.Add(Me.chkTwoFactorRequired)
        Me.tabSecurity.Controls.Add(Me.txtPasswordExpiry)
        Me.tabSecurity.Controls.Add(Me.lblPasswordExpiry)
        Me.tabSecurity.Controls.Add(Me.txtMaxLoginAttempts)
        Me.tabSecurity.Controls.Add(Me.lblMaxLoginAttempts)
        Me.tabSecurity.Controls.Add(Me.txtSessionTimeout)
        Me.tabSecurity.Controls.Add(Me.lblSessionTimeout)
        Me.tabSecurity.Location = New System.Drawing.Point(4, 25)
        Me.tabSecurity.Name = "tabSecurity"
        Me.tabSecurity.Padding = New System.Windows.Forms.Padding(3)
        Me.tabSecurity.Size = New System.Drawing.Size(552, 371)
        Me.tabSecurity.TabIndex = 0
        Me.tabSecurity.Text = "Security"
        Me.tabSecurity.UseVisualStyleBackColor = True
        
        ' Security Controls
        Me.lblSessionTimeout.AutoSize = True
        Me.lblSessionTimeout.Location = New System.Drawing.Point(20, 30)
        Me.lblSessionTimeout.Name = "lblSessionTimeout"
        Me.lblSessionTimeout.Size = New System.Drawing.Size(140, 17)
        Me.lblSessionTimeout.TabIndex = 0
        Me.lblSessionTimeout.Text = "Session Timeout (min):"
        
        Me.txtSessionTimeout.Location = New System.Drawing.Point(180, 27)
        Me.txtSessionTimeout.Name = "txtSessionTimeout"
        Me.txtSessionTimeout.Size = New System.Drawing.Size(100, 22)
        Me.txtSessionTimeout.TabIndex = 1
        
        Me.lblMaxLoginAttempts.AutoSize = True
        Me.lblMaxLoginAttempts.Location = New System.Drawing.Point(20, 70)
        Me.lblMaxLoginAttempts.Name = "lblMaxLoginAttempts"
        Me.lblMaxLoginAttempts.Size = New System.Drawing.Size(135, 17)
        Me.lblMaxLoginAttempts.TabIndex = 2
        Me.lblMaxLoginAttempts.Text = "Max Login Attempts:"
        
        Me.txtMaxLoginAttempts.Location = New System.Drawing.Point(180, 67)
        Me.txtMaxLoginAttempts.Name = "txtMaxLoginAttempts"
        Me.txtMaxLoginAttempts.Size = New System.Drawing.Size(100, 22)
        Me.txtMaxLoginAttempts.TabIndex = 3
        
        Me.lblPasswordExpiry.AutoSize = True
        Me.lblPasswordExpiry.Location = New System.Drawing.Point(20, 110)
        Me.lblPasswordExpiry.Name = "lblPasswordExpiry"
        Me.lblPasswordExpiry.Size = New System.Drawing.Size(150, 17)
        Me.lblPasswordExpiry.TabIndex = 4
        Me.lblPasswordExpiry.Text = "Password Expiry (days):"
        
        Me.txtPasswordExpiry.Location = New System.Drawing.Point(180, 107)
        Me.txtPasswordExpiry.Name = "txtPasswordExpiry"
        Me.txtPasswordExpiry.Size = New System.Drawing.Size(100, 22)
        Me.txtPasswordExpiry.TabIndex = 5
        
        Me.chkTwoFactorRequired.AutoSize = True
        Me.chkTwoFactorRequired.Location = New System.Drawing.Point(20, 150)
        Me.chkTwoFactorRequired.Name = "chkTwoFactorRequired"
        Me.chkTwoFactorRequired.Size = New System.Drawing.Size(205, 21)
        Me.chkTwoFactorRequired.TabIndex = 6
        Me.chkTwoFactorRequired.Text = "Require Two-Factor Authentication"
        Me.chkTwoFactorRequired.UseVisualStyleBackColor = True
        
        Me.chkIPWhitelisting.AutoSize = True
        Me.chkIPWhitelisting.Location = New System.Drawing.Point(20, 190)
        Me.chkIPWhitelisting.Name = "chkIPWhitelisting"
        Me.chkIPWhitelisting.Size = New System.Drawing.Size(130, 21)
        Me.chkIPWhitelisting.TabIndex = 7
        Me.chkIPWhitelisting.Text = "Enable IP Whitelisting"
        Me.chkIPWhitelisting.UseVisualStyleBackColor = True
        
        ' tabNotifications
        Me.tabNotifications.Controls.Add(Me.chkSMTPSSL)
        Me.tabNotifications.Controls.Add(Me.txtSMTPPort)
        Me.tabNotifications.Controls.Add(Me.lblSMTPPort)
        Me.tabNotifications.Controls.Add(Me.txtSMTPServer)
        Me.tabNotifications.Controls.Add(Me.lblSMTPServer)
        Me.tabNotifications.Controls.Add(Me.chkSMSNotifications)
        Me.tabNotifications.Controls.Add(Me.chkEmailNotifications)
        Me.tabNotifications.Location = New System.Drawing.Point(4, 25)
        Me.tabNotifications.Name = "tabNotifications"
        Me.tabNotifications.Padding = New System.Windows.Forms.Padding(3)
        Me.tabNotifications.Size = New System.Drawing.Size(552, 371)
        Me.tabNotifications.TabIndex = 1
        Me.tabNotifications.Text = "Notifications"
        Me.tabNotifications.UseVisualStyleBackColor = True
        
        ' Notification Controls
        Me.chkEmailNotifications.AutoSize = True
        Me.chkEmailNotifications.Location = New System.Drawing.Point(20, 30)
        Me.chkEmailNotifications.Name = "chkEmailNotifications"
        Me.chkEmailNotifications.Size = New System.Drawing.Size(141, 21)
        Me.chkEmailNotifications.TabIndex = 0
        Me.chkEmailNotifications.Text = "Email Notifications"
        Me.chkEmailNotifications.UseVisualStyleBackColor = True
        
        Me.chkSMSNotifications.AutoSize = True
        Me.chkSMSNotifications.Location = New System.Drawing.Point(20, 70)
        Me.chkSMSNotifications.Name = "chkSMSNotifications"
        Me.chkSMSNotifications.Size = New System.Drawing.Size(133, 21)
        Me.chkSMSNotifications.TabIndex = 1
        Me.chkSMSNotifications.Text = "SMS Notifications"
        Me.chkSMSNotifications.UseVisualStyleBackColor = True
        
        Me.lblSMTPServer.AutoSize = True
        Me.lblSMTPServer.Location = New System.Drawing.Point(20, 110)
        Me.lblSMTPServer.Name = "lblSMTPServer"
        Me.lblSMTPServer.Size = New System.Drawing.Size(94, 17)
        Me.lblSMTPServer.TabIndex = 2
        Me.lblSMTPServer.Text = "SMTP Server:"
        
        Me.txtSMTPServer.Location = New System.Drawing.Point(130, 107)
        Me.txtSMTPServer.Name = "txtSMTPServer"
        Me.txtSMTPServer.Size = New System.Drawing.Size(200, 22)
        Me.txtSMTPServer.TabIndex = 3
        
        Me.lblSMTPPort.AutoSize = True
        Me.lblSMTPPort.Location = New System.Drawing.Point(20, 150)
        Me.lblSMTPPort.Name = "lblSMTPPort"
        Me.lblSMTPPort.Size = New System.Drawing.Size(80, 17)
        Me.lblSMTPPort.TabIndex = 4
        Me.lblSMTPPort.Text = "SMTP Port:"
        
        Me.txtSMTPPort.Location = New System.Drawing.Point(130, 147)
        Me.txtSMTPPort.Name = "txtSMTPPort"
        Me.txtSMTPPort.Size = New System.Drawing.Size(100, 22)
        Me.txtSMTPPort.TabIndex = 5
        
        Me.chkSMTPSSL.AutoSize = True
        Me.chkSMTPSSL.Location = New System.Drawing.Point(20, 190)
        Me.chkSMTPSSL.Name = "chkSMTPSSL"
        Me.chkSMTPSSL.Size = New System.Drawing.Size(108, 21)
        Me.chkSMTPSSL.TabIndex = 6
        Me.chkSMTPSSL.Text = "Use SSL/TLS"
        Me.chkSMTPSSL.UseVisualStyleBackColor = True
        
        ' tabBackup
        Me.tabBackup.Controls.Add(Me.txtBackupRetention)
        Me.tabBackup.Controls.Add(Me.lblBackupRetention)
        Me.tabBackup.Controls.Add(Me.btnBrowseBackupPath)
        Me.tabBackup.Controls.Add(Me.txtBackupPath)
        Me.tabBackup.Controls.Add(Me.lblBackupPath)
        Me.tabBackup.Controls.Add(Me.cboBackupFrequency)
        Me.tabBackup.Controls.Add(Me.lblBackupFrequency)
        Me.tabBackup.Controls.Add(Me.chkAutoBackup)
        Me.tabBackup.Location = New System.Drawing.Point(4, 25)
        Me.tabBackup.Name = "tabBackup"
        Me.tabBackup.Size = New System.Drawing.Size(552, 371)
        Me.tabBackup.TabIndex = 2
        Me.tabBackup.Text = "Backup"
        Me.tabBackup.UseVisualStyleBackColor = True
        
        ' Backup Controls
        Me.chkAutoBackup.AutoSize = True
        Me.chkAutoBackup.Location = New System.Drawing.Point(20, 30)
        Me.chkAutoBackup.Name = "chkAutoBackup"
        Me.chkAutoBackup.Size = New System.Drawing.Size(143, 21)
        Me.chkAutoBackup.TabIndex = 0
        Me.chkAutoBackup.Text = "Enable Auto Backup"
        Me.chkAutoBackup.UseVisualStyleBackColor = True
        
        Me.lblBackupFrequency.AutoSize = True
        Me.lblBackupFrequency.Location = New System.Drawing.Point(20, 70)
        Me.lblBackupFrequency.Name = "lblBackupFrequency"
        Me.lblBackupFrequency.Size = New System.Drawing.Size(123, 17)
        Me.lblBackupFrequency.TabIndex = 1
        Me.lblBackupFrequency.Text = "Backup Frequency:"
        
        Me.cboBackupFrequency.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBackupFrequency.FormattingEnabled = True
        Me.cboBackupFrequency.Items.AddRange(New Object() {"Daily", "Weekly", "Monthly"})
        Me.cboBackupFrequency.Location = New System.Drawing.Point(160, 67)
        Me.cboBackupFrequency.Name = "cboBackupFrequency"
        Me.cboBackupFrequency.Size = New System.Drawing.Size(120, 24)
        Me.cboBackupFrequency.TabIndex = 2
        
        Me.lblBackupPath.AutoSize = True
        Me.lblBackupPath.Location = New System.Drawing.Point(20, 110)
        Me.lblBackupPath.Name = "lblBackupPath"
        Me.lblBackupPath.Size = New System.Drawing.Size(90, 17)
        Me.lblBackupPath.TabIndex = 3
        Me.lblBackupPath.Text = "Backup Path:"
        
        Me.txtBackupPath.Location = New System.Drawing.Point(20, 135)
        Me.txtBackupPath.Name = "txtBackupPath"
        Me.txtBackupPath.Size = New System.Drawing.Size(400, 22)
        Me.txtBackupPath.TabIndex = 4
        
        Me.btnBrowseBackupPath.Location = New System.Drawing.Point(430, 133)
        Me.btnBrowseBackupPath.Name = "btnBrowseBackupPath"
        Me.btnBrowseBackupPath.Size = New System.Drawing.Size(80, 26)
        Me.btnBrowseBackupPath.TabIndex = 5
        Me.btnBrowseBackupPath.Text = "Browse..."
        Me.btnBrowseBackupPath.UseVisualStyleBackColor = True
        
        Me.lblBackupRetention.AutoSize = True
        Me.lblBackupRetention.Location = New System.Drawing.Point(20, 180)
        Me.lblBackupRetention.Name = "lblBackupRetention"
        Me.lblBackupRetention.Size = New System.Drawing.Size(155, 17)
        Me.lblBackupRetention.TabIndex = 6
        Me.lblBackupRetention.Text = "Retention Period (days):"
        
        Me.txtBackupRetention.Location = New System.Drawing.Point(190, 177)
        Me.txtBackupRetention.Name = "txtBackupRetention"
        Me.txtBackupRetention.Size = New System.Drawing.Size(100, 22)
        Me.txtBackupRetention.TabIndex = 7
        
        ' tabGeneral
        Me.tabGeneral.Controls.Add(Me.chkMaintenanceMode)
        Me.tabGeneral.Controls.Add(Me.cboDefaultTheme)
        Me.tabGeneral.Controls.Add(Me.lblDefaultTheme)
        Me.tabGeneral.Controls.Add(Me.cboDefaultLanguage)
        Me.tabGeneral.Controls.Add(Me.lblDefaultLanguage)
        Me.tabGeneral.Controls.Add(Me.txtCompanyName)
        Me.tabGeneral.Controls.Add(Me.lblCompanyName)
        Me.tabGeneral.Location = New System.Drawing.Point(4, 25)
        Me.tabGeneral.Name = "tabGeneral"
        Me.tabGeneral.Size = New System.Drawing.Size(552, 371)
        Me.tabGeneral.TabIndex = 3
        Me.tabGeneral.Text = "General"
        Me.tabGeneral.UseVisualStyleBackColor = True
        
        ' General Controls
        Me.lblCompanyName.AutoSize = True
        Me.lblCompanyName.Location = New System.Drawing.Point(20, 30)
        Me.lblCompanyName.Name = "lblCompanyName"
        Me.lblCompanyName.Size = New System.Drawing.Size(109, 17)
        Me.lblCompanyName.TabIndex = 0
        Me.lblCompanyName.Text = "Company Name:"
        
        Me.txtCompanyName.Location = New System.Drawing.Point(150, 27)
        Me.txtCompanyName.Name = "txtCompanyName"
        Me.txtCompanyName.Size = New System.Drawing.Size(250, 22)
        Me.txtCompanyName.TabIndex = 1
        
        Me.lblDefaultLanguage.AutoSize = True
        Me.lblDefaultLanguage.Location = New System.Drawing.Point(20, 70)
        Me.lblDefaultLanguage.Name = "lblDefaultLanguage"
        Me.lblDefaultLanguage.Size = New System.Drawing.Size(118, 17)
        Me.lblDefaultLanguage.TabIndex = 2
        Me.lblDefaultLanguage.Text = "Default Language:"
        
        Me.cboDefaultLanguage.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboDefaultLanguage.FormattingEnabled = True
        Me.cboDefaultLanguage.Items.AddRange(New Object() {"English", "Afrikaans", "Zulu"})
        Me.cboDefaultLanguage.Location = New System.Drawing.Point(150, 67)
        Me.cboDefaultLanguage.Name = "cboDefaultLanguage"
        Me.cboDefaultLanguage.Size = New System.Drawing.Size(150, 24)
        Me.cboDefaultLanguage.TabIndex = 3
        
        Me.lblDefaultTheme.AutoSize = True
        Me.lblDefaultTheme.Location = New System.Drawing.Point(20, 110)
        Me.lblDefaultTheme.Name = "lblDefaultTheme"
        Me.lblDefaultTheme.Size = New System.Drawing.Size(101, 17)
        Me.lblDefaultTheme.TabIndex = 4
        Me.lblDefaultTheme.Text = "Default Theme:"
        
        Me.cboDefaultTheme.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboDefaultTheme.FormattingEnabled = True
        Me.cboDefaultTheme.Items.AddRange(New Object() {"Light", "Dark", "Auto"})
        Me.cboDefaultTheme.Location = New System.Drawing.Point(150, 107)
        Me.cboDefaultTheme.Name = "cboDefaultTheme"
        Me.cboDefaultTheme.Size = New System.Drawing.Size(150, 24)
        Me.cboDefaultTheme.TabIndex = 5
        
        Me.chkMaintenanceMode.AutoSize = True
        Me.chkMaintenanceMode.Location = New System.Drawing.Point(20, 150)
        Me.chkMaintenanceMode.Name = "chkMaintenanceMode"
        Me.chkMaintenanceMode.Size = New System.Drawing.Size(140, 21)
        Me.chkMaintenanceMode.TabIndex = 6
        Me.chkMaintenanceMode.Text = "Maintenance Mode"
        Me.chkMaintenanceMode.UseVisualStyleBackColor = True
        
        ' Action Buttons
        Me.btnSave.Location = New System.Drawing.Point(300, 430)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(100, 35)
        Me.btnSave.TabIndex = 1
        Me.btnSave.Text = "Save Settings"
        Me.btnSave.UseVisualStyleBackColor = True
        
        Me.btnTestConnection.Location = New System.Drawing.Point(420, 430)
        Me.btnTestConnection.Name = "btnTestConnection"
        Me.btnTestConnection.Size = New System.Drawing.Size(120, 35)
        Me.btnTestConnection.TabIndex = 2
        Me.btnTestConnection.Text = "Test Connection"
        Me.btnTestConnection.UseVisualStyleBackColor = True
        
        Me.btnCancel.Location = New System.Drawing.Point(560, 430)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(80, 35)
        Me.btnCancel.TabIndex = 3
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        
        ' SystemSettingsForm
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(660, 480)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnTestConnection)
        Me.Controls.Add(Me.btnSave)
        Me.Controls.Add(Me.tabControl)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "SystemSettingsForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "System Settings"
        Me.tabControl.ResumeLayout(False)
        Me.tabSecurity.ResumeLayout(False)
        Me.tabSecurity.PerformLayout()
        Me.tabNotifications.ResumeLayout(False)
        Me.tabNotifications.PerformLayout()
        Me.tabBackup.ResumeLayout(False)
        Me.tabBackup.PerformLayout()
        Me.tabGeneral.ResumeLayout(False)
        Me.tabGeneral.PerformLayout()
        Me.ResumeLayout(False)
    End Sub
End Class
