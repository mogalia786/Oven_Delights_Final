<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class POReceivingForm
    Inherits System.Windows.Forms.Form

    <System.Diagnostics.DebuggerNonUserCode()>
    Protected Overrides Sub Dispose(disposing As Boolean)
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
        Me.lblTitle = New System.Windows.Forms.Label()
        Me.lblSKU = New System.Windows.Forms.Label()
        Me.txtSKU = New System.Windows.Forms.TextBox()
        Me.lblQty = New System.Windows.Forms.Label()
        Me.numQty = New System.Windows.Forms.NumericUpDown()
        Me.lblUnitCost = New System.Windows.Forms.Label()
        Me.numUnitCost = New System.Windows.Forms.NumericUpDown()
        Me.lblSupplier = New System.Windows.Forms.Label()
        Me.txtSupplier = New System.Windows.Forms.TextBox()
        Me.lblSupplierInv = New System.Windows.Forms.Label()
        Me.txtSupplierInv = New System.Windows.Forms.TextBox()
        Me.lblBatch = New System.Windows.Forms.Label()
        Me.txtBatch = New System.Windows.Forms.TextBox()
        Me.lblExpiry = New System.Windows.Forms.Label()
        Me.dtpExpiry = New System.Windows.Forms.DateTimePicker()
        Me.lblNotes = New System.Windows.Forms.Label()
        Me.txtNotes = New System.Windows.Forms.TextBox()
        Me.lblBranch = New System.Windows.Forms.Label()
        Me.cboBranch = New System.Windows.Forms.ComboBox()
        Me.btnReceive = New System.Windows.Forms.Button()
        CType(Me.numQty, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.numUnitCost, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        ' lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.lblTitle.Location = New System.Drawing.Point(24, 18)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(365, 25)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Storeroom (External PO) → Retail Receipt"
        '
        ' lblSKU
        '
        Me.lblSKU.AutoSize = True
        Me.lblSKU.Location = New System.Drawing.Point(24, 64)
        Me.lblSKU.Name = "lblSKU"
        Me.lblSKU.Size = New System.Drawing.Size(29, 15)
        Me.lblSKU.TabIndex = 1
        Me.lblSKU.Text = "SKU"
        '
        ' txtSKU
        '
        Me.txtSKU.Location = New System.Drawing.Point(96, 61)
        Me.txtSKU.Name = "txtSKU"
        Me.txtSKU.Size = New System.Drawing.Size(200, 23)
        Me.txtSKU.TabIndex = 2
        '
        ' lblQty
        '
        Me.lblQty.AutoSize = True
        Me.lblQty.Location = New System.Drawing.Point(24, 96)
        Me.lblQty.Name = "lblQty"
        Me.lblQty.Size = New System.Drawing.Size(28, 15)
        Me.lblQty.TabIndex = 3
        Me.lblQty.Text = "Qty"
        '
        ' numQty
        '
        Me.numQty.DecimalPlaces = 0
        Me.numQty.Location = New System.Drawing.Point(96, 93)
        Me.numQty.Maximum = New Decimal(New Integer() {1000000, 0, 0, 0})
        Me.numQty.Name = "numQty"
        Me.numQty.Size = New System.Drawing.Size(120, 23)
        Me.numQty.TabIndex = 4
        '
        ' lblUnitCost
        '
        Me.lblUnitCost.AutoSize = True
        Me.lblUnitCost.Location = New System.Drawing.Point(232, 96)
        Me.lblUnitCost.Name = "lblUnitCost"
        Me.lblUnitCost.Size = New System.Drawing.Size(61, 15)
        Me.lblUnitCost.TabIndex = 5
        Me.lblUnitCost.Text = "Unit Cost"
        '
        ' numUnitCost
        '
        Me.numUnitCost.DecimalPlaces = 2
        Me.numUnitCost.Location = New System.Drawing.Point(304, 93)
        Me.numUnitCost.Maximum = New Decimal(New Integer() {10000000, 0, 0, 0})
        Me.numUnitCost.Name = "numUnitCost"
        Me.numUnitCost.Size = New System.Drawing.Size(120, 23)
        Me.numUnitCost.TabIndex = 6
        '
        ' lblSupplier
        '
        Me.lblSupplier.AutoSize = True
        Me.lblSupplier.Location = New System.Drawing.Point(24, 132)
        Me.lblSupplier.Name = "lblSupplier"
        Me.lblSupplier.Size = New System.Drawing.Size(53, 15)
        Me.lblSupplier.TabIndex = 7
        Me.lblSupplier.Text = "Supplier"
        '
        ' txtSupplier
        '
        Me.txtSupplier.Location = New System.Drawing.Point(96, 129)
        Me.txtSupplier.Name = "txtSupplier"
        Me.txtSupplier.Size = New System.Drawing.Size(328, 23)
        Me.txtSupplier.TabIndex = 8
        '
        ' lblSupplierInv
        '
        Me.lblSupplierInv.AutoSize = True
        Me.lblSupplierInv.Location = New System.Drawing.Point(24, 164)
        Me.lblSupplierInv.Name = "lblSupplierInv"
        Me.lblSupplierInv.Size = New System.Drawing.Size(66, 15)
        Me.lblSupplierInv.TabIndex = 9
        Me.lblSupplierInv.Text = "Supp. Inv#"
        '
        ' txtSupplierInv
        '
        Me.txtSupplierInv.Location = New System.Drawing.Point(96, 161)
        Me.txtSupplierInv.Name = "txtSupplierInv"
        Me.txtSupplierInv.Size = New System.Drawing.Size(200, 23)
        Me.txtSupplierInv.TabIndex = 10
        '
        ' lblBatch
        '
        Me.lblBatch.AutoSize = True
        Me.lblBatch.Location = New System.Drawing.Point(24, 196)
        Me.lblBatch.Name = "lblBatch"
        Me.lblBatch.Size = New System.Drawing.Size(38, 15)
        Me.lblBatch.TabIndex = 11
        Me.lblBatch.Text = "Batch"
        '
        ' txtBatch
        '
        Me.txtBatch.Location = New System.Drawing.Point(96, 193)
        Me.txtBatch.Name = "txtBatch"
        Me.txtBatch.Size = New System.Drawing.Size(200, 23)
        Me.txtBatch.TabIndex = 12
        '
        ' lblExpiry
        '
        Me.lblExpiry.AutoSize = True
        Me.lblExpiry.Location = New System.Drawing.Point(312, 196)
        Me.lblExpiry.Name = "lblExpiry"
        Me.lblExpiry.Size = New System.Drawing.Size(41, 15)
        Me.lblExpiry.TabIndex = 13
        Me.lblExpiry.Text = "Expiry"
        '
        ' dtpExpiry
        '
        Me.dtpExpiry.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpExpiry.Location = New System.Drawing.Point(360, 193)
        Me.dtpExpiry.Name = "dtpExpiry"
        Me.dtpExpiry.Size = New System.Drawing.Size(120, 23)
        Me.dtpExpiry.TabIndex = 14
        '
        ' lblNotes
        '
        Me.lblNotes.AutoSize = True
        Me.lblNotes.Location = New System.Drawing.Point(24, 232)
        Me.lblNotes.Name = "lblNotes"
        Me.lblNotes.Size = New System.Drawing.Size(38, 15)
        Me.lblNotes.TabIndex = 15
        Me.lblNotes.Text = "Notes"
        '
        ' txtNotes
        '
        Me.txtNotes.Location = New System.Drawing.Point(96, 229)
        Me.txtNotes.Multiline = True
        Me.txtNotes.Name = "txtNotes"
        Me.txtNotes.Size = New System.Drawing.Size(384, 72)
        Me.txtNotes.TabIndex = 16
        '
        ' lblBranch
        '
        Me.lblBranch.AutoSize = True
        Me.lblBranch.Location = New System.Drawing.Point(24, 320)
        Me.lblBranch.Name = "lblBranch"
        Me.lblBranch.Size = New System.Drawing.Size(47, 15)
        Me.lblBranch.TabIndex = 17
        Me.lblBranch.Text = "Branch"
        '
        ' cboBranch
        '
        Me.cboBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBranch.FormattingEnabled = True
        Me.cboBranch.Location = New System.Drawing.Point(96, 317)
        Me.cboBranch.Name = "cboBranch"
        Me.cboBranch.Size = New System.Drawing.Size(200, 23)
        Me.cboBranch.TabIndex = 18
        '
        ' btnReceive
        '
        Me.btnReceive.Location = New System.Drawing.Point(96, 360)
        Me.btnReceive.Name = "btnReceive"
        Me.btnReceive.Size = New System.Drawing.Size(160, 30)
        Me.btnReceive.TabIndex = 19
        Me.btnReceive.Text = "Receive to Retail"
        Me.btnReceive.UseVisualStyleBackColor = True
        '
        ' POReceivingForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(520, 410)
        Me.Controls.Add(Me.btnReceive)
        Me.Controls.Add(Me.cboBranch)
        Me.Controls.Add(Me.lblBranch)
        Me.Controls.Add(Me.txtNotes)
        Me.Controls.Add(Me.lblNotes)
        Me.Controls.Add(Me.dtpExpiry)
        Me.Controls.Add(Me.lblExpiry)
        Me.Controls.Add(Me.txtBatch)
        Me.Controls.Add(Me.lblBatch)
        Me.Controls.Add(Me.txtSupplierInv)
        Me.Controls.Add(Me.lblSupplierInv)
        Me.Controls.Add(Me.txtSupplier)
        Me.Controls.Add(Me.lblSupplier)
        Me.Controls.Add(Me.numUnitCost)
        Me.Controls.Add(Me.lblUnitCost)
        Me.Controls.Add(Me.numQty)
        Me.Controls.Add(Me.lblQty)
        Me.Controls.Add(Me.txtSKU)
        Me.Controls.Add(Me.lblSKU)
        Me.Controls.Add(Me.lblTitle)
        Me.Name = "POReceivingForm"
        Me.Text = "PO → Retail Receiving"
        CType(Me.numQty, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.numUnitCost, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents lblTitle As Label
    Friend WithEvents lblSKU As Label
    Friend WithEvents txtSKU As TextBox
    Friend WithEvents lblQty As Label
    Friend WithEvents numQty As NumericUpDown
    Friend WithEvents lblUnitCost As Label
    Friend WithEvents numUnitCost As NumericUpDown
    Friend WithEvents lblSupplier As Label
    Friend WithEvents txtSupplier As TextBox
    Friend WithEvents lblSupplierInv As Label
    Friend WithEvents txtSupplierInv As TextBox
    Friend WithEvents lblBatch As Label
    Friend WithEvents txtBatch As TextBox
    Friend WithEvents lblExpiry As Label
    Friend WithEvents dtpExpiry As DateTimePicker
    Friend WithEvents lblNotes As Label
    Friend WithEvents txtNotes As TextBox
    Friend WithEvents lblBranch As Label
    Friend WithEvents cboBranch As ComboBox
    Friend WithEvents btnReceive As Button
End Class
