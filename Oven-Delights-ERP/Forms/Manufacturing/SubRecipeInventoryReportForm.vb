Imports System.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing
    Public Class SubRecipeInventoryReportForm
        Inherits Form
        
        Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private currentBranchID As Integer = 0
        Private isSuperAdmin As Boolean = False
        
        Public Sub New()
            InitializeComponent()
            
            ' Configure DataGridView for better appearance
            ConfigureDataGridView()
            
            ' Hide all filter controls - we only show sub-recipes with recipes
            If cmbFreshness IsNot Nothing Then
                cmbFreshness.Visible = False
                If Label4 IsNot Nothing Then Label4.Visible = False
            End If
            If cmbBranch IsNot Nothing Then
                cmbBranch.Visible = False
                If Label1 IsNot Nothing Then Label1.Visible = False
            End If
            If cmbSubRecipe IsNot Nothing Then
                cmbSubRecipe.Visible = False
                If Label2 IsNot Nothing Then Label2.Visible = False
            End If
            If btnExport IsNot Nothing Then
                btnExport.Visible = False
            End If
            
            ' Load data
            If AppSession.CurrentUser IsNot Nothing Then
                currentBranchID = AppSession.CurrentUser.BranchID
                isSuperAdmin = (AppSession.CurrentUser.UserID = 1 OrElse AppSession.CurrentUser.RoleID = 1)
            End If
            
            LoadSubRecipesWithRecipes()
        End Sub
        
        Private Sub ConfigureDataGridView()
            ' Modern styling for DataGridView
            dgvInventory.AutoGenerateColumns = False
            dgvInventory.AllowUserToAddRows = False
            dgvInventory.AllowUserToDeleteRows = False
            dgvInventory.ReadOnly = True
            dgvInventory.SelectionMode = DataGridViewSelectionMode.FullRowSelect
            dgvInventory.BackgroundColor = Color.White
            dgvInventory.BorderStyle = BorderStyle.None
            dgvInventory.RowHeadersVisible = False
            dgvInventory.EnableHeadersVisualStyles = False
            dgvInventory.ColumnHeadersHeight = 40
            dgvInventory.RowTemplate.Height = 40
            
            ' Header styling
            dgvInventory.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(230, 126, 34)
            dgvInventory.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgvInventory.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
            dgvInventory.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
            dgvInventory.ColumnHeadersDefaultCellStyle.Padding = New Padding(10)
            
            ' Alternating row colors
            dgvInventory.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(250, 250, 250)
            dgvInventory.DefaultCellStyle.SelectionBackColor = Color.FromArgb(230, 126, 34)
            dgvInventory.DefaultCellStyle.SelectionForeColor = Color.White
            dgvInventory.DefaultCellStyle.Font = New Font("Segoe UI", 10)
            dgvInventory.DefaultCellStyle.Padding = New Padding(8)
            
            ' Clear existing columns and add new ones
            dgvInventory.Columns.Clear()
            
            ' Add hidden ProductID column
            Dim colProductID As New DataGridViewTextBoxColumn With {
                .Name = "ProductID",
                .DataPropertyName = "ProductID",
                .Visible = False
            }
            dgvInventory.Columns.Add(colProductID)
            
            ' Add hidden BOMID column
            Dim colBOMID As New DataGridViewTextBoxColumn With {
                .Name = "BOMID",
                .DataPropertyName = "BOMID",
                .Visible = False
            }
            dgvInventory.Columns.Add(colBOMID)
            
            ' Add Edit button column
            Dim colEdit As New DataGridViewButtonColumn With {
                .Name = "Edit",
                .HeaderText = "Action",
                .Text = "✏️ Edit Recipe",
                .UseColumnTextForButtonValue = True,
                .Width = 120,
                .DefaultCellStyle = New DataGridViewCellStyle With {
                    .BackColor = Color.FromArgb(52, 152, 219),
                    .ForeColor = Color.White,
                    .SelectionBackColor = Color.FromArgb(41, 128, 185),
                    .SelectionForeColor = Color.White,
                    .Font = New Font("Segoe UI", 10, FontStyle.Bold)
                }
            }
            dgvInventory.Columns.Add(colEdit)
            
            dgvInventory.Columns.AddRange({
                New DataGridViewTextBoxColumn With {.Name = "SubRecipeName", .HeaderText = "Sub-Recipe Name", .DataPropertyName = "SubRecipeName", .Width = 300},
                New DataGridViewTextBoxColumn With {.Name = "SKU", .HeaderText = "SKU", .DataPropertyName = "SKU", .Width = 150},
                New DataGridViewTextBoxColumn With {.Name = "BatchSize", .HeaderText = "Batch Size", .DataPropertyName = "BatchSize", .Width = 100, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "N2"}},
                New DataGridViewTextBoxColumn With {.Name = "TotalCost", .HeaderText = "Total Cost", .DataPropertyName = "TotalCost", .Width = 120, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight, .Format = "C2"}},
                New DataGridViewTextBoxColumn With {.Name = "IngredientCount", .HeaderText = "# Ingredients", .DataPropertyName = "IngredientCount", .Width = 110, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleCenter}},
                New DataGridViewTextBoxColumn With {.Name = "CreatedDate", .HeaderText = "Created Date", .DataPropertyName = "CreatedDate", .Width = 130},
                New DataGridViewTextBoxColumn With {.Name = "IsActive", .HeaderText = "Status", .DataPropertyName = "IsActive", .Width = 90}
            })
        End Sub
        
        Private Sub LoadSubRecipesWithRecipes()
            Try
                Using conn As New SqlConnection(connectionString)
                    ' Query to get all sub-recipes that have recipes defined in Demo_SubRecipe_Master
                    Dim sql As String = "
                        SELECT 
                            p.ProductID,
                            srm.SubRecipeID AS BOMID,
                            p.Name AS SubRecipeName,
                            p.SKU,
                            srm.BatchQty AS BatchSize,
                            srm.TotalCost,
                            COUNT(sri.IngredientLineID) AS IngredientCount,
                            CONVERT(VARCHAR(10), srm.CreatedDate, 120) AS CreatedDate,
                            CASE WHEN srm.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS IsActive
                        FROM Demo_Retail_Product p
                        INNER JOIN Demo_SubRecipe_Master srm ON p.ProductID = srm.SubRecipeID
                        LEFT JOIN Demo_SubRecipe_Ingredients sri ON srm.SubRecipeID = sri.SubRecipeID
                        WHERE (p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%')
                          AND p.IsActive = 1
                          AND srm.IsActive = 1
                        GROUP BY p.ProductID, srm.SubRecipeID, p.Name, p.SKU, srm.BatchQty, srm.TotalCost, srm.CreatedDate, srm.IsActive
                        ORDER BY p.Name"
                    
                    Dim cmd As New SqlCommand(sql, conn)
                    conn.Open()
                    
                    Dim dt As New DataTable()
                    dt.Load(cmd.ExecuteReader())
                    
                    ' Bind to grid
                    dgvInventory.DataSource = Nothing
                    dgvInventory.DataSource = dt
                    dgvInventory.Refresh()
                    
                    ' Update summary labels
                    If lblTotalBatches IsNot Nothing Then
                        lblTotalBatches.Text = $"Total Sub-Recipes: {dt.Rows.Count}"
                    End If
                    If lblTotalQuantity IsNot Nothing Then
                        lblTotalQuantity.Text = $"Total Ingredients: {If(dt.Rows.Count > 0, Convert.ToInt32(dt.Compute("SUM(IngredientCount)", "")), 0)}"
                    End If
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading sub-recipes: " & ex.Message & vbCrLf & vbCrLf & ex.StackTrace, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
            LoadSubRecipesWithRecipes()
        End Sub
        
        Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
            Me.Close()
        End Sub
        
        Private Sub dgvInventory_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvInventory.CellContentClick
            ' Handle Edit button click
            If e.RowIndex >= 0 AndAlso e.ColumnIndex = dgvInventory.Columns("Edit").Index Then
                Try
                    Dim row = dgvInventory.Rows(e.RowIndex)
                    Dim productID = Convert.ToInt32(row.Cells("ProductID").Value)
                    Dim subRecipeName = row.Cells("SubRecipeName").Value.ToString()
                    
                    ' Open EditSubRecipeForm with the selected sub-recipe
                    Dim editForm As New EditSubRecipeForm(productID, subRecipeName)
                    editForm.MdiParent = Me.MdiParent
                    editForm.Show()
                    editForm.WindowState = FormWindowState.Maximized
                    
                    ' Refresh the grid after editing
                    AddHandler editForm.FormClosed, Sub(s, ev)
                        LoadSubRecipesWithRecipes()
                    End Sub
                    
                Catch ex As Exception
                    MessageBox.Show("Error opening recipe editor: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        End Sub
    End Class
End Namespace
