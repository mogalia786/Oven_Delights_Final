Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data
Imports System.Drawing.Printing

Public Class LedgerHierarchyForm
    Inherits Form

    Private ReadOnly _connectionString As String
    Private _currentView As String = "Categories"
    Private _currentCategory As String = ""
    Private _currentAccountID As Integer = 0
    Private _currentAccountCode As String = ""
    Private _currentAccountName As String = ""
    
    Private lblTitle As Label
    Private lblBreadcrumb As Label
    Private btnBack As Button
    Private btnPrint As Button
    Private dgvMain As DataGridView
    Private dtpFrom As DateTimePicker
    Private dtpTo As DateTimePicker
    Private pnlDateRange As Panel

    Public Sub New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        InitializeComponent()
    End Sub
    
    Protected Overrides Sub OnLoad(e As EventArgs)
        MyBase.OnLoad(e)
        LoadCategories()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "General Ledger - Hierarchical View"
        Me.Size = New Size(1400, 800)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.FromArgb(240, 240, 245)

        Dim pnlMain As New Panel With {.Dock = DockStyle.Fill, .Padding = New Padding(20)}

        ' Header Panel
        Dim pnlHeader As New Panel With {.Dock = DockStyle.Top, .Height = 120, .BackColor = Color.White}

        lblTitle = New Label With {
            .Text = "General Ledger",
            .Font = New Font("Segoe UI", 20, FontStyle.Bold),
            .Location = New Point(20, 15),
            .Size = New Size(400, 40),
            .ForeColor = Color.FromArgb(41, 128, 185)
        }

        lblBreadcrumb = New Label With {
            .Text = "All Journals",
            .Font = New Font("Segoe UI", 11),
            .Location = New Point(20, 60),
            .Size = New Size(800, 25),
            .ForeColor = Color.FromArgb(127, 140, 141)
        }

        btnBack = New Button With {
            .Text = "← Back",
            .Location = New Point(1100, 20),
            .Size = New Size(100, 35),
            .Font = New Font("Segoe UI", 10),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Visible = False
        }
        AddHandler btnBack.Click, AddressOf btnBack_Click

        btnPrint = New Button With {
            .Text = "Print",
            .Location = New Point(1220, 20),
            .Size = New Size(100, 35),
            .Font = New Font("Segoe UI", 10),
            .BackColor = Color.FromArgb(46, 204, 113),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat
        }
        AddHandler btnPrint.Click, AddressOf btnPrint_Click

        ' Date Range Panel
        pnlDateRange = New Panel With {
            .Location = New Point(20, 85),
            .Size = New Size(500, 30),
            .Visible = False
        }

        Dim lblFrom As New Label With {
            .Text = "From:",
            .Location = New Point(0, 5),
            .Size = New Size(50, 20)
        }

        dtpFrom = New DateTimePicker With {
            .Location = New Point(55, 0),
            .Size = New Size(150, 25),
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Today.AddMonths(-6)
        }
        AddHandler dtpFrom.ValueChanged, AddressOf DateRange_Changed

        Dim lblTo As New Label With {
            .Text = "To:",
            .Location = New Point(220, 5),
            .Size = New Size(30, 20)
        }

        dtpTo = New DateTimePicker With {
            .Location = New Point(255, 0),
            .Size = New Size(150, 25),
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Today
        }
        AddHandler dtpTo.ValueChanged, AddressOf DateRange_Changed

        pnlDateRange.Controls.AddRange({lblFrom, dtpFrom, lblTo, dtpTo})
        pnlHeader.Controls.AddRange({lblTitle, lblBreadcrumb, btnBack, btnPrint, pnlDateRange})

        ' Data Grid
        dgvMain = New DataGridView With {
            .Dock = DockStyle.Fill,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 10)
        }
        AddHandler dgvMain.CellDoubleClick, AddressOf dgvMain_CellDoubleClick

        pnlMain.Controls.AddRange({pnlHeader, dgvMain})
        Me.Controls.Add(pnlMain)
    End Sub

    Public Sub LoadCategories()
        _currentView = "Accounts"
        lblTitle.Text = "General Ledger - All Accounts"
        lblBreadcrumb.Text = "All Accounts"
        btnBack.Visible = False
        pnlDateRange.Visible = False

        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()

                ' Get all Chart of Accounts with balances from CORRECT data sources
                ' Accounts Payable (2100) → SupplierLedger
                ' Accounts Receivable (1200) → CustomerLedger  
                ' All other accounts → JournalDetails + GeneralLedger (POS)
                ' ONLY show top-level control accounts (exclude subsidiary ledgers)
                Dim sql As String = "
                    SELECT 
                        coa.AccountID,
                        coa.AccountCode,
                        coa.AccountName,
                        coa.AccountType,
                        CASE 
                            -- Accounts Payable: Get from SupplierLedger
                            WHEN coa.AccountCode = '2100' THEN 
                                ISNULL((SELECT SUM(CreditAmount - DebitAmount) FROM SupplierLedger), 0)
                            -- Accounts Receivable: Get from CustomerLedger
                            WHEN coa.AccountCode = '1200' THEN 
                                ISNULL((SELECT SUM(DebitAmount - CreditAmount) FROM CustomerLedger), 0)
                            -- Assets and Expenses: Debit balance from GeneralLedger
                            WHEN coa.AccountType IN ('Asset', 'Expense') THEN 
                                ISNULL((SELECT SUM(DebitAmount - CreditAmount) FROM GeneralLedger WHERE AccountID = coa.AccountID AND IsReversed = 0), 0)
                            -- Liabilities, Equity, Revenue: Credit balance from GeneralLedger
                            ELSE 
                                ISNULL((SELECT SUM(CreditAmount - DebitAmount) FROM GeneralLedger WHERE AccountID = coa.AccountID AND IsReversed = 0), 0)
                        END AS Balance
                    FROM ChartOfAccounts coa
                    WHERE coa.IsActive = 1
                      AND ISNULL(coa.IsSubsidiaryLedger, 0) = 0
                    ORDER BY coa.AccountCode"

                Dim dt As New DataTable()
                Using adapter As New SqlDataAdapter(sql, conn)
                    adapter.Fill(dt)
                End Using

                ' Debug output
                Debug.WriteLine($"LoadCategories: Returned {dt.Rows.Count} rows")
                If dt.Rows.Count > 0 Then
                    Debug.WriteLine($"First account: {dt.Rows(0)("AccountCode")} - {dt.Rows(0)("AccountName")}")
                End If

                If dgvMain Is Nothing Then
                    MessageBox.Show("DataGridView not initialized.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Return
                End If

                dgvMain.DataSource = dt

                ' Ensure grid shows from the top
                If dgvMain.Rows.Count > 0 Then
                    dgvMain.ClearSelection()
                    dgvMain.FirstDisplayedScrollingRowIndex = 0
                End If

                If dgvMain.Columns.Count > 0 Then
                    If dgvMain.Columns.Contains("AccountID") Then
                        dgvMain.Columns("AccountID").Visible = False
                    End If
                    
                    If dgvMain.Columns.Contains("AccountCode") Then
                        dgvMain.Columns("AccountCode").HeaderText = "Account Code"
                        dgvMain.Columns("AccountCode").Width = 150
                    End If
                    
                    If dgvMain.Columns.Contains("AccountName") Then
                        dgvMain.Columns("AccountName").HeaderText = "Account Name"
                        dgvMain.Columns("AccountName").Width = 400
                    End If
                    
                    If dgvMain.Columns.Contains("TotalDebit") Then
                        dgvMain.Columns("TotalDebit").HeaderText = "Total Debits"
                        dgvMain.Columns("TotalDebit").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("TotalDebit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("TotalDebit").Width = 150
                    End If
                    
                    If dgvMain.Columns.Contains("TotalCredit") Then
                        dgvMain.Columns("TotalCredit").HeaderText = "Total Credits"
                        dgvMain.Columns("TotalCredit").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("TotalCredit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("TotalCredit").Width = 150
                    End If
                    
                    If dgvMain.Columns.Contains("Balance") Then
                        dgvMain.Columns("Balance").HeaderText = "Balance"
                        dgvMain.Columns("Balance").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("Balance").DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                        dgvMain.Columns("Balance").Width = 150
                    End If
                End If

            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading accounts: {ex.Message}{Environment.NewLine}{Environment.NewLine}Stack Trace:{Environment.NewLine}{ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadLedgers(accountID As Integer, accountCode As String, accountName As String)
        _currentView = "Ledgers"
        _currentAccountID = accountID
        _currentAccountCode = accountCode
        _currentAccountName = accountName
        lblTitle.Text = $"Ledgers for {accountCode} - {accountName}"
        lblBreadcrumb.Text = $"All Accounts > {accountCode}"
        btnBack.Visible = True
        pnlDateRange.Visible = False

        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()

                ' Check if this account is a control account with subsidiary ledgers
                Dim isControlAccount As Boolean = False
                Dim checkSql As String = "SELECT IsControlAccount FROM ChartOfAccounts WHERE AccountID = @AccountID"
                Using cmd As New SqlCommand(checkSql, conn)
                    cmd.Parameters.AddWithValue("@AccountID", accountID)
                    Dim result = cmd.ExecuteScalar()
                    If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                        isControlAccount = CBool(result)
                    End If
                End Using

                Dim dt As New DataTable()
                
                ' If this is Accounts Payable (2100), get supplier ledgers
                If accountCode = "2100" OrElse (isControlAccount AndAlso accountCode.StartsWith("2") AndAlso accountName.ToLower().Contains("payable")) Then
                    Dim sql As String = "
                        SELECT 
                            sl.SupplierID AS LedgerID,
                            'Supplier' AS LedgerType,
                            sl.SupplierCode AS LedgerCode,
                            sl.SupplierName AS LedgerName,
                            ISNULL(SUM(sl.DebitAmount), 0) AS TotalDebit,
                            ISNULL(SUM(sl.CreditAmount), 0) AS TotalCredit,
                            ISNULL(MAX(sl.RunningBalance), 0) AS Balance
                        FROM SupplierLedger sl
                        GROUP BY sl.SupplierID, sl.SupplierCode, sl.SupplierName
                        ORDER BY sl.SupplierName"
                    
                    Using adapter As New SqlDataAdapter(sql, conn)
                        adapter.Fill(dt)
                    End Using
                
                ' If this is Accounts Receivable (1200), get customer ledgers
                ElseIf accountCode = "1200" OrElse (isControlAccount AndAlso accountCode.StartsWith("1") AndAlso accountName.ToLower().Contains("receivable")) Then
                    Dim sql As String = "
                        SELECT 
                            cl.CustomerID AS LedgerID,
                            'Customer' AS LedgerType,
                            cl.AccountNumber AS LedgerCode,
                            cl.CustomerName AS LedgerName,
                            ISNULL(SUM(cl.DebitAmount), 0) AS TotalDebit,
                            ISNULL(SUM(cl.CreditAmount), 0) AS TotalCredit,
                            ISNULL(MAX(cl.RunningBalance), 0) AS Balance
                        FROM CustomerLedger cl
                        GROUP BY cl.CustomerID, cl.AccountNumber, cl.CustomerName
                        ORDER BY cl.CustomerName"
                    
                    Using adapter As New SqlDataAdapter(sql, conn)
                        adapter.Fill(dt)
                    End Using
                
                Else
                    ' For other accounts, show journal entries directly
                    LoadTransactions(accountID, accountCode, accountName)
                    Return
                End If

                ' Bind data to grid
                dgvMain.DataSource = dt
                dgvMain.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None
                dgvMain.Visible = True
                dgvMain.BringToFront()

                If dgvMain.Columns.Count > 0 Then
                    If dgvMain.Columns.Contains("LedgerID") Then
                        dgvMain.Columns("LedgerID").Visible = False
                    End If
                    
                    If dgvMain.Columns.Contains("LedgerType") Then
                        dgvMain.Columns("LedgerType").HeaderText = "Type"
                        dgvMain.Columns("LedgerType").Width = 100
                    End If
                    
                    If dgvMain.Columns.Contains("LedgerCode") Then
                        dgvMain.Columns("LedgerCode").HeaderText = "Code"
                        dgvMain.Columns("LedgerCode").Width = 150
                    End If
                    
                    If dgvMain.Columns.Contains("LedgerName") Then
                        dgvMain.Columns("LedgerName").HeaderText = "Name"
                        dgvMain.Columns("LedgerName").Width = 400
                    End If
                    
                    If dgvMain.Columns.Contains("TotalDebit") Then
                        dgvMain.Columns("TotalDebit").HeaderText = "Total Debits"
                        dgvMain.Columns("TotalDebit").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("TotalDebit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("TotalDebit").Width = 150
                    End If
                    
                    If dgvMain.Columns.Contains("TotalCredit") Then
                        dgvMain.Columns("TotalCredit").HeaderText = "Total Credits"
                        dgvMain.Columns("TotalCredit").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("TotalCredit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("TotalCredit").Width = 150
                    End If
                    
                    If dgvMain.Columns.Contains("Balance") Then
                        dgvMain.Columns("Balance").HeaderText = "Balance"
                        dgvMain.Columns("Balance").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("Balance").DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                        dgvMain.Columns("Balance").Width = 150
                    End If
                End If

            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading ledgers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadTransactions(accountID As Integer, accountCode As String, accountName As String)
        _currentView = "Transactions"
        _currentAccountID = accountID
        lblTitle.Text = $"Ledger - {accountCode} - {accountName}"
        lblBreadcrumb.Text = $"All Categories > {_currentCategory} > {accountCode}"
        btnBack.Visible = True
        pnlDateRange.Visible = True

        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()

                ' Get all journal entries for this account from BOTH JournalDetails (ERP) and GeneralLedger (POS)
                Dim sql As String = "
                    SELECT 
                        jh.JournalID,
                        jh.JournalDate AS TransactionDate,
                        jh.JournalNumber AS Reference,
                        jh.Reference AS JournalRef,
                        jh.Description,
                        jd.Debit AS DebitAmount,
                        jd.Credit AS CreditAmount,
                        'ERP' AS Source
                    FROM JournalDetails jd
                    INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
                    WHERE jd.AccountID = @AccountID
                        AND jh.JournalDate BETWEEN @FromDate AND @ToDate
                    
                    UNION ALL
                    
                    SELECT 
                        gl.EntryID AS JournalID,
                        gl.TransactionDate,
                        gl.JournalEntryNumber AS Reference,
                        gl.ReferenceID AS JournalRef,
                        gl.Description,
                        gl.DebitAmount,
                        gl.CreditAmount,
                        'POS' AS Source
                    FROM GeneralLedger gl
                    WHERE gl.AccountID = @AccountID
                        AND gl.TransactionDate BETWEEN @FromDate AND @ToDate
                        AND gl.IsReversed = 0
                    
                    ORDER BY TransactionDate, JournalID"

                Dim dt As New DataTable()
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@AccountID", accountID)
                    cmd.Parameters.AddWithValue("@FromDate", dtpFrom.Value.Date)
                    cmd.Parameters.AddWithValue("@ToDate", dtpTo.Value.Date.AddDays(1).AddSeconds(-1))
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using

                ' Calculate running balance
                Dim balance As Decimal = 0
                dt.Columns.Add("Balance", GetType(Decimal))
                
                For Each row As DataRow In dt.Rows
                    Dim debit As Decimal = If(IsDBNull(row("DebitAmount")), 0, CDec(row("DebitAmount")))
                    Dim credit As Decimal = If(IsDBNull(row("CreditAmount")), 0, CDec(row("CreditAmount")))
                    
                    ' For assets and expenses, debit increases balance
                    If accountCode.StartsWith("1") OrElse accountCode.StartsWith("5") Then
                        balance += debit - credit
                    Else
                        ' For liabilities, equity, and income, credit increases balance
                        balance += credit - debit
                    End If
                    
                    row("Balance") = balance
                Next

                ' Insert opening balance row if there are transactions
                If dt.Rows.Count > 0 Then
                    Dim openingRow As DataRow = dt.NewRow()
                    openingRow("JournalID") = DBNull.Value
                    openingRow("TransactionDate") = dtpFrom.Value.Date
                    openingRow("Reference") = ""
                    openingRow("JournalRef") = ""
                    openingRow("Description") = "Opening Balance"
                    openingRow("DebitAmount") = 0
                    openingRow("CreditAmount") = 0
                    openingRow("Balance") = 0
                    dt.Rows.InsertAt(openingRow, 0)
                    
                    ' Recalculate balances
                    balance = 0
                    For i As Integer = 1 To dt.Rows.Count - 1
                        Dim row As DataRow = dt.Rows(i)
                        Dim debit As Decimal = If(IsDBNull(row("DebitAmount")), 0, CDec(row("DebitAmount")))
                        Dim credit As Decimal = If(IsDBNull(row("CreditAmount")), 0, CDec(row("CreditAmount")))
                        
                        If accountCode.StartsWith("1") OrElse accountCode.StartsWith("5") Then
                            balance += debit - credit
                        Else
                            balance += credit - debit
                        End If
                        
                        row("Balance") = balance
                    Next
                End If

                dgvMain.DataSource = dt
                dgvMain.Visible = True
                dgvMain.BringToFront()

                If dgvMain.Columns.Count > 0 Then
                    If dgvMain.Columns.Contains("JournalID") Then
                        dgvMain.Columns("JournalID").Visible = False
                    End If
                    
                    If dgvMain.Columns.Contains("TransactionDate") Then
                        dgvMain.Columns("TransactionDate").HeaderText = "Date"
                        dgvMain.Columns("TransactionDate").DefaultCellStyle.Format = "dd MMM yyyy"
                        dgvMain.Columns("TransactionDate").Width = 120
                    End If
                    
                    If dgvMain.Columns.Contains("Reference") Then
                        dgvMain.Columns("Reference").HeaderText = "Journal #"
                        dgvMain.Columns("Reference").Width = 150
                    End If
                    
                    If dgvMain.Columns.Contains("JournalRef") Then
                        dgvMain.Columns("JournalRef").HeaderText = "Reference"
                        dgvMain.Columns("JournalRef").Width = 150
                    End If
                    
                    If dgvMain.Columns.Contains("Source") Then
                        dgvMain.Columns("Source").HeaderText = "Source"
                        dgvMain.Columns("Source").Width = 80
                    End If
                    
                    If dgvMain.Columns.Contains("Description") Then
                        dgvMain.Columns("Description").HeaderText = "Description"
                        dgvMain.Columns("Description").Width = 400
                    End If
                    
                    If dgvMain.Columns.Contains("DebitAmount") Then
                        dgvMain.Columns("DebitAmount").HeaderText = "Debit"
                        dgvMain.Columns("DebitAmount").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("DebitAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("DebitAmount").Width = 120
                    End If
                    
                    If dgvMain.Columns.Contains("CreditAmount") Then
                        dgvMain.Columns("CreditAmount").HeaderText = "Credit"
                        dgvMain.Columns("CreditAmount").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("CreditAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("CreditAmount").Width = 120
                    End If
                    
                    If dgvMain.Columns.Contains("Balance") Then
                        dgvMain.Columns("Balance").HeaderText = "Balance"
                        dgvMain.Columns("Balance").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("Balance").DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                        dgvMain.Columns("Balance").Width = 150
                    End If

                    ' Highlight opening balance row
                    For Each row As DataGridViewRow In dgvMain.Rows
                        If row.Cells("Description").Value?.ToString().Contains("Opening Balance") Then
                            row.DefaultCellStyle.BackColor = Color.FromArgb(241, 196, 15)
                            row.DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                        End If
                    Next
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading transactions: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadLedgerDetails(ledgerID As Integer, ledgerType As String, ledgerName As String)
        _currentView = "LedgerDetails"
        lblTitle.Text = $"{ledgerType} Ledger - {ledgerName}"
        lblBreadcrumb.Text = $"All Accounts > Ledgers > {ledgerName}"
        btnBack.Visible = True
        pnlDateRange.Visible = False

        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()

                Dim dt As New DataTable()
                
                If ledgerType = "Supplier" Then
                    Dim sql As String = "
                        SELECT 
                            TransactionDate,
                            TransactionType,
                            ReferenceNumber AS Reference,
                            Description,
                            DebitAmount,
                            CreditAmount,
                            RunningBalance
                        FROM SupplierLedger
                        WHERE SupplierID = @LedgerID
                        ORDER BY TransactionDate, LedgerID"
                    
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@LedgerID", ledgerID)
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(dt)
                        End Using
                    End Using
                    
                ElseIf ledgerType = "Customer" Then
                    Dim sql As String = "
                        SELECT 
                            TransactionDate,
                            TransactionType,
                            ReferenceNumber AS Reference,
                            Description,
                            DebitAmount,
                            CreditAmount,
                            RunningBalance
                        FROM CustomerLedger
                        WHERE CustomerID = @LedgerID
                        ORDER BY TransactionDate, LedgerID"
                    
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@LedgerID", ledgerID)
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(dt)
                        End Using
                    End Using
                End If

                ' Add opening balance row if there are transactions
                If dt.Rows.Count > 0 Then
                    Dim openingRow As DataRow = dt.NewRow()
                    openingRow("TransactionDate") = If(dt.Rows.Count > 0, dt.Rows(0)("TransactionDate"), DateTime.Today)
                    openingRow("TransactionType") = ""
                    openingRow("Reference") = ""
                    openingRow("Description") = "Opening Balance"
                    openingRow("DebitAmount") = 0
                    openingRow("CreditAmount") = 0
                    openingRow("RunningBalance") = 0
                    dt.Rows.InsertAt(openingRow, 0)
                End If

                dgvMain.DataSource = dt
                dgvMain.Visible = True
                dgvMain.BringToFront()

                If dgvMain.Columns.Count > 0 Then
                    If dgvMain.Columns.Contains("TransactionDate") Then
                        dgvMain.Columns("TransactionDate").HeaderText = "Date"
                        dgvMain.Columns("TransactionDate").DefaultCellStyle.Format = "dd MMM yyyy"
                        dgvMain.Columns("TransactionDate").Width = 120
                    End If
                    
                    If dgvMain.Columns.Contains("TransactionType") Then
                        dgvMain.Columns("TransactionType").HeaderText = "Type"
                        dgvMain.Columns("TransactionType").Width = 100
                    End If
                    
                    If dgvMain.Columns.Contains("Reference") Then
                        dgvMain.Columns("Reference").HeaderText = "Reference"
                        dgvMain.Columns("Reference").Width = 150
                    End If
                    
                    If dgvMain.Columns.Contains("Description") Then
                        dgvMain.Columns("Description").HeaderText = "Description"
                        dgvMain.Columns("Description").Width = 400
                    End If
                    
                    If dgvMain.Columns.Contains("DebitAmount") Then
                        dgvMain.Columns("DebitAmount").HeaderText = "Debit"
                        dgvMain.Columns("DebitAmount").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("DebitAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("DebitAmount").Width = 120
                    End If
                    
                    If dgvMain.Columns.Contains("CreditAmount") Then
                        dgvMain.Columns("CreditAmount").HeaderText = "Credit"
                        dgvMain.Columns("CreditAmount").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("CreditAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("CreditAmount").Width = 120
                    End If
                    
                    If dgvMain.Columns.Contains("RunningBalance") Then
                        dgvMain.Columns("RunningBalance").HeaderText = "Balance"
                        dgvMain.Columns("RunningBalance").DefaultCellStyle.Format = "N2"
                        dgvMain.Columns("RunningBalance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        dgvMain.Columns("RunningBalance").DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                        dgvMain.Columns("RunningBalance").Width = 150
                    End If

                    ' Highlight opening balance row
                    For Each row As DataGridViewRow In dgvMain.Rows
                        If row.Cells("Description").Value?.ToString() = "Opening Balance" Then
                            row.DefaultCellStyle.BackColor = Color.FromArgb(241, 196, 15)
                            row.DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                        End If
                    Next
                End If

            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading ledger details: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvMain_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex < 0 Then Return

        Try
            If _currentView = "Accounts" Then
                Dim accountID = CInt(dgvMain.Rows(e.RowIndex).Cells("AccountID").Value)
                Dim accountCode = dgvMain.Rows(e.RowIndex).Cells("AccountCode").Value.ToString()
                Dim accountName = dgvMain.Rows(e.RowIndex).Cells("AccountName").Value.ToString()
                LoadLedgers(accountID, accountCode, accountName)
            ElseIf _currentView = "Ledgers" Then
                Dim ledgerID = CInt(dgvMain.Rows(e.RowIndex).Cells("LedgerID").Value)
                Dim ledgerType = dgvMain.Rows(e.RowIndex).Cells("LedgerType").Value.ToString()
                Dim ledgerName = dgvMain.Rows(e.RowIndex).Cells("LedgerName").Value.ToString()
                LoadLedgerDetails(ledgerID, ledgerType, ledgerName)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnBack_Click(sender As Object, e As EventArgs)
        Try
            Select Case _currentView
                Case "LedgerDetails"
                    ' Go back to ledgers list for this account
                    LoadLedgers(_currentAccountID, _currentAccountCode, _currentAccountName)
                Case "Transactions"
                    ' Go back to all accounts (transactions are shown directly for non-control accounts)
                    LoadCategories()
                Case "Ledgers"
                    ' Go back to all accounts
                    LoadCategories()
            End Select
        Catch ex As Exception
            MessageBox.Show($"Navigation error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnPrint_Click(sender As Object, e As EventArgs)
        Try
            If dgvMain.Rows.Count = 0 Then
                MessageBox.Show("No data to print.", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            ' Create DataTable from grid
            Dim dt As New DataTable()
            For Each col As DataGridViewColumn In dgvMain.Columns
                If col.Visible Then
                    dt.Columns.Add(col.HeaderText)
                End If
            Next

            For Each row As DataGridViewRow In dgvMain.Rows
                If Not row.IsNewRow Then
                    Dim dr = dt.NewRow()
                    Dim colIndex = 0
                    For i = 0 To dgvMain.Columns.Count - 1
                        If dgvMain.Columns(i).Visible Then
                            dr(colIndex) = If(row.Cells(i).Value, "")
                            colIndex += 1
                        End If
                    Next
                    dt.Rows.Add(dr)
                End If
            Next

            ' Print
            PrintLedgerReport(dt, lblTitle.Text, lblBreadcrumb.Text)
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub PrintLedgerReport(data As DataTable, title As String, subtitle As String)
        Dim printDoc As New PrintDocument()
        Dim currentPage As Integer = 1
        Dim currentRow As Integer = 0
        
        AddHandler printDoc.PrintPage, Sub(sender, e)
            Dim font As New Font("Arial", 9)
            Dim fontBold As New Font("Arial", 9, FontStyle.Bold)
            Dim fontTitle As New Font("Arial", 14, FontStyle.Bold)
            
            Dim yPos As Single = 50
            Dim leftMargin As Single = 50
            Dim rightMargin As Single = e.PageBounds.Width - 50
            
            ' Print title
            e.Graphics.DrawString(title, fontTitle, Brushes.Black, leftMargin, yPos)
            yPos += 35
            
            ' Print subtitle
            e.Graphics.DrawString(subtitle, fontBold, Brushes.Gray, leftMargin, yPos)
            yPos += 25
            
            ' Print date
            e.Graphics.DrawString($"Printed: {DateTime.Now:dd/MM/yyyy HH:mm}", font, Brushes.Black, leftMargin, yPos)
            yPos += 30
            
            ' Print column headers
            Dim colX As Single = leftMargin
            Dim colWidths As New List(Of Single)
            
            ' Calculate column widths
            Dim totalWidth = rightMargin - leftMargin
            Dim colWidth = totalWidth / data.Columns.Count
            
            For Each col As DataColumn In data.Columns
                e.Graphics.DrawString(col.ColumnName, fontBold, Brushes.Black, colX, yPos)
                colWidths.Add(colWidth)
                colX += colWidth
            Next
            yPos += 25
            
            ' Print separator line
            e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
            yPos += 10
            
            ' Print data rows
            While currentRow < data.Rows.Count AndAlso yPos < e.PageBounds.Height - 100
                Dim row = data.Rows(currentRow)
                colX = leftMargin
                
                For i = 0 To data.Columns.Count - 1
                    Dim value = If(row(i) IsNot DBNull.Value, row(i).ToString(), "")
                    
                    ' Right-align numeric values
                    If IsNumeric(value) Then
                        Dim valueSize = e.Graphics.MeasureString(value, font)
                        e.Graphics.DrawString(value, font, Brushes.Black, colX + colWidths(i) - valueSize.Width - 5, yPos)
                    Else
                        e.Graphics.DrawString(value, font, Brushes.Black, colX, yPos)
                    End If
                    
                    colX += colWidths(i)
                Next
                
                yPos += 20
                currentRow += 1
            End While
            
            ' Print page number
            e.Graphics.DrawString($"Page {currentPage}", font, Brushes.Black, rightMargin - 100, e.PageBounds.Height - 50)
            
            ' Check if more pages needed
            e.HasMorePages = (currentRow < data.Rows.Count)
            If e.HasMorePages Then
                currentPage += 1
            End If
        End Sub
        
        ' Show print preview
        Dim preview As New PrintPreviewDialog()
        preview.Document = printDoc
        preview.Width = 1000
        preview.Height = 700
        preview.ShowDialog()
    End Sub

    Private Sub DateRange_Changed(sender As Object, e As EventArgs)
        If _currentView = "Transactions" AndAlso _currentAccountID > 0 Then
            Dim accountCode = lblBreadcrumb.Text.Split(">"c).Last().Trim()
            Dim accountName = lblTitle.Text.Replace("Ledger - ", "").Replace(accountCode & " - ", "")
            LoadTransactions(_currentAccountID, accountCode, accountName)
        End If
    End Sub
End Class
