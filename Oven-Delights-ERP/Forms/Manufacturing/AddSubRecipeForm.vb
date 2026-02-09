Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing

Namespace Manufacturing

    Public Class AddSubRecipeForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        ' Logo colors: Orange (#E67E22), Dark Brown (#6E2C00), Cream (#F5DEB3)
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(230, 126, 34) ' Orange
        Private ReadOnly ColorDark As Color = Color.FromArgb(110, 44, 0) ' Dark Brown
        Private ReadOnly ColorLight As Color = Color.FromArgb(245, 222, 179) ' Cream

        Private txtSubRecipeName As TextBox
        Private WithEvents txtSKU As TextBox
        Private chkIsActive As CheckBox
        Private btnSave As Button
        Private btnCancel As Button

        Public Sub New()
            Me.Text = "Add Sub-Recipe - Oven Delights"
            Me.Width = 650
            Me.Height = 400
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False
            Me.BackColor = Color.White
            InitializeUI()
        End Sub

        Private Sub InitializeUI()
            ' Header Panel
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 70,
                .BackColor = ColorDark
            }
            
            Dim lblHeader As New Label() With {
                .Text = "🧁 Add Sub-Recipe",
                .Font = New Font("Segoe UI", 16, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Left = 20,
                .Top = 15
            }
            
            Dim lblSubHeader As New Label() With {
                .Text = "Create a new sub-recipe component (universal for all branches)",
                .Font = New Font("Segoe UI", 9),
                .ForeColor = ColorLight,
                .AutoSize = True,
                .Left = 20,
                .Top = 45
            }
            
            pnlHeader.Controls.AddRange({lblHeader, lblSubHeader})

            ' Main content panel
            Dim pnlMain As New Panel() With {
                .Dock = DockStyle.Fill,
                .Padding = New Padding(30),
                .BackColor = Color.White
            }

            Dim y As Integer = 100
            Dim labelFont As New Font("Segoe UI", 10, FontStyle.Bold)
            Dim textFont As New Font("Segoe UI", 10)

            ' Sub-Recipe Name
            Dim lblName As New Label() With {
                .Text = "Sub-Recipe Name *",
                .Left = 0,
                .Top = y,
                .Width = 200,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            txtSubRecipeName = New TextBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 550,
                .Font = textFont,
                .BorderStyle = BorderStyle.FixedSingle
            }
            y += 70

            ' SKU (Auto-generated)
            Dim lblSKU As New Label() With {
                .Text = "SKU (Auto-generated)",
                .Left = 0,
                .Top = y,
                .Width = 200,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            txtSKU = New TextBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 250,
                .Font = textFont,
                .BorderStyle = BorderStyle.FixedSingle,
                .ReadOnly = True,
                .BackColor = ColorLight
            }
            
            Dim lblSKUHint As New Label() With {
                .Text = "SKU will be auto-generated from the sub-recipe name",
                .Left = 260,
                .Top = y + 30,
                .Width = 290,
                .Font = New Font("Segoe UI", 8, FontStyle.Italic),
                .ForeColor = Color.Gray
            }
            y += 70

            ' Active checkbox
            chkIsActive = New CheckBox() With {
                .Text = "✓ Sub-Recipe is Active",
                .Left = 0,
                .Top = y,
                .Checked = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .ForeColor = ColorDark,
                .AutoSize = True
            }
            y += 40

            ' Info panel
            Dim pnlInfo As New Panel() With {
                .Left = 0,
                .Top = y,
                .Width = 550,
                .Height = 60,
                .BorderStyle = BorderStyle.FixedSingle,
                .BackColor = Color.FromArgb(240, 248, 255)
            }
            
            Dim lblInfo As New Label() With {
                .Text = "ℹ️ Note: Sub-recipes are universal components used across all branches." & vbCrLf & 
                        "After creating this sub-recipe, use 'Create Sub-Recipe' to define its ingredients.",
                .Left = 10,
                .Top = 10,
                .Width = 530,
                .Height = 40,
                .Font = New Font("Segoe UI", 9),
                .ForeColor = Color.FromArgb(0, 51, 102)
            }
            pnlInfo.Controls.Add(lblInfo)

            pnlMain.Controls.AddRange({lblName, txtSubRecipeName, lblSKU, txtSKU, lblSKUHint, chkIsActive, pnlInfo})

            ' Button panel
            Dim pnlButtons As New Panel() With {
                .Dock = DockStyle.Bottom,
                .Height = 70,
                .BackColor = Color.FromArgb(250, 250, 250),
                .Padding = New Padding(30, 15, 30, 15)
            }

            btnSave = New Button() With {
                .Text = "💾 Save Sub-Recipe",
                .Width = 150,
                .Height = 40,
                .Left = 330,
                .Top = 15,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .BackColor = ColorPrimary,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            btnSave.FlatAppearance.BorderSize = 0

            btnCancel = New Button() With {
                .Text = "✖ Cancel",
                .Width = 120,
                .Height = 40,
                .Left = 490,
                .Top = 15,
                .Font = New Font("Segoe UI", 10),
                .BackColor = Color.Gray,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            btnCancel.FlatAppearance.BorderSize = 0

            pnlButtons.Controls.AddRange({btnSave, btnCancel})

            ' Add event handlers
            AddHandler btnSave.Click, AddressOf BtnSave_Click
            AddHandler btnCancel.Click, AddressOf BtnCancel_Click
            AddHandler txtSubRecipeName.TextChanged, AddressOf TxtSubRecipeName_TextChanged

            ' Add all panels to form
            Me.Controls.AddRange({pnlHeader, pnlMain, pnlButtons})
        End Sub

        Private Sub TxtSubRecipeName_TextChanged(sender As Object, e As EventArgs)
            ' Auto-generate SKU from sub-recipe name
            If Not String.IsNullOrWhiteSpace(txtSubRecipeName.Text) Then
                Dim name As String = txtSubRecipeName.Text.Trim()
                
                ' Generate SKU: Take first 3 words, remove spaces, add timestamp
                Dim words = name.Split(" "c)
                Dim skuBase As String = String.Join("", words.Take(Math.Min(3, words.Length)))
                
                ' Remove special characters and limit length
                skuBase = System.Text.RegularExpressions.Regex.Replace(skuBase, "[^a-zA-Z0-9]", "")
                If skuBase.Length > 10 Then skuBase = skuBase.Substring(0, 10)
                
                ' Add timestamp for uniqueness
                Dim timestamp As String = DateTime.Now.ToString("MMddHHmm")
                txtSKU.Text = (skuBase.ToUpper() & timestamp).PadRight(13, "0"c).Substring(0, 13)
            Else
                txtSKU.Text = ""
            End If
        End Sub

        Private Sub BtnSave_Click(sender As Object, e As EventArgs)
            ' Validation
            If String.IsNullOrWhiteSpace(txtSubRecipeName.Text) Then
                MessageBox.Show("Please enter a sub-recipe name.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtSubRecipeName.Focus()
                Return
            End If

            If String.IsNullOrWhiteSpace(txtSKU.Text) Then
                MessageBox.Show("SKU is required. Please enter a sub-recipe name to auto-generate SKU.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtSubRecipeName.Focus()
                Return
            End If
            
            ' Check for duplicate sub-recipe name
            If IsSubRecipeNameExists(txtSubRecipeName.Text.Trim()) Then
                MessageBox.Show("This sub-recipe name already exists. Please use a unique name.", "Duplicate Sub-Recipe", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtSubRecipeName.Focus()
                Return
            End If
            
            ' Check for duplicate SKU
            If IsSKUExists(txtSKU.Text.Trim()) Then
                MessageBox.Show("This SKU already exists. Please modify the sub-recipe name.", "Duplicate SKU", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtSubRecipeName.Focus()
                Return
            End If

            Try
                SaveSubRecipe()
                MessageBox.Show("Sub-recipe added successfully!" & vbCrLf & vbCrLf & 
                               "You can now use 'Create Sub-Recipe' to define its ingredients.", 
                               "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Me.DialogResult = DialogResult.OK
                Me.Close()
            Catch ex As Exception
                MessageBox.Show($"Error saving sub-recipe: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
        
        Private Function IsSubRecipeNameExists(subRecipeName As String) As Boolean
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql As String = "SELECT COUNT(*) FROM Demo_Retail_Product WHERE Name = @Name AND Category = 'sub recipe'"
                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@Name", subRecipeName)
                        Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                        Return count > 0
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error checking sub-recipe name: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Function
        
        Private Function IsSKUExists(sku As String) As Boolean
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql As String = "SELECT COUNT(*) FROM Demo_Retail_Product WHERE SKU = @SKU"
                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@SKU", sku)
                        Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                        Return count > 0
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error checking SKU: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Function

        Private Sub SaveSubRecipe()
            Using con As New SqlConnection(_connectionString)
                con.Open()
                
                Try
                    ' Insert sub-recipe into Demo_Retail_Product
                    ' Category = 'sub recipe', ProductType = 'Internal', BranchID = NULL (universal)
                    Dim sql As String = "INSERT INTO Demo_Retail_Product " &
                                       "(SKU, Name, Category, Description, ProductType, IsActive, CreatedAt, UpdatedAt, BranchID) " &
                                       "VALUES (@SKU, @Name, 'sub recipe', @Description, 'Internal', @IsActive, GETDATE(), GETDATE(), NULL)"
                    
                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@SKU", txtSKU.Text.Trim())
                        cmd.Parameters.AddWithValue("@Name", txtSubRecipeName.Text.Trim())
                        cmd.Parameters.AddWithValue("@Description", txtSubRecipeName.Text.Trim())
                        cmd.Parameters.AddWithValue("@IsActive", If(chkIsActive.Checked, 1, 0))
                        
                        cmd.ExecuteNonQuery()
                    End Using
                    
                Catch ex As Exception
                    Throw New Exception($"Error saving sub-recipe: {ex.Message}")
                End Try
            End Using
        End Sub

        Private Sub BtnCancel_Click(sender As Object, e As EventArgs)
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Sub

    End Class

End Namespace
