Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms
Imports System.Drawing

Public Class BalanceSheetForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly dgvBalanceSheet As New DataGridView()
    Private ReadOnly dtpAsOfDate As New DateTimePicker()
    Private ReadOnly btnGenerate As New Button()
    Private ReadOnly btnExport As New Button()
    Private ReadOnly btnClose As New Button()
    Private ReadOnly lblTotalAssets As New Label()
    Private ReadOnly lblTotalLiabilities As New Label()
    Private ReadOnly lblTotalEquity As New Label()

    Public Sub New()
        InitializeFormProperties()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        SetupUI()
        LoadBalanceSheet()
    End Sub

    Private Sub InitializeFormProperties()
        Me.Text = "Balance Sheet Report"
        Me.Size = New Size(1000, 700)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.Sizable
        Me.WindowState = FormWindowState.Maximized
    End Sub

    Private Sub SetupUI()
        ' As of date control
        Dim lblAsOfDate As New Label()
        lblAsOfDate.Text = "As of Date:"
        lblAsOfDate.Location = New Point(20, 20)
        lblAsOfDate.AutoSize = True

        dtpAsOfDate.Location = New Point(100, 18)
        dtpAsOfDate.Size = New Size(150, 20)
        dtpAsOfDate.Value = DateTime.Now

        ' Generate button
        btnGenerate.Text = "Generate Report"
        btnGenerate.Location = New Point(270, 18)
        btnGenerate.Size = New Size(120, 25)
        AddHandler btnGenerate.Click, AddressOf OnGenerateReport

        ' Export button
        btnExport.Text = "Export to CSV"
        btnExport.Location = New Point(400, 18)
        btnExport.Size = New Size(100, 25)
        AddHandler btnExport.Click, AddressOf OnExportReport

        ' DataGridView for balance sheet
        dgvBalanceSheet.Location = New Point(20, 60)
        dgvBalanceSheet.Size = New Size(950, 450)
        dgvBalanceSheet.ReadOnly = True
        dgvBalanceSheet.AllowUserToAddRows = False
        dgvBalanceSheet.AllowUserToDeleteRows = False
        dgvBalanceSheet.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvBalanceSheet.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill

        ' Summary labels
        lblTotalAssets.Text = "Total Assets: R 0.00"
        lblTotalAssets.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        lblTotalAssets.ForeColor = Color.Blue
        lblTotalAssets.Location = New Point(20, 530)
        lblTotalAssets.AutoSize = True

        lblTotalLiabilities.Text = "Total Liabilities: R 0.00"
        lblTotalLiabilities.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        lblTotalLiabilities.ForeColor = Color.Red
        lblTotalLiabilities.Location = New Point(20, 555)
        lblTotalLiabilities.AutoSize = True

        lblTotalEquity.Text = "Total Equity: R 0.00"
        lblTotalEquity.Font = New Font("Segoe UI", 12, FontStyle.Bold)
        lblTotalEquity.ForeColor = Color.Green
        lblTotalEquity.Location = New Point(20, 585)
        lblTotalEquity.AutoSize = True

        ' Close button
        btnClose.Text = "Close"
        btnClose.Location = New Point(895, 585)
        btnClose.Size = New Size(75, 30)
        AddHandler btnClose.Click, Sub() Me.Close()

        ' Add controls to form
        Me.Controls.AddRange({lblAsOfDate, dtpAsOfDate, btnGenerate, btnExport,
                             dgvBalanceSheet, lblTotalAssets, lblTotalLiabilities, lblTotalEquity, btnClose})
    End Sub

    Private Sub LoadBalanceSheet()
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return

            Using conn As New SqlConnection(_connString)
                ' Create comprehensive balance sheet query
                Dim sql = "
                WITH AssetData AS (
                    -- Current Assets
                    SELECT 
                        'ASSETS' as Category,
                        'Current Assets' as SubCategory,
                        'Cash and Cash Equivalents' as AccountName,
                        ISNULL(SUM(ba.Balance), 0) as Amount,
                        1 as SortOrder
                    FROM BankAccounts ba
                    WHERE ba.IsActive = 1
                    
                    UNION ALL
                    
                    SELECT 
                        'ASSETS' as Category,
                        'Current Assets' as SubCategory,
                        'Accounts Receivable' as AccountName,
                        ISNULL(SUM(ar.Amount), 0) as Amount,
                        2 as SortOrder
                    FROM AccountsReceivable ar
                    WHERE ar.DueDate <= DATEADD(YEAR, 1, @asOfDate)
                    AND ar.IsPaid = 0
                    
                    UNION ALL
                    
                    SELECT 
                        'ASSETS' as Category,
                        'Current Assets' as SubCategory,
                        'Inventory' as AccountName,
                        ISNULL(SUM(i.Quantity * i.UnitCost), 0) as Amount,
                        3 as SortOrder
                    FROM Inventory i
                    WHERE i.IsActive = 1
                    
                    UNION ALL
                    
                    -- Fixed Assets
                    SELECT 
                        'ASSETS' as Category,
                        'Fixed Assets' as SubCategory,
                        'Equipment' as AccountName,
                        ISNULL(SUM(fa.BookValue), 0) as Amount,
                        4 as SortOrder
                    FROM FixedAssets fa
                    WHERE fa.AssetType = 'Equipment'
                    AND fa.IsActive = 1
                    
                    UNION ALL
                    
                    SELECT 
                        'ASSETS' as Category,
                        'Fixed Assets' as SubCategory,
                        'Furniture & Fixtures' as AccountName,
                        ISNULL(SUM(fa.BookValue), 0) as Amount,
                        5 as SortOrder
                    FROM FixedAssets fa
                    WHERE fa.AssetType = 'Furniture'
                    AND fa.IsActive = 1
                ),
                LiabilityData AS (
                    -- Current Liabilities
                    SELECT 
                        'LIABILITIES' as Category,
                        'Current Liabilities' as SubCategory,
                        'Accounts Payable' as AccountName,
                        ISNULL(SUM(ap.Amount), 0) as Amount,
                        6 as SortOrder
                    FROM AccountsPayable ap
                    WHERE ap.DueDate <= DATEADD(YEAR, 1, @asOfDate)
                    AND ap.IsPaid = 0
                    
                    UNION ALL
                    
                    SELECT 
                        'LIABILITIES' as Category,
                        'Current Liabilities' as SubCategory,
                        'Accrued Expenses' as AccountName,
                        ISNULL(SUM(ae.Amount), 0) as Amount,
                        7 as SortOrder
                    FROM AccruedExpenses ae
                    WHERE ae.IsActive = 1
                    
                    UNION ALL
                    
                    -- Long-term Liabilities
                    SELECT 
                        'LIABILITIES' as Category,
                        'Long-term Liabilities' as SubCategory,
                        'Long-term Debt' as AccountName,
                        ISNULL(SUM(ltd.Balance), 0) as Amount,
                        8 as SortOrder
                    FROM LongTermDebt ltd
                    WHERE ltd.IsActive = 1
                ),
                EquityData AS (
                    SELECT 
                        'EQUITY' as Category,
                        'Owner Equity' as SubCategory,
                        'Owner Capital' as AccountName,
                        ISNULL(SUM(oe.Amount), 0) as Amount,
                        9 as SortOrder
                    FROM OwnerEquity oe
                    WHERE oe.IsActive = 1
                    
                    UNION ALL
                    
                    SELECT 
                        'EQUITY' as Category,
                        'Owner Equity' as SubCategory,
                        'Retained Earnings' as AccountName,
                        ISNULL(SUM(re.Amount), 0) as Amount,
                        10 as SortOrder
                    FROM RetainedEarnings re
                    WHERE re.IsActive = 1
                )
                SELECT Category, SubCategory, AccountName, Amount
                FROM AssetData
                WHERE Amount > 0
                UNION ALL
                SELECT Category, SubCategory, AccountName, Amount
                FROM LiabilityData
                WHERE Amount > 0
                UNION ALL
                SELECT Category, SubCategory, AccountName, Amount
                FROM EquityData
                WHERE Amount > 0
                ORDER BY Category, SubCategory, AccountName"

                Using da As New SqlDataAdapter(sql, conn)
                    da.SelectCommand.Parameters.AddWithValue("@asOfDate", dtpAsOfDate.Value.Date)
                    
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    
                    dgvBalanceSheet.DataSource = dt
                    
                    ' Calculate totals
                    CalculateTotals(dt)
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading balance sheet: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub CalculateTotals(dt As DataTable)
        Dim totalAssets As Decimal = 0
        Dim totalLiabilities As Decimal = 0
        Dim totalEquity As Decimal = 0

        For Each row As DataRow In dt.Rows
            Dim amount As Decimal = Convert.ToDecimal(row("Amount"))
            Select Case row("Category").ToString()
                Case "ASSETS"
                    totalAssets += amount
                Case "LIABILITIES"
                    totalLiabilities += amount
                Case "EQUITY"
                    totalEquity += amount
            End Select
        Next

        lblTotalAssets.Text = $"Total Assets: R {totalAssets:N2}"
        lblTotalLiabilities.Text = $"Total Liabilities: R {totalLiabilities:N2}"
        lblTotalEquity.Text = $"Total Equity: R {totalEquity:N2}"
        
        ' Verify balance sheet equation (Assets = Liabilities + Equity)
        Dim difference As Decimal = totalAssets - (totalLiabilities + totalEquity)
        If Math.Abs(difference) > 0.01 Then
            MessageBox.Show($"Balance Sheet Warning: Assets do not equal Liabilities + Equity. Difference: R {difference:N2}", 
                          "Balance Sheet Imbalance", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End If
    End Sub

    Private Sub OnGenerateReport(sender As Object, e As EventArgs)
        LoadBalanceSheet()
    End Sub

    Private Sub OnExportReport(sender As Object, e As EventArgs)
        Try
            Dim saveDialog As New SaveFileDialog()
            saveDialog.Filter = "CSV files (*.csv)|*.csv"
            saveDialog.FileName = $"BalanceSheet_{dtpAsOfDate.Value:yyyy-MM-dd}.csv"
            
            If saveDialog.ShowDialog() = DialogResult.OK Then
                ExportToCSV(saveDialog.FileName)
                MessageBox.Show("Balance sheet exported successfully.", "Export Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error exporting report: {ex.Message}", "Export Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ExportToCSV(fileName As String)
        Using writer As New System.IO.StreamWriter(fileName)
            ' Write header
            writer.WriteLine($"Balance Sheet Report - As of {dtpAsOfDate.Value:yyyy-MM-dd}")
            writer.WriteLine("Category,Sub Category,Account Name,Amount")
            
            ' Write data
            If dgvBalanceSheet.DataSource IsNot Nothing Then
                Dim dt = CType(dgvBalanceSheet.DataSource, DataTable)
                For Each row As DataRow In dt.Rows
                    writer.WriteLine($"{row("Category")},{row("SubCategory")},{row("AccountName")},{row("Amount")}")
                Next
            End If
            
            ' Write totals
            writer.WriteLine("")
            writer.WriteLine($"Summary")
            writer.WriteLine($"{lblTotalAssets.Text}")
            writer.WriteLine($"{lblTotalLiabilities.Text}")
            writer.WriteLine($"{lblTotalEquity.Text}")
        End Using
    End Sub
End Class
