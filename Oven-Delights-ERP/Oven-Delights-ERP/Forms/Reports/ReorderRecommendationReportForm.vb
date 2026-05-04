Imports System.Data.SqlClient
Imports System.Data

Public Class ReorderRecommendationReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Reorder Recommendation Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
        
        ' Hide date filters
        dtpStartDate.Visible = False
        dtpEndDate.Visible = False
        pnlFilters.Controls.Cast(Of Control)().Where(Function(c) TypeOf c Is Label AndAlso (CType(c, Label).Text.Contains("Date"))).ToList().ForEach(Sub(l) l.Hide())
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_ReorderRecommendation", conn)
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
            FormatNumberColumn("ReorderLevel")
            FormatNumberColumn("MaxStock")
            FormatNumberColumn("RecommendedOrderQty")
            FormatCurrencyColumn("UnitCost")
            FormatCurrencyColumn("EstimatedCost")
            
            ' Color code by priority
            For Each row As DataGridViewRow In dgvReport.Rows
                If row.Cells("Priority").Value IsNot Nothing Then
                    Dim priority = row.Cells("Priority").Value.ToString()
                    Select Case priority
                        Case "URGENT - OUT OF STOCK"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(255, 205, 210)
                            row.DefaultCellStyle.Font = New Font(dgvReport.Font, FontStyle.Bold)
                        Case "HIGH PRIORITY"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(255, 224, 178)
                        Case "NORMAL"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(255, 249, 196)
                    End Select
                End If
            Next
            
            If dt.Rows.Count > 0 Then
                Dim totalCost = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("EstimatedCost")), 0D, r.Field(Of Decimal)("EstimatedCost")))
                Dim urgentCount = dt.AsEnumerable().Count(Function(r) Not IsDBNull(r("Priority")) AndAlso r.Field(Of String)("Priority") = "URGENT - OUT OF STOCK")
                
                MessageBox.Show($"Reorder Summary:{vbCrLf}Items to Reorder: {dt.Rows.Count:N0}{vbCrLf}Urgent Items: {urgentCount:N0}{vbCrLf}Estimated Cost: {totalCost:C2}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Else
                MessageBox.Show("All stock levels are adequate!", "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
