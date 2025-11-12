Imports System.Data.SqlClient
Imports System.Data

Public Class BranchPerformanceReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Branch Performance Comparison"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
        
        ' Hide branch filter for this report (shows all branches)
        cmbBranch.Visible = False
        pnlFilters.Controls.Cast(Of Control)().FirstOrDefault(Function(c) TypeOf c Is Label AndAlso CType(c, Label).Text = "Branch:")?.Hide()
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_BranchPerformance", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@StartDate", dtpStartDate.Value.Date)
                    cmd.Parameters.AddWithValue("@EndDate", dtpEndDate.Value.Date)

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
            FormatCurrencyColumn("AverageTransaction")
            
            ' Add percentage column formatting
            If dgvReport.Columns.Contains("ProfitMargin") Then
                dgvReport.Columns("ProfitMargin").DefaultCellStyle.Format = "P2"
                dgvReport.Columns("ProfitMargin").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            
            ' Highlight top performer
            If dt.Rows.Count > 0 Then
                Dim maxSales = dt.AsEnumerable().Max(Function(r) If(IsDBNull(r("TotalSales")), 0D, r.Field(Of Decimal)("TotalSales")))
                For Each row As DataGridViewRow In dgvReport.Rows
                    If row.Cells("TotalSales").Value IsNot Nothing AndAlso 
                       Convert.ToDecimal(row.Cells("TotalSales").Value) = maxSales Then
                        row.DefaultCellStyle.BackColor = Color.FromArgb(232, 245, 233)
                        row.DefaultCellStyle.Font = New Font(dgvReport.Font, FontStyle.Bold)
                    End If
                Next
                
                Dim totalSales = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalSales")), 0D, r.Field(Of Decimal)("TotalSales")))
                Dim totalProfit = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("GrossProfit")), 0D, r.Field(Of Decimal)("GrossProfit")))
                
                MessageBox.Show($"Summary:{vbCrLf}Total Branches: {dt.Rows.Count}{vbCrLf}Combined Sales: {totalSales:C2}{vbCrLf}Combined Profit: {totalProfit:C2}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
