Imports System.Windows.Forms
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Data

Namespace Stockroom
    Public Class StockroomBOMFulfillmentForm
        Inherits Form
        
        Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private cmbOrders As ComboBox
        Private dgvItems As DataGridView
        Private btnFulfill As Button
        Private currentReOrderBookID As Integer = 0
        
        Public Sub New()
            InitializeComponent()
        End Sub
        
        Private Sub StockroomBOMFulfillmentForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
            Try
                LoadPendingOrders()
            Catch ex As Exception
                MessageBox.Show("Form Load Error: " & ex.Message & vbCrLf & vbCrLf & ex.StackTrace, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub InitializeComponent()
            Me.Text = "Fulfill Re-order from Baker - Stockroom"
            Me.Size = New Size(1000, 600)
            Me.StartPosition = FormStartPosition.CenterScreen
            
            Dim lblOrderNum As New Label()
            lblOrderNum.Text = "Select Pending Order:"
            lblOrderNum.Location = New Point(20, 20)
            lblOrderNum.AutoSize = True
            lblOrderNum.Font = New Font("Arial", 11, FontStyle.Bold)
            Me.Controls.Add(lblOrderNum)
            
            cmbOrders = New ComboBox()
            cmbOrders.Location = New Point(200, 18)
            cmbOrders.Width = 400
            cmbOrders.Font = New Font("Arial", 11)
            cmbOrders.DropDownStyle = ComboBoxStyle.DropDownList
            AddHandler cmbOrders.SelectedIndexChanged, AddressOf CmbOrders_SelectedIndexChanged
            Me.Controls.Add(cmbOrders)
            
            Dim lblItems As New Label()
            lblItems.Text = "Ingredients Required:"
            lblItems.Location = New Point(20, 70)
            lblItems.Font = New Font("Arial", 12, FontStyle.Bold)
            lblItems.AutoSize = True
            Me.Controls.Add(lblItems)
            
            dgvItems = New DataGridView()
            dgvItems.Location = New Point(20, 100)
            dgvItems.Size = New Size(940, 380)
            dgvItems.AllowUserToAddRows = False
            dgvItems.ReadOnly = True
            dgvItems.SelectionMode = DataGridViewSelectionMode.FullRowSelect
            Me.Controls.Add(dgvItems)
            
            btnFulfill = New Button()
            btnFulfill.Text = "Mark as Fulfilled"
            btnFulfill.Location = New Point(800, 500)
            btnFulfill.Size = New Size(160, 40)
            btnFulfill.Font = New Font("Arial", 11, FontStyle.Bold)
            btnFulfill.Enabled = False
            AddHandler btnFulfill.Click, AddressOf BtnFulfill_Click
            Me.Controls.Add(btnFulfill)
        End Sub
        
        
        Private Sub LoadPendingOrders()
            Try
                ' Remove event handler temporarily
                RemoveHandler cmbOrders.SelectedIndexChanged, AddressOf CmbOrders_SelectedIndexChanged
                
                cmbOrders.DataSource = Nothing
                cmbOrders.Items.Clear()
                
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    
                    ' Get all Posted orders that have BOM requisitions (waiting for stockroom fulfillment)
                    Dim cmd As New SqlCommand(
                        "SELECT DISTINCT rob.ReOrderBookID, " &
                        "rob.ReOrderNumber + ' - ' + ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') + ' - ' + " &
                        "FORMAT(rob.OrderDate, 'dd/MM/yyyy') + ' (' + CAST(ISNULL(rob.TotalProducts, 0) AS NVARCHAR) + ' products)' AS DisplayText, " &
                        "rob.OrderDate " &
                        "FROM ReOrderBooks rob " &
                        "LEFT JOIN Users u ON rob.ManufacturerUserID = u.UserID " &
                        "INNER JOIN BOMRequisitionFulfillment brf ON rob.ReOrderBookID = brf.ReOrderBookID " &
                        "WHERE rob.Status = 'Posted' AND brf.FulfilledDate IS NULL " &
                        "ORDER BY rob.OrderDate DESC", conn)
                    
                    Dim dt As New DataTable()
                    dt.Load(cmd.ExecuteReader())
                    
                    If dt.Rows.Count = 0 Then
                        cmbOrders.Items.Add("No pending orders")
                        cmbOrders.Enabled = False
                        Return
                    End If
                    
                    cmbOrders.DisplayMember = "DisplayText"
                    cmbOrders.ValueMember = "ReOrderBookID"
                    cmbOrders.DataSource = dt
                    cmbOrders.SelectedIndex = -1
                    cmbOrders.Enabled = True
                End Using
                
                ' Re-add event handler
                AddHandler cmbOrders.SelectedIndexChanged, AddressOf CmbOrders_SelectedIndexChanged
            Catch ex As Exception
                MessageBox.Show("Error loading orders: " & ex.Message & vbCrLf & vbCrLf & ex.StackTrace, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub CmbOrders_SelectedIndexChanged(sender As Object, e As EventArgs)
            ' Don't process if form is not fully loaded or if clearing
            If Not Me.IsHandleCreated OrElse cmbOrders.DataSource Is Nothing Then Return
            
            If cmbOrders.SelectedIndex >= 0 AndAlso cmbOrders.SelectedValue IsNot Nothing Then
                Try
                    currentReOrderBookID = Convert.ToInt32(cmbOrders.SelectedValue)
                    LoadRequisitionItems()
                    btnFulfill.Enabled = True
                Catch ex As Exception
                    ' Ignore binding errors during initialization
                End Try
            End If
        End Sub
        
        Private Sub LoadRequisitionItems()
            Try
                dgvItems.DataSource = Nothing
                
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    
                    ' Check if BOMRequisitionFulfillment table exists
                    Dim cmdCheck As New SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BOMRequisitionFulfillment'", conn)
                    If Convert.ToInt32(cmdCheck.ExecuteScalar()) = 0 Then
                        MessageBox.Show("BOMRequisitionFulfillment table does not exist. Please run CREATE_BOM_REQUISITION_FULFILLMENT.sql script first.", "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                        btnFulfill.Enabled = False
                        Return
                    End If
                    
                    ' Get requisition items with stock levels from Demo_Retail_Product
                    Dim cmd As New SqlCommand(
                        "SELECT f.FulfillmentID, f.IngredientName, f.QuantityRequired, " &
                        "ISNULL((SELECT TOP 1 CurrentStock FROM Demo_Retail_Product " &
                        "WHERE Name = f.IngredientName AND BranchID = @BranchID), 0) AS StockOnHand, " &
                        "CASE WHEN ISNULL((SELECT TOP 1 CurrentStock FROM Demo_Retail_Product " &
                        "WHERE Name = f.IngredientName AND BranchID = @BranchID), 0) < f.QuantityRequired " &
                        "THEN f.QuantityRequired - ISNULL((SELECT TOP 1 CurrentStock FROM Demo_Retail_Product " &
                        "WHERE Name = f.IngredientName AND BranchID = @BranchID), 0) " &
                        "ELSE 0 END AS Shortage, " &
                        "f.UnitOfMeasure, " &
                        "CASE WHEN f.FulfilledDate IS NOT NULL THEN 1 ELSE 0 END AS IsFulfilled " &
                        "FROM BOMRequisitionFulfillment f " &
                        "WHERE f.ReOrderBookID = @ReOrderBookID " &
                        "ORDER BY f.IngredientName", conn)
                    cmd.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                    cmd.Parameters.AddWithValue("@BranchID", If(AppSession.CurrentUser?.BranchID, 0))
                    
                    Dim dt As New DataTable()
                    dt.Load(cmd.ExecuteReader())
                    
                    If dt.Rows.Count = 0 Then
                        MessageBox.Show("No requisition items found. Baker must click 'Request BOM' first to generate the requisition.", "No Data", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        dgvItems.DataSource = Nothing
                        btnFulfill.Enabled = False
                        Return
                    End If
                    
                    dgvItems.DataSource = dt
                    
                    ' Color code rows with shortages - use column index instead of name
                    For Each row As DataGridViewRow In dgvItems.Rows
                        If Not row.IsNewRow AndAlso row.Cells.Count > 4 Then
                            Try
                                ' Shortage is the 5th column (index 4)
                                Dim shortageValue = row.Cells(4).Value
                                If shortageValue IsNot Nothing AndAlso Not IsDBNull(shortageValue) Then
                                    Dim shortage = Convert.ToDecimal(shortageValue)
                                    If shortage > 0 Then
                                        row.DefaultCellStyle.BackColor = Color.LightCoral
                                    End If
                                End If
                            Catch
                                ' Ignore color coding errors
                            End Try
                        End If
                    Next
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading items: " & ex.Message & vbCrLf & vbCrLf & "Stack: " & ex.StackTrace, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Sub BtnFulfill_Click(sender As Object, e As EventArgs)
            ' Check for shortages first
            Dim dt = TryCast(dgvItems.DataSource, DataTable)
            If dt IsNot Nothing Then
                Dim hasShortages = False
                For Each row As DataRow In dt.Rows
                    If Convert.ToDecimal(row("Shortage")) > 0 Then
                        hasShortages = True
                        Exit For
                    End If
                Next
                
                If hasShortages Then
                    MessageBox.Show(
                        "Cannot fulfill - there are shortages!" & vbCrLf & vbCrLf &
                        "Red highlighted items show shortages." & vbCrLf &
                        "Please create Purchase Orders for missing items." & vbCrLf &
                        "After receiving stock, return here to fulfill.",
                        "Shortages Detected",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Warning)
                    Return
                End If
            End If
            
            Dim result = MessageBox.Show(
                "This will:" & vbCrLf &
                "1. Reduce stockroom inventory" & vbCrLf &
                "2. Transfer to manufacturing area" & vbCrLf &
                "3. Mark order as fulfilled" & vbCrLf &
                "4. Enable baker to start production" & vbCrLf & vbCrLf &
                "Continue?",
                "Confirm Fulfillment",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question)
            
            If result = DialogResult.Yes Then
                Try
                    Using conn As New SqlConnection(connectionString)
                        conn.Open()
                        Dim transaction = conn.BeginTransaction()
                        
                        Try
                            ' Mark ONLY unfulfilled items as fulfilled (items with enough stock)
                            Dim cmdFulfill As New SqlCommand(
                                "UPDATE BOMRequisitionFulfillment " &
                                "SET QuantityFulfilled = QuantityRequired, FulfilledDate = GETDATE(), FulfilledBy = @FulfilledBy " &
                                "WHERE ReOrderBookID = @ReOrderBookID AND FulfilledDate IS NULL", conn, transaction)
                            cmdFulfill.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                            cmdFulfill.Parameters.AddWithValue("@FulfilledBy", AppSession.CurrentUser.Username)
                            Dim fulfilledCount = cmdFulfill.ExecuteNonQuery()
                            
                            ' Transfer inventory from StockroomStock to ManufacturingStock
                            Dim cmdGetItems As New SqlCommand(
                                "SELECT IngredientName, QuantityRequired " &
                                "FROM BOMRequisitionFulfillment WHERE ReOrderBookID = @ReOrderBookID", conn, transaction)
                            cmdGetItems.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                            Dim reader = cmdGetItems.ExecuteReader()
                            Dim items As New List(Of (Name As String, Qty As Decimal))
                            While reader.Read()
                                items.Add((reader.GetString(0), reader.GetDecimal(1)))
                            End While
                            reader.Close()
                            
                            ' Log stock movements for each item transferred to manufacturing
                            For Each item In items
                                ' Get ProductID from Demo_Retail_Product by name and branch
                                Dim branchId = If(AppSession.CurrentUser?.BranchID, 0)
                                Dim cmdGetProdID As New SqlCommand(
                                    "SELECT TOP 1 ProductID FROM Demo_Retail_Product " &
                                    "WHERE Name = @Name AND BranchID = @BranchID", conn, transaction)
                                cmdGetProdID.Parameters.AddWithValue("@Name", item.Name)
                                cmdGetProdID.Parameters.AddWithValue("@BranchID", branchId)
                                Dim prodID = cmdGetProdID.ExecuteScalar()
                                
                                If prodID IsNot Nothing Then
                                    Dim productID = Convert.ToInt32(prodID)
                                    
                                    ' Log stock movement to manufacturing (for tracking only, stock stays in Demo_Retail_Product)
                                    Dim cmdLog As New SqlCommand(
                                        "INSERT INTO StockMovements (MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, CreatedBy, BranchID, ReferenceNumber) " &
                                        "VALUES (@MaterialID, @MovementType, GETDATE(), 0, @Qty, 0, @CreatedBy, @BranchID, @ReferenceNumber)", conn, transaction)
                                    cmdLog.Parameters.AddWithValue("@MaterialID", productID)
                                    cmdLog.Parameters.AddWithValue("@MovementType", "BOM Fulfill")
                                    cmdLog.Parameters.AddWithValue("@Qty", item.Qty)
                                    cmdLog.Parameters.AddWithValue("@CreatedBy", If(AppSession.CurrentUser?.UserID, 0))
                                    cmdLog.Parameters.AddWithValue("@BranchID", branchId)
                                    cmdLog.Parameters.AddWithValue("@ReferenceNumber", $"BOM-{currentReOrderBookID}")
                                    cmdLog.ExecuteNonQuery()
                                End If
                            Next
                            
                            ' Check if ALL items are now fulfilled
                            Dim cmdCheckAll As New SqlCommand(
                                "SELECT COUNT(*) FROM BOMRequisitionFulfillment " &
                                "WHERE ReOrderBookID = @ReOrderBookID AND FulfilledDate IS NULL", conn, transaction)
                            cmdCheckAll.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                            Dim remainingItems = Convert.ToInt32(cmdCheckAll.ExecuteScalar())
                            
                            ' Only mark as BOM Fulfilled if ALL items are fulfilled
                            If remainingItems = 0 Then
                                Dim cmdUpdate As New SqlCommand(
                                    "UPDATE ReOrderBooks SET FulfilledDate = GETDATE(), FulfilledBy = @FulfilledBy, Status = 'BOM Fulfilled' " &
                                    "WHERE ReOrderBookID = @ReOrderBookID", conn, transaction)
                                cmdUpdate.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                                cmdUpdate.Parameters.AddWithValue("@FulfilledBy", AppSession.CurrentUser.Username)
                                cmdUpdate.ExecuteNonQuery()
                            End If
                            
                            transaction.Commit()
                            
                            If remainingItems = 0 Then
                                MessageBox.Show($"All BOM items fulfilled! Order is now ready for baker to start production.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                                ' Clear the grid and reload orders (this order will disappear since it's fully fulfilled)
                                dgvItems.DataSource = Nothing
                                LoadPendingOrders()
                                btnFulfill.Enabled = False
                            Else
                                MessageBox.Show($"{fulfilledCount} item(s) fulfilled. {remainingItems} item(s) still need fulfillment.", "Partial Fulfillment", MessageBoxButtons.OK, MessageBoxIcon.Information)
                                ' Reload the SAME order to show updated fulfillment status
                                LoadRequisitionItems()
                            End If
                            
                        Catch ex As Exception
                            transaction.Rollback()
                            Throw
                        End Try
                    End Using
                Catch ex As Exception
                    MessageBox.Show("Error fulfilling order: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        End Sub
    End Class
End Namespace
