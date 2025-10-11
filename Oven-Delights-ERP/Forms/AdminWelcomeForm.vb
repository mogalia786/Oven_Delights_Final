Imports System.Windows.Forms
Imports System.Drawing

Public Class AdminWelcomeForm
    Inherits Form

    Public Sub New(displayName As String)
        Me.Text = "Administrator - Welcome"
        Me.StartPosition = FormStartPosition.CenterParent
        Me.BackColor = Color.WhiteSmoke
        Me.Width = 900
        Me.Height = 600

        ' Admin menu
        Dim menu As New MenuStrip()
        Dim mAdmin As New ToolStripMenuItem("Administrator")
        Dim miStaff As New ToolStripMenuItem("User Management")
        AddHandler miStaff.Click, AddressOf OnOpenStaffManagement
        Dim miPayrollEntry As New ToolStripMenuItem("Payroll Entry")
        AddHandler miPayrollEntry.Click, AddressOf OnOpenPayrollEntry
        Dim miGLMappings As New ToolStripMenuItem("GL Account Mappings")
        AddHandler miGLMappings.Click, AddressOf OnOpenGLAccountMappings
        mAdmin.DropDownItems.Add(miStaff)
        mAdmin.DropDownItems.Add(miPayrollEntry)
        mAdmin.DropDownItems.Add(New ToolStripSeparator())
        mAdmin.DropDownItems.Add(miGLMappings)

        Dim mAccounting As New ToolStripMenuItem("Accounting")
        
        ' General Ledger submenu
        Dim miTrialBalance As New ToolStripMenuItem("Trial Balance")
        AddHandler miTrialBalance.Click, AddressOf OnOpenTrialBalance
        Dim miAccountLedger As New ToolStripMenuItem("Account Ledger")
        AddHandler miAccountLedger.Click, AddressOf OnOpenAccountLedger
        Dim miJournals As New ToolStripMenuItem("Journals Viewer")
        AddHandler miJournals.Click, AddressOf OnOpenJournalsViewer
        Dim miGL As New ToolStripMenuItem("General Ledger Viewer")
        AddHandler miGL.Click, AddressOf OnOpenGLViewer
        
        ' Cash Book submenu
        Dim miCashBook As New ToolStripMenuItem("Cash Book")
        Dim miMainCashBook As New ToolStripMenuItem("Main Cash Book")
        AddHandler miMainCashBook.Click, AddressOf OnOpenMainCashBook
        Dim miPettyCash As New ToolStripMenuItem("Petty Cash")
        AddHandler miPettyCash.Click, AddressOf OnOpenPettyCash
        miCashBook.DropDownItems.Add(miMainCashBook)
        miCashBook.DropDownItems.Add(miPettyCash)
        
        ' Other accounting items
        Dim miPayroll As New ToolStripMenuItem("Payroll Journal")
        AddHandler miPayroll.Click, AddressOf OnOpenPayrollJournal
        Dim miExpenseTypes As New ToolStripMenuItem("Expense Types")
        AddHandler miExpenseTypes.Click, AddressOf OnOpenExpenseTypes
        Dim miExpenses As New ToolStripMenuItem("Expenses")
        AddHandler miExpenses.Click, AddressOf OnOpenExpenses
        
        mAccounting.DropDownItems.Add(miTrialBalance)
        mAccounting.DropDownItems.Add(miAccountLedger)
        mAccounting.DropDownItems.Add(miJournals)
        mAccounting.DropDownItems.Add(miGL)
        mAccounting.DropDownItems.Add(New ToolStripSeparator())
        mAccounting.DropDownItems.Add(miCashBook)
        mAccounting.DropDownItems.Add(New ToolStripSeparator())
        mAccounting.DropDownItems.Add(miPayroll)
        mAccounting.DropDownItems.Add(New ToolStripSeparator())
        mAccounting.DropDownItems.Add(miExpenseTypes)
        mAccounting.DropDownItems.Add(miExpenses)

        menu.Items.Add(mAdmin)
        menu.Items.Add(mAccounting)
        Me.MainMenuStrip = menu
        menu.Dock = DockStyle.Top
        Controls.Add(menu)

        Dim header As New Label() With {
            .Text = $"Welcome Administrator {displayName}",
            .Dock = DockStyle.Top,
            .Height = 56,
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.White,
            .BackColor = Color.FromArgb(183, 58, 46),
            .Padding = New Padding(16, 12, 16, 12)
        }
        Controls.Add(header)

        Dim body As New Label() With {
            .Text = "Use the Administrator menu to manage users, branches, settings and view system reports.",
            .Dock = DockStyle.Fill,
            .TextAlign = ContentAlignment.MiddleCenter,
            .Font = New Font("Segoe UI", 12, FontStyle.Regular)
        }
        Controls.Add(body)
    End Sub

    Private Sub OnOpenJournalsViewer(sender As Object, e As EventArgs)
        Using f As New JournalViewerForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenGLViewer(sender As Object, e As EventArgs)
        Using f As New GeneralLedgerViewerForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenStaffManagement(sender As Object, e As EventArgs)
        Using f As New StaffManagementForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenPayrollEntry(sender As Object, e As EventArgs)
        Using f As New PayrollEntryForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenPayrollJournal(sender As Object, e As EventArgs)
        Using f As New PayrollJournalForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenGLAccountMappings(sender As Object, e As EventArgs)
        Using f As New GLAccountMappingsForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenExpenseTypes(sender As Object, e As EventArgs)
        Using f As New Accounting.ExpenseTypesForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenExpenses(sender As Object, e As EventArgs)
        Using f As New Accounting.ExpensesForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenTrialBalance(sender As Object, e As EventArgs)
        Using f As New Accounting.TrialBalanceForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenAccountLedger(sender As Object, e As EventArgs)
        Using f As New Accounting.AccountLedgerForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenMainCashBook(sender As Object, e As EventArgs)
        Using f As New Accounting.MainCashBookForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub

    Private Sub OnOpenPettyCash(sender As Object, e As EventArgs)
        Using f As New Accounting.PettyCashForm()
            f.StartPosition = FormStartPosition.CenterParent
            f.ShowDialog(Me)
        End Using
    End Sub
End Class
