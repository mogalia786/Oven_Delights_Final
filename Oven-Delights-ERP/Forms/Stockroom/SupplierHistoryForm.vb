Imports System.Data.SqlClient
Imports System.Windows.Forms
Imports System.Configuration
Imports System.IO

Namespace Stockroom
    Public Class SupplierHistoryForm
        Inherits Form
    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private selectedSupplierID As Integer = 0
    Private openingBalance As Decimal = 0

    Private Sub SupplierHistoryForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Supplier Payment History"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen

        SetupUI()
        LoadSuppliers()
    End Sub

    Private Sub SetupUI()
        ' Supplier Selection Panel
        Dim pnlTop As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .Padding = New Padding(10)
        }

        Dim lblSupplier As New Label With {
            .Text = "Select Supplier:",
            .Location = New Point(10, 15),
            .Size = New Size(120, 20),
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }

        Dim cboSupplier As New ComboBox With {
            .Name = "cboSupplier",
            .Location = New Point(140, 12),
            .Size = New Size(400, 25),
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Font = New Font("Segoe UI", 10)
        }
        AddHandler cboSupplier.SelectedIndexChanged, AddressOf cboSupplier_SelectedIndexChanged

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
        Dim lblTotalPurchases As New Label With {
            .Name = "lblTotalPurchases",
            .Text = "Total Purchases: R0.00",
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

        pnlTop.Controls.AddRange({lblSupplier, cboSupplier, lblDateFrom, dtpDateFrom, lblDateTo, dtpDateTo, btnRefresh, btnExport, btnPrint, lblTotalPurchases, lblTotalPayments, lblBalance, lblOpeningBalance})

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

    Private Sub LoadSuppliers()
        Dim cboSupplier = CType(Me.Controls.Find("cboSupplier", True).FirstOrDefault(), ComboBox)
        If cboSupplier Is Nothing Then Return

        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Dim query As String = "SELECT SupplierID, CompanyName FROM Suppliers WHERE IsActive = 1 ORDER BY CompanyName"
                Using cmd As New SqlCommand(query, conn)
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        Dim dt As New DataTable()
                        dt.Load(reader)

                        cboSupplier.DisplayMember = "CompanyName"
                        cboSupplier.ValueMember = "SupplierID"
                        cboSupplier.DataSource = dt
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub cboSupplier_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim cboSupplier = CType(sender, ComboBox)
        If cboSupplier.SelectedValue IsNot Nothing AndAlso IsNumeric(cboSupplier.SelectedValue) Then
            selectedSupplierID = Convert.ToInt32(cboSupplier.SelectedValue)
            LoadSupplierHistory()
        End If
    End Sub

    Private Sub LoadSupplierHistory()
        If selectedSupplierID = 0 Then Return

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
                ' Note: SupplierPayments table not created yet, showing invoice totals only
                Dim openingQuery As String = "
                    SELECT 
                        ISNULL(SUM(TotalAmount), 0) AS OpeningBalance
                    FROM SupplierInvoices 
                    WHERE SupplierID = @SupplierID AND InvoiceDate < @DateFrom"

                Using cmdOpening As New SqlCommand(openingQuery, conn)
                    cmdOpening.Parameters.AddWithValue("@SupplierID", selectedSupplierID)
                    cmdOpening.Parameters.AddWithValue("@DateFrom", dateFrom)
                    Dim result = cmdOpening.ExecuteScalar()
                    openingBalance = If(result IsNot Nothing AndAlso Not IsDBNull(result), CDec(result), 0)
                End Using

                ' Get all transactions within date range (ordered oldest to newest)
                ' Note: SupplierPayments table not created yet, showing invoices only
                Dim query As String = "
                    SELECT 
                        'Invoice' AS TransactionType,
                        si.InvoiceID AS TransactionID,
                        si.InvoiceNumber AS Reference,
                        si.InvoiceDate AS TransactionDate,
                        si.DueDate AS DueDate,
                        'Invoice' AS Category,
                        ISNULL(si.Reference, ISNULL(si.Notes, '')) AS Description,
                        si.TotalAmount AS Debit,
                        0.00 AS Credit,
                        si.TotalAmount AS Balance,
                        si.Status
                    FROM SupplierInvoices si
                    WHERE si.SupplierID = @SupplierID
                      AND si.InvoiceDate >= @DateFrom
                      AND si.InvoiceDate <= @DateTo
                    ORDER BY si.InvoiceDate ASC"

                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@SupplierID", selectedSupplierID)
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
                            dgvHistory.Columns("TransactionType").Width = 120
                            dgvHistory.Columns("Reference").Width = 120
                            dgvHistory.Columns("TransactionDate").Width = 100
                            dgvHistory.Columns("TransactionDate").DefaultCellStyle.Format = "yyyy-MM-dd"
                            dgvHistory.Columns("DueDate").Width = 100
                            dgvHistory.Columns("DueDate").DefaultCellStyle.Format = "yyyy-MM-dd"
                            dgvHistory.Columns("Category").Width = 100
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
                                If row.Cells("TransactionType").Value.ToString() = "Purchase Order" Then
                                    row.DefaultCellStyle.BackColor = Color.FromArgb(255, 240, 240)
                                Else
                                    row.DefaultCellStyle.BackColor = Color.FromArgb(240, 255, 240)
                                End If

                                ' Highlight pending/overdue orders
                                If row.Cells("Status").Value.ToString() = "Pending" OrElse row.Cells("Status").Value.ToString() = "Overdue" Then
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
        Dim totalPurchases As Decimal = 0
        Dim totalPayments As Decimal = 0

        For Each row As DataRow In dt.Rows
            totalPurchases += CDec(row("Debit"))
            totalPayments += CDec(row("Credit"))
        Next

        Dim balance As Decimal = totalPurchases - totalPayments

        Dim lblTotalPurchases = CType(Me.Controls.Find("lblTotalPurchases", True).FirstOrDefault(), Label)
        Dim lblTotalPayments = CType(Me.Controls.Find("lblTotalPayments", True).FirstOrDefault(), Label)
        Dim lblBalance = CType(Me.Controls.Find("lblBalance", True).FirstOrDefault(), Label)

        If lblTotalPurchases IsNot Nothing Then lblTotalPurchases.Text = $"Total Purchases: R{totalPurchases:N2}"
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
                            si.InvoiceNumber,
                            si.InvoiceDate,
                            si.DueDate,
                            s.CompanyName AS SupplierName,
                            s.ContactPerson,
                            s.Phone,
                            si.Reference,
                            si.SubTotal,
                            si.VATAmount,
                            si.TotalAmount,
                            si.AmountPaid,
                            si.AmountOutstanding,
                            si.Status,
                            si.CreatedBy,
                            si.CreatedDate,
                            (SELECT COUNT(*) FROM SupplierInvoiceLines WHERE InvoiceID = si.InvoiceID) AS ItemCount
                        FROM SupplierInvoices si
                        INNER JOIN Suppliers s ON si.SupplierID = s.SupplierID
                        WHERE si.InvoiceID = @ID"

                    Using cmd As New SqlCommand(query, conn)
                        cmd.Parameters.AddWithValue("@ID", transactionID)
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            If reader.Read() Then
                                Dim dueDate As String = If(IsDBNull(reader("DueDate")), "N/A", CDate(reader("DueDate")).ToString("yyyy-MM-dd"))
                                details = $"SUPPLIER INVOICE DETAILS{vbCrLf}{vbCrLf}" &
                                         $"Invoice Number: {reader("InvoiceNumber")}{vbCrLf}" &
                                         $"Supplier: {reader("SupplierName")}{vbCrLf}" &
                                         $"Contact: {reader("ContactPerson")} - {reader("Phone")}{vbCrLf}" &
                                         $"Invoice Date: {CDate(reader("InvoiceDate")):yyyy-MM-dd}{vbCrLf}" &
                                         $"Due Date: {dueDate}{vbCrLf}" &
                                         $"Status: {reader("Status")}{vbCrLf}{vbCrLf}" &
                                         $"SubTotal: R{CDec(reader("SubTotal")):N2}{vbCrLf}" &
                                         $"VAT: R{CDec(reader("VATAmount")):N2}{vbCrLf}" &
                                         $"Total Amount: R{CDec(reader("TotalAmount")):N2}{vbCrLf}" &
                                         $"Amount Paid: R{CDec(reader("AmountPaid")):N2}{vbCrLf}" &
                                         $"Amount Outstanding: R{CDec(reader("AmountOutstanding")):N2}{vbCrLf}{vbCrLf}" &
                                         $"Total Items: {reader("ItemCount")}{vbCrLf}" &
                                         $"Reference: {reader("Reference")}{vbCrLf}{vbCrLf}" &
                                         $"Created By: {reader("CreatedBy")}{vbCrLf}" &
                                         $"Created Date: {CDate(reader("CreatedDate")):yyyy-MM-dd HH:mm}"
                            End If
                        End Using
                    End Using

                ElseIf transactionType = "Payment" Then
                    Dim query As String = "
                        SELECT 
                            sp.PaymentNumber,
                            sp.PaymentDate,
                            s.CompanyName AS SupplierName,
                            sp.Amount,
                            sp.PaymentMethod,
                            sp.Notes,
                            sp.CreatedBy,
                            sp.CreatedDate
                        FROM SupplierPayments sp
                        INNER JOIN Suppliers s ON sp.SupplierID = s.SupplierID
                        WHERE sp.PaymentID = @ID"

                    Using cmd As New SqlCommand(query, conn)
                        cmd.Parameters.AddWithValue("@ID", transactionID)
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            If reader.Read() Then
                                details = $"PAYMENT DETAILS{vbCrLf}{vbCrLf}" &
                                         $"Payment Number: {reader("PaymentNumber")}{vbCrLf}" &
                                         $"Supplier: {reader("SupplierName")}{vbCrLf}" &
                                         $"Payment Date: {CDate(reader("PaymentDate")):yyyy-MM-dd}{vbCrLf}" &
                                         $"Payment Method: {reader("PaymentMethod")}{vbCrLf}{vbCrLf}" &
                                         $"Amount: R{CDec(reader("Amount")):N2}{vbCrLf}{vbCrLf}" &
                                         $"Notes: {reader("Notes")}{vbCrLf}{vbCrLf}" &
                                         $"Created By: {reader("CreatedBy")}{vbCrLf}" &
                                         $"Created Date: {CDate(reader("CreatedDate")):yyyy-MM-dd HH:mm}"
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
        LoadSupplierHistory()
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs)
        Try
            Dim dgvHistory = CType(Me.Controls.Find("dgvHistory", True).FirstOrDefault(), DataGridView)
            If dgvHistory Is Nothing OrElse dgvHistory.Rows.Count = 0 Then
                MessageBox.Show("No data to export", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim cboSupplier = CType(Me.Controls.Find("cboSupplier", True).FirstOrDefault(), ComboBox)
            Dim supplierName As String = If(cboSupplier IsNot Nothing, cboSupplier.Text.Replace(" ", "_"), "Unknown")
            Dim fileName As String = $"SupplierHistory_{supplierName}_{DateTime.Now:yyyyMMdd_HHmmss}.csv"
            
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

            Dim cboSupplier = CType(Me.Controls.Find("cboSupplier", True).FirstOrDefault(), ComboBox)
            Dim supplierName As String = If(cboSupplier IsNot Nothing, cboSupplier.Text, "Unknown")

            Dim printDoc As New Printing.PrintDocument()
            AddHandler printDoc.PrintPage, Sub(s, ev)
                Dim font As New Font("Arial", 10)
                Dim headerFont As New Font("Arial", 12, FontStyle.Bold)
                Dim y As Integer = 50

                ' Print header
                ev.Graphics.DrawString($"Supplier Payment History - {supplierName}", headerFont, Brushes.Black, 50, y)
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
