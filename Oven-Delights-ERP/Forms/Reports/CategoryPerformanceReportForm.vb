Imports System.Data.SqlClient
Imports System.Data

Public Class CategoryPerformanceReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Category Performance Analysis"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_CategoryPerformance", conn)
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
            FormatNumberColumn("ProductCount")
            FormatNumberColumn("TotalUnitsSold")
            FormatCurrencyColumn("TotalRevenue")
            FormatCurrencyColumn("TotalCost")
            FormatCurrencyColumn("GrossProfit")
            FormatCurrencyColumn("AveragePrice")
            
            ' Format profit margin as percentage
            If dgvReport.Columns.Contains("ProfitMargin") Then
                dgvReport.Columns("ProfitMargin").DefaultCellStyle.Format = "P2"
                dgvReport.Columns("ProfitMargin").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            
            ' Highlight top performer
            If dt.Rows.Count > 0 Then
                Dim maxRevenue = dt.AsEnumerable().Max(Function(r) If(IsDBNull(r("TotalRevenue")), 0D, r.Field(Of Decimal)("TotalRevenue")))
                For Each row As DataGridViewRow In dgvReport.Rows
                    If row.Cells("TotalRevenue").Value IsNot Nothing AndAlso 
                       Convert.ToDecimal(row.Cells("TotalRevenue").Value) = maxRevenue Then
                        row.DefaultCellStyle.BackColor = Color.FromArgb(232, 245, 233)
                        row.DefaultCellStyle.Font = New Font(dgvReport.Font, FontStyle.Bold)
                    End If
                Next
                
                Dim totalRevenue = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalRevenue")), 0D, r.Field(Of Decimal)("TotalRevenue")))
                Dim totalProfit = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("GrossProfit")), 0D, r.Field(Of Decimal)("GrossProfit")))
                Dim avgMargin = If(totalRevenue > 0, (totalProfit / totalRevenue), 0)
                
                MessageBox.Show($"Category Summary:{vbCrLf}Total Categories: {dt.Rows.Count}{vbCrLf}Total Revenue: {totalRevenue:C2}{vbCrLf}Total Profit: {totalProfit:C2}{vbCrLf}Average Margin: {avgMargin:P2}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
