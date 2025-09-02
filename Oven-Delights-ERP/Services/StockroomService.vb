Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Data
Imports Oven_Delights_ERP.Accounting

Public Class StockroomService
    Private ReadOnly connectionString As String

    Public Sub New()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Public Function GetAllSuppliers() As DataTable
        Dim suppliersTable As New DataTable()

        Using connection As New SqlConnection(connectionString)
            Dim query As String = "SELECT " &
                                  "SupplierID AS ID, " &
                                  "SupplierCode, " &
                                  "CompanyName AS Name, " &
                                  "IsActive, " &
                                  "CreatedDate " &
                                  "FROM Suppliers ORDER BY CompanyName"

            Using adapter As New SqlDataAdapter(query, connection)
                adapter.Fill(suppliersTable)
            End Using
        End Using

        Return suppliersTable
    End Function

    ' Lightweight lookups for forms (duplicates removed; using consolidated versions below)

    ' Helper: check if a table column exists
    Private Function ColumnExists(con As SqlConnection, tx As SqlTransaction, tableName As String, columnName As String) As Boolean
        Using cmd As New SqlCommand("SELECT CASE WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME=@t AND COLUMN_NAME=@c) THEN 1 ELSE 0 END", con, tx)
            cmd.Parameters.AddWithValue("@t", tableName)
            cmd.Parameters.AddWithValue("@c", columnName)
            Dim obj = cmd.ExecuteScalar()
            Return obj IsNot Nothing AndAlso obj IsNot DBNull.Value AndAlso Convert.ToInt32(obj) = 1
        End Using
    End Function

    ' Returns PO header fields for display (e.g., PONumber). One row or empty.
    Public Function GetPurchaseOrderHeader(poId As Integer) As DataTable
        Dim dt As New DataTable()
        If poId <= 0 Then Return dt
        Using con As New SqlConnection(connectionString)
            Dim sql = "SELECT PurchaseOrderID, PONumber, SupplierID, BranchID, Status, CreatedDate, OrderDate, RequiredDate, SubTotal, VATAmount FROM PurchaseOrders WHERE PurchaseOrderID = @id"
            Using ad As New SqlDataAdapter(sql, con)
                ad.SelectCommand.Parameters.AddWithValue("@id", poId)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    ' Lookup Units of Measure (UoMID, UnitName)
    Public Function GetUnits() As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            Try
                Dim sql = "SELECT UoMID, UnitName FROM dbo.Units WHERE ISNULL(IsActive,1)=1 ORDER BY UnitName"
                Using ad As New SqlDataAdapter(sql, con)
                    ad.Fill(dt)
                End Using
            Catch
                ' return empty if Units table missing
            End Try
        End Using
        Return dt
    End Function

    ' Pricing guidance helpers (duplicates removed; using consolidated versions below)

    ' Returns on-hand stock for a material for the specified branch using Inventory table; falls back to RawMaterials.CurrentStock if needed.
    Public Function GetStockOnHand(materialId As Integer, branchId As Integer) As Decimal
        If materialId <= 0 Then Return 0D
        Try
            Using con As New SqlConnection(connectionString)
                con.Open()
                ' Preferred source: per-branch Inventory
                Try
                    Using cmd As New SqlCommand("SELECT ISNULL(SUM(QuantityOnHand),0) FROM dbo.Inventory WHERE MaterialID = @M AND (@B = 0 OR BranchID = @B) AND ISNULL(IsActive,1)=1", con)
                        cmd.Parameters.AddWithValue("@M", materialId)
                        cmd.Parameters.AddWithValue("@B", branchId)
                        Dim v = cmd.ExecuteScalar()
                        If v IsNot Nothing AndAlso v IsNot DBNull.Value Then
                            Return Convert.ToDecimal(v)
                        End If
                    End Using
                Catch
                    ' Fallback without IsActive column
                    Using cmd As New SqlCommand("SELECT ISNULL(SUM(QuantityOnHand),0) FROM dbo.Inventory WHERE MaterialID = @M AND (@B = 0 OR BranchID = @B)", con)
                        cmd.Parameters.AddWithValue("@M", materialId)
                        cmd.Parameters.AddWithValue("@B", branchId)
                        Dim v = cmd.ExecuteScalar()
                        If v IsNot Nothing AndAlso v IsNot DBNull.Value Then
                            Return Convert.ToDecimal(v)
                        End If
                    End Using
                End Try
                ' Legacy fallback: RawMaterials.CurrentStock (global)
                Using cmd As New SqlCommand("SELECT ISNULL(CurrentStock,0) FROM dbo.RawMaterials WHERE MaterialID = @M", con)
                    cmd.Parameters.AddWithValue("@M", materialId)
                    Dim obj = cmd.ExecuteScalar()
                    If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                        Return Convert.ToDecimal(obj)
                    End If
                End Using
            End Using
        Catch
        End Try
        Return 0D
    End Function

    ' Stockroom-specific on-hand quantity computed from StockMovements (InventoryArea = 'Stockroom')
    Public Function GetStockOnHandInStockroom(materialId As Integer) As Decimal
        If materialId <= 0 Then Return 0D
        Try
            Using con As New SqlConnection(connectionString)
                Using cmd As New SqlCommand("SELECT ISNULL(SUM(QuantityIn - QuantityOut), 0) FROM dbo.StockMovements WHERE MaterialID = @M AND (InventoryArea = N'Stockroom' OR InventoryArea IS NULL)", con)
                    cmd.Parameters.AddWithValue("@M", materialId)
                    con.Open()
                    Dim obj = cmd.ExecuteScalar()
                    If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                        Return Convert.ToDecimal(obj)
                    End If
                End Using
            End Using
        Catch
        End Try
        Return 0D
    End Function

    Public Sub SaveSuppliers(changes As DataTable)
        If changes Is Nothing Then Return
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    For Each r As DataRow In changes.Rows
                        Dim id As Integer = If(r.Table.Columns.Contains("ID") AndAlso Not r.IsNull("ID"), Convert.ToInt32(r("ID")), 0)
                        Dim code As String = If(r.Table.Columns.Contains("SupplierCode"), Convert.ToString(r("SupplierCode")).Trim(), Nothing)
                        Dim name As String = If(r.Table.Columns.Contains("Name"), Convert.ToString(r("Name")).Trim(), Nothing)
                        Dim active As Boolean = False
                        If r.Table.Columns.Contains("IsActive") AndAlso Not r.IsNull("IsActive") Then active = Convert.ToBoolean(r("IsActive"))

                        If String.IsNullOrWhiteSpace(name) Then Continue For

                        If id = 0 Then
                            Using cmd As New SqlCommand("INSERT INTO Suppliers(SupplierCode, CompanyName, IsActive, CreatedDate) OUTPUT INSERTED.SupplierID VALUES(@Code, @Name, @Act, SYSUTCDATETIME())", con, tx)
                                cmd.Parameters.AddWithValue("@Code", If(code, CType(DBNull.Value, Object)))
                                cmd.Parameters.AddWithValue("@Name", name)
                                cmd.Parameters.AddWithValue("@Act", active)
                                Dim newId = CInt(cmd.ExecuteScalar())
                                If r.Table.Columns.Contains("ID") Then r("ID") = newId
                            End Using
                        Else
                            Using cmd As New SqlCommand("UPDATE Suppliers SET SupplierCode=@Code, CompanyName=@Name, IsActive=@Act, ModifiedDate = SYSUTCDATETIME() WHERE SupplierID=@Id", con, tx)
                                cmd.Parameters.AddWithValue("@Id", id)
                                cmd.Parameters.AddWithValue("@Code", If(code, CType(DBNull.Value, Object)))
                                cmd.Parameters.AddWithValue("@Name", name)
                                cmd.Parameters.AddWithValue("@Act", active)
                                cmd.ExecuteNonQuery()
                            End Using
                        End If
                    Next
                    tx.Commit()
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Private Function TryGetString(r As DataRow, col As String) As String
        Try
            If r.Table.Columns.Contains(col) AndAlso Not r.IsNull(col) Then
                Return Convert.ToString(r(col))
            End If
        Catch
        End Try
        Return Nothing
    End Function

    Public Function SearchMaterials(term As String, Optional maxRows As Integer = 25) As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            Dim sql = "SELECT TOP (@max) MaterialID, MaterialCode, MaterialName, AverageCost " &
                      "FROM RawMaterials " &
                      "WHERE IsActive = 1 AND (MaterialCode LIKE @q OR MaterialName LIKE @q) " &
                      "ORDER BY MaterialName"
            Using ad As New SqlDataAdapter(sql, con)
                ad.SelectCommand.Parameters.AddWithValue("@max", maxRows)
                ad.SelectCommand.Parameters.AddWithValue("@q", "%" & term & "%")
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    Public Function SearchSuppliers(term As String, Optional maxRows As Integer = 25) As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            Dim sql = "SELECT TOP (@max) SupplierID, SupplierCode, CompanyName FROM Suppliers " &
                      "WHERE IsActive = 1 AND (SupplierCode LIKE @q OR CompanyName LIKE @q) " &
                      "ORDER BY CompanyName"
            Using ad As New SqlDataAdapter(sql, con)
                ad.SelectCommand.Parameters.AddWithValue("@max", maxRows)
                ad.SelectCommand.Parameters.AddWithValue("@q", "%" & term & "%")
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    ' Resolve default supplier for a single material
    Public Function ResolveDefaultSupplierForMaterial(materialId As Integer) As Integer
        If materialId <= 0 Then Return 0
        Using con As New SqlConnection(connectionString)
            con.Open()
            ' 1) Preferred/Last supplier from RawMaterials if schema supports it
            Try
                Dim hasPref As Boolean = False
                Dim hasLast As Boolean = False
                hasPref = ColumnExists(con, Nothing, "RawMaterials", "PreferredSupplierID")
                hasLast = ColumnExists(con, Nothing, "RawMaterials", "LastSupplierID")
                If hasPref OrElse hasLast Then
                    Dim sqlPref As String = "SELECT TOP 1 COALESCE(PreferredSupplierID, LastSupplierID) FROM dbo.RawMaterials WHERE MaterialID = @M AND (PreferredSupplierID IS NOT NULL OR LastSupplierID IS NOT NULL)"
                    Using cmd As New SqlCommand(sqlPref, con)
                        cmd.Parameters.AddWithValue("@M", materialId)
                        Dim obj = cmd.ExecuteScalar()
                        If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                            Return Convert.ToInt32(obj)
                        End If
                    End Using
                End If
            Catch
                ' ignore and fall back to GRN history
            End Try

            ' 2) Most-recent GRN supplier for this material
            Try
                Dim sql As String = "SELECT TOP 1 g.SupplierID " & _
                                   "FROM dbo.GRNLines gl " & _
                                   "INNER JOIN dbo.GoodsReceivedNotes g ON g.GRNID = gl.GRNID " & _
                                   "WHERE gl.MaterialID = @M " & _
                                   "ORDER BY g.ReceivedDate DESC, gl.GRNLineID DESC"
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@M", materialId)
                    Dim obj = cmd.ExecuteScalar()
                    If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                        Return Convert.ToInt32(obj)
                    End If
                End Using
            Catch
            End Try
        End Using
        Return 0
    End Function

    ' Resolve default supplier for a set of materials: prefers a single PreferredSupplier across all; else most-recent GRN supplier overall
    Public Function ResolveDefaultSupplierForMaterials(materialIds As IEnumerable(Of Integer)) As Integer
        If materialIds Is Nothing Then Return 0
        Dim ids As List(Of Integer) = New List(Of Integer)(materialIds)
        ids.RemoveAll(Function(x) x <= 0)
        If ids.Count = 0 Then Return 0

        Using con As New SqlConnection(connectionString)
            con.Open()
            ' 1) If RawMaterials has PreferredSupplierID/LastSupplierID and a single non-null supplier exists across all ids, use it
            Try
                Dim hasPref As Boolean = ColumnExists(con, Nothing, "RawMaterials", "PreferredSupplierID")
                Dim hasLast As Boolean = ColumnExists(con, Nothing, "RawMaterials", "LastSupplierID")
                If hasPref OrElse hasLast Then
                    Dim paramNames As New List(Of String)()
                    Dim cmdText As String = "SELECT DISTINCT COALESCE(PreferredSupplierID, LastSupplierID) AS Sup " & _
                                            "FROM dbo.RawMaterials WHERE MaterialID IN (" & String.Join(",", ids.Select(Function(i, idx) "@m" & idx)) & ") " & _
                                            "AND (PreferredSupplierID IS NOT NULL OR LastSupplierID IS NOT NULL)"
                    Using cmd As New SqlCommand(cmdText, con)
                        For i As Integer = 0 To ids.Count - 1
                            cmd.Parameters.AddWithValue("@m" & i, ids(i))
                        Next
                        Dim found As New List(Of Integer)()
                        Using rdr = cmd.ExecuteReader()
                            While rdr.Read()
                                If Not rdr.IsDBNull(0) Then found.Add(rdr.GetInt32(0))
                            End While
                        End Using
                        If found.Count = 1 Then
                            Return found(0)
                        End If
                    End Using
                End If
            Catch
                ' ignore and fall back to GRN history
            End Try

            ' 2) Most-recent GRN supplier among the materials
            Try
                Dim inList As String = String.Join(",", ids.Select(Function(i, idx) "@g" & idx))
                Dim sql As String = "SELECT TOP 1 g.SupplierID " & _
                                    "FROM dbo.GRNLines gl " & _
                                    "INNER JOIN dbo.GoodsReceivedNotes g ON g.GRNID = gl.GRNID " & _
                                    "WHERE gl.MaterialID IN (" & inList & ") " & _
                                    "ORDER BY g.ReceivedDate DESC, gl.GRNLineID DESC"
                Using cmd As New SqlCommand(sql, con)
                    For i As Integer = 0 To ids.Count - 1
                        cmd.Parameters.AddWithValue("@g" & i, ids(i))
                    Next
                    Dim obj = cmd.ExecuteScalar()
                    If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                        Return Convert.ToInt32(obj)
                    End If
                End Using
            Catch
            End Try
        End Using
        Return 0
    End Function

    Public Function GetGRNsBySupplier(supplierId As Integer) As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            Dim sql = "SELECT GRNID, GRNNumber, ReceivedDate, TotalAmount FROM GoodsReceivedNotes WHERE SupplierID = @sid ORDER BY ReceivedDate DESC"
            Using ad As New SqlDataAdapter(sql, con)
                ad.SelectCommand.Parameters.AddWithValue("@sid", supplierId)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    Public Function GetReturnableGRNLines(grnId As Integer) As DataTable
        ' Uses helper view vw_GRNLine_ReturnableQty if available; falls back to computing from GRNLines
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            Dim sql As String = ""
            sql = "SELECT gl.GRNLineID, gl.MaterialID, m.MaterialCode, m.MaterialName, gl.ReceivedQuantity, " &
                  "ISNULL(v.RemainingQty, gl.ReceivedQuantity) AS RemainingQty, gl.UnitCost " &
                  "FROM GRNLines gl " &
                  "INNER JOIN RawMaterials m ON m.MaterialID = gl.MaterialID " &
                  "LEFT JOIN vw_GRNLine_ReturnableQty v ON v.GRNLineID = gl.GRNLineID " &
                  "WHERE gl.GRNID = @g"
            Using ad As New SqlDataAdapter(sql, con)
                ad.SelectCommand.Parameters.AddWithValue("@g", grnId)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    Private Function GetNextDocumentNumber(documentType As String, branchId As Integer, userId As Integer, con As SqlConnection, tx As SqlTransaction) As String
        Try
            Using cmd As New SqlCommand("sp_GetNextDocumentNumber", con, tx)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@DocumentType", documentType)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                cmd.Parameters.AddWithValue("@UserID", userId)
                Dim outNum As New SqlParameter("@NextDocNumber", SqlDbType.VarChar, 50) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(outNum)
                cmd.ExecuteNonQuery()
                Dim v = Convert.ToString(outNum.Value)
                If Not String.IsNullOrWhiteSpace(v) Then Return v
            End Using
        Catch
            ' Fallback handled below
        End Try
        Return $"{documentType}-{DateTime.UtcNow:yyyyMMddHHmmss}"
    End Function

    Private Function GetSettingInt(key As String) As Integer?
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using cmd As New SqlCommand("SELECT [Value] FROM SystemSettings WHERE [Key] = @k", con)
                cmd.Parameters.AddWithValue("@k", key)
                Dim obj = cmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Dim s As String = Convert.ToString(obj)
                    Dim v As Integer
                    If Integer.TryParse(s, v) Then Return v
                End If
            End Using
        End Using
        Return Nothing
    End Function

    Public Function GetOpenPOsBySupplier(supplierId As Integer) As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            Dim sql = "SELECT PurchaseOrderID, PONumber, OrderDate, SubTotal, VATAmount, TotalAmount = (SubTotal + VATAmount) " & _
                       "FROM dbo.PurchaseOrders WHERE SupplierID = @sid ORDER BY PurchaseOrderID DESC"
            Using ad As New SqlDataAdapter(sql, con)
                ad.SelectCommand.Parameters.AddWithValue("@sid", supplierId)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    Public Function GetPOLines(poId As Integer) As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            Dim sql = _
                "SELECT l.POLineID, l.MaterialID, m.MaterialCode, m.MaterialName, l.OrderedQuantity, ISNULL(l.ReceivedQuantity,0) AS ReceivedQuantity, l.UnitCost " & _
                "FROM dbo.PurchaseOrderLines l " & _
                "INNER JOIN dbo.RawMaterials m ON m.MaterialID = l.MaterialID " & _
                "WHERE l.PurchaseOrderID = @id AND l.MaterialID IS NOT NULL " & _
                "UNION ALL " & _
                "SELECT l.POLineID, l.ProductID AS MaterialID, p.ProductCode AS MaterialCode, p.ProductName AS MaterialName, l.OrderedQuantity, ISNULL(l.ReceivedQuantity,0) AS ReceivedQuantity, l.UnitCost " & _
                "FROM dbo.PurchaseOrderLines l " & _
                "INNER JOIN dbo.Products p ON p.ProductID = l.ProductID " & _
                "WHERE l.PurchaseOrderID = @id AND l.ProductID IS NOT NULL " & _
                "ORDER BY MaterialName"
            Using ad As New SqlDataAdapter(sql, con)
                ad.SelectCommand.Parameters.AddWithValue("@id", poId)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    Public Function CreateGRN(poId As Integer, supplierId As Integer, branchId As Integer, receivedDate As DateTime, deliveryNote As String, notes As String, createdBy As Integer, lines As DataTable) As Integer
        ' lines expected schema: POLineID(int), MaterialID(int), ReceivedQuantity(decimal), UnitCost(decimal)
        ' MaterialID in UI may carry ProductID for product lines; we will resolve actual RM/Product via POLine lookup.
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Prevent duplicate capture: require a supplier invoice/delivery note and ensure it is unique per supplier
                    If String.IsNullOrWhiteSpace(deliveryNote) Then
                        Throw New ApplicationException("Supplier invoice / delivery note is required. To correct a captured invoice, use a Credit Note.")
                    End If
                    Using cmdDup As New SqlCommand("SELECT TOP 1 1 FROM GoodsReceivedNotes WHERE SupplierID = @Sup AND DeliveryNote = @DN", con, tx)
                        cmdDup.Parameters.AddWithValue("@Sup", supplierId)
                        cmdDup.Parameters.AddWithValue("@DN", deliveryNote)
                        Dim exists = cmdDup.ExecuteScalar()
                        If exists IsNot Nothing Then
                            Throw New ApplicationException("This supplier invoice/delivery note has already been captured. Use a Credit Note for any corrections; recapturing is not allowed.")
                        End If
                    End Using

                    ' Create GRN Header
                    Dim grnNumber As String = GetNextDocumentNumber("GRN", branchId, createdBy, con, tx)
                    Dim cmdH = New SqlCommand("INSERT INTO GoodsReceivedNotes(GRNNumber, PurchaseOrderID, SupplierID, ReceivedDate, TotalAmount, Status, DeliveryNote, ReceivedBy, Notes, CreatedDate, CreatedBy) " &
                                              "OUTPUT INSERTED.GRNID VALUES(@No,@PO,@Sup,@Date,@Total,N'Received',@DN,@By,@Notes,SYSUTCDATETIME(),@By)", con, tx)
                    cmdH.Parameters.AddWithValue("@No", grnNumber)
                    cmdH.Parameters.AddWithValue("@PO", poId)
                    cmdH.Parameters.AddWithValue("@Sup", supplierId)
                    cmdH.Parameters.AddWithValue("@Date", receivedDate)
                    cmdH.Parameters.AddWithValue("@DN", deliveryNote)
                    cmdH.Parameters.AddWithValue("@By", createdBy)
                    cmdH.Parameters.AddWithValue("@Notes", If(notes, CType(DBNull.Value, Object)))

                    ' Compute total
                    Dim total As Decimal = 0D
                    For Each r As DataRow In lines.Rows
                        total += Convert.ToDecimal(r("ReceivedQuantity")) * Convert.ToDecimal(r("UnitCost"))
                    Next
                    cmdH.Parameters.AddWithValue("@Total", total)
                    Dim grnId As Integer = CInt(cmdH.ExecuteScalar())

                    ' Determine if GRNLines supports ProductID/ItemSource
                    Dim hasGRNL_Product As Boolean = False
                    Dim hasGRNL_ItemSource As Boolean = False
                    hasGRNL_Product = ColumnExists(con, tx, "GRNLines", "ProductID")
                    hasGRNL_ItemSource = ColumnExists(con, tx, "GRNLines", "ItemSource")

                    ' Preload PO line item sources to resolve RM vs Product
                    Dim polMap As New Dictionary(Of Integer, (MatId As Integer?, ProdId As Integer?, Src As String))
                    Using cmdPol As New SqlCommand("SELECT POLineID, MaterialID, " & _
                                                  "CASE WHEN COL_LENGTH('dbo.PurchaseOrderLines','ProductID') IS NULL THEN NULL ELSE ProductID END AS ProductID, " & _
                                                  "CASE WHEN COL_LENGTH('dbo.PurchaseOrderLines','ItemSource') IS NULL THEN NULL ELSE ItemSource END AS ItemSource " & _
                                                  "FROM dbo.PurchaseOrderLines WHERE PurchaseOrderID = @P", con, tx)
                        cmdPol.Parameters.AddWithValue("@P", poId)
                        Using rdr = cmdPol.ExecuteReader()
                            While rdr.Read()
                                Dim key As Integer = rdr.GetInt32(0)
                                Dim mid As Integer? = If(rdr.IsDBNull(1), CType(Nothing, Integer?), rdr.GetInt32(1))
                                Dim pid As Integer? = If(rdr.IsDBNull(2), CType(Nothing, Integer?), rdr.GetInt32(2))
                                Dim src As String = If(rdr.IsDBNull(3), Nothing, rdr.GetString(3))
                                polMap(key) = (mid, pid, src)
                            End While
                        End Using
                    End Using

                    ' Prepare GRN line insert command (schema-aware)
                    Dim cmdL As SqlCommand
                    If hasGRNL_Product AndAlso hasGRNL_ItemSource Then
                        cmdL = New SqlCommand("INSERT INTO GRNLines(GRNID, POLineID, MaterialID, ProductID, ItemSource, ReceivedQuantity, UnitCost) VALUES(@G,@PL,@M,@P,@S,@Q,@C)", con, tx)
                        cmdL.Parameters.Add("@P", SqlDbType.Int)
                        cmdL.Parameters.Add("@S", SqlDbType.NVarChar, 2)
                    Else
                        cmdL = New SqlCommand("INSERT INTO GRNLines(GRNID, POLineID, MaterialID, ReceivedQuantity, UnitCost) VALUES(@G,@PL,@M,@Q,@C)", con, tx)
                    End If
                    cmdL.Parameters.Add("@G", SqlDbType.Int)
                    cmdL.Parameters.Add("@PL", SqlDbType.Int)
                    cmdL.Parameters.Add("@M", SqlDbType.Int)
                    cmdL.Parameters.Add("@Q", SqlDbType.Decimal).Precision = 18 : cmdL.Parameters("@Q").Scale = 4
                    cmdL.Parameters.Add("@C", SqlDbType.Decimal).Precision = 18 : cmdL.Parameters("@C").Scale = 4

                    Dim updPOL = New SqlCommand("UPDATE PurchaseOrderLines SET ReceivedQuantity = ReceivedQuantity + @Q WHERE POLineID = @PL", con, tx)
                    updPOL.Parameters.Add("@Q", SqlDbType.Decimal).Precision = 18 : updPOL.Parameters("@Q").Scale = 4
                    updPOL.Parameters.Add("@PL", SqlDbType.Int)

                    Dim insMove = New SqlCommand("INSERT INTO StockMovements(MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, UnitCost, TotalValue, ReferenceType, ReferenceID, ReferenceNumber, Notes, CreatedDate, CreatedBy) " & _
                                                "VALUES(@M,'Purchase',@D,@In,0,@Bal,@Cost,@Val,'GRN',@RefId,@RefNo,@N,SYSUTCDATETIME(),@By)", con, tx)
                    insMove.Parameters.Add("@M", SqlDbType.Int)
                    insMove.Parameters.Add("@D", SqlDbType.DateTime2)
                    insMove.Parameters.Add("@In", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@In").Scale = 4
                    insMove.Parameters.Add("@Bal", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Bal").Scale = 4
                    insMove.Parameters.Add("@Cost", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Cost").Scale = 4
                    insMove.Parameters.Add("@Val", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Val").Scale = 2
                    insMove.Parameters.Add("@RefId", SqlDbType.Int)
                    insMove.Parameters.Add("@RefNo", SqlDbType.NVarChar, 30)
                    insMove.Parameters.Add("@N", SqlDbType.NVarChar, 255)
                    insMove.Parameters.Add("@By", SqlDbType.Int)

                    Dim updRM = New SqlCommand("UPDATE RawMaterials SET CurrentStock = CurrentStock + @Q, LastCost = @C, AverageCost = CASE WHEN COALESCE(CurrentStock,0) + @Q = 0 THEN AverageCost ELSE ((AverageCost * COALESCE(NULLIF(CurrentStock,0),0)) + (@C * @Q)) / NULLIF(COALESCE(CurrentStock,0) + @Q,0) END WHERE MaterialID = @M", con, tx)
                    updRM.Parameters.Add("@Q", SqlDbType.Decimal).Precision = 18 : updRM.Parameters("@Q").Scale = 4
                    updRM.Parameters.Add("@C", SqlDbType.Decimal).Precision = 18 : updRM.Parameters("@C").Scale = 4
                    updRM.Parameters.Add("@M", SqlDbType.Int)

                    ' Prepare ProductInventory upsert helpers for product (PR) lines at RETAIL
                    Dim cmdGetRetailLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@B, N'RETAIL')", con, tx)
                    cmdGetRetailLoc.Parameters.Add("@B", SqlDbType.Int)

                    Dim cmdPIUpd As New SqlCommand("UPDATE dbo.ProductInventory SET QuantityOnHand = QuantityOnHand + @Q, LastReceived = SYSUTCDATETIME(), LastUpdated = SYSUTCDATETIME() " & _
                                                  "WHERE ProductID = @P AND ISNULL(BranchID,-1) = ISNULL(@B,-1) AND LocationID = @L AND Batch IS NULL", con, tx)
                    cmdPIUpd.Parameters.Add("@P", SqlDbType.Int)
                    cmdPIUpd.Parameters.Add("@B", SqlDbType.Int)
                    cmdPIUpd.Parameters.Add("@L", SqlDbType.Int)
                    cmdPIUpd.Parameters.Add("@Q", SqlDbType.Decimal).Precision = 18 : cmdPIUpd.Parameters("@Q").Scale = 4

                    Dim cmdPIIns As New SqlCommand("INSERT INTO dbo.ProductInventory (ProductID, BranchID, LocationID, Batch, QuantityOnHand, UnitCost, LastReceived, LastUpdated) " & _
                                                  "VALUES(@P, @B, @L, NULL, @Q, @C, SYSUTCDATETIME(), SYSUTCDATETIME())", con, tx)
                    cmdPIIns.Parameters.Add("@P", SqlDbType.Int)
                    cmdPIIns.Parameters.Add("@B", SqlDbType.Int)
                    cmdPIIns.Parameters.Add("@L", SqlDbType.Int)
                    cmdPIIns.Parameters.Add("@Q", SqlDbType.Decimal).Precision = 18 : cmdPIIns.Parameters("@Q").Scale = 4
                    cmdPIIns.Parameters.Add("@C", SqlDbType.Decimal).Precision = 18 : cmdPIIns.Parameters("@C").Scale = 4

                    ' Track totals by line type for journals
                    Dim totalRMValue As Decimal = 0D
                    Dim totalPRValue As Decimal = 0D

                    For Each r As DataRow In lines.Rows
                        Dim plId = Convert.ToInt32(r("POLineID"))
                        Dim qty = Convert.ToDecimal(r("ReceivedQuantity"))
                        Dim cost = Convert.ToDecimal(r("UnitCost"))
                        If qty <= 0 Then Continue For

                        ' Resolve RM vs Product from POLine
                        Dim resolvedMat As Integer? = Nothing
                        Dim resolvedProd As Integer? = Nothing
                        Dim src As String = Nothing
                        If polMap.ContainsKey(plId) Then
                            Dim t = polMap(plId)
                            resolvedMat = t.MatId
                            resolvedProd = t.ProdId
                            src = t.Src
                        End If

                        Dim isProduct As Boolean = (resolvedProd.HasValue AndAlso resolvedProd.Value > 0) OrElse (Not String.IsNullOrWhiteSpace(src) AndAlso src = "PR")

                        If isProduct AndAlso Not (hasGRNL_Product AndAlso hasGRNL_ItemSource) Then
                            Throw New ApplicationException("Database schema for GRNLines does not support products yet. Please run 39_Add_GRNL_Product_Support.sql")
                        End If

                        ' GRN line insert
                        cmdL.Parameters("@G").Value = grnId
                        cmdL.Parameters("@PL").Value = plId
                        cmdL.Parameters("@Q").Value = qty
                        cmdL.Parameters("@C").Value = cost
                        If isProduct Then
                            cmdL.Parameters("@M").Value = If(resolvedMat.HasValue, resolvedMat.Value, CType(DBNull.Value, Object))
                            cmdL.Parameters("@P").Value = If(resolvedProd.HasValue, resolvedProd.Value, CType(DBNull.Value, Object))
                            cmdL.Parameters("@S").Value = If(String.IsNullOrWhiteSpace(src), "PR", src)
                        Else
                            Dim matId As Integer = If(resolvedMat.HasValue, resolvedMat.Value, Convert.ToInt32(r("MaterialID")))
                            cmdL.Parameters("@M").Value = matId
                            If hasGRNL_Product AndAlso hasGRNL_ItemSource Then
                                cmdL.Parameters("@P").Value = CType(DBNull.Value, Object)
                                cmdL.Parameters("@S").Value = "RM"
                            End If
                        End If
                        cmdL.ExecuteNonQuery()

                        ' Update PO line received
                        updPOL.Parameters("@Q").Value = qty
                        updPOL.Parameters("@PL").Value = plId
                        updPOL.ExecuteNonQuery()

                        ' Insert stock movement and update RM stock ONLY for RM lines
                        If Not isProduct Then
                            Dim matIdUse As Integer = Convert.ToInt32(cmdL.Parameters("@M").Value)
                            Dim currentBal As Decimal
                            Using cmdBal As New SqlCommand("SELECT CurrentStock FROM RawMaterials WHERE MaterialID = @M", con, tx)
                                cmdBal.Parameters.AddWithValue("@M", matIdUse)
                                currentBal = Convert.ToDecimal(cmdBal.ExecuteScalar())
                            End Using
                            Dim newBal = currentBal + qty
                            insMove.Parameters("@M").Value = matIdUse
                            insMove.Parameters("@D").Value = receivedDate
                            insMove.Parameters("@In").Value = qty
                            insMove.Parameters("@Bal").Value = newBal
                            insMove.Parameters("@Cost").Value = cost
                            insMove.Parameters("@Val").Value = Math.Round(qty * cost, 2)
                            insMove.Parameters("@RefId").Value = grnId
                            insMove.Parameters("@RefNo").Value = grnNumber
                            insMove.Parameters("@N").Value = If(String.IsNullOrWhiteSpace(notes), CType(DBNull.Value, Object), notes)
                            insMove.Parameters("@By").Value = createdBy
                            insMove.ExecuteNonQuery()

                            ' Update material stock (legacy)
                            updRM.Parameters("@Q").Value = qty
                            updRM.Parameters("@C").Value = cost
                            updRM.Parameters("@M").Value = matIdUse
                            updRM.ExecuteNonQuery()

                            ' Accumulate RM total for journals
                            totalRMValue += Math.Round(qty * cost, 2)
                        Else
                            ' For product lines, upsert ProductInventory at RETAIL
                            Dim prodIdUse As Integer = Convert.ToInt32(cmdL.Parameters("@P").Value)
                            cmdGetRetailLoc.Parameters("@B").Value = If(branchId > 0, branchId, CType(DBNull.Value, Object))
                            Dim locObj = cmdGetRetailLoc.ExecuteScalar()
                            Dim retailLocId As Integer = If(locObj Is Nothing OrElse locObj Is DBNull.Value, 0, Convert.ToInt32(locObj))
                            If retailLocId <= 0 Then Throw New ApplicationException("Retail location not configured for this branch. Please ensure InventoryLocations has code 'RETAIL'.")

                            cmdPIUpd.Parameters("@P").Value = prodIdUse
                            cmdPIUpd.Parameters("@B").Value = If(branchId > 0, branchId, CType(DBNull.Value, Object))
                            cmdPIUpd.Parameters("@L").Value = retailLocId
                            cmdPIUpd.Parameters("@Q").Value = qty
                            Dim rows = cmdPIUpd.ExecuteNonQuery()
                            If rows = 0 Then
                                cmdPIIns.Parameters("@P").Value = prodIdUse
                                cmdPIIns.Parameters("@B").Value = If(branchId > 0, branchId, CType(DBNull.Value, Object))
                                cmdPIIns.Parameters("@L").Value = retailLocId
                                cmdPIIns.Parameters("@Q").Value = qty
                                cmdPIIns.Parameters("@C").Value = cost
                                cmdPIIns.ExecuteNonQuery()
                            End If

                            ' Accumulate PR total for journals
                            totalPRValue += Math.Round(qty * cost, 2)
                        End If

                        ' Update/Insert Inventory table (per-branch stock) only for RM lines
                        If Not isProduct Then
                            Dim matIdUse2 As Integer = Convert.ToInt32(cmdL.Parameters("@M").Value)
                            Using cmdInvCheck As New SqlCommand("SELECT QuantityOnHand FROM Inventory WHERE MaterialID = @M AND BranchID = @B AND Location = 'MAIN'", con, tx)
                                cmdInvCheck.Parameters.AddWithValue("@M", matIdUse2)
                                cmdInvCheck.Parameters.AddWithValue("@B", branchId)
                                Dim existingQty = cmdInvCheck.ExecuteScalar()
                                
                                If existingQty IsNot Nothing Then
                                    ' Update existing inventory record
                                    Using cmdInvUpd As New SqlCommand("UPDATE Inventory SET QuantityOnHand = QuantityOnHand + @Q, UnitCost = @C, LastUpdated = GETDATE(), ModifiedBy = @By WHERE MaterialID = @M AND BranchID = @B AND Location = 'MAIN'", con, tx)
                                        cmdInvUpd.Parameters.AddWithValue("@Q", qty)
                                        cmdInvUpd.Parameters.AddWithValue("@C", cost)
                                        cmdInvUpd.Parameters.AddWithValue("@M", matIdUse2)
                                        cmdInvUpd.Parameters.AddWithValue("@B", branchId)
                                        cmdInvUpd.Parameters.AddWithValue("@By", createdBy)
                                        cmdInvUpd.ExecuteNonQuery()
                                    End Using
                                Else
                                    ' Insert new inventory record
                                    Using cmdInvIns As New SqlCommand("INSERT INTO Inventory (MaterialID, BranchID, Location, QuantityOnHand, UnitCost, CreatedBy, CreatedDate) VALUES (@M, @B, 'MAIN', @Q, @C, @By, GETDATE())", con, tx)
                                        cmdInvIns.Parameters.AddWithValue("@M", matIdUse2)
                                        cmdInvIns.Parameters.AddWithValue("@B", branchId)
                                        cmdInvIns.Parameters.AddWithValue("@Q", qty)
                                        cmdInvIns.Parameters.AddWithValue("@C", cost)
                                        cmdInvIns.Parameters.AddWithValue("@By", createdBy)
                                        cmdInvIns.ExecuteNonQuery()
                                    End Using
                                End If
                            End Using
                        End If
                    Next

                    ' Update PO Status based on received completeness
                    Using cmdStatus As New SqlCommand("UPDATE PurchaseOrders SET Status = CASE WHEN NOT EXISTS(SELECT 1 FROM PurchaseOrderLines WHERE PurchaseOrderID=@P AND ReceivedQuantity < OrderedQuantity) THEN N'Closed' ELSE N'Partial' END WHERE PurchaseOrderID=@P", con, tx)
                        cmdStatus.Parameters.AddWithValue("@P", poId)
                        cmdStatus.ExecuteNonQuery()
                    End Using

                    ' Journals via stored procedures using GRIR method and split inventory by line type
                    Dim acctInvRaw As Integer = GLMapping.GetMappedAccountId(con, "InventoryRaw", branchId, tx)
                    Dim acctInvRetail As Integer = GLMapping.GetMappedAccountId(con, "RetailInventory", branchId, tx)
                    Dim acctGRIR As Integer = GLMapping.GetMappedAccountId(con, "GRIR", branchId, tx)

                    ' Fallback to SystemSettings if GLMapping not configured
                    If acctGRIR <= 0 Then
                        Dim grirSet = GetSettingInt("GRIRAccountID")
                        If grirSet.HasValue Then acctGRIR = grirSet.Value
                    End If
                    If acctInvRaw <= 0 Then
                        Dim invSet = GetSettingInt("InventoryAccountID")
                        If invSet.HasValue Then acctInvRaw = invSet.Value
                    End If

                    Dim totalForCR As Decimal = totalRMValue + totalPRValue
                    If totalForCR > 0D AndAlso acctGRIR > 0 AndAlso (acctInvRaw > 0 OrElse acctInvRetail > 0) Then
                        ' Load supplier reference for journal refs
                        Dim supplierRef As String = Nothing
                        Using cmdSup As New SqlCommand("SELECT ISNULL(NULLIF(LTRIM(RTRIM(SupplierCode)), ''), CompanyName) FROM Suppliers WHERE SupplierID = @sid", con, tx)
                            cmdSup.Parameters.AddWithValue("@sid", supplierId)
                            Dim obj = cmdSup.ExecuteScalar()
                            If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then supplierRef = Convert.ToString(obj)
                        End Using
                        If String.IsNullOrWhiteSpace(supplierRef) Then supplierRef = supplierId.ToString()

                        ' Determine fiscal period
                        Dim fiscalPeriodId As Integer = GetFiscalPeriodId(receivedDate, branchId, con, tx)
                        Dim headerDesc As String = $"GRV {grnNumber} - {supplierRef} - DN {deliveryNote} - PO {poId}"
                        Dim journalId As Integer = CreateJournalHeader(receivedDate, grnNumber, headerDesc, fiscalPeriodId, createdBy, branchId, con, tx)
                        ' Debit inventory by bucket
                        If totalRMValue > 0D AndAlso acctInvRaw > 0 Then
                            AddJournalDetail(journalId, acctInvRaw, Math.Round(totalRMValue, 2), 0D, $"GRV {grnNumber} (RM)", supplierRef, deliveryNote, con, tx)
                        End If
                        If totalPRValue > 0D AndAlso acctInvRetail > 0 Then
                            AddJournalDetail(journalId, acctInvRetail, Math.Round(totalPRValue, 2), 0D, $"GRV {grnNumber} (PR)", supplierRef, deliveryNote, con, tx)
                        End If
                        ' Credit GRIR with total
                        AddJournalDetail(journalId, acctGRIR, 0D, Math.Round(totalForCR, 2), $"GRV {grnNumber}", supplierRef, deliveryNote, con, tx)
                        PostJournal(journalId, createdBy, con, tx)
                    End If

                    tx.Commit()

                    ' Post-GRN hook: if the PO reference includes "IO#<id>", auto-complete the Internal Order.
                    ' Keep it simple: parse from Reference, falling back to Notes or PONumber.
                    Try
                        Dim refText As String = Nothing
                        ' Prefer Reference
                        Try
                            Using cmdRef As New SqlCommand("SELECT NULLIF(LTRIM(RTRIM(Reference)), '') FROM dbo.PurchaseOrders WHERE PurchaseOrderID=@P", con)
                                cmdRef.Parameters.AddWithValue("@P", poId)
                                Dim o = cmdRef.ExecuteScalar()
                                If o IsNot Nothing AndAlso o IsNot DBNull.Value Then refText = Convert.ToString(o)
                            End Using
                        Catch
                        End Try

                        ' Fallback to Notes
                        If String.IsNullOrWhiteSpace(refText) Then
                            Try
                                Using cmdRef2 As New SqlCommand("SELECT NULLIF(LTRIM(RTRIM(Notes)), '') FROM dbo.PurchaseOrders WHERE PurchaseOrderID=@P", con)
                                    cmdRef2.Parameters.AddWithValue("@P", poId)
                                    Dim o = cmdRef2.ExecuteScalar()
                                    If o IsNot Nothing AndAlso o IsNot DBNull.Value Then refText = Convert.ToString(o)
                                End Using
                            Catch
                            End Try
                        End If

                        ' Fallback to PONumber
                        If String.IsNullOrWhiteSpace(refText) Then
                            Try
                                Using cmdRef3 As New SqlCommand("SELECT NULLIF(LTRIM(RTRIM(PONumber)), '') FROM dbo.PurchaseOrders WHERE PurchaseOrderID=@P", con)
                                    cmdRef3.Parameters.AddWithValue("@P", poId)
                                    Dim o = cmdRef3.ExecuteScalar()
                                    If o IsNot Nothing AndAlso o IsNot DBNull.Value Then refText = Convert.ToString(o)
                                End Using
                            Catch
                            End Try
                        End If

                        If Not String.IsNullOrWhiteSpace(refText) Then
                            Dim idx As Integer = refText.IndexOf("IO#", StringComparison.OrdinalIgnoreCase)
                            If idx >= 0 Then
                                Dim j As Integer = idx + 3
                                Dim num As String = String.Empty
                                While j < refText.Length AndAlso Char.IsDigit(refText(j))
                                    num &= refText(j)
                                    j += 1
                                End While
                                Dim ioId As Integer = 0
                                If Integer.TryParse(num, ioId) AndAlso ioId > 0 Then
                                    ' Complete the Internal Order chain: fulfill to MFG, receive FG, transfer to Retail, and post journals.
                                    Try
                                        CompleteInternalOrder(ioId, branchId, createdBy)
                                    Catch
                                        ' Swallow: do not block GRN return on IO completion issues
                                    End Try
                                End If
                            End If
                        End If
                    Catch
                        ' Swallow: keep GRN flow resilient
                    End Try

                    Return grnId
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Function

    ' Returns Credit Note header (number, totals) for follow-up posting and display
    Public Function GetCreditNoteHeader(creditNoteId As Integer) As DataTable
        Dim dt As New DataTable()
        If creditNoteId <= 0 Then Return dt
        Using con As New SqlConnection(connectionString)
            Dim sql = "SELECT CreditNoteID, CreditNoteNumber, SupplierID, BranchID, CreditDate, TotalAmount, GRNID, PurchaseOrderID FROM CreditNotes WHERE CreditNoteID = @id"
            Using ad As New SqlDataAdapter(sql, con)
                ad.SelectCommand.Parameters.AddWithValue("@id", creditNoteId)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    ' Helper to get supplier reference (code or name)
    Private Function GetSupplierReferenceValue(supplierId As Integer) As String
        If supplierId <= 0 Then Return supplierId.ToString()
        Using con As New SqlConnection(connectionString)
            Using cmd As New SqlCommand("SELECT ISNULL(NULLIF(LTRIM(RTRIM(SupplierCode)), ''), CompanyName) FROM Suppliers WHERE SupplierID = @sid", con)
                cmd.Parameters.AddWithValue("@sid", supplierId)
                con.Open()
                Dim obj = cmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Dim v = Convert.ToString(obj)
                    If Not String.IsNullOrWhiteSpace(v) Then Return v
                End If
            End Using
        End Using
        Return supplierId.ToString()
    End Function

    ' List posted AP invoices for the supplier (from Journal tables)
    Public Function GetSupplierAPInvoices(supplierId As Integer) As DataTable
        Dim dt As New DataTable()
        If supplierId <= 0 Then Return dt
        Dim supplierRef As String = GetSupplierReferenceValue(supplierId)
        Using con As New SqlConnection(connectionString)
            con.Open()
            ' Get AP Control account from SystemSettings
            Dim apAcctId As Integer = 0
            Using cmdSet As New SqlCommand("SELECT [Value] FROM SystemSettings WHERE [Key] = 'APControlAccountID'", con)
                Dim obj = cmdSet.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Integer.TryParse(Convert.ToString(obj), apAcctId)
                End If
            End Using
            If apAcctId <= 0 Then Return dt
            Dim sql = "SELECT h.JournalID, h.JournalNumber, h.JournalDate, d.Credit AS Amount, d.Reference2 AS SupplierInvoiceNo " & _
                      "FROM JournalHeaders h INNER JOIN JournalDetails d ON d.JournalID = h.JournalID " & _
                      "WHERE h.IsPosted = 1 AND d.AccountID = @AP AND d.Reference1 = @Ref AND d.Credit > 0 " & _
                      "ORDER BY h.JournalDate DESC, h.JournalID DESC"
            Using ad As New SqlDataAdapter(sql, con)
                ad.SelectCommand.Parameters.AddWithValue("@AP", apAcctId)
                ad.SelectCommand.Parameters.AddWithValue("@Ref", supplierRef)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    Public Function CreateStockTransfer(fromBranchId As Integer, toBranchId As Integer, transferDate As DateTime, reference As String, notes As String, createdBy As Integer, lines As DataTable) As Integer
        ' lines schema: MaterialID(int), TransferQuantity(decimal), UnitCost(decimal)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    Dim trfNumber As String = GetNextDocumentNumber("TRF", fromBranchId, createdBy, con, tx)

                    ' Insert header
                    Dim cmdH = New SqlCommand("INSERT INTO StockTransfers(TransferNumber, FromBranchID, ToBranchID, TransferDate, Status, Reference, Notes, CreatedDate, CreatedBy) " &
                                              "OUTPUT INSERTED.TransferID VALUES(@No,@From,@To,@Dt,N'Sent',@Ref,@Notes,SYSUTCDATETIME(),@By)", con, tx)
                    cmdH.Parameters.AddWithValue("@No", trfNumber)
                    cmdH.Parameters.AddWithValue("@From", fromBranchId)
                    cmdH.Parameters.AddWithValue("@To", toBranchId)
                    cmdH.Parameters.AddWithValue("@Dt", transferDate.Date)
                    cmdH.Parameters.AddWithValue("@Ref", If(reference, CType(DBNull.Value, Object)))
                    cmdH.Parameters.AddWithValue("@Notes", If(notes, CType(DBNull.Value, Object)))
                    cmdH.Parameters.AddWithValue("@By", createdBy)
                    Dim transferId As Integer = CInt(cmdH.ExecuteScalar())

                    Dim cmdL = New SqlCommand("INSERT INTO StockTransferLines(TransferID, MaterialID, TransferQuantity, UnitCost) VALUES(@T,@M,@Q,@C)", con, tx)
                    cmdL.Parameters.Add("@T", SqlDbType.Int)
                    cmdL.Parameters.Add("@M", SqlDbType.Int)
                    cmdL.Parameters.Add("@Q", SqlDbType.Decimal).Precision = 18 : cmdL.Parameters("@Q").Scale = 4
                    cmdL.Parameters.Add("@C", SqlDbType.Decimal).Precision = 18 : cmdL.Parameters("@C").Scale = 4

                    Dim insMove = New SqlCommand("INSERT INTO StockMovements(MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, UnitCost, TotalValue, ReferenceType, ReferenceID, ReferenceNumber, Notes, CreatedDate, CreatedBy) " &
                                                "VALUES(@M,'Transfer',@D,@In,@Out,@Bal,@Cost,@Val,'TRF',@RefId,@RefNo,@N,SYSUTCDATETIME(),@By)", con, tx)
                    insMove.Parameters.Add("@M", SqlDbType.Int)
                    insMove.Parameters.Add("@D", SqlDbType.DateTime2)
                    insMove.Parameters.Add("@In", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@In").Scale = 4
                    insMove.Parameters.Add("@Out", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Out").Scale = 4
                    insMove.Parameters.Add("@Bal", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Bal").Scale = 4
                    insMove.Parameters.Add("@Cost", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Cost").Scale = 4
                    insMove.Parameters.Add("@Val", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Val").Scale = 2
                    insMove.Parameters.Add("@RefId", SqlDbType.Int)
                    insMove.Parameters.Add("@RefNo", SqlDbType.NVarChar, 30)
                    insMove.Parameters.Add("@N", SqlDbType.NVarChar, 255)
                    insMove.Parameters.Add("@By", SqlDbType.Int)

                    For Each r As DataRow In lines.Rows
                        Dim matId = Convert.ToInt32(r("MaterialID"))
                        Dim qty = Convert.ToDecimal(r("TransferQuantity"))
                        Dim cost = Convert.ToDecimal(r("UnitCost"))
                        If qty <= 0D Then Continue For

                        ' Insert line
                        cmdL.Parameters("@T").Value = transferId
                        cmdL.Parameters("@M").Value = matId
                        cmdL.Parameters("@Q").Value = qty
                        cmdL.Parameters("@C").Value = cost
                        cmdL.ExecuteNonQuery()

                        ' Current global stock
                        Dim currentBal As Decimal
                        Using cmdBal As New SqlCommand("SELECT CurrentStock FROM RawMaterials WHERE MaterialID = @M", con, tx)
                            cmdBal.Parameters.AddWithValue("@M", matId)
                            currentBal = Convert.ToDecimal(cmdBal.ExecuteScalar())
                        End Using

                        ' Transfer OUT movement (no change to global stock)
                        insMove.Parameters("@M").Value = matId
                        insMove.Parameters("@D").Value = transferDate
                        insMove.Parameters("@In").Value = 0D
                        insMove.Parameters("@Out").Value = qty
                        insMove.Parameters("@Bal").Value = currentBal ' unchanged globally
                        insMove.Parameters("@Cost").Value = cost
                        insMove.Parameters("@Val").Value = Math.Round(qty * cost, 2)
                        insMove.Parameters("@RefId").Value = transferId
                        insMove.Parameters("@RefNo").Value = trfNumber
                        insMove.Parameters("@N").Value = $"Transfer OUT {fromBranchId}->{toBranchId}. {notes}"
                        insMove.Parameters("@By").Value = createdBy
                        insMove.ExecuteNonQuery()
                    Next

                    tx.Commit()
                    Return transferId
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Function

    Public Sub ReceiveStockTransfer(transferId As Integer, receivedDate As DateTime, receivedBy As Integer, lines As DataTable)
        ' lines schema: TransferLineID(int), ReceivedQuantity(decimal)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Get header info
                    Dim trfNumber As String
                    Dim toBranchId As Integer
                    Using cmd As New SqlCommand("SELECT TransferNumber, ToBranchID FROM StockTransfers WHERE TransferID=@T", con, tx)
                        cmd.Parameters.AddWithValue("@T", transferId)
                        Using rd = cmd.ExecuteReader()
                            If Not rd.Read() Then Throw New ApplicationException("Transfer not found")
                            trfNumber = rd.GetString(0)
                            toBranchId = rd.GetInt32(1)
                        End Using
                    End Using

                    ' Prepare movement and line updates
                    Dim getLine = New SqlCommand("SELECT MaterialID, TransferQuantity, UnitCost FROM StockTransferLines WHERE TransferLineID=@L AND TransferID=@T", con, tx)
                    getLine.Parameters.Add("@L", SqlDbType.Int)
                    getLine.Parameters.Add("@T", SqlDbType.Int)

                    Dim updLine = New SqlCommand("UPDATE StockTransferLines SET ReceivedQuantity = ISNULL(ReceivedQuantity,0) + @R, LineStatus = CASE WHEN (ISNULL(ReceivedQuantity,0) + @R) >= TransferQuantity THEN N'Completed' ELSE N'Partial' END WHERE TransferLineID=@L", con, tx)
                    updLine.Parameters.Add("@R", SqlDbType.Decimal).Precision = 18 : updLine.Parameters("@R").Scale = 4
                    updLine.Parameters.Add("@L", SqlDbType.Int)

                    Dim insMove = New SqlCommand("INSERT INTO StockMovements(MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, UnitCost, TotalValue, ReferenceType, ReferenceID, ReferenceNumber, Notes, CreatedDate, CreatedBy) " &
                                                "VALUES(@M,'Transfer',@D,@In,0,@Bal,@Cost,@Val,'TRF',@RefId,@RefNo,@N,SYSUTCDATETIME(),@By)", con, tx)
                    insMove.Parameters.Add("@M", SqlDbType.Int)
                    insMove.Parameters.Add("@D", SqlDbType.DateTime2)
                    insMove.Parameters.Add("@In", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@In").Scale = 4
                    insMove.Parameters.Add("@Bal", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Bal").Scale = 4
                    insMove.Parameters.Add("@Cost", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Cost").Scale = 4
                    insMove.Parameters.Add("@Val", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Val").Scale = 2
                    insMove.Parameters.Add("@RefId", SqlDbType.Int)
                    insMove.Parameters.Add("@RefNo", SqlDbType.NVarChar, 30)
                    insMove.Parameters.Add("@N", SqlDbType.NVarChar, 255)
                    insMove.Parameters.Add("@By", SqlDbType.Int)

                    For Each r As DataRow In lines.Rows
                        Dim lineId = Convert.ToInt32(r("TransferLineID"))
                        Dim recvQty = Convert.ToDecimal(r("ReceivedQuantity"))
                        If recvQty <= 0D Then Continue For

                        ' Load line details
                        getLine.Parameters("@L").Value = lineId
                        getLine.Parameters("@T").Value = transferId
                        Dim matId As Integer, qty As Decimal, cost As Decimal
                        Using rd = getLine.ExecuteReader()
                            If Not rd.Read() Then Throw New ApplicationException("Transfer line not found")
                            matId = rd.GetInt32(0)
                            qty = rd.GetDecimal(1)
                            cost = rd.GetDecimal(2)
                        End Using

                        ' Update line received
                        updLine.Parameters("@R").Value = recvQty
                        updLine.Parameters("@L").Value = lineId
                        updLine.ExecuteNonQuery()

                        ' Current global stock
                        Dim currentBal As Decimal
                        Using cmdBal As New SqlCommand("SELECT CurrentStock FROM RawMaterials WHERE MaterialID = @M", con, tx)
                            cmdBal.Parameters.AddWithValue("@M", matId)
                            currentBal = Convert.ToDecimal(cmdBal.ExecuteScalar())
                        End Using

                        ' Transfer IN movement (no change to global stock)
                        insMove.Parameters("@M").Value = matId
                        insMove.Parameters("@D").Value = receivedDate
                        insMove.Parameters("@In").Value = recvQty
                        insMove.Parameters("@Bal").Value = currentBal ' unchanged globally
                        insMove.Parameters("@Cost").Value = cost
                        insMove.Parameters("@Val").Value = Math.Round(recvQty * cost, 2)
                        insMove.Parameters("@RefId").Value = transferId
                        insMove.Parameters("@RefNo").Value = trfNumber
                        insMove.Parameters("@N").Value = $"Transfer IN to {toBranchId}"
                        insMove.Parameters("@By").Value = receivedBy
                        insMove.ExecuteNonQuery()
                    Next

                    ' Update header status
                    Using cmdStatus As New SqlCommand("UPDATE StockTransfers SET Status = CASE WHEN NOT EXISTS(SELECT 1 FROM StockTransferLines WHERE TransferID=@T AND ReceivedQuantity < TransferQuantity) THEN N'Received' ELSE N'Partial' END WHERE TransferID=@T", con, tx)
                        cmdStatus.Parameters.AddWithValue("@T", transferId)
                        cmdStatus.ExecuteNonQuery()
                    End Using

                    tx.Commit()
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Public Function CreateStockAdjustment(branchId As Integer, adjustmentDate As DateTime, reasonCode As String, reason As String, createdBy As Integer, lines As DataTable) As Integer
        ' lines schema: MaterialID(int), SystemQuantity(decimal), ActualQuantity(decimal), UnitCost(decimal)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    Dim adjNumber As String = GetNextDocumentNumber("ADJ", branchId, createdBy, con, tx)

                    ' Insert header
                    Dim cmdH = New SqlCommand("INSERT INTO StockAdjustments(AdjustmentNumber, AdjustmentDate, ReasonCode, Reason, Status, CreatedDate, CreatedBy) " &
                                              "OUTPUT INSERTED.AdjustmentID VALUES(@No, @Dt, @Code, @Reason, N'Posted', SYSUTCDATETIME(), @By)", con, tx)
                    cmdH.Parameters.AddWithValue("@No", adjNumber)
                    cmdH.Parameters.AddWithValue("@Dt", adjustmentDate.Date)
                    cmdH.Parameters.AddWithValue("@Code", reasonCode)
                    cmdH.Parameters.AddWithValue("@Reason", If(reason, CType(DBNull.Value, Object)))
                    cmdH.Parameters.AddWithValue("@By", createdBy)
                    Dim adjustmentId As Integer = CInt(cmdH.ExecuteScalar())

                    ' Prepare detail/stock commands
                    Dim cmdL = New SqlCommand("INSERT INTO StockAdjustmentLines(AdjustmentID, MaterialID, SystemQuantity, ActualQuantity, UnitCost, Notes) VALUES(@A,@M,@Sys,@Act,@C,NULL)", con, tx)
                    cmdL.Parameters.Add("@A", SqlDbType.Int)
                    cmdL.Parameters.Add("@M", SqlDbType.Int)
                    cmdL.Parameters.Add("@Sys", SqlDbType.Decimal).Precision = 18 : cmdL.Parameters("@Sys").Scale = 4
                    cmdL.Parameters.Add("@Act", SqlDbType.Decimal).Precision = 18 : cmdL.Parameters("@Act").Scale = 4
                    cmdL.Parameters.Add("@C", SqlDbType.Decimal).Precision = 18 : cmdL.Parameters("@C").Scale = 4

                    Dim insMove = New SqlCommand("INSERT INTO StockMovements(MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, UnitCost, TotalValue, ReferenceType, ReferenceID, ReferenceNumber, Notes, CreatedDate, CreatedBy) " &
                                                "VALUES(@M,'Adjustment',@D,@In,@Out,@Bal,@Cost,@Val,'ADJ',@RefId,@RefNo,@N,SYSUTCDATETIME(),@By)", con, tx)
                    insMove.Parameters.Add("@M", SqlDbType.Int)
                    insMove.Parameters.Add("@D", SqlDbType.DateTime2)
                    insMove.Parameters.Add("@In", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@In").Scale = 4
                    insMove.Parameters.Add("@Out", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Out").Scale = 4
                    insMove.Parameters.Add("@Bal", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Bal").Scale = 4
                    insMove.Parameters.Add("@Cost", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Cost").Scale = 4
                    insMove.Parameters.Add("@Val", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Val").Scale = 2
                    insMove.Parameters.Add("@RefId", SqlDbType.Int)
                    insMove.Parameters.Add("@RefNo", SqlDbType.NVarChar, 30)
                    insMove.Parameters.Add("@N", SqlDbType.NVarChar, 255)
                    insMove.Parameters.Add("@By", SqlDbType.Int)

                    Dim updRM = New SqlCommand("UPDATE RawMaterials SET CurrentStock = CurrentStock + @Delta, LastCost = CASE WHEN @Delta>0 THEN @C ELSE LastCost END, " &
                                              "AverageCost = CASE WHEN (COALESCE(CurrentStock,0) + @Delta) = 0 THEN AverageCost ELSE ((AverageCost * COALESCE(NULLIF(CurrentStock,0),0)) + (@C * COALESCE(NULLIF(CASE WHEN @Delta>0 THEN @Delta ELSE 0 END,0),0))) / NULLIF(COALESCE(CurrentStock,0) + @Delta,0) END " &
                                              "WHERE MaterialID = @M", con, tx)
                    updRM.Parameters.Add("@Delta", SqlDbType.Decimal).Precision = 18 : updRM.Parameters("@Delta").Scale = 4
                    updRM.Parameters.Add("@C", SqlDbType.Decimal).Precision = 18 : updRM.Parameters("@C").Scale = 4
                    updRM.Parameters.Add("@M", SqlDbType.Int)

                    Dim netValue As Decimal = 0D

                    For Each r As DataRow In lines.Rows
                        Dim matId = Convert.ToInt32(r("MaterialID"))
                        Dim sysQty = Convert.ToDecimal(r("SystemQuantity"))
                        Dim actQty = Convert.ToDecimal(r("ActualQuantity"))
                        Dim unitCost = Convert.ToDecimal(r("UnitCost"))
                        Dim delta = actQty - sysQty
                        If delta = 0D Then Continue For

                        ' Insert detail line
                        cmdL.Parameters("@A").Value = adjustmentId
                        cmdL.Parameters("@M").Value = matId
                        cmdL.Parameters("@Sys").Value = sysQty
                        cmdL.Parameters("@Act").Value = actQty
                        cmdL.Parameters("@C").Value = unitCost
                        cmdL.ExecuteNonQuery()

                        ' Current stock
                        Dim currentBal As Decimal
                        Using cmdBal As New SqlCommand("SELECT CurrentStock FROM RawMaterials WHERE MaterialID = @M", con, tx)
                            cmdBal.Parameters.AddWithValue("@M", matId)
                            currentBal = Convert.ToDecimal(cmdBal.ExecuteScalar())
                        End Using
                        Dim newBal = currentBal + delta

                        ' Movement
                        insMove.Parameters("@M").Value = matId
                        insMove.Parameters("@D").Value = adjustmentDate
                        insMove.Parameters("@In").Value = If(delta > 0, Math.Abs(delta), 0D)
                        insMove.Parameters("@Out").Value = If(delta < 0, Math.Abs(delta), 0D)
                        insMove.Parameters("@Bal").Value = newBal
                        insMove.Parameters("@Cost").Value = unitCost
                        insMove.Parameters("@Val").Value = Math.Round(Math.Abs(delta) * unitCost, 2)
                        insMove.Parameters("@RefId").Value = adjustmentId
                        insMove.Parameters("@RefNo").Value = adjNumber
                        insMove.Parameters("@N").Value = reason
                        insMove.Parameters("@By").Value = createdBy
                        insMove.ExecuteNonQuery()

                        ' Update material stock and average cost (only for positive delta)
                        updRM.Parameters("@Delta").Value = delta
                        updRM.Parameters("@C").Value = unitCost
                        updRM.Parameters("@M").Value = matId
                        updRM.ExecuteNonQuery()

                        ' Net value for accounting (loss negative, gain positive)
                        netValue += delta * unitCost
                    Next

                    ' Optional accounting: Inventory gain/loss
                    Dim invAcct = GetSettingInt("InventoryAccountID")
                    Dim gainLossAcct = GetSettingInt("InventoryGainLossAccountID")
                    If invAcct.HasValue AndAlso gainLossAcct.HasValue AndAlso netValue <> 0D Then
                        Dim fiscalPeriodId As Integer = GetFiscalPeriodId(adjustmentDate, branchId, con, tx)
                        Dim jId As Integer = CreateJournalHeader(adjustmentDate, adjNumber, $"Stock Adjustment {reasonCode}", fiscalPeriodId, createdBy, branchId, con, tx)
                        If netValue > 0D Then
                            ' Gain: DR Inventory, CR Gain Account
                            AddJournalDetail(jId, invAcct.Value, Math.Abs(netValue), 0D, $"ADJ {adjNumber}", Nothing, Nothing, con, tx)
                            AddJournalDetail(jId, gainLossAcct.Value, 0D, Math.Abs(netValue), $"ADJ {adjNumber}", Nothing, Nothing, con, tx)
                        Else
                            ' Loss: DR Loss Account, CR Inventory
                            AddJournalDetail(jId, gainLossAcct.Value, Math.Abs(netValue), 0D, $"ADJ {adjNumber}", Nothing, Nothing, con, tx)
                            AddJournalDetail(jId, invAcct.Value, 0D, Math.Abs(netValue), $"ADJ {adjNumber}", Nothing, Nothing, con, tx)
                        End If
                        PostJournal(jId, createdBy, con, tx)
                    End If

                    tx.Commit()
                    Return adjustmentId
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Function

    Public Function CreateCreditNote(supplierId As Integer, branchId As Integer, grnId As Integer, creditDate As DateTime, reason As String, reference As String, notes As String, createdBy As Integer, lines As DataTable) As Integer
        ' lines expected schema: GRNLineID(int, nullable), MaterialID(int), ReturnQuantity(decimal), UnitCost(decimal), [Reason](string, optional), [Comments](string, optional)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Generate CRN number
                    Dim crnNumber As String = GetNextDocumentNumber("CRN", branchId, createdBy, con, tx)

                    ' Compute amounts by reason
                    Dim total As Decimal = 0D
                    Dim damagedTotal As Decimal = 0D
                    Dim shortTotal As Decimal = 0D
                    For Each r As DataRow In lines.Rows
                        Dim qty As Decimal = Convert.ToDecimal(r("ReturnQuantity"))
                        Dim cost As Decimal = Convert.ToDecimal(r("UnitCost"))
                        If qty <= 0D Then Continue For
                        Dim lineTotal As Decimal = qty * cost
                        total += lineTotal
                        Dim lnReason As String = If(TryGetString(r, "Reason"), String.Empty)
                        If lnReason.Equals("Damaged/Expired", StringComparison.OrdinalIgnoreCase) Then
                            damagedTotal += lineTotal
                        ElseIf lnReason.Equals("Short-supply", StringComparison.OrdinalIgnoreCase) Then
                            shortTotal += lineTotal
                        End If
                    Next

                    ' Insert header
                    Dim cmdH = New SqlCommand("INSERT INTO CreditNotes(CreditNoteNumber, SupplierID, BranchID, GRNID, PurchaseOrderID, CreditDate, TotalAmount, Status, Reason, Reference, Notes, CreatedDate, CreatedBy, IsPosted) " &
                                              "OUTPUT INSERTED.CreditNoteID " &
                                              "VALUES(@No,@Sup,@Br,@GRN, (SELECT PurchaseOrderID FROM GoodsReceivedNotes WHERE GRNID=@GRN), @Dt, @Tot, N'Posted', @Reason, @Ref, @Notes, SYSUTCDATETIME(), @By, 1)", con, tx)
                    cmdH.Parameters.AddWithValue("@No", crnNumber)
                    cmdH.Parameters.AddWithValue("@Sup", supplierId)
                    cmdH.Parameters.AddWithValue("@Br", branchId)
                    If grnId > 0 Then
                        cmdH.Parameters.AddWithValue("@GRN", grnId)
                    Else
                        cmdH.Parameters.AddWithValue("@GRN", DBNull.Value)
                    End If
                    cmdH.Parameters.AddWithValue("@Dt", creditDate.Date)
                    cmdH.Parameters.AddWithValue("@Tot", total)
                    cmdH.Parameters.AddWithValue("@Reason", If(reason, CType(DBNull.Value, Object)))
                    cmdH.Parameters.AddWithValue("@Ref", If(reference, CType(DBNull.Value, Object)))
                    cmdH.Parameters.AddWithValue("@Notes", If(notes, CType(DBNull.Value, Object)))
                    cmdH.Parameters.AddWithValue("@By", createdBy)
                    Dim creditNoteId As Integer = CInt(cmdH.ExecuteScalar())

                    ' Prepare detail/stock commands
                    Dim hasReasonCol As Boolean = lines.Columns.Contains("Reason")
                    Dim hasCommentsCol As Boolean = lines.Columns.Contains("Comments")
                    Dim cmdL As SqlCommand
                    If hasReasonCol OrElse hasCommentsCol Then
                        cmdL = New SqlCommand("INSERT INTO CreditNoteLines(CreditNoteID, GRNLineID, MaterialID, ReturnQuantity, UnitCost, Reason, Comments) VALUES(@CN,@GL,@M,@Q,@C,@R,@Com)", con, tx)
                    Else
                        cmdL = New SqlCommand("INSERT INTO CreditNoteLines(CreditNoteID, GRNLineID, MaterialID, ReturnQuantity, UnitCost) VALUES(@CN,@GL,@M,@Q,@C)", con, tx)
                    End If
                    cmdL.Parameters.Add("@CN", SqlDbType.Int)
                    cmdL.Parameters.Add("@GL", SqlDbType.Int)
                    cmdL.Parameters.Add("@M", SqlDbType.Int)
                    cmdL.Parameters.Add("@Q", SqlDbType.Decimal).Precision = 18 : cmdL.Parameters("@Q").Scale = 4
                    cmdL.Parameters.Add("@C", SqlDbType.Decimal).Precision = 18 : cmdL.Parameters("@C").Scale = 4
                    If hasReasonCol OrElse hasCommentsCol Then
                        cmdL.Parameters.Add("@R", SqlDbType.VarChar, 30)
                        cmdL.Parameters.Add("@Com", SqlDbType.NVarChar, 255)
                    End If

                    Dim insMove = New SqlCommand("INSERT INTO StockMovements(MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, UnitCost, TotalValue, ReferenceType, ReferenceID, ReferenceNumber, Notes, CreatedDate, CreatedBy) " &
                                                "VALUES(@M,'Return',@D,0,@Out,@Bal,@Cost,@Val,'CRN',@RefId,@RefNo,@N,SYSUTCDATETIME(),@By)", con, tx)
                    insMove.Parameters.Add("@M", SqlDbType.Int)
                    insMove.Parameters.Add("@D", SqlDbType.DateTime2)
                    insMove.Parameters.Add("@Out", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Out").Scale = 4
                    insMove.Parameters.Add("@Bal", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Bal").Scale = 4
                    insMove.Parameters.Add("@Cost", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Cost").Scale = 4
                    insMove.Parameters.Add("@Val", SqlDbType.Decimal).Precision = 18 : insMove.Parameters("@Val").Scale = 2
                    insMove.Parameters.Add("@RefId", SqlDbType.Int)
                    insMove.Parameters.Add("@RefNo", SqlDbType.NVarChar, 30)
                    insMove.Parameters.Add("@N", SqlDbType.NVarChar, 255)
                    insMove.Parameters.Add("@By", SqlDbType.Int)

                    Dim updRM = New SqlCommand("UPDATE RawMaterials SET CurrentStock = CurrentStock - @Q, LastCost = @C, AverageCost = CASE WHEN COALESCE(CurrentStock,0) - @Q = 0 THEN AverageCost ELSE ((AverageCost * COALESCE(NULLIF(CurrentStock,0),0)) - (@C * @Q)) / NULLIF(COALESCE(CurrentStock,0) - @Q,0) END WHERE MaterialID = @M", con, tx)
                    updRM.Parameters.Add("@Q", SqlDbType.Decimal).Precision = 18 : updRM.Parameters("@Q").Scale = 4
                    updRM.Parameters.Add("@C", SqlDbType.Decimal).Precision = 18 : updRM.Parameters("@C").Scale = 4
                    updRM.Parameters.Add("@M", SqlDbType.Int)

                    For Each r As DataRow In lines.Rows
                        Dim matId = Convert.ToInt32(r("MaterialID"))
                        Dim qty = Convert.ToDecimal(r("ReturnQuantity"))
                        Dim cost = Convert.ToDecimal(r("UnitCost"))
                        If qty <= 0 Then Continue For
                        Dim lnReason As String = If(TryGetString(r, "Reason"), String.Empty)
                        Dim lnComments As String = If(TryGetString(r, "Comments"), Nothing)

                        ' Insert detail line
                        cmdL.Parameters("@CN").Value = creditNoteId
                        If r.IsNull("GRNLineID") Then
                            cmdL.Parameters("@GL").Value = DBNull.Value
                        Else
                            cmdL.Parameters("@GL").Value = Convert.ToInt32(r("GRNLineID"))
                        End If
                        cmdL.Parameters("@M").Value = matId
                        cmdL.Parameters("@Q").Value = qty
                        cmdL.Parameters("@C").Value = cost
                        If hasReasonCol OrElse hasCommentsCol Then
                            cmdL.Parameters("@R").Value = If(String.IsNullOrWhiteSpace(lnReason), CType(DBNull.Value, Object), lnReason)
                            cmdL.Parameters("@Com").Value = If(String.IsNullOrWhiteSpace(lnComments), CType(DBNull.Value, Object), lnComments)
                        End If
                        cmdL.ExecuteNonQuery()

                        ' Stock movement only for Damaged/Expired
                        If lnReason.Equals("Damaged/Expired", StringComparison.OrdinalIgnoreCase) Then
                            ' Get current stock
                            Dim currentBal As Decimal
                            Using cmdBal As New SqlCommand("SELECT CurrentStock FROM RawMaterials WHERE MaterialID = @M", con, tx)
                                cmdBal.Parameters.AddWithValue("@M", matId)
                                currentBal = Convert.ToDecimal(cmdBal.ExecuteScalar())
                            End Using
                            Dim newBal = currentBal - qty

                            ' Stock movement (Return OUT)
                            insMove.Parameters("@M").Value = matId
                            insMove.Parameters("@D").Value = creditDate
                            insMove.Parameters("@Out").Value = qty
                            insMove.Parameters("@Bal").Value = newBal
                            insMove.Parameters("@Cost").Value = cost
                            insMove.Parameters("@Val").Value = Math.Round(qty * cost, 2)
                            insMove.Parameters("@RefId").Value = creditNoteId
                            insMove.Parameters("@RefNo").Value = crnNumber
                            insMove.Parameters("@N").Value = If(String.IsNullOrWhiteSpace(lnComments), notes, lnComments)
                            insMove.Parameters("@By").Value = createdBy
                            insMove.ExecuteNonQuery()

                            ' Update material stock
                            updRM.Parameters("@Q").Value = qty
                            updRM.Parameters("@C").Value = cost
                            updRM.Parameters("@M").Value = matId
                            updRM.ExecuteNonQuery()
                        End If
                    Next

                    ' Post accounting split by reason
                    Dim apAcct = ResolveSupplierAPAccountId(supplierId, con, tx)
                    Dim invAcct = GetSettingInt("InventoryAccountID")
                    Dim shortClearingAcct = GetSettingInt("ShortSupplyClearingAccountID")
                    If apAcct.HasValue AndAlso total > 0D Then
                        Dim fiscalPeriodId As Integer = GetFiscalPeriodId(creditDate, branchId, con, tx)
                        Dim journalId As Integer = CreateJournalHeader(creditDate, crnNumber, $"Supplier Credit Note for GRN {grnId}", fiscalPeriodId, createdBy, branchId, con, tx)
                        ' DR AP for full amount
                        AddJournalDetail(journalId, apAcct.Value, total, 0D, $"CRN {crnNumber}", Nothing, Nothing, con, tx)
                        ' CR Inventory for damaged/expired
                        If invAcct.HasValue AndAlso damagedTotal > 0D Then
                            AddJournalDetail(journalId, invAcct.Value, 0D, damagedTotal, $"CRN {crnNumber} Damaged/Expired", Nothing, Nothing, con, tx)
                        End If
                        ' CR Short-supply clearing for short supply
                        If shortClearingAcct.HasValue AndAlso shortTotal > 0D Then
                            AddJournalDetail(journalId, shortClearingAcct.Value, 0D, shortTotal, $"CRN {crnNumber} Short-supply", Nothing, Nothing, con, tx)
                        End If
                        PostJournal(journalId, createdBy, con, tx)
                    End If

                    tx.Commit()
                    Return creditNoteId
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Function

    ' Attempts to resolve the supplier-specific AP account; falls back to system setting keys.
    Private Function ResolveSupplierAPAccountId(supplierId As Integer, con As SqlConnection, tx As SqlTransaction) As Integer?
        ' Try supplier column if available
        Try
            Using cmd As New SqlCommand("SELECT AccountsPayableAccountID FROM Suppliers WHERE SupplierID = @Id", con, tx)
                cmd.Parameters.AddWithValue("@Id", supplierId)
                Dim obj = cmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Dim v = Convert.ToInt32(obj)
                    If v > 0 Then Return v
                End If
            End Using
        Catch
            ' Ignore schema mismatch and fallback
        End Try
        ' Alternate supplier PK name
        Try
            Using cmd As New SqlCommand("SELECT AccountsPayableAccountID FROM Suppliers WHERE ID = @Id", con, tx)
                cmd.Parameters.AddWithValue("@Id", supplierId)
                Dim obj = cmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Dim v = Convert.ToInt32(obj)
                    If v > 0 Then Return v
                End If
            End Using
        Catch
        End Try
        ' System settings fallbacks
        Dim ap1 = GetSettingInt("AccountsPayableAccountID")
        If ap1.HasValue Then Return ap1
        Dim ap2 = GetSettingInt("APAccountID")
        If ap2.HasValue Then Return ap2
        Return Nothing
    End Function

    ' Resolve expense account for purchase returns (non-stock). Tries supplier default, then system setting.
    Private Function ResolvePurchaseReturnsExpenseAccountId(supplierId As Integer, con As SqlConnection, tx As SqlTransaction) As Integer?
        ' Try supplier default expense if available
        Try
            Using cmd As New SqlCommand("SELECT DefaultExpenseAccountID FROM Suppliers WHERE SupplierID = @Id", con, tx)
                cmd.Parameters.AddWithValue("@Id", supplierId)
                Dim obj = cmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Dim v = Convert.ToInt32(obj)
                    If v > 0 Then Return v
                End If
            End Using
        Catch
        End Try
        Try
            Using cmd As New SqlCommand("SELECT DefaultExpenseAccountID FROM Suppliers WHERE ID = @Id", con, tx)
                cmd.Parameters.AddWithValue("@Id", supplierId)
                Dim obj = cmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Dim v = Convert.ToInt32(obj)
                    If v > 0 Then Return v
                End If
            End Using
        Catch
        End Try
        ' System setting fallbacks
        Dim r1 = GetSettingInt("PurchaseReturnsExpenseAccountID")
        If r1.HasValue Then Return r1
        Dim r2 = GetSettingInt("ReturnsExpenseAccountID")
        If r2.HasValue Then Return r2
        Return Nothing
    End Function

    Private Function GetFiscalPeriodId(docDate As DateTime, branchId As Integer, con As SqlConnection, tx As SqlTransaction) As Integer
        Using cmd As New SqlCommand("SELECT TOP 1 PeriodID FROM FiscalPeriods WHERE @d BETWEEN StartDate AND EndDate AND IsClosed = 0 ORDER BY StartDate DESC", con, tx)
            cmd.Parameters.AddWithValue("@d", docDate.Date)
            Dim obj = cmd.ExecuteScalar()
            If obj Is Nothing OrElse obj Is DBNull.Value Then Throw New ApplicationException("No open fiscal period for date")
            Return Convert.ToInt32(obj)
        End Using
    End Function

    Private Function CreateJournalHeader(journalDate As DateTime, reference As String, description As String, fiscalPeriodId As Integer, createdBy As Integer, branchId As Integer, con As SqlConnection, tx As SqlTransaction) As Integer
        Using cmd As New SqlCommand("sp_CreateJournalEntry", con, tx)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@JournalDate", journalDate.Date)
            cmd.Parameters.AddWithValue("@Reference", reference)
            cmd.Parameters.AddWithValue("@Description", description)
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

    Public Function GetSuppliersLookup() As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            Dim sql = "SELECT SupplierID, SupplierCode, CompanyName FROM Suppliers WHERE IsActive = 1 ORDER BY CompanyName"
            Using ad As New SqlDataAdapter(sql, con)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    Public Function GetMaterialsLookup() As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            Dim sql = "SELECT MaterialID, MaterialCode, MaterialName, AverageCost FROM RawMaterials WHERE IsActive = 1 ORDER BY MaterialName"
            Using ad As New SqlDataAdapter(sql, con)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    ' Unified Purchase Order items lookup: includes RawMaterials and purchasable Products.
    ' Columns: MaterialID, MaterialCode, MaterialName, AverageCost, ItemSource ('RM' or 'PR'), CategoryName, SubcategoryName
    ' Note: MaterialID for 'PR' rows refers to ProductID. Callers must check ItemSource when persisting.
    Public Function GetPOItemsLookup() As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            con.Open()
            ' Detect optional product cost columns to avoid invalid column errors
            Dim hasLastPurchaseCost As Boolean = False
            Dim hasStandardCost As Boolean = False
            Try
                Using cmdCol As New SqlCommand("SELECT CASE WHEN COL_LENGTH('dbo.Products','LastPurchaseCost') IS NULL THEN 0 ELSE 1 END, " & _
                                              "CASE WHEN COL_LENGTH('dbo.Products','StandardCost') IS NULL THEN 0 ELSE 1 END", con)
                    Using rdr = cmdCol.ExecuteReader()
                        If rdr.Read() Then
                            hasLastPurchaseCost = (rdr.GetInt32(0) = 1)
                            hasStandardCost = (rdr.GetInt32(1) = 1)
                        End If
                    End Using
                End Using
            Catch
                ' If detection fails, assume columns are missing to keep query safe
                hasLastPurchaseCost = False
                hasStandardCost = False
            End Try

            Dim purchaseCostExpr As String
            If hasLastPurchaseCost AndAlso hasStandardCost Then
                purchaseCostExpr = "COALESCE(NULLIF(p.LastPurchaseCost,0), p.StandardCost, 0) AS PurchaseCost"
            ElseIf hasLastPurchaseCost Then
                purchaseCostExpr = "ISNULL(NULLIF(p.LastPurchaseCost,0), 0) AS PurchaseCost"
            ElseIf hasStandardCost Then
                purchaseCostExpr = "ISNULL(p.StandardCost, 0) AS PurchaseCost"
            Else
                purchaseCostExpr = "CAST(0 AS decimal(18,4)) AS PurchaseCost"
            End If

            Dim sql As String = _
                "WITH prod AS ( " & _
                "   SELECT p.ProductID, p.ProductCode, p.ProductName, " & purchaseCostExpr & ", " & _
                "          c.CategoryName, s.SubcategoryName, p.IsActive, p.CategoryID, p.SubcategoryID " & _
                "   FROM dbo.Products p " & _
                "   LEFT JOIN dbo.Categories c ON c.CategoryID = p.CategoryID " & _
                "   LEFT JOIN dbo.Subcategories s ON s.SubcategoryID = p.SubcategoryID " & _
                " ) " & _
                " SELECT rm.MaterialID AS MaterialID, rm.MaterialCode AS MaterialCode, " & _
                "        rm.MaterialName AS MaterialName, rm.AverageCost AS AverageCost, " & _
                "        CAST('RM' AS nvarchar(2)) AS ItemSource, " & _
                "        pc.CategoryName AS CategoryName, CAST(NULL AS nvarchar(100)) AS SubcategoryName " & _
                " FROM dbo.RawMaterials rm " & _
                " LEFT JOIN dbo.ProductCategories pc ON pc.CategoryID = rm.CategoryID " & _
                " WHERE ISNULL(rm.IsActive,1) = 1 " & _
                " UNION ALL " & _
                " SELECT p.ProductID AS MaterialID, p.ProductCode AS MaterialCode, " & _
                "        p.ProductName AS MaterialName, p.PurchaseCost AS AverageCost, " & _
                "        CAST('PR' AS nvarchar(2)) AS ItemSource, " & _
                "        p.CategoryName, p.SubcategoryName " & _
                " FROM prod p " & _
                " WHERE p.IsActive = 1 " & _
                "   AND p.CategoryID IS NOT NULL AND p.SubcategoryID IS NOT NULL " & _
                "   AND (OBJECT_ID('dbo.ProductRecipe','U') IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.ProductRecipe pr WHERE pr.ProductID = p.ProductID)) " & _
                "   AND (OBJECT_ID('dbo.BOMHeader','U') IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.BOMHeader bh WHERE bh.ProductID = p.ProductID)) " & _
                " ORDER BY MaterialName"
            Using ad As New SqlDataAdapter(sql, con)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    Public Function GetBranchesLookup() As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            Try
                Dim sql = "SELECT BranchID, BranchName, Prefix FROM Branches ORDER BY BranchName"
                Using ad As New SqlDataAdapter(sql, con)
                    ad.Fill(dt)
                End Using
            Catch
                ' Fallback for legacy schema where primary key column is ID
                Dim sqlLegacy = "SELECT ID AS BranchID, BranchName, Prefix FROM Branches ORDER BY BranchName"
                Using ad As New SqlDataAdapter(sqlLegacy, con)
                    ad.Fill(dt)
                End Using
            End Try
        End Using
        Return dt
    End Function

    Public Function GetLastPaidPrice(supplierId As Integer, materialId As Integer) As Nullable(Of Decimal)
        If supplierId <= 0 OrElse materialId <= 0 Then Return Nothing
        Using con As New SqlConnection(connectionString)
            Dim sql = "SELECT TOP 1 gl.UnitCost FROM GoodsReceivedNotes g " &
                      "INNER JOIN GRNLines gl ON gl.GRNID = g.GRNID " &
                      "WHERE g.SupplierID = @sid AND gl.MaterialID = @mid " &
                      "ORDER BY g.ReceivedDate DESC, gl.GRNLineID DESC"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@sid", supplierId)
                cmd.Parameters.AddWithValue("@mid", materialId)
                con.Open()
                Dim obj = cmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Return Convert.ToDecimal(obj)
                End If
            End Using
        End Using
        Return Nothing
    End Function

    Public Function GetMaterialLastCost(materialId As Integer) As Decimal
        If materialId <= 0 Then Return 0D
        Using con As New SqlConnection(connectionString)
            Using cmd As New SqlCommand("SELECT ISNULL(LastCost,0) FROM RawMaterials WHERE MaterialID = @m", con)
                cmd.Parameters.AddWithValue("@m", materialId)
                con.Open()
                Dim obj = cmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Return Convert.ToDecimal(obj)
                End If
            End Using
        End Using
        Return 0D
    End Function

    Public Function GetAllMaterials(Optional branchId As Integer = 0) As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            Dim sql As String
            If branchId > 0 Then
                ' Compute CurrentStock from Inventory for the specified branch.
                sql = "SELECT rm.MaterialID, rm.MaterialCode, rm.MaterialName, rm.MaterialType, rm.UnitOfMeasure, " & _
                      "ISNULL(rm.LastCost,0) AS LastCost, ISNULL(rm.AverageCost,0) AS AverageCost, " & _
                      "ISNULL((SELECT SUM(i.QuantityOnHand) FROM dbo.Inventory i WHERE i.MaterialID = rm.MaterialID AND i.BranchID = @B), 0) AS CurrentStock, " & _
                      "rm.IsActive FROM dbo.RawMaterials rm ORDER BY rm.MaterialName"
            Else
                ' Legacy/global stock view
                sql = "SELECT MaterialID, MaterialCode, MaterialName, MaterialType, UnitOfMeasure, " & _
                      "ISNULL(LastCost,0) AS LastCost, ISNULL(AverageCost,0) AS AverageCost, ISNULL(CurrentStock,0) AS CurrentStock, IsActive " & _
                      "FROM dbo.RawMaterials ORDER BY MaterialName"
            End If
            Using ad As New SqlDataAdapter(sql, con)
                If branchId > 0 Then
                    ad.SelectCommand.Parameters.AddWithValue("@B", branchId)
                End If
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    Public Sub SaveMaterials(changes As DataTable)
        If changes Is Nothing Then Return
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Determine sensible defaults used when incoming rows omit required fields
                    Dim defaultCategoryId As Integer = 0
                    Dim defaultCreatedBy As Integer = 0
                    Try
                        Using cmdCat As New SqlCommand("SELECT CategoryID FROM dbo.ProductCategories WHERE CategoryCode = N'UNCAT'", con, tx)
                            Dim obj = cmdCat.ExecuteScalar()
                            If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                                defaultCategoryId = Convert.ToInt32(obj)
                            End If
                        End Using
                        If defaultCategoryId = 0 Then
                            Using cmdAnyCat As New SqlCommand("SELECT TOP 1 CategoryID FROM dbo.ProductCategories ORDER BY CategoryID", con, tx)
                                Dim obj = cmdAnyCat.ExecuteScalar()
                                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                                    defaultCategoryId = Convert.ToInt32(obj)
                                End If
                            End Using
                        End If
                        Using cmdUser As New SqlCommand("SELECT TOP 1 UserID FROM dbo.Users ORDER BY UserID", con, tx)
                            Dim obj = cmdUser.ExecuteScalar()
                            If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                                defaultCreatedBy = Convert.ToInt32(obj)
                            End If
                        End Using
                    Catch
                        ' Defaults remain 0 if lookups fail; INSERT will still fail in that case which surfaces the real issue
                    End Try
                    For Each r As DataRow In changes.Rows
                        Dim id As Integer = If(r.IsNull("MaterialID"), 0, Convert.ToInt32(r("MaterialID")))
                        Dim code As String = Convert.ToString(r("MaterialCode")).Trim()
                        Dim name As String = Convert.ToString(r("MaterialName")).Trim()
                        Dim mtype As String = Convert.ToString(r("MaterialType")).Trim()
                        Dim uom As String = If(String.IsNullOrWhiteSpace(Convert.ToString(r("UnitOfMeasure"))), "kg", Convert.ToString(r("UnitOfMeasure")).Trim())
                        Dim active As Boolean = False
                        If Not r.IsNull("IsActive") Then active = Convert.ToBoolean(r("IsActive"))
                        Dim lastCost As Decimal = 0D
                        If Not r.IsNull("LastCost") Then lastCost = Convert.ToDecimal(r("LastCost"))
                        Dim avgCost As Decimal = 0D
                        If Not r.IsNull("AverageCost") Then avgCost = Convert.ToDecimal(r("AverageCost"))
                        ' Resolve CategoryID: prefer explicit CategoryID column, else numeric Category column, else fallback defaultCategoryId
                        Dim categoryId As Integer = 0
                        If r.Table.Columns.Contains("CategoryID") AndAlso Not r.IsNull("CategoryID") Then
                            Integer.TryParse(Convert.ToString(r("CategoryID")), categoryId)
                        ElseIf r.Table.Columns.Contains("Category") AndAlso Not r.IsNull("Category") Then
                            Integer.TryParse(Convert.ToString(r("Category")), categoryId)
                        End If
                        If categoryId <= 0 Then categoryId = defaultCategoryId
                        ' Resolve CreatedBy from row if provided; else fallback
                        Dim createdBy As Integer = defaultCreatedBy
                        If r.Table.Columns.Contains("CreatedBy") AndAlso Not r.IsNull("CreatedBy") Then
                            Dim tmp As Integer
                            If Integer.TryParse(Convert.ToString(r("CreatedBy")), tmp) AndAlso tmp > 0 Then createdBy = tmp
                        End If

                        If id = 0 Then
                            ' Insert
                            Using cmd As New SqlCommand("INSERT INTO RawMaterials(MaterialCode, MaterialName, MaterialType, UnitOfMeasure, BaseUnit, CategoryID, LastCost, AverageCost, CurrentStock, IsActive, CreatedDate, CreatedBy) " &
                                                        "OUTPUT INSERTED.MaterialID VALUES(@Code,@Name,@Type,@UoM,@Base,@Cat,@Last,@Avg,0,@Act,SYSUTCDATETIME(),@By)", con, tx)
                                cmd.Parameters.AddWithValue("@Code", If(code, CType(DBNull.Value, Object)))
                                cmd.Parameters.AddWithValue("@Name", name)
                                cmd.Parameters.AddWithValue("@Type", If(String.IsNullOrWhiteSpace(mtype), "Raw", mtype))
                                cmd.Parameters.AddWithValue("@UoM", uom)
                                cmd.Parameters.AddWithValue("@Base", uom)
                                cmd.Parameters.AddWithValue("@Cat", categoryId)
                                cmd.Parameters.AddWithValue("@Last", lastCost)
                                cmd.Parameters.AddWithValue("@Avg", avgCost)
                                cmd.Parameters.AddWithValue("@Act", active)
                                cmd.Parameters.AddWithValue("@By", createdBy)
                                Dim newId = CInt(cmd.ExecuteScalar())
                                r("MaterialID") = newId
                            End Using
                        Else
                            ' Update
                            Using cmd As New SqlCommand("UPDATE RawMaterials SET MaterialCode=@Code, MaterialName=@Name, MaterialType=@Type, UnitOfMeasure=@UoM, BaseUnit=@Base, CategoryID=@Cat, LastCost=@Last, AverageCost=@Avg, IsActive=@Act, ModifiedDate=SYSUTCDATETIME() WHERE MaterialID=@Id", con, tx)
                                cmd.Parameters.AddWithValue("@Id", id)
                                cmd.Parameters.AddWithValue("@Code", If(code, CType(DBNull.Value, Object)))
                                cmd.Parameters.AddWithValue("@Name", name)
                                cmd.Parameters.AddWithValue("@Type", If(String.IsNullOrWhiteSpace(mtype), "Raw", mtype))
                                cmd.Parameters.AddWithValue("@UoM", uom)
                                cmd.Parameters.AddWithValue("@Base", uom)
                                cmd.Parameters.AddWithValue("@Cat", categoryId)
                                cmd.Parameters.AddWithValue("@Last", lastCost)
                                cmd.Parameters.AddWithValue("@Avg", avgCost)
                                cmd.Parameters.AddWithValue("@Act", active)
                                cmd.ExecuteNonQuery()
                            End Using
                        End If
                    Next

                    tx.Commit()
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Private Function GetVatRatePercent() As Decimal
        ' Returns VAT rate percent from SystemSettings (e.g., 15 for 15%). Defaults to 15 if not set.
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using cmd As New SqlCommand("SELECT [Value] FROM SystemSettings WHERE [Key] = 'VATRatePercent'", con)
                Dim obj = cmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    Dim s As String = Convert.ToString(obj)
                    Dim rate As Decimal
                    If Decimal.TryParse(s, rate) Then
                        Return rate
                    End If
                End If
            End Using
        End Using
        Return 15D
    End Function

    Public Function CreatePurchaseOrder(branchId As Integer, supplierId As Integer, orderDate As DateTime, requiredDate As Nullable(Of DateTime), reference As String, notes As String, createdBy As Integer, lines As DataTable) As Integer
        ' lines expected schema: MaterialID(int), OrderedQuantity(decimal), UnitCost(decimal)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    Dim poId As Integer
                    ' Compute totals from lines
                    Dim subTotal As Decimal = 0D
                    For Each r As DataRow In lines.Rows
                        Dim qty As Decimal = Convert.ToDecimal(r("OrderedQuantity"))
                        Dim cost As Decimal = Convert.ToDecimal(r("UnitCost"))
                        subTotal += qty * cost
                    Next
                    Dim vatRatePercent As Decimal = GetVatRatePercent()
                    Dim vat As Decimal = Math.Round(subTotal * (vatRatePercent / 100D), 2)
                    ' Validate Branch exists using BranchID first; fall back to legacy ID if BranchID not present
                    Dim branchExists As Boolean = False
                    Try
                        Using cmdChk As New SqlCommand("SELECT TOP 1 1 FROM dbo.Branches WHERE BranchID = @B", con, tx)
                            cmdChk.Parameters.AddWithValue("@B", branchId)
                            branchExists = (cmdChk.ExecuteScalar() IsNot Nothing)
                        End Using
                    Catch
                        ' If BranchID column doesn't exist, try legacy ID
                        Using cmdChk As New SqlCommand("SELECT TOP 1 1 FROM dbo.Branches WHERE ID = @B", con, tx)
                            cmdChk.Parameters.AddWithValue("@B", branchId)
                            branchExists = (cmdChk.ExecuteScalar() IsNot Nothing)
                        End Using
                    End Try
                    If Not branchExists Then
                        Throw New ApplicationException($"Branch not found for ID {branchId}. Ensure Branches table has a row with this ID and that foreign keys reference the correct Branches primary key column (BranchID or ID).")
                    End If

                    ' Generate document number using configured numbering
                    Dim poNumber As String = GetNextDocumentNumber("PO", branchId, createdBy, con, tx)

                    Dim insertPO = New SqlCommand("INSERT INTO PurchaseOrders(PONumber, SupplierID, BranchID, OrderDate, RequiredDate, Status, SubTotal, VATAmount, Reference, Notes, CreatedDate, CreatedBy) " &
                                               "OUTPUT INSERTED.PurchaseOrderID " &
                                               "VALUES(@PONumber, @SupplierID, @BranchID, @OrderDate, @RequiredDate, N'Draft', @SubTotal, @VATAmount, @Reference, @Notes, SYSUTCDATETIME(), @CreatedBy)", con, tx)
                    insertPO.Parameters.AddWithValue("@PONumber", poNumber)
                    insertPO.Parameters.AddWithValue("@SupplierID", supplierId)
                    insertPO.Parameters.AddWithValue("@BranchID", branchId)
                    insertPO.Parameters.AddWithValue("@OrderDate", orderDate)
                    If requiredDate.HasValue Then
                        insertPO.Parameters.AddWithValue("@RequiredDate", requiredDate.Value)
                    Else
                        insertPO.Parameters.AddWithValue("@RequiredDate", DBNull.Value)
                    End If
                    insertPO.Parameters.AddWithValue("@SubTotal", subTotal)
                    insertPO.Parameters.AddWithValue("@VATAmount", vat)
                    insertPO.Parameters.AddWithValue("@Reference", If(reference, CType(DBNull.Value, Object)))
                    insertPO.Parameters.AddWithValue("@Notes", If(notes, CType(DBNull.Value, Object)))
                    insertPO.Parameters.AddWithValue("@CreatedBy", createdBy)

                    poId = CInt(insertPO.ExecuteScalar())

                    ' Determine if schema supports ProductID/ItemSource on PurchaseOrderLines
                    Dim hasPOL_ProductID As Boolean = False
                    Dim hasPOL_ItemSource As Boolean = False
                    Try
                        hasPOL_ProductID = ColumnExists(con, tx, "PurchaseOrderLines", "ProductID")
                        hasPOL_ItemSource = ColumnExists(con, tx, "PurchaseOrderLines", "ItemSource")
                    Catch
                        hasPOL_ProductID = False : hasPOL_ItemSource = False
                    End Try

                    Dim insertLineRaw As SqlCommand = Nothing
                    Dim insertLineProd As SqlCommand = Nothing

                    If hasPOL_ProductID AndAlso hasPOL_ItemSource Then
                        ' Unified insert supporting either RawMaterial or Product with ItemSource
                        insertLineRaw = New SqlCommand("INSERT INTO PurchaseOrderLines(PurchaseOrderID, MaterialID, ProductID, ItemSource, OrderedQuantity, UnitCost) VALUES(@POID, @MaterialID, NULL, N'RM', @Qty, @Cost)", con, tx)
                        insertLineProd = New SqlCommand("INSERT INTO PurchaseOrderLines(PurchaseOrderID, MaterialID, ProductID, ItemSource, OrderedQuantity, UnitCost) VALUES(@POID, NULL, @ProductID, N'PR', @Qty, @Cost)", con, tx)

                        insertLineRaw.Parameters.Add("@POID", SqlDbType.Int)
                        insertLineRaw.Parameters.Add("@MaterialID", SqlDbType.Int)
                        insertLineRaw.Parameters.Add("@Qty", SqlDbType.Decimal).Precision = 18 : insertLineRaw.Parameters("@Qty").Scale = 4
                        insertLineRaw.Parameters.Add("@Cost", SqlDbType.Decimal).Precision = 18 : insertLineRaw.Parameters("@Cost").Scale = 4

                        insertLineProd.Parameters.Add("@POID", SqlDbType.Int)
                        insertLineProd.Parameters.Add("@ProductID", SqlDbType.Int)
                        insertLineProd.Parameters.Add("@Qty", SqlDbType.Decimal).Precision = 18 : insertLineProd.Parameters("@Qty").Scale = 4
                        insertLineProd.Parameters.Add("@Cost", SqlDbType.Decimal).Precision = 18 : insertLineProd.Parameters("@Cost").Scale = 4

                        For Each r As DataRow In lines.Rows
                            Dim selId As Integer = Convert.ToInt32(r("MaterialID"))
                            Dim qty As Decimal = Convert.ToDecimal(r("OrderedQuantity"))
                            Dim cost As Decimal = Convert.ToDecimal(r("UnitCost"))

                            ' Does this ID exist in RawMaterials?
                            Dim isRaw As Boolean = False
                            Using cmdChk As New SqlCommand("SELECT TOP 1 1 FROM dbo.RawMaterials WHERE MaterialID = @id", con, tx)
                                cmdChk.Parameters.AddWithValue("@id", selId)
                                Dim o = cmdChk.ExecuteScalar()
                                isRaw = (o IsNot Nothing AndAlso o IsNot DBNull.Value)
                            End Using
                            If isRaw Then
                                insertLineRaw.Parameters("@POID").Value = poId
                                insertLineRaw.Parameters("@MaterialID").Value = selId
                                insertLineRaw.Parameters("@Qty").Value = qty
                                insertLineRaw.Parameters("@Cost").Value = cost
                                insertLineRaw.ExecuteNonQuery()
                            Else
                                ' Otherwise treat as Product if it exists
                                Dim isProd As Boolean = False
                                Using cmdChk As New SqlCommand("SELECT TOP 1 1 FROM dbo.Products WHERE ProductID = @id", con, tx)
                                    cmdChk.Parameters.AddWithValue("@id", selId)
                                    Dim o = cmdChk.ExecuteScalar()
                                    isProd = (o IsNot Nothing AndAlso o IsNot DBNull.Value)
                                End Using
                                If Not isProd Then
                                    Throw New ApplicationException($"Selected item ID {selId} not found in RawMaterials or Products. Please refresh the item list.")
                                End If
                                insertLineProd.Parameters("@POID").Value = poId
                                insertLineProd.Parameters("@ProductID").Value = selId
                                insertLineProd.Parameters("@Qty").Value = qty
                                insertLineProd.Parameters("@Cost").Value = cost
                                insertLineProd.ExecuteNonQuery()
                            End If
                        Next
                    Else
                        ' Legacy schema: only MaterialID supported, so enforce RawMaterials only
                        Dim insertLine = New SqlCommand("INSERT INTO PurchaseOrderLines(PurchaseOrderID, MaterialID, OrderedQuantity, UnitCost) VALUES(@POID, @MaterialID, @Qty, @Cost)", con, tx)
                        insertLine.Parameters.Add("@POID", SqlDbType.Int)
                        insertLine.Parameters.Add("@MaterialID", SqlDbType.Int)
                        insertLine.Parameters.Add("@Qty", SqlDbType.Decimal).Precision = 18 : insertLine.Parameters("@Qty").Scale = 4
                        insertLine.Parameters.Add("@Cost", SqlDbType.Decimal).Precision = 18 : insertLine.Parameters("@Cost").Scale = 4

                        For Each r As DataRow In lines.Rows
                            Dim selId As Integer = Convert.ToInt32(r("MaterialID"))
                            ' Validate exists in RawMaterials to avoid FK errors
                            Dim existsRM As Boolean = False
                            Using cmdChk As New SqlCommand("SELECT TOP 1 1 FROM dbo.RawMaterials WHERE MaterialID = @id", con, tx)
                                cmdChk.Parameters.AddWithValue("@id", selId)
                                Dim o = cmdChk.ExecuteScalar()
                                existsRM = (o IsNot Nothing AndAlso o IsNot DBNull.Value)
                            End Using
                            If Not existsRM Then
                                Throw New ApplicationException("This database schema only supports Raw Materials in Purchase Orders. The selected item is a Product. Please run the migration to add ProductID/ItemSource to PurchaseOrderLines, or select a Raw Material.")
                            End If
                            insertLine.Parameters("@POID").Value = poId
                            insertLine.Parameters("@MaterialID").Value = selId
                            insertLine.Parameters("@Qty").Value = Convert.ToDecimal(r("OrderedQuantity"))
                            insertLine.Parameters("@Cost").Value = Convert.ToDecimal(r("UnitCost"))
                            insertLine.ExecuteNonQuery()
                        Next
                    End If

                    tx.Commit()
                    Return poId
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Function
    Public Function GetAllRawMaterials() As DataTable
        Dim materialsTable As New DataTable()

        Using connection As New SqlConnection(connectionString)
            Dim query As String = "SELECT " &
                                  "MaterialID AS ID, " &
                                  "MaterialCode, " &
                                  "MaterialName AS Name, " &
                                  "CategoryID AS Category, " &
                                  "IsActive, " &
                                  "CreatedDate, " &
                                  "StandardCost, LastCost, AverageCost " &
                                  "FROM RawMaterials ORDER BY MaterialName"

            Using adapter As New SqlDataAdapter(query, connection)
                adapter.Fill(materialsTable)
            End Using
        End Using

        Return materialsTable
    End Function

    Public Function GetAllPurchaseOrders() As DataTable
        Dim ordersTable As New DataTable()

        Using connection As New SqlConnection(connectionString)
            Dim query As String = "SELECT " &
                                  "PurchaseOrderID AS ID, " &
                                  "PONumber AS OrderNumber, " &
                                  "SupplierID, BranchID, Status, " &
                                  "CreatedDate, OrderDate, RequiredDate " &
                                  "FROM PurchaseOrders ORDER BY CreatedDate DESC"

            Using adapter As New SqlDataAdapter(query, connection)
                adapter.Fill(ordersTable)
            End Using
        End Using

        Return ordersTable
    End Function

    Public Function GetLowStockMaterials() As DataTable
        Dim lowStockTable As New DataTable()

        Using connection As New SqlConnection(connectionString)
            Dim query As String = "SELECT " &
                                  "MaterialID AS ID, " &
                                  "MaterialCode, " &
                                  "MaterialName AS Name, " &
                                  "CurrentStock, ReorderLevel, AverageCost, " &
                                  "CAST(AverageCost * ReorderLevel AS DECIMAL(18,2)) AS ReorderValue, " &
                                  "CASE " &
                                  " WHEN CurrentStock = 0 THEN 'Critical - Out of Stock' " &
                                  " WHEN CurrentStock < (ReorderLevel / 2.0) THEN 'Critical - Very Low' " &
                                  " WHEN CurrentStock < ReorderLevel THEN 'Low Stock' " &
                                  " ELSE 'OK' END AS Priority " &
                                  "FROM RawMaterials " &
                                  "WHERE CurrentStock <= ReorderLevel AND IsActive = 1 " &
                                  "ORDER BY MaterialName"

            Using adapter As New SqlDataAdapter(query, connection)
                adapter.Fill(lowStockTable)
            End Using
        End Using

        Return lowStockTable
    End Function

    ' Returns a one-row table with LastPrice, LastSupplier, LastDate, Avg30Days, Avg90Days for a material.
    Public Function GetMaterialPricingSummary(materialId As Integer) As DataTable
        Dim dt As New DataTable()
        If materialId <= 0 Then Return dt
        Using con As New SqlConnection(connectionString)
            Try
                Dim sql = "SELECT " &
                          "(SELECT TOP 1 gl.UnitCost FROM GoodsReceivedNotes g INNER JOIN GRNLines gl ON gl.GRNID = g.GRNID WHERE gl.MaterialID = @mid ORDER BY g.ReceivedDate DESC, gl.GRNLineID DESC) AS LastPrice, " &
                          "(SELECT TOP 1 s.CompanyName FROM GoodsReceivedNotes g INNER JOIN Suppliers s ON s.SupplierID = g.SupplierID INNER JOIN GRNLines gl ON gl.GRNID = g.GRNID WHERE gl.MaterialID = @mid ORDER BY g.ReceivedDate DESC, gl.GRNLineID DESC) AS LastSupplier, " &
                          "(SELECT TOP 1 g.ReceivedDate FROM GoodsReceivedNotes g INNER JOIN GRNLines gl ON gl.GRNID = g.GRNID WHERE gl.MaterialID = @mid ORDER BY g.ReceivedDate DESC, gl.GRNLineID DESC) AS LastDate, " &
                          "(SELECT AVG(CAST(gl.UnitCost AS DECIMAL(18,4))) FROM GRNLines gl INNER JOIN GoodsReceivedNotes g ON g.GRNID = gl.GRNID WHERE gl.MaterialID = @mid AND g.ReceivedDate >= DATEADD(DAY,-30, SYSUTCDATETIME())) AS Avg30Days, " &
                          "(SELECT AVG(CAST(gl.UnitCost AS DECIMAL(18,4))) FROM GRNLines gl INNER JOIN GoodsReceivedNotes g ON g.GRNID = gl.GRNID WHERE gl.MaterialID = @mid AND g.ReceivedDate >= DATEADD(DAY,-90, SYSUTCDATETIME())) AS Avg90Days"
                Using ad As New SqlDataAdapter(sql, con)
                    ad.SelectCommand.Parameters.AddWithValue("@mid", materialId)
                    ad.Fill(dt)
                End Using
            Catch
                ' If GRN tables are absent, return empty table with expected cols
                dt.Columns.Add("LastPrice", GetType(Decimal))
                dt.Columns.Add("LastSupplier", GetType(String))
                dt.Columns.Add("LastDate", GetType(Date))
                dt.Columns.Add("Avg30Days", GetType(Decimal))
                dt.Columns.Add("Avg90Days", GetType(Decimal))
                dt.Rows.Add(dt.NewRow())
            End Try
        End Using
        Return dt
    End Function

    ' Returns last price and average price grouped by supplier for a material (top recent suppliers first)
    Public Function GetMaterialSupplierPricing(materialId As Integer) As DataTable
        Dim dt As New DataTable()
        If materialId <= 0 Then Return dt
        Using con As New SqlConnection(connectionString)
            Try
                Dim sql = "WITH LastPerSupplier AS (" &
                          " SELECT g.SupplierID, MAX(g.ReceivedDate) AS LastDate " &
                          " FROM GoodsReceivedNotes g " &
                          " INNER JOIN GRNLines gl ON gl.GRNID = g.GRNID " &
                          " WHERE gl.MaterialID = @mid " &
                          " GROUP BY g.SupplierID), " &
                          " Prices AS (" &
                          " SELECT g.SupplierID, gl.UnitCost, g.ReceivedDate " &
                          " FROM GoodsReceivedNotes g INNER JOIN GRNLines gl ON gl.GRNID = g.GRNID " &
                          " WHERE gl.MaterialID = @mid) " &
                          " SELECT TOP 10 s.SupplierID, s.CompanyName, " &
                          "        (SELECT TOP 1 p.UnitCost FROM Prices p WHERE p.SupplierID = s.SupplierID ORDER BY p.ReceivedDate DESC) AS LastPrice, " &
                          "        (SELECT TOP 1 p.ReceivedDate FROM Prices p WHERE p.SupplierID = s.SupplierID ORDER BY p.ReceivedDate DESC) AS LastDate, " &
                          "        (SELECT AVG(CAST(p.UnitCost AS DECIMAL(18,4))) FROM Prices p WHERE p.SupplierID = s.SupplierID AND p.ReceivedDate >= DATEADD(DAY,-90, SYSUTCDATETIME())) AS Avg90Days " &
                          " FROM LastPerSupplier lps " &
                          " INNER JOIN Suppliers s ON s.SupplierID = lps.SupplierID " &
                          " ORDER BY LastDate DESC"
                Using ad As New SqlDataAdapter(sql, con)
                    ad.SelectCommand.Parameters.AddWithValue("@mid", materialId)
                    ad.Fill(dt)
                End Using
            Catch
                ' empty table if schema missing
            End Try
        End Using
        Return dt
    End Function

    ' Returns recent purchase or receipt history for a material
    Public Function GetMaterialPurchaseHistory(materialId As Integer, topN As Integer) As DataTable
        Dim dt As New DataTable()
        If materialId <= 0 Then Return dt
        If topN <= 0 Then topN = 20
        Using con As New SqlConnection(connectionString)
            Try
                Dim sql = "SELECT TOP (@N) g.GRNID, g.GRNNumber, g.ReceivedDate, s.CompanyName, gl.ReceivedQuantity, gl.UnitCost, (gl.ReceivedQuantity * gl.UnitCost) AS LineValue " &
                          "FROM GoodsReceivedNotes g " &
                          "INNER JOIN GRNLines gl ON gl.GRNID = g.GRNID " &
                          "INNER JOIN Suppliers s ON s.SupplierID = g.SupplierID " &
                          "WHERE gl.MaterialID = @mid " &
                          "ORDER BY g.ReceivedDate DESC, g.GRNID DESC"
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@N", topN)
                    cmd.Parameters.AddWithValue("@mid", materialId)
                    Using ad As New SqlDataAdapter(cmd)
                        ad.Fill(dt)
                    End Using
                End Using
            Catch
                ' empty table if schema missing
            End Try
        End Using
        Return dt
    End Function

    ' Catalog CRUD support for SubAssemblies/Decorations/Toppings/Accessories/Packaging
    Private Class CatalogMap
        Public Property Table As String
        Public Property IdCol As String
        Public Property CodeCol As String
        Public Property NameCol As String
        Public Property ActiveCol As String = "IsActive"
        Public Property CurrentCostCol As String = "CurrentCost"
        Public Property LastPaidCostCol As String = "LastPaidCost"
        Public Property LastPurchaseDateCol As String = "LastPurchaseDate"
        Public Property LastSupplierIdCol As String = "LastSupplierID"
    End Class

    Private Function ResolveCatalog(catalogType As String) As CatalogMap
        If String.IsNullOrWhiteSpace(catalogType) Then Return Nothing
        Select Case catalogType.Trim()
            Case "SubAssembly"
                Return New CatalogMap With {.Table = "SubAssemblies", .IdCol = "SubAssemblyID", .CodeCol = "SubAssemblyCode", .NameCol = "SubAssemblyName"}
            Case "Decoration"
                Return New CatalogMap With {.Table = "Decorations", .IdCol = "DecorationID", .CodeCol = "DecorationCode", .NameCol = "DecorationName"}
            Case "Topping"
                Return New CatalogMap With {.Table = "Toppings", .IdCol = "ToppingID", .CodeCol = "ToppingCode", .NameCol = "ToppingName"}
            Case "Accessory"
                Return New CatalogMap With {.Table = "Accessories", .IdCol = "AccessoryID", .CodeCol = "AccessoryCode", .NameCol = "AccessoryName"}
            Case "Packaging"
                Return New CatalogMap With {.Table = "Packaging", .IdCol = "PackagingID", .CodeCol = "PackagingCode", .NameCol = "PackagingName"}
            Case Else
                Return Nothing
        End Select
    End Function

    Public Function GetCatalogItems(catalogType As String) As DataTable
        Dim map = ResolveCatalog(catalogType)
        Dim dt As New DataTable()
        If map Is Nothing Then Return dt
        Using con As New SqlConnection(connectionString)
            con.Open()
            Dim hasUoM As Boolean = False
            Try
                hasUoM = ColumnExists(con, Nothing, map.Table, "UoMID")
            Catch
            End Try
            Dim selectCols As String = $"{map.IdCol} AS ID, {map.CodeCol} AS ItemCode, {map.NameCol} AS ItemName, {map.ActiveCol} AS IsActive, {map.CurrentCostCol} AS CurrentCost, {map.LastPaidCostCol} AS LastPaidCost, {map.LastPurchaseDateCol} AS LastPurchaseDate, {map.LastSupplierIdCol} AS LastSupplierID"
            If hasUoM Then selectCols &= ", UoMID"
            Dim sql = $"SELECT {selectCols} FROM {map.Table} ORDER BY {map.NameCol}"
            Using ad As New SqlDataAdapter(sql, con)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    Public Sub SaveCatalogItems(catalogType As String, changes As DataTable)
        Dim map = ResolveCatalog(catalogType)
        If map Is Nothing OrElse changes Is Nothing Then Return
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    Dim hasUoM As Boolean = False
                    Try
                        hasUoM = ColumnExists(con, tx, map.Table, "UoMID")
                    Catch
                    End Try
                    For Each r As DataRow In changes.Rows
                        Dim id As Integer = 0
                        If r.Table.Columns.Contains("ID") AndAlso Not r.IsNull("ID") Then id = Convert.ToInt32(r("ID"))
                        Dim code As String = If(r.Table.Columns.Contains("ItemCode"), Convert.ToString(r("ItemCode")).Trim(), Nothing)
                        Dim name As String = If(r.Table.Columns.Contains("ItemName"), Convert.ToString(r("ItemName")).Trim(), Nothing)
                        Dim active As Boolean = False
                        If r.Table.Columns.Contains("IsActive") AndAlso Not r.IsNull("IsActive") Then active = Convert.ToBoolean(r("IsActive"))
                        Dim curCost As Object = If(r.Table.Columns.Contains("CurrentCost") AndAlso Not r.IsNull("CurrentCost"), CType(r("CurrentCost"), Object), CType(DBNull.Value, Object))
                        Dim lastPaid As Object = If(r.Table.Columns.Contains("LastPaidCost") AndAlso Not r.IsNull("LastPaidCost"), CType(r("LastPaidCost"), Object), CType(DBNull.Value, Object))
                        Dim lastDate As Object = If(r.Table.Columns.Contains("LastPurchaseDate") AndAlso Not r.IsNull("LastPurchaseDate"), CType(r("LastPurchaseDate"), Object), CType(DBNull.Value, Object))
                        Dim lastSup As Object = If(r.Table.Columns.Contains("LastSupplierID") AndAlso Not r.IsNull("LastSupplierID"), CType(r("LastSupplierID"), Object), CType(DBNull.Value, Object))
                        Dim uomid As Object = CType(DBNull.Value, Object)
                        If hasUoM AndAlso r.Table.Columns.Contains("UoMID") AndAlso Not r.IsNull("UoMID") Then uomid = r("UoMID")

                        If String.IsNullOrWhiteSpace(name) Then Continue For

                        If id = 0 Then
                            Dim cols = $"{map.CodeCol}, {map.NameCol}, {map.ActiveCol}, {map.CurrentCostCol}, {map.LastPaidCostCol}, {map.LastPurchaseDateCol}, {map.LastSupplierIdCol}"
                            Dim vals = "@Code, @Name, @Act, @Cur, @LastPaid, @LastDate, @LastSup"
                            If hasUoM Then
                                cols &= ", UoMID"
                                vals &= ", @UoM"
                            End If
                            Dim sql = $"INSERT INTO {map.Table}({cols}) OUTPUT INSERTED.{map.IdCol} VALUES({vals})"
                            Using cmd As New SqlCommand(sql, con, tx)
                                cmd.Parameters.AddWithValue("@Code", If(code, CType(DBNull.Value, Object)))
                                cmd.Parameters.AddWithValue("@Name", name)
                                cmd.Parameters.AddWithValue("@Act", active)
                                cmd.Parameters.AddWithValue("@Cur", curCost)
                                cmd.Parameters.AddWithValue("@LastPaid", lastPaid)
                                cmd.Parameters.AddWithValue("@LastDate", lastDate)
                                cmd.Parameters.AddWithValue("@LastSup", lastSup)
                                If hasUoM Then cmd.Parameters.AddWithValue("@UoM", uomid)
                                Dim newId = CInt(cmd.ExecuteScalar())
                                If r.Table.Columns.Contains("ID") Then r("ID") = newId
                            End Using
                        Else
                            Dim setSql = $"{map.CodeCol}=@Code, {map.NameCol}=@Name, {map.ActiveCol}=@Act, {map.CurrentCostCol}=@Cur, {map.LastPaidCostCol}=@LastPaid, {map.LastPurchaseDateCol}=@LastDate, {map.LastSupplierIdCol}=@LastSup"
                            If hasUoM Then setSql &= ", UoMID=@UoM"
                            Dim sql = $"UPDATE {map.Table} SET {setSql} WHERE {map.IdCol}=@Id"
                            Using cmd As New SqlCommand(sql, con, tx)
                                cmd.Parameters.AddWithValue("@Id", id)
                                cmd.Parameters.AddWithValue("@Code", If(code, CType(DBNull.Value, Object)))
                                cmd.Parameters.AddWithValue("@Name", name)
                                cmd.Parameters.AddWithValue("@Act", active)
                                cmd.Parameters.AddWithValue("@Cur", curCost)
                                cmd.Parameters.AddWithValue("@LastPaid", lastPaid)
                                cmd.Parameters.AddWithValue("@LastDate", lastDate)
                                cmd.Parameters.AddWithValue("@LastSup", lastSup)
                                If hasUoM Then cmd.Parameters.AddWithValue("@UoM", uomid)
                                cmd.ExecuteNonQuery()
                            End Using
                        End If
                    Next
                    tx.Commit()
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

' === Added minimal helpers for Manufacturing users, today's internal orders, and completion flow ===

    ' Returns active users in the Manufacturing role for a given branch (or all branches when branchId <= 0)
    Public Function GetManufacturingUsersByBranch(branchId As Integer) As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            con.Open()
            Dim sql As String = "SELECT u.UserID, " & _
                                "       CASE " & _
                                "           WHEN LTRIM(RTRIM(COALESCE(u.FirstName, '') + ' ' + COALESCE(u.LastName, ''))) = '' THEN u.Username " & _
                                "           ELSE LTRIM(RTRIM(COALESCE(u.FirstName, '') + ' ' + COALESCE(u.LastName, ''))) " & _
                                "       END AS FullName, " & _
                                "       u.Username, u.BranchID " & _
                                "FROM dbo.Users u " & _
                                "INNER JOIN dbo.Roles r ON r.RoleID = u.RoleID " & _
                                "WHERE u.IsActive = 1 AND r.RoleName = @role " & _
                                "  AND (@bid <= 0 OR u.BranchID = @bid) " & _
                                "ORDER BY FullName"
            Using ad As New SqlDataAdapter(sql, con)
                ad.SelectCommand.Parameters.AddWithValue("@role", "Manufacturer")
                ad.SelectCommand.Parameters.AddWithValue("@bid", branchId)
                ad.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    ' Lists today's Internal Orders for a branch with a composite label: "<InternalOrderNo> — Requested by <User>"
    Public Function GetTodaysInternalOrdersWithLabels(branchId As Integer, Optional status As String = Nothing) As DataTable
        Dim dt As New DataTable()
        Using con As New SqlConnection(connectionString)
            con.Open()
            Dim sql As String = "SELECT IOH.InternalOrderID, IOH.InternalOrderNo, IOH.Status, IOH.RequestedDate, " & _
                                "       COALESCE(u.FirstName + ' ' + u.LastName, 'User') AS RequestedByName, " & _
                                "       (IOH.InternalOrderNo + ' — Requested by ' + COALESCE(u.FirstName + ' ' + u.LastName, 'User')) AS Label " & _
                                "FROM dbo.InternalOrderHeader IOH " & _
                                "LEFT JOIN dbo.Users u ON u.UserID = IOH.RequestedBy " & _
                                "LEFT JOIN dbo.InventoryLocations L ON L.LocationID = IOH.FromLocationID " & _
                                "WHERE CAST(IOH.RequestedDate AS date) = CAST(SYSUTCDATETIME() AS date) " & _
                                "  AND (@bid <= 0 OR L.BranchID = @bid) " & _
                                "  AND (@st IS NULL OR IOH.Status = @st) " & _
                                "ORDER BY IOH.InternalOrderID DESC"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@bid", branchId)
                Dim pSt As New SqlParameter("@st", SqlDbType.NVarChar, 20)
                If String.IsNullOrWhiteSpace(status) Then
                    pSt.Value = DBNull.Value
                Else
                    pSt.Value = status
                End If
                cmd.Parameters.Add(pSt)
                Using ad As New SqlDataAdapter(cmd)
                    ad.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    ' Marks an Internal Order as completed by: fulfilling to MFG, receiving finished goods to MFG, then transferring to Retail.
    ' Notes parsing: expects IOH.Notes to contain "Products: <ProductID>=<Qty>|<ProductID>=<Qty>"
    Public Sub CompleteInternalOrder(internalOrderId As Integer, branchId As Integer, userId As Integer)
        If internalOrderId <= 0 Then Throw New ArgumentException("internalOrderId must be > 0")
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' 1) Load IO header basics and product plan (from Notes if present)
                    Dim ioNo As String = Nothing
                    Dim ioStatus As String = Nothing
                    Dim notes As String = Nothing
                    Using cmd As New SqlCommand("SELECT InternalOrderNo, Status, Notes FROM dbo.InternalOrderHeader WHERE InternalOrderID = @id", con, tx)
                        cmd.Parameters.AddWithValue("@id", internalOrderId)
                        Using rd = cmd.ExecuteReader()
                            If rd.Read() Then
                                ioNo = If(rd.IsDBNull(0), Nothing, rd.GetString(0))
                                ioStatus = If(rd.IsDBNull(1), Nothing, rd.GetString(1))
                                notes = If(rd.IsDBNull(2), Nothing, rd.GetString(2))
                            Else
                                Throw New ApplicationException("Internal Order not found")
                            End If
                        End Using
                    End Using

                    ' 2) Fulfill raw materials to MFG under the same transaction
                    Using cmdF As New SqlCommand("dbo.sp_IO_FulfillToMFG", con, tx)
                        cmdF.CommandType = CommandType.StoredProcedure
                        cmdF.Parameters.AddWithValue("@InternalOrderID", internalOrderId)
                        Dim pB As New SqlParameter("@BranchID", SqlDbType.Int)
                        pB.Value = If(branchId > 0, CType(branchId, Object), DBNull.Value)
                        cmdF.Parameters.Add(pB)
                        Dim pU As New SqlParameter("@UserID", SqlDbType.Int)
                        pU.Value = If(userId > 0, CType(userId, Object), DBNull.Value)
                        cmdF.Parameters.Add(pU)
                        cmdF.ExecuteNonQuery()
                    End Using

                    ' 3) Parse products to finish -> receive to MFG, then transfer to RETAIL
                    Dim planned As New List(Of Tuple(Of Integer, Decimal))()
                    If Not String.IsNullOrWhiteSpace(notes) Then
                        Dim ix = notes.IndexOf("Products:", StringComparison.OrdinalIgnoreCase)
                        If ix >= 0 Then
                            Dim s = notes.Substring(ix + 9).Trim()
                            s = s.TrimStart(" ", ";"c)
                            For Each token In s.Split("|"c)
                                Dim pair = token.Trim()
                                If pair.Length = 0 Then Continue For
                                Dim eq = pair.IndexOf("="c)
                                If eq > 0 Then
                                    Dim pidStr = pair.Substring(0, eq).Trim()
                                    Dim qtyStr = pair.Substring(eq + 1).Trim()
                                    Dim pid As Integer
                                    Dim qty As Decimal
                                    If Integer.TryParse(pidStr, pid) AndAlso Decimal.TryParse(qtyStr, qty) Then
                                        If pid > 0 AndAlso qty > 0D Then planned.Add(Tuple.Create(pid, qty))
                                    End If
                                End If
                            Next
                        End If
                    End If

                    ' Execute product movements via existing procs under transaction
                    For Each t In planned
                        Using cmdIn As New SqlCommand("dbo.sp_FG_ReceiveToMFG", con, tx)
                            cmdIn.CommandType = CommandType.StoredProcedure
                            cmdIn.Parameters.AddWithValue("@ProductID", t.Item1)
                            cmdIn.Parameters.AddWithValue("@Quantity", t.Item2)
                            Dim pB As New SqlParameter("@BranchID", SqlDbType.Int)
                            pB.Value = If(branchId > 0, CType(branchId, Object), DBNull.Value)
                            cmdIn.Parameters.Add(pB)
                            Dim pU As New SqlParameter("@UserID", SqlDbType.Int)
                            pU.Value = If(userId > 0, CType(userId, Object), DBNull.Value)
                            cmdIn.Parameters.Add(pU)
                            cmdIn.Parameters.AddWithValue("@ToLocationCode", "MFG")
                            cmdIn.ExecuteNonQuery()
                        End Using

                        Using cmdTx As New SqlCommand("dbo.sp_FG_TransferToRetail", con, tx)
                            cmdTx.CommandType = CommandType.StoredProcedure
                            cmdTx.Parameters.AddWithValue("@ProductID", t.Item1)
                            cmdTx.Parameters.AddWithValue("@Quantity", t.Item2)
                            Dim pB2 As New SqlParameter("@BranchID", SqlDbType.Int)
                            pB2.Value = If(branchId > 0, CType(branchId, Object), DBNull.Value)
                            cmdTx.Parameters.Add(pB2)
                            Dim pU2 As New SqlParameter("@UserID", SqlDbType.Int)
                            pU2.Value = If(userId > 0, CType(userId, Object), DBNull.Value)
                            cmdTx.Parameters.Add(pU2)
                            cmdTx.Parameters.AddWithValue("@FromLocationCode", "MFG")
                            cmdTx.Parameters.AddWithValue("@ToLocationCode", "RETAIL")
                            cmdTx.ExecuteNonQuery()
                        End Using
                    Next

                    ' 4) Compute material issue value from IO lines x RawMaterials.AverageCost
                    Dim materialsValue As Decimal = 0D
                    Dim sqlVal As String = "SELECT SUM(ISNULL(l.Quantity,0) * ISNULL(rm.AverageCost,0)) FROM dbo.InternalOrderLines l INNER JOIN dbo.RawMaterials rm ON rm.MaterialID = l.RawMaterialID WHERE l.InternalOrderID = @id AND l.ItemType = 'RawMaterial'"
                    Using cmdV As New SqlCommand(sqlVal, con, tx)
                        cmdV.Parameters.AddWithValue("@id", internalOrderId)
                        Dim o = cmdV.ExecuteScalar()
                        If o IsNot Nothing AndAlso o IsNot DBNull.Value Then materialsValue = Convert.ToDecimal(o)
                    End Using

                    ' 5) Update IO status to Issued (fulfilled) if it is still Open
                    Using cmdU As New SqlCommand("UPDATE dbo.InternalOrderHeader SET Status = CASE WHEN Status = 'Open' THEN 'Issued' ELSE Status END WHERE InternalOrderID = @id", con, tx)
                        cmdU.Parameters.AddWithValue("@id", internalOrderId)
                        cmdU.ExecuteNonQuery()
                    End Using

                    ' 6) Post journals if mappings exist and value > 0
                    If materialsValue > 0D Then
                        Dim fiscalId As Integer = GetFiscalPeriodId(Date.UtcNow, branchId, con, tx)
                        Dim ref As String = ioNo
                        Dim desc1 As String = $"Issue RM to MFG for {ioNo}"
                        Dim desc2 As String = $"Transfer FG to Retail for {ioNo}"

                        ' Resolve accounts via GL mappings
                        Dim acctWIP As Integer = GLMapping.GetMappedAccountId(con, "WIP", branchId)
                        Dim acctInvRaw As Integer = GLMapping.GetMappedAccountId(con, "InventoryRaw", branchId)
                        Dim acctInvRetail As Integer = GLMapping.GetMappedAccountId(con, "RetailInventory", branchId)

                        ' Journal 1: DR WIP; CR InventoryRaw
                        If acctWIP > 0 AndAlso acctInvRaw > 0 Then
                            Dim j1 As Integer = CreateJournalHeader(Date.UtcNow, ref, desc1, fiscalId, userId, branchId, con, tx)
                            AddJournalDetail(j1, acctWIP, Math.Round(materialsValue, 2), 0D, desc1, ioNo, Nothing, con, tx)
                            AddJournalDetail(j1, acctInvRaw, 0D, Math.Round(materialsValue, 2), desc1, ioNo, Nothing, con, tx)
                            PostJournal(j1, userId, con, tx)
                        End If

                        ' Journal 2: DR RetailInventory; CR WIP
                        If acctInvRetail > 0 AndAlso acctWIP > 0 Then
                            Dim j2 As Integer = CreateJournalHeader(Date.UtcNow, ref, desc2, fiscalId, userId, branchId, con, tx)
                            AddJournalDetail(j2, acctInvRetail, Math.Round(materialsValue, 2), 0D, desc2, ioNo, Nothing, con, tx)
                            AddJournalDetail(j2, acctWIP, 0D, Math.Round(materialsValue, 2), desc2, ioNo, Nothing, con, tx)
                            PostJournal(j2, userId, con, tx)
                        End If
                    End If

                    tx.Commit()
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

End Class
