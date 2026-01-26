Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class FNBTransactionDetailsForm
    Private _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private _transactionId As Integer

    Public Sub New(transactionId As Integer)
        InitializeComponent()
        _transactionId = transactionId
    End Sub

    Private Sub FNBTransactionDetailsForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            LoadTransactionDetails()
        Catch ex As Exception
            MessageBox.Show($"Error loading transaction details: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadTransactionDetails()
        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_FNB_GetTransactionDetails", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@PaymentTransactionID", _transactionId)

                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtTransactionID.Text = reader("PaymentTransactionID").ToString()
                        txtEndToEndID.Text = reader("EndToEndID").ToString()
                        txtBatchID.Text = reader("BatchID").ToString()
                        txtMessageID.Text = reader("MessageID").ToString()
                        txtInstructionID.Text = If(reader("InstructionID") Is DBNull.Value, "N/A", reader("InstructionID").ToString())
                        
                        txtCreditorName.Text = reader("CreditorName").ToString()
                        txtCreditorAccount.Text = reader("CreditorAccountNumber").ToString()
                        txtCreditorBranch.Text = reader("CreditorBranchID").ToString()
                        txtAmount.Text = CDec(reader("Amount")).ToString("N2")
                        txtCurrency.Text = reader("Currency").ToString()
                        
                        txtTransactionStatus.Text = reader("TransactionStatus").ToString()
                        txtBatchStatus.Text = reader("BatchStatus").ToString()
                        
                        If reader("RejectionReasonCode") IsNot DBNull.Value Then
                            txtRejectionCode.Text = reader("RejectionReasonCode").ToString()
                            txtRejectionText.Text = reader("RejectionReasonText").ToString()
                        Else
                            txtRejectionCode.Text = "N/A"
                            txtRejectionText.Text = "N/A"
                        End If
                        
                        txtRemittanceRef.Text = reader("RemittanceReference").ToString()
                        txtRemittanceRef20.Text = reader("RemittanceReference20").ToString()
                        
                        If reader("ProofOfPaymentEmail") IsNot DBNull.Value Then
                            txtProofEmail.Text = reader("ProofOfPaymentEmail").ToString()
                        Else
                            txtProofEmail.Text = "N/A"
                        End If
                        
                        txtRequestedDate.Text = CDate(reader("RequestedExecutionDate")).ToString("yyyy-MM-dd")
                        txtCreatedDate.Text = CDate(reader("CreatedDate")).ToString("yyyy-MM-dd HH:mm:ss")
                        
                        If reader("ProcessedDate") IsNot DBNull.Value Then
                            txtProcessedDate.Text = CDate(reader("ProcessedDate")).ToString("yyyy-MM-dd HH:mm:ss")
                        Else
                            txtProcessedDate.Text = "Not processed"
                        End If
                        
                        txtDebtorAccount.Text = reader("DebtorAccountNumber").ToString()
                        
                        If reader("SupplierName") IsNot DBNull.Value Then
                            txtSupplierName.Text = reader("SupplierName").ToString()
                        Else
                            txtSupplierName.Text = "N/A"
                        End If
                        
                        chkIsPosted.Checked = CBool(reader("IsPosted"))
                        If reader("JournalID") IsNot DBNull.Value Then
                            txtJournalID.Text = reader("JournalID").ToString()
                        Else
                            txtJournalID.Text = "N/A"
                        End If
                    End If

                    If reader.NextResult() Then
                        Dim dtHistory As New DataTable()
                        dtHistory.Load(reader)
                        dgvStatusHistory.DataSource = dtHistory
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
