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

    Private Sub SetupAuditLogColumns()
        dgvAuditLog.Columns.Clear()
        dgvAuditLog.Columns.Add("ID", "ID")
        dgvAuditLog.Columns.Add("UserID", "User ID")
        dgvAuditLog.Columns.Add("Action", "Action")
        dgvAuditLog.Columns.Add("TableName", "Table")
        dgvAuditLog.Columns.Add("RecordID", "Record ID")
        dgvAuditLog.Columns.Add("Details", "Details")
        dgvAuditLog.Columns.Add("Timestamp", "Timestamp")
        dgvAuditLog.Columns.Add("IPAddress", "IP Address")
        
        ' Set column widths
        dgvAuditLog.Columns("ID").Width = 60
        dgvAuditLog.Columns("UserID").Width = 80
        dgvAuditLog.Columns("Action").Width = 120
        dgvAuditLog.Columns("TableName").Width = 100
        dgvAuditLog.Columns("RecordID").Width = 80
        dgvAuditLog.Columns("Details").Width = 300
        dgvAuditLog.Columns("Timestamp").Width = 150
        dgvAuditLog.Columns("IPAddress").Width = 120
    End Sub

    Private Sub LoadAuditLogs()
        Try
            ' Ensure columns exist before clearing rows
            If dgvAuditLog.Columns.Count = 0 Then
                SetupAuditLogColumns()
            End If
            
            dgvAuditLog.Rows.Clear()
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                Dim sql As String = "SELECT TOP 1000 AuditID AS ID, UserID, Action, TableName, RecordID, " &
                                   "Details, Timestamp, IPAddress " &
                                   "FROM AuditLog " &
                                   "WHERE (@FromDate IS NULL OR Timestamp >= @FromDate) " &
                                   "AND (@ToDate IS NULL OR Timestamp <= @ToDate) " &
                                   "AND (@Action IS NULL OR @Action = '' OR @Action = 'All Actions' OR Action = @Action) " &
                                   "AND (@UserID IS NULL OR UserID = @UserID) " &
                                   "ORDER BY Timestamp DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@FromDate", If(dtpFromDate.Value.Date = DateTime.MinValue.Date, DBNull.Value, dtpFromDate.Value.Date))
                    cmd.Parameters.AddWithValue("@ToDate", If(dtpToDate.Value.Date = DateTime.MaxValue.Date, DBNull.Value, dtpToDate.Value.Date.AddDays(1).AddSeconds(-1)))
                    cmd.Parameters.AddWithValue("@Action", If(cboAction.SelectedItem?.ToString() = "All Actions", DBNull.Value, cboAction.SelectedItem?.ToString()))
                    cmd.Parameters.AddWithValue("@UserID", If(_cboUser.SelectedValue Is Nothing OrElse CInt(_cboUser.SelectedValue) = 0, DBNull.Value, _cboUser.SelectedValue))
                    
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            dgvAuditLog.Rows.Add(
                                reader("ID"),
                                reader("UserID"),
                                reader("Action"),
                                If(IsDBNull(reader("TableName")), "", reader("TableName").ToString()),
                                If(IsDBNull(reader("RecordID")), "", reader("RecordID").ToString()),
                                If(IsDBNull(reader("Details")), "", reader("Details").ToString()),
                                reader("Timestamp"),
                                If(IsDBNull(reader("IPAddress")), "", reader("IPAddress").ToString())
                            )
                        End While
                    End Using
                End Using
            End Using
            
            ' Insert sample data if no records exist
            If dgvAuditLog.Rows.Count = 0 Then
                InsertSampleAuditData()
                LoadAuditLogs() ' Reload after inserting sample data
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error loading audit logs: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub InsertSampleAuditData()
        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                ' Insert sample audit log entries
                Dim sampleEntries As String() = {
                    "INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Details, Timestamp, IPAddress) VALUES (1, 'Login', 'Users', '1', 'User logged in successfully', GETDATE(), '127.0.0.1')",
                    "INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Details, Timestamp, IPAddress) VALUES (1, 'UserCreated', 'Users', '2', 'New user account created', DATEADD(MINUTE, -30, GETDATE()), '127.0.0.1')",
                    "INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Details, Timestamp, IPAddress) VALUES (1, 'BranchCreated', 'Branches', '1', 'New branch office created', DATEADD(HOUR, -2, GETDATE()), '127.0.0.1')",
                    "INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Details, Timestamp, IPAddress) VALUES (1, 'UserUpdated', 'Users', '1', 'User profile updated', DATEADD(DAY, -1, GETDATE()), '127.0.0.1')"
                }
                
                For Each entry In sampleEntries
                    Using cmd As New SqlCommand(entry, conn)
                        cmd.ExecuteNonQuery()
                    End Using
                Next
            End Using
        Catch ex As Exception
            ' Ignore errors when inserting sample data
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
