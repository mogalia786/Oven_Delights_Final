<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SupplierAddEditForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
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
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.txtSupplierCode = New System.Windows.Forms.TextBox()
        Me.txtCompanyName = New System.Windows.Forms.TextBox()
        Me.txtContactPerson = New System.Windows.Forms.TextBox()
        Me.txtEmail = New System.Windows.Forms.TextBox()
        Me.txtPhone = New System.Windows.Forms.TextBox()
        Me.txtMobile = New System.Windows.Forms.TextBox()
        Me.txtAddress = New System.Windows.Forms.TextBox()
        Me.txtCity = New System.Windows.Forms.TextBox()
        Me.txtProvince = New System.Windows.Forms.TextBox()
        Me.txtPostalCode = New System.Windows.Forms.TextBox()
        Me.txtCountry = New System.Windows.Forms.TextBox()
        Me.txtVATNumber = New System.Windows.Forms.TextBox()
        Me.txtPaymentTerms = New System.Windows.Forms.TextBox()
        Me.txtCreditLimit = New System.Windows.Forms.TextBox()
        Me.chkIsActive = New System.Windows.Forms.CheckBox()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.lblSupplierCode = New System.Windows.Forms.Label()
        Me.lblCompanyName = New System.Windows.Forms.Label()
        Me.lblContactPerson = New System.Windows.Forms.Label()
        Me.lblEmail = New System.Windows.Forms.Label()
        Me.lblPhone = New System.Windows.Forms.Label()
        Me.lblMobile = New System.Windows.Forms.Label()
        Me.lblAddress = New System.Windows.Forms.Label()
        Me.lblCity = New System.Windows.Forms.Label()
        Me.lblProvince = New System.Windows.Forms.Label()
        Me.lblPostalCode = New System.Windows.Forms.Label()
        Me.lblCountry = New System.Windows.Forms.Label()
        Me.lblVATNumber = New System.Windows.Forms.Label()
        Me.lblPaymentTerms = New System.Windows.Forms.Label()
        Me.lblCreditLimit = New System.Windows.Forms.Label()
        Me.pnlMain = New System.Windows.Forms.Panel()
        Me.pnlButtons = New System.Windows.Forms.Panel()
        Me.pnlMain.SuspendLayout()
        Me.pnlButtons.SuspendLayout()
        Me.SuspendLayout()
        '
        'txtSupplierCode
        '
        Me.txtSupplierCode.Location = New System.Drawing.Point(120, 20)
        Me.txtSupplierCode.Name = "txtSupplierCode"
        Me.txtSupplierCode.Size = New System.Drawing.Size(150, 20)
        Me.txtSupplierCode.TabIndex = 0
        '
        'txtCompanyName
        '
        Me.txtCompanyName.Location = New System.Drawing.Point(120, 50)
        Me.txtCompanyName.Name = "txtCompanyName"
        Me.txtCompanyName.Size = New System.Drawing.Size(300, 20)
        Me.txtCompanyName.TabIndex = 1
        '
        'txtContactPerson
        '
        Me.txtContactPerson.Location = New System.Drawing.Point(120, 80)
        Me.txtContactPerson.Name = "txtContactPerson"
        Me.txtContactPerson.Size = New System.Drawing.Size(200, 20)
        Me.txtContactPerson.TabIndex = 2
        '
        'txtEmail
        '
        Me.txtEmail.Location = New System.Drawing.Point(120, 110)
        Me.txtEmail.Name = "txtEmail"
        Me.txtEmail.Size = New System.Drawing.Size(250, 20)
        Me.txtEmail.TabIndex = 3
        '
        'txtPhone
        '
        Me.txtPhone.Location = New System.Drawing.Point(120, 140)
        Me.txtPhone.Name = "txtPhone"
        Me.txtPhone.Size = New System.Drawing.Size(150, 20)
        Me.txtPhone.TabIndex = 4
        '
        'txtMobile
        '
        Me.txtMobile.Location = New System.Drawing.Point(320, 140)
        Me.txtMobile.Name = "txtMobile"
        Me.txtMobile.Size = New System.Drawing.Size(150, 20)
        Me.txtMobile.TabIndex = 5
        '
        'txtAddress
        '
        Me.txtAddress.Location = New System.Drawing.Point(120, 170)
        Me.txtAddress.Multiline = True
        Me.txtAddress.Name = "txtAddress"
        Me.txtAddress.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtAddress.Size = New System.Drawing.Size(350, 60)
        Me.txtAddress.TabIndex = 6
        '
        'txtCity
        '
        Me.txtCity.Location = New System.Drawing.Point(120, 240)
        Me.txtCity.Name = "txtCity"
        Me.txtCity.Size = New System.Drawing.Size(150, 20)
        Me.txtCity.TabIndex = 7
        '
        'txtProvince
        '
        Me.txtProvince.Location = New System.Drawing.Point(320, 240)
        Me.txtProvince.Name = "txtProvince"
        Me.txtProvince.Size = New System.Drawing.Size(150, 20)
        Me.txtProvince.TabIndex = 8
        '
        'txtPostalCode
        '
        Me.txtPostalCode.Location = New System.Drawing.Point(120, 270)
        Me.txtPostalCode.Name = "txtPostalCode"
        Me.txtPostalCode.Size = New System.Drawing.Size(100, 20)
        Me.txtPostalCode.TabIndex = 9
        '
        'txtCountry
        '
        Me.txtCountry.Location = New System.Drawing.Point(320, 270)
        Me.txtCountry.Name = "txtCountry"
        Me.txtCountry.Size = New System.Drawing.Size(150, 20)
        Me.txtCountry.TabIndex = 10
        '
        'txtVATNumber
        '
        Me.txtVATNumber.Location = New System.Drawing.Point(120, 300)
        Me.txtVATNumber.Name = "txtVATNumber"
        Me.txtVATNumber.Size = New System.Drawing.Size(150, 20)
        Me.txtVATNumber.TabIndex = 11
        '
        'txtPaymentTerms
        '
        Me.txtPaymentTerms.Location = New System.Drawing.Point(120, 330)
        Me.txtPaymentTerms.Name = "txtPaymentTerms"
        Me.txtPaymentTerms.Size = New System.Drawing.Size(80, 20)
        Me.txtPaymentTerms.TabIndex = 12
        Me.txtPaymentTerms.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'txtCreditLimit
        '
        Me.txtCreditLimit.Location = New System.Drawing.Point(320, 330)
        Me.txtCreditLimit.Name = "txtCreditLimit"
        Me.txtCreditLimit.Size = New System.Drawing.Size(120, 20)
        Me.txtCreditLimit.TabIndex = 13
        Me.txtCreditLimit.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'chkIsActive
        '
        Me.chkIsActive.AutoSize = True
        Me.chkIsActive.Checked = True
        Me.chkIsActive.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkIsActive.Location = New System.Drawing.Point(120, 360)
        Me.chkIsActive.Name = "chkIsActive"
        Me.chkIsActive.Size = New System.Drawing.Size(67, 17)
        Me.chkIsActive.TabIndex = 14
        Me.chkIsActive.Text = "Is Active"
        Me.chkIsActive.UseVisualStyleBackColor = True
        '
        'btnSave
        '
        Me.btnSave.Location = New System.Drawing.Point(314, 10)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(75, 23)
        Me.btnSave.TabIndex = 15
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(395, 10)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 16
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'lblSupplierCode
        '
        Me.lblSupplierCode.AutoSize = True
        Me.lblSupplierCode.Location = New System.Drawing.Point(20, 23)
        Me.lblSupplierCode.Name = "lblSupplierCode"
        Me.lblSupplierCode.Size = New System.Drawing.Size(79, 13)
        Me.lblSupplierCode.TabIndex = 17
        Me.lblSupplierCode.Text = "Supplier Code:"
        '
        'lblCompanyName
        '
        Me.lblCompanyName.AutoSize = True
        Me.lblCompanyName.Location = New System.Drawing.Point(20, 53)
        Me.lblCompanyName.Name = "lblCompanyName"
        Me.lblCompanyName.Size = New System.Drawing.Size(85, 13)
        Me.lblCompanyName.TabIndex = 18
        Me.lblCompanyName.Text = "Company Name:"
        '
        'lblContactPerson
        '
        Me.lblContactPerson.AutoSize = True
        Me.lblContactPerson.Location = New System.Drawing.Point(20, 83)
        Me.lblContactPerson.Name = "lblContactPerson"
        Me.lblContactPerson.Size = New System.Drawing.Size(83, 13)
        Me.lblContactPerson.TabIndex = 19
        Me.lblContactPerson.Text = "Contact Person:"
        '
        'lblEmail
        '
        Me.lblEmail.AutoSize = True
        Me.lblEmail.Location = New System.Drawing.Point(20, 113)
        Me.lblEmail.Name = "lblEmail"
        Me.lblEmail.Size = New System.Drawing.Size(35, 13)
        Me.lblEmail.TabIndex = 20
        Me.lblEmail.Text = "Email:"
        '
        'lblPhone
        '
        Me.lblPhone.AutoSize = True
        Me.lblPhone.Location = New System.Drawing.Point(20, 143)
        Me.lblPhone.Name = "lblPhone"
        Me.lblPhone.Size = New System.Drawing.Size(41, 13)
        Me.lblPhone.TabIndex = 21
        Me.lblPhone.Text = "Phone:"
        '
        'lblMobile
        '
        Me.lblMobile.AutoSize = True
        Me.lblMobile.Location = New System.Drawing.Point(280, 143)
        Me.lblMobile.Name = "lblMobile"
        Me.lblMobile.Size = New System.Drawing.Size(41, 13)
        Me.lblMobile.TabIndex = 22
        Me.lblMobile.Text = "Mobile:"
        '
        'lblAddress
        '
        Me.lblAddress.AutoSize = True
        Me.lblAddress.Location = New System.Drawing.Point(20, 173)
        Me.lblAddress.Name = "lblAddress"
        Me.lblAddress.Size = New System.Drawing.Size(48, 13)
        Me.lblAddress.TabIndex = 23
        Me.lblAddress.Text = "Address:"
        '
        'lblCity
        '
        Me.lblCity.AutoSize = True
        Me.lblCity.Location = New System.Drawing.Point(20, 243)
        Me.lblCity.Name = "lblCity"
        Me.lblCity.Size = New System.Drawing.Size(27, 13)
        Me.lblCity.TabIndex = 24
        Me.lblCity.Text = "City:"
        '
        'lblProvince
        '
        Me.lblProvince.AutoSize = True
        Me.lblProvince.Location = New System.Drawing.Point(280, 243)
        Me.lblProvince.Name = "lblProvince"
        Me.lblProvince.Size = New System.Drawing.Size(52, 13)
        Me.lblProvince.TabIndex = 25
        Me.lblProvince.Text = "Province:"
        '
        'lblPostalCode
        '
        Me.lblPostalCode.AutoSize = True
        Me.lblPostalCode.Location = New System.Drawing.Point(20, 273)
        Me.lblPostalCode.Name = "lblPostalCode"
        Me.lblPostalCode.Size = New System.Drawing.Size(70, 13)
        Me.lblPostalCode.TabIndex = 26
        Me.lblPostalCode.Text = "Postal Code:"
        '
        'lblCountry
        '
        Me.lblCountry.AutoSize = True
        Me.lblCountry.Location = New System.Drawing.Point(280, 273)
        Me.lblCountry.Name = "lblCountry"
        Me.lblCountry.Size = New System.Drawing.Size(46, 13)
        Me.lblCountry.TabIndex = 27
        Me.lblCountry.Text = "Country:"
        '
        'lblVATNumber
        '
        Me.lblVATNumber.AutoSize = True
        Me.lblVATNumber.Location = New System.Drawing.Point(20, 303)
        Me.lblVATNumber.Name = "lblVATNumber"
        Me.lblVATNumber.Size = New System.Drawing.Size(71, 13)
        Me.lblVATNumber.TabIndex = 28
        Me.lblVATNumber.Text = "VAT Number:"
        '
        'lblPaymentTerms
        '
        Me.lblPaymentTerms.AutoSize = True
        Me.lblPaymentTerms.Location = New System.Drawing.Point(20, 333)
        Me.lblPaymentTerms.Name = "lblPaymentTerms"
        Me.lblPaymentTerms.Size = New System.Drawing.Size(88, 13)
        Me.lblPaymentTerms.TabIndex = 29
        Me.lblPaymentTerms.Text = "Payment Terms:"
        '
        'lblCreditLimit
        '
        Me.lblCreditLimit.AutoSize = True
        Me.lblCreditLimit.Location = New System.Drawing.Point(280, 333)
        Me.lblCreditLimit.Name = "lblCreditLimit"
        Me.lblCreditLimit.Size = New System.Drawing.Size(63, 13)
        Me.lblCreditLimit.TabIndex = 30
        Me.lblCreditLimit.Text = "Credit Limit:"
        '
        'pnlMain
        '
        Me.pnlMain.Controls.Add(Me.lblSupplierCode)
        Me.pnlMain.Controls.Add(Me.lblCreditLimit)
        Me.pnlMain.Controls.Add(Me.txtSupplierCode)
        Me.pnlMain.Controls.Add(Me.lblPaymentTerms)
        Me.pnlMain.Controls.Add(Me.txtCompanyName)
        Me.pnlMain.Controls.Add(Me.lblVATNumber)
        Me.pnlMain.Controls.Add(Me.txtContactPerson)
        Me.pnlMain.Controls.Add(Me.lblCountry)
        Me.pnlMain.Controls.Add(Me.txtEmail)
        Me.pnlMain.Controls.Add(Me.lblPostalCode)
        Me.pnlMain.Controls.Add(Me.txtPhone)
        Me.pnlMain.Controls.Add(Me.lblProvince)
        Me.pnlMain.Controls.Add(Me.txtMobile)
        Me.pnlMain.Controls.Add(Me.lblCity)
        Me.pnlMain.Controls.Add(Me.txtAddress)
        Me.pnlMain.Controls.Add(Me.lblAddress)
        Me.pnlMain.Controls.Add(Me.txtCity)
        Me.pnlMain.Controls.Add(Me.lblMobile)
        Me.pnlMain.Controls.Add(Me.txtProvince)
        Me.pnlMain.Controls.Add(Me.lblPhone)
        Me.pnlMain.Controls.Add(Me.txtPostalCode)
        Me.pnlMain.Controls.Add(Me.lblEmail)
        Me.pnlMain.Controls.Add(Me.txtCountry)
        Me.pnlMain.Controls.Add(Me.lblContactPerson)
        Me.pnlMain.Controls.Add(Me.txtVATNumber)
        Me.pnlMain.Controls.Add(Me.lblCompanyName)
        Me.pnlMain.Controls.Add(Me.txtPaymentTerms)
        Me.pnlMain.Controls.Add(Me.txtCreditLimit)
        Me.pnlMain.Controls.Add(Me.chkIsActive)
        Me.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMain.Location = New System.Drawing.Point(0, 0)
        Me.pnlMain.Name = "pnlMain"
        Me.pnlMain.Size = New System.Drawing.Size(500, 387)
        Me.pnlMain.TabIndex = 31
        '
        'pnlButtons
        '
        Me.pnlButtons.Controls.Add(Me.btnSave)
        Me.pnlButtons.Controls.Add(Me.btnCancel)
        Me.pnlButtons.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlButtons.Location = New System.Drawing.Point(0, 387)
        Me.pnlButtons.Name = "pnlButtons"
        Me.pnlButtons.Size = New System.Drawing.Size(500, 43)
        Me.pnlButtons.TabIndex = 32
        '
        'SupplierAddEditForm
        '
        Me.AcceptButton = Me.btnSave
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(500, 430)
        Me.Controls.Add(Me.pnlMain)
        Me.Controls.Add(Me.pnlButtons)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.Name = "SupplierAddEditForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Supplier Details"
        Me.pnlMain.ResumeLayout(False)
        Me.pnlMain.PerformLayout()
        Me.pnlButtons.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents txtSupplierCode As TextBox
    Friend WithEvents txtCompanyName As TextBox
    Friend WithEvents txtContactPerson As TextBox
    Friend WithEvents txtEmail As TextBox
    Friend WithEvents txtPhone As TextBox
    Friend WithEvents txtMobile As TextBox
    Friend WithEvents txtAddress As TextBox
    Friend WithEvents txtCity As TextBox
    Friend WithEvents txtProvince As TextBox
    Friend WithEvents txtPostalCode As TextBox
    Friend WithEvents txtCountry As TextBox
    Friend WithEvents txtVATNumber As TextBox
    Friend WithEvents txtPaymentTerms As TextBox
    Friend WithEvents txtCreditLimit As TextBox
    Friend WithEvents chkIsActive As CheckBox
    Friend WithEvents btnSave As Button
    Friend WithEvents btnCancel As Button
    Friend WithEvents lblSupplierCode As Label
    Friend WithEvents lblCompanyName As Label
    Friend WithEvents lblContactPerson As Label
    Friend WithEvents lblEmail As Label
    Friend WithEvents lblPhone As Label
    Friend WithEvents lblMobile As Label
    Friend WithEvents lblAddress As Label
    Friend WithEvents lblCity As Label
    Friend WithEvents lblProvince As Label
    Friend WithEvents lblPostalCode As Label
    Friend WithEvents lblCountry As Label
    Friend WithEvents lblVATNumber As Label
    Friend WithEvents lblPaymentTerms As Label
    Friend WithEvents lblCreditLimit As Label
    Friend WithEvents pnlMain As Panel
    Friend WithEvents pnlButtons As Panel

End Class
