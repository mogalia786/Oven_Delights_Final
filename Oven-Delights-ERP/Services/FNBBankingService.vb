Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Net.Http
Imports System.Text
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

''' <summary>
''' FNB Banking Integration Service
''' Handles bank statement downloads, payment submissions, and API communication
''' </summary>
Public Class FNBBankingService
    Private ReadOnly _connectionString As String
    Private ReadOnly _fnbApiBaseUrl As String
    Private ReadOnly _fnbApiKey As String
    Private ReadOnly _fnbClientId As String
    Private ReadOnly _fnbClientSecret As String
    Private _httpClient As HttpClient

    Public Sub New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        ' Load FNB API credentials from database (same as working FNBStatementService)
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Dim cmd As New SqlCommand("SELECT TOP 1 BaseURL, ClientID, ClientSecret FROM FNB_APICredentials WHERE IsActive = 1", conn)
            Using reader = cmd.ExecuteReader()
                If reader.Read() Then
                    _fnbApiBaseUrl = reader("BaseURL").ToString()
                    _fnbClientId = reader("ClientID").ToString()
                    _fnbClientSecret = reader("ClientSecret").ToString()
                Else
                    Throw New Exception("FNB API credentials not configured")
                End If
            End Using
        End Using
        
        _httpClient = New HttpClient()
        _httpClient.Timeout = TimeSpan.FromSeconds(60)
    End Sub

    ''' <summary>
    ''' Get OAuth access token from FNB
    ''' </summary>
    Private Function GetAccessToken() As String
        Try
            Dim tokenUrl = $"{_fnbApiBaseUrl}/oauth2/token/v2"
            
            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(30)
                
                ' Send credentials in body (same as working BankStatementViewerForm)
                Dim content As New FormUrlEncodedContent(New Dictionary(Of String, String) From {
                    {"grant_type", "client_credentials"},
                    {"client_id", _fnbClientId},
                    {"client_secret", _fnbClientSecret}
                })
                
                Dim response = client.PostAsync(tokenUrl, content).Result
                Dim responseBody = response.Content.ReadAsStringAsync().Result
                
                If response.IsSuccessStatusCode Then
                    Dim tokenResponse = JObject.Parse(responseBody)
                    Return tokenResponse("access_token").ToString()
                Else
                    Throw New Exception($"Token request failed: {response.StatusCode} - {responseBody}")
                End If
            End Using
        Catch ex As Exception
            Throw New Exception($"Failed to obtain access token: {ex.Message}", ex)
        End Try
    End Function

    ''' <summary>
    ''' Download bank statement from FNB using working FNBStatementService
    ''' </summary>
    Public Function DownloadBankStatement(bankAccountID As Integer, startDate As Date, endDate As Date, userName As String) As Integer
        Try
            ' Get FNB account details
            Dim accountNumber As String = Nothing
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("SELECT AccountNumber FROM BankAccounts WHERE BankAccountID = @BankAccountID", conn)
                    cmd.Parameters.AddWithValue("@BankAccountID", bankAccountID)
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            accountNumber = reader("AccountNumber").ToString()
                        Else
                            Throw New Exception("Bank account not found")
                        End If
                    End Using
                End Using
            End Using
            
            ' Use the working FNBStatementService
            Dim statementService As New FNBStatementService()
            Dim statement = statementService.FetchStatement(accountNumber, startDate, endDate)
            
            ' Import transactions from statement
            Dim importedCount = statementService.SaveStatementToDatabase(statement, userName)
            
            ' Log the import
            LogStatementImport(bankAccountID, startDate, endDate, importedCount, userName, "FNB API", Nothing)
            
            Return importedCount
            
        Catch ex As Exception
            Throw New Exception($"Error downloading bank statement: {ex.Message}", ex)
        End Try
    End Function

    ''' <summary>
    ''' Import statement transactions from JSON data
    ''' </summary>
    Private Function ImportStatementTransactions(bankAccountID As Integer, statementData As JObject, userName As String) As Integer
        Dim importedCount As Integer = 0
        
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using transaction = conn.BeginTransaction()
                Try
                    Dim transactions = statementData("transactions")
                    
                    For Each txn In transactions
                        Dim transactionDate = CDate(txn("transactionDate"))
                        Dim description = txn("description").ToString()
                        Dim bankReference = txn("reference")?.ToString()
                        Dim debitAmount = CDec(If(txn("debitAmount"), 0))
                        Dim creditAmount = CDec(If(txn("creditAmount"), 0))
                        Dim balance = CDec(If(txn("balance"), 0))
                        Dim transactionType = If(debitAmount > 0, "Debit", "Credit")
                        
                        ' Check if transaction already exists (duplicate prevention)
                        Dim exists As Boolean = False
                        Using checkCmd As New SqlCommand("SELECT COUNT(*) FROM BankStatementTransactions WHERE BankAccountID = @BankAccountID AND TransactionDate = @TransactionDate AND BankReference = @BankReference AND ABS(DebitAmount - @DebitAmount) < 0.01 AND ABS(CreditAmount - @CreditAmount) < 0.01", conn, transaction)
                            checkCmd.Parameters.AddWithValue("@BankAccountID", bankAccountID)
                            checkCmd.Parameters.AddWithValue("@TransactionDate", transactionDate)
                            checkCmd.Parameters.AddWithValue("@BankReference", If(bankReference, DBNull.Value))
                            checkCmd.Parameters.AddWithValue("@DebitAmount", debitAmount)
                            checkCmd.Parameters.AddWithValue("@CreditAmount", creditAmount)
                            exists = CInt(checkCmd.ExecuteScalar()) > 0
                        End Using
                        
                        If Not exists Then
                            ' Insert transaction
                            Using insertCmd As New SqlCommand("INSERT INTO BankStatementTransactions (BankAccountID, TransactionDate, Description, BankReference, DebitAmount, CreditAmount, Balance, TransactionType, Status, ImportedBy, ImportedDate) VALUES (@BankAccountID, @TransactionDate, @Description, @BankReference, @DebitAmount, @CreditAmount, @Balance, @TransactionType, 'Unmatched', @ImportedBy, GETDATE())", conn, transaction)
                                insertCmd.Parameters.AddWithValue("@BankAccountID", bankAccountID)
                                insertCmd.Parameters.AddWithValue("@TransactionDate", transactionDate)
                                insertCmd.Parameters.AddWithValue("@Description", description)
                                insertCmd.Parameters.AddWithValue("@BankReference", If(bankReference, DBNull.Value))
                                insertCmd.Parameters.AddWithValue("@DebitAmount", debitAmount)
                                insertCmd.Parameters.AddWithValue("@CreditAmount", creditAmount)
                                insertCmd.Parameters.AddWithValue("@Balance", balance)
                                insertCmd.Parameters.AddWithValue("@TransactionType", transactionType)
                                insertCmd.Parameters.AddWithValue("@ImportedBy", userName)
                                insertCmd.ExecuteNonQuery()
                                importedCount += 1
                            End Using
                        End If
                    Next
                    
                    transaction.Commit()
                    
                Catch ex As Exception
                    transaction.Rollback()
                    Throw New Exception($"Error importing transactions: {ex.Message}", ex)
                End Try
            End Using
        End Using
        
        Return importedCount
    End Function

    ''' <summary>
    ''' Log statement import
    ''' </summary>
    Private Sub LogStatementImport(bankAccountID As Integer, startDate As Date, endDate As Date, totalTransactions As Integer, userName As String, importSource As String, fileName As String)
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            
            ' Calculate totals
            Dim totalDebits As Decimal = 0
            Dim totalCredits As Decimal = 0
            Dim openingBalance As Decimal = 0
            Dim closingBalance As Decimal = 0
            
            Using cmd As New SqlCommand("SELECT SUM(DebitAmount) AS TotalDebits, SUM(CreditAmount) AS TotalCredits FROM BankStatementTransactions WHERE BankAccountID = @BankAccountID AND TransactionDate BETWEEN @StartDate AND @EndDate", conn)
                cmd.Parameters.AddWithValue("@BankAccountID", bankAccountID)
                cmd.Parameters.AddWithValue("@StartDate", startDate)
                cmd.Parameters.AddWithValue("@EndDate", endDate)
                Using reader = cmd.ExecuteReader()
                    If reader.Read() Then
                        totalDebits = If(IsDBNull(reader("TotalDebits")), 0, CDec(reader("TotalDebits")))
                        totalCredits = If(IsDBNull(reader("TotalCredits")), 0, CDec(reader("TotalCredits")))
                    End If
                End Using
            End Using
            
            ' Get opening and closing balances
            Using cmd As New SqlCommand("SELECT TOP 1 Balance FROM BankStatementTransactions WHERE BankAccountID = @BankAccountID AND TransactionDate >= @StartDate ORDER BY TransactionDate ASC, StatementLineID ASC", conn)
                cmd.Parameters.AddWithValue("@BankAccountID", bankAccountID)
                cmd.Parameters.AddWithValue("@StartDate", startDate)
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing Then openingBalance = CDec(result)
            End Using
            
            Using cmd As New SqlCommand("SELECT TOP 1 Balance FROM BankStatementTransactions WHERE BankAccountID = @BankAccountID AND TransactionDate <= @EndDate ORDER BY TransactionDate DESC, StatementLineID DESC", conn)
                cmd.Parameters.AddWithValue("@BankAccountID", bankAccountID)
                cmd.Parameters.AddWithValue("@EndDate", endDate)
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing Then closingBalance = CDec(result)
            End Using
            
            ' Insert log
            Using cmd As New SqlCommand("INSERT INTO BankStatementImportLog (BankAccountID, ImportedBy, StatementStartDate, StatementEndDate, TotalTransactions, TotalDebits, TotalCredits, OpeningBalance, ClosingBalance, ImportSource, FileName, Status) VALUES (@BankAccountID, @ImportedBy, @StartDate, @EndDate, @TotalTransactions, @TotalDebits, @TotalCredits, @OpeningBalance, @ClosingBalance, @ImportSource, @FileName, 'Completed')", conn)
                cmd.Parameters.AddWithValue("@BankAccountID", bankAccountID)
                cmd.Parameters.AddWithValue("@ImportedBy", userName)
                cmd.Parameters.AddWithValue("@StartDate", startDate)
                cmd.Parameters.AddWithValue("@EndDate", endDate)
                cmd.Parameters.AddWithValue("@TotalTransactions", totalTransactions)
                cmd.Parameters.AddWithValue("@TotalDebits", totalDebits)
                cmd.Parameters.AddWithValue("@TotalCredits", totalCredits)
                cmd.Parameters.AddWithValue("@OpeningBalance", openingBalance)
                cmd.Parameters.AddWithValue("@ClosingBalance", closingBalance)
                cmd.Parameters.AddWithValue("@ImportSource", importSource)
                cmd.Parameters.AddWithValue("@FileName", If(fileName, DBNull.Value))
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' Submit payment batch to FNB
    ''' </summary>
    Public Function SubmitPaymentBatch(batchID As Integer, userName As String) As String
        Try
            ' Get batch details
            Dim batchItems As New List(Of Object)
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Get batch items
                Using cmd As New SqlCommand("SELECT pbi.*, CASE WHEN pbi.PaymentType = 'Supplier' THEN si.TotalAmount ELSE bp.Amount END AS Amount, CASE WHEN pbi.PaymentType = 'Supplier' THEN s.BankName ELSE b.BankName END AS BankName, CASE WHEN pbi.PaymentType = 'Supplier' THEN s.AccountNumber ELSE b.AccountNumber END AS AccountNumber, CASE WHEN pbi.PaymentType = 'Supplier' THEN s.BranchCode ELSE b.BranchCode END AS BranchCode FROM PaymentBatchItems pbi LEFT JOIN SupplierInvoices si ON pbi.PaymentType = 'Supplier' AND pbi.ReferenceID = si.InvoiceID LEFT JOIN Suppliers s ON si.SupplierID = s.SupplierID LEFT JOIN BeneficiaryPayments bp ON pbi.PaymentType = 'Beneficiary' AND pbi.ReferenceID = bp.PaymentID LEFT JOIN Beneficiaries b ON bp.BeneficiaryID = b.BeneficiaryID WHERE pbi.BatchID = @BatchID", conn)
                    cmd.Parameters.AddWithValue("@BatchID", batchID)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            batchItems.Add(New With {
                                .PaymentReference = reader("PaymentReference").ToString(),
                                .RecipientName = reader("RecipientName").ToString(),
                                .BankName = reader("BankName").ToString(),
                                .AccountNumber = reader("AccountNumber").ToString(),
                                .BranchCode = reader("BranchCode").ToString(),
                                .Amount = CDec(reader("Amount"))
                            })
                        End While
                    End Using
                End Using
            End Using
            
            ' Create FNB payment batch request
            Dim paymentRequest = New With {
                .batchReference = $"BATCH-{batchID}",
                .payments = batchItems
            }
            
            Dim jsonRequest = JsonConvert.SerializeObject(paymentRequest)
            Dim content = New StringContent(jsonRequest, Encoding.UTF8, "application/json")
            
            ' Submit to FNB API
            Dim apiUrl = $"{_fnbApiBaseUrl}/payments/batch"
            Dim response = _httpClient.PostAsync(apiUrl, content).Result
            
            If Not response.IsSuccessStatusCode Then
                Throw New Exception($"FNB API Error: {response.StatusCode} - {response.ReasonPhrase}")
            End If
            
            Dim jsonResponse = response.Content.ReadAsStringAsync().Result
            Dim responseData = JObject.Parse(jsonResponse)
            Dim batchReference = responseData("batchReference").ToString()
            
            ' Update batch status
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("UPDATE PaymentBatches SET Status = 'Sent to Bank', SentToBankDate = GETDATE(), BankBatchRef = @BankBatchRef WHERE BatchID = @BatchID", conn)
                    cmd.Parameters.AddWithValue("@BatchID", batchID)
                    cmd.Parameters.AddWithValue("@BankBatchRef", batchReference)
                    cmd.ExecuteNonQuery()
                End Using
                
                ' Update individual payments
                Using cmd As New SqlCommand("UPDATE SupplierInvoices SET Status = 'Sent to Bank', SentToBankDate = GETDATE(), BankTransactionRef = @BankRef WHERE InvoiceID IN (SELECT ReferenceID FROM PaymentBatchItems WHERE BatchID = @BatchID AND PaymentType = 'Supplier')", conn)
                    cmd.Parameters.AddWithValue("@BatchID", batchID)
                    cmd.Parameters.AddWithValue("@BankRef", batchReference)
                    cmd.ExecuteNonQuery()
                End Using
                
                Using cmd As New SqlCommand("UPDATE BeneficiaryPayments SET Status = 'Sent to Bank', SentToBankDate = GETDATE(), BankTransactionRef = @BankRef WHERE PaymentID IN (SELECT ReferenceID FROM PaymentBatchItems WHERE BatchID = @BatchID AND PaymentType = 'Beneficiary')", conn)
                    cmd.Parameters.AddWithValue("@BatchID", batchID)
                    cmd.Parameters.AddWithValue("@BankRef", batchReference)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            
            Return batchReference
            
        Catch ex As Exception
            Throw New Exception($"Error submitting payment batch: {ex.Message}", ex)
        End Try
    End Function

    ''' <summary>
    ''' Import bank statement from CSV file
    ''' </summary>
    Public Function ImportStatementFromCSV(bankAccountID As Integer, filePath As String, userName As String) As Integer
        Dim importedCount As Integer = 0
        
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using transaction = conn.BeginTransaction()
                    Try
                        ' Read CSV file
                        Dim lines = System.IO.File.ReadAllLines(filePath)
                        
                        ' Skip header row
                        For i As Integer = 1 To lines.Length - 1
                            Dim fields = lines(i).Split(","c)
                            
                            If fields.Length >= 5 Then
                                Dim transactionDate = CDate(fields(0).Trim(""""c))
                                Dim description = fields(1).Trim(""""c)
                                Dim bankReference = If(fields.Length > 5, fields(5).Trim(""""c), Nothing)
                                Dim debitAmount = If(String.IsNullOrWhiteSpace(fields(2)), 0, CDec(fields(2).Trim(""""c)))
                                Dim creditAmount = If(String.IsNullOrWhiteSpace(fields(3)), 0, CDec(fields(3).Trim(""""c)))
                                Dim balance = CDec(fields(4).Trim(""""c))
                                Dim transactionType = If(debitAmount > 0, "Debit", "Credit")
                                
                                ' Check for duplicates
                                Dim exists As Boolean = False
                                Using checkCmd As New SqlCommand("SELECT COUNT(*) FROM BankStatementTransactions WHERE BankAccountID = @BankAccountID AND TransactionDate = @TransactionDate AND Description = @Description AND ABS(DebitAmount - @DebitAmount) < 0.01 AND ABS(CreditAmount - @CreditAmount) < 0.01", conn, transaction)
                                    checkCmd.Parameters.AddWithValue("@BankAccountID", bankAccountID)
                                    checkCmd.Parameters.AddWithValue("@TransactionDate", transactionDate)
                                    checkCmd.Parameters.AddWithValue("@Description", description)
                                    checkCmd.Parameters.AddWithValue("@DebitAmount", debitAmount)
                                    checkCmd.Parameters.AddWithValue("@CreditAmount", creditAmount)
                                    exists = CInt(checkCmd.ExecuteScalar()) > 0
                                End Using
                                
                                If Not exists Then
                                    Using insertCmd As New SqlCommand("INSERT INTO BankStatementTransactions (BankAccountID, TransactionDate, Description, BankReference, DebitAmount, CreditAmount, Balance, TransactionType, Status, ImportedBy, ImportedDate) VALUES (@BankAccountID, @TransactionDate, @Description, @BankReference, @DebitAmount, @CreditAmount, @Balance, @TransactionType, 'Unmatched', @ImportedBy, GETDATE())", conn, transaction)
                                        insertCmd.Parameters.AddWithValue("@BankAccountID", bankAccountID)
                                        insertCmd.Parameters.AddWithValue("@TransactionDate", transactionDate)
                                        insertCmd.Parameters.AddWithValue("@Description", description)
                                        insertCmd.Parameters.AddWithValue("@BankReference", If(bankReference, DBNull.Value))
                                        insertCmd.Parameters.AddWithValue("@DebitAmount", debitAmount)
                                        insertCmd.Parameters.AddWithValue("@CreditAmount", creditAmount)
                                        insertCmd.Parameters.AddWithValue("@Balance", balance)
                                        insertCmd.Parameters.AddWithValue("@TransactionType", transactionType)
                                        insertCmd.Parameters.AddWithValue("@ImportedBy", userName)
                                        insertCmd.ExecuteNonQuery()
                                        importedCount += 1
                                    End Using
                                End If
                            End If
                        Next
                        
                        transaction.Commit()
                        
                        ' Log import
                        Dim startDate = CDate(lines(1).Split(","c)(0).Trim(""""c))
                        Dim endDate = CDate(lines(lines.Length - 1).Split(","c)(0).Trim(""""c))
                        LogStatementImport(bankAccountID, startDate, endDate, importedCount, userName, "CSV Upload", filePath)
                        
                    Catch ex As Exception
                        transaction.Rollback()
                        Throw New Exception($"Error importing CSV: {ex.Message}", ex)
                    End Try
                End Using
            End Using
            
        Catch ex As Exception
            Throw New Exception($"Error reading CSV file: {ex.Message}", ex)
        End Try
        
        Return importedCount
    End Function

End Class
