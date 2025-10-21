Imports System.Data
Imports System.IO
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class BankStatementImportService
    Private ReadOnly _connStr As String

    Public Sub New()
        _connStr = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub
    ' Parse CSV bank statement with support for South African bank formats
    Public Function ParseCsv(path As String, Optional bankFormat As String = "AUTO") As DataTable
        Dim dt As New DataTable()
        dt.Columns.Add("Date", GetType(Date))
        dt.Columns.Add("Reference")
        dt.Columns.Add("Description")
        dt.Columns.Add("Amount", GetType(Decimal))
        dt.Columns.Add("Balance", GetType(Decimal))
        dt.Columns.Add("Target") ' Expense/Income/AP/AR
        
        If String.IsNullOrWhiteSpace(path) OrElse Not File.Exists(path) Then Return dt
        
        Using sr As New StreamReader(path)
            Dim lines As New List(Of String)()
            While Not sr.EndOfStream
                lines.Add(sr.ReadLine())
            End While
            
            ' Detect bank format and parse accordingly
            Select Case bankFormat.ToUpper()
                Case "ABSA"
                    ParseAbsaFormat(dt, lines)
                Case "FNB"
                    ParseFnbFormat(dt, lines)
                Case "STANDARD"
                    ParseStandardBankFormat(dt, lines)
                Case "NEDBANK"
                    ParseNedbankFormat(dt, lines)
                Case Else
                    ParseGenericFormat(dt, lines)
            End Select
        End Using
        Return dt
    End Function

    ' ABSA Format: Date, Description, Amount, Balance
    Private Sub ParseAbsaFormat(dt As DataTable, lines As List(Of String))
        Dim startIndex = 0
        ' Skip header if present
        If lines.Count > 0 AndAlso lines(0).ToLower().Contains("date") Then startIndex = 1
        
        For i As Integer = startIndex To lines.Count - 1
            Dim line = lines(i).Trim()
            If String.IsNullOrWhiteSpace(line) Then Continue For
            
            Dim parts = SplitCsvLine(line)
            If parts.Length >= 4 Then
                Dim transDate As Date
                Dim amount, balance As Decimal
                
                If Date.TryParse(parts(0), transDate) AndAlso
                   Decimal.TryParse(parts(2), amount) AndAlso
                   Decimal.TryParse(parts(3), balance) Then
                    dt.Rows.Add(transDate, "", parts(1), amount, balance, "")
                End If
            End If
        Next
    End Sub
    
    ' FNB Format: Date, SERVICE FEE, Amount, DESCRIPTION, CHEQUE NUMBER, Balance
    Private Sub ParseFnbFormat(dt As DataTable, lines As List(Of String))
        Dim startIndex = 0
        ' Skip account info and find column headers
        For i As Integer = 0 To Math.Min(10, lines.Count - 1)
            If lines(i).ToLower().Contains("date") Then
                startIndex = i + 1
                Exit For
            End If
        Next
        
        For i As Integer = startIndex To lines.Count - 1
            Dim line = lines(i).Trim()
            If String.IsNullOrWhiteSpace(line) Then Continue For
            
            Dim parts = SplitCsvLine(line)
            If parts.Length >= 6 Then
                Dim transDate As Date
                Dim amount, balance As Decimal
                
                If Date.TryParse(parts(0), transDate) AndAlso
                   Decimal.TryParse(parts(2), amount) AndAlso
                   Decimal.TryParse(parts(5), balance) Then
                    Dim reference = If(parts.Length > 4, parts(4), "")
                    dt.Rows.Add(transDate, reference, parts(3), amount, balance, "")
                End If
            End If
        Next
    End Sub
    
    ' Standard Bank Format: Date, Reference, Amount, Balance
    Private Sub ParseStandardBankFormat(dt As DataTable, lines As List(Of String))
        Dim startIndex = 0
        If lines.Count > 0 AndAlso lines(0).ToLower().Contains("date") Then startIndex = 1
        
        For i As Integer = startIndex To lines.Count - 1
            Dim line = lines(i).Trim()
            If String.IsNullOrWhiteSpace(line) Then Continue For
            
            Dim parts = SplitCsvLine(line)
            If parts.Length >= 4 Then
                Dim transDate As Date
                Dim amount, balance As Decimal
                
                If Date.TryParse(parts(0), transDate) AndAlso
                   Decimal.TryParse(parts(2), amount) AndAlso
                   Decimal.TryParse(parts(3), balance) Then
                    dt.Rows.Add(transDate, parts(1), parts(1), amount, balance, "")
                End If
            End If
        Next
    End Sub
    
    ' Nedbank Format: First 4 lines are account details, then: Date, Reference, Amount, Balance
    Private Sub ParseNedbankFormat(dt As DataTable, lines As List(Of String))
        Dim startIndex = 4 ' Skip first 4 lines of account details
        
        For i As Integer = startIndex To lines.Count - 1
            Dim line = lines(i).Trim()
            If String.IsNullOrWhiteSpace(line) Then Continue For
            
            Dim parts = SplitCsvLine(line)
            ' Handle both formats: Date,Reference,Amount,Balance or ArbitraryNumber,Date,Reference,Amount,Balance
            Dim dateIndex = 0
            If parts.Length >= 5 Then dateIndex = 1 ' Has arbitrary number prefix
            
            If parts.Length >= dateIndex + 4 Then
                Dim transDate As Date
                Dim amount, balance As Decimal
                
                If Date.TryParse(parts(dateIndex), transDate) AndAlso
                   Decimal.TryParse(parts(dateIndex + 2), amount) AndAlso
                   Decimal.TryParse(parts(dateIndex + 3), balance) Then
                    dt.Rows.Add(transDate, parts(dateIndex + 1), parts(dateIndex + 1), amount, balance, "")
                End If
            End If
        Next
    End Sub
    
    ' Generic format fallback
    Private Sub ParseGenericFormat(dt As DataTable, lines As List(Of String))
        Dim startIndex = 0
        If lines.Count > 0 AndAlso lines(0).ToLower().Contains("date") Then startIndex = 1
        
        For i As Integer = startIndex To lines.Count - 1
            Dim line = lines(i).Trim()
            If String.IsNullOrWhiteSpace(line) Then Continue For
            
            Dim parts = SplitCsvLine(line)
            If parts.Length >= 3 Then
                Dim transDate As Date
                Dim amount As Decimal
                
                If Date.TryParse(parts(0), transDate) AndAlso
                   Decimal.TryParse(parts(2), amount) Then
                    Dim balance As Decimal = 0
                    If parts.Length > 3 Then Decimal.TryParse(parts(3), balance)
                    dt.Rows.Add(transDate, "", parts(1), amount, balance, "")
                End If
            End If
        Next
    End Sub
    
    ' Helper to properly split CSV lines handling quoted fields
    Private Function SplitCsvLine(line As String) As String()
        Dim result As New List(Of String)()
        Dim current As New System.Text.StringBuilder()
        Dim inQuotes As Boolean = False
        
        For i As Integer = 0 To line.Length - 1
            Dim c = line(i)
            
            If c = """"c Then
                inQuotes = Not inQuotes
            ElseIf c = ","c AndAlso Not inQuotes Then
                result.Add(current.ToString().Trim())
                current.Clear()
            Else
                current.Append(c)
            End If
        Next
        
        result.Add(current.ToString().Trim())
        Return result.ToArray()
    End Function

    ' Rule engine for transaction categorization. Returns modified table.
    Public Function ApplyRules(dt As DataTable) As DataTable
        If dt Is Nothing Then Return Nothing
        For Each r As DataRow In dt.Rows
            Dim desc = Convert.ToString(r("Description")).ToLowerInvariant()
            If desc.Contains("eskom") OrElse desc.Contains("electric") Then r("Target") = "Expense"
            If desc.Contains("rates") OrElse desc.Contains("municipality") Then r("Target") = "Expense"
            If desc.Contains("sale") OrElse desc.Contains("income") Then r("Target") = "Income"
        Next
        Return dt
    End Function

    ' Infer ledger mapping with simple rules; adds columns if missing
    Public Function MapToLedgers(dt As DataTable) As DataTable
        If dt Is Nothing Then Return Nothing
        If Not dt.Columns.Contains("Ledger") Then dt.Columns.Add("Ledger")
        If Not dt.Columns.Contains("Side") Then dt.Columns.Add("Side") ' DR or CR
        For Each r As DataRow In dt.Rows
            Dim target As String = Convert.ToString(r("Target")).Trim()
            Dim desc As String = Convert.ToString(r("Description")).ToLowerInvariant()
            Dim amt As Decimal = 0D
            Decimal.TryParse(Convert.ToString(r("Amount")), amt)
            Dim ledger As String = Nothing
            Dim side As String = Nothing
            ' Basic mapping
            If String.Equals(target, "Expense", StringComparison.OrdinalIgnoreCase) Then
                ledger = "EXP:UTILITIES"
                side = If(amt < 0D, "CR", "DR")
            ElseIf String.Equals(target, "Income", StringComparison.OrdinalIgnoreCase) Then
                ledger = "INC:SALES"
                side = If(amt < 0D, "DR", "CR")
            ElseIf desc.Contains("bank charge") OrElse desc.Contains("fee") Then
                ledger = "EXP:BANK CHARGES"
                side = If(amt < 0D, "CR", "DR")
            ElseIf desc.Contains("interest") Then
                ledger = If(amt >= 0D, "INC:INTEREST", "EXP:INTEREST")
                side = If(amt < 0D, "CR", "DR")
            Else
                ledger = "UNCATEGORISED"
                side = If(amt < 0D, "CR", "DR")
            End If
            r("Ledger") = ledger
            r("Side") = side
        Next
        Return dt
    End Function

    ' Posting integration with AccountingPostingService for ledger updates.
    Public Function PostToLedgers(dt As DataTable, postedBy As Integer) As Boolean
        If dt Is Nothing OrElse dt.Rows.Count = 0 Then Return False
        Try
            Dim fiscalId = GetOpenFiscalPeriodId(Date.Today)
            If Not fiscalId.HasValue Then
                Throw New ApplicationException("No open fiscal period for today; cannot post bank import.")
            End If
            Dim aps As New AccountingPostingService()
            Dim bankAccountId As Integer = aps.GetBankAccountId()
            If bankAccountId <= 0 Then
                Throw New ApplicationException("BANK_DEFAULT system account not configured.")
            End If

            Dim branchId As Integer = AppSession.CurrentBranchID
            Dim jId As Integer = aps.CreateJournalEntry(Date.Today, "BANK-IMPORT", "Bank statement import", fiscalId.Value, postedBy, branchId)

            For Each r As DataRow In dt.Rows
                Dim desc As String = Convert.ToString(r("Description"))
                Dim amt As Decimal = 0D
                Decimal.TryParse(Convert.ToString(r("Amount")), amt)
                If amt = 0D Then Continue For
                Dim side As String = If(dt.Columns.Contains("Side"), Convert.ToString(r("Side")).ToUpperInvariant(), Nothing)
                If String.IsNullOrWhiteSpace(side) Then
                    side = If(amt >= 0D, "DR", "CR") ' deposits default to DR Bank
                End If
                Dim ledgerKey As String = Nothing
                If dt.Columns.Contains("Ledger") Then
                    ledgerKey = MapLedgerKeyFromName(Convert.ToString(r("Ledger")))
                End If
                If String.IsNullOrWhiteSpace(ledgerKey) Then
                    Dim tgt = If(dt.Columns.Contains("Target"), Convert.ToString(r("Target")), "")
                    If tgt.Equals("Income", StringComparison.OrdinalIgnoreCase) Then ledgerKey = "INC_MISC" Else ledgerKey = "EXP_MISC"
                End If
                Dim contraId As Integer = aps.GetSystemAccountId(ledgerKey)
                If contraId <= 0 Then contraId = aps.GetSystemAccountId("SUSPENSE")
                If contraId <= 0 Then Throw New ApplicationException("No suitable contra SystemAccount found (tried ledger and SUSPENSE).")

                Dim debit As Decimal = 0D, credit As Decimal = 0D
                If side = "DR" Then
                    ' DR Bank; CR Contra
                    debit = Math.Abs(amt)
                    aps.AddJournalDetail(jId, bankAccountId, debit, 0D, desc, Nothing, Nothing)
                    credit = Math.Abs(amt)
                    aps.AddJournalDetail(jId, contraId, 0D, credit, desc, Nothing, Nothing)
                Else
                    ' CR Bank; DR Contra
                    debit = Math.Abs(amt)
                    aps.AddJournalDetail(jId, contraId, debit, 0D, desc, Nothing, Nothing)
                    credit = Math.Abs(amt)
                    aps.AddJournalDetail(jId, bankAccountId, 0D, credit, desc, Nothing, Nothing)
                End If
            Next

            aps.PostJournal(jId, postedBy)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Private Function GetOpenFiscalPeriodId(d As Date) As Integer?
        Try
            Using cn As New SqlConnection(_connStr)
                Using cmd As New SqlCommand("SELECT TOP 1 PeriodID FROM FiscalPeriods WHERE @d BETWEEN StartDate AND EndDate AND IsClosed=0 ORDER BY StartDate DESC", cn)
                    cmd.Parameters.AddWithValue("@d", d)
                    cn.Open()
                    Dim o = cmd.ExecuteScalar()
                    If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return Convert.ToInt32(o)
                End Using
            End Using
        Catch
        End Try
        Return Nothing
    End Function

    Private Function MapLedgerKeyFromName(name As String) As String
        If String.IsNullOrWhiteSpace(name) Then Return Nothing
        Dim s = name.ToUpperInvariant().Trim()
        s = s.Replace(":", "_").Replace(" ", "_")
        Dim clean As New System.Text.StringBuilder()
        For Each ch As Char In s
            If Char.IsLetterOrDigit(ch) OrElse ch = "_"c Then clean.Append(ch)
        Next
        Return clean.ToString()
    End Function
End Class
