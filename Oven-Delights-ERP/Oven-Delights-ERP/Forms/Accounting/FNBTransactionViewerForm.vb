Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class FNBTransactionViewerForm
    Private _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Private Sub FNBTransactionViewerForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            dtpFromDate.Value = Date.Today.AddMonths(-1)
            dtpToDate.Value = Date.Today
            cboStatus.SelectedIndex = 0
            LoadPaymentHistory()
        Catch ex As Exception
            MessageBox.Show($"Error initializing form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadPaymentHistory()
        Try
            Dim dt As New DataTable()

            Using conn As New SqlConnection(_connectionString)
                Using cmd As New SqlCommand("sp_FNB_GetPaymentHistory", conn)
                    cmd.CommandType = CommandType.StoredProcedure

                    cmd.Parameters.AddWithValue("@FromDate", dtpFromDate.Value.Date)
                    cmd.Parameters.AddWithValue("@ToDate", dtpToDate.Value.Date)

                    If cboStatus.SelectedIndex > 0 Then
                        cmd.Parameters.AddWithValue("@BatchStatus", cboStatus.SelectedItem.ToString())
                    Else
                        cmd.Parameters.AddWithValue("@BatchStatus", DBNull.Value)
                    End If

                    cmd.Parameters.AddWithValue("@SupplierID", DBNull.Value)
                    cmd.Parameters.AddWithValue("@BranchID", DBNull.Value)

                    conn.Open()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            dgvBatches.DataSource = dt

            If dgvBatches.Columns.Contains("BatchID") Then
                dgvBatches.Columns("BatchID").Width = 60
            End If
            If dgvBatches.Columns.Contains("MessageID") Then
                dgvBatches.Columns("MessageID").Width = 150
            End If
            If dgvBatches.Columns.Contains("InstructionID") Then
                dgvBatches.Columns("InstructionID").Width = 150
            End If
            If dgvBatches.Columns.Contains("BatchStatus") Then
                dgvBatches.Columns("BatchStatus").Width = 80
            End If
            If dgvBatches.Columns.Contains("TotalControlSum") Then
                dgvBatches.Columns("TotalControlSum").DefaultCellStyle.Format = "N2"
                dgvBatches.Columns("TotalControlSum").Width = 100
            End If
            If dgvBatches.Columns.Contains("RequestedExecutionDate") Then
                dgvBatches.Columns("RequestedExecutionDate").DefaultCellStyle.Format = "yyyy-MM-dd"
                dgvBatches.Columns("RequestedExecutionDate").Width = 100
            End If

            lblRecordCount.Text = $"Batches: {dt.Rows.Count}"

        Catch ex As Exception
            MessageBox.Show($"Error loading payment history: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadBatchTransactions(batchId As Integer)
        Try
            Dim dt As New DataTable()

            Using conn As New SqlConnection(_connectionString)
                Using cmd As New SqlCommand("sp_FNB_GetBatchTransactions", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@BatchID", batchId)

                    conn.Open()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            dgvTransactions.DataSource = dt

            If dgvTransactions.Columns.Contains("PaymentTransactionID") Then
                dgvTransactions.Columns("PaymentTransactionID").Width = 60
            End If
            If dgvTransactions.Columns.Contains("EndToEndID") Then
                dgvTransactions.Columns("EndToEndID").Width = 120
            End If
            If dgvTransactions.Columns.Contains("Amount") Then
                dgvTransactions.Columns("Amount").DefaultCellStyle.Format = "N2"
                dgvTransactions.Columns("Amount").Width = 100
            End If
            If dgvTransactions.Columns.Contains("TransactionStatus") Then
                dgvTransactions.Columns("TransactionStatus").Width = 80
            End If
            If dgvTransactions.Columns.Contains("CreditorName") Then
                dgvTransactions.Columns("CreditorName").Width = 150
            End If
            If dgvTransactions.Columns.Contains("RejectionReasonCode") Then
                dgvTransactions.Columns("RejectionReasonCode").HeaderText = "Rejection Code"
                dgvTransactions.Columns("RejectionReasonCode").Width = 100
            End If
            If dgvTransactions.Columns.Contains("RejectionReasonText") Then
                dgvTransactions.Columns("RejectionReasonText").HeaderText = "Rejection Reason"
                dgvTransactions.Columns("RejectionReasonText").Width = 250
                dgvTransactions.Columns("RejectionReasonText").DefaultCellStyle.WrapMode = DataGridViewTriState.True
            End If

            lblTransactionCount.Text = $"Transactions: {dt.Rows.Count}"

        Catch ex As Exception
            MessageBox.Show($"Error loading transactions: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvBatches_SelectionChanged(sender As Object, e As EventArgs) Handles dgvBatches.SelectionChanged
        Try
            If dgvBatches.SelectedRows.Count > 0 Then
                Dim batchId = CInt(dgvBatches.SelectedRows(0).Cells("BatchID").Value)
                LoadBatchTransactions(batchId)
            End If
        Catch ex As Exception
        End Try
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadPaymentHistory()
    End Sub

    Private Sub btnCheckStatus_Click(sender As Object, e As EventArgs) Handles btnCheckStatus.Click
        Try
            If dgvBatches.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a batch to check status.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim batchId = CInt(dgvBatches.SelectedRows(0).Cells("BatchID").Value)
            Dim instructionId = dgvBatches.SelectedRows(0).Cells("InstructionID").Value?.ToString()

            If String.IsNullOrEmpty(instructionId) Then
                MessageBox.Show("This batch has not been submitted yet.", "Not Submitted", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Cursor = Cursors.WaitCursor
            btnCheckStatus.Enabled = False

            Dim paymentService As New FNBPaymentExecutionService(_connectionString, "Sandbox")
            paymentService.CheckPaymentStatuses()

            Cursor = Cursors.Default
            btnCheckStatus.Enabled = True

            MessageBox.Show("Payment status updated successfully.", "Status Updated", MessageBoxButtons.OK, MessageBoxIcon.Information)

            LoadPaymentHistory()
            If dgvBatches.SelectedRows.Count > 0 Then
                LoadBatchTransactions(batchId)
            End If

        Catch ex As Exception
            Cursor = Cursors.Default
            btnCheckStatus.Enabled = True
            MessageBox.Show($"Error checking status: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnViewDetails_Click(sender As Object, e As EventArgs) Handles btnViewDetails.Click
        Try
            If dgvTransactions.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a transaction to view details.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim transactionId = CInt(dgvTransactions.SelectedRows(0).Cells("PaymentTransactionID").Value)
            Dim detailsForm As New FNBTransactionDetailsForm(transactionId)
            detailsForm.ShowDialog()

        Catch ex As Exception
            MessageBox.Show($"Error viewing details: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub cboStatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboStatus.SelectedIndexChanged
        If Me.Visible Then
            LoadPaymentHistory()
        End If
    End Sub

    Private Sub dtpFromDate_ValueChanged(sender As Object, e As EventArgs) Handles dtpFromDate.ValueChanged
        If Me.Visible Then
            LoadPaymentHistory()
        End If
    End Sub

    Private Sub dtpToDate_ValueChanged(sender As Object, e As EventArgs) Handles dtpToDate.ValueChanged
        If Me.Visible Then
            LoadPaymentHistory()
        End If
    End Sub
End Class
