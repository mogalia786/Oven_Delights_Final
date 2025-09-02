Imports System.Windows.Forms
Imports System.Data.SqlClient
Imports System.Data
Imports System.Drawing

' LIVE EDIT: This file was modified at your request for verification.
Public Class CreditNoteForm
    Inherits Form

    Private purchaseOrderId As Integer
    Private connectionString As String

    ' Services
    Private ReadOnly stockroom As New StockroomService()

    ' Controls
    Private lblSupplier As Label
    Private txtSupplier As TextBox
    Private lstSupplier As ListBox
    Private lblGRN As Label
    Private cboGRN As ComboBox
    Private lblInvoice As Label
    Private cboInvoice As ComboBox
    Private lblDate As Label
    Private dtpCreditDate As DateTimePicker
    Private lblReason As Label
    Private txtReason As TextBox
    Private lblReference As Label
    Private txtReference As TextBox
    Private lblNotes As Label
    Private txtNotes As TextBox
    Private dgvLines As DataGridView
    Private btnSave As Button
    Private btnCancel As Button

    ' Backing state
    Private selectedSupplierId As Integer?
    Private selectedGRNId As Integer?

    Public Sub New(poId As Integer)
        Me.purchaseOrderId = poId
        connectionString = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Me.WindowState = FormWindowState.Maximized
        InitializeComponent()
        SetupModernUI()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Supplier Credit Note"
        Me.Padding = New Padding(12)

        lblSupplier = New Label() With {.Text = "Supplier", .AutoSize = True, .Location = New Point(20, 20)}
        txtSupplier = New TextBox() With {.Location = New Point(20, 45), .Width = 340}
        lstSupplier = New ListBox() With {.Location = New Point(20, 70), .Width = 340, .Height = 100, .Visible = False}

        lblGRN = New Label() With {.Text = "GRN", .AutoSize = True, .Location = New Point(380, 20)}
        cboGRN = New ComboBox() With {.Location = New Point(380, 45), .Width = 260, .DropDownStyle = ComboBoxStyle.DropDownList}

        lblInvoice = New Label() With {.Text = "Supplier Invoice", .AutoSize = True, .Location = New Point(660, 20)}
        cboInvoice = New ComboBox() With {.Location = New Point(660, 45), .Width = 260, .DropDownStyle = ComboBoxStyle.DropDownList}

        lblDate = New Label() With {.Text = "Date", .AutoSize = True, .Location = New Point(940, 20)}
        dtpCreditDate = New DateTimePicker() With {.Location = New Point(940, 45), .Width = 160, .Value = DateTime.Today}

        lblReason = New Label() With {.Text = "Reason", .AutoSize = True, .Location = New Point(20, 180)}
        txtReason = New TextBox() With {.Location = New Point(20, 205), .Width = 340}

        lblReference = New Label() With {.Text = "Reference", .AutoSize = True, .Location = New Point(380, 180)}
        txtReference = New TextBox() With {.Location = New Point(380, 205), .Width = 260}

        lblNotes = New Label() With {.Text = "Notes", .AutoSize = True, .Location = New Point(660, 180)}
        txtNotes = New TextBox() With {.Location = New Point(660, 205), .Width = 260}

        dgvLines = New DataGridView() With {.Location = New Point(20, 245), .Width = 900, .Height = 360, .AllowUserToAddRows = False, .ReadOnly = False, .AutoGenerateColumns = False}
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "GRNLineID", .Name = "GRNLineID", .DataPropertyName = "GRNLineID", .Visible = False})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "MaterialID", .Name = "MaterialID", .DataPropertyName = "MaterialID", .Visible = False})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Material", .Name = "MaterialName", .DataPropertyName = "MaterialName", .Width = 260, .ReadOnly = True})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Returnable Qty", .Name = "ReturnableQty", .DataPropertyName = "ReturnableQty", .Width = 120, .ReadOnly = True})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Unit Cost", .Name = "UnitCost", .DataPropertyName = "UnitCost", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Return Qty", .Name = "ReturnQuantity", .DataPropertyName = "ReturnQuantity", .Width = 120})

        btnSave = New Button() With {.Text = "Save Credit Note", .Location = New Point(20, 620), .Width = 180}
        btnCancel = New Button() With {.Text = "Cancel", .Location = New Point(210, 620), .Width = 100}

        AddHandler txtSupplier.TextChanged, AddressOf OnSupplierSearchChanged
        AddHandler lstSupplier.Click, AddressOf OnSupplierSelected
        AddHandler cboGRN.SelectedIndexChanged, AddressOf OnGRNSelected
        AddHandler cboInvoice.SelectedIndexChanged, Sub(sender, e)
                                                       ' no-op placeholder to allow future filtering by invoice
                                                   End Sub
        AddHandler btnSave.Click, AddressOf btnSaveCreditNote_Click
        AddHandler btnCancel.Click, Sub(sender, e) Me.Close()

        Me.Controls.AddRange(New Control() {lblSupplier, txtSupplier, lstSupplier, lblGRN, cboGRN, lblInvoice, cboInvoice, lblDate, dtpCreditDate, lblReason, txtReason, lblReference, txtReference, lblNotes, txtNotes, dgvLines, btnSave, btnCancel})
    End Sub

    Private Sub btnSaveCreditNote_Click(sender As Object, e As EventArgs)
        Try
            If Not selectedSupplierId.HasValue Then
                MessageBox.Show("Select a supplier first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            If Not selectedGRNId.HasValue Then
                MessageBox.Show("Select a GRN.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If cboInvoice.SelectedIndex < 0 Then
                MessageBox.Show("Select the supplier invoice to credit against.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            ' Build lines table expected by service: GRNLineID, MaterialID, ReturnQuantity, UnitCost
            Dim lines As New DataTable()
            lines.Columns.Add("GRNLineID", GetType(Integer))
            lines.Columns.Add("MaterialID", GetType(Integer))
            lines.Columns.Add("ReturnQuantity", GetType(Decimal))
            lines.Columns.Add("UnitCost", GetType(Decimal))

            For Each row As DataGridViewRow In dgvLines.Rows
                Dim retQtyObj = row.Cells("ReturnQuantity").Value
                If retQtyObj Is Nothing Then Continue For
                Dim retQty As Decimal
                If Not Decimal.TryParse(retQtyObj.ToString(), retQty) OrElse retQty <= 0D Then Continue For

                Dim maxQty As Decimal = Convert.ToDecimal(row.Cells("ReturnableQty").Value)
                If retQty > maxQty Then
                    MessageBox.Show("Return quantity cannot exceed returnable quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                Dim dr = lines.NewRow()
                dr("GRNLineID") = Convert.ToInt32(row.Cells("GRNLineID").Value)
                dr("MaterialID") = Convert.ToInt32(row.Cells("MaterialID").Value)
                dr("ReturnQuantity") = retQty
                dr("UnitCost") = Convert.ToDecimal(row.Cells("UnitCost").Value)
                lines.Rows.Add(dr)
            Next

            If lines.Rows.Count = 0 Then
                MessageBox.Show("Enter at least one return quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            ' Branch and user: derive from current context if available; fallback to 1
            Dim branchId As Integer = GetCurrentBranchId()
            Dim userId As Integer = GetCurrentUserId()

            ' Compute total amount for AP posting
            Dim totalAmount As Decimal = 0D
            For Each r As DataRow In lines.Rows
                totalAmount += Convert.ToDecimal(r("ReturnQuantity")) * Convert.ToDecimal(r("UnitCost"))
            Next

            Dim creditId = stockroom.CreateCreditNote(selectedSupplierId.Value, branchId, selectedGRNId.Value, dtpCreditDate.Value.Date, txtReason.Text, txtReference.Text, txtNotes.Text, userId, lines)

            ' Retrieve generated credit note number and branch for AP credit posting
            Dim hdr = stockroom.GetCreditNoteHeader(creditId)
            Dim crnNumber As String = Nothing
            If hdr IsNot Nothing AndAlso hdr.Rows.Count > 0 AndAlso Not IsDBNull(hdr.Rows(0)("CreditNoteNumber")) Then
                crnNumber = Convert.ToString(hdr.Rows(0)("CreditNoteNumber"))
            End If

            ' Post AP credit: DR AP Control; CR GRIR
            Dim ap As New AccountsPayableService()
            Dim desc As String = $"Supplier CN {crnNumber} for GRN {If(cboGRN.SelectedItem Is Nothing, "", CType(cboGRN.SelectedItem, DataRowView)("GRNNumber").ToString())}. Reason: {txtReason.Text}"
            Dim journalId = ap.CreateSupplierCreditNote(selectedSupplierId.Value, crnNumber, branchId, dtpCreditDate.Value.Date, Math.Round(totalAmount, 2), userId, desc)

            MessageBox.Show($"Credit note created: {crnNumber} (ID: {creditId}). AP JournalID: {journalId}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            ' Return to a clean capture state (grab screen)
            ResetFormAfterSave()
        Catch ex As Exception
            MessageBox.Show("Failed to create credit note: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SetupModernUI()
        Me.BackColor = Color.FromArgb(255, 240, 245)
        ' Simple theme touches
        For Each ctl As Control In Me.Controls
            If TypeOf ctl Is Label Then
                CType(ctl, Label).Font = New Font("Segoe UI", 9.0F, FontStyle.Regular)
            End If
            If TypeOf ctl Is Button Then
                Dim b = CType(ctl, Button)
                b.BackColor = Color.FromArgb(230, 200, 210)
                b.FlatStyle = FlatStyle.Flat
                b.FlatAppearance.BorderSize = 0
            End If
        Next
    End Sub

    ' Supplier search handlers
    Private Sub OnSupplierSearchChanged(sender As Object, e As EventArgs)
        Dim term = txtSupplier.Text.Trim()
        lstSupplier.Items.Clear()
        lstSupplier.Visible = False
        selectedSupplierId = Nothing
        cboGRN.DataSource = Nothing
        dgvLines.DataSource = Nothing

        If term.Length < 2 Then Return
        Dim dt = stockroom.SearchSuppliers(term, 20)
        For Each r As DataRow In dt.Rows
            lstSupplier.Items.Add(New With {.Text = $"{r("CompanyName")} ({r("SupplierCode")})", .Value = CInt(r("SupplierID"))})
        Next
        If dt.Rows.Count > 0 Then
            lstSupplier.DisplayMember = "Text"
            lstSupplier.ValueMember = "Value"
            lstSupplier.Visible = True
        End If
    End Sub

    Private Sub OnSupplierSelected(sender As Object, e As EventArgs)
        If lstSupplier.SelectedItem Is Nothing Then Return
        Dim it = lstSupplier.SelectedItem
        Dim idProp = it.GetType().GetProperty("Value")
        Dim textProp = it.GetType().GetProperty("Text")
        selectedSupplierId = CInt(idProp.GetValue(it, Nothing))
        txtSupplier.Text = textProp.GetValue(it, Nothing).ToString()
        lstSupplier.Visible = False
        LoadSupplierGRNs()
        LoadSupplierInvoices()
    End Sub

    Private Sub LoadSupplierGRNs()
        If Not selectedSupplierId.HasValue Then Return
        Dim dt = stockroom.GetGRNsBySupplier(selectedSupplierId.Value)
        cboGRN.DataSource = dt
        cboGRN.DisplayMember = "GRNNumber"
        cboGRN.ValueMember = "GRNID"
        cboGRN.SelectedIndex = -1
        selectedGRNId = Nothing
        dgvLines.DataSource = Nothing
    End Sub

    Private Sub OnGRNSelected(sender As Object, e As EventArgs)
        If cboGRN.SelectedIndex < 0 Then
            selectedGRNId = Nothing
            dgvLines.DataSource = Nothing
            Return
        End If
        selectedGRNId = CInt(CType(cboGRN.SelectedItem, DataRowView)("GRNID"))
        LoadReturnableLines(selectedGRNId.Value)
    End Sub

    Private Sub LoadReturnableLines(grnId As Integer)
        Dim dt = stockroom.GetReturnableGRNLines(grnId)
        ' Expecting columns: GRNLineID, MaterialID, MaterialName, ReturnableQty, UnitCost
        ' Add editable ReturnQuantity column
        If Not dt.Columns.Contains("ReturnQuantity") Then
            dt.Columns.Add("ReturnQuantity", GetType(Decimal))
        End If
        dgvLines.DataSource = dt
    End Sub

    Private Sub LoadSupplierInvoices()
        If Not selectedSupplierId.HasValue Then
            cboInvoice.DataSource = Nothing
            Return
        End If
        Dim dt = stockroom.GetSupplierAPInvoices(selectedSupplierId.Value)
        cboInvoice.DataSource = dt
        cboInvoice.DisplayMember = "SupplierInvoiceNo"
        cboInvoice.ValueMember = "JournalID"
        cboInvoice.SelectedIndex = -1
    End Sub

    Private Function GetCurrentBranchId() As Integer
        If AppSession.CurrentBranchID > 0 Then Return AppSession.CurrentBranchID
        Return 1
    End Function
    Private Function GetCurrentUserId() As Integer
        If AppSession.CurrentUserID > 0 Then Return AppSession.CurrentUserID
        Return 1
    End Function

    Private Sub ResetFormAfterSave()
        Try
            ' Reset supplier search
            txtSupplier.Text = String.Empty
            lstSupplier.Items.Clear()
            lstSupplier.Visible = False
            selectedSupplierId = Nothing

            ' Clear GRN and invoice selections
            cboGRN.DataSource = Nothing
            cboGRN.Items.Clear()
            cboGRN.SelectedIndex = -1
            selectedGRNId = Nothing

            cboInvoice.DataSource = Nothing
            cboInvoice.Items.Clear()
            cboInvoice.SelectedIndex = -1

            ' Clear header fields
            dtpCreditDate.Value = Date.Today
            txtReason.Text = String.Empty
            txtReference.Text = String.Empty
            txtNotes.Text = String.Empty

            ' Clear grid
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

            ' Focus first field
            txtSupplier.Focus()
        Catch
            ' Non-fatal reset
        End Try
    End Sub
End Class

