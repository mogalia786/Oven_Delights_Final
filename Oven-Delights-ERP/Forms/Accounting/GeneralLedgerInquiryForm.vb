Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data

Public Class GeneralLedgerInquiryForm
    Inherits Form

    Private ReadOnly _glService As New GeneralLedgerService()
    Private ReadOnly _connectionString As String
    
    ' Control references
    Private cboAccount As ComboBox
    Private dtpFrom As DateTimePicker
    Private dtpTo As DateTimePicker
    Private dgvLedger As DataGridView
    Private lblAccountInfo As Label
    Private lblBalance As Label

    Public Sub New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        InitializeComponent()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "General Ledger Inquiry"
        Me.Size = New Size(1400, 800)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.FromArgb(240, 240, 245)

        Dim pnlMain As New Panel With {.Dock = DockStyle.Fill, .Padding = New Padding(20)}

        ' Title
        Dim lblTitle As New Label With {
            .Text = "General Ledger Inquiry",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .Dock = DockStyle.Top,
            .Height = 50,
            .ForeColor = Color.FromArgb(41, 128, 185),
            .TextAlign = ContentAlignment.MiddleLeft
        }

        ' Filter Panel
        Dim pnlFilter As New Panel With {.Dock = DockStyle.Top, .Height = 100, .BackColor = Color.White}

        Dim lblAccount As New Label With {.Text = "Account:", .Location = New Point(20, 15), .Width = 70}
        cboAccount = New ComboBox With {
            .Location = New Point(100, 12),
            .Width = 300,
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Name = "cboAccount"
        }

        Dim lblFrom As New Label With {.Text = "From:", .Location = New Point(420, 15), .Width = 50}
        dtpFrom = New DateTimePicker With {
            .Location = New Point(480, 12),
            .Width = 150,
            .Name = "dtpFrom",
            .Value = New Date(DateTime.Now.Year, 1, 1)
        }

        Dim lblTo As New Label With {.Text = "To:", .Location = New Point(650, 15), .Width = 30}
        dtpTo = New DateTimePicker With {
            .Location = New Point(690, 12),
            .Width = 150,
            .Name = "dtpTo"
        }

        Dim btnSearch As New Button With {
            .Text = "Search",
            .Location = New Point(860, 10),
            .Size = New Size(120, 35),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnSearch.FlatAppearance.BorderSize = 0
        AddHandler btnSearch.Click, AddressOf BtnSearch_Click

        ' Account Info Labels
        lblAccountInfo = New Label With {
            .Name = "lblAccountInfo",
            .Location = New Point(20, 55),
            .Width = 600,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 73, 94)
        }

        lblBalance = New Label With {
            .Name = "lblBalance",
            .Location = New Point(640, 55),
            .Width = 340,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = Color.FromArgb(39, 174, 96),
            .TextAlign = ContentAlignment.MiddleRight
        }

        pnlFilter.Controls.AddRange({lblAccount, cboAccount, lblFrom, dtpFrom, lblTo, dtpTo, btnSearch, lblAccountInfo, lblBalance})

        ' DataGridView
        dgvLedger = New DataGridView With {
            .Dock = DockStyle.Fill,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .Name = "dgvLedger",
            .RowHeadersVisible = False,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .ColumnHeadersHeight = 40,
            .DefaultCellStyle = New DataGridViewCellStyle With {
                .Font = New Font("Segoe UI", 10),
                .SelectionBackColor = Color.FromArgb(52, 152, 219),
                .SelectionForeColor = Color.White
            },
            .ColumnHeadersDefaultCellStyle = New DataGridViewCellStyle With {
                .BackColor = Color.FromArgb(52, 73, 94),
                .ForeColor = Color.White,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Padding = New Padding(5)
            },
            .EnableHeadersVisualStyles = False,
            .RowTemplate = New DataGridViewRow With {.Height = 35}
        }
        AddHandler dgvLedger.CellDoubleClick, AddressOf DgvLedger_CellDoubleClick

        pnlMain.Controls.Add(dgvLedger)
        pnlMain.Controls.Add(pnlFilter)
        pnlMain.Controls.Add(lblTitle)
        Me.Controls.Add(pnlMain)

        AddHandler Me.Load, AddressOf Form_Load
    End Sub

    Private Sub Form_Load(sender As Object, e As EventArgs)
        LoadAccounts()
    End Sub

    Private Sub LoadAccounts()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT AccountID, AccountCode + ' - ' + AccountName AS DisplayName, AccountCode FROM ChartOfAccounts WHERE IsActive = 1 ORDER BY AccountCode"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        Dim dt As New DataTable()
                        dt.Load(reader)
                        cboAccount.DisplayMember = "DisplayName"
                        cboAccount.ValueMember = "AccountCode"
                        cboAccount.DataSource = dt
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading accounts: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnSearch_Click(sender As Object, e As EventArgs)
        Try
            If cboAccount.SelectedValue Is Nothing Then
                MessageBox.Show("Please select an account", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim accountCode = cboAccount.SelectedValue.ToString()
            Dim dt = _glService.GetAccountLedger(accountCode, dtpFrom.Value, dtpTo.Value, Nothing)
            dgvLedger.DataSource = dt

            If dt.Rows.Count > 0 Then
                ' Format columns
                dgvLedger.Columns("JournalDate").HeaderText = "Date"
                dgvLedger.Columns("JournalDate").Width = 100
                dgvLedger.Columns("JournalDate").DefaultCellStyle.Format = "yyyy-MM-dd"
                dgvLedger.Columns("JournalNumber").HeaderText = "Journal #"
                dgvLedger.Columns("JournalNumber").Width = 120
                dgvLedger.Columns("Reference").HeaderText = "Reference"
                dgvLedger.Columns("Reference").Width = 120
                dgvLedger.Columns("Description").HeaderText = "Description"
                dgvLedger.Columns("Debit").HeaderText = "Debit"
                dgvLedger.Columns("Debit").DefaultCellStyle.Format = "N2"
                dgvLedger.Columns("Debit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgvLedger.Columns("Debit").Width = 120
                dgvLedger.Columns("Credit").HeaderText = "Credit"
                dgvLedger.Columns("Credit").DefaultCellStyle.Format = "N2"
                dgvLedger.Columns("Credit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgvLedger.Columns("Credit").Width = 120
                dgvLedger.Columns("RunningBalance").HeaderText = "Balance"
                dgvLedger.Columns("RunningBalance").DefaultCellStyle.Format = "N2"
                dgvLedger.Columns("RunningBalance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgvLedger.Columns("RunningBalance").Width = 120

                ' Color-code debits and credits
                For Each row As DataGridViewRow In dgvLedger.Rows
                    Dim debit = CDec(row.Cells("Debit").Value)
                    Dim credit = CDec(row.Cells("Credit").Value)
                    
                    If debit > 0 Then
                        row.Cells("Debit").Style.ForeColor = Color.FromArgb(39, 174, 96)
                        row.Cells("Debit").Style.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                    End If
                    
                    If credit > 0 Then
                        row.Cells("Credit").Style.ForeColor = Color.FromArgb(231, 76, 60)
                        row.Cells("Credit").Style.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                    End If

                    ' Color running balance
                    Dim balance = CDec(row.Cells("RunningBalance").Value)
                    If balance >= 0 Then
                        row.Cells("RunningBalance").Style.ForeColor = Color.FromArgb(39, 174, 96)
                    Else
                        row.Cells("RunningBalance").Style.ForeColor = Color.FromArgb(231, 76, 60)
                    End If
                Next

                ' Update info labels
                lblAccountInfo.Text = cboAccount.Text
                Dim finalBalance = CDec(dt.Rows(dt.Rows.Count - 1)("RunningBalance"))
                lblBalance.Text = $"Current Balance: R {finalBalance:N2}"
                lblBalance.ForeColor = If(finalBalance >= 0, Color.FromArgb(39, 174, 96), Color.FromArgb(231, 76, 60))
            Else
                lblAccountInfo.Text = "No transactions found"
                lblBalance.Text = ""
            End If
        Catch ex As Exception
            MessageBox.Show($"Error searching ledger: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub DgvLedger_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex < 0 Then Return

        Try
            Dim journalNumber = dgvLedger.Rows(e.RowIndex).Cells("JournalNumber").Value.ToString()
            
            ' Show journal details
            ShowJournalDetails(journalNumber)
        Catch ex As Exception
            MessageBox.Show($"Error showing journal details: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ShowJournalDetails(journalNumber As String)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT jd.LineNumber, coa.AccountCode, coa.AccountName, jd.Debit, jd.Credit, jd.Description, " &
                         "jh.JournalDate, jh.Reference, jh.Description AS JournalDescription " &
                         "FROM JournalDetails jd " &
                         "INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID " &
                         "INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID " &
                         "WHERE jh.JournalNumber = @JournalNumber " &
                         "ORDER BY jd.LineNumber"
                
                Using adapter As New SqlDataAdapter(sql, conn)
                    adapter.SelectCommand.Parameters.AddWithValue("@JournalNumber", journalNumber)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)

                    If dt.Rows.Count = 0 Then
                        MessageBox.Show("No journal details found for this journal number.", "No Data", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Return
                    End If

                    ' Create a simple form to display journal details
                    Dim detailsForm As New Form With {
                        .Text = $"Journal Details - {journalNumber}",
                        .Size = New Size(900, 600),
                        .StartPosition = FormStartPosition.CenterParent,
                        .BackColor = Color.White
                    }

                    ' Header info
                    Dim pnlHeader As New Panel With {.Dock = DockStyle.Top, .Height = 80, .BackColor = Color.FromArgb(52, 152, 219), .Padding = New Padding(15)}
                    Dim lblJournal As New Label With {
                        .Text = $"Journal: {journalNumber}",
                        .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                        .ForeColor = Color.White,
                        .Dock = DockStyle.Top,
                        .Height = 30
                    }
                    Dim lblDate As New Label With {
                        .Text = $"Date: {CDate(dt.Rows(0)("JournalDate")):yyyy-MM-dd} | {dt.Rows(0)("JournalDescription")}",
                        .Font = New Font("Segoe UI", 10),
                        .ForeColor = Color.White,
                        .Dock = DockStyle.Top,
                        .Height = 25
                    }
                    pnlHeader.Controls.AddRange({lblDate, lblJournal})

                    ' DataGridView for details
                    Dim dgvDetails As New DataGridView With {
                        .Dock = DockStyle.Fill,
                        .AutoGenerateColumns = True,
                        .AllowUserToAddRows = False,
                        .AllowUserToDeleteRows = False,
                        .ReadOnly = True,
                        .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                        .BackgroundColor = Color.White,
                        .BorderStyle = BorderStyle.None,
                        .RowHeadersVisible = False,
                        .Font = New Font("Segoe UI", 10)
                    }
                    dgvDetails.DataSource = dt
                    dgvDetails.Columns("JournalDate").Visible = False
                    dgvDetails.Columns("Reference").Visible = False
                    dgvDetails.Columns("JournalDescription").Visible = False
                    dgvDetails.Columns("LineNumber").Width = 60
                    dgvDetails.Columns("AccountCode").Width = 100
                    dgvDetails.Columns("AccountName").Width = 250
                    dgvDetails.Columns("Description").Width = 200
                    dgvDetails.Columns("Debit").DefaultCellStyle.Format = "N2"
                    dgvDetails.Columns("Debit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    dgvDetails.Columns("Credit").DefaultCellStyle.Format = "N2"
                    dgvDetails.Columns("Credit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight

                    ' Summary panel
                    Dim pnlSummary As New Panel With {.Dock = DockStyle.Bottom, .Height = 50, .BackColor = Color.FromArgb(240, 240, 245), .Padding = New Padding(15)}
                    Dim totalDebit = dt.AsEnumerable().Sum(Function(r) CDec(r("Debit")))
                    Dim totalCredit = dt.AsEnumerable().Sum(Function(r) CDec(r("Credit")))
                    Dim lblSummary As New Label With {
                        .Text = $"Total Debits: R {totalDebit:N2}  |  Total Credits: R {totalCredit:N2}  |  Balanced: {If(totalDebit = totalCredit, "✓ Yes", "✗ No")}",
                        .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                        .Dock = DockStyle.Fill,
                        .TextAlign = ContentAlignment.MiddleCenter,
                        .ForeColor = If(totalDebit = totalCredit, Color.FromArgb(39, 174, 96), Color.FromArgb(231, 76, 60))
                    }
                    pnlSummary.Controls.Add(lblSummary)

                    detailsForm.Controls.AddRange({dgvDetails, pnlSummary, pnlHeader})
                    detailsForm.ShowDialog(Me)
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading journal details: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
