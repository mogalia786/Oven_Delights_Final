Imports System.Net.Http
Imports System.Text
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

Public Class FNBPaymentAPIClient
    Private _connectionString As String
    Private _baseUrl As String
    Private _tokenUrl As String
    Private _clientId As String
    Private _clientSecret As String
    Private _accessToken As String
    Private _tokenExpiry As DateTime
    Private _environment As String

    Public Sub New(connectionString As String, Optional environment As String = "Sandbox")
        _connectionString = connectionString
        _environment = environment
        LoadCredentials()
    End Sub

    Private Sub LoadCredentials()
        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_FNB_GetAPICredentials", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@Environment", _environment)

                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        _clientId = reader("ClientID").ToString()
                        _clientSecret = reader("ClientSecret").ToString()
                        _baseUrl = reader("BaseURL").ToString()
                        _tokenUrl = reader("TokenURL").ToString()
                    Else
                        Throw New Exception($"No active credentials found for environment: {_environment}")
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Function GetAccessToken() As String
        If Not String.IsNullOrEmpty(_accessToken) AndAlso DateTime.Now < _tokenExpiry Then
            Return _accessToken
        End If

        Try
            ' DEBUG: Show credentials being used
            Dim debugInfo As String = $"OAuth Request Debug Info:{Environment.NewLine}" &
                                     $"Token URL: {_tokenUrl}{Environment.NewLine}" &
                                     $"Client ID: {_clientId}{Environment.NewLine}" &
                                     $"Client Secret: {_clientSecret}{Environment.NewLine}" &
                                     $"Secret Length: {_clientSecret.Length} chars{Environment.NewLine}" &
                                     $"Environment: {_environment}"
            
            MessageBox.Show(debugInfo, "FNB OAuth Debug", MessageBoxButtons.OK, MessageBoxIcon.Information)
            
            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(30)

                ' FNB requires Basic Auth header with credentials
                Dim credentials = Convert.ToBase64String(Text.Encoding.ASCII.GetBytes($"{_clientId}:{_clientSecret}"))
                client.DefaultRequestHeaders.Authorization = New Headers.AuthenticationHeaderValue("Basic", credentials)

                ' Only grant_type and scope in body
                Dim content As New FormUrlEncodedContent(New Dictionary(Of String, String) From {
                    {"grant_type", "client_credentials"},
                    {"scope", "i_can"}
                })

                Dim response = client.PostAsync(_tokenUrl, content).Result
                Dim responseBody = response.Content.ReadAsStringAsync().Result

                If response.IsSuccessStatusCode Then
                    Dim tokenResponse = JsonConvert.DeserializeObject(Of TokenResponse)(responseBody)

                    _accessToken = tokenResponse.access_token
                    _tokenExpiry = DateTime.Now.AddSeconds(tokenResponse.expires_in - 60)

                    Return _accessToken
                Else
                    Throw New Exception($"Token request failed: {response.StatusCode} - {responseBody}")
                End If
            End Using
        Catch ex As Exception
            Throw New Exception($"Failed to obtain access token: {ex.Message}", ex)
        End Try
    End Function

    Public Function InitiatePayment(paymentRequest As PaymentInitiationRequest) As PaymentInitiationResponse
        Dim token = GetAccessToken()

        Try
            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(60)
                client.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}")

                Dim json = JsonConvert.SerializeObject(paymentRequest, New JsonSerializerSettings With {
                    .NullValueHandling = NullValueHandling.Ignore,
                    .Formatting = Formatting.None
                })

                Dim content As New StringContent(json, Encoding.UTF8, "application/json")

                Dim response = client.PostAsync($"{_baseUrl}/paymentExecution/initiate/v1", content).Result

                Dim responseJson = response.Content.ReadAsStringAsync().Result

                If response.IsSuccessStatusCode Then
                    Return JsonConvert.DeserializeObject(Of PaymentInitiationResponse)(responseJson)
                Else
                    Dim errorResponse = JsonConvert.DeserializeObject(Of ErrorResponse)(responseJson)
                    Throw New Exception($"Payment initiation failed: {response.StatusCode} - {errorResponse.message}")
                End If
            End Using
        Catch ex As Exception
            Throw New Exception($"Failed to initiate payment: {ex.Message}", ex)
        End Try
    End Function

    Public Function GetPaymentStatus(instructionId As String) As PaymentStatusReport
        Dim token = GetAccessToken()

        Try
            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(30)
                client.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}")

                Dim response = client.GetAsync($"{_baseUrl}/paymentExecution/retrieveReport/v1/{instructionId}").Result

                Dim responseJson = response.Content.ReadAsStringAsync().Result

                If response.IsSuccessStatusCode Then
                    Return JsonConvert.DeserializeObject(Of PaymentStatusReport)(responseJson)
                Else
                    Throw New Exception($"Status retrieval failed: {response.StatusCode} - {responseJson}")
                End If
            End Using
        Catch ex As Exception
            Throw New Exception($"Failed to retrieve payment status: {ex.Message}", ex)
        End Try
    End Function

    Public Function GetUnpaidPayments(filter As UnpaidsFilter) As UnpaidsPaymentStatusReportList
        Dim token = GetAccessToken()

        Try
            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(30)
                client.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}")

                Dim json = JsonConvert.SerializeObject(filter, New JsonSerializerSettings With {
                    .NullValueHandling = NullValueHandling.Ignore
                })

                Dim content As New StringContent(json, Encoding.UTF8, "application/json")

                Dim response = client.PostAsync($"{_baseUrl}/paymentExecution/retrieveFilteredUnpaids/v1", content).Result

                Dim responseJson = response.Content.ReadAsStringAsync().Result

                If response.IsSuccessStatusCode Then
                    Return JsonConvert.DeserializeObject(Of UnpaidsPaymentStatusReportList)(responseJson)
                Else
                    Throw New Exception($"Unpaids retrieval failed: {response.StatusCode} - {responseJson}")
                End If
            End Using
        Catch ex As Exception
            Throw New Exception($"Failed to retrieve unpaid payments: {ex.Message}", ex)
        End Try
    End Function
End Class

Public Class TokenResponse
    Public Property access_token As String
    Public Property token_type As String
    Public Property expires_in As Integer
    Public Property scope As String
End Class

Public Class PaymentInitiationRequest
    Public Property groupHeader As GroupHeader
    Public Property paymentInformation As List(Of PaymentInformation)
End Class

Public Class GroupHeader
    Public Property messageId As String
    Public Property creationDateTime As String
    Public Property initiatingPartyName As String
    Public Property initiatingPartyBIC As String
    Public Property totalNumberOfTransactions As Integer
    Public Property totalControlSum As Decimal
End Class

Public Class PaymentInformation
    Public Property paymentInformationId As String
    Public Property paymentInformationMethod As String
    Public Property batchBooking As Boolean
    Public Property numberOfTransactions As Integer
    Public Property controlSum As Decimal
    Public Property paymentTypeInformationServiceLevelCode As String
    Public Property requestedExecutionDate As String
    Public Property debtor As Debtor
    Public Property debtorAccount As DebtorAccount
    Public Property debtorAgent As DebtorAgent
    Public Property creditTransferTransactionInformation As List(Of CreditTransferTransaction)
End Class

Public Class Debtor
    Public Property name As String
    Public Property bicOrBEI As String
End Class

Public Class DebtorAccount
    Public Property accountNumber As String
    Public Property accountType As String
End Class

Public Class DebtorAgent
    Public Property branchId As String
End Class

Public Class CreditTransferTransaction
    Public Property endToEndId As String
    Public Property amount As Amount
    Public Property creditor As Creditor
    Public Property creditorAccount As CreditorAccount
    Public Property creditorAgent As CreditorAgent
    Public Property remittanceInformationUnstructured As String
    Public Property remittanceLocationMethod As String
    Public Property remittanceLocationElectronicAddress As String
End Class

Public Class Amount
    Public Property currency As String
    Public Property value As Decimal
End Class

Public Class Creditor
    Public Property name As String
    Public Property bicOrBEI As String
End Class

Public Class CreditorAccount
    Public Property accountNumber As String
    Public Property accountType As String
End Class

Public Class CreditorAgent
    Public Property branchId As String
End Class

Public Class PaymentInitiationResponse
    Public Property instructionId As String
    Public Property messageId As String
    Public Property status As String
End Class

Public Class PaymentStatusReport
    Public Property instructionId As String
    Public Property groupStatus As String
    Public Property transactions As List(Of TransactionStatus)
End Class

Public Class TransactionStatus
    Public Property endToEndId As String
    Public Property status As String
    Public Property reasonCode As String
    Public Property reasonText As String
End Class

Public Class UnpaidsFilter
    Public Property fromDate As String
    Public Property toDate As String
    Public Property accountNumber As String
End Class

Public Class UnpaidsPaymentStatusReportList
    Public Property unpaids As List(Of UnpaidTransaction)
End Class

Public Class UnpaidTransaction
    Public Property endToEndId As String
    Public Property amount As Decimal
    Public Property reasonCode As String
    Public Property reasonText As String
End Class

Public Class ErrorResponse
    Public Property code As String
    Public Property message As String
    Public Property details As String
End Class
