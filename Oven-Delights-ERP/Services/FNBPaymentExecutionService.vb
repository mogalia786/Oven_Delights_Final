Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

Public Class FNBPaymentExecutionService
    Private _connectionString As String
    Private _fnbApi As FNBPaymentAPIClient
    Private _testMode As Boolean = False

    ' Event for status logging
    Public Event StatusUpdate(message As String)

    Public Sub New(connectionString As String, Optional environment As String = "Sandbox")
        _connectionString = connectionString
        
        ' Enable test mode if environment is "Test" - bypasses actual FNB API
        If environment.ToUpper() = "TEST" Then
            _testMode = True
        Else
            _fnbApi = New FNBPaymentAPIClient(connectionString, environment)
        End If
    End Sub

    Private Sub LogStatus(message As String)
        RaiseEvent StatusUpdate(message)
    End Sub

    Public Function CreateAndSubmitPaymentBatch(
        paymentLines As List(Of PaymentLineInfo),
        executionDate As Date,
        branchId As Integer,
        createdBy As Integer
    ) As Tuple(Of Boolean, String, Integer?)

        Try
            LogStatus("=== Submitting Batch Payment to FNB API ===")
            
            If paymentLines Is Nothing OrElse paymentLines.Count = 0 Then
                LogStatus("✗✗✗ SUBMISSION FAILED ✗✗✗")
                LogStatus("Message: No payment lines provided")
                Return New Tuple(Of Boolean, String, Integer?)(False, "No payment lines provided", Nothing)
            End If

            Dim totalAmount = paymentLines.Sum(Function(p) p.Amount)
            LogStatus($"Payment Count: {paymentLines.Count}")
            LogStatus($"Total Amount: R{totalAmount:N2}")
            LogStatus($"Execution Date: {executionDate:yyyy-MM-dd}")
            LogStatus($"Environment: Sandbox (QA)")
            LogStatus("")

            Dim validationResult = ValidatePaymentLines(paymentLines)
            If Not validationResult.Item1 Then
                LogStatus("✗✗✗ VALIDATION FAILED ✗✗✗")
                LogStatus($"Message: {validationResult.Item2}")
                Return New Tuple(Of Boolean, String, Integer?)(False, validationResult.Item2, Nothing)
            End If

            Dim messageId = GenerateMessageId()
            Dim batchId As Integer = 0
            Dim instructionId As String = Nothing

            Dim apiRequest = BuildPaymentRequest(messageId, paymentLines, executionDate)
            Dim apiRequestJson = JsonConvert.SerializeObject(apiRequest)

            batchId = CreateBatchRecord(messageId, paymentLines.Count, totalAmount, executionDate, branchId, createdBy, apiRequestJson)
            LogStatus($"Batch ID: {batchId}")
            LogStatus($"Message ID: {messageId}")
            LogStatus("")

            For Each line In paymentLines
                AddTransactionRecord(batchId, line)
            Next

            ' Test Mode: Simulate successful API response
            If _testMode Then
                LogStatus("Waiting for API response (timeout: 60 seconds)...")
                instructionId = $"TEST-{Guid.NewGuid().ToString().Substring(0, 8).ToUpper()}"
                Dim testResponse = New With {
                    .instructionId = instructionId,
                    .status = "ACCP",
                    .message = "TEST MODE - Simulated successful submission"
                }
                UpdateBatchWithInstructionId(batchId, instructionId, "ACCP", JsonConvert.SerializeObject(testResponse))
                LogStatus("✓✓✓ BATCH SUBMITTED SUCCESSFULLY ✓✓✓")
                LogStatus($"Message: [TEST MODE] Payment batch accepted")
                LogStatus($"Instruction ID: {instructionId}")
                LogStatus("--- Full Response ---")
                LogStatus(JsonConvert.SerializeObject(testResponse, Formatting.Indented))
                Return New Tuple(Of Boolean, String, Integer?)(True, $"[TEST MODE] Payment batch submitted successfully. Instruction ID: {instructionId}", batchId)
            End If

            ' Real API call
            LogStatus("Waiting for API response (timeout: 60 seconds)...")
            Dim apiResponse = _fnbApi.InitiatePayment(apiRequest)
            
            instructionId = apiResponse.instructionId
            LogStatus("✓✓✓ BATCH SUBMITTED SUCCESSFULLY ✓✓✓")
            LogStatus($"Message: Payment batch accepted by FNB")
            LogStatus($"Instruction ID: {If(instructionId, "(null)")}")
            LogStatus($"Message ID: {If(apiResponse.messageId, "(null)")}")
            LogStatus($"Status: {If(apiResponse.status, "(null)")}")
            LogStatus("--- Full Response ---")
            LogStatus(JsonConvert.SerializeObject(apiResponse, Formatting.Indented))

            UpdateBatchWithInstructionId(batchId, instructionId, "ACCP", JsonConvert.SerializeObject(apiResponse))

            Return New Tuple(Of Boolean, String, Integer?)(True, $"Payment batch submitted successfully. Instruction ID: {instructionId}", batchId)

        Catch ex As Exception
            Return New Tuple(Of Boolean, String, Integer?)(False, $"Failed to submit payment batch: {ex.Message}", Nothing)
        End Try
    End Function

    Private Function ValidatePaymentLines(paymentLines As List(Of PaymentLineInfo)) As Tuple(Of Boolean, String)
        For Each line In paymentLines
            If String.IsNullOrWhiteSpace(line.CreditorName) Then
                Return New Tuple(Of Boolean, String)(False, "Creditor name is required for all payments")
            End If

            If String.IsNullOrWhiteSpace(line.CreditorAccountNumber) Then
                Return New Tuple(Of Boolean, String)(False, $"Bank account number is required for {line.CreditorName}")
            End If

            If String.IsNullOrWhiteSpace(line.CreditorBranchCode) Then
                Return New Tuple(Of Boolean, String)(False, $"Branch code is required for {line.CreditorName}")
            End If

            If line.Amount <= 0 Then
                Return New Tuple(Of Boolean, String)(False, $"Invalid amount for {line.CreditorName}")
            End If

            If String.IsNullOrWhiteSpace(line.Reference) Then
                Return New Tuple(Of Boolean, String)(False, $"Payment reference is required for {line.CreditorName}")
            End If
        Next

        Return New Tuple(Of Boolean, String)(True, "Validation passed")
    End Function

    Private Function GenerateMessageId() As String
        Return $"OD-{DateTime.Now:yyyyMMddHHmmss}-{Guid.NewGuid().ToString().Substring(0, 8).ToUpper()}"
    End Function

    Private Function BuildPaymentRequest(
        messageId As String,
        paymentLines As List(Of PaymentLineInfo),
        executionDate As Date
    ) As PaymentInitiationRequest

        Dim credentials = GetAPICredentials()

        Dim request As New PaymentInitiationRequest()

        request.groupHeader = New GroupHeader() With {
            .messageId = messageId,
            .creationDateTime = DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss"),
            .initiatingPartyName = "OVEN DELIGHTS PTY LTD",
            .initiatingPartyBIC = "FIRNZAJJ",
            .totalNumberOfTransactions = paymentLines.Count,
            .totalControlSum = paymentLines.Sum(Function(p) p.Amount)
        }

        Dim paymentInfo As New PaymentInformation() With {
            .paymentInformationId = messageId,
            .paymentInformationMethod = "TRF",
            .batchBooking = True,
            .numberOfTransactions = paymentLines.Count,
            .controlSum = paymentLines.Sum(Function(p) p.Amount),
            .paymentTypeInformationServiceLevelCode = "SDVA",
            .requestedExecutionDate = executionDate.ToString("yyyy-MM-dd"),
            .debtor = New Debtor() With {
                .name = "Oven Delights Pty Ltd",
                .bicOrBEI = "FIRNZAJJ"
            },
            .debtorAccount = New DebtorAccount() With {
                .accountNumber = credentials.DebtorAccountNumber,
                .accountType = "CACC"
            },
            .debtorAgent = New DebtorAgent() With {
                .branchId = credentials.DebtorBranchId
            }
        }

        paymentInfo.creditTransferTransactionInformation = New List(Of CreditTransferTransaction)()

        For Each line In paymentLines
            Dim transaction As New CreditTransferTransaction() With {
                .endToEndId = line.Reference,
                .amount = New Amount() With {
                    .currency = "ZAR",
                    .value = line.Amount
                },
                .creditor = New Creditor() With {
                    .name = line.CreditorName,
                    .bicOrBEI = If(String.IsNullOrEmpty(line.CreditorBIC), "FIRNZAJJ", line.CreditorBIC)
                },
                .creditorAccount = New CreditorAccount() With {
                    .accountNumber = line.CreditorAccountNumber,
                    .accountType = If(String.IsNullOrEmpty(line.CreditorAccountType), "CACC", line.CreditorAccountType)
                },
                .creditorAgent = New CreditorAgent() With {
                    .branchId = line.CreditorBranchCode
                },
                .remittanceInformationUnstructured = Left(line.Reference, 20)
            }

            If Not String.IsNullOrEmpty(line.ProofOfPaymentEmail) Then
                transaction.remittanceLocationMethod = "EMAL"
                transaction.remittanceLocationElectronicAddress = line.ProofOfPaymentEmail
            End If

            paymentInfo.creditTransferTransactionInformation.Add(transaction)
        Next

        request.paymentInformation = New List(Of PaymentInformation) From {paymentInfo}

        Return request
    End Function

    Private Function GetAPICredentials() As APICredentialInfo
        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_FNB_GetAPICredentials", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@Environment", "Sandbox")

                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        Return New APICredentialInfo With {
                            .DebtorAccountNumber = reader("DebtorAccountNumber").ToString(),
                            .DebtorBranchId = reader("DebtorBranchID").ToString()
                        }
                    Else
                        Throw New Exception("No API credentials found")
                    End If
                End Using
            End Using
        End Using
    End Function

    Private Function CreateBatchRecord(
        messageId As String,
        transactionCount As Integer,
        totalAmount As Decimal,
        executionDate As Date,
        branchId As Integer,
        createdBy As Integer,
        apiRequestJson As String
    ) As Integer

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_FNB_CreatePaymentBatch", conn)
                cmd.CommandType = CommandType.StoredProcedure

                Dim credentials = GetAPICredentials()

                cmd.Parameters.AddWithValue("@MessageID", messageId)
                cmd.Parameters.AddWithValue("@TotalNumberOfTransactions", transactionCount)
                cmd.Parameters.AddWithValue("@TotalControlSum", totalAmount)
                cmd.Parameters.AddWithValue("@RequestedExecutionDate", executionDate)
                cmd.Parameters.AddWithValue("@ServiceLevelCode", "SDVA")
                cmd.Parameters.AddWithValue("@DebtorAccountNumber", credentials.DebtorAccountNumber)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@APIRequestJSON", If(apiRequestJson, DBNull.Value))

                Dim batchIdParam As New SqlParameter("@BatchID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(batchIdParam)

                conn.Open()
                cmd.ExecuteNonQuery()

                Return CInt(batchIdParam.Value)
            End Using
        End Using
    End Function

    Private Sub AddTransactionRecord(batchId As Integer, line As PaymentLineInfo)
        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_FNB_AddPaymentTransaction", conn)
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.AddWithValue("@BatchID", batchId)
                cmd.Parameters.AddWithValue("@EndToEndID", line.Reference)
                cmd.Parameters.AddWithValue("@Amount", line.Amount)
                cmd.Parameters.AddWithValue("@CreditorName", line.CreditorName)
                cmd.Parameters.AddWithValue("@CreditorAccountNumber", line.CreditorAccountNumber)
                cmd.Parameters.AddWithValue("@CreditorAccountType", If(line.CreditorAccountType, "CACC"))
                cmd.Parameters.AddWithValue("@CreditorBranchID", line.CreditorBranchCode)
                cmd.Parameters.AddWithValue("@CreditorBIC", If(line.CreditorBIC, "FIRNZAJJ"))
                cmd.Parameters.AddWithValue("@RemittanceReference", line.Reference)
                cmd.Parameters.AddWithValue("@ProofOfPaymentEmail", If(line.ProofOfPaymentEmail, DBNull.Value))
                cmd.Parameters.AddWithValue("@SupplierID", If(line.SupplierID, DBNull.Value))
                cmd.Parameters.AddWithValue("@PurchaseInvoiceID", If(line.PurchaseInvoiceID, DBNull.Value))
                cmd.Parameters.AddWithValue("@ExpenseBillID", If(line.ExpenseBillID, DBNull.Value))
                cmd.Parameters.AddWithValue("@PaymentType", If(line.PaymentType, "Supplier"))

                Dim transactionIdParam As New SqlParameter("@PaymentTransactionID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(transactionIdParam)

                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub UpdateBatchWithInstructionId(batchId As Integer, instructionId As String, status As String, responseJson As String)
        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_FNB_UpdateBatchStatus", conn)
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.AddWithValue("@BatchID", batchId)
                cmd.Parameters.AddWithValue("@InstructionID", instructionId)
                cmd.Parameters.AddWithValue("@BatchStatus", status)
                cmd.Parameters.AddWithValue("@RejectionReason", DBNull.Value)
                cmd.Parameters.AddWithValue("@APIResponseJSON", If(responseJson, DBNull.Value))
                cmd.Parameters.AddWithValue("@CheckedBy", DBNull.Value)

                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Sub CheckPaymentStatuses()
        Dim pendingBatches = GetPendingBatches()

        For Each batch In pendingBatches
            Try
                Dim statusReport = _fnbApi.GetPaymentStatus(batch.InstructionID)

                UpdateBatchStatus(batch.BatchID, statusReport.groupStatus)

                If statusReport.transactions IsNot Nothing Then
                    For Each txn In statusReport.transactions
                        UpdateTransactionStatus(batch.BatchID, txn.endToEndId, txn.status, txn.reasonCode, txn.reasonText)
                    Next
                End If

            Catch ex As Exception
                Console.WriteLine($"Failed to check status for batch {batch.BatchID}: {ex.Message}")
            End Try
        Next
    End Sub

    Private Function GetPendingBatches() As List(Of PendingBatchInfo)
        Dim batches As New List(Of PendingBatchInfo)()

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_FNB_GetPendingBatches", conn)
                cmd.CommandType = CommandType.StoredProcedure

                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        batches.Add(New PendingBatchInfo With {
                            .BatchID = CInt(reader("BatchID")),
                            .InstructionID = reader("InstructionID").ToString()
                        })
                    End While
                End Using
            End Using
        End Using

        Return batches
    End Function

    Private Sub UpdateBatchStatus(batchId As Integer, status As String)
        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_FNB_UpdateBatchStatus", conn)
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.AddWithValue("@BatchID", batchId)
                cmd.Parameters.AddWithValue("@InstructionID", DBNull.Value)
                cmd.Parameters.AddWithValue("@BatchStatus", status)
                cmd.Parameters.AddWithValue("@RejectionReason", DBNull.Value)
                cmd.Parameters.AddWithValue("@APIResponseJSON", DBNull.Value)
                cmd.Parameters.AddWithValue("@CheckedBy", DBNull.Value)

                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub UpdateTransactionStatus(batchId As Integer, endToEndId As String, status As String, reasonCode As String, reasonText As String)
        Dim transactionId = GetTransactionIdByEndToEndId(batchId, endToEndId)

        If transactionId.HasValue Then
            Using conn As New SqlConnection(_connectionString)
                Using cmd As New SqlCommand("sp_FNB_UpdateTransactionStatus", conn)
                    cmd.CommandType = CommandType.StoredProcedure

                    cmd.Parameters.AddWithValue("@PaymentTransactionID", transactionId.Value)
                    cmd.Parameters.AddWithValue("@TransactionStatus", status)
                    cmd.Parameters.AddWithValue("@RejectionReasonCode", If(reasonCode, DBNull.Value))
                    cmd.Parameters.AddWithValue("@RejectionReasonText", If(reasonText, DBNull.Value))
                    cmd.Parameters.AddWithValue("@CheckedBy", DBNull.Value)

                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        End If
    End Sub

    Private Function GetTransactionIdByEndToEndId(batchId As Integer, endToEndId As String) As Integer?
        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("SELECT PaymentTransactionID FROM FNB_PaymentTransactions WHERE BatchID = @BatchID AND EndToEndID = @EndToEndID", conn)
                cmd.Parameters.AddWithValue("@BatchID", batchId)
                cmd.Parameters.AddWithValue("@EndToEndID", endToEndId)

                conn.Open()
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    Return CInt(result)
                End If
            End Using
        End Using

        Return Nothing
    End Function
End Class

Public Class PaymentLineInfo
    Public Property SupplierID As Integer?
    Public Property PurchaseInvoiceID As Integer?
    Public Property ExpenseBillID As Integer?
    Public Property PaymentType As String
    Public Property CreditorName As String
    Public Property CreditorAccountNumber As String
    Public Property CreditorAccountType As String
    Public Property CreditorBranchCode As String
    Public Property CreditorBIC As String
    Public Property Amount As Decimal
    Public Property Reference As String
    Public Property ProofOfPaymentEmail As String
End Class

Public Class APICredentialInfo
    Public Property DebtorAccountNumber As String
    Public Property DebtorBranchId As String
End Class

Public Class PendingBatchInfo
    Public Property BatchID As Integer
    Public Property InstructionID As String
End Class
