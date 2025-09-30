Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class AccountsReceivableService
    Private ReadOnly connectionString As String

    Public Sub New()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    ' Utilities
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

    ' Minimal customer reference (extend when Customers master table is finalized)
    Private Function GetCustomerRef(customerId As Integer, con As SqlConnection, tx As SqlTransaction) As String
        ' Get customer reference from Customers table or fallback to ID
        Try
            Using cmd As New SqlCommand("SELECT TOP 1 ISNULL(NULLIF(LTRIM(RTRIM(CustomerCode)), ''), CompanyName) FROM Customers WHERE CustomerID = @id", con, tx)
                cmd.Parameters.AddWithValue("@id", customerId)
                Dim obj = cmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Dim v = Convert.ToString(obj)
                    If Not String.IsNullOrWhiteSpace(v) Then Return v
                End If
            End Using
        Catch
        End Try
        Return customerId.ToString()
    End Function

    ' Debtors Journal: Customer Invoice
    ' DR AR Control; CR Revenue
    Public Function CreateCustomerInvoice(customerId As Integer, customerInvoiceNo As String, branchId As Integer, invoiceDate As DateTime, amount As Decimal, createdBy As Integer, Optional description As String = Nothing) As Integer
        If customerId <= 0 Then Throw New ArgumentException("customerId required")
        If String.IsNullOrWhiteSpace(customerInvoiceNo) Then Throw New ArgumentException("Customer invoice number required")
        If amount <= 0D Then Throw New ArgumentException("Amount must be > 0")

        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    Dim arAcct = GetSettingInt("ARControlAccountID", con, tx)
                    Dim revAcct = GetSettingInt("RevenueAccountID", con, tx)
                    If Not arAcct.HasValue OrElse Not revAcct.HasValue Then
                        Throw New ApplicationException("System settings missing: ARControlAccountID and/or RevenueAccountID")
                    End If

                    Dim custRef = GetCustomerRef(customerId, con, tx)
                    Dim fiscalId = GetFiscalPeriodId(invoiceDate, con, tx)
                    Dim desc As String = If(description, $"AR Inv {customerInvoiceNo} - {custRef}")

                    Dim jId = CreateJournalHeader(invoiceDate, customerInvoiceNo, desc, fiscalId, createdBy, branchId, con, tx)
                    ' DR AR Control
                    AddJournalDetail(jId, arAcct.Value, Math.Round(amount, 2), 0D, desc, custRef, customerInvoiceNo, con, tx)
                    ' CR Revenue
                    AddJournalDetail(jId, revAcct.Value, 0D, Math.Round(amount, 2), desc, custRef, customerInvoiceNo, con, tx)

                    PostJournal(jId, createdBy, con, tx)
                    tx.Commit()
                    Return jId
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Function

    ' Debtors Journal: Customer Credit Note
    ' DR Revenue; CR AR Control
    Public Function CreateCustomerCreditNote(customerId As Integer, creditNoteNo As String, branchId As Integer, creditDate As DateTime, amount As Decimal, createdBy As Integer, Optional description As String = Nothing) As Integer
        If customerId <= 0 Then Throw New ArgumentException("customerId required")
        If String.IsNullOrWhiteSpace(creditNoteNo) Then Throw New ArgumentException("Customer credit note number required")
        If amount <= 0D Then Throw New ArgumentException("Amount must be > 0")

        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    Dim arAcct = GetSettingInt("ARControlAccountID", con, tx)
                    Dim revAcct = GetSettingInt("RevenueAccountID", con, tx)
                    If Not arAcct.HasValue OrElse Not revAcct.HasValue Then
                        Throw New ApplicationException("System settings missing: ARControlAccountID and/or RevenueAccountID")
                    End If

                    Dim custRef = GetCustomerRef(customerId, con, tx)
                    Dim fiscalId = GetFiscalPeriodId(creditDate, con, tx)
                    Dim desc As String = If(description, $"AR CN {creditNoteNo} - {custRef}")

                    Dim jId = CreateJournalHeader(creditDate, creditNoteNo, desc, fiscalId, createdBy, branchId, con, tx)
                    ' DR Revenue
                    AddJournalDetail(jId, revAcct.Value, Math.Round(amount, 2), 0D, desc, custRef, creditNoteNo, con, tx)
                    ' CR AR Control
                    AddJournalDetail(jId, arAcct.Value, 0D, Math.Round(amount, 2), desc, custRef, creditNoteNo, con, tx)

                    PostJournal(jId, createdBy, con, tx)
                    tx.Commit()
                    Return jId
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Function
End Class
