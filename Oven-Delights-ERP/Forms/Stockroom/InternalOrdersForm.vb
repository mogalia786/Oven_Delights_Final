Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports System.Drawing

Namespace Stockroom

Public Class InternalOrdersForm
    Inherits Form

    Private ReadOnly svc As New ManufacturingService()

    Private dgvHeaders As DataGridView
    Private dgvLines As DataGridView
    Private btnRefresh As Button
    Private btnFulfill As Button
    Private btnCreatePO As Button
    Private lblReceived As Label
    Private cboReceived As ComboBox
    Private lblFulfilled As Label
    Private cboFulfilled As ComboBox
    Private lblManufacturer As Label
    Private cboManufacturer As ComboBox
    Private btnWorkload As Button
    Private lblRequestedByTitle As Label
    Private lblRequestedByValue As Label
    Private suppressEvents As Boolean = False

    Private _manufacturerUserId As Integer = 0
    Private _manufacturerName As String = "-"

    Public Sub New()
        Me.Text = "Internal Orders (Bundles)"
        Me.Width = 900
        Me.Height = 560
        Me.StartPosition = FormStartPosition.CenterParent
        InitializeUi()
        LoadReceivedList()
        LoadFulfilledList()
        LoadManufacturers()
        ' Auto-refresh when the window shows
        AddHandler Me.Shown, Sub(sender, args) OnRefresh(Nothing, EventArgs.Empty)
    End Sub

    Private Sub LoadManufacturers()
        Try
            Using cn As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                cn.Open()
                Dim sql As String = _
                    "SELECT u.UserID, (u.FirstName + ' ' + u.LastName) AS FullName " & _
                    "FROM dbo.Users u " & _
                    "JOIN dbo.Roles r ON r.RoleID = u.RoleID " & _
                    "WHERE r.RoleName IN (N'Manufacturing-Manager', N'MM', N'Manufacturer') OR r.RoleName LIKE N'Manufactur%' " & _
                    "ORDER BY FullName;"
                Using cmd As New SqlCommand(sql, cn)
                    Using rdr = cmd.ExecuteReader()
                        Dim dt As New DataTable()
                        dt.Load(rdr)
                        cboManufacturer.DataSource = dt
                        cboManufacturer.DisplayMember = "FullName"
                        cboManufacturer.ValueMember = "UserID"
                    End Using
                End Using
            End Using
            SelectManufacturerInCombo()
        Catch ex As Exception
            ' non-fatal
        End Try
    End Sub

    Private Sub SafeLoadManufacturers()
        Try
            LoadManufacturers()
        Catch
        End Try
    End Sub

    Private Sub SelectManufacturerInCombo()
        If cboManufacturer Is Nothing OrElse cboManufacturer.DataSource Is Nothing Then Return
        If _manufacturerUserId > 0 Then
            Try
                cboManufacturer.SelectedValue = _manufacturerUserId
            Catch
                ' ignore if not found
            End Try
        Else
            cboManufacturer.SelectedIndex = -1
        End If
    End Sub

    Private Sub OnManufacturerChanged(sender As Object, e As EventArgs)
        If cboManufacturer Is Nothing OrElse cboManufacturer.SelectedValue Is Nothing Then
            _manufacturerUserId = 0
            _manufacturerName = "-"
        Else
            Dim uid As Integer = 0
            Integer.TryParse(cboManufacturer.SelectedValue.ToString(), uid)
            _manufacturerUserId = uid
            _manufacturerName = If(cboManufacturer.Text, "-")
        End If
        ' Persist to current IO header (if any selected)
        Dim ioId = GetSelectedInternalOrderID()
        If ioId > 0 AndAlso _manufacturerUserId > 0 Then
            SaveManufacturerOnHeader(ioId, _manufacturerUserId)
        End If
        ' Recompute enable state based on current shortages + manufacturer selection
        Try
            RecomputeButtonsFromCurrent()
        Catch
        End Try
    End Sub

    ' Overload: optionally auto-run shortage-to-PO when opened from dashboard
    Public Sub New(autoShortagePO As Boolean)
        Me.New()
        If autoShortagePO Then
            AddHandler Me.Shown, Sub()
                                     Try
                                         Me.AutoOpenShortagePO()
                                     Catch
                                         ' non-fatal
                                     End Try
                                 End Sub
        End If
    End Sub

    ' New overload: accept preselected manufacturer from dashboard
    Public Sub New(autoShortagePO As Boolean, manufacturerUserId As Integer, manufacturerName As String)
        Me.New(autoShortagePO)
        _manufacturerUserId = manufacturerUserId
        If Not String.IsNullOrWhiteSpace(manufacturerName) Then
            _manufacturerName = manufacturerName
        End If
        Try
            SelectManufacturerInCombo()
        Catch
        End Try
    End Sub

    Private Sub InitializeUi()
        lblReceived = New Label() With {.Left = 12, .Top = 12, .AutoSize = True, .Text = "BOM Received:"}
        cboReceived = New ComboBox() With {.Left = 110, .Top = 8, .Width = 360, .DropDownStyle = ComboBoxStyle.DropDownList}
        lblFulfilled = New Label() With {.Left = 490, .Top = 12, .AutoSize = True, .Text = "BOM Fulfilled:"}
        cboFulfilled = New ComboBox() With {.Left = 590, .Top = 8, .Width = 280, .DropDownStyle = ComboBoxStyle.DropDownList}

        ' Requested by (Retail Manager)
        lblRequestedByTitle = New Label() With {.Left = 12, .Top = 40, .AutoSize = True, .Text = "Requested by (Retail):"}
        lblRequestedByValue = New Label() With {.Left = 160, .Top = 40, .AutoSize = True, .Text = "-"}

        ' Manufacturer assignment (editable) + workload
        lblManufacturer = New Label() With {.Left = 490, .Top = 40, .AutoSize = True, .Text = "Manufacturer:"}
        cboManufacturer = New ComboBox() With {.Left = 590, .Top = 36, .Width = 220, .DropDownStyle = ComboBoxStyle.DropDownList}
        btnWorkload = New Button() With {.Left = 816, .Top = 36, .Width = 56, .Text = "Load"}

        dgvHeaders = New DataGridView() With {
            .Left = 12, .Top = 68, .Width = 860, .Height = 196,
            .ReadOnly = True, .AllowUserToAddRows = False, .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect, .MultiSelect = False
        }
        dgvLines = New DataGridView() With {
            .Left = 12, .Top = 312, .Width = 860, .Height = 220,
            .ReadOnly = True, .AllowUserToAddRows = False, .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect, .MultiSelect = False
        }
        btnRefresh = New Button() With {.Left = 12, .Top = 272, .Width = 120, .Text = "Refresh"}
        btnCreatePO = New Button() With {.Left = 540, .Top = 272, .Width = 200, .Text = "Create PO for Shortages", .Enabled = False}
        btnFulfill = New Button() With {.Left = 752, .Top = 272, .Width = 120, .Text = "Fulfill"}

        AddHandler btnRefresh.Click, AddressOf OnRefresh
        AddHandler btnCreatePO.Click, AddressOf OnCreatePOForShortages
        AddHandler btnFulfill.Click, AddressOf OnFulfill
        AddHandler dgvHeaders.SelectionChanged, AddressOf OnHeaderSelectionChanged
        AddHandler cboReceived.SelectedIndexChanged, AddressOf OnReceivedSelected
        AddHandler cboFulfilled.SelectedIndexChanged, AddressOf OnFulfilledSelected
        AddHandler btnWorkload.Click, AddressOf OnWorkloadClicked
        AddHandler cboManufacturer.SelectedIndexChanged, AddressOf OnManufacturerChanged
        AddHandler cboManufacturer.DropDown, Sub() SafeLoadManufacturers()

        Me.Controls.AddRange(New Control() {lblReceived, cboReceived, lblFulfilled, cboFulfilled, lblRequestedByTitle, lblRequestedByValue, lblManufacturer, cboManufacturer, btnWorkload, dgvHeaders, dgvLines, btnRefresh, btnCreatePO, btnFulfill})
    End Sub

    Private Sub OnRefresh(sender As Object, e As EventArgs)
        LoadReceivedList()
        LoadFulfilledList()
        dgvHeaders.DataSource = Nothing
        dgvLines.DataSource = Nothing
        cboReceived.SelectedIndex = -1
        cboFulfilled.SelectedIndex = -1
        lblRequestedByValue.Text = "-"
        SelectManufacturerInCombo()
    End Sub

    Private Sub OnHeaderSelectionChanged(sender As Object, e As EventArgs)
        If suppressEvents Then Return
        LoadLinesForSelected()
    End Sub

    Private Sub LoadReceivedList()
        Try
            Using cn As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                cn.Open()
                Dim sql As String = _
                    "SELECT IOH.InternalOrderID, " & _
                    "       IOH.InternalOrderNo + N' — Requested by ' + COALESCE(u.FirstName + ' ' + u.LastName, N'User') AS DisplayText " & _
                    "FROM dbo.InternalOrderHeader IOH " & _
                    "LEFT JOIN dbo.Users u ON u.UserID = IOH.RequestedBy " & _
                    "JOIN dbo.InventoryLocations L ON L.LocationID = IOH.FromLocationID " & _
                    "WHERE IOH.Status = 'Open' AND (IOH.Notes LIKE '%Bundle%' OR IOH.Notes LIKE '%BuildOfMaterials%') " & _
                    "  AND (L.BranchID = @bid OR @bid IS NULL) " & _
                    "ORDER BY IOH.InternalOrderID DESC"
                Using cmd As New SqlCommand(sql, cn)
                    Dim bid As Object = If(AppSession.CurrentBranchID > 0, CType(AppSession.CurrentBranchID, Object), DBNull.Value)
                    cmd.Parameters.AddWithValue("@bid", bid)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        cboReceived.DataSource = dt
                        cboReceived.DisplayMember = "DisplayText"
                        cboReceived.ValueMember = "InternalOrderID"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to load BOM received list: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadFulfilledList()
        Try
            Using cn As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                cn.Open()
                Dim sql As String = _
                    "SELECT IOH.InternalOrderID, " & _
                    "       IOH.InternalOrderNo + N' — Requested by ' + COALESCE(u.FirstName + ' ' + u.LastName, N'User') AS DisplayText " & _
                    "FROM dbo.InternalOrderHeader IOH " & _
                    "LEFT JOIN dbo.Users u ON u.UserID = IOH.RequestedBy " & _
                    "JOIN dbo.InventoryLocations L ON L.LocationID = IOH.FromLocationID " & _
                    "WHERE IOH.Status = 'Issued' AND (IOH.Notes LIKE '%Bundle%' OR IOH.Notes LIKE '%BuildOfMaterials%') " & _
                    "  AND (L.BranchID = @bid OR @bid IS NULL) " & _
                    "ORDER BY IOH.InternalOrderID DESC"
                Using cmd As New SqlCommand(sql, cn)
                    Dim bid As Object = If(AppSession.CurrentBranchID > 0, CType(AppSession.CurrentBranchID, Object), DBNull.Value)
                    cmd.Parameters.AddWithValue("@bid", bid)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        cboFulfilled.DataSource = dt
                        cboFulfilled.DisplayMember = "DisplayText"
                        cboFulfilled.ValueMember = "InternalOrderID"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to load BOM fulfilled list: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' Manufacturer list removed — manufacturer is chosen earlier (Retail/Stockroom dashboard)

    Private Sub LoadLinesForSelected()
        Dim id As Integer = GetSelectedInternalOrderID()
        If id <= 0 Then
            dgvLines.DataSource = Nothing
            Return
        End If
        Try
            Using cn As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                cn.Open()
                ' Load header for selected IO into top grid (single row)
                Using cmdH As New SqlCommand("SELECT InternalOrderID, InternalOrderNo, FromLocationID, ToLocationID, Status, RequestedDate, RequestedBy, ISNULL(Notes,'') AS Notes FROM dbo.InternalOrderHeader WHERE InternalOrderID = @id", cn)
                    cmdH.Parameters.AddWithValue("@id", id)
                    Using daH As New SqlDataAdapter(cmdH)
                        Dim dtH As New DataTable()
                        daH.Fill(dtH)
                        suppressEvents = True
                        dgvHeaders.DataSource = dtH
                        suppressEvents = False
                        ' Requested by Retail Manager name
                        If dtH.Rows.Count > 0 Then
                            Dim reqBy As Object = dtH.Rows(0)("RequestedBy")
                            Dim reqName As String = "-"
                            If reqBy IsNot DBNull.Value Then
                                Dim uid As Integer = Convert.ToInt32(reqBy)
                                reqName = GetUserFullName(uid)
                            End If
                            lblRequestedByValue.Text = reqName
                            ' Preselect manufacturer from Notes token
                            Dim notes As String = Convert.ToString(dtH.Rows(0)("Notes"))
                            Dim manId As Integer = ExtractInt(notes, "ManufacturerUserID=")
                            If manId > 0 Then
                                Try
                                    ' Removed manufacturer combo box
                                Catch
                                End Try
                            Else
                                ' Removed manufacturer combo box
                            End If
                        Else
                            lblRequestedByValue.Text = "-"
                            ' Removed manufacturer combo box
                        End If
                    End Using
                End Using
                ' Show readable item names for stockroom lines
                Dim sql As String = _
                    "SELECT iol.LineNumber, iol.ItemType, " & _
                    "       COALESCE(CONCAT(rm.MaterialCode, ' - ', rm.MaterialName), p.ProductName, 'Component') AS Item, " & _
                    "       CAST(iol.Quantity AS decimal(18,4)) AS RequestedQty, iol.UoM, " & _
                    "       CASE WHEN iol.ItemType = 'RawMaterial' THEN CAST(ISNULL(mov.QtyOnHand, 0) AS decimal(18,4)) ELSE NULL END AS AvailableQty, " & _
                    "       iol.RawMaterialID " & _
                    "FROM dbo.InternalOrderLines iol " & _
                    "LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = iol.RawMaterialID " & _
                    "LEFT JOIN dbo.Products p ON p.ProductID = iol.ProductID " & _
                    "JOIN dbo.InternalOrderHeader ioh ON ioh.InternalOrderID = iol.InternalOrderID " & _
                    "JOIN dbo.InventoryLocations loc ON loc.LocationID = ioh.FromLocationID " & _
                    "OUTER APPLY ( " & _
                    "    SELECT SUM(sm.QuantityIn - sm.QuantityOut) AS QtyOnHand " & _
                    "    FROM dbo.StockMovements sm " & _
                    "    WHERE sm.MaterialID = iol.RawMaterialID " & _
                    "      AND (sm.InventoryArea = N'Stockroom' OR sm.InventoryArea IS NULL) " & _
                    ") mov " & _
                    "WHERE iol.InternalOrderID = @id " & _
                    "ORDER BY iol.LineNumber"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@id", id)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvLines.DataSource = dt
                        ApplyStockFormattingAndGuard(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to load IO details: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function GetSelectedInternalOrderID() As Integer
        If dgvHeaders Is Nothing OrElse dgvHeaders.CurrentRow Is Nothing OrElse dgvHeaders.CurrentRow.DataBoundItem Is Nothing Then Return 0
        Dim drv = TryCast(dgvHeaders.CurrentRow.DataBoundItem, DataRowView)
        If drv Is Nothing Then Return 0
        Dim v As Object = drv.Row("InternalOrderID")
        If v Is Nothing OrElse v Is DBNull.Value Then Return 0
        Return Convert.ToInt32(v)
    End Function

    Private Sub OnFulfill(sender As Object, e As EventArgs)
        Dim id = GetSelectedInternalOrderID()
        If id <= 0 Then
            MessageBox.Show("Select an internal order to fulfill.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        ' Require manufacturer selection
        Dim manId As Integer = _manufacturerUserId
        If manId <= 0 Then
            MessageBox.Show("Select a manufacturer before fulfilling.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        Try
            ' Ensure the chosen manufacturer is persisted on IO header notes
            SaveManufacturerOnHeader(id, manId)

            ' Mark the Internal Order as Completed (fulfilled) and stamp a fulfillment time token
            Using cn As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                cn.Open()
                ' Update status to Completed if currently Open/Issued
                Using cmdU As New SqlCommand("UPDATE dbo.InternalOrderHeader SET Status = N'Completed', UpdatedAtUtc = SYSUTCDATETIME() WHERE InternalOrderID=@id;", cn)
                    cmdU.Parameters.AddWithValue("@id", id)
                    Try : cmdU.ExecuteNonQuery() : Catch : End Try
                End Using
                ' Stamp fulfillment time token in Notes (FulfilledAtUtc=...)
                Dim notes As String = ""
                Using cmdR As New SqlCommand("SELECT ISNULL(Notes,'') FROM dbo.InternalOrderHeader WHERE InternalOrderID=@id", cn)
                    cmdR.Parameters.AddWithValue("@id", id)
                    Dim o = cmdR.ExecuteScalar()
                    If o IsNot Nothing AndAlso o IsNot DBNull.Value Then notes = Convert.ToString(o)
                End Using
                Dim newNotes As String = UpsertNotesToken(notes, "FulfilledAtUtc=", DateTime.UtcNow.ToString("o"))
                Using cmdN As New SqlCommand("UPDATE dbo.InternalOrderHeader SET Notes=@n WHERE InternalOrderID=@id", cn)
                    cmdN.Parameters.AddWithValue("@n", newNotes)
                    cmdN.Parameters.AddWithValue("@id", id)
                    Try : cmdN.ExecuteNonQuery() : Catch : End Try
                End Using
            End Using

            ' Persist DailyOrderBook: stockroom fulfilled (by InternalOrderID)
            Try
                Using cn2 As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    cn2.Open()
                    Using cmdF As New SqlCommand("dbo.sp_DailyOrderBook_SetStockroomFulfilled", cn2)
                        cmdF.CommandType = CommandType.StoredProcedure
                        cmdF.Parameters.AddWithValue("@BookDate", Services.TimeProvider.Today())
                        cmdF.Parameters.AddWithValue("@BranchID", If(AppSession.CurrentBranchID > 0, CType(AppSession.CurrentBranchID, Object), 0))
                        cmdF.Parameters.AddWithValue("@ProductID", CType(DBNull.Value, Object))
                        cmdF.Parameters.AddWithValue("@InternalOrderID", id)
                        cmdF.Parameters.AddWithValue("@StockroomFulfilledAtUtc", DateTime.UtcNow)
                        Try : cmdF.ExecuteNonQuery() : Catch : End Try
                    End Using
                End Using
            Catch
            End Try

            ' Notify Manufacturing dashboard if it's open so it can show the new Issued order
            Try
                For Each f As Form In Application.OpenForms
                    If f.GetType().FullName = "Oven_Delights_ERP.Manufacturing.ManufacturingDashboardForm" Then
                        Dim mi = f.GetType().GetMethod("RefreshData")
                        If mi IsNot Nothing Then mi.Invoke(f, Nothing)
                        f.BringToFront()
                        Exit For
                    End If
                Next
            Catch
            End Try

            ' Close this form so dashboard can gray out the row
            Me.DialogResult = DialogResult.OK
            Me.Close()
        Catch ex As Exception
            MessageBox.Show("Fulfillment failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnReceivedSelected(sender As Object, e As EventArgs)
        Dim id As Integer = 0
        Dim parsed As Boolean = False
        Dim valObj As Object = Nothing
        If cboReceived IsNot Nothing Then
            valObj = cboReceived.SelectedValue
        End If
        If valObj IsNot Nothing Then
            parsed = Integer.TryParse(valObj.ToString(), id)
        End If
        If Not parsed Then
            Dim drv As DataRowView = TryCast(cboReceived.SelectedItem, DataRowView)
            If drv IsNot Nothing AndAlso drv.Row IsNot Nothing AndAlso drv.Row.Table IsNot Nothing AndAlso drv.Row.Table.Columns.Contains("InternalOrderID") Then
                Dim raw As Object = drv.Row("InternalOrderID")
                If raw IsNot Nothing AndAlso raw IsNot DBNull.Value Then
                    id = Convert.ToInt32(raw)
                    parsed = True
                End If
            End If
        End If
        If parsed AndAlso id > 0 Then
            LoadHeaderAndLinesById(id)
        Else
            dgvHeaders.DataSource = Nothing
            dgvLines.DataSource = Nothing
        End If
    End Sub

    Private Sub OnFulfilledSelected(sender As Object, e As EventArgs)
        ' Optional: show the fulfilled IO details if desired, otherwise keep grids clear
        dgvHeaders.DataSource = Nothing
        dgvLines.DataSource = Nothing
    End Sub

    Private Sub LoadHeaderAndLinesById(ioId As Integer)
        If ioId <= 0 Then
            dgvHeaders.DataSource = Nothing
            dgvLines.DataSource = Nothing
            Return
        End If
        Try
            Using cn As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                cn.Open()
                Using cmdH As New SqlCommand("SELECT InternalOrderID, InternalOrderNo, FromLocationID, ToLocationID, Status, RequestedDate, RequestedBy, ISNULL(Notes,'') AS Notes FROM dbo.InternalOrderHeader WHERE InternalOrderID = @id", cn)
                    cmdH.Parameters.AddWithValue("@id", ioId)
                    Using daH As New SqlDataAdapter(cmdH)
                        Dim dtH As New DataTable()
                        daH.Fill(dtH)
                        suppressEvents = True
                        dgvHeaders.DataSource = dtH
                        suppressEvents = False
                        If dtH.Rows.Count > 0 Then
                            Dim reqBy As Object = dtH.Rows(0)("RequestedBy")
                            Dim reqName As String = "-"
                            If reqBy IsNot DBNull.Value Then
                                Dim uid As Integer = Convert.ToInt32(reqBy)
                                reqName = GetUserFullName(uid)
                            End If
                            lblRequestedByValue.Text = reqName
                            Dim notes As String = Convert.ToString(dtH.Rows(0)("Notes"))
                            Dim manId As Integer = ExtractInt(notes, "ManufacturerUserID=")
                            If manId > 0 Then
                                Try 
                                    ' Removed manufacturer combo box
                                Catch 
                                End Try
                            Else
                                ' Removed manufacturer combo box
                            End If
                        Else
                            lblRequestedByValue.Text = "-"
                            ' Removed manufacturer combo box
                        End If
                    End Using
                End Using
                Dim sql As String = _
                    "SELECT iol.LineNumber, iol.ItemType, " & _
                    "       COALESCE(CONCAT(rm.MaterialCode, ' - ', rm.MaterialName), p.ProductName, 'Component') AS Item, " & _
                    "       CAST(iol.Quantity AS decimal(18,4)) AS RequestedQty, iol.UoM, " & _
                    "       CASE WHEN iol.ItemType = 'RawMaterial' THEN CAST(ISNULL(mov.QtyOnHand, 0) AS decimal(18,4)) ELSE NULL END AS AvailableQty, " & _
                    "       iol.RawMaterialID " & _
                    "FROM dbo.InternalOrderLines iol " & _
                    "LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = iol.RawMaterialID " & _
                    "LEFT JOIN dbo.Products p ON p.ProductID = iol.ProductID " & _
                    "JOIN dbo.InternalOrderHeader ioh ON ioh.InternalOrderID = iol.InternalOrderID " & _
                    "JOIN dbo.InventoryLocations loc ON loc.LocationID = ioh.FromLocationID " & _
                    "OUTER APPLY ( " & _
                    "    SELECT SUM(sm.QuantityIn - sm.QuantityOut) AS QtyOnHand " & _
                    "    FROM dbo.StockMovements sm " & _
                    "    WHERE sm.MaterialID = iol.RawMaterialID " & _
                    "      AND (sm.InventoryArea = N'Stockroom' OR sm.InventoryArea IS NULL) " & _
                    ") mov " & _
                    "WHERE iol.InternalOrderID = @id " & _
                    "ORDER BY iol.LineNumber"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@id", ioId)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvLines.DataSource = dt
                        ApplyStockFormattingAndGuard(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to load IO details: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ApplyStockFormattingAndGuard(dt As DataTable)
        Try
            Dim insufficient As Boolean = False
            If dt IsNot Nothing AndAlso dt.Columns.Contains("RequestedQty") AndAlso dt.Columns.Contains("AvailableQty") Then
                ' Evaluate shortages
                For Each r As DataRow In dt.Rows
                    Dim req As Decimal = 0D
                    Dim avail As Decimal = 0D
                    If r("RequestedQty") IsNot DBNull.Value Then req = Convert.ToDecimal(r("RequestedQty"))
                    If r("AvailableQty") IsNot DBNull.Value Then avail = Convert.ToDecimal(r("AvailableQty"))
                    If req > avail Then insufficient = True
                Next

                ' Apply row-level highlighting
                For Each row As DataGridViewRow In dgvLines.Rows
                    If row.IsNewRow Then Continue For
                    Dim req As Decimal = 0D
                    Dim avail As Decimal = 0D
                    If row.Cells("RequestedQty").Value IsNot Nothing AndAlso row.Cells("RequestedQty").Value IsNot DBNull.Value Then
                        req = Convert.ToDecimal(row.Cells("RequestedQty").Value)
                    End If
                    If row.Cells("AvailableQty").Value IsNot Nothing AndAlso row.Cells("AvailableQty").Value IsNot DBNull.Value Then
                        avail = Convert.ToDecimal(row.Cells("AvailableQty").Value)
                    End If
                    If req > avail Then
                        row.DefaultCellStyle.BackColor = Color.MistyRose
                        row.DefaultCellStyle.ForeColor = Color.Black
                    Else
                        row.DefaultCellStyle.BackColor = Color.White
                        row.DefaultCellStyle.ForeColor = Color.Black
                    End If
                Next
            End If
            ' Also require a manufacturer to be selected
            Dim hasManufacturer As Boolean = (_manufacturerUserId > 0)
            btnFulfill.Enabled = (Not insufficient) AndAlso hasManufacturer
            btnCreatePO.Enabled = insufficient
        Catch
            ' Best-effort; do not block if formatting fails
            btnFulfill.Enabled = False
            btnCreatePO.Enabled = False
        End Try
    End Sub

    Private Sub OnCreatePOForShortages(sender As Object, e As EventArgs)
        Dim id = GetSelectedInternalOrderID()
        If id <= 0 Then
            MessageBox.Show("Select an internal order first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If dgvLines Is Nothing OrElse dgvLines.Rows.Count = 0 Then
            MessageBox.Show("No lines loaded.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If

        ' Build shortages: only RawMaterial where RequestedQty > AvailableQty
        Dim dtShort As New DataTable()
        dtShort.Columns.Add("MaterialID", GetType(Integer))
        dtShort.Columns.Add("MaterialName", GetType(String))
        dtShort.Columns.Add("ShortQty", GetType(Decimal))

        For Each row As DataGridViewRow In dgvLines.Rows
            If row.IsNewRow Then Continue For
            Dim itemType As String = If(row.Cells("ItemType").Value, String.Empty).ToString()
            If Not String.Equals(itemType, "RawMaterial", StringComparison.OrdinalIgnoreCase) Then Continue For
            Dim req As Decimal = 0D
            Dim avail As Decimal = 0D
            If row.Cells("RequestedQty").Value IsNot Nothing AndAlso row.Cells("RequestedQty").Value IsNot DBNull.Value Then req = Convert.ToDecimal(row.Cells("RequestedQty").Value)
            If row.Cells("AvailableQty").Value IsNot Nothing AndAlso row.Cells("AvailableQty").Value IsNot DBNull.Value Then avail = Convert.ToDecimal(row.Cells("AvailableQty").Value)
            If req > avail Then
                Dim matId As Integer = 0
                If row.Cells("RawMaterialID") IsNot Nothing AndAlso row.Cells("RawMaterialID").Value IsNot DBNull.Value Then
                    matId = Convert.ToInt32(row.Cells("RawMaterialID").Value)
                End If
                If matId > 0 Then
                    Dim name As String = "Material"
                    If row.Cells("Item") IsNot Nothing AndAlso row.Cells("Item").Value IsNot Nothing AndAlso row.Cells("Item").Value IsNot DBNull.Value Then
                        name = row.Cells("Item").Value.ToString()
                    End If
                    Dim shortQty As Decimal = Math.Round(req - avail, 4)
                    dtShort.Rows.Add(matId, name, shortQty)
                End If
            End If
        Next

        If dtShort.Rows.Count = 0 Then
            MessageBox.Show("No shortages found for Raw Materials.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If

        Using dlg As New CreateShortagePOForm(AppSession.CurrentBranchID, id, dtShort)
            dlg.ShowDialog(Me)
        End Using
        ' Refresh Stockroom dashboard counts if open
        Try
            For Each f As Form In Application.OpenForms
                If TypeOf f Is Stockroom.StockroomDashboardForm Then
                    CType(f, Stockroom.StockroomDashboardForm).RefreshData()
                End If
            Next
        Catch
        End Try
    End Sub

    ' Auto-pick the most recent Received IO and open the shortages dialog if shortages exist
    Public Sub AutoOpenShortagePO()
        Try
            ' Ensure lists loaded
            LoadReceivedList()
            If cboReceived Is Nothing OrElse cboReceived.Items.Count = 0 Then Return
            ' Select the first (most recent) received IO
            cboReceived.SelectedIndex = 0
            ' Load lines for selection
            LoadLinesForSelected()
            ' If shortages detected, the Create PO button will be enabled
            If btnCreatePO.Enabled Then
                OnCreatePOForShortages(Me, EventArgs.Empty)
            End If
        Catch
            ' swallow
        End Try
    End Sub

    Private Sub OnWorkloadClicked(sender As Object, e As EventArgs)
        ' Show today's workload per manufacturer from RetailOrdersToday
        Try
            Using cn As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                cn.Open()
                Using cmd As New SqlCommand("WITH M AS ( " & _
                                            "  SELECT u.UserID, (u.FirstName + ' ' + u.LastName) AS FullName " & _
                                            "  FROM dbo.Users u JOIN dbo.Roles r ON r.RoleID=u.RoleID " & _
                                            "  WHERE r.RoleName IN (N'Manufacturing-Manager', N'MM', N'Manufacturer') OR r.RoleName LIKE N'Manufactur%' " & _
                                            "), T AS ( " & _
                                            "  SELECT ManufacturerUserID, COUNT(1) AS Orders, COALESCE(SUM(Qty),0) AS TotalQty " & _
                                            "  FROM dbo.RetailOrdersToday WHERE OrderDate=@d GROUP BY ManufacturerUserID " & _
                                            ") " & _
                                            "SELECT M.FullName AS Mfg, COALESCE(T.Orders,0) AS Orders, COALESCE(T.TotalQty,0) AS TotalQty " & _
                                            "FROM M LEFT JOIN T ON T.ManufacturerUserID = M.UserID " & _
                                            "ORDER BY M.FullName;", cn)
                    cmd.Parameters.AddWithValue("@d", Services.TimeProvider.Today())
                    Using r = cmd.ExecuteReader()
                        Dim lines As New List(Of String)()
                        lines.Add("Today's Workload by Manufacturer:")
                        While r.Read()
                            Dim name As String = If(r("Mfg") Is DBNull.Value, "Unassigned", Convert.ToString(r("Mfg")))
                            Dim orders As Integer = If(r("Orders") Is DBNull.Value, 0, Convert.ToInt32(r("Orders")))
                            Dim qty As Decimal = If(r("TotalQty") Is DBNull.Value, 0D, Convert.ToDecimal(r("TotalQty")))
                            lines.Add($" - {name}: {orders} orders, Qty {qty}")
                        End While
                        MessageBox.Show(String.Join(Environment.NewLine, lines), "Today's Workload", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to load workload: " & ex.Message, "Workload", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SaveManufacturerOnHeader(ioId As Integer, manUserId As Integer)
        If ioId <= 0 OrElse manUserId <= 0 Then Return
        Using cn As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            cn.Open()
            ' Read existing notes
            Dim notes As String = ""
            Using cmdR As New SqlCommand("SELECT ISNULL(Notes,'') FROM dbo.InternalOrderHeader WHERE InternalOrderID=@id", cn)
                cmdR.Parameters.AddWithValue("@id", ioId)
                Dim o = cmdR.ExecuteScalar()
                If o IsNot Nothing AndAlso o IsNot DBNull.Value Then notes = Convert.ToString(o)
            End Using
            Dim newNotes As String = UpsertNotesToken(notes, "ManufacturerUserID=", manUserId.ToString())
            Using cmdU As New SqlCommand("UPDATE dbo.InternalOrderHeader SET Notes=@n WHERE InternalOrderID=@id", cn)
                cmdU.Parameters.AddWithValue("@n", newNotes)
                cmdU.Parameters.AddWithValue("@id", ioId)
                cmdU.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Function GetUserFullName(userId As Integer) As String
        If userId <= 0 Then Return "-"
        Try
            Using cn As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                cn.Open()
                Using cmd As New SqlCommand("SELECT COALESCE(NULLIF(LTRIM(RTRIM(FirstName + ' ' + LastName)), ''), Username) FROM dbo.Users WHERE UserID=@u", cn)
                    cmd.Parameters.AddWithValue("@u", userId)
                    Dim o = cmd.ExecuteScalar()
                    If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return Convert.ToString(o)
                End Using
            End Using
        Catch
        End Try
        Return "-"
    End Function

    Private Function ExtractInt(text As String, key As String) As Integer
        Try
            If String.IsNullOrEmpty(text) OrElse String.IsNullOrEmpty(key) Then Return 0
            Dim idx As Integer = text.IndexOf(key, StringComparison.OrdinalIgnoreCase)
            If idx < 0 Then Return 0
            idx += key.Length
            Dim endIdx As Integer = text.IndexOfAny(New Char() {";"c, "|"c, " "c, ","c, ChrW(13), ChrW(10)})
            Dim token As String = If(endIdx >= idx AndAlso endIdx >= 0, text.Substring(idx, Math.Max(0, endIdx - idx)), text.Substring(idx))
            Dim val As Integer
            If Integer.TryParse(token.Trim(), val) Then Return val
        Catch
        End Try
        Return 0
    End Function

    Private Function UpsertNotesToken(notes As String, key As String, value As String) As String
        If notes Is Nothing Then notes = ""
        Dim trimmed = notes.Trim()
        Dim prefix = key
        Dim startIdx = trimmed.IndexOf(prefix, StringComparison.OrdinalIgnoreCase)
        If startIdx < 0 Then
            If trimmed.Length > 0 AndAlso Not trimmed.EndsWith(";") Then trimmed &= "; "
            Return trimmed & prefix & value
        End If
        ' Replace existing value
        Dim after = trimmed.Substring(startIdx + prefix.Length)
        Dim sepIdx = after.IndexOf(";"c)
        Dim beforePart = trimmed.Substring(0, startIdx)
        Dim afterPart As String = ""
        If sepIdx >= 0 Then
            afterPart = after.Substring(sepIdx) ' keep the ; and remainder
        End If
        Dim rebuilt = beforePart
        If Not rebuilt.EndsWith(" ") AndAlso rebuilt.Length > 0 Then rebuilt &= " "
        rebuilt &= prefix & value
        rebuilt &= afterPart
        Return rebuilt.Trim()
    End Function

    ' Recompute enablement of Fulfill/Create PO buttons from the currently loaded lines
    Private Sub RecomputeButtonsFromCurrent()
        Try
            Dim insufficient As Boolean = False
            If dgvLines IsNot Nothing AndAlso dgvLines.Rows IsNot Nothing Then
                For Each row As DataGridViewRow In dgvLines.Rows
                    If row Is Nothing OrElse row.IsNewRow Then Continue For
                    Dim itemType As String = If(row.Cells("ItemType")?.Value, String.Empty).ToString()
                    If Not String.Equals(itemType, "RawMaterial", StringComparison.OrdinalIgnoreCase) Then Continue For
                    Dim req As Decimal = 0D
                    Dim avail As Decimal = 0D
                    If row.Cells("RequestedQty") IsNot Nothing AndAlso row.Cells("RequestedQty").Value IsNot DBNull.Value Then req = Convert.ToDecimal(row.Cells("RequestedQty").Value)
                    If row.Cells("AvailableQty") IsNot Nothing AndAlso row.Cells("AvailableQty").Value IsNot DBNull.Value Then avail = Convert.ToDecimal(row.Cells("AvailableQty").Value)
                    If req > avail Then
                        insufficient = True
                        Exit For
                    End If
                Next
            End If

            Dim hasManufacturer As Boolean = (_manufacturerUserId > 0)
            If Me.btnFulfill IsNot Nothing Then Me.btnFulfill.Enabled = (Not insufficient) AndAlso hasManufacturer
            If Me.btnCreatePO IsNot Nothing Then Me.btnCreatePO.Enabled = insufficient
        Catch
            ' conservative fallback
            If Me.btnFulfill IsNot Nothing Then Me.btnFulfill.Enabled = False
            If Me.btnCreatePO IsNot Nothing Then Me.btnCreatePO.Enabled = False
        End Try
    End Sub

End Class

End Namespace
