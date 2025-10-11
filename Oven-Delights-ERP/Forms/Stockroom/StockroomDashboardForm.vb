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
        Private ReadOnly stockroomService As New StockroomService()
        Private currentBranchId As Integer
        Private isSuperAdmin As Boolean
        ' Embedded grid for Retail Orders in the "Reorders Due" tile
        Private dgvRetailOrders As DataGridView
        ' Embedded grid for External (PO) Orders in the "POs Pending" tile
        Private dgvExternalOrders As DataGridView
        ' Embedded grid for Manufacturer Pending counts
        Private dgvMfgPending As DataGridView
        ' Embedded grid for Stockroom Fulfilled queries
        Private dgvFulfilled As DataGridView
        Private blinkState As Boolean = False

        Public Sub New()
            ' Initialize branch and role info
            currentBranchId = stockroomService.GetCurrentUserBranchId()
            isSuperAdmin = stockroomService.IsCurrentUserSuperAdmin()

            Me.Text = "Stockroom - Dashboard"
            Me.Name = "StockroomDashboardForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.White
            Me.Font = New Font("Segoe UI", 9.0F, FontStyle.Regular, GraphicsUnit.Point)
            Me.Size = New Size(1000, 680)

            ' Set header text with branch info
            If isSuperAdmin Then
                header.Text = "Stockroom Overview - All Branches"
            Else
                Dim branchName As String = GetBranchName(currentBranchId)
                header.Text = $"Stockroom Overview - {branchName}"
            End If
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
            pnlGrid.RowCount = 3
            pnlGrid.Location = New Point(20, 60)
            pnlGrid.Size = New Size(950, 520)
            pnlGrid.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
            pnlGrid.ColumnStyles.Clear()
            pnlGrid.RowStyles.Clear()
            For i = 1 To 3
                pnlGrid.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 33.33F))
            Next
            For i = 1 To 3
                pnlGrid.RowStyles.Add(New RowStyle(SizeType.Percent, 33.33F))
            Next

            pnlGrid.Controls.Add(CreateTile("Reorders Due", "--", "Internal BOM picks"), 0, 0)
            pnlGrid.Controls.Add(CreateTile("POs Pending", "--", "External reorders"), 1, 0)
            pnlGrid.Controls.Add(CreateTile("Receipts Today", "--", "GRN count"), 2, 0)
            pnlGrid.Controls.Add(CreateTile("Issues to MFG", "--", "Components issued"), 0, 1)
            pnlGrid.Controls.Add(CreateTile("In-Transit", "--", "Transfers"), 1, 1)
            pnlGrid.Controls.Add(CreateTile("Manufacturer Pending Queries", "--", "By Manufacturer"), 2, 1)
            pnlGrid.Controls.Add(CreateTile("Stockroom Fulfilled Queries", "--", "Stockroom"), 0, 2)
            ' New: Inter-Branch Pending Requests tile with click to open Requests List
            pnlGrid.Controls.Add(CreateActionTile("Pending Branch Requests", "Click to open Requests List", AddressOf OpenInterBranchRequestsList), 1, 2)
            ' New: Cross-Branch Stock Lookup tile
            pnlGrid.Controls.Add(CreateActionTile("Cross-Branch Lookup", "Find stock across branches", AddressOf OpenCrossBranchLookup), 2, 2)

            Controls.Add(header)
            Controls.Add(btnClose)
            Controls.Add(pnlGrid)

            AddHandler Me.Shown, Sub()
                                     LoadKpisSafely()
                                     LoadRetailOrdersGridSafely()
                                     LoadExternalOrdersGridSafely()
                                     LoadMfgPendingGridSafely()
                                     LoadFulfilledGridSafely()
                                 End Sub

            ' constructor continues below to finish UI initialization

            ' (method moved below constructor)

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
                                              blinkState = Not blinkState
                                              LoadKpisSafely()
                                              LoadRetailOrdersGridSafely()
                                              LoadExternalOrdersGridSafely()
                                              LoadMfgPendingGridSafely()
                                              LoadFulfilledGridSafely()
                                          End Sub
            refreshTimer.Interval = GetRefreshIntervalFromConfig()
            ' Do not auto-start; prevent timer-driven resets while navigating
            refreshTimer.Stop()

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

        Private Sub OpenInterBranchRequestsList()
            Try
                Using f As New InterBranchRequestsListForm()
                    f.ShowDialog(Me)
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, "Failed to open Inter-Branch Requests: " & ex.Message, "Stockroom Dashboard", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OpenCrossBranchLookup()
            Try
                Using f As New CrossBranchLookupForm()
                    f.ShowDialog(Me)
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, "Failed to open Cross-Branch Lookup: " & ex.Message, "Stockroom Dashboard", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OpenStockroomFulfillWithSelection(internalOrderId As Integer)
            Try
                Using f As New InternalOrdersForm(internalOrderId)
                    f.ShowDialog(Me)
                End Using
                ' Refresh all tiles and embedded grids after possible changes
                RefreshData()
            Catch ex As Exception
                MessageBox.Show(Me, "Failed to open Internal Orders: " & ex.Message, "Stockroom Dashboard", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
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
            ' No-op to keep timer disabled for immediate navigation experience
        End Sub

        Private Function CreateTile(title As String, valueText As String, subtitle As String) As Control
            Dim panel As New Panel()
            panel.Margin = New Padding(8)
            panel.Padding = New Padding(16)
            panel.BackColor = Color.FromArgb(248, 249, 250) ' subtle light background
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

            ' If this is the Reorders Due tile, embed a grid of Internal Orders (Open/Issued) under the subtitle
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
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "InternalOrderNo", .HeaderText = "Order #", .FillWeight = 22})
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "RequestedBy", .HeaderText = "Requested By", .FillWeight = 24})
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Status", .HeaderText = "Status", .FillWeight = 12})
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Requested", .HeaderText = "Requested (Local)", .FillWeight = 20})
                Dim btnOpen As New DataGridViewButtonColumn() With {.Name = "Open", .HeaderText = "Open", .Text = "Open", .UseColumnTextForButtonValue = True, .FillWeight = 8}
                Dim btnChange As New DataGridViewButtonColumn() With {.Name = "ChangeMfg", .HeaderText = "Change Mfg", .Text = "Change", .UseColumnTextForButtonValue = True, .FillWeight = 10}
                dgvRetailOrders.Columns.Add(btnOpen)
                dgvRetailOrders.Columns.Add(btnChange)
                ' Hidden technical column
                dgvRetailOrders.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "InternalOrderID", .HeaderText = "InternalOrderID", .Visible = False})
                AddHandler dgvRetailOrders.CellClick, AddressOf OnRetailOrdersCellClick
                panel.Controls.Add(dgvRetailOrders)
            ElseIf String.Equals(title, "Mfg Pending", StringComparison.OrdinalIgnoreCase) OrElse String.Equals(title, "Manufacturer Pending Queries", StringComparison.OrdinalIgnoreCase) Then
                dgvMfgPending = New DataGridView()
                dgvMfgPending.AllowUserToAddRows = False
                dgvMfgPending.AllowUserToDeleteRows = False
                dgvMfgPending.ReadOnly = True
                dgvMfgPending.SelectionMode = DataGridViewSelectionMode.FullRowSelect
                dgvMfgPending.MultiSelect = False
                dgvMfgPending.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
                dgvMfgPending.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
                dgvMfgPending.Location = New Point(12, 108)
                dgvMfgPending.Size = New Size(panel.ClientSize.Width - 24, panel.ClientSize.Height - 120)
                AddHandler panel.Resize, Sub()
                                             dgvMfgPending.Size = New Size(panel.ClientSize.Width - 24, panel.ClientSize.Height - 120)
                                         End Sub

                dgvMfgPending.Columns.Clear()
                dgvMfgPending.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ManufacturerUserID", .HeaderText = "UserID", .FillWeight = 12})
                dgvMfgPending.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ManufacturerName", .HeaderText = "Manufacturer", .FillWeight = 48})
                dgvMfgPending.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "PendingCount", .HeaderText = "Pending", .FillWeight = 20})
                Dim btnView As New DataGridViewButtonColumn() With {.Name = "View", .HeaderText = "Open List", .Text = "Open", .UseColumnTextForButtonValue = True, .FillWeight = 20}
                dgvMfgPending.Columns.Add(btnView)

                AddHandler dgvMfgPending.CellClick, AddressOf OnMfgPendingCellClick
                AddHandler dgvMfgPending.CellDoubleClick, AddressOf OnMfgPendingCellDoubleClick

                panel.Controls.Add(dgvMfgPending)
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
            ElseIf String.Equals(title, "Fulfilled Queries", StringComparison.OrdinalIgnoreCase) OrElse String.Equals(title, "Stockroom Fulfilled Queries", StringComparison.OrdinalIgnoreCase) Then
                dgvFulfilled = New DataGridView()
                dgvFulfilled.AllowUserToAddRows = False
                dgvFulfilled.AllowUserToDeleteRows = False
                dgvFulfilled.ReadOnly = True
                dgvFulfilled.SelectionMode = DataGridViewSelectionMode.FullRowSelect
                dgvFulfilled.MultiSelect = False
                dgvFulfilled.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
                dgvFulfilled.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
                dgvFulfilled.Location = New Point(12, 108)
                dgvFulfilled.Size = New Size(panel.ClientSize.Width - 24, panel.ClientSize.Height - 120)
                AddHandler panel.Resize, Sub()
                                             dgvFulfilled.Size = New Size(panel.ClientSize.Width - 24, panel.ClientSize.Height - 120)
                                         End Sub

                dgvFulfilled.Columns.Clear()
                dgvFulfilled.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "InternalOrderNo", .HeaderText = "Order #", .FillWeight = 22})
                dgvFulfilled.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Manufacturer", .HeaderText = "Manufacturer", .FillWeight = 26})
                dgvFulfilled.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Status", .HeaderText = "Status", .FillWeight = 12})
                dgvFulfilled.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Updated", .HeaderText = "Updated (Local)", .FillWeight = 20})
                Dim btnOpenFul As New DataGridViewButtonColumn() With {.Name = "Open", .HeaderText = "Open", .Text = "Open", .UseColumnTextForButtonValue = True, .FillWeight = 10}
                dgvFulfilled.Columns.Add(btnOpenFul)
                dgvFulfilled.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "InternalOrderID", .HeaderText = "InternalOrderID", .Visible = False})
                AddHandler dgvFulfilled.CellClick, Sub(s As Object, ev As DataGridViewCellEventArgs)
                                                       If ev.RowIndex < 0 Then Return
                                                       If String.Equals(dgvFulfilled.Columns(ev.ColumnIndex).Name, "Open", StringComparison.OrdinalIgnoreCase) Then
                                                           Dim ioId As Integer = 0
                                                           Dim v = dgvFulfilled.Rows(ev.RowIndex).Cells("InternalOrderID").Value
                                                           If v IsNot Nothing AndAlso v IsNot DBNull.Value Then ioId = Convert.ToInt32(v)
                                                           OpenStockroomFulfillWithSelection(ioId)
                                                       End If
                                                   End Sub
                panel.Controls.Add(dgvFulfilled)
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

        Private Function GetBranchName(branchId As Integer) As String
            Try
                Return "Branch " & branchId.ToString()
            Catch
                Return "Unknown Branch"
            End Try
        End Function

        ' Lightweight action tile with a title and subtitle that invokes a zero-argument action on click.
        ' Accepts an Action delegate so callers can pass AddressOf SomeSub with no parameters.
        Private Function CreateActionTile(title As String, subtitle As String, clickAction As System.Action) As Control
            Dim panel As New Panel()
            panel.Margin = New Padding(8)
            panel.Padding = New Padding(16)
            panel.BackColor = Color.FromArgb(240, 245, 255) ' slightly tinted to indicate click target
            panel.BorderStyle = BorderStyle.FixedSingle
            panel.Dock = DockStyle.Fill

            Dim lblTitle As New Label() With {
                .Text = title,
                .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold),
                .AutoSize = True,
                .Location = New Point(8, 8)
            }
            Dim lblSub As New Label() With {
                .Text = subtitle,
                .Font = New Font("Segoe UI", 9.0F, FontStyle.Regular),
                .AutoSize = True,
                .ForeColor = Color.DimGray,
                .Location = New Point(8, 34)
            }

            panel.Controls.Add(lblTitle)
            panel.Controls.Add(lblSub)

            ' Wire click on panel and labels to the provided action using a lambda to match EventHandler signature
            Dim handler As EventHandler = Sub(sender, e)
                                              If clickAction IsNot Nothing Then clickAction()
                                          End Sub
            AddHandler panel.Click, handler
            AddHandler lblTitle.Click, handler
            AddHandler lblSub.Click, handler

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

        ' Load manufacturer pending counts and apply flashing color when PendingCount > 0
        Private Sub LoadMfgPendingGrid()
            If dgvMfgPending Is Nothing Then Return
            dgvMfgPending.Rows.Clear()
            Dim totalPending As Integer = 0

            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Using cmd As New SqlCommand("SELECT bts.ManufacturerUserID, ISNULL(bts.ManufacturerName, N'Unassigned') AS ManufacturerName, COUNT(1) AS PendingCount " &
                                                "FROM dbo.BomTaskStatus bts " &
                                                "JOIN dbo.InternalOrderHeader IOH ON IOH.InternalOrderID = bts.InternalOrderID " &
                                                "JOIN dbo.InventoryLocations locTo ON locTo.LocationID = IOH.ToLocationID " &
                                                "WHERE bts.Status = N'Pending' AND (locTo.BranchID=@b OR @b IS NULL) " &
                                                "GROUP BY bts.ManufacturerUserID, ISNULL(bts.ManufacturerName, N'Unassigned') " &
                                                "ORDER BY PendingCount DESC;", cn)
                        cmd.Parameters.AddWithValue("@b", AppSession.CurrentBranchID)
                        Using r = cmd.ExecuteReader()
                            While r.Read()
                                Dim uid As Object = If(IsDBNull(r("ManufacturerUserID")), Nothing, r("ManufacturerUserID"))
                                Dim name As String = If(IsDBNull(r("ManufacturerName")), "Unassigned", Convert.ToString(r("ManufacturerName")))
                                Dim cnt As Integer = If(IsDBNull(r("PendingCount")), 0, Convert.ToInt32(r("PendingCount")))
                                Dim rowIndex = dgvMfgPending.Rows.Add(If(uid Is Nothing, Nothing, Convert.ToInt32(uid)), name, cnt, "Open")
                                Dim row = dgvMfgPending.Rows(rowIndex)
                                totalPending += cnt
                                ' Flash manufacturer name when pending > 0
                                If cnt > 0 Then
                                    row.Cells("ManufacturerName").Style.ForeColor = If(blinkState, Color.Firebrick, Color.Black)
                                Else
                                    row.Cells("ManufacturerName").Style.ForeColor = Color.Black
                                End If
                            End While
                        End Using
                    End Using
                End Using
            Catch
            End Try
            ' Update the tile numeric value
            Try
                SetTileValue("Manufacturer Pending Queries", totalPending.ToString())
            Catch
            End Try
        End Sub

        Private Sub OnMfgPendingCellClick(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex < 0 OrElse dgvMfgPending Is Nothing Then Return
            Dim colName = dgvMfgPending.Columns(e.ColumnIndex).Name
            If Not String.Equals(colName, "View", StringComparison.OrdinalIgnoreCase) Then Return
            OpenPendingListForSelectedManufacturer(e.RowIndex)
        End Sub

        Private Sub OnMfgPendingCellDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex < 0 OrElse dgvMfgPending Is Nothing Then Return
            OpenPendingListForSelectedManufacturer(e.RowIndex)
        End Sub

        Private Sub OpenPendingListForSelectedManufacturer(rowIndex As Integer)
            Try
                Dim uidObj = dgvMfgPending.Rows(rowIndex).Cells("ManufacturerUserID").Value
                Dim name As String = Convert.ToString(dgvMfgPending.Rows(rowIndex).Cells("ManufacturerName").Value)
                Dim uid As Integer = 0
                If uidObj IsNot Nothing AndAlso uidObj IsNot DBNull.Value Then
                    Integer.TryParse(uidObj.ToString(), uid)
                End If

                ' Build a simple form with a grid listing pending BOMs for this manufacturer
                Dim dlg As New Form()
                dlg.Text = $"Pending BOMs - {name}"
                dlg.StartPosition = FormStartPosition.CenterParent
                dlg.Size = New Size(760, 480)
                Dim grid As New DataGridView()
                grid.Dock = DockStyle.Fill
                grid.ReadOnly = True
                grid.SelectionMode = DataGridViewSelectionMode.FullRowSelect
                grid.MultiSelect = False
                grid.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
                grid.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "InternalOrderID", .HeaderText = "BOM #", .FillWeight = 18})
                grid.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Status", .HeaderText = "Status", .FillWeight = 12})
                grid.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Updated", .HeaderText = "Updated (Local)", .FillWeight = 26})
                grid.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ManufacturerName", .HeaderText = "Manufacturer", .FillWeight = 24})
                Dim btnOpen As New DataGridViewButtonColumn() With {.Name = "Open", .HeaderText = "Open", .Text = "Open", .UseColumnTextForButtonValue = True, .FillWeight = 10}
                grid.Columns.Add(btnOpen)

                AddHandler grid.CellClick, Sub(s, ev)
                                               If ev.RowIndex >= 0 AndAlso String.Equals(grid.Columns(ev.ColumnIndex).Name, "Open", StringComparison.OrdinalIgnoreCase) Then
                                                   Dim ioId = Convert.ToInt32(grid.Rows(ev.RowIndex).Cells("InternalOrderID").Value)
                                                   OpenStockroomFulfillWithSelection(ioId)
                                                   dlg.Close()
                                               End If
                                           End Sub
                AddHandler grid.CellDoubleClick, Sub(s, ev)
                                                     If ev.RowIndex >= 0 Then
                                                         Dim ioId = Convert.ToInt32(grid.Rows(ev.RowIndex).Cells("InternalOrderID").Value)
                                                         OpenStockroomFulfillWithSelection(ioId)
                                                         dlg.Close()
                                                     End If
                                                 End Sub

                dlg.Controls.Add(grid)

                ' Load data
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim sql As String
                    If uid > 0 Then
                        sql = "SELECT bts.InternalOrderID, bts.ManufacturerName, bts.Status, bts.UpdatedAtUtc " &
                              "FROM dbo.BomTaskStatus bts " &
                              "JOIN dbo.InternalOrderHeader IOH ON IOH.InternalOrderID=bts.InternalOrderID " &
                              "JOIN dbo.InventoryLocations locTo ON locTo.LocationID = IOH.ToLocationID " &
                              "WHERE bts.Status=N'Pending' AND bts.ManufacturerUserID=@u AND (locTo.BranchID=@b OR @b IS NULL) ORDER BY bts.UpdatedAtUtc DESC;"
                    Else
                        sql = "SELECT bts.InternalOrderID, bts.ManufacturerName, bts.Status, bts.UpdatedAtUtc " &
                              "FROM dbo.BomTaskStatus bts " &
                              "JOIN dbo.InternalOrderHeader IOH ON IOH.InternalOrderID=bts.InternalOrderID " &
                              "JOIN dbo.InventoryLocations locTo ON locTo.LocationID = IOH.ToLocationID " &
                              "WHERE bts.Status=N'Pending' AND bts.ManufacturerUserID IS NULL AND (locTo.BranchID=@b OR @b IS NULL) ORDER BY bts.UpdatedAtUtc DESC;"
                    End If
                    Using cmd As New SqlCommand(sql, cn)
                        If uid > 0 Then cmd.Parameters.AddWithValue("@u", uid)
                        cmd.Parameters.AddWithValue("@b", AppSession.CurrentBranchID)
                        Using r = cmd.ExecuteReader()
                            While r.Read()
                                Dim ioId As Integer = If(IsDBNull(r("InternalOrderID")), 0, Convert.ToInt32(r("InternalOrderID")))
                                Dim st As String = If(IsDBNull(r("Status")), "Pending", Convert.ToString(r("Status")))
                                Dim nm As String = If(IsDBNull(r("ManufacturerName")), "Unassigned", Convert.ToString(r("ManufacturerName")))
                                Dim updLocal As String = ""
                                If Not IsDBNull(r("UpdatedAtUtc")) Then
                                    Dim utc As DateTime = DateTime.SpecifyKind(Convert.ToDateTime(r("UpdatedAtUtc")), DateTimeKind.Utc)
                                    updLocal = utc.ToLocalTime().ToString("yyyy-MM-dd HH:mm")
                                End If
                                grid.Rows.Add(ioId, st, updLocal, nm, "Open")
                            End While
                        End Using
                    End Using
                End Using

                dlg.ShowDialog(Me)
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
                    ' Resolve locations to match KPI count
                    Dim stockLoc As Integer = 0, mfgLoc As Integer = 0
                    Using cmdLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'STOCKROOM') AS StockLoc, dbo.fn_GetLocationId(@b, N'MFG') AS MfgLoc;", cn)
                        cmdLoc.Parameters.AddWithValue("@b", branchId)
                        Using rl = cmdLoc.ExecuteReader()
                            If rl.Read() Then
                                stockLoc = If(IsDBNull(rl("StockLoc")), 0, Convert.ToInt32(rl("StockLoc")))
                                mfgLoc = If(IsDBNull(rl("MfgLoc")), 0, Convert.ToInt32(rl("MfgLoc")))
                            End If
                        End Using
                    End Using
                    If stockLoc = 0 OrElse mfgLoc = 0 Then Return
                    Using cmd As New SqlCommand("SELECT IOH.InternalOrderID, IOH.InternalOrderNo, IOH.Status, IOH.RequestedDate, ISNULL(IOH.Notes,N'') AS Notes, " &
                                                  "       COALESCE(u.FirstName + ' ' + u.LastName, N'-') AS RequestedByName, " &
                                                  "       bts.Status AS EffStatus " &
                                                  "FROM dbo.InternalOrderHeader IOH " &
                                                  "LEFT JOIN dbo.BomTaskStatus bts ON bts.InternalOrderID = IOH.InternalOrderID " &
                                                  "LEFT JOIN dbo.Users u ON u.UserID = IOH.RequestedBy " &
                                                  "WHERE IOH.FromLocationID=@fromLoc AND IOH.ToLocationID=@toLoc " &
                                                  "  AND ISNULL(IOH.Status,'') IN (N'Open', N'Issued') " &
                                                  "ORDER BY IOH.InternalOrderID DESC;", cn)
                        cmd.Parameters.AddWithValue("@fromLoc", stockLoc)
                        cmd.Parameters.AddWithValue("@toLoc", mfgLoc)
                        Using r = cmd.ExecuteReader()
                            While r.Read()
                                Dim reqDtLocal As String = ""
                                If Not (r("RequestedDate") Is DBNull.Value) Then
                                    Dim d As DateTime = Convert.ToDateTime(r("RequestedDate"))
                                    Dim dl As DateTime = DateTime.SpecifyKind(d, DateTimeKind.Utc).ToLocalTime()
                                    reqDtLocal = dl.ToString("yyyy-MM-dd HH:mm")
                                End If
                                Dim effStatus As String = Convert.ToString(r("EffStatus"))
                                Dim statusText As String = If(String.Equals(effStatus, "Completed", StringComparison.OrdinalIgnoreCase), "Completed", "Pending")
                                dgvRetailOrders.Rows.Add(New Object() {
                                    Convert.ToString(r("InternalOrderNo")),
                                    Convert.ToString(r("RequestedByName")),
                                    statusText,
                                    reqDtLocal,
                                    "Open",
                                    "Change",
                                    Convert.ToInt32(r("InternalOrderID"))
                                })
                            End While
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, "Failed to load Internal Orders: " & ex.Message, "Stockroom Dashboard", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
                ' Open the Stockroom fulfill view with the selected Internal Order preselected
                Dim ioId As Integer = 0
                Dim v As Object = dgvRetailOrders.Rows(e.RowIndex).Cells("InternalOrderID").Value
                If v IsNot Nothing AndAlso v IsNot DBNull.Value Then ioId = Convert.ToInt32(v)
                OpenStockroomFulfillWithSelection(ioId)
            ElseIf colName = "ChangeMfg" Then
                Dim ioId As Integer = 0
                Dim v As Object = dgvRetailOrders.Rows(e.RowIndex).Cells("InternalOrderID").Value
                If v IsNot Nothing AndAlso v IsNot DBNull.Value Then ioId = Convert.ToInt32(v)
                If ioId <= 0 Then Return
                Using dlg As New SelectManufacturerDialog()
                    If dlg.ShowDialog(Me) = DialogResult.OK AndAlso dlg.SelectedUserId > 0 Then
                        Try
                            UpdateManufacturerOnInternalOrder(ioId, dlg.SelectedUserId, dlg.SelectedUserName)
                            ' Reflect across all tiles and grids immediately
                            RefreshData()
                        Catch ex As Exception
                            MessageBox.Show(Me, "Failed to assign manufacturer: " & ex.Message, "Stockroom Dashboard", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        End Try
                    End If
                End Using
            End If
        End Sub

        Private Sub UpdateManufacturerOnInternalOrder(ioId As Integer, userId As Integer, userName As String)
            Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Using cn As New SqlConnection(cs)
                cn.Open()
                Dim notes As String = ""
                Dim ioStatus As String = Nothing
                Using cmdR As New SqlCommand("SELECT ISNULL(Notes,'') AS Notes, ISNULL(Status,N'Open') AS Status FROM dbo.InternalOrderHeader WHERE InternalOrderID=@id", cn)
                    cmdR.Parameters.AddWithValue("@id", ioId)
                    Using r = cmdR.ExecuteReader()
                        If r.Read() Then
                            notes = If(IsDBNull(r("Notes")), String.Empty, Convert.ToString(r("Notes")))
                            ioStatus = If(IsDBNull(r("Status")), "Open", Convert.ToString(r("Status")))
                        End If
                    End Using
                End Using
                notes = UpsertNotesToken(notes, "ManufacturerUserID=", userId.ToString())
                notes = UpsertNotesToken(notes, "ManufacturerName=", userName)
                Using cmdU As New SqlCommand("UPDATE dbo.InternalOrderHeader SET Notes=@n WHERE InternalOrderID=@id", cn)
                    cmdU.Parameters.AddWithValue("@n", notes)
                    cmdU.Parameters.AddWithValue("@id", ioId)
                    cmdU.ExecuteNonQuery()
                End Using
                ' Upsert BomTaskStatus with current mapped status and manufacturer (ID + Name)
                Dim mapped As String = "Created"
                If String.Equals(ioStatus, "Issued", StringComparison.OrdinalIgnoreCase) Then mapped = "Fulfilled"
                If String.Equals(ioStatus, "Completed", StringComparison.OrdinalIgnoreCase) Then mapped = "Completed"
                Using cmdS As New SqlCommand("IF EXISTS(SELECT 1 FROM dbo.BomTaskStatus WHERE InternalOrderID=@id) " &
                                             "UPDATE dbo.BomTaskStatus SET ManufacturerUserID=@m, ManufacturerName=@n, Status=@s WHERE InternalOrderID=@id " &
                                             "ELSE INSERT INTO dbo.BomTaskStatus(InternalOrderID, ManufacturerUserID, ManufacturerName, Status) VALUES(@id, @m, @n, @s);", cn)
                    cmdS.Parameters.AddWithValue("@id", ioId)
                    cmdS.Parameters.AddWithValue("@m", userId)
                    cmdS.Parameters.AddWithValue("@n", If(userName, String.Empty))
                    cmdS.Parameters.AddWithValue("@s", mapped)
                    Try : cmdS.ExecuteNonQuery() : Catch : End Try
                End Using
            End Using
        End Sub

        Private Function UpsertNotesToken(notes As String, key As String, value As String) As String
            If notes Is Nothing Then notes = String.Empty
            Dim idx As Integer = notes.IndexOf(key, StringComparison.OrdinalIgnoreCase)
            If idx < 0 Then
                If notes.Length > 0 AndAlso Not notes.EndsWith(";") Then notes &= ";"
                Return notes & key & value
            End If
            ' Replace existing token until next semicolon or end
            Dim endIdx As Integer = notes.IndexOf(";"c, idx)
            If endIdx < 0 Then endIdx = notes.Length
            Dim before As String = notes.Substring(0, idx)
            Dim after As String = notes.Substring(endIdx)
            Return before & key & value & after
        End Function

        Private NotInheritable Class SelectManufacturerDialog
            Inherits Form
            Private ReadOnly _grid As New DataGridView()
            Private ReadOnly _ok As New Button()
            Private ReadOnly _cancel As New Button()
            Public Property SelectedUserId As Integer
            Public Property SelectedUserName As String

            Public Sub New()
                Me.Text = "Select Manufacturer"
                Me.Width = 520
                Me.Height = 420
                Me.StartPosition = FormStartPosition.CenterParent
                _grid.AllowUserToAddRows = False
                _grid.AllowUserToDeleteRows = False
                _grid.ReadOnly = True
                _grid.SelectionMode = DataGridViewSelectionMode.FullRowSelect
                _grid.MultiSelect = False
                _grid.Dock = DockStyle.Top
                _grid.Height = 330
                _grid.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "UserID", .HeaderText = "ID", .Width = 60})
                _grid.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "FullName", .HeaderText = "Name", .AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill})

                _ok.Text = "OK"
                _ok.Width = 100
                _ok.Top = 340
                _ok.Left = 280
                AddHandler _ok.Click, Sub()
                                          If _grid.CurrentRow Is Nothing Then Return
                                          Dim uid As Integer = Convert.ToInt32(_grid.CurrentRow.Cells("UserID").Value)
                                          Dim nm As String = Convert.ToString(_grid.CurrentRow.Cells("FullName").Value)
                                          SelectedUserId = uid
                                          SelectedUserName = nm
                                          Me.DialogResult = DialogResult.OK
                                      End Sub

                _cancel.Text = "Cancel"
                _cancel.Width = 100
                _cancel.Top = 340
                _cancel.Left = 390
                AddHandler _cancel.Click, Sub()
                                              Me.DialogResult = DialogResult.Cancel
                                          End Sub

                Me.Controls.Add(_grid)
                Me.Controls.Add(_ok)
                Me.Controls.Add(_cancel)

                LoadManufacturers()
            End Sub

            Private Sub LoadManufacturers()
                Try
                    Using cn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                        cn.Open()
                        Using cmd As New SqlCommand("SELECT u.UserID, (u.FirstName + ' ' + u.LastName) AS FullName FROM dbo.Users u JOIN dbo.Roles r ON r.RoleID = u.RoleID WHERE r.RoleName IN (N'Manufacturing-Manager', N'MM', N'Manufacturer') OR r.RoleName LIKE N'Manufactur%' ORDER BY FullName;", cn)
                            Using r = cmd.ExecuteReader()
                                While r.Read()
                                    _grid.Rows.Add(New Object() {Convert.ToInt32(r("UserID")), Convert.ToString(r("FullName"))})
                                End While
                            End Using
                        End Using
                    End Using
                Catch
                End Try
            End Sub

        End Class

        Private Sub UpsertRetailOrdersToday(productId As Integer, orderNumber As String, sku As String, productName As String, qty As Decimal, manufacturerUserId As Integer, manufacturerName As String)
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Dim branchId As Integer = currentBranchId
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
            LoadExternalOrdersGridSafely()
            LoadMfgPendingGridSafely()
            LoadFulfilledGridSafely()
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
                    Using cmd As New SqlCommand("SELECT COUNT(1) " &
                                                "FROM dbo.InternalOrderHeader IOH " &
                                                "WHERE IOH.FromLocationID=@fromLoc AND IOH.ToLocationID=@toLoc " &
                                                "  AND ISNULL(IOH.Status,'') IN (N'Open', N'Issued');", cn)
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

        Private Sub LoadMfgPendingGridSafely()
            Try
                LoadMfgPendingGrid()
            Catch
            End Try
        End Sub

        Private Sub LoadFulfilledGridSafely()
            Try
                LoadFulfilledGrid()
            Catch
            End Try
        End Sub

        ' Load fulfilled/completed internal BOMs for Stockroom->MFG
        Private Sub LoadFulfilledGrid()
            If dgvFulfilled Is Nothing Then Return
            dgvFulfilled.Rows.Clear()
            Dim total As Integer = 0
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Dim branchId As Integer = AppSession.CurrentBranchID
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim stockLoc As Integer = 0, mfgLoc As Integer = 0
                    Using cmdLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'STOCKROOM') AS StockLoc, dbo.fn_GetLocationId(@b, N'MFG') AS MfgLoc;", cn)
                        cmdLoc.Parameters.AddWithValue("@b", branchId)
                        Using rl = cmdLoc.ExecuteReader()
                            If rl.Read() Then
                                stockLoc = If(IsDBNull(rl("StockLoc")), 0, Convert.ToInt32(rl("StockLoc")))
                                mfgLoc = If(IsDBNull(rl("MfgLoc")), 0, Convert.ToInt32(rl("MfgLoc")))
                            End If
                        End Using
                    End Using
                    If stockLoc = 0 OrElse mfgLoc = 0 Then Return
                    Using cmd As New SqlCommand("SELECT IOH.InternalOrderID, IOH.InternalOrderNo, ISNULL(bts.ManufacturerName,N'Unassigned') AS Manufacturer, bts.Status " &
                                              "FROM dbo.InternalOrderHeader IOH " &
                                              "JOIN dbo.BomTaskStatus bts ON bts.InternalOrderID = IOH.InternalOrderID " &
                                              "WHERE IOH.FromLocationID=@fromLoc AND IOH.ToLocationID=@toLoc " &
                                              "  AND IOH.Status = N'Completed' " &
                                              "  AND bts.Status = N'Pending' " &
                                              "ORDER BY IOH.InternalOrderID DESC;", cn)
                        cmd.Parameters.AddWithValue("@fromLoc", stockLoc)
                        cmd.Parameters.AddWithValue("@toLoc", mfgLoc)
                        Using r = cmd.ExecuteReader()
                            While r.Read()
                                Dim updatedLocal As String = ""
                                dgvFulfilled.Rows.Add(New Object() {
                                    Convert.ToString(r("InternalOrderNo")),
                                    Convert.ToString(r("Manufacturer")),
                                    Convert.ToString(r("Status")),
                                    updatedLocal,
                                    "Open",
                                    Convert.ToInt32(r("InternalOrderID"))
                                })
                                total += 1
                            End While
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, "Failed to load Fulfilled queries: " & ex.Message, "Stockroom Dashboard", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Finally
                SetTileValue("Stockroom Fulfilled Queries", total.ToString())
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
                    Using cmd As New SqlCommand("SELECT OrderNumber, SKU, ProductName, COALESCE(InternalOrderID, 0) AS InternalOrderID FROM dbo.DailyOrderBook WHERE BookDate=@d AND BranchID=@b ORDER BY CreatedAtUtc DESC;", cn)
                        cmd.Parameters.AddWithValue("@d", TimeProvider.Today())
                        cmd.Parameters.AddWithValue("@b", AppSession.CurrentBranchID)
                        Using r = cmd.ExecuteReader()
                            While r.Read()
                                Dim orderNo As String = If(IsDBNull(r("OrderNumber")), String.Empty, Convert.ToString(r("OrderNumber")))
                                Dim sku As String = If(IsDBNull(r("SKU")), String.Empty, Convert.ToString(r("SKU")))
                                Dim prod As String = If(IsDBNull(r("ProductName")), String.Empty, Convert.ToString(r("ProductName")))
                                Dim ioId As Integer = If(IsDBNull(r("InternalOrderID")), 0, Convert.ToInt32(r("InternalOrderID")))
                                dgvExternalOrders.Rows.Add(orderNo, sku, prod, ioId, "Open")
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
                ' After closing PO view, refresh all tiles/grids so counts reflect any changes
                RefreshData()
            Catch
            End Try
        End Sub

    End Class
End Namespace
