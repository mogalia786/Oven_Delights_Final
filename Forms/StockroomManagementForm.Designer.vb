<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class StockroomManagementForm
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
        Me.TabControl1 = New System.Windows.Forms.TabControl()
        Me.TabPage1 = New System.Windows.Forms.TabPage()
        Me.TabPage2 = New System.Windows.Forms.TabPage()
        Me.TabPage3 = New System.Windows.Forms.TabPage()
        Me.TabPage4 = New System.Windows.Forms.TabPage()
        Me.dgvRawMaterials = New System.Windows.Forms.DataGridView()
        Me.txtSearchMaterials = New System.Windows.Forms.TextBox()
        Me.btnAddMaterial = New System.Windows.Forms.Button()
        Me.btnEditMaterial = New System.Windows.Forms.Button()
        Me.lblTotalMaterials = New System.Windows.Forms.Label()
        Me.dgvSuppliers = New System.Windows.Forms.DataGridView()
        Me.txtSearchSuppliers = New System.Windows.Forms.TextBox()
        Me.btnAddSupplier = New System.Windows.Forms.Button()
        Me.btnEditSupplier = New System.Windows.Forms.Button()
        Me.lblTotalSuppliers = New System.Windows.Forms.Label()
        Me.dgvPurchaseOrders = New System.Windows.Forms.DataGridView()
        Me.btnCreatePO = New System.Windows.Forms.Button()
        Me.lblTotalOrders = New System.Windows.Forms.Label()
        Me.dgvLowStock = New System.Windows.Forms.DataGridView()
        Me.lblLowStockCount = New System.Windows.Forms.Label()
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.Label1 = New System.Windows.Forms.Label()
        
        Me.TabControl1.SuspendLayout()
        Me.TabPage1.SuspendLayout()
        Me.TabPage2.SuspendLayout()
        Me.TabPage3.SuspendLayout()
        Me.TabPage4.SuspendLayout()
        CType(Me.dgvRawMaterials, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dgvSuppliers, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dgvPurchaseOrders, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dgvLowStock, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        
        ' TabControl1
        Me.TabControl1.Controls.Add(Me.TabPage1)
        Me.TabControl1.Controls.Add(Me.TabPage2)
        Me.TabControl1.Controls.Add(Me.TabPage3)
        Me.TabControl1.Controls.Add(Me.TabPage4)
        Me.TabControl1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TabControl1.Location = New System.Drawing.Point(0, 0)
        Me.TabControl1.Name = "TabControl1"
        Me.TabControl1.SelectedIndex = 0
        Me.TabControl1.Size = New System.Drawing.Size(800, 450)
        Me.TabControl1.TabIndex = 0
        
        ' TabPage1 - Raw Materials
        Me.TabPage1.Controls.Add(Me.dgvRawMaterials)
        Me.TabPage1.Controls.Add(Me.txtSearchMaterials)
        Me.TabPage1.Controls.Add(Me.btnAddMaterial)
        Me.TabPage1.Controls.Add(Me.btnEditMaterial)
        Me.TabPage1.Controls.Add(Me.lblTotalMaterials)
        Me.TabPage1.Controls.Add(Me.Label1)
        Me.TabPage1.Location = New System.Drawing.Point(4, 22)
        Me.TabPage1.Name = "TabPage1"
        Me.TabPage1.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage1.Size = New System.Drawing.Size(792, 424)
        Me.TabPage1.TabIndex = 0
        Me.TabPage1.Text = "Raw Materials"
        Me.TabPage1.UseVisualStyleBackColor = True
        
        ' dgvRawMaterials
        Me.dgvRawMaterials.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvRawMaterials.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvRawMaterials.Location = New System.Drawing.Point(6, 60)
        Me.dgvRawMaterials.Name = "dgvRawMaterials"
        Me.dgvRawMaterials.Size = New System.Drawing.Size(780, 320)
        Me.dgvRawMaterials.TabIndex = 0
        
        ' txtSearchMaterials
        Me.txtSearchMaterials.Location = New System.Drawing.Point(60, 15)
        Me.txtSearchMaterials.Name = "txtSearchMaterials"
        Me.txtSearchMaterials.Size = New System.Drawing.Size(200, 20)
        Me.txtSearchMaterials.TabIndex = 1
        
        ' btnAddMaterial
        Me.btnAddMaterial.Location = New System.Drawing.Point(600, 13)
        Me.btnAddMaterial.Name = "btnAddMaterial"
        Me.btnAddMaterial.Size = New System.Drawing.Size(75, 23)
        Me.btnAddMaterial.TabIndex = 2
        Me.btnAddMaterial.Text = "Add"
        Me.btnAddMaterial.UseVisualStyleBackColor = True
        
        ' btnEditMaterial
        Me.btnEditMaterial.Location = New System.Drawing.Point(681, 13)
        Me.btnEditMaterial.Name = "btnEditMaterial"
        Me.btnEditMaterial.Size = New System.Drawing.Size(75, 23)
        Me.btnEditMaterial.TabIndex = 3
        Me.btnEditMaterial.Text = "Edit"
        Me.btnEditMaterial.UseVisualStyleBackColor = True
        
        ' lblTotalMaterials
        Me.lblTotalMaterials.AutoSize = True
        Me.lblTotalMaterials.Location = New System.Drawing.Point(6, 395)
        Me.lblTotalMaterials.Name = "lblTotalMaterials"
        Me.lblTotalMaterials.Size = New System.Drawing.Size(80, 13)
        Me.lblTotalMaterials.TabIndex = 4
        
        ' Label1
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(6, 18)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(44, 13)
        Me.Label1.TabIndex = 5
        Me.Label1.Text = "Search:"
        
        ' TabPage2 - Suppliers
        Me.TabPage2.Controls.Add(Me.dgvSuppliers)
        Me.TabPage2.Controls.Add(Me.txtSearchSuppliers)
        Me.TabPage2.Controls.Add(Me.btnAddSupplier)
        Me.TabPage2.Controls.Add(Me.btnEditSupplier)
        Me.TabPage2.Controls.Add(Me.lblTotalSuppliers)
        Me.TabPage2.Location = New System.Drawing.Point(4, 22)
        Me.TabPage2.Name = "TabPage2"
        Me.TabPage2.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage2.Size = New System.Drawing.Size(792, 424)
        Me.TabPage2.TabIndex = 1
        Me.TabPage2.Text = "Suppliers"
        Me.TabPage2.UseVisualStyleBackColor = True
        
        ' dgvSuppliers
        Me.dgvSuppliers.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvSuppliers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvSuppliers.Location = New System.Drawing.Point(6, 50)
        Me.dgvSuppliers.Name = "dgvSuppliers"
        Me.dgvSuppliers.Size = New System.Drawing.Size(780, 330)
        Me.dgvSuppliers.TabIndex = 0
        
        ' txtSearchSuppliers
        Me.txtSearchSuppliers.Location = New System.Drawing.Point(6, 15)
        Me.txtSearchSuppliers.Name = "txtSearchSuppliers"
        Me.txtSearchSuppliers.Size = New System.Drawing.Size(200, 20)
        Me.txtSearchSuppliers.TabIndex = 1
        
        ' btnAddSupplier
        Me.btnAddSupplier.Location = New System.Drawing.Point(600, 13)
        Me.btnAddSupplier.Name = "btnAddSupplier"
        Me.btnAddSupplier.Size = New System.Drawing.Size(75, 23)
        Me.btnAddSupplier.TabIndex = 2
        Me.btnAddSupplier.Text = "Add"
        Me.btnAddSupplier.UseVisualStyleBackColor = True
        
        ' btnEditSupplier
        Me.btnEditSupplier.Location = New System.Drawing.Point(681, 13)
        Me.btnEditSupplier.Name = "btnEditSupplier"
        Me.btnEditSupplier.Size = New System.Drawing.Size(75, 23)
        Me.btnEditSupplier.TabIndex = 3
        Me.btnEditSupplier.Text = "Edit"
        Me.btnEditSupplier.UseVisualStyleBackColor = True
        
        ' lblTotalSuppliers
        Me.lblTotalSuppliers.AutoSize = True
        Me.lblTotalSuppliers.Location = New System.Drawing.Point(6, 395)
        Me.lblTotalSuppliers.Name = "lblTotalSuppliers"
        Me.lblTotalSuppliers.Size = New System.Drawing.Size(80, 13)
        Me.lblTotalSuppliers.TabIndex = 4
        
        ' TabPage3 - Purchase Orders
        Me.TabPage3.Controls.Add(Me.dgvPurchaseOrders)
        Me.TabPage3.Controls.Add(Me.btnCreatePO)
        Me.TabPage3.Controls.Add(Me.lblTotalOrders)
        Me.TabPage3.Location = New System.Drawing.Point(4, 22)
        Me.TabPage3.Name = "TabPage3"
        Me.TabPage3.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage3.Size = New System.Drawing.Size(792, 424)
        Me.TabPage3.TabIndex = 2
        Me.TabPage3.Text = "Purchase Orders"
        Me.TabPage3.UseVisualStyleBackColor = True
        
        ' dgvPurchaseOrders
        Me.dgvPurchaseOrders.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgvPurchaseOrders.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvPurchaseOrders.Location = New System.Drawing.Point(6, 50)
        Me.dgvPurchaseOrders.Name = "dgvPurchaseOrders"
        Me.dgvPurchaseOrders.Size = New System.Drawing.Size(780, 330)
        Me.dgvPurchaseOrders.TabIndex = 0
        
        ' btnCreatePO
        Me.btnCreatePO.Location = New System.Drawing.Point(6, 15)
        Me.btnCreatePO.Name = "btnCreatePO"
        Me.btnCreatePO.Size = New System.Drawing.Size(120, 23)
        Me.btnCreatePO.TabIndex = 1
        Me.btnCreatePO.UseVisualStyleBackColor = True
        
        ' lblTotalOrders
        Me.lblTotalOrders.AutoSize = True
        Me.lblTotalOrders.Location = New System.Drawing.Point(6, 395)
        Me.lblTotalOrders.Name = "lblTotalOrders"
        Me.lblTotalOrders.TabIndex = 2
        
        ' TabPage4 - Low Stock
        Me.TabPage4.Controls.Add(Me.dgvLowStock)
        Me.TabPage4.Controls.Add(Me.lblLowStockCount)
        Me.TabPage4.Location = New System.Drawing.Point(4, 22)
        Me.TabPage4.Name = "TabPage4"
        Me.TabPage4.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage4.Size = New System.Drawing.Size(792, 424)
        Me.TabPage4.TabIndex = 3
        Me.TabPage4.Text = "Low Stock"
        Me.TabPage4.UseVisualStyleBackColor = True
        '
        'dgvLowStock
        '
        Me.dgvLowStock.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvLowStock.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvLowStock.Location = New System.Drawing.Point(3, 3)
        Me.dgvLowStock.Name = "dgvLowStock"
        Me.dgvLowStock.Size = New System.Drawing.Size(786, 380)
        Me.dgvLowStock.TabIndex = 0
        '
        'btnRefresh
        '
        Me.btnRefresh.Location = New System.Drawing.Point(6, 6)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(75, 23)
        Me.btnRefresh.TabIndex = 1
        Me.btnRefresh.Text = "Refresh"
        Me.btnRefresh.UseVisualStyleBackColor = True
        '
        'StockroomManagementForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(800, 450)
        Me.Controls.Add(Me.TabControl1)
        Me.Name = "StockroomManagementForm"
        Me.Text = "Stockroom Management"
        Me.TabControl1.ResumeLayout(False)
        Me.TabPage1.ResumeLayout(False)
        Me.TabPage1.PerformLayout()
        CType(Me.dgvRawMaterials, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage2.ResumeLayout(False)
        CType(Me.dgvSuppliers, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage3.ResumeLayout(False)
        CType(Me.dgvPurchaseOrders, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage4.ResumeLayout(False)
        CType(Me.dgvLowStock, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents TabControl1 As TabControl
    Friend WithEvents TabPage1 As TabPage
    Friend WithEvents dgvRawMaterials As DataGridView
    Friend WithEvents txtSearchMaterials As TextBox
    Friend WithEvents Label1 As Label
    Friend WithEvents TabPage2 As TabPage
    Friend WithEvents dgvSuppliers As DataGridView
    Friend WithEvents txtSearchSuppliers As TextBox
    Friend WithEvents TabPage3 As TabPage
    Friend WithEvents dgvPurchaseOrders As DataGridView
    Friend WithEvents TabPage4 As TabPage
    Friend WithEvents dgvLowStock As DataGridView
    Friend WithEvents lblTotalSuppliers As Label
    Friend WithEvents lblTotalMaterials As Label
    Friend WithEvents lblTotalOrders As Label
    Friend WithEvents lblLowStockCount As Label
    Friend WithEvents btnAddMaterial As Button
    Friend WithEvents btnEditMaterial As Button
    Friend WithEvents btnAddSupplier As Button
    Friend WithEvents btnEditSupplier As Button
    Friend WithEvents btnCreatePO As Button
    Friend WithEvents btnRefresh As Button
End Class
