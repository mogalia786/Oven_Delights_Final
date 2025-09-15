Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class CrossBranchLookupForm
    Private ReadOnly _connString As String

    Public Sub New()
        InitializeComponent()
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
                ' Search across branches using a consolidated view if available
                Dim sql As String = "SELECT BranchID, BranchName, SKU, Name, QtyOnHand, ReorderPoint FROM dbo.v_Retail_StockOnHand WHERE (SKU = @q OR Name LIKE @like) ORDER BY Name, BranchName"
                Using da As New SqlDataAdapter(sql, cn)
                    da.SelectCommand.Parameters.AddWithValue("@q", q)
                    da.SelectCommand.Parameters.AddWithValue("@like", "%" & q & "%")
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgv.DataSource = dt
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
