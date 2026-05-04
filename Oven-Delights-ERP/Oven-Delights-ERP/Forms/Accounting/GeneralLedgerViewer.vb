Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

''' <summary>
''' General Ledger Viewer - displays all accounting transactions
''' </summary>
Public Class GeneralLedgerViewer
    Inherits Form
    
    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchID As Integer
    
    Private dgvLedger As DataGridView
    Private dtpFrom As DateTimePicker
    Private dtpTo As DateTimePicker
    Private cboAccount As ComboBox
    Private btnFilter As Button
    Private btnExport As Button
    Private WithEvents btnPrint As Button
    Private btnClose As Button
    Private lblTotalDebits As Label
    Private lblTotalCredits As Label
    
    Public Sub New(branchID As Integer)
        _currentBranchID = branchID
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        InitializeComponent()
        LoadAccounts()
        LoadLedger()
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "General Ledger Viewer"
        Me.Size = New Size(1400, 800)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.White
        
        ' Header
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#34495E")
        }
        
        Dim lblTitle As New Label With {
            .Text = "📒 GENERAL LEDGER",
            .Font = New Font("Segoe UI", 20, FontStyle.Bold),
            .ForeColor = Color.White,
            .Location = New Point(20, 20),
            .AutoSize = True
        }
        pnlHeader.Controls.Add(lblTitle)
        
        ' Filter Panel
        Dim pnlFilter As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 70,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1"),
            .Padding = New Padding(20, 15, 20, 15)
        }
        
        Dim lblFrom As New Label With {
            .Text = "From:",
            .Location = New Point(20, 20),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        pnlFilter.Controls.Add(lblFrom)
        
        dtpFrom = New DateTimePicker With {
            .Location = New Point(70, 17),
            .Size = New Size(150, 25),
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Now.AddMonths(-1)
        }
        pnlFilter.Controls.Add(dtpFrom)
        
        Dim lblTo As New Label With {
            .Text = "To:",
            .Location = New Point(240, 20),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        pnlFilter.Controls.Add(lblTo)
        
        dtpTo = New DateTimePicker With {
            .Location = New Point(275, 17),
            .Size = New Size(150, 25),
            .Format = DateTimePickerFormat.Short
        }
        pnlFilter.Controls.Add(dtpTo)
        
        Dim lblAccount As New Label With {
            .Text = "Account:",
            .Location = New Point(445, 20),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        pnlFilter.Controls.Add(lblAccount)
        
        cboAccount = New ComboBox With {
            .Location = New Point(520, 17),
            .Size = New Size(300, 25),
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        pnlFilter.Controls.Add(cboAccount)
        
        btnFilter = New Button With {
            .Text = "🔍 Filter",
            .Location = New Point(840, 15),
            .Size = New Size(100, 30),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnFilter.FlatAppearance.BorderSize = 0
        AddHandler btnFilter.Click, AddressOf btnFilter_Click
        pnlFilter.Controls.Add(btnFilter)
        
        btnExport = New Button With {
            .Text = "📊 Export",
            .Location = New Point(960, 15),
            .Size = New Size(100, 30),
            .BackColor = ColorTranslator.FromHtml("#27AE60"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnExport.FlatAppearance.BorderSize = 0
        AddHandler btnExport.Click, AddressOf btnExport_Click
        pnlFilter.Controls.Add(btnExport)
        
        btnPrint = New Button With {
            .Text = "🖨️ Print",
            .Location = New Point(1080, 15),
            .Size = New Size(100, 30),
            .BackColor = ColorTranslator.FromHtml("#9B59B6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnPrint.FlatAppearance.BorderSize = 0
        AddHandler btnPrint.Click, AddressOf btnPrint_Click
        pnlFilter.Controls.Add(btnPrint)
        
        ' DataGridView
        dgvLedger = New DataGridView With {
            .Dock = DockStyle.Fill,
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
        
        dgvLedger.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#2C3E50")
        dgvLedger.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvLedger.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        dgvLedger.EnableHeadersVisualStyles = False
        dgvLedger.AlternatingRowsDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F8F9FA")
        dgvLedger.RowTemplate.Height = 35
        
        ' Footer Panel
        Dim pnlFooter As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1")
        }
        
        lblTotalDebits = New Label With {
            .Text = "Total Debits: R 0.00",
            .Location = New Point(20, 20),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#27AE60")
        }
        pnlFooter.Controls.Add(lblTotalDebits)
        
        lblTotalCredits = New Label With {
            .Text = "Total Credits: R 0.00",
            .Location = New Point(20, 45),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#E74C3C")
        }
        pnlFooter.Controls.Add(lblTotalCredits)
        
        btnClose = New Button With {
            .Text = "❌ Close",
            .Location = New Point(1250, 20),
            .Size = New Size(120, 40),
            .BackColor = ColorTranslator.FromHtml("#95A5A6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold)
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, Sub() Me.Close()
        pnlFooter.Controls.Add(btnClose)
        
        Me.Controls.Add(dgvLedger)
        Me.Controls.Add(pnlFilter)
        Me.Controls.Add(pnlHeader)
        Me.Controls.Add(pnlFooter)
    End Sub
    
    Private Sub LoadAccounts()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim sql = "SELECT AccountID, AccountCode + ' - ' + AccountName AS AccountDisplay 
                          FROM ChartOfAccounts 
                          ORDER BY AccountCode"
                
                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    
                    cboAccount.Items.Clear()
                    cboAccount.Items.Add(New With {.AccountID = 0, .AccountDisplay = "-- All Accounts --"})
                    
                    For Each row As DataRow In dt.Rows
                        cboAccount.Items.Add(New With {
                            .AccountID = CInt(row("AccountID")),
                            .AccountDisplay = row("AccountDisplay").ToString()
                        })
                    Next
                    
                    cboAccount.DisplayMember = "AccountDisplay"
                    cboAccount.ValueMember = "AccountID"
                    cboAccount.SelectedIndex = 0
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading accounts: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub LoadLedger()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim sql = "
                    SELECT 
                        CONVERT(VARCHAR, gl.TransactionDate, 106) AS [Date],
                        gl.JournalEntryNumber AS [Journal #],
                        coa.AccountCode AS [Code],
                        coa.AccountName AS [Account],
                        gl.Description,
                        CASE WHEN gl.DebitAmount > 0 THEN gl.DebitAmount ELSE NULL END AS [Debit],
                        CASE WHEN gl.CreditAmount > 0 THEN gl.CreditAmount ELSE NULL END AS [Credit],
                        gl.ReferenceType AS [Type],
                        gl.ReferenceID AS [Reference],
                        gl.CreatedBy AS [User]
                    FROM GeneralLedger gl
                    INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
                    WHERE gl.IsReversed = 0
                      AND gl.TransactionDate BETWEEN @FromDate AND @ToDate"
                
                Dim selectedAccount = DirectCast(cboAccount.SelectedItem, Object)
                Dim accountID = CInt(selectedAccount.AccountID)
                
                If accountID > 0 Then
                    sql &= " AND gl.AccountID = @AccountID"
                End If
                
                sql &= " ORDER BY gl.EntryID DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@FromDate", dtpFrom.Value.Date)
                    cmd.Parameters.AddWithValue("@ToDate", dtpTo.Value.Date.AddDays(1).AddSeconds(-1))
                    
                    If accountID > 0 Then
                        cmd.Parameters.AddWithValue("@AccountID", accountID)
                    End If
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvLedger.DataSource = dt
                        
                        If dgvLedger.Columns.Contains("Debit") Then
                            dgvLedger.Columns("Debit").DefaultCellStyle.Format = "N2"
                            dgvLedger.Columns("Debit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        End If
                        If dgvLedger.Columns.Contains("Credit") Then
                            dgvLedger.Columns("Credit").DefaultCellStyle.Format = "N2"
                            dgvLedger.Columns("Credit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        End If
                        
                        ' Calculate totals
                        Dim totalDebits = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("Debit")), 0D, CDec(r("Debit"))))
                        Dim totalCredits = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("Credit")), 0D, CDec(r("Credit"))))
                        
                        lblTotalDebits.Text = $"Total Debits: R {totalDebits:N2}"
                        lblTotalCredits.Text = $"Total Credits: R {totalCredits:N2}"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading ledger: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnFilter_Click(sender As Object, e As EventArgs)
        LoadLedger()
    End Sub
    
    Private Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click
        Try
            Dim printDoc As New Printing.PrintDocument()
            AddHandler printDoc.PrintPage, AddressOf PrintLedger
            
            Dim printDialog As New PrintDialog With {
                .Document = printDoc
            }
            
            If printDialog.ShowDialog() = DialogResult.OK Then
                printDoc.Print()
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub PrintLedger(sender As Object, e As Printing.PrintPageEventArgs)
        Dim font As New Font("Courier New", 8)
        Dim headerFont As New Font("Courier New", 10, FontStyle.Bold)
        Dim y As Single = 50
        Dim leftMargin As Single = 50
        
        ' Print header
        e.Graphics.DrawString("GENERAL LEDGER REPORT", headerFont, Brushes.Black, leftMargin, y)
        y += 30
        e.Graphics.DrawString($"Period: {dtpFrom.Value:dd/MM/yyyy} to {dtpTo.Value:dd/MM/yyyy}", font, Brushes.Black, leftMargin, y)
        y += 20
        e.Graphics.DrawString(New String("-"c, 100), font, Brushes.Black, leftMargin, y)
        y += 20
        
        ' Print column headers
        e.Graphics.DrawString("Date       Account                    Description                Debit        Credit", font, Brushes.Black, leftMargin, y)
        y += 15
        e.Graphics.DrawString(New String("-"c, 100), font, Brushes.Black, leftMargin, y)
        y += 20
        
        ' Print rows
        For Each row As DataGridViewRow In dgvLedger.Rows
            If y > e.PageBounds.Height - 100 Then Exit For
            
            Dim dateStr = If(row.Cells("Date").Value, "").ToString().PadRight(10)
            Dim accountStr = If(row.Cells("Account").Value, "").ToString().Substring(0, Math.Min(25, If(row.Cells("Account").Value, "").ToString().Length)).PadRight(25)
            Dim descStr = If(row.Cells("Description").Value, "").ToString().Substring(0, Math.Min(25, If(row.Cells("Description").Value, "").ToString().Length)).PadRight(25)
            Dim debitStr = If(IsDBNull(row.Cells("Debit").Value), "", $"R{CDec(row.Cells("Debit").Value):N2}").PadLeft(12)
            Dim creditStr = If(IsDBNull(row.Cells("Credit").Value), "", $"R{CDec(row.Cells("Credit").Value):N2}").PadLeft(12)
            
            e.Graphics.DrawString($"{dateStr} {accountStr} {descStr} {debitStr} {creditStr}", font, Brushes.Black, leftMargin, y)
            y += 15
        Next
        
        ' Print totals
        y += 10
        e.Graphics.DrawString(New String("-"c, 100), font, Brushes.Black, leftMargin, y)
        y += 20
        e.Graphics.DrawString(lblTotalDebits.Text, headerFont, Brushes.Black, leftMargin, y)
        y += 20
        e.Graphics.DrawString(lblTotalCredits.Text, headerFont, Brushes.Black, leftMargin, y)
        
        e.HasMorePages = False
    End Sub
    
    Private Sub btnExport_Click(sender As Object, e As EventArgs)
        MessageBox.Show("Export functionality coming soon!", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub
End Class
