Imports System.Data.SqlClient
Imports System.Data

Public Class SalesByProductReportForm
    Inherits BaseReportForm

    Private cmbCategory As ComboBox

    Public Sub New()
        MyBase.New()
        reportTitle = "Sales by Product Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
        
        ' Add category filter
        Dim lblCategory As New Label() With {
            .Text = "Category:",
            .Location = New Point(540, 15),
            .AutoSize = True
        }
        cmbCategory = New ComboBox() With {
            .Location = New Point(540, 35),
            .Width = 150,
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        LoadCategories()
        pnlFilters.Controls.AddRange({lblCategory, cmbCategory})
        
        ' Reposition buttons
        btnGenerate.Location = New Point(700, 30)
        btnExport.Location = New Point(830, 30)
        btnPrint.Location = New Point(960, 30)
    End Sub

    Private Sub LoadCategories()
        Try
            cmbCategory.Items.Clear()
            cmbCategory.Items.Add(New With {.CategoryID = 0, .CategoryName = "All Categories", .Display = "All Categories"})

            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("SELECT CategoryID, CategoryName FROM Categories ORDER BY CategoryName", conn)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            cmbCategory.Items.Add(New With {
                                .CategoryID = reader.GetInt32(0),
                                .CategoryName = reader.GetString(1),
                                .Display = reader.GetString(1)
                            })
                        End While
                    End Using
                End Using
            End Using

            cmbCategory.DisplayMember = "Display"
            cmbCategory.ValueMember = "CategoryID"
            If cmbCategory.Items.Count > 0 Then cmbCategory.SelectedIndex = 0
        Catch ex As Exception
            ' Silently fail if Categories table doesn't exist
        End Try
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim categoryID As Integer = 0
            If cmbCategory.SelectedItem IsNot Nothing Then
                Dim item = DirectCast(cmbCategory.SelectedItem, Object)
                categoryID = CInt(item.GetType().GetProperty("CategoryID").GetValue(item))
            End If

            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                Dim sql = "SELECT 
                            i.ProductName,
                            p.Category,
                            SUM(i.Quantity) AS TotalQuantity,
                            SUM(i.LineTotal) AS TotalSales,
                            COUNT(DISTINCT i.InvoiceNumber) AS TransactionCount,
                            AVG(i.UnitPrice) AS AvgPrice
                          FROM Invoices i
                          LEFT JOIN Demo_Retail_Product p ON p.ProductID = i.ProductID
                          WHERE i.SaleDate BETWEEN @StartDate AND @EndDate"
                
                Dim branchID = GetSelectedBranchID()
                If branchID > 0 Then
                    sql &= " AND i.BranchID = @BranchID"
                End If
                
                If categoryID > 0 Then
                    sql &= " AND p.CategoryID = @CategoryID"
                End If
                
                sql &= " GROUP BY i.ProductName, p.Category ORDER BY TotalSales DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@StartDate", dtpStartDate.Value.Date)
                    cmd.Parameters.AddWithValue("@EndDate", dtpEndDate.Value.Date)
                    If branchID > 0 Then
                        cmd.Parameters.AddWithValue("@BranchID", branchID)
                    End If
                    If categoryID > 0 Then
                        cmd.Parameters.AddWithValue("@CategoryID", categoryID)
                    End If

                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            dgvReport.DataSource = dt
            
            ' Format columns
            FormatNumberColumn("QuantitySold")
            FormatCurrencyColumn("TotalRevenue")
            FormatCurrencyColumn("TotalCost")
            FormatCurrencyColumn("GrossProfit")
            FormatCurrencyColumn("AveragePrice")
            
            If dt.Rows.Count > 0 Then
                Dim totalRevenue = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalRevenue")), 0D, r.Field(Of Decimal)("TotalRevenue")))
                Dim totalProfit = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("GrossProfit")), 0D, r.Field(Of Decimal)("GrossProfit")))
                Dim totalQty = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("QuantitySold")), 0, r.Field(Of Integer)("QuantitySold")))
                Dim margin = If(totalRevenue > 0, (totalProfit / totalRevenue * 100), 0)
                
                MessageBox.Show($"Summary:{vbCrLf}Total Units Sold: {totalQty:N0}{vbCrLf}Total Revenue: {totalRevenue:C2}{vbCrLf}Gross Profit: {totalProfit:C2}{vbCrLf}Profit Margin: {margin:F2}%", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
