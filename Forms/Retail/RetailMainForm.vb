Imports System.Windows.Forms
Imports System.Drawing

Namespace Retail
    Public Class RetailMainForm
        Inherits Form

        Private ReadOnly menu As New MenuStrip()

        Public Sub New()
            Me.Text = "Retail"
            Me.Name = "RetailMainForm"
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.Size = New Size(1200, 800)
            Me.MinimumSize = New Size(1000, 700)

            BuildMenus()
            Controls.Add(menu)
            MainMenuStrip = menu
        End Sub

        Private Sub BuildMenus()
            ' POS
            Dim pos = New ToolStripMenuItem("POS")
            Dim miNewSale = New ToolStripMenuItem("New Sale (Scan/Lookup)")
            AddHandler miNewSale.Click, Sub() ShowPlaceholder("POS - New Sale")
            Dim miHold = New ToolStripMenuItem("Hold/Resume Sales")
            AddHandler miHold.Click, Sub() ShowPlaceholder("POS - Hold/Resume")
            Dim miReturns = New ToolStripMenuItem("Returns/Refunds")
            AddHandler miReturns.Click, Sub() ShowPlaceholder("POS - Returns/Refunds")
            Dim miZ = New ToolStripMenuItem("Daily Z Report (Close)")
            AddHandler miZ.Click, Sub() ShowPlaceholder("POS - Daily Z Report")
            pos.DropDownItems.AddRange(New ToolStripItem() {miNewSale, miHold, miReturns, miZ})

            ' Products
            Dim products = New ToolStripMenuItem("Products")
            Dim internalProducts = New ToolStripMenuItem("Internal Products (Manufactured)")
            Dim miIntList = New ToolStripMenuItem("List & Search (Today-only)")
            AddHandler miIntList.Click, AddressOf OpenInternalProducts
            Dim miIntReorder = New ToolStripMenuItem("Reorder (Create BOM Bundle)")
            AddHandler miIntReorder.Click, AddressOf OpenInternalProducts ' same screen, action inside
            Dim miIntLabels = New ToolStripMenuItem("Labels/Barcodes")
            AddHandler miIntLabels.Click, Sub() ShowPlaceholder("Products - Labels/Barcodes")
            internalProducts.DropDownItems.AddRange(New ToolStripItem() {miIntList, miIntReorder, miIntLabels})

            Dim externalProducts = New ToolStripMenuItem("External Products (Purchased)")
            Dim miExtList = New ToolStripMenuItem("List & Search")
            AddHandler miExtList.Click, Sub() ShowPlaceholder("External Products - List")
            Dim miExtPrices = New ToolStripMenuItem("Price Lists")
            AddHandler miExtPrices.Click, Sub() ShowPlaceholder("External Products - Price Lists")
            Dim miExtLabels = New ToolStripMenuItem("Labels/Barcodes")
            AddHandler miExtLabels.Click, Sub() ShowPlaceholder("External Products - Labels")
            externalProducts.DropDownItems.AddRange(New ToolStripItem() {miExtList, miExtPrices, miExtLabels})

            Dim catTaxes = New ToolStripMenuItem("Categories & Taxes")
            AddHandler catTaxes.Click, Sub() ShowPlaceholder("Categories & Taxes")
            products.DropDownItems.AddRange(New ToolStripItem() {internalProducts, externalProducts, New ToolStripSeparator(), catTaxes})

            ' Inventory
            Dim inv = New ToolStripMenuItem("Inventory (Retail Branch)")
            Dim miOnHand = New ToolStripMenuItem("Stock on Hand")
            AddHandler miOnHand.Click, AddressOf OpenStockOnHand
            Dim miAdjust = New ToolStripMenuItem("Adjustments (Write-off, Count)")
            AddHandler miAdjust.Click, Sub() ShowPlaceholder("Inventory - Adjustments")
            Dim miSerial = New ToolStripMenuItem("Serial/Lot (Query)")
            AddHandler miSerial.Click, Sub() ShowPlaceholder("Inventory - Serial/Lot")
            Dim miReorderPts = New ToolStripMenuItem("Reorder Points (Alerts)")
            AddHandler miReorderPts.Click, Sub() ShowPlaceholder("Inventory - Reorder Points")
            inv.DropDownItems.AddRange(New ToolStripItem() {miOnHand, miAdjust, miSerial, miReorderPts})

            ' Transfers
            Dim transfers = New ToolStripMenuItem("Transfers (IBT)")
            Dim miTO = New ToolStripMenuItem("Transfer Orders")
            Dim miTOCreate = New ToolStripMenuItem("Create")
            AddHandler miTOCreate.Click, Sub() ShowPlaceholder("Transfers - Create TO")
            Dim miTODispatch = New ToolStripMenuItem("Dispatch")
            AddHandler miTODispatch.Click, Sub() ShowPlaceholder("Transfers - Dispatch")
            Dim miTOReceive = New ToolStripMenuItem("Receive")
            AddHandler miTOReceive.Click, Sub() ShowPlaceholder("Transfers - Receive")
            miTO.DropDownItems.AddRange(New ToolStripItem() {miTOCreate, miTODispatch, miTOReceive})
            Dim miInTransit = New ToolStripMenuItem("In-Transit")
            AddHandler miInTransit.Click, Sub() ShowPlaceholder("Transfers - In-Transit")
            transfers.DropDownItems.AddRange(New ToolStripItem() {miTO, miInTransit})

            ' Purchasing
            Dim purchasing = New ToolStripMenuItem("Purchasing")
            Dim miPO = New ToolStripMenuItem("Purchase Orders")
            Dim miPONew = New ToolStripMenuItem("New PO (Inventory or Product)")
            AddHandler miPONew.Click, Sub() ShowPlaceholder("Purchasing - New PO")
            Dim miPOApprove = New ToolStripMenuItem("Approve")
            AddHandler miPOApprove.Click, Sub() ShowPlaceholder("Purchasing - Approve PO")
            Dim miPOReceive = New ToolStripMenuItem("Receive (GRN)")
            AddHandler miPOReceive.Click, Sub() ShowPlaceholder("Purchasing - GRN")
            miPO.DropDownItems.AddRange(New ToolStripItem() {miPONew, miPOApprove, miPOReceive})
            Dim miSuppliers = New ToolStripMenuItem("Suppliers")
            AddHandler miSuppliers.Click, Sub() ShowPlaceholder("Purchasing - Suppliers")
            Dim miPrices = New ToolStripMenuItem("Price Agreements")
            AddHandler miPrices.Click, Sub() ShowPlaceholder("Purchasing - Price Agreements")
            purchasing.DropDownItems.AddRange(New ToolStripItem() {miPO, miSuppliers, miPrices})

            ' Manufacturing (handoff)
            Dim mfg = New ToolStripMenuItem("Manufacturing (Hand-off)")
            Dim miDashboard = New ToolStripMenuItem("Producer Dashboard (Today-only)")
            AddHandler miDashboard.Click, Sub() ShowPlaceholder("Manufacturing - Producer Dashboard (open from MFG menu)")
            Dim miComplete = New ToolStripMenuItem("Complete Build (BOM → FG to Retail)")
            AddHandler miComplete.Click, Sub() ShowPlaceholder("Manufacturing - Complete Build (open from MFG menu)")
            mfg.DropDownItems.AddRange(New ToolStripItem() {miDashboard, miComplete})

            ' Daily Order Book (Retail)
            Dim daily = New ToolStripMenuItem("Daily Order Book")
            AddHandler daily.Click, AddressOf OpenDailyOrderBook

            ' Reports
            Dim reports = New ToolStripMenuItem("Reports")
            Dim miRptSOH = New ToolStripMenuItem("Stock on Hand by Branch")
            AddHandler miRptSOH.Click, Sub() ShowPlaceholder("Report - SOH by Branch")
            Dim miRptSales = New ToolStripMenuItem("Sales by Product/Category")
            AddHandler miRptSales.Click, Sub() ShowPlaceholder("Report - Sales by Product/Category")
            Dim miRptMargin = New ToolStripMenuItem("Margins")
            AddHandler miRptMargin.Click, Sub() ShowPlaceholder("Report - Margins")
            Dim miRptTransit = New ToolStripMenuItem("Transfers (In-Transit)")
            AddHandler miRptTransit.Click, Sub() ShowPlaceholder("Report - Transfers In-Transit")
            Dim miRptAdj = New ToolStripMenuItem("Adjustments & Write-offs")
            AddHandler miRptAdj.Click, Sub() ShowPlaceholder("Report - Adjustments & Write-offs")
            reports.DropDownItems.AddRange(New ToolStripItem() {miRptSOH, miRptSales, miRptMargin, miRptTransit, miRptAdj})

            ' Settings
            Dim settings = New ToolStripMenuItem("Settings")
            Dim miBarcodes = New ToolStripMenuItem("Barcodes (GTIN mapping)")
            AddHandler miBarcodes.Click, Sub() ShowPlaceholder("Settings - Barcodes")
            Dim miGL = New ToolStripMenuItem("GL Mappings")
            AddHandler miGL.Click, Sub() ShowPlaceholder("Settings - GL Mappings")
            Dim miSerialLot = New ToolStripMenuItem("Serial/Lot Policies")
            AddHandler miSerialLot.Click, Sub() ShowPlaceholder("Settings - Serial/Lot Policies")
            Dim miRoles = New ToolStripMenuItem("Roles & Access")
            AddHandler miRoles.Click, Sub() ShowPlaceholder("Settings - Roles & Access")
            settings.DropDownItems.AddRange(New ToolStripItem() {miBarcodes, miGL, miSerialLot, miRoles})

            menu.Items.AddRange(New ToolStripItem() {pos, products, inv, transfers, purchasing, mfg, daily, reports, settings})
        End Sub

        Private Sub OpenInternalProducts(sender As Object, e As EventArgs)
            ' Opens the existing internal Products screen (today-only toggle present inside)
            Dim frm As New ProductsForm()
            frm.StartPosition = FormStartPosition.CenterParent
            frm.ShowDialog(Me)
        End Sub

        Private Sub OpenStockOnHand(sender As Object, e As EventArgs)
            Dim frm As New RetailStockOnHandForm()
            frm.StartPosition = FormStartPosition.CenterParent
            frm.ShowDialog(Me)
        End Sub

        Private Sub OpenDailyOrderBook(sender As Object, e As EventArgs)
            Dim frm As New DailyOrderBookForm()
            frm.StartPosition = FormStartPosition.CenterParent
            frm.ShowDialog(Me)
        End Sub

        Private Sub ShowPlaceholder(feature As String)
            MessageBox.Show(Me, feature & " - coming soon", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

    End Class
End Namespace
