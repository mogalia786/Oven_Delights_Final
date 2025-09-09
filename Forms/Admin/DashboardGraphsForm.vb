Imports System.Windows.Forms
Imports System.Windows.Forms.DataVisualization.Charting
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Data

Namespace Admin
    Public Class DashboardGraphsForm
        Inherits Form

        Private ReadOnly chartExpenses As New Chart()
        Private ReadOnly chartJournals As New Chart()
        Private ReadOnly lblInfo As New Label() With {.Dock = DockStyle.Top, .Height = 28, .TextAlign = ContentAlignment.MiddleLeft, .Padding = New Padding(8, 4, 0, 0)}
        Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        Public Sub New()
            Me.Text = "Dashboard Graphs"
            Me.Width = 1000
            Me.Height = 700
            Me.BackColor = Color.White

            ' Removed blue header for maximum content visibility
            Controls.Add(New Panel() With {.Dock = DockStyle.Top, .Height = 12})
            Controls.Add(lblInfo)

            Dim split As New SplitContainer() With {.Dock = DockStyle.Fill, .Orientation = Orientation.Horizontal, .SplitterDistance = CInt(Me.Height * 0.48)}
            SetupChart(chartExpenses, "Daily Expenses (Last 14 Days)")
            SetupChart(chartJournals, "Journal Count (Last 14 Days)")
            split.Panel1.Padding = New Padding(8)
            split.Panel2.Padding = New Padding(8)
            split.Panel1.Controls.Add(chartExpenses)
            split.Panel2.Controls.Add(chartJournals)
            Controls.Add(split)

            AddHandler Me.Shown, Sub()
                                      Try
                                          LoadCharts()
                                      Catch ex As Exception
                                          MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                      End Try
                                  End Sub
        End Sub

        Private Function IsSuperAdmin() As Boolean
            Return String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        End Function

        Private Function EffectiveBranchFilterSql(ByRef sqlWhere As String, ByRef branchId As Integer) As Boolean
            ' Returns True if branch parameter should be added
            If IsSuperAdmin() Then
                sqlWhere = String.Empty
                branchId = 0
                Return False
            End If
            branchId = AppSession.CurrentBranchID
            sqlWhere = " WHERE BranchID = @bid"
            Return True
        End Function

        Private Sub LoadCharts()
            Dim info As String = If(IsSuperAdmin(), "Scope: All Branches", $"Scope: BranchID={AppSession.CurrentBranchID}")
            lblInfo.Text = info
            LoadDailyExpenses()
            LoadDailyJournalCounts()
        End Sub

        Private Sub LoadDailyExpenses()
            Try
                Dim where As String = String.Empty
                Dim bid As Integer = 0
                Dim addParam As Boolean = EffectiveBranchFilterSql(where, bid)
                Dim sql As String = "SELECT CAST(ExpenseDate AS date) AS D, SUM(Amount) AS Total " & _
                                    "FROM dbo.DailyExpenses " & where & _
                                    " AND ExpenseDate >= DATEADD(day, -13, CAST(GETDATE() AS date)) " & _
                                    "GROUP BY CAST(ExpenseDate AS date) " & _
                                    "ORDER BY D"
                Using con As New SqlConnection(connectionString)
                    con.Open()
                    Using cmd As New SqlCommand(sql, con)
                        If addParam Then cmd.Parameters.AddWithValue("@bid", bid)
                        Dim dt As New DataTable()
                        Using da As New SqlDataAdapter(cmd)
                            da.Fill(dt)
                        End Using
                        BindChart(chartExpenses, dt, "D", "Total", "#,0.00")
                    End Using
                End Using
            Catch ex As Exception
                ' Non-fatal
            End Try
        End Sub

        Private Sub LoadDailyJournalCounts()
            Try
                Dim where As String = String.Empty
                Dim bid As Integer = 0
                Dim addParam As Boolean = EffectiveBranchFilterSql(where, bid)
                Dim sql As String = "SELECT CAST(JournalDate AS date) AS D, COUNT(*) AS Cnt " & _
                                    "FROM dbo.JournalHeaders " & where & _
                                    " AND JournalDate >= DATEADD(day, -13, CAST(GETDATE() AS date)) " & _
                                    "GROUP BY CAST(JournalDate AS date) " & _
                                    "ORDER BY D"
                Using con As New SqlConnection(connectionString)
                    con.Open()
                    Using cmd As New SqlCommand(sql, con)
                        If addParam Then cmd.Parameters.AddWithValue("@bid", bid)
                        Dim dt As New DataTable()
                        Using da As New SqlDataAdapter(cmd)
                            da.Fill(dt)
                        End Using
                        BindChart(chartJournals, dt, "D", "Cnt", "#,0")
                    End Using
                End Using
            Catch ex As Exception
                ' Non-fatal
            End Try
        End Sub

        Private Sub SetupChart(ch As Chart, title As String)
            ch.Dock = DockStyle.Fill
            ch.BackColor = Color.White
            ch.ChartAreas.Clear()
            Dim ca As New ChartArea("ca1")
            ca.AxisX.MajorGrid.Enabled = False
            ca.AxisY.MajorGrid.LineColor = Color.Gainsboro
            ch.ChartAreas.Add(ca)
            ch.Series.Clear()
            Dim s As New Series("s1") With {
                .ChartType = SeriesChartType.Column,
                .XValueType = ChartValueType.Date,
                .YValueType = ChartValueType.Double,
                .IsValueShownAsLabel = True
            }
            ch.Series.Add(s)
            ch.Titles.Clear()
            ch.Titles.Add(title)
        End Sub

        Private Sub BindChart(ch As Chart, dt As DataTable, xCol As String, yCol As String, labelFmt As String)
            Dim s = ch.Series("s1")
            s.Points.Clear()
            For Each r As DataRow In dt.Rows
                Dim dp As New DataPoint()
                dp.SetValueXY(Convert.ToDateTime(r(xCol)), Convert.ToDouble(r(yCol)))
                dp.LabelFormat = labelFmt
                s.Points.Add(dp)
            Next
        End Sub
    End Class
End Namespace
