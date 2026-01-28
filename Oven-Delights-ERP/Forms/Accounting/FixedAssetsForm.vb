Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Accounting
    Public Class FixedAssetsForm
        Inherits Form

        Private WithEvents tabControl As TabControl
        Private WithEvents dgvAssets As DataGridView
        Private WithEvents btnAdd As Button
        Private WithEvents btnEdit As Button
        Private WithEvents btnDispose As Button
        Private WithEvents btnDepreciate As Button
        Private WithEvents btnRefresh As Button
        Private WithEvents cboCategory As ComboBox
        Private WithEvents cboBranch As ComboBox
        Private WithEvents chkIncludeDisposed As CheckBox
        Private _connString As String

        Public Sub New()
            Try
                InitializeComponent()
                _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
                
                If String.IsNullOrEmpty(_connString) Then
                    MessageBox.Show("Connection string not found.", "Configuration Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Return
                End If
                
                LoadCategories()
                LoadBranches()
                LoadAssets()
            Catch ex As Exception
                MessageBox.Show($"Error initializing Fixed Assets form: {ex.Message}", "Initialization Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Fixed Assets Management"
            Me.Size = New Size(1400, 800)
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            ' Header Panel
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = Color.FromArgb(52, 73, 94)
            }

            Dim lblTitle As New Label() With {
                .Text = "Fixed Assets Register",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 15)
            }
            pnlHeader.Controls.Add(lblTitle)

            Dim lblSubtitle As New Label() With {
                .Text = "Manage property, plant, and equipment",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 45)
            }
            pnlHeader.Controls.Add(lblSubtitle)

            ' Filter Panel
            Dim pnlFilter As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 60,
                .BackColor = Color.FromArgb(236, 240, 241),
                .Padding = New Padding(10)
            }

            Dim lblCategory As New Label() With {
                .Text = "Category:",
                .Location = New Point(15, 20),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblCategory)

            cboCategory = New ComboBox() With {
                .Location = New Point(85, 17),
                .Width = 150,
                .DropDownStyle = ComboBoxStyle.DropDownList
            }
            pnlFilter.Controls.Add(cboCategory)

            Dim lblBranch As New Label() With {
                .Text = "Branch:",
                .Location = New Point(250, 20),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(lblBranch)

            cboBranch = New ComboBox() With {
                .Location = New Point(310, 17),
                .Width = 150,
                .DropDownStyle = ComboBoxStyle.DropDownList
            }
            pnlFilter.Controls.Add(cboBranch)

            chkIncludeDisposed = New CheckBox() With {
                .Text = "Include Disposed Assets",
                .Location = New Point(480, 18),
                .AutoSize = True
            }
            pnlFilter.Controls.Add(chkIncludeDisposed)

            btnRefresh = New Button() With {
                .Text = "Refresh",
                .Location = New Point(650, 15),
                .Size = New Size(100, 30),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat
            }
            pnlFilter.Controls.Add(btnRefresh)

            ' Button Panel
            Dim pnlButtons As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 60,
                .BackColor = Color.White,
                .Padding = New Padding(10)
            }

            btnAdd = New Button() With {
                .Text = "➕ Add Asset",
                .Location = New Point(15, 15),
                .Size = New Size(120, 35),
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }
            pnlButtons.Controls.Add(btnAdd)

            btnEdit = New Button() With {
                .Text = "✏️ Edit",
                .Location = New Point(145, 15),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10)
            }
            pnlButtons.Controls.Add(btnEdit)

            btnDispose = New Button() With {
                .Text = "🗑️ Dispose",
                .Location = New Point(255, 15),
                .Size = New Size(110, 35),
                .BackColor = Color.FromArgb(231, 76, 60),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10)
            }
            pnlButtons.Controls.Add(btnDispose)

            btnDepreciate = New Button() With {
                .Text = "📊 Run Depreciation",
                .Location = New Point(375, 15),
                .Size = New Size(150, 35),
                .BackColor = Color.FromArgb(155, 89, 182),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10)
            }
            pnlButtons.Controls.Add(btnDepreciate)

            ' DataGridView
            dgvAssets = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {.BackColor = Color.FromArgb(245, 245, 245)}
            }

            ' Add controls to form
            Me.Controls.Add(dgvAssets)
            Me.Controls.Add(pnlButtons)
            Me.Controls.Add(pnlFilter)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadCategories()
            Try
                cboCategory.Items.Clear()
                cboCategory.Items.Add(New With {.CategoryID = 0, .CategoryName = "All Categories"})
                cboCategory.Items.Add(New With {.CategoryID = 1, .CategoryName = "Building"})
                cboCategory.Items.Add(New With {.CategoryID = 2, .CategoryName = "Equipment"})
                cboCategory.Items.Add(New With {.CategoryID = 3, .CategoryName = "Vehicle"})
                cboCategory.Items.Add(New With {.CategoryID = 4, .CategoryName = "Furniture"})
                cboCategory.Items.Add(New With {.CategoryID = 5, .CategoryName = "Computer"})
                cboCategory.Items.Add(New With {.CategoryID = 6, .CategoryName = "Other"})
                
                cboCategory.DisplayMember = "CategoryName"
                cboCategory.ValueMember = "CategoryID"
                If cboCategory.Items.Count > 0 Then cboCategory.SelectedIndex = 0
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine($"Error loading categories: {ex.Message}")
            End Try
        End Sub

        Private Sub LoadBranches()
            Try
                If String.IsNullOrEmpty(_connString) Then Return
                
                cboBranch.Items.Clear()
                cboBranch.Items.Add(New With {.BranchID = 0, .BranchName = "All Branches"})
                
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand("SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName", conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                cboBranch.Items.Add(New With {
                                    .BranchID = reader.GetInt32(0),
                                    .BranchName = reader.GetString(1)
                                })
                            End While
                        End Using
                    End Using
                End Using
                
                cboBranch.DisplayMember = "BranchName"
                cboBranch.ValueMember = "BranchID"
                If cboBranch.Items.Count > 0 Then cboBranch.SelectedIndex = 0
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine($"Error loading branches: {ex.Message}")
            End Try
        End Sub

        Private Sub LoadAssets()
            Try
                If String.IsNullOrEmpty(_connString) Then Return
                
                Dim branchID As Integer? = Nothing
                If cboBranch IsNot Nothing AndAlso cboBranch.SelectedItem IsNot Nothing Then
                    Dim bid = CInt(cboBranch.SelectedItem.BranchID)
                    If bid > 0 Then branchID = bid
                End If
                
                Dim category As String = Nothing
                If cboCategory IsNot Nothing AndAlso cboCategory.SelectedItem IsNot Nothing Then
                    Dim catName = cboCategory.SelectedItem.CategoryName.ToString()
                    If catName <> "All Categories" Then category = catName
                End If
                
                Dim includeDisposed As Boolean = If(chkIncludeDisposed?.Checked, False)
                
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_FixedAsset_GetRegister", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@BranchID", If(branchID.HasValue, CObj(branchID.Value), DBNull.Value))
                        cmd.Parameters.AddWithValue("@AssetCategory", If(category IsNot Nothing, CObj(category), DBNull.Value))
                        cmd.Parameters.AddWithValue("@IncludeDisposed", includeDisposed)
                        
                        Using adapter As New SqlDataAdapter(cmd)
                            Dim dt As New DataTable()
                            adapter.Fill(dt)
                            dgvAssets.DataSource = dt
                            FormatGrid()
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading assets: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub FormatGrid()
            If dgvAssets.Columns.Count = 0 Then Return
            
            Try
                ' Hide technical columns
                For Each colName In {"AssetID", "BranchID", "AssetAccountID", "DepreciationAccountID", "ExpenseAccountID"}
                    If dgvAssets.Columns.Contains(colName) Then
                        dgvAssets.Columns(colName).Visible = False
                    End If
                Next
                
                ' Format visible columns
                If dgvAssets.Columns.Contains("AssetCode") Then
                    dgvAssets.Columns("AssetCode").HeaderText = "Code"
                    dgvAssets.Columns("AssetCode").Width = 100
                End If
                
                If dgvAssets.Columns.Contains("AssetName") Then
                    dgvAssets.Columns("AssetName").HeaderText = "Asset Name"
                    dgvAssets.Columns("AssetName").Width = 200
                End If
                
                If dgvAssets.Columns.Contains("AssetCategory") Then
                    dgvAssets.Columns("AssetCategory").HeaderText = "Category"
                    dgvAssets.Columns("AssetCategory").Width = 100
                End If
                
                If dgvAssets.Columns.Contains("PurchaseDate") Then
                    dgvAssets.Columns("PurchaseDate").HeaderText = "Purchase Date"
                    dgvAssets.Columns("PurchaseDate").DefaultCellStyle.Format = "yyyy-MM-dd"
                    dgvAssets.Columns("PurchaseDate").Width = 100
                End If
                
                If dgvAssets.Columns.Contains("PurchasePrice") Then
                    dgvAssets.Columns("PurchasePrice").HeaderText = "Cost"
                    dgvAssets.Columns("PurchasePrice").DefaultCellStyle.Format = "N2"
                    dgvAssets.Columns("PurchasePrice").Width = 100
                End If
                
                If dgvAssets.Columns.Contains("CurrentBookValue") Then
                    dgvAssets.Columns("CurrentBookValue").HeaderText = "Book Value"
                    dgvAssets.Columns("CurrentBookValue").DefaultCellStyle.Format = "N2"
                    dgvAssets.Columns("CurrentBookValue").Width = 100
                End If
                
                If dgvAssets.Columns.Contains("AccumulatedDepreciation") Then
                    dgvAssets.Columns("AccumulatedDepreciation").HeaderText = "Accum. Depr."
                    dgvAssets.Columns("AccumulatedDepreciation").DefaultCellStyle.Format = "N2"
                    dgvAssets.Columns("AccumulatedDepreciation").Width = 100
                End If
                
                If dgvAssets.Columns.Contains("BranchName") Then
                    dgvAssets.Columns("BranchName").HeaderText = "Branch"
                    dgvAssets.Columns("BranchName").Width = 120
                End If
                
                If dgvAssets.Columns.Contains("IsDisposed") Then
                    dgvAssets.Columns("IsDisposed").HeaderText = "Disposed"
                    dgvAssets.Columns("IsDisposed").Width = 70
                End If
                
                ' Color code disposed assets
                For Each row As DataGridViewRow In dgvAssets.Rows
                    If Not row.IsNewRow AndAlso row.Cells("IsDisposed").Value IsNot Nothing Then
                        If CBool(row.Cells("IsDisposed").Value) Then
                            row.DefaultCellStyle.BackColor = Color.FromArgb(255, 230, 230)
                            row.DefaultCellStyle.ForeColor = Color.Gray
                        End If
                    End If
                Next
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine($"Error formatting grid: {ex.Message}")
            End Try
        End Sub

        Private Sub BtnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
            LoadAssets()
        End Sub

        Private Sub CboCategory_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboCategory.SelectedIndexChanged
            LoadAssets()
        End Sub

        Private Sub CboBranch_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboBranch.SelectedIndexChanged
            LoadAssets()
        End Sub

        Private Sub ChkIncludeDisposed_CheckedChanged(sender As Object, e As EventArgs) Handles chkIncludeDisposed.CheckedChanged
            LoadAssets()
        End Sub

        Private Sub BtnAdd_Click(sender As Object, e As EventArgs) Handles btnAdd.Click
            Try
                Dim addForm As New FixedAssetAddForm()
                If addForm.ShowDialog() = DialogResult.OK Then
                    LoadAssets()
                End If
            Catch ex As Exception
                MessageBox.Show($"Error opening add form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub BtnEdit_Click(sender As Object, e As EventArgs) Handles btnEdit.Click
            If dgvAssets.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select an asset to edit.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            MessageBox.Show("Edit functionality coming soon.", "Feature", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub BtnDispose_Click(sender As Object, e As EventArgs) Handles btnDispose.Click
            If dgvAssets.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select an asset to dispose.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            Dim assetID = CInt(dgvAssets.SelectedRows(0).Cells("AssetID").Value)
            Dim assetName = dgvAssets.SelectedRows(0).Cells("AssetName").Value.ToString()
            
            Dim result = MessageBox.Show($"Are you sure you want to dispose of asset: {assetName}?", 
                                        "Confirm Disposal", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            
            If result = DialogResult.Yes Then
                Try
                    Dim disposeForm As New FixedAssetDisposeForm(assetID, assetName)
                    If disposeForm.ShowDialog() = DialogResult.OK Then
                        LoadAssets()
                    End If
                Catch ex As Exception
                    MessageBox.Show($"Error disposing asset: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        End Sub

        Private Sub BtnDepreciate_Click(sender As Object, e As EventArgs) Handles btnDepreciate.Click
            Try
                Dim depForm As New DepreciationProcessForm()
                If depForm.ShowDialog() = DialogResult.OK Then
                    LoadAssets()
                End If
            Catch ex As Exception
                MessageBox.Show($"Error opening depreciation form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
