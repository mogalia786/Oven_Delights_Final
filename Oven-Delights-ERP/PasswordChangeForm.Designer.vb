<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class PasswordChangeForm
    Inherits System.Windows.Forms.Form

    Private components As System.ComponentModel.IContainer
    Friend WithEvents lblCurrentPassword As System.Windows.Forms.Label
    Friend WithEvents txtCurrentPassword As System.Windows.Forms.TextBox
    Friend WithEvents lblNewPassword As System.Windows.Forms.Label
    Friend WithEvents txtNewPassword As System.Windows.Forms.TextBox
    Friend WithEvents lblConfirmPassword As System.Windows.Forms.Label
    Friend WithEvents txtConfirmPassword As System.Windows.Forms.TextBox
    Friend WithEvents lblPasswordStrength As System.Windows.Forms.Label
    Friend WithEvents btnChangePassword As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.lblCurrentPassword = New System.Windows.Forms.Label()
        Me.txtCurrentPassword = New System.Windows.Forms.TextBox()
        Me.lblNewPassword = New System.Windows.Forms.Label()
        Me.txtNewPassword = New System.Windows.Forms.TextBox()
        Me.lblConfirmPassword = New System.Windows.Forms.Label()
        Me.txtConfirmPassword = New System.Windows.Forms.TextBox()
        Me.lblPasswordStrength = New System.Windows.Forms.Label()
        Me.btnChangePassword = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        
        ' lblCurrentPassword
        Me.lblCurrentPassword.AutoSize = True
        Me.lblCurrentPassword.Location = New System.Drawing.Point(20, 20)
        Me.lblCurrentPassword.Name = "lblCurrentPassword"
        Me.lblCurrentPassword.Size = New System.Drawing.Size(124, 17)
        Me.lblCurrentPassword.TabIndex = 0
        Me.lblCurrentPassword.Text = "Current Password:"
        
        ' txtCurrentPassword
        Me.txtCurrentPassword.Location = New System.Drawing.Point(160, 17)
        Me.txtCurrentPassword.Name = "txtCurrentPassword"
        Me.txtCurrentPassword.PasswordChar = "*"c
        Me.txtCurrentPassword.Size = New System.Drawing.Size(200, 22)
        Me.txtCurrentPassword.TabIndex = 1
        
        ' lblNewPassword
        Me.lblNewPassword.AutoSize = True
        Me.lblNewPassword.Location = New System.Drawing.Point(20, 55)
        Me.lblNewPassword.Name = "lblNewPassword"
        Me.lblNewPassword.Size = New System.Drawing.Size(104, 17)
        Me.lblNewPassword.TabIndex = 2
        Me.lblNewPassword.Text = "New Password:"
        
        ' txtNewPassword
        Me.txtNewPassword.Location = New System.Drawing.Point(160, 52)
        Me.txtNewPassword.Name = "txtNewPassword"
        Me.txtNewPassword.PasswordChar = "*"c
        Me.txtNewPassword.Size = New System.Drawing.Size(200, 22)
        Me.txtNewPassword.TabIndex = 3
        
        ' lblConfirmPassword
        Me.lblConfirmPassword.AutoSize = True
        Me.lblConfirmPassword.Location = New System.Drawing.Point(20, 90)
        Me.lblConfirmPassword.Name = "lblConfirmPassword"
        Me.lblConfirmPassword.Size = New System.Drawing.Size(125, 17)
        Me.lblConfirmPassword.TabIndex = 4
        Me.lblConfirmPassword.Text = "Confirm Password:"
        
        ' txtConfirmPassword
        Me.txtConfirmPassword.Location = New System.Drawing.Point(160, 87)
        Me.txtConfirmPassword.Name = "txtConfirmPassword"
        Me.txtConfirmPassword.PasswordChar = "*"c
        Me.txtConfirmPassword.Size = New System.Drawing.Size(200, 22)
        Me.txtConfirmPassword.TabIndex = 5
        
        ' lblPasswordStrength
        Me.lblPasswordStrength.AutoSize = True
        Me.lblPasswordStrength.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.8!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblPasswordStrength.Location = New System.Drawing.Point(160, 120)
        Me.lblPasswordStrength.Name = "lblPasswordStrength"
        Me.lblPasswordStrength.Size = New System.Drawing.Size(0, 17)
        Me.lblPasswordStrength.TabIndex = 6
        
        ' btnChangePassword
        Me.btnChangePassword.Location = New System.Drawing.Point(160, 160)
        Me.btnChangePassword.Name = "btnChangePassword"
        Me.btnChangePassword.Size = New System.Drawing.Size(130, 35)
        Me.btnChangePassword.TabIndex = 7
        Me.btnChangePassword.Text = "Change Password"
        Me.btnChangePassword.UseVisualStyleBackColor = True
        
        ' btnCancel
        Me.btnCancel.Location = New System.Drawing.Point(300, 160)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(80, 35)
        Me.btnCancel.TabIndex = 8
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        
        ' PasswordChangeForm
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(400, 220)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnChangePassword)
        Me.Controls.Add(Me.lblPasswordStrength)
        Me.Controls.Add(Me.txtConfirmPassword)
        Me.Controls.Add(Me.lblConfirmPassword)
        Me.Controls.Add(Me.txtNewPassword)
        Me.Controls.Add(Me.lblNewPassword)
        Me.Controls.Add(Me.txtCurrentPassword)
        Me.Controls.Add(Me.lblCurrentPassword)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "PasswordChangeForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Change Password"
        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub
End Class
