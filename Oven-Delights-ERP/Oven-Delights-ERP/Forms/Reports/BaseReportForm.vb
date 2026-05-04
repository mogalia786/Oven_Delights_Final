Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing.Printing
Imports System.IO

Public Class BaseReportForm
    Inherits Form

    Protected connectionString As String
    Protected dgvReport As DataGridView
    Protected dtpStartDate As DateTimePicker
    Protected dtpEndDate As DateTimePicker
    Protected cmbBranch As ComboBox
    Protected btnGenerate As Button
    Protected btnExport As Button
    Protected btnPrint As Button
    Protected lblTitle As Label
    Protected pnlFilters As Panel
    Protected reportTitle As String = "Report"

    Public Sub New()
        ' Initialize connection string FIRST
        Try
            connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Catch ex As Exception
            MessageBox.Show($"Error loading connection string: {ex.Message}", "Configuration Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            connectionString = ""
        End Try
        InitializeComponent()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Report Viewer"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.White

        ' Title Label
        lblTitle = New Label() With {
            .Text = reportTitle,
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.FromArgb(183, 58, 46),
            .AutoSize = True,
            .Location = New Point(20, 20)
        }

        ' Filter Panel
        pnlFilters = New Panel() With {
            .Location = New Point(20, 60),
            .Size = New Size(1140, 80),
            .BackColor = Color.FromArgb(245, 245, 245),
            .BorderStyle = BorderStyle.FixedSingle
        }

        ' Date Range
        Dim lblStartDate As New Label() With {
            .Text = "Start Date:",
            .Location = New Point(10, 15),
            .AutoSize = True
        }
        dtpStartDate = New DateTimePicker() With {
            .Location = New Point(10, 35),
            .Width = 150,
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Now.AddMonths(-1)
        }

        Dim lblEndDate As New Label() With {
            .Text = "End Date:",
            .Location = New Point(170, 15),
            .AutoSize = True
        }
        dtpEndDate = New DateTimePicker() With {
            .Location = New Point(170, 35),
            .Width = 150,
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Now
        }

        ' Branch Filter
        Dim lblBranch As New Label() With {
            .Text = "Branch:",
            .Location = New Point(330, 15),
            .AutoSize = True
        }
        cmbBranch = New ComboBox() With {
            .Location = New Point(330, 35),
            .Width = 200,
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        LoadBranches()

        ' Buttons
        btnGenerate = New Button() With {
            .Text = "Generate Report",
            .Location = New Point(540, 30),
            .Size = New Size(120, 35),
            .BackColor = Color.FromArgb(183, 58, 46),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold)
        }
        AddHandler btnGenerate.Click, AddressOf BtnGenerate_Click

        btnExport = New Button() With {
            .Text = "Export to Excel",
            .Location = New Point(670, 30),
            .Size = New Size(120, 35),
            .BackColor = Color.FromArgb(46, 125, 50),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold)
        }
        AddHandler btnExport.Click, AddressOf BtnExport_Click

        btnPrint = New Button() With {
            .Text = "Print",
            .Location = New Point(800, 30),
            .Size = New Size(120, 35),
            .BackColor = Color.FromArgb(25, 118, 210),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold)
        }
        AddHandler btnPrint.Click, AddressOf BtnPrint_Click

        ' DataGridView
        dgvReport = New DataGridView() With {
            .Location = New Point(20, 150),
            .Size = New Size(1140, 480),
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.Fixed3D,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .ColumnHeadersDefaultCellStyle = New DataGridViewCellStyle() With {
                .BackColor = Color.FromArgb(183, 58, 46),
                .ForeColor = Color.White,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Alignment = DataGridViewContentAlignment.MiddleCenter
            },
            .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {
                .BackColor = Color.FromArgb(250, 250, 250)
            }
        }

        ' Add controls
        pnlFilters.Controls.AddRange({lblStartDate, dtpStartDate, lblEndDate, dtpEndDate, lblBranch, cmbBranch, btnGenerate, btnExport, btnPrint})
        Me.Controls.AddRange({lblTitle, pnlFilters, dgvReport})
    End Sub

    Protected Overridable Sub LoadBranches()
        Try
            If String.IsNullOrEmpty(connectionString) Then
                MessageBox.Show("Connection string not initialized. Please check App.config.", "Configuration Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If
            
            cmbBranch.Items.Clear()
            cmbBranch.Items.Add(New With {.BranchID = 0, .BranchName = "All Branches", .Display = "All Branches"})

            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("SELECT BranchID, BranchName FROM Branches ORDER BY BranchName", conn)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            cmbBranch.Items.Add(New With {
                                .BranchID = reader.GetInt32(0),
                                .BranchName = reader.GetString(1),
                                .Display = reader.GetString(1)
                            })
                        End While
                    End Using
                End Using
            End Using

            cmbBranch.DisplayMember = "Display"
            cmbBranch.ValueMember = "BranchID"
            If cmbBranch.Items.Count > 0 Then cmbBranch.SelectedIndex = 0
        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Protected Overridable Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        ' Override in derived classes
    End Sub

    Protected Sub BtnExport_Click(sender As Object, e As EventArgs)
        Try
            If dgvReport.Rows.Count = 0 Then
                MessageBox.Show("No data to export.", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim saveDialog As New SaveFileDialog() With {
                .Filter = "CSV Files (*.csv)|*.csv",
                .FileName = $"{reportTitle}_{DateTime.Now:yyyyMMdd}.csv"
            }

            If saveDialog.ShowDialog() = DialogResult.OK Then
                Using writer As New StreamWriter(saveDialog.FileName)
                    ' Headers
                    Dim headers = String.Join(",", dgvReport.Columns.Cast(Of DataGridViewColumn)().Select(Function(c) $"""{c.HeaderText}"""))
                    writer.WriteLine(headers)

                    ' Data
                    For Each row As DataGridViewRow In dgvReport.Rows
                        If Not row.IsNewRow Then
                            Dim cells = String.Join(",", row.Cells.Cast(Of DataGridViewCell)().Select(Function(c) $"""{If(c.Value?.ToString(), "")}"""))
                            writer.WriteLine(cells)
                        End If
                    Next
                End Using

                MessageBox.Show("Report exported successfully!", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
                System.Diagnostics.Process.Start("explorer.exe", $"/select,""{saveDialog.FileName}""")
            End If
        Catch ex As Exception
            MessageBox.Show($"Error exporting report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Protected Sub BtnPrint_Click(sender As Object, e As EventArgs)
        Try
            If dgvReport.Rows.Count = 0 Then
                MessageBox.Show("No data to print.", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim printDoc As New PrintDocument()
            AddHandler printDoc.PrintPage, AddressOf PrintDocument_PrintPage

            Dim printDialog As New PrintDialog() With {.Document = printDoc}
            If printDialog.ShowDialog() = DialogResult.OK Then
                printDoc.Print()
            End If
        Catch ex As Exception
            MessageBox.Show($"Error printing report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private currentRow As Integer = 0
    Private Sub PrintDocument_PrintPage(sender As Object, e As PrintPageEventArgs)
        Dim font As New Font("Arial", 10)
        Dim headerFont As New Font("Arial", 12, FontStyle.Bold)
        Dim y As Single = e.MarginBounds.Top
        Dim x As Single = e.MarginBounds.Left

        ' Print title
        e.Graphics.DrawString(reportTitle, headerFont, Brushes.Black, x, y)
        y += 40

        ' Print date range
        e.Graphics.DrawString($"Period: {dtpStartDate.Value:dd/MM/yyyy} - {dtpEndDate.Value:dd/MM/yyyy}", font, Brushes.Black, x, y)
        y += 30

        ' Print column headers
        Dim colWidth As Single = e.MarginBounds.Width / dgvReport.Columns.Count
        For Each col As DataGridViewColumn In dgvReport.Columns
            e.Graphics.DrawString(col.HeaderText, New Font("Arial", 9, FontStyle.Bold), Brushes.Black, x, y)
            x += colWidth
        Next
        y += 25

        ' Print rows
        While currentRow < dgvReport.Rows.Count AndAlso y < e.MarginBounds.Bottom
            x = e.MarginBounds.Left
            Dim row = dgvReport.Rows(currentRow)
            For Each cell As DataGridViewCell In row.Cells
                Dim cellValue As String = If(cell.Value IsNot Nothing, cell.Value.ToString(), "")
                e.Graphics.DrawString(cellValue, font, Brushes.Black, x, y)
                x += colWidth
            Next
            y += 20
            currentRow += 1
        End While

        e.HasMorePages = (currentRow < dgvReport.Rows.Count)
        If Not e.HasMorePages Then currentRow = 0
    End Sub

    Protected Function GetSelectedBranchID() As Integer
        If cmbBranch.SelectedItem IsNot Nothing Then
            Dim item = DirectCast(cmbBranch.SelectedItem, Object)
            Return CInt(item.GetType().GetProperty("BranchID").GetValue(item))
        End If
        Return 0
    End Function

    Protected Sub FormatCurrencyColumn(columnName As String)
        If dgvReport.Columns.Contains(columnName) Then
            dgvReport.Columns(columnName).DefaultCellStyle.Format = "C2"
            dgvReport.Columns(columnName).DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        End If
    End Sub

    Protected Sub FormatNumberColumn(columnName As String)
        If dgvReport.Columns.Contains(columnName) Then
            dgvReport.Columns(columnName).DefaultCellStyle.Format = "N0"
            dgvReport.Columns(columnName).DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        End If
    End Sub
End Class
