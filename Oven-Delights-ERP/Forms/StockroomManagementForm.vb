Imports System.Windows.Forms

Public Class StockroomManagementForm
    Inherits Form

    Private currentUser As User

    Public Sub New(user As User)
        InitializeComponent()
        currentUser = user
        Me.Text = "Stockroom Management - Oven Delights ERP"
        Me.WindowState = FormWindowState.Maximized

        ' Wire up event handlers
        AddHandler btnAddSupplier.Click, AddressOf btnAddSupplier_Click
        AddHandler btnEditSupplier.Click, AddressOf btnEditSupplier_Click
        AddHandler btnAddMaterial.Click, AddressOf btnAddMaterial_Click
        AddHandler btnEditMaterial.Click, AddressOf btnEditMaterial_Click
        AddHandler btnCreatePO.Click, AddressOf btnCreatePO_Click
        AddHandler btnRefresh.Click, AddressOf btnRefresh_Click
        AddHandler txtSearchSuppliers.TextChanged, AddressOf txtSearchSuppliers_TextChanged
        AddHandler txtSearchMaterials.TextChanged, AddressOf txtSearchMaterials_TextChanged

        LoadDataFromDatabase()
    End Sub

    Private Sub LoadDataFromDatabase()
        Try
            Dim stockroomService As New StockroomService()

            ' Load suppliers data from database
            Dim suppliersData = stockroomService.GetAllSuppliers()
            If dgvSuppliers IsNot Nothing Then
                dgvSuppliers.DataSource = suppliersData
                dgvSuppliers.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
                dgvSuppliers.SelectionMode = DataGridViewSelectionMode.FullRowSelect
                dgvSuppliers.ReadOnly = True
                dgvSuppliers.AllowUserToAddRows = False
                dgvSuppliers.AllowUserToDeleteRows = False
            End If

            ' Load raw materials data from database
            Dim materialsData = stockroomService.GetAllRawMaterials()
            If dgvRawMaterials IsNot Nothing Then
                dgvRawMaterials.DataSource = materialsData
                dgvRawMaterials.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
                dgvRawMaterials.SelectionMode = DataGridViewSelectionMode.FullRowSelect
                dgvRawMaterials.ReadOnly = True
                dgvRawMaterials.AllowUserToAddRows = False
                dgvRawMaterials.AllowUserToDeleteRows = False

                ' Format currency columns
                If dgvRawMaterials.Columns.Contains("StandardCost") Then
                    dgvRawMaterials.Columns("StandardCost").DefaultCellStyle.Format = "C2"
                End If
                If dgvRawMaterials.Columns.Contains("LastCost") Then
                    dgvRawMaterials.Columns("LastCost").DefaultCellStyle.Format = "C2"
                End If
                If dgvRawMaterials.Columns.Contains("AverageCost") Then
                    dgvRawMaterials.Columns("AverageCost").DefaultCellStyle.Format = "C2"
                End If
                If dgvRawMaterials.Columns.Contains("StockValue") Then
                    dgvRawMaterials.Columns("StockValue").DefaultCellStyle.Format = "C2"
                End If
            End If

            ' Load purchase orders data from database
            Dim purchaseOrdersData = stockroomService.GetAllPurchaseOrders()
            If dgvPurchaseOrders IsNot Nothing Then
                dgvPurchaseOrders.DataSource = purchaseOrdersData
                dgvPurchaseOrders.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
                dgvPurchaseOrders.SelectionMode = DataGridViewSelectionMode.FullRowSelect
                dgvPurchaseOrders.ReadOnly = True
                dgvPurchaseOrders.AllowUserToAddRows = False
                dgvPurchaseOrders.AllowUserToDeleteRows = False

                ' Format currency columns
                If dgvPurchaseOrders.Columns.Contains("SubTotal") Then
                    dgvPurchaseOrders.Columns("SubTotal").DefaultCellStyle.Format = "C2"
                End If
                If dgvPurchaseOrders.Columns.Contains("VATAmount") Then
                    dgvPurchaseOrders.Columns("VATAmount").DefaultCellStyle.Format = "C2"
                End If
                If dgvPurchaseOrders.Columns.Contains("TotalAmount") Then
                    dgvPurchaseOrders.Columns("TotalAmount").DefaultCellStyle.Format = "C2"
                End If

                ' Format date columns
                If dgvPurchaseOrders.Columns.Contains("OrderDate") Then
                    dgvPurchaseOrders.Columns("OrderDate").DefaultCellStyle.Format = "dd/MM/yyyy"
                End If
                If dgvPurchaseOrders.Columns.Contains("RequiredDate") Then
                    dgvPurchaseOrders.Columns("RequiredDate").DefaultCellStyle.Format = "dd/MM/yyyy"
                End If
            End If

            ' Load low stock items from database
            Dim lowStockData = stockroomService.GetLowStockMaterials()
            If dgvLowStock IsNot Nothing Then
                dgvLowStock.DataSource = lowStockData
                dgvLowStock.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
                dgvLowStock.SelectionMode = DataGridViewSelectionMode.FullRowSelect
                dgvLowStock.ReadOnly = True
                dgvLowStock.AllowUserToAddRows = False
                dgvLowStock.AllowUserToDeleteRows = False

                ' Format currency columns
                If dgvLowStock.Columns.Contains("AverageCost") Then
                    dgvLowStock.Columns("AverageCost").DefaultCellStyle.Format = "C2"
                End If
                If dgvLowStock.Columns.Contains("ReorderValue") Then
                    dgvLowStock.Columns("ReorderValue").DefaultCellStyle.Format = "C2"
                End If

                ' Color code priority levels
                For Each row As DataGridViewRow In dgvLowStock.Rows
                    If row.Cells("Priority") IsNot Nothing Then
                        Dim priority As String = row.Cells("Priority").Value?.ToString()
                        Select Case priority
                            Case "Critical - Out of Stock"
                                row.DefaultCellStyle.BackColor = Color.LightCoral
                            Case "Critical - Very Low"
                                row.DefaultCellStyle.BackColor = Color.LightSalmon
                            Case "Low Stock"
                                row.DefaultCellStyle.BackColor = Color.LightYellow
                        End Select
                    End If
                Next
            End If

            ' Update summary labels with real counts
            If lblTotalSuppliers IsNot Nothing Then lblTotalSuppliers.Text = $"Total Suppliers: {suppliersData.Rows.Count}"
            If lblTotalMaterials IsNot Nothing Then lblTotalMaterials.Text = $"Total Materials: {materialsData.Rows.Count}"
            If lblTotalOrders IsNot Nothing Then lblTotalOrders.Text = $"Total Orders: {purchaseOrdersData.Rows.Count}"
            If lblLowStockCount IsNot Nothing Then lblLowStockCount.Text = $"Low Stock Items: {lowStockData.Rows.Count}"

        Catch ex As Exception
            MessageBox.Show($"Error loading data: {ex.Message}", "Data Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnAddSupplier_Click(sender As Object, e As EventArgs)
        MessageBox.Show("Add Supplier functionality will be implemented.", "Coming Soon", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub btnEditSupplier_Click(sender As Object, e As EventArgs)
        If dgvSuppliers.SelectedRows.Count > 0 Then
            MessageBox.Show("Edit Supplier functionality will be implemented.", "Coming Soon", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Else
            MessageBox.Show("Please select a supplier to edit.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End If
    End Sub

    Private Sub btnAddMaterial_Click(sender As Object, e As EventArgs)
        MessageBox.Show("Add Material functionality will be implemented.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub btnEditMaterial_Click(sender As Object, e As EventArgs)
        If dgvRawMaterials.SelectedRows.Count > 0 Then
            MessageBox.Show("Edit Material functionality will be implemented.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Else
            MessageBox.Show("Please select a material to edit.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End If
    End Sub

    Private Sub btnCreatePO_Click(sender As Object, e As EventArgs)
        MessageBox.Show("Create Purchase Order functionality will be implemented.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs)
        LoadDataFromDatabase()
        MessageBox.Show("Data refreshed successfully from database.", "Refresh", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub txtSearchSuppliers_TextChanged(sender As Object, e As EventArgs)
        ' Simple search functionality - can be enhanced later
        Dim searchText As String = txtSearchSuppliers.Text.ToLower()
        ' Search implementation will be added when database is working
    End Sub

    Private Sub txtSearchMaterials_TextChanged(sender As Object, e As EventArgs)
        ' Simple search functionality - can be enhanced later
        Dim searchText As String = txtSearchMaterials.Text.ToLower()
        ' Search implementation will be added when database is working
    End Sub

    Private Sub StockroomManagementForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Stockroom Management - Oven Delights ERP"
        Me.WindowState = FormWindowState.Maximized
        ConfigureDataGridViews()
    End Sub

    Private Sub ConfigureDataGridViews()
        ' Configure all data grids
        dgvSuppliers.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        dgvSuppliers.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvSuppliers.MultiSelect = False

        dgvRawMaterials.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        dgvRawMaterials.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvRawMaterials.MultiSelect = False

        dgvPurchaseOrders.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        dgvPurchaseOrders.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvPurchaseOrders.MultiSelect = False

        dgvLowStock.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        dgvLowStock.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvLowStock.MultiSelect = False
    End Sub
End Class
