<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AccountsPayableInvoiceForm
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
        Me.components = New System.ComponentModel.Container()
        Me.lblTitle = New System.Windows.Forms.Label()
        Me.lblInvoiceNumber = New System.Windows.Forms.Label()
        Me.txtInvoiceNumber = New System.Windows.Forms.TextBox()
        Me.lblSupplier = New System.Windows.Forms.Label()
        Me.cmbSupplier = New System.Windows.Forms.ComboBox()
        Me.lblGLAccount = New System.Windows.Forms.Label()
        Me.cmbGLAccount = New System.Windows.Forms.ComboBox()
        Me.lblInvoiceDate = New System.Windows.Forms.Label()
        Me.dtpInvoiceDate = New System.Windows.Forms.DateTimePicker()
        Me.lblDueDate = New System.Windows.Forms.Label()
        Me.dtpDueDate = New System.Windows.Forms.DateTimePicker()
        Me.lblAmount = New System.Windows.Forms.Label()
        Me.txtAmount = New System.Windows.Forms.TextBox()
        Me.lblDescription = New System.Windows.Forms.Label()
        Me.txtDescription = New System.Windows.Forms.TextBox()
        Me.chkPaid = New System.Windows.Forms.CheckBox()
        Me.lblPaidDate = New System.Windows.Forms.Label()
        Me.dtpPaidDate = New System.Windows.Forms.DateTimePicker()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Microsoft Sans Serif", 14.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTitle.Location = New System.Drawing.Point(12, 9)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(196, 24)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Accounts Payable Invoice"
        '
        'lblInvoiceNumber
        '
        Me.lblInvoiceNumber.AutoSize = True
        Me.lblInvoiceNumber.Location = New System.Drawing.Point(12, 50)
        Me.lblInvoiceNumber.Name = "lblInvoiceNumber"
        Me.lblInvoiceNumber.Size = New System.Drawing.Size(85, 13)
        Me.lblInvoiceNumber.TabIndex = 1
        Me.lblInvoiceNumber.Text = "Invoice Number:"
        '
        'txtInvoiceNumber
        '
        Me.txtInvoiceNumber.Location = New System.Drawing.Point(120, 47)
        Me.txtInvoiceNumber.Name = "txtInvoiceNumber"
        Me.txtInvoiceNumber.Size = New System.Drawing.Size(200, 20)
        Me.txtInvoiceNumber.TabIndex = 2
        '
        'lblSupplier
        '
        Me.lblSupplier.AutoSize = True
        Me.lblSupplier.Location = New System.Drawing.Point(12, 80)
        Me.lblSupplier.Name = "lblSupplier"
        Me.lblSupplier.Size = New System.Drawing.Size(48, 13)
        Me.lblSupplier.TabIndex = 3
        Me.lblSupplier.Text = "Supplier:"
        '
        'cmbSupplier
        '
        Me.cmbSupplier.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbSupplier.FormattingEnabled = True
        Me.cmbSupplier.Location = New System.Drawing.Point(120, 77)
        Me.cmbSupplier.Name = "cmbSupplier"
        Me.cmbSupplier.Size = New System.Drawing.Size(300, 21)
        Me.cmbSupplier.TabIndex = 4
        '
        'lblGLAccount
        '
        Me.lblGLAccount.AutoSize = True
        Me.lblGLAccount.Location = New System.Drawing.Point(12, 110)
        Me.lblGLAccount.Name = "lblGLAccount"
        Me.lblGLAccount.Size = New System.Drawing.Size(67, 13)
        Me.lblGLAccount.TabIndex = 5
        Me.lblGLAccount.Text = "GL Account:"
        '
        'cmbGLAccount
        '
        Me.cmbGLAccount.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbGLAccount.FormattingEnabled = True
        Me.cmbGLAccount.Location = New System.Drawing.Point(120, 107)
        Me.cmbGLAccount.Name = "cmbGLAccount"
        Me.cmbGLAccount.Size = New System.Drawing.Size(300, 21)
        Me.cmbGLAccount.TabIndex = 6
        '
        'lblInvoiceDate
        '
        Me.lblInvoiceDate.AutoSize = True
        Me.lblInvoiceDate.Location = New System.Drawing.Point(12, 140)
        Me.lblInvoiceDate.Name = "lblInvoiceDate"
        Me.lblInvoiceDate.Size = New System.Drawing.Size(71, 13)
        Me.lblInvoiceDate.TabIndex = 7
        Me.lblInvoiceDate.Text = "Invoice Date:"
        '
        'dtpInvoiceDate
        '
        Me.dtpInvoiceDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpInvoiceDate.Location = New System.Drawing.Point(120, 137)
        Me.dtpInvoiceDate.Name = "dtpInvoiceDate"
        Me.dtpInvoiceDate.Size = New System.Drawing.Size(150, 20)
        Me.dtpInvoiceDate.TabIndex = 8
        '
        'lblDueDate
        '
        Me.lblDueDate.AutoSize = True
        Me.lblDueDate.Location = New System.Drawing.Point(12, 170)
        Me.lblDueDate.Name = "lblDueDate"
        Me.lblDueDate.Size = New System.Drawing.Size(56, 13)
        Me.lblDueDate.TabIndex = 9
        Me.lblDueDate.Text = "Due Date:"
        '
        'dtpDueDate
        '
        Me.dtpDueDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpDueDate.Location = New System.Drawing.Point(120, 167)
        Me.dtpDueDate.Name = "dtpDueDate"
        Me.dtpDueDate.Size = New System.Drawing.Size(150, 20)
        Me.dtpDueDate.TabIndex = 10
        '
        'lblAmount
        '
        Me.lblAmount.AutoSize = True
        Me.lblAmount.Location = New System.Drawing.Point(12, 200)
        Me.lblAmount.Name = "lblAmount"
        Me.lblAmount.Size = New System.Drawing.Size(46, 13)
        Me.lblAmount.TabIndex = 11
        Me.lblAmount.Text = "Amount:"
        '
        'txtAmount
        '
        Me.txtAmount.Location = New System.Drawing.Point(120, 197)
        Me.txtAmount.Name = "txtAmount"
        Me.txtAmount.Size = New System.Drawing.Size(150, 20)
        Me.txtAmount.TabIndex = 12
        Me.txtAmount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'lblDescription
        '
        Me.lblDescription.AutoSize = True
        Me.lblDescription.Location = New System.Drawing.Point(12, 230)
        Me.lblDescription.Name = "lblDescription"
        Me.lblDescription.Size = New System.Drawing.Size(63, 13)
        Me.lblDescription.TabIndex = 13
        Me.lblDescription.Text = "Description:"
        '
        'txtDescription
        '
        Me.txtDescription.Location = New System.Drawing.Point(120, 227)
        Me.txtDescription.Multiline = True
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtDescription.Size = New System.Drawing.Size(300, 60)
        Me.txtDescription.TabIndex = 14
        '
        'chkPaid
        '
        Me.chkPaid.AutoSize = True
        Me.chkPaid.Location = New System.Drawing.Point(120, 300)
        Me.chkPaid.Name = "chkPaid"
        Me.chkPaid.Size = New System.Drawing.Size(47, 17)
        Me.chkPaid.TabIndex = 15
        Me.chkPaid.Text = "Paid"
        Me.chkPaid.UseVisualStyleBackColor = True
        '
        'lblPaidDate
        '
        Me.lblPaidDate.AutoSize = True
        Me.lblPaidDate.Location = New System.Drawing.Point(12, 330)
        Me.lblPaidDate.Name = "lblPaidDate"
        Me.lblPaidDate.Size = New System.Drawing.Size(58, 13)
        Me.lblPaidDate.TabIndex = 16
        Me.lblPaidDate.Text = "Paid Date:"
        '
        'dtpPaidDate
        '
        Me.dtpPaidDate.Enabled = False
        Me.dtpPaidDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpPaidDate.Location = New System.Drawing.Point(120, 327)
        Me.dtpPaidDate.Name = "dtpPaidDate"
        Me.dtpPaidDate.Size = New System.Drawing.Size(150, 20)
        Me.dtpPaidDate.TabIndex = 17
        '
        'btnSave
        '
        Me.btnSave.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.btnSave.FlatAppearance.BorderSize = 0
        Me.btnSave.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnSave.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnSave.ForeColor = System.Drawing.Color.White
        Me.btnSave.Location = New System.Drawing.Point(260, 370)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(80, 35)
        Me.btnSave.TabIndex = 18
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = False
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.Color.FromArgb(CType(CType(108, Byte), Integer), CType(CType(117, Byte), Integer), CType(CType(125, Byte), Integer))
        Me.btnCancel.FlatAppearance.BorderSize = 0
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnCancel.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.ForeColor = System.Drawing.Color.White
        Me.btnCancel.Location = New System.Drawing.Point(350, 370)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(80, 35)
        Me.btnCancel.TabIndex = 19
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = False
        '
        'AccountsPayableInvoiceForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.White
        Me.ClientSize = New System.Drawing.Size(600, 550)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnSave)
        Me.Controls.Add(Me.dtpPaidDate)
        Me.Controls.Add(Me.lblPaidDate)
        Me.Controls.Add(Me.chkPaid)
        Me.Controls.Add(Me.txtDescription)
        Me.Controls.Add(Me.lblDescription)
        Me.Controls.Add(Me.txtAmount)
        Me.Controls.Add(Me.lblAmount)
        Me.Controls.Add(Me.dtpDueDate)
        Me.Controls.Add(Me.lblDueDate)
        Me.Controls.Add(Me.dtpInvoiceDate)
        Me.Controls.Add(Me.lblInvoiceDate)
        Me.Controls.Add(Me.cmbGLAccount)
        Me.Controls.Add(Me.lblGLAccount)
        Me.Controls.Add(Me.cmbSupplier)
        Me.Controls.Add(Me.lblSupplier)
        Me.Controls.Add(Me.txtInvoiceNumber)
        Me.Controls.Add(Me.lblInvoiceNumber)
        Me.Controls.Add(Me.lblTitle)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "AccountsPayableInvoiceForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Supplier Invoice"
        Me.Visible = True
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents lblTitle As Label
    Friend WithEvents lblInvoiceNumber As Label
    Friend WithEvents txtInvoiceNumber As TextBox
    Friend WithEvents lblSupplier As Label
    Friend WithEvents cmbSupplier As ComboBox
    Friend WithEvents lblGLAccount As Label
    Friend WithEvents cmbGLAccount As ComboBox
    Friend WithEvents lblInvoiceDate As Label
    Friend WithEvents dtpInvoiceDate As DateTimePicker
    Friend WithEvents lblDueDate As Label
    Friend WithEvents dtpDueDate As DateTimePicker
    Friend WithEvents lblAmount As Label
    Friend WithEvents txtAmount As TextBox
    Friend WithEvents lblDescription As Label
    Friend WithEvents txtDescription As TextBox
    Friend WithEvents chkPaid As CheckBox
    Friend WithEvents lblPaidDate As Label
    Friend WithEvents dtpPaidDate As DateTimePicker
    Friend WithEvents btnSave As Button
    Friend WithEvents btnCancel As Button
End Class
