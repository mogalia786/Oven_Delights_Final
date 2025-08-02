Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Partial Class BranchManagementForm
    Inherits Form

    Private connectionString As String

    Public Sub New()
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        LoadBranches()
    End Sub

    Private Sub LoadBranches()
        dgvBranches.DataSource = GetAllBranches()
        dgvBranches.AutoResizeColumns()
    End Sub

    Private Function GetAllBranches() As DataTable
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT ID, Name, Address, Phone, Email, Manager, IsActive, CreatedDate FROM Branches ORDER BY Name", conn)
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)
            Catch ex As Exception
                MessageBox.Show("Error loading branches: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
        Return dt
    End Function

    Private Sub btnAddBranch_Click(sender As Object, e As EventArgs) Handles btnAddBranch.Click
        Dim addForm As New BranchAddEditForm()
        If addForm.ShowDialog() = DialogResult.OK Then
            LoadBranches()
        End If
    End Sub

    Private Sub btnEditBranch_Click(sender As Object, e As EventArgs) Handles btnEditBranch.Click
        If dgvBranches.SelectedRows.Count > 0 Then
            Dim branchID As Integer = Convert.ToInt32(dgvBranches.SelectedRows(0).Cells("ID").Value)
            Dim editForm As New BranchAddEditForm(branchID)
            If editForm.ShowDialog() = DialogResult.OK Then
                LoadBranches()
            End If
        Else
            MessageBox.Show("Please select a branch to edit.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
    End Sub

    Private Sub btnDeleteBranch_Click(sender As Object, e As EventArgs) Handles btnDeleteBranch.Click
        If dgvBranches.SelectedRows.Count > 0 Then
            Dim branchName As String = dgvBranches.SelectedRows(0).Cells("Name").Value.ToString()
            Dim result As DialogResult = MessageBox.Show($"Are you sure you want to deactivate branch '{branchName}'?", "Confirm Deactivation", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result = DialogResult.Yes Then
                Dim branchID As Integer = Convert.ToInt32(dgvBranches.SelectedRows(0).Cells("ID").Value)
                If DeactivateBranch(branchID) Then
                    MessageBox.Show("Branch deactivated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    LoadBranches()
                End If
            End If
        Else
            MessageBox.Show("Please select a branch to deactivate.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
    End Sub

    Private Function DeactivateBranch(branchID As Integer) As Boolean
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("UPDATE Branches SET IsActive = 0 WHERE ID = @branchID", conn)
                cmd.Parameters.AddWithValue("@branchID", branchID)
                cmd.ExecuteNonQuery()
                LogAuditAction("BranchDeactivated", "Branches", branchID, $"Deactivated branch ID: {branchID}")
                Return True
            Catch ex As Exception
                MessageBox.Show("Error deactivating branch: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Using
    End Function

    Private Sub LogAuditAction(action As String, tableName As String, recordID As Integer, details As String)
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Details, Timestamp) VALUES (NULL, @action, @tableName, @recordID, @details, GETDATE())", conn)
                cmd.Parameters.AddWithValue("@action", action)
                cmd.Parameters.AddWithValue("@tableName", tableName)
                cmd.Parameters.AddWithValue("@recordID", recordID)
                cmd.Parameters.AddWithValue("@details", details)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                ' Silent fail for audit logging
            End Try
        End Using
    End Sub
End Class
