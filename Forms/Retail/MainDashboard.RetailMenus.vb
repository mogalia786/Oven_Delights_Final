Imports System.Windows.Forms

Partial Class MainDashboard

    ' Wire Retail menus on first show so the Designer file remains untouched.
    Private wiredRetailMenus As Boolean = False

    Private Sub Retail_WireMenus_OnShown(sender As Object, e As EventArgs) Handles Me.Shown
        If wiredRetailMenus Then Return
        Try
            WireRetailMenus()
            wiredRetailMenus = True
        Catch ex As Exception
            MessageBox.Show("Retail menu wiring failed: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenLowStockReport(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is LowStockReportForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New LowStockReportForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Low Stock report: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenPOReceiving(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is POReceivingForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New POReceivingForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening PO → Retail Receiving: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub WireRetailMenus()
        If Me.MenuStrip1 Is Nothing Then Return
        Dim retail As ToolStripMenuItem = GetOrCreateTopMenu("Retail")
        If retail Is Nothing Then Return

        ' Products > Product Upsert
        Dim products As ToolStripMenuItem = GetOrCreateSubMenu(retail, "Products")
        Dim miUpsert As ToolStripMenuItem = GetOrCreateSubMenu(products, "Product Upsert")
        RemoveHandler miUpsert.Click, AddressOf OpenRetailProductUpsert
        AddHandler miUpsert.Click, AddressOf OpenRetailProductUpsert

        ' Prices > Price Management (stub wiring; form will follow)
        Dim prices As ToolStripMenuItem = GetOrCreateSubMenu(retail, "Prices")
        Dim miPriceMgmt As ToolStripMenuItem = GetOrCreateSubMenu(prices, "Price Management")
        RemoveHandler miPriceMgmt.Click, AddressOf OpenPriceManagement
        AddHandler miPriceMgmt.Click, AddressOf OpenPriceManagement

        ' Inventory > Stock on Hand (already implemented elsewhere) and Adjustments (stub wiring)
        Dim inventory As ToolStripMenuItem = GetOrCreateSubMenu(retail, "Inventory")
        Dim miSOH As ToolStripMenuItem = GetOrCreateSubMenu(inventory, "Stock on Hand")
        RemoveHandler miSOH.Click, AddressOf OpenRetailStockOnHand
        AddHandler miSOH.Click, AddressOf OpenRetailStockOnHand
        Dim miAdjust As ToolStripMenuItem = GetOrCreateSubMenu(inventory, "Adjustments")
        RemoveHandler miAdjust.Click, AddressOf OpenStockOverview
        AddHandler miAdjust.Click, AddressOf OpenStockOverview

        ' Receiving > Manufacturing and External PO (stub wiring; forms will follow)
        Dim receiving As ToolStripMenuItem = GetOrCreateSubMenu(retail, "Receiving")
        Dim miMfg As ToolStripMenuItem = GetOrCreateSubMenu(receiving, "Manufacturing → Retail")
        RemoveHandler miMfg.Click, AddressOf OpenManufacturingReceiving
        AddHandler miMfg.Click, AddressOf OpenManufacturingReceiving
        Dim miExt As ToolStripMenuItem = GetOrCreateSubMenu(receiving, "Storeroom (External PO) → Retail")
        RemoveHandler miExt.Click, AddressOf OpenPOReceiving
        AddHandler miExt.Click, AddressOf OpenPOReceiving

        ' Reports > Low Stock, Catalog, Price History (stub wiring; reports will follow)
        Dim reports As ToolStripMenuItem = GetOrCreateSubMenu(retail, "Reports")
        Dim miLow As ToolStripMenuItem = GetOrCreateSubMenu(reports, "Low Stock")
        RemoveHandler miLow.Click, AddressOf OpenLowStockReport
        AddHandler miLow.Click, AddressOf OpenLowStockReport
        Dim miCat As ToolStripMenuItem = GetOrCreateSubMenu(reports, "Product Catalog")
        RemoveHandler miCat.Click, AddressOf OpenProductCatalogReport
        AddHandler miCat.Click, AddressOf OpenProductCatalogReport
        Dim miHist As ToolStripMenuItem = GetOrCreateSubMenu(reports, "Price History")
        RemoveHandler miHist.Click, AddressOf OpenPriceHistoryReport
        AddHandler miHist.Click, AddressOf OpenPriceHistoryReport
        
        ' Manufacturing > Orders > New Orders, Ready Orders, All Orders
        Dim manufacturing As ToolStripMenuItem = GetOrCreateTopMenu("Manufacturing")
        Dim orders As ToolStripMenuItem = GetOrCreateSubMenu(manufacturing, "Orders")
        Dim miNewOrders As ToolStripMenuItem = GetOrCreateSubMenu(orders, "New Orders")
        RemoveHandler miNewOrders.Click, AddressOf OpenNewOrders
        AddHandler miNewOrders.Click, AddressOf OpenNewOrders
        Dim miReadyOrders As ToolStripMenuItem = GetOrCreateSubMenu(orders, "Ready Orders")
        RemoveHandler miReadyOrders.Click, AddressOf OpenReadyOrders
        AddHandler miReadyOrders.Click, AddressOf OpenReadyOrders
        Dim miAllOrders As ToolStripMenuItem = GetOrCreateSubMenu(orders, "All Orders")
        RemoveHandler miAllOrders.Click, AddressOf OpenAllOrders
        AddHandler miAllOrders.Click, AddressOf OpenAllOrders
    End Sub
    
    Private Sub OpenNewOrders(sender As Object, e As EventArgs)
        Try
            Dim frm As New ManufacturerOrdersForm("New")
            frm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show("Error opening New Orders: " & ex.Message, "Manufacturing", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenReadyOrders(sender As Object, e As EventArgs)
        Try
            Dim frm As New ManufacturerOrdersForm("Ready")
            frm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show("Error opening Ready Orders: " & ex.Message, "Manufacturing", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenAllOrders(sender As Object, e As EventArgs)
        Try
            Dim frm As New ManufacturerOrdersForm("All")
            frm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show("Error opening All Orders: " & ex.Message, "Manufacturing", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function GetOrCreateTopMenu(text As String) As ToolStripMenuItem
        For Each it As ToolStripItem In Me.MenuStrip1.Items
            Dim mi = TryCast(it, ToolStripMenuItem)
            If mi IsNot Nothing AndAlso String.Equals(mi.Text.Replace("&", String.Empty), text, StringComparison.OrdinalIgnoreCase) Then
                Return mi
            End If
        Next
        Dim created As New ToolStripMenuItem(text)
        Me.MenuStrip1.Items.Add(created)
        Return created
    End Function

    Private Sub OpenProductCatalogReport(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is ProductCatalogReportForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New ProductCatalogReportForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Product Catalog report: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenPriceHistoryReport(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is PriceHistoryReportForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New PriceHistoryReportForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Price History report: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function GetOrCreateSubMenu(parent As ToolStripMenuItem, text As String) As ToolStripMenuItem
        For Each it As ToolStripItem In parent.DropDownItems
            Dim mi = TryCast(it, ToolStripMenuItem)
            If mi IsNot Nothing AndAlso String.Equals(mi.Text, text, StringComparison.OrdinalIgnoreCase) Then
                Return mi
            End If
        Next
        Dim created As New ToolStripMenuItem(text)
        parent.DropDownItems.Add(created)
        Return created
    End Function

    Private Sub OpenRetailProductUpsert(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is ProductUpsertForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New ProductUpsertForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Product Upsert: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' Temporary placeholders (no heavy UI) — kept Designer‑editable forms for real features
    Private Sub OpenPriceManagement(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is PriceManagementForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New PriceManagementForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Price Management: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    Private Sub OpenStockOverview(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is StockOverviewForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New StockOverviewForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Stock Overview: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    Private Sub Retail_Receiving_Placeholder(sender As Object, e As EventArgs)
        MessageBox.Show("Receiving flows are being implemented.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub
    Private Sub Retail_Reports_Placeholder(sender As Object, e As EventArgs)
        MessageBox.Show("Reports are being implemented.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub OpenManufacturingReceiving(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is ManufacturingReceivingForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New ManufacturingReceivingForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Manufacturing → Retail Receiving: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

End Class
