' Touch-first Producer Dashboard with live clock and color tiles
Imports System
Imports System.Data
Imports System.Drawing
Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms.DataVisualization.Charting

Namespace Manufacturing
    Public Class UserDashboardForm
        Inherits Form

        Private flow As New FlowLayoutPanel()
        Private lblClock As New Label()
        Private refreshTimer As New Timer()
        Private kpiChart As New Chart()
        ' Flashing notification for urgent tasks per user
        Private ReadOnly blinkTimer As New Timer()
        Private blinkOn As Boolean = False
        Private flashingPanels As New Dictionary(Of Integer, Panel)()

        Public Sub New()
            Me.Text = "Manufacturing - Producers"
            Me.WindowState = FormWindowState.Maximized
            Me.BackColor = Color.White

            lblClock.Font = New Font("Segoe UI", 18, FontStyle.Bold)
            lblClock.AutoSize = True
            lblClock.Location = New Point(20, 15)
            UpdateClock()

            flow.Dock = DockStyle.Fill
            flow.Padding = New Padding(20, 70, 20, 20)
            flow.AutoScroll = True
            flow.WrapContents = True

            Me.Controls.Add(flow)
            Me.Controls.Add(lblClock)

            ' Chart setup (urgent tasks per manufacturer)
            Dim chArea As New ChartArea("Main")
            chArea.AxisX.MajorGrid.Enabled = False
            chArea.AxisY.MajorGrid.LineColor = Color.Gainsboro
            kpiChart.ChartAreas.Clear()
            kpiChart.ChartAreas.Add(chArea)
            kpiChart.Legends.Clear()
            kpiChart.Palette = ChartColorPalette.Bright
            kpiChart.Anchor = AnchorStyles.Left Or AnchorStyles.Right Or AnchorStyles.Bottom
            kpiChart.Location = New Point(20, Me.ClientSize.Height - 280)
            kpiChart.Size = New Size(Me.ClientSize.Width - 40, 200)
            AddHandler Me.Resize, Sub()
                                       kpiChart.Location = New Point(20, Me.ClientSize.Height - 280)
                                       kpiChart.Size = New Size(Me.ClientSize.Width - 40, 200)
                                   End Sub

            Me.Controls.Add(kpiChart)

            ' Initial load of tiles
            LoadTiles()

            AddHandler refreshTimer.Tick, AddressOf OnTick
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
        
            Dim clockTimer As New Timer()
            AddHandler clockTimer.Tick, Sub() UpdateClock()
            clockTimer.Interval = 1000
            clockTimer.Start()

            ' Blink timer to visually notify urgent tasks
            AddHandler blinkTimer.Tick, AddressOf OnBlink
            blinkTimer.Interval = 700
        End Sub

        ' Return a short summary of the next task for a user based on the latest Open/Issued internal order bundle
        Private Function GetLatestTaskTextForUser(cn As SqlConnection, branchId As Integer, userId As Integer) As String
            Try
                ' Resolve locations
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
                If stockLoc = 0 OrElse mfgLoc = 0 Then Return String.Empty

                ' Latest Open/Issued IOH for this user with Products list
                Dim notes As String = Nothing
                Using cmd As New SqlCommand("SELECT TOP 1 IOH.Notes FROM dbo.InternalOrderHeader IOH WHERE IOH.RequestedBy=@uid AND IOH.FromLocationID=@fromLoc AND IOH.ToLocationID=@toLoc AND IOH.Status IN ('Open','Issued') AND IOH.Notes LIKE 'Products:%' ORDER BY CASE WHEN IOH.Status='Issued' THEN 0 WHEN IOH.Status='Open' THEN 1 ELSE 2 END, IOH.RequestedDate DESC, IOH.InternalOrderID DESC;", cn)
                    cmd.Parameters.AddWithValue("@uid", userId)
                    cmd.Parameters.AddWithValue("@fromLoc", stockLoc)
                    cmd.Parameters.AddWithValue("@toLoc", mfgLoc)
                    Dim o = cmd.ExecuteScalar()
                    If o Is Nothing OrElse o Is DBNull.Value Then Return String.Empty
                    notes = Convert.ToString(o)
                End Using
                If String.IsNullOrWhiteSpace(notes) Then Return String.Empty

                ' Parse first productId and qty
                Dim prodId As Integer = 0
                Dim qty As Decimal = 0D
                If Not TryParseFirstProductAndQty(notes, prodId, qty) OrElse prodId <= 0 Then Return String.Empty

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
            refreshTimer.Interval = GetRefreshIntervalFromConfig()
            If Not refreshTimer.Enabled Then refreshTimer.Start()
        End Sub

        Private Sub UpdateClock()
            lblClock.Text = DateTime.Now.ToString("dddd, dd MMM yyyy  HH:mm:ss")
        End Sub

        Private Sub OnTick(sender As Object, e As EventArgs)
            LoadTiles()
        End Sub

        ' Allow other forms to force-refresh producer tiles immediately
        Public Sub RefreshNow()
            LoadTiles()
        End Sub

        Private Sub CreateTile(name As String, back As Color, urgent As Integer, normal As Integer, taskText As String, Optional userId As Integer = 0)
            Dim pnl As New Panel()
            pnl.Size = New Size(320, 180)
            pnl.Margin = New Padding(15)
            pnl.BackColor = back
            pnl.Cursor = Cursors.Hand
            pnl.Tag = userId

            Dim lblName As New Label()
            lblName.Text = name
            lblName.Font = New Font("Segoe UI", 20, FontStyle.Bold)
            lblName.AutoSize = False
            lblName.TextAlign = ContentAlignment.MiddleLeft
            lblName.Dock = DockStyle.Top
            lblName.Height = 60

            Dim lblCounts As New Label()
            lblCounts.Text = $"Urgent: {urgent}   |   Other: {normal}"
            lblCounts.Font = New Font("Segoe UI", 14, FontStyle.Regular)
            lblCounts.AutoSize = False
            lblCounts.TextAlign = ContentAlignment.MiddleLeft
            lblCounts.Dock = DockStyle.Top
            lblCounts.Height = 40

            Dim lblTask As New Label()
            lblTask.Text = If(String.IsNullOrWhiteSpace(taskText), "No task", taskText)
            lblTask.Font = New Font("Segoe UI", 12, FontStyle.Italic)
            lblTask.AutoSize = False
            lblTask.TextAlign = ContentAlignment.MiddleLeft
            lblTask.Dock = DockStyle.Top
            lblTask.Height = 36

            Dim btnOpen As New Button()
            btnOpen.Text = "Open tasks"
            btnOpen.Font = New Font("Segoe UI", 12, FontStyle.Bold)
            btnOpen.Dock = DockStyle.Bottom
            btnOpen.Height = 40
            AddHandler btnOpen.Click, Sub() OpenProducerTasks(userId, name)

            AddHandler pnl.Click, Sub() OpenProducerTasks(userId, name)
            AddHandler lblName.Click, Sub() OpenProducerTasks(userId, name)
            AddHandler lblCounts.Click, Sub() OpenProducerTasks(userId, name)
            AddHandler lblTask.Click, Sub() OpenProducerTasks(userId, name)

            pnl.Controls.Add(btnOpen)
            pnl.Controls.Add(lblCounts)
            pnl.Controls.Add(lblTask)
            pnl.Controls.Add(lblName)
            flow.Controls.Add(pnl)

            ' Track panels that have urgent tasks for blinking
            If urgent > 0 AndAlso userId > 0 Then
                If Not flashingPanels.ContainsKey(userId) Then
                    flashingPanels(userId) = pnl
                End If
            End If
        End Sub

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
                ' Prepare chart series
                kpiChart.Series.Clear()
                Dim s As New Series("UrgentTasks") With {
                    .ChartType = SeriesChartType.Column,
                    .IsValueShownAsLabel = True
                }

                Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()

                    ' Load active manufacturers
                    Dim dtUsers As New DataTable()
                    Using cmdU As New SqlCommand("SELECT u.UserID, (u.FirstName + ' ' + u.LastName) AS DisplayName FROM dbo.Users u INNER JOIN dbo.Roles r ON r.RoleID = u.RoleID WHERE r.RoleName IN ('Manufacturing-Manager','Manufacturer') AND u.IsActive=1 ORDER BY DisplayName;", cn)
                        Using da As New SqlDataAdapter(cmdU)
                            da.Fill(dtUsers)
                        End Using
                    End Using

                    Dim branchId As Integer = AppSession.CurrentBranchID
                    For Each row As DataRow In dtUsers.Rows
                        Dim uid As Integer = Convert.ToInt32(row("UserID"))
                        Dim name As String = row("DisplayName").ToString()
                        Dim urgent As Integer = 0, normal As Integer = 0
                        ComputeCountsForUser(cn, branchId, uid, urgent, normal)
                        Dim back As Color = If(urgent > 0, Color.LightCoral, If(normal > 0, Color.Khaki, Color.LightGreen))
                        Dim taskText As String = GetLatestTaskTextForUser(cn, branchId, uid)
                        CreateTile(name, back, urgent, normal, taskText, uid)
                        ' Chart point per user
                        s.Points.AddXY(name, urgent)
                    Next
                    kpiChart.Series.Add(s)
                End Using
                ' Manage blink state based on whether there are urgent panels
                If flashingPanels.Count > 0 Then
                    If Not blinkTimer.Enabled Then blinkTimer.Start()
                Else
                    blinkTimer.Stop()
                    blinkOn = False
                End If
            Catch ex As Exception
                ' Fallback: ensure chart has a visible empty series so UI doesn't look broken
                Try
                    kpiChart.Series.Clear()
                    Dim sEmpty As New Series("UrgentTasks") With {
                        .ChartType = SeriesChartType.Column,
                        .IsValueShownAsLabel = True
                    }
                    kpiChart.Series.Add(sEmpty)
                Catch
                End Try
            End Try
        End Sub

        Private Sub OnBlink(sender As Object, e As EventArgs)
            blinkOn = Not blinkOn
            ' Use green shades for flashing to align with green tiles while drawing attention
            Dim colorA As Color = Color.MediumSeaGreen
            Dim colorB As Color = Color.PaleGreen
            For Each kv In flashingPanels
                Dim pnl = kv.Value
                If pnl Is Nothing OrElse pnl.IsDisposed Then Continue For
                pnl.BackColor = If(blinkOn, colorA, colorB)
            Next
        End Sub

        ' Compute today's counts for a manufacturer based on Stockroom-fulfilled Internal Orders (Issued) for today.
        ' Urgent = total number of product entries across today's Issued bundles for this manufacturer.
        ' Other = 0 (once fulfilled, everything is urgent to make now).
        Private Sub ComputeCountsForUser(cn As SqlConnection, branchId As Integer, userId As Integer, ByRef urgent As Integer, ByRef normal As Integer)
            urgent = 0 : normal = 0
            ' Resolve locations
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
            If stockLoc = 0 OrElse mfgLoc = 0 Then Return

            ' Open/Issued bundles for this user (not limited to today)
            Dim totalProducts As Integer = 0
            Using cmd As New SqlCommand("SELECT IOH.Notes FROM dbo.InternalOrderHeader IOH WHERE IOH.RequestedBy = @uid AND IOH.FromLocationID=@fromLoc AND IOH.ToLocationID=@toLoc AND IOH.Status IN ('Open','Issued') AND IOH.Notes LIKE 'Products:%'", cn)
                cmd.Parameters.AddWithValue("@uid", userId)
                cmd.Parameters.AddWithValue("@fromLoc", stockLoc)
                cmd.Parameters.AddWithValue("@toLoc", mfgLoc)
                Using rdr = cmd.ExecuteReader()
                    While rdr.Read()
                        Dim notes As String = If(rdr.IsDBNull(0), String.Empty, rdr.GetString(0))
                        Dim ids = ParseProductIds(notes)
                        totalProducts += ids.Count
                    End While
                End Using
            End Using

            urgent = totalProducts
            normal = 0
        End Sub

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
