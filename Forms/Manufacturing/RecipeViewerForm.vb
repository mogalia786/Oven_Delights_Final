Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Drawing.Printing

Namespace Manufacturing

    Public Class RecipeViewerForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        ' Logo colors
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(230, 126, 34)
        Private ReadOnly ColorDark As Color = Color.FromArgb(110, 44, 0)
        Private ReadOnly ColorLight As Color = Color.FromArgb(245, 222, 179)
        Private ReadOnly ColorAccent As Color = Color.FromArgb(183, 58, 46)

        Private dgvRecipes As DataGridView
        Private btnRefresh As Button

        Public Sub New()
            Me.Text = "Recipe Viewer - Oven Delights"
            Me.Width = 1200
            Me.Height = 700
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.White
            InitializeUI()
            LoadRecipes()
        End Sub

        Private Sub InitializeUI()
            ' Header Panel
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = ColorDark
            }

            Dim lblHeader As New Label() With {
                .Text = "📖 Recipe Viewer",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Left = 30,
                .Top = 25
            }

            Dim lblSubHeader As New Label() With {
                .Text = "View and print all created product recipes",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorLight,
                .AutoSize = True,
                .Left = 30,
                .Top = 52
            }

            btnRefresh = New Button() With {
                .Text = "🔄 Refresh",
                .Left = 1050,
                .Top = 20,
                .Width = 120,
                .Height = 40,
                .BackColor = ColorPrimary,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnRefresh.FlatAppearance.BorderSize = 0
            AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click

            pnlHeader.Controls.AddRange({lblHeader, lblSubHeader, btnRefresh})

            ' DataGridView for recipes
            dgvRecipes = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .ReadOnly = True,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .RowHeadersVisible = False,
                .Font = New Font("Segoe UI", 10),
                .RowTemplate = New DataGridViewRow() With {.Height = 45}
            }

            ' Style the grid
            dgvRecipes.EnableHeadersVisualStyles = False
            dgvRecipes.ColumnHeadersDefaultCellStyle.BackColor = ColorDark
            dgvRecipes.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgvRecipes.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
            dgvRecipes.ColumnHeadersDefaultCellStyle.Padding = New Padding(5)
            dgvRecipes.ColumnHeadersHeight = 45

            dgvRecipes.AlternatingRowsDefaultCellStyle.BackColor = ColorLight
            dgvRecipes.DefaultCellStyle.SelectionBackColor = ColorPrimary
            dgvRecipes.DefaultCellStyle.SelectionForeColor = Color.White

            AddHandler dgvRecipes.CellContentClick, AddressOf DgvRecipes_CellContentClick

            Me.Controls.Add(dgvRecipes)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadRecipes()
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()

                    ' Check if RecipeCreated and ItemType columns exist
                    Dim hasRecipeCreated As Boolean = False
                    Dim hasItemType As Boolean = False

                    Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'RecipeCreated'", con)
                        hasRecipeCreated = Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0
                    End Using

                    Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'ItemType'", con)
                        hasItemType = Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0
                    End Using

                    ' Build SQL - only show products that have recipes in RecipeNode table
                    ' Don't rely on RecipeCreated column as it may contain other data
                    Dim whereClause As String = "WHERE EXISTS(SELECT 1 FROM RecipeNode WHERE ProductID = p.ProductID)"

                    ' Optionally filter by ItemType if it exists (internal = manufactured in-house)
                    If hasItemType Then
                        whereClause &= " AND p.ItemType IN ('internal', 'Manufactured')"
                    End If

                    Dim sql As String = "SELECT p.ProductID, p.ProductName, " &
                                       "ISNULL(p.ProductCode, '') AS ProductCode, " &
                                       "ISNULL(c.CategoryName, '') AS CategoryName, " &
                                       "ISNULL(s.SubcategoryName, '') AS SubcategoryName, " &
                                       "p.CreatedDate, " &
                                       "CASE WHEN EXISTS(SELECT 1 FROM RecipeNode WHERE ProductID = p.ProductID) THEN 'Yes' ELSE 'No' END AS HasRecipe " &
                                       "FROM Products p " &
                                       "LEFT JOIN Categories c ON p.CategoryID = c.CategoryID " &
                                       "LEFT JOIN Subcategories s ON p.SubcategoryID = s.SubcategoryID " &
                                       whereClause & " " &
                                       "ORDER BY p.ProductName"

                    Using cmd As New SqlCommand(sql, con)
                        Dim adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)

                        ' Check if we have data before binding
                        If dt.Rows.Count = 0 Then
                            MessageBox.Show("No recipes found. Create a recipe using 'Build My Product' first.", "No Recipes", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            dgvRecipes.DataSource = Nothing
                            Return
                        End If

                        dgvRecipes.DataSource = dt

                        ' Format columns
                        If dgvRecipes.Columns.Count > 0 Then
                            If dgvRecipes.Columns.Contains("ProductID") Then
                                dgvRecipes.Columns("ProductID").Visible = False
                            End If

                            If dgvRecipes.Columns.Contains("ProductName") Then
                                dgvRecipes.Columns("ProductName").HeaderText = "Product Name"
                                dgvRecipes.Columns("ProductName").Width = 250
                            End If

                            If dgvRecipes.Columns.Contains("ProductCode") Then
                                dgvRecipes.Columns("ProductCode").HeaderText = "Code"
                                dgvRecipes.Columns("ProductCode").Width = 100
                            End If

                            If dgvRecipes.Columns.Contains("CategoryName") Then
                                dgvRecipes.Columns("CategoryName").HeaderText = "Category"
                                dgvRecipes.Columns("CategoryName").Width = 150
                            End If

                            If dgvRecipes.Columns.Contains("SubcategoryName") Then
                                dgvRecipes.Columns("SubcategoryName").HeaderText = "Subcategory"
                                dgvRecipes.Columns("SubcategoryName").Width = 150
                            End If

                            If dgvRecipes.Columns.Contains("CreatedDate") Then
                                dgvRecipes.Columns("CreatedDate").HeaderText = "Created"
                                dgvRecipes.Columns("CreatedDate").Width = 120
                                dgvRecipes.Columns("CreatedDate").DefaultCellStyle.Format = "dd/MM/yyyy"
                            End If

                            If dgvRecipes.Columns.Contains("HasRecipe") Then
                                dgvRecipes.Columns("HasRecipe").HeaderText = "Recipe"
                                dgvRecipes.Columns("HasRecipe").Width = 80
                            End If

                            ' Add print button column
                            Dim btnViewCol As New DataGridViewButtonColumn() With {
                                .Name = "ViewButton",
                                .HeaderText = "View",
                                .Text = "👁 View",
                                .UseColumnTextForButtonValue = True,
                                .Width = 100,
                                .FlatStyle = FlatStyle.Flat
                            }
                            dgvRecipes.Columns.Add(btnViewCol)

                            Dim btnPrintCol As New DataGridViewButtonColumn() With {
                                .Name = "PrintButton",
                                .HeaderText = "Print",
                                .Text = "🖨 Print",
                                .UseColumnTextForButtonValue = True,
                                .Width = 100,
                                .FlatStyle = FlatStyle.Flat
                            }
                            dgvRecipes.Columns.Add(btnPrintCol)
                        End If
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading recipes: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
            LoadRecipes()
        End Sub

        Private Sub DgvRecipes_CellContentClick(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex < 0 Then Return

            Dim productId As Integer = Convert.ToInt32(dgvRecipes.Rows(e.RowIndex).Cells("ProductID").Value)
            Dim productName As String = dgvRecipes.Rows(e.RowIndex).Cells("ProductName").Value.ToString()

            If e.ColumnIndex = dgvRecipes.Columns("ViewButton").Index Then
                ViewRecipe(productId, productName)
            ElseIf e.ColumnIndex = dgvRecipes.Columns("PrintButton").Index Then
                PrintRecipe(productId, productName)
            End If
        End Sub

        Private Sub ViewRecipe(productId As Integer, productName As String)
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()

                    ' Get recipe method
                    Dim recipeMethod As String = ""
                    Using cmd As New SqlCommand("SELECT ISNULL(RecipeMethod, '') FROM Products WHERE ProductID = @id", con)
                        cmd.Parameters.AddWithValue("@id", productId)
                        Dim result = cmd.ExecuteScalar()
                        If result IsNot Nothing Then recipeMethod = result.ToString()
                    End Using

                    ' Get recipe components
                    Dim components As New System.Text.StringBuilder()
                    components.AppendLine($"Recipe for: {productName}")
                    components.AppendLine(New String("="c, 60))
                    components.AppendLine()

                    Dim sql As String = "SELECT Level, NodeKind, ItemType, ItemName, Qty, Notes " &
                                       "FROM RecipeNode " &
                                       "WHERE ProductID = @id " &
                                       "ORDER BY ISNULL(ParentNodeID, 0), SortOrder, NodeID"

                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@id", productId)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                Dim level As Integer = If(IsDBNull(reader("Level")), 0, Convert.ToInt32(reader("Level")))
                                Dim indent As String = New String(" "c, level * 3)
                                Dim itemName As String = If(IsDBNull(reader("ItemName")), "", reader("ItemName").ToString())
                                Dim qty As String = If(IsDBNull(reader("Qty")), "", reader("Qty").ToString())

                                If Not String.IsNullOrEmpty(qty) Then
                                    components.AppendLine($"{indent}• {itemName} - Qty: {qty}")
                                Else
                                    components.AppendLine($"{indent}• {itemName}")
                                End If
                            End While
                        End Using
                    End Using

                    components.AppendLine()
                    components.AppendLine(New String("="c, 60))
                    components.AppendLine("RECIPE METHOD:")
                    components.AppendLine(New String("="c, 60))
                    components.AppendLine(recipeMethod)

                    ' Show in message box
                    Dim viewForm As New Form() With {
                        .Text = $"Recipe: {productName}",
                        .Width = 700,
                        .Height = 600,
                        .StartPosition = FormStartPosition.CenterParent
                    }

                    Dim txtRecipe As New TextBox() With {
                        .Dock = DockStyle.Fill,
                        .Multiline = True,
                        .ScrollBars = ScrollBars.Vertical,
                        .Font = New Font("Consolas", 10),
                        .Text = components.ToString(),
                        .ReadOnly = True,
                        .BackColor = Color.White
                    }

                    viewForm.Controls.Add(txtRecipe)
                    viewForm.ShowDialog()
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error viewing recipe: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub PrintRecipe(productId As Integer, productName As String)
            Try
                Dim recipeText As String = GetRecipeText(productId, productName)

                Dim printDoc As New PrintDocument()
                AddHandler printDoc.PrintPage, Sub(sender, e)
                                                   Dim font As New Font("Arial", 10)
                                                   Dim headerFont As New Font("Arial", 14, FontStyle.Bold)
                                                   Dim y As Single = 50

                                                   ' Print header
                                                   e.Graphics.DrawString($"Recipe: {productName}", headerFont, Brushes.Black, 50, y)
                                                   y += 40
                                                   e.Graphics.DrawString(New String("-"c, 80), font, Brushes.Black, 50, y)
                                                   y += 30

                                                   ' Print recipe text
                                                   Dim lines() As String = recipeText.Split(New String() {Environment.NewLine}, StringSplitOptions.None)
                                                   For Each line In lines
                                                       If y > e.PageBounds.Height - 100 Then Exit For
                                                       e.Graphics.DrawString(line, font, Brushes.Black, 50, y)
                                                       y += 20
                                                   Next
                                               End Sub

                Dim printDialog As New PrintDialog() With {.Document = printDoc}
                If printDialog.ShowDialog() = DialogResult.OK Then
                    printDoc.Print()
                    MessageBox.Show("Recipe sent to printer!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            Catch ex As Exception
                MessageBox.Show($"Error printing recipe: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function GetRecipeText(productId As Integer, productName As String) As String
            Dim result As New System.Text.StringBuilder()

            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()

                    ' Get recipe method
                    Dim recipeMethod As String = ""
                    Using cmd As New SqlCommand("SELECT ISNULL(RecipeMethod, '') FROM Products WHERE ProductID = @id", con)
                        cmd.Parameters.AddWithValue("@id", productId)
                        Dim obj = cmd.ExecuteScalar()
                        If obj IsNot Nothing Then recipeMethod = obj.ToString()
                    End Using

                    result.AppendLine("COMPONENTS:")
                    result.AppendLine()

                    ' Get components
                    Dim sql As String = "SELECT Level, ItemName, Qty FROM RecipeNode WHERE ProductID = @id ORDER BY ISNULL(ParentNodeID, 0), SortOrder"
                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@id", productId)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                Dim level As Integer = If(IsDBNull(reader("Level")), 0, Convert.ToInt32(reader("Level")))
                                Dim indent As String = New String(" "c, level * 2)
                                Dim itemName As String = If(IsDBNull(reader("ItemName")), "", reader("ItemName").ToString())
                                Dim qty As String = If(IsDBNull(reader("Qty")), "", reader("Qty").ToString())

                                If Not String.IsNullOrEmpty(qty) Then
                                    result.AppendLine($"{indent}- {itemName} (Qty: {qty})")
                                Else
                                    result.AppendLine($"{indent}- {itemName}")
                                End If
                            End While
                        End Using
                    End Using

                    result.AppendLine()
                    result.AppendLine("METHOD:")
                    result.AppendLine(recipeMethod)
                End Using
            Catch ex As Exception
                result.AppendLine($"Error: {ex.Message}")
            End Try

            Return result.ToString()
        End Function

    End Class

End Namespace
