Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports Oven_Delights_ERP.UI

Public Class StockMovementReportForm
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
    Private lblMovementType As Label
    Private cboMovementType As ComboBox
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
        LoadMovementTypes()
        AddHandler btnLoad.Click, AddressOf btnLoad_Click
        AddHandler Me.Shown, AddressOf StockMovementReportForm_Shown
        
        ' Hide branch selector for non-super admin
        If Not _isSuperAdmin Then
            If lblBranch IsNot Nothing Then lblBranch.Visible = False
            If cboBranch IsNot Nothing Then cboBranch.Visible = False
        End If
        
        Theme.Apply(Me)
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Stock Movement Report"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterParent
        
        ' Filters panel
        pnlFilters = New Panel() With {.Dock = DockStyle.Top, .Height = 60, .Padding = New Padding(8)}
        lblBranch = New Label() With {.Text = "Branch:", .AutoSize = True, .Left = 8, .Top = 16}
        cboBranch = New ComboBox() With {.Left = 60, .Top = 12, .Width = 150, .DropDownStyle = ComboBoxStyle.DropDownList}
        lblFrom = New Label() With {.Text = "From:", .AutoSize = True, .Left = 230, .Top = 16}
        dtpFrom = New DateTimePicker() With {.Left = 270, .Top = 12, .Format = DateTimePickerFormat.Custom, .CustomFormat = "dd MMM yyyy", .Value = Date.Now.AddDays(-7)}
        lblTo = New Label() With {.Text = "To:", .AutoSize = True, .Left = 450, .Top = 16}
        dtpTo = New DateTimePicker() With {.Left = 480, .Top = 12, .Format = DateTimePickerFormat.Custom, .CustomFormat = "dd MMM yyyy", .Value = Date.Now}
        lblMovementType = New Label() With {.Text = "Type:", .AutoSize = True, .Left = 660, .Top = 16}
        cboMovementType = New ComboBox() With {.Left = 700, .Top = 12, .Width = 120, .DropDownStyle = ComboBoxStyle.DropDownList}
        btnLoad = New Button() With {.Left = 840, .Top = 12, .Width = 100, .Text = "Load Report"}
        
        pnlFilters.Controls.AddRange({lblBranch, cboBranch, lblFrom, dtpFrom, lblTo, dtpTo, lblMovementType, cboMovementType, btnLoad})
        
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

    Private Sub LoadMovementTypes()
        Try
            Dim dt As New DataTable()
            dt.Columns.Add("Type", GetType(String))
            dt.Rows.Add("All Types")
            dt.Rows.Add("Receipt")
            dt.Rows.Add("Issue")
            dt.Rows.Add("Transfer")
            dt.Rows.Add("Adjustment")
            dt.Rows.Add("Return")
            cboMovementType.DataSource = dt
            cboMovementType.DisplayMember = "Type"
            cboMovementType.ValueMember = "Type"
        Catch ex As Exception
            MessageBox.Show("Error loading movement types: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub StockMovementReportForm_Shown(sender As Object, e As EventArgs)
        LoadReport()
    End Sub

    Private Sub btnLoad_Click(sender As Object, e As EventArgs)
        LoadReport()
    End Sub

    Private Sub LoadReport()
        Try
            Using conn As New SqlConnection(_connString)
                ' Stock movement report with fallbacks
                Dim sql As String = "IF OBJECT_ID('dbo.v_Stockroom_StockMovements','V') IS NOT NULL " & _
                                    "SELECT MovementDate, MaterialCode, MaterialName, MovementType, Quantity, UnitCost, TotalValue, BranchName, Reference FROM dbo.v_Stockroom_StockMovements " & _
                                    "WHERE MovementDate BETWEEN @from AND @to AND (@bid IS NULL OR BranchID = @bid) AND (@type = 'All Types' OR MovementType = @type) ORDER BY MovementDate DESC " & _
                                    "ELSE IF OBJECT_ID('dbo.Stockroom_StockMovements','U') IS NOT NULL " & _
                                    "SELECT sm.MovementDate, ISNULL(m.MaterialCode, 'Unknown') AS MaterialCode, ISNULL(m.MaterialName, 'Unknown Material') AS MaterialName, " & _
                                    "ISNULL(sm.MovementType, 'Unknown') AS MovementType, sm.Quantity, ISNULL(sm.UnitCost, 0) AS UnitCost, " & _
                                    "(sm.Quantity * ISNULL(sm.UnitCost, 0)) AS TotalValue, ISNULL(b.BranchName, 'Main') AS BranchName, " & _
                                    "ISNULL(sm.Reference, '') AS Reference " & _
                                    "FROM dbo.Stockroom_StockMovements sm " & _
                                    "LEFT JOIN dbo.Stockroom_Materials m ON m.MaterialID = sm.MaterialID " & _
                                    "LEFT JOIN dbo.Branches b ON b.BranchID = sm.BranchID " & _
                                    "WHERE sm.MovementDate BETWEEN @from AND @to AND (@bid IS NULL OR sm.BranchID = @bid) AND (@type = 'All Types' OR ISNULL(sm.MovementType, 'Unknown') = @type) ORDER BY sm.MovementDate DESC " & _
                                    "ELSE SELECT CAST('1900-01-01' AS DATE) AS MovementDate, CAST('N/A' AS NVARCHAR(50)) AS MaterialCode, " & _
                                    "CAST('No stock movements available' AS NVARCHAR(200)) AS MaterialName, CAST('N/A' AS NVARCHAR(50)) AS MovementType, " & _
                                    "CAST(0 AS DECIMAL(18,2)) AS Quantity, CAST(0 AS DECIMAL(18,2)) AS UnitCost, CAST(0 AS DECIMAL(18,2)) AS TotalValue, " & _
                                    "CAST('N/A' AS NVARCHAR(100)) AS BranchName, CAST('N/A' AS NVARCHAR(200)) AS Reference WHERE 1=0;"
                
                Using da As New SqlDataAdapter(sql, conn)
                    Dim bid As Object = GetBranchParam()
                    Dim movType As String = If(cboMovementType.SelectedValue?.ToString(), "All Types")
                    da.SelectCommand.Parameters.AddWithValue("@from", dtpFrom.Value.Date)
                    da.SelectCommand.Parameters.AddWithValue("@to", dtpTo.Value.Date.AddDays(1).AddSeconds(-1))
                    da.SelectCommand.Parameters.AddWithValue("@bid", bid)
                    da.SelectCommand.Parameters.AddWithValue("@type", movType)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgv.DataSource = dt
                    
                    ' Format columns
                    If dgv.Columns.Contains("Quantity") Then dgv.Columns("Quantity").DefaultCellStyle.Format = "N2"
                    If dgv.Columns.Contains("UnitCost") Then dgv.Columns("UnitCost").DefaultCellStyle.Format = "C2"
                    If dgv.Columns.Contains("TotalValue") Then dgv.Columns("TotalValue").DefaultCellStyle.Format = "C2"
                    If dgv.Columns.Contains("MovementDate") Then dgv.Columns("MovementDate").DefaultCellStyle.Format = "dd MMM yyyy HH:mm"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading stock movement report: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
