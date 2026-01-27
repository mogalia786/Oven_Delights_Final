Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data
Imports Newtonsoft.Json

Public Class APPaymentService
    Private ReadOnly _connectionString As String
    Private ReadOnly _fnbApiClient As FNBPaymentAPIClient

    Public Event LogMessage(message As String)

    Public Sub New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        _fnbApiClient = New FNBPaymentAPIClient(_connectionString)
    End Sub

    Public Function CreatePaymentBatch(invoiceIds As List(Of Integer), createdBy As String) As Integer
        Dim batchId As Integer = 0

        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("sp_AP_CreatePaymentBatch", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@InvoiceIDs", String.Join(",", invoiceIds))
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)

                Dim outputParam As New SqlParameter("@BatchID", SqlDbType.Int) With {
                    .Direction = ParameterDirection.Output
                }
                cmd.Parameters.Add(outputParam)

                cmd.ExecuteNonQuery()
                batchId = CInt(outputParam.Value)
            End Using
        End Using

        RaiseEvent LogMessage($"Payment batch {batchId} created with {invoiceIds.Count} invoices")
        Return batchId
    End Function

    Public Function SubmitPaymentBatchToFNB(batchId As Integer) As Boolean
        Try
            RaiseEvent LogMessage($"Preparing batch {batchId} for FNB submission...")

            ' Get batch details
            Dim batchData = GetBatchDetails(batchId)
            If batchData Is Nothing Then
                Throw New Exception("Batch not found")
            End If

            ' Build FNB payment request
            Dim paymentRequestJson = BuildFNBPaymentRequest(batchData)

            ' Save request JSON
            UpdateBatchRequestJSON(batchId, paymentRequestJson)

            RaiseEvent LogMessage($"Submitting batch to FNB API...")

            ' Submit to FNB - deserialize JSON to proper object
            Dim paymentRequest = JsonConvert.DeserializeObject(Of PaymentInitiationRequest)(paymentRequestJson)
            Dim response = _fnbApiClient.InitiatePayment(paymentRequest)

            RaiseEvent LogMessage($"✓ Batch submitted successfully")
            RaiseEvent LogMessage($"Instruction ID: {response.instructionId}")
            RaiseEvent LogMessage($"Message ID: {response.messageId}")
            RaiseEvent LogMessage($"Status: {response.status}")

            ' Update batch with FNB response
            UpdateBatchStatus(batchId, "Submitted", response.instructionId, response.messageId, 
                            "Submitted to FNB", JsonConvert.SerializeObject(response))

            ' Update invoices to Processing status
            UpdateInvoicesInBatch(batchId, "Processing", batchId, DateTime.Now)

            Return True
        Catch ex As Exception
            RaiseEvent LogMessage($"✗ Error submitting batch: {ex.Message}")
            UpdateBatchStatus(batchId, "Failed", Nothing, Nothing, ex.Message, Nothing)
            Return False
        End Try
    End Function

    Public Sub CheckPaymentStatus(batchId As Integer)
        Try
            ' Get batch instruction ID
            Dim instructionId As String = Nothing
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim cmd As New SqlCommand("SELECT InstructionID FROM AP_PaymentBatches WHERE BatchID = @BatchID", conn)
                cmd.Parameters.AddWithValue("@BatchID", batchId)
                instructionId = cmd.ExecuteScalar()?.ToString()
            End Using

            If String.IsNullOrEmpty(instructionId) Then
                RaiseEvent LogMessage("No instruction ID found for batch")
                Return
            End If

            RaiseEvent LogMessage($"Checking payment status for instruction {instructionId}...")

            ' Get status from FNB
            Dim statusReport = _fnbApiClient.GetPaymentStatus(instructionId)

            RaiseEvent LogMessage($"Batch Status: {statusReport.groupStatus}")

            ' Update batch status
            Dim batchStatus = If(statusReport.groupStatus = "ACCP", "Completed", "Processing")
            UpdateBatchStatus(batchId, batchStatus, Nothing, Nothing, 
                            $"Status: {statusReport.groupStatus}", JsonConvert.SerializeObject(statusReport))

            ' Update individual transactions
            If statusReport.transactions IsNot Nothing Then
                For Each txn In statusReport.transactions
                    UpdateTransactionStatus(batchId, txn.endToEndId, txn.status, txn.reasonCode, txn.reasonText)
                    RaiseEvent LogMessage($"Transaction {txn.endToEndId}: {txn.status}")
                Next
            End If

            ' If all completed, post to GL
            If batchStatus = "Completed" Then
                PostBatchToGL(batchId)
            End If
        Catch ex As Exception
            RaiseEvent LogMessage($"Error checking payment status: {ex.Message}")
        End Try
    End Sub

    Private Function GetBatchDetails(batchId As Integer) As DataTable
        Dim dt As New DataTable()

        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Dim sql = "SELECT i.InvoiceID, i.InvoiceNumber, i.TotalAmount, i.Description, " &
                     "b.BeneficiaryName, b.BankName, b.BranchCode, b.AccountNumber, b.AccountType, " &
                     "c.CategoryName " &
                     "FROM AP_PaymentBatchItems bi " &
                     "INNER JOIN AP_Invoices i ON bi.InvoiceID = i.InvoiceID " &
                     "INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID " &
                     "INNER JOIN AP_Categories c ON i.CategoryID = c.CategoryID " &
                     "WHERE bi.BatchID = @BatchID"

            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@BatchID", batchId)
                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using
        End Using

        Return dt
    End Function

    Private Function BuildFNBPaymentRequest(batchData As DataTable) As String
        Dim transactions As New List(Of Object)

        For Each row As DataRow In batchData.Rows
            transactions.Add(New With {
                .endToEndId = row("InvoiceNumber").ToString(),
                .amount = New With {
                    .currency = "ZAR",
                    .amount = CDec(row("TotalAmount"))
                },
                .creditor = New With {
                    .name = row("BeneficiaryName").ToString(),
                    .account = New With {
                        .identification = row("AccountNumber").ToString(),
                        .schemeName = "BBAN"
                    }
                },
                .creditorAgent = New With {
                    .identification = row("BranchCode").ToString()
                },
                .remittanceInformation = New With {
                    .unstructured = row("Description").ToString()
                }
            })
        Next

        Dim paymentRequest = New With {
            .groupHeader = New With {
                .messageId = "APB-" & DateTime.Now.ToString("yyyyMMddHHmmss"),
                .creationDateTime = DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss"),
                .numberOfTransactions = transactions.Count,
                .controlSum = batchData.AsEnumerable().Sum(Function(r) CDec(r("TotalAmount")))
            },
            .paymentInformation = New List(Of Object) From {
                New With {
                    .paymentInformationId = "APPI-" & DateTime.Now.ToString("yyyyMMddHHmmss"),
                    .paymentMethod = "TRF",
                    .requestedExecutionDate = DateTime.Now.ToString("yyyy-MM-dd"),
                    .debtor = New With {
                        .name = "Oven Delights"
                    },
                    .debtorAccount = New With {
                        .identification = GetDebtorAccountNumber(),
                        .schemeName = "BBAN"
                    },
                    .creditTransferTransactionInformation = transactions
                }
            }
        }

        Return JsonConvert.SerializeObject(paymentRequest)
    End Function

    Private Function GetDebtorAccountNumber() As String
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Dim cmd As New SqlCommand("SELECT TOP 1 AccountNumber FROM BankAccounts WHERE IsActive = 1 AND AccountNumber LIKE '63%'", conn)
            Dim result = cmd.ExecuteScalar()
            Return If(result IsNot Nothing, result.ToString(), "63001723469")
        End Using
    End Function

    Private Sub UpdateBatchRequestJSON(batchId As Integer, requestJson As String)
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Dim cmd As New SqlCommand("UPDATE AP_PaymentBatches SET FNBRequestJSON = @JSON WHERE BatchID = @BatchID", conn)
            cmd.Parameters.AddWithValue("@BatchID", batchId)
            cmd.Parameters.AddWithValue("@JSON", requestJson)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Sub UpdateBatchStatus(batchId As Integer, status As String, instructionId As String, messageId As String, statusMessage As String, responseJson As String)
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("sp_AP_UpdatePaymentBatchStatus", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@BatchID", batchId)
                cmd.Parameters.AddWithValue("@Status", status)
                cmd.Parameters.AddWithValue("@InstructionID", If(instructionId, DBNull.Value))
                cmd.Parameters.AddWithValue("@MessageID", If(messageId, DBNull.Value))
                cmd.Parameters.AddWithValue("@StatusMessage", If(statusMessage, DBNull.Value))
                cmd.Parameters.AddWithValue("@ResponseJSON", If(responseJson, DBNull.Value))
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub UpdateInvoicesInBatch(batchId As Integer, status As String, paymentBatchId As Integer?, paymentDate As DateTime?)
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Dim sql = "UPDATE i SET i.Status = @Status, i.PaymentBatchID = @PaymentBatchID, i.PaymentDate = @PaymentDate, i.ModifiedDate = GETDATE() " &
                     "FROM AP_Invoices i INNER JOIN AP_PaymentBatchItems bi ON i.InvoiceID = bi.InvoiceID " &
                     "WHERE bi.BatchID = @BatchID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@BatchID", batchId)
                cmd.Parameters.AddWithValue("@Status", status)
                cmd.Parameters.AddWithValue("@PaymentBatchID", If(paymentBatchId, DBNull.Value))
                cmd.Parameters.AddWithValue("@PaymentDate", If(paymentDate, DBNull.Value))
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub UpdateTransactionStatus(batchId As Integer, endToEndId As String, status As String, reasonCode As String, reasonText As String)
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Dim sql = "UPDATE bi SET bi.Status = @Status, bi.StatusMessage = @StatusMessage, " &
                     "bi.RejectionReasonCode = @ReasonCode, bi.RejectionReasonText = @ReasonText " &
                     "FROM AP_PaymentBatchItems bi " &
                     "INNER JOIN AP_Invoices i ON bi.InvoiceID = i.InvoiceID " &
                     "WHERE bi.BatchID = @BatchID AND i.InvoiceNumber = @EndToEndID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@BatchID", batchId)
                cmd.Parameters.AddWithValue("@EndToEndID", endToEndId)
                cmd.Parameters.AddWithValue("@Status", status)
                cmd.Parameters.AddWithValue("@StatusMessage", $"{status} - {reasonText}")
                cmd.Parameters.AddWithValue("@ReasonCode", If(reasonCode, DBNull.Value))
                cmd.Parameters.AddWithValue("@ReasonText", If(reasonText, DBNull.Value))
                cmd.ExecuteNonQuery()
            End Using

            ' Update invoice status if successful
            If status = "ACCP" Then
                Dim sqlInv = "UPDATE i SET i.Status = 'Paid', i.PaymentDate = GETDATE() " &
                            "FROM AP_Invoices i WHERE i.InvoiceNumber = @EndToEndID"
                Using cmdInv As New SqlCommand(sqlInv, conn)
                    cmdInv.Parameters.AddWithValue("@EndToEndID", endToEndId)
                    cmdInv.ExecuteNonQuery()
                End Using
            End If
        End Using
    End Sub

    Private Sub PostBatchToGL(batchId As Integer)
        Try
            RaiseEvent LogMessage($"Posting batch {batchId} to General Ledger...")

            Using conn As New SqlConnection(_connectionString)
                conn.Open()

                ' Get all paid invoices in batch - load into list first
                Dim sql = "SELECT i.InvoiceID, i.TotalAmount, c.GLAccountCode, b.BeneficiaryName, i.Description " &
                         "FROM AP_PaymentBatchItems bi " &
                         "INNER JOIN AP_Invoices i ON bi.InvoiceID = i.InvoiceID " &
                         "INNER JOIN AP_Categories c ON i.CategoryID = c.CategoryID " &
                         "INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID " &
                         "WHERE bi.BatchID = @BatchID AND i.Status = 'Paid'"

                Dim invoices As New List(Of (InvoiceID As Integer, Amount As Decimal, GLAccount As String, Beneficiary As String, Description As String))

                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@BatchID", batchId)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            invoices.Add((
                                CInt(reader("InvoiceID")),
                                CDec(reader("TotalAmount")),
                                reader("GLAccountCode").ToString(),
                                reader("BeneficiaryName").ToString(),
                                reader("Description").ToString()
                            ))
                        End While
                    End Using
                End Using

                ' Now post each invoice to GL
                For Each inv In invoices
                    Using cmdGL As New SqlCommand("sp_AP_PostPaymentToGL", conn)
                        cmdGL.CommandType = CommandType.StoredProcedure
                        cmdGL.Parameters.AddWithValue("@InvoiceID", inv.InvoiceID)
                        cmdGL.Parameters.AddWithValue("@PaymentBatchID", batchId)
                        cmdGL.Parameters.AddWithValue("@PostingDate", DateTime.Today)
                        cmdGL.Parameters.AddWithValue("@CreatedBy", "APPaymentService")
                        cmdGL.ExecuteNonQuery()
                    End Using

                    RaiseEvent LogMessage($"Posted invoice {inv.InvoiceID} to GL: DR {inv.GLAccount} CR 1010 - R{inv.Amount:N2}")
                Next
            End Using

            RaiseEvent LogMessage($"✓ Batch {batchId} posted to GL successfully")
        Catch ex As Exception
            RaiseEvent LogMessage($"Error posting to GL: {ex.Message}")
        End Try
    End Sub
End Class
