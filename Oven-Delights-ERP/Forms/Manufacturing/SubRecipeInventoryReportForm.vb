Imports System.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing
    Public Class SubRecipeInventoryReportForm
        Inherits Form
        
        Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private currentBranchID As Integer = 0
        
        Public Sub New()
            InitializeComponent()
            
            ' Configure DataGridView for better appearance
            ConfigureDataGridView()
            
            ' Hide only the Freshness dropdown and Export button (keep Branch and Sub-Recipe filters)
            If cmbFreshness IsNot Nothing Then
                cmbFreshness.Visible = False
                If Label4 IsNot Nothing Then Label4.Visible = False
            End If
            If btnExport IsNot Nothing Then
                btnExport.Visible = False
            End If
            
            ' Load data
            If AppSession.CurrentUser IsNot Nothing Then
                currentBranchID = AppSession.CurrentUser.BranchID
            End If
            
            LoadBranches()
            LoadSubRecipes()
            LoadInventoryReport()
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
            dgvInventory.RowTemplate.Height = 35
            
            ' Header styling
            dgvInventory.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(52, 73, 94)
            dgvInventory.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgvInventory.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
            dgvInventory.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
            dgvInventory.ColumnHeadersDefaultCellStyle.Padding = New Padding(5)
            
            ' Alternating row colors
            dgvInventory.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 245, 245)
            dgvInventory.DefaultCellStyle.SelectionBackColor = Color.FromArgb(52, 152, 219)
            dgvInventory.DefaultCellStyle.SelectionForeColor = Color.White
            dgvInventory.DefaultCellStyle.Font = New Font("Segoe UI", 9)
            dgvInventory.DefaultCellStyle.Padding = New Padding(5)
            
            ' Clear existing columns and add new ones
            dgvInventory.Columns.Clear()
            dgvInventory.Columns.AddRange({
                New DataGridViewTextBoxColumn With {.Name = "BatchNumber", .HeaderText = "Batch Number", .DataPropertyName = "BatchNumber", .Width = 180},
                New DataGridViewTextBoxColumn With {.Name = "SubRecipeName", .HeaderText = "Sub-Recipe", .DataPropertyName = "SubRecipeName", .Width = 200},
                New DataGridViewTextBoxColumn With {.Name = "Quantity", .HeaderText = "Qty", .DataPropertyName = "Quantity", .Width = 80, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight}},
                New DataGridViewTextBoxColumn With {.Name = "UnitOfMeasure", .HeaderText = "Unit", .DataPropertyName = "UnitOfMeasure", .Width = 80},
                New DataGridViewTextBoxColumn With {.Name = "ManufacturedDateFormatted", .HeaderText = "Manufactured Date", .DataPropertyName = "ManufacturedDateFormatted", .Width = 130},
                New DataGridViewTextBoxColumn With {.Name = "ManufacturedTimeFormatted", .HeaderText = "Time", .DataPropertyName = "ManufacturedTimeFormatted", .Width = 90},
                New DataGridViewTextBoxColumn With {.Name = "AgeInHours", .HeaderText = "Age (Hours)", .DataPropertyName = "AgeInHours", .Width = 100, .DefaultCellStyle = New DataGridViewCellStyle With {.Alignment = DataGridViewContentAlignment.MiddleRight}},
                New DataGridViewTextBoxColumn With {.Name = "FreshnessLevel", .HeaderText = "Freshness", .DataPropertyName = "FreshnessLevel", .Width = 100},
                New DataGridViewTextBoxColumn With {.Name = "BranchName", .HeaderText = "Branch", .DataPropertyName = "BranchName", .Width = 120},
                New DataGridViewTextBoxColumn With {.Name = "BakerName", .HeaderText = "Baker", .DataPropertyName = "BakerName", .Width = 150}
            })
        End Sub
        
        Private Sub LoadBranches()
            Try
                Using conn As New SqlConnection(connectionString)
                    Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                    Dim cmd As New SqlCommand(sql, conn)
                    conn.Open()
                    
                    Dim dt As New DataTable()
                    dt.Load(cmd.ExecuteReader())
                    
                    ' Add "All Branches" option if Head Office
                    If currentBranchID = 0 Then
                        Dim allRow = dt.NewRow()
                        allRow("BranchID") = DBNull.Value
                        allRow("BranchName") = "All Branches"
                        dt.Rows.InsertAt(allRow, 0)
                    End If
                    
                    cmbBranch.DisplayMember = "BranchName"
                    cmbBranch.ValueMember = "BranchID"
                    cmbBranch.DataSource = dt
                    
                    If currentBranchID > 0 Then
                        cmbBranch.SelectedValue = currentBranchID
                        cmbBranch.Enabled = False
                    End If
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading branches: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub LoadSubRecipes()
            Try
                Using conn As New SqlConnection(connectionString)
                    ' Load sub-recipes from inventory (distinct list of what's actually in stock)
                    Dim sql = "SELECT DISTINCT sri.SubRecipeID, sri.SubRecipeName " &
                              "FROM Demo_SubRecipe_Inventory sri " &
                              "WHERE sri.Status = 'Available' " &
                              "ORDER BY sri.SubRecipeName"
                    Dim cmd As New SqlCommand(sql, conn)
                    conn.Open()
                    
                    Dim dt As New DataTable()
                    dt.Load(cmd.ExecuteReader())
                    
                    ' Allow SubRecipeID column to accept nulls for "All" option
                    If dt.Columns.Contains("SubRecipeID") Then
                        dt.Columns("SubRecipeID").AllowDBNull = True
                    End If
                    
                    ' Add "All Sub-Recipes" option
                    Dim allRow = dt.NewRow()
                    allRow("SubRecipeID") = DBNull.Value
                    allRow("SubRecipeName") = "All Sub-Recipes"
                    dt.Rows.InsertAt(allRow, 0)
                    
                    cmbSubRecipe.DisplayMember = "SubRecipeName"
                    cmbSubRecipe.ValueMember = "SubRecipeID"
                    cmbSubRecipe.DataSource = dt
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading sub-recipes: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub LoadInventoryReport()
            Try
                Using conn As New SqlConnection(connectionString)
                    Dim cmd As New SqlCommand("sp_GetSubRecipeInventoryReport", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    
                    ' Branch filter
                    If cmbBranch.SelectedValue IsNot Nothing AndAlso Not IsDBNull(cmbBranch.SelectedValue) Then
                        cmd.Parameters.AddWithValue("@BranchID", cmbBranch.SelectedValue)
                    Else
                        cmd.Parameters.AddWithValue("@BranchID", DBNull.Value)
                    End If
                    
                    ' Sub-recipe filter
                    If cmbSubRecipe.SelectedValue IsNot Nothing AndAlso Not IsDBNull(cmbSubRecipe.SelectedValue) Then
                        cmd.Parameters.AddWithValue("@SubRecipeID", cmbSubRecipe.SelectedValue)
                    Else
                        cmd.Parameters.AddWithValue("@SubRecipeID", DBNull.Value)
                    End If
                    
                    cmd.Parameters.AddWithValue("@FreshnessFilter", DBNull.Value)
                    
                    conn.Open()
                    Dim dt As New DataTable()
                    dt.Load(cmd.ExecuteReader())
                    
                    ' Clear existing data source
                    dgvInventory.DataSource = Nothing
                    dgvInventory.DataSource = dt
                    dgvInventory.Refresh()
                    
                    ' Apply freshness color coding to entire rows
                    Application.DoEvents()
                    
                    For Each row As DataGridViewRow In dgvInventory.Rows
                        If row.DataBoundItem IsNot Nothing Then
                            Try
                                Dim drv = CType(row.DataBoundItem, DataRowView)
                                If drv.Row.Table.Columns.Contains("FreshnessLevel") AndAlso Not IsDBNull(drv("FreshnessLevel")) Then
                                    Dim freshness = drv("FreshnessLevel").ToString()
                                    Dim backColor As Color
                                    Dim foreColor As Color = Color.Black
                                    
                                    ' Apply color based on freshness level
                                    Select Case freshness
                                        Case "Very Fresh"
                                            backColor = Color.FromArgb(200, 255, 200) ' Light green
                                        Case "Fresh"
                                            backColor = Color.FromArgb(220, 255, 220) ' Very light green
                                        Case "Good"
                                            backColor = Color.FromArgb(255, 255, 200) ' Light yellow
                                        Case "Aging"
                                            backColor = Color.FromArgb(255, 230, 150) ' Light orange
                                        Case "Old"
                                            backColor = Color.FromArgb(255, 200, 150) ' Orange
                                            foreColor = Color.DarkRed
                                        Case "Very Old"
                                            backColor = Color.FromArgb(255, 180, 180) ' Light red
                                            foreColor = Color.DarkRed
                                        Case Else
                                            backColor = Color.White
                                    End Select
                                    
                                    row.DefaultCellStyle.BackColor = backColor
                                    row.DefaultCellStyle.ForeColor = foreColor
                                    row.DefaultCellStyle.SelectionBackColor = Color.FromArgb(52, 152, 219)
                                    row.DefaultCellStyle.SelectionForeColor = Color.White
                                End If
                            Catch colorEx As Exception
                                ' Skip color coding if there's an error
                            End Try
                        End If
                    Next
                    
                    lblTotalBatches.Text = $"Total Batches: {dt.Rows.Count}"
                    Dim totalQty As Decimal = If(dt.Rows.Count > 0, Convert.ToDecimal(dt.Compute("SUM(Quantity)", "")), 0)
                    lblTotalQuantity.Text = $"Total Quantity: {totalQty:N2}"
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading inventory report: " & ex.Message & vbCrLf & vbCrLf & ex.StackTrace, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
            LoadInventoryReport()
        End Sub
        
        Private Sub cmbBranch_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cmbBranch.SelectedIndexChanged
            LoadInventoryReport()
        End Sub
        
        Private Sub cmbSubRecipe_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cmbSubRecipe.SelectedIndexChanged
            LoadInventoryReport()
        End Sub
        
        Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
            Me.Close()
        End Sub
    End Class
End Namespace
