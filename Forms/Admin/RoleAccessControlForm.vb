Imports System.Data
Imports Microsoft.Data.SqlClient

Public Class RoleAccessControlForm
    Private _dt As DataTable
    Private _perm As New PermissionService()
    Private _connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Private Sub RoleAccessControlForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Role Access Control"
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
            _perm.SaveRolePermissions(roleId, _dt, AppSession.CurrentUserID)
            MessageBox.Show("Permissions saved.")
        Catch ex As Exception
            MessageBox.Show("Failed to save: " & ex.Message)
        End Try
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub

    Private Sub btnReload_Click(sender As Object, e As EventArgs) Handles btnReload.Click
        ReloadGrid()
    End Sub

    Private Sub ReloadGrid()
        Try
            Dim features = _perm.GetAllFeatures()
            Dim roleId As Integer = GetSelectedRoleId()
            Dim perms As DataTable = Nothing
            If roleId > 0 Then
                perms = _perm.GetRolePermissions(roleId)
            End If
            BuildGrid()
            If features IsNot Nothing Then
                For Each fr As DataRow In features.Rows
                    Dim key As String = Convert.ToString(fr("FeatureKey"))
                    Dim name As String = Convert.ToString(fr("DisplayName"))
                    Dim cat As String = Convert.ToString(fr("Category"))
                    Dim canRead As Boolean = False
                    Dim canWrite As Boolean = False
                    If perms IsNot Nothing Then
                        Dim found() = perms.Select($"FeatureKey = '{key.Replace("'", "''")}'")
                        If found IsNot Nothing AndAlso found.Length > 0 Then
                            Dim pr = found(0)
                            If Not pr.IsNull("CanRead") Then canRead = Convert.ToBoolean(pr("CanRead"))
                            If Not pr.IsNull("CanWrite") Then canWrite = Convert.ToBoolean(pr("CanWrite"))
                        End If
                    End If
                    _dt.Rows.Add(key, If(String.IsNullOrWhiteSpace(name), key, name), cat, canRead, canWrite)
                Next
            End If
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
End Class
