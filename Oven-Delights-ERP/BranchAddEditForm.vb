Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Partial Class BranchAddEditForm
    Inherits Form

    Private connectionString As String
    Private branchID As Integer?
    Private isEditMode As Boolean = False

    Public Sub New()
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        isEditMode = False
        Me.Text = "Add New Branch"
    End Sub

    Public Sub New(branchID As Integer)
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Me.branchID = branchID
        isEditMode = True
        Me.Text = "Edit Branch"
        LoadBranchData()
    End Sub

    Private Sub LoadBranchData()
        If branchID.HasValue Then
            Using conn As New SqlConnection(connectionString)
                Try
                    conn.Open()
                    Dim cmd As New SqlCommand("SELECT Name, Address, Phone, Email, Manager, IsActive FROM Branches WHERE ID = @branchID", conn)
                    cmd.Parameters.AddWithValue("@branchID", branchID.Value)
                    Dim reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtName.Text = reader("Name").ToString()
                        txtAddress.Text = reader("Address").ToString()
                        txtPhone.Text = reader("Phone").ToString()
                        txtEmail.Text = reader("Email").ToString()
                        txtManager.Text = reader("Manager").ToString()
                        chkIsActive.Checked = Convert.ToBoolean(reader("IsActive"))
                    End If
                    reader.Close()
                Catch ex As Exception
                    MessageBox.Show("Error loading branch data: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End Using
        End If
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If ValidateForm() Then
            If isEditMode Then
                If UpdateBranch() Then
                    MessageBox.Show("Branch updated successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.DialogResult = DialogResult.OK
                    Me.Close()
                End If
            Else
                If CreateBranch() Then
                    MessageBox.Show("Branch created successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.DialogResult = DialogResult.OK
                    Me.Close()
                End If
            End If
        End If
    End Sub

    Private Function ValidateForm() As Boolean
        If String.IsNullOrWhiteSpace(txtName.Text) Then
            MessageBox.Show("Branch name is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtName.Focus()
            Return False
        End If

        If String.IsNullOrWhiteSpace(txtAddress.Text) Then
            MessageBox.Show("Address is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtAddress.Focus()
            Return False
        End If

        Return True
    End Function

    Private Function CreateBranch() As Boolean
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("INSERT INTO Branches (Name, Address, Phone, Email, Manager, IsActive, CreatedDate, CostCenterCode) VALUES (@name, @address, @phone, @email, @manager, @isActive, GETDATE(), @costCenter)", conn)
                cmd.Parameters.AddWithValue("@name", txtName.Text.Trim())
                cmd.Parameters.AddWithValue("@address", txtAddress.Text.Trim())
                cmd.Parameters.AddWithValue("@phone", If(String.IsNullOrWhiteSpace(txtPhone.Text), DBNull.Value, txtPhone.Text.Trim()))
                cmd.Parameters.AddWithValue("@email", If(String.IsNullOrWhiteSpace(txtEmail.Text), DBNull.Value, txtEmail.Text.Trim()))
                cmd.Parameters.AddWithValue("@manager", If(String.IsNullOrWhiteSpace(txtManager.Text), DBNull.Value, txtManager.Text.Trim()))
                cmd.Parameters.AddWithValue("@isActive", chkIsActive.Checked)
                cmd.Parameters.AddWithValue("@costCenter", GenerateCostCenterCode(txtName.Text.Trim()))
                cmd.ExecuteNonQuery()
                LogAuditAction("BranchCreated", "Branches", Nothing, $"Created branch: {txtName.Text.Trim()}")
                Return True
            Catch ex As Exception
                MessageBox.Show("Error creating branch: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Using
    End Function

    Private Function UpdateBranch() As Boolean
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("UPDATE Branches SET Name=@name, Address=@address, Phone=@phone, Email=@email, Manager=@manager, IsActive=@isActive WHERE ID=@branchID", conn)
                cmd.Parameters.AddWithValue("@branchID", branchID.Value)
                cmd.Parameters.AddWithValue("@name", txtName.Text.Trim())
                cmd.Parameters.AddWithValue("@address", txtAddress.Text.Trim())
                cmd.Parameters.AddWithValue("@phone", If(String.IsNullOrWhiteSpace(txtPhone.Text), DBNull.Value, txtPhone.Text.Trim()))
                cmd.Parameters.AddWithValue("@email", If(String.IsNullOrWhiteSpace(txtEmail.Text), DBNull.Value, txtEmail.Text.Trim()))
                cmd.Parameters.AddWithValue("@manager", If(String.IsNullOrWhiteSpace(txtManager.Text), DBNull.Value, txtManager.Text.Trim()))
                cmd.Parameters.AddWithValue("@isActive", chkIsActive.Checked)
                cmd.ExecuteNonQuery()
                LogAuditAction("BranchUpdated", "Branches", branchID.Value, $"Updated branch: {txtName.Text.Trim()}")
                Return True
            Catch ex As Exception
                MessageBox.Show("Error updating branch: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Using
    End Function

    Private Function GenerateCostCenterCode(branchName As String) As String
        ' Generate cost center code for accounting integration
        Dim code As String = branchName.Replace(" ", "").ToUpper()
        If code.Length > 10 Then
            code = code.Substring(0, 10)
        End If
        Return "CC" & code & DateTime.Now.ToString("yy")
    End Function

    Private Sub LogAuditAction(action As String, tableName As String, recordID As Integer?, details As String)
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Details, Timestamp) VALUES (NULL, @action, @tableName, @recordID, @details, GETDATE())", conn)
                cmd.Parameters.AddWithValue("@action", action)
                cmd.Parameters.AddWithValue("@tableName", tableName)
                cmd.Parameters.AddWithValue("@recordID", If(recordID.HasValue, recordID.Value, DBNull.Value))
                cmd.Parameters.AddWithValue("@details", details)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                ' Silent fail for audit logging
            End Try
        End Using
    End Sub

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub
End Class
