Imports System.Windows.Forms
Imports System.Drawing

Namespace Accounting
    Public Class AdhocInvoiceCaptureForm
        Inherits Form

        Private WithEvents dgvInvoices As DataGridView
        Private WithEvents btnNew As Button
        Private WithEvents btnEdit As Button
        Private WithEvents btnDelete As Button
        Private WithEvents btnRefresh As Button
        Private _invoiceService As APInvoiceService

        Public Sub New()
            InitializeComponent()
            _invoiceService = New APInvoiceService()
            LoadInvoices()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Adhoc Invoice Capture - Accounts Payable"
            Me.Size = New Size(1400, 700)
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            ' Header Panel
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = Color.FromArgb(231, 76, 60),
                .Padding = New Padding(20)
            }

            Dim lblTitle As New Label() With {
                .Text = "Adhoc Invoice Capture",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 15)
            }
            pnlHeader.Controls.Add(lblTitle)

            Dim lblSubtitle As New Label() With {
                .Text = "Capture and manage accounts payable invoices",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 45)
            }
            pnlHeader.Controls.Add(lblSubtitle)

            ' Toolbar Panel
            Dim pnlToolbar As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 60,
                .BackColor = Color.FromArgb(236, 240, 241),
                .Padding = New Padding(20, 10, 20, 10)
            }

            btnNew = New Button() With {
                .Text = "➕ New Invoice",
                .Location = New Point(20, 15),
                .Size = New Size(120, 35),
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            pnlToolbar.Controls.Add(btnNew)

            btnEdit = New Button() With {
                .Text = "✏ Edit",
                .Location = New Point(150, 15),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Enabled = False
            }
            pnlToolbar.Controls.Add(btnEdit)

            btnDelete = New Button() With {
                .Text = "🗑 Delete",
                .Location = New Point(260, 15),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(231, 76, 60),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Enabled = False
            }
            pnlToolbar.Controls.Add(btnDelete)

            btnRefresh = New Button() With {
                .Text = "🔄 Refresh",
                .Location = New Point(370, 15),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(149, 165, 166),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            pnlToolbar.Controls.Add(btnRefresh)

            ' Grid Panel
            Dim pnlGrid As New Panel() With {
                .Dock = DockStyle.Fill,
                .Padding = New Padding(20)
            }

            dgvInvoices = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {.BackColor = Color.FromArgb(245, 245, 245)}
            }
            AddHandler dgvInvoices.SelectionChanged, AddressOf OnSelectionChanged
            pnlGrid.Controls.Add(dgvInvoices)

            Me.Controls.Add(pnlGrid)
            Me.Controls.Add(pnlToolbar)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadInvoices()
            Try
                Dim dt = _invoiceService.GetOutstandingInvoices()
                dgvInvoices.DataSource = dt

                If dgvInvoices.Columns.Count > 0 Then
                    dgvInvoices.Columns("InvoiceID").Visible = False
                    dgvInvoices.Columns("InvoiceNumber").HeaderText = "Invoice #"
                    dgvInvoices.Columns("InvoiceDate").HeaderText = "Invoice Date"
                    dgvInvoices.Columns("DueDate").HeaderText = "Due Date"
                    dgvInvoices.Columns("DaysUntilDue").HeaderText = "Days Until Due"
                    dgvInvoices.Columns("Amount").HeaderText = "Amount"
                    dgvInvoices.Columns("Amount").DefaultCellStyle.Format = "N2"
                    dgvInvoices.Columns("TaxAmount").HeaderText = "Tax"
                    dgvInvoices.Columns("TaxAmount").DefaultCellStyle.Format = "N2"
                    dgvInvoices.Columns("TotalAmount").HeaderText = "Total"
                    dgvInvoices.Columns("TotalAmount").DefaultCellStyle.Format = "N2"
                    dgvInvoices.Columns("BeneficiaryName").HeaderText = "Beneficiary"
                    dgvInvoices.Columns("CategoryName").HeaderText = "Category"
                    dgvInvoices.Columns("Status").HeaderText = "Status"
                    dgvInvoices.Columns("Description").HeaderText = "Description"
                    dgvInvoices.Columns("Reference").HeaderText = "Reference"

                    ' Hide bank details columns
                    If dgvInvoices.Columns.Contains("BankName") Then dgvInvoices.Columns("BankName").Visible = False
                    If dgvInvoices.Columns.Contains("AccountNumber") Then dgvInvoices.Columns("AccountNumber").Visible = False
                    If dgvInvoices.Columns.Contains("BranchCode") Then dgvInvoices.Columns("BranchCode").Visible = False
                    If dgvInvoices.Columns.Contains("GLAccountCode") Then dgvInvoices.Columns("GLAccountCode").Visible = False
                End If
            Catch ex As Exception
                MessageBox.Show($"Error loading invoices: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnSelectionChanged(sender As Object, e As EventArgs)
            Dim hasSelection = dgvInvoices.SelectedRows.Count > 0
            btnEdit.Enabled = hasSelection
            btnDelete.Enabled = hasSelection
        End Sub

        Private Sub btnNew_Click(sender As Object, e As EventArgs) Handles btnNew.Click
            Using dlg As New InvoiceCaptureDialog(_invoiceService)
                If dlg.ShowDialog(Me) = DialogResult.OK Then
                    LoadInvoices()
                End If
            End Using
        End Sub

        Private Sub btnEdit_Click(sender As Object, e As EventArgs) Handles btnEdit.Click
            If dgvInvoices.SelectedRows.Count = 0 Then Return

            Dim invoiceId = CInt(dgvInvoices.SelectedRows(0).Cells("InvoiceID").Value)
            MessageBox.Show("Edit functionality coming soon", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub btnDelete_Click(sender As Object, e As EventArgs) Handles btnDelete.Click
            If dgvInvoices.SelectedRows.Count = 0 Then Return

            Dim result = MessageBox.Show("Are you sure you want to delete this invoice?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result = DialogResult.Yes Then
                Try
                    Dim invoiceId = CInt(dgvInvoices.SelectedRows(0).Cells("InvoiceID").Value)
                    _invoiceService.UpdateInvoiceStatus(invoiceId, "Cancelled")
                    LoadInvoices()
                    MessageBox.Show("Invoice cancelled successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Catch ex As Exception
                    MessageBox.Show($"Error deleting invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        End Sub

        Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
            LoadInvoices()
        End Sub
    End Class

    ' ===== Invoice Capture Dialog =====
    Public Class InvoiceCaptureDialog
        Inherits Form

        Private WithEvents btnSave As Button
        Private btnCancel As Button
        Private txtInvoiceNumber As TextBox
        Private WithEvents cboCategory As ComboBox
        Private WithEvents cboBeneficiary As ComboBox
        Private WithEvents btnNewBeneficiary As Button
        Private dtpInvoiceDate As DateTimePicker
        Private dtpDueDate As DateTimePicker
        Private txtAmount As TextBox
        Private txtTaxAmount As TextBox
        Private txtDescription As TextBox
        Private txtReference As TextBox
        Private lblTotal As Label
        Private _invoiceService As APInvoiceService

        Public Sub New(invoiceService As APInvoiceService)
            _invoiceService = invoiceService
            InitializeComponent()
            LoadCategories()
            LoadBeneficiaries()
            txtInvoiceNumber.Text = _invoiceService.GenerateInvoiceNumber()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Capture New Invoice"
            Me.Size = New Size(600, 600)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False
            Me.BackColor = Color.White

            Dim yPos = 20

            ' Invoice Number
            Dim lblInvoiceNo As New Label() With {.Text = "Invoice Number:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblInvoiceNo)
            txtInvoiceNumber = New TextBox() With {.Location = New Point(150, yPos - 3), .Width = 400}
            Me.Controls.Add(txtInvoiceNumber)
            yPos += 35

            ' Category (Payment Type)
            Dim lblCategory As New Label() With {.Text = "Payment Type:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblCategory)
            cboCategory = New ComboBox() With {.Location = New Point(150, yPos - 3), .Width = 400, .DropDownStyle = ComboBoxStyle.DropDownList}
            Me.Controls.Add(cboCategory)
            yPos += 35

            ' Beneficiary
            Dim lblBeneficiary As New Label() With {.Text = "Beneficiary:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblBeneficiary)
            cboBeneficiary = New ComboBox() With {.Location = New Point(150, yPos - 3), .Width = 320, .DropDownStyle = ComboBoxStyle.DropDownList}
            Me.Controls.Add(cboBeneficiary)
            btnNewBeneficiary = New Button() With {.Text = "➕", .Location = New Point(480, yPos - 3), .Size = New Size(70, 25), .BackColor = Color.FromArgb(46, 204, 113), .ForeColor = Color.White}
            Me.Controls.Add(btnNewBeneficiary)
            yPos += 35

            ' Invoice Date
            Dim lblInvoiceDate As New Label() With {.Text = "Invoice Date:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblInvoiceDate)
            dtpInvoiceDate = New DateTimePicker() With {.Location = New Point(150, yPos - 3), .Width = 180, .Format = DateTimePickerFormat.Short, .Value = DateTime.Today}
            Me.Controls.Add(dtpInvoiceDate)
            yPos += 35

            ' Due Date
            Dim lblDueDate As New Label() With {.Text = "Due Date:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblDueDate)
            dtpDueDate = New DateTimePicker() With {.Location = New Point(150, yPos - 3), .Width = 180, .Format = DateTimePickerFormat.Short, .Value = DateTime.Today.AddDays(30)}
            Me.Controls.Add(dtpDueDate)
            yPos += 35

            ' Amount
            Dim lblAmount As New Label() With {.Text = "Amount (excl VAT):", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblAmount)
            txtAmount = New TextBox() With {.Location = New Point(150, yPos - 3), .Width = 180, .Text = "0.00"}
            AddHandler txtAmount.TextChanged, AddressOf CalculateTotal
            Me.Controls.Add(txtAmount)
            yPos += 35

            ' Tax Amount
            Dim lblTax As New Label() With {.Text = "VAT Amount:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblTax)
            txtTaxAmount = New TextBox() With {.Location = New Point(150, yPos - 3), .Width = 180, .Text = "0.00"}
            AddHandler txtTaxAmount.TextChanged, AddressOf CalculateTotal
            Me.Controls.Add(txtTaxAmount)
            yPos += 35

            ' Total
            Dim lblTotalLabel As New Label() With {.Text = "Total Amount:", .Location = New Point(20, yPos), .AutoSize = True, .Font = New Font("Segoe UI", 10, FontStyle.Bold)}
            Me.Controls.Add(lblTotalLabel)
            lblTotal = New Label() With {.Text = "R 0.00", .Location = New Point(150, yPos), .AutoSize = True, .Font = New Font("Segoe UI", 12, FontStyle.Bold), .ForeColor = Color.FromArgb(231, 76, 60)}
            Me.Controls.Add(lblTotal)
            yPos += 40

            ' Description
            Dim lblDescription As New Label() With {.Text = "Description:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblDescription)
            txtDescription = New TextBox() With {.Location = New Point(150, yPos - 3), .Width = 400, .Height = 60, .Multiline = True}
            Me.Controls.Add(txtDescription)
            yPos += 70

            ' Reference
            Dim lblReference As New Label() With {.Text = "Reference:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblReference)
            txtReference = New TextBox() With {.Location = New Point(150, yPos - 3), .Width = 400}
            Me.Controls.Add(txtReference)
            yPos += 40

            ' Buttons
            btnSave = New Button() With {.Text = "Save Invoice", .Location = New Point(350, yPos), .Size = New Size(120, 35), .BackColor = Color.FromArgb(46, 204, 113), .ForeColor = Color.White, .FlatStyle = FlatStyle.Flat}
            Me.Controls.Add(btnSave)

            btnCancel = New Button() With {.Text = "Cancel", .Location = New Point(480, yPos), .Size = New Size(70, 35), .DialogResult = DialogResult.Cancel}
            Me.Controls.Add(btnCancel)
        End Sub

        Private Sub LoadCategories()
            Dim dt = _invoiceService.GetCategories()
            cboCategory.DisplayMember = "CategoryName"
            cboCategory.ValueMember = "CategoryID"
            cboCategory.DataSource = dt
        End Sub

        Private Sub LoadBeneficiaries()
            Dim dt = _invoiceService.GetBeneficiaries()
            cboBeneficiary.DisplayMember = "BeneficiaryName"
            cboBeneficiary.ValueMember = "BeneficiaryID"
            cboBeneficiary.DataSource = dt
        End Sub

        Private Sub CalculateTotal(sender As Object, e As EventArgs)
            Try
                Dim amount = Decimal.Parse(txtAmount.Text)
                Dim tax = Decimal.Parse(txtTaxAmount.Text)
                Dim total = amount + tax
                lblTotal.Text = $"R {total:N2}"
            Catch
                lblTotal.Text = "R 0.00"
            End Try
        End Sub

        Private Sub btnNewBeneficiary_Click(sender As Object, e As EventArgs) Handles btnNewBeneficiary.Click
            MessageBox.Show("Use Beneficiary Management form to add new beneficiaries", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
            Try
                ' Validation
                If String.IsNullOrWhiteSpace(txtInvoiceNumber.Text) Then
                    MessageBox.Show("Please enter an invoice number", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                If cboCategory.SelectedValue Is Nothing Then
                    MessageBox.Show("Please select a payment type", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                If cboBeneficiary.SelectedValue Is Nothing Then
                    MessageBox.Show("Please select a beneficiary", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                Dim amount = Decimal.Parse(txtAmount.Text)
                Dim taxAmount = Decimal.Parse(txtTaxAmount.Text)

                If amount <= 0 Then
                    MessageBox.Show("Amount must be greater than zero", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                ' Save invoice
                Dim invoiceId = _invoiceService.CreateInvoice(
                    txtInvoiceNumber.Text.Trim(),
                    CInt(cboBeneficiary.SelectedValue),
                    CInt(cboCategory.SelectedValue),
                    dtpInvoiceDate.Value.Date,
                    dtpDueDate.Value.Date,
                    amount,
                    taxAmount,
                    txtDescription.Text.Trim(),
                    txtReference.Text.Trim(),
                    AppSession.CurrentUser.Username
                )

                MessageBox.Show($"Invoice {txtInvoiceNumber.Text} created successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Me.DialogResult = DialogResult.OK
                Me.Close()
            Catch ex As Exception
                MessageBox.Show($"Error saving invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
