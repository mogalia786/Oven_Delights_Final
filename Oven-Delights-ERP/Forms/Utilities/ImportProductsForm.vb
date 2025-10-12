Imports System.IO
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Linq

Public Class ImportProductsForm
    Inherits Form
    
    Private _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private _csvFilePath As String = ""
    Private _columnMapping As New Dictionary(Of String, Integer) ' Database field -> CSV column index
    Private _csvHeaders As String() = Nothing
    
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
                ' Read headers
                Dim headerLine = reader.ReadLine()
                _csvHeaders = headerLine.Split(","c).Select(Function(h) h.Trim()).ToArray()
                
                For Each header In _csvHeaders
                    dt.Columns.Add(header)
                Next
                
                ' Read first 10 rows for preview
                Dim rowCount As Integer = 0
                While Not reader.EndOfStream AndAlso rowCount < 10
                    Dim line = reader.ReadLine()
                    Dim values = line.Split(","c)
                    dt.Rows.Add(values)
                    rowCount += 1
                End While
            End Using
            
            ' Auto-detect column mapping
            AutoDetectColumnMapping()
            
            ' Show mapping UI
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
        
        ' Define field mappings with variations
        Dim fieldVariations As New Dictionary(Of String, String()) From {
            {"ProductCode", {"ProductCode", "Product Code", "Code", "SKU", "ProductID"}},
            {"ProductName", {"ProductName", "Product Name", "Name", "Description"}},
            {"CategoryID", {"CategoryID", "Category ID", "Category", "Cat ID"}},
            {"ItemType", {"ItemType", "Item Type", "Type", "ProductType"}},
            {"LastPaidPrice", {"LastPaidPrice", "Last Paid Price", "Cost Price", "Purchase Price", "Cost"}},
            {"AverageCost", {"AverageCost", "Average Cost", "Avg Cost", "AvgCost"}},
            {"ReorderLevel", {"ReorderLevel", "Reorder Level", "Min Stock", "MinStock"}},
            {"ReorderQuantity", {"ReorderQuantity", "Reorder Quantity", "Reorder Qty", "ReorderQty"}},
            {"IsActive", {"IsActive", "Active", "Status"}},
            {"BarCode", {"BarCode", "Bar Code", "Barcode", "EAN"}},
            {"UnitOfMeasure", {"UnitOfMeasure", "Unit Of Measure", "UOM", "Unit"}},
            {"SupplierID", {"SupplierID", "Supplier ID", "Supplier"}},
            {"TaxRate", {"TaxRate", "Tax Rate", "VAT Rate", "Tax"}},
            {"SellingPrice", {"SellingPrice", "Selling Price", "Sale Price", "Price"}},
            {"Notes", {"Notes", "Comments", "Remarks", "Description"}}
        }
        
        ' Try to match each database field to a CSV column
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
        ' Remove old mapping panel if exists
        Dim oldPanel = Me.Controls.Find("pnlMapping", True).FirstOrDefault()
        If oldPanel IsNot Nothing Then Me.Controls.Remove(oldPanel)
        
        ' Calculate height based on CSV columns count
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
        
        ' Column headers
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
        
        ' Get all database fields from Products table
        Dim dbFieldsList As New List(Of String) From {"(Don't Map)"}
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND TABLE_SCHEMA = 'dbo' ORDER BY ORDINAL_POSITION", conn)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim colName = reader.GetString(0)
                            If Not (colName.Equals("ProductID", StringComparison.OrdinalIgnoreCase) OrElse 
                                   colName.Equals("CreatedDate", StringComparison.OrdinalIgnoreCase) OrElse 
                                   colName.Equals("CreatedBy", StringComparison.OrdinalIgnoreCase) OrElse
                                   colName.Equals("ModifiedDate", StringComparison.OrdinalIgnoreCase) OrElse
                                   colName.Equals("ModifiedBy", StringComparison.OrdinalIgnoreCase)) Then
                                dbFieldsList.Add(colName)
                            End If
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception
            dbFieldsList.AddRange({"ProductCode", "ProductName", "CategoryID", "ItemType", "LastPaidPrice", "AverageCost", "ReorderLevel", "ReorderQuantity", "IsActive"})
        End Try
        
        Dim dbFields As String() = dbFieldsList.ToArray()
        
        ' Create mapping row for EACH CSV column
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
                                                If Not _columnMapping.ContainsKey("ProductName") Then
                                                    MessageBox.Show("ProductName is required! Please map it to a CSV column.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                                    Return
                                                End If
                                                
                                                System.Diagnostics.Debug.WriteLine("=== COLUMN MAPPING ===")
                                                For Each kvp In _columnMapping
                                                    System.Diagnostics.Debug.WriteLine($"{kvp.Key} -> CSV Column Index {kvp.Value} ({If(kvp.Value < _csvHeaders.Length, _csvHeaders(kvp.Value), "OUT OF RANGE")})")
                                                Next
                                                System.Diagnostics.Debug.WriteLine("======================")
                                                
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
        
        ' Check if mapping panel is visible
        Dim mappingPanel = Me.Controls.Find("pnlMapping", True).FirstOrDefault()
        If mappingPanel IsNot Nothing AndAlso mappingPanel.Visible Then
            MessageBox.Show("Please confirm the column mapping first by clicking 'Confirm Mapping' button.", "Mapping Required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        If Not _columnMapping.ContainsKey("ProductName") Then
            MessageBox.Show("ProductName mapping is required! Please preview the file and map columns first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim result = MessageBox.Show("Are you sure you want to import these products?" & vbCrLf & "This will add new products to the database.", "Confirm Import", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
        If result <> DialogResult.Yes Then Return
        
        Try
            Dim imported As Integer = 0
            Dim skipped As Integer = 0
            Dim errors As New List(Of String)
            Dim rowNumber As Integer = 1
            
            ' Count total rows first
            Dim totalRows As Integer = 0
            Using reader As New StreamReader(_csvFilePath)
                reader.ReadLine() ' Skip header
                While Not reader.EndOfStream
                    reader.ReadLine()
                    totalRows += 1
                End While
            End Using
            
            ' Show progress bar
            Dim progressBar = CType(Me.Controls.Find("progressBar", True)(0), ProgressBar)
            progressBar.Visible = True
            progressBar.Minimum = 0
            progressBar.Maximum = totalRows
            progressBar.Value = 0
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using reader As New StreamReader(_csvFilePath)
                    reader.ReadLine() ' Skip header
                    
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
                        
                        ' Use column mapping to extract values
                        Dim GetMappedValue = Function(field As String) As String
                                                 If _columnMapping.ContainsKey(field) AndAlso _columnMapping(field) < values.Length Then
                                                     Return values(_columnMapping(field)).Trim()
                                                 End If
                                                 Return ""
                                             End Function
                        
                        Dim productName = GetMappedValue("ProductName")
                        If String.IsNullOrEmpty(productName) Then
                            errors.Add($"Row {rowNumber}: ProductName is empty or not mapped")
                            skipped += 1
                            Continue While
                        End If
                        
                        ' Truncate product name
                        If productName.Length > 200 Then productName = productName.Substring(0, 200)
                        
                        ' Generate unique ProductCode
                        Dim productCode = GetMappedValue("ProductCode")
                        If String.IsNullOrEmpty(productCode) Then
                            Dim prefix As String = ""
                            Dim cleanName = New String(productName.Where(Function(c) Char.IsLetter(c)).ToArray())
                            If cleanName.Length >= 3 Then
                                prefix = cleanName.Substring(0, 3).ToUpper()
                            ElseIf cleanName.Length > 0 Then
                                prefix = cleanName.ToUpper().PadRight(3, "X"c)
                            Else
                                prefix = "PRD"
                            End If
                            
                            Dim codeNumber As Integer = 1
                            Dim isUnique As Boolean = False
                            While Not isUnique AndAlso codeNumber < 10000
                                productCode = $"{prefix}{codeNumber:D3}"
                                Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Products WHERE ProductCode = @code", conn)
                                    cmdCheck.Parameters.AddWithValue("@code", productCode)
                                    isUnique = Convert.ToInt32(cmdCheck.ExecuteScalar()) = 0
                                End Using
                                If Not isUnique Then codeNumber += 1
                            End While
                            
                            If Not isUnique Then
                                errors.Add($"Row {rowNumber}: Could not generate unique ProductCode")
                                skipped += 1
                                Continue While
                            End If
                        End If
                        
                        ' Get other fields
                        Dim categoryIdStr = GetMappedValue("CategoryID")
                        Dim categoryId As Integer = 0
                        Integer.TryParse(categoryIdStr, categoryId)
                        
                        Dim itemType = GetMappedValue("ItemType")
                        If String.IsNullOrEmpty(itemType) Then itemType = "external"
                        
                        Dim isActiveStr = GetMappedValue("IsActive")
                        Dim isActive = If(isActiveStr = "1" OrElse isActiveStr.Equals("true", StringComparison.OrdinalIgnoreCase), True, True)
                        
                        ' Check duplicate
                        Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Products WHERE ProductName = @name", conn)
                            cmdCheck.Parameters.AddWithValue("@name", productName)
                            If Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0 Then
                                skipped += 1
                                Continue While
                            End If
                        End Using
                        
                        ' Insert product
                        Try
                            Dim columns As New List(Of String)
                            Dim parameters As New Dictionary(Of String, Object)
                            
                            columns.Add("ProductCode")
                            parameters.Add("@ProductCode", productCode)
                            
                            columns.Add("ProductName")
                            parameters.Add("@ProductName", productName)
                            
                            If categoryId > 0 Then
                                columns.Add("CategoryID")
                                parameters.Add("@CategoryID", categoryId)
                            End If
                            
                            columns.Add("ItemType")
                            parameters.Add("@ItemType", itemType)
                            
                            columns.Add("IsActive")
                            parameters.Add("@IsActive", isActive)
                            
                            columns.Add("RecipeCreated")
                            parameters.Add("@RecipeCreated", "No")
                            
                            columns.Add("CreatedDate")
                            parameters.Add("@CreatedDate", DateTime.Now)
                            
                            ' Only add CreatedBy if column exists
                            Try
                                Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'CreatedBy'", conn)
                                    If Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0 Then
                                        columns.Add("CreatedBy")
                                        parameters.Add("@CreatedBy", If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 1))
                                    End If
                                End Using
                            Catch
                                ' Column doesn't exist, skip it
                            End Try
                            
                            Dim sql = $"INSERT INTO Products ({String.Join(", ", columns)}) VALUES ({String.Join(", ", columns.Select(Function(c) "@" & c))})"
                            
                            Using cmd As New SqlCommand(sql, conn)
                                For Each param In parameters
                                    cmd.Parameters.AddWithValue(param.Key, param.Value)
                                Next
                                cmd.ExecuteNonQuery()
                                imported += 1
                            End Using
                        Catch ex As Exception
                            errors.Add($"Row {rowNumber}: {ex.Message}")
                            System.Diagnostics.Debug.WriteLine($"Error importing row {rowNumber}: {ex.Message}")
                            skipped += 1
                        End Try
                        
                        ' Update progress bar
                        progressBar.Value = rowNumber - 1
                        Dim lblStatus = CType(Me.Controls.Find("lblStatus", True)(0), Label)
                        lblStatus.Text = $"Importing... {rowNumber - 1} of {totalRows} rows processed"
                        Application.DoEvents() ' Allow UI to update
                    End While
                End Using
            End Using
            
            ' Hide progress bar
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
            MessageBox.Show($"Error importing products: {ex.Message}{vbCrLf}{vbCrLf}Stack Trace:{vbCrLf}{ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
