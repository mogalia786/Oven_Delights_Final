Imports System.Windows.Forms
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports Oven_Delights_ERP.UI

Public Class InvoiceEditorForm
    Inherits Form

    Private ReadOnly service As New StockroomService()

    ' Search controls
    Private pnlSearch As Panel
    Private lblSupplier As Label
    Private cboSupplier As ComboBox
    Private lblPO As Label
    Private cboPO As ComboBox
    Private lblFrom As Label
    Private dtpFrom As DateTimePicker
    Private lblTo As Label
    Private dtpTo As DateTimePicker
    Private lblFind As Label
    Private txtFind As TextBox
    Private btnLoad As Button

    ' Results and edit
    Private dgvResults As DataGridView
    Private lblLines As Label
    Private dgvLines As DataGridView

    ' Totals & actions
    Private lblSubTotal As Label
    Private txtSubTotal As TextBox
    Private lblVat As Label
    Private txtVat As TextBox
    Private lblTotal As Label
    Private txtTotal As TextBox
    Private btnSave As Button
    Private btnClose As Button

    ' State
    Private ReadOnly _branchId As Integer
    Private ReadOnly _userId As Integer
    Private WithEvents cboProduct As ComboBox
    Private currentInvoiceId As Integer = 0
    Private isBindingTopGrid As Boolean = False

    ' Parameterless constructor for Designer only
    Public Sub New()
        InitializeComponent()
        Me.Text = "View / Edit Invoices"
        Me.WindowState = FormWindowState.Maximized
        ' Wire events outside InitializeComponent to avoid designer errors
        AddHandler Me.Load, AddressOf InvoiceEditorForm_Load
    End Sub

    Private Sub InvoiceEditorForm_Load(sender As Object, e As EventArgs)
        Try
            AddHandler btnLoad.Click, AddressOf btnLoad_Click
            AddHandler cboSupplier.SelectedIndexChanged, AddressOf cboSupplier_SelectedIndexChanged
            AddHandler dtpFrom.ValueChanged, AddressOf OnDateFilterChanged
            AddHandler dtpTo.ValueChanged, AddressOf OnDateFilterChanged
            AddHandler dgvResults.SelectionChanged, AddressOf dgvResults_SelectionChanged
            AddHandler dgvResults.CellClick, AddressOf dgvResults_CellClick
            AddHandler dgvLines.CellValueChanged, AddressOf dgvLines_CellValueChanged
            AddHandler dgvLines.CurrentCellDirtyStateChanged, Sub(s, ea) If dgvLines.IsCurrentCellDirty Then dgvLines.CommitEdit(DataGridViewDataErrorContexts.Commit)
            AddHandler dgvLines.DataBindingComplete, AddressOf dgvLines_DataBindingComplete
        Catch
        End Try
    End Sub

    Private Sub cboPO_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadInvoiceForSelectedPO()
    End Sub

    Private Sub LoadInvoiceForSelectedPO()
        If cboSupplier.SelectedValue Is Nothing OrElse cboPO.SelectedValue Is Nothing Then
            Return
        End If
        Dim supId As Integer
        Dim poKey As Object = cboPO.SelectedValue
        If Not Integer.TryParse(cboSupplier.SelectedValue.ToString(), supId) Then Return

        Try
            ' Expected: a single invoice associated to the selected PO
            ' Prefer an explicit method by supplier+PO; fallback to by PO only
            Dim invHeader As DataTable = Nothing
            Try
                invHeader = service.GetInvoiceBySupplierPO(supId, poKey)
            Catch
                Try
                    invHeader = service.GetInvoiceByPO(poKey)
                Catch
                End Try
            End Try

            Dim header As New DataTable()
            header.Columns.Add("InvoiceID", GetType(Integer))
            header.Columns.Add("Supplier", GetType(String))
            header.Columns.Add("GRNID", GetType(Integer))
            header.Columns.Add("PONumber", GetType(String))
            header.Columns.Add("Date", GetType(Date))
            header.Columns.Add("Total", GetType(Decimal))

            Dim invoiceId As Integer = 0
            If invHeader IsNot Nothing AndAlso invHeader.Rows.Count > 0 Then
                Dim r = invHeader.Rows(0)
                invoiceId = If(invHeader.Columns.Contains("InvoiceID"), CInt(r("InvoiceID")), 0)
                Dim h = header.NewRow()
                h("InvoiceID") = invoiceId
                h("Supplier") = If(invHeader.Columns.Contains("Supplier"), r("Supplier"), cboSupplier.Text)
                h("GRNID") = If(invHeader.Columns.Contains("GRNID"), r("GRNID"), 0)
                h("PONumber") = If(invHeader.Columns.Contains("PONumber"), r("PONumber"), cboPO.Text)
                h("Date") = If(invHeader.Columns.Contains("InvoiceDate"), r("InvoiceDate"), Date.Now.Date)
                h("Total") = If(invHeader.Columns.Contains("Total"), r("Total"), 0D)
                header.Rows.Add(h)
            End If

            dgvResults.DataSource = header
            currentInvoiceId = invoiceId
            If invoiceId > 0 Then
                LoadInvoiceLines(invoiceId)
            Else
                dgvLines.Rows.Clear()
                RecalcTotals()
            End If
        Catch
            ' Keep UI responsive even if backend missing
        End Try
    End Sub

    Public Sub New(branchId As Integer, userId As Integer)
        InitializeComponent()
        Me.Text = "View / Edit Invoices"
        Me.WindowState = FormWindowState.Maximized
        _branchId = branchId
        _userId = userId
        
        ' Create and setup product dropdown
        If pnlSearch IsNot Nothing Then
            ' Load products using ProductDropdown helper
            Try
                Dim txtSKU As New TextBox()
                txtSKU.Left = 300
                txtSKU.Top = 8
                txtSKU.Width = 280
                cboProduct = UI.ProductDropdown.Create(Me, txtSKU)
                pnlSearch.Controls.Add(cboProduct)
            Catch
            End Try
        End If
        
        SafeLoadSuppliers()
    End Sub

    Private Sub InitializeComponent()
        ' Search panel
        pnlSearch = New Panel() With {.Dock = DockStyle.Top, .Height = 64, .Padding = New Padding(8)}
        lblSupplier = New Label() With {.Text = "Supplier:", .AutoSize = True, .Left = 8, .Top = 12}
        cboSupplier = New ComboBox() With {.Left = 70, .Top = 8, .Width = 220, .DropDownStyle = ComboBoxStyle.DropDownList}
        ' PO dropdown removed from filter; POs are listed in the top grid after Load
        lblFrom = New Label() With {.Text = "From:", .AutoSize = True, .Left = 600, .Top = 12}
        dtpFrom = New DateTimePicker() With {.Left = 640, .Top = 8, .Format = DateTimePickerFormat.Custom, .CustomFormat = "dd MMM yyyy"}
        lblTo = New Label() With {.Text = "To:", .AutoSize = True, .Left = 792, .Top = 12}
        dtpTo = New DateTimePicker() With {.Left = 820, .Top = 8, .Format = DateTimePickerFormat.Custom, .CustomFormat = "dd MMM yyyy"}
        btnLoad = New Button() With {.Left = 1010, .Top = 8, .Width = 100, .Text = "Load"}
        pnlSearch.Controls.AddRange(New Control() {lblSupplier, cboSupplier, lblFrom, dtpFrom, lblTo, dtpTo, btnLoad})

        ' Results grid
        dgvResults = New DataGridView() With {.Dock = DockStyle.Top, .Height = 180, .ReadOnly = True, .SelectionMode = DataGridViewSelectionMode.FullRowSelect, .AllowUserToAddRows = False, .AllowUserToDeleteRows = False, .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill}

        lblLines = New Label() With {.Text = "Invoice Lines (editable: ReceiveNow, CreditReason, CreditComments)", .Dock = DockStyle.Top, .Height = 24, .Padding = New Padding(8, 4, 0, 0)}

        ' Lines grid (editable subset)
        dgvLines = New DataGridView() With {.Dock = DockStyle.Fill, .AllowUserToAddRows = False, .AllowUserToDeleteRows = False, .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill, .RowHeadersVisible = False}
        ' Define columns (match capture names for reuse)
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "POLineID", .HeaderText = "POLineID", .Visible = False})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "MaterialID", .HeaderText = "MaterialID", .Visible = False})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "MaterialCode", .HeaderText = "Code", .ReadOnly = True})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "MaterialName", .HeaderText = "Material", .ReadOnly = True})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "OrderedQuantity", .HeaderText = "Ordered", .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N2"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ReceivedQuantityToDate", .HeaderText = "Received TD", .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N2"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ReceiveNow", .HeaderText = "Receive Now", .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N2"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "UnitCost", .HeaderText = "Unit Cost", .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N2"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "LastCost", .HeaderText = "Last Cost", .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N2"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "AverageCost", .HeaderText = "Avg Cost", .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N2"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ReturnQty", .HeaderText = "Return Qty", .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N2"}})
        Dim reasonCol As New DataGridViewComboBoxColumn() With {.Name = "CreditReason", .HeaderText = "Credit Reason"}
        reasonCol.Items.AddRange(New Object() {"No Credit Note", "Short-supply", "Damaged/Expired"})
        dgvLines.Columns.Add(reasonCol)
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "CreditComments", .HeaderText = "Comments"})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "LineTotal", .HeaderText = "Line Total", .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N2"}})

        ' Event handlers moved to Load to keep InitializeComponent designer-safe

        ' Bottom totals/actions panel
        Dim pnlBottomHost As New Panel() With {.Dock = DockStyle.Bottom, .Height = 64}
        lblSubTotal = New Label() With {.Text = "SubTotal:", .Left = 560, .Top = 12}
        txtSubTotal = New TextBox() With {.Left = 630, .Top = 8, .Width = 100, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right}
        lblVat = New Label() With {.Text = "VAT:", .Left = 740, .Top = 12}
        txtVat = New TextBox() With {.Left = 770, .Top = 8, .Width = 100, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right}
        lblTotal = New Label() With {.Text = "Total:", .Left = 880, .Top = 12}
        txtTotal = New TextBox() With {.Left = 920, .Top = 8, .Width = 120, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right}
        btnSave = New Button() With {.Left = 8, .Top = 8, .Width = 100, .Text = "Save"}
        btnClose = New Button() With {.Left = 116, .Top = 8, .Width = 100, .Text = "Close"}
        AddHandler btnSave.Click, AddressOf btnSave_Click
        AddHandler btnClose.Click, Sub() Me.Close()
        pnlBottomHost.Controls.AddRange(New Control() {btnSave, btnClose, lblSubTotal, txtSubTotal, lblVat, txtVat, lblTotal, txtTotal})

        ' Form layout
        Me.Controls.AddRange(New Control() {dgvLines, lblLines, dgvResults, pnlSearch, pnlBottomHost})
        Me.Padding = New Padding(0)
        Theme.Apply(Me)
    End Sub

    ' Load ALL invoices (captured invoices) by optional Supplier and Date range
    Private Sub btnLoad_Click(sender As Object, e As EventArgs)
        Try
            Dim supId As Integer = 0
            If cboSupplier.SelectedValue IsNot Nothing Then
                Integer.TryParse(cboSupplier.SelectedValue.ToString(), supId)
            End If
            Dim fromD As Date = dtpFrom.Value.Date
            Dim toD As Date = dtpTo.Value.Date

            Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Dim dt As New DataTable()
            Using con As New Microsoft.Data.SqlClient.SqlConnection(cs)
                con.Open()
                ' Keep this query minimal to avoid referencing non-existent columns
                Dim sql As String = "SELECT i.InvoiceID, s.CompanyName AS Supplier, i.InvoiceDate AS [Date], i.Total " &
                                    "FROM Invoices i " &
                                    "LEFT JOIN Suppliers s ON s.SupplierID = i.SupplierID " &
                                    "WHERE (@sid = 0 OR i.SupplierID = @sid) " &
                                    "ORDER BY i.InvoiceDate DESC, i.InvoiceID DESC"
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@sid", supId)
                    Using da As New Microsoft.Data.SqlClient.SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
                ' Fallback: if no invoices found, load POs (use columns that exist in your DB)
                If dt IsNot Nothing AndAlso dt.Rows.Count = 0 Then
                    Dim dtPO As New DataTable()
                    Dim sqlPO As String = "SELECT p.PurchaseOrderID AS POID, COALESCE(p.SupplierName, s.CompanyName, '') AS Supplier, " &
                                          "p.Status " &
                                          "FROM PurchaseOrders p " &
                                          "LEFT JOIN Suppliers s ON s.SupplierID = p.SupplierID " &
                                          "WHERE (@sid = 0 OR p.SupplierID = @sid) " &
                                          "ORDER BY p.PurchaseOrderID DESC"
                    Using cmdPO As New Microsoft.Data.SqlClient.SqlCommand(sqlPO, con)
                        cmdPO.Parameters.AddWithValue("@sid", supId)
                        Using daPO As New Microsoft.Data.SqlClient.SqlDataAdapter(cmdPO)
                            daPO.Fill(dtPO)
                        End Using
                    End Using
                    dt = dtPO
                End If
            End Using

            dgvResults.DataSource = dt
            ' Basic formatting
            If dgvResults.Columns.Contains("InvoiceID") Then dgvResults.Columns("InvoiceID").HeaderText = "Invoice ID"
            If dgvResults.Columns.Contains("POID") Then dgvResults.Columns("POID").HeaderText = "PO ID"
            If dgvResults.Columns.Contains("Status") Then dgvResults.Columns("Status").HeaderText = "Status"
            If dgvResults.Columns.Contains("Total") Then dgvResults.Columns("Total").DefaultCellStyle.Format = "N2"
        Catch
            dgvResults.DataSource = Nothing
        End Try
    End Sub

    ' Ensure ReceiveNow starts at 0 for all rows after data binding
    Private Sub dgvLines_DataBindingComplete(sender As Object, e As DataGridViewBindingCompleteEventArgs)
        Try
            For Each r As DataGridViewRow In dgvLines.Rows
                If r.Cells("ReceiveNow").Value Is Nothing OrElse Not Decimal.TryParse(Convert.ToString(r.Cells("ReceiveNow").Value), New Decimal()) Then
                    r.Cells("ReceiveNow").Value = 0D
                End If
            Next
        Catch
        End Try
    End Sub

    Private Sub SafeLoadSuppliers()
        Try
            Dim dt = service.GetAllSuppliers()
            cboSupplier.DisplayMember = "Name"
            cboSupplier.ValueMember = "ID"
            cboSupplier.DataSource = dt
            cboSupplier.SelectedIndex = -1
        Catch
            ' Ignore; allow manual filtering by text
        End Try
    End Sub

    Private Sub cboSupplier_SelectedIndexChanged(sender As Object, e As EventArgs)
        ' PO dropdown removed; loading is performed via the Load button into the top grid
    End Sub

    Private Sub LoadSupplierPOs(supplierId As Integer)
        ' No-op: PO dropdown removed; use Load button to populate the top grid with POs
    End Sub

    Private Sub OnDateFilterChanged(sender As Object, e As EventArgs)
        ' No-op until user clicks Load; then we list POs in the top grid
    End Sub

    Private Sub Obsolete_dgvResults_SelectionChanged_Early(sender As Object, e As EventArgs)
        ' no-op (earlier duplicate; active implementation exists later in file)
    End Sub

    Private Sub Obsolete_dgvResults_CellClick_Early(sender As Object, e As DataGridViewCellEventArgs)
        ' no-op (earlier duplicate; active implementation exists later in file)
        Return
    End Sub

    Private Sub LoadInvoiceLines(invoiceId As Integer)
        dgvLines.Rows.Clear()
        ' Attempt to load lines from service; fallback to empty if unavailable
        Dim dt As DataTable = Nothing
        Try
            dt = service.GetInvoiceLines(invoiceId)
        Catch
        End Try
        If dt Is Nothing Then
            ' Show blank editable grid allowing the three fields to be changed if lines are bound later
            RecalcTotals()
            Return
        End If
        For Each r As DataRow In dt.Rows
            Dim idx = dgvLines.Rows.Add()
            Dim row = dgvLines.Rows(idx)
            row.Cells("POLineID").Value = If(r.Table.Columns.Contains("POLineID") AndAlso Not IsDBNull(r("POLineID")), r("POLineID"), 0)
            row.Cells("MaterialID").Value = If(r.Table.Columns.Contains("MaterialID") AndAlso Not IsDBNull(r("MaterialID")), r("MaterialID"), 0)
            row.Cells("MaterialCode").Value = GetStr(r, "MaterialCode")
            row.Cells("MaterialName").Value = GetStr(r, "MaterialName")
            row.Cells("OrderedQuantity").Value = GetDec(r, "OrderedQuantity")
            row.Cells("ReceivedQuantityToDate").Value = GetDec(r, "ReceivedQuantityToDate")
            row.Cells("ReceiveNow").Value = GetDec(r, "ReceiveNow")
            row.Cells("UnitCost").Value = GetDec(r, "UnitCost")
            row.Cells("LastCost").Value = GetDec(r, "LastCost")
            row.Cells("AverageCost").Value = GetDec(r, "AverageCost")
            row.Cells("ReturnQty").Value = GetDec(r, "ReturnQty")
            row.Cells("CreditReason").Value = GetStr(r, "CreditReason")
            row.Cells("CreditComments").Value = GetStr(r, "CreditComments")
            row.Cells("LineTotal").Value = Math.Round(GetDec(r, "ReceiveNow") * GetDec(r, "UnitCost"), 2)

            ' Enrich missing fields (Material/Ordered/ReceivedTD) if not provided by service
            Try
                Dim matName As String = Convert.ToString(row.Cells("MaterialName").Value)
                Dim matCode As String = Convert.ToString(row.Cells("MaterialCode").Value)
                Dim orderedQ As Decimal = ToDec(row.Cells("OrderedQuantity").Value)
                Dim recTdQ As Decimal = ToDec(row.Cells("ReceivedQuantityToDate").Value)
                ' 1) If we have a MaterialID, fetch Code/Name from Materials first
                Dim materialId As Integer = 0
                If row.Cells("MaterialID").Value IsNot Nothing Then Integer.TryParse(row.Cells("MaterialID").Value.ToString(), materialId)
                If materialId > 0 AndAlso (String.IsNullOrWhiteSpace(matName) OrElse String.IsNullOrWhiteSpace(matCode)) Then
                    Dim csM = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                    Using conM As New Microsoft.Data.SqlClient.SqlConnection(csM)
                        conM.Open()
                        Using cmdM As New Microsoft.Data.SqlClient.SqlCommand("SELECT Code, Name FROM Materials WHERE MaterialID = @mid", conM)
                            cmdM.Parameters.AddWithValue("@mid", materialId)
                            Using rdM = cmdM.ExecuteReader()
                                If rdM.Read() Then
                                    If String.IsNullOrWhiteSpace(matCode) AndAlso Not rdM.IsDBNull(rdM.GetOrdinal("Code")) Then row.Cells("MaterialCode").Value = rdM("Code").ToString()
                                    If String.IsNullOrWhiteSpace(matName) AndAlso Not rdM.IsDBNull(rdM.GetOrdinal("Name")) Then row.Cells("MaterialName").Value = rdM("Name").ToString()
                                    matName = Convert.ToString(row.Cells("MaterialName").Value)
                                    matCode = Convert.ToString(row.Cells("MaterialCode").Value)
                                End If
                            End Using
                        End Using
                    End Using
                End If
                Dim poLineId As Integer = 0
                If row.Cells("POLineID").Value IsNot Nothing Then Integer.TryParse(row.Cells("POLineID").Value.ToString(), poLineId)
                If (String.IsNullOrWhiteSpace(matName) OrElse orderedQ = 0D) AndAlso poLineId > 0 Then
                    Dim cs2 = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                    Using con2 As New Microsoft.Data.SqlClient.SqlConnection(cs2)
                        con2.Open()
                        Dim sql2 As String = "SELECT pol.OrderedQuantity, pol.ReceivedQuantity AS ReceivedQuantity, m.Code AS MaterialCode, m.Name AS MaterialName " &
                                             "FROM PurchaseOrderLines pol " &
                                             "LEFT JOIN Materials m ON m.MaterialID = pol.MaterialID " &
                                             "WHERE pol.POLineID = @id"
                        Using cmd2 As New Microsoft.Data.SqlClient.SqlCommand(sql2, con2)
                            cmd2.Parameters.AddWithValue("@id", poLineId)
                            Using rd = cmd2.ExecuteReader()
                                If rd.Read() Then
                                    If String.IsNullOrWhiteSpace(matName) Then
                                        If Not rd.IsDBNull(rd.GetOrdinal("MaterialCode")) Then row.Cells("MaterialCode").Value = rd("MaterialCode").ToString()
                                        If Not rd.IsDBNull(rd.GetOrdinal("MaterialName")) Then row.Cells("MaterialName").Value = rd("MaterialName").ToString()
                                    End If
                                    If orderedQ = 0D AndAlso Not rd.IsDBNull(rd.GetOrdinal("OrderedQuantity")) Then row.Cells("OrderedQuantity").Value = Convert.ToDecimal(rd("OrderedQuantity"))
                                    If recTdQ = 0D AndAlso Not rd.IsDBNull(rd.GetOrdinal("ReceivedQuantity")) Then row.Cells("ReceivedQuantityToDate").Value = Convert.ToDecimal(rd("ReceivedQuantity"))
                                End If
                            End Using
                        End Using
                    End Using
                End If
            Catch
                ' Non-fatal enrichment
            End Try
        Next
        RecalcTotals()
    End Sub

    ' Keep the top grid simple: selecting a row loads the invoice lines by InvoiceID
    Private Sub dgvResults_SelectionChanged(sender As Object, e As EventArgs)
        If dgvResults Is Nothing OrElse dgvResults.CurrentRow Is Nothing Then Return
        Try
            Dim invId As Integer = 0
            ' 1) If the grid has InvoiceID, use it directly
            If dgvResults.Columns.Contains("InvoiceID") Then
                Dim v = dgvResults.CurrentRow.Cells("InvoiceID").Value
                If v IsNot Nothing Then Integer.TryParse(v.ToString(), invId)
            End If

            ' 2) If no InvoiceID, resolve from POID using multiple paths
            If invId = 0 AndAlso dgvResults.Columns.Contains("POID") Then
                Dim poId As Integer = 0
                Dim rawPO = dgvResults.CurrentRow.Cells("POID").Value
                If rawPO IsNot Nothing Then Integer.TryParse(rawPO.ToString(), poId)
                If poId > 0 Then
                    Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                    ' Path A: Invoices.POID
                    Try
                        Using con As New Microsoft.Data.SqlClient.SqlConnection(cs)
                            con.Open()
                            Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT TOP 1 i.InvoiceID FROM Invoices i WHERE i.POID = @poid", con)
                                cmd.Parameters.AddWithValue("@poid", poId)
                                Dim obj As Object = cmd.ExecuteScalar()
                                If obj IsNot Nothing AndAlso Not Convert.IsDBNull(obj) Then Integer.TryParse(obj.ToString(), invId)
                            End Using
                        End Using
                    Catch
                    End Try
                    ' Path B: Invoices.PurchaseOrderID
                    If invId = 0 Then
                        Try
                            Using con As New Microsoft.Data.SqlClient.SqlConnection(cs)
                                con.Open()
                                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT TOP 1 i.InvoiceID FROM Invoices i WHERE i.PurchaseOrderID = @poid", con)
                                    cmd.Parameters.AddWithValue("@poid", poId)
                                    Dim obj As Object = cmd.ExecuteScalar()
                                    If obj IsNot Nothing AndAlso Not Convert.IsDBNull(obj) Then Integer.TryParse(obj.ToString(), invId)
                                End Using
                            End Using
                        Catch
                        End Try
                    End If
                    ' Path C: InvoicePOMap.PurchaseOrderID
                    If invId = 0 Then
                        Try
                            Using con As New Microsoft.Data.SqlClient.SqlConnection(cs)
                                con.Open()
                                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT TOP 1 m.InvoiceID FROM InvoicePOMap m WHERE m.PurchaseOrderID = @poid", con)
                                    cmd.Parameters.AddWithValue("@poid", poId)
                                    Dim obj As Object = cmd.ExecuteScalar()
                                    If obj IsNot Nothing AndAlso Not Convert.IsDBNull(obj) Then Integer.TryParse(obj.ToString(), invId)
                                End Using
                            End Using
                        Catch
                        End Try
                    End If
                End If
            End If

            currentInvoiceId = invId
            If invId > 0 Then
                LoadInvoiceLines(invId)
            Else
                dgvLines.Rows.Clear()
                RecalcTotals()
            End If
        Catch ex As Exception
            MessageBox.Show("Unable to load selection: " & ex.Message, "Load", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub dgvResults_CellClick(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex < 0 Then Return
        dgvResults_SelectionChanged(sender, EventArgs.Empty)
    End Sub

    Private Sub dgvLines_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex < 0 Then Return
        Dim col = dgvLines.Columns(e.ColumnIndex).Name
        If col = "ReceiveNow" OrElse col = "UnitCost" OrElse col = "ReturnQty" OrElse col = "CreditReason" Then
            Dim row = dgvLines.Rows(e.RowIndex)
            Dim qty = ToDec(row.Cells("ReceiveNow").Value)
            Dim cost = ToDec(row.Cells("UnitCost").Value)
            row.Cells("LineTotal").Value = Math.Round(qty * cost, 2)
            RecalcTotals()
        End If
    End Sub

    Private Function ToDec(v As Object) As Decimal
        If v Is Nothing OrElse v Is DBNull.Value Then Return 0D
        Dim d As Decimal
        If Decimal.TryParse(v.ToString(), d) Then Return d
        Return 0D
    End Function

    Private Function GetDec(dr As DataRow, col As String) As Decimal
        If dr Is Nothing OrElse String.IsNullOrEmpty(col) Then Return 0D
        If dr.Table Is Nothing OrElse Not dr.Table.Columns.Contains(col) Then Return 0D
        Dim v = dr(col)
        If v Is Nothing OrElse v Is DBNull.Value Then Return 0D
        Dim d As Decimal
        If Decimal.TryParse(v.ToString(), d) Then Return d
        Return 0D
    End Function

    Private Function GetStr(dr As DataRow, col As String) As String
        If dr Is Nothing OrElse String.IsNullOrEmpty(col) Then Return String.Empty
        If dr.Table Is Nothing OrElse Not dr.Table.Columns.Contains(col) Then Return String.Empty
        Dim v = dr(col)
        If v Is Nothing OrElse v Is DBNull.Value Then Return String.Empty
        Return v.ToString()
    End Function

    Private Sub RecalcTotals()
        Dim subTot As Decimal = 0D
        For Each row As DataGridViewRow In dgvLines.Rows
            If Not row.IsNewRow Then
                subTot += ToDec(row.Cells("ReceiveNow").Value) * ToDec(row.Cells("UnitCost").Value)
            End If
        Next
        subTot = Math.Round(subTot, 2)
        Dim vatRate As Decimal = GetVatRate()
        Dim vat As Decimal = Math.Round(subTot * (vatRate / 100D), 2)
        Dim total As Decimal = Math.Round(subTot + vat, 2)
        If txtSubTotal IsNot Nothing Then txtSubTotal.Text = subTot.ToString("N2")
        If txtVat IsNot Nothing Then txtVat.Text = vat.ToString("N2")
        If txtTotal IsNot Nothing Then txtTotal.Text = total.ToString("N2")
    End Sub

    Private Function GetVatRate() As Decimal
        Try
            Dim cs = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Using con As New Microsoft.Data.SqlClient.SqlConnection(cs)
                con.Open()
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT [Value] FROM SystemSettings WHERE [Key]='VATRatePercent'", con)
                    Dim obj As Object = cmd.ExecuteScalar()
                    If obj IsNot Nothing AndAlso Not Convert.IsDBNull(obj) Then
                        Dim s = obj.ToString()
                        Dim r As Decimal
                        If Decimal.TryParse(s, r) Then Return r
                    End If
                End Using
            End Using
        Catch
        End Try
        Return 15D
    End Function

    Private Sub btnSave_Click(sender As Object, e As EventArgs)
        If currentInvoiceId <= 0 Then
            MessageBox.Show("Select an invoice to edit.", "Edit Invoice", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        ' Build edited lines table (only the allowed fields are considered)
        Dim edited As New DataTable()
        edited.Columns.Add("POLineID", GetType(Integer))
        edited.Columns.Add("ReceiveNow", GetType(Decimal))
        edited.Columns.Add("UnitCost", GetType(Decimal))
        edited.Columns.Add("ReturnQty", GetType(Decimal))
        edited.Columns.Add("CreditReason", GetType(String))
        edited.Columns.Add("CreditComments", GetType(String))
        Dim anyReceiveNow As Boolean = False
        ' Validate credit reason when short-receiving
        For Each row As DataGridViewRow In dgvLines.Rows
            If row.IsNewRow Then Continue For
            Dim ordered As Decimal = ToDec(row.Cells("OrderedQuantity").Value)
            Dim recTD As Decimal = ToDec(row.Cells("ReceivedQuantityToDate").Value)
            Dim outstanding As Decimal = Math.Max(0D, ordered - recTD)
            Dim recvNow As Decimal = ToDec(row.Cells("ReceiveNow").Value)
            If recvNow < outstanding AndAlso recvNow > 0D Then
                Dim reason As String = If(row.Cells("CreditReason").Value, String.Empty).ToString()
                If String.IsNullOrWhiteSpace(reason) OrElse String.Equals(reason, "No Credit Note", StringComparison.OrdinalIgnoreCase) Then
                    dgvLines.CurrentCell = row.Cells("CreditReason")
                    MessageBox.Show("Please select a Credit Reason when receiving less than the outstanding quantity.", "Reason required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
            End If
        Next
        For Each row As DataGridViewRow In dgvLines.Rows
            If row.IsNewRow Then Continue For
            Dim r = edited.NewRow()
            r("POLineID") = If(row.Cells("POLineID").Value Is Nothing, 0, CInt(row.Cells("POLineID").Value))
            r("ReceiveNow") = ToDec(row.Cells("ReceiveNow").Value)
            r("UnitCost") = ToDec(row.Cells("UnitCost").Value)
            r("ReturnQty") = ToDec(row.Cells("ReturnQty").Value)
            r("CreditReason") = If(row.Cells("CreditReason").Value, "")
            r("CreditComments") = If(row.Cells("CreditComments").Value, "")
            edited.Rows.Add(r)
            If Not anyReceiveNow AndAlso ToDec(row.Cells("ReceiveNow").Value) > 0D Then anyReceiveNow = True
        Next
        If Not anyReceiveNow Then
            MessageBox.Show("Enter a quantity in 'Receive Now' for at least one line before saving.", "Nothing Received", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        Try
            ' Call service to persist edits (append-only CN, journals/ledger/stock deltas)
            service.UpdateInvoiceWithJournal(currentInvoiceId, edited, currentUserId)
            MessageBox.Show("Invoice updated and journal adjusted.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Unable to update invoice: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
