Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing.Printing

Public Class LedgerViewerForm
    Private _connectionString As String
    Private _ledgerType As String ' "Supplier", "Customer", "Expense", etc.
    Private _entityId As Integer
    Private _entityName As String
    Private _printDocument As PrintDocument
    Private _printDataTable As DataTable
    
    Public Sub New(ledgerType As String, entityId As Integer, entityName As String)
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        _ledgerType = ledgerType
        _entityId = entityId
        _entityName = entityName
    End Sub
    
    Protected Overrides Sub OnLoad(e As EventArgs)
        MyBase.OnLoad(e)
        Me.Text = $"{_ledgerType} Ledger - {_entityName}"
        Me.Size = New Size(1200, 800)
        Me.StartPosition = FormStartPosition.CenterParent
        
        InitializeUI()
        LoadLedgerData()
    End Sub
    
    Private Sub InitializeComponent()
        Me.SuspendLayout()
        Me.Name = "LedgerViewerForm"
        Me.ResumeLayout(False)
    End Sub
    
    Private Sub InitializeUI()
        ' Header Panel
        Dim pnlHeader As New Panel() With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .BackColor = Color.FromArgb(52, 73, 94),
            .Padding = New Padding(20)
        }
        
        ' Company Name
        Dim lblCompany As New Label() With {
            .Text = "OVEN DELIGHTS",
            .Font = New Font("Segoe UI", 20, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 10)
        }
        
        ' Ledger Title
        Dim lblTitle As New Label() With {
            .Text = $"{_ledgerType} Ledger Statement",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 45)
        }
        
        ' Entity Name
        Dim lblEntity As New Label() With {
            .Text = $"Account: {_entityName}",
            .Font = New Font("Segoe UI", 12),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 75)
        }
        
        pnlHeader.Controls.AddRange({lblCompany, lblTitle, lblEntity})
        
        ' Filter Panel
        Dim pnlFilter As New Panel() With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = Color.FromArgb(236, 240, 241),
            .Padding = New Padding(20, 10, 20, 10)
        }
        
        Dim lblFromDate As New Label() With {
            .Text = "From Date:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .AutoSize = True,
            .Location = New Point(20, 25)
        }
        
        Dim dtpFromDate As New DateTimePicker() With {
            .Name = "dtpFromDate",
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Today.AddMonths(-1),
            .Location = New Point(110, 22),
            .Width = 150,
            .Font = New Font("Segoe UI", 10)
        }
        
        Dim lblToDate As New Label() With {
            .Text = "To Date:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .AutoSize = True,
            .Location = New Point(280, 25)
        }
        
        Dim dtpToDate As New DateTimePicker() With {
            .Name = "dtpToDate",
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Today,
            .Location = New Point(350, 22),
            .Width = 150,
            .Font = New Font("Segoe UI", 10)
        }
        
        Dim btnRefresh As New Button() With {
            .Text = "🔄 Refresh",
            .Location = New Point(520, 20),
            .Width = 120,
            .Height = 35,
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click
        
        Dim btnPrint As New Button() With {
            .Text = "🖨 Print",
            .Location = New Point(650, 20),
            .Width = 120,
            .Height = 35,
            .BackColor = Color.FromArgb(39, 174, 96),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnPrint.Click, AddressOf BtnPrint_Click
        
        Dim btnExport As New Button() With {
            .Text = "📊 Export",
            .Location = New Point(780, 20),
            .Width = 120,
            .Height = 35,
            .BackColor = Color.FromArgb(155, 89, 182),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnExport.Click, AddressOf BtnExport_Click
        
        Dim btnClose As New Button() With {
            .Text = "✕ Close",
            .Location = New Point(910, 20),
            .Width = 120,
            .Height = 35,
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnClose.Click, Sub(s, ev) Me.Close()
        
        pnlFilter.Controls.AddRange({lblFromDate, dtpFromDate, lblToDate, dtpToDate, btnRefresh, btnPrint, btnExport, btnClose})
        
        ' DataGridView
        Dim dgvLedger As New DataGridView() With {
            .Name = "dgvLedger",
            .Dock = DockStyle.Fill,
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 9)
        }
        
        ' Alternating row colors
        dgvLedger.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 245, 245)
        dgvLedger.DefaultCellStyle.SelectionBackColor = Color.FromArgb(52, 152, 219)
        dgvLedger.DefaultCellStyle.SelectionForeColor = Color.White
        
        ' Summary Panel
        Dim pnlSummary As New Panel() With {
            .Name = "pnlSummary",
            .Dock = DockStyle.Bottom,
            .Height = 100,
            .BackColor = Color.FromArgb(236, 240, 241),
            .Padding = New Padding(20)
        }
        
        Dim lblOpeningBalance As New Label() With {
            .Name = "lblOpeningBalance",
            .Text = "Opening Balance: R 0.00",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .AutoSize = True,
            .Location = New Point(20, 15)
        }
        
        Dim lblTotalDebit As New Label() With {
            .Name = "lblTotalDebit",
            .Text = "Total Debit: R 0.00",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .AutoSize = True,
            .Location = New Point(20, 40)
        }
        
        Dim lblTotalCredit As New Label() With {
            .Name = "lblTotalCredit",
            .Text = "Total Credit: R 0.00",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .AutoSize = True,
            .Location = New Point(250, 40)
        }
        
        Dim lblClosingBalance As New Label() With {
            .Name = "lblClosingBalance",
            .Text = "Closing Balance: R 0.00",
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = Color.FromArgb(39, 174, 96),
            .AutoSize = True,
            .Location = New Point(20, 65)
        }
        
        pnlSummary.Controls.AddRange({lblOpeningBalance, lblTotalDebit, lblTotalCredit, lblClosingBalance})
        
        Me.Controls.AddRange({dgvLedger, pnlSummary, pnlFilter, pnlHeader})
    End Sub
    
    Private Sub LoadLedgerData()
        Try
            Dim dtpFromDate = CType(Me.Controls.Find("dtpFromDate", True)(0), DateTimePicker)
            Dim dtpToDate = CType(Me.Controls.Find("dtpToDate", True)(0), DateTimePicker)
            Dim dgvLedger = CType(Me.Controls.Find("dgvLedger", True)(0), DataGridView)
            
            Dim dt As New DataTable()
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim sql As String = GetLedgerQuery()
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@EntityID", _entityId)
                    cmd.Parameters.AddWithValue("@FromDate", dtpFromDate.Value.Date)
                    cmd.Parameters.AddWithValue("@ToDate", dtpToDate.Value.Date.AddDays(1).AddSeconds(-1))
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using
            
            dgvLedger.DataSource = dt
            
            ' Format columns
            If dt.Rows.Count > 0 Then
                FormatGridColumns(dgvLedger)
                UpdateSummary(dt, dtpFromDate.Value)
            End If
            
            _printDataTable = dt
            
        Catch ex As Exception
            MessageBox.Show($"Error loading ledger data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Function GetLedgerQuery() As String
        Select Case _ledgerType.ToLower()
            Case "supplier"
                Return "SELECT TransactionDate AS [Date], TransactionType AS [Type], Reference, Description, " &
                       "Debit, Credit, Balance " &
                       "FROM SupplierLedger " &
                       "WHERE SupplierID = @EntityID AND TransactionDate BETWEEN @FromDate AND @ToDate " &
                       "ORDER BY TransactionDate, LedgerID"
            
            Case "customer"
                Return "SELECT TransactionDate AS [Date], TransactionType AS [Type], Reference, Description, " &
                       "Debit, Credit, Balance " &
                       "FROM CustomerLedger " &
                       "WHERE CustomerID = @EntityID AND TransactionDate BETWEEN @FromDate AND @ToDate " &
                       "ORDER BY TransactionDate, LedgerID"
            
            Case "expense"
                Return "SELECT TransactionDate AS [Date], TransactionType AS [Type], Reference, Description, " &
                       "Amount AS Debit, 0 AS Credit, Amount AS Balance " &
                       "FROM Expenses " &
                       "WHERE ExpenseID = @EntityID AND TransactionDate BETWEEN @FromDate AND @ToDate " &
                       "ORDER BY TransactionDate"
            
            Case Else
                ' Generic ledger query
                Return "SELECT TransactionDate AS [Date], TransactionType AS [Type], Reference, Description, " &
                       "Debit, Credit, Balance " &
                       "FROM GeneralLedger " &
                       "WHERE EntityID = @EntityID AND TransactionDate BETWEEN @FromDate AND @ToDate " &
                       "ORDER BY TransactionDate"
        End Select
    End Function
    
    Private Sub FormatGridColumns(dgv As DataGridView)
        ' Date column
        If dgv.Columns.Contains("Date") Then
            dgv.Columns("Date").DefaultCellStyle.Format = "dd/MM/yyyy"
            dgv.Columns("Date").Width = 100
        End If
        
        ' Type column
        If dgv.Columns.Contains("Type") Then
            dgv.Columns("Type").Width = 100
        End If
        
        ' Reference column
        If dgv.Columns.Contains("Reference") Then
            dgv.Columns("Reference").Width = 120
        End If
        
        ' Description column
        If dgv.Columns.Contains("Description") Then
            dgv.Columns("Description").AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
        End If
        
        ' Debit column
        If dgv.Columns.Contains("Debit") Then
            dgv.Columns("Debit").DefaultCellStyle.Format = "N2"
            dgv.Columns("Debit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            dgv.Columns("Debit").Width = 120
        End If
        
        ' Credit column
        If dgv.Columns.Contains("Credit") Then
            dgv.Columns("Credit").DefaultCellStyle.Format = "N2"
            dgv.Columns("Credit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            dgv.Columns("Credit").Width = 120
        End If
        
        ' Balance column
        If dgv.Columns.Contains("Balance") Then
            dgv.Columns("Balance").DefaultCellStyle.Format = "N2"
            dgv.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            dgv.Columns("Balance").DefaultCellStyle.Font = New Font("Segoe UI", 9, FontStyle.Bold)
            dgv.Columns("Balance").Width = 120
        End If
    End Sub
    
    Private Sub UpdateSummary(dt As DataTable, fromDate As DateTime)
        Try
            Dim lblOpeningBalance = CType(Me.Controls.Find("lblOpeningBalance", True)(0), Label)
            Dim lblTotalDebit = CType(Me.Controls.Find("lblTotalDebit", True)(0), Label)
            Dim lblTotalCredit = CType(Me.Controls.Find("lblTotalCredit", True)(0), Label)
            Dim lblClosingBalance = CType(Me.Controls.Find("lblClosingBalance", True)(0), Label)
            
            ' Calculate opening balance (balance before from date)
            Dim openingBalance As Decimal = GetOpeningBalance(fromDate)
            
            ' Calculate totals
            Dim totalDebit As Decimal = 0
            Dim totalCredit As Decimal = 0
            Dim closingBalance As Decimal = 0
            
            For Each row As DataRow In dt.Rows
                If Not IsDBNull(row("Debit")) Then totalDebit += Convert.ToDecimal(row("Debit"))
                If Not IsDBNull(row("Credit")) Then totalCredit += Convert.ToDecimal(row("Credit"))
            Next
            
            If dt.Rows.Count > 0 Then
                closingBalance = Convert.ToDecimal(dt.Rows(dt.Rows.Count - 1)("Balance"))
            Else
                closingBalance = openingBalance
            End If
            
            ' Update labels
            lblOpeningBalance.Text = $"Opening Balance: R {openingBalance:N2}"
            lblTotalDebit.Text = $"Total Debit: R {totalDebit:N2}"
            lblTotalCredit.Text = $"Total Credit: R {totalCredit:N2}"
            lblClosingBalance.Text = $"Closing Balance: R {closingBalance:N2}"
            
            ' Color code closing balance
            If closingBalance < 0 Then
                lblClosingBalance.ForeColor = Color.FromArgb(231, 76, 60) ' Red
            Else
                lblClosingBalance.ForeColor = Color.FromArgb(39, 174, 96) ' Green
            End If
            
        Catch ex As Exception
            ' Ignore summary calculation errors
        End Try
    End Sub
    
    Private Function GetOpeningBalance(fromDate As DateTime) As Decimal
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim sql As String = ""
                Select Case _ledgerType.ToLower()
                    Case "supplier"
                        sql = "SELECT ISNULL(Balance, 0) FROM SupplierLedger WHERE SupplierID = @EntityID AND TransactionDate < @FromDate ORDER BY TransactionDate DESC, LedgerID DESC"
                    Case "customer"
                        sql = "SELECT ISNULL(Balance, 0) FROM CustomerLedger WHERE CustomerID = @EntityID AND TransactionDate < @FromDate ORDER BY TransactionDate DESC, LedgerID DESC"
                    Case Else
                        Return 0
                End Select
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@EntityID", _entityId)
                    cmd.Parameters.AddWithValue("@FromDate", fromDate.Date)
                    
                    Dim result = cmd.ExecuteScalar()
                    If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                        Return Convert.ToDecimal(result)
                    End If
                End Using
            End Using
        Catch
            ' Return 0 if error
        End Try
        
        Return 0
    End Function
    
    Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
        LoadLedgerData()
    End Sub
    
    Private Sub BtnPrint_Click(sender As Object, e As EventArgs)
        Try
            If _printDataTable Is Nothing OrElse _printDataTable.Rows.Count = 0 Then
                MessageBox.Show("No data to print.", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            _printDocument = New PrintDocument()
            AddHandler _printDocument.PrintPage, AddressOf PrintDocument_PrintPage
            
            Dim printDialog As New PrintDialog()
            printDialog.Document = _printDocument
            
            If printDialog.ShowDialog() = DialogResult.OK Then
                _printDocument.Print()
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub PrintDocument_PrintPage(sender As Object, e As PrintPageEventArgs)
        Dim font As New Font("Arial", 10)
        Dim boldFont As New Font("Arial", 10, FontStyle.Bold)
        Dim titleFont As New Font("Arial", 14, FontStyle.Bold)
        Dim y As Integer = 50
        Dim leftMargin As Integer = 50
        
        ' Print header
        e.Graphics.DrawString("OVEN DELIGHTS", titleFont, Brushes.Black, leftMargin, y)
        y += 30
        e.Graphics.DrawString($"{_ledgerType} Ledger Statement", boldFont, Brushes.Black, leftMargin, y)
        y += 25
        e.Graphics.DrawString($"Account: {_entityName}", font, Brushes.Black, leftMargin, y)
        y += 20
        
        Dim dtpFromDate = CType(Me.Controls.Find("dtpFromDate", True)(0), DateTimePicker)
        Dim dtpToDate = CType(Me.Controls.Find("dtpToDate", True)(0), DateTimePicker)
        e.Graphics.DrawString($"Period: {dtpFromDate.Value:dd/MM/yyyy} to {dtpToDate.Value:dd/MM/yyyy}", font, Brushes.Black, leftMargin, y)
        y += 30
        
        ' Print table header
        e.Graphics.DrawString("Date", boldFont, Brushes.Black, leftMargin, y)
        e.Graphics.DrawString("Type", boldFont, Brushes.Black, leftMargin + 100, y)
        e.Graphics.DrawString("Reference", boldFont, Brushes.Black, leftMargin + 200, y)
        e.Graphics.DrawString("Description", boldFont, Brushes.Black, leftMargin + 320, y)
        e.Graphics.DrawString("Debit", boldFont, Brushes.Black, leftMargin + 500, y)
        e.Graphics.DrawString("Credit", boldFont, Brushes.Black, leftMargin + 580, y)
        e.Graphics.DrawString("Balance", boldFont, Brushes.Black, leftMargin + 660, y)
        y += 25
        
        ' Print line
        e.Graphics.DrawLine(Pens.Black, leftMargin, y, leftMargin + 700, y)
        y += 10
        
        ' Print data
        For Each row As DataRow In _printDataTable.Rows
            If y > e.PageBounds.Height - 100 Then Exit For ' Page break
            
            e.Graphics.DrawString(Convert.ToDateTime(row("Date")).ToString("dd/MM/yyyy"), font, Brushes.Black, leftMargin, y)
            e.Graphics.DrawString(row("Type").ToString(), font, Brushes.Black, leftMargin + 100, y)
            e.Graphics.DrawString(row("Reference").ToString(), font, Brushes.Black, leftMargin + 200, y)
            e.Graphics.DrawString(row("Description").ToString(), font, Brushes.Black, leftMargin + 320, y)
            e.Graphics.DrawString($"R {Convert.ToDecimal(row("Debit")):N2}", font, Brushes.Black, leftMargin + 500, y)
            e.Graphics.DrawString($"R {Convert.ToDecimal(row("Credit")):N2}", font, Brushes.Black, leftMargin + 580, y)
            e.Graphics.DrawString($"R {Convert.ToDecimal(row("Balance")):N2}", boldFont, Brushes.Black, leftMargin + 660, y)
            y += 20
        Next
        
        ' Print footer
        y += 20
        e.Graphics.DrawLine(Pens.Black, leftMargin, y, leftMargin + 700, y)
        y += 15
        
        Dim lblClosingBalance = CType(Me.Controls.Find("lblClosingBalance", True)(0), Label)
        e.Graphics.DrawString(lblClosingBalance.Text, boldFont, Brushes.Black, leftMargin + 500, y)
    End Sub
    
    Private Sub BtnExport_Click(sender As Object, e As EventArgs)
        Try
            If _printDataTable Is Nothing OrElse _printDataTable.Rows.Count = 0 Then
                MessageBox.Show("No data to export.", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            Dim sfd As New SaveFileDialog()
            sfd.Filter = "CSV Files|*.csv"
            sfd.FileName = $"{_ledgerType}_Ledger_{_entityName}_{DateTime.Now:yyyyMMdd}.csv"
            
            If sfd.ShowDialog() = DialogResult.OK Then
                ExportToCSV(sfd.FileName)
                MessageBox.Show("Ledger exported successfully!", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error exporting: {ex.Message}", "Export Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub ExportToCSV(filePath As String)
        Using writer As New IO.StreamWriter(filePath)
            ' Write header
            Dim headers As New List(Of String)
            For Each col As DataColumn In _printDataTable.Columns
                headers.Add(col.ColumnName)
            Next
            writer.WriteLine(String.Join(",", headers))
            
            ' Write data
            For Each row As DataRow In _printDataTable.Rows
                Dim values As New List(Of String)
                For Each item In row.ItemArray
                    values.Add($"""{item}""")
                Next
                writer.WriteLine(String.Join(",", values))
            Next
        End Using
    End Sub
End Class
