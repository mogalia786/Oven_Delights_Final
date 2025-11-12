Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class StockroomStockReportForm
    Private connectionString As String
    Private currentBranchId As Integer

    Public Sub New()
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        currentBranchId = AppSession.CurrentBranchID
        LoadReport()
    End Sub

    Private Sub btnLoad_Click(sender As Object, e As EventArgs) Handles btnLoad.Click
        LoadReport()
    End Sub

    Private Sub LoadReport()
        Try
            Using con As New SqlConnection(connectionString)
                ' Read from branch-specific StockroomStock table
                Dim sql = "SELECT rm.MaterialID, rm.MaterialCode, rm.MaterialName, " &
                         "rm.MaterialType AS CategoryName, " &
                         "ISNULL(ss.Quantity, 0) AS QtyOnHand, " &
                         "rm.BaseUnit AS UoM, " &
                         "rm.ReorderLevel, rm.AverageCost, " &
                         "(ISNULL(ss.Quantity, 0) * rm.AverageCost) AS StockValue, " &
                         "s.SupplierName AS PreferredSupplier " &
                         "FROM RawMaterials rm " &
                         "LEFT JOIN StockroomStock ss ON ss.ProductID = rm.MaterialID AND ss.BranchID = @BranchID " &
                         "LEFT JOIN Suppliers s ON s.SupplierID = rm.PreferredSupplierID " &
                         "ORDER BY rm.MaterialName"

                Using ad As New SqlDataAdapter(sql, con)
                    ad.SelectCommand.Parameters.AddWithValue("@BranchID", currentBranchId)
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
            If dgvReport.Columns.Contains("CategoryName") Then
                dgvReport.Columns("CategoryName").HeaderText = "Category"
                dgvReport.Columns("CategoryName").Width = 120
            End If
            If dgvReport.Columns.Contains("QtyOnHand") Then
                dgvReport.Columns("QtyOnHand").HeaderText = "Stock Qty"
                dgvReport.Columns("QtyOnHand").Width = 100
                dgvReport.Columns("QtyOnHand").DefaultCellStyle.Format = "N2"
                dgvReport.Columns("QtyOnHand").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            If dgvReport.Columns.Contains("UoM") Then
                dgvReport.Columns("UoM").HeaderText = "UoM"
                dgvReport.Columns("UoM").Width = 60
            End If
            If dgvReport.Columns.Contains("ReorderLevel") Then
                dgvReport.Columns("ReorderLevel").HeaderText = "Reorder Level"
                dgvReport.Columns("ReorderLevel").Width = 100
                dgvReport.Columns("ReorderLevel").DefaultCellStyle.Format = "N2"
                dgvReport.Columns("ReorderLevel").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            If dgvReport.Columns.Contains("AverageCost") Then
                dgvReport.Columns("AverageCost").HeaderText = "Avg Cost"
                dgvReport.Columns("AverageCost").Width = 100
                dgvReport.Columns("AverageCost").DefaultCellStyle.Format = "C2"
                dgvReport.Columns("AverageCost").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            If dgvReport.Columns.Contains("StockValue") Then
                dgvReport.Columns("StockValue").HeaderText = "Stock Value"
                dgvReport.Columns("StockValue").Width = 120
                dgvReport.Columns("StockValue").DefaultCellStyle.Format = "C2"
                dgvReport.Columns("StockValue").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            If dgvReport.Columns.Contains("PreferredSupplier") Then
                dgvReport.Columns("PreferredSupplier").HeaderText = "Supplier"
                dgvReport.Columns("PreferredSupplier").Width = 150
            End If

            ' Color code low stock
            For Each row As DataGridViewRow In dgvReport.Rows
                If row.Cells("QtyOnHand").Value IsNot Nothing AndAlso row.Cells("ReorderLevel").Value IsNot Nothing Then
                    Dim qty As Decimal = Convert.ToDecimal(row.Cells("QtyOnHand").Value)
                    Dim reorder As Decimal = Convert.ToDecimal(row.Cells("ReorderLevel").Value)
                    If qty <= reorder Then
                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 220, 220)
                        row.DefaultCellStyle.ForeColor = Color.FromArgb(192, 57, 43)
                    End If
                End If
            Next
        Catch ex As Exception
            ' Column formatting failed - non-critical
        End Try
    End Sub

    Private Sub UpdateSummary(dt As DataTable)
        Dim totalItems As Integer = dt.Rows.Count
        Dim totalValue As Decimal = 0D
        Dim lowStockCount As Integer = 0

        For Each row As DataRow In dt.Rows
            If Not IsDBNull(row("StockValue")) Then
                totalValue += Convert.ToDecimal(row("StockValue"))
            End If
            If Not IsDBNull(row("QtyOnHand")) AndAlso Not IsDBNull(row("ReorderLevel")) Then
                If Convert.ToDecimal(row("QtyOnHand")) <= Convert.ToDecimal(row("ReorderLevel")) Then
                    lowStockCount += 1
                End If
            End If
        Next

        lblSummary.Text = $"Total Items: {totalItems} | Total Value: {totalValue:C2} | Low Stock: {lowStockCount}"
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        MessageBox.Show("Export functionality coming soon", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
