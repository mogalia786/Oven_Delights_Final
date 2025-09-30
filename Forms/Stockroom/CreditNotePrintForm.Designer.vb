<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CreditNotePrintForm
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
        Me.pnlHeader = New System.Windows.Forms.Panel()
        Me.lblCompanyName = New System.Windows.Forms.Label()
        Me.lblCompanyAddress = New System.Windows.Forms.Label()
        Me.lblTitle = New System.Windows.Forms.Label()
        Me.pnlCreditNoteInfo = New System.Windows.Forms.Panel()
        Me.lblCreditNoteNumber = New System.Windows.Forms.Label()
        Me.lblCreditDate = New System.Windows.Forms.Label()
        Me.lblSupplierInfo = New System.Windows.Forms.Label()
        Me.txtCreditNoteNumber = New System.Windows.Forms.TextBox()
        Me.txtCreditDate = New System.Windows.Forms.TextBox()
        Me.txtSupplierInfo = New System.Windows.Forms.TextBox()
        Me.dgvCreditLines = New System.Windows.Forms.DataGridView()
        Me.pnlTotals = New System.Windows.Forms.Panel()
        Me.lblSubTotal = New System.Windows.Forms.Label()
        Me.lblVATAmount = New System.Windows.Forms.Label()
        Me.lblTotalAmount = New System.Windows.Forms.Label()
        Me.txtSubTotal = New System.Windows.Forms.TextBox()
        Me.txtVATAmount = New System.Windows.Forms.TextBox()
        Me.txtTotalAmount = New System.Windows.Forms.TextBox()
        Me.pnlFooter = New System.Windows.Forms.Panel()
        Me.lblReason = New System.Windows.Forms.Label()
        Me.txtReason = New System.Windows.Forms.TextBox()
        Me.pnlButtons = New System.Windows.Forms.Panel()
        Me.btnPrint = New System.Windows.Forms.Button()
        Me.btnPreview = New System.Windows.Forms.Button()
        Me.btnExportPDF = New System.Windows.Forms.Button()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.pnlHeader.SuspendLayout()
        Me.pnlCreditNoteInfo.SuspendLayout()
        CType(Me.dgvCreditLines, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlTotals.SuspendLayout()
        Me.pnlFooter.SuspendLayout()
        Me.pnlButtons.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlHeader
        '
        Me.pnlHeader.BackColor = System.Drawing.SystemColors.Control
        Me.pnlHeader.Controls.Add(Me.lblCompanyName)
        Me.pnlHeader.Controls.Add(Me.lblCompanyAddress)
        Me.pnlHeader.Controls.Add(Me.lblTitle)
        Me.pnlHeader.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlHeader.Location = New System.Drawing.Point(0, 0)
        Me.pnlHeader.Name = "pnlHeader"
        Me.pnlHeader.Size = New System.Drawing.Size(800, 100)
        Me.pnlHeader.TabIndex = 0
        '
        'lblCompanyName
        '
        Me.lblCompanyName.AutoSize = True
        Me.lblCompanyName.Font = New System.Drawing.Font("Microsoft Sans Serif", 14.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblCompanyName.Location = New System.Drawing.Point(20, 20)
        Me.lblCompanyName.Name = "lblCompanyName"
        Me.lblCompanyName.Size = New System.Drawing.Size(127, 24)
        Me.lblCompanyName.TabIndex = 0
        Me.lblCompanyName.Text = "Oven Delights"
        '
        'lblCompanyAddress
        '
        Me.lblCompanyAddress.AutoSize = True
        Me.lblCompanyAddress.Location = New System.Drawing.Point(20, 50)
        Me.lblCompanyAddress.Name = "lblCompanyAddress"
        Me.lblCompanyAddress.Size = New System.Drawing.Size(200, 13)
        Me.lblCompanyAddress.TabIndex = 1
        Me.lblCompanyAddress.Text = "123 Business Street, City, Province, Code"
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Microsoft Sans Serif", 16.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTitle.Location = New System.Drawing.Point(600, 30)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(135, 26)
        Me.lblTitle.TabIndex = 2
        Me.lblTitle.Text = "Credit Note"
        '
        'pnlCreditNoteInfo
        '
        Me.pnlCreditNoteInfo.Controls.Add(Me.lblCreditNoteNumber)
        Me.pnlCreditNoteInfo.Controls.Add(Me.lblCreditDate)
        Me.pnlCreditNoteInfo.Controls.Add(Me.lblSupplierInfo)
        Me.pnlCreditNoteInfo.Controls.Add(Me.txtCreditNoteNumber)
        Me.pnlCreditNoteInfo.Controls.Add(Me.txtCreditDate)
        Me.pnlCreditNoteInfo.Controls.Add(Me.txtSupplierInfo)
        Me.pnlCreditNoteInfo.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlCreditNoteInfo.Location = New System.Drawing.Point(0, 100)
        Me.pnlCreditNoteInfo.Name = "pnlCreditNoteInfo"
        Me.pnlCreditNoteInfo.Size = New System.Drawing.Size(800, 120)
        Me.pnlCreditNoteInfo.TabIndex = 1
        '
        'lblCreditNoteNumber
        '
        Me.lblCreditNoteNumber.AutoSize = True
        Me.lblCreditNoteNumber.Location = New System.Drawing.Point(20, 20)
        Me.lblCreditNoteNumber.Name = "lblCreditNoteNumber"
        Me.lblCreditNoteNumber.Size = New System.Drawing.Size(105, 13)
        Me.lblCreditNoteNumber.TabIndex = 0
        Me.lblCreditNoteNumber.Text = "Credit Note Number:"
        '
        'lblCreditDate
        '
        Me.lblCreditDate.AutoSize = True
        Me.lblCreditDate.Location = New System.Drawing.Point(20, 50)
        Me.lblCreditDate.Name = "lblCreditDate"
        Me.lblCreditDate.Size = New System.Drawing.Size(66, 13)
        Me.lblCreditDate.TabIndex = 1
        Me.lblCreditDate.Text = "Credit Date:"
        '
        'lblSupplierInfo
        '
        Me.lblSupplierInfo.AutoSize = True
        Me.lblSupplierInfo.Location = New System.Drawing.Point(400, 20)
        Me.lblSupplierInfo.Name = "lblSupplierInfo"
        Me.lblSupplierInfo.Size = New System.Drawing.Size(48, 13)
        Me.lblSupplierInfo.TabIndex = 2
        Me.lblSupplierInfo.Text = "Supplier:"
        '
        'txtCreditNoteNumber
        '
        Me.txtCreditNoteNumber.Location = New System.Drawing.Point(140, 17)
        Me.txtCreditNoteNumber.Name = "txtCreditNoteNumber"
        Me.txtCreditNoteNumber.ReadOnly = True
        Me.txtCreditNoteNumber.Size = New System.Drawing.Size(150, 20)
        Me.txtCreditNoteNumber.TabIndex = 3
        '
        'txtCreditDate
        '
        Me.txtCreditDate.Location = New System.Drawing.Point(140, 47)
        Me.txtCreditDate.Name = "txtCreditDate"
        Me.txtCreditDate.ReadOnly = True
        Me.txtCreditDate.Size = New System.Drawing.Size(150, 20)
        Me.txtCreditDate.TabIndex = 4
        '
        'txtSupplierInfo
        '
        Me.txtSupplierInfo.Location = New System.Drawing.Point(460, 17)
        Me.txtSupplierInfo.Multiline = True
        Me.txtSupplierInfo.Name = "txtSupplierInfo"
        Me.txtSupplierInfo.ReadOnly = True
        Me.txtSupplierInfo.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtSupplierInfo.Size = New System.Drawing.Size(320, 80)
        Me.txtSupplierInfo.TabIndex = 5
        '
        'dgvCreditLines
        '
        Me.dgvCreditLines.AllowUserToAddRows = False
        Me.dgvCreditLines.AllowUserToDeleteRows = False
        Me.dgvCreditLines.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvCreditLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvCreditLines.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvCreditLines.Location = New System.Drawing.Point(0, 220)
        Me.dgvCreditLines.Name = "dgvCreditLines"
        Me.dgvCreditLines.ReadOnly = True
        Me.dgvCreditLines.Size = New System.Drawing.Size(800, 200)
        Me.dgvCreditLines.TabIndex = 2
        '
        'pnlTotals
        '
        Me.pnlTotals.Controls.Add(Me.lblSubTotal)
        Me.pnlTotals.Controls.Add(Me.lblVATAmount)
        Me.pnlTotals.Controls.Add(Me.lblTotalAmount)
        Me.pnlTotals.Controls.Add(Me.txtSubTotal)
        Me.pnlTotals.Controls.Add(Me.txtVATAmount)
        Me.pnlTotals.Controls.Add(Me.txtTotalAmount)
        Me.pnlTotals.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlTotals.Location = New System.Drawing.Point(0, 420)
        Me.pnlTotals.Name = "pnlTotals"
        Me.pnlTotals.Size = New System.Drawing.Size(800, 80)
        Me.pnlTotals.TabIndex = 3
        '
        'lblSubTotal
        '
        Me.lblSubTotal.AutoSize = True
        Me.lblSubTotal.Location = New System.Drawing.Point(500, 20)
        Me.lblSubTotal.Name = "lblSubTotal"
        Me.lblSubTotal.Size = New System.Drawing.Size(56, 13)
        Me.lblSubTotal.TabIndex = 0
        Me.lblSubTotal.Text = "Sub Total:"
        '
        'lblVATAmount
        '
        Me.lblVATAmount.AutoSize = True
        Me.lblVATAmount.Location = New System.Drawing.Point(500, 40)
        Me.lblVATAmount.Name = "lblVATAmount"
        Me.lblVATAmount.Size = New System.Drawing.Size(31, 13)
        Me.lblVATAmount.TabIndex = 1
        Me.lblVATAmount.Text = "VAT:"
        '
        'lblTotalAmount
        '
        Me.lblTotalAmount.AutoSize = True
        Me.lblTotalAmount.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTotalAmount.Location = New System.Drawing.Point(500, 60)
        Me.lblTotalAmount.Name = "lblTotalAmount"
        Me.lblTotalAmount.Size = New System.Drawing.Size(40, 13)
        Me.lblTotalAmount.TabIndex = 2
        Me.lblTotalAmount.Text = "Total:"
        '
        'txtSubTotal
        '
        Me.txtSubTotal.Location = New System.Drawing.Point(580, 17)
        Me.txtSubTotal.Name = "txtSubTotal"
        Me.txtSubTotal.ReadOnly = True
        Me.txtSubTotal.Size = New System.Drawing.Size(100, 20)
        Me.txtSubTotal.TabIndex = 3
        Me.txtSubTotal.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'txtVATAmount
        '
        Me.txtVATAmount.Location = New System.Drawing.Point(580, 37)
        Me.txtVATAmount.Name = "txtVATAmount"
        Me.txtVATAmount.ReadOnly = True
        Me.txtVATAmount.Size = New System.Drawing.Size(100, 20)
        Me.txtVATAmount.TabIndex = 4
        Me.txtVATAmount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'txtTotalAmount
        '
        Me.txtTotalAmount.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTotalAmount.Location = New System.Drawing.Point(580, 57)
        Me.txtTotalAmount.Name = "txtTotalAmount"
        Me.txtTotalAmount.ReadOnly = True
        Me.txtTotalAmount.Size = New System.Drawing.Size(100, 20)
        Me.txtTotalAmount.TabIndex = 5
        Me.txtTotalAmount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'pnlFooter
        '
        Me.pnlFooter.Controls.Add(Me.lblReason)
        Me.pnlFooter.Controls.Add(Me.txtReason)
        Me.pnlFooter.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlFooter.Location = New System.Drawing.Point(0, 500)
        Me.pnlFooter.Name = "pnlFooter"
        Me.pnlFooter.Size = New System.Drawing.Size(800, 80)
        Me.pnlFooter.TabIndex = 4
        '
        'lblReason
        '
        Me.lblReason.AutoSize = True
        Me.lblReason.Location = New System.Drawing.Point(20, 20)
        Me.lblReason.Name = "lblReason"
        Me.lblReason.Size = New System.Drawing.Size(47, 13)
        Me.lblReason.TabIndex = 0
        Me.lblReason.Text = "Reason:"
        '
        'txtReason
        '
        Me.txtReason.Location = New System.Drawing.Point(80, 17)
        Me.txtReason.Multiline = True
        Me.txtReason.Name = "txtReason"
        Me.txtReason.ReadOnly = True
        Me.txtReason.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtReason.Size = New System.Drawing.Size(600, 50)
        Me.txtReason.TabIndex = 1
        '
        'pnlButtons
        '
        Me.pnlButtons.Controls.Add(Me.btnPrint)
        Me.pnlButtons.Controls.Add(Me.btnPreview)
        Me.pnlButtons.Controls.Add(Me.btnExportPDF)
        Me.pnlButtons.Controls.Add(Me.btnClose)
        Me.pnlButtons.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlButtons.Location = New System.Drawing.Point(0, 580)
        Me.pnlButtons.Name = "pnlButtons"
        Me.pnlButtons.Size = New System.Drawing.Size(800, 50)
        Me.pnlButtons.TabIndex = 5
        '
        'btnPrint
        '
        Me.btnPrint.Location = New System.Drawing.Point(550, 15)
        Me.btnPrint.Name = "btnPrint"
        Me.btnPrint.Size = New System.Drawing.Size(75, 23)
        Me.btnPrint.TabIndex = 0
        Me.btnPrint.Text = "Print"
        Me.btnPrint.UseVisualStyleBackColor = True
        '
        'btnPreview
        '
        Me.btnPreview.Location = New System.Drawing.Point(469, 15)
        Me.btnPreview.Name = "btnPreview"
        Me.btnPreview.Size = New System.Drawing.Size(75, 23)
        Me.btnPreview.TabIndex = 1
        Me.btnPreview.Text = "Preview"
        Me.btnPreview.UseVisualStyleBackColor = True
        '
        'btnExportPDF
        '
        Me.btnExportPDF.Location = New System.Drawing.Point(631, 15)
        Me.btnExportPDF.Name = "btnExportPDF"
        Me.btnExportPDF.Size = New System.Drawing.Size(80, 23)
        Me.btnExportPDF.TabIndex = 2
        Me.btnExportPDF.Text = "Export PDF"
        Me.btnExportPDF.UseVisualStyleBackColor = True
        '
        'btnClose
        '
        Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnClose.Location = New System.Drawing.Point(717, 15)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(75, 23)
        Me.btnClose.TabIndex = 3
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = True
        '
        'CreditNotePrintForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnClose
        Me.ClientSize = New System.Drawing.Size(800, 630)
        Me.Controls.Add(Me.dgvCreditLines)
        Me.Controls.Add(Me.pnlTotals)
        Me.Controls.Add(Me.pnlFooter)
        Me.Controls.Add(Me.pnlButtons)
        Me.Controls.Add(Me.pnlCreditNoteInfo)
        Me.Controls.Add(Me.pnlHeader)
        Me.Name = "CreditNotePrintForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Credit Note Print Preview"
        Me.pnlHeader.ResumeLayout(False)
        Me.pnlHeader.PerformLayout()
        Me.pnlCreditNoteInfo.ResumeLayout(False)
        Me.pnlCreditNoteInfo.PerformLayout()
        CType(Me.dgvCreditLines, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlTotals.ResumeLayout(False)
        Me.pnlTotals.PerformLayout()
        Me.pnlFooter.ResumeLayout(False)
        Me.pnlFooter.PerformLayout()
        Me.pnlButtons.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents pnlHeader As Panel
    Friend WithEvents lblCompanyName As Label
    Friend WithEvents lblCompanyAddress As Label
    Friend WithEvents lblTitle As Label
    Friend WithEvents pnlCreditNoteInfo As Panel
    Friend WithEvents lblCreditNoteNumber As Label
    Friend WithEvents lblCreditDate As Label
    Friend WithEvents lblSupplierInfo As Label
    Friend WithEvents txtCreditNoteNumber As TextBox
    Friend WithEvents txtCreditDate As TextBox
    Friend WithEvents txtSupplierInfo As TextBox
    Friend WithEvents dgvCreditLines As DataGridView
    Friend WithEvents pnlTotals As Panel
    Friend WithEvents lblSubTotal As Label
    Friend WithEvents lblVATAmount As Label
    Friend WithEvents lblTotalAmount As Label
    Friend WithEvents txtSubTotal As TextBox
    Friend WithEvents txtVATAmount As TextBox
    Friend WithEvents txtTotalAmount As TextBox
    Friend WithEvents pnlFooter As Panel
    Friend WithEvents lblReason As Label
    Friend WithEvents txtReason As TextBox
    Friend WithEvents pnlButtons As Panel
    Friend WithEvents btnPrint As Button
    Friend WithEvents btnPreview As Button
    Friend WithEvents btnExportPDF As Button
    Friend WithEvents btnClose As Button

End Class
