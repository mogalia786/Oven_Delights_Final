Imports System.Windows.Forms
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class ManufacturingStockReportForm
    Inherits Form

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private service As New StockroomService()
    Private currentBranchId As Integer
    Private isSuperAdmin As Boolean
    
    Public Sub New()
        InitializeComponent()
        currentBranchId = AppSession.CurrentBranchID
        isSuperAdmin = service.IsCurrentUserSuperAdmin()
        Me.Text = "Manufacturing Stock Report (WIP)"
        Me.WindowState = FormWindowState.Maximized
        
        If Not isSuperAdmin Then
            cboBranch.Visible = False
            lblBranch.Visible = False
        End If
        
        LoadBranches()
        LoadReport()
    End Sub

    Private Sub LoadBranches()
        Try
            Dim branches = service.GetBranchesLookup()
            If branches IsNot Nothing Then
                cboBranch.DataSource = branches
                cboBranch.DisplayMember = "BranchName"
                cboBranch.ValueMember = "BranchID"
                If Not isSuperAdmin Then
                    cboBranch.SelectedValue = currentBranchId
                End If
            End If
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
                Dim sql = "SELECT mi.MaterialID, rm.MaterialCode, rm.MaterialName, rm.MaterialType, " &
                         "rm.UnitOfMeasure, mi.QtyOnHand, mi.AverageCost, " &
                         "(mi.QtyOnHand * mi.AverageCost) AS StockValue, " &
                         "mi.LastUpdated, b.BranchName " &
                         "FROM Manufacturing_Inventory mi " &
                         "INNER JOIN RawMaterials rm ON rm.MaterialID = mi.MaterialID " &
                         "INNER JOIN Branches b ON b.BranchID = mi.BranchID " &
                         "WHERE mi.BranchID = @BranchID " &
                         "AND mi.QtyOnHand > 0 " &
                         "ORDER BY rm.MaterialName"
                
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
        If dgvReport.Columns.Count = 0 Then Return
        
        dgvReport.Columns("MaterialID").Visible = False
        dgvReport.Columns("MaterialCode").HeaderText = "Code"
        dgvReport.Columns("MaterialCode").Width = 100
        dgvReport.Columns("MaterialName").HeaderText = "Material Name"
        dgvReport.Columns("MaterialName").Width = 250
        dgvReport.Columns("MaterialType").HeaderText = "Type"
        dgvReport.Columns("MaterialType").Width = 100
        dgvReport.Columns("UnitOfMeasure").HeaderText = "UoM"
        dgvReport.Columns("UnitOfMeasure").Width = 80
        dgvReport.Columns("QtyOnHand").HeaderText = "WIP Qty"
        dgvReport.Columns("QtyOnHand").Width = 100
        dgvReport.Columns("QtyOnHand").DefaultCellStyle.Format = "N2"
        dgvReport.Columns("AverageCost").HeaderText = "Avg Cost"
        dgvReport.Columns("AverageCost").Width = 100
        dgvReport.Columns("AverageCost").DefaultCellStyle.Format = "C2"
        dgvReport.Columns("StockValue").HeaderText = "WIP Value"
        dgvReport.Columns("StockValue").Width = 120
        dgvReport.Columns("StockValue").DefaultCellStyle.Format = "C2"
        dgvReport.Columns("LastUpdated").HeaderText = "Last Updated"
        dgvReport.Columns("LastUpdated").Width = 150
        dgvReport.Columns("LastUpdated").DefaultCellStyle.Format = "dd MMM yyyy HH:mm"
        dgvReport.Columns("BranchName").HeaderText = "Branch"
        dgvReport.Columns("BranchName").Width = 150
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
