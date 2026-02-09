Imports System.Data.SqlClient
Imports System.Configuration

Public Class BatchPriceUpdateForm
    Inherits Form
    
    Private connString As String
    Private currentBranchID As Integer
    Private branchName As String
    Private cmbCategory As ComboBox
    Private dgvProducts As DataGridView
    Private lblInfo As Label
    
    Public Sub New(branchID As Integer, branchName As String)
        Me.currentBranchID = branchID
        Me.branchName = branchName
        connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        
        SetupUI()
        LoadCategories()
    End Sub
    
    Private Sub SetupUI()
        Me.Text = "Price Management"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.FromArgb(240, 240, 240)
        
        ' ===================== HEADER PANEL =====================
        Dim headerPanel As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .BackColor = Color.FromArgb(41, 128, 185),
            .Padding = New Padding(20, 10, 20, 10)
        }
        
        Dim lblTitle As New Label With {
            .Text = "Price Management - Batch Update",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 15)
        }
        
        Dim lblBranch As New Label With {
            .Text = $"Branch: {branchName}",
            .Font = New Font("Segoe UI", 11),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 48)
        }
        
        headerPanel.Controls.AddRange({lblTitle, lblBranch})
        Me.Controls.Add(headerPanel)
        
        Dim filterPanel As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 70,
            .BackColor = Color.White,
            .Padding = New Padding(20, 15, 20, 15)
        }
        
        Dim lblCategory As New Label With {
            .Text = "Select Category:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .AutoSize = True,
            .Location = New Point(20, 20)
        }
        
        cmbCategory = New ComboBox With {
            .Name = "cmbCategory",
            .Font = New Font("Segoe UI", 10),
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Width = 300,
            .Location = New Point(150, 17)
        }
        AddHandler cmbCategory.SelectedIndexChanged, AddressOf CmbCategory_SelectedIndexChanged
        
        Dim btnRefresh As New Button With {
            .Name = "btnRefresh",
            .Text = "🔄 Refresh",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Size = New Size(120, 35),
            .Location = New Point(470, 15),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnRefresh.FlatAppearance.BorderSize = 0
        AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click
        
        filterPanel.Controls.AddRange({lblCategory, cmbCategory, btnRefresh})
        Me.Controls.Add(filterPanel)
        
        dgvProducts = New DataGridView With {
            .Name = "dgvProducts",
            .Dock = DockStyle.Fill,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.FixedSingle,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .RowHeadersVisible = False,
            .EnableHeadersVisualStyles = False,
            .Font = New Font("Segoe UI", 9),
            .ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing,
            .ColumnHeadersHeight = 45,
            .ColumnHeadersVisible = True
        }
        
        dgvProducts.ColumnHeadersDefaultCellStyle.BackColor = Color.Orange
        dgvProducts.ColumnHeadersDefaultCellStyle.ForeColor = Color.Black
        dgvProducts.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        dgvProducts.ColumnHeadersDefaultCellStyle.Padding = New Padding(8)
        dgvProducts.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
        dgvProducts.ColumnHeadersDefaultCellStyle.WrapMode = DataGridViewTriState.False
        dgvProducts.ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.Raised
        
        ' Set AutoGenerateColumns AFTER creating grid but BEFORE adding columns
        dgvProducts.AutoGenerateColumns = False
        dgvProducts.Columns.Clear()
        
        ' Manually define columns
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductID", .HeaderText = "ProductID", .DataPropertyName = "ProductID", .Visible = False})
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "SKU", .HeaderText = "SKU", .DataPropertyName = "SKU", .Width = 120, .ReadOnly = True})
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductName", .HeaderText = "Product Name", .DataPropertyName = "ProductName", .ReadOnly = True, .AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill})
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "SubCategoryName", .HeaderText = "Sub-Category", .DataPropertyName = "SubCategoryName", .Width = 150, .ReadOnly = True})
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "CurrentSellingPrice", .HeaderText = "Selling Price (R)", .DataPropertyName = "CurrentSellingPrice", .Width = 130, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "N2", .Alignment = DataGridViewContentAlignment.MiddleRight}})
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "CurrentCostPrice", .HeaderText = "Cost Price (R)", .DataPropertyName = "CurrentCostPrice", .Width = 130, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "N2", .Alignment = DataGridViewContentAlignment.MiddleRight}})
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "StockOnHand", .HeaderText = "Stock On Hand", .DataPropertyName = "StockOnHand", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "N2", .Alignment = DataGridViewContentAlignment.MiddleRight}})
        
        dgvProducts.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 245, 245)
        dgvProducts.DefaultCellStyle.SelectionBackColor = Color.FromArgb(41, 128, 185)
        dgvProducts.DefaultCellStyle.SelectionForeColor = Color.White
        dgvProducts.RowTemplate.Height = 35
        
        Dim buttonPanel As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 80,
            .BackColor = Color.FromArgb(240, 240, 240),
            .Padding = New Padding(20, 10, 20, 10)
        }
        
        lblInfo = New Label With {
            .Name = "lblInfo",
            .Text = "Select a category to view and update prices",
            .Font = New Font("Segoe UI", 9, FontStyle.Italic),
            .ForeColor = Color.FromArgb(127, 140, 141),
            .AutoSize = True,
            .Location = New Point(20, 25)
        }
        
        Dim btnClose As New Button With {
            .Name = "btnClose",
            .Text = "✖ Close",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Size = New Size(100, 45),
            .Location = New Point(1050, 15),
            .BackColor = Color.FromArgb(189, 195, 199),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, Sub(s, e) Me.Close()
        
        Dim btnSave As New Button With {
            .Name = "btnSave",
            .Text = "� Save Changes",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Size = New Size(150, 45),
            .Location = New Point(890, 15),
            .BackColor = Color.FromArgb(39, 174, 96),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnSave.FlatAppearance.BorderSize = 0
        AddHandler btnSave.Click, AddressOf BtnSave_Click
        
        Dim btnPrint As New Button With {
            .Name = "btnPrint",
            .Text = "� Print",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Size = New Size(100, 45),
            .Location = New Point(780, 15),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnPrint.FlatAppearance.BorderSize = 0
        AddHandler btnPrint.Click, AddressOf BtnPrint_Click
        
        Dim btnExport As New Button With {
            .Name = "btnExport",
            .Text = "📊 Export",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Size = New Size(120, 45),
            .Location = New Point(650, 15),
            .BackColor = Color.FromArgb(22, 160, 133),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnExport.FlatAppearance.BorderSize = 0
        AddHandler btnExport.Click, AddressOf BtnExport_Click
        
        Dim btnDelete As New Button With {
            .Name = "btnDelete",
            .Text = "🗑️ Delete",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Size = New Size(120, 45),
            .Location = New Point(520, 15),
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnDelete.FlatAppearance.BorderSize = 0
        AddHandler btnDelete.Click, AddressOf BtnDelete_Click
        
        buttonPanel.Controls.AddRange({lblInfo, btnDelete, btnExport, btnPrint, btnSave, btnClose})
        Me.Controls.Add(buttonPanel)
        
        ' ===================== DATAGRIDVIEW (ADD LAST!) =====================
        Me.Controls.Add(dgvProducts)
        dgvProducts.BringToFront()
    End Sub
    
    Private Sub LoadCategories()
        Try
            cmbCategory.Items.Clear()
            
            Using conn As New SqlConnection(connString)
                conn.Open()
                
                Dim sql = "
                    SELECT DISTINCT c.CategoryID, c.CategoryName
                    FROM Categories c
                    INNER JOIN Demo_Retail_Product p ON c.CategoryID = p.CategoryID
                    WHERE p.BranchID = @BranchID 
                      AND p.IsActive = 1
                      AND c.IsActive = 1
                      AND c.CategoryName IN (
                        'FRESH CREAM', 'BUTTERCREAM', 'EXOTIC CAKES', 'SHOP FRONT', 'PIES',
                        'FRESH CREAM BIRTHDAY CAKES', 'BUTTERCREAM BIRTHDAY CAKE', 'NOVELTY',
                        'BISCUITS', 'PLATTER', 'SAVOURY', 'DRINKS', 'BEVERAGES', 'SNACKS',
                        'SWEETS', 'WEDDING CAKES', 'FRUITCAKE', 'MISCELLANEOUS'
                      )
                    ORDER BY c.CategoryName"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                    
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            cmbCategory.Items.Add(New With {
                                .CategoryID = reader.GetInt32(0),
                                .CategoryName = reader.GetString(1),
                                .Display = reader.GetString(1)
                            })
                        End While
                    End Using
                End Using
            End Using
            
            cmbCategory.DisplayMember = "Display"
            
            If cmbCategory.Items.Count > 0 Then
                cmbCategory.SelectedIndex = 0
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error loading categories: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub CmbCategory_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadProducts()
    End Sub
    
    Private Sub LoadProducts()
        Try
            If cmbCategory Is Nothing Then
                MessageBox.Show("Category dropdown is null", "Debug", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If cmbCategory.SelectedItem Is Nothing Then
                If dgvProducts IsNot Nothing Then
                    dgvProducts.DataSource = Nothing
                End If
                If lblInfo IsNot Nothing Then
                    lblInfo.Text = "Select a category to view and update prices"
                End If
                Return
            End If
            
            Dim selectedCategory = cmbCategory.SelectedItem
            If selectedCategory Is Nothing Then
                MessageBox.Show("Selected category is null", "Debug", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim categoryID As Integer
            Dim categoryName As String
            
            Try
                categoryID = CInt(selectedCategory.CategoryID)
                categoryName = CStr(selectedCategory.CategoryName)
            Catch ex As Exception
                MessageBox.Show($"Error accessing category properties: {ex.Message}", "Debug", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End Try
            
            Using conn As New SqlConnection(connString)
                conn.Open()
                
                Dim sql = "
                    SELECT DISTINCT
                        p.ProductID,
                        p.SKU,
                        p.Name AS ProductName,
                        s.SubCategoryName,
                        ISNULL(pr.SellingPrice, 0) AS CurrentSellingPrice,
                        ISNULL(pr.CostPrice, 0) AS CurrentCostPrice,
                        ISNULL(st.QtyOnHand, 0) AS StockOnHand
                    FROM Demo_Retail_Product p
                    LEFT JOIN SubCategories s ON p.SubCategoryID = s.SubCategoryID
                    LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID 
                        AND pr.BranchID = @BranchID 
                        AND (pr.EffectiveTo IS NULL OR pr.EffectiveTo >= GETDATE())
                    LEFT JOIN (
                        SELECT v.ProductID, SUM(st.QtyOnHand) AS QtyOnHand
                        FROM Demo_Retail_Variant v
                        INNER JOIN Demo_Retail_Stock st ON v.VariantID = st.VariantID
                        WHERE st.BranchID = @BranchID
                        GROUP BY v.ProductID
                    ) st ON p.ProductID = st.ProductID
                    WHERE p.CategoryID = @CategoryID
                      AND p.BranchID = @BranchID
                      AND p.IsActive = 1
                    ORDER BY p.Name"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@CategoryID", categoryID)
                    cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                    
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                    
                    If dgvProducts Is Nothing Then
                        MessageBox.Show("DataGridView not initialized", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        Return
                    End If
                    
                    dgvProducts.DataSource = dt
                End Using
            End Using
            
            Dim rowCount = dgvProducts.Rows.Count
            If lblInfo IsNot Nothing Then
                lblInfo.Text = $"Category: {categoryName} | {rowCount} product(s) | Edit prices and click Save All Changes"
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error loading products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
        LoadProducts()
        MessageBox.Show("Data refreshed successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub
    
    Private Sub BtnSave_Click(sender As Object, e As EventArgs)
        Try
            If dgvProducts.Rows.Count = 0 Then
                MessageBox.Show("No products to save!", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            Dim result = MessageBox.Show(
                $"Are you sure you want to update prices for {dgvProducts.Rows.Count} product(s)?",
                "Confirm Price Update",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question)
            
            If result <> DialogResult.Yes Then Return
            
            Dim updated As Integer = 0
            
            Using conn As New SqlConnection(connString)
                conn.Open()
                
                For Each row As DataGridViewRow In dgvProducts.Rows
                    If Not row.IsNewRow Then
                        Dim productID = CInt(row.Cells("ProductID").Value)
                        Dim sellingPrice = CDec(row.Cells("CurrentSellingPrice").Value)
                        Dim costPrice = CDec(row.Cells("CurrentCostPrice").Value)
                        
                        UpdateProductPrice(conn, productID, sellingPrice, costPrice)
                        updated += 1
                    End If
                Next
            End Using
            
            MessageBox.Show($"Successfully updated prices for {updated} product(s)!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            LoadProducts()
            
        Catch ex As Exception
            MessageBox.Show($"Error saving prices: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub UpdateProductPrice(conn As SqlConnection, productID As Integer, sellingPrice As Decimal, costPrice As Decimal)
        Dim sql = "
            IF EXISTS (SELECT 1 FROM Demo_Retail_Price WHERE ProductID = @ProductID AND BranchID = @BranchID AND EffectiveTo IS NULL)
            BEGIN
                UPDATE Demo_Retail_Price 
                SET SellingPrice = @SellingPrice,
                    CostPrice = @CostPrice
                WHERE ProductID = @ProductID 
                  AND BranchID = @BranchID 
                  AND EffectiveTo IS NULL
            END
            ELSE
            BEGIN
                INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom, EffectiveTo)
                VALUES (@ProductID, @BranchID, @SellingPrice, @CostPrice, GETDATE(), NULL)
            END
            
            UPDATE Demo_Retail_Product
            SET LastPaidPrice = @CostPrice,
                AverageCost = @CostPrice
            WHERE ProductID = @ProductID AND BranchID = @BranchID"
        
        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@ProductID", productID)
            cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
            cmd.Parameters.AddWithValue("@SellingPrice", sellingPrice)
            cmd.Parameters.AddWithValue("@CostPrice", costPrice)
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
    Private Sub BtnExport_Click(sender As Object, e As EventArgs)
        Try
            If dgvProducts.Rows.Count = 0 Then
                MessageBox.Show("No data to export!", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            Dim sfd As New SaveFileDialog With {
                .Filter = "Excel Files|*.xlsx",
                .Title = "Export Price List",
                .FileName = $"PriceList_{branchName}_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
            }
            
            If sfd.ShowDialog() = DialogResult.OK Then
                Using workbook As New ClosedXML.Excel.XLWorkbook()
                    Dim worksheet = workbook.Worksheets.Add("Price List")
                    
                    worksheet.Cell(1, 1).Value = "Price Management Report"
                    worksheet.Cell(1, 1).Style.Font.Bold = True
                    worksheet.Cell(1, 1).Style.Font.FontSize = 16
                    
                    worksheet.Cell(2, 1).Value = $"Branch: {branchName}"
                    worksheet.Cell(3, 1).Value = $"Category: {If(cmbCategory.SelectedItem IsNot Nothing, cmbCategory.SelectedItem.CategoryName, "All")}"
                    worksheet.Cell(4, 1).Value = $"Generated: {DateTime.Now:yyyy-MM-dd HH:mm:ss}"
                    
                    Dim headerRow = 6
                    For col = 0 To dgvProducts.Columns.Count - 1
                        If dgvProducts.Columns(col).Visible Then
                            worksheet.Cell(headerRow, col + 1).Value = dgvProducts.Columns(col).HeaderText
                            worksheet.Cell(headerRow, col + 1).Style.Font.Bold = True
                            worksheet.Cell(headerRow, col + 1).Style.Fill.BackgroundColor = ClosedXML.Excel.XLColor.FromArgb(52, 73, 94)
                            worksheet.Cell(headerRow, col + 1).Style.Font.FontColor = ClosedXML.Excel.XLColor.White
                        End If
                    Next
                    
                    Dim currentRow = headerRow + 1
                    For Each row As DataGridViewRow In dgvProducts.Rows
                        If Not row.IsNewRow Then
                            Dim currentCol = 1
                            For col = 0 To dgvProducts.Columns.Count - 1
                                If dgvProducts.Columns(col).Visible Then
                                    Dim value = If(row.Cells(col).Value, "")
                                    worksheet.Cell(currentRow, currentCol).Value = value.ToString()
                                    currentCol += 1
                                End If
                            Next
                            currentRow += 1
                        End If
                    Next
                    
                    worksheet.Columns().AdjustToContents()
                    workbook.SaveAs(sfd.FileName)
                End Using
                
                MessageBox.Show("Price list exported successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error exporting to Excel: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub BtnPrint_Click(sender As Object, e As EventArgs)
        Try
            If dgvProducts.Rows.Count = 0 Then
                MessageBox.Show("No data to print!", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            Dim printDialog As New PrintDialog()
            Dim printDocument As New Printing.PrintDocument()
            
            AddHandler printDocument.PrintPage, AddressOf PrintDocument_PrintPage
            
            printDialog.Document = printDocument
            
            If printDialog.ShowDialog() = DialogResult.OK Then
                printDocument.Print()
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub PrintDocument_PrintPage(sender As Object, e As Printing.PrintPageEventArgs)
        Dim font As New Font("Segoe UI", 10)
        Dim headerFont As New Font("Segoe UI", 12, FontStyle.Bold)
        Dim brush As New SolidBrush(Color.Black)
        
        Dim yPos As Single = e.MarginBounds.Top
        
        e.Graphics.DrawString("Price Management Report", headerFont, brush, e.MarginBounds.Left, yPos)
        yPos += 30
        
        e.Graphics.DrawString($"Branch: {branchName}", font, brush, e.MarginBounds.Left, yPos)
        yPos += 20
        
        e.Graphics.DrawString($"Category: {If(cmbCategory.SelectedItem IsNot Nothing, cmbCategory.SelectedItem.CategoryName, "All")}", font, brush, e.MarginBounds.Left, yPos)
        yPos += 20
        
        e.Graphics.DrawString($"Date: {DateTime.Now:yyyy-MM-dd HH:mm:ss}", font, brush, e.MarginBounds.Left, yPos)
        yPos += 40
        
        Dim xPos As Single = e.MarginBounds.Left
        For Each col As DataGridViewColumn In dgvProducts.Columns
            If col.Visible Then
                e.Graphics.DrawString(col.HeaderText, New Font("Segoe UI", 9, FontStyle.Bold), brush, xPos, yPos)
                xPos += 100
            End If
        Next
        
        yPos += 25
        
        For Each row As DataGridViewRow In dgvProducts.Rows
            If Not row.IsNewRow AndAlso yPos < e.MarginBounds.Bottom - 50 Then
                xPos = e.MarginBounds.Left
                For Each col As DataGridViewColumn In dgvProducts.Columns
                    If col.Visible Then
                        Dim value = If(row.Cells(col.Index).Value, "")
                        e.Graphics.DrawString(value.ToString(), font, brush, xPos, yPos)
                        xPos += 100
                    End If
                Next
                yPos += 20
            End If
        Next
        
        e.HasMorePages = False
    End Sub
    
    Private Sub BtnDelete_Click(sender As Object, e As EventArgs)
        Try
            ' Check if any rows are selected
            If dgvProducts.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select at least one product to delete.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Confirm deletion
            Dim selectedCount = dgvProducts.SelectedRows.Count
            Dim result = MessageBox.Show(
                $"Are you sure you want to delete {selectedCount} product(s)?" & Environment.NewLine & Environment.NewLine &
                "This will hide the selected products from POS and Price Management." & Environment.NewLine &
                "The product data will be preserved in the database.",
                "Confirm Delete",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question,
                MessageBoxDefaultButton.Button2)
            
            If result = DialogResult.No Then
                Return
            End If
            
            Dim deletedCount As Integer = 0
            Using conn As New SqlConnection(connString)
                conn.Open()
                
                For Each row As DataGridViewRow In dgvProducts.SelectedRows
                    If Not row.IsNewRow Then
                        ' Get SKU from the row
                        Dim sku As String = If(row.Cells("SKU")?.Value?.ToString(), "")
                        
                        If Not String.IsNullOrEmpty(sku) Then
                            ' Soft delete: Set IsActive = 0 for this product in this branch
                            Dim sql = "UPDATE Demo_Retail_Product SET IsActive = 0 WHERE SKU = @sku AND BranchID = @bid"
                            Using cmd As New SqlCommand(sql, conn)
                                cmd.Parameters.AddWithValue("@sku", sku)
                                cmd.Parameters.AddWithValue("@bid", currentBranchID)
                                Dim rowsAffected = cmd.ExecuteNonQuery()
                                If rowsAffected > 0 Then
                                    deletedCount += 1
                                End If
                            End Using
                        End If
                    End If
                Next
            End Using
            
            If deletedCount > 0 Then
                MessageBox.Show($"Successfully deleted {deletedCount} product(s)." & Environment.NewLine &
                              "They will no longer appear in POS or Price Management.",
                              "Success",
                              MessageBoxButtons.OK,
                              MessageBoxIcon.Information)
                
                ' Refresh the grid to remove deleted items
                LoadProducts()
            Else
                MessageBox.Show("No products were deleted.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error deleting products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
