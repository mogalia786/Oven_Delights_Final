Imports System.Data.SqlClient
Imports System.Data

Public Class InventoryValuationReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Inventory Valuation Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
        
        ' Hide date filters (uses current date)
        dtpStartDate.Visible = False
        dtpEndDate.Visible = False
        pnlFilters.Controls.Cast(Of Control)().Where(Function(c) TypeOf c Is Label AndAlso (CType(c, Label).Text.Contains("Date"))).ToList().ForEach(Sub(l) l.Hide())
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_InventoryValuation", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@BranchID", GetSelectedBranchID())

                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            dgvReport.DataSource = dt
            
            ' Format columns
            FormatNumberColumn("CurrentStock")
            FormatCurrencyColumn("UnitCost")
            FormatCurrencyColumn("TotalValue")
            FormatCurrencyColumn("RetailValue")
            FormatCurrencyColumn("PotentialProfit")
            
            ' Add chart-style visualization for high-value items
            If dgvReport.Columns.Contains("TotalValue") Then
                Dim maxValue = dt.AsEnumerable().Max(Function(r) If(IsDBNull(r("TotalValue")), 0D, r.Field(Of Decimal)("TotalValue")))
                
                For Each row As DataGridViewRow In dgvReport.Rows
                    If row.Cells("TotalValue").Value IsNot Nothing Then
                        Dim value = Convert.ToDecimal(row.Cells("TotalValue").Value)
                        Dim percentage = If(maxValue > 0, value / maxValue, 0)
                        
                        If percentage > 0.7 Then
                            row.DefaultCellStyle.BackColor = Color.FromArgb(255, 243, 224)
                        End If
                    End If
                Next
            End If
            
            If dt.Rows.Count > 0 Then
                Dim totalValue = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalValue")), 0D, r.Field(Of Decimal)("TotalValue")))
                Dim retailValue = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("RetailValue")), 0D, r.Field(Of Decimal)("RetailValue")))
                Dim potentialProfit = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("PotentialProfit")), 0D, r.Field(Of Decimal)("PotentialProfit")))
                
                MessageBox.Show($"Inventory Summary:{vbCrLf}{vbCrLf}Total Items: {dt.Rows.Count:N0}{vbCrLf}Cost Value: {totalValue:C2}{vbCrLf}Retail Value: {retailValue:C2}{vbCrLf}Potential Profit: {potentialProfit:C2}", 
                    "Valuation Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
