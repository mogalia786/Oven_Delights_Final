' PurchaseOrderFormNew.vb - Modern, Clean Purchase Order Form
' FIXES: Black dropdown, Last Paid Price, Professional styling
Imports System.Windows.Forms
Imports System.Data
Imports System.Drawing
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
        
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Qty", .HeaderText = "Quantity", .Width = 100, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N2"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "UnitPrice", .HeaderText = "Unit Price (Incl VAT)", .Width = 140, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N2"}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LastPaid", .HeaderText = "Last Paid", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N2", .ForeColor = Color.FromArgb(100, 100, 100)}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LastCost", .HeaderText = "Avg Cost", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N2", .ForeColor = Color.FromArgb(120, 120, 120)}})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LineTotal", .HeaderText = "Line Total", .Width = 140, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N2", .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold)}})

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

        footer.Controls.AddRange({lblSubTotal, txtSubTotal, lblVAT, txtVAT, lblTotal, txtTotal, btnSave})

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
            For Each row As DataRow In allProducts.Rows
                Dim name As String = row("MaterialName").ToString()
                Dim id As Integer = Convert.ToInt32(row("MaterialID"))
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
        ' Reload products based on type
        LoadProductLookup()
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
            
            If cboProductType.SelectedIndex = 0 Then
                ' External Product - Demo_Retail_Price has: CostPrice (Excl VAT), SellingPrice (Incl VAT)
                Dim branchId = If(isSuperAdmin AndAlso cboBranch.SelectedValue IsNot Nothing, Convert.ToInt32(cboBranch.SelectedValue), currentBranchId)
                
                System.Diagnostics.Debug.WriteLine($"LoadPricesForProduct: ProductID={productId}, BranchID={branchId}")
                
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    ' CostPrice = Last price paid to supplier (Excl VAT)
                    ' Convert to Incl VAT for display (multiply by 1.15)
                    Using cmd As New SqlCommand("SELECT ISNULL(CostPrice, 0) * 1.15, ISNULL(CostPrice, 0) FROM dbo.Demo_Retail_Price WHERE ProductID = @id AND BranchID = @branchId", conn)
                        cmd.Parameters.AddWithValue("@id", productId)
                        cmd.Parameters.AddWithValue("@branchId", branchId)
                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                lastPaid = reader.GetDecimal(0)  ' CostPrice * 1.15 (Incl VAT)
                                avgCost = reader.GetDecimal(1)   ' CostPrice (Excl VAT)
                                System.Diagnostics.Debug.WriteLine($"FOUND: LastPaid={lastPaid}, AvgCost={avgCost}")
                            Else
                                System.Diagnostics.Debug.WriteLine($"NO RECORD FOUND for ProductID={productId}, BranchID={branchId}")
                            End If
                        End Using
                    End Using
                End Using
            Else
                ' Raw Material
                Dim supplierId = GetSupplierID()
                Dim lpp = service.GetLastPaidPrice(supplierId, productId)
                If lpp.HasValue Then lastPaid = lpp.Value
                avgCost = service.GetMaterialLastCost(productId)
            End If
            
            row.Cells("LastPaid").Value = lastPaid
            row.Cells("LastCost").Value = avgCost
            
            ' Auto-fill unit price if empty
            If row.Cells("UnitPrice").Value Is Nothing OrElse Convert.ToDecimal(row.Cells("UnitPrice").Value) = 0 Then
                row.Cells("UnitPrice").Value = If(lastPaid > 0, lastPaid, avgCost)
            End If
            
            CalculateLineTotal(row)
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Error loading prices: {ex.Message}")
        End Try
    End Sub

    Private Sub Grid_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex < 0 Then Return
        Dim row = dgvLines.Rows(e.RowIndex)
        
        If e.ColumnIndex = dgvLines.Columns("Qty").Index OrElse e.ColumnIndex = dgvLines.Columns("UnitPrice").Index Then
            CalculateLineTotal(row)
        End If
    End Sub

    Private Sub CalculateLineTotal(row As DataGridViewRow)
        Try
            Dim qty As Decimal = 0
            Dim price As Decimal = 0
            
            If row.Cells("Qty").Value IsNot Nothing Then
                Decimal.TryParse(row.Cells("Qty").Value.ToString(), qty)
            End If
            If row.Cells("UnitPrice").Value IsNot Nothing Then
                Decimal.TryParse(row.Cells("UnitPrice").Value.ToString(), price)
            End If
            
            row.Cells("LineTotal").Value = qty * price
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
            ' SubTotal = Total ÷ 1.15 = EXCLUDING VAT (e.g., 34,500 ÷ 1.15 = 30,000)
            ' VAT = Total - SubTotal (e.g., 34,500 - 30,000 = 4,500)
            
            Dim totalInclVAT As Decimal = 0
            
            For Each row As DataGridViewRow In dgvLines.Rows
                If row.IsNewRow Then Continue For
                If row.Cells("LineTotal").Value IsNot Nothing Then
                    totalInclVAT += Convert.ToDecimal(row.Cells("LineTotal").Value)
                End If
            Next
            
            ' Calculate BACKWARDS from VAT-inclusive total
            Dim subTotal As Decimal = Math.Round(totalInclVAT / 1.15D, 2)
            Dim vat As Decimal = Math.Round(totalInclVAT - subTotal, 2)
            
            txtSubTotal.Text = subTotal.ToString("N2")  ' Excl VAT (calculated)
            txtVAT.Text = vat.ToString("N2")            ' VAT amount (calculated)
            txtTotal.Text = totalInclVAT.ToString("N2") ' Incl VAT (entered)
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
            
            ' Collect lines
            Dim lines As New List(Of (ProductID As Integer, Qty As Decimal, Price As Decimal))
            For Each row As DataGridViewRow In dgvLines.Rows
                If row.IsNewRow Then Continue For
                If row.Cells("ProductID").Value Is Nothing Then Continue For
                
                Dim pid = Convert.ToInt32(row.Cells("ProductID").Value)
                Dim qty As Decimal = 0
                Dim price As Decimal = 0
                
                If row.Cells("Qty").Value IsNot Nothing Then
                    Decimal.TryParse(row.Cells("Qty").Value.ToString(), qty)
                End If
                If row.Cells("UnitPrice").Value IsNot Nothing Then
                    Decimal.TryParse(row.Cells("UnitPrice").Value.ToString(), price)
                End If
                
                If qty > 0 AndAlso price > 0 Then
                    lines.Add((pid, qty, price))
                End If
            Next
            
            If lines.Count = 0 Then
                MessageBox.Show("Please add at least one line item", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Save PO
            Dim branchId = If(isSuperAdmin AndAlso cboBranch.SelectedValue IsNot Nothing, Convert.ToInt32(cboBranch.SelectedValue), currentBranchId)
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
            
            lblPONumber.Text = $"PO: {poNumber}"
            MessageBox.Show($"Purchase Order {poNumber} created successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            
            ' Close the form after successful save
            Me.Close()
            
        Catch ex As Exception
            MessageBox.Show($"Error saving PO: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
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
