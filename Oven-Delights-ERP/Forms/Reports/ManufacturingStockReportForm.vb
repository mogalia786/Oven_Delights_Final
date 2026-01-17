Imports System.Windows.Forms
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class ManufacturingStockReportForm
    Inherits Form

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private currentBranchId As Integer
    Private isSuperAdmin As Boolean

    Public Sub New()
        InitializeComponent()
        currentBranchId = AppSession.CurrentBranchID
        isSuperAdmin = False ' Default to non-admin
        Me.Text = "Manufacturing Stock Report (WIP)"
        Me.WindowState = FormWindowState.Maximized

        If Not isSuperAdmin Then
            If cboBranch IsNot Nothing Then cboBranch.Visible = False
            If lblBranch IsNot Nothing Then lblBranch.Visible = False
        End If

        LoadBranches()
        AddHandler Me.Load, AddressOf Form_Load
    End Sub

    Private Sub Form_Load(sender As Object, e As EventArgs)
        LoadReport()
    End Sub

    Private Sub LoadBranches()
        Try
            If cboBranch Is Nothing Then Return

            Using con As New SqlConnection(connectionString)
                Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                Using ad As New SqlDataAdapter(sql, con)
                    Dim dt As New DataTable()
                    ad.Fill(dt)
                    cboBranch.DataSource = dt
                    cboBranch.DisplayMember = "BranchName"
                    cboBranch.ValueMember = "BranchID"
                    If Not isSuperAdmin Then
                        cboBranch.SelectedValue = currentBranchId
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnLoad_Click(sender As Object, e As EventArgs) Handles btnLoad.Click
        LoadReport()
    End Sub

    Private Sub LoadReport()
        Try
            Dim branchId As Integer = If(isSuperAdmin AndAlso cboBranch.SelectedValue IsNot Nothing, Convert.ToInt32(cboBranch.SelectedValue), currentBranchId)

            Using con As New SqlConnection(connectionString)
                ' Query actual manufacturing inventory (ingredients in WIP)
                Dim sql = "SELECT " &
                         "drp.ProductID AS MaterialID, " &
                         "ISNULL(drp.Code, drp.SKU) AS MaterialCode, " &
                         "drp.Name AS MaterialName, " &
                         "drp.Category AS MaterialType, " &
                         "'unit' AS UnitOfMeasure, " &
                         "ISNULL(drp.CurrentStock, 0) AS QtyOnHand, " &
                         "ISNULL(drp.AverageCost, 0) AS AverageCost, " &
                         "ISNULL(drp.CurrentStock, 0) * ISNULL(drp.AverageCost, 0) AS StockValue, " &
                         "drp.LastUpdated, " &
                         "b.BranchName " &
                         "FROM Demo_Retail_Product drp " &
                         "INNER JOIN Branches b ON b.BranchID = drp.BranchID " &
                         "WHERE drp.BranchID = @BranchID " &
                         "AND (drp.Category LIKE '%ingredient%' OR drp.Category LIKE '%consumable%' OR drp.Category LIKE '%pack%') " &
                         "AND ISNULL(drp.CurrentStock, 0) > 0 " &
                         "ORDER BY drp.Name"

                Using ad As New SqlDataAdapter(sql, con)
                    ad.SelectCommand.Parameters.AddWithValue("@BranchID", branchId)
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

            If dgvReport.Columns.Contains("MaterialID") Then dgvReport.Columns("MaterialID").Visible = False
            If dgvReport.Columns.Contains("MaterialCode") Then
                dgvReport.Columns("MaterialCode").HeaderText = "Code"
                dgvReport.Columns("MaterialCode").Width = 100
            End If
            If dgvReport.Columns.Contains("MaterialName") Then
                dgvReport.Columns("MaterialName").HeaderText = "Material Name"
                dgvReport.Columns("MaterialName").Width = 250
            End If
            If dgvReport.Columns.Contains("MaterialType") Then
                dgvReport.Columns("MaterialType").HeaderText = "Type"
                dgvReport.Columns("MaterialType").Width = 100
            End If
            If dgvReport.Columns.Contains("UnitOfMeasure") Then
                dgvReport.Columns("UnitOfMeasure").HeaderText = "UoM"
                dgvReport.Columns("UnitOfMeasure").Width = 80
            End If
            If dgvReport.Columns.Contains("QtyOnHand") Then
                dgvReport.Columns("QtyOnHand").HeaderText = "WIP Qty"
                dgvReport.Columns("QtyOnHand").Width = 100
                dgvReport.Columns("QtyOnHand").DefaultCellStyle.Format = "N2"
            End If
            If dgvReport.Columns.Contains("AverageCost") Then
                dgvReport.Columns("AverageCost").HeaderText = "Avg Cost"
                dgvReport.Columns("AverageCost").Width = 100
                dgvReport.Columns("AverageCost").DefaultCellStyle.Format = "C2"
            End If
            If dgvReport.Columns.Contains("StockValue") Then
                dgvReport.Columns("StockValue").HeaderText = "WIP Value"
                dgvReport.Columns("StockValue").Width = 120
                dgvReport.Columns("StockValue").DefaultCellStyle.Format = "C2"
            End If
            If dgvReport.Columns.Contains("LastUpdated") Then
                dgvReport.Columns("LastUpdated").HeaderText = "Last Updated"
                dgvReport.Columns("LastUpdated").Width = 150
                dgvReport.Columns("LastUpdated").DefaultCellStyle.Format = "dd MMM yyyy HH:mm"
            End If
            If dgvReport.Columns.Contains("BranchName") Then
                dgvReport.Columns("BranchName").HeaderText = "Branch"
                dgvReport.Columns("BranchName").Width = 150
            End If
        Catch ex As Exception
            ' Column formatting failed - non-critical
        End Try
    End Sub

    Private Sub UpdateSummary(dt As DataTable)
        Dim totalItems As Integer = dt.Rows.Count
        Dim totalValue As Decimal = 0D
        
        For Each row As DataRow In dt.Rows
            totalValue += Convert.ToDecimal(row("StockValue"))
        Next
        
        lblSummary.Text = $"Total WIP Items: {totalItems} | Total WIP Value: {totalValue:C2}"
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Try
            Dim sfd As New SaveFileDialog With {
                .Filter = "CSV Files (*.csv)|*.csv|Excel Files (*.xlsx)|*.xlsx",
                .FileName = $"ManufacturingWIPReport_{DateTime.Now:yyyyMMdd}.csv"
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

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
