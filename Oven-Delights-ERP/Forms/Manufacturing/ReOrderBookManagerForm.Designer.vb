Namespace Manufacturing
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class ReOrderBookManagerForm
        Inherits System.Windows.Forms.Form

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

    Private components As System.ComponentModel.IContainer

    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.lblDraftCount = New System.Windows.Forms.Label()
        Me.dgvDraftBooks = New System.Windows.Forms.DataGridView()
        Me.GroupBox2 = New System.Windows.Forms.GroupBox()
        Me.btnPost = New System.Windows.Forms.Button()
        Me.grpProducts = New System.Windows.Forms.GroupBox()
        Me.btnAddProduct = New System.Windows.Forms.Button()
        Me.nudQuantity = New System.Windows.Forms.NumericUpDown()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.cmbProduct = New System.Windows.Forms.ComboBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.dgvProductLines = New System.Windows.Forms.DataGridView()
        Me.lblTotalQuantity = New System.Windows.Forms.Label()
        Me.lblTotalProducts = New System.Windows.Forms.Label()
        Me.lblBakerName = New System.Windows.Forms.Label()
        Me.txtReOrderNumber = New System.Windows.Forms.TextBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.GroupBox3 = New System.Windows.Forms.GroupBox()
        Me.btnNewReOrder = New System.Windows.Forms.Button()
        Me.txtNotes = New System.Windows.Forms.TextBox()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.chkUrgent = New System.Windows.Forms.CheckBox()
        Me.dtpRequiredDate = New System.Windows.Forms.DateTimePicker()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.dtpOrderDate = New System.Windows.Forms.DateTimePicker()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.cmbBaker = New System.Windows.Forms.ComboBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Panel1.SuspendLayout()
        CType(Me.SplitContainer1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        CType(Me.dgvDraftBooks, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox2.SuspendLayout()
        Me.grpProducts.SuspendLayout()
        CType(Me.nudQuantity, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dgvProductLines, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox3.SuspendLayout()
        Me.SuspendLayout()
        
        ' Panel1
        Me.Panel1.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.Panel1.Controls.Add(Me.btnClose)
        Me.Panel1.Controls.Add(Me.Label1)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(1400, 60)
        Me.Panel1.TabIndex = 0
        
        ' Label1
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Segoe UI", 18.0!, System.Drawing.FontStyle.Bold)
        Me.Label1.ForeColor = System.Drawing.Color.White
        Me.Label1.Location = New System.Drawing.Point(12, 12)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(350, 32)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "📋 Order Book Schedule Manager"
        
        ' btnClose
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(1300, 15)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(80, 30)
        Me.btnClose.TabIndex = 1
        Me.btnClose.Text = "Close"
        
        ' SplitContainer1
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.Location = New System.Drawing.Point(0, 60)
        Me.SplitContainer1.Name = "SplitContainer1"
        Me.SplitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal
        Me.SplitContainer1.Panel1.Controls.Add(Me.GroupBox1)
        Me.SplitContainer1.Panel2.Controls.Add(Me.GroupBox2)
        Me.SplitContainer1.Panel2.Controls.Add(Me.GroupBox3)
        Me.SplitContainer1.Size = New System.Drawing.Size(1400, 740)
        Me.SplitContainer1.SplitterDistance = 250
        Me.SplitContainer1.TabIndex = 1
        
        ' GroupBox1
        Me.GroupBox1.Controls.Add(Me.dgvDraftBooks)
        Me.GroupBox1.Controls.Add(Me.lblDraftCount)
        Me.GroupBox1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.GroupBox1.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.GroupBox1.Location = New System.Drawing.Point(0, 0)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Padding = New System.Windows.Forms.Padding(10)
        Me.GroupBox1.Size = New System.Drawing.Size(1400, 250)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Draft Re-Order Books"
        
        ' lblDraftCount
        Me.lblDraftCount.AutoSize = True
        Me.lblDraftCount.Dock = System.Windows.Forms.DockStyle.Top
        Me.lblDraftCount.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.lblDraftCount.Location = New System.Drawing.Point(10, 26)
        Me.lblDraftCount.Name = "lblDraftCount"
        Me.lblDraftCount.Padding = New System.Windows.Forms.Padding(0, 0, 0, 5)
        Me.lblDraftCount.Size = New System.Drawing.Size(120, 20)
        Me.lblDraftCount.TabIndex = 0
        Me.lblDraftCount.Text = "Draft Re-Orders: 0"
        
        ' dgvDraftBooks
        Me.dgvDraftBooks.AllowUserToAddRows = False
        Me.dgvDraftBooks.AllowUserToDeleteRows = False
        Me.dgvDraftBooks.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvDraftBooks.BackgroundColor = System.Drawing.Color.White
        Me.dgvDraftBooks.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvDraftBooks.Location = New System.Drawing.Point(10, 50)
        Me.dgvDraftBooks.Name = "dgvDraftBooks"
        Me.dgvDraftBooks.ReadOnly = True
        Me.dgvDraftBooks.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvDraftBooks.Size = New System.Drawing.Size(1380, 190)
        Me.dgvDraftBooks.TabIndex = 1
        
        ' GroupBox3
        Me.GroupBox3.Controls.Add(Me.Label2)
        Me.GroupBox3.Controls.Add(Me.cmbBaker)
        Me.GroupBox3.Controls.Add(Me.Label3)
        Me.GroupBox3.Controls.Add(Me.dtpOrderDate)
        Me.GroupBox3.Controls.Add(Me.Label4)
        Me.GroupBox3.Controls.Add(Me.dtpRequiredDate)
        Me.GroupBox3.Controls.Add(Me.chkUrgent)
        Me.GroupBox3.Controls.Add(Me.Label8)
        Me.GroupBox3.Controls.Add(Me.txtNotes)
        Me.GroupBox3.Controls.Add(Me.btnNewReOrder)
        Me.GroupBox3.Dock = System.Windows.Forms.DockStyle.Top
        Me.GroupBox3.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.GroupBox3.Location = New System.Drawing.Point(0, 0)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Padding = New System.Windows.Forms.Padding(10)
        Me.GroupBox3.Size = New System.Drawing.Size(1400, 150)
        Me.GroupBox3.TabIndex = 0
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Create New Order Book"
        
        ' Label2
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.Label2.Location = New System.Drawing.Point(15, 30)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(40, 15)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "Baker:"
        
        ' cmbBaker
        Me.cmbBaker.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbBaker.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.cmbBaker.FormattingEnabled = True
        Me.cmbBaker.Location = New System.Drawing.Point(15, 50)
        Me.cmbBaker.Name = "cmbBaker"
        Me.cmbBaker.Size = New System.Drawing.Size(250, 23)
        Me.cmbBaker.TabIndex = 1
        
        ' Label3
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.Label3.Location = New System.Drawing.Point(280, 30)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(70, 15)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "Order Date:"
        
        ' dtpOrderDate
        Me.dtpOrderDate.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.dtpOrderDate.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpOrderDate.Location = New System.Drawing.Point(280, 50)
        Me.dtpOrderDate.Name = "dtpOrderDate"
        Me.dtpOrderDate.Size = New System.Drawing.Size(120, 23)
        Me.dtpOrderDate.TabIndex = 3
        
        ' Label4
        Me.Label4.AutoSize = True
        Me.Label4.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.Label4.Location = New System.Drawing.Point(420, 30)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(88, 15)
        Me.Label4.TabIndex = 4
        Me.Label4.Text = "Required Date:"
        
        ' dtpRequiredDate
        Me.dtpRequiredDate.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.dtpRequiredDate.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpRequiredDate.Location = New System.Drawing.Point(420, 50)
        Me.dtpRequiredDate.Name = "dtpRequiredDate"
        Me.dtpRequiredDate.Size = New System.Drawing.Size(120, 23)
        Me.dtpRequiredDate.TabIndex = 5
        
        ' chkUrgent
        Me.chkUrgent.AutoSize = True
        Me.chkUrgent.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.chkUrgent.Location = New System.Drawing.Point(560, 52)
        Me.chkUrgent.Name = "chkUrgent"
        Me.chkUrgent.Size = New System.Drawing.Size(65, 19)
        Me.chkUrgent.TabIndex = 6
        Me.chkUrgent.Text = "Urgent"
        
        ' Label8
        Me.Label8.AutoSize = True
        Me.Label8.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.Label8.Location = New System.Drawing.Point(15, 85)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(41, 15)
        Me.Label8.TabIndex = 7
        Me.Label8.Text = "Notes:"
        
        ' txtNotes
        Me.txtNotes.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.txtNotes.Location = New System.Drawing.Point(15, 105)
        Me.txtNotes.Name = "txtNotes"
        Me.txtNotes.Size = New System.Drawing.Size(525, 23)
        Me.txtNotes.TabIndex = 8
        
        ' btnNewReOrder
        Me.btnNewReOrder.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.btnNewReOrder.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnNewReOrder.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnNewReOrder.ForeColor = System.Drawing.Color.White
        Me.btnNewReOrder.Location = New System.Drawing.Point(560, 95)
        Me.btnNewReOrder.Name = "btnNewReOrder"
        Me.btnNewReOrder.Size = New System.Drawing.Size(150, 35)
        Me.btnNewReOrder.TabIndex = 9
        Me.btnNewReOrder.Text = "Create Order"
        Me.btnNewReOrder.UseVisualStyleBackColor = False
        
        ' GroupBox2
        Me.GroupBox2.Controls.Add(Me.Label5)
        Me.GroupBox2.Controls.Add(Me.txtReOrderNumber)
        Me.GroupBox2.Controls.Add(Me.lblBakerName)
        Me.GroupBox2.Controls.Add(Me.lblTotalProducts)
        Me.GroupBox2.Controls.Add(Me.lblTotalQuantity)
        Me.GroupBox2.Controls.Add(Me.dgvProductLines)
        Me.GroupBox2.Controls.Add(Me.grpProducts)
        Me.GroupBox2.Controls.Add(Me.btnPost)
        Me.GroupBox2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.GroupBox2.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.GroupBox2.Location = New System.Drawing.Point(0, 150)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Padding = New System.Windows.Forms.Padding(10)
        Me.GroupBox2.Size = New System.Drawing.Size(1400, 336)
        Me.GroupBox2.TabIndex = 1
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Re-Order Book Details"
        
        ' Label5
        Me.Label5.AutoSize = True
        Me.Label5.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.Label5.Location = New System.Drawing.Point(15, 30)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(82, 15)
        Me.Label5.TabIndex = 0
        Me.Label5.Text = "Re-Order #:"
        
        ' txtReOrderNumber
        Me.txtReOrderNumber.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.txtReOrderNumber.Location = New System.Drawing.Point(100, 27)
        Me.txtReOrderNumber.Name = "txtReOrderNumber"
        Me.txtReOrderNumber.ReadOnly = True
        Me.txtReOrderNumber.Size = New System.Drawing.Size(200, 23)
        Me.txtReOrderNumber.TabIndex = 1
        
        ' lblBakerName
        Me.lblBakerName.AutoSize = True
        Me.lblBakerName.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.lblBakerName.Location = New System.Drawing.Point(320, 30)
        Me.lblBakerName.Name = "lblBakerName"
        Me.lblBakerName.Size = New System.Drawing.Size(60, 15)
        Me.lblBakerName.TabIndex = 2
        Me.lblBakerName.Text = "Baker: -"
        
        ' lblTotalProducts
        Me.lblTotalProducts.AutoSize = True
        Me.lblTotalProducts.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.lblTotalProducts.Location = New System.Drawing.Point(500, 30)
        Me.lblTotalProducts.Name = "lblTotalProducts"
        Me.lblTotalProducts.Size = New System.Drawing.Size(70, 15)
        Me.lblTotalProducts.TabIndex = 3
        Me.lblTotalProducts.Text = "Products: 0"
        
        ' lblTotalQuantity
        Me.lblTotalQuantity.AutoSize = True
        Me.lblTotalQuantity.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.lblTotalQuantity.Location = New System.Drawing.Point(620, 30)
        Me.lblTotalQuantity.Name = "lblTotalQuantity"
        Me.lblTotalQuantity.Size = New System.Drawing.Size(70, 15)
        Me.lblTotalQuantity.TabIndex = 4
        Me.lblTotalQuantity.Text = "Total Qty: 0"
        
        ' dgvProductLines
        Me.dgvProductLines.AllowUserToAddRows = False
        Me.dgvProductLines.AllowUserToDeleteRows = False
        Me.dgvProductLines.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvProductLines.BackgroundColor = System.Drawing.Color.White
        Me.dgvProductLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvProductLines.Location = New System.Drawing.Point(15, 60)
        Me.dgvProductLines.Name = "dgvProductLines"
        Me.dgvProductLines.ReadOnly = True
        Me.dgvProductLines.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvProductLines.Size = New System.Drawing.Size(900, 180)
        Me.dgvProductLines.TabIndex = 5
        
        ' grpProducts
        Me.grpProducts.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grpProducts.Controls.Add(Me.Label6)
        Me.grpProducts.Controls.Add(Me.cmbProduct)
        Me.grpProducts.Controls.Add(Me.Label7)
        Me.grpProducts.Controls.Add(Me.nudQuantity)
        Me.grpProducts.Controls.Add(Me.btnAddProduct)
        Me.grpProducts.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.grpProducts.Location = New System.Drawing.Point(930, 60)
        Me.grpProducts.Name = "grpProducts"
        Me.grpProducts.Size = New System.Drawing.Size(460, 180)
        Me.grpProducts.TabIndex = 6
        Me.grpProducts.TabStop = False
        Me.grpProducts.Text = "Add Products"
        
        ' Label6
        Me.Label6.AutoSize = True
        Me.Label6.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.Label6.Location = New System.Drawing.Point(15, 25)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(52, 15)
        Me.Label6.TabIndex = 0
        Me.Label6.Text = "Product:"
        
        ' cmbProduct
        Me.cmbProduct.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbProduct.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.cmbProduct.FormattingEnabled = True
        Me.cmbProduct.Location = New System.Drawing.Point(15, 45)
        Me.cmbProduct.Name = "cmbProduct"
        Me.cmbProduct.Size = New System.Drawing.Size(430, 23)
        Me.cmbProduct.TabIndex = 1
        
        ' Label7
        Me.Label7.AutoSize = True
        Me.Label7.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.Label7.Location = New System.Drawing.Point(15, 80)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(56, 15)
        Me.Label7.TabIndex = 2
        Me.Label7.Text = "Quantity:"
        
        ' nudQuantity
        Me.nudQuantity.Font = New System.Drawing.Font("Segoe UI", 16.0!)
        Me.nudQuantity.Location = New System.Drawing.Point(15, 100)
        Me.nudQuantity.Maximum = New Decimal(New Integer() {10000, 0, 0, 0})
        Me.nudQuantity.Minimum = New Decimal(New Integer() {1, 0, 0, 0})
        Me.nudQuantity.Name = "nudQuantity"
        Me.nudQuantity.Size = New System.Drawing.Size(120, 40)
        Me.nudQuantity.TabIndex = 3
        Me.nudQuantity.Value = New Decimal(New Integer() {1, 0, 0, 0})
        
        ' btnAddProduct
        Me.btnAddProduct.BackColor = System.Drawing.Color.FromArgb(CType(CType(40, Byte), Integer), CType(CType(167, Byte), Integer), CType(CType(69, Byte), Integer))
        Me.btnAddProduct.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnAddProduct.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnAddProduct.ForeColor = System.Drawing.Color.White
        Me.btnAddProduct.Location = New System.Drawing.Point(15, 135)
        Me.btnAddProduct.Name = "btnAddProduct"
        Me.btnAddProduct.Size = New System.Drawing.Size(120, 30)
        Me.btnAddProduct.TabIndex = 4
        Me.btnAddProduct.Text = "Add Product"
        Me.btnAddProduct.UseVisualStyleBackColor = False
        
        ' btnPost
        Me.btnPost.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnPost.BackColor = System.Drawing.Color.FromArgb(CType(CType(220, Byte), Integer), CType(CType(53, Byte), Integer), CType(CType(69, Byte), Integer))
        Me.btnPost.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnPost.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.btnPost.ForeColor = System.Drawing.Color.White
        Me.btnPost.Location = New System.Drawing.Point(1200, 260)
        Me.btnPost.Name = "btnPost"
        Me.btnPost.Size = New System.Drawing.Size(180, 50)
        Me.btnPost.TabIndex = 7
        Me.btnPost.Text = "📤 Post to Baker"
        Me.btnPost.UseVisualStyleBackColor = False
        
        ' ReOrderBookManagerForm
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1400, 800)
        Me.Controls.Add(Me.SplitContainer1)
        Me.Controls.Add(Me.Panel1)
        Me.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.Name = "ReOrderBookManagerForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Order Book Schedule Manager"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        CType(Me.SplitContainer1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SplitContainer1.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        CType(Me.dgvDraftBooks, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.grpProducts.ResumeLayout(False)
        Me.grpProducts.PerformLayout()
        CType(Me.nudQuantity, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.dgvProductLines, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox3.PerformLayout()
        Me.ResumeLayout(False)
    End Sub

    Friend WithEvents Panel1 As Panel
    Friend WithEvents Label1 As Label
    Friend WithEvents btnClose As Button
    Friend WithEvents SplitContainer1 As SplitContainer
    Friend WithEvents GroupBox1 As GroupBox
    Friend WithEvents dgvDraftBooks As DataGridView
    Friend WithEvents lblDraftCount As Label
    Friend WithEvents GroupBox2 As GroupBox
    Friend WithEvents GroupBox3 As GroupBox
    Friend WithEvents Label2 As Label
    Friend WithEvents cmbBaker As ComboBox
    Friend WithEvents Label3 As Label
    Friend WithEvents dtpOrderDate As DateTimePicker
    Friend WithEvents Label4 As Label
    Friend WithEvents dtpRequiredDate As DateTimePicker
    Friend WithEvents chkUrgent As CheckBox
    Friend WithEvents Label8 As Label
    Friend WithEvents txtNotes As TextBox
    Friend WithEvents btnNewReOrder As Button
    Friend WithEvents Label5 As Label
    Friend WithEvents txtReOrderNumber As TextBox
    Friend WithEvents lblBakerName As Label
    Friend WithEvents lblTotalProducts As Label
    Friend WithEvents lblTotalQuantity As Label
    Friend WithEvents dgvProductLines As DataGridView
    Friend WithEvents grpProducts As GroupBox
    Friend WithEvents Label6 As Label
    Friend WithEvents cmbProduct As ComboBox
    Friend WithEvents Label7 As Label
    Friend WithEvents nudQuantity As NumericUpDown
    Friend WithEvents btnAddProduct As Button
    Friend WithEvents btnPost As Button
    End Class
End Namespace
