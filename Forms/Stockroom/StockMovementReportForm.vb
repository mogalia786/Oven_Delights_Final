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
    Private ReadOnly stockroomService As New StockroomService()

    ' Controls are declared in Designer file - use Designer names
    ' btnGenerate, dgvMovements, dtpFromDate, dtpToDate declared in Designer

    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrWhiteSpace(_connString) Then
            MessageBox.Show("Missing connection string 'OvenDelightsERPConnectionString' in App.config.", "Config Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
        _isSuperAdmin = stockroomService.IsCurrentUserSuperAdmin()
        _sessionBranchId = stockroomService.GetCurrentUserBranchId()

        LoadBranches()
        LoadMovementTypes()
        AddHandler btnGenerate.Click, AddressOf btnLoad_Click
        AddHandler Me.Shown, AddressOf StockMovementReportForm_Shown

        ' Branch selector not in current Designer - will add if needed

        Theme.Apply(Me)
    End Sub

    ' InitializeComponent is in Designer file

    Private Sub LoadBranches()
        Try
            Dim branches = stockroomService.GetBranchesLookup()
            If branches IsNot Nothing AndAlso branches.Rows.Count > 0 Then
                If _isSuperAdmin Then
                    ' Add "All Branches" option
                    Dim allRow = branches.NewRow()
                    allRow("BranchID") = DBNull.Value
                    allRow("BranchName") = "All Branches"
                    branches.Rows.InsertAt(allRow, 0)
                    ' Branch combo not in Designer - will add if needed
                    ' cboBranch.DataSource = branches
                    ' cboBranch.DisplayMember = "BranchName"
                    ' cboBranch.ValueMember = "BranchID"
                Else
                    Dim rows = branches.Select($"BranchID = {_sessionBranchId}")
                    If rows IsNot Nothing AndAlso rows.Length > 0 Then
                        ' Branch combo not in Designer - will add if needed
                        ' cboBranch.DataSource = branches
                        ' cboBranch.DisplayMember = "BranchName"
                        ' cboBranch.ValueMember = "BranchID"
                        ' cboBranch.SelectedValue = _sessionBranchId
                    End If
                End If
            End If
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
                Dim sql As String = "IF OBJECT_ID('dbo.v_Stockroom_StockMovements','V') IS NOT NULL " &
                                    "SELECT MovementDate, MaterialCode, MaterialName, MovementType, Quantity, UnitCost, TotalValue, BranchName, Reference FROM dbo.v_Stockroom_StockMovements " &
                                    "WHERE MovementDate BETWEEN @from AND @to AND (@bid IS NULL OR BranchID = @bid) AND (@type = 'All Types' OR MovementType = @type) ORDER BY MovementDate DESC " &
                                    "ELSE IF OBJECT_ID('dbo.Stockroom_StockMovements','U') IS NOT NULL " &
                                    "SELECT sm.MovementDate, ISNULL(m.MaterialCode, 'Unknown') AS MaterialCode, ISNULL(m.MaterialName, 'Unknown Material') AS MaterialName, " &
                                    "ISNULL(sm.MovementType, 'Unknown') AS MovementType, sm.Quantity, ISNULL(sm.UnitCost, 0) AS UnitCost, " &
                                    "(sm.Quantity * ISNULL(sm.UnitCost, 0)) AS TotalValue, ISNULL(b.BranchName, 'Main') AS BranchName, " &
                                    "ISNULL(sm.Reference, '') AS Reference " &
                                    "FROM dbo.Stockroom_StockMovements sm " &
                                    "LEFT JOIN dbo.Stockroom_Materials m ON m.MaterialID = sm.MaterialID " &
                                    "LEFT JOIN dbo.Branches b ON b.BranchID = sm.BranchID " &
                                    "WHERE sm.MovementDate BETWEEN @from AND @to AND (@bid IS NULL OR sm.BranchID = @bid) AND (@type = 'All Types' OR ISNULL(sm.MovementType, 'Unknown') = @type) ORDER BY sm.MovementDate DESC " &
                                    "ELSE SELECT CAST('1900-01-01' AS DATE) AS MovementDate, CAST('N/A' AS NVARCHAR(50)) AS MaterialCode, " &
                                    "CAST('No stock movements available' AS NVARCHAR(200)) AS MaterialName, CAST('N/A' AS NVARCHAR(50)) AS MovementType, " &
                                    "CAST(0 AS DECIMAL(18,2)) AS Quantity, CAST(0 AS DECIMAL(18,2)) AS UnitCost, CAST(0 AS DECIMAL(18,2)) AS TotalValue, " &
                                    "CAST('N/A' AS NVARCHAR(100)) AS BranchName, CAST('N/A' AS NVARCHAR(200)) AS Reference WHERE 1=0;"

                Using da As New SqlDataAdapter(sql, conn)
                    Dim bid As Object = GetBranchParam()
                    Dim movType As String = If(cboMovementType.SelectedValue?.ToString(), "All Types")
                    da.SelectCommand.Parameters.AddWithValue("@from", dtpFromDate.Value.Date)
                    da.SelectCommand.Parameters.AddWithValue("@to", dtpToDate.Value.Date.AddDays(1).AddSeconds(-1))
                    da.SelectCommand.Parameters.AddWithValue("@bid", bid)
                    da.SelectCommand.Parameters.AddWithValue("@type", movType)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvMovements.DataSource = dt

                    ' Format columns
                    If dgvMovements.Columns.Contains("Quantity") Then dgvMovements.Columns("Quantity").DefaultCellStyle.Format = "N2"
                    If dgvMovements.Columns.Contains("UnitCost") Then dgvMovements.Columns("UnitCost").DefaultCellStyle.Format = "C2"
                    If dgvMovements.Columns.Contains("TotalValue") Then dgvMovements.Columns("TotalValue").DefaultCellStyle.Format = "C2"
                    If dgvMovements.Columns.Contains("MovementDate") Then dgvMovements.Columns("MovementDate").DefaultCellStyle.Format = "dd MMM yyyy HH:mm"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading stock movement report: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function GetBranchParam() As Object
        If _isSuperAdmin Then
            ' Branch combo not in current Designer
            Dim v As Object = DBNull.Value
            Return If(v Is Nothing OrElse v Is DBNull.Value, DBNull.Value, v)
        End If
        If _sessionBranchId <= 0 Then Return DBNull.Value
        Return _sessionBranchId
    End Function
End Class
