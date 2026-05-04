Imports System.Data.SqlClient
Imports System.Data

Public Class TopSellingProductsReportForm
    Inherits BaseReportForm

    Private nudTopN As NumericUpDown

    Public Sub New()
        MyBase.New()
        reportTitle = "Top Selling Products Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
        
        ' Add Top N filter
        Dim lblTopN As New Label() With {
            .Text = "Show Top:",
            .Location = New Point(540, 15),
            .AutoSize = True
        }
        nudTopN = New NumericUpDown() With {
            .Location = New Point(540, 35),
            .Width = 80,
            .Minimum = 5,
            .Maximum = 100,
            .Value = 20,
            .Increment = 5
        }
        
        pnlFilters.Controls.AddRange({lblTopN, nudTopN})
        
        ' Reposition buttons
        btnGenerate.Location = New Point(630, 30)
        btnExport.Location = New Point(760, 30)
        btnPrint.Location = New Point(890, 30)
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                Dim sql = "SELECT TOP (@TopN)
                            i.ProductName,
                            p.Category,
                            SUM(i.Quantity) AS QuantitySold,
                            SUM(i.LineTotal) AS TotalRevenue,
                            COUNT(DISTINCT i.InvoiceNumber) AS TimesOrdered,
                            AVG(i.UnitPrice) AS AveragePrice
                          FROM Invoices i
                          LEFT JOIN Demo_Retail_Product p ON p.ProductID = i.ProductID
                          WHERE i.SaleDate BETWEEN @StartDate AND @EndDate"
                
                Dim branchID = GetSelectedBranchID()
                If branchID > 0 Then
                    sql &= " AND i.BranchID = @BranchID"
                End If
                
                sql &= " GROUP BY i.ProductName, p.Category ORDER BY QuantitySold DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@StartDate", dtpStartDate.Value.Date)
                    cmd.Parameters.AddWithValue("@EndDate", dtpEndDate.Value.Date)
                    cmd.Parameters.AddWithValue("@TopN", CInt(nudTopN.Value))
                    If branchID > 0 Then
                        cmd.Parameters.AddWithValue("@BranchID", branchID)
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
            FormatNumberColumn("TimesOrdered")
            FormatCurrencyColumn("AveragePrice")
            
            ' Add ranking visual
            For i As Integer = 0 To Math.Min(2, dgvReport.Rows.Count - 1)
                dgvReport.Rows(i).DefaultCellStyle.BackColor = Color.FromArgb(255, 243, 224)
                dgvReport.Rows(i).DefaultCellStyle.Font = New Font(dgvReport.Font, FontStyle.Bold)
            Next
            
            If dt.Rows.Count > 0 Then
                Dim totalRevenue = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalRevenue")), 0D, r.Field(Of Decimal)("TotalRevenue")))
                Dim totalQty = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("QuantitySold")), 0, r.Field(Of Integer)("QuantitySold")))
                
                MessageBox.Show($"Top {dt.Rows.Count} Products:{vbCrLf}Total Units: {totalQty:N0}{vbCrLf}Total Revenue: {totalRevenue:C2}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
