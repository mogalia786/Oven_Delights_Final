Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports Oven_Delights_ERP.Accounting

Public Class AccountsPayableService
    Private ReadOnly connectionString As String

    Public Sub New()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    ' Returns the open fiscal period ID for the given date or throws if none
    Private Function GetFiscalPeriodId(docDate As DateTime, con As SqlConnection, tx As SqlTransaction) As Integer
        Using cmd As New SqlCommand("SELECT TOP 1 PeriodID FROM FiscalPeriods WHERE @d BETWEEN StartDate AND EndDate AND IsClosed = 0 ORDER BY StartDate DESC", con, tx)
            cmd.Parameters.AddWithValue("@d", docDate.Date)
            Dim obj = cmd.ExecuteScalar()
            If obj Is Nothing OrElse obj Is DBNull.Value Then
                Throw New ApplicationException("No open fiscal period for date")
            End If
            Return Convert.ToInt32(obj)
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

    Private Function GetSupplierRef(supplierId As Integer, con As SqlConnection, tx As SqlTransaction) As String
        Using cmd As New SqlCommand("SELECT ISNULL(NULLIF(LTRIM(RTRIM(SupplierCode)), ''), CompanyName) FROM Suppliers WHERE SupplierID = @sid", con, tx)
            cmd.Parameters.AddWithValue("@sid", supplierId)
            Dim obj = cmd.ExecuteScalar()
            If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                Dim v = Convert.ToString(obj)
                If Not String.IsNullOrWhiteSpace(v) Then Return v
            End If
        End Using
        Return supplierId.ToString()
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
            ' Ensure presence of @LineNumber OUTPUT to satisfy proc signature
            Dim lineOut As New SqlParameter("@LineNumber", SqlDbType.Int)
            lineOut.Direction = ParameterDirection.Output
            cmd.Parameters.Add(lineOut)
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

    Private Sub EnsureNoDuplicateSupplierInvoice(apAccountId As Integer, supplierRef As String, supplierInvoiceNo As String, con As SqlConnection, tx As SqlTransaction)
        ' Prevent capturing the same supplier invoice twice by checking existing AP Control lines with same references
        Dim sql = "SELECT TOP 1 1 FROM JournalDetails d INNER JOIN JournalHeaders h ON h.JournalID = d.JournalID " & _
                  "WHERE d.AccountID = @AP AND d.Reference1 = @R1 AND d.Reference2 = @R2"
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@AP", apAccountId)
            cmd.Parameters.AddWithValue("@R1", supplierRef)
            cmd.Parameters.AddWithValue("@R2", supplierInvoiceNo)
            Dim exists = cmd.ExecuteScalar()
            If exists IsNot Nothing AndAlso exists IsNot DBNull.Value Then
                Throw New ApplicationException("This supplier invoice already exists for the supplier.")
            End If
        End Using
    End Sub

    ' Posts a Supplier Invoice: DR GRIR; CR AP Control. Returns JournalID.
    Public Function CreateSupplierInvoice(supplierId As Integer, supplierInvoiceNo As String, branchId As Integer, invoiceDate As DateTime, amount As Decimal, createdBy As Integer, Optional description As String = Nothing, Optional grnNumbers As IEnumerable(Of String) = Nothing) As Integer
        If supplierId <= 0 Then Throw New ArgumentException("supplierId required")
        If String.IsNullOrWhiteSpace(supplierInvoiceNo) Then Throw New ArgumentException("Supplier invoice number required")
        If amount <= 0D Then Throw New ArgumentException("Amount must be > 0")

        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Prefer GLAccountMappings; fallback to SystemSettings
                    Dim branchIdForMapping As Integer = branchId
                    Dim grirId As Integer = GLMapping.GetMappedAccountId(con, "GRIR", branchIdForMapping, tx)
                    Dim apId As Integer = GLMapping.GetMappedAccountId(con, "Creditors", branchIdForMapping, tx)
                    Dim grirAcct As Integer? = If(grirId > 0, grirId, GetSettingInt("GRIRAccountID", con, tx))
                    Dim apAcct As Integer? = If(apId > 0, apId, GetSettingInt("APControlAccountID", con, tx))
                    If Not grirAcct.HasValue OrElse grirAcct.Value <= 0 OrElse Not apAcct.HasValue OrElse apAcct.Value <= 0 Then
                        Throw New ApplicationException("AP posting skipped: configure GL mappings for 'GRIR' and 'Creditors' (or set SystemSettings GRIRAccountID/APControlAccountID).")
                    End If

                    Dim supplierRef = GetSupplierRef(supplierId, con, tx)
                    EnsureNoDuplicateSupplierInvoice(apAcct.Value, supplierRef, supplierInvoiceNo, con, tx)

                    Dim fiscalId = GetFiscalPeriodId(invoiceDate, con, tx)
                    Dim desc As String = If(description, $"AP Inv {supplierInvoiceNo} - {supplierRef}")
                    If grnNumbers IsNot Nothing Then
                        Dim list = String.Join(",", grnNumbers)
                        If Not String.IsNullOrWhiteSpace(list) Then desc &= $" - GRV {list}"
                    End If

                    Dim journalId = CreateJournalHeader(invoiceDate, supplierInvoiceNo, desc, fiscalId, createdBy, branchId, con, tx)

                    ' DR GRIR
                    AddJournalDetail(journalId, grirAcct.Value, Math.Round(amount, 2), 0D, desc, supplierRef, supplierInvoiceNo, con, tx)
                    ' CR AP Control
                    AddJournalDetail(journalId, apAcct.Value, 0D, Math.Round(amount, 2), desc, supplierRef, supplierInvoiceNo, con, tx)

                    PostJournal(journalId, createdBy, con, tx)
                    tx.Commit()
                    Return journalId
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Function

    ' Posts a Supplier Credit Note: DR AP Control; CR GRIR. Returns JournalID.
    Public Function CreateSupplierCreditNote(supplierId As Integer, creditNoteNo As String, branchId As Integer, creditDate As DateTime, amount As Decimal, createdBy As Integer, Optional description As String = Nothing) As Integer
        If supplierId <= 0 Then Throw New ArgumentException("supplierId required")
        If String.IsNullOrWhiteSpace(creditNoteNo) Then Throw New ArgumentException("Supplier credit note number required")
        If amount <= 0D Then Throw New ArgumentException("Amount must be > 0")

        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Prefer GLAccountMappings per-branch; fallback to SystemSettings
                    Dim branchIdForMapping As Integer = branchId
                    Dim grirId As Integer = GLMapping.GetMappedAccountId(con, "GRIR", branchIdForMapping, tx)
                    Dim apId As Integer = GLMapping.GetMappedAccountId(con, "Creditors", branchIdForMapping, tx)
                    Dim grirAcct As Integer? = If(grirId > 0, grirId, GetSettingInt("GRIRAccountID", con, tx))
                    Dim apAcct As Integer? = If(apId > 0, apId, GetSettingInt("APControlAccountID", con, tx))
                    If Not grirAcct.HasValue OrElse grirAcct.Value <= 0 OrElse Not apAcct.HasValue OrElse apAcct.Value <= 0 Then
                        Throw New ApplicationException("AP credit posting skipped: configure GL mappings for 'GRIR' and 'Creditors' (or set SystemSettings GRIRAccountID/APControlAccountID).")
                    End If

                    Dim supplierRef = GetSupplierRef(supplierId, con, tx)
                    Dim fiscalId = GetFiscalPeriodId(creditDate, con, tx)
                    Dim desc As String = If(description, $"AP CN {creditNoteNo} - {supplierRef}")

                    Dim journalId = CreateJournalHeader(creditDate, creditNoteNo, desc, fiscalId, createdBy, branchId, con, tx)

                    ' DR AP Control
                    AddJournalDetail(journalId, apAcct.Value, Math.Round(amount, 2), 0D, desc, supplierRef, creditNoteNo, con, tx)
                    ' CR GRIR
                    AddJournalDetail(journalId, grirAcct.Value, 0D, Math.Round(amount, 2), desc, supplierRef, creditNoteNo, con, tx)

                    PostJournal(journalId, createdBy, con, tx)
                    tx.Commit()
                    Return journalId
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Function

End Class
