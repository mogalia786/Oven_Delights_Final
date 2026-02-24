Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

''' <summary>
''' Supplier Ledger Viewer - displays all supplier account balances (Accounts Payable)
''' </summary>
Public Class SupplierLedgerViewer
    Inherits Form
    
    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchID As Integer
    
    Private dgvSuppliers As DataGridView
    Private txtSearch As TextBox
    Private btnSearch As Button
    Private btnClose As Button
    Private lblTotalPayables As Label
    Private lblTotalPrepaid As Label
    
    Public Sub New(branchID As Integer)
        _currentBranchID = branchID
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        InitializeComponent()
        LoadSuppliers()
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "Supplier Ledger Viewer - Accounts Payable"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.White
        
        ' Header
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#C0392B")
        }
        
        Dim lblTitle As New Label With {
            .Text = "📦 SUPPLIER LEDGERS (ACCOUNTS PAYABLE)",
            .Font = New Font("Segoe UI", 20, FontStyle.Bold),
            .ForeColor = Color.White,
            .Location = New Point(20, 20),
            .AutoSize = True
        }
        pnlHeader.Controls.Add(lblTitle)
        
        ' Search Panel
        Dim pnlSearch As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 70,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1"),
            .Padding = New Padding(20, 15, 20, 15)
        }
        
        Dim lblSearch As New Label With {
            .Text = "Search:",
            .Location = New Point(20, 22),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        pnlSearch.Controls.Add(lblSearch)
        
        txtSearch = New TextBox With {
            .Location = New Point(90, 20),
            .Size = New Size(300, 25),
            .Font = New Font("Segoe UI", 11)
        }
        AddHandler txtSearch.KeyPress, Sub(s, e)
            If e.KeyChar = ChrW(Keys.Enter) Then
                e.Handled = True
                LoadSuppliers()
            End If
        End Sub
        pnlSearch.Controls.Add(txtSearch)
        
        btnSearch = New Button With {
            .Text = "🔍 Search",
            .Location = New Point(410, 18),
            .Size = New Size(100, 30),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnSearch.FlatAppearance.BorderSize = 0
        AddHandler btnSearch.Click, AddressOf btnSearch_Click
        pnlSearch.Controls.Add(btnSearch)
        
        Dim lblHint As New Label With {
            .Text = "💡 Double-click a supplier to view detailed transactions",
            .Location = New Point(530, 22),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 9, FontStyle.Italic),
            .ForeColor = ColorTranslator.FromHtml("#7F8C8D")
        }
        pnlSearch.Controls.Add(lblHint)
        
        ' DataGridView
        dgvSuppliers = New DataGridView With {
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
        
        dgvSuppliers.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#C0392B")
        dgvSuppliers.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvSuppliers.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        dgvSuppliers.EnableHeadersVisualStyles = False
        dgvSuppliers.AlternatingRowsDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F8F9FA")
        dgvSuppliers.RowTemplate.Height = 35
        
        AddHandler dgvSuppliers.CellDoubleClick, AddressOf dgvSuppliers_CellDoubleClick
        
        ' Footer Panel
        Dim pnlFooter As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1")
        }
        
        lblTotalPayables = New Label With {
            .Text = "Total Payables (We Owe): R 0.00",
            .Location = New Point(20, 20),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#E74C3C")
        }
        pnlFooter.Controls.Add(lblTotalPayables)
        
        lblTotalPrepaid = New Label With {
            .Text = "Total Prepaid (They Owe Us): R 0.00",
            .Location = New Point(20, 45),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#27AE60")
        }
        pnlFooter.Controls.Add(lblTotalPrepaid)
        
        btnClose = New Button With {
            .Text = "❌ Close",
            .Location = New Point(1050, 20),
            .Size = New Size(120, 40),
            .BackColor = ColorTranslator.FromHtml("#95A5A6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold)
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, Sub() Me.Close()
        pnlFooter.Controls.Add(btnClose)
        
        Me.Controls.Add(dgvSuppliers)
        Me.Controls.Add(pnlSearch)
        Me.Controls.Add(pnlHeader)
        Me.Controls.Add(pnlFooter)
    End Sub
    
    Private Sub LoadSuppliers()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim sql = "
                    SELECT 
                        SupplierCode AS [Supplier Code],
                        SupplierName AS [Supplier Name],
                        RunningBalance AS [Balance],
                        CASE 
                            WHEN RunningBalance > 0 THEN 'We Owe'
                            WHEN RunningBalance < 0 THEN 'Prepaid'
                            ELSE 'Settled'
                        END AS [Status],
                        CONVERT(VARCHAR, MAX(TransactionDate), 106) AS [Last Activity],
                        COUNT(*) AS [Transactions]
                    FROM (
                        SELECT 
                            SupplierID,
                            SupplierCode,
                            SupplierName,
                            RunningBalance,
                            TransactionDate,
                            ROW_NUMBER() OVER (PARTITION BY SupplierID, SupplierCode ORDER BY LedgerID DESC) AS rn
                        FROM SupplierLedger
                        WHERE (@Search = '' OR SupplierCode LIKE @Search OR SupplierName LIKE @Search)
                    ) AS Latest
                    WHERE rn = 1
                    GROUP BY SupplierID, SupplierCode, SupplierName, RunningBalance
                    ORDER BY ABS(RunningBalance) DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    Dim searchTerm = If(String.IsNullOrWhiteSpace(txtSearch.Text), "", $"%{txtSearch.Text.Trim()}%")
                    cmd.Parameters.AddWithValue("@Search", searchTerm)
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvSuppliers.DataSource = dt
                        
                        If dgvSuppliers.Columns.Contains("Balance") Then
                            dgvSuppliers.Columns("Balance").DefaultCellStyle.Format = "N2"
                            dgvSuppliers.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        End If
                        
                        ' Color code balances
                        For Each row As DataGridViewRow In dgvSuppliers.Rows
                            If row.Cells("Balance").Value IsNot Nothing Then
                                Dim balance = CDec(row.Cells("Balance").Value)
                                If balance > 0 Then
                                    row.Cells("Balance").Style.ForeColor = Color.FromArgb(231, 76, 60)
                                    row.Cells("Balance").Style.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                                ElseIf balance < 0 Then
                                    row.Cells("Balance").Style.ForeColor = Color.FromArgb(39, 174, 96)
                                    row.Cells("Balance").Style.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                                End If
                            End If
                        Next
                        
                        ' Calculate totals
                        Dim totalPayables = dt.AsEnumerable().Where(Function(r) CDec(r("Balance")) > 0).Sum(Function(r) CDec(r("Balance")))
                        Dim totalPrepaid = Math.Abs(dt.AsEnumerable().Where(Function(r) CDec(r("Balance")) < 0).Sum(Function(r) CDec(r("Balance"))))
                        
                        lblTotalPayables.Text = $"Total Payables (We Owe): R {totalPayables:N2}"
                        lblTotalPrepaid.Text = $"Total Prepaid (They Owe Us): R {totalPrepaid:N2}"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnSearch_Click(sender As Object, e As EventArgs)
        LoadSuppliers()
    End Sub
    
    Private Sub dgvSuppliers_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex >= 0 Then
            Try
                Dim supplierCode = dgvSuppliers.Rows(e.RowIndex).Cells("Supplier Code").Value.ToString()
                Dim supplierName = dgvSuppliers.Rows(e.RowIndex).Cells("Supplier Name").Value.ToString()
                
                Dim detailForm As New SupplierLedgerDetail(supplierCode, supplierName)
                detailForm.ShowDialog()
                
                ' Refresh after closing detail
                LoadSuppliers()
            Catch ex As Exception
                MessageBox.Show($"Error opening supplier detail: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub
End Class
