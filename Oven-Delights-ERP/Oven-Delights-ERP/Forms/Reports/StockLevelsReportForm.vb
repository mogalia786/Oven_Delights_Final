Imports System.Data.SqlClient
Imports System.Data

Public Class StockLevelsReportForm
    Inherits BaseReportForm

    Private chkLowStock As CheckBox

    Public Sub New()
        MyBase.New()
        reportTitle = "Stock Levels Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
        
        ' Add low stock filter
        chkLowStock = New CheckBox() With {
            .Text = "Show Low Stock Only",
            .Location = New Point(930, 35),
            .AutoSize = True,
            .Checked = False
        }
        pnlFilters.Controls.Add(chkLowStock)
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_StockLevels", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@BranchID", GetSelectedBranchID())
                    cmd.Parameters.AddWithValue("@LowStockOnly", chkLowStock.Checked)

                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            dgvReport.DataSource = dt
            
            ' Format columns
            FormatNumberColumn("CurrentStock")
            FormatNumberColumn("ReorderLevel")
            FormatNumberColumn("MaxStock")
            FormatCurrencyColumn("UnitCost")
            FormatCurrencyColumn("TotalValue")
            
            ' Highlight low stock rows
            For Each row As DataGridViewRow In dgvReport.Rows
                If row.Cells("CurrentStock").Value IsNot Nothing AndAlso 
                   row.Cells("ReorderLevel").Value IsNot Nothing Then
                    Dim current = Convert.ToDecimal(row.Cells("CurrentStock").Value)
                    Dim reorder = Convert.ToDecimal(row.Cells("ReorderLevel").Value)
                    If current <= reorder Then
                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 235, 238)
                        row.DefaultCellStyle.ForeColor = Color.FromArgb(183, 28, 28)
                    End If
                End If
            Next
            
            If dt.Rows.Count > 0 Then
                Dim totalValue = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalValue")), 0D, r.Field(Of Decimal)("TotalValue")))
                Dim lowStockItems = dt.AsEnumerable().Count(Function(r) Not IsDBNull(r("CurrentStock")) AndAlso Not IsDBNull(r("ReorderLevel")) AndAlso Convert.ToDecimal(r("CurrentStock")) <= Convert.ToDecimal(r("ReorderLevel")))
                
                MessageBox.Show($"Summary:{vbCrLf}Total Items: {dt.Rows.Count:N0}{vbCrLf}Low Stock Items: {lowStockItems:N0}{vbCrLf}Total Inventory Value: {totalValue:C2}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
