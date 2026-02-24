Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing.Printing

Public Class BatchPaymentForm
    Private connectionString As String
    Private currentFNBBatchID As Integer = 0
    Private selectedInvoices As New List(Of Integer)
    Private WithEvents _printDocument As New PrintDocument()
    Private _printData As DataTable
    Private tabControl As TabControl
    Private txtTestResults As TextBox
    Private txtResponseLog As TextBox
    Private btnClearLog As Button

    Public Sub New()
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Private Sub BatchPaymentForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            ' Enable form scrolling
            Me.AutoScroll = True
            
            ' Set default dates
            dtpPaymentDate.Value = DateTime.Now
            
            ' Load payment methods
            cmbPaymentMethod.Items.AddRange(New String() {"EFT", "Check", "Cash", "Wire Transfer"})
            cmbPaymentMethod.SelectedIndex = 0
            
            ' Load bank accounts
            Try
                LoadBankAccounts()
            Catch ex As Exception
                MessageBox.Show($"Error loading bank accounts: {ex.Message}", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End Try
            
            ' Load unpaid invoices
            Try
                LoadUnpaidInvoices()
            Catch ex As Exception
                MessageBox.Show($"Error loading invoices: {ex.Message}{Environment.NewLine}{Environment.NewLine}The form will continue to load.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End Try
            
            ' Setup grid
            SetupInvoiceGrid()
            SetupBatchGrid()
            
            ' Initial state
            UpdateUIState()
            
            ' Create status log control
            CreateStatusLogControl()
            
        Catch ex As Exception
            MessageBox.Show($"Error loading form: {ex.Message}{Environment.NewLine}{Environment.NewLine}Stack Trace:{Environment.NewLine}{ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub CreateStatusLogControl()
        Try
            ' Create TabControl below all grids - form will scroll
            tabControl = New TabControl With {
                .Location = New Point(12, 850),
                .Size = New Size(Me.ClientSize.Width - 24, 150),
                .Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right,
                .Visible = True
            }
            
            ' Test Results Tab
            Dim tabTestResults As New TabPage("Test Results")
            txtTestResults = New TextBox With {
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .ReadOnly = True,
                .Font = New Font("Consolas", 9),
                .BackColor = Color.Black,
                .ForeColor = Color.Lime,
                .Dock = DockStyle.Fill
            }
            tabTestResults.Controls.Add(txtTestResults)
            
            ' Response Log Tab
            Dim tabResponseLog As New TabPage("Response Log")
            txtResponseLog = New TextBox With {
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .ReadOnly = True,
                .Font = New Font("Consolas", 9),
                .BackColor = Color.Black,
                .ForeColor = Color.Lime,
                .Dock = DockStyle.Fill
            }
            tabResponseLog.Controls.Add(txtResponseLog)
            
            tabControl.TabPages.Add(tabTestResults)
            tabControl.TabPages.Add(tabResponseLog)
            Me.Controls.Add(tabControl)
            tabControl.BringToFront()
            
            ' Clear Log button
            btnClearLog = New Button With {
                .Text = "Clear Log",
                .Location = New Point(Me.ClientSize.Width - 112, Me.ClientSize.Height - 82),
                .Size = New Size(100, 25),
                .Anchor = AnchorStyles.Bottom Or AnchorStyles.Right,
                .Visible = True
            }
            AddHandler btnClearLog.Click, AddressOf ClearLog_Click
            Me.Controls.Add(btnClearLog)
            btnClearLog.BringToFront()
        Catch ex As Exception
            MessageBox.Show($"Error creating status log: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ClearLog_Click(sender As Object, e As EventArgs)
        If txtTestResults IsNot Nothing Then txtTestResults.Clear()
        If txtResponseLog IsNot Nothing Then txtResponseLog.Clear()
    End Sub

    Private Sub LogMessage(message As String)
        If txtTestResults Is Nothing Then Return
        If txtTestResults.InvokeRequired Then
            txtTestResults.Invoke(Sub() LogMessage(message))
        Else
            Dim timestamp = DateTime.Now.ToString("HH:mm:ss")
            txtTestResults.AppendText($"[{timestamp}] {message}" & Environment.NewLine)
            txtTestResults.SelectionStart = txtTestResults.Text.Length
            txtTestResults.ScrollToCaret()
        End If
    End Sub
    
    Private Sub LogResponse(message As String)
        If txtResponseLog Is Nothing Then Return
        If txtResponseLog.InvokeRequired Then
            txtResponseLog.Invoke(Sub() LogResponse(message))
        Else
            Dim timestamp = DateTime.Now.ToString("HH:mm:ss")
            txtResponseLog.AppendText($"[{timestamp}] {message}" & Environment.NewLine)
            txtResponseLog.SelectionStart = txtResponseLog.Text.Length
            txtResponseLog.ScrollToCaret()
        End If
    End Sub

    Private Sub LoadBankAccounts()
        Try
            cmbBankAccount.Items.Clear()
            cmbBankAccount.Items.Add(New With {.BankAccountID = 0, .Display = "-- Select Bank Account --"})
            
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("SELECT BankAccountID, AccountName, AccountNumber, CurrentBalance FROM BankAccounts WHERE IsActive = 1", conn)
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            cmbBankAccount.Items.Add(New With {
                                .BankAccountID = reader.GetInt32(0),
                                .Display = $"{reader.GetString(1)} ({reader.GetString(2)}) - Balance: {reader.GetDecimal(3):C2}"
                            })
                        End While
                    End Using
                End Using
            End Using
            
            cmbBankAccount.DisplayMember = "Display"
            cmbBankAccount.ValueMember = "BankAccountID"
            cmbBankAccount.SelectedIndex = 0
            
        Catch ex As Exception
            MessageBox.Show($"Error loading bank accounts: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadUnpaidInvoices()
        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GetUnpaidInvoices", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@SupplierID", 0)
                    cmd.Parameters.AddWithValue("@DueDateFrom", DBNull.Value)
                    cmd.Parameters.AddWithValue("@DueDateTo", DBNull.Value)
                    
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                    
                    dgvUnpaidInvoices.DataSource = dt
                    
                    ' Add checkbox column if not exists
                    If Not dgvUnpaidInvoices.Columns.Contains("Select") Then
                        Dim chkCol As New DataGridViewCheckBoxColumn()
                        chkCol.Name = "Select"
                        chkCol.HeaderText = "Select"
                        chkCol.Width = 50
                        dgvUnpaidInvoices.Columns.Insert(0, chkCol)
                    End If
                    
                    ' Update summary
                    lblTotalInvoices.Text = $"Total Invoices: {dt.Rows.Count}"
                    If dt.Rows.Count > 0 Then
                        Dim totalDue As Decimal = dt.AsEnumerable().Sum(Function(r) r.Field(Of Decimal)("AmountDue"))
                        lblTotalDue.Text = $"Total Due: {totalDue:C2}"
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading invoices: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SetupInvoiceGrid()
        With dgvUnpaidInvoices
            .AutoGenerateColumns = True
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect
            .AllowUserToAddRows = False
            .AllowUserToDeleteRows = False
            .ReadOnly = False
            .MultiSelect = True
            
            ' Format columns after data is loaded
            If .Columns.Contains("TotalAmount") Then
                .Columns("TotalAmount").DefaultCellStyle.Format = "C2"
                .Columns("TotalAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            
            If .Columns.Contains("AmountDue") Then
                .Columns("AmountDue").DefaultCellStyle.Format = "C2"
                .Columns("AmountDue").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            
            If .Columns.Contains("DaysOverdue") Then
                .Columns("DaysOverdue").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            End If
        End With
    End Sub

    Private Sub SetupBatchGrid()
        With dgvBatchItems
            .AutoGenerateColumns = True
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect
            .AllowUserToAddRows = False
            .AllowUserToDeleteRows = False
            .ReadOnly = True
            .MultiSelect = True
        End With
    End Sub
    
    Private Sub btnRemoveFromBatch_Click(sender As Object, e As EventArgs) Handles btnRemoveFromBatch.Click
        Try
            If dgvBatchItems.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select invoice(s) to remove from batch.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            If currentFNBBatchID = 0 Then
                MessageBox.Show("No active batch. Please create or load a batch first.", "No Batch", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim result = MessageBox.Show($"Remove {dgvBatchItems.SelectedRows.Count} invoice(s) from batch?", "Confirm Removal", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result <> DialogResult.Yes Then
                Return
            End If
            
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using trans = conn.BeginTransaction()
                    Try
                        For Each row As DataGridViewRow In dgvBatchItems.SelectedRows
                            Dim invoiceID As Integer = Convert.ToInt32(row.Cells("InvoiceID").Value)
                            
                            ' Remove from AP_InvoiceBatchMapping
                            Dim cmdDelete As New SqlCommand("DELETE FROM AP_InvoiceBatchMapping WHERE BatchID = @BatchID AND InvoiceID = @InvoiceID", conn, trans)
                            cmdDelete.Parameters.AddWithValue("@BatchID", currentFNBBatchID)
                            cmdDelete.Parameters.AddWithValue("@InvoiceID", invoiceID)
                            cmdDelete.ExecuteNonQuery()
                            
                            ' Remove from selectedInvoices list
                            If selectedInvoices.Contains(invoiceID) Then
                                selectedInvoices.Remove(invoiceID)
                            End If
                        Next
                        
                        trans.Commit()
                        
                        MessageBox.Show($"{dgvBatchItems.SelectedRows.Count} invoice(s) removed from batch.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        
                        ' Refresh grids
                        LoadBatchItems()
                        LoadUnpaidInvoices()
                        UpdateUIState()
                        
                    Catch ex As Exception
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error removing invoice(s) from batch: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnCreateBatch_Click(sender As Object, e As EventArgs) Handles btnCreateBatch.Click
        Try
            ' Validate
            If cmbPaymentMethod.SelectedIndex < 0 Then
                MessageBox.Show("Please select a payment method", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If cmbBankAccount.SelectedIndex <= 0 Then
                MessageBox.Show("Please select a bank account", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Create batch
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_CreatePaymentBatch", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    
                    Dim batchNumber As New SqlParameter("@BatchNumber", SqlDbType.NVarChar, 50)
                    batchNumber.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(batchNumber)
                    
                    cmd.Parameters.AddWithValue("@PaymentDate", dtpPaymentDate.Value.Date)
                    cmd.Parameters.AddWithValue("@PaymentMethod", cmbPaymentMethod.SelectedItem.ToString())
                    cmd.Parameters.AddWithValue("@BankAccountID", CType(cmbBankAccount.SelectedItem, Object).BankAccountID)
                    cmd.Parameters.AddWithValue("@Notes", txtNotes.Text)
                    cmd.Parameters.AddWithValue("@CreatedBy", If(AppSession.CurrentUsername, "System"))
                    
                    Dim batchID As New SqlParameter("@BatchID", SqlDbType.Int)
                    batchID.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(batchID)
                    
                    cmd.ExecuteNonQuery()
                    
                    currentFNBBatchID = CInt(batchID.Value)
                    txtBatchNumber.Text = batchNumber.Value.ToString()
                    
                    MessageBox.Show($"Batch {txtBatchNumber.Text} created successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    UpdateUIState()
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error creating batch: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnAddSelected_Click(sender As Object, e As EventArgs) Handles btnAddSelected.Click
        Try
            ' Collect selected invoices
            selectedInvoices.Clear()
            
            For Each row As DataGridViewRow In dgvUnpaidInvoices.Rows
                If row.Cells("Select").Value IsNot Nothing AndAlso CBool(row.Cells("Select").Value) = True Then
                    Dim invoiceID As Integer = CInt(row.Cells("InvoiceID").Value)
                    selectedInvoices.Add(invoiceID)
                End If
            Next
            
            If selectedInvoices.Count = 0 Then
                MessageBox.Show("Please select at least one invoice", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            MessageBox.Show($"{selectedInvoices.Count} invoice(s) selected. Click 'Submit to FNB' to process payment.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            LoadBatchItems()
        Catch ex As Exception
            MessageBox.Show($"Error selecting invoices: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadBatchItems()
        Try
            If selectedInvoices.Count = 0 Then
                dgvBatchItems.DataSource = Nothing
                lblBatchTotal.Text = "Batch Total: R0.00"
                lblBatchCount.Text = "Invoices: 0"
                Return
            End If
            
            ' Get details of selected invoices
            Dim invoiceIds As String = String.Join(",", selectedInvoices)
            
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Dim sql As String = $"
                    SELECT 
                        i.InvoiceID,
                        i.InvoiceNumber,
                        b.BeneficiaryName AS SupplierName,
                        i.InvoiceDate,
                        i.DueDate,
                        i.TotalAmount AS InvoiceAmount,
                        i.TotalAmount AS AmountPaid,
                        0 AS DiscountTaken,
                        i.Description AS Notes
                    FROM AP_Invoices i
                    INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
                    WHERE i.InvoiceID IN ({invoiceIds})"
                
                Using cmd As New SqlCommand(sql, conn)
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                    
                    dgvBatchItems.DataSource = dt
                    
                    ' Update totals
                    If dt.Rows.Count > 0 Then
                        Dim totalAmount As Decimal = dt.AsEnumerable().Sum(Function(r) r.Field(Of Decimal)("AmountPaid"))
                        lblBatchTotal.Text = $"Batch Total: {totalAmount:C2}"
                        lblBatchCount.Text = $"Invoices: {dt.Rows.Count}"
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading batch items: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnProcessBatch_Click(sender As Object, e As EventArgs) Handles btnProcessBatch.Click
        Try
            ' Check Administrator or Super Administrator role
            If AppSession.CurrentRoleName <> "Administrator" AndAlso AppSession.CurrentRoleName <> "Super Administrator" Then
                MessageBox.Show("Only Administrators and Super Administrators can process payments.", "Access Denied", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If currentFNBBatchID = 0 Then
                MessageBox.Show("No batch to process", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim result As DialogResult = MessageBox.Show(
                $"Are you sure you want to process batch {txtBatchNumber.Text}?{vbCrLf}This will create payments and update all invoices.",
                "Confirm Payment",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question)
            
            If result = DialogResult.Yes Then
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_ProcessPaymentBatch", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.CommandTimeout = 120
                        cmd.Parameters.AddWithValue("@BatchID", currentFNBBatchID)
                        cmd.Parameters.AddWithValue("@ProcessedBy", If(AppSession.CurrentUsername, "System"))
                        
                        cmd.ExecuteNonQuery()
                        
                        MessageBox.Show("Batch processed successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        
                        ' Reset form
                        currentFNBBatchID = 0
                        txtBatchNumber.Text = ""
                        dgvBatchItems.DataSource = Nothing
                        LoadUnpaidInvoices()
                        UpdateUIState()
                    End Using
                End Using
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error processing batch: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub UpdateUIState()
        Dim hasBatch As Boolean = currentFNBBatchID > 0
        
        btnCreateBatch.Enabled = Not hasBatch
        btnAddSelected.Enabled = hasBatch
        btnProcessBatch.Enabled = hasBatch
        btnPrintSchedule.Enabled = hasBatch
        cmbPaymentMethod.Enabled = Not hasBatch
        cmbBankAccount.Enabled = Not hasBatch
        dtpPaymentDate.Enabled = Not hasBatch
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
    
    Private Sub btnLoadBatch_Click(sender As Object, e As EventArgs) Handles btnLoadBatch.Click
        Try
            ' Create a form to select saved batch
            Dim selectForm As New Form With {
                .Text = "Select Saved Batch",
                .Size = New Size(800, 500),
                .StartPosition = FormStartPosition.CenterParent,
                .FormBorderStyle = FormBorderStyle.FixedDialog,
                .MaximizeBox = False,
                .MinimizeBox = False
            }
            
            Dim dgvBatches As New DataGridView With {
                .Dock = DockStyle.Fill,
                .ReadOnly = True,
                .AllowUserToAddRows = False,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False
            }
            
            Dim btnSelect As New Button With {
                .Text = "Load Selected Batch",
                .Dock = DockStyle.Bottom,
                .Height = 40,
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            
            selectForm.Controls.Add(dgvBatches)
            selectForm.Controls.Add(btnSelect)
            
            ' Load saved batches
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("
                    SELECT 
                        pb.BatchID,
                        pb.BatchNumber,
                        pb.PaymentDate,
                        pb.PaymentMethod,
                        pb.TotalAmount,
                        pb.Status,
                        COUNT(pbi.BatchItemID) AS InvoiceCount
                    FROM PaymentBatches pb
                    LEFT JOIN PaymentBatchItems pbi ON pb.BatchID = pbi.BatchID
                    WHERE pb.Status = 'Draft'
                    GROUP BY pb.BatchID, pb.BatchNumber, pb.PaymentDate, pb.PaymentMethod, pb.TotalAmount, pb.Status
                    ORDER BY pb.BatchNumber DESC", conn)
                    
                    Dim adapter As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)
                    dgvBatches.DataSource = dt
                    
                    If dt.Rows.Count = 0 Then
                        MessageBox.Show("No saved batches found.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Return
                    End If
                End Using
            End Using
            
            ' Handle select button click
            AddHandler btnSelect.Click, Sub(s, ev)
                If dgvBatches.SelectedRows.Count > 0 Then
                    Dim selectedBatchID As Integer = Convert.ToInt32(dgvBatches.SelectedRows(0).Cells("BatchID").Value)
                    Dim selectedBatchNumber As String = dgvBatches.SelectedRows(0).Cells("BatchNumber").ToString()
                    
                    ' Load the batch
                    currentFNBBatchID = selectedBatchID
                    txtBatchNumber.Text = selectedBatchNumber
                    LoadBatchItems()
                    UpdateUIState()
                    
                    selectForm.Close()
                    MessageBox.Show($"Batch {selectedBatchNumber} loaded successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            End Sub
            
            selectForm.ShowDialog()
            
        Catch ex As Exception
            MessageBox.Show($"Error loading saved batches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnPrintSchedule_Click(sender As Object, e As EventArgs) Handles btnPrintSchedule.Click
        Try
            If currentFNBBatchID = 0 Then
                MessageBox.Show("Please create a batch first", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Load batch data for printing
            LoadBatchDataForPrint()
            
            ' Set page settings
            _printDocument.DefaultPageSettings.Landscape = False
            _printDocument.DefaultPageSettings.PaperSize = New PaperSize("A4", 827, 1169)
            
            ' Show print preview
            Dim printPreview As New PrintPreviewDialog With {
                .Document = _printDocument,
                .Width = 1200,
                .Height = 900,
                .WindowState = FormWindowState.Maximized
            }
            printPreview.ShowDialog()
            
        Catch ex As Exception
            MessageBox.Show($"Error printing schedule: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function GeneratePaymentSchedule() As String
        Dim sb As New System.Text.StringBuilder()
        
        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GetPaymentSchedule", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@BatchID", currentFNBBatchID)
                    cmd.Parameters.AddWithValue("@DateFrom", DBNull.Value)
                    cmd.Parameters.AddWithValue("@DateTo", DBNull.Value)
                    cmd.Parameters.AddWithValue("@SupplierID", 0)
                    
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.HasRows Then
                            ' Read first row for header info
                            reader.Read()
                            
                            ' Header
                            sb.AppendLine("═══════════════════════════════════════════════════════════════════════")
                            sb.AppendLine("                        PAYMENT SCHEDULE")
                            sb.AppendLine("                        Oven Delights ERP")
                            sb.AppendLine("═══════════════════════════════════════════════════════════════════════")
                            sb.AppendLine()
                            sb.AppendLine($"Batch Number:     {reader("BatchNumber")}")
                            sb.AppendLine($"Batch Date:       {CDate(reader("BatchDate")):yyyy-MM-dd}")
                            sb.AppendLine($"Payment Date:     {CDate(reader("PaymentDate")):yyyy-MM-dd}")
                            sb.AppendLine($"Payment Method:   {reader("PaymentMethod")}")
                            sb.AppendLine($"Bank Account:     {reader("BankAccount")} ({reader("BankAccountNumber")})")
                            sb.AppendLine($"Total Amount:     {CDec(reader("BatchTotal")):C2}")
                            sb.AppendLine($"Invoice Count:    {reader("InvoiceCount")}")
                            sb.AppendLine($"Status:           {reader("Status")}")
                            If Not IsDBNull(reader("BatchNotes")) AndAlso reader("BatchNotes").ToString().Length > 0 Then
                                sb.AppendLine($"Notes:            {reader("BatchNotes")}")
                            End If
                            sb.AppendLine()
                            sb.AppendLine("───────────────────────────────────────────────────────────────────────")
                            sb.AppendLine("INVOICE DETAILS")
                            sb.AppendLine("───────────────────────────────────────────────────────────────────────")
                            sb.AppendLine()
                            
                            ' Continue reading invoice details
                            While reader.Read()
                                sb.AppendLine($"Invoice:          {reader("InvoiceNumber")}")
                                sb.AppendLine($"Supplier:         {reader("SupplierName")}")
                                If Not IsDBNull(reader("ContactPerson")) Then
                                    sb.AppendLine($"Contact:          {reader("ContactPerson")}")
                                End If
                                If Not IsDBNull(reader("SupplierPhone")) AndAlso reader("SupplierPhone").ToString().Length > 0 Then
                                    sb.AppendLine($"Phone:            {reader("SupplierPhone")}")
                                End If
                                If Not IsDBNull(reader("Email")) AndAlso reader("Email").ToString().Length > 0 Then
                                    sb.AppendLine($"Email:            {reader("Email")}")
                                End If
                                sb.AppendLine($"Invoice Date:     {CDate(reader("InvoiceDate")):yyyy-MM-dd}")
                                sb.AppendLine($"Due Date:         {CDate(reader("DueDate")):yyyy-MM-dd}")
                                sb.AppendLine($"Invoice Amount:   {CDec(reader("InvoiceAmount")):C2}")
                                sb.AppendLine($"Amount Paid:      {CDec(reader("AmountPaid")):C2}")
                                If CDec(reader("DiscountTaken")) > 0 Then
                                    sb.AppendLine($"Discount Taken:   {CDec(reader("DiscountTaken")):C2}")
                                End If
                                sb.AppendLine()
                            End While
                        End If
                    End Using
                End Using
            End Using
            
            sb.AppendLine("═══════════════════════════════════════════════════════════════════════")
            sb.AppendLine($"Generated: {DateTime.Now:yyyy-MM-dd HH:mm:ss}")
            sb.AppendLine($"Generated By: {If(AppSession.CurrentUsername, "System")}")
            sb.AppendLine("═══════════════════════════════════════════════════════════════════════")
            
        Catch ex As Exception
            sb.AppendLine($"Error generating schedule: {ex.Message}")
        End Try
        
        Return sb.ToString()
    End Function
    
    Private Sub LoadBatchDataForPrint()
        Try
            _printData = New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                ' Use the same stored procedure that loads the grid
                Using cmd As New SqlCommand("sp_GetBatchDetails", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@BatchID", currentFNBBatchID)
                    
                    Dim adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(_printData)
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading print data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub _printDocument_PrintPage(sender As Object, e As PrintPageEventArgs) Handles _printDocument.PrintPage
        Try
            If _printData Is Nothing OrElse _printData.Rows.Count = 0 Then Return
            
            Dim g = e.Graphics
            Dim yPos As Integer = 50
            Dim leftMargin As Integer = 50
            Dim pageWidth As Integer = e.PageBounds.Width
            Dim rightMargin As Integer = pageWidth - 50
            
            ' Fonts
            Dim titleFont As New Font("Segoe UI", 18, FontStyle.Bold)
            Dim headerFont As New Font("Segoe UI", 14, FontStyle.Bold)
            Dim normalFont As New Font("Segoe UI", 10)
            Dim boldFont As New Font("Segoe UI", 10, FontStyle.Bold)
            
            ' Date at top right
            Dim dateStr As String = $"Date: {DateTime.Now:dd MMM yyyy}"
            Dim dateSize = g.MeasureString(dateStr, normalFont)
            g.DrawString(dateStr, normalFont, Brushes.Black, rightMargin - dateSize.Width, yPos)
            yPos += 30
            
            ' Title - BOLD LARGE FONT
            Dim titleStr As String = "PAYMENT SCHEDULE"
            Dim titleSize = g.MeasureString(titleStr, titleFont)
            g.DrawString(titleStr, titleFont, Brushes.Black, (pageWidth - titleSize.Width) / 2, yPos)
            yPos += 50
            
            ' Branch info
            g.DrawString(If(AppSession.CurrentBranchName, "Oven Delights"), boldFont, Brushes.Black, leftMargin, yPos)
            yPos += 22
            g.DrawString($"Generated By: {If(AppSession.CurrentUsername, "System")}", normalFont, Brushes.Black, leftMargin, yPos)
            yPos += 20
            g.DrawString($"Batch: {txtBatchNumber.Text}", normalFont, Brushes.Black, leftMargin, yPos)
            yPos += 35
            
            ' Line
            g.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
            yPos += 20
            
            ' Column headers
            g.DrawString("Invoice #", boldFont, Brushes.Black, leftMargin, yPos)
            g.DrawString("Supplier", boldFont, Brushes.Black, leftMargin + 150, yPos)
            g.DrawString("Invoice Amt", boldFont, Brushes.Black, leftMargin + 350, yPos)
            g.DrawString("Payment Amt", boldFont, Brushes.Black, leftMargin + 480, yPos)
            yPos += 25
            
            g.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
            yPos += 15
            
            ' Invoice lines
            Dim totalPayment As Decimal = 0
            For Each row As DataRow In _printData.Rows
                If yPos > e.PageBounds.Height - 200 Then Exit For
                
                Dim invoiceNum As String = If(row("InvoiceNumber") IsNot DBNull.Value, row("InvoiceNumber").ToString(), "")
                Dim supplierName As String = If(row("SupplierName") IsNot DBNull.Value, row("SupplierName").ToString(), "")
                Dim amountPaid As Decimal = If(row("AmountPaid") IsNot DBNull.Value, Convert.ToDecimal(row("AmountPaid")), 0)
                
                g.DrawString(invoiceNum, normalFont, Brushes.Black, leftMargin, yPos)
                g.DrawString(supplierName, normalFont, Brushes.Black, leftMargin + 150, yPos)
                g.DrawString($"R {amountPaid:N2}", normalFont, Brushes.Black, leftMargin + 350, yPos)
                g.DrawString($"R {amountPaid:N2}", normalFont, Brushes.Black, leftMargin + 480, yPos)
                
                totalPayment += amountPaid
                yPos += 25
            Next
            
            yPos += 10
            g.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
            yPos += 20
            
            ' Total
            g.DrawString("TOTAL PAYMENT:", boldFont, Brushes.Black, leftMargin + 350, yPos)
            g.DrawString($"R {totalPayment:N2}", boldFont, Brushes.Black, leftMargin + 480, yPos)
            yPos += 50
            
            ' Payment Date line
            g.DrawString("Payment Date: .................................................", boldFont, Brushes.Black, leftMargin, yPos)
            yPos += 50
            
            ' Signature lines
            g.DrawLine(Pens.Black, leftMargin, yPos, leftMargin + 250, yPos)
            g.DrawLine(Pens.Black, leftMargin + 350, yPos, leftMargin + 600, yPos)
            yPos += 20
            g.DrawString("Prepared By", normalFont, Brushes.Black, leftMargin, yPos)
            g.DrawString("Authorized By (Administrator)", normalFont, Brushes.Black, leftMargin + 350, yPos)
            yPos += 30
            
            ' Footer
            g.DrawString($"Printed: {DateTime.Now:dd MMM yyyy HH:mm}", New Font("Segoe UI", 8), Brushes.Gray, leftMargin, yPos)
            
            e.HasMorePages = False
            
        Catch ex As Exception
            MessageBox.Show($"Error during print: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnSubmitFNB_Click(sender As Object, e As EventArgs) Handles btnSubmitFNB.Click
        Try
            If currentFNBBatchID = 0 Then
                MessageBox.Show("Please create a batch first", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If dgvBatchItems.Rows.Count = 0 Then
                MessageBox.Show("No items in batch to submit", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            ' Supervisor password prompt
            Dim passwordForm As New Form With {
                .Text = "Supervisor Authorization Required",
                .Size = New Size(400, 200),
                .StartPosition = FormStartPosition.CenterParent,
                .FormBorderStyle = FormBorderStyle.FixedDialog,
                .MaximizeBox = False,
                .MinimizeBox = False
            }

            Dim lblPrompt As New Label With {
                .Text = "Enter Supervisor Password to authorize batch payment:",
                .Location = New Point(20, 20),
                .Size = New Size(350, 40),
                .Font = New Font("Segoe UI", 10)
            }

            Dim txtPassword As New TextBox With {
                .Location = New Point(20, 70),
                .Size = New Size(340, 25),
                .UseSystemPasswordChar = True,
                .Font = New Font("Segoe UI", 10)
            }

            Dim btnOK As New Button With {
                .Text = "Authorize",
                .Location = New Point(180, 110),
                .Size = New Size(90, 30),
                .DialogResult = DialogResult.OK
            }

            Dim btnCancel As New Button With {
                .Text = "Cancel",
                .Location = New Point(280, 110),
                .Size = New Size(80, 30),
                .DialogResult = DialogResult.Cancel
            }

            passwordForm.Controls.AddRange({lblPrompt, txtPassword, btnOK, btnCancel})
            passwordForm.AcceptButton = btnOK
            passwordForm.CancelButton = btnCancel

            If passwordForm.ShowDialog() <> DialogResult.OK Then Return

            ' Validate supervisor password
            Dim supervisorPassword As String = txtPassword.Text
            Dim isAuthorized As Boolean = False

            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("SELECT COUNT(*) FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID WHERE u.Password = @Password AND r.RoleName IN ('Administrator', 'Super Administrator') AND u.IsActive = 1", conn)
                    cmd.Parameters.AddWithValue("@Password", supervisorPassword)
                    isAuthorized = CInt(cmd.ExecuteScalar()) > 0
                End Using
            End Using

            If Not isAuthorized Then
                MessageBox.Show("Invalid supervisor password. Batch submission cancelled.", "Authorization Failed", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If

            ' Confirm submission
            Dim result = MessageBox.Show(
                $"Submit batch {txtBatchNumber.Text} to FNB Payment Execution API?" & Environment.NewLine & Environment.NewLine &
                "*** SANDBOX TESTING MODE ***" & Environment.NewLine &
                "Using test beneficiary accounts." & Environment.NewLine & Environment.NewLine &
                $"Total Amount: {lblBatchTotal.Text}" & Environment.NewLine &
                $"Payment Date: {dtpPaymentDate.Value:yyyy-MM-dd}" & Environment.NewLine & Environment.NewLine &
                "Continue?",
                "FNB API Submission",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question
            )

            If result <> DialogResult.Yes Then Return

            ' Build payment lines from batch
            Dim paymentLines As New List(Of PaymentLineInfo)()

            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                ' Get selected invoices with beneficiary info
                If selectedInvoices.Count = 0 Then
                    MessageBox.Show("No invoices selected", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                
                Dim invoiceIds As String = String.Join(",", selectedInvoices)
                Dim sql As String = $"
                    SELECT 
                        i.InvoiceID,
                        i.InvoiceNumber,
                        i.TotalAmount,
                        b.BeneficiaryID,
                        b.BeneficiaryName,
                        b.AccountNumber,
                        b.BranchCode,
                        b.Email
                    FROM AP_Invoices i
                    INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
                    WHERE i.InvoiceID IN ({invoiceIds})"
                
                Using cmd As New SqlCommand(sql, conn)
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim invoiceNum As String = If(reader("InvoiceNumber") Is DBNull.Value, "PAYMENT", reader.GetString(reader.GetOrdinal("InvoiceNumber")))
                            Dim invoiceID As Integer = reader.GetInt32(reader.GetOrdinal("InvoiceID"))
                            Dim amount As Decimal = reader.GetDecimal(reader.GetOrdinal("TotalAmount"))

                            Dim line As New PaymentLineInfo() With {
                                .SupplierID = invoiceID,
                                .PaymentType = "Beneficiary",
                                .CreditorName = reader.GetString(reader.GetOrdinal("BeneficiaryName")),
                                .CreditorAccountNumber = If(reader("AccountNumber") Is DBNull.Value, "", reader.GetString(reader.GetOrdinal("AccountNumber"))),
                                .CreditorAccountType = "CACC",
                                .CreditorBranchCode = If(reader("BranchCode") Is DBNull.Value, "250655", reader.GetString(reader.GetOrdinal("BranchCode"))),
                                .CreditorBIC = "FIRNZAJJ",
                                .Amount = amount,
                                .Reference = invoiceNum.Substring(0, Math.Min(20, invoiceNum.Length)),
                                .ProofOfPaymentEmail = "tshepo.kgasoane@rmb.co.za"
                            }

                            ' Validate bank details
                            If String.IsNullOrEmpty(line.CreditorAccountNumber) Then
                                MessageBox.Show($"Beneficiary '{line.CreditorName}' has no bank account number configured.", "Missing Bank Details", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                Return
                            End If

                            paymentLines.Add(line)
                        End While
                    End Using
                End Using
            End Using

            If paymentLines.Count = 0 Then
                MessageBox.Show("No valid payment lines found", "No Data", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            ' Submit to FNB API
            Cursor = Cursors.WaitCursor
            btnSubmitFNB.Enabled = False
            
            ' Clear and show status log
            If txtTestResults IsNot Nothing Then
                txtTestResults.Clear()
                LogMessage("Preparing FNB batch payment submission...")
            End If
            
            Dim paymentService As New FNBPaymentExecutionService(connectionString, "Sandbox")
            
            ' Wire up status event handler
            AddHandler paymentService.StatusUpdate, AddressOf LogMessage
            
            Dim executionDate = dtpPaymentDate.Value.Date
            Dim branchId = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 1)
            Dim createdBy = If(AppSession.CurrentUser IsNot Nothing, AppSession.CurrentUser.UserID, 1)

            Dim submitResult = paymentService.CreateAndSubmitPaymentBatch(paymentLines, executionDate, branchId, createdBy)
            
            ' Remove event handler
            RemoveHandler paymentService.StatusUpdate, AddressOf LogMessage

            Cursor = Cursors.Default
            btnSubmitFNB.Enabled = True

            If submitResult.Item1 Then
                ' Save invoice-to-batch mappings
                Dim fnbBatchID As Integer = submitResult.Item3
                Try
                    Using conn As New SqlConnection(connectionString)
                        conn.Open()
                        For Each invoiceID In selectedInvoices
                            ' Get invoice amount
                            Dim amount As Decimal = 0
                            Using cmdAmount As New SqlCommand("SELECT TotalAmount FROM AP_Invoices WHERE InvoiceID = @InvoiceID", conn)
                                cmdAmount.Parameters.AddWithValue("@InvoiceID", invoiceID)
                                Dim amountResult = cmdAmount.ExecuteScalar()
                                If amountResult IsNot Nothing Then amount = CDec(amountResult)
                            End Using
                            
                            ' Insert mapping
                            Using cmdInsert As New SqlCommand("INSERT INTO AP_InvoiceBatchMapping (InvoiceID, FNB_BatchID, AmountPaid, AddedBy, AddedDate) VALUES (@InvoiceID, @FNB_BatchID, @AmountPaid, @AddedBy, GETDATE())", conn)
                                cmdInsert.Parameters.AddWithValue("@InvoiceID", invoiceID)
                                cmdInsert.Parameters.AddWithValue("@FNB_BatchID", fnbBatchID)
                                cmdInsert.Parameters.AddWithValue("@AmountPaid", amount)
                                cmdInsert.Parameters.AddWithValue("@AddedBy", createdBy)
                                cmdInsert.ExecuteNonQuery()
                            End Using
                        Next
                    End Using
                    
                    ' Clear selected invoices and refresh
                    selectedInvoices.Clear()
                    LoadUnpaidInvoices()
                    LoadBatchItems()
                    
                Catch ex As Exception
                    LogMessage($"Warning: Failed to save invoice mappings: {ex.Message}")
                End Try
                
                MessageBox.Show(
                    $"Payment batch submitted successfully to FNB!" & Environment.NewLine & Environment.NewLine &
                    submitResult.Item2 & Environment.NewLine & Environment.NewLine &
                    $"FNB Batch ID: {submitResult.Item3}" & Environment.NewLine & Environment.NewLine &
                    "Click 'View Transactions' to monitor payment status.",
                    "Success",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information
                )
            Else
                MessageBox.Show(
                    $"Failed to submit payment batch to FNB:" & Environment.NewLine & Environment.NewLine &
                    submitResult.Item2,
                    "Submission Failed",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error
                )
            End If

        Catch ex As Exception
            Cursor = Cursors.Default
            btnSubmitFNB.Enabled = True
            MessageBox.Show($"Error submitting to FNB API: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnViewTransactions_Click(sender As Object, e As EventArgs) Handles btnViewTransactions.Click
        Try
            Dim viewForm As New FNBTransactionViewerForm()
            viewForm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show($"Error opening transaction viewer: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
