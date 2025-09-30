Imports System
Imports System.Windows.Forms
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports Oven_Delights_ERP.Logging
Imports Oven_Delights_ERP.Models
Imports System.Diagnostics
Imports System.Data

Partial Class BranchManagementForm
    Inherits Form

    Private ReadOnly _branchService As New BranchService()
    Private ReadOnly _currentUserId As Integer
    Private ReadOnly _connectionString As String
    Private ReadOnly _logger As ILogger = New DebugLogger()
    
    ' Controls are now properly declared in the Designer file with WithEvents

    Public Sub New(currentUserId As Integer)
        Try
            InitializeComponent()
            _currentUserId = currentUserId
            _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            
            If String.IsNullOrEmpty(_connectionString) Then
                Throw New ConfigurationErrorsException("Database connection string is not configured.")
            End If
            
            ConfigureDataGridView()
            LoadBranches()
        Catch ex As Exception
            _logger.LogError($"Error initializing BranchManagementForm: {ex.Message}")
            MessageBox.Show($"Failed to initialize form: {ex.Message}", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.DialogResult = DialogResult.Abort
            Me.Close()
        End Try
    End Sub

    Private Sub ConfigureDataGridView()
        ' Configure columns for better display
        dgvBranches.AutoGenerateColumns = False
        dgvBranches.AllowUserToAddRows = False
        dgvBranches.AllowUserToDeleteRows = False
        dgvBranches.ReadOnly = True
        dgvBranches.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvBranches.MultiSelect = False
        dgvBranches.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        dgvBranches.AllowUserToResizeRows = False
        dgvBranches.RowHeadersVisible = False
        dgvBranches.BackgroundColor = SystemColors.Window
        dgvBranches.BorderStyle = BorderStyle.None
        dgvBranches.CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal
        dgvBranches.GridColor = Color.FromArgb(240, 240, 240)
        
        ' Set up the grid's appearance
        dgvBranches.DefaultCellStyle.SelectionBackColor = Color.FromArgb(0, 122, 204)
        dgvBranches.DefaultCellStyle.SelectionForeColor = Color.White
        dgvBranches.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(250, 250, 250)
        dgvBranches.RowsDefaultCellStyle.Padding = New Padding(3)
        dgvBranches.DefaultCellStyle.Font = New Font("Segoe UI", 9.0F, FontStyle.Regular)
        
        ' Clear existing columns
        dgvBranches.Columns.Clear()
        
        ' Add columns with proper mapping and formatting
        dgvBranches.Columns.Add(New DataGridViewTextBoxColumn() With {
            .Name = "colID",
            .DataPropertyName = "ID",
            .HeaderText = "ID",
            .Visible = False
        })
        
        dgvBranches.Columns.Add(New DataGridViewTextBoxColumn() With {
            .Name = "colBranchCode",
            .DataPropertyName = "BranchCode",
            .HeaderText = "Branch Code",
            .Width = 100,
            .HeaderCell = New DataGridViewColumnHeaderCell() With {.Style = New DataGridViewCellStyle() With {.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}}
        })
        
        dgvBranches.Columns.Add(New DataGridViewTextBoxColumn() With {
            .Name = "colBranchName",
            .DataPropertyName = "BranchName",
            .HeaderText = "Branch Name",
            .Width = 150,
            .HeaderCell = New DataGridViewColumnHeaderCell() With {.Style = New DataGridViewCellStyle() With {.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}}
        })
        
        dgvBranches.Columns.Add(New DataGridViewTextBoxColumn() With {
            .Name = "colPrefix",
            .DataPropertyName = "Prefix",
            .HeaderText = "Prefix",
            .Width = 70,
            .HeaderCell = New DataGridViewColumnHeaderCell() With {.Style = New DataGridViewCellStyle() With {.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}},
            .DefaultCellStyle = New DataGridViewCellStyle() With {.Alignment = DataGridViewContentAlignment.MiddleCenter}
        })
        
        dgvBranches.Columns.Add(New DataGridViewTextBoxColumn() With {
            .Name = "colAddress",
            .DataPropertyName = "Address",
            .HeaderText = "Address",
            .Width = 200,
            .HeaderCell = New DataGridViewColumnHeaderCell() With {.Style = New DataGridViewCellStyle() With {.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}}
        })
        
        dgvBranches.Columns.Add(New DataGridViewTextBoxColumn() With {
            .Name = "colCity",
            .DataPropertyName = "City",
            .HeaderText = "City",
            .Width = 100,
            .HeaderCell = New DataGridViewColumnHeaderCell() With {.Style = New DataGridViewCellStyle() With {.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}}
        })
        
        dgvBranches.Columns.Add(New DataGridViewTextBoxColumn() With {
            .Name = "colProvince",
            .DataPropertyName = "Province",
            .HeaderText = "Province",
            .Width = 100,
            .HeaderCell = New DataGridViewColumnHeaderCell() With {.Style = New DataGridViewCellStyle() With {.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}}
        })
        
        dgvBranches.Columns.Add(New DataGridViewTextBoxColumn() With {
            .Name = "colPostalCode",
            .DataPropertyName = "PostalCode",
            .HeaderText = "Postal Code",
            .Width = 90,
            .HeaderCell = New DataGridViewColumnHeaderCell() With {.Style = New DataGridViewCellStyle() With {.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}}
        })
        
        dgvBranches.Columns.Add(New DataGridViewTextBoxColumn() With {
            .Name = "colPhone",
            .DataPropertyName = "Phone",
            .HeaderText = "Phone",
            .Width = 120,
            .HeaderCell = New DataGridViewColumnHeaderCell() With {.Style = New DataGridViewCellStyle() With {.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}}
        })
        
        dgvBranches.Columns.Add(New DataGridViewTextBoxColumn() With {
            .Name = "colEmail",
            .DataPropertyName = "Email",
            .HeaderText = "Email",
            .Width = 180,
            .HeaderCell = New DataGridViewColumnHeaderCell() With {.Style = New DataGridViewCellStyle() With {.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}}
        })
        
        dgvBranches.Columns.Add(New DataGridViewTextBoxColumn() With {
            .Name = "colManagerName",
            .DataPropertyName = "ManagerName",
            .HeaderText = "Manager",
            .Width = 150,
            .HeaderCell = New DataGridViewColumnHeaderCell() With {.Style = New DataGridViewCellStyle() With {.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}}
        })
        
        dgvBranches.Columns.Add(New DataGridViewCheckBoxColumn() With {
            .Name = "colIsActive",
            .DataPropertyName = "IsActive",
            .HeaderText = "Active",
            .Width = 60,
            .HeaderCell = New DataGridViewColumnHeaderCell() With {.Style = New DataGridViewCellStyle() With {.Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}},
            .DefaultCellStyle = New DataGridViewCellStyle() With {.Alignment = DataGridViewContentAlignment.MiddleCenter}
        })
    End Sub

    Private Sub LoadBranches()
        Try
            Cursor = Cursors.WaitCursor
            Dim branches = _branchService.GetAllBranches()
            
            ' Check if we got valid data
            If branches Is Nothing OrElse branches.Rows.Count = 0 Then
                _logger.LogInformation("No branches found in the database")
                ' Clear the grid if no data
                dgvBranches.DataSource = Nothing
                Return
            End If
            
            dgvBranches.DataSource = branches
            _logger.LogInformation($"Loaded {branches.Rows.Count} branches")
            
        Catch ex As Exception
            _logger.LogError($"Error loading branches: {ex.Message}")
            MessageBox.Show($"An error occurred while loading branches: {ex.Message}", 
                          "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Finally
            Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub btnAddBranch_Click(sender As Object, e As EventArgs) Handles btnAddBranch.Click
        Dim addForm As New BranchAddEditForm(_currentUserId)
        If addForm.ShowDialog() = DialogResult.OK Then
            LoadBranches()
        End If
    End Sub

    Private Sub btnEditBranch_Click(sender As Object, e As EventArgs) Handles btnEditBranch.Click
        If dgvBranches.SelectedRows.Count > 0 Then
            Dim branchId = Convert.ToInt32(dgvBranches.SelectedRows(0).Cells("colID").Value)
            Dim editForm As New BranchAddEditForm(branchId, _currentUserId)
            If editForm.ShowDialog() = DialogResult.OK Then
                LoadBranches()
            End If
        Else
            MessageBox.Show("Please select a branch to edit.", "No Selection", 
                          MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
    End Sub
    
    Private Sub btnDeleteBranch_Click(sender As Object, e As EventArgs) Handles btnDeleteBranch.Click
        If dgvBranches.SelectedRows.Count > 0 Then
            Dim branchId = Convert.ToInt32(dgvBranches.SelectedRows(0).Cells("colID").Value)
            Dim branchName = dgvBranches.SelectedRows(0).Cells("colBranchName").Value.ToString()
            
            If MessageBox.Show($"Are you sure you want to delete branch: {branchName}?" & vbCrLf & 
                             "This will only deactivate the branch if there are no active users.", 
                             "Confirm Delete", 
                             MessageBoxButtons.YesNo, 
                             MessageBoxIcon.Question) = DialogResult.Yes Then
                Try
                    If _branchService.DeleteBranch(branchId, _currentUserId) Then
                        MessageBox.Show("Branch deleted successfully.", "Success", 
                                      MessageBoxButtons.OK, MessageBoxIcon.Information)
                        LoadBranches()
                    End If
                Catch ex As Exception
                    MessageBox.Show($"Error deleting branch: {ex.Message}", "Error", 
                                  MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        Else
            MessageBox.Show("Please select a branch to delete.", "No Selection", 
                          MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
    End Sub
    
    Private Sub btnRefresh_Click(sender As Object, e As EventArgs)
        LoadBranches()
    End Sub
    
    Private Sub txtSearch_TextChanged(sender As Object, e As EventArgs)
        Try
            If dgvBranches.DataSource IsNot Nothing Then
                Dim dt = CType(dgvBranches.DataSource, DataTable)
                If Not String.IsNullOrWhiteSpace(txtSearch.Text) Then
                    ' Escape special characters to prevent injection
                    Dim searchText = txtSearch.Text.Replace("'", "''").Replace("%", "[%]")
                    
                    ' Use parameterized filter to prevent SQL injection
                    dt.DefaultView.RowFilter = $"BranchName LIKE '%{searchText}%' OR " & 
                                            $"BranchCode LIKE '%{searchText}%' OR " &
                                            $"Phone LIKE '%{searchText}%' OR " &
                                            $"Email LIKE '%{searchText}%'"
                    
                    _logger.LogDebug($"Applied search filter: {searchText}")
                Else
                    dt.DefaultView.RowFilter = String.Empty
                End If
            End If
        Catch ex As Exception
            _logger.LogError($"Error applying search filter: {ex.Message}")
            ' Don't show error to user for search functionality
        End Try
    End Sub



    Private Function DeactivateBranch(branchId As Integer) As Boolean
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' First check if there are active users in this branch
                Dim checkUsersQuery = "SELECT COUNT(*) FROM Users WHERE BranchID = @branchId AND IsActive = 1"
                Dim userCount As Integer
                
                Using cmd As New SqlCommand(checkUsersQuery, conn)
                    cmd.CommandType = CommandType.Text
                    cmd.Parameters.AddWithValue("@branchId", branchId)
                    userCount = Convert.ToInt32(cmd.ExecuteScalar())
                End Using
                
                If userCount > 0 Then
                    MessageBox.Show($"Cannot deactivate branch. There are {userCount} active user(s) assigned to this branch.", 
                                  "Cannot Deactivate", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return False
                End If
                
                ' Determine key column at runtime (ID vs BranchID)
                Dim keyCol As String
                Using cmdKey As New SqlCommand("SELECT CASE WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Branches' AND COLUMN_NAME='ID') THEN 'ID' ELSE 'BranchID' END", conn)
                    cmdKey.CommandType = CommandType.Text
                    keyCol = Convert.ToString(cmdKey.ExecuteScalar())
                End Using

                ' Proceed with deactivation
                Dim updateQuery = $"UPDATE Branches SET IsActive = 0, ModifiedDate = GETDATE() WHERE {keyCol} = @branchId"
                
                Using cmd As New SqlCommand(updateQuery, conn)
                    cmd.CommandType = CommandType.Text
                    cmd.Parameters.AddWithValue("@branchId", branchId)
                    Dim rowsAffected = cmd.ExecuteNonQuery()
                    
                    If rowsAffected > 0 Then
                        _logger.LogInformation($"Successfully deactivated branch ID: {branchId}")
                        LogAuditAction("BranchDeactivated", "Branches", branchId, $"Deactivated branch ID: {branchId}")
                        Return True
                    End If
                    
                    _logger.LogWarning($"No rows affected when deactivating branch ID: {branchId}")
                    Return False
                End Using
            End Using
        Catch ex As Exception
            _logger.LogError($"Error deactivating branch ID {branchId}: {ex.Message}")
            MessageBox.Show($"An error occurred while deactivating the branch: {ex.Message}", 
                          "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        End Try
    End Function

    Private Sub LogAuditAction(action As String, tableName As String, recordID As Integer, details As String)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim query As String = """
                    INSERT INTO AuditLog 
                        (UserID, Action, TableName, RecordID, Details, Timestamp) 
                    VALUES 
                        (@userID, @action, @tableName, @recordID, @details, GETDATE())
                """
                
                Using cmd As New SqlCommand(query, conn)
                    cmd.CommandType = CommandType.Text
                    cmd.Parameters.AddWithValue("@userID", _currentUserId)
                    cmd.Parameters.AddWithValue("@action", action)
                    cmd.Parameters.AddWithValue("@tableName", tableName)
                    cmd.Parameters.AddWithValue("@recordID", recordID)
                    cmd.Parameters.AddWithValue("@details", If(String.IsNullOrEmpty(details), DBNull.Value, details))
                    
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            ' Log error but don't throw - audit logging failure shouldn't prevent main operation
            _logger.LogError($"Error logging audit action: {ex.Message}")
        End Try
    End Sub
End Class
