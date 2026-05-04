Imports System.Windows.Forms

''' <summary>
''' Accounting menu wiring for MainDashboard
''' </summary>
Partial Class MainDashboard
    
    Private Sub WireAccountingMenus()
        Try
            ' Get or create Accounting top-level menu
            Dim accounting As ToolStripMenuItem = GetOrCreateTopMenu("Accounting")
            
            ' Financial Dashboard
            Dim financialDashboard As ToolStripMenuItem = GetOrCreateSubMenu(accounting, "Financial Dashboard")
            RemoveHandler financialDashboard.Click, AddressOf OpenFinancialDashboard
            AddHandler financialDashboard.Click, AddressOf OpenFinancialDashboard
            
            ' General Ledger
            Dim generalLedger As ToolStripMenuItem = GetOrCreateSubMenu(accounting, "General Ledger")
            RemoveHandler generalLedger.Click, AddressOf OpenGeneralLedger
            AddHandler generalLedger.Click, AddressOf OpenGeneralLedger
            
            ' Customer Ledgers
            Dim customerLedgers As ToolStripMenuItem = GetOrCreateSubMenu(accounting, "Customer Ledgers")
            RemoveHandler customerLedgers.Click, AddressOf OpenCustomerLedgers
            AddHandler customerLedgers.Click, AddressOf OpenCustomerLedgers
            
            ' Supplier Ledgers
            Dim supplierLedgers As ToolStripMenuItem = GetOrCreateSubMenu(accounting, "Supplier Ledgers")
            RemoveHandler supplierLedgers.Click, AddressOf OpenSupplierLedgers
            AddHandler supplierLedgers.Click, AddressOf OpenSupplierLedgers
            
            ' Bank Reconciliation
            Dim bankRecon As ToolStripMenuItem = GetOrCreateSubMenu(accounting, "Bank Reconciliation")
            RemoveHandler bankRecon.Click, AddressOf OpenBankReconciliation
            AddHandler bankRecon.Click, AddressOf OpenBankReconciliation
            
            ' Bank Transaction Mapping
            Dim bankMapping As ToolStripMenuItem = GetOrCreateSubMenu(accounting, "Bank Transaction Mapping")
            RemoveHandler bankMapping.Click, AddressOf OpenBankTransactionMapping
            AddHandler bankMapping.Click, AddressOf OpenBankTransactionMapping
            
        Catch ex As Exception
            MessageBox.Show($"Error wiring accounting menus: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenFinancialDashboard(sender As Object, e As EventArgs)
        Try
            Dim branchID = If(AppSession.CurrentUser IsNot Nothing, AppSession.CurrentUser.BranchID, 0)
            Dim frm As New FinancialDashboard(branchID)
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show($"Error opening Financial Dashboard: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenGeneralLedger(sender As Object, e As EventArgs)
        Try
            Dim branchID = If(AppSession.CurrentUser IsNot Nothing, AppSession.CurrentUser.BranchID, 0)
            Dim frm As New GeneralLedgerViewer(branchID)
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show($"Error opening General Ledger: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenCustomerLedgers(sender As Object, e As EventArgs)
        Try
            Dim branchID = If(AppSession.CurrentUser IsNot Nothing, AppSession.CurrentUser.BranchID, 0)
            Dim frm As New CustomerLedgerViewer(branchID)
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show($"Error opening Customer Ledgers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenSupplierLedgers(sender As Object, e As EventArgs)
        Try
            Dim branchID = If(AppSession.CurrentUser IsNot Nothing, AppSession.CurrentUser.BranchID, 0)
            Dim frm As New SupplierLedgerViewer(branchID)
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show($"Error opening Supplier Ledgers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenBankReconciliation(sender As Object, e As EventArgs)
        Try
            Dim userName = If(AppSession.CurrentUser IsNot Nothing, AppSession.CurrentUser.Username, "System")
            Dim frm As New Accounting.BankReconciliationDashboard(userName)
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show($"Error opening Bank Reconciliation: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenBankTransactionMapping(sender As Object, e As EventArgs)
        Try
            Dim frm As New BankTransactionMappingForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show($"Error opening Bank Transaction Mapping: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    ' Note: GetOrCreateTopMenu and GetOrCreateSubMenu methods are defined in MainDashboard.RetailMenus.vb
    
End Class
