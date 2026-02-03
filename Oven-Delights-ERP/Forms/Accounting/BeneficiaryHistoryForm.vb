Imports System.Data.SqlClient
Imports System.Windows.Forms
Imports System.Configuration
Imports System.IO

Namespace Accounting
    Public Class BeneficiaryHistoryForm
        Inherits Form
    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private selectedBeneficiaryID As Integer = 0
    Private openingBalance As Decimal = 0

    Private Sub BeneficiaryHistoryForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Beneficiary Payment History"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen

        SetupUI()
        LoadBeneficiaries()
    End Sub

    Private Sub SetupUI()
        ' Beneficiary Selection Panel
        Dim pnlTop As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .Padding = New Padding(10)
        }

        Dim lblBeneficiary As New Label With {
            .Text = "Select Beneficiary:",
            .Location = New Point(10, 15),
            .Size = New Size(120, 20),
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }

        Dim cboBeneficiary As New ComboBox With {
            .Name = "cboBeneficiary",
            .Location = New Point(140, 12),
            .Size = New Size(400, 25),
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Font = New Font("Segoe UI", 10)
        }
        AddHandler cboBeneficiary.SelectedIndexChanged, AddressOf cboBeneficiary_SelectedIndexChanged

        ' Date Range Filters
        Dim lblDateFrom As New Label With {
            .Text = "From Date:",
            .Location = New Point(660, 15),
            .Size = New Size(70, 20),
            .Font = New Font("Segoe UI", 9)
        }

        Dim dtpDateFrom As New DateTimePicker With {
            .Name = "dtpDateFrom",
            .Location = New Point(735, 12),
            .Size = New Size(120, 25),
            .Format = DateTimePickerFormat.Short,
            .Value = New Date(DateTime.Now.Year, 1, 1)
        }

        Dim lblDateTo As New Label With {
            .Text = "To Date:",
            .Location = New Point(870, 15),
            .Size = New Size(55, 20),
            .Font = New Font("Segoe UI", 9)
        }

        Dim dtpDateTo As New DateTimePicker With {
            .Name = "dtpDateTo",
            .Location = New Point(930, 12),
            .Size = New Size(120, 25),
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Now
        }

        Dim btnRefresh As New Button With {
            .Text = "🔄 Refresh",
            .Location = New Point(1060, 10),
            .Size = New Size(100, 30),
            .Font = New Font("Segoe UI", 9)
        }
        AddHandler btnRefresh.Click, AddressOf btnRefresh_Click

        Dim btnExport As New Button With {
            .Name = "btnExport",
            .Text = "📊 Export to CSV",
            .Location = New Point(660, 45),
            .Size = New Size(130, 30),
            .Font = New Font("Segoe UI", 9)
        }
        AddHandler btnExport.Click, AddressOf btnExport_Click

        Dim btnPrint As New Button With {
            .Name = "btnPrint",
            .Text = "🖨️ Print",
            .Location = New Point(800, 45),
            .Size = New Size(100, 30),
            .Font = New Font("Segoe UI", 9)
        }
        AddHandler btnPrint.Click, AddressOf btnPrint_Click

        ' Summary Labels
        Dim lblTotalInvoices As New Label With {
            .Name = "lblTotalInvoices",
            .Text = "Total Invoices: R0.00",
            .Location = New Point(10, 50),
            .Size = New Size(200, 20),
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .ForeColor = Color.DarkBlue
        }

        Dim lblTotalPayments As New Label With {
            .Name = "lblTotalPayments",
            .Text = "Total Payments: R0.00",
            .Location = New Point(220, 50),
            .Size = New Size(200, 20),
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .ForeColor = Color.DarkGreen
        }

        Dim lblBalance As New Label With {
            .Name = "lblBalance",
            .Text = "Balance Due: R0.00",
            .Location = New Point(430, 50),
            .Size = New Size(200, 20),
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .ForeColor = Color.DarkRed
        }

        Dim lblOpeningBalance As New Label With {
            .Name = "lblOpeningBalance",
            .Text = "Opening Balance: R0.00",
            .Location = New Point(10, 85),
            .Size = New Size(250, 20),
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .ForeColor = Color.DarkOrange
        }

        pnlTop.Controls.AddRange({lblBeneficiary, cboBeneficiary, lblDateFrom, dtpDateFrom, lblDateTo, dtpDateTo, btnRefresh, btnExport, btnPrint, lblTotalInvoices, lblTotalPayments, lblBalance, lblOpeningBalance})

        ' DataGridView for transactions
        Dim dgvHistory As New DataGridView With {
            .Name = "dgvHistory",
            .Dock = DockStyle.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .MultiSelect = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 9)
        }
        AddHandler dgvHistory.CellDoubleClick, AddressOf dgvHistory_CellDoubleClick

        Me.Controls.Add(dgvHistory)
        Me.Controls.Add(pnlTop)
    End Sub

    Private Sub LoadBeneficiaries()
        Dim cboBeneficiary = CType(Me.Controls.Find("cboBeneficiary", True).FirstOrDefault(), ComboBox)
        If cboBeneficiary Is Nothing Then Return

        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Dim query As String = "SELECT BeneficiaryID, BeneficiaryName FROM AP_Beneficiaries WHERE IsActive = 1 ORDER BY BeneficiaryName"
                Using cmd As New SqlCommand(query, conn)
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        Dim dt As New DataTable()
                        dt.Load(reader)

                        cboBeneficiary.DisplayMember = "BeneficiaryName"
                        cboBeneficiary.ValueMember = "BeneficiaryID"
                        cboBeneficiary.DataSource = dt
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading beneficiaries: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub cboBeneficiary_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim cboBeneficiary = CType(sender, ComboBox)
        If cboBeneficiary.SelectedValue IsNot Nothing AndAlso IsNumeric(cboBeneficiary.SelectedValue) Then
            selectedBeneficiaryID = Convert.ToInt32(cboBeneficiary.SelectedValue)
            LoadBeneficiaryHistory()
        End If
    End Sub

    Private Sub LoadBeneficiaryHistory()
        If selectedBeneficiaryID = 0 Then Return

        Dim dgvHistory = CType(Me.Controls.Find("dgvHistory", True).FirstOrDefault(), DataGridView)
        If dgvHistory Is Nothing Then Return

        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()

                Dim dtpDateFrom = CType(Me.Controls.Find("dtpDateFrom", True).FirstOrDefault(), DateTimePicker)
                Dim dtpDateTo = CType(Me.Controls.Find("dtpDateTo", True).FirstOrDefault(), DateTimePicker)
                Dim dateFrom As Date = If(dtpDateFrom IsNot Nothing, dtpDateFrom.Value.Date, New Date(DateTime.Now.Year, 1, 1))
                Dim dateTo As Date = If(dtpDateTo IsNot Nothing, dtpDateTo.Value.Date, DateTime.Now.Date)

                ' Calculate opening balance (transactions before dateFrom)
                Dim openingQuery As String = "
                    SELECT 
                        ISNULL(SUM(i.TotalAmount), 0) - ISNULL(SUM(m.AmountPaid), 0) AS OpeningBalance
                    FROM AP_Invoices i
                    LEFT JOIN AP_InvoiceBatchMapping m ON i.InvoiceID = m.InvoiceID
                    LEFT JOIN FNB_PaymentBatches pb ON m.FNB_BatchID = pb.BatchID AND pb.BatchStatus IN ('ACCP', 'ACSC', 'Pending', 'PDNG')
                    WHERE i.BeneficiaryID = @BeneficiaryID
                      AND i.InvoiceDate < @DateFrom"

                Using cmdOpening As New SqlCommand(openingQuery, conn)
                    cmdOpening.Parameters.AddWithValue("@BeneficiaryID", selectedBeneficiaryID)
                    cmdOpening.Parameters.AddWithValue("@DateFrom", dateFrom)
                    Dim result = cmdOpening.ExecuteScalar()
                    openingBalance = If(result IsNot Nothing AndAlso Not IsDBNull(result), CDec(result), 0)
                End Using

                ' Get all transactions within date range (ordered oldest to newest)
                Dim query As String = "
                    SELECT 
                        'Invoice' AS TransactionType,
                        i.InvoiceID AS TransactionID,
                        i.InvoiceNumber AS Reference,
                        i.InvoiceDate AS TransactionDate,
                        i.DueDate,
                        c.CategoryName AS Category,
                        i.Description,
                        i.TotalAmount AS Debit,
                        0.00 AS Credit,
                        i.TotalAmount AS Balance,
                        i.Status
                    FROM AP_Invoices i
                    INNER JOIN AP_Categories c ON i.CategoryID = c.CategoryID
                    WHERE i.BeneficiaryID = @BeneficiaryID
                      AND i.InvoiceDate >= @DateFrom
                      AND i.InvoiceDate <= @DateTo
                    
                    UNION ALL
                    
                    SELECT 
                        'Payment' AS TransactionType,
                        pt.PaymentTransactionID AS TransactionID,
                        pt.EndToEndID AS Reference,
                        pb.RequestedExecutionDate AS TransactionDate,
                        NULL AS DueDate,
                        'Payment' AS Category,
                        CONCAT('FNB Payment - ', pb.MessageID) AS Description,
                        0.00 AS Debit,
                        pt.Amount AS Credit,
                        -pt.Amount AS Balance,
                        pb.BatchStatus AS Status
                    FROM FNB_PaymentTransactions pt
                    INNER JOIN FNB_PaymentBatches pb ON pt.BatchID = pb.BatchID
                    INNER JOIN AP_InvoiceBatchMapping m ON m.FNB_BatchID = pb.BatchID
                    INNER JOIN AP_Invoices i ON m.InvoiceID = i.InvoiceID
                    WHERE i.BeneficiaryID = @BeneficiaryID 
                      AND pb.BatchStatus IN ('ACCP', 'ACSC', 'Pending', 'PDNG')
                      AND pb.RequestedExecutionDate >= @DateFrom
                      AND pb.RequestedExecutionDate <= @DateTo
                    
                    ORDER BY TransactionDate ASC, TransactionType ASC"

                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@BeneficiaryID", selectedBeneficiaryID)
                    cmd.Parameters.AddWithValue("@DateFrom", dateFrom)
                    cmd.Parameters.AddWithValue("@DateTo", dateTo)

                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)

                        ' Calculate running balance starting from opening balance
                        Dim runningBalance As Decimal = openingBalance
                        For i As Integer = 0 To dt.Rows.Count - 1
                            runningBalance += CDec(dt.Rows(i)("Balance"))
                            dt.Rows(i)("Balance") = runningBalance
                        Next

                        ' Update opening balance label
                        Dim lblOpeningBalance = CType(Me.Controls.Find("lblOpeningBalance", True).FirstOrDefault(), Label)
                        If lblOpeningBalance IsNot Nothing Then
                            lblOpeningBalance.Text = $"Opening Balance: R{openingBalance:N2}"
                            lblOpeningBalance.ForeColor = If(openingBalance >= 0, Color.DarkGreen, Color.DarkRed)
                        End If

                        dgvHistory.DataSource = dt

                        ' Format columns
                        If dgvHistory.Columns.Count > 0 Then
                            dgvHistory.Columns("TransactionID").Visible = False
                            dgvHistory.Columns("TransactionType").Width = 80
                            dgvHistory.Columns("Reference").Width = 120
                            dgvHistory.Columns("TransactionDate").Width = 100
                            dgvHistory.Columns("TransactionDate").DefaultCellStyle.Format = "yyyy-MM-dd"
                            dgvHistory.Columns("DueDate").Width = 100
                            dgvHistory.Columns("DueDate").DefaultCellStyle.Format = "yyyy-MM-dd"
                            dgvHistory.Columns("Category").Width = 120
                            dgvHistory.Columns("Description").AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
                            dgvHistory.Columns("Debit").Width = 100
                            dgvHistory.Columns("Debit").DefaultCellStyle.Format = "N2"
                            dgvHistory.Columns("Debit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                            dgvHistory.Columns("Credit").Width = 100
                            dgvHistory.Columns("Credit").DefaultCellStyle.Format = "N2"
                            dgvHistory.Columns("Credit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                            dgvHistory.Columns("Balance").Width = 120
                            dgvHistory.Columns("Balance").DefaultCellStyle.Format = "N2"
                            dgvHistory.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                            dgvHistory.Columns("Status").Width = 100

                            ' Color code rows
                            For Each row As DataGridViewRow In dgvHistory.Rows
                                If row.Cells("TransactionType").Value.ToString() = "Invoice" Then
                                    row.DefaultCellStyle.BackColor = Color.FromArgb(255, 240, 240)
                                Else
                                    row.DefaultCellStyle.BackColor = Color.FromArgb(240, 255, 240)
                                End If

                                ' Highlight overdue invoices
                                If row.Cells("Status").Value.ToString() = "Overdue" Then
                                    row.DefaultCellStyle.ForeColor = Color.DarkRed
                                    row.DefaultCellStyle.Font = New Font(dgvHistory.Font, FontStyle.Bold)
                                End If
                            Next
                        End If

                        UpdateSummary(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading history: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub UpdateSummary(dt As DataTable)
        Dim totalInvoices As Decimal = 0
        Dim totalPayments As Decimal = 0

        For Each row As DataRow In dt.Rows
            totalInvoices += CDec(row("Debit"))
            totalPayments += CDec(row("Credit"))
        Next

        Dim balance As Decimal = totalInvoices - totalPayments

        Dim lblTotalInvoices = CType(Me.Controls.Find("lblTotalInvoices", True).FirstOrDefault(), Label)
        Dim lblTotalPayments = CType(Me.Controls.Find("lblTotalPayments", True).FirstOrDefault(), Label)
        Dim lblBalance = CType(Me.Controls.Find("lblBalance", True).FirstOrDefault(), Label)

        If lblTotalInvoices IsNot Nothing Then lblTotalInvoices.Text = $"Total Invoices: R{totalInvoices:N2}"
        If lblTotalPayments IsNot Nothing Then lblTotalPayments.Text = $"Total Payments: R{totalPayments:N2}"
        If lblBalance IsNot Nothing Then
            lblBalance.Text = $"Balance Due: R{balance:N2}"
            lblBalance.ForeColor = If(balance > 0, Color.DarkRed, Color.DarkGreen)
        End If
    End Sub

    Private Sub dgvHistory_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex < 0 Then Return

        Dim dgvHistory = CType(sender, DataGridView)
        Dim transactionType As String = dgvHistory.Rows(e.RowIndex).Cells("TransactionType").Value.ToString()
        Dim transactionID As Integer = Convert.ToInt32(dgvHistory.Rows(e.RowIndex).Cells("TransactionID").Value)
        Dim reference As String = dgvHistory.Rows(e.RowIndex).Cells("Reference").Value.ToString()

        ShowTransactionDetails(transactionType, transactionID, reference)
    End Sub

    Private Sub ShowTransactionDetails(transactionType As String, transactionID As Integer, reference As String)
        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()

                Dim details As String = ""

                If transactionType = "Invoice" Then
                    Dim query As String = "
                        SELECT 
                            i.InvoiceNumber,
                            i.InvoiceDate,
                            i.DueDate,
                            b.BeneficiaryName,
                            c.CategoryName,
                            i.Description,
                            i.Reference,
                            i.Amount,
                            i.TaxAmount,
                            i.TotalAmount,
                            i.Status,
                            i.CreatedBy,
                            i.CreatedDate
                        FROM AP_Invoices i
                        INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
                        INNER JOIN AP_Categories c ON i.CategoryID = c.CategoryID
                        WHERE i.InvoiceID = @ID"

                    Using cmd As New SqlCommand(query, conn)
                        cmd.Parameters.AddWithValue("@ID", transactionID)
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            If reader.Read() Then
                                details = $"INVOICE DETAILS{vbCrLf}{vbCrLf}" &
                                         $"Invoice Number: {reader("InvoiceNumber")}{vbCrLf}" &
                                         $"Beneficiary: {reader("BeneficiaryName")}{vbCrLf}" &
                                         $"Category: {reader("CategoryName")}{vbCrLf}" &
                                         $"Invoice Date: {CDate(reader("InvoiceDate")):yyyy-MM-dd}{vbCrLf}" &
                                         $"Due Date: {CDate(reader("DueDate")):yyyy-MM-dd}{vbCrLf}" &
                                         $"Status: {reader("Status")}{vbCrLf}{vbCrLf}" &
                                         $"Description: {reader("Description")}{vbCrLf}" &
                                         $"Reference: {reader("Reference")}{vbCrLf}{vbCrLf}" &
                                         $"Amount: R{CDec(reader("Amount")):N2}{vbCrLf}" &
                                         $"Tax: R{CDec(reader("TaxAmount")):N2}{vbCrLf}" &
                                         $"Total: R{CDec(reader("TotalAmount")):N2}{vbCrLf}{vbCrLf}" &
                                         $"Created By: {reader("CreatedBy")}{vbCrLf}" &
                                         $"Created Date: {CDate(reader("CreatedDate")):yyyy-MM-dd HH:mm}"
                            End If
                        End Using
                    End Using

                ElseIf transactionType = "Payment" Then
                    Dim query As String = "
                        SELECT 
                            pb.BatchNumber,
                            pb.BatchDate,
                            pbi.Amount,
                            pbi.Status,
                            pbi.StatusMessage,
                            pbi.RejectionReasonText,
                            pbi.EndToEndID,
                            i.InvoiceNumber,
                            b.BeneficiaryName,
                            pb.InstructionID,
                            pb.SubmittedDate,
                            pb.CompletedDate,
                            pb.CreatedBy
                        FROM AP_PaymentBatchItems pbi
                        INNER JOIN AP_PaymentBatches pb ON pbi.BatchID = pb.BatchID
                        INNER JOIN AP_Invoices i ON pbi.InvoiceID = i.InvoiceID
                        INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
                        WHERE pbi.BatchItemID = @ID"

                    Using cmd As New SqlCommand(query, conn)
                        cmd.Parameters.AddWithValue("@ID", transactionID)
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            If reader.Read() Then
                                details = $"PAYMENT DETAILS{vbCrLf}{vbCrLf}" &
                                         $"Batch Number: {reader("BatchNumber")}{vbCrLf}" &
                                         $"Batch Date: {CDate(reader("BatchDate")):yyyy-MM-dd HH:mm}{vbCrLf}" &
                                         $"Beneficiary: {reader("BeneficiaryName")}{vbCrLf}" &
                                         $"Invoice: {reader("InvoiceNumber")}{vbCrLf}{vbCrLf}" &
                                         $"Payment Amount: R{CDec(reader("Amount")):N2}{vbCrLf}" &
                                         $"Status: {reader("Status")}{vbCrLf}" &
                                         $"Status Message: {If(IsDBNull(reader("StatusMessage")), "N/A", reader("StatusMessage"))}{vbCrLf}" &
                                         If(IsDBNull(reader("RejectionReasonText")), "", $"Rejection Reason: {reader("RejectionReasonText")}{vbCrLf}") &
                                         $"{vbCrLf}FNB End-to-End ID: {If(IsDBNull(reader("EndToEndID")), "N/A", reader("EndToEndID"))}{vbCrLf}" &
                                         $"FNB Instruction ID: {If(IsDBNull(reader("InstructionID")), "N/A", reader("InstructionID"))}{vbCrLf}" &
                                         $"Submitted: {If(IsDBNull(reader("SubmittedDate")), "N/A", CDate(reader("SubmittedDate")).ToString("yyyy-MM-dd HH:mm"))}{vbCrLf}" &
                                         $"Completed: {If(IsDBNull(reader("CompletedDate")), "N/A", CDate(reader("CompletedDate")).ToString("yyyy-MM-dd HH:mm"))}{vbCrLf}{vbCrLf}" &
                                         $"Created By: {reader("CreatedBy")}"
                            End If
                        End Using
                    End Using
                End If

                If Not String.IsNullOrEmpty(details) Then
                    MessageBox.Show(details, $"{transactionType} Details - {reference}", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading details: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs)
        LoadBeneficiaryHistory()
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs)
        Try
            Dim dgvHistory = CType(Me.Controls.Find("dgvHistory", True).FirstOrDefault(), DataGridView)
            If dgvHistory Is Nothing OrElse dgvHistory.Rows.Count = 0 Then
                MessageBox.Show("No data to export", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim cboBeneficiary = CType(Me.Controls.Find("cboBeneficiary", True).FirstOrDefault(), ComboBox)
            Dim beneficiaryName As String = If(cboBeneficiary IsNot Nothing, cboBeneficiary.Text.Replace(" ", "_"), "Unknown")
            Dim fileName As String = $"BeneficiaryHistory_{beneficiaryName}_{DateTime.Now:yyyyMMdd_HHmmss}.csv"
            
            Dim saveDialog As New SaveFileDialog With {
                .Filter = "CSV Files (*.csv)|*.csv",
                .FileName = fileName,
                .Title = "Export to CSV"
            }

            If saveDialog.ShowDialog() = DialogResult.OK Then
                Using writer As New StreamWriter(saveDialog.FileName)
                    ' Write opening balance
                    writer.WriteLine($"Opening Balance,R{openingBalance:N2}")
                    writer.WriteLine()
                    
                    ' Write headers
                    Dim headers As New List(Of String)
                    For Each col As DataGridViewColumn In dgvHistory.Columns
                        If col.Visible Then
                            headers.Add(col.HeaderText)
                        End If
                    Next
                    writer.WriteLine(String.Join(",", headers))

                    ' Write data
                    For Each row As DataGridViewRow In dgvHistory.Rows
                        Dim values As New List(Of String)
                        For Each col As DataGridViewColumn In dgvHistory.Columns
                            If col.Visible Then
                                Dim cellValue = row.Cells(col.Index).Value
                                Dim value As String = If(cellValue IsNot Nothing, cellValue.ToString().Replace(",", ";"), "")
                                values.Add($"""{value}""")
                            End If
                        Next
                        writer.WriteLine(String.Join(",", values))
                    Next
                End Using

                MessageBox.Show($"Data exported successfully to:{vbCrLf}{saveDialog.FileName}", "Export Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Process.Start("explorer.exe", $"/select,""{saveDialog.FileName}""")
            End If
        Catch ex As Exception
            MessageBox.Show($"Error exporting: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnPrint_Click(sender As Object, e As EventArgs)
        Try
            Dim dgvHistory = CType(Me.Controls.Find("dgvHistory", True).FirstOrDefault(), DataGridView)
            If dgvHistory Is Nothing OrElse dgvHistory.Rows.Count = 0 Then
                MessageBox.Show("No data to print", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim cboBeneficiary = CType(Me.Controls.Find("cboBeneficiary", True).FirstOrDefault(), ComboBox)
            Dim beneficiaryName As String = If(cboBeneficiary IsNot Nothing, cboBeneficiary.Text, "Unknown")

            Dim printDoc As New Printing.PrintDocument()
            AddHandler printDoc.PrintPage, Sub(s, ev)
                Dim font As New Font("Arial", 10)
                Dim headerFont As New Font("Arial", 12, FontStyle.Bold)
                Dim y As Integer = 50

                ' Print header
                ev.Graphics.DrawString($"Beneficiary Payment History - {beneficiaryName}", headerFont, Brushes.Black, 50, y)
                y += 30
                ev.Graphics.DrawString($"Opening Balance: R{openingBalance:N2}", font, Brushes.Black, 50, y)
                y += 40

                ' Print column headers
                Dim x As Integer = 50
                For Each col As DataGridViewColumn In dgvHistory.Columns
                    If col.Visible Then
                        ev.Graphics.DrawString(col.HeaderText, font, Brushes.Black, x, y)
                        x += 100
                    End If
                Next
                y += 20

                ' Print rows
                For Each row As DataGridViewRow In dgvHistory.Rows
                    x = 50
                    For Each col As DataGridViewColumn In dgvHistory.Columns
                        If col.Visible Then
                            ev.Graphics.DrawString(row.Cells(col.Index).Value?.ToString(), font, Brushes.Black, x, y)
                            x += 100
                        End If
                    Next
                    y += 20
                    If y > ev.PageBounds.Height - 100 Then Exit For
                Next
            End Sub

            Dim printDialog As New PrintDialog()
            printDialog.Document = printDoc
            If printDialog.ShowDialog() = DialogResult.OK Then
                printDoc.Print()
            End If
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    End Class
End Namespace
