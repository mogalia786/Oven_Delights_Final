Imports System.Windows.Forms
Imports System.Drawing
Imports Oven_Delights_ERP.UI
Imports System.ComponentModel
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Partial Class UserManagementForm
    Inherits Form

    Private ReadOnly userService As UserService
    Private ReadOnly currentUserID As Integer
    Private isFirstLoad As Boolean = True

    Public Sub New(userID As Integer)
        InitializeComponent()
        currentUserID = userID
        userService = New UserService()
        
        ' Set form title
        ' Note: Removed AppIcon reference to fix compilation error
        
        Me.Text = "User Management - Oven Delights ERP"
        
        ' Configure UI
        ConfigureDataGridView()
        LoadUsers()
        
        ' Set up event handlers
        AddHandler Me.Load, AddressOf UserManagementForm_Load
        AddHandler Me.FormClosing, AddressOf UserManagementForm_FormClosing
        AddHandler dgvUsers.DataBindingComplete, AddressOf DgvUsers_DataBindingComplete
    End Sub

    Private Sub ConfigureDataGridView()
        ' Configure column display names and formatting
        dgvUsers.AutoGenerateColumns = False
        dgvUsers.Columns.Clear()

        ' Visual styling
        dgvUsers.ReadOnly = True
        dgvUsers.MultiSelect = False
        dgvUsers.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvUsers.RowHeadersVisible = False
        dgvUsers.ColumnHeadersVisible = True
        dgvUsers.BorderStyle = BorderStyle.None
        dgvUsers.CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal
        dgvUsers.BackgroundColor = Color.White
        dgvUsers.GridColor = Color.FromArgb(236, 240, 241)
        dgvUsers.EnableHeadersVisualStyles = False
        dgvUsers.DefaultCellStyle.Font = New Font("Segoe UI", 10F, FontStyle.Regular)
        dgvUsers.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(44, 62, 80) ' dark blue header
        dgvUsers.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvUsers.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI Semibold", 10.5F, FontStyle.Bold)
        dgvUsers.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
        dgvUsers.ColumnHeadersDefaultCellStyle.WrapMode = DataGridViewTriState.False
        dgvUsers.ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.Single
        dgvUsers.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.EnableResizing
        dgvUsers.ColumnHeadersHeight = 34
        dgvUsers.DefaultCellStyle.BackColor = Color.White
        dgvUsers.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 247, 250)
        ' Selection should be dark blue, not green
        dgvUsers.DefaultCellStyle.SelectionBackColor = Color.FromArgb(44, 62, 80)
        dgvUsers.DefaultCellStyle.SelectionForeColor = Color.White

        ' Requested order: Role, Branch, Name, Email, Username, and other useful fields
        dgvUsers.Columns.Add(CreateDataGridViewTextBoxColumn("RoleName", "Role", 150))
        dgvUsers.Columns.Add(CreateDataGridViewTextBoxColumn("BranchName", "Branch", 180))
        dgvUsers.Columns.Add(CreateDataGridViewTextBoxColumn("FirstName", "First Name", 140))
        dgvUsers.Columns.Add(CreateDataGridViewTextBoxColumn("LastName", "Last Name", 140))
        dgvUsers.Columns.Add(CreateDataGridViewTextBoxColumn("Email", "Email", 220))
        dgvUsers.Columns.Add(CreateDataGridViewTextBoxColumn("Username", "Username", 160))
        dgvUsers.Columns.Add(CreateDataGridViewCheckBoxColumn("IsActive", "Active", 80))
        dgvUsers.Columns.Add(CreateDataGridViewCheckBoxColumn("TwoFactorEnabled", "2FA", 70))
        dgvUsers.Columns.Add(CreateDataGridViewTextBoxColumn("LastLogin", "Last Login", 160))
        dgvUsers.Columns.Add(CreateDataGridViewTextBoxColumn("FailedLoginAttempts", "Failed Attempts", 130))
        dgvUsers.Columns.Add(CreateDataGridViewTextBoxColumn("CreatedDate", "Created", 160))

        ' Action buttons
        Dim editBtn As New DataGridViewButtonColumn() With {
            .HeaderText = "",
            .Text = "Edit",
            .UseColumnTextForButtonValue = True,
            .Width = 90,
            .Name = "colEdit"
        }
        dgvUsers.Columns.Add(editBtn)

        Dim deactivateBtn As New DataGridViewButtonColumn() With {
            .HeaderText = "",
            .Text = "Deactivate",
            .UseColumnTextForButtonValue = True,
            .Width = 110,
            .Name = "colDeactivate"
        }
        dgvUsers.Columns.Add(deactivateBtn)

        ' Hidden but available identifiers
        Dim colUserId = CreateDataGridViewTextBoxColumn("UserID", "User ID", 80)
        colUserId.Visible = False
        dgvUsers.Columns.Add(colUserId)
        Dim colRoleId = CreateDataGridViewTextBoxColumn("RoleID", "Role ID", 80)
        colRoleId.Visible = False
        dgvUsers.Columns.Add(colRoleId)
        Dim colBranchId = CreateDataGridViewTextBoxColumn("BranchID", "Branch ID", 80)
        colBranchId.Visible = False
        dgvUsers.Columns.Add(colBranchId)
    End Sub

    Private Function CreateDataGridViewTextBoxColumn(dataPropertyName As String, headerText As String, width As Integer) As DataGridViewTextBoxColumn
        Return New DataGridViewTextBoxColumn() With {
            .DataPropertyName = dataPropertyName,
            .HeaderText = headerText,
            .Width = width,
            .AutoSizeMode = DataGridViewAutoSizeColumnMode.None,
            .Name = dataPropertyName,
            .DefaultCellStyle = New DataGridViewCellStyle() With {
                .Padding = New Padding(10, 0, 10, 0),
                .Alignment = DataGridViewContentAlignment.MiddleLeft
            }
        }
    End Function

    Private Function CreateDataGridViewCheckBoxColumn(dataPropertyName As String, headerText As String, width As Integer) As DataGridViewCheckBoxColumn
        Return New DataGridViewCheckBoxColumn() With {
            .DataPropertyName = dataPropertyName,
            .HeaderText = headerText,
            .Width = width,
            .AutoSizeMode = DataGridViewAutoSizeColumnMode.None,
            .Name = dataPropertyName,
            .DefaultCellStyle = New DataGridViewCellStyle() With {
                .Alignment = DataGridViewContentAlignment.MiddleCenter,
                .Padding = New Padding(0, 0, 0, 0)
            }
        }
    End Function

    Private Sub LoadUsers()
        Try
            Cursor = Cursors.WaitCursor
            
            ' Clear any existing data
            dgvUsers.DataSource = Nothing
            
            ' Get users from the service
            Dim users = userService.GetAllUsersInline()
            
            ' Check if there was an error in the service call
            If users.ExtendedProperties.ContainsKey("Error") Then
                Dim errorMsg = users.ExtendedProperties("Error").ToString()
                Debug.WriteLine($"Error in LoadUsers: {errorMsg}")
                MessageBox.Show($"Error loading users: {errorMsg}", "Error", 
                              MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If
            
            If users IsNot Nothing AndAlso users.Rows.Count > 0 Then
                ' Set the data source
                dgvUsers.DataSource = users

                ' Format columns
                FormatDataGridViewColumns()
                
                ' Auto-size columns on first load
                If isFirstLoad Then
                    dgvUsers.AutoResizeColumns(DataGridViewAutoSizeColumnsMode.DisplayedCells)
                    isFirstLoad = False
                End If
            Else
                ' Show message if no users found
                MessageBox.Show("No users found in the database.", "Information", 
                              MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As SqlException
            Dim errorMsg = $"Database error loading users: {ex.Message}"
            Debug.WriteLine($"{errorMsg}{vbCrLf}{ex.StackTrace}")
            MessageBox.Show(errorMsg, "Database Error", 
                          MessageBoxButtons.OK, MessageBoxIcon.Error)
                          
        Catch ex As Exception
            Dim errorMsg = $"Unexpected error loading users: {ex.Message}"
            Debug.WriteLine($"{errorMsg}{vbCrLf}{ex.StackTrace}")
            
            ' Check for inner exception
            If ex.InnerException IsNot Nothing Then
                errorMsg += $"{vbCrLf}Inner Exception: {ex.InnerException.Message}"
                Debug.WriteLine($"Inner Exception: {ex.InnerException.Message}")
            End If
            
            MessageBox.Show(errorMsg, "Error", 
                          MessageBoxButtons.OK, MessageBoxIcon.Error)
        Finally
            Cursor = Cursors.Default
        End Try
    End Sub
    
    Private Sub FormatDataGridViewColumns()
        ' Format specific columns if they exist
        If dgvUsers.Columns.Contains("LastLogin") Then
            dgvUsers.Columns("LastLogin").DefaultCellStyle.Format = "g"
            dgvUsers.Columns("LastLogin").DefaultCellStyle.NullValue = "Never"
        End If
        
        ' Format boolean columns
        For Each col As DataGridViewColumn In dgvUsers.Columns
            If col.ValueType Is GetType(Boolean) OrElse 
               (col.DataPropertyName IsNot Nothing AndAlso 
                col.DataPropertyName.EndsWith("IsActive", StringComparison.OrdinalIgnoreCase)) Then
                col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
                col.HeaderCell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter
            End If
        Next
    End Sub

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click, txtSearch.KeyDown
        ' Handle Enter key in search box
        If TypeOf e Is KeyEventArgs AndAlso DirectCast(e, KeyEventArgs).KeyCode = Keys.Enter Then
            PerformSearch()
        ElseIf TypeOf e Is EventArgs Then
            ' Button click
            PerformSearch()
        End If
    End Sub

    Private Sub PerformSearch()
        Try
            If String.IsNullOrWhiteSpace(txtSearch.Text) Then
                LoadUsers()
            Else
                Dim searchResults = userService.SearchUsersInline(txtSearch.Text.Trim())
                If searchResults IsNot Nothing AndAlso searchResults.Rows.Count > 0 Then
                    dgvUsers.DataSource = searchResults
                    dgvUsers.AutoResizeColumns(DataGridViewAutoSizeColumnsMode.DisplayedCells)
                Else
                    MessageBox.Show("No users found matching your search criteria.", "No Results",
                                 MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            End If
        Catch ex As Exception
            MessageBox.Show($"Error searching users: {ex.Message}", "Search Error",
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub



    Private Sub btnEditUser_Click(sender As Object, e As EventArgs) Handles btnEditUser.Click, dgvUsers.DoubleClick
        If dgvUsers.SelectedRows.Count > 0 Then
            Try
                Dim userID As Integer = Convert.ToInt32(dgvUsers.SelectedRows(0).Cells("UserID").Value)
                Dim editForm As New UserAddEditForm(userID)
                If editForm.ShowDialog() = DialogResult.OK Then
                    LoadUsers()
                End If
            Catch ex As Exception
                MessageBox.Show($"Error editing user: {ex.Message}", "Edit Error",
                             MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        Else
            MessageBox.Show("Please select a user to edit.", "No Selection",
                         MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
    End Sub

    Private Sub btnDeleteUser_Click(sender As Object, e As EventArgs) Handles btnDeleteUser.Click
        If dgvUsers.SelectedRows.Count > 0 Then
            Try
                Dim username As String = dgvUsers.SelectedRows(0).Cells("Username").Value.ToString()
                Dim userID As Integer = Convert.ToInt32(dgvUsers.SelectedRows(0).Cells("UserID").Value)

                ' Check if trying to delete own account
                If userID = currentUserID Then
                    MessageBox.Show("You cannot deactivate your own account.", "Invalid Operation",
                                 MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                Dim result As DialogResult = MessageBox.Show(
                    $"Are you sure you want to deactivate user '{username}'?" & vbCrLf &
                    "This will prevent the user from logging in.",
                    "Confirm Deactivation",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question)

                If result = DialogResult.Yes Then
                    If userService.DeleteUserInline(userID) Then
                        MessageBox.Show("User deactivated successfully.", "Success",
                                     MessageBoxButtons.OK, MessageBoxIcon.Information)
                        LoadUsers()
                    Else
                        MessageBox.Show("Failed to deactivate user. Please try again.", "Error",
                                     MessageBoxButtons.OK, MessageBoxIcon.Error)
                    End If
                End If
            Catch ex As Exception
                MessageBox.Show($"Error deactivating user: {ex.Message}", "Deactivation Error",
                             MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        Else
            MessageBox.Show("Please select a user to deactivate.", "No Selection",
                         MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
    End Sub
    Private Sub UserManagementForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        ' Center the form on the screen
        Me.StartPosition = FormStartPosition.CenterScreen
        
        ' Set window state to maximized
        Me.WindowState = FormWindowState.Maximized
        
        ' Set minimum size
        Me.MinimumSize = New Size(1024, 768)
    End Sub
    
    Private Sub UserManagementForm_FormClosing(sender As Object, e As FormClosingEventArgs) Handles MyBase.FormClosing
        ' Clean up resources
        ' Note: Removed Dispose() call since UserService doesn't implement IDisposable
    End Sub
    
    Private Sub btnAddUser_Click(sender As Object, e As EventArgs) Handles btnAddUser.Click
        Try
            Using addForm As New UserAddEditForm()
                If addForm.ShowDialog() = DialogResult.OK Then
                    ' Refresh the user list after adding a new user
                    LoadUsers()
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error adding user: {ex.Message}", "Error", 
                          MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub dgvUsers_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvUsers.CellDoubleClick
        ' Only handle row clicks, not header clicks
        If e.RowIndex >= 0 Then
            btnEditUser.PerformClick()
        End If
    End Sub

    Private Sub dgvUsers_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvUsers.CellContentClick
        If e.RowIndex < 0 Then Return
        Dim colName = dgvUsers.Columns(e.ColumnIndex).Name
        If colName = "colEdit" Then
            btnEditUser.PerformClick()
        ElseIf colName = "colDeactivate" Then
            btnDeleteUser.PerformClick()
        End If
    End Sub
    
    Private Sub txtSearch_KeyDown(sender As Object, e As KeyEventArgs) Handles txtSearch.KeyDown
        ' Trigger search on Enter key
        If e.KeyCode = Keys.Enter Then
            btnSearch.PerformClick()
            e.Handled = True
            e.SuppressKeyPress = True
        End If
    End Sub

    Private Sub DgvUsers_DataBindingComplete(sender As Object, e As DataGridViewBindingCompleteEventArgs)
        ' Re-apply header styling after data binding to ensure colors/fonts persist
        Try
            dgvUsers.EnableHeadersVisualStyles = False
            dgvUsers.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(44, 62, 80)
            dgvUsers.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgvUsers.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI Semibold", 10.5F, FontStyle.Bold)
            dgvUsers.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleLeft
            dgvUsers.ColumnHeadersDefaultCellStyle.WrapMode = DataGridViewTriState.False
            dgvUsers.ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.Single
            dgvUsers.ColumnHeadersVisible = True
            dgvUsers.ColumnHeadersHeight = 34
            ' Reassert header text to avoid any data-binding resets
            Dim headerMap As New Dictionary(Of String, String) From {
                {"RoleName", "Role"},
                {"BranchName", "Branch"},
                {"FirstName", "First Name"},
                {"LastName", "Last Name"},
                {"Email", "Email"},
                {"Username", "Username"},
                {"IsActive", "Active"},
                {"TwoFactorEnabled", "2FA"},
                {"LastLogin", "Last Login"},
                {"FailedLoginAttempts", "Failed Attempts"},
                {"CreatedDate", "Created"}
            }
            For Each col As DataGridViewColumn In dgvUsers.Columns
                If headerMap.ContainsKey(col.DataPropertyName) Then
                    col.HeaderText = headerMap(col.DataPropertyName)
                End If
            Next
            dgvUsers.Refresh()
        Catch
            ' ignore styling errors
        End Try
    End Sub
End Class
