Imports System.Windows.Forms
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class RetailProductsStockReportForm
    Inherits Form

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private service As New StockroomService()
    Private currentBranchId As Integer
    Private isSuperAdmin As Boolean
    
    Public Sub New()
        InitializeComponent()
        currentBranchId = AppSession.CurrentBranchID
        isSuperAdmin = service.IsCurrentUserSuperAdmin()
        Me.Text = "Retail Products Stock Report"
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
                Dim sql = "SELECT p.ProductID, p.ProductCode, p.SKU, p.ProductName, p.ItemType, " &
                         "rs.QtyOnHand, rs.AverageCost, " &
                         "ISNULL(pp.SellingPrice, 0) AS SellingPrice, " &
                         "(rs.QtyOnHand * rs.AverageCost) AS StockValue, " &
                         "(rs.QtyOnHand * ISNULL(pp.SellingPrice, 0)) AS PotentialRevenue, " &
                         "c.CategoryName, b.BranchName " &
                         "FROM Retail_Stock rs " &
                         "INNER JOIN Products p ON p.ProductID = rs.VariantID " &
                         "LEFT JOIN ProductPricing pp ON pp.ProductID = p.ProductID AND pp.BranchID = rs.BranchID AND pp.IsActive = 1 " &
                         "LEFT JOIN Categories c ON c.CategoryID = p.CategoryID " &
                         "INNER JOIN Branches b ON b.BranchID = rs.BranchID " &
                         "WHERE rs.BranchID = @BranchID " &
                         "AND rs.QtyOnHand > 0 " &
                         "ORDER BY p.ProductName"
                
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
        
        dgvReport.Columns("ProductID").Visible = False
        dgvReport.Columns("ProductCode").HeaderText = "Code"
        dgvReport.Columns("ProductCode").Width = 100
        dgvReport.Columns("SKU").HeaderText = "SKU/Barcode"
        dgvReport.Columns("SKU").Width = 120
        dgvReport.Columns("ProductName").HeaderText = "Product Name"
        dgvReport.Columns("ProductName").Width = 250
        dgvReport.Columns("ItemType").HeaderText = "Type"
        dgvReport.Columns("ItemType").Width = 100
        dgvReport.Columns("QtyOnHand").HeaderText = "Qty On Hand"
        dgvReport.Columns("QtyOnHand").Width = 100
        dgvReport.Columns("QtyOnHand").DefaultCellStyle.Format = "N2"
        dgvReport.Columns("AverageCost").HeaderText = "Avg Cost"
        dgvReport.Columns("AverageCost").Width = 100
        dgvReport.Columns("AverageCost").DefaultCellStyle.Format = "C2"
        dgvReport.Columns("SellingPrice").HeaderText = "Selling Price"
        dgvReport.Columns("SellingPrice").Width = 100
        dgvReport.Columns("SellingPrice").DefaultCellStyle.Format = "C2"
        dgvReport.Columns("StockValue").HeaderText = "Stock Value (Cost)"
        dgvReport.Columns("StockValue").Width = 130
        dgvReport.Columns("StockValue").DefaultCellStyle.Format = "C2"
        dgvReport.Columns("PotentialRevenue").HeaderText = "Potential Revenue"
        dgvReport.Columns("PotentialRevenue").Width = 130
        dgvReport.Columns("PotentialRevenue").DefaultCellStyle.Format = "C2"
        dgvReport.Columns("CategoryName").HeaderText = "Category"
        dgvReport.Columns("CategoryName").Width = 150
        dgvReport.Columns("BranchName").HeaderText = "Branch"
        dgvReport.Columns("BranchName").Width = 150
    End Sub

    Private Sub UpdateSummary(dt As DataTable)
        Dim totalItems As Integer = dt.Rows.Count
        Dim totalStockValue As Decimal = 0D
        Dim totalRevenue As Decimal = 0D
        
        For Each row As DataRow In dt.Rows
            totalStockValue += Convert.ToDecimal(row("StockValue"))
            totalRevenue += Convert.ToDecimal(row("PotentialRevenue"))
        Next
        
        Dim potentialProfit As Decimal = totalRevenue - totalStockValue
        
        lblSummary.Text = $"Total Products: {totalItems} | Stock Value: {totalStockValue:C2} | Potential Revenue: {totalRevenue:C2} | Potential Profit: {potentialProfit:C2}"
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Try
            Dim sfd As New SaveFileDialog With {
                .Filter = "CSV Files (*.csv)|*.csv|Excel Files (*.xlsx)|*.xlsx",
                .FileName = $"RetailProductsReport_{DateTime.Now:yyyyMMdd}.csv"
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
