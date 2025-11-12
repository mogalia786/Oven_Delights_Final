Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

Public Class AddMenuDialog
    Inherits Form
    
    Private _connectionString As String
    Private txtMenuName As TextBox
    Private txtSubMenuName As TextBox
    Private numDisplayOrder As NumericUpDown
    Private chkGrantToAll As CheckBox
    Private btnAdd As Button
    Private btnCancel As Button
    
    Private _green As Color = ColorTranslator.FromHtml("#27AE60")
    Private _red As Color = ColorTranslator.FromHtml("#E74C3C")
    Private _darkBlue As Color = ColorTranslator.FromHtml("#2C3E50")
    
    Public Sub New()
        MyBase.New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        InitializeComponent()
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "Add New Menu"
        Me.Size = New Size(500, 400)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.BackColor = Color.White
        
        ' Header
        Dim lblHeader As New Label With {
            .Text = "➕ ADD NEW MENU",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = _darkBlue,
            .Location = New Point(30, 20),
            .AutoSize = True
        }
        
        ' Menu Name
        Dim lblMenuName As New Label With {
            .Text = "Main Menu Name:",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(30, 70),
            .AutoSize = True
        }
        
        txtMenuName = New TextBox With {
            .Font = New Font("Segoe UI", 11),
            .Location = New Point(30, 95),
            .Size = New Size(430, 30)
        }
        
        ' Sub-Menu Name
        Dim lblSubMenuName As New Label With {
            .Text = "Sub-Menu Name (optional):",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(30, 140),
            .AutoSize = True
        }
        
        txtSubMenuName = New TextBox With {
            .Font = New Font("Segoe UI", 11),
            .Location = New Point(30, 165),
            .Size = New Size(430, 30)
        }
        
        ' Display Order
        Dim lblDisplayOrder As New Label With {
            .Text = "Display Order:",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Location = New Point(30, 210),
            .AutoSize = True
        }
        
        numDisplayOrder = New NumericUpDown With {
            .Font = New Font("Segoe UI", 11),
            .Location = New Point(30, 235),
            .Size = New Size(100, 30),
            .Minimum = 0,
            .Maximum = 999,
            .Value = 1
        }
        
        ' Grant to all roles checkbox
        chkGrantToAll = New CheckBox With {
            .Text = "Grant access to all roles by default",
            .Font = New Font("Segoe UI", 10),
            .Location = New Point(30, 280),
            .Size = New Size(430, 25),
            .Checked = True
        }
        
        ' Buttons
        btnAdd = New Button With {
            .Text = "✓ ADD MENU",
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .Size = New Size(180, 50),
            .Location = New Point(120, 320),
            .BackColor = _green,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnAdd.FlatAppearance.BorderSize = 0
        AddHandler btnAdd.Click, AddressOf BtnAdd_Click
        
        btnCancel = New Button With {
            .Text = "✖ CANCEL",
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .Size = New Size(120, 50),
            .Location = New Point(320, 320),
            .BackColor = _red,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnCancel.FlatAppearance.BorderSize = 0
        AddHandler btnCancel.Click, Sub() Me.Close()
        
        Me.Controls.AddRange({lblHeader, lblMenuName, txtMenuName, lblSubMenuName, txtSubMenuName, 
                             lblDisplayOrder, numDisplayOrder, chkGrantToAll, btnAdd, btnCancel})
    End Sub
    
    Private Sub BtnAdd_Click(sender As Object, e As EventArgs)
        Dim menuName = txtMenuName.Text.Trim()
        
        If String.IsNullOrEmpty(menuName) Then
            MessageBox.Show("Please enter a menu name.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtMenuName.Focus()
            Return
        End If
        
        Dim subMenuName = txtSubMenuName.Text.Trim()
        If String.IsNullOrEmpty(subMenuName) Then
            subMenuName = Nothing
        End If
        
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Use stored procedure to add menu
                Using cmd As New SqlCommand("sp_AddMenu", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@MenuName", menuName)
                    cmd.Parameters.AddWithValue("@SubMenuName", If(subMenuName, DBNull.Value))
                    cmd.Parameters.AddWithValue("@DisplayOrder", CInt(numDisplayOrder.Value))
                    cmd.Parameters.AddWithValue("@GrantToAllRoles", chkGrantToAll.Checked)
                    
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            
            Dim menuType = If(String.IsNullOrEmpty(subMenuName), "Main menu", "Sub-menu")
            Dim fullName = If(String.IsNullOrEmpty(subMenuName), menuName, $"{menuName} > {subMenuName}")
            
            MessageBox.Show($"{menuType} '{fullName}' added successfully!" & vbCrLf & vbCrLf & 
                          If(chkGrantToAll.Checked, "Access granted to all roles.", "No default permissions set."),
                          "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            
            Me.DialogResult = DialogResult.OK
            Me.Close()
            
        Catch ex As Exception
            MessageBox.Show($"Error adding menu: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
