Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

''' <summary>
''' Supplier Ledger Detail - displays detailed transaction history for a specific supplier
''' </summary>
Public Class SupplierLedgerDetail
    Inherits Form
    
    Private ReadOnly _connString As String
    Private ReadOnly _supplierCode As String
    Private ReadOnly _supplierName As String
    
    Private dgvTransactions As DataGridView
    Private lblSupplierInfo As Label
    Private lblCurrentBalance As Label
    Private btnPrint As Button
    Private btnClose As Button
    
    Public Sub New(supplierCode As String, supplierName As String)
        _supplierCode = supplierCode
        _supplierName = supplierName
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        InitializeComponent()
        LoadTransactions()
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = $"Supplier Ledger - {_supplierName}"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.White
        
        ' Header
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .BackColor = ColorTranslator.FromHtml("#C0392B")
        }
        
        Dim lblTitle As New Label With {
            .Text = "📋 SUPPLIER LEDGER DETAIL",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = Color.White,
            .Location = New Point(20, 15),
            .AutoSize = True
        }
        pnlHeader.Controls.Add(lblTitle)
        
        lblSupplierInfo = New Label With {
            .Text = $"Supplier: {_supplierName} | Code: {_supplierCode}",
            .Font = New Font("Segoe UI", 12),
            .ForeColor = ColorTranslator.FromHtml("#ECF0F1"),
            .Location = New Point(20, 50),
            .AutoSize = True
        }
        pnlHeader.Controls.Add(lblSupplierInfo)
        
        lblCurrentBalance = New Label With {
            .Text = "Current Balance: R 0.00",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = Color.White,
            .Location = New Point(20, 80),
            .AutoSize = True
        }
        pnlHeader.Controls.Add(lblCurrentBalance)
        
        ' DataGridView
        dgvTransactions = New DataGridView With {
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
        
        dgvTransactions.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#C0392B")
        dgvTransactions.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvTransactions.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        dgvTransactions.EnableHeadersVisualStyles = False
        dgvTransactions.AlternatingRowsDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F8F9FA")
        dgvTransactions.RowTemplate.Height = 35
        
        ' Footer Panel
        Dim pnlFooter As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 70,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1")
        }
        
        btnPrint = New Button With {
            .Text = "🖨️ Print Statement",
            .Location = New Point(20, 15),
            .Size = New Size(180, 40),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold)
        }
        btnPrint.FlatAppearance.BorderSize = 0
        AddHandler btnPrint.Click, AddressOf btnPrint_Click
        pnlFooter.Controls.Add(btnPrint)
        
        btnClose = New Button With {
            .Text = "❌ Close",
            .Location = New Point(1050, 15),
            .Size = New Size(120, 40),
            .BackColor = ColorTranslator.FromHtml("#95A5A6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold)
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, Sub() Me.Close()
        pnlFooter.Controls.Add(btnClose)
        
        Me.Controls.Add(dgvTransactions)
        Me.Controls.Add(pnlHeader)
        Me.Controls.Add(pnlFooter)
    End Sub
    
    Private Sub LoadTransactions()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim sql = "
                    SELECT 
                        CONVERT(VARCHAR, TransactionDate, 106) AS [Date],
                        TransactionType AS [Type],
                        ReferenceNumber AS [Reference],
                        Description,
                        CASE WHEN DebitAmount > 0 THEN DebitAmount ELSE NULL END AS [Debit],
                        CASE WHEN CreditAmount > 0 THEN CreditAmount ELSE NULL END AS [Credit],
                        RunningBalance AS [Balance],
                        CreatedBy AS [User]
                    FROM SupplierLedger
                    WHERE SupplierCode = @SupplierCode
                    ORDER BY LedgerID ASC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@SupplierCode", _supplierCode)
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvTransactions.DataSource = dt
                        
                        If dgvTransactions.Columns.Contains("Debit") Then
                            dgvTransactions.Columns("Debit").DefaultCellStyle.Format = "N2"
                            dgvTransactions.Columns("Debit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                            dgvTransactions.Columns("Debit").DefaultCellStyle.ForeColor = Color.FromArgb(231, 76, 60)
                        End If
                        
                        If dgvTransactions.Columns.Contains("Credit") Then
                            dgvTransactions.Columns("Credit").DefaultCellStyle.Format = "N2"
                            dgvTransactions.Columns("Credit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                            dgvTransactions.Columns("Credit").DefaultCellStyle.ForeColor = Color.FromArgb(39, 174, 96)
                        End If
                        
                        If dgvTransactions.Columns.Contains("Balance") Then
                            dgvTransactions.Columns("Balance").DefaultCellStyle.Format = "N2"
                            dgvTransactions.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                            dgvTransactions.Columns("Balance").DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                        End If
                        
                        ' Color code running balance
                        For Each row As DataGridViewRow In dgvTransactions.Rows
                            If row.Cells("Balance").Value IsNot Nothing Then
                                Dim balance = CDec(row.Cells("Balance").Value)
                                If balance > 0 Then
                                    row.Cells("Balance").Style.ForeColor = Color.FromArgb(231, 76, 60)
                                ElseIf balance < 0 Then
                                    row.Cells("Balance").Style.ForeColor = Color.FromArgb(39, 174, 96)
                                Else
                                    row.Cells("Balance").Style.ForeColor = Color.FromArgb(127, 140, 141)
                                End If
                            End If
                        Next
                        
                        ' Get current balance
                        If dt.Rows.Count > 0 Then
                            Dim currentBalance = CDec(dt.Rows(dt.Rows.Count - 1)("Balance"))
                            lblCurrentBalance.Text = $"Current Balance: R {currentBalance:N2}"
                            
                            If currentBalance > 0 Then
                                lblCurrentBalance.ForeColor = Color.FromArgb(231, 76, 60)
                                lblCurrentBalance.Text &= " (We Owe Supplier)"
                            ElseIf currentBalance < 0 Then
                                lblCurrentBalance.ForeColor = Color.FromArgb(39, 174, 96)
                                lblCurrentBalance.Text &= " (Supplier Owes Us - Prepaid)"
                            Else
                                lblCurrentBalance.ForeColor = Color.FromArgb(127, 140, 141)
                                lblCurrentBalance.Text &= " (Settled)"
                            End If
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading transactions: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnPrint_Click(sender As Object, e As EventArgs)
        MessageBox.Show("Print statement functionality coming soon!", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub
End Class
