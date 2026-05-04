Imports System.Data.SqlClient
Imports System.Configuration

Public Class ScaledBOMService
    Private ReadOnly _connectionString As String

    Public Sub New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Public Class BOMItem
        Public Property ItemID As Integer
        Public Property ItemName As String
        Public Property ItemType As String
        Public Property Quantity As Decimal
        Public Property UnitOfMeasure As String
        Public Property CostPerUnit As Decimal
        Public Property TotalCost As Decimal
        Public Property RecipeBatchQty As Decimal
        Public Property RequestedQty As Decimal
        Public Property ScalingFactor As Decimal
    End Class

    Public Function GetScaledBOM(productID As Integer, requestedQuantity As Decimal) As List(Of BOMItem)
        Dim bomItems As New List(Of BOMItem)

        Try
            Using conn As New SqlConnection(_connectionString)
                Using cmd As New SqlCommand("sp_GetScaledBOMFromRecipe", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ProductID", productID)
                    cmd.Parameters.AddWithValue("@RequestedQuantity", requestedQuantity)

                    conn.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            bomItems.Add(New BOMItem With {
                                .ItemID = reader.GetInt32(reader.GetOrdinal("ItemID")),
                                .ItemName = reader.GetString(reader.GetOrdinal("ItemName")),
                                .ItemType = reader.GetString(reader.GetOrdinal("ItemType")),
                                .Quantity = reader.GetDecimal(reader.GetOrdinal("Quantity")),
                                .UnitOfMeasure = reader.GetString(reader.GetOrdinal("UnitOfMeasure")),
                                .CostPerUnit = reader.GetDecimal(reader.GetOrdinal("CostPerUnit")),
                                .TotalCost = reader.GetDecimal(reader.GetOrdinal("TotalCost")),
                                .RecipeBatchQty = reader.GetDecimal(reader.GetOrdinal("RecipeBatchQty")),
                                .RequestedQty = reader.GetDecimal(reader.GetOrdinal("RequestedQty")),
                                .ScalingFactor = reader.GetDecimal(reader.GetOrdinal("ScalingFactor"))
                            })
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception($"Error retrieving scaled BOM: {ex.Message}", ex)
        End Try

        Return bomItems
    End Function

    Public Function GetBOMSummary(productID As Integer, requestedQuantity As Decimal) As (TotalCost As Decimal, ItemCount As Integer, BatchQty As Decimal)
        Dim bomItems = GetScaledBOM(productID, requestedQuantity)
        
        If bomItems.Count = 0 Then
            Return (0, 0, 0)
        End If

        Dim totalCost = bomItems.Sum(Function(item) item.TotalCost)
        Dim itemCount = bomItems.Count
        Dim batchQty = bomItems.First().RecipeBatchQty

        Return (totalCost, itemCount, batchQty)
    End Function

    Public Function CheckRecipeExists(productID As Integer) As Boolean
        Try
            Using conn As New SqlConnection(_connectionString)
                Dim query As String = "
                    SELECT CASE 
                        WHEN EXISTS (SELECT 1 FROM Demo_ProductRecipe_Master WHERE ProductID = @ProductID AND IsActive = 1) THEN 1
                        WHEN EXISTS (SELECT 1 FROM Demo_SubRecipe_Master WHERE SubRecipeID = @ProductID AND IsActive = 1) THEN 1
                        ELSE 0
                    END AS RecipeExists"

                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@ProductID", productID)
                    conn.Open()
                    Return CBool(cmd.ExecuteScalar())
                End Using
            End Using
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Function GetRecipeBatchQuantity(productID As Integer) As Decimal
        Try
            Using conn As New SqlConnection(_connectionString)
                Dim query As String = "
                    SELECT COALESCE(
                        (SELECT BatchQty FROM Demo_ProductRecipe_Master WHERE ProductID = @ProductID AND IsActive = 1),
                        (SELECT BatchQty FROM Demo_SubRecipe_Master WHERE SubRecipeID = @ProductID AND IsActive = 1),
                        1
                    ) AS BatchQty"

                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@ProductID", productID)
                    conn.Open()
                    Dim result = cmd.ExecuteScalar()
                    Return If(result IsNot Nothing AndAlso Not IsDBNull(result), Convert.ToDecimal(result), 1)
                End Using
            End Using
        Catch ex As Exception
            Return 1
        End Try
    End Function
End Class
