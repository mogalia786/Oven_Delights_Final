Imports System.Net.Http
Imports System.Net.Http.Headers
Imports System.Configuration
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports Microsoft.Data.SqlClient

Public Class FNBStatementService
    Private ReadOnly _baseUrl As String
    Private ReadOnly _clientId As String
    Private ReadOnly _clientSecret As String
    Private ReadOnly _connectionString As String

    Public Event LogMessage(message As String)

    Public Sub New()
        ' Load FNB API credentials from database
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Dim cmd As New SqlCommand("SELECT TOP 1 BaseURL, ClientID, ClientSecret FROM FNB_APICredentials WHERE IsActive = 1", conn)
            Using reader = cmd.ExecuteReader()
                If reader.Read() Then
                    _baseUrl = reader("BaseURL").ToString()
                    _clientId = reader("ClientID").ToString()
                    _clientSecret = reader("ClientSecret").ToString()
                Else
                    Throw New Exception("FNB API credentials not configured")
                End If
            End Using
        End Using
    End Sub

    Private Function GetAccessToken() As String
        Try
            RaiseEvent LogMessage($"Requesting OAuth token from: {_baseUrl}/oauth2/token/v2")
            RaiseEvent LogMessage($"Client ID: {_clientId}")
            
            Using client As New HttpClient()
                Dim tokenUrl = $"{_baseUrl}/oauth2/token/v2"
                
                Dim content As New FormUrlEncodedContent(New Dictionary(Of String, String) From {
                    {"grant_type", "client_credentials"},
                    {"client_id", _clientId},
                    {"client_secret", _clientSecret}
                })

                Dim response = client.PostAsync(tokenUrl, content).Result
                Dim responseJson = response.Content.ReadAsStringAsync().Result

                If response.IsSuccessStatusCode Then
                    Dim tokenData = JObject.Parse(responseJson)
                    Dim token = tokenData("access_token").ToString()
                    RaiseEvent LogMessage($"✓ Token obtained successfully (length: {token.Length})")
                    Return token
                Else
                    RaiseEvent LogMessage($"✗ Token request failed: {response.StatusCode}")
                    Throw New Exception($"Token request failed: {response.StatusCode} - {responseJson}")
                End If
            End Using
        Catch ex As Exception
            RaiseEvent LogMessage($"Error getting access token: {ex.Message}")
            Throw
        End Try
    End Function

    Public Function FetchStatement(accountId As String, fromDate As Date, toDate As Date) As CustomerStatement
        Try
            Dim token = GetAccessToken()
            RaiseEvent LogMessage($"Fetching statement for account {accountId} from {fromDate:yyyy-MM-dd} to {toDate:yyyy-MM-dd}")

            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(180)
                
                Dim requestId = Guid.NewGuid().ToString()
                
                ' Log all request details
                RaiseEvent LogMessage($"=== REQUEST DETAILS ===")
                RaiseEvent LogMessage($"URL: {_baseUrl}/statements/retrieveStatement/v1/")
                RaiseEvent LogMessage($"Method: POST")
                RaiseEvent LogMessage($"X-Request-ID: {requestId}")
                RaiseEvent LogMessage($"Authorization: Bearer {token.Substring(0, Math.Min(20, token.Length))}...")
                RaiseEvent LogMessage($"Content-Type: application/json")
                
                client.DefaultRequestHeaders.Authorization = New AuthenticationHeaderValue("Bearer", token)
                client.DefaultRequestHeaders.Add("X-Request-ID", requestId)
                client.DefaultRequestHeaders.Add("Accept", "application/json")

                ' Use simple YYYY-MM-DD date format as per API spec
                Dim requestBody = New With {
                    .accountId = accountId,
                    .fromDate = fromDate.ToString("yyyy-MM-dd"),
                    .toDate = toDate.ToString("yyyy-MM-dd")
                }

                Dim jsonContent = JsonConvert.SerializeObject(requestBody, Formatting.Indented)
                RaiseEvent LogMessage($"Request Body:{vbCrLf}{jsonContent}")
                
                Dim content As New StringContent(jsonContent, Text.Encoding.UTF8, "application/json")

                Dim url = $"{_baseUrl}/statements/retrieveStatement/v1/"
                RaiseEvent LogMessage($"Sending request...")
                
                Dim response = client.PostAsync(url, content).Result
                Dim responseJson = response.Content.ReadAsStringAsync().Result

                RaiseEvent LogMessage($"=== RESPONSE DETAILS ===")
                RaiseEvent LogMessage($"Status Code: {CInt(response.StatusCode)} {response.StatusCode}")
                RaiseEvent LogMessage($"Reason Phrase: {response.ReasonPhrase}")
                
                ' Log response headers
                If response.Headers IsNot Nothing Then
                    For Each header In response.Headers
                        RaiseEvent LogMessage($"Header: {header.Key} = {String.Join(", ", header.Value)}")
                    Next
                End If
                
                RaiseEvent LogMessage($"Response Body:{vbCrLf}{responseJson}")

                If response.IsSuccessStatusCode Then
                    Dim statement = JsonConvert.DeserializeObject(Of CustomerStatement)(responseJson)
                    Dim entryCount = If(statement?.statement?.entry IsNot Nothing, statement.statement.entry.Count, 0)
                    RaiseEvent LogMessage($"Statement retrieved successfully. Entries: {entryCount}")
                    Return statement
                Else
                    RaiseEvent LogMessage($"Statement retrieval failed: {responseJson}")
                    Throw New Exception($"Statement retrieval failed: {response.StatusCode} - {responseJson}")
                End If
            End Using
        Catch ex As Exception
            RaiseEvent LogMessage($"Error fetching statement: {ex.Message}")
            Throw
        End Try
    End Function

    Public Function SaveStatementToDatabase(statement As CustomerStatement, fetchedBy As String) As Integer
        Dim savedCount As Integer = 0

        Try
            If statement Is Nothing OrElse statement.statement Is Nothing OrElse statement.statement.entry Is Nothing Then
                Return 0
            End If

            Using conn As New SqlConnection(_connectionString)
                conn.Open()

                For Each entry In statement.statement.entry
                    Try
                        Dim cmd As New SqlCommand("sp_AP_SaveStatementTransaction", conn) With {
                            .CommandType = CommandType.StoredProcedure
                        }

                        cmd.Parameters.AddWithValue("@AccountNumber", If(statement.statement.account IsNot Nothing, statement.statement.account.accountNumber, ""))
                        cmd.Parameters.AddWithValue("@TransactionDate", If(entry.bookingDateTime.HasValue, entry.bookingDateTime.Value, Date.Now))
                        cmd.Parameters.AddWithValue("@Amount", entry.amountValue)
                        cmd.Parameters.AddWithValue("@CreditDebitIndicator", If(String.IsNullOrEmpty(entry.creditDebitIndicator), "", entry.creditDebitIndicator))
                        cmd.Parameters.AddWithValue("@Description", If(entry.transactionDetails IsNot Nothing, entry.transactionDetails.referenceEndToEndId, ""))
                        cmd.Parameters.AddWithValue("@Reference", If(String.IsNullOrEmpty(entry.servicerReference), DBNull.Value, entry.servicerReference))
                        cmd.Parameters.AddWithValue("@ServicerReference", If(String.IsNullOrEmpty(entry.servicerReference), DBNull.Value, entry.servicerReference))
                        cmd.Parameters.AddWithValue("@EndToEndID", If(entry.transactionDetails IsNot Nothing, entry.transactionDetails.referenceEndToEndId, DBNull.Value))
                        cmd.Parameters.AddWithValue("@RelatedPartyName", If(entry.transactionDetails IsNot Nothing, entry.transactionDetails.relatedPartyDebitorName, DBNull.Value))
                        cmd.Parameters.AddWithValue("@RawJSON", JsonConvert.SerializeObject(entry))
                        cmd.Parameters.AddWithValue("@FetchedBy", fetchedBy)

                        Dim outputParam As New SqlParameter("@TransactionID", SqlDbType.Int) With {
                            .Direction = ParameterDirection.Output
                        }
                        cmd.Parameters.Add(outputParam)

                        cmd.ExecuteNonQuery()
                        savedCount += 1
                    Catch ex As Exception
                        RaiseEvent LogMessage($"Error saving transaction: {ex.Message}")
                    End Try
                Next
            End Using

            RaiseEvent LogMessage($"Saved {savedCount} transactions to database")
        Catch ex As Exception
            RaiseEvent LogMessage($"Error saving statement to database: {ex.Message}")
            Throw
        End Try

        Return savedCount
    End Function

    Public Function GetUnmappedTransactions() As DataTable
        Dim dt As New DataTable()

        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Dim sql = "SELECT TransactionID, AccountNumber, TransactionDate, Amount, CreditDebitIndicator, " &
                     "Description, Reference, RelatedPartyName, FetchedDate " &
                     "FROM AP_StatementTransactions " &
                     "WHERE MappedCategoryID IS NULL " &
                     "ORDER BY TransactionDate DESC"

            Using cmd As New SqlCommand(sql, conn)
                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using
        End Using

        Return dt
    End Function
End Class

' ===== Data Models =====

Public Class CustomerStatement
    Public Property groupHeader As StatementGroupHeader
    Public Property statement As StatementData
End Class

Public Class StatementGroupHeader
    Public Property messageId As String
    Public Property creationDateTime As String
    Public Property pageNumber As Integer
    Public Property lastPageIndicator As Boolean
End Class

Public Class StatementData
    Public Property statementNumber As Integer
    Public Property sequenceNumber As String
    Public Property creationDateTime As String
    Public Property fromDateTime As String
    Public Property toDateTime As String
    Public Property account As StatementAccount
    Public Property balance As List(Of StatementBalance)
    Public Property entry As List(Of StatementEntry)
End Class

Public Class StatementAccount
    Public Property typeCode As String
    Public Property currency As String
    Public Property name As String
    Public Property accountNumber As String
    Public Property ownerName As String
    Public Property servicer As StatementServicer
End Class

Public Class StatementServicer
    Public Property institutionName As String
    Public Property institutionCountry As String
End Class

Public Class StatementBalance
    Public Property typeCode As String
    Public Property amountValue As Decimal
    Public Property amountCurrency As String
    Public Property creditDebitIndicator As String
    Public Property [date] As String
End Class

Public Class StatementEntry
    Public Property amountValue As Decimal
    Public Property amountCurrency As String
    Public Property creditDebitIndicator As String
    Public Property statusCode As String
    Public Property bookingDateTime As Date?
    Public Property valueDate As Date?
    Public Property servicerReference As String
    Public Property bankTransactionCode As StatementBankTransactionCode
    Public Property transactionDetails As StatementTransactionDetails
End Class

Public Class StatementBankTransactionCode
    Public Property domainCode As String
    Public Property domainFamilyCode As String
    Public Property domainSubFamilyCode As String
End Class

Public Class StatementTransactionDetails
    Public Property referenceEndToEndId As String
    Public Property amountValue As Decimal
    Public Property amountCurrency As String
    Public Property creditDebitIndicator As String
    Public Property relatedPartyDebitorName As String
    Public Property counterValueAmount As StatementCounterValueAmount
End Class

Public Class StatementCounterValueAmount
    Public Property servicerCurrencyExchange As String
    Public Property currencyExchangeRate As String
End Class
