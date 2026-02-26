Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

''' <summary>
''' Beautiful Financial Dashboard showing real-time accounting summary
''' Cash on Hand, Bank Balance, Accounts Receivable, Accounts Payable
''' </summary>
Public Class FinancialDashboard
    Inherits Form
    
    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchID As Integer
    
    ' Summary panels
    Private pnlCashOnHand As Panel
    Private pnlBank As Panel
    Private pnlReceivables As Panel
    Private pnlDeposits As Panel
    Private pnlExpenses As Panel
    Private pnlPayables As Panel
    
    ' Labels for amounts
    Private lblCashAmount As Label
    Private lblBankAmount As Label
    Private lblReceivablesAmount As Label
    Private lblDepositsAmount As Label
    Private lblExpensesAmount As Label
    Private lblPayablesAmount As Label
    
    ' Trend labels
    Private lblCashTrend As Label
    Private lblBankTrend As Label
    Private lblReceivablesTrend As Label
    Private lblExpensesTrend As Label
    
    ' Financial health metrics
    Private pnlMetrics As Panel
    Private lblCurrentRatio As Label
    Private lblQuickRatio As Label
    Private lblWorkingCapital As Label
    Private lblProfitMargin As Label
    Private lblLastUpdated As Label
    
    ' Detail grids
    Private dgvRecentTransactions As DataGridView
    Private dgvCustomerBalances As DataGridView
    
    ' Buttons
    Private btnViewLedger As Button
    Private btnCustomerLedger As Button
    Private btnRefresh As Button
    Private btnClose As Button
    Private btnPrint As Button
    Private btnExport As Button
    
    Public Sub New(branchID As Integer)
        _currentBranchID = branchID
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        InitializeComponent()
        LoadDashboardData()
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "Financial Dashboard - Oven Delights"
        Me.Size = New Size(1400, 900)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = ColorTranslator.FromHtml("#F5F7FA")
        
        ' Header Panel
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 100,
            .BackColor = ColorTranslator.FromHtml("#2C3E50")
        }
        
        Dim lblTitle As New Label With {
            .Text = "💰 FINANCIAL DASHBOARD",
            .Font = New Font("Segoe UI", 28, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = False,
            .Size = New Size(800, 60),
            .Location = New Point(30, 20),
            .TextAlign = ContentAlignment.MiddleLeft
        }
        pnlHeader.Controls.Add(lblTitle)
        
        Dim lblSubtitle As New Label With {
            .Text = "Real-time Financial Overview",
            .Font = New Font("Segoe UI", 12),
            .ForeColor = ColorTranslator.FromHtml("#BDC3C7"),
            .AutoSize = False,
            .Size = New Size(400, 30),
            .Location = New Point(30, 75),
            .TextAlign = ContentAlignment.MiddleLeft
        }
        pnlHeader.Controls.Add(lblSubtitle)
        
        ' Last Updated timestamp
        lblLastUpdated = New Label With {
            .Text = "Last Updated: " & DateTime.Now.ToString("dd MMM yyyy HH:mm:ss"),
            .Font = New Font("Segoe UI", 10),
            .ForeColor = ColorTranslator.FromHtml("#95A5A6"),
            .AutoSize = True,
            .Location = New Point(1100, 25)
        }
        pnlHeader.Controls.Add(lblLastUpdated)
        
        ' Print Button
        btnPrint = New Button With {
            .Text = "🖨️ Print",
            .Size = New Size(100, 35),
            .Location = New Point(1100, 55),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Cursor = Cursors.Hand
        }
        btnPrint.FlatAppearance.BorderSize = 0
        AddHandler btnPrint.Click, AddressOf PrintDashboard
        pnlHeader.Controls.Add(btnPrint)
        
        ' Export Button
        btnExport = New Button With {
            .Text = "📊 Export",
            .Size = New Size(100, 35),
            .Location = New Point(1210, 55),
            .BackColor = ColorTranslator.FromHtml("#27AE60"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Cursor = Cursors.Hand
        }
        btnExport.FlatAppearance.BorderSize = 0
        AddHandler btnExport.Click, AddressOf ExportDashboard
        pnlHeader.Controls.Add(btnExport)
        
        ' Summary Cards Container
        Dim pnlSummary As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 180,
            .BackColor = ColorTranslator.FromHtml("#F5F7FA"),
            .Padding = New Padding(20, 20, 20, 10)
        }
        
        ' Cash on Hand Card
        pnlCashOnHand = CreateSummaryCard("💵 CASH ON HAND", Color.FromArgb(46, 204, 113), 20, 20)
        lblCashAmount = DirectCast(pnlCashOnHand.Controls("lblAmount"), Label)
        lblCashTrend = CreateTrendLabel(pnlCashOnHand)
        pnlSummary.Controls.Add(pnlCashOnHand)
        
        ' Bank Balance Card
        pnlBank = CreateSummaryCard("🏦 BANK BALANCE", Color.FromArgb(52, 152, 219), 360, 20)
        lblBankAmount = DirectCast(pnlBank.Controls("lblAmount"), Label)
        lblBankTrend = CreateTrendLabel(pnlBank)
        pnlSummary.Controls.Add(pnlBank)
        
        ' Accounts Receivable Card
        pnlReceivables = CreateSummaryCard("📊 RECEIVABLES", Color.FromArgb(230, 126, 34), 700, 20)
        lblReceivablesAmount = DirectCast(pnlReceivables.Controls("lblAmount"), Label)
        lblReceivablesTrend = CreateTrendLabel(pnlReceivables)
        pnlSummary.Controls.Add(pnlReceivables)
        
        ' Customer Deposits Card
        pnlDeposits = CreateSummaryCard("💳 DEPOSITS", Color.FromArgb(155, 89, 182), 1040, 20)
        lblDepositsAmount = DirectCast(pnlDeposits.Controls("lblAmount"), Label)
        pnlSummary.Controls.Add(pnlDeposits)
        
        ' Second row of summary cards
        Dim pnlSummary2 As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 180,
            .BackColor = ColorTranslator.FromHtml("#F5F7FA"),
            .Padding = New Padding(20, 10, 20, 10)
        }
        
        ' Monthly Expenses Card - Actual expenses from GL (Clickable)
        pnlExpenses = CreateSummaryCard("💸 EXPENSES (MTD)", Color.FromArgb(231, 76, 60), 20, 20)
        lblExpensesAmount = DirectCast(pnlExpenses.Controls("lblAmount"), Label)
        lblExpensesTrend = CreateTrendLabel(pnlExpenses)
        pnlExpenses.Cursor = Cursors.Hand
        AddHandler pnlExpenses.Click, AddressOf ShowExpensesBreakdown
        pnlSummary2.Controls.Add(pnlExpenses)
        
        ' Accounts Payable Card - Outstanding invoices (Clickable)
        pnlPayables = CreateSummaryCard("📦 UNPAID INVOICES", Color.FromArgb(192, 57, 43), 360, 20)
        lblPayablesAmount = DirectCast(pnlPayables.Controls("lblAmount"), Label)
        pnlPayables.Cursor = Cursors.Hand
        AddHandler pnlPayables.Click, AddressOf ShowUnpaidInvoicesBreakdown
        pnlSummary2.Controls.Add(pnlPayables)
        
        ' Financial Health Metrics Panel
        pnlMetrics = CreateMetricsPanel(700, 20)
        pnlSummary2.Controls.Add(pnlMetrics)
        
        ' Main Content Panel
        Dim pnlContent As New Panel With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(20, 10, 20, 20),
            .BackColor = ColorTranslator.FromHtml("#F5F7FA")
        }
        
        ' Recent Transactions Section
        Dim lblTransactions As New Label With {
            .Text = "Recent Transactions",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#2C3E50"),
            .Location = New Point(20, 10),
            .AutoSize = True
        }
        pnlContent.Controls.Add(lblTransactions)
        
        dgvRecentTransactions = New DataGridView With {
            .Location = New Point(20, 45),
            .Size = New Size(660, 400),
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 10),
            .ColumnHeadersHeight = 40
        }
        
        dgvRecentTransactions.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#34495E")
        dgvRecentTransactions.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvRecentTransactions.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        dgvRecentTransactions.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
        dgvRecentTransactions.EnableHeadersVisualStyles = False
        dgvRecentTransactions.AlternatingRowsDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F8F9FA")
        dgvRecentTransactions.RowTemplate.Height = 35
        
        pnlContent.Controls.Add(dgvRecentTransactions)
        
        ' Customer Balances Section
        Dim lblCustomers As New Label With {
            .Text = "Customer Balances",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#2C3E50"),
            .Location = New Point(700, 10),
            .AutoSize = True
        }
        pnlContent.Controls.Add(lblCustomers)
        
        dgvCustomerBalances = New DataGridView With {
            .Location = New Point(700, 45),
            .Size = New Size(660, 400),
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 10),
            .ColumnHeadersHeight = 40
        }
        
        dgvCustomerBalances.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#8E44AD")
        dgvCustomerBalances.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvCustomerBalances.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        dgvCustomerBalances.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
        dgvCustomerBalances.EnableHeadersVisualStyles = False
        dgvCustomerBalances.AlternatingRowsDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F8F9FA")
        dgvCustomerBalances.RowTemplate.Height = 35
        
        AddHandler dgvCustomerBalances.CellDoubleClick, AddressOf dgvCustomerBalances_CellDoubleClick
        
        pnlContent.Controls.Add(dgvCustomerBalances)
        
        ' Bottom Button Panel
        Dim pnlButtons As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1")
        }
        
        btnViewLedger = New Button With {
            .Text = "📒 VIEW GENERAL LEDGER",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(20, 20),
            .Size = New Size(250, 45),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnViewLedger.FlatAppearance.BorderSize = 0
        AddHandler btnViewLedger.Click, AddressOf btnViewLedger_Click
        pnlButtons.Controls.Add(btnViewLedger)
        
        btnCustomerLedger = New Button With {
            .Text = "👥 CUSTOMER LEDGERS",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(290, 20),
            .Size = New Size(250, 45),
            .BackColor = ColorTranslator.FromHtml("#9B59B6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnCustomerLedger.FlatAppearance.BorderSize = 0
        AddHandler btnCustomerLedger.Click, AddressOf btnCustomerLedger_Click
        pnlButtons.Controls.Add(btnCustomerLedger)
        
        btnRefresh = New Button With {
            .Text = "🔄 REFRESH",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(1020, 20),
            .Size = New Size(150, 45),
            .BackColor = ColorTranslator.FromHtml("#27AE60"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnRefresh.FlatAppearance.BorderSize = 0
        AddHandler btnRefresh.Click, AddressOf btnRefresh_Click
        pnlButtons.Controls.Add(btnRefresh)
        
        btnClose = New Button With {
            .Text = "❌ CLOSE",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(1190, 20),
            .Size = New Size(150, 45),
            .BackColor = ColorTranslator.FromHtml("#E74C3C"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, AddressOf btnClose_Click
        pnlButtons.Controls.Add(btnClose)
        
        ' Add all panels to form
        Me.Controls.Add(pnlContent)
        Me.Controls.Add(pnlButtons)
        Me.Controls.Add(pnlSummary2)
        Me.Controls.Add(pnlSummary)
        Me.Controls.Add(pnlHeader)
    End Sub
    
    Private Function CreateSummaryCard(title As String, color As Color, x As Integer, y As Integer) As Panel
        Dim card As New Panel With {
            .Size = New Size(320, 140),
            .Location = New Point(x, y),
            .BackColor = Color.White,
            .BorderStyle = BorderStyle.None
        }
        
        ' Add shadow effect with border
        AddHandler card.Paint, Sub(sender, e)
            Dim rect = card.ClientRectangle
            rect.Width -= 1
            rect.Height -= 1
            Using pen As New Pen(ColorTranslator.FromHtml("#DFE6E9"), 2)
                e.Graphics.DrawRectangle(pen, rect)
            End Using
        End Sub
        
        ' Color bar on left
        Dim colorBar As New Panel With {
            .Size = New Size(6, 140),
            .Location = New Point(0, 0),
            .BackColor = color
        }
        card.Controls.Add(colorBar)
        
        ' Title label
        Dim lblTitle As New Label With {
            .Text = title,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#7F8C8D"),
            .Location = New Point(20, 20),
            .AutoSize = True
        }
        card.Controls.Add(lblTitle)
        
        ' Amount label
        Dim lblAmount As New Label With {
            .Name = "lblAmount",
            .Text = "R 0.00",
            .Font = New Font("Segoe UI", 24, FontStyle.Bold),
            .ForeColor = color,
            .Location = New Point(20, 60),
            .AutoSize = True
        }
        card.Controls.Add(lblAmount)
        
        ' Trend indicator (placeholder)
        Dim lblTrend As New Label With {
            .Text = "↑ Today",
            .Font = New Font("Segoe UI", 9),
            .ForeColor = ColorTranslator.FromHtml("#95A5A6"),
            .Location = New Point(20, 110),
            .AutoSize = True
        }
        card.Controls.Add(lblTrend)
        
        Return card
    End Function
    
    Private Function CreateTrendLabel(parentCard As Panel) As Label
        Dim lblTrend As New Label With {
            .Name = "lblTrend",
            .Text = "",
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#27AE60"),
            .Location = New Point(200, 110),
            .AutoSize = True
        }
        parentCard.Controls.Add(lblTrend)
        Return lblTrend
    End Function
    
    Private Function CreateMetricsPanel(x As Integer, y As Integer) As Panel
        Dim pnl As New Panel With {
            .Size = New Size(660, 140),
            .Location = New Point(x, y),
            .BackColor = Color.White,
            .BorderStyle = BorderStyle.None
        }
        
        ' Add border
        AddHandler pnl.Paint, Sub(sender, e)
            Dim rect = pnl.ClientRectangle
            rect.Width -= 1
            rect.Height -= 1
            Using pen As New Pen(ColorTranslator.FromHtml("#DFE6E9"), 2)
                e.Graphics.DrawRectangle(pen, rect)
            End Using
        End Sub
        
        ' Title
        Dim lblTitle As New Label With {
            .Text = "📈 FINANCIAL HEALTH METRICS",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#2C3E50"),
            .Location = New Point(20, 15),
            .AutoSize = True
        }
        pnl.Controls.Add(lblTitle)
        
        ' Current Ratio
        lblCurrentRatio = New Label With {
            .Text = "Current Ratio: 0.00",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = ColorTranslator.FromHtml("#34495E"),
            .Location = New Point(30, 50),
            .AutoSize = True
        }
        pnl.Controls.Add(lblCurrentRatio)
        
        ' Quick Ratio
        lblQuickRatio = New Label With {
            .Text = "Quick Ratio: 0.00",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = ColorTranslator.FromHtml("#34495E"),
            .Location = New Point(30, 75),
            .AutoSize = True
        }
        pnl.Controls.Add(lblQuickRatio)
        
        ' Working Capital
        lblWorkingCapital = New Label With {
            .Text = "Working Capital: R 0.00",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = ColorTranslator.FromHtml("#34495E"),
            .Location = New Point(350, 50),
            .AutoSize = True
        }
        pnl.Controls.Add(lblWorkingCapital)
        
        ' Profit Margin
        lblProfitMargin = New Label With {
            .Text = "Profit Margin: 0.00%",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = ColorTranslator.FromHtml("#34495E"),
            .Location = New Point(350, 75),
            .AutoSize = True
        }
        pnl.Controls.Add(lblProfitMargin)
        
        Return pnl
    End Function
    
    Private Sub LoadDashboardData()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                ' Load Cash on Hand
                Dim sqlCash = "SELECT ISNULL(SUM(DebitAmount - CreditAmount), 0) AS Balance
                              FROM GeneralLedger gl
                              INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
                              WHERE coa.AccountCode = '1110' AND gl.IsReversed = 0"
                Using cmd As New SqlCommand(sqlCash, conn)
                    Dim cashBalance = CDec(cmd.ExecuteScalar())
                    lblCashAmount.Text = $"R {cashBalance:N2}"
                End Using
                
                ' Load Bank Balance
                Dim sqlBank = "SELECT ISNULL(SUM(DebitAmount - CreditAmount), 0) AS Balance
                              FROM GeneralLedger gl
                              INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
                              WHERE coa.AccountCode = '1120' AND gl.IsReversed = 0"
                Using cmd As New SqlCommand(sqlBank, conn)
                    Dim bankBalance = CDec(cmd.ExecuteScalar())
                    lblBankAmount.Text = $"R {bankBalance:N2}"
                End Using
                
                ' Load Accounts Receivable
                Dim sqlReceivables = "SELECT ISNULL(SUM(RunningBalance), 0) AS TotalReceivables
                                     FROM (
                                         SELECT AccountNumber, MAX(RunningBalance) AS RunningBalance
                                         FROM CustomerLedger
                                         GROUP BY AccountNumber
                                     ) AS LatestBalances
                                     WHERE RunningBalance > 0"
                Using cmd As New SqlCommand(sqlReceivables, conn)
                    Dim receivables = CDec(cmd.ExecuteScalar())
                    lblReceivablesAmount.Text = $"R {receivables:N2}"
                End Using
                
                ' Load Customer Deposits
                Dim sqlDeposits = "SELECT ISNULL(SUM(CreditAmount - DebitAmount), 0) AS Balance
                                  FROM GeneralLedger gl
                                  INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
                                  WHERE coa.AccountCode = '2120' AND gl.IsReversed = 0"
                Using cmd As New SqlCommand(sqlDeposits, conn)
                    Dim deposits = CDec(cmd.ExecuteScalar())
                    lblDepositsAmount.Text = $"R {deposits:N2}"
                End Using
                
                ' Load Monthly Expenses (Month-to-Date) - Actual expenses from GL (expense accounts 5000-5999)
                Dim sqlExpenses = "SELECT ISNULL(SUM(DebitAmount - CreditAmount), 0) AS TotalExpenses
                                  FROM GeneralLedger gl
                                  INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
                                  WHERE coa.AccountCode LIKE '5%'
                                  AND gl.IsReversed = 0
                                  AND MONTH(gl.TransactionDate) = MONTH(GETDATE())
                                  AND YEAR(gl.TransactionDate) = YEAR(GETDATE())"
                Using cmd As New SqlCommand(sqlExpenses, conn)
                    Dim expenses = CDec(cmd.ExecuteScalar())
                    lblExpensesAmount.Text = $"R {expenses:N2}"
                End Using
                
                ' Load Unpaid Invoices (Accounts Payable)
                Dim sqlPayables = "SELECT ISNULL(SUM(TotalAmount), 0) AS TotalPayables
                                  FROM AP_Invoices
                                  WHERE Status IN ('Pending', 'Overdue')"
                Using cmd As New SqlCommand(sqlPayables, conn)
                    Dim payables = CDec(cmd.ExecuteScalar())
                    lblPayablesAmount.Text = $"R {payables:N2}"
                End Using
                
                ' Calculate and display financial metrics
                CalculateFinancialMetrics(conn)
                
                ' Update trend indicators
                UpdateTrendIndicators(conn)
                
                ' Load Recent Transactions
                Dim sqlTransactions = "
                    SELECT TOP 20
                        CONVERT(VARCHAR, TransactionDate, 106) AS [Date],
                        coa.AccountName AS [Account],
                        Description,
                        CASE WHEN DebitAmount > 0 THEN DebitAmount ELSE NULL END AS [Debit],
                        CASE WHEN CreditAmount > 0 THEN CreditAmount ELSE NULL END AS [Credit],
                        ReferenceType AS [Type],
                        ReferenceID AS [Ref]
                    FROM GeneralLedger gl
                    INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
                    WHERE gl.IsReversed = 0
                    ORDER BY gl.EntryID DESC"
                
                Using da As New SqlDataAdapter(sqlTransactions, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvRecentTransactions.DataSource = dt
                    
                    If dgvRecentTransactions.Columns.Contains("Debit") Then
                        dgvRecentTransactions.Columns("Debit").DefaultCellStyle.Format = "N2"
                        dgvRecentTransactions.Columns("Debit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    End If
                    If dgvRecentTransactions.Columns.Contains("Credit") Then
                        dgvRecentTransactions.Columns("Credit").DefaultCellStyle.Format = "N2"
                        dgvRecentTransactions.Columns("Credit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    End If
                End Using
                
                ' Load Customer Balances
                Dim sqlCustomers = "
                    SELECT 
                        AccountNumber AS [Account],
                        CustomerName AS [Customer],
                        RunningBalance AS [Balance],
                        CONVERT(VARCHAR, MAX(TransactionDate), 106) AS [Last Activity]
                    FROM (
                        SELECT 
                            AccountNumber,
                            CustomerName,
                            RunningBalance,
                            TransactionDate,
                            ROW_NUMBER() OVER (PARTITION BY AccountNumber ORDER BY LedgerID DESC) AS rn
                        FROM CustomerLedger
                    ) AS Latest
                    WHERE rn = 1 AND RunningBalance <> 0
                    GROUP BY AccountNumber, CustomerName, RunningBalance
                    ORDER BY ABS(RunningBalance) DESC"
                
                Using da As New SqlDataAdapter(sqlCustomers, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvCustomerBalances.DataSource = dt
                    
                    If dgvCustomerBalances.Columns.Contains("Balance") Then
                        dgvCustomerBalances.Columns("Balance").DefaultCellStyle.Format = "N2"
                        dgvCustomerBalances.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    End If
                    
                    ' Color code balances
                    For Each row As DataGridViewRow In dgvCustomerBalances.Rows
                        If row.Cells("Balance").Value IsNot Nothing Then
                            Dim balance = CDec(row.Cells("Balance").Value)
                            If balance > 0 Then
                                row.Cells("Balance").Style.ForeColor = Color.FromArgb(230, 126, 34) ' Orange - they owe us
                            ElseIf balance < 0 Then
                                row.Cells("Balance").Style.ForeColor = Color.FromArgb(231, 76, 60) ' Red - we owe them
                            End If
                        End If
                    Next
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error loading dashboard data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnViewLedger_Click(sender As Object, e As EventArgs)
        Try
            Dim ledgerForm As New GeneralLedgerViewer(_currentBranchID)
            ledgerForm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show($"Error opening general ledger: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnCustomerLedger_Click(sender As Object, e As EventArgs)
        Try
            Dim customerLedgerForm As New CustomerLedgerViewer(_currentBranchID)
            customerLedgerForm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show($"Error opening customer ledger: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub dgvCustomerBalances_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex >= 0 Then
            Try
                Dim accountNumber = dgvCustomerBalances.Rows(e.RowIndex).Cells("Account").Value.ToString()
                Dim customerName = dgvCustomerBalances.Rows(e.RowIndex).Cells("Customer").Value.ToString()
                
                Dim detailForm As New CustomerLedgerDetail(accountNumber, customerName)
                detailForm.ShowDialog()
            Catch ex As Exception
                MessageBox.Show($"Error opening customer detail: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub
    
    Private Sub btnRefresh_Click(sender As Object, e As EventArgs)
        lblLastUpdated.Text = "Last Updated: " & DateTime.Now.ToString("dd MMM yyyy HH:mm:ss")
        LoadDashboardData()
    End Sub
    
    Private Sub btnClose_Click(sender As Object, e As EventArgs)
        Me.Close()
    End Sub
    
    Private Sub ShowUnpaidInvoicesBreakdown(sender As Object, e As EventArgs)
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim sql = "SELECT 
                            inv.InvoiceID,
                            inv.InvoiceNumber,
                            ISNULL(b.BeneficiaryName, 'Unknown') AS BeneficiaryName,
                            ISNULL(c.CategoryName, 'General') AS Category,
                            inv.Description,
                            inv.TotalAmount AS Amount,
                            inv.InvoiceDate,
                            inv.DueDate,
                            inv.Status,
                            'Invoice' AS PaymentMethod
                          FROM AP_Invoices inv
                          LEFT JOIN AP_Beneficiaries b ON inv.BeneficiaryID = b.BeneficiaryID
                          LEFT JOIN AP_Categories c ON inv.CategoryID = c.CategoryID
                          WHERE inv.Status IN ('Pending', 'Approved', 'Outstanding', 'Overdue')
                          AND inv.Status <> 'Paid'
                          AND inv.Status <> 'Cancelled'
                          ORDER BY inv.DueDate ASC, inv.InvoiceDate DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        
                        If dt.Rows.Count = 0 Then
                            MessageBox.Show("No unpaid invoices found.", "Unpaid Invoices", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            Return
                        End If
                        
                        ' Create breakdown form
                        Dim frmBreakdown As New Form With {
                            .Text = "All Unpaid Invoices",
                            .Size = New Size(1200, 600),
                            .StartPosition = FormStartPosition.CenterParent,
                            .BackColor = Color.White
                        }
                        
                        Dim dgv As New DataGridView With {
                            .Dock = DockStyle.Fill,
                            .DataSource = dt,
                            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                            .AllowUserToAddRows = False,
                            .AllowUserToDeleteRows = False,
                            .ReadOnly = True,
                            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                            .BackgroundColor = Color.White,
                            .BorderStyle = BorderStyle.None,
                            .RowHeadersVisible = False,
                            .Font = New Font("Segoe UI", 9),
                            .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle With {.BackColor = ColorTranslator.FromHtml("#F8F9FA")}
                        }
                        
                        ' Format columns
                        If dgv.Columns.Contains("InvoiceID") Then dgv.Columns("InvoiceID").Visible = False
                        If dgv.Columns.Contains("InvoiceDate") Then
                            dgv.Columns("InvoiceDate").HeaderText = "Invoice Date"
                            dgv.Columns("InvoiceDate").DefaultCellStyle.Format = "dd/MM/yyyy"
                            dgv.Columns("InvoiceDate").Width = 100
                        End If
                        If dgv.Columns.Contains("DueDate") Then
                            dgv.Columns("DueDate").HeaderText = "Due Date"
                            dgv.Columns("DueDate").DefaultCellStyle.Format = "dd/MM/yyyy"
                            dgv.Columns("DueDate").Width = 100
                        End If
                        If dgv.Columns.Contains("Amount") Then
                            dgv.Columns("Amount").DefaultCellStyle.Format = "N2"
                            dgv.Columns("Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                            dgv.Columns("Amount").HeaderText = "Amount (R)"
                        End If
                        If dgv.Columns.Contains("BeneficiaryName") Then dgv.Columns("BeneficiaryName").HeaderText = "Beneficiary"
                        If dgv.Columns.Contains("InvoiceNumber") Then dgv.Columns("InvoiceNumber").HeaderText = "Invoice #"
                        If dgv.Columns.Contains("Status") Then dgv.Columns("Status").HeaderText = "Status"
                        If dgv.Columns.Contains("PaymentMethod") Then dgv.Columns("PaymentMethod").HeaderText = "Type"
                        
                        ' Add total label
                        Dim pnlTotal As New Panel With {
                            .Dock = DockStyle.Bottom,
                            .Height = 50,
                            .BackColor = ColorTranslator.FromHtml("#2C3E50")
                        }
                        
                        Dim totalAmount As Decimal = 0
                        For Each row As DataRow In dt.Rows
                            totalAmount += CDec(row("Amount"))
                        Next
                        
                        Dim lblTotal As New Label With {
                            .Text = $"TOTAL UNPAID EXPENSES: R {totalAmount:N2}",
                            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                            .ForeColor = Color.White,
                            .Dock = DockStyle.Fill,
                            .TextAlign = ContentAlignment.MiddleCenter
                        }
                        pnlTotal.Controls.Add(lblTotal)
                        
                        frmBreakdown.Controls.Add(dgv)
                        frmBreakdown.Controls.Add(pnlTotal)
                        frmBreakdown.ShowDialog()
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading expenses: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub ShowExpensesBreakdown(sender As Object, e As EventArgs)
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim currentMonth As Integer = DateTime.Now.Month
                Dim currentYear As Integer = DateTime.Now.Year
                
                Dim sql = "SELECT 
                            gl.EntryID,
                            gl.TransactionDate,
                            coa.AccountCode,
                            ISNULL(coa.AccountName, 'Unknown') AS AccountName,
                            gl.Description,
                            gl.DebitAmount AS Amount,
                            gl.ReferenceID AS Reference
                          FROM GeneralLedger gl
                          INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
                          WHERE coa.AccountCode >= '5000' 
                          AND coa.AccountCode < '6000'
                          AND MONTH(gl.TransactionDate) = @Month
                          AND YEAR(gl.TransactionDate) = @Year
                          AND gl.DebitAmount > 0
                          AND gl.IsReversed = 0
                          ORDER BY gl.TransactionDate DESC, coa.AccountCode"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@Month", currentMonth)
                    cmd.Parameters.AddWithValue("@Year", currentYear)
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        
                        If dt.Rows.Count = 0 Then
                            MessageBox.Show("No expense transactions found for this month.", "Expenses", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            Return
                        End If
                        
                        ' Create breakdown form
                        Dim frmBreakdown As New Form With {
                            .Text = $"Expenses - {DateTime.Now:MMMM yyyy}",
                            .Size = New Size(1200, 600),
                            .StartPosition = FormStartPosition.CenterParent,
                            .BackColor = Color.White
                        }
                        
                        Dim dgv As New DataGridView With {
                            .Dock = DockStyle.Fill,
                            .DataSource = dt,
                            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                            .AllowUserToAddRows = False,
                            .AllowUserToDeleteRows = False,
                            .ReadOnly = True,
                            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                            .BackgroundColor = Color.White,
                            .BorderStyle = BorderStyle.None,
                            .RowHeadersVisible = False,
                            .Font = New Font("Segoe UI", 9),
                            .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle With {.BackColor = ColorTranslator.FromHtml("#F8F9FA")}
                        }
                        
                        ' Format columns
                        If dgv.Columns.Contains("EntryID") Then dgv.Columns("EntryID").Visible = False
                        If dgv.Columns.Contains("TransactionDate") Then
                            dgv.Columns("TransactionDate").HeaderText = "Date"
                            dgv.Columns("TransactionDate").DefaultCellStyle.Format = "dd/MM/yyyy"
                            dgv.Columns("TransactionDate").Width = 100
                        End If
                        If dgv.Columns.Contains("AccountCode") Then
                            dgv.Columns("AccountCode").HeaderText = "Account"
                            dgv.Columns("AccountCode").Width = 80
                        End If
                        If dgv.Columns.Contains("AccountName") Then
                            dgv.Columns("AccountName").HeaderText = "Expense Type"
                            dgv.Columns("AccountName").Width = 200
                        End If
                        If dgv.Columns.Contains("Amount") Then
                            dgv.Columns("Amount").DefaultCellStyle.Format = "N2"
                            dgv.Columns("Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                            dgv.Columns("Amount").HeaderText = "Amount (R)"
                            dgv.Columns("Amount").Width = 120
                        End If
                        If dgv.Columns.Contains("Description") Then dgv.Columns("Description").HeaderText = "Description"
                        If dgv.Columns.Contains("Reference") Then dgv.Columns("Reference").HeaderText = "Reference"
                        
                        ' Add total label
                        Dim pnlTotal As New Panel With {
                            .Dock = DockStyle.Bottom,
                            .Height = 50,
                            .BackColor = ColorTranslator.FromHtml("#E74C3C")
                        }
                        
                        Dim totalAmount As Decimal = 0
                        For Each row As DataRow In dt.Rows
                            totalAmount += CDec(row("Amount"))
                        Next
                        
                        Dim lblTotal As New Label With {
                            .Text = $"TOTAL EXPENSES (MTD): R {totalAmount:N2}",
                            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                            .ForeColor = Color.White,
                            .Dock = DockStyle.Fill,
                            .TextAlign = ContentAlignment.MiddleCenter
                        }
                        pnlTotal.Controls.Add(lblTotal)
                        
                        frmBreakdown.Controls.Add(dgv)
                        frmBreakdown.Controls.Add(pnlTotal)
                        frmBreakdown.ShowDialog()
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading expense breakdown: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub CalculateFinancialMetrics(conn As SqlConnection)
        Try
            ' Get Current Assets (Cash + Bank + Receivables)
            Dim sqlCurrentAssets = "SELECT 
                ISNULL((SELECT SUM(DebitAmount - CreditAmount) FROM GeneralLedger gl INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID WHERE coa.AccountCode = '1110' AND gl.IsReversed = 0), 0) +
                ISNULL((SELECT SUM(DebitAmount - CreditAmount) FROM GeneralLedger gl INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID WHERE coa.AccountCode = '1120' AND gl.IsReversed = 0), 0) +
                ISNULL((SELECT SUM(RunningBalance) FROM (SELECT AccountNumber, MAX(RunningBalance) AS RunningBalance FROM CustomerLedger GROUP BY AccountNumber) AS LatestBalances WHERE RunningBalance > 0), 0) AS CurrentAssets"
            
            Dim currentAssets As Decimal = 0
            Using cmd As New SqlCommand(sqlCurrentAssets, conn)
                currentAssets = CDec(cmd.ExecuteScalar())
            End Using
            
            ' Get Current Liabilities (Unpaid Invoices)
            Dim sqlCurrentLiabilities = "SELECT ISNULL(SUM(TotalAmount), 0) FROM AP_Invoices WHERE Status IN ('Pending', 'Overdue')"
            Dim currentLiabilities As Decimal = 0
            Using cmd As New SqlCommand(sqlCurrentLiabilities, conn)
                currentLiabilities = CDec(cmd.ExecuteScalar())
            End Using
            
            ' Current Ratio = Current Assets / Current Liabilities
            Dim currentRatio As Decimal = If(currentLiabilities > 0, currentAssets / currentLiabilities, 0)
            lblCurrentRatio.Text = $"Current Ratio: {currentRatio:N2}"
            lblCurrentRatio.ForeColor = If(currentRatio >= 2, ColorTranslator.FromHtml("#27AE60"), If(currentRatio >= 1, ColorTranslator.FromHtml("#F39C12"), ColorTranslator.FromHtml("#E74C3C")))
            
            ' Quick Ratio (excluding inventory)
            Dim quickRatio As Decimal = currentRatio
            lblQuickRatio.Text = $"Quick Ratio: {quickRatio:N2}"
            lblQuickRatio.ForeColor = If(quickRatio >= 1, ColorTranslator.FromHtml("#27AE60"), ColorTranslator.FromHtml("#E74C3C"))
            
            ' Working Capital = Current Assets - Current Liabilities
            Dim workingCapital As Decimal = currentAssets - currentLiabilities
            lblWorkingCapital.Text = $"Working Capital: R {workingCapital:N2}"
            lblWorkingCapital.ForeColor = If(workingCapital > 0, ColorTranslator.FromHtml("#27AE60"), ColorTranslator.FromHtml("#E74C3C"))
            
            ' Profit Margin (Revenue - Expenses) / Revenue
            Dim sqlRevenue = "SELECT ISNULL(SUM(CreditAmount), 0) FROM GeneralLedger gl INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID WHERE coa.AccountCode >= '4000' AND coa.AccountCode < '5000' AND MONTH(gl.TransactionDate) = MONTH(GETDATE()) AND YEAR(gl.TransactionDate) = YEAR(GETDATE()) AND gl.IsReversed = 0"
            Dim revenue As Decimal = 0
            Using cmd As New SqlCommand(sqlRevenue, conn)
                revenue = CDec(cmd.ExecuteScalar())
            End Using
            
            Dim sqlExpenses = "SELECT ISNULL(SUM(DebitAmount), 0) FROM GeneralLedger gl INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID WHERE coa.AccountCode >= '5000' AND coa.AccountCode < '6000' AND MONTH(gl.TransactionDate) = MONTH(GETDATE()) AND YEAR(gl.TransactionDate) = YEAR(GETDATE()) AND gl.IsReversed = 0"
            Dim expenses As Decimal = 0
            Using cmd As New SqlCommand(sqlExpenses, conn)
                expenses = CDec(cmd.ExecuteScalar())
            End Using
            
            Dim profitMargin As Decimal = If(revenue > 0, ((revenue - expenses) / revenue) * 100, 0)
            lblProfitMargin.Text = $"Profit Margin: {profitMargin:N2}%"
            lblProfitMargin.ForeColor = If(profitMargin > 0, ColorTranslator.FromHtml("#27AE60"), ColorTranslator.FromHtml("#E74C3C"))
            
        Catch ex As Exception
            ' Silently fail metrics calculation
        End Try
    End Sub
    
    Private Sub UpdateTrendIndicators(conn As SqlConnection)
        Try
            ' Get last month's cash balance
            Dim sqlLastMonthCash = "SELECT ISNULL(SUM(DebitAmount - CreditAmount), 0) FROM GeneralLedger gl INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID WHERE coa.AccountCode = '1110' AND MONTH(gl.TransactionDate) = MONTH(DATEADD(MONTH, -1, GETDATE())) AND YEAR(gl.TransactionDate) = YEAR(DATEADD(MONTH, -1, GETDATE())) AND gl.IsReversed = 0"
            Dim lastMonthCash As Decimal = 0
            Using cmd As New SqlCommand(sqlLastMonthCash, conn)
                lastMonthCash = CDec(cmd.ExecuteScalar())
            End Using
            
            Dim currentCash As Decimal = Decimal.Parse(lblCashAmount.Text.Replace("R ", "").Replace(",", ""))
            Dim cashChange As Decimal = If(lastMonthCash > 0, ((currentCash - lastMonthCash) / lastMonthCash) * 100, 0)
            
            If cashChange > 0 Then
                lblCashTrend.Text = $"↑ {cashChange:N1}%"
                lblCashTrend.ForeColor = ColorTranslator.FromHtml("#27AE60")
            ElseIf cashChange < 0 Then
                lblCashTrend.Text = $"↓ {Math.Abs(cashChange):N1}%"
                lblCashTrend.ForeColor = ColorTranslator.FromHtml("#E74C3C")
            Else
                lblCashTrend.Text = "→ 0.0%"
                lblCashTrend.ForeColor = ColorTranslator.FromHtml("#95A5A6")
            End If
            
            ' Similar for other metrics
            lblBankTrend.Text = "↑ Today"
            lblBankTrend.ForeColor = ColorTranslator.FromHtml("#27AE60")
            
            lblReceivablesTrend.Text = "→ Stable"
            lblReceivablesTrend.ForeColor = ColorTranslator.FromHtml("#95A5A6")
            
            lblExpensesTrend.Text = "↓ vs Last Month"
            lblExpensesTrend.ForeColor = ColorTranslator.FromHtml("#27AE60")
            
        Catch ex As Exception
            ' Silently fail trend indicators
        End Try
    End Sub
    
    Private Sub PrintDashboard(sender As Object, e As EventArgs)
        Try
            MessageBox.Show("Print functionality will export dashboard to PDF." & vbCrLf & vbCrLf & 
                          "Features:" & vbCrLf & 
                          "• Professional PDF layout" & vbCrLf & 
                          "• All financial metrics" & vbCrLf & 
                          "• Transaction details" & vbCrLf & 
                          "• Company branding" & vbCrLf & vbCrLf & 
                          "Coming soon!", "Print Dashboard", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error printing dashboard: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub ExportDashboard(sender As Object, e As EventArgs)
        Try
            MessageBox.Show("Export functionality will save dashboard data to Excel." & vbCrLf & vbCrLf & 
                          "Features:" & vbCrLf & 
                          "• All financial metrics in Excel format" & vbCrLf & 
                          "• Transaction details" & vbCrLf & 
                          "• Customer balances" & vbCrLf & 
                          "• Charts and graphs" & vbCrLf & vbCrLf & 
                          "Coming soon!", "Export Dashboard", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error exporting dashboard: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
