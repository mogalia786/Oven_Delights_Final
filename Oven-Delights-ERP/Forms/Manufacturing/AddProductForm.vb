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
        Private txtProductCode As TextBox
        Private txtDescription As TextBox
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
            Me.Height = 700
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
                .Text = "Create a new manufactured product for recipe building",
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
            Dim pnlLeft As New Panel() With {.Left = 0, .Top = 0, .Width = 520, .Height = 550}
            
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

            ' Category/Subcategory
            Dim lblCategory As New Label() With {
                .Text = "Category & Subcategory *",
                .Left = 0,
                .Top = y,
                .Width = 250,
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

            pnlLeft.Controls.AddRange({lblName, txtProductName, lblCode, txtProductCode, lblCategory, categorySelector, lblDesc, txtDescription, pnlPricing, chkIsActive})

            ' Right side - Image upload
            Dim pnlRight As New Panel() With {.Left = 540, .Top = 0, .Width = 300, .Height = 550}
            
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
        
        Private Sub BtnUploadImage_Click(sender As Object, e As EventArgs)
            Using ofd As New OpenFileDialog()
                ofd.Filter = "Image Files|*.jpg;*.jpeg;*.png;*.bmp"
                ofd.Title = "Select Product Image"
                
                If ofd.ShowDialog() = DialogResult.OK Then
                    Try
                        ' Check file size (max 2MB)
                        Dim fileInfo As New FileInfo(ofd.FileName)
                        If fileInfo.Length > 2 * 1024 * 1024 Then
                            MessageBox.Show("Image size must be less than 2MB.", "File Too Large", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                            Return
                        End If
                        
                        ' Load image
                        Dim img As Image = Image.FromFile(ofd.FileName)
                        picProductImage.Image = img
                        
                        ' Convert to byte array
                        Using ms As New MemoryStream()
                            img.Save(ms, img.RawFormat)
                            _productImageBytes = ms.ToArray()
                        End Using
                        
                    Catch ex As Exception
                        MessageBox.Show($"Error loading image: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
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

            If categorySelector Is Nothing OrElse Not categorySelector.IsValidSelection Then
                MessageBox.Show("Please select a Category and Subcategory.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
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

        Private Sub SaveProduct()
            Using con As New SqlConnection(_connectionString)
                con.Open()
                Using tx = con.BeginTransaction()
                    Try
                        ' Get category and subcategory IDs
                        Dim categoryId As Integer = categorySelector.SelectedCategoryId
                        Dim subcategoryId As Integer = categorySelector.SelectedSubcategoryId

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
                        Dim sql As String = "INSERT INTO Products (ProductName, ProductCode, Description, CategoryID, SubcategoryID, ItemType, LastPaidPrice, AverageCost, ReorderLevel, ReorderQuantity, IsActive, RecipeCreated, ProductImage, CreatedDate, CreatedBy) " &
                                          "VALUES (@Name, @Code, @Desc, @CatID, @SubcatID, 'Manufactured', @LastPaid, @AvgCost, @Reorder, @ReorderQty, @IsActive, 'No', @Image, GETDATE(), @CreatedBy)"

                        Using cmd As New SqlCommand(sql, con, tx)
                            cmd.Parameters.AddWithValue("@Name", txtProductName.Text.Trim())
                            cmd.Parameters.AddWithValue("@Code", txtProductCode.Text.Trim())
                            cmd.Parameters.AddWithValue("@Desc", If(String.IsNullOrWhiteSpace(txtDescription.Text), DBNull.Value, txtDescription.Text.Trim()))
                            cmd.Parameters.AddWithValue("@CatID", categoryId)
                            cmd.Parameters.AddWithValue("@SubcatID", subcategoryId)
                            cmd.Parameters.AddWithValue("@LastPaid", lastPaidPrice)
                            cmd.Parameters.AddWithValue("@AvgCost", avgCost)
                            cmd.Parameters.AddWithValue("@Reorder", reorderLevel)
                            cmd.Parameters.AddWithValue("@ReorderQty", reorderQty)
                            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked)
                            cmd.Parameters.AddWithValue("@Image", If(_productImageBytes Is Nothing, DBNull.Value, CType(_productImageBytes, Object)))
                            cmd.Parameters.AddWithValue("@CreatedBy", AppSession.CurrentUserID)
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
