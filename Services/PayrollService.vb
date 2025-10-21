Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class PayrollService
    Private ReadOnly connectionString As String

    Public Sub New()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    ' Settings helpers
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

    ' Fallback: read GLAccountMappings if SystemSettings keys are not present
    Private Function GetMappedAccountId(mappingKey As String, branchId As Integer, con As SqlConnection, tx As SqlTransaction) As Integer?
        ' Prefer branch-specific mapping; else fallback to NULL branch
        Dim sql As String = "SELECT TOP 1 AccountID FROM dbo.GLAccountMappings WHERE MappingKey = @k AND (BranchID = @b OR (BranchID IS NULL AND @b IS NULL)) ORDER BY CASE WHEN BranchID = @b THEN 0 ELSE 1 END"
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@k", mappingKey)
            Dim pB = cmd.Parameters.Add("@b", SqlDbType.Int)
            If branchId > 0 Then pB.Value = branchId Else pB.Value = DBNull.Value
            Dim obj = cmd.ExecuteScalar()
            If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                Return Convert.ToInt32(obj)
            End If
        End Using
        Return Nothing
    End Function

    Private Function GetFiscalPeriodId(docDate As DateTime, con As SqlConnection, tx As SqlTransaction) As Integer
        Using cmd As New SqlCommand("SELECT TOP 1 PeriodID FROM FiscalPeriods WHERE @d BETWEEN StartDate AND EndDate AND IsClosed = 0 ORDER BY StartDate DESC", con, tx)
            cmd.Parameters.AddWithValue("@d", docDate.Date)
            Dim obj = cmd.ExecuteScalar()
            If obj Is Nothing OrElse obj Is DBNull.Value Then Throw New ApplicationException("No open fiscal period for date")
            Return CInt(obj)
        End Using
    End Function

    Private Function CreateJournalHeader(journalDate As DateTime, reference As String, description As String, fiscalPeriodId As Integer, createdBy As Integer, branchId As Integer, con As SqlConnection, tx As SqlTransaction) As Integer
        ' Try the stored procedure first; if it fails due to NULL JournalNumber, fallback to manual insert with a generated number
        Try
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
        Catch ex As SqlException
            Dim msg As String = If(ex.Message, String.Empty).ToLowerInvariant()
            If msg.Contains("journalnumber") OrElse msg.Contains("null into column 'journalnumber'") Then
                ' Generate next document number and insert header manually
                Dim nextNo As String = GetNextDocumentNumber(con, tx, "Journal", branchId, createdBy)
                If String.IsNullOrWhiteSpace(nextNo) Then Throw New ApplicationException("Document numbering for 'Journal' is not configured.", ex)
                Using cmd As New SqlCommand("INSERT INTO dbo.JournalHeaders (JournalNumber, JournalDate, Reference, Description, FiscalPeriodID, CreatedBy, BranchID, IsPosted) VALUES (@jn, @jd, @ref, @desc, @fp, @cb, @bid, 0); SELECT CAST(SCOPE_IDENTITY() AS int);", con, tx)
                    cmd.Parameters.AddWithValue("@jn", nextNo)
                    cmd.Parameters.AddWithValue("@jd", journalDate.Date)
                    cmd.Parameters.AddWithValue("@ref", If(reference, CType(DBNull.Value, Object)))
                    cmd.Parameters.AddWithValue("@desc", If(description, CType(DBNull.Value, Object)))
                    cmd.Parameters.AddWithValue("@fp", fiscalPeriodId)
                    cmd.Parameters.AddWithValue("@cb", createdBy)
                    cmd.Parameters.AddWithValue("@bid", branchId)
                    Dim res = cmd.ExecuteScalar()
                    Return Convert.ToInt32(res)
                End Using
            End If
            Throw
        End Try
    End Function

    Private Function GetNextDocumentNumber(con As SqlConnection, tx As SqlTransaction, docType As String, branchId As Integer, userId As Integer) As String
        Using cmd As New SqlCommand("sp_GetNextDocumentNumber", con, tx)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@DocumentType", docType)
            cmd.Parameters.AddWithValue("@BranchID", branchId)
            cmd.Parameters.AddWithValue("@UserID", userId)
            Dim pOut As New SqlParameter("@NextDocNumber", SqlDbType.VarChar, 50) With {.Direction = ParameterDirection.Output}
            cmd.Parameters.Add(pOut)
            cmd.ExecuteNonQuery()
            Dim result As Object = pOut.Value
            If result IsNot Nothing AndAlso result IsNot DBNull.Value Then
                Return Convert.ToString(result)
            End If
        End Using
        Return Nothing
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

    ' Payroll accrual: DR Payroll Expense; CR Payroll Liabilities (net + deductions)
    Public Function AccruePayroll(payDate As DateTime, reference As String, gross As Decimal, deductions As Decimal, createdBy As Integer, branchId As Integer) As Integer
        If gross <= 0D Then Throw New ArgumentException("Gross must be > 0")
        If deductions < 0D Then Throw New ArgumentException("Deductions cannot be negative")
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    Dim expAcct = GetSettingInt("PayrollExpenseAccountID", con, tx)
                    Dim liabAcct = GetSettingInt("PayrollLiabilityAccountID", con, tx) ' Net payable + statutory
                    ' Fallback to GLAccountMappings if settings are missing
                    If Not expAcct.HasValue Then expAcct = GetMappedAccountId("PayrollExpense", branchId, con, tx)
                    If Not liabAcct.HasValue Then liabAcct = GetMappedAccountId("PayrollLiability", branchId, con, tx)
                    If Not expAcct.HasValue OrElse Not liabAcct.HasValue Then
                        Throw New ApplicationException("System settings missing: PayrollExpenseAccountID and/or PayrollLiabilityAccountID")
                    End If
                    Dim fiscal = GetFiscalPeriodId(payDate, con, tx)
                    Dim desc = If(String.IsNullOrWhiteSpace(reference), $"Payroll Accrual {payDate:yyyy-MM}", reference)
                    Dim jId = CreateJournalHeader(payDate, reference, desc, fiscal, createdBy, branchId, con, tx)
                    ' DR Payroll Expense (gross)
                    AddJournalDetail(jId, expAcct.Value, Math.Round(gross, 2), 0D, desc, reference, Nothing, con, tx)
                    ' CR Payroll Liability (gross)
                    AddJournalDetail(jId, liabAcct.Value, 0D, Math.Round(gross, 2), desc, reference, Nothing, con, tx)
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

    ' Payroll payment: DR Payroll Liability; CR Bank (net paid)
    Public Function PayPayroll(payDate As DateTime, reference As String, netPay As Decimal, createdBy As Integer, branchId As Integer) As Integer
        If netPay <= 0D Then Throw New ArgumentException("Net pay must be > 0")
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    Dim liabAcct = GetSettingInt("PayrollLiabilityAccountID", con, tx)
                    Dim bankAcct = GetSettingInt("BANK_DEFAULT", con, tx)
                    ' Fallbacks to mappings
                    If Not liabAcct.HasValue Then liabAcct = GetMappedAccountId("PayrollLiability", branchId, con, tx)
                    If Not bankAcct.HasValue Then bankAcct = GetMappedAccountId("Bank", branchId, con, tx)
                    If Not liabAcct.HasValue OrElse Not bankAcct.HasValue Then
                        Throw New ApplicationException("System settings missing: PayrollLiabilityAccountID and/or BANK_DEFAULT")
                    End If
                    Dim fiscal = GetFiscalPeriodId(payDate, con, tx)
                    Dim desc = If(String.IsNullOrWhiteSpace(reference), $"Payroll Payment {payDate:yyyy-MM}", reference)
                    Dim jId = CreateJournalHeader(payDate, reference, desc, fiscal, createdBy, branchId, con, tx)
                    ' DR Payroll Liability
                    AddJournalDetail(jId, liabAcct.Value, Math.Round(netPay, 2), 0D, desc, reference, Nothing, con, tx)
                    ' CR Bank
                    AddJournalDetail(jId, bankAcct.Value, 0D, Math.Round(netPay, 2), desc, reference, Nothing, con, tx)
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
