Imports System.Windows.Forms
Imports System.Data
Imports System.Drawing
Imports System.Drawing.Printing
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Namespace Purchasing
    Public Class EditPurchaseOrderForm
        Inherits Form

        Private ReadOnly service As New StockroomService()
        Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private currentBranchId As Integer
        Private selectedPOID As Integer = 0
        Private selectedSupplierID As Integer = 0
        Private printDocument As New PrintDocument()
        Private currentPONumber As String = ""
        Private currentSupplierName As String = ""

        ' Header controls
        Private cboSupplier As ComboBox
        Private cboPO As ComboBox
        Private txtSupplier As TextBox
        Private txtOrderDate As TextBox
        Private txtRequiredDate As TextBox
        Private txtReference As TextBox
        Private txtNotes As TextBox
        Private cboProductType As ComboBox
        Private lblPONumber As Label

        ' Grid
        Private dgvLines As DataGridView

        ' Product autocomplete
        Private productLookup As New Dictionary(Of String, Integer)()
        Private allProducts As DataTable

        ' Totals
        Private txtSubTotal As TextBox
        Private txtVAT As TextBox
        Private txtTotal As TextBox
        Private btnUpdate As Button
        Private btnClose As Button

        Public Sub New()
            Me.WindowState = FormWindowState.Maximized
            Me.Text = "Edit Purchase Order"
            Me.BackColor = Color.White

            currentBranchId = service.GetCurrentUserBranchId()

            InitializeComponent()
            LoadSuppliers()
            LoadProducts()
            
            ' Refresh PO list when form is activated to ensure invoiced POs are excluded
            AddHandler Me.Activated, AddressOf Form_Activated
        End Sub
        
        Private Sub Form_Activated(sender As Object, e As EventArgs)
            ' Refresh the PO list if a supplier is selected
            If cboSupplier.SelectedIndex >= 0 AndAlso selectedSupplierID > 0 Then
                Dim currentPOSelection = cboPO.SelectedValue
                LoadPurchaseOrdersWithoutInvoices()
                ' Try to restore selection if PO still exists
                If currentPOSelection IsNot Nothing Then
                    cboPO.SelectedValue = currentPOSelection
                End If
            End If
        End Sub

        Private Sub InitializeComponent()
            ' Modern header
            Dim header As New Panel With {
                .Dock = DockStyle.Top,
                .Height = 180,
                .BackColor = Color.FromArgb(245, 245, 245),
                .Padding = New Padding(20)
            }

            ' Row 1 - Supplier and PO Selection
            Dim lblSupplier As New Label With {.Text = "Supplier", .Location = New Point(20, 15), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
            cboSupplier = New ComboBox With {
                .Location = New Point(20, 38),
                .Width = 280,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10.0F),
                .BackColor = Color.White,
                .ForeColor = Color.Black
            }
            AddHandler cboSupplier.SelectedIndexChanged, AddressOf cboSupplier_SelectedIndexChanged

            Dim lblPO As New Label With {.Text = "Purchase Order", .Location = New Point(320, 15), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
            cboPO = New ComboBox With {
                .Location = New Point(320, 38),
                .Width = 280,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10.0F),
                .BackColor = Color.White,
                .ForeColor = Color.Black,
                .Enabled = False
            }
            AddHandler cboPO.SelectedIndexChanged, AddressOf cboPO_SelectedIndexChanged

            lblPONumber = New Label With {.Text = "Select a PO to edit", .Location = New Point(620, 38), .Font = New Font("Segoe UI", 11.0F, FontStyle.Bold), .ForeColor = Color.FromArgb(231, 76, 60), .AutoSize = True}

            ' Row 2 - PO Details (Read-only display)
            Dim lblOrderDate As New Label With {.Text = "Order Date", .Location = New Point(20, 80), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
            txtOrderDate = New TextBox With {.Location = New Point(20, 103), .Width = 140, .ReadOnly = True, .BackColor = Color.FromArgb(240, 240, 240), .Font = New Font("Segoe UI", 10.0F)}

            Dim lblRequiredDate As New Label With {.Text = "Required Date", .Location = New Point(180, 80), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
            txtRequiredDate = New TextBox With {.Location = New Point(180, 103), .Width = 140, .ReadOnly = True, .BackColor = Color.FromArgb(240, 240, 240), .Font = New Font("Segoe UI", 10.0F)}

            Dim lblReference As New Label With {.Text = "Reference", .Location = New Point(340, 80), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
            txtReference = New TextBox With {.Location = New Point(340, 103), .Width = 220, .Font = New Font("Segoe UI", 10.0F)}

            Dim lblNotes As New Label With {.Text = "Notes", .Location = New Point(20, 135), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
            txtNotes = New TextBox With {.Location = New Point(100, 135), .Width = 460, .Font = New Font("Segoe UI", 10.0F)}

            Dim lblProductType As New Label With {.Text = "Purchase Type", .Location = New Point(580, 80), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
            cboProductType = New ComboBox With {
                .Location = New Point(580, 103),
                .Width = 150,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10.0F),
                .BackColor = Color.White,
                .ForeColor = Color.Black
            }
            cboProductType.Items.AddRange({"External Product", "Raw Material"})
            cboProductType.SelectedIndex = 1
            AddHandler cboProductType.SelectedIndexChanged, AddressOf ProductType_Changed

            header.Controls.AddRange({lblSupplier, cboSupplier, lblPO, cboPO, lblPONumber, lblOrderDate, txtOrderDate, lblRequiredDate, txtRequiredDate, lblReference, txtReference, lblNotes, txtNotes, lblProductType, cboProductType})

            ' Modern grid
            dgvLines = New DataGridView With {
                .Dock = DockStyle.Fill,
                .AllowUserToAddRows = True,
                .AllowUserToDeleteRows = True,
                .AutoGenerateColumns = False,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal,
                .ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.None,
                .EnableHeadersVisualStyles = False,
                .RowHeadersVisible = False,
                .SelectionMode = DataGridViewSelectionMode.CellSelect,
                .AllowUserToResizeRows = False,
                .Font = New Font("Segoe UI", 10.0F)
            }

            ' Header styling
            dgvLines.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(52, 73, 94)
            dgvLines.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgvLines.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10.0F, FontStyle.Bold)
            dgvLines.ColumnHeadersDefaultCellStyle.Padding = New Padding(8)
            dgvLines.ColumnHeadersHeight = 45

            ' Row styling
            dgvLines.DefaultCellStyle.SelectionBackColor = Color.FromArgb(52, 152, 219)
            dgvLines.DefaultCellStyle.SelectionForeColor = Color.White
            dgvLines.DefaultCellStyle.Padding = New Padding(5)
            dgvLines.RowTemplate.Height = 40
            dgvLines.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(250, 250, 250)

            ' Columns
            dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductID", .Visible = False})
            dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "POLineID", .Visible = False})
            dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductType", .Visible = False})
            
            Dim productCol As New DataGridViewTextBoxColumn With {
                .Name = "Product",
                .HeaderText = "Product / Material",
                .Width = 350
            }
            dgvLines.Columns.Add(productCol)
            
            dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Qty", .HeaderText = "Quantity", .Width = 100, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N4"}})
            dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "UnitPrice", .HeaderText = "Unit Price (Excl VAT)", .Width = 140, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N4"}})
            dgvLines.Columns.Add(New DataGridViewCheckBoxColumn With {.Name = "IsVatable", .HeaderText = "VATable", .Width = 80, .TrueValue = True, .FalseValue = False})
            dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LastPaid", .HeaderText = "Last Paid", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N4", .ForeColor = Color.FromArgb(100, 100, 100)}})
            dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LineTotal", .HeaderText = "Line Total", .Width = 140, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N4", .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold)}})

            AddHandler dgvLines.EditingControlShowing, AddressOf Grid_EditingControlShowing
            AddHandler dgvLines.CellValueChanged, AddressOf Grid_CellValueChanged
            AddHandler dgvLines.CellEndEdit, AddressOf Grid_CellEndEdit

            ' Footer
            Dim footer As New Panel With {
                .Dock = DockStyle.Bottom,
                .Height = 80,
                .BackColor = Color.FromArgb(245, 245, 245),
                .Padding = New Padding(20)
            }

            Dim lblSubTotal As New Label With {.Text = "SubTotal (Excl VAT)", .Location = New Point(20, 15), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
            txtSubTotal = New TextBox With {.Location = New Point(20, 38), .Width = 130, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right, .Font = New Font("Segoe UI", 11.0F), .BackColor = Color.White}

            Dim lblVAT As New Label With {.Text = "VAT (15%)", .Location = New Point(170, 15), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
            txtVAT = New TextBox With {.Location = New Point(170, 38), .Width = 110, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right, .Font = New Font("Segoe UI", 11.0F), .BackColor = Color.White}

            Dim lblTotal As New Label With {.Text = "TOTAL (Incl VAT)", .Location = New Point(300, 15), .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold), .ForeColor = Color.FromArgb(231, 76, 60), .AutoSize = True}
            txtTotal = New TextBox With {.Location = New Point(300, 38), .Width = 150, .ReadOnly = True, .TextAlign = HorizontalAlignment.Right, .Font = New Font("Segoe UI", 12.0F, FontStyle.Bold), .BackColor = Color.White, .ForeColor = Color.FromArgb(231, 76, 60)}

            btnUpdate = New Button With {
                .Text = "💾 Update Purchase Order",
                .Location = New Point(480, 30),
                .Width = 220,
                .Height = 40,
                .Font = New Font("Segoe UI", 11.0F, FontStyle.Bold),
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Enabled = False
            }
            btnUpdate.FlatAppearance.BorderSize = 0
            AddHandler btnUpdate.Click, AddressOf Update_Click
            
            Dim btnPrint As New Button With {
                .Text = "🖨️ Print PO",
                .Location = New Point(720, 30),
                .Width = 150,
                .Height = 40,
                .Font = New Font("Segoe UI", 11.0F, FontStyle.Bold),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Enabled = False,
                .Name = "btnPrint"
            }
            btnPrint.FlatAppearance.BorderSize = 0
            AddHandler btnPrint.Click, AddressOf Print_Click
            AddHandler printDocument.PrintPage, AddressOf PrintDocument_PrintPage
            
            btnClose = New Button With {
                .Text = "✖ Close",
                .Location = New Point(890, 30),
                .Width = 150,
                .Height = 40,
                .Font = New Font("Segoe UI", 11.0F, FontStyle.Bold),
                .BackColor = Color.FromArgb(220, 53, 69),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            btnClose.FlatAppearance.BorderSize = 0
            AddHandler btnClose.Click, Sub() Me.Close()

            footer.Controls.AddRange({lblSubTotal, txtSubTotal, lblVAT, txtVAT, lblTotal, txtTotal, btnUpdate, btnPrint, btnClose})

            Me.Controls.Add(dgvLines)
            Me.Controls.Add(footer)
            Me.Controls.Add(header)
        End Sub

        Private Sub LoadSuppliers()
            Try
                Dim dt = service.GetSuppliers()
                cboSupplier.DataSource = dt
                cboSupplier.DisplayMember = "CompanyName"
                cboSupplier.ValueMember = "SupplierID"
                cboSupplier.SelectedIndex = -1
            Catch ex As Exception
                MessageBox.Show($"Error loading suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub cboSupplier_SelectedIndexChanged(sender As Object, e As EventArgs)
            If cboSupplier.SelectedIndex >= 0 AndAlso cboSupplier.SelectedValue IsNot Nothing Then
                Try
                    ' Check if SelectedValue is already an integer or needs conversion
                    If TypeOf cboSupplier.SelectedValue Is Integer Then
                        selectedSupplierID = CInt(cboSupplier.SelectedValue)
                    ElseIf TypeOf cboSupplier.SelectedValue Is String Then
                        selectedSupplierID = Convert.ToInt32(cboSupplier.SelectedValue)
                    ElseIf TypeOf cboSupplier.SelectedValue Is DataRowView Then
                        Dim drv As DataRowView = DirectCast(cboSupplier.SelectedValue, DataRowView)
                        selectedSupplierID = Convert.ToInt32(drv("SupplierID"))
                    Else
                        ' Try generic conversion
                        selectedSupplierID = Convert.ToInt32(cboSupplier.SelectedValue)
                    End If
                    
                    If selectedSupplierID > 0 Then
                        LoadPurchaseOrdersWithoutInvoices()
                        cboPO.Enabled = True
                    End If
                Catch ex As Exception
                    ' Ignore conversion errors during dropdown initialization
                    cboPO.DataSource = Nothing
                    cboPO.Enabled = False
                End Try
            Else
                cboPO.DataSource = Nothing
                cboPO.Enabled = False
                ClearForm()
            End If
        End Sub

        Private Sub LoadPurchaseOrdersWithoutInvoices()
            Try
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    
                    ' Get POs that don't have invoices captured against them
                    Dim sql As String = "
                        SELECT DISTINCT po.PurchaseOrderID, po.PONumber, po.OrderDate, po.RequiredDate
                        FROM PurchaseOrders po
                        WHERE po.SupplierID = @SupplierID
                          AND po.BranchID = @BranchID
                          AND po.Status NOT IN ('Cancelled', 'Closed')
                          AND po.PurchaseOrderID NOT IN (
                              SELECT DISTINCT PurchaseOrderID 
                              FROM SupplierInvoices 
                              WHERE PurchaseOrderID IS NOT NULL
                          )
                        ORDER BY po.OrderDate DESC, po.PONumber DESC"
                    
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@SupplierID", selectedSupplierID)
                        cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                        
                        Dim adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        
                        If dt.Rows.Count = 0 Then
                            ' Only show message if user explicitly selected a supplier (not during form load/scrolling)
                            If selectedSupplierID > 0 Then
                                MessageBox.Show("No editable purchase orders found for this supplier. All POs have invoices captured.", "No POs Available", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            End If
                            cboPO.DataSource = Nothing
                            cboPO.Enabled = False
                            Return
                        End If
                        
                        Try
                            ' Add display column manually to avoid casting errors
                            dt.Columns.Add("Display", GetType(String))
                            For Each row As DataRow In dt.Rows
                                Try
                                    Dim poNumber As String = If(row("PONumber") IsNot Nothing AndAlso Not IsDBNull(row("PONumber")), row("PONumber").ToString(), "")
                                    Dim orderDate As DateTime = If(row("OrderDate") IsNot Nothing AndAlso Not IsDBNull(row("OrderDate")), Convert.ToDateTime(row("OrderDate")), DateTime.Now)
                                    row("Display") = $"{poNumber} - {orderDate:dd MMM yyyy}"
                                Catch rowEx As Exception
                                    row("Display") = "Error loading PO"
                                End Try
                            Next
                            
                            ' Clear any existing binding first
                            cboPO.DataSource = Nothing
                            cboPO.DisplayMember = ""
                            cboPO.ValueMember = ""
                            
                            ' Now bind the data
                            cboPO.DataSource = dt
                            cboPO.DisplayMember = "Display"
                            cboPO.ValueMember = "PurchaseOrderID"
                            cboPO.SelectedIndex = -1
                        Catch displayEx As Exception
                            MessageBox.Show($"Error creating display column: {displayEx.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                            cboPO.DataSource = Nothing
                            cboPO.Enabled = False
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading purchase orders: {ex.Message}{Environment.NewLine}{Environment.NewLine}Stack Trace:{Environment.NewLine}{ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub cboPO_SelectedIndexChanged(sender As Object, e As EventArgs)
            If cboPO.SelectedIndex >= 0 AndAlso cboPO.SelectedValue IsNot Nothing Then
                Try
                    ' Check if SelectedValue is already an integer or needs conversion
                    If TypeOf cboPO.SelectedValue Is Integer Then
                        selectedPOID = CInt(cboPO.SelectedValue)
                    ElseIf TypeOf cboPO.SelectedValue Is String Then
                        selectedPOID = Convert.ToInt32(cboPO.SelectedValue)
                    ElseIf TypeOf cboPO.SelectedValue Is DataRowView Then
                        Dim drv As DataRowView = DirectCast(cboPO.SelectedValue, DataRowView)
                        selectedPOID = Convert.ToInt32(drv("PurchaseOrderID"))
                    Else
                        ' Try generic conversion
                        selectedPOID = Convert.ToInt32(cboPO.SelectedValue)
                    End If
                    
                    If selectedPOID > 0 Then
                        LoadPODetails()
                        btnUpdate.Enabled = True
                    End If
                Catch ex As Exception
                    MessageBox.Show($"Error selecting PO: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    ClearForm()
                    btnUpdate.Enabled = False
                End Try
            Else
                ClearForm()
                btnUpdate.Enabled = False
            End If
        End Sub

        Private Sub LoadPODetails()
            Try
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    
                    ' Load PO header
                    Dim headerSql As String = "
                        SELECT po.PONumber, po.OrderDate, po.RequiredDate, po.Reference, po.Notes
                        FROM PurchaseOrders po
                        WHERE po.PurchaseOrderID = @PurchaseOrderID"
                    
                    Using cmd As New SqlCommand(headerSql, conn)
                        cmd.Parameters.AddWithValue("@PurchaseOrderID", selectedPOID)
                        
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            If reader.Read() Then
                                currentPONumber = reader("PONumber").ToString()
                                lblPONumber.Text = $"PO: {currentPONumber}"
                                lblPONumber.ForeColor = Color.FromArgb(46, 204, 113)
                                txtOrderDate.Text = Convert.ToDateTime(reader("OrderDate")).ToString("dd/MM/yyyy")
                                txtRequiredDate.Text = Convert.ToDateTime(reader("RequiredDate")).ToString("dd/MM/yyyy")
                                txtReference.Text = If(IsDBNull(reader("Reference")), "", reader("Reference").ToString())
                                txtNotes.Text = If(IsDBNull(reader("Notes")), "", reader("Notes").ToString())
                            End If
                        End Using
                    End Using
                    
                    ' Store supplier name for printing
                    currentSupplierName = cboSupplier.Text
                    
                    ' Load PO lines - check both RawMaterials and Demo_Retail_Product
                    Dim linesSql As String = "
                        SELECT 
                            pol.POLineID,
                            COALESCE(pol.MaterialID, pol.ProductID, 0) AS ProductID,
                            CASE 
                                WHEN rm.MaterialID IS NOT NULL THEN rm.MaterialName
                                WHEN p.ProductID IS NOT NULL THEN p.Name
                                WHEN pol.MaterialID > 0 THEN 'Material ID: ' + CAST(pol.MaterialID AS NVARCHAR)
                                WHEN pol.ProductID > 0 THEN 'Product ID: ' + CAST(pol.ProductID AS NVARCHAR)
                                ELSE 'Unknown Item'
                            END AS ProductName,
                            pol.OrderedQuantity AS Quantity,
                            pol.UnitCost AS UnitPrice,
                            CASE 
                                WHEN rm.MaterialID IS NOT NULL THEN ISNULL(pol.IsVatable, 1)
                                WHEN p.ProductID IS NOT NULL THEN ISNULL(p.IsVatable, 1)
                                ELSE ISNULL(pol.IsVatable, 1)
                            END AS IsVatable,
                            CASE 
                                WHEN rm.MaterialID IS NOT NULL THEN ISNULL(rm.LastPaidPrice, 0)
                                WHEN p.ProductID IS NOT NULL THEN ISNULL(rp.CostPrice, 0)
                                ELSE 0
                            END AS LastPaid
                        FROM PurchaseOrderLines pol
                        LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID
                        LEFT JOIN Demo_Retail_Product p ON pol.ProductID = p.ProductID AND p.BranchID = @BranchID
                        LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
                        WHERE pol.PurchaseOrderID = @PurchaseOrderID
                        ORDER BY pol.POLineID"
                    
                    dgvLines.Rows.Clear()
                    
                    Dim rowCount As Integer = 0
                    Using cmd As New SqlCommand(linesSql, conn)
                        cmd.Parameters.AddWithValue("@PurchaseOrderID", selectedPOID)
                        cmd.Parameters.AddWithValue("@BranchID", AppSession.CurrentUser.BranchID)
                        
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            While reader.Read()
                                rowCount += 1
                                Dim row As Integer = dgvLines.Rows.Add()
                                
                                ' Handle all potential DBNull values
                                Dim productName As String = If(IsDBNull(reader("ProductName")), "", reader("ProductName").ToString())
                                Dim materialId As Integer = If(IsDBNull(reader("ProductID")), 0, Convert.ToInt32(reader("ProductID")))
                                Dim qty As Decimal = If(IsDBNull(reader("Quantity")), 0D, Convert.ToDecimal(reader("Quantity")))
                                Dim price As Decimal = If(IsDBNull(reader("UnitPrice")), 0D, Convert.ToDecimal(reader("UnitPrice")))
                                Dim isVatable As Boolean = If(IsDBNull(reader("IsVatable")), True, Convert.ToBoolean(reader("IsVatable")))
                                Dim lastPaid As Decimal = If(IsDBNull(reader("LastPaid")), 0D, Convert.ToDecimal(reader("LastPaid")))
                                Dim poLineId As Object = If(IsDBNull(reader("POLineID")), Nothing, reader("POLineID"))
                                
                                ' If product name is empty, show Material ID
                                If String.IsNullOrWhiteSpace(productName) Then
                                    productName = $"Material ID: {materialId}"
                                End If
                                
                                dgvLines.Rows(row).Cells("POLineID").Value = poLineId
                                dgvLines.Rows(row).Cells("ProductID").Value = materialId
                                dgvLines.Rows(row).Cells("Product").Value = productName
                                dgvLines.Rows(row).Cells("Qty").Value = qty
                                dgvLines.Rows(row).Cells("UnitPrice").Value = price
                                dgvLines.Rows(row).Cells("IsVatable").Value = isVatable
                                dgvLines.Rows(row).Cells("LastPaid").Value = lastPaid
                                dgvLines.Rows(row).Cells("LineTotal").Value = qty * price
                            End While
                        End Using
                    End Using
                    
                    If rowCount = 0 Then
                        MessageBox.Show($"No line items found for PO {currentPONumber}. The PO may be empty.", "No Items", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    End If
                    
                    CalculateTotals()
                    LoadProducts()
                    
                    ' Enable print button
                    Dim btnPrint = TryCast(Me.Controls.Find("btnPrint", True).FirstOrDefault(), Button)
                    If btnPrint IsNot Nothing Then
                        btnPrint.Enabled = True
                    End If
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading PO details: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub ClearForm()
            lblPONumber.Text = "Select a PO to edit"
            lblPONumber.ForeColor = Color.FromArgb(231, 76, 60)
            txtOrderDate.Clear()
            txtRequiredDate.Clear()
            txtReference.Clear()
            txtNotes.Clear()
            dgvLines.Rows.Clear()
            txtSubTotal.Text = "0.00"
            txtVAT.Text = "0.00"
            txtTotal.Text = "0.00"
        End Sub

        Private Sub LoadProducts()
            Try
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    
                    ' Load ALL purchasable items - both RawMaterials and External Products
                    ' Prioritize External Products - exclude RawMaterials with same name as External Products
                    Dim sql As String = "
                        SELECT ProductID, ProductName, LastPaidPrice, IsVatable, ItemSource
                        FROM (
                            -- External Products from Demo_Retail_Product with CostPrice (PRIORITY)
                            SELECT DISTINCT
                                p.ProductID, 
                                p.Name AS ProductName, 
                                ISNULL(rp.CostPrice, 0) AS LastPaidPrice, 
                                ISNULL(p.IsVatable, 1) AS IsVatable,
                                'PR' AS ItemSource
                            FROM Demo_Retail_Product p
                            LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
                            WHERE p.ProductType = 'External' 
                              AND p.IsActive = 1
                              AND p.BranchID = @BranchID
                            
                            UNION ALL
                            
                            -- RawMaterials (exclude if same name exists in External Products)
                            SELECT 
                                rm.MaterialID AS ProductID, 
                                rm.MaterialName AS ProductName, 
                                ISNULL(rm.LastPaidPrice, 0) AS LastPaidPrice, 
                                1 AS IsVatable,
                                'RM' AS ItemSource
                            FROM RawMaterials rm
                            WHERE rm.IsActive = 1
                              AND NOT EXISTS (
                                  SELECT 1 FROM Demo_Retail_Product p 
                                  WHERE p.Name = rm.MaterialName 
                                    AND p.ProductType = 'External' 
                                    AND p.IsActive = 1
                                    AND p.BranchID = @BranchID
                              )
                        ) AS AllItems
                        ORDER BY ProductName"
                    
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@BranchID", AppSession.CurrentUser.BranchID)
                        Dim adapter As New SqlDataAdapter(cmd)
                        allProducts = New DataTable()
                        adapter.Fill(allProducts)
                        
                        productLookup.Clear()
                        For Each row As DataRow In allProducts.Rows
                            Dim productName As String = row("ProductName").ToString()
                            Dim productId As Integer = Convert.ToInt32(row("ProductID"))
                            ' Use product name as key - if duplicate names exist, last one wins
                            productLookup(productName) = productId
                        Next
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub ProductType_Changed(sender As Object, e As EventArgs)
            LoadProducts()
        End Sub

        Private Sub Grid_EditingControlShowing(sender As Object, e As DataGridViewEditingControlShowingEventArgs)
            If dgvLines.CurrentCell Is Nothing Then Return
            
            Dim txt = TryCast(e.Control, TextBox)
            If txt Is Nothing Then Return
            
            ' Clear any previous autocomplete
            txt.AutoCompleteMode = AutoCompleteMode.None
            txt.AutoCompleteSource = AutoCompleteSource.None
            txt.AutoCompleteCustomSource = Nothing
            
            ' Setup autocomplete ONLY for Product column
            If dgvLines.CurrentCell.ColumnIndex = dgvLines.Columns("Product").Index Then
                ' Setup autocomplete with ALL products
                Dim ac As New AutoCompleteStringCollection()
                If productLookup IsNot Nothing AndAlso productLookup.Count > 0 Then
                    ac.AddRange(productLookup.Keys.ToArray())
                End If
                
                txt.AutoCompleteMode = AutoCompleteMode.SuggestAppend
                txt.AutoCompleteSource = AutoCompleteSource.CustomSource
                txt.AutoCompleteCustomSource = ac
                txt.BackColor = Color.White
                txt.ForeColor = Color.Black
                txt.Font = New Font("Segoe UI", 10.0F)
            End If
        End Sub

        Private Sub Grid_CellEndEdit(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex < 0 Then Return
            
            Dim row = dgvLines.Rows(e.RowIndex)
            
            If e.ColumnIndex = dgvLines.Columns("Product").Index Then
                Dim productName As String = row.Cells("Product").Value?.ToString()
                If Not String.IsNullOrWhiteSpace(productName) AndAlso productLookup.ContainsKey(productName) Then
                    Dim productId As Integer = productLookup(productName)
                    row.Cells("ProductID").Value = productId
                    
                    ' Load product details
                    Dim productRow = allProducts.AsEnumerable().FirstOrDefault(Function(r) Convert.ToInt32(r("ProductID")) = productId)
                    If productRow IsNot Nothing Then
                        row.Cells("LastPaid").Value = productRow("LastPaidPrice")
                        row.Cells("IsVatable").Value = productRow("IsVatable")
                        
                        If row.Cells("UnitPrice").Value Is Nothing OrElse Convert.ToDecimal(row.Cells("UnitPrice").Value) = 0 Then
                            row.Cells("UnitPrice").Value = productRow("LastPaidPrice")
                        End If
                        
                        If row.Cells("Qty").Value Is Nothing OrElse Convert.ToDecimal(row.Cells("Qty").Value) = 0 Then
                            row.Cells("Qty").Value = 1
                        End If
                    Else
                        ' DEBUG: Product not found in allProducts
                        MessageBox.Show($"Product '{productName}' (ID: {productId}) not found in allProducts DataTable.{Environment.NewLine}This means the ProductID from productLookup doesn't match any ProductID in allProducts.", "Debug: Product Not Found", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    End If
                End If
            End If
            
            CalculateLineTotal(e.RowIndex)
        End Sub

        Private Sub Grid_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex < 0 Then Return
            
            If e.ColumnIndex = dgvLines.Columns("Qty").Index OrElse e.ColumnIndex = dgvLines.Columns("UnitPrice").Index Then
                CalculateLineTotal(e.RowIndex)
            End If
        End Sub

        Private Sub CalculateLineTotal(rowIndex As Integer)
            If rowIndex < 0 OrElse rowIndex >= dgvLines.Rows.Count Then Return
            
            Dim row = dgvLines.Rows(rowIndex)
            
            Dim qty As Decimal = 0
            Dim price As Decimal = 0
            
            If row.Cells("Qty").Value IsNot Nothing Then Decimal.TryParse(row.Cells("Qty").Value.ToString(), qty)
            If row.Cells("UnitPrice").Value IsNot Nothing Then Decimal.TryParse(row.Cells("UnitPrice").Value.ToString(), price)
            
            row.Cells("LineTotal").Value = qty * price
            
            CalculateTotals()
        End Sub

        Private Sub CalculateTotals()
            Dim subTotal As Decimal = 0
            Dim vatTotal As Decimal = 0
            
            For Each row As DataGridViewRow In dgvLines.Rows
                If Not row.IsNewRow AndAlso row.Cells("ProductID").Value IsNot Nothing Then
                    Dim lineTotal As Decimal = 0
                    If row.Cells("LineTotal").Value IsNot Nothing Then
                        lineTotal = Convert.ToDecimal(row.Cells("LineTotal").Value)
                    End If
                    
                    subTotal += lineTotal
                    
                    Dim isVatable As Boolean = True
                    If row.Cells("IsVatable").Value IsNot Nothing Then
                        isVatable = Convert.ToBoolean(row.Cells("IsVatable").Value)
                    End If
                    
                    If isVatable Then
                        vatTotal += lineTotal * 0.15D
                    End If
                End If
            Next
            
            txtSubTotal.Text = subTotal.ToString("N2")
            txtVAT.Text = vatTotal.ToString("N2")
            txtTotal.Text = (subTotal + vatTotal).ToString("N2")
        End Sub

        Private Sub Update_Click(sender As Object, e As EventArgs)
            If selectedPOID <= 0 Then
                MessageBox.Show("Please select a purchase order to update.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim hasItems As Boolean = False
            For Each row As DataGridViewRow In dgvLines.Rows
                If Not row.IsNewRow AndAlso row.Cells("ProductID").Value IsNot Nothing Then
                    hasItems = True
                    Exit For
                End If
            Next
            
            If Not hasItems Then
                MessageBox.Show("Please add at least one item to the purchase order.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Try
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    
                    Using tx = conn.BeginTransaction()
                        Try
                            ' Calculate totals from grid
                            Dim subTotal As Decimal = 0
                            Dim vatTotal As Decimal = 0
                            
                            For Each row As DataGridViewRow In dgvLines.Rows
                                If Not row.IsNewRow AndAlso row.Cells("ProductID").Value IsNot Nothing Then
                                    Dim lineTotal As Decimal = Convert.ToDecimal(row.Cells("LineTotal").Value)
                                    Dim isVatable As Boolean = If(row.Cells("IsVatable").Value IsNot Nothing, Convert.ToBoolean(row.Cells("IsVatable").Value), False)
                                    
                                    subTotal += lineTotal
                                    If isVatable Then
                                        vatTotal += lineTotal * 0.15D
                                    End If
                                End If
                            Next
                            
                            ' Update PO header with totals (TotalAmount is computed column, auto-calculated)
                            Dim updateHeaderSql As String = "
                                UPDATE PurchaseOrders 
                                SET Reference = @Reference, 
                                    Notes = @Notes,
                                    SubTotal = @SubTotal,
                                    VATAmount = @VATAmount,
                                    ModifiedBy = @UserID,
                                    ModifiedDate = GETDATE()
                                WHERE PurchaseOrderID = @PurchaseOrderID"
                            
                            Using cmd As New SqlCommand(updateHeaderSql, conn, tx)
                                cmd.Parameters.AddWithValue("@PurchaseOrderID", selectedPOID)
                                cmd.Parameters.AddWithValue("@Reference", If(String.IsNullOrWhiteSpace(txtReference.Text), DBNull.Value, txtReference.Text.Trim()))
                                cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrWhiteSpace(txtNotes.Text), DBNull.Value, txtNotes.Text.Trim()))
                                cmd.Parameters.AddWithValue("@SubTotal", subTotal)
                                cmd.Parameters.AddWithValue("@VATAmount", vatTotal)
                                cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            ' Delete existing lines
                            Using cmd As New SqlCommand("DELETE FROM PurchaseOrderLines WHERE PurchaseOrderID = @PurchaseOrderID", conn, tx)
                                cmd.Parameters.AddWithValue("@PurchaseOrderID", selectedPOID)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            ' Insert updated lines
                            For Each row As DataGridViewRow In dgvLines.Rows
                                If Not row.IsNewRow AndAlso row.Cells("ProductID").Value IsNot Nothing Then
                                    Dim productId As Integer = Convert.ToInt32(row.Cells("ProductID").Value)
                                    Dim productName As String = row.Cells("Product").Value?.ToString()
                                    Dim isVatable As Boolean = If(row.Cells("IsVatable").Value IsNot Nothing, Convert.ToBoolean(row.Cells("IsVatable").Value), True)
                                    
                                    ' Determine if this is a RawMaterial or External Product
                                    Dim productRow = allProducts.AsEnumerable().FirstOrDefault(Function(r) Convert.ToInt32(r("ProductID")) = productId)
                                    Dim itemSource As String = If(productRow IsNot Nothing, productRow("ItemSource").ToString(), "PR")
                                    
                                    Dim qty As Decimal = Convert.ToDecimal(row.Cells("Qty").Value)
                                    Dim unitCost As Decimal = Convert.ToDecimal(row.Cells("UnitPrice").Value)
                                    
                                    Dim insertLineSql As String = "
                                        INSERT INTO PurchaseOrderLines (PurchaseOrderID, MaterialID, ProductID, OrderedQuantity, UnitCost, IsVatable, ItemSource)
                                        VALUES (@PurchaseOrderID, @MaterialID, @ProductID, @OrderedQuantity, @UnitCost, @IsVatable, @ItemSource)"
                                    
                                    Using cmd As New SqlCommand(insertLineSql, conn, tx)
                                        cmd.Parameters.AddWithValue("@PurchaseOrderID", selectedPOID)
                                        
                                        ' If RawMaterial, set MaterialID; if Product, set ProductID
                                        If itemSource = "RM" Then
                                            cmd.Parameters.AddWithValue("@MaterialID", productId)
                                            cmd.Parameters.AddWithValue("@ProductID", DBNull.Value)
                                        Else
                                            cmd.Parameters.AddWithValue("@MaterialID", DBNull.Value)
                                            cmd.Parameters.AddWithValue("@ProductID", productId)
                                        End If
                                        
                                        cmd.Parameters.AddWithValue("@OrderedQuantity", qty)
                                        cmd.Parameters.AddWithValue("@UnitCost", unitCost)
                                        cmd.Parameters.AddWithValue("@IsVatable", isVatable)
                                        cmd.Parameters.AddWithValue("@ItemSource", itemSource)
                                        cmd.ExecuteNonQuery()
                                    End Using
                                End If
                            Next
                            
                            tx.Commit()
                            
                            MessageBox.Show("Purchase order updated successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            
                            ' Reload to show updated data
                            LoadPODetails()
                            
                        Catch
                            tx.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error updating purchase order: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub Print_Click(sender As Object, e As EventArgs)
            Try
                If String.IsNullOrEmpty(currentPONumber) Then
                    MessageBox.Show("Please select a Purchase Order first before printing.", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Return
                End If
                
                Dim printDialog As New PrintDialog()
                printDialog.Document = printDocument
                
                If printDialog.ShowDialog() = DialogResult.OK Then
                    printDocument.Print()
                End If
            Catch ex As Exception
                MessageBox.Show($"Error printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub PrintDocument_PrintPage(sender As Object, e As PrintPageEventArgs)
            Try
                Dim normalFont As New Font("Arial", 9)
                Dim headerFont As New Font("Arial", 10, FontStyle.Bold)
                Dim titleFont As New Font("Arial", 14, FontStyle.Bold)
                Dim smallFont As New Font("Arial", 8)
                
                Dim printY As Integer = 50
                
                ' Title
                e.Graphics.DrawString("PURCHASE ORDER", titleFont, Brushes.Black, 300, printY)
                printY += 40
                
                ' PO Details
                e.Graphics.DrawString($"PO Number: {currentPONumber}", headerFont, Brushes.Black, 50, printY)
                e.Graphics.DrawString($"Date: {txtOrderDate.Text}", normalFont, Brushes.Black, 500, printY)
                printY += 25
                
                e.Graphics.DrawString($"Supplier: {currentSupplierName}", normalFont, Brushes.Black, 50, printY)
                printY += 25
                
                e.Graphics.DrawString($"Required Date: {txtRequiredDate.Text}", normalFont, Brushes.Black, 50, printY)
                printY += 25
                
                If Not String.IsNullOrWhiteSpace(txtReference.Text) Then
                    e.Graphics.DrawString($"Reference: {txtReference.Text}", normalFont, Brushes.Black, 50, printY)
                    printY += 25
                End If
                
                If Not String.IsNullOrWhiteSpace(txtNotes.Text) Then
                    e.Graphics.DrawString($"Notes: {txtNotes.Text}", normalFont, Brushes.Black, 50, printY)
                    printY += 25
                End If
                
                printY += 15
                
                ' Line items header
                e.Graphics.DrawLine(Pens.Black, 50, printY, 750, printY)
                printY += 5
                
                e.Graphics.DrawString("Product/Material", headerFont, Brushes.Black, 50, printY)
                e.Graphics.DrawString("Quantity", headerFont, Brushes.Black, 450, printY)
                e.Graphics.DrawString("Unit Price", headerFont, Brushes.Black, 550, printY)
                e.Graphics.DrawString("Total", headerFont, Brushes.Black, 680, printY)
                printY += 25
                
                e.Graphics.DrawLine(Pens.Black, 50, printY, 750, printY)
                printY += 10
                
                ' Line items
                For Each row As DataGridViewRow In dgvLines.Rows
                    If Not row.IsNewRow AndAlso row.Cells("Product").Value IsNot Nothing Then
                        Dim product As String = row.Cells("Product").Value.ToString()
                        
                        ' Truncate long product names
                        If product.Length > 50 Then
                            product = product.Substring(0, 47) & "..."
                        End If
                        
                        Dim qty = If(row.Cells("Qty").Value, 0D)
                        Dim unitPrice = If(row.Cells("UnitPrice").Value, 0D)
                        Dim lineTotal = If(row.Cells("LineTotal").Value, 0D)
                        
                        e.Graphics.DrawString(product, normalFont, Brushes.Black, 50, printY)
                        e.Graphics.DrawString(Convert.ToDecimal(qty).ToString("N4"), normalFont, Brushes.Black, 450, printY)
                        e.Graphics.DrawString(Convert.ToDecimal(unitPrice).ToString("N4"), normalFont, Brushes.Black, 550, printY)
                        e.Graphics.DrawString(Convert.ToDecimal(lineTotal).ToString("N4"), normalFont, Brushes.Black, 680, printY)
                        printY += 20
                    End If
                Next
                
                printY += 10
                e.Graphics.DrawLine(Pens.Black, 50, printY, 780, printY)
                printY += 20
                
                ' Totals
                e.Graphics.DrawString("Sub Total (Excl VAT):", normalFont, Brushes.Black, 550, printY)
                e.Graphics.DrawString($"R {txtSubTotal.Text}", normalFont, Brushes.Black, 680, printY)
                printY += 25
                
                e.Graphics.DrawString("VAT (15%):", normalFont, Brushes.Black, 550, printY)
                e.Graphics.DrawString($"R {txtVAT.Text}", normalFont, Brushes.Black, 680, printY)
                printY += 25
                
                ' Draw line before total
                e.Graphics.DrawLine(Pens.Black, 550, printY, 780, printY)
                printY += 10
                
                e.Graphics.DrawString("TOTAL (Incl VAT):", headerFont, Brushes.Black, 550, printY)
                e.Graphics.DrawString($"R {txtTotal.Text}", headerFont, Brushes.Black, 680, printY)
                
                ' Footer
                printY = 1050
                e.Graphics.DrawString($"Printed: {DateTime.Now:dd MMM yyyy HH:mm}", smallFont, Brushes.Gray, 50, printY)
                
                e.HasMorePages = False
            Catch ex As Exception
                MessageBox.Show($"Error during print: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
