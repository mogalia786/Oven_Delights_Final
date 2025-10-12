<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CreditNoteCreateForm
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
        Me.cboCreditType = New System.Windows.Forms.ComboBox()
        Me.txtReason = New System.Windows.Forms.TextBox()
        Me.dtpCreditDate = New System.Windows.Forms.DateTimePicker()
        Me.dgvGRVLines = New System.Windows.Forms.DataGridView()
        Me.dgvCreditLines = New System.Windows.Forms.DataGridView()
        Me.btnAddLine = New System.Windows.Forms.Button()
        Me.btnRemoveLine = New System.Windows.Forms.Button()
        Me.btnCreate = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.lblCreditType = New System.Windows.Forms.Label()
        Me.lblReason = New System.Windows.Forms.Label()
        Me.lblCreditDate = New System.Windows.Forms.Label()
        Me.lblGRVLines = New System.Windows.Forms.Label()
        Me.lblCreditLines = New System.Windows.Forms.Label()
        Me.txtSubTotal = New System.Windows.Forms.TextBox()
        Me.txtVATAmount = New System.Windows.Forms.TextBox()
        Me.txtTotalAmount = New System.Windows.Forms.TextBox()
        Me.lblSubTotal = New System.Windows.Forms.Label()
        Me.lblVATAmount = New System.Windows.Forms.Label()
        Me.lblTotalAmount = New System.Windows.Forms.Label()
        Me.pnlHeader = New System.Windows.Forms.Panel()
        Me.pnlMain = New System.Windows.Forms.Panel()
        Me.pnlGRVLines = New System.Windows.Forms.Panel()
        Me.pnlCreditLines = New System.Windows.Forms.Panel()
        Me.pnlButtons = New System.Windows.Forms.Panel()
        Me.pnlTotals = New System.Windows.Forms.Panel()
        CType(Me.dgvGRVLines, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dgvCreditLines, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlHeader.SuspendLayout()
        Me.pnlMain.SuspendLayout()
        Me.pnlGRVLines.SuspendLayout()
        Me.pnlCreditLines.SuspendLayout()
        Me.pnlButtons.SuspendLayout()
        Me.pnlTotals.SuspendLayout()
        Me.SuspendLayout()
        '
        'cboCreditType
        '
        Me.cboCreditType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboCreditType.FormattingEnabled = True
        Me.cboCreditType.Location = New System.Drawing.Point(100, 20)
        Me.cboCreditType.Name = "cboCreditType"
        Me.cboCreditType.Size = New System.Drawing.Size(150, 21)
        Me.cboCreditType.TabIndex = 0
        '
        'txtReason
        '
        Me.txtReason.Location = New System.Drawing.Point(100, 50)
        Me.txtReason.Multiline = True
        Me.txtReason.Name = "txtReason"
        Me.txtReason.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtReason.Size = New System.Drawing.Size(400, 60)
        Me.txtReason.TabIndex = 1
        '
        'dtpCreditDate
        '
        Me.dtpCreditDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpCreditDate.Location = New System.Drawing.Point(350, 20)
        Me.dtpCreditDate.Name = "dtpCreditDate"
        Me.dtpCreditDate.Size = New System.Drawing.Size(150, 20)
        Me.dtpCreditDate.TabIndex = 2
        '
        'dgvGRVLines
        '
        Me.dgvGRVLines.AllowUserToAddRows = False
        Me.dgvGRVLines.AllowUserToDeleteRows = False
        Me.dgvGRVLines.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvGRVLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvGRVLines.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvGRVLines.Location = New System.Drawing.Point(0, 25)
        Me.dgvGRVLines.MultiSelect = False
        Me.dgvGRVLines.Name = "dgvGRVLines"
        Me.dgvGRVLines.ReadOnly = True
        Me.dgvGRVLines.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvGRVLines.Size = New System.Drawing.Size(390, 175)
        Me.dgvGRVLines.TabIndex = 3
        '
        'dgvCreditLines
        '
        Me.dgvCreditLines.AllowUserToAddRows = False
        Me.dgvCreditLines.AllowUserToDeleteRows = False
        Me.dgvCreditLines.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvCreditLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvCreditLines.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvCreditLines.Location = New System.Drawing.Point(0, 25)
        Me.dgvCreditLines.MultiSelect = False
        Me.dgvCreditLines.Name = "dgvCreditLines"
        Me.dgvCreditLines.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvCreditLines.Size = New System.Drawing.Size(400, 175)
        Me.dgvCreditLines.TabIndex = 4
        '
        'btnAddLine
        '
        Me.btnAddLine.Location = New System.Drawing.Point(10, 10)
        Me.btnAddLine.Name = "btnAddLine"
        Me.btnAddLine.Size = New System.Drawing.Size(75, 23)
        Me.btnAddLine.TabIndex = 5
        Me.btnAddLine.Text = "Add Line"
        Me.btnAddLine.UseVisualStyleBackColor = True
        '
        'btnRemoveLine
        '
        Me.btnRemoveLine.Location = New System.Drawing.Point(91, 10)
        Me.btnRemoveLine.Name = "btnRemoveLine"
        Me.btnRemoveLine.Size = New System.Drawing.Size(85, 23)
        Me.btnRemoveLine.TabIndex = 6
        Me.btnRemoveLine.Text = "Remove Line"
        Me.btnRemoveLine.UseVisualStyleBackColor = True
        '
        'btnCreate
        '
        Me.btnCreate.Location = New System.Drawing.Point(634, 10)
        Me.btnCreate.Name = "btnCreate"
        Me.btnCreate.Size = New System.Drawing.Size(75, 23)
        Me.btnCreate.TabIndex = 7
        Me.btnCreate.Text = "Create"
        Me.btnCreate.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(715, 10)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 8
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'lblCreditType
        '
        Me.lblCreditType.AutoSize = True
        Me.lblCreditType.Location = New System.Drawing.Point(20, 23)
        Me.lblCreditType.Name = "lblCreditType"
        Me.lblCreditType.Size = New System.Drawing.Size(66, 13)
        Me.lblCreditType.TabIndex = 9
        Me.lblCreditType.Text = "Credit Type:"
        '
        'lblReason
        '
        Me.lblReason.AutoSize = True
        Me.lblReason.Location = New System.Drawing.Point(20, 53)
        Me.lblReason.Name = "lblReason"
        Me.lblReason.Size = New System.Drawing.Size(47, 13)
        Me.lblReason.TabIndex = 10
        Me.lblReason.Text = "Reason:"
        '
        'lblCreditDate
        '
        Me.lblCreditDate.AutoSize = True
        Me.lblCreditDate.Location = New System.Drawing.Point(270, 23)
        Me.lblCreditDate.Name = "lblCreditDate"
        Me.lblCreditDate.Size = New System.Drawing.Size(66, 13)
        Me.lblCreditDate.TabIndex = 11
        Me.lblCreditDate.Text = "Credit Date:"
        '
        'lblGRVLines
        '
        Me.lblGRVLines.BackColor = System.Drawing.SystemColors.ActiveCaption
        Me.lblGRVLines.Dock = System.Windows.Forms.DockStyle.Top
        Me.lblGRVLines.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblGRVLines.Location = New System.Drawing.Point(0, 0)
        Me.lblGRVLines.Name = "lblGRVLines"
        Me.lblGRVLines.Size = New System.Drawing.Size(390, 25)
        Me.lblGRVLines.TabIndex = 12
        Me.lblGRVLines.Text = "GRV Lines"
        Me.lblGRVLines.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'lblCreditLines
        '
        Me.lblCreditLines.BackColor = System.Drawing.SystemColors.ActiveCaption
        Me.lblCreditLines.Dock = System.Windows.Forms.DockStyle.Top
        Me.lblCreditLines.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblCreditLines.Location = New System.Drawing.Point(0, 0)
        Me.lblCreditLines.Name = "lblCreditLines"
        Me.lblCreditLines.Size = New System.Drawing.Size(400, 25)
        Me.lblCreditLines.TabIndex = 13
        Me.lblCreditLines.Text = "Credit Note Lines"
        Me.lblCreditLines.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'txtSubTotal
        '
        Me.txtSubTotal.Location = New System.Drawing.Point(100, 10)
        Me.txtSubTotal.Name = "txtSubTotal"
        Me.txtSubTotal.ReadOnly = True
        Me.txtSubTotal.Size = New System.Drawing.Size(100, 20)
        Me.txtSubTotal.TabIndex = 14
        Me.txtSubTotal.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'txtVATAmount
        '
        Me.txtVATAmount.Location = New System.Drawing.Point(280, 10)
        Me.txtVATAmount.Name = "txtVATAmount"
        Me.txtVATAmount.ReadOnly = True
        Me.txtVATAmount.Size = New System.Drawing.Size(100, 20)
        Me.txtVATAmount.TabIndex = 15
        Me.txtVATAmount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'txtTotalAmount
        '
        Me.txtTotalAmount.Location = New System.Drawing.Point(480, 10)
        Me.txtTotalAmount.Name = "txtTotalAmount"
        Me.txtTotalAmount.ReadOnly = True
        Me.txtTotalAmount.Size = New System.Drawing.Size(100, 20)
        Me.txtTotalAmount.TabIndex = 16
        Me.txtTotalAmount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'lblSubTotal
        '
        Me.lblSubTotal.AutoSize = True
        Me.lblSubTotal.Location = New System.Drawing.Point(20, 13)
        Me.lblSubTotal.Name = "lblSubTotal"
        Me.lblSubTotal.Size = New System.Drawing.Size(56, 13)
        Me.lblSubTotal.TabIndex = 17
        Me.lblSubTotal.Text = "Sub Total:"
        '
        'lblVATAmount
        '
        Me.lblVATAmount.AutoSize = True
        Me.lblVATAmount.Location = New System.Drawing.Point(220, 13)
        Me.lblVATAmount.Name = "lblVATAmount"
        Me.lblVATAmount.Size = New System.Drawing.Size(31, 13)
        Me.lblVATAmount.TabIndex = 18
        Me.lblVATAmount.Text = "VAT:"
        '
        'lblTotalAmount
        '
        Me.lblTotalAmount.AutoSize = True
        Me.lblTotalAmount.Location = New System.Drawing.Point(420, 13)
        Me.lblTotalAmount.Name = "lblTotalAmount"
        Me.lblTotalAmount.Size = New System.Drawing.Size(34, 13)
        Me.lblTotalAmount.TabIndex = 19
        Me.lblTotalAmount.Text = "Total:"
        '
        'pnlHeader
        '
        Me.pnlHeader.Controls.Add(Me.lblCreditType)
        Me.pnlHeader.Controls.Add(Me.cboCreditType)
        Me.pnlHeader.Controls.Add(Me.lblCreditDate)
        Me.pnlHeader.Controls.Add(Me.dtpCreditDate)
        Me.pnlHeader.Controls.Add(Me.lblReason)
        Me.pnlHeader.Controls.Add(Me.txtReason)
        Me.pnlHeader.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlHeader.Location = New System.Drawing.Point(0, 0)
        Me.pnlHeader.Name = "pnlHeader"
        Me.pnlHeader.Size = New System.Drawing.Size(800, 130)
        Me.pnlHeader.TabIndex = 20
        '
        'pnlMain
        '
        Me.pnlMain.Controls.Add(Me.pnlGRVLines)
        Me.pnlMain.Controls.Add(Me.pnlCreditLines)
        Me.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMain.Location = New System.Drawing.Point(0, 130)
        Me.pnlMain.Name = "pnlMain"
        Me.pnlMain.Size = New System.Drawing.Size(800, 200)
        Me.pnlMain.TabIndex = 21
        '
        'pnlGRVLines
        '
        Me.pnlGRVLines.Controls.Add(Me.dgvGRVLines)
        Me.pnlGRVLines.Controls.Add(Me.lblGRVLines)
        Me.pnlGRVLines.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlGRVLines.Location = New System.Drawing.Point(0, 0)
        Me.pnlGRVLines.Name = "pnlGRVLines"
        Me.pnlGRVLines.Size = New System.Drawing.Size(390, 200)
        Me.pnlGRVLines.TabIndex = 22
        '
        'pnlCreditLines
        '
        Me.pnlCreditLines.Controls.Add(Me.dgvCreditLines)
        Me.pnlCreditLines.Controls.Add(Me.lblCreditLines)
        Me.pnlCreditLines.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlCreditLines.Location = New System.Drawing.Point(390, 0)
        Me.pnlCreditLines.Name = "pnlCreditLines"
        Me.pnlCreditLines.Size = New System.Drawing.Size(400, 200)
        Me.pnlCreditLines.TabIndex = 23
        '
        'pnlButtons
        '
        Me.pnlButtons.Controls.Add(Me.btnAddLine)
        Me.pnlButtons.Controls.Add(Me.btnRemoveLine)
        Me.pnlButtons.Controls.Add(Me.btnCreate)
        Me.pnlButtons.Controls.Add(Me.btnCancel)
        Me.pnlButtons.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlButtons.Location = New System.Drawing.Point(0, 370)
        Me.pnlButtons.Name = "pnlButtons"
        Me.pnlButtons.Size = New System.Drawing.Size(800, 43)
        Me.pnlButtons.TabIndex = 24
        '
        'pnlTotals
        '
        Me.pnlTotals.Controls.Add(Me.lblSubTotal)
        Me.pnlTotals.Controls.Add(Me.txtSubTotal)
        Me.pnlTotals.Controls.Add(Me.lblVATAmount)
        Me.pnlTotals.Controls.Add(Me.txtVATAmount)
        Me.pnlTotals.Controls.Add(Me.lblTotalAmount)
        Me.pnlTotals.Controls.Add(Me.txtTotalAmount)
        Me.pnlTotals.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlTotals.Location = New System.Drawing.Point(0, 330)
        Me.pnlTotals.Name = "pnlTotals"
        Me.pnlTotals.Size = New System.Drawing.Size(800, 40)
        Me.pnlTotals.TabIndex = 25
        '
        'CreditNoteCreateForm
        '
        Me.AcceptButton = Me.btnCreate
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(800, 413)
        Me.Controls.Add(Me.pnlMain)
        Me.Controls.Add(Me.pnlTotals)
        Me.Controls.Add(Me.pnlButtons)
        Me.Controls.Add(Me.pnlHeader)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.Name = "CreditNoteCreateForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Create Credit Note"
        CType(Me.dgvGRVLines, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.dgvCreditLines, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlHeader.ResumeLayout(False)
        Me.pnlHeader.PerformLayout()
        Me.pnlMain.ResumeLayout(False)
        Me.pnlGRVLines.ResumeLayout(False)
        Me.pnlCreditLines.ResumeLayout(False)
        Me.pnlButtons.ResumeLayout(False)
        Me.pnlTotals.ResumeLayout(False)
        Me.pnlTotals.PerformLayout()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents cboCreditType As ComboBox
    Friend WithEvents txtReason As TextBox
    Friend WithEvents dtpCreditDate As DateTimePicker
    Friend WithEvents dgvGRVLines As DataGridView
    Friend WithEvents dgvCreditLines As DataGridView
    Friend WithEvents btnAddLine As Button
    Friend WithEvents btnRemoveLine As Button
    Friend WithEvents btnCreate As Button
    Friend WithEvents btnCancel As Button
    Friend WithEvents lblCreditType As Label
    Friend WithEvents lblReason As Label
    Friend WithEvents lblCreditDate As Label
    Friend WithEvents lblGRVLines As Label
    Friend WithEvents lblCreditLines As Label
    Friend WithEvents txtSubTotal As TextBox
    Friend WithEvents txtVATAmount As TextBox
    Friend WithEvents txtTotalAmount As TextBox
    Friend WithEvents lblSubTotal As Label
    Friend WithEvents lblVATAmount As Label
    Friend WithEvents lblTotalAmount As Label
    Friend WithEvents pnlHeader As Panel
    Friend WithEvents pnlMain As Panel
    Friend WithEvents pnlGRVLines As Panel
    Friend WithEvents pnlCreditLines As Panel
    Friend WithEvents pnlButtons As Panel
    Friend WithEvents pnlTotals As Panel

End Class
