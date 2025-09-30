<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class StockroomDashboardForm
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
        Me.pnlKPIs = New System.Windows.Forms.Panel()
        Me.lblTotalProducts = New System.Windows.Forms.Label()
        Me.lblLowStock = New System.Windows.Forms.Label()
        Me.lblPendingGRVs = New System.Windows.Forms.Label()
        Me.lblTotalValue = New System.Windows.Forms.Label()
        Me.dgvLowStockItems = New System.Windows.Forms.DataGridView()
        Me.dgvRecentMovements = New System.Windows.Forms.DataGridView()
        Me.lblLowStockTitle = New System.Windows.Forms.Label()
        Me.lblRecentMovementsTitle = New System.Windows.Forms.Label()
        Me.btnRefresh = New System.Windows.Forms.Button()
        Me.btnInventoryReport = New System.Windows.Forms.Button()
        Me.btnStockMovementReport = New System.Windows.Forms.Button()
        Me.pnlButtons = New System.Windows.Forms.Panel()
        Me.pnlMain = New System.Windows.Forms.Panel()
        Me.pnlLeft = New System.Windows.Forms.Panel()
        Me.pnlRight = New System.Windows.Forms.Panel()
        Me.pnlKPIs.SuspendLayout()
        CType(Me.dgvLowStockItems, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dgvRecentMovements, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.pnlButtons.SuspendLayout()
        Me.pnlMain.SuspendLayout()
        Me.pnlLeft.SuspendLayout()
        Me.pnlRight.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlKPIs
        '
        Me.pnlKPIs.BackColor = System.Drawing.SystemColors.Control
        Me.pnlKPIs.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.pnlKPIs.Controls.Add(Me.lblTotalProducts)
        Me.pnlKPIs.Controls.Add(Me.lblLowStock)
        Me.pnlKPIs.Controls.Add(Me.lblPendingGRVs)
        Me.pnlKPIs.Controls.Add(Me.lblTotalValue)
        Me.pnlKPIs.Dock = System.Windows.Forms.DockStyle.Top
        Me.pnlKPIs.Location = New System.Drawing.Point(0, 0)
        Me.pnlKPIs.Name = "pnlKPIs"
        Me.pnlKPIs.Size = New System.Drawing.Size(800, 100)
        Me.pnlKPIs.TabIndex = 0
        '
        'lblTotalProducts
        '
        Me.lblTotalProducts.AutoSize = True
        Me.lblTotalProducts.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTotalProducts.ForeColor = System.Drawing.Color.Blue
        Me.lblTotalProducts.Location = New System.Drawing.Point(20, 20)
        Me.lblTotalProducts.Name = "lblTotalProducts"
        Me.lblTotalProducts.Size = New System.Drawing.Size(126, 20)
        Me.lblTotalProducts.TabIndex = 0
        Me.lblTotalProducts.Text = "Total Products:"
        '
        'lblLowStock
        '
        Me.lblLowStock.AutoSize = True
        Me.lblLowStock.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblLowStock.ForeColor = System.Drawing.Color.Red
        Me.lblLowStock.Location = New System.Drawing.Point(200, 20)
        Me.lblLowStock.Name = "lblLowStock"
        Me.lblLowStock.Size = New System.Drawing.Size(95, 20)
        Me.lblLowStock.TabIndex = 1
        Me.lblLowStock.Text = "Low Stock:"
        '
        'lblPendingGRVs
        '
        Me.lblPendingGRVs.AutoSize = True
        Me.lblPendingGRVs.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblPendingGRVs.ForeColor = System.Drawing.Color.Orange
        Me.lblPendingGRVs.Location = New System.Drawing.Point(380, 20)
        Me.lblPendingGRVs.Name = "lblPendingGRVs"
        Me.lblPendingGRVs.Size = New System.Drawing.Size(124, 20)
        Me.lblPendingGRVs.TabIndex = 2
        Me.lblPendingGRVs.Text = "Pending GRVs:"
        '
        'lblTotalValue
        '
        Me.lblTotalValue.AutoSize = True
        Me.lblTotalValue.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTotalValue.ForeColor = System.Drawing.Color.Green
        Me.lblTotalValue.Location = New System.Drawing.Point(560, 20)
        Me.lblTotalValue.Name = "lblTotalValue"
        Me.lblTotalValue.Size = New System.Drawing.Size(106, 20)
        Me.lblTotalValue.TabIndex = 3
        Me.lblTotalValue.Text = "Total Value:"
        '
        'dgvLowStockItems
        '
        Me.dgvLowStockItems.AllowUserToAddRows = False
        Me.dgvLowStockItems.AllowUserToDeleteRows = False
        Me.dgvLowStockItems.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvLowStockItems.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvLowStockItems.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvLowStockItems.Location = New System.Drawing.Point(0, 25)
        Me.dgvLowStockItems.MultiSelect = False
        Me.dgvLowStockItems.Name = "dgvLowStockItems"
        Me.dgvLowStockItems.ReadOnly = True
        Me.dgvLowStockItems.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvLowStockItems.Size = New System.Drawing.Size(390, 275)
        Me.dgvLowStockItems.TabIndex = 1
        '
        'dgvRecentMovements
        '
        Me.dgvRecentMovements.AllowUserToAddRows = False
        Me.dgvRecentMovements.AllowUserToDeleteRows = False
        Me.dgvRecentMovements.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.dgvRecentMovements.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgvRecentMovements.Dock = System.Windows.Forms.DockStyle.Fill
        Me.dgvRecentMovements.Location = New System.Drawing.Point(0, 25)
        Me.dgvRecentMovements.MultiSelect = False
        Me.dgvRecentMovements.Name = "dgvRecentMovements"
        Me.dgvRecentMovements.ReadOnly = True
        Me.dgvRecentMovements.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.dgvRecentMovements.Size = New System.Drawing.Size(400, 275)
        Me.dgvRecentMovements.TabIndex = 2
        '
        'lblLowStockTitle
        '
        Me.lblLowStockTitle.BackColor = System.Drawing.SystemColors.ActiveCaption
        Me.lblLowStockTitle.Dock = System.Windows.Forms.DockStyle.Top
        Me.lblLowStockTitle.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblLowStockTitle.Location = New System.Drawing.Point(0, 0)
        Me.lblLowStockTitle.Name = "lblLowStockTitle"
        Me.lblLowStockTitle.Size = New System.Drawing.Size(390, 25)
        Me.lblLowStockTitle.TabIndex = 3
        Me.lblLowStockTitle.Text = "Low Stock Items"
        Me.lblLowStockTitle.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'lblRecentMovementsTitle
        '
        Me.lblRecentMovementsTitle.BackColor = System.Drawing.SystemColors.ActiveCaption
        Me.lblRecentMovementsTitle.Dock = System.Windows.Forms.DockStyle.Top
        Me.lblRecentMovementsTitle.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblRecentMovementsTitle.Location = New System.Drawing.Point(0, 0)
        Me.lblRecentMovementsTitle.Name = "lblRecentMovementsTitle"
        Me.lblRecentMovementsTitle.Size = New System.Drawing.Size(400, 25)
        Me.lblRecentMovementsTitle.TabIndex = 4
        Me.lblRecentMovementsTitle.Text = "Recent Stock Movements"
        Me.lblRecentMovementsTitle.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'btnRefresh
        '
        Me.btnRefresh.Location = New System.Drawing.Point(10, 10)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(75, 23)
        Me.btnRefresh.TabIndex = 5
        Me.btnRefresh.Text = "Refresh"
        Me.btnRefresh.UseVisualStyleBackColor = True
        '
        'btnInventoryReport
        '
        Me.btnInventoryReport.Location = New System.Drawing.Point(91, 10)
        Me.btnInventoryReport.Name = "btnInventoryReport"
        Me.btnInventoryReport.Size = New System.Drawing.Size(100, 23)
        Me.btnInventoryReport.TabIndex = 6
        Me.btnInventoryReport.Text = "Inventory Report"
        Me.btnInventoryReport.UseVisualStyleBackColor = True
        '
        'btnStockMovementReport
        '
        Me.btnStockMovementReport.Location = New System.Drawing.Point(197, 10)
        Me.btnStockMovementReport.Name = "btnStockMovementReport"
        Me.btnStockMovementReport.Size = New System.Drawing.Size(130, 23)
        Me.btnStockMovementReport.TabIndex = 7
        Me.btnStockMovementReport.Text = "Stock Movement Report"
        Me.btnStockMovementReport.UseVisualStyleBackColor = True
        '
        'pnlButtons
        '
        Me.pnlButtons.Controls.Add(Me.btnRefresh)
        Me.pnlButtons.Controls.Add(Me.btnStockMovementReport)
        Me.pnlButtons.Controls.Add(Me.btnInventoryReport)
        Me.pnlButtons.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlButtons.Location = New System.Drawing.Point(0, 400)
        Me.pnlButtons.Name = "pnlButtons"
        Me.pnlButtons.Size = New System.Drawing.Size(800, 50)
        Me.pnlButtons.TabIndex = 8
        '
        'pnlMain
        '
        Me.pnlMain.Controls.Add(Me.pnlLeft)
        Me.pnlMain.Controls.Add(Me.pnlRight)
        Me.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlMain.Location = New System.Drawing.Point(0, 100)
        Me.pnlMain.Name = "pnlMain"
        Me.pnlMain.Size = New System.Drawing.Size(800, 300)
        Me.pnlMain.TabIndex = 9
        '
        'pnlLeft
        '
        Me.pnlLeft.Controls.Add(Me.dgvLowStockItems)
        Me.pnlLeft.Controls.Add(Me.lblLowStockTitle)
        Me.pnlLeft.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlLeft.Location = New System.Drawing.Point(0, 0)
        Me.pnlLeft.Name = "pnlLeft"
        Me.pnlLeft.Size = New System.Drawing.Size(390, 300)
        Me.pnlLeft.TabIndex = 10
        '
        'pnlRight
        '
        Me.pnlRight.Controls.Add(Me.dgvRecentMovements)
        Me.pnlRight.Controls.Add(Me.lblRecentMovementsTitle)
        Me.pnlRight.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlRight.Location = New System.Drawing.Point(390, 0)
        Me.pnlRight.Name = "pnlRight"
        Me.pnlRight.Size = New System.Drawing.Size(400, 300)
        Me.pnlRight.TabIndex = 11
        '
        'StockroomDashboardForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(800, 450)
        Me.Controls.Add(Me.pnlMain)
        Me.Controls.Add(Me.pnlButtons)
        Me.Controls.Add(Me.pnlKPIs)
        Me.Name = "StockroomDashboardForm"
        Me.Text = "Stockroom Dashboard"
        Me.pnlKPIs.ResumeLayout(False)
        Me.pnlKPIs.PerformLayout()
        CType(Me.dgvLowStockItems, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.dgvRecentMovements, System.ComponentModel.ISupportInitialize).EndInit()
        Me.pnlButtons.ResumeLayout(False)
        Me.pnlMain.ResumeLayout(False)
        Me.pnlLeft.ResumeLayout(False)
        Me.pnlRight.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

    Friend WithEvents pnlKPIs As Panel
    Friend WithEvents lblTotalProducts As Label
    Friend WithEvents lblLowStock As Label
    Friend WithEvents lblPendingGRVs As Label
    Friend WithEvents lblTotalValue As Label
    Friend WithEvents dgvLowStockItems As DataGridView
    Friend WithEvents dgvRecentMovements As DataGridView
    Friend WithEvents lblLowStockTitle As Label
    Friend WithEvents lblRecentMovementsTitle As Label
    Friend WithEvents btnRefresh As Button
    Friend WithEvents btnInventoryReport As Button
    Friend WithEvents btnStockMovementReport As Button
    Friend WithEvents pnlButtons As Panel
    Friend WithEvents pnlMain As Panel
    Friend WithEvents pnlLeft As Panel
    Friend WithEvents pnlRight As Panel

End Class
