Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data

Public Class ManualJournalEntryForm
    Inherits Form

    Private ReadOnly _glService As New GeneralLedgerService()
    Private ReadOnly _connectionString As String
    Private _journalLines As New DataTable()
    Private _currentUser As String = "System"

    Public Sub New()
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        InitializeJournalLinesTable()
    End Sub

    Private Sub InitializeJournalLinesTable()
        _journalLines.Columns.Add("LineNumber", GetType(Integer))
        _journalLines.Columns.Add("AccountCode", GetType(String))
        _journalLines.Columns.Add("AccountName", GetType(String))
        _journalLines.Columns.Add("Description", GetType(String))
        _journalLines.Columns.Add("Debit", GetType(Decimal))
        _journalLines.Columns.Add("Credit", GetType(Decimal))
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Manual Journal Entry"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.FromArgb(240, 240, 245)

        Dim pnlMain As New Panel With {.Dock = DockStyle.Fill, .Padding = New Padding(20)}

        ' Title
        Dim lblTitle As New Label With {
            .Text = "Manual Journal Entry",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .Dock = DockStyle.Top,
            .Height = 50,
            .ForeColor = Color.FromArgb(142, 68, 173),
            .TextAlign = ContentAlignment.MiddleLeft
        }

        ' Header Panel
        Dim pnlHeader As New Panel With {.Dock = DockStyle.Top, .Height = 120, .BackColor = Color.White}

        Dim lblDate As New Label With {.Text = "Journal Date:", .Location = New Point(20, 15), .Width = 100}
        Dim dtpDate As New DateTimePicker With {
            .Location = New Point(130, 12),
            .Width = 150,
            .Name = "dtpDate"
        }

        Dim lblRef As New Label With {.Text = "Reference:", .Location = New Point(300, 15), .Width = 80}
        Dim txtRef As New TextBox With {
            .Location = New Point(390, 12),
            .Width = 200,
            .Name = "txtRef"
        }

        Dim lblDesc As New Label With {.Text = "Description:", .Location = New Point(20, 55), .Width = 100}
        Dim txtDesc As New TextBox With {
            .Location = New Point(130, 52),
            .Width = 460,
            .Name = "txtDesc"
        }

        pnlHeader.Controls.AddRange({lblDate, dtpDate, lblRef, txtRef, lblDesc, txtDesc})

        ' Line Entry Panel
        Dim pnlLineEntry As New Panel With {.Dock = DockStyle.Top, .Height = 100, .BackColor = Color.FromArgb(236, 240, 241)}

        Dim lblAccount As New Label With {.Text = "Account:", .Location = New Point(20, 15), .Width = 70}
        Dim cboAccount As New ComboBox With {
            .Location = New Point(100, 12),
            .Width = 300,
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Name = "cboAccount"
        }

        Dim lblLineDesc As New Label With {.Text = "Description:", .Location = New Point(420, 15), .Width = 80}
        Dim txtLineDesc As New TextBox With {
            .Location = New Point(510, 12),
            .Width = 250,
            .Name = "txtLineDesc"
        }

        Dim lblDebit As New Label With {.Text = "Debit:", .Location = New Point(20, 55), .Width = 50}
        Dim txtDebit As New TextBox With {
            .Location = New Point(80, 52),
            .Width = 120,
            .Name = "txtDebit",
            .Text = "0.00"
        }

        Dim lblCredit As New Label With {.Text = "Credit:", .Location = New Point(220, 55), .Width = 50}
        Dim txtCredit As New TextBox With {
            .Location = New Point(280, 52),
            .Width = 120,
            .Name = "txtCredit",
            .Text = "0.00"
        }

        Dim btnAddLine As New Button With {
            .Text = "Add Line",
            .Location = New Point(420, 50),
            .Size = New Size(100, 30),
            .BackColor = Color.FromArgb(39, 174, 96),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold)
        }
        btnAddLine.FlatAppearance.BorderSize = 0
        AddHandler btnAddLine.Click, AddressOf BtnAddLine_Click

        Dim btnRemoveLine As New Button With {
            .Text = "Remove",
            .Location = New Point(530, 50),
            .Size = New Size(100, 30),
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold)
        }
        btnRemoveLine.FlatAppearance.BorderSize = 0
        AddHandler btnRemoveLine.Click, AddressOf BtnRemoveLine_Click

        pnlLineEntry.Controls.AddRange({lblAccount, cboAccount, lblLineDesc, txtLineDesc, lblDebit, txtDebit, lblCredit, txtCredit, btnAddLine, btnRemoveLine})

        ' DataGridView for lines
        Dim dgvLines As New DataGridView With {
            .Dock = DockStyle.Fill,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .Name = "dgvLines",
            .RowHeadersVisible = False,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .DefaultCellStyle = New DataGridViewCellStyle With {
                .Font = New Font("Segoe UI", 10),
                .SelectionBackColor = Color.FromArgb(142, 68, 173),
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
        dgvLines.DataSource = _journalLines

        ' Bottom Panel with totals and buttons
        Dim pnlBottom As New Panel With {.Dock = DockStyle.Bottom, .Height = 100, .BackColor = Color.FromArgb(236, 240, 241)}

        Dim lblTotalDebits As New Label With {
            .Name = "lblTotalDebits",
            .Location = New Point(20, 15),
            .Width = 250,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = Color.FromArgb(39, 174, 96)
        }

        Dim lblTotalCredits As New Label With {
            .Name = "lblTotalCredits",
            .Location = New Point(280, 15),
            .Width = 250,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = Color.FromArgb(231, 76, 60)
        }

        Dim lblDifference As New Label With {
            .Name = "lblDifference",
            .Location = New Point(540, 15),
            .Width = 300,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = Color.FromArgb(231, 76, 60)
        }

        Dim btnPost As New Button With {
            .Text = "Post Journal",
            .Location = New Point(880, 10),
            .Size = New Size(140, 40),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Enabled = False,
            .Name = "btnPost"
        }
        btnPost.FlatAppearance.BorderSize = 0
        AddHandler btnPost.Click, AddressOf BtnPost_Click

        Dim btnClear As New Button With {
            .Text = "Clear All",
            .Location = New Point(880, 55),
            .Size = New Size(140, 30),
            .BackColor = Color.FromArgb(149, 165, 166),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold)
        }
        btnClear.FlatAppearance.BorderSize = 0
        AddHandler btnClear.Click, AddressOf BtnClear_Click

        pnlBottom.Controls.AddRange({lblTotalDebits, lblTotalCredits, lblDifference, btnPost, btnClear})

        pnlMain.Controls.Add(dgvLines)
        pnlMain.Controls.Add(pnlBottom)
        pnlMain.Controls.Add(pnlLineEntry)
        pnlMain.Controls.Add(pnlHeader)
        pnlMain.Controls.Add(lblTitle)
        Me.Controls.Add(pnlMain)

        AddHandler Me.Load, AddressOf Form_Load
    End Sub

    Private Sub Form_Load(sender As Object, e As EventArgs)
        LoadAccounts()
        UpdateTotals()
    End Sub

    Private Sub LoadAccounts()
        Try
            Dim pnlMain = CType(Me.Controls(0), Panel)
            Dim cbo = CType(pnlMain.Controls("cboAccount"), ComboBox)

            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "SELECT AccountID, AccountCode + ' - ' + AccountName AS DisplayName, AccountCode, AccountName FROM ChartOfAccounts WHERE IsActive = 1 ORDER BY AccountCode"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        Dim dt As New DataTable()
                        dt.Load(reader)
                        cbo.DisplayMember = "DisplayName"
                        cbo.ValueMember = "AccountCode"
                        cbo.DataSource = dt
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading accounts: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnAddLine_Click(sender As Object, e As EventArgs)
        Try
            Dim pnlMain = CType(Me.Controls(0), Panel)
            Dim cboAccount = CType(pnlMain.Controls("cboAccount"), ComboBox)
            Dim txtLineDesc = CType(pnlMain.Controls("txtLineDesc"), TextBox)
            Dim txtDebit = CType(pnlMain.Controls("txtDebit"), TextBox)
            Dim txtCredit = CType(pnlMain.Controls("txtCredit"), TextBox)

            If cboAccount.SelectedValue Is Nothing Then
                MessageBox.Show("Please select an account", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim debit As Decimal
            Dim credit As Decimal

            If Not Decimal.TryParse(txtDebit.Text, debit) OrElse debit < 0 Then
                MessageBox.Show("Please enter a valid debit amount", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If Not Decimal.TryParse(txtCredit.Text, credit) OrElse credit < 0 Then
                MessageBox.Show("Please enter a valid credit amount", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If debit > 0 AndAlso credit > 0 Then
                MessageBox.Show("A line cannot have both debit and credit amounts", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If debit = 0 AndAlso credit = 0 Then
                MessageBox.Show("Please enter either a debit or credit amount", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim accountCode = cboAccount.SelectedValue.ToString()
            Dim accountName = CType(cboAccount.DataSource, DataTable).Select($"AccountCode = '{accountCode}'")(0)("AccountName").ToString()

            Dim row = _journalLines.NewRow()
            row("LineNumber") = _journalLines.Rows.Count + 1
            row("AccountCode") = accountCode
            row("AccountName") = accountName
            row("Description") = txtLineDesc.Text
            row("Debit") = debit
            row("Credit") = credit
            _journalLines.Rows.Add(row)

            ' Clear inputs
            txtLineDesc.Clear()
            txtDebit.Text = "0.00"
            txtCredit.Text = "0.00"

            UpdateTotals()
            FormatGrid()
        Catch ex As Exception
            MessageBox.Show($"Error adding line: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnRemoveLine_Click(sender As Object, e As EventArgs)
        Try
            Dim pnlMain = CType(Me.Controls(0), Panel)
            Dim dgv = CType(pnlMain.Controls("dgvLines"), DataGridView)

            If dgv.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a line to remove", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            _journalLines.Rows.RemoveAt(dgv.SelectedRows(0).Index)

            ' Renumber lines
            For i As Integer = 0 To _journalLines.Rows.Count - 1
                _journalLines.Rows(i)("LineNumber") = i + 1
            Next

            UpdateTotals()
        Catch ex As Exception
            MessageBox.Show($"Error removing line: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub UpdateTotals()
        Try
            Dim pnlMain = CType(Me.Controls(0), Panel)
            Dim lblDebits = CType(pnlMain.Controls("lblTotalDebits"), Label)
            Dim lblCredits = CType(pnlMain.Controls("lblTotalCredits"), Label)
            Dim lblDiff = CType(pnlMain.Controls("lblDifference"), Label)
            Dim btnPost = CType(pnlMain.Controls("btnPost"), Button)

            Dim totalDebits As Decimal = 0
            Dim totalCredits As Decimal = 0

            For Each row As DataRow In _journalLines.Rows
                totalDebits += CDec(row("Debit"))
                totalCredits += CDec(row("Credit"))
            Next

            Dim difference = totalDebits - totalCredits

            lblDebits.Text = $"Total Debits: R {totalDebits:N2}"
            lblCredits.Text = $"Total Credits: R {totalCredits:N2}"
            lblDiff.Text = $"Difference: R {difference:N2}"

            If Math.Abs(difference) < 0.01D AndAlso _journalLines.Rows.Count > 0 Then
                lblDiff.ForeColor = Color.FromArgb(39, 174, 96)
                lblDiff.Text = "✓ Balanced"
                btnPost.Enabled = True
            Else
                lblDiff.ForeColor = Color.FromArgb(231, 76, 60)
                btnPost.Enabled = False
            End If
        Catch ex As Exception
            MessageBox.Show($"Error updating totals: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub FormatGrid()
        Try
            Dim pnlMain = CType(Me.Controls(0), Panel)
            Dim dgv = CType(pnlMain.Controls("dgvLines"), DataGridView)

            If dgv.Columns.Count > 0 Then
                dgv.Columns("LineNumber").HeaderText = "#"
                dgv.Columns("LineNumber").Width = 50
                dgv.Columns("AccountCode").HeaderText = "Code"
                dgv.Columns("AccountCode").Width = 100
                dgv.Columns("AccountName").HeaderText = "Account"
                dgv.Columns("Description").HeaderText = "Description"
                dgv.Columns("Debit").HeaderText = "Debit"
                dgv.Columns("Debit").DefaultCellStyle.Format = "N2"
                dgv.Columns("Debit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgv.Columns("Debit").Width = 120
                dgv.Columns("Credit").HeaderText = "Credit"
                dgv.Columns("Credit").DefaultCellStyle.Format = "N2"
                dgv.Columns("Credit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgv.Columns("Credit").Width = 120

                ' Color-code debits and credits
                For Each row As DataGridViewRow In dgv.Rows
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
                Next
            End If
        Catch ex As Exception
            ' Ignore formatting errors
        End Try
    End Sub

    Private Sub BtnPost_Click(sender As Object, e As EventArgs)
        Try
            Dim pnlMain = CType(Me.Controls(0), Panel)
            Dim dtpDate = CType(pnlMain.Controls("dtpDate"), DateTimePicker)
            Dim txtRef = CType(pnlMain.Controls("txtRef"), TextBox)
            Dim txtDesc = CType(pnlMain.Controls("txtDesc"), TextBox)

            If String.IsNullOrWhiteSpace(txtDesc.Text) Then
                MessageBox.Show("Please enter a journal description", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If _journalLines.Rows.Count = 0 Then
                MessageBox.Show("Please add at least one journal line", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            ' Convert DataTable to List of JournalLineItem
            Dim lines As New List(Of JournalLineItem)
            For Each row As DataRow In _journalLines.Rows
                lines.Add(New JournalLineItem With {
                    .AccountCode = row("AccountCode").ToString(),
                    .Debit = CDec(row("Debit")),
                    .Credit = CDec(row("Credit")),
                    .Description = row("Description").ToString()
                })
            Next

            ' Post journal
            Dim journalId = _glService.PostCompleteJournal(
                dtpDate.Value,
                txtRef.Text,
                txtDesc.Text,
                Nothing,
                lines,
                _currentUser
            )

            MessageBox.Show($"Journal posted successfully! Journal ID: {journalId}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)

            ' Clear form
            BtnClear_Click(Nothing, Nothing)

        Catch ex As Exception
            MessageBox.Show($"Error posting journal: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnClear_Click(sender As Object, e As EventArgs)
        Try
            Dim pnlMain = CType(Me.Controls(0), Panel)
            Dim txtRef = CType(pnlMain.Controls("txtRef"), TextBox)
            Dim txtDesc = CType(pnlMain.Controls("txtDesc"), TextBox)
            Dim txtLineDesc = CType(pnlMain.Controls("txtLineDesc"), TextBox)
            Dim txtDebit = CType(pnlMain.Controls("txtDebit"), TextBox)
            Dim txtCredit = CType(pnlMain.Controls("txtCredit"), TextBox)

            txtRef.Clear()
            txtDesc.Clear()
            txtLineDesc.Clear()
            txtDebit.Text = "0.00"
            txtCredit.Text = "0.00"
            _journalLines.Clear()
            UpdateTotals()
        Catch ex As Exception
            MessageBox.Show($"Error clearing form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
