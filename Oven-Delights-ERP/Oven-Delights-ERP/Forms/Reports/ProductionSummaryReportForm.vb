Imports System.Data.SqlClient
Imports System.Data

Public Class ProductionSummaryReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Manufacturing Production Summary"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_ProductionSummary", conn)
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
            FormatNumberColumn("QuantityProduced")
            FormatCurrencyColumn("MaterialCost")
            FormatCurrencyColumn("LaborCost")
            FormatCurrencyColumn("TotalCost")
            FormatCurrencyColumn("CostPerUnit")
            
            If dt.Rows.Count > 0 Then
                Dim totalQty = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("QuantityProduced")), 0, r.Field(Of Integer)("QuantityProduced")))
                Dim totalCost = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalCost")), 0D, r.Field(Of Decimal)("TotalCost")))
                
                MessageBox.Show($"Summary:{vbCrLf}Total Units Produced: {totalQty:N0}{vbCrLf}Total Production Cost: {totalCost:C2}{vbCrLf}Average Cost Per Unit: {If(totalQty > 0, (totalCost / totalQty), 0):C2}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
