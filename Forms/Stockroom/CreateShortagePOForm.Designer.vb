<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CreateShortagePOForm
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
        Me.dgvShortages = New System.Windows.Forms.DataGridView()
        Me.cboSupplier = New System.Windows.Forms.ComboBox()
        Me.lblSupplier = New System.Windows.Forms.Label()
        Me.dtpRequiredDate = New System.Windows.Forms.DateTimePicker()
        Me.lblRequiredDate = New System.Windows.Forms.Label()
        Me.txtNotes = New System.Windows.Forms.TextBox()
        Me.lblNotes = New System.Windows.Forms.Label()
        Me.btnSelectAll = New System.Windows.Forms.Button()
        Me.btnDeselectAll = New System.Windows.Forms.Button()
        Me.btnCreatePO = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.chkLowStockOnly = New System.Windows.Forms.CheckBox()
        Me.txtTotalAmount = New System.Windows.Forms.TextBox()
        Me.lblTotalAmount = New System.Windows.Forms.Label()
        Me.pnlHeader = New System.Windows.Forms.Panel()
        Me.pnlButtons = New System.Windows.Forms.Panel()
        Me.pnlSummary = New System.Windows.Forms.Panel()
        CType(Me.dgvShortages, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlHeader.SuspendLayout()
        Me.pnlButtons.SuspendLayout()
        Me.pnlSummary.SuspendLayout()
        Me.SuspendLayout()
        '
        'dgvShortages
        '
        Me.dgvShortages.AllowUserToAddRows = False
        Me.dgvShortages.AllowUserToDeleteRows = False
        Me.dgvShortages.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvShortages.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvShortages.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvShortages.Location = New System.Drawing.Point(0, 120)
        Me.dgvShortages.MultiSelect = True
        Me.dgvShortages.Name = "dgvShortages"
        Me.dgvShortages.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvShortages.Size = New System.Drawing.Size(800, 280)
        Me.dgvShortages.TabIndex = 0
        '
        'cboSupplier
        '
        Me.cboSupplier.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboSupplier.FormattingEnabled = True
        Me.cboSupplier.Location = New System.Drawing.Point(100, 20)
        Me.cboSupplier.Name = "cboSupplier"
        Me.cboSupplier.Size = New System.Drawing.Size(200, 21)
        Me.cboSupplier.TabIndex = 1
        '
        'lblSupplier
        '
        Me.lblSupplier.AutoSize = True
        Me.lblSupplier.Location = New System.Drawing.Point(20, 23)
        Me.lblSupplier.Name = "lblSupplier"
        Me.lblSupplier.Size = New System.Drawing.Size(48, 13)
        Me.lblSupplier.TabIndex = 2
        Me.lblSupplier.Text = "Supplier:"
        '
        'dtpRequiredDate
        '
        Me.dtpRequiredDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpRequiredDate.Location = New System.Drawing.Point(420, 20)
        Me.dtpRequiredDate.Name = "dtpRequiredDate"
        Me.dtpRequiredDate.Size = New System.Drawing.Size(150, 20)
        Me.dtpRequiredDate.TabIndex = 3
        '
        'lblRequiredDate
        '
        Me.lblRequiredDate.AutoSize = True
        Me.lblRequiredDate.Location = New System.Drawing.Point(330, 23)
        Me.lblRequiredDate.Name = "lblRequiredDate"
        Me.lblRequiredDate.Size = New System.Drawing.Size(81, 13)
        Me.lblRequiredDate.TabIndex = 4
        Me.lblRequiredDate.Text = "Required Date:"
        '
        'txtNotes
        '
        Me.txtNotes.Location = New System.Drawing.Point(100, 50)
        Me.txtNotes.Multiline = True
        Me.txtNotes.Name = "txtNotes"
        Me.txtNotes.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtNotes.Size = New System.Drawing.Size(470, 50)
        Me.txtNotes.TabIndex = 5
        '
        'lblNotes
        '
        Me.lblNotes.AutoSize = True
        Me.lblNotes.Location = New System.Drawing.Point(20, 53)
        Me.lblNotes.Name = "lblNotes"
        Me.lblNotes.Size = New System.Drawing.Size(38, 13)
        Me.lblNotes.TabIndex = 6
        Me.lblNotes.Text = "Notes:"
        '
        'btnSelectAll
        '
        Me.btnSelectAll.Location = New System.Drawing.Point(10, 10)
        Me.btnSelectAll.Name = "btnSelectAll"
        Me.btnSelectAll.Size = New System.Drawing.Size(75, 23)
        Me.btnSelectAll.TabIndex = 7
        Me.btnSelectAll.Text = "Select All"
        Me.btnSelectAll.UseVisualStyleBackColor = True
        '
        'btnDeselectAll
        '
        Me.btnDeselectAll.Location = New System.Drawing.Point(91, 10)
        Me.btnDeselectAll.Name = "btnDeselectAll"
        Me.btnDeselectAll.Size = New System.Drawing.Size(85, 23)
        Me.btnDeselectAll.TabIndex = 8
        Me.btnDeselectAll.Text = "Deselect All"
        Me.btnDeselectAll.UseVisualStyleBackColor = True
        '
        'btnCreatePO
        '
        Me.btnCreatePO.Location = New System.Drawing.Point(634, 10)
        Me.btnCreatePO.Name = "btnCreatePO"
        Me.btnCreatePO.Size = New System.Drawing.Size(75, 23)
        Me.btnCreatePO.TabIndex = 9
        Me.btnCreatePO.Text = "Create PO"
        Me.btnCreatePO.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(715, 10)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 10
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'btnRefresh
        '
        Me.btnRefresh.Location = New System.Drawing.Point(182, 10)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(75, 23)
        Me.btnRefresh.TabIndex = 11
        Me.btnRefresh.Text = "Refresh"
        Me.btnRefresh.UseVisualStyleBackColor = True
        '
        'chkLowStockOnly
        '
        Me.chkLowStockOnly.AutoSize = True
        Me.chkLowStockOnly.Checked = True
        Me.chkLowStockOnly.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkLowStockOnly.Location = New System.Drawing.Point(600, 22)
        Me.chkLowStockOnly.Name = "chkLowStockOnly"
        Me.chkLowStockOnly.Size = New System.Drawing.Size(108, 17)
        Me.chkLowStockOnly.TabIndex = 12
        Me.chkLowStockOnly.Text = "Low Stock Only"
        Me.chkLowStockOnly.UseVisualStyleBackColor = True
        '
        'txtTotalAmount
        '
        Me.txtTotalAmount.Location = New System.Drawing.Point(100, 10)
        Me.txtTotalAmount.Name = "txtTotalAmount"
        Me.txtTotalAmount.ReadOnly = True
        Me.txtTotalAmount.Size = New System.Drawing.Size(120, 20)
        Me.txtTotalAmount.TabIndex = 13
        Me.txtTotalAmount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'lblTotalAmount
        '
        Me.lblTotalAmount.AutoSize = True
        Me.lblTotalAmount.Location = New System.Drawing.Point(20, 13)
        Me.lblTotalAmount.Name = "lblTotalAmount"
        Me.lblTotalAmount.Size = New System.Drawing.Size(74, 13)
        Me.lblTotalAmount.TabIndex = 14
        Me.lblTotalAmount.Text = "Total Amount:"
        '
        'pnlHeader
        '
        Me.pnlHeader.Controls.Add(Me.lblSupplier)
        Me.pnlHeader.Controls.Add(Me.chkLowStockOnly)
        Me.pnlHeader.Controls.Add(Me.cboSupplier)
        Me.pnlHeader.Controls.Add(Me.lblRequiredDate)
        Me.pnlHeader.Controls.Add(Me.dtpRequiredDate)
        Me.pnlHeader.Controls.Add(Me.lblNotes)
        Me.pnlHeader.Controls.Add(Me.txtNotes)
        Me.pnlHeader.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlHeader.Location = New System.Drawing.Point(0, 0)
        Me.pnlHeader.Name = "pnlHeader"
        Me.pnlHeader.Size = New System.Drawing.Size(800, 120)
        Me.pnlHeader.TabIndex = 15
        '
        'pnlButtons
        '
        Me.pnlButtons.Controls.Add(Me.btnSelectAll)
        Me.pnlButtons.Controls.Add(Me.btnDeselectAll)
        Me.pnlButtons.Controls.Add(Me.btnRefresh)
        Me.pnlButtons.Controls.Add(Me.btnCreatePO)
        Me.pnlButtons.Controls.Add(Me.btnCancel)
        Me.pnlButtons.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlButtons.Location = New System.Drawing.Point(0, 440)
        Me.pnlButtons.Name = "pnlButtons"
        Me.pnlButtons.Size = New System.Drawing.Size(800, 43)
        Me.pnlButtons.TabIndex = 16
        '
        'pnlSummary
        '
        Me.pnlSummary.Controls.Add(Me.lblTotalAmount)
        Me.pnlSummary.Controls.Add(Me.txtTotalAmount)
        Me.pnlSummary.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlSummary.Location = New System.Drawing.Point(0, 400)
        Me.pnlSummary.Name = "pnlSummary"
        Me.pnlSummary.Size = New System.Drawing.Size(800, 40)
        Me.pnlSummary.TabIndex = 17
        '
        'CreateShortagePOForm
        '
        Me.AcceptButton = Me.btnCreatePO
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(800, 483)
        Me.Controls.Add(Me.dgvShortages)
        Me.Controls.Add(Me.pnlSummary)
        Me.Controls.Add(Me.pnlButtons)
        Me.Controls.Add(Me.pnlHeader)
        Me.Name = "CreateShortagePOForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Create Purchase Order for Shortages"
        CType(Me.dgvShortages, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlHeader.ResumeLayout(False)
        Me.pnlHeader.PerformLayout()
        Me.pnlButtons.ResumeLayout(False)
        Me.pnlSummary.ResumeLayout(False)
        Me.pnlSummary.PerformLayout()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents dgvShortages As DataGridView
    Friend WithEvents cboSupplier As ComboBox
    Friend WithEvents lblSupplier As Label
    Friend WithEvents dtpRequiredDate As DateTimePicker
    Friend WithEvents lblRequiredDate As Label
    Friend WithEvents txtNotes As TextBox
    Friend WithEvents lblNotes As Label
    Friend WithEvents btnSelectAll As Button
    Friend WithEvents btnDeselectAll As Button
    Friend WithEvents btnCreatePO As Button
    Friend WithEvents btnCancel As Button
    Friend WithEvents btnRefresh As Button
    Friend WithEvents chkLowStockOnly As CheckBox
    Friend WithEvents txtTotalAmount As TextBox
    Friend WithEvents lblTotalAmount As Label
    Friend WithEvents pnlHeader As Panel
    Friend WithEvents pnlButtons As Panel
    Friend WithEvents pnlSummary As Panel

End Class
