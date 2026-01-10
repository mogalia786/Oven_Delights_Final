Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing.Printing

Namespace Manufacturing
    Public Class ReOrderBookManagerForm
    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private currentReOrderBookID As Integer = 0
    Private currentBranchID As Integer = 0
    Private currentUserName As String = ""
    Private scaledBOMService As New ScaledBOMService()

    Private Sub ReOrderBookManagerForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            If AppSession.CurrentUser Is Nothing Then
                MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Me.Close()
                Return
            End If
            
            currentUserName = AppSession.CurrentUser.Username
            currentBranchID = AppSession.CurrentUser.BranchID
            
            SetupUI()
            LoadBakers()
            LoadProducts()
            LoadDraftReOrderBooks()
            
            dtpOrderDate.Value = DateTime.Today
            dtpRequiredDate.Value = DateTime.Today.AddDays(1)
            
            EnableEditMode(False)
            
        Catch ex As Exception
            MessageBox.Show("Error loading form: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private isLoadingProducts As Boolean = False
    
    Private Sub OnProductSearchChanged(sender As Object, e As EventArgs)
        If Not isLoadingProducts Then
            LoadProducts(cmbProduct.Text)
        End If
    End Sub

    Private Sub SetupUI()
        ' Setup DataGridViews
        dgvDraftBooks.AutoGenerateColumns = False
        dgvDraftBooks.Columns.Clear()
        dgvDraftBooks.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ReOrderBookID", .DataPropertyName = "ReOrderBookID", .Visible = False})
        dgvDraftBooks.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ReOrderNumber", .HeaderText = "Re-Order #", .DataPropertyName = "ReOrderNumber", .Width = 150})
        dgvDraftBooks.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ManufacturerName", .HeaderText = "Baker", .DataPropertyName = "ManufacturerName", .Width = 120})
        dgvDraftBooks.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "OrderDate", .HeaderText = "Date", .DataPropertyName = "OrderDate", .Width = 100, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "dd/MM/yyyy"}})
        dgvDraftBooks.Columns.Add(New DataGridViewCheckBoxColumn With {.Name = "IsUrgent", .HeaderText = "Urgent", .DataPropertyName = "IsUrgent", .Width = 60})
        dgvDraftBooks.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalProducts", .HeaderText = "Products", .DataPropertyName = "TotalProducts", .Width = 80})
        dgvDraftBooks.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalQuantity", .HeaderText = "Qty", .DataPropertyName = "TotalQuantity", .Width = 80})
        
        dgvProductLines.AutoGenerateColumns = False
        dgvProductLines.Columns.Clear()
        dgvProductLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ReOrderLineID", .DataPropertyName = "ReOrderLineID", .Visible = False})
        dgvProductLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LineNumber", .HeaderText = "#", .DataPropertyName = "LineNumber", .Width = 40})
        dgvProductLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductName", .HeaderText = "Product", .DataPropertyName = "ProductName", .Width = 250})
        dgvProductLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "SKU", .HeaderText = "Barcode", .DataPropertyName = "SKU", .Width = 120})
        dgvProductLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "QuantityOrdered", .HeaderText = "Quantity", .DataPropertyName = "QuantityOrdered", .Width = 80})
        dgvProductLines.Columns.Add(New DataGridViewButtonColumn With {.Name = "Remove", .HeaderText = "", .Text = "Remove", .UseColumnTextForButtonValue = True, .Width = 80})
    End Sub

    Private Sub LoadBakers()
        Try
            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("SELECT UserID, FirstName + ' ' + LastName AS FullName FROM Users WHERE RoleID IN (SELECT RoleID FROM Roles WHERE RoleName = 'Manufacturer') AND IsActive = 1 AND BranchID = @BranchID ORDER BY FirstName", conn)
                cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                conn.Open()
                
                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())
                
                cmbBaker.DisplayMember = "FullName"
                cmbBaker.ValueMember = "UserID"
                cmbBaker.DataSource = dt
                cmbBaker.SelectedIndex = -1
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading bakers: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadProducts(Optional searchText As String = "")
        Try
            Using conn As New SqlConnection(connectionString)
                ' Only load products that have recipes created (Recipe_Created = 1)
                ' Branch filtering: HEAD OFFICE shows all, specific branch filters by BranchID
                Dim currentBranchID = If(AppSession.CurrentUser?.BranchID, 0)
                Dim sql As String
                
                If currentBranchID = 0 OrElse currentBranchID = 12 Then
                    ' HEAD OFFICE - show all branches with DISTINCT names
                    ' Show Internal products (check for recipes if tables exist)
                    sql = "SELECT MIN(p.ProductID) AS ProductID, p.Name AS ProductName, MIN(ISNULL(p.Code, p.SKU)) AS SKU " & _
                          "FROM Demo_Retail_Product p " & _
                          "WHERE p.IsActive = 1 " & _
                          "  AND p.ProductType = 'Internal' " & _
                          "  AND (NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Demo_ProductRecipe_Master') " & _
                          "       OR EXISTS (SELECT 1 FROM Demo_ProductRecipe_Master pr WHERE pr.ProductID = p.ProductID AND pr.IsActive = 1) " & _
                          "       OR EXISTS (SELECT 1 FROM Demo_SubRecipe_Master sr WHERE sr.SubRecipeID = p.ProductID AND sr.IsActive = 1)) "
                    If Not String.IsNullOrEmpty(searchText) Then
                        sql &= " AND p.Name LIKE @search "
                    End If
                    sql &= "GROUP BY p.Name ORDER BY p.Name"
                Else
                    ' Specific branch - filter by BranchID
                    ' Show Internal products (check for recipes if tables exist)
                    sql = "SELECT p.ProductID, p.Name AS ProductName, ISNULL(p.Code, p.SKU) AS SKU " & _
                          "FROM Demo_Retail_Product p " & _
                          "WHERE p.IsActive = 1 " & _
                          "  AND p.BranchID = @BranchID " & _
                          "  AND p.ProductType = 'Internal' " & _
                          "  AND (NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Demo_ProductRecipe_Master') " & _
                          "       OR EXISTS (SELECT 1 FROM Demo_ProductRecipe_Master pr WHERE pr.ProductID = p.ProductID AND pr.IsActive = 1) " & _
                          "       OR EXISTS (SELECT 1 FROM Demo_SubRecipe_Master sr WHERE sr.SubRecipeID = p.ProductID AND sr.IsActive = 1)) "
                    If Not String.IsNullOrEmpty(searchText) Then
                        sql &= " AND p.Name LIKE @search "
                    End If
                    sql &= "ORDER BY p.Name"
                End If
                
                Dim cmd As New SqlCommand(sql, conn)
                If Not String.IsNullOrEmpty(searchText) Then
                    cmd.Parameters.AddWithValue("@search", $"%{searchText}%")
                End If
                If currentBranchID > 0 AndAlso currentBranchID <> 12 Then
                    cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                End If
                conn.Open()
                
                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())
                
                cmbProduct.DisplayMember = "ProductName"
                cmbProduct.ValueMember = "ProductID"
                cmbProduct.DataSource = dt
                cmbProduct.SelectedIndex = -1
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading products: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadDraftReOrderBooks()
        Try
            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("sp_GetDraftReOrderBooks", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                
                conn.Open()
                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())
                
                dgvDraftBooks.DataSource = dt
                lblDraftCount.Text = $"Draft Re-Orders: {dt.Rows.Count}"
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading drafts: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnNewReOrder_Click(sender As Object, e As EventArgs) Handles btnNewReOrder.Click
        If cmbBaker.SelectedIndex = -1 Then
            MessageBox.Show("Please select a baker", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Try
            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("sp_CreateReOrderBook", conn)
                cmd.CommandType = CommandType.StoredProcedure
                
                cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                cmd.Parameters.AddWithValue("@ManufacturerUserID", cmbBaker.SelectedValue)
                cmd.Parameters.AddWithValue("@OrderDate", dtpOrderDate.Value.Date)
                cmd.Parameters.AddWithValue("@RequiredDate", dtpRequiredDate.Value.Date)
                cmd.Parameters.AddWithValue("@CreatedBy", currentUserName)
                cmd.Parameters.AddWithValue("@IsUrgent", chkUrgent.Checked)
                cmd.Parameters.AddWithValue("@Notes", txtNotes.Text)
                
                Dim pReOrderBookID As New SqlParameter("@ReOrderBookID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                Dim pReOrderNumber As New SqlParameter("@ReOrderNumber", SqlDbType.NVarChar, 50) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(pReOrderBookID)
                cmd.Parameters.Add(pReOrderNumber)
                
                conn.Open()
                cmd.ExecuteNonQuery()
                
                currentReOrderBookID = CInt(pReOrderBookID.Value)
                txtReOrderNumber.Text = pReOrderNumber.Value.ToString()
                
                EnableEditMode(True)
                LoadDraftReOrderBooks()
                
                MessageBox.Show($"Re-Order Book created: {txtReOrderNumber.Text}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End Using
        Catch ex As Exception
            MessageBox.Show("Error creating re-order: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnAddProduct_Click(sender As Object, e As EventArgs) Handles btnAddProduct.Click
        If currentReOrderBookID = 0 Then
            MessageBox.Show("Please create a re-order book first", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        If cmbProduct.SelectedIndex = -1 OrElse nudQuantity.Value <= 0 Then
            MessageBox.Show("Please select a product and enter quantity", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                ' Get next line number
                Dim cmdLineNum As New SqlCommand("SELECT ISNULL(MAX(LineNumber), 0) + 1 FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID", conn)
                cmdLineNum.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                Dim lineNumber = Convert.ToInt32(cmdLineNum.ExecuteScalar())
                
                ' Get product details
                Dim selectedRow = CType(cmbProduct.SelectedItem, DataRowView)
                Dim productID As Integer = Convert.ToInt32(cmbProduct.SelectedValue)
                Dim productName As String = selectedRow("ProductName").ToString()
                Dim barcode As String = If(selectedRow("SKU"), "").ToString()
                
                ' Insert new line (BOM will be generated later by baker from dashboard)
                Dim cmdInsert As New SqlCommand(
                    "INSERT INTO ReOrderBookLines (ReOrderBookID, ProductID, ProductName, Barcode, LineNumber, QuantityOrdered, UnitOfMeasure, Notes) " &
                    "VALUES (@ReOrderBookID, @ProductID, @ProductName, @Barcode, @LineNumber, @QuantityOrdered, @UnitOfMeasure, @Notes)", conn)
                cmdInsert.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                cmdInsert.Parameters.AddWithValue("@ProductID", productID)
                cmdInsert.Parameters.AddWithValue("@ProductName", productName)
                cmdInsert.Parameters.AddWithValue("@Barcode", barcode)
                cmdInsert.Parameters.AddWithValue("@LineNumber", lineNumber)
                cmdInsert.Parameters.AddWithValue("@QuantityOrdered", nudQuantity.Value)
                cmdInsert.Parameters.AddWithValue("@UnitOfMeasure", "Each")
                cmdInsert.Parameters.AddWithValue("@Notes", DBNull.Value)
                cmdInsert.ExecuteNonQuery()
                
                LoadReOrderBookDetails(currentReOrderBookID)
                LoadDraftReOrderBooks()
                
                ' Reset controls
                cmbProduct.SelectedIndex = -1
                nudQuantity.Value = 1
                
            End Using
        Catch ex As Exception
            MessageBox.Show("Error adding product: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadReOrderBookDetails(reOrderBookID As Integer)
        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                ' Get header details
                Dim cmdHeader As New SqlCommand(
                    "SELECT rb.ReOrderNumber, u.FirstName + ' ' + u.LastName AS ManufacturerName, " &
                    "COUNT(rbl.ReOrderLineID) AS TotalProducts, SUM(rbl.QuantityOrdered) AS TotalQuantity " &
                    "FROM ReOrderBooks rb " &
                    "LEFT JOIN Users u ON rb.ManufacturerUserID = u.UserID " &
                    "LEFT JOIN ReOrderBookLines rbl ON rb.ReOrderBookID = rbl.ReOrderBookID " &
                    "WHERE rb.ReOrderBookID = @ReOrderBookID " &
                    "GROUP BY rb.ReOrderNumber, u.FirstName, u.LastName", conn)
                cmdHeader.Parameters.AddWithValue("@ReOrderBookID", reOrderBookID)
                
                Dim reader = cmdHeader.ExecuteReader()
                If reader.Read() Then
                    txtReOrderNumber.Text = If(reader("ReOrderNumber"), "").ToString()
                    lblBakerName.Text = "Baker: " & If(reader("ManufacturerName"), "").ToString()
                    lblTotalProducts.Text = "Products: " & If(reader("TotalProducts"), 0).ToString()
                    lblTotalQuantity.Text = "Total Qty: " & If(reader("TotalQuantity"), 0).ToString()
                End If
                reader.Close()
                
                ' Get line items
                Dim cmdLines As New SqlCommand(
                    "SELECT rbl.ReOrderLineID, rbl.LineNumber, rbl.ProductID, p.Name AS ProductName, ISNULL(p.Code, p.SKU) AS SKU, rbl.QuantityOrdered " &
                    "FROM ReOrderBookLines rbl " &
                    "INNER JOIN Demo_Retail_Product p ON rbl.ProductID = p.ProductID " &
                    "WHERE rbl.ReOrderBookID = @ReOrderBookID " &
                    "ORDER BY rbl.LineNumber", conn)
                cmdLines.Parameters.AddWithValue("@ReOrderBookID", reOrderBookID)
                
                Dim dtLines As New DataTable()
                dtLines.Load(cmdLines.ExecuteReader())
                dgvProductLines.DataSource = dtLines
                
                btnPost.Enabled = dtLines.Rows.Count > 0
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading details: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnPost_Click(sender As Object, e As EventArgs) Handles btnPost.Click
        If currentReOrderBookID = 0 Then
            MessageBox.Show("Please select a re-order book first", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        ' Confirm before posting
        Dim result = MessageBox.Show("Post this Re-Order Book to Baker?" & vbCrLf & vbCrLf & 
                                     "This will make it visible on the Baker Dashboard.", 
                                     "Confirm Post", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
        If result <> DialogResult.Yes Then Return
        
        Try
            ' Mark as Posted and show on baker dashboard
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Dim cmd As New SqlCommand(
                    "UPDATE ReOrderBooks SET Status = 'Posted', PostedDate = GETDATE() WHERE ReOrderBookID = @ReOrderBookID", conn)
                cmd.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                Dim rowsAffected = cmd.ExecuteNonQuery()
                
                If rowsAffected = 0 Then
                    MessageBox.Show("Failed to update re-order book. It may have been deleted.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Return
                End If
            End Using
            
            MessageBox.Show("Re-Order Book posted successfully!" & vbCrLf & "Now visible on Baker Dashboard.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            LoadDraftReOrderBooks()
            ResetForm()
            
        Catch ex As Exception
            MessageBox.Show("Error posting re-order book: " & ex.Message & vbCrLf & vbCrLf & ex.StackTrace, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvDraftBooks_CellClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvDraftBooks.CellClick
        If e.RowIndex >= 0 Then
            Dim reOrderBookID As Integer = CInt(dgvDraftBooks.Rows(e.RowIndex).Cells("ReOrderBookID").Value)
            currentReOrderBookID = reOrderBookID
            LoadReOrderBookDetails(reOrderBookID)
            EnableEditMode(True)
        End If
    End Sub

    Private Sub dgvProductLines_CellClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvProductLines.CellClick
        If e.RowIndex >= 0 AndAlso e.ColumnIndex = dgvProductLines.Columns("Remove").Index Then
            Dim result As DialogResult = MessageBox.Show("Remove this product?", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result = DialogResult.Yes Then
                ' Remove line logic here
                LoadReOrderBookDetails(currentReOrderBookID)
            End If
        End If
    End Sub

    Private Sub EnableEditMode(enabled As Boolean)
        grpProducts.Enabled = enabled
        btnPost.Enabled = enabled
    End Sub

    Private Sub ResetForm()
        currentReOrderBookID = 0
        txtReOrderNumber.Text = ""
        lblBakerName.Text = "Baker: -"
        lblTotalProducts.Text = "Products: 0"
        lblTotalQuantity.Text = "Total Qty: 0"
        dgvProductLines.DataSource = Nothing
        cmbBaker.SelectedIndex = -1
        cmbProduct.SelectedIndex = -1
        nudQuantity.Value = 1
        txtNotes.Text = ""
        chkUrgent.Checked = False
        EnableEditMode(False)
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
    End Class
End Namespace
