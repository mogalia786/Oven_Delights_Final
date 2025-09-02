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
            Try
                ' Receive FG into MFG inventory
                Dim svc As New ManufacturingService()
                svc.ReceiveFinishedToMFG(currentProductId, qty)

                ' Immediately transfer FG to RETAIL so Retail has stock live
                svc.TransferToRetail(currentProductId, qty)

                ' Mark IO as Completed
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("UPDATE dbo.InternalOrderHeader SET Status='Completed', CompletedDate = SYSUTCDATETIME() WHERE InternalOrderID = @id", cn)
                        cmd.Parameters.AddWithValue("@id", currentIOId)
                        cmd.ExecuteNonQuery()
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

                MessageBox.Show("Build completed. Finished goods moved to Retail stock.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Catch ex As Exception
                MessageBox.Show("Completion failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
