Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms
Imports System.Drawing

Public Class ProductAddEditForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _productId As Integer?
    Private ReadOnly _isEditMode As Boolean

    Public Sub New(Optional productId As Integer? = Nothing)
        _productId = productId
        _isEditMode = productId.HasValue
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        InitializeComponent()
        LoadDropdownData()
        If _isEditMode Then LoadProductData()
    End Sub

    ' Controls are declared in Designer file
    Private cboProductType As ComboBox
    Private cboUnitOfMeasure As ComboBox

    ' InitializeComponent is in Designer file


    Private Sub LoadDropdownData()
        ' Product Types - CRITICAL: Only allow External products to be created manually
        ' Manufactured products are created ONLY via manufacturing build process
        cboProductType.Items.AddRange({"External"})
        cboProductType.SelectedIndex = 0

        ' Units of Measure
        cboUnitOfMeasure.Items.AddRange({"kg", "g", "L", "ml", "pcs", "box", "pack", "dozen", "m", "cm"})
        cboUnitOfMeasure.SelectedIndex = 0
        
        ' Load Categories from database
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT CategoryID, CategoryName FROM Categories WHERE IsActive = 1 ORDER BY CategoryName"
                Using cmd As New SqlCommand(sql, conn)
                    conn.Open()
                    Using reader = cmd.ExecuteReader()
                        Dim categories As New DataTable()
                        categories.Load(reader)
                        cboCategory.DataSource = categories
                        cboCategory.DisplayMember = "CategoryName"
                        cboCategory.ValueMember = "CategoryID"
                    End Using
                End Using
            End Using
        Catch
            ' Fallback if Categories table doesn't exist
            cboCategory.Items.AddRange({"General", "Bakery", "Pastry", "Beverages"})
            cboCategory.SelectedIndex = 0
        End Try
    End Sub

    Private Sub LoadProductData()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT ProductName, CategoryID, ItemType, IsActive FROM Products WHERE ProductID = @productId"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@productId", _productId.Value)
                    conn.Open()
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            txtProductName.Text = reader("ProductName").ToString()
                            If Not IsDBNull(reader("CategoryID")) Then
                                cboCategory.SelectedValue = Convert.ToInt32(reader("CategoryID"))
                            End If
                            If Not IsDBNull(reader("ItemType")) Then
                                cboProductType.Text = reader("ItemType").ToString()
                            End If
                            chkIsActive.Checked = Convert.ToBoolean(reader("IsActive"))
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading product data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnSave(sender As Object, e As EventArgs)
        Try
            If Not ValidateInput() Then Return

            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                If _isEditMode Then
                    UpdateProduct(conn)
                Else
                    CreateProduct(conn)
                End If
                
                Me.DialogResult = DialogResult.OK
                Me.Close()
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error saving product: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnCancel(sender As Object, e As EventArgs)
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub

    Private Function ValidateInput() As Boolean
        If String.IsNullOrWhiteSpace(txtProductName.Text) Then
            MessageBox.Show("Product name is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtProductName.Focus()
            Return False
        End If

        If cboCategory.SelectedValue Is Nothing Then
            MessageBox.Show("Category is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            cboCategory.Focus()
            Return False
        End If

        Return True
    End Function
    
    Private Sub CreateProduct(conn As SqlConnection)
        Dim sql = "INSERT INTO Products (ProductCode, ProductName, CategoryID, ItemType, IsActive, CreatedDate, CreatedBy) " &
                  "VALUES (@ProductCode, @ProductName, @CategoryID, @ItemType, @IsActive, GETDATE(), 1)"
        
        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@ProductCode", GenerateProductCode())
            cmd.Parameters.AddWithValue("@ProductName", txtProductName.Text.Trim())
            cmd.Parameters.AddWithValue("@CategoryID", Convert.ToInt32(cboCategory.SelectedValue))
            cmd.Parameters.AddWithValue("@ItemType", cboProductType.Text)
            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked)
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
    Private Sub UpdateProduct(conn As SqlConnection)
        Dim sql = "UPDATE Products SET ProductName = @ProductName, CategoryID = @CategoryID, ItemType = @ItemType, IsActive = @IsActive " &
                  "WHERE ProductID = @ProductID"
        
        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@ProductName", txtProductName.Text.Trim())
            cmd.Parameters.AddWithValue("@CategoryID", Convert.ToInt32(cboCategory.SelectedValue))
            cmd.Parameters.AddWithValue("@ItemType", cboProductType.Text)
            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked)
            cmd.Parameters.AddWithValue("@ProductID", _productId.Value)
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
    Private Function GenerateProductCode() As String
        Return "PRD" & DateTime.Now.ToString("yyyyMMddHHmmss")
    End Function
End Class
