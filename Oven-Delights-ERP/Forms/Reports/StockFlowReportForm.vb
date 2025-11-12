Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class StockFlowReportForm
    Inherits BaseReportForm

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    
    Private cboMovementType As ComboBox
    Private dtpStartDate As DateTimePicker
    Private dtpEndDate As DateTimePicker
    Private cboBranch As ComboBox
    Private dgvReport As DataGridView
    Private btnGenerate As Button
    Private btnExport As Button

    Public Sub New()
        MyBase.New()
        InitializeComponent()
        LoadBranches()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Stock Flow Report - Stockroom → Manufacturing → Retail"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterScreen

        ' Header Panel
        Dim headerPanel As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .BackColor = Color.FromArgb(52, 73, 94),
            .Padding = New Padding(20)
        }

        Dim lblTitle As New Label With {
            .Text = "📊 Stock Flow Report",
            .Font = New Font("Segoe UI", 16.0F, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 15)
        }

        Dim lblSubtitle As New Label With {
            .Text = "Track stock movements: Stockroom → Manufacturing → Retail",
            .Font = New Font("Segoe UI", 10.0F),
            .ForeColor = Color.FromArgb(200, 200, 200),
            .AutoSize = True,
            .Location = New Point(20, 50)
        }

        ' Filters Panel
        Dim filtersPanel As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = Color.White,
            .Padding = New Padding(20, 10, 20, 10)
        }

        Dim lblMovementType As New Label With {
            .Text = "Movement Type:",
            .Location = New Point(20, 15),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)
        }

        cboMovementType = New ComboBox With {
            .Location = New Point(20, 38),
            .Width = 200,
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Font = New Font("Segoe UI", 10.0F)
        }
        cboMovementType.Items.AddRange(New String() {
            "All Movements",
            "Stockroom → Manufacturing",
            "Manufacturing → Retail",
            "Retail → Manufacturing (Returns)",
            "Manufacturing → Stockroom (Returns)"
        })
        cboMovementType.SelectedIndex = 0

        Dim lblStartDate As New Label With {
            .Text = "Start Date:",
            .Location = New Point(240, 15),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)
        }

        dtpStartDate = New DateTimePicker With {
            .Location = New Point(240, 38),
            .Width = 150,
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Now.AddMonths(-1)
        }

        Dim lblEndDate As New Label With {
            .Text = "End Date:",
            .Location = New Point(410, 15),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)
        }

        dtpEndDate = New DateTimePicker With {
            .Location = New Point(410, 38),
            .Width = 150,
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Now
        }

        Dim lblBranch As New Label With {
            .Text = "Branch:",
            .Location = New Point(580, 15),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)
        }

        cboBranch = New ComboBox With {
            .Location = New Point(580, 38),
            .Width = 180,
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Font = New Font("Segoe UI", 10.0F)
        }

        btnGenerate = New Button With {
            .Text = "Generate Report",
            .Location = New Point(780, 35),
            .Size = New Size(140, 35),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold),
            .Cursor = Cursors.Hand
        }
        AddHandler btnGenerate.Click, AddressOf GenerateReport

        btnExport = New Button With {
            .Text = "Export to Excel",
            .Location = New Point(930, 35),
            .Size = New Size(140, 35),
            .BackColor = Color.FromArgb(46, 204, 113),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10.0F, FontStyle.Bold),
            .Cursor = Cursors.Hand
        }
        AddHandler btnExport.Click, AddressOf ExportToExcel

        ' DataGridView
        dgvReport = New DataGridView With {
            .Dock = DockStyle.Fill,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 9.0F),
            .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle With {.BackColor = Color.FromArgb(250, 250, 250)}
        }

        dgvReport.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(52, 73, 94)
        dgvReport.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvReport.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10.0F, FontStyle.Bold)
        dgvReport.ColumnHeadersHeight = 40

        ' Add controls
        headerPanel.Controls.AddRange({lblTitle, lblSubtitle})
        filtersPanel.Controls.AddRange({lblMovementType, cboMovementType, lblStartDate, dtpStartDate, lblEndDate, dtpEndDate, lblBranch, cboBranch, btnGenerate, btnExport})
        
        Me.Controls.Add(dgvReport)
        Me.Controls.Add(filtersPanel)
        Me.Controls.Add(headerPanel)
    End Sub

    Private Sub LoadBranches()
        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE ISNULL(IsActive, 1) = 1 ORDER BY BranchName"
                Using cmd As New SqlCommand(sql, conn)
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                    
                    ' Add "All Branches" option
                    Dim allRow = dt.NewRow()
                    allRow("BranchID") = 0
                    allRow("BranchName") = "All Branches"
                    dt.Rows.InsertAt(allRow, 0)
                    
                    cboBranch.DataSource = dt
                    cboBranch.DisplayMember = "BranchName"
                    cboBranch.ValueMember = "BranchID"
                    cboBranch.SelectedIndex = 0
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub GenerateReport(sender As Object, e As EventArgs)
        Try
            Dim movementType = cboMovementType.SelectedItem.ToString()
            Dim startDate = dtpStartDate.Value.Date
            Dim endDate = dtpEndDate.Value.Date.AddDays(1).AddSeconds(-1)
            Dim branchId = Convert.ToInt32(cboBranch.SelectedValue)

            Dim sql As String = BuildQuery(movementType, branchId)

            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@StartDate", startDate)
                    cmd.Parameters.AddWithValue("@EndDate", endDate)
                    If branchId > 0 Then
                        cmd.Parameters.AddWithValue("@BranchID", branchId)
                    End If

                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using

                    dgvReport.DataSource = dt
                    FormatGrid()
                End Using
            End Using

            MessageBox.Show($"Report generated successfully! {dgvReport.Rows.Count} movements found.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function BuildQuery(movementType As String, branchId As Integer) As String
        Dim sql As String = "
            SELECT 
                rsm.MovementID,
                rsm.MovementDate,
                b.BranchName,
                rp.Name AS ProductName,
                rv.VariantName,
                rsm.FromLocation,
                rsm.ToLocation,
                rsm.Quantity,
                rsm.Reason,
                rsm.Reference,
                u.Username AS MovedBy,
                rsm.Notes
            FROM dbo.Demo_Retail_StockMovements rsm
            INNER JOIN dbo.Demo_Retail_Product rp ON rsm.ProductID = rp.ProductID
            LEFT JOIN dbo.Demo_Retail_Variant rv ON rsm.VariantID = rv.VariantID
            INNER JOIN Branches b ON rsm.BranchID = b.BranchID
            LEFT JOIN Users u ON rsm.CreatedBy = u.UserID
            WHERE rsm.MovementDate BETWEEN @StartDate AND @EndDate"

        If branchId > 0 Then
            sql &= " AND rsm.BranchID = @BranchID"
        End If

        Select Case movementType
            Case "Stockroom → Manufacturing"
                sql &= " AND rsm.FromLocation = 'Stockroom' AND rsm.ToLocation = 'Manufacturing'"
            Case "Manufacturing → Retail"
                sql &= " AND rsm.FromLocation = 'Manufacturing' AND rsm.ToLocation = 'Retail'"
            Case "Retail → Manufacturing (Returns)"
                sql &= " AND rsm.FromLocation = 'Retail' AND rsm.ToLocation = 'Manufacturing'"
            Case "Manufacturing → Stockroom (Returns)"
                sql &= " AND rsm.FromLocation = 'Manufacturing' AND rsm.ToLocation = 'Stockroom'"
        End Select

        sql &= " ORDER BY rsm.MovementDate DESC, rsm.MovementID DESC"

        Return sql
    End Function

    Private Sub FormatGrid()
        If dgvReport.Columns.Count = 0 Then Return

        dgvReport.Columns("MovementID").HeaderText = "ID"
        dgvReport.Columns("MovementID").Width = 60
        
        dgvReport.Columns("MovementDate").HeaderText = "Date"
        dgvReport.Columns("MovementDate").DefaultCellStyle.Format = "dd/MM/yyyy HH:mm"
        dgvReport.Columns("MovementDate").Width = 130
        
        dgvReport.Columns("BranchName").HeaderText = "Branch"
        dgvReport.Columns("ProductName").HeaderText = "Product"
        dgvReport.Columns("VariantName").HeaderText = "Variant"
        
        dgvReport.Columns("FromLocation").HeaderText = "From"
        dgvReport.Columns("FromLocation").Width = 100
        
        dgvReport.Columns("ToLocation").HeaderText = "To"
        dgvReport.Columns("ToLocation").Width = 100
        
        dgvReport.Columns("Quantity").HeaderText = "Qty"
        dgvReport.Columns("Quantity").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        dgvReport.Columns("Quantity").DefaultCellStyle.Format = "N2"
        dgvReport.Columns("Quantity").Width = 80
        
        dgvReport.Columns("Reason").HeaderText = "Reason"
        dgvReport.Columns("Reference").HeaderText = "Reference"
        dgvReport.Columns("MovedBy").HeaderText = "Moved By"
        dgvReport.Columns("Notes").HeaderText = "Notes"
    End Sub

    Private Sub ExportToExcel(sender As Object, e As EventArgs)
        Try
            If dgvReport.Rows.Count = 0 Then
                MessageBox.Show("No data to export!", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim saveDialog As New SaveFileDialog With {
                .Filter = "Excel Files|*.xlsx",
                .Title = "Export Stock Flow Report",
                .FileName = $"StockFlowReport_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
            }

            If saveDialog.ShowDialog() = DialogResult.OK Then
                ' TODO: Implement Excel export using EPPlus or similar library
                MessageBox.Show("Excel export functionality to be implemented with EPPlus library", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error exporting to Excel: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
