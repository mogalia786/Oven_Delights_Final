Imports System.IO
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Linq

Public Class ImportCategoriesForm
    Inherits Form
    
    Private _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private _csvFilePath As String = ""
    Private _columnMapping As New Dictionary(Of String, Integer)
    Private _csvHeaders As String() = Nothing
    
    Private Sub ImportCategoriesForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Import Categories from CSV - Oven Delights ERP"
        Me.Size = New Size(1000, 700)
        Me.StartPosition = FormStartPosition.CenterParent
        InitializeUI()
    End Sub
    
    Private Sub InitializeUI()
        ' Header Panel
        Dim pnlHeader As New Panel() With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = Color.FromArgb(155, 89, 182)
        }
        
        Dim lblTitle As New Label() With {
            .Text = "📥 Import Categories from CSV",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 15)
        }
        
        Dim lblSubtitle As New Label() With {
            .Text = "Upload a CSV file to bulk import categories into the system",
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
                   "Columns: CategoryName, Description, IsActive" & vbCrLf &
                   "IsActive: 1 (active) or 0 (inactive)",
            .Left = 0,
            .Top = y,
            .Width = 900,
            .Height = 60,
            .Font = New Font("Segoe UI", 9),
            .ForeColor = Color.FromArgb(52, 73, 94)
        }
        y += 70
        
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
        
        ' Progress Bar
        Dim progressBar As New ProgressBar() With {
            .Name = "progressBar",
            .Left = 0,
            .Top = y,
            .Width = 900,
            .Height = 25,
            .Visible = False
        }
        y += 35
        
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
            .Text = "✓ Import Categories",
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
        
        pnlMain.Controls.AddRange({lblInstructions, lblFile, txtFilePath, btnBrowse, lblPreview, dgvPreview, progressBar, lblStatus, btnPreview, btnImport, btnClose})
        
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
                Dim headerLine = reader.ReadLine()
                _csvHeaders = headerLine.Split(","c).Select(Function(h) h.Trim()).ToArray()
                
                For Each header In _csvHeaders
                    dt.Columns.Add(header)
                Next
                
                Dim rowCount As Integer = 0
                While Not reader.EndOfStream AndAlso rowCount < 10
                    Dim line = reader.ReadLine()
                    Dim values = line.Split(","c)
                    dt.Rows.Add(values)
                    rowCount += 1
                End While
            End Using
            
            AutoDetectColumnMapping()
            ShowColumnMappingUI()
            
            Dim dgv = CType(Me.Controls.Find("dgvPreview", True)(0), DataGridView)
            dgv.DataSource = dt
            
            Dim lblStatus = CType(Me.Controls.Find("lblStatus", True)(0), Label)
            lblStatus.Text = $"Preview loaded: {dt.Rows.Count} rows shown (first 10). Review column mapping below."
            lblStatus.ForeColor = Color.FromArgb(52, 152, 219)
        Catch ex As Exception
            MessageBox.Show($"Error reading CSV file: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub AutoDetectColumnMapping()
        _columnMapping.Clear()
        
        Dim fieldVariations As New Dictionary(Of String, String()) From {
            {"CategoryName", {"CategoryName", "Category Name", "Name", "Category"}},
            {"Description", {"Description", "Desc", "Details"}},
            {"IsActive", {"IsActive", "Active", "Status"}}
        }
        
        For Each field In fieldVariations.Keys
            For i As Integer = 0 To _csvHeaders.Length - 1
                Dim csvHeader = _csvHeaders(i).Trim()
                For Each variation In fieldVariations(field)
                    If csvHeader.Equals(variation, StringComparison.OrdinalIgnoreCase) Then
                        _columnMapping(field) = i
                        Exit For
                    End If
                Next
                If _columnMapping.ContainsKey(field) Then Exit For
            Next
        Next
    End Sub
    
    Private Sub ShowColumnMappingUI()
        Dim oldPanel = Me.Controls.Find("pnlMapping", True).FirstOrDefault()
        If oldPanel IsNot Nothing Then Me.Controls.Remove(oldPanel)
        
        Dim rows As Integer = _csvHeaders.Length
        Dim panelHeight As Integer = 80 + (rows * 35) + 50
        If panelHeight > 400 Then panelHeight = 400
        
        Dim pnlMapping As New Panel() With {
            .Name = "pnlMapping",
            .Left = 20,
            .Top = 400,
            .Width = 900,
            .Height = panelHeight,
            .BorderStyle = BorderStyle.FixedSingle,
            .BackColor = Color.FromArgb(236, 240, 241),
            .AutoScroll = True
        }
        
        Dim lblMappingTitle As New Label() With {
            .Text = "📋 Column Mapping - Map each CSV column to a database field (or Don't Map):",
            .Left = 10,
            .Top = 5,
            .Width = 880,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        pnlMapping.Controls.Add(lblMappingTitle)
        
        Dim lblCSVHeader As New Label() With {
            .Text = "CSV Column",
            .Left = 10,
            .Top = 30,
            .Width = 200,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 73, 94)
        }
        
        Dim lblArrow As New Label() With {
            .Text = "→",
            .Left = 220,
            .Top = 30,
            .Width = 30,
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .TextAlign = ContentAlignment.MiddleCenter
        }
        
        Dim lblDBHeader As New Label() With {
            .Text = "Database Field",
            .Left = 260,
            .Top = 30,
            .Width = 200,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 73, 94)
        }
        
        pnlMapping.Controls.AddRange({lblCSVHeader, lblArrow, lblDBHeader})
        
        Dim y As Integer = 55
        Dim dbFields As String() = {"(Don't Map)", "CategoryName", "Description", "IsActive"}
        
        For i As Integer = 0 To _csvHeaders.Length - 1
            Dim csvColumn As String = _csvHeaders(i)
            
            Dim lblCSVCol As New Label() With {
                .Text = csvColumn,
                .Left = 10,
                .Top = y,
                .Width = 200,
                .Font = New Font("Segoe UI", 9),
                .ForeColor = Color.Black
            }
            
            Dim lblArrowIcon As New Label() With {
                .Text = "→",
                .Left = 220,
                .Top = y,
                .Width = 30,
                .Font = New Font("Segoe UI", 10),
                .TextAlign = ContentAlignment.MiddleCenter
            }
            
            Dim cboDBField As New ComboBox() With {
                .Name = "cboCSV_" & i.ToString(),
                .Tag = i,
                .Left = 260,
                .Top = y - 2,
                .Width = 200,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 9)
            }
            
            For Each dbField In dbFields
                cboDBField.Items.Add(dbField)
            Next
            
            Dim foundMapping As Boolean = False
            For Each kvp In _columnMapping
                If kvp.Value = i Then
                    Dim dbFieldIndex = Array.IndexOf(dbFields, kvp.Key)
                    If dbFieldIndex >= 0 Then
                        cboDBField.SelectedIndex = dbFieldIndex
                        cboDBField.BackColor = Color.LightGreen
                        foundMapping = True
                        Exit For
                    End If
                End If
            Next
            
            If Not foundMapping Then
                cboDBField.SelectedIndex = 0
            End If
            
            AddHandler cboDBField.SelectedIndexChanged, Sub(s, ev)
                                                            Dim combo = CType(s, ComboBox)
                                                            Dim csvIndex = CInt(combo.Tag)
                                                            Dim selectedField = combo.SelectedItem.ToString()
                                                            
                                                            Dim keysToRemove = _columnMapping.Where(Function(kvp) kvp.Value = csvIndex).Select(Function(kvp) kvp.Key).ToList()
                                                            For Each key In keysToRemove
                                                                _columnMapping.Remove(key)
                                                            Next
                                                            
                                                            If selectedField <> "(Don't Map)" Then
                                                                _columnMapping(selectedField) = csvIndex
                                                                combo.BackColor = Color.LightGreen
                                                            Else
                                                                combo.BackColor = Color.White
                                                            End If
                                                        End Sub
            
            pnlMapping.Controls.AddRange({lblCSVCol, lblArrowIcon, cboDBField})
            y += 35
        Next
        
        y += 10
        
        Dim btnConfirmMapping As New Button() With {
            .Text = "✓ Confirm Mapping",
            .Left = 10,
            .Top = y,
            .Width = 150,
            .Height = 35,
            .BackColor = Color.FromArgb(39, 174, 96),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnConfirmMapping.Click, Sub(s, ev)
                                                If Not _columnMapping.ContainsKey("CategoryName") Then
                                                    MessageBox.Show("CategoryName is required! Please map it to a CSV column.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                                    Return
                                                End If
                                                
                                                pnlMapping.Visible = False
                                                
                                                Dim lblStatus = CType(Me.Controls.Find("lblStatus", True)(0), Label)
                                                lblStatus.Text = $"Mapping confirmed. {_columnMapping.Count} fields mapped. Ready to import."
                                                lblStatus.ForeColor = Color.FromArgb(39, 174, 96)
                                            End Sub
        
        Dim btnCancelMapping As New Button() With {
            .Text = "✕ Cancel",
            .Left = 170,
            .Top = y,
            .Width = 100,
            .Height = 35,
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        AddHandler btnCancelMapping.Click, Sub(s, ev)
                                               pnlMapping.Visible = False
                                           End Sub
        
        pnlMapping.Controls.AddRange({btnConfirmMapping, btnCancelMapping})
        
        Me.Controls.Add(pnlMapping)
        pnlMapping.BringToFront()
    End Sub
    
    Private Sub BtnImport_Click(sender As Object, e As EventArgs)
        If String.IsNullOrEmpty(_csvFilePath) OrElse Not File.Exists(_csvFilePath) Then
            MessageBox.Show("Please select a valid CSV file.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim mappingPanel = Me.Controls.Find("pnlMapping", True).FirstOrDefault()
        If mappingPanel IsNot Nothing AndAlso mappingPanel.Visible Then
            MessageBox.Show("Please confirm the column mapping first by clicking 'Confirm Mapping' button.", "Mapping Required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        If Not _columnMapping.ContainsKey("CategoryName") Then
            MessageBox.Show("CategoryName mapping is required! Please preview the file and map columns first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim result = MessageBox.Show("Are you sure you want to import these categories?" & vbCrLf & "This will add new categories to the database.", "Confirm Import", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
        If result <> DialogResult.Yes Then Return
        
        Try
            Dim imported As Integer = 0
            Dim skipped As Integer = 0
            Dim errors As New List(Of String)
            Dim rowNumber As Integer = 1
            
            Dim totalRows As Integer = 0
            Using reader As New StreamReader(_csvFilePath)
                reader.ReadLine()
                While Not reader.EndOfStream
                    reader.ReadLine()
                    totalRows += 1
                End While
            End Using
            
            Dim progressBar = CType(Me.Controls.Find("progressBar", True)(0), ProgressBar)
            progressBar.Visible = True
            progressBar.Minimum = 0
            progressBar.Maximum = totalRows
            progressBar.Value = 0
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using reader As New StreamReader(_csvFilePath)
                    reader.ReadLine()
                    
                    While Not reader.EndOfStream
                        rowNumber += 1
                        Dim line = reader.ReadLine()
                        If String.IsNullOrWhiteSpace(line) Then Continue While
                        
                        Dim values = line.Split(","c)
                        
                        If values.Length < 1 Then
                            errors.Add($"Row {rowNumber}: Empty row")
                            skipped += 1
                            Continue While
                        End If
                        
                        Dim GetMappedValue = Function(field As String) As String
                                                 If _columnMapping.ContainsKey(field) AndAlso _columnMapping(field) < values.Length Then
                                                     Return values(_columnMapping(field)).Trim()
                                                 End If
                                                 Return ""
                                             End Function
                        
                        Dim categoryName = GetMappedValue("CategoryName")
                        If String.IsNullOrEmpty(categoryName) Then
                            errors.Add($"Row {rowNumber}: CategoryName is empty")
                            skipped += 1
                            Continue While
                        End If
                        
                        If categoryName.Length > 100 Then categoryName = categoryName.Substring(0, 100)
                        
                        Dim description = GetMappedValue("Description")
                        If description.Length > 500 Then description = description.Substring(0, 500)
                        
                        Dim isActiveStr = GetMappedValue("IsActive")
                        Dim isActive = If(isActiveStr = "1" OrElse isActiveStr.Equals("true", StringComparison.OrdinalIgnoreCase), True, True)
                        
                        ' Check duplicate
                        Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Categories WHERE CategoryName = @name", conn)
                            cmdCheck.Parameters.AddWithValue("@name", categoryName)
                            If Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0 Then
                                skipped += 1
                                Continue While
                            End If
                        End Using
                        
                        ' Insert category - check which columns exist
                        Try
                            Dim columns As New List(Of String)
                            Dim parameters As New Dictionary(Of String, Object)
                            
                            columns.Add("CategoryName")
                            parameters.Add("@CategoryName", categoryName)
                            
                            columns.Add("IsActive")
                            parameters.Add("@IsActive", isActive)
                            
                            ' Check if Description column exists
                            If Not String.IsNullOrEmpty(description) Then
                                Try
                                    Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Categories' AND COLUMN_NAME = 'Description'", conn)
                                        If Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0 Then
                                            columns.Add("Description")
                                            parameters.Add("@Description", description)
                                        End If
                                    End Using
                                Catch
                                    ' Column doesn't exist, skip it
                                End Try
                            End If
                            
                            ' Check if CreatedDate column exists
                            Try
                                Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Categories' AND COLUMN_NAME = 'CreatedDate'", conn)
                                    If Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0 Then
                                        columns.Add("CreatedDate")
                                        parameters.Add("@CreatedDate", DateTime.Now)
                                    End If
                                End Using
                            Catch
                                ' Column doesn't exist, skip it
                            End Try
                            
                            Dim sql = $"INSERT INTO Categories ({String.Join(", ", columns)}) VALUES ({String.Join(", ", columns.Select(Function(c) "@" & c))})"
                            
                            Using cmd As New SqlCommand(sql, conn)
                                For Each param In parameters
                                    cmd.Parameters.AddWithValue(param.Key, param.Value)
                                Next
                                cmd.ExecuteNonQuery()
                                imported += 1
                            End Using
                        Catch ex As Exception
                            errors.Add($"Row {rowNumber}: {ex.Message}")
                            skipped += 1
                        End Try
                        
                        progressBar.Value = rowNumber - 1
                        Dim lblStatus = CType(Me.Controls.Find("lblStatus", True)(0), Label)
                        lblStatus.Text = $"Importing... {rowNumber - 1} of {totalRows} rows processed"
                        Application.DoEvents()
                    End While
                End Using
            End Using
            
            progressBar.Visible = False
            
            Dim lblStatus2 = CType(Me.Controls.Find("lblStatus", True)(0), Label)
            lblStatus2.Text = $"Import complete! Imported: {imported}, Skipped: {skipped}"
            lblStatus2.ForeColor = Color.FromArgb(39, 174, 96)
            
            Dim resultMsg As String = $"Import completed!{vbCrLf}{vbCrLf}Imported: {imported}{vbCrLf}Skipped: {skipped}"
            If errors.Count > 0 AndAlso errors.Count <= 10 Then
                resultMsg &= vbCrLf & vbCrLf & "Errors:" & vbCrLf & String.Join(vbCrLf, errors.Take(10))
            ElseIf errors.Count > 10 Then
                resultMsg &= vbCrLf & vbCrLf & $"Errors: {errors.Count} (showing first 10):" & vbCrLf & String.Join(vbCrLf, errors.Take(10))
            End If
            
            MessageBox.Show(resultMsg, "Import Results", MessageBoxButtons.OK, If(imported > 0, MessageBoxIcon.Information, MessageBoxIcon.Warning))
        Catch ex As Exception
            MessageBox.Show($"Error importing categories: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
