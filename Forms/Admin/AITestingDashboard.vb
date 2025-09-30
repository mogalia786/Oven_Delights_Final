Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Drawing
Imports System.Threading.Tasks

Namespace Forms.Admin
    Public Class AITestingDashboard
        Inherits Form

        Private _connectionString As String
        Private dgvTestResults As DataGridView
        Private dgvTestSessions As DataGridView
        Private dgvErrors As DataGridView
        Private btnRunTests As Button
        Private btnViewReport As Button
        Private lblStatus As Label
        Private progressBar As ProgressBar
        Private tabControl As TabControl

        Public Sub New()
            _connectionString = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            InitializeComponent()
            LoadTestData()
        End Sub

        Public Sub New(connectionString As String)
            _connectionString = connectionString
            InitializeComponent()
            LoadTestData()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "AI Testing Dashboard"
            Me.Size = New Size(1200, 800)
            Me.StartPosition = FormStartPosition.CenterScreen

            ' Create tab control
            tabControl = New TabControl()
            tabControl.Dock = DockStyle.Fill
            Me.Controls.Add(tabControl)

            ' Test Sessions Tab
            CreateTestSessionsTab()

            ' Test Results Tab
            CreateTestResultsTab()

            ' Errors Tab
            CreateErrorsTab()

            ' Control Panel
            CreateControlPanel()
        End Sub

        Private Sub CreateTestSessionsTab()
            Dim tabPage As New TabPage("Test Sessions")
            tabControl.TabPages.Add(tabPage)

            dgvTestSessions = New DataGridView()
            dgvTestSessions.Dock = DockStyle.Fill
            dgvTestSessions.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            dgvTestSessions.ReadOnly = True
            dgvTestSessions.SelectionMode = DataGridViewSelectionMode.FullRowSelect
            tabPage.Controls.Add(dgvTestSessions)
        End Sub

        Private Sub CreateTestResultsTab()
            Dim tabPage As New TabPage("Test Results")
            tabControl.TabPages.Add(tabPage)

            dgvTestResults = New DataGridView()
            dgvTestResults.Dock = DockStyle.Fill
            dgvTestResults.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            dgvTestResults.ReadOnly = True
            dgvTestResults.SelectionMode = DataGridViewSelectionMode.FullRowSelect
            tabPage.Controls.Add(dgvTestResults)
        End Sub

        Private Sub CreateErrorsTab()
            Dim tabPage As New TabPage("Errors")
            tabControl.TabPages.Add(tabPage)

            dgvErrors = New DataGridView()
            dgvErrors.Dock = DockStyle.Fill
            dgvErrors.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            dgvErrors.ReadOnly = True
            dgvErrors.SelectionMode = DataGridViewSelectionMode.FullRowSelect
            tabPage.Controls.Add(dgvErrors)
        End Sub

        Private Sub CreateControlPanel()
            Dim panel As New Panel()
            panel.Height = 80
            panel.Dock = DockStyle.Bottom
            panel.BackColor = Color.LightGray
            Me.Controls.Add(panel)

            ' Run Tests Button
            btnRunTests = New Button()
            btnRunTests.Text = "Run Comprehensive Tests"
            btnRunTests.Size = New Size(200, 35)
            btnRunTests.Location = New Point(10, 10)
            btnRunTests.BackColor = Color.Green
            btnRunTests.ForeColor = Color.White
            AddHandler btnRunTests.Click, AddressOf RunTests
            panel.Controls.Add(btnRunTests)

            ' View Report Button
            btnViewReport = New Button()
            btnViewReport.Text = "Generate Report"
            btnViewReport.Size = New Size(150, 35)
            btnViewReport.Location = New Point(220, 10)
            btnViewReport.BackColor = Color.Blue
            btnViewReport.ForeColor = Color.White
            AddHandler btnViewReport.Click, AddressOf GenerateReport
            panel.Controls.Add(btnViewReport)

            ' Status Label
            lblStatus = New Label()
            lblStatus.Text = "Ready"
            lblStatus.Location = New Point(380, 15)
            lblStatus.Size = New Size(300, 25)
            panel.Controls.Add(lblStatus)

            ' Progress Bar
            progressBar = New ProgressBar()
            progressBar.Location = New Point(10, 50)
            progressBar.Size = New Size(360, 20)
            progressBar.Visible = False
            panel.Controls.Add(progressBar)
        End Sub

        Private Async Sub RunTests(sender As Object, e As EventArgs)
            Try
                btnRunTests.Enabled = False
                progressBar.Visible = True
                progressBar.Style = ProgressBarStyle.Marquee
                lblStatus.Text = "Running comprehensive tests with login credentials..."

                Dim testingService As New AITestingService(_connectionString)
                Dim report As TestReport = Await testingService.RunComprehensiveTestWithLogin("faizel", "mogalia")

                lblStatus.Text = $"Tests completed: {report.PassedTests}/{report.TotalTests} passed"
                LoadTestData()

            Catch ex As Exception
                MessageBox.Show($"Error running tests: {ex.Message}", "Testing Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                lblStatus.Text = "Test run failed"
            Finally
                btnRunTests.Enabled = True
                progressBar.Visible = False
            End Try
        End Sub

        Private Sub GenerateReport(sender As Object, e As EventArgs)
            Try
                Dim reportForm As New AITestReportForm(_connectionString)
                reportForm.ShowDialog(Me)
            Catch ex As Exception
                MessageBox.Show($"Error generating report: {ex.Message}", "Report Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadTestData()
            LoadTestSessions()
            LoadTestResults()
            LoadTestErrors()
        End Sub

        Private Sub LoadTestSessions()
            Try
                Using conn As New SqlConnection(_connectionString)
                    conn.Open()
                    Dim sql = "SELECT TOP 20 SessionID, StartTime, EndTime, Status, TotalTests, PassedTests, FailedTests FROM dbo.TestSessions ORDER BY StartTime DESC"
                    Dim adapter As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)
                    dgvTestSessions.DataSource = dt
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading test sessions: {ex.Message}", "Data Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End Try
        End Sub

        Private Sub LoadTestResults()
            Try
                Using conn As New SqlConnection(_connectionString)
                    conn.Open()
                    Dim sql = "SELECT TOP 100 tr.Module, tr.Feature, tr.TestType, tr.Success, tr.Message, tr.Duration, tr.Timestamp FROM dbo.TestResults tr INNER JOIN dbo.TestSessions ts ON tr.SessionID = ts.SessionID ORDER BY tr.Timestamp DESC"
                    Dim adapter As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)
                    dgvTestResults.DataSource = dt

                    ' Color code results
                    For Each row As DataGridViewRow In dgvTestResults.Rows
                        If row.Cells("Success").Value IsNot Nothing Then
                            If CBool(row.Cells("Success").Value) Then
                                row.DefaultCellStyle.BackColor = Color.LightGreen
                            Else
                                row.DefaultCellStyle.BackColor = Color.LightPink
                            End If
                        End If
                    Next
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading test results: {ex.Message}", "Data Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End Try
        End Sub

        Private Sub LoadTestErrors()
            Try
                Using conn As New SqlConnection(_connectionString)
                    conn.Open()
                    Dim sql = "SELECT TOP 50 Module, ErrorMessage, Timestamp, Resolved FROM dbo.TestErrors ORDER BY Timestamp DESC"
                    Dim adapter As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)
                    dgvErrors.DataSource = dt

                    ' Color code errors
                    For Each row As DataGridViewRow In dgvErrors.Rows
                        If row.Cells("Resolved").Value IsNot Nothing Then
                            If CBool(row.Cells("Resolved").Value) Then
                                row.DefaultCellStyle.BackColor = Color.LightBlue
                            Else
                                row.DefaultCellStyle.BackColor = Color.LightCoral
                            End If
                        End If
                    Next
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading test errors: {ex.Message}", "Data Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End Try
        End Sub
    End Class
End Namespace
