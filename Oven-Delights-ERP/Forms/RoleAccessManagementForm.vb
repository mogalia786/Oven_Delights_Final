Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

Public Class RoleAccessManagementForm
    Inherits Form
    
    Private _connectionString As String
    Private _currentRoleID As Integer = 0
    
    Private cmbRole As ComboBox
    Private tvMenus As TreeView
    Private btnSave As Button
    Private btnCancel As Button
    Private lblStatus As Label
    
    ' Color scheme
    Private _darkBlue As Color = ColorTranslator.FromHtml("#2C3E50")
    Private _lightBlue As Color = ColorTranslator.FromHtml("#3498DB")
    Private _green As Color = ColorTranslator.FromHtml("#27AE60")
    Private _red As Color = ColorTranslator.FromHtml("#E74C3C")
    Private _orange As Color = ColorTranslator.FromHtml("#E67E22")
    
    Public Sub New()
        MyBase.New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        InitializeComponent()
        LoadRoles()
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "Role Access Management"
        Me.Size = New Size(900, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.BackColor = Color.White
        
        ' Header Panel
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 100,
            .BackColor = _darkBlue
        }
        
        Dim lblTitle As New Label With {
            .Text = "🔐 ROLE ACCESS MANAGEMENT",
            .Font = New Font("Segoe UI", 24, FontStyle.Bold),
            .ForeColor = Color.White,
            .Location = New Point(30, 30),
            .AutoSize = True
        }
        
        pnlHeader.Controls.Add(lblTitle)
        
        ' Content Panel
        Dim pnlContent As New Panel With {
            .Location = New Point(0, 100),
            .Size = New Size(900, 500),
            .BackColor = Color.White,
            .Padding = New Padding(30)
        }
        
        ' Role Selection
        Dim lblRole As New Label With {
            .Text = "Select Role:",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = _darkBlue,
            .Location = New Point(30, 20),
            .AutoSize = True
        }
        
        cmbRole = New ComboBox With {
            .Font = New Font("Segoe UI", 13),
            .Location = New Point(30, 55),
            .Size = New Size(400, 35),
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        AddHandler cmbRole.SelectedIndexChanged, AddressOf CmbRole_SelectedIndexChanged
        
        ' Info Label
        Dim lblInfo As New Label With {
            .Text = "Check/uncheck menus and sub-menus to control access for this role." & vbCrLf & 
                    "Unchecking a main menu will disable all its sub-menus.",
            .Font = New Font("Segoe UI", 10, FontStyle.Italic),
            .ForeColor = _orange,
            .Location = New Point(30, 100),
            .Size = New Size(840, 40)
        }
        
        ' TreeView for menu hierarchy
        Dim lblMenus As New Label With {
            .Text = "Menu Access Permissions:",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .ForeColor = _darkBlue,
            .Location = New Point(30, 150),
            .AutoSize = True
        }
        
        tvMenus = New TreeView With {
            .Location = New Point(30, 185),
            .Size = New Size(840, 280),
            .CheckBoxes = True,
            .Font = New Font("Segoe UI", 11),
            .BorderStyle = BorderStyle.FixedSingle
        }
        AddHandler tvMenus.AfterCheck, AddressOf TvMenus_AfterCheck
        
        ' Status Label
        lblStatus = New Label With {
            .Text = "",
            .Font = New Font("Segoe UI", 10, FontStyle.Italic),
            .ForeColor = _green,
            .Location = New Point(30, 475),
            .Size = New Size(840, 25),
            .TextAlign = ContentAlignment.MiddleLeft
        }
        
        pnlContent.Controls.AddRange({lblRole, cmbRole, lblInfo, lblMenus, tvMenus, lblStatus})
        
        ' Button Panel
        Dim pnlButtons As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 100,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1")
        }
        
        ' Add Menu Button
        Dim btnAddMenu As New Button With {
            .Text = "➕ ADD MENU",
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .Size = New Size(180, 60),
            .Location = New Point(30, 20),
            .BackColor = _orange,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnAddMenu.FlatAppearance.BorderSize = 0
        AddHandler btnAddMenu.Click, AddressOf BtnAddMenu_Click
        
        btnSave = New Button With {
            .Text = "💾 SAVE PERMISSIONS",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .Size = New Size(250, 60),
            .Location = New Point(330, 20),
            .BackColor = _green,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand,
            .Enabled = False
        }
        btnSave.FlatAppearance.BorderSize = 0
        AddHandler btnSave.Click, AddressOf BtnSave_Click
        
        btnCancel = New Button With {
            .Text = "✖ CANCEL",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .Size = New Size(180, 60),
            .Location = New Point(600, 20),
            .BackColor = _red,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnCancel.FlatAppearance.BorderSize = 0
        AddHandler btnCancel.Click, Sub() Me.Close()
        
        pnlButtons.Controls.AddRange({btnAddMenu, btnSave, btnCancel})
        
        Me.Controls.AddRange({pnlHeader, pnlContent, pnlButtons})
    End Sub
    
    Private Sub LoadRoles()
        Try
            cmbRole.Items.Clear()
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim sql = "SELECT RoleID, RoleName FROM Roles WHERE RoleName <> 'Super Administrator' ORDER BY RoleName"
                
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            cmbRole.Items.Add(New RoleItem With {
                                .RoleID = CInt(reader("RoleID")),
                                .RoleName = reader("RoleName").ToString()
                            })
                        End While
                    End Using
                End Using
            End Using
            
            If cmbRole.Items.Count > 0 Then
                cmbRole.SelectedIndex = 0
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error loading roles: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub CmbRole_SelectedIndexChanged(sender As Object, e As EventArgs)
        If cmbRole.SelectedIndex < 0 Then Return
        
        Dim selectedRole = CType(cmbRole.SelectedItem, RoleItem)
        _currentRoleID = selectedRole.RoleID
        
        LoadMenuHierarchy()
        LoadRolePermissions()
        
        btnSave.Enabled = True
        lblStatus.Text = $"Loaded permissions for: {selectedRole.RoleName}"
        lblStatus.ForeColor = _lightBlue
    End Sub
    
    Private Sub LoadMenuHierarchy()
        tvMenus.Nodes.Clear()
        
        Try
            ' Load menu structure from MenuRegistry table
            Dim menus As New Dictionary(Of String, List(Of String))
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Get all menus ordered by DisplayOrder
                Dim sql = "
                    SELECT MenuName, SubMenuName, DisplayOrder
                    FROM MenuRegistry
                    WHERE IsActive = 1
                    ORDER BY MenuName, DisplayOrder"
                
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim menuName = reader("MenuName").ToString()
                            Dim subMenuName = If(IsDBNull(reader("SubMenuName")), Nothing, reader("SubMenuName").ToString())
                            
                            ' Build dictionary structure
                            If String.IsNullOrEmpty(subMenuName) Then
                                ' Main menu entry
                                If Not menus.ContainsKey(menuName) Then
                                    menus(menuName) = New List(Of String)
                                End If
                            Else
                                ' Sub-menu entry
                                If Not menus.ContainsKey(menuName) Then
                                    menus(menuName) = New List(Of String)
                                End If
                                menus(menuName).Add(subMenuName)
                            End If
                        End While
                    End Using
                End Using
            End Using
            
            ' Build tree from loaded data
            For Each menuEntry In menus
                Dim mainNode As New TreeNode(menuEntry.Key) With {
                    .Tag = New MenuTag With {.MenuName = menuEntry.Key, .IsMainMenu = True}
                }
                
                For Each subMenu In menuEntry.Value
                    Dim subNode As New TreeNode(subMenu) With {
                        .Tag = New MenuTag With {.MenuName = menuEntry.Key, .SubMenuName = subMenu, .IsMainMenu = False}
                    }
                    mainNode.Nodes.Add(subNode)
                Next
                
                tvMenus.Nodes.Add(mainNode)
            Next
            
            tvMenus.ExpandAll()
            
        Catch ex As Exception
            MessageBox.Show($"Error loading menu structure: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub LoadRolePermissions()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim sql = "SELECT MenuName, SubMenuName, HasAccess FROM RoleMenuPermissions WHERE RoleID = @roleID"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@roleID", _currentRoleID)
                    
                    Dim permissions As New Dictionary(Of String, Boolean)
                    
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim menuName = reader("MenuName").ToString()
                            Dim subMenuName = If(IsDBNull(reader("SubMenuName")), Nothing, reader("SubMenuName").ToString())
                            Dim hasAccess = CBool(reader("HasAccess"))
                            
                            Dim key = If(String.IsNullOrEmpty(subMenuName), menuName, $"{menuName}|{subMenuName}")
                            permissions(key) = hasAccess
                        End While
                    End Using
                    
                    ' Apply permissions to tree
                    For Each mainNode As TreeNode In tvMenus.Nodes
                        Dim menuTag = CType(mainNode.Tag, MenuTag)
                        
                        ' Check main menu
                        If permissions.ContainsKey(menuTag.MenuName) Then
                            mainNode.Checked = permissions(menuTag.MenuName)
                        Else
                            mainNode.Checked = True ' Default to enabled
                        End If
                        
                        ' Check sub-menus
                        For Each subNode As TreeNode In mainNode.Nodes
                            Dim subTag = CType(subNode.Tag, MenuTag)
                            Dim subKey = $"{subTag.MenuName}|{subTag.SubMenuName}"
                            
                            If permissions.ContainsKey(subKey) Then
                                subNode.Checked = permissions(subKey)
                            Else
                                subNode.Checked = mainNode.Checked ' Inherit from parent
                            End If
                        Next
                    Next
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error loading permissions: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub TvMenus_AfterCheck(sender As Object, e As TreeViewEventArgs)
        ' Prevent recursive calls
        If e.Action = TreeViewAction.Unknown Then Return
        
        ' If main menu is unchecked, uncheck all sub-menus
        If e.Node.Level = 0 AndAlso Not e.Node.Checked Then
            For Each childNode As TreeNode In e.Node.Nodes
                childNode.Checked = False
            Next
        End If
        
        ' If main menu is checked, user can manually check sub-menus (don't auto-check)
        
        lblStatus.Text = "Permissions modified. Click SAVE to apply changes."
        lblStatus.ForeColor = _orange
    End Sub
    
    Private Sub BtnAddMenu_Click(sender As Object, e As EventArgs)
        Try
            Using addMenuDialog As New AddMenuDialog()
                If addMenuDialog.ShowDialog() = DialogResult.OK Then
                    ' Reload menu hierarchy to show new menu
                    LoadMenuHierarchy()
                    
                    ' Reload permissions for current role
                    If _currentRoleID > 0 Then
                        LoadRolePermissions()
                    End If
                    
                    lblStatus.Text = "✓ Menu added! Tree refreshed."
                    lblStatus.ForeColor = _green
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error opening Add Menu dialog: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub BtnSave_Click(sender As Object, e As EventArgs)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Using transaction = conn.BeginTransaction()
                    Try
                        ' Delete existing permissions for this role
                        Dim sqlDelete = "DELETE FROM RoleMenuPermissions WHERE RoleID = @roleID"
                        Using cmd As New SqlCommand(sqlDelete, conn, transaction)
                            cmd.Parameters.AddWithValue("@roleID", _currentRoleID)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' Insert new permissions
                        Dim sqlInsert = "INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess) VALUES (@roleID, @menuName, @subMenuName, @hasAccess)"
                        
                        For Each mainNode As TreeNode In tvMenus.Nodes
                            Dim menuTag = CType(mainNode.Tag, MenuTag)
                            
                            ' Save main menu permission
                            Using cmd As New SqlCommand(sqlInsert, conn, transaction)
                                cmd.Parameters.AddWithValue("@roleID", _currentRoleID)
                                cmd.Parameters.AddWithValue("@menuName", menuTag.MenuName)
                                cmd.Parameters.AddWithValue("@subMenuName", DBNull.Value)
                                cmd.Parameters.AddWithValue("@hasAccess", mainNode.Checked)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            ' Save sub-menu permissions
                            For Each subNode As TreeNode In mainNode.Nodes
                                Dim subTag = CType(subNode.Tag, MenuTag)
                                
                                Using cmd As New SqlCommand(sqlInsert, conn, transaction)
                                    cmd.Parameters.AddWithValue("@roleID", _currentRoleID)
                                    cmd.Parameters.AddWithValue("@menuName", subTag.MenuName)
                                    cmd.Parameters.AddWithValue("@subMenuName", subTag.SubMenuName)
                                    cmd.Parameters.AddWithValue("@hasAccess", subNode.Checked)
                                    cmd.ExecuteNonQuery()
                                End Using
                            Next
                        Next
                        
                        transaction.Commit()
                        
                        lblStatus.Text = "✓ Permissions saved successfully!"
                        lblStatus.ForeColor = _green
                        
                        MessageBox.Show("Role permissions saved successfully!" & vbCrLf & vbCrLf & 
                                      "Users with this role will see the updated menu access on their next login.", 
                                      "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        
                    Catch ex As Exception
                        transaction.Rollback()
                        Throw
                    End Try
                End Using
            End Using
            
        Catch ex As Exception
            lblStatus.Text = "✖ Error saving permissions"
            lblStatus.ForeColor = _red
            MessageBox.Show($"Error saving permissions: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    ' Helper classes
    Private Class RoleItem
        Public Property RoleID As Integer
        Public Property RoleName As String
        
        Public Overrides Function ToString() As String
            Return RoleName
        End Function
    End Class
    
    Private Class MenuTag
        Public Property MenuName As String
        Public Property SubMenuName As String
        Public Property IsMainMenu As Boolean
    End Class
End Class
