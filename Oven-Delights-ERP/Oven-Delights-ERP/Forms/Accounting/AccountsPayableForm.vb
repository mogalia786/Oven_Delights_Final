Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms

Namespace Forms.Accounting
    Public Class AccountsPayableForm
        Inherits Form

        Private dgvPayables As DataGridView
        Private btnAddPayable As Button
        Private btnEditPayable As Button
        Private btnDeletePayable As Button
        Private btnProcessPayment As Button
        Private btnPrint As Button
        Private WithEvents txtSearch As TextBox
        Private lblSearch As Label
        Private _connectionString As String

        Public Sub New()
            InitializeComponent()
            _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            LoadPayables()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Accounts Payable Management"
            Me.Size = New Size(1000, 600)
            Me.WindowState = FormWindowState.Maximized

            ' Search controls
            lblSearch = New Label() With {
                .Text = "Search:",
                .Location = New Point(10, 15),
                .Size = New Size(50, 20)
            }

            txtSearch = New TextBox() With {
                .Location = New Point(70, 12),
                .Size = New Size(200, 25)
            }

            ' Buttons
            btnAddPayable = New Button() With {
                .Text = "Add Payable",
                .Location = New Point(300, 10),
                .Size = New Size(100, 30)
            }
            AddHandler btnAddPayable.Click, AddressOf btnAddPayable_Click

            btnEditPayable = New Button() With {
                .Text = "Edit Payable",
                .Location = New Point(410, 10),
                .Size = New Size(100, 30)
            }
            AddHandler btnEditPayable.Click, AddressOf btnEditPayable_Click

            btnDeletePayable = New Button() With {
                .Text = "Delete Payable",
                .Location = New Point(520, 10),
                .Size = New Size(100, 30)
            }
            AddHandler btnDeletePayable.Click, AddressOf btnDeletePayable_Click

            btnProcessPayment = New Button() With {
                .Text = "Process Payment",
                .Location = New Point(630, 10),
                .Size = New Size(120, 30)
            }
            AddHandler btnProcessPayment.Click, AddressOf btnProcessPayment_Click

            btnPrint = New Button() With {
                .Text = "🖨️ Print Report",
                .Location = New Point(760, 10),
                .Size = New Size(120, 30),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat
            }
            btnPrint.FlatAppearance.BorderSize = 0
            AddHandler btnPrint.Click, AddressOf btnPrint_Click

            ' DataGridView
            dgvPayables = New DataGridView() With {
                .Location = New Point(10, 50),
                .Size = New Size(Me.ClientSize.Width - 20, Me.ClientSize.Height - 60),
                .Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .ReadOnly = True
            }

            ' Add controls to form
            Me.Controls.AddRange({lblSearch, txtSearch, btnAddPayable, btnEditPayable, btnDeletePayable, btnProcessPayment, btnPrint, dgvPayables})
        End Sub

        Private Sub LoadPayables()
            Try
                Using conn As New SqlConnection(_connectionString)
                    Dim sql = "SELECT 
                                ap.PayableID,
                                ap.SupplierName,
                                ap.InvoiceNumber,
                                ap.InvoiceDate,
                                ap.DueDate,
                                ap.Amount,
                                ap.AmountPaid,
                                (ap.Amount - ap.AmountPaid) AS Outstanding,
                                ap.Status,
                                ap.Description
                               FROM AccountsPayable ap
                               ORDER BY ap.DueDate ASC"

                    Using adapter As New SqlDataAdapter(sql, conn)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        dgvPayables.DataSource = dt

                        ' Format columns
                        If dgvPayables.Columns.Contains("Amount") Then
                            dgvPayables.Columns("Amount").DefaultCellStyle.Format = "C2"
                        End If
                        If dgvPayables.Columns.Contains("AmountPaid") Then
                            dgvPayables.Columns("AmountPaid").DefaultCellStyle.Format = "C2"
                        End If
                        If dgvPayables.Columns.Contains("Outstanding") Then
                            dgvPayables.Columns("Outstanding").DefaultCellStyle.Format = "C2"
                        End If
                        If dgvPayables.Columns.Contains("InvoiceDate") Then
                            dgvPayables.Columns("InvoiceDate").DefaultCellStyle.Format = "d"
                        End If
                        If dgvPayables.Columns.Contains("DueDate") Then
                            dgvPayables.Columns("DueDate").DefaultCellStyle.Format = "d"
                        End If
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading payables: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub txtSearch_TextChanged(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtSearch.Text) Then
                LoadPayables()
                Return
            End If

            Try
                Using conn As New SqlConnection(_connectionString)
                    Dim sql = "SELECT 
                                ap.PayableID,
                                ap.SupplierName,
                                ap.InvoiceNumber,
                                ap.InvoiceDate,
                                ap.DueDate,
                                ap.Amount,
                                ap.AmountPaid,
                                (ap.Amount - ap.AmountPaid) AS Outstanding,
                                ap.Status,
                                ap.Description
                               FROM AccountsPayable ap
                               WHERE ap.SupplierName LIKE @search 
                                  OR ap.InvoiceNumber LIKE @search
                                  OR ap.Description LIKE @search
                               ORDER BY ap.DueDate ASC"

                    Using adapter As New SqlDataAdapter(sql, conn)
                        adapter.SelectCommand.Parameters.AddWithValue("@search", "%" & txtSearch.Text & "%")
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        dgvPayables.DataSource = dt
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Error searching payables: " & ex.Message, "Search Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnAddPayable_Click(sender As Object, e As EventArgs)
            Try
                Dim frm As New TestInvoiceForm()
                frm.MdiParent = Me.MdiParent
                frm.Show()
                frm.WindowState = FormWindowState.Maximized
                frm.BringToFront()
            Catch ex As Exception
                MessageBox.Show($"Error opening invoice form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnEditPayable_Click(sender As Object, e As EventArgs)
            If dgvPayables.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a payable to edit.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Dim invoiceId As Integer = Convert.ToInt32(dgvPayables.SelectedRows(0).Cells("PayableID").Value)
                Dim frm As New AccountsPayableInvoiceForm(currentUser, invoiceId)
                frm.Show()
                frm.BringToFront()
            Catch ex As Exception
                MessageBox.Show($"Error opening invoice form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnDeletePayable_Click(sender As Object, e As EventArgs)
            If dgvPayables.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a payable to delete.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Dim invoiceNumber As String = dgvPayables.SelectedRows(0).Cells("InvoiceNumber").Value.ToString()
                Dim result As DialogResult = MessageBox.Show($"Are you sure you want to delete invoice {invoiceNumber}?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
                
                If result = DialogResult.Yes Then
                    Dim invoiceId As Integer = Convert.ToInt32(dgvPayables.SelectedRows(0).Cells("InvoiceID").Value)
                    DeleteInvoice(invoiceId)
                End If
            Catch ex As Exception
                MessageBox.Show($"Error deleting invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnProcessPayment_Click(sender As Object, e As EventArgs)
            If dgvPayables.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a payable to process payment for.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            MessageBox.Show("Process Payment functionality to be implemented.", "Feature", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub DeleteInvoice(invoiceId As Integer)
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    Dim cmd As New SqlCommand("DELETE FROM APInvoices WHERE InvoiceID = @InvoiceID", conn)
                    cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                    cmd.ExecuteNonQuery()
                    ' ' LoadInvoices()
                    MessageBox.Show("Invoice deleted successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error deleting invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub MarkInvoiceAsPaid(invoiceId As Integer)
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    Dim cmd As New SqlCommand("UPDATE APInvoices SET IsPaid = 1, PaidDate = @PaidDate WHERE InvoiceID = @InvoiceID", conn)
                    cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                    cmd.Parameters.AddWithValue("@PaidDate", DateTime.Today)
                    cmd.ExecuteNonQuery()
                End Using
            Catch ex As Exception
                Throw New Exception($"Failed to mark invoice as paid: {ex.Message}")
            End Try
        End Sub

        Private Sub btnPrint_Click(sender As Object, e As EventArgs)
            Try
                Dim printDoc As New System.Drawing.Printing.PrintDocument()
                AddHandler printDoc.PrintPage, AddressOf PrintPayablesReport
                
                Dim printDialog As New PrintDialog()
                printDialog.Document = printDoc
                
                If printDialog.ShowDialog() = DialogResult.OK Then
                    printDoc.Print()
                    MessageBox.Show("Accounts Payable Report printed successfully!", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            Catch ex As Exception
                MessageBox.Show($"Error printing report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub PrintPayablesReport(sender As Object, e As System.Drawing.Printing.PrintPageEventArgs)
            Try
                Dim titleFont As New Font("Arial", 20, FontStyle.Bold)
                Dim headerFont As New Font("Arial", 14, FontStyle.Bold)
                Dim normalFont As New Font("Arial", 9)
                Dim boldFont As New Font("Arial", 9, FontStyle.Bold)
                Dim smallFont As New Font("Arial", 8)
                
                Dim yPos As Single = 50
                Dim leftMargin As Single = 50
                Dim rightMargin As Single = e.PageBounds.Width - 50
                
                ' Company Header
                e.Graphics.DrawString("OVEN DELIGHTS (PTY) LTD", titleFont, Brushes.Black, leftMargin, yPos)
                yPos += 30
                e.Graphics.DrawString("ACCOUNTS PAYABLE REPORT", headerFont, Brushes.Black, leftMargin, yPos)
                yPos += 25
                e.Graphics.DrawString($"Generated: {DateTime.Now:dd MMM yyyy HH:mm:ss}", smallFont, Brushes.Gray, leftMargin, yPos)
                yPos += 30
                
                e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
                yPos += 20
                
                ' Calculate totals
                Dim totalAmount As Decimal = 0
                Dim totalPaid As Decimal = 0
                Dim totalOutstanding As Decimal = 0
                Dim overdueCount As Integer = 0
                
                For Each row As DataGridViewRow In dgvPayables.Rows
                    If Not row.IsNewRow Then
                        If row.Cells("Amount").Value IsNot Nothing Then
                            totalAmount += Convert.ToDecimal(row.Cells("Amount").Value)
                        End If
                        If row.Cells("AmountPaid").Value IsNot Nothing Then
                            totalPaid += Convert.ToDecimal(row.Cells("AmountPaid").Value)
                        End If
                        If row.Cells("Outstanding").Value IsNot Nothing Then
                            totalOutstanding += Convert.ToDecimal(row.Cells("Outstanding").Value)
                        End If
                        
                        ' Check if overdue
                        If row.Cells("DueDate").Value IsNot Nothing AndAlso row.Cells("Status").Value IsNot Nothing Then
                            Dim dueDate As DateTime = Convert.ToDateTime(row.Cells("DueDate").Value)
                            Dim status As String = row.Cells("Status").Value.ToString()
                            If dueDate < DateTime.Today AndAlso status <> "Paid" Then
                                overdueCount += 1
                            End If
                        End If
                    End If
                Next
                
                ' Summary Section
                e.Graphics.DrawString("SUMMARY", headerFont, Brushes.Black, leftMargin, yPos)
                yPos += 30
                
                e.Graphics.DrawString("Total Invoices:", boldFont, Brushes.Black, leftMargin, yPos)
                e.Graphics.DrawString(dgvPayables.Rows.Count.ToString(), normalFont, Brushes.Black, leftMargin + 200, yPos)
                yPos += 20
                
                e.Graphics.DrawString("Total Amount:", boldFont, Brushes.Black, leftMargin, yPos)
                e.Graphics.DrawString($"R {totalAmount:N2}", normalFont, Brushes.Black, leftMargin + 200, yPos)
                yPos += 20
                
                e.Graphics.DrawString("Total Paid:", boldFont, Brushes.Black, leftMargin, yPos)
                e.Graphics.DrawString($"R {totalPaid:N2}", normalFont, Brushes.Black, leftMargin + 200, yPos)
                yPos += 20
                
                e.Graphics.DrawString("Total Outstanding:", boldFont, Brushes.Black, leftMargin, yPos)
                e.Graphics.DrawString($"R {totalOutstanding:N2}", normalFont, New SolidBrush(Color.Red), leftMargin + 200, yPos)
                yPos += 20
                
                e.Graphics.DrawString("Overdue Invoices:", boldFont, Brushes.Black, leftMargin, yPos)
                e.Graphics.DrawString(overdueCount.ToString(), normalFont, New SolidBrush(If(overdueCount > 0, Color.Red, Color.Green)), leftMargin + 200, yPos)
                yPos += 35
                
                e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
                yPos += 20
                
                ' Expense Category Breakdown
                e.Graphics.DrawString("EXPENSE BREAKDOWN BY CATEGORY", headerFont, Brushes.Black, leftMargin, yPos)
                yPos += 30
                
                ' Get category breakdown from database
                Try
                    Using conn As New SqlConnection(_connectionString)
                        conn.Open()
                        Dim sql = "SELECT 
                                    ISNULL(c.CategoryName, 'Uncategorized') AS Category,
                                    COUNT(ap.InvoiceID) AS InvoiceCount,
                                    SUM(ap.Amount) AS TotalAmount,
                                    SUM(ap.Amount - ap.AmountPaid) AS Outstanding
                                   FROM AP_Invoices ap
                                   LEFT JOIN AP_Categories c ON ap.CategoryID = c.CategoryID
                                   WHERE ap.Status <> 'Cancelled'
                                   GROUP BY c.CategoryName
                                   ORDER BY SUM(ap.Amount) DESC"
                        
                        Using cmd As New SqlCommand(sql, conn)
                            Using reader = cmd.ExecuteReader()
                                ' Category headers
                                e.Graphics.DrawString("Category", boldFont, Brushes.Black, leftMargin, yPos)
                                e.Graphics.DrawString("Count", boldFont, Brushes.Black, leftMargin + 250, yPos)
                                e.Graphics.DrawString("Total", boldFont, Brushes.Black, leftMargin + 320, yPos)
                                e.Graphics.DrawString("Outstanding", boldFont, Brushes.Black, leftMargin + 420, yPos)
                                yPos += 20
                                
                                e.Graphics.DrawLine(Pens.Gray, leftMargin, yPos, rightMargin, yPos)
                                yPos += 10
                                
                                Dim categoryCount As Integer = 0
                                While reader.Read() AndAlso categoryCount < 20 AndAlso yPos < e.PageBounds.Height - 150
                                    Dim category As String = reader("Category").ToString()
                                    Dim count As Integer = Convert.ToInt32(reader("InvoiceCount"))
                                    Dim amount As Decimal = Convert.ToDecimal(reader("TotalAmount"))
                                    Dim outstanding As Decimal = Convert.ToDecimal(reader("Outstanding"))
                                    
                                    If category.Length > 30 Then category = category.Substring(0, 27) & "..."
                                    
                                    e.Graphics.DrawString(category, normalFont, Brushes.Black, leftMargin, yPos)
                                    e.Graphics.DrawString(count.ToString(), normalFont, Brushes.Black, leftMargin + 250, yPos)
                                    e.Graphics.DrawString($"R {amount:N2}", normalFont, Brushes.Black, leftMargin + 320, yPos)
                                    e.Graphics.DrawString($"R {outstanding:N2}", normalFont, Brushes.Black, leftMargin + 420, yPos)
                                    yPos += 18
                                    categoryCount += 1
                                End While
                            End Using
                        End Using
                    End Using
                Catch ex As Exception
                    ' If category breakdown fails, skip it
                    e.Graphics.DrawString("Category breakdown not available", smallFont, Brushes.Gray, leftMargin, yPos)
                    yPos += 20
                End Try
                
                yPos += 20
                e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
                yPos += 20
                
                ' Invoice Details
                e.Graphics.DrawString("INVOICE DETAILS", headerFont, Brushes.Black, leftMargin, yPos)
                yPos += 30
                
                ' Invoice headers
                e.Graphics.DrawString("Supplier", boldFont, Brushes.Black, leftMargin, yPos)
                e.Graphics.DrawString("Invoice #", boldFont, Brushes.Black, leftMargin + 150, yPos)
                e.Graphics.DrawString("Due Date", boldFont, Brushes.Black, leftMargin + 250, yPos)
                e.Graphics.DrawString("Amount", boldFont, Brushes.Black, leftMargin + 340, yPos)
                e.Graphics.DrawString("Outstanding", boldFont, Brushes.Black, leftMargin + 430, yPos)
                e.Graphics.DrawString("Status", boldFont, Brushes.Black, leftMargin + 540, yPos)
                yPos += 20
                
                e.Graphics.DrawLine(Pens.Gray, leftMargin, yPos, rightMargin, yPos)
                yPos += 10
                
                ' Print invoices (up to what fits on page)
                Dim invoiceCount As Integer = 0
                For Each row As DataGridViewRow In dgvPayables.Rows
                    If yPos > e.PageBounds.Height - 100 Then Exit For
                    If row.IsNewRow Then Continue For
                    
                    Dim supplier As String = If(row.Cells("SupplierName").Value, "").ToString()
                    Dim invoiceNum As String = If(row.Cells("InvoiceNumber").Value, "").ToString()
                    Dim dueDate As String = ""
                    If row.Cells("DueDate").Value IsNot Nothing Then
                        dueDate = Convert.ToDateTime(row.Cells("DueDate").Value).ToString("dd/MM/yyyy")
                    End If
                    Dim amount As String = If(row.Cells("Amount").Value IsNot Nothing, $"R {Convert.ToDecimal(row.Cells("Amount").Value):N2}", "R 0.00")
                    Dim outstanding As String = If(row.Cells("Outstanding").Value IsNot Nothing, $"R {Convert.ToDecimal(row.Cells("Outstanding").Value):N2}", "R 0.00")
                    Dim status As String = If(row.Cells("Status").Value, "").ToString()
                    
                    If supplier.Length > 18 Then supplier = supplier.Substring(0, 15) & "..."
                    
                    ' Highlight overdue invoices
                    Dim textBrush As Brush = Brushes.Black
                    If row.Cells("DueDate").Value IsNot Nothing AndAlso status <> "Paid" Then
                        If Convert.ToDateTime(row.Cells("DueDate").Value) < DateTime.Today Then
                            textBrush = Brushes.Red
                        End If
                    End If
                    
                    e.Graphics.DrawString(supplier, normalFont, textBrush, leftMargin, yPos)
                    e.Graphics.DrawString(invoiceNum, normalFont, textBrush, leftMargin + 150, yPos)
                    e.Graphics.DrawString(dueDate, normalFont, textBrush, leftMargin + 250, yPos)
                    e.Graphics.DrawString(amount, normalFont, textBrush, leftMargin + 340, yPos)
                    e.Graphics.DrawString(outstanding, normalFont, textBrush, leftMargin + 430, yPos)
                    e.Graphics.DrawString(status, normalFont, textBrush, leftMargin + 540, yPos)
                    yPos += 18
                    invoiceCount += 1
                Next
                
                ' Footer
                yPos = e.PageBounds.Height - 50
                e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
                yPos += 10
                e.Graphics.DrawString($"Printed: {DateTime.Now:dd MMM yyyy HH:mm}", smallFont, Brushes.Gray, leftMargin, yPos)
                e.Graphics.DrawString($"Showing {invoiceCount} of {dgvPayables.Rows.Count} invoices", smallFont, Brushes.Gray, rightMargin - 200, yPos)
                
            Catch ex As Exception
                MessageBox.Show($"Error rendering print page: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
