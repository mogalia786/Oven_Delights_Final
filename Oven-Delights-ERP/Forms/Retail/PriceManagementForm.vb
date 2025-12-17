Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.IO
Imports System.Drawing
Imports Oven_Delights_ERP.UI

Public Class PriceManagementForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _sessionBranchId As Integer
    Private _selectedProductId As Integer = 0

    ' UI Controls
    Private pnlHeader As Panel
    Private lblTitle As Label
    Private picLogo As PictureBox
    Private pnlMain As Panel
    Private grpProduct As GroupBox
    Private lblProduct As Label
    Private cboProduct As ComboBox
    Private grpPricing As GroupBox
    Private lblPrice As Label
    Private numPrice As NumericUpDown
    Private lblCurrency As Label
    Private txtCurrency As TextBox
    Private lblRecommended As Label
    Private lblRecommendedValue As Label
    Private btnSave As Button
    Private grpImage As GroupBox
    Private picProduct As PictureBox
    Private btnBrowseImage As Button
    Private btnRemoveImage As Button
    Private dgvPrices As DataGridView

    Public Sub New()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _sessionBranchId = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 1)

        InitializeCustomComponents()
        ApplyTheme()
        LoadProducts()
    End Sub

    Private Sub InitializeCustomComponents()
        Me.Text = "Price Management - Oven Delights"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.FromArgb(245, 245, 245)

        ' Header Panel
        pnlHeader = New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = Color.FromArgb(230, 126, 34)
        }

        ' Logo
        picLogo = New PictureBox With {
            .Location = New Point(20, 15),
            .Size = New Size(50, 50),
            .SizeMode = PictureBoxSizeMode.Zoom
        }
        Try
            picLogo.Image = Image.FromFile("logo.png")
        Catch
            ' No logo file
        End Try

        ' Title
        lblTitle = New Label With {
            .Text = "PRICE MANAGEMENT",
            .Font = New Font("Segoe UI", 20, FontStyle.Bold),
            .ForeColor = Color.White,
            .Location = New Point(80, 20),
            .AutoSize = True
        }

        pnlHeader.Controls.AddRange({picLogo, lblTitle})

        ' Main Panel
        pnlMain = New Panel With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(20)
        }

        ' Product Selection Group
        grpProduct = New GroupBox With {
            .Text = "Select Product",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(20, 100),
            .Size = New Size(750, 80),
            .ForeColor = Color.FromArgb(52, 73, 94)
        }

        lblProduct = New Label With {
            .Text = "Product:",
            .Location = New Point(15, 35),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 10)
        }

        cboProduct = New ComboBox With {
            .Location = New Point(90, 32),
            .Size = New Size(640, 25),
            .DropDownStyle = ComboBoxStyle.DropDown,
            .AutoCompleteMode = AutoCompleteMode.SuggestAppend,
            .AutoCompleteSource = AutoCompleteSource.ListItems,
            .Font = New Font("Segoe UI", 10)
        }
        AddHandler cboProduct.SelectedIndexChanged, AddressOf OnProductSelected

        grpProduct.Controls.AddRange({lblProduct, cboProduct})

        ' Pricing Group
        grpPricing = New GroupBox With {
            .Text = "Set Price",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(20, 190),
            .Size = New Size(750, 120),
            .ForeColor = Color.FromArgb(52, 73, 94)
        }

        lblPrice = New Label With {
            .Text = "Selling Price:",
            .Location = New Point(15, 40),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 10)
        }

        numPrice = New NumericUpDown With {
            .Location = New Point(110, 37),
            .Size = New Size(150, 25),
            .DecimalPlaces = 2,
            .Maximum = 1000000,
            .Font = New Font("Segoe UI", 10)
        }

        lblCurrency = New Label With {
            .Text = "Currency:",
            .Location = New Point(280, 40),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 10)
        }
        txtCurrency = New TextBox With {
            .Location = New Point(360, 37),
            .Size = New Size(80, 25),
            .Text = "ZAR",
            .Font = New Font("Segoe UI", 10)
        }

        lblRecommended = New Label With {
            .Text = "Recommended (Avg Cost):",
            .Location = New Point(15, 75),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 9),
            .ForeColor = Color.FromArgb(127, 140, 141)
        }

        lblRecommendedValue = New Label With {
            .Text = "R 0.00",
            .Location = New Point(180, 75),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 152, 219)
        }

        btnSave = New Button With {
            .Text = "💾SAVE PRICE",
            .Location = New Point(460, 32),
            .Size = New Size(150, 40),
            .BackColor = Color.FromArgb(46, 204, 113),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Cursor = Cursors.Hand
        }
        btnSave.FlatAppearance.BorderSize = 0
        AddHandler btnSave.Click, AddressOf btnSave_Click

        grpPricing.Controls.AddRange({lblPrice, numPrice, lblCurrency, txtCurrency, lblRecommended, lblRecommendedValue, btnSave})

        ' Image Group
        grpImage = New GroupBox With {
            .Text = "Product Image",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(780, 100),
            .Size = New Size(380, 210),
            .ForeColor = Color.FromArgb(52, 73, 94)
        }

        picProduct = New PictureBox With {
            .Location = New Point(15, 30),
            .Size = New Size(350, 120),
            .BorderStyle = BorderStyle.FixedSingle,
            .SizeMode = PictureBoxSizeMode.Zoom,
            .BackColor = Color.White
        }

        btnBrowseImage = New Button With {
            .Text = "📁 Add/Change Image",
            .Location = New Point(15, 160),
            .Size = New Size(170, 35),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .Cursor = Cursors.Hand
        }
        btnBrowseImage.FlatAppearance.BorderSize = 0
        AddHandler btnBrowseImage.Click, AddressOf OnBrowseImage

        btnRemoveImage = New Button With {
            .Text = "🗑️ Remove Image",
            .Location = New Point(195, 160),
            .Size = New Size(170, 35),
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .Cursor = Cursors.Hand
        }
        btnRemoveImage.FlatAppearance.BorderSize = 0
        AddHandler btnRemoveImage.Click, AddressOf OnRemoveImage

        grpImage.Controls.AddRange({picProduct, btnBrowseImage, btnRemoveImage})

        ' Price History Grid
        dgvPrices = New DataGridView With {
            .Location = New Point(20, 320),
            .Size = New Size(1140, 300),
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .ColumnHeadersDefaultCellStyle = New DataGridViewCellStyle With {
                .BackColor = Color.FromArgb(52, 73, 94),
                .ForeColor = Color.White,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Alignment = DataGridViewContentAlignment.MiddleLeft
            },
            .DefaultCellStyle = New DataGridViewCellStyle With {
                .Font = New Font("Segoe UI", 9),
                .SelectionBackColor = Color.FromArgb(230, 126, 34),
                .SelectionForeColor = Color.White
            },
            .RowHeadersVisible = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }

        pnlMain.Controls.AddRange({grpProduct, grpPricing, grpImage, dgvPrices})

        Me.Controls.AddRange({pnlHeader, pnlMain})
    End Sub

    Private Sub ApplyTheme()
        ' Theme colors already applied during button creation
        ' Orange header: #E67E22
        ' Green save: #2ECC71
        ' Blue image: #3498DB
        ' Red remove: #E74C3C
    End Sub

    Private Sub LoadProducts()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim sql = "SELECT DISTINCT p.ProductID, p.ProductCode, p.Name AS ProductName, " &
                         "p.Name + ' [' + COALESCE(p.SKU, p.ProductCode, 'No Code') + ']' AS DisplayText " &
                         "FROM Demo_Retail_Product p " &
                         "WHERE p.IsActive = 1 AND p.BranchID = @bid " &
                         "ORDER BY p.Name"
                Using da As New SqlDataAdapter(sql, conn)
                    da.SelectCommand.Parameters.AddWithValue("@bid", _sessionBranchId)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    cboProduct.DataSource = dt
                    cboProduct.DisplayMember = "DisplayText"
                    cboProduct.ValueMember = "ProductID"
                    cboProduct.SelectedIndex = -1
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnProductSelected(sender As Object, e As EventArgs)
        Try
            If cboProduct.SelectedValue Is Nothing OrElse IsDBNull(cboProduct.SelectedValue) Then Return

            ' Handle both DataRowView and direct value
            Dim value = cboProduct.SelectedValue
            If TypeOf value Is DataRowView Then
                Dim drv As DataRowView = DirectCast(value, DataRowView)
                _selectedProductId = Convert.ToInt32(drv("ProductID"))
            Else
                _selectedProductId = Convert.ToInt32(value)
            End If

            LoadProductPrice()
            LoadProductImage()
        Catch ex As Exception
            ' Ignore selection errors during initialization
        End Try
    End Sub

    Private Sub LoadProductPrice()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()

                ' Get current selling price from Demo_Retail_Price
                Dim sql = "SELECT SellingPrice FROM Demo_Retail_Price " &
                         "WHERE ProductID = @pid AND BranchID = @bid"

                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@pid", _selectedProductId)
                    cmd.Parameters.AddWithValue("@bid", _sessionBranchId)

                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            numPrice.Value = If(IsDBNull(reader("SellingPrice")), 0, Convert.ToDecimal(reader("SellingPrice")))
                            txtCurrency.Text = "ZAR"
                        Else
                            ' No price set yet
                            numPrice.Value = 0
                            txtCurrency.Text = "ZAR"
                        End If
                    End Using
                End Using

                ' Get average cost (recommended price) from Demo_Retail_Price
                Dim avgCost As Decimal = 0
                Dim sqlAvg = "SELECT TOP 1 ISNULL(CostPrice, 0) AS AvgCost " &
                            "FROM Demo_Retail_Price " &
                            "WHERE ProductID = @pid AND BranchID = @bid " &
                            "ORDER BY CreatedAt DESC"

                Using cmdAvg As New SqlCommand(sqlAvg, conn)
                    cmdAvg.Parameters.AddWithValue("@pid", _selectedProductId)
                    cmdAvg.Parameters.AddWithValue("@bid", _sessionBranchId)
                    Dim result = cmdAvg.ExecuteScalar()
                    If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                        avgCost = Convert.ToDecimal(result)
                    End If
                End Using

                ' Display recommended price
                lblRecommendedValue.Text = $"R {avgCost:F2}"
                If avgCost > 0 Then
                    lblRecommendedValue.ForeColor = Color.FromArgb(46, 204, 113) ' Green if has cost
                Else
                    lblRecommendedValue.ForeColor = Color.FromArgb(231, 76, 60) ' Red if no cost
                End If

                ' Load price history
                LoadPriceHistory()
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading price: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadPriceHistory()
        Try
            Using conn As New SqlConnection(_connString)
                ' Load pricing info from Demo_Retail_Price
                Dim sql = "SELECT " &
                         "p.Name AS ProductName, " &
                         "p.ProductCode, " &
                         "b.BranchName, " &
                         "pr.CostPrice, " &
                         "pr.SellingPrice, " &
                         "'ZAR' AS Currency, " &
                         "pr.CreatedAt, " &
                         "'Current' AS Status " &
                         "FROM Demo_Retail_Price pr " &
                         "INNER JOIN Demo_Retail_Product p ON p.ProductID = pr.ProductID " &
                         "INNER JOIN Branches b ON b.BranchID = pr.BranchID " &
                         "WHERE pr.ProductID = @pid " &
                         "ORDER BY pr.CreatedAt DESC"

                Using da As New SqlDataAdapter(sql, conn)
                    da.SelectCommand.Parameters.AddWithValue("@pid", _selectedProductId)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvPrices.DataSource = dt
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading price history: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs)
        If _selectedProductId = 0 Then
            MessageBox.Show("Please select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If numPrice.Value <= 0 Then
            MessageBox.Show("Please enter a valid price.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using tx = conn.BeginTransaction()
                    Try
                        ' Check if product exists in Demo_Retail_Product for this branch
                        Dim productExists As Boolean = False
                        Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Demo_Retail_Product WHERE ProductID = @pid AND BranchID = @bid", conn, tx)
                            cmdCheck.Parameters.AddWithValue("@pid", _selectedProductId)
                            cmdCheck.Parameters.AddWithValue("@bid", _sessionBranchId)
                            productExists = Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0
                        End Using
                        
                        If Not productExists Then
                            MessageBox.Show("This product does not exist for the selected branch. Please ensure the product is created for this branch first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                            tx.Rollback()
                            Return
                        End If
                        
                        ' Update or Insert selling price in Demo_Retail_Price
                        Dim cmdUpsert As New SqlCommand(
                            "IF EXISTS (SELECT 1 FROM Demo_Retail_Price WHERE ProductID = @pid AND BranchID = @bid) " &
                            "BEGIN " &
                            "  UPDATE Demo_Retail_Price SET SellingPrice = @price, EffectiveFrom = GETDATE() " &
                            "  WHERE ProductID = @pid AND BranchID = @bid " &
                            "END " &
                            "ELSE " &
                            "BEGIN " &
                            "  INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom, CreatedAt) " &
                            "  VALUES (@pid, @bid, @price, 0, GETDATE(), GETDATE()) " &
                            "END", conn, tx)
                        cmdUpsert.Parameters.AddWithValue("@pid", _selectedProductId)
                        cmdUpsert.Parameters.AddWithValue("@bid", _sessionBranchId)
                        cmdUpsert.Parameters.AddWithValue("@price", numPrice.Value)
                        
                        ' DEBUG: Show what we're saving
                        MessageBox.Show($"Saving Price:{vbCrLf}ProductID: {_selectedProductId}{vbCrLf}BranchID: {_sessionBranchId}{vbCrLf}Price: R {numPrice.Value:N2}", "DEBUG", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        
                        cmdUpsert.ExecuteNonQuery()

                        tx.Commit()
                        MessageBox.Show("Price saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        LoadProductPrice()
                    Catch
                        tx.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error saving price: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnBrowseImage(sender As Object, e As EventArgs)
        If _selectedProductId = 0 Then
            MessageBox.Show("Please select a product first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Using ofd As New OpenFileDialog()
            ofd.Title = "Select Product Image"
            ofd.Filter = "Image Files|*.jpg;*.jpeg;*.png;*.bmp;*.gif|All Files|*.*"
            If ofd.ShowDialog(Me) = DialogResult.OK Then
                Try
                    ' Load and resize image to prevent out of memory errors
                    Using originalImg As Image = Image.FromFile(ofd.FileName)
                        ' Resize to max 800x800
                        Dim maxSize As Integer = 800
                        Dim newWidth As Integer = originalImg.Width
                        Dim newHeight As Integer = originalImg.Height
                        
                        If originalImg.Width > maxSize OrElse originalImg.Height > maxSize Then
                            Dim ratio As Double = Math.Min(maxSize / CDbl(originalImg.Width), maxSize / CDbl(originalImg.Height))
                            newWidth = CInt(originalImg.Width * ratio)
                            newHeight = CInt(originalImg.Height * ratio)
                        End If
                        
                        ' Create resized image
                        Dim resizedImg As New Bitmap(newWidth, newHeight)
                        Using g As Graphics = Graphics.FromImage(resizedImg)
                            g.InterpolationMode = Drawing2D.InterpolationMode.HighQualityBicubic
                            g.DrawImage(originalImg, 0, 0, newWidth, newHeight)
                        End Using
                        
                        ' Dispose old image
                        If picProduct.Image IsNot Nothing Then
                            picProduct.Image.Dispose()
                        End If
                        picProduct.Image = resizedImg
                        
                        ' Convert to byte array
                        Using ms As New MemoryStream()
                            resizedImg.Save(ms, Imaging.ImageFormat.Jpeg)
                            Dim bytes = ms.ToArray()
                            SaveProductImage(bytes)
                        End Using
                    End Using
                    MessageBox.Show("Image saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Catch ex As Exception
                    MessageBox.Show($"Error saving image: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        End Using
    End Sub

    Private Sub OnRemoveImage(sender As Object, e As EventArgs)
        If _selectedProductId = 0 Then
            MessageBox.Show("Please select a product first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using cmd As New SqlCommand("UPDATE Products SET ProductImage = NULL WHERE ProductID = @pid", conn)
                    cmd.Parameters.AddWithValue("@pid", _selectedProductId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            picProduct.Image = Nothing
            MessageBox.Show("Image removed successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error removing image: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SaveProductImage(bytes As Byte())
        Using conn As New SqlConnection(_connString)
            conn.Open()
            Using cmd As New SqlCommand("UPDATE Products SET ProductImage = @img WHERE ProductID = @pid", conn)
                cmd.Parameters.AddWithValue("@img", bytes)
                cmd.Parameters.AddWithValue("@pid", _selectedProductId)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub LoadProductImage()
        picProduct.Image = Nothing
        If _selectedProductId = 0 Then Return

        Try
            ' Dispose old image first
            If picProduct.Image IsNot Nothing Then
                picProduct.Image.Dispose()
                picProduct.Image = Nothing
            End If
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using cmd As New SqlCommand("SELECT ProductImage FROM Products WHERE ProductID = @pid", conn)
                    cmd.Parameters.AddWithValue("@pid", _selectedProductId)
                    Dim result = cmd.ExecuteScalar()
                    If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                        Dim bytes = DirectCast(result, Byte())
                        If bytes.Length > 0 Then
                            Using ms As New MemoryStream(bytes)
                                ' Create a copy of the image to avoid memory stream disposal issues
                                Using tempImg As Image = Image.FromStream(ms)
                                    picProduct.Image = New Bitmap(tempImg)
                                End Using
                            End Using
                        End If
                    End If
                End Using
            End Using
        Catch
            ' No image or error loading
        End Try
    End Sub
End Class
