Imports System.Data
Imports Microsoft.Data.SqlClient

Public Class AccountingPostingService
    Private ReadOnly _connStr As String

    Public Sub New()
        _connStr = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    ' Gets next document number following Branch/Role/Type rules
    Public Function GetNextDocumentNumber(documentType As String, branchId As Integer, userId As Integer) As String
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_GetNextDocumentNumber", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@DocumentType", documentType)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                cmd.Parameters.AddWithValue("@UserID", userId)
                Dim outParam As New SqlParameter("@NextDocNumber", SqlDbType.VarChar, 50)
                outParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToString(outParam.Value)
            End Using
        End Using
    End Function

    ' Creates a journal header and returns JournalID
    Public Function CreateJournalEntry(journalDate As Date, reference As String, description As String, fiscalPeriodId As Integer, createdBy As Integer, branchId As Integer, Optional journalNumber As String = Nothing) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_CreateJournalEntry", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@FiscalPeriodID", fiscalPeriodId)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outParam As New SqlParameter("@JournalID", SqlDbType.Int)
                outParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function

    ' Adds a line to a journal and returns the LineNumber
    Public Function AddJournalDetail(journalId As Integer, accountId As Integer, debit As Decimal, credit As Decimal, Optional lineDescription As String = Nothing, Optional reference1 As String = Nothing, Optional reference2 As String = Nothing, Optional costCenterId As Integer? = Nothing, Optional projectId As Integer? = Nothing) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_AddJournalDetail", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@JournalID", journalId)
                cmd.Parameters.AddWithValue("@AccountID", accountId)
                cmd.Parameters.AddWithValue("@Debit", debit)
                cmd.Parameters.AddWithValue("@Credit", credit)
                cmd.Parameters.AddWithValue("@Description", If(lineDescription, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Reference1", If(reference1, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Reference2", If(reference2, CType(DBNull.Value, Object)))
                If costCenterId.HasValue Then
                    cmd.Parameters.AddWithValue("@CostCenterID", costCenterId.Value)
                Else
                    cmd.Parameters.AddWithValue("@CostCenterID", CType(DBNull.Value, Object))
                End If
                If projectId.HasValue Then
                    cmd.Parameters.AddWithValue("@ProjectID", projectId.Value)
                Else
                    cmd.Parameters.AddWithValue("@ProjectID", CType(DBNull.Value, Object))
                End If
                Dim outParam As New SqlParameter("@LineNumber", SqlDbType.Int)
                outParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function

    ' Posts a journal (updates balances)
    Public Sub PostJournal(journalId As Integer, postedBy As Integer)
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_PostJournal", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@JournalID", journalId)
                cmd.Parameters.AddWithValue("@PostedBy", postedBy)
                cn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    ' Helper: Go-to accounts (these would normally be configurable). Replace with lookups as needed.
    Public Function GetInventoryAccountId() As Integer
        Return GetSystemAccountId("INVENTORY")
    End Function

    Public Function GetGRIRAccountId() As Integer
        Return GetSystemAccountId("GRIR")
    End Function

    Public Function GetAPControlAccountId() As Integer
        Return GetSystemAccountId("AP_CONTROL")
    End Function

    Public Function GetBankAccountId() As Integer
        Return GetSystemAccountId("BANK_DEFAULT")
    End Function

    Public Function GetWIPAccountId() As Integer
        Return GetSystemAccountId("WIP")
    End Function

    Public Function GetSystemAccountId(key As String) As Integer
        If String.IsNullOrWhiteSpace(key) Then Return 0
        Try
            Using cn As New SqlConnection(_connStr)
                Using cmd As New SqlCommand("SELECT AccountID FROM dbo.SystemAccounts WHERE SysKey = @k", cn)
                    cmd.Parameters.AddWithValue("@k", key)
                    cn.Open()
                    Dim obj = cmd.ExecuteScalar()
                    If obj IsNot Nothing AndAlso Not Convert.IsDBNull(obj) Then
                        Dim id As Integer
                        If Integer.TryParse(obj.ToString(), id) Then Return id
                    End If
                End Using
            End Using
        Catch
        End Try
        Return 0
    End Function

    ' Ensure a GL account exists for the supplier as a creditor sub-account. Returns AccountID.
    Public Function EnsureSupplierCreditorAccount(supplierId As Integer, supplierName As String) As Integer
        ' Replace with actual implementation when GLAccounts schema/dictionary is ready.
        ' Strategy:
        ' 1) Try find existing GLAccounts row mapped to this SupplierID.
        ' 2) If missing, create under AP Control parent.
        ' 3) Return AccountID.
        Return 0
    End Function

    ' ============ AP (Suppliers) ============
    Public Function PostAPSupplierInvoice(invoiceId As Integer, supplierId As Integer, journalDate As Date, amount As Decimal, useGRNI As Boolean, reference As String, description As String, createdBy As Integer, branchId As Integer) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_AP_Post_SupplierInvoice", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                cmd.Parameters.AddWithValue("@SupplierID", supplierId)
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@Amount", amount)
                cmd.Parameters.AddWithValue("@UseGRNI", If(useGRNI, 1, 0))
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outParam As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function

    Public Function PostAPSupplierCredit(creditNoteId As Integer, supplierId As Integer, journalDate As Date, amount As Decimal, usePurchaseReturns As Boolean, reference As String, description As String, createdBy As Integer, branchId As Integer) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_AP_Post_SupplierCredit", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@CreditNoteID", creditNoteId)
                cmd.Parameters.AddWithValue("@SupplierID", supplierId)
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@Amount", amount)
                cmd.Parameters.AddWithValue("@UsePurchaseReturns", If(usePurchaseReturns, 1, 0))
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outParam As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function

    Public Function PostAPSupplierPayment(paymentId As Integer, supplierId As Integer, journalDate As Date, amount As Decimal, reference As String, description As String, createdBy As Integer, branchId As Integer) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_AP_Post_SupplierPayment", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@PaymentID", paymentId)
                cmd.Parameters.AddWithValue("@SupplierID", supplierId)
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@Amount", amount)
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outParam As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function

    ' ============ AR (Customers) ============
    Public Function PostARCustomerInvoice(invoiceId As Integer, customerId As Integer, journalDate As Date, netAmount As Decimal, vatAmount As Decimal, cogsAmount As Decimal, reference As String, description As String, createdBy As Integer, branchId As Integer) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_AR_Post_CustomerInvoice", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                cmd.Parameters.AddWithValue("@CustomerID", customerId)
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@NetAmount", netAmount)
                cmd.Parameters.AddWithValue("@VATAmount", vatAmount)
                cmd.Parameters.AddWithValue("@COGSAmount", cogsAmount)
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outParam As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function

    Public Function PostARCustomerCredit(creditNoteId As Integer, customerId As Integer, journalDate As Date, netAmount As Decimal, vatAmount As Decimal, cogsReturn As Decimal, reference As String, description As String, createdBy As Integer, branchId As Integer) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_AR_Post_CustomerCredit", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@CreditNoteID", creditNoteId)
                cmd.Parameters.AddWithValue("@CustomerID", customerId)
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@NetAmount", netAmount)
                cmd.Parameters.AddWithValue("@VATAmount", vatAmount)
                cmd.Parameters.AddWithValue("@COGSReturn", cogsReturn)
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outParam As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function

    Public Function PostARCustomerReceipt(receiptId As Integer, customerId As Integer, journalDate As Date, amount As Decimal, reference As String, description As String, createdBy As Integer, branchId As Integer) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_AR_Post_CustomerReceipt", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ReceiptID", receiptId)
                cmd.Parameters.AddWithValue("@CustomerID", customerId)
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@Amount", amount)
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outParam As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function

    ' ============ Expenses ============
    Public Function PostExpenseBill(expenseId As Integer, journalDate As Date, expenseAccountId As Integer, netAmount As Decimal, vatAmount As Decimal, viaAP As Boolean, reference As String, description As String, createdBy As Integer, branchId As Integer) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_Exp_Post_Bill", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ExpenseID", expenseId)
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@ExpenseAccountID", expenseAccountId)
                cmd.Parameters.AddWithValue("@NetAmount", netAmount)
                cmd.Parameters.AddWithValue("@VATAmount", vatAmount)
                cmd.Parameters.AddWithValue("@ViaAP", If(viaAP, 1, 0))
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outParam As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function

    Public Function PostExpensePayment(paymentId As Integer, journalDate As Date, amount As Decimal, reference As String, description As String, createdBy As Integer, branchId As Integer) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_Exp_Post_Payment", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@PaymentID", paymentId)
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@Amount", amount)
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outParam As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function

    ' ============ Bank ============
    Public Function PostBankCharge(chargeId As Integer, journalDate As Date, amount As Decimal, reference As String, description As String, createdBy As Integer, branchId As Integer) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_Bank_Post_Charge", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ChargeID", chargeId)
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@Amount", amount)
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outParam As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function

    Public Function PostBankTransfer(transferId As Integer, journalDate As Date, amount As Decimal, fromBankAccountId As Integer, toBankAccountId As Integer, reference As String, description As String, createdBy As Integer, branchId As Integer) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("sp_Bank_Post_Transfer", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@TransferID", transferId)
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@Amount", amount)
                cmd.Parameters.AddWithValue("@FromBankAccountID", fromBankAccountId)
                cmd.Parameters.AddWithValue("@ToBankAccountID", toBankAccountId)
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outParam As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outParam)
                cn.Open()
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outParam.Value)
            End Using
        End Using
    End Function
End Class
