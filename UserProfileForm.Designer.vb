<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class UserProfileForm
    Inherits System.Windows.Forms.Form

    Private components As System.ComponentModel.IContainer
    Friend WithEvents picProfilePhoto As System.Windows.Forms.PictureBox
    Friend WithEvents btnUploadPhoto As System.Windows.Forms.Button
    Friend WithEvents lblUsername As System.Windows.Forms.Label
    Friend WithEvents txtUsername As System.Windows.Forms.TextBox
    Friend WithEvents lblEmail As System.Windows.Forms.Label
    Friend WithEvents txtEmail As System.Windows.Forms.TextBox
    Friend WithEvents lblFirstName As System.Windows.Forms.Label
    Friend WithEvents txtFirstName As System.Windows.Forms.TextBox
    Friend WithEvents lblLastName As System.Windows.Forms.Label
    Friend WithEvents txtLastName As System.Windows.Forms.TextBox
    Friend WithEvents lblRole As System.Windows.Forms.Label
    Friend WithEvents lblCreatedDate As System.Windows.Forms.Label
    Friend WithEvents lblLastLogin As System.Windows.Forms.Label
    Friend WithEvents grpPreferences As System.Windows.Forms.GroupBox
    Friend WithEvents lblTheme As System.Windows.Forms.Label
    Friend WithEvents cboTheme As System.Windows.Forms.ComboBox
    Friend WithEvents lblLanguage As System.Windows.Forms.Label
    Friend WithEvents cboLanguage As System.Windows.Forms.ComboBox
    Friend WithEvents chkEmailNotifications As System.Windows.Forms.CheckBox
    Friend WithEvents chkTwoFactor As System.Windows.Forms.CheckBox
    Friend WithEvents btnSaveProfile As System.Windows.Forms.Button
    Friend WithEvents btnChangePassword As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.picProfilePhoto = New System.Windows.Forms.PictureBox()
        Me.btnUploadPhoto = New System.Windows.Forms.Button()
        Me.lblUsername = New System.Windows.Forms.Label()
        Me.txtUsername = New System.Windows.Forms.TextBox()
        Me.lblEmail = New System.Windows.Forms.Label()
        Me.txtEmail = New System.Windows.Forms.TextBox()
        Me.lblFirstName = New System.Windows.Forms.Label()
        Me.txtFirstName = New System.Windows.Forms.TextBox()
        Me.lblLastName = New System.Windows.Forms.Label()
        Me.txtLastName = New System.Windows.Forms.TextBox()
        Me.lblRole = New System.Windows.Forms.Label()
        Me.lblCreatedDate = New System.Windows.Forms.Label()
        Me.lblLastLogin = New System.Windows.Forms.Label()
        Me.grpPreferences = New System.Windows.Forms.GroupBox()
        Me.lblTheme = New System.Windows.Forms.Label()
        Me.cboTheme = New System.Windows.Forms.ComboBox()
        Me.lblLanguage = New System.Windows.Forms.Label()
        Me.cboLanguage = New System.Windows.Forms.ComboBox()
        Me.chkEmailNotifications = New System.Windows.Forms.CheckBox()
        Me.chkTwoFactor = New System.Windows.Forms.CheckBox()
        Me.btnSaveProfile = New System.Windows.Forms.Button()
        Me.btnChangePassword = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        CType(Me.picProfilePhoto, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.grpPreferences.SuspendLayout()
        Me.SuspendLayout()
        
        ' picProfilePhoto
        Me.picProfilePhoto.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.picProfilePhoto.Location = New System.Drawing.Point(20, 20)
        Me.picProfilePhoto.Name = "picProfilePhoto"
        Me.picProfilePhoto.Size = New System.Drawing.Size(150, 150)
        Me.picProfilePhoto.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.picProfilePhoto.TabIndex = 0
        Me.picProfilePhoto.TabStop = False
        
        ' btnUploadPhoto
        Me.btnUploadPhoto.Location = New System.Drawing.Point(20, 180)
        Me.btnUploadPhoto.Name = "btnUploadPhoto"
        Me.btnUploadPhoto.Size = New System.Drawing.Size(150, 30)
        Me.btnUploadPhoto.TabIndex = 1
        Me.btnUploadPhoto.Text = "Upload Photo"
        Me.btnUploadPhoto.UseVisualStyleBackColor = True
        
        ' Profile Information
        Me.lblUsername.AutoSize = True
        Me.lblUsername.Location = New System.Drawing.Point(200, 20)
        Me.lblUsername.Name = "lblUsername"
        Me.lblUsername.Size = New System.Drawing.Size(73, 17)
        Me.lblUsername.TabIndex = 2
        Me.lblUsername.Text = "Username:"
        
        Me.txtUsername.Location = New System.Drawing.Point(300, 17)
        Me.txtUsername.Name = "txtUsername"
        Me.txtUsername.ReadOnly = True
        Me.txtUsername.Size = New System.Drawing.Size(200, 22)
        Me.txtUsername.TabIndex = 3
        
        Me.lblEmail.AutoSize = True
        Me.lblEmail.Location = New System.Drawing.Point(200, 55)
        Me.lblEmail.Name = "lblEmail"
        Me.lblEmail.Size = New System.Drawing.Size(46, 17)
        Me.lblEmail.TabIndex = 4
        Me.lblEmail.Text = "Email:"
        
        Me.txtEmail.Location = New System.Drawing.Point(300, 52)
        Me.txtEmail.Name = "txtEmail"
        Me.txtEmail.Size = New System.Drawing.Size(200, 22)
        Me.txtEmail.TabIndex = 5
        
        Me.lblFirstName.AutoSize = True
        Me.lblFirstName.Location = New System.Drawing.Point(200, 90)
        Me.lblFirstName.Name = "lblFirstName"
        Me.lblFirstName.Size = New System.Drawing.Size(80, 17)
        Me.lblFirstName.TabIndex = 6
        Me.lblFirstName.Text = "First Name:"
        
        Me.txtFirstName.Location = New System.Drawing.Point(300, 87)
        Me.txtFirstName.Name = "txtFirstName"
        Me.txtFirstName.Size = New System.Drawing.Size(200, 22)
        Me.txtFirstName.TabIndex = 7
        
        Me.lblLastName.AutoSize = True
        Me.lblLastName.Location = New System.Drawing.Point(200, 125)
        Me.lblLastName.Name = "lblLastName"
        Me.lblLastName.Size = New System.Drawing.Size(79, 17)
        Me.lblLastName.TabIndex = 8
        Me.lblLastName.Text = "Last Name:"
        
        Me.txtLastName.Location = New System.Drawing.Point(300, 122)
        Me.txtLastName.Name = "txtLastName"
        Me.txtLastName.Size = New System.Drawing.Size(200, 22)
        Me.txtLastName.TabIndex = 9
        
        Me.lblRole.AutoSize = True
        Me.lblRole.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.8!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRole.Location = New System.Drawing.Point(200, 160)
        Me.lblRole.Name = "lblRole"
        Me.lblRole.Size = New System.Drawing.Size(41, 17)
        Me.lblRole.TabIndex = 10
        Me.lblRole.Text = "Role:"
        
        Me.lblCreatedDate.AutoSize = True
        Me.lblCreatedDate.Location = New System.Drawing.Point(200, 185)
        Me.lblCreatedDate.Name = "lblCreatedDate"
        Me.lblCreatedDate.Size = New System.Drawing.Size(106, 17)
        Me.lblCreatedDate.TabIndex = 11
        Me.lblCreatedDate.Text = "Member Since:"
        
        Me.lblLastLogin.AutoSize = True
        Me.lblLastLogin.Location = New System.Drawing.Point(200, 210)
        Me.lblLastLogin.Name = "lblLastLogin"
        Me.lblLastLogin.Size = New System.Drawing.Size(81, 17)
        Me.lblLastLogin.TabIndex = 12
        Me.lblLastLogin.Text = "Last Login:"
        
        ' Preferences Group
        Me.grpPreferences.Controls.Add(Me.chkTwoFactor)
        Me.grpPreferences.Controls.Add(Me.chkEmailNotifications)
        Me.grpPreferences.Controls.Add(Me.cboLanguage)
        Me.grpPreferences.Controls.Add(Me.lblLanguage)
        Me.grpPreferences.Controls.Add(Me.cboTheme)
        Me.grpPreferences.Controls.Add(Me.lblTheme)
        Me.grpPreferences.Location = New System.Drawing.Point(20, 240)
        Me.grpPreferences.Name = "grpPreferences"
        Me.grpPreferences.Size = New System.Drawing.Size(480, 150)
        Me.grpPreferences.TabIndex = 13
        Me.grpPreferences.TabStop = False
        Me.grpPreferences.Text = "Preferences"
        
        Me.lblTheme.AutoSize = True
        Me.lblTheme.Location = New System.Drawing.Point(20, 30)
        Me.lblTheme.Name = "lblTheme"
        Me.lblTheme.Size = New System.Drawing.Size(54, 17)
        Me.lblTheme.TabIndex = 0
        Me.lblTheme.Text = "Theme:"
        
        Me.cboTheme.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboTheme.FormattingEnabled = True
        Me.cboTheme.Items.AddRange(New Object() {"Light", "Dark", "Auto"})
        Me.cboTheme.Location = New System.Drawing.Point(100, 27)
        Me.cboTheme.Name = "cboTheme"
        Me.cboTheme.Size = New System.Drawing.Size(120, 24)
        Me.cboTheme.TabIndex = 1
        
        Me.lblLanguage.AutoSize = True
        Me.lblLanguage.Location = New System.Drawing.Point(250, 30)
        Me.lblLanguage.Name = "lblLanguage"
        Me.lblLanguage.Size = New System.Drawing.Size(76, 17)
        Me.lblLanguage.TabIndex = 2
        Me.lblLanguage.Text = "Language:"
        
        Me.cboLanguage.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboLanguage.FormattingEnabled = True
        Me.cboLanguage.Items.AddRange(New Object() {"English", "Afrikaans", "Zulu"})
        Me.cboLanguage.Location = New System.Drawing.Point(330, 27)
        Me.cboLanguage.Name = "cboLanguage"
        Me.cboLanguage.Size = New System.Drawing.Size(120, 24)
        Me.cboLanguage.TabIndex = 3
        
        Me.chkEmailNotifications.AutoSize = True
        Me.chkEmailNotifications.Location = New System.Drawing.Point(20, 70)
        Me.chkEmailNotifications.Name = "chkEmailNotifications"
        Me.chkEmailNotifications.Size = New System.Drawing.Size(141, 21)
        Me.chkEmailNotifications.TabIndex = 4
        Me.chkEmailNotifications.Text = "Email Notifications"
        Me.chkEmailNotifications.UseVisualStyleBackColor = True
        
        Me.chkTwoFactor.AutoSize = True
        Me.chkTwoFactor.Location = New System.Drawing.Point(20, 100)
        Me.chkTwoFactor.Name = "chkTwoFactor"
        Me.chkTwoFactor.Size = New System.Drawing.Size(180, 21)
        Me.chkTwoFactor.TabIndex = 5
        Me.chkTwoFactor.Text = "Two-Factor Authentication"
        Me.chkTwoFactor.UseVisualStyleBackColor = True
        
        ' Buttons
        Me.btnSaveProfile.Location = New System.Drawing.Point(200, 410)
        Me.btnSaveProfile.Name = "btnSaveProfile"
        Me.btnSaveProfile.Size = New System.Drawing.Size(100, 35)
        Me.btnSaveProfile.TabIndex = 14
        Me.btnSaveProfile.Text = "Save Profile"
        Me.btnSaveProfile.UseVisualStyleBackColor = True
        
        Me.btnChangePassword.Location = New System.Drawing.Point(320, 410)
        Me.btnChangePassword.Name = "btnChangePassword"
        Me.btnChangePassword.Size = New System.Drawing.Size(130, 35)
        Me.btnChangePassword.TabIndex = 15
        Me.btnChangePassword.Text = "Change Password"
        Me.btnChangePassword.UseVisualStyleBackColor = True
        
        Me.btnCancel.Location = New System.Drawing.Point(470, 410)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(80, 35)
        Me.btnCancel.TabIndex = 16
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        
        ' UserProfileForm
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(570, 470)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnChangePassword)
        Me.Controls.Add(Me.btnSaveProfile)
        Me.Controls.Add(Me.grpPreferences)
        Me.Controls.Add(Me.lblLastLogin)
        Me.Controls.Add(Me.lblCreatedDate)
        Me.Controls.Add(Me.lblRole)
        Me.Controls.Add(Me.txtLastName)
        Me.Controls.Add(Me.lblLastName)
        Me.Controls.Add(Me.txtFirstName)
        Me.Controls.Add(Me.lblFirstName)
        Me.Controls.Add(Me.txtEmail)
        Me.Controls.Add(Me.lblEmail)
        Me.Controls.Add(Me.txtUsername)
        Me.Controls.Add(Me.lblUsername)
        Me.Controls.Add(Me.btnUploadPhoto)
        Me.Controls.Add(Me.picProfilePhoto)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "UserProfileForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "User Profile"
        CType(Me.picProfilePhoto, System.ComponentModel.ISupportInitialize).EndInit()
        Me.grpPreferences.ResumeLayout(False)
        Me.grpPreferences.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub
End Class
