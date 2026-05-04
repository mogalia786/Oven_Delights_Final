Namespace Manufacturing
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class SubRecipeManufacturingRequestForm
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
            Me.dgvDraftRequests = New System.Windows.Forms.DataGridView()
            Me.GroupBox2 = New System.Windows.Forms.GroupBox()
            Me.btnPost = New System.Windows.Forms.Button()
            Me.grpSubRecipes = New System.Windows.Forms.GroupBox()
            Me.Label6 = New System.Windows.Forms.Label()
            Me.cmbSubRecipe = New System.Windows.Forms.ComboBox()
            Me.Label7 = New System.Windows.Forms.Label()
            Me.nudQuantity = New System.Windows.Forms.NumericUpDown()
            Me.btnAddSubRecipe = New System.Windows.Forms.Button()
            Me.dgvSubRecipeLines = New System.Windows.Forms.DataGridView()
            Me.lblTotalQuantity = New System.Windows.Forms.Label()
            Me.lblTotalSubRecipes = New System.Windows.Forms.Label()
            Me.lblBakerName = New System.Windows.Forms.Label()
            Me.txtRequestNumber = New System.Windows.Forms.TextBox()
            Me.Label5 = New System.Windows.Forms.Label()
            Me.GroupBox3 = New System.Windows.Forms.GroupBox()
            Me.btnNewRequest = New System.Windows.Forms.Button()
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
            CType(Me.dgvDraftRequests, System.ComponentModel.ISupportInitialize).BeginInit()
            Me.GroupBox2.SuspendLayout()
            Me.grpSubRecipes.SuspendLayout()
            CType(Me.nudQuantity, System.ComponentModel.ISupportInitialize).BeginInit()
            CType(Me.dgvSubRecipeLines, System.ComponentModel.ISupportInitialize).BeginInit()
            Me.GroupBox3.SuspendLayout()
            Me.SuspendLayout()
            
            ' Panel1
            Me.Panel1.BackColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(140, Byte), Integer), CType(CType(0, Byte), Integer))
            Me.Panel1.Controls.Add(Me.Label1)
            Me.Panel1.Controls.Add(Me.btnClose)
            Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
            Me.Panel1.Location = New System.Drawing.Point(0, 0)
            Me.Panel1.Name = "Panel1"
            Me.Panel1.Size = New System.Drawing.Size(1400, 60)
            Me.Panel1.TabIndex = 0
            
            ' Label1
            Me.Label1.AutoSize = True
            Me.Label1.Font = New System.Drawing.Font("Segoe UI", 16.0!, System.Drawing.FontStyle.Bold)
            Me.Label1.ForeColor = System.Drawing.Color.White
            Me.Label1.Location = New System.Drawing.Point(15, 15)
            Me.Label1.Name = "Label1"
            Me.Label1.Size = New System.Drawing.Size(400, 30)
            Me.Label1.TabIndex = 0
            Me.Label1.Text = "🧁 Sub-Recipe Manufacturing Request"
            
            ' btnClose
            Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.btnClose.BackColor = System.Drawing.Color.FromArgb(CType(CType(231, Byte), Integer), CType(CType(76, Byte), Integer), CType(CType(60, Byte), Integer))
            Me.btnClose.FlatAppearance.BorderSize = 0
            Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnClose.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.btnClose.ForeColor = System.Drawing.Color.White
            Me.btnClose.Location = New System.Drawing.Point(1320, 10)
            Me.btnClose.Name = "btnClose"
            Me.btnClose.Size = New System.Drawing.Size(70, 40)
            Me.btnClose.TabIndex = 1
            Me.btnClose.Text = "✖ Close"
            Me.btnClose.UseVisualStyleBackColor = False
            
            ' SplitContainer1
            Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
            Me.SplitContainer1.Location = New System.Drawing.Point(0, 60)
            Me.SplitContainer1.Name = "SplitContainer1"
            Me.SplitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal
            Me.SplitContainer1.Panel1.Controls.Add(Me.GroupBox3)
            Me.SplitContainer1.Panel2.Controls.Add(Me.GroupBox2)
            Me.SplitContainer1.Size = New System.Drawing.Size(1400, 740)
            Me.SplitContainer1.SplitterDistance = 150
            Me.SplitContainer1.TabIndex = 1
            
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
            Me.GroupBox3.Controls.Add(Me.btnNewRequest)
            Me.GroupBox3.Dock = System.Windows.Forms.DockStyle.Fill
            Me.GroupBox3.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.GroupBox3.Location = New System.Drawing.Point(0, 0)
            Me.GroupBox3.Name = "GroupBox3"
            Me.GroupBox3.Padding = New System.Windows.Forms.Padding(10)
            Me.GroupBox3.Size = New System.Drawing.Size(1400, 150)
            Me.GroupBox3.TabIndex = 0
            Me.GroupBox3.TabStop = False
            Me.GroupBox3.Text = "New Sub-Recipe Manufacturing Request"
            
            ' Label2
            Me.Label2.AutoSize = True
            Me.Label2.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.Label2.Location = New System.Drawing.Point(15, 30)
            Me.Label2.Name = "Label2"
            Me.Label2.Size = New System.Drawing.Size(42, 15)
            Me.Label2.TabIndex = 0
            Me.Label2.Text = "Baker:"
            
            ' cmbBaker
            Me.cmbBaker.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
            Me.cmbBaker.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.cmbBaker.FormattingEnabled = True
            Me.cmbBaker.Location = New System.Drawing.Point(15, 50)
            Me.cmbBaker.Name = "cmbBaker"
            Me.cmbBaker.Size = New System.Drawing.Size(200, 23)
            Me.cmbBaker.TabIndex = 1
            
            ' Label3
            Me.Label3.AutoSize = True
            Me.Label3.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.Label3.Location = New System.Drawing.Point(230, 30)
            Me.Label3.Name = "Label3"
            Me.Label3.Size = New System.Drawing.Size(70, 15)
            Me.Label3.TabIndex = 2
            Me.Label3.Text = "Order Date:"
            
            ' dtpOrderDate
            Me.dtpOrderDate.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.dtpOrderDate.Format = System.Windows.Forms.DateTimePickerFormat.Short
            Me.dtpOrderDate.Location = New System.Drawing.Point(230, 50)
            Me.dtpOrderDate.Name = "dtpOrderDate"
            Me.dtpOrderDate.Size = New System.Drawing.Size(120, 23)
            Me.dtpOrderDate.TabIndex = 3
            
            ' Label4
            Me.Label4.AutoSize = True
            Me.Label4.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.Label4.Location = New System.Drawing.Point(370, 30)
            Me.Label4.Name = "Label4"
            Me.Label4.Size = New System.Drawing.Size(88, 15)
            Me.Label4.TabIndex = 4
            Me.Label4.Text = "Required Date:"
            
            ' dtpRequiredDate
            Me.dtpRequiredDate.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.dtpRequiredDate.Format = System.Windows.Forms.DateTimePickerFormat.Short
            Me.dtpRequiredDate.Location = New System.Drawing.Point(370, 50)
            Me.dtpRequiredDate.Name = "dtpRequiredDate"
            Me.dtpRequiredDate.Size = New System.Drawing.Size(120, 23)
            Me.dtpRequiredDate.TabIndex = 5
            
            ' chkUrgent
            Me.chkUrgent.AutoSize = True
            Me.chkUrgent.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.chkUrgent.Location = New System.Drawing.Point(510, 52)
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
            Me.txtNotes.Size = New System.Drawing.Size(475, 23)
            Me.txtNotes.TabIndex = 8
            
            ' btnNewRequest
            Me.btnNewRequest.BackColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(140, Byte), Integer), CType(CType(0, Byte), Integer))
            Me.btnNewRequest.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnNewRequest.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.btnNewRequest.ForeColor = System.Drawing.Color.White
            Me.btnNewRequest.Location = New System.Drawing.Point(510, 95)
            Me.btnNewRequest.Name = "btnNewRequest"
            Me.btnNewRequest.Size = New System.Drawing.Size(150, 35)
            Me.btnNewRequest.TabIndex = 9
            Me.btnNewRequest.Text = "Create Request"
            Me.btnNewRequest.UseVisualStyleBackColor = False
            
            ' GroupBox2
            Me.GroupBox2.Controls.Add(Me.Label5)
            Me.GroupBox2.Controls.Add(Me.txtRequestNumber)
            Me.GroupBox2.Controls.Add(Me.lblBakerName)
            Me.GroupBox2.Controls.Add(Me.lblTotalSubRecipes)
            Me.GroupBox2.Controls.Add(Me.lblTotalQuantity)
            Me.GroupBox2.Controls.Add(Me.dgvSubRecipeLines)
            Me.GroupBox2.Controls.Add(Me.grpSubRecipes)
            Me.GroupBox2.Controls.Add(Me.btnPost)
            Me.GroupBox2.Controls.Add(Me.GroupBox1)
            Me.GroupBox2.Dock = System.Windows.Forms.DockStyle.Fill
            Me.GroupBox2.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.GroupBox2.Location = New System.Drawing.Point(0, 0)
            Me.GroupBox2.Name = "GroupBox2"
            Me.GroupBox2.Padding = New System.Windows.Forms.Padding(10)
            Me.GroupBox2.Size = New System.Drawing.Size(1400, 586)
            Me.GroupBox2.TabIndex = 1
            Me.GroupBox2.TabStop = False
            Me.GroupBox2.Text = "Request Details"
            
            ' GroupBox1
            Me.GroupBox1.Controls.Add(Me.lblDraftCount)
            Me.GroupBox1.Controls.Add(Me.dgvDraftRequests)
            Me.GroupBox1.Dock = System.Windows.Forms.DockStyle.Left
            Me.GroupBox1.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
            Me.GroupBox1.Location = New System.Drawing.Point(10, 26)
            Me.GroupBox1.Name = "GroupBox1"
            Me.GroupBox1.Size = New System.Drawing.Size(450, 550)
            Me.GroupBox1.TabIndex = 0
            Me.GroupBox1.TabStop = False
            Me.GroupBox1.Text = "Draft Requests"
            
            ' lblDraftCount
            Me.lblDraftCount.AutoSize = True
            Me.lblDraftCount.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.lblDraftCount.Location = New System.Drawing.Point(10, 20)
            Me.lblDraftCount.Name = "lblDraftCount"
            Me.lblDraftCount.Size = New System.Drawing.Size(100, 15)
            Me.lblDraftCount.TabIndex = 0
            Me.lblDraftCount.Text = "Draft Requests: 0"
            
            ' dgvDraftRequests
            Me.dgvDraftRequests.AllowUserToAddRows = False
            Me.dgvDraftRequests.AllowUserToDeleteRows = False
            Me.dgvDraftRequests.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.dgvDraftRequests.BackgroundColor = System.Drawing.Color.White
            Me.dgvDraftRequests.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
            Me.dgvDraftRequests.Location = New System.Drawing.Point(10, 40)
            Me.dgvDraftRequests.Name = "dgvDraftRequests"
            Me.dgvDraftRequests.ReadOnly = True
            Me.dgvDraftRequests.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
            Me.dgvDraftRequests.Size = New System.Drawing.Size(430, 500)
            Me.dgvDraftRequests.TabIndex = 1
            
            ' Label5
            Me.Label5.AutoSize = True
            Me.Label5.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.Label5.Location = New System.Drawing.Point(475, 30)
            Me.Label5.Name = "Label5"
            Me.Label5.Size = New System.Drawing.Size(68, 15)
            Me.Label5.TabIndex = 0
            Me.Label5.Text = "Request #:"
            
            ' txtRequestNumber
            Me.txtRequestNumber.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
            Me.txtRequestNumber.Location = New System.Drawing.Point(550, 27)
            Me.txtRequestNumber.Name = "txtRequestNumber"
            Me.txtRequestNumber.ReadOnly = True
            Me.txtRequestNumber.Size = New System.Drawing.Size(200, 23)
            Me.txtRequestNumber.TabIndex = 1
            
            ' lblBakerName
            Me.lblBakerName.AutoSize = True
            Me.lblBakerName.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.lblBakerName.Location = New System.Drawing.Point(770, 30)
            Me.lblBakerName.Name = "lblBakerName"
            Me.lblBakerName.Size = New System.Drawing.Size(60, 15)
            Me.lblBakerName.TabIndex = 2
            Me.lblBakerName.Text = "Baker: -"
            
            ' lblTotalSubRecipes
            Me.lblTotalSubRecipes.AutoSize = True
            Me.lblTotalSubRecipes.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.lblTotalSubRecipes.Location = New System.Drawing.Point(950, 30)
            Me.lblTotalSubRecipes.Name = "lblTotalSubRecipes"
            Me.lblTotalSubRecipes.Size = New System.Drawing.Size(90, 15)
            Me.lblTotalSubRecipes.TabIndex = 3
            Me.lblTotalSubRecipes.Text = "Sub-Recipes: 0"
            
            ' lblTotalQuantity
            Me.lblTotalQuantity.AutoSize = True
            Me.lblTotalQuantity.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.lblTotalQuantity.Location = New System.Drawing.Point(1080, 30)
            Me.lblTotalQuantity.Name = "lblTotalQuantity"
            Me.lblTotalQuantity.Size = New System.Drawing.Size(75, 15)
            Me.lblTotalQuantity.TabIndex = 4
            Me.lblTotalQuantity.Text = "Total Qty: 0"
            
            ' dgvSubRecipeLines
            Me.dgvSubRecipeLines.AllowUserToAddRows = False
            Me.dgvSubRecipeLines.AllowUserToDeleteRows = False
            Me.dgvSubRecipeLines.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.dgvSubRecipeLines.BackgroundColor = System.Drawing.Color.White
            Me.dgvSubRecipeLines.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
            Me.dgvSubRecipeLines.Location = New System.Drawing.Point(475, 60)
            Me.dgvSubRecipeLines.Name = "dgvSubRecipeLines"
            Me.dgvSubRecipeLines.ReadOnly = True
            Me.dgvSubRecipeLines.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
            Me.dgvSubRecipeLines.Size = New System.Drawing.Size(450, 300)
            Me.dgvSubRecipeLines.TabIndex = 5
            
            ' grpSubRecipes
            Me.grpSubRecipes.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.grpSubRecipes.Controls.Add(Me.Label6)
            Me.grpSubRecipes.Controls.Add(Me.cmbSubRecipe)
            Me.grpSubRecipes.Controls.Add(Me.Label7)
            Me.grpSubRecipes.Controls.Add(Me.nudQuantity)
            Me.grpSubRecipes.Controls.Add(Me.btnAddSubRecipe)
            Me.grpSubRecipes.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
            Me.grpSubRecipes.Location = New System.Drawing.Point(940, 60)
            Me.grpSubRecipes.Name = "grpSubRecipes"
            Me.grpSubRecipes.Size = New System.Drawing.Size(450, 180)
            Me.grpSubRecipes.TabIndex = 6
            Me.grpSubRecipes.TabStop = False
            Me.grpSubRecipes.Text = "Add Sub-Recipes"
            
            ' Label6
            Me.Label6.AutoSize = True
            Me.Label6.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.Label6.Location = New System.Drawing.Point(15, 25)
            Me.Label6.Name = "Label6"
            Me.Label6.Size = New System.Drawing.Size(70, 15)
            Me.Label6.TabIndex = 0
            Me.Label6.Text = "Sub-Recipe:"
            
            ' cmbSubRecipe
            Me.cmbSubRecipe.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
            Me.cmbSubRecipe.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.cmbSubRecipe.FormattingEnabled = True
            Me.cmbSubRecipe.Location = New System.Drawing.Point(15, 45)
            Me.cmbSubRecipe.Name = "cmbSubRecipe"
            Me.cmbSubRecipe.Size = New System.Drawing.Size(420, 23)
            Me.cmbSubRecipe.TabIndex = 1
            
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
            
            ' btnAddSubRecipe
            Me.btnAddSubRecipe.BackColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(140, Byte), Integer), CType(CType(0, Byte), Integer))
            Me.btnAddSubRecipe.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnAddSubRecipe.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
            Me.btnAddSubRecipe.ForeColor = System.Drawing.Color.White
            Me.btnAddSubRecipe.Location = New System.Drawing.Point(15, 135)
            Me.btnAddSubRecipe.Name = "btnAddSubRecipe"
            Me.btnAddSubRecipe.Size = New System.Drawing.Size(140, 30)
            Me.btnAddSubRecipe.TabIndex = 4
            Me.btnAddSubRecipe.Text = "Add Sub-Recipe"
            Me.btnAddSubRecipe.UseVisualStyleBackColor = False
            
            ' btnPost
            Me.btnPost.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.btnPost.BackColor = System.Drawing.Color.FromArgb(CType(CType(220, Byte), Integer), CType(CType(53, Byte), Integer), CType(CType(69, Byte), Integer))
            Me.btnPost.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnPost.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
            Me.btnPost.ForeColor = System.Drawing.Color.White
            Me.btnPost.Location = New System.Drawing.Point(1200, 510)
            Me.btnPost.Name = "btnPost"
            Me.btnPost.Size = New System.Drawing.Size(180, 50)
            Me.btnPost.TabIndex = 7
            Me.btnPost.Text = "📤 Post to Baker"
            Me.btnPost.UseVisualStyleBackColor = False
            
            ' SubRecipeManufacturingRequestForm
            Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
            Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
            Me.ClientSize = New System.Drawing.Size(1400, 800)
            Me.Controls.Add(Me.SplitContainer1)
            Me.Controls.Add(Me.Panel1)
            Me.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.Name = "SubRecipeManufacturingRequestForm"
            Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
            Me.Text = "Sub-Recipe Manufacturing Request"
            Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
            Me.Panel1.ResumeLayout(False)
            Me.Panel1.PerformLayout()
            Me.SplitContainer1.Panel1.ResumeLayout(False)
            Me.SplitContainer1.Panel2.ResumeLayout(False)
            CType(Me.SplitContainer1, System.ComponentModel.ISupportInitialize).EndInit()
            Me.SplitContainer1.ResumeLayout(False)
            Me.GroupBox3.ResumeLayout(False)
            Me.GroupBox3.PerformLayout()
            Me.GroupBox1.ResumeLayout(False)
            Me.GroupBox1.PerformLayout()
            CType(Me.dgvDraftRequests, System.ComponentModel.ISupportInitialize).EndInit()
            Me.GroupBox2.ResumeLayout(False)
            Me.GroupBox2.PerformLayout()
            Me.grpSubRecipes.ResumeLayout(False)
            Me.grpSubRecipes.PerformLayout()
            CType(Me.nudQuantity, System.ComponentModel.ISupportInitialize).EndInit()
            CType(Me.dgvSubRecipeLines, System.ComponentModel.ISupportInitialize).EndInit()
            Me.ResumeLayout(False)
        End Sub

        Friend WithEvents Panel1 As Panel
        Friend WithEvents Label1 As Label
        Friend WithEvents btnClose As Button
        Friend WithEvents SplitContainer1 As SplitContainer
        Friend WithEvents GroupBox1 As GroupBox
        Friend WithEvents dgvDraftRequests As DataGridView
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
        Friend WithEvents btnNewRequest As Button
        Friend WithEvents Label5 As Label
        Friend WithEvents txtRequestNumber As TextBox
        Friend WithEvents lblBakerName As Label
        Friend WithEvents lblTotalSubRecipes As Label
        Friend WithEvents lblTotalQuantity As Label
        Friend WithEvents dgvSubRecipeLines As DataGridView
        Friend WithEvents grpSubRecipes As GroupBox
        Friend WithEvents Label6 As Label
        Friend WithEvents cmbSubRecipe As ComboBox
        Friend WithEvents Label7 As Label
        Friend WithEvents nudQuantity As NumericUpDown
        Friend WithEvents btnAddSubRecipe As Button
        Friend WithEvents btnPost As Button
    End Class
End Namespace
