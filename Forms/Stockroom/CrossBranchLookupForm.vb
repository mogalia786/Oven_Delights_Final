Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class CrossBranchLookupForm
    Private ReadOnly _connString As String
    Private ReadOnly stockroomService As New StockroomService()
    Private currentBranchId As Integer
    Private isSuperAdmin As Boolean

    Public Sub New()
        InitializeComponent()
        
        ' Initialize branch and role info
        currentBranchId = stockroomService.GetCurrentUserBranchId()
        isSuperAdmin = stockroomService.IsCurrentUserSuperAdmin()
        
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrWhiteSpace(_connString) Then
            MessageBox.Show("Missing connection string 'OvenDelightsERPConnectionString' in App.config.", "Config Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
        AddHandler btnSearch.Click, AddressOf OnSearch
        AddHandler Me.Shown, Sub() txtProduct.Focus()
        ' Enter-to-search for quicker UX
        AddHandler txtProduct.KeyDown, Sub(sender, e)
                                           If e IsNot Nothing AndAlso e.KeyCode = Keys.Enter Then
                                               e.SuppressKeyPress = True
                                               OnSearch(sender, EventArgs.Empty)
                                           End If
                                       End Sub
        ' Wire export button if present (resolve dynamically to avoid designer dependency)
        Dim exportBtn As Button = TryCast(Me.Controls("btnExport"), Button)
        If exportBtn IsNot Nothing Then AddHandler exportBtn.Click, AddressOf OnExport
    End Sub

    Private Sub OnSearch(sender As Object, e As EventArgs)
        Dim q As String = txtProduct.Text.Trim()
        If String.IsNullOrWhiteSpace(q) Then
            MessageBox.Show("Enter a product name or SKU to search across branches.")
            Return
        End If
        Try
            Using cn As New SqlConnection(_connString)
                cn.Open()
                ' Search across branches with proper branch filtering
                Dim sql As String
                If isSuperAdmin Then
                    sql = "SELECT rs.BranchID, b.BranchName, p.ProductCode AS SKU, p.ProductName AS Name, 
                           ISNULL(rs.QuantityInStock, 0) AS QtyOnHand, ISNULL(rs.ReorderLevel, 0) AS ReorderPoint 
                           FROM Products p 
                           LEFT JOIN Retail_Stock rs ON p.ProductID = rs.ProductID 
                           LEFT JOIN Branches b ON rs.BranchID = b.BranchID 
                           WHERE (p.ProductCode LIKE @like OR p.ProductName LIKE @like) 
                           AND p.IsActive = 1 
                           ORDER BY p.ProductName, b.BranchName"
                Else
                    sql = "SELECT rs.BranchID, b.BranchName, p.ProductCode AS SKU, p.ProductName AS Name, 
                           ISNULL(rs.QuantityInStock, 0) AS QtyOnHand, ISNULL(rs.ReorderLevel, 0) AS ReorderPoint 
                           FROM Products p 
                           LEFT JOIN Retail_Stock rs ON p.ProductID = rs.ProductID AND rs.BranchID = @branchId
                           LEFT JOIN Branches b ON rs.BranchID = b.BranchID 
                           WHERE (p.ProductCode LIKE @like OR p.ProductName LIKE @like) 
                           AND p.IsActive = 1 
                           ORDER BY p.ProductName"
                End If
                
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@like", "%" & q & "%")
                    If Not isSuperAdmin Then
                        cmd.Parameters.AddWithValue("@branchId", currentBranchId)
                    End If
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgv.DataSource = dt
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Lookup failed: " & ex.Message, "Cross-Branch Lookup", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnExport(sender As Object, e As EventArgs)
        Try
            If dgv Is Nothing OrElse dgv.Rows.Count = 0 Then
                MessageBox.Show("Nothing to export.")
                Return
            End If
            Dim sfd As New SaveFileDialog() With {
                .Title = "Export Cross-Branch Stock",
                .Filter = "CSV Files (*.csv)|*.csv",
                .FileName = $"CrossBranch_{DateTime.Now:yyyyMMdd_HHmmss}.csv"
            }
            If sfd.ShowDialog(Me) <> DialogResult.OK Then Return
            Using sw As New IO.StreamWriter(sfd.FileName, False, System.Text.Encoding.UTF8)
                ' headers
                Dim headers = dgv.Columns.Cast(Of DataGridViewColumn)().Select(Function(c) SafeCsv(c.HeaderText))
                sw.WriteLine(String.Join(",", headers))
                ' rows
                For Each row As DataGridViewRow In dgv.Rows
                    If row.IsNewRow Then Continue For
                    Dim vals = row.Cells.Cast(Of DataGridViewCell)().Select(Function(c) SafeCsv(If(c.Value, "").ToString()))
                    sw.WriteLine(String.Join(",", vals))
                Next
            End Using
            Try
                Process.Start(New ProcessStartInfo() With { .FileName = sfd.FileName, .UseShellExecute = True })
            Catch
            End Try
        Catch ex As Exception
            MessageBox.Show("Export failed: " & ex.Message, "Cross-Branch Lookup", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function SafeCsv(v As String) As String
        If v Is Nothing Then Return ""
        Dim needsQuote = v.Contains(",") OrElse v.Contains("\"") OrElse v.Contains(vbCr) OrElse v.Contains(vbLf)
        v = v.Replace("\"", "\"\"")
        Return If(needsQuote, "\"" & v & "\"", v)
    End Function
End Class
