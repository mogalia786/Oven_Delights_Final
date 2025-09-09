Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

' Placeholder service for Cashbook operations (receipts/payments)
' Aligns with Journal SPs and SystemSettings but defers full implementation until banking module is finalized.
Public Class CashbookService
    Private ReadOnly connectionString As String

    Public Sub New()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    ' Helpers (available for future implementation)
    Private Function GetFiscalPeriodId(docDate As DateTime, con As SqlConnection, tx As SqlTransaction) As Integer
        Using cmd As New SqlCommand("SELECT TOP 1 PeriodID FROM FiscalPeriods WHERE @d BETWEEN StartDate AND EndDate AND IsClosed = 0 ORDER BY StartDate DESC", con, tx)
            cmd.Parameters.AddWithValue("@d", docDate.Date)
            Dim obj = cmd.ExecuteScalar()
            If obj Is Nothing OrElse obj Is DBNull.Value Then Throw New ApplicationException("No open fiscal period for date")
            Return CInt(obj)
        End Using
    End Function

    Private Function GetSettingInt(key As String, con As SqlConnection, tx As SqlTransaction) As Integer?
        Using cmd As New SqlCommand("SELECT [Value] FROM SystemSettings WHERE [Key] = @k", con, tx)
            cmd.Parameters.AddWithValue("@k", key)
            Dim obj = cmd.ExecuteScalar()
            If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                Dim s As String = Convert.ToString(obj)
                Dim v As Integer
                If Integer.TryParse(s, v) Then Return v
            End If
        End Using
        Return Nothing
    End Function

    Private Function CreateJournalHeader(journalDate As DateTime, reference As String, description As String, fiscalPeriodId As Integer, createdBy As Integer, branchId As Integer, con As SqlConnection, tx As SqlTransaction) As Integer
        Using cmd As New SqlCommand("sp_CreateJournalEntry", con, tx)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@JournalDate", journalDate.Date)
            cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
            cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
            cmd.Parameters.AddWithValue("@FiscalPeriodID", fiscalPeriodId)
            cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
            cmd.Parameters.AddWithValue("@BranchID", branchId)
            Dim outId As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
            cmd.Parameters.Add(outId)
            cmd.ExecuteNonQuery()
            Return CInt(outId.Value)
        End Using
    End Function

    Private Sub AddJournalDetail(journalId As Integer, accountId As Integer, debit As Decimal, credit As Decimal, description As String, ref1 As String, ref2 As String, con As SqlConnection, tx As SqlTransaction)
        Using cmd As New SqlCommand("sp_AddJournalDetail", con, tx)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@JournalID", journalId)
            cmd.Parameters.AddWithValue("@AccountID", accountId)
            cmd.Parameters.AddWithValue("@Debit", debit)
            cmd.Parameters.AddWithValue("@Credit", credit)
            cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
            cmd.Parameters.AddWithValue("@Reference1", If(String.IsNullOrWhiteSpace(ref1), CType(DBNull.Value, Object), ref1))
            cmd.Parameters.AddWithValue("@Reference2", If(String.IsNullOrWhiteSpace(ref2), CType(DBNull.Value, Object), ref2))
            cmd.Parameters.AddWithValue("@CostCenterID", DBNull.Value)
            cmd.Parameters.AddWithValue("@ProjectID", DBNull.Value)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Sub PostJournal(journalId As Integer, postedBy As Integer, con As SqlConnection, tx As SqlTransaction)
        Using cmd As New SqlCommand("sp_PostJournal", con, tx)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@JournalID", journalId)
            cmd.Parameters.AddWithValue("@PostedBy", postedBy)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    ' --- Public placeholders ---
    ' Bank receipt (from customer or other): DR Bank; CR AR Control or Other Income
    Public Function RecordReceipt(bankAccountId As Integer, counterpartyRef As String, receiptNo As String, branchId As Integer, receiptDate As DateTime, amount As Decimal, createdBy As Integer, Optional description As String = Nothing) As Integer
        ' Placeholder: to be completed when bank accounts and mappings are finalized.
        Throw New NotImplementedException("Cashbook receipt posting will be implemented after banking module setup.")
    End Function

    ' Bank payment (to supplier or other): DR Expense/AP Control; CR Bank
    Public Function RecordPayment(bankAccountId As Integer, counterpartyRef As String, paymentNo As String, branchId As Integer, paymentDate As DateTime, amount As Decimal, createdBy As Integer, Optional description As String = Nothing) As Integer
        ' Placeholder: to be completed when bank accounts and mappings are finalized.
        Throw New NotImplementedException("Cashbook payment posting will be implemented after banking module setup.")
    End Function

    ' Bank charges: DR Bank Charges Expense; CR Bank
    Public Function RecordBankCharge(bankAccountId As Integer, chargeRef As String, branchId As Integer, chargeDate As DateTime, amount As Decimal, createdBy As Integer, Optional description As String = Nothing) As Integer
        ' Placeholder: to be completed when bank accounts and mappings are finalized.
        Throw New NotImplementedException("Cashbook bank charge posting will be implemented after banking module setup.")
    End Function
End Class
