<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class BranchAddEditForm
    Inherits System.Windows.Forms.Form

    Private components As System.ComponentModel.IContainer
    Friend WithEvents lblName As System.Windows.Forms.Label
    Friend WithEvents txtName As System.Windows.Forms.TextBox
    Friend WithEvents lblBranchCode As System.Windows.Forms.Label
    Friend WithEvents txtBranchCode As System.Windows.Forms.TextBox
    Friend WithEvents lblPrefix As System.Windows.Forms.Label
    Friend WithEvents txtPrefix As System.Windows.Forms.TextBox
    Friend WithEvents lblAddress As System.Windows.Forms.Label
    Friend WithEvents txtAddress As System.Windows.Forms.TextBox
    Friend WithEvents lblCity As System.Windows.Forms.Label
    Friend WithEvents txtCity As System.Windows.Forms.TextBox
    Friend WithEvents lblProvince As System.Windows.Forms.Label
    Friend WithEvents txtProvince As System.Windows.Forms.TextBox
    Friend WithEvents lblPostalCode As System.Windows.Forms.Label
    Friend WithEvents txtPostalCode As System.Windows.Forms.TextBox
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
        Me.lblBranchCode = New System.Windows.Forms.Label()
        Me.txtBranchCode = New System.Windows.Forms.TextBox()
        Me.lblPrefix = New System.Windows.Forms.Label()
        Me.txtPrefix = New System.Windows.Forms.TextBox()
        Me.lblAddress = New System.Windows.Forms.Label()
        Me.txtAddress = New System.Windows.Forms.TextBox()
        Me.lblCity = New System.Windows.Forms.Label()
        Me.txtCity = New System.Windows.Forms.TextBox()
        Me.lblProvince = New System.Windows.Forms.Label()
        Me.txtProvince = New System.Windows.Forms.TextBox()
        Me.lblPostalCode = New System.Windows.Forms.Label()
        Me.txtPostalCode = New System.Windows.Forms.TextBox()
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
        Me.lblName.Size = New System.Drawing.Size(94, 17)
        Me.lblName.TabIndex = 0
        Me.lblName.Text = "Branch Name:"
        
        ' txtName
        Me.txtName.Location = New System.Drawing.Point(150, 17)
        Me.txtName.Name = "txtName"
        Me.txtName.Size = New System.Drawing.Size(300, 22)
        Me.txtName.TabIndex = 1
        
        ' lblBranchCode
        Me.lblBranchCode.AutoSize = True
        Me.lblBranchCode.Location = New System.Drawing.Point(20, 55)
        Me.lblBranchCode.Name = "lblBranchCode"
        Me.lblBranchCode.Size = New System.Drawing.Size(93, 17)
        Me.lblBranchCode.TabIndex = 2
        Me.lblBranchCode.Text = "Branch Code:"
        
        ' txtBranchCode
        Me.txtBranchCode.Location = New System.Drawing.Point(150, 52)
        Me.txtBranchCode.Name = "txtBranchCode"
        Me.txtBranchCode.Size = New System.Drawing.Size(150, 22)
        Me.txtBranchCode.TabIndex = 3
        
        ' lblPrefix
        Me.lblPrefix.AutoSize = True
        Me.lblPrefix.Location = New System.Drawing.Point(320, 55)
        Me.lblPrefix.Name = "lblPrefix"
        Me.lblPrefix.Size = New System.Drawing.Size(44, 17)
        Me.lblPrefix.TabIndex = 4
        Me.lblPrefix.Text = "Prefix:"
        
        ' txtPrefix
        Me.txtPrefix.Location = New System.Drawing.Point(380, 52)
        Me.txtPrefix.MaxLength = 10
        Me.txtPrefix.Name = "txtPrefix"
        Me.txtPrefix.Size = New System.Drawing.Size(70, 22)
        Me.txtPrefix.TabIndex = 5
        
        ' lblAddress
        Me.lblAddress.AutoSize = True
        Me.lblAddress.Location = New System.Drawing.Point(20, 90)
        Me.lblAddress.Name = "lblAddress"
        Me.lblAddress.Size = New System.Drawing.Size(64, 17)
        Me.lblAddress.TabIndex = 6
        Me.lblAddress.Text = "Address:"
        
        ' txtAddress
        Me.txtAddress.Location = New System.Drawing.Point(150, 87)
        Me.txtAddress.Multiline = True
        Me.txtAddress.Name = "txtAddress"
        Me.txtAddress.Size = New System.Drawing.Size(300, 50)
        Me.txtAddress.TabIndex = 7
        
        ' lblCity
        Me.lblCity.AutoSize = True
        Me.lblCity.Location = New System.Drawing.Point(20, 150)
        Me.lblCity.Name = "lblCity"
        Me.lblCity.Size = New System.Drawing.Size(35, 17)
        Me.lblCity.TabIndex = 8
        Me.lblCity.Text = "City:"
        
        ' txtCity
        Me.txtCity.Location = New System.Drawing.Point(150, 147)
        Me.txtCity.Name = "txtCity"
        Me.txtCity.Size = New System.Drawing.Size(200, 22)
        Me.txtCity.TabIndex = 9
        
        ' lblProvince
        Me.lblProvince.AutoSize = True
        Me.lblProvince.Location = New System.Drawing.Point(20, 185)
        Me.lblProvince.Name = "lblProvince"
        Me.lblProvince.Size = New System.Drawing.Size(67, 17)
        Me.lblProvince.TabIndex = 10
        Me.lblProvince.Text = "Province:"
        
        ' txtProvince
        Me.txtProvince.Location = New System.Drawing.Point(150, 182)
        Me.txtProvince.Name = "txtProvince"
        Me.txtProvince.Size = New System.Drawing.Size(200, 22)
        Me.txtProvince.TabIndex = 11
        
        ' lblPostalCode
        Me.lblPostalCode.AutoSize = True
        Me.lblPostalCode.Location = New System.Drawing.Point(20, 220)
        Me.lblPostalCode.Name = "lblPostalCode"
        Me.lblPostalCode.Size = New System.Drawing.Size(88, 17)
        Me.lblPostalCode.TabIndex = 12
        Me.lblPostalCode.Text = "Postal Code:"
        
        ' txtPostalCode
        Me.txtPostalCode.Location = New System.Drawing.Point(150, 217)
        Me.txtPostalCode.Name = "txtPostalCode"
        Me.txtPostalCode.Size = New System.Drawing.Size(120, 22)
        Me.txtPostalCode.TabIndex = 13
        
        ' lblPhone
        Me.lblPhone.AutoSize = True
        Me.lblPhone.Location = New System.Drawing.Point(20, 255)
        Me.lblPhone.Name = "lblPhone"
        Me.lblPhone.Size = New System.Drawing.Size(53, 17)
        Me.lblPhone.TabIndex = 14
        Me.lblPhone.Text = "Phone:"
        
        ' txtPhone
        Me.txtPhone.Location = New System.Drawing.Point(150, 252)
        Me.txtPhone.Name = "txtPhone"
        Me.txtPhone.Size = New System.Drawing.Size(200, 22)
        Me.txtPhone.TabIndex = 15
        
        ' lblEmail
        Me.lblEmail.AutoSize = True
        Me.lblEmail.Location = New System.Drawing.Point(20, 290)
        Me.lblEmail.Name = "lblEmail"
        Me.lblEmail.Size = New System.Drawing.Size(46, 17)
        Me.lblEmail.TabIndex = 16
        Me.lblEmail.Text = "Email:"
        
        ' txtEmail
        Me.txtEmail.Location = New System.Drawing.Point(150, 287)
        Me.txtEmail.Name = "txtEmail"
        Me.txtEmail.Size = New System.Drawing.Size(300, 22)
        Me.txtEmail.TabIndex = 17
        
        ' lblManager
        Me.lblManager.AutoSize = True
        Me.lblManager.Location = New System.Drawing.Point(20, 325)
        Me.lblManager.Name = "lblManager"
        Me.lblManager.Size = New System.Drawing.Size(67, 17)
        Me.lblManager.TabIndex = 18
        Me.lblManager.Text = "Manager:"
        
        ' txtManager
        Me.txtManager.Location = New System.Drawing.Point(150, 322)
        Me.txtManager.Name = "txtManager"
        Me.txtManager.Size = New System.Drawing.Size(300, 22)
        Me.txtManager.TabIndex = 19
        
        ' chkIsActive
        Me.chkIsActive.AutoSize = True
        Me.chkIsActive.Checked = True
        Me.chkIsActive.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkIsActive.Location = New System.Drawing.Point(150, 360)
        Me.chkIsActive.Name = "chkIsActive"
        Me.chkIsActive.Size = New System.Drawing.Size(80, 21)
        Me.chkIsActive.TabIndex = 20
        Me.chkIsActive.Text = "Is Active"
        Me.chkIsActive.UseVisualStyleBackColor = True
        
        ' btnSave
        Me.btnSave.Location = New System.Drawing.Point(150, 400)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(120, 35)
        Me.btnSave.TabIndex = 21
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = True
        
        ' btnCancel
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(280, 400)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(120, 35)
        Me.btnCancel.TabIndex = 22
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        
        ' BranchAddEditForm
        Me.AcceptButton = Me.btnSave
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(500, 460)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnSave)
        Me.Controls.Add(Me.chkIsActive)
        Me.Controls.Add(Me.txtManager)
        Me.Controls.Add(Me.lblManager)
        Me.Controls.Add(Me.txtEmail)
        Me.Controls.Add(Me.lblEmail)
        Me.Controls.Add(Me.txtPostalCode)
        Me.Controls.Add(Me.lblPostalCode)
        Me.Controls.Add(Me.txtProvince)
        Me.Controls.Add(Me.lblProvince)
        Me.Controls.Add(Me.txtCity)
        Me.Controls.Add(Me.lblCity)
        Me.Controls.Add(Me.txtPhone)
        Me.Controls.Add(Me.lblPhone)
        Me.Controls.Add(Me.txtAddress)
        Me.Controls.Add(Me.lblAddress)
        Me.Controls.Add(Me.txtPrefix)
        Me.Controls.Add(Me.lblPrefix)
        Me.Controls.Add(Me.txtBranchCode)
        Me.Controls.Add(Me.lblBranchCode)
        Me.Controls.Add(Me.txtName)
        Me.Controls.Add(Me.lblName)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "BranchAddEditForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Add/Edit Branch"
        Me.ResumeLayout(False)
        Me.PerformLayout()
    End Sub
End Class
