<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class ProductUpsertForm
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
        Me.lblCategory = New System.Windows.Forms.Label()
        Me.txtCategory = New System.Windows.Forms.TextBox()
        Me.lblDescription = New System.Windows.Forms.Label()
        Me.txtDescription = New System.Windows.Forms.TextBox()
        Me.lblReorder = New System.Windows.Forms.Label()
        Me.numReorder = New System.Windows.Forms.NumericUpDown()
        Me.lblBranch = New System.Windows.Forms.Label()
        Me.cboBranch = New System.Windows.Forms.ComboBox()
        Me.lblPrimaryImage = New System.Windows.Forms.Label()
        Me.txtPrimaryImage = New System.Windows.Forms.TextBox()
        Me.btnSave = New System.Windows.Forms.Button()
        CType(Me.numReorder, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        ' lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.lblTitle.Location = New System.Drawing.Point(24, 18)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(228, 25)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Product (Add / Update)"
        '
        ' lblSKU
        '
        Me.lblSKU.AutoSize = True
        Me.lblSKU.Location = New System.Drawing.Point(24, 68)
        Me.lblSKU.Name = "lblSKU"
        Me.lblSKU.Size = New System.Drawing.Size(29, 15)
        Me.lblSKU.TabIndex = 1
        Me.lblSKU.Text = "SKU"
        '
        ' txtSKU
        '
        Me.txtSKU.Location = New System.Drawing.Point(140, 65)
        Me.txtSKU.Name = "txtSKU"
        Me.txtSKU.Size = New System.Drawing.Size(240, 23)
        Me.txtSKU.TabIndex = 2
        '
        ' lblName
        '
        Me.lblName.AutoSize = True
        Me.lblName.Location = New System.Drawing.Point(24, 100)
        Me.lblName.Name = "lblName"
        Me.lblName.Size = New System.Drawing.Size(42, 15)
        Me.lblName.TabIndex = 3
        Me.lblName.Text = "Name"
        '
        ' txtName
        '
        Me.txtName.Location = New System.Drawing.Point(140, 97)
        Me.txtName.Name = "txtName"
        Me.txtName.Size = New System.Drawing.Size(360, 23)
        Me.txtName.TabIndex = 4
        '
        ' lblCategory
        '
        Me.lblCategory.AutoSize = True
        Me.lblCategory.Location = New System.Drawing.Point(24, 132)
        Me.lblCategory.Name = "lblCategory"
        Me.lblCategory.Size = New System.Drawing.Size(58, 15)
        Me.lblCategory.TabIndex = 5
        Me.lblCategory.Text = "Category"
        '
        ' txtCategory
        '
        Me.txtCategory.Location = New System.Drawing.Point(140, 129)
        Me.txtCategory.Name = "txtCategory"
        Me.txtCategory.Size = New System.Drawing.Size(240, 23)
        Me.txtCategory.TabIndex = 6
        '
        ' lblDescription
        '
        Me.lblDescription.AutoSize = True
        Me.lblDescription.Location = New System.Drawing.Point(24, 164)
        Me.lblDescription.Name = "lblDescription"
        Me.lblDescription.Size = New System.Drawing.Size(69, 15)
        Me.lblDescription.TabIndex = 7
        Me.lblDescription.Text = "Description"
        '
        ' txtDescription
        '
        Me.txtDescription.Location = New System.Drawing.Point(140, 161)
        Me.txtDescription.Multiline = True
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtDescription.Size = New System.Drawing.Size(480, 100)
        Me.txtDescription.TabIndex = 8
        '
        ' lblReorder
        '
        Me.lblReorder.AutoSize = True
        Me.lblReorder.Location = New System.Drawing.Point(24, 274)
        Me.lblReorder.Name = "lblReorder"
        Me.lblReorder.Size = New System.Drawing.Size(85, 15)
        Me.lblReorder.TabIndex = 9
        Me.lblReorder.Text = "Reorder Point"
        '
        ' numReorder
        '
        Me.numReorder.DecimalPlaces = 0
        Me.numReorder.Location = New System.Drawing.Point(140, 270)
        Me.numReorder.Maximum = New Decimal(New Integer() {100000, 0, 0, 0})
        Me.numReorder.Name = "numReorder"
        Me.numReorder.Size = New System.Drawing.Size(120, 23)
        Me.numReorder.TabIndex = 10
        '
        ' lblBranch
        '
        Me.lblBranch.AutoSize = True
        Me.lblBranch.Location = New System.Drawing.Point(24, 308)
        Me.lblBranch.Name = "lblBranch"
        Me.lblBranch.Size = New System.Drawing.Size(47, 15)
        Me.lblBranch.TabIndex = 11
        Me.lblBranch.Text = "Branch"
        '
        ' cboBranch
        '
        Me.cboBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboBranch.FormattingEnabled = True
        Me.cboBranch.Location = New System.Drawing.Point(140, 305)
        Me.cboBranch.Name = "cboBranch"
        Me.cboBranch.Size = New System.Drawing.Size(240, 23)
        Me.cboBranch.TabIndex = 12
        '
        ' lblPrimaryImage
        '
        Me.lblPrimaryImage.AutoSize = True
        Me.lblPrimaryImage.Location = New System.Drawing.Point(24, 344)
        Me.lblPrimaryImage.Name = "lblPrimaryImage"
        Me.lblPrimaryImage.Size = New System.Drawing.Size(89, 15)
        Me.lblPrimaryImage.TabIndex = 13
        Me.lblPrimaryImage.Text = "Primary Image"
        '
        ' txtPrimaryImage
        '
        Me.txtPrimaryImage.Location = New System.Drawing.Point(140, 341)
        Me.txtPrimaryImage.Name = "txtPrimaryImage"
        Me.txtPrimaryImage.PlaceholderText = "https://..."
        Me.txtPrimaryImage.Size = New System.Drawing.Size(480, 23)
        Me.txtPrimaryImage.TabIndex = 14
        '
        ' btnSave
        '
        Me.btnSave.Location = New System.Drawing.Point(140, 384)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(140, 32)
        Me.btnSave.TabIndex = 15
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = True
        '
        ' ProductUpsertForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(900, 500)
        Me.Controls.Add(Me.btnSave)
        Me.Controls.Add(Me.txtPrimaryImage)
        Me.Controls.Add(Me.lblPrimaryImage)
        Me.Controls.Add(Me.cboBranch)
        Me.Controls.Add(Me.lblBranch)
        Me.Controls.Add(Me.numReorder)
        Me.Controls.Add(Me.lblReorder)
        Me.Controls.Add(Me.txtDescription)
        Me.Controls.Add(Me.lblDescription)
        Me.Controls.Add(Me.txtCategory)
        Me.Controls.Add(Me.lblCategory)
        Me.Controls.Add(Me.txtName)
        Me.Controls.Add(Me.lblName)
        Me.Controls.Add(Me.txtSKU)
        Me.Controls.Add(Me.lblSKU)
        Me.Controls.Add(Me.lblTitle)
        Me.Name = "ProductUpsertForm"
        Me.Text = "Product Upsert"
        CType(Me.numReorder, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents lblTitle As Label
    Friend WithEvents lblSKU As Label
    Friend WithEvents txtSKU As TextBox
    Friend WithEvents lblName As Label
    Friend WithEvents txtName As TextBox
    Friend WithEvents lblCategory As Label
    Friend WithEvents txtCategory As TextBox
    Friend WithEvents lblDescription As Label
    Friend WithEvents txtDescription As TextBox
    Friend WithEvents lblReorder As Label
    Friend WithEvents numReorder As NumericUpDown
    Friend WithEvents lblBranch As Label
    Friend WithEvents cboBranch As ComboBox
    Friend WithEvents lblPrimaryImage As Label
    Friend WithEvents txtPrimaryImage As TextBox
    Friend WithEvents btnSave As Button
End Class
