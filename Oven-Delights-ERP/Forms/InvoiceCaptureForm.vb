Imports System.Windows.Forms
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class InvoiceCaptureForm
    Inherits System.Windows.Forms.Form

    Private ReadOnly stockroomService As New StockroomService()
    Private ReadOnly accountingService As New AccountsPayableService()
    Private selectedSupplierId As Integer
    Private selectedPOId As Integer

    Private Sub InvoiceCaptureForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            Me.WindowState = FormWindowState.Maximized
            Me.Show()
            Me.BringToFront()

            LoadSuppliers()
            ConfigureTotalsTextBoxes()
            dtpReceived.Value = DateTime.Now

            AddHandler cboSupplier.SelectedIndexChanged, AddressOf cboSupplier_SelectedIndexChanged
            AddHandler cboPO.SelectedIndexChanged, AddressOf cboPO_SelectedIndexChanged
            AddHandler btnSave.Click, AddressOf btnSave_Click
            AddHandler btnCancel.Click, AddressOf btnCancel_Click
            AddHandler btnApplyDiscount.Click, AddressOf btnApplyDiscount_Click
            AddHandler dgvLines.DataError, AddressOf dgvLines_DataError

        Catch ex As Exception
            MessageBox.Show($"Error loading Invoice Capture form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvLines_DataError(sender As Object, e As DataGridViewDataErrorEventArgs)
        ' Suppress formatting errors (e.g., large numbers like SKU/Barcode exceeding Int32)
        ' Just display the value as-is without formatting
        e.ThrowException = False
        e.Cancel = False
    End Sub

    Private Sub dgvLines_DataBindingComplete(sender As Object, e As DataGridViewBindingCompleteEventArgs) Handles dgvLines.DataBindingComplete
        Try
            For Each r As DataGridViewRow In dgvLines.Rows
                If dgvLines.Columns.Contains("ReceiveNow") Then
                    Dim v = r.Cells("ReceiveNow").Value
                    If v Is Nothing OrElse IsDBNull(v) Then
                        r.Cells("ReceiveNow").Value = 0D
                    End If
                End If
            Next
        Catch
        End Try
    End Sub

    Private Sub dgvLines_RowsAdded(sender As Object, e As DataGridViewRowsAddedEventArgs) Handles dgvLines.RowsAdded
        Try
            For i As Integer = e.RowIndex To (e.RowIndex + e.RowCount - 1)
                If i >= 0 AndAlso i < dgvLines.Rows.Count Then
                    If dgvLines.Columns.Contains("ReceiveNow") Then
                        dgvLines.Rows(i).Cells("ReceiveNow").Value = 0D
                    End If
                End If
            Next
        Catch
        End Try
    End Sub

    Private Sub LoadSuppliers()
        Try
            Dim suppliers = stockroomService.GetSuppliers()
            cboSupplier.DataSource = suppliers
            cboSupplier.DisplayMember = "CompanyName"
            cboSupplier.ValueMember = "SupplierID"
            cboSupplier.SelectedIndex = -1
            
            ' Setup autocomplete like PO form
            If suppliers IsNot Nothing AndAlso suppliers.Rows.Count > 0 Then
                Dim ac As New AutoCompleteStringCollection()
                For Each r As DataRow In suppliers.Rows
                    ac.Add(r("CompanyName").ToString())
                Next
                cboSupplier.AutoCompleteMode = AutoCompleteMode.SuggestAppend
                cboSupplier.AutoCompleteSource = AutoCompleteSource.CustomSource
                cboSupplier.AutoCompleteCustomSource = ac
            End If
        Catch ex As Exception
            MessageBox.Show("Error loading suppliers: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub cboSupplier_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboSupplier.SelectedIndexChanged
        Try
            If cboSupplier.SelectedValue IsNot Nothing Then
                selectedSupplierId = Convert.ToInt32(cboSupplier.SelectedValue)
                LoadPurchaseOrders()
            Else
                selectedSupplierId = 0
                cboPO.DataSource = Nothing
            End If
        Catch
        End Try
    End Sub

    Private Sub LoadPurchaseOrders()
        Try
            If selectedSupplierId > 0 Then
                Dim dt = stockroomService.GetPurchaseOrdersForSupplier(selectedSupplierId)
                cboPO.DataSource = dt
                cboPO.DisplayMember = "PONumber"
                cboPO.ValueMember = "POID"
                cboPO.SelectedIndex = -1

                ' Clear grid if no POs available
                If dt.Rows.Count = 0 Then
                    dgvLines.DataSource = Nothing
                    txtSubTotal.Text = "0.00"
                    txtVat.Text = "0.00"
                    txtTotal.Text = "0.00"
                End If
            End If
        Catch ex As Exception
            MessageBox.Show("Error loading purchase orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub cboPO_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboPO.SelectedIndexChanged
        Try
            If cboPO.SelectedValue IsNot Nothing Then
                selectedPOId = Convert.ToInt32(cboPO.SelectedValue)
                LoadPOLines()
            Else
                selectedPOId = 0
                dgvLines.DataSource = Nothing
            End If
        Catch
        End Try
    End Sub

    Private Sub LoadPOLines()
        Try
            If selectedPOId > 0 Then
                Dim lines = stockroomService.GetPurchaseOrderLines(selectedPOId)

                ' Disable auto-column generation to prevent formatting errors
                dgvLines.AutoGenerateColumns = True
                dgvLines.DataSource = lines

                ' CRITICAL: Verify required columns exist for stock updates
                Dim missingColumns As New List(Of String)
                If Not dgvLines.Columns.Contains("MaterialID") Then missingColumns.Add("MaterialID")
                If Not dgvLines.Columns.Contains("ProductName") Then missingColumns.Add("ProductName")
                If Not dgvLines.Columns.Contains("ProductType") Then missingColumns.Add("ProductType")

                If missingColumns.Count > 0 Then
                    MessageBox.Show("CRITICAL ERROR: Missing required columns in PO lines grid!" & vbCrLf & vbCrLf &
                                  "Missing: " & String.Join(", ", missingColumns) & vbCrLf & vbCrLf &
                                  "Stock updates will FAIL! Contact system administrator.",
                                  "Data Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End If

                ' Set string format for any large numeric columns (like SKU/Barcode)
                For Each col As DataGridViewColumn In dgvLines.Columns
                    If col.ValueType Is GetType(Long) OrElse col.ValueType Is GetType(Int64) Then
                        col.DefaultCellStyle.Format = ""
                        col.ValueType = GetType(String)
                    End If
                Next
                
                ' Configure ReceiveNow column to accept decimals
                If dgvLines.Columns.Contains("ReceiveNow") Then
                    dgvLines.Columns("ReceiveNow").ValueType = GetType(Decimal)
                    dgvLines.Columns("ReceiveNow").DefaultCellStyle.Format = "N2"
                    dgvLines.Columns("ReceiveNow").DefaultCellStyle.NullValue = 0D
                End If

                ' Add dropdown for CreditReason column
                If dgvLines.Columns.Contains("CreditReason") Then
                    Dim creditReasonColumn As DataGridViewComboBoxColumn = New DataGridViewComboBoxColumn()
                    creditReasonColumn.Name = "CreditReason"
                    creditReasonColumn.HeaderText = "Credit Reason"
                    creditReasonColumn.Items.AddRange({"No Credit Note", "Damaged Goods", "Wrong Item", "Quality Issue", "Overcharge", "Other"})
                    creditReasonColumn.DefaultCellStyle.NullValue = "No Credit Note"

                    Dim oldIndex = dgvLines.Columns("CreditReason").Index
                    dgvLines.Columns.RemoveAt(oldIndex)
                    dgvLines.Columns.Insert(oldIndex, creditReasonColumn)
                End If

                ' Add Credit Note button column
                If Not dgvLines.Columns.Contains("CreditBtn") Then
                    Dim btnColumn As New DataGridViewButtonColumn()
                    btnColumn.Name = "CreditBtn"
                    btnColumn.HeaderText = "Credit Note"
                    btnColumn.Text = "Print CN"
                    btnColumn.UseColumnTextForButtonValue = False
                    dgvLines.Columns.Add(btnColumn)
                End If
            End If
        Catch ex As Exception
            MessageBox.Show("Error loading PO lines: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvLines_CellFormatting(sender As Object, e As DataGridViewCellFormattingEventArgs) Handles dgvLines.CellFormatting
        If e.RowIndex < 0 Then Return
        If dgvLines.Columns(e.ColumnIndex).Name = "CreditBtn" Then
            Dim row = dgvLines.Rows(e.RowIndex)
            Dim returnQty = If(row.Cells("ReturnQty").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("ReturnQty").Value))
            Dim creditReason = Convert.ToString(row.Cells("CreditReason").Value)

            If returnQty > 0 AndAlso creditReason <> "No Credit Note" Then
                e.Value = "Print CN"
            Else
                e.Value = ""
            End If
        End If
    End Sub

    Private Sub dgvLines_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvLines.CellContentClick
        If e.RowIndex < 0 Then Return
        If dgvLines.Columns(e.ColumnIndex).Name = "CreditBtn" Then
            Dim row = dgvLines.Rows(e.RowIndex)
            Dim returnQty = If(row.Cells("ReturnQty").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("ReturnQty").Value))
            Dim creditReason = Convert.ToString(row.Cells("CreditReason").Value)

            If returnQty > 0 AndAlso creditReason <> "No Credit Note" Then
                CreateAndPrintCreditNote(row)
            Else
                MessageBox.Show("Please enter return quantity and select credit reason.", "Credit Note", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        End If
    End Sub

    Private Sub CreateAndPrintCreditNote(row As DataGridViewRow)
        Try
            Dim returnQty = Convert.ToDecimal(row.Cells("ReturnQty").Value)
            Dim unitCost = Convert.ToDecimal(row.Cells("UnitCost").Value)
            Dim creditReason = Convert.ToString(row.Cells("CreditReason").Value)
            Dim comments = Convert.ToString(row.Cells("CreditComments").Value)
            Dim productCode = Convert.ToString(row.Cells("ProductCode").Value)
            Dim productName = Convert.ToString(row.Cells("ProductName").Value)

            ' Generate credit note letter directly in textbox
            Dim letter As New System.Text.StringBuilder()
            letter.AppendLine("OVEN DELIGHTS (PTY) LTD")
            letter.AppendLine("123 Baker Street, Johannesburg, 2000")
            letter.AppendLine("Tel: (011) 123-4567")
            letter.AppendLine("Email: accounts@ovendelights.co.za")
            letter.AppendLine()
            letter.AppendLine("CREDIT NOTE")
            letter.AppendLine("=" & String.Empty.PadRight(50, "="))
            letter.AppendLine()
            letter.AppendLine($"Credit Note Number: CN{DateTime.Now:yyyyMMddHHmmss}")
            letter.AppendLine($"Date: {DateTime.Now:dd MMMM yyyy}")
            letter.AppendLine($"Supplier: {cboSupplier.Text}")
            letter.AppendLine($"PO Number: {cboPO.Text}")
            letter.AppendLine()
            letter.AppendLine("Dear Sir/Madam,")
            letter.AppendLine()
            letter.AppendLine("RE: CREDIT NOTE FOR RETURNED GOODS")
            letter.AppendLine()
            letter.AppendLine($"We are issuing this credit note for the following reason: {creditReason}")
            letter.AppendLine()
            letter.AppendLine("ITEM DETAILS:")
            letter.AppendLine($"Product Code: {productCode}")
            letter.AppendLine($"Description: {productName}")
            letter.AppendLine($"Quantity Returned: {returnQty:N2}")
            letter.AppendLine($"Unit Cost: R {unitCost:N2}")
            letter.AppendLine($"Total Credit Amount: R {(returnQty * unitCost):N2}")
            letter.AppendLine()
            If Not String.IsNullOrEmpty(comments) Then
                letter.AppendLine($"Comments: {comments}")
                letter.AppendLine()
            End If
            letter.AppendLine("Please adjust your records accordingly.")
            letter.AppendLine()
            letter.AppendLine("Yours faithfully,")
            letter.AppendLine("OVEN DELIGHTS ACCOUNTS DEPARTMENT")

            ' Resize grid to top half and full width
            dgvLines.Location = New Point(10, 150)
            dgvLines.Size = New Size(Me.Width - 40, (Me.Height - 200) \ 2)
            dgvLines.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right

            ' Show letter in bottom half
            Dim txtLetter As TextBox
            If Me.Controls.ContainsKey("txtCreditNoteLetter") Then
                txtLetter = DirectCast(Me.Controls("txtCreditNoteLetter"), TextBox)
                txtLetter.Text = letter.ToString()
                txtLetter.Location = New Point(10, dgvLines.Bottom + 10)
                txtLetter.Size = New Size(Me.Width - 40, (Me.Height - 200) \ 2 - 90)
            Else
                txtLetter = New TextBox()
                txtLetter.Name = "txtCreditNoteLetter"
                txtLetter.Multiline = True
                txtLetter.ScrollBars = ScrollBars.Vertical
                txtLetter.Font = New Font("Courier New", 10)
                txtLetter.Location = New Point(10, dgvLines.Bottom + 10)
                txtLetter.Size = New Size(Me.Width - 40, (Me.Height - 200) \ 2 - 90)
                txtLetter.Anchor = AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right
                txtLetter.Text = letter.ToString()
                Me.Controls.Add(txtLetter)
            End If

            ' Add Print and Email buttons if they don't exist
            If Not Me.Controls.ContainsKey("btnPrintCreditNote") Then
                Dim btnPrint As New Button()
                btnPrint.Name = "btnPrintCreditNote"
                btnPrint.Text = "🖨️ Print Credit Note"
                btnPrint.Location = New Point(10, txtLetter.Bottom + 5)
                btnPrint.Size = New Size(180, 35)
                btnPrint.BackColor = ColorTranslator.FromHtml("#27AE60")
                btnPrint.ForeColor = Color.White
                btnPrint.FlatStyle = FlatStyle.Flat
                btnPrint.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                AddHandler btnPrint.Click, Sub()
                                               Try
                                                   Dim printDialog As New PrintDialog()
                                                   Dim printDoc As New System.Drawing.Printing.PrintDocument()
                                                   AddHandler printDoc.PrintPage, Sub(s, ev)
                                                                                      ev.Graphics.DrawString(txtLetter.Text, New Font("Courier New", 10), Brushes.Black, 50, 50)
                                                                                  End Sub
                                                   If printDialog.ShowDialog() = DialogResult.OK Then
                                                       printDoc.Print()
                                                       MessageBox.Show("Credit note printed successfully!", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
                                                   End If
                                               Catch ex As Exception
                                                   MessageBox.Show($"Print error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                               End Try
                                           End Sub
                Me.Controls.Add(btnPrint)

                Dim btnEmail As New Button()
                btnEmail.Name = "btnEmailCreditNote"
                btnEmail.Text = "📧 Email Credit Note"
                btnEmail.Location = New Point(200, txtLetter.Bottom + 5)
                btnEmail.Size = New Size(180, 35)
                btnEmail.BackColor = ColorTranslator.FromHtml("#E67E22")
                btnEmail.ForeColor = Color.White
                btnEmail.FlatStyle = FlatStyle.Flat
                btnEmail.Font = New Font("Segoe UI", 10, FontStyle.Bold)
                AddHandler btnEmail.Click, Sub()
                                               Try
                                                   ' Create mailto link with credit note content
                                                   Dim subject = $"Credit Note - CN{DateTime.Now:yyyyMMddHHmmss}"
                                                   Dim body = Uri.EscapeDataString(txtLetter.Text)
                                                   Dim mailto = $"mailto:?subject={subject}&body={body}"
                                                   System.Diagnostics.Process.Start(New System.Diagnostics.ProcessStartInfo(mailto) With {.UseShellExecute = True})
                                                   MessageBox.Show("Email client opened with credit note!", "Email", MessageBoxButtons.OK, MessageBoxIcon.Information)
                                               Catch ex As Exception
                                                   MessageBox.Show($"Email error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                               End Try
                                           End Sub
                Me.Controls.Add(btnEmail)
            End If

            MessageBox.Show("Credit note generated successfully! Use Print or Email buttons below.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)

        Catch ex As Exception
            MessageBox.Show("Error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Try
            If selectedSupplierId <= 0 Then
                MessageBox.Show("Please select a supplier.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If selectedPOId <= 0 Then
                MessageBox.Show("Please select a purchase order.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If String.IsNullOrWhiteSpace(txtDeliveryNote.Text) Then
                MessageBox.Show("Please enter an Invoice Number.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtDeliveryNote.Focus()
                Return
            End If
            
            ' Check for duplicate invoice number
            If CheckDuplicateInvoiceNumber(txtDeliveryNote.Text.Trim(), selectedSupplierId) Then
                MessageBox.Show($"Invoice Number '{txtDeliveryNote.Text.Trim()}' already exists for this supplier. Please enter a unique invoice number.", "Duplicate Invoice", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtDeliveryNote.Focus()
                txtDeliveryNote.SelectAll()
                Return
            End If

            Dim hasReceiveNow As Boolean = False
            For Each row As DataGridViewRow In dgvLines.Rows
                If Not row.IsNewRow Then
                    Dim receiveNow = If(row.Cells("ReceiveNow").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("ReceiveNow").Value))
                    If receiveNow > 0 Then
                        hasReceiveNow = True
                        Exit For
                    End If
                End If
            Next

            If Not hasReceiveNow Then
                MessageBox.Show("Please enter quantities to receive.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            ' Calculate totals
            Dim subTotal As Decimal = 0
            For Each row As DataGridViewRow In dgvLines.Rows
                If Not row.IsNewRow Then
                    Dim receiveNow = If(row.Cells("ReceiveNow").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("ReceiveNow").Value))
                    Dim unitCost = If(row.Cells("UnitCost").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("UnitCost").Value))
                    subTotal += receiveNow * unitCost
                End If
            Next
            
            ' Apply discount - use Rand discount value directly
            Dim discountAmount As Decimal = 0
            Dim discountPercent As Decimal = 0
            
            ' Get discount amount from txtDiscountRand
            If Decimal.TryParse(txtDiscountRand.Text, discountAmount) AndAlso discountAmount > 0 Then
                subTotal = subTotal - discountAmount
                ' Calculate percentage for saving
                If subTotal > 0 Then
                    discountPercent = Math.Round((discountAmount / (subTotal + discountAmount)) * 100, 4)
                End If
            End If
            
            Dim vatAmount As Decimal = Math.Round(subTotal * 0.15D, 4)
            Dim totalAmount As Decimal = subTotal + vatAmount

            ' Save GRV and update inventory
            Dim grvId = stockroomService.SaveGoodsReceivedVoucher(selectedSupplierId, selectedPOId, txtDeliveryNote.Text, dtpReceived.Value, dgvLines)

            ' Create Supplier Invoice record
            CreateSupplierInvoice(selectedSupplierId, selectedPOId, txtDeliveryNote.Text, dtpReceived.Value, subTotal, vatAmount, totalAmount, grvId, discountAmount, discountPercent)

            ' Update inventory based on ProductType
            Dim branchId As Integer = If(AppSession.CurrentUser IsNot Nothing AndAlso AppSession.CurrentUser.BranchID.HasValue, AppSession.CurrentUser.BranchID.Value, 0)

            For Each row As DataGridViewRow In dgvLines.Rows
                If Not row.IsNewRow Then
                    Dim receiveNow = If(row.Cells("ReceiveNow").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("ReceiveNow").Value))
                    If receiveNow > 0 Then
                        Dim productType = If(row.Cells("ProductType").Value, "").ToString().Trim()
                        Dim unitCost = If(row.Cells("UnitCost").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("UnitCost").Value))

                        ' Check if it's a raw material (includes ingredients and sub-recipes)
                        If productType.Contains("Material") OrElse productType.Contains("Ingredient") OrElse productType.Contains("Recipe") Then
                            ' Get MaterialID for raw materials - try all possible columns
                            Dim materialId As Integer = 0
                            If dgvLines.Columns.Contains("MaterialID") AndAlso row.Cells("MaterialID").Value IsNot Nothing AndAlso Not IsDBNull(row.Cells("MaterialID").Value) Then
                                materialId = Convert.ToInt32(row.Cells("MaterialID").Value)
                            ElseIf dgvLines.Columns.Contains("ProductID") AndAlso row.Cells("ProductID").Value IsNot Nothing AndAlso Not IsDBNull(row.Cells("ProductID").Value) Then
                                materialId = Convert.ToInt32(row.Cells("ProductID").Value)
                            ElseIf dgvLines.Columns.Contains("RawMaterialCode") AndAlso row.Cells("RawMaterialCode").Value IsNot Nothing Then
                                ' Try to get MaterialID from RawMaterialCode
                                Dim code = row.Cells("RawMaterialCode").Value.ToString()
                                Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                                    con.Open()
                                    Using cmd As New SqlCommand("SELECT MaterialID FROM RawMaterials WHERE MaterialCode = @Code", con)
                                        cmd.Parameters.AddWithValue("@Code", code)
                                        Dim result = cmd.ExecuteScalar()
                                        If result IsNot Nothing Then materialId = Convert.ToInt32(result)
                                    End Using
                                End Using
                            End If

                            If materialId > 0 Then
                                stockroomService.UpdateRawMaterialStock(materialId, receiveNow, "Received from PO " & cboPO.Text)
                                Dim productName = If(row.Cells("ProductName").Value, "").ToString().Trim()
                                If Not String.IsNullOrEmpty(productName) Then UpdateLastPaidPriceByName(productName, unitCost)
                            End If
                        ElseIf productType.Contains("Product") OrElse productType = "External" Then
                            ' Get ProductID for external products
                            Dim productId As Integer = 0
                            If dgvLines.Columns.Contains("ProductID") AndAlso row.Cells("ProductID").Value IsNot Nothing Then
                                productId = Convert.ToInt32(row.Cells("ProductID").Value)
                            End If

                            If productId > 0 Then
                                UpdateExternalProductInventory(productId, branchId, receiveNow, unitCost)
                            End If
                        Else
                            ' Default to raw material if type is unclear - try MaterialID first, then ProductID
                            Dim materialId As Integer = 0
                            If dgvLines.Columns.Contains("MaterialID") AndAlso row.Cells("MaterialID").Value IsNot Nothing Then
                                materialId = Convert.ToInt32(row.Cells("MaterialID").Value)
                            ElseIf dgvLines.Columns.Contains("ProductID") AndAlso row.Cells("ProductID").Value IsNot Nothing Then
                                materialId = Convert.ToInt32(row.Cells("ProductID").Value)
                            End If

                            If materialId > 0 Then
                                stockroomService.UpdateRawMaterialStock(materialId, receiveNow, "Received from PO " & cboPO.Text)
                                UpdateLastPaidPrice(materialId, unitCost, "RawMaterial")
                            End If
                        End If
                    End If
                End If
            Next

            ' Update PO status to captured/closed
            stockroomService.UpdatePurchaseOrderStatus(selectedPOId, "Captured")

            MessageBox.Show("GRV saved successfully! Inventory updated.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)

            ' Refresh PO dropdown to remove captured PO
            LoadPurchaseOrders()

            ' Clear the form
            cboPO.SelectedIndex = -1
            dgvLines.DataSource = Nothing
            txtSubTotal.Text = "0.00"
            txtVat.Text = "0.00"
            txtTotal.Text = "0.00"

            Me.Close()

        Catch ex As Exception
            MessageBox.Show("Error saving GRV: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.Close()
    End Sub

    Private Sub ConfigureTotalsTextBoxes()
        txtSubTotal.ReadOnly = True
        txtSubTotal.TextAlign = HorizontalAlignment.Right
        txtVat.ReadOnly = True
        txtVat.TextAlign = HorizontalAlignment.Right
        txtTotal.ReadOnly = True
        txtTotal.TextAlign = HorizontalAlignment.Right
        txtSubTotal.Text = "0.00"
        txtVat.Text = "0.00"
        txtTotal.Text = "0.00"

        ' Add event handlers for total calculation
        AddHandler dgvLines.CellValueChanged, AddressOf CalculateTotals
        AddHandler dgvLines.RowsAdded, AddressOf CalculateTotals
        AddHandler dgvLines.RowsRemoved, AddressOf CalculateTotals
        AddHandler txtDiscount.TextChanged, AddressOf txtDiscount_TextChanged
        AddHandler txtDiscountRand.TextChanged, AddressOf txtDiscountRand_TextChanged
    End Sub

    Private Sub CalculateTotals(sender As Object, e As EventArgs)
        Try
            ' PURCHASE ORDER PRICING: UnitCost is EXCLUDING VAT
            ' Calculate totals respecting IsVatable status
            ' Vatable items: Add 15% VAT to excl VAT price
            ' Non-vatable items: No VAT added
            
            Dim subTotalVatable As Decimal = 0
            Dim subTotalNonVatable As Decimal = 0
            Dim vatTotal As Decimal = 0
            
            For Each row As DataGridViewRow In dgvLines.Rows
                If Not row.IsNewRow Then
                    Dim receiveNow = If(row.Cells("ReceiveNow").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("ReceiveNow").Value))
                    Dim unitCost = If(row.Cells("UnitCost").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("UnitCost").Value))
                    Dim lineTotalExclVAT As Decimal = receiveNow * unitCost
                    
                    ' Get ProductID to check IsVatable
                    Dim productId As Integer = 0
                    If row.Cells("ProductID").Value IsNot Nothing Then
                        productId = Convert.ToInt32(row.Cells("ProductID").Value)
                    End If
                    
                    ' Check if product is vatable
                    Dim isVatable As Boolean = True
                    If productId > 0 Then
                        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                            conn.Open()
                            Using cmd As New SqlCommand("SELECT ISNULL(IsVatable, 1) FROM Demo_Retail_Product WHERE ProductID = @ProductID", conn)
                                cmd.Parameters.AddWithValue("@ProductID", productId)
                                Dim result = cmd.ExecuteScalar()
                                If result IsNot Nothing Then isVatable = Convert.ToBoolean(result)
                            End Using
                        End Using
                    End If
                    
                    If isVatable Then
                        ' Price is excl VAT - calculate VAT amount
                        Dim lineVAT As Decimal = Math.Round(lineTotalExclVAT * 0.15D, 4)
                        subTotalVatable += lineTotalExclVAT
                        vatTotal += lineVAT
                    Else
                        ' Price has no VAT
                        subTotalNonVatable += lineTotalExclVAT
                    End If
                End If
            Next
            
            Dim subTotal As Decimal = subTotalVatable + subTotalNonVatable
            Dim originalSubTotal As Decimal = subTotal
            
            ' Apply discount - check if Rand discount or Percentage discount is entered
            Dim discountRand As Decimal = 0
            Dim discountPercent As Decimal = 0
            
            ' Priority: Rand discount takes precedence over percentage
            If Decimal.TryParse(txtDiscountRand.Text, discountRand) AndAlso discountRand > 0 Then
                ' Apply Rand discount to subtotal (excl VAT)
                subTotal = subTotal - discountRand
                ' Recalculate VAT on discounted subtotal
                vatTotal = Math.Round(subTotal * 0.15D, 4)
            ElseIf Decimal.TryParse(txtDiscount.Text, discountPercent) AndAlso discountPercent > 0 Then
                ' Apply percentage discount to subtotal (excl VAT)
                Dim discountAmount As Decimal = Math.Round(originalSubTotal * (discountPercent / 100), 4)
                subTotal = subTotal - discountAmount
                ' Recalculate VAT on discounted subtotal
                vatTotal = Math.Round(subTotal * 0.15D, 4)
            End If
            
            Dim total As Decimal = subTotal + vatTotal

            txtSubTotal.Text = originalSubTotal.ToString("N4")
            txtVat.Text = vatTotal.ToString("N4")
            txtTotal.Text = total.ToString("N4")
        Catch ex As Exception
            ' Ignore calculation errors
        End Try
    End Sub

    Private Sub btnApplyDiscount_Click(sender As Object, e As EventArgs)
        Try
            Dim discountPercent As Decimal
            If Not Decimal.TryParse(txtDiscount.Text, discountPercent) Then
                MessageBox.Show("Please enter a valid discount percentage.", "Invalid Discount", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtDiscount.Focus()
                Return
            End If
            
            If discountPercent < 0 OrElse discountPercent > 100 Then
                MessageBox.Show("Discount must be between 0% and 100%.", "Invalid Discount", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtDiscount.Focus()
                Return
            End If
            
            CalculateTotals(Nothing, EventArgs.Empty)
            
            MessageBox.Show($"Discount of {discountPercent}% applied successfully!\n\nNew Total: R {txtTotal.Text}", "Discount Applied", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error applying discount: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub CreateSupplierInvoice(supplierId As Integer, purchaseOrderId As Integer, invoiceNumber As String, invoiceDate As DateTime, subTotal As Decimal, vatAmount As Decimal, totalAmount As Decimal, grvId As Integer, discountAmount As Decimal, discountPercent As Decimal)
        Try
            Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                con.Open()
                Using tx = con.BeginTransaction()
                    Try
                        ' Create supplier invoice header
                        Dim invoiceId As Integer
                        Dim sql = "INSERT INTO SupplierInvoices (InvoiceNumber, SupplierID, BranchID, PurchaseOrderID, InvoiceDate, DueDate, SubTotal, VATAmount, TotalAmount, AmountPaid, AmountOutstanding, Status, GRVID, DiscountAmount, DiscountPercent, CreatedBy) " &
                                 "VALUES (@InvNum, @SupID, @BranchID, @POID, @InvDate, @DueDate, @SubTotal, @VAT, @Total, 0, @Total, 'Unpaid', @GRVID, @DiscountAmount, @DiscountPercent, @UserID); SELECT SCOPE_IDENTITY();"
                        Using cmd As New SqlCommand(sql, con, tx)
                            cmd.Parameters.AddWithValue("@InvNum", invoiceNumber)
                            cmd.Parameters.AddWithValue("@SupID", supplierId)
                            cmd.Parameters.AddWithValue("@BranchID", AppSession.CurrentBranchID)
                            cmd.Parameters.AddWithValue("@POID", purchaseOrderId)
                            cmd.Parameters.AddWithValue("@InvDate", invoiceDate)
                            cmd.Parameters.AddWithValue("@DueDate", invoiceDate.AddDays(30))
                            cmd.Parameters.AddWithValue("@SubTotal", subTotal)
                            cmd.Parameters.AddWithValue("@VAT", vatAmount)
                            cmd.Parameters.AddWithValue("@Total", totalAmount)
                            cmd.Parameters.AddWithValue("@GRVID", grvId)
                            cmd.Parameters.AddWithValue("@DiscountAmount", discountAmount)
                            cmd.Parameters.AddWithValue("@DiscountPercent", discountPercent)
                            cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
                            invoiceId = Convert.ToInt32(cmd.ExecuteScalar())
                        End Using

                        ' Insert invoice lines
                        For Each row As DataGridViewRow In dgvLines.Rows
                            If Not row.IsNewRow Then
                                Dim receivedQty As Decimal = If(row.Cells("ReceiveNow").Value, 0D)
                                If receivedQty > 0 Then
                                    Dim itemId As Integer = If(row.Cells("ProductID").Value, 0)
                                    If itemId > 0 Then
                                        Dim productType As String = If(row.Cells("ProductType").Value, "").ToString()
                                        Dim itemSource As String = If(productType.Contains("Product"), "PR", "RM")
                                        Dim unitPrice As Decimal = If(row.Cells("UnitCost").Value, 0D)
                                        Dim lineTotal As Decimal = receivedQty * unitPrice
                                        
                                        Dim lineSql = "INSERT INTO SupplierInvoiceLines (InvoiceID, ItemID, ItemSource, Description, Quantity, UnitPrice, LineTotal) " &
                                                     "VALUES (@InvoiceID, @ItemID, @ItemSource, @Description, @Quantity, @UnitPrice, @LineTotal)"
                                        Using lineCmd As New SqlCommand(lineSql, con, tx)
                                            lineCmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                                            lineCmd.Parameters.AddWithValue("@ItemID", itemId)
                                            lineCmd.Parameters.AddWithValue("@ItemSource", itemSource)
                                            lineCmd.Parameters.AddWithValue("@Description", If(row.Cells("ProductName").Value, ""))
                                            lineCmd.Parameters.AddWithValue("@Quantity", receivedQty)
                                            lineCmd.Parameters.AddWithValue("@UnitPrice", unitPrice)
                                            lineCmd.Parameters.AddWithValue("@LineTotal", lineTotal)
                                            lineCmd.ExecuteNonQuery()
                                        End Using
                                    End If
                                End If
                            End If
                        Next

                        ' Create journal entries
                        CreatePurchaseJournalEntries(supplierId, invoiceNumber, subTotal, vatAmount, totalAmount, con, tx)

                        ' Create supplier ledger entry
                        CreateSupplierLedgerEntry(supplierId, invoiceId, invoiceNumber, totalAmount, con, tx)

                        ' Also insert into AP_Invoices for FNB bulk payment system
                        ' First get or create beneficiary from supplier
                        Dim beneficiaryId As Integer = 0
                        Dim getBeneficiarySql = "SELECT BeneficiaryID FROM AP_Beneficiaries WHERE BeneficiaryName = (SELECT CompanyName FROM Suppliers WHERE SupplierID = @SupplierID)"
                        Using cmd As New SqlCommand(getBeneficiarySql, con, tx)
                            cmd.Parameters.AddWithValue("@SupplierID", supplierId)
                            Dim result = cmd.ExecuteScalar()
                            If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                                beneficiaryId = Convert.ToInt32(result)
                            End If
                        End Using
                        
                        ' If beneficiary doesn't exist, create it from supplier
                        If beneficiaryId = 0 Then
                            Dim createBeneficiarySql = "INSERT INTO AP_Beneficiaries (BeneficiaryName, BankName, BranchCode, AccountNumber, AccountType, AccountHolderName, IsActive) " &
                                                      "SELECT CompanyName, BankName, BranchCode, AccountNumber, 'Current', CompanyName, 1 FROM Suppliers WHERE SupplierID = @SupplierID; SELECT SCOPE_IDENTITY();"
                            Using cmd As New SqlCommand(createBeneficiarySql, con, tx)
                                cmd.Parameters.AddWithValue("@SupplierID", supplierId)
                                Dim result = cmd.ExecuteScalar()
                                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                                    beneficiaryId = Convert.ToInt32(result)
                                End If
                            End Using
                        End If
                        
                        ' Insert or update AP_Invoices if beneficiary exists
                        If beneficiaryId > 0 Then
                            Dim categoryId As Integer = 1 ' Default category
                            Dim getCategorySql = "SELECT TOP 1 CategoryID FROM AP_Categories WHERE CategoryName = 'Supplier Invoice' OR CategoryName LIKE '%Supplier%'"
                            Using cmd As New SqlCommand(getCategorySql, con, tx)
                                Dim result = cmd.ExecuteScalar()
                                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                                    categoryId = Convert.ToInt32(result)
                                End If
                            End Using
                            
                            ' Check if invoice already exists for this beneficiary
                            Dim existingInvoiceId As Integer = 0
                            Dim checkSql = "SELECT InvoiceID FROM AP_Invoices WHERE InvoiceNumber = @InvNum AND BeneficiaryID = @BeneficiaryID"
                            Using cmd As New SqlCommand(checkSql, con, tx)
                                cmd.Parameters.AddWithValue("@InvNum", invoiceNumber)
                                cmd.Parameters.AddWithValue("@BeneficiaryID", beneficiaryId)
                                Dim result = cmd.ExecuteScalar()
                                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                                    existingInvoiceId = Convert.ToInt32(result)
                                End If
                            End Using
                            
                            If existingInvoiceId > 0 Then
                                ' Update existing invoice
                                Dim updateAPSql = "UPDATE AP_Invoices SET Amount = @Amount, TaxAmount = @Tax, InvoiceDate = @InvDate, DueDate = @DueDate, " &
                                                "Description = @Description, ModifiedBy = @UserID, ModifiedDate = GETDATE() " &
                                                "WHERE InvoiceID = @InvoiceID"
                                Using cmd As New SqlCommand(updateAPSql, con, tx)
                                    cmd.Parameters.AddWithValue("@InvoiceID", existingInvoiceId)
                                    cmd.Parameters.AddWithValue("@Amount", subTotal)
                                    cmd.Parameters.AddWithValue("@Tax", vatAmount)
                                    cmd.Parameters.AddWithValue("@InvDate", invoiceDate)
                                    cmd.Parameters.AddWithValue("@DueDate", invoiceDate.AddDays(30))
                                    cmd.Parameters.AddWithValue("@Description", $"Supplier Invoice from GRV")
                                    cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
                                    cmd.ExecuteNonQuery()
                                End Using
                            Else
                                ' Insert new invoice
                                Dim insertAPSql = "INSERT INTO AP_Invoices (InvoiceNumber, BeneficiaryID, CategoryID, InvoiceDate, DueDate, Amount, TaxAmount, Description, Status, CreatedBy) " &
                                                "VALUES (@InvNum, @BeneficiaryID, @CategoryID, @InvDate, @DueDate, @Amount, @Tax, @Description, 'Pending', @UserID)"
                                Using cmd As New SqlCommand(insertAPSql, con, tx)
                                    cmd.Parameters.AddWithValue("@InvNum", invoiceNumber)
                                    cmd.Parameters.AddWithValue("@BeneficiaryID", beneficiaryId)
                                    cmd.Parameters.AddWithValue("@CategoryID", categoryId)
                                    cmd.Parameters.AddWithValue("@InvDate", invoiceDate)
                                    cmd.Parameters.AddWithValue("@DueDate", invoiceDate.AddDays(30))
                                    cmd.Parameters.AddWithValue("@Amount", subTotal)
                                    cmd.Parameters.AddWithValue("@Tax", vatAmount)
                                    cmd.Parameters.AddWithValue("@Description", $"Supplier Invoice from GRV")
                                    cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
                                    cmd.ExecuteNonQuery()
                                End Using
                            End If
                        End If

                        tx.Commit()
                    Catch
                        tx.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        Catch ex As Exception
            ' Log error but don't stop the process
            MessageBox.Show($"Warning: Could not create supplier invoice record: {ex.Message}", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub CreatePurchaseJournalEntries(supplierId As Integer, reference As String, subTotal As Decimal, vatAmount As Decimal, totalAmount As Decimal, con As SqlConnection, tx As SqlTransaction)
        ' Create journal header
        Dim journalId As Integer
        ' Get fiscal period
        Dim fiscalPeriodId As Integer = 0
        Using cmdFP As New SqlCommand("SELECT TOP 1 PeriodID FROM dbo.FiscalPeriods WHERE GETDATE() BETWEEN StartDate AND EndDate AND IsClosed = 0 ORDER BY StartDate DESC", con, tx)
            Dim fpResult = cmdFP.ExecuteScalar()
            If fpResult IsNot Nothing AndAlso Not IsDBNull(fpResult) Then
                fiscalPeriodId = Convert.ToInt32(fpResult)
            End If
        End Using

        If fiscalPeriodId <= 0 Then
            ' No fiscal period - skip journal entry
            Return
        End If

        Dim jSql = "INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy) " &
                  "OUTPUT INSERTED.JournalID VALUES (@JNum, @BranchID, GETDATE(), @Ref, @Desc, @FP, 0, @UserID)"
        Using cmd As New SqlCommand(jSql, con, tx)
            cmd.Parameters.AddWithValue("@JNum", $"PI-{reference}")
            cmd.Parameters.AddWithValue("@BranchID", AppSession.CurrentBranchID)
            cmd.Parameters.AddWithValue("@Ref", reference)
            cmd.Parameters.AddWithValue("@Desc", "Purchase Invoice")
            cmd.Parameters.AddWithValue("@FP", fiscalPeriodId)
            cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
            journalId = Convert.ToInt32(cmd.ExecuteScalar())
        End Using

        ' DR Inventory
        Dim dSql = "INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description) VALUES (@JID, @LineNum, @AcctID, @Amount, 0, @Desc)"
        Using cmd As New SqlCommand(dSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", journalId)
            cmd.Parameters.AddWithValue("@LineNum", 1)
            cmd.Parameters.AddWithValue("@AcctID", GetOrCreateAccountID(con, tx, "1200", "Inventory", "Asset"))
            cmd.Parameters.AddWithValue("@Amount", subTotal)
            cmd.Parameters.AddWithValue("@Desc", $"Inventory - {reference}")
            cmd.ExecuteNonQuery()
        End Using

        ' DR VAT Input
        Using cmd As New SqlCommand(dSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", journalId)
            cmd.Parameters.AddWithValue("@LineNum", 2)
            cmd.Parameters.AddWithValue("@AcctID", GetOrCreateAccountID(con, tx, "1300", "VAT Input", "Asset"))
            cmd.Parameters.AddWithValue("@Amount", vatAmount)
            cmd.Parameters.AddWithValue("@Desc", $"VAT Input - {reference}")
            cmd.ExecuteNonQuery()
        End Using

        ' CR Accounts Payable
        Dim cSql = "INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description) VALUES (@JID, @LineNum, @AcctID, 0, @Amount, @Desc)"
        Using cmd As New SqlCommand(cSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", journalId)
            cmd.Parameters.AddWithValue("@LineNum", 3)
            cmd.Parameters.AddWithValue("@AcctID", GetOrCreateAccountID(con, tx, "2100", "Accounts Payable", "Liability"))
            cmd.Parameters.AddWithValue("@Amount", totalAmount)
            cmd.Parameters.AddWithValue("@Desc", $"Accounts Payable - {reference}")
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Function GetOrCreateAccountID(con As SqlConnection, tx As SqlTransaction, code As String, name As String, accountType As String) As Integer
        ' Try GLAccounts first (new table) - uses AccountNumber
        Dim sql = "SELECT AccountID FROM GLAccounts WHERE AccountNumber = @Code"
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@Code", code)
            Dim result = cmd.ExecuteScalar()
            If result IsNot Nothing Then Return Convert.ToInt32(result)
        End Using

        ' Try ChartOfAccounts (legacy table) - uses AccountCode
        sql = "SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = @Code"
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@Code", code)
            Dim result = cmd.ExecuteScalar()
            If result IsNot Nothing Then Return Convert.ToInt32(result)
        End Using

        ' Create in GLAccounts - uses AccountNumber, AccountName, AccountType
        Dim insertSql = "INSERT INTO GLAccounts (AccountNumber, AccountName, AccountType, IsActive) OUTPUT INSERTED.AccountID VALUES (@Code, @Name, @Type, 1)"
        Using cmd As New SqlCommand(insertSql, con, tx)
            cmd.Parameters.AddWithValue("@Code", code)
            cmd.Parameters.AddWithValue("@Name", name)
            cmd.Parameters.AddWithValue("@Type", accountType)
            Return Convert.ToInt32(cmd.ExecuteScalar())
        End Using
    End Function

    Private Sub CreateSupplierLedgerEntry(supplierId As Integer, invoiceId As Integer, reference As String, amount As Decimal, con As SqlConnection, tx As SqlTransaction)
        ' Create supplier ledger entry for the invoice
        Dim sql = "INSERT INTO SupplierLedger (SupplierID, TransactionDate, TransactionType, Reference, Debit, Credit, Balance, Description, InvoiceID, CreatedBy, CreatedDate) " &
                  "VALUES (@SupplierID, GETDATE(), 'Invoice', @Reference, @Amount, 0, @Amount, @Description, @InvoiceID, @UserID, GETDATE())"

        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@SupplierID", supplierId)
            cmd.Parameters.AddWithValue("@Reference", reference)
            cmd.Parameters.AddWithValue("@Amount", amount)
            cmd.Parameters.AddWithValue("@Description", $"Purchase Invoice - {reference}")
            cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
            cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
            cmd.ExecuteNonQuery()
        End Using

        ' Update running balance for this supplier
        UpdateSupplierBalance(supplierId, con, tx)
    End Sub

    Private Sub UpdateSupplierBalance(supplierId As Integer, con As SqlConnection, tx As SqlTransaction)
        ' Recalculate running balance for all supplier ledger entries
        Dim sql = "WITH OrderedLedger AS ( " &
                  "  SELECT LedgerID, Debit, Credit, " &
                  "  ROW_NUMBER() OVER (ORDER BY TransactionDate, LedgerID) AS RowNum " &
                  "  FROM SupplierLedger WHERE SupplierID = @SupplierID " &
                  "), " &
                  "RunningBalance AS ( " &
                  "  SELECT LedgerID, Debit, Credit, " &
                  "  SUM(Debit - Credit) OVER (ORDER BY RowNum) AS Balance " &
                  "  FROM OrderedLedger " &
                  ") " &
                  "UPDATE sl SET sl.Balance = rb.Balance " &
                  "FROM SupplierLedger sl " &
                  "INNER JOIN RunningBalance rb ON sl.LedgerID = rb.LedgerID"

        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@SupplierID", supplierId)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Sub UpdateExternalProductInventory(productId As Integer, branchId As Integer, quantity As Decimal, unitCost As Decimal)
        Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Update CurrentStock in Demo_Retail_Product
                    Dim updateStockSql = "UPDATE Demo_Retail_Product " &
                                        "SET CurrentStock = ISNULL(CurrentStock, 0) + @Qty " &
                                        "WHERE ProductID = @ProductID AND BranchID = @BranchID"
                    
                    Using cmd As New SqlCommand(updateStockSql, con, tx)
                        cmd.Parameters.AddWithValue("@ProductID", productId)
                        cmd.Parameters.AddWithValue("@BranchID", branchId)
                        cmd.Parameters.AddWithValue("@Qty", quantity)
                        cmd.ExecuteNonQuery()
                    End Using
                    
                    ' Update Demo_Retail_Price with cost price
                    ' unitCost is ALREADY Excl VAT - save it as-is, no division needed
                    
                    Dim updatePriceSql = "IF EXISTS (SELECT 1 FROM Demo_Retail_Price WHERE ProductID = @ProductID AND BranchID = @BranchID) " &
                                        "  UPDATE Demo_Retail_Price SET CostPrice = @CostExclVAT, CreatedAt = GETDATE() WHERE ProductID = @ProductID AND BranchID = @BranchID " &
                                        "ELSE " &
                                        "  INSERT INTO Demo_Retail_Price (ProductID, BranchID, CostPrice, EffectiveFrom, CreatedAt) VALUES (@ProductID, @BranchID, @CostExclVAT, GETDATE(), GETDATE())"
                    
                    Using cmd As New SqlCommand(updatePriceSql, con, tx)
                        cmd.Parameters.AddWithValue("@ProductID", productId)
                        cmd.Parameters.AddWithValue("@BranchID", branchId)
                        cmd.Parameters.AddWithValue("@CostExclVAT", unitCost)
                        cmd.ExecuteNonQuery()
                    End Using
                    
                    tx.Commit()
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Private Sub UpdateLastPaidPrice(materialId As Integer, unitCost As Decimal, itemType As String)
        ' IGNORE materialId - update by product name from grid instead
    End Sub
    
    Private Function CheckDuplicateInvoiceNumber(invoiceNumber As String, supplierId As Integer) As Boolean
        Try
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                conn.Open()
                Dim sql As String = "SELECT COUNT(*) FROM SupplierInvoices WHERE InvoiceNumber = @InvoiceNumber AND SupplierID = @SupplierID"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
                    cmd.Parameters.AddWithValue("@SupplierID", supplierId)
                    Dim count As Integer = CInt(cmd.ExecuteScalar())
                    Return count > 0
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error checking duplicate invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        End Try
    End Function
    
    Private Sub txtDiscount_TextChanged(sender As Object, e As EventArgs)
        ' When percentage changes, calculate and update Rand discount
        Try
            Dim discountPercent As Decimal = 0
            If Decimal.TryParse(txtDiscount.Text, discountPercent) AndAlso discountPercent > 0 Then
                ' Get current subtotal
                Dim subTotal As Decimal = 0
                If Decimal.TryParse(txtSubTotal.Text.Replace(",", ""), subTotal) Then
                    Dim discountRand As Decimal = Math.Round(subTotal * (discountPercent / 100), 4)
                    ' Update Rand discount textbox without triggering its event
                    RemoveHandler txtDiscountRand.TextChanged, AddressOf txtDiscountRand_TextChanged
                    txtDiscountRand.Text = discountRand.ToString("N4")
                    AddHandler txtDiscountRand.TextChanged, AddressOf txtDiscountRand_TextChanged
                End If
            ElseIf String.IsNullOrWhiteSpace(txtDiscount.Text) OrElse discountPercent = 0 Then
                ' Clear Rand discount if percentage is cleared
                RemoveHandler txtDiscountRand.TextChanged, AddressOf txtDiscountRand_TextChanged
                txtDiscountRand.Text = "0.0000"
                AddHandler txtDiscountRand.TextChanged, AddressOf txtDiscountRand_TextChanged
            End If
            
            ' Recalculate totals
            CalculateTotals(Nothing, EventArgs.Empty)
        Catch ex As Exception
            ' Ignore errors during sync
        End Try
    End Sub
    
    Private Sub txtDiscountRand_TextChanged(sender As Object, e As EventArgs)
        ' When Rand discount changes, calculate and update percentage
        Try
            Dim discountRand As Decimal = 0
            If Decimal.TryParse(txtDiscountRand.Text, discountRand) AndAlso discountRand > 0 Then
                ' Get current subtotal
                Dim subTotal As Decimal = 0
                If Decimal.TryParse(txtSubTotal.Text.Replace(",", ""), subTotal) AndAlso subTotal > 0 Then
                    Dim discountPercent As Decimal = Math.Round((discountRand / subTotal) * 100, 4)
                    ' Update percentage textbox without triggering its event
                    RemoveHandler txtDiscount.TextChanged, AddressOf txtDiscount_TextChanged
                    txtDiscount.Text = discountPercent.ToString("N4")
                    AddHandler txtDiscount.TextChanged, AddressOf txtDiscount_TextChanged
                End If
            ElseIf String.IsNullOrWhiteSpace(txtDiscountRand.Text) OrElse discountRand = 0 Then
                ' Clear percentage if Rand is cleared
                RemoveHandler txtDiscount.TextChanged, AddressOf txtDiscount_TextChanged
                txtDiscount.Text = "0.00"
                AddHandler txtDiscount.TextChanged, AddressOf txtDiscount_TextChanged
            End If
            
            ' Recalculate totals
            CalculateTotals(Nothing, EventArgs.Empty)
        Catch ex As Exception
            ' Ignore errors during sync
        End Try
    End Sub
    
    Private Sub UpdateLastPaidPriceByName(productName As String, unitCost As Decimal)
        Try
            Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                con.Open()
                
                ' Update by MaterialName - more reliable than ID
                Dim sql = "UPDATE RawMaterials SET LastPaidPrice = @UnitCost, LastPurchaseDate = GETDATE() WHERE MaterialName = @Name"
                
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@UnitCost", unitCost)
                    cmd.Parameters.AddWithValue("@Name", productName)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            ' Silent
        End Try
    End Sub
End Class