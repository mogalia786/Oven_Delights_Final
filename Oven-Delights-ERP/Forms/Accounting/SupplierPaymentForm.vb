Imports System.Windows.Forms
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Partial Public Class SupplierPaymentForm

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private currentBranchId As Integer
    Private selectedSupplierId As Integer = 0
    
    Public Sub New()
        InitializeComponent()
        currentBranchId = AppSession.CurrentBranchID
        Me.Text = "Pay Supplier Invoice"
        Me.WindowState = FormWindowState.Maximized
        LoadSuppliers()
    End Sub

    Private Sub LoadSuppliers()
        Try
            Using con As New SqlConnection(connectionString)
                Dim sql = "SELECT SupplierID, CompanyName FROM Suppliers WHERE IsActive = 1 ORDER BY CompanyName"
                Using ad As New SqlDataAdapter(sql, con)
                    Dim dt As New DataTable()
                    ad.Fill(dt)
                    cboSupplier.DataSource = dt
                    cboSupplier.DisplayMember = "CompanyName"
                    cboSupplier.ValueMember = "SupplierID"
                    cboSupplier.SelectedIndex = -1
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub cboSupplier_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboSupplier.SelectedIndexChanged
        If cboSupplier.SelectedValue IsNot Nothing AndAlso TypeOf cboSupplier.SelectedValue Is Integer Then
            selectedSupplierId = Convert.ToInt32(cboSupplier.SelectedValue)
            LoadOutstandingInvoices()
        End If
    End Sub

    Private Sub LoadOutstandingInvoices()
        Try
            If selectedSupplierId <= 0 Then
                dgvInvoices.DataSource = Nothing
                Return
            End If

            Using con As New SqlConnection(connectionString)
                ' Try with BranchID filter first
                Dim sql = "SELECT InvoiceID, InvoiceNumber, InvoiceDate, DueDate, TotalAmount, " &
                         "ISNULL(AmountPaid, 0) AS AmountPaid, " &
                         "ISNULL(AmountOutstanding, TotalAmount) AS AmountOutstanding, " &
                         "CASE WHEN DueDate < GETDATE() AND ISNULL(AmountOutstanding, TotalAmount) > 0 THEN 'Overdue' " &
                         "     ELSE ISNULL(Status, 'Open') END AS DisplayStatus " &
                         "FROM SupplierInvoices " &
                         "WHERE SupplierID = @SupplierID " &
                         "AND (BranchID = @BranchID OR BranchID IS NULL) " &
                         "AND ISNULL(AmountOutstanding, TotalAmount) > 0 " &
                         "ORDER BY InvoiceDate"
                
                Using ad As New SqlDataAdapter(sql, con)
                    ad.SelectCommand.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
                    ad.SelectCommand.Parameters.AddWithValue("@BranchID", currentBranchId)
                    Dim dt As New DataTable()
                    ad.Fill(dt)
                    
                    If dt.Rows.Count = 0 Then
                        ' Try without branch filter
                        sql = "SELECT InvoiceID, InvoiceNumber, InvoiceDate, DueDate, TotalAmount, " &
                             "ISNULL(AmountPaid, 0) AS AmountPaid, " &
                             "ISNULL(AmountOutstanding, TotalAmount) AS AmountOutstanding, " &
                             "CASE WHEN DueDate < GETDATE() AND ISNULL(AmountOutstanding, TotalAmount) > 0 THEN 'Overdue' " &
                             "     ELSE ISNULL(Status, 'Open') END AS DisplayStatus " &
                             "FROM SupplierInvoices " &
                             "WHERE SupplierID = @SupplierID " &
                             "AND ISNULL(AmountOutstanding, TotalAmount) > 0 " &
                             "ORDER BY InvoiceDate"
                        
                        Using ad2 As New SqlDataAdapter(sql, con)
                            ad2.SelectCommand.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
                            dt.Clear()
                            ad2.Fill(dt)
                        End Using
                    End If
                    
                    dgvInvoices.DataSource = dt
                    
                    If dt.Rows.Count = 0 Then
                        MessageBox.Show($"No outstanding invoices found for this supplier.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Else
                        FormatInvoicesGrid()
                        UpdateTotals()
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading invoices: {ex.Message}{Environment.NewLine}{Environment.NewLine}Stack: {ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub FormatInvoicesGrid()
        If dgvInvoices.Columns.Count = 0 Then Return
        
        dgvInvoices.Columns("InvoiceID").Visible = False
        dgvInvoices.Columns("InvoiceNumber").HeaderText = "Invoice #"
        dgvInvoices.Columns("InvoiceNumber").Width = 120
        dgvInvoices.Columns("InvoiceDate").HeaderText = "Invoice Date"
        dgvInvoices.Columns("InvoiceDate").Width = 100
        dgvInvoices.Columns("InvoiceDate").DefaultCellStyle.Format = "dd MMM yyyy"
        dgvInvoices.Columns("DueDate").HeaderText = "Due Date"
        dgvInvoices.Columns("DueDate").Width = 100
        dgvInvoices.Columns("DueDate").DefaultCellStyle.Format = "dd MMM yyyy"
        dgvInvoices.Columns("TotalAmount").HeaderText = "Total"
        dgvInvoices.Columns("TotalAmount").Width = 100
        dgvInvoices.Columns("TotalAmount").DefaultCellStyle.Format = "C2"
        dgvInvoices.Columns("AmountPaid").HeaderText = "Paid"
        dgvInvoices.Columns("AmountPaid").Width = 100
        dgvInvoices.Columns("AmountPaid").DefaultCellStyle.Format = "C2"
        dgvInvoices.Columns("AmountOutstanding").HeaderText = "Outstanding"
        dgvInvoices.Columns("AmountOutstanding").Width = 120
        dgvInvoices.Columns("AmountOutstanding").DefaultCellStyle.Format = "C2"
        dgvInvoices.Columns("DisplayStatus").HeaderText = "Status"
        dgvInvoices.Columns("DisplayStatus").Width = 100
        
        ' Add payment amount column
        If Not dgvInvoices.Columns.Contains("PaymentAmount") Then
            Dim payCol As New DataGridViewTextBoxColumn With {
                .Name = "PaymentAmount",
                .HeaderText = "Payment Amount",
                .Width = 120,
                .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "N2"}
            }
            dgvInvoices.Columns.Add(payCol)
        End If
    End Sub

    Private Sub UpdateTotals()
        Dim totalOutstanding As Decimal = 0D
        Dim totalPayment As Decimal = 0D
        
        For Each row As DataGridViewRow In dgvInvoices.Rows
            If row.IsNewRow Then Continue For
            totalOutstanding += Convert.ToDecimal(row.Cells("AmountOutstanding").Value)
            
            Dim payCell = row.Cells("PaymentAmount").Value
            If payCell IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(payCell.ToString()) Then
                Dim payAmount As Decimal
                If Decimal.TryParse(payCell.ToString(), payAmount) Then
                    totalPayment += payAmount
                End If
            End If
        Next
        
        lblTotalOutstanding.Text = $"Total Outstanding: {totalOutstanding:C2}"
        lblTotalPayment.Text = $"Total Payment: {totalPayment:C2}"
    End Sub

    Private Sub dgvInvoices_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs) Handles dgvInvoices.CellValueChanged
        If e.RowIndex >= 0 AndAlso e.ColumnIndex >= 0 Then
            If dgvInvoices.Columns(e.ColumnIndex).Name = "PaymentAmount" Then
                UpdateTotals()
            End If
        End If
    End Sub

    Private Sub btnProcessPayment_Click(sender As Object, e As EventArgs) Handles btnProcessPayment.Click
        Try
            ' Validate
            If selectedSupplierId = 0 Then
                MessageBox.Show("Please select a supplier.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If String.IsNullOrWhiteSpace(cboPaymentMethod.Text) Then
                MessageBox.Show("Please select a payment method.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Collect payments
            Dim payments As New List(Of (InvoiceID As Integer, Amount As Decimal))
            Dim totalPayment As Decimal = 0D
            
            For Each row As DataGridViewRow In dgvInvoices.Rows
                If row.IsNewRow Then Continue For
                
                Dim payCell = row.Cells("PaymentAmount").Value
                If payCell Is Nothing OrElse String.IsNullOrWhiteSpace(payCell.ToString()) Then Continue For
                
                Dim payAmount As Decimal
                If Not Decimal.TryParse(payCell.ToString(), payAmount) OrElse payAmount <= 0 Then Continue For
                
                Dim invoiceId As Integer = Convert.ToInt32(row.Cells("InvoiceID").Value)
                Dim outstanding As Decimal = Convert.ToDecimal(row.Cells("AmountOutstanding").Value)
                
                If payAmount > outstanding Then
                    MessageBox.Show($"Payment amount cannot exceed outstanding amount for invoice {row.Cells("InvoiceNumber").Value}", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                
                payments.Add((invoiceId, payAmount))
                totalPayment += payAmount
            Next
            
            If payments.Count = 0 Then
                MessageBox.Show("Please enter payment amounts.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Process payment
            ProcessPayment(payments, totalPayment)
            
            MessageBox.Show($"Payment of {totalPayment:C2} processed successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            LoadOutstandingInvoices()
            ClearPaymentFields()
            
        Catch ex As Exception
            MessageBox.Show($"Error processing payment: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ProcessPayment(payments As List(Of (InvoiceID As Integer, Amount As Decimal)), totalAmount As Decimal)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Create payment record
                    Dim paymentNumber As String = $"PAY-{DateTime.Now:yyyyMMddHHmmss}"
                    Dim paymentId As Integer
                    
                    Dim paySql = "INSERT INTO SupplierPayments (PaymentNumber, SupplierID, BranchID, PaymentDate, PaymentMethod, PaymentAmount, Reference, CheckNumber, Notes, CreatedBy) " &
                                "OUTPUT INSERTED.PaymentID " &
                                "VALUES (@PayNum, @SupplierID, @BranchID, @PayDate, @Method, @Amount, @Ref, @Check, @Notes, @UserID)"
                    
                    Using cmd As New SqlCommand(paySql, con, tx)
                        cmd.Parameters.AddWithValue("@PayNum", paymentNumber)
                        cmd.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
                        cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                        cmd.Parameters.AddWithValue("@PayDate", dtpPaymentDate.Value)
                        cmd.Parameters.AddWithValue("@Method", cboPaymentMethod.Text)
                        cmd.Parameters.AddWithValue("@Amount", totalAmount)
                        cmd.Parameters.AddWithValue("@Ref", If(String.IsNullOrWhiteSpace(txtReference.Text), DBNull.Value, txtReference.Text))
                        cmd.Parameters.AddWithValue("@Check", If(String.IsNullOrWhiteSpace(txtCheckNumber.Text), DBNull.Value, txtCheckNumber.Text))
                        cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrWhiteSpace(txtNotes.Text), DBNull.Value, txtNotes.Text))
                        cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
                        paymentId = Convert.ToInt32(cmd.ExecuteScalar())
                    End Using
                    
                    ' Allocate payments to invoices
                    For Each payment In payments
                        ' Create allocation
                        Dim allocSql = "INSERT INTO SupplierPaymentAllocations (PaymentID, InvoiceID, AllocatedAmount, AllocationDate) VALUES (@PayID, @InvID, @Amount, GETDATE())"
                        Using cmd As New SqlCommand(allocSql, con, tx)
                            cmd.Parameters.AddWithValue("@PayID", paymentId)
                            cmd.Parameters.AddWithValue("@InvID", payment.InvoiceID)
                            cmd.Parameters.AddWithValue("@Amount", payment.Amount)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' Update invoice
                        Dim updateInvSql = "UPDATE SupplierInvoices SET AmountPaid = AmountPaid + @Amount, Status = CASE WHEN AmountPaid + @Amount >= TotalAmount THEN 'Paid' WHEN AmountPaid + @Amount > 0 THEN 'PartiallyPaid' ELSE Status END WHERE InvoiceID = @InvID"
                        Using cmd As New SqlCommand(updateInvSql, con, tx)
                            cmd.Parameters.AddWithValue("@Amount", payment.Amount)
                            cmd.Parameters.AddWithValue("@InvID", payment.InvoiceID)
                            cmd.ExecuteNonQuery()
                        End Using
                    Next
                    
                    ' Create ledger entries
                    CreatePaymentLedgerEntries(con, tx, totalAmount, paymentNumber)
                    
                    tx.Commit()
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Private Sub CreatePaymentLedgerEntries(con As SqlConnection, tx As SqlTransaction, amount As Decimal, reference As String)
        ' Get current fiscal period
        Dim fiscalPeriodId As Integer = 0
        Using cmdFP As New SqlCommand("SELECT TOP 1 PeriodID FROM dbo.FiscalPeriods WHERE GETDATE() BETWEEN StartDate AND EndDate AND IsClosed = 0 ORDER BY StartDate DESC", con, tx)
            Dim fpResult = cmdFP.ExecuteScalar()
            If fpResult IsNot Nothing AndAlso Not IsDBNull(fpResult) Then
                fiscalPeriodId = Convert.ToInt32(fpResult)
            End If
        End Using
        
        If fiscalPeriodId <= 0 Then
            Throw New Exception("No open fiscal period found. Please create a fiscal period before processing payments.")
        End If
        
        ' Create journal header
        Dim journalId As Integer
        Dim jSql = "INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy) OUTPUT INSERTED.JournalID VALUES (@JNum, @BranchID, GETDATE(), @Ref, @Desc, @FP, 0, @UserID)"
        Using cmd As New SqlCommand(jSql, con, tx)
            cmd.Parameters.AddWithValue("@JNum", $"JNL-{DateTime.Now:yyyyMMddHHmmss}")
            cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
            cmd.Parameters.AddWithValue("@Ref", reference)
            cmd.Parameters.AddWithValue("@Desc", "Supplier Payment")
            cmd.Parameters.AddWithValue("@FP", fiscalPeriodId)
            cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
            journalId = Convert.ToInt32(cmd.ExecuteScalar())
        End Using
        
        ' DR Accounts Payable (reduce liability)
        Dim dSql = "INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description) VALUES (@JID, 1, @AcctID, @Amount, 0, @Desc)"
        Using cmd As New SqlCommand(dSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", journalId)
            cmd.Parameters.AddWithValue("@AcctID", GetAPAccountID(con, tx))
            cmd.Parameters.AddWithValue("@Amount", amount)
            cmd.Parameters.AddWithValue("@Desc", $"Accounts Payable - {reference}")
            cmd.ExecuteNonQuery()
        End Using
        
        ' CR Bank/Cash (reduce asset)
        Dim cSql = "INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description) VALUES (@JID, 2, @AcctID, 0, @Amount, @Desc)"
        Using cmd As New SqlCommand(cSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", journalId)
            cmd.Parameters.AddWithValue("@AcctID", GetBankAccountID(con, tx))
            cmd.Parameters.AddWithValue("@Amount", amount)
            cmd.Parameters.AddWithValue("@Desc", $"Bank Payment - {reference}")
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Function GetAPAccountID(con As SqlConnection, tx As SqlTransaction) As Integer
        Return GetOrCreateAccountID(con, tx, "2100", "Accounts Payable")
    End Function

    Private Function GetBankAccountID(con As SqlConnection, tx As SqlTransaction) As Integer
        Return GetOrCreateAccountID(con, tx, "1050", "Bank Account")
    End Function

    Private Function GetOrCreateAccountID(con As SqlConnection, tx As SqlTransaction, code As String, name As String) As Integer
        ' Try GLAccounts first (new table)
        Dim sql = "SELECT AccountID FROM GLAccounts WHERE AccountNumber = @Code"
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@Code", code)
            Dim result = cmd.ExecuteScalar()
            If result IsNot Nothing Then Return Convert.ToInt32(result)
        End Using
        
        ' Try ChartOfAccounts (legacy table)
        sql = "SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = @Code"
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@Code", code)
            Dim result = cmd.ExecuteScalar()
            If result IsNot Nothing Then Return Convert.ToInt32(result)
        End Using
        
        ' Create in GLAccounts
        Dim accountType = If(code.StartsWith("1"), "Asset", If(code.StartsWith("2"), "Liability", "Expense"))
        Dim balanceType = If(code.StartsWith("1") OrElse code.StartsWith("5"), "D", "C")
        Dim insertSql = "INSERT INTO GLAccounts (AccountNumber, AccountName, AccountType, BalanceType, IsActive) OUTPUT INSERTED.AccountID VALUES (@Code, @Name, @Type, @Balance, 1)"
        Using cmd As New SqlCommand(insertSql, con, tx)
            cmd.Parameters.AddWithValue("@Code", code)
            cmd.Parameters.AddWithValue("@Name", name)
            cmd.Parameters.AddWithValue("@Type", accountType)
            cmd.Parameters.AddWithValue("@Balance", balanceType)
            Return Convert.ToInt32(cmd.ExecuteScalar())
        End Using
    End Function

    Private Sub ClearPaymentFields()
        txtReference.Clear()
        txtCheckNumber.Clear()
        txtNotes.Clear()
        dtpPaymentDate.Value = DateTime.Today
        If cboPaymentMethod.Items.Count > 0 Then cboPaymentMethod.SelectedIndex = 0
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
