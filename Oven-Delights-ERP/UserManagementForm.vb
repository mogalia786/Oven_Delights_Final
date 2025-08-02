Imports System.Windows.Forms

Partial Class UserManagementForm
    Inherits Form

    Private userService As New UserService()

    Public Sub New()
        InitializeComponent()
        LoadUsers()
    End Sub

    Private Sub LoadUsers()
        dgvUsers.DataSource = userService.GetAllUsers()
        dgvUsers.AutoResizeColumns()
    End Sub

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        If String.IsNullOrWhiteSpace(txtSearch.Text) Then
            LoadUsers()
        Else
            dgvUsers.DataSource = userService.SearchUsers(txtSearch.Text.Trim())
            dgvUsers.AutoResizeColumns()
        End If
    End Sub

    Private Sub btnAddUser_Click(sender As Object, e As EventArgs) Handles btnAddUser.Click
        Dim addForm As New UserAddEditForm()
        If addForm.ShowDialog() = DialogResult.OK Then
            LoadUsers()
        End If
    End Sub

    Private Sub btnEditUser_Click(sender As Object, e As EventArgs) Handles btnEditUser.Click
        If dgvUsers.SelectedRows.Count > 0 Then
            Dim userID As Integer = Convert.ToInt32(dgvUsers.SelectedRows(0).Cells("ID").Value)
            Dim editForm As New UserAddEditForm(userID)
            If editForm.ShowDialog() = DialogResult.OK Then
                LoadUsers()
            End If
        Else
            MessageBox.Show("Please select a user to edit.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
    End Sub

    Private Sub btnDeleteUser_Click(sender As Object, e As EventArgs) Handles btnDeleteUser.Click
        If dgvUsers.SelectedRows.Count > 0 Then
            Dim username As String = dgvUsers.SelectedRows(0).Cells("Username").Value.ToString()
            Dim result As DialogResult = MessageBox.Show($"Are you sure you want to deactivate user '{username}'?", "Confirm Deactivation", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result = DialogResult.Yes Then
                Dim userID As Integer = Convert.ToInt32(dgvUsers.SelectedRows(0).Cells("ID").Value)
                If userService.DeleteUser(userID) Then
                    MessageBox.Show("User deactivated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    LoadUsers()
                End If
            End If
        Else
            MessageBox.Show("Please select a user to deactivate.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
    End Sub
End Class
