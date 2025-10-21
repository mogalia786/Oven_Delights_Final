Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms
Imports System.Drawing

Public Class StockroomInventoryForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly stockroomService As New StockroomService()
    ' Controls are declared in Designer file
    Private lblTotalValue As Label

    Public Sub New()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        InitializeComponent()
        LoadCategories()
        LoadInventory()
    End Sub

    ' InitializeComponent is in Designer file

    Private Sub LoadCategories()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT DISTINCT c.CategoryName AS Category FROM Products p INNER JOIN ProductCategories c ON p.CategoryID = c.CategoryID WHERE p.IsActive = 1 ORDER BY c.CategoryName"
                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    
                    ' Add "All Categories" option
                    Dim allRow = dt.NewRow()
                    allRow("Category") = "All Categories"
                    dt.Rows.InsertAt(allRow, 0)
                    
                    cboCategory.DataSource = dt
                    cboCategory.DisplayMember = "Category"
                    cboCategory.ValueMember = "Category"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading categories: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadInventory()
        Try
            ' Get current user's branch and role for filtering
            Dim currentBranchId As Integer = stockroomService.GetCurrentUserBranchId()
            Dim isSuperAdmin As Boolean = stockroomService.IsCurrentUserSuperAdmin()
            
            Using conn As New SqlConnection(_connString)
                Dim sql As String
                If isSuperAdmin Then
                    sql = "SELECT p.ProductID, p.ProductCode, p.ProductName, 
                           c.CategoryName AS Category, p.ItemType,
                           ISNULL(SUM(rs.QtyOnHand), 0) AS CurrentStock,
                           ISNULL(AVG(rs.ReorderPoint), 0) AS ReorderLevel,
                           CASE WHEN p.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status
                           FROM Products p
                           LEFT JOIN ProductCategories c ON p.CategoryID = c.CategoryID
                           LEFT JOIN Retail_Variant rv ON rv.ProductID = p.ProductID
                           LEFT JOIN Retail_Stock rs ON rs.VariantID = rv.VariantID
                           GROUP BY p.ProductID, p.ProductCode, p.ProductName, c.CategoryName, p.ItemType, p.IsActive
                           ORDER BY p.ProductName"
                Else
                    sql = "SELECT p.ProductID, p.ProductCode, p.ProductName, 
                           c.CategoryName AS Category, p.ItemType,
                           ISNULL(SUM(rs.QtyOnHand), 0) AS CurrentStock,
                           ISNULL(AVG(rs.ReorderPoint), 0) AS ReorderLevel,
                           CASE WHEN p.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status
                           FROM Products p
                           LEFT JOIN ProductCategories c ON p.CategoryID = c.CategoryID
                           LEFT JOIN Retail_Variant rv ON rv.ProductID = p.ProductID
                           LEFT JOIN Retail_Stock rs ON rs.VariantID = rv.VariantID AND rs.BranchID = @BranchID
                           WHERE p.IsActive = 1
                           GROUP BY p.ProductID, p.ProductCode, p.ProductName, c.CategoryName, p.ItemType, p.IsActive
                           ORDER BY p.ProductName"
                End If

                Using cmd As New SqlCommand(sql, conn)
                    If Not isSuperAdmin Then
                        cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                    End If
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvInventory.DataSource = dt
                    
                    ' Hide ProductID column
                    If dgvInventory.Columns.Contains("ProductID") Then
                        dgvInventory.Columns("ProductID").Visible = False
                    End If
                    
                    ' Color code low stock items
                    AddHandler dgvInventory.CellFormatting, AddressOf OnCellFormatting
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading inventory: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnCellFormatting(sender As Object, e As DataGridViewCellFormattingEventArgs)
        Try
            If e.RowIndex >= 0 AndAlso dgvInventory.Rows(e.RowIndex).Cells("CurrentStock").Value IsNot Nothing AndAlso
               dgvInventory.Rows(e.RowIndex).Cells("ReorderLevel").Value IsNot Nothing Then
                
                Dim currentStock As Integer = Convert.ToInt32(dgvInventory.Rows(e.RowIndex).Cells("CurrentStock").Value)
                Dim reorderLevel As Integer = Convert.ToInt32(dgvInventory.Rows(e.RowIndex).Cells("ReorderLevel").Value)
                
                If currentStock <= reorderLevel AndAlso currentStock > 0 Then
                    e.CellStyle.BackColor = Color.LightCoral
                    e.CellStyle.ForeColor = Color.DarkRed
                ElseIf currentStock = 0 Then
                    e.CellStyle.BackColor = Color.Red
                    e.CellStyle.ForeColor = Color.White
                End If
            End If
        Catch
            ' Ignore formatting errors
        End Try
    End Sub

    Private Sub CalculateTotalValue(dt As DataTable)
        Dim totalItems As Integer = dt.Rows.Count
        lblTotalValue.Text = $"Total Products: {totalItems}"
    End Sub

    Private Sub OnSearchTextChanged(sender As Object, e As EventArgs)
        ApplyFilters()
    End Sub

    Private Sub OnCategoryChanged(sender As Object, e As EventArgs)
        ApplyFilters()
    End Sub

    Private Sub ApplyFilters()
        Try
            If dgvInventory.DataSource IsNot Nothing Then
                Dim dt = CType(dgvInventory.DataSource, DataTable)
                Dim filter As String = ""
                
                ' Search filter
                If Not String.IsNullOrWhiteSpace(txtSearch.Text) Then
                    Dim searchText = txtSearch.Text.Replace("'", "''")
                    filter = $"ProductName LIKE '%{searchText}%'"
                End If
                
                ' Category filter
                If cboCategory.SelectedValue IsNot Nothing AndAlso cboCategory.SelectedValue.ToString() <> "All Categories" Then
                    If Not String.IsNullOrEmpty(filter) Then filter += " AND "
                    filter += $"Category = '{cboCategory.SelectedValue.ToString().Replace("'", "''")}'"
                End If
                
                dt.DefaultView.RowFilter = filter
            End If
        Catch ex As Exception
            ' Silent fail for filter errors
        End Try
    End Sub

    Private Sub OnAddProduct(sender As Object, e As EventArgs)
        Try
            Using frm As New ProductAddEditForm()
                If frm.ShowDialog(Me) = DialogResult.OK Then
                    LoadInventory()
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error opening Add Product form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnEditProduct(sender As Object, e As EventArgs)
        Try
            If dgvInventory.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a product to edit.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim productId = Convert.ToInt32(dgvInventory.SelectedRows(0).Cells("ProductID").Value)
            Using frm As New ProductAddEditForm(productId)
                If frm.ShowDialog(Me) = DialogResult.OK Then
                    LoadInventory()
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error opening Edit Product form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnDeleteProduct(sender As Object, e As EventArgs)
        Try
            If dgvInventory.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a product to delete.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim productName = dgvInventory.SelectedRows(0).Cells("ProductName").Value.ToString()
            Dim result = MessageBox.Show($"Are you sure you want to delete product '{productName}'?", 
                                       "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            
            If result = DialogResult.Yes Then
                Dim productId = Convert.ToInt32(dgvInventory.SelectedRows(0).Cells("ProductID").Value)
                DeleteProduct(productId)
                LoadInventory()
            End If
        Catch ex As Exception
            MessageBox.Show($"Error deleting product: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub DeleteProduct(productId As Integer)
        Using conn As New SqlConnection(_connString)
            conn.Open()
            Using cmd As New SqlCommand("UPDATE Products SET IsActive = 0 WHERE ProductID = @productId", conn)
                cmd.Parameters.AddWithValue("@productId", productId)
                cmd.ExecuteNonQuery()
            End Using
        End Using
        MessageBox.Show("Product deactivated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub OnRefresh(sender As Object, e As EventArgs)
        LoadInventory()
    End Sub
End Class
