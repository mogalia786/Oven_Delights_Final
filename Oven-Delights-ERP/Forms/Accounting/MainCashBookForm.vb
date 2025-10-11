Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms

Namespace Accounting
    Partial Public Class MainCashBookForm
        Inherits Form

        Private ReadOnly _connString As String
        Private _currentCashBookID As Integer
        Private _currentBranchID As Integer
        Private _openingBalance As Decimal = 0
        Private _isReconciled As Boolean = False

        Public Sub New()
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            _currentBranchID = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
            
            Me.Text = "Main Cash Book"
            Me.WindowState = FormWindowState.Maximized
            
            LoadCashBooks()
            dtpDate.Value = DateTime.Today
        End Sub

        Private Sub LoadCashBooks()
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim sql = "SELECT CashBookID, CashBookName, CurrentBalance FROM CashBooks WHERE BranchID = @bid AND CashBookType = 'Main' AND IsActive = 1"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@bid", _currentBranchID)
                        Using reader = cmd.ExecuteReader()
                            cboCashBook.Items.Clear()
                            While reader.Read()
                                Dim item As New CashBookItem With {
                                    .CashBookID = reader.GetInt32(0),
                                    .CashBookName = reader.GetString(1),
                                    .CurrentBalance = reader.GetDecimal(2)
                                }
                                cboCashBook.Items.Add(item)
                            End While
                        End Using
                    End Using
                    
                    cboCashBook.DisplayMember = "CashBookName"
                    If cboCashBook.Items.Count > 0 Then
                        cboCashBook.SelectedIndex = 0
                    End If
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading cash books: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub cboCashBook_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboCashBook.SelectedIndexChanged
            Dim item = TryCast(cboCashBook.SelectedItem, CashBookItem)
            If item IsNot Nothing Then
                _currentCashBookID = item.CashBookID
                LoadOpeningBalance()
                LoadTransactions()
                CalculateTotals()
            End If
        End Sub

        Private Sub LoadOpeningBalance()
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    ' Check if already reconciled today
                    Dim sql = "SELECT OpeningBalance, IsApproved FROM CashBookReconciliation WHERE CashBookID = @cbid AND ReconciliationDate = @date"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@cbid", _currentCashBookID)
                        cmd.Parameters.AddWithValue("@date", dtpDate.Value.Date)
                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                _openingBalance = reader.GetDecimal(0)
                                _isReconciled = reader.GetBoolean(1)
                                lblOpeningBalance.Text = $"Opening Balance: R {_openingBalance:N2}"
                                If _isReconciled Then
                                    lblStatus.Text = "Status: ✅ Reconciled"
                                    lblStatus.ForeColor = Color.Green
                                    btnReconcile.Enabled = False
                                Else
                                    lblStatus.Text = "Status: ⏰ Pending Reconciliation"
                                    lblStatus.ForeColor = Color.Orange
                                    btnReconcile.Enabled = True
                                End If
                                Return
                            End If
                        End Using
                    End Using
                    
                    ' Get previous day's closing or current balance
                    sql = "SELECT TOP 1 ActualCount FROM CashBookReconciliation WHERE CashBookID = @cbid AND ReconciliationDate < @date ORDER BY ReconciliationDate DESC"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@cbid", _currentCashBookID)
                        cmd.Parameters.AddWithValue("@date", dtpDate.Value.Date)
                        Dim result = cmd.ExecuteScalar()
                        If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                            _openingBalance = Convert.ToDecimal(result)
                        Else
                            ' Use current balance from CashBooks
                            Dim item = TryCast(cboCashBook.SelectedItem, CashBookItem)
                            If item IsNot Nothing Then
                                _openingBalance = item.CurrentBalance
                            End If
                        End If
                    End Using
                    
                    lblOpeningBalance.Text = $"Opening Balance: R {_openingBalance:N2}"
                    lblStatus.Text = "Status: 🔓 Open"
                    lblStatus.ForeColor = Color.Blue
                    btnReconcile.Enabled = True
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading opening balance: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadTransactions()
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    
                    ' Load Receipts
                    Dim sqlReceipts = "SELECT TransactionID, CONVERT(VARCHAR(5), CreatedDate, 108) AS Time, ReferenceNumber, Payee, Amount, IsVoid FROM CashBookTransactions WHERE CashBookID = @cbid AND TransactionDate = @date AND TransactionType = 'Receipt' ORDER BY CreatedDate"
                    Using da As New SqlDataAdapter(sqlReceipts, conn)
                        da.SelectCommand.Parameters.AddWithValue("@cbid", _currentCashBookID)
                        da.SelectCommand.Parameters.AddWithValue("@date", dtpDate.Value.Date)
                        Dim dtReceipts As New DataTable()
                        da.Fill(dtReceipts)
                        dgvReceipts.DataSource = dtReceipts
                        FormatReceiptsGrid()
                    End Using
                    
                    ' Load Payments
                    Dim sqlPayments = "SELECT TransactionID, CONVERT(VARCHAR(5), CreatedDate, 108) AS Time, ReferenceNumber, Payee, Amount, IsVoid FROM CashBookTransactions WHERE CashBookID = @cbid AND TransactionDate = @date AND TransactionType = 'Payment' ORDER BY CreatedDate"
                    Using da As New SqlDataAdapter(sqlPayments, conn)
                        da.SelectCommand.Parameters.AddWithValue("@cbid", _currentCashBookID)
                        da.SelectCommand.Parameters.AddWithValue("@date", dtpDate.Value.Date)
                        Dim dtPayments As New DataTable()
                        da.Fill(dtPayments)
                        dgvPayments.DataSource = dtPayments
                        FormatPaymentsGrid()
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading transactions: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub FormatReceiptsGrid()
            If dgvReceipts.Columns.Count = 0 Then Return
            
            dgvReceipts.Columns("TransactionID").Visible = False
            dgvReceipts.Columns("Time").Width = 60
            dgvReceipts.Columns("ReferenceNumber").HeaderText = "Ref#"
            dgvReceipts.Columns("ReferenceNumber").Width = 100
            dgvReceipts.Columns("Payee").HeaderText = "From"
            dgvReceipts.Columns("Payee").Width = 200
            dgvReceipts.Columns("Amount").DefaultCellStyle.Format = "N2"
            dgvReceipts.Columns("Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            dgvReceipts.Columns("Amount").Width = 100
            dgvReceipts.Columns("IsVoid").Visible = False
            
            ' Highlight voided rows
            For Each row As DataGridViewRow In dgvReceipts.Rows
                If Not row.IsNewRow AndAlso Convert.ToBoolean(row.Cells("IsVoid").Value) Then
                    row.DefaultCellStyle.BackColor = Color.LightCoral
                    row.DefaultCellStyle.ForeColor = Color.Gray
                End If
            Next
        End Sub

        Private Sub FormatPaymentsGrid()
            If dgvPayments.Columns.Count = 0 Then Return
            
            dgvPayments.Columns("TransactionID").Visible = False
            dgvPayments.Columns("Time").Width = 60
            dgvPayments.Columns("ReferenceNumber").HeaderText = "Ref#"
            dgvPayments.Columns("ReferenceNumber").Width = 100
            dgvPayments.Columns("Payee").HeaderText = "To"
            dgvPayments.Columns("Payee").Width = 200
            dgvPayments.Columns("Amount").DefaultCellStyle.Format = "N2"
            dgvPayments.Columns("Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            dgvPayments.Columns("Amount").Width = 100
            dgvPayments.Columns("IsVoid").Visible = False
            
            ' Highlight voided rows
            For Each row As DataGridViewRow In dgvPayments.Rows
                If Not row.IsNewRow AndAlso Convert.ToBoolean(row.Cells("IsVoid").Value) Then
                    row.DefaultCellStyle.BackColor = Color.LightCoral
                    row.DefaultCellStyle.ForeColor = Color.Gray
                End If
            Next
        End Sub

        Private Sub CalculateTotals()
            Dim totalReceipts As Decimal = 0
            Dim totalPayments As Decimal = 0
            
            For Each row As DataGridViewRow In dgvReceipts.Rows
                If Not row.IsNewRow AndAlso Not Convert.ToBoolean(row.Cells("IsVoid").Value) Then
                    totalReceipts += Convert.ToDecimal(row.Cells("Amount").Value)
                End If
            Next
            
            For Each row As DataGridViewRow In dgvPayments.Rows
                If Not row.IsNewRow AndAlso Not Convert.ToBoolean(row.Cells("IsVoid").Value) Then
                    totalPayments += Convert.ToDecimal(row.Cells("Amount").Value)
                End If
            Next
            
            lblTotalReceipts.Text = $"Total Receipts: R {totalReceipts:N2}"
            lblTotalPayments.Text = $"Total Payments: R {totalPayments:N2}"
            
            Dim expectedClosing = _openingBalance + totalReceipts - totalPayments
            lblExpectedClosing.Text = $"Expected Closing: R {expectedClosing:N2}"
        End Sub

        Private Sub btnNewReceipt_Click(sender As Object, e As EventArgs) Handles btnNewReceipt.Click
            If _isReconciled Then
                MessageBox.Show("This day has been reconciled. Cannot add new transactions.", "Reconciled", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim form As New CashTransactionForm(_currentCashBookID, "Receipt", dtpDate.Value.Date)
            If form.ShowDialog() = DialogResult.OK Then
                LoadTransactions()
                CalculateTotals()
            End If
        End Sub

        Private Sub btnNewPayment_Click(sender As Object, e As EventArgs) Handles btnNewPayment.Click
            If _isReconciled Then
                MessageBox.Show("This day has been reconciled. Cannot add new transactions.", "Reconciled", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim form As New CashTransactionForm(_currentCashBookID, "Payment", dtpDate.Value.Date)
            If form.ShowDialog() = DialogResult.OK Then
                LoadTransactions()
                CalculateTotals()
            End If
        End Sub

        Private Sub btnReconcile_Click(sender As Object, e As EventArgs) Handles btnReconcile.Click
            Dim totalReceipts As Decimal = 0
            Dim totalPayments As Decimal = 0
            
            For Each row As DataGridViewRow In dgvReceipts.Rows
                If Not row.IsNewRow AndAlso Not Convert.ToBoolean(row.Cells("IsVoid").Value) Then
                    totalReceipts += Convert.ToDecimal(row.Cells("Amount").Value)
                End If
            Next
            
            For Each row As DataGridViewRow In dgvPayments.Rows
                If Not row.IsNewRow AndAlso Not Convert.ToBoolean(row.Cells("IsVoid").Value) Then
                    totalPayments += Convert.ToDecimal(row.Cells("Amount").Value)
                End If
            Next
            
            Dim expectedClosing = _openingBalance + totalReceipts - totalPayments
            
            Dim form As New CashReconciliationForm(_currentCashBookID, dtpDate.Value.Date, _openingBalance, totalReceipts, totalPayments, expectedClosing)
            If form.ShowDialog() = DialogResult.OK Then
                LoadOpeningBalance()
                MessageBox.Show("Cash book reconciled successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        End Sub

        Private Sub dtpDate_ValueChanged(sender As Object, e As EventArgs) Handles dtpDate.ValueChanged
            LoadOpeningBalance()
            LoadTransactions()
            CalculateTotals()
        End Sub

        Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
            LoadTransactions()
            CalculateTotals()
        End Sub

        Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
            Me.Close()
        End Sub

        Private Class CashBookItem
            Public Property CashBookID As Integer
            Public Property CashBookName As String
            Public Property CurrentBalance As Decimal
        End Class
    End Class
End Namespace
