<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class BranchAddEditForm
    Inherits System.Windows.Forms.Form

    Private components As System.ComponentModel.IContainer
    Friend WithEvents lblName As System.Windows.Forms.Label
    Friend WithEvents txtName As System.Windows.Forms.TextBox
    Friend WithEvents lblAddress As System.Windows.Forms.Label
    Friend WithEvents txtAddress As System.Windows.Forms.TextBox
    Friend WithEvents lblPhone As System.Windows.Forms.Label
    Friend WithEvents txtPhone As System.Windows.Forms.TextBox
    Friend WithEvents lblEmail As System.Windows.Forms.Label
    Friend WithEvents txtEmail As System.Windows.Forms.TextBox
    Friend WithEvents lblManager As System.Windows.Forms.Label
    Friend WithEvents txtManager As System.Windows.Forms.TextBox
    Friend WithEvents chkIsActive As System.Windows.Forms.CheckBox
    Friend WithEvents btnSave As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.lblName = New System.Windows.Forms.Label()
        Me.txtName = New System.Windows.Forms.TextBox()
        Me.lblAddress = New System.Windows.Forms.Label()
        Me.txtAddress = New System.Windows.Forms.TextBox()
        Me.lblPhone = New System.Windows.Forms.Label()
        Me.txtPhone = New System.Windows.Forms.TextBox()
        Me.lblEmail = New System.Windows.Forms.Label()
        Me.txtEmail = New System.Windows.Forms.TextBox()
        Me.lblManager = New System.Windows.Forms.Label()
        Me.txtManager = New System.Windows.Forms.TextBox()
        Me.chkIsActive = New System.Windows.Forms.CheckBox()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        
        ' lblName
        Me.lblName.AutoSize = True
        Me.lblName.Location = New System.Drawing.Point(20, 20)
        Me.lblName.Name = "lblName"
        Me.lblName.Size = New System.Drawing.Size(49, 17)
        Me.lblName.TabIndex = 0
        Me.lblName.Text = "Name:"
        
        ' txtName
        Me.txtName.Location = New System.Drawing.Point(120, 17)
        Me.txtName.Name = "txtName"
        Me.txtName.Size = New System.Drawing.Size(250, 22)
        Me.txtName.TabIndex = 1
        
        ' lblAddress
        Me.lblAddress.AutoSize = True
        Me.lblAddress.Location = New System.Drawing.Point(20, 55)
        Me.lblAddress.Name = "lblAddress"
        Me.lblAddress.Size = New System.Drawing.Size(64, 17)
        Me.lblAddress.TabIndex = 2
        Me.lblAddress.Text = "Address:"
        
        ' txtAddress
        Me.txtAddress.Location = New System.Drawing.Point(120, 52)
        Me.txtAddress.Multiline = True
        Me.txtAddress.Name = "txtAddress"
        Me.txtAddress.Size = New System.Drawing.Size(250, 60)
        Me.txtAddress.TabIndex = 3
        
        ' lblPhone
        Me.lblPhone.AutoSize = True
        Me.lblPhone.Location = New System.Drawing.Point(20, 125)
        Me.lblPhone.Name = "lblPhone"
        Me.lblPhone.Size = New System.Drawing.Size(52, 17)
        Me.lblPhone.TabIndex = 4
        Me.lblPhone.Text = "Phone:"
        
        ' txtPhone
        Me.txtPhone.Location = New System.Drawing.Point(120, 122)
        Me.txtPhone.Name = "txtPhone"
        Me.txtPhone.Size = New System.Drawing.Size(250, 22)
        Me.txtPhone.TabIndex = 5
        
        ' lblEmail
        Me.lblEmail.AutoSize = True
        Me.lblEmail.Location = New System.Drawing.Point(20, 160)
        Me.lblEmail.Name = "lblEmail"
        Me.lblEmail.Size = New System.Drawing.Size(46, 17)
        Me.lblEmail.TabIndex = 6
        Me.lblEmail.Text = "Email:"
        
        ' txtEmail
        Me.txtEmail.Location = New System.Drawing.Point(120, 157)
        Me.txtEmail.Name = "txtEmail"
        Me.txtEmail.Size = New System.Drawing.Size(250, 22)
        Me.txtEmail.TabIndex = 7
        
        ' lblManager
        Me.lblManager.AutoSize = True
        Me.lblManager.Location = New System.Drawing.Point(20, 195)
        Me.lblManager.Name = "lblManager"
        Me.lblManager.Size = New System.Drawing.Size(67, 17)
        Me.lblManager.TabIndex = 8
        Me.lblManager.Text = "Manager:"
        
        ' txtManager
        Me.txtManager.Location = New System.Drawing.Point(120, 192)
        Me.txtManager.Name = "txtManager"
        Me.txtManager.Size = New System.Drawing.Size(250, 22)
        Me.txtManager.TabIndex = 9
        
        ' chkIsActive
        Me.chkIsActive.AutoSize = True
        Me.chkIsActive.Checked = True
        Me.chkIsActive.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkIsActive.Location = New System.Drawing.Point(120, 230)
        Me.chkIsActive.Name = "chkIsActive"
        Me.chkIsActive.Size = New System.Drawing.Size(74, 21)
        Me.chkIsActive.TabIndex = 10
        Me.chkIsActive.Text = "Is Active"
        Me.chkIsActive.UseVisualStyleBackColor = True
        
        ' btnSave
        Me.btnSave.Location = New System.Drawing.Point(120, 270)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(90, 35)
        Me.btnSave.TabIndex = 11
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = True
        
        ' btnCancel
        Me.btnCancel.Location = New System.Drawing.Point(230, 270)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(90, 35)
        Me.btnCancel.TabIndex = 12
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        
        ' BranchAddEditForm
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(400, 330)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnSave)
        Me.Controls.Add(Me.chkIsActive)
        Me.Controls.Add(Me.txtManager)
        Me.Controls.Add(Me.lblManager)
        Me.Controls.Add(Me.txtEmail)
        Me.Controls.Add(Me.lblEmail)
        Me.Controls.Add(Me.txtPhone)
        Me.Controls.Add(Me.lblPhone)
        Me.Controls.Add(Me.txtAddress)
        Me.Controls.Add(Me.lblAddress)
        Me.Controls.Add(Me.txtName)
        Me.Controls.Add(Me.lblName)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "BranchAddEditForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Branch Management"
        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub
End Class
