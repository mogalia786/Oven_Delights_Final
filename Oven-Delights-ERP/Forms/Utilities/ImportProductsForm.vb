Imports System.IO
Imports System.Data.SqlClient
Imports System.Configuration

Public Class ImportProductsForm
    Inherits Form
    
    Private _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private _csvFilePath As String = ""
    
    Private Sub ImportProductsForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Import Products from CSV - Oven Delights ERP"
        Me.Size = New Size(1000, 700)
        Me.StartPosition = FormStartPosition.CenterParent
        InitializeUI()
    End Sub
    
    Private Sub InitializeUI()
        ' Header Panel
        Dim pnlHeader As New Panel() With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = Color.FromArgb(230, 126, 34)
        }
        
        Dim lblTitle As New Label() With {
            .Text = "📥 Import Products from CSV",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 15)
        }
        
        Dim lblSubtitle As New Label() With {
            .Text = "Upload a CSV file to bulk import products into the system",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 50)
        }
        
        pnlHeader.Controls.AddRange({lblTitle, lblSubtitle})
        
        ' Main Panel
        Dim pnlMain As New Panel() With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(20),
            .BackColor = Color.White
        }
        
        Dim y As Integer = 20
        
        ' Instructions
        Dim lblInstructions As New Label() With {
            .Text = "CSV Format Requirements:" & vbCrLf &
                   "Columns: ProductCode, ProductName, CategoryID, ItemType, LastPaidPrice, AverageCost, ReorderLevel, ReorderQuantity, IsActive" & vbCrLf &
                   "ItemType: 'internal' or 'external'" & vbCrLf &
                   "IsActive: 1 (active) or 0 (inactive)",
            .Left = 0,
            .Top = y,
            .Width = 900,
            .Height = 80,
            .Font = New Font("Segoe UI", 9),
            .ForeColor = Color.FromArgb(52, 73, 94)
        }
        y += 90
        
        ' File Selection
        Dim lblFile As New Label() With {
            .Text = "Select CSV File:",
            .Left = 0,
            .Top = y,
            .Width = 150,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        
        Dim txtFilePath As New TextBox() With {
            .Name = "txtFilePath",
            .Left = 0,
            .Top = y + 25,
            .Width = 700,
            .Font = New Font("Segoe UI", 10),
            .ReadOnly = True
        }
        
        Dim btnBrowse As New Button() With {
            .Text = "📁 Browse",
            .Left = 710,
            .Top = y + 23,
            .Width = 120,
            .Height = 30,
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnBrowse.Click, Sub(s, ev)
                                        Using ofd As New OpenFileDialog()
                                            ofd.Filter = "CSV Files|*.csv|All Files|*.*"
                                            ofd.Title = "Select CSV File"
                                            If ofd.ShowDialog() = DialogResult.OK Then
                                                txtFilePath.Text = ofd.FileName
                                                _csvFilePath = ofd.FileName
                                            End If
                                        End Using
                                    End Sub
        y += 70
        
        ' Preview Grid
        Dim lblPreview As New Label() With {
            .Text = "Preview:",
            .Left = 0,
            .Top = y,
            .Width = 150,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        
        Dim dgvPreview As New DataGridView() With {
            .Name = "dgvPreview",
            .Left = 0,
            .Top = y + 25,
            .Width = 900,
            .Height = 300,
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }
        y += 335
        
        ' Status Label
        Dim lblStatus As New Label() With {
            .Name = "lblStatus",
            .Text = "Ready to import...",
            .Left = 0,
            .Top = y,
            .Width = 900,
            .Height = 40,
            .Font = New Font("Segoe UI", 9),
            .ForeColor = Color.FromArgb(52, 73, 94)
        }
        y += 50
        
        ' Buttons
        Dim btnPreview As New Button() With {
            .Text = "👁 Preview Data",
            .Left = 0,
            .Top = y,
            .Width = 150,
            .Height = 40,
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnPreview.Click, AddressOf BtnPreview_Click
        
        Dim btnImport As New Button() With {
            .Text = "✓ Import Products",
            .Left = 160,
            .Top = y,
            .Width = 150,
            .Height = 40,
            .BackColor = Color.FromArgb(39, 174, 96),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnImport.Click, AddressOf BtnImport_Click
        
        Dim btnClose As New Button() With {
            .Text = "✕ Close",
            .Left = 320,
            .Top = y,
            .Width = 150,
            .Height = 40,
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnClose.Click, Sub(s, ev) Me.Close()
        
        pnlMain.Controls.AddRange({lblInstructions, lblFile, txtFilePath, btnBrowse, lblPreview, dgvPreview, lblStatus, btnPreview, btnImport, btnClose})
        
        Me.Controls.AddRange({pnlHeader, pnlMain})
    End Sub
    
    Private Sub BtnPreview_Click(sender As Object, e As EventArgs)
        If String.IsNullOrEmpty(_csvFilePath) OrElse Not File.Exists(_csvFilePath) Then
            MessageBox.Show("Please select a valid CSV file.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Try
            Dim dt As New DataTable()
            Using reader As New StreamReader(_csvFilePath)
                Dim headers = reader.ReadLine().Split(","c)
                For Each header In headers
                    dt.Columns.Add(header.Trim())
                Next
                
                While Not reader.EndOfStream
                    Dim line = reader.ReadLine()
                    Dim values = line.Split(","c)
                    dt.Rows.Add(values)
                End While
            End Using
            
            Dim dgv = CType(Me.Controls.Find("dgvPreview", True)(0), DataGridView)
            dgv.DataSource = dt
            
            Dim lblStatus = CType(Me.Controls.Find("lblStatus", True)(0), Label)
            lblStatus.Text = $"Preview loaded: {dt.Rows.Count} rows found"
            lblStatus.ForeColor = Color.FromArgb(39, 174, 96)
        Catch ex As Exception
            MessageBox.Show($"Error reading CSV file: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub BtnImport_Click(sender As Object, e As EventArgs)
        If String.IsNullOrEmpty(_csvFilePath) OrElse Not File.Exists(_csvFilePath) Then
            MessageBox.Show("Please select a valid CSV file.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim result = MessageBox.Show("Are you sure you want to import these products?" & vbCrLf & "This will add new products to the database.", "Confirm Import", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
        If result <> DialogResult.Yes Then Return
        
        Try
            Dim imported As Integer = 0
            Dim skipped As Integer = 0
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using reader As New StreamReader(_csvFilePath)
                    ' Skip header
                    reader.ReadLine()
                    
                    While Not reader.EndOfStream
                        Dim line = reader.ReadLine()
                        Dim values = line.Split(","c)
                        
                        If values.Length < 9 Then
                            skipped += 1
                            Continue While
                        End If
                        
                        Dim productCode = values(0).Trim()
                        Dim productName = values(1).Trim()
                        Dim categoryId = If(Integer.TryParse(values(2).Trim(), Nothing), Integer.Parse(values(2).Trim()), 0)
                        Dim itemType = values(3).Trim()
                        Dim lastPaidPrice = If(Decimal.TryParse(values(4).Trim(), Nothing), Decimal.Parse(values(4).Trim()), 0D)
                        Dim avgCost = If(Decimal.TryParse(values(5).Trim(), Nothing), Decimal.Parse(values(5).Trim()), 0D)
                        Dim reorderLevel = If(Integer.TryParse(values(6).Trim(), Nothing), Integer.Parse(values(6).Trim()), 0)
                        Dim reorderQty = If(Integer.TryParse(values(7).Trim(), Nothing), Integer.Parse(values(7).Trim()), 0)
                        Dim isActive = values(8).Trim() = "1"
                        
                        ' Check if product already exists
                        Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Products WHERE ProductCode = @code", conn)
                            cmdCheck.Parameters.AddWithValue("@code", productCode)
                            If Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0 Then
                                skipped += 1
                                Continue While
                            End If
                        End Using
                        
                        ' Insert product
                        Dim sql = "INSERT INTO Products (ProductName, ProductCode, CategoryID, ItemType, IsActive, RecipeCreated, CreatedDate) " &
                                 "VALUES (@name, @code, @catId, @itemType, @active, 'No', GETDATE())"
                        
                        Using cmd As New SqlCommand(sql, conn)
                            cmd.Parameters.AddWithValue("@name", productName)
                            cmd.Parameters.AddWithValue("@code", productCode)
                            cmd.Parameters.AddWithValue("@catId", If(categoryId > 0, CType(categoryId, Object), DBNull.Value))
                            cmd.Parameters.AddWithValue("@itemType", itemType)
                            cmd.Parameters.AddWithValue("@active", isActive)
                            cmd.ExecuteNonQuery()
                            imported += 1
                        End Using
                    End While
                End Using
            End Using
            
            Dim lblStatus = CType(Me.Controls.Find("lblStatus", True)(0), Label)
            lblStatus.Text = $"Import complete! Imported: {imported}, Skipped: {skipped}"
            lblStatus.ForeColor = Color.FromArgb(39, 174, 96)
            
            MessageBox.Show($"Import completed successfully!{vbCrLf}{vbCrLf}Imported: {imported}{vbCrLf}Skipped (duplicates): {skipped}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error importing products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
