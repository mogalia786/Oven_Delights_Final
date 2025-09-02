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

    Private Function GetSystemAccountId(key As String) As Integer
        ' Placeholder: swap for table-driven config if present
        ' For now, assume a mapping table or a view exists. Return 0 to force caller to validate.
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
End Class
