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

        Protected Overrides Sub OnFormClosed(e As FormClosedEventArgs)
            Try
                ' Clear menu items to prevent duplicates
                If menu IsNot Nothing Then
                    menu.Items.Clear()
                End If
                
                ' Dispose of menu
                If menu IsNot Nothing Then
                    menu.Dispose()
                End If
            Catch ex As Exception
                ' Silent cleanup
            End Try
            MyBase.OnFormClosed(e)
        End Sub

        Private Sub BuildMenus()
            ' POS
            Dim pos = New ToolStripMenuItem("POS")
            Dim miNewSale = New ToolStripMenuItem("New Sale (Scan/Lookup)")
            AddHandler miNewSale.Click, AddressOf OpenPOSNewSale
            Dim miHold = New ToolStripMenuItem("Hold/Resume Sales")
            AddHandler miHold.Click, AddressOf OpenPOSHoldResume
            Dim miReturns = New ToolStripMenuItem("Returns/Refunds")
            AddHandler miReturns.Click, AddressOf OpenPOSReturns
            Dim miZ = New ToolStripMenuItem("Daily Z Report (Close)")
            AddHandler miZ.Click, AddressOf OpenPOSZReport
            pos.DropDownItems.AddRange(New ToolStripItem() {miNewSale, miHold, miReturns, miZ})

            ' Products
            Dim products = New ToolStripMenuItem("Products")
            Dim internalProducts = New ToolStripMenuItem("Internal Products (Manufactured)")
            Dim miIntList = New ToolStripMenuItem("List & Search (Today-only)")
            AddHandler miIntList.Click, AddressOf OpenInternalProducts
            Dim miIntReorder = New ToolStripMenuItem("Reorder (Create BOM Bundle)")
            AddHandler miIntReorder.Click, AddressOf OpenInternalProducts ' same screen, action inside
            Dim miIntLabels = New ToolStripMenuItem("Labels/Barcodes")
            AddHandler miIntLabels.Click, AddressOf OpenProductLabels
            internalProducts.DropDownItems.AddRange(New ToolStripItem() {miIntList, miIntReorder, miIntLabels})

            Dim externalProducts = New ToolStripMenuItem("External Products (Purchased)")
            Dim miExtList = New ToolStripMenuItem("List & Search")
            AddHandler miExtList.Click, AddressOf OpenExternalProducts
            Dim miExtPrices = New ToolStripMenuItem("Price Lists")
            AddHandler miExtPrices.Click, AddressOf OpenExternalPriceLists
            Dim miExtLabels = New ToolStripMenuItem("Labels/Barcodes")
            AddHandler miExtLabels.Click, AddressOf OpenProductLabels
            externalProducts.DropDownItems.AddRange(New ToolStripItem() {miExtList, miExtPrices, miExtLabels})

            Dim catTaxes = New ToolStripMenuItem("Categories & Taxes")
            AddHandler catTaxes.Click, AddressOf OpenCategoriesTaxes
            products.DropDownItems.AddRange(New ToolStripItem() {internalProducts, externalProducts, New ToolStripSeparator(), catTaxes})

            ' Inventory
            Dim inv = New ToolStripMenuItem("Inventory (Retail Branch)")
            Dim miOnHand = New ToolStripMenuItem("Stock on Hand")
            AddHandler miOnHand.Click, AddressOf OpenStockOnHand
            Dim miAdjust = New ToolStripMenuItem("Adjustments (Write-off, Count)")
            AddHandler miAdjust.Click, AddressOf OpenInventoryAdjustments
            Dim miSerial = New ToolStripMenuItem("Serial/Lot (Query)")
            AddHandler miSerial.Click, AddressOf OpenSerialLotQuery
            Dim miReorderPts = New ToolStripMenuItem("Reorder Points (Alerts)")
            AddHandler miReorderPts.Click, AddressOf OpenReorderPoints
            inv.DropDownItems.AddRange(New ToolStripItem() {miOnHand, miAdjust, miSerial, miReorderPts})

            ' Transfers
            Dim transfers = New ToolStripMenuItem("Transfers (IBT)")
            Dim miTO = New ToolStripMenuItem("Transfer Orders")
            Dim miTOCreate = New ToolStripMenuItem("Create")
            AddHandler miTOCreate.Click, AddressOf OpenTransferCreate
            Dim miTODispatch = New ToolStripMenuItem("Dispatch")
            AddHandler miTODispatch.Click, AddressOf OpenTransferDispatch
            Dim miTOReceive = New ToolStripMenuItem("Receive")
            AddHandler miTOReceive.Click, AddressOf OpenTransferReceive
            miTO.DropDownItems.AddRange(New ToolStripItem() {miTOCreate, miTODispatch, miTOReceive})
            Dim miInTransit = New ToolStripMenuItem("In-Transit")
            AddHandler miInTransit.Click, AddressOf OpenTransferInTransit
            transfers.DropDownItems.AddRange(New ToolStripItem() {miTO, miInTransit})

            ' Purchasing
            Dim purchasing = New ToolStripMenuItem("Purchasing")
            Dim miPO = New ToolStripMenuItem("Purchase Orders")
            Dim miPONew = New ToolStripMenuItem("New PO (Inventory or Product)")
            AddHandler miPONew.Click, AddressOf OpenPurchaseOrderNew
            Dim miPOApprove = New ToolStripMenuItem("Approve")
            AddHandler miPOApprove.Click, AddressOf OpenPurchaseOrderApprove
            Dim miPOReceive = New ToolStripMenuItem("Receive (GRN)")
            AddHandler miPOReceive.Click, AddressOf OpenPurchaseOrderReceive
            miPO.DropDownItems.AddRange(New ToolStripItem() {miPONew, miPOApprove, miPOReceive})
            Dim miSuppliers = New ToolStripMenuItem("Suppliers")
            AddHandler miSuppliers.Click, AddressOf OpenSuppliers
            Dim miPrices = New ToolStripMenuItem("Price Agreements")
            AddHandler miPrices.Click, AddressOf OpenPriceAgreements
            purchasing.DropDownItems.AddRange(New ToolStripItem() {miPO, miSuppliers, miPrices})

            ' Manufacturing (handoff)
            Dim mfg = New ToolStripMenuItem("Manufacturing (Hand-off)")
            Dim miDashboard = New ToolStripMenuItem("Producer Dashboard (Today-only)")
            AddHandler miDashboard.Click, AddressOf OpenManufacturingDashboard
            Dim miComplete = New ToolStripMenuItem("Complete Build (BOM → FG to Retail)")
            AddHandler miComplete.Click, AddressOf OpenManufacturingComplete
            mfg.DropDownItems.AddRange(New ToolStripItem() {miDashboard, miComplete})

            ' Daily Order Book (Retail)
            Dim daily = New ToolStripMenuItem("Daily Order Book")
            AddHandler daily.Click, AddressOf OpenDailyOrderBook

            ' Reports
            Dim reports = New ToolStripMenuItem("Reports")
            Dim miRptSOH = New ToolStripMenuItem("Stock on Hand by Branch")
            AddHandler miRptSOH.Click, AddressOf OpenReportStockOnHand
            Dim miRptSales = New ToolStripMenuItem("Sales by Product/Category")
            AddHandler miRptSales.Click, AddressOf OpenReportSales
            Dim miRptMargin = New ToolStripMenuItem("Margins")
            AddHandler miRptMargin.Click, AddressOf OpenReportMargins
            Dim miRptTransit = New ToolStripMenuItem("Transfers (In-Transit)")
            AddHandler miRptTransit.Click, AddressOf OpenReportTransfers
            Dim miRptAdj = New ToolStripMenuItem("Adjustments & Write-offs")
            AddHandler miRptAdj.Click, AddressOf OpenReportAdjustments
            reports.DropDownItems.AddRange(New ToolStripItem() {miRptSOH, miRptSales, miRptMargin, miRptTransit, miRptAdj})

            ' Settings
            Dim settings = New ToolStripMenuItem("Settings")
            Dim miBarcodes = New ToolStripMenuItem("Barcodes (GTIN mapping)")
            AddHandler miBarcodes.Click, AddressOf OpenBarcodeSettings
            Dim miGL = New ToolStripMenuItem("GL Mappings")
            AddHandler miGL.Click, AddressOf OpenGLMappings
            Dim miSerialLot = New ToolStripMenuItem("Serial/Lot Policies")
            AddHandler miSerialLot.Click, AddressOf OpenSerialLotPolicies
            Dim miRoles = New ToolStripMenuItem("Roles & Access")
            AddHandler miRoles.Click, AddressOf OpenRolesAccess
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

        ' POS Methods
        Private Sub OpenPOSNewSale(sender As Object, e As EventArgs)
            Try
                Dim frm As New POSForm()
                frm.StartPosition = FormStartPosition.CenterParent
                frm.ShowDialog(Me)
            Catch ex As Exception
                MessageBox.Show(Me, "Error opening POS: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OpenPOSHoldResume(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "POS Hold/Resume functionality will be implemented in the POS form.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenPOSReturns(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "POS Returns/Refunds functionality will be implemented in the POS form.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenPOSZReport(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Daily Z Report functionality will be implemented in the POS form.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        ' Product Methods
        Private Sub OpenProductLabels(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Product Labels/Barcodes functionality coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenExternalProducts(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "External Products management coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenExternalPriceLists(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "External Price Lists management coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenCategoriesTaxes(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Categories & Taxes management coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        ' Inventory Methods
        Private Sub OpenInventoryAdjustments(sender As Object, e As EventArgs)
            Try
                Dim frm As New StockOverviewForm()
                frm.StartPosition = FormStartPosition.CenterParent
                frm.ShowDialog(Me)
            Catch ex As Exception
                MessageBox.Show(Me, "Error opening Inventory Adjustments: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OpenSerialLotQuery(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Serial/Lot Query functionality coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenReorderPoints(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Reorder Points management coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        ' Transfer Methods
        Private Sub OpenTransferCreate(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Transfer Order creation coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenTransferDispatch(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Transfer Dispatch functionality coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenTransferReceive(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Transfer Receive functionality coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenTransferInTransit(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "In-Transit Transfers view coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        ' Purchasing Methods
        Private Sub OpenPurchaseOrderNew(sender As Object, e As EventArgs)
            Try
                Dim frm As New PurchaseOrderForm()
                frm.StartPosition = FormStartPosition.CenterParent
                frm.ShowDialog(Me)
            Catch ex As Exception
                MessageBox.Show(Me, "Error opening Purchase Order: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OpenPurchaseOrderApprove(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Purchase Order approval functionality coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenPurchaseOrderReceive(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Purchase Order receiving (GRN) functionality coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenSuppliers(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Supplier management coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenPriceAgreements(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Price Agreements management coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        ' Manufacturing Methods
        Private Sub OpenManufacturingDashboard(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Manufacturing Dashboard should be opened from the Manufacturing menu.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenManufacturingComplete(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Manufacturing Complete Build should be opened from the Manufacturing menu.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        ' Report Methods
        Private Sub OpenReportStockOnHand(sender As Object, e As EventArgs)
            Try
                Dim frm As New RetailStockOnHandForm()
                frm.StartPosition = FormStartPosition.CenterParent
                frm.ShowDialog(Me)
            Catch ex As Exception
                MessageBox.Show(Me, "Error opening Stock on Hand report: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OpenReportSales(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Sales by Product/Category report coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenReportMargins(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Margins report coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenReportTransfers(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Transfers In-Transit report coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenReportAdjustments(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Adjustments & Write-offs report coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        ' Settings Methods
        Private Sub OpenBarcodeSettings(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Barcode GTIN mapping settings coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenGLMappings(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "GL Mappings settings coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenSerialLotPolicies(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Serial/Lot Policies settings coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OpenRolesAccess(sender As Object, e As EventArgs)
            MessageBox.Show(Me, "Roles & Access management coming soon.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

    End Class
End Namespace
