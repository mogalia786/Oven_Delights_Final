Imports System.Windows.Forms
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Drawing.Printing

Public Class EditSupplierInvoiceForm
    Inherits Form
    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private currentInvoiceId As Integer = 0
    Private currentPurchaseOrderId As Integer = 0
    Private currentSupplierId As Integer = 0
    Private printDocument As New PrintDocument()
    Private printFont As Font
    Private printY As Integer = 0
    Private printPageNumber As Integer = 0
    
    Public Sub New()
        InitializeComponent()
        Me.Text = "Edit Supplier Invoice"
        Me.WindowState = FormWindowState.Maximized
        AddHandler printDocument.PrintPage, AddressOf PrintDocument_PrintPage
    End Sub
    
    Private Sub InitializeComponent()
        ' Main panels
        Dim pnlSearch As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .Padding = New Padding(10)
        }
        
        Dim pnlInvoice As New Panel With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(10)
        }
        
        Dim pnlButtons As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 60,
            .Padding = New Padding(10)
        }
        
        ' Search controls
        Dim lblSupplier As New Label With {
            .Text = "Supplier:",
            .Location = New Point(10, 15),
            .AutoSize = True
        }
        
        Dim cboSupplier As New ComboBox With {
            .Name = "cboSupplier",
            .Location = New Point(80, 12),
            .Width = 250,
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Font = New Font("Segoe UI", 10)
        }
        
        ' Load suppliers
        Try
            Using con As New SqlConnection(connectionString)
                con.Open()
                Dim sql = "SELECT SupplierID, CompanyName FROM Suppliers ORDER BY CompanyName"
                Using cmd As New SqlCommand(sql, con)
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                    cboSupplier.DataSource = dt
                    cboSupplier.DisplayMember = "CompanyName"
                    cboSupplier.ValueMember = "SupplierID"
                    cboSupplier.SelectedIndex = -1
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
        
        Dim lblInvoiceNumber As New Label With {
            .Text = "Invoice Number:",
            .Location = New Point(350, 15),
            .AutoSize = True
        }
        
        Dim txtInvoiceNumber As New TextBox With {
            .Name = "txtInvoiceNumber",
            .Location = New Point(470, 12),
            .Width = 200,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        
        Dim btnSearch As New Button With {
            .Name = "btnSearch",
            .Text = "Search",
            .Location = New Point(680, 10),
            .Width = 100,
            .Height = 30
        }
        AddHandler btnSearch.Click, AddressOf btnSearch_Click
        
        Dim lblStatus As New Label With {
            .Name = "lblStatus",
            .Location = New Point(800, 15),
            .AutoSize = True,
            .ForeColor = Color.Blue,
            .Font = New Font("Segoe UI", 9, FontStyle.Italic)
        }
        
        pnlSearch.Controls.AddRange({lblSupplier, cboSupplier, lblInvoiceNumber, txtInvoiceNumber, btnSearch, lblStatus})
        
        ' Invoice header group
        Dim grpHeader As New GroupBox With {
            .Text = "Invoice Details",
            .Dock = DockStyle.Top,
            .Height = 180,
            .Padding = New Padding(10)
        }
        
        ' Header fields
        Dim lblSupplierHeader As New Label With {.Text = "Supplier:", .Location = New Point(20, 30), .AutoSize = True}
        Dim txtSupplier As New TextBox With {.Name = "txtSupplier", .Location = New Point(120, 27), .Width = 300, .ReadOnly = True}
        
        Dim lblInvoiceDate As New Label With {.Text = "Invoice Date:", .Location = New Point(20, 60), .AutoSize = True}
        Dim dtpInvoiceDate As New DateTimePicker With {.Name = "dtpInvoiceDate", .Location = New Point(120, 57), .Width = 150}
        
        Dim lblDueDate As New Label With {.Text = "Due Date:", .Location = New Point(300, 60), .AutoSize = True}
        Dim dtpDueDate As New DateTimePicker With {.Name = "dtpDueDate", .Location = New Point(380, 57), .Width = 150}
        
        Dim lblBranch As New Label With {.Text = "Branch:", .Location = New Point(20, 90), .AutoSize = True}
        Dim txtBranch As New TextBox With {.Name = "txtBranch", .Location = New Point(120, 87), .Width = 200, .ReadOnly = True}
        
        Dim lblStatus2 As New Label With {.Text = "Status:", .Location = New Point(350, 90), .AutoSize = True}
        Dim txtStatus As New TextBox With {.Name = "txtStatus", .Location = New Point(410, 87), .Width = 120, .ReadOnly = True}
        
        Dim lblPONumber As New Label With {.Text = "PO Number:", .Location = New Point(550, 90), .AutoSize = True}
        Dim txtPONumber As New TextBox With {.Name = "txtPONumber", .Location = New Point(640, 87), .Width = 150, .ReadOnly = True}
        
        Dim lblSubTotal As New Label With {.Text = "Sub Total:", .Location = New Point(20, 120), .AutoSize = True}
        Dim txtSubTotal As New TextBox With {.Name = "txtSubTotal", .Location = New Point(120, 117), .Width = 120, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right}
        
        Dim lblVAT As New Label With {.Text = "VAT:", .Location = New Point(260, 120), .AutoSize = True}
        Dim txtVAT As New TextBox With {.Name = "txtVAT", .Location = New Point(310, 117), .Width = 120, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right}
        
        Dim lblDiscount As New Label With {.Text = "Discount:", .Location = New Point(450, 120), .AutoSize = True}
        Dim txtDiscount As New TextBox With {.Name = "txtDiscount", .Location = New Point(520, 117), .Width = 120, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right}
        
        Dim lblTotal As New Label With {.Text = "Total:", .Location = New Point(660, 120), .AutoSize = True}
        Dim txtTotal As New TextBox With {.Name = "txtTotal", .Location = New Point(710, 117), .Width = 120, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right, .Font = New Font("Segoe UI", 10, FontStyle.Bold)}
        
        Dim lblAmountPaid As New Label With {.Text = "Amount Paid:", .Location = New Point(20, 150), .AutoSize = True}
        Dim txtAmountPaid As New TextBox With {.Name = "txtAmountPaid", .Location = New Point(120, 147), .Width = 120, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right}
        
        Dim lblOutstanding As New Label With {.Text = "Outstanding:", .Location = New Point(260, 150), .AutoSize = True}
        Dim txtOutstanding As New TextBox With {.Name = "txtOutstanding", .Location = New Point(350, 147), .Width = 120, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right, .Font = New Font("Segoe UI", 10, FontStyle.Bold), .ForeColor = Color.Red}
        
        grpHeader.Controls.AddRange({lblSupplierHeader, txtSupplier, lblInvoiceDate, dtpInvoiceDate, lblDueDate, dtpDueDate,
                                     lblBranch, txtBranch, lblStatus2, txtStatus, lblPONumber, txtPONumber,
                                     lblSubTotal, txtSubTotal, lblDiscount, txtDiscount, lblVAT, txtVAT,
                                     lblTotal, txtTotal, lblAmountPaid, txtAmountPaid, lblOutstanding, txtOutstanding})
        
        ' Invoice lines grid
        Dim grpLines As New GroupBox With {
            .Text = "Invoice Lines",
            .Dock = DockStyle.Fill,
            .Padding = New Padding(10)
        }
        
        Dim dgvLines As New DataGridView With {
            .Name = "dgvLines",
            .Dock = DockStyle.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .SelectionMode = DataGridViewSelectionMode.CellSelect
        }
        AddHandler dgvLines.CellValueChanged, AddressOf dgvLines_CellValueChanged
        AddHandler dgvLines.CellValidating, AddressOf dgvLines_CellValidating
        
        grpLines.Controls.Add(dgvLines)
        
        pnlInvoice.Controls.AddRange({grpLines, grpHeader})
        
        ' Buttons
        Dim btnSave As New Button With {
            .Name = "btnSave",
            .Text = "Save Changes",
            .Location = New Point(10, 15),
            .Width = 120,
            .Height = 35,
            .Enabled = False,
            .BackColor = Color.Green,
            .ForeColor = Color.White
        }
        AddHandler btnSave.Click, AddressOf btnSave_Click
        
        Dim btnPrint As New Button With {
            .Name = "btnPrint",
            .Text = "Print Invoice",
            .Location = New Point(140, 15),
            .Width = 120,
            .Height = 35,
            .Enabled = False
        }
        AddHandler btnPrint.Click, AddressOf btnPrint_Click
        
        Dim btnViewPO As New Button With {
            .Name = "btnViewPO",
            .Text = "View Purchase Order",
            .Location = New Point(270, 15),
            .Width = 150,
            .Height = 35,
            .Enabled = False,
            .BackColor = Color.DodgerBlue,
            .ForeColor = Color.White
        }
        AddHandler btnViewPO.Click, AddressOf btnViewPO_Click
        
        Dim btnClose As New Button With {
            .Text = "Close",
            .Location = New Point(430, 15),
            .Width = 100,
            .Height = 35
        }
        AddHandler btnClose.Click, Sub() Me.Close()
        
        pnlButtons.Controls.AddRange({btnSave, btnPrint, btnViewPO, btnClose})
        
        ' Add panels to form
        Me.Controls.AddRange({pnlInvoice, pnlSearch, pnlButtons})
    End Sub
    
    Private Sub btnSearch_Click(sender As Object, e As EventArgs)
        Dim cboSupplier = DirectCast(Me.Controls.Find("cboSupplier", True)(0), ComboBox)
        Dim txtInvoiceNumber = DirectCast(Me.Controls.Find("txtInvoiceNumber", True)(0), TextBox)
        Dim invoiceNum As String = txtInvoiceNumber.Text.Trim()
        
        If cboSupplier.SelectedIndex < 0 Then
            MessageBox.Show("Please select a supplier first.", "Search", MessageBoxButtons.OK, MessageBoxIcon.Information)
            cboSupplier.Focus()
            Return
        End If
        
        If String.IsNullOrWhiteSpace(invoiceNum) Then
            MessageBox.Show("Please enter an invoice number.", "Search", MessageBoxButtons.OK, MessageBoxIcon.Information)
            txtInvoiceNumber.Focus()
            Return
        End If
        
        currentSupplierId = Convert.ToInt32(cboSupplier.SelectedValue)
        SearchAndLoadInvoice(invoiceNum, currentSupplierId)
    End Sub
    
    Private Sub SearchAndLoadInvoice(invoiceNumber As String, supplierId As Integer)
        Try
            Dim lblStatus = DirectCast(Me.Controls.Find("lblStatus", True)(0), Label)
            lblStatus.Text = "Searching..."
            lblStatus.ForeColor = Color.Blue
            
            Using con As New SqlConnection(connectionString)
                con.Open()
                
                ' Search for invoice by supplier and invoice number
                Dim sql As String
                
                ' Search with supplier filter
                sql = "SELECT TOP 1 si.InvoiceID, si.InvoiceNumber, si.SupplierID, s.CompanyName AS SupplierName, " &
                      "si.InvoiceDate, si.DueDate, si.BranchID, b.BranchName, si.Status, si.PurchaseOrderID, " &
                      "si.SubTotal, si.VATAmount, si.TotalAmount, si.AmountPaid, si.AmountOutstanding, " &
                      "si.DiscountAmount, si.DiscountPercent " &
                      "FROM SupplierInvoices si " &
                      "INNER JOIN Suppliers s ON si.SupplierID = s.SupplierID " &
                      "LEFT JOIN Branches b ON si.BranchID = b.BranchID " &
                      "WHERE si.InvoiceNumber = @InvoiceNumber AND si.SupplierID = @SupplierID"
                
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
                    cmd.Parameters.AddWithValue("@SupplierID", supplierId)
                    
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            currentInvoiceId = Convert.ToInt32(reader("InvoiceID"))
                            currentPurchaseOrderId = If(IsDBNull(reader("PurchaseOrderID")), 0, Convert.ToInt32(reader("PurchaseOrderID")))
                            
                            ' Populate header fields
                            DirectCast(Me.Controls.Find("txtSupplier", True)(0), TextBox).Text = reader("SupplierName").ToString()
                            DirectCast(Me.Controls.Find("dtpInvoiceDate", True)(0), DateTimePicker).Value = Convert.ToDateTime(reader("InvoiceDate"))
                            DirectCast(Me.Controls.Find("dtpDueDate", True)(0), DateTimePicker).Value = Convert.ToDateTime(reader("DueDate"))
                            DirectCast(Me.Controls.Find("txtBranch", True)(0), TextBox).Text = If(IsDBNull(reader("BranchName")), "", reader("BranchName").ToString())
                            DirectCast(Me.Controls.Find("txtStatus", True)(0), TextBox).Text = reader("Status").ToString()
                            DirectCast(Me.Controls.Find("txtPONumber", True)(0), TextBox).Text = If(currentPurchaseOrderId > 0, "PO-" & currentPurchaseOrderId.ToString(), "N/A")
                            
                            DirectCast(Me.Controls.Find("txtSubTotal", True)(0), TextBox).Text = Convert.ToDecimal(reader("SubTotal")).ToString("N4")
                            DirectCast(Me.Controls.Find("txtDiscount", True)(0), TextBox).Text = Convert.ToDecimal(reader("DiscountAmount")).ToString("N4")
                            DirectCast(Me.Controls.Find("txtVAT", True)(0), TextBox).Text = Convert.ToDecimal(reader("VATAmount")).ToString("N4")
                            DirectCast(Me.Controls.Find("txtTotal", True)(0), TextBox).Text = Convert.ToDecimal(reader("TotalAmount")).ToString("N4")
                            DirectCast(Me.Controls.Find("txtAmountPaid", True)(0), TextBox).Text = Convert.ToDecimal(reader("AmountPaid")).ToString("N4")
                            DirectCast(Me.Controls.Find("txtOutstanding", True)(0), TextBox).Text = Convert.ToDecimal(reader("AmountOutstanding")).ToString("N4")
                            
                            reader.Close()
                            
                            ' Load invoice lines
                            LoadInvoiceLines(con)
                            
                            lblStatus.Text = $"Invoice {invoiceNumber} loaded successfully"
                            lblStatus.ForeColor = Color.Green
                            
                            ' Enable buttons
                            DirectCast(Me.Controls.Find("btnSave", True)(0), Button).Enabled = True
                            DirectCast(Me.Controls.Find("btnPrint", True)(0), Button).Enabled = True
                            DirectCast(Me.Controls.Find("btnViewPO", True)(0), Button).Enabled = (currentPurchaseOrderId > 0)
                        Else
                            MessageBox.Show($"Invoice number '{invoiceNumber}' not found for the selected supplier.", "Not Found", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            lblStatus.Text = "Invoice not found"
                            lblStatus.ForeColor = Color.Red
                            ClearForm()
                        End If
                    End Using
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error searching invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub SearchAndLoadInvoice_Old(invoiceNumber As String)
        Try
            Dim lblStatus = DirectCast(Me.Controls.Find("lblStatus", True)(0), Label)
            lblStatus.Text = "Searching..."
            lblStatus.ForeColor = Color.Blue
            
            Using con As New SqlConnection(connectionString)
                con.Open()
                
                ' OLD CODE - Check if PurchaseOrderID column exists
                Dim checkColumnSql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SupplierInvoices' AND COLUMN_NAME = 'PurchaseOrderID'"
                Dim hasPOColumn As Boolean = False
                Dim sql As String
                
                Using checkCmd As New SqlCommand(checkColumnSql, con)
                    hasPOColumn = (Convert.ToInt32(checkCmd.ExecuteScalar()) > 0)
                End Using
                
                If hasPOColumn Then
                    sql = "SELECT i.InvoiceID, i.InvoiceNumber, i.InvoiceDate, i.DueDate, i.SubTotal, i.VATAmount, i.TotalAmount, " &
                         "i.AmountPaid, i.AmountOutstanding, i.Status, i.PurchaseOrderID, ISNULL(i.DiscountAmount, 0) AS DiscountAmount, ISNULL(i.DiscountPercent, 0) AS DiscountPercent, " &
                         "s.CompanyName, s.ContactPerson, s.Phone, s.Email, s.Address, s.City, s.PostalCode, b.BranchName, po.PONumber " &
                         "FROM SupplierInvoices i " &
                         "INNER JOIN Suppliers s ON s.SupplierID = i.SupplierID " &
                         "LEFT JOIN Branches b ON b.BranchID = i.BranchID " &
                         "LEFT JOIN PurchaseOrders po ON po.PurchaseOrderID = i.PurchaseOrderID " &
                         "WHERE i.InvoiceNumber = @InvoiceNumber"
                Else
                    sql = "SELECT i.InvoiceID, i.InvoiceNumber, i.InvoiceDate, i.DueDate, i.SubTotal, i.VATAmount, i.TotalAmount, " &
                         "i.AmountPaid, i.AmountOutstanding, i.Status, 0 AS PurchaseOrderID, ISNULL(i.DiscountAmount, 0) AS DiscountAmount, ISNULL(i.DiscountPercent, 0) AS DiscountPercent, " &
                         "s.CompanyName, s.ContactPerson, s.Phone, s.Email, s.Address, s.City, s.PostalCode, b.BranchName, 'N/A' AS PONumber " &
                         "FROM SupplierInvoices i " &
                         "INNER JOIN Suppliers s ON s.SupplierID = i.SupplierID " &
                         "LEFT JOIN Branches b ON b.BranchID = i.BranchID " &
                         "WHERE i.InvoiceNumber = @InvoiceNumber"
                End If
                
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
                    
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            currentInvoiceId = Convert.ToInt32(reader("InvoiceID"))
                            currentPurchaseOrderId = If(IsDBNull(reader("PurchaseOrderID")), 0, Convert.ToInt32(reader("PurchaseOrderID")))
                            LoadInvoiceDetails(reader)
                            reader.Close()
                            LoadInvoiceLines(con)
                            
                            lblStatus.Text = $"Invoice {invoiceNumber} loaded successfully"
                            lblStatus.ForeColor = Color.Green
                            
                            DirectCast(Me.Controls.Find("btnPrint", True)(0), Button).Enabled = True
                            DirectCast(Me.Controls.Find("btnViewPO", True)(0), Button).Enabled = (currentPurchaseOrderId > 0)
                        Else
                            MessageBox.Show($"Invoice number '{invoiceNumber}' not found.", "Not Found", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            lblStatus.Text = "Invoice not found"
                            lblStatus.ForeColor = Color.Red
                            ClearForm()
                        End If
                    End Using
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error searching invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub LoadInvoiceDetails(reader As SqlDataReader)
        DirectCast(Me.Controls.Find("txtSupplier", True)(0), TextBox).Text = reader("CompanyName").ToString()
        DirectCast(Me.Controls.Find("dtpInvoiceDate", True)(0), DateTimePicker).Value = Convert.ToDateTime(reader("InvoiceDate"))
        DirectCast(Me.Controls.Find("dtpDueDate", True)(0), DateTimePicker).Value = Convert.ToDateTime(reader("DueDate"))
        DirectCast(Me.Controls.Find("txtBranch", True)(0), TextBox).Text = If(IsDBNull(reader("BranchName")), "", reader("BranchName").ToString())
        DirectCast(Me.Controls.Find("txtStatus", True)(0), TextBox).Text = reader("Status").ToString()
        DirectCast(Me.Controls.Find("txtPONumber", True)(0), TextBox).Text = If(IsDBNull(reader("PONumber")), "N/A", reader("PONumber").ToString())
        DirectCast(Me.Controls.Find("txtSubTotal", True)(0), TextBox).Text = Convert.ToDecimal(reader("SubTotal")).ToString("N4")
        
        Dim discountAmount As Decimal = Convert.ToDecimal(reader("DiscountAmount"))
        Dim discountPercent As Decimal = Convert.ToDecimal(reader("DiscountPercent"))
        If discountAmount > 0 Then
            DirectCast(Me.Controls.Find("txtDiscount", True)(0), TextBox).Text = $"R {discountAmount:N4} ({discountPercent:N4}%)"
        Else
            DirectCast(Me.Controls.Find("txtDiscount", True)(0), TextBox).Text = "R 0.0000"
        End If
        
        DirectCast(Me.Controls.Find("txtVAT", True)(0), TextBox).Text = Convert.ToDecimal(reader("VATAmount")).ToString("N4")
        DirectCast(Me.Controls.Find("txtTotal", True)(0), TextBox).Text = Convert.ToDecimal(reader("TotalAmount")).ToString("N4")
        DirectCast(Me.Controls.Find("txtAmountPaid", True)(0), TextBox).Text = Convert.ToDecimal(reader("AmountPaid")).ToString("N4")
        DirectCast(Me.Controls.Find("txtOutstanding", True)(0), TextBox).Text = Convert.ToDecimal(reader("AmountOutstanding")).ToString("N4")
    End Sub
    
    Private Sub LoadInvoiceLines(con As SqlConnection)
        Dim sql = "SELECT InvoiceLineID, ItemID, ItemSource, Description, Quantity, UnitPrice, LineTotal " &
                 "FROM SupplierInvoiceLines " &
                 "WHERE InvoiceID = @InvoiceID " &
                 "ORDER BY InvoiceLineID"
        
        Using cmd As New SqlCommand(sql, con)
            cmd.Parameters.AddWithValue("@InvoiceID", currentInvoiceId)
            
            Dim dt As New DataTable()
            Using da As New SqlDataAdapter(cmd)
                da.Fill(dt)
            End Using
            
            Dim dgvLines = DirectCast(Me.Controls.Find("dgvLines", True)(0), DataGridView)
            dgvLines.DataSource = dt
            
            If dgvLines.Columns.Count > 0 Then
                dgvLines.Columns("InvoiceLineID").Visible = False
                dgvLines.Columns("ItemID").Visible = False
                dgvLines.Columns("ItemSource").HeaderText = "Type"
                dgvLines.Columns("ItemSource").Width = 60
                dgvLines.Columns("ItemSource").ReadOnly = True
                dgvLines.Columns("Description").HeaderText = "Description"
                dgvLines.Columns("Description").ReadOnly = True
                dgvLines.Columns("Quantity").HeaderText = "Quantity"
                dgvLines.Columns("Quantity").DefaultCellStyle.Format = "N4"
                dgvLines.Columns("Quantity").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgvLines.Columns("Quantity").ReadOnly = False
                dgvLines.Columns("UnitPrice").HeaderText = "Unit Price"
                dgvLines.Columns("UnitPrice").DefaultCellStyle.Format = "N4"
                dgvLines.Columns("UnitPrice").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgvLines.Columns("UnitPrice").ReadOnly = False
                dgvLines.Columns("LineTotal").HeaderText = "Total"
                dgvLines.Columns("LineTotal").DefaultCellStyle.Format = "N4"
                dgvLines.Columns("LineTotal").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                dgvLines.Columns("LineTotal").ReadOnly = True
            End If
            
            DirectCast(Me.Controls.Find("btnSave", True)(0), Button).Enabled = True
        End Using
    End Sub
    
    Private Sub ClearForm()
        currentInvoiceId = 0
        currentPurchaseOrderId = 0
        DirectCast(Me.Controls.Find("txtSupplier", True)(0), TextBox).Clear()
        DirectCast(Me.Controls.Find("txtBranch", True)(0), TextBox).Clear()
        DirectCast(Me.Controls.Find("txtStatus", True)(0), TextBox).Clear()
        DirectCast(Me.Controls.Find("txtSubTotal", True)(0), TextBox).Clear()
        DirectCast(Me.Controls.Find("txtVAT", True)(0), TextBox).Clear()
        DirectCast(Me.Controls.Find("txtTotal", True)(0), TextBox).Clear()
        DirectCast(Me.Controls.Find("txtAmountPaid", True)(0), TextBox).Clear()
        DirectCast(Me.Controls.Find("txtOutstanding", True)(0), TextBox).Clear()
        DirectCast(Me.Controls.Find("dgvLines", True)(0), DataGridView).DataSource = Nothing
        DirectCast(Me.Controls.Find("btnPrint", True)(0), Button).Enabled = False
        DirectCast(Me.Controls.Find("btnViewPO", True)(0), Button).Enabled = False
    End Sub
    
    Private Sub btnViewPO_Click(sender As Object, e As EventArgs)
        If currentPurchaseOrderId <= 0 Then
            MessageBox.Show("No Purchase Order linked to this invoice.", "View PO", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        Try
            Dim poViewer As New PurchaseOrderViewerForm(currentPurchaseOrderId)
            poViewer.ShowDialog(Me)
        Catch ex As Exception
            MessageBox.Show($"Error opening Purchase Order: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnPrint_Click(sender As Object, e As EventArgs)
        If currentInvoiceId <= 0 Then
            MessageBox.Show("No invoice loaded to print.", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        Try
            printFont = New Font("Arial", 10)
            printPageNumber = 0
            
            Dim preview As New PrintPreviewDialog With {
                .Document = printDocument,
                .WindowState = FormWindowState.Maximized
            }
            preview.ShowDialog()
            
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub PrintDocument_PrintPage(sender As Object, e As PrintPageEventArgs)
        printY = 50
        printPageNumber += 1
        
        Dim titleFont As New Font("Arial", 16, FontStyle.Bold)
        Dim headerFont As New Font("Arial", 12, FontStyle.Bold)
        Dim normalFont As New Font("Arial", 10)
        Dim smallFont As New Font("Arial", 8)
        
        ' Company header
        e.Graphics.DrawString("OVEN DELIGHTS", titleFont, Brushes.Black, 50, printY)
        printY += 30
        e.Graphics.DrawString("SUPPLIER INVOICE", headerFont, Brushes.Black, 50, printY)
        printY += 40
        
        ' Invoice details
        Dim txtInvoiceNumber = DirectCast(Me.Controls.Find("txtInvoiceNumber", True)(0), TextBox)
        Dim txtSupplier = DirectCast(Me.Controls.Find("txtSupplier", True)(0), TextBox)
        Dim dtpInvoiceDate = DirectCast(Me.Controls.Find("dtpInvoiceDate", True)(0), DateTimePicker)
        Dim dtpDueDate = DirectCast(Me.Controls.Find("dtpDueDate", True)(0), DateTimePicker)
        Dim txtBranch = DirectCast(Me.Controls.Find("txtBranch", True)(0), TextBox)
        Dim txtStatus = DirectCast(Me.Controls.Find("txtStatus", True)(0), TextBox)
        
        e.Graphics.DrawString($"Invoice Number: {txtInvoiceNumber.Text}", normalFont, Brushes.Black, 50, printY)
        e.Graphics.DrawString($"Date: {dtpInvoiceDate.Value:dd MMM yyyy}", normalFont, Brushes.Black, 500, printY)
        printY += 25
        
        e.Graphics.DrawString($"Supplier: {txtSupplier.Text}", normalFont, Brushes.Black, 50, printY)
        printY += 25
        
        e.Graphics.DrawString($"Branch: {txtBranch.Text}", normalFont, Brushes.Black, 50, printY)
        e.Graphics.DrawString($"Status: {txtStatus.Text}", normalFont, Brushes.Black, 400, printY)
        Dim txtPONumber = DirectCast(Me.Controls.Find("txtPONumber", True)(0), TextBox)
        e.Graphics.DrawString($"PO Number: {txtPONumber.Text}", normalFont, Brushes.Black, 550, printY)
        printY += 40
        
        ' Line items header
        e.Graphics.DrawLine(Pens.Black, 50, printY, 750, printY)
        printY += 5
        
        e.Graphics.DrawString("Code", headerFont, Brushes.Black, 50, printY)
        e.Graphics.DrawString("Description", headerFont, Brushes.Black, 150, printY)
        e.Graphics.DrawString("Qty", headerFont, Brushes.Black, 450, printY)
        e.Graphics.DrawString("Unit Price", headerFont, Brushes.Black, 520, printY)
        e.Graphics.DrawString("Total", headerFont, Brushes.Black, 650, printY)
        printY += 25
        
        e.Graphics.DrawLine(Pens.Black, 50, printY, 750, printY)
        printY += 10
        
        ' Line items
        Dim dgvLines = DirectCast(Me.Controls.Find("dgvLines", True)(0), DataGridView)
        For Each row As DataGridViewRow In dgvLines.Rows
            If Not row.IsNewRow Then
                Dim itemSource As String = If(row.Cells("ItemSource").Value, "").ToString()
                Dim description As String = If(row.Cells("Description").Value, "").ToString()
                e.Graphics.DrawString(itemSource, normalFont, Brushes.Black, 50, printY)
                e.Graphics.DrawString(description, normalFont, Brushes.Black, 150, printY)
                e.Graphics.DrawString(Convert.ToDecimal(row.Cells("Quantity").Value).ToString("N4"), normalFont, Brushes.Black, 450, printY)
                e.Graphics.DrawString(Convert.ToDecimal(row.Cells("UnitPrice").Value).ToString("N4"), normalFont, Brushes.Black, 520, printY)
                e.Graphics.DrawString(Convert.ToDecimal(row.Cells("LineTotal").Value).ToString("N4"), normalFont, Brushes.Black, 650, printY)
                printY += 20
            End If
        Next
        
        printY += 10
        e.Graphics.DrawLine(Pens.Black, 50, printY, 750, printY)
        printY += 20
        
        ' Totals
        Dim txtSubTotal = DirectCast(Me.Controls.Find("txtSubTotal", True)(0), TextBox)
        Dim txtDiscount = DirectCast(Me.Controls.Find("txtDiscount", True)(0), TextBox)
        Dim txtVAT = DirectCast(Me.Controls.Find("txtVAT", True)(0), TextBox)
        Dim txtTotal = DirectCast(Me.Controls.Find("txtTotal", True)(0), TextBox)
        Dim txtAmountPaid = DirectCast(Me.Controls.Find("txtAmountPaid", True)(0), TextBox)
        Dim txtOutstanding = DirectCast(Me.Controls.Find("txtOutstanding", True)(0), TextBox)
        
        e.Graphics.DrawString("Sub Total:", normalFont, Brushes.Black, 550, printY)
        e.Graphics.DrawString($"R {txtSubTotal.Text}", normalFont, Brushes.Black, 650, printY)
        printY += 25
        
        e.Graphics.DrawString("VAT:", normalFont, Brushes.Black, 550, printY)
        e.Graphics.DrawString($"R {txtVAT.Text}", normalFont, Brushes.Black, 650, printY)
        printY += 25
        
        If Not txtDiscount.Text.StartsWith("R 0.0000") Then
            e.Graphics.DrawString("Discount:", normalFont, Brushes.Black, 550, printY)
            e.Graphics.DrawString(txtDiscount.Text, normalFont, Brushes.Black, 650, printY)
            printY += 25
        End If
        
        e.Graphics.DrawString("Total:", headerFont, Brushes.Black, 550, printY)
        e.Graphics.DrawString($"R {txtTotal.Text}", headerFont, Brushes.Black, 650, printY)
        printY += 30
        
        e.Graphics.DrawString("Amount Paid:", normalFont, Brushes.Black, 550, printY)
        e.Graphics.DrawString($"R {txtAmountPaid.Text}", normalFont, Brushes.Black, 650, printY)
        printY += 25
        
        e.Graphics.DrawString("Outstanding:", headerFont, Brushes.Black, 550, printY)
        e.Graphics.DrawString($"R {txtOutstanding.Text}", New Font("Arial", 10, FontStyle.Bold), Brushes.Red, 650, printY)
        
        ' Footer
        printY = 1050
        e.Graphics.DrawString($"Printed: {DateTime.Now:dd MMM yyyy HH:mm}", smallFont, Brushes.Gray, 50, printY)
        e.Graphics.DrawString($"Page {printPageNumber}", smallFont, Brushes.Gray, 700, printY)
        
        e.HasMorePages = False
    End Sub
    
    Private Sub dgvLines_CellValidating(sender As Object, e As DataGridViewCellValidatingEventArgs)
        Dim dgv = DirectCast(sender, DataGridView)
        
        ' Only validate Quantity and UnitPrice columns
        If dgv.Columns(e.ColumnIndex).Name = "Quantity" OrElse dgv.Columns(e.ColumnIndex).Name = "UnitPrice" Then
            Dim newValue As String = e.FormattedValue.ToString()
            Dim decimalValue As Decimal
            
            If Not Decimal.TryParse(newValue, decimalValue) OrElse decimalValue < 0 Then
                MessageBox.Show("Please enter a valid positive number.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                e.Cancel = True
            End If
        End If
    End Sub
    
    Private Sub dgvLines_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex < 0 Then Return
        
        Dim dgv = DirectCast(sender, DataGridView)
        
        ' Only recalculate if Quantity or UnitPrice changed
        If dgv.Columns(e.ColumnIndex).Name = "Quantity" OrElse dgv.Columns(e.ColumnIndex).Name = "UnitPrice" Then
            Dim row = dgv.Rows(e.RowIndex)
            
            Dim qty As Decimal = If(row.Cells("Quantity").Value, 0D)
            Dim unitPrice As Decimal = If(row.Cells("UnitPrice").Value, 0D)
            Dim lineTotal As Decimal = qty * unitPrice
            
            row.Cells("LineTotal").Value = lineTotal
            
            ' Recalculate invoice totals
            RecalculateTotals()
        End If
    End Sub
    
    Private Sub RecalculateTotals()
        Dim dgvLines = DirectCast(Me.Controls.Find("dgvLines", True)(0), DataGridView)
        
        Dim subTotal As Decimal = 0
        For Each row As DataGridViewRow In dgvLines.Rows
            If Not row.IsNewRow Then
                subTotal += If(row.Cells("LineTotal").Value, 0D)
            End If
        Next
        
        Dim vatAmount As Decimal = Math.Round(subTotal * 0.15D, 4)
        Dim totalAmount As Decimal = subTotal + vatAmount
        
        DirectCast(Me.Controls.Find("txtSubTotal", True)(0), TextBox).Text = subTotal.ToString("N4")
        DirectCast(Me.Controls.Find("txtVAT", True)(0), TextBox).Text = vatAmount.ToString("N4")
        DirectCast(Me.Controls.Find("txtTotal", True)(0), TextBox).Text = totalAmount.ToString("N4")
        
        ' Update outstanding (Total - AmountPaid)
        Dim amountPaid As Decimal = Decimal.Parse(DirectCast(Me.Controls.Find("txtAmountPaid", True)(0), TextBox).Text)
        Dim outstanding As Decimal = totalAmount - amountPaid
        DirectCast(Me.Controls.Find("txtOutstanding", True)(0), TextBox).Text = outstanding.ToString("N4")
    End Sub
    
    Private Sub btnSave_Click(sender As Object, e As EventArgs)
        If currentInvoiceId <= 0 Then
            MessageBox.Show("No invoice loaded to save.", "Save", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        If MessageBox.Show("Save changes to this invoice? This will update the invoice lines, totals, and journals.", "Confirm Save", MessageBoxButtons.YesNo, MessageBoxIcon.Question) <> DialogResult.Yes Then
            Return
        End If
        
        Try
            Using con As New SqlConnection(connectionString)
                con.Open()
                Using tx = con.BeginTransaction()
                    Try
                        ' Delete existing invoice lines
                        Dim deleteSql = "DELETE FROM SupplierInvoiceLines WHERE InvoiceID = @InvoiceID"
                        Using cmd As New SqlCommand(deleteSql, con, tx)
                            cmd.Parameters.AddWithValue("@InvoiceID", currentInvoiceId)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' Insert updated invoice lines
                        Dim dgvLines = DirectCast(Me.Controls.Find("dgvLines", True)(0), DataGridView)
                        For Each row As DataGridViewRow In dgvLines.Rows
                            If Not row.IsNewRow Then
                                Dim insertSql = "INSERT INTO SupplierInvoiceLines (InvoiceID, ItemID, ItemSource, Description, Quantity, UnitPrice, LineTotal) " &
                                               "VALUES (@InvoiceID, @ItemID, @ItemSource, @Description, @Quantity, @UnitPrice, @LineTotal)"
                                Using cmd As New SqlCommand(insertSql, con, tx)
                                    cmd.Parameters.AddWithValue("@InvoiceID", currentInvoiceId)
                                    cmd.Parameters.AddWithValue("@ItemID", If(row.Cells("ItemID").Value, 0))
                                    cmd.Parameters.AddWithValue("@ItemSource", If(row.Cells("ItemSource").Value, ""))
                                    cmd.Parameters.AddWithValue("@Description", If(row.Cells("Description").Value, ""))
                                    cmd.Parameters.AddWithValue("@Quantity", If(row.Cells("Quantity").Value, 0D))
                                    cmd.Parameters.AddWithValue("@UnitPrice", If(row.Cells("UnitPrice").Value, 0D))
                                    cmd.Parameters.AddWithValue("@LineTotal", If(row.Cells("LineTotal").Value, 0D))
                                    cmd.ExecuteNonQuery()
                                End Using
                            End If
                        Next
                        
                        ' Update invoice header totals
                        Dim subTotal As Decimal = Decimal.Parse(DirectCast(Me.Controls.Find("txtSubTotal", True)(0), TextBox).Text)
                        Dim vatAmount As Decimal = Decimal.Parse(DirectCast(Me.Controls.Find("txtVAT", True)(0), TextBox).Text)
                        Dim totalAmount As Decimal = Decimal.Parse(DirectCast(Me.Controls.Find("txtTotal", True)(0), TextBox).Text)
                        Dim amountPaid As Decimal = Decimal.Parse(DirectCast(Me.Controls.Find("txtAmountPaid", True)(0), TextBox).Text)
                        Dim outstanding As Decimal = totalAmount - amountPaid
                        
                        Dim updateSql = "UPDATE SupplierInvoices SET SubTotal = @SubTotal, VATAmount = @VAT, TotalAmount = @Total, AmountOutstanding = @Outstanding " &
                                       "WHERE InvoiceID = @InvoiceID"
                        Using cmd As New SqlCommand(updateSql, con, tx)
                            cmd.Parameters.AddWithValue("@InvoiceID", currentInvoiceId)
                            cmd.Parameters.AddWithValue("@SubTotal", subTotal)
                            cmd.Parameters.AddWithValue("@VAT", vatAmount)
                            cmd.Parameters.AddWithValue("@Total", totalAmount)
                            cmd.Parameters.AddWithValue("@Outstanding", outstanding)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' Update supplier ledger balance
                        Dim updateLedgerSql = "UPDATE SupplierLedger SET Debit = @Total WHERE InvoiceID = @InvoiceID"
                        Using cmd As New SqlCommand(updateLedgerSql, con, tx)
                            cmd.Parameters.AddWithValue("@InvoiceID", currentInvoiceId)
                            cmd.Parameters.AddWithValue("@Total", totalAmount)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' Also update AP_Invoices if matching record exists (for FNB bulk payments)
                        Dim txtInvoiceNumber = DirectCast(Me.Controls.Find("txtInvoiceNumber", True)(0), TextBox)
                        Dim updateAPSql = "UPDATE AP_Invoices SET Amount = @Amount, TaxAmount = @Tax " &
                                         "WHERE InvoiceNumber = @InvoiceNumber"
                        Using cmd As New SqlCommand(updateAPSql, con, tx)
                            cmd.Parameters.AddWithValue("@InvoiceNumber", txtInvoiceNumber.Text)
                            cmd.Parameters.AddWithValue("@Amount", subTotal)
                            cmd.Parameters.AddWithValue("@Tax", vatAmount)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        tx.Commit()
                        MessageBox.Show("Invoice updated successfully in both systems!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        
                    Catch ex As Exception
                        tx.Rollback()
                        Throw
                    End Try
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error saving invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
