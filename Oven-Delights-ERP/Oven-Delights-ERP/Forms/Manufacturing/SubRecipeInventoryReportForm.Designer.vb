Namespace Manufacturing
    <Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
    Partial Class SubRecipeInventoryReportForm
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
            Me.Panel1 = New System.Windows.Forms.Panel()
            Me.Label1 = New System.Windows.Forms.Label()
            Me.btnClose = New System.Windows.Forms.Button()
            Me.Panel2 = New System.Windows.Forms.Panel()
            Me.GroupBox1 = New System.Windows.Forms.GroupBox()
            Me.Label2 = New System.Windows.Forms.Label()
            Me.cmbBranch = New System.Windows.Forms.ComboBox()
            Me.Label3 = New System.Windows.Forms.Label()
            Me.cmbSubRecipe = New System.Windows.Forms.ComboBox()
            Me.Label4 = New System.Windows.Forms.Label()
            Me.cmbFreshness = New System.Windows.Forms.ComboBox()
            Me.btnRefresh = New System.Windows.Forms.Button()
            Me.btnExport = New System.Windows.Forms.Button()
            Me.dgvInventory = New System.Windows.Forms.DataGridView()
            Me.Panel3 = New System.Windows.Forms.Panel()
            Me.lblTotalBatches = New System.Windows.Forms.Label()
            Me.lblTotalQuantity = New System.Windows.Forms.Label()
            Me.GroupBox2 = New System.Windows.Forms.GroupBox()
            Me.lblLegend = New System.Windows.Forms.Label()
            Me.Panel1.SuspendLayout()
            Me.Panel2.SuspendLayout()
            Me.GroupBox1.SuspendLayout()
            CType(Me.dgvInventory, System.ComponentModel.ISupportInitialize).BeginInit()
            Me.Panel3.SuspendLayout()
            Me.GroupBox2.SuspendLayout()
            Me.SuspendLayout()
            '
            'Panel1
            '
            Me.Panel1.BackColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(73, Byte), Integer), CType(CType(94, Byte), Integer))
            Me.Panel1.Controls.Add(Me.Label1)
            Me.Panel1.Controls.Add(Me.btnClose)
            Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
            Me.Panel1.Location = New System.Drawing.Point(0, 0)
            Me.Panel1.Name = "Panel1"
            Me.Panel1.Size = New System.Drawing.Size(1400, 60)
            Me.Panel1.TabIndex = 0
            '
            'Label1
            '
            Me.Label1.AutoSize = True
            Me.Label1.Font = New System.Drawing.Font("Segoe UI", 16.0!, System.Drawing.FontStyle.Bold)
            Me.Label1.ForeColor = System.Drawing.Color.White
            Me.Label1.Location = New System.Drawing.Point(15, 15)
            Me.Label1.Name = "Label1"
            Me.Label1.Size = New System.Drawing.Size(350, 30)
            Me.Label1.TabIndex = 0
            Me.Label1.Text = "📊 Sub-Recipe Inventory Report"
            '
            'btnClose
            '
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
            '
            'Panel2
            '
            Me.Panel2.Controls.Add(Me.GroupBox1)
            Me.Panel2.Dock = System.Windows.Forms.DockStyle.Top
            Me.Panel2.Location = New System.Drawing.Point(0, 60)
            Me.Panel2.Name = "Panel2"
            Me.Panel2.Padding = New System.Windows.Forms.Padding(10)
            Me.Panel2.Size = New System.Drawing.Size(1400, 100)
            Me.Panel2.TabIndex = 1
            '
            'GroupBox1
            '
            Me.GroupBox1.Controls.Add(Me.Label2)
            Me.GroupBox1.Controls.Add(Me.cmbBranch)
            Me.GroupBox1.Controls.Add(Me.Label3)
            Me.GroupBox1.Controls.Add(Me.cmbSubRecipe)
            Me.GroupBox1.Controls.Add(Me.Label4)
            Me.GroupBox1.Controls.Add(Me.cmbFreshness)
            Me.GroupBox1.Controls.Add(Me.btnRefresh)
            Me.GroupBox1.Controls.Add(Me.btnExport)
            Me.GroupBox1.Dock = System.Windows.Forms.DockStyle.Fill
            Me.GroupBox1.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.GroupBox1.Location = New System.Drawing.Point(10, 10)
            Me.GroupBox1.Name = "GroupBox1"
            Me.GroupBox1.Size = New System.Drawing.Size(1380, 80)
            Me.GroupBox1.TabIndex = 0
            Me.GroupBox1.TabStop = False
            Me.GroupBox1.Text = "Filters"
            '
            'Label2
            '
            Me.Label2.AutoSize = True
            Me.Label2.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.Label2.Location = New System.Drawing.Point(15, 25)
            Me.Label2.Name = "Label2"
            Me.Label2.Size = New System.Drawing.Size(48, 15)
            Me.Label2.TabIndex = 0
            Me.Label2.Text = "Branch:"
            '
            'cmbBranch
            '
            Me.cmbBranch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
            Me.cmbBranch.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.cmbBranch.FormattingEnabled = True
            Me.cmbBranch.Location = New System.Drawing.Point(15, 45)
            Me.cmbBranch.Name = "cmbBranch"
            Me.cmbBranch.Size = New System.Drawing.Size(200, 23)
            Me.cmbBranch.TabIndex = 1
            '
            'Label3
            '
            Me.Label3.AutoSize = True
            Me.Label3.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.Label3.Location = New System.Drawing.Point(230, 25)
            Me.Label3.Name = "Label3"
            Me.Label3.Size = New System.Drawing.Size(70, 15)
            Me.Label3.TabIndex = 2
            Me.Label3.Text = "Sub-Recipe:"
            '
            'cmbSubRecipe
            '
            Me.cmbSubRecipe.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
            Me.cmbSubRecipe.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.cmbSubRecipe.FormattingEnabled = True
            Me.cmbSubRecipe.Location = New System.Drawing.Point(230, 45)
            Me.cmbSubRecipe.Name = "cmbSubRecipe"
            Me.cmbSubRecipe.Size = New System.Drawing.Size(300, 23)
            Me.cmbSubRecipe.TabIndex = 3
            '
            'Label4
            '
            Me.Label4.AutoSize = True
            Me.Label4.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.Label4.Location = New System.Drawing.Point(545, 25)
            Me.Label4.Name = "Label4"
            Me.Label4.Size = New System.Drawing.Size(63, 15)
            Me.Label4.TabIndex = 4
            Me.Label4.Text = "Freshness:"
            '
            'cmbFreshness
            '
            Me.cmbFreshness.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
            Me.cmbFreshness.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.cmbFreshness.FormattingEnabled = True
            Me.cmbFreshness.Location = New System.Drawing.Point(545, 45)
            Me.cmbFreshness.Name = "cmbFreshness"
            Me.cmbFreshness.Size = New System.Drawing.Size(150, 23)
            Me.cmbFreshness.TabIndex = 5
            '
            'btnRefresh
            '
            Me.btnRefresh.BackColor = System.Drawing.Color.FromArgb(CType(CType(52, Byte), Integer), CType(CType(152, Byte), Integer), CType(CType(219, Byte), Integer))
            Me.btnRefresh.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnRefresh.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
            Me.btnRefresh.ForeColor = System.Drawing.Color.White
            Me.btnRefresh.Location = New System.Drawing.Point(710, 40)
            Me.btnRefresh.Name = "btnRefresh"
            Me.btnRefresh.Size = New System.Drawing.Size(100, 30)
            Me.btnRefresh.TabIndex = 6
            Me.btnRefresh.Text = "🔄 Refresh"
            Me.btnRefresh.UseVisualStyleBackColor = False
            '
            'btnExport
            '
            Me.btnExport.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.btnExport.BackColor = System.Drawing.Color.FromArgb(CType(CType(46, Byte), Integer), CType(CType(204, Byte), Integer), CType(CType(113, Byte), Integer))
            Me.btnExport.FlatStyle = System.Windows.Forms.FlatStyle.Flat
            Me.btnExport.Font = New System.Drawing.Font("Segoe UI", 9.0!, System.Drawing.FontStyle.Bold)
            Me.btnExport.ForeColor = System.Drawing.Color.White
            Me.btnExport.Location = New System.Drawing.Point(1260, 40)
            Me.btnExport.Name = "btnExport"
            Me.btnExport.Size = New System.Drawing.Size(100, 30)
            Me.btnExport.TabIndex = 7
            Me.btnExport.Text = "📤 Export"
            Me.btnExport.UseVisualStyleBackColor = False
            '
            'dgvInventory
            '
            Me.dgvInventory.AllowUserToAddRows = False
            Me.dgvInventory.AllowUserToDeleteRows = False
            Me.dgvInventory.BackgroundColor = System.Drawing.Color.White
            Me.dgvInventory.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
            Me.dgvInventory.Dock = System.Windows.Forms.DockStyle.Fill
            Me.dgvInventory.Location = New System.Drawing.Point(0, 160)
            Me.dgvInventory.Name = "dgvInventory"
            Me.dgvInventory.ReadOnly = True
            Me.dgvInventory.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
            Me.dgvInventory.Size = New System.Drawing.Size(1400, 490)
            Me.dgvInventory.TabIndex = 2
            '
            'Panel3
            '
            Me.Panel3.Controls.Add(Me.lblTotalBatches)
            Me.Panel3.Controls.Add(Me.lblTotalQuantity)
            Me.Panel3.Controls.Add(Me.GroupBox2)
            Me.Panel3.Dock = System.Windows.Forms.DockStyle.Bottom
            Me.Panel3.Location = New System.Drawing.Point(0, 650)
            Me.Panel3.Name = "Panel3"
            Me.Panel3.Padding = New System.Windows.Forms.Padding(10)
            Me.Panel3.Size = New System.Drawing.Size(1400, 150)
            Me.Panel3.TabIndex = 3
            '
            'lblTotalBatches
            '
            Me.lblTotalBatches.AutoSize = True
            Me.lblTotalBatches.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
            Me.lblTotalBatches.Location = New System.Drawing.Point(15, 15)
            Me.lblTotalBatches.Name = "lblTotalBatches"
            Me.lblTotalBatches.Size = New System.Drawing.Size(120, 20)
            Me.lblTotalBatches.TabIndex = 0
            Me.lblTotalBatches.Text = "Total Batches: 0"
            '
            'lblTotalQuantity
            '
            Me.lblTotalQuantity.AutoSize = True
            Me.lblTotalQuantity.Font = New System.Drawing.Font("Segoe UI", 11.0!, System.Drawing.FontStyle.Bold)
            Me.lblTotalQuantity.Location = New System.Drawing.Point(15, 40)
            Me.lblTotalQuantity.Name = "lblTotalQuantity"
            Me.lblTotalQuantity.Size = New System.Drawing.Size(130, 20)
            Me.lblTotalQuantity.TabIndex = 1
            Me.lblTotalQuantity.Text = "Total Quantity: 0"
            '
            'GroupBox2
            '
            Me.GroupBox2.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.GroupBox2.Controls.Add(Me.lblLegend)
            Me.GroupBox2.Font = New System.Drawing.Font("Segoe UI", 10.0!, System.Drawing.FontStyle.Bold)
            Me.GroupBox2.Location = New System.Drawing.Point(15, 70)
            Me.GroupBox2.Name = "GroupBox2"
            Me.GroupBox2.Size = New System.Drawing.Size(1370, 70)
            Me.GroupBox2.TabIndex = 2
            Me.GroupBox2.TabStop = False
            Me.GroupBox2.Text = "Freshness Legend"
            '
            'lblLegend
            '
            Me.lblLegend.AutoSize = True
            Me.lblLegend.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.lblLegend.Location = New System.Drawing.Point(10, 25)
            Me.lblLegend.Name = "lblLegend"
            Me.lblLegend.Size = New System.Drawing.Size(800, 30)
            Me.lblLegend.TabIndex = 0
            Me.lblLegend.Text = "🟢 Very Fresh (0-24h)  |  🟢 Fresh (24-48h)  |  🟡 Good (48-72h)  |  🟠 Aging (3-5 days)  |  🔴 Old (5-7 days)  |  ⚫ Very Old (7+ days)"
            '
            'SubRecipeInventoryReportForm
            '
            Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 15.0!)
            Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
            Me.ClientSize = New System.Drawing.Size(1400, 800)
            Me.Controls.Add(Me.dgvInventory)
            Me.Controls.Add(Me.Panel3)
            Me.Controls.Add(Me.Panel2)
            Me.Controls.Add(Me.Panel1)
            Me.Font = New System.Drawing.Font("Segoe UI", 9.0!)
            Me.Name = "SubRecipeInventoryReportForm"
            Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
            Me.Text = "Sub-Recipe Inventory Report"
            Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
            Me.Panel1.ResumeLayout(False)
            Me.Panel1.PerformLayout()
            Me.Panel2.ResumeLayout(False)
            Me.GroupBox1.ResumeLayout(False)
            Me.GroupBox1.PerformLayout()
            CType(Me.dgvInventory, System.ComponentModel.ISupportInitialize).EndInit()
            Me.Panel3.ResumeLayout(False)
            Me.Panel3.PerformLayout()
            Me.GroupBox2.ResumeLayout(False)
            Me.GroupBox2.PerformLayout()
            Me.ResumeLayout(False)
        End Sub

        Friend WithEvents Panel1 As Panel
        Friend WithEvents Label1 As Label
        Friend WithEvents btnClose As Button
        Friend WithEvents Panel2 As Panel
        Friend WithEvents GroupBox1 As GroupBox
        Friend WithEvents Label2 As Label
        Friend WithEvents cmbBranch As ComboBox
        Friend WithEvents Label3 As Label
        Friend WithEvents cmbSubRecipe As ComboBox
        Friend WithEvents Label4 As Label
        Friend WithEvents cmbFreshness As ComboBox
        Friend WithEvents btnRefresh As Button
        Friend WithEvents btnExport As Button
        Friend WithEvents dgvInventory As DataGridView
        Friend WithEvents Panel3 As Panel
        Friend WithEvents lblTotalBatches As Label
        Friend WithEvents lblTotalQuantity As Label
        Friend WithEvents GroupBox2 As GroupBox
        Friend WithEvents lblLegend As Label
    End Class
End Namespace
