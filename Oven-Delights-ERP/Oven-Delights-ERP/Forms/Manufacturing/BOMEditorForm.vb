Imports System.Windows.Forms
Imports System.Drawing
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Data

Namespace Manufacturing
    Public Class BOMEditorForm
        Inherits Form

        Private cboProduct As ComboBox
        Private txtProductionQty As NumericUpDown
        Private dtpRequest As DateTimePicker
        Private btnGenerate As Button
        Private btnSubmit As Button
        Private btnBuildNow As Button
        Private btnPrint As Button
        Private btnEmail As Button
        Private lvIngredients As ListView
        Private lblLeftHeader As Label
        Private pnlDivider As Panel
        Private lblHeader As Label
        Private lblStatus As Label
        Private lblRequester As Label
        Private cboRequester As ComboBox

        ' Right-side Fulfilled BOMs section
        Private lblFulfilled As Label
        Private cboFulfilled As ComboBox
        Private btnCompleted As Button
        Private lvFulfilled As ListView

        ' Bottom completed products summary
        Private lblCompletedHeader As Label
        Private lvCompleted As ListView

        Private currentBOMID As Integer = 0
        Private currentBatchYield As Decimal = 1D
        Private preselectedManufacturerId As Integer = 0
        Private internalOrderIdForFulfill As Integer = 0
        Private internalOrderNoForFulfill As String = String.Empty
        Private fulfillMode As Boolean = False
        ' Mode: "Create" enables only left side; "Complete" enables only right side; anything else enables both
        Private _bomMode As String = "Both"

        ' Allows caller to preselect a specific fulfilled Internal Order when opening in Complete mode
        Public Sub PreselectFulfilledInternalOrder(ioId As Integer)
            internalOrderIdForFulfill = If(ioId > 0, ioId, 0)
            internalOrderNoForFulfill = String.Empty
        End Sub

        ' Overload to preselect by both ID and OrderNo as a fallback
        Public Sub PreselectFulfilledInternalOrder(ioId As Integer, ioNo As String)
            internalOrderIdForFulfill = If(ioId > 0, ioId, 0)
            internalOrderNoForFulfill = If(ioNo, String.Empty)
        End Sub

        ' Public API for caller to set the BOM interaction mode
        Public Sub SetMode(mode As String)
            _bomMode = If(mode, "Both")
            ApplyBomMode()
        End Sub

        Private Sub ApplyBomMode()
            Dim isCreate As Boolean = String.Equals(_bomMode, "Create", StringComparison.OrdinalIgnoreCase)
            Dim isComplete As Boolean = String.Equals(_bomMode, "Complete", StringComparison.OrdinalIgnoreCase)
            Dim enableCreate As Boolean = isCreate OrElse (Not isCreate AndAlso Not isComplete)
            Dim enableComplete As Boolean = isComplete OrElse (Not isCreate AndAlso Not isComplete)
            EnableCreateSection(enableCreate)
            EnableCompleteSection(enableComplete)
            ' Update header/title to reflect mode visibly for the user
            If lblHeader IsNot Nothing Then
                If isCreate Then
                    lblHeader.Text = "BOM - Create"
                ElseIf isComplete Then
                    lblHeader.Text = "BOM - Complete"
                Else
                    lblHeader.Text = "Bill of Materials (BOM) Editing"
                End If
            End If
            If isCreate Then
                Me.Text = "Manufacturing - BOM (Create)"
            ElseIf isComplete Then
                Me.Text = "Manufacturing - BOM (Complete)"
            Else
                Me.Text = "Manufacturing - BOM Editing"
            End If
        End Sub

        Private Sub EnableCreateSection(enabled As Boolean)
            Dim controlsToToggle As Control() = {cboProduct, txtProductionQty, dtpRequest, btnGenerate, btnSubmit, btnBuildNow, btnPrint, btnEmail, lvIngredients}
            For Each c As Control In controlsToToggle
                If c IsNot Nothing Then
                    c.Enabled = enabled
                    c.TabStop = enabled
                End If
            Next
            If lblLeftHeader IsNot Nothing Then lblLeftHeader.Enabled = enabled
        End Sub

        Private Sub EnableCompleteSection(enabled As Boolean)
            Dim controlsToToggle As Control() = {cboFulfilled, btnCompleted, lvFulfilled}
            For Each c As Control In controlsToToggle
                If c IsNot Nothing Then
                    c.Enabled = enabled
                    c.TabStop = enabled
                End If
            Next
            If lblFulfilled IsNot Nothing Then lblFulfilled.Enabled = enabled
        End Sub

        Public Sub New()
            Me.Text = "Manufacturing - BOM Editing"
            Me.Name = "BOMEditorForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.White
            Me.Width = 1280
            Me.Height = 800

            lblHeader = New Label() With {
                .Text = "Bill of Materials (BOM) Editing",
                .Dock = DockStyle.Top,
                .Height = 40,
                .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                .ForeColor = Color.White,
                .BackColor = Color.FromArgb(0, 99, 99),
                .Padding = New Padding(12, 8, 12, 8)
            }
            Controls.Add(lblHeader)

            Dim lblProd As New Label() With {.Text = "Product:", .Left = 20, .Top = 56, .AutoSize = True}
            cboProduct = New ComboBox() With {.Left = 90, .Top = 52, .Width = 340, .DropDownStyle = ComboBoxStyle.DropDownList}

            lblRequester = New Label() With {.Text = "Requested by:", .Left = 440, .Top = 56, .AutoSize = True}
            cboRequester = New ComboBox() With {.Left = 540, .Top = 52, .Width = 240, .DropDownStyle = ComboBoxStyle.DropDownList}

            Dim lblProdQty As New Label() With {.Text = "Production Qty:", .Left = 800, .Top = 56, .AutoSize = True}
            txtProductionQty = New NumericUpDown() With {
                .Left = 900,
                .Top = 52,
                .Width = 80,
                .DecimalPlaces = 1,
                .Increment = 0.1D,
                .Minimum = 0.1D,
                .Maximum = 1000000D,
                .Value = 1D,
                .ThousandsSeparator = True
            }

            Dim lblDate As New Label() With {.Text = "Date/Time:", .Left = 1000, .Top = 56, .AutoSize = True}
            dtpRequest = New DateTimePicker() With {.Left = 1080, .Top = 52, .Width = 180, .Format = DateTimePickerFormat.Custom, .CustomFormat = "yyyy-MM-dd HH:mm"}

            btnGenerate = New Button() With {.Text = "Generate", .Left = 20, .Top = 90, .Width = 90}
            btnSubmit = New Button() With {.Text = "Submit", .Left = 120, .Top = 90, .Width = 90}
            btnPrint = New Button() With {.Text = "Print", .Left = 220, .Top = 90, .Width = 80}
            btnEmail = New Button() With {.Text = "Email", .Left = 310, .Top = 90, .Width = 80}
            btnBuildNow = New Button() With {.Text = "Build Now", .Left = 410, .Top = 90, .Width = 100}

            lvIngredients = New ListView() With {
                .Left = 20,
                .Top = 130,
                .Width = 580,
                .Height = 360,
                .View = View.Details,
                .FullRowSelect = True,
                .GridLines = False
            }
            lvIngredients.Columns.Add("Item", 540)
            lvIngredients.Columns.Add("Quantity", 200, HorizontalAlignment.Right)
            lvIngredients.Columns.Add("UoM", 180)
            ' Show stock on hand from RawMaterials (same source as Stockroom > Inventory > Raw Materials)
            lvIngredients.Columns.Add("Stock", 160, HorizontalAlignment.Right)

            ' Bold section header above left grid
            lblLeftHeader = New Label() With {
                .Text = "Generate BOM",
                .Left = 20,
                .Top = 108,
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold)
            }

            ' Vertical divider between grids
            pnlDivider = New Panel() With {
                .Left = 600,
                .Top = 130,
                .Width = 2,
                .Height = 360,
                .BackColor = Color.Gainsboro
            }

            lblStatus = New Label() With {.Left = 20, .Top = 680, .Width = 980, .ForeColor = Color.DimGray}

            ' Right-hand fulfilled/completed section
            lblFulfilled = New Label() With {.Text = "Completed BOM", .Left = 620, .Top = 108, .AutoSize = True, .Font = New Font("Segoe UI", 11, FontStyle.Bold)}
            ' Move dropdown lower to avoid overlap with Date/Time
            cboFulfilled = New ComboBox() With {.Left = 620, .Top = 80, .Width = 420, .DropDownStyle = ComboBoxStyle.DropDownList}
            btnCompleted = New Button() With {.Text = "Completed", .Left = 940, .Top = 104, .Width = 130}

            lvFulfilled = New ListView() With {
                .Left = 620,
                .Top = 130,
                .Width = 620,
                .Height = 360,
                .View = View.Details,
                .FullRowSelect = True,
                .GridLines = False
            }
            lvFulfilled.Columns.Add("Line", 60)
            lvFulfilled.Columns.Add("Item", 420)
            lvFulfilled.Columns.Add("Qty", 100, HorizontalAlignment.Right)
            lvFulfilled.Columns.Add("UoM", 60)

            ' Bottom Completed Products grid and header
            lblCompletedHeader = New Label() With {
                .Text = "Completed Products",
                .Left = 20,
                .Top = 500,
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold)
            }
            lvCompleted = New ListView() With {
                .Left = 20,
                .Top = 520,
                .Width = 1240,
                .Height = 180,
                .View = View.Details,
                .FullRowSelect = True,
                .GridLines = True
            }
            lvCompleted.Columns.Add("Product", 320)
            lvCompleted.Columns.Add("Qty", 90, HorizontalAlignment.Right)
            lvCompleted.Columns.Add("UoM", 80)
            lvCompleted.Columns.Add("Completed On", 180)
            lvCompleted.Columns.Add("Input BOM No", 190)
            lvCompleted.Columns.Add("Fulfilled IO No", 190)

            Controls.AddRange(New Control() {lblProd, cboProduct, lblRequester, cboRequester, lblProdQty, txtProductionQty, lblDate, dtpRequest, btnGenerate, btnSubmit, btnPrint, btnEmail, btnBuildNow, lblLeftHeader, lvIngredients, pnlDivider, lblFulfilled, cboFulfilled, btnCompleted, lvFulfilled, lblCompletedHeader, lvCompleted, lblStatus})

            AddHandler btnGenerate.Click, AddressOf GenerateList
            AddHandler btnSubmit.Click, AddressOf OnSubmit
            AddHandler btnPrint.Click, AddressOf BtnPrint_Click
            AddHandler btnEmail.Click, AddressOf OnEmail
            AddHandler btnBuildNow.Click, AddressOf OnBuildNow
            AddHandler cboProduct.SelectedIndexChanged, Sub(sender, args)
                                                            ' Clear list and state when product changes
                                                            currentBOMID = 0
                                                            currentBatchYield = 1D
                                                            lvIngredients.Items.Clear()
                                                            lblStatus.Text = ""
                                                        End Sub

            LoadProducts()
            LoadManufacturingUsers()
            LoadFulfilledList()
            AddHandler cboFulfilled.SelectedIndexChanged, AddressOf OnFulfilledSelected
            AddHandler btnCompleted.Click, AddressOf OnCompleted
            AddHandler lvFulfilled.ItemActivate, AddressOf OnFulfilledItemActivate ' double-click or Enter to complete
            ' Ensure fulfilled list shows when form first displays
            AddHandler Me.Shown, Sub(sender, args)
                                      LoadFulfilledList()
                                      ' Try to apply any requested preselection after data loads
                                      TryApplyFulfilledPreselection()
                                      ApplyResponsiveLayout()
                                      ' Apply mode after UI is built
                                      ApplyBomMode()
                                  End Sub
            AddHandler Me.Resize, Sub(sender, args) ApplyResponsiveLayout()
            ' Auto-refresh when form regains focus
            AddHandler Me.Activated, Sub(sender, args)
                                        LoadProducts()
                                        LoadManufacturingUsers()
                                        LoadFulfilledList()
                                        TryApplyFulfilledPreselection()
                                    End Sub
            ' Clear transient UI when form is hidden/closed
            AddHandler Me.VisibleChanged, Sub(sender, args)
                                              If Not Me.Visible Then ClearForm()
                                          End Sub
            ' Refresh data when user opens dropdowns
            AddHandler cboProduct.DropDown, Sub(sender, args) LoadProducts()
            AddHandler cboRequester.DropDown, Sub(sender, args) LoadManufacturingUsers()
            AddHandler cboFulfilled.DropDown, Sub(sender, args)
                                                 LoadFulfilledList()
                                                 TryApplyFulfilledPreselection()
                                             End Sub
        End Sub

        ' Overload to support being opened from Stockroom with a specific IO and Manufacturer
        Public Sub New(internalOrderId As Integer, manufacturerUserId As Integer, mode As String)
            Me.New()
            Try
                internalOrderIdForFulfill = Math.Max(0, internalOrderId)
                preselectedManufacturerId = Math.Max(0, manufacturerUserId)
                fulfillMode = String.Equals(If(mode, "").Trim(), "Fulfill", StringComparison.OrdinalIgnoreCase)
                ' Preselect the manufacturer in requester combo if found
                If preselectedManufacturerId > 0 AndAlso cboRequester IsNot Nothing AndAlso cboRequester.DataSource IsNot Nothing Then
                    Try
                        cboRequester.SelectedValue = preselectedManufacturerId
                    Catch
                        ' ignore if not present in current list
                    End Try
                End If
                ApplyFulfillContext()
            Catch
            End Try
        End Sub

        Private Sub LoadManufacturingUsers()
            Try
                Dim svc As New StockroomService()
                Dim branchId As Integer = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
                Dim dt = svc.GetManufacturingUsersByBranch(branchId)
                cboRequester.DataSource = dt
                cboRequester.DisplayMember = "FullName"
                cboRequester.ValueMember = "UserID"
                cboRequester.SelectedIndex = -1
            Catch ex As Exception
                ' If lookup fails, keep dropdown empty but do not block UI
                cboRequester.DataSource = Nothing
                cboRequester.Items.Clear()
            End Try
        End Sub

        Private Sub ApplyFulfillContext()
            Try
                If fulfillMode Then
                    lblHeader.Text = "Fulfill BOM to Manufacturing"
                    lblLeftHeader.Text = "Fulfill BOM"
                    ' When fulfilling, requester is the selected manufacturer; lock it to prevent accidental change
                    If preselectedManufacturerId > 0 Then
                        Try
                            cboRequester.SelectedValue = preselectedManufacturerId
                        Catch
                        End Try
                    End If
                    cboRequester.Enabled = False
                End If
            Catch
            End Try
        End Sub

        Private Sub ApplyResponsiveLayout()
            ' Make both top grids use half the available client width and bottom grid full width.
            Try
                Dim margin As Integer = 20
                Dim spacing As Integer = 10
                Dim clientW As Integer = Me.ClientSize.Width

                ' Left grid width
                Dim leftWidth As Integer = (clientW - (margin * 2) - spacing - pnlDivider.Width) \ 2
                lvIngredients.Left = margin
                lvIngredients.Width = Math.Max(300, leftWidth)

                ' Divider centered between grids
                pnlDivider.Left = lvIngredients.Left + lvIngredients.Width + spacing

                ' Right grid uses remaining width
                lvFulfilled.Left = pnlDivider.Left + pnlDivider.Width + spacing
                lvFulfilled.Width = Math.Max(300, clientW - lvFulfilled.Left - margin)

                ' Right header and controls align with right grid
                lblFulfilled.Left = lvFulfilled.Left
                btnCompleted.Left = lvFulfilled.Left + lvFulfilled.Width - btnCompleted.Width
                cboFulfilled.Left = lvFulfilled.Left
                cboFulfilled.Width = lvFulfilled.Width

                ' Completed products bottom grid full width
                lvCompleted.Left = margin
                lvCompleted.Width = clientW - (margin * 2)
            Catch
            End Try
        End Sub

        Private Sub OnBuildNow(sender As Object, e As EventArgs)
            ' One-click flow: create bundle from BOM, fulfill to MFG (deducts stockroom), then receive finished goods into MFG
            If cboProduct.SelectedValue Is Nothing Then
                MessageBox.Show("Select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim pid As Integer
            If Not Integer.TryParse(cboProduct.SelectedValue.ToString(), pid) Then
                MessageBox.Show("Invalid product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim qty As Decimal = txtProductionQty.Value
            If qty <= 0D Then
                MessageBox.Show("Enter a valid Production Qty (> 0).", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Dim svc As New ManufacturingService()
                ' Ensure a formal, active BOM exists; if not, create from RecipeNode
                Dim ensuredBOM = svc.EnsureActiveBOMFromRecipe(pid)
                Dim items As New List(Of Tuple(Of Integer, Decimal))() From {Tuple.Create(pid, qty)}
                Dim ds = svc.CreateBundleFromBOM(items)
                Dim ioId As Integer = 0
                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    Dim header = ds.Tables(0).Rows(0)
                    If ds.Tables(0).Columns.Contains("InternalOrderID") Then
                        Integer.TryParse(header("InternalOrderID").ToString(), ioId)
                    End If
                End If

                If ioId <= 0 Then
                    MessageBox.Show("Unable to create internal order from BOM. Please verify the product's recipe has components.", "Build Now", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                ' Deduct stockroom to MFG for needed components per BOM
                svc.FulfillBundleToMFG(ioId)

                ' Receive finished goods into MFG inventory
                svc.ReceiveFinishedToMFG(pid, qty)

                lblStatus.Text = "Build completed: components issued to MFG and finished goods received."
                MessageBox.Show("Build completed: stock deducted and finished goods received to MFG.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                ClearForm()
            Catch ex As Exception
                MessageBox.Show("Build Now failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadProducts()
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    ' List products actually saved by Build My Product: Products having a saved hierarchy in RecipeNode
                    Dim sql As String = _
                        "SELECT DISTINCT p.ProductID, p.ProductCode, p.ProductName, (p.ProductCode + ' - ' + p.ProductName) AS DisplayText " & _
                        "FROM dbo.Products p " & _
                        "WHERE ISNULL(p.IsActive,1)=1 " & _
                        "ORDER BY p.ProductName;"
                    Using cmd As New SqlCommand(sql, cn)
                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)
                            cboProduct.DataSource = dt
                            cboProduct.DisplayMember = "DisplayText"
                            cboProduct.ValueMember = "ProductID"
                            ' Avoid default selection on load; require explicit user choice
                            If dt.Rows.Count > 0 Then cboProduct.SelectedIndex = -1
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Load products failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub GenerateList(sender As Object, e As EventArgs)
            LoadBOM()
        End Sub

        Private Sub LoadBOM()
            currentBOMID = 0
            currentBatchYield = 1D
            lvIngredients.Items.Clear()
            lblStatus.Text = ""

            If cboProduct.SelectedValue Is Nothing Then Return
            Dim pid As Integer
            If Not Integer.TryParse(cboProduct.SelectedValue.ToString(), pid) Then Return

            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    ' Get active BOM header
                    Dim sqlH As String = "SELECT TOP 1 BOMID, BatchYieldQty FROM dbo.BOMHeader WHERE ProductID = @pid AND IsActive = 1 AND EffectiveFrom <= CAST(GETDATE() AS DATE) AND (EffectiveTo IS NULL OR EffectiveTo >= CAST(GETDATE() AS DATE)) ORDER BY EffectiveFrom DESC, BOMID DESC"
                    Dim bomId As Integer = 0
                    Using cmdH As New SqlCommand(sqlH, cn)
                        cmdH.Parameters.AddWithValue("@pid", pid)
                        Using r = cmdH.ExecuteReader()
                            If r.Read() Then
                                bomId = Convert.ToInt32(r("BOMID"))
                                currentBatchYield = Convert.ToDecimal(r("BatchYieldQty"))
                                ' batch yield kept internal only for scaling
                            End If
                        End Using
                    End Using

                    If bomId = 0 Then
                        ' Fallback: generate list directly from Build My Product hierarchy (RecipeNode)
                        Dim sqlFromRecipe As String = _
                            "SELECT ROW_NUMBER() OVER (ORDER BY rn.SortOrder, rn.NodeID) AS LineNumber, " & _
                            "       rn.ItemName AS ComponentName, " & _
                            "       rn.Qty AS QuantityPerBatch, " & _
                            "       ISNULL(u.UoMCode, '') AS UoM, " & _
                            "       rn.MaterialID AS RawMaterialID " & _
                            "FROM dbo.RecipeNode rn " & _
                            "LEFT JOIN dbo.UoM u ON u.UoMID = rn.UoMID " & _
                            "WHERE rn.ProductID = @pid " & _
                            "  AND rn.ParentNodeID IS NOT NULL " & _
                            "  AND (rn.MaterialID IS NOT NULL OR rn.SubAssemblyProductID IS NOT NULL OR rn.ItemName IS NOT NULL) " & _
                            "ORDER BY rn.SortOrder, rn.NodeID;"
                        Using cmdR As New SqlCommand(sqlFromRecipe, cn)
                            cmdR.Parameters.AddWithValue("@pid", pid)
                            Using daR As New SqlDataAdapter(cmdR)
                                Dim dtR As New DataTable()
                                daR.Fill(dtR)
                                If dtR.Rows.Count = 0 Then
                                    lblStatus.Text = "No active BOM found and no components in product hierarchy."
                                    Return
                                End If
                                PopulateList(dtR)
                                lblStatus.Text = "Generated from product hierarchy (no active BOM yet)."
                                Return
                            End Using
                        End Using
                    End If
                    currentBOMID = bomId

                    ' Load BOM items (names and UoM): include raw materials and subassemblies; exclude only the finished product itself
                    Dim sqlI As String = "SELECT bi.LineNumber, bi.ComponentType, bi.RawMaterialID, bi.ComponentProductID, bi.NonStockDesc, bi.QuantityPerBatch, bi.UoM, " +
                                         "CASE WHEN bi.NonStockDesc IS NOT NULL THEN bi.NonStockDesc " +
                                         "     WHEN bi.RawMaterialID IS NOT NULL THEN CONCAT(rm.MaterialCode, ' - ', rm.MaterialName) " +
                                         "     WHEN bi.ComponentProductID IS NOT NULL THEN p.ProductName " +
                                         "     ELSE 'Component' END AS ComponentName " +
                                         "FROM dbo.BOMItems bi " +
                                         "LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = bi.RawMaterialID " +
                                         "LEFT JOIN dbo.Products p ON p.ProductID = bi.ComponentProductID " +
                                         "WHERE bi.BOMID = @bid AND (bi.ComponentProductID IS NULL OR bi.ComponentProductID <> @pid) " +
                                         "ORDER BY bi.LineNumber"
                    Using cmdI As New SqlCommand(sqlI, cn)
                        cmdI.Parameters.AddWithValue("@bid", bomId)
                        cmdI.Parameters.AddWithValue("@pid", pid)
                        Using da As New SqlDataAdapter(cmdI)
                            Dim dt As New DataTable()
                            da.Fill(dt)
                            PopulateList(dt)
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Load BOM failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnSubmit(sender As Object, e As EventArgs)
            ' Create and send a Build of Materials request (Internal Order) to Stockroom based on selected product and Production Qty
            If cboProduct.SelectedValue Is Nothing Then
                MessageBox.Show("Select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            If cboRequester.SelectedValue Is Nothing Then
                MessageBox.Show("Select the Manufacturing user (Requested by).", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim pid As Integer
            If Not Integer.TryParse(cboProduct.SelectedValue.ToString(), pid) Then
                MessageBox.Show("Invalid product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim qty As Decimal = Convert.ToDecimal(txtProductionQty.Value)
            If qty <= 0D Then
                MessageBox.Show("Enter a valid Production Qty (> 0).", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim reqUserId As Integer
            If Not Integer.TryParse(cboRequester.SelectedValue.ToString(), reqUserId) OrElse reqUserId <= 0 Then
                MessageBox.Show("Invalid requester.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Try
                Dim svc As New ManufacturingService()
                ' Ensure a formal, active BOM exists; if not, create from RecipeNode (matches Build Now behavior)
                Dim ensuredBOM = svc.EnsureActiveBOMFromRecipe(pid)
                Dim items As New List(Of Tuple(Of Integer, Decimal))() From {Tuple.Create(pid, qty)}
                Dim branchId As Integer = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
                Dim ds = svc.CreateBundleFromBOM(items, branchId, reqUserId)
                ' Expect ds.Tables(0) header with InternalOrderID/Number
                Dim message As String = "Build of Materials request created."
                If (ds IsNot Nothing) AndAlso (ds.Tables IsNot Nothing) AndAlso (ds.Tables.Count > 0) AndAlso (ds.Tables(0).Rows.Count > 0) Then
                    Dim header = ds.Tables(0).Rows(0)
                    Dim idText As String = If(ds.Tables(0).Columns.Contains("InternalOrderID"), header("InternalOrderID").ToString(), String.Empty)
                    Dim numText As String = If(ds.Tables(0).Columns.Contains("InternalOrderNumber"), header("InternalOrderNumber").ToString(), String.Empty)
                    message = $"Build of Materials {(If(String.IsNullOrWhiteSpace(numText), "", numText & " "))}created (ID {idText})."

                    ' Tag Internal Order header Notes for easy lookup by Complete form (per-branch)
                    Dim ioId As Integer
                    If Integer.TryParse(idText, ioId) Then
                        Try
                            Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                            Using cn As New SqlConnection(cs)
                                cn.Open()
                                Dim br As Integer = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
                                Dim tag As String = $" | BuildOfMaterials | ProductID={pid}; Qty={qty}; Req={dtpRequest.Value:yyyy-MM-dd HH:mm}; Branch={br}"
                                Dim sql As String = "UPDATE dbo.InternalOrderHeader SET Notes = CONCAT(ISNULL(Notes,''), @tag) WHERE InternalOrderID = @id"
                                Using cmd As New SqlCommand(sql, cn)
                                    cmd.Parameters.AddWithValue("@tag", tag)
                                    cmd.Parameters.AddWithValue("@id", ioId)
                                    cmd.ExecuteNonQuery()
                                End Using
                            End Using
                        Catch
                        End Try
                    End If
                Else
                    MessageBox.Show("No internal order was created from BOM. Please verify the product's recipe has components.", "Submit", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                lblStatus.Text = message & " Sent to Stockroom."
                MessageBox.Show(message & " Sent to Stockroom.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                ClearForm()
            Catch ex As Exception
                MessageBox.Show("Submit failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub PopulateList(dt As DataTable)
            lvIngredients.BeginUpdate()
            lvIngredients.Items.Clear()

            Dim prodQty As Decimal = Convert.ToDecimal(txtProductionQty.Value)
            If prodQty < 0D Then prodQty = 0D

            Dim scale As Decimal = 0D
            If currentBatchYield > 0D Then scale = If(prodQty = 0D, 0D, prodQty / currentBatchYield)

            Dim stockSvc As New StockroomService()
            Dim branchId As Integer = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)

            For Each row As DataRow In dt.Rows
                Dim name As String = If(TryCast(row("ComponentName"), String), String.Empty)
                Dim perBatch As Decimal = 0D
                If Not Convert.IsDBNull(row("QuantityPerBatch")) Then perBatch = Convert.ToDecimal(row("QuantityPerBatch"))
                Dim req As Decimal = Math.Round(perBatch * scale, 4)
                Dim lvi As New ListViewItem(name)
                lvi.SubItems.Add(If(req = 0D, "0", req.ToString("0.#")))
                lvi.SubItems.Add(If(Convert.IsDBNull(row("UoM")), "", row("UoM").ToString()))
                ' Stock on hand from Stockroom movements (InventoryArea = 'Stockroom')
                Dim stockText As String = ""
                If dt.Columns.Contains("RawMaterialID") AndAlso Not Convert.IsDBNull(row("RawMaterialID")) Then
                    Dim matId As Integer = 0
                    Integer.TryParse(row("RawMaterialID").ToString(), matId)
                    If matId > 0 Then
                        Dim onHand As Decimal = stockSvc.GetStockOnHandInStockroom(matId)
                        stockText = onHand.ToString("0.#")
                    End If
                End If
                lvi.SubItems.Add(stockText)
                lvIngredients.Items.Add(lvi)
            Next
            lvIngredients.EndUpdate()

            lblStatus.Text = If(currentBOMID > 0, $"BOM {currentBOMID} ready @ {dtpRequest.Value:yyyy-MM-dd HH:mm}. Scale = {If(currentBatchYield>0, prodQty/currentBatchYield, 0):0.####}", "")
        End Sub

        Private Sub BtnPrint_Click(sender As Object, e As EventArgs)
            MessageBox.Show("Print of BOM list will be implemented next (PDF/Printer)", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub OnEmail(sender As Object, e As EventArgs)
            MessageBox.Show("Email to Stockroom will be implemented next (HTML export)", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub ClearForm()
            ' Reset UI to a clean state after successful actions
            Try
                cboProduct.SelectedIndex = -1
            Catch
            End Try
            txtProductionQty.Value = 1D
            dtpRequest.Value = Services.TimeProvider.Now()
            currentBOMID = 0
            currentBatchYield = 1D
            lvIngredients.Items.Clear()
            lblStatus.Text = ""
        End Sub

        ' ===== Right-hand Fulfilled BOMs workflow =====
        Private Sub TryApplyFulfilledPreselection()
            If internalOrderIdForFulfill <= 0 OrElse cboFulfilled Is Nothing Then Return
            Try
                ' Ensure ValueMember is set so SelectedValue works
                If String.IsNullOrWhiteSpace(cboFulfilled.ValueMember) Then
                    cboFulfilled.ValueMember = "InternalOrderID"
                End If
                ' First try the direct SelectedValue assignment (integer)
                cboFulfilled.SelectedValue = internalOrderIdForFulfill
                Dim matched As Boolean = (cboFulfilled.SelectedValue IsNot Nothing AndAlso cboFulfilled.SelectedValue.ToString() = internalOrderIdForFulfill.ToString())

                ' If not matched, and the ValueMember column is string-typed, try matching string version of ID
                If Not matched Then
                    Dim dt As DataTable = TryCast(cboFulfilled.DataSource, DataTable)
                    If dt IsNot Nothing AndAlso dt.Columns.Contains("InternalOrderID") Then
                        Dim isStringColumn As Boolean = (dt.Columns("InternalOrderID").DataType Is GetType(String))
                        If isStringColumn Then
                            cboFulfilled.SelectedValue = internalOrderIdForFulfill.ToString()
                            matched = (cboFulfilled.SelectedValue IsNot Nothing AndAlso cboFulfilled.SelectedValue.ToString() = internalOrderIdForFulfill.ToString())
                        End If
                    End If
                End If

                ' If not matched, iterate the DataSource for a manual match by ID or fallback by OrderNo
                If Not matched Then
                    Dim dt As DataTable = TryCast(cboFulfilled.DataSource, DataTable)
                    If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                        Dim targetIndex As Integer = -1
                        For i As Integer = 0 To dt.Rows.Count - 1
                            Dim rid As Integer = 0
                            Try
                                rid = Convert.ToInt32(dt.Rows(i)("InternalOrderID"))
                            Catch
                            End Try
                            If internalOrderIdForFulfill > 0 AndAlso rid = internalOrderIdForFulfill Then
                                targetIndex = i
                                Exit For
                            End If
                        Next
                        ' Fallback: match by InternalOrderNo if given
                        If targetIndex < 0 AndAlso Not String.IsNullOrWhiteSpace(internalOrderNoForFulfill) Then
                            For i As Integer = 0 To dt.Rows.Count - 1
                                Dim rno As String = TryCast(dt.Rows(i)("InternalOrderNo"), String)
                                If Not String.IsNullOrWhiteSpace(rno) AndAlso String.Equals(rno.Trim(), internalOrderNoForFulfill.Trim(), StringComparison.OrdinalIgnoreCase) Then
                                    targetIndex = i
                                    Exit For
                                End If
                            Next
                        End If
                        If targetIndex >= 0 Then
                            cboFulfilled.SelectedIndex = targetIndex
                            matched = True
                        End If
                    End If
                End If

                ' If selection succeeded, clear the pending preselect to avoid overriding user later
                If matched Then
                    internalOrderIdForFulfill = 0
                    internalOrderNoForFulfill = String.Empty
                End If
            Catch
                ' ignore
            End Try
        End Sub

        Private Sub LoadFulfilledList()
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    ' Original logic: list Open/Issued IOs, filtered by FromLocation branch
                    Dim sql As String = _
                        "SELECT IOH.InternalOrderID, IOH.InternalOrderNo, IOH.Notes, " & _
                        "       CASE " & _
                        "           WHEN LTRIM(RTRIM(COALESCE(u.FirstName, '') + ' ' + COALESCE(u.LastName, ''))) = '' THEN u.Username " & _
                        "           ELSE LTRIM(RTRIM(COALESCE(u.FirstName, '') + ' ' + COALESCE(u.LastName, ''))) " & _
                        "       END AS RequestedByName " & _
                        "FROM dbo.InternalOrderHeader IOH " & _
                        "JOIN dbo.InventoryLocations L ON L.LocationID = IOH.FromLocationID " & _
                        "LEFT JOIN dbo.Users u ON u.UserID = IOH.RequestedBy " & _
                        "WHERE IOH.Status IN ('Open','Issued','Fulfilled') " & _
                        "  AND (L.BranchID = @bid OR @bid IS NULL) " & _
                        "ORDER BY IOH.InternalOrderID DESC"
                    Using cmd As New SqlCommand(sql, cn)
                        Dim bid As Object = If(AppSession.CurrentBranchID > 0, CType(AppSession.CurrentBranchID, Object), DBNull.Value)
                        cmd.Parameters.AddWithValue("@bid", bid)
                        Using da As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            da.Fill(dt)
                            ' Build display as "<Product Name> - <BOM No or IO No>"
                            If Not dt.Columns.Contains("DisplayText") Then dt.Columns.Add("DisplayText", GetType(String))
                            Using cn2 As New SqlConnection(cs)
                                cn2.Open()
                                For Each row As DataRow In dt.Rows
                                    Dim ioNo As String = If(Convert.IsDBNull(row("InternalOrderNo")), "", row("InternalOrderNo").ToString())
                                    Dim notes As String = If(Convert.IsDBNull(row("Notes")), "", row("Notes").ToString())
                                    Dim pid As Integer = ExtractInt(notes, "ProductID=")
                                    Dim qty As Decimal = 0D
                                    ' Prefer Products: list if present
                                    Dim prodStart As Integer = notes.IndexOf("Products:", StringComparison.OrdinalIgnoreCase)
                                    If prodStart >= 0 Then
                                        Dim listPart As String = notes.Substring(prodStart + 9)
                                        Dim semi As Integer = listPart.IndexOf(";"c)
                                        If semi >= 0 Then listPart = listPart.Substring(0, semi)
                                        For Each token In listPart.Split("|"c)
                                            Dim t = token.Trim()
                                            If t.Length = 0 Then Continue For
                                            Dim eq = t.IndexOf("="c)
                                            If eq > 0 Then
                                                Dim idStr = t.Substring(0, eq).Trim()
                                                Dim tmp As Integer
                                                If Integer.TryParse(idStr, tmp) Then
                                                    pid = tmp
                                                    ' capture qty after '=' if present
                                                    Dim qtyStr As String = t.Substring(eq + 1).Trim()
                                                    Dim qtmp As Decimal
                                                    If Decimal.TryParse(qtyStr, qtmp) Then qty = qtmp
                                                    Exit For
                                                End If
                                            End If
                                        Next
                                    End If
                                    Dim pname As String = "Product"
                                    If pid > 0 Then
                                        Using cmdP As New SqlCommand("SELECT TOP 1 ProductName FROM dbo.Products WHERE ProductID=@pid", cn2)
                                            cmdP.Parameters.AddWithValue("@pid", pid)
                                            Dim obj = cmdP.ExecuteScalar()
                                            If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then pname = obj.ToString()
                                        End Using
                                    Else
                                        ' Fallback: infer from InternalOrderLines finished item
                                        Using cmdFP As New SqlCommand("SELECT TOP 1 p.ProductID, p.ProductName, iol.Quantity FROM dbo.InternalOrderLines iol JOIN dbo.Products p ON p.ProductID = iol.ProductID WHERE iol.ItemType = 'Finished' AND iol.InternalOrderID = @id ORDER BY iol.LineNumber", cn2)
                                            cmdFP.Parameters.AddWithValue("@id", Convert.ToInt32(row("InternalOrderID")))
                                            Using rP = cmdFP.ExecuteReader()
                                                If rP.Read() Then
                                                    pid = rP.GetInt32(0)
                                                    pname = rP.GetString(1)
                                                    If qty <= 0D AndAlso Not rP.IsDBNull(2) Then qty = Convert.ToDecimal(rP.GetValue(2))
                                                End If
                                            End Using
                                        End Using
                                    End If
                                    Dim bomNo As String = ExtractToken(notes, "BOMNo=")
                                    If String.IsNullOrWhiteSpace(bomNo) Then bomNo = ExtractToken(notes, "InputBOMNo=")
                                    Dim rightText As String = If(String.IsNullOrWhiteSpace(bomNo), ioNo, bomNo)
                                    Dim reqName As String = ""
                                    If dt.Columns.Contains("RequestedByName") AndAlso Not Convert.IsDBNull(row("RequestedByName")) Then
                                        reqName = row("RequestedByName").ToString()
                                    End If
                                    Dim qtyPart As String = If(qty > 0D, $" x {qty:0.####}", "")
                                    If String.IsNullOrWhiteSpace(reqName) Then
                                        row("DisplayText") = $"{pname}{qtyPart} / {rightText}"
                                    Else
                                        row("DisplayText") = $"{pname}{qtyPart} / {rightText} — Requested by {reqName}"
                                    End If
                                Next
                            End Using
                            ' Clear before rebinding to avoid stale bindings resetting selection
                            cboFulfilled.DataSource = Nothing
                            cboFulfilled.SelectedIndex = -1
                            cboFulfilled.DataSource = dt
                            cboFulfilled.DisplayMember = "DisplayText"
                            ' Set ValueMember so we can select by InternalOrderID
                            cboFulfilled.ValueMember = "InternalOrderID"
                            ' Apply any pending preselection immediately after (re)binding
                            TryApplyFulfilledPreselection()
                            ' Optionally focus so the user immediately sees the selected item text
                            Try
                                If cboFulfilled.Enabled Then cboFulfilled.Focus()
                            Catch
                            End Try
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Load fulfilled BOMs failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnFulfilledSelected(sender As Object, e As EventArgs)
            lvFulfilled.Items.Clear()
            If cboFulfilled.SelectedValue Is Nothing Then Return
            Dim ioId As Integer
            If Not Integer.TryParse(cboFulfilled.SelectedValue.ToString(), ioId) Then Return
            LoadFulfilledLines(ioId)
        End Sub

        Private Sub LoadFulfilledLines(ioId As Integer)
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    lvFulfilled.BeginUpdate()
                    lvFulfilled.Items.Clear()

                    ' Preferred: show Finished lines from InternalOrderLines (what will be received)
                    Dim hasFinished As Boolean = False
                    Using cmdF As New SqlCommand("SELECT iol.LineNumber, p.ProductName, iol.Quantity, ISNULL(p.BaseUoM,'ea') AS UoM FROM dbo.InternalOrderLines iol JOIN dbo.Products p ON p.ProductID = iol.ProductID WHERE iol.InternalOrderID=@id AND iol.ItemType='Finished' ORDER BY iol.LineNumber", cn)
                        cmdF.Parameters.AddWithValue("@id", ioId)
                        Using rF = cmdF.ExecuteReader()
                            Dim line As Integer = 0
                            While rF.Read()
                                hasFinished = True
                                line += 1
                                Dim lvi As New ListViewItem(line.ToString())
                                lvi.SubItems.Add(rF.GetString(1))
                                lvi.SubItems.Add(Convert.ToDecimal(rF.GetValue(2)).ToString("0.####"))
                                lvi.SubItems.Add(rF.GetString(3))
                                lvFulfilled.Items.Add(lvi)
                            End While
                        End Using
                    End Using
                    If hasFinished Then
                        lvFulfilled.EndUpdate()
                        Return
                    End If

                    ' Next, try to show the requested finished products from IOH.Notes (format: "Products: <pid>=<qty>|<pid>=<qty>")
                    Dim notes As String = ""
                    Using cmdN As New SqlCommand("SELECT Notes FROM dbo.InternalOrderHeader WHERE InternalOrderID=@id", cn)
                        cmdN.Parameters.AddWithValue("@id", ioId)
                        Dim objN = cmdN.ExecuteScalar()
                        If objN IsNot Nothing AndAlso objN IsNot DBNull.Value Then notes = objN.ToString()
                    End Using

                    Dim prodEntries As New List(Of Tuple(Of Integer, Decimal))()
                    Dim prodStart As Integer = notes.IndexOf("Products:", StringComparison.OrdinalIgnoreCase)
                    If prodStart >= 0 Then
                        Dim listPart As String = notes.Substring(prodStart + 9)
                        Dim semi As Integer = listPart.IndexOf(";"c)
                        If semi >= 0 Then listPart = listPart.Substring(0, semi)
                        For Each token In listPart.Split("|"c)
                            Dim t = token.Trim()
                            If t.Length = 0 Then Continue For
                            Dim eq = t.IndexOf("="c)
                            If eq > 0 Then
                                Dim idStr = t.Substring(0, eq).Trim()
                                Dim qtyStr = t.Substring(eq + 1).Trim()
                                Dim pid As Integer
                                Dim qv As Decimal
                                If Integer.TryParse(idStr, pid) AndAlso Decimal.TryParse(qtyStr, qv) Then
                                    If qv > 0D Then prodEntries.Add(Tuple.Create(pid, qv))
                                End If
                            End If
                        Next
                    End If

                    If prodEntries.Count > 0 Then
                        Dim lineNo As Integer = 0
                        For Each pe In prodEntries
                            lineNo += 1
                            Dim pname As String = $"Product {pe.Item1}"
                            Dim uom As String = "ea"
                            Using cmdP As New SqlCommand("SELECT TOP 1 ProductName, ISNULL(BaseUoM,'ea') FROM dbo.Products WHERE ProductID=@pid", cn)
                                cmdP.Parameters.AddWithValue("@pid", pe.Item1)
                                Using r = cmdP.ExecuteReader()
                                    If r.Read() Then
                                        pname = r.GetString(0)
                                        uom = r.GetString(1)
                                    End If
                                End Using
                            End Using
                            Dim lvi As New ListViewItem(lineNo.ToString())
                            lvi.SubItems.Add(pname)
                            lvi.SubItems.Add(pe.Item2.ToString("0.####"))
                            lvi.SubItems.Add(uom)
                            lvFulfilled.Items.Add(lvi)
                        Next
                    Else
                        ' Fallback to showing raw material lines if no product list present
                        Dim sql As String = _
                            "SELECT iol.LineNumber, iol.ItemType, " & _
                            "       COALESCE(CONCAT(rm.MaterialCode, ' - ', rm.MaterialName), p.ProductName, 'Component') AS Item, " & _
                            "       iol.Quantity, iol.UoM " & _
                            "FROM dbo.InternalOrderLines iol " & _
                            "LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = iol.RawMaterialID " & _
                            "LEFT JOIN dbo.Products p ON p.ProductID = iol.ProductID " & _
                            "WHERE iol.InternalOrderID = @id " & _
                            "ORDER BY iol.LineNumber"
                        Using cmd As New SqlCommand(sql, cn)
                            cmd.Parameters.AddWithValue("@id", ioId)
                            Using da As New SqlDataAdapter(cmd)
                                Dim dt As New DataTable()
                                da.Fill(dt)
                                For Each row As DataRow In dt.Rows
                                    Dim lvi As New ListViewItem(If(Convert.IsDBNull(row("LineNumber")), "", row("LineNumber").ToString()))
                                    lvi.SubItems.Add(If(Convert.IsDBNull(row("Item")), "", row("Item").ToString()))
                                    Dim qtyText As String = ""
                                    If Not Convert.IsDBNull(row("Quantity")) Then qtyText = Convert.ToDecimal(row("Quantity")).ToString("0.####")
                                    lvi.SubItems.Add(qtyText)
                                    lvi.SubItems.Add(If(Convert.IsDBNull(row("UoM")), "", row("UoM").ToString()))
                                    lvFulfilled.Items.Add(lvi)
                                Next
                            End Using
                        End Using
                    End If
                    lvFulfilled.EndUpdate()
                End Using
            Catch ex As Exception
                MessageBox.Show("Load fulfilled BOM lines failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnCompleted(sender As Object, e As EventArgs)
            If cboFulfilled.SelectedValue Is Nothing Then
                MessageBox.Show("Select a fulfilled BOM first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Dim ioId As Integer
            If Not Integer.TryParse(cboFulfilled.SelectedValue.ToString(), ioId) OrElse ioId <= 0 Then
                MessageBox.Show("Invalid selection.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                ' Variables needed across both primary and fallback branches
                Dim notes As String = ""
                Dim ioNo As String = ""
                Dim inputBomNo As String = ""
                Dim completedOn As String = DateTime.Now.ToString("yyyy-MM-dd HH:mm")
                ' Parse product list from IOH.Notes (preferred), otherwise fall back to single ProductID/Qty tags
                Dim products As New List(Of Tuple(Of Integer, Decimal))()
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("SELECT Notes, InternalOrderNo FROM dbo.InternalOrderHeader WHERE InternalOrderID=@id", cn)
                        cmd.Parameters.AddWithValue("@id", ioId)
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                If Not r.IsDBNull(0) Then notes = r.GetString(0)
                                If Not r.IsDBNull(1) Then ioNo = r.GetString(1)
                            End If
                        End Using
                    End Using
                    Dim prodStart As Integer = notes.IndexOf("Products:", StringComparison.OrdinalIgnoreCase)
                    If prodStart >= 0 Then
                        Dim listPart As String = notes.Substring(prodStart + 9)
                        Dim semi As Integer = listPart.IndexOf(";"c)
                        If semi >= 0 Then listPart = listPart.Substring(0, semi)
                        For Each token In listPart.Split("|"c)
                            Dim t = token.Trim()
                            If t.Length = 0 Then Continue For
                            Dim eq = t.IndexOf("="c)
                            If eq > 0 Then
                                Dim idStr = t.Substring(0, eq).Trim()
                                Dim qtyStr = t.Substring(eq + 1).Trim()
                                Dim pid As Integer
                                Dim qv As Decimal
                                If Integer.TryParse(idStr, pid) AndAlso Decimal.TryParse(qtyStr, qv) AndAlso qv > 0D Then
                                    products.Add(Tuple.Create(pid, qv))
                                End If
                            End If
                        Next
                    Else
                        Dim pid As Integer = ExtractInt(notes, "ProductID=")
                        Dim q = ExtractDecimal(notes, "Qty=")
                        If pid > 0 AndAlso q.HasValue AndAlso q.Value > 0D Then products.Add(Tuple.Create(pid, q.Value))
                    End If
                    ' After receiving, append rows to bottom completed grid
                    inputBomNo = ""
                    Dim bomTag = ExtractToken(notes, "BOMNo=")
                    If Not String.IsNullOrWhiteSpace(bomTag) Then inputBomNo = bomTag Else inputBomNo = ExtractToken(notes, "InputBOMNo=")
                    Using cn2 As New SqlConnection(cs)
                        cn2.Open()
                        For Each t In products
                            Dim pname As String = $"Product {t.Item1}"
                            Dim uom As String = "ea"
                            Using cmdP As New SqlCommand("SELECT TOP 1 ProductName, ISNULL(BaseUoM,'ea') FROM dbo.Products WHERE ProductID=@pid", cn2)
                                cmdP.Parameters.AddWithValue("@pid", t.Item1)
                                Using rp = cmdP.ExecuteReader()
                                    If rp.Read() Then
                                        pname = rp.GetString(0)
                                        uom = rp.GetString(1)
                                    End If
                                End Using
                            End Using
                            Dim row As New ListViewItem(pname)
                            row.SubItems.Add(t.Item2.ToString("0.####"))
                            row.SubItems.Add(uom)
                            row.SubItems.Add(completedOn)
                            row.SubItems.Add(inputBomNo)
                            row.SubItems.Add(ioNo)
                            lvCompleted.Items.Add(row)
                        Next
                    End Using
                End Using

                If products.Count = 0 Then
                    ' Fallback: derive finished products from InternalOrderLines
                    Using cn As New SqlConnection(cs)
                        cn.Open()
                        Using cmdF As New SqlCommand("SELECT iol.ProductID, iol.Quantity, ISNULL(p.BaseUoM,'ea') AS UoM FROM dbo.InternalOrderLines iol JOIN dbo.Products p ON p.ProductID = iol.ProductID WHERE iol.InternalOrderID=@id AND iol.ItemType='Finished' AND iol.ProductID IS NOT NULL", cn)
                            cmdF.Parameters.AddWithValue("@id", ioId)
                            Using rF = cmdF.ExecuteReader()
                                While rF.Read()
                                    Dim pidF As Integer = If(rF.IsDBNull(0), 0, rF.GetInt32(0))
                                    Dim qtyF As Decimal = If(rF.IsDBNull(1), 0D, Convert.ToDecimal(rF.GetValue(1)))
                                    If pidF > 0 AndAlso qtyF > 0D Then products.Add(Tuple.Create(pidF, qtyF))
                                End While
                            End Using
                        End Using
                    End Using
                    If products.Count = 0 Then
                        MessageBox.Show("No products found to receive for this request.", "Complete", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                        Return
                    End If
                    Using cn3 As New SqlConnection(cs)
                        cn3.Open()
                        For Each t In products
                            Dim pname As String = $"Product {t.Item1}"
                            Dim uom As String = "ea"
                            Using cmdP As New SqlCommand("SELECT TOP 1 ProductName, ISNULL(BaseUoM,'ea') FROM dbo.Products WHERE ProductID=@pid", cn3)
                                cmdP.Parameters.AddWithValue("@pid", t.Item1)
                                Using rp = cmdP.ExecuteReader()
                                    If rp.Read() Then
                                        pname = rp.GetString(0)
                                        uom = rp.GetString(1)
                                    End If
                                End Using
                            End Using
                            Dim row As New ListViewItem(pname)
                            row.SubItems.Add(t.Item2.ToString("0.####"))
                            row.SubItems.Add(uom)
                            row.SubItems.Add(completedOn)
                            row.SubItems.Add(inputBomNo)
                            row.SubItems.Add(ioNo)
                            lvCompleted.Items.Add(row)
                        Next
                    End Using
                End If

                ' Deduct raw materials from Manufacturing_Inventory and add finished goods to RETAIL inventory
                Try
                    Dim branchId As Integer = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 1)
                    Dim retailLoc As Integer = 0, mfgLoc As Integer = 0
                    Using cn As New SqlConnection(cs)
                        cn.Open()
                        
                        ' First, deduct raw materials from Manufacturing_Inventory based on InternalOrderLines
                        Using cmdMaterials As New SqlCommand("SELECT MaterialID, Quantity FROM dbo.InternalOrderLines WHERE InternalOrderID=@id AND MaterialID IS NOT NULL", cn)
                            cmdMaterials.Parameters.AddWithValue("@id", ioId)
                            Using rMat = cmdMaterials.ExecuteReader()
                                Dim materials As New List(Of Tuple(Of Integer, Decimal))()
                                While rMat.Read()
                                    Dim matId As Integer = rMat.GetInt32(0)
                                    Dim matQty As Decimal = rMat.GetDecimal(1)
                                    materials.Add(Tuple.Create(matId, matQty))
                                End While
                                rMat.Close()
                                
                                ' Deduct each material from Manufacturing_Inventory
                                For Each mat In materials
                                    Using cmdDeduct As New SqlCommand("UPDATE dbo.Manufacturing_Inventory SET QtyOnHand = QtyOnHand - @qty WHERE MaterialID=@mid AND BranchID=@bid", cn)
                                        cmdDeduct.Parameters.AddWithValue("@qty", mat.Item2)
                                        cmdDeduct.Parameters.AddWithValue("@mid", mat.Item1)
                                        cmdDeduct.Parameters.AddWithValue("@bid", branchId)
                                        cmdDeduct.ExecuteNonQuery()
                                    End Using
                                    
                                    ' Log the movement
                                    Try
                                        Using cmdMove As New SqlCommand("INSERT INTO dbo.Manufacturing_InventoryMovements (MaterialID, BranchID, MovementType, QtyDelta, CostPerUnit, Reference, Notes, MovementDate, CreatedBy) VALUES (@mid, @bid, 'Consumed in Production', -@qty, 0, @ref, @notes, GETDATE(), @user)", cn)
                                            cmdMove.Parameters.AddWithValue("@mid", mat.Item1)
                                            cmdMove.Parameters.AddWithValue("@bid", branchId)
                                            cmdMove.Parameters.AddWithValue("@qty", mat.Item2)
                                            cmdMove.Parameters.AddWithValue("@ref", $"IO-{ioId}")
                                            cmdMove.Parameters.AddWithValue("@notes", "BOM Completion")
                                            cmdMove.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                                            cmdMove.ExecuteNonQuery()
                                        End Using
                                    Catch
                                    End Try
                                Next
                            End Using
                        End Using
                        ' Resolve locations
                        Using cmdLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'RETAIL') AS RetailLoc, dbo.fn_GetLocationId(@b, N'MFG') AS MfgLoc;", cn)
                            cmdLoc.Parameters.AddWithValue("@b", If(branchId > 0, CType(branchId, Object), DBNull.Value))
                            Using r = cmdLoc.ExecuteReader()
                                If r.Read() Then
                                    retailLoc = If(IsDBNull(r("RetailLoc")), 0, Convert.ToInt32(r("RetailLoc")))
                                    mfgLoc = If(IsDBNull(r("MfgLoc")), 0, Convert.ToInt32(r("MfgLoc")))
                                End If
                            End Using
                        End Using
                        If retailLoc > 0 Then
                            For Each t In products
                                Dim pid As Integer = t.Item1
                                Dim qty As Decimal = t.Item2
                                If pid <= 0 OrElse qty <= 0D Then Continue For
                                ' Upsert into ProductInventory at RETAIL
                                Using cmdUp As New SqlCommand("UPDATE dbo.ProductInventory SET QuantityOnHand = ISNULL(QuantityOnHand,0) + @q WHERE ProductID=@p AND LocationID=@loc AND (@b=0 OR BranchID=@b); IF @@ROWCOUNT=0 INSERT INTO dbo.ProductInventory(ProductID, LocationID, BranchID, QuantityOnHand) VALUES(@p,@loc,CASE WHEN @b=0 THEN NULL ELSE @b END,@q);", cn)
                                    cmdUp.Parameters.AddWithValue("@q", qty)
                                    cmdUp.Parameters.AddWithValue("@p", pid)
                                    cmdUp.Parameters.AddWithValue("@loc", retailLoc)
                                    cmdUp.Parameters.AddWithValue("@b", branchId)
                                    cmdUp.ExecuteNonQuery()
                                End Using
                                
                                ' Update Retail_Stock (uses VariantID which maps to ProductID via Retail_Variant)
                                Try
                                    ' Get or create VariantID for this ProductID
                                    Dim variantId As Integer = 0
                                    
                                    ' First try to get existing VariantID
                                    Using cmdGetVariant As New SqlCommand("SELECT VariantID FROM dbo.Retail_Variant WHERE ProductID=@pid", cn)
                                        cmdGetVariant.Parameters.AddWithValue("@pid", pid)
                                        Dim result = cmdGetVariant.ExecuteScalar()
                                        If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                                            variantId = Convert.ToInt32(result)
                                        End If
                                    End Using
                                    
                                    ' If not found, create new variant
                                    If variantId = 0 Then
                                        Using cmdInsertVariant As New SqlCommand("INSERT INTO dbo.Retail_Variant (ProductID) VALUES (@pid); SELECT SCOPE_IDENTITY();", cn)
                                            cmdInsertVariant.Parameters.AddWithValue("@pid", pid)
                                            Dim result = cmdInsertVariant.ExecuteScalar()
                                            If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                                                variantId = Convert.ToInt32(result)
                                            End If
                                        End Using
                                    End If
                                    
                                    If variantId > 0 Then
                                        ' Check if stock record exists
                                        Dim stockExists As Boolean = False
                                        Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM dbo.Retail_Stock WHERE VariantID=@vid AND BranchID=@b", cn)
                                            cmdCheck.Parameters.AddWithValue("@vid", variantId)
                                            cmdCheck.Parameters.AddWithValue("@b", branchId)
                                            stockExists = Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0
                                        End Using
                                        
                                        If stockExists Then
                                            ' Update existing stock
                                            Using cmdUpdate As New SqlCommand("UPDATE dbo.Retail_Stock SET QtyOnHand = QtyOnHand + @q WHERE VariantID=@vid AND BranchID=@b", cn)
                                                cmdUpdate.Parameters.AddWithValue("@vid", variantId)
                                                cmdUpdate.Parameters.AddWithValue("@b", branchId)
                                                cmdUpdate.Parameters.AddWithValue("@q", qty)
                                                cmdUpdate.ExecuteNonQuery()
                                            End Using
                                        Else
                                            ' Insert new stock record
                                            Using cmdInsert As New SqlCommand("INSERT INTO dbo.Retail_Stock (VariantID, BranchID, QtyOnHand, ReorderPoint) VALUES (@vid, @b, @q, 10)", cn)
                                                cmdInsert.Parameters.AddWithValue("@vid", variantId)
                                                cmdInsert.Parameters.AddWithValue("@b", branchId)
                                                cmdInsert.Parameters.AddWithValue("@q", qty)
                                                cmdInsert.ExecuteNonQuery()
                                            End Using
                                        End If
                                        
                                        MessageBox.Show($"Updated Retail_Stock: ProductID={pid}, VariantID={variantId}, Qty={qty}, Branch={branchId}", "Debug", MessageBoxButtons.OK, MessageBoxIcon.Information)
                                    End If
                                Catch ex As Exception
                                    ' Show error to user for debugging
                                    MessageBox.Show($"Retail_Stock update failed: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                End Try
                                ' Try to log a movement from MFG -> RETAIL (ignore if table/columns differ)
                                Try
                                    Using cmdMv As New SqlCommand("IF OBJECT_ID('dbo.ProductMovements','U') IS NOT NULL INSERT INTO dbo.ProductMovements(ProductID, Quantity, FromLocationID, ToLocationID, MovementType, MovementDate, BranchID) VALUES(@p,@q,@fromLoc,@toLoc,N'Production',GETDATE(),CASE WHEN @b=0 THEN NULL ELSE @b END);", cn)
                                        cmdMv.Parameters.AddWithValue("@p", pid)
                                        cmdMv.Parameters.AddWithValue("@q", qty)
                                        cmdMv.Parameters.AddWithValue("@fromLoc", If(mfgLoc > 0, CType(mfgLoc, Object), DBNull.Value))
                                        cmdMv.Parameters.AddWithValue("@toLoc", retailLoc)
                                        cmdMv.Parameters.AddWithValue("@b", branchId)
                                        cmdMv.ExecuteNonQuery()
                                    End Using
                                Catch
                                End Try
                            Next
                        End If
                    End Using
                Catch
                    ' Do not block completion if inventory logging fails
                End Try

                ' Mark IO as Completed
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmdU As New SqlCommand("UPDATE dbo.InternalOrderHeader SET Status='Completed' WHERE InternalOrderID=@id", cn)
                        cmdU.Parameters.AddWithValue("@id", ioId)
                        cmdU.ExecuteNonQuery()
                    End Using
                End Using

                MessageBox.Show("Product(s) created and inventory updated.", "Completed BOM", MessageBoxButtons.OK, MessageBoxIcon.Information)
                lvFulfilled.Items.Clear()
                LoadFulfilledList()
                cboFulfilled.SelectedIndex = -1
            Catch ex As Exception
                MessageBox.Show("Complete failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        ' Allow completing by clicking an item in the Completed BOM grid
        Private Sub OnFulfilledItemActivate(sender As Object, e As EventArgs)
            OnCompleted(sender, e)
        End Sub

        Private Function ExtractInt(text As String, key As String) As Integer
            Try
                Dim startIdx = text.IndexOf(key, StringComparison.OrdinalIgnoreCase)
                If startIdx < 0 Then Return 0
                startIdx += key.Length
                Dim endIdx = text.IndexOfAny(New Char() {";"c, "|"c, " "c}, startIdx)
                Dim token As String = If(endIdx >= 0, text.Substring(startIdx, endIdx - startIdx), text.Substring(startIdx))
                Dim val As Integer
                If Integer.TryParse(token.Trim(), val) Then Return val
            Catch
            End Try
            Return 0
        End Function

        Private Function ExtractToken(text As String, key As String) As String
            Try
                Dim startIdx = text.IndexOf(key, StringComparison.OrdinalIgnoreCase)
                If startIdx < 0 Then Return String.Empty
                startIdx += key.Length
                Dim endIdx = text.IndexOfAny(New Char() {";"c, "|"c, " "c}, startIdx)
                Dim token As String = If(endIdx >= 0, text.Substring(startIdx, endIdx - startIdx), text.Substring(startIdx))
                Return token.Trim()
            Catch
                Return String.Empty
            End Try
        End Function

        Private Function ExtractDecimal(text As String, key As String) As Decimal?
            Try
                Dim startIdx = text.IndexOf(key, StringComparison.OrdinalIgnoreCase)
                If startIdx < 0 Then Return Nothing
                startIdx += key.Length
                Dim endIdx = text.IndexOfAny(New Char() {";"c, "|"c, " "c}, startIdx)
                Dim token As String = If(endIdx >= 0, text.Substring(startIdx, endIdx - startIdx), text.Substring(startIdx))
                Dim val As Decimal
                If Decimal.TryParse(token.Trim(), val) Then Return val
            Catch
            End Try
            Return Nothing
        End Function
    End Class
End Namespace
