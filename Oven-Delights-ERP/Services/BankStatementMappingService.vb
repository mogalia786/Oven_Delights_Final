Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Text.RegularExpressions

Public Class BankStatementMappingService
    Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    
    ' Predefined mapping rules for automatic expense categorization
    Private ReadOnly mappingRules As New Dictionary(Of String, String) From {
        {"RENT", "Rent Expense"},
        {"RATES", "Municipal Rates"},
        {"ELECTRICITY", "Electricity Expense"},
        {"WATER", "Water & Sewerage"},
        {"TELEPHONE", "Telephone Expense"},
        {"INTERNET", "Internet & Communications"},
        {"INSURANCE", "Insurance Expense"},
        {"FUEL", "Fuel & Transport"},
        {"PETROL", "Fuel & Transport"},
        {"DIESEL", "Fuel & Transport"},
        {"BANK CHARGES", "Bank Charges"},
        {"INTEREST", "Interest Earned"},
        {"SALARY", "Salaries & Wages"},
        {"WAGES", "Salaries & Wages"},
        {"EFT", "Sales Revenue"},
        {"DEPOSIT", "Sales Revenue"},
        {"TRANSFER", "Inter-Account Transfer"}
    }

    Public Function ImportBankStatement(filePath As String) As DataTable
        Dim dt As New DataTable()
        
        Try
            ' Read Excel file and convert to DataTable
            dt = ReadExcelFile(filePath)
            
            ' Standardize column names
            StandardizeColumns(dt)
            
            ' Add mapping columns
            dt.Columns.Add("SuggestedAccount", GetType(String))
            dt.Columns.Add("AccountCode", GetType(String))
            dt.Columns.Add("TransactionType", GetType(String))
            dt.Columns.Add("SupplierMatch", GetType(String))
            dt.Columns.Add("InvoiceMatch", GetType(String))
            
            ' Apply automatic mapping
            For Each row As DataRow In dt.Rows
                MapTransaction(row)
            Next
            
        Catch ex As Exception
            Throw New Exception($"Error importing bank statement: {ex.Message}")
        End Try
        
        Return dt
    End Function

    Private Function ReadExcelFile(filePath As String) As DataTable
        ' This would use Excel interop or EPPlus library
        ' For now, assume CSV format for simplicity
        Dim dt As New DataTable()
        
        Using reader As New System.IO.StreamReader(filePath)
            Dim headers As String() = reader.ReadLine().Split(","c)
            
            For Each header As String In headers
                dt.Columns.Add(header.Trim(""""c))
            Next
            
            While Not reader.EndOfStream
                Dim values As String() = reader.ReadLine().Split(","c)
                Dim row As DataRow = dt.NewRow()
                
                For i As Integer = 0 To Math.Min(values.Length - 1, dt.Columns.Count - 1)
                    row(i) = values(i).Trim(""""c)
                Next
                
                dt.Rows.Add(row)
            End While
        End Using
        
        Return dt
    End Function

    Private Sub StandardizeColumns(dt As DataTable)
        ' Map common bank statement column variations to standard names
        Dim columnMappings As New Dictionary(Of String, String) From {
            {"Date", "TransactionDate"},
            {"Transaction Date", "TransactionDate"},
            {"Value Date", "TransactionDate"},
            {"Description", "Description"},
            {"Reference", "Description"},
            {"Details", "Description"},
            {"Amount", "Amount"},
            {"Debit", "DebitAmount"},
            {"Credit", "CreditAmount"},
            {"Balance", "Balance"}
        }
        
        For Each mapping In columnMappings
            If dt.Columns.Contains(mapping.Key) AndAlso Not dt.Columns.Contains(mapping.Value) Then
                dt.Columns(mapping.Key).ColumnName = mapping.Value
            End If
        Next
        
        ' Ensure required columns exist
        If Not dt.Columns.Contains("TransactionDate") Then dt.Columns.Add("TransactionDate", GetType(Date))
        If Not dt.Columns.Contains("Description") Then dt.Columns.Add("Description", GetType(String))
        If Not dt.Columns.Contains("Amount") Then dt.Columns.Add("Amount", GetType(Decimal))
        If Not dt.Columns.Contains("DebitAmount") Then dt.Columns.Add("DebitAmount", GetType(Decimal))
        If Not dt.Columns.Contains("CreditAmount") Then dt.Columns.Add("CreditAmount", GetType(Decimal))
    End Sub

    Private Sub MapTransaction(row As DataRow)
        Dim description As String = row("Description").ToString().ToUpper()
        Dim amount As Decimal = GetTransactionAmount(row)
        
        ' Default values
        row("SuggestedAccount") = "Unclassified"
        row("AccountCode") = "9999"
        row("TransactionType") = If(amount > 0, "Credit", "Debit")
        row("SupplierMatch") = ""
        row("InvoiceMatch") = ""
        
        ' Apply mapping rules
        For Each rule In mappingRules
            If description.Contains(rule.Key) Then
                row("SuggestedAccount") = rule.Value
                row("AccountCode") = GetAccountCode(rule.Value)
                Exit For
            End If
        Next
        
        ' Check for supplier matches
        CheckSupplierMatch(row, description)
        
        ' Check for invoice references
        CheckInvoiceMatch(row, description)
        
        ' Special handling for specific patterns
        ApplySpecialRules(row, description, amount)
    End Sub

    Private Function GetTransactionAmount(row As DataRow) As Decimal
        ' Handle different amount column formats
        If Not IsDBNull(row("Amount")) AndAlso Not String.IsNullOrEmpty(row("Amount").ToString()) Then
            Return Convert.ToDecimal(row("Amount"))
        ElseIf Not IsDBNull(row("CreditAmount")) AndAlso Not String.IsNullOrEmpty(row("CreditAmount").ToString()) Then
            Return Convert.ToDecimal(row("CreditAmount"))
        ElseIf Not IsDBNull(row("DebitAmount")) AndAlso Not String.IsNullOrEmpty(row("DebitAmount").ToString()) Then
            Return -Convert.ToDecimal(row("DebitAmount"))
        End If
        
        Return 0
    End Function

    Private Sub CheckSupplierMatch(row As DataRow, description As String)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim sql As String = "SELECT TOP 1 SupplierName FROM dbo.Suppliers WHERE @desc LIKE '%' + SupplierName + '%' ORDER BY LEN(SupplierName) DESC"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@desc", description)
                    Dim result = cmd.ExecuteScalar()
                    
                    If result IsNot Nothing Then
                        row("SupplierMatch") = result.ToString()
                        row("SuggestedAccount") = "Accounts Payable"
                        row("AccountCode") = "2100"
                    End If
                End Using
            End Using
        Catch
            ' Ignore errors in supplier matching
        End Try
    End Sub

    Private Sub CheckInvoiceMatch(row As DataRow, description As String)
        Try
            ' Look for invoice number patterns (INV-123, 123456, etc.)
            Dim invoicePattern As String = "(INV[-]?\d+|\b\d{4,8}\b)"
            Dim match As Match = Regex.Match(description, invoicePattern)
            
            If match.Success Then
                Dim invoiceNumber As String = match.Value
                
                Using conn As New SqlConnection(_connectionString)
                    conn.Open()
                    
                    Dim sql As String = "SELECT TOP 1 InvoiceNumber FROM dbo.SupplierInvoices WHERE InvoiceNumber = @inv OR InvoiceNumber LIKE '%' + @inv + '%'"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@inv", invoiceNumber)
                        Dim result = cmd.ExecuteScalar()
                        
                        If result IsNot Nothing Then
                            row("InvoiceMatch") = result.ToString()
                            row("SuggestedAccount") = "Accounts Payable"
                            row("AccountCode") = "2100"
                        End If
                    End Using
                End Using
            End If
        Catch
            ' Ignore errors in invoice matching
        End Try
    End Sub

    Private Sub ApplySpecialRules(row As DataRow, description As String, amount As Decimal)
        ' Bank charges are always expenses
        If description.Contains("BANK") AndAlso description.Contains("CHARGE") Then
            row("SuggestedAccount") = "Bank Charges"
            row("AccountCode") = "6200"
        End If
        
        ' Interest earned
        If description.Contains("INTEREST") AndAlso amount > 0 Then
            row("SuggestedAccount") = "Interest Earned"
            row("AccountCode") = "4200"
        End If
        
        ' EFT payments are likely sales
        If description.Contains("EFT") AndAlso amount > 0 Then
            row("SuggestedAccount") = "Sales Revenue"
            row("AccountCode") = "4000"
        End If
        
        ' Large round amounts might be rent/rates
        If amount < 0 AndAlso (amount Mod 100 = 0) AndAlso Math.Abs(amount) > 1000 Then
            If String.IsNullOrEmpty(row("SupplierMatch").ToString()) Then
                row("SuggestedAccount") = "Rent or Municipal Rates"
                row("AccountCode") = "6100"
            End If
        End If
    End Sub

    Private Function GetAccountCode(accountName As String) As String
        ' Map account names to GL codes
        Dim accountCodes As New Dictionary(Of String, String) From {
            {"Rent Expense", "6100"},
            {"Municipal Rates", "6110"},
            {"Electricity Expense", "6120"},
            {"Water & Sewerage", "6130"},
            {"Telephone Expense", "6140"},
            {"Internet & Communications", "6150"},
            {"Insurance Expense", "6160"},
            {"Fuel & Transport", "6170"},
            {"Bank Charges", "6200"},
            {"Salaries & Wages", "6300"},
            {"Sales Revenue", "4000"},
            {"Interest Earned", "4200"},
            {"Accounts Payable", "2100"},
            {"Inter-Account Transfer", "1200"}
        }
        
        Return If(accountCodes.ContainsKey(accountName), accountCodes(accountName), "9999")
    End Function

    Public Sub SaveMappedTransactions(dt As DataTable, userId As Integer)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using trans As SqlTransaction = conn.BeginTransaction()
                    
                    For Each row As DataRow In dt.Rows
                        ' Insert into BankTransactions table
                        Dim sql As String = "
                            INSERT INTO dbo.BankTransactions 
                            (TransactionDate, Description, Amount, AccountCode, AccountName, SupplierMatch, InvoiceMatch, ImportedBy, ImportedDate)
                            VALUES 
                            (@date, @desc, @amount, @code, @account, @supplier, @invoice, @user, GETDATE())"
                        
                        Using cmd As New SqlCommand(sql, conn, trans)
                            cmd.Parameters.AddWithValue("@date", Convert.ToDateTime(row("TransactionDate")))
                            cmd.Parameters.AddWithValue("@desc", row("Description").ToString())
                            cmd.Parameters.AddWithValue("@amount", Convert.ToDecimal(row("Amount")))
                            cmd.Parameters.AddWithValue("@code", row("AccountCode").ToString())
                            cmd.Parameters.AddWithValue("@account", row("SuggestedAccount").ToString())
                            cmd.Parameters.AddWithValue("@supplier", row("SupplierMatch").ToString())
                            cmd.Parameters.AddWithValue("@invoice", row("InvoiceMatch").ToString())
                            cmd.Parameters.AddWithValue("@user", userId)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' Create journal entries
                        CreateJournalEntries(row, conn, trans, userId)
                    Next
                    
                    trans.Commit()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Error saving mapped transactions: {ex.Message}")
        End Try
    End Sub

    Private Sub CreateJournalEntries(row As DataRow, conn As SqlConnection, trans As SqlTransaction, userId As Integer)
        Dim amount As Decimal = Convert.ToDecimal(row("Amount"))
        Dim accountCode As String = row("AccountCode").ToString()
        Dim description As String = row("Description").ToString()
        Dim transDate As Date = Convert.ToDateTime(row("TransactionDate"))
        
        ' Get account IDs
        Dim bankAccountID As Integer
        Dim expenseAccountID As Integer
        
        Using cmd As New SqlCommand("SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1", conn, trans)
            Dim result = cmd.ExecuteScalar()
            If result Is Nothing Then Throw New Exception("Bank account 1010 not found")
            bankAccountID = Convert.ToInt32(result)
        End Using
        
        Using cmd As New SqlCommand("SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = @code AND IsActive = 1", conn, trans)
            cmd.Parameters.AddWithValue("@code", accountCode)
            Dim result = cmd.ExecuteScalar()
            If result Is Nothing Then Throw New Exception($"Account {accountCode} not found")
            expenseAccountID = Convert.ToInt32(result)
        End Using
        
        ' Get fiscal period
        Dim fiscalPeriodID As Integer
        Using cmd As New SqlCommand("SELECT dbo.fn_GetCurrentFiscalPeriodID(@date)", conn, trans)
            cmd.Parameters.AddWithValue("@date", transDate)
            fiscalPeriodID = Convert.ToInt32(cmd.ExecuteScalar())
        End Using
        
        ' Create journal header
        Dim journalNumber As String = "BANK-" & DateTime.Now.Ticks.ToString().Substring(8)
        Dim journalID As Integer
        
        Using cmd As New SqlCommand("INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy) VALUES (@num, 1, @date, @ref, @desc, @period, 1, @user); SELECT CAST(SCOPE_IDENTITY() AS INT)", conn, trans)
            cmd.Parameters.AddWithValue("@num", journalNumber)
            cmd.Parameters.AddWithValue("@date", transDate)
            cmd.Parameters.AddWithValue("@ref", "Bank Statement")
            cmd.Parameters.AddWithValue("@desc", "Bank: " & description)
            cmd.Parameters.AddWithValue("@period", fiscalPeriodID)
            cmd.Parameters.AddWithValue("@user", userId)
            journalID = Convert.ToInt32(cmd.ExecuteScalar())
        End Using
        
        ' Create journal details based on transaction type
        If amount > 0 Then
            ' Money IN (Credit to bank = Revenue)
            ' DR Bank Account
            Using cmd As New SqlCommand("INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1) VALUES (@jid, 1, @aid, @debit, 0, @desc, @ref)", conn, trans)
                cmd.Parameters.AddWithValue("@jid", journalID)
                cmd.Parameters.AddWithValue("@aid", bankAccountID)
                cmd.Parameters.AddWithValue("@debit", amount)
                cmd.Parameters.AddWithValue("@desc", "Bank receipt")
                cmd.Parameters.AddWithValue("@ref", "Bank Statement")
                cmd.ExecuteNonQuery()
            End Using
            
            ' CR Revenue Account
            Using cmd As New SqlCommand("INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1) VALUES (@jid, 2, @aid, 0, @credit, @desc, @ref)", conn, trans)
                cmd.Parameters.AddWithValue("@jid", journalID)
                cmd.Parameters.AddWithValue("@aid", expenseAccountID)
                cmd.Parameters.AddWithValue("@credit", amount)
                cmd.Parameters.AddWithValue("@desc", description)
                cmd.Parameters.AddWithValue("@ref", "Bank Statement")
                cmd.ExecuteNonQuery()
            End Using
        Else
            ' Money OUT (Debit to bank = Expense)
            Dim absAmount As Decimal = Math.Abs(amount)
            
            ' DR Expense Account
            Using cmd As New SqlCommand("INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1) VALUES (@jid, 1, @aid, @debit, 0, @desc, @ref)", conn, trans)
                cmd.Parameters.AddWithValue("@jid", journalID)
                cmd.Parameters.AddWithValue("@aid", expenseAccountID)
                cmd.Parameters.AddWithValue("@debit", absAmount)
                cmd.Parameters.AddWithValue("@desc", description)
                cmd.Parameters.AddWithValue("@ref", "Bank Statement")
                cmd.ExecuteNonQuery()
            End Using
            
            ' CR Bank Account
            Using cmd As New SqlCommand("INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1) VALUES (@jid, 2, @aid, 0, @credit, @desc, @ref)", conn, trans)
                cmd.Parameters.AddWithValue("@jid", journalID)
                cmd.Parameters.AddWithValue("@aid", bankAccountID)
                cmd.Parameters.AddWithValue("@credit", absAmount)
                cmd.Parameters.AddWithValue("@desc", "Bank payment")
                cmd.Parameters.AddWithValue("@ref", "Bank Statement")
                cmd.ExecuteNonQuery()
            End Using
        End If
    End Sub

End Class
