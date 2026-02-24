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
    
    ' Labels for amounts
    Private lblCashAmount As Label
    Private lblBankAmount As Label
    Private lblReceivablesAmount As Label
    Private lblDepositsAmount As Label
    
    ' Detail grids
    Private dgvRecentTransactions As DataGridView
    Private dgvCustomerBalances As DataGridView
    
    ' Buttons
    Private btnViewLedger As Button
    Private btnCustomerLedger As Button
    Private btnRefresh As Button
    Private btnClose As Button
    
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
        pnlSummary.Controls.Add(pnlCashOnHand)
        
        ' Bank Balance Card
        pnlBank = CreateSummaryCard("🏦 BANK BALANCE", Color.FromArgb(52, 152, 219), 360, 20)
        lblBankAmount = DirectCast(pnlBank.Controls("lblAmount"), Label)
        pnlSummary.Controls.Add(pnlBank)
        
        ' Accounts Receivable Card
        pnlReceivables = CreateSummaryCard("📊 RECEIVABLES", Color.FromArgb(230, 126, 34), 700, 20)
        lblReceivablesAmount = DirectCast(pnlReceivables.Controls("lblAmount"), Label)
        pnlSummary.Controls.Add(pnlReceivables)
        
        ' Customer Deposits Card
        pnlDeposits = CreateSummaryCard("💳 DEPOSITS", Color.FromArgb(155, 89, 182), 1040, 20)
        lblDepositsAmount = DirectCast(pnlDeposits.Controls("lblAmount"), Label)
        pnlSummary.Controls.Add(pnlDeposits)
        
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
        Me.Controls.Add(pnlSummary)
        Me.Controls.Add(pnlHeader)
        Me.Controls.Add(pnlButtons)
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
        LoadDashboardData()
    End Sub
    
    Private Sub btnClose_Click(sender As Object, e As EventArgs)
        Me.Close()
    End Sub
End Class
