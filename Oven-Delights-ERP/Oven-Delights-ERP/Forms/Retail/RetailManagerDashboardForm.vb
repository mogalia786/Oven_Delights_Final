Imports System.Drawing
Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Data
Imports System.Windows.Forms.DataVisualization.Charting
Imports System.Collections.Generic
Imports Microsoft.VisualBasic
Imports Oven_Delights_ERP.Services

Namespace Retail
    Public Class RetailManagerDashboardForm
        Inherits Form

        Private ReadOnly header As New Label()
        Private ReadOnly pnlGrid As New TableLayoutPanel()
        Private ReadOnly btnClose As New Button()
        Private ReadOnly tileValues As New Dictionary(Of String, Label)(StringComparer.OrdinalIgnoreCase)
        Private ReadOnly kpiChart As New Chart()
        Private ReadOnly refreshTimer As New Timer()
        ' Embedded reorder grid inside the "Reorders Due" tile
        Private dgvReorders As DataGridView
        Private lblReordersMeta As Label
        Private lblReordersBlueTick As Label
        Private reorderTable As DataTable
        ' Embedded grid for the "Ordered Items" tile
        Private dgvOrdered As DataGridView
        ' Session memory: product IDs ordered during this session (to resist timer flipping)
        Private ReadOnly orderedTodaySession As New HashSet(Of Integer)()
        ' Manual mode disabled: ordered items grid is loaded from DB so it persists across restarts
        Private orderedItemsManualMode As Boolean = False

        Public Sub New()
            Me.Text = "Retail - Manager Dashboard"
            Me.Name = "RetailManagerDashboardForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.White
            Me.Font = New Font("Segoe UI", 9.0F, FontStyle.Regular, GraphicsUnit.Point)
            Me.Size = New Size(1000, 680)

            header.Text = "Retail Overview"
            header.Font = New Font("Segoe UI", 16.0F, FontStyle.Bold)
            header.AutoSize = True
            header.Location = New Point(20, 15)

            btnClose.Text = "Close"
            btnClose.Anchor = AnchorStyles.Top Or AnchorStyles.Right
            btnClose.Size = New Size(100, 32)
            btnClose.Location = New Point(Me.ClientSize.Width - 120, 16)
            btnClose.BackColor = Color.Gainsboro
            AddHandler btnClose.Click, Sub() Me.Close()
            AddHandler Me.Resize, Sub() btnClose.Location = New Point(Me.ClientSize.Width - 120, 16)

            ' Grid for KPI tiles
            pnlGrid.ColumnCount = 3
            pnlGrid.RowCount = 2
            pnlGrid.Location = New Point(20, 60)
            pnlGrid.Size = New Size(950, 520)
            pnlGrid.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
            pnlGrid.ColumnStyles.Clear()
            pnlGrid.RowStyles.Clear()
            For i = 1 To 3
                pnlGrid.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 33.33F))
            Next
            For i = 1 To 2
                pnlGrid.RowStyles.Add(New RowStyle(SizeType.Percent, 50.0F))
            Next

            ' Tiles (professional, muted styling)
            pnlGrid.Controls.Add(CreateTile("Reorders Due", "--", ""), 0, 0)
            pnlGrid.Controls.Add(CreateTile("Ordered Items", "--", "Reorders placed today"), 1, 0)
            pnlGrid.Controls.Add(CreateTile("Top Product", "--", "Best seller today"), 2, 0)
            pnlGrid.Controls.Add(CreateTile("Stock Alerts", "--", "Below reorder"), 0, 1)
            pnlGrid.Controls.Add(CreateTile("Transfers In-Transit", "--", "Pending IBT"), 1, 1)
            pnlGrid.Controls.Add(CreateTile("Adjustments", "--", "Today"), 2, 1)

            Controls.Add(header)
            Controls.Add(btnClose)
            Controls.Add(pnlGrid)

            ' Chart: Retail KPIs visualization
            Dim chArea As New ChartArea("Main")
            chArea.AxisX.MajorGrid.Enabled = False
            chArea.AxisY.MajorGrid.LineColor = Color.Gainsboro
            kpiChart.ChartAreas.Clear()
            kpiChart.ChartAreas.Add(chArea)
            kpiChart.Legends.Clear()
            kpiChart.Palette = ChartColorPalette.SeaGreen
            kpiChart.Anchor = AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
            kpiChart.Location = New Point(20, Me.ClientSize.Height - 260)
            kpiChart.Size = New Size(950, 180)
            AddHandler Me.Resize, Sub() kpiChart.Location = New Point(20, Me.ClientSize.Height - 260)
            Controls.Add(kpiChart)

            ' Load KPIs
            AddHandler Me.Shown, Sub()
                                      LoadKpisSafely()
                                      LoadReorderGridSafely()
                                      LoadOrderedItemsGridSafely()
                                  End Sub

            ' Auto-refresh using configurable interval
            AddHandler refreshTimer.Tick, Sub()
                                              LoadKpisSafely()
                                              LoadReorderGridSafely()
                                              If Not orderedItemsManualMode Then
                                                  LoadOrderedItemsGridSafely()
                                              End If
                                          End Sub
            refreshTimer.Interval = GetRefreshIntervalFromConfig()
            refreshTimer.Start()

            ' Pause/resume refresh when not visible or deactivated
            AddHandler Me.Activated, Sub() ResumeRefresh()
            AddHandler Me.Deactivate, Sub() 
                ' Only pause if form is actually being deactivated, not just losing focus
                If Me.WindowState <> FormWindowState.Minimized Then
                    ' Keep refresh running when form is visible but not active
                    Return
                End If
                PauseRefresh()
            End Sub
            AddHandler Me.VisibleChanged, Sub()
                                            If Me.Visible AndAlso Me.WindowState <> FormWindowState.Minimized Then
                                                ResumeRefresh()
                                            Else
                                                PauseRefresh()
                                            End If
                                         End Sub
        End Sub

        Private Function GetLatestOrderNumberForProduct(productId As Integer) As String
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Dim branchId As Integer = AppSession.CurrentBranchID
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim retailLoc As Integer = 0
                    Using cmdLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'RETAIL') AS RetailLoc;", cn)
                        cmdLoc.Parameters.AddWithValue("@b", branchId)
                        Using r As SqlDataReader = cmdLoc.ExecuteReader()
                            If r.Read() Then
                                retailLoc = If(IsDBNull(r("RetailLoc")), 0, Convert.ToInt32(r("RetailLoc")))
                            End If
                        End Using
                    End Using
                    Using cmd As New SqlCommand("SELECT TOP 1 ioh.InternalOrderNo FROM dbo.InternalOrderHeader ioh " & _
                                                "JOIN dbo.InternalOrderLines iol ON ioh.InternalOrderID=iol.InternalOrderID " & _
                                                "WHERE iol.ProductID=@p AND (@loc IS NULL OR ioh.ToLocationID=@loc OR ioh.FromLocationID=@loc) " & _
                                                "AND CONVERT(date, ioh.RequestedDate)=@today " & _
                                                "ORDER BY ioh.InternalOrderID DESC;", cn)
                        cmd.Parameters.AddWithValue("@p", productId)
                        cmd.Parameters.AddWithValue("@loc", If(retailLoc > 0, retailLoc, CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                        Dim obj = cmd.ExecuteScalar()
                        Return If(obj Is Nothing OrElse obj Is DBNull.Value, String.Empty, obj.ToString())
                    End Using
                End Using
            Catch
                Return String.Empty
            End Try
        End Function

        Private Sub UpsertRetailOrdersToday(orderNumber As String, productId As Integer, sku As String, productName As String, qty As Decimal)
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
                    cmd.Parameters.AddWithValue("@ManufacturerUserID", CType(DBNull.Value, Object))
                    cmd.Parameters.AddWithValue("@ManufacturerName", CType(DBNull.Value, Object))
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        End Sub

        Private Function GetRetailLocationId(branchId As Integer) As Integer
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'RETAIL')", cn)
                        cmd.Parameters.AddWithValue("@b", branchId)
                        Dim obj = cmd.ExecuteScalar()
                        Return If(obj Is Nothing OrElse obj Is DBNull.Value, 0, Convert.ToInt32(obj))
                    End Using
                End Using
            Catch
                Return 0
            End Try
        End Function

        Private Function GetCurrentUserDisplayName() As String
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("SELECT TOP 1 (FirstName + ' ' + LastName) FROM dbo.Users WHERE UserID=@u;", cn)
                        cmd.Parameters.AddWithValue("@u", AppSession.CurrentUserID)
                        Dim obj = cmd.ExecuteScalar()
                        If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                            Return Convert.ToString(obj)
                        End If
                    End Using
                End Using
            Catch
            End Try
            Return ""
        End Function

        Private Sub UpdateOrderedItemsTileCount()
            If orderedItemsManualMode AndAlso dgvOrdered IsNot Nothing Then
                SetTileValue("Ordered Items", dgvOrdered.Rows.Count.ToString())
                Return
            End If
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim branchId As Integer = AppSession.CurrentBranchID
                    Dim retailLoc As Integer = 0
                    Using cmdLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'RETAIL') AS RetailLoc;", cn)
                        cmdLoc.Parameters.AddWithValue("@b", branchId)
                        Dim r As SqlDataReader = cmdLoc.ExecuteReader()
                        If r.Read() Then
                            retailLoc = If(IsDBNull(r("RetailLoc")), 0, Convert.ToInt32(r("RetailLoc")))
                        End If
                        r.Close()
                    End Using
                    Using cmd As New SqlCommand("SELECT COUNT(1) FROM dbo.InternalOrderHeader IOH WHERE IOH.Status='Open' AND (@loc IS NULL OR IOH.ToLocationID=@loc OR IOH.FromLocationID=@loc) AND CONVERT(date, IOH.RequestedDate)=@today;", cn)
                        cmd.Parameters.AddWithValue("@loc", If(retailLoc > 0, retailLoc, CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                        Dim vOrdered As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                        SetTileValue("Ordered Items", vOrdered.ToString())
                    End Using
                End Using
            Catch
                ' ignore tile refresh errors
            End Try
        End Sub

        ' (constructor closed above)

        Private Function GetRefreshIntervalFromConfig() As Integer
            Try
                Dim s = ConfigurationManager.AppSettings("DashboardRefreshSeconds")
                Dim seconds As Integer
                If Integer.TryParse(s, seconds) AndAlso seconds > 0 Then
                    Return seconds * 1000
                End If
            Catch
            End Try
            Return 60000 ' default 60s
        End Function

        Private Sub PauseRefresh()
            refreshTimer.Stop()
        End Sub

        Private Sub ResumeRefresh()
            refreshTimer.Interval = GetRefreshIntervalFromConfig()
            If Not refreshTimer.Enabled Then refreshTimer.Start()
        End Sub

        Private Function CreateTile(title As String, valueText As String, subtitle As String) As Control
            Dim panel As New Panel()
            panel.Margin = New Padding(8)
            panel.Padding = New Padding(16)
            panel.BackColor = Color.WhiteSmoke
            panel.BorderStyle = BorderStyle.FixedSingle
            panel.Dock = DockStyle.Fill

            Dim lblTitle As New Label() With {
                .Text = title,
                .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold),
                .AutoSize = True,
                .Location = New Point(8, 8)
            }
            panel.Controls.Add(lblTitle)

            If String.Equals(title, "Reorders Due", StringComparison.OrdinalIgnoreCase) Then
                ' Build embedded DataGridView for live reorder view
                dgvReorders = New DataGridView() With {
                    .Dock = DockStyle.Fill,
                    .Top = 36,
                    .Left = 8,
                    .Height = panel.Height - 48,
                    .AllowUserToAddRows = False,
                    .AllowUserToDeleteRows = False,
                    .ReadOnly = False,
                    .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                    .MultiSelect = False,
                    .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None,
                    .BackgroundColor = Color.White,
                    .ScrollBars = ScrollBars.Both,
                    .RowHeadersVisible = False
                }
                dgvReorders.Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right
                BuildReorderGridColumns()
                panel.Controls.Add(dgvReorders)
                ' diagnostics label
                lblReordersMeta = New Label() With {
                    .AutoSize = False,
                    .Dock = DockStyle.Bottom,
                    .Height = 18,
                    .Font = New Font("Segoe UI", 8.0F, FontStyle.Italic),
                    .ForeColor = Color.Gray,
                    .TextAlign = ContentAlignment.MiddleLeft,
                    .Padding = New Padding(8, 0, 0, 0)
                }
                panel.Controls.Add(lblReordersMeta)
                ' blue tick indicator (visual marker to confirm correct form)
                lblReordersBlueTick = New Label() With {
                    .AutoSize = True,
                    .Font = New Font("Segoe UI", 12.0F, FontStyle.Bold),
                    .ForeColor = Color.DodgerBlue,
                    .Text = "✔",
                    .Top = 6,
                    .Left = panel.Width - 24
                }
                lblReordersBlueTick.Anchor = AnchorStyles.Top Or AnchorStyles.Right
                panel.Controls.Add(lblReordersBlueTick)
                ' Immediately load data into the embedded grid
                Try
                    LoadReorderGridSafely()
                Catch
                End Try
            ElseIf String.Equals(title, "Ordered Items", StringComparison.OrdinalIgnoreCase) Then
                ' Create a compact grid listing today's open orders to Retail
                dgvOrdered = New DataGridView() With {
                    .Name = "dgvOrdered",
                    .Dock = DockStyle.Fill,
                    .AllowUserToAddRows = False,
                    .AllowUserToDeleteRows = False,
                    .ReadOnly = True,
                    .RowHeadersVisible = False,
                    .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                    .BackgroundColor = Color.White,
                    .MultiSelect = False,
                    .SelectionMode = DataGridViewSelectionMode.FullRowSelect
                }
                dgvOrdered.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)
                dgvOrdered.DefaultCellStyle.Font = New Font("Segoe UI", 9.0F)
                dgvOrdered.Columns.Clear()
                dgvOrdered.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "OrderNo", .HeaderText = "Order #", .FillWeight = 26})
                dgvOrdered.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "SKU", .HeaderText = "SKU", .FillWeight = 30})
                dgvOrdered.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductName", .HeaderText = "Product", .FillWeight = 100})
                dgvOrdered.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Qty", .HeaderText = "Qty", .FillWeight = 22, .DefaultCellStyle = New DataGridViewCellStyle() With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "0"}})
                dgvOrdered.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Time", .HeaderText = "Time", .FillWeight = 22, .DefaultCellStyle = New DataGridViewCellStyle() With {.Alignment = DataGridViewContentAlignment.MiddleCenter}})
                panel.Controls.Add(dgvOrdered)
                Try
                    LoadOrderedItemsGridSafely()
                Catch
                End Try
            Else
                Dim lblValue As New Label() With {
                    .Text = valueText,
                    .Font = New Font("Segoe UI", 22.0F, FontStyle.Bold),
                    .AutoSize = True,
                    .Location = New Point(8, 34)
                }
                Dim lblSub As New Label() With {
                    .Text = subtitle,
                    .Font = New Font("Segoe UI", 9.0F, FontStyle.Regular),
                    .AutoSize = True,
                    .ForeColor = Color.DimGray,
                    .Location = New Point(8, 78)
                }
                panel.Controls.Add(lblValue)
                panel.Controls.Add(lblSub)
                ' Click actions only for non-grid tiles
                AddHandler panel.Click, Sub() OnTileClicked(title)
                AddHandler lblTitle.Click, Sub() OnTileClicked(title)
                AddHandler lblValue.Click, Sub() OnTileClicked(title)
                AddHandler lblSub.Click, Sub() OnTileClicked(title)
                ' track value label by tile title
                If Not tileValues.ContainsKey(title) Then tileValues.Add(title, lblValue)
            End If
            Return panel
        End Function

        Private Sub LoadOrderedItemsGridSafely()
            Try
                If Not orderedItemsManualMode Then
                    LoadOrderedItemsGrid()
                End If
            Catch
            End Try
        End Sub

        Private Sub LoadOrderedItemsGrid()
            If dgvOrdered Is Nothing Then Return
            If orderedItemsManualMode Then Return ' safety
            dgvOrdered.Rows.Clear()
            Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Dim branchId As Integer = AppSession.CurrentBranchID
            Using cn As New SqlConnection(cs)
                cn.Open()
                Using cmd As New SqlCommand("SELECT OrderNumber, SKU, ProductName, Qty, CreatedDate FROM dbo.RetailOrdersToday WHERE OrderDate = @today AND (@b IS NULL OR BranchID=@b) ORDER BY CreatedDate DESC;", cn)
                    cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                    cmd.Parameters.AddWithValue("@b", If(branchId > 0, branchId, CType(DBNull.Value, Object)))
                    Using rd = cmd.ExecuteReader()
                        While rd.Read()
                            Dim ordNo As String = If(rd.IsDBNull(0), "", rd.GetString(0))
                            Dim sku As String = If(rd.IsDBNull(1), "", Convert.ToString(rd.GetValue(1)))
                            Dim prod As String = If(rd.IsDBNull(2), "", Convert.ToString(rd.GetValue(2)))
                            Dim q As Decimal = If(rd.IsDBNull(3), 0D, Convert.ToDecimal(rd.GetValue(3)))
                            Dim t As String = ""
                            If Not rd.IsDBNull(4) Then
                                Dim dt As DateTime = Convert.ToDateTime(rd.GetValue(4))
                                t = dt.ToString("HH:mm")
                            End If
                            dgvOrdered.Rows.Add(ordNo, sku, prod, q, t)
                        End While
                    End Using
                End Using
            End Using
        End Sub

        ' Time handled globally by Services.TimeProvider

        Private Sub BuildReorderGridColumns()
            If dgvReorders Is Nothing Then Return
            dgvReorders.Columns.Clear()
            ' Hidden identifiers
            dgvReorders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductID", .HeaderText = "ProductID", .Visible = False})
            dgvReorders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "SKU", .HeaderText = "SKU", .Width = 110})
            dgvReorders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductName", .HeaderText = "Product", .Width = 260})
            dgvReorders.Columns.Add(New DataGridViewTextBoxColumn() With {
                .Name = "OnHand",
                .HeaderText = "Qty",
                .Width = 80,
                .DefaultCellStyle = New DataGridViewCellStyle() With {
                    .Alignment = DataGridViewContentAlignment.MiddleRight,
                    .Format = "0"
                }
            })
            dgvReorders.Columns.Add(New DataGridViewCheckBoxColumn() With {.Name = "IsManufactured", .HeaderText = "MFG", .Width = 50, .ReadOnly = True})
            dgvReorders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Status", .HeaderText = "Status", .Width = 80, .Visible = False})
            dgvReorders.Columns.Add(New DataGridViewTextBoxColumn() With {
                .Name = "ReorderQty",
                .HeaderText = "Order Qty",
                .Width = 80,
                .DefaultCellStyle = New DataGridViewCellStyle() With {
                    .Alignment = DataGridViewContentAlignment.MiddleRight,
                    .Format = "0"
                }
            })
            Dim btnCol As New DataGridViewButtonColumn() With {.Name = "Action", .HeaderText = "", .Text = "Reorder", .UseColumnTextForButtonValue = True, .Width = 90}
            dgvReorders.Columns.Add(btnCol)
            ' Keep the Reorder button always visible
            dgvReorders.Columns("Action").DisplayIndex = 0
            dgvReorders.Columns("Action").Frozen = True
            AddHandler dgvReorders.CellContentClick, AddressOf DgvReorders_CellContentClick
        End Sub

        Private Sub LoadReorderGridSafely()
            Try
                LoadReorderGrid()
            Catch ex As Exception
                ' Fallback: attempt minimal load to ensure user sees products
                Try
                    LoadReorderGridFallback()
                Catch
                    ' swallow
                End Try
                If lblReordersMeta IsNot Nothing Then
                    lblReordersMeta.Text = $"err: {ex.Message} ({TimeProvider.Now():HH:mm})"
                End If
            End Try
        End Sub

        Private Sub LoadReorderGrid()
            If dgvReorders Is Nothing Then Return
            Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Dim branchId As Integer = AppSession.CurrentBranchID

            Using cn As New SqlConnection(cs)
                cn.Open()
                ' Resolve RETAIL location
                Dim retailLoc As Integer = 0
                Using cmdLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'RETAIL') AS RetailLoc;", cn)
                    Dim pB = cmdLoc.Parameters.Add("@b", SqlDbType.Int)
                    If branchId > 0 Then
                        pB.Value = branchId
                    Else
                        pB.Value = DBNull.Value
                    End If
                    Using r = cmdLoc.ExecuteReader()
                        If r.Read() Then
                            retailLoc = If(IsDBNull(r("RetailLoc")), 0, Convert.ToInt32(r("RetailLoc")))
                        End If
                    End Using
                End Using
                ' Do NOT return if retail location not configured; still show products with OnHand=0

                ' Build dataset: products, on hand, manufactured flag, today's internal order existence and receipts to RETAIL today
                ' Determine which SKU column exists (SKU vs ProductCode)
                Dim skuCol As String = "SKU"
                Using cmdSku As New SqlCommand("SELECT CASE WHEN EXISTS(SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Products') AND name = 'SKU') THEN 1 ELSE 0 END", cn)
                    Dim hasSku = Convert.ToInt32(cmdSku.ExecuteScalar()) = 1
                    If Not hasSku Then skuCol = "ProductCode"
                End Using

                Dim sql As String = ""
                sql &= "WITH MFG AS ( " &
                       "  SELECT DISTINCT bh.ProductID FROM dbo.BOMHeader bh " &
                       "  UNION SELECT DISTINCT pr.ProductID FROM dbo.ProductRecipe pr )," &
                       " SOH AS ( " &
                       "  SELECT rv.ProductID, SUM(ISNULL(rs.QtyOnHand,0)) AS OnHand FROM dbo.Retail_Stock rs " &
                       "  INNER JOIN dbo.Retail_Variant rv ON rs.VariantID = rv.VariantID " &
                       "  WHERE rs.BranchID = COALESCE(@b, rs.BranchID) GROUP BY rv.ProductID )," &
                       " ROTS AS ( " &
                       "  SELECT DISTINCT t.ProductID FROM dbo.RetailOrdersToday t WHERE t.OrderDate = @today AND t.BranchID = COALESCE(@b, t.BranchID) ), " &
                       " RECEIPTS AS ( " &
                       "  SELECT DISTINCT pm.ProductID FROM dbo.ProductMovements pm " &
                       "  WHERE (@retailLoc IS NOT NULL AND pm.ToLocationID = @retailLoc) AND CONVERT(date, pm.MovementDate)=@today ) " &
                       "SELECT p.ProductID, p." & skuCol & " AS SKU, p.ProductName, ISNULL(s.OnHand,0) AS OnHand, CASE WHEN m.ProductID IS NULL THEN 0 ELSE 1 END AS IsManufactured, " &
                       "       CASE WHEN (CASE WHEN m.ProductID IS NULL THEN 0 ELSE 1 END)=1 THEN CASE WHEN r.ProductID IS NOT NULL THEN 'Green' ELSE 'Red' END " &
                       "            ELSE CASE WHEN ISNULL(s.OnHand,0) < 10 THEN 'Red' WHEN ISNULL(s.OnHand,0) < 15 THEN 'Yellow' ELSE 'Green' END END AS Status, " &
                       "       CASE WHEN (CASE WHEN m.ProductID IS NULL THEN 0 ELSE 1 END)=1 THEN 10 ELSE 0 END AS ReorderQty, " &
                       "       CASE WHEN rt.ProductID IS NOT NULL AND r.ProductID IS NULL THEN 1 ELSE 0 END AS OrderedToday " &
                       "FROM dbo.Products p " &
                       "INNER JOIN (SELECT DISTINCT rv.ProductID FROM dbo.Retail_Variant rv INNER JOIN dbo.Retail_Stock rs ON rv.VariantID = rs.VariantID WHERE rs.BranchID = COALESCE(@b, rs.BranchID)) PB ON PB.ProductID = p.ProductID " &
                       "LEFT JOIN SOH s ON s.ProductID=p.ProductID " &
                       "LEFT JOIN MFG m ON m.ProductID=p.ProductID " &
                       "LEFT JOIN ROTS rt ON rt.ProductID=p.ProductID " &
                       "LEFT JOIN RECEIPTS r ON r.ProductID=p.ProductID " &
                       "WHERE 1=1 " &
                       "ORDER BY p.ProductName;"

                Dim dt As New DataTable()
                Using cmd As New SqlCommand(sql, cn)
                    Dim pB = cmd.Parameters.Add("@b", SqlDbType.Int)
                    If branchId > 0 Then
                        pB.Value = branchId
                    Else
                        pB.Value = DBNull.Value
                    End If
                    Dim pLoc = cmd.Parameters.Add("@loc", SqlDbType.Int)
                    If retailLoc > 0 Then
                        pLoc.Value = retailLoc
                    Else
                        pLoc.Value = DBNull.Value
                    End If
                    cmd.Parameters.Add(New SqlParameter("@retailLoc", SqlDbType.Int) With {.Value = If(retailLoc > 0, retailLoc, CType(DBNull.Value, Object))})
                    cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using

                reorderTable = dt
                dgvReorders.Rows.Clear()
                If dt.Rows.Count = 0 Then
                    ' Fallback minimal list
                    LoadReorderGridFallback(cn)
                Else
                    For Each row As DataRow In dt.Rows
                        Dim pid As Integer = Convert.ToInt32(row("ProductID"))
                        Dim idx = dgvReorders.Rows.Add(row("ProductID"), row("SKU"), row("ProductName"), row("OnHand"), Convert.ToBoolean(row("IsManufactured")), row("Status"), row("ReorderQty"), "Reorder")
                        ' If this product has an order created today OR we flagged it in-session, render Action as Ordered and read-only
                        Dim orderedToday As Boolean = False
                        If dt.Columns.Contains("OrderedToday") Then
                            orderedToday = Convert.ToInt32(row("OrderedToday")) = 1
                        End If
                        If (orderedToday OrElse orderedTodaySession.Contains(pid)) Then
                            Dim c = dgvReorders.Rows(idx).Cells("Action")
                            Dim orderedCell As New DataGridViewTextBoxCell()
                            orderedCell.Value = "Ordered"
                            dgvReorders.Rows(idx).Cells("Action") = orderedCell
                            dgvReorders.Rows(idx).Cells("Action").Style.BackColor = Color.LightGray
                            dgvReorders.Rows(idx).Cells("Action").Style.ForeColor = Color.DimGray
                            dgvReorders.Rows(idx).Cells("Action").Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                            dgvReorders.Rows(idx).Cells("Action").ReadOnly = True
                            dgvReorders.Rows(idx).Cells("Action").ToolTipText = "Ordered"
                            dgvReorders.Rows(idx).Cells("Action").Tag = "Ordered"
                        End If
                        ApplyRowStyle(idx)
                    Next
                End If
            End Using
            dgvReorders.Visible = True
            dgvReorders.BringToFront()
            ' Reset scroll position and selection
            Try
                dgvReorders.FirstDisplayedScrollingColumnIndex = 0
            Catch
            End Try
            dgvReorders.HorizontalScrollingOffset = 0
            dgvReorders.ClearSelection()
            If lblReordersMeta IsNot Nothing Then
                lblReordersMeta.Text = $"{dgvReorders.Rows.Count} items  |  {TimeProvider.Now():HH:mm}"
            End If
        End Sub

        Private Sub LoadReorderGridFallback(Optional openConnection As SqlConnection = Nothing)
            If dgvReorders Is Nothing Then Return
            Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Dim needsClose As Boolean = False
            Dim cn As SqlConnection = openConnection
            If cn Is Nothing Then
                cn = New SqlConnection(cs)
                cn.Open()
                needsClose = True
            End If
            Try
                ' Resolve Retail location (needed to detect receipts today)
                Dim retailLoc As Integer = 0
                Dim branchId As Integer = AppSession.CurrentBranchID
                Try
                    Using cmdLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'RETAIL') AS RetailLoc;", cn)
                        cmdLoc.Parameters.AddWithValue("@b", branchId)
                        Using r = cmdLoc.ExecuteReader()
                            If r.Read() Then
                                retailLoc = If(IsDBNull(r("RetailLoc")), 0, Convert.ToInt32(r("RetailLoc")))
                            End If
                        End Using
                    End Using
                Catch
                End Try
                ' Determine SKU column
                Dim skuCol As String = "SKU"
                Using cmdSku As New SqlCommand("SELECT CASE WHEN EXISTS(SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Products') AND name = 'SKU') THEN 1 ELSE 0 END", cn)
                    Dim hasSku = Convert.ToInt32(cmdSku.ExecuteScalar()) = 1
                    If Not hasSku Then skuCol = "ProductCode"
                End Using

                Dim sql As String = "WITH MFG AS ( " &
                                   "  SELECT DISTINCT bh.ProductID FROM dbo.BOMHeader bh " &
                                   "  UNION SELECT DISTINCT pr.ProductID FROM dbo.ProductRecipe pr ) " &
                                   $"SELECT p.ProductID, p.{skuCol} AS SKU, p.ProductName, CAST(0 AS decimal(18,2)) AS OnHand, " &
                                   "       CASE WHEN m.ProductID IS NULL THEN 0 ELSE 1 END AS IsManufactured, " &
                                   "       CASE WHEN (CASE WHEN m.ProductID IS NULL THEN 0 ELSE 1 END)=1 " &
                                   "            THEN CASE WHEN EXISTS(SELECT 1 FROM dbo.ProductMovements pm WHERE (@retailLoc IS NOT NULL AND pm.ToLocationID=@retailLoc) AND CONVERT(date, pm.MovementDate)=@today AND pm.ProductID=p.ProductID) " &
                                   "                      THEN 'Green' ELSE 'Red' END " &
                                   "            ELSE 'Green' END AS Status, " &
                                   "       CASE WHEN (CASE WHEN m.ProductID IS NULL THEN 0 ELSE 1 END)=1 THEN 10 ELSE 0 END AS ReorderQty, " &
                                   "       CASE WHEN EXISTS (SELECT 1 FROM dbo.InternalOrderLines iol " &
                                   "                        JOIN dbo.InternalOrderHeader ioh ON ioh.InternalOrderID = iol.InternalOrderID " &
                                   "                        WHERE iol.ProductID = p.ProductID AND ioh.Status = 'Open' " &
                                   "                          AND CONVERT(date, ioh.RequestedDate) = @today) THEN 1 ELSE 0 END AS OrderedToday " &
                                   "FROM dbo.Products p " &
                                   "INNER JOIN (SELECT DISTINCT rv.ProductID FROM dbo.Retail_Variant rv INNER JOIN dbo.Retail_Stock rs ON rv.VariantID = rs.VariantID WHERE rs.BranchID = COALESCE(@b, rs.BranchID)) PB ON PB.ProductID = p.ProductID " &
                                   "LEFT JOIN MFG m ON m.ProductID=p.ProductID " &
                                   "ORDER BY p.ProductName;"

                Dim dt As New DataTable()
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                    cmd.Parameters.AddWithValue("@retailLoc", If(retailLoc > 0, retailLoc, CType(DBNull.Value, Object)))
                    cmd.Parameters.AddWithValue("@b", AppSession.CurrentBranchID)
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using

                dgvReorders.Rows.Clear()
                For Each row As DataRow In dt.Rows
                    Dim idx = dgvReorders.Rows.Add(row("ProductID"), row("SKU"), row("ProductName"), row("OnHand"), Convert.ToBoolean(row("IsManufactured")), row("Status"), row("ReorderQty"), "Reorder")
                    ' If already ordered today, convert button to read-only label
                    If dt.Columns.Contains("OrderedToday") AndAlso Not IsDBNull(row("OrderedToday")) AndAlso Convert.ToInt32(row("OrderedToday")) = 1 Then
                        Dim c As DataGridViewTextBoxCell = New DataGridViewTextBoxCell()
                        c.Value = "Ordered"
                        dgvReorders.Rows(idx).Cells("Action") = c
                        With dgvReorders.Rows(idx).Cells("Action").Style
                            .BackColor = Color.LightGray
                            .ForeColor = Color.DimGray
                            .Alignment = DataGridViewContentAlignment.MiddleCenter
                        End With
                        dgvReorders.Rows(idx).Cells("Action").ReadOnly = True
                        dgvReorders.Rows(idx).Cells("Action").ToolTipText = "Ordered"
                        dgvReorders.Rows(idx).Cells("Action").Tag = "Ordered"
                    End If
                    ApplyRowStyle(idx)
                Next
                ' Reset scroll position and selection
                Try
                    dgvReorders.FirstDisplayedScrollingColumnIndex = 0
                Catch
                End Try
                dgvReorders.HorizontalScrollingOffset = 0
                dgvReorders.ClearSelection()
            Finally
                If needsClose Then
                    cn.Close()
                End If
            End Try
            If lblReordersMeta IsNot Nothing Then
                lblReordersMeta.Text = $"{dgvReorders.Rows.Count} items  |  {DateTime.Now:HH:mm}"
            End If
        End Sub

        Private Sub ApplyRowStyle(rowIndex As Integer)
            If rowIndex < 0 OrElse rowIndex >= dgvReorders.Rows.Count Then Return
            Dim r = dgvReorders.Rows(rowIndex)
            Dim status As String = Convert.ToString(r.Cells("Status").Value)
            Select Case status
                Case "Red"
                    r.DefaultCellStyle.BackColor = Color.Red
                    r.DefaultCellStyle.ForeColor = Color.White
                Case "Yellow"
                    r.DefaultCellStyle.BackColor = Color.Yellow
                    r.DefaultCellStyle.ForeColor = Color.Black
                Case Else
                    r.DefaultCellStyle.BackColor = Color.Green
                    r.DefaultCellStyle.ForeColor = Color.White
            End Select
            r.DefaultCellStyle.SelectionBackColor = Color.DodgerBlue
            r.DefaultCellStyle.SelectionForeColor = Color.White
        End Sub

        Private Sub DgvReorders_CellContentClick(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex < 0 Then Return
            If dgvReorders.Columns(e.ColumnIndex).Name <> "Action" Then Return
            Dim r = dgvReorders.Rows(e.RowIndex)
            Dim actionCell = r.Cells("Action")
            If Not TypeOf actionCell Is DataGridViewButtonCell Then Return
            If actionCell IsNot Nothing AndAlso actionCell.Tag IsNot Nothing AndAlso String.Equals(actionCell.Tag.ToString(), "Ordered", StringComparison.OrdinalIgnoreCase) Then
                Return
            End If
            Dim productId As Integer = Convert.ToInt32(r.Cells("ProductID").Value)
            Dim qtyObj = r.Cells("ReorderQty").Value
            Dim defaultQty As Decimal = 0D
            Decimal.TryParse(Convert.ToString(qtyObj), defaultQty)
            Dim input As String = InputBox($"Enter reorder quantity for {r.Cells("SKU").Value}", "Reorder Quantity", If(defaultQty > 0D, defaultQty.ToString(), "1"))
            Dim qty As Decimal
            If Not Decimal.TryParse(input, qty) OrElse qty <= 0D Then
                MessageBox.Show("Invalid quantity.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Try
                Dim ordNoCreated As String = CreateInternalOrderForProduct(productId, qty)
                If String.IsNullOrWhiteSpace(ordNoCreated) Then
                    ' Fallback: fetch latest order number for this product for today (same branch/location scope)
                    ordNoCreated = GetLatestOrderNumberForProduct(productId)
                End If
                r.Cells("ReorderQty").Value = qty
                Dim orderedCell As New DataGridViewTextBoxCell()
                orderedCell.Value = "Ordered"
                r.Cells("Action") = orderedCell
                r.Cells("Action").Style.BackColor = Color.LightGray
                r.Cells("Action").Style.ForeColor = Color.DimGray
                r.Cells("Action").Style.Alignment = DataGridViewContentAlignment.MiddleCenter
                r.Cells("Action").ReadOnly = True
                r.Cells("Action").ToolTipText = "Ordered"
                r.Cells("Action").Tag = "Ordered"
                ApplyRowStyle(e.RowIndex)
                dgvReorders.InvalidateRow(e.RowIndex)
                UpdateOrderedItemsTileCount()
                ' Persist in-session to resist timer flipping and update Ordered grid immediately
                Try
                    orderedTodaySession.Add(productId)
                Catch
                End Try
                ' Persist to RetailOrdersToday (DB) so dashboard reloads are consistent across sessions
                Try
                    Dim skuTxt As String = If(r.Cells("SKU").Value Is Nothing, "", r.Cells("SKU").Value.ToString())
                    Dim prodTxt As String = If(r.Cells("ProductName").Value Is Nothing, "", r.Cells("ProductName").Value.ToString())
                    UpsertRetailOrdersToday(ordNoCreated, productId, skuTxt, prodTxt, qty)
                Catch
                End Try
                If dgvOrdered IsNot Nothing Then
                    Dim skuTxt As String = If(r.Cells("SKU").Value Is Nothing, "", r.Cells("SKU").Value.ToString())
                    Dim prodTxt As String = If(r.Cells("ProductName").Value Is Nothing, "", r.Cells("ProductName").Value.ToString())
                    Dim timeTxt As String = TimeProvider.Now().ToString("HH:mm")
                    ' Transfer directly from the reorder row, using Order # returned by creation call
                    dgvOrdered.Rows.Insert(0, ordNoCreated, skuTxt, prodTxt, qty, timeTxt)
                End If
                ' Defer DB reload to timer so the just-inserted UI row remains visible immediately
                ' Keep left-aligned and selection cleared after the change
                Try : dgvReorders.FirstDisplayedScrollingColumnIndex = 0 : Catch : End Try
                dgvReorders.HorizontalScrollingOffset = 0
                dgvReorders.ClearSelection()
                MessageBox.Show("Reorder created.", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
                LoadKpisSafely()
            Catch ex As Exception
                MessageBox.Show("Reorder failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function CreateInternalOrderForProduct(productId As Integer, qty As Decimal) As String
            Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Using cn As New SqlConnection(cs)
                cn.Open()

                ' Build TVP for one item per dbo.BOMRequestItem (ProductID, OutputQty)
                Dim tvp As New DataTable()
                tvp.Columns.Add("ProductID", GetType(Integer))
                tvp.Columns.Add("OutputQty", GetType(Decimal))
                tvp.Rows.Add(productId, qty)

                ' Call SP: dbo.sp_MO_CreateBundleFromBOM(@Items TVP, @BranchID, @UserID)
                Using cmd As New SqlCommand("dbo.sp_MO_CreateBundleFromBOM", cn)
                    cmd.CommandType = CommandType.StoredProcedure
                    Dim pItems As New SqlParameter("@Items", SqlDbType.Structured)
                    pItems.TypeName = "dbo.BOMRequestItem"
                    pItems.Value = tvp
                    cmd.Parameters.Add(pItems)
                    cmd.Parameters.Add(New SqlParameter("@BranchID", SqlDbType.Int) With {.Value = AppSession.CurrentBranchID})
                    cmd.Parameters.Add(New SqlParameter("@UserID", SqlDbType.Int) With {.Value = AppSession.CurrentUserID})
                    ' Capture result set to retrieve OrderNumber without extra queries
                    Dim ds As New DataSet()
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(ds)
                    End Using
                    If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                        Dim hdr As DataTable = ds.Tables(0)
                        Dim h As DataRow = hdr.Rows(0)
                        ' Prefer explicit order number columns from the proc result
                        Dim possibleCols As String() = {"OrderNumber", "InternalOrderNo", "InternalOrderNumber", "OrderNo", "DocNumber"}
                        For Each c In possibleCols
                            If hdr.Columns.Contains(c) AndAlso Not IsDBNull(h(c)) Then
                                Dim num As String = Convert.ToString(h(c))
                                If Not String.IsNullOrWhiteSpace(num) Then Return num
                            End If
                        Next
                        ' If header ID present, look it up directly for authoritative value
                        Dim idCols As String() = {"InternalOrderID", "OrderID", "HeaderID"}
                        For Each ic In idCols
                            If hdr.Columns.Contains(ic) AndAlso Not IsDBNull(h(ic)) Then
                                Dim iohId As Integer = 0
                                Integer.TryParse(Convert.ToString(h(ic)), iohId)
                                If iohId > 0 Then
                                    Using cmdFetch As New SqlCommand("SELECT InternalOrderNo FROM dbo.InternalOrderHeader WHERE InternalOrderID=@id", cn)
                                        cmdFetch.Parameters.AddWithValue("@id", iohId)
                                        Dim o = cmdFetch.ExecuteScalar()
                                        If o IsNot Nothing AndAlso o IsNot DBNull.Value Then
                                            Dim num2 As String = o.ToString()
                                            If Not String.IsNullOrWhiteSpace(num2) Then Return num2
                                        End If
                                    End Using
                                End If
                            End If
                        Next
                    End If
                End Using
            End Using
            Return String.Empty
        End Function

        Private Sub SetTileValue(title As String, valueText As String)
            Dim lbl As Label = Nothing
            If tileValues.TryGetValue(title, lbl) Then
                lbl.Text = valueText
            End If
        End Sub

        Private Sub LoadKpisSafely()
            Try
                LoadKpis()
            Catch
                ' Ensure a visible empty series so chart doesn't look broken
                Try
                    kpiChart.Series.Clear()
                    Dim sEmpty As New Series("KPIs") With {
                        .ChartType = SeriesChartType.Column,
                        .IsValueShownAsLabel = True
                    }
                    kpiChart.Series.Add(sEmpty)
                Catch
                End Try
            End Try
        End Sub

        Private Sub LoadKpis()
            Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Dim branchId As Integer = AppSession.CurrentBranchID
            If branchId <= 0 Then Return
            Using cn As New SqlConnection(cs)
                cn.Open()

                ' Resolve Retail location for this branch
                Dim retailLoc As Integer = 0
                Using cmdLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'RETAIL') AS RetailLoc;", cn)
                    cmdLoc.Parameters.AddWithValue("@b", branchId)
                    Using r = cmdLoc.ExecuteReader()
                        If r.Read() Then
                            retailLoc = If(IsDBNull(r("RetailLoc")), 0, Convert.ToInt32(r("RetailLoc")))
                        End If
                    End Using
                End Using
                If retailLoc = 0 Then Return

                Dim vInbound As Integer = 0, vOrdered As Integer = 0, vZeroSkus As Integer = 0, vReorders As Integer = 0

                ' 0) Reorders Due — Open Internal Orders for this branch's Retail location (tag 'Products:%')
                Using cmd As New SqlCommand("SELECT COUNT(1) FROM dbo.InternalOrderHeader IOH WHERE IOH.Status='Open' AND IOH.Notes LIKE 'Products:%' AND (@loc IS NULL OR IOH.ToLocationID=@loc OR IOH.FromLocationID=@loc);", cn)
                    cmd.Parameters.AddWithValue("@loc", retailLoc)
                    vReorders = Convert.ToInt32(cmd.ExecuteScalar())
                    SetTileValue("Reorders Due", vReorders.ToString())
                End Using

                ' 1) Today's inbound movements to Retail (receipts/transfers)
                Using cmd As New SqlCommand("SELECT COUNT(1) FROM dbo.ProductMovements pm WHERE pm.ToLocationID=@loc AND CONVERT(date, pm.MovementDate)=@today AND pm.BranchID=@b;", cn)
                    cmd.Parameters.AddWithValue("@loc", retailLoc)
                    cmd.Parameters.AddWithValue("@b", branchId)
                    cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                    vInbound = Convert.ToInt32(cmd.ExecuteScalar())
                    SetTileValue("Transfers In-Transit", vInbound.ToString()) ' reuse tile spot for movements today
                End Using

                ' 2) Ordered Items — Open Internal Orders created today where Retail is source or destination
                Using cmd As New SqlCommand("SELECT COUNT(1) FROM dbo.InternalOrderHeader IOH WHERE IOH.Status='Open' AND (@loc IS NULL OR IOH.ToLocationID=@loc OR IOH.FromLocationID=@loc) AND CONVERT(date, IOH.RequestedDate)=@today;", cn)
                    cmd.Parameters.AddWithValue("@loc", retailLoc)
                    cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                    vOrdered = Convert.ToInt32(cmd.ExecuteScalar())
                    SetTileValue("Ordered Items", vOrdered.ToString())
                End Using

                ' 3) Zero stock SKUs (potential alerts)
                Using cmd As New SqlCommand("SELECT COUNT(1) FROM dbo.Retail_Stock rs WHERE rs.BranchID=@b AND ISNULL(rs.QtyOnHand,0) = 0;", cn)
                    cmd.Parameters.AddWithValue("@loc", retailLoc)
                    cmd.Parameters.AddWithValue("@b", branchId)
                    vZeroSkus = Convert.ToInt32(cmd.ExecuteScalar())
                    SetTileValue("Stock Alerts", vZeroSkus.ToString())
                End Using

                ' Update Chart
                kpiChart.Series.Clear()
                Dim s As New Series("RetailKPIs") With {
                    .ChartType = SeriesChartType.Column,
                    .IsValueShownAsLabel = True
                }
                s.Points.AddXY("Reorders", vReorders)
                s.Points.AddXY("InboundToday", vInbound)
                s.Points.AddXY("OrderedItems", vOrdered)
                s.Points.AddXY("ZeroStock", vZeroSkus)
                kpiChart.Series.Add(s)
            End Using
        End Sub

        Private Sub OnTileClicked(title As String)
            Select Case title
                Case "Reorders Due"
                    ' No navigation; grid is embedded in the tile.
            End Select
        End Sub

    End Class
End Namespace
