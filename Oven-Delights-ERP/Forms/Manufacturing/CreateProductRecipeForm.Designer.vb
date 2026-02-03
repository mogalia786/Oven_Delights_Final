<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class CreateProductRecipeForm
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
        Me.pnlHeader = New System.Windows.Forms.Panel()
        Me.lblTitle = New System.Windows.Forms.Label()
        Me.pnlMain = New System.Windows.Forms.Panel()
        Me.grpProduct = New System.Windows.Forms.GroupBox()
        Me.cboProduct = New System.Windows.Forms.ComboBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.grpComponents = New System.Windows.Forms.GroupBox()
        Me.dgvComponents = New System.Windows.Forms.DataGridView()
        Me.btnAddComponent = New System.Windows.Forms.Button()
        Me.txtComponentQty = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.cboComponent = New System.Windows.Forms.ComboBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.grpConsolidated = New System.Windows.Forms.GroupBox()
        Me.dgvConsolidatedBOM = New System.Windows.Forms.DataGridView()
        Me.chkShowConsolidated = New System.Windows.Forms.CheckBox()
        Me.grpMethod = New System.Windows.Forms.GroupBox()
        Me.txtMethod = New System.Windows.Forms.TextBox()
        Me.grpBatch = New System.Windows.Forms.GroupBox()
        Me.txtBatchQty = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.pnlFooter = New System.Windows.Forms.Panel()
        Me.lblAdhocCost = New System.Windows.Forms.Label()
        Me.lblBatchCost = New System.Windows.Forms.Label()
        Me.lblTotalCost = New System.Windows.Forms.Label()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.btnPrint = New System.Windows.Forms.Button()
        Me.btnClear = New System.Windows.Forms.Button()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.pnlHeader.SuspendLayout()
        Me.pnlMain.SuspendLayout()
        Me.grpProduct.SuspendLayout()
        Me.grpComponents.SuspendLayout()
        CType(Me.dgvComponents, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.grpConsolidated.SuspendLayout()
        CType(Me.dgvConsolidatedBOM, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.grpMethod.SuspendLayout()
        Me.grpBatch.SuspendLayout()
        Me.pnlFooter.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlHeader
        '
        Me.pnlHeader.BackColor = System.Drawing.Color.FromArgb(CType(CType(41, Byte), Integer), CType(CType(128, Byte), Integer), CType(CType(185, Byte), Integer))
        Me.pnlHeader.Controls.Add(Me.lblTitle)
        Me.pnlHeader.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlHeader.Location = New System.Drawing.Point(0, 0)
        Me.pnlHeader.Name = "pnlHeader"
        Me.pnlHeader.Size = New System.Drawing.Size(1600, 80)
        Me.pnlHeader.TabIndex = 0
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 24.0!, System.Drawing.FontStyle.Bold)
        Me.lblTitle.ForeColor = System.Drawing.Color.White
        Me.lblTitle.Location = New System.Drawing.Point(20, 20)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(549, 45)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Create Product Recipe - WOW FACTOR"
        '
        'pnlMain
        '
        Me.pnlMain.AutoScroll = True
        Me.pnlMain.Controls.Add(Me.grpMethod)
        Me.pnlMain.Controls.Add(Me.grpConsolidated)
        Me.pnlMain.Controls.Add(Me.grpComponents)
        Me.pnlMain.Controls.Add(Me.grpBatch)
        Me.pnlMain.Controls.Add(Me.grpProduct)
        Me.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMain.Location = New System.Drawing.Point(0, 80)
        Me.pnlMain.Name = "pnlMain"
        Me.pnlMain.Padding = New System.Windows.Forms.Padding(20)
        Me.pnlMain.Size = New System.Drawing.Size(1600, 820)
        Me.pnlMain.TabIndex = 1
        '
        'grpProduct
        '
        Me.grpProduct.Controls.Add(Me.cboProduct)
        Me.grpProduct.Controls.Add(Me.Label1)
        Me.grpProduct.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpProduct.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpProduct.Location = New System.Drawing.Point(20, 20)
        Me.grpProduct.Name = "grpProduct"
        Me.grpProduct.Size = New System.Drawing.Size(1560, 80)
        Me.grpProduct.TabIndex = 0
        Me.grpProduct.TabStop = False
        Me.grpProduct.Text = "Select Product"
        '
        'cboProduct
        '
        Me.cboProduct.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDown
        Me.cboProduct.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.cboProduct.FormattingEnabled = True
        Me.cboProduct.Location = New System.Drawing.Point(120, 30)
        Me.cboProduct.Name = "cboProduct"
        Me.cboProduct.Size = New System.Drawing.Size(500, 28)
        Me.cboProduct.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label1.Location = New System.Drawing.Point(20, 33)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(62, 19)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Product:"
        '
        'grpComponents
        '
        Me.grpComponents.Controls.Add(Me.dgvComponents)
        Me.grpComponents.Controls.Add(Me.btnAddComponent)
        Me.grpComponents.Controls.Add(Me.txtComponentQty)
        Me.grpComponents.Controls.Add(Me.Label3)
        Me.grpComponents.Controls.Add(Me.cboComponent)
        Me.grpComponents.Controls.Add(Me.Label2)
        Me.grpComponents.Controls.Add(Me.chkShowConsolidated)
        Me.grpComponents.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpComponents.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpComponents.Location = New System.Drawing.Point(20, 180)
        Me.grpComponents.Name = "grpComponents"
        Me.grpComponents.Size = New System.Drawing.Size(1560, 300)
        Me.grpComponents.TabIndex = 2
        Me.grpComponents.TabStop = False
        Me.grpComponents.Text = "Components"
        '
        'dgvComponents
        '
        Me.dgvComponents.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvComponents.Location = New System.Drawing.Point(20, 80)
        Me.dgvComponents.Name = "dgvComponents"
        Me.dgvComponents.Size = New System.Drawing.Size(1520, 200)
        Me.dgvComponents.TabIndex = 5
        '
        'btnAddComponent
        '
        Me.btnAddComponent.BackColor = System.Drawing.Color.FromArgb(CType(CType(39, Byte), Integer), CType(CType(174, Byte), Integer), CType(CType(96, Byte), Integer))
        Me.btnAddComponent.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnAddComponent.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnAddComponent.ForeColor = System.Drawing.Color.White
        Me.btnAddComponent.Location = New System.Drawing.Point(750, 30)
        Me.btnAddComponent.Name = "btnAddComponent"
        Me.btnAddComponent.Size = New System.Drawing.Size(150, 35)
        Me.btnAddComponent.TabIndex = 4
        Me.btnAddComponent.Text = "Add Component"
        Me.btnAddComponent.UseVisualStyleBackColor = False
        '
        'txtComponentQty
        '
        Me.txtComponentQty.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.txtComponentQty.Location = New System.Drawing.Point(650, 33)
        Me.txtComponentQty.Name = "txtComponentQty"
        Me.txtComponentQty.Size = New System.Drawing.Size(80, 27)
        Me.txtComponentQty.TabIndex = 3
        Me.txtComponentQty.Text = "1"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label3.Location = New System.Drawing.Point(570, 36)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(67, 19)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "Quantity:"
        '
        'cboComponent
        '
        Me.cboComponent.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDown
        Me.cboComponent.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.cboComponent.FormattingEnabled = True
        Me.cboComponent.Location = New System.Drawing.Point(120, 33)
        Me.cboComponent.Name = "cboComponent"
        Me.cboComponent.Size = New System.Drawing.Size(430, 28)
        Me.cboComponent.TabIndex = 1
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label2.Location = New System.Drawing.Point(20, 36)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(90, 19)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "Component:"
        '
        'chkShowConsolidated
        '
        Me.chkShowConsolidated.AutoSize = True
        Me.chkShowConsolidated.Font = New System.Drawing.Font("Segoe UI", 9.0!)
        Me.chkShowConsolidated.Location = New System.Drawing.Point(900, 36)
        Me.chkShowConsolidated.Name = "chkShowConsolidated"
        Me.chkShowConsolidated.Size = New System.Drawing.Size(150, 19)
        Me.chkShowConsolidated.TabIndex = 6
        Me.chkShowConsolidated.Text = "Show Consolidated BOM"
        Me.chkShowConsolidated.UseVisualStyleBackColor = True
        '
        'grpConsolidated
        '
        Me.grpConsolidated.Controls.Add(Me.dgvConsolidatedBOM)
        Me.grpConsolidated.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpConsolidated.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpConsolidated.Location = New System.Drawing.Point(20, 480)
        Me.grpConsolidated.Name = "grpConsolidated"
        Me.grpConsolidated.Size = New System.Drawing.Size(1560, 200)
        Me.grpConsolidated.TabIndex = 3
        Me.grpConsolidated.TabStop = False
        Me.grpConsolidated.Text = "Consolidated BOM (Auto-Generated)"
        Me.grpConsolidated.Visible = False
        '
        'dgvConsolidatedBOM
        '
        Me.dgvConsolidatedBOM.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvConsolidatedBOM.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvConsolidatedBOM.Location = New System.Drawing.Point(3, 22)
        Me.dgvConsolidatedBOM.Name = "dgvConsolidatedBOM"
        Me.dgvConsolidatedBOM.Size = New System.Drawing.Size(1554, 175)
        Me.dgvConsolidatedBOM.TabIndex = 0
        '
        'grpMethod
        '
        Me.grpMethod.Controls.Add(Me.txtMethod)
        Me.grpMethod.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpMethod.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpMethod.Location = New System.Drawing.Point(20, 680)
        Me.grpMethod.Name = "grpMethod"
        Me.grpMethod.Size = New System.Drawing.Size(1560, 150)
        Me.grpMethod.TabIndex = 4
        Me.grpMethod.TabStop = False
        Me.grpMethod.Text = "Assembly Method / Instructions"
        '
        'txtMethod
        '
        Me.txtMethod.Dock = System.Windows.Forms.DockStyle.Fill
        Me.txtMethod.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.txtMethod.Location = New System.Drawing.Point(3, 22)
        Me.txtMethod.Multiline = True
        Me.txtMethod.Name = "txtMethod"
        Me.txtMethod.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtMethod.Size = New System.Drawing.Size(1554, 125)
        Me.txtMethod.TabIndex = 0
        '
        'grpBatch
        '
        Me.grpBatch.Controls.Add(Me.txtBatchQty)
        Me.grpBatch.Controls.Add(Me.Label6)
        Me.grpBatch.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpBatch.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpBatch.Location = New System.Drawing.Point(20, 100)
        Me.grpBatch.Name = "grpBatch"
        Me.grpBatch.Size = New System.Drawing.Size(1560, 80)
        Me.grpBatch.TabIndex = 1
        Me.grpBatch.TabStop = False
        Me.grpBatch.Text = "Batch Quantity"
        '
        'txtBatchQty
        '
        Me.txtBatchQty.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.txtBatchQty.Location = New System.Drawing.Point(150, 30)
        Me.txtBatchQty.Name = "txtBatchQty"
        Me.txtBatchQty.Size = New System.Drawing.Size(150, 27)
        Me.txtBatchQty.TabIndex = 1
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label6.Location = New System.Drawing.Point(20, 33)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(102, 19)
        Me.Label6.TabIndex = 0
        Me.Label6.Text = "Batch Quantity:"
        '
        'pnlFooter
        '
        Me.pnlFooter.BackColor = System.Drawing.Color.White
        Me.pnlFooter.Controls.Add(Me.lblAdhocCost)
        Me.pnlFooter.Controls.Add(Me.lblBatchCost)
        Me.pnlFooter.Controls.Add(Me.lblTotalCost)
        Me.pnlFooter.Controls.Add(Me.btnClose)
        Me.pnlFooter.Controls.Add(Me.btnPrint)
        Me.pnlFooter.Controls.Add(Me.btnClear)
        Me.pnlFooter.Controls.Add(Me.btnSave)
        Me.pnlFooter.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlFooter.Location = New System.Drawing.Point(0, 900)
        Me.pnlFooter.Name = "pnlFooter"
        Me.pnlFooter.Size = New System.Drawing.Size(1600, 80)
        Me.pnlFooter.TabIndex = 2
        '
        'lblTotalCost
        '
        Me.lblTotalCost.AutoSize = True
        Me.lblTotalCost.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalCost.ForeColor = System.Drawing.Color.FromArgb(CType(CType(39, Byte), Integer), CType(CType(174, Byte), Integer), CType(CType(96, Byte), Integer))
        Me.lblTotalCost.Location = New System.Drawing.Point(20, 10)
        Me.lblTotalCost.Name = "lblTotalCost"
        Me.lblTotalCost.Size = New System.Drawing.Size(400, 20)
        Me.lblTotalCost.TabIndex = 4
        Me.lblTotalCost.Text = "1 UNIT: Excl VAT: R0.00 | VAT (15%): R0.00 | Incl VAT: R0.00"
        '
        'lblBatchCost
        '
        Me.lblBatchCost.AutoSize = True
        Me.lblBatchCost.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblBatchCost.ForeColor = System.Drawing.Color.FromArgb(CType(CType(41, Byte), Integer), CType(CType(128, Byte), Integer), CType(CType(185, Byte), Integer))
        Me.lblBatchCost.Location = New System.Drawing.Point(20, 30)
        Me.lblBatchCost.Name = "lblBatchCost"
        Me.lblBatchCost.Size = New System.Drawing.Size(400, 20)
        Me.lblBatchCost.TabIndex = 5
        Me.lblBatchCost.Text = "BATCH: Excl VAT: R0.00 | VAT (15%): R0.00 | Incl VAT: R0.00"
        '
        'lblAdhocCost
        '
        Me.lblAdhocCost.AutoSize = True
        Me.lblAdhocCost.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblAdhocCost.ForeColor = System.Drawing.Color.FromArgb(CType(CType(230, Byte), Integer), CType(CType(126, Byte), Integer), CType(CType(34, Byte), Integer))
        Me.lblAdhocCost.Location = New System.Drawing.Point(20, 50)
        Me.lblAdhocCost.Name = "lblAdhocCost"
        Me.lblAdhocCost.Size = New System.Drawing.Size(500, 20)
        Me.lblAdhocCost.TabIndex = 6
        Me.lblAdhocCost.Text = "WITH ADHOC (+15%): Excl VAT: R0.00 | VAT (15%): R0.00 | Incl VAT: R0.00"
        '
        'btnClose
        '
        Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(149, Byte), Integer), CType(CType(165, Byte), Integer), CType(CType(166, Byte), Integer))
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(1430, 20)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(150, 45)
        Me.btnClose.TabIndex = 3
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = False
        '
        'btnPrint
        '
        Me.btnPrint.BackColor = System.Drawing.Color.FromArgb(CType(CType(142, Byte), Integer), CType(CType(68, Byte), Integer), CType(CType(173, Byte), Integer))
        Me.btnPrint.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnPrint.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.btnPrint.ForeColor = System.Drawing.Color.White
        Me.btnPrint.Location = New System.Drawing.Point(1260, 20)
        Me.btnPrint.Name = "btnPrint"
        Me.btnPrint.Size = New System.Drawing.Size(150, 45)
        Me.btnPrint.TabIndex = 2
        Me.btnPrint.Text = "Print"
        Me.btnPrint.UseVisualStyleBackColor = False
        '
        'btnClear
        '
        Me.btnClear.BackColor = System.Drawing.Color.FromArgb(CType(CType(230, Byte), Integer), CType(CType(126, Byte), Integer), CType(CType(34, Byte), Integer))
        Me.btnClear.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClear.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.btnClear.ForeColor = System.Drawing.Color.White
        Me.btnClear.Location = New System.Drawing.Point(1090, 20)
        Me.btnClear.Name = "btnClear"
        Me.btnClear.Size = New System.Drawing.Size(150, 45)
        Me.btnClear.TabIndex = 1
        Me.btnClear.Text = "Clear"
        Me.btnClear.UseVisualStyleBackColor = False
        '
        'btnSave
        '
        Me.btnSave.BackColor = System.Drawing.Color.FromArgb(CType(CType(39, Byte), Integer), CType(CType(174, Byte), Integer), CType(CType(96, Byte), Integer))
        Me.btnSave.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnSave.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.btnSave.ForeColor = System.Drawing.Color.White
        Me.btnSave.Location = New System.Drawing.Point(920, 20)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(150, 45)
        Me.btnSave.TabIndex = 0
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = False
        '
        'CreateProductRecipeForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1600, 980)
        Me.Controls.Add(Me.pnlMain)
        Me.Controls.Add(Me.pnlFooter)
        Me.Controls.Add(Me.pnlHeader)
        Me.Name = "CreateProductRecipeForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Create Product Recipe"
        Me.pnlHeader.ResumeLayout(False)
        Me.pnlHeader.PerformLayout()
        Me.pnlMain.ResumeLayout(False)
        Me.grpProduct.ResumeLayout(False)
        Me.grpProduct.PerformLayout()
        Me.grpComponents.ResumeLayout(False)
        Me.grpComponents.PerformLayout()
        CType(Me.dgvComponents, System.ComponentModel.ISupportInitialize).EndInit()
        Me.grpConsolidated.ResumeLayout(False)
        CType(Me.dgvConsolidatedBOM, System.ComponentModel.ISupportInitialize).EndInit()
        Me.grpMethod.ResumeLayout(False)
        Me.grpMethod.PerformLayout()
        Me.grpBatch.ResumeLayout(False)
        Me.grpBatch.PerformLayout()
        Me.pnlFooter.ResumeLayout(False)
        Me.pnlFooter.PerformLayout()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents pnlHeader As Panel
    Friend WithEvents lblTitle As Label
    Friend WithEvents pnlMain As Panel
    Friend WithEvents grpProduct As GroupBox
    Friend WithEvents cboProduct As ComboBox
    Friend WithEvents Label1 As Label
    Friend WithEvents grpComponents As GroupBox
    Friend WithEvents dgvComponents As DataGridView
    Friend WithEvents btnAddComponent As Button
    Friend WithEvents txtComponentQty As TextBox
    Friend WithEvents Label3 As Label
    Friend WithEvents cboComponent As ComboBox
    Friend WithEvents Label2 As Label
    Friend WithEvents grpConsolidated As GroupBox
    Friend WithEvents dgvConsolidatedBOM As DataGridView
    Friend WithEvents grpMethod As GroupBox
    Friend WithEvents txtMethod As TextBox
    Friend WithEvents grpBatch As GroupBox
    Friend WithEvents txtBatchQty As TextBox
    Friend WithEvents Label6 As Label
    Friend WithEvents pnlFooter As Panel
    Friend WithEvents lblTotalCost As Label
    Friend WithEvents lblBatchCost As Label
    Friend WithEvents lblAdhocCost As Label
    Friend WithEvents btnClose As Button
    Friend WithEvents btnPrint As Button
    Friend WithEvents btnClear As Button
    Friend WithEvents btnSave As Button
    Friend WithEvents chkShowConsolidated As CheckBox
End Class
