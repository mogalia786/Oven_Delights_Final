Imports System.IO
Imports System.Data.SqlClient
Imports System.Configuration

Public Class ImportSuppliersForm
    Inherits Form
    
    Private _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private _csvFilePath As String = ""
    Private _columnMapping As New Dictionary(Of String, Integer) ' Database field -> CSV column index
    Private _csvHeaders As String() = Nothing
    
    Private Sub ImportSuppliersForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Import Suppliers from CSV - Oven Delights ERP"
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
            .Text = "📥 Import Suppliers from CSV",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 15)
        }
        
        Dim lblSubtitle As New Label() With {
            .Text = "Upload a CSV file to bulk import suppliers into the system",
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
                   "Columns: CompanyName, ContactPerson, Email, Phone, Address, City, PostalCode, Country, VATNumber, IsActive" & vbCrLf &
                   "IsActive: 1 (active) or 0 (inactive)" & vbCrLf &
                   "All fields are optional except CompanyName",
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
            .Text = "✓ Import Suppliers",
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
                _csvHeaders = reader.ReadLine().Split(","c)
                For i As Integer = 0 To _csvHeaders.Length - 1
                    _csvHeaders(i) = _csvHeaders(i).Trim()
                    dt.Columns.Add(_csvHeaders(i))
                Next
                
                Dim rowCount As Integer = 0
                While Not reader.EndOfStream AndAlso rowCount < 10 ' Preview first 10 rows
                    Dim line = reader.ReadLine()
                    Dim values = line.Split(","c)
                    dt.Rows.Add(values)
                    rowCount += 1
                End While
            End Using
            
            ' Auto-detect column mapping
            AutoDetectColumnMapping()
            
            ' Show preview grid
            Dim dgv = CType(Me.Controls.Find("dgvPreview", True)(0), DataGridView)
            dgv.DataSource = dt
            
            ' Show mapping UI
            ShowColumnMappingUI()
            
            Dim lblStatus = CType(Me.Controls.Find("lblStatus", True)(0), Label)
            lblStatus.Text = $"Preview loaded. Review column mapping below and adjust if needed."
            lblStatus.ForeColor = Color.FromArgb(39, 174, 96)
        Catch ex As Exception
            MessageBox.Show($"Error reading CSV file: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub AutoDetectColumnMapping()
        _columnMapping.Clear()
        
        ' Define field mappings with variations
        Dim fieldVariations As New Dictionary(Of String, String()) From {
            {"SupplierCode", {"SupplierCode", "Supplier Code", "Code", "SupplierID"}},
            {"CompanyName", {"CompanyName", "Company Name", "Company", "Supplier Name", "Name"}},
            {"ContactPerson", {"ContactPerson", "Contact Person", "Contact", "Contact Name"}},
            {"Email", {"Email", "E-mail", "EmailAddress", "Email Address"}},
            {"Phone", {"Phone", "Telephone", "Tel", "PhoneNumber", "Phone Number"}},
            {"Mobile", {"Mobile", "Cell", "CellPhone", "Mobile Phone"}},
            {"Address", {"Address", "Street Address", "Physical Address", "PhysicalAddress"}},
            {"City", {"City", "Town"}},
            {"Province", {"Province", "State", "Region"}},
            {"PostalCode", {"PostalCode", "Postal Code", "Zip", "ZipCode", "Zip Code", "Post Code"}},
            {"Country", {"Country"}},
            {"VATNumber", {"VATNumber", "VAT Number", "VAT", "TaxNumber", "Tax Number"}},
            {"BankName", {"BankName", "Bank Name", "Bank"}},
            {"BranchCode", {"BranchCode", "Branch Code", "Branch"}},
            {"AccountNumber", {"AccountNumber", "Account Number", "Account No", "AccNo"}},
            {"PaymentTerms", {"PaymentTerms", "Payment Terms", "Terms"}},
            {"CreditLimit", {"CreditLimit", "Credit Limit", "Credit"}},
            {"Notes", {"Notes", "Comments", "Remarks"}},
            {"IsActive", {"IsActive", "Active", "Status"}}
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
        Dim panelHeight As Integer = 80 + (rows * 35) + 50 ' Title + rows + button
        If panelHeight > 400 Then panelHeight = 400 ' Max height with scroll
        
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
        
        ' Get all database fields from Suppliers table
        Dim dbFieldsList As New List(Of String) From {"(Don't Map)"}
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND TABLE_SCHEMA = 'dbo' ORDER BY ORDINAL_POSITION", conn)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim colName = reader.GetString(0)
                            ' Exclude auto-generated and system fields
                            If Not (colName.Equals("SupplierID", StringComparison.OrdinalIgnoreCase) OrElse 
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
            ' Fallback to hardcoded list if query fails
            dbFieldsList.AddRange({"CompanyName", "ContactPerson", "Email", "Phone", "Address", "City", "PostalCode", "Country", "VATNumber", "IsActive"})
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
                .Tag = i, ' Store CSV column index
                .Left = 260,
                .Top = y - 2,
                .Width = 200,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 9)
            }
            
            ' Add database field options
            For Each dbField In dbFields
                cboDBField.Items.Add(dbField)
            Next
            
            ' Set auto-detected mapping or default to "Don't Map"
            Dim foundMapping As Boolean = False
            For Each kvp In _columnMapping
                If kvp.Value = i Then
                    ' This CSV column is mapped to this database field
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
                cboDBField.SelectedIndex = 0 ' "Don't Map"
            End If
            
            ' Update mapping when changed
            AddHandler cboDBField.SelectedIndexChanged, Sub(s, ev)
                                                            Dim combo = CType(s, ComboBox)
                                                            Dim csvIndex = CInt(combo.Tag)
                                                            Dim selectedField = combo.SelectedItem.ToString()
                                                            
                                                            ' Remove old mapping for this CSV column
                                                            Dim keysToRemove = _columnMapping.Where(Function(kvp) kvp.Value = csvIndex).Select(Function(kvp) kvp.Key).ToList()
                                                            For Each key In keysToRemove
                                                                _columnMapping.Remove(key)
                                                            Next
                                                            
                                                            ' Add new mapping if not "Don't Map"
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
        
        ' Add some spacing before buttons
        y += 10
        
        ' Add Confirm Mapping button at the end of content
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
                                                ' Validate required field
                                                If Not _columnMapping.ContainsKey("CompanyName") Then
                                                    MessageBox.Show("CompanyName is required! Please map it to a CSV column.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                                    Return
                                                End If
                                                
                                                ' Debug: Show mapping
                                                System.Diagnostics.Debug.WriteLine("=== COLUMN MAPPING ===")
                                                For Each kvp In _columnMapping
                                                    System.Diagnostics.Debug.WriteLine($"{kvp.Key} -> CSV Column Index {kvp.Value} ({If(kvp.Value < _csvHeaders.Length, _csvHeaders(kvp.Value), "OUT OF RANGE")})")
                                                Next
                                                System.Diagnostics.Debug.WriteLine("======================")
                                                
                                                ' Hide mapping panel
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
        
        ' Check if mapping panel is visible (not confirmed yet)
        Dim mappingPanel = Me.Controls.Find("pnlMapping", True).FirstOrDefault()
        If mappingPanel IsNot Nothing AndAlso mappingPanel.Visible Then
            MessageBox.Show("Please confirm the column mapping first by clicking 'Confirm Mapping' button.", "Mapping Required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        ' Validate required field mapping
        If Not _columnMapping.ContainsKey("CompanyName") Then
            MessageBox.Show("CompanyName mapping is required! Please preview the file and map columns first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim result = MessageBox.Show("Are you sure you want to import these suppliers?" & vbCrLf & "This will add new suppliers to the database.", "Confirm Import", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
        If result <> DialogResult.Yes Then Return
        
        Try
            Dim imported As Integer = 0
            Dim skipped As Integer = 0
            Dim errors As New List(Of String)
            Dim rowNumber As Integer = 1 ' Track row for error reporting
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using reader As New StreamReader(_csvFilePath)
                    ' Skip header
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
                        
                        ' Use column mapping to extract values
                        Dim GetMappedValue = Function(field As String) As String
                                                 If _columnMapping.ContainsKey(field) AndAlso _columnMapping(field) < values.Length Then
                                                     Return values(_columnMapping(field)).Trim()
                                                 End If
                                                 Return ""
                                             End Function
                        
                        Dim companyName = GetMappedValue("CompanyName")
                        If String.IsNullOrEmpty(companyName) Then
                            errors.Add($"Row {rowNumber}: CompanyName is empty or not mapped")
                            skipped += 1
                            Continue While
                        End If
                        
                        ' Generate unique SupplierCode from company name
                        Dim supplierCode = GetMappedValue("SupplierCode")
                        If String.IsNullOrEmpty(supplierCode) Then
                            ' Auto-generate: First 3 letters + number
                            Dim prefix As String = ""
                            Dim cleanName = New String(companyName.Where(Function(c) Char.IsLetter(c)).ToArray())
                            If cleanName.Length >= 3 Then
                                prefix = cleanName.Substring(0, 3).ToUpper()
                            ElseIf cleanName.Length > 0 Then
                                prefix = cleanName.ToUpper().PadRight(3, "X"c)
                            Else
                                prefix = "SUP"
                            End If
                            
                            ' Find next available number
                            Dim codeNumber As Integer = 1
                            Dim isUnique As Boolean = False
                            While Not isUnique AndAlso codeNumber < 10000
                                supplierCode = $"{prefix}{codeNumber:D3}"
                                Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Suppliers WHERE SupplierCode = @code", conn)
                                    cmdCheck.Parameters.AddWithValue("@code", supplierCode)
                                    isUnique = Convert.ToInt32(cmdCheck.ExecuteScalar()) = 0
                                End Using
                                If Not isUnique Then codeNumber += 1
                            End While
                            
                            If Not isUnique Then
                                errors.Add($"Row {rowNumber}: Could not generate unique SupplierCode")
                                skipped += 1
                                Continue While
                            End If
                        End If
                        
                        ' Truncate fields to prevent SQL errors
                        Dim contactPerson = GetMappedValue("ContactPerson")
                        If contactPerson.Length > 100 Then contactPerson = contactPerson.Substring(0, 100)
                        
                        Dim email = GetMappedValue("Email")
                        If email.Length > 100 Then email = email.Substring(0, 100)
                        
                        Dim phone = GetMappedValue("Phone")
                        If phone.Length > 50 Then phone = phone.Substring(0, 50)
                        
                        Dim address = GetMappedValue("Address")
                        System.Diagnostics.Debug.WriteLine($"Row {rowNumber}: Address mapped value = '{address}'")
                        If address.Length > 200 Then address = address.Substring(0, 200)
                        
                        Dim city = GetMappedValue("City")
                        If city.Length > 100 Then city = city.Substring(0, 100)
                        
                        Dim postalCode = GetMappedValue("PostalCode")
                        If postalCode.Length > 20 Then postalCode = postalCode.Substring(0, 20)
                        
                        Dim country = GetMappedValue("Country")
                        If String.IsNullOrEmpty(country) Then country = "South Africa"
                        If country.Length > 100 Then country = country.Substring(0, 100)
                        
                        Dim vatNumber = GetMappedValue("VATNumber")
                        If vatNumber.Length > 50 Then vatNumber = vatNumber.Substring(0, 50)
                        
                        Dim isActiveStr = GetMappedValue("IsActive")
                        Dim isActive = If(isActiveStr = "1" OrElse isActiveStr.Equals("true", StringComparison.OrdinalIgnoreCase) OrElse isActiveStr.Equals("yes", StringComparison.OrdinalIgnoreCase), True, True)
                        
                        ' Additional fields from CSV
                        Dim mobile = GetMappedValue("Mobile")
                        If mobile.Length > 50 Then mobile = mobile.Substring(0, 50)
                        
                        Dim province = GetMappedValue("Province")
                        If province.Length > 100 Then province = province.Substring(0, 100)
                        
                        Dim bankName = GetMappedValue("BankName")
                        If bankName.Length > 100 Then bankName = bankName.Substring(0, 100)
                        
                        Dim branchCode = GetMappedValue("BranchCode")
                        If branchCode.Length > 20 Then branchCode = branchCode.Substring(0, 20)
                        
                        Dim accountNumber = GetMappedValue("AccountNumber")
                        If accountNumber.Length > 50 Then accountNumber = accountNumber.Substring(0, 50)
                        
                        Dim paymentTerms = GetMappedValue("PaymentTerms")
                        If paymentTerms.Length > 50 Then paymentTerms = paymentTerms.Substring(0, 50)
                        
                        Dim creditLimitStr = GetMappedValue("CreditLimit")
                        Dim creditLimit As Decimal = 0
                        Decimal.TryParse(creditLimitStr, creditLimit)
                        
                        Dim notes = GetMappedValue("Notes")
                        If notes.Length > 500 Then notes = notes.Substring(0, 500)
                        
                        ' Check if supplier already exists
                        Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Suppliers WHERE CompanyName = @name", conn)
                            cmdCheck.Parameters.AddWithValue("@name", companyName)
                            If Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0 Then
                                skipped += 1
                                Continue While
                            End If
                        End Using
                        
                        ' Insert supplier - build dynamic SQL based on mapped columns
                        Try
                            ' Build column list and value list
                            Dim columns As New List(Of String)
                            Dim parameters As New Dictionary(Of String, Object)
                            
                            ' Add mapped fields
                            If Not String.IsNullOrEmpty(supplierCode) Then
                                columns.Add("SupplierCode")
                                parameters.Add("@SupplierCode", supplierCode)
                            End If
                            
                            If Not String.IsNullOrEmpty(companyName) Then
                                columns.Add("CompanyName")
                                parameters.Add("@CompanyName", companyName)
                            End If
                            
                            If Not String.IsNullOrEmpty(contactPerson) Then
                                columns.Add("ContactPerson")
                                parameters.Add("@ContactPerson", contactPerson)
                            End If
                            
                            If Not String.IsNullOrEmpty(email) Then
                                columns.Add("Email")
                                parameters.Add("@Email", email)
                            End If
                            
                            If Not String.IsNullOrEmpty(phone) Then
                                columns.Add("Phone")
                                parameters.Add("@Phone", phone)
                            End If
                            
                            If Not String.IsNullOrEmpty(address) Then
                                columns.Add("Address")
                                parameters.Add("@Address", address)
                            End If
                            
                            If Not String.IsNullOrEmpty(city) Then
                                columns.Add("City")
                                parameters.Add("@City", city)
                            End If
                            
                            If Not String.IsNullOrEmpty(postalCode) Then
                                columns.Add("PostalCode")
                                parameters.Add("@PostalCode", postalCode)
                            End If
                            
                            If Not String.IsNullOrEmpty(country) Then
                                columns.Add("Country")
                                parameters.Add("@Country", country)
                            End If
                            
                            If Not String.IsNullOrEmpty(vatNumber) Then
                                columns.Add("VATNumber")
                                parameters.Add("@VATNumber", vatNumber)
                            End If
                            
                            If Not String.IsNullOrEmpty(mobile) Then
                                columns.Add("Mobile")
                                parameters.Add("@Mobile", mobile)
                            End If
                            
                            If Not String.IsNullOrEmpty(province) Then
                                columns.Add("Province")
                                parameters.Add("@Province", province)
                            End If
                            
                            If Not String.IsNullOrEmpty(bankName) Then
                                columns.Add("BankName")
                                parameters.Add("@BankName", bankName)
                            End If
                            
                            If Not String.IsNullOrEmpty(branchCode) Then
                                columns.Add("BranchCode")
                                parameters.Add("@BranchCode", branchCode)
                            End If
                            
                            If Not String.IsNullOrEmpty(accountNumber) Then
                                columns.Add("AccountNumber")
                                parameters.Add("@AccountNumber", accountNumber)
                            End If
                            
                            If Not String.IsNullOrEmpty(paymentTerms) Then
                                columns.Add("PaymentTerms")
                                parameters.Add("@PaymentTerms", paymentTerms)
                            End If
                            
                            If creditLimit > 0 Then
                                columns.Add("CreditLimit")
                                parameters.Add("@CreditLimit", creditLimit)
                            End If
                            
                            If Not String.IsNullOrEmpty(notes) Then
                                columns.Add("Notes")
                                parameters.Add("@Notes", notes)
                            End If
                            
                            columns.Add("IsActive")
                            parameters.Add("@IsActive", isActive)
                            
                            columns.Add("CreatedDate")
                            parameters.Add("@CreatedDate", DateTime.Now)
                            
                            ' Only add CreatedBy if column exists
                            Try
                                Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'CreatedBy'", conn)
                                    If Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0 Then
                                        columns.Add("CreatedBy")
                                        parameters.Add("@CreatedBy", If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 1))
                                    End If
                                End Using
                            Catch
                                ' Column doesn't exist, skip it
                            End Try
                            
                            ' Build SQL
                            Dim sql = $"INSERT INTO Suppliers ({String.Join(", ", columns)}) VALUES ({String.Join(", ", columns.Select(Function(c) "@" & c))})"
                            
                            Using cmd As New SqlCommand(sql, conn)
                                For Each param In parameters
                                    cmd.Parameters.AddWithValue(param.Key, param.Value)
                                Next
                                cmd.ExecuteNonQuery()
                                imported += 1
                            End Using
                        Catch ex As Exception
                            ' Log error and skip this row
                            errors.Add($"Row {rowNumber}: {ex.Message}")
                            System.Diagnostics.Debug.WriteLine($"Error importing row {rowNumber}: {ex.Message}")
                            skipped += 1
                        End Try
                    End While
                End Using
            End Using
            
            Dim lblStatus = CType(Me.Controls.Find("lblStatus", True)(0), Label)
            lblStatus.Text = $"Import complete! Imported: {imported}, Skipped: {skipped}"
            lblStatus.ForeColor = Color.FromArgb(39, 174, 96)
            
            ' Show detailed results
            Dim resultMsg As String = $"Import completed!{vbCrLf}{vbCrLf}Imported: {imported}{vbCrLf}Skipped: {skipped}"
            If errors.Count > 0 AndAlso errors.Count <= 10 Then
                resultMsg &= vbCrLf & vbCrLf & "Errors:" & vbCrLf & String.Join(vbCrLf, errors.Take(10))
            ElseIf errors.Count > 10 Then
                resultMsg &= vbCrLf & vbCrLf & $"Errors: {errors.Count} (showing first 10):" & vbCrLf & String.Join(vbCrLf, errors.Take(10))
            End If
            
            MessageBox.Show(resultMsg, "Import Results", MessageBoxButtons.OK, If(imported > 0, MessageBoxIcon.Information, MessageBoxIcon.Warning))
        Catch ex As Exception
            MessageBox.Show($"Error importing suppliers: {ex.Message}{vbCrLf}{vbCrLf}Stack Trace:{vbCrLf}{ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
