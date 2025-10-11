Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class RolePermissionService
    Private ReadOnly _connStr As String

    Public Sub New()
        _connStr = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
    End Sub

    ' Check if user has specific permission
    Public Function HasPermission(userId As Integer, permissionName As String) As Boolean
        Try
            Using conn As New SqlConnection(_connStr)
                Dim sql = "SELECT COUNT(*) FROM Users u " &
                         "INNER JOIN RolePermissions rp ON rp.RoleID = u.RoleID " &
                         "INNER JOIN Permissions p ON p.PermissionID = rp.PermissionID " &
                         "WHERE u.UserID = @userId AND p.PermissionName = @permissionName " &
                         "AND u.IsActive = 1 AND p.IsActive = 1"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@userId", userId)
                    cmd.Parameters.AddWithValue("@permissionName", permissionName)
                    conn.Open()
                    Return Convert.ToInt32(cmd.ExecuteScalar()) > 0
                End Using
            End Using
        Catch
            Return False
        End Try
    End Function

    ' Check if current session user has permission
    Public Function HasPermission(permissionName As String) As Boolean
        If AppSession.CurrentUserID <= 0 Then Return False
        Return HasPermission(AppSession.CurrentUserID, permissionName)
    End Function

    ' Get all permissions for a role
    Public Function GetRolePermissions(roleId As Integer) As List(Of String)
        Dim permissions As New List(Of String)()
        Try
            Using conn As New SqlConnection(_connStr)
                Dim sql = "SELECT p.PermissionName FROM RolePermissions rp " &
                         "INNER JOIN Permissions p ON p.PermissionID = rp.PermissionID " &
                         "WHERE rp.RoleID = @roleId AND p.IsActive = 1"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@roleId", roleId)
                    conn.Open()
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            permissions.Add(reader("PermissionName").ToString())
                        End While
                    End Using
                End Using
            End Using
        Catch
        End Try
        Return permissions
    End Function

    ' Check if user is Super Administrator (bypass all permission checks)
    Public Function IsSuperAdmin(userId As Integer) As Boolean
        Try
            Using conn As New SqlConnection(_connStr)
                Dim sql = "SELECT COUNT(*) FROM Users u " &
                         "INNER JOIN Roles r ON r.RoleID = u.RoleID " &
                         "WHERE u.UserID = @userId AND r.RoleName = 'Super Administrator' " &
                         "AND u.IsActive = 1 AND r.IsActive = 1"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@userId", userId)
                    conn.Open()
                    Return Convert.ToInt32(cmd.ExecuteScalar()) > 0
                End Using
            End Using
        Catch
            Return False
        End Try
    End Function

    ' Check if current session user is Super Administrator
    Public Function IsSuperAdmin() As Boolean
        If AppSession.CurrentUserID <= 0 Then Return False
        Return IsSuperAdmin(AppSession.CurrentUserID)
    End Function

    ' Get user's role name
    Public Function GetUserRole(userId As Integer) As String
        Try
            Using conn As New SqlConnection(_connStr)
                Dim sql = "SELECT r.RoleName FROM Users u " &
                         "INNER JOIN Roles r ON r.RoleID = u.RoleID " &
                         "WHERE u.UserID = @userId AND u.IsActive = 1"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@userId", userId)
                    conn.Open()
                    Dim result = cmd.ExecuteScalar()
                    Return If(result IsNot Nothing, result.ToString(), "")
                End Using
            End Using
        Catch
            Return ""
        End Try
    End Function

    ' Check if user has any of the specified permissions (OR logic)
    Public Function HasAnyPermission(userId As Integer, ParamArray permissionNames As String()) As Boolean
        If permissionNames Is Nothing OrElse permissionNames.Length = 0 Then Return False
        
        Try
            Using conn As New SqlConnection(_connStr)
                Dim placeholders = String.Join(",", permissionNames.Select(Function(p, i) $"@perm{i}"))
                Dim sql = $"SELECT COUNT(*) FROM Users u " &
                         $"INNER JOIN RolePermissions rp ON rp.RoleID = u.RoleID " &
                         $"INNER JOIN Permissions p ON p.PermissionID = rp.PermissionID " &
                         $"WHERE u.UserID = @userId AND p.PermissionName IN ({placeholders}) " &
                         $"AND u.IsActive = 1 AND p.IsActive = 1"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@userId", userId)
                    For i As Integer = 0 To permissionNames.Length - 1
                        cmd.Parameters.AddWithValue($"@perm{i}", permissionNames(i))
                    Next
                    conn.Open()
                    Return Convert.ToInt32(cmd.ExecuteScalar()) > 0
                End Using
            End Using
        Catch
            Return False
        End Try
    End Function

    ' Check if current session user has any of the specified permissions
    Public Function HasAnyPermission(ParamArray permissionNames As String()) As Boolean
        If AppSession.CurrentUserID <= 0 Then Return False
        Return HasAnyPermission(AppSession.CurrentUserID, permissionNames)
    End Function

    ' Apply role-based menu visibility
    Public Sub ApplyMenuSecurity(menuStrip As MenuStrip)
        If menuStrip Is Nothing Then Return
        
        Try
            Dim userId = AppSession.CurrentUserID
            If userId <= 0 Then Return
            
            ' Super Admin sees everything
            If IsSuperAdmin(userId) Then Return
            
            ' Apply role-based restrictions
            For Each item As ToolStripItem In menuStrip.Items
                If TypeOf item Is ToolStripMenuItem Then
                    ApplyMenuItemSecurity(CType(item, ToolStripMenuItem), userId)
                End If
            Next
        Catch
        End Try
    End Sub

    Private Sub ApplyMenuItemSecurity(menuItem As ToolStripMenuItem, userId As Integer)
        Select Case menuItem.Text.ToLower()
            Case "administration", "administrator"
                menuItem.Visible = IsSuperAdmin(userId)
            Case "retail"
                menuItem.Visible = HasAnyPermission(userId, "POS_ACCESS", "PRODUCT_VIEW", "STOCK_VIEW", "SALES_PROCESS")
            Case "accounting"
                menuItem.Visible = HasAnyPermission(userId, "ACCOUNTING_ACCESS", "FINANCIAL_REPORTS")
            Case "stockroom"
                menuItem.Visible = HasAnyPermission(userId, "INVENTORY_MANAGEMENT", "STOCK_CONTROL")
            Case "manufacturing"
                menuItem.Visible = HasAnyPermission(userId, "MANUFACTURING_ACCESS", "PRODUCTION_CONTROL")
        End Select
        
        ' Apply to sub-items
        For Each subItem As ToolStripItem In menuItem.DropDownItems
            If TypeOf subItem Is ToolStripMenuItem Then
                ApplySubMenuSecurity(CType(subItem, ToolStripMenuItem), userId)
            End If
        Next
    End Sub

    Private Sub ApplySubMenuSecurity(subMenuItem As ToolStripMenuItem, userId As Integer)
        Select Case subMenuItem.Text.ToLower()
            Case "point of sale", "pos"
                subMenuItem.Visible = HasPermission(userId, "POS_ACCESS")
            Case "product management", "products"
                subMenuItem.Visible = HasAnyPermission(userId, "PRODUCT_EDIT", "PRODUCT_VIEW")
            Case "price management"
                subMenuItem.Visible = HasPermission(userId, "PRICE_MANAGEMENT")
            Case "stock overview", "stock on hand"
                subMenuItem.Visible = HasPermission(userId, "STOCK_VIEW")
            Case "user management"
                subMenuItem.Visible = IsSuperAdmin(userId)
            Case "branch management"
                subMenuItem.Visible = IsSuperAdmin(userId)
        End Select
    End Sub
End Class
