Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class PaymentDueService
    Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Public Function GetPaymentsDueCount() As Integer
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Count overdue invoices + recurring expenses due
                Dim sql As String = "
                    SELECT COUNT(*) FROM (
                        -- Overdue supplier invoices
                        SELECT 1 FROM dbo.SupplierInvoices 
                        WHERE Status = 'Approved' 
                        AND PaymentStatus = 'Pending'
                        AND DATEADD(day, PaymentTerms, InvoiceDate) <= GETDATE()
                        
                        UNION ALL
                        
                        -- Recurring expenses due (rent, rates, etc.)
                        SELECT 1 FROM dbo.RecurringExpenses 
                        WHERE IsActive = 1
                        AND NextDueDate <= GETDATE()
                        AND (LastPaidDate IS NULL OR LastPaidDate < NextDueDate)
                    ) AS PaymentsDue"
                
                Using cmd As New SqlCommand(sql, conn)
                    Return Convert.ToInt32(cmd.ExecuteScalar())
                End Using
            End Using
        Catch
            Return 0
        End Try
    End Function

    Public Function GetPaymentsDueList() As DataTable
        Dim dt As New DataTable()
        
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim sql As String = "
                    SELECT 
                        'Invoice' AS PaymentType,
                        si.InvoiceID AS ReferenceID,
                        si.InvoiceNumber AS Reference,
                        s.SupplierName AS Payee,
                        si.TotalAmount AS Amount,
                        DATEADD(day, si.PaymentTerms, si.InvoiceDate) AS DueDate,
                        DATEDIFF(day, DATEADD(day, si.PaymentTerms, si.InvoiceDate), GETDATE()) AS DaysOverdue,
                        si.Description AS Description,
                        s.BankAccount,
                        s.BankBranch,
                        s.BankName
                    FROM dbo.SupplierInvoices si
                    INNER JOIN dbo.Suppliers s ON si.SupplierID = s.SupplierID
                    WHERE si.Status = 'Approved' 
                    AND si.PaymentStatus = 'Pending'
                    AND DATEADD(day, si.PaymentTerms, si.InvoiceDate) <= GETDATE()
                    
                    UNION ALL
                    
                    SELECT 
                        'Expense' AS PaymentType,
                        re.ExpenseID AS ReferenceID,
                        re.ExpenseCode AS Reference,
                        re.PayeeName AS Payee,
                        re.Amount AS Amount,
                        re.NextDueDate AS DueDate,
                        DATEDIFF(day, re.NextDueDate, GETDATE()) AS DaysOverdue,
                        re.Description AS Description,
                        re.BankAccount,
                        re.BankBranch,
                        re.BankName
                    FROM dbo.RecurringExpenses re
                    WHERE re.IsActive = 1
                    AND re.NextDueDate <= GETDATE()
                    AND (re.LastPaidDate IS NULL OR re.LastPaidDate < re.NextDueDate)
                    
                    ORDER BY DaysOverdue DESC, DueDate ASC"
                
                Using adapter As New SqlDataAdapter(sql, conn)
                    adapter.Fill(dt)
                End Using
            End Using
        Catch ex As Exception
            ' Return empty table on error
        End Try
        
        Return dt
    End Function

    Public Sub MarkPaymentProcessed(paymentType As String, referenceId As Integer, bankReference As String, paidAmount As Decimal, paidDate As Date)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using trans As SqlTransaction = conn.BeginTransaction()
                    
                    If paymentType = "Invoice" Then
                        ' Update supplier invoice
                        Dim sql As String = "UPDATE dbo.SupplierInvoices SET PaymentStatus = 'Paid', PaidDate = @paidDate, PaidAmount = @amount, BankReference = @ref WHERE InvoiceID = @id"
                        Using cmd As New SqlCommand(sql, conn, trans)
                            cmd.Parameters.AddWithValue("@paidDate", paidDate)
                            cmd.Parameters.AddWithValue("@amount", paidAmount)
                            cmd.Parameters.AddWithValue("@ref", bankReference)
                            cmd.Parameters.AddWithValue("@id", referenceId)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                    ElseIf paymentType = "Expense" Then
                        ' Update recurring expense
                        Dim sql As String = "UPDATE dbo.RecurringExpenses SET LastPaidDate = @paidDate, LastPaidAmount = @amount, BankReference = @ref, NextDueDate = DATEADD(month, FrequencyMonths, @paidDate) WHERE ExpenseID = @id"
                        Using cmd As New SqlCommand(sql, conn, trans)
                            cmd.Parameters.AddWithValue("@paidDate", paidDate)
                            cmd.Parameters.AddWithValue("@amount", paidAmount)
                            cmd.Parameters.AddWithValue("@ref", bankReference)
                            cmd.Parameters.AddWithValue("@id", referenceId)
                            cmd.ExecuteNonQuery()
                        End Using
                    End If
                    
                    trans.Commit()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Error marking payment as processed: {ex.Message}")
        End Try
    End Sub

End Class
