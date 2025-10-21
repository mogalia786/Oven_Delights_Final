Imports System.Data
Imports System.Windows.Forms
Imports System.Configuration
Imports System.Data.SqlClient

Public Class GRVCreateForm
    Inherits Form
    Private ReadOnly grvService As New GRVService()
    Private ReadOnly stockroomService As New StockroomService()
    Private currentBranchId As Integer
    Private isSuperAdmin As Boolean

    Public Sub New()
        InitializeComponent()
        LoadData()
    End Sub

    ' InitializeComponent is now in Designer file

    Private Sub LoadData()
        Try
            ' Load branches (only show current user's branch unless Super Admin)
            Dim branches = stockroomService.GetBranchesLookup()
            cboBranch.DataSource = branches
            cboBranch.DisplayMember = "BranchName"
            cboBranch.ValueMember = "BranchID"
            
            ' Set default to current user's branch
            If Not stockroomService.IsCurrentUserSuperAdmin() Then
                cboBranch.SelectedValue = stockroomService.GetCurrentUserBranchId()
                cboBranch.Enabled = False
            End If
            
            ' Load purchase orders
            LoadPurchaseOrders()
        Catch ex As Exception
            MessageBox.Show($"Error loading data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadPurchaseOrders()
        Try
            ' Load purchase orders filtered by branch
            Dim currentBranchId As Integer = stockroomService.GetCurrentUserBranchId()
            Dim isSuperAdmin As Boolean = stockroomService.IsCurrentUserSuperAdmin()
            
            Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                Dim sql As String
                If isSuperAdmin Then
                    sql = "SELECT po.PurchaseOrderID, po.PONumber, s.CompanyName AS SupplierName 
                           FROM PurchaseOrders po 
                           INNER JOIN Suppliers s ON po.SupplierID = s.SupplierID 
                           WHERE po.Status IN ('Approved', 'Pending') 
                           ORDER BY po.CreatedDate DESC"
                Else
                    sql = "SELECT po.PurchaseOrderID, po.PONumber, s.CompanyName AS SupplierName 
                           FROM PurchaseOrders po 
                           INNER JOIN Suppliers s ON po.SupplierID = s.SupplierID 
                           WHERE po.Status IN ('Approved', 'Pending') AND po.BranchID = @BranchID
                           ORDER BY po.CreatedDate DESC"
                End If
                
                Using cmd As New SqlCommand(sql, con)
                    If Not isSuperAdmin Then
                        cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                    End If
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        
                        cboPurchaseOrder.DataSource = dt
                        cboPurchaseOrder.DisplayMember = "PONumber"
                        cboPurchaseOrder.ValueMember = "PurchaseOrderID"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading purchase orders: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadPOLines()
        If cboPurchaseOrder.SelectedValue Is Nothing Then
            dgvPOLines.DataSource = Nothing
            Return
        End If
        Dim poId As Integer = Convert.ToInt32(cboPurchaseOrder.SelectedValue)
        
        Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            Dim sql As String = "
                SELECT pol.POLineID, 
                       COALESCE(rm.MaterialName, p.Name, sp.Name) AS ItemName,
                       COALESCE(rm.MaterialCode, p.SKU, sp.Code) AS ItemCode,
                       pol.OrderedQuantity, pol.UnitCost,
                       (pol.OrderedQuantity * pol.UnitCost) AS LineTotal,
                       CASE WHEN pol.MaterialID IS NOT NULL THEN 'Raw Material' ELSE 'Product' END AS ItemType
                FROM PurchaseOrderLines pol
                LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID
                LEFT JOIN Products p ON pol.ProductID = p.ProductID
                LEFT JOIN Stockroom_Product sp ON pol.ProductID = sp.ProductID
                WHERE pol.PurchaseOrderID = @poId AND pol.IsActive = 1
                ORDER BY pol.LineNumber"
            
            Using da As New SqlDataAdapter(sql, con)
                da.SelectCommand.Parameters.AddWithValue("@poId", poId)
                Dim dt As New DataTable()
                da.Fill(dt)
                
                dgvPOLines.DataSource = dt
                
                ' Format columns
                If dgvPOLines.Columns.Contains("POLineID") Then dgvPOLines.Columns("POLineID").Visible = False
                If dgvPOLines.Columns.Contains("ItemName") Then dgvPOLines.Columns("ItemName").HeaderText = "Item"
                If dgvPOLines.Columns.Contains("ItemCode") Then dgvPOLines.Columns("ItemCode").HeaderText = "Code"
                If dgvPOLines.Columns.Contains("OrderedQuantity") Then dgvPOLines.Columns("OrderedQuantity").HeaderText = "Quantity"
                If dgvPOLines.Columns.Contains("UnitCost") Then 
                    dgvPOLines.Columns("UnitCost").HeaderText = "Unit Cost"
                    dgvPOLines.Columns("UnitCost").DefaultCellStyle.Format = "C2"
                End If
                If dgvPOLines.Columns.Contains("LineTotal") Then 
                    dgvPOLines.Columns("LineTotal").HeaderText = "Total"
                    dgvPOLines.Columns("LineTotal").DefaultCellStyle.Format = "C2"
                End If
                
                btnCreate.Enabled = dt.Rows.Count > 0
            End Using
        End Using
    End Sub

    Private Sub cboPurchaseOrder_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboPurchaseOrder.SelectedIndexChanged
        If cboPurchaseOrder.SelectedItem IsNot Nothing Then
            Dim row As DataRowView = DirectCast(cboPurchaseOrder.SelectedItem, DataRowView)
            
            ' Update supplier
            cboSupplier.Text = row("SupplierName").ToString()
            
            ' Load PO lines
            LoadPOLines()
        End If
    End Sub

    Private Sub btnCreate_Click(sender As Object, e As EventArgs) Handles btnCreate.Click
        Try
            If cboPurchaseOrder.SelectedValue Is Nothing Then
                MessageBox.Show("Please select a purchase order.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If cboBranch.SelectedValue Is Nothing Then
                MessageBox.Show("Please select a branch.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim poId As Integer = Convert.ToInt32(cboPurchaseOrder.SelectedValue)
            Dim row As DataRowView = DirectCast(cboPurchaseOrder.SelectedItem, DataRowView)
            Dim supplierId As Integer = Convert.ToInt32(row("SupplierID"))
            Dim branchId As Integer = Convert.ToInt32(cboBranch.SelectedValue)
            
            Dim deliveryDate As Date? = Nothing
            If dtpDeliveryDate.Checked Then
                deliveryDate = dtpDeliveryDate.Value.Date
            End If
            
            Dim grvId As Integer = grvService.CreateGRVFromPO(
                poId, supplierId, branchId,
                txtDeliveryNote.Text.Trim(),
                deliveryDate,
                AppSession.CurrentUserID,
                txtNotes.Text.Trim()
            )
            
            MessageBox.Show($"GRV created successfully. GRV ID: {grvId}", "Success", 
                          MessageBoxButtons.OK, MessageBoxIcon.Information)
            
            Me.DialogResult = DialogResult.OK
            Me.Close()
            
        Catch ex As Exception
            MessageBox.Show($"Error creating GRV: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
