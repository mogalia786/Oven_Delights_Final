Imports System.Data.SqlClient
Imports System.Data

Public Class DailySalesReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Daily Sales Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_DailySales", conn)
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
            
            ' Add totals row
            If dt.Rows.Count > 0 Then
                Dim totalSales = dt.AsEnumerable().Sum(Function(r) r.Field(Of Decimal)("TotalSales"))
                Dim totalCost = dt.AsEnumerable().Sum(Function(r) r.Field(Of Decimal)("TotalCost"))
                Dim totalProfit = dt.AsEnumerable().Sum(Function(r) r.Field(Of Decimal)("GrossProfit"))
                Dim totalTrans = dt.AsEnumerable().Sum(Function(r) r.Field(Of Integer)("TransactionCount"))
                
                MessageBox.Show($"Summary:{vbCrLf}Total Sales: {totalSales:C2}{vbCrLf}Total Cost: {totalCost:C2}{vbCrLf}Gross Profit: {totalProfit:C2}{vbCrLf}Transactions: {totalTrans:N0}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
