Imports System.Data.SqlClient
Imports System.Configuration

Public Class SubRecipeIngredientDialog
    Inherits Form

    Private _subRecipeID As Integer
    Private _subRecipeName As String
    Private _connectionString As String

    Private txtSearch As TextBox
    Private lstIngredients As ListBox
    Private dgvSelected As DataGridView
    Private selectedTable As DataTable
    Private btnAdd As Button
    Private btnOK As Button
    Private btnCancel As Button

    Public Sub New(subRecipeID As Integer, subRecipeName As String, connectionString As String)
        _subRecipeID = subRecipeID
        _subRecipeName = subRecipeName
        _connectionString = connectionString

        Me.Text = $"Add Ingredients for: {subRecipeName}"
        Me.Width = 800
        Me.Height = 600
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False

        InitializeUI()
        LoadIngredients("")
    End Sub

    Private Sub InitializeUI()
        ' Title
        Dim lblTitle As New Label With {
            .Text = $"Build Ingredients for: {_subRecipeName}",
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .Location = New Point(20, 20),
            .AutoSize = True
        }
        Me.Controls.Add(lblTitle)

        ' Search
        Dim lblSearch As New Label With {
            .Text = "Search Ingredients:",
            .Location = New Point(20, 60),
            .AutoSize = True
        }
        Me.Controls.Add(lblSearch)

        txtSearch = New TextBox With {
            .Location = New Point(20, 80),
            .Width = 300,
            .Font = New Font("Segoe UI", 10)
        }
        AddHandler txtSearch.TextChanged, AddressOf OnSearchChanged
        Me.Controls.Add(txtSearch)

        ' Ingredient List
        lstIngredients = New ListBox With {
            .Location = New Point(20, 110),
            .Width = 300,
            .Height = 300,
            .Font = New Font("Segoe UI", 9)
        }
        AddHandler lstIngredients.DoubleClick, AddressOf OnAddClick
        Me.Controls.Add(lstIngredients)

        ' Add Button
        btnAdd = New Button With {
            .Text = "Add →",
            .Location = New Point(330, 250),
            .Width = 100,
            .Height = 40
        }
        AddHandler btnAdd.Click, AddressOf OnAddClick
        Me.Controls.Add(btnAdd)

        ' Selected Grid
        Dim lblSelected As New Label With {
            .Text = "Selected Ingredients:",
            .Location = New Point(450, 60),
            .AutoSize = True
        }
        Me.Controls.Add(lblSelected)

        selectedTable = New DataTable()
        selectedTable.Columns.Add("ProductID", GetType(Integer))
        selectedTable.Columns.Add("ProductName", GetType(String))
        selectedTable.Columns.Add("Quantity", GetType(Decimal))
        selectedTable.Columns.Add("Cost", GetType(Decimal))

        dgvSelected = New DataGridView With {
            .Location = New Point(450, 80),
            .Width = 320,
            .Height = 400,
            .AllowUserToAddRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoGenerateColumns = False
        }
        
        ' Manually create columns
        dgvSelected.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "ProductID",
            .DataPropertyName = "ProductID",
            .Visible = False
        })
        
        dgvSelected.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "ProductName",
            .DataPropertyName = "ProductName",
            .HeaderText = "Ingredient",
            .Width = 150,
            .ReadOnly = True
        })
        
        dgvSelected.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "Quantity",
            .DataPropertyName = "Quantity",
            .HeaderText = "Qty",
            .Width = 70
        })
        
        dgvSelected.Columns.Add(New DataGridViewTextBoxColumn With {
            .Name = "Cost",
            .DataPropertyName = "Cost",
            .HeaderText = "Cost",
            .Width = 70,
            .ReadOnly = True,
            .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}
        })
        
        dgvSelected.DataSource = selectedTable
        Me.Controls.Add(dgvSelected)

        ' Remove Button
        Dim btnRemove As New Button With {
            .Text = "Remove",
            .Location = New Point(450, 490),
            .Width = 100
        }
        AddHandler btnRemove.Click, Sub()
                                         If dgvSelected.SelectedRows.Count > 0 Then
                                             dgvSelected.Rows.Remove(dgvSelected.SelectedRows(0))
                                         End If
                                     End Sub
        Me.Controls.Add(btnRemove)

        ' OK/Cancel
        btnOK = New Button With {
            .Text = "OK",
            .Location = New Point(570, 520),
            .Width = 100,
            .DialogResult = DialogResult.OK
        }
        Me.Controls.Add(btnOK)

        btnCancel = New Button With {
            .Text = "Cancel",
            .Location = New Point(680, 520),
            .Width = 100,
            .DialogResult = DialogResult.Cancel
        }
        Me.Controls.Add(btnCancel)
    End Sub

    Private Sub OnSearchChanged(sender As Object, e As EventArgs)
        LoadIngredients(txtSearch.Text)
    End Sub

    Private Sub LoadIngredients(searchText As String)
        lstIngredients.Items.Clear()
        Dim searchParam = If(String.IsNullOrEmpty(searchText), "%", $"%{searchText}%")

        Try
            Using cn As New SqlConnection(_connectionString)
                cn.Open()
                ' Show ALL active products that can be used as ingredients
                ' Exclude only Internal manufactured products (ProductType = 'Internal')
                ' Get ProductID and CostPrice from Demo_Retail_Price for current branch
                ' Use DISTINCT on Name to avoid duplicates across branches
                Dim branchId As Integer = If(AppSession.CurrentUser?.BranchID, 1)
                Dim query = "SELECT MIN(p.ProductID) AS ProductID, p.Name AS ProductName, " &
                           "MIN(ISNULL(p.Code, p.SKU)) AS ProductCode, " &
                           "ISNULL((SELECT TOP 1 CostPrice FROM Demo_Retail_Price " &
                           "WHERE ProductID = MIN(p.ProductID) AND BranchID = @BranchID " &
                           "ORDER BY EffectiveFrom DESC), 0) AS Cost " &
                           "FROM Demo_Retail_Product p " &
                           "WHERE (p.Name LIKE @search OR ISNULL(p.Code, p.SKU) LIKE @search) " &
                           "  AND p.IsActive = 1 " &
                           "  AND (p.ProductType <> 'Internal' OR p.ProductType IS NULL) " &
                           "GROUP BY p.Name " &
                           "ORDER BY p.Name"
                Using cmd As New SqlCommand(query, cn)
                    cmd.Parameters.AddWithValue("@search", searchParam)
                    cmd.Parameters.AddWithValue("@BranchID", branchId)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            lstIngredients.Items.Add(New With {
                                .ProductID = reader.GetInt32(0),
                                .ProductCode = If(reader.IsDBNull(2), "", reader.GetString(2)),
                                .ProductName = reader.GetString(1),
                                .Cost = reader.GetDecimal(3),
                                .Display = reader.GetString(1)
                            })
                        End While
                    End Using
                End Using
            End Using

            If lstIngredients.Items.Count > 0 Then
                lstIngredients.DisplayMember = "Display"
            End If
        Catch ex As Exception
            MessageBox.Show($"Error loading ingredients: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnAddClick(sender As Object, e As EventArgs)
        If lstIngredients.SelectedItem Is Nothing Then Return

        Dim selected = lstIngredients.SelectedItem

        ' Ask for quantity
        Dim qtyInput = InputBox($"Enter quantity for {selected.ProductName}:", "Quantity", "1")
        If String.IsNullOrEmpty(qtyInput) Then Return

        Dim qty As Decimal
        If Not Decimal.TryParse(qtyInput, qty) OrElse qty <= 0 Then
            MessageBox.Show("Please enter a valid quantity.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Dim row = selectedTable.NewRow()
        row("ProductID") = selected.ProductID
        row("ProductName") = selected.ProductName
        row("Quantity") = qty
        row("Cost") = selected.Cost
        selectedTable.Rows.Add(row)
    End Sub

    Public Function GetIngredients() As List(Of IngredientItem)
        Dim ingredients As New List(Of IngredientItem)
        For Each row As DataRow In selectedTable.Rows
            ingredients.Add(New IngredientItem With {
                .ProductID = Convert.ToInt32(row("ProductID")),
                .ProductName = row("ProductName").ToString(),
                .Quantity = Convert.ToDecimal(row("Quantity")),
                .Cost = Convert.ToDecimal(row("Cost"))
            })
        Next
        Return ingredients
    End Function

    Public Class IngredientItem
        Public Property ProductID As Integer
        Public Property ProductName As String
        Public Property Quantity As Decimal
        Public Property Cost As Decimal
    End Class
End Class
