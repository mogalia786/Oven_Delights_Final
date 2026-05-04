Imports System.Data.SqlClient
Imports System.Configuration

Public Class RecipeCostCalculationService

    Private ReadOnly _connectionString As String

    Public Sub New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Public Function GetIngredientCostPerUnit(ingredientID As Integer, branchID As Integer, packageSize As Decimal) As Decimal
        Dim costPerUnit As Decimal = 0

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_GetIngredientCostPerUnit", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@IngredientID", ingredientID)
                cmd.Parameters.AddWithValue("@BranchID", branchID)
                cmd.Parameters.AddWithValue("@PackageSize", packageSize)

                Dim outputParam As New SqlParameter("@CostPerUnit", SqlDbType.Decimal)
                outputParam.Precision = 18
                outputParam.Scale = 6
                outputParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(outputParam)

                conn.Open()
                cmd.ExecuteNonQuery()

                If Not IsDBNull(outputParam.Value) Then
                    costPerUnit = Convert.ToDecimal(outputParam.Value)
                End If
            End Using
        End Using

        Return costPerUnit
    End Function

    Public Function CalculateSubRecipeTotalCost(subRecipeID As Integer) As Decimal
        Dim totalCost As Decimal = 0

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "SELECT SUM(TotalCost) FROM Demo_SubRecipe_BOM WHERE SubRecipeID = @SubRecipeID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@SubRecipeID", subRecipeID)
                conn.Open()

                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    totalCost = Convert.ToDecimal(result)
                End If
            End Using
        End Using

        Return totalCost
    End Function

    Public Function GetSubRecipeCostPerUnit(subRecipeID As Integer) As Decimal
        Dim costPerUnit As Decimal = 0

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "
                SELECT ISNULL(TotalCost, 0) / NULLIF(ISNULL(BatchQty, 1), 0) AS CostPerUnit
                FROM Demo_SubRecipe_Master
                WHERE SubRecipeID = @SubRecipeID AND IsActive = 1"
            
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@SubRecipeID", subRecipeID)
                conn.Open()

                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    costPerUnit = Convert.ToDecimal(result)
                End If
            End Using
        End Using

        Return costPerUnit
    End Function

    Public Function CalculateProductTotalCost(productID As Integer) As Decimal
        Dim totalCost As Decimal = 0

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "SELECT SUM(TotalCost) FROM Demo_Product_BOM WHERE ProductID = @ProductID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ProductID", productID)
                conn.Open()

                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    totalCost = Convert.ToDecimal(result)
                End If
            End Using
        End Using

        Return totalCost
    End Function

    Public Function GetConsolidatedBOM(productID As Integer) As DataSet
        Dim ds As New DataSet()

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_GetConsolidatedBOM", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ProductID", productID)

                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(ds)
                End Using
            End Using
        End Using

        Return ds
    End Function

    Public Sub UpdateSubRecipeTotalCost(subRecipeID As Integer)
        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_UpdateSubRecipeTotalCost", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@SubRecipeID", subRecipeID)

                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Sub UpdateProductRecipeTotalCost(productID As Integer)
        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_UpdateProductRecipeTotalCost", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ProductID", productID)

                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Function CheckSubRecipeExists(subRecipeID As Integer) As Boolean
        Dim exists As Boolean = False

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_CheckSubRecipeExists", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@SubRecipeID", subRecipeID)

                Dim outputParam As New SqlParameter("@Exists", SqlDbType.Bit)
                outputParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(outputParam)

                conn.Open()
                cmd.ExecuteNonQuery()

                exists = Convert.ToBoolean(outputParam.Value)
            End Using
        End Using

        Return exists
    End Function

    Public Function CheckProductRecipeExists(productID As Integer) As Boolean
        Dim exists As Boolean = False

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_CheckProductRecipeExists", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ProductID", productID)

                Dim outputParam As New SqlParameter("@Exists", SqlDbType.Bit)
                outputParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(outputParam)

                conn.Open()
                cmd.ExecuteNonQuery()

                exists = Convert.ToBoolean(outputParam.Value)
            End Using
        End Using

        Return exists
    End Function

    Public Sub RefreshAllRecipeCosts(branchID As Integer)
        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_RefreshAllRecipeCosts", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@BranchID", branchID)
                cmd.CommandTimeout = 120

                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Function SaveSubRecipe(subRecipeID As Integer, method As String, batchQty As Decimal, createdBy As Integer) As Tuple(Of Boolean, String)
        Dim success As Boolean = False
        Dim message As String = ""

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_SaveSubRecipe", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@SubRecipeID", subRecipeID)
                cmd.Parameters.AddWithValue("@Method", If(String.IsNullOrEmpty(method), DBNull.Value, method))
                cmd.Parameters.AddWithValue("@BatchQty", batchQty)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)

                Dim successParam As New SqlParameter("@Success", SqlDbType.Bit)
                successParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(successParam)

                Dim messageParam As New SqlParameter("@Message", SqlDbType.NVarChar, 500)
                messageParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(messageParam)

                conn.Open()
                cmd.ExecuteNonQuery()

                success = Convert.ToBoolean(successParam.Value)
                message = messageParam.Value.ToString()
            End Using
        End Using

        Return New Tuple(Of Boolean, String)(success, message)
    End Function

    Public Function SaveSubRecipeIngredient(subRecipeID As Integer, ingredientID As Integer, quantity As Decimal,
                                           unitOfMeasure As String, packageSize As Decimal, costPerUnit As Decimal) As Tuple(Of Boolean, String)
        Dim success As Boolean = False
        Dim message As String = ""

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_SaveSubRecipeIngredient", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@SubRecipeID", subRecipeID)
                cmd.Parameters.AddWithValue("@IngredientID", ingredientID)
                cmd.Parameters.AddWithValue("@Quantity", quantity)
                cmd.Parameters.AddWithValue("@UnitOfMeasure", unitOfMeasure)
                cmd.Parameters.AddWithValue("@PackageSize", packageSize)
                cmd.Parameters.AddWithValue("@CostPerUnit", costPerUnit)

                Dim successParam As New SqlParameter("@Success", SqlDbType.Bit)
                successParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(successParam)

                Dim messageParam As New SqlParameter("@Message", SqlDbType.NVarChar, 500)
                messageParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(messageParam)

                conn.Open()
                cmd.ExecuteNonQuery()

                success = Convert.ToBoolean(successParam.Value)
                message = messageParam.Value.ToString()
            End Using
        End Using

        Return New Tuple(Of Boolean, String)(success, message)
    End Function

    Public Function SaveProductRecipe(productID As Integer, method As String, batchQty As Decimal, createdBy As Integer) As Tuple(Of Boolean, String)
        Dim success As Boolean = False
        Dim message As String = ""

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_SaveProductRecipe", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ProductID", productID)
                cmd.Parameters.AddWithValue("@Method", If(String.IsNullOrEmpty(method), DBNull.Value, method))
                cmd.Parameters.AddWithValue("@BatchQty", batchQty)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)

                Dim successParam As New SqlParameter("@Success", SqlDbType.Bit)
                successParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(successParam)

                Dim messageParam As New SqlParameter("@Message", SqlDbType.NVarChar, 500)
                messageParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(messageParam)

                conn.Open()
                cmd.ExecuteNonQuery()

                success = Convert.ToBoolean(successParam.Value)
                message = messageParam.Value.ToString()
            End Using
        End Using

        Return New Tuple(Of Boolean, String)(success, message)
    End Function

    Public Function SaveProductBOMComponent(productID As Integer, componentType As String, componentID As Integer,
                                           quantity As Decimal, costPerUnit As Decimal) As Tuple(Of Boolean, String)
        Dim success As Boolean = False
        Dim message As String = ""

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_SaveProductBOMComponent", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ProductID", productID)
                cmd.Parameters.AddWithValue("@ComponentType", componentType)
                cmd.Parameters.AddWithValue("@ComponentID", componentID)
                cmd.Parameters.AddWithValue("@Quantity", quantity)
                cmd.Parameters.AddWithValue("@CostPerUnit", costPerUnit)

                Dim successParam As New SqlParameter("@Success", SqlDbType.Bit)
                successParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(successParam)

                Dim messageParam As New SqlParameter("@Message", SqlDbType.NVarChar, 500)
                messageParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(messageParam)

                conn.Open()
                cmd.ExecuteNonQuery()

                success = Convert.ToBoolean(successParam.Value)
                message = messageParam.Value.ToString()
            End Using
        End Using

        Return New Tuple(Of Boolean, String)(success, message)
    End Function

    Public Function DeleteSubRecipeIngredient(bomLineID As Integer) As Tuple(Of Boolean, String)
        Dim success As Boolean = False
        Dim message As String = ""

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_DeleteSubRecipeIngredient", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@BOMLineID", bomLineID)

                Dim successParam As New SqlParameter("@Success", SqlDbType.Bit)
                successParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(successParam)

                Dim messageParam As New SqlParameter("@Message", SqlDbType.NVarChar, 500)
                messageParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(messageParam)

                conn.Open()
                cmd.ExecuteNonQuery()

                success = Convert.ToBoolean(successParam.Value)
                message = messageParam.Value.ToString()
            End Using
        End Using

        Return New Tuple(Of Boolean, String)(success, message)
    End Function

    Public Function DeleteProductBOMComponent(bomLineID As Integer) As Tuple(Of Boolean, String)
        Dim success As Boolean = False
        Dim message As String = ""

        Using conn As New SqlConnection(_connectionString)
            Using cmd As New SqlCommand("sp_DeleteProductBOMComponent", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@BOMLineID", bomLineID)

                Dim successParam As New SqlParameter("@Success", SqlDbType.Bit)
                successParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(successParam)

                Dim messageParam As New SqlParameter("@Message", SqlDbType.NVarChar, 500)
                messageParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(messageParam)

                conn.Open()
                cmd.ExecuteNonQuery()

                success = Convert.ToBoolean(successParam.Value)
                message = messageParam.Value.ToString()
            End Using
        End Using

        Return New Tuple(Of Boolean, String)(success, message)
    End Function

    Public Function GetSubRecipeIngredients(subRecipeID As Integer) As DataTable
        Dim dt As New DataTable()

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "
                SELECT 
                    sri.IngredientLineID AS BOMLineID,
                    sri.IngredientID,
                    p.Name AS IngredientName,
                    sri.Quantity,
                    sri.UnitOfMeasure,
                    ISNULL(sri.PackageSize, 1) AS PackageSize,
                    sri.CostPerUnit,
                    (sri.Quantity * sri.CostPerUnit) AS TotalCost,
                    ISNULL(srm.BatchQty, 1) AS BatchQty,
                    (sri.Quantity / NULLIF(ISNULL(srm.BatchQty, 1), 0)) AS QuantityPerUnit
                FROM Demo_SubRecipe_Ingredients sri
                INNER JOIN Demo_Retail_Product p ON sri.IngredientID = p.ProductID
                LEFT JOIN Demo_SubRecipe_Master srm ON sri.SubRecipeID = srm.SubRecipeID
                WHERE sri.SubRecipeID = @SubRecipeID
                  AND sri.IsActive = 1
                ORDER BY p.Name"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@SubRecipeID", subRecipeID)
                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using
        End Using

        Return dt
    End Function

    Public Function GetProductBOMComponents(productID As Integer) As DataTable
        Dim dt As New DataTable()

        Using conn As New SqlConnection(_connectionString)
            ' Fetch current live cost from Demo_Retail_Price for non-SubRecipe components
            ' For SubRecipes, use stored cost from BOM
            Dim query As String = "
                SELECT 
                    pb.BOMLineID,
                    pb.ComponentType,
                    pb.ComponentID,
                    p.Name AS ComponentName,
                    pb.Quantity,
                    CASE 
                        WHEN pb.ComponentType = 'SubRecipe' THEN pb.CostPerUnit
                        ELSE ISNULL(rp.CostPrice, pb.CostPerUnit)
                    END AS CostPerUnit,
                    CASE 
                        WHEN pb.ComponentType = 'SubRecipe' THEN pb.TotalCost
                        ELSE pb.Quantity * ISNULL(rp.CostPrice, pb.CostPerUnit)
                    END AS TotalCost
                FROM Demo_ProductRecipe_BOM pb
                INNER JOIN Demo_Retail_Product p ON pb.ComponentID = p.ProductID
                LEFT JOIN Demo_Retail_Price rp ON rp.ProductID = p.ProductID AND rp.BranchID = p.BranchID
                WHERE pb.ProductID = @ProductID
                  AND pb.IsActive = 1
                ORDER BY pb.ComponentType, p.Name"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ProductID", productID)
                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using
        End Using

        Return dt
    End Function

    Public Function GetSubRecipeDetails(subRecipeID As Integer) As DataRow
        Dim dt As New DataTable()

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "
                SELECT 
                    sr.SubRecipeID,
                    p.Name AS SubRecipeName,
                    sr.Method,
                    sr.BatchQty,
                    sr.TotalCost,
                    sr.IsActive
                FROM Demo_SubRecipe_Master sr
                INNER JOIN Demo_Retail_Product p ON sr.SubRecipeID = p.ProductID
                WHERE sr.SubRecipeID = @SubRecipeID"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@SubRecipeID", subRecipeID)
                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using
        End Using

        If dt.Rows.Count > 0 Then
            Return dt.Rows(0)
        End If

        Return Nothing
    End Function

    Public Function GetProductRecipeDetails(productID As Integer) As DataRow
        Dim dt As New DataTable()

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "
                SELECT 
                    pr.ProductID,
                    p.Name AS ProductName,
                    pr.Method,
                    pr.BatchQty,
                    pr.TotalCost,
                    pr.IsActive
                FROM Demo_ProductRecipe_Master pr
                INNER JOIN Demo_Retail_Product p ON pr.ProductID = p.ProductID
                WHERE pr.ProductID = @ProductID"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ProductID", productID)
                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using
        End Using

        If dt.Rows.Count > 0 Then
            Return dt.Rows(0)
        End If

        Return Nothing
    End Function

End Class
