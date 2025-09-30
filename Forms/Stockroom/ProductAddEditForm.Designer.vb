<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ProductAddEditForm
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
        Me.txtProductCode = New System.Windows.Forms.TextBox()
        Me.txtProductName = New System.Windows.Forms.TextBox()
        Me.txtDescription = New System.Windows.Forms.TextBox()
        Me.cboCategory = New System.Windows.Forms.ComboBox()
        Me.txtUnitPrice = New System.Windows.Forms.TextBox()
        Me.txtStockQuantity = New System.Windows.Forms.TextBox()
        Me.txtReorderPoint = New System.Windows.Forms.TextBox()
        Me.chkIsActive = New System.Windows.Forms.CheckBox()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.lblProductCode = New System.Windows.Forms.Label()
        Me.lblProductName = New System.Windows.Forms.Label()
        Me.lblDescription = New System.Windows.Forms.Label()
        Me.lblCategory = New System.Windows.Forms.Label()
        Me.lblUnitPrice = New System.Windows.Forms.Label()
        Me.lblStockQuantity = New System.Windows.Forms.Label()
        Me.lblReorderPoint = New System.Windows.Forms.Label()
        Me.pnlMain = New System.Windows.Forms.Panel()
        Me.pnlButtons = New System.Windows.Forms.Panel()
        Me.pnlMain.SuspendLayout()
        Me.pnlButtons.SuspendLayout()
        Me.SuspendLayout()
        '
        'txtProductCode
        '
        Me.txtProductCode.Location = New System.Drawing.Point(120, 20)
        Me.txtProductCode.Name = "txtProductCode"
        Me.txtProductCode.Size = New System.Drawing.Size(200, 20)
        Me.txtProductCode.TabIndex = 0
        '
        'txtProductName
        '
        Me.txtProductName.Location = New System.Drawing.Point(120, 50)
        Me.txtProductName.Name = "txtProductName"
        Me.txtProductName.Size = New System.Drawing.Size(300, 20)
        Me.txtProductName.TabIndex = 1
        '
        'txtDescription
        '
        Me.txtDescription.Location = New System.Drawing.Point(120, 80)
        Me.txtDescription.Multiline = True
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtDescription.Size = New System.Drawing.Size(300, 60)
        Me.txtDescription.TabIndex = 2
        '
        'cboCategory
        '
        Me.cboCategory.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboCategory.FormattingEnabled = True
        Me.cboCategory.Location = New System.Drawing.Point(120, 150)
        Me.cboCategory.Name = "cboCategory"
        Me.cboCategory.Size = New System.Drawing.Size(200, 21)
        Me.cboCategory.TabIndex = 3
        '
        'txtUnitPrice
        '
        Me.txtUnitPrice.Location = New System.Drawing.Point(120, 180)
        Me.txtUnitPrice.Name = "txtUnitPrice"
        Me.txtUnitPrice.Size = New System.Drawing.Size(100, 20)
        Me.txtUnitPrice.TabIndex = 4
        Me.txtUnitPrice.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'txtStockQuantity
        '
        Me.txtStockQuantity.Location = New System.Drawing.Point(120, 210)
        Me.txtStockQuantity.Name = "txtStockQuantity"
        Me.txtStockQuantity.Size = New System.Drawing.Size(100, 20)
        Me.txtStockQuantity.TabIndex = 5
        Me.txtStockQuantity.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'txtReorderPoint
        '
        Me.txtReorderPoint.Location = New System.Drawing.Point(120, 240)
        Me.txtReorderPoint.Name = "txtReorderPoint"
        Me.txtReorderPoint.Size = New System.Drawing.Size(100, 20)
        Me.txtReorderPoint.TabIndex = 6
        Me.txtReorderPoint.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'chkIsActive
        '
        Me.chkIsActive.AutoSize = True
        Me.chkIsActive.Checked = True
        Me.chkIsActive.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkIsActive.Location = New System.Drawing.Point(120, 270)
        Me.chkIsActive.Name = "chkIsActive"
        Me.chkIsActive.Size = New System.Drawing.Size(67, 17)
        Me.chkIsActive.TabIndex = 7
        Me.chkIsActive.Text = "Is Active"
        Me.chkIsActive.UseVisualStyleBackColor = True
        '
        'btnSave
        '
        Me.btnSave.Location = New System.Drawing.Point(264, 10)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(75, 23)
        Me.btnSave.TabIndex = 8
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(345, 10)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 9
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'lblProductCode
        '
        Me.lblProductCode.AutoSize = True
        Me.lblProductCode.Location = New System.Drawing.Point(20, 23)
        Me.lblProductCode.Name = "lblProductCode"
        Me.lblProductCode.Size = New System.Drawing.Size(75, 13)
        Me.lblProductCode.TabIndex = 10
        Me.lblProductCode.Text = "Product Code:"
        '
        'lblProductName
        '
        Me.lblProductName.AutoSize = True
        Me.lblProductName.Location = New System.Drawing.Point(20, 53)
        Me.lblProductName.Name = "lblProductName"
        Me.lblProductName.Size = New System.Drawing.Size(78, 13)
        Me.lblProductName.TabIndex = 11
        Me.lblProductName.Text = "Product Name:"
        '
        'lblDescription
        '
        Me.lblDescription.AutoSize = True
        Me.lblDescription.Location = New System.Drawing.Point(20, 83)
        Me.lblDescription.Name = "lblDescription"
        Me.lblDescription.Size = New System.Drawing.Size(63, 13)
        Me.lblDescription.TabIndex = 12
        Me.lblDescription.Text = "Description:"
        '
        'lblCategory
        '
        Me.lblCategory.AutoSize = True
        Me.lblCategory.Location = New System.Drawing.Point(20, 153)
        Me.lblCategory.Name = "lblCategory"
        Me.lblCategory.Size = New System.Drawing.Size(52, 13)
        Me.lblCategory.TabIndex = 13
        Me.lblCategory.Text = "Category:"
        '
        'lblUnitPrice
        '
        Me.lblUnitPrice.AutoSize = True
        Me.lblUnitPrice.Location = New System.Drawing.Point(20, 183)
        Me.lblUnitPrice.Name = "lblUnitPrice"
        Me.lblUnitPrice.Size = New System.Drawing.Size(56, 13)
        Me.lblUnitPrice.TabIndex = 14
        Me.lblUnitPrice.Text = "Unit Price:"
        '
        'lblStockQuantity
        '
        Me.lblStockQuantity.AutoSize = True
        Me.lblStockQuantity.Location = New System.Drawing.Point(20, 213)
        Me.lblStockQuantity.Name = "lblStockQuantity"
        Me.lblStockQuantity.Size = New System.Drawing.Size(81, 13)
        Me.lblStockQuantity.TabIndex = 15
        Me.lblStockQuantity.Text = "Stock Quantity:"
        '
        'lblReorderPoint
        '
        Me.lblReorderPoint.AutoSize = True
        Me.lblReorderPoint.Location = New System.Drawing.Point(20, 243)
        Me.lblReorderPoint.Name = "lblReorderPoint"
        Me.lblReorderPoint.Size = New System.Drawing.Size(75, 13)
        Me.lblReorderPoint.TabIndex = 16
        Me.lblReorderPoint.Text = "Reorder Point:"
        '
        'pnlMain
        '
        Me.pnlMain.Controls.Add(Me.lblProductCode)
        Me.pnlMain.Controls.Add(Me.lblReorderPoint)
        Me.pnlMain.Controls.Add(Me.txtProductCode)
        Me.pnlMain.Controls.Add(Me.lblStockQuantity)
        Me.pnlMain.Controls.Add(Me.txtProductName)
        Me.pnlMain.Controls.Add(Me.lblUnitPrice)
        Me.pnlMain.Controls.Add(Me.txtDescription)
        Me.pnlMain.Controls.Add(Me.lblCategory)
        Me.pnlMain.Controls.Add(Me.cboCategory)
        Me.pnlMain.Controls.Add(Me.lblDescription)
        Me.pnlMain.Controls.Add(Me.txtUnitPrice)
        Me.pnlMain.Controls.Add(Me.lblProductName)
        Me.pnlMain.Controls.Add(Me.txtStockQuantity)
        Me.pnlMain.Controls.Add(Me.txtReorderPoint)
        Me.pnlMain.Controls.Add(Me.chkIsActive)
        Me.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMain.Location = New System.Drawing.Point(0, 0)
        Me.pnlMain.Name = "pnlMain"
        Me.pnlMain.Size = New System.Drawing.Size(450, 307)
        Me.pnlMain.TabIndex = 17
        '
        'pnlButtons
        '
        Me.pnlButtons.Controls.Add(Me.btnSave)
        Me.pnlButtons.Controls.Add(Me.btnCancel)
        Me.pnlButtons.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlButtons.Location = New System.Drawing.Point(0, 307)
        Me.pnlButtons.Name = "pnlButtons"
        Me.pnlButtons.Size = New System.Drawing.Size(450, 43)
        Me.pnlButtons.TabIndex = 18
        '
        'ProductAddEditForm
        '
        Me.AcceptButton = Me.btnSave
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(450, 350)
        Me.Controls.Add(Me.pnlMain)
        Me.Controls.Add(Me.pnlButtons)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.Name = "ProductAddEditForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Product Details"
        Me.pnlMain.ResumeLayout(False)
        Me.pnlMain.PerformLayout()
        Me.pnlButtons.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents txtProductCode As TextBox
    Friend WithEvents txtProductName As TextBox
    Friend WithEvents txtDescription As TextBox
    Friend WithEvents cboCategory As ComboBox
    Friend WithEvents txtUnitPrice As TextBox
    Friend WithEvents txtStockQuantity As TextBox
    Friend WithEvents txtReorderPoint As TextBox
    Friend WithEvents chkIsActive As CheckBox
    Friend WithEvents btnSave As Button
    Friend WithEvents btnCancel As Button
    Friend WithEvents lblProductCode As Label
    Friend WithEvents lblProductName As Label
    Friend WithEvents lblDescription As Label
    Friend WithEvents lblCategory As Label
    Friend WithEvents lblUnitPrice As Label
    Friend WithEvents lblStockQuantity As Label
    Friend WithEvents lblReorderPoint As Label
    Friend WithEvents pnlMain As Panel
    Friend WithEvents pnlButtons As Panel

End Class
