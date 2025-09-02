Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.IO
Imports System.Text

Partial Class AuditLogViewer
    Inherits Form

    Private connectionString As String

    Public Sub New()
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        LoadAuditLogs()
        SetupDateFilters()
    End Sub

    Private Sub SetupDateFilters()
        dtpFromDate.Value = DateTime.Now.AddDays(-30)
        dtpToDate.Value = DateTime.Now
        
        cboAction.Items.Clear()
        cboAction.Items.Add("All Actions")
        cboAction.Items.Add("UserCreated")
        cboAction.Items.Add("UserUpdated")
        cboAction.Items.Add("UserDeleted")
        cboAction.Items.Add("BranchCreated")
        cboAction.Items.Add("BranchUpdated")
        cboAction.Items.Add("BranchDeactivated")
        cboAction.Items.Add("Login")
        cboAction.Items.Add("Logout")
        cboAction.SelectedIndex = 0
    End Sub

    Private Sub LoadAuditLogs()
        dgvAuditLog.DataSource = GetAuditLogs()
        dgvAuditLog.AutoResizeColumns()
        
        ' Format timestamp column
        If dgvAuditLog.Columns.Contains("Timestamp") Then
            dgvAuditLog.Columns("Timestamp").DefaultCellStyle.Format = "yyyy-MM-dd HH:mm:ss"
        End If
    End Sub

    Private Function GetAuditLogs() As DataTable
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim sql As String = "SELECT a.AuditID, u.Username, a.Action, a.TableName, a.RecordID, a.Details, a.Timestamp, a.IPAddress " &
                                   "FROM AuditLog a LEFT JOIN Users u ON a.UserID = u.UserID " &
                                   "WHERE a.Timestamp >= @fromDate AND a.Timestamp <= @toDate"
                
                If cboAction.SelectedIndex > 0 Then
                    sql &= " AND a.Action = @action"
                End If
                
                If Not String.IsNullOrWhiteSpace(txtUserFilter.Text) Then
                    sql &= " AND u.Username LIKE @username"
                End If
                
                sql &= " ORDER BY a.Timestamp DESC"
                
                Dim cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@fromDate", dtpFromDate.Value.Date)
                cmd.Parameters.AddWithValue("@toDate", dtpToDate.Value.Date.AddDays(1).AddSeconds(-1))
                
                If cboAction.SelectedIndex > 0 Then
                    cmd.Parameters.AddWithValue("@action", cboAction.SelectedItem.ToString())
                End If
                
                If Not String.IsNullOrWhiteSpace(txtUserFilter.Text) Then
                    cmd.Parameters.AddWithValue("@username", "%" & txtUserFilter.Text.Trim() & "%")
                End If
                
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)
            Catch ex As Exception
                MessageBox.Show("Error loading audit logs: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
        Return dt
    End Function

    Private Sub btnFilter_Click(sender As Object, e As EventArgs) Handles btnFilter.Click
        LoadAuditLogs()
    End Sub

    Private Sub btnExportCSV_Click(sender As Object, e As EventArgs) Handles btnExportCSV.Click
        ExportToCSV()
    End Sub

    Private Sub btnExportPDF_Click(sender As Object, e As EventArgs) Handles btnExportPDF.Click
        ExportToPDF()
    End Sub

    Private Sub ExportToCSV()
        Try
            Dim saveDialog As New SaveFileDialog()
            saveDialog.Filter = "CSV files (*.csv)|*.csv"
            saveDialog.FileName = $"AuditLog_{DateTime.Now:yyyyMMdd_HHmmss}.csv"
            
            If saveDialog.ShowDialog() = DialogResult.OK Then
                Dim csv As New StringBuilder()
                
                ' Add headers
                Dim headers As New List(Of String)()
                For Each column As DataGridViewColumn In dgvAuditLog.Columns
                    headers.Add(column.HeaderText)
                Next
                csv.AppendLine(String.Join(",", headers))
                
                ' Add data rows
                For Each row As DataGridViewRow In dgvAuditLog.Rows
                    If Not row.IsNewRow Then
                        Dim values As New List(Of String)()
                        For Each cell As DataGridViewCell In row.Cells
                            Dim value As String = If(cell.Value?.ToString(), "")
                            ' Escape commas and quotes
                            If value.Contains(",") OrElse value.Contains("""") Then
                                value = """" & value.Replace("""", """""") & """"
                            End If
                            values.Add(value)
                        Next
                        csv.AppendLine(String.Join(",", values))
                    End If
                Next
                
                File.WriteAllText(saveDialog.FileName, csv.ToString())
                MessageBox.Show("Audit log exported successfully!", "Export Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show("Error exporting to CSV: " & ex.Message, "Export Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ExportToPDF()
        MessageBox.Show("PDF export functionality requires Crystal Reports or similar PDF library integration.", "Feature Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadAuditLogs()
    End Sub

    Private Sub dgvAuditLog_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvAuditLog.CellDoubleClick
        If e.RowIndex >= 0 Then
            Dim details As String = dgvAuditLog.Rows(e.RowIndex).Cells("Details").Value?.ToString()
            If Not String.IsNullOrEmpty(details) Then
                MessageBox.Show(details, "Audit Log Details", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        End If
    End Sub
End Class
