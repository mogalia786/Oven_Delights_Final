Imports System.Data
Imports Microsoft.Data.SqlClient

Public Class RoleAccessControlForm
    Private _dt As DataTable
    Private _perm As New PermissionService()
    Private _connectionString As String
    Private _connStr As String

    Private Sub RoleAccessControlForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Role Access Control"
        _connStr = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        Try
            LoadRoles()
            If cboRole.Items.Count > 0 Then
                cboRole.SelectedIndex = 0
                ReloadGrid()
            Else
                BuildGrid()
            End If
        Catch
            ' Fallback to empty grid if roles not available
            BuildGrid()
        End Try
    End Sub

    Private Sub BuildGrid()
        _dt = New DataTable()
        _dt.Columns.Add("FeatureKey")
        _dt.Columns.Add("DisplayName")
        _dt.Columns.Add("Category")
        _dt.Columns.Add("CanRead", GetType(Boolean))
        _dt.Columns.Add("CanWrite", GetType(Boolean))
        dgv.DataSource = _dt
        dgv.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Try
            Dim roleId As Integer = GetSelectedRoleId()
            If roleId <= 0 Then
                MessageBox.Show("Select a role first.")
                Return
            End If
            SaveRolePermissions(roleId)
            MessageBox.Show("Permissions saved.")
        Catch ex As Exception
            MessageBox.Show("Failed to save: " & ex.Message)
        End Try
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub

    Private Sub btnReload_Click(sender As Object, e As EventArgs) Handles btnReload.Click
        Try
            Dim roleId As Integer = GetSelectedRoleId()
            If roleId <= 0 Then
                MessageBox.Show("Please select a role first.", "No Role Selected", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Clear all existing permissions for this role
            Using conn As New SqlConnection(_connStr)
                conn.Open()
                Using cmd As New SqlCommand("DELETE FROM RolePermissions WHERE RoleID = @roleId", conn)
                    cmd.Parameters.AddWithValue("@roleId", roleId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            
            MessageBox.Show("Scanning MainDashboard for all menus...", "Refreshing", MessageBoxButtons.OK, MessageBoxIcon.Information)
            ReloadGrid()
            MessageBox.Show($"Found {_dt.Rows.Count} menu items! Please review and save permissions.", "Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Error reloading: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ReloadGrid()
        Try
            Dim roleId As Integer = GetSelectedRoleId()
            BuildGrid()
            
            ' Load all menus from MenuRegistry table
            Using conn As New SqlConnection(_connStr)
                conn.Open()
                Dim sql = "SELECT MenuPath, DisplayName FROM MenuRegistry WHERE IsActive = 1 ORDER BY MenuPath"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim menuPath As String = reader("MenuPath").ToString()
                            Dim displayName As String = reader("DisplayName").ToString()
                            Dim canRead As Boolean = False
                            Dim canWrite As Boolean = False
                            
                            ' Check if we need to load existing permissions
                            If roleId > 0 Then
                                Using conn2 As New SqlConnection(_connStr)
                                    conn2.Open()
                                    Dim sqlPerm = "SELECT CanRead, CanWrite FROM RolePermissions WHERE RoleID = @roleId AND ModuleName = @module"
                                    Using cmdPerm As New SqlCommand(sqlPerm, conn2)
                                        cmdPerm.Parameters.AddWithValue("@roleId", roleId)
                                        cmdPerm.Parameters.AddWithValue("@module", menuPath)
                                        Using readerPerm = cmdPerm.ExecuteReader()
                                            If readerPerm.Read() Then
                                                canRead = Convert.ToBoolean(readerPerm("CanRead"))
                                                canWrite = Convert.ToBoolean(readerPerm("CanWrite"))
                                            End If
                                        End Using
                                    End Using
                                End Using
                            End If
                            
                            _dt.Rows.Add(menuPath, menuPath, "Menu", canRead, canWrite)
                        End While
                    End Using
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show("Failed to load permissions: " & ex.Message)
        End Try
    End Sub
    

    Private Sub LoadRoles()
        cboRole.Items.Clear()
        Using cn As New SqlConnection(_connStr)
            Using da As New SqlDataAdapter("SELECT RoleID, RoleName FROM dbo.Roles ORDER BY RoleName", cn)
                Dim dt As New DataTable()
                da.Fill(dt)
                cboRole.DisplayMember = "RoleName"
                cboRole.ValueMember = "RoleID"
                cboRole.DataSource = dt
            End Using
        End Using
    End Sub

    Private Function GetSelectedRoleId() As Integer
        If cboRole Is Nothing OrElse cboRole.SelectedValue Is Nothing Then Return 0
        Dim v = cboRole.SelectedValue
        If TypeOf v Is DBNull Then Return 0
        Return Convert.ToInt32(v)
    End Function

    Private Sub SaveRolePermissions(roleId As Integer)
        Using conn As New SqlConnection(_connStr)
            conn.Open()
            
            ' Delete existing permissions for this role
            Using cmd As New SqlCommand("DELETE FROM RolePermissions WHERE RoleID = @roleId", conn)
                cmd.Parameters.AddWithValue("@roleId", roleId)
                cmd.ExecuteNonQuery()
            End Using
            
            ' Insert new permissions
            For Each row As DataRow In _dt.Rows
                Dim moduleName As String = row("FeatureKey").ToString()
                Dim canRead As Boolean = Convert.ToBoolean(row("CanRead"))
                Dim canWrite As Boolean = Convert.ToBoolean(row("CanWrite"))
                
                Using cmd As New SqlCommand("INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite) VALUES (@roleId, @module, @canRead, @canWrite)", conn)
                    cmd.Parameters.AddWithValue("@roleId", roleId)
                    cmd.Parameters.AddWithValue("@module", moduleName)
                    cmd.Parameters.AddWithValue("@canRead", canRead)
                    cmd.Parameters.AddWithValue("@canWrite", canWrite)
                    cmd.ExecuteNonQuery()
                End Using
            Next
        End Using
    End Sub

    Private Sub cboRole_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboRole.SelectedIndexChanged
        ReloadGrid()
    End Sub
End Class
