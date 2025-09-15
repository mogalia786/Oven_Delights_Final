<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class PriceManagementForm
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
        Me.btnLoad = New System.Windows.Forms.Button()
        Me.dgvHistory = New System.Windows.Forms.DataGridView()
        Me.lblBranch = New System.Windows.Forms.Label()
        Me.cboBranch = New System.Windows.Forms.ComboBox()
        Me.lblCurrency = New System.Windows.Forms.Label()
        Me.txtCurrency = New System.Windows.Forms.TextBox()
        Me.lblPrice = New System.Windows.Forms.Label()
        Me.numPrice = New System.Windows.Forms.NumericUpDown()
        Me.lblEffective = New System.Windows.Forms.Label()
        Me.dtpEffectiveFrom = New System.Windows.Forms.DateTimePicker()
        Me.btnSetPrice = New System.Windows.Forms.Button()
        CType(Me.dgvHistory, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.numPrice, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        ' lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.lblTitle.Location = New System.Drawing.Point(24, 18)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(187, 25)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Price Management"
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
        Me.txtSKU.Location = New System.Drawing.Point(80, 61)
        Me.txtSKU.Name = "txtSKU"
        Me.txtSKU.Size = New System.Drawing.Size(200, 23)
        Me.txtSKU.TabIndex = 2
        '
        ' btnLoad
        '
        Me.btnLoad.Location = New System.Drawing.Point(296, 60)
        Me.btnLoad.Name = "btnLoad"
        Me.btnLoad.Size = New System.Drawing.Size(90, 25)
        Me.btnLoad.TabIndex = 3
        Me.btnLoad.Text = "Load"
        Me.btnLoad.UseVisualStyleBackColor = True
        '
        ' dgvHistory
        '
        Me.dgvHistory.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvHistory.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvHistory.Location = New System.Drawing.Point(24, 104)
        Me.dgvHistory.Name = "dgvHistory"
        Me.dgvHistory.RowTemplate.Height = 25
        Me.dgvHistory.Size = New System.Drawing.Size(760, 360)
        Me.dgvHistory.TabIndex = 4
        '
        ' lblBranch
        '
        Me.lblBranch.AutoSize = True
        Me.lblBranch.Location = New System.Drawing.Point(408, 64)
        Me.lblBranch.Name = "lblBranch"
        Me.lblBranch.Size = New System.Drawing.Size(47, 15)
        Me.lblBranch.TabIndex = 5
        Me.lblBranch.Text = "Branch"
        '
        ' cboBranch
        '
        Me.cboBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBranch.FormattingEnabled = True
        Me.cboBranch.Location = New System.Drawing.Point(464, 61)
        Me.cboBranch.Name = "cboBranch"
        Me.cboBranch.Size = New System.Drawing.Size(180, 23)
        Me.cboBranch.TabIndex = 6
        '
        ' lblCurrency
        '
        Me.lblCurrency.AutoSize = True
        Me.lblCurrency.Location = New System.Drawing.Point(24, 484)
        Me.lblCurrency.Name = "lblCurrency"
        Me.lblCurrency.Size = New System.Drawing.Size(57, 15)
        Me.lblCurrency.TabIndex = 7
        Me.lblCurrency.Text = "Currency"
        '
        ' txtCurrency
        '
        Me.txtCurrency.Location = New System.Drawing.Point(96, 481)
        Me.txtCurrency.Name = "txtCurrency"
        Me.txtCurrency.Size = New System.Drawing.Size(80, 23)
        Me.txtCurrency.TabIndex = 8
        Me.txtCurrency.Text = "ZAR"
        '
        ' lblPrice
        '
        Me.lblPrice.AutoSize = True
        Me.lblPrice.Location = New System.Drawing.Point(192, 484)
        Me.lblPrice.Name = "lblPrice"
        Me.lblPrice.Size = New System.Drawing.Size(34, 15)
        Me.lblPrice.TabIndex = 9
        Me.lblPrice.Text = "Price"
        '
        ' numPrice
        '
        Me.numPrice.DecimalPlaces = 2
        Me.numPrice.Location = New System.Drawing.Point(240, 481)
        Me.numPrice.Maximum = New Decimal(New Integer() {10000000, 0, 0, 0})
        Me.numPrice.Name = "numPrice"
        Me.numPrice.Size = New System.Drawing.Size(120, 23)
        Me.numPrice.TabIndex = 10
        '
        ' lblEffective
        '
        Me.lblEffective.AutoSize = True
        Me.lblEffective.Location = New System.Drawing.Point(376, 484)
        Me.lblEffective.Name = "lblEffective"
        Me.lblEffective.Size = New System.Drawing.Size(82, 15)
        Me.lblEffective.TabIndex = 11
        Me.lblEffective.Text = "Effective From"
        '
        ' dtpEffectiveFrom
        '
        Me.dtpEffectiveFrom.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.dtpEffectiveFrom.Location = New System.Drawing.Point(472, 481)
        Me.dtpEffectiveFrom.Name = "dtpEffectiveFrom"
        Me.dtpEffectiveFrom.Size = New System.Drawing.Size(120, 23)
        Me.dtpEffectiveFrom.TabIndex = 12
        '
        ' btnSetPrice
        '
        Me.btnSetPrice.Location = New System.Drawing.Point(608, 480)
        Me.btnSetPrice.Name = "btnSetPrice"
        Me.btnSetPrice.Size = New System.Drawing.Size(120, 25)
        Me.btnSetPrice.TabIndex = 13
        Me.btnSetPrice.Text = "Set Price"
        Me.btnSetPrice.UseVisualStyleBackColor = True
        '
        ' PriceManagementForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(808, 521)
        Me.Controls.Add(Me.btnSetPrice)
        Me.Controls.Add(Me.dtpEffectiveFrom)
        Me.Controls.Add(Me.lblEffective)
        Me.Controls.Add(Me.numPrice)
        Me.Controls.Add(Me.lblPrice)
        Me.Controls.Add(Me.txtCurrency)
        Me.Controls.Add(Me.lblCurrency)
        Me.Controls.Add(Me.cboBranch)
        Me.Controls.Add(Me.lblBranch)
        Me.Controls.Add(Me.dgvHistory)
        Me.Controls.Add(Me.btnLoad)
        Me.Controls.Add(Me.txtSKU)
        Me.Controls.Add(Me.lblSKU)
        Me.Controls.Add(Me.lblTitle)
        Me.Name = "PriceManagementForm"
        Me.Text = "Price Management"
        CType(Me.dgvHistory, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.numPrice, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents lblTitle As Label
    Friend WithEvents lblSKU As Label
    Friend WithEvents txtSKU As TextBox
    Friend WithEvents btnLoad As Button
    Friend WithEvents dgvHistory As DataGridView
    Friend WithEvents lblBranch As Label
    Friend WithEvents cboBranch As ComboBox
    Friend WithEvents lblCurrency As Label
    Friend WithEvents txtCurrency As TextBox
    Friend WithEvents lblPrice As Label
    Friend WithEvents numPrice As NumericUpDown
    Friend WithEvents lblEffective As Label
    Friend WithEvents dtpEffectiveFrom As DateTimePicker
    Friend WithEvents btnSetPrice As Button
End Class
