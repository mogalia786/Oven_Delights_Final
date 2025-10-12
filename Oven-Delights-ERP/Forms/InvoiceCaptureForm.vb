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
                    Dim d As Decimal
                    If v Is Nothing OrElse Not Decimal.TryParse(Convert.ToString(v), d) Then r.Cells("ReceiveNow").Value = 0D
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
                
                ' Set string format for any large numeric columns (like SKU/Barcode)
                For Each col As DataGridViewColumn In dgvLines.Columns
                    If col.ValueType Is GetType(Long) OrElse col.ValueType Is GetType(Int64) Then
                        col.DefaultCellStyle.Format = ""
                        col.ValueType = GetType(String)
                    End If
                Next

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
                MessageBox.Show("Please enter a delivery note number.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
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
            Dim vatAmount As Decimal = subTotal * 0.15D
            Dim totalAmount As Decimal = subTotal + vatAmount

            ' Save GRV and update inventory
            Dim grvId = stockroomService.SaveGoodsReceivedVoucher(selectedSupplierId, selectedPOId, txtDeliveryNote.Text, dtpReceived.Value, dgvLines)

            ' Create Supplier Invoice record
            CreateSupplierInvoice(selectedSupplierId, txtDeliveryNote.Text, dtpReceived.Value, subTotal, vatAmount, totalAmount, grvId)

            ' Update inventory based on ProductType
            For Each row As DataGridViewRow In dgvLines.Rows
                If Not row.IsNewRow Then
                    Dim receiveNow = If(row.Cells("ReceiveNow").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("ReceiveNow").Value))
                    If receiveNow > 0 Then
                        Dim productId = Convert.ToInt32(row.Cells("ProductID").Value)
                        Dim productType = Convert.ToString(row.Cells("ProductType").Value)

                        If productType = "Raw Material" Then
                            ' Update RawMaterials.CurrentStock
                            stockroomService.UpdateRawMaterialStock(productId, receiveNow, "Received from PO " & cboPO.Text)
                        ElseIf productType = "Product" Then
                            ' Update Products stock or create new product entry
                            stockroomService.UpdateProductStock(productId, receiveNow, "Received from PO " & cboPO.Text)
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
    End Sub

    Private Sub CalculateTotals(sender As Object, e As EventArgs)
        Try
            Dim subTotal As Decimal = 0
            For Each row As DataGridViewRow In dgvLines.Rows
                If Not row.IsNewRow Then
                    Dim receiveNow = If(row.Cells("ReceiveNow").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("ReceiveNow").Value))
                    Dim unitCost = If(row.Cells("UnitCost").Value Is Nothing, 0D, Convert.ToDecimal(row.Cells("UnitCost").Value))
                    subTotal += receiveNow * unitCost
                End If
            Next

            Dim vatAmount As Decimal = subTotal * 0.15D ' 15% VAT
            Dim total As Decimal = subTotal + vatAmount

            txtSubTotal.Text = subTotal.ToString("F2")
            txtVat.Text = vatAmount.ToString("F2")
            txtTotal.Text = total.ToString("F2")
        Catch ex As Exception
            ' Ignore calculation errors
        End Try
    End Sub

    Private Sub CreateSupplierInvoice(supplierId As Integer, invoiceNumber As String, invoiceDate As DateTime, subTotal As Decimal, vatAmount As Decimal, totalAmount As Decimal, grvId As Integer)
        Try
            Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                con.Open()
                Using tx = con.BeginTransaction()
                    Try
                        ' Create supplier invoice header
                        Dim invoiceId As Integer
                        Dim sql = "INSERT INTO SupplierInvoices (InvoiceNumber, SupplierID, BranchID, InvoiceDate, DueDate, SubTotal, VATAmount, TotalAmount, AmountPaid, AmountOutstanding, Status, GRVID, CreatedBy) " &
                                 "OUTPUT INSERTED.InvoiceID VALUES (@InvNum, @SupID, @BranchID, @InvDate, @DueDate, @SubTotal, @VAT, @Total, 0, @Total, 'Unpaid', @GRVID, @UserID)"
                        Using cmd As New SqlCommand(sql, con, tx)
                            cmd.Parameters.AddWithValue("@InvNum", invoiceNumber)
                            cmd.Parameters.AddWithValue("@SupID", supplierId)
                            cmd.Parameters.AddWithValue("@BranchID", AppSession.CurrentBranchID)
                            cmd.Parameters.AddWithValue("@InvDate", invoiceDate)
                            cmd.Parameters.AddWithValue("@DueDate", invoiceDate.AddDays(30))
                            cmd.Parameters.AddWithValue("@SubTotal", subTotal)
                            cmd.Parameters.AddWithValue("@VAT", vatAmount)
                            cmd.Parameters.AddWithValue("@Total", totalAmount)
                            cmd.Parameters.AddWithValue("@GRVID", grvId)
                            cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
                            invoiceId = Convert.ToInt32(cmd.ExecuteScalar())
                        End Using

                        ' Create journal entries
                        CreatePurchaseJournalEntries(supplierId, invoiceNumber, subTotal, vatAmount, totalAmount, con, tx)

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

End Class