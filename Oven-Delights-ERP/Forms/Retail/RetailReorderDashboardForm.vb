Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms
Imports Oven_Delights_ERP.Common
Imports Oven_Delights_ERP.Services
Imports Oven_Delights_ERP.Purchasing

Namespace Retail
    Public Class RetailReorderDashboardForm
        Inherits Form

        Private ReadOnly dgv As New DataGridView()
        Private ReadOnly txtSearch As New TextBox()
        Private ReadOnly lbl As New Label()
        Private ReadOnly btnRefresh As New Button()
        Private ReadOnly btnClose As New Button()
        Private ReadOnly lblPath As New Label()

        Public Sub New()
            Me.Text = "Retail - Reorder Dashboard"
            Me.Name = "RetailReorderDashboardForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.Size = New Size(1200, 700)

            lbl.Text = "Reorder Dashboard (Retail)"
            lbl.Font = New Font("Segoe UI", 14, FontStyle.Bold)
            lbl.AutoSize = True
            lbl.Location = New Point(20, 15)

            txtSearch.PlaceholderText = "Search by SKU or Name..."
            txtSearch.Location = New Point(22, 55)
            txtSearch.Width = 340
            AddHandler txtSearch.TextChanged, AddressOf OnSearchChanged

            btnRefresh.Text = "Refresh"
            btnRefresh.Location = New Point(380, 53)
            AddHandler btnRefresh.Click, Sub() LoadData()

            btnClose.Text = "Close"
            btnClose.Location = New Point(1080, 15)
            AddHandler btnClose.Click, Sub() Me.Close()

            ' Visible path indicator
            lblPath.AutoSize = True
            lblPath.Font = New Font("Segoe UI", 9.5F, FontStyle.Italic)
            lblPath.Text = "Path: -"
            lblPath.Location = New Point(480, 56)

            dgv.Location = New Point(20, 95)
            dgv.Size = New Size(1140, 540)
            dgv.AllowUserToAddRows = False
            dgv.AllowUserToDeleteRows = False
            dgv.SelectionMode = DataGridViewSelectionMode.FullRowSelect
            dgv.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            dgv.MultiSelect = False

            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductID", .HeaderText = "ProductID", .Visible = False})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "SKU", .HeaderText = "SKU", .FillWeight = 14})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductName", .HeaderText = "Product Name", .FillWeight = 28})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "OnHand", .HeaderText = "On Hand", .FillWeight = 10})
            dgv.Columns.Add(New DataGridViewCheckBoxColumn() With {.Name = "IsManufactured", .HeaderText = "Manufactured", .FillWeight = 10})
            ' Ensure compatibility with existing string values ("Yes"/"No") if present in the data source
            Dim chkCol = TryCast(dgv.Columns("IsManufactured"), DataGridViewCheckBoxColumn)
            If chkCol IsNot Nothing Then
                chkCol.TrueValue = "Yes"
                chkCol.FalseValue = "No"
                chkCol.IndeterminateValue = DBNull.Value
            End If
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Status", .HeaderText = "Status", .FillWeight = 14})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ReorderQty", .HeaderText = "Reorder Qty", .FillWeight = 10})
            Dim btnCol As New DataGridViewButtonColumn()
            btnCol.Name = "Action"
            btnCol.HeaderText = "Action"
            btnCol.Text = "Reorder"
            btnCol.UseColumnTextForButtonValue = True
            btnCol.FillWeight = 14
            dgv.Columns.Add(btnCol)

            AddHandler dgv.CellFormatting, AddressOf OnCellFormatting
            AddHandler dgv.CellClick, AddressOf OnCellClick
            AddHandler dgv.CellEndEdit, AddressOf OnCellEndEdit

            Controls.Add(lbl)
            Controls.Add(txtSearch)
            Controls.Add(btnRefresh)
            Controls.Add(btnClose)
            Controls.Add(lblPath)
            Controls.Add(dgv)

            LoadData()
        End Sub

        Private Sub WriteDailyOrderBookSetPOCreated(productId As Integer, purchaseOrderId As Integer, supplierId As Integer?, supplierName As String)
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("dbo.sp_DailyOrderBook_SetPurchaseOrderCreated", cn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@BookDate", Services.TimeProvider.Today())
                        cmd.Parameters.AddWithValue("@BranchID", If(AppSession.CurrentBranchID > 0, CType(AppSession.CurrentBranchID, Object), 0))
                        cmd.Parameters.AddWithValue("@ProductID", productId)
                        cmd.Parameters.AddWithValue("@PurchaseOrderID", purchaseOrderId)
                        cmd.Parameters.AddWithValue("@SupplierID", If(supplierId.HasValue, CType(supplierId.Value, Object), CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@SupplierName", If(String.IsNullOrEmpty(supplierName), CType(DBNull.Value, Object), supplierName))
                        cmd.Parameters.AddWithValue("@PurchaseOrderCreatedAtUtc", DateTime.UtcNow)
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
            Catch
            End Try
        End Sub

        Private Sub WriteDailyOrderBookRequested(productId As Integer, sku As String, productName As String, qty As Decimal, requestedById As Integer, requestedByName As String, manufacturerUserId As Integer, manufacturerName As String, internalOrderId As Integer?, orderNumber As String, isInternal As Boolean, supplierId As Integer?, supplierName As String)
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("dbo.sp_DailyOrderBook_UpsertRequested", cn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@BookDate", Services.TimeProvider.Today())
                        cmd.Parameters.AddWithValue("@BranchID", If(AppSession.CurrentBranchID > 0, CType(AppSession.CurrentBranchID, Object), 0))
                        cmd.Parameters.AddWithValue("@ProductID", productId)
                        cmd.Parameters.AddWithValue("@SKU", If(String.IsNullOrEmpty(sku), CType(DBNull.Value, Object), sku))
                        cmd.Parameters.AddWithValue("@ProductName", If(String.IsNullOrEmpty(productName), CType(DBNull.Value, Object), productName))
                        cmd.Parameters.AddWithValue("@OrderNumber", If(String.IsNullOrWhiteSpace(orderNumber), CType(DBNull.Value, Object), orderNumber))
                        cmd.Parameters.AddWithValue("@InternalOrderID", If(internalOrderId.HasValue, CType(internalOrderId.Value, Object), CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@OrderQty", qty)
                        cmd.Parameters.AddWithValue("@RequestedAtUtc", DateTime.UtcNow)
                        cmd.Parameters.AddWithValue("@RequestedBy", If(requestedById > 0, CType(requestedById, Object), CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@RequestedByName", If(String.IsNullOrEmpty(requestedByName), CType(DBNull.Value, Object), requestedByName))
                        cmd.Parameters.AddWithValue("@ManufacturerUserID", If(manufacturerUserId > 0, CType(manufacturerUserId, Object), CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@ManufacturerName", If(String.IsNullOrEmpty(manufacturerName), CType(DBNull.Value, Object), manufacturerName))
                        cmd.Parameters.AddWithValue("@IsInternal", If(isInternal, 1, 0))
                        cmd.Parameters.AddWithValue("@SupplierID", If(supplierId.HasValue, CType(supplierId.Value, Object), CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@SupplierName", If(String.IsNullOrEmpty(supplierName), CType(DBNull.Value, Object), supplierName))
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
            Catch
                ' non-fatal
            End Try
        End Sub

        Private Sub OnCellEndEdit(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex < 0 Then Return
            Dim colName = dgv.Columns(e.ColumnIndex).Name
            If Not String.Equals(colName, "ReorderQty", StringComparison.OrdinalIgnoreCase) Then Return
            Dim row = dgv.Rows(e.RowIndex)
            Dim qtyVal As Object = row.Cells("ReorderQty").Value
            Dim qty As Decimal
            If qtyVal Is Nothing OrElse Not Decimal.TryParse(qtyVal.ToString(), qty) OrElse qty <= 0D Then
                MessageBox.Show(Me, "Enter a valid Reorder Qty (number > 0).", "Reorder", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End If
            ' Do not trigger any reorder logic here; reorder happens only on clicking the Action button
            Return
        End Sub

        Private Sub OnSearchChanged(sender As Object, e As EventArgs)
            LoadData()
        End Sub

        Private Sub LoadData()
            dgv.Rows.Clear()
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()

                    Dim sql As String = ""
                    sql &= "DECLARE @BranchID INT = @pBranchID;" & vbCrLf
                    sql &= "DECLARE @RetailLoc INT = dbo.fn_GetLocationId(@BranchID, N'RETAIL');" & vbCrLf
                    sql &= "IF @RetailLoc IS NULL SET @RetailLoc = dbo.fn_GetLocationId(NULL, N'RETAIL');" & vbCrLf
                    sql &= "IF @RetailLoc IS NULL SET @RetailLoc = 0;" & vbCrLf
                    sql &= "WITH Base AS (" & vbCrLf
                    sql &= "  SELECT p.ProductID, p.ProductCode AS SKU, p.ProductName, " & vbCrLf
                    sql &= "         CAST(CASE WHEN EXISTS(SELECT 1 FROM dbo.BOMHeader bh WHERE bh.ProductID=p.ProductID AND bh.IsActive=1 AND (bh.EffectiveTo IS NULL OR bh.EffectiveTo >= CAST(GETDATE() AS DATE))) " & vbCrLf
                    sql &= "              THEN 1 ELSE 0 END AS BIT) AS IsManufactured, " & vbCrLf
                    sql &= "         ISNULL(SUM(rs.QtyOnHand),0) AS OnHand " & vbCrLf
                    sql &= "  FROM dbo.Products p " & vbCrLf
                    sql &= "  LEFT JOIN dbo.Retail_Variant rv ON rv.ProductID = p.ProductID " & vbCrLf
                    sql &= "  LEFT JOIN dbo.Retail_Stock rs ON rs.VariantID = rv.VariantID AND rs.BranchID = @BranchID " & vbCrLf
                    sql &= "  GROUP BY p.ProductID, p.ProductCode, p.ProductName " & vbCrLf
                    sql &= ") " & vbCrLf
                    sql &= "SELECT b.ProductID, b.SKU, b.ProductName, b.IsManufactured, b.OnHand, " & vbCrLf
                    sql &= "       CAST(CASE WHEN b.IsManufactured = 1 THEN " & vbCrLf
                    sql &= "           CASE WHEN EXISTS (" & vbCrLf
                    sql &= "                 SELECT 1 FROM dbo.InternalOrderHeader ioh " & vbCrLf
                    sql &= "                 WHERE ioh.Status IN ('Open','Issued') " & vbCrLf
                    sql &= "                   AND CAST(ioh.RequestedDate AS DATE) = CAST(SYSUTCDATETIME() AS DATE) " & vbCrLf
                    sql &= "                   AND ioh.Notes LIKE 'Products:%' " & vbCrLf
                    sql &= "                   AND (ioh.Notes LIKE '%|' + CAST(b.ProductID AS NVARCHAR(20)) + '=%' OR ioh.Notes LIKE 'Products: ' + CAST(b.ProductID AS NVARCHAR(20)) + '=%')" & vbCrLf
                    sql &= "           ) THEN 'Green' ELSE 'Red' END " & vbCrLf
                    sql &= "         ELSE " & vbCrLf
                    sql &= "           CASE WHEN b.OnHand < 10 THEN 'Red' WHEN b.OnHand BETWEEN 10 AND 14 THEN 'Yellow' ELSE 'Green' END " & vbCrLf
                    sql &= "       END AS NVARCHAR(10)) AS StatusText " & vbCrLf
                    sql &= "FROM Base b " & vbCrLf
                    sql &= "WHERE b.IsManufactured = 1 " & vbCrLf
                    sql &= "  AND (@pSearch = '' OR b.SKU LIKE '%' + @pSearch + '%' OR b.ProductName LIKE '%' + @pSearch + '%') " & vbCrLf
                    sql &= "ORDER BY b.ProductName;"

                    Using cmd As New SqlCommand(sql, cn)
                        Dim branchId As Integer = AppSession.CurrentBranchID
                        If branchId <= 0 Then Throw New ApplicationException("Branch is required.")
                        cmd.Parameters.AddWithValue("@pBranchID", branchId)
                        cmd.Parameters.AddWithValue("@pSearch", txtSearch.Text.Trim())
                        Using rdr = cmd.ExecuteReader()
                            While rdr.Read()
                                Dim isMfg As Boolean = Convert.ToBoolean(rdr("IsManufactured"))
                                Dim statusText As String = rdr("StatusText").ToString()
                                Dim defaultQty As Decimal = If(isMfg, 10D, 0D) ' simple default; external not reordering from here
                                dgv.Rows.Add(New Object() {
                                    rdr("ProductID"),
                                    rdr("SKU").ToString(),
                                    rdr("ProductName").ToString(),
                                    Convert.ToDecimal(If(IsDBNull(rdr("OnHand")), 0D, rdr("OnHand"))),
                                    If(isMfg, "Yes", "No"),
                                    statusText,
                                    defaultQty,
                                    "Reorder"
                                })
                            End While
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, ex.Message, "Reorder Dashboard", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnCellFormatting(sender As Object, e As DataGridViewCellFormattingEventArgs)
            If dgv.Columns(e.ColumnIndex).Name = "Status" AndAlso e.Value IsNot Nothing Then
                Dim statusText As String = e.Value.ToString()
                Dim row = dgv.Rows(e.RowIndex)
                Select Case statusText
                    Case "Red"
                        row.DefaultCellStyle.BackColor = Color.MistyRose
                        row.DefaultCellStyle.ForeColor = Color.Maroon
                    Case "Yellow"
                        row.DefaultCellStyle.BackColor = Color.LemonChiffon
                        row.DefaultCellStyle.ForeColor = Color.DarkGoldenrod
                    Case Else
                        row.DefaultCellStyle.BackColor = Color.Honeydew
                        row.DefaultCellStyle.ForeColor = Color.DarkGreen
                End Select
            End If
        End Sub

        Private Sub OnCellClick(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex < 0 Then Return
            If dgv.Columns(e.ColumnIndex).Name <> "Action" Then Return

            Dim row = dgv.Rows(e.RowIndex)
            Dim prodId As Integer = Convert.ToInt32(row.Cells("ProductID").Value)
            ' Respect the grid's Manufactured checkbox as the source of truth
            Dim isMfg As Boolean = False
            Dim val = row.Cells("IsManufactured").Value
            If TypeOf val Is Boolean Then
                isMfg = CBool(val)
            ElseIf val IsNot Nothing Then
                Dim s As String = val.ToString()
                isMfg = String.Equals(s, "Yes", StringComparison.OrdinalIgnoreCase) OrElse String.Equals(s, "True", StringComparison.OrdinalIgnoreCase) OrElse s = "1"
            End If
            Dim qtyObj = row.Cells("ReorderQty").Value
            Dim qty As Decimal
            If qtyObj Is Nothing OrElse Not Decimal.TryParse(qtyObj.ToString(), qty) OrElse qty <= 0D Then
                MessageBox.Show(Me, "Enter a valid Reorder Qty (number > 0).", "Reorder", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            ' Update visible route indicator for diagnostics
            Dim sku As String = Convert.ToString(row.Cells("SKU").Value)
            If Not isMfg Then
                lblPath.Text = $"Path: External (PO)  |  ProductID={prodId}  SKU={sku}"
                lblPath.ForeColor = Color.SteelBlue
            Else
                lblPath.Text = $"Path: Internal (IO)  |  ProductID={prodId}  SKU={sku}"
                lblPath.ForeColor = Color.DarkGreen
            End If

            If Not isMfg Then
                ' External product -> Prefer transfer from STOCKROOM if available; else create PO
                Try
                    Dim branchId As Integer = AppSession.CurrentBranchID
                    Dim availableInStockroom As Decimal = GetProductOnHandAtLocation(prodId, branchId, "STOCKROOM")
                    If availableInStockroom >= qty AndAlso qty > 0D Then
                        ' Transfer from STOCKROOM to RETAIL immediately
                        Dim svc As New ManufacturingService()
                        svc.TransferToRetail(productId:=prodId,
                                             quantity:=qty,
                                             branchId:=branchId,
                                             userId:=AppSession.CurrentUserID,
                                             fromLocationCode:="STOCKROOM",
                                             toLocationCode:="RETAIL")

                        ' Log request as fulfilled via internal transfer (external product)
                        WriteDailyOrderBookRequested(
                            productId:=prodId,
                            sku:=sku,
                            productName:=Convert.ToString(row.Cells("ProductName").Value),
                            qty:=qty,
                            requestedById:=AppSession.CurrentUserID,
                            requestedByName:=GetCurrentUserDisplayName(),
                            manufacturerUserId:=0,
                            manufacturerName:=Nothing,
                            internalOrderId:=Nothing,
                            orderNumber:=String.Empty,
                            isInternal:=False,
                            supplierId:=Nothing,
                            supplierName:=Nothing)

                        MessageBox.Show(Me, "Transferred from Stockroom to Retail.", "Reorder", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        LoadData()
                        Return
                    End If
                Catch ex As Exception
                    ' If transfer path fails, fall back to creating a PO
                End Try

                ' Fallback: create a Purchase Order
                Dim po = PurchaseOrderCreateForm.CreatePO(Me)
                If Not po.Ok OrElse po.PurchaseOrderID <= 0 Then Return
                Try
                    WriteDailyOrderBookRequested(
                        productId:=prodId,
                        sku:=sku,
                        productName:=Convert.ToString(row.Cells("ProductName").Value),
                        qty:=qty,
                        requestedById:=AppSession.CurrentUserID,
                        requestedByName:=GetCurrentUserDisplayName(),
                        manufacturerUserId:=0,
                        manufacturerName:=Nothing,
                        internalOrderId:=Nothing,
                        orderNumber:=String.Empty,
                        isInternal:=False,
                        supplierId:=po.SupplierID,
                        supplierName:=po.SupplierName)
                    WriteDailyOrderBookSetPOCreated(prodId, po.PurchaseOrderID, po.SupplierID, po.SupplierName)
                    MessageBox.Show(Me, "Purchase Order created for external product.", "Reorder", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    LoadData()
                Catch ex As Exception
                    MessageBox.Show(Me, ex.Message, "Reorder (PO)", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
                Return
            End If

            ' Internal product -> Require manufacturer selection then create IO
            Dim pick = ManufacturerPickerForm.Pick(Me)
            If Not pick.Ok OrElse pick.UserID <= 0 Then
                MessageBox.Show(Me, "You must select a manufacturer to proceed.", "Reorder", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Try
                CreateInternalOrderForManufactured(prodId, qty)
                UpsertRetailOrdersToday(orderNumber:=String.Empty,
                                        productId:=prodId,
                                        sku:=Convert.ToString(row.Cells("SKU").Value),
                                        productName:=Convert.ToString(row.Cells("ProductName").Value),
                                        qty:=qty,
                                        manufacturerUserId:=pick.UserID,
                                        manufacturerName:=pick.UserName)
                WriteDailyOrderBookRequested(
                    productId:=prodId,
                    sku:=Convert.ToString(row.Cells("SKU").Value),
                    productName:=Convert.ToString(row.Cells("ProductName").Value),
                    qty:=qty,
                    requestedById:=AppSession.CurrentUserID,
                    requestedByName:=GetCurrentUserDisplayName(),
                    manufacturerUserId:=pick.UserID,
                    manufacturerName:=pick.UserName,
                    internalOrderId:=Nothing,
                    orderNumber:=String.Empty,
                    isInternal:=True,
                    supplierId:=Nothing,
                    supplierName:=Nothing)
                MessageBox.Show(Me, "Reorder created as Internal Order to Stockroom (bundle for BOM).", "Reorder", MessageBoxButtons.OK, MessageBoxIcon.Information)
                LoadData()
            Catch ex As SqlException
                MessageBox.Show(Me, ex.Message, "Reorder - SQL", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Catch ex As Exception
                MessageBox.Show(Me, ex.Message, "Reorder", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub CreateInternalOrderForManufactured(productId As Integer, outputQty As Decimal)
            Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Using cn As New SqlConnection(cs)
                cn.Open()
                Using cmd As New SqlCommand("dbo.sp_MO_CreateBundleFromBOM", cn)
                    cmd.CommandType = CommandType.StoredProcedure

                    ' Build TVP for dbo.BOMRequestItem (ProductID, OutputQty)
                    Dim tvp As New DataTable()
                    tvp.Columns.Add("ProductID", GetType(Integer))
                    tvp.Columns.Add("OutputQty", GetType(Decimal))
                    tvp.Rows.Add(productId, outputQty)

                    Dim pItems = cmd.Parameters.AddWithValue("@Items", tvp)
                    pItems.SqlDbType = SqlDbType.Structured
                    pItems.TypeName = "dbo.BOMRequestItem"

                    Dim branchId As Integer = AppSession.CurrentBranchID
                    Dim userId As Integer = AppSession.CurrentUserID
                    cmd.Parameters.AddWithValue("@BranchID", branchId)
                    cmd.Parameters.AddWithValue("@UserID", userId)
                    cmd.Parameters.AddWithValue("@FromLocationCode", "STOCKROOM")
                    cmd.Parameters.AddWithValue("@ToLocationCode", "MFG")

                    cmd.ExecuteNonQuery()
                End Using
            End Using
        End Sub

        Private Sub UpsertRetailOrdersToday(orderNumber As String, productId As Integer, sku As String, productName As String, qty As Decimal, manufacturerUserId As Integer, manufacturerName As String)
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Dim branchId As Integer = AppSession.CurrentBranchID
                Dim locId As Integer = GetRetailLocationId(branchId)
                Dim userId As Integer = AppSession.CurrentUserID
                Dim userName As String = GetCurrentUserDisplayName()
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("dbo.sp_RetailOrdersToday_Upsert", cn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@OrderDate", TimeProvider.Today())
                        cmd.Parameters.AddWithValue("@BranchID", If(branchId > 0, branchId, CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@LocationID", If(locId > 0, locId, CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@OrderNumber", If(String.IsNullOrWhiteSpace(orderNumber), CType(DBNull.Value, Object), orderNumber))
                        cmd.Parameters.AddWithValue("@ProductID", productId)
                        cmd.Parameters.AddWithValue("@SKU", If(String.IsNullOrEmpty(sku), CType(DBNull.Value, Object), sku))
                        cmd.Parameters.AddWithValue("@ProductName", If(String.IsNullOrEmpty(productName), CType(DBNull.Value, Object), productName))
                        cmd.Parameters.AddWithValue("@Qty", qty)
                        cmd.Parameters.AddWithValue("@RequestedBy", If(userId > 0, userId, CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@RequestedByName", If(String.IsNullOrEmpty(userName), CType(DBNull.Value, Object), userName))
                        cmd.Parameters.AddWithValue("@ManufacturerUserID", If(manufacturerUserId > 0, manufacturerUserId, CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@ManufacturerName", If(String.IsNullOrEmpty(manufacturerName), CType(DBNull.Value, Object), manufacturerName))
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
            Catch ex As Exception
                ' Non-fatal for reorder, but log to user
                Try
                    MessageBox.Show(Me, "Failed to persist RetailOrdersToday: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Catch
                End Try
            End Try
        End Sub

        Private Function GetRetailLocationId(branchId As Integer) As Integer
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'RETAIL') AS RetailLoc;", cn)
                        cmd.Parameters.AddWithValue("@b", branchId)
                        Dim o = cmd.ExecuteScalar()
                        Return If(o Is Nothing OrElse o Is DBNull.Value, 0, Convert.ToInt32(o))
                    End Using
                End Using
            Catch
                Return 0
            End Try
        End Function

        ' Generic location resolver
        Private Function GetLocationId(branchId As Integer, locationCode As String) As Integer
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, @code);", cn)
                        cmd.Parameters.AddWithValue("@b", branchId)
                        cmd.Parameters.AddWithValue("@code", locationCode)
                        Dim o = cmd.ExecuteScalar()
                        Return If(o Is Nothing OrElse o Is DBNull.Value, 0, Convert.ToInt32(o))
                    End Using
                End Using
            Catch
                Return 0
            End Try
        End Function

        ' Reads ProductInventory on-hand for a product at a specific branch/location
        Private Function GetProductOnHandAtLocation(productId As Integer, branchId As Integer, locationCode As String) As Decimal
            If productId <= 0 Then Return 0D
            Dim locId As Integer = GetLocationId(branchId, locationCode)
            If locId <= 0 Then Return 0D
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("SELECT ISNULL(SUM(rs.QtyOnHand),0) FROM dbo.Retail_Stock rs INNER JOIN dbo.Retail_Variant rv ON rs.VariantID = rv.VariantID WHERE rv.ProductID=@p AND rs.BranchID=@b", cn)
                        cmd.Parameters.AddWithValue("@p", productId)
                        cmd.Parameters.AddWithValue("@b", If(branchId > 0, branchId, CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@l", locId)
                        Dim o = cmd.ExecuteScalar()
                        If o IsNot Nothing AndAlso o IsNot DBNull.Value Then
                            Return Convert.ToDecimal(o)
                        End If
                    End Using
                End Using
            Catch
            End Try
            Return 0D
        End Function

        Private Function HasActiveBOM(productId As Integer) As Boolean
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim sql As String = _
                        "SELECT TOP 1 1 " & _
                        "FROM dbo.BOMHeader h " & _
                        "WHERE h.ProductID=@pid AND h.IsActive=1 " & _
                        "  AND h.EffectiveFrom <= CAST(GETDATE() AS DATE) " & _
                        "  AND (h.EffectiveTo IS NULL OR h.EffectiveTo >= CAST(GETDATE() AS DATE)) " & _
                        "  AND EXISTS (SELECT 1 FROM dbo.BOMLines l WHERE l.BOMID = h.BOMID AND ISNULL(l.IsActive,1)=1)"
                    Using cmd As New SqlCommand(sql, cn)
                        cmd.Parameters.AddWithValue("@pid", productId)
                        Dim o = cmd.ExecuteScalar()
                        Return Not (o Is Nothing OrElse o Is DBNull.Value)
                    End Using
                End Using
            Catch
                Return False
            End Try
        End Function

        Private Function GetCurrentUserDisplayName() As String
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("SELECT TOP 1 (FirstName + ' ' + LastName) FROM dbo.Users WHERE UserID=@id", cn)
                        cmd.Parameters.AddWithValue("@id", AppSession.CurrentUserID)
                        Dim o = cmd.ExecuteScalar()
                        If o Is Nothing OrElse o Is DBNull.Value Then Return String.Empty
                        Return Convert.ToString(o)
                    End Using
                End Using
            Catch
                Return String.Empty
            End Try
        End Function

    End Class
End Namespace
