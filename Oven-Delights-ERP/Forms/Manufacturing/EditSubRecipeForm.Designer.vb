<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class EditSubRecipeForm
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
        Me.lblSubRecipeName = New System.Windows.Forms.Label()
        Me.grpIngredients = New System.Windows.Forms.GroupBox()
        Me.dgvIngredients = New System.Windows.Forms.DataGridView()
        Me.btnAddIngredient = New System.Windows.Forms.Button()
        Me.txtQuantity = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.cboIngredient = New System.Windows.Forms.ComboBox()
        Me.Label2 = New System.Windows.Forms.Label()
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
        Me.lblTitle.Size = New System.Drawing.Size(280, 45)
        Me.lblTitle.TabIndex = 0
        Me.lblTitle.Text = "Edit Sub-Recipe"
        '
        'pnlMain
        '
        Me.pnlMain.AutoScroll = True
        Me.pnlMain.Controls.Add(Me.grpMethod)
        Me.pnlMain.Controls.Add(Me.grpIngredients)
        Me.pnlMain.Controls.Add(Me.grpBatch)
        Me.pnlMain.Controls.Add(Me.grpSubRecipe)
        Me.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMain.Location = New System.Drawing.Point(0, 80)
        Me.pnlMain.Name = "pnlMain"
        Me.pnlMain.Padding = New System.Windows.Forms.Padding(20)
        Me.pnlMain.Size = New System.Drawing.Size(1600, 720)
        Me.pnlMain.TabIndex = 1
        '
        'grpSubRecipe
        '
        Me.grpSubRecipe.Controls.Add(Me.lblSubRecipeName)
        Me.grpSubRecipe.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpSubRecipe.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpSubRecipe.Location = New System.Drawing.Point(20, 20)
        Me.grpSubRecipe.Name = "grpSubRecipe"
        Me.grpSubRecipe.Padding = New System.Windows.Forms.Padding(10)
        Me.grpSubRecipe.Size = New System.Drawing.Size(1560, 80)
        Me.grpSubRecipe.TabIndex = 0
        Me.grpSubRecipe.TabStop = False
        Me.grpSubRecipe.Text = "Sub-Recipe"
        '
        'lblSubRecipeName
        '
        Me.lblSubRecipeName.AutoSize = True
        Me.lblSubRecipeName.Font = New System.Drawing.Font("Segoe UI", 14.0!, System.Drawing.FontStyle.Bold)
        Me.lblSubRecipeName.Location = New System.Drawing.Point(15, 30)
        Me.lblSubRecipeName.Name = "lblSubRecipeName"
        Me.lblSubRecipeName.Size = New System.Drawing.Size(200, 25)
        Me.lblSubRecipeName.TabIndex = 0
        Me.lblSubRecipeName.Text = "Sub-Recipe Name"
        '
        'grpBatch
        '
        Me.grpBatch.Controls.Add(Me.txtBatchQty)
        Me.grpBatch.Controls.Add(Me.Label6)
        Me.grpBatch.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpBatch.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpBatch.Location = New System.Drawing.Point(20, 100)
        Me.grpBatch.Name = "grpBatch"
        Me.grpBatch.Padding = New System.Windows.Forms.Padding(10)
        Me.grpBatch.Size = New System.Drawing.Size(1560, 80)
        Me.grpBatch.TabIndex = 1
        Me.grpBatch.TabStop = False
        Me.grpBatch.Text = "Batch Quantity"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label6.Location = New System.Drawing.Point(15, 35)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(100, 19)
        Me.Label6.TabIndex = 0
        Me.Label6.Text = "Batch Quantity:"
        '
        'txtBatchQty
        '
        Me.txtBatchQty.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.txtBatchQty.Location = New System.Drawing.Point(130, 32)
        Me.txtBatchQty.Name = "txtBatchQty"
        Me.txtBatchQty.Size = New System.Drawing.Size(150, 25)
        Me.txtBatchQty.TabIndex = 1
        '
        'grpIngredients
        '
        Me.grpIngredients.Controls.Add(Me.dgvIngredients)
        Me.grpIngredients.Controls.Add(Me.btnAddIngredient)
        Me.grpIngredients.Controls.Add(Me.txtQuantity)
        Me.grpIngredients.Controls.Add(Me.Label3)
        Me.grpIngredients.Controls.Add(Me.cboIngredient)
        Me.grpIngredients.Controls.Add(Me.Label2)
        Me.grpIngredients.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpIngredients.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpIngredients.Location = New System.Drawing.Point(20, 180)
        Me.grpIngredients.Name = "grpIngredients"
        Me.grpIngredients.Padding = New System.Windows.Forms.Padding(10)
        Me.grpIngredients.Size = New System.Drawing.Size(1560, 400)
        Me.grpIngredients.TabIndex = 2
        Me.grpIngredients.TabStop = False
        Me.grpIngredients.Text = "Ingredients"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label2.Location = New System.Drawing.Point(15, 35)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(75, 19)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "Ingredient:"
        '
        'cboIngredient
        '
        Me.cboIngredient.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboIngredient.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.cboIngredient.FormattingEnabled = True
        Me.cboIngredient.Location = New System.Drawing.Point(100, 32)
        Me.cboIngredient.Name = "cboIngredient"
        Me.cboIngredient.Size = New System.Drawing.Size(400, 25)
        Me.cboIngredient.TabIndex = 1
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.Label3.Location = New System.Drawing.Point(520, 35)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(65, 19)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "Quantity:"
        '
        'txtQuantity
        '
        Me.txtQuantity.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.txtQuantity.Location = New System.Drawing.Point(595, 32)
        Me.txtQuantity.Name = "txtQuantity"
        Me.txtQuantity.Size = New System.Drawing.Size(150, 25)
        Me.txtQuantity.TabIndex = 3
        '
        'btnAddIngredient
        '
        Me.btnAddIngredient.BackColor = System.Drawing.Color.FromArgb(CType(CType(39, Byte), Integer), CType(CType(174, Byte), Integer), CType(CType(96, Byte), Integer))
        Me.btnAddIngredient.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnAddIngredient.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.btnAddIngredient.ForeColor = System.Drawing.Color.White
        Me.btnAddIngredient.Location = New System.Drawing.Point(765, 28)
        Me.btnAddIngredient.Name = "btnAddIngredient"
        Me.btnAddIngredient.Size = New System.Drawing.Size(150, 35)
        Me.btnAddIngredient.TabIndex = 4
        Me.btnAddIngredient.Text = "Add Ingredient"
        Me.btnAddIngredient.UseVisualStyleBackColor = False
        '
        'dgvIngredients
        '
        Me.dgvIngredients.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvIngredients.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvIngredients.Location = New System.Drawing.Point(15, 75)
        Me.dgvIngredients.Name = "dgvIngredients"
        Me.dgvIngredients.Size = New System.Drawing.Size(1530, 310)
        Me.dgvIngredients.TabIndex = 5
        '
        'grpMethod
        '
        Me.grpMethod.Controls.Add(Me.txtMethod)
        Me.grpMethod.Dock = System.Windows.Forms.DockStyle.Top
        Me.grpMethod.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
        Me.grpMethod.Location = New System.Drawing.Point(20, 580)
        Me.grpMethod.Name = "grpMethod"
        Me.grpMethod.Padding = New System.Windows.Forms.Padding(10)
        Me.grpMethod.Size = New System.Drawing.Size(1560, 200)
        Me.grpMethod.TabIndex = 3
        Me.grpMethod.TabStop = False
        Me.grpMethod.Text = "Assembly Method / Instructions"
        '
        'txtMethod
        '
        Me.txtMethod.Dock = System.Windows.Forms.DockStyle.Fill
        Me.txtMethod.Font = New System.Drawing.Font("Segoe UI", 10.0!)
        Me.txtMethod.Location = New System.Drawing.Point(10, 32)
        Me.txtMethod.Multiline = True
        Me.txtMethod.Name = "txtMethod"
        Me.txtMethod.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtMethod.Size = New System.Drawing.Size(1540, 158)
        Me.txtMethod.TabIndex = 0
        '
        'pnlFooter
        '
        Me.pnlFooter.BackColor = System.Drawing.Color.FromArgb(CType(CType(236, Byte), Integer), CType(CType(240, Byte), Integer), CType(CType(241, Byte), Integer))
        Me.pnlFooter.Controls.Add(Me.lblAdhocCost)
        Me.pnlFooter.Controls.Add(Me.lblBatchCost)
        Me.pnlFooter.Controls.Add(Me.lblTotalCost)
        Me.pnlFooter.Controls.Add(Me.btnClose)
        Me.pnlFooter.Controls.Add(Me.btnSave)
        Me.pnlFooter.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlFooter.Location = New System.Drawing.Point(0, 800)
        Me.pnlFooter.Name = "pnlFooter"
        Me.pnlFooter.Padding = New System.Windows.Forms.Padding(20)
        Me.pnlFooter.Size = New System.Drawing.Size(1600, 100)
        Me.pnlFooter.TabIndex = 2
        '
        'lblTotalCost
        '
        Me.lblTotalCost.AutoSize = True
        Me.lblTotalCost.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblTotalCost.Location = New System.Drawing.Point(20, 15)
        Me.lblTotalCost.Name = "lblTotalCost"
        Me.lblTotalCost.Size = New System.Drawing.Size(300, 20)
        Me.lblTotalCost.TabIndex = 0
        Me.lblTotalCost.Text = "1 UNIT: Excl VAT: R0.00 | Incl VAT: R0.00"
        '
        'lblBatchCost
        '
        Me.lblBatchCost.AutoSize = True
        Me.lblBatchCost.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblBatchCost.Location = New System.Drawing.Point(20, 40)
        Me.lblBatchCost.Name = "lblBatchCost"
        Me.lblBatchCost.Size = New System.Drawing.Size(350, 20)
        Me.lblBatchCost.TabIndex = 1
        Me.lblBatchCost.Text = "BATCH (1 units): Excl VAT: R0.00 | Incl VAT: R0.00"
        '
        'lblAdhocCost
        '
        Me.lblAdhocCost.AutoSize = True
        Me.lblAdhocCost.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
        Me.lblAdhocCost.Location = New System.Drawing.Point(20, 65)
        Me.lblAdhocCost.Name = "lblAdhocCost"
        Me.lblAdhocCost.Size = New System.Drawing.Size(400, 20)
        Me.lblAdhocCost.TabIndex = 2
        Me.lblAdhocCost.Text = "WITH ADHOC (+15%): Excl VAT: R0.00 | Incl VAT: R0.00"
        '
        'btnSave
        '
        Me.btnSave.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnSave.BackColor = System.Drawing.Color.FromArgb(CType(CType(39, Byte), Integer), CType(CType(174, Byte), Integer), CType(CType(96, Byte), Integer))
        Me.btnSave.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnSave.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.btnSave.ForeColor = System.Drawing.Color.White
        Me.btnSave.Location = New System.Drawing.Point(1280, 30)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(140, 45)
        Me.btnSave.TabIndex = 3
        Me.btnSave.Text = "Save"
        Me.btnSave.UseVisualStyleBackColor = False
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(231, Byte), Integer), CType(CType(76, Byte), Integer), CType(CType(60, Byte), Integer))
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnClose.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
        Me.btnClose.ForeColor = System.Drawing.Color.White
        Me.btnClose.Location = New System.Drawing.Point(1440, 30)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(140, 45)
        Me.btnClose.TabIndex = 4
        Me.btnClose.Text = "Close"
        Me.btnClose.UseVisualStyleBackColor = False
        '
        'EditSubRecipeForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1600, 900)
        Me.Controls.Add(Me.pnlMain)
        Me.Controls.Add(Me.pnlFooter)
        Me.Controls.Add(Me.pnlHeader)
        Me.Name = "EditSubRecipeForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Edit Sub-Recipe"
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
    Friend WithEvents lblSubRecipeName As Label
    Friend WithEvents grpBatch As GroupBox
    Friend WithEvents txtBatchQty As TextBox
    Friend WithEvents Label6 As Label
    Friend WithEvents grpIngredients As GroupBox
    Friend WithEvents dgvIngredients As DataGridView
    Friend WithEvents btnAddIngredient As Button
    Friend WithEvents txtQuantity As TextBox
    Friend WithEvents Label3 As Label
    Friend WithEvents cboIngredient As ComboBox
    Friend WithEvents Label2 As Label
    Friend WithEvents grpMethod As GroupBox
    Friend WithEvents txtMethod As TextBox
    Friend WithEvents pnlFooter As Panel
    Friend WithEvents lblAdhocCost As Label
    Friend WithEvents lblBatchCost As Label
    Friend WithEvents lblTotalCost As Label
    Friend WithEvents btnClose As Button
    Friend WithEvents btnSave As Button
End Class
