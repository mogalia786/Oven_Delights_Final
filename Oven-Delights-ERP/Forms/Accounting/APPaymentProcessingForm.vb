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
        Private txtLog As TextBox
        Private lblTotalAmount As Label
        Private lblSelectedCount As Label
        Private _invoiceService As APInvoiceService
        Private _paymentService As APPaymentService
        Private _currentBatchId As Integer?

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

            btnCheckStatus = New Button() With {
                .Text = "🔍 Check Status",
                .Location = New Point(210, 15),
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
                .Location = New Point(350, 15),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(149, 165, 166),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            pnlToolbar.Controls.Add(btnRefresh)

            Dim btnViewBatches As New Button() With {
                .Text = "📋 View Batches",
                .Location = New Point(460, 15),
                .Size = New Size(130, 35),
                .BackColor = Color.FromArgb(155, 89, 182),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            AddHandler btnViewBatches.Click, AddressOf btnViewBatches_Click
            pnlToolbar.Controls.Add(btnViewBatches)

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

                Dim dt = _invoiceService.GetOutstandingInvoices()

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
            Catch ex As Exception
                OnLogMessage($"Error updating totals: {ex.Message}")
            End Try
        End Sub

        Private Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
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
                    MessageBox.Show("Please select at least one invoice to pay", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                Dim result = MessageBox.Show($"Submit payment batch for {selectedInvoices.Count} invoice(s)?{Environment.NewLine}Total Amount: R {lblTotalAmount.Text.Replace("Total: R ", "")}",
                                           "Confirm Payment Submission",
                                           MessageBoxButtons.YesNo,
                                           MessageBoxIcon.Question)

                If result = DialogResult.Yes Then
                    btnSubmit.Enabled = False
                    txtLog.Clear()
                    OnLogMessage("=== PAYMENT BATCH SUBMISSION ===")

                    ' Create payment batch
                    _currentBatchId = _paymentService.CreatePaymentBatch(selectedInvoices, AppSession.CurrentUser.Username)
                    OnLogMessage($"Payment batch {_currentBatchId} created")

                    ' Submit to FNB
                    Dim success = _paymentService.SubmitPaymentBatchToFNB(_currentBatchId.Value)

                    If success Then
                        btnCheckStatus.Enabled = True
                        LoadOutstandingInvoices()
                        MessageBox.Show($"Payment batch submitted successfully!{Environment.NewLine}Batch ID: {_currentBatchId}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Else
                        MessageBox.Show("Payment batch submission failed. Check log for details.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    End If

                    btnSubmit.Enabled = True
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
                ' Get submitted batches
                Dim batches As New DataTable()
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    Dim sql = "SELECT BatchID, CreatedDate, TotalAmount, Status, InstructionID, MessageID, " &
                             "SubmittedDate, CompletedDate, StatusMessage " &
                             "FROM AP_PaymentBatches " &
                             "WHERE Status IN ('Submitted', 'Processing', 'Completed', 'Failed') " &
                             "ORDER BY CreatedDate DESC"
                    Using cmd As New SqlCommand(sql, conn)
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(batches)
                        End Using
                    End Using
                End Using

                If batches.Rows.Count = 0 Then
                    MessageBox.Show("No submitted payment batches found", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Return
                End If

                ' Show batch selection dialog
                Dim batchList As New List(Of String)
                For Each row As DataRow In batches.Rows
                    batchList.Add($"Batch {row("BatchID")} - {row("Status")} - R{row("TotalAmount"):N2} - {CDate(row("CreatedDate")):yyyy-MM-dd HH:mm}")
                Next

                Dim selectedBatch = InputBox("Select a batch to check status (enter Batch ID):" & vbCrLf & vbCrLf & String.Join(vbCrLf, batchList), "Payment Batches", "")
                
                If Not String.IsNullOrEmpty(selectedBatch) Then
                    Dim batchId As Integer
                    If Integer.TryParse(selectedBatch, batchId) Then
                        _currentBatchId = batchId
                        btnCheckStatus.Enabled = True
                        OnLogMessage($"Selected batch {batchId} for status check")
                        MessageBox.Show($"Batch {batchId} selected. Click 'Check Status' to update.", "Batch Selected", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Else
                        MessageBox.Show("Invalid batch ID", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    End If
                End If
            Catch ex As Exception
                MessageBox.Show($"Error loading batches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnLogMessage(message As String)
            If txtLog.InvokeRequired Then
                txtLog.Invoke(Sub() OnLogMessage(message))
            Else
                txtLog.AppendText($"[{DateTime.Now:HH:mm:ss}] {message}{Environment.NewLine}")
            End If
        End Sub
    End Class
End Namespace
