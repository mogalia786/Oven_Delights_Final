Imports System.Net.Http
Imports System.Text
Imports Newtonsoft.Json
Imports System.Threading.Tasks

Public Class FNBTerminalTestService
    Private ReadOnly apiBaseUrl As String = "https://test.figment.co.za:49410/api/"
    Private ReadOnly clientId As String = "MP7BQIe0TMxgxzhpGghkNF303zhmYnjA"
    Private ReadOnly clientSecret As String = "Tf3ac4dLR9DGmBfwipmjy6tjUmLv6tma"
    Private ReadOnly siteId As String = "UT02"
    Private posIdentifier As Integer = 10

    Private currentToken As String
    Private tokenExpiry As DateTime

    Public Sub SetTerminalId(terminalId As Integer)
        posIdentifier = terminalId
    End Sub

    Public Class TokenResponse
        Public Property access_token As String
        Public Property token_type As String
        Public Property expires_in As Integer
    End Class

    Public Class ProductItem
        Public Property itemId As Integer
        Public Property category As Integer
        Public Property amount As Integer
        Public Property barCode As String
        Public Property description As String
        Public Property quantity As Integer
        Public Property unitPrice As Integer
        Public Property rebate As Integer
    End Class

    Public Class TransactionRequest
        Public Property siteId As String
        Public Property requestType As String
        Public Property reconIndicator As String
        Public Property posIdentifier As Integer
        Public Property posVersion As String
        Public Property totalAmount As Integer
        Public Property operatorId As Integer
        Public Property operatorName As String
        Public Property shiftNo As Integer
        Public Property slipNo As Integer
        Public Property supervisor As String()
        Public Property cashBackAmount As Integer
        Public Property budgetPeriod As Integer
        Public Property productItems As List(Of ProductItem)
    End Class

    Public Class TransactionDetail
        Public Property [date] As String
        Public Property pan As String
        Public Property expiry As String
        Public Property cardType As String
        Public Property sequence As String
        Public Property batch As String
        Public Property approvalCode As String
        Public Property uti As String
    End Class

    Public Class MerchantInfo
        Public Property number As String
        Public Property terminalId As String
        Public Property name As String
    End Class

    Public Class TransactionResponse
        Public Property resultCode As String
        Public Property resultSubCode As String
        Public Property posIdentifier As Integer
        Public Property reconIndicator As String
        Public Property totalAmount As Integer
        Public Property transactions As List(Of TransactionDetail)
        Public Property merchant As MerchantInfo
    End Class

    Public Class TestResult
        Public Property Success As Boolean
        Public Property Message As String
        Public Property ResultCode As String
        Public Property ApprovalCode As String
        Public Property CardType As String
        Public Property MaskedPAN As String
        Public Property TransactionUTI As String
        Public Property MerchantNumber As String
        Public Property TerminalId As String
        Public Property RawResponse As String
    End Class

    Public Async Function GetValidToken() As Task(Of String)
        Try
            If String.IsNullOrEmpty(currentToken) OrElse DateTime.Now >= tokenExpiry.AddMinutes(-5) Then
                Await RefreshToken()
            End If
            Return currentToken
        Catch ex As Exception
            Throw New Exception($"Token validation failed: {ex.Message}")
        End Try
    End Function

    Private Async Function RefreshToken() As Task
        Try
            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(30)

                Dim request = New With {
                    .client_id = clientId,
                    .client_secret = clientSecret
                }

                Dim json = JsonConvert.SerializeObject(request)
                Dim content = New StringContent(json, Encoding.UTF8, "application/json")

                Dim response = Await client.PostAsync($"{apiBaseUrl}oauth2/token", content)
                Dim responseJson = Await response.Content.ReadAsStringAsync()

                If response.IsSuccessStatusCode Then
                    Dim tokenResponse = JsonConvert.DeserializeObject(Of TokenResponse)(responseJson)
                    currentToken = tokenResponse.access_token
                    tokenExpiry = DateTime.Now.AddSeconds(tokenResponse.expires_in)
                Else
                    Throw New Exception($"Token request failed: HTTP {response.StatusCode} - {responseJson}")
                End If
            End Using
        Catch ex As Exception
            Throw New Exception($"Token refresh failed: {ex.Message}")
        End Try
    End Function

    Public Async Function TestAPIStatus() As Task(Of TestResult)
        Try
            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(10)
                
                ' Test OAuth token endpoint instead of status endpoint
                Dim token = Await GetValidToken()
                
                Return New TestResult With {
                    .Success = True,
                    .Message = "API is online and OAuth token obtained successfully",
                    .RawResponse = $"Token obtained: {token.Substring(0, Math.Min(20, token.Length))}..."
                }
            End Using
        Catch ex As Exception
            Return New TestResult With {
                .Success = False,
                .Message = $"API connection failed: {ex.Message}",
                .RawResponse = ex.ToString()
            }
        End Try
    End Function

    Public Async Function ProcessTestTransaction(
        amount As Decimal,
        operatorName As String,
        Optional operatorId As Integer = 1,
        Optional slipNo As Integer = 1,
        Optional requestType As String = "Settlement",
        Optional logCallback As Action(Of String) = Nothing
    ) As Task(Of TestResult)

        Try
            logCallback?.Invoke("🔌 Connecting to FNB API...")
            logCallback?.Invoke($"   Endpoint: {apiBaseUrl}")
            
            Dim token = Await GetValidToken()
            logCallback?.Invoke("✓ Connected to FNB API - OAuth token obtained")

            ' Generate Recon Indicator - max 7 characters, never starts with 0 (FNB requirement)
            Dim timestamp As Long = DateTimeOffset.Now.ToUnixTimeMilliseconds()
            Dim reconIndicator As String = (timestamp Mod 10000000).ToString().PadLeft(7, "1"c)
            Dim totalAmountCents As Integer = CInt(amount * 100)

            Dim productItems As New List(Of ProductItem) From {
                New ProductItem With {
                    .itemId = 1,
                    .category = 255,
                    .amount = totalAmountCents,
                    .barCode = "TEST001",
                    .description = "Oven Delights",
                    .quantity = 1,
                    .unitPrice = totalAmountCents,
                    .rebate = 0
                }
            }

            Dim supervisorCode As String = If(requestType = "Refund", "R", "S")
            
            Dim request = New TransactionRequest With {
                .siteId = siteId,
                .requestType = requestType,
                .reconIndicator = reconIndicator,
                .posIdentifier = posIdentifier,
                .posVersion = "1.8.5.3",
                .totalAmount = totalAmountCents,
                .operatorId = operatorId,
                .operatorName = operatorName,
                .shiftNo = 1,
                .slipNo = slipNo,
                .supervisor = New String() {supervisorCode},
                .cashBackAmount = 0,
                .budgetPeriod = 0,
                .productItems = productItems
            }

            logCallback?.Invoke("")
            logCallback?.Invoke($"📡 Connecting to POS Terminal {posIdentifier} for {requestType}...")
            logCallback?.Invoke("--- Request Details ---")
            logCallback?.Invoke($"   Site ID: {siteId}")
            logCallback?.Invoke($"   Terminal: {posIdentifier}")
            logCallback?.Invoke($"   Request Type: {requestType}")
            logCallback?.Invoke($"   Amount: R{amount:F2} ({totalAmountCents} cents)")
            logCallback?.Invoke($"   Recon Indicator: {reconIndicator}")
            logCallback?.Invoke($"   Operator: {operatorName} (ID: {operatorId})")
            logCallback?.Invoke($"   Slip No: {slipNo}")
            logCallback?.Invoke("")
            logCallback?.Invoke("⏳ Awaiting terminal connection...")

            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(180)
                client.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}")

                Dim json = JsonConvert.SerializeObject(request)
                Dim content = New StringContent(json, Encoding.UTF8, "application/json")

                Dim response = Await client.PostAsync($"{apiBaseUrl}transactions/transaction", content)
                
                logCallback?.Invoke("✓ Connected to terminal - Processing transaction...")
                logCallback?.Invoke("⏳ Waiting for card tap/insert and customer action...")
                
                Dim responseJson = Await response.Content.ReadAsStringAsync()
                
                logCallback?.Invoke("")
                logCallback?.Invoke("📨 Terminal Response Received")

                If response.IsSuccessStatusCode Then
                    Dim transResponse = JsonConvert.DeserializeObject(Of TransactionResponse)(responseJson)

                    If transResponse.resultCode = "0000" Then
                        Dim trans = transResponse.transactions?.FirstOrDefault()
                        Return New TestResult With {
                            .Success = True,
                            .Message = "Transaction APPROVED",
                            .ResultCode = transResponse.resultCode,
                            .ApprovalCode = trans?.approvalCode,
                            .CardType = trans?.cardType,
                            .MaskedPAN = trans?.pan,
                            .TransactionUTI = trans?.uti,
                            .MerchantNumber = transResponse.merchant?.number,
                            .TerminalId = transResponse.merchant?.terminalId,
                            .RawResponse = responseJson
                        }
                    Else
                        Return New TestResult With {
                            .Success = False,
                            .Message = $"Transaction DECLINED - Result Code: {transResponse.resultCode}",
                            .ResultCode = transResponse.resultCode,
                            .RawResponse = responseJson
                        }
                    End If
                ElseIf response.StatusCode = 202 Then
                    Return New TestResult With {
                        .Success = False,
                        .Message = "Transaction IN PROGRESS - Waiting for cashier action",
                        .ResultCode = "3015",
                        .RawResponse = responseJson
                    }
                ElseIf response.StatusCode = 402 Then
                    Return New TestResult With {
                        .Success = False,
                        .Message = "Transaction DECLINED by terminal",
                        .ResultCode = "1000",
                        .RawResponse = responseJson
                    }
                ElseIf response.StatusCode = 409 Then
                    ' HTTP 409 Conflict - Usually means duplicate transaction or terminal busy
                    Return New TestResult With {
                        .Success = False,
                        .Message = "Transaction CONFLICT - Terminal may be busy or duplicate transaction detected",
                        .ResultCode = "CONFLICT",
                        .RawResponse = $"HTTP 409 Conflict{vbCrLf}{responseJson}{vbCrLf}{vbCrLf}Possible causes:{vbCrLf}1. Terminal is processing another transaction{vbCrLf}2. Duplicate Recon Indicator{vbCrLf}3. Terminal not responding (timeout){vbCrLf}4. Terminal not connected to network{vbCrLf}{vbCrLf}Wait 30 seconds and try again with a different transaction."
                    }
                Else
                    Return New TestResult With {
                        .Success = False,
                        .Message = $"Transaction failed: HTTP {response.StatusCode}",
                        .RawResponse = $"HTTP {response.StatusCode}{vbCrLf}{responseJson}"
                    }
                End If
            End Using

        Catch timeoutEx As TaskCanceledException
            Return New TestResult With {
                .Success = False,
                .Message = "Transaction timed out - Terminal may still be processing. Use Check Status to verify.",
                .ResultCode = "TIMEOUT",
                .RawResponse = $"Request timed out after 180 seconds.{vbCrLf}This usually means:{vbCrLf}1. Terminal is not connected/powered on{vbCrLf}2. Network connectivity issue{vbCrLf}3. Terminal is waiting for card insertion{vbCrLf}{vbCrLf}Exception: {timeoutEx.ToString()}"
            }
        Catch httpEx As HttpRequestException
            Return New TestResult With {
                .Success = False,
                .Message = $"HTTP Connection error: {httpEx.Message}",
                .ResultCode = "HTTP_ERROR",
                .RawResponse = $"Failed to connect to FNB API.{vbCrLf}Check:{vbCrLf}1. Internet connection{vbCrLf}2. Firewall settings{vbCrLf}3. API endpoint URL{vbCrLf}{vbCrLf}Exception: {httpEx.ToString()}"
            }
        Catch ex As Exception
            Return New TestResult With {
                .Success = False,
                .Message = $"Communication error: {ex.Message}",
                .RawResponse = ex.ToString()
            }
        End Try
    End Function

    Public Async Function GetTransactionStatus(reconIndicator As String) As Task(Of TestResult)
        Try
            Dim token = Await GetValidToken()

            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(30)
                client.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}")
                client.DefaultRequestHeaders.Add("apiKey", "Q7w30FOnntfiLzJuKKJrKqVqXg9BHPCq")

                Dim response = Await client.GetAsync($"{apiBaseUrl}transactions/status?reconIndicator={reconIndicator}")
                Dim responseJson = Await response.Content.ReadAsStringAsync()

                Return New TestResult With {
                    .Success = response.IsSuccessStatusCode,
                    .Message = If(response.IsSuccessStatusCode, "Status retrieved successfully", "Status check failed"),
                    .RawResponse = responseJson
                }
            End Using
        Catch ex As Exception
            Return New TestResult With {
                .Success = False,
                .Message = $"Status check error: {ex.Message}",
                .RawResponse = ex.ToString()
            }
        End Try
    End Function

    Public Async Function CancelTransaction(reconIndicator As String) As Task(Of TestResult)
        Try
            Dim token = Await GetValidToken()

            Using client As New HttpClient()
                client.Timeout = TimeSpan.FromSeconds(30)
                client.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}")
                client.DefaultRequestHeaders.Add("apiKey", "Q7w30FOnntfiLzJuKKJrKqVqXg9BHPCq")

                Dim response = Await client.DeleteAsync($"{apiBaseUrl}transactions/cancel?reconIndicator={reconIndicator}")
                Dim responseJson = Await response.Content.ReadAsStringAsync()

                Return New TestResult With {
                    .Success = response.IsSuccessStatusCode,
                    .Message = If(response.IsSuccessStatusCode, "Transaction cancelled successfully", "Cancellation failed"),
                    .RawResponse = responseJson
                }
            End Using
        Catch ex As Exception
            Return New TestResult With {
                .Success = False,
                .Message = $"Cancellation error: {ex.Message}",
                .RawResponse = ex.ToString()
            }
        End Try
    End Function
End Class
