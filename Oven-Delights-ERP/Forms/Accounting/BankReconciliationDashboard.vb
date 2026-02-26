Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms
Imports System.Drawing

Namespace Accounting
    ''' <summary>
    ''' Bank Statement Reconciliation Dashboard
    ''' Main interface for importing statements, auto-matching, and posting to GL
    ''' </summary>
    Public Class BankReconciliationDashboard
        Inherits Form

        Private ReadOnly _connectionString As String
        Private ReadOnly _userName As String
        Private _fnbService As FNBBankingService

        Private WithEvents cmbBankAccount As ComboBox
        Private WithEvents dtpStartDate As DateTimePicker
        Private WithEvents dtpEndDate As DateTimePicker
        Private WithEvents btnDownloadFNB As Button
        Private WithEvents btnImportCSV As Button
        Private WithEvents btnAutoMatch As Button
        Private WithEvents btnPostToGL As Button
        Private WithEvents btnRefresh As Button
        Private WithEvents dgvTransactions As DataGridView
        Private lblStats As Label
        Private pnlStats As Panel
        Private txtStatusLog As TextBox

        Public Sub New(userName As String)
            _userName = userName
            _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            _fnbService = New FNBBankingService()

            InitializeComponent()
        End Sub
        
        Private Sub BankReconciliationDashboard_Load(sender As Object, e As EventArgs) Handles MyBase.Load
            LoadBankAccounts()
            LoadStatistics()
            LoadTransactions()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Bank Statement Reconciliation"
            Me.Size = New Size(1600, 900)
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            ' Header Panel
            Dim pnlHeader As New Panel With {
                .Dock = DockStyle.Top,
                .Height = 100,
                .BackColor = ColorTranslator.FromHtml("#2C3E50")
            }

            Dim lblTitle As New Label With {
                .Text = "🏦 BANK RECONCILIATION",
                .Font = New Font("Segoe UI", 24, FontStyle.Bold),
                .ForeColor = Color.White,
                .Location = New Point(20, 20),
                .AutoSize = True
            }
            pnlHeader.Controls.Add(lblTitle)

            Dim lblSubtitle As New Label With {
                .Text = "Automated bank statement matching and GL posting",
                .Font = New Font("Segoe UI", 11),
                .ForeColor = Color.FromArgb(189, 195, 199),
                .Location = New Point(20, 60),
                .AutoSize = True
            }
            pnlHeader.Controls.Add(lblSubtitle)

            ' Statistics Panel
            pnlStats = New Panel With {
                .Dock = DockStyle.Top,
                .Height = 120,
                .BackColor = ColorTranslator.FromHtml("#ECF0F1"),
                .Padding = New Padding(20)
            }

            lblStats = New Label With {
                .Dock = DockStyle.Fill,
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorTranslator.FromHtml("#2C3E50")
            }
            pnlStats.Controls.Add(lblStats)

            ' Filter Panel
            Dim pnlFilters As New Panel With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = Color.White,
                .Padding = New Padding(20, 10, 20, 10)
            }

            Dim lblBank As New Label With {
                .Text = "Bank Account:",
                .Location = New Point(20, 25),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            pnlFilters.Controls.Add(lblBank)

            cmbBankAccount = New ComboBox With {
                .Location = New Point(130, 22),
                .Size = New Size(300, 25),
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10)
            }
            pnlFilters.Controls.Add(cmbBankAccount)

            Dim lblStartDate As New Label With {
                .Text = "From:",
                .Location = New Point(450, 25),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            pnlFilters.Controls.Add(lblStartDate)

            dtpStartDate = New DateTimePicker With {
                .Location = New Point(500, 22),
                .Size = New Size(150, 25),
                .Format = DateTimePickerFormat.Short,
                .Value = Date.Today.AddDays(-30)
            }
            pnlFilters.Controls.Add(dtpStartDate)

            Dim lblEndDate As New Label With {
                .Text = "To:",
                .Location = New Point(670, 25),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            pnlFilters.Controls.Add(lblEndDate)

            dtpEndDate = New DateTimePicker With {
                .Location = New Point(700, 22),
                .Size = New Size(150, 25),
                .Format = DateTimePickerFormat.Short,
                .Value = Date.Today
            }
            pnlFilters.Controls.Add(dtpEndDate)

            btnRefresh = New Button With {
                .Text = "🔄 Refresh",
                .Location = New Point(870, 20),
                .Size = New Size(120, 35),
                .BackColor = ColorTranslator.FromHtml("#95A5A6"),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnRefresh.FlatAppearance.BorderSize = 0
            pnlFilters.Controls.Add(btnRefresh)

            ' Action Buttons Panel
            Dim pnlActions As New Panel With {
                .Dock = DockStyle.Top,
                .Height = 70,
                .BackColor = Color.White,
                .Padding = New Padding(20, 10, 20, 10)
            }

            btnDownloadFNB = New Button With {
                .Text = "📥 Download FNB",
                .Location = New Point(20, 15),
                .Size = New Size(180, 40),
                .BackColor = ColorTranslator.FromHtml("#3498DB"),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnDownloadFNB.FlatAppearance.BorderSize = 0
            pnlActions.Controls.Add(btnDownloadFNB)

            btnImportCSV = New Button With {
                .Text = "📂 Import CSV",
                .Location = New Point(220, 15),
                .Size = New Size(180, 40),
                .BackColor = ColorTranslator.FromHtml("#9B59B6"),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnImportCSV.FlatAppearance.BorderSize = 0
            pnlActions.Controls.Add(btnImportCSV)

            btnAutoMatch = New Button With {
                .Text = "🔗 Auto-Match",
                .Location = New Point(420, 15),
                .Size = New Size(180, 40),
                .BackColor = ColorTranslator.FromHtml("#F39C12"),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnAutoMatch.FlatAppearance.BorderSize = 0
            pnlActions.Controls.Add(btnAutoMatch)

            btnPostToGL = New Button With {
                .Text = "✅ Post to GL",
                .Location = New Point(620, 15),
                .Size = New Size(180, 40),
                .BackColor = ColorTranslator.FromHtml("#27AE60"),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnPostToGL.FlatAppearance.BorderSize = 0
            pnlActions.Controls.Add(btnPostToGL)

            ' DataGridView
            dgvTransactions = New DataGridView With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = True,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .Font = New Font("Segoe UI", 9),
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle With {.BackColor = ColorTranslator.FromHtml("#F8F9FA")}
            }

            ' Status Log Panel (Black background, green text - like batch payments)
            Dim pnlStatusLog As New Panel With {
                .Dock = DockStyle.Bottom,
                .Height = 200,
                .BackColor = Color.Black,
                .Padding = New Padding(10)
            }

            Dim lblStatusTitle As New Label With {
                .Text = "FNB API STATUS LOG",
                .Dock = DockStyle.Top,
                .Height = 25,
                .ForeColor = Color.Lime,
                .Font = New Font("Consolas", 10, FontStyle.Bold),
                .BackColor = Color.Black
            }
            pnlStatusLog.Controls.Add(lblStatusTitle)

            txtStatusLog = New TextBox With {
                .Dock = DockStyle.Fill,
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .BackColor = Color.Black,
                .ForeColor = Color.Lime,
                .Font = New Font("Consolas", 9),
                .ReadOnly = True,
                .BorderStyle = BorderStyle.None
            }
            pnlStatusLog.Controls.Add(txtStatusLog)

            ' Add controls to form
            Me.Controls.Add(dgvTransactions)
            Me.Controls.Add(pnlStatusLog)
            Me.Controls.Add(pnlActions)
            Me.Controls.Add(pnlFilters)
            Me.Controls.Add(pnlStats)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadBankAccounts()
            Try
                cmbBankAccount.Items.Clear()
                cmbBankAccount.Items.Add(New With {.BankAccountID = 0, .DisplayText = "All Bank Accounts"})

                Using conn As New SqlConnection(_connectionString)
                    conn.Open()
                    Using cmd As New SqlCommand("SELECT BankAccountID, AccountName, BankName, AccountNumber FROM BankAccounts WHERE IsActive = 1 ORDER BY AccountName", conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                cmbBankAccount.Items.Add(New With {
                                    .BankAccountID = CInt(reader("BankAccountID")),
                                    .DisplayText = $"{reader("AccountName")} - {reader("BankName")} ({reader("AccountNumber")})"
                                })
                            End While
                        End Using
                    End Using
                End Using

                cmbBankAccount.DisplayMember = "DisplayText"
                If cmbBankAccount.Items.Count > 0 Then cmbBankAccount.SelectedIndex = 0

            Catch ex As Exception
                MessageBox.Show($"Error loading bank accounts: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadStatistics()
            Try
                Using conn As New SqlConnection(_connectionString)
                    conn.Open()

                    Dim totalTransactions As Integer = 0
                    Dim unmatchedCount As Integer = 0
                    Dim matchedCount As Integer = 0
                    Dim postedCount As Integer = 0
                    Dim unmatchedAmount As Decimal = 0

                    Using cmd As New SqlCommand("SELECT COUNT(*) AS Total, SUM(CASE WHEN Status = 'Unmatched' THEN 1 ELSE 0 END) AS Unmatched, SUM(CASE WHEN Status = 'Matched' THEN 1 ELSE 0 END) AS Matched, SUM(CASE WHEN Status = 'Posted' THEN 1 ELSE 0 END) AS Posted, SUM(CASE WHEN Status = 'Unmatched' THEN DebitAmount ELSE 0 END) AS UnmatchedAmount FROM BankStatementTransactions WHERE TransactionDate BETWEEN @StartDate AND @EndDate", conn)
                        cmd.Parameters.AddWithValue("@StartDate", dtpStartDate.Value.Date)
                        cmd.Parameters.AddWithValue("@EndDate", dtpEndDate.Value.Date)

                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                totalTransactions = If(IsDBNull(reader("Total")), 0, CInt(reader("Total")))
                                unmatchedCount = If(IsDBNull(reader("Unmatched")), 0, CInt(reader("Unmatched")))
                                matchedCount = If(IsDBNull(reader("Matched")), 0, CInt(reader("Matched")))
                                postedCount = If(IsDBNull(reader("Posted")), 0, CInt(reader("Posted")))
                                unmatchedAmount = If(IsDBNull(reader("UnmatchedAmount")), 0, CDec(reader("UnmatchedAmount")))
                            End If
                        End Using
                    End Using

                    lblStats.Text = $"📊 STATISTICS: Total Transactions: {totalTransactions} | " &
                                   $"⚠️ Unmatched: {unmatchedCount} (R{unmatchedAmount:N2}) | " &
                                   $"🔗 Matched: {matchedCount} | " &
                                   $"✅ Posted to GL: {postedCount}"
                End Using

            Catch ex As Exception
                lblStats.Text = "Error loading statistics"
            End Try
        End Sub

        Private Sub LoadTransactions()
            Try
                Using conn As New SqlConnection(_connectionString)
                    conn.Open()

                    Dim sql = "SELECT 
                        ast.TransactionID AS StatementLineID,
                        ast.AccountNumber AS BankAccount,
                        ast.TransactionDate,
                        ast.Description,
                        ast.Reference AS BankReference,
                        CASE WHEN ast.CreditDebitIndicator = 'DBIT' THEN ast.Amount ELSE 0 END AS DebitAmount,
                        CASE WHEN ast.CreditDebitIndicator = 'CRDT' THEN ast.Amount ELSE 0 END AS CreditAmount,
                        0 AS Balance,
                        CASE WHEN ast.MappedCategoryID IS NULL THEN 'Unmatched' ELSE 'Matched' END AS Status,
                        NULL AS MatchedPaymentRef,
                        NULL AS MatchedPaymentType,
                        'No' AS Posted
                    FROM AP_StatementTransactions ast
                    WHERE ast.TransactionDate BETWEEN @StartDate AND @EndDate"

                    If cmbBankAccount.SelectedItem IsNot Nothing Then
                        Dim selectedBankID = CInt(cmbBankAccount.SelectedItem.GetType().GetProperty("BankAccountID").GetValue(cmbBankAccount.SelectedItem, Nothing))
                        If selectedBankID > 0 Then
                            ' Get account number for selected bank account
                            Dim accountNumber As String = Nothing
                            Using cmdAcct As New SqlCommand("SELECT AccountNumber FROM BankAccounts WHERE BankAccountID = @BankAccountID", conn)
                                cmdAcct.Parameters.AddWithValue("@BankAccountID", selectedBankID)
                                accountNumber = cmdAcct.ExecuteScalar()?.ToString()
                            End Using
                            If Not String.IsNullOrEmpty(accountNumber) Then
                                sql &= " AND ast.AccountNumber = @AccountNumber"
                            End If
                        End If
                    End If

                    sql &= " ORDER BY ast.TransactionDate DESC, ast.TransactionID DESC"

                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@StartDate", dtpStartDate.Value.Date)
                        cmd.Parameters.AddWithValue("@EndDate", dtpEndDate.Value.Date)

                        If cmbBankAccount.SelectedItem IsNot Nothing Then
                            Dim selectedBankID = CInt(cmbBankAccount.SelectedItem.GetType().GetProperty("BankAccountID").GetValue(cmbBankAccount.SelectedItem, Nothing))
                            If selectedBankID > 0 Then
                                Dim accountNumber As String = Nothing
                                Using cmdAcct As New SqlCommand("SELECT AccountNumber FROM BankAccounts WHERE BankAccountID = @BankAccountID", conn)
                                    cmdAcct.Parameters.AddWithValue("@BankAccountID", selectedBankID)
                                    accountNumber = cmdAcct.ExecuteScalar()?.ToString()
                                End Using
                                If Not String.IsNullOrEmpty(accountNumber) Then
                                    cmd.Parameters.AddWithValue("@AccountNumber", accountNumber)
                                End If
                            End If
                        End If

                        Using adapter As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            adapter.Fill(dt)
                            dgvTransactions.DataSource = dt
                        End Using
                    End Using
                End Using

                FormatGrid()

            Catch ex As Exception
                MessageBox.Show($"Error loading transactions: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub FormatGrid()
            If dgvTransactions.Columns.Contains("StatementLineID") Then
                dgvTransactions.Columns("StatementLineID").Visible = False
            End If

            If dgvTransactions.Columns.Contains("TransactionDate") Then
                dgvTransactions.Columns("TransactionDate").HeaderText = "Date"
                dgvTransactions.Columns("TransactionDate").Width = 100
                dgvTransactions.Columns("TransactionDate").DefaultCellStyle.Format = "dd/MM/yyyy"
            End If

            If dgvTransactions.Columns.Contains("Description") Then
                dgvTransactions.Columns("Description").HeaderText = "Description"
                dgvTransactions.Columns("Description").Width = 350
            End If

            If dgvTransactions.Columns.Contains("DebitAmount") Then
                dgvTransactions.Columns("DebitAmount").HeaderText = "Debit"
                dgvTransactions.Columns("DebitAmount").Width = 100
                dgvTransactions.Columns("DebitAmount").DefaultCellStyle.Format = "N2"
                dgvTransactions.Columns("DebitAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If

            If dgvTransactions.Columns.Contains("CreditAmount") Then
                dgvTransactions.Columns("CreditAmount").HeaderText = "Credit"
                dgvTransactions.Columns("CreditAmount").Width = 100
                dgvTransactions.Columns("CreditAmount").DefaultCellStyle.Format = "N2"
                dgvTransactions.Columns("CreditAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If

            If dgvTransactions.Columns.Contains("Balance") Then
                dgvTransactions.Columns("Balance").HeaderText = "Balance"
                dgvTransactions.Columns("Balance").Width = 120
                dgvTransactions.Columns("Balance").DefaultCellStyle.Format = "N2"
                dgvTransactions.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If

            If dgvTransactions.Columns.Contains("Status") Then
                dgvTransactions.Columns("Status").HeaderText = "Status"
                dgvTransactions.Columns("Status").Width = 100
            End If

            ' Color code rows by status
            For Each row As DataGridViewRow In dgvTransactions.Rows
                If row.Cells("Status").Value IsNot Nothing Then
                    Select Case row.Cells("Status").Value.ToString()
                        Case "Unmatched"
                            row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#FFEBEE")
                        Case "Matched"
                            row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#FFF9C4")
                        Case "Posted"
                            row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#E8F5E9")
                    End Select
                End If
            Next
        End Sub

        Private Sub LogStatus(message As String)
            If txtStatusLog.InvokeRequired Then
                txtStatusLog.Invoke(Sub() LogStatus(message))
            Else
                txtStatusLog.AppendText($"[{DateTime.Now:HH:mm:ss}] {message}{vbCrLf}")
                txtStatusLog.SelectionStart = txtStatusLog.Text.Length
                txtStatusLog.ScrollToCaret()
            End If
        End Sub

        Private Sub LogPayload(title As String, payload As String)
            LogStatus($">>> {title}")
            LogStatus(payload)
            LogStatus("")
        End Sub

        Private Sub LogResponse(title As String, response As String)
            LogStatus($"<<< {title}")
            LogStatus(response)
            LogStatus("========================================")
            LogStatus("")
        End Sub

        Private Sub btnDownloadFNB_Click(sender As Object, e As EventArgs) Handles btnDownloadFNB.Click
            Try
                If cmbBankAccount.SelectedItem Is Nothing OrElse CInt(cmbBankAccount.SelectedItem.GetType().GetProperty("BankAccountID").GetValue(cmbBankAccount.SelectedItem, Nothing)) = 0 Then
                    MessageBox.Show("Please select a specific bank account", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                Dim bankAccountID = CInt(cmbBankAccount.SelectedItem.GetType().GetProperty("BankAccountID").GetValue(cmbBankAccount.SelectedItem, Nothing))

                LogStatus("========================================")
                LogStatus("FNB TRANSACTION HISTORY API - DOWNLOAD")
                LogStatus("========================================")
                LogStatus("")
                LogStatus(">>> REQUEST DETAILS")
                LogStatus($"Bank Account ID: {bankAccountID}")
                LogStatus($"From Date: {dtpStartDate.Value:yyyy-MM-dd}")
                LogStatus($"To Date: {dtpEndDate.Value:yyyy-MM-dd}")
                LogStatus("")
                LogStatus("Obtaining OAuth access token...")

                Cursor = Cursors.WaitCursor
                Dim importedCount = _fnbService.DownloadBankStatement(bankAccountID, dtpStartDate.Value.Date, dtpEndDate.Value.Date, _userName)
                Cursor = Cursors.Default

                LogStatus("")
                LogStatus("<<< RESPONSE")
                LogStatus($"✓ SUCCESS: Downloaded {importedCount} transactions")
                LogStatus("========================================")
                LogStatus("")

                MessageBox.Show($"Successfully downloaded {importedCount} transactions from FNB Transaction History API", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)

                LoadStatistics()
                LoadTransactions()

            Catch ex As Exception
                Cursor = Cursors.Default
                LogStatus("")
                LogStatus("<<< ERROR")
                LogStatus($"✗ FAILED: {ex.Message}")
                LogStatus("========================================")
                LogStatus("")
                MessageBox.Show($"Error downloading statement: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnImportCSV_Click(sender As Object, e As EventArgs) Handles btnImportCSV.Click
            Try
                If cmbBankAccount.SelectedItem Is Nothing OrElse CInt(cmbBankAccount.SelectedItem.GetType().GetProperty("BankAccountID").GetValue(cmbBankAccount.SelectedItem, Nothing)) = 0 Then
                    MessageBox.Show("Please select a specific bank account", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                Using ofd As New OpenFileDialog With {
                    .Filter = "CSV Files (*.csv)|*.csv|All Files (*.*)|*.*",
                    .Title = "Select Bank Statement CSV File"
                }
                    If ofd.ShowDialog() = DialogResult.OK Then
                        Dim bankAccountID = CInt(cmbBankAccount.SelectedItem.GetType().GetProperty("BankAccountID").GetValue(cmbBankAccount.SelectedItem, Nothing))

                        LogStatus("========================================")
                        LogStatus("CSV IMPORT INITIATED")
                        LogPayload("IMPORT DETAILS", $"BankAccountID: {bankAccountID}, File: {System.IO.Path.GetFileName(ofd.FileName)}")

                        Cursor = Cursors.WaitCursor
                        Dim importedCount = _fnbService.ImportStatementFromCSV(bankAccountID, ofd.FileName, _userName)
                        Cursor = Cursors.Default

                        LogResponse("RESPONSE", $"SUCCESS: Imported {importedCount} transactions from CSV")

                        MessageBox.Show($"Successfully imported {importedCount} transactions from CSV", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)

                        LoadStatistics()
                        LoadTransactions()
                    End If
                End Using

            Catch ex As Exception
                Cursor = Cursors.Default
                LogResponse("ERROR", $"FAILED: {ex.Message}")
                MessageBox.Show($"Error importing CSV: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnAutoMatch_Click(sender As Object, e As EventArgs) Handles btnAutoMatch.Click
            Try
                Dim result = MessageBox.Show("Run auto-matching on unmatched transactions?" & vbCrLf & vbCrLf &
                                           "This will match bank transactions to pending supplier invoices and beneficiary payments based on reference numbers.",
                                           "Confirm Auto-Match", MessageBoxButtons.YesNo, MessageBoxIcon.Question)

                If result = DialogResult.Yes Then
                    Cursor = Cursors.WaitCursor

                    Using conn As New SqlConnection(_connectionString)
                        conn.Open()
                        Using cmd As New SqlCommand("sp_AutoMatchBankTransactions", conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.AddWithValue("@BankAccountID", DBNull.Value)
                            cmd.Parameters.AddWithValue("@StatementLineID", DBNull.Value)
                            cmd.Parameters.AddWithValue("@UserName", _userName)

                            Using reader = cmd.ExecuteReader()
                                If reader.Read() Then
                                    Dim totalMatched = CInt(reader("TotalMatched"))
                                    Dim supplierPayments = CInt(reader("SupplierPayments"))
                                    Dim beneficiaryPayments = CInt(reader("BeneficiaryPayments"))
                                    Dim customerDeposits = CInt(reader("CustomerDeposits"))
                                    Dim stillUnmatched = CInt(reader("StillUnmatched"))

                                    Cursor = Cursors.Default

                                    MessageBox.Show($"Auto-matching completed!" & vbCrLf & vbCrLf &
                                                  $"✅ Total Matched: {totalMatched}" & vbCrLf &
                                                  $"   - Supplier Payments: {supplierPayments}" & vbCrLf &
                                                  $"   - Beneficiary Payments: {beneficiaryPayments}" & vbCrLf &
                                                  $"   - Customer Deposits: {customerDeposits}" & vbCrLf & vbCrLf &
                                                  $"⚠️ Still Unmatched: {stillUnmatched}",
                                                  "Auto-Match Results", MessageBoxButtons.OK, MessageBoxIcon.Information)
                                End If
                            End Using
                        End Using
                    End Using

                    LoadStatistics()
                    LoadTransactions()
                End If

            Catch ex As Exception
                Cursor = Cursors.Default
                MessageBox.Show($"Error during auto-matching: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnPostToGL_Click(sender As Object, e As EventArgs) Handles btnPostToGL.Click
            Try
                ' Count matched transactions
                Dim matchedCount As Integer = 0
                Using conn As New SqlConnection(_connectionString)
                    conn.Open()
                    Using cmd As New SqlCommand("SELECT COUNT(*) FROM BankStatementTransactions WHERE Status = 'Matched' AND PostedToGL = 0", conn)
                        matchedCount = CInt(cmd.ExecuteScalar())
                    End Using
                End Using

                If matchedCount = 0 Then
                    MessageBox.Show("No matched transactions to post", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Return
                End If

                Dim result = MessageBox.Show($"Post {matchedCount} matched transactions to General Ledger?" & vbCrLf & vbCrLf &
                                           "This will:" & vbCrLf &
                                           "• Create GL entries (debits and credits)" & vbCrLf &
                                           "• Update supplier invoices to 'Paid'" & vbCrLf &
                                           "• Update beneficiary payments to 'Paid'" & vbCrLf &
                                           "• Mark transactions as 'Posted'" & vbCrLf & vbCrLf &
                                           "This action cannot be undone!",
                                           "Confirm GL Posting", MessageBoxButtons.YesNo, MessageBoxIcon.Warning)

                If result = DialogResult.Yes Then
                    Cursor = Cursors.WaitCursor

                    Using conn As New SqlConnection(_connectionString)
                        conn.Open()
                        Using cmd As New SqlCommand("sp_PostBankTransactionsToGL", conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.CommandTimeout = 120
                            cmd.Parameters.AddWithValue("@StatementLineID", DBNull.Value)
                            cmd.Parameters.AddWithValue("@BankAccountID", DBNull.Value)
                            cmd.Parameters.AddWithValue("@UserName", _userName)
                            cmd.Parameters.AddWithValue("@PostingDate", Date.Today)

                            Using reader = cmd.ExecuteReader()
                                If reader.Read() Then
                                    If reader("TransactionsPosted") IsNot DBNull.Value Then
                                        Dim posted = CInt(reader("TransactionsPosted"))
                                        Dim totalDebits = CDec(reader("TotalDebits"))
                                        Dim totalCredits = CDec(reader("TotalCredits"))
                                        Dim batchID = CInt(reader("GLBatchID"))

                                        Cursor = Cursors.Default

                                        MessageBox.Show($"GL Posting Successful!" & vbCrLf & vbCrLf &
                                                      $"✅ Transactions Posted: {posted}" & vbCrLf &
                                                      $"💰 Total Debits: R{totalDebits:N2}" & vbCrLf &
                                                      $"💰 Total Credits: R{totalCredits:N2}" & vbCrLf &
                                                      $"📋 GL Batch ID: {batchID}" & vbCrLf & vbCrLf &
                                                      $"✓ Debits = Credits (Balanced)",
                                                      "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                                    Else
                                        Cursor = Cursors.Default
                                        MessageBox.Show($"Posting Failed: {reader("ErrorMessage")}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                    End If
                                End If
                            End Using
                        End Using
                    End Using

                    LoadStatistics()
                    LoadTransactions()
                End If

            Catch ex As Exception
                Cursor = Cursors.Default
                MessageBox.Show($"Error posting to GL: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
            LoadStatistics()
            LoadTransactions()
        End Sub

    End Class
End Namespace
