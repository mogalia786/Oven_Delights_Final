Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms
Imports System.Drawing

Public Class SuppliersForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly stockroomService As New StockroomService()
    ' Controls are declared in Designer file

    Public Sub New()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        InitializeComponent()
        LoadSuppliers()
    End Sub

    ' InitializeComponent is in Designer file


    Private Sub LoadSuppliers()
        Try
            Using conn As New SqlConnection(_connString)
                ' Get current user's branch and role for filtering
                Dim currentBranchId As Integer = stockroomService.GetCurrentUserBranchId()
                Dim isSuperAdmin As Boolean = stockroomService.IsCurrentUserSuperAdmin()
                
                Dim sql As String
                If isSuperAdmin Then
                    sql = "SELECT SupplierID, CompanyName AS SupplierName, 
                           ISNULL(ContactPerson, '') AS ContactPerson,
                           ISNULL(Phone, '') AS Phone,
                           ISNULL(Email, '') AS Email,
                           ISNULL(Address, '') AS Address,
                           CASE WHEN IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status,
                           CreatedDate
                           FROM Suppliers 
                           ORDER BY CompanyName"
                Else
                    sql = "SELECT SupplierID, CompanyName AS SupplierName, 
                           ISNULL(ContactPerson, '') AS ContactPerson,
                           ISNULL(Phone, '') AS Phone,
                           ISNULL(Email, '') AS Email,
                           ISNULL(Address, '') AS Address,
                           CASE WHEN IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status,
                           CreatedDate
                           FROM Suppliers 
                           WHERE (BranchID = @BranchID OR BranchID IS NULL)
                           ORDER BY CompanyName"
                End If

                Using cmd As New SqlCommand(sql, conn)
                    If Not isSuperAdmin Then
                        cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                    End If
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvSuppliers.DataSource = dt
                        
                        ' Hide SupplierID column
                        If dgvSuppliers.Columns.Contains("SupplierID") Then
                            dgvSuppliers.Columns("SupplierID").Visible = False
                        End If
                        
                        ' Format date column
                        If dgvSuppliers.Columns.Contains("CreatedDate") Then
                            dgvSuppliers.Columns("CreatedDate").DefaultCellStyle.Format = "yyyy-MM-dd"
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnSearchTextChanged(sender As Object, e As EventArgs)
        Try
            If dgvSuppliers.DataSource IsNot Nothing Then
                Dim dt = CType(dgvSuppliers.DataSource, DataTable)
                If Not String.IsNullOrWhiteSpace(txtSearch.Text) Then
                    Dim searchText = txtSearch.Text.Replace("'", "''")
                    dt.DefaultView.RowFilter = $"SupplierName LIKE '%{searchText}%' OR ContactPerson LIKE '%{searchText}%' OR Phone LIKE '%{searchText}%' OR Email LIKE '%{searchText}%'"
                Else
                    dt.DefaultView.RowFilter = String.Empty
                End If
            End If
        Catch ex As Exception
            ' Silent fail for search errors
        End Try
    End Sub

    Private Sub OnAddSupplier(sender As Object, e As EventArgs)
        Try
            Using frm As New SupplierAddEditForm()
                If frm.ShowDialog(Me) = DialogResult.OK Then
                    LoadSuppliers()
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error opening Add Supplier form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnEditSupplier(sender As Object, e As EventArgs)
        Try
            If dgvSuppliers.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a supplier to edit.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim supplierId = Convert.ToInt32(dgvSuppliers.SelectedRows(0).Cells("SupplierID").Value)
            Using frm As New SupplierAddEditForm(supplierId)
                If frm.ShowDialog(Me) = DialogResult.OK Then
                    LoadSuppliers()
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error opening Edit Supplier form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnDeleteSupplier(sender As Object, e As EventArgs)
        Try
            If dgvSuppliers.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a supplier to delete.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim supplierName = dgvSuppliers.SelectedRows(0).Cells("SupplierName").Value.ToString()
            Dim result = MessageBox.Show($"Are you sure you want to delete supplier '{supplierName}'?", 
                                       "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            
            If result = DialogResult.Yes Then
                Dim supplierId = Convert.ToInt32(dgvSuppliers.SelectedRows(0).Cells("SupplierID").Value)
                DeleteSupplier(supplierId)
                LoadSuppliers()
            End If
        Catch ex As Exception
            MessageBox.Show($"Error deleting supplier: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub DeleteSupplier(supplierId As Integer)
        Using conn As New SqlConnection(_connString)
            conn.Open()
            Using cmd As New SqlCommand("UPDATE Suppliers SET IsActive = 0 WHERE SupplierID = @supplierId", conn)
                cmd.Parameters.AddWithValue("@supplierId", supplierId)
                cmd.ExecuteNonQuery()
            End Using
        End Using
        MessageBox.Show("Supplier deactivated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub OnRefresh(sender As Object, e As EventArgs)
        LoadSuppliers()
    End Sub
End Class
