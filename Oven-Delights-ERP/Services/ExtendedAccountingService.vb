Imports System.Data.SqlClient
Imports System.Configuration

''' <summary>
''' Extended Accounting Service for Supplier Ledgers, Adhoc Invoices/Payments, and Bank Reconciliation
''' </summary>
Public Class ExtendedAccountingService
    
    Private ReadOnly _connString As String
    
    Public Sub New()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrEmpty(_connString) Then
            Throw New Exception("Connection string 'OvenDelightsERPConnectionString' not found")
        End If
    End Sub
    
    ' =============================================
    ' SUPPLIER LEDGER METHODS
    ' =============================================
    
    ''' <summary>
    ''' Post supplier invoice to ledger (increases what we owe)
    ''' Does NOT update Bank account - only when reconciled with FNB statement
    ''' </summary>
    Public Function PostSupplierInvoice(
        supplierID As Integer,
        supplierName As String,
        supplierCode As String,
        invoiceNumber As String,
        invoiceAmount As Decimal,
        description As String,
        branchID As Integer,
        userName As String
    ) As Boolean
        
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using trans = conn.BeginTransaction()
                    Try
                        ' 1. Post to Supplier Ledger (DR - increases what we owe)
                        Using cmd As New SqlCommand("sp_PostSupplierLedger", conn, trans)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.AddWithValue("@SupplierID", supplierID)
                            cmd.Parameters.AddWithValue("@SupplierName", supplierName)
                            cmd.Parameters.AddWithValue("@SupplierCode", If(String.IsNullOrEmpty(supplierCode), DBNull.Value, supplierCode))
                            cmd.Parameters.AddWithValue("@TransactionType", "Invoice")
                            cmd.Parameters.AddWithValue("@ReferenceNumber", invoiceNumber)
                            cmd.Parameters.AddWithValue("@Description", description)
                            cmd.Parameters.AddWithValue("@DebitAmount", invoiceAmount)
                            cmd.Parameters.AddWithValue("@CreditAmount", 0)
                            cmd.Parameters.AddWithValue("@BranchID", branchID)
                            cmd.Parameters.AddWithValue("@CreatedBy", userName)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' 2. Post to General Ledger (DR: Expense/Asset, CR: Accounts Payable)
                        Dim journalNumber = $"SUP-INV-{invoiceNumber}"
                        
                        ' Get Accounts Payable account ID
                        Dim apAccountID As Integer
                        Using cmd As New SqlCommand("SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '2110'", conn, trans)
                            apAccountID = CInt(cmd.ExecuteScalar())
                        End Using
                        
                        ' Post journal entry
                        Using cmd As New SqlCommand("sp_PostJournalEntry", conn, trans)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.AddWithValue("@JournalNumber", journalNumber)
                            cmd.Parameters.AddWithValue("@AccountID", apAccountID)
                            cmd.Parameters.AddWithValue("@TransactionType", "SupplierInvoice")
                            cmd.Parameters.AddWithValue("@Description", $"Supplier Invoice: {supplierName} - {description}")
                            cmd.Parameters.AddWithValue("@DebitAmount", 0)
                            cmd.Parameters.AddWithValue("@CreditAmount", invoiceAmount)
                            cmd.Parameters.AddWithValue("@ReferenceNumber", invoiceNumber)
                            cmd.Parameters.AddWithValue("@BranchID", branchID)
                            cmd.Parameters.AddWithValue("@CreatedBy", userName)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        trans.Commit()
                        Return True
                        
                    Catch ex As Exception
                        trans.Rollback()
                        Throw New Exception($"Error posting supplier invoice: {ex.Message}", ex)
                    End Try
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Database error in PostSupplierInvoice: {ex.Message}", ex)
        End Try
    End Function
    
    ''' <summary>
    ''' Post supplier payment - PENDING reconciliation with FNB statement
    ''' Bank account is NOT updated until reconciled
    ''' </summary>
    Public Function PostSupplierPaymentPending(
        supplierID As Integer,
        supplierName As String,
        supplierCode As String,
        paymentNumber As String,
        paymentAmount As Decimal,
        paymentMethod As String,
        bankReference As String,
        branchID As Integer,
        userName As String
    ) As Integer
        
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using trans = conn.BeginTransaction()
                    Try
                        Dim paymentID As Integer
                        
                        ' 1. Insert into SupplierPayments table (pending reconciliation)
                        Dim sql = "INSERT INTO SupplierPayments (
                                    PaymentNumber, PaymentDate, SupplierID, SupplierName, SupplierCode,
                                    PaymentAmount, PaymentMethod, IsBankTransfer, BankReference,
                                    IsReconciled, BranchID, CreatedBy
                                   ) VALUES (
                                    @PaymentNumber, GETDATE(), @SupplierID, @SupplierName, @SupplierCode,
                                    @PaymentAmount, @PaymentMethod, @IsBankTransfer, @BankReference,
                                    0, @BranchID, @CreatedBy
                                   );
                                   SELECT SCOPE_IDENTITY()"
                        
                        Using cmd As New SqlCommand(sql, conn, trans)
                            cmd.Parameters.AddWithValue("@PaymentNumber", paymentNumber)
                            cmd.Parameters.AddWithValue("@SupplierID", supplierID)
                            cmd.Parameters.AddWithValue("@SupplierName", supplierName)
                            cmd.Parameters.AddWithValue("@SupplierCode", If(String.IsNullOrEmpty(supplierCode), DBNull.Value, supplierCode))
                            cmd.Parameters.AddWithValue("@PaymentAmount", paymentAmount)
                            cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod)
                            cmd.Parameters.AddWithValue("@IsBankTransfer", If(paymentMethod = "EFT" Or paymentMethod = "Card", 1, 0))
                            cmd.Parameters.AddWithValue("@BankReference", If(String.IsNullOrEmpty(bankReference), DBNull.Value, bankReference))
                            cmd.Parameters.AddWithValue("@BranchID", branchID)
                            cmd.Parameters.AddWithValue("@CreatedBy", userName)
                            paymentID = Convert.ToInt32(cmd.ExecuteScalar())
                        End Using
                        
                        ' 2. Post to Supplier Ledger (CR - decreases what we owe)
                        Using cmd As New SqlCommand("sp_PostSupplierLedger", conn, trans)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.AddWithValue("@SupplierID", supplierID)
                            cmd.Parameters.AddWithValue("@SupplierName", supplierName)
                            cmd.Parameters.AddWithValue("@SupplierCode", If(String.IsNullOrEmpty(supplierCode), DBNull.Value, supplierCode))
                            cmd.Parameters.AddWithValue("@TransactionType", "Payment-Pending")
                            cmd.Parameters.AddWithValue("@ReferenceNumber", paymentNumber)
                            cmd.Parameters.AddWithValue("@Description", $"Payment pending reconciliation - {paymentMethod}")
                            cmd.Parameters.AddWithValue("@DebitAmount", 0)
                            cmd.Parameters.AddWithValue("@CreditAmount", paymentAmount)
                            cmd.Parameters.AddWithValue("@BranchID", branchID)
                            cmd.Parameters.AddWithValue("@CreatedBy", userName)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' NOTE: Bank account NOT updated yet - only when reconciled with FNB statement
                        
                        trans.Commit()
                        Return paymentID
                        
                    Catch ex As Exception
                        trans.Rollback()
                        Throw New Exception($"Error posting supplier payment: {ex.Message}", ex)
                    End Try
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Database error in PostSupplierPaymentPending: {ex.Message}", ex)
        End Try
    End Function
    
    ' =============================================
    ' ADHOC INVOICE METHODS
    ' =============================================
    
    ''' <summary>
    ''' Create adhoc invoice for customer
    ''' </summary>
    Public Function CreateAdhocInvoice(
        invoiceNumber As String,
        customerID As Integer,
        customerName As String,
        accountNumber As String,
        items As List(Of AdhocInvoiceItem),
        branchID As Integer,
        userName As String
    ) As Integer
        
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using trans = conn.BeginTransaction()
                    Try
                        Dim invoiceID As Integer
                        Dim subTotal = items.Sum(Function(i) i.LineTotal)
                        Dim taxAmount = items.Sum(Function(i) i.LineTotal * i.TaxRate / 100)
                        Dim totalAmount = subTotal + taxAmount
                        
                        ' 1. Insert invoice header
                        Dim sql = "INSERT INTO AdhocInvoices (
                                    InvoiceNumber, InvoiceDate, CustomerID, CustomerName, AccountNumber,
                                    SubTotal, TaxAmount, TotalAmount, AmountPaid, BalanceDue,
                                    InvoiceStatus, BranchID, CreatedBy
                                   ) VALUES (
                                    @InvoiceNumber, GETDATE(), @CustomerID, @CustomerName, @AccountNumber,
                                    @SubTotal, @TaxAmount, @TotalAmount, 0, @TotalAmount,
                                    'Unpaid', @BranchID, @CreatedBy
                                   );
                                   SELECT SCOPE_IDENTITY()"
                        
                        Using cmd As New SqlCommand(sql, conn, trans)
                            cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
                            cmd.Parameters.AddWithValue("@CustomerID", If(customerID = 0, DBNull.Value, customerID))
                            cmd.Parameters.AddWithValue("@CustomerName", customerName)
                            cmd.Parameters.AddWithValue("@AccountNumber", If(String.IsNullOrEmpty(accountNumber), DBNull.Value, accountNumber))
                            cmd.Parameters.AddWithValue("@SubTotal", subTotal)
                            cmd.Parameters.AddWithValue("@TaxAmount", taxAmount)
                            cmd.Parameters.AddWithValue("@TotalAmount", totalAmount)
                            cmd.Parameters.AddWithValue("@BranchID", branchID)
                            cmd.Parameters.AddWithValue("@CreatedBy", userName)
                            invoiceID = Convert.ToInt32(cmd.ExecuteScalar())
                        End Using
                        
                        ' 2. Insert invoice items
                        For Each item In items
                            sql = "INSERT INTO AdhocInvoiceItems (
                                    InvoiceID, ProductID, Description, Quantity, UnitPrice, LineTotal, TaxRate
                                   ) VALUES (
                                    @InvoiceID, @ProductID, @Description, @Quantity, @UnitPrice, @LineTotal, @TaxRate
                                   )"
                            
                            Using cmd As New SqlCommand(sql, conn, trans)
                                cmd.Parameters.AddWithValue("@InvoiceID", invoiceID)
                                cmd.Parameters.AddWithValue("@ProductID", If(item.ProductID = 0, DBNull.Value, item.ProductID))
                                cmd.Parameters.AddWithValue("@Description", item.Description)
                                cmd.Parameters.AddWithValue("@Quantity", item.Quantity)
                                cmd.Parameters.AddWithValue("@UnitPrice", item.UnitPrice)
                                cmd.Parameters.AddWithValue("@LineTotal", item.LineTotal)
                                cmd.Parameters.AddWithValue("@TaxRate", item.TaxRate)
                                cmd.ExecuteNonQuery()
                            End Using
                        Next
                        
                        ' 3. Post to Customer Ledger (DR - customer owes us)
                        If Not String.IsNullOrEmpty(accountNumber) Then
                            Using cmd As New SqlCommand("sp_PostCustomerLedger", conn, trans)
                                cmd.CommandType = CommandType.StoredProcedure
                                cmd.Parameters.AddWithValue("@AccountNumber", accountNumber)
                                cmd.Parameters.AddWithValue("@CustomerName", customerName)
                                cmd.Parameters.AddWithValue("@TransactionType", "AdhocInvoice")
                                cmd.Parameters.AddWithValue("@ReferenceNumber", invoiceNumber)
                                cmd.Parameters.AddWithValue("@Description", "Adhoc Invoice")
                                cmd.Parameters.AddWithValue("@DebitAmount", totalAmount)
                                cmd.Parameters.AddWithValue("@CreditAmount", 0)
                                cmd.Parameters.AddWithValue("@BranchID", branchID)
                                cmd.Parameters.AddWithValue("@CreatedBy", userName)
                                cmd.ExecuteNonQuery()
                            End Using
                        End If
                        
                        trans.Commit()
                        Return invoiceID
                        
                    Catch ex As Exception
                        trans.Rollback()
                        Throw New Exception($"Error creating adhoc invoice: {ex.Message}", ex)
                    End Try
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Database error in CreateAdhocInvoice: {ex.Message}", ex)
        End Try
    End Function
    
    ''' <summary>
    ''' Post adhoc payment - PENDING reconciliation if bank transfer
    ''' </summary>
    Public Function PostAdhocPaymentPending(
        paymentNumber As String,
        customerName As String,
        accountNumber As String,
        invoiceID As Integer,
        invoiceNumber As String,
        paymentAmount As Decimal,
        paymentMethod As String,
        bankReference As String,
        branchID As Integer,
        userName As String
    ) As Integer
        
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using trans = conn.BeginTransaction()
                    Try
                        Dim paymentID As Integer
                        Dim isBankTransfer = (paymentMethod = "Card" Or paymentMethod = "EFT")
                        
                        ' 1. Insert payment record
                        Dim sql = "INSERT INTO AdhocPayments (
                                    PaymentNumber, PaymentDate, CustomerName, AccountNumber,
                                    InvoiceID, InvoiceNumber, PaymentAmount, PaymentMethod,
                                    IsBankTransfer, BankReference, IsReconciled,
                                    BranchID, CreatedBy
                                   ) VALUES (
                                    @PaymentNumber, GETDATE(), @CustomerName, @AccountNumber,
                                    @InvoiceID, @InvoiceNumber, @PaymentAmount, @PaymentMethod,
                                    @IsBankTransfer, @BankReference, @IsReconciled,
                                    @BranchID, @CreatedBy
                                   );
                                   SELECT SCOPE_IDENTITY()"
                        
                        Using cmd As New SqlCommand(sql, conn, trans)
                            cmd.Parameters.AddWithValue("@PaymentNumber", paymentNumber)
                            cmd.Parameters.AddWithValue("@CustomerName", customerName)
                            cmd.Parameters.AddWithValue("@AccountNumber", If(String.IsNullOrEmpty(accountNumber), DBNull.Value, accountNumber))
                            cmd.Parameters.AddWithValue("@InvoiceID", If(invoiceID = 0, DBNull.Value, invoiceID))
                            cmd.Parameters.AddWithValue("@InvoiceNumber", If(String.IsNullOrEmpty(invoiceNumber), DBNull.Value, invoiceNumber))
                            cmd.Parameters.AddWithValue("@PaymentAmount", paymentAmount)
                            cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod)
                            cmd.Parameters.AddWithValue("@IsBankTransfer", isBankTransfer)
                            cmd.Parameters.AddWithValue("@BankReference", If(String.IsNullOrEmpty(bankReference), DBNull.Value, bankReference))
                            cmd.Parameters.AddWithValue("@IsReconciled", If(paymentMethod = "Cash", 1, 0)) ' Cash is immediately reconciled
                            cmd.Parameters.AddWithValue("@BranchID", branchID)
                            cmd.Parameters.AddWithValue("@CreatedBy", userName)
                            paymentID = Convert.ToInt32(cmd.ExecuteScalar())
                        End Using
                        
                        ' 2. Update invoice if linked
                        If invoiceID > 0 Then
                            sql = "UPDATE AdhocInvoices 
                                   SET AmountPaid = AmountPaid + @PaymentAmount,
                                       BalanceDue = BalanceDue - @PaymentAmount,
                                       InvoiceStatus = CASE 
                                           WHEN BalanceDue - @PaymentAmount <= 0 THEN 'Paid'
                                           WHEN AmountPaid + @PaymentAmount > 0 THEN 'PartiallyPaid'
                                           ELSE 'Unpaid'
                                       END,
                                       LastModifiedBy = @UserName,
                                       LastModifiedDate = GETDATE()
                                   WHERE InvoiceID = @InvoiceID"
                            
                            Using cmd As New SqlCommand(sql, conn, trans)
                                cmd.Parameters.AddWithValue("@InvoiceID", invoiceID)
                                cmd.Parameters.AddWithValue("@PaymentAmount", paymentAmount)
                                cmd.Parameters.AddWithValue("@UserName", userName)
                                cmd.ExecuteNonQuery()
                            End Using
                        End If
                        
                        ' 3. Post to Customer Ledger (CR - payment received)
                        If Not String.IsNullOrEmpty(accountNumber) Then
                            Using cmd As New SqlCommand("sp_PostCustomerLedger", conn, trans)
                                cmd.CommandType = CommandType.StoredProcedure
                                cmd.Parameters.AddWithValue("@AccountNumber", accountNumber)
                                cmd.Parameters.AddWithValue("@CustomerName", customerName)
                                cmd.Parameters.AddWithValue("@TransactionType", "AdhocPayment")
                                cmd.Parameters.AddWithValue("@ReferenceNumber", paymentNumber)
                                cmd.Parameters.AddWithValue("@Description", $"Payment - {paymentMethod}")
                                cmd.Parameters.AddWithValue("@DebitAmount", 0)
                                cmd.Parameters.AddWithValue("@CreditAmount", paymentAmount)
                                cmd.Parameters.AddWithValue("@BranchID", branchID)
                                cmd.Parameters.AddWithValue("@CreatedBy", userName)
                                cmd.ExecuteNonQuery()
                            End Using
                        End If
                        
                        ' 4. If CASH payment, update Bank/Cash immediately
                        If paymentMethod = "Cash" Then
                            PostCashPaymentToGL(conn, trans, paymentNumber, paymentAmount, "Adhoc Payment - Cash", branchID, userName)
                        End If
                        
                        ' NOTE: If Card/EFT, Bank account NOT updated until reconciled with FNB statement
                        
                        trans.Commit()
                        Return paymentID
                        
                    Catch ex As Exception
                        trans.Rollback()
                        Throw New Exception($"Error posting adhoc payment: {ex.Message}", ex)
                    End Try
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Database error in PostAdhocPaymentPending: {ex.Message}", ex)
        End Try
    End Function
    
    ' =============================================
    ' BANK RECONCILIATION METHODS
    ' =============================================
    
    ''' <summary>
    ''' Reconcile payment with bank statement - updates Bank account
    ''' </summary>
    Public Function ReconcilePaymentWithBankStatement(
        reconciliationID As Integer,
        paymentID As Integer,
        reconciliationType As String,
        userName As String
    ) As Boolean
        
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using trans = conn.BeginTransaction()
                    Try
                        ' 1. Mark bank statement entry as reconciled
                        Dim sql = "UPDATE BankStatementReconciliation
                                   SET IsReconciled = 1,
                                       ReconciliationType = @ReconciliationType,
                                       AdhocPaymentID = @PaymentID,
                                       ReconciledDate = GETDATE(),
                                       ReconciledBy = @UserName
                                   WHERE ReconciliationID = @ReconciliationID"
                        
                        Using cmd As New SqlCommand(sql, conn, trans)
                            cmd.Parameters.AddWithValue("@ReconciliationID", reconciliationID)
                            cmd.Parameters.AddWithValue("@ReconciliationType", reconciliationType)
                            cmd.Parameters.AddWithValue("@PaymentID", paymentID)
                            cmd.Parameters.AddWithValue("@UserName", userName)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' 2. Mark payment as reconciled
                        If reconciliationType = "AdhocPayment" Then
                            sql = "UPDATE AdhocPayments
                                   SET IsReconciled = 1,
                                       ReconciledDate = GETDATE(),
                                       ReconciledBy = @UserName
                                   WHERE PaymentID = @PaymentID"
                        ElseIf reconciliationType = "SupplierPayment" Then
                            sql = "UPDATE SupplierPayments
                                   SET IsReconciled = 1,
                                       ReconciledDate = GETDATE(),
                                       ReconciledBy = @UserName
                                   WHERE PaymentID = @PaymentID"
                        End If
                        
                        Using cmd As New SqlCommand(sql, conn, trans)
                            cmd.Parameters.AddWithValue("@PaymentID", paymentID)
                            cmd.Parameters.AddWithValue("@UserName", userName)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' 3. NOW update Bank account in General Ledger
                        Dim amount As Decimal
                        Dim description As String
                        Dim reference As String
                        Dim branchID As Integer
                        
                        sql = "SELECT Amount, BankDescription, BankReference, BranchID
                               FROM BankStatementReconciliation
                               WHERE ReconciliationID = @ReconciliationID"
                        
                        Using cmd As New SqlCommand(sql, conn, trans)
                            cmd.Parameters.AddWithValue("@ReconciliationID", reconciliationID)
                            Using reader = cmd.ExecuteReader()
                                If reader.Read() Then
                                    amount = CDec(reader("Amount"))
                                    description = reader("BankDescription").ToString()
                                    reference = reader("BankReference").ToString()
                                    branchID = CInt(reader("BranchID"))
                                End If
                            End Using
                        End Using
                        
                        ' Post to General Ledger - Bank account
                        Dim journalNumber = $"BANK-RECON-{reconciliationID}"
                        Dim bankAccountID As Integer
                        
                        Using cmd As New SqlCommand("SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '1120'", conn, trans)
                            bankAccountID = CInt(cmd.ExecuteScalar())
                        End Using
                        
                        Using cmd As New SqlCommand("sp_PostJournalEntry", conn, trans)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.AddWithValue("@JournalNumber", journalNumber)
                            cmd.Parameters.AddWithValue("@AccountID", bankAccountID)
                            cmd.Parameters.AddWithValue("@TransactionType", "BankReconciliation")
                            cmd.Parameters.AddWithValue("@Description", $"Bank reconciliation: {description}")
                            cmd.Parameters.AddWithValue("@DebitAmount", If(amount > 0, amount, 0))
                            cmd.Parameters.AddWithValue("@CreditAmount", If(amount < 0, Math.Abs(amount), 0))
                            cmd.Parameters.AddWithValue("@ReferenceNumber", reference)
                            cmd.Parameters.AddWithValue("@BranchID", branchID)
                            cmd.Parameters.AddWithValue("@CreatedBy", userName)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        trans.Commit()
                        Return True
                        
                    Catch ex As Exception
                        trans.Rollback()
                        Throw New Exception($"Error reconciling payment: {ex.Message}", ex)
                    End Try
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Database error in ReconcilePaymentWithBankStatement: {ex.Message}", ex)
        End Try
    End Function
    
    ' =============================================
    ' HELPER METHODS
    ' =============================================
    
    Private Sub PostCashPaymentToGL(
        conn As SqlConnection,
        trans As SqlTransaction,
        reference As String,
        amount As Decimal,
        description As String,
        branchID As Integer,
        userName As String
    )
        ' Get Cash on Hand account ID
        Dim cashAccountID As Integer
        Using cmd As New SqlCommand("SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '1110'", conn, trans)
            cashAccountID = CInt(cmd.ExecuteScalar())
        End Using
        
        ' Post to General Ledger
        Dim journalNumber = $"CASH-{reference}"
        Using cmd As New SqlCommand("sp_PostJournalEntry", conn, trans)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@JournalNumber", journalNumber)
            cmd.Parameters.AddWithValue("@AccountID", cashAccountID)
            cmd.Parameters.AddWithValue("@TransactionType", "CashPayment")
            cmd.Parameters.AddWithValue("@Description", description)
            cmd.Parameters.AddWithValue("@DebitAmount", amount)
            cmd.Parameters.AddWithValue("@CreditAmount", 0)
            cmd.Parameters.AddWithValue("@ReferenceNumber", reference)
            cmd.Parameters.AddWithValue("@BranchID", branchID)
            cmd.Parameters.AddWithValue("@CreatedBy", userName)
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
End Class

' =============================================
' HELPER CLASSES
' =============================================

Public Class AdhocInvoiceItem
    Public Property ProductID As Integer
    Public Property Description As String
    Public Property Quantity As Decimal
    Public Property UnitPrice As Decimal
    Public Property LineTotal As Decimal
    Public Property TaxRate As Decimal
End Class
