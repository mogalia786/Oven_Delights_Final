<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class StockOverviewForm
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
        Me.lblBranch = New System.Windows.Forms.Label()
        Me.cboBranch = New System.Windows.Forms.ComboBox()
        Me.lblSKU = New System.Windows.Forms.Label()
        Me.txtSKU = New System.Windows.Forms.TextBox()
        Me.btnLoad = New System.Windows.Forms.Button()
        Me.dgvStock = New System.Windows.Forms.DataGridView()
        Me.grpAdjust = New System.Windows.Forms.GroupBox()
        Me.lblQty = New System.Windows.Forms.Label()
        Me.numQty = New System.Windows.Forms.NumericUpDown()
        Me.lblReason = New System.Windows.Forms.Label()
        Me.txtReason = New System.Windows.Forms.TextBox()
        Me.btnAdjust = New System.Windows.Forms.Button()
        CType(Me.dgvStock, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.grpAdjust.SuspendLayout()
        CType(Me.numQty, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        ' lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.lblTitle.Location = New System.Drawing.Point(24, 18)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(142, 25)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Stock Overview"
        '
        ' lblBranch
        '
        Me.lblBranch.AutoSize = True
        Me.lblBranch.Location = New System.Drawing.Point(24, 64)
        Me.lblBranch.Name = "lblBranch"
        Me.lblBranch.Size = New System.Drawing.Size(47, 15)
        Me.lblBranch.TabIndex = 1
        Me.lblBranch.Text = "Branch"
        '
        ' cboBranch
        '
        Me.cboBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBranch.FormattingEnabled = True
        Me.cboBranch.Location = New System.Drawing.Point(80, 61)
        Me.cboBranch.Name = "cboBranch"
        Me.cboBranch.Size = New System.Drawing.Size(200, 23)
        Me.cboBranch.TabIndex = 2
        '
        ' lblSKU
        '
        Me.lblSKU.AutoSize = True
        Me.lblSKU.Location = New System.Drawing.Point(296, 64)
        Me.lblSKU.Name = "lblSKU"
        Me.lblSKU.Size = New System.Drawing.Size(29, 15)
        Me.lblSKU.TabIndex = 3
        Me.lblSKU.Text = "SKU"
        '
        ' txtSKU
        '
        Me.txtSKU.Location = New System.Drawing.Point(336, 61)
        Me.txtSKU.Name = "txtSKU"
        Me.txtSKU.Size = New System.Drawing.Size(180, 23)
        Me.txtSKU.TabIndex = 4
        '
        ' btnLoad
        '
        Me.btnLoad.Location = New System.Drawing.Point(528, 60)
        Me.btnLoad.Name = "btnLoad"
        Me.btnLoad.Size = New System.Drawing.Size(90, 25)
        Me.btnLoad.TabIndex = 5
        Me.btnLoad.Text = "Load"
        Me.btnLoad.UseVisualStyleBackColor = True
        '
        ' dgvStock
        '
        Me.dgvStock.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvStock.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvStock.Location = New System.Drawing.Point(24, 104)
        Me.dgvStock.Name = "dgvStock"
        Me.dgvStock.RowTemplate.Height = 25
        Me.dgvStock.Size = New System.Drawing.Size(920, 420)
        Me.dgvStock.TabIndex = 6
        '
        ' grpAdjust
        '
        Me.grpAdjust.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.grpAdjust.Controls.Add(Me.btnAdjust)
        Me.grpAdjust.Controls.Add(Me.txtReason)
        Me.grpAdjust.Controls.Add(Me.lblReason)
        Me.grpAdjust.Controls.Add(Me.numQty)
        Me.grpAdjust.Controls.Add(Me.lblQty)
        Me.grpAdjust.Location = New System.Drawing.Point(24, 540)
        Me.grpAdjust.Name = "grpAdjust"
        Me.grpAdjust.Size = New System.Drawing.Size(600, 88)
        Me.grpAdjust.TabIndex = 7
        Me.grpAdjust.TabStop = False
        Me.grpAdjust.Text = "Adjustment"
        '
        ' lblQty
        '
        Me.lblQty.AutoSize = True
        Me.lblQty.Location = New System.Drawing.Point(16, 36)
        Me.lblQty.Name = "lblQty"
        Me.lblQty.Size = New System.Drawing.Size(28, 15)
        Me.lblQty.TabIndex = 0
        Me.lblQty.Text = "Qty"
        '
        ' numQty
        '
        Me.numQty.DecimalPlaces = 0
        Me.numQty.Location = New System.Drawing.Point(56, 32)
        Me.numQty.Maximum = New Decimal(New Integer() {1000000, 0, 0, 0})
        Me.numQty.Minimum = New Decimal(New Integer() {1000000, 0, 0, -2147483648})
        Me.numQty.Name = "numQty"
        Me.numQty.Size = New System.Drawing.Size(100, 23)
        Me.numQty.TabIndex = 1
        '
        ' lblReason
        '
        Me.lblReason.AutoSize = True
        Me.lblReason.Location = New System.Drawing.Point(176, 36)
        Me.lblReason.Name = "lblReason"
        Me.lblReason.Size = New System.Drawing.Size(45, 15)
        Me.lblReason.TabIndex = 2
        Me.lblReason.Text = "Reason"
        '
        ' txtReason
        '
        Me.txtReason.Location = New System.Drawing.Point(232, 32)
        Me.txtReason.Name = "txtReason"
        Me.txtReason.Size = New System.Drawing.Size(232, 23)
        Me.txtReason.TabIndex = 3
        '
        ' btnAdjust
        '
        Me.btnAdjust.Location = New System.Drawing.Point(480, 31)
        Me.btnAdjust.Name = "btnAdjust"
        Me.btnAdjust.Size = New System.Drawing.Size(96, 25)
        Me.btnAdjust.TabIndex = 4
        Me.btnAdjust.Text = "Apply"
        Me.btnAdjust.UseVisualStyleBackColor = True
        '
        ' StockOverviewForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(968, 641)
        Me.Controls.Add(Me.grpAdjust)
        Me.Controls.Add(Me.dgvStock)
        Me.Controls.Add(Me.btnLoad)
        Me.Controls.Add(Me.txtSKU)
        Me.Controls.Add(Me.lblSKU)
        Me.Controls.Add(Me.cboBranch)
        Me.Controls.Add(Me.lblBranch)
        Me.Controls.Add(Me.lblTitle)
        Me.Name = "StockOverviewForm"
        Me.Text = "Stock Overview"
        CType(Me.dgvStock, System.ComponentModel.ISupportInitialize).EndInit()
        Me.grpAdjust.ResumeLayout(False)
        Me.grpAdjust.PerformLayout()
        CType(Me.numQty, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents lblTitle As Label
    Friend WithEvents lblBranch As Label
    Friend WithEvents cboBranch As ComboBox
    Friend WithEvents lblSKU As Label
    Friend WithEvents txtSKU As TextBox
    Friend WithEvents btnLoad As Button
    Friend WithEvents dgvStock As DataGridView
    Friend WithEvents grpAdjust As GroupBox
    Friend WithEvents lblQty As Label
    Friend WithEvents numQty As NumericUpDown
    Friend WithEvents lblReason As Label
    Friend WithEvents txtReason As TextBox
    Friend WithEvents btnAdjust As Button
End Class
