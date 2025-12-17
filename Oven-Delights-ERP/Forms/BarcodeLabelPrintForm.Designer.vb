<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class BarcodeLabelPrintForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()>
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
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.lblPrice = New System.Windows.Forms.Label()
        Me.lblBarcode = New System.Windows.Forms.Label()
        Me.lblProductName = New System.Windows.Forms.Label()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.cboProduct = New System.Windows.Forms.ComboBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.GroupBox2 = New System.Windows.Forms.GroupBox()
        Me.cboPrinter = New System.Windows.Forms.ComboBox()
        Me.Label10 = New System.Windows.Forms.Label()
        Me.nudStartPosition = New System.Windows.Forms.NumericUpDown()
        Me.Label9 = New System.Windows.Forms.Label()
        Me.nudQuantity = New System.Windows.Forms.NumericUpDown()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.txtFreeText = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.GroupBox3 = New System.Windows.Forms.GroupBox()
        Me.nudVerticalGap = New System.Windows.Forms.NumericUpDown()
        Me.Label12 = New System.Windows.Forms.Label()
        Me.nudHorizontalGap = New System.Windows.Forms.NumericUpDown()
        Me.Label11 = New System.Windows.Forms.Label()
        Me.nudLabelHeight = New System.Windows.Forms.NumericUpDown()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.nudLabelWidth = New System.Windows.Forms.NumericUpDown()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.GroupBox4 = New System.Windows.Forms.GroupBox()
        Me.picPreview = New System.Windows.Forms.PictureBox()
        Me.btnPrint = New System.Windows.Forms.Button()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        CType(Me.nudStartPosition, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nudQuantity, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox3.SuspendLayout()
        CType(Me.nudLabelHeight, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nudLabelWidth, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox4.SuspendLayout()
        CType(Me.picPreview, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.lblPrice)
        Me.GroupBox1.Controls.Add(Me.lblBarcode)
        Me.GroupBox1.Controls.Add(Me.lblProductName)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Controls.Add(Me.cboProduct)
        Me.GroupBox1.Controls.Add(Me.Label4)
        Me.GroupBox1.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point)
        Me.GroupBox1.Location = New System.Drawing.Point(12, 12)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(400, 180)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Product Selection"
        '
        'lblPrice
        '
        Me.lblPrice.AutoSize = True
        Me.lblPrice.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.lblPrice.Location = New System.Drawing.Point(120, 145)
        Me.lblPrice.Name = "lblPrice"
        Me.lblPrice.Size = New System.Drawing.Size(45, 19)
        Me.lblPrice.TabIndex = 7
        Me.lblPrice.Text = "R 0.00"
        '
        'lblBarcode
        '
        Me.lblBarcode.AutoSize = True
        Me.lblBarcode.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point)
        Me.lblBarcode.Location = New System.Drawing.Point(120, 115)
        Me.lblBarcode.Name = "lblBarcode"
        Me.lblBarcode.Size = New System.Drawing.Size(12, 15)
        Me.lblBarcode.TabIndex = 6
        Me.lblBarcode.Text = "-"
        '
        'lblProductName
        '
        Me.lblProductName.AutoSize = True
        Me.lblProductName.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point)
        Me.lblProductName.Location = New System.Drawing.Point(120, 85)
        Me.lblProductName.Name = "lblProductName"
        Me.lblProductName.Size = New System.Drawing.Size(12, 15)
        Me.lblProductName.TabIndex = 5
        Me.lblProductName.Text = "-"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(20, 145)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(36, 15)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "Price:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(20, 115)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(53, 15)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "Barcode:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(20, 85)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(87, 15)
        Me.Label1.TabIndex = 2
        Me.Label1.Text = "Product Name:"
        '
        'cboProduct
        '
        Me.cboProduct.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboProduct.FormattingEnabled = True
        Me.cboProduct.Location = New System.Drawing.Point(20, 45)
        Me.cboProduct.Name = "cboProduct"
        Me.cboProduct.Size = New System.Drawing.Size(360, 23)
        Me.cboProduct.TabIndex = 1
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(20, 25)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(87, 15)
        Me.Label4.TabIndex = 0
        Me.Label4.Text = "Select Product:"
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.cboPrinter)
        Me.GroupBox2.Controls.Add(Me.Label10)
        Me.GroupBox2.Controls.Add(Me.nudStartPosition)
        Me.GroupBox2.Controls.Add(Me.Label9)
        Me.GroupBox2.Controls.Add(Me.nudQuantity)
        Me.GroupBox2.Controls.Add(Me.Label5)
        Me.GroupBox2.Controls.Add(Me.txtFreeText)
        Me.GroupBox2.Controls.Add(Me.Label6)
        Me.GroupBox2.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point)
        Me.GroupBox2.Location = New System.Drawing.Point(12, 198)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(400, 160)
        Me.GroupBox2.TabIndex = 1
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Print Settings"
        '
        'nudStartPosition
        '
        Me.nudStartPosition.Location = New System.Drawing.Point(150, 90)
        Me.nudStartPosition.Maximum = New Decimal(New Integer() {100, 0, 0, 0})
        Me.nudStartPosition.Minimum = New Decimal(New Integer() {1, 0, 0, 0})
        Me.nudStartPosition.Name = "nudStartPosition"
        Me.nudStartPosition.Size = New System.Drawing.Size(100, 23)
        Me.nudStartPosition.TabIndex = 5
        Me.nudStartPosition.Value = New Decimal(New Integer() {1, 0, 0, 0})
        '
        'cboPrinter
        '
        Me.cboPrinter.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboPrinter.FormattingEnabled = True
        Me.cboPrinter.Location = New System.Drawing.Point(150, 120)
        Me.cboPrinter.Name = "cboPrinter"
        Me.cboPrinter.Size = New System.Drawing.Size(230, 23)
        Me.cboPrinter.TabIndex = 7
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(20, 123)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(47, 15)
        Me.Label10.TabIndex = 6
        Me.Label10.Text = "Printer:"
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(20, 92)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(124, 15)
        Me.Label9.TabIndex = 4
        Me.Label9.Text = "Start Position (Label #):"
        '
        'nudQuantity
        '
        Me.nudQuantity.Location = New System.Drawing.Point(150, 60)
        Me.nudQuantity.Maximum = New Decimal(New Integer() {1000, 0, 0, 0})
        Me.nudQuantity.Minimum = New Decimal(New Integer() {1, 0, 0, 0})
        Me.nudQuantity.Name = "nudQuantity"
        Me.nudQuantity.Size = New System.Drawing.Size(100, 23)
        Me.nudQuantity.TabIndex = 3
        Me.nudQuantity.Value = New Decimal(New Integer() {1, 0, 0, 0})
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(20, 62)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(56, 15)
        Me.Label5.TabIndex = 2
        Me.Label5.Text = "Quantity:"
        '
        'txtFreeText
        '
        Me.txtFreeText.Location = New System.Drawing.Point(150, 25)
        Me.txtFreeText.MaxLength = 10
        Me.txtFreeText.Name = "txtFreeText"
        Me.txtFreeText.Size = New System.Drawing.Size(230, 23)
        Me.txtFreeText.TabIndex = 1
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(20, 28)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(92, 15)
        Me.Label6.TabIndex = 0
        Me.Label6.Text = "Free Text (e.g. B1):"
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.nudVerticalGap)
        Me.GroupBox3.Controls.Add(Me.Label12)
        Me.GroupBox3.Controls.Add(Me.nudHorizontalGap)
        Me.GroupBox3.Controls.Add(Me.Label11)
        Me.GroupBox3.Controls.Add(Me.nudLabelHeight)
        Me.GroupBox3.Controls.Add(Me.Label8)
        Me.GroupBox3.Controls.Add(Me.nudLabelWidth)
        Me.GroupBox3.Controls.Add(Me.Label7)
        Me.GroupBox3.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point)
        Me.GroupBox3.Location = New System.Drawing.Point(12, 364)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(400, 120)
        Me.GroupBox3.TabIndex = 2
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Label Dimensions & Spacing (mm)"
        '
        'nudLabelHeight
        '
        Me.nudLabelHeight.Location = New System.Drawing.Point(150, 55)
        Me.nudLabelHeight.Maximum = New Decimal(New Integer() {200, 0, 0, 0})
        Me.nudLabelHeight.Minimum = New Decimal(New Integer() {10, 0, 0, 0})
        Me.nudLabelHeight.Name = "nudLabelHeight"
        Me.nudLabelHeight.Size = New System.Drawing.Size(100, 23)
        Me.nudLabelHeight.TabIndex = 3
        Me.nudLabelHeight.Value = New Decimal(New Integer() {30, 0, 0, 0})
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(20, 57)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(76, 15)
        Me.Label8.TabIndex = 2
        Me.Label8.Text = "Label Height:"
        '
        'nudLabelWidth
        '
        Me.nudLabelWidth.Location = New System.Drawing.Point(150, 25)
        Me.nudLabelWidth.Maximum = New Decimal(New Integer() {200, 0, 0, 0})
        Me.nudLabelWidth.Minimum = New Decimal(New Integer() {10, 0, 0, 0})
        Me.nudLabelWidth.Name = "nudLabelWidth"
        Me.nudLabelWidth.Size = New System.Drawing.Size(100, 23)
        Me.nudLabelWidth.TabIndex = 1
        Me.nudLabelWidth.Value = New Decimal(New Integer() {50, 0, 0, 0})
        '
        'nudHorizontalGap
        '
        Me.nudHorizontalGap.DecimalPlaces = 1
        Me.nudHorizontalGap.Location = New System.Drawing.Point(280, 25)
        Me.nudHorizontalGap.Maximum = New Decimal(New Integer() {10, 0, 0, 0})
        Me.nudHorizontalGap.Name = "nudHorizontalGap"
        Me.nudHorizontalGap.Size = New System.Drawing.Size(100, 23)
        Me.nudHorizontalGap.TabIndex = 7
        Me.nudHorizontalGap.Value = New Decimal(New Integer() {2, 0, 0, 0})
        '
        'Label11
        '
        Me.Label11.AutoSize = True
        Me.Label11.Location = New System.Drawing.Point(280, 7)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(96, 15)
        Me.Label11.TabIndex = 6
        Me.Label11.Text = "Horizontal Gap:"
        '
        'nudVerticalGap
        '
        Me.nudVerticalGap.DecimalPlaces = 1
        Me.nudVerticalGap.Location = New System.Drawing.Point(280, 70)
        Me.nudVerticalGap.Maximum = New Decimal(New Integer() {10, 0, 0, 0})
        Me.nudVerticalGap.Name = "nudVerticalGap"
        Me.nudVerticalGap.Size = New System.Drawing.Size(100, 23)
        Me.nudVerticalGap.TabIndex = 9
        Me.nudVerticalGap.Value = New Decimal(New Integer() {2, 0, 0, 0})
        '
        'Label12
        '
        Me.Label12.AutoSize = True
        Me.Label12.Location = New System.Drawing.Point(280, 52)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(78, 15)
        Me.Label12.TabIndex = 8
        Me.Label12.Text = "Vertical Gap:"
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(20, 27)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(72, 15)
        Me.Label7.TabIndex = 0
        Me.Label7.Text = "Label Width:"
        '
        'GroupBox4
        '
        Me.GroupBox4.Controls.Add(Me.picPreview)
        Me.GroupBox4.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point)
        Me.GroupBox4.Location = New System.Drawing.Point(418, 12)
        Me.GroupBox4.Name = "GroupBox4"
        Me.GroupBox4.Size = New System.Drawing.Size(370, 510)
        Me.GroupBox4.TabIndex = 3
        Me.GroupBox4.TabStop = False
        Me.GroupBox4.Text = "Label Preview"
        '
        'picPreview
        '
        Me.picPreview.BackColor = System.Drawing.Color.White
        Me.picPreview.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.picPreview.Location = New System.Drawing.Point(15, 25)
        Me.picPreview.Name = "picPreview"
        Me.picPreview.Size = New System.Drawing.Size(340, 475)
        Me.picPreview.TabIndex = 0
        Me.picPreview.TabStop = False
        '
        'btnPrint
        '
        Me.btnPrint.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.btnPrint.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnPrint.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.btnPrint.ForeColor = System.Drawing.Color.White
        Me.btnPrint.Location = New System.Drawing.Point(12, 490)
        Me.btnPrint.Name = "btnPrint"
        Me.btnPrint.Size = New System.Drawing.Size(195, 40)
        Me.btnPrint.TabIndex = 4
        Me.btnPrint.Text = "Print Labels"
        Me.btnPrint.UseVisualStyleBackColor = False
        '
        'btnClose
        '
        Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(220, Byte), Integer), CType(CType(53, Byte), Integer), CType(CType(69, Byte), Integer))
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point)
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(217, 490)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(195, 40)
        Me.btnClose.TabIndex = 5
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = False
        '
        'BarcodeLabelPrintForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(800, 560)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.btnPrint)
        Me.Controls.Add(Me.GroupBox4)
        Me.Controls.Add(Me.GroupBox3)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.GroupBox1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "BarcodeLabelPrintForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Print Barcode Labels"
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        CType(Me.nudStartPosition, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nudQuantity, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox3.PerformLayout()
        CType(Me.nudLabelHeight, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nudLabelWidth, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nudHorizontalGap, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nudVerticalGap, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox4.ResumeLayout(False)
        CType(Me.picPreview, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents GroupBox1 As GroupBox
    Friend WithEvents cboProduct As ComboBox
    Friend WithEvents Label4 As Label
    Friend WithEvents lblPrice As Label
    Friend WithEvents lblBarcode As Label
    Friend WithEvents lblProductName As Label
    Friend WithEvents Label3 As Label
    Friend WithEvents Label2 As Label
    Friend WithEvents Label1 As Label
    Friend WithEvents GroupBox2 As GroupBox
    Friend WithEvents nudQuantity As NumericUpDown
    Friend WithEvents Label5 As Label
    Friend WithEvents txtFreeText As TextBox
    Friend WithEvents Label6 As Label
    Friend WithEvents GroupBox3 As GroupBox
    Friend WithEvents nudLabelHeight As NumericUpDown
    Friend WithEvents Label8 As Label
    Friend WithEvents nudLabelWidth As NumericUpDown
    Friend WithEvents Label7 As Label
    Friend WithEvents GroupBox4 As GroupBox
    Friend WithEvents picPreview As PictureBox
    Friend WithEvents btnPrint As Button
    Friend WithEvents btnClose As Button
    Friend WithEvents nudStartPosition As NumericUpDown
    Friend WithEvents Label9 As Label
    Friend WithEvents cboPrinter As ComboBox
    Friend WithEvents Label10 As Label
    Friend WithEvents nudHorizontalGap As NumericUpDown
    Friend WithEvents Label11 As Label
    Friend WithEvents nudVerticalGap As NumericUpDown
    Friend WithEvents Label12 As Label
End Class
