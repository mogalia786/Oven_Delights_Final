Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing.Printing

Public Class BatchPaymentForm
    Private connectionString As String
    Private currentBatchID As Integer = 0
    Private selectedInvoices As New List(Of Integer)
    Private WithEvents _printDocument As New PrintDocument()
    Private _printData As DataTable

    Public Sub New()
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Private Sub BatchPaymentForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            ' Set default dates
            dtpPaymentDate.Value = DateTime.Now
            
            ' Load payment methods
            cmbPaymentMethod.Items.AddRange(New String() {"EFT", "Check", "Cash", "Wire Transfer"})
            cmbPaymentMethod.SelectedIndex = 0
            
            ' Load bank accounts
            LoadBankAccounts()
            
            ' Load unpaid invoices
            LoadUnpaidInvoices()
            
            ' Setup grid
            SetupInvoiceGrid()
            SetupBatchGrid()
            
            ' Initial state
            UpdateUIState()
            
        Catch ex As Exception
            MessageBox.Show($"Error loading form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
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
        End With
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
                    cmd.Parameters.AddWithValue("@CreatedBy", AppSession.CurrentUsername)
                    
                    Dim batchID As New SqlParameter("@BatchID", SqlDbType.Int)
                    batchID.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(batchID)
                    
                    cmd.ExecuteNonQuery()
                    
                    currentBatchID = CInt(batchID.Value)
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
            If currentBatchID = 0 Then
                MessageBox.Show("Please create a batch first", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim addedCount As Integer = 0
            
            For Each row As DataGridViewRow In dgvUnpaidInvoices.Rows
                If row.Cells("Select").Value IsNot Nothing AndAlso CBool(row.Cells("Select").Value) = True Then
                    Dim invoiceID As Integer = CInt(row.Cells("InvoiceID").Value)
                    Dim amountDue As Decimal = CDec(row.Cells("AmountDue").Value)
                    
                    ' Add to batch
                    Using conn As New SqlConnection(connectionString)
                        conn.Open()
                        Using cmd As New SqlCommand("sp_AddInvoiceToBatch", conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.AddWithValue("@BatchID", currentBatchID)
                            cmd.Parameters.AddWithValue("@InvoiceID", invoiceID)
                            cmd.Parameters.AddWithValue("@AmountToPay", amountDue)
                            cmd.Parameters.AddWithValue("@DiscountTaken", 0)
                            
                            cmd.ExecuteNonQuery()
                            addedCount += 1
                        End Using
                    End Using
                End If
            Next
            
            If addedCount > 0 Then
                MessageBox.Show($"{addedCount} invoice(s) added to batch", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                LoadBatchItems()
                LoadUnpaidInvoices() ' Refresh
            Else
                MessageBox.Show("No invoices selected", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error adding invoices: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadBatchItems()
        Try
            If currentBatchID = 0 Then Return
            
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GetBatchDetails", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@BatchID", currentBatchID)
                    
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
            
            If currentBatchID = 0 Then
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
                        cmd.Parameters.AddWithValue("@BatchID", currentBatchID)
                        cmd.Parameters.AddWithValue("@ProcessedBy", AppSession.CurrentUsername)
                        
                        cmd.ExecuteNonQuery()
                        
                        MessageBox.Show("Batch processed successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        
                        ' Reset form
                        currentBatchID = 0
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
        Dim hasBatch As Boolean = currentBatchID > 0
        
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
                    currentBatchID = selectedBatchID
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
            If currentBatchID = 0 Then
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
                    cmd.Parameters.AddWithValue("@BatchID", currentBatchID)
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
            sb.AppendLine($"Generated By: {AppSession.CurrentUsername}")
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
                    cmd.Parameters.AddWithValue("@BatchID", currentBatchID)
                    
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
            g.DrawString(AppSession.CurrentBranchName, boldFont, Brushes.Black, leftMargin, yPos)
            yPos += 22
            g.DrawString(AppSession.CurrentBranchAddress, normalFont, Brushes.Black, leftMargin, yPos)
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
End Class
