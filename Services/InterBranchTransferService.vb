Imports System.Data
Imports Microsoft.Data.SqlClient

Public Class InterBranchTransferService
    Private ReadOnly _connStr As String
    Private ReadOnly stockroomService As New StockroomService()
    
    Public Sub New()
        _connStr = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Public Function CreateTransferFromRequest(requestId As Integer, createdBy As Integer) As Integer
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("dbo.sp_IBT_Create", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@RequestID", requestId)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cn.Open()
                Dim transferId As Integer = 0
                Using rdr = cmd.ExecuteReader()
                    If rdr.Read() Then
                        transferId = Convert.ToInt32(rdr("TransferID"))
                    End If
                End Using
                Return transferId
            End Using
        End Using
    End Function

    Public Function ListPendingRequests(toBranchId As Integer) As DataTable
        Using cn As New SqlConnection(_connStr)
            Using da As New SqlDataAdapter("dbo.sp_IBT_ListPending", cn)
                da.SelectCommand.CommandType = CommandType.StoredProcedure
                da.SelectCommand.Parameters.AddWithValue("@ToBranchID", toBranchId)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            End Using
        End Using
    End Function

    Public Function PostTransfer(transferId As Integer, postedBy As Integer) As (IntPo As String, InterInv As String)
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("dbo.sp_IBT_Post", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@TransferID", transferId)
                cmd.Parameters.AddWithValue("@PostedBy", postedBy)
                cn.Open()
                Dim intPo As String = Nothing, interInv As String = Nothing
                Using rdr = cmd.ExecuteReader()
                    If rdr.Read() Then
                        intPo = Convert.ToString(rdr("INT_PO_Number"))
                        interInv = Convert.ToString(rdr("INTER_INV_Number"))
                    End If
                End Using
                Return (intPo, interInv)
            End Using
        End Using
    End Function
End Class
