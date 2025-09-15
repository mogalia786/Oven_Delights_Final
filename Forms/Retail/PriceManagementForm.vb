Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.IO
Imports System.Drawing
Imports Oven_Delights_ERP.UI

Public Partial Class PriceManagementForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _isSuperAdmin As Boolean
    Private ReadOnly _sessionBranchId As Integer
    Private ReadOnly _btnImageBrowse As New Button()
    Private ReadOnly _btnImageRemove As New Button()
    Private ReadOnly _picPreview As New PictureBox()
    Private ReadOnly _cboProduct As New ComboBox()

    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrWhiteSpace(_connString) Then
            MessageBox.Show("Missing connection string 'OvenDelightsERPConnectionString' in App.config.", "Config Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
        _isSuperAdmin = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        _sessionBranchId = If(AppSession.CurrentUser IsNot Nothing AndAlso AppSession.CurrentUser.BranchID.HasValue, AppSession.CurrentUser.BranchID.Value, 0)
        LoadBranches()
        dtpEffectiveFrom.Value = Date.Today
        AddHandler btnLoad.Click, AddressOf btnLoad_Click
        AddHandler btnSetPrice.Click, AddressOf btnSetPrice_Click
        ' Runtime UI: product dropdown using ProductDropdown helper
        Try
            Dim productDropdown As ComboBox = UI.ProductDropdown.Create(Me, txtSKU)
            AddHandler productDropdown.SelectedValueChanged, AddressOf OnProductSelected
            Dim lblSku As Label = TryCast(Me.Controls("lblSKU"), Label)
            If lblSku IsNot Nothing Then lblSku.Text = "Product"
        Catch
        End Try
        ' Runtime UI: image preview + upload/remove
        Try
            _picPreview.BorderStyle = BorderStyle.FixedSingle
            _picPreview.SizeMode = PictureBoxSizeMode.Zoom
            _picPreview.Width = 160
            _picPreview.Height = 160
            _picPreview.Left = Math.Max(12, Me.ClientSize.Width - 180)
            _picPreview.Top = 12
            _picPreview.Anchor = AnchorStyles.Top Or AnchorStyles.Right
            Me.Controls.Add(_picPreview)

            _btnImageBrowse.Text = "Add/Change Image…"
            _btnImageBrowse.AutoSize = True
            _btnImageBrowse.Left = _picPreview.Left
            _btnImageBrowse.Top = _picPreview.Bottom + 8
            _btnImageBrowse.Anchor = AnchorStyles.Top Or AnchorStyles.Right
            AddHandler _btnImageBrowse.Click, AddressOf OnBrowseImage
            Me.Controls.Add(_btnImageBrowse)

            _btnImageRemove.Text = "Remove Image"
            _btnImageRemove.AutoSize = True
            _btnImageRemove.Left = _picPreview.Left
            _btnImageRemove.Top = _btnImageBrowse.Bottom + 6
            _btnImageRemove.Anchor = AnchorStyles.Top Or AnchorStyles.Right
            AddHandler _btnImageRemove.Click, AddressOf OnRemoveImage
            Me.Controls.Add(_btnImageRemove)
        Catch
        End Try
        ' Hide branch selector for non-super admin
        If Not _isSuperAdmin Then
            If lblBranch IsNot Nothing Then lblBranch.Visible = False
            If cboBranch IsNot Nothing Then cboBranch.Visible = False
        End If
        ' Dropdown already populated by helper
    End Sub

    Private Sub LoadBranches()
        Try
            Using conn As New SqlConnection(_connString)
                If String.IsNullOrWhiteSpace(_connString) Then Return
                
                If _isSuperAdmin Then
                    ' Super admin: see all branches
                    Dim sql As String = "SELECT BranchID, BranchName FROM dbo.Branches ORDER BY BranchName"
                    Using da As New SqlDataAdapter(sql, conn)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        If dt.Rows.Count > 0 Then
                            cboBranch.DataSource = dt
                            cboBranch.DisplayMember = "BranchName"
                            cboBranch.ValueMember = "BranchID"
                        Else
                            ' Fallback to global option
                            Dim dtGlobal As New DataTable()
                            dtGlobal.Columns.Add("BranchID", GetType(Integer))
                            dtGlobal.Columns.Add("BranchName", GetType(String))
                            Dim row = dtGlobal.NewRow()
                            row("BranchID") = DBNull.Value
                            row("BranchName") = "(No Branch / Global)"
                            dtGlobal.Rows.Add(row)
                            cboBranch.DataSource = dtGlobal
                            cboBranch.DisplayMember = "BranchName"
                            cboBranch.ValueMember = "BranchID"
                        End If
                    End Using
                Else
                    ' Regular user: only show their assigned branch
                    If _sessionBranchId > 0 Then
                        Dim sql As String = "SELECT BranchID, BranchName FROM dbo.Branches WHERE BranchID = @branchId"
                        Using da As New SqlDataAdapter(sql, conn)
                            da.SelectCommand.Parameters.AddWithValue("@branchId", _sessionBranchId)
                            Dim dt As New DataTable()
                            da.Fill(dt)
                            If dt.Rows.Count > 0 Then
                                cboBranch.DataSource = dt
                                cboBranch.DisplayMember = "BranchName"
                                cboBranch.ValueMember = "BranchID"
                                cboBranch.SelectedValue = _sessionBranchId
                                cboBranch.Enabled = False ' Disable selection for regular users
                            End If
                        End Using
                    Else
                        ' No branch assigned - show global option
                        Dim dtGlobal As New DataTable()
                        dtGlobal.Columns.Add("BranchID", GetType(Integer))
                        dtGlobal.Columns.Add("BranchName", GetType(String))
                        Dim row = dtGlobal.NewRow()
                        row("BranchID") = DBNull.Value
                        row("BranchName") = "(No Branch / Global)"
                        dtGlobal.Rows.Add(row)
                        cboBranch.DataSource = dtGlobal
                        cboBranch.DisplayMember = "BranchName"
                        cboBranch.ValueMember = "BranchID"
                        cboBranch.Enabled = False
                    End If
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading branches: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnLoad_Click(sender As Object, e As EventArgs)
        If String.IsNullOrWhiteSpace(txtSKU.Text) Then
            MessageBox.Show("Select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        LoadPriceHistory()
    End Sub

    Private Sub LoadPriceHistory()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql As String = "SELECT p.ProductID, p.SKU, p.Name, pr.BranchID, pr.SellingPrice, pr.Currency, pr.EffectiveFrom, pr.EffectiveTo " & _
                                    "FROM dbo.Retail_Product p " & _
                                    "LEFT JOIN dbo.Retail_Price pr ON pr.ProductID = p.ProductID AND (@bid IS NULL OR pr.BranchID = @bid) " & _
                                    "WHERE p.SKU = @sku " & _
                                    "ORDER BY pr.EffectiveFrom DESC"
                Using da As New SqlDataAdapter(sql, conn)
                    Dim bid As Object = GetBranchParam()
                    da.SelectCommand.Parameters.AddWithValue("@sku", txtSKU.Text.Trim())
                    da.SelectCommand.Parameters.AddWithValue("@bid", bid)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvHistory.DataSource = dt
                End Using
            End Using
            ' Refresh image preview for this SKU
            LoadPrimaryImageForSku(txtSKU.Text.Trim())
        Catch ex As Exception
            MessageBox.Show("Error loading price history: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnSetPrice_Click(sender As Object, e As EventArgs)
        If String.IsNullOrWhiteSpace(txtSKU.Text) Then
            MessageBox.Show("Select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If numPrice.Value <= 0D Then
            MessageBox.Show("Enter a valid price.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using tx = conn.BeginTransaction()
                    Try
                        Dim productId As Integer = 0
                        Using cmd As New SqlCommand("SELECT TOP 1 ProductID FROM dbo.Retail_Product WHERE SKU = @sku", conn, tx)
                            cmd.Parameters.AddWithValue("@sku", txtSKU.Text.Trim())
                            Dim o = cmd.ExecuteScalar()
                            If o Is Nothing OrElse o Is DBNull.Value Then
                                MessageBox.Show("SKU not found.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                tx.Rollback()
                                Return
                            End If
                            productId = Convert.ToInt32(o)
                        End Using
                        Using ins As New SqlCommand("INSERT INTO dbo.Retail_Price(ProductID, BranchID, SellingPrice, Currency, EffectiveFrom, EffectiveTo) VALUES(@pid, @bid, @prc, @cur, @from, NULL)", conn, tx)
                            Dim bid As Object = GetBranchParam()
                            ins.Parameters.AddWithValue("@pid", productId)
                            ins.Parameters.AddWithValue("@bid", bid)
                            ins.Parameters.AddWithValue("@prc", CDec(numPrice.Value))
                            ins.Parameters.AddWithValue("@cur", If(String.IsNullOrWhiteSpace(txtCurrency.Text), "ZAR", txtCurrency.Text.Trim()))
                            ins.Parameters.AddWithValue("@from", dtpEffectiveFrom.Value.Date)
                            ins.ExecuteNonQuery()
                        End Using
                        tx.Commit()
                    Catch
                        tx.Rollback()
                        Throw
                    End Try
                End Using
            End Using
            LoadPriceHistory()
            MessageBox.Show("Price set.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Error setting price: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' Product list provided by ProductDropdown helper; custom loader removed

    Private Sub OnProductSelected(sender As Object, e As EventArgs)
        If Not String.IsNullOrWhiteSpace(txtSKU.Text) Then
            LoadPriceHistory()
            LoadPrimaryImageForSku(txtSKU.Text.Trim())
        End If
    End Sub

    Private Function GetBranchParam() As Object
        If _isSuperAdmin Then
            Dim v = If(cboBranch IsNot Nothing, cboBranch.SelectedValue, Nothing)
            Return If(v Is Nothing, DBNull.Value, v)
        End If
        If _sessionBranchId <= 0 Then Return DBNull.Value
        Return _sessionBranchId
    End Function

    ' ------- Product Image (BLOB) helpers -------
    Private Sub OnBrowseImage(sender As Object, e As EventArgs)
        If String.IsNullOrWhiteSpace(txtSKU.Text) Then
            MessageBox.Show("Enter a SKU first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        Using ofd As New OpenFileDialog()
            ofd.Title = "Select Product Image"
            ofd.Filter = "Image Files|*.jpg;*.jpeg;*.png;*.bmp;*.gif|All Files|*.*"
            If ofd.ShowDialog(Me) = DialogResult.OK Then
                Try
                    Dim bytes = File.ReadAllBytes(ofd.FileName)
                    Dim img As Image = Nothing
                    Using ms As New MemoryStream(bytes)
                        img = Image.FromStream(ms)
                    End Using
                    _picPreview.Image = img
                    Dim productId = GetProductIdBySku(txtSKU.Text.Trim())
                    If productId <= 0 Then
                        MessageBox.Show("SKU not found.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        Return
                    End If
                    SavePrimaryImage(productId, bytes)
                    MessageBox.Show("Image saved.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Catch ex As Exception
                    MessageBox.Show("Failed to save image: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        End Using
    End Sub

    Private Sub OnRemoveImage(sender As Object, e As EventArgs)
        If String.IsNullOrWhiteSpace(txtSKU.Text) Then
            MessageBox.Show("Enter a SKU first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        Try
            Dim productId = GetProductIdBySku(txtSKU.Text.Trim())
            If productId <= 0 Then
                MessageBox.Show("SKU not found.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If
            RemovePrimaryImage(productId)
            _picPreview.Image = Nothing
            MessageBox.Show("Image removed.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Failed to remove image: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function GetProductIdBySku(sku As String) As Integer
        If String.IsNullOrWhiteSpace(sku) Then Return 0
        Try
            Using cn As New SqlConnection(_connString)
                Using cmd As New SqlCommand("SELECT TOP 1 ProductID FROM dbo.Retail_Product WHERE SKU=@sku", cn)
                    cmd.Parameters.AddWithValue("@sku", sku)
                    cn.Open()
                    Dim o = cmd.ExecuteScalar()
                    If o IsNot Nothing AndAlso o IsNot DBNull.Value Then Return Convert.ToInt32(o)
                End Using
            End Using
        Catch
        End Try
        Return 0
    End Function

    Private Sub SavePrimaryImage(productId As Integer, bytes As Byte())
        Using cn As New SqlConnection(_connString)
            cn.Open()
            Using tx = cn.BeginTransaction()
                Try
                    Dim imageId As Integer = 0
                    Using cmd As New SqlCommand("SELECT TOP 1 ImageID FROM dbo.Retail_ProductImage WHERE ProductID=@pid AND IsPrimary=1 ORDER BY ImageID", cn, tx)
                        cmd.Parameters.AddWithValue("@pid", productId)
                        Dim o = cmd.ExecuteScalar()
                        If o IsNot Nothing AndAlso o IsNot DBNull.Value Then imageId = Convert.ToInt32(o)
                    End Using
                    If imageId = 0 Then
                        Using ins As New SqlCommand("INSERT INTO dbo.Retail_ProductImage(ProductID, ImageUrl, ThumbnailUrl, IsPrimary) VALUES(@pid, NULL, NULL, 1); SELECT CAST(SCOPE_IDENTITY() AS INT);", cn, tx)
                            ins.Parameters.AddWithValue("@pid", productId)
                            imageId = Convert.ToInt32(ins.ExecuteScalar())
                        End Using
                    End If
                    Using up As New SqlCommand("UPDATE dbo.Retail_ProductImage SET ImageData=@data WHERE ImageID=@iid", cn, tx)
                        up.Parameters.AddWithValue("@data", bytes)
                        up.Parameters.AddWithValue("@iid", imageId)
                        up.ExecuteNonQuery()
                    End Using
                    tx.Commit()
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Private Sub RemovePrimaryImage(productId As Integer)
        Using cn As New SqlConnection(_connString)
            cn.Open()
            Using cmd As New SqlCommand("UPDATE dbo.Retail_ProductImage SET ImageData = NULL WHERE ProductID=@pid AND IsPrimary=1", cn)
                cmd.Parameters.AddWithValue("@pid", productId)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub LoadPrimaryImageForSku(sku As String)
        _picPreview.Image = Nothing
        If String.IsNullOrWhiteSpace(sku) Then Return
        Try
            Using cn As New SqlConnection(_connString)
                Using cmd As New SqlCommand("SELECT TOP 1 CAST(ImageData AS VARBINARY(MAX)) FROM dbo.Retail_ProductImage rpi INNER JOIN dbo.Retail_Product rp ON rp.ProductID = rpi.ProductID WHERE rp.SKU=@sku AND rpi.IsPrimary=1 AND rpi.ImageData IS NOT NULL ORDER BY rpi.ImageID DESC", cn)
                    cmd.Parameters.AddWithValue("@sku", sku)
                    cn.Open()
                    Dim o = cmd.ExecuteScalar()
                    If o IsNot Nothing AndAlso o IsNot DBNull.Value Then
                        Dim bytes = DirectCast(o, Byte())
                        Using ms As New MemoryStream(bytes)
                            _picPreview.Image = Image.FromStream(ms)
                        End Using
                    End If
                End Using
            End Using
        Catch
        End Try
    End Sub
End Class
