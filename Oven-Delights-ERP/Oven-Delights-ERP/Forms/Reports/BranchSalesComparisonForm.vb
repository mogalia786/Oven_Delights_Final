Imports System.Data.SqlClient
Imports System.Data
Imports System.Windows.Forms.DataVisualization.Charting

Public Class BranchSalesComparisonForm
    Inherits BaseReportForm

    Private chart As Chart

    Public Sub New()
        MyBase.New()
        reportTitle = "Branch Sales Comparison"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
        
        ' Add chart control
        chart = New Chart()
        chart.Dock = DockStyle.Bottom
        chart.Height = 400
        chart.BackColor = Color.White
        
        Dim chartArea As New ChartArea("MainArea")
        chartArea.AxisX.Title = "Branch"
        chartArea.AxisY.Title = "Sales Amount (R)"
        chartArea.AxisY.LabelStyle.Format = "C0"
        chart.ChartAreas.Add(chartArea)
        
        Dim legend As New Legend("Legend")
        legend.Docking = Docking.Top
        chart.Legends.Add(legend)
        
        Me.Controls.Add(chart)
        chart.BringToFront()
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                Dim sql = "SELECT 
                            b.BranchName,
                            COUNT(*) AS TransactionCount,
                            SUM(ds.TotalAmount) AS TotalSales,
                            AVG(ds.TotalAmount) AS AvgSaleAmount,
                            SUM(ds.ItemCount) AS TotalItems
                          FROM DailySales ds
                          INNER JOIN Branches b ON b.BranchID = ds.BranchID
                          WHERE ds.SaleDate BETWEEN @StartDate AND @EndDate
                          GROUP BY b.BranchName
                          ORDER BY TotalSales DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@StartDate", dtpStartDate.Value.Date)
                    cmd.Parameters.AddWithValue("@EndDate", dtpEndDate.Value.Date)

                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            dgvReport.DataSource = dt
            
            ' Format columns
            If dgvReport.Columns.Contains("TotalSales") Then
                dgvReport.Columns("TotalSales").DefaultCellStyle.Format = "C2"
            End If
            If dgvReport.Columns.Contains("AvgSaleAmount") Then
                dgvReport.Columns("AvgSaleAmount").DefaultCellStyle.Format = "C2"
            End If
            
            ' Update chart
            UpdateChart(dt)
            
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub UpdateChart(dt As DataTable)
        chart.Series.Clear()
        
        If dt.Rows.Count = 0 Then Return
        
        ' Sales Series
        Dim salesSeries As New Series("Total Sales")
        salesSeries.ChartType = SeriesChartType.Column
        salesSeries.Color = Color.FromArgb(46, 125, 50)
        salesSeries.IsValueShownAsLabel = True
        salesSeries.LabelFormat = "C0"
        
        For Each row As DataRow In dt.Rows
            salesSeries.Points.AddXY(row("BranchName").ToString(), CDec(row("TotalSales")))
        Next
        
        chart.Series.Add(salesSeries)
        
        ' Transaction Count Series
        Dim transSeries As New Series("Transactions")
        transSeries.ChartType = SeriesChartType.Line
        transSeries.Color = Color.FromArgb(33, 150, 243)
        transSeries.BorderWidth = 3
        transSeries.MarkerStyle = MarkerStyle.Circle
        transSeries.MarkerSize = 8
        transSeries.YAxisType = AxisType.Secondary
        
        chart.ChartAreas(0).AxisY2.Title = "Transaction Count"
        chart.ChartAreas(0).AxisY2.LabelStyle.Format = "N0"
        
        For Each row As DataRow In dt.Rows
            transSeries.Points.AddXY(row("BranchName").ToString(), CInt(row("TransactionCount")))
        Next
        
        chart.Series.Add(transSeries)
    End Sub
End Class
