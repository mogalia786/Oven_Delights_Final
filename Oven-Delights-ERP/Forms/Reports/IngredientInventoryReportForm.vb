Imports System.Windows.Forms
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Drawing

Public Class IngredientInventoryReportForm
    Inherits Form

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private dgvReport As DataGridView
    Private cboBranch As ComboBox
    Private cboCategory As ComboBox
    Private btnLoad As Button
    Private btnExport As Button
    Private btnClose As Button
    Private lblTitle As Label
    Private lblBranch As Label
    Private lblCategory As Label
    Private lblSummary As Label
    Private pnlTop As Panel
    Private pnlBottom As Panel
    Private currentBranchId As Integer
    Private isSuperAdmin As Boolean

    Public Sub New()
        InitializeComponent()
        currentBranchId = AppSession.CurrentBranchID
        isSuperAdmin = (AppSession.CurrentUser.RoleID = 1) ' Assuming 1 is SuperAdmin
        Me.Text = "Ingredient Inventory Report"
        Me.WindowState = FormWindowState.Maximized
        LoadBranches()
        LoadCategories()
        AddHandler Me.Load, AddressOf Form_Load
    End Sub

    Private Sub InitializeComponent()
        Me.Size = New Size(1400, 800)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.BackColor = Color.FromArgb(240, 240, 245)

        ' Top Panel
        pnlTop = New Panel With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .BackColor = Color.White,
            .Padding = New Padding(20)
        }

        lblTitle = New Label With {
            .Text = "🥫 INGREDIENT INVENTORY REPORT",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 73, 94),
            .AutoSize = True,
            .Location = New Point(20, 15)
        }

        lblBranch = New Label With {
            .Text = "Branch:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(20, 60),
            .AutoSize = True
        }

        cboBranch = New ComboBox With {
            .Location = New Point(90, 57),
            .Width = 250,
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Font = New Font("Segoe UI", 10)
        }

        lblCategory = New Label With {
            .Text = "Category:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(360, 60),
            .AutoSize = True
        }

        cboCategory = New ComboBox With {
            .Location = New Point(440, 57),
            .Width = 200,
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Font = New Font("Segoe UI", 10)
        }

        btnLoad = New Button With {
            .Text = "🔄 Load Report",
            .Location = New Point(660, 55),
            .Size = New Size(130, 35),
            .BackColor = Color.FromArgb(52, 152, 219),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnLoad.FlatAppearance.BorderSize = 0
        AddHandler btnLoad.Click, AddressOf btnLoad_Click

        lblSummary = New Label With {
            .Location = New Point(820, 60),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 10),
            .ForeColor = Color.FromArgb(127, 140, 141)
        }

        pnlTop.Controls.AddRange({lblTitle, lblBranch, cboBranch, lblCategory, cboCategory, btnLoad, lblSummary})

        ' DataGridView
        dgvReport = New DataGridView With {
            .Dock = DockStyle.Fill,
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .MultiSelect = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .ColumnHeadersDefaultCellStyle = New DataGridViewCellStyle With {
                .BackColor = Color.FromArgb(230, 126, 34),
                .ForeColor = Color.White,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Alignment = DataGridViewContentAlignment.MiddleLeft,
                .Padding = New Padding(5)
            },
            .RowHeadersVisible = False,
            .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle With {
                .BackColor = Color.FromArgb(245, 245, 245)
            },
            .DefaultCellStyle = New DataGridViewCellStyle With {
                .SelectionBackColor = Color.FromArgb(52, 152, 219),
                .SelectionForeColor = Color.White,
                .Font = New Font("Segoe UI", 9),
                .Padding = New Padding(5)
            }
        }

        ' Bottom Panel
        pnlBottom = New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 60,
            .BackColor = Color.White,
            .Padding = New Padding(20, 10, 20, 10)
        }

        btnExport = New Button With {
            .Text = "📊 Export to Excel",
            .Location = New Point(20, 10),
            .Size = New Size(150, 40),
            .BackColor = Color.FromArgb(46, 204, 113),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnExport.FlatAppearance.BorderSize = 0
        AddHandler btnExport.Click, AddressOf btnExport_Click

        btnClose = New Button With {
            .Text = "✖ Close",
            .Location = New Point(190, 10),
            .Size = New Size(120, 40),
            .BackColor = Color.FromArgb(231, 76, 60),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold)
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, AddressOf btnClose_Click

        pnlBottom.Controls.AddRange({btnExport, btnClose})

        Me.Controls.AddRange({pnlTop, dgvReport, pnlBottom})
    End Sub

    Private Sub Form_Load(sender As Object, e As EventArgs)
        LoadReport()
    End Sub

    Private Sub LoadBranches()
        Try
            Using con As New SqlConnection(connectionString)
                Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                Using ad As New SqlDataAdapter(sql, con)
                    Dim dt As New DataTable()
                    ad.Fill(dt)

                    If isSuperAdmin Then
                        Dim allRow = dt.NewRow()
                        allRow("BranchID") = 0
                        allRow("BranchName") = "All Branches"
                        dt.Rows.InsertAt(allRow, 0)
                    End If

                    cboBranch.DataSource = dt
                    cboBranch.DisplayMember = "BranchName"
                    cboBranch.ValueMember = "BranchID"

                    If isSuperAdmin Then
                        cboBranch.SelectedIndex = 0
                    Else
                        cboBranch.SelectedValue = currentBranchId
                        cboBranch.Enabled = False
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadCategories()
        Try
            Dim dt As New DataTable()
            dt.Columns.Add("CategoryValue", GetType(String))
            dt.Columns.Add("CategoryName", GetType(String))

            dt.Rows.Add("ALL", "All Categories")
            dt.Rows.Add("Ingredient", "Ingredients")
            dt.Rows.Add("Consumable", "Consumables")
            dt.Rows.Add("Packaging", "Packaging")
            dt.Rows.Add("Miscellaneous", "Miscellaneous")

            cboCategory.DataSource = dt
            cboCategory.DisplayMember = "CategoryName"
            cboCategory.ValueMember = "CategoryValue"
            cboCategory.SelectedIndex = 0
        Catch ex As Exception
            MessageBox.Show($"Error loading categories: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnLoad_Click(sender As Object, e As EventArgs)
        LoadReport()
    End Sub

    Private Sub LoadReport()
        Try
            Dim branchId As Integer = If(cboBranch.SelectedValue IsNot Nothing, Convert.ToInt32(cboBranch.SelectedValue), currentBranchId)
            Dim category As String = If(cboCategory.SelectedValue IsNot Nothing, cboCategory.SelectedValue.ToString(), "ALL")

            Using con As New SqlConnection(connectionString)
                Dim sql As String = "SELECT " &
                                   "ISNULL(drp.Code, drp.SKU) AS [Code], " &
                                   "drp.Name AS [Ingredient Name], " &
                                   "drp.Category AS [Category], " &
                                   "'unit' AS [Unit], " &
                                   "ISNULL(drp.CurrentStock, 0) AS [Qty On Hand], " &
                                   "ISNULL(drp.AverageCost, 0) AS [Avg Cost], " &
                                   "ISNULL(drp.LastPaidPrice, 0) AS [Last Cost], " &
                                   "(ISNULL(drp.CurrentStock, 0) * ISNULL(drp.AverageCost, 0)) AS [Stock Value], " &
                                   "drp.ProductType AS [Type], " &
                                   "b.BranchName AS [Branch], " &
                                   "drp.LastUpdated AS [Last Updated] " &
                                   "FROM Demo_Retail_Product drp " &
                                   "INNER JOIN Branches b ON b.BranchID = drp.BranchID " &
                                   "WHERE drp.IsActive = 1 "

                ' Branch filter
                If branchId > 0 Then
                    sql &= "AND drp.BranchID = @BranchID "
                End If

                ' Category filter
                If category <> "ALL" Then
                    sql &= "AND drp.Category LIKE @Category "
                Else
                    sql &= "AND (drp.Category LIKE '%ingredient%' OR drp.Category LIKE '%consumable%' OR drp.Category LIKE '%pack%' OR drp.Category LIKE '%misce%') "
                End If

                sql &= "ORDER BY drp.Name"

                Using ad As New SqlDataAdapter(sql, con)
                    If branchId > 0 Then
                        ad.SelectCommand.Parameters.AddWithValue("@BranchID", branchId)
                    End If
                    If category <> "ALL" Then
                        ad.SelectCommand.Parameters.AddWithValue("@Category", "%" & category & "%")
                    End If

                    Dim dt As New DataTable()
                    ad.Fill(dt)
                    dgvReport.DataSource = dt
                    FormatGrid()
                    UpdateSummary(dt)
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub FormatGrid()
        Try
            If dgvReport.Columns.Count = 0 Then Return

            If dgvReport.Columns.Contains("Code") Then dgvReport.Columns("Code").Width = 100
            If dgvReport.Columns.Contains("Ingredient Name") Then dgvReport.Columns("Ingredient Name").Width = 250
            If dgvReport.Columns.Contains("Category") Then dgvReport.Columns("Category").Width = 120
            If dgvReport.Columns.Contains("Unit") Then dgvReport.Columns("Unit").Width = 80

            If dgvReport.Columns.Contains("Qty On Hand") Then
                dgvReport.Columns("Qty On Hand").Width = 100
                dgvReport.Columns("Qty On Hand").DefaultCellStyle.Format = "N2"
                dgvReport.Columns("Qty On Hand").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If

            If dgvReport.Columns.Contains("Avg Cost") Then
                dgvReport.Columns("Avg Cost").Width = 100
                dgvReport.Columns("Avg Cost").DefaultCellStyle.Format = "C2"
                dgvReport.Columns("Avg Cost").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If

            If dgvReport.Columns.Contains("Last Cost") Then
                dgvReport.Columns("Last Cost").Width = 100
                dgvReport.Columns("Last Cost").DefaultCellStyle.Format = "C2"
                dgvReport.Columns("Last Cost").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If

            If dgvReport.Columns.Contains("Stock Value") Then
                dgvReport.Columns("Stock Value").Width = 120
                dgvReport.Columns("Stock Value").DefaultCellStyle.Format = "C2"
                dgvReport.Columns("Stock Value").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If

            If dgvReport.Columns.Contains("Type") Then dgvReport.Columns("Type").Width = 90
            If dgvReport.Columns.Contains("Branch") Then dgvReport.Columns("Branch").Width = 120

            If dgvReport.Columns.Contains("Last Updated") Then
                dgvReport.Columns("Last Updated").Width = 140
                dgvReport.Columns("Last Updated").DefaultCellStyle.Format = "dd MMM yyyy HH:mm"
            End If
        Catch ex As Exception
            ' Column formatting failed - non-critical
        End Try
    End Sub

    Private Sub UpdateSummary(dt As DataTable)
        Try
            Dim totalItems As Integer = dt.Rows.Count
            Dim totalValue As Decimal = 0D
            Dim totalQty As Decimal = 0D

            For Each row As DataRow In dt.Rows
                If Not IsDBNull(row("Stock Value")) Then
                    totalValue += Convert.ToDecimal(row("Stock Value"))
                End If
                If Not IsDBNull(row("Qty On Hand")) Then
                    totalQty += Convert.ToDecimal(row("Qty On Hand"))
                End If
            Next

            lblSummary.Text = $"Total Items: {totalItems} | Total Qty: {totalQty:N2} | Total Value: {totalValue:C2}"
        Catch ex As Exception
            lblSummary.Text = "Summary calculation error"
        End Try
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs)
        Try
            Dim sfd As New SaveFileDialog With {
                .Filter = "CSV Files (*.csv)|*.csv",
                .FileName = $"IngredientInventory_{DateTime.Now:yyyyMMdd}.csv"
            }

            If sfd.ShowDialog() = DialogResult.OK Then
                ExportToCSV(sfd.FileName)
                MessageBox.Show("Report exported successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error exporting report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ExportToCSV(filePath As String)
        Using sw As New System.IO.StreamWriter(filePath)
            Dim headers As New List(Of String)
            For Each col As DataGridViewColumn In dgvReport.Columns
                If col.Visible Then headers.Add(col.HeaderText)
            Next
            sw.WriteLine(String.Join(",", headers))

            For Each row As DataGridViewRow In dgvReport.Rows
                If row.IsNewRow Then Continue For
                Dim values As New List(Of String)
                For Each col As DataGridViewColumn In dgvReport.Columns
                    If col.Visible Then
                        Dim val = row.Cells(col.Index).Value
                        values.Add(If(val IsNot Nothing, val.ToString().Replace(",", ";"), ""))
                    End If
                Next
                sw.WriteLine(String.Join(",", values))
            Next
        End Using
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs)
        Me.Close()
    End Sub
End Class
