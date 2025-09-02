Imports System.Windows.Forms
Imports System.Data
Imports System.IO
Imports Oven_Delights_ERP.UI

Public Class InvoiceCaptureForm
    Inherits Form
    Implements ISidebarProvider

    Private ReadOnly service As New StockroomService()
    ' Email, PDF and dashboard
    Private ReadOnly emailService As New EmailService()
    Private ReadOnly pdfService As New PdfService()
    Private dashboardPanel As Panel
    Private dashboardBrowser As WebBrowser

    ' Header controls
    Private WithEvents cboSupplier As New ComboBox()
    Private WithEvents cboPO As New ComboBox()
    Private lblSupplier As New Label()
    Private lblPO As New Label()
    Private lblDeliveryNote As New Label()
    Private txtDeliveryNote As New TextBox()
    Private lblDate As New Label()
    Private dtpReceived As New DateTimePicker()

    ' Grid and totals
    Private WithEvents dgvLines As New DataGridView()
    Private lblSubTotal As New Label()
    Private txtSubTotal As New TextBox()
    Private lblVat As New Label()
    Private txtVat As New TextBox()
    Private lblTotal As New Label()
    Private txtTotal As New TextBox()

    ' Actions
    Private WithEvents btnSave As New Button()
    Private WithEvents btnCancel As New Button()

    ' State
    Private selectedSupplierId As Integer = 0
    Private selectedPOId As Integer = 0
    Private currentBranchId As Integer
    Private currentUserId As Integer

    Public Sub New(branchId As Integer, userId As Integer)
        Me.Text = "Invoice Capture (GRV)"
        Me.WindowState = FormWindowState.Maximized
        Me.StartPosition = FormStartPosition.CenterParent
        Me.currentBranchId = branchId
        Me.currentUserId = userId
        InitializeComponent()
        LoadSuppliers()
        ApplyTheme()
    End Sub

    Private Sub InitializeComponent()
        ' Header layout
        lblSupplier.Text = "Supplier:" : lblSupplier.AutoSize = True
        lblPO.Text = "PO:" : lblPO.AutoSize = True
        lblDeliveryNote.Text = "Delivery Note:" : lblDeliveryNote.AutoSize = True
        lblDate.Text = "Received Date:" : lblDate.AutoSize = True

        cboSupplier.DropDownStyle = ComboBoxStyle.DropDownList
        cboPO.DropDownStyle = ComboBoxStyle.DropDownList
        dtpReceived.Format = DateTimePickerFormat.[Short]
        dtpReceived.Value = DateTime.Now

        ' Grid
        dgvLines.AllowUserToAddRows = False
        dgvLines.AllowUserToDeleteRows = False
        dgvLines.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        dgvLines.RowHeadersVisible = False
        dgvLines.SelectionMode = DataGridViewSelectionMode.CellSelect

        ' Add columns
        dgvLines.Columns.Clear()
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "POLineID", .HeaderText = "POLineID", .Visible = False})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "MaterialID", .HeaderText = "MaterialID", .Visible = False})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "MaterialCode", .HeaderText = "Code", .ReadOnly = True, .FillWeight = 120})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "MaterialName", .HeaderText = "Material", .ReadOnly = True, .FillWeight = 180})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "OrderedQuantity", .HeaderText = "Ordered", .ReadOnly = True, .FillWeight = 90, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ReceivedQuantityToDate", .HeaderText = "Received TD", .ReadOnly = True, .FillWeight = 90, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ReceiveNow", .HeaderText = "Receive Now", .FillWeight = 90, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "UnitCost", .HeaderText = "Unit Cost", .FillWeight = 90, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        ' Cost insight columns
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "LastCost", .HeaderText = "Last Cost", .ReadOnly = True, .FillWeight = 90, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "AverageCost", .HeaderText = "Avg Cost", .ReadOnly = True, .FillWeight = 90, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ReturnQty", .HeaderText = "Return Qty", .FillWeight = 90, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        ' Per-line credit reason
        Dim reasonCol As New DataGridViewComboBoxColumn() With {.Name = "CreditReason", .HeaderText = "Credit Reason", .FillWeight = 120}
        reasonCol.Items.AddRange(New Object() {"No Credit Note", "Short-supply", "Damaged/Expired"})
        dgvLines.Columns.Add(reasonCol)
        ' Per-line comments
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "CreditComments", .HeaderText = "Comments", .FillWeight = 180})
        ' Read-only credit amount derived from ReturnQty * UnitCost
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "CreditAmount", .HeaderText = "Credit Amount", .ReadOnly = True, .FillWeight = 110, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N2"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "LineTotal", .HeaderText = "Line Total", .ReadOnly = True, .FillWeight = 110, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N2"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "Variance", .HeaderText = "Variance", .ReadOnly = True, .FillWeight = 90, .DefaultCellStyle = New DataGridViewCellStyle() With {.Format = "N4"}})
        Dim btnCol As New DataGridViewButtonColumn() With {.Name = "CreditBtn", .HeaderText = "Credit Note", .Text = "CN", .UseColumnTextForButtonValue = True, .FillWeight = 60}
        dgvLines.Columns.Add(btnCol)

        ' Totals
        lblSubTotal.Text = "SubTotal:" : lblSubTotal.AutoSize = True
        lblVat.Text = "VAT:" : lblVat.AutoSize = True
        lblTotal.Text = "Total:" : lblTotal.AutoSize = True
        For Each t In New TextBox() {txtSubTotal, txtVat, txtTotal}
            t.ReadOnly = True
            t.TextAlign = HorizontalAlignment.Right
        Next

        ' Buttons
        btnSave.Text = "Save GRV"
        btnCancel.Text = "Cancel"

        ' Layout controls manually (simple flow)
        Dim pnlTop As New Panel() With {.Dock = DockStyle.Top, .Height = 72}
        lblSupplier.Location = New Drawing.Point(12, 12)
        cboSupplier.Location = New Drawing.Point(90, 8) : cboSupplier.Width = 300
        lblPO.Location = New Drawing.Point(410, 12)
        cboPO.Location = New Drawing.Point(440, 8) : cboPO.Width = 220
        lblDeliveryNote.Location = New Drawing.Point(680, 12)
        txtDeliveryNote.Location = New Drawing.Point(780, 8) : txtDeliveryNote.Width = 180
        lblDate.Location = New Drawing.Point(980, 12)
        dtpReceived.Location = New Drawing.Point(1075, 8)
        pnlTop.Controls.AddRange(New Control() {lblSupplier, cboSupplier, lblPO, cboPO, lblDeliveryNote, txtDeliveryNote, lblDate, dtpReceived})

        Dim pnlBottom As New Panel() With {.Dock = DockStyle.Bottom, .Height = 72}
        lblSubTotal.Location = New Drawing.Point(680, 14)
        txtSubTotal.Location = New Drawing.Point(750, 10) : txtSubTotal.Width = 120
        lblVat.Location = New Drawing.Point(880, 14)
        txtVat.Location = New Drawing.Point(920, 10) : txtVat.Width = 120
        lblTotal.Location = New Drawing.Point(1050, 14)
        txtTotal.Location = New Drawing.Point(1095, 10) : txtTotal.Width = 120
        btnSave.Location = New Drawing.Point(12, 10)
        btnCancel.Location = New Drawing.Point(110, 10)
        pnlBottom.Controls.AddRange(New Control() {btnSave, btnCancel, lblSubTotal, txtSubTotal, lblVat, txtVat, lblTotal, txtTotal})

        ' Dashboard panel intentionally not added to Controls to maximize grid width
        dashboardPanel = New Panel() With {.Dock = DockStyle.Right, .Width = 0, .Visible = False}
        dashboardBrowser = New WebBrowser() With {.Dock = DockStyle.Fill, .ScriptErrorsSuppressed = True}

        dgvLines.Dock = DockStyle.Fill
        dgvLines.Margin = New Padding(0)
        Me.Padding = New Padding(0)

        Me.Controls.AddRange(New Control() {dgvLines, pnlBottom, pnlTop})

        ' Dashboard is collapsed on this form; skip loading HTML to save resources
    End Sub

    Private Sub LoadSuppliers()
        Dim dt = service.GetSuppliersLookup()
        cboSupplier.DisplayMember = "CompanyName"
        cboSupplier.ValueMember = "SupplierID"
        cboSupplier.DataSource = dt
        cboSupplier.SelectedIndex = -1
    End Sub

    Private Sub LoadPOsForSupplier(supplierId As Integer)
        Dim dt = service.GetOpenPOsBySupplier(supplierId)
        cboPO.DisplayMember = "PONumber"
        cboPO.ValueMember = "PurchaseOrderID"
        cboPO.DataSource = dt
        cboPO.SelectedIndex = -1
    End Sub

    Private Sub LoadPOLines(poId As Integer)
        dgvLines.Rows.Clear()
        Dim dt = service.GetPOLines(poId)
        For Each r As DataRow In dt.Rows
            Dim ordered As Decimal = Convert.ToDecimal(r("OrderedQuantity"))
            Dim receivedTD As Decimal = Convert.ToDecimal(r("ReceivedQuantity"))
            Dim canReceive As Decimal = Math.Max(0D, ordered - receivedTD)
            Dim unitCost As Decimal = Convert.ToDecimal(r("UnitCost"))
            Dim idx = dgvLines.Rows.Add()
            Dim row = dgvLines.Rows(idx)
            row.Cells("POLineID").Value = r("POLineID")
            row.Cells("MaterialID").Value = r("MaterialID")
            row.Cells("MaterialCode").Value = Convert.ToString(r("MaterialCode"))
            row.Cells("MaterialName").Value = Convert.ToString(r("MaterialName"))
            row.Cells("OrderedQuantity").Value = ordered
            row.Cells("ReceivedQuantityToDate").Value = receivedTD
            row.Cells("ReceiveNow").Value = canReceive
            row.Cells("UnitCost").Value = unitCost
            ' Fetch LastCost and AverageCost for the material
            Try
                Dim cs = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using con As New Microsoft.Data.SqlClient.SqlConnection(cs)
                    con.Open()
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT ISNULL(LastCost,0) AS LastCost, ISNULL(AverageCost,0) AS AverageCost FROM RawMaterials WHERE MaterialID=@M", con)
                        cmd.Parameters.AddWithValue("@M", CInt(r("MaterialID")))
                        Using rd = cmd.ExecuteReader()
                            If rd.Read() Then
                                row.Cells("LastCost").Value = Convert.ToDecimal(rd("LastCost"))
                                row.Cells("AverageCost").Value = Convert.ToDecimal(rd("AverageCost"))
                            Else
                                row.Cells("LastCost").Value = 0D
                                row.Cells("AverageCost").Value = 0D
                            End If
                        End Using
                    End Using
                End Using
            Catch
                row.Cells("LastCost").Value = 0D
                row.Cells("AverageCost").Value = 0D
            End Try
            row.Cells("ReturnQty").Value = 0D
            row.Cells("CreditReason").Value = "No Credit Note"
            row.Cells("CreditComments").Value = ""
            row.Cells("CreditAmount").Value = Math.Round(0D * unitCost, 2)
            row.Cells("LineTotal").Value = Math.Round(canReceive * unitCost, 2)
            row.Cells("Variance").Value = ordered - (receivedTD + canReceive)
        Next
        RecalcTotals()
    End Sub

    Private Sub cboSupplier_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboSupplier.SelectedIndexChanged
        If cboSupplier.SelectedIndex >= 0 Then
            selectedSupplierId = CInt(cboSupplier.SelectedValue)
            LoadPOsForSupplier(selectedSupplierId)
        Else
            selectedSupplierId = 0
            cboPO.DataSource = Nothing
            dgvLines.Rows.Clear()
            RecalcTotals()
        End If
        RaiseEvent SidebarContextChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub cboPO_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboPO.SelectedIndexChanged
        If cboPO.SelectedIndex >= 0 Then
            selectedPOId = CInt(cboPO.SelectedValue)
            LoadPOLines(selectedPOId)
        Else
            selectedPOId = 0
            dgvLines.Rows.Clear()
            RecalcTotals()
        End If
        RaiseEvent SidebarContextChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub dgvLines_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs) Handles dgvLines.CellValueChanged
        If e.RowIndex < 0 Then Return
        Dim col = dgvLines.Columns(e.ColumnIndex).Name
        If col = "ReceiveNow" OrElse col = "UnitCost" OrElse col = "ReturnQty" OrElse col = "CreditReason" Then
            Dim row = dgvLines.Rows(e.RowIndex)
            Dim qty = ToDec(row.Cells("ReceiveNow").Value)
            Dim cost = ToDec(row.Cells("UnitCost").Value)
            row.Cells("LineTotal").Value = Math.Round(qty * cost, 2)
            Dim ordered = ToDec(row.Cells("OrderedQuantity").Value)
            Dim recTD = ToDec(row.Cells("ReceivedQuantityToDate").Value)
            row.Cells("Variance").Value = ordered - (recTD + qty)

            ' Auto-suggest ReturnQty when reason is Short-supply
            Dim reason = Convert.ToString(row.Cells("CreditReason").Value)
            If String.Equals(reason, "Short-supply", StringComparison.OrdinalIgnoreCase) Then
                Dim shortage As Decimal = Math.Max(0D, ordered - (recTD + qty))
                row.Cells("ReturnQty").Value = shortage
            End If

            ' Update credit amount from ReturnQty * UnitCost
            Dim ret = ToDec(row.Cells("ReturnQty").Value)
            row.Cells("CreditAmount").Value = Math.Round(ret * cost, 2)
            RecalcTotals()
            RaiseEvent SidebarContextChanged(Me, EventArgs.Empty)
        End If
    End Sub

    Private Sub dgvLines_CurrentCellDirtyStateChanged(sender As Object, e As EventArgs) Handles dgvLines.CurrentCellDirtyStateChanged
        If dgvLines.IsCurrentCellDirty Then dgvLines.CommitEdit(DataGridViewDataErrorContexts.Commit)
    End Sub

    Private Function ToDec(v As Object) As Decimal
        If v Is Nothing OrElse v Is DBNull.Value Then Return 0D
        Dim d As Decimal
        If Decimal.TryParse(v.ToString(), d) Then Return d
        Return 0D
    End Function

    Private Sub RecalcTotals()
        Dim subTot As Decimal = 0D
        For Each row As DataGridViewRow In dgvLines.Rows
            subTot += ToDec(row.Cells("LineTotal").Value)
        Next
        txtSubTotal.Text = subTot.ToString("N2")
        ' Show VAT using current admin setting
        Dim vatRate As Decimal = GetVatRate()
        Dim vat = Math.Round(subTot * (vatRate / 100D), 2)
        txtVat.Text = vat.ToString("N2")
        txtTotal.Text = (subTot + vat).ToString("N2")
    End Sub

    Private Sub dgvLines_CellFormatting(sender As Object, e As DataGridViewCellFormattingEventArgs) Handles dgvLines.CellFormatting
        If e.RowIndex < 0 Then Return
        If dgvLines.Columns(e.ColumnIndex).Name = "CreditBtn" Then
            Dim row = dgvLines.Rows(e.RowIndex)
            Dim ordered = ToDec(row.Cells("OrderedQuantity").Value)
            Dim recTD = ToDec(row.Cells("ReceivedQuantityToDate").Value)
            Dim recvNow = ToDec(row.Cells("ReceiveNow").Value)
            Dim shortage = ordered > (recTD + recvNow)
            Dim btn = CType(row.Cells("CreditBtn"), DataGridViewButtonCell)
            If shortage Then
                btn.Style.BackColor = Drawing.Color.IndianRed
                btn.Style.ForeColor = Drawing.Color.White
                btn.FlatStyle = FlatStyle.Popup
            Else
                btn.Style.BackColor = Drawing.Color.SeaGreen
                btn.Style.ForeColor = Drawing.Color.White
                btn.FlatStyle = FlatStyle.Popup
            End If
        End If
    End Sub

    Private Sub dgvLines_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvLines.CellContentClick
        If e.RowIndex < 0 Then Return
        If dgvLines.Columns(e.ColumnIndex).Name = "CreditBtn" Then
            Dim row = dgvLines.Rows(e.RowIndex)
            ' Toggle quick-fill of ReturnQty to suggest damaged return equals 0 or a small default
            Dim current = ToDec(row.Cells("ReturnQty").Value)
            If current > 0D Then
                row.Cells("ReturnQty").Value = 0D
            Else
                ' Default to 0; user must explicitly enter damaged qty
                row.Cells("ReturnQty").Value = 0D
            End If
        End If
    End Sub

    Private Function GetVatRate() As Decimal
        ' Mirror StockroomService VAT lookup with a simple call
        Dim dt As New DataTable()
        ' Use service helper indirectly: reuse in form by querying SystemSettings directly is avoided to keep single source of truth
        ' Here, quickly compute from subtotal using service method via reflection isn't ideal; instead, call a minimal vat getter
        ' Use a lightweight approach: piggyback on service via a temporary DataTable is overkill; we expose VAT via a small API if needed.
        ' For now, recompute using the same logic: default 15 if not set.
        Try
            ' Direct mini-query
            Dim cs = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Using con As New Microsoft.Data.SqlClient.SqlConnection(cs)
                con.Open()
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT [Value] FROM SystemSettings WHERE [Key]='VATRatePercent'", con)
                    Dim obj = cmd.ExecuteScalar()
                    If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
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

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If selectedSupplierId <= 0 Then
            MessageBox.Show("Select a supplier.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If selectedPOId <= 0 Then
            MessageBox.Show("Select a purchase order.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        ' Build lines datatable for service
        Dim dt As New DataTable()
        dt.Columns.Add("POLineID", GetType(Integer))
        dt.Columns.Add("MaterialID", GetType(Integer))
        dt.Columns.Add("ReceivedQuantity", GetType(Decimal))
        dt.Columns.Add("UnitCost", GetType(Decimal))

        For Each row As DataGridViewRow In dgvLines.Rows
            Dim qty = ToDec(row.Cells("ReceiveNow").Value)
            Dim cost = ToDec(row.Cells("UnitCost").Value)
            If qty > 0D Then
                Dim r = dt.NewRow()
                r("POLineID") = CInt(row.Cells("POLineID").Value)
                r("MaterialID") = CInt(row.Cells("MaterialID").Value)
                r("ReceivedQuantity") = qty
                r("UnitCost") = cost
                dt.Rows.Add(r)
            End If
        Next

        If dt.Rows.Count = 0 Then
            MessageBox.Show("Nothing to receive.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If

        Try
            Dim grnId = service.CreateGRN(selectedPOId, selectedSupplierId, currentBranchId, dtpReceived.Value, txtDeliveryNote.Text, Nothing, currentUserId, dt)

            ' Build credit note lines for credit notes (reason-based)
            Dim crnDt As New DataTable()
            crnDt.Columns.Add("GRNLineID", GetType(Integer)) ' optional/nullable; leave null
            crnDt.Columns.Add("MaterialID", GetType(Integer))
            crnDt.Columns.Add("ReturnQuantity", GetType(Decimal))
            crnDt.Columns.Add("UnitCost", GetType(Decimal))
            crnDt.Columns.Add("Reason", GetType(String))
            crnDt.Columns.Add("Comments", GetType(String))

            For Each row As DataGridViewRow In dgvLines.Rows
                Dim ret = ToDec(row.Cells("ReturnQty").Value)
                If ret > 0D Then
                    Dim reason = Convert.ToString(row.Cells("CreditReason").Value)
                    If Not String.Equals(reason, "No Credit Note", StringComparison.OrdinalIgnoreCase) Then
                        Dim r = crnDt.NewRow()
                        r("GRNLineID") = DBNull.Value
                        r("MaterialID") = CInt(row.Cells("MaterialID").Value)
                        r("ReturnQuantity") = ret
                        r("UnitCost") = ToDec(row.Cells("UnitCost").Value)
                        r("Reason") = reason
                        r("Comments") = Convert.ToString(row.Cells("CreditComments").Value)
                        crnDt.Rows.Add(r)
                    End If
                End If
            Next

            Dim crnMsg As String = ""
            Dim creditNoteAttachment As String = Nothing
            If crnDt.Rows.Count > 0 Then
                Dim headerReason As String = "Credit Note"
                Dim crnId = service.CreateCreditNote(selectedSupplierId, currentBranchId, grnId, dtpReceived.Value, headerReason, txtDeliveryNote.Text, Nothing, currentUserId, crnDt)
                crnMsg = $" and Credit Note ID {crnId}"

                ' Email notification
                Try
                    Dim supplierName As String = If(cboSupplier.SelectedIndex >= 0, cboSupplier.Text, "Supplier")
                    Dim totalAmount As Decimal = 0D
                    For Each r As DataRow In crnDt.Rows
                        totalAmount += CDec(r("ReturnQuantity")) * CDec(r("UnitCost"))
                    Next
                    ' Generate Credit Note PDF and email it as attachment
                    creditNoteAttachment = pdfService.GenerateCreditNotePdf(crnId, supplierName, dtpReceived.Value, headerReason, crnDt)
                    emailService.SendCreditNoteEmail(crnId, supplierName, $"CRN-{crnId}", dtpReceived.Value, totalAmount, Nothing, creditNoteAttachment)
                Catch
                    ' Swallow email errors per user preference to not block flow
                End Try
            End If

            ' Generate GRV and Invoice PDFs for archive/sharing
            Try
                Dim supplierNameG As String = If(cboSupplier.SelectedIndex >= 0, cboSupplier.Text, "Supplier")
                Dim poText As String = If(cboPO.SelectedIndex >= 0, cboPO.Text, "")
                ' Build GRV lines DataTable matching PdfService expectations
                Dim grvLines As New DataTable()
                grvLines.Columns.Add("MaterialName", GetType(String))
                grvLines.Columns.Add("OrderedQuantity", GetType(Decimal))
                grvLines.Columns.Add("ReceivedQuantityToDate", GetType(Decimal))
                grvLines.Columns.Add("ReceiveNow", GetType(Decimal))
                grvLines.Columns.Add("UnitCost", GetType(Decimal))
                For Each gridRow As DataGridViewRow In dgvLines.Rows
                    Dim recvNow = ToDec(gridRow.Cells("ReceiveNow").Value)
                    If recvNow > 0D Then
                        Dim rr = grvLines.NewRow()
                        rr("MaterialName") = Convert.ToString(gridRow.Cells("MaterialName").Value)
                        rr("OrderedQuantity") = ToDec(gridRow.Cells("OrderedQuantity").Value)
                        rr("ReceivedQuantityToDate") = ToDec(gridRow.Cells("ReceivedQuantityToDate").Value)
                        rr("ReceiveNow") = recvNow
                        rr("UnitCost") = ToDec(gridRow.Cells("UnitCost").Value)
                        grvLines.Rows.Add(rr)
                    End If
                Next
                Dim subTot As Decimal = 0D
                Decimal.TryParse(txtSubTotal.Text, subTot)
                Dim vat As Decimal = 0D
                Decimal.TryParse(txtVat.Text, vat)
                Dim tot As Decimal = 0D
                Decimal.TryParse(txtTotal.Text, tot)
                Dim grvPath = pdfService.GenerateGrvPdf(grnId, supplierNameG, poText, dtpReceived.Value, txtDeliveryNote.Text, grvLines, subTot, vat, tot)

                ' Build Invoice lines from received quantities (as a simple supplier invoice representation)
                Dim invLines As New DataTable()
                invLines.Columns.Add("MaterialName", GetType(String))
                invLines.Columns.Add("Quantity", GetType(Decimal))
                invLines.Columns.Add("UnitCost", GetType(Decimal))
                For Each gridRow As DataGridViewRow In dgvLines.Rows
                    Dim recvNow = ToDec(gridRow.Cells("ReceiveNow").Value)
                    If recvNow > 0D Then
                        Dim rr = invLines.NewRow()
                        rr("MaterialName") = Convert.ToString(gridRow.Cells("MaterialName").Value)
                        rr("Quantity") = recvNow
                        rr("UnitCost") = ToDec(gridRow.Cells("UnitCost").Value)
                        invLines.Rows.Add(rr)
                    End If
                Next
                Dim invoicePath = pdfService.GenerateInvoicePdf(grnId, supplierNameG, dtpReceived.Value, invLines, subTot, vat, tot)
                ' Paths are created under My Documents/ERP_Documents for user access
            Catch
                ' Do not block saving if PDF generation fails
            End Try

            ' Prompt to post AP (creditors) journal immediately using Delivery Note as Supplier Invoice No
            Try
                Dim totDec As Decimal = 0D
                Decimal.TryParse(txtTotal.Text, totDec)
                If totDec > 0D AndAlso Not String.IsNullOrWhiteSpace(txtDeliveryNote.Text) Then
                    Dim ans = MessageBox.Show("Post Supplier Invoice to Accounts Payable now using the Delivery Note as the Supplier Invoice Number?", "Post to AP", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
                    If ans = DialogResult.Yes Then
                        Dim ap As New AccountsPayableService()
                        ' Description includes PO and optional credit note info
                        Dim supplierName As String = If(cboSupplier.SelectedIndex >= 0, cboSupplier.Text, "Supplier")
                        Dim desc As String = $"AP Inv {txtDeliveryNote.Text} - {supplierName} - PO {If(cboPO.SelectedIndex >= 0, cboPO.Text, selectedPOId.ToString())}"
                        If Not String.IsNullOrWhiteSpace(crnMsg) Then desc &= $" ({crnMsg.Trim()})"
                        ap.CreateSupplierInvoice(selectedSupplierId, txtDeliveryNote.Text, currentBranchId, dtpReceived.Value, Math.Round(totDec, 2), currentUserId, desc, Nothing)
                    End If
                End If
            Catch ex As Exception
                ' Non-blocking: inform user but continue
                MessageBox.Show("AP posting skipped: " & ex.Message, "Accounts Payable", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End Try

            MessageBox.Show($"GRV saved (GRN ID {grnId}{crnMsg}).", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            ClearForm()
        Catch ex As Exception
            MessageBox.Show("Error saving GRV: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ClearForm()
        ' Reset selections
        cboSupplier.SelectedIndex = -1
        cboPO.DataSource = Nothing
        selectedSupplierId = 0
        selectedPOId = 0
        ' Clear grid and totals
        dgvLines.Rows.Clear()
        txtSubTotal.Text = "0.00"
        txtVat.Text = "0.00"
        txtTotal.Text = "0.00"
        ' Reset header fields
        txtDeliveryNote.Text = String.Empty
        dtpReceived.Value = DateTime.Now
        ' Refresh suppliers list to reflect any external changes
        LoadSuppliers()
        RaiseEvent SidebarContextChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.Close()
    End Sub

    Private Sub ApplyTheme()
        Me.BackColor = Drawing.Color.White
        dgvLines.BackgroundColor = Drawing.Color.White
        dgvLines.AlternatingRowsDefaultCellStyle.BackColor = Drawing.Color.FromArgb(248, 248, 248)
    End Sub
    ' ---------------- ISidebarProvider ----------------
    Public Event SidebarContextChanged As EventHandler Implements ISidebarProvider.SidebarContextChanged

    Public Function BuildSidebarPanel() As Panel Implements ISidebarProvider.BuildSidebarPanel
        Dim p As New Panel() With {.Height = 160, .BackColor = Drawing.Color.White}
        Dim title As New Label() With {
            .Text = "GRV Context",
            .Dock = DockStyle.Top,
            .Height = 24,
            .Font = New Drawing.Font("Segoe UI", 10.0F, Drawing.FontStyle.Bold),
            .Padding = New Padding(8, 6, 8, 0)
        }
        p.Controls.Add(title)

        Dim supplierText As String = If(cboSupplier.SelectedIndex >= 0, cboSupplier.Text, "(none)")
        Dim poText As String = If(cboPO.SelectedIndex >= 0, cboPO.Text, "(none)")

        Dim ordered As Decimal = 0D
        Dim recTD As Decimal = 0D
        Dim recvNow As Decimal = 0D
        Dim variance As Decimal = 0D
        Dim unitCost As Decimal = 0D
        Dim materialName As String = ""
        If dgvLines.CurrentRow IsNot Nothing Then
            materialName = Convert.ToString(dgvLines.CurrentRow.Cells("MaterialName").Value)
            ordered = ToDec(dgvLines.CurrentRow.Cells("OrderedQuantity").Value)
            recTD = ToDec(dgvLines.CurrentRow.Cells("ReceivedQuantityToDate").Value)
            recvNow = ToDec(dgvLines.CurrentRow.Cells("ReceiveNow").Value)
            unitCost = ToDec(dgvLines.CurrentRow.Cells("UnitCost").Value)
            variance = ordered - (recTD + recvNow)
        End If

        Dim info As String = $"Supplier: {supplierText}" & Environment.NewLine &
                             $"PO: {poText}" & Environment.NewLine &
                             $"Material: {If(String.IsNullOrEmpty(materialName), "(none)", materialName)}" & Environment.NewLine &
                             $"Ordered: {ordered:N2}  Rec TD: {recTD:N2}" & Environment.NewLine &
                             $"Receive Now: {recvNow:N2}  Var: {variance:N2}" & Environment.NewLine &
                             $"Unit Cost: {unitCost:N2}  Total: {txtTotal.Text}"

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
