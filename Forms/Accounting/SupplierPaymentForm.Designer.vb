<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class SupplierPaymentForm
    Inherits System.Windows.Forms.Form

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

    Private components As System.ComponentModel.IContainer

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.pnlTop = New System.Windows.Forms.Panel()
        Me.lblTitle = New System.Windows.Forms.Label()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.btnProcessPayment = New System.Windows.Forms.Button()
        Me.pnlDetails = New System.Windows.Forms.Panel()
        Me.lblSupplier = New System.Windows.Forms.Label()
        Me.cboSupplier = New System.Windows.Forms.ComboBox()
        Me.lblPaymentDate = New System.Windows.Forms.Label()
        Me.dtpPaymentDate = New System.Windows.Forms.DateTimePicker()
        Me.lblPaymentMethod = New System.Windows.Forms.Label()
        Me.cboPaymentMethod = New System.Windows.Forms.ComboBox()
        Me.lblReference = New System.Windows.Forms.Label()
        Me.txtReference = New System.Windows.Forms.TextBox()
        Me.lblCheckNumber = New System.Windows.Forms.Label()
        Me.txtCheckNumber = New System.Windows.Forms.TextBox()
        Me.lblNotes = New System.Windows.Forms.Label()
        Me.txtNotes = New System.Windows.Forms.TextBox()
        Me.dgvInvoices = New System.Windows.Forms.DataGridView()
        Me.pnlBottom = New System.Windows.Forms.Panel()
        Me.lblTotalOutstanding = New System.Windows.Forms.Label()
        Me.lblTotalPayment = New System.Windows.Forms.Label()
        Me.pnlTop.SuspendLayout()
        Me.pnlDetails.SuspendLayout()
        CType(Me.dgvInvoices, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlBottom.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlTop
        '
        Me.pnlTop.BackColor = System.Drawing.Color.FromArgb(CType(CType(183, Byte), Integer), CType(CType(58, Byte), Integer), CType(CType(46, Byte), Integer))
        Me.pnlTop.Controls.Add(Me.lblTitle)
        Me.pnlTop.Controls.Add(Me.btnClose)
        Me.pnlTop.Controls.Add(Me.btnProcessPayment)
        Me.pnlTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlTop.Location = New System.Drawing.Point(0, 0)
        Me.pnlTop.Name = "pnlTop"
        Me.pnlTop.Size = New System.Drawing.Size(1200, 60)
        Me.pnlTop.TabIndex = 0
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.lblTitle.ForeColor = System.Drawing.Color.White
        Me.lblTitle.Location = New System.Drawing.Point(12, 17)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(200, 25)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Pay Supplier Invoice"
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(108, Byte), Integer), CType(CType(117, Byte), Integer), CType(CType(125, Byte), Integer))
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(1080, 12)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(100, 36)
        Me.btnClose.TabIndex = 2
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = False
        '
        'btnProcessPayment
        '
        Me.btnProcessPayment.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnProcessPayment.BackColor = System.Drawing.Color.FromArgb(CType(CType(40, Byte), Integer), CType(CType(167, Byte), Integer), CType(CType(69, Byte), Integer))
        Me.btnProcessPayment.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnProcessPayment.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnProcessPayment.ForeColor = System.Drawing.Color.White
        Me.btnProcessPayment.Location = New System.Drawing.Point(920, 12)
        Me.btnProcessPayment.Name = "btnProcessPayment"
        Me.btnProcessPayment.Size = New System.Drawing.Size(150, 36)
        Me.btnProcessPayment.TabIndex = 1
        Me.btnProcessPayment.Text = "Process Payment"
        Me.btnProcessPayment.UseVisualStyleBackColor = False
        '
        'pnlDetails
        '
        Me.pnlDetails.BackColor = System.Drawing.Color.WhiteSmoke
        Me.pnlDetails.Controls.Add(Me.lblSupplier)
        Me.pnlDetails.Controls.Add(Me.cboSupplier)
        Me.pnlDetails.Controls.Add(Me.lblPaymentDate)
        Me.pnlDetails.Controls.Add(Me.dtpPaymentDate)
        Me.pnlDetails.Controls.Add(Me.lblPaymentMethod)
        Me.pnlDetails.Controls.Add(Me.cboPaymentMethod)
        Me.pnlDetails.Controls.Add(Me.lblReference)
        Me.pnlDetails.Controls.Add(Me.txtReference)
        Me.pnlDetails.Controls.Add(Me.lblCheckNumber)
        Me.pnlDetails.Controls.Add(Me.txtCheckNumber)
        Me.pnlDetails.Controls.Add(Me.lblNotes)
        Me.pnlDetails.Controls.Add(Me.txtNotes)
        Me.pnlDetails.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlDetails.Location = New System.Drawing.Point(0, 60)
        Me.pnlDetails.Name = "pnlDetails"
        Me.pnlDetails.Padding = New System.Windows.Forms.Padding(12)
        Me.pnlDetails.Size = New System.Drawing.Size(1200, 120)
        Me.pnlDetails.TabIndex = 1
        '
        'lblSupplier
        '
        Me.lblSupplier.AutoSize = True
        Me.lblSupplier.Location = New System.Drawing.Point(12, 15)
        Me.lblSupplier.Name = "lblSupplier"
        Me.lblSupplier.Size = New System.Drawing.Size(55, 15)
        Me.lblSupplier.TabIndex = 0
        Me.lblSupplier.Text = "Supplier:"
        '
        'cboSupplier
        '
        Me.cboSupplier.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboSupplier.FormattingEnabled = True
        Me.cboSupplier.Location = New System.Drawing.Point(12, 33)
        Me.cboSupplier.Name = "cboSupplier"
        Me.cboSupplier.Size = New System.Drawing.Size(300, 23)
        Me.cboSupplier.TabIndex = 1
        '
        'lblPaymentDate
        '
        Me.lblPaymentDate.AutoSize = True
        Me.lblPaymentDate.Location = New System.Drawing.Point(330, 15)
        Me.lblPaymentDate.Name = "lblPaymentDate"
        Me.lblPaymentDate.Size = New System.Drawing.Size(84, 15)
        Me.lblPaymentDate.TabIndex = 2
        Me.lblPaymentDate.Text = "Payment Date:"
        '
        'dtpPaymentDate
        '
        Me.dtpPaymentDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpPaymentDate.Location = New System.Drawing.Point(330, 33)
        Me.dtpPaymentDate.Name = "dtpPaymentDate"
        Me.dtpPaymentDate.Size = New System.Drawing.Size(150, 23)
        Me.dtpPaymentDate.TabIndex = 3
        '
        'lblPaymentMethod
        '
        Me.lblPaymentMethod.AutoSize = True
        Me.lblPaymentMethod.Location = New System.Drawing.Point(500, 15)
        Me.lblPaymentMethod.Name = "lblPaymentMethod"
        Me.lblPaymentMethod.Size = New System.Drawing.Size(103, 15)
        Me.lblPaymentMethod.TabIndex = 4
        Me.lblPaymentMethod.Text = "Payment Method:"
        '
        'cboPaymentMethod
        '
        Me.cboPaymentMethod.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboPaymentMethod.FormattingEnabled = True
        Me.cboPaymentMethod.Items.AddRange(New Object() {"Cash", "BankTransfer", "Check", "CreditNote"})
        Me.cboPaymentMethod.Location = New System.Drawing.Point(500, 33)
        Me.cboPaymentMethod.Name = "cboPaymentMethod"
        Me.cboPaymentMethod.Size = New System.Drawing.Size(150, 23)
        Me.cboPaymentMethod.TabIndex = 5
        '
        'lblReference
        '
        Me.lblReference.AutoSize = True
        Me.lblReference.Location = New System.Drawing.Point(12, 65)
        Me.lblReference.Name = "lblReference"
        Me.lblReference.Size = New System.Drawing.Size(62, 15)
        Me.lblReference.TabIndex = 6
        Me.lblReference.Text = "Reference:"
        '
        'txtReference
        '
        Me.txtReference.Location = New System.Drawing.Point(12, 83)
        Me.txtReference.Name = "txtReference"
        Me.txtReference.Size = New System.Drawing.Size(200, 23)
        Me.txtReference.TabIndex = 7
        '
        'lblCheckNumber
        '
        Me.lblCheckNumber.AutoSize = True
        Me.lblCheckNumber.Location = New System.Drawing.Point(230, 65)
        Me.lblCheckNumber.Name = "lblCheckNumber"
        Me.lblCheckNumber.Size = New System.Drawing.Size(91, 15)
        Me.lblCheckNumber.TabIndex = 8
        Me.lblCheckNumber.Text = "Check Number:"
        '
        'txtCheckNumber
        '
        Me.txtCheckNumber.Location = New System.Drawing.Point(230, 83)
        Me.txtCheckNumber.Name = "txtCheckNumber"
        Me.txtCheckNumber.Size = New System.Drawing.Size(150, 23)
        Me.txtCheckNumber.TabIndex = 9
        '
        'lblNotes
        '
        Me.lblNotes.AutoSize = True
        Me.lblNotes.Location = New System.Drawing.Point(400, 65)
        Me.lblNotes.Name = "lblNotes"
        Me.lblNotes.Size = New System.Drawing.Size(41, 15)
        Me.lblNotes.TabIndex = 10
        Me.lblNotes.Text = "Notes:"
        '
        'txtNotes
        '
        Me.txtNotes.Location = New System.Drawing.Point(400, 83)
        Me.txtNotes.Name = "txtNotes"
        Me.txtNotes.Size = New System.Drawing.Size(400, 23)
        Me.txtNotes.TabIndex = 11
        '
        'dgvInvoices
        '
        Me.dgvInvoices.AllowUserToAddRows = False
        Me.dgvInvoices.AllowUserToDeleteRows = False
        Me.dgvInvoices.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvInvoices.BackgroundColor = System.Drawing.Color.White
        Me.dgvInvoices.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvInvoices.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvInvoices.Location = New System.Drawing.Point(0, 180)
        Me.dgvInvoices.Name = "dgvInvoices"
        Me.dgvInvoices.RowTemplate.Height = 25
        Me.dgvInvoices.Size = New System.Drawing.Size(1200, 420)
        Me.dgvInvoices.TabIndex = 2
        '
        'pnlBottom
        '
        Me.pnlBottom.BackColor = System.Drawing.Color.WhiteSmoke
        Me.pnlBottom.Controls.Add(Me.lblTotalOutstanding)
        Me.pnlBottom.Controls.Add(Me.lblTotalPayment)
        Me.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlBottom.Location = New System.Drawing.Point(0, 600)
        Me.pnlBottom.Name = "pnlBottom"
        Me.pnlBottom.Size = New System.Drawing.Size(1200, 50)
        Me.pnlBottom.TabIndex = 3
        '
        'lblTotalOutstanding
        '
        Me.lblTotalOutstanding.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblTotalOutstanding.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalOutstanding.Location = New System.Drawing.Point(700, 12)
        Me.lblTotalOutstanding.Name = "lblTotalOutstanding"
        Me.lblTotalOutstanding.Size = New System.Drawing.Size(250, 25)
        Me.lblTotalOutstanding.TabIndex = 0
        Me.lblTotalOutstanding.Text = "Total Outstanding: R 0.00"
        Me.lblTotalOutstanding.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblTotalPayment
        '
        Me.lblTotalPayment.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblTotalPayment.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalPayment.ForeColor = System.Drawing.Color.FromArgb(CType(CType(40, Byte), Integer), CType(CType(167, Byte), Integer), CType(CType(69, Byte), Integer))
        Me.lblTotalPayment.Location = New System.Drawing.Point(960, 12)
        Me.lblTotalPayment.Name = "lblTotalPayment"
        Me.lblTotalPayment.Size = New System.Drawing.Size(220, 25)
        Me.lblTotalPayment.TabIndex = 1
        Me.lblTotalPayment.Text = "Total Payment: R 0.00"
        Me.lblTotalPayment.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'SupplierPaymentForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1200, 650)
        Me.Controls.Add(Me.dgvInvoices)
        Me.Controls.Add(Me.pnlBottom)
        Me.Controls.Add(Me.pnlDetails)
        Me.Controls.Add(Me.pnlTop)
        Me.Name = "SupplierPaymentForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Pay Supplier Invoice"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        Me.pnlDetails.ResumeLayout(False)
        Me.pnlDetails.PerformLayout()
        CType(Me.dgvInvoices, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlBottom.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents pnlTop As Panel
    Friend WithEvents lblTitle As Label
    Friend WithEvents btnClose As Button
    Friend WithEvents btnProcessPayment As Button
    Friend WithEvents pnlDetails As Panel
    Friend WithEvents lblSupplier As Label
    Friend WithEvents cboSupplier As ComboBox
    Friend WithEvents lblPaymentDate As Label
    Friend WithEvents dtpPaymentDate As DateTimePicker
    Friend WithEvents lblPaymentMethod As Label
    Friend WithEvents cboPaymentMethod As ComboBox
    Friend WithEvents lblReference As Label
    Friend WithEvents txtReference As TextBox
    Friend WithEvents lblCheckNumber As Label
    Friend WithEvents txtCheckNumber As TextBox
    Friend WithEvents lblNotes As Label
    Friend WithEvents txtNotes As TextBox
    Friend WithEvents dgvInvoices As DataGridView
    Friend WithEvents pnlBottom As Panel
    Friend WithEvents lblTotalOutstanding As Label
    Friend WithEvents lblTotalPayment As Label
End Class
