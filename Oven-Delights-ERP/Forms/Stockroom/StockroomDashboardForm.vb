Imports System.Drawing
Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms.DataVisualization.Charting
Imports Oven_Delights_ERP.Services
Imports Oven_Delights_ERP.Common

Namespace Stockroom
    Public Class StockroomDashboardForm
        Inherits Form

        Private ReadOnly header As New Label()
        Private ReadOnly pnlGrid As New TableLayoutPanel()
        Private ReadOnly btnClose As New Button()
        Private ReadOnly tileValues As New Dictionary(Of String, Label)(StringComparer.OrdinalIgnoreCase)
        Private ReadOnly btnOpenBom As New Button()
        Private ReadOnly kpiChart As New Chart()
        Private ReadOnly refreshTimer As New Timer()
        ' Embedded grid for Retail Orders in the "Reorders Due" tile
        Private dgvRetailOrders As DataGridView
        ' Embedded grid for External (PO) Orders in the "POs Pending" tile
        Private dgvExternalOrders As DataGridView

        Public Sub New()
            Me.Text = "Stockroom - Dashboard"
            Me.Name = "StockroomDashboardForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.White
            Me.Font = New Font("Segoe UI", 9.0F, FontStyle.Regular, GraphicsUnit.Point)
            Me.Size = New Size(1000, 680)

            header.Text = "Stockroom Overview"
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

            pnlGrid.Controls.Add(CreateTile("Reorders Due", "--", "Internal BOM picks"), 0, 0)
            pnlGrid.Controls.Add(CreateTile("POs Pending", "--", "External reorders"), 1, 0)
            pnlGrid.Controls.Add(CreateTile("Receipts Today", "--", "GRN count"), 2, 0)
            pnlGrid.Controls.Add(CreateTile("Issues to MFG", "--", "Components issued"), 0, 1)
            pnlGrid.Controls.Add(CreateTile("In-Transit", "--", "Transfers"), 1, 1)
            pnlGrid.Controls.Add(CreateTile("Adjustments", "--", "Today"), 2, 1)

            Controls.Add(header)
            Controls.Add(btnClose)
            Controls.Add(pnlGrid)

            AddHandler Me.Shown, Sub()
                                      LoadKpisSafely()
                                      LoadRetailOrdersGridSafely()
                                      LoadExternalOrdersGridSafely()
                                  End Sub

            ' Action button: Open BOM Editor
            btnOpenBom.Text = "Open BOM Fulfill"
            btnOpenBom.Size = New Size(160, 32)
            btnOpenBom.Location = New Point(20, Me.ClientSize.Height - 56)
            btnOpenBom.Anchor = AnchorStyles.Left Or AnchorStyles.Bottom
            AddHandler btnOpenBom.Click, AddressOf OnOpenBom
            Controls.Add(btnOpenBom)

            ' Chart: visual summary of KPIs
            Dim chArea As New ChartArea("Main")
            chArea.AxisX.MajorGrid.Enabled = False
            chArea.AxisY.MajorGrid.LineColor = Color.Gainsboro
            kpiChart.ChartAreas.Clear()
            kpiChart.ChartAreas.Add(chArea)
            kpiChart.Legends.Clear()
            kpiChart.Palette = ChartColorPalette.BrightPastel
            kpiChart.Anchor = AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
            kpiChart.Location = New Point(20, Me.ClientSize.Height - 260)
            kpiChart.Size = New Size(950, 180)
            AddHandler Me.Resize, Sub() kpiChart.Location = New Point(20, Me.ClientSize.Height - 260)
            Controls.Add(kpiChart)

            ' Auto-refresh using configurable interval
            AddHandler refreshTimer.Tick, Sub()
                                             LoadKpisSafely()
                                             LoadRetailOrdersGridSafely()
                                             LoadExternalOrdersGridSafely()
                                         End Sub
            refreshTimer.Interval = GetRefreshIntervalFromConfig()
            refreshTimer.Start()

            ' Pause/resume refresh when not visible or deactivated
            AddHandler Me.Activated, Sub() ResumeRefresh()
            AddHandler Me.Deactivate, Sub() PauseRefresh()
            AddHandler Me.VisibleChanged, Sub()
                                            If Me.Visible AndAlso Me.WindowState <> FormWindowState.Minimized Then
                                                ResumeRefresh()
                                            Else
                                                PauseRefresh()
                                            End If
                                         End Sub
        End Sub

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
            refreshTimer.[Stop]()
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

            panel.Controls.Add(lblTitle)
            panel.Controls.Add(lblValue)
            panel.Controls.Add(lblSub)

            ' If this is the Reorders Due tile, embed the retail orders grid under the subtitle
            If String.Equals(title, "Reorders Due", StringComparison.OrdinalIgnoreCase) Then
                dgvRetailOrders = New DataGridView()
                dgvRetailOrders.AllowUserToAddRows = False
                dgvRetailOrders.AllowUserToDeleteRows = False
                dgvRetailOrders.ReadOnly = True
                dgvRetailOrders.SelectionMode = DataGridViewSelectionMode.FullRowSelect
                dgvRetailOrders.MultiSelect = False
                dgvRetailOrders.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
                dgvRetailOrders.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
                dgvRetailOrders.Location = New Point(12, 108)
                dgvRetailOrders.Size = New Size(panel.ClientSize.Width - 24, panel.ClientSize.Height - 120)
                AddHandler panel.Resize, Sub()
                                             dgvRetailOrders.Size = New Size(panel.ClientSize.Width - 24, panel.ClientSize.Height - 120)
                                         End Sub

                dgvRetailOrders.Columns.Clear()
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "OrderNumber", .HeaderText = "Order #", .FillWeight = 16})
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "SKU", .HeaderText = "SKU", .FillWeight = 16})
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductName", .HeaderText = "Product", .FillWeight = 28})
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Qty", .HeaderText = "Qty", .FillWeight = 10})
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ManufacturerName", .HeaderText = "Manufacturer", .FillWeight = 20})
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Status", .HeaderText = "Status", .FillWeight = 12})
                Dim btnOpen As New DataGridViewButtonColumn() With {.Name = "Open", .HeaderText = "Open", .Text = "Open", .UseColumnTextForButtonValue = True, .FillWeight = 10}
                Dim btnChange As New DataGridViewButtonColumn() With {.Name = "ChangeMfg", .HeaderText = "Change Mfg", .Text = "Change", .UseColumnTextForButtonValue = True, .FillWeight = 10}
                dgvRetailOrders.Columns.Add(btnOpen)
                dgvRetailOrders.Columns.Add(btnChange)
                ' Keep ProductID as hidden technical column
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductID", .HeaderText = "ProductID", .Visible = False})
                AddHandler dgvRetailOrders.CellClick, AddressOf OnRetailOrdersCellClick
                panel.Controls.Add(dgvRetailOrders)
            ElseIf String.Equals(title, "POs Pending", StringComparison.OrdinalIgnoreCase) Then
                dgvExternalOrders = New DataGridView()
                dgvExternalOrders.AllowUserToAddRows = False
                dgvExternalOrders.AllowUserToDeleteRows = False
                dgvExternalOrders.ReadOnly = True
                dgvExternalOrders.SelectionMode = DataGridViewSelectionMode.FullRowSelect
                dgvExternalOrders.MultiSelect = False
                dgvExternalOrders.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
                dgvExternalOrders.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
                dgvExternalOrders.Location = New Point(12, 108)
                dgvExternalOrders.Size = New Size(panel.ClientSize.Width - 24, panel.ClientSize.Height - 120)
                AddHandler panel.Resize, Sub()
                                             dgvExternalOrders.Size = New Size(panel.ClientSize.Width - 24, panel.ClientSize.Height - 120)
                                         End Sub

                dgvExternalOrders.Columns.Clear()
                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "SKU", .HeaderText = "SKU", .FillWeight = 16})
                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductName", .HeaderText = "Product", .FillWeight = 26})
                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Qty", .HeaderText = "Qty", .FillWeight = 10})
                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "SupplierName", .HeaderText = "Supplier", .FillWeight = 20})
                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "POID", .HeaderText = "PO #", .FillWeight = 12})
                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "POCreated", .HeaderText = "PO Created (UTC)", .FillWeight = 16})
                Dim btnOpenPO As New DataGridViewButtonColumn() With {.Name = "OpenPO", .HeaderText = "Open", .Text = "Open", .UseColumnTextForButtonValue = True, .FillWeight = 10}
                dgvExternalOrders.Columns.Add(btnOpenPO)
                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductID", .HeaderText = "ProductID", .Visible = False})
                AddHandler dgvExternalOrders.CellClick, AddressOf OnExternalOrdersCellClick
                panel.Controls.Add(dgvExternalOrders)
            End If
            ' Make tile touch-clickable to open Stockroom fulfill view.
            ' Only Reorders Due auto-runs shortage-to-PO.
            Dim autoShortage As Boolean = String.Equals(title, "Reorders Due", StringComparison.OrdinalIgnoreCase)
            AddHandler panel.Click, Sub() OpenStockroomFulfill(autoShortage)
            AddHandler lblTitle.Click, Sub() OpenStockroomFulfill(autoShortage)
            AddHandler lblValue.Click, Sub() OpenStockroomFulfill(autoShortage)
            AddHandler lblSub.Click, Sub() OpenStockroomFulfill(autoShortage)
            If Not tileValues.ContainsKey(title) Then tileValues.Add(title, lblValue)
            Return panel
        End Function

        Private Sub OnOpenBom(sender As Object, e As EventArgs)
            OpenStockroomFulfill(False)
        End Sub

        Private Sub OpenStockroomFulfill(Optional autoShortagePO As Boolean = False, Optional manufacturerUserId As Integer = 0, Optional manufacturerName As String = Nothing)
            Using frm As New Stockroom.InternalOrdersForm(autoShortagePO, manufacturerUserId, manufacturerName)
                frm.ShowDialog(Me)
            End Using
            RefreshData()
        End Sub

        Private Sub SetTileValue(title As String, valueText As String)
            Dim lbl As Label = Nothing
            If tileValues.TryGetValue(title, lbl) Then
                lbl.Text = valueText
            End If
        End Sub

        Private Sub LoadRetailOrdersGridSafely()
            Try
                LoadRetailOrdersGrid()
            Catch
            End Try
        End Sub

        

        Private Sub LoadRetailOrdersGrid()
            If dgvRetailOrders Is Nothing Then Return
            dgvRetailOrders.Rows.Clear()
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Dim branchId As Integer = AppSession.CurrentBranchID
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("SELECT rot.OrderNumber, rot.SKU, rot.ProductName, rot.Qty, rot.ManufacturerName, rot.ManufacturerUserID, rot.ProductID,
       dob.StockroomFulfilledAtUtc
FROM dbo.RetailOrdersToday rot
LEFT JOIN dbo.DailyOrderBook dob
  ON dob.BookDate = @d AND dob.BranchID = @b AND dob.ProductID = rot.ProductID
WHERE rot.OrderDate=@d AND (@b IS NULL OR rot.BranchID=@b)
ORDER BY rot.ID DESC;", cn)
                        cmd.Parameters.AddWithValue("@d", TimeProvider.Today())
                        cmd.Parameters.AddWithValue("@b", If(branchId > 0, branchId, CType(DBNull.Value, Object)))
                        Using r = cmd.ExecuteReader()
                            While r.Read()
                                Dim mfgName As String = If(r("ManufacturerName") Is DBNull.Value, "", Convert.ToString(r("ManufacturerName")))
                                If String.IsNullOrWhiteSpace(mfgName) Then mfgName = "Unassigned"
                                Dim fulfilled As Boolean = Not (r("StockroomFulfilledAtUtc") Is DBNull.Value)
                                Dim statusText As String = If(fulfilled, "Completed", "Pending")
                                Dim idx As Integer = dgvRetailOrders.Rows.Add(New Object() {
                                    If(r("OrderNumber") Is DBNull.Value, "", Convert.ToString(r("OrderNumber"))),
                                    If(r("SKU") Is DBNull.Value, "", Convert.ToString(r("SKU"))),
                                    If(r("ProductName") Is DBNull.Value, "", Convert.ToString(r("ProductName"))),
                                    If(r("Qty") Is DBNull.Value, 0D, Convert.ToDecimal(r("Qty"))),
                                    mfgName,
                                    statusText,
                                    "Open",
                                    "Change",
                                    Convert.ToInt32(r("ProductID"))
                                })
                                ' keep manufacturer user id in row tag for later use
                                Dim manId As Integer = 0
                                If Not (r("ManufacturerUserID") Is DBNull.Value) Then manId = Convert.ToInt32(r("ManufacturerUserID"))
                                dgvRetailOrders.Rows(idx).Tag = manId
                                If fulfilled Then
                                    Try
                                        Dim row = dgvRetailOrders.Rows(idx)
                                        row.DefaultCellStyle.BackColor = Color.Gainsboro
                                        row.DefaultCellStyle.ForeColor = Color.DimGray
                                        row.ReadOnly = True
                                    Catch
                                    End Try
                                End If
                            End While
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, "Failed to load Retail Orders: " & ex.Message, "Stockroom Dashboard", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function ResolveUserName(cn As SqlConnection, userId As Integer) As String
            Try
                Using cmd As New SqlCommand("SELECT TOP 1 (FirstName + ' ' + LastName) FROM dbo.Users WHERE UserID=@id", cn)
                    cmd.Parameters.AddWithValue("@id", userId)
                    Dim o = cmd.ExecuteScalar()
                    If o Is Nothing OrElse o Is DBNull.Value Then Return "User #" & userId.ToString()
                    Return Convert.ToString(o)
                End Using
            Catch
                Return "User #" & userId.ToString()
            End Try
        End Function

        Private Sub OnRetailOrdersCellClick(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex < 0 Then Return
            Dim colName = dgvRetailOrders.Columns(e.ColumnIndex).Name
            If colName = "Open" Then
                Dim row = dgvRetailOrders.Rows(e.RowIndex)
                ' If already completed, ignore further opens
                Dim statusVal As String = TryCast(row.Cells("Status").Value, String)
                If Not String.IsNullOrEmpty(statusVal) AndAlso statusVal.Equals("Completed", StringComparison.OrdinalIgnoreCase) Then
                    Return
                End If
                Dim manId As Integer = 0
                If row IsNot Nothing AndAlso row.Tag IsNot Nothing Then
                    Integer.TryParse(row.Tag.ToString(), manId)
                End If
                Dim manName As String = If(row.Cells("ManufacturerName").Value Is Nothing, Nothing, row.Cells("ManufacturerName").Value.ToString())
                ' Open fulfill form and, upon OK, mark as completed in the dashboard
                Dim dr As DialogResult
                Using frm As New Stockroom.InternalOrdersForm(True, manId, manName)
                    dr = frm.ShowDialog(Me)
                End Using
                If dr = DialogResult.OK Then
                    Try
                        row.Cells("Status").Value = "Completed"
                        row.DefaultCellStyle.BackColor = Color.Gainsboro
                        row.DefaultCellStyle.ForeColor = Color.DimGray
                        row.ReadOnly = True
                    Catch
                    End Try
                End If
            ElseIf colName = "ChangeMfg" Then
                Dim prodId As Integer = 0
                Dim cellObj As Object = dgvRetailOrders.Rows(e.RowIndex).Cells("ProductID").Value
                If cellObj IsNot Nothing Then Integer.TryParse(Convert.ToString(cellObj), prodId)
                Dim pick = ManufacturerPickerForm.Pick(Me)
                If pick.Ok AndAlso pick.UserID > 0 Then
                    UpsertRetailOrdersToday(productId:=prodId,
                                             orderNumber:=Convert.ToString(dgvRetailOrders.Rows(e.RowIndex).Cells("OrderNumber").Value),
                                             sku:=Convert.ToString(dgvRetailOrders.Rows(e.RowIndex).Cells("SKU").Value),
                                             productName:=Convert.ToString(dgvRetailOrders.Rows(e.RowIndex).Cells("ProductName").Value),
                                             qty:=Convert.ToDecimal(dgvRetailOrders.Rows(e.RowIndex).Cells("Qty").Value),
                                             manufacturerUserId:=pick.UserID,
                                             manufacturerName:=pick.UserName)
                    LoadRetailOrdersGridSafely()
                End If
            End If
        End Sub

        Private Sub UpsertRetailOrdersToday(productId As Integer, orderNumber As String, sku As String, productName As String, qty As Decimal, manufacturerUserId As Integer, manufacturerName As String)
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Dim branchId As Integer = AppSession.CurrentBranchID
                Dim locId As Integer = 0
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmdLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'STOCKROOM')", cn)
                        cmdLoc.Parameters.AddWithValue("@b", branchId)
                        Dim o = cmdLoc.ExecuteScalar()
                        If o IsNot Nothing AndAlso o IsNot DBNull.Value Then locId = Convert.ToInt32(o)
                    End Using
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
                        cmd.Parameters.AddWithValue("@RequestedBy", AppSession.CurrentUserID)
                        cmd.Parameters.AddWithValue("@RequestedByName", DBNull.Value)
                        cmd.Parameters.AddWithValue("@ManufacturerUserID", If(manufacturerUserId > 0, manufacturerUserId, CType(DBNull.Value, Object)))
                        cmd.Parameters.AddWithValue("@ManufacturerName", If(String.IsNullOrEmpty(manufacturerName), CType(DBNull.Value, Object), manufacturerName))
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
            Catch
            End Try
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

        Public Sub RefreshData()
            LoadKpisSafely()
            LoadRetailOrdersGridSafely()
        End Sub

        Private Sub LoadKpis()
            Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Dim branchId As Integer = AppSession.CurrentBranchID
            If branchId <= 0 Then Return
            Using cn As New SqlConnection(cs)
                cn.Open()

                ' Resolve Stockroom and MFG locations for this branch
                Dim stockLoc As Integer = 0, mfgLoc As Integer = 0
                Using cmdLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'STOCKROOM') AS StockLoc, dbo.fn_GetLocationId(@b, N'MFG') AS MfgLoc;", cn)
                    cmdLoc.Parameters.AddWithValue("@b", branchId)
                    Using r = cmdLoc.ExecuteReader()
                        If r.Read() Then
                            stockLoc = If(IsDBNull(r("StockLoc")), 0, Convert.ToInt32(r("StockLoc")))
                            mfgLoc = If(IsDBNull(r("MfgLoc")), 0, Convert.ToInt32(r("MfgLoc")))
                        End If
                    End Using
                End Using

                ' 1) Reorders Due (Internal) — Open/Issued internal orders from Stockroom to MFG
                Dim vReorders As Integer = 0, vPOs As Integer = 0, vReceipts As Integer = 0, vIssuesToday As Integer = 0, vInTransit As Integer = 0, vAdjust As Integer = 0

                If stockLoc > 0 AndAlso mfgLoc > 0 Then
                    Using cmd As New SqlCommand("SELECT COUNT(1) FROM dbo.InternalOrderHeader IOH WHERE IOH.FromLocationID=@fromLoc AND IOH.ToLocationID=@toLoc AND IOH.Status IN ('Open','Issued');", cn)
                        cmd.Parameters.AddWithValue("@fromLoc", stockLoc)
                        cmd.Parameters.AddWithValue("@toLoc", mfgLoc)
                        vReorders = Convert.ToInt32(cmd.ExecuteScalar())
                        SetTileValue("Reorders Due", vReorders.ToString())
                    End Using
                End If

                ' 2) POs Pending — Draft/Approved/Open
                Using cmd As New SqlCommand("SELECT COUNT(1) FROM dbo.PurchaseOrders WHERE ISNULL(Status,'Draft') IN (N'Draft',N'Approved',N'Open') AND BranchID=@b;", cn)
                    cmd.Parameters.AddWithValue("@b", branchId)
                    vPOs = Convert.ToInt32(cmd.ExecuteScalar())
                    SetTileValue("POs Pending", vPOs.ToString())
                End Using

                ' 3) Receipts Today (GRN)
                Using cmd As New SqlCommand("SELECT COUNT(1) FROM dbo.GoodsReceivedNotes WHERE CONVERT(date, ReceivedDate)=@today AND BranchID=@b;", cn)
                    cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                    cmd.Parameters.AddWithValue("@b", branchId)
                    vReceipts = Convert.ToInt32(cmd.ExecuteScalar())
                    SetTileValue("Receipts Today", vReceipts.ToString())
                End Using

                ' 4) Issues to MFG (today) — internal orders Issued today
                If stockLoc > 0 AndAlso mfgLoc > 0 Then
                    Using cmd As New SqlCommand("SELECT COUNT(1) FROM dbo.InternalOrderHeader IOH WHERE IOH.FromLocationID=@fromLoc AND IOH.ToLocationID=@toLoc AND IOH.Status='Issued' AND CONVERT(date, IOH.RequestedDate)=@today;", cn)
                        cmd.Parameters.AddWithValue("@fromLoc", stockLoc)
                        cmd.Parameters.AddWithValue("@toLoc", mfgLoc)
                        cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                        vIssuesToday = Convert.ToInt32(cmd.ExecuteScalar())
                        SetTileValue("Issues to MFG", vIssuesToday.ToString())
                    End Using
                End If

                ' 5) In-Transit Transfers — if StockTransfers exists
                Try
                    Using cmd As New SqlCommand("IF OBJECT_ID('dbo.StockTransfers','U') IS NOT NULL SELECT COUNT(1) ELSE SELECT 0 FROM dbo.StockTransfers WHERE Status=N'InTransit' AND BranchID=@b;", cn)
                        cmd.Parameters.AddWithValue("@b", branchId)
                        vInTransit = Convert.ToInt32(cmd.ExecuteScalar())
                    End Using
                Catch
                    vInTransit = 0
                End Try
                SetTileValue("In-Transit", vInTransit.ToString())

                ' 6) Adjustments Today — StockMovements for Stockroom area
                Using cmd As New SqlCommand("SELECT COUNT(1) FROM dbo.StockMovements WHERE MovementType=N'Adjustment' AND InventoryArea=N'Stockroom' AND CONVERT(date, MovementDate)=@today;", cn)
                    cmd.Parameters.AddWithValue("@today", TimeProvider.Today())
                    vAdjust = Convert.ToInt32(cmd.ExecuteScalar())
                    SetTileValue("Adjustments", vAdjust.ToString())
                End Using

                ' Update Chart dataset
                kpiChart.Series.Clear()
                Dim s As New Series("KPIs") With {
                    .ChartType = SeriesChartType.Column,
                    .IsValueShownAsLabel = True
                }
                s.Points.AddXY("Reorders", vReorders)
                s.Points.AddXY("POs", vPOs)
                s.Points.AddXY("Receipts", vReceipts)
                s.Points.AddXY("IssuesToday", vIssuesToday)
                s.Points.AddXY("InTransit", vInTransit)
                s.Points.AddXY("Adjustments", vAdjust)
                kpiChart.Series.Add(s)
            End Using
        End Sub

        ' Safely refresh the embedded External Orders grid (POs Pending tile)
        Private Sub LoadExternalOrdersGridSafely()
            Try
                LoadExternalOrdersGrid()
            Catch
            End Try
        End Sub

        ' Load external (supplier) orders from DailyOrderBook for today and current branch
        Private Sub LoadExternalOrdersGrid()
            If dgvExternalOrders Is Nothing Then Return

            ' Initialize columns once
            If dgvExternalOrders.Columns.Count = 0 Then
                dgvExternalOrders.ReadOnly = True
                dgvExternalOrders.AllowUserToAddRows = False
                dgvExternalOrders.AllowUserToDeleteRows = False
                dgvExternalOrders.SelectionMode = DataGridViewSelectionMode.FullRowSelect
                dgvExternalOrders.MultiSelect = False
                dgvExternalOrders.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill

                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "PurchaseOrderID", .HeaderText = "PO #", .FillWeight = 14})
                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "SKU", .HeaderText = "SKU", .FillWeight = 16})
                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductName", .HeaderText = "Product", .FillWeight = 28})
                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "SupplierName", .HeaderText = "Supplier", .FillWeight = 20})
                dgvExternalOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Status", .HeaderText = "Status", .FillWeight = 12})
                Dim btnOpen As New DataGridViewButtonColumn() With {.Name = "Open", .HeaderText = "Open", .Text = "Open", .UseColumnTextForButtonValue = True, .FillWeight = 10}
                dgvExternalOrders.Columns.Add(btnOpen)

                AddHandler dgvExternalOrders.CellClick, AddressOf OnExternalOrdersCellClick
            End If

            dgvExternalOrders.Rows.Clear()

            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("SELECT PurchaseOrderID, SKU, ProductName, SupplierName, COALESCE(Status, N'Pending') AS Status FROM dbo.DailyOrderBook WHERE BookDate=@d AND BranchID=@b AND ISNULL(IsInternal,0)=0 AND PurchaseOrderID IS NOT NULL ORDER BY PurchaseOrderID DESC;", cn)
                        cmd.Parameters.AddWithValue("@d", TimeProvider.Today())
                        cmd.Parameters.AddWithValue("@b", AppSession.CurrentBranchID)
                        Using r = cmd.ExecuteReader()
                            While r.Read()
                                Dim poId As Integer = If(IsDBNull(r("PurchaseOrderID")), 0, Convert.ToInt32(r("PurchaseOrderID")))
                                Dim sku As String = If(IsDBNull(r("SKU")), String.Empty, Convert.ToString(r("SKU")))
                                Dim prod As String = If(IsDBNull(r("ProductName")), String.Empty, Convert.ToString(r("ProductName")))
                                Dim supp As String = If(IsDBNull(r("SupplierName")), String.Empty, Convert.ToString(r("SupplierName")))
                                Dim st As String = If(IsDBNull(r("Status")), "Pending", Convert.ToString(r("Status")))
                                dgvExternalOrders.Rows.Add(poId, sku, prod, supp, st, "Open")
                            End While
                        End Using
                    End Using
                End Using
            Catch
            End Try
        End Sub

        ' Handle clicks in External Orders grid (Open button)
        Private Sub OnExternalOrdersCellClick(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex < 0 OrElse dgvExternalOrders Is Nothing Then Return
            Dim colName = dgvExternalOrders.Columns(e.ColumnIndex).Name
            If Not String.Equals(colName, "Open", StringComparison.OrdinalIgnoreCase) Then Return
            Try
                Dim poIdObj = dgvExternalOrders.Rows(e.RowIndex).Cells("PurchaseOrderID").Value
                Dim poId As Integer = If(poIdObj Is Nothing OrElse poIdObj Is DBNull.Value, 0, Convert.ToInt32(poIdObj))
                If poId <= 0 Then Return
                Using f As New Purchasing.PurchaseOrderViewForm(poId)
                    f.ShowDialog(Me)
                End Using
            Catch
            End Try
        End Sub

    End Class
End Namespace
