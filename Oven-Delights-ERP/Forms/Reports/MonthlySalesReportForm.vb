Imports System.Data.SqlClient
Imports System.Data

Public Class MonthlySalesReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Monthly Sales Trend Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_MonthlySales", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@StartDate", dtpStartDate.Value.Date)
                    cmd.Parameters.AddWithValue("@EndDate", dtpEndDate.Value.Date)
                    cmd.Parameters.AddWithValue("@BranchID", GetSelectedBranchID())

                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            dgvReport.DataSource = dt
            
            ' Format columns
            FormatCurrencyColumn("TotalSales")
            FormatCurrencyColumn("TotalCost")
            FormatCurrencyColumn("GrossProfit")
            FormatNumberColumn("TransactionCount")
            FormatCurrencyColumn("AverageSale")
            
            ' Add growth indicator
            If dt.Rows.Count > 1 Then
                For i As Integer = 1 To dt.Rows.Count - 1
                    Dim currentSales = If(IsDBNull(dt.Rows(i)("TotalSales")), 0D, Convert.ToDecimal(dt.Rows(i)("TotalSales")))
                    Dim previousSales = If(IsDBNull(dt.Rows(i - 1)("TotalSales")), 0D, Convert.ToDecimal(dt.Rows(i - 1)("TotalSales")))
                    
                    If previousSales > 0 Then
                        Dim growth = ((currentSales - previousSales) / previousSales) * 100
                        dgvReport.Rows(i).Cells("TotalSales").ToolTipText = $"Growth: {growth:F2}%"
                        
                        If growth > 0 Then
                            dgvReport.Rows(i).Cells("TotalSales").Style.ForeColor = Color.FromArgb(27, 94, 32)
                        ElseIf growth < 0 Then
                            dgvReport.Rows(i).Cells("TotalSales").Style.ForeColor = Color.FromArgb(183, 28, 28)
                        End If
                    End If
                Next
            End If
            
            If dt.Rows.Count > 0 Then
                Dim totalSales = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalSales")), 0D, r.Field(Of Decimal)("TotalSales")))
                Dim avgMonthlySales = totalSales / dt.Rows.Count
                
                MessageBox.Show($"Period Summary:{vbCrLf}Months: {dt.Rows.Count}{vbCrLf}Total Sales: {totalSales:C2}{vbCrLf}Average Monthly Sales: {avgMonthlySales:C2}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
