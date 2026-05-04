Imports System.Windows.Forms
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class SupplierInvoiceReportForm
    Inherits Form

    Private pnlFilters As Panel
    Private lblSupplier As Label
    Private cboSupplier As ComboBox
    Private lblFromDate As Label
    Private dtpFromDate As DateTimePicker
    Private lblToDate As Label
    Private dtpToDate As DateTimePicker
    Private btnGenerate As Button
    Private btnPrint As Button
    Private btnExport As Button
    Private btnClose As Button
    Private dgvReport As DataGridView
    Private lblStatus As Label

    Public Sub New()
        InitializeComponent()
        Me.Text = "Supplier Invoice Report"
        Me.WindowState = FormWindowState.Maximized
        LoadSuppliers()
    End Sub

    Private Sub InitializeComponent()
        ' Filters panel
        pnlFilters = New Panel() With {.Dock = DockStyle.Top, .Height = 80, .Padding = New Padding(8)}
        
        lblSupplier = New Label() With {.Text = "Supplier:", .AutoSize = True, .Left = 8, .Top = 12}
        cboSupplier = New ComboBox() With {.Left = 80, .Top = 8, .Width = 250, .DropDownStyle = ComboBoxStyle.DropDown}
        
        lblFromDate = New Label() With {.Text = "From Date:", .AutoSize = True, .Left = 350, .Top = 12}
        dtpFromDate = New DateTimePicker() With {.Left = 430, .Top = 8, .Width = 150, .Format = DateTimePickerFormat.Custom, .CustomFormat = "dd MMM yyyy"}
        
        lblToDate = New Label() With {.Text = "To Date:", .AutoSize = True, .Left = 600, .Top = 12}
        dtpToDate = New DateTimePicker() With {.Left = 670, .Top = 8, .Width = 150, .Format = DateTimePickerFormat.Custom, .CustomFormat = "dd MMM yyyy"}
        
        btnGenerate = New Button() With {.Left = 840, .Top = 8, .Width = 100, .Text = "Generate", .Height = 28}
        btnPrint = New Button() With {.Left = 950, .Top = 8, .Width = 80, .Text = "Print", .Height = 28, .Enabled = False}
        btnExport = New Button() With {.Left = 1040, .Top = 8, .Width = 100, .Text = "Export Excel", .Height = 28, .Enabled = False}
        btnClose = New Button() With {.Left = 1150, .Top = 8, .Width = 80, .Text = "Close", .Height = 28}
        
        AddHandler btnGenerate.Click, AddressOf btnGenerate_Click
        AddHandler btnPrint.Click, AddressOf btnPrint_Click
        AddHandler btnExport.Click, AddressOf btnExport_Click
        AddHandler btnClose.Click, Sub() Me.Close()
        
        pnlFilters.Controls.AddRange(New Control() {lblSupplier, cboSupplier, lblFromDate, dtpFromDate, lblToDate, dtpToDate, btnGenerate, btnPrint, btnExport, btnClose})
        
        ' Status label
        lblStatus = New Label() With {.Dock = DockStyle.Bottom, .Height = 30, .Padding = New Padding(8), .Text = "Select filters and click Generate to view report"}
        
        ' Report grid
        dgvReport = New DataGridView() With {
            .Dock = DockStyle.Fill,
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .RowHeadersVisible = False
        }
        
        ' Form layout
        Me.Controls.AddRange(New Control() {dgvReport, pnlFilters, lblStatus})
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        
        ' Set default date range (last 30 days)
        dtpToDate.Value = DateTime.Now.Date
        dtpFromDate.Value = DateTime.Now.Date.AddDays(-30)
    End Sub

    Private Sub LoadSuppliers()
        Try
            Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Using con As New SqlConnection(cs)
                con.Open()
                Dim sql = "SELECT 0 AS SupplierID, '-- All Suppliers --' AS CompanyName " &
                         "UNION ALL " &
                         "SELECT SupplierID, CompanyName FROM Suppliers WHERE IsActive = 1 " &
                         "ORDER BY SupplierID"
                Using cmd As New SqlCommand(sql, con)
                    Dim dt As New DataTable()
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                    cboSupplier.DisplayMember = "CompanyName"
                    cboSupplier.ValueMember = "SupplierID"
                    cboSupplier.DataSource = dt
                    cboSupplier.SelectedIndex = 0
                    
                    ' Setup autocomplete like PO form
                    If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                        Dim ac As New AutoCompleteStringCollection()
                        For Each r As DataRow In dt.Rows
                            ac.Add(r("CompanyName").ToString())
                        Next
                        cboSupplier.AutoCompleteMode = AutoCompleteMode.SuggestAppend
                        cboSupplier.AutoCompleteSource = AutoCompleteSource.CustomSource
                        cboSupplier.AutoCompleteCustomSource = ac
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim supplierId As Integer = 0
            If cboSupplier.SelectedValue IsNot Nothing Then
                Integer.TryParse(cboSupplier.SelectedValue.ToString(), supplierId)
            End If
            
            Dim fromDate As Date = dtpFromDate.Value.Date
            Dim toDate As Date = dtpToDate.Value.Date
            
            If toDate < fromDate Then
                MessageBox.Show("To Date must be greater than or equal to From Date.", "Invalid Date Range", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            lblStatus.Text = "Generating report..."
            Application.DoEvents()
            
            Dim cs = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Dim dt As New DataTable()
            
            Using con As New SqlConnection(cs)
                con.Open()
                
                Dim sql As String = "
                    SELECT 
                        s.CompanyName AS [Supplier Name],
                        si.InvoiceNumber AS [Invoice Number],
                        si.InvoiceDate AS [Invoice Date],
                        si.DueDate AS [Due Date],
                        si.SubTotal AS [Sub Total],
                        si.VATAmount AS [VAT Amount],
                        si.TotalAmount AS [Total Amount],
                        si.AmountPaid AS [Amount Paid],
                        si.AmountOutstanding AS [Amount Outstanding],
                        si.Status,
                        CONVERT(DATE, si.CreatedDate) AS [Captured Date],
                        CASE 
                            WHEN si.Status = 'Paid' OR si.Status = 'Partial' THEN 
                                (SELECT TOP 1 CONVERT(DATE, sp.PaymentDate) 
                                 FROM SupplierPaymentAllocations spa
                                 INNER JOIN SupplierPayments sp ON sp.PaymentID = spa.PaymentID
                                 WHERE spa.InvoiceID = si.InvoiceID 
                                 ORDER BY sp.PaymentDate DESC)
                            ELSE NULL 
                        END AS [Payment Date],
                        b.BranchName AS [Branch]
                    FROM SupplierInvoices si
                    INNER JOIN Suppliers s ON s.SupplierID = si.SupplierID
                    LEFT JOIN Branches b ON b.BranchID = si.BranchID
                    WHERE (@SupplierID = 0 OR si.SupplierID = @SupplierID)
                      AND si.InvoiceDate >= @FromDate
                      AND si.InvoiceDate <= @ToDate
                    ORDER BY si.InvoiceDate DESC, s.CompanyName, si.InvoiceNumber"
                
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@SupplierID", supplierId)
                    cmd.Parameters.AddWithValue("@FromDate", fromDate)
                    cmd.Parameters.AddWithValue("@ToDate", toDate)
                    
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
            
            dgvReport.DataSource = dt
            
            ' Format columns
            If dgvReport.Columns.Contains("Invoice Date") Then
                dgvReport.Columns("Invoice Date").DefaultCellStyle.Format = "dd MMM yyyy"
                dgvReport.Columns("Invoice Date").Width = 100
            End If
            
            If dgvReport.Columns.Contains("Due Date") Then
                dgvReport.Columns("Due Date").DefaultCellStyle.Format = "dd MMM yyyy"
                dgvReport.Columns("Due Date").Width = 100
            End If
            
            If dgvReport.Columns.Contains("Captured Date") Then
                dgvReport.Columns("Captured Date").DefaultCellStyle.Format = "dd MMM yyyy"
                dgvReport.Columns("Captured Date").Width = 100
            End If
            
            If dgvReport.Columns.Contains("Payment Date") Then
                dgvReport.Columns("Payment Date").DefaultCellStyle.Format = "dd MMM yyyy"
                dgvReport.Columns("Payment Date").Width = 100
            End If
            
            If dgvReport.Columns.Contains("Sub Total") Then
                dgvReport.Columns("Sub Total").DefaultCellStyle.Format = "N2"
                dgvReport.Columns("Sub Total").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgvReport.Columns("Sub Total").Width = 100
            End If
            
            If dgvReport.Columns.Contains("VAT Amount") Then
                dgvReport.Columns("VAT Amount").DefaultCellStyle.Format = "N2"
                dgvReport.Columns("VAT Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgvReport.Columns("VAT Amount").Width = 100
            End If
            
            If dgvReport.Columns.Contains("Total Amount") Then
                dgvReport.Columns("Total Amount").DefaultCellStyle.Format = "N2"
                dgvReport.Columns("Total Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgvReport.Columns("Total Amount").Width = 100
            End If
            
            If dgvReport.Columns.Contains("Amount Paid") Then
                dgvReport.Columns("Amount Paid").DefaultCellStyle.Format = "N2"
                dgvReport.Columns("Amount Paid").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgvReport.Columns("Amount Paid").Width = 100
            End If
            
            If dgvReport.Columns.Contains("Amount Outstanding") Then
                dgvReport.Columns("Amount Outstanding").DefaultCellStyle.Format = "N2"
                dgvReport.Columns("Amount Outstanding").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgvReport.Columns("Amount Outstanding").Width = 120
            End If
            
            If dgvReport.Columns.Contains("Status") Then
                dgvReport.Columns("Status").Width = 80
            End If
            
            If dgvReport.Columns.Contains("Supplier Name") Then
                dgvReport.Columns("Supplier Name").Width = 200
            End If
            
            If dgvReport.Columns.Contains("Invoice Number") Then
                dgvReport.Columns("Invoice Number").Width = 120
            End If
            
            ' Calculate totals
            Dim totalAmount As Decimal = 0
            Dim totalPaid As Decimal = 0
            Dim totalOutstanding As Decimal = 0
            
            For Each row As DataRow In dt.Rows
                If Not IsDBNull(row("Total Amount")) Then totalAmount += CDec(row("Total Amount"))
                If Not IsDBNull(row("Amount Paid")) Then totalPaid += CDec(row("Amount Paid"))
                If Not IsDBNull(row("Amount Outstanding")) Then totalOutstanding += CDec(row("Amount Outstanding"))
            Next
            
            lblStatus.Text = $"Found {dt.Rows.Count} invoice(s) | Total: R{totalAmount:N2} | Paid: R{totalPaid:N2} | Outstanding: R{totalOutstanding:N2}"
            btnPrint.Enabled = dt.Rows.Count > 0
            btnExport.Enabled = dt.Rows.Count > 0
            
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            lblStatus.Text = "Error generating report"
        End Try
    End Sub

    Private Sub btnPrint_Click(sender As Object, e As EventArgs)
        Try
            If dgvReport.Rows.Count = 0 Then
                MessageBox.Show("No data to print.", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim printDoc As New System.Drawing.Printing.PrintDocument()
            Dim currentRow As Integer = 0
            
            AddHandler printDoc.PrintPage, Sub(s, ev)
                Dim font As New Font("Arial", 9)
                Dim fontBold As New Font("Arial", 9, FontStyle.Bold)
                Dim fontTitle As New Font("Arial", 12, FontStyle.Bold)
                Dim y As Single = 50
                Dim lineHeight As Single = 18

                ' Title
                ev.Graphics.DrawString("SUPPLIER INVOICE REPORT", fontTitle, Brushes.Black, 300, y)
                y += 30

                ' Date range
                ev.Graphics.DrawString($"Period: {dtpFromDate.Value:dd MMM yyyy} to {dtpToDate.Value:dd MMM yyyy}", font, Brushes.Black, 50, y)
                y += 20
                
                ' Supplier filter
                If cboSupplier.SelectedIndex > 0 Then
                    ev.Graphics.DrawString($"Supplier: {cboSupplier.Text}", font, Brushes.Black, 50, y)
                    y += 20
                End If
                
                ev.Graphics.DrawString($"Generated: {DateTime.Now:dd MMM yyyy HH:mm}", font, Brushes.Black, 50, y)
                y += 30

                ' Column headers
                ev.Graphics.DrawLine(Pens.Black, 50, y, 750, y)
                y += 5
                ev.Graphics.DrawString("Supplier", fontBold, Brushes.Black, 50, y)
                ev.Graphics.DrawString("Invoice #", fontBold, Brushes.Black, 200, y)
                ev.Graphics.DrawString("Date", fontBold, Brushes.Black, 300, y)
                ev.Graphics.DrawString("Total", fontBold, Brushes.Black, 400, y)
                ev.Graphics.DrawString("Status", fontBold, Brushes.Black, 500, y)
                ev.Graphics.DrawString("Captured", fontBold, Brushes.Black, 600, y)
                ev.Graphics.DrawString("Paid", fontBold, Brushes.Black, 700, y)
                y += lineHeight
                ev.Graphics.DrawLine(Pens.Black, 50, y, 750, y)
                y += 5

                ' Data rows
                Dim maxRows As Integer = CInt((ev.MarginBounds.Bottom - y) / lineHeight) - 2
                Dim rowsPrinted As Integer = 0
                
                While currentRow < dgvReport.Rows.Count AndAlso rowsPrinted < maxRows
                    Dim row = dgvReport.Rows(currentRow)
                    If Not row.IsNewRow Then
                        ' Truncate long supplier names
                        Dim supplier As String = If(row.Cells("Supplier Name").Value, "").ToString()
                        If supplier.Length > 20 Then supplier = supplier.Substring(0, 17) & "..."
                        
                        ev.Graphics.DrawString(supplier, font, Brushes.Black, 50, y)
                        ev.Graphics.DrawString(If(row.Cells("Invoice Number").Value, "").ToString(), font, Brushes.Black, 200, y)
                        
                        If row.Cells("Invoice Date").Value IsNot Nothing Then
                            ev.Graphics.DrawString(CDate(row.Cells("Invoice Date").Value).ToString("dd/MM/yy"), font, Brushes.Black, 300, y)
                        End If
                        
                        If row.Cells("Total Amount").Value IsNot Nothing Then
                            ev.Graphics.DrawString($"R{CDec(row.Cells("Total Amount").Value):N0}", font, Brushes.Black, 400, y)
                        End If
                        
                        ev.Graphics.DrawString(If(row.Cells("Status").Value, "").ToString(), font, Brushes.Black, 500, y)
                        
                        If row.Cells("Captured Date").Value IsNot Nothing Then
                            ev.Graphics.DrawString(CDate(row.Cells("Captured Date").Value).ToString("dd/MM/yy"), font, Brushes.Black, 600, y)
                        End If
                        
                        If row.Cells("Payment Date").Value IsNot Nothing AndAlso Not IsDBNull(row.Cells("Payment Date").Value) Then
                            ev.Graphics.DrawString(CDate(row.Cells("Payment Date").Value).ToString("dd/MM/yy"), font, Brushes.Black, 700, y)
                        End If
                        
                        y += lineHeight
                    End If
                    currentRow += 1
                    rowsPrinted += 1
                End While

                ' Summary at bottom if last page
                If currentRow >= dgvReport.Rows.Count Then
                    y += 10
                    ev.Graphics.DrawLine(Pens.Black, 50, y, 750, y)
                    y += 10
                    ev.Graphics.DrawString(lblStatus.Text, fontBold, Brushes.Black, 50, y)
                End If

                ' More pages?
                ev.HasMorePages = currentRow < dgvReport.Rows.Count
            End Sub

            ' Show print preview
            Dim printPreview As New PrintPreviewDialog()
            printPreview.Document = printDoc
            printPreview.WindowState = FormWindowState.Maximized
            printPreview.ShowDialog()

        Catch ex As Exception
            MessageBox.Show($"Error printing report: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs)
        Try
            If dgvReport.Rows.Count = 0 Then
                MessageBox.Show("No data to export.", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            Dim sfd As New SaveFileDialog With {
                .Filter = "Excel Files|*.xlsx",
                .FileName = $"SupplierInvoiceReport_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
            }
            
            If sfd.ShowDialog() = DialogResult.OK Then
                Using wb As New ClosedXML.Excel.XLWorkbook()
                    Dim ws = wb.Worksheets.Add("Supplier Invoices")
                    
                    ' Title
                    ws.Cell(1, 1).Value = "SUPPLIER INVOICE REPORT"
                    ws.Cell(1, 1).Style.Font.Bold = True
                    ws.Cell(1, 1).Style.Font.FontSize = 14
                    
                    ' Date range
                    ws.Cell(2, 1).Value = $"Period: {dtpFromDate.Value:dd MMM yyyy} to {dtpToDate.Value:dd MMM yyyy}"
                    ws.Cell(3, 1).Value = $"Generated: {DateTime.Now:dd MMM yyyy HH:mm}"
                    
                    ' Headers (row 5)
                    Dim col As Integer = 1
                    For Each column As DataGridViewColumn In dgvReport.Columns
                        ws.Cell(5, col).Value = column.HeaderText
                        ws.Cell(5, col).Style.Font.Bold = True
                        ws.Cell(5, col).Style.Fill.BackgroundColor = ClosedXML.Excel.XLColor.FromArgb(44, 62, 80)
                        ws.Cell(5, col).Style.Font.FontColor = ClosedXML.Excel.XLColor.White
                        col += 1
                    Next
                    
                    ' Data
                    Dim row As Integer = 6
                    For Each dr As DataGridViewRow In dgvReport.Rows
                        If Not dr.IsNewRow Then
                            col = 1
                            For Each column As DataGridViewColumn In dgvReport.Columns
                                Dim cellValue = dr.Cells(column.Index).Value
                                If cellValue IsNot Nothing AndAlso Not IsDBNull(cellValue) Then
                                    ws.Cell(row, col).Value = cellValue.ToString()
                                End If
                                col += 1
                            Next
                            row += 1
                        End If
                    Next
                    
                    ws.Columns().AdjustToContents()
                    wb.SaveAs(sfd.FileName)
                End Using
                
                MessageBox.Show("Report exported successfully!", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Process.Start(New ProcessStartInfo(sfd.FileName) With {.UseShellExecute = True})
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error exporting report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
