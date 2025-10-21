Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Partial Class POSForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _isSuperAdmin As Boolean
    Private ReadOnly _sessionBranchId As Integer
    Private _currentBranchId As Integer
    Private _cartItems As New DataTable()
    Private _currentSubtotal As Decimal = 0
    Private _currentVAT As Decimal = 0
    Private _currentTotal As Decimal = 0
    Private _tenderType As String = "Cash"

    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrWhiteSpace(_connString) Then
            MessageBox.Show("Missing connection string 'OvenDelightsERPConnectionString' in App.config.", "Config Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
        _isSuperAdmin = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        _sessionBranchId = If(AppSession.CurrentUser IsNot Nothing AndAlso AppSession.CurrentUser.BranchID.HasValue, AppSession.CurrentUser.BranchID.Value, 0)
        _currentBranchId = _sessionBranchId
        
        InitializeCart()
        LoadBranches()
        SetupEventHandlers()
        
        ' Hide branch selector for non-super admin
        If Not _isSuperAdmin Then
            lblBranch.Visible = False
            cboBranch.Visible = False
        End If
        
        ' Focus on scan textbox
        txtScanSKU.Focus()
    End Sub

    Private Sub InitializeCart()
        _cartItems.Columns.Add("Code", GetType(String))
        _cartItems.Columns.Add("SKU", GetType(String))
        _cartItems.Columns.Add("ProductName", GetType(String))
        _cartItems.Columns.Add("Quantity", GetType(Integer))
        _cartItems.Columns.Add("UnitPrice", GetType(Decimal))
        _cartItems.Columns.Add("LineTotal", GetType(Decimal))
        _cartItems.Columns.Add("ProductID", GetType(Integer))
        dgvCart.DataSource = _cartItems
        
        ' Hide ProductID column
        If dgvCart.Columns.Contains("ProductID") Then
            dgvCart.Columns("ProductID").Visible = False
        End If
    End Sub

    Private Sub SetupEventHandlers()
        AddHandler txtScanSKU.KeyDown, AddressOf txtScanSKU_KeyDown
        AddHandler btnLookup.Click, AddressOf btnLookup_Click
        AddHandler dgvProducts.CellDoubleClick, AddressOf dgvProducts_CellDoubleClick
        AddHandler dgvCart.CellValueChanged, AddressOf dgvCart_CellValueChanged
        AddHandler btnCash.Click, AddressOf btnCash_Click
        AddHandler btnCard.Click, AddressOf btnCard_Click
        AddHandler btnFinalizeSale.Click, AddressOf btnFinalizeSale_Click
        AddHandler btnClearCart.Click, AddressOf btnClearCart_Click
        AddHandler cboBranch.SelectedValueChanged, AddressOf cboBranch_SelectedValueChanged
    End Sub

    Private Sub LoadBranches()
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using da As New SqlDataAdapter("SELECT BranchID, BranchName FROM dbo.Branches ORDER BY BranchName", conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    If _isSuperAdmin Then
                        cboBranch.DataSource = dt
                        cboBranch.DisplayMember = "BranchName"
                        cboBranch.ValueMember = "BranchID"
                        cboBranch.SelectedValue = _sessionBranchId
                    Else
                        Dim rows = dt.Select($"BranchID = {_sessionBranchId}")
                        If rows IsNot Nothing AndAlso rows.Length > 0 Then
                            cboBranch.DataSource = dt
                            cboBranch.DisplayMember = "BranchName"
                            cboBranch.ValueMember = "BranchID"
                            cboBranch.SelectedValue = _sessionBranchId
                        End If
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading branches: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub cboBranch_SelectedValueChanged(sender As Object, e As EventArgs)
        If cboBranch.SelectedValue IsNot Nothing Then
            _currentBranchId = Convert.ToInt32(cboBranch.SelectedValue)
        End If
    End Sub

    Private Sub txtScanSKU_KeyDown(sender As Object, e As KeyEventArgs)
        If e.KeyCode = Keys.Enter Then
            e.SuppressKeyPress = True
            LookupProduct()
        End If
    End Sub

    Private Sub btnLookup_Click(sender As Object, e As EventArgs)
        LookupProduct()
    End Sub

    Private Sub LookupProduct()
        Try
            Dim sku As String = txtScanSKU.Text.Trim()
            If String.IsNullOrWhiteSpace(sku) Then
                LoadAllProducts()
                Return
            End If
            
            Using conn As New SqlConnection(_connString)
                ' Try to find exact Code/SKU match first, then partial matches
                Dim sql As String = "SELECT TOP 20 p.ProductID, p.ProductCode AS Code, p.SKU, p.ProductName AS Name, ISNULL(rp.SellingPrice, 0) AS CurrentPrice, ISNULL(s.QtyOnHand, 0) AS Stock " &
                                   "FROM dbo.Products p " &
                                   "LEFT JOIN dbo.Retail_Variant rv ON rv.ProductID = p.ProductID " &
                                   "LEFT JOIN dbo.Retail_Stock s ON s.VariantID = rv.VariantID AND s.BranchID = @bid " &
                                   "LEFT JOIN dbo.Retail_Price rp ON rp.ProductID = p.ProductID AND rp.EffectiveTo IS NULL " &
                                   "WHERE p.ProductCode LIKE @sku OR p.SKU LIKE @sku OR p.ProductName LIKE @sku " &
                                   "ORDER BY CASE WHEN p.ProductCode = @exactSku OR p.SKU = @exactSku THEN 0 ELSE 1 END, p.ProductName"
                
                Using da As New SqlDataAdapter(sql, conn)
                    da.SelectCommand.Parameters.AddWithValue("@bid", _currentBranchId)
                    da.SelectCommand.Parameters.AddWithValue("@sku", $"%{sku}%")
                    da.SelectCommand.Parameters.AddWithValue("@exactSku", sku)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvProducts.DataSource = dt
                    
                    ' If exact Code or SKU match found, add to cart automatically
                    If dt.Rows.Count > 0 Then
                        Dim firstRow = dt.Rows(0)
                        If firstRow("Code").ToString().Equals(sku, StringComparison.OrdinalIgnoreCase) OrElse 
                           firstRow("SKU").ToString().Equals(sku, StringComparison.OrdinalIgnoreCase) Then
                            AddToCart(firstRow)
                            txtScanSKU.Clear()
                            txtScanSKU.Focus()
                        End If
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error looking up product: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadAllProducts()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql As String = "SELECT TOP 50 p.ProductID, p.ProductCode AS Code, p.SKU, p.ProductName AS Name, ISNULL(rp.SellingPrice, 0) AS CurrentPrice, ISNULL(s.QtyOnHand, 0) AS Stock " &
                                   "FROM dbo.Products p " &
                                   "LEFT JOIN dbo.Retail_Variant rv ON rv.ProductID = p.ProductID " &
                                   "LEFT JOIN dbo.Retail_Stock s ON s.VariantID = rv.VariantID AND s.BranchID = @bid " &
                                   "LEFT JOIN dbo.Retail_Price rp ON rp.ProductID = p.ProductID AND rp.EffectiveTo IS NULL " &
                                   "ORDER BY p.ProductCode, p.ProductName"
                
                Using da As New SqlDataAdapter(sql, conn)
                    da.SelectCommand.Parameters.AddWithValue("@bid", _currentBranchId)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvProducts.DataSource = dt
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading products: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvProducts_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex >= 0 AndAlso dgvProducts.Rows(e.RowIndex) IsNot Nothing Then
            Dim row = dgvProducts.Rows(e.RowIndex)
            AddToCart(CType(row.DataBoundItem, DataRowView).Row)
        End If
    End Sub

    Private Sub AddToCart(productRow As DataRow)
        Try
            Dim code As String = If(productRow.Table.Columns.Contains("Code"), productRow("Code").ToString(), "")
            Dim sku As String = productRow("SKU").ToString()
            Dim productName As String = productRow("Name").ToString()
            Dim unitPrice As Decimal = Convert.ToDecimal(productRow("CurrentPrice"))
            Dim productId As Integer = Convert.ToInt32(productRow("ProductID"))
            
            ' Check if item already in cart (by Code or SKU)
            Dim existingRows = _cartItems.Select($"Code = '{code.Replace("'", "''")}' OR SKU = '{sku.Replace("'", "''")}'")
            If existingRows.Length > 0 Then
                ' Increment quantity
                Dim qty As Integer = Convert.ToInt32(existingRows(0)("Quantity"))
                existingRows(0)("Quantity") = qty + 1
                existingRows(0)("LineTotal") = (qty + 1) * unitPrice
            Else
                ' Add new item
                Dim newRow = _cartItems.NewRow()
                newRow("Code") = code
                newRow("SKU") = sku
                newRow("ProductName") = productName
                newRow("Quantity") = 1
                newRow("UnitPrice") = unitPrice
                newRow("LineTotal") = unitPrice
                newRow("ProductID") = productId
                _cartItems.Rows.Add(newRow)
            End If
            
            UpdateCartTotals()
        Catch ex As Exception
            MessageBox.Show("Error adding to cart: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvCart_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex >= 0 AndAlso e.ColumnIndex >= 0 Then
            Dim colName = dgvCart.Columns(e.ColumnIndex).Name
            If colName = "Quantity" Then
                Try
                    Dim row = _cartItems.Rows(e.RowIndex)
                    Dim qty As Integer = Convert.ToInt32(row("Quantity"))
                    Dim unitPrice As Decimal = Convert.ToDecimal(row("UnitPrice"))
                    row("LineTotal") = qty * unitPrice
                    UpdateCartTotals()
                Catch
                End Try
            End If
        End If
    End Sub

    Private Sub UpdateCartTotals()
        _currentSubtotal = 0
        For Each row As DataRow In _cartItems.Rows
            _currentSubtotal += Convert.ToDecimal(row("LineTotal"))
        Next
        
        _currentVAT = _currentSubtotal * 0.15D ' 15% VAT
        _currentTotal = _currentSubtotal + _currentVAT
        
        txtSubtotal.Text = _currentSubtotal.ToString("N2")
        txtVAT.Text = _currentVAT.ToString("N2")
        txtTotal.Text = _currentTotal.ToString("N2")
        txtTenderAmount.Text = _currentTotal.ToString("N2")
    End Sub

    Private Sub btnCash_Click(sender As Object, e As EventArgs)
        _tenderType = "Cash"
        btnCash.BackColor = Color.LightBlue
        btnCard.BackColor = SystemColors.Control
    End Sub

    Private Sub btnCard_Click(sender As Object, e As EventArgs)
        _tenderType = "Card"
        btnCard.BackColor = Color.LightBlue
        btnCash.BackColor = SystemColors.Control
    End Sub

    Private Sub btnFinalizeSale_Click(sender As Object, e As EventArgs)
        Try
            If _cartItems.Rows.Count = 0 Then
                MessageBox.Show("Cart is empty.", "POS", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim tenderAmount As Decimal
            If Not Decimal.TryParse(txtTenderAmount.Text, tenderAmount) Then
                MessageBox.Show("Invalid tender amount.", "POS", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If tenderAmount < _currentTotal Then
                MessageBox.Show("Tender amount is insufficient.", "POS", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Process sale
            ProcessSale(tenderAmount)
            
        Catch ex As Exception
            MessageBox.Show("Error finalizing sale: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ProcessSale(tenderAmount As Decimal)
        Using conn As New SqlConnection(_connString)
            conn.Open()
            Using trans = conn.BeginTransaction()
                Try
                    ' Create sale header
                    Dim saleId As Integer = CreateSaleHeader(conn, trans, tenderAmount)
                    
                    ' Create sale lines and update stock
                    For Each row As DataRow In _cartItems.Rows
                        CreateSaleLine(conn, trans, saleId, row)
                        UpdateStock(conn, trans, row)
                    Next
                    
                    ' Post to GL (simplified)
                    PostSaleToGL(conn, trans, saleId)
                    
                    trans.Commit()
                    
                    ' Show success and clear cart
                    Dim change As Decimal = tenderAmount - _currentTotal
                    MessageBox.Show($"Sale completed successfully!{vbCrLf}Change: {change:N2}", "POS", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    ClearCart()
                    
                Catch ex As Exception
                    trans.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Private Function CreateSaleHeader(conn As SqlConnection, trans As SqlTransaction, tenderAmount As Decimal) As Integer
        Dim sql As String = "INSERT INTO dbo.Retail_Sales (BranchID, SaleDate, Subtotal, VATAmount, Total, TenderType, TenderAmount, UserID) " &
                           "VALUES (@bid, @date, @sub, @vat, @total, @tender, @amount, @uid); SELECT SCOPE_IDENTITY();"
        
        Using cmd As New SqlCommand(sql, conn, trans)
            cmd.Parameters.AddWithValue("@bid", _currentBranchId)
            cmd.Parameters.AddWithValue("@date", DateTime.Now)
            cmd.Parameters.AddWithValue("@sub", _currentSubtotal)
            cmd.Parameters.AddWithValue("@vat", _currentVAT)
            cmd.Parameters.AddWithValue("@total", _currentTotal)
            cmd.Parameters.AddWithValue("@tender", _tenderType)
            cmd.Parameters.AddWithValue("@amount", tenderAmount)
            cmd.Parameters.AddWithValue("@uid", If(AppSession.CurrentUser?.UserID, 0))
            Return Convert.ToInt32(cmd.ExecuteScalar())
        End Using
    End Function

    Private Sub CreateSaleLine(conn As SqlConnection, trans As SqlTransaction, saleId As Integer, cartRow As DataRow)
        Dim sql As String = "INSERT INTO dbo.Retail_SaleLines (SaleID, ProductID, Code, SKU, ProductName, Quantity, UnitPrice, LineTotal) " &
                           "VALUES (@sid, @pid, @code, @sku, @name, @qty, @price, @total)"
        
        Using cmd As New SqlCommand(sql, conn, trans)
            cmd.Parameters.AddWithValue("@sid", saleId)
            cmd.Parameters.AddWithValue("@pid", cartRow("ProductID"))
            cmd.Parameters.AddWithValue("@code", If(cartRow.Table.Columns.Contains("Code"), cartRow("Code"), ""))
            cmd.Parameters.AddWithValue("@sku", cartRow("SKU"))
            cmd.Parameters.AddWithValue("@name", cartRow("ProductName"))
            cmd.Parameters.AddWithValue("@qty", cartRow("Quantity"))
            cmd.Parameters.AddWithValue("@price", cartRow("UnitPrice"))
            cmd.Parameters.AddWithValue("@total", cartRow("LineTotal"))
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Sub UpdateStock(conn As SqlConnection, trans As SqlTransaction, cartRow As DataRow)
        Dim sql As String = "UPDATE rs SET rs.QtyOnHand = rs.QtyOnHand - @qty " &
                           "FROM dbo.Retail_Stock rs " &
                           "INNER JOIN dbo.Retail_Variant rv ON rs.VariantID = rv.VariantID " &
                           "WHERE rv.ProductID = @pid AND rs.BranchID = @bid"
        
        Using cmd As New SqlCommand(sql, conn, trans)
            cmd.Parameters.AddWithValue("@qty", cartRow("Quantity"))
            cmd.Parameters.AddWithValue("@pid", cartRow("ProductID"))
            cmd.Parameters.AddWithValue("@bid", _currentBranchId)
            cmd.ExecuteNonQuery()
        End Using
        
        ' Insert stock movement - Use QtyDelta NOT QuantityChange
        Dim moveSql As String = "INSERT INTO dbo.Retail_StockMovements (VariantID, BranchID, QtyDelta, Reason, Ref1, CreatedAt, CreatedBy) " &
                               "VALUES ((SELECT TOP 1 VariantID FROM dbo.Retail_Variant WHERE ProductID = @pid), @bid, @qty, @reason, @ref, GETDATE(), @uid)"
        
        Using cmd As New SqlCommand(moveSql, conn, trans)
            cmd.Parameters.AddWithValue("@pid", cartRow("ProductID"))
            cmd.Parameters.AddWithValue("@bid", _currentBranchId)
            cmd.Parameters.AddWithValue("@qty", -Convert.ToDecimal(cartRow("Quantity")))
            cmd.Parameters.AddWithValue("@reason", "Sale")
            cmd.Parameters.AddWithValue("@ref", $"POS-{cartRow("SKU")}")
            cmd.Parameters.AddWithValue("@uid", If(AppSession.CurrentUser?.UserID, 0))
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Sub PostSaleToGL(conn As SqlConnection, trans As SqlTransaction, saleId As Integer)
        ' Simplified GL posting - would normally use stored procedures
        ' This is a stub for the GL integration requirement
        Try
            ' Sales Revenue (Credit)
            ' COGS (Debit)
            ' Inventory (Credit)
            ' VAT Payable (Credit)
            ' Cash/Bank (Debit)
            
            ' For now, just log the requirement
            System.Diagnostics.Debug.WriteLine($"GL Posting required for Sale ID: {saleId}")
        Catch ex As Exception
            ' Log but don't fail the sale
            System.Diagnostics.Debug.WriteLine($"GL Posting failed: {ex.Message}")
        End Try
    End Sub

    Private Sub btnClearCart_Click(sender As Object, e As EventArgs)
        If MessageBox.Show("Clear all items from cart?", "POS", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
            ClearCart()
        End If
    End Sub

    Private Sub ClearCart()
        _cartItems.Clear()
        UpdateCartTotals()
        txtScanSKU.Clear()
        txtScanSKU.Focus()
    End Sub
End Class
