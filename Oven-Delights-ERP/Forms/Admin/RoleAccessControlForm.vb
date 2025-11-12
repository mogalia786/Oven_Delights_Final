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
        MessageBox.Show("Scanning MainDashboard for all menus...", "Refreshing", MessageBoxButtons.OK, MessageBoxIcon.Information)
        ReloadGrid()
        MessageBox.Show($"Found {_dt.Rows.Count} menu items!", "Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub ReloadGrid()
        Try
            Dim roleId As Integer = GetSelectedRoleId()
            BuildGrid()
            
            ' Get all menu items from MainDashboard dynamically
            Dim modules As New List(Of String)()
            
            ' Find the MainDashboard form
            Dim mainDashboard As Form = Nothing
            Dim formCount As Integer = 0
            For Each frm As Form In Application.OpenForms
                formCount += 1
                System.Diagnostics.Debug.WriteLine($"Found form: {frm.GetType().Name}")
                If frm.GetType().Name = "MainDashboard" Then
                    mainDashboard = frm
                    Exit For
                End If
            Next
            
            System.Diagnostics.Debug.WriteLine($"Total forms open: {formCount}, MainDashboard found: {mainDashboard IsNot Nothing}")
            
            If mainDashboard IsNot Nothing Then
                ' Get MenuStrip from MainDashboard
                Dim menuStrip As MenuStrip = Nothing
                For Each ctrl As Control In mainDashboard.Controls
                    If TypeOf ctrl Is MenuStrip Then
                        menuStrip = CType(ctrl, MenuStrip)
                        System.Diagnostics.Debug.WriteLine($"Found MenuStrip with {menuStrip.Items.Count} top-level items")
                        Exit For
                    End If
                Next
                
                If menuStrip IsNot Nothing Then
                    ' Scan all menu items recursively
                    For Each topItem As ToolStripMenuItem In menuStrip.Items.OfType(Of ToolStripMenuItem)()
                        ' Add top-level menu
                        Dim topMenuText = topItem.Text.Replace("&", "")
                        modules.Add(topMenuText)
                        System.Diagnostics.Debug.WriteLine($"Top menu: {topMenuText} ({topItem.DropDownItems.Count} subitems)")
                        
                        ' Add all submenus recursively
                        ScanSubMenus(topItem, topMenuText, modules)
                    Next
                    System.Diagnostics.Debug.WriteLine($"Total menus scanned: {modules.Count}")
                Else
                    System.Diagnostics.Debug.WriteLine("MenuStrip not found in MainDashboard!")
                End If
            Else
                System.Diagnostics.Debug.WriteLine("MainDashboard form not found!")
            End If
            
            ' If no menus found from MainDashboard, use fallback list
            If modules.Count = 0 Then
                modules.AddRange({
                    "Administration", "Stockroom", "Manufacturing", "Retail", "Accounting", "Reporting", "Utilities"
                })
            End If
            
            ' Load permissions for each module
            For Each moduleName As String In modules
                Dim canRead As Boolean = False
                Dim canWrite As Boolean = False
                
                If roleId > 0 Then
                    ' Load existing permissions for this role and module
                    Using conn As New SqlConnection(_connStr)
                        conn.Open()
                        Dim sql = "SELECT CanRead, CanWrite FROM RolePermissions WHERE RoleID = @roleId AND ModuleName = @module"
                        Using cmd As New SqlCommand(sql, conn)
                            cmd.Parameters.AddWithValue("@roleId", roleId)
                            cmd.Parameters.AddWithValue("@module", moduleName)
                            Using reader = cmd.ExecuteReader()
                                If reader.Read() Then
                                    canRead = Convert.ToBoolean(reader("CanRead"))
                                    canWrite = Convert.ToBoolean(reader("CanWrite"))
                                End If
                            End Using
                        End Using
                    End Using
                End If
                
                _dt.Rows.Add(moduleName, moduleName, "Module", canRead, canWrite)
            Next
            
        Catch ex As Exception
            MessageBox.Show("Failed to load permissions: " & ex.Message)
        End Try
    End Sub
    
    Private Sub ScanSubMenus(parentItem As ToolStripMenuItem, parentPath As String, ByRef modules As List(Of String))
        For Each subItem As ToolStripMenuItem In parentItem.DropDownItems.OfType(Of ToolStripMenuItem)()
            Dim menuPath = parentPath & " > " & subItem.Text.Replace("&", "").Replace("…", "")
            modules.Add(menuPath)
            
            ' Recursively scan deeper levels
            If subItem.DropDownItems.Count > 0 Then
                ScanSubMenus(subItem, menuPath, modules)
            End If
        Next
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
