Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Accounting
    Public Class DailyPostingReportForm
        Inherits Form

        Private WithEvents dgvPostings As DataGridView
        Private WithEvents dgvSummary As DataGridView
        Private WithEvents dgvVerification As DataGridView
        Private WithEvents btnRefresh As Button
        Private WithEvents btnExport As Button
        Private WithEvents dtpFromDate As DateTimePicker
        Private WithEvents dtpToDate As DateTimePicker
        Private WithEvents cboBranch As ComboBox
        Private WithEvents cboAccount As ComboBox
        Private WithEvents tabControl As TabControl
        Private WithEvents lblTotalDebits As Label
        Private WithEvents lblTotalCredits As Label
        Private WithEvents lblDifference As Label
        Private WithEvents lblStatus As Label
        Private _connString As String
        Private _currentBranchID As Integer
        Private _currentUserID As Integer

        Public Sub New()
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            _currentBranchID = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
            _currentUserID = If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 1)
            
            LoadBranches()
            LoadAccounts()
            LoadDailyPostings()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Daily GL Posting Report"
            Me.Size = New Size(1600, 900)
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            ' Header Panel
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = Color.FromArgb(52, 73, 94),
                .Padding = New Padding(20)
            }

            Dim lblTitle As New Label() With {
                .Text = "Daily GL Posting Report",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 15)
            }
            pnlHeader.Controls.Add(lblTitle)

            Dim lblSubtitle As New Label() With {
                .Text = "View all GL postings with double-entry verification",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 45)
            }
            pnlHeader.Controls.Add(lblSubtitle)

            ' Filter Panel
            Dim pnlFilter As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 100,
                .BackColor = Color.FromArgb(236, 240, 241),
                .Padding = New Padding(20, 10, 20, 10)
            }

            ' Row 1: Date filters
            Dim lblFromDate As New Label() With {
                .Text = "From Date:",
                .Location = New Point(20, 18),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblFromDate)

            dtpFromDate = New DateTimePicker() With {
                .Location = New Point(100, 15),
                .Width = 150,
                .Format = DateTimePickerFormat.Short,
                .Value = DateTime.Today
            }
            pnlFilter.Controls.Add(dtpFromDate)

            Dim lblToDate As New Label() With {
                .Text = "To Date:",
                .Location = New Point(270, 18),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblToDate)

            dtpToDate = New DateTimePicker() With {
                .Location = New Point(340, 15),
                .Width = 150,
                .Format = DateTimePickerFormat.Short,
                .Value = DateTime.Today
            }
            pnlFilter.Controls.Add(dtpToDate)

            ' Row 2: Branch and Account filters
            Dim lblBranch As New Label() With {
                .Text = "Branch:",
                .Location = New Point(20, 53),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblBranch)

            cboBranch = New ComboBox() With {
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Location = New Point(100, 50),
                .Width = 200
            }
            pnlFilter.Controls.Add(cboBranch)

            Dim lblAccount As New Label() With {
                .Text = "Account:",
                .Location = New Point(320, 53),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblAccount)

            cboAccount = New ComboBox() With {
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Location = New Point(390, 50),
                .Width = 250
            }
            pnlFilter.Controls.Add(cboAccount)

            btnRefresh = New Button() With {
                .Text = "🔄 Refresh",
                .Location = New Point(660, 48),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            pnlFilter.Controls.Add(btnRefresh)

            btnExport = New Button() With {
                .Text = "📊 Export",
                .Location = New Point(780, 48),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            pnlFilter.Controls.Add(btnExport)

            ' Summary Panel
            Dim pnlSummary As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 60,
                .BackColor = Color.White,
                .Padding = New Padding(20, 10, 20, 10)
            }

            lblTotalDebits = New Label() With {
                .Text = "Total Debits: R0.00",
                .Location = New Point(20, 15),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = Color.FromArgb(52, 73, 94)
            }
            pnlSummary.Controls.Add(lblTotalDebits)

            lblTotalCredits = New Label() With {
                .Text = "Total Credits: R0.00",
                .Location = New Point(250, 15),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = Color.FromArgb(52, 73, 94)
            }
            pnlSummary.Controls.Add(lblTotalCredits)

            lblDifference = New Label() With {
                .Text = "Difference: R0.00",
                .Location = New Point(480, 15),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = Color.FromArgb(52, 73, 94)
            }
            pnlSummary.Controls.Add(lblDifference)

            lblStatus = New Label() With {
                .Text = "✓ BALANCED",
                .Location = New Point(710, 15),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = Color.FromArgb(46, 204, 113)
            }
            pnlSummary.Controls.Add(lblStatus)

            ' Tab Control
            tabControl = New TabControl() With {
                .Dock = DockStyle.Fill,
                .Padding = New Point(10, 5)
            }

            ' Tab 1: All Postings
            Dim tabPostings As New TabPage("All GL Postings") With {
                .BackColor = Color.White,
                .Padding = New Padding(10)
            }

            dgvPostings = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {.BackColor = Color.FromArgb(245, 245, 245)}
            }
            tabPostings.Controls.Add(dgvPostings)

            ' Tab 2: Summary by Type
            Dim tabSummary As New TabPage("Summary by Type") With {
                .BackColor = Color.White,
                .Padding = New Padding(10)
            }

            dgvSummary = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {.BackColor = Color.FromArgb(245, 245, 245)}
            }
            tabSummary.Controls.Add(dgvSummary)

            ' Tab 3: Verification (Unbalanced Entries)
            Dim tabVerification As New TabPage("Double-Entry Verification") With {
                .BackColor = Color.White,
                .Padding = New Padding(10)
            }

            dgvVerification = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {.BackColor = Color.FromArgb(245, 245, 245)}
            }
            tabVerification.Controls.Add(dgvVerification)

            tabControl.TabPages.Add(tabPostings)
            tabControl.TabPages.Add(tabSummary)
            tabControl.TabPages.Add(tabVerification)

            Me.Controls.Add(tabControl)
            Me.Controls.Add(pnlSummary)
            Me.Controls.Add(pnlFilter)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadBranches()
            Try
                cboBranch.Items.Clear()
                cboBranch.Items.Add(New With {.BranchID = 0, .BranchName = "All Branches"})
                
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                    Using cmd As New SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                cboBranch.Items.Add(New With {
                                    .BranchID = reader.GetInt32(0),
                                    .BranchName = reader.GetString(1)
                                })
                            End While
                        End Using
                    End Using
                End Using
                
                cboBranch.DisplayMember = "BranchName"
                cboBranch.ValueMember = "BranchID"
                If cboBranch.Items.Count > 0 Then cboBranch.SelectedIndex = 0
            Catch ex As Exception
                MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadAccounts()
            Try
                cboAccount.Items.Clear()
                cboAccount.Items.Add(New With {.AccountCode = "", .AccountName = "All Accounts"})
                
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim sql = "SELECT AccountCode, AccountName FROM ChartOfAccounts WHERE IsActive = 1 ORDER BY AccountCode"
                    Using cmd As New SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                cboAccount.Items.Add(New With {
                                    .AccountCode = reader.GetString(0),
                                    .AccountName = reader.GetString(0) & " - " & reader.GetString(1)
                                })
                            End While
                        End Using
                    End Using
                End Using
                
                cboAccount.DisplayMember = "AccountName"
                cboAccount.ValueMember = "AccountCode"
                If cboAccount.Items.Count > 0 Then cboAccount.SelectedIndex = 0
            Catch ex As Exception
                MessageBox.Show($"Error loading accounts: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadDailyPostings()
            Try
                Dim branchID As Integer? = Nothing
                If cboBranch.SelectedItem IsNot Nothing Then
                    Dim selectedBranch = DirectCast(cboBranch.SelectedItem, Object)
                    Dim bid = CInt(selectedBranch.BranchID)
                    If bid > 0 Then branchID = bid
                End If

                Dim accountCode As String = Nothing
                If cboAccount.SelectedItem IsNot Nothing Then
                    Dim selectedAccount = DirectCast(cboAccount.SelectedItem, Object)
                    Dim ac = selectedAccount.AccountCode.ToString()
                    If Not String.IsNullOrEmpty(ac) Then accountCode = ac
                End If

                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    
                    ' Load main postings
                    Using cmd As New SqlCommand("sp_GL_DailyPostingReport", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@FromDate", dtpFromDate.Value.Date)
                        cmd.Parameters.AddWithValue("@ToDate", dtpToDate.Value.Date)
                        If branchID.HasValue Then
                            cmd.Parameters.AddWithValue("@BranchID", branchID.Value)
                        Else
                            cmd.Parameters.AddWithValue("@BranchID", DBNull.Value)
                        End If
                        If Not String.IsNullOrEmpty(accountCode) Then
                            cmd.Parameters.AddWithValue("@AccountCode", accountCode)
                        Else
                            cmd.Parameters.AddWithValue("@AccountCode", DBNull.Value)
                        End If

                        Using adapter As New SqlDataAdapter(cmd)
                            Dim ds As New DataSet()
                            adapter.Fill(ds)

                            ' Tab 1: All Postings
                            If ds.Tables.Count > 0 Then
                                dgvPostings.DataSource = ds.Tables(0)
                                FormatPostingsGrid()
                                
                                ' Calculate totals
                                Dim totalDebits = ds.Tables(0).AsEnumerable().Sum(Function(row) row.Field(Of Decimal)("Debit"))
                                Dim totalCredits = ds.Tables(0).AsEnumerable().Sum(Function(row) row.Field(Of Decimal)("Credit"))
                                Dim difference = totalDebits - totalCredits
                                
                                lblTotalDebits.Text = $"Total Debits: R{totalDebits:N2}"
                                lblTotalCredits.Text = $"Total Credits: R{totalCredits:N2}"
                                lblDifference.Text = $"Difference: R{difference:N2}"
                                
                                If difference = 0 Then
                                    lblStatus.Text = "✓ BALANCED"
                                    lblStatus.ForeColor = Color.FromArgb(46, 204, 113)
                                Else
                                    lblStatus.Text = "✗ OUT OF BALANCE"
                                    lblStatus.ForeColor = Color.FromArgb(231, 76, 60)
                                End If
                            End If

                            ' Tab 2: Summary
                            If ds.Tables.Count > 1 Then
                                dgvSummary.DataSource = ds.Tables(1)
                                FormatSummaryGrid()
                            End If

                            ' Tab 3: Verification
                            If ds.Tables.Count > 2 Then
                                dgvVerification.DataSource = ds.Tables(2)
                                FormatVerificationGrid()
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading postings: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub FormatPostingsGrid()
            If dgvPostings.Columns.Count > 0 Then
                dgvPostings.Columns("JournalID").Visible = False
                dgvPostings.Columns("JournalNumber").HeaderText = "Journal #"
                dgvPostings.Columns("JournalNumber").Width = 120
                dgvPostings.Columns("JournalDate").HeaderText = "Date"
                dgvPostings.Columns("JournalDate").Width = 100
                dgvPostings.Columns("Reference").HeaderText = "Reference"
                dgvPostings.Columns("Reference").Width = 120
                dgvPostings.Columns("JournalDescription").HeaderText = "Journal Desc"
                dgvPostings.Columns("BranchName").HeaderText = "Branch"
                dgvPostings.Columns("BranchName").Width = 120
                dgvPostings.Columns("LineNumber").HeaderText = "Line"
                dgvPostings.Columns("LineNumber").Width = 50
                dgvPostings.Columns("AccountCode").HeaderText = "Account"
                dgvPostings.Columns("AccountCode").Width = 80
                dgvPostings.Columns("AccountName").HeaderText = "Account Name"
                dgvPostings.Columns("AccountType").HeaderText = "Type"
                dgvPostings.Columns("AccountType").Width = 80
                dgvPostings.Columns("Debit").HeaderText = "Debit"
                dgvPostings.Columns("Debit").DefaultCellStyle.Format = "N2"
                dgvPostings.Columns("Debit").Width = 100
                dgvPostings.Columns("Credit").HeaderText = "Credit"
                dgvPostings.Columns("Credit").DefaultCellStyle.Format = "N2"
                dgvPostings.Columns("Credit").Width = 100
                dgvPostings.Columns("LineDescription").HeaderText = "Line Desc"
                dgvPostings.Columns("TransactionType").HeaderText = "Type"
                dgvPostings.Columns("TransactionType").Width = 120
                
                ' Color code by transaction type
                For Each row As DataGridViewRow In dgvPostings.Rows
                    If Not row.IsNewRow Then
                        Dim transType = row.Cells("TransactionType").Value?.ToString()
                        Select Case transType
                            Case "POS Sale"
                                row.DefaultCellStyle.BackColor = Color.FromArgb(230, 245, 255)
                            Case "AP Invoice", "AP Payment"
                                row.DefaultCellStyle.BackColor = Color.FromArgb(255, 245, 230)
                            Case "Stock Adjustment", "Wastage"
                                row.DefaultCellStyle.BackColor = Color.FromArgb(255, 235, 235)
                        End Select
                    End If
                Next
            End If
        End Sub

        Private Sub FormatSummaryGrid()
            If dgvSummary.Columns.Count > 0 Then
                dgvSummary.Columns("TransactionType").HeaderText = "Transaction Type"
                dgvSummary.Columns("TransactionCount").HeaderText = "Count"
                dgvSummary.Columns("TotalDebits").HeaderText = "Total Debits"
                dgvSummary.Columns("TotalDebits").DefaultCellStyle.Format = "N2"
                dgvSummary.Columns("TotalCredits").HeaderText = "Total Credits"
                dgvSummary.Columns("TotalCredits").DefaultCellStyle.Format = "N2"
            End If
        End Sub

        Private Sub FormatVerificationGrid()
            If dgvVerification.Columns.Count > 0 Then
                dgvVerification.Columns("JournalNumber").HeaderText = "Journal #"
                dgvVerification.Columns("JournalDate").HeaderText = "Date"
                dgvVerification.Columns("Description").HeaderText = "Description"
                dgvVerification.Columns("TotalDebits").HeaderText = "Total Debits"
                dgvVerification.Columns("TotalDebits").DefaultCellStyle.Format = "N2"
                dgvVerification.Columns("TotalCredits").HeaderText = "Total Credits"
                dgvVerification.Columns("TotalCredits").DefaultCellStyle.Format = "N2"
                dgvVerification.Columns("Difference").HeaderText = "Difference"
                dgvVerification.Columns("Difference").DefaultCellStyle.Format = "N2"
                dgvVerification.Columns("Status").HeaderText = "Status"
                
                ' Highlight unbalanced entries
                For Each row As DataGridViewRow In dgvVerification.Rows
                    If Not row.IsNewRow Then
                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 230, 230)
                        row.DefaultCellStyle.ForeColor = Color.FromArgb(192, 57, 43)
                    End If
                Next
            End If
        End Sub

        Private Sub BtnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
            LoadDailyPostings()
        End Sub

        Private Sub BtnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
            MessageBox.Show("Export functionality coming soon!", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub DtpFromDate_ValueChanged(sender As Object, e As EventArgs) Handles dtpFromDate.ValueChanged
            LoadDailyPostings()
        End Sub

        Private Sub DtpToDate_ValueChanged(sender As Object, e As EventArgs) Handles dtpToDate.ValueChanged
            LoadDailyPostings()
        End Sub

        Private Sub CboBranch_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboBranch.SelectedIndexChanged
            LoadDailyPostings()
        End Sub

        Private Sub CboAccount_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboAccount.SelectedIndexChanged
            LoadDailyPostings()
        End Sub
    End Class
End Namespace
