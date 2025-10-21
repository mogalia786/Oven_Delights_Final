Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms
Imports System.Drawing

Public Class IncomeStatementForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly dgvIncomeStatement As New DataGridView()
    Private ReadOnly dtpFromDate As New DateTimePicker()
    Private ReadOnly dtpToDate As New DateTimePicker()
    Private ReadOnly btnGenerate As New Button()
    Private ReadOnly btnExport As New Button()
    Private ReadOnly btnClose As New Button()
    Private ReadOnly lblTotalRevenue As New Label()
    Private ReadOnly lblTotalExpenses As New Label()
    Private ReadOnly lblNetIncome As New Label()

    Public Sub New()
        InitializeFormProperties()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        SetupUI()
        LoadIncomeStatement()
    End Sub

    Private Sub InitializeFormProperties()
        Me.Text = "Income Statement Report"
        Me.Size = New Size(1000, 700)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.Sizable
        Me.WindowState = FormWindowState.Maximized
    End Sub

    Private Sub SetupUI()
        ' Date range controls
        Dim lblFromDate As New Label()
        lblFromDate.Text = "From Date:"
        lblFromDate.Location = New Point(20, 20)
        lblFromDate.AutoSize = True

        dtpFromDate.Location = New Point(100, 18)
        dtpFromDate.Size = New Size(150, 20)
        dtpFromDate.Value = New DateTime(DateTime.Now.Year, 1, 1) ' Start of current year

        Dim lblToDate As New Label()
        lblToDate.Text = "To Date:"
        lblToDate.Location = New Point(270, 20)
        lblToDate.AutoSize = True

        dtpToDate.Location = New Point(330, 18)
        dtpToDate.Size = New Size(150, 20)
        dtpToDate.Value = DateTime.Now

        ' Generate button
        btnGenerate.Text = "Generate Report"
        btnGenerate.Location = New Point(500, 18)
        btnGenerate.Size = New Size(120, 25)
        AddHandler btnGenerate.Click, AddressOf OnGenerateReport

        ' Export button
        btnExport.Text = "Export to CSV"
        btnExport.Location = New Point(630, 18)
        btnExport.Size = New Size(100, 25)
        AddHandler btnExport.Click, AddressOf OnExportReport

        ' DataGridView for income statement
        dgvIncomeStatement.Location = New Point(20, 60)
        dgvIncomeStatement.Size = New Size(950, 450)
        dgvIncomeStatement.ReadOnly = True
        dgvIncomeStatement.AllowUserToAddRows = False
        dgvIncomeStatement.AllowUserToDeleteRows = False
        dgvIncomeStatement.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvIncomeStatement.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill

        ' Summary labels
        lblTotalRevenue.Text = "Total Revenue: R 0.00"
        lblTotalRevenue.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        lblTotalRevenue.ForeColor = Color.Green
        lblTotalRevenue.Location = New Point(20, 530)
        lblTotalRevenue.AutoSize = True

        lblTotalExpenses.Text = "Total Expenses: R 0.00"
        lblTotalExpenses.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        lblTotalExpenses.ForeColor = Color.Red
        lblTotalExpenses.Location = New Point(20, 555)
        lblTotalExpenses.AutoSize = True

        lblNetIncome.Text = "Net Income: R 0.00"
        lblNetIncome.Font = New Font("Segoe UI", 12, FontStyle.Bold)
        lblNetIncome.Location = New Point(20, 585)
        lblNetIncome.AutoSize = True

        ' Close button
        btnClose.Text = "Close"
        btnClose.Location = New Point(895, 585)
        btnClose.Size = New Size(75, 30)
        AddHandler btnClose.Click, Sub() Me.Close()

        ' Add controls to form
        Me.Controls.AddRange({lblFromDate, dtpFromDate, lblToDate, dtpToDate, btnGenerate, btnExport,
                             dgvIncomeStatement, lblTotalRevenue, lblTotalExpenses, lblNetIncome, btnClose})
    End Sub

    Private Sub LoadIncomeStatement()
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return

            Using conn As New SqlConnection(_connString)
                ' Create comprehensive income statement query
                Dim sql = "
                WITH RevenueData AS (
                    SELECT 
                        'REVENUE' as Category,
                        'Sales Revenue' as AccountName,
                        ISNULL(SUM(s.TotalAmount), 0) as Amount
                    FROM Sales s
                    WHERE s.SaleDate BETWEEN @fromDate AND @toDate
                    AND s.IsActive = 1
                    
                    UNION ALL
                    
                    SELECT 
                        'REVENUE' as Category,
                        'Service Revenue' as AccountName,
                        ISNULL(SUM(sr.Amount), 0) as Amount
                    FROM ServiceRevenue sr
                    WHERE sr.ServiceDate BETWEEN @fromDate AND @toDate
                    AND sr.IsActive = 1
                ),
                ExpenseData AS (
                    SELECT 
                        'EXPENSES' as Category,
                        'Cost of Goods Sold' as AccountName,
                        ISNULL(SUM(cogs.Amount), 0) as Amount
                    FROM CostOfGoodsSold cogs
                    WHERE cogs.TransactionDate BETWEEN @fromDate AND @toDate
                    
                    UNION ALL
                    
                    SELECT 
                        'EXPENSES' as Category,
                        'Operating Expenses' as AccountName,
                        ISNULL(SUM(e.Amount), 0) as Amount
                    FROM Expenses e
                    WHERE e.ExpenseDate BETWEEN @fromDate AND @toDate
                    AND e.IsActive = 1
                    
                    UNION ALL
                    
                    SELECT 
                        'EXPENSES' as Category,
                        'Payroll Expenses' as AccountName,
                        ISNULL(SUM(p.GrossAmount), 0) as Amount
                    FROM PayrollTransactions p
                    WHERE p.PayPeriodStart BETWEEN @fromDate AND @toDate
                    
                    UNION ALL
                    
                    SELECT 
                        'EXPENSES' as Category,
                        'Rent & Utilities' as AccountName,
                        ISNULL(SUM(ru.Amount), 0) as Amount
                    FROM RentUtilities ru
                    WHERE ru.TransactionDate BETWEEN @fromDate AND @toDate
                )
                SELECT Category, AccountName, Amount
                FROM RevenueData
                WHERE Amount > 0
                UNION ALL
                SELECT Category, AccountName, Amount
                FROM ExpenseData
                WHERE Amount > 0
                ORDER BY Category DESC, AccountName"

                Using da As New SqlDataAdapter(sql, conn)
                    da.SelectCommand.Parameters.AddWithValue("@fromDate", dtpFromDate.Value.Date)
                    da.SelectCommand.Parameters.AddWithValue("@toDate", dtpToDate.Value.Date.AddDays(1).AddSeconds(-1))
                    
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    
                    dgvIncomeStatement.DataSource = dt
                    
                    ' Calculate totals
                    CalculateTotals(dt)
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading income statement: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub CalculateTotals(dt As DataTable)
        Dim totalRevenue As Decimal = 0
        Dim totalExpenses As Decimal = 0

        For Each row As DataRow In dt.Rows
            Dim amount As Decimal = Convert.ToDecimal(row("Amount"))
            If row("Category").ToString() = "REVENUE" Then
                totalRevenue += amount
            ElseIf row("Category").ToString() = "EXPENSES" Then
                totalExpenses += amount
            End If
        Next

        Dim netIncome As Decimal = totalRevenue - totalExpenses

        lblTotalRevenue.Text = $"Total Revenue: R {totalRevenue:N2}"
        lblTotalExpenses.Text = $"Total Expenses: R {totalExpenses:N2}"
        lblNetIncome.Text = $"Net Income: R {netIncome:N2}"
        
        ' Color code net income
        If netIncome >= 0 Then
            lblNetIncome.ForeColor = Color.Green
        Else
            lblNetIncome.ForeColor = Color.Red
        End If
    End Sub

    Private Sub OnGenerateReport(sender As Object, e As EventArgs)
        LoadIncomeStatement()
    End Sub

    Private Sub OnExportReport(sender As Object, e As EventArgs)
        Try
            Dim saveDialog As New SaveFileDialog()
            saveDialog.Filter = "CSV files (*.csv)|*.csv"
            saveDialog.FileName = $"IncomeStatement_{dtpFromDate.Value:yyyy-MM-dd}_to_{dtpToDate.Value:yyyy-MM-dd}.csv"
            
            If saveDialog.ShowDialog() = DialogResult.OK Then
                ExportToCSV(saveDialog.FileName)
                MessageBox.Show("Income statement exported successfully.", "Export Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error exporting report: {ex.Message}", "Export Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ExportToCSV(fileName As String)
        Using writer As New System.IO.StreamWriter(fileName)
            ' Write header
            writer.WriteLine($"Income Statement Report - {dtpFromDate.Value:yyyy-MM-dd} to {dtpToDate.Value:yyyy-MM-dd}")
            writer.WriteLine("Category,Account Name,Amount")
            
            ' Write data
            If dgvIncomeStatement.DataSource IsNot Nothing Then
                Dim dt = CType(dgvIncomeStatement.DataSource, DataTable)
                For Each row As DataRow In dt.Rows
                    writer.WriteLine($"{row("Category")},{row("AccountName")},{row("Amount")}")
                Next
            End If
            
            ' Write totals
            writer.WriteLine("")
            writer.WriteLine($"Summary")
            writer.WriteLine($"{lblTotalRevenue.Text}")
            writer.WriteLine($"{lblTotalExpenses.Text}")
            writer.WriteLine($"{lblNetIncome.Text}")
        End Using
    End Sub
End Class
