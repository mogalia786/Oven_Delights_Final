Imports System.Windows.Forms
Imports System.Drawing
Imports System.Configuration

Namespace Accounting
    Public Class BankStatementViewerForm
        Inherits Form

        Private WithEvents btnFetch As Button
        Private WithEvents dgvTransactions As DataGridView
        Private dtpFromDate As DateTimePicker
        Private dtpToDate As DateTimePicker
        Private txtAccountId As TextBox
        Private WithEvents btnMap As Button
        Private txtLog As TextBox
        Private _statementService As FNBStatementService
        Private _invoiceService As APInvoiceService

        Public Sub New()
            InitializeComponent()
            _statementService = New FNBStatementService()
            _invoiceService = New APInvoiceService()
            AddHandler _statementService.LogMessage, AddressOf OnLogMessage
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Bank Statement Viewer"
            Me.Size = New Size(1200, 700)
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            ' Header Panel
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 100,
                .BackColor = Color.FromArgb(52, 73, 94),
                .Padding = New Padding(20)
            }

            Dim lblTitle As New Label() With {
                .Text = "FNB Bank Statement Viewer",
                .Font = New Font("Segoe UI", 16, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 15)
            }
            pnlHeader.Controls.Add(lblTitle)

            ' Filter Panel
            Dim pnlFilter As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = Color.FromArgb(236, 240, 241),
                .Padding = New Padding(20, 10, 20, 10)
            }

            Dim lblAccount As New Label() With {
                .Text = "Account ID:",
                .Location = New Point(20, 25),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblAccount)

            txtAccountId = New TextBox() With {
                .Location = New Point(100, 22),
                .Width = 150,
                .Text = "63001723469"
            }
            pnlFilter.Controls.Add(txtAccountId)

            Dim lblFrom As New Label() With {
                .Text = "From:",
                .Location = New Point(270, 25),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblFrom)

            dtpFromDate = New DateTimePicker() With {
                .Location = New Point(320, 22),
                .Width = 120,
                .Format = DateTimePickerFormat.Short,
                .Value = DateTime.Now.AddDays(-7)
            }
            pnlFilter.Controls.Add(dtpFromDate)

            Dim lblTo As New Label() With {
                .Text = "To:",
                .Location = New Point(460, 25),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblTo)

            dtpToDate = New DateTimePicker() With {
                .Location = New Point(490, 22),
                .Width = 120,
                .Format = DateTimePickerFormat.Short,
                .Value = DateTime.Now
            }
            pnlFilter.Controls.Add(dtpToDate)

            btnFetch = New Button() With {
                .Text = "Fetch Statement",
                .Location = New Point(630, 20),
                .Size = New Size(120, 30),
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            pnlFilter.Controls.Add(btnFetch)

            btnMap = New Button() With {
                .Text = "Map Transaction",
                .Location = New Point(770, 20),
                .Size = New Size(130, 30),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Enabled = False
            }
            pnlFilter.Controls.Add(btnMap)

            ' Split Container for Grid and Log
            Dim splitContainer As New SplitContainer() With {
                .Dock = DockStyle.Fill,
                .Orientation = Orientation.Vertical,
                .SplitterDistance = 350
            }

            ' Transactions Grid
            dgvTransactions = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False
            }
            splitContainer.Panel1.Controls.Add(dgvTransactions)

            ' Log Panel
            Dim pnlLog As New Panel() With {
                .Dock = DockStyle.Fill,
                .Padding = New Padding(10)
            }

            Dim lblLog As New Label() With {
                .Text = "Activity Log",
                .Dock = DockStyle.Top,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Height = 25
            }
            pnlLog.Controls.Add(lblLog)

            txtLog = New TextBox() With {
                .Dock = DockStyle.Fill,
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .BackColor = Color.FromArgb(44, 62, 80),
                .ForeColor = Color.FromArgb(236, 240, 241),
                .Font = New Font("Consolas", 9),
                .ReadOnly = True
            }
            pnlLog.Controls.Add(txtLog)

            splitContainer.Panel2.Controls.Add(pnlLog)

            Me.Controls.Add(splitContainer)
            Me.Controls.Add(pnlFilter)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub btnFetch_Click(sender As Object, e As EventArgs) Handles btnFetch.Click
            Try
                btnFetch.Enabled = False
                txtLog.Clear()
                OnLogMessage("Starting statement fetch...")

                Dim accountId = txtAccountId.Text.Trim()
                Dim fromDate = dtpFromDate.Value.Date
                Dim toDate = dtpToDate.Value.Date

                If String.IsNullOrEmpty(accountId) Then
                    MessageBox.Show("Please enter an account ID", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                ' Fetch statement from FNB API
                Dim statement = _statementService.FetchStatement(accountId, fromDate, toDate)

                ' Save to database
                Dim savedCount = _statementService.SaveStatementToDatabase(statement, AppSession.CurrentUser.Username)

                ' Load transactions into grid
                LoadTransactions()

                MessageBox.Show($"Statement fetched successfully. {savedCount} transactions saved.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Catch ex As Exception
                OnLogMessage($"ERROR: {ex.Message}")
                MessageBox.Show($"Error fetching statement: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Finally
                btnFetch.Enabled = True
            End Try
        End Sub

        Private Sub LoadTransactions()
            Try
                Dim dt = _statementService.GetUnmappedTransactions()
                dgvTransactions.DataSource = dt

                If dgvTransactions.Columns.Count > 0 Then
                    dgvTransactions.Columns("TransactionID").Visible = False
                    dgvTransactions.Columns("AccountNumber").HeaderText = "Account"
                    dgvTransactions.Columns("TransactionDate").HeaderText = "Date"
                    dgvTransactions.Columns("Amount").HeaderText = "Amount"
                    dgvTransactions.Columns("Amount").DefaultCellStyle.Format = "N2"
                    dgvTransactions.Columns("CreditDebitIndicator").HeaderText = "Type"
                    dgvTransactions.Columns("Description").HeaderText = "Description"
                    dgvTransactions.Columns("Reference").HeaderText = "Reference"
                    dgvTransactions.Columns("RelatedPartyName").HeaderText = "Party"
                    dgvTransactions.Columns("FetchedDate").HeaderText = "Fetched"
                End If

                btnMap.Enabled = dt.Rows.Count > 0
                OnLogMessage($"Loaded {dt.Rows.Count} unmapped transactions")
            Catch ex As Exception
                OnLogMessage($"Error loading transactions: {ex.Message}")
            End Try
        End Sub

        Private Sub btnMap_Click(sender As Object, e As EventArgs) Handles btnMap.Click
            If dgvTransactions.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a transaction to map", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim transactionId = CInt(dgvTransactions.SelectedRows(0).Cells("TransactionID").Value)
            Dim amount = CDec(dgvTransactions.SelectedRows(0).Cells("Amount").Value)
            Dim description = dgvTransactions.SelectedRows(0).Cells("Description").Value?.ToString()

            ' Show mapping dialog
            Using dlg As New StatementMappingDialog(transactionId, amount, description, _invoiceService)
                If dlg.ShowDialog(Me) = DialogResult.OK Then
                    LoadTransactions()
                    OnLogMessage($"Transaction {transactionId} mapped successfully")
                End If
            End Using
        End Sub

        Private Sub OnLogMessage(message As String)
            If txtLog.InvokeRequired Then
                txtLog.Invoke(Sub() OnLogMessage(message))
            Else
                txtLog.AppendText($"[{DateTime.Now:HH:mm:ss}] {message}{Environment.NewLine}")
            End If
        End Sub
    End Class

    ' ===== Statement Mapping Dialog =====
    Public Class StatementMappingDialog
        Inherits Form

        Private WithEvents cboCategory As ComboBox
        Private WithEvents cboBeneficiary As ComboBox
        Private WithEvents chkCreateInvoice As CheckBox
        Private WithEvents btnSave As Button
        Private btnCancel As Button
        Private _transactionId As Integer
        Private _amount As Decimal
        Private _description As String
        Private _invoiceService As APInvoiceService

        Public Sub New(transactionId As Integer, amount As Decimal, description As String, invoiceService As APInvoiceService)
            _transactionId = transactionId
            _amount = amount
            _description = description
            _invoiceService = invoiceService
            InitializeComponent()
            LoadCategories()
            LoadBeneficiaries()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Map Statement Transaction"
            Me.Size = New Size(500, 350)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False

            Dim yPos = 20

            Dim lblInfo As New Label() With {
                .Text = $"Transaction Amount: R {_amount:N2}",
                .Location = New Point(20, yPos),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            Me.Controls.Add(lblInfo)
            yPos += 30

            Dim lblDesc As New Label() With {
                .Text = $"Description: {_description}",
                .Location = New Point(20, yPos),
                .Size = New Size(450, 40),
                .Font = New Font("Segoe UI", 9)
            }
            Me.Controls.Add(lblDesc)
            yPos += 50

            Dim lblCategory As New Label() With {
                .Text = "Category:",
                .Location = New Point(20, yPos),
                .AutoSize = True
            }
            Me.Controls.Add(lblCategory)

            cboCategory = New ComboBox() With {
                .Location = New Point(120, yPos - 3),
                .Width = 300,
                .DropDownStyle = ComboBoxStyle.DropDownList
            }
            Me.Controls.Add(cboCategory)
            yPos += 40

            chkCreateInvoice = New CheckBox() With {
                .Text = "Create Invoice from Transaction",
                .Location = New Point(20, yPos),
                .AutoSize = True
            }
            Me.Controls.Add(chkCreateInvoice)
            yPos += 35

            Dim lblBeneficiary As New Label() With {
                .Text = "Beneficiary:",
                .Location = New Point(20, yPos),
                .AutoSize = True,
                .Enabled = False
            }
            Me.Controls.Add(lblBeneficiary)

            cboBeneficiary = New ComboBox() With {
                .Location = New Point(120, yPos - 3),
                .Width = 300,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Enabled = False
            }
            Me.Controls.Add(cboBeneficiary)
            yPos += 50

            btnSave = New Button() With {
                .Text = "Save Mapping",
                .Location = New Point(280, yPos),
                .Size = New Size(100, 30),
                .DialogResult = DialogResult.OK
            }
            Me.Controls.Add(btnSave)

            btnCancel = New Button() With {
                .Text = "Cancel",
                .Location = New Point(390, yPos),
                .Size = New Size(80, 30),
                .DialogResult = DialogResult.Cancel
            }
            Me.Controls.Add(btnCancel)

            AddHandler chkCreateInvoice.CheckedChanged, Sub()
                                                            cboBeneficiary.Enabled = chkCreateInvoice.Checked
                                                        End Sub
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

        Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
            Try
                If cboCategory.SelectedValue Is Nothing Then
                    MessageBox.Show("Please select a category", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Me.DialogResult = DialogResult.None
                    Return
                End If

                If chkCreateInvoice.Checked AndAlso cboBeneficiary.SelectedValue Is Nothing Then
                    MessageBox.Show("Please select a beneficiary", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Me.DialogResult = DialogResult.None
                    Return
                End If

                Dim categoryId = CInt(cboCategory.SelectedValue)
                Dim beneficiaryId = If(chkCreateInvoice.Checked, CInt(cboBeneficiary.SelectedValue), CType(Nothing, Integer?))

                Using conn As New SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    Using cmd As New SqlClient.SqlCommand("sp_AP_MapStatementTransaction", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@TransactionID", _transactionId)
                        cmd.Parameters.AddWithValue("@CategoryID", categoryId)
                        cmd.Parameters.AddWithValue("@CreateInvoice", chkCreateInvoice.Checked)
                        cmd.Parameters.AddWithValue("@BeneficiaryID", If(beneficiaryId, DBNull.Value))
                        cmd.Parameters.AddWithValue("@CreatedBy", AppSession.CurrentUser.Username)
                        cmd.ExecuteNonQuery()
                    End Using
                End Using

                MessageBox.Show("Transaction mapped successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Catch ex As Exception
                MessageBox.Show($"Error mapping transaction: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Me.DialogResult = DialogResult.None
            End Try
        End Sub
    End Class
End Namespace
