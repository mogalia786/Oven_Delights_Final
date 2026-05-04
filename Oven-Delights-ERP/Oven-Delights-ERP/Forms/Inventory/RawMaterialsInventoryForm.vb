Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing.Printing

Public Class RawMaterialsInventoryForm
    Private ReadOnly _connectionString As String
    Private ReadOnly _currentBranchID As Integer
    Private WithEvents btnPrint As Button
    Private _currentPrintRow As Integer = 0

    Public Sub New()
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        _currentBranchID = AppSession.CurrentUser.BranchID
    End Sub

    Private Sub RawMaterialsInventoryForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        SetupForm()
        LoadCategories()
        LoadRawMaterials()
    End Sub

    Private Sub SetupForm()
        Me.Text = "Raw Materials Inventory"
        Me.WindowState = FormWindowState.Maximized
        Me.BackColor = Color.FromArgb(240, 244, 248)

        Dim headerPanel As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = Color.FromArgb(41, 128, 185),
            .Padding = New Padding(20, 15, 20, 15)
        }

        Dim titleLabel As New Label With {
            .Text = "Raw Materials Inventory",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 20)
        }

        Dim subtitleLabel As New Label With {
            .Text = "View and manage raw materials, ingredients, packaging, and consumables",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = Color.FromArgb(236, 240, 241),
            .AutoSize = True,
            .Location = New Point(20, 50)
        }

        headerPanel.Controls.AddRange({titleLabel, subtitleLabel})

        Dim filterPanel As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = Color.White,
            .Padding = New Padding(20, 15, 20, 15)
        }

        Dim lblCategory As New Label With {
            .Text = "Category:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .AutoSize = True,
            .Location = New Point(20, 25)
        }

        cboCategory = New ComboBox With {
            .Font = New Font("Segoe UI", 10),
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Width = 200,
            .Location = New Point(100, 22)
        }

        Dim lblSearch As New Label With {
            .Text = "Search:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .AutoSize = True,
            .Location = New Point(320, 25)
        }

        txtSearch = New TextBox With {
            .Font = New Font("Segoe UI", 10),
            .Width = 300,
            .Location = New Point(390, 22)
        }

        btnRefresh = New Button With {
            .Text = "Refresh",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Width = 100,
            .Height = 35,
            .Location = New Point(710, 18),
            .Cursor = Cursors.Hand
        }
        btnRefresh.FlatAppearance.BorderSize = 0

        btnPrint = New Button With {
            .Text = "Print",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .BackColor = Color.FromArgb(46, 204, 113),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Width = 100,
            .Height = 35,
            .Location = New Point(830, 18),
            .Cursor = Cursors.Hand
        }
        btnPrint.FlatAppearance.BorderSize = 0

        filterPanel.Controls.AddRange({lblCategory, cboCategory, lblSearch, txtSearch, btnRefresh, btnPrint})

        dgvRawMaterials = New DataGridView With {
            .Dock = DockStyle.Fill,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None,
            .RowHeadersVisible = False,
            .EnableHeadersVisualStyles = False,
            .Font = New Font("Segoe UI", 11),
            .RowTemplate = New DataGridViewRow With {.Height = 55},
            .CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal,
            .GridColor = Color.FromArgb(200, 200, 200)
        }

        dgvRawMaterials.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(52, 73, 94)
        dgvRawMaterials.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvRawMaterials.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        dgvRawMaterials.ColumnHeadersDefaultCellStyle.Padding = New Padding(10)
        dgvRawMaterials.ColumnHeadersHeight = 50

        dgvRawMaterials.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(236, 240, 241)
        dgvRawMaterials.DefaultCellStyle.SelectionBackColor = Color.FromArgb(52, 152, 219)
        dgvRawMaterials.DefaultCellStyle.SelectionForeColor = Color.White
        dgvRawMaterials.DefaultCellStyle.Padding = New Padding(10, 8, 10, 8)

        dgvRawMaterials.Columns.Add("ProductID", "Product ID")
        dgvRawMaterials.Columns.Add("Name", "Item Name")
        dgvRawMaterials.Columns.Add("Category", "Category")
        dgvRawMaterials.Columns.Add("CostPrice", "Cost Price (Universal)")
        dgvRawMaterials.Columns.Add("StockOnHand", "Stock On Hand")
        dgvRawMaterials.Columns.Add("LastPurchaseDate", "Last Purchase Date")
        dgvRawMaterials.Columns.Add("Supplier", "Supplier")

        dgvRawMaterials.Columns("ProductID").Visible = False
        dgvRawMaterials.Columns("Name").Width = 450
        dgvRawMaterials.Columns("Category").Width = 200
        dgvRawMaterials.Columns("CostPrice").Width = 220
        dgvRawMaterials.Columns("CostPrice").DefaultCellStyle.Format = "N4"
        dgvRawMaterials.Columns("CostPrice").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        dgvRawMaterials.Columns("StockOnHand").Width = 200
        dgvRawMaterials.Columns("StockOnHand").DefaultCellStyle.Format = "N4"
        dgvRawMaterials.Columns("StockOnHand").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
        dgvRawMaterials.Columns("LastPurchaseDate").Width = 220
        dgvRawMaterials.Columns("LastPurchaseDate").DefaultCellStyle.Format = "yyyy-MM-dd"
        dgvRawMaterials.Columns("Supplier").Width = 350

        Dim mainPanel As New Panel With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(20)
        }
        mainPanel.Controls.Add(dgvRawMaterials)

        Me.Controls.Add(mainPanel)
        Me.Controls.Add(filterPanel)
        Me.Controls.Add(headerPanel)

        AddHandler cboCategory.SelectedIndexChanged, AddressOf cboCategory_SelectedIndexChanged
        AddHandler txtSearch.TextChanged, AddressOf txtSearch_TextChanged
        AddHandler btnRefresh.Click, AddressOf btnRefresh_Click
    End Sub

    Private cboCategory As ComboBox
    Private txtSearch As TextBox
    Private btnRefresh As Button
    Private dgvRawMaterials As DataGridView

    Private Sub LoadCategories()
        cboCategory.Items.Clear()
        cboCategory.Items.Add("Ingredients")
        cboCategory.Items.Add("Packaging")
        cboCategory.Items.Add("Consumables")
        cboCategory.Items.Add("Miscellaneous")
        cboCategory.SelectedIndex = 0
    End Sub

    Private Sub LoadRawMaterials()
        dgvRawMaterials.Rows.Clear()

        Dim selectedCategory As String = If(cboCategory.SelectedItem IsNot Nothing, cboCategory.SelectedItem.ToString(), "Ingredients")
        Dim searchText As String = txtSearch.Text.Trim()

        Dim categoryFilter As String = ""
        Select Case selectedCategory
            Case "Ingredients"
                categoryFilter = "p.Category LIKE '%ingredient%'"
            Case "Packaging"
                categoryFilter = "p.Category LIKE '%pack%'"
            Case "Consumables"
                categoryFilter = "p.Category LIKE '%consumable%'"
            Case "Miscellaneous"
                categoryFilter = "p.Category LIKE '%misce%'"
        End Select

        Using conn As New SqlConnection(_connectionString)
            ' Use master branch (BranchID = 6) for products to eliminate duplicates
            ' Cost price is universal, stored in Demo_Retail_Price per branch but same across all branches
            Dim query As String = $"
                SELECT 
                    p.ProductID,
                    p.Name,
                    p.Category,
                    ISNULL(rp.CostPrice, 0) AS CostPrice,
                    ISNULL(p.CurrentStock, 0) AS StockOnHand,
                    lastInv.InvoiceDate AS LastInvoiceDate,
                    s.CompanyName AS SupplierName
                FROM Demo_Retail_Product p
                LEFT JOIN Demo_Retail_Price rp ON rp.ProductID = p.ProductID AND rp.BranchID = 6
                OUTER APPLY (
                    SELECT TOP 1 
                        si.InvoiceDate,
                        si.SupplierID
                    FROM SupplierInvoiceLines sil
                    INNER JOIN SupplierInvoices si ON si.InvoiceID = sil.InvoiceID
                    WHERE sil.ItemID = p.ProductID 
                      AND sil.ItemSource = 'PR'
                    ORDER BY si.InvoiceDate DESC
                ) lastInv
                LEFT JOIN Suppliers s ON s.SupplierID = lastInv.SupplierID
                WHERE p.IsActive = 1
                  AND p.BranchID = 6
                  AND p.ProductType = 'External'
                  AND {categoryFilter}
                  AND (p.Name LIKE @Search OR p.Category LIKE @Search OR ISNULL(p.Code, p.SKU) LIKE @Search)
                ORDER BY p.Name"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Search", $"%{searchText}%")
                conn.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        dgvRawMaterials.Rows.Add(
                            reader("ProductID"),
                            reader("Name"),
                            reader("Category"),
                            reader("CostPrice"),
                            reader("StockOnHand"),
                            If(IsDBNull(reader("LastInvoiceDate")), DBNull.Value, reader("LastInvoiceDate")),
                            If(IsDBNull(reader("SupplierName")), "N/A", reader("SupplierName"))
                        )
                    End While
                End Using
            End Using
        End Using

        Dim statusLabel As New Label With {
            .Text = $"Showing {dgvRawMaterials.Rows.Count} items in {selectedCategory}",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = Color.FromArgb(127, 140, 141),
            .AutoSize = True,
            .Location = New Point(20, Me.Height - 50)
        }

        For Each ctrl In Me.Controls.OfType(Of Label)().Where(Function(l) l.Text.StartsWith("Showing")).ToList()
            Me.Controls.Remove(ctrl)
        Next
        Me.Controls.Add(statusLabel)
        statusLabel.BringToFront()
    End Sub

    Private Sub cboCategory_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadRawMaterials()
    End Sub

    Private Sub txtSearch_TextChanged(sender As Object, e As EventArgs)
        LoadRawMaterials()
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs)
        LoadRawMaterials()
        MessageBox.Show("Data refreshed successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click
        Try
            _currentPrintRow = 0
            Dim selectedCategory As String = If(cboCategory.SelectedItem?.ToString(), "All Categories")
            Dim printDialog As New PrintDialog()
            Dim printDoc As New PrintDocument()
            
            AddHandler printDoc.PrintPage, AddressOf PrintDocument_PrintPage
            
            printDialog.Document = printDoc
            
            If printDialog.ShowDialog() = DialogResult.OK Then
                printDoc.DocumentName = $"Raw Materials Inventory - {selectedCategory}"
                printDoc.Print()
            End If
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub PrintDocument_PrintPage(sender As Object, e As PrintPageEventArgs)
        Try
            Dim selectedCategory As String = If(cboCategory.SelectedItem?.ToString(), "All Categories")
            Dim searchText As String = txtSearch.Text.Trim()
            
            Using font As New Font("Segoe UI", 10)
                Using boldFont As New Font("Segoe UI", 12, FontStyle.Bold)
                    Using headerFont As New Font("Segoe UI", 16, FontStyle.Bold)
                        Dim yPos As Integer = 50
                        Dim leftMargin As Integer = 50
                        
                        ' Print title
                        e.Graphics.DrawString("Raw Materials Inventory Report", headerFont, Brushes.Black, leftMargin, yPos)
                        yPos += 40
                        
                        ' Print category and date
                        e.Graphics.DrawString($"Category: {selectedCategory}", boldFont, Brushes.Black, leftMargin, yPos)
                        yPos += 25
                        e.Graphics.DrawString($"Date: {DateTime.Now:yyyy-MM-dd HH:mm}", font, Brushes.Black, leftMargin, yPos)
                        yPos += 25
                        
                        If Not String.IsNullOrEmpty(searchText) Then
                            e.Graphics.DrawString($"Search Filter: {searchText}", font, Brushes.Black, leftMargin, yPos)
                            yPos += 25
                        End If
                        
                        yPos += 20
                        
                        ' Print column headers
                        Dim colX As Integer = leftMargin
                        e.Graphics.DrawString("Item Name", boldFont, Brushes.Black, colX, yPos)
                        colX += 200
                        e.Graphics.DrawString("Category", boldFont, Brushes.Black, colX, yPos)
                        colX += 100
                        e.Graphics.DrawString("Cost Price", boldFont, Brushes.Black, colX, yPos)
                        colX += 100
                        e.Graphics.DrawString("Stock", boldFont, Brushes.Black, colX, yPos)
                        colX += 80
                        e.Graphics.DrawString("Last Purchase", boldFont, Brushes.Black, colX, yPos)
                        colX += 120
                        e.Graphics.DrawString("Supplier", boldFont, Brushes.Black, colX, yPos)
                        
                        yPos += 25
                        e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, 750, yPos)
                        yPos += 10
                        
                        ' Print data rows
                        While _currentPrintRow < dgvRawMaterials.Rows.Count
                            Dim row As DataGridViewRow = dgvRawMaterials.Rows(_currentPrintRow)
                            If row.IsNewRow Then
                                _currentPrintRow += 1
                                Continue While
                            End If
                            
                            If yPos > e.PageBounds.Height - 100 Then
                                e.HasMorePages = True
                                Exit While
                            End If
                            
                            colX = leftMargin
                            
                            ' Item Name
                            Dim itemName As String = If(row.Cells("Name").Value?.ToString(), "")
                            e.Graphics.DrawString(itemName, font, Brushes.Black, colX, yPos)
                            colX += 200
                            
                            ' Category
                            Dim category As String = If(row.Cells("Category").Value?.ToString(), "")
                            e.Graphics.DrawString(category, font, Brushes.Black, colX, yPos)
                            colX += 100
                            
                            ' Cost Price
                            Dim costPrice As String = "0.0000"
                            If row.Cells("CostPrice").Value IsNot Nothing AndAlso Not IsDBNull(row.Cells("CostPrice").Value) Then
                                costPrice = Convert.ToDecimal(row.Cells("CostPrice").Value).ToString("N4")
                            End If
                            e.Graphics.DrawString(costPrice, font, Brushes.Black, colX, yPos)
                            colX += 100
                            
                            ' Stock On Hand
                            Dim stock As String = "0.0000"
                            If row.Cells("StockOnHand").Value IsNot Nothing AndAlso Not IsDBNull(row.Cells("StockOnHand").Value) Then
                                stock = Convert.ToDecimal(row.Cells("StockOnHand").Value).ToString("N4")
                            End If
                            e.Graphics.DrawString(stock, font, Brushes.Black, colX, yPos)
                            colX += 80
                            
                            ' Last Purchase Date
                            Dim lastPurchase = row.Cells("LastPurchaseDate").Value
                            Dim purchaseDate As String = If(lastPurchase IsNot Nothing AndAlso Not IsDBNull(lastPurchase), 
                                                            Convert.ToDateTime(lastPurchase).ToString("yyyy-MM-dd"), "N/A")
                            e.Graphics.DrawString(purchaseDate, font, Brushes.Black, colX, yPos)
                            colX += 120
                            
                            ' Supplier
                            Dim supplier As String = If(row.Cells("Supplier").Value?.ToString(), "N/A")
                            e.Graphics.DrawString(supplier, font, Brushes.Black, colX, yPos)
                            
                            yPos += 20
                            _currentPrintRow += 1
                        End While
                        
                        ' Print footer
                        yPos = e.PageBounds.Height - 50
                        e.Graphics.DrawString($"Total Items: {dgvRawMaterials.Rows.Count}", font, Brushes.Gray, leftMargin, yPos)
                        
                        If Not e.HasMorePages Then
                            e.HasMorePages = False
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error during print: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            e.HasMorePages = False
        End Try
    End Sub
End Class
