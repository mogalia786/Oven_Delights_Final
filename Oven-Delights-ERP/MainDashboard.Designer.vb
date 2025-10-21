<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class MainDashboard
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
        Dim resources As ComponentModel.ComponentResourceManager = New ComponentModel.ComponentResourceManager(GetType(MainDashboard))
        MenuStrip1 = New MenuStrip()
        AdministratorToolStripMenuItem = New ToolStripMenuItem()
        DashboardToolStripMenuItem = New ToolStripMenuItem()
        UserManagementToolStripMenuItem = New ToolStripMenuItem()
        BranchManagementToolStripMenuItem = New ToolStripMenuItem()
        AuditLogToolStripMenuItem = New ToolStripMenuItem()
        SystemSettingsToolStripMenuItem = New ToolStripMenuItem()
        StockroomToolStripMenuItem = New ToolStripMenuItem()
        InventoryManagementToolStripMenuItem = New ToolStripMenuItem()
        SuppliersToolStripMenuItem = New ToolStripMenuItem()
        PurchaseOrdersToolStripMenuItem = New ToolStripMenuItem()
        SupplierInvoicesToolStripMenuItem = New ToolStripMenuItem()
        CreditNotesToolStripMenuItem = New ToolStripMenuItem()
        StockTransfersToolStripMenuItem = New ToolStripMenuItem()
        StockAdjustmentsToolStripMenuItem = New ToolStripMenuItem()
        ManufacturingToolStripMenuItem = New ToolStripMenuItem()
        mnuManufacturingOrders = New ToolStripMenuItem()
        mnuNewOrders = New ToolStripMenuItem()
        mnuReadyOrders = New ToolStripMenuItem()
        mnuAllOrders = New ToolStripMenuItem()
        RetailToolStripMenuItem = New ToolStripMenuItem()
        AccountingToolStripMenuItem = New ToolStripMenuItem()
        ReportingToolStripMenuItem = New ToolStripMenuItem()
        ExitToolStripMenuItem = New ToolStripMenuItem()
        pnlSidebar = New Panel()
        lblSidebarTitle = New Label()
        picLogo = New PictureBox()
        pnlRightStats = New Panel()
        lblStatsTitle = New Label()
        MenuStrip1.SuspendLayout()
        pnlSidebar.SuspendLayout()
        CType(picLogo, ComponentModel.ISupportInitialize).BeginInit()
        pnlRightStats.SuspendLayout()
        SuspendLayout()
        ' 
        ' MenuStrip1
        ' 
        MenuStrip1.Items.AddRange(New ToolStripItem() {AdministratorToolStripMenuItem, StockroomToolStripMenuItem, ManufacturingToolStripMenuItem, RetailToolStripMenuItem, AccountingToolStripMenuItem, ReportingToolStripMenuItem, ExitToolStripMenuItem})
        MenuStrip1.Location = New Point(0, 0)
        MenuStrip1.Name = "MenuStrip1"
        MenuStrip1.Padding = New Padding(7, 2, 0, 2)
        MenuStrip1.Size = New Size(1400, 24)
        MenuStrip1.TabIndex = 0
        MenuStrip1.Text = "MenuStrip1"
        ' 
        ' AdministratorToolStripMenuItem
        ' 
        AdministratorToolStripMenuItem.DropDownItems.AddRange(New ToolStripItem() {DashboardToolStripMenuItem, UserManagementToolStripMenuItem, BranchManagementToolStripMenuItem, AuditLogToolStripMenuItem, SystemSettingsToolStripMenuItem})
        AdministratorToolStripMenuItem.Name = "AdministratorToolStripMenuItem"
        AdministratorToolStripMenuItem.Size = New Size(92, 20)
        AdministratorToolStripMenuItem.Text = "Administration"
        ' 
        ' DashboardToolStripMenuItem
        ' 
        DashboardToolStripMenuItem.Name = "DashboardToolStripMenuItem"
        DashboardToolStripMenuItem.Size = New Size(185, 22)
        DashboardToolStripMenuItem.Text = "Dashboard"
        ' 
        ' UserManagementToolStripMenuItem
        ' 
        UserManagementToolStripMenuItem.Name = "UserManagementToolStripMenuItem"
        UserManagementToolStripMenuItem.Size = New Size(185, 22)
        UserManagementToolStripMenuItem.Text = "User Management"
        ' 
        ' BranchManagementToolStripMenuItem
        ' 
        BranchManagementToolStripMenuItem.Name = "BranchManagementToolStripMenuItem"
        BranchManagementToolStripMenuItem.Size = New Size(185, 22)
        BranchManagementToolStripMenuItem.Text = "Branch Management"
        ' 
        ' AuditLogToolStripMenuItem
        ' 
        AuditLogToolStripMenuItem.Name = "AuditLogToolStripMenuItem"
        AuditLogToolStripMenuItem.Size = New Size(185, 22)
        AuditLogToolStripMenuItem.Text = "Audit Log"
        ' 
        ' SystemSettingsToolStripMenuItem
        ' 
        SystemSettingsToolStripMenuItem.Name = "SystemSettingsToolStripMenuItem"
        SystemSettingsToolStripMenuItem.Size = New Size(185, 22)
        SystemSettingsToolStripMenuItem.Text = "System Settings"
        ' 
        ' StockroomToolStripMenuItem
        ' 
        StockroomToolStripMenuItem.DropDownItems.AddRange(New ToolStripItem() {InventoryManagementToolStripMenuItem, SuppliersToolStripMenuItem, PurchaseOrdersToolStripMenuItem, SupplierInvoicesToolStripMenuItem, CreditNotesToolStripMenuItem, StockTransfersToolStripMenuItem, StockAdjustmentsToolStripMenuItem})
        StockroomToolStripMenuItem.Name = "StockroomToolStripMenuItem"
        StockroomToolStripMenuItem.Size = New Size(77, 20)
        StockroomToolStripMenuItem.Text = "Stockroom"
        ' 
        ' InventoryManagementToolStripMenuItem
        ' 
        InventoryManagementToolStripMenuItem.Name = "InventoryManagementToolStripMenuItem"
        InventoryManagementToolStripMenuItem.Size = New Size(198, 22)
        InventoryManagementToolStripMenuItem.Text = "Inventory Management"
        ' 
        ' SuppliersToolStripMenuItem
        ' 
        SuppliersToolStripMenuItem.Name = "SuppliersToolStripMenuItem"
        SuppliersToolStripMenuItem.Size = New Size(198, 22)
        SuppliersToolStripMenuItem.Text = "Suppliers"
        ' 
        ' PurchaseOrdersToolStripMenuItem
        ' 
        PurchaseOrdersToolStripMenuItem.Name = "PurchaseOrdersToolStripMenuItem"
        PurchaseOrdersToolStripMenuItem.Size = New Size(198, 22)
        PurchaseOrdersToolStripMenuItem.Text = "Purchase Orders"
        ' 
        ' SupplierInvoicesToolStripMenuItem
        ' 
        SupplierInvoicesToolStripMenuItem.Name = "SupplierInvoicesToolStripMenuItem"
        SupplierInvoicesToolStripMenuItem.Size = New Size(198, 22)
        SupplierInvoicesToolStripMenuItem.Text = "Supplier Invoices"
        ' 
        ' CreditNotesToolStripMenuItem
        ' 
        CreditNotesToolStripMenuItem.Name = "CreditNotesToolStripMenuItem"
        CreditNotesToolStripMenuItem.Size = New Size(198, 22)
        CreditNotesToolStripMenuItem.Text = "Credit Notes"
        ' 
        ' StockTransfersToolStripMenuItem
        ' 
        StockTransfersToolStripMenuItem.Name = "StockTransfersToolStripMenuItem"
        StockTransfersToolStripMenuItem.Size = New Size(198, 22)
        StockTransfersToolStripMenuItem.Text = "Stock Transfers"
        ' 
        ' StockAdjustmentsToolStripMenuItem
        ' 
        StockAdjustmentsToolStripMenuItem.Name = "StockAdjustmentsToolStripMenuItem"
        StockAdjustmentsToolStripMenuItem.Size = New Size(198, 22)
        StockAdjustmentsToolStripMenuItem.Text = "Stock Adjustments"
        ' 
        ' ManufacturingToolStripMenuItem
        ' 
        ManufacturingToolStripMenuItem.DropDownItems.AddRange(New ToolStripItem() {mnuManufacturingOrders})
        ManufacturingToolStripMenuItem.Name = "ManufacturingToolStripMenuItem"
        ManufacturingToolStripMenuItem.Size = New Size(98, 20)
        ManufacturingToolStripMenuItem.Text = "Manufacturing"
        ' 
        ' mnuManufacturingOrders
        ' 
        mnuManufacturingOrders.DropDownItems.AddRange(New ToolStripItem() {mnuNewOrders, mnuReadyOrders, mnuAllOrders})
        mnuManufacturingOrders.Name = "mnuManufacturingOrders"
        mnuManufacturingOrders.Size = New Size(180, 22)
        mnuManufacturingOrders.Text = "Orders"
        ' 
        ' mnuNewOrders
        ' 
        mnuNewOrders.Name = "mnuNewOrders"
        mnuNewOrders.Size = New Size(180, 22)
        mnuNewOrders.Text = "New Orders"
        ' 
        ' mnuReadyOrders
        ' 
        mnuReadyOrders.Name = "mnuReadyOrders"
        mnuReadyOrders.Size = New Size(180, 22)
        mnuReadyOrders.Text = "Ready Orders"
        ' 
        ' mnuAllOrders
        ' 
        mnuAllOrders.Name = "mnuAllOrders"
        mnuAllOrders.Size = New Size(180, 22)
        mnuAllOrders.Text = "All Orders"
        ' 
        ' RetailToolStripMenuItem
        ' 
        RetailToolStripMenuItem.Name = "RetailToolStripMenuItem"
        RetailToolStripMenuItem.Size = New Size(48, 20)
        RetailToolStripMenuItem.Text = "Retail"
        ' 
        ' AccountingToolStripMenuItem
        ' 
        AccountingToolStripMenuItem.Name = "AccountingToolStripMenuItem"
        AccountingToolStripMenuItem.Size = New Size(81, 20)
        AccountingToolStripMenuItem.Text = "Accounting"
        ' 
        ' ReportingToolStripMenuItem
        ' 
        ReportingToolStripMenuItem.Name = "ReportingToolStripMenuItem"
        ReportingToolStripMenuItem.Size = New Size(71, 20)
        ReportingToolStripMenuItem.Text = "Reporting"
        ' 
        ' ExitToolStripMenuItem
        ' 
        ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        ExitToolStripMenuItem.Size = New Size(38, 20)
        ExitToolStripMenuItem.Text = "Exit"
        ' 
        ' pnlSidebar
        ' 
        pnlSidebar.BackColor = Color.FromArgb(CByte(183), CByte(58), CByte(46))
        pnlSidebar.Controls.Add(lblSidebarTitle)
        pnlSidebar.Controls.Add(picLogo)
        pnlSidebar.Dock = DockStyle.Left
        pnlSidebar.Location = New Point(0, 24)
        pnlSidebar.Name = "pnlSidebar"
        pnlSidebar.Padding = New Padding(12)
        pnlSidebar.Size = New Size(220, 899)
        pnlSidebar.TabIndex = 1
        ' 
        ' lblSidebarTitle
        ' 
        lblSidebarTitle.AutoSize = True
        lblSidebarTitle.Dock = DockStyle.Top
        lblSidebarTitle.Font = New Font("Segoe UI", 11F, FontStyle.Bold, GraphicsUnit.Point)
        lblSidebarTitle.ForeColor = Color.White
        lblSidebarTitle.Location = New Point(12, 112)
        lblSidebarTitle.Margin = New Padding(0, 8, 0, 8)
        lblSidebarTitle.Name = "lblSidebarTitle"
        lblSidebarTitle.Padding = New Padding(0, 10, 0, 10)
        lblSidebarTitle.Size = New Size(107, 40)
        lblSidebarTitle.TabIndex = 2
        lblSidebarTitle.Text = "Oven Delights"
        ' 
        ' picLogo
        ' 
        picLogo.BackColor = Color.FromArgb(CByte(183), CByte(58), CByte(46))
        picLogo.Dock = DockStyle.Top
        picLogo.Image = CType(resources.GetObject("picLogo.Image"), Image)
        picLogo.Location = New Point(12, 12)
        picLogo.Name = "picLogo"
        picLogo.Size = New Size(196, 100)
        picLogo.SizeMode = PictureBoxSizeMode.Zoom
        picLogo.TabIndex = 0
        picLogo.TabStop = False
        ' 
        ' pnlRightStats
        ' 
        pnlRightStats.BackColor = Color.FromArgb(CByte(242), CByte(215), CByte(212))
        pnlRightStats.Controls.Add(lblStatsTitle)
        pnlRightStats.Dock = DockStyle.Right
        pnlRightStats.Location = New Point(1142, 24)
        pnlRightStats.Name = "pnlRightStats"
        pnlRightStats.Padding = New Padding(16)
        pnlRightStats.Size = New Size(258, 899)
        pnlRightStats.TabIndex = 3
        ' 
        ' lblStatsTitle
        ' 
        lblStatsTitle.AutoSize = True
        lblStatsTitle.Font = New Font("Segoe UI", 11F, FontStyle.Bold, GraphicsUnit.Point)
        lblStatsTitle.ForeColor = Color.Black
        lblStatsTitle.Location = New Point(24, 24)
        lblStatsTitle.Name = "lblStatsTitle"
        lblStatsTitle.Size = New Size(171, 20)
        lblStatsTitle.TabIndex = 0
        lblStatsTitle.Text = "Key Stats (placeholder)"
        ' 
        ' MainDashboard
        ' 
        AutoScaleDimensions = New SizeF(7F, 15F)
        AutoScaleMode = AutoScaleMode.Font
        BackColor = Color.WhiteSmoke
        ClientSize = New Size(1400, 923)
        Controls.Add(pnlRightStats)
        Controls.Add(pnlSidebar)
        Controls.Add(MenuStrip1)
        IsMdiContainer = True
        MainMenuStrip = MenuStrip1
        Margin = New Padding(4, 3, 4, 3)
        Name = "MainDashboard"
        Text = "Oven Delights ERP - Main Dashboard"
        WindowState = FormWindowState.Maximized
        MenuStrip1.ResumeLayout(False)
        MenuStrip1.PerformLayout()
        pnlSidebar.ResumeLayout(False)
        pnlSidebar.PerformLayout()
        CType(picLogo, ComponentModel.ISupportInitialize).EndInit()
        pnlRightStats.ResumeLayout(False)
        pnlRightStats.PerformLayout()
        ResumeLayout(False)
        PerformLayout()
    End Sub

    Friend WithEvents MenuStrip1 As MenuStrip
    Friend WithEvents AdministratorToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents StockroomToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents ManufacturingToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents mnuManufacturingOrders As ToolStripMenuItem
    Friend WithEvents mnuNewOrders As ToolStripMenuItem
    Friend WithEvents mnuReadyOrders As ToolStripMenuItem
    Friend WithEvents mnuAllOrders As ToolStripMenuItem
    Friend WithEvents RetailToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents AccountingToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents ReportingToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As ToolStripMenuItem

    ' Administrator Submenus
    Friend WithEvents DashboardToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents UserManagementToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents BranchManagementToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents AuditLogToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents SystemSettingsToolStripMenuItem As ToolStripMenuItem

    ' Stockroom Submenus
    Friend WithEvents InventoryManagementToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents SuppliersToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents PurchaseOrdersToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents StockTransfersToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents StockAdjustmentsToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents SupplierInvoicesToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents CreditNotesToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents pnlSidebar As Panel
    Friend WithEvents picLogo As PictureBox
    Friend WithEvents lblSidebarTitle As Label
    Friend WithEvents pnlRightStats As Panel
    Friend WithEvents lblStatsTitle As Label
End Class
