Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class SARSReportingForm
    Inherits Form

    Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private sarsService As New SARSComplianceService()
    
    Private tabControl As TabControl
    Private tabVAT201 As TabPage
    Private tabEMP201 As TabPage
    Private tabIRP5 As TabPage
    Private tabCompliance As TabPage
    
    ' VAT201 controls
    Private dtpVATStart As DateTimePicker
    Private dtpVATEnd As DateTimePicker
    Private dgvVAT201 As DataGridView
    Private btnGenerateVAT As Button
    Private btnExportVAT As Button
    
    ' EMP201 controls
    Private dtpEMPStart As DateTimePicker
    Private dtpEMPEnd As DateTimePicker
    Private dgvEMP201 As DataGridView
    Private btnGenerateEMP As Button
    Private btnExportEMP As Button
    
    ' IRP5 controls
    Private cmbTaxYear As ComboBox
    Private dgvIRP5 As DataGridView
    Private btnGenerateIRP5 As Button
    Private btnExportIRP5 As Button
    
    ' Compliance controls
    Private lstCompliance As ListBox
    Private btnCheckCompliance As Button
    Private lblComplianceStatus As Label

    Public Sub New()
        Me.Text = "SARS Reporting & Compliance"
        Me.Width = 1200
        Me.Height = 800
        Me.StartPosition = FormStartPosition.CenterParent
        InitializeUI()
    End Sub

    Private Sub InitializeUI()
        ' Main tab control
        tabControl = New TabControl With {
            .Dock = DockStyle.Fill
        }
        
        ' Create tabs
        CreateVAT201Tab()
        CreateEMP201Tab()
        CreateIRP5Tab()
        CreateComplianceTab()
        
        Me.Controls.Add(tabControl)
    End Sub

    Private Sub CreateVAT201Tab()
        tabVAT201 = New TabPage("VAT201 Returns")
        
        ' Period selection
        Dim lblVATStart As New Label With {
            .Text = "Period Start:",
            .Location = New Point(20, 20),
            .Size = New Size(80, 20)
        }
        
        dtpVATStart = New DateTimePicker With {
            .Location = New Point(110, 17),
            .Size = New Size(120, 25),
            .Value = New Date(DateTime.Now.Year, DateTime.Now.Month, 1)
        }
        
        Dim lblVATEnd As New Label With {
            .Text = "Period End:",
            .Location = New Point(250, 20),
            .Size = New Size(80, 20)
        }
        
        dtpVATEnd = New DateTimePicker With {
            .Location = New Point(340, 17),
            .Size = New Size(120, 25),
            .Value = New Date(DateTime.Now.Year, DateTime.Now.Month, DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month))
        }
        
        btnGenerateVAT = New Button With {
            .Text = "Generate VAT201",
            .Location = New Point(480, 15),
            .Size = New Size(120, 30),
            .BackColor = Color.LightBlue
        }
        
        btnExportVAT = New Button With {
            .Text = "Export CSV",
            .Location = New Point(610, 15),
            .Size = New Size(100, 30),
            .BackColor = Color.LightGreen,
            .Enabled = False
        }
        
        ' VAT201 data grid
        dgvVAT201 = New DataGridView With {
            .Location = New Point(20, 60),
            .Size = New Size(1140, 400),
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }
        
        ' Instructions
        Dim lblVATInstructions As New Label With {
            .Text = "Instructions: Generate VAT201 data, review calculations, then export CSV for manual eFiling submission.",
            .Location = New Point(20, 480),
            .Size = New Size(1140, 40),
            .ForeColor = Color.Blue
        }
        
        tabVAT201.Controls.AddRange({lblVATStart, dtpVATStart, lblVATEnd, dtpVATEnd, btnGenerateVAT, btnExportVAT, dgvVAT201, lblVATInstructions})
        
        AddHandler btnGenerateVAT.Click, AddressOf OnGenerateVAT201
        AddHandler btnExportVAT.Click, AddressOf OnExportVAT201
        
        tabControl.TabPages.Add(tabVAT201)
    End Sub

    Private Sub CreateEMP201Tab()
        tabEMP201 = New TabPage("EMP201 PAYE")
        
        ' Period selection
        Dim lblEMPStart As New Label With {
            .Text = "Period Start:",
            .Location = New Point(20, 20),
            .Size = New Size(80, 20)
        }
        
        dtpEMPStart = New DateTimePicker With {
            .Location = New Point(110, 17),
            .Size = New Size(120, 25),
            .Value = New Date(DateTime.Now.Year, DateTime.Now.Month, 1)
        }
        
        Dim lblEMPEnd As New Label With {
            .Text = "Period End:",
            .Location = New Point(250, 20),
            .Size = New Size(80, 20)
        }
        
        dtpEMPEnd = New DateTimePicker With {
            .Location = New Point(340, 17),
            .Size = New Size(120, 25),
            .Value = New Date(DateTime.Now.Year, DateTime.Now.Month, DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month))
        }
        
        btnGenerateEMP = New Button With {
            .Text = "Generate EMP201",
            .Location = New Point(480, 15),
            .Size = New Size(120, 30),
            .BackColor = Color.LightBlue
        }
        
        btnExportEMP = New Button With {
            .Text = "Export CSV",
            .Location = New Point(610, 15),
            .Size = New Size(100, 30),
            .BackColor = Color.LightGreen,
            .Enabled = False
        }
        
        ' EMP201 data grid
        dgvEMP201 = New DataGridView With {
            .Location = New Point(20, 60),
            .Size = New Size(1140, 400),
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }
        
        ' Instructions
        Dim lblEMPInstructions As New Label With {
            .Text = "Instructions: Generate monthly PAYE data (EMP201), verify amounts, then export for eFiling submission.",
            .Location = New Point(20, 480),
            .Size = New Size(1140, 40),
            .ForeColor = Color.Blue
        }
        
        tabEMP201.Controls.AddRange({lblEMPStart, dtpEMPStart, lblEMPEnd, dtpEMPEnd, btnGenerateEMP, btnExportEMP, dgvEMP201, lblEMPInstructions})
        
        AddHandler btnGenerateEMP.Click, AddressOf OnGenerateEMP201
        AddHandler btnExportEMP.Click, AddressOf OnExportEMP201
        
        tabControl.TabPages.Add(tabEMP201)
    End Sub

    Private Sub CreateIRP5Tab()
        tabIRP5 = New TabPage("IRP5 Certificates")
        
        ' Tax year selection
        Dim lblTaxYear As New Label With {
            .Text = "Tax Year:",
            .Location = New Point(20, 20),
            .Size = New Size(80, 20)
        }
        
        cmbTaxYear = New ComboBox With {
            .Location = New Point(110, 17),
            .Size = New Size(120, 25),
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        
        ' Populate tax years
        For year As Integer = DateTime.Now.Year - 5 To DateTime.Now.Year + 1
            cmbTaxYear.Items.Add(year)
        Next
        cmbTaxYear.SelectedItem = DateTime.Now.Year
        
        btnGenerateIRP5 = New Button With {
            .Text = "Generate IRP5s",
            .Location = New Point(250, 15),
            .Size = New Size(120, 30),
            .BackColor = Color.LightBlue
        }
        
        btnExportIRP5 = New Button With {
            .Text = "Export CSV",
            .Location = New Point(380, 15),
            .Size = New Size(100, 30),
            .BackColor = Color.LightGreen,
            .Enabled = False
        }
        
        ' IRP5 data grid
        dgvIRP5 = New DataGridView With {
            .Location = New Point(20, 60),
            .Size = New Size(1140, 400),
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }
        
        ' Instructions
        Dim lblIRP5Instructions As New Label With {
            .Text = "Instructions: Generate annual IRP5 certificates for all employees, review data, then export for e@syFile submission.",
            .Location = New Point(20, 480),
            .Size = New Size(1140, 40),
            .ForeColor = Color.Blue
        }
        
        tabIRP5.Controls.AddRange({lblTaxYear, cmbTaxYear, btnGenerateIRP5, btnExportIRP5, dgvIRP5, lblIRP5Instructions})
        
        AddHandler btnGenerateIRP5.Click, AddressOf OnGenerateIRP5
        AddHandler btnExportIRP5.Click, AddressOf OnExportIRP5
        
        tabControl.TabPages.Add(tabIRP5)
    End Sub

    Private Sub CreateComplianceTab()
        tabCompliance = New TabPage("Compliance Check")
        
        btnCheckCompliance = New Button With {
            .Text = "Run Compliance Check",
            .Location = New Point(20, 20),
            .Size = New Size(150, 35),
            .BackColor = Color.Orange
        }
        
        lblComplianceStatus = New Label With {
            .Location = New Point(180, 30),
            .Size = New Size(400, 20),
            .Font = New Font("Arial", 10, FontStyle.Bold)
        }
        
        lstCompliance = New ListBox With {
            .Location = New Point(20, 70),
            .Size = New Size(1140, 400),
            .Font = New Font("Consolas", 9)
        }
        
        ' Compliance guidelines
        Dim lblGuidelines As New Label With {
            .Text = "SARS Compliance Guidelines:" & vbCrLf &
                   "• VAT201 returns due by 25th of following month" & vbCrLf &
                   "• EMP201 returns due by 7th of following month" & vbCrLf &
                   "• IRP5 certificates due by 31 May annually" & vbCrLf &
                   "• All submissions must be made via eFiling or e@syFile",
            .Location = New Point(20, 490),
            .Size = New Size(1140, 80),
            .ForeColor = Color.DarkGreen
        }
        
        tabCompliance.Controls.AddRange({btnCheckCompliance, lblComplianceStatus, lstCompliance, lblGuidelines})
        
        AddHandler btnCheckCompliance.Click, AddressOf OnCheckCompliance
        
        tabControl.TabPages.Add(tabCompliance)
    End Sub

    Private Sub OnGenerateVAT201(sender As Object, e As EventArgs)
        Try
            Dim data As DataTable = sarsService.GenerateVAT201Data(dtpVATStart.Value, dtpVATEnd.Value)
            
            ' Transform data for display
            Dim displayData As New DataTable()
            displayData.Columns.Add("VAT Field", GetType(String))
            displayData.Columns.Add("Amount", GetType(Decimal))
            
            If data.Rows.Count > 0 Then
                Dim row As DataRow = data.Rows(0)
                displayData.Rows.Add("Standard Rated Supplies (Excl VAT)", If(IsDBNull(row("StandardRatedSupplies")), 0, Convert.ToDecimal(row("StandardRatedSupplies"))))
                displayData.Rows.Add("Output VAT (Standard Rate)", If(IsDBNull(row("OutputVATStandard")), 0, Convert.ToDecimal(row("OutputVATStandard"))))
                displayData.Rows.Add("Zero Rated Supplies", If(IsDBNull(row("ZeroRatedSupplies")), 0, Convert.ToDecimal(row("ZeroRatedSupplies"))))
                displayData.Rows.Add("Exempt Supplies", If(IsDBNull(row("ExemptSupplies")), 0, Convert.ToDecimal(row("ExemptSupplies"))))
                displayData.Rows.Add("Input VAT", If(IsDBNull(row("InputVAT")), 0, Convert.ToDecimal(row("InputVAT"))))
                displayData.Rows.Add("Bad Debts Recovered", If(IsDBNull(row("BadDebtsRecovered")), 0, Convert.ToDecimal(row("BadDebtsRecovered"))))
                displayData.Rows.Add("Adjustments", If(IsDBNull(row("Adjustments")), 0, Convert.ToDecimal(row("Adjustments"))))
                
                Dim outputVAT As Decimal = If(IsDBNull(row("OutputVATStandard")), 0, Convert.ToDecimal(row("OutputVATStandard")))
                Dim inputVAT As Decimal = If(IsDBNull(row("InputVAT")), 0, Convert.ToDecimal(row("InputVAT")))
                Dim netVAT As Decimal = outputVAT - inputVAT
                displayData.Rows.Add("Net VAT Payable/(Refundable)", netVAT)
            End If
            
            dgvVAT201.DataSource = displayData
            dgvVAT201.Columns("Amount").DefaultCellStyle.Format = "C2"
            btnExportVAT.Enabled = True
            
        Catch ex As Exception
            MessageBox.Show($"Error generating VAT201: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnExportVAT201(sender As Object, e As EventArgs)
        Try
            Dim saveDialog As New SaveFileDialog With {
                .Filter = "CSV files (*.csv)|*.csv",
                .FileName = $"VAT201_{dtpVATStart.Value:yyyyMM}.csv"
            }
            
            If saveDialog.ShowDialog() = DialogResult.OK Then
                Dim data As DataTable = sarsService.GenerateVAT201Data(dtpVATStart.Value, dtpVATEnd.Value)
                sarsService.ExportVAT201ToCSV(data, saveDialog.FileName, dtpVATStart.Value, dtpVATEnd.Value)
                MessageBox.Show($"VAT201 exported to: {saveDialog.FileName}", "Export Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error exporting VAT201: {ex.Message}", "Export Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnGenerateEMP201(sender As Object, e As EventArgs)
        Try
            Dim data As DataTable = sarsService.GenerateEMP201Data(dtpEMPStart.Value, dtpEMPEnd.Value)
            
            ' Transform data for display
            Dim displayData As New DataTable()
            displayData.Columns.Add("PAYE Field", GetType(String))
            displayData.Columns.Add("Amount", GetType(Decimal))
            
            If data.Rows.Count > 0 Then
                Dim row As DataRow = data.Rows(0)
                displayData.Rows.Add("PAYE Deducted", Convert.ToDecimal(row("TotalPAYE")))
                displayData.Rows.Add("UIF Contributions", Convert.ToDecimal(row("TotalUIF")))
                displayData.Rows.Add("Skills Development Levy", Convert.ToDecimal(row("TotalSDL")))
                displayData.Rows.Add("Employment Tax Incentive", Convert.ToDecimal(row("TotalETI")))
                displayData.Rows.Add("Total Liability", Convert.ToDecimal(row("TotalLiability")))
                displayData.Rows.Add("Number of Employees", Convert.ToInt32(row("EmployeeCount")))
            End If
            
            dgvEMP201.DataSource = displayData
            dgvEMP201.Columns("Amount").DefaultCellStyle.Format = "N2"
            btnExportEMP.Enabled = True
            
        Catch ex As Exception
            MessageBox.Show($"Error generating EMP201: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnExportEMP201(sender As Object, e As EventArgs)
        Try
            Dim saveDialog As New SaveFileDialog With {
                .Filter = "CSV files (*.csv)|*.csv",
                .FileName = $"EMP201_{dtpEMPStart.Value:yyyyMM}.csv"
            }
            
            If saveDialog.ShowDialog() = DialogResult.OK Then
                Dim data As DataTable = sarsService.GenerateEMP201Data(dtpEMPStart.Value, dtpEMPEnd.Value)
                sarsService.ExportEMP201ToCSV(data, saveDialog.FileName, dtpEMPStart.Value, dtpEMPEnd.Value)
                MessageBox.Show($"EMP201 exported to: {saveDialog.FileName}", "Export Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error exporting EMP201: {ex.Message}", "Export Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnGenerateIRP5(sender As Object, e As EventArgs)
        Try
            Dim taxYear As Integer = Convert.ToInt32(cmbTaxYear.SelectedItem)
            Dim data As DataTable = sarsService.GenerateIRP5Data(taxYear)
            
            dgvIRP5.DataSource = data
            
            ' Format currency columns
            For Each col As DataGridViewColumn In dgvIRP5.Columns
                If col.Name.Contains("Income") OrElse col.Name.Contains("Allowances") OrElse 
                   col.Name.Contains("Benefits") OrElse col.Name.Contains("Deductions") OrElse
                   col.Name.Contains("PAYE") OrElse col.Name.Contains("Contributions") Then
                    col.DefaultCellStyle.Format = "C2"
                End If
            Next
            
            btnExportIRP5.Enabled = True
            
        Catch ex As Exception
            MessageBox.Show($"Error generating IRP5: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnExportIRP5(sender As Object, e As EventArgs)
        Try
            Dim saveDialog As New SaveFileDialog With {
                .Filter = "CSV files (*.csv)|*.csv",
                .FileName = $"IRP5_{cmbTaxYear.SelectedItem}.csv"
            }
            
            If saveDialog.ShowDialog() = DialogResult.OK Then
                Dim taxYear As Integer = Convert.ToInt32(cmbTaxYear.SelectedItem)
                Dim data As DataTable = sarsService.GenerateIRP5Data(taxYear)
                sarsService.ExportIRP5ToCSV(data, saveDialog.FileName, taxYear)
                MessageBox.Show($"IRP5 certificates exported to: {saveDialog.FileName}", "Export Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error exporting IRP5: {ex.Message}", "Export Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnCheckCompliance(sender As Object, e As EventArgs)
        Try
            lstCompliance.Items.Clear()
            lstCompliance.Items.Add("Running SARS compliance check...")
            Application.DoEvents()
            
            Dim issues As List(Of String) = sarsService.ValidateVATCompliance()
            
            lstCompliance.Items.Clear()
            
            If issues.Count = 0 Then
                lstCompliance.Items.Add("✓ No compliance issues found")
                lblComplianceStatus.Text = "Status: COMPLIANT"
                lblComplianceStatus.ForeColor = Color.Green
            Else
                lstCompliance.Items.Add($"Found {issues.Count} compliance issue(s):")
                lstCompliance.Items.Add("")
                
                For Each issue As String In issues
                    lstCompliance.Items.Add($"⚠ {issue}")
                Next
                
                lblComplianceStatus.Text = $"Status: {issues.Count} ISSUES FOUND"
                lblComplianceStatus.ForeColor = Color.Red
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error checking compliance: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

End Class
