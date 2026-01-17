<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class CreateSubRecipeForm
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
        Me.grpSubRecipe = New System.Windows.Forms.GroupBox()
        Me.cboSubRecipe = New System.Windows.Forms.ComboBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.grpIngredients = New System.Windows.Forms.GroupBox()
        Me.btnAddIngredient = New System.Windows.Forms.Button()
        Me.txtPackageSize = New System.Windows.Forms.TextBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.cboUnit = New System.Windows.Forms.ComboBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.txtQuantity = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.cboIngredient = New System.Windows.Forms.ComboBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.dgvIngredients = New System.Windows.Forms.DataGridView()
        Me.grpMethod = New System.Windows.Forms.GroupBox()
        Me.txtMethod = New System.Windows.Forms.TextBox()
        Me.grpBatch = New System.Windows.Forms.GroupBox()
        Me.txtBatchQty = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.pnlFooter = New System.Windows.Forms.Panel()
        Me.lblAdhocCost = New System.Windows.Forms.Label()
        Me.lblTotalCost = New System.Windows.Forms.Label()
        Me.btnClose = New System.Windows.Forms.Button()
        Me.btnPrint = New System.Windows.Forms.Button()
        Me.btnClear = New System.Windows.Forms.Button()
        Me.btnSave = New System.Windows.Forms.Button()
        Me.pnlHeader.SuspendLayout()
        Me.pnlMain.SuspendLayout()
        Me.grpSubRecipe.SuspendLayout()
        Me.grpIngredients.SuspendLayout()
        CType(Me.dgvIngredients, System.ComponentModel.ISupportInitialize).BeginInit()
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
        Me.pnlHeader.Size = New System.Drawing.Size(1400, 80)
        Me.pnlHeader.TabIndex = 0
        '
        'lblTitle
        '
        Me.lblTitle.AutoSize = True
        Me.lblTitle.Font = New System.Drawing.Font("Segoe UI", 24.0!, System.Drawing.FontStyle.Bold)
        Me.lblTitle.ForeColor = System.Drawing.Color.White
        Me.lblTitle.Location = New System.Drawing.Point(20, 20)
        Me.lblTitle.Name = "lblTitle"
        Me.lblTitle.Size = New System.Drawing.Size(512, 45)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Create Sub-Recipe - WOW FACTOR"
        '
        'pnlMain
        '
        Me.pnlMain.Controls.Add(Me.grpMethod)
        Me.pnlMain.Controls.Add(Me.grpIngredients)
        Me.pnlMain.Controls.Add(Me.grpBatch)
        Me.pnlMain.Controls.Add(Me.grpSubRecipe)
        Me.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMain.Location = New System.Drawing.Point(0, 80)
        Me.pnlMain.Name = "pnlMain"
        Me.pnlMain.Padding = New System.Windows.Forms.Padding(20)
        Me.pnlMain.Size = New System.Drawing.Size(1400, 670)
        Me.pnlMain.TabIndex = 1
        '
        'grpSubRecipe
        '
        Me.grpSubRecipe.Controls.Add(Me.cboSubRecipe)
        Me.grpSubRecipe.Controls.Add(Me.Label1)
        Me.grpSubRecipe.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpSubRecipe.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpSubRecipe.Location = New System.Drawing.Point(20, 20)
        Me.grpSubRecipe.Name = "grpSubRecipe"
        Me.grpSubRecipe.Size = New System.Drawing.Size(1360, 80)
        Me.grpSubRecipe.TabIndex = 0
        Me.grpSubRecipe.TabStop = False
        Me.grpSubRecipe.Text = "Select Sub-Recipe"
        '
        'cboSubRecipe
        '
        Me.cboSubRecipe.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDown
        Me.cboSubRecipe.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.cboSubRecipe.FormattingEnabled = True
        Me.cboSubRecipe.Location = New System.Drawing.Point(150, 30)
        Me.cboSubRecipe.Name = "cboSubRecipe"
        Me.cboSubRecipe.Size = New System.Drawing.Size(500, 28)
        Me.cboSubRecipe.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label1.Location = New System.Drawing.Point(20, 33)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(82, 19)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Sub-Recipe:"
        '
        'grpIngredients
        '
        Me.grpIngredients.Controls.Add(Me.dgvIngredients)
        Me.grpIngredients.Controls.Add(Me.btnAddIngredient)
        Me.grpIngredients.Controls.Add(Me.txtPackageSize)
        Me.grpIngredients.Controls.Add(Me.Label5)
        Me.grpIngredients.Controls.Add(Me.cboUnit)
        Me.grpIngredients.Controls.Add(Me.Label4)
        Me.grpIngredients.Controls.Add(Me.txtQuantity)
        Me.grpIngredients.Controls.Add(Me.Label3)
        Me.grpIngredients.Controls.Add(Me.cboIngredient)
        Me.grpIngredients.Controls.Add(Me.Label2)
        Me.grpIngredients.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpIngredients.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpIngredients.Location = New System.Drawing.Point(20, 180)
        Me.grpIngredients.Name = "grpIngredients"
        Me.grpIngredients.Size = New System.Drawing.Size(1360, 300)
        Me.grpIngredients.TabIndex = 2
        Me.grpIngredients.TabStop = False
        Me.grpIngredients.Text = "Ingredients"
        '
        'btnAddIngredient
        '
        Me.btnAddIngredient.BackColor = System.Drawing.Color.FromArgb(CType(CType(39, Byte), Integer), CType(CType(174, Byte), Integer), CType(CType(96, Byte), Integer))
        Me.btnAddIngredient.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnAddIngredient.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnAddIngredient.ForeColor = System.Drawing.Color.White
        Me.btnAddIngredient.Location = New System.Drawing.Point(1050, 30)
        Me.btnAddIngredient.Name = "btnAddIngredient"
        Me.btnAddIngredient.Size = New System.Drawing.Size(150, 35)
        Me.btnAddIngredient.TabIndex = 9
        Me.btnAddIngredient.Text = "Add Ingredient"
        Me.btnAddIngredient.UseVisualStyleBackColor = False
        '
        'txtPackageSize
        '
        Me.txtPackageSize.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.txtPackageSize.Location = New System.Drawing.Point(900, 33)
        Me.txtPackageSize.Name = "txtPackageSize"
        Me.txtPackageSize.Size = New System.Drawing.Size(120, 27)
        Me.txtPackageSize.TabIndex = 8
        Me.txtPackageSize.Visible = False
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label5.Location = New System.Drawing.Point(780, 36)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(93, 19)
        Me.Label5.TabIndex = 7
        Me.Label5.Text = "Package Size:"
        Me.Label5.Visible = False
        '
        'cboUnit
        '
        Me.cboUnit.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDown
        Me.cboUnit.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.cboUnit.FormattingEnabled = True
        Me.cboUnit.Location = New System.Drawing.Point(680, 33)
        Me.cboUnit.Name = "cboUnit"
        Me.cboUnit.Size = New System.Drawing.Size(80, 28)
        Me.cboUnit.TabIndex = 6
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label4.Location = New System.Drawing.Point(635, 36)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(38, 19)
        Me.Label4.TabIndex = 5
        Me.Label4.Text = "Unit:"
        '
        'txtQuantity
        '
        Me.txtQuantity.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.txtQuantity.Location = New System.Drawing.Point(520, 33)
        Me.txtQuantity.Name = "txtQuantity"
        Me.txtQuantity.Size = New System.Drawing.Size(100, 27)
        Me.txtQuantity.TabIndex = 4
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label3.Location = New System.Drawing.Point(440, 36)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(67, 19)
        Me.Label3.TabIndex = 3
        Me.Label3.Text = "Quantity:"
        '
        'cboIngredient
        '
        Me.cboIngredient.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDown
        Me.cboIngredient.Font = New System.Drawing.Font("Segoe UI", 11.0!)
        Me.cboIngredient.FormattingEnabled = True
        Me.cboIngredient.Location = New System.Drawing.Point(120, 33)
        Me.cboIngredient.Name = "cboIngredient"
        Me.cboIngredient.Size = New System.Drawing.Size(300, 28)
        Me.cboIngredient.TabIndex = 2
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label2.Location = New System.Drawing.Point(20, 36)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(77, 19)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "Ingredient:"
        '
        'dgvIngredients
        '
        Me.dgvIngredients.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvIngredients.Location = New System.Drawing.Point(20, 80)
        Me.dgvIngredients.Name = "dgvIngredients"
        Me.dgvIngredients.Size = New System.Drawing.Size(1320, 200)
        Me.dgvIngredients.TabIndex = 10
        '
        'grpMethod
        '
        Me.grpMethod.Controls.Add(Me.txtMethod)
        Me.grpMethod.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpMethod.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpMethod.Location = New System.Drawing.Point(20, 400)
        Me.grpMethod.Name = "grpMethod"
        Me.grpMethod.Size = New System.Drawing.Size(1360, 150)
        Me.grpMethod.TabIndex = 2
        Me.grpMethod.TabStop = False
        Me.grpMethod.Text = "Method / Instructions"
        '
        'txtMethod
        '
        Me.txtMethod.Dock = System.Windows.Forms.DockStyle.Fill
        Me.txtMethod.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.txtMethod.Location = New System.Drawing.Point(3, 22)
        Me.txtMethod.Multiline = True
        Me.txtMethod.Name = "txtMethod"
        Me.txtMethod.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtMethod.Size = New System.Drawing.Size(1354, 125)
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
        Me.grpBatch.Size = New System.Drawing.Size(1360, 80)
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
        Me.pnlFooter.Controls.Add(Me.lblTotalCost)
        Me.pnlFooter.Controls.Add(Me.btnClose)
        Me.pnlFooter.Controls.Add(Me.btnPrint)
        Me.pnlFooter.Controls.Add(Me.btnClear)
        Me.pnlFooter.Controls.Add(Me.btnSave)
        Me.pnlFooter.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlFooter.Location = New System.Drawing.Point(0, 750)
        Me.pnlFooter.Name = "pnlFooter"
        Me.pnlFooter.Size = New System.Drawing.Size(1400, 80)
        Me.pnlFooter.TabIndex = 2
        '
        'lblTotalCost
        '
        Me.lblTotalCost.AutoSize = True
        Me.lblTotalCost.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalCost.ForeColor = System.Drawing.Color.FromArgb(CType(CType(39, Byte), Integer), CType(CType(174, Byte), Integer), CType(CType(96, Byte), Integer))
        Me.lblTotalCost.Location = New System.Drawing.Point(20, 10)
        Me.lblTotalCost.Name = "lblTotalCost"
        Me.lblTotalCost.Size = New System.Drawing.Size(329, 25)
        Me.lblTotalCost.TabIndex = 4
        Me.lblTotalCost.Text = "Total Cost Per Sub-Recipe: R0.00"
        '
        'lblAdhocCost
        '
        Me.lblAdhocCost.AutoSize = True
        Me.lblAdhocCost.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.lblAdhocCost.ForeColor = System.Drawing.Color.FromArgb(CType(CType(230, Byte), Integer), CType(CType(126, Byte), Integer), CType(CType(34, Byte), Integer))
        Me.lblAdhocCost.Location = New System.Drawing.Point(20, 45)
        Me.lblAdhocCost.Name = "lblAdhocCost"
        Me.lblAdhocCost.Size = New System.Drawing.Size(329, 25)
        Me.lblAdhocCost.TabIndex = 5
        Me.lblAdhocCost.Text = "ADHOC COST (+20%): R0.00"
        '
        'btnClose
        '
        Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(149, Byte), Integer), CType(CType(165, Byte), Integer), CType(CType(166, Byte), Integer))
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(1230, 20)
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
        Me.btnPrint.Location = New System.Drawing.Point(1060, 20)
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
        Me.btnClear.Location = New System.Drawing.Point(890, 20)
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
        Me.btnSave.Location = New System.Drawing.Point(720, 20)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(150, 45)
        Me.btnSave.TabIndex = 0
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = False
        '
        'CreateSubRecipeForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1400, 830)
        Me.Controls.Add(Me.pnlMain)
        Me.Controls.Add(Me.pnlFooter)
        Me.Controls.Add(Me.pnlHeader)
        Me.Name = "CreateSubRecipeForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Create Sub-Recipe"
        Me.pnlHeader.ResumeLayout(False)
        Me.pnlHeader.PerformLayout()
        Me.pnlMain.ResumeLayout(False)
        Me.grpSubRecipe.ResumeLayout(False)
        Me.grpSubRecipe.PerformLayout()
        Me.grpIngredients.ResumeLayout(False)
        Me.grpIngredients.PerformLayout()
        CType(Me.dgvIngredients, System.ComponentModel.ISupportInitialize).EndInit()
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
    Friend WithEvents grpSubRecipe As GroupBox
    Friend WithEvents cboSubRecipe As ComboBox
    Friend WithEvents Label1 As Label
    Friend WithEvents grpIngredients As GroupBox
    Friend WithEvents dgvIngredients As DataGridView
    Friend WithEvents btnAddIngredient As Button
    Friend WithEvents txtPackageSize As TextBox
    Friend WithEvents Label5 As Label
    Friend WithEvents cboUnit As ComboBox
    Friend WithEvents Label4 As Label
    Friend WithEvents txtQuantity As TextBox
    Friend WithEvents Label3 As Label
    Friend WithEvents cboIngredient As ComboBox
    Friend WithEvents Label2 As Label
    Friend WithEvents grpMethod As GroupBox
    Friend WithEvents txtMethod As TextBox
    Friend WithEvents grpBatch As GroupBox
    Friend WithEvents txtBatchQty As TextBox
    Friend WithEvents Label6 As Label
    Friend WithEvents pnlFooter As Panel
    Friend WithEvents lblTotalCost As Label
    Friend WithEvents lblAdhocCost As Label
    Friend WithEvents btnClose As Button
    Friend WithEvents btnPrint As Button
    Friend WithEvents btnClear As Button
    Friend WithEvents btnSave As Button
End Class
