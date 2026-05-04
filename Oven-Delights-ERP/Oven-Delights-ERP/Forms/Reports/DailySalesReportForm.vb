Imports System.Data.SqlClient
Imports System.Data

Public Class DailySalesReportForm
    Inherits BaseReportForm

    Public Sub New()
        MyBase.New()
        reportTitle = "Daily Sales Report"
        lblTitle.Text = reportTitle
        Me.Text = reportTitle
    End Sub

    Protected Overrides Sub BtnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                Dim sql = "SELECT 
                            SaleDate,
                            b.BranchName,
                            COUNT(*) AS TransactionCount,
                            SUM(TotalAmount) AS TotalSales,
                            SUM(ItemCount) AS TotalItems,
                            COUNT(DISTINCT PaymentMethod) AS PaymentMethodCount
                          FROM DailySales ds
                          INNER JOIN Branches b ON b.BranchID = ds.BranchID
                          WHERE SaleDate BETWEEN @StartDate AND @EndDate"
                
                Dim branchID = GetSelectedBranchID()
                If branchID > 0 Then
                    sql &= " AND ds.BranchID = @BranchID"
                End If
                
                sql &= " GROUP BY SaleDate, b.BranchName ORDER BY SaleDate DESC, b.BranchName"
                
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
            
            ' Show summary
            If dt.Rows.Count > 0 Then
                Dim totalSales = dt.AsEnumerable().Sum(Function(r) r.Field(Of Decimal)("TotalSales"))
                Dim totalTrans = dt.AsEnumerable().Sum(Function(r) r.Field(Of Integer)("TransactionCount"))
                Dim totalItems = dt.AsEnumerable().Sum(Function(r) r.Field(Of Integer)("TotalItems"))
                
                MessageBox.Show($"Summary:{vbCrLf}Total Sales: {totalSales:C2}{vbCrLf}Transactions: {totalTrans:N0}{vbCrLf}Items Sold: {totalItems:N0}", 
                    "Report Summary", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
