Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports Oven_Delights_ERP.Services

Namespace Manufacturing
    Public Class CompleteBuildForm
        Inherits Form

        Private cboProduct As ComboBox
        Private btnFind As Button
        Private lblInfo As Label
        Private txtQtyToReceive As TextBox
        Private btnComplete As Button

        Private currentIOId As Integer = 0
        Private currentProductId As Integer = 0
        Private currentBranchId As Integer = 0
        Private currentSuggestedQty As Decimal = 0D
        Private producerUserId As Integer = 0 ' optional filter when launched from Producer Dashboard

        Public Sub New()
            Me.Text = "Manufacturing - Complete Build of Materials"
            Me.Name = "CompleteBuildForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.White
            Me.Width = 820
            Me.Height = 420

            Dim lblProd As New Label() With {.Text = "Product:", .Left = 20, .Top = 20, .AutoSize = True}
            cboProduct = New ComboBox() With {.Left = 90, .Top = 16, .Width = 420, .DropDownStyle = ComboBoxStyle.DropDownList}

            btnFind = New Button() With {.Text = "Find Latest Build", .Left = 520, .Top = 15, .Width = 150}
            lblInfo = New Label() With {.Left = 20, .Top = 60, .Width = 750, .Height = 200, .ForeColor = Color.DimGray}

            Dim lblQty As New Label() With {.Text = "Qty to Receive (FG):", .Left = 20, .Top = 270, .AutoSize = True}
            txtQtyToReceive = New TextBox() With {.Left = 170, .Top = 266, .Width = 100}

            btnComplete = New Button() With {.Text = "Completed", .Left = 20, .Top = 310, .Width = 120}

            Controls.AddRange(New Control() {lblProd, cboProduct, btnFind, lblInfo, lblQty, txtQtyToReceive, btnComplete})

            AddHandler btnFind.Click, AddressOf OnFindLatest
            AddHandler btnComplete.Click, AddressOf OnCompleted

            currentBranchId = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
            LoadProducts()
        End Sub

        ' Optional overload to open form for a specific producer (contextual title)
        Public Sub New(producerName As String)
            Me.New(producerName, 0)
        End Sub

        ' Overload with producer user id for filtering
        Public Sub New(producerName As String, producerUserId As Integer)
            Me.New()
            Me.producerUserId = producerUserId
            If Not String.IsNullOrWhiteSpace(producerName) Then
                Me.Text = $"{Me.Text} - {producerName}"
            End If
            ' Auto-load latest Issued bundle for this producer so product and quantity are pre-filled
            Try
                AutoLoadLatestForProducer()
            Catch
                ' non-fatal
            End Try
        End Sub

        ' Load product and qty context from a specific Internal Order ID
        Private Sub LoadFromInternalOrder(ioId As Integer)
            currentIOId = ioId
            currentProductId = 0
            currentSuggestedQty = 0D
            lblInfo.Text = ""
            txtQtyToReceive.Text = ""
            Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Using cn As New SqlConnection(cs)
                cn.Open()
                Dim notes As String = Nothing
                Dim ioNo As String = Nothing
                Dim status As String = Nothing
                Dim req As String = Nothing
                Using cmd As New SqlCommand("SELECT IOH.InternalOrderNo, IOH.Status, IOH.RequestedDate, IOH.Notes FROM dbo.InternalOrderHeader IOH WHERE IOH.InternalOrderID=@id", cn)
                    cmd.Parameters.AddWithValue("@id", ioId)
                    Using r = cmd.ExecuteReader()
                        If r.Read() Then
                            ioNo = If(r.IsDBNull(0), Nothing, r.GetString(0))
                            status = If(r.IsDBNull(1), Nothing, r.GetString(1))
                            req = If(r.IsDBNull(2), "", Convert.ToDateTime(r.GetValue(2)).ToString("yyyy-MM-dd HH:mm"))
                            notes = If(r.IsDBNull(3), Nothing, r.GetString(3))
                        Else
                            Throw New ApplicationException("Internal Order not found.")
                        End If
                    End Using
                End Using

                ' Try products list in notes first
                Dim firstProductId As Integer = ExtractFirstProductIdFromProductsList(If(notes, String.Empty))
                If firstProductId <= 0 Then
                    ' Fallback: first product line
                    Using cmdL As New SqlCommand("SELECT TOP 1 IOL.ProductID, IOL.Quantity FROM dbo.InternalOrderLines IOL WHERE IOL.InternalOrderID=@id AND IOL.ProductID IS NOT NULL ORDER BY IOL.LineNumber ASC;", cn)
                        cmdL.Parameters.AddWithValue("@id", ioId)
                        Using rl = cmdL.ExecuteReader()
                            If rl.Read() Then
                                firstProductId = If(rl.IsDBNull(0), 0, Convert.ToInt32(rl.GetValue(0)))
                                currentSuggestedQty = If(rl.IsDBNull(1), 0D, Convert.ToDecimal(rl.GetValue(1)))
                            End If
                        End Using
                    End Using
                Else
                    currentSuggestedQty = ParseQtyFromProductsList(notes, firstProductId)
                End If

                If firstProductId > 0 Then
                    currentProductId = firstProductId
                    ' Try to select product in the combo
                    If cboProduct.DataSource IsNot Nothing Then
                        Try : cboProduct.SelectedValue = currentProductId : Catch : End Try
                    End If
                End If

                If currentSuggestedQty > 0D Then
                    txtQtyToReceive.Text = currentSuggestedQty.ToString("0.####")
                End If

                lblInfo.Text = $"Internal Order: {ioNo} (ID {currentIOId}){Environment.NewLine}Status: {status}{Environment.NewLine}Requested: {req}{Environment.NewLine}{notes}"
            End Using
        End Sub

        ' Overload to open directly for a specific Internal Order
        Public Sub New(internalOrderId As Integer)
            Me.New()
            Try
                LoadFromInternalOrder(internalOrderId)
            Catch ex As Exception
                MessageBox.Show("Failed to load Internal Order: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadProducts()
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim sql As String = "SELECT DISTINCT p.ProductID, p.ProductName FROM dbo.Products p " & _
                                        "JOIN dbo.BOMHeader h ON h.ProductID = p.ProductID " & _
                                        "WHERE h.IsActive = 1 AND h.EffectiveFrom <= @today " & _
                                        "  AND (h.EffectiveTo IS NULL OR h.EffectiveTo >= @today) " & _
                                        "ORDER BY p.ProductName"
                    Using cmd As New SqlCommand(sql, cn)
                        cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)
                            cboProduct.DataSource = dt
                            cboProduct.DisplayMember = "ProductName"
                            cboProduct.ValueMember = "ProductID"
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Load products failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnFindLatest(sender As Object, e As EventArgs)
            currentIOId = 0
            currentProductId = 0
            currentSuggestedQty = 0D
            lblInfo.Text = ""
            txtQtyToReceive.Text = ""

            If cboProduct.SelectedValue Is Nothing Then
                MessageBox.Show("Select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            If Not Integer.TryParse(cboProduct.SelectedValue.ToString(), currentProductId) Then Return

            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()

                    ' Resolve branch-specific From/To locations (Stockroom -> MFG)
                    Dim locSql As String = "SELECT dbo.fn_GetLocationId(@b, N'STOCKROOM') AS FromLoc, dbo.fn_GetLocationId(@b, N'MFG') AS ToLoc;"
                    Dim fromLoc As Integer = 0, toLoc As Integer = 0
                    Using cmdLoc As New SqlCommand(locSql, cn)
                        cmdLoc.Parameters.AddWithValue("@b", If(currentBranchId > 0, CType(currentBranchId, Object), DBNull.Value))
                        Using rl = cmdLoc.ExecuteReader()
                            If rl.Read() Then
                                fromLoc = If(IsDBNull(rl("FromLoc")), 0, Convert.ToInt32(rl("FromLoc")))
                                toLoc = If(IsDBNull(rl("ToLoc")), 0, Convert.ToInt32(rl("ToLoc")))
                            End If
                        End Using
                    End Using
                    If fromLoc = 0 OrElse toLoc = 0 Then
                        Throw New ApplicationException("Branch locations not configured (Stockroom/MFG).")
                    End If

                    ' Latest Internal Order bundle for this branch flow and TODAY (UTC); prefer Issued, fallback Open
                    Dim sql As String = "SELECT TOP 1 IOH.InternalOrderID, IOH.InternalOrderNo, IOH.Status, IOH.RequestedDate, IOH.Notes, IOH.RequestedBy, (u.FirstName + ' ' + u.LastName) AS RequestedByName " & _
                                        "FROM dbo.InternalOrderHeader IOH " & _
                                        "LEFT JOIN dbo.Users u ON u.UserID = IOH.RequestedBy " & _
                                        "WHERE IOH.FromLocationID = @fromLoc AND IOH.ToLocationID = @toLoc " & _
                                        "  AND CONVERT(date, IOH.RequestedDate) = @today " & _
                                        "  AND IOH.Notes LIKE 'Products:%' " & _
                                        "  AND IOH.Notes LIKE @prodTag " & _
                                        If(producerUserId > 0, "  AND IOH.RequestedBy = @reqBy ", "") & _
                                        "ORDER BY CASE WHEN IOH.Status='Issued' THEN 0 WHEN IOH.Status='Open' THEN 1 ELSE 2 END, IOH.RequestedDate DESC, IOH.InternalOrderID DESC"
                    Using cmd As New SqlCommand(sql, cn)
                        cmd.Parameters.AddWithValue("@fromLoc", fromLoc)
                        cmd.Parameters.AddWithValue("@toLoc", toLoc)
                        cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                        cmd.Parameters.AddWithValue("@prodTag", "%" & currentProductId.ToString() & "=%")
                        If producerUserId > 0 Then cmd.Parameters.AddWithValue("@reqBy", producerUserId)
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                currentIOId = Convert.ToInt32(r("InternalOrderID"))
                                Dim ioNo As String = r("InternalOrderNo").ToString()
                                Dim status As String = r("Status").ToString()
                                Dim req As String = If(IsDBNull(r("RequestedDate")), "", Convert.ToDateTime(r("RequestedDate")).ToString("yyyy-MM-dd HH:mm"))
                                Dim notes As String = If(IsDBNull(r("Notes")), "", r("Notes").ToString())
                                Dim reqByName As String = If(r.IsDBNull(r.GetOrdinal("RequestedByName")), "", r("RequestedByName").ToString())

                                ' First try new format: Products: <ProductID>=<Qty>|...
                                currentSuggestedQty = ParseQtyFromProductsList(notes, currentProductId)
                                If currentSuggestedQty <= 0D Then
                                    ' Fallback to legacy Qty= in notes if present
                                    currentSuggestedQty = ParseQtyFromNotes(notes)
                                End If
                                If currentSuggestedQty > 0D Then txtQtyToReceive.Text = currentSuggestedQty.ToString("0.####")

                                lblInfo.Text = $"Internal Order: {ioNo} (ID {currentIOId}){Environment.NewLine}Status: {status}{Environment.NewLine}Requested: {req}{Environment.NewLine}Requested By: {reqByName}{Environment.NewLine}{notes}"
                            Else
                                lblInfo.Text = "No open/issued Internal Order bundle found for this branch."
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Find latest failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function ParseQtyFromNotes(notes As String) As Decimal
            If String.IsNullOrWhiteSpace(notes) Then Return 0D
            Try
                ' Pattern: Qty=number; or Qty=number (may be decimal)
                Dim marker As String = "Qty="
                Dim i As Integer = notes.IndexOf(marker, StringComparison.OrdinalIgnoreCase)
                If i >= 0 Then
                    Dim startIdx As Integer = i + marker.Length
                    Dim j As Integer = startIdx
                    While j < notes.Length AndAlso (Char.IsDigit(notes(j)) OrElse notes(j) = "."c)
                        j += 1
                    End While
                    Dim s As String = notes.Substring(startIdx, j - startIdx)
                    Dim v As Decimal
                    If Decimal.TryParse(s, v) Then Return v
                End If
            Catch
            End Try
            Return 0D
        End Function

        ' Parse quantities from the format produced by sp_MO_CreateBundleFromBOM notes:
        ' Example: "Bundle created from BOM(s); Products: 101=12.5|205=3|..."
        Private Function ParseQtyFromProductsList(notes As String, productId As Integer) As Decimal
            If String.IsNullOrWhiteSpace(notes) Then Return 0D
            Dim marker As String = "Products:"
            Dim idx As Integer = notes.IndexOf(marker, StringComparison.OrdinalIgnoreCase)
            If idx < 0 Then Return 0D
            Dim listPart As String = notes.Substring(idx + marker.Length).Trim()
            ' split by '|'
            Dim parts = listPart.Split(New Char() {"|"c}, StringSplitOptions.RemoveEmptyEntries)
            For Each part In parts
                Dim kv = part.Split("="c)
                If kv.Length = 2 Then
                    Dim idStr = kv(0).Trim()
                    Dim qtyStr = kv(1).Trim()
                    Dim id As Integer
                    If Integer.TryParse(idStr, id) AndAlso id = productId Then
                        Dim q As Decimal
                        If Decimal.TryParse(qtyStr, q) Then Return q
                    End If
                End If
            Next
            Return 0D
        End Function

        ' Extract the first ProductID from a "Products: id=qty|..." list in notes
        Private Function ExtractFirstProductIdFromProductsList(notes As String) As Integer
            If String.IsNullOrWhiteSpace(notes) Then Return 0
            Dim marker As String = "Products:"
            Dim idx As Integer = notes.IndexOf(marker, StringComparison.OrdinalIgnoreCase)
            If idx < 0 Then Return 0
            Dim listPart As String = notes.Substring(idx + marker.Length).Trim()
            Dim parts = listPart.Split(New Char() {"|"c}, StringSplitOptions.RemoveEmptyEntries)
            For Each part In parts
                Dim kv = part.Split("="c)
                If kv.Length >= 1 Then
                    Dim idStr = kv(0).Trim()
                    Dim id As Integer
                    If Integer.TryParse(idStr, id) Then Return id
                End If
            Next
            Return 0
        End Function

        ' Auto-load latest bundle for the current producer (if provided) and pre-select product/qty
        Private Sub AutoLoadLatestForProducer()
            If producerUserId <= 0 Then Exit Sub
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()

                    ' Resolve branch-specific From/To locations (Stockroom -> MFG)
                    Dim locSql As String = "SELECT dbo.fn_GetLocationId(@b, N'STOCKROOM') AS FromLoc, dbo.fn_GetLocationId(@b, N'MFG') AS ToLoc;"
                    Dim fromLoc As Integer = 0, toLoc As Integer = 0
                    Using cmdLoc As New SqlCommand(locSql, cn)
                        cmdLoc.Parameters.AddWithValue("@b", If(currentBranchId > 0, CType(currentBranchId, Object), DBNull.Value))
                        Using rl = cmdLoc.ExecuteReader()
                            If rl.Read() Then
                                fromLoc = If(IsDBNull(rl("FromLoc")), 0, Convert.ToInt32(rl("FromLoc")))
                                toLoc = If(IsDBNull(rl("ToLoc")), 0, Convert.ToInt32(rl("ToLoc")))
                            End If
                        End Using
                    End Using
                    If fromLoc = 0 OrElse toLoc = 0 Then Exit Sub

                    ' Get latest IOH for this producer today with Products list
                    Dim sql As String = "SELECT TOP 1 IOH.InternalOrderID, IOH.InternalOrderNo, IOH.Status, IOH.RequestedDate, IOH.Notes " & _
                                        "FROM dbo.InternalOrderHeader IOH " & _
                                        "WHERE IOH.FromLocationID = @fromLoc AND IOH.ToLocationID = @toLoc " & _
                                        "  AND CONVERT(date, IOH.RequestedDate) = @today " & _
                                        "  AND IOH.Notes LIKE 'Products:%' " & _
                                        "  AND IOH.RequestedBy = @reqBy " & _
                                        "ORDER BY CASE WHEN IOH.Status='Issued' THEN 0 WHEN IOH.Status='Open' THEN 1 ELSE 2 END, IOH.RequestedDate DESC, IOH.InternalOrderID DESC"
                    Dim productIdFromNotes As Integer = 0
                    Dim notes As String = Nothing
                    Using cmd As New SqlCommand(sql, cn)
                        cmd.Parameters.AddWithValue("@fromLoc", fromLoc)
                        cmd.Parameters.AddWithValue("@toLoc", toLoc)
                        cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                        cmd.Parameters.AddWithValue("@reqBy", producerUserId)
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                notes = If(IsDBNull(r("Notes")), Nothing, r("Notes").ToString())
                            End If
                        End Using
                    End Using
                    If String.IsNullOrWhiteSpace(notes) Then Exit Sub

                    productIdFromNotes = ExtractFirstProductIdFromProductsList(notes)
                    If productIdFromNotes <= 0 Then Exit Sub

                    ' Try to select the product in combo
                    If cboProduct.DataSource IsNot Nothing Then
                        Try
                            cboProduct.SelectedValue = productIdFromNotes
                        Catch
                            ' ignore if not present
                        End Try
                    End If
                    currentProductId = productIdFromNotes

                    ' Populate latest info and suggested qty using existing flow
                    OnFindLatest(Me, EventArgs.Empty)
                End Using
            Catch
                ' Non-fatal; just skip autoload
            End Try
        End Sub

        Private Sub OnCompleted(sender As Object, e As EventArgs)
            If currentIOId <= 0 OrElse currentProductId <= 0 Then
                MessageBox.Show("Find a Build of Materials first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim qty As Decimal
            If Not Decimal.TryParse((If(txtQtyToReceive.Text, "")).Trim(), qty) OrElse qty <= 0D Then
                MessageBox.Show("Enter a valid Qty to Receive (> 0).", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim totalMfgCost As Decimal = 0D
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using tx = cn.BeginTransaction()
                        Try
                            ' Get BranchID from InternalOrderHeader
                            Dim branchId As Integer = currentBranchId
                            If branchId <= 0 Then
                                Using cmdBranch As New SqlCommand("SELECT ISNULL(BranchID, 0) FROM dbo.InternalOrderHeader WHERE InternalOrderID=@id", cn, tx)
                                    cmdBranch.Parameters.AddWithValue("@id", currentIOId)
                                    Dim obj = cmdBranch.ExecuteScalar()
                                    If obj IsNot Nothing AndAlso Not IsDBNull(obj) Then branchId = Convert.ToInt32(obj)
                                End Using
                            End If
                            If branchId <= 0 Then branchId = AppSession.CurrentBranchID
                            
                            ' Get recipe ingredients from InternalOrderLines
                            Using cmdLines As New SqlCommand("SELECT MaterialID, Quantity FROM dbo.InternalOrderLines WHERE InternalOrderID=@id AND MaterialID IS NOT NULL", cn, tx)
                                cmdLines.Parameters.AddWithValue("@id", currentIOId)
                                Using reader = cmdLines.ExecuteReader()
                                    Dim materials As New List(Of (MaterialID As Integer, Quantity As Decimal))
                                    While reader.Read()
                                        materials.Add((reader.GetInt32(0), reader.GetDecimal(1)))
                                    End While
                                    reader.Close()
                                    
                                    ' Reduce Manufacturing_Inventory for each ingredient
                                    For Each mat In materials
                                        Dim qtyUsed As Decimal = mat.Quantity * qty ' Scale by finished product quantity
                                        Dim unitCost As Decimal = 0D
                                        
                                        ' Get cost from Manufacturing_Inventory
                                        Using cmdCost As New SqlCommand("SELECT ISNULL(AverageCost, 0) FROM dbo.Manufacturing_Inventory WHERE MaterialID=@mid AND BranchID=@bid", cn, tx)
                                            cmdCost.Parameters.AddWithValue("@mid", mat.MaterialID)
                                            cmdCost.Parameters.AddWithValue("@bid", branchId)
                                            Dim obj = cmdCost.ExecuteScalar()
                                            If obj IsNot Nothing AndAlso Not IsDBNull(obj) Then unitCost = Convert.ToDecimal(obj)
                                        End Using
                                        
                                        ' Reduce Manufacturing_Inventory
                                        Using cmdReduce As New SqlCommand("UPDATE dbo.Manufacturing_Inventory SET QtyOnHand = QtyOnHand - @qty, LastUpdated = GETDATE() WHERE MaterialID=@mid AND BranchID=@bid", cn, tx)
                                            cmdReduce.Parameters.AddWithValue("@qty", qtyUsed)
                                            cmdReduce.Parameters.AddWithValue("@mid", mat.MaterialID)
                                            cmdReduce.Parameters.AddWithValue("@bid", branchId)
                                            cmdReduce.ExecuteNonQuery()
                                        End Using
                                        
                                        ' Insert Manufacturing_InventoryMovements
                                        Using cmdMove As New SqlCommand("INSERT INTO dbo.Manufacturing_InventoryMovements (MaterialID, BranchID, MovementType, Quantity, UnitCost, ReferenceType, ReferenceID, MovementDate, CreatedBy) VALUES (@mid, @bid, 'Consumed in Build', -@qty, @cost, 'InternalOrder', @ioid, GETDATE(), @user)", cn, tx)
                                            cmdMove.Parameters.AddWithValue("@mid", mat.MaterialID)
                                            cmdMove.Parameters.AddWithValue("@bid", branchId)
                                            cmdMove.Parameters.AddWithValue("@qty", qtyUsed)
                                            cmdMove.Parameters.AddWithValue("@cost", unitCost)
                                            cmdMove.Parameters.AddWithValue("@ioid", currentIOId)
                                            cmdMove.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                                            cmdMove.ExecuteNonQuery()
                                        End Using
                                        
                                        totalMfgCost += qtyUsed * unitCost
                                    Next
                                End Using
                            End Using
                            
                            ' Calculate finished product cost per unit
                            Dim finishedProductCost As Decimal = If(qty > 0, totalMfgCost / qty, 0D)
                            
                            ' Increase Retail_Stock for finished product
                            ' First ensure Retail_Variant exists
                            Dim variantId As Integer = 0
                            Using cmdVariant As New SqlCommand("SELECT TOP 1 VariantID FROM dbo.Retail_Variant WHERE ProductID=@pid", cn, tx)
                                cmdVariant.Parameters.AddWithValue("@pid", currentProductId)
                                Dim obj = cmdVariant.ExecuteScalar()
                                If obj IsNot Nothing AndAlso Not IsDBNull(obj) Then
                                    variantId = Convert.ToInt32(obj)
                                Else
                                    ' Create default variant
                                    Using cmdInsVar As New SqlCommand("INSERT INTO dbo.Retail_Variant (ProductID, VariantName, IsActive) OUTPUT INSERTED.VariantID VALUES (@pid, 'Default', 1)", cn, tx)
                                        cmdInsVar.Parameters.AddWithValue("@pid", currentProductId)
                                        variantId = Convert.ToInt32(cmdInsVar.ExecuteScalar())
                                    End Using
                                End If
                            End Using
                            
                            ' Upsert Retail_Stock
                            Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM dbo.Retail_Stock WHERE VariantID=@vid AND BranchID=@bid", cn, tx)
                                cmdCheck.Parameters.AddWithValue("@vid", variantId)
                                cmdCheck.Parameters.AddWithValue("@bid", branchId)
                                Dim exists = Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0
                                
                                If exists Then
                                    Using cmdUpdate As New SqlCommand("UPDATE dbo.Retail_Stock SET QtyOnHand = QtyOnHand + @qty, AverageCost = (AverageCost * QtyOnHand + @cost * @qty) / (QtyOnHand + @qty) WHERE VariantID=@vid AND BranchID=@bid", cn, tx)
                                        cmdUpdate.Parameters.AddWithValue("@qty", qty)
                                        cmdUpdate.Parameters.AddWithValue("@cost", finishedProductCost)
                                        cmdUpdate.Parameters.AddWithValue("@vid", variantId)
                                        cmdUpdate.Parameters.AddWithValue("@bid", branchId)
                                        cmdUpdate.ExecuteNonQuery()
                                    End Using
                                Else
                                    Using cmdInsert As New SqlCommand("INSERT INTO dbo.Retail_Stock (VariantID, BranchID, QtyOnHand, AverageCost, ReorderPoint) VALUES (@vid, @bid, @qty, @cost, 10)", cn, tx)
                                        cmdInsert.Parameters.AddWithValue("@vid", variantId)
                                        cmdInsert.Parameters.AddWithValue("@bid", branchId)
                                        cmdInsert.Parameters.AddWithValue("@qty", qty)
                                        cmdInsert.Parameters.AddWithValue("@cost", finishedProductCost)
                                        cmdInsert.ExecuteNonQuery()
                                    End Using
                                End If
                            End Using
                            
                            ' Insert Retail_StockMovements
                            Using cmdMove As New SqlCommand("INSERT INTO dbo.Retail_StockMovements (VariantID, BranchID, QtyDelta, Reason, Ref1, CreatedAt, CreatedBy) VALUES (@vid, @bid, @qty, 'Manufacturing Build Complete', @ref, GETDATE(), @user)", cn, tx)
                                cmdMove.Parameters.AddWithValue("@vid", variantId)
                                cmdMove.Parameters.AddWithValue("@bid", branchId)
                                cmdMove.Parameters.AddWithValue("@qty", qty)
                                cmdMove.Parameters.AddWithValue("@ref", $"IO-{currentIOId}")
                                cmdMove.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                                cmdMove.ExecuteNonQuery()
                            End Using
                            
                            ' Create Journal Entry: DR Retail Inventory, CR Manufacturing Inventory
                            If totalMfgCost > 0 Then
                                Dim journalNumber As String = $"JNL-BUILD-{currentIOId}-{DateTime.Now:yyyyMMddHHmmss}"
                                Dim journalId As Integer
                                Using cmdJH As New SqlCommand("INSERT INTO dbo.JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, IsPosted, CreatedBy, CreatedDate) OUTPUT INSERTED.JournalID VALUES (@jnum, @bid, GETDATE(), @ref, @desc, 1, @user, GETDATE())", cn, tx)
                                    cmdJH.Parameters.AddWithValue("@jnum", journalNumber)
                                    cmdJH.Parameters.AddWithValue("@bid", branchId)
                                    cmdJH.Parameters.AddWithValue("@ref", $"IO-{currentIOId}")
                                    cmdJH.Parameters.AddWithValue("@desc", $"Manufacturing Build Complete - Product {currentProductId}")
                                    cmdJH.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                                    journalId = Convert.ToInt32(cmdJH.ExecuteScalar())
                                End Using
                                
                                ' DR Retail Inventory
                                Dim retailInvAcct As Integer = GetAccountID("Retail Inventory", cn, tx)
                                Using cmdDR As New SqlCommand("INSERT INTO dbo.JournalDetails (JournalID, AccountID, Debit, Credit, Description) VALUES (@jid, @acct, @amt, 0, @desc)", cn, tx)
                                    cmdDR.Parameters.AddWithValue("@jid", journalId)
                                    cmdDR.Parameters.AddWithValue("@acct", retailInvAcct)
                                    cmdDR.Parameters.AddWithValue("@amt", Math.Round(totalMfgCost, 2))
                                    cmdDR.Parameters.AddWithValue("@desc", "Finished goods from manufacturing")
                                    cmdDR.ExecuteNonQuery()
                                End Using
                                
                                ' CR Manufacturing Inventory
                                Dim mfgInvAcct As Integer = GetAccountID("Manufacturing Inventory", cn, tx)
                                Using cmdCR As New SqlCommand("INSERT INTO dbo.JournalDetails (JournalID, AccountID, Debit, Credit, Description) VALUES (@jid, @acct, 0, @amt, @desc)", cn, tx)
                                    cmdCR.Parameters.AddWithValue("@jid", journalId)
                                    cmdCR.Parameters.AddWithValue("@acct", mfgInvAcct)
                                    cmdCR.Parameters.AddWithValue("@amt", Math.Round(totalMfgCost, 2))
                                    cmdCR.Parameters.AddWithValue("@desc", "Materials consumed in manufacturing")
                                    cmdCR.ExecuteNonQuery()
                                End Using
                            End If
                            
                            ' Mark IO as Completed
                            Using cmd As New SqlCommand("IF COL_LENGTH('dbo.InternalOrderHeader','CompletedDate') IS NOT NULL BEGIN UPDATE dbo.InternalOrderHeader SET Status='Completed', CompletedDate = SYSUTCDATETIME() WHERE InternalOrderID = @id END ELSE BEGIN UPDATE dbo.InternalOrderHeader SET Status='Completed' WHERE InternalOrderID = @id END", cn, tx)
                                cmd.Parameters.AddWithValue("@id", currentIOId)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            ' Mark BomTaskStatus as Completed
                            Using cmd2 As New SqlCommand("UPDATE dbo.BomTaskStatus SET Status = N'Completed', UpdatedAtUtc = SYSUTCDATETIME() WHERE InternalOrderID = @id", cn, tx)
                                cmd2.Parameters.AddWithValue("@id", currentIOId)
                                cmd2.ExecuteNonQuery()
                            End Using
                            
                            tx.Commit()
                        Catch ex As Exception
                            tx.Rollback()
                            Throw New Exception($"Build completion failed: {ex.Message}", ex)
                        End Try
                    End Using
                End Using

                ' Refresh dashboards so counts change immediately
                Try
                    For Each f As Form In Application.OpenForms
                        If TypeOf f Is Manufacturing.UserDashboardForm Then
                            CType(f, Manufacturing.UserDashboardForm).RefreshNow()
                        ElseIf TypeOf f Is Stockroom.StockroomDashboardForm Then
                            CType(f, Stockroom.StockroomDashboardForm).RefreshData()
                        End If
                    Next
                Catch
                End Try

                MessageBox.Show($"Build completed. {qty} units moved to Retail stock at cost {totalMfgCost:C2}.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Catch ex As Exception
                MessageBox.Show("Completion failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Function GetAccountID(accountName As String, cn As SqlConnection, tx As SqlTransaction) As Integer
            ' Try to find account by name, create if not exists
            Using cmd As New SqlCommand("SELECT AccountID FROM dbo.ChartOfAccounts WHERE AccountName = @name", cn, tx)
                cmd.Parameters.AddWithValue("@name", accountName)
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    Return Convert.ToInt32(result)
                End If
            End Using
            
            ' Create account if not found
            Dim accountCode As String = ""
            Dim accountType As String = "Asset"
            Select Case accountName
                Case "Manufacturing Inventory"
                    accountCode = "1320"
                Case "Stockroom Inventory"
                    accountCode = "1310"
                Case "Retail Inventory"
                    accountCode = "1330"
                Case Else
                    accountCode = "1300"
            End Select
            
            Using cmdIns As New SqlCommand("INSERT INTO dbo.ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive) OUTPUT INSERTED.AccountID VALUES (@code, @name, @type, 1)", cn, tx)
                cmdIns.Parameters.AddWithValue("@code", accountCode)
                cmdIns.Parameters.AddWithValue("@name", accountName)
                cmdIns.Parameters.AddWithValue("@type", accountType)
                Return Convert.ToInt32(cmdIns.ExecuteScalar())
            End Using
        End Function
    End Class
End Namespace
