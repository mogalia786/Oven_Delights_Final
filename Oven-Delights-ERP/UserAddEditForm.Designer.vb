<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class UserAddEditForm
    Inherits System.Windows.Forms.Form

    Private components As System.ComponentModel.IContainer
    Friend WithEvents lblUsername As System.Windows.Forms.Label
    Friend WithEvents txtUsername As System.Windows.Forms.TextBox
    Friend WithEvents lblPassword As System.Windows.Forms.Label
    Friend WithEvents txtPassword As System.Windows.Forms.TextBox
    Friend WithEvents lblEmail As System.Windows.Forms.Label
    Friend WithEvents txtEmail As System.Windows.Forms.TextBox
    Friend WithEvents lblFirstName As System.Windows.Forms.Label
    Friend WithEvents txtFirstName As System.Windows.Forms.TextBox
    Friend WithEvents lblLastName As System.Windows.Forms.Label
    Friend WithEvents txtLastName As System.Windows.Forms.TextBox
    Friend WithEvents lblRole As System.Windows.Forms.Label
    Friend WithEvents cboRole As System.Windows.Forms.ComboBox
    Friend WithEvents lblBranch As System.Windows.Forms.Label
    Friend WithEvents cboBranch As System.Windows.Forms.ComboBox
    Friend WithEvents chkIsActive As System.Windows.Forms.CheckBox
    Friend WithEvents btnSave As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.lblUsername = New System.Windows.Forms.Label()
        Me.txtUsername = New System.Windows.Forms.TextBox()
        Me.lblPassword = New System.Windows.Forms.Label()
        Me.txtPassword = New System.Windows.Forms.TextBox()
        Me.lblEmail = New System.Windows.Forms.Label()
        Me.txtEmail = New System.Windows.Forms.TextBox()
        Me.lblFirstName = New System.Windows.Forms.Label()
        Me.txtFirstName = New System.Windows.Forms.TextBox()
        Me.lblLastName = New System.Windows.Forms.Label()
        Me.txtLastName = New System.Windows.Forms.TextBox()
        Me.lblRole = New System.Windows.Forms.Label()
        Me.cboRole = New System.Windows.Forms.ComboBox()
        Me.lblBranch = New System.Windows.Forms.Label()
        Me.cboBranch = New System.Windows.Forms.ComboBox()
        Me.chkIsActive = New System.Windows.Forms.CheckBox()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        
        ' lblUsername
        Me.lblUsername.AutoSize = True
        Me.lblUsername.Location = New System.Drawing.Point(20, 20)
        Me.lblUsername.Name = "lblUsername"
        Me.lblUsername.Size = New System.Drawing.Size(73, 17)
        Me.lblUsername.TabIndex = 0
        Me.lblUsername.Text = "Username:"
        
        ' txtUsername
        Me.txtUsername.Location = New System.Drawing.Point(120, 17)
        Me.txtUsername.Name = "txtUsername"
        Me.txtUsername.Size = New System.Drawing.Size(200, 22)
        Me.txtUsername.TabIndex = 1
        
        ' lblPassword
        Me.lblPassword.AutoSize = True
        Me.lblPassword.Location = New System.Drawing.Point(20, 55)
        Me.lblPassword.Name = "lblPassword"
        Me.lblPassword.Size = New System.Drawing.Size(69, 17)
        Me.lblPassword.TabIndex = 2
        Me.lblPassword.Text = "Password:"
        
        ' txtPassword
        Me.txtPassword.Location = New System.Drawing.Point(120, 52)
        Me.txtPassword.Name = "txtPassword"
        Me.txtPassword.PasswordChar = "*"c
        Me.txtPassword.Size = New System.Drawing.Size(200, 22)
        Me.txtPassword.TabIndex = 3
        
        ' lblEmail
        Me.lblEmail.AutoSize = True
        Me.lblEmail.Location = New System.Drawing.Point(20, 90)
        Me.lblEmail.Name = "lblEmail"
        Me.lblEmail.Size = New System.Drawing.Size(46, 17)
        Me.lblEmail.TabIndex = 4
        Me.lblEmail.Text = "Email:"
        
        ' txtEmail
        Me.txtEmail.Location = New System.Drawing.Point(120, 87)
        Me.txtEmail.Name = "txtEmail"
        Me.txtEmail.Size = New System.Drawing.Size(200, 22)
        Me.txtEmail.TabIndex = 5
        
        ' lblFirstName
        Me.lblFirstName.AutoSize = True
        Me.lblFirstName.Location = New System.Drawing.Point(20, 125)
        Me.lblFirstName.Name = "lblFirstName"
        Me.lblFirstName.Size = New System.Drawing.Size(80, 17)
        Me.lblFirstName.TabIndex = 6
        Me.lblFirstName.Text = "First Name:"
        
        ' txtFirstName
        Me.txtFirstName.Location = New System.Drawing.Point(120, 122)
        Me.txtFirstName.Name = "txtFirstName"
        Me.txtFirstName.Size = New System.Drawing.Size(200, 22)
        Me.txtFirstName.TabIndex = 7
        
        ' lblLastName
        Me.lblLastName.AutoSize = True
        Me.lblLastName.Location = New System.Drawing.Point(20, 160)
        Me.lblLastName.Name = "lblLastName"
        Me.lblLastName.Size = New System.Drawing.Size(79, 17)
        Me.lblLastName.TabIndex = 8
        Me.lblLastName.Text = "Last Name:"
        
        ' txtLastName
        Me.txtLastName.Location = New System.Drawing.Point(120, 157)
        Me.txtLastName.Name = "txtLastName"
        Me.txtLastName.Size = New System.Drawing.Size(200, 22)
        Me.txtLastName.TabIndex = 9
        
        ' lblRole
        Me.lblRole.AutoSize = True
        Me.lblRole.Location = New System.Drawing.Point(20, 195)
        Me.lblRole.Name = "lblRole"
        Me.lblRole.Size = New System.Drawing.Size(41, 17)
        Me.lblRole.TabIndex = 10
        Me.lblRole.Text = "Role:"
        
        ' cboRole
        Me.cboRole.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboRole.FormattingEnabled = True
        Me.cboRole.Location = New System.Drawing.Point(120, 192)
        Me.cboRole.Name = "cboRole"
        Me.cboRole.Size = New System.Drawing.Size(200, 24)
        Me.cboRole.TabIndex = 11
        
        ' lblBranch
        Me.lblBranch.AutoSize = True
        Me.lblBranch.Location = New System.Drawing.Point(20, 230)
        Me.lblBranch.Name = "lblBranch"
        Me.lblBranch.Size = New System.Drawing.Size(55, 17)
        Me.lblBranch.TabIndex = 12
        Me.lblBranch.Text = "Branch:"
        
        ' cboBranch
        Me.cboBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBranch.FormattingEnabled = True
        Me.cboBranch.Location = New System.Drawing.Point(120, 227)
        Me.cboBranch.Name = "cboBranch"
        Me.cboBranch.Size = New System.Drawing.Size(200, 24)
        Me.cboBranch.TabIndex = 13
        
        ' chkIsActive
        Me.chkIsActive.AutoSize = True
        Me.chkIsActive.Checked = True
        Me.chkIsActive.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkIsActive.Location = New System.Drawing.Point(120, 265)
        Me.chkIsActive.Name = "chkIsActive"
        Me.chkIsActive.Size = New System.Drawing.Size(74, 21)
        Me.chkIsActive.TabIndex = 14
        Me.chkIsActive.Text = "Is Active"
        Me.chkIsActive.UseVisualStyleBackColor = True
        
        ' btnSave
        Me.btnSave.Location = New System.Drawing.Point(120, 310)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(90, 35)
        Me.btnSave.TabIndex = 15
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = True
        
        ' btnCancel
        Me.btnCancel.Location = New System.Drawing.Point(230, 310)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(90, 35)
        Me.btnCancel.TabIndex = 16
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        
        ' UserAddEditForm
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(360, 370)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnSave)
        Me.Controls.Add(Me.chkIsActive)
        Me.Controls.Add(Me.cboBranch)
        Me.Controls.Add(Me.lblBranch)
        Me.Controls.Add(Me.cboRole)
        Me.Controls.Add(Me.lblRole)
        Me.Controls.Add(Me.txtLastName)
        Me.Controls.Add(Me.lblLastName)
        Me.Controls.Add(Me.txtFirstName)
        Me.Controls.Add(Me.lblFirstName)
        Me.Controls.Add(Me.txtEmail)
        Me.Controls.Add(Me.lblEmail)
        Me.Controls.Add(Me.txtPassword)
        Me.Controls.Add(Me.lblPassword)
        Me.Controls.Add(Me.txtUsername)
        Me.Controls.Add(Me.lblUsername)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "UserAddEditForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "User Management"
        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub
End Class
