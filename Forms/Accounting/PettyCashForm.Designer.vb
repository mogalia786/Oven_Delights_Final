Namespace Accounting
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class PettyCashForm
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
        Me.pnlHeader = New System.Windows.Forms.Panel()
        Me.lblOpeningFloat = New System.Windows.Forms.Label()
        Me.lblTotalExpenses = New System.Windows.Forms.Label()
        Me.lblRemainingCash = New System.Windows.Forms.Label()
        Me.btnTopUp = New System.Windows.Forms.Button()
        Me.btnReconcile = New System.Windows.Forms.Button()
        Me.grpNewVoucher = New System.Windows.Forms.GroupBox()
        Me.lblVoucherNo = New System.Windows.Forms.Label()
        Me.lblPayee = New System.Windows.Forms.Label()
        Me.txtPayee = New System.Windows.Forms.TextBox()
        Me.lblAmount = New System.Windows.Forms.Label()
        Me.nudAmount = New System.Windows.Forms.NumericUpDown()
        Me.lblCategory = New System.Windows.Forms.Label()
        Me.cboCategory = New System.Windows.Forms.ComboBox()
        Me.lblPurpose = New System.Windows.Forms.Label()
        Me.txtPurpose = New System.Windows.Forms.TextBox()
        Me.chkReceiptAttached = New System.Windows.Forms.CheckBox()
        Me.btnNewVoucher = New System.Windows.Forms.Button()
        Me.grpTodaysVouchers = New System.Windows.Forms.GroupBox()
        Me.dgvVouchers = New System.Windows.Forms.DataGridView()
        Me.pnlTop.SuspendLayout()
        Me.pnlHeader.SuspendLayout()
        Me.grpNewVoucher.SuspendLayout()
        CType(Me.nudAmount, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.grpTodaysVouchers.SuspendLayout()
        CType(Me.dgvVouchers, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'pnlTop
        '
        Me.pnlTop.BackColor = System.Drawing.Color.Navy
        Me.pnlTop.Controls.Add(Me.lblTitle)
        Me.pnlTop.Controls.Add(Me.btnClose)
        Me.pnlTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlTop.Location = New System.Drawing.Point(0, 0)
        Me.pnlTop.Name = "pnlTop"
        Me.pnlTop.Size = New System.Drawing.Size(1000, 60)
        Me.pnlTop.TabIndex = 0
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 18.0!, System.Drawing.FontStyle.Bold)
        Me.lblTitle.ForeColor = System.Drawing.Color.White
        Me.lblTitle.Location = New System.Drawing.Point(12, 12)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(299, 32)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Petty Cash Management"
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(192, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(920, 12)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(68, 36)
        Me.btnClose.TabIndex = 1
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = False
        '
        'pnlHeader
        '
        Me.pnlHeader.BackColor = System.Drawing.Color.WhiteSmoke
        Me.pnlHeader.Controls.Add(Me.lblOpeningFloat)
        Me.pnlHeader.Controls.Add(Me.lblTotalExpenses)
        Me.pnlHeader.Controls.Add(Me.lblRemainingCash)
        Me.pnlHeader.Controls.Add(Me.btnTopUp)
        Me.pnlHeader.Controls.Add(Me.btnReconcile)
        Me.pnlHeader.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlHeader.Location = New System.Drawing.Point(0, 60)
        Me.pnlHeader.Name = "pnlHeader"
        Me.pnlHeader.Size = New System.Drawing.Size(1000, 80)
        Me.pnlHeader.TabIndex = 1
        '
        'lblOpeningFloat
        '
        Me.lblOpeningFloat.AutoSize = True
        Me.lblOpeningFloat.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.lblOpeningFloat.Location = New System.Drawing.Point(12, 15)
        Me.lblOpeningFloat.Name = "lblOpeningFloat"
        Me.lblOpeningFloat.Size = New System.Drawing.Size(178, 21)
        Me.lblOpeningFloat.TabIndex = 0
        Me.lblOpeningFloat.Text = "Opening Float: R 0.00"
        '
        'lblTotalExpenses
        '
        Me.lblTotalExpenses.AutoSize = True
        Me.lblTotalExpenses.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalExpenses.Location = New System.Drawing.Point(12, 45)
        Me.lblTotalExpenses.Name = "lblTotalExpenses"
        Me.lblTotalExpenses.Size = New System.Drawing.Size(162, 20)
        Me.lblTotalExpenses.TabIndex = 1
        Me.lblTotalExpenses.Text = "Total Expenses: R 0.00"
        '
        'lblRemainingCash
        '
        Me.lblRemainingCash.AutoSize = True
        Me.lblRemainingCash.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblRemainingCash.Location = New System.Drawing.Point(250, 45)
        Me.lblRemainingCash.Name = "lblRemainingCash"
        Me.lblRemainingCash.Size = New System.Drawing.Size(172, 20)
        Me.lblRemainingCash.TabIndex = 2
        Me.lblRemainingCash.Text = "Remaining Cash: R 0.00"
        '
        'btnTopUp
        '
        Me.btnTopUp.BackColor = System.Drawing.Color.DarkOrange
        Me.btnTopUp.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnTopUp.ForeColor = System.Drawing.Color.White
        Me.btnTopUp.Location = New System.Drawing.Point(650, 25)
        Me.btnTopUp.Name = "btnTopUp"
        Me.btnTopUp.Size = New System.Drawing.Size(150, 35)
        Me.btnTopUp.TabIndex = 3
        Me.btnTopUp.Text = "Top Up from Main Cash"
        Me.btnTopUp.UseVisualStyleBackColor = False
        '
        'btnReconcile
        '
        Me.btnReconcile.BackColor = System.Drawing.Color.Green
        Me.btnReconcile.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnReconcile.ForeColor = System.Drawing.Color.White
        Me.btnReconcile.Location = New System.Drawing.Point(820, 25)
        Me.btnReconcile.Name = "btnReconcile"
        Me.btnReconcile.Size = New System.Drawing.Size(150, 35)
        Me.btnReconcile.TabIndex = 4
        Me.btnReconcile.Text = "Reconcile"
        Me.btnReconcile.UseVisualStyleBackColor = False
        '
        'grpNewVoucher
        '
        Me.grpNewVoucher.Controls.Add(Me.lblVoucherNo)
        Me.grpNewVoucher.Controls.Add(Me.lblPayee)
        Me.grpNewVoucher.Controls.Add(Me.txtPayee)
        Me.grpNewVoucher.Controls.Add(Me.lblAmount)
        Me.grpNewVoucher.Controls.Add(Me.nudAmount)
        Me.grpNewVoucher.Controls.Add(Me.lblCategory)
        Me.grpNewVoucher.Controls.Add(Me.cboCategory)
        Me.grpNewVoucher.Controls.Add(Me.lblPurpose)
        Me.grpNewVoucher.Controls.Add(Me.txtPurpose)
        Me.grpNewVoucher.Controls.Add(Me.chkReceiptAttached)
        Me.grpNewVoucher.Controls.Add(Me.btnNewVoucher)
        Me.grpNewVoucher.Location = New System.Drawing.Point(12, 150)
        Me.grpNewVoucher.Name = "grpNewVoucher"
        Me.grpNewVoucher.Size = New System.Drawing.Size(976, 200)
        Me.grpNewVoucher.TabIndex = 2
        Me.grpNewVoucher.TabStop = False
        Me.grpNewVoucher.Text = "New Petty Cash Voucher"
        '
        'lblVoucherNo
        '
        Me.lblVoucherNo.AutoSize = True
        Me.lblVoucherNo.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.lblVoucherNo.Location = New System.Drawing.Point(15, 25)
        Me.lblVoucherNo.Name = "lblVoucherNo"
        Me.lblVoucherNo.Size = New System.Drawing.Size(130, 15)
        Me.lblVoucherNo.TabIndex = 0
        Me.lblVoucherNo.Text = "Voucher No: (Auto)"
        '
        'lblPayee
        '
        Me.lblPayee.AutoSize = True
        Me.lblPayee.Location = New System.Drawing.Point(15, 55)
        Me.lblPayee.Name = "lblPayee"
        Me.lblPayee.Size = New System.Drawing.Size(42, 15)
        Me.lblPayee.TabIndex = 1
        Me.lblPayee.Text = "Payee:"
        '
        'txtPayee
        '
        Me.txtPayee.Location = New System.Drawing.Point(100, 52)
        Me.txtPayee.Name = "txtPayee"
        Me.txtPayee.Size = New System.Drawing.Size(250, 23)
        Me.txtPayee.TabIndex = 2
        '
        'lblAmount
        '
        Me.lblAmount.AutoSize = True
        Me.lblAmount.Location = New System.Drawing.Point(370, 55)
        Me.lblAmount.Name = "lblAmount"
        Me.lblAmount.Size = New System.Drawing.Size(54, 15)
        Me.lblAmount.TabIndex = 3
        Me.lblAmount.Text = "Amount:"
        '
        'nudAmount
        '
        Me.nudAmount.DecimalPlaces = 2
        Me.nudAmount.Location = New System.Drawing.Point(440, 53)
        Me.nudAmount.Maximum = New Decimal(New Integer() {500, 0, 0, 0})
        Me.nudAmount.Name = "nudAmount"
        Me.nudAmount.Size = New System.Drawing.Size(120, 23)
        Me.nudAmount.TabIndex = 4
        Me.nudAmount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        Me.nudAmount.ThousandsSeparator = True
        '
        'lblCategory
        '
        Me.lblCategory.AutoSize = True
        Me.lblCategory.Location = New System.Drawing.Point(15, 95)
        Me.lblCategory.Name = "lblCategory"
        Me.lblCategory.Size = New System.Drawing.Size(58, 15)
        Me.lblCategory.TabIndex = 5
        Me.lblCategory.Text = "Category:"
        '
        'cboCategory
        '
        Me.cboCategory.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboCategory.FormattingEnabled = True
        Me.cboCategory.Location = New System.Drawing.Point(100, 92)
        Me.cboCategory.Name = "cboCategory"
        Me.cboCategory.Size = New System.Drawing.Size(250, 23)
        Me.cboCategory.TabIndex = 6
        '
        'lblPurpose
        '
        Me.lblPurpose.AutoSize = True
        Me.lblPurpose.Location = New System.Drawing.Point(15, 135)
        Me.lblPurpose.Name = "lblPurpose"
        Me.lblPurpose.Size = New System.Drawing.Size(53, 15)
        Me.lblPurpose.TabIndex = 7
        Me.lblPurpose.Text = "Purpose:"
        '
        'txtPurpose
        '
        Me.txtPurpose.Location = New System.Drawing.Point(100, 132)
        Me.txtPurpose.Multiline = True
        Me.txtPurpose.Name = "txtPurpose"
        Me.txtPurpose.Size = New System.Drawing.Size(460, 50)
        Me.txtPurpose.TabIndex = 8
        '
        'chkReceiptAttached
        '
        Me.chkReceiptAttached.AutoSize = True
        Me.chkReceiptAttached.Location = New System.Drawing.Point(580, 135)
        Me.chkReceiptAttached.Name = "chkReceiptAttached"
        Me.chkReceiptAttached.Size = New System.Drawing.Size(121, 19)
        Me.chkReceiptAttached.TabIndex = 9
        Me.chkReceiptAttached.Text = "Receipt Attached"
        Me.chkReceiptAttached.UseVisualStyleBackColor = True
        '
        'btnNewVoucher
        '
        Me.btnNewVoucher.BackColor = System.Drawing.Color.Green
        Me.btnNewVoucher.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnNewVoucher.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnNewVoucher.ForeColor = System.Drawing.Color.White
        Me.btnNewVoucher.Location = New System.Drawing.Point(800, 140)
        Me.btnNewVoucher.Name = "btnNewVoucher"
        Me.btnNewVoucher.Size = New System.Drawing.Size(150, 40)
        Me.btnNewVoucher.TabIndex = 10
        Me.btnNewVoucher.Text = "Create Voucher"
        Me.btnNewVoucher.UseVisualStyleBackColor = False
        '
        'grpTodaysVouchers
        '
        Me.grpTodaysVouchers.Controls.Add(Me.dgvVouchers)
        Me.grpTodaysVouchers.Location = New System.Drawing.Point(12, 360)
        Me.grpTodaysVouchers.Name = "grpTodaysVouchers"
        Me.grpTodaysVouchers.Size = New System.Drawing.Size(976, 250)
        Me.grpTodaysVouchers.TabIndex = 3
        Me.grpTodaysVouchers.TabStop = False
        Me.grpTodaysVouchers.Text = "Today's Vouchers"
        '
        'dgvVouchers
        '
        Me.dgvVouchers.AllowUserToAddRows = False
        Me.dgvVouchers.AllowUserToDeleteRows = False
        Me.dgvVouchers.BackgroundColor = System.Drawing.Color.White
        Me.dgvVouchers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvVouchers.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvVouchers.Location = New System.Drawing.Point(3, 19)
        Me.dgvVouchers.Name = "dgvVouchers"
        Me.dgvVouchers.ReadOnly = True
        Me.dgvVouchers.RowTemplate.Height = 25
        Me.dgvVouchers.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvVouchers.Size = New System.Drawing.Size(970, 228)
        Me.dgvVouchers.TabIndex = 0
        '
        'PettyCashForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1000, 620)
        Me.Controls.Add(Me.grpTodaysVouchers)
        Me.Controls.Add(Me.grpNewVoucher)
        Me.Controls.Add(Me.pnlHeader)
        Me.Controls.Add(Me.pnlTop)
        Me.Name = "PettyCashForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Petty Cash Management"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        Me.pnlHeader.ResumeLayout(False)
        Me.pnlHeader.PerformLayout()
        Me.grpNewVoucher.ResumeLayout(False)
        Me.grpNewVoucher.PerformLayout()
        CType(Me.nudAmount, System.ComponentModel.ISupportInitialize).EndInit()
        Me.grpTodaysVouchers.ResumeLayout(False)
        CType(Me.dgvVouchers, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents pnlTop As Panel
    Friend WithEvents lblTitle As Label
    Friend WithEvents btnClose As Button
    Friend WithEvents pnlHeader As Panel
    Friend WithEvents lblOpeningFloat As Label
    Friend WithEvents lblTotalExpenses As Label
    Friend WithEvents lblRemainingCash As Label
    Friend WithEvents btnTopUp As Button
    Friend WithEvents btnReconcile As Button
    Friend WithEvents grpNewVoucher As GroupBox
    Friend WithEvents lblVoucherNo As Label
    Friend WithEvents lblPayee As Label
    Friend WithEvents txtPayee As TextBox
    Friend WithEvents lblAmount As Label
    Friend WithEvents nudAmount As NumericUpDown
    Friend WithEvents lblCategory As Label
    Friend WithEvents cboCategory As ComboBox
    Friend WithEvents lblPurpose As Label
    Friend WithEvents txtPurpose As TextBox
    Friend WithEvents chkReceiptAttached As CheckBox
    Friend WithEvents btnNewVoucher As Button
    Friend WithEvents grpTodaysVouchers As GroupBox
    Friend WithEvents dgvVouchers As DataGridView
    End Class
End Namespace
