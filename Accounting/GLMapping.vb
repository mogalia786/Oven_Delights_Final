' GLMapping.vb
' Central helper to resolve GL accounts via GLAccountMappings with optional branch override.
Imports Microsoft.Data.SqlClient

Namespace Accounting
    Public Module GLMapping
        Public Function GetMappedAccountId(con As SqlConnection, mappingKey As String, branchId As Integer) As Integer
            ' 1) Exact branch mapping
            Using cmd As New SqlCommand("SELECT TOP 1 AccountID FROM dbo.GLAccountMappings WHERE MappingKey = @k AND BranchID = @b AND AccountID IS NOT NULL", con)
                cmd.Parameters.AddWithValue("@k", mappingKey)
                cmd.Parameters.AddWithValue("@b", branchId)
                Dim o = cmd.ExecuteScalar()
                If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return Convert.ToInt32(o)
            End Using
            ' 2) Global mapping (no BranchID)
            Using cmd As New SqlCommand("SELECT TOP 1 AccountID FROM dbo.GLAccountMappings WHERE MappingKey = @k AND BranchID IS NULL AND AccountID IS NOT NULL", con)
                cmd.Parameters.AddWithValue("@k", mappingKey)
                Dim o = cmd.ExecuteScalar()
                If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return Convert.ToInt32(o)
            End Using
            Return 0
        End Function

        ' Overload that enlists commands in the provided transaction
        Public Function GetMappedAccountId(con As SqlConnection, mappingKey As String, branchId As Integer, tx As SqlTransaction) As Integer
            ' 1) Exact branch mapping
            Using cmd As New SqlCommand("SELECT TOP 1 AccountID FROM dbo.GLAccountMappings WHERE MappingKey = @k AND BranchID = @b AND AccountID IS NOT NULL", con, tx)
                cmd.Parameters.AddWithValue("@k", mappingKey)
                cmd.Parameters.AddWithValue("@b", branchId)
                Dim o = cmd.ExecuteScalar()
                If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return Convert.ToInt32(o)
            End Using
            ' 2) Global mapping (no BranchID)
            Using cmd As New SqlCommand("SELECT TOP 1 AccountID FROM dbo.GLAccountMappings WHERE MappingKey = @k AND BranchID IS NULL AND AccountID IS NOT NULL", con, tx)
                cmd.Parameters.AddWithValue("@k", mappingKey)
                Dim o = cmd.ExecuteScalar()
                If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return Convert.ToInt32(o)
            End Using
            Return 0
        End Function
    End Module
End Namespace
