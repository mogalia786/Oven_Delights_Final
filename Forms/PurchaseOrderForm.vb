' PurchaseOrderForm.vb
' Functional purchase order MDI child: supplier autocomplete, branch, dates, lines grid, totals, save
Imports System.Windows.Forms
Imports System.Data
Imports System.Drawing
Imports System.IO
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports Oven_Delights_ERP.UI
Imports Oven_Delights_ERP.Accounting

Public Class PurchaseOrderForm
    Inherits Form
    Implements UI.ISidebarProvider

    Private ReadOnly service As New StockroomService()
    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private currentBranchId As Integer
    Private isSuperAdmin As Boolean

    ' Header controls
    Private lblSupplier As Label
    Private txtSupplier As TextBox
    Private lblBranch As Label
    Private cboBranch As ComboBox
    Private lblOrderDate As Label
    Private dtpOrderDate As DateTimePicker
    Private lblRequiredDate As Label
    Private dtpRequiredDate As DateTimePicker
    Private lblReference As Label
    Private txtReference As TextBox
    Private lblNotes As Label
    Private txtNotes As TextBox
    Private lblPONumber As Label

    ' Lines grid
    Private dgvLines As DataGridView

    ' Product type indicator
    Private lblProductType As Label
    Private cboProductType As ComboBox

    ' Totals
    Private lblSubTotal As Label
    Private txtSubTotal As TextBox
    Private lblVAT As Label
    Private txtVAT As TextBox
    Private lblTotal As Label
    Private txtTotal As TextBox

    ' Actions
    Private btnSave As Button

    ' Dashboard panel (removed to honor single left sidebar layout)

    ' Lookups
    Private suppliers As DataTable
    Private materials As DataTable
    Private branches As DataTable

    Public Sub New()
        Me.WindowState = FormWindowState.Maximized
        Me.Text = "Purchase Order"

        ' Initialize branch and role info
        currentBranchId = service.GetCurrentUserBranchId()
        isSuperAdmin = service.IsCurrentUserSuperAdmin()

        InitializeComponent()
        ' Apply theme after controls are created
        Theme.Apply(Me)
        LoadLookups()
        SetupSupplierAutocomplete()
        SetupMaterialsColumn()
        RecalculateTotals()
    End Sub

    Private Function GetCurrentBranchId() As Integer
        Return AppSession.CurrentBranchID
    End Function

    Private Function CreateJournalHeaderSafe(con As SqlConnection, jDate As Date, reference As String, description As String, fiscalPeriodId As Object, createdBy As Integer, branchId As Integer) As Integer
        ' Try standard stored procedure first
        Try
            Using cmd As New SqlCommand("sp_CreateJournalEntry", con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@JournalDate", jDate)
                cmd.Parameters.AddWithValue("@Reference", reference)
                cmd.Parameters.AddWithValue("@Description", description)
                cmd.Parameters.AddWithValue("@FiscalPeriodID", fiscalPeriodId)
                cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                Dim pOut As New SqlParameter("@JournalID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(pOut)
                cmd.ExecuteNonQuery()
                Return Convert.ToInt32(pOut.Value)
            End Using
        Catch ex As SqlException
            ' If failure is due to NULL JournalNumber, fallback to manual insert with next document number
            If ex.Message IsNot Nothing AndAlso ex.Message.ToLower().Contains("journalnumber") Then
                Dim nextNo = GetNextDocumentNumber(con, "Journal", branchId, createdBy)
                If String.IsNullOrWhiteSpace(nextNo) Then
                    Throw New Exception("Document numbering for 'Journal' is not configured. Please configure DocumentNumbering for DocumentType='Journal'.", ex)
                End If
                Using cmd As New SqlCommand("INSERT INTO dbo.JournalHeaders (JournalNumber, JournalDate, Reference, Description, FiscalPeriodID, CreatedBy, BranchID, IsPosted) " &
                                            "VALUES (@jn, @jd, @ref, @desc, @fp, @cb, @bid, 0); SELECT CAST(SCOPE_IDENTITY() AS int);", con)
                    cmd.Parameters.AddWithValue("@jn", nextNo)
                    cmd.Parameters.AddWithValue("@jd", jDate)
                    cmd.Parameters.AddWithValue("@ref", reference)
                    cmd.Parameters.AddWithValue("@desc", description)
                    cmd.Parameters.AddWithValue("@fp", fiscalPeriodId)
                    cmd.Parameters.AddWithValue("@cb", createdBy)
                    cmd.Parameters.AddWithValue("@bid", branchId)
                    Dim res = cmd.ExecuteScalar()
                    Return Convert.ToInt32(res)
                End Using
            Else
                Throw
            End If
        End Try
    End Function

    Private Function GetNextDocumentNumber(con As SqlConnection, docType As String, branchId As Integer, userId As Integer) As String
        Using cmd As New SqlCommand("sp_GetNextDocumentNumber", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@DocumentType", docType)
            cmd.Parameters.AddWithValue("@BranchID", branchId)
            cmd.Parameters.AddWithValue("@UserID", userId)
            Dim pOut As New SqlParameter("@NextDocNumber", SqlDbType.VarChar, 50)
            pOut.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pOut)
            cmd.ExecuteNonQuery()
            Dim result As Object = pOut.Value
            If result IsNot Nothing AndAlso result IsNot DBNull.Value Then
                Return Convert.ToString(result)
            End If
        End Using
        Return Nothing
    End Function

    Private Sub InitializeComponent()
        ' Header panel
        Dim header As New Panel With {.Dock = DockStyle.Top, .Height = 140, .Padding = New Padding(12)}

        lblSupplier = New Label With {.Text = "Supplier", .AutoSize = True, .Top = 12, .Left = 12}
        txtSupplier = New TextBox With {.Width = 320, .Top = lblSupplier.Top + 18, .Left = 12}

        lblBranch = New Label With {.Text = "Branch", .AutoSize = True, .Top = 12, .Left = 360, .Visible = False}
        cboBranch = New ComboBox With {.Width = 220, .Top = lblBranch.Top + 18, .Left = 360, .DropDownStyle = ComboBoxStyle.DropDownList, .Visible = False}

        lblOrderDate = New Label With {.Text = "Order Date", .AutoSize = True, .Top = 12, .Left = 600}
        dtpOrderDate = New DateTimePicker With {.Top = lblOrderDate.Top + 18, .Left = 600, .Width = 140, .Format = DateTimePickerFormat.Short}

        lblRequiredDate = New Label With {.Text = "Required Date", .AutoSize = True, .Top = 12, .Left = 760}
        dtpRequiredDate = New DateTimePicker With {.Top = lblRequiredDate.Top + 18, .Left = 760, .Width = 140, .Format = DateTimePickerFormat.Short}

        lblReference = New Label With {.Text = "Reference", .AutoSize = True, .Top = 64, .Left = 12}
        txtReference = New TextBox With {.Width = 260, .Top = lblReference.Top + 18, .Left = 12}

        lblNotes = New Label With {.Text = "Notes", .AutoSize = True, .Top = 64, .Left = 290}
        txtNotes = New TextBox With {.Width = 400, .Top = lblNotes.Top + 18, .Left = 290}

        ' Product type indicator
        lblProductType = New Label With {.Text = "Purchase Type", .AutoSize = True, .Top = 64, .Left = 710}
        cboProductType = New ComboBox With {.Width = 150, .Top = lblProductType.Top + 18, .Left = 710, .DropDownStyle = ComboBoxStyle.DropDownList}
        cboProductType.Items.AddRange({"External Product", "Raw Material"})
        cboProductType.SelectedIndex = 1 ' Default to Raw Material
        AddHandler cboProductType.SelectedIndexChanged, AddressOf cboProductType_SelectedIndexChanged

        ' PO Number display (blank until save)
        lblPONumber = New Label With {.Text = "PO: (unsaved)", .AutoSize = True, .Top = 12, .Left = 920, .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold)}

        header.Controls.AddRange(New Control() {lblSupplier, txtSupplier, lblBranch, cboBranch, lblOrderDate, dtpOrderDate, lblRequiredDate, dtpRequiredDate, lblReference, txtReference, lblNotes, txtNotes, lblProductType, cboProductType, lblPONumber})

        ' Lines grid
        dgvLines = New DataGridView With {.Dock = DockStyle.Fill, .AllowUserToAddRows = True, .AllowUserToDeleteRows = True, .AutoGenerateColumns = False}
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "MaterialID", .HeaderText = "MaterialID", .DataPropertyName = "MaterialID", .Visible = False})
        Dim materialColumn As New DataGridViewComboBoxColumn With {.Name = "Material", .HeaderText = "Material", .Width = 300}
        materialColumn.DisplayMember = "MaterialName"
        materialColumn.ValueMember = "MaterialID"
        materialColumn.DefaultCellStyle.NullValue = Nothing
        materialColumn.DefaultCellStyle.DataSourceNullValue = DBNull.Value
        dgvLines.Columns.Add(materialColumn)
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "OrderedQuantity", .HeaderText = "Qty", .DataPropertyName = "OrderedQuantity", .Width = 80, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N2"}})
        ' Optional unit cost (can be blank/null). We keep DataPropertyName = UnitCost to avoid backend changes
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "UnitCost", .HeaderText = "Est. Unit Price", .DataPropertyName = "UnitCost", .Width = 110, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N2"}})
        ' Guidance prices
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LastPaidPrice", .HeaderText = "Last Paid", .ReadOnly = True, .Width = 100, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .ForeColor = Color.FromArgb(90, 90, 90), .Format = "N2"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LastCost", .HeaderText = "Last Cost", .ReadOnly = True, .Width = 100, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .ForeColor = Color.FromArgb(120, 120, 120), .Format = "N2"}})
        ' Expected total uses UnitCost if provided, otherwise LastPaidPrice
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LineTotal", .HeaderText = "Expected Total", .ReadOnly = True, .Width = 120, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N2"}})
        AddHandler dgvLines.CellValueChanged, AddressOf dgvLines_CellValueChanged
        AddHandler dgvLines.EditingControlShowing, AddressOf dgvLines_EditingControlShowing
        AddHandler dgvLines.DataError, AddressOf dgvLines_DataError
        AddHandler dgvLines.CurrentCellDirtyStateChanged, AddressOf dgvLines_CurrentCellDirtyStateChanged
        AddHandler dgvLines.RowsAdded, AddressOf dgvLines_RowsAdded
        AddHandler dgvLines.RowsRemoved, AddressOf dgvLines_RowsRemoved
        ' Style grid with theme
        Theme.StyleGrid(dgvLines)

        ' Footer totals and actions
        Dim footer As New Panel With {.Dock = DockStyle.Bottom, .Height = 60, .Padding = New Padding(12)}
        lblSubTotal = New Label With {.Text = "SubTotal", .AutoSize = True, .Top = 10, .Left = 12}
        txtSubTotal = New TextBox With {.ReadOnly = True, .TextAlign = HorizontalAlignment.Right, .Width = 120, .Top = 28, .Left = 12}
        lblVAT = New Label With {.Text = "VAT (15%)", .AutoSize = True, .Top = 10, .Left = 150}
        txtVAT = New TextBox With {.ReadOnly = True, .TextAlign = HorizontalAlignment.Right, .Width = 100, .Top = 28, .Left = 150}
        lblTotal = New Label With {.Text = "Total", .AutoSize = True, .Top = 10, .Left = 270}
        txtTotal = New TextBox With {.ReadOnly = True, .TextAlign = HorizontalAlignment.Right, .Width = 120, .Top = 28, .Left = 270}

        btnSave = New Button With {.Text = "Save", .Width = 120, .Height = 30, .Top = 16, .Left = 420}
        AddHandler btnSave.Click, AddressOf btnSave_Click

        footer.Controls.AddRange(New Control() {lblSubTotal, txtSubTotal, lblVAT, txtVAT, lblTotal, txtTotal, btnSave})

        ' Compose form
        Me.Controls.Clear()
        Me.Controls.Add(dgvLines)
        Me.Controls.Add(footer)
        Me.Controls.Add(header)

    End Sub

    Private Sub LoadLookups()
        suppliers = service.GetSuppliersLookup()
        materials = service.GetPOItemsLookup()
        branches = service.GetBranchesLookup()

        ' Set branch dropdown
        If branches IsNot Nothing AndAlso branches.Rows.Count > 0 Then
            cboBranch.DataSource = Nothing
            cboBranch.DataSource = branches
            cboBranch.DisplayMember = "BranchName"
            cboBranch.ValueMember = "BranchID"

            ' Set default to current user's branch
            cboBranch.SelectedValue = currentBranchId

            ' Disable branch selection for non-Super Admin users
            If Not isSuperAdmin Then
                cboBranch.Enabled = False
            End If
        End If

        ' React to supplier changes to refresh guidance prices
        AddHandler txtSupplier.TextChanged, Sub(sender, e)
                                                RefreshGuidancePricesForAllRows()
                                                RaiseEvent SidebarContextChanged(Me, EventArgs.Empty)
                                            End Sub
    End Sub

    Private Sub SetupSupplierAutocomplete()
        Dim ac As New AutoCompleteStringCollection()
        Dim companyNameCol As Integer = suppliers.Columns("CompanyName").Ordinal
        For Each r As DataRow In suppliers.Rows
            ac.Add(r(companyNameCol).ToString())
        Next
        txtSupplier.AutoCompleteMode = AutoCompleteMode.SuggestAppend
        txtSupplier.AutoCompleteSource = AutoCompleteSource.CustomSource
        txtSupplier.AutoCompleteCustomSource = ac
    End Sub

    Private Sub SetupMaterialsColumn()
        Dim combo = TryCast(dgvLines.Columns("Material"), DataGridViewComboBoxColumn)
        If combo IsNot Nothing Then
            FilterMaterialsByType()
        End If
    End Sub

    Private Sub FilterMaterialsByType()
        Dim combo = TryCast(dgvLines.Columns("Material"), DataGridViewComboBoxColumn)
        If combo Is Nothing OrElse materials Is Nothing OrElse materials.Rows.Count = 0 Then Return

        Try
            ' Create a filtered copy of the materials table
            Dim filteredTable As New DataTable()
            filteredTable = materials.Clone() ' Copy structure

            ' Filter based on selected product type
            Dim itemSourceCol As Integer = materials.Columns("ItemSource").Ordinal

            If cboProductType.SelectedIndex = 0 Then
                ' External Product - show only Products (ItemSource = 'PR')
                For Each row As DataRow In materials.Rows
                    If row(itemSourceCol).ToString() = "PR" Then
                        filteredTable.ImportRow(row)
                    End If
                Next
            Else
                ' Raw Material - show only RawMaterials (ItemSource = 'RM')
                For Each row As DataRow In materials.Rows
                    If row(itemSourceCol).ToString() = "RM" Then
                        filteredTable.ImportRow(row)
                    End If
                Next
            End If

            ' Set the filtered data
            combo.DataSource = Nothing
            combo.DataSource = filteredTable
            combo.DisplayMember = "MaterialName"
            combo.ValueMember = "MaterialID"

            ' Fix black background issue - set on FlatStyle
            combo.FlatStyle = FlatStyle.Standard
            combo.DefaultCellStyle.BackColor = Color.White
            combo.DefaultCellStyle.ForeColor = Color.Black
            combo.DefaultCellStyle.SelectionBackColor = Color.LightBlue
            combo.DefaultCellStyle.SelectionForeColor = Color.Black
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"FilterMaterialsByType error: {ex.Message}")
        End Try
    End Sub

    Private Sub cboProductType_SelectedIndexChanged(sender As Object, e As EventArgs)
        FilterMaterialsByType()
    End Sub

    Private Sub dgvLines_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs)
        Try
            If e.RowIndex < 0 Then Return
            Dim row = dgvLines.Rows(e.RowIndex)
            ' If material changed, refresh guidance prices
            If e.ColumnIndex = dgvLines.Columns("Material").Index Then
                PopulateGuidancePrices(row)
            End If
            Dim qty As Decimal = 0D
            Dim cost As Decimal = 0D
            Dim lastPaid As Decimal = 0D

            If row.Cells("OrderedQuantity").Value IsNot Nothing Then
                Decimal.TryParse(Convert.ToString(row.Cells("OrderedQuantity").Value), qty)
            End If
            If row.Cells("UnitCost").Value IsNot Nothing Then
                Decimal.TryParse(Convert.ToString(row.Cells("UnitCost").Value), cost)
            End If
            If row.Cells("LastPaidPrice").Value IsNot Nothing Then
                Decimal.TryParse(Convert.ToString(row.Cells("LastPaidPrice").Value), lastPaid)
            End If

            Dim effectiveUnit As Decimal = If(cost > 0D, cost, lastPaid)
            row.Cells("LineTotal").Value = (qty * effectiveUnit)
            RecalculateTotals()
            RaiseEvent SidebarContextChanged(Me, EventArgs.Empty)
        Catch ex As Exception
            ' Ignore cell value conversion errors to prevent dialog spam
            System.Diagnostics.Debug.WriteLine($"Cell value changed error: {ex.Message}")
        End Try
    End Sub

    Private Sub dgvLines_EditingControlShowing(sender As Object, e As DataGridViewEditingControlShowingEventArgs)
        If dgvLines.CurrentCell Is Nothing Then Return
        If dgvLines.CurrentCell.OwningColumn.Name = "Material" Then
            Dim cb = TryCast(e.Control, ComboBox)
            If cb IsNot Nothing Then
                ' Re-fetch latest materials so newly added items appear without reopening the form
                Try
                    materials = service.GetPOItemsLookup()
                    FilterMaterialsByType()
                Catch
                    ' Non-fatal; keep existing list
                End Try
                cb.DropDownStyle = ComboBoxStyle.DropDown
                cb.AutoCompleteMode = AutoCompleteMode.SuggestAppend
                cb.AutoCompleteSource = AutoCompleteSource.ListItems

                ' Fix black background on the actual ComboBox control
                cb.BackColor = Color.White
                cb.ForeColor = Color.Black
                cb.FlatStyle = FlatStyle.Standard
            End If
        End If
        ' Enforce numeric-only for numeric columns using shared helper
        UI.InputValidation.AttachNumericOnlyForGrid(dgvLines, e, True, "OrderedQuantity", "UnitCost")
    End Sub

    Private Sub dgvLines_DataError(sender As Object, e As DataGridViewDataErrorEventArgs)
        ' Suppress the default error dialog and handle the error silently
        e.Cancel = True
        System.Diagnostics.Debug.WriteLine($"DataGridView DataError: {e.Exception?.Message}")
    End Sub

    Private Sub dgvLines_CurrentCellDirtyStateChanged(sender As Object, e As EventArgs)
        ' Commit combo box selections immediately so CellValueChanged fires
        If dgvLines.IsCurrentCellDirty Then
            dgvLines.CommitEdit(DataGridViewDataErrorContexts.Commit)
        End If
    End Sub

    Private Sub dgvLines_RowsAdded(sender As Object, e As DataGridViewRowsAddedEventArgs)
        RecalculateTotals()
        RaiseEvent SidebarContextChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub dgvLines_RowsRemoved(sender As Object, e As DataGridViewRowsRemovedEventArgs)
        RecalculateTotals()
        RaiseEvent SidebarContextChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub RecalculateTotals()
        Dim subTotal As Decimal = 0D
        For Each r As DataGridViewRow In dgvLines.Rows
            If r.IsNewRow Then Continue For
            Dim lt As Decimal = 0D
            If r.Cells("LineTotal").Value IsNot Nothing Then
                Decimal.TryParse(Convert.ToString(r.Cells("LineTotal").Value), lt)
            End If
            subTotal += lt
        Next
        Dim vat As Decimal = Math.Round(subTotal * 0.15D, 2)
        Dim total As Decimal = subTotal + vat
        txtSubTotal.Text = subTotal.ToString("N2")
        txtVAT.Text = vat.ToString("N2")
        txtTotal.Text = total.ToString("N2")
    End Sub

    Private Sub RefreshGuidancePricesForAllRows()
        For Each r As DataGridViewRow In dgvLines.Rows
            If r.IsNewRow Then Continue For
            PopulateGuidancePrices(r)
        Next
        RecalculateTotals()
        RaiseEvent SidebarContextChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub PopulateGuidancePrices(row As DataGridViewRow)
        Try
            If row Is Nothing Then Return
            If row.Cells("Material").Value Is Nothing Then Return
            Dim supplierId = ResolveSupplierId()
            Dim materialId = Convert.ToInt32(row.Cells("Material").Value)
            ' Fetch supplier-specific last paid price (nullable) and material last cost
            Dim lastPaidNullable As Decimal? = service.GetLastPaidPrice(supplierId, materialId)
            Dim lastCost As Decimal = service.GetMaterialLastCost(materialId)
            row.Cells("LastPaidPrice").Value = If(lastPaidNullable.HasValue, lastPaidNullable.Value, 0D)
            row.Cells("LastCost").Value = lastCost
            ' Recompute expected total for this row
            Dim qty As Decimal = 0D
            Dim unit As Decimal = 0D
            Decimal.TryParse(Convert.ToString(row.Cells("OrderedQuantity").Value), qty)
            Decimal.TryParse(Convert.ToString(row.Cells("UnitCost").Value), unit)
            ' Default UnitCost to last paid price (or last cost) if currently zero/blank; user may edit afterward
            If unit <= 0D Then
                Dim defaultUnit = If(lastPaidNullable.HasValue AndAlso lastPaidNullable.Value > 0D, lastPaidNullable.Value, lastCost)
                row.Cells("UnitCost").Value = defaultUnit
                unit = defaultUnit
            End If
            Dim effectiveUnit As Decimal = unit
            row.Cells("LineTotal").Value = qty * effectiveUnit
        Catch
            ' Swallow guidance errors; avoid blocking PO capture
        End Try
    End Sub

    Private Function ResolveSupplierId() As Integer
        Dim name = txtSupplier.Text.Trim()
        If name = String.Empty Then Return 0
        Dim found() As DataRow = suppliers.Select($"CompanyName = '{name.Replace("'", "''")}'")
        If found Is Nothing OrElse found.Length = 0 Then Return 0
        Dim supplierIdCol As Integer = suppliers.Columns("SupplierID").Ordinal
        Return Convert.ToInt32(found(0)(supplierIdCol))
    End Function

    Private Function BuildLinesTable() As DataTable
        Dim dt As New DataTable()
        dt.Columns.Add("MaterialID", GetType(Integer))
        dt.Columns.Add("OrderedQuantity", GetType(Decimal))
        dt.Columns.Add("UnitCost", GetType(Decimal))
        For Each r As DataGridViewRow In dgvLines.Rows
            If r.IsNewRow Then Continue For
            If r.Cells("Material").Value Is Nothing Then Continue For

            ' Get MaterialID from the ComboBox cell - handle DataRowView properly
            Dim materialId As Integer = 0
            Dim cellValue = r.Cells("Material").Value
            If TypeOf cellValue Is DataRowView Then
                Dim drv As DataRowView = DirectCast(cellValue, DataRowView)
                materialId = Convert.ToInt32(drv("MaterialID"))
            ElseIf TypeOf cellValue Is Integer Then
                materialId = Convert.ToInt32(cellValue)
            Else
                Continue For
            End If

            Dim qty As Decimal
            Dim cost As Decimal
            Decimal.TryParse(Convert.ToString(r.Cells("OrderedQuantity").Value), qty)
            Decimal.TryParse(Convert.ToString(r.Cells("UnitCost").Value), cost)
            ' Allow nullable/blank cost for PO capture; send 0 if blank
            If qty <= 0 Then Continue For
            If cost < 0 Then cost = 0D
            dt.Rows.Add(materialId, qty, cost)
        Next
        Return dt
    End Function

    Private Sub btnSave_Click(sender As Object, e As EventArgs)
        Try
            Dim supplierId = ResolveSupplierId()
            If supplierId = 0 Then
                MessageBox.Show("Please select a valid supplier.")
                Return
            End If
            ' Branch is always taken from the current session
            ' Validation: every line must have a UnitCost > 0 before saving
            For Each r As DataGridViewRow In dgvLines.Rows
                If r.IsNewRow Then Continue For
                If r.Cells("Material").Value Is Nothing Then Continue For
                Dim qty As Decimal = 0D
                Decimal.TryParse(Convert.ToString(r.Cells("OrderedQuantity").Value), qty)
                If qty <= 0D Then Continue For
                Dim unit As Decimal = 0D
                Decimal.TryParse(Convert.ToString(r.Cells("UnitCost").Value), unit)
                If unit <= 0D Then
                    dgvLines.CurrentCell = r.Cells("UnitCost")
                    MessageBox.Show("Enter a Unit Cost for every ordered item before saving the Purchase Order.", "Unit Cost required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
            Next
            Dim lines = BuildLinesTable()
            If lines.Rows.Count = 0 Then
                MessageBox.Show("Please add at least one line.")
                Return
            End If
            ' Use branch from dropdown if Super Admin, otherwise current user's branch
            Dim selectedBranchId As Integer
            If isSuperAdmin AndAlso cboBranch.SelectedItem IsNot Nothing Then
                Dim row As DataRowView = TryCast(cboBranch.SelectedItem, DataRowView)
                If row IsNot Nothing Then
                    Dim branchIdCol As Integer = row.DataView.Table.Columns("BranchID").Ordinal
                    selectedBranchId = Convert.ToInt32(row(branchIdCol))
                Else
                    selectedBranchId = currentBranchId
                End If
            Else
                selectedBranchId = currentBranchId
            End If

            Dim poId = service.CreatePurchaseOrder(selectedBranchId, supplierId, dtpOrderDate.Value.Date, dtpRequiredDate.Value.Date, txtReference.Text.Trim(), txtNotes.Text.Trim(), AppSession.CurrentUserID, lines)
            ' Fetch PONumber for display
            Dim poHdr = service.GetPurchaseOrderHeader(poId)
            Dim poNumber As String = Nothing
            If poHdr IsNot Nothing AndAlso poHdr.Rows.Count > 0 Then
                Dim poNumCol As Integer = poHdr.Columns("PONumber").Ordinal
                If Not IsDBNull(poHdr.Rows(0)(poNumCol)) Then
                    poNumber = Convert.ToString(poHdr.Rows(0)(poNumCol))
                End If
            End If
            If Not String.IsNullOrWhiteSpace(poNumber) Then
                lblPONumber.Text = $"PO: {poNumber}"
            End If
            MessageBox.Show($"Purchase Order saved: {If(String.IsNullOrWhiteSpace(poNumber), "(number pending)", poNumber)} (ID: {poId}).", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Me.Tag = poId
            RaiseEvent SidebarContextChanged(Me, EventArgs.Empty)

            ' Attempt to post journal immediately using physical document numbers
            Try
                Dim supplierName = txtSupplier.Text.Trim()
                Dim supplierInvoiceNo As String = txtReference.Text.Trim() ' using Reference as Supplier Invoice
                PostPurchaseJournal(selectedBranchId, dtpOrderDate.Value.Date, poNumber, supplierInvoiceNo, supplierName, lines)
            Catch jex As Exception
                ' Non-blocking: inform but do not fail the save flow
                MessageBox.Show("PO saved but journal posting failed: " & jex.Message, "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End Try
            ' Return to a clean capture screen (grab screen)
            ResetFormAfterSave()
        Catch ex As Exception
            MessageBox.Show("Error saving Purchase Order: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub PostPurchaseJournal(branchId As Integer, journalDate As Date, poNumber As String, supplierInvoiceNo As String, supplierName As String, lines As DataTable)
        If String.IsNullOrWhiteSpace(poNumber) Then Throw New Exception("PO number not available for journal reference.")
        If String.IsNullOrWhiteSpace(supplierInvoiceNo) Then supplierInvoiceNo = "(no-invoice)"

        ' Totals: compute from provided lines and VAT = 15%
        Dim subTotal As Decimal = 0D
        Dim qtyColIdx As Integer = lines.Columns("OrderedQuantity").Ordinal
        Dim costColIdx As Integer = lines.Columns("UnitCost").Ordinal

        For Each r As DataRow In lines.Rows
            Dim qty As Decimal = 0D
            Dim unit As Decimal = 0D
            If r(qtyColIdx) IsNot DBNull.Value Then qty = Convert.ToDecimal(r(qtyColIdx))
            If r(costColIdx) IsNot DBNull.Value Then unit = Convert.ToDecimal(r(costColIdx))
            subTotal += (qty * unit)
        Next
        Dim vat As Decimal = Math.Round(subTotal * 0.15D, 2)
        Dim total As Decimal = subTotal + vat

        Using con As New SqlConnection(connectionString)
            con.Open()

            ' Resolve accounts: prefer DB mappings, fallback to smart search
            Dim acctPurchases As Integer = GLMapping.GetMappedAccountId(con, "Purchases", branchId)
            If acctPurchases = 0 Then
                acctPurchases = FirstNonZero(
                    TryGetAccountIdSmart(con,
                        exactNames:={"Purchases", "Inventory", "Cost of Sales"},
                        likePatterns:={"%purchas%", "%invent%", "%stock%"},
                        accountNumbers:={"1300", "1400"}
                    ))
            End If

            Dim acctVatInput As Integer = GLMapping.GetMappedAccountId(con, "VATInput", branchId)
            If acctVatInput = 0 Then
                acctVatInput = FirstNonZero(
                    TryGetAccountIdSmart(con,
                        exactNames:={"VAT Input", "VAT Control", "VAT", "Input VAT"},
                        likePatterns:={"%vat%input%", "%input%vat%", "%vat%control%", "%vat%"},
                        accountNumbers:={"2600", "2610"}
                    ))
            End If

            Dim acctCreditors As Integer = GLMapping.GetMappedAccountId(con, "Creditors", branchId)
            If acctCreditors = 0 Then
                acctCreditors = FirstNonZero(
                    TryGetAccountIdSmart(con,
                        exactNames:={"Creditors", "Accounts Payable", "Trade Payables"},
                        likePatterns:={"%payable%", "%creditor%", "%trade%payable%"},
                        accountNumbers:={"2100", "2000"}
                    ))
            End If

            If acctPurchases = 0 OrElse acctCreditors = 0 Then
                Throw New Exception("Required accounts not found (Purchases/Inventory and Creditors/AP). Configure names or numbers to match your GL.")
            End If

            Dim fiscalPeriodId As Object = GetFiscalPeriodId(con, journalDate)

            ' Create journal header (safe): ensures a JournalNumber exists
            Dim journalId As Integer = CreateJournalHeaderSafe(con, journalDate,
                                                              $"PO:{poNumber} INV:{supplierInvoiceNo}",
                                                              $"Purchase - {supplierName} | PO {poNumber} | INV {supplierInvoiceNo}",
                                                              If(fiscalPeriodId Is Nothing, DBNull.Value, fiscalPeriodId),
                                                              AppSession.CurrentUserID,
                                                              GetCurrentBranchId())

            If vat > 0D AndAlso acctVatInput > 0 Then
                ' Split: Purchases ex VAT + VAT input
                AddJournalDetail(con, journalId, acctPurchases, subTotal, 0D, $"Purchase {supplierName}", "PURCHASE", poNumber)
                AddJournalDetail(con, journalId, acctVatInput, vat, 0D, "VAT Input", "PURCHASE", supplierInvoiceNo)
                AddJournalDetail(con, journalId, acctCreditors, 0D, total, $"Creditors - {supplierName}", "PURCHASE", supplierInvoiceNo)
            Else
                ' No VAT account available or VAT is zero: DR full amount to Purchases/Inventory
                AddJournalDetail(con, journalId, acctPurchases, total, 0D, $"Purchase {supplierName}", "PURCHASE", poNumber)
                AddJournalDetail(con, journalId, acctCreditors, 0D, total, $"Creditors - {supplierName}", "PURCHASE", supplierInvoiceNo)
            End If
        End Using
    End Sub

    Private Sub AddJournalDetail(con As SqlConnection, journalId As Integer, accountId As Integer, debit As Decimal, credit As Decimal, descText As String, ref1 As String, ref2 As String)
        Using cmd As New SqlCommand("sp_AddJournalDetail", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@JournalID", journalId)
            cmd.Parameters.AddWithValue("@AccountID", accountId)
            cmd.Parameters.AddWithValue("@Debit", debit)
            cmd.Parameters.AddWithValue("@Credit", credit)
            cmd.Parameters.AddWithValue("@Description", descText)
            cmd.Parameters.AddWithValue("@Reference1", ref1)
            cmd.Parameters.AddWithValue("@Reference2", ref2)
            cmd.Parameters.AddWithValue("@CostCenterID", DBNull.Value)
            cmd.Parameters.AddWithValue("@ProjectID", DBNull.Value)
            ' Some environments require @LineNumber OUTPUT to be present
            Dim pLine As New SqlParameter("@LineNumber", SqlDbType.Int)
            pLine.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pLine)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Function TryGetAccountIdByNameExact(con As SqlConnection, name As String) As Integer
        Using cmd As New SqlCommand("SELECT TOP 1 AccountID FROM dbo.GLAccounts WHERE AccountName = @n AND IsActive = 1 ORDER BY AccountID", con)
            cmd.Parameters.AddWithValue("@n", name)
            Dim o = cmd.ExecuteScalar()
            If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return Convert.ToInt32(o)
        End Using
        Return 0
    End Function

    Private Function TryGetAccountIdSmart(con As SqlConnection, Optional exactNames As String() = Nothing, Optional likePatterns As String() = Nothing, Optional accountNumbers As String() = Nothing) As Integer
        ' 1) Exact case-insensitive match on AccountName
        If exactNames IsNot Nothing Then
            For Each n In exactNames
                Using cmd As New SqlCommand("SELECT TOP 1 AccountID FROM dbo.GLAccounts WHERE IsActive = 1 AND LOWER(AccountName) = LOWER(@n) ORDER BY AccountID", con)
                    cmd.Parameters.AddWithValue("@n", n)
                    Dim o = cmd.ExecuteScalar()
                    If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return Convert.ToInt32(o)
                End Using
            Next
        End If

        ' 2) LIKE patterns on AccountName
        If likePatterns IsNot Nothing Then
            For Each p In likePatterns
                Using cmd As New SqlCommand("SELECT TOP 1 AccountID FROM dbo.GLAccounts WHERE IsActive = 1 AND AccountName LIKE @p ORDER BY AccountID", con)
                    cmd.Parameters.AddWithValue("@p", p)
                    Dim o = cmd.ExecuteScalar()
                    If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return Convert.ToInt32(o)
                End Using
            Next
        End If

        ' 3) Common account numbers
        If accountNumbers IsNot Nothing Then
            For Each num In accountNumbers
                Using cmd As New SqlCommand("SELECT TOP 1 AccountID FROM dbo.GLAccounts WHERE IsActive = 1 AND AccountNumber = @n ORDER BY AccountID", con)
                    cmd.Parameters.AddWithValue("@n", num)
                    Dim o = cmd.ExecuteScalar()
                    If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return Convert.ToInt32(o)
                End Using
            Next
        End If

        Return 0
    End Function

    Private Function FirstNonZero(ParamArray values() As Integer) As Integer
        For Each v In values
            If v <> 0 Then Return v
        Next
        Return 0
    End Function

    Private Function GetFiscalPeriodId(con As SqlConnection, d As Date) As Object
        Using cmd As New SqlCommand("SELECT TOP 1 PeriodID FROM dbo.FiscalPeriods WHERE @d BETWEEN StartDate AND EndDate ORDER BY StartDate DESC", con)
            cmd.Parameters.AddWithValue("@d", d)
            Dim o = cmd.ExecuteScalar()
            If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return o
        End Using
        Return Nothing
    End Function

    Private Sub ResetFormAfterSave()
        Try
            ' Reset header fields
            txtSupplier.Text = String.Empty
            If cboBranch.Items.Count > 0 Then cboBranch.SelectedIndex = 0
            dtpOrderDate.Value = DateTime.Today
            dtpRequiredDate.Value = DateTime.Today
            txtReference.Text = String.Empty
            txtNotes.Text = String.Empty

            ' Reset number label
            If lblPONumber IsNot Nothing Then lblPONumber.Text = "PO: (unsaved)"

            ' Clear lines grid
            If dgvLines IsNot Nothing Then
                If dgvLines.DataSource IsNot Nothing Then
                    Dim dt = TryCast(dgvLines.DataSource, DataTable)
                    If dt IsNot Nothing Then
                        dt.Rows.Clear()
                        dt.AcceptChanges()
                    Else
                        dgvLines.Rows.Clear()
                    End If
                Else
                    dgvLines.Rows.Clear()
                End If
            End If

            ' Reset totals 
            txtSubTotal.Text = "0.00"
            txtVAT.Text = "0.00"
            txtTotal.Text = "0.00"

            ' Focus first capture control
            txtSupplier.Focus()
        Catch
            ' Non-fatal reset
        End Try
    End Sub

    ' ---------------- ISidebarProvider ----------------
    Public Event SidebarContextChanged As EventHandler Implements UI.ISidebarProvider.SidebarContextChanged

    Public Function BuildSidebarPanel() As Panel Implements UI.ISidebarProvider.BuildSidebarPanel
        Dim p As New Panel() With {.Height = 160, .BackColor = Color.White}
        Dim title As New Label() With {
            .Text = "PO Context",
            .Dock = DockStyle.Top,
            .Height = 24,
            .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold),
            .Padding = New Padding(8, 6, 8, 0)
        }
        p.Controls.Add(title)

        Dim supplierName = txtSupplier.Text.Trim()
        Dim branchId As Integer = GetCurrentBranchId()

        ' Use current row material if available
        Dim materialId As Integer = 0
        Dim lastPaid As Decimal = 0D
        Dim lastCost As Decimal = 0D
        Dim soh As Decimal = 0D
        Try
            If dgvLines.CurrentRow IsNot Nothing AndAlso Not dgvLines.CurrentRow.IsNewRow Then
                If dgvLines.CurrentRow.Cells("Material").Value IsNot Nothing Then
                    materialId = Convert.ToInt32(dgvLines.CurrentRow.Cells("Material").Value)
                End If
                Decimal.TryParse(Convert.ToString(dgvLines.CurrentRow.Cells("LastPaidPrice").Value), lastPaid)
                Decimal.TryParse(Convert.ToString(dgvLines.CurrentRow.Cells("LastCost").Value), lastCost)
            End If
            If materialId > 0 Then
                soh = service.GetStockOnHand(materialId, branchId)
            End If
        Catch
        End Try

        Dim info As String = $"Supplier: {If(String.IsNullOrEmpty(supplierName), "(none)", supplierName)}" & Environment.NewLine &
                             $"BranchID: {branchId}" & Environment.NewLine &
                             $"MaterialID: {If(materialId > 0, materialId.ToString(), "(none)")}" & Environment.NewLine &
                             $"Last Paid: {lastPaid:N2}  Last Cost: {lastCost:N2}" & Environment.NewLine &
                             $"Stock On Hand: {soh:N2}"
        Dim lbl As New Label() With {
            .Text = info,
            .Dock = DockStyle.Fill,
            .Padding = New Padding(12, 4, 8, 8)
        }
        p.Controls.Add(lbl)
        p.Controls.SetChildIndex(lbl, 0)
        Return p
    End Function

End Class
