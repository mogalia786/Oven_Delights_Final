Imports System.Data.SqlClient
Imports System.Data

Public Class SlowMovingStockReportForm
    Inherits BaseReportForm

    Private nudDays As NumericUpDown

    Public Sub New()
        MyBase.New()
        reportTitle = "Slow Moving Stock Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
        
        ' Hide date filters
        dtpStartDate.Visible = False
        dtpEndDate.Visible = False
        pnlFilters.Controls.Cast(Of Control)().Where(Function(c) TypeOf c Is Label AndAlso (CType(c, Label).Text.Contains("Date"))).ToList().ForEach(Sub(l) l.Hide())
        
        ' Add days filter
        Dim lblDays As New Label() With {
            .Text = "Days Since Last Sale:",
            .Location = New Point(10, 15),
            .AutoSize = True
        }
        nudDays = New NumericUpDown() With {
            .Location = New Point(10, 35),
            .Width = 100,
            .Minimum = 7,
            .Maximum = 365,
            .Value = 30,
            .Increment = 7
        }
        
        pnlFilters.Controls.AddRange({lblDays, nudDays})
        
        ' Reposition branch filter
        cmbBranch.Location = New Point(120, 35)
        pnlFilters.Controls.Cast(Of Control)().FirstOrDefault(Function(c) TypeOf c Is Label AndAlso CType(c, Label).Text = "Branch:")?.SetBounds(120, 15, 0, 0, BoundsSpecified.X Or BoundsSpecified.Y)
        
        ' Reposition buttons
        btnGenerate.Location = New Point(330, 30)
        btnExport.Location = New Point(460, 30)
        btnPrint.Location = New Point(590, 30)
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_SlowMovingStock", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@DaysSinceLastSale", CInt(nudDays.Value))
                    cmd.Parameters.AddWithValue("@BranchID", GetSelectedBranchID())

                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            dgvReport.DataSource = dt
            
            ' Format columns
            FormatNumberColumn("CurrentStock")
            FormatCurrencyColumn("TiedUpCapital")
            FormatNumberColumn("DaysSinceLastSale")
            
            ' Color code by severity
            For Each row As DataGridViewRow In dgvReport.Rows
                If row.Cells("DaysSinceLastSale").Value IsNot Nothing Then
                    Dim days = Convert.ToInt32(row.Cells("DaysSinceLastSale").Value)
                    If days > 90 Then
                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 205, 210)
                    ElseIf days > 60 Then
                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 224, 178)
                    ElseIf days > 30 Then
                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 249, 196)
                    End If
                End If
            Next
            
            If dt.Rows.Count > 0 Then
                Dim totalCapital = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TiedUpCapital")), 0D, r.Field(Of Decimal)("TiedUpCapital")))
                Dim avgDays = dt.AsEnumerable().Average(Function(r) If(IsDBNull(r("DaysSinceLastSale")), 0, r.Field(Of Integer)("DaysSinceLastSale")))
                
                MessageBox.Show($"Slow Moving Items:{vbCrLf}Total Items: {dt.Rows.Count:N0}{vbCrLf}Capital Tied Up: {totalCapital:C2}{vbCrLf}Average Days: {avgDays:F0}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Else
                MessageBox.Show("No slow-moving stock found!", "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
