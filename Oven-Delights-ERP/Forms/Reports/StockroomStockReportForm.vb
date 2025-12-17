Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class StockroomStockReportForm
    Private connectionString As String
    Private currentBranchId As Integer

    Public Sub New()
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        currentBranchId = If(AppSession.CurrentUser?.BranchID, 0)
    End Sub

    Private Sub StockroomStockReportForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        LoadBranches()
        LoadReport()
    End Sub

    Private Sub LoadBranches()
        Try
            cboBranch.Items.Clear()

            If currentBranchId = 0 Then
                ' Head Office - hide branch dropdown (shows all branches by default)
                cboBranch.Items.Add(New With {.BranchID = 0, .BranchName = "All Branches"})
                cboBranch.DisplayMember = "BranchName"
                cboBranch.ValueMember = "BranchID"
                cboBranch.SelectedIndex = 0
                cboBranch.Visible = False
                lblBranch.Visible = False
            Else
                ' Specific branch - show locked to current branch
                Using con As New SqlConnection(connectionString)
                    con.Open()
                    Using cmd As New SqlCommand("SELECT BranchName FROM Branches WHERE BranchID = @BranchID", con)
                        cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                        Dim branchName = cmd.ExecuteScalar()?.ToString()
                        cboBranch.Items.Add(New With {.BranchID = currentBranchId, .BranchName = branchName})
                    End Using
                End Using
                cboBranch.DisplayMember = "BranchName"
                cboBranch.ValueMember = "BranchID"
                cboBranch.SelectedIndex = 0
                cboBranch.Enabled = False
                cboBranch.Visible = True
                lblBranch.Visible = True
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
            ' Get selected branch
            Dim selectedBranchId As Integer = currentBranchId
            If cboBranch.SelectedItem IsNot Nothing Then
                Dim selectedBranch = DirectCast(cboBranch.SelectedItem, Object)
                selectedBranchId = CInt(selectedBranch.BranchID)
            End If

            Using con As New SqlConnection(connectionString)
                Dim sql As String
                If selectedBranchId = 0 Then
                    ' All branches - ONLY use columns from schema
                    sql = "SELECT DISTINCT " &
                          "p.ProductID, " &
                          "p.ProductCode, " &
                          "p.Name AS ProductName, " &
                          "p.Category AS CategoryName, " &
                          "ISNULL(p.CurrentStock, 0) AS QtyOnHand, " &
                          "ISNULL((SELECT TOP 1 CostPrice FROM Demo_Retail_Price WHERE ProductID = p.ProductID ORDER BY CreatedAt DESC), 0) AS CostPrice, " &
                          "ISNULL((SELECT TOP 1 SellingPrice FROM Demo_Retail_Price WHERE ProductID = p.ProductID ORDER BY CreatedAt DESC), 0) AS SellingPrice, " &
                          "(ISNULL(p.CurrentStock, 0) * ISNULL((SELECT TOP 1 CostPrice FROM Demo_Retail_Price WHERE ProductID = p.ProductID ORDER BY CreatedAt DESC), 0)) AS StockValue " &
                          "FROM Demo_Retail_Product p " &
                          "WHERE (p.Category LIKE '%ingredient%' OR p.Category LIKE '%consumable%' OR p.Category LIKE '%packaging%' OR p.Category LIKE '%misce%') " &
                          "ORDER BY p.Name"
                Else
                    ' Specific branch
                    sql = "SELECT " &
                          "p.ProductID, " &
                          "p.ProductCode, " &
                          "p.Name AS ProductName, " &
                          "p.Category AS CategoryName, " &
                          "ISNULL(p.CurrentStock, 0) AS QtyOnHand, " &
                          "ISNULL((SELECT TOP 1 CostPrice FROM Demo_Retail_Price WHERE ProductID = p.ProductID AND BranchID = @BranchID ORDER BY CreatedAt DESC), 0) AS CostPrice, " &
                          "ISNULL((SELECT TOP 1 SellingPrice FROM Demo_Retail_Price WHERE ProductID = p.ProductID AND BranchID = @BranchID ORDER BY CreatedAt DESC), 0) AS SellingPrice, " &
                          "(ISNULL(p.CurrentStock, 0) * ISNULL((SELECT TOP 1 CostPrice FROM Demo_Retail_Price WHERE ProductID = p.ProductID AND BranchID = @BranchID ORDER BY CreatedAt DESC), 0)) AS StockValue " &
                          "FROM Demo_Retail_Product p " &
                          "WHERE p.BranchID = @BranchID " &
                          "AND (p.Category LIKE '%ingredient%' OR p.Category LIKE '%consumable%' OR p.Category LIKE '%packaging%' OR p.Category LIKE '%misce%') " &
                          "ORDER BY p.Name"
                End If

                Using ad As New SqlDataAdapter(sql, con)
                    If selectedBranchId > 0 Then
                        ad.SelectCommand.Parameters.AddWithValue("@BranchID", selectedBranchId)
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

            ' Hide columns
            If dgvReport.Columns.Contains("ProductID") Then dgvReport.Columns("ProductID").Visible = False
            
            ' Format visible columns
            If dgvReport.Columns.Contains("ProductCode") Then
                dgvReport.Columns("ProductCode").HeaderText = "Code"
                dgvReport.Columns("ProductCode").Width = 80
            End If
            If dgvReport.Columns.Contains("ProductName") Then
                dgvReport.Columns("ProductName").HeaderText = "Product Name"
                dgvReport.Columns("ProductName").Width = 200
            End If
            If dgvReport.Columns.Contains("CategoryName") Then
                dgvReport.Columns("CategoryName").HeaderText = "Category"
                dgvReport.Columns("CategoryName").Width = 150
            End If
            If dgvReport.Columns.Contains("QtyOnHand") Then
                dgvReport.Columns("QtyOnHand").HeaderText = "Stock Qty"
                dgvReport.Columns("QtyOnHand").Width = 80
                dgvReport.Columns("QtyOnHand").DefaultCellStyle.Format = "N2"
                dgvReport.Columns("QtyOnHand").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            If dgvReport.Columns.Contains("CostPrice") Then
                dgvReport.Columns("CostPrice").HeaderText = "Cost Price"
                dgvReport.Columns("CostPrice").Width = 90
                dgvReport.Columns("CostPrice").DefaultCellStyle.Format = "C2"
                dgvReport.Columns("CostPrice").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            If dgvReport.Columns.Contains("SellingPrice") Then
                dgvReport.Columns("SellingPrice").HeaderText = "Selling Price"
                dgvReport.Columns("SellingPrice").Width = 100
                dgvReport.Columns("SellingPrice").DefaultCellStyle.Format = "C2"
                dgvReport.Columns("SellingPrice").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            If dgvReport.Columns.Contains("StockValue") Then
                dgvReport.Columns("StockValue").HeaderText = "Stock Value"
                dgvReport.Columns("StockValue").Width = 100
                dgvReport.Columns("StockValue").DefaultCellStyle.Format = "C2"
                dgvReport.Columns("StockValue").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If

            ' Color code low/zero stock
            For Each row As DataGridViewRow In dgvReport.Rows
                If row.Cells("QtyOnHand").Value IsNot Nothing Then
                    Dim qty As Decimal = Convert.ToDecimal(row.Cells("QtyOnHand").Value)
                    If qty <= 0 Then
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
        Dim zeroStockCount As Integer = 0

        For Each row As DataRow In dt.Rows
            If Not IsDBNull(row("StockValue")) Then
                totalValue += Convert.ToDecimal(row("StockValue"))
            End If
            If Not IsDBNull(row("QtyOnHand")) Then
                If Convert.ToDecimal(row("QtyOnHand")) <= 0 Then
                    zeroStockCount += 1
                End If
            End If
        Next

        lblSummary.Text = $"Total Items: {totalItems} | Total Value: {totalValue:C2} | Zero Stock: {zeroStockCount}"
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Try
            ' Create print document
            Dim printDoc As New Printing.PrintDocument()
            AddHandler printDoc.PrintPage, AddressOf PrintDocument_PrintPage
            
            ' Show print preview
            Dim printPreview As New PrintPreviewDialog()
            printPreview.Document = printDoc
            printPreview.ShowDialog()
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub PrintDocument_PrintPage(sender As Object, e As Printing.PrintPageEventArgs)
        Dim font As New Font("Arial", 10)
        Dim headerFont As New Font("Arial", 12, FontStyle.Bold)
        Dim y As Integer = 50
        Dim x As Integer = 50
        
        ' Print title
        e.Graphics.DrawString("Stockroom Stock Report", headerFont, Brushes.Black, x, y)
        y += 30
        e.Graphics.DrawString($"Generated: {DateTime.Now:yyyy-MM-dd HH:mm}", font, Brushes.Black, x, y)
        y += 40
        
        ' Print column headers
        Dim colX As Integer = x
        For Each col As DataGridViewColumn In dgvReport.Columns
            If col.Visible Then
                e.Graphics.DrawString(col.HeaderText, New Font("Arial", 9, FontStyle.Bold), Brushes.Black, colX, y)
                colX += 100
            End If
        Next
        y += 25
        
        ' Print rows
        For Each row As DataGridViewRow In dgvReport.Rows
            If y > e.PageBounds.Height - 100 Then Exit For ' Page break
            colX = x
            For Each col As DataGridViewColumn In dgvReport.Columns
                If col.Visible AndAlso row.Cells(col.Index).Value IsNot Nothing Then
                    e.Graphics.DrawString(row.Cells(col.Index).Value.ToString(), font, Brushes.Black, colX, y)
                    colX += 100
                End If
            Next
            y += 20
        Next
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
