Imports System.Data.SqlClient
Imports System.Data

Public Class StockMovementReportForm
    Inherits BaseReportForm

    Private cmbMovementType As ComboBox

    Public Sub New()
        MyBase.New()
        reportTitle = "Stock Movement Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
        
        ' Add movement type filter
        Dim lblMovementType As New Label() With {
            .Text = "Movement Type:",
            .Location = New Point(540, 15),
            .AutoSize = True
        }
        cmbMovementType = New ComboBox() With {
            .Location = New Point(540, 35),
            .Width = 150,
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        cmbMovementType.Items.AddRange({"All Movements", "Receipts", "Issues", "Transfers", "Adjustments", "Sales"})
        cmbMovementType.SelectedIndex = 0
        
        pnlFilters.Controls.AddRange({lblMovementType, cmbMovementType})
        
        ' Reposition buttons
        btnGenerate.Location = New Point(700, 30)
        btnExport.Location = New Point(830, 30)
        btnPrint.Location = New Point(960, 30)
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_Report_StockMovement", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@StartDate", dtpStartDate.Value.Date)
                    cmd.Parameters.AddWithValue("@EndDate", dtpEndDate.Value.Date)
                    cmd.Parameters.AddWithValue("@BranchID", GetSelectedBranchID())
                    cmd.Parameters.AddWithValue("@MovementType", If(cmbMovementType.SelectedIndex = 0, DBNull.Value, cmbMovementType.SelectedItem))

                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            dgvReport.DataSource = dt
            
            ' Format columns
            FormatNumberColumn("Quantity")
            FormatCurrencyColumn("UnitCost")
            FormatCurrencyColumn("TotalValue")
            
            ' Color code movement types
            For Each row As DataGridViewRow In dgvReport.Rows
                If row.Cells("MovementType").Value IsNot Nothing Then
                    Dim movementType = row.Cells("MovementType").Value.ToString()
                    Select Case movementType.ToUpper()
                        Case "RECEIPT", "RECEIPTS"
                            row.Cells("MovementType").Style.BackColor = Color.FromArgb(200, 230, 201)
                        Case "ISSUE", "ISSUES"
                            row.Cells("MovementType").Style.BackColor = Color.FromArgb(255, 224, 178)
                        Case "TRANSFER", "TRANSFERS"
                            row.Cells("MovementType").Style.BackColor = Color.FromArgb(187, 222, 251)
                        Case "ADJUSTMENT", "ADJUSTMENTS"
                            row.Cells("MovementType").Style.BackColor = Color.FromArgb(248, 187, 208)
                        Case "SALE", "SALES"
                            row.Cells("MovementType").Style.BackColor = Color.FromArgb(225, 190, 231)
                    End Select
                End If
            Next
            
            If dt.Rows.Count > 0 Then
                Dim totalValue = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalValue")), 0D, Math.Abs(r.Field(Of Decimal)("TotalValue"))))
                
                MessageBox.Show($"Summary:{vbCrLf}Total Movements: {dt.Rows.Count:N0}{vbCrLf}Total Value: {totalValue:C2}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
