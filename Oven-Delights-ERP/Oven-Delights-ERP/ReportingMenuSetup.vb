Imports System.Windows.Forms

''' <summary>
''' Add this code to your MainDashboard.vb file to wire up all reporting menu items
''' </summary>
Public Module ReportingMenuSetup
    
    ''' <summary>
    ''' Call this method from MainDashboard_Load to setup all reporting menu items
    ''' </summary>
    Public Sub SetupReportingMenus(dashboard As Form, reportingMenu As ToolStripMenuItem)
        ' Clear existing items
        reportingMenu.DropDownItems.Clear()
        
        ' ========================================
        ' SALES REPORTS
        ' ========================================
        Dim salesMenu As New ToolStripMenuItem("Sales Reports")
        
        Dim dailySales As New ToolStripMenuItem("Daily Sales Report")
        AddHandler dailySales.Click, Sub(s, e) OpenReport(dashboard, New DailySalesReportForm())
        
        Dim monthlySales As New ToolStripMenuItem("Monthly Sales Trend")
        AddHandler monthlySales.Click, Sub(s, e) OpenReport(dashboard, New MonthlySalesReportForm())
        
        Dim salesByProduct As New ToolStripMenuItem("Sales by Product")
        AddHandler salesByProduct.Click, Sub(s, e) OpenReport(dashboard, New SalesByProductReportForm())
        
        Dim topSelling As New ToolStripMenuItem("Top Selling Products")
        AddHandler topSelling.Click, Sub(s, e) OpenReport(dashboard, New TopSellingProductsReportForm())
        
        salesMenu.DropDownItems.AddRange({dailySales, monthlySales, salesByProduct, topSelling})
        
        ' ========================================
        ' INVENTORY REPORTS
        ' ========================================
        Dim inventoryMenu As New ToolStripMenuItem("Inventory Reports")
        
        Dim stockLevels As New ToolStripMenuItem("Stock Levels")
        AddHandler stockLevels.Click, Sub(s, e) OpenReport(dashboard, New StockLevelsReportForm())
        
        Dim stockMovement As New ToolStripMenuItem("Stock Movement")
        AddHandler stockMovement.Click, Sub(s, e) OpenReport(dashboard, New StockMovementReportForm())
        
        Dim inventoryValuation As New ToolStripMenuItem("Inventory Valuation")
        AddHandler inventoryValuation.Click, Sub(s, e) OpenReport(dashboard, New InventoryValuationReportForm())
        
        Dim slowMoving As New ToolStripMenuItem("Slow Moving Stock")
        AddHandler slowMoving.Click, Sub(s, e) OpenReport(dashboard, New SlowMovingStockReportForm())
        
        Dim reorderRecommendation As New ToolStripMenuItem("Reorder Recommendations")
        AddHandler reorderRecommendation.Click, Sub(s, e) OpenReport(dashboard, New ReorderRecommendationReportForm())
        
        inventoryMenu.DropDownItems.AddRange({stockLevels, stockMovement, inventoryValuation, slowMoving, reorderRecommendation})
        
        ' ========================================
        ' MANUFACTURING REPORTS
        ' ========================================
        Dim manufacturingMenu As New ToolStripMenuItem("Manufacturing Reports")
        
        Dim productionSummary As New ToolStripMenuItem("Production Summary")
        AddHandler productionSummary.Click, Sub(s, e) OpenReport(dashboard, New ProductionSummaryReportForm())
        
        manufacturingMenu.DropDownItems.Add(productionSummary)
        
        ' ========================================
        ' FINANCIAL REPORTS
        ' ========================================
        Dim financialMenu As New ToolStripMenuItem("Financial Reports")
        
        Dim profitLoss As New ToolStripMenuItem("Profit & Loss Statement")
        AddHandler profitLoss.Click, Sub(s, e) OpenReport(dashboard, New ProfitLossReportForm())
        
        Dim apAging As New ToolStripMenuItem("Accounts Payable Aging")
        AddHandler apAging.Click, Sub(s, e) OpenReport(dashboard, New APAgingReportForm())
        
        financialMenu.DropDownItems.AddRange({profitLoss, apAging})
        
        ' ========================================
        ' ANALYSIS REPORTS
        ' ========================================
        Dim analysisMenu As New ToolStripMenuItem("Analysis Reports")
        
        Dim branchPerformance As New ToolStripMenuItem("Branch Performance Comparison")
        AddHandler branchPerformance.Click, Sub(s, e) OpenReport(dashboard, New BranchPerformanceReportForm())
        
        Dim categoryPerformance As New ToolStripMenuItem("Category Performance")
        AddHandler categoryPerformance.Click, Sub(s, e) OpenReport(dashboard, New CategoryPerformanceReportForm())
        
        Dim supplierPerformance As New ToolStripMenuItem("Supplier Performance")
        AddHandler supplierPerformance.Click, Sub(s, e) OpenReport(dashboard, New SupplierPerformanceReportForm())
        
        analysisMenu.DropDownItems.AddRange({branchPerformance, categoryPerformance, supplierPerformance})
        
        ' ========================================
        ' ADD ALL CATEGORIES TO REPORTING MENU
        ' ========================================
        reportingMenu.DropDownItems.AddRange({
            salesMenu,
            New ToolStripSeparator(),
            inventoryMenu,
            New ToolStripSeparator(),
            manufacturingMenu,
            New ToolStripSeparator(),
            financialMenu,
            New ToolStripSeparator(),
            analysisMenu
        })
    End Sub
    
    Private Sub OpenReport(dashboard As Form, reportForm As Form)
        Try
            ' Check if report is already open
            If TypeOf dashboard Is Form AndAlso CType(dashboard, Form).IsMdiContainer Then
                For Each child As Form In CType(dashboard, Form).MdiChildren
                    If child.GetType() Is reportForm.GetType() Then
                        child.Activate()
                        child.WindowState = FormWindowState.Maximized
                        reportForm.Dispose()
                        Return
                    End If
                Next
            End If
            
            ' Open new report
            reportForm.MdiParent = dashboard
            reportForm.Show()
            reportForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show($"Error opening report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
End Module
