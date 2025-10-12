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
            {"CompanyName", {"CompanyName", "Company Name", "Company", "Supplier Name", "Name"}},
            {"ContactPerson", {"ContactPerson", "Contact Person", "Contact", "Contact Name"}},
            {"Email", {"Email", "E-mail", "EmailAddress", "Email Address"}},
            {"Phone", {"Phone", "Telephone", "Tel", "PhoneNumber", "Phone Number", "Mobile"}},
            {"Address", {"Address", "Street Address", "Physical Address"}},
            {"City", {"City", "Town"}},
            {"PostalCode", {"PostalCode", "Postal Code", "Zip", "ZipCode", "Zip Code", "Post Code"}},
            {"Country", {"Country"}},
            {"VATNumber", {"VATNumber", "VAT Number", "VAT", "TaxNumber", "Tax Number"}},
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
        
        Dim pnlMapping As New Panel() With {
            .Name = "pnlMapping",
            .Left = 20,
            .Top = 500,
            .Width = 900,
            .Height = 120,
            .BorderStyle = BorderStyle.FixedSingle,
            .BackColor = Color.FromArgb(236, 240, 241)
        }
        
        Dim lblMappingTitle As New Label() With {
            .Text = "Column Mapping (adjust if needed):",
            .Left = 10,
            .Top = 5,
            .Width = 300,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        pnlMapping.Controls.Add(lblMappingTitle)
        
        Dim x As Integer = 10
        Dim y As Integer = 30
        
        ' Create dropdowns for key fields
        Dim keyFields As String() = {"CompanyName", "ContactPerson", "Email", "Phone", "PostalCode"}
        
        For Each field In keyFields
            Dim lblField As New Label() With {
                .Text = field & ":",
                .Left = x,
                .Top = y,
                .Width = 120,
                .Font = New Font("Segoe UI", 8)
            }
            
            Dim cboColumn As New ComboBox() With {
                .Name = "cbo" & field,
                .Left = x,
                .Top = y + 18,
                .Width = 120,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 8)
            }
            
            cboColumn.Items.Add("(Not Mapped)")
            For Each header In _csvHeaders
                cboColumn.Items.Add(header)
            Next
            
            If _columnMapping.ContainsKey(field) Then
                cboColumn.SelectedIndex = _columnMapping(field) + 1
            Else
                cboColumn.SelectedIndex = 0
            End If
            
            ' Update mapping when changed
            AddHandler cboColumn.SelectedIndexChanged, Sub(s, ev)
                                                           Dim combo = CType(s, ComboBox)
                                                           Dim fld = combo.Name.Substring(3) ' Remove "cbo" prefix
                                                           If combo.SelectedIndex > 0 Then
                                                               _columnMapping(fld) = combo.SelectedIndex - 1
                                                           ElseIf _columnMapping.ContainsKey(fld) Then
                                                               _columnMapping.Remove(fld)
                                                           End If
                                                       End Sub
            
            pnlMapping.Controls.AddRange({lblField, cboColumn})
            x += 130
            If x > 780 Then
                x = 10
                y += 60
            End If
        Next
        
        Me.Controls.Add(pnlMapping)
        pnlMapping.BringToFront()
    End Sub
    
    Private Sub BtnImport_Click(sender As Object, e As EventArgs)
        If String.IsNullOrEmpty(_csvFilePath) OrElse Not File.Exists(_csvFilePath) Then
            MessageBox.Show("Please select a valid CSV file.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim result = MessageBox.Show("Are you sure you want to import these suppliers?" & vbCrLf & "This will add new suppliers to the database.", "Confirm Import", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
        If result <> DialogResult.Yes Then Return
        
        Try
            Dim imported As Integer = 0
            Dim skipped As Integer = 0
            Dim rowNumber As Integer = 1 ' Track row for error reporting
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using reader As New StreamReader(_csvFilePath)
                    ' Skip header
                    reader.ReadLine()
                    
                    While Not reader.EndOfStream
                        rowNumber += 1
                        Dim line = reader.ReadLine()
                        Dim values = line.Split(","c)
                        
                        If values.Length < 1 Then
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
                            skipped += 1
                            Continue While
                        End If
                        
                        ' Truncate fields to prevent SQL errors
                        Dim contactPerson = GetMappedValue("ContactPerson")
                        If contactPerson.Length > 100 Then contactPerson = contactPerson.Substring(0, 100)
                        
                        Dim email = GetMappedValue("Email")
                        If email.Length > 100 Then email = email.Substring(0, 100)
                        
                        Dim phone = GetMappedValue("Phone")
                        If phone.Length > 50 Then phone = phone.Substring(0, 50)
                        
                        Dim address = GetMappedValue("Address")
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
                        
                        ' Check if supplier already exists
                        Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Suppliers WHERE CompanyName = @name", conn)
                            cmdCheck.Parameters.AddWithValue("@name", companyName)
                            If Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0 Then
                                skipped += 1
                                Continue While
                            End If
                        End Using
                        
                        ' Insert supplier
                        Try
                            Dim sql = "INSERT INTO Suppliers (CompanyName, ContactPerson, Email, Phone, Address, City, PostalCode, Country, VATNumber, IsActive, CreatedDate) " &
                                     "VALUES (@company, @contact, @email, @phone, @address, @city, @postal, @country, @vat, @active, GETDATE())"
                            
                            Using cmd As New SqlCommand(sql, conn)
                                cmd.Parameters.AddWithValue("@company", companyName)
                                cmd.Parameters.AddWithValue("@contact", If(String.IsNullOrEmpty(contactPerson), DBNull.Value, CType(contactPerson, Object)))
                                cmd.Parameters.AddWithValue("@email", If(String.IsNullOrEmpty(email), DBNull.Value, CType(email, Object)))
                                cmd.Parameters.AddWithValue("@phone", If(String.IsNullOrEmpty(phone), DBNull.Value, CType(phone, Object)))
                                cmd.Parameters.AddWithValue("@address", If(String.IsNullOrEmpty(address), DBNull.Value, CType(address, Object)))
                                cmd.Parameters.AddWithValue("@city", If(String.IsNullOrEmpty(city), DBNull.Value, CType(city, Object)))
                                cmd.Parameters.AddWithValue("@postal", If(String.IsNullOrEmpty(postalCode), DBNull.Value, CType(postalCode, Object)))
                                cmd.Parameters.AddWithValue("@country", country)
                                cmd.Parameters.AddWithValue("@vat", If(String.IsNullOrEmpty(vatNumber), DBNull.Value, CType(vatNumber, Object)))
                                cmd.Parameters.AddWithValue("@active", isActive)
                                cmd.ExecuteNonQuery()
                                imported += 1
                            End Using
                        Catch ex As Exception
                            ' Log error and skip this row
                            System.Diagnostics.Debug.WriteLine($"Error importing row {rowNumber}: {ex.Message}")
                            skipped += 1
                        End Try
                    End While
                End Using
            End Using
            
            Dim lblStatus = CType(Me.Controls.Find("lblStatus", True)(0), Label)
            lblStatus.Text = $"Import complete! Imported: {imported}, Skipped: {skipped}"
            lblStatus.ForeColor = Color.FromArgb(39, 174, 96)
            
            MessageBox.Show($"Import completed successfully!{vbCrLf}{vbCrLf}Imported: {imported}{vbCrLf}Skipped (duplicates): {skipped}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error importing suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
