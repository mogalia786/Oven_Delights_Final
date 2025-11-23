Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Drawing.Printing

Namespace Manufacturing

    Public Class BuildProductBOMForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        ' Modern color scheme
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(41, 128, 185)      ' Blue
        Private ReadOnly ColorSuccess As Color = Color.FromArgb(39, 174, 96)       ' Green
        Private ReadOnly ColorWarning As Color = Color.FromArgb(243, 156, 18)      ' Orange
        Private ReadOnly ColorDanger As Color = Color.FromArgb(231, 76, 60)        ' Red
        Private ReadOnly ColorDark As Color = Color.FromArgb(52, 73, 94)           ' Dark Blue
        Private ReadOnly ColorLight As Color = Color.FromArgb(236, 240, 241)       ' Light Gray
        Private ReadOnly ColorWhite As Color = Color.White

        ' Panel 1: Product Selection
        Private txtProductSearch As TextBox
        Private lstProductResults As ListBox
        Private lblProductCode As Label
        Private txtBatchSize As NumericUpDown
        Private _selectedProductId As Integer = 0

        ' Panel 2: Sub-Recipe Selection
        Private txtSubRecipeSearch As TextBox
        Private lstSubRecipes As ListBox
        Private btnAddSubRecipe As Button

        ' Panel 3: BOM Grid
        Private dgvBOM As DataGridView
        Private bomTable As DataTable

        ' Panel 4: Other Items
        Private txtOtherItemSearch As TextBox
        Private lstOtherItems As ListBox
        Private btnAddOtherItem As Button

        ' Bottom: Cost Summary
        Private lblSubtotal As Label
        Private lblVAT As Label
        Private lblTotal As Label

        ' Action Buttons
        Private btnSaveMethod As Button
        Private btnPrintRecipe As Button
        Private btnSave As Button
        Private btnCancel As Button

        ' Method text
        Private txtMethod As TextBox

        Public Sub New()
            Me.Text = "Build My Product - BOM Creator"
            Me.Width = 1400
            Me.Height = 900
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = ColorLight
            InitializeUI()
            LoadSubRecipes("")
            LoadOtherItems("")
            AddHandler Me.Load, AddressOf OnFormLoad
        End Sub

        Private Sub InitializeUI()
            ' Main container
            Dim mainPanel As New TableLayoutPanel With {
                .Dock = DockStyle.Fill,
                .ColumnCount = 2,
                .RowCount = 3,
                .Padding = New Padding(20),
                .BackColor = ColorLight
            }

            mainPanel.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 50))
            mainPanel.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 50))
            mainPanel.RowStyles.Add(New RowStyle(SizeType.Absolute, 180))  ' Panel 1 & 2
            mainPanel.RowStyles.Add(New RowStyle(SizeType.Percent, 100))   ' Panel 3 & 4
            mainPanel.RowStyles.Add(New RowStyle(SizeType.Absolute, 120))  ' Bottom

            ' PANEL 1: Product Selection
            mainPanel.Controls.Add(CreatePanel1(), 0, 0)

            ' PANEL 2: Sub-Recipes
            mainPanel.Controls.Add(CreatePanel2(), 1, 0)

            ' PANEL 3: BOM Grid (spans 2 columns)
            Dim bomPanel = CreatePanel3()
            mainPanel.SetColumnSpan(bomPanel, 2)
            mainPanel.Controls.Add(bomPanel, 0, 1)

            ' Initialize BOM table AFTER dgvBOM is created
            InitializeBOMTable()

            ' BOTTOM: Cost Summary & Actions
            Dim bottomPanel = CreateBottomPanel()
            mainPanel.SetColumnSpan(bottomPanel, 2)
            mainPanel.Controls.Add(bottomPanel, 0, 2)

            Me.Controls.Add(mainPanel)
        End Sub

        Private Function CreatePanel1() As Panel
            Dim panel As New Panel With {
                .Dock = DockStyle.Fill,
                .BackColor = ColorWhite,
                .Padding = New Padding(15)
            }

            ' Title
            Dim title As New Label With {
                .Text = "1. SELECT PRODUCT",
                .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                .ForeColor = ColorPrimary,
                .AutoSize = True,
                .Location = New Point(15, 15)
            }
            panel.Controls.Add(title)

            ' Product Search
            Dim lblProduct As New Label With {
                .Text = "Search Product:",
                .Location = New Point(15, 50),
                .AutoSize = True
            }
            panel.Controls.Add(lblProduct)

            txtProductSearch = New TextBox With {
                .Location = New Point(15, 70),
                .Width = 350,
                .Font = New Font("Segoe UI", 10)
            }
            AddHandler txtProductSearch.TextChanged, AddressOf OnProductSearchChanged
            panel.Controls.Add(txtProductSearch)

            ' Product Results
            lstProductResults = New ListBox With {
                .Location = New Point(15, 95),
                .Width = 350,
                .Height = 80,
                .Font = New Font("Segoe UI", 9)
            }
            AddHandler lstProductResults.SelectedIndexChanged, AddressOf OnProductSelected
            AddHandler lstProductResults.DoubleClick, AddressOf OnProductDoubleClick
            panel.Controls.Add(lstProductResults)

            ' Product Code
            lblProductCode = New Label With {
                .Text = "Code: -",
                .Location = New Point(380, 70),
                .AutoSize = True,
                .ForeColor = ColorDark,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            panel.Controls.Add(lblProductCode)

            ' Batch Size
            Dim lblBatch As New Label With {
                .Text = "Batch Size:",
                .Location = New Point(380, 100),
                .AutoSize = True
            }
            panel.Controls.Add(lblBatch)

            txtBatchSize = New NumericUpDown With {
                .Location = New Point(380, 120),
                .Width = 100,
                .Minimum = 1,
                .Maximum = 10000,
                .Value = 1,
                .Font = New Font("Segoe UI", 10)
            }
            AddHandler txtBatchSize.ValueChanged, AddressOf OnBatchSizeChanged
            panel.Controls.Add(txtBatchSize)

            Return panel
        End Function

        Private Function CreatePanel2() As Panel
            Dim panel As New Panel With {
                .Dock = DockStyle.Fill,
                .BackColor = ColorWhite,
                .Padding = New Padding(15)
            }

            ' Title
            Dim title As New Label With {
                .Text = "2. ADD SUB-RECIPES & OTHER ITEMS",
                .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                .ForeColor = ColorSuccess,
                .AutoSize = True,
                .Location = New Point(15, 15)
            }
            panel.Controls.Add(title)

            ' Sub-Recipe Search
            Dim lblSubRecipe As New Label With {
                .Text = "Search Sub-Recipe:",
                .Location = New Point(15, 50),
                .AutoSize = True
            }
            panel.Controls.Add(lblSubRecipe)

            txtSubRecipeSearch = New TextBox With {
                .Location = New Point(15, 70),
                .Width = 250,
                .Font = New Font("Segoe UI", 10)
            }
            AddHandler txtSubRecipeSearch.TextChanged, AddressOf OnSubRecipeSearchChanged
            panel.Controls.Add(txtSubRecipeSearch)

            btnAddSubRecipe = New Button With {
                .Text = "Add →",
                .Location = New Point(270, 68),
                .Width = 80,
                .Height = 28,
                .BackColor = ColorSuccess,
                .ForeColor = ColorWhite,
                .FlatStyle = FlatStyle.Flat
            }
            btnAddSubRecipe.FlatAppearance.BorderSize = 0
            AddHandler btnAddSubRecipe.Click, AddressOf OnAddSubRecipeClick
            panel.Controls.Add(btnAddSubRecipe)

            lstSubRecipes = New ListBox With {
                .Location = New Point(15, 105),
                .Width = 335,
                .Height = 50,
                .Font = New Font("Segoe UI", 9)
            }
            AddHandler lstSubRecipes.DoubleClick, AddressOf OnSubRecipeDoubleClick
            panel.Controls.Add(lstSubRecipes)

            ' Other Items Search
            Dim lblOther As New Label With {
                .Text = "Search Other Items (packaging, etc):",
                .Location = New Point(370, 50),
                .AutoSize = True
            }
            panel.Controls.Add(lblOther)

            txtOtherItemSearch = New TextBox With {
                .Location = New Point(370, 70),
                .Width = 250,
                .Font = New Font("Segoe UI", 10)
            }
            AddHandler txtOtherItemSearch.TextChanged, AddressOf OnOtherItemSearchChanged
            panel.Controls.Add(txtOtherItemSearch)

            btnAddOtherItem = New Button With {
                .Text = "Add →",
                .Location = New Point(625, 68),
                .Width = 80,
                .Height = 28,
                .BackColor = ColorWarning,
                .ForeColor = ColorWhite,
                .FlatStyle = FlatStyle.Flat
            }
            btnAddOtherItem.FlatAppearance.BorderSize = 0
            AddHandler btnAddOtherItem.Click, AddressOf OnAddOtherItemClick
            panel.Controls.Add(btnAddOtherItem)

            lstOtherItems = New ListBox With {
                .Location = New Point(370, 105),
                .Width = 335,
                .Height = 50,
                .Font = New Font("Segoe UI", 9)
            }
            AddHandler lstOtherItems.DoubleClick, AddressOf OnOtherItemDoubleClick
            panel.Controls.Add(lstOtherItems)

            Return panel
        End Function

        Private Function CreatePanel3() As Panel
            Dim panel As New Panel With {
                .Dock = DockStyle.Fill,
                .BackColor = ColorWhite,
                .Padding = New Padding(15)
            }

            ' Title
            Dim title As New Label With {
                .Text = "3. BILL OF MATERIALS (BOM)",
                .Font = New Font("Segoe UI", 14, FontStyle.Bold),
                .ForeColor = ColorDark,
                .AutoSize = True,
                .Location = New Point(15, 15)
            }
            panel.Controls.Add(title)

            ' BOM Grid
            dgvBOM = New DataGridView With {
                .Location = New Point(15, 50),
                .Width = panel.Width - 30,
                .Height = panel.Height - 70,
                .Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = True,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .BackgroundColor = ColorWhite,
                .BorderStyle = BorderStyle.None,
                .RowHeadersVisible = False,
                .Font = New Font("Segoe UI", 10)
            }

            ' Style header
            dgvBOM.ColumnHeadersDefaultCellStyle.BackColor = ColorDark
            dgvBOM.ColumnHeadersDefaultCellStyle.ForeColor = ColorWhite
            dgvBOM.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
            dgvBOM.ColumnHeadersHeight = 40

            ' Alternating row colors
            dgvBOM.AlternatingRowsDefaultCellStyle.BackColor = ColorLight

            panel.Controls.Add(dgvBOM)

            Return panel
        End Function

        Private Function CreateBottomPanel() As Panel
            Dim panel As New Panel With {
                .Dock = DockStyle.Fill,
                .BackColor = ColorDark,
                .Padding = New Padding(15)
            }

            ' Cost Summary (Left side)
            Dim lblSubtotalLabel As New Label With {
                .Text = "Subtotal (excl VAT):",
                .Location = New Point(15, 15),
                .AutoSize = True,
                .ForeColor = ColorWhite,
                .Font = New Font("Segoe UI", 11)
            }
            panel.Controls.Add(lblSubtotalLabel)

            lblSubtotal = New Label With {
                .Text = "R 0.00",
                .Location = New Point(200, 15),
                .AutoSize = True,
                .ForeColor = ColorWhite,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold)
            }
            panel.Controls.Add(lblSubtotal)

            Dim lblVATLabel As New Label With {
                .Text = "VAT (15%):",
                .Location = New Point(15, 40),
                .AutoSize = True,
                .ForeColor = ColorWhite,
                .Font = New Font("Segoe UI", 11)
            }
            panel.Controls.Add(lblVATLabel)

            lblVAT = New Label With {
                .Text = "R 0.00",
                .Location = New Point(200, 40),
                .AutoSize = True,
                .ForeColor = ColorWhite,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold)
            }
            panel.Controls.Add(lblVAT)

            Dim lblTotalLabel As New Label With {
                .Text = "TOTAL COST:",
                .Location = New Point(15, 70),
                .AutoSize = True,
                .ForeColor = ColorSuccess,
                .Font = New Font("Segoe UI", 14, FontStyle.Bold)
            }
            panel.Controls.Add(lblTotalLabel)

            lblTotal = New Label With {
                .Text = "R 0.00",
                .Location = New Point(200, 70),
                .AutoSize = True,
                .ForeColor = ColorSuccess,
                .Font = New Font("Segoe UI", 14, FontStyle.Bold)
            }
            panel.Controls.Add(lblTotal)

            ' Action Buttons (Right side)
            Dim buttonX As Integer = panel.Width - 600

            btnSaveMethod = New Button With {
                .Text = "Add Method",
                .Location = New Point(buttonX, 20),
                .Width = 130,
                .Height = 40,
                .BackColor = ColorPrimary,
                .ForeColor = ColorWhite,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Anchor = AnchorStyles.Top Or AnchorStyles.Right
            }
            btnSaveMethod.FlatAppearance.BorderSize = 0
            AddHandler btnSaveMethod.Click, AddressOf OnSaveMethodClick
            panel.Controls.Add(btnSaveMethod)

            btnPrintRecipe = New Button With {
                .Text = "Print Recipe",
                .Location = New Point(buttonX + 140, 20),
                .Width = 130,
                .Height = 40,
                .BackColor = ColorWarning,
                .ForeColor = ColorWhite,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Anchor = AnchorStyles.Top Or AnchorStyles.Right
            }
            btnPrintRecipe.FlatAppearance.BorderSize = 0
            AddHandler btnPrintRecipe.Click, AddressOf OnPrintRecipeClick
            panel.Controls.Add(btnPrintRecipe)

            btnSave = New Button With {
                .Text = "Save BOM",
                .Location = New Point(buttonX + 280, 20),
                .Width = 130,
                .Height = 40,
                .BackColor = ColorSuccess,
                .ForeColor = ColorWhite,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Anchor = AnchorStyles.Top Or AnchorStyles.Right
            }
            btnSave.FlatAppearance.BorderSize = 0
            AddHandler btnSave.Click, AddressOf OnSaveClick
            panel.Controls.Add(btnSave)

            btnCancel = New Button With {
                .Text = "Cancel",
                .Location = New Point(buttonX + 420, 20),
                .Width = 130,
                .Height = 40,
                .BackColor = ColorDanger,
                .ForeColor = ColorWhite,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Anchor = AnchorStyles.Top Or AnchorStyles.Right
            }
            btnCancel.FlatAppearance.BorderSize = 0
            AddHandler btnCancel.Click, AddressOf OnCancelClick
            panel.Controls.Add(btnCancel)

            Return panel
        End Function

        Private Sub InitializeBOMTable()
            bomTable = New DataTable()
            bomTable.Columns.Add("ItemID", GetType(Integer))
            bomTable.Columns.Add("ProductName", GetType(String))
            bomTable.Columns.Add("ProductType", GetType(String))
            bomTable.Columns.Add("SubRecipeName", GetType(String))
            bomTable.Columns.Add("Qty", GetType(Decimal))
            bomTable.Columns.Add("UnitOfMeasure", GetType(String))
            bomTable.Columns.Add("UnitCost", GetType(Decimal))
            bomTable.Columns.Add("TotalCost", GetType(Decimal))
            bomTable.Columns.Add("IsVatable", GetType(Boolean))

            ' Bind to DataGridView
            dgvBOM.DataSource = bomTable
            dgvBOM.AutoGenerateColumns = True

            ' Wait for columns to be generated, then format them
            Application.DoEvents()

            ' Hide ItemID column
            If dgvBOM.Columns.Contains("ItemID") Then
                dgvBOM.Columns("ItemID").Visible = False
            End If

            ' Format columns
            If dgvBOM.Columns.Contains("ProductName") Then
                dgvBOM.Columns("ProductName").HeaderText = "Item Name"
                dgvBOM.Columns("ProductName").Width = 250
            End If

            If dgvBOM.Columns.Contains("ProductType") Then
                dgvBOM.Columns("ProductType").HeaderText = "Type"
            End If

            If dgvBOM.Columns.Contains("SubRecipeName") Then
                dgvBOM.Columns("SubRecipeName").HeaderText = "Sub-Recipe"
            End If

            If dgvBOM.Columns.Contains("Qty") Then
                dgvBOM.Columns("Qty").HeaderText = "Quantity"
                dgvBOM.Columns("Qty").DefaultCellStyle.Format = "N2"
            End If

            If dgvBOM.Columns.Contains("UnitOfMeasure") Then
                dgvBOM.Columns("UnitOfMeasure").HeaderText = "Unit"
            End If

            If dgvBOM.Columns.Contains("UnitCost") Then
                dgvBOM.Columns("UnitCost").HeaderText = "Unit Cost"
                dgvBOM.Columns("UnitCost").DefaultCellStyle.Format = "C2"
            End If

            If dgvBOM.Columns.Contains("TotalCost") Then
                dgvBOM.Columns("TotalCost").HeaderText = "Total Cost"
                dgvBOM.Columns("TotalCost").DefaultCellStyle.Format = "C2"
            End If

            If dgvBOM.Columns.Contains("IsVatable") Then
                dgvBOM.Columns("IsVatable").HeaderText = "VAT"
            End If

            AddHandler dgvBOM.CellValueChanged, AddressOf OnBOMCellChanged
        End Sub

        ' Event Handlers
        Private Sub OnFormLoad(sender As Object, e As EventArgs)
            LoadSubRecipes("")
            LoadOtherItems("")
        End Sub

        Private Sub OnProductSearchChanged(sender As Object, e As EventArgs)
            lstProductResults.Visible = True
            LoadProducts(txtProductSearch.Text)
        End Sub

        Private Sub LoadProducts(searchText As String)
            lstProductResults.Items.Clear()
            Dim searchParam = If(String.IsNullOrEmpty(searchText), "%", $"%{searchText}%")

            Try
                Using cn As New SqlConnection(_connectionString)
                    cn.Open()
                    ' Query Demo_Retail_Product for MANUFACTURED PRODUCTS (exclude raw materials and sub-recipes)
                    ' Use GROUP BY Name to avoid duplicates when Super Admin sees all branches
                    ' Only show products without a recipe (Recipe_Created = 0 or NULL)
                    ' For branch users: filter by their branch. For HEAD OFFICE: show all but pick first ProductID per name
                    Dim currentBranchID = If(AppSession.CurrentUser?.BranchID, 0)
                    Dim query As String
                    
                    If currentBranchID = 0 OrElse currentBranchID = 12 Then
                        ' HEAD OFFICE - show all branches, use MIN(ProductID) to pick one
                        query = "SELECT MIN(ProductID) AS ProductID, Name AS ProductName " & _
                               "FROM Demo_Retail_Product " & _
                               "WHERE (Name LIKE @search OR ISNULL(Code, SKU) LIKE @search) " & _
                               "  AND IsActive = 1 " & _
                               "  AND ProductType = 'Internal' " & _
                               "  AND (Recipe_Created = 0 OR Recipe_Created IS NULL) " & _
                               "  AND Category NOT LIKE '%ingredient%' " & _
                               "  AND Category NOT LIKE '%sub%recipe%' " & _
                               "  AND Category NOT LIKE '%subrecipe%' " & _
                               "  AND Category NOT LIKE '%consumable%' " & _
                               "  AND Category NOT LIKE '%pack%' " & _
                               "  AND Category NOT LIKE '%misce%' " & _
                               "GROUP BY Name " & _
                               "ORDER BY Name"
                    Else
                        ' Specific branch - filter by branch, no need for GROUP BY
                        query = "SELECT ProductID, Name AS ProductName " & _
                               "FROM Demo_Retail_Product " & _
                               "WHERE (Name LIKE @search OR ISNULL(Code, SKU) LIKE @search) " & _
                               "  AND IsActive = 1 " & _
                               "  AND BranchID = @BranchID " & _
                               "  AND ProductType = 'Internal' " & _
                               "  AND (Recipe_Created = 0 OR Recipe_Created IS NULL) " & _
                               "  AND Category NOT LIKE '%ingredient%' " & _
                               "  AND Category NOT LIKE '%sub%recipe%' " & _
                               "  AND Category NOT LIKE '%subrecipe%' " & _
                               "  AND Category NOT LIKE '%consumable%' " & _
                               "  AND Category NOT LIKE '%pack%' " & _
                               "  AND Category NOT LIKE '%misce%' " & _
                               "ORDER BY Name"
                    End If
                    
                    Using cmd As New SqlCommand(query, cn)
                        cmd.Parameters.AddWithValue("@search", searchParam)
                        If currentBranchID > 0 AndAlso currentBranchID <> 12 Then
                            cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                        End If
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                Dim productId = reader.GetInt32(0)
                                Dim name = reader.GetString(1)
                                lstProductResults.Items.Add(New With {
                                    .ProductID = productId,
                                    .ProductCode = "",
                                    .ProductName = name,
                                    .Display = name
                                })
                            End While
                        End Using
                    End Using
                End Using

                If lstProductResults.Items.Count > 0 Then
                    lstProductResults.DisplayMember = "Display"
                End If
            Catch ex As Exception
                MessageBox.Show($"Error loading products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnProductSelected(sender As Object, e As EventArgs)
            If lstProductResults.SelectedItem IsNot Nothing Then
                Dim selected = lstProductResults.SelectedItem
                _selectedProductId = selected.ProductID
                txtProductSearch.Text = selected.ProductName
                lblProductCode.Text = $"Code: {selected.ProductCode}"
                lstProductResults.Visible = False
            End If
        End Sub

        Private Sub OnProductDoubleClick(sender As Object, e As EventArgs)
            OnProductSelected(sender, e)
        End Sub

        Private Sub OnSubRecipeSearchChanged(sender As Object, e As EventArgs)
            LoadSubRecipes(txtSubRecipeSearch.Text)
        End Sub

        Private Sub LoadSubRecipes(searchText As String)
            lstSubRecipes.Items.Clear()

            ' Show all if search is empty, otherwise filter
            Dim searchParam = If(String.IsNullOrEmpty(searchText), "%", $"%{searchText}%")

            Try
                Using cn As New SqlConnection(_connectionString)
                    cn.Open()
                    ' Query Demo_Retail_Product for Sub Recipe category
                    ' Branch filtering: HEAD OFFICE shows all, specific branch filters by BranchID
                    Dim currentBranchID = If(AppSession.CurrentUser?.BranchID, 0)
                    Dim query As String
                    
                    If currentBranchID = 0 OrElse currentBranchID = 12 Then
                        query = "SELECT MIN(ProductID) AS ProductID, Name AS ProductName " & _
                               "FROM Demo_Retail_Product " & _
                               "WHERE (Name LIKE @search OR ISNULL(Code, SKU) LIKE @search) " & _
                               "  AND IsActive = 1 " & _
                               "  AND (Category LIKE '%sub%recipe%' OR Category LIKE '%subrecipe%') " & _
                               "GROUP BY Name " & _
                               "ORDER BY Name"
                    Else
                        query = "SELECT ProductID, Name AS ProductName " & _
                               "FROM Demo_Retail_Product " & _
                               "WHERE (Name LIKE @search OR ISNULL(Code, SKU) LIKE @search) " & _
                               "  AND IsActive = 1 " & _
                               "  AND BranchID = @BranchID " & _
                               "  AND (Category LIKE '%sub%recipe%' OR Category LIKE '%subrecipe%') " & _
                               "ORDER BY Name"
                    End If
                    
                    Using cmd As New SqlCommand(query, cn)
                        cmd.Parameters.AddWithValue("@search", searchParam)
                        If currentBranchID > 0 AndAlso currentBranchID <> 12 Then
                            cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                        End If
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                Dim productId = reader.GetInt32(0)
                                Dim name = reader.GetString(1)
                                lstSubRecipes.Items.Add(New With {
                                    .ProductID = productId,
                                    .ProductCode = "",
                                    .ProductName = name,
                                    .Display = name
                                })
                            End While
                        End Using
                    End Using
                End Using

                If lstSubRecipes.Items.Count > 0 Then
                    lstSubRecipes.DisplayMember = "Display"
                End If
            Catch ex As Exception
                MessageBox.Show($"Error loading sub-recipes: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnOtherItemSearchChanged(sender As Object, e As EventArgs)
            LoadOtherItems(txtOtherItemSearch.Text)
        End Sub

        Private Sub LoadOtherItems(searchText As String)
            lstOtherItems.Items.Clear()

            ' Show all if search is empty, otherwise filter
            Dim searchParam = If(String.IsNullOrEmpty(searchText), "%", $"%{searchText}%")

            Try
                Using cn As New SqlConnection(_connectionString)
                    cn.Open()
                    ' Query Demo_Retail_Product for Consumables, Packaging, Miscellaneous categories
                    ' Branch filtering: HEAD OFFICE shows all, specific branch filters by BranchID
                    Dim currentBranchID = If(AppSession.CurrentUser?.BranchID, 0)
                    Dim query As String
                    
                    If currentBranchID = 0 OrElse currentBranchID = 12 Then
                        query = "SELECT MIN(ProductID) AS ProductID, Name AS ProductName " & _
                               "FROM Demo_Retail_Product " & _
                               "WHERE (Name LIKE @search OR ISNULL(Code, SKU) LIKE @search) " & _
                               "  AND IsActive = 1 " & _
                               "  AND (Category LIKE '%consumable%' OR Category LIKE '%pack%' OR Category LIKE '%misce%') " & _
                               "GROUP BY Name " & _
                               "ORDER BY Name"
                    Else
                        query = "SELECT ProductID, Name AS ProductName " & _
                               "FROM Demo_Retail_Product " & _
                               "WHERE (Name LIKE @search OR ISNULL(Code, SKU) LIKE @search) " & _
                               "  AND IsActive = 1 " & _
                               "  AND BranchID = @BranchID " & _
                               "  AND (Category LIKE '%consumable%' OR Category LIKE '%pack%' OR Category LIKE '%misce%') " & _
                               "ORDER BY Name"
                    End If
                    
                    Using cmd As New SqlCommand(query, cn)
                        cmd.Parameters.AddWithValue("@search", searchParam)
                        If currentBranchID > 0 AndAlso currentBranchID <> 12 Then
                            cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                        End If
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                Dim productId = reader.GetInt32(0)
                                Dim name = reader.GetString(1)
                                lstOtherItems.Items.Add(New With {
                                    .ProductID = productId,
                                    .ProductCode = "",
                                    .ProductName = name,
                                    .Display = name
                                })
                            End While
                        End Using
                    End Using
                End Using

                If lstOtherItems.Items.Count > 0 Then
                    lstOtherItems.DisplayMember = "Display"
                End If
            Catch ex As Exception
                MessageBox.Show($"Error loading other items: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnAddSubRecipeClick(sender As Object, e As EventArgs)
            If lstSubRecipes.SelectedItem Is Nothing Then
                MessageBox.Show("Please select a sub-recipe first.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim selected = lstSubRecipes.SelectedItem

            ' Ask if sub-recipe has ingredients
            Dim result = MessageBox.Show($"Does '{selected.ProductName}' have ingredients?", "Sub-Recipe Ingredients", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Question)

            If result = DialogResult.Cancel Then Return

            If result = DialogResult.Yes Then
                ' Open ingredient builder dialog
                Dim ingredientDialog As New SubRecipeIngredientDialog(selected.ProductID, selected.ProductName, _connectionString)
                If ingredientDialog.ShowDialog() = DialogResult.OK Then
                    ' Add ingredients to BOM
                    For Each ingredient In ingredientDialog.GetIngredients()
                        Dim row = bomTable.NewRow()
                        row("ItemID") = ingredient.ProductID
                        row("ProductName") = ingredient.ProductName
                        row("ProductType") = "Ingredient"
                        row("SubRecipeName") = selected.ProductName
                        row("Qty") = ingredient.Quantity
                        row("UnitOfMeasure") = "ea"
                        row("UnitCost") = ingredient.Cost
                        row("TotalCost") = ingredient.Quantity * ingredient.Cost * txtBatchSize.Value
                        row("IsVatable") = True
                        bomTable.Rows.Add(row)
                    Next
                    RecalculateBOM()
                End If
            Else
                ' No ingredients, just add sub-recipe with quantity
                Dim qtyDialog As New Form With {
                    .Text = "Enter Quantity",
                    .Width = 300,
                    .Height = 150,
                    .StartPosition = FormStartPosition.CenterParent
                }

                Dim lblQty As New Label With {
                    .Text = "Quantity:",
                    .Location = New Point(20, 20),
                    .AutoSize = True
                }
                qtyDialog.Controls.Add(lblQty)

                Dim txtQty As New NumericUpDown With {
                    .Location = New Point(20, 45),
                    .Width = 240,
                    .Minimum = 0.01,
                    .Maximum = 10000,
                    .DecimalPlaces = 2,
                    .Value = 1
                }
                qtyDialog.Controls.Add(txtQty)

                Dim btnOK As New Button With {
                    .Text = "Add to BOM",
                    .Location = New Point(20, 75),
                    .Width = 100,
                    .DialogResult = DialogResult.OK
                }
                qtyDialog.Controls.Add(btnOK)

                Dim btnCancel As New Button With {
                    .Text = "Cancel",
                    .Location = New Point(130, 75),
                    .Width = 100,
                    .DialogResult = DialogResult.Cancel
                }
                qtyDialog.Controls.Add(btnCancel)

                If qtyDialog.ShowDialog() = DialogResult.OK Then
                    AddItemToBOM(selected.ProductID, selected.ProductName, "Sub-Recipe", "", txtQty.Value)
                End If
            End If
        End Sub

        Private Sub OnSubRecipeDoubleClick(sender As Object, e As EventArgs)
            OnAddSubRecipeClick(sender, e)
        End Sub

        Private Sub OnAddOtherItemClick(sender As Object, e As EventArgs)
            If lstOtherItems.SelectedItem Is Nothing Then
                MessageBox.Show("Please select an item first.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim selected = lstOtherItems.SelectedItem
            Dim qtyDialog As New Form With {
                .Text = "Enter Quantity",
                .Width = 300,
                .Height = 150,
                .StartPosition = FormStartPosition.CenterParent
            }

            Dim lblQty As New Label With {
                .Text = "Quantity:",
                .Location = New Point(20, 20),
                .AutoSize = True
            }
            qtyDialog.Controls.Add(lblQty)

            Dim txtQty As New NumericUpDown With {
                .Location = New Point(20, 45),
                .Width = 240,
                .Minimum = 0.01,
                .Maximum = 10000,
                .DecimalPlaces = 2,
                .Value = 1
            }
            qtyDialog.Controls.Add(txtQty)

            Dim btnOK As New Button With {
                .Text = "Add to BOM",
                .Location = New Point(20, 75),
                .Width = 100,
                .DialogResult = DialogResult.OK
            }
            qtyDialog.Controls.Add(btnOK)

            Dim btnCancel As New Button With {
                .Text = "Cancel",
                .Location = New Point(130, 75),
                .Width = 100,
                .DialogResult = DialogResult.Cancel
            }
            qtyDialog.Controls.Add(btnCancel)

            If qtyDialog.ShowDialog() = DialogResult.OK Then
                AddItemToBOM(selected.ProductID, selected.ProductName, "Other", "", txtQty.Value)
            End If
        End Sub

        Private Sub OnOtherItemDoubleClick(sender As Object, e As EventArgs)
            OnAddOtherItemClick(sender, e)
        End Sub

        Private Sub AddSubRecipeToBOM(subRecipeID As Integer, subRecipeName As String, quantity As Decimal)
            Try
                Using cn As New SqlConnection(_connectionString)
                    cn.Open()
                    ' Check if sub-recipe has ingredients in RecipeNode table
                    Dim query = "SELECT COUNT(*) FROM RecipeNode WHERE ProductID = @id AND ParentNodeID IS NOT NULL"
                    Using cmd As New SqlCommand(query, cn)
                        cmd.Parameters.AddWithValue("@id", subRecipeID)
                        Dim hasIngredients = Convert.ToInt32(cmd.ExecuteScalar()) > 0

                        If hasIngredients Then
                            ' Add ingredients from RecipeNode
                            Dim ingredientQuery = "SELECT rn.ItemName, rn.Qty, p.ProductID, ISNULL(p.AverageCost, 0) AS Cost " &
                                                "FROM RecipeNode rn " &
                                                "LEFT JOIN Products p ON p.ProductName = rn.ItemName " &
                                                "WHERE rn.ProductID = @id AND rn.ParentNodeID IS NOT NULL"
                            Using cmdIngredients As New SqlCommand(ingredientQuery, cn)
                                cmdIngredients.Parameters.AddWithValue("@id", subRecipeID)
                                Using reader = cmdIngredients.ExecuteReader()
                                    While reader.Read()
                                        Dim ingredientName = reader.GetString(0)
                                        Dim ingredientQty = reader.GetDecimal(1)
                                        Dim ingredientID = If(reader.IsDBNull(2), 0, reader.GetInt32(2))
                                        Dim cost = reader.GetDecimal(3)

                                        Dim row = bomTable.NewRow()
                                        row("ItemID") = ingredientID
                                        row("ProductName") = ingredientName
                                        row("ProductType") = "Ingredient"
                                        row("SubRecipeName") = subRecipeName
                                        row("Qty") = ingredientQty * quantity
                                        row("UnitOfMeasure") = "ea"
                                        row("UnitCost") = cost
                                        row("TotalCost") = ingredientQty * quantity * cost * txtBatchSize.Value
                                        row("IsVatable") = True
                                        bomTable.Rows.Add(row)
                                    End While
                                End Using
                            End Using
                        Else
                            ' No ingredients, add sub-recipe itself
                            AddItemToBOM(subRecipeID, subRecipeName, "Sub-Recipe", "", quantity)
                        End If

                        RecalculateBOM()
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error adding sub-recipe: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub AddItemToBOM(itemID As Integer, itemName As String, itemType As String, subRecipe As String, quantity As Decimal)
            Try
                Using cn As New SqlConnection(_connectionString)
                    cn.Open()
                    Dim query = "SELECT ISNULL(AverageCost, 0) FROM Products WHERE ProductID = @id"
                    Using cmd As New SqlCommand(query, cn)
                        cmd.Parameters.AddWithValue("@id", itemID)
                        Dim costObj = cmd.ExecuteScalar()
                        Dim cost As Decimal = If(costObj IsNot Nothing AndAlso Not IsDBNull(costObj), Convert.ToDecimal(costObj), 0D)

                        Dim row = bomTable.NewRow()
                        row("ItemID") = itemID
                        row("ProductName") = itemName
                        row("ProductType") = itemType
                        row("SubRecipeName") = subRecipe
                        row("Qty") = quantity
                        row("UnitOfMeasure") = "ea"
                        row("UnitCost") = cost
                        row("TotalCost") = quantity * cost * txtBatchSize.Value
                        row("IsVatable") = True

                        bomTable.Rows.Add(row)
                        RecalculateBOM()
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error adding item: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnBatchSizeChanged(sender As Object, e As EventArgs)
            RecalculateBOM()
        End Sub

        Private Sub OnBOMCellChanged(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex >= 0 Then
                RecalculateBOM()
            End If
        End Sub

        Private Sub RecalculateBOM()
            Dim subtotal As Decimal = 0
            Dim vatAmount As Decimal = 0

            For Each row As DataRow In bomTable.Rows
                Dim qty = Convert.ToDecimal(row("Qty"))
                Dim unitCost = Convert.ToDecimal(row("UnitCost"))
                Dim batchSize = txtBatchSize.Value
                Dim totalCost = qty * unitCost * batchSize

                row("TotalCost") = totalCost
                subtotal += totalCost

                If Convert.ToBoolean(row("IsVatable")) Then
                    vatAmount += totalCost * 0.15D
                End If
            Next

            lblSubtotal.Text = $"R {subtotal:N2}"
            lblVAT.Text = $"R {vatAmount:N2}"
            lblTotal.Text = $"R {(subtotal + vatAmount):N2}"
        End Sub

        Private Sub OnSaveMethodClick(sender As Object, e As EventArgs)
            ' Open method dialog
            Dim methodForm As New Form With {
                .Text = "Add Manufacturing Method",
                .Width = 600,
                .Height = 400,
                .StartPosition = FormStartPosition.CenterParent
            }

            txtMethod = New TextBox With {
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .Dock = DockStyle.Fill,
                .Font = New Font("Segoe UI", 10),
                .Padding = New Padding(10)
            }
            methodForm.Controls.Add(txtMethod)

            Dim btnOK As New Button With {
                .Text = "Save Method",
                .Dock = DockStyle.Bottom,
                .Height = 40,
                .BackColor = ColorSuccess,
                .ForeColor = ColorWhite,
                .FlatStyle = FlatStyle.Flat
            }
            AddHandler btnOK.Click, Sub()
                                        methodForm.DialogResult = DialogResult.OK
                                        methodForm.Close()
                                    End Sub
            methodForm.Controls.Add(btnOK)

            methodForm.ShowDialog()
        End Sub

        Private Sub OnPrintRecipeClick(sender As Object, e As EventArgs)
            If _selectedProductId = 0 Then
                MessageBox.Show("Please select a product first.", "No Product", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If bomTable.Rows.Count = 0 Then
                MessageBox.Show("Please add at least one item to the BOM.", "Empty BOM", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Dim printDoc As New PrintDocument()
                AddHandler printDoc.PrintPage, AddressOf PrintBOMPage
                
                Dim printDialog As New PrintDialog()
                printDialog.Document = printDoc
                
                If printDialog.ShowDialog() = DialogResult.OK Then
                    printDoc.Print()
                End If
            Catch ex As Exception
                MessageBox.Show($"Error printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub PrintBOMPage(sender As Object, e As PrintPageEventArgs)
            Dim font As New Font("Arial", 10)
            Dim fontBold As New Font("Arial", 12, FontStyle.Bold)
            Dim fontTitle As New Font("Arial", 16, FontStyle.Bold)
            Dim y As Single = 50
            Dim leftMargin As Single = 50
            
            ' Title
            e.Graphics.DrawString("RECIPE CARD", fontTitle, Brushes.Black, leftMargin, y)
            y += 40
            
            ' Product Info
            e.Graphics.DrawString($"Product: {txtProductSearch.Text}", fontBold, Brushes.Black, leftMargin, y)
            y += 25
            e.Graphics.DrawString($"{lblProductCode.Text}", font, Brushes.Black, leftMargin, y)
            y += 20
            e.Graphics.DrawString($"Batch Size: {txtBatchSize.Value}", font, Brushes.Black, leftMargin, y)
            y += 30
            
            ' Ingredients Header
            e.Graphics.DrawString("INGREDIENTS:", fontBold, Brushes.Black, leftMargin, y)
            y += 25
            
            ' BOM Lines
            For Each row As DataRow In bomTable.Rows
                Dim itemText = $"• {row("ProductName")} - {row("Qty")} {row("UnitOfMeasure")}"
                If Not String.IsNullOrEmpty(row("SubRecipeName").ToString()) Then
                    itemText &= $" (from {row("SubRecipeName")})"
                End If
                e.Graphics.DrawString(itemText, font, Brushes.Black, leftMargin + 20, y)
                y += 20
            Next
            
            y += 20
            
            ' Method
            If txtMethod IsNot Nothing AndAlso Not String.IsNullOrEmpty(txtMethod.Text) Then
                e.Graphics.DrawString("METHOD:", fontBold, Brushes.Black, leftMargin, y)
                y += 25
                
                Dim methodLines = txtMethod.Text.Split(New String() {Environment.NewLine}, StringSplitOptions.None)
                For Each line In methodLines
                    e.Graphics.DrawString(line, font, Brushes.Black, leftMargin + 20, y)
                    y += 20
                Next
                
                y += 20
            End If
            
            ' Cost Summary
            e.Graphics.DrawString("COST SUMMARY:", fontBold, Brushes.Black, leftMargin, y)
            y += 25
            e.Graphics.DrawString($"Subtotal: {lblSubtotal.Text}", font, Brushes.Black, leftMargin + 20, y)
            y += 20
            e.Graphics.DrawString($"VAT (15%): {lblVAT.Text}", font, Brushes.Black, leftMargin + 20, y)
            y += 20
            e.Graphics.DrawString($"Total: {lblTotal.Text}", fontBold, Brushes.Black, leftMargin + 20, y)
            
            e.HasMorePages = False
        End Sub

        Private Sub OnSaveClick(sender As Object, e As EventArgs)
            If _selectedProductId = 0 Then
                MessageBox.Show("Please select a product first.", "No Product", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If bomTable.Rows.Count = 0 Then
                MessageBox.Show("Please add at least one item to the BOM.", "Empty BOM", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Using cn As New SqlConnection(_connectionString)
                    cn.Open()
                    Using trans = cn.BeginTransaction()
                        Try
                            ' Get product details
                            Dim productName As String = txtProductSearch.Text
                            Dim productCode As String = lblProductCode.Text.Replace("Code: ", "")
                            
                            ' Calculate totals
                            Dim subtotal As Decimal = 0
                            For Each row As DataRow In bomTable.Rows
                                subtotal += Convert.ToDecimal(row("TotalCost"))
                            Next
                            Dim vatAmount As Decimal = subtotal * 0.15D
                            Dim totalWithVAT As Decimal = subtotal + vatAmount
                            
                            ' Insert BOM Header
                            Dim headerQuery = "INSERT INTO BOM_Header (ProductID, ProductName, ProductCode, BatchSize, TotalCost, TotalCostWithVAT, MethodInstructions, CreatedBy, CreatedDate, IsActive) " &
                                            "VALUES (@ProductID, @ProductName, @ProductCode, @BatchSize, @TotalCost, @TotalCostWithVAT, @Method, @CreatedBy, GETDATE(), 1); SELECT SCOPE_IDENTITY();"
                            Dim cmdHeader As New SqlCommand(headerQuery, cn, trans)
                            cmdHeader.Parameters.AddWithValue("@ProductID", _selectedProductId)
                            cmdHeader.Parameters.AddWithValue("@ProductName", productName)
                            cmdHeader.Parameters.AddWithValue("@ProductCode", productCode)
                            cmdHeader.Parameters.AddWithValue("@BatchSize", txtBatchSize.Value)
                            cmdHeader.Parameters.AddWithValue("@TotalCost", subtotal)
                            cmdHeader.Parameters.AddWithValue("@TotalCostWithVAT", totalWithVAT)
                            cmdHeader.Parameters.AddWithValue("@Method", If(txtMethod?.Text, ""))
                            cmdHeader.Parameters.AddWithValue("@CreatedBy", If(AppSession.CurrentUser?.Username, "System"))
                            
                            Dim bomID As Integer = Convert.ToInt32(cmdHeader.ExecuteScalar())
                            
                            ' Insert BOM Lines
                            Dim lineNumber As Integer = 1
                            For Each row As DataRow In bomTable.Rows
                                Dim lineQuery = "INSERT INTO BOM_Lines (BOMID, ItemID, ProductName, ProductType, SubRecipeName, Quantity, UnitOfMeasure, UnitCost, TotalCost, IsVatable, LineNumber) " &
                                              "VALUES (@BOMID, @ItemID, @ProductName, @ProductType, @SubRecipeName, @Qty, @Unit, @UnitCost, @TotalCost, @IsVatable, @LineNumber)"
                                Dim cmdLine As New SqlCommand(lineQuery, cn, trans)
                                cmdLine.Parameters.AddWithValue("@BOMID", bomID)
                                cmdLine.Parameters.AddWithValue("@ItemID", row("ItemID"))
                                cmdLine.Parameters.AddWithValue("@ProductName", row("ProductName"))
                                cmdLine.Parameters.AddWithValue("@ProductType", row("ProductType"))
                                cmdLine.Parameters.AddWithValue("@SubRecipeName", If(row("SubRecipeName"), DBNull.Value))
                                cmdLine.Parameters.AddWithValue("@Qty", row("Qty"))
                                cmdLine.Parameters.AddWithValue("@Unit", row("UnitOfMeasure"))
                                cmdLine.Parameters.AddWithValue("@UnitCost", row("UnitCost"))
                                cmdLine.Parameters.AddWithValue("@TotalCost", row("TotalCost"))
                                cmdLine.Parameters.AddWithValue("@IsVatable", row("IsVatable"))
                                cmdLine.Parameters.AddWithValue("@LineNumber", lineNumber)
                                cmdLine.ExecuteNonQuery()
                                lineNumber += 1
                            Next
                            
                            ' Mark product as having a recipe created
                            Dim updateRecipeQuery = "UPDATE Demo_Retail_Product SET Recipe_Created = 1 WHERE ProductID = @ProductID"
                            Dim cmdUpdateRecipe As New SqlCommand(updateRecipeQuery, cn, trans)
                            cmdUpdateRecipe.Parameters.AddWithValue("@ProductID", _selectedProductId)
                            cmdUpdateRecipe.ExecuteNonQuery()
                            
                            trans.Commit()
                            MessageBox.Show($"BOM saved successfully! BOM ID: {bomID}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            Me.DialogResult = DialogResult.OK
                            Me.Close()
                        Catch ex As Exception
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error saving BOM: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnCancelClick(sender As Object, e As EventArgs)
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Sub

    End Class

End Namespace
