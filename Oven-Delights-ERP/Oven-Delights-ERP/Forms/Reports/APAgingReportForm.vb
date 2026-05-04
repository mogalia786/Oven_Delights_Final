Imports System.Data.SqlClient
Imports System.Data

Public Class APAgingReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Accounts Payable Aging Report"
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
                Using cmd As New SqlCommand("sp_Report_APAging", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@AsOfDate", DateTime.Now.Date)
                    cmd.Parameters.AddWithValue("@BranchID", GetSelectedBranchID())

                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            dgvReport.DataSource = dt
            
            ' Format columns
            FormatCurrencyColumn("TotalOutstanding")
            FormatCurrencyColumn("Current")
            FormatCurrencyColumn("Days1_30")
            FormatCurrencyColumn("Days31_60")
            FormatCurrencyColumn("Days61_90")
            FormatCurrencyColumn("Days90Plus")
            
            ' Highlight overdue amounts
            For Each row As DataGridViewRow In dgvReport.Rows
                If row.Cells("Days90Plus").Value IsNot Nothing Then
                    Dim overdue = Convert.ToDecimal(row.Cells("Days90Plus").Value)
                    If overdue > 0 Then
                        row.Cells("Days90Plus").Style.BackColor = Color.FromArgb(255, 205, 210)
                        row.Cells("Days90Plus").Style.ForeColor = Color.FromArgb(183, 28, 28)
                        row.Cells("Days90Plus").Style.Font = New Font(dgvReport.Font, FontStyle.Bold)
                    End If
                End If
            Next
            
            If dt.Rows.Count > 0 Then
                Dim totalOutstanding = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalOutstanding")), 0D, r.Field(Of Decimal)("TotalOutstanding")))
                Dim overdue90 = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("Days90Plus")), 0D, r.Field(Of Decimal)("Days90Plus")))
                
                MessageBox.Show($"Summary:{vbCrLf}Total Suppliers: {dt.Rows.Count}{vbCrLf}Total Outstanding: {totalOutstanding:C2}{vbCrLf}90+ Days Overdue: {overdue90:C2}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
