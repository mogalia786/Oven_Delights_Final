Imports System.Data.SqlClient
Imports System.Data

Public Class SupplierPerformanceReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Supplier Performance Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_SupplierPerformance", conn)
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
            FormatNumberColumn("TotalOrders")
            FormatCurrencyColumn("TotalPurchases")
            FormatCurrencyColumn("AverageOrderValue")
            FormatNumberColumn("OnTimeDeliveries")
            FormatNumberColumn("LateDeliveries")
            
            ' Add percentage column for on-time delivery
            If dgvReport.Columns.Contains("OnTimePercentage") Then
                dgvReport.Columns("OnTimePercentage").DefaultCellStyle.Format = "P0"
                dgvReport.Columns("OnTimePercentage").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            End If
            
            ' Color code performance
            For Each row As DataGridViewRow In dgvReport.Rows
                If row.Cells("OnTimePercentage").Value IsNot Nothing Then
                    Dim onTimePercent = Convert.ToDecimal(row.Cells("OnTimePercentage").Value)
                    If onTimePercent >= 0.95D Then
                        row.Cells("OnTimePercentage").Style.BackColor = Color.FromArgb(200, 230, 201)
                    ElseIf onTimePercent >= 0.80D Then
                        row.Cells("OnTimePercentage").Style.BackColor = Color.FromArgb(255, 249, 196)
                    Else
                        row.Cells("OnTimePercentage").Style.BackColor = Color.FromArgb(255, 205, 210)
                    End If
                End If
            Next
            
            If dt.Rows.Count > 0 Then
                Dim totalPurchases = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalPurchases")), 0D, r.Field(Of Decimal)("TotalPurchases")))
                Dim totalOrders = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalOrders")), 0, r.Field(Of Integer)("TotalOrders")))
                Dim avgOnTime = dt.AsEnumerable().Average(Function(r) If(IsDBNull(r("OnTimePercentage")), 0D, r.Field(Of Decimal)("OnTimePercentage")))
                
                MessageBox.Show($"Summary:{vbCrLf}Total Suppliers: {dt.Rows.Count}{vbCrLf}Total Orders: {totalOrders:N0}{vbCrLf}Total Purchases: {totalPurchases:C2}{vbCrLf}Average On-Time: {avgOnTime:P0}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
