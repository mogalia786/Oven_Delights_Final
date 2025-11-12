Namespace Manufacturing
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class BakerProductionViewForm
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
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.lblBakerName = New System.Windows.Forms.Label()
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.dgvReOrderBooks = New System.Windows.Forms.DataGridView()
        Me.Panel2 = New System.Windows.Forms.Panel()
        Me.lblOrderCount = New System.Windows.Forms.Label()
        Me.dtpDate = New System.Windows.Forms.DateTimePicker()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.GroupBox2 = New System.Windows.Forms.GroupBox()
        Me.dgvProductLines = New System.Windows.Forms.DataGridView()
        Me.Panel3 = New System.Windows.Forms.Panel()
        Me.btnPrint = New System.Windows.Forms.Button()
        Me.btnCompleteProduct = New System.Windows.Forms.Button()
        Me.btnStartProduction = New System.Windows.Forms.Button()
        Me.btnRequestBOM = New System.Windows.Forms.Button()
        Me.lblTotalQuantity = New System.Windows.Forms.Label()
        Me.lblTotalProducts = New System.Windows.Forms.Label()
        Me.lblStatus = New System.Windows.Forms.Label()
        Me.txtReOrderNumber = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.Panel1.SuspendLayout()
        CType(Me.SplitContainer1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        CType(Me.dgvReOrderBooks, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel2.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        CType(Me.dgvProductLines, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel3.SuspendLayout()
        Me.SuspendLayout()
        
        ' Panel1
        Me.Panel1.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.Panel1.Controls.Add(Me.btnRefresh)
        Me.Panel1.Controls.Add(Me.btnClose)
        Me.Panel1.Controls.Add(Me.lblBakerName)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(1400, 60)
        Me.Panel1.TabIndex = 0
        
        ' lblBakerName
        Me.lblBakerName.AutoSize = True
        Me.lblBakerName.Font = New System.Drawing.Font("Segoe UI", 18.0!, System.Drawing.FontStyle.Bold)
        Me.lblBakerName.ForeColor = System.Drawing.Color.White
        Me.lblBakerName.Location = New System.Drawing.Point(12, 12)
        Me.lblBakerName.Name = "lblBakerName"
        Me.lblBakerName.Size = New System.Drawing.Size(300, 32)
        Me.lblBakerName.TabIndex = 0
        Me.lblBakerName.Text = "👨‍🍳 Baker: -"
        
        ' btnRefresh
        Me.btnRefresh.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnRefresh.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnRefresh.ForeColor = System.Drawing.Color.White
        Me.btnRefresh.Location = New System.Drawing.Point(1200, 15)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(90, 30)
        Me.btnRefresh.TabIndex = 1
        Me.btnRefresh.Text = "🔄 Refresh"
        
        ' btnClose
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(1300, 15)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(80, 30)
        Me.btnClose.TabIndex = 2
        Me.btnClose.Text = "Close"
        
        ' SplitContainer1
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.Location = New System.Drawing.Point(0, 60)
        Me.SplitContainer1.Name = "SplitContainer1"
        Me.SplitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal
        Me.SplitContainer1.Panel1.Controls.Add(Me.GroupBox1)
        Me.SplitContainer1.Panel2.Controls.Add(Me.GroupBox2)
        Me.SplitContainer1.Size = New System.Drawing.Size(1400, 740)
        Me.SplitContainer1.SplitterDistance = 280
        Me.SplitContainer1.TabIndex = 1
        
        ' GroupBox1
        Me.GroupBox1.Controls.Add(Me.dgvReOrderBooks)
        Me.GroupBox1.Controls.Add(Me.Panel2)
        Me.GroupBox1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.GroupBox1.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.GroupBox1.Location = New System.Drawing.Point(0, 0)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Padding = New System.Windows.Forms.Padding(10)
        Me.GroupBox1.Size = New System.Drawing.Size(1400, 280)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "My Re-Order Books"
        
        ' Panel2
        Me.Panel2.Controls.Add(Me.Label2)
        Me.Panel2.Controls.Add(Me.dtpDate)
        Me.Panel2.Controls.Add(Me.lblOrderCount)
        Me.Panel2.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel2.Location = New System.Drawing.Point(10, 26)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(1380, 40)
        Me.Panel2.TabIndex = 0
        
        ' Label2
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.Label2.Location = New System.Drawing.Point(5, 10)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(35, 15)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "Date:"
        
        ' dtpDate
        Me.dtpDate.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.dtpDate.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpDate.Location = New System.Drawing.Point(45, 7)
        Me.dtpDate.Name = "dtpDate"
        Me.dtpDate.Size = New System.Drawing.Size(120, 23)
        Me.dtpDate.TabIndex = 1
        
        ' lblOrderCount
        Me.lblOrderCount.AutoSize = True
        Me.lblOrderCount.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.lblOrderCount.Location = New System.Drawing.Point(180, 10)
        Me.lblOrderCount.Name = "lblOrderCount"
        Me.lblOrderCount.Size = New System.Drawing.Size(60, 15)
        Me.lblOrderCount.TabIndex = 2
        Me.lblOrderCount.Text = "Orders: 0"
        
        ' dgvReOrderBooks
        Me.dgvReOrderBooks.AllowUserToAddRows = False
        Me.dgvReOrderBooks.AllowUserToDeleteRows = False
        Me.dgvReOrderBooks.AutoGenerateColumns = True
        Me.dgvReOrderBooks.BackgroundColor = System.Drawing.Color.White
        Me.dgvReOrderBooks.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvReOrderBooks.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvReOrderBooks.Location = New System.Drawing.Point(10, 66)
        Me.dgvReOrderBooks.Name = "dgvReOrderBooks"
        Me.dgvReOrderBooks.ReadOnly = True
        Me.dgvReOrderBooks.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvReOrderBooks.Size = New System.Drawing.Size(1380, 204)
        Me.dgvReOrderBooks.TabIndex = 1
        
        ' GroupBox2
        Me.GroupBox2.Controls.Add(Me.dgvProductLines)
        Me.GroupBox2.Controls.Add(Me.Panel3)
        Me.GroupBox2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.GroupBox2.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.GroupBox2.Location = New System.Drawing.Point(0, 0)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Padding = New System.Windows.Forms.Padding(10)
        Me.GroupBox2.Size = New System.Drawing.Size(1400, 456)
        Me.GroupBox2.TabIndex = 0
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Production Details"
        
        ' Panel3
        Me.Panel3.Controls.Add(Me.Label3)
        Me.Panel3.Controls.Add(Me.txtReOrderNumber)
        Me.Panel3.Controls.Add(Me.lblStatus)
        Me.Panel3.Controls.Add(Me.lblTotalProducts)
        Me.Panel3.Controls.Add(Me.lblTotalQuantity)
        Me.Panel3.Controls.Add(Me.btnRequestBOM)
        Me.Panel3.Controls.Add(Me.btnStartProduction)
        Me.Panel3.Controls.Add(Me.btnCompleteProduct)
        Me.Panel3.Controls.Add(Me.btnPrint)
        Me.Panel3.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel3.Location = New System.Drawing.Point(10, 26)
        Me.Panel3.Name = "Panel3"
        Me.Panel3.Size = New System.Drawing.Size(1380, 60)
        Me.Panel3.TabIndex = 0
        
        ' Label3
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.Label3.Location = New System.Drawing.Point(5, 10)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(70, 15)
        Me.Label3.TabIndex = 0
        Me.Label3.Text = "Re-Order #:"
        
        ' txtReOrderNumber
        Me.txtReOrderNumber.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.txtReOrderNumber.Location = New System.Drawing.Point(80, 7)
        Me.txtReOrderNumber.Name = "txtReOrderNumber"
        Me.txtReOrderNumber.ReadOnly = True
        Me.txtReOrderNumber.Size = New System.Drawing.Size(180, 23)
        Me.txtReOrderNumber.TabIndex = 1
        
        ' lblStatus
        Me.lblStatus.AutoSize = True
        Me.lblStatus.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.lblStatus.Location = New System.Drawing.Point(280, 10)
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(60, 15)
        Me.lblStatus.TabIndex = 2
        Me.lblStatus.Text = "Status: -"
        
        ' lblTotalProducts
        Me.lblTotalProducts.AutoSize = True
        Me.lblTotalProducts.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.lblTotalProducts.Location = New System.Drawing.Point(400, 10)
        Me.lblTotalProducts.Name = "lblTotalProducts"
        Me.lblTotalProducts.Size = New System.Drawing.Size(70, 15)
        Me.lblTotalProducts.TabIndex = 3
        Me.lblTotalProducts.Text = "Products: 0"
        
        ' lblTotalQuantity
        Me.lblTotalQuantity.AutoSize = True
        Me.lblTotalQuantity.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.lblTotalQuantity.Location = New System.Drawing.Point(520, 10)
        Me.lblTotalQuantity.Name = "lblTotalQuantity"
        Me.lblTotalQuantity.Size = New System.Drawing.Size(70, 15)
        Me.lblTotalQuantity.TabIndex = 4
        Me.lblTotalQuantity.Text = "Total Qty: 0"
        
        ' btnRequestBOM
        Me.btnRequestBOM.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnRequestBOM.BackColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(193, Byte), Integer), CType(CType(7, Byte), Integer))
        Me.btnRequestBOM.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnRequestBOM.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnRequestBOM.ForeColor = System.Drawing.Color.Black
        Me.btnRequestBOM.Location = New System.Drawing.Point(750, 15)
        Me.btnRequestBOM.Name = "btnRequestBOM"
        Me.btnRequestBOM.Size = New System.Drawing.Size(140, 35)
        Me.btnRequestBOM.TabIndex = 5
        Me.btnRequestBOM.Text = "📋 Request BOM"
        Me.btnRequestBOM.UseVisualStyleBackColor = False
        
        ' btnStartProduction
        Me.btnStartProduction.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnStartProduction.BackColor = System.Drawing.Color.FromArgb(CType(CType(40, Byte), Integer), CType(CType(167, Byte), Integer), CType(CType(69, Byte), Integer))
        Me.btnStartProduction.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnStartProduction.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnStartProduction.ForeColor = System.Drawing.Color.White
        Me.btnStartProduction.Location = New System.Drawing.Point(900, 15)
        Me.btnStartProduction.Name = "btnStartProduction"
        Me.btnStartProduction.Size = New System.Drawing.Size(140, 35)
        Me.btnStartProduction.TabIndex = 6
        Me.btnStartProduction.Text = "▶️ Start Production"
        Me.btnStartProduction.UseVisualStyleBackColor = False
        
        ' btnCompleteProduct
        Me.btnCompleteProduct.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCompleteProduct.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(122, Byte), Integer), CType(CType(204, Byte), Integer))
        Me.btnCompleteProduct.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnCompleteProduct.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnCompleteProduct.ForeColor = System.Drawing.Color.White
        Me.btnCompleteProduct.Location = New System.Drawing.Point(1050, 15)
        Me.btnCompleteProduct.Name = "btnCompleteProduct"
        Me.btnCompleteProduct.Size = New System.Drawing.Size(150, 35)
        Me.btnCompleteProduct.TabIndex = 6
        Me.btnCompleteProduct.Text = "✅ Complete Product"
        Me.btnCompleteProduct.UseVisualStyleBackColor = False
        
        ' btnPrint
        Me.btnPrint.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnPrint.BackColor = System.Drawing.Color.FromArgb(CType(CType(108, Byte), Integer), CType(CType(117, Byte), Integer), CType(CType(125, Byte), Integer))
        Me.btnPrint.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnPrint.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
        Me.btnPrint.ForeColor = System.Drawing.Color.White
        Me.btnPrint.Location = New System.Drawing.Point(1210, 15)
        Me.btnPrint.Name = "btnPrint"
        Me.btnPrint.Size = New System.Drawing.Size(160, 35)
        Me.btnPrint.TabIndex = 7
        Me.btnPrint.Text = "🖨️ Print Production Sheet"
        Me.btnPrint.UseVisualStyleBackColor = False
        
        ' dgvProductLines
        Me.dgvProductLines.AllowUserToAddRows = False
        Me.dgvProductLines.AllowUserToDeleteRows = False
        Me.dgvProductLines.AutoGenerateColumns = True
        Me.dgvProductLines.BackgroundColor = System.Drawing.Color.White
        Me.dgvProductLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvProductLines.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvProductLines.Location = New System.Drawing.Point(10, 86)
        Me.dgvProductLines.Name = "dgvProductLines"
        Me.dgvProductLines.ReadOnly = True
        Me.dgvProductLines.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvProductLines.Size = New System.Drawing.Size(1380, 360)
        Me.dgvProductLines.TabIndex = 1
        
        ' BakerProductionViewForm
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1400, 800)
        Me.Controls.Add(Me.SplitContainer1)
        Me.Controls.Add(Me.Panel1)
        Me.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.Name = "BakerProductionViewForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Baker Production View"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        CType(Me.SplitContainer1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SplitContainer1.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        CType(Me.dgvReOrderBooks, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel2.ResumeLayout(False)
        Me.Panel2.PerformLayout()
        Me.GroupBox2.ResumeLayout(False)
        CType(Me.dgvProductLines, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel3.ResumeLayout(False)
        Me.Panel3.PerformLayout()
        Me.ResumeLayout(False)
    End Sub

    Friend WithEvents Panel1 As Panel
    Friend WithEvents lblBakerName As Label
    Friend WithEvents btnRefresh As Button
    Friend WithEvents btnClose As Button
    Friend WithEvents SplitContainer1 As SplitContainer
    Friend WithEvents GroupBox1 As GroupBox
    Friend WithEvents dgvReOrderBooks As DataGridView
    Friend WithEvents Panel2 As Panel
    Friend WithEvents Label2 As Label
    Friend WithEvents dtpDate As DateTimePicker
    Friend WithEvents lblOrderCount As Label
    Friend WithEvents GroupBox2 As GroupBox
    Friend WithEvents dgvProductLines As DataGridView
    Friend WithEvents Panel3 As Panel
    Friend WithEvents Label3 As Label
    Friend WithEvents txtReOrderNumber As TextBox
    Friend WithEvents lblStatus As Label
    Friend WithEvents lblTotalProducts As Label
    Friend WithEvents lblTotalQuantity As Label
    Friend WithEvents btnRequestBOM As Button
    Friend WithEvents btnStartProduction As Button
    Friend WithEvents btnCompleteProduct As Button
    Friend WithEvents btnPrint As Button
    End Class
End Namespace
