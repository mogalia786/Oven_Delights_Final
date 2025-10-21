Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.IO

Namespace Manufacturing

    Public Class AddProductForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        ' Logo colors: Orange (#E67E22), Dark Brown (#6E2C00), Cream (#F5DEB3)
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(230, 126, 34) ' Orange
        Private ReadOnly ColorDark As Color = Color.FromArgb(110, 44, 0) ' Dark Brown
        Private ReadOnly ColorLight As Color = Color.FromArgb(245, 222, 179) ' Cream
        Private ReadOnly ColorAccent As Color = Color.FromArgb(183, 58, 46) ' Red accent

        Private WithEvents categorySelector As CategorySubcategorySelector
        Private txtProductName As TextBox
        Private WithEvents txtProductCode As TextBox
        Private txtSKU As TextBox
        Private picBarcode As PictureBox
        Private txtDescription As TextBox
        Private cmbItemType As ComboBox
        Private txtLastPaidPrice As TextBox
        Private txtAverageCost As TextBox
        Private txtReorderLevel As TextBox
        Private txtReorderQuantity As TextBox
        Private chkIsActive As CheckBox
        Private btnSave As Button
        Private btnCancel As Button
        Private btnUploadImage As Button
        Private picProductImage As PictureBox
        Private _productImageBytes As Byte() = Nothing

        Public Sub New()
            Me.Text = "Add New Product - Oven Delights"
            Me.Width = 900
            Me.Height = 800
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False
            Me.BackColor = Color.White
            InitializeUI()
        End Sub

        Private Sub InitializeUI()
            ' Header Panel with gradient
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = ColorDark
            }
            
            Dim lblHeader As New Label() With {
                .Text = "✨ Add New Product",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Left = 30,
                .Top = 25
            }
            
            Dim lblSubHeader As New Label() With {
                .Text = "Create a new product (internal/manufactured or external/purchased)",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorLight,
                .AutoSize = True,
                .Left = 30,
                .Top = 52
            }
            
            pnlHeader.Controls.AddRange({lblHeader, lblSubHeader})

            ' Main content panel
            Dim pnlMain As New Panel() With {
                .Dock = DockStyle.Fill,
                .Padding = New Padding(30),
                .BackColor = Color.White,
                .AutoScroll = True
            }

            ' Left side - Form fields
            Dim pnlLeft As New Panel() With {.Left = 0, .Top = 0, .Width = 520, .Height = 650}
            
            Dim y As Integer = 10
            Dim labelFont As New Font("Segoe UI", 10, FontStyle.Bold)
            Dim textFont As New Font("Segoe UI", 10)

            ' Product Name
            Dim lblName As New Label() With {
                .Text = "Product Name *",
                .Left = 0,
                .Top = y,
                .Width = 150,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            txtProductName = New TextBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 480,
                .Font = textFont,
                .BorderStyle = BorderStyle.FixedSingle
            }
            y += 70

            ' Product Code
            Dim lblCode As New Label() With {
                .Text = "Product Code *",
                .Left = 0,
                .Top = y,
                .Width = 150,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            txtProductCode = New TextBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 230,
                .Font = textFont,
                .BorderStyle = BorderStyle.FixedSingle
            }
            y += 70
            
            ' SKU (Barcode)
            Dim lblSKU As New Label() With {
                .Text = "SKU (Barcode)",
                .Left = 0,
                .Top = y,
                .Width = 150,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            txtSKU = New TextBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 230,
                .Font = textFont,
                .BorderStyle = BorderStyle.FixedSingle,
                .ReadOnly = True,
                .BackColor = ColorLight
            }
            
            ' Barcode image display
            picBarcode = New PictureBox() With {
                .Left = 240,
                .Top = y + 5,
                .Width = 240,
                .Height = 60,
                .BorderStyle = BorderStyle.FixedSingle,
                .BackColor = Color.White,
                .SizeMode = PictureBoxSizeMode.CenterImage
            }
            y += 70
            
            ' Item Type
            Dim lblItemType As New Label() With {
                .Text = "Product Type *",
                .Left = 0,
                .Top = y,
                .Width = 150,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            cmbItemType = New ComboBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 230,
                .Font = textFont,
                .DropDownStyle = ComboBoxStyle.DropDownList
            }
            cmbItemType.Items.AddRange({"internal", "external"})
            cmbItemType.SelectedIndex = 0 ' Default to internal
            y += 70

            ' Category (subcategory optional)
            Dim lblCategory As New Label() With {
                .Text = "Category *",
                .Left = 0,
                .Top = y,
                .Width = 150,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            categorySelector = New CategorySubcategorySelector()
            categorySelector.Location = New Point(0, y + 25)
            categorySelector.Width = 480
            y += 70

            ' Description
            Dim lblDesc As New Label() With {
                .Text = "Description",
                .Left = 0,
                .Top = y,
                .Width = 150,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            txtDescription = New TextBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 480,
                .Height = 70,
                .Multiline = True,
                .Font = textFont,
                .BorderStyle = BorderStyle.FixedSingle,
                .ScrollBars = ScrollBars.Vertical
            }
            y += 110

            ' Pricing section
            Dim pnlPricing As New Panel() With {
                .Left = 0,
                .Top = y,
                .Width = 480,
                .Height = 100,
                .BorderStyle = BorderStyle.FixedSingle,
                .BackColor = ColorLight
            }
            
            Dim lblPricingHeader As New Label() With {
                .Text = "💰 Pricing Information",
                .Left = 10,
                .Top = 5,
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .ForeColor = ColorDark
            }
            
            Dim lblLastPaid As New Label() With {.Text = "Last Paid Price:", .Left = 10, .Top = 35, .Width = 120, .Font = textFont, .ForeColor = ColorDark}
            txtLastPaidPrice = New TextBox() With {.Left = 135, .Top = 32, .Width = 100, .Text = "0.00", .Font = textFont, .BorderStyle = BorderStyle.FixedSingle}
            
            Dim lblAvgCost As New Label() With {.Text = "Average Cost:", .Left = 250, .Top = 35, .Width = 100, .Font = textFont, .ForeColor = ColorDark}
            txtAverageCost = New TextBox() With {.Left = 360, .Top = 32, .Width = 100, .Text = "0.00", .Font = textFont, .BorderStyle = BorderStyle.FixedSingle}
            
            Dim lblReorder As New Label() With {.Text = "Reorder Level:", .Left = 10, .Top = 65, .Width = 120, .Font = textFont, .ForeColor = ColorDark}
            txtReorderLevel = New TextBox() With {.Left = 135, .Top = 62, .Width = 100, .Text = "0", .Font = textFont, .BorderStyle = BorderStyle.FixedSingle}
            
            Dim lblReorderQty As New Label() With {.Text = "Reorder Qty:", .Left = 250, .Top = 65, .Width = 100, .Font = textFont, .ForeColor = ColorDark}
            txtReorderQuantity = New TextBox() With {.Left = 360, .Top = 62, .Width = 100, .Text = "0", .Font = textFont, .BorderStyle = BorderStyle.FixedSingle}
            
            pnlPricing.Controls.AddRange({lblPricingHeader, lblLastPaid, txtLastPaidPrice, lblAvgCost, txtAverageCost, lblReorder, txtReorderLevel, lblReorderQty, txtReorderQuantity})
            y += 120

            ' Active checkbox
            chkIsActive = New CheckBox() With {
                .Text = "✓ Product is Active",
                .Left = 0,
                .Top = y,
                .Checked = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .ForeColor = ColorDark
            }

            pnlLeft.Controls.AddRange({lblName, txtProductName, lblCode, txtProductCode, lblSKU, txtSKU, picBarcode, lblItemType, cmbItemType, lblCategory, categorySelector, lblDesc, txtDescription, pnlPricing, chkIsActive})

            ' Right side - Image upload
            Dim pnlRight As New Panel() With {.Left = 540, .Top = 0, .Width = 300, .Height = 650}
            
            Dim lblImageHeader As New Label() With {
                .Text = "📷 Product Image",
                .Left = 0,
                .Top = 10,
                .AutoSize = True,
                .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                .ForeColor = ColorDark
            }
            
            picProductImage = New PictureBox() With {
                .Left = 0,
                .Top = 45,
                .Width = 280,
                .Height = 280,
                .BorderStyle = BorderStyle.FixedSingle,
                .SizeMode = PictureBoxSizeMode.Zoom,
                .BackColor = ColorLight
            }
            
            ' Default image placeholder
            Dim bmp As New Bitmap(280, 280)
            Using g As Graphics = Graphics.FromImage(bmp)
                g.Clear(ColorLight)
                g.DrawString("No Image", New Font("Segoe UI", 14), New SolidBrush(ColorDark), New PointF(90, 130))
            End Using
            picProductImage.Image = bmp
            
            btnUploadImage = New Button() With {
                .Text = "📁 Upload Image",
                .Left = 0,
                .Top = 335,
                .Width = 280,
                .Height = 40,
                .BackColor = ColorPrimary,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnUploadImage.FlatAppearance.BorderSize = 0
            AddHandler btnUploadImage.Click, AddressOf BtnUploadImage_Click
            
            Dim lblImageNote As New Label() With {
                .Text = "Supported: JPG, PNG, BMP" & vbCrLf & "Max size: 2MB",
                .Left = 0,
                .Top = 385,
                .Width = 280,
                .Height = 40,
                .Font = New Font("Segoe UI", 8),
                .ForeColor = Color.Gray,
                .TextAlign = ContentAlignment.TopCenter
            }
            
            pnlRight.Controls.AddRange({lblImageHeader, picProductImage, btnUploadImage, lblImageNote})

            ' Bottom button panel
            Dim pnlButtons As New Panel() With {
                .Dock = DockStyle.Bottom,
                .Height = 70,
                .BackColor = Color.WhiteSmoke
            }
            
            btnSave = New Button() With {
                .Text = "💾 Save Product",
                .Left = 30,
                .Top = 15,
                .Width = 160,
                .Height = 40,
                .BackColor = ColorPrimary,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnSave.FlatAppearance.BorderSize = 0
            AddHandler btnSave.Click, AddressOf BtnSave_Click

            btnCancel = New Button() With {
                .Text = "✖ Cancel",
                .Left = 200,
                .Top = 15,
                .Width = 120,
                .Height = 40,
                .BackColor = ColorAccent,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnCancel.FlatAppearance.BorderSize = 0
            AddHandler btnCancel.Click, AddressOf BtnCancel_Click
            
            pnlButtons.Controls.AddRange({btnSave, btnCancel})

            pnlMain.Controls.AddRange({pnlLeft, pnlRight})
            Me.Controls.Add(pnlButtons)
            Me.Controls.Add(pnlMain)
            Me.Controls.Add(pnlHeader)
        End Sub
        
        Private Sub TxtProductCode_TextChanged(sender As Object, e As EventArgs) Handles txtProductCode.TextChanged
            ' Convert product code to barcode SKU format
            If Not String.IsNullOrWhiteSpace(txtProductCode.Text) Then
                ' Generate EAN-13 compatible barcode (13 digits)
                ' Format: Country(3) + Manufacturer(4) + Product(5) + Check(1)
                Dim code As String = txtProductCode.Text.Trim().ToUpper()
                
                ' Remove non-alphanumeric characters
                code = System.Text.RegularExpressions.Regex.Replace(code, "[^A-Z0-9]", "")
                
                ' Convert to numeric barcode (use ASCII values for letters)
                Dim barcodeNum As String = ""
                For Each c As Char In code
                    If Char.IsDigit(c) Then
                        barcodeNum &= c
                    Else
                        ' Convert letter to number (A=10, B=11, etc.)
                        barcodeNum &= (Asc(c) - 55).ToString()
                    End If
                Next
                
                ' Pad or truncate to 12 digits
                If barcodeNum.Length > 12 Then
                    barcodeNum = barcodeNum.Substring(0, 12)
                Else
                    barcodeNum = barcodeNum.PadRight(12, "0"c)
                End If
                
                ' Calculate EAN-13 check digit
                Dim sum As Integer = 0
                For i As Integer = 0 To 11
                    Dim digit As Integer = Integer.Parse(barcodeNum(i).ToString())
                    If i Mod 2 = 0 Then
                        sum += digit
                    Else
                        sum += digit * 3
                    End If
                Next
                Dim checkDigit As Integer = (10 - (sum Mod 10)) Mod 10
                
                ' Final barcode
                Dim finalBarcode As String = barcodeNum & checkDigit.ToString()
                txtSKU.Text = finalBarcode
                
                ' Generate barcode image
                GenerateBarcodeImage(finalBarcode)
            Else
                txtSKU.Text = ""
                picBarcode.Image = Nothing
            End If
        End Sub
        
        Private Sub GenerateBarcodeImage(barcodeText As String)
            ' Generate a simple Code 128 style barcode image
            Try
                Dim width As Integer = 230
                Dim height As Integer = 50
                Dim bmp As New Bitmap(width, height)
                
                Using g As Graphics = Graphics.FromImage(bmp)
                    g.Clear(Color.White)
                    
                    ' Draw bars based on barcode digits
                    Dim barWidth As Single = width / (barcodeText.Length * 2.5F)
                    Dim x As Single = 5
                    
                    For Each c As Char In barcodeText
                        Dim digit As Integer = Integer.Parse(c.ToString())
                        ' Alternate between thick and thin bars based on digit value
                        Dim isThick As Boolean = (digit Mod 2 = 0)
                        Dim currentBarWidth As Single = If(isThick, barWidth * 1.5F, barWidth)
                        
                        ' Draw black bar
                        g.FillRectangle(Brushes.Black, x, 5, currentBarWidth, height - 20)
                        x += currentBarWidth
                        
                        ' Draw white space
                        x += barWidth * 0.5F
                    Next
                    
                    ' Draw text below barcode
                    Dim textFont As New Font("Consolas", 8, FontStyle.Regular)
                    Dim textSize = g.MeasureString(barcodeText, textFont)
                    g.DrawString(barcodeText, textFont, Brushes.Black, (width - textSize.Width) / 2, height - 15)
                End Using
                
                ' Dispose old image
                If picBarcode.Image IsNot Nothing Then
                    picBarcode.Image.Dispose()
                End If
                picBarcode.Image = bmp
            Catch ex As Exception
                ' Silently fail if barcode generation fails
            End Try
        End Sub
        
        Private Sub BtnUploadImage_Click(sender As Object, e As EventArgs)
            Using ofd As New OpenFileDialog()
                ofd.Filter = "Image Files|*.jpg;*.jpeg;*.png;*.bmp"
                ofd.Title = "Select Product Image"
                
                If ofd.ShowDialog() = DialogResult.OK Then
                    Try
                        ' Load and resize image to prevent out of memory errors
                        Using originalImg As Image = Image.FromFile(ofd.FileName)
                            ' Resize to max 800x800 to save memory and database space
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
                            
                            ' Display in picture box
                            If picProductImage.Image IsNot Nothing Then
                                picProductImage.Image.Dispose()
                            End If
                            picProductImage.Image = resizedImg
                            
                            ' Convert to byte array (JPEG format to reduce size)
                            Using ms As New MemoryStream()
                                resizedImg.Save(ms, Imaging.ImageFormat.Jpeg)
                                _productImageBytes = ms.ToArray()
                            End Using
                        End Using
                    Catch ex As Exception
                        MessageBox.Show($"Error loading image: {ex.Message}", "Image Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    End Try
                End If
            End Using
        End Sub

        Private Sub BtnSave_Click(sender As Object, e As EventArgs)
            ' Validation
            If String.IsNullOrWhiteSpace(txtProductName.Text) Then
                MessageBox.Show("Please enter a product name.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtProductName.Focus()
                Return
            End If

            If String.IsNullOrWhiteSpace(txtProductCode.Text) Then
                MessageBox.Show("Please enter a product code.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtProductCode.Focus()
                Return
            End If
            
            ' Check for duplicate Product Code
            If IsProductCodeExists(txtProductCode.Text.Trim()) Then
                MessageBox.Show("This Product Code already exists. Please use a unique code.", "Duplicate Product Code", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtProductCode.Focus()
                Return
            End If
            
            ' Check for duplicate SKU/Barcode
            If Not String.IsNullOrWhiteSpace(txtSKU.Text) AndAlso IsSKUExists(txtSKU.Text.Trim()) Then
                MessageBox.Show("This SKU/Barcode already exists. Please use a different Product Code.", "Duplicate SKU", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtProductCode.Focus()
                Return
            End If

            If categorySelector Is Nothing OrElse categorySelector.SelectedCategoryId <= 0 Then
                MessageBox.Show("Please select a Category.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                SaveProduct()
                MessageBox.Show("Product added successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Me.DialogResult = DialogResult.OK
                Me.Close()
            Catch ex As Exception
                MessageBox.Show($"Error saving product: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Function IsProductCodeExists(productCode As String) As Boolean
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql As String = "SELECT COUNT(*) FROM Products WHERE ProductCode = @Code"
                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@Code", productCode)
                        Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                        Return count > 0
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error checking product code: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Function
        
        Private Function IsSKUExists(sku As String) As Boolean
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql As String = "SELECT COUNT(*) FROM Products WHERE SKU = @SKU"
                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@SKU", sku)
                        Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                        Return count > 0
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error checking SKU: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Function

        Private Sub SaveProduct()
            Using con As New SqlConnection(_connectionString)
                con.Open()
                Using tx = con.BeginTransaction()
                    Try
                        ' Get category ID (subcategory not used)
                        Dim categoryId As Integer = categorySelector.SelectedCategoryId
                        Dim subcategoryId As Integer = 0 ' Not using subcategory

                        ' Validate category exists
                        If categoryId <= 0 Then
                            Throw New Exception("Please select a valid Category.")
                        End If

                        ' Parse numeric values
                        Dim lastPaidPrice As Decimal = 0D
                        Decimal.TryParse(txtLastPaidPrice.Text, lastPaidPrice)

                        Dim avgCost As Decimal = 0D
                        Decimal.TryParse(txtAverageCost.Text, avgCost)

                        Dim reorderLevel As Integer = 0
                        Integer.TryParse(txtReorderLevel.Text, reorderLevel)

                        Dim reorderQty As Integer = 0
                        Integer.TryParse(txtReorderQuantity.Text, reorderQty)

                        ' Insert product with RecipeCreated = 'No' and ProductImage
                        ' Using only columns that exist in Products table
                        ' Make CategoryID and SubcategoryID nullable to avoid FK constraint issues
                        Dim sql As String = "INSERT INTO Products (ProductName, ProductCode, SKU, CategoryID, SubcategoryID, ItemType, IsActive, RecipeCreated, ProductImage, CreatedDate) " &
                                          "VALUES (@Name, @Code, @SKU, @CatID, @SubcatID, @ItemType, @IsActive, 'No', @Image, GETDATE())"

                        Using cmd As New SqlCommand(sql, con, tx)
                            cmd.Parameters.AddWithValue("@Name", txtProductName.Text.Trim())
                            cmd.Parameters.AddWithValue("@Code", txtProductCode.Text.Trim())
                            cmd.Parameters.AddWithValue("@SKU", If(String.IsNullOrWhiteSpace(txtSKU.Text), DBNull.Value, CType(txtSKU.Text.Trim(), Object)))
                            cmd.Parameters.AddWithValue("@ItemType", If(cmbItemType.SelectedItem IsNot Nothing, cmbItemType.SelectedItem.ToString(), "internal"))
                            cmd.Parameters.AddWithValue("@CatID", If(categoryId > 0, CType(categoryId, Object), DBNull.Value))
                            cmd.Parameters.AddWithValue("@SubcatID", DBNull.Value) ' Subcategory not used
                            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked)
                            
                            ' Properly handle binary image data
                            If _productImageBytes Is Nothing Then
                                cmd.Parameters.Add("@Image", SqlDbType.VarBinary).Value = DBNull.Value
                            Else
                                cmd.Parameters.Add("@Image", SqlDbType.VarBinary, -1).Value = _productImageBytes
                            End If
                            
                            cmd.ExecuteNonQuery()
                        End Using

                        tx.Commit()
                    Catch
                        tx.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Sub

        Private Sub BtnCancel_Click(sender As Object, e As EventArgs)
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Sub

    End Class

End Namespace
