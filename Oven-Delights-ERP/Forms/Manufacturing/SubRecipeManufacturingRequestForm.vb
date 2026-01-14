Imports System.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing
    Public Class SubRecipeManufacturingRequestForm
        Private connectionString As String
        Private currentRequestID As Integer = 0
        Private currentBranchID As Integer = 0
        Private currentUserName As String = ""

        Public Sub New()
            InitializeComponent()
            
            Try
                connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Catch ex As Exception
                MessageBox.Show("Error initializing connection: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                connectionString = ""
            End Try
        End Sub

        Private Sub SubRecipeManufacturingRequestForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
            Try
                If AppSession.CurrentUser Is Nothing Then
                    MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Me.Close()
                    Return
                End If
                
                currentUserName = AppSession.CurrentUser.Username
                currentBranchID = AppSession.CurrentUser.BranchID
                
                SetupUI()
                LoadBakers()
                LoadSubRecipes()
                LoadDraftRequests()
                
                If dtpOrderDate IsNot Nothing Then
                    dtpOrderDate.Value = DateTime.Today
                End If
                
                If dtpRequiredDate IsNot Nothing Then
                    dtpRequiredDate.Value = DateTime.Today.AddDays(1)
                End If
                
                EnableEditMode(False)
                
            Catch ex As Exception
                MessageBox.Show("Error loading form: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub SetupUI()
            dgvDraftRequests.AutoGenerateColumns = False
            dgvDraftRequests.Columns.Clear()
            dgvDraftRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ReOrderBookID", .DataPropertyName = "ReOrderBookID", .Visible = False})
            dgvDraftRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ReOrderNumber", .HeaderText = "Request #", .DataPropertyName = "ReOrderNumber", .Width = 150})
            dgvDraftRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ManufacturerName", .HeaderText = "Baker", .DataPropertyName = "ManufacturerName", .Width = 120})
            dgvDraftRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "OrderDate", .HeaderText = "Date", .DataPropertyName = "OrderDate", .Width = 100, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "dd/MM/yyyy"}})
            dgvDraftRequests.Columns.Add(New DataGridViewCheckBoxColumn With {.Name = "IsUrgent", .HeaderText = "Urgent", .DataPropertyName = "IsUrgent", .Width = 60})
            dgvDraftRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalProducts", .HeaderText = "Sub-Recipes", .DataPropertyName = "TotalProducts", .Width = 80})
            dgvDraftRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalQuantity", .HeaderText = "Qty", .DataPropertyName = "TotalQuantity", .Width = 80})
            
            dgvSubRecipeLines.AutoGenerateColumns = False
            dgvSubRecipeLines.Columns.Clear()
            dgvSubRecipeLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ReOrderLineID", .DataPropertyName = "ReOrderLineID", .Visible = False})
            dgvSubRecipeLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LineNumber", .HeaderText = "#", .DataPropertyName = "LineNumber", .Width = 40})
            dgvSubRecipeLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductName", .HeaderText = "Sub-Recipe", .DataPropertyName = "ProductName", .Width = 250})
            dgvSubRecipeLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "QuantityOrdered", .HeaderText = "Quantity", .DataPropertyName = "QuantityOrdered", .Width = 80})
            dgvSubRecipeLines.Columns.Add(New DataGridViewButtonColumn With {.Name = "Remove", .HeaderText = "", .Text = "Remove", .UseColumnTextForButtonValue = True, .Width = 80})
        End Sub

        Private Sub LoadBakers()
            Try
                Using conn As New SqlConnection(connectionString)
                    Dim cmd As New SqlCommand("SELECT UserID, FirstName + ' ' + LastName AS FullName FROM Users WHERE RoleID IN (SELECT RoleID FROM Roles WHERE RoleName = 'Manufacturer') AND IsActive = 1 AND BranchID = @BranchID ORDER BY FirstName", conn)
                    cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                    conn.Open()
                    
                    Dim dt As New DataTable()
                    dt.Load(cmd.ExecuteReader())
                    
                    cmbBaker.DisplayMember = "FullName"
                    cmbBaker.ValueMember = "UserID"
                    cmbBaker.DataSource = dt
                    cmbBaker.SelectedIndex = -1
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading bakers: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadSubRecipes()
            Try
                Using conn As New SqlConnection(connectionString)
                    Dim sql As String = "SELECT srm.SubRecipeID, p.Name AS SubRecipeName " &
                                       "FROM Demo_SubRecipe_Master srm " &
                                       "INNER JOIN Demo_Retail_Product p ON srm.SubRecipeID = p.ProductID " &
                                       "WHERE srm.IsActive = 1 " &
                                       "ORDER BY p.Name"
                    
                    Dim cmd As New SqlCommand(sql, conn)
                    conn.Open()
                    
                    Dim dt As New DataTable()
                    dt.Load(cmd.ExecuteReader())
                    
                    cmbSubRecipe.DisplayMember = "SubRecipeName"
                    cmbSubRecipe.ValueMember = "SubRecipeID"
                    cmbSubRecipe.DataSource = dt
                    cmbSubRecipe.SelectedIndex = -1
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading sub-recipes: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadDraftRequests()
            Try
                Using conn As New SqlConnection(connectionString)
                    Dim cmd As New SqlCommand("sp_GetDraftReOrderBooks", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                    
                    conn.Open()
                    Dim dt As New DataTable()
                    dt.Load(cmd.ExecuteReader())
                    
                    dgvDraftRequests.DataSource = dt
                    lblDraftCount.Text = $"Draft Requests: {dt.Rows.Count}"
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading drafts: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnNewRequest_Click(sender As Object, e As EventArgs) Handles btnNewRequest.Click
            If cmbBaker.SelectedIndex = -1 Then
                MessageBox.Show("Please select a baker", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Try
                Using conn As New SqlConnection(connectionString)
                    Dim cmd As New SqlCommand("sp_CreateReOrderBook", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    
                    cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                    cmd.Parameters.AddWithValue("@ManufacturerUserID", cmbBaker.SelectedValue)
                    cmd.Parameters.AddWithValue("@OrderDate", dtpOrderDate.Value.Date)
                    cmd.Parameters.AddWithValue("@RequiredDate", dtpRequiredDate.Value.Date)
                    cmd.Parameters.AddWithValue("@CreatedBy", currentUserName)
                    cmd.Parameters.AddWithValue("@IsUrgent", chkUrgent.Checked)
                    cmd.Parameters.AddWithValue("@Notes", txtNotes.Text)
                    
                    Dim pRequestID As New SqlParameter("@ReOrderBookID", SqlDbType.Int) With {.Direction = ParameterDirection.Output}
                    Dim pRequestNumber As New SqlParameter("@ReOrderNumber", SqlDbType.NVarChar, 50) With {.Direction = ParameterDirection.Output}
                    cmd.Parameters.Add(pRequestID)
                    cmd.Parameters.Add(pRequestNumber)
                    
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    
                    currentRequestID = CInt(pRequestID.Value)
                    txtRequestNumber.Text = pRequestNumber.Value.ToString()
                    
                    EnableEditMode(True)
                    LoadDraftRequests()
                    
                    MessageBox.Show($"Sub-Recipe Request created: {txtRequestNumber.Text}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End Using
            Catch ex As Exception
                MessageBox.Show("Error creating request: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnAddSubRecipe_Click(sender As Object, e As EventArgs) Handles btnAddSubRecipe.Click
            If currentRequestID = 0 Then
                MessageBox.Show("Please create a request first", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If cmbSubRecipe.SelectedIndex = -1 OrElse nudQuantity.Value <= 0 Then
                MessageBox.Show("Please select a sub-recipe and enter quantity", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Try
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    
                    Dim cmdLineNum As New SqlCommand("SELECT ISNULL(MAX(LineNumber), 0) + 1 FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID", conn)
                    cmdLineNum.Parameters.AddWithValue("@ReOrderBookID", currentRequestID)
                    Dim lineNumber = Convert.ToInt32(cmdLineNum.ExecuteScalar())
                    
                    Dim selectedRow = CType(cmbSubRecipe.SelectedItem, DataRowView)
                    Dim subRecipeID As Integer = Convert.ToInt32(cmbSubRecipe.SelectedValue)
                    Dim subRecipeName As String = selectedRow("SubRecipeName").ToString()
                    
                    Dim cmdInsert As New SqlCommand(
                        "INSERT INTO ReOrderBookLines (ReOrderBookID, ProductID, ProductName, Barcode, LineNumber, QuantityOrdered, UnitOfMeasure, ItemType, Notes) " &
                        "VALUES (@ReOrderBookID, @SubRecipeID, @SubRecipeName, @Barcode, @LineNumber, @QuantityOrdered, @UnitOfMeasure, @ItemType, @Notes)", conn)
                    cmdInsert.Parameters.AddWithValue("@ReOrderBookID", currentRequestID)
                    cmdInsert.Parameters.AddWithValue("@SubRecipeID", subRecipeID)
                    cmdInsert.Parameters.AddWithValue("@SubRecipeName", subRecipeName)
                    cmdInsert.Parameters.AddWithValue("@Barcode", "SR-" & subRecipeID.ToString())
                    cmdInsert.Parameters.AddWithValue("@LineNumber", lineNumber)
                    cmdInsert.Parameters.AddWithValue("@QuantityOrdered", nudQuantity.Value)
                    cmdInsert.Parameters.AddWithValue("@UnitOfMeasure", "Batch")
                    cmdInsert.Parameters.AddWithValue("@ItemType", "SubRecipe")
                    cmdInsert.Parameters.AddWithValue("@Notes", "Sub-Recipe for preparation")
                    cmdInsert.ExecuteNonQuery()
                    
                    LoadRequestDetails(currentRequestID)
                    LoadDraftRequests()
                    
                    cmbSubRecipe.SelectedIndex = -1
                    nudQuantity.Value = 1
                    
                End Using
            Catch ex As Exception
                MessageBox.Show("Error adding sub-recipe: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadRequestDetails(requestID As Integer)
            Try
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    
                    Dim cmdHeader As New SqlCommand(
                        "SELECT rb.ReOrderNumber, u.FirstName + ' ' + u.LastName AS ManufacturerName, " &
                        "COUNT(rbl.ReOrderLineID) AS TotalProducts, SUM(rbl.QuantityOrdered) AS TotalQuantity " &
                        "FROM ReOrderBooks rb " &
                        "LEFT JOIN Users u ON rb.ManufacturerUserID = u.UserID " &
                        "LEFT JOIN ReOrderBookLines rbl ON rb.ReOrderBookID = rbl.ReOrderBookID " &
                        "WHERE rb.ReOrderBookID = @ReOrderBookID " &
                        "GROUP BY rb.ReOrderNumber, u.FirstName, u.LastName", conn)
                    cmdHeader.Parameters.AddWithValue("@ReOrderBookID", requestID)
                    
                    Dim reader = cmdHeader.ExecuteReader()
                    If reader.Read() Then
                        txtRequestNumber.Text = If(reader("ReOrderNumber"), "").ToString()
                        lblBakerName.Text = "Baker: " & If(reader("ManufacturerName"), "").ToString()
                        lblTotalSubRecipes.Text = "Sub-Recipes: " & If(reader("TotalProducts"), 0).ToString()
                        lblTotalQuantity.Text = "Total Qty: " & If(reader("TotalQuantity"), 0).ToString()
                    End If
                    reader.Close()
                    
                    Dim cmdLines As New SqlCommand(
                        "SELECT rbl.ReOrderLineID, rbl.LineNumber, rbl.ProductName, rbl.QuantityOrdered, p.SKU " &
                        "FROM ReOrderBookLines rbl " &
                        "LEFT JOIN Demo_Retail_Product p ON rbl.ProductID = p.ProductID " &
                        "WHERE rbl.ReOrderBookID = @ReOrderBookID " &
                        "ORDER BY rbl.LineNumber", conn)
                    cmdLines.Parameters.AddWithValue("@ReOrderBookID", requestID)
                    
                    Dim dtLines As New DataTable()
                    dtLines.Load(cmdLines.ExecuteReader())
                    dgvSubRecipeLines.DataSource = dtLines
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading request details: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnPost_Click(sender As Object, e As EventArgs) Handles btnPost.Click
            If currentRequestID = 0 Then
                MessageBox.Show("No request to post", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Try
                Using conn As New SqlConnection(connectionString)
                    Dim cmd As New SqlCommand("UPDATE ReOrderBooks SET Status = 'Posted', PostedDate = GETDATE(), PostedBy = @PostedBy WHERE ReOrderBookID = @ReOrderBookID", conn)
                    cmd.Parameters.AddWithValue("@ReOrderBookID", currentRequestID)
                    cmd.Parameters.AddWithValue("@PostedBy", AppSession.CurrentUser.UserID)
                    
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    
                    MessageBox.Show("Request posted to Baker Dashboard successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    
                    ResetForm()
                    LoadDraftRequests()
                End Using
            Catch ex As Exception
                MessageBox.Show("Error posting request: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub EnableEditMode(enabled As Boolean)
            If grpSubRecipes IsNot Nothing Then
                grpSubRecipes.Enabled = enabled
            End If
            If btnPost IsNot Nothing Then
                btnPost.Enabled = enabled
            End If
        End Sub

        Private Sub ResetForm()
            currentRequestID = 0
            If txtRequestNumber IsNot Nothing Then txtRequestNumber.Text = ""
            If lblBakerName IsNot Nothing Then lblBakerName.Text = "Baker: -"
            If lblTotalSubRecipes IsNot Nothing Then lblTotalSubRecipes.Text = "Sub-Recipes: 0"
            If lblTotalQuantity IsNot Nothing Then lblTotalQuantity.Text = "Total Qty: 0"
            If dgvSubRecipeLines IsNot Nothing Then dgvSubRecipeLines.DataSource = Nothing
            If cmbBaker IsNot Nothing Then cmbBaker.SelectedIndex = -1
            If cmbSubRecipe IsNot Nothing Then cmbSubRecipe.SelectedIndex = -1
            If nudQuantity IsNot Nothing Then nudQuantity.Value = 1
            If txtNotes IsNot Nothing Then txtNotes.Text = ""
            If chkUrgent IsNot Nothing Then chkUrgent.Checked = False
            EnableEditMode(False)
        End Sub

        Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
            Me.Close()
        End Sub

        Private Sub dgvDraftRequests_CellClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvDraftRequests.CellClick
            If e.RowIndex >= 0 Then
                Dim requestID As Integer = Convert.ToInt32(dgvDraftRequests.Rows(e.RowIndex).Cells("ReOrderBookID").Value)
                currentRequestID = requestID
                LoadRequestDetails(requestID)
                EnableEditMode(True)
            End If
        End Sub
    End Class
End Namespace
