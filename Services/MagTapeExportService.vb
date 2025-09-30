Imports System.Data
Imports System.IO
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Text

Public Class MagTapeExportService
    Private ReadOnly _connStr As String

    Public Sub New()
        _connStr = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    ' Export payment batch to MagTape format for South African banks
    Public Function ExportPaymentBatch(batchId As Integer, bankCode As String) As String
        Try
            Dim payments = GetPaymentBatchData(batchId)
            If payments Is Nothing OrElse payments.Rows.Count = 0 Then
                Throw New ApplicationException("No payments found in batch.")
            End If

            Select Case bankCode.ToUpper()
                Case "ABSA"
                    Return GenerateAbsaMagTape(payments, batchId)
                Case "FNB"
                    Return GenerateFnbMagTape(payments, batchId)
                Case "STANDARD"
                    Return GenerateStandardBankMagTape(payments, batchId)
                Case "NEDBANK"
                    Return GenerateNedbankMagTape(payments, batchId)
                Case Else
                    Return GenerateGenericNaedoFormat(payments, batchId)
            End Select
        Catch ex As Exception
            Throw New ApplicationException($"MagTape export failed: {ex.Message}", ex)
        End Try
    End Function

    Private Function GetPaymentBatchData(batchId As Integer) As DataTable
        Using conn As New SqlConnection(_connStr)
            Dim sql = "SELECT pb.BatchNumber, pb.TotalAmount, pb.PaymentDate, pb.BankAccountNumber, " &
                      "p.PaymentID, p.SupplierID, p.Amount, p.Reference, " &
                      "s.SupplierName, s.BankName, s.BranchCode, s.AccountNumber, s.AccountType " &
                      "FROM PaymentBatches pb " &
                      "INNER JOIN Payments p ON p.BatchID = pb.BatchID " &
                      "INNER JOIN Suppliers s ON s.SupplierID = p.SupplierID " &
                      "WHERE pb.BatchID = @batchId AND pb.Status = 'APPROVED' " &
                      "ORDER BY p.PaymentID"
            
            Using da As New SqlDataAdapter(sql, conn)
                da.SelectCommand.Parameters.AddWithValue("@batchId", batchId)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            End Using
        End Using
    End Function

    ' ABSA MagTape format (ACB format)
    Private Function GenerateAbsaMagTape(payments As DataTable, batchId As Integer) As String
        Dim sb As New StringBuilder()
        Dim totalAmount As Decimal = 0
        Dim recordCount As Integer = 0

        ' Header record
        Dim batchNumber = payments.Rows(0)("BatchNumber").ToString().PadLeft(6, "0"c)
        Dim paymentDate = CDate(payments.Rows(0)("PaymentDate")).ToString("yyyyMMdd")
        Dim originatorAccount = payments.Rows(0)("BankAccountNumber").ToString().PadRight(15)
        
        sb.AppendLine($"1{batchNumber}{paymentDate}{originatorAccount}SALARY PAYMENTS".PadRight(80))

        ' Detail records
        For Each row As DataRow In payments.Rows
            recordCount += 1
            Dim amount = CDec(row("Amount"))
            totalAmount += amount
            
            Dim beneficiaryAccount = row("AccountNumber").ToString().PadRight(15)
            Dim beneficiaryName = row("SupplierName").ToString().Substring(0, Math.Min(32, row("SupplierName").ToString().Length)).PadRight(32)
            Dim branchCode = row("BranchCode").ToString().PadLeft(6, "0"c)
            Dim reference = row("Reference").ToString().Substring(0, Math.Min(20, row("Reference").ToString().Length)).PadRight(20)
            Dim amountStr = (amount * 100).ToString("000000000000") ' Amount in cents
            
            sb.AppendLine($"2{beneficiaryAccount}{beneficiaryName}{branchCode}{reference}{amountStr}")
        Next

        ' Trailer record
        Dim totalAmountStr = (totalAmount * 100).ToString("000000000000000")
        Dim recordCountStr = recordCount.ToString("000000")
        sb.AppendLine($"9{totalAmountStr}{recordCountStr}".PadRight(80))

        Return sb.ToString()
    End Function

    ' FNB MagTape format
    Private Function GenerateFnbMagTape(payments As DataTable, batchId As Integer) As String
        Dim sb As New StringBuilder()
        Dim totalAmount As Decimal = 0
        Dim recordCount As Integer = 0

        ' Header record - FNB format
        Dim batchNumber = payments.Rows(0)("BatchNumber").ToString().PadLeft(8, "0"c)
        Dim paymentDate = CDate(payments.Rows(0)("PaymentDate")).ToString("yyyyMMdd")
        Dim originatorAccount = payments.Rows(0)("BankAccountNumber").ToString().PadRight(16)
        
        sb.AppendLine($"HDR{batchNumber}{paymentDate}{originatorAccount}PAYMENTS")

        ' Detail records
        For Each row As DataRow In payments.Rows
            recordCount += 1
            Dim amount = CDec(row("Amount"))
            totalAmount += amount
            
            Dim beneficiaryAccount = row("AccountNumber").ToString().PadRight(16)
            Dim beneficiaryName = row("SupplierName").ToString().Substring(0, Math.Min(30, row("SupplierName").ToString().Length)).PadRight(30)
            Dim branchCode = row("BranchCode").ToString().PadLeft(6, "0"c)
            Dim reference = row("Reference").ToString().Substring(0, Math.Min(16, row("Reference").ToString().Length)).PadRight(16)
            Dim amountStr = amount.ToString("000000000.00")
            
            sb.AppendLine($"DTL{beneficiaryAccount}{beneficiaryName}{branchCode}{reference}{amountStr}")
        Next

        ' Trailer record
        Dim totalAmountStr = totalAmount.ToString("000000000000.00")
        Dim recordCountStr = recordCount.ToString("000000")
        sb.AppendLine($"TRL{totalAmountStr}{recordCountStr}")

        Return sb.ToString()
    End Function

    ' Standard Bank MagTape format
    Private Function GenerateStandardBankMagTape(payments As DataTable, batchId As Integer) As String
        Dim sb As New StringBuilder()
        Dim totalAmount As Decimal = 0
        Dim recordCount As Integer = 0

        ' Header record - Standard Bank format
        Dim batchNumber = payments.Rows(0)("BatchNumber").ToString().PadLeft(6, "0"c)
        Dim paymentDate = CDate(payments.Rows(0)("PaymentDate")).ToString("yyyyMMdd")
        Dim originatorAccount = payments.Rows(0)("BankAccountNumber").ToString().PadRight(11)
        
        sb.AppendLine($"000001{batchNumber}{paymentDate}{originatorAccount}PAYMENTS")

        ' Detail records
        For Each row As DataRow In payments.Rows
            recordCount += 1
            Dim amount = CDec(row("Amount"))
            totalAmount += amount
            
            Dim beneficiaryAccount = row("AccountNumber").ToString().PadRight(11)
            Dim beneficiaryName = row("SupplierName").ToString().Substring(0, Math.Min(25, row("SupplierName").ToString().Length)).PadRight(25)
            Dim branchCode = row("BranchCode").ToString().PadLeft(6, "0"c)
            Dim reference = row("Reference").ToString().Substring(0, Math.Min(12, row("Reference").ToString().Length)).PadRight(12)
            Dim amountStr = (amount * 100).ToString("0000000000") ' Amount in cents
            
            sb.AppendLine($"000002{beneficiaryAccount}{beneficiaryName}{branchCode}{reference}{amountStr}")
        Next

        ' Trailer record
        Dim totalAmountStr = (totalAmount * 100).ToString("0000000000000")
        Dim recordCountStr = recordCount.ToString("000000")
        sb.AppendLine($"000009{totalAmountStr}{recordCountStr}")

        Return sb.ToString()
    End Function

    ' Nedbank MagTape format
    Private Function GenerateNedbankMagTape(payments As DataTable, batchId As Integer) As String
        Dim sb As New StringBuilder()
        Dim totalAmount As Decimal = 0
        Dim recordCount As Integer = 0

        ' Header record - Nedbank format
        Dim batchNumber = payments.Rows(0)("BatchNumber").ToString().PadLeft(7, "0"c)
        Dim paymentDate = CDate(payments.Rows(0)("PaymentDate")).ToString("yyyyMMdd")
        Dim originatorAccount = payments.Rows(0)("BankAccountNumber").ToString().PadRight(15)
        
        sb.AppendLine($"H{batchNumber}{paymentDate}{originatorAccount}SUPPLIER PAYMENTS")

        ' Detail records
        For Each row As DataRow In payments.Rows
            recordCount += 1
            Dim amount = CDec(row("Amount"))
            totalAmount += amount
            
            Dim beneficiaryAccount = row("AccountNumber").ToString().PadRight(15)
            Dim beneficiaryName = row("SupplierName").ToString().Substring(0, Math.Min(28, row("SupplierName").ToString().Length)).PadRight(28)
            Dim branchCode = row("BranchCode").ToString().PadLeft(6, "0"c)
            Dim reference = row("Reference").ToString().Substring(0, Math.Min(18, row("Reference").ToString().Length)).PadRight(18)
            Dim amountStr = (amount * 100).ToString("00000000000") ' Amount in cents
            
            sb.AppendLine($"D{beneficiaryAccount}{beneficiaryName}{branchCode}{reference}{amountStr}")
        Next

        ' Trailer record
        Dim totalAmountStr = (totalAmount * 100).ToString("00000000000000")
        Dim recordCountStr = recordCount.ToString("0000000")
        sb.AppendLine($"T{totalAmountStr}{recordCountStr}")

        Return sb.ToString()
    End Function

    ' Generic NAEDO format for other banks
    Private Function GenerateGenericNaedoFormat(payments As DataTable, batchId As Integer) As String
        Dim sb As New StringBuilder()
        Dim totalAmount As Decimal = 0
        Dim recordCount As Integer = 0

        ' Header record - Generic NAEDO format
        Dim batchNumber = payments.Rows(0)("BatchNumber").ToString().PadLeft(8, "0"c)
        Dim paymentDate = CDate(payments.Rows(0)("PaymentDate")).ToString("yyyyMMdd")
        Dim originatorAccount = payments.Rows(0)("BankAccountNumber").ToString().PadRight(20)
        
        sb.AppendLine($"HEADER,{batchNumber},{paymentDate},{originatorAccount},PAYMENTS")

        ' Detail records
        For Each row As DataRow In payments.Rows
            recordCount += 1
            Dim amount = CDec(row("Amount"))
            totalAmount += amount
            
            Dim beneficiaryAccount = row("AccountNumber").ToString()
            Dim beneficiaryName = row("SupplierName").ToString()
            Dim branchCode = row("BranchCode").ToString()
            Dim reference = row("Reference").ToString()
            
            sb.AppendLine($"DETAIL,{beneficiaryAccount},{beneficiaryName},{branchCode},{reference},{amount:F2}")
        Next

        ' Trailer record
        sb.AppendLine($"TRAILER,{totalAmount:F2},{recordCount}")

        Return sb.ToString()
    End Function

    ' Save MagTape file to disk
    Public Function SaveMagTapeFile(content As String, batchId As Integer, bankCode As String) As String
        Dim fileName = $"MAGTAPE_{bankCode}_{batchId}_{DateTime.Now:yyyyMMdd_HHmmss}.txt"
        Dim filePath = IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "ERP_Exports", fileName)
        
        IO.Directory.CreateDirectory(IO.Path.GetDirectoryName(filePath))
        IO.File.WriteAllText(filePath, content, Encoding.ASCII)
        
        Return filePath
    End Function
End Class
