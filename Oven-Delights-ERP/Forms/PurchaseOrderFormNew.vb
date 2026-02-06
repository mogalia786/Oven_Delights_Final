' PurchaseOrderFormNew.vb - Modern, Clean Purchase Order Form
' FIXES: Black dropdown, Last Paid Price, Professional styling
Imports System.Windows.Forms
Imports System.Data
Imports System.Drawing
Imports System.Drawing.Printing
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports Oven_Delights_ERP.UI

Public Class PurchaseOrderFormNew
    Inherits Form
    Implements UI.ISidebarProvider

    Private ReadOnly service As New StockroomService()
    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private currentBranchId As Integer
    Private isSuperAdmin As Boolean
    Private printDocument As New PrintDocument()
    Private savedPONumber As String = ""

    ' Header controls
    Private txtSupplier As TextBox
    Private cboBranch As ComboBox
    Private dtpOrderDate As DateTimePicker
    Private dtpRequiredDate As DateTimePicker
    Private txtReference As TextBox
    Private txtNotes As TextBox
    Private cboProductType As ComboBox
    Private lblPONumber As Label

    ' Grid
    Private dgvLines As DataGridView
    
    ' Product autocomplete (TEXTBOX not ComboBox!)
    Private productLookup As New Dictionary(Of String, Integer)()
    Private allProducts As DataTable

    ' Totals
    Private txtSubTotal As TextBox
    Private txtVAT As TextBox
    Private txtTotal As TextBox
    Private btnSave As Button
    Private btnClose As Button
    
    ' Track if PO has been saved
    Private poHasBeenSaved As Boolean = False

    ' Lookups
    Private suppliers As DataTable
    Private branches As DataTable

    Public Sub New()
        Me.WindowState = FormWindowState.Maximized
        Me.Text = "✓ Purchase Order - NEW MODERN FORM"
        Me.BackColor = Color.White

        currentBranchId = service.GetCurrentUserBranchId()
        isSuperAdmin = service.IsCurrentUserSuperAdmin()

        InitializeComponent()
        LoadLookups()
        SetupSupplierAutocomplete()
        
        ' Add event handler for branch change
        AddHandler cboBranch.SelectedIndexChanged, AddressOf cboBranch_SelectedIndexChanged
    End Sub

    Private Sub InitializeComponent()
        ' Modern header
        Dim header As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 150,
            .BackColor = Color.FromArgb(245, 245, 245),
            .Padding = New Padding(20)
        }

        ' Row 1
        Dim lblSupplier As New Label With {.Text = "Supplier", .Location = New Point(20, 15), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
        txtSupplier = New TextBox With {.Location = New Point(20, 38), .Width = 280, .Font = New Font("Segoe UI", 10.0F)}

        Dim lblOrderDate As New Label With {.Text = "Order Date", .Location = New Point(520, 15), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
        dtpOrderDate = New DateTimePicker With {.Location = New Point(520, 38), .Width = 140, .Format = DateTimePickerFormat.Short, .Font = New Font("Segoe UI", 10.0F)}

        Dim lblRequiredDate As New Label With {.Text = "Required Date", .Location = New Point(680, 15), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
        dtpRequiredDate = New DateTimePicker With {.Location = New Point(680, 38), .Width = 140, .Format = DateTimePickerFormat.Short, .Font = New Font("Segoe UI", 10.0F)}

        lblPONumber = New Label With {.Text = "PO: (unsaved)", .Location = New Point(850, 38), .Font = New Font("Segoe UI", 11.0F, FontStyle.Bold), .ForeColor = Color.FromArgb(231, 76, 60), .AutoSize = True}

        ' Row 2
        Dim lblReference As New Label With {.Text = "Reference", .Location = New Point(20, 80), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
        txtReference = New TextBox With {.Location = New Point(20, 103), .Width = 220, .Font = New Font("Segoe UI", 10.0F)}

        Dim lblNotes As New Label With {.Text = "Notes", .Location = New Point(260, 80), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
        txtNotes = New TextBox With {.Location = New Point(260, 103), .Width = 340, .Font = New Font("Segoe UI", 10.0F)}

        Dim lblProductType As New Label With {.Text = "Purchase Type", .Location = New Point(620, 80), .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold), .AutoSize = True}
        cboProductType = New ComboBox With {
            .Location = New Point(620, 103),
            .Width = 150,
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Font = New Font("Segoe UI", 10.0F),
            .BackColor = Color.White,
            .ForeColor = Color.Black,
            .FlatStyle = FlatStyle.Flat
        }
        cboProductType.Items.AddRange({"External Product", "Raw Material"})
        cboProductType.SelectedIndex = 1
        AddHandler cboProductType.SelectedIndexChanged, AddressOf ProductType_Changed

        ' Branch (hidden by default)
        cboBranch = New ComboBox With {.Location = New Point(320, 38), .Width = 180, .Visible = False, .DropDownStyle = ComboBoxStyle.DropDownList}

        header.Controls.AddRange({lblSupplier, txtSupplier, lblOrderDate, dtpOrderDate, lblRequiredDate, dtpRequiredDate, lblPONumber, lblReference, txtReference, lblNotes, txtNotes, lblProductType, cboProductType, cboBranch})

        ' Modern grid with TEXTBOX for product selection
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

        ' Columns - TEXTBOX for product (not ComboBox!)
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductID", .Visible = False})
        
        ' AUTOCOMPLETE TEXTBOX COLUMN
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
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LastCost", .HeaderText = "Avg Cost", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N4", .ForeColor = Color.FromArgb(120, 120, 120)}})
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

        btnSave = New Button With {
            .Text = "💾 Save Purchase Order",
            .Location = New Point(480, 30),
            .Width = 200,
            .Height = 40,
            .Font = New Font("Segoe UI", 11.0F, FontStyle.Bold),
            .BackColor = Color.FromArgb(46, 204, 113),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnSave.FlatAppearance.BorderSize = 0
        AddHandler btnSave.Click, AddressOf Save_Click
        
        Dim btnPrint As New Button With {
            .Text = "🖨️ Print PO",
            .Location = New Point(700, 30),
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
            .Location = New Point(860, 30),
            .Width = 150,
            .Height = 40,
            .Font = New Font("Segoe UI", 11.0F, FontStyle.Bold),
            .BackColor = Color.FromArgb(220, 53, 69),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, AddressOf btnClose_Click

        footer.Controls.AddRange({lblSubTotal, txtSubTotal, lblVAT, txtVAT, lblTotal, txtTotal, btnSave, btnPrint, btnClose})

        Me.Controls.Add(dgvLines)
        Me.Controls.Add(footer)
        Me.Controls.Add(header)
    End Sub

    Private Sub LoadLookups()
        Try
            suppliers = service.GetSuppliers()
            
            ' Load branches for all users (but lock for non-super admins)
            branches = service.GetBranchesLookup()
            cboBranch.DataSource = branches
            cboBranch.DisplayMember = "BranchName"
            cboBranch.ValueMember = "BranchID"
            cboBranch.SelectedValue = currentBranchId
            
            ' Lock branch dropdown for non-super admins
            BranchHelper.LockBranchDropdown(cboBranch, isSuperAdmin, currentBranchId)
            
            ' Get current branch ID for filtering products
            Dim branchId = BranchHelper.GetEffectiveBranchId(cboBranch, isSuperAdmin, currentBranchId)
            allProducts = service.GetPOItemsLookup(branchId)
            LoadProductLookup()
            
        Catch ex As Exception
            MessageBox.Show($"Error loading data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadProductLookup()
        productLookup.Clear()
        If allProducts IsNot Nothing Then
            Dim currentBranchProducts As New Dictionary(Of String, Integer)()
            Dim otherBranchProducts As New Dictionary(Of String, Integer)()
            
            ' Separate products by branch - prefer current branch
            For Each row As DataRow In allProducts.Rows
                Dim name As String = row("MaterialName").ToString()
                Dim id As Integer = Convert.ToInt32(row("MaterialID"))
                
                ' Check if this product belongs to current branch (from allProducts query)
                ' Since we're filtering by branch in GetPOItemsLookup, all should be current branch
                If Not productLookup.ContainsKey(name) Then
                    productLookup.Add(name, id)
                End If
            Next
        End If
    End Sub

    Private Sub SetupSupplierAutocomplete()
        If suppliers IsNot Nothing AndAlso suppliers.Rows.Count > 0 Then
            Dim ac As New AutoCompleteStringCollection()
            For Each r As DataRow In suppliers.Rows
                ac.Add(r("CompanyName").ToString())
            Next
            txtSupplier.AutoCompleteMode = AutoCompleteMode.SuggestAppend
            txtSupplier.AutoCompleteSource = AutoCompleteSource.CustomSource
            txtSupplier.AutoCompleteCustomSource = ac
        End If
    End Sub

    Private Sub ProductType_Changed(sender As Object, e As EventArgs)
        ' Product type dropdown is now informational only - all items are loaded
        ' No need to reload products
    End Sub

    Private Sub Grid_EditingControlShowing(sender As Object, e As DataGridViewEditingControlShowingEventArgs)
        If dgvLines.CurrentCell Is Nothing Then Return
        
        Dim txt = TryCast(e.Control, TextBox)
        If txt Is Nothing Then Return
        
        ' Clear any previous autocomplete
        txt.AutoCompleteMode = AutoCompleteMode.None
        txt.AutoCompleteSource = AutoCompleteSource.None
        txt.AutoCompleteCustomSource = Nothing
        
        ' Setup autocomplete ONLY for Product column (index 1)
        If dgvLines.CurrentCell.ColumnIndex = 1 AndAlso dgvLines.Columns(1).Name = "Product" Then
            ' Setup autocomplete
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
        
        ' When product name is entered, lookup ID and prices
        If e.ColumnIndex = dgvLines.Columns("Product").Index Then
            Dim productName = row.Cells("Product").Value?.ToString()
            If Not String.IsNullOrEmpty(productName) AndAlso productLookup.ContainsKey(productName) Then
                Dim productId = productLookup(productName)
                row.Cells("ProductID").Value = productId
                LoadPricesForProduct(row, productId)
            End If
        End If
    End Sub

    Private Sub LoadPricesForProduct(row As DataGridViewRow, productId As Integer)
        Try
            Dim lastPaid As Decimal = 0
            Dim avgCost As Decimal = 0
            Dim isVatable As Boolean = True ' Default to true
            Dim branchId = If(isSuperAdmin AndAlso cboBranch.SelectedValue IsNot Nothing, Convert.ToInt32(cboBranch.SelectedValue), currentBranchId)
            
            ' Check if this is External Product or Raw Material
            ' Get latest price from ProductPriceHistory table
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                ' First, try to get latest price from price history
                Using cmd As New SqlCommand("sp_GetLatestProductPrice", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ProductID", productId)
                    cmd.Parameters.AddWithValue("@BranchID", AppSession.CurrentUser.BranchID)
                    
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            lastPaid = reader.GetDecimal(0) ' CostPrice from price history
                            ' Show last purchase info in tooltip or status
                            Dim lastDate = reader.GetDateTime(1)
                            Dim lastSupplier = reader.GetString(2)
                            row.Cells("LastPaid").ToolTipText = $"Last purchased from {lastSupplier} on {lastDate:yyyy-MM-dd}"
                        End If
                    End Using
                End Using
                
                ' Get current average cost and VAT status from Demo_Retail_Price
                Using cmd As New SqlCommand("SELECT ISNULL(rp.CostPrice, 0), ISNULL(p.IsVatable, 1) FROM Demo_Retail_Product p LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID WHERE p.ProductID = @id AND p.BranchID = @branch", conn)
                    cmd.Parameters.AddWithValue("@id", productId)
                    cmd.Parameters.AddWithValue("@branch", AppSession.CurrentUser.BranchID)
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            avgCost = reader.GetDecimal(0)
                            isVatable = reader.GetBoolean(1)
                        End If
                    End Using
                End Using
            End Using
            
            ' Set the values
            row.Cells("LastPaid").Value = If(lastPaid > 0, lastPaid, avgCost)
            row.Cells("LastCost").Value = avgCost
            row.Cells("IsVatable").Value = isVatable
            
            ' Auto-fill unit price with last paid if empty
            ' IMPORTANT: UnitPrice column is "Unit Price (Excl VAT)"
            ' Prices stored in ProductPriceHistory and Demo_Retail_Price are ALREADY Excl VAT
            ' No conversion needed - use price as-is regardless of vatable status
            If row.Cells("UnitPrice").Value Is Nothing OrElse Convert.ToDecimal(row.Cells("UnitPrice").Value) = 0 Then
                Dim priceToUse As Decimal = If(lastPaid > 0, lastPaid, avgCost)
                row.Cells("UnitPrice").Value = priceToUse
            End If
            
            CalculateLineTotal(row)
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Error loading prices: {ex.Message}")
        End Try
    End Sub

    Private Sub Grid_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex < 0 Then Return
        Dim row = dgvLines.Rows(e.RowIndex)
        
        If e.ColumnIndex = dgvLines.Columns("Qty").Index OrElse 
           e.ColumnIndex = dgvLines.Columns("UnitPrice").Index OrElse
           e.ColumnIndex = dgvLines.Columns("IsVatable").Index Then
            CalculateLineTotal(row)
        End If
    End Sub

    Private Sub CalculateLineTotal(row As DataGridViewRow)
        Try
            Dim qty As Decimal = 0
            Dim priceExclVAT As Decimal = 0
            Dim isVatable As Boolean = False
            
            If row.Cells("Qty").Value IsNot Nothing Then
                Decimal.TryParse(row.Cells("Qty").Value.ToString(), qty)
            End If
            If row.Cells("UnitPrice").Value IsNot Nothing Then
                Decimal.TryParse(row.Cells("UnitPrice").Value.ToString(), priceExclVAT)
            End If
            If row.Cells("IsVatable").Value IsNot Nothing Then
                Boolean.TryParse(row.Cells("IsVatable").Value.ToString(), isVatable)
            End If
            
            ' Line Total = Qty * Price INCLUDING VAT
            Dim priceInclVAT As Decimal = If(isVatable, priceExclVAT * 1.15D, priceExclVAT)
            row.Cells("LineTotal").Value = qty * priceInclVAT
            
            RecalculateTotals()
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Error calculating line total: {ex.Message}")
        End Try
    End Sub

    Private Sub RecalculateTotals()
        Try
            ' USER ENTERS: Unit Price INCLUDING VAT (e.g., 345.00)
            ' LineTotal = Qty * UnitPrice = INCLUDING VAT (e.g., 100 * 345 = 34,500)
            ' Total = Sum of LineTotals = INCLUDING VAT (e.g., 34,500)
            ' CALCULATE BACKWARDS:
            ' Calculate totals - price entered is actual price paid
            ' Vatable items: Price includes VAT, so SubTotal = Price/1.15, VAT = Price - SubTotal
            ' Non-vatable items: Price has no VAT, so SubTotal = Price, VAT = 0
            ' Example: Apple R100 (vatable) → SubTotal R86.96, VAT R13.04
            '          Flour R10 (non-vatable) → SubTotal R10, VAT R0
            '          Total: SubTotal R96.96, VAT R13.04, Total R110
            
            Dim subTotalVatable As Decimal = 0
            Dim subTotalNonVatable As Decimal = 0
            Dim vatTotal As Decimal = 0
            
            For Each row As DataGridViewRow In dgvLines.Rows
                If row.IsNewRow Then Continue For
                If row.Cells("LineTotal").Value IsNot Nothing Then
                    Dim lineTotal As Decimal = Convert.ToDecimal(row.Cells("LineTotal").Value)
                    Dim isVatable As Boolean = If(row.Cells("IsVatable").Value IsNot Nothing, Convert.ToBoolean(row.Cells("IsVatable").Value), True)
                    
                    If isVatable Then
                        ' Price includes VAT - extract excl VAT and VAT amount
                        Dim lineTotalExclVAT As Decimal = Math.Round(lineTotal / 1.15D, 2)
                        Dim lineVAT As Decimal = lineTotal - lineTotalExclVAT
                        subTotalVatable += lineTotalExclVAT
                        vatTotal += lineVAT
                    Else
                        ' Price has no VAT - it's already excl VAT
                        subTotalNonVatable += lineTotal
                    End If
                End If
            Next
            
            Dim subTotal As Decimal = subTotalVatable + subTotalNonVatable
            Dim total As Decimal = subTotal + vatTotal
            
            txtSubTotal.Text = subTotal.ToString("N4")  ' Excl VAT
            txtVAT.Text = vatTotal.ToString("N4")       ' VAT amount (only on vatable items)
            txtTotal.Text = total.ToString("N4")        ' Total
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Error calculating totals: {ex.Message}")
        End Try
    End Sub

    Private Function GetSupplierID() As Integer
        Dim name = txtSupplier.Text.Trim()
        If String.IsNullOrEmpty(name) Then Return 0
        Dim found = suppliers.Select($"CompanyName = '{name.Replace("'", "''")}'")
        If found.Length = 0 Then Return 0
        Return Convert.ToInt32(found(0)("SupplierID"))
    End Function

    Private Sub Save_Click(sender As Object, e As EventArgs)
        Try
            ' Validate
            If String.IsNullOrWhiteSpace(txtSupplier.Text) Then
                MessageBox.Show("Please select a supplier", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim supplierId = GetSupplierID()
            If supplierId = 0 Then
                MessageBox.Show("Invalid supplier selected", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Collect lines and update IsVatable status
            Dim lines As New List(Of (ProductID As Integer, Qty As Decimal, Price As Decimal))
            Dim branchId = If(isSuperAdmin AndAlso cboBranch.SelectedValue IsNot Nothing, Convert.ToInt32(cboBranch.SelectedValue), currentBranchId)
            
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                For Each row As DataGridViewRow In dgvLines.Rows
                    If row.IsNewRow Then Continue For
                    If row.Cells("ProductID").Value Is Nothing Then Continue For
                    
                    Dim pid = Convert.ToInt32(row.Cells("ProductID").Value)
                    Dim qty As Decimal = 0
                    Dim price As Decimal = 0
                    Dim isVatable As Boolean = If(row.Cells("IsVatable").Value IsNot Nothing, Convert.ToBoolean(row.Cells("IsVatable").Value), True)
                    
                    If row.Cells("Qty").Value IsNot Nothing Then
                        Decimal.TryParse(row.Cells("Qty").Value.ToString(), qty)
                    End If
                    If row.Cells("UnitPrice").Value IsNot Nothing Then
                        Decimal.TryParse(row.Cells("UnitPrice").Value.ToString(), price)
                    End If
                    
                    If qty > 0 AndAlso price > 0 Then
                        lines.Add((pid, qty, price))
                        
                        ' Update IsVatable in Demo_Retail_Product for this branch
                        Dim updateVatSql = "UPDATE Demo_Retail_Product SET IsVatable = @IsVatable WHERE ProductID = @ProductID AND BranchID = @BranchID"
                        Using cmd As New SqlCommand(updateVatSql, conn)
                            cmd.Parameters.AddWithValue("@IsVatable", isVatable)
                            cmd.Parameters.AddWithValue("@ProductID", pid)
                            cmd.Parameters.AddWithValue("@BranchID", branchId)
                            cmd.ExecuteNonQuery()
                        End Using
                    End If
                Next
            End Using
            
            If lines.Count = 0 Then
                MessageBox.Show("Please add at least one line item", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Save PO
            Dim isExternal = (cboProductType.SelectedIndex = 0)
            
            Dim poNumber = service.CreatePurchaseOrder(
                supplierId,
                branchId,
                dtpOrderDate.Value,
                dtpRequiredDate.Value,
                txtReference.Text,
                txtNotes.Text,
                lines,
                isExternal
            )
            
            savedPONumber = poNumber
            lblPONumber.Text = $"PO: {poNumber}"
            lblPONumber.ForeColor = Color.FromArgb(46, 204, 113)
            
            ' Enable print button
            Dim btnPrint = DirectCast(Me.Controls.Find("btnPrint", True)(0), Button)
            btnPrint.Enabled = True
            
            ' Mark as saved
            poHasBeenSaved = True
            
            MessageBox.Show($"Purchase Order {poNumber} created successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            
        Catch ex As Exception
            MessageBox.Show($"Error saving PO: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs)
        Me.Close()
    End Sub

    Protected Overrides Sub OnFormClosing(e As FormClosingEventArgs)
        MyBase.OnFormClosing(e)
        
        ' If PO has already been saved, just close
        If poHasBeenSaved Then
            Return
        End If
        
        ' Check if there's any data entered
        Dim hasData As Boolean = False
        
        ' Check if supplier is selected
        If Not String.IsNullOrWhiteSpace(txtSupplier.Text) Then
            hasData = True
        End If
        
        ' Check if any lines have been added
        If Not hasData Then
            For Each row As DataGridViewRow In dgvLines.Rows
                If Not row.IsNewRow AndAlso row.Cells("ProductID").Value IsNot Nothing Then
                    hasData = True
                    Exit For
                End If
            Next
        End If
        
        ' If no data entered, just close
        If Not hasData Then
            Return
        End If
        
        ' Warn user about unsaved changes
        Dim result = MessageBox.Show(
            "You have unsaved changes. Do you want to close without saving?" & Environment.NewLine & Environment.NewLine &
            "Click 'Yes' to close without saving" & Environment.NewLine &
            "Click 'No' to go back and save your Purchase Order",
            "Unsaved Changes",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Warning,
            MessageBoxDefaultButton.Button2)
        
        If result = DialogResult.No Then
            e.Cancel = True
        End If
    End Sub

    Private Sub cboBranch_SelectedIndexChanged(sender As Object, e As EventArgs)
        ' Reload products when branch changes
        If cboBranch.SelectedValue IsNot Nothing Then
            Dim branchId = BranchHelper.GetEffectiveBranchId(cboBranch, isSuperAdmin, currentBranchId)
            allProducts = service.GetPOItemsLookup(branchId)
            LoadProductLookup()
            
            ' Clear grid lines since products changed
            dgvLines.Rows.Clear()
        End If
    End Sub

    ' ISidebarProvider implementation
    Public Event SidebarContextChanged As EventHandler Implements ISidebarProvider.SidebarContextChanged
    
    Public Function BuildSidebarPanel() As Panel Implements ISidebarProvider.BuildSidebarPanel
        ' Return empty panel - no sidebar needed for this form
        Return New Panel()
    End Function
End Class
