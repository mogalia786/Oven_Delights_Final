Imports System.Data.SqlClient
Imports System.Data

Public Class ProfitLossReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Profit & Loss Statement"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_ProfitLoss", conn)
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
            FormatCurrencyColumn("Amount")
            
            ' Apply hierarchical formatting
            For Each row As DataGridViewRow In dgvReport.Rows
                If row.Cells("AccountCategory").Value IsNot Nothing Then
                    Dim category = row.Cells("AccountCategory").Value.ToString()
                    
                    ' Bold headers
                    If category.Contains("Total") OrElse category.Contains("Revenue") OrElse 
                       category.Contains("Expenses") OrElse category.Contains("Net") Then
                        row.DefaultCellStyle.Font = New Font(dgvReport.Font, FontStyle.Bold)
                        row.DefaultCellStyle.BackColor = Color.FromArgb(240, 240, 240)
                    End If
                    
                    ' Highlight net profit/loss
                    If category.Contains("Net Profit") OrElse category.Contains("Net Loss") Then
                        If row.Cells("Amount").Value IsNot Nothing Then
                            Dim amount = Convert.ToDecimal(row.Cells("Amount").Value)
                            If amount >= 0 Then
                                row.DefaultCellStyle.BackColor = Color.FromArgb(200, 230, 201)
                                row.DefaultCellStyle.ForeColor = Color.FromArgb(27, 94, 32)
                            Else
                                row.DefaultCellStyle.BackColor = Color.FromArgb(255, 205, 210)
                                row.DefaultCellStyle.ForeColor = Color.FromArgb(183, 28, 28)
                            End If
                        End If
                    End If
                End If
            Next
            
            If dt.Rows.Count > 0 Then
                ' Find net profit row
                Dim netProfitRow = dt.AsEnumerable().FirstOrDefault(Function(r) Not IsDBNull(r("AccountCategory")) AndAlso (r.Field(Of String)("AccountCategory").Contains("Net Profit") OrElse r.Field(Of String)("AccountCategory").Contains("Net Loss")))
                
                If netProfitRow IsNot Nothing Then
                    Dim netProfit = If(IsDBNull(netProfitRow("Amount")), 0D, netProfitRow.Field(Of Decimal)("Amount"))
                    Dim status = If(netProfit >= 0, "Profit", "Loss")
                    MessageBox.Show($"Period: {dtpStartDate.Value:dd/MM/yyyy} - {dtpEndDate.Value:dd/MM/yyyy}{vbCrLf}{vbCrLf}Net {status}: {Math.Abs(netProfit):C2}", 
                        "P&L Summary", MessageBoxButtons.OK, If(netProfit >= 0, MessageBoxIcon.Information, MessageBoxIcon.Warning))
                End If
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
