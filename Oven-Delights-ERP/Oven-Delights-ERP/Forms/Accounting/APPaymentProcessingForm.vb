Imports System.Windows.Forms
Imports System.Drawing
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Namespace Accounting
    Public Class APPaymentProcessingForm
        Inherits Form

        Private WithEvents dgvInvoices As DataGridView
        Private WithEvents btnSubmit As Button
        Private WithEvents btnCheckStatus As Button
        Private WithEvents btnRefresh As Button
        Private WithEvents btnCreateBatch As Button
        Private dtpPaymentDate As DateTimePicker
        Private chkBatchPayment As CheckBox
        Private txtLog As TextBox
        Private lblTotalAmount As Label
        Private lblSelectedCount As Label
        Private _invoiceService As APInvoiceService
        Private _paymentService As APPaymentService
        Private _currentBatchId As Integer?
        Private _currentBranchId As Integer

        Public Sub New()
            Try
                InitializeComponent()
                _invoiceService = New APInvoiceService()
                _paymentService = New APPaymentService()
                AddHandler _paymentService.LogMessage, AddressOf OnLogMessage
            Catch ex As Exception
                MessageBox.Show($"Error initializing Payment Processing form: {ex.Message}{vbCrLf}{vbCrLf}Please ensure AP database tables and stored procedures are created.", "Initialization Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub APPaymentProcessingForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
            Try
                ' Get current user's branch
                _currentBranchId = If(AppSession.CurrentUser IsNot Nothing, AppSession.CurrentUser.BranchID, 0)
                
                If _currentBranchId = 0 Then
                    MessageBox.Show("Unable to determine your branch. Please contact system administrator.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Me.Close()
                    Return
                End If
                
                OnLogMessage($"Loading invoices for Branch ID: {_currentBranchId}")
                LoadOutstandingInvoices()
            Catch ex As Exception
                OnLogMessage($"Error loading invoices on form load: {ex.Message}")
                MessageBox.Show($"Error loading invoices: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Accounts Payable - Payment Processing"
            Me.Size = New Size(1400, 800)
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            ' Header Panel
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 100,
                .BackColor = Color.FromArgb(155, 89, 182),
                .Padding = New Padding(20)
            }

            Dim lblTitle As New Label() With {
                .Text = "AP Payment Processing",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 15)
            }
            pnlHeader.Controls.Add(lblTitle)

            Dim lblSubtitle As New Label() With {
                .Text = "Process payments to suppliers via FNB Bulk Payment API",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 45)
            }
            pnlHeader.Controls.Add(lblSubtitle)

            lblSelectedCount = New Label() With {
                .Text = "Selected: 0 invoices",
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = Color.White,
                .Location = New Point(900, 20),
                .AutoSize = True
            }
            pnlHeader.Controls.Add(lblSelectedCount)

            lblTotalAmount = New Label() With {
                .Text = "Total: R 0.00",
                .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                .ForeColor = Color.FromArgb(241, 196, 15),
                .Location = New Point(900, 50),
                .AutoSize = True
            }
            pnlHeader.Controls.Add(lblTotalAmount)

            ' Toolbar Panel
            Dim pnlToolbar As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 60,
                .BackColor = Color.FromArgb(236, 240, 241),
                .Padding = New Padding(20, 10, 20, 10)
            }

            btnSubmit = New Button() With {
                .Text = "💳 Submit Payment Batch",
                .Location = New Point(20, 15),
                .Size = New Size(180, 35),
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold),
                .Enabled = False
            }
            pnlToolbar.Controls.Add(btnSubmit)

            btnCreateBatch = New Button() With {
                .Text = "📦 Create Batch",
                .Location = New Point(210, 15),
                .Size = New Size(130, 35),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Enabled = False
            }
            pnlToolbar.Controls.Add(btnCreateBatch)

            btnCheckStatus = New Button() With {
                .Text = "🔍 Check Status",
                .Location = New Point(350, 15),
                .Size = New Size(130, 35),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Enabled = False
            }
            pnlToolbar.Controls.Add(btnCheckStatus)

            btnRefresh = New Button() With {
                .Text = "🔄 Refresh",
                .Location = New Point(490, 15),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(149, 165, 166),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            pnlToolbar.Controls.Add(btnRefresh)

            Dim btnViewBatches As New Button() With {
                .Text = "📋 View Batches",
                .Location = New Point(600, 15),
                .Size = New Size(130, 35),
                .BackColor = Color.FromArgb(155, 89, 182),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            AddHandler btnViewBatches.Click, AddressOf btnViewBatches_Click
            pnlToolbar.Controls.Add(btnViewBatches)

            Dim btnPrint As New Button() With {
                .Text = "🖨️ Print",
                .Location = New Point(740, 15),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            AddHandler btnPrint.Click, AddressOf btnPrint_Click
            pnlToolbar.Controls.Add(btnPrint)

            ' Payment Date Picker
            Dim lblPaymentDate As New Label() With {
                .Text = "Payment Date:",
                .Location = New Point(860, 20),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            pnlToolbar.Controls.Add(lblPaymentDate)

            dtpPaymentDate = New DateTimePicker() With {
                .Location = New Point(960, 17),
                .Size = New Size(150, 25),
                .Format = DateTimePickerFormat.Short,
                .Value = DateTime.Now
            }
            pnlToolbar.Controls.Add(dtpPaymentDate)

            ' Batch Payment Checkbox
            chkBatchPayment = New CheckBox() With {
                .Text = "Batch Payment (Show as 1 line on statement)",
                .Location = New Point(1130, 20),
                .AutoSize = True,
                .Checked = False,
                .Font = New Font("Segoe UI", 9)
            }
            Dim tooltip As New ToolTip()
            tooltip.SetToolTip(chkBatchPayment, "UNCHECKED (default): Each invoice shows separately on FNB statement" & vbCrLf & "CHECKED: All invoices show as one total line on FNB statement")
            pnlToolbar.Controls.Add(chkBatchPayment)

            ' Split Container for Grid and Log
            Dim splitContainer As New SplitContainer() With {
                .Dock = DockStyle.Fill,
                .Orientation = Orientation.Vertical,
                .SplitterDistance = 400
            }

            ' Invoices Grid
            Dim pnlGrid As New Panel() With {
                .Dock = DockStyle.Fill,
                .Padding = New Padding(20, 10, 20, 10)
            }

            Dim lblGridTitle As New Label() With {
                .Text = "Outstanding Invoices - Select invoices to pay",
                .Dock = DockStyle.Top,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Height = 30
            }
            pnlGrid.Controls.Add(lblGridTitle)

            dgvInvoices = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = False,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {.BackColor = Color.FromArgb(245, 245, 245)}
            }
            AddHandler dgvInvoices.CellValueChanged, AddressOf OnCellValueChanged
            pnlGrid.Controls.Add(dgvInvoices)

            splitContainer.Panel1.Controls.Add(pnlGrid)

            ' Log Panel
            Dim pnlLog As New Panel() With {
                .Dock = DockStyle.Fill,
                .Padding = New Padding(20, 10, 20, 10)
            }

            Dim lblLog As New Label() With {
                .Text = "Payment Processing Log",
                .Dock = DockStyle.Top,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Height = 30
            }
            pnlLog.Controls.Add(lblLog)

            txtLog = New TextBox() With {
                .Dock = DockStyle.Fill,
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .BackColor = Color.FromArgb(44, 62, 80),
                .ForeColor = Color.FromArgb(46, 204, 113),
                .Font = New Font("Consolas", 9),
                .ReadOnly = True
            }
            pnlLog.Controls.Add(txtLog)

            splitContainer.Panel2.Controls.Add(pnlLog)

            Me.Controls.Add(splitContainer)
            Me.Controls.Add(pnlToolbar)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadOutstandingInvoices()
            Try
                If _invoiceService Is Nothing Then
                    Throw New Exception("Invoice service not initialized")
                End If

                Dim dt = _invoiceService.GetOutstandingInvoices(branchId:=_currentBranchId)

                If dt Is Nothing Then
                    dt = New DataTable()
                    OnLogMessage("No invoices found - empty result set")
                End If

                ' Add checkbox column
                If Not dt.Columns.Contains("Selected") Then
                    dt.Columns.Add("Selected", GetType(Boolean))
                    For Each row As DataRow In dt.Rows
                        row("Selected") = False
                    Next
                End If

                If dgvInvoices Is Nothing Then
                    Throw New Exception("Invoice grid not initialized")
                End If

                dgvInvoices.DataSource = dt

                If dgvInvoices.Columns.Count > 0 Then
                    ' Setup checkbox column
                    If dgvInvoices.Columns.Contains("Selected") Then
                        dgvInvoices.Columns("Selected").DisplayIndex = 0
                        dgvInvoices.Columns("Selected").HeaderText = "Pay"
                        dgvInvoices.Columns("Selected").Width = 50
                        dgvInvoices.Columns("Selected").ReadOnly = False
                    End If

                    ' Setup visible columns
                    If dgvInvoices.Columns.Contains("InvoiceID") Then dgvInvoices.Columns("InvoiceID").Visible = False
                    If dgvInvoices.Columns.Contains("InvoiceNumber") Then dgvInvoices.Columns("InvoiceNumber").HeaderText = "Invoice #"
                    If dgvInvoices.Columns.Contains("InvoiceDate") Then dgvInvoices.Columns("InvoiceDate").HeaderText = "Date"
                    If dgvInvoices.Columns.Contains("DueDate") Then dgvInvoices.Columns("DueDate").HeaderText = "Due Date"
                    If dgvInvoices.Columns.Contains("DaysUntilDue") Then dgvInvoices.Columns("DaysUntilDue").HeaderText = "Days"
                    If dgvInvoices.Columns.Contains("TotalAmount") Then
                        dgvInvoices.Columns("TotalAmount").HeaderText = "Amount"
                        dgvInvoices.Columns("TotalAmount").DefaultCellStyle.Format = "N2"
                    End If
                    If dgvInvoices.Columns.Contains("BeneficiaryName") Then dgvInvoices.Columns("BeneficiaryName").HeaderText = "Beneficiary"
                    If dgvInvoices.Columns.Contains("CategoryName") Then dgvInvoices.Columns("CategoryName").HeaderText = "Category"
                    If dgvInvoices.Columns.Contains("Description") Then dgvInvoices.Columns("Description").HeaderText = "Description"

                    ' Hide unnecessary columns
                    If dgvInvoices.Columns.Contains("Amount") Then dgvInvoices.Columns("Amount").Visible = False
                    If dgvInvoices.Columns.Contains("TaxAmount") Then dgvInvoices.Columns("TaxAmount").Visible = False
                    If dgvInvoices.Columns.Contains("Status") Then dgvInvoices.Columns("Status").Visible = False
                    If dgvInvoices.Columns.Contains("Reference") Then dgvInvoices.Columns("Reference").Visible = False
                    If dgvInvoices.Columns.Contains("BankName") Then dgvInvoices.Columns("BankName").Visible = False
                    If dgvInvoices.Columns.Contains("AccountNumber") Then dgvInvoices.Columns("AccountNumber").Visible = False
                    If dgvInvoices.Columns.Contains("BranchCode") Then dgvInvoices.Columns("BranchCode").Visible = False
                    If dgvInvoices.Columns.Contains("GLAccountCode") Then dgvInvoices.Columns("GLAccountCode").Visible = False
                End If

                OnLogMessage($"Loaded {dt.Rows.Count} outstanding invoices")
            Catch ex As Exception
                OnLogMessage($"Error loading invoices: {ex.Message}")
                MessageBox.Show($"Error loading invoices: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnCellValueChanged(sender As Object, e As DataGridViewCellEventArgs)
            Try
                If dgvInvoices IsNot Nothing AndAlso dgvInvoices.Columns.Contains("Selected") Then
                    If e.ColumnIndex = dgvInvoices.Columns("Selected").Index Then
                        UpdateTotals()
                    End If
                End If
            Catch ex As Exception
                OnLogMessage($"Error in cell value changed: {ex.Message}")
            End Try
        End Sub

        Private Sub UpdateTotals()
            Try
                If dgvInvoices Is Nothing OrElse dgvInvoices.DataSource Is Nothing Then
                    Return
                End If

                Dim dt = CType(dgvInvoices.DataSource, DataTable)
                If dt Is Nothing OrElse Not dt.Columns.Contains("Selected") OrElse Not dt.Columns.Contains("TotalAmount") Then
                    Return
                End If

                Dim selectedCount = 0
                Dim totalAmount As Decimal = 0

                For Each row As DataRow In dt.Rows
                    If CBool(row("Selected")) Then
                        selectedCount += 1
                        totalAmount += CDec(row("TotalAmount"))
                    End If
                Next

                If lblSelectedCount IsNot Nothing Then
                    lblSelectedCount.Text = $"Selected: {selectedCount} invoice(s)"
                End If
                If lblTotalAmount IsNot Nothing Then
                    lblTotalAmount.Text = $"Total: R {totalAmount:N2}"
                End If
                If btnSubmit IsNot Nothing Then
                    btnSubmit.Enabled = selectedCount > 0
                End If
                If btnCreateBatch IsNot Nothing Then
                    btnCreateBatch.Enabled = selectedCount > 0
                End If
            Catch ex As Exception
                OnLogMessage($"Error updating totals: {ex.Message}")
            End Try
        End Sub

        Private Sub btnCreateBatch_Click(sender As Object, e As EventArgs) Handles btnCreateBatch.Click
            Try
                ' Get selected invoice IDs
                Dim dt = CType(dgvInvoices.DataSource, DataTable)
                Dim selectedInvoices As New List(Of Integer)

                For Each row As DataRow In dt.Rows
                    If CBool(row("Selected")) Then
                        selectedInvoices.Add(CInt(row("InvoiceID")))
                    End If
                Next

                If selectedInvoices.Count = 0 Then
                    MessageBox.Show("Please select at least one invoice to create a batch", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                Dim result = MessageBox.Show($"Create payment batch for {selectedInvoices.Count} invoice(s)?{Environment.NewLine}Total Amount: R {lblTotalAmount.Text.Replace("Total: R ", "")}{Environment.NewLine}{Environment.NewLine}Note: This will create the batch but NOT submit it to FNB.",
                                           "Confirm Batch Creation",
                                           MessageBoxButtons.YesNo,
                                           MessageBoxIcon.Question)

                If result = DialogResult.Yes Then
                    btnCreateBatch.Enabled = False
                    txtLog.Clear()
                    OnLogMessage("=== CREATING PAYMENT BATCH ===")

                    ' Create payment batch (without submitting) with BranchID
                    _currentBatchId = _paymentService.CreatePaymentBatch(selectedInvoices, AppSession.CurrentUser.Username, _currentBranchId)
                    OnLogMessage($"Payment batch {_currentBatchId} created successfully for Branch {_currentBranchId}")
                    OnLogMessage("Batch is ready. Use 'Submit Payment Batch' to send to FNB.")

                    LoadOutstandingInvoices()
                    MessageBox.Show($"Payment batch created successfully!{Environment.NewLine}Batch ID: {_currentBatchId}{Environment.NewLine}{Environment.NewLine}Use 'Submit Payment Batch' to send to FNB.", "Batch Created", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    
                    btnCreateBatch.Enabled = True
                    btnSubmit.Enabled = True
                End If
            Catch ex As Exception
                OnLogMessage($"ERROR: {ex.Message}")
                MessageBox.Show($"Error creating payment batch: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                btnCreateBatch.Enabled = True
            End Try
        End Sub

        Private Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
            Try
                ' Check Administrator or Super Administrator role
                If AppSession.CurrentRoleName <> "Administrator" AndAlso AppSession.CurrentRoleName <> "Super Administrator" Then
                    MessageBox.Show("Only Administrators and Super Administrators can submit payment batches.", "Access Denied", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                
                ' Request administrator password verification
                Dim passwordInput = InputBox("Enter your password to authorize payment submission:", "Administrator Authorization Required", "")
                If String.IsNullOrEmpty(passwordInput) Then
                    MessageBox.Show("Payment submission cancelled - password required", "Cancelled", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Return
                End If
                
                ' Verify password matches current logged-in user
                Dim isPasswordValid As Boolean = False
                Dim storedPassword As String = ""
                
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    Dim cmd As New SqlCommand("SELECT Password FROM Users WHERE Username = @Username AND IsActive = 1", conn)
                    cmd.Parameters.AddWithValue("@Username", AppSession.CurrentUser.Username)
                    Dim result = cmd.ExecuteScalar()
                    If result IsNot Nothing Then
                        storedPassword = result.ToString()
                        isPasswordValid = (storedPassword = passwordInput)
                    End If
                End Using
                
                If Not isPasswordValid Then
                    MessageBox.Show($"Invalid password for user '{AppSession.CurrentUser.Username}'. Payment submission denied.", "Access Denied", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    OnLogMessage($"Payment submission denied - invalid password for user: {AppSession.CurrentUser.Username}")
                    Return
                End If
                
                OnLogMessage($"Administrator password verified for user: {AppSession.CurrentUser.Username}")
                
                ' Check if we have a pending batch selected from View Batches
                If _currentBatchId.HasValue Then
                    ' Submit existing batch
                    Dim result = MessageBox.Show($"Submit payment batch {_currentBatchId} to FNB?",
                                               "Confirm Submission",
                                               MessageBoxButtons.YesNo,
                                               MessageBoxIcon.Question)

                    If result = DialogResult.Yes Then
                        btnSubmit.Enabled = False
                        txtLog.Clear()
                        OnLogMessage($"=== SUBMITTING EXISTING BATCH {_currentBatchId} ===")

                        ' Submit to FNB with BatchPayment setting
                        Dim success = _paymentService.SubmitPaymentBatchToFNB(_currentBatchId.Value, dtpPaymentDate.Value, chkBatchPayment.Checked)

                        If success Then
                            btnCheckStatus.Enabled = True
                            LoadOutstandingInvoices()
                            MessageBox.Show($"Payment batch {_currentBatchId} submitted successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Else
                            MessageBox.Show("Payment batch submission failed. Check log for details.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        End If

                        btnSubmit.Enabled = True
                    End If
                Else
                    ' Create new batch from selected invoices
                    Dim dt = CType(dgvInvoices.DataSource, DataTable)
                    Dim selectedInvoices As New List(Of Integer)

                    For Each row As DataRow In dt.Rows
                        If CBool(row("Selected")) Then
                            selectedInvoices.Add(CInt(row("InvoiceID")))
                        End If
                    Next

                    If selectedInvoices.Count = 0 Then
                        MessageBox.Show("Please select at least one invoice to submit", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                        Return
                    End If

                    Dim result = MessageBox.Show($"Submit payment batch for {selectedInvoices.Count} invoice(s) to FNB?{Environment.NewLine}Total Amount: R {lblTotalAmount.Text.Replace("Total: R ", "")}",
                                               "Confirm Submission",
                                               MessageBoxButtons.YesNo,
                                               MessageBoxIcon.Question)

                    If result = DialogResult.Yes Then
                        btnSubmit.Enabled = False
                        txtLog.Clear()
                        OnLogMessage("=== SUBMITTING PAYMENT BATCH ===")

                        ' Create and submit payment batch with BranchID
                        _currentBatchId = _paymentService.CreatePaymentBatch(selectedInvoices, AppSession.CurrentUser.Username, _currentBranchId)
                        OnLogMessage($"Payment batch {_currentBatchId} created")

                        ' Submit to FNB with BatchPayment setting
                        Dim success = _paymentService.SubmitPaymentBatchToFNB(_currentBatchId.Value, dtpPaymentDate.Value, chkBatchPayment.Checked)

                        If success Then
                            btnCheckStatus.Enabled = True
                            LoadOutstandingInvoices()
                            MessageBox.Show($"Payment batch submitted successfully!{Environment.NewLine}Batch ID: {_currentBatchId}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Else
                            MessageBox.Show("Payment batch submission failed. Check log for details.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        End If

                        btnSubmit.Enabled = True
                    End If
                End If
            Catch ex As Exception
                OnLogMessage($"ERROR: {ex.Message}")
                MessageBox.Show($"Error submitting payment batch: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                btnSubmit.Enabled = True
            End Try
        End Sub

        Private Sub btnCheckStatus_Click(sender As Object, e As EventArgs) Handles btnCheckStatus.Click
            If Not _currentBatchId.HasValue Then
                MessageBox.Show("No batch to check status for", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Try
                btnCheckStatus.Enabled = False
                OnLogMessage($"=== CHECKING PAYMENT STATUS FOR BATCH {_currentBatchId} ===")
                _paymentService.CheckPaymentStatus(_currentBatchId.Value)
                LoadOutstandingInvoices()
                btnCheckStatus.Enabled = True
            Catch ex As Exception
                OnLogMessage($"ERROR: {ex.Message}")
                MessageBox.Show($"Error checking payment status: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                btnCheckStatus.Enabled = True
            End Try
        End Sub

        Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
            LoadOutstandingInvoices()
        End Sub

        Private Sub btnViewBatches_Click(sender As Object, e As EventArgs)
            Try
                ' Get batches for current branch only
                Dim batches As New DataTable()
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    Dim sql = "SELECT BatchID, BatchNumber, CreatedDate, TotalInvoices, TotalAmount, Status, " &
                             "SubmittedDate, CompletedDate, StatusMessage, CreatedBy " &
                             "FROM AP_PaymentBatches " &
                             "WHERE BranchID = @BranchID OR BranchID IS NULL " &
                             "ORDER BY CreatedDate DESC"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@BranchID", _currentBranchId)
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(batches)
                        End Using
                    End Using
                End Using

                If batches.Rows.Count = 0 Then
                    MessageBox.Show("No payment batches found for this branch", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Return
                End If

                ' Create batch selection dialog
                Dim batchDialog As New Form() With {
                    .Text = "Select Payment Batch",
                    .Size = New Size(900, 500),
                    .StartPosition = FormStartPosition.CenterParent,
                    .FormBorderStyle = FormBorderStyle.FixedDialog,
                    .MaximizeBox = False,
                    .MinimizeBox = False
                }

                Dim dgvBatches As New DataGridView() With {
                    .Dock = DockStyle.Fill,
                    .DataSource = batches,
                    .ReadOnly = True,
                    .AllowUserToAddRows = False,
                    .AllowUserToDeleteRows = False,
                    .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                    .MultiSelect = False,
                    .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
                }

                ' Format columns
                If dgvBatches.Columns.Contains("BatchID") Then dgvBatches.Columns("BatchID").Width = 70
                If dgvBatches.Columns.Contains("BatchNumber") Then dgvBatches.Columns("BatchNumber").Width = 150
                If dgvBatches.Columns.Contains("CreatedDate") Then
                    dgvBatches.Columns("CreatedDate").HeaderText = "Created"
                    dgvBatches.Columns("CreatedDate").DefaultCellStyle.Format = "yyyy-MM-dd HH:mm"
                    dgvBatches.Columns("CreatedDate").Width = 130
                End If
                If dgvBatches.Columns.Contains("TotalInvoices") Then
                    dgvBatches.Columns("TotalInvoices").HeaderText = "Invoices"
                    dgvBatches.Columns("TotalInvoices").Width = 70
                End If
                If dgvBatches.Columns.Contains("TotalAmount") Then
                    dgvBatches.Columns("TotalAmount").HeaderText = "Amount"
                    dgvBatches.Columns("TotalAmount").DefaultCellStyle.Format = "N2"
                    dgvBatches.Columns("TotalAmount").Width = 100
                End If
                If dgvBatches.Columns.Contains("Status") Then dgvBatches.Columns("Status").Width = 90
                If dgvBatches.Columns.Contains("CreatedBy") Then
                    dgvBatches.Columns("CreatedBy").HeaderText = "Created By"
                    dgvBatches.Columns("CreatedBy").Width = 100
                End If
                If dgvBatches.Columns.Contains("SubmittedDate") Then dgvBatches.Columns("SubmittedDate").Visible = False
                If dgvBatches.Columns.Contains("CompletedDate") Then dgvBatches.Columns("CompletedDate").Visible = False
                If dgvBatches.Columns.Contains("StatusMessage") Then dgvBatches.Columns("StatusMessage").Visible = False

                Dim pnlButtons As New Panel() With {
                    .Dock = DockStyle.Bottom,
                    .Height = 50
                }

                Dim btnSelect As New Button() With {
                    .Text = "Select Batch",
                    .Size = New Size(120, 35),
                    .Location = New Point(10, 8),
                    .DialogResult = DialogResult.OK
                }

                Dim btnCancel As New Button() With {
                    .Text = "Cancel",
                    .Size = New Size(100, 35),
                    .Location = New Point(140, 8),
                    .DialogResult = DialogResult.Cancel
                }

                pnlButtons.Controls.Add(btnSelect)
                pnlButtons.Controls.Add(btnCancel)

                batchDialog.Controls.Add(dgvBatches)
                batchDialog.Controls.Add(pnlButtons)
                batchDialog.AcceptButton = btnSelect
                batchDialog.CancelButton = btnCancel

                If batchDialog.ShowDialog() = DialogResult.OK AndAlso dgvBatches.SelectedRows.Count > 0 Then
                    Dim selectedRow = dgvBatches.SelectedRows(0)
                    Dim batchId As Integer = CInt(selectedRow.Cells("BatchID").Value)
                    Dim batchStatus As String = selectedRow.Cells("Status").Value.ToString()
                    
                    _currentBatchId = batchId
                    
                    If batchStatus = "Pending" Then
                        btnSubmit.Enabled = True
                        btnCheckStatus.Enabled = False
                        OnLogMessage($"Selected pending batch {batchId}")
                        MessageBox.Show($"Batch {batchId} is pending.{Environment.NewLine}{Environment.NewLine}Click 'Submit Payment Batch' to send to FNB.", "Pending Batch Selected", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    ElseIf batchStatus = "Submitted" OrElse batchStatus = "Processing" Then
                        btnCheckStatus.Enabled = True
                        btnSubmit.Enabled = False
                        OnLogMessage($"Selected batch {batchId} for status check")
                        MessageBox.Show($"Batch {batchId} is {batchStatus}.{Environment.NewLine}{Environment.NewLine}Click 'Check Status' to update.", "Batch Selected", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Else
                        btnCheckStatus.Enabled = True
                        btnSubmit.Enabled = False
                        OnLogMessage($"Selected batch {batchId} - Status: {batchStatus}")
                        MessageBox.Show($"Batch {batchId} status: {batchStatus}", "Batch Selected", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    End If
                End If
            Catch ex As Exception
                MessageBox.Show($"Error loading batches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnLogMessage(message As String)
            If txtLog IsNot Nothing Then
                txtLog.AppendText($"[{DateTime.Now:HH:mm:ss}] {message}{Environment.NewLine}")
            End If
        End Sub

        Private Sub btnPrint_Click(sender As Object, e As EventArgs)
            Try
                If dgvInvoices Is Nothing OrElse dgvInvoices.Rows.Count = 0 Then
                    MessageBox.Show("No invoices to print", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Return
                End If

                Dim printDoc As New System.Drawing.Printing.PrintDocument()
                AddHandler printDoc.PrintPage, AddressOf PrintPayablesPage

                Dim printDialog As New PrintDialog()
                printDialog.Document = printDoc

                If printDialog.ShowDialog() = DialogResult.OK Then
                    printDoc.Print()
                    MessageBox.Show("Accounts Payable report printed successfully!", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            Catch ex As Exception
                MessageBox.Show($"Error printing report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub PrintPayablesPage(sender As Object, e As System.Drawing.Printing.PrintPageEventArgs)
            Try
                Dim titleFont As New Font("Arial", 18, FontStyle.Bold)
                Dim headerFont As New Font("Arial", 12, FontStyle.Bold)
                Dim normalFont As New Font("Arial", 8)
                Dim boldFont As New Font("Arial", 8, FontStyle.Bold)
                Dim smallFont As New Font("Arial", 7)

                Dim yPos As Single = 50
                Dim leftMargin As Single = 50
                Dim rightMargin As Single = e.PageBounds.Width - 50

                ' Company Header
                e.Graphics.DrawString("OVEN DELIGHTS (PTY) LTD", titleFont, Brushes.Black, leftMargin, yPos)
                yPos += 30
                e.Graphics.DrawString("ACCOUNTS PAYABLE - OUTSTANDING INVOICES", headerFont, Brushes.Black, leftMargin, yPos)
                yPos += 25
                e.Graphics.DrawString($"Generated: {DateTime.Now:dd MMM yyyy HH:mm:ss}", smallFont, Brushes.Gray, leftMargin, yPos)
                yPos += 30

                e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
                yPos += 20

                ' Calculate totals
                Dim dt = CType(dgvInvoices.DataSource, DataTable)
                Dim totalAmount As Decimal = 0
                Dim selectedAmount As Decimal = 0
                Dim selectedCount As Integer = 0

                For Each row As DataRow In dt.Rows
                    If row("TotalAmount") IsNot Nothing Then
                        totalAmount += Convert.ToDecimal(row("TotalAmount"))
                    End If
                    If row("Selected") IsNot Nothing AndAlso CBool(row("Selected")) Then
                        selectedCount += 1
                        If row("TotalAmount") IsNot Nothing Then
                            selectedAmount += Convert.ToDecimal(row("TotalAmount"))
                        End If
                    End If
                Next

                ' Summary Section
                e.Graphics.DrawString("SUMMARY", headerFont, Brushes.Black, leftMargin, yPos)
                yPos += 25

                e.Graphics.DrawString("Total Outstanding Invoices:", boldFont, Brushes.Black, leftMargin, yPos)
                e.Graphics.DrawString(dt.Rows.Count.ToString(), normalFont, Brushes.Black, leftMargin + 200, yPos)
                yPos += 18

                e.Graphics.DrawString("Total Outstanding Amount:", boldFont, Brushes.Black, leftMargin, yPos)
                e.Graphics.DrawString($"R {totalAmount:N2}", normalFont, Brushes.Black, leftMargin + 200, yPos)
                yPos += 18

                e.Graphics.DrawString("Selected for Payment:", boldFont, Brushes.Black, leftMargin, yPos)
                e.Graphics.DrawString($"{selectedCount} invoices", normalFont, New SolidBrush(Color.Green), leftMargin + 200, yPos)
                yPos += 18

                e.Graphics.DrawString("Selected Amount:", boldFont, Brushes.Black, leftMargin, yPos)
                e.Graphics.DrawString($"R {selectedAmount:N2}", normalFont, New SolidBrush(Color.Green), leftMargin + 200, yPos)
                yPos += 30

                e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
                yPos += 20

                ' Invoice Details
                e.Graphics.DrawString("INVOICE DETAILS", headerFont, Brushes.Black, leftMargin, yPos)
                yPos += 25

                ' Column headers
                e.Graphics.DrawString("Sel", boldFont, Brushes.Black, leftMargin, yPos)
                e.Graphics.DrawString("Invoice #", boldFont, Brushes.Black, leftMargin + 30, yPos)
                e.Graphics.DrawString("Supplier", boldFont, Brushes.Black, leftMargin + 140, yPos)
                e.Graphics.DrawString("Invoice Date", boldFont, Brushes.Black, leftMargin + 280, yPos)
                e.Graphics.DrawString("Due Date", boldFont, Brushes.Black, leftMargin + 370, yPos)
                e.Graphics.DrawString("Days", boldFont, Brushes.Black, leftMargin + 450, yPos)
                e.Graphics.DrawString("Amount", boldFont, Brushes.Black, leftMargin + 490, yPos)
                e.Graphics.DrawString("Category", boldFont, Brushes.Black, leftMargin + 570, yPos)
                yPos += 18

                e.Graphics.DrawLine(Pens.Gray, leftMargin, yPos, rightMargin, yPos)
                yPos += 8

                ' Print invoices
                Dim invoiceCount As Integer = 0
                For Each row As DataRow In dt.Rows
                    If yPos > e.PageBounds.Height - 100 Then Exit For

                    Dim selected As String = If(row("Selected") IsNot Nothing AndAlso CBool(row("Selected")), "✓", "")
                    Dim invoiceNum As String = If(row("InvoiceNumber")?.ToString(), "")
                    Dim supplier As String = If(row("BeneficiaryName")?.ToString(), "")
                    Dim invoiceDate As String = ""
                    If row("InvoiceDate") IsNot Nothing Then
                        invoiceDate = Convert.ToDateTime(row("InvoiceDate")).ToString("dd/MM/yyyy")
                    End If
                    Dim dueDate As String = ""
                    If row("DueDate") IsNot Nothing Then
                        dueDate = Convert.ToDateTime(row("DueDate")).ToString("dd/MM/yyyy")
                    End If
                    Dim daysOverdue As String = If(row("DaysUntilDue")?.ToString(), "0")
                    Dim amount As Decimal = If(row("TotalAmount") IsNot Nothing, Convert.ToDecimal(row("TotalAmount")), 0)
                    Dim category As String = If(row("CategoryName")?.ToString(), "")

                    If supplier.Length > 18 Then supplier = supplier.Substring(0, 15) & "..."
                    If invoiceNum.Length > 15 Then invoiceNum = invoiceNum.Substring(0, 12) & "..."
                    If category.Length > 15 Then category = category.Substring(0, 12) & "..."

                    ' Highlight selected or overdue
                    Dim textBrush As Brush = Brushes.Black
                    If row("Selected") IsNot Nothing AndAlso CBool(row("Selected")) Then
                        textBrush = New SolidBrush(Color.Green)
                    ElseIf row("DaysUntilDue") IsNot Nothing AndAlso Convert.ToInt32(row("DaysUntilDue")) < 0 Then
                        textBrush = Brushes.Red
                    End If

                    e.Graphics.DrawString(selected, boldFont, textBrush, leftMargin, yPos)
                    e.Graphics.DrawString(invoiceNum, normalFont, textBrush, leftMargin + 30, yPos)
                    e.Graphics.DrawString(supplier, normalFont, textBrush, leftMargin + 140, yPos)
                    e.Graphics.DrawString(invoiceDate, normalFont, textBrush, leftMargin + 280, yPos)
                    e.Graphics.DrawString(dueDate, normalFont, textBrush, leftMargin + 370, yPos)
                    e.Graphics.DrawString(daysOverdue, normalFont, textBrush, leftMargin + 450, yPos)
                    e.Graphics.DrawString($"R {amount:N2}", normalFont, textBrush, leftMargin + 490, yPos)
                    e.Graphics.DrawString(category, normalFont, textBrush, leftMargin + 570, yPos)

                    yPos += 16
                    invoiceCount += 1
                Next

                ' Footer
                yPos = e.PageBounds.Height - 50
                e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
                yPos += 10
                e.Graphics.DrawString($"Printed: {DateTime.Now:dd MMM yyyy HH:mm}", smallFont, Brushes.Gray, leftMargin, yPos)
                e.Graphics.DrawString($"Showing {invoiceCount} of {dt.Rows.Count} invoices", smallFont, Brushes.Gray, rightMargin - 200, yPos)

            Catch ex As Exception
                MessageBox.Show($"Error rendering print page: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
