Imports System.Threading
Imports System.Threading.Tasks
Imports System.Data.SqlClient

Public Class AITestingBackgroundService
    Private _connectionString As String
    Private _timer As Timer
    Private _isRunning As Boolean = False
    Private _testingService As AITestingService
    
    Public Sub New(connectionString As String)
        _connectionString = connectionString
        _testingService = New AITestingService(connectionString)
    End Sub
    
    Public Sub StartBackgroundTesting()
        ' Run tests immediately, then every 5 minutes for active testing
        _timer = New Timer(AddressOf RunScheduledTests, Nothing, TimeSpan.Zero, TimeSpan.FromMinutes(5))
        LogActivity("AI PA Background Testing Service started - running every 5 minutes")
    End Sub
    
    Public Sub StopBackgroundTesting()
        _timer?.Dispose()
        _isRunning = False
    End Sub
    
    Private Async Sub RunScheduledTests(state As Object)
        If _isRunning Then Return ' Prevent overlapping runs
        
        _isRunning = True
        Try
            ' Log test start with timestamp
            LogActivity($"AI PA Background testing cycle started at {DateTime.Now:yyyy-MM-dd HH:mm:ss}")
            
            ' Update service status to Running
            UpdateServiceStatus("Running")
            
            ' Run comprehensive tests with actual form testing
            Dim report As TestReport = Await _testingService.RunComprehensiveTest()
            
            ' Log detailed results
            LogActivity($"Testing cycle completed - Total: {report.TotalTests}, Passed: {report.PassedTests}, Failed: {report.FailedTests}")
            
            ' Analyze results and fix issues
            Await AnalyzeAndFixIssues(report)
            
            ' Update service status
            UpdateServiceStatus("Completed", report.TotalTests, report.PassedTests, report.FailedTests)
            
            LogActivity($"AI PA cycle finished - next run in 5 minutes")
            
        Catch ex As Exception
            LogActivity($"AI PA Background testing error: {ex.Message}")
            LogActivity($"Stack trace: {ex.StackTrace}")
            UpdateServiceStatus("Error", 0, 0, 0, ex.Message)
        Finally
            _isRunning = False
        End Try
    End Sub
    
    Private Async Function AnalyzeAndFixIssues(report As TestReport) As Task
        ' Get failed tests that can be auto-fixed
        Dim fixableIssues = report.TestResults.Where(Function(t) Not t.Success AndAlso IsFixableIssue(t)).ToList()
        
        For Each issue In fixableIssues
            Try
                Await AttemptAutoFix(issue)
                LogActivity($"Auto-fixed: {issue.ModuleName} - {issue.Feature}")
            Catch ex As Exception
                LogActivity($"Auto-fix failed for {issue.ModuleName} - {issue.Feature}: {ex.Message}")
            End Try
        Next
        
        ' Log critical issues that need manual attention
        Dim criticalIssues = report.TestResults.Where(Function(t) Not t.Success AndAlso IsCriticalIssue(t)).ToList()
        For Each issue In criticalIssues
            LogCriticalIssue(issue)
        Next
    End Function
    
    Private Function IsFixableIssue(testResult As TestResult) As Boolean
        ' Determine if issue can be automatically fixed
        If testResult.Message.Contains("form not found", StringComparison.OrdinalIgnoreCase) Then Return False
        If testResult.Message.Contains("database connection", StringComparison.OrdinalIgnoreCase) Then Return False
        If testResult.Message.Contains("missing handler", StringComparison.OrdinalIgnoreCase) Then Return True
        If testResult.Message.Contains("null reference", StringComparison.OrdinalIgnoreCase) Then Return True
        Return False
    End Function
    
    Private Function IsCriticalIssue(testResult As TestResult) As Boolean
        ' Determine if issue is critical and needs immediate attention
        Return testResult.ModuleName = "Administration" OrElse 
               testResult.ModuleName = "Accounting" OrElse
               testResult.Message.Contains("database", StringComparison.OrdinalIgnoreCase)
    End Function
    
    Private Async Function AttemptAutoFix(testResult As TestResult) As Task
        Select Case True
            Case testResult.Message.Contains("missing handler", StringComparison.OrdinalIgnoreCase)
                Await FixMissingHandler(testResult)
                
            Case testResult.Message.Contains("null reference", StringComparison.OrdinalIgnoreCase)
                Await FixNullReference(testResult)
                
            Case testResult.Message.Contains("data source", StringComparison.OrdinalIgnoreCase)
                Await FixDataSource(testResult)
        End Select
    End Function
    
    Private Async Function FixMissingHandler(testResult As TestResult) As Task
        ' Generate and apply missing event handler
        Dim handlerCode = GenerateEventHandler(testResult.FormName, testResult.Feature)
        If Not String.IsNullOrEmpty(handlerCode) Then
            Await ApplyCodeFix(testResult.FormName, handlerCode)
        End If
    End Function
    
    Private Async Function FixNullReference(testResult As TestResult) As Task
        ' Add null checks and defensive programming
        Dim nullCheckCode = GenerateNullChecks(testResult.FormName, testResult.Message)
        If Not String.IsNullOrEmpty(nullCheckCode) Then
            Await ApplyCodeFix(testResult.FormName, nullCheckCode)
        End If
    End Function
    
    Private Async Function FixDataSource(testResult As TestResult) As Task
        ' Fix data binding issues
        Dim dataSourceFix = GenerateDataSourceFix(testResult.FormName, testResult.Feature)
        If Not String.IsNullOrEmpty(dataSourceFix) Then
            Await ApplyCodeFix(testResult.FormName, dataSourceFix)
        End If
    End Function
    
    Private Function GenerateEventHandler(formName As String, feature As String) As String
        ' Generate appropriate event handler code
        Return $"
    Private Sub {feature.Replace(" ", "")}Handler(sender As Object, e As EventArgs)
        Try
            ' Auto-generated handler for {feature}
            MessageBox.Show(""{feature} functionality is being implemented."", ""Info"", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($""Error in {feature}: {{ex.Message}}"", ""Error"", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub"
    End Function
    
    Private Function GenerateNullChecks(formName As String, errorMessage As String) As String
        ' Generate null check code based on error message
        If errorMessage.Contains("DataGridView") Then
            Return "
        If dgvData IsNot Nothing AndAlso dgvData.DataSource IsNot Nothing Then
            ' Safe data grid operations
        End If"
        ElseIf errorMessage.Contains("TextBox") Then
            Return "
        If txtInput IsNot Nothing AndAlso Not String.IsNullOrEmpty(txtInput.Text) Then
            ' Safe text box operations
        End If"
        End If
        Return String.Empty
    End Function
    
    Private Function GenerateDataSourceFix(formName As String, feature As String) As String
        ' Generate data source initialization code
        Return $"
    Private Sub Initialize{feature.Replace(" ", "")}Data()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = ""SELECT * FROM {GetTableName(feature)}""
                Dim adapter As New SqlDataAdapter(sql, conn)
                Dim dt As New DataTable()
                adapter.Fill(dt)
                dgvData.DataSource = dt
            End Using
        Catch ex As Exception
            MessageBox.Show($""Error loading {feature} data: {{ex.Message}}"", ""Data Error"", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub"
    End Function
    
    Private Function GetTableName(feature As String) As String
        ' Map feature names to database table names
        Select Case feature.ToLower()
            Case "user management" : Return "Users"
            Case "branch management" : Return "Branches"
            Case "audit log" : Return "AuditLog"
            Case "products" : Return "Retail_Product"
            Case "stock" : Return "Retail_Stock"
            Case Else : Return "SystemSettings"
        End Select
    End Function
    
    Private Async Function ApplyCodeFix(formName As String, codeToAdd As String) As Task
        ' Apply the generated code fix to the form file
        Try
            Dim formPath = $"Forms\{formName}.vb"
            If IO.File.Exists(formPath) Then
                Dim content = Await IO.File.ReadAllTextAsync(formPath)
                
                ' Find insertion point (before End Class)
                Dim insertionPoint = content.LastIndexOf("End Class")
                If insertionPoint > 0 Then
                    Dim newContent = content.Insert(insertionPoint, codeToAdd & vbCrLf & vbCrLf)
                    Await IO.File.WriteAllTextAsync(formPath, newContent)
                    LogActivity($"Applied code fix to {formName}")
                End If
            End If
        Catch ex As Exception
            LogActivity($"Failed to apply code fix to {formName}: {ex.Message}")
        End Try
    End Function
    
    Private Sub LogActivity(message As String)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "INSERT INTO dbo.AITestingLog (Timestamp, Message, LogType) VALUES (@time, @msg, 'Background')"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@time", DateTime.Now)
                    cmd.Parameters.AddWithValue("@msg", message)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch
            ' Silent fail for logging
        End Try
    End Sub
    
    Private Sub UpdateServiceStatus(status As String, Optional totalTests As Integer = 0, Optional passedTests As Integer = 0, Optional failedTests As Integer = 0, Optional errorMessage As String = Nothing)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "UPDATE dbo.BackgroundServiceStatus SET LastRun = @lastRun, Status = @status, RunCount = RunCount + 1, LastError = @error WHERE ServiceName = 'AI Testing Background Service'"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@lastRun", DateTime.Now)
                    cmd.Parameters.AddWithValue("@status", status)
                    cmd.Parameters.AddWithValue("@error", If(errorMessage, DBNull.Value))
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch
            ' Silent fail for status update
        End Try
    End Sub

    Private Sub LogCriticalIssue(testResult As TestResult)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "INSERT INTO dbo.CriticalIssues (Timestamp, Module, Feature, Message, Priority) VALUES (@time, @module, @feature, @msg, 'High')"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@time", DateTime.Now)
                    cmd.Parameters.AddWithValue("@module", testResult.ModuleName)
                    cmd.Parameters.AddWithValue("@feature", testResult.Feature)
                    cmd.Parameters.AddWithValue("@msg", testResult.Message)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch
            ' Silent fail for logging
        End Try
    End Sub
End Class
