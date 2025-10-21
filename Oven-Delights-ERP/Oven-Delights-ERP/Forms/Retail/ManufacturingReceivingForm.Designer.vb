<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class ManufacturingReceivingForm
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
        Me.lblName = New System.Windows.Forms.Label()
        Me.txtName = New System.Windows.Forms.TextBox()
        Me.lblBranch = New System.Windows.Forms.Label()
        Me.cboBranch = New System.Windows.Forms.ComboBox()
        Me.lblQty = New System.Windows.Forms.Label()
        Me.numQty = New System.Windows.Forms.NumericUpDown()
        Me.btnReceive = New System.Windows.Forms.Button()
        CType(Me.numQty, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        ' lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.lblTitle.Location = New System.Drawing.Point(24, 18)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(307, 25)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Receive Finished Goods (MFG → Retail)"
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
        Me.txtSKU.Size = New System.Drawing.Size(220, 23)
        Me.txtSKU.TabIndex = 2
        '
        ' lblName
        '
        Me.lblName.AutoSize = True
        Me.lblName.Location = New System.Drawing.Point(24, 96)
        Me.lblName.Name = "lblName"
        Me.lblName.Size = New System.Drawing.Size(42, 15)
        Me.lblName.TabIndex = 3
        Me.lblName.Text = "Name"
        '
        ' txtName
        '
        Me.txtName.Location = New System.Drawing.Point(80, 93)
        Me.txtName.Name = "txtName"
        Me.txtName.Size = New System.Drawing.Size(360, 23)
        Me.txtName.TabIndex = 4
        '
        ' lblBranch
        '
        Me.lblBranch.AutoSize = True
        Me.lblBranch.Location = New System.Drawing.Point(24, 130)
        Me.lblBranch.Name = "lblBranch"
        Me.lblBranch.Size = New System.Drawing.Size(47, 15)
        Me.lblBranch.TabIndex = 5
        Me.lblBranch.Text = "Branch"
        '
        ' cboBranch
        '
        Me.cboBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBranch.FormattingEnabled = True
        Me.cboBranch.Location = New System.Drawing.Point(80, 127)
        Me.cboBranch.Name = "cboBranch"
        Me.cboBranch.Size = New System.Drawing.Size(220, 23)
        Me.cboBranch.TabIndex = 6
        '
        ' lblQty
        '
        Me.lblQty.AutoSize = True
        Me.lblQty.Location = New System.Drawing.Point(24, 164)
        Me.lblQty.Name = "lblQty"
        Me.lblQty.Size = New System.Drawing.Size(28, 15)
        Me.lblQty.TabIndex = 7
        Me.lblQty.Text = "Qty"
        '
        ' numQty
        '
        Me.numQty.DecimalPlaces = 0
        Me.numQty.Location = New System.Drawing.Point(80, 160)
        Me.numQty.Maximum = New Decimal(New Integer() {1000000, 0, 0, 0})
        Me.numQty.Name = "numQty"
        Me.numQty.Size = New System.Drawing.Size(120, 23)
        Me.numQty.TabIndex = 8
        '
        ' btnReceive
        '
        Me.btnReceive.Location = New System.Drawing.Point(80, 200)
        Me.btnReceive.Name = "btnReceive"
        Me.btnReceive.Size = New System.Drawing.Size(160, 30)
        Me.btnReceive.TabIndex = 9
        Me.btnReceive.Text = "Receive to Retail"
        Me.btnReceive.UseVisualStyleBackColor = True
        '
        ' ManufacturingReceivingForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(640, 280)
        Me.Controls.Add(Me.btnReceive)
        Me.Controls.Add(Me.numQty)
        Me.Controls.Add(Me.lblQty)
        Me.Controls.Add(Me.cboBranch)
        Me.Controls.Add(Me.lblBranch)
        Me.Controls.Add(Me.txtName)
        Me.Controls.Add(Me.lblName)
        Me.Controls.Add(Me.txtSKU)
        Me.Controls.Add(Me.lblSKU)
        Me.Controls.Add(Me.lblTitle)
        Me.Name = "ManufacturingReceivingForm"
        Me.Text = "MFG → Retail Receiving"
        CType(Me.numQty, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents lblTitle As Label
    Friend WithEvents lblSKU As Label
    Friend WithEvents txtSKU As TextBox
    Friend WithEvents lblName As Label
    Friend WithEvents txtName As TextBox
    Friend WithEvents lblBranch As Label
    Friend WithEvents cboBranch As ComboBox
    Friend WithEvents lblQty As Label
    Friend WithEvents numQty As NumericUpDown
    Friend WithEvents btnReceive As Button
End Class
