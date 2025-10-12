<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class GRVCreateForm
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
        Me.cboPurchaseOrder = New System.Windows.Forms.ComboBox()
        Me.cboSupplier = New System.Windows.Forms.ComboBox()
        Me.cboBranch = New System.Windows.Forms.ComboBox()
        Me.txtDeliveryNote = New System.Windows.Forms.TextBox()
        Me.dtpDeliveryDate = New System.Windows.Forms.DateTimePicker()
        Me.txtNotes = New System.Windows.Forms.TextBox()
        Me.dgvPOLines = New System.Windows.Forms.DataGridView()
        Me.btnCreate = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.lblPO = New System.Windows.Forms.Label()
        Me.lblSupplier = New System.Windows.Forms.Label()
        Me.lblBranch = New System.Windows.Forms.Label()
        Me.lblDeliveryNote = New System.Windows.Forms.Label()
        Me.lblDeliveryDate = New System.Windows.Forms.Label()
        Me.lblNotes = New System.Windows.Forms.Label()
        Me.pnlHeader = New System.Windows.Forms.Panel()
        CType(Me.dgvPOLines, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlHeader.SuspendLayout()
        Me.SuspendLayout()
        '
        'cboPurchaseOrder
        '
        Me.cboPurchaseOrder.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboPurchaseOrder.FormattingEnabled = True
        Me.cboPurchaseOrder.Location = New System.Drawing.Point(130, 18)
        Me.cboPurchaseOrder.Name = "cboPurchaseOrder"
        Me.cboPurchaseOrder.Size = New System.Drawing.Size(200, 21)
        Me.cboPurchaseOrder.TabIndex = 0
        '
        'cboSupplier
        '
        Me.cboSupplier.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboSupplier.Enabled = False
        Me.cboSupplier.FormattingEnabled = True
        Me.cboSupplier.Location = New System.Drawing.Point(460, 18)
        Me.cboSupplier.Name = "cboSupplier"
        Me.cboSupplier.Size = New System.Drawing.Size(200, 21)
        Me.cboSupplier.TabIndex = 1
        '
        'cboBranch
        '
        Me.cboBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBranch.Enabled = False
        Me.cboBranch.FormattingEnabled = True
        Me.cboBranch.Location = New System.Drawing.Point(130, 50)
        Me.cboBranch.Name = "cboBranch"
        Me.cboBranch.Size = New System.Drawing.Size(200, 21)
        Me.cboBranch.TabIndex = 2
        '
        'txtDeliveryNote
        '
        Me.txtDeliveryNote.Location = New System.Drawing.Point(460, 50)
        Me.txtDeliveryNote.Name = "txtDeliveryNote"
        Me.txtDeliveryNote.Size = New System.Drawing.Size(200, 20)
        Me.txtDeliveryNote.TabIndex = 3
        '
        'dtpDeliveryDate
        '
        Me.dtpDeliveryDate.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpDeliveryDate.Location = New System.Drawing.Point(130, 82)
        Me.dtpDeliveryDate.Name = "dtpDeliveryDate"
        Me.dtpDeliveryDate.Size = New System.Drawing.Size(200, 20)
        Me.dtpDeliveryDate.TabIndex = 4
        '
        'txtNotes
        '
        Me.txtNotes.Location = New System.Drawing.Point(130, 114)
        Me.txtNotes.Multiline = True
        Me.txtNotes.Name = "txtNotes"
        Me.txtNotes.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtNotes.Size = New System.Drawing.Size(530, 60)
        Me.txtNotes.TabIndex = 5
        '
        'dgvPOLines
        '
        Me.dgvPOLines.AllowUserToAddRows = False
        Me.dgvPOLines.AllowUserToDeleteRows = False
        Me.dgvPOLines.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvPOLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvPOLines.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvPOLines.Location = New System.Drawing.Point(0, 200)
        Me.dgvPOLines.MultiSelect = False
        Me.dgvPOLines.Name = "dgvPOLines"
        Me.dgvPOLines.ReadOnly = True
        Me.dgvPOLines.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvPOLines.Size = New System.Drawing.Size(784, 301)
        Me.dgvPOLines.TabIndex = 6
        '
        'btnCreate
        '
        Me.btnCreate.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCreate.Location = New System.Drawing.Point(616, 520)
        Me.btnCreate.Name = "btnCreate"
        Me.btnCreate.Size = New System.Drawing.Size(75, 23)
        Me.btnCreate.TabIndex = 7
        Me.btnCreate.Text = "Create GRV"
        Me.btnCreate.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(697, 520)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 8
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'lblPO
        '
        Me.lblPO.AutoSize = True
        Me.lblPO.Location = New System.Drawing.Point(20, 21)
        Me.lblPO.Name = "lblPO"
        Me.lblPO.Size = New System.Drawing.Size(84, 13)
        Me.lblPO.TabIndex = 9
        Me.lblPO.Text = "Purchase Order:"
        '
        'lblSupplier
        '
        Me.lblSupplier.AutoSize = True
        Me.lblSupplier.Location = New System.Drawing.Point(350, 21)
        Me.lblSupplier.Name = "lblSupplier"
        Me.lblSupplier.Size = New System.Drawing.Size(48, 13)
        Me.lblSupplier.TabIndex = 10
        Me.lblSupplier.Text = "Supplier:"
        '
        'lblBranch
        '
        Me.lblBranch.AutoSize = True
        Me.lblBranch.Location = New System.Drawing.Point(20, 53)
        Me.lblBranch.Name = "lblBranch"
        Me.lblBranch.Size = New System.Drawing.Size(44, 13)
        Me.lblBranch.TabIndex = 11
        Me.lblBranch.Text = "Branch:"
        '
        'lblDeliveryNote
        '
        Me.lblDeliveryNote.AutoSize = True
        Me.lblDeliveryNote.Location = New System.Drawing.Point(350, 53)
        Me.lblDeliveryNote.Name = "lblDeliveryNote"
        Me.lblDeliveryNote.Size = New System.Drawing.Size(75, 13)
        Me.lblDeliveryNote.TabIndex = 12
        Me.lblDeliveryNote.Text = "Delivery Note:"
        '
        'lblDeliveryDate
        '
        Me.lblDeliveryDate.AutoSize = True
        Me.lblDeliveryDate.Location = New System.Drawing.Point(20, 85)
        Me.lblDeliveryDate.Name = "lblDeliveryDate"
        Me.lblDeliveryDate.Size = New System.Drawing.Size(75, 13)
        Me.lblDeliveryDate.TabIndex = 13
        Me.lblDeliveryDate.Text = "Delivery Date:"
        '
        'lblNotes
        '
        Me.lblNotes.AutoSize = True
        Me.lblNotes.Location = New System.Drawing.Point(20, 117)
        Me.lblNotes.Name = "lblNotes"
        Me.lblNotes.Size = New System.Drawing.Size(38, 13)
        Me.lblNotes.TabIndex = 14
        Me.lblNotes.Text = "Notes:"
        '
        'pnlHeader
        '
        Me.pnlHeader.Controls.Add(Me.lblPO)
        Me.pnlHeader.Controls.Add(Me.lblNotes)
        Me.pnlHeader.Controls.Add(Me.cboPurchaseOrder)
        Me.pnlHeader.Controls.Add(Me.lblDeliveryDate)
        Me.pnlHeader.Controls.Add(Me.cboSupplier)
        Me.pnlHeader.Controls.Add(Me.lblDeliveryNote)
        Me.pnlHeader.Controls.Add(Me.cboBranch)
        Me.pnlHeader.Controls.Add(Me.lblBranch)
        Me.pnlHeader.Controls.Add(Me.txtDeliveryNote)
        Me.pnlHeader.Controls.Add(Me.lblSupplier)
        Me.pnlHeader.Controls.Add(Me.dtpDeliveryDate)
        Me.pnlHeader.Controls.Add(Me.txtNotes)
        Me.pnlHeader.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlHeader.Location = New System.Drawing.Point(0, 0)
        Me.pnlHeader.Name = "pnlHeader"
        Me.pnlHeader.Size = New System.Drawing.Size(784, 200)
        Me.pnlHeader.TabIndex = 15
        '
        'GRVCreateForm
        '
        Me.AcceptButton = Me.btnCreate
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(784, 561)
        Me.Controls.Add(Me.dgvPOLines)
        Me.Controls.Add(Me.pnlHeader)
        Me.Controls.Add(Me.btnCreate)
        Me.Controls.Add(Me.btnCancel)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.Name = "GRVCreateForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Create GRV from Purchase Order"
        CType(Me.dgvPOLines, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlHeader.ResumeLayout(False)
        Me.pnlHeader.PerformLayout()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents cboPurchaseOrder As ComboBox
    Friend WithEvents cboSupplier As ComboBox
    Friend WithEvents cboBranch As ComboBox
    Friend WithEvents txtDeliveryNote As TextBox
    Friend WithEvents dtpDeliveryDate As DateTimePicker
    Friend WithEvents txtNotes As TextBox
    Friend WithEvents dgvPOLines As DataGridView
    Friend WithEvents btnCreate As Button
    Friend WithEvents btnCancel As Button
    Friend WithEvents lblPO As Label
    Friend WithEvents lblSupplier As Label
    Friend WithEvents lblBranch As Label
    Friend WithEvents lblDeliveryNote As Label
    Friend WithEvents lblDeliveryDate As Label
    Friend WithEvents lblNotes As Label
    Friend WithEvents pnlHeader As Panel

End Class
