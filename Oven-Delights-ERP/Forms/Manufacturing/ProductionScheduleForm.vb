Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports Oven_Delights_ERP.UI

Public Class ProductionScheduleForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _isSuperAdmin As Boolean
    Private ReadOnly _sessionBranchId As Integer

    ' Controls
    Private pnlFilters As Panel
    Private lblBranch As Label
    Private cboBranch As ComboBox
    Private lblFrom As Label
    Private dtpFrom As DateTimePicker
    Private lblTo As Label
    Private dtpTo As DateTimePicker
    Private btnLoad As Button
    Private dgv As DataGridView

    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrWhiteSpace(_connString) Then
            MessageBox.Show("Missing connection string 'OvenDelightsERPConnectionString' in App.config.", "Config Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
        _isSuperAdmin = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        _sessionBranchId = If(AppSession.CurrentUser IsNot Nothing AndAlso AppSession.CurrentUser.BranchID.HasValue, AppSession.CurrentUser.BranchID.Value, 0)
        
        LoadBranches()
        AddHandler btnLoad.Click, AddressOf btnLoad_Click
        AddHandler Me.Shown, AddressOf ProductionScheduleForm_Shown
        
        ' Hide branch selector for non-super admin
        If Not _isSuperAdmin Then
            If lblBranch IsNot Nothing Then lblBranch.Visible = False
            If cboBranch IsNot Nothing Then cboBranch.Visible = False
        End If
        
        Theme.Apply(Me)
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Production Schedule"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterParent
        
        ' Filters panel
        pnlFilters = New Panel() With {.Dock = DockStyle.Top, .Height = 60, .Padding = New Padding(8)}
        lblBranch = New Label() With {.Text = "Branch:", .AutoSize = True, .Left = 8, .Top = 16}
        cboBranch = New ComboBox() With {.Left = 60, .Top = 12, .Width = 200, .DropDownStyle = ComboBoxStyle.DropDownList}
        lblFrom = New Label() With {.Text = "From:", .AutoSize = True, .Left = 280, .Top = 16}
        dtpFrom = New DateTimePicker() With {.Left = 320, .Top = 12, .Format = DateTimePickerFormat.Custom, .CustomFormat = "dd MMM yyyy", .Value = Date.Now}
        lblTo = New Label() With {.Text = "To:", .AutoSize = True, .Left = 500, .Top = 16}
        dtpTo = New DateTimePicker() With {.Left = 530, .Top = 12, .Format = DateTimePickerFormat.Custom, .CustomFormat = "dd MMM yyyy", .Value = Date.Now.AddDays(30)}
        btnLoad = New Button() With {.Left = 720, .Top = 12, .Width = 100, .Text = "Load Schedule"}
        
        pnlFilters.Controls.AddRange({lblBranch, cboBranch, lblFrom, dtpFrom, lblTo, dtpTo, btnLoad})
        
        ' Data grid
        dgv = New DataGridView() With {
            .Dock = DockStyle.Fill,
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }
        
        Me.Controls.AddRange({dgv, pnlFilters})
    End Sub

    Private Sub LoadBranches()
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using da As New SqlDataAdapter("SELECT BranchID, BranchName FROM dbo.Branches ORDER BY BranchName", conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    If _isSuperAdmin Then
                        ' Add "All Branches" option
                        Dim allRow = dt.NewRow()
                        allRow("BranchID") = DBNull.Value
                        allRow("BranchName") = "All Branches"
                        dt.Rows.InsertAt(allRow, 0)
                        cboBranch.DataSource = dt
                        cboBranch.DisplayMember = "BranchName"
                        cboBranch.ValueMember = "BranchID"
                    Else
                        Dim rows = dt.Select($"BranchID = {_sessionBranchId}")
                        If rows IsNot Nothing AndAlso rows.Length > 0 Then
                            cboBranch.DataSource = dt
                            cboBranch.DisplayMember = "BranchName"
                            cboBranch.ValueMember = "BranchID"
                            cboBranch.SelectedValue = _sessionBranchId
                        End If
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading branches: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ProductionScheduleForm_Shown(sender As Object, e As EventArgs)
        LoadSchedule()
    End Sub

    Private Sub btnLoad_Click(sender As Object, e As EventArgs)
        LoadSchedule()
    End Sub

    Private Sub LoadSchedule()
        Try
            Using conn As New SqlConnection(_connString)
                ' Production schedule with fallbacks for different table structures
                Dim sql As String = "IF OBJECT_ID('dbo.v_Manufacturing_ProductionSchedule','V') IS NOT NULL " & _
                                    "SELECT ScheduleID, ProductName, ScheduledDate, Quantity, Status, BranchName FROM dbo.v_Manufacturing_ProductionSchedule " & _
                                    "WHERE ScheduledDate BETWEEN @from AND @to AND (@bid IS NULL OR BranchID = @bid) ORDER BY ScheduledDate " & _
                                    "ELSE IF OBJECT_ID('dbo.Manufacturing_ProductionSchedule','U') IS NOT NULL " & _
                                    "SELECT ps.ScheduleID, ISNULL(p.ProductName, 'Unknown Product') AS ProductName, ps.ScheduledDate, ps.Quantity, " & _
                                    "ISNULL(ps.Status, 'Pending') AS Status, ISNULL(b.BranchName, 'Main') AS BranchName " & _
                                    "FROM dbo.Manufacturing_ProductionSchedule ps " & _
                                    "LEFT JOIN dbo.Products p ON p.ProductID = ps.ProductID " & _
                                    "LEFT JOIN dbo.Branches b ON b.BranchID = ps.BranchID " & _
                                    "WHERE ps.ScheduledDate BETWEEN @from AND @to AND (@bid IS NULL OR ps.BranchID = @bid) ORDER BY ps.ScheduledDate " & _
                                    "ELSE SELECT CAST(NULL AS INT) AS ScheduleID, CAST('No production schedule available' AS NVARCHAR(200)) AS ProductName, " & _
                                    "CAST('1900-01-01' AS DATE) AS ScheduledDate, CAST(0 AS DECIMAL(18,2)) AS Quantity, " & _
                                    "CAST('N/A' AS NVARCHAR(50)) AS Status, CAST('N/A' AS NVARCHAR(100)) AS BranchName WHERE 1=0;"
                
                Using da As New SqlDataAdapter(sql, conn)
                    Dim bid As Object = GetBranchParam()
                    da.SelectCommand.Parameters.AddWithValue("@from", dtpFrom.Value.Date)
                    da.SelectCommand.Parameters.AddWithValue("@to", dtpTo.Value.Date.AddDays(1).AddSeconds(-1))
                    da.SelectCommand.Parameters.AddWithValue("@bid", bid)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgv.DataSource = dt
                    
                    ' Format columns
                    If dgv.Columns.Contains("Quantity") Then dgv.Columns("Quantity").DefaultCellStyle.Format = "N2"
                    If dgv.Columns.Contains("ScheduledDate") Then dgv.Columns("ScheduledDate").DefaultCellStyle.Format = "dd MMM yyyy"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading production schedule: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function GetBranchParam() As Object
        If _isSuperAdmin Then
            Dim v = If(cboBranch IsNot Nothing, cboBranch.SelectedValue, Nothing)
            Return If(v Is Nothing OrElse v Is DBNull.Value, DBNull.Value, v)
        End If
        If _sessionBranchId <= 0 Then Return DBNull.Value
        Return _sessionBranchId
    End Function
End Class
