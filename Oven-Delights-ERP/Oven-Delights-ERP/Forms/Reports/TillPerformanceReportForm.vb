Imports System.Data.SqlClient
Imports System.Data

Public Class TillPerformanceReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Till Performance Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                Dim sql = "SELECT 
                            ds.TillNumber,
                            b.BranchName,
                            ds.SaleDate,
                            COUNT(*) AS TransactionCount,
                            SUM(ds.TotalAmount) AS TotalSales,
                            AVG(ds.TotalAmount) AS AvgTransaction,
                            SUM(ds.ItemCount) AS TotalItems,
                            MIN(ds.CreatedDate) AS FirstSale,
                            MAX(ds.CreatedDate) AS LastSale
                          FROM DailySales ds
                          INNER JOIN Branches b ON b.BranchID = ds.BranchID
                          WHERE ds.SaleDate BETWEEN @StartDate AND @EndDate"
                
                Dim branchID = GetSelectedBranchID()
                If branchID > 0 Then
                    sql &= " AND ds.BranchID = @BranchID"
                End If
                
                sql &= " GROUP BY ds.TillNumber, b.BranchName, ds.SaleDate 
                         ORDER BY ds.SaleDate DESC, TotalSales DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@StartDate", dtpStartDate.Value.Date)
                    cmd.Parameters.AddWithValue("@EndDate", dtpEndDate.Value.Date)
                    If branchID > 0 Then
                        cmd.Parameters.AddWithValue("@BranchID", branchID)
                    End If

                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
            End Using

            dgvReport.DataSource = dt
            
            ' Format columns
            If dgvReport.Columns.Contains("TotalSales") Then
                dgvReport.Columns("TotalSales").DefaultCellStyle.Format = "C2"
            End If
            If dgvReport.Columns.Contains("AvgTransaction") Then
                dgvReport.Columns("AvgTransaction").DefaultCellStyle.Format = "C2"
            End If
            
            ' Show summary
            If dt.Rows.Count > 0 Then
                Dim totalSales = dt.AsEnumerable().Sum(Function(r) r.Field(Of Decimal)("TotalSales"))
                Dim totalTrans = dt.AsEnumerable().Sum(Function(r) r.Field(Of Integer)("TransactionCount"))
                Dim avgTrans = If(totalTrans > 0, totalSales / totalTrans, 0)
                
                MessageBox.Show($"Summary:{vbCrLf}Total Sales: {totalSales:C2}{vbCrLf}Transactions: {totalTrans:N0}{vbCrLf}Avg Transaction: {avgTrans:C2}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
