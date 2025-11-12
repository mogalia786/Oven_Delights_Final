Imports System.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing
    Public Class ReOrderBookManagerForm
    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private currentReOrderBookID As Integer = 0
    Private currentBranchID As Integer = 0
    Private currentUserName As String = ""

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

    Private Sub LoadProducts()
        Try
            Using conn As New SqlConnection(connectionString)
                ' Load internal products that have an active recipe in the new Recipe table
                Dim branchId As Integer = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
                Dim sql As String = "SELECT DISTINCT p.ProductID, p.Name AS ProductName, p.SKU " & _
                                    "FROM Demo_Retail_Product p " & _
                                    "WHERE p.IsActive = 1 " & _
                                    "  AND p.ProductType = 'Internal' " & _
                                    "  AND (p.BranchID = @branchId OR p.BranchID IS NULL) " & _
                                    "  AND EXISTS (SELECT 1 FROM dbo.Recipe r WHERE r.ProductID = p.ProductID AND r.IsActive = 1) " & _
                                    "ORDER BY p.Name"
                Dim cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@branchId", branchId)
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
                Dim cmd As New SqlCommand("sp_AddProductToReOrderBook", conn)
                cmd.CommandType = CommandType.StoredProcedure
                
                cmd.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                cmd.Parameters.AddWithValue("@ProductID", cmbProduct.SelectedValue)
                cmd.Parameters.AddWithValue("@QuantityOrdered", nudQuantity.Value)
                cmd.Parameters.AddWithValue("@UnitOfMeasure", "Each")
                cmd.Parameters.AddWithValue("@Notes", DBNull.Value)
                
                Dim pReOrderLineID As New SqlParameter("@ReOrderLineID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                cmd.Parameters.Add(pReOrderLineID)
                
                conn.Open()
                cmd.ExecuteNonQuery()
                
                LoadReOrderBookDetails(currentReOrderBookID)
                LoadDraftReOrderBooks()
                
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
                Dim cmd As New SqlCommand("sp_GetReOrderBookDetails", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ReOrderBookID", reOrderBookID)
                
                conn.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                
                If reader.Read() Then
                    txtReOrderNumber.Text = reader("ReOrderNumber").ToString()
                    lblBakerName.Text = "Baker: " & reader("ManufacturerName").ToString()
                    lblTotalProducts.Text = "Products: " & reader("TotalProducts").ToString()
                    lblTotalQuantity.Text = "Total Qty: " & reader("TotalQuantity").ToString()
                End If
                
                reader.NextResult()
                Dim dtLines As New DataTable()
                dtLines.Load(reader)
                dgvProductLines.DataSource = dtLines
                
                btnPost.Enabled = dtLines.Rows.Count > 0
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading details: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnPost_Click(sender As Object, e As EventArgs) Handles btnPost.Click
        If currentReOrderBookID = 0 Then Return
        
        Dim result As DialogResult = MessageBox.Show(
            "Post this re-order book to the baker?" & vbCrLf & vbCrLf &
            "The baker will receive production instructions.",
            "Confirm Post",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question)
        
        If result = DialogResult.Yes Then
            Try
                Using conn As New SqlConnection(connectionString)
                    Dim cmd As New SqlCommand("sp_PostReOrderBook", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                    cmd.Parameters.AddWithValue("@PostedBy", currentUserName)
                    
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    
                    MessageBox.Show("Re-order book posted successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    
                    ResetForm()
                    LoadDraftReOrderBooks()
                End Using
            Catch ex As Exception
                MessageBox.Show("Error posting: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
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
