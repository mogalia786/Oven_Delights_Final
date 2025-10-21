Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Partial Class ProductUpsertForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _isSuperAdmin As Boolean
    Private ReadOnly _sessionBranchId As Integer
    Private _imageBytes As Byte()
    Private WithEvents categorySelector As CategorySubcategorySelector

    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrWhiteSpace(_connString) Then
            MessageBox.Show("Missing connection string 'OvenDelightsERPConnectionString' in App.config.", "Config Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
        _isSuperAdmin = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        _sessionBranchId = If(AppSession.CurrentUser IsNot Nothing AndAlso AppSession.CurrentUser.BranchID.HasValue, AppSession.CurrentUser.BranchID.Value, 0)
        LoadBranches()
        ' Hide branch selector for non-super admin; branch is taken from session
        If Not _isSuperAdmin Then
            If lblBranch IsNot Nothing Then lblBranch.Visible = False
            If cboBranch IsNot Nothing Then cboBranch.Visible = False
        End If

        ' Add Category/Subcategory Selector
        Try
            categorySelector = New CategorySubcategorySelector()
            categorySelector.Name = "categorySelector"
            categorySelector.Location = New Point(12, 200)
            categorySelector.Anchor = AnchorStyles.Top Or AnchorStyles.Left Or AnchorStyles.Right
            Me.Controls.Add(categorySelector)
            AddHandler categorySelector.SelectionChanged, AddressOf OnCategorySelectionChanged
        Catch ex As Exception
            MessageBox.Show($"Error adding category selector: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try

        ' Add an Upload button next to the Primary Image URL field (created programmatically to avoid Designer edits)
        Try
            Dim btnUpload As New Button()
            btnUpload.Name = "btnUploadImage"
            btnUpload.Text = "Upload..."
            btnUpload.AutoSize = True
            If txtPrimaryImage IsNot Nothing Then
                btnUpload.Top = txtPrimaryImage.Top - 1
                btnUpload.Left = txtPrimaryImage.Right + 8
            Else
                btnUpload.Top = 12
                btnUpload.Left = 12
            End If
            AddHandler btnUpload.Click, AddressOf OnUploadImageClick
            Me.Controls.Add(btnUpload)
            btnUpload.BringToFront()
        Catch
        End Try
    End Sub

    Private Sub LoadBranches()
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return
            Using conn As New Microsoft.Data.SqlClient.SqlConnection(_connString)
                conn.Open()
                Dim hasBranches As Boolean
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT COUNT(1) FROM sys.tables WHERE name='Branches'", conn)
                    hasBranches = CInt(cmd.ExecuteScalar()) > 0
                End Using
                If hasBranches Then
                    Using da As New Microsoft.Data.SqlClient.SqlDataAdapter("SELECT BranchID, BranchName FROM dbo.Branches ORDER BY BranchName", conn)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        If _isSuperAdmin Then
                            cboBranch.DataSource = dt
                            cboBranch.DisplayMember = "BranchName"
                            cboBranch.ValueMember = "BranchID"
                        Else
                            ' Non-super admin: do not expose dropdown; optionally select their branch if present
                            Dim rows = dt.Select($"BranchID = {_sessionBranchId}")
                            If rows IsNot Nothing AndAlso rows.Length > 0 Then
                                cboBranch.DataSource = dt
                                cboBranch.DisplayMember = "BranchName"
                                cboBranch.ValueMember = "BranchID"
                                cboBranch.SelectedValue = _sessionBranchId
                            End If
                        End If
                    End Using
                Else
                    ' No branches table; allow NULL branch context
                    Dim dt As New DataTable()
                    dt.Columns.Add("BranchID", GetType(Integer))
                    dt.Columns.Add("BranchName", GetType(String))
                    Dim row = dt.NewRow()
                    row("BranchID") = DBNull.Value
                    row("BranchName") = "(No Branch / Global)"
                    dt.Rows.Add(row)
                    cboBranch.DataSource = dt
                    cboBranch.DisplayMember = "BranchName"
                    cboBranch.ValueMember = "BranchID"
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading branches: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If String.IsNullOrWhiteSpace(txtSKU.Text) OrElse String.IsNullOrWhiteSpace(txtName.Text) Then
            MessageBox.Show("SKU and Name are required.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        Try
            Using conn As New Microsoft.Data.SqlClient.SqlConnection(_connString)
                conn.Open()
                Dim tx As Microsoft.Data.SqlClient.SqlTransaction = conn.BeginTransaction()
                Try
                    Dim productId As Integer = EnsureProduct(conn, tx)
                    ' Ensure a variant (basic single-variant model for now)
                    Dim variantId As Integer = EnsureVariant(conn, tx, productId)
                    ' Apply reorder point and optional image
                    If numReorder.Value > 0D Then
                        Using cmd As New Microsoft.Data.SqlClient.SqlCommand("UPDATE dbo.Retail_Stock SET ReorderPoint=@rp WHERE VariantID=@vid; IF @@ROWCOUNT=0 INSERT INTO dbo.Retail_Stock(VariantID, BranchID, QtyOnHand, ReorderPoint, Location) VALUES(@vid, @bid, 0, @rp, NULL);", conn, tx)
                            cmd.Parameters.AddWithValue("@vid", variantId)
                            Dim bid As Object = GetBranchParam()
                            cmd.Parameters.AddWithValue("@bid", bid)
                            cmd.Parameters.AddWithValue("@rp", Decimal.ToInt32(numReorder.Value))
                            cmd.ExecuteNonQuery()
                        End Using
                    End If
                    ' Save image either as BLOB (preferred) if ImageData column exists, else fall back to URL
                    If _imageBytes IsNot Nothing AndAlso _imageBytes.Length > 0 AndAlso HasImageDataColumn(conn, tx) Then
                        Using cmd As New Microsoft.Data.SqlClient.SqlCommand("INSERT INTO dbo.Retail_ProductImage(ProductID, ImageUrl, ThumbnailUrl, IsPrimary, ImageData) VALUES(@pid, NULL, NULL, 1, @img)", conn, tx)
                            cmd.Parameters.AddWithValue("@pid", productId)
                            cmd.Parameters.Add("@img", SqlDbType.VarBinary, _imageBytes.Length).Value = _imageBytes
                            cmd.ExecuteNonQuery()
                        End Using
                    ElseIf Not String.IsNullOrWhiteSpace(txtPrimaryImage.Text) Then
                        Using cmd As New Microsoft.Data.SqlClient.SqlCommand("INSERT INTO dbo.Retail_ProductImage(ProductID, ImageUrl, IsPrimary) VALUES(@pid, @url, 1);", conn, tx)
                            cmd.Parameters.AddWithValue("@pid", productId)
                            cmd.Parameters.AddWithValue("@url", txtPrimaryImage.Text.Trim())
                            cmd.ExecuteNonQuery()
                        End Using
                    End If
                    tx.Commit()
                    MessageBox.Show("Product saved.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Catch ex As Exception
                    tx.Rollback()
                    Throw
                End Try
            End Using
        Catch ex As Exception
            MessageBox.Show("Save failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function EnsureProduct(conn As Microsoft.Data.SqlClient.SqlConnection, tx As Microsoft.Data.SqlClient.SqlTransaction) As Integer
        ' Try find by SKU; else insert - Use Products table with CategoryID/SubcategoryID
        Using cmdFind As New Microsoft.Data.SqlClient.SqlCommand("SELECT ProductID FROM dbo.Products WHERE SKU=@sku OR ProductCode=@sku", conn, tx)
            cmdFind.Parameters.AddWithValue("@sku", txtSKU.Text.Trim())
            Dim o = cmdFind.ExecuteScalar()
            If o IsNot Nothing AndAlso o IsNot DBNull.Value Then
                Dim pid = CInt(o)
                ' Get CategoryID and SubcategoryID from selector
                Dim catId As Integer = categorySelector.SelectedCategoryID
                Dim subId As Integer? = categorySelector.SelectedSubcategoryID
                Using cmdUpd As New Microsoft.Data.SqlClient.SqlCommand("UPDATE dbo.Products SET ProductName=@n, CategoryID=@cid, SubcategoryID=@sid WHERE ProductID=@id", conn, tx)
                    cmdUpd.Parameters.AddWithValue("@n", txtName.Text.Trim())
                    cmdUpd.Parameters.AddWithValue("@cid", catId)
                    cmdUpd.Parameters.AddWithValue("@sid", If(subId.HasValue, CType(subId.Value, Object), DBNull.Value))
                    cmdUpd.Parameters.AddWithValue("@id", pid)
                    cmdUpd.ExecuteNonQuery()
                End Using
                Return pid
            End If
        End Using
        Dim catId2 As Integer = categorySelector.SelectedCategoryID
        Dim subId2 As Integer? = categorySelector.SelectedSubcategoryID
        Using cmdIns As New Microsoft.Data.SqlClient.SqlCommand("INSERT INTO dbo.Products(SKU, ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, BaseUoM, IsActive) VALUES(@sku,@sku,@n,@cid,@sid,'External','ea',1); SELECT CAST(SCOPE_IDENTITY() AS INT);", conn, tx)
            cmdIns.Parameters.AddWithValue("@sku", txtSKU.Text.Trim())
            cmdIns.Parameters.AddWithValue("@n", txtName.Text.Trim())
            cmdIns.Parameters.AddWithValue("@cid", catId2)
            cmdIns.Parameters.AddWithValue("@sid", If(subId2.HasValue, CType(subId2.Value, Object), DBNull.Value))
            Return CInt(cmdIns.ExecuteScalar())
        End Using
    End Function

    Private Function EnsureVariant(conn As Microsoft.Data.SqlClient.SqlConnection, tx As Microsoft.Data.SqlClient.SqlTransaction, productId As Integer) As Integer
        Using cmd As New Microsoft.Data.SqlClient.SqlCommand("EXEC dbo.sp_Retail_EnsureVariant @ProductID=@pid, @Barcode=NULL, @VariantID=@vid OUTPUT; SELECT @vid;", conn, tx)
            cmd.Parameters.AddWithValue("@pid", productId)
            Dim pOut As New Microsoft.Data.SqlClient.SqlParameter("@vid", SqlDbType.Int)
            pOut.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pOut)
            Dim result = cmd.ExecuteScalar()
            Return Convert.ToInt32(result)
        End Using
    End Function

    Private Function GetBranchParam() As Object
        If _isSuperAdmin Then
            Dim v = If(cboBranch IsNot Nothing, cboBranch.SelectedValue, Nothing)
            Return If(v Is Nothing, DBNull.Value, v)
        End If
        If _sessionBranchId <= 0 Then Return DBNull.Value
        Return _sessionBranchId
    End Function

    Private Sub OnCategorySelectionChanged(sender As Object, e As EventArgs)
        ' Validate category selection before allowing save
        If categorySelector IsNot Nothing Then
            Dim validationMessage As String = categorySelector.ValidateSelection()
            If Not String.IsNullOrEmpty(validationMessage) Then
                ' Disable save functionality until proper classification is selected
                If btnSave IsNot Nothing Then
                    btnSave.Enabled = False
                End If
            Else
                ' Enable save when valid classification is selected
                If btnSave IsNot Nothing Then
                    btnSave.Enabled = True
                End If
            End If
        End If
    End Sub

    Private Sub OnUploadImageClick(sender As Object, e As EventArgs)
        Using dlg As New OpenFileDialog()
            dlg.Title = "Choose Product Image"
            dlg.Filter = "Image Files|*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.webp|All Files|*.*"
            dlg.Multiselect = False
            If dlg.ShowDialog(Me) = DialogResult.OK Then
                Try
                    _imageBytes = System.IO.File.ReadAllBytes(dlg.FileName)
                    If txtPrimaryImage IsNot Nothing Then
                        txtPrimaryImage.Text = dlg.FileName
                    End If
                Catch ex As Exception
                    MessageBox.Show(Me, "Failed to read image: " & ex.Message, "Upload Image", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    _imageBytes = Nothing
                End Try
            End If
        End Using
    End Sub

    Private Function HasImageDataColumn(conn As Microsoft.Data.SqlClient.SqlConnection, tx As Microsoft.Data.SqlClient.SqlTransaction) As Boolean
        Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT COUNT(1) FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Retail_ProductImage') AND name = 'ImageData'", conn, tx)
            Dim o = cmd.ExecuteScalar()
            Return o IsNot Nothing AndAlso o IsNot DBNull.Value AndAlso Convert.ToInt32(o) > 0
        End Using
    End Function
End Class
