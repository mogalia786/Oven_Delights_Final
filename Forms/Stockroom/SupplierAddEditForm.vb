Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms
Imports System.Drawing

Public Class SupplierAddEditForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _supplierId As Integer?
    Private ReadOnly _isEditMode As Boolean
    Private ReadOnly stockroomService As New StockroomService()
    ' Controls are declared in Designer file
    Private cboPaymentTerms As ComboBox
    Private cboBranch As ComboBox
    Private txtSupplierName As TextBox

    Public Sub New(Optional supplierId As Integer? = Nothing)
        _supplierId = supplierId
        _isEditMode = supplierId.HasValue
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        InitializeComponent()
        If _isEditMode Then LoadSupplierData()
    End Sub

    ' InitializeComponent is in Designer file

    Private Sub LoadPaymentTerms()
        cboPaymentTerms.Items.AddRange({"Net 30", "Net 15", "Net 7", "COD", "2/10 Net 30", "1/10 Net 30"})
        cboPaymentTerms.SelectedIndex = 0
    End Sub

    Private Sub LoadBranches()
        Try
            Dim branches = stockroomService.GetBranchesLookup()
            cboBranch.DataSource = branches
            cboBranch.DisplayMember = "BranchName"
            cboBranch.ValueMember = "BranchID"
            
            ' Set default to current user's branch
            If Not stockroomService.IsCurrentUserSuperAdmin() Then
                cboBranch.SelectedValue = stockroomService.GetCurrentUserBranchId()
            End If
        Catch ex As Exception
            ' Fallback if branches can't be loaded
            cboBranch.Items.Add("Main Branch")
            cboBranch.SelectedIndex = 0
        End Try
    End Sub

    Private Sub LoadSupplierData()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT CompanyName AS SupplierName, 
                           ISNULL(ContactPerson, '') AS ContactPerson, 
                           ISNULL(Phone, '') AS Phone, 
                           ISNULL(Email, '') AS Email, 
                           ISNULL(Address, '') AS Address, 
                           ISNULL(BranchID, 1) AS BranchID,
                           IsActive 
                           FROM Suppliers WHERE SupplierID = @supplierId"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@supplierId", _supplierId.Value)
                    conn.Open()
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            txtSupplierName.Text = reader("SupplierName").ToString()
                            txtContactPerson.Text = reader("ContactPerson").ToString()
                            txtPhone.Text = reader("Phone").ToString()
                            txtEmail.Text = reader("Email").ToString()
                            txtAddress.Text = reader("Address").ToString()
                            chkIsActive.Checked = Convert.ToBoolean(reader("IsActive"))
                            
                            ' Set branch if Super Admin
                            If stockroomService.IsCurrentUserSuperAdmin() AndAlso cboBranch.Items.Count > 0 Then
                                Try
                                    cboBranch.SelectedValue = Convert.ToInt32(reader("BranchID"))
                                Catch
                                    cboBranch.SelectedIndex = 0
                                End Try
                            End If
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading supplier data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnSave(sender As Object, e As EventArgs)
        Try
            If Not ValidateInput() Then Return

            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                If _isEditMode Then
                    UpdateSupplier(conn)
                Else
                    CreateSupplier(conn)
                End If
                
                Me.DialogResult = DialogResult.OK
                Me.Close()
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error saving supplier: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnCancel(sender As Object, e As EventArgs)
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub

    Private Function ValidateInput() As Boolean
        If String.IsNullOrWhiteSpace(txtSupplierName.Text) Then
            MessageBox.Show("Supplier name is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtSupplierName.Focus()
            Return False
        End If

        If String.IsNullOrWhiteSpace(txtContactPerson.Text) Then
            MessageBox.Show("Contact person is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtContactPerson.Focus()
            Return False
        End If

        If Not String.IsNullOrWhiteSpace(txtEmail.Text) AndAlso Not txtEmail.Text.Contains("@") Then
            MessageBox.Show("Please enter a valid email address.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtEmail.Focus()
            Return False
        End If

        Return True
    End Function

    Private Sub CreateSupplier(conn As SqlConnection)
        ' Get branch ID for new supplier
        Dim branchId As Integer
        If stockroomService.IsCurrentUserSuperAdmin() AndAlso cboBranch.SelectedValue IsNot Nothing Then
            branchId = Convert.ToInt32(cboBranch.SelectedValue)
        Else
            branchId = stockroomService.GetCurrentUserBranchId()
        End If
        
        Dim sql = "INSERT INTO Suppliers (CompanyName, ContactPerson, Phone, Email, Address, BranchID, IsActive, CreatedDate, CreatedBy) " &
                  "VALUES (@CompanyName, @ContactPerson, @Phone, @Email, @Address, @BranchID, @IsActive, GETDATE(), 1)"
        
        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@CompanyName", txtSupplierName.Text.Trim())
            cmd.Parameters.AddWithValue("@ContactPerson", txtContactPerson.Text.Trim())
            cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim())
            cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim())
            cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim())
            cmd.Parameters.AddWithValue("@BranchID", branchId)
            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked)
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
    Private Sub UpdateSupplier(conn As SqlConnection)
        ' Get branch ID for update
        Dim branchId As Integer
        If stockroomService.IsCurrentUserSuperAdmin() AndAlso cboBranch.SelectedValue IsNot Nothing Then
            branchId = Convert.ToInt32(cboBranch.SelectedValue)
        Else
            branchId = stockroomService.GetCurrentUserBranchId()
        End If
        
        Dim sql = "UPDATE Suppliers SET CompanyName = @CompanyName, ContactPerson = @ContactPerson, 
                   Phone = @Phone, Email = @Email, Address = @Address, BranchID = @BranchID, IsActive = @IsActive 
                   WHERE SupplierID = @SupplierID"
        
        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@CompanyName", txtSupplierName.Text.Trim())
            cmd.Parameters.AddWithValue("@ContactPerson", txtContactPerson.Text.Trim())
            cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim())
            cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim())
            cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim())
            cmd.Parameters.AddWithValue("@BranchID", branchId)
            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked)
            cmd.Parameters.AddWithValue("@SupplierID", _supplierId.Value)
            cmd.ExecuteNonQuery()
        End Using
    End Sub
End Class
