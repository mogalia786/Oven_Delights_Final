Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Xml
Imports System.IO

Public Class SARSComplianceService
    Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    ' Generate VAT201 data for SARS submission
    Public Function GenerateVAT201Data(periodStart As Date, periodEnd As Date) As DataTable
        Dim dt As New DataTable()
        
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' VAT201 calculation query
                Dim sql As String = "
                    SELECT 
                        -- Standard rated supplies (14%)
                        SUM(CASE WHEN vat.VATRate = 14 AND vat.VATType = 'Output' THEN vat.TaxableAmount ELSE 0 END) AS StandardRatedSupplies,
                        SUM(CASE WHEN vat.VATRate = 14 AND vat.VATType = 'Output' THEN vat.VATAmount ELSE 0 END) AS OutputVATStandard,
                        
                        -- Zero rated supplies
                        SUM(CASE WHEN vat.VATRate = 0 AND vat.VATType = 'Output' THEN vat.TaxableAmount ELSE 0 END) AS ZeroRatedSupplies,
                        
                        -- Exempt supplies
                        SUM(CASE WHEN vat.VATType = 'Exempt' THEN vat.TaxableAmount ELSE 0 END) AS ExemptSupplies,
                        
                        -- Input VAT
                        SUM(CASE WHEN vat.VATType = 'Input' THEN vat.VATAmount ELSE 0 END) AS InputVAT,
                        
                        -- Bad debts recovered
                        SUM(CASE WHEN vat.VATType = 'BadDebtRecovered' THEN vat.VATAmount ELSE 0 END) AS BadDebtsRecovered,
                        
                        -- Adjustments
                        SUM(CASE WHEN vat.VATType = 'Adjustment' THEN vat.VATAmount ELSE 0 END) AS Adjustments
                        
                    FROM dbo.VATTransactions vat
                    WHERE vat.TransactionDate >= @startDate 
                    AND vat.TransactionDate <= @endDate
                    AND vat.IsActive = 1"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@startDate", periodStart)
                    cmd.Parameters.AddWithValue("@endDate", periodEnd)
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Error generating VAT201 data: {ex.Message}")
        End Try
        
        Return dt
    End Function

    ' Generate EMP201 data for PAYE submission
    Public Function GenerateEMP201Data(periodStart As Date, periodEnd As Date) As DataTable
        Dim dt As New DataTable()
        
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim sql As String = "
                    SELECT 
                        -- PAYE deducted
                        SUM(p.PAYEDeducted) AS TotalPAYE,
                        
                        -- UIF contributions (employee + employer)
                        SUM(p.UIFEmployee + p.UIFEmployer) AS TotalUIF,
                        
                        -- SDL (Skills Development Levy)
                        SUM(p.SDL) AS TotalSDL,
                        
                        -- ETI (Employment Tax Incentive)
                        SUM(p.ETI) AS TotalETI,
                        
                        -- Total liability
                        SUM(p.PAYEDeducted + p.UIFEmployee + p.UIFEmployer + p.SDL - p.ETI) AS TotalLiability,
                        
                        -- Employee count
                        COUNT(DISTINCT p.EmployeeID) AS EmployeeCount
                        
                    FROM dbo.PayrollTransactions p
                    WHERE p.PayPeriodStart >= @startDate 
                    AND p.PayPeriodEnd <= @endDate
                    AND p.IsActive = 1"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@startDate", periodStart)
                    cmd.Parameters.AddWithValue("@endDate", periodEnd)
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Error generating EMP201 data: {ex.Message}")
        End Try
        
        Return dt
    End Function

    ' Generate IRP5 certificates for employees
    Public Function GenerateIRP5Data(taxYear As Integer) As DataTable
        Dim dt As New DataTable()
        
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim sql As String = "
                    SELECT 
                        e.EmployeeNumber,
                        e.FirstName,
                        e.LastName,
                        e.IDNumber,
                        e.TaxNumber,
                        
                        -- Income details
                        SUM(p.GrossSalary) AS GrossIncome,
                        SUM(p.Allowances) AS Allowances,
                        SUM(p.Benefits) AS TaxableBenefits,
                        SUM(p.Deductions) AS Deductions,
                        SUM(p.PAYEDeducted) AS PAYEDeducted,
                        SUM(p.UIFEmployee) AS UIFContributions,
                        SUM(p.PensionContributions) AS PensionContributions,
                        SUM(p.MedicalAidContributions) AS MedicalAidContributions,
                        
                        -- Calculated fields
                        SUM(p.GrossSalary + p.Allowances + p.Benefits - p.Deductions) AS TaxableIncome,
                        
                        -- Employment details
                        MIN(p.PayPeriodStart) AS EmploymentStartDate,
                        MAX(p.PayPeriodEnd) AS EmploymentEndDate
                        
                    FROM dbo.Employees e
                    INNER JOIN dbo.PayrollTransactions p ON e.EmployeeID = p.EmployeeID
                    WHERE YEAR(p.PayPeriodStart) = @taxYear
                    AND p.IsActive = 1
                    GROUP BY e.EmployeeID, e.EmployeeNumber, e.FirstName, e.LastName, e.IDNumber, e.TaxNumber
                    ORDER BY e.EmployeeNumber"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@taxYear", taxYear)
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Error generating IRP5 data: {ex.Message}")
        End Try
        
        Return dt
    End Function

    ' Export VAT201 to CSV format for manual eFiling
    Public Sub ExportVAT201ToCSV(data As DataTable, filePath As String, periodStart As Date, periodEnd As Date)
        Try
            Using writer As New StreamWriter(filePath)
                writer.WriteLine("VAT201 Export for Period: " & periodStart.ToString("yyyy-MM-dd") & " to " & periodEnd.ToString("yyyy-MM-dd"))
                writer.WriteLine("Generated: " & DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
                writer.WriteLine("")
                
                If data.Rows.Count > 0 Then
                    Dim row As DataRow = data.Rows(0)
                    
                    writer.WriteLine("Field,Amount")
                    writer.WriteLine($"Standard Rated Supplies (Excl VAT),{If(IsDBNull(row("StandardRatedSupplies")), 0, Convert.ToDecimal(row("StandardRatedSupplies"))):F2}")
                    writer.WriteLine($"Output VAT on Standard Rated Supplies,{If(IsDBNull(row("OutputVATStandard")), 0, Convert.ToDecimal(row("OutputVATStandard"))):F2}")
                    writer.WriteLine($"Zero Rated Supplies,{If(IsDBNull(row("ZeroRatedSupplies")), 0, Convert.ToDecimal(row("ZeroRatedSupplies"))):F2}")
                    writer.WriteLine($"Exempt Supplies,{If(IsDBNull(row("ExemptSupplies")), 0, Convert.ToDecimal(row("ExemptSupplies"))):F2}")
                    writer.WriteLine($"Input VAT,{If(IsDBNull(row("InputVAT")), 0, Convert.ToDecimal(row("InputVAT"))):F2}")
                    writer.WriteLine($"Bad Debts Recovered,{If(IsDBNull(row("BadDebtsRecovered")), 0, Convert.ToDecimal(row("BadDebtsRecovered"))):F2}")
                    writer.WriteLine($"Adjustments,{If(IsDBNull(row("Adjustments")), 0, Convert.ToDecimal(row("Adjustments"))):F2}")
                    
                    Dim totalOutputVAT As Decimal = If(IsDBNull(row("OutputVATStandard")), 0, Convert.ToDecimal(row("OutputVATStandard")))
                    Dim totalInputVAT As Decimal = If(IsDBNull(row("InputVAT")), 0, Convert.ToDecimal(row("InputVAT")))
                    Dim netVAT As Decimal = totalOutputVAT - totalInputVAT
                    
                    writer.WriteLine($"Total Output VAT,{totalOutputVAT:F2}")
                    writer.WriteLine($"Total Input VAT,{totalInputVAT:F2}")
                    writer.WriteLine($"Net VAT (Payable)/Refundable,{netVAT:F2}")
                End If
            End Using
        Catch ex As Exception
            Throw New Exception($"Error exporting VAT201 to CSV: {ex.Message}")
        End Try
    End Sub

    ' Export EMP201 to CSV format
    Public Sub ExportEMP201ToCSV(data As DataTable, filePath As String, periodStart As Date, periodEnd As Date)
        Try
            Using writer As New StreamWriter(filePath)
                writer.WriteLine("EMP201 Export for Period: " & periodStart.ToString("yyyy-MM-dd") & " to " & periodEnd.ToString("yyyy-MM-dd"))
                writer.WriteLine("Generated: " & DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
                writer.WriteLine("")
                
                If data.Rows.Count > 0 Then
                    Dim row As DataRow = data.Rows(0)
                    
                    writer.WriteLine("Field,Amount")
                    writer.WriteLine($"PAYE Deducted,{Convert.ToDecimal(row("TotalPAYE")):F2}")
                    writer.WriteLine($"UIF Contributions,{Convert.ToDecimal(row("TotalUIF")):F2}")
                    writer.WriteLine($"Skills Development Levy,{Convert.ToDecimal(row("TotalSDL")):F2}")
                    writer.WriteLine($"Employment Tax Incentive,{Convert.ToDecimal(row("TotalETI")):F2}")
                    writer.WriteLine($"Total Liability,{Convert.ToDecimal(row("TotalLiability")):F2}")
                    writer.WriteLine($"Number of Employees,{Convert.ToInt32(row("EmployeeCount"))}")
                End If
            End Using
        Catch ex As Exception
            Throw New Exception($"Error exporting EMP201 to CSV: {ex.Message}")
        End Try
    End Sub

    ' Export IRP5 certificates to CSV
    Public Sub ExportIRP5ToCSV(data As DataTable, filePath As String, taxYear As Integer)
        Try
            Using writer As New StreamWriter(filePath)
                writer.WriteLine("IRP5 Certificates Export for Tax Year: " & taxYear.ToString())
                writer.WriteLine("Generated: " & DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
                writer.WriteLine("")
                
                ' CSV Headers
                writer.WriteLine("Employee Number,First Name,Last Name,ID Number,Tax Number,Gross Income,Allowances,Taxable Benefits,Deductions,PAYE Deducted,UIF Contributions,Pension Contributions,Medical Aid Contributions,Taxable Income,Employment Start,Employment End")
                
                For Each row As DataRow In data.Rows
                    writer.WriteLine($"{row("EmployeeNumber")}," &
                                   $"""{row("FirstName")}""," &
                                   $"""{row("LastName")}""," &
                                   $"{row("IDNumber")}," &
                                   $"{row("TaxNumber")}," &
                                   $"{Convert.ToDecimal(row("GrossIncome")):F2}," &
                                   $"{Convert.ToDecimal(row("Allowances")):F2}," &
                                   $"{Convert.ToDecimal(row("TaxableBenefits")):F2}," &
                                   $"{Convert.ToDecimal(row("Deductions")):F2}," &
                                   $"{Convert.ToDecimal(row("PAYEDeducted")):F2}," &
                                   $"{Convert.ToDecimal(row("UIFContributions")):F2}," &
                                   $"{Convert.ToDecimal(row("PensionContributions")):F2}," &
                                   $"{Convert.ToDecimal(row("MedicalAidContributions")):F2}," &
                                   $"{Convert.ToDecimal(row("TaxableIncome")):F2}," &
                                   $"{Convert.ToDateTime(row("EmploymentStartDate")):yyyy-MM-dd}," &
                                   $"{Convert.ToDateTime(row("EmploymentEndDate")):yyyy-MM-dd}")
                Next
            End Using
        Catch ex As Exception
            Throw New Exception($"Error exporting IRP5 to CSV: {ex.Message}")
        End Try
    End Sub

    ' Validate VAT registration and compliance
    Public Function ValidateVATCompliance() As List(Of String)
        Dim issues As New List(Of String)()
        
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Check for missing VAT numbers on suppliers
                Dim sql As String = "SELECT COUNT(*) FROM dbo.Suppliers WHERE (VATNumber IS NULL OR VATNumber = '') AND IsActive = 1"
                Using cmd As New SqlCommand(sql, conn)
                    Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    If count > 0 Then
                        issues.Add($"{count} active suppliers missing VAT numbers")
                    End If
                End Using
                
                ' Check for transactions without VAT classification
                sql = "SELECT COUNT(*) FROM dbo.Transactions WHERE VATType IS NULL AND TransactionDate >= DATEADD(month, -3, GETDATE())"
                Using cmd As New SqlCommand(sql, conn)
                    Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    If count > 0 Then
                        issues.Add($"{count} recent transactions missing VAT classification")
                    End If
                End Using
                
                ' Check for overdue VAT returns
                sql = "SELECT COUNT(*) FROM dbo.VATReturns WHERE Status = 'Pending' AND DueDate < GETDATE()"
                Using cmd As New SqlCommand(sql, conn)
                    Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    If count > 0 Then
                        issues.Add($"{count} overdue VAT returns")
                    End If
                End Using
            End Using
        Catch ex As Exception
            issues.Add($"Error validating VAT compliance: {ex.Message}")
        End Try
        
        Return issues
    End Function

End Class
