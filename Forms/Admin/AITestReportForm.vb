Imports System.Windows.Forms
Imports System.Text
Imports Microsoft.Data.SqlClient
Imports System.Data
Imports System.Drawing
Imports System.IO

Namespace Forms.Admin
    Public Class AITestReportForm
        Inherits Form

        Private _connectionString As String
        Private txtReport As RichTextBox
        Private btnExport As Button
        Private btnClose As Button
        Private WithEvents cmbSessions As ComboBox
        Private lblTitle As Label

        Public Sub New(connectionString As String)
            _connectionString = connectionString
            InitializeComponent()
            LoadSessions()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "AI Testing Report Generator"
            Me.Size = New Size(900, 700)
            Me.StartPosition = FormStartPosition.CenterScreen

            ' Title
            lblTitle = New Label()
            lblTitle.Text = "AI Testing Comprehensive Report"
            lblTitle.Font = New Font("Arial", 16, FontStyle.Bold)
            lblTitle.Location = New Point(20, 20)
            lblTitle.Size = New Size(400, 30)
            Me.Controls.Add(lblTitle)

            ' Session selector
            Dim lblSession As New Label()
            lblSession.Text = "Select Test Session:"
            lblSession.Location = New Point(20, 60)
            lblSession.Size = New Size(120, 20)
            Me.Controls.Add(lblSession)

            cmbSessions = New ComboBox()
            cmbSessions.Location = New Point(150, 58)
            cmbSessions.Size = New Size(300, 25)
            cmbSessions.DropDownStyle = ComboBoxStyle.DropDownList
            Me.Controls.Add(cmbSessions)

            ' Report text area
            txtReport = New RichTextBox()
            txtReport.Location = New Point(20, 100)
            txtReport.Size = New Size(840, 500)
            txtReport.Font = New Font("Consolas", 10)
            txtReport.ReadOnly = True
            Me.Controls.Add(txtReport)

            ' Buttons
            btnExport = New Button()
            btnExport.Text = "Export Report"
            btnExport.Location = New Point(20, 620)
            btnExport.Size = New Size(120, 35)
            btnExport.BackColor = Color.Green
            btnExport.ForeColor = Color.White
            AddHandler btnExport.Click, AddressOf ExportReport
            Me.Controls.Add(btnExport)

            btnClose = New Button()
            btnClose.Text = "Close"
            btnClose.Location = New Point(160, 620)
            btnClose.Size = New Size(80, 35)
            AddHandler btnClose.Click, AddressOf CloseForm
            Me.Controls.Add(btnClose)
        End Sub

        Private Sub LoadSessions()
            Try
                Using conn As New SqlConnection(_connectionString)
                    conn.Open()
                    Dim sql = "SELECT SessionID, StartTime, Status FROM dbo.TestSessions ORDER BY StartTime DESC"
                    Using cmd As New SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            cmbSessions.Items.Clear()
                            While reader.Read()
                                Dim item = $"{reader("SessionID")} - {reader("StartTime")} ({reader("Status")})"
                                cmbSessions.Items.Add(New SessionItem With {
                                    .SessionID = reader("SessionID").ToString(),
                                    .DisplayText = item
                                })
                            End While
                        End Using
                    End Using
                End Using

                If cmbSessions.Items.Count > 0 Then
                    cmbSessions.SelectedIndex = 0
                End If

            Catch ex As Exception
                MessageBox.Show($"Error loading sessions: {ex.Message}", "Data Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End Try
        End Sub

        Private Sub SessionChanged(sender As Object, e As EventArgs)
            If cmbSessions.SelectedItem IsNot Nothing Then
                Dim selectedSession = CType(cmbSessions.SelectedItem, SessionItem)
                GenerateReport(selectedSession.SessionID)
            End If
        End Sub

        Private Sub GenerateReport(sessionID As String)
            Try
                Dim report As New StringBuilder()
                
                ' Header
                report.AppendLine("=" * 80)
                report.AppendLine("OVEN DELIGHTS ERP - AI TESTING COMPREHENSIVE REPORT")
                report.AppendLine("=" * 80)
                report.AppendLine($"Generated: {DateTime.Now:yyyy-MM-dd HH:mm:ss}")
                report.AppendLine($"Session ID: {sessionID}")
                report.AppendLine()

                Using conn As New SqlConnection(_connectionString)
                    conn.Open()

                    ' Session Summary
                    GenerateSessionSummary(conn, sessionID, report)
                    
                    ' Module Results
                    GenerateModuleResults(conn, sessionID, report)
                    
                    ' Error Analysis
                    GenerateErrorAnalysis(conn, sessionID, report)
                    
                    ' Performance Metrics
                    GeneratePerformanceMetrics(conn, sessionID, report)
                    
                    ' Recommendations
                    GenerateRecommendations(conn, sessionID, report)
                End Using

                txtReport.Text = report.ToString()

            Catch ex As Exception
                MessageBox.Show($"Error generating report: {ex.Message}", "Report Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub GenerateSessionSummary(conn As SqlConnection, sessionID As String, report As StringBuilder)
            report.AppendLine("SESSION SUMMARY")
            report.AppendLine("-" * 40)

            Dim sql = "SELECT * FROM dbo.TestSessions WHERE SessionID = @session"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@session", sessionID)
                Using reader = cmd.ExecuteReader()
                    If reader.Read() Then
                        report.AppendLine($"Start Time: {reader("StartTime")}")
                        report.AppendLine($"End Time: {If(reader("EndTime") Is DBNull.Value, "N/A", reader("EndTime"))}")
                        report.AppendLine($"Status: {reader("Status")}")
                        report.AppendLine($"Total Tests: {If(reader("TotalTests") Is DBNull.Value, "N/A", reader("TotalTests"))}")
                        report.AppendLine($"Passed Tests: {If(reader("PassedTests") Is DBNull.Value, "N/A", reader("PassedTests"))}")
                        report.AppendLine($"Failed Tests: {If(reader("FailedTests") Is DBNull.Value, "N/A", reader("FailedTests"))}")
                        
                        If reader("TotalTests") IsNot DBNull.Value AndAlso CInt(reader("TotalTests")) > 0 Then
                            Dim successRate = (CInt(reader("PassedTests")) / CInt(reader("TotalTests"))) * 100
                            report.AppendLine($"Success Rate: {successRate:F1}%")
                        End If
                    End If
                End Using
            End Using
            report.AppendLine()
        End Sub

        Private Sub GenerateModuleResults(conn As SqlConnection, sessionID As String, report As StringBuilder)
            report.AppendLine("MODULE RESULTS")
            report.AppendLine("-" * 40)

            Dim sql = "SELECT Module, COUNT(*) as TotalTests, SUM(CASE WHEN Success = 1 THEN 1 ELSE 0 END) as PassedTests FROM dbo.TestResults WHERE SessionID = @session GROUP BY Module ORDER BY Module"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@session", sessionID)
                Using reader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim moduleValue = reader("Module").ToString()
                        Dim total = CInt(reader("TotalTests"))
                        Dim passed = CInt(reader("PassedTests"))
                        Dim successRate = If(total > 0, (passed / total) * 100, 0)
                        
                        report.AppendLine($"{moduleValue}:")
                        report.AppendLine($"  Tests: {passed}/{total} ({successRate:F1}%)")
                    End While
                End Using
            End Using
            report.AppendLine()
        End Sub

        Private Sub GenerateErrorAnalysis(conn As SqlConnection, sessionID As String, report As StringBuilder)
            report.AppendLine("ERROR ANALYSIS")
            report.AppendLine("-" * 40)

            Dim sql = "SELECT Module, COUNT(*) as ErrorCount FROM dbo.TestErrors WHERE SessionID = @session GROUP BY Module ORDER BY ErrorCount DESC"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@session", sessionID)
                Using reader = cmd.ExecuteReader()
                    If reader.HasRows Then
                        While reader.Read()
                            report.AppendLine($"{reader("Module")}: {reader("ErrorCount")} errors")
                        End While
                    Else
                        report.AppendLine("No errors recorded for this session.")
                    End If
                End Using
            End Using

            ' Detailed errors
            sql = "SELECT TOP 10 Module, ErrorMessage FROM dbo.TestErrors WHERE SessionID = @session ORDER BY Timestamp DESC"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@session", sessionID)
                Using reader = cmd.ExecuteReader()
                    If reader.HasRows Then
                        report.AppendLine()
                        report.AppendLine("Recent Errors:")
                        While reader.Read()
                            report.AppendLine($"  [{reader("Module")}] {reader("ErrorMessage")}")
                        End While
                    End If
                End Using
            End Using
            report.AppendLine()
        End Sub

        Private Sub GeneratePerformanceMetrics(conn As SqlConnection, sessionID As String, report As StringBuilder)
            report.AppendLine("PERFORMANCE METRICS")
            report.AppendLine("-" * 40)

            Dim sql = "SELECT AVG(Duration) as AvgDuration, MAX(Duration) as MaxDuration, MIN(Duration) as MinDuration FROM dbo.TestResults WHERE SessionID = @session AND Duration IS NOT NULL"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@session", sessionID)
                Using reader = cmd.ExecuteReader()
                    If reader.Read() AndAlso reader("AvgDuration") IsNot DBNull.Value Then
                        report.AppendLine($"Average Test Duration: {CDbl(reader("AvgDuration")):F2} ms")
                        report.AppendLine($"Maximum Test Duration: {CDbl(reader("MaxDuration")):F2} ms")
                        report.AppendLine($"Minimum Test Duration: {CDbl(reader("MinDuration")):F2} ms")
                    Else
                        report.AppendLine("No performance data available.")
                    End If
                End Using
            End Using
            report.AppendLine()
        End Sub

        Private Sub GenerateRecommendations(conn As SqlConnection, sessionID As String, report As StringBuilder)
            report.AppendLine("RECOMMENDATIONS")
            report.AppendLine("-" * 40)

            ' Get failed tests
            Dim sql = "SELECT Module, Feature, Message FROM dbo.TestResults WHERE SessionID = @session AND Success = 0"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@session", sessionID)
                Using reader = cmd.ExecuteReader()
                    Dim hasFailures = False
                    While reader.Read()
                        If Not hasFailures Then
                            report.AppendLine("Priority Issues to Address:")
                            hasFailures = True
                        End If
                        report.AppendLine($"• {reader("Module")} - {reader("Feature")}: {reader("Message")}")
                    End While
                    
                    If Not hasFailures Then
                        report.AppendLine("✓ All tests passed successfully!")
                        report.AppendLine("• Continue regular testing schedule")
                        report.AppendLine("• Monitor system performance")
                        report.AppendLine("• Consider adding more test coverage")
                    End If
                End Using
            End Using

            report.AppendLine()
            report.AppendLine("General Recommendations:")
            report.AppendLine("• Run comprehensive tests weekly")
            report.AppendLine("• Address failed tests immediately")
            report.AppendLine("• Monitor performance trends")
            report.AppendLine("• Update test coverage as system evolves")
            report.AppendLine()
            report.AppendLine("=" * 80)
        End Sub

        Private Sub ExportReport(sender As Object, e As EventArgs)
            Try
                Dim saveDialog As New SaveFileDialog()
                saveDialog.Filter = "Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
                saveDialog.FileName = $"AI_Test_Report_{DateTime.Now:yyyyMMdd_HHmmss}.txt"
                
                If saveDialog.ShowDialog() = DialogResult.OK Then
                    File.WriteAllText(saveDialog.FileName, txtReport.Text)
                    MessageBox.Show("Report exported successfully!", "Export Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            Catch ex As Exception
                MessageBox.Show($"Error exporting report: {ex.Message}", "Export Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub CloseForm(sender As Object, e As EventArgs)
            Me.Close()
        End Sub

        Private Class SessionItem
            Public Property SessionID As String
            Public Property DisplayText As String
            
            Public Overrides Function ToString() As String
                Return DisplayText
            End Function
        End Class
    End Class
End Namespace
