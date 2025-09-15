Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.IO
Imports System.Text

Partial Class AuditLogViewer
    Inherits Form

    Private connectionString As String
    Private ReadOnly _cboUser As New ComboBox()

    Public Sub New()
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        EnsureAuditLogTable()
        SetupDateFilters()
        SetupUserDropdown()
        LoadAuditLogs()
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

    Private Sub SetupUserDropdown()
        Try
            ' Place dropdown near existing controls if not on designer
            If _cboUser.Parent Is Nothing Then
                _cboUser.DropDownStyle = ComboBoxStyle.DropDownList
                _cboUser.Width = 220
                _cboUser.Name = "_cboUser"
                ' Try to align top row
                _cboUser.Left = If(cboAction IsNot Nothing, cboAction.Right + 12, 12)
                _cboUser.Top = If(cboAction IsNot Nothing, cboAction.Top, 8)
                Me.Controls.Add(_cboUser)
            End If
            LoadUsersIntoDropdown()
            AddHandler _cboUser.SelectedIndexChanged, Sub() LoadAuditLogs()
        Catch
        End Try
    End Sub

    Private Sub LoadUsersIntoDropdown()
        Dim isSuper As Boolean = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        Dim branchId As Integer = 0
        Try
            branchId = If(AppSession.CurrentUser IsNot Nothing AndAlso AppSession.CurrentUser.BranchID.HasValue, AppSession.CurrentUser.BranchID.Value, 0)
        Catch
            branchId = 0
        End Try
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connectionString)
            conn.Open()
            Dim sql As String = "SELECT u.UserID, u.Username, u.BranchID FROM dbo.Users u"
            If Not isSuper AndAlso branchId > 0 Then
                sql &= " WHERE u.BranchID = @b"
            End If
            sql &= " ORDER BY u.Username"
            Using da As New SqlDataAdapter(sql, conn)
                If Not isSuper AndAlso branchId > 0 Then da.SelectCommand.Parameters.AddWithValue("@b", branchId)
                da.Fill(dt)
            End Using
        End Using
        Dim list As New List(Of KeyValuePair(Of Integer, String))()
        list.Add(New KeyValuePair(Of Integer, String)(0, If(String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase), "All Users (All Branches)", "All Users (My Branch)")))
        For Each r As DataRow In dt.Rows
            Dim id As Integer = Convert.ToInt32(r("UserID"))
            Dim name As String = Convert.ToString(r("Username"))
            list.Add(New KeyValuePair(Of Integer, String)(id, name))
        Next
        _cboUser.DataSource = list
        _cboUser.ValueMember = "Key"
        _cboUser.DisplayMember = "Value"
        _cboUser.SelectedIndex = 0
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
                                   "FROM dbo.AuditLog a LEFT JOIN dbo.Users u ON a.UserID = u.UserID " &
                                   "WHERE a.Timestamp >= @fromDate AND a.Timestamp <= @toDate"
                
                If cboAction.SelectedIndex > 0 Then
                    sql &= " AND a.Action = @action"
                End If
                ' Filter by selected user if chosen
                Dim selectedUserId As Integer = 0
                Try
                    If _cboUser IsNot Nothing AndAlso _cboUser.SelectedValue IsNot Nothing AndAlso Not TypeOf _cboUser.SelectedValue Is DBNull Then
                        selectedUserId = Convert.ToInt32(_cboUser.SelectedValue)
                    End If
                Catch
                    selectedUserId = 0
                End Try
                If selectedUserId > 0 Then
                    sql &= " AND a.UserID = @uid"
                End If
                
                sql &= " ORDER BY a.Timestamp DESC"
                
                Dim cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@fromDate", dtpFromDate.Value.Date)
                cmd.Parameters.AddWithValue("@toDate", dtpToDate.Value.Date.AddDays(1).AddSeconds(-1))
                
                If cboAction.SelectedIndex > 0 Then
                    cmd.Parameters.AddWithValue("@action", cboAction.SelectedItem.ToString())
                End If
                If selectedUserId > 0 Then
                    cmd.Parameters.AddWithValue("@uid", selectedUserId)
                End If
                
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)
            Catch ex As Exception
                MessageBox.Show("Error loading audit logs: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
        Return dt
    End Function

    Private Sub EnsureAuditLogTable()
        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                Dim sql As String = "IF OBJECT_ID('dbo.AuditLog','U') IS NULL BEGIN " & _
                                    "CREATE TABLE dbo.AuditLog (" & _
                                    " AuditID INT IDENTITY(1,1) PRIMARY KEY, " & _
                                    " UserID INT NULL, " & _
                                    " Action NVARCHAR(100) NOT NULL, " & _
                                    " TableName NVARCHAR(128) NULL, " & _
                                    " RecordID NVARCHAR(100) NULL, " & _
                                    " Details NVARCHAR(MAX) NULL, " & _
                                    " Timestamp DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(), " & _
                                    " IPAddress NVARCHAR(45) NULL ); END;"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch
            ' best-effort only
        End Try
    End Sub

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
