Imports System.Windows.Forms
Imports System.Drawing
Imports System.Configuration

Namespace Accounting
    Public Class BankStatementViewerForm
        Inherits Form

        Private WithEvents btnFetch As Button
        Private WithEvents dgvTransactions As DataGridView
        Private dtpFromDate As DateTimePicker
        Private dtpToDate As DateTimePicker
        Private txtAccountId As TextBox
        Private txtLog As TextBox
        Private lblOpeningBalance As Label
        Private lblClosingBalance As Label
        Private _statementService As FNBStatementService
        Private _invoiceService As APInvoiceService

        Public Sub New()
            InitializeComponent()
            _statementService = New FNBStatementService()
            _invoiceService = New APInvoiceService()
            AddHandler _statementService.LogMessage, AddressOf OnLogMessage
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Bank Statement Viewer"
            Me.Size = New Size(1200, 700)
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            ' Header Panel
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 100,
                .BackColor = Color.FromArgb(52, 73, 94),
                .Padding = New Padding(20)
            }

            Dim lblTitle As New Label() With {
                .Text = "FNB Bank Statement Viewer",
                .Font = New Font("Segoe UI", 16, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 15)
            }
            pnlHeader.Controls.Add(lblTitle)

            ' Filter Panel
            Dim pnlFilter As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = Color.FromArgb(236, 240, 241),
                .Padding = New Padding(20, 10, 20, 10)
            }

            Dim lblAccount As New Label() With {
                .Text = "Account ID:",
                .Location = New Point(20, 25),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblAccount)

            ' Load business account number from credentials
            Dim businessAccount As String = "63001723469" ' Default
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    Using cmd As New SqlCommand("SELECT TOP 1 DebtorAccountNumber FROM FNB_APICredentials WHERE IsActive = 1 AND Environment = 'Sandbox'", conn)
                        Dim result = cmd.ExecuteScalar()
                        If result IsNot Nothing Then
                            businessAccount = result.ToString()
                        End If
                    End Using
                End Using
            Catch ex As Exception
                ' Use default if query fails
            End Try

            txtAccountId = New TextBox() With {
                .Location = New Point(100, 22),
                .Width = 150,
                .Text = businessAccount
            }
            pnlFilter.Controls.Add(txtAccountId)

            Dim lblFrom As New Label() With {
                .Text = "From:",
                .Location = New Point(270, 25),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblFrom)

            dtpFromDate = New DateTimePicker() With {
                .Location = New Point(320, 22),
                .Width = 120,
                .Format = DateTimePickerFormat.Short,
                .Value = DateTime.Now.AddDays(-7)
            }
            pnlFilter.Controls.Add(dtpFromDate)

            Dim lblTo As New Label() With {
                .Text = "To:",
                .Location = New Point(460, 25),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblTo)

            dtpToDate = New DateTimePicker() With {
                .Location = New Point(490, 22),
                .Width = 120,
                .Format = DateTimePickerFormat.Short,
                .Value = DateTime.Now
            }
            pnlFilter.Controls.Add(dtpToDate)

            btnFetch = New Button() With {
                .Text = "Fetch Statement",
                .Location = New Point(600, 22),
                .Size = New Size(150, 30),
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            pnlFilter.Controls.Add(btnFetch)

            ' Balance labels
            lblOpeningBalance = New Label() With {
                .Text = "Opening Balance: -",
                .Location = New Point(770, 25),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold),
                .ForeColor = Color.FromArgb(52, 73, 94)
            }
            pnlFilter.Controls.Add(lblOpeningBalance)

            lblClosingBalance = New Label() With {
                .Text = "Closing Balance: -",
                .Location = New Point(770, 50),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold),
                .ForeColor = Color.FromArgb(52, 73, 94)
            }
            pnlFilter.Controls.Add(lblClosingBalance)


            ' Split Container for Grid and Log
            Dim splitContainer As New SplitContainer() With {
                .Dock = DockStyle.Fill,
                .Orientation = Orientation.Vertical,
                .SplitterDistance = 350
            }

            ' Transactions Grid
            dgvTransactions = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False
            }
            splitContainer.Panel1.Controls.Add(dgvTransactions)

            ' Log Panel
            Dim pnlLog As New Panel() With {
                .Dock = DockStyle.Fill,
                .Padding = New Padding(10)
            }

            Dim lblLog As New Label() With {
                .Text = "Activity Log",
                .Dock = DockStyle.Top,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Height = 25
            }
            pnlLog.Controls.Add(lblLog)

            txtLog = New TextBox() With {
                .Dock = DockStyle.Fill,
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .BackColor = Color.FromArgb(44, 62, 80),
                .ForeColor = Color.FromArgb(236, 240, 241),
                .Font = New Font("Consolas", 9),
                .ReadOnly = True
            }
            pnlLog.Controls.Add(txtLog)

            splitContainer.Panel2.Controls.Add(pnlLog)

            Me.Controls.Add(splitContainer)
            Me.Controls.Add(pnlFilter)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub btnFetch_Click(sender As Object, e As EventArgs) Handles btnFetch.Click
            Try
                btnFetch.Enabled = False
                txtLog.Clear()
                OnLogMessage("Starting statement fetch...")

                Dim accountId = txtAccountId.Text.Trim()
                Dim fromDate = dtpFromDate.Value.Date
                Dim toDate = dtpToDate.Value.Date

                If String.IsNullOrEmpty(accountId) Then
                    MessageBox.Show("Please enter an account ID", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                ' Fetch statement from FNB API
                Dim statement = _statementService.FetchStatement(accountId, fromDate, toDate)

                ' Display balances
                If statement IsNot Nothing AndAlso statement.statement IsNot Nothing AndAlso statement.statement.balance IsNot Nothing Then
                    For Each bal In statement.statement.balance
                        If bal.typeCode = "OPBD" Then
                            lblOpeningBalance.Text = $"Opening Balance: {bal.creditDebitIndicator} R{bal.amountValue:N2}"
                            lblOpeningBalance.ForeColor = If(bal.creditDebitIndicator = "Credit", Color.Green, Color.Red)
                        ElseIf bal.typeCode = "CLBD" Then
                            lblClosingBalance.Text = $"Closing Balance: {bal.creditDebitIndicator} R{bal.amountValue:N2}"
                            lblClosingBalance.ForeColor = If(bal.creditDebitIndicator = "Credit", Color.Green, Color.Red)
                        End If
                    Next
                End If

                ' Save to database
                Dim savedCount = _statementService.SaveStatementToDatabase(statement, AppSession.CurrentUser.Username)

                OnLogMessage("")
                OnLogMessage("========================================")
                OnLogMessage("AUTO-PROCESSING STATEMENT")
                OnLogMessage("========================================")

                ' STEP 1: Auto-map all unmapped transactions
                Dim mappedCount As Integer = 0
                Dim postedCount As Integer = 0
                Dim skippedCount As Integer = 0

                OnLogMessage("STEP 1: Auto-mapping transactions...")
                Dim connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

                Using conn As New SqlConnection(connectionString)
                    conn.Open()

                    Dim sqlUnmapped As String = "SELECT TransactionID FROM AP_StatementTransactions WHERE (IsMapped = 0 OR IsMapped IS NULL) AND (IsReconciled = 0 OR IsReconciled IS NULL) ORDER BY TransactionDate ASC"
                    Using cmd As New SqlCommand(sqlUnmapped, conn)
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            Dim unmappedTxns As New List(Of Integer)
                            While reader.Read()
                                unmappedTxns.Add(reader.GetInt32(0))
                            End While
                            reader.Close()

                            For Each txnId In unmappedTxns
                                Try
                                    Using cmdMap As New SqlCommand("sp_BankStatement_AutoMapWithRules", conn)
                                        cmdMap.CommandType = CommandType.StoredProcedure
                                        cmdMap.Parameters.AddWithValue("@TransactionID", txnId)
                                        cmdMap.ExecuteNonQuery()
                                        mappedCount += 1
                                    End Using
                                Catch ex As Exception
                                    OnLogMessage($"  Error mapping {txnId}: {ex.Message}")
                                    skippedCount += 1
                                End Try
                            Next
                        End Using
                    End Using

                    OnLogMessage($"  Mapped: {mappedCount} | Skipped: {skippedCount}")
                    OnLogMessage("")
                    OnLogMessage("STEP 2: Posting to General Ledger (Accrual Method)...")

                    ' STEP 2: Post all mapped but not reconciled transactions to GL using accrual method
                    Dim sqlMapped As String = "
                        SELECT TransactionID, TransactionDate, Description, Reference, Amount, CreditDebitIndicator
                        FROM AP_StatementTransactions
                        WHERE IsMapped = 1 AND (IsReconciled = 0 OR IsReconciled IS NULL)
                        ORDER BY TransactionDate, TransactionID"

                    Using cmd As New SqlCommand(sqlMapped, conn)
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            Dim transactions As New List(Of Object)

                            While reader.Read()
                                transactions.Add(New With {
                                    .TransactionID = reader.GetInt32(0),
                                    .TransactionDate = reader.GetDateTime(1),
                                    .Description = reader.GetString(2),
                                    .Reference = If(reader.IsDBNull(3), "", reader.GetString(3)),
                                    .Amount = reader.GetDecimal(4),
                                    .TransactionType = reader.GetString(5)
                                })
                            End While
                            reader.Close()

                            For Each trans In transactions
                                Try
                                    If trans.TransactionType = "Debit" Then
                                        ' DEBIT = Payment out (Complete accrual: DR AP / CR Bank)
                                        Dim invoiceNumber As String = ExtractInvoiceNumber(trans.Reference)
                                        Dim supplierName As String = trans.Description

                                        Using cmdPost As New SqlCommand("sp_BankStatement_CompletePayment", conn)
                                            cmdPost.CommandType = CommandType.StoredProcedure
                                            cmdPost.Parameters.AddWithValue("@TransactionID", trans.TransactionID)
                                            cmdPost.Parameters.AddWithValue("@TransactionDate", trans.TransactionDate)
                                            cmdPost.Parameters.AddWithValue("@Amount", trans.Amount)
                                            cmdPost.Parameters.AddWithValue("@Description", trans.Description)
                                            cmdPost.Parameters.AddWithValue("@Reference", trans.Reference)
                                            cmdPost.Parameters.AddWithValue("@SupplierName", supplierName)
                                            cmdPost.Parameters.AddWithValue("@PostedBy", If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 1))
                                            cmdPost.ExecuteNonQuery()
                                            postedCount += 1
                                        End Using

                                    ElseIf trans.TransactionType = "Credit" Then
                                        ' CREDIT = Receipt in (Complete accrual: DR Bank / CR AR)
                                        Using cmdPost As New SqlCommand("sp_BankStatement_CompleteReceipt", conn)
                                            cmdPost.CommandType = CommandType.StoredProcedure
                                            cmdPost.Parameters.AddWithValue("@TransactionID", trans.TransactionID)
                                            cmdPost.Parameters.AddWithValue("@TransactionDate", trans.TransactionDate)
                                            cmdPost.Parameters.AddWithValue("@Amount", trans.Amount)
                                            cmdPost.Parameters.AddWithValue("@Description", trans.Description)
                                            cmdPost.Parameters.AddWithValue("@CustomerName", trans.Description)
                                            cmdPost.Parameters.AddWithValue("@Reference", trans.Reference)
                                            cmdPost.Parameters.AddWithValue("@PostedBy", If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 1))
                                            cmdPost.ExecuteNonQuery()
                                            postedCount += 1
                                        End Using
                                    End If
                                Catch ex As Exception
                                    OnLogMessage($"  Error posting {trans.Description}: {ex.Message}")
                                End Try
                            Next
                        End Using
                    End Using
                End Using

                OnLogMessage($"  Posted to GL: {postedCount}")
                OnLogMessage("========================================")
                OnLogMessage("PROCESSING COMPLETE")
                OnLogMessage("========================================")

                ' Load transactions into grid
                LoadTransactions()

                MessageBox.Show($"Statement processed successfully!{Environment.NewLine}{Environment.NewLine}Fetched: {savedCount} transactions{Environment.NewLine}Mapped: {mappedCount}{Environment.NewLine}Posted to GL: {postedCount}{Environment.NewLine}Skipped: {skippedCount}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Catch ex As Exception
                OnLogMessage($"ERROR: {ex.Message}")
                MessageBox.Show($"Error fetching statement: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Finally
                btnFetch.Enabled = True
            End Try
        End Sub

        Private Sub LoadTransactions()
            Try
                ' Load ALL transactions (not just unmapped)
                Dim dt As New DataTable()
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()

                    ' Load opening and closing balances from database
                    Dim sqlBalances As String = "
                        SELECT TOP 1 
                            MAX(CASE WHEN BalanceType = 'OPBD' THEN Amount END) AS OpeningBalance,
                            MAX(CASE WHEN BalanceType = 'OPBD' THEN CreditDebitIndicator END) AS OpeningIndicator,
                            MAX(CASE WHEN BalanceType = 'CLBD' THEN Amount END) AS ClosingBalance,
                            MAX(CASE WHEN BalanceType = 'CLBD' THEN CreditDebitIndicator END) AS ClosingIndicator
                        FROM AP_StatementBalances
                        WHERE AccountNumber = @AccountNumber
                            AND Amount > 0
                        GROUP BY BalanceDate
                        ORDER BY BalanceDate DESC"

                    Using cmdBal As New SqlCommand(sqlBalances, conn)
                        cmdBal.Parameters.AddWithValue("@AccountNumber", txtAccountId.Text.Trim())
                        Using reader As SqlDataReader = cmdBal.ExecuteReader()
                            If reader.Read() Then
                                If Not reader.IsDBNull(0) Then
                                    Dim openingBal = reader.GetDecimal(0)
                                    Dim openingInd = If(reader.IsDBNull(1), "Debit", reader.GetString(1))
                                    lblOpeningBalance.Text = $"Opening Balance: {openingInd} R{openingBal:N2}"
                                    lblOpeningBalance.ForeColor = If(openingInd = "Credit", Color.Green, Color.Red)
                                End If

                                If Not reader.IsDBNull(2) Then
                                    Dim closingBal = reader.GetDecimal(2)
                                    Dim closingInd = If(reader.IsDBNull(3), "Debit", reader.GetString(3))
                                    lblClosingBalance.Text = $"Closing Balance: {closingInd} R{closingBal:N2}"
                                    lblClosingBalance.ForeColor = If(closingInd = "Credit", Color.Green, Color.Red)
                                End If
                            End If
                        End Using
                    End Using

                    ' Calculate running balances first
                    Dim cmdCalc As New SqlCommand("EXEC sp_CalculateStatementRunningBalances @AccountNumber", conn)
                    cmdCalc.Parameters.AddWithValue("@AccountNumber", txtAccountId.Text.Trim())
                    cmdCalc.ExecuteNonQuery()

                    Dim sql As String = "
                        SELECT 
                            t.TransactionID,
                            t.TransactionDate AS [Date],
                            t.Description,
                            t.Reference,
                            CASE WHEN t.CreditDebitIndicator IN ('Debit', 'DBIT') THEN t.Amount ELSE 0 END AS [Debit],
                            CASE WHEN t.CreditDebitIndicator IN ('Credit', 'CRDT') THEN t.Amount ELSE 0 END AS [Credit],
                            ISNULL(t.RunningBalance, 0.00) AS [Balance],
                            t.RelatedPartyName AS [Party],
                            CASE WHEN t.IsReconciled = 1 THEN 'Yes' ELSE 'No' END AS [Posted to GL],
                            CASE WHEN ISNULL(t.IsMapped, 0) = 1 THEN 'Yes' ELSE 'No' END AS [Mapped],
                            t.CreditDebitIndicator AS [Indicator]
                        FROM AP_StatementTransactions t
                        WHERE t.AccountNumber = @AccountNumber
                        ORDER BY t.TransactionDate ASC, t.TransactionID ASC"

                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@AccountNumber", txtAccountId.Text.Trim())
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(dt)
                        End Using
                    End Using

                End Using

                dgvTransactions.DataSource = dt

                If dgvTransactions.Columns.Count > 0 Then
                    ' Hide TransactionID
                    dgvTransactions.Columns("TransactionID").Visible = False

                    ' Format columns like a professional bank statement
                    dgvTransactions.Columns("Date").Width = 100
                    dgvTransactions.Columns("Date").DefaultCellStyle.Format = "dd MMM yyyy"

                    dgvTransactions.Columns("Description").Width = 250
                    dgvTransactions.Columns("Description").DefaultCellStyle.WrapMode = DataGridViewTriState.True

                    dgvTransactions.Columns("Reference").Width = 120

                    dgvTransactions.Columns("Debit").Width = 100
                    dgvTransactions.Columns("Debit").DefaultCellStyle.Format = "R #,##0.00"
                    dgvTransactions.Columns("Debit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    dgvTransactions.Columns("Debit").HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleRight

                    dgvTransactions.Columns("Credit").Width = 100
                    dgvTransactions.Columns("Credit").DefaultCellStyle.Format = "R #,##0.00"
                    dgvTransactions.Columns("Credit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    dgvTransactions.Columns("Credit").HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleRight
                    dgvTransactions.Columns("Credit").DefaultCellStyle.ForeColor = Color.Green

                    dgvTransactions.Columns("Balance").Width = 120
                    dgvTransactions.Columns("Balance").DefaultCellStyle.Format = "R #,##0.00"
                    dgvTransactions.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    dgvTransactions.Columns("Balance").HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleRight
                    dgvTransactions.Columns("Balance").DefaultCellStyle.Font = New Font(dgvTransactions.Font, FontStyle.Bold)

                    dgvTransactions.Columns("Party").Width = 150
                    dgvTransactions.Columns("Posted to GL").Width = 80
                    dgvTransactions.Columns("Mapped").Width = 60

                    ' Color code rows based on posting status
                    For Each row As DataGridViewRow In dgvTransactions.Rows
                        If row.Cells("Posted to GL").Value.ToString() = "Yes" Then
                            row.DefaultCellStyle.BackColor = Color.LightGreen
                        ElseIf row.Cells("Mapped").Value.ToString() = "Yes" Then
                            row.DefaultCellStyle.BackColor = Color.LightYellow
                        Else
                            row.DefaultCellStyle.BackColor = Color.White
                        End If

                        ' Color balance based on positive/negative
                        Dim balance = CDec(row.Cells("Balance").Value)
                        If balance < 0 Then
                            row.Cells("Balance").Style.ForeColor = Color.Red
                        Else
                            row.Cells("Balance").Style.ForeColor = Color.Green
                        End If
                    Next
                End If

                If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                    Dim unmappedCount As Integer = 0
                    Try
                        If dt.Columns.Contains("Mapped") Then
                            For Each row As DataRow In dt.Rows
                                If Not row.IsNull("Mapped") AndAlso row("Mapped").ToString() = "No" Then
                                    unmappedCount += 1
                                End If
                            Next
                        End If
                    Catch
                        ' Ignore errors in unmapped count calculation
                    End Try
                    OnLogMessage($"Loaded {dt.Rows.Count} transactions ({unmappedCount} unmapped)")
                Else
                    OnLogMessage("No transactions loaded")
                End If
            Catch ex As Exception
                OnLogMessage($"Error loading transactions: {ex.Message}")
                If ex.InnerException IsNot Nothing Then
                    OnLogMessage($"Inner exception: {ex.InnerException.Message}")
                End If
            End Try
        End Sub

        Private Sub btnPostCredits_Click(sender As Object, e As EventArgs)
            Try
                Dim postedCount As Integer = 0
                Dim skippedCount As Integer = 0
                
                OnLogMessage("Posting credit transactions to ledgers...")
                
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    
                    ' Get all unposted credit transactions
                    Dim sql As String = "SELECT TransactionID, Amount, Description, CreditDebitIndicator FROM AP_StatementTransactions WHERE CreditDebitIndicator = 'Credit' AND (IsReconciled = 0 OR IsReconciled IS NULL) ORDER BY TransactionDate ASC"
                    Using cmd As New SqlCommand(sql, conn)
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            Dim transactions As New List(Of Tuple(Of Integer, Decimal, String))
                            
                            While reader.Read()
                                transactions.Add(New Tuple(Of Integer, Decimal, String)(
                                    reader.GetInt32(0),
                                    reader.GetDecimal(1),
                                    If(reader.IsDBNull(2), "", reader.GetString(2))
                                ))
                            End While
                            reader.Close()
                            
                            ' Post each credit transaction
                            For Each txn In transactions
                                OnLogMessage($"Posting credit transaction {txn.Item1} (R{txn.Item2:N2})...")
                                
                                Try
                                    Using cmdPost As New SqlCommand("sp_PostCreditTransactionsToLedgers", conn)
                                        cmdPost.CommandType = CommandType.StoredProcedure
                                        cmdPost.Parameters.AddWithValue("@TransactionID", txn.Item1)
                                        cmdPost.Parameters.AddWithValue("@PostedBy", AppSession.CurrentUser.Username)
                                        
                                        cmdPost.ExecuteNonQuery()
                                        postedCount += 1
                                        OnLogMessage($"✓ Posted transaction {txn.Item1} to Bank and Cash on Hand ledgers")
                                    End Using
                                Catch ex As Exception
                                    skippedCount += 1
                                    OnLogMessage($"✗ Failed to post transaction {txn.Item1}: {ex.Message}")
                                End Try
                            Next
                        End Using
                    End Using
                End Using
                
                LoadTransactions()
                MessageBox.Show($"Credit posting complete!{Environment.NewLine}{Environment.NewLine}Posted: {postedCount}{Environment.NewLine}Skipped: {skippedCount}", "Posting Results", MessageBoxButtons.OK, MessageBoxIcon.Information)
                
            Catch ex As Exception
                OnLogMessage($"ERROR: {ex.Message}")
                MessageBox.Show($"Error posting credits: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnProcessStatement_Click(sender As Object, e As EventArgs)
            Try
                ' ACCRUAL MODEL: Process mapped transactions and complete double-entry
                Dim connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Dim processedCount As Integer = 0
                Dim errorCount As Integer = 0
                
                OnLogMessage("========================================")
                OnLogMessage("PROCESSING BANK STATEMENT (ACCRUAL MODEL)")
                OnLogMessage("========================================")
                
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    
                    ' Get all mapped but not reconciled transactions
                    Dim sql As String = "
                        SELECT 
                            TransactionID,
                            TransactionDate,
                            Description,
                            Reference,
                            Amount,
                            CreditDebitIndicator,
                            MappedLedgerAccount
                        FROM AP_StatementTransactions
                        WHERE IsMapped = 1 
                            AND IsReconciled = 0
                        ORDER BY TransactionDate, TransactionID"
                    
                    Using cmd As New SqlCommand(sql, conn)
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            Dim transactions As New List(Of Object)
                            
                            While reader.Read()
                                transactions.Add(New With {
                                    .TransactionID = reader.GetInt32(0),
                                    .TransactionDate = reader.GetDateTime(1),
                                    .Description = reader.GetString(2),
                                    .Reference = If(reader.IsDBNull(3), "", reader.GetString(3)),
                                    .Amount = reader.GetDecimal(4),
                                    .CreditDebitIndicator = If(reader.IsDBNull(5), "", reader.GetString(5)),
                                    .MappedLedgerAccount = If(reader.IsDBNull(6), "", reader.GetString(6))
                                })
                            End While
                            
                            reader.Close()
                            
                            ' Process each transaction
                            For Each trans In transactions
                                Try
                                    OnLogMessage($"Processing: {trans.Description} - R{trans.Amount:N2}")
                                    
                                    ' Determine transaction type from FNB codes or CreditDebitIndicator
                                    ' FNB: PMT = Payment OUT, COLL = Collection IN
                                    ' FNB API: DBIT/Debit = Money OUT, CRDT/Credit = Money IN
                                    Dim isPaymentOut As Boolean = False
                                    
                                    If trans.Reference.Contains("PMT") OrElse trans.Reference.Contains("PAYMENT") Then
                                        isPaymentOut = True
                                    ElseIf trans.Reference.Contains("COLL") OrElse trans.Reference.Contains("COLLECTION") Then
                                        isPaymentOut = False
                                    ElseIf trans.CreditDebitIndicator = "DBIT" OrElse trans.CreditDebitIndicator = "Debit" Then
                                        isPaymentOut = True
                                    ElseIf trans.CreditDebitIndicator = "CRDT" OrElse trans.CreditDebitIndicator = "Credit" Then
                                        isPaymentOut = False
                                    End If
                                    
                                    If isPaymentOut Then
                                        ' Payment OUT (DR AP / CR Bank)
                                        ' Extract supplier/invoice info from reference
                                        Dim invoiceNumber As String = ExtractInvoiceNumber(trans.Reference)
                                        Dim supplierName As String = trans.Description
                                        
                                        ' Call sp_BankStatement_CompletePayment
                                        Using cmdPost As New SqlCommand("sp_BankStatement_CompletePayment", conn)
                                            cmdPost.CommandType = CommandType.StoredProcedure
                                            cmdPost.Parameters.AddWithValue("@TransactionID", trans.TransactionID)
                                            cmdPost.Parameters.AddWithValue("@Amount", trans.Amount)
                                            cmdPost.Parameters.AddWithValue("@SupplierName", supplierName)
                                            cmdPost.Parameters.AddWithValue("@InvoiceNumber", If(String.IsNullOrEmpty(invoiceNumber), trans.Reference, invoiceNumber))
                                            cmdPost.Parameters.AddWithValue("@PostedBy", If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 1))
                                            
                                            cmdPost.ExecuteNonQuery()
                                            processedCount += 1
                                            OnLogMessage($"  ✓ Payment completed: DR AP / CR Bank")
                                        End Using
                                        
                                    Else
                                        ' Receipt IN (DR Bank / CR AR)
                                        ' Extract customer info from reference
                                        Dim customerName As String = trans.Description
                                        
                                        ' Call sp_BankStatement_CompleteReceipt
                                        Using cmdPost As New SqlCommand("sp_BankStatement_CompleteReceipt", conn)
                                            cmdPost.CommandType = CommandType.StoredProcedure
                                            cmdPost.Parameters.AddWithValue("@TransactionID", trans.TransactionID)
                                            cmdPost.Parameters.AddWithValue("@Amount", trans.Amount)
                                            cmdPost.Parameters.AddWithValue("@TransactionDate", trans.TransactionDate)
                                            cmdPost.Parameters.AddWithValue("@Description", trans.Description)
                                            cmdPost.Parameters.AddWithValue("@Reference", trans.Reference)
                                            cmdPost.Parameters.AddWithValue("@CustomerName", customerName)
                                            cmdPost.Parameters.AddWithValue("@PostedBy", If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 1))
                                            
                                            cmdPost.ExecuteNonQuery()
                                            processedCount += 1
                                            OnLogMessage($"  ✓ Receipt completed: DR Bank / CR AR")
                                        End Using
                                    End If
                                    
                                Catch ex As Exception
                                    errorCount += 1
                                    OnLogMessage($"  ✗ ERROR: {ex.Message}")
                                End Try
                            Next
                        End Using
                    End Using
                End Using
                
                OnLogMessage("========================================")
                OnLogMessage($"PROCESSING COMPLETE")
                OnLogMessage($"Processed: {processedCount} | Errors: {errorCount}")
                OnLogMessage("========================================")
                
                LoadTransactions()
                MessageBox.Show($"Bank statement processing complete!{Environment.NewLine}{Environment.NewLine}Processed: {processedCount}{Environment.NewLine}Errors: {errorCount}{Environment.NewLine}{Environment.NewLine}Double-entry completed for all mapped transactions.", "Processing Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
                
            Catch ex As Exception
                OnLogMessage($"FATAL ERROR: {ex.Message}")
                MessageBox.Show($"Error processing statement: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub btnAutoMap_Click(sender As Object, e As EventArgs)
            Try
                Dim mappedCount As Integer = 0
                Dim skippedCount As Integer = 0
                
                OnLogMessage("Starting intelligent auto-mapping process...")
                
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    
                    ' Get all unmapped transactions
                    Dim sql As String = "SELECT TransactionID FROM AP_StatementTransactions WHERE IsMapped = 0 OR IsMapped IS NULL ORDER BY TransactionDate ASC"
                    Using cmd As New SqlCommand(sql, conn)
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            Dim transactions As New List(Of Integer)
                            
                            While reader.Read()
                                transactions.Add(reader.GetInt32(0))
                            End While
                            reader.Close()
                            
                            ' Process each transaction using stored procedure
                            For Each txnId In transactions
                                OnLogMessage($"Auto-mapping transaction {txnId}...")
                                
                                Using cmdMap As New SqlCommand("sp_BankStatement_AutoMap", conn)
                                    cmdMap.CommandType = CommandType.StoredProcedure
                                    cmdMap.Parameters.AddWithValue("@TransactionID", txnId)
                                    
                                    Using mapReader As SqlDataReader = cmdMap.ExecuteReader()
                                        If mapReader.Read() Then
                                            Dim success = mapReader.GetInt32(mapReader.GetOrdinal("Success"))
                                            Dim accountCode = If(mapReader.IsDBNull(mapReader.GetOrdinal("AccountCode")), "", mapReader.GetString(mapReader.GetOrdinal("AccountCode")))
                                            Dim mappingType = If(mapReader.IsDBNull(mapReader.GetOrdinal("MappingType")), "", mapReader.GetString(mapReader.GetOrdinal("MappingType")))
                                            Dim message = If(mapReader.IsDBNull(mapReader.GetOrdinal("Message")), "", mapReader.GetString(mapReader.GetOrdinal("Message")))
                                            
                                            If success = 1 Then
                                                mappedCount += 1
                                                OnLogMessage($"✓ Transaction {txnId} → {accountCode} ({mappingType})")
                                            Else
                                                skippedCount += 1
                                                OnLogMessage($"⊘ Transaction {txnId} - {message}")
                                            End If
                                        End If
                                    End Using
                                End Using
                            Next
                        End Using
                    End Using
                End Using
                
                LoadTransactions()
                
                ' Auto-mapping complete - bank statement processing now uses accrual model
                ' Transactions are marked as mapped but NOT posted here
                ' Posting happens when user manually processes bank statement to complete double-entry
                LoadTransactions()
                MessageBox.Show($"Auto-mapping complete!{Environment.NewLine}{Environment.NewLine}Mapped: {mappedCount}{Environment.NewLine}Skipped: {skippedCount}{Environment.NewLine}{Environment.NewLine}Use 'Process Statement' to complete GL entries.", "Auto-Mapping Results", MessageBoxButtons.OK, MessageBoxIcon.Information)
                
            Catch ex As Exception
                OnLogMessage($"ERROR: {ex.Message}")
                MessageBox.Show($"Error during auto-mapping: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Function MatchTransactionToInvoice(conn As SqlConnection, reference As String, amount As Decimal, ByRef matchMethod As String) As String
            Try
                ' Extract invoice number from reference (e.g., "INV-20260304220245", "FNB CB INV-003")
                Dim invoiceNumber As String = ExtractInvoiceNumber(reference)
                
                If String.IsNullOrEmpty(invoiceNumber) Then
                    OnLogMessage($"  No invoice number found in: '{reference}'")
                    Return ""
                End If
                
                OnLogMessage($"  Extracted invoice number: '{invoiceNumber}' from '{reference}'")
                
                ' Try to find matching invoice by invoice number and amount
                ' Get supplier's ledger account from ChartOfAccounts
                ' Try exact match first, then try matching with/without INV- prefix
                Dim sql As String = "
                    SELECT TOP 1 
                        i.InvoiceID,
                        i.InvoiceNumber,
                        i.TotalAmount,
                        i.BeneficiaryID,
                        coa.AccountCode AS SupplierLedgerAccount,
                        coa.AccountName AS SupplierName
                    FROM AP_Invoices i
                    LEFT JOIN ChartOfAccounts coa ON i.BeneficiaryID = coa.SupplierID AND coa.IsSubsidiaryLedger = 1
                    WHERE (UPPER(i.InvoiceNumber) = UPPER(@InvoiceNumber)
                           OR UPPER(i.InvoiceNumber) = UPPER(REPLACE(@InvoiceNumber, 'INV-', ''))
                           OR UPPER('INV-' + i.InvoiceNumber) = UPPER(@InvoiceNumber))
                        AND ABS(i.TotalAmount - @Amount) < 0.01
                        AND i.BeneficiaryID IS NOT NULL
                    ORDER BY i.InvoiceDate DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
                    cmd.Parameters.AddWithValue("@Amount", amount)
                    
                    OnLogMessage($"  Searching for invoice: '{invoiceNumber}' with amount R{amount:N2}")
                    
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            Dim ledgerAccount = If(reader.IsDBNull(reader.GetOrdinal("SupplierLedgerAccount")), "", reader.GetString(reader.GetOrdinal("SupplierLedgerAccount")))
                            Dim supplierName = If(reader.IsDBNull(reader.GetOrdinal("SupplierName")), "", reader.GetString(reader.GetOrdinal("SupplierName")))
                            Dim foundInvoice = reader.GetString(reader.GetOrdinal("InvoiceNumber"))
                            Dim foundAmount = reader.GetDecimal(reader.GetOrdinal("TotalAmount"))
                            
                            OnLogMessage($"  ✓ FOUND invoice: '{foundInvoice}' Amount: R{foundAmount:N2}, Supplier: '{supplierName}', Ledger: '{ledgerAccount}'")
                            
                            If Not String.IsNullOrEmpty(ledgerAccount) Then
                                matchMethod = $"Invoice Match: {invoiceNumber} - {supplierName}"
                                Return ledgerAccount
                            Else
                                OnLogMessage($"  ⚠ Invoice found but no ledger account assigned")
                            End If
                        Else
                            OnLogMessage($"  ✗ No invoice match in AP_Invoices for '{invoiceNumber}' with amount R{amount:N2}")
                        End If
                    End Using
                End Using
                
                ' Try searching Reference field as well
                sql = "
                    SELECT TOP 1 
                        i.InvoiceID,
                        i.InvoiceNumber,
                        i.TotalAmount,
                        i.BeneficiaryID,
                        coa.AccountCode AS SupplierLedgerAccount,
                        coa.AccountName AS SupplierName
                    FROM AP_Invoices i
                    LEFT JOIN ChartOfAccounts coa ON i.BeneficiaryID = coa.SupplierID AND coa.IsSubsidiaryLedger = 1
                    WHERE (UPPER(i.Reference) = UPPER(@InvoiceNumber)
                           OR UPPER(i.Reference) = UPPER(REPLACE(@InvoiceNumber, 'INV-', ''))
                           OR UPPER('INV-' + i.Reference) = UPPER(@InvoiceNumber))
                        AND ABS(i.TotalAmount - @Amount) < 0.01
                        AND i.BeneficiaryID IS NOT NULL
                    ORDER BY i.InvoiceDate DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
                    cmd.Parameters.AddWithValue("@Amount", amount)
                    
                    OnLogMessage($"  Searching AP_Invoices.Reference for: InvoiceNumber='{invoiceNumber}', Amount=R{amount:N2}")
                    
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            Dim ledgerAccount = If(reader.IsDBNull(reader.GetOrdinal("SupplierLedgerAccount")), "", reader.GetString(reader.GetOrdinal("SupplierLedgerAccount")))
                            Dim supplierName = If(reader.IsDBNull(reader.GetOrdinal("SupplierName")), "", reader.GetString(reader.GetOrdinal("SupplierName")))
                            Dim foundInvoice = reader.GetString(reader.GetOrdinal("InvoiceNumber"))
                            Dim foundAmount = reader.GetDecimal(reader.GetOrdinal("TotalAmount"))
                            
                            OnLogMessage($"  ✓ FOUND via Reference: Invoice '{foundInvoice}' Amount: R{foundAmount:N2}, Supplier: '{supplierName}', Ledger: '{ledgerAccount}'")
                            
                            If Not String.IsNullOrEmpty(ledgerAccount) Then
                                matchMethod = $"Reference Match: {invoiceNumber} - {supplierName}"
                                Return ledgerAccount
                            End If
                        Else
                            OnLogMessage($"  ✗ No match in Reference field either")
                        End If
                    End Using
                End Using
                
                ' Try searching SupplierInvoices table (invoices from POs)
                OnLogMessage($"  Searching SupplierInvoices table...")
                sql = "
                    SELECT TOP 1 
                        i.InvoiceID,
                        i.InvoiceNumber,
                        i.TotalAmount,
                        i.SupplierID,
                        coa.AccountCode AS SupplierLedgerAccount,
                        coa.AccountName AS SupplierName
                    FROM SupplierInvoices i
                    LEFT JOIN ChartOfAccounts coa ON i.SupplierID = coa.SupplierID AND coa.IsSubsidiaryLedger = 1
                    WHERE (UPPER(i.InvoiceNumber) = UPPER(@InvoiceNumber)
                           OR UPPER(i.InvoiceNumber) = UPPER(REPLACE(@InvoiceNumber, 'INV-', ''))
                           OR UPPER('INV-' + i.InvoiceNumber) = UPPER(@InvoiceNumber))
                        AND ABS(i.TotalAmount - @Amount) < 0.01
                        AND i.SupplierID IS NOT NULL
                    ORDER BY i.InvoiceDate DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
                    cmd.Parameters.AddWithValue("@Amount", amount)
                    
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            Dim ledgerAccount = If(reader.IsDBNull(reader.GetOrdinal("SupplierLedgerAccount")), "", reader.GetString(reader.GetOrdinal("SupplierLedgerAccount")))
                            Dim supplierName = If(reader.IsDBNull(reader.GetOrdinal("SupplierName")), "", reader.GetString(reader.GetOrdinal("SupplierName")))
                            Dim foundInvoice = reader.GetString(reader.GetOrdinal("InvoiceNumber"))
                            Dim foundAmount = reader.GetDecimal(reader.GetOrdinal("TotalAmount"))
                            
                            OnLogMessage($"  ✓ FOUND in SupplierInvoices: Invoice '{foundInvoice}' Amount: R{foundAmount:N2}, Supplier: '{supplierName}', Ledger: '{ledgerAccount}'")
                            
                            If Not String.IsNullOrEmpty(ledgerAccount) Then
                                matchMethod = $"PO Invoice Match: {invoiceNumber} - {supplierName}"
                                Return ledgerAccount
                            Else
                                OnLogMessage($"  ⚠ Invoice found in SupplierInvoices but no ledger account assigned")
                            End If
                        Else
                            OnLogMessage($"  ✗ No match in SupplierInvoices table")
                        End If
                    End Using
                End Using
                
                ' Try fuzzy match by amount only (within R1.00)
                OnLogMessage($"  Trying fuzzy amount match (±R1.00)...")
                sql = "
                    SELECT TOP 1 
                        i.InvoiceID,
                        i.InvoiceNumber,
                        i.TotalAmount,
                        i.BeneficiaryID,
                        coa.AccountCode AS SupplierLedgerAccount,
                        coa.AccountName AS SupplierName
                    FROM AP_Invoices i
                    LEFT JOIN ChartOfAccounts coa ON i.BeneficiaryID = coa.SupplierID AND coa.IsSubsidiaryLedger = 1
                    WHERE ABS(i.TotalAmount - @Amount) < 1.00
                        AND i.PaymentStatus IN ('Pending', 'Processing')
                        AND i.BeneficiaryID IS NOT NULL
                    ORDER BY ABS(i.TotalAmount - @Amount), i.InvoiceDate DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@Amount", amount)
                    
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            Dim ledgerAccount = If(reader.IsDBNull(reader.GetOrdinal("SupplierLedgerAccount")), "", reader.GetString(reader.GetOrdinal("SupplierLedgerAccount")))
                            Dim supplierName = If(reader.IsDBNull(reader.GetOrdinal("SupplierName")), "", reader.GetString(reader.GetOrdinal("SupplierName")))
                            Dim foundInvoice = reader.GetString(reader.GetOrdinal("InvoiceNumber"))
                            Dim foundAmount = reader.GetDecimal(reader.GetOrdinal("TotalAmount"))
                            
                            OnLogMessage($"  Fuzzy match found: '{foundInvoice}' Amount: R{foundAmount:N2}, Supplier: '{supplierName}', Ledger: '{ledgerAccount}'")
                            
                            If Not String.IsNullOrEmpty(ledgerAccount) Then
                                matchMethod = $"Fuzzy Match: {foundInvoice} - {supplierName}"
                                Return ledgerAccount
                            End If
                        End If
                    End Using
                End Using
                
            Catch ex As Exception
                OnLogMessage($"Error matching invoice: {ex.Message}")
            End Try
            
            Return ""
        End Function
        
        Private Function ExtractInvoiceNumber(reference As String) As String
            If String.IsNullOrEmpty(reference) Then
                Return ""
            End If
            
            ' Common patterns: 
            ' "TP-INV5", "SUPPLIER-INV123" (prefix-INVnumber)
            ' "INV-20260304220245", "FNB CB INV-003" (INV-number)
            ' "INV123", "INVOICE123" (INVnumber)
            Dim patterns() As String = {
                "[A-Z]+-INV\d+",        ' TP-INV5, SUPPLIER-INV123
                "[A-Z]+INV\d+",         ' TPINV5
                "INV-\d+",              ' INV-20260304220245
                "INV\d+",               ' INV123
                "INVOICE-\d+",          ' INVOICE-123
                "INVOICE\d+"            ' INVOICE123
            }
            
            For Each pattern In patterns
                Dim match = System.Text.RegularExpressions.Regex.Match(reference, pattern, System.Text.RegularExpressions.RegexOptions.IgnoreCase)
                If match.Success Then
                    OnLogMessage($"  Pattern '{pattern}' matched: '{match.Value}'")
                    Return match.Value
                End If
            Next
            
            Return ""
        End Function
        
        Private Function DeterminePostSyncDescription(description As String, reference As String, beneficiary As String, creditDebitType As String) As String
            ' Determine what this transaction should be posted as
            Dim desc = description.ToLower()
            Dim ref = reference.ToLower()
            Dim ben = beneficiary.ToLower()
            Dim combined = (desc & " " & ref & " " & ben).ToLower()
            
            ' Check for invoice number first
            Dim invoiceNum = ExtractInvoiceNumber(description)
            If String.IsNullOrEmpty(invoiceNum) Then
                invoiceNum = ExtractInvoiceNumber(reference)
            End If
            
            If Not String.IsNullOrEmpty(invoiceNum) Then
                ' If we have an invoice number, use it with beneficiary
                If Not String.IsNullOrEmpty(beneficiary) Then
                    Return $"{beneficiary} ({invoiceNum})"
                Else
                    Return invoiceNum
                End If
            End If
            
            ' Check for specific transaction types
            If combined.Contains("bank charges") Or combined.Contains("bank fee") Or combined.Contains("service fee") Or
               combined.Contains("monthly fee") Or combined.Contains("transaction fee") Or combined.Contains("admin fee") Then
                Return "Bank Charges"
                
            ElseIf combined.Contains("cash deposit") Or combined.Contains("atm deposit") Or combined.Contains("branch deposit") Then
                Return "Cash Deposit"
                
            ElseIf combined.Contains("eft") Or combined.Contains("electronic transfer") Then
                If Not String.IsNullOrEmpty(beneficiary) Then
                    Return $"EFT - {beneficiary}"
                Else
                    Return "EFT Payment"
                End If
                
            ElseIf combined.Contains("salary") Or combined.Contains("wages") Or combined.Contains("payroll") Then
                If Not String.IsNullOrEmpty(beneficiary) Then
                    Return $"Salary - {beneficiary}"
                Else
                    Return "Salary Payment"
                End If
                
            ElseIf combined.Contains("interest") Then
                If creditDebitType = "Credit" Then
                    Return "Interest Received"
                Else
                    Return "Interest Paid"
                End If
                
            ElseIf combined.Contains("refund") Or combined.Contains("reversal") Then
                Return "Refund/Reversal"
                
            ElseIf Not String.IsNullOrEmpty(beneficiary) Then
                ' Use beneficiary name if available
                Return beneficiary
                
            ElseIf Not String.IsNullOrEmpty(description) Then
                ' Use description if no beneficiary
                Return description
                
            Else
                ' Fallback to reference
                Return If(Not String.IsNullOrEmpty(reference), reference, "Unknown Transaction")
            End If
        End Function
        
        Private Function DetermineLedgerAccount(description As String, reference As String, creditDebitType As String) As String
            ' Convert to lowercase for pattern matching
            Dim desc = description.ToLower()
            Dim ref = reference.ToLower()
            Dim combined = (desc & " " & ref).ToLower()
            
            Dim accountName As String = ""
            Dim matchMethod As String = ""
            
            ' Payment patterns (Debit transactions - money going out)
            If creditDebitType = "Debit" Then
                ' PRIORITY 1: Try to match to supplier invoice (subsidiary ledger)
                Try
                    Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                        conn.Open()
                        Dim supplierLedger = MatchTransactionToInvoice(conn, reference, 0, matchMethod)
                        If Not String.IsNullOrEmpty(supplierLedger) Then
                            OnLogMessage($"  Matched to supplier ledger: {supplierLedger}")
                            Return supplierLedger
                        End If
                    End Using
                Catch ex As Exception
                    OnLogMessage($"Error matching supplier invoice: {ex.Message}")
                End Try
                
                ' Bank charges and fees (check first - very common)
                If combined.Contains("bank charges") Or combined.Contains("bank fee") Or combined.Contains("service fee") Or 
                   combined.Contains("monthly fee") Or combined.Contains("transaction fee") Or combined.Contains("admin fee") Or
                   combined.Contains("account fee") Or combined.Contains("maintenance fee") Then
                    accountName = "Bank Charges & Fees"
                    
                ' Salary and wages
                ElseIf combined.Contains("salary") Or combined.Contains("wages") Or combined.Contains("payroll") Or
                       combined.Contains("staff payment") Or combined.Contains("employee") Then
                    accountName = "Salaries & Wages"
                    
                ' Rent and lease
                ElseIf combined.Contains("rent") Or combined.Contains("lease") Or combined.Contains("rental") Then
                    accountName = "Rent Expense"
                    
                ' Utilities - Electricity
                ElseIf combined.Contains("electricity") Or combined.Contains("eskom") Or combined.Contains("city power") Then
                    accountName = "Utilities - Electricity"
                    
                ' Utilities - Water
                ElseIf combined.Contains("water") Or combined.Contains("municipal") Or combined.Contains("sewerage") Then
                    accountName = "Utilities - Water"
                    
                ' Telephone and internet
                ElseIf combined.Contains("telephone") Or combined.Contains("internet") Or combined.Contains("vodacom") Or 
                       combined.Contains("mtn") Or combined.Contains("telkom") Or combined.Contains("cell c") Or
                       combined.Contains("data") Or combined.Contains("airtime") Then
                    accountName = "Telephone & Internet"
                    
                ' Suppliers and inventory
                ElseIf combined.Contains("supplier") Or combined.Contains("purchase") Or combined.Contains("inventory") Or
                       combined.Contains("stock") Or combined.Contains("goods") Then
                    accountName = "Accounts Payable"
                    
                ' Insurance
                ElseIf combined.Contains("insurance") Or combined.Contains("premium") Then
                    accountName = "Insurance Expense"
                    
                ' Tax and VAT
                ElseIf combined.Contains("tax") Or combined.Contains("vat") Or combined.Contains("sars") Or
                       combined.Contains("revenue service") Then
                    accountName = "VAT Payable"
                    
                ' Loan and interest payments
                ElseIf combined.Contains("loan") Or combined.Contains("interest") Or combined.Contains("repayment") Or
                       combined.Contains("finance charge") Then
                    accountName = "Interest Expense"
                    
                ' Fuel and vehicle expenses
                ElseIf combined.Contains("fuel") Or combined.Contains("petrol") Or combined.Contains("diesel") Or
                       combined.Contains("engen") Or combined.Contains("shell") Or combined.Contains("bp") Or
                       combined.Contains("sasol") Then
                    accountName = "Vehicle Fuel"
                    
                ' Office supplies and stationery
                ElseIf combined.Contains("stationery") Or combined.Contains("office supplies") Or combined.Contains("printing") Then
                    accountName = "Office Supplies"
                    
                ' Don't default - let it be skipped if no pattern matches
                Else
                    Return ""
                End If
                
            ' Receipt patterns (Credit transactions - money coming in)
            ElseIf creditDebitType = "Credit" Then
                ' PRIORITY 1: Try to match to customer invoice (subsidiary ledger)
                Dim customerLedger = TryMatchInvoiceToCustomer(description, reference, 0)
                If Not String.IsNullOrEmpty(customerLedger) Then
                    OnLogMessage($"  Matched to customer ledger: {customerLedger}")
                    Return customerLedger
                End If
                
                ' Cash deposits
                If combined.Contains("cash deposit") Or combined.Contains("deposit cash") Or 
                   combined.Contains("atm deposit") Or combined.Contains("branch deposit") Then
                    accountName = "Petty Cash"
                    
                ' Sales and POS receipts
                ElseIf combined.Contains("sales") Or combined.Contains("pos") Or combined.Contains("payment received") Or
                       combined.Contains("customer payment") Or combined.Contains("receipt") Then
                    accountName = "Sales Revenue"
                    
                ' Interest received
                ElseIf combined.Contains("interest received") Or combined.Contains("interest income") Or
                       combined.Contains("interest credit") Then
                    accountName = "Interest Income"
                    
                ' Refunds
                ElseIf combined.Contains("refund") Or combined.Contains("reversal") Then
                    accountName = "Accounts Receivable"
                    
                ' Capital deposits
                ElseIf combined.Contains("capital") Or combined.Contains("owner deposit") Or 
                       combined.Contains("shareholder") Then
                    accountName = "Capital"
                    
                ' Bank transfers in
                ElseIf combined.Contains("transfer in") Or combined.Contains("incoming transfer") Then
                    accountName = "Accounts Receivable"
                    
                ' Don't default - let it be skipped
                Else
                    Return ""
                End If
            End If
            
            ' Look up the actual ledger account from the database
            If Not String.IsNullOrEmpty(accountName) Then
                Return LookupLedgerAccount(accountName)
            End If
            
            Return "" ' No match found
        End Function
        
        Private Function TryMatchInvoiceToCustomer(description As String, reference As String, amount As Decimal) As String
            ' Try to match customer receipt to AR invoice and return customer subsidiary ledger
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    
                    ' Extract invoice number from description or reference
                    Dim invoiceNum = ExtractInvoiceNumber(description)
                    If String.IsNullOrEmpty(invoiceNum) Then
                        invoiceNum = ExtractInvoiceNumber(reference)
                    End If
                    
                    If Not String.IsNullOrEmpty(invoiceNum) Then
                        ' Try to find AR invoice and get customer ledger
                        Dim sql = "
                            SELECT TOP 1 
                                CAST(coa.AccountCode AS VARCHAR(10)) + ' - ' + coa.AccountName AS CustomerLedger
                            FROM AR_Invoices ar
                            INNER JOIN ChartOfAccounts coa ON ar.CustomerID = coa.CustomerID 
                                AND coa.IsSubsidiaryLedger = 1
                                AND coa.AccountType = 'Asset'
                            WHERE ar.InvoiceNumber LIKE '%' + @InvoiceNum + '%'
                                AND ar.PaymentStatus IN ('Pending', 'Partial')
                            ORDER BY ar.InvoiceDate DESC"
                        
                        Using cmd As New SqlCommand(sql, conn)
                            cmd.Parameters.AddWithValue("@InvoiceNum", invoiceNum)
                            Dim result = cmd.ExecuteScalar()
                            If result IsNot Nothing Then
                                Return result.ToString()
                            End If
                        End Using
                    End If
                End Using
            Catch ex As Exception
                OnLogMessage($"Error matching customer invoice: {ex.Message}")
            End Try
            
            Return ""
        End Function
        
        Private Sub CreateJournalEntryForBankTransaction(conn As SqlConnection, transactionId As Integer, amount As Decimal, creditDebitType As String, ledgerAccount As String, description As String, reference As String)
            Try
                ' Extract account code from ledger account string (e.g., "2200-001 - ABC Suppliers" -> "2200-001")
                Dim accountCode As String = ledgerAccount
                If ledgerAccount.Contains(" - ") Then
                    accountCode = ledgerAccount.Split(New String() {" - "}, StringSplitOptions.None)(0).Trim()
                End If
                
                ' Get bank account code (1010 - Bank Account - Current)
                Dim bankAccountCode As String = "1010"
                
                ' Create journal header
                Dim journalHeaderSql As String = "
                    INSERT INTO JournalHeaders (JournalDate, Reference, Description, JournalType, Status, CreatedBy, CreatedDate)
                    VALUES (@JournalDate, @Reference, @Description, 'Bank Statement', 'Posted', 'System', GETDATE());
                    SELECT SCOPE_IDENTITY();"
                
                Dim journalHeaderId As Integer
                Using cmd As New SqlCommand(journalHeaderSql, conn)
                    cmd.Parameters.AddWithValue("@JournalDate", Date.Today)
                    cmd.Parameters.AddWithValue("@Reference", $"BANK-{transactionId}")
                    cmd.Parameters.AddWithValue("@Description", $"{description} - {reference}")
                    journalHeaderId = Convert.ToInt32(cmd.ExecuteScalar())
                End Using
                
                ' Create journal lines based on transaction type
                If creditDebitType = "Debit" Then
                    ' Money OUT: DR Expense/Supplier, CR Bank
                    ' Line 1: Debit the expense or supplier account
                    InsertJournalLine(conn, journalHeaderId, 1, accountCode, description, amount, 0)
                    ' Line 2: Credit the bank account
                    InsertJournalLine(conn, journalHeaderId, 2, bankAccountCode, description, 0, amount)
                Else
                    ' Money IN: DR Bank, CR Income/Customer
                    ' Line 1: Debit the bank account
                    InsertJournalLine(conn, journalHeaderId, 1, bankAccountCode, description, amount, 0)
                    ' Line 2: Credit the income or customer account
                    InsertJournalLine(conn, journalHeaderId, 2, accountCode, description, 0, amount)
                End If
                
                OnLogMessage($"  Created journal entry #{journalHeaderId} for transaction {transactionId}")
                
            Catch ex As Exception
                OnLogMessage($"  Error creating journal entry: {ex.Message}")
            End Try
        End Sub
        
        Private Sub InsertJournalLine(conn As SqlConnection, journalHeaderId As Integer, lineNumber As Integer, accountCode As String, description As String, debitAmount As Decimal, creditAmount As Decimal)
            Dim sql As String = "
                INSERT INTO JournalLines (JournalHeaderID, LineNumber, AccountCode, Description, DebitAmount, CreditAmount)
                VALUES (@JournalHeaderID, @LineNumber, @AccountCode, @Description, @DebitAmount, @CreditAmount)"
            
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@JournalHeaderID", journalHeaderId)
                cmd.Parameters.AddWithValue("@LineNumber", lineNumber)
                cmd.Parameters.AddWithValue("@AccountCode", accountCode)
                cmd.Parameters.AddWithValue("@Description", description)
                cmd.Parameters.AddWithValue("@DebitAmount", debitAmount)
                cmd.Parameters.AddWithValue("@CreditAmount", creditAmount)
                cmd.ExecuteNonQuery()
            End Using
        End Sub
        
        Private Function LookupLedgerAccount(accountName As String) As String
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    
                    ' Try to find ledger account by name pattern
                    Dim sql As String = "
                        SELECT TOP 1 
                            CAST(AccountCode AS VARCHAR(10)) + ' - ' + AccountName AS LedgerAccount
                        FROM ChartOfAccounts
                        WHERE AccountName LIKE '%' + @AccountName + '%'
                            AND IsActive = 1
                        ORDER BY AccountCode"
                    
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@AccountName", accountName)
                        
                        Dim result = cmd.ExecuteScalar()
                        If result IsNot Nothing Then
                            Return result.ToString()
                        End If
                    End Using
                End Using
            Catch ex As Exception
                OnLogMessage($"Error looking up ledger account for '{accountName}': {ex.Message}")
            End Try
            
            Return "" ' No match found
        End Function

        Private Sub OnLogMessage(message As String)
            If txtLog.InvokeRequired Then
                txtLog.Invoke(Sub() OnLogMessage(message))
            Else
                txtLog.AppendText($"[{DateTime.Now:HH:mm:ss}] {message}{Environment.NewLine}")
            End If
        End Sub
    End Class

    ' ===== Statement Mapping Dialog =====
    Public Class StatementMappingDialog
        Inherits Form

        Private WithEvents cboCategory As ComboBox
        Private WithEvents cboBeneficiary As ComboBox
        Private WithEvents chkCreateInvoice As CheckBox
        Private WithEvents btnSave As Button
        Private btnCancel As Button
        Private _transactionId As Integer
        Private _amount As Decimal
        Private _description As String
        Private _invoiceService As APInvoiceService

        Public Sub New(transactionId As Integer, amount As Decimal, description As String, invoiceService As APInvoiceService)
            _transactionId = transactionId
            _amount = amount
            _description = description
            _invoiceService = invoiceService
            InitializeComponent()
            LoadCategories()
            LoadBeneficiaries()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Map Statement Transaction"
            Me.Size = New Size(500, 350)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False

            Dim yPos = 20

            Dim lblInfo As New Label() With {
                .Text = $"Transaction Amount: R {_amount:N2}",
                .Location = New Point(20, yPos),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            Me.Controls.Add(lblInfo)
            yPos += 30

            Dim lblDesc As New Label() With {
                .Text = $"Description: {_description}",
                .Location = New Point(20, yPos),
                .Size = New Size(450, 40),
                .Font = New Font("Segoe UI", 9)
            }
            Me.Controls.Add(lblDesc)
            yPos += 50

            Dim lblCategory As New Label() With {
                .Text = "Category:",
                .Location = New Point(20, yPos),
                .AutoSize = True
            }
            Me.Controls.Add(lblCategory)

            cboCategory = New ComboBox() With {
                .Location = New Point(120, yPos - 3),
                .Width = 300,
                .DropDownStyle = ComboBoxStyle.DropDownList
            }
            Me.Controls.Add(cboCategory)
            yPos += 40

            chkCreateInvoice = New CheckBox() With {
                .Text = "Create Invoice from Transaction",
                .Location = New Point(20, yPos),
                .AutoSize = True
            }
            Me.Controls.Add(chkCreateInvoice)
            yPos += 35

            Dim lblBeneficiary As New Label() With {
                .Text = "Beneficiary:",
                .Location = New Point(20, yPos),
                .AutoSize = True,
                .Enabled = False
            }
            Me.Controls.Add(lblBeneficiary)

            cboBeneficiary = New ComboBox() With {
                .Location = New Point(120, yPos - 3),
                .Width = 300,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Enabled = False
            }
            Me.Controls.Add(cboBeneficiary)
            yPos += 50

            btnSave = New Button() With {
                .Text = "Save Mapping",
                .Location = New Point(280, yPos),
                .Size = New Size(100, 30),
                .DialogResult = DialogResult.OK
            }
            Me.Controls.Add(btnSave)

            btnCancel = New Button() With {
                .Text = "Cancel",
                .Location = New Point(390, yPos),
                .Size = New Size(80, 30),
                .DialogResult = DialogResult.Cancel
            }
            Me.Controls.Add(btnCancel)

            AddHandler chkCreateInvoice.CheckedChanged, Sub()
                                                            cboBeneficiary.Enabled = chkCreateInvoice.Checked
                                                        End Sub
        End Sub

        Private Sub LoadCategories()
            Dim dt = _invoiceService.GetCategories()
            cboCategory.DisplayMember = "CategoryName"
            cboCategory.ValueMember = "CategoryID"
            cboCategory.DataSource = dt
        End Sub

        Private Sub LoadBeneficiaries()
            Dim dt = _invoiceService.GetBeneficiaries()
            cboBeneficiary.DisplayMember = "BeneficiaryName"
            cboBeneficiary.ValueMember = "BeneficiaryID"
            cboBeneficiary.DataSource = dt
        End Sub

        Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
            Try
                If cboCategory.SelectedValue Is Nothing Then
                    MessageBox.Show("Please select a category", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Me.DialogResult = DialogResult.None
                    Return
                End If

                If chkCreateInvoice.Checked AndAlso cboBeneficiary.SelectedValue Is Nothing Then
                    MessageBox.Show("Please select a beneficiary", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Me.DialogResult = DialogResult.None
                    Return
                End If

                Dim categoryId = CInt(cboCategory.SelectedValue)
                Dim beneficiaryId = If(chkCreateInvoice.Checked, CInt(cboBeneficiary.SelectedValue), CType(Nothing, Integer?))

                Using conn As New SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    Using cmd As New SqlClient.SqlCommand("sp_AP_MapStatementTransaction", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@TransactionID", _transactionId)
                        cmd.Parameters.AddWithValue("@CategoryID", categoryId)
                        cmd.Parameters.AddWithValue("@CreateInvoice", chkCreateInvoice.Checked)
                        cmd.Parameters.AddWithValue("@BeneficiaryID", If(beneficiaryId, DBNull.Value))
                        cmd.Parameters.AddWithValue("@CreatedBy", AppSession.CurrentUser.Username)
                        cmd.ExecuteNonQuery()
                    End Using
                End Using

                MessageBox.Show("Transaction mapped successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Catch ex As Exception
                MessageBox.Show($"Error mapping transaction: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Me.DialogResult = DialogResult.None
            End Try
        End Sub
    End Class
End Namespace
