Imports System.Data
Imports Microsoft.Data.SqlClient

Public Class MenuRegistryScannerForm
    Private _connectionString As String
    Private _scannedMenus As New List(Of MenuInfo)
    Private btnSave As Button
    Private dgvMenus As DataGridView

    Private Structure MenuInfo
        Public MenuPath As String
        Public MenuLevel As Integer
        Public ParentPath As String
        Public DisplayName As String
        Public ModuleName As String
    End Structure

    Private Sub MenuRegistryScannerForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Menu Registry Scanner"
        Me.Size = New Size(900, 600)
        _connectionString = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString

        SetupUI()
    End Sub

    Private Sub SetupUI()
        Dim pnlTop As New Panel With {.Dock = DockStyle.Top, .Height = 80, .BackColor = Color.FromArgb(52, 73, 94)}
        Dim lblTitle As New Label With {
            .Text = "Menu Registry Scanner",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.White,
            .Location = New Point(20, 15),
            .AutoSize = True
        }
        Dim lblSub As New Label With {
            .Text = "Scan MainDashboard menus and update MenuRegistry table",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = Color.LightGray,
            .Location = New Point(20, 45),
            .AutoSize = True
        }
        pnlTop.Controls.AddRange({lblTitle, lblSub})

        Dim btnScan As New Button With {
            .Text = "Scan Menus",
            .Location = New Point(20, 100),
            .Size = New Size(150, 40),
            .BackColor = Color.FromArgb(46, 204, 113),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnScan.Click, AddressOf BtnScan_Click

        btnSave = New Button With {
            .Text = "Save to Database",
            .Location = New Point(180, 100),
            .Size = New Size(150, 40),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Enabled = False
        }
        AddHandler btnSave.Click, AddressOf BtnSave_Click

        Dim btnClose As New Button With {
            .Text = "Close",
            .Location = New Point(340, 100),
            .Size = New Size(100, 40),
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnClose.Click, Sub() Me.Close()

        dgvMenus = New DataGridView With {
            .Location = New Point(20, 150),
            .Size = New Size(840, 380),
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect
        }

        Me.Controls.AddRange({pnlTop, btnScan, btnSave, btnClose, dgvMenus})
    End Sub

    Private Sub BtnScan_Click(sender As Object, e As EventArgs)
        Try
            _scannedMenus.Clear()

            ' Find MainDashboard
            Dim mainDashboard As Form = Nothing
            For Each frm As Form In Application.OpenForms
                If frm.GetType().Name = "MainDashboard" Then
                    mainDashboard = frm
                    Exit For
                End If
            Next

            If mainDashboard Is Nothing Then
                MessageBox.Show("MainDashboard not found. Please ensure it is open.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If

            ' Find MenuStrip
            Dim menuStrip As MenuStrip = Nothing
            For Each ctrl As Control In mainDashboard.Controls
                If TypeOf ctrl Is MenuStrip Then
                    menuStrip = CType(ctrl, MenuStrip)
                    Exit For
                End If
            Next

            If menuStrip Is Nothing Then
                MessageBox.Show("MenuStrip not found in MainDashboard.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If

            ' Scan all menus recursively
            For Each topItem As ToolStripMenuItem In menuStrip.Items.OfType(Of ToolStripMenuItem)()
                Dim topMenuText = topItem.Text.Replace("&", "").Replace("…", "")
                _scannedMenus.Add(New MenuInfo With {
                    .MenuPath = topMenuText,
                    .MenuLevel = 1,
                    .ParentPath = Nothing,
                    .DisplayName = topMenuText,
                    .ModuleName = topMenuText
                })
                ScanSubMenus(topItem, topMenuText, topMenuText)
            Next

            ' Display in grid
            Dim dt As New DataTable()
            dt.Columns.Add("MenuPath", GetType(String))
            dt.Columns.Add("Level", GetType(Integer))
            dt.Columns.Add("ParentPath", GetType(String))
            dt.Columns.Add("DisplayName", GetType(String))
            dt.Columns.Add("Module", GetType(String))

            For Each menu In _scannedMenus
                dt.Rows.Add(menu.MenuPath, menu.MenuLevel, menu.ParentPath, menu.DisplayName, menu.ModuleName)
            Next

            dgvMenus.DataSource = dt
            btnSave.Enabled = True

            MessageBox.Show($"Scanned {_scannedMenus.Count} menu items successfully!", "Scan Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)

        Catch ex As Exception
            MessageBox.Show("Error scanning menus: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ScanSubMenus(parentItem As ToolStripMenuItem, parentPath As String, moduleName As String)
        Dim level As Integer = parentPath.Split(">"c).Length + 1

        For Each subItem As ToolStripMenuItem In parentItem.DropDownItems.OfType(Of ToolStripMenuItem)()
            Dim menuText = subItem.Text.Replace("&", "").Replace("…", "").Trim()
            Dim menuPath = parentPath & " > " & menuText

            _scannedMenus.Add(New MenuInfo With {
                .MenuPath = menuPath,
                .MenuLevel = level,
                .ParentPath = parentPath,
                .DisplayName = menuText,
                .ModuleName = moduleName
            })

            ' Recursively scan deeper levels
            If subItem.DropDownItems.Count > 0 Then
                ScanSubMenus(subItem, menuPath, moduleName)
            End If
        Next
    End Sub

    Private Sub BtnSave_Click(sender As Object, e As EventArgs)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()

                ' Clear existing menus
                Using cmd As New SqlCommand("DELETE FROM MenuRegistry", conn)
                    cmd.ExecuteNonQuery()
                End Using

                ' Insert all scanned menus
                For Each menu In _scannedMenus
                    Dim sql = "INSERT INTO MenuRegistry (MenuPath, MenuLevel, ParentPath, DisplayName, ModuleName) VALUES (@MenuPath, @MenuLevel, @ParentPath, @DisplayName, @ModuleName)"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@MenuPath", menu.MenuPath)
                        cmd.Parameters.AddWithValue("@MenuLevel", menu.MenuLevel)
                        cmd.Parameters.AddWithValue("@ParentPath", If(menu.ParentPath, DBNull.Value))
                        cmd.Parameters.AddWithValue("@DisplayName", menu.DisplayName)
                        cmd.Parameters.AddWithValue("@ModuleName", menu.ModuleName)
                        cmd.ExecuteNonQuery()
                    End Using
                Next
            End Using

            MessageBox.Show($"Successfully saved {_scannedMenus.Count} menu items to MenuRegistry table!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)

        Catch ex As Exception
            MessageBox.Show("Error saving to database: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
