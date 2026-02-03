<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class BatchPaymentForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
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

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.pnlTop = New System.Windows.Forms.Panel()
        Me.lblTitle = New System.Windows.Forms.Label()
        Me.pnlBatchInfo = New System.Windows.Forms.Panel()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.txtBatchNumber = New System.Windows.Forms.TextBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.dtpPaymentDate = New System.Windows.Forms.DateTimePicker()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.cmbPaymentMethod = New System.Windows.Forms.ComboBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.cmbBankAccount = New System.Windows.Forms.ComboBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.txtNotes = New System.Windows.Forms.TextBox()
        Me.btnCreateBatch = New System.Windows.Forms.Button()
        Me.pnlInvoices = New System.Windows.Forms.Panel()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.dgvUnpaidInvoices = New System.Windows.Forms.DataGridView()
        Me.lblTotalInvoices = New System.Windows.Forms.Label()
        Me.lblTotalDue = New System.Windows.Forms.Label()
        Me.btnAddSelected = New System.Windows.Forms.Button()
        Me.pnlBatch = New System.Windows.Forms.Panel()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.dgvBatchItems = New System.Windows.Forms.DataGridView()
        Me.lblBatchCount = New System.Windows.Forms.Label()
        Me.lblBatchTotal = New System.Windows.Forms.Label()
        Me.btnProcessBatch = New System.Windows.Forms.Button()
        Me.btnPrintSchedule = New System.Windows.Forms.Button()
        Me.btnSubmitFNB = New System.Windows.Forms.Button()
        Me.btnViewTransactions = New System.Windows.Forms.Button()
        Me.btnLoadBatch = New System.Windows.Forms.Button()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.pnlTop.SuspendLayout()
        Me.pnlBatchInfo.SuspendLayout()
        Me.pnlInvoices.SuspendLayout()
        CType(Me.dgvUnpaidInvoices, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlBatch.SuspendLayout()
        CType(Me.dgvBatchItems, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'pnlTop
        '
        Me.pnlTop.BackColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(73, Byte), Integer), CType(CType(94, Byte), Integer))
        Me.pnlTop.Controls.Add(Me.lblTitle)
        Me.pnlTop.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlTop.Location = New System.Drawing.Point(0, 0)
        Me.pnlTop.Name = "pnlTop"
        Me.pnlTop.Size = New System.Drawing.Size(1400, 60)
        Me.pnlTop.TabIndex = 0
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 18.0!, System.Drawing.FontStyle.Bold)
        Me.lblTitle.ForeColor = System.Drawing.Color.White
        Me.lblTitle.Location = New System.Drawing.Point(12, 12)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(338, 32)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Batch Invoice Payment"
        '
        'pnlBatchInfo
        '
        Me.pnlBatchInfo.BackColor = System.Drawing.Color.White
        Me.pnlBatchInfo.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.pnlBatchInfo.Controls.Add(Me.btnLoadBatch)
        Me.pnlBatchInfo.Controls.Add(Me.btnCreateBatch)
        Me.pnlBatchInfo.Controls.Add(Me.txtNotes)
        Me.pnlBatchInfo.Controls.Add(Me.Label5)
        Me.pnlBatchInfo.Controls.Add(Me.cmbBankAccount)
        Me.pnlBatchInfo.Controls.Add(Me.Label4)
        Me.pnlBatchInfo.Controls.Add(Me.cmbPaymentMethod)
        Me.pnlBatchInfo.Controls.Add(Me.Label3)
        Me.pnlBatchInfo.Controls.Add(Me.dtpPaymentDate)
        Me.pnlBatchInfo.Controls.Add(Me.Label2)
        Me.pnlBatchInfo.Controls.Add(Me.txtBatchNumber)
        Me.pnlBatchInfo.Controls.Add(Me.Label1)
        Me.pnlBatchInfo.Location = New System.Drawing.Point(12, 70)
        Me.pnlBatchInfo.Name = "pnlBatchInfo"
        Me.pnlBatchInfo.Size = New System.Drawing.Size(1376, 120)
        Me.pnlBatchInfo.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.Label1.Location = New System.Drawing.Point(10, 15)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(91, 15)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Batch Number:"
        '
        'txtBatchNumber
        '
        Me.txtBatchNumber.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.txtBatchNumber.Location = New System.Drawing.Point(110, 12)
        Me.txtBatchNumber.Name = "txtBatchNumber"
        Me.txtBatchNumber.ReadOnly = True
        Me.txtBatchNumber.Size = New System.Drawing.Size(150, 23)
        Me.txtBatchNumber.TabIndex = 1
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.Label2.Location = New System.Drawing.Point(280, 15)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(91, 15)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Payment Date:"
        '
        'dtpPaymentDate
        '
        Me.dtpPaymentDate.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.dtpPaymentDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpPaymentDate.Location = New System.Drawing.Point(380, 12)
        Me.dtpPaymentDate.Name = "dtpPaymentDate"
        Me.dtpPaymentDate.Size = New System.Drawing.Size(150, 23)
        Me.dtpPaymentDate.TabIndex = 3
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.Label3.Location = New System.Drawing.Point(550, 15)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(109, 15)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "Payment Method:"
        '
        'cmbPaymentMethod
        '
        Me.cmbPaymentMethod.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbPaymentMethod.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.cmbPaymentMethod.FormattingEnabled = True
        Me.cmbPaymentMethod.Location = New System.Drawing.Point(670, 12)
        Me.cmbPaymentMethod.Name = "cmbPaymentMethod"
        Me.cmbPaymentMethod.Size = New System.Drawing.Size(150, 23)
        Me.cmbPaymentMethod.TabIndex = 5
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.Label4.Location = New System.Drawing.Point(10, 50)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(88, 15)
        Me.Label4.TabIndex = 6
        Me.Label4.Text = "Bank Account:"
        '
        'cmbBankAccount
        '
        Me.cmbBankAccount.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbBankAccount.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.cmbBankAccount.FormattingEnabled = True
        Me.cmbBankAccount.Location = New System.Drawing.Point(110, 47)
        Me.cmbBankAccount.Name = "cmbBankAccount"
        Me.cmbBankAccount.Size = New System.Drawing.Size(420, 23)
        Me.cmbBankAccount.TabIndex = 7
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.Label5.Location = New System.Drawing.Point(10, 85)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(43, 15)
        Me.Label5.TabIndex = 8
        Me.Label5.Text = "Notes:"
        '
        'txtNotes
        '
        Me.txtNotes.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.txtNotes.Location = New System.Drawing.Point(110, 82)
        Me.txtNotes.Name = "txtNotes"
        Me.txtNotes.Size = New System.Drawing.Size(710, 23)
        Me.txtNotes.TabIndex = 9
        '
        'btnCreateBatch
        '
        Me.btnCreateBatch.BackColor = System.Drawing.Color.FromArgb(CType(CType(46, Byte), Integer), CType(CType(204, Byte), Integer), CType(CType(113, Byte), Integer))
        Me.btnCreateBatch.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnCreateBatch.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnCreateBatch.ForeColor = System.Drawing.Color.White
        Me.btnCreateBatch.Location = New System.Drawing.Point(1050, 80)
        Me.btnCreateBatch.Name = "btnCreateBatch"
        Me.btnCreateBatch.Size = New System.Drawing.Size(150, 30)
        Me.btnCreateBatch.TabIndex = 10
        Me.btnCreateBatch.Text = "Create Batch"
        Me.btnCreateBatch.UseVisualStyleBackColor = False
        '
        'btnLoadBatch
        '
        Me.btnLoadBatch.BackColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(152, Byte), Integer), CType(CType(219, Byte), Integer))
        Me.btnLoadBatch.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnLoadBatch.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnLoadBatch.ForeColor = System.Drawing.Color.White
        Me.btnLoadBatch.Location = New System.Drawing.Point(1210, 80)
        Me.btnLoadBatch.Name = "btnLoadBatch"
        Me.btnLoadBatch.Size = New System.Drawing.Size(150, 30)
        Me.btnLoadBatch.TabIndex = 11
        Me.btnLoadBatch.Text = "Load Saved Batch"
        Me.btnLoadBatch.UseVisualStyleBackColor = False
        '
        'pnlInvoices
        '
        Me.pnlInvoices.BackColor = System.Drawing.Color.White
        Me.pnlInvoices.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.pnlInvoices.Controls.Add(Me.btnAddSelected)
        Me.pnlInvoices.Controls.Add(Me.lblTotalDue)
        Me.pnlInvoices.Controls.Add(Me.lblTotalInvoices)
        Me.pnlInvoices.Controls.Add(Me.dgvUnpaidInvoices)
        Me.pnlInvoices.Controls.Add(Me.Label6)
        Me.pnlInvoices.Location = New System.Drawing.Point(12, 200)
        Me.pnlInvoices.Name = "pnlInvoices"
        Me.pnlInvoices.Size = New System.Drawing.Size(1376, 300)
        Me.pnlInvoices.TabIndex = 2
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.Label6.Location = New System.Drawing.Point(10, 10)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(125, 20)
        Me.Label6.TabIndex = 0
        Me.Label6.Text = "Unpaid Invoices"
        '
        'dgvUnpaidInvoices
        '
        Me.dgvUnpaidInvoices.AllowUserToAddRows = False
        Me.dgvUnpaidInvoices.AllowUserToDeleteRows = False
        Me.dgvUnpaidInvoices.BackgroundColor = System.Drawing.Color.White
        Me.dgvUnpaidInvoices.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvUnpaidInvoices.Location = New System.Drawing.Point(10, 40)
        Me.dgvUnpaidInvoices.Name = "dgvUnpaidInvoices"
        Me.dgvUnpaidInvoices.Size = New System.Drawing.Size(1350, 210)
        Me.dgvUnpaidInvoices.TabIndex = 1
        '
        'lblTotalInvoices
        '
        Me.lblTotalInvoices.AutoSize = True
        Me.lblTotalInvoices.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalInvoices.Location = New System.Drawing.Point(10, 260)
        Me.lblTotalInvoices.Name = "lblTotalInvoices"
        Me.lblTotalInvoices.Size = New System.Drawing.Size(91, 15)
        Me.lblTotalInvoices.TabIndex = 2
        Me.lblTotalInvoices.Text = "Total Invoices: 0"
        '
        'lblTotalDue
        '
        Me.lblTotalDue.AutoSize = True
        Me.lblTotalDue.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalDue.Location = New System.Drawing.Point(200, 260)
        Me.lblTotalDue.Name = "lblTotalDue"
        Me.lblTotalDue.Size = New System.Drawing.Size(90, 15)
        Me.lblTotalDue.TabIndex = 3
        Me.lblTotalDue.Text = "Total Due: R0.00"
        '
        'btnAddSelected
        '
        Me.btnAddSelected.BackColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(152, Byte), Integer), CType(CType(219, Byte), Integer))
        Me.btnAddSelected.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnAddSelected.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnAddSelected.ForeColor = System.Drawing.Color.White
        Me.btnAddSelected.Location = New System.Drawing.Point(1210, 255)
        Me.btnAddSelected.Name = "btnAddSelected"
        Me.btnAddSelected.Size = New System.Drawing.Size(150, 30)
        Me.btnAddSelected.TabIndex = 4
        Me.btnAddSelected.Text = "Add Selected to Batch"
        Me.btnAddSelected.UseVisualStyleBackColor = False
        '
        'pnlBatch
        '
        Me.pnlBatch.BackColor = System.Drawing.Color.White
        Me.pnlBatch.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.pnlBatch.Controls.Add(Me.btnRemoveFromBatch)
        Me.pnlBatch.Controls.Add(Me.btnViewTransactions)
        Me.pnlBatch.Controls.Add(Me.btnSubmitFNB)
        Me.pnlBatch.Controls.Add(Me.btnPrintSchedule)
        Me.pnlBatch.Controls.Add(Me.btnProcessBatch)
        Me.pnlBatch.Controls.Add(Me.lblBatchTotal)
        Me.pnlBatch.Controls.Add(Me.lblBatchCount)
        Me.pnlBatch.Controls.Add(Me.dgvBatchItems)
        Me.pnlBatch.Controls.Add(Me.Label7)
        Me.pnlBatch.Location = New System.Drawing.Point(12, 510)
        Me.pnlBatch.Name = "pnlBatch"
        Me.pnlBatch.Size = New System.Drawing.Size(1376, 250)
        Me.pnlBatch.TabIndex = 3
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.Label7.Location = New System.Drawing.Point(10, 10)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(149, 20)
        Me.Label7.TabIndex = 0
        Me.Label7.Text = "Current Batch Items"
        '
        'dgvBatchItems
        '
        Me.dgvBatchItems.AllowUserToAddRows = False
        Me.dgvBatchItems.AllowUserToDeleteRows = False
        Me.dgvBatchItems.BackgroundColor = System.Drawing.Color.White
        Me.dgvBatchItems.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvBatchItems.Location = New System.Drawing.Point(10, 40)
        Me.dgvBatchItems.Name = "dgvBatchItems"
        Me.dgvBatchItems.ReadOnly = True
        Me.dgvBatchItems.Size = New System.Drawing.Size(1350, 160)
        Me.dgvBatchItems.TabIndex = 1
        '
        'lblBatchCount
        '
        Me.lblBatchCount.AutoSize = True
        Me.lblBatchCount.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.lblBatchCount.Location = New System.Drawing.Point(10, 210)
        Me.lblBatchCount.Name = "lblBatchCount"
        Me.lblBatchCount.Size = New System.Drawing.Size(65, 15)
        Me.lblBatchCount.TabIndex = 2
        Me.lblBatchCount.Text = "Invoices: 0"
        '
        'lblBatchTotal
        '
        Me.lblBatchTotal.AutoSize = True
        Me.lblBatchTotal.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.lblBatchTotal.Location = New System.Drawing.Point(200, 210)
        Me.lblBatchTotal.Name = "lblBatchTotal"
        Me.lblBatchTotal.Size = New System.Drawing.Size(108, 15)
        Me.lblBatchTotal.TabIndex = 3
        Me.lblBatchTotal.Text = "Batch Total: R0.00"
        '
        'btnProcessBatch
        '
        Me.btnProcessBatch.BackColor = System.Drawing.Color.FromArgb(CType(CType(231, Byte), Integer), CType(CType(76, Byte), Integer), CType(CType(60, Byte), Integer))
        Me.btnProcessBatch.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnProcessBatch.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnProcessBatch.ForeColor = System.Drawing.Color.White
        Me.btnProcessBatch.Location = New System.Drawing.Point(710, 205)
        Me.btnProcessBatch.Name = "btnProcessBatch"
        Me.btnProcessBatch.Size = New System.Drawing.Size(160, 30)
        Me.btnProcessBatch.TabIndex = 4
        Me.btnProcessBatch.Text = "Process Payment"
        Me.btnProcessBatch.UseVisualStyleBackColor = False
        '
        'btnPrintSchedule
        '
        Me.btnPrintSchedule.BackColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(152, Byte), Integer), CType(CType(219, Byte), Integer))
        Me.btnPrintSchedule.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnPrintSchedule.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnPrintSchedule.ForeColor = System.Drawing.Color.White
        Me.btnPrintSchedule.Location = New System.Drawing.Point(880, 205)
        Me.btnPrintSchedule.Name = "btnPrintSchedule"
        Me.btnPrintSchedule.Size = New System.Drawing.Size(160, 30)
        Me.btnPrintSchedule.TabIndex = 5
        Me.btnPrintSchedule.Text = "Print Payment Schedule"
        Me.btnPrintSchedule.UseVisualStyleBackColor = False
        '
        'btnSubmitFNB
        '
        Me.btnSubmitFNB.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.btnSubmitFNB.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnSubmitFNB.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnSubmitFNB.ForeColor = System.Drawing.Color.White
        Me.btnSubmitFNB.Location = New System.Drawing.Point(1050, 205)
        Me.btnSubmitFNB.Name = "btnSubmitFNB"
        Me.btnSubmitFNB.Size = New System.Drawing.Size(150, 30)
        Me.btnSubmitFNB.TabIndex = 6
        Me.btnSubmitFNB.Text = "Submit to FNB API"
        Me.btnSubmitFNB.UseVisualStyleBackColor = False
        '
        'btnViewTransactions
        '
        Me.btnViewTransactions.BackColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(152, Byte), Integer), CType(CType(219, Byte), Integer))
        Me.btnViewTransactions.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnViewTransactions.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnViewTransactions.ForeColor = System.Drawing.Color.White
        Me.btnViewTransactions.Location = New System.Drawing.Point(1210, 205)
        Me.btnViewTransactions.Name = "btnViewTransactions"
        Me.btnViewTransactions.Size = New System.Drawing.Size(150, 30)
        Me.btnViewTransactions.TabIndex = 7
        Me.btnViewTransactions.Text = "View Transactions"
        Me.btnViewTransactions.UseVisualStyleBackColor = False
        '
        'btnRemoveFromBatch
        '
        Me.btnRemoveFromBatch.BackColor = System.Drawing.Color.FromArgb(CType(CType(231, Byte), Integer), CType(CType(76, Byte), Integer), CType(CType(60, Byte), Integer))
        Me.btnRemoveFromBatch.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnRemoveFromBatch.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnRemoveFromBatch.ForeColor = System.Drawing.Color.White
        Me.btnRemoveFromBatch.Location = New System.Drawing.Point(540, 205)
        Me.btnRemoveFromBatch.Name = "btnRemoveFromBatch"
        Me.btnRemoveFromBatch.Size = New System.Drawing.Size(160, 30)
        Me.btnRemoveFromBatch.TabIndex = 8
        Me.btnRemoveFromBatch.Text = "Remove from Batch"
        Me.btnRemoveFromBatch.UseVisualStyleBackColor = False
        '
        'btnClose
        '
        Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(149, Byte), Integer), CType(CType(165, Byte), Integer), CType(CType(166, Byte), Integer))
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(1238, 770)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(150, 35)
        Me.btnClose.TabIndex = 4
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = False
        '
        'BatchPaymentForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.FromArgb(CType(CType(236, Byte), Integer), CType(CType(240, Byte), Integer), CType(CType(241, Byte), Integer))
        Me.ClientSize = New System.Drawing.Size(1400, 820)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.pnlBatch)
        Me.Controls.Add(Me.pnlInvoices)
        Me.Controls.Add(Me.pnlBatchInfo)
        Me.Controls.Add(Me.pnlTop)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.Name = "BatchPaymentForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Batch Invoice Payment"
        Me.pnlTop.ResumeLayout(False)
        Me.pnlTop.PerformLayout()
        Me.pnlBatchInfo.ResumeLayout(False)
        Me.pnlBatchInfo.PerformLayout()
        Me.pnlInvoices.ResumeLayout(False)
        Me.pnlInvoices.PerformLayout()
        CType(Me.dgvUnpaidInvoices, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlBatch.ResumeLayout(False)
        Me.pnlBatch.PerformLayout()
        CType(Me.dgvBatchItems, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents pnlTop As Panel
    Friend WithEvents lblTitle As Label
    Friend WithEvents pnlBatchInfo As Panel
    Friend WithEvents Label1 As Label
    Friend WithEvents txtBatchNumber As TextBox
    Friend WithEvents Label2 As Label
    Friend WithEvents dtpPaymentDate As DateTimePicker
    Friend WithEvents Label3 As Label
    Friend WithEvents cmbPaymentMethod As ComboBox
    Friend WithEvents Label4 As Label
    Friend WithEvents cmbBankAccount As ComboBox
    Friend WithEvents Label5 As Label
    Friend WithEvents txtNotes As TextBox
    Friend WithEvents btnCreateBatch As Button
    Friend WithEvents btnLoadBatch As Button
    Friend WithEvents pnlInvoices As Panel
    Friend WithEvents Label6 As Label
    Friend WithEvents dgvUnpaidInvoices As DataGridView
    Friend WithEvents lblTotalInvoices As Label
    Friend WithEvents lblTotalDue As Label
    Friend WithEvents btnAddSelected As Button
    Friend WithEvents pnlBatch As Panel
    Friend WithEvents Label7 As Label
    Friend WithEvents dgvBatchItems As DataGridView
    Friend WithEvents lblBatchCount As Label
    Friend WithEvents lblBatchTotal As Label
    Friend WithEvents btnProcessBatch As Button
    Friend WithEvents btnPrintSchedule As Button
    Friend WithEvents btnSubmitFNB As Button
    Friend WithEvents btnViewTransactions As Button
    Friend WithEvents btnRemoveFromBatch As Button
    Friend WithEvents btnClose As Button
End Class
