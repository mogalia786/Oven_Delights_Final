' Touch-first Producer Dashboard with live clock and color tiles
Imports System
Imports System.Data
Imports System.Drawing
Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
 

Namespace Manufacturing
    Public Class UserDashboardForm
        Inherits Form

        Private flow As New FlowLayoutPanel()
        Private lblClock As New Label()
        Private lblBlueTick As New Label()
        Private refreshTimer As New Timer()
        ' Removed chart to simplify dashboard and avoid runtime issues
        ' Flashing notification for urgent tasks per user
        Private ReadOnly blinkTimer As New Timer()
        Private blinkOn As Boolean = False
        Private flashingPanels As New Dictionary(Of Integer, Panel)()
        ' Track per-user base color and last urgent counts for change detection
        Private userBaseColors As New Dictionary(Of Integer, Color)()
        Private lastUrgentCounts As New Dictionary(Of Integer, Integer)()
        ' Bottom grid: pending BOMs for selected manufacturer
        Private dgvUserPending As New DataGridView()
        Private selectedUserId As Integer = 0
        Private selectedUserName As String = String.Empty
        ' Main split so we can adjust SplitterDistance safely post-initialization
        Private splitMain As SplitContainer
        ' DEBUG: populate dummy rows if query returns zero (for wiring test)
        Private Const DebugPopulateDummyOnEmpty As Boolean = False

        Public Sub New()
            Me.Text = "Manufacturers Order Book"
            Me.WindowState = FormWindowState.Maximized
            Me.BackColor = Color.White

            lblClock.Font = New Font("Segoe UI", 18, FontStyle.Bold)
            lblClock.AutoSize = True
            lblClock.Location = New Point(20, 15)
            UpdateClock()

            ' Blue tick indicator (top-right) to verify correct page/build
            lblBlueTick.AutoSize = True
            lblBlueTick.Text = "✓"
            lblBlueTick.ForeColor = Color.SteelBlue
            lblBlueTick.Font = New Font("Segoe UI", 14, FontStyle.Bold)
            lblBlueTick.Location = New Point(Me.ClientSize.Width - 40, 15)
            lblBlueTick.Anchor = AnchorStyles.Top Or AnchorStyles.Right
            Controls.Add(lblBlueTick)

            ' Header panel with title
            Dim header As New Panel()
            header.Dock = DockStyle.Top
            header.Height = 64
            header.BackColor = Color.White
            Dim lblTitle As New Label()
            lblTitle.Text = "Manufacturers Order Book"
            lblTitle.Font = New Font("Segoe UI", 22, FontStyle.Bold)
            lblTitle.AutoSize = True
            lblTitle.ForeColor = Color.FromArgb(30, 30, 30)
            lblTitle.Location = New Point(20, 16)
            header.Controls.Add(lblTitle)

            ' Split container: top = tiles, bottom = grid
            splitMain = New SplitContainer()
            splitMain.Orientation = Orientation.Horizontal
            splitMain.Dock = DockStyle.Fill
            splitMain.SplitterWidth = 6
            ' Do not enforce min sizes at construction time to avoid SplitterDistance exceptions
            splitMain.Panel1MinSize = 0
            splitMain.Panel2MinSize = 0

            ' Flow goes into top panel
            flow.Dock = DockStyle.Fill
            flow.Padding = New Padding(16)
            flow.AutoScroll = True
            flow.WrapContents = True
            splitMain.Panel1.Controls.Add(flow)

            ' Grid goes into bottom panel (fill)
            dgvUserPending.AllowUserToAddRows = False
            dgvUserPending.AllowUserToDeleteRows = False
            dgvUserPending.ReadOnly = True
            dgvUserPending.SelectionMode = DataGridViewSelectionMode.FullRowSelect
            dgvUserPending.MultiSelect = False
            dgvUserPending.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            dgvUserPending.Dock = DockStyle.Fill
            If dgvUserPending.Columns.Count = 0 Then
                dgvUserPending.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "InternalOrderNo", .HeaderText = "Order #", .FillWeight = 20})
                dgvUserPending.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Requested", .HeaderText = "Requested", .FillWeight = 18})
                dgvUserPending.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Product", .HeaderText = "Product", .FillWeight = 42})
                dgvUserPending.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Qty", .HeaderText = "Qty", .FillWeight = 10})
                dgvUserPending.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "InternalOrderID", .HeaderText = "InternalOrderID", .Visible = False})
            End If
            AddHandler dgvUserPending.CellDoubleClick, AddressOf OnPendingRowDoubleClick
            splitMain.Panel2.Controls.Add(dgvUserPending)

            ' Add to form in order: header (Top), split (Fill), then clock/tick
            Me.Controls.Add(splitMain)
            Me.Controls.Add(header)
            Me.Controls.Add(lblClock)
            Me.Controls.Add(lblBlueTick)
            PositionBlueTick()
            lblBlueTick.BringToFront()
            lblClock.BringToFront()
            ' Hide clock and blue tick per requirement: no timers/indicators on screen
            lblClock.Visible = False
            lblBlueTick.Visible = False

            ' Resize: keep blue tick positioned correctly and clamp splitter safely
            AddHandler Me.Resize, Sub()
                                       PositionBlueTick()
                                       lblBlueTick.BringToFront()
                                       SetSafeSplitterDistance()
                                   End Sub
            

            ' Initial load of tiles
            LoadTiles()

            ' (Bottom grid initialized above in splitMain)

            AddHandler refreshTimer.Tick, AddressOf OnTick
            refreshTimer.Interval = GetRefreshIntervalFromConfig()
            ' Do not auto-start refresh timer; keep disabled for immediate, stable UI
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
            ' After shown, set a safe splitter distance based on actual layout
            AddHandler Me.Shown, Sub() SetSafeSplitterDistance()
        
            ' No clock timer updates; keep visuals static and responsive

            ' Blink timer to visually notify urgent tasks (kept)
            AddHandler blinkTimer.Tick, AddressOf OnBlink
            blinkTimer.Interval = 700
        End Sub

        Private Sub OnProducerSelected(userId As Integer, name As String)
            selectedUserId = userId
            selectedUserName = name
            ' Prevent any periodic refresh from interrupting immediate navigation
            PauseRefresh()
            LoadPendingGridFor(userId, name)
            ' Bring attention to the grid
            dgvUserPending.BringToFront()
            dgvUserPending.Focus()
        End Sub

        Private Sub OnPendingRowDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
            If e Is Nothing OrElse e.RowIndex < 0 Then Return
            ' Open the exact BOM completion form for the selected Internal Order
            Try
                Dim row = dgvUserPending.Rows(e.RowIndex)
                Dim ioIdObj = row.Cells("InternalOrderID").Value
                Dim ioNoObj = row.Cells("InternalOrderNo").Value
                Dim ioId As Integer = 0
                Dim ioNo As String = If(ioNoObj Is Nothing, String.Empty, ioNoObj.ToString())
                If ioIdObj IsNot Nothing AndAlso Integer.TryParse(ioIdObj.ToString(), ioId) AndAlso ioId > 0 Then
                    Using frm As New BOMEditorForm()
                        ' Preselect the chosen Internal Order in the Completed BOM dropdown
                        frm.PreselectFulfilledInternalOrder(ioId, ioNo)
                        frm.SetMode("Complete")
                        frm.WindowState = FormWindowState.Maximized
                        frm.ShowDialog(Me)
                    End Using
                    ' Refresh tiles and bottom grid to reflect completed work
                    LoadTiles()
                    If Not String.IsNullOrWhiteSpace(selectedUserName) OrElse selectedUserId > 0 Then
                        LoadPendingGridFor(selectedUserId, selectedUserName)
                    End If
                End If
            Catch
                ' ignore; do not crash dashboard
            End Try
        End Sub
 
        Private Sub LoadPendingGridFor(userId As Integer, Optional manufacturerName As String = Nothing)
            Try
                EnsurePendingGridColumns()
                dgvUserPending.Rows.Clear()
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim branchId As Integer = AppSession.CurrentBranchID
                    ' Pull EXACTLY the same set as the tile count: Pending by branch and manufacturer
                    Dim sql As String = _
                        "SELECT v.InternalOrderID, v.InternalOrderNo, v.RequestedDate, v.Notes " & _
                        "FROM dbo.v_MfgPendingFromStockroom v " & _
                        "WHERE v.BranchID=@b AND (" & _
                        "       (@uid>0 AND v.ManufacturerUserID=@uid) " & _
                        "    OR (@uid=0 AND LTRIM(RTRIM(v.ManufacturerName)) COLLATE Latin1_General_CI_AI = LTRIM(RTRIM(@name)) COLLATE Latin1_General_CI_AI)" & _
                        ") ORDER BY v.RequestedDate DESC, v.InternalOrderID DESC;"
                    Using cmd As New SqlCommand(sql, cn)
                        cmd.Parameters.AddWithValue("@b", branchId)
                        cmd.Parameters.AddWithValue("@uid", userId)
                        cmd.Parameters.AddWithValue("@name", If(manufacturerName, String.Empty))
                        Dim added As Integer = 0
                        Using rdr = cmd.ExecuteReader()
                            While rdr.Read()
                                Dim ioId As Integer = If(rdr.IsDBNull(0), 0, rdr.GetInt32(0))
                                Dim ioNo As String = If(rdr.IsDBNull(1), String.Empty, rdr.GetString(1))
                                Dim req As DateTime = If(rdr.IsDBNull(2), DateTime.MinValue, rdr.GetDateTime(2))
                                Dim notes As String = If(rdr.IsDBNull(3), String.Empty, rdr.GetString(3))
                                Dim prodName As String = String.Empty
                                Dim qty As Decimal = 0D
                                Dim pid As Integer = 0
                                If TryParseFirstProductAndQty(notes, pid, qty) Then
                                    ' Resolve product name from Products table
                                    If pid > 0 Then
                                        Try
                                            Using cmdP As New SqlCommand("SELECT TOP 1 ProductName FROM dbo.Products WHERE ProductID=@pid", cn)
                                                cmdP.Parameters.AddWithValue("@pid", pid)
                                                Dim obj = cmdP.ExecuteScalar()
                                                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                                                    prodName = obj.ToString()
                                                Else
                                                    prodName = $"Product {pid}"
                                                End If
                                            End Using
                                        Catch
                                            prodName = $"Product {pid}"
                                        End Try
                                    End If
                                End If
                                Dim reqText As String = If(req = DateTime.MinValue, "", req.ToString("dd MMM yyyy HH:mm"))
                                Dim qtyText As String = If(qty > 0D, qty.ToString("0.####"), "")
                                dgvUserPending.Rows.Add(ioNo, reqText, prodName, qtyText, ioId)
                                added += 1
                            End While
                        End Using
                        ' DEBUG fallback: if no pending rows found, add dummy rows so UI can be tested
                        If added = 0 AndAlso DebugPopulateDummyOnEmpty Then
                            Dim nowText As String = DateTime.Now.ToString("dd MMM yyyy HH:mm")
                            For i As Integer = 1 To 3
                                dgvUserPending.Rows.Add($"TEST-{i:000}", nowText, $"TEST pending item {i}", "1", 0)
                            Next
                        End If
                    End Using
                End Using
                ' If still empty, add dummy rows for testing
                If DebugPopulateDummyOnEmpty AndAlso dgvUserPending.Rows.Count = 0 Then
                    AddDummyPendingRows()
                End If
                ' Select first row if any and ensure grid is in focus
                If dgvUserPending.Rows.Count > 0 Then
                    dgvUserPending.ClearSelection()
                    dgvUserPending.Rows(0).Selected = True
                End If
                dgvUserPending.BringToFront()
                dgvUserPending.Focus()
            Catch
                ' On any error, add dummy rows so wiring can be verified
                If DebugPopulateDummyOnEmpty Then
                    EnsurePendingGridColumns()
                    dgvUserPending.Rows.Clear()
                    AddDummyPendingRows()
                    dgvUserPending.BringToFront()
                    dgvUserPending.Focus()
                End If
            End Try
        End Sub

        Private Sub AddDummyPendingRows()
            Dim nowText As String = DateTime.Now.ToString("dd MMM yyyy HH:mm")
            For i As Integer = 1 To 3
                dgvUserPending.Rows.Add($"TEST-{i:000}", nowText, $"TEST pending item {i}", "1", 0)
            Next
        End Sub

        Private Sub EnsurePendingGridColumns()
            If dgvUserPending.Columns.Count >= 5 AndAlso dgvUserPending.Columns(0).Name = "InternalOrderNo" Then Return
            dgvUserPending.AutoGenerateColumns = False
            dgvUserPending.Columns.Clear()
            Dim colNo As New DataGridViewTextBoxColumn()
            colNo.Name = "InternalOrderNo"
            colNo.HeaderText = "Order #"
            colNo.Width = 120
            Dim colReq As New DataGridViewTextBoxColumn()
            colReq.Name = "Requested"
            colReq.HeaderText = "Requested"
            colReq.Width = 160
            Dim colProd As New DataGridViewTextBoxColumn()
            colProd.Name = "Product"
            colProd.HeaderText = "Product"
            colProd.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
            Dim colQty As New DataGridViewTextBoxColumn()
            colQty.Name = "Qty"
            colQty.HeaderText = "Qty"
            colQty.Width = 80
            Dim colId As New DataGridViewTextBoxColumn()
            colId.Name = "InternalOrderID"
            colId.HeaderText = "InternalOrderID"
            colId.Visible = False
            dgvUserPending.Columns.AddRange(New DataGridViewColumn() {colNo, colReq, colProd, colQty, colId})
        End Sub

        ' Return a short summary of the next task based on latest Pending BOM (BomTaskStatus).
        ' Prefer lookup by ManufacturerUserID; if not available, fallback by ManufacturerName.
        Private Function GetLatestTaskTextForUser(cn As SqlConnection, branchId As Integer, userId As Integer, Optional manufacturerName As String = Nothing) As String
            Try
                ' Find most recent pending InternalOrder for this manufacturer in this branch
                Dim ioId As Integer = 0
                Dim ioNo As String = Nothing
                If userId > 0 Then
                    Using cmd As New SqlCommand("SELECT TOP 1 v.InternalOrderID, v.InternalOrderNo " & _
                                                "FROM dbo.v_MfgPendingFromStockroom v " & _
                                                "WHERE v.BranchID=@b AND v.ManufacturerUserID=@uid " & _
                                                "ORDER BY v.RequestedDate DESC, v.InternalOrderID DESC;", cn)
                        cmd.Parameters.AddWithValue("@b", branchId)
                        cmd.Parameters.AddWithValue("@uid", userId)
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                ioId = If(r.IsDBNull(0), 0, Convert.ToInt32(r.GetValue(0)))
                                ioNo = If(r.IsDBNull(1), Nothing, Convert.ToString(r.GetValue(1)))
                            End If
                        End Using
                    End Using
                End If
                If ioId = 0 AndAlso Not String.IsNullOrWhiteSpace(manufacturerName) Then
                    Using cmd As New SqlCommand("SELECT TOP 1 v.InternalOrderID, v.InternalOrderNo " & _
                                                "FROM dbo.v_MfgPendingFromStockroom v " & _
                                                "WHERE v.BranchID=@b AND v.ManufacturerName=@nm " & _
                                                "ORDER BY v.RequestedDate DESC, v.InternalOrderID DESC;", cn)
                        cmd.Parameters.AddWithValue("@b", branchId)
                        cmd.Parameters.AddWithValue("@nm", manufacturerName)
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                ioId = If(r.IsDBNull(0), 0, Convert.ToInt32(r.GetValue(0)))
                                ioNo = If(r.IsDBNull(1), Nothing, Convert.ToString(r.GetValue(1)))
                            End If
                        End Using
                    End Using
                End If
                If ioId = 0 Then Return String.Empty

                ' Get first product line from that order
                Dim prodId As Integer = 0
                Dim qty As Decimal = 0D
                Using cmdL As New SqlCommand("SELECT TOP 1 IOL.ProductID, IOL.Quantity FROM dbo.InternalOrderLines IOL WHERE IOL.InternalOrderID=@id AND IOL.ProductID IS NOT NULL ORDER BY IOL.LineNumber ASC;", cn)
                    cmdL.Parameters.AddWithValue("@id", ioId)
                    Using r = cmdL.ExecuteReader()
                        If r.Read() Then
                            prodId = If(r.IsDBNull(0), 0, Convert.ToInt32(r.GetValue(0)))
                            qty = If(r.IsDBNull(1), 0D, Convert.ToDecimal(r.GetValue(1)))
                        End If
                    End Using
                End Using
                If prodId <= 0 Then
                    ' Fall back to order number if no product line captured yet
                    If Not String.IsNullOrWhiteSpace(ioNo) Then
                        Return $"Task: Order {ioNo}"
                    End If
                    Return String.Empty
                End If

                ' Resolve product name
                Dim prodName As String = Nothing
                Using cmdP As New SqlCommand("SELECT TOP 1 ProductName FROM dbo.Products WHERE ProductID=@p", cn)
                    cmdP.Parameters.AddWithValue("@p", prodId)
                    Dim o = cmdP.ExecuteScalar()
                    If o Is Nothing OrElse o Is DBNull.Value Then
                        prodName = "Product #" & prodId.ToString()
                    Else
                        prodName = Convert.ToString(o)
                    End If
                End Using
                If qty > 0D Then
                    Return $"Task: {prodName} x {qty:0.####}"
                Else
                    Return $"Task: {prodName}"
                End If
            Catch
                Return String.Empty
            End Try
        End Function

        ' Parse the first entry from a "Products: id=qty|..." list
        Private Function TryParseFirstProductAndQty(notes As String, ByRef productId As Integer, ByRef qty As Decimal) As Boolean
            productId = 0 : qty = 0D
            If String.IsNullOrWhiteSpace(notes) Then Return False
            Dim marker As String = "Products:"
            Dim idx As Integer = notes.IndexOf(marker, StringComparison.OrdinalIgnoreCase)
            If idx < 0 Then Return False
            Dim listPart As String = notes.Substring(idx + marker.Length).Trim()
            Dim parts = listPart.Split(New Char() {"|"c}, StringSplitOptions.RemoveEmptyEntries)
            For Each part In parts
                Dim kv = part.Split("="c)
                If kv.Length >= 1 Then
                    Dim idStr = kv(0).Trim()
                    Dim id As Integer
                    If Integer.TryParse(idStr, id) Then
                        productId = id
                        If kv.Length >= 2 Then
                            Dim qStr = kv(1).Trim()
                            Dim q As Decimal
                            If Decimal.TryParse(qStr, q) Then qty = q
                        End If
                        Return True
                    End If
                End If
            Next
            Return False
        End Function

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
            ' No-op: keep auto refresh disabled to avoid UI delays/resets
        End Sub

        Private Sub UpdateClock()
            lblClock.Text = AppTime.Now().ToString("dddd, dd MMM yyyy  HH:mm:ss")
        End Sub

        Private Sub OnTick(sender As Object, e As EventArgs)
            LoadTiles()
        End Sub

        ' Allow other forms to force-refresh producer tiles immediately
        Public Sub RefreshNow()
            LoadTiles()
        End Sub

        Private Sub UpdateBlueTickStamp()
            ' Disabled visual timer indicator
            If lblBlueTick Is Nothing OrElse Not lblBlueTick.Visible Then Return
            lblBlueTick.Text = "✓"
            PositionBlueTick()
            lblBlueTick.BringToFront()
        End Sub

        Private Sub PositionBlueTick()
            ' Keep the blue tick at the top-right with a small margin
            Dim margin As Integer = 20
            If lblBlueTick Is Nothing OrElse lblBlueTick.IsDisposed Then Return
            Dim x As Integer = Math.Max(0, Me.ClientSize.Width - lblBlueTick.PreferredWidth - margin)
            Dim y As Integer = 15
            lblBlueTick.Location = New Point(x, y)
        End Sub

        Private Sub SetSafeSplitterDistance()
            Try
                If splitMain Is Nothing OrElse splitMain.IsDisposed Then Return
                If Not splitMain.IsHandleCreated Then Return
                Dim total As Integer = Math.Max(0, splitMain.ClientSize.Height)
                If total <= 0 Then Return
                ' Desired visual minimums (not enforced on the control to prevent exceptions)
                Dim min1 As Integer = 200
                Dim min2 As Integer = 180
                Dim sw As Integer = Math.Max(1, splitMain.SplitterWidth)
                Dim maxDist As Integer = Math.Max(min1, total - min2 - sw)
                If maxDist < min1 Then
                    ' Window too small; fall back to center split
                    splitMain.SplitterDistance = Math.Max(0, total \ 2)
                    Return
                End If
                Dim desired As Integer = Math.Max(min1, CInt(total * 0.55))
                desired = Math.Min(desired, maxDist)
                If desired < min1 Then desired = min1
                If desired > maxDist Then desired = maxDist
                If desired >= min1 AndAlso desired <= maxDist Then
                    splitMain.SplitterDistance = desired
                End If
            Catch
                ' ignore layout edge cases; keep default
            End Try
        End Sub

        Private Sub CreateTile(name As String, back As Color, urgent As Integer, normal As Integer, taskText As String, userId As Integer, isNewUrgent As Boolean)
            Dim pnl As New Panel()
            pnl.Width = 320
            pnl.Height = 190
            pnl.Margin = New Padding(10)
            pnl.Padding = New Padding(12)
            pnl.BackColor = back
            pnl.Tag = userId

            Dim lblName As New Label()
            lblName.Text = name
            lblName.Font = New Font("Segoe UI", 20, FontStyle.Bold)
            lblName.AutoSize = False
            lblName.TextAlign = ContentAlignment.MiddleLeft
            lblName.Dock = DockStyle.Top
            lblName.Height = 52

            Dim lblCounts As New Label()
            Dim totalTasks As Integer = urgent + normal
            lblCounts.Text = $"Pending: {totalTasks}"
            lblCounts.Font = New Font("Segoe UI", 16, FontStyle.Bold)
            lblCounts.AutoSize = False
            lblCounts.TextAlign = ContentAlignment.MiddleLeft
            lblCounts.Dock = DockStyle.Top
            lblCounts.Height = 44

            Dim lblTask As New Label()
            ' Keep tile minimal: no specific task list here
            lblTask.Text = String.Empty
            lblTask.Font = New Font("Segoe UI", 12, FontStyle.Italic)
            lblTask.AutoSize = False
            lblTask.TextAlign = ContentAlignment.MiddleLeft
            lblTask.Dock = DockStyle.Top
            lblTask.Height = 12

            ' Diagnostics: show resolved locations and issued count (temporary)
            Dim lblDiag As New Label()
            lblDiag.Text = GetDiagnosticsForUser(userId)
            lblDiag.Font = New Font("Segoe UI", 8, FontStyle.Italic)
            lblDiag.ForeColor = Color.DimGray
            lblDiag.AutoSize = False
            lblDiag.TextAlign = ContentAlignment.MiddleLeft
            lblDiag.Dock = DockStyle.Top
            lblDiag.Height = 18

            Dim btnOpen As New Button()
            btnOpen.Text = "Open tasks"
            btnOpen.Font = New Font("Segoe UI", 12, FontStyle.Bold)
            btnOpen.Dock = DockStyle.Bottom
            btnOpen.Height = 44
            btnOpen.ForeColor = Color.White
            btnOpen.BackColor = Color.SteelBlue
            btnOpen.FlatStyle = FlatStyle.Flat
            btnOpen.FlatAppearance.BorderSize = 0
            btnOpen.UseVisualStyleBackColor = False
            AddHandler btnOpen.Click, Sub() OnProducerSelected(userId, name)

            AddHandler pnl.Click, Sub() OnProducerSelected(userId, name)
            AddHandler lblName.Click, Sub() OnProducerSelected(userId, name)
            AddHandler lblCounts.Click, Sub() OnProducerSelected(userId, name)
            AddHandler lblTask.Click, Sub() OnProducerSelected(userId, name)
            ' Double-click the count to open the latest task directly
            AddHandler lblCounts.DoubleClick, Sub()
                                                  Try
                                                      Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                                                      Using cn As New SqlConnection(cs)
                                                          cn.Open()
                                                          Dim branchId As Integer = AppSession.CurrentBranchID
                                                          Using cmd As New SqlCommand("SELECT TOP 1 v.InternalOrderID FROM dbo.v_MfgPendingFromStockroom v WHERE v.BranchID=@b AND v.ManufacturerUserID=@uid ORDER BY v.RequestedDate DESC, v.InternalOrderID DESC;", cn)
                                                              cmd.Parameters.AddWithValue("@b", branchId)
                                                              cmd.Parameters.AddWithValue("@uid", userId)
                                                              Dim o = cmd.ExecuteScalar()
                                                              If o IsNot Nothing AndAlso o IsNot DBNull.Value Then
                                                                  Dim ioId As Integer = Convert.ToInt32(o)
                                                                  Using frm As New CompleteBuildForm(ioId)
                                                                      frm.ShowDialog(Me)
                                                                  End Using
                                                                  LoadTiles()
                                                                  OnProducerSelected(userId, name)
                                                              End If
                                                          End Using
                                                      End Using
                                                  Catch
                                                  End Try
                                              End Sub

            pnl.Controls.Add(btnOpen)
            pnl.Controls.Add(lblCounts)
            pnl.Controls.Add(lblDiag)
            pnl.Controls.Add(lblTask)
            pnl.Controls.Add(lblName)
            flow.Controls.Add(pnl)

            ' Track base color and panels that should blink due to new urgent work
            If userId > 0 Then
                userBaseColors(userId) = back
                If isNewUrgent AndAlso urgent > 0 Then
                    If Not flashingPanels.ContainsKey(userId) Then
                        flashingPanels(userId) = pnl
                    End If
                End If
            End If

            ' Improve text readability with contrasting colors
            Dim fore As Color = GetIdealTextColor(back)
            lblName.ForeColor = fore
            lblCounts.ForeColor = fore
            lblTask.ForeColor = fore
        End Sub

        ' Choose black or white text based on background luminance for readability
        Private Function GetIdealTextColor(bg As Color) As Color
            ' Perceived luminance formula
            Dim luminance As Double = (0.299 * bg.R + 0.587 * bg.G + 0.114 * bg.B) / 255.0
            ' Bias towards white text unless the background is very bright
            Return If(luminance > 0.8, Color.Black, Color.White)
        End Function

        Private Sub OpenProducerTasks(userId As Integer, name As String)
            ' Open BOM completion form for this producer
            Using frm As New CompleteBuildForm(name, userId)
                frm.ShowDialog(Me)
            End Using
        End Sub

        Private Sub LoadTiles()
            Try
                flow.Controls.Clear()
                flashingPanels.Clear()
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim branchId As Integer = AppSession.CurrentBranchID
                    ' Build manufacturer list from Pending BomTaskStatus for this branch, mirroring stockroom pattern
                    Dim dt As New DataTable()
                    Using cmd As New SqlCommand("SELECT v.ManufacturerUserID, v.ManufacturerName, COUNT(1) AS PendingCount " & _
                                               "FROM dbo.v_MfgPendingFromStockroom v " & _
                                               "WHERE v.BranchID=@b " & _
                                               "GROUP BY v.ManufacturerUserID, v.ManufacturerName " & _
                                               "ORDER BY v.ManufacturerName;", cn)
                        cmd.Parameters.AddWithValue("@b", branchId)
                        Using da As New SqlDataAdapter(cmd)
                            da.Fill(dt)
                        End Using
                    End Using

                    If dt.Rows.Count = 0 Then
                        ' Friendly placeholder when no pending items
                        Dim lbl As New Label()
                        lbl.Text = "No pending manufacturing tasks for this branch."
                        lbl.Font = New Font("Segoe UI", 14, FontStyle.Italic)
                        lbl.AutoSize = True
                        lbl.ForeColor = Color.DimGray
                        flow.Controls.Add(lbl)
                    Else
                        For Each r As DataRow In dt.Rows
                            Dim uid As Integer = If(IsDBNull(r("ManufacturerUserID")), 0, Convert.ToInt32(r("ManufacturerUserID")))
                            Dim name As String = Convert.ToString(r("ManufacturerName"))
                            Dim urgent As Integer = Convert.ToInt32(r("PendingCount"))
                            Dim normal As Integer = 0
                            Dim baseColor As Color = GetColorForUser(uid, urgent, normal)
                            Dim isNew As Boolean = False
                            If lastUrgentCounts.ContainsKey(uid) Then
                                If urgent > lastUrgentCounts(uid) Then isNew = True
                            End If
                            lastUrgentCounts(uid) = urgent
                            ' Do not compute/display a specific task on the tile; the bottom grid will show all
                            CreateTile(name, baseColor, urgent, normal, "", uid, isNew)
                        Next
                    End If
                End Using

                ' Manage blink state based on whether there are urgent panels
                If flashingPanels.Count > 0 Then
                    If Not blinkTimer.Enabled Then blinkTimer.Start()
                Else
                    blinkTimer.Stop()
                    blinkOn = False
                End If
                UpdateBlueTickStamp()
            Catch ex As Exception
                UpdateBlueTickStamp()
            End Try
        End Sub

        Private Sub OnBlink(sender As Object, e As EventArgs)
            blinkOn = Not blinkOn
            ' Flash between per-user base color and a highlight color to indicate new urgent work
            Dim highlight As Color = Color.Gold
            For Each kv In flashingPanels
                Dim pnl = kv.Value
                If pnl Is Nothing OrElse pnl.IsDisposed Then Continue For
                Dim uid As Integer = CInt(pnl.Tag)
                Dim baseCol As Color = If(userBaseColors.ContainsKey(uid), userBaseColors(uid), Color.LightGray)
                pnl.BackColor = If(blinkOn, highlight, baseCol)
            Next
        End Sub

        ' Map a user to a stable, visually distinct color. Shade varies slightly by status.
        Private Function GetColorForUser(userId As Integer, urgent As Integer, normal As Integer) As Color
            ' Softer, presentable palette
            Dim palette As Color() = {
                Color.LightSteelBlue,
                Color.MediumAquamarine,
                Color.Khaki,
                Color.Plum,
                Color.SkyBlue,
                Color.Salmon,
                Color.PaleGoldenrod,
                Color.LightSeaGreen,
                Color.BurlyWood,
                Color.MediumSlateBlue
            }
            Dim baseCol = palette(Math.Abs(userId) Mod palette.Length)
            ' Keep colors light and readable regardless of count
            Return LightenColor(baseCol, 0.12)
        End Function

        Private Function LightenColor(c As Color, amount As Double) As Color
            amount = Math.Max(0.0, Math.Min(1.0, amount))
            Dim r As Integer = CInt(c.R + (255 - c.R) * amount)
            Dim g As Integer = CInt(c.G + (255 - c.G) * amount)
            Dim b As Integer = CInt(c.B + (255 - c.B) * amount)
            Return Color.FromArgb(r, g, b)
        End Function

        ' Compute counts for a manufacturer based on BomTaskStatus Pending items
        ' Urgent = number of pending BOMs for this manufacturer (one per InternalOrderID)
        ' Other = 0 (only tracking pending work here)
        Private Sub ComputeCountsForUser(cn As SqlConnection, branchId As Integer, userId As Integer, ByRef urgent As Integer, ByRef normal As Integer)
            urgent = 0 : normal = 0
            Using cmd As New SqlCommand("SELECT COUNT(1) " & _
                                        "FROM dbo.v_MfgPendingFromStockroom v " & _
                                        "WHERE v.BranchID=@b AND v.ManufacturerUserID=@uid;", cn)
                cmd.Parameters.AddWithValue("@b", branchId)
                cmd.Parameters.AddWithValue("@uid", userId)
                Dim o = cmd.ExecuteScalar()
                urgent = If(o Is Nothing OrElse o Is DBNull.Value, 0, Convert.ToInt32(o))
            End Using
            normal = 0
        End Sub

        Private Function GetDiagnosticsForUser(userId As Integer) As String
            Try
                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim branchId As Integer = AppSession.CurrentBranchID
                    Dim stockLoc As Integer = 0, mfgLoc As Integer = 0
                    Using cmdLoc As New SqlCommand("SELECT dbo.fn_GetLocationId(@b, N'STOCKROOM') AS StockLoc, dbo.fn_GetLocationId(@b, N'MFG') AS MfgLoc;", cn)
                        cmdLoc.Parameters.AddWithValue("@b", If(branchId > 0, CType(branchId, Object), DBNull.Value))
                        Using r = cmdLoc.ExecuteReader()
                            If r.Read() Then
                                stockLoc = If(IsDBNull(r("StockLoc")), 0, Convert.ToInt32(r("StockLoc")))
                                mfgLoc = If(IsDBNull(r("MfgLoc")), 0, Convert.ToInt32(r("MfgLoc")))
                            End If
                        End Using
                    End Using
                    Dim cnt As Integer = 0
                    Using cmd As New SqlCommand("SELECT COUNT(*) FROM dbo.InternalOrderLines IOL INNER JOIN dbo.InternalOrderHeader IOH ON IOH.InternalOrderID = IOL.InternalOrderID WHERE IOH.Notes LIKE N'%ManufacturerUserID=' + CAST(@uid AS nvarchar(12)) + N'%' AND IOH.FromLocationID=@fromLoc AND IOH.ToLocationID=@toLoc AND IOH.Status IN ('Issued','Fulfilled') AND IOL.ProductID IS NOT NULL;", cn)
                        cmd.Parameters.AddWithValue("@uid", userId)
                        cmd.Parameters.AddWithValue("@fromLoc", stockLoc)
                        cmd.Parameters.AddWithValue("@toLoc", mfgLoc)
                        Dim o = cmd.ExecuteScalar()
                        cnt = If(o Is Nothing OrElse o Is DBNull.Value, 0, Convert.ToInt32(o))
                    End Using
                    Return $"Locs S={stockLoc} M={mfgLoc} | IssuedLines={cnt}"
                End Using
            Catch
                Return "Diag: n/a"
            End Try
        End Function

        Private Function ParseProductIds(notes As String) As List(Of Integer)
            Dim list As New List(Of Integer)()
            If String.IsNullOrWhiteSpace(notes) Then Return list
            Dim marker As String = "Products:"
            Dim idx As Integer = notes.IndexOf(marker, StringComparison.OrdinalIgnoreCase)
            If idx < 0 Then Return list
            Dim listPart As String = notes.Substring(idx + marker.Length).Trim()
            Dim parts = listPart.Split(New Char() {"|"c}, StringSplitOptions.RemoveEmptyEntries)
            For Each part In parts
                Dim kv = part.Split("="c)
                If kv.Length = 2 Then
                    Dim id As Integer
                    If Integer.TryParse(kv(0).Trim(), id) Then list.Add(id)
                End If
            Next
            Return list
        End Function
    End Class
End Namespace
