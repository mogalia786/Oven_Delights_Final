Imports System.Data
Imports Microsoft.Data.SqlClient

Public Class PostingService
    Private ReadOnly connectionString As String

    Public Sub New()
        connectionString = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Public Function GetFiscalPeriodId(postDate As Date) As Integer
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using cmd As New SqlCommand("SELECT TOP 1 PeriodID FROM FiscalPeriods WHERE @d >= StartDate AND @d <= EndDate AND IsClosed = 0 ORDER BY StartDate DESC", con)
                cmd.Parameters.AddWithValue("@d", postDate.Date)
                Dim obj = cmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Return Convert.ToInt32(obj)
                End If
            End Using
        End Using
        Return 0
    End Function

    Public Function CreateJournalEntry(journalDate As Date, reference As String, description As String, createdBy As Integer, branchId As Integer) As Integer
        Dim fiscalId = GetFiscalPeriodId(journalDate)
        If fiscalId = 0 Then Throw New InvalidOperationException("No open fiscal period for the posting date.")
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using cmd As New SqlCommand("sp_CreateJournalEntry", con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@JournalDate", journalDate)
                cmd.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@FiscalPeriodID", fiscalId)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim outId As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outId)
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(outId.Value)
            End Using
        End Using
    End Function

    Public Sub AddJournalDetail(journalId As Integer, accountId As Integer, debit As Decimal, credit As Decimal, description As String, ref1 As String, ref2 As String)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using cmd As New SqlCommand("sp_AddJournalDetail", con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@JournalID", journalId)
                cmd.Parameters.AddWithValue("@AccountID", accountId)
                cmd.Parameters.AddWithValue("@Debit", debit)
                cmd.Parameters.AddWithValue("@Credit", credit)
                cmd.Parameters.AddWithValue("@Description", If(description, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Reference1", If(ref1, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@Reference2", If(ref2, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@CostCenterID", CType(DBNull.Value, Object))
                cmd.Parameters.AddWithValue("@ProjectID", CType(DBNull.Value, Object))
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Sub PostJournal(journalId As Integer, postedBy As Integer)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using cmd As New SqlCommand("sp_PostJournal", con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@JournalID", journalId)
                cmd.Parameters.AddWithValue("@PostedBy", postedBy)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub
End Class
