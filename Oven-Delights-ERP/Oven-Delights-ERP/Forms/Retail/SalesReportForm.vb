Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports Oven_Delights_ERP.UI

Public Class SalesReportForm
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
        AddHandler Me.Shown, AddressOf SalesReportForm_Shown
        
        ' Hide branch selector for non-super admin
        If Not _isSuperAdmin Then
            If lblBranch IsNot Nothing Then lblBranch.Visible = False
            If cboBranch IsNot Nothing Then cboBranch.Visible = False
        End If
        
        Theme.Apply(Me)
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Sales Report"
        Me.Size = New Size(1000, 700)
        Me.StartPosition = FormStartPosition.CenterParent
        
        ' Filters panel
        pnlFilters = New Panel() With {.Dock = DockStyle.Top, .Height = 60, .Padding = New Padding(8)}
        lblBranch = New Label() With {.Text = "Branch:", .AutoSize = True, .Left = 8, .Top = 16}
        cboBranch = New ComboBox() With {.Left = 60, .Top = 12, .Width = 200, .DropDownStyle = ComboBoxStyle.DropDownList}
        lblFrom = New Label() With {.Text = "From:", .AutoSize = True, .Left = 280, .Top = 16}
        dtpFrom = New DateTimePicker() With {.Left = 320, .Top = 12, .Format = DateTimePickerFormat.Custom, .CustomFormat = "dd MMM yyyy", .Value = Date.Now.AddMonths(-1)}
        lblTo = New Label() With {.Text = "To:", .AutoSize = True, .Left = 500, .Top = 16}
        dtpTo = New DateTimePicker() With {.Left = 530, .Top = 12, .Format = DateTimePickerFormat.Custom, .CustomFormat = "dd MMM yyyy", .Value = Date.Now}
        btnLoad = New Button() With {.Left = 720, .Top = 12, .Width = 100, .Text = "Load Report"}
        
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

    Private Sub SalesReportForm_Shown(sender As Object, e As EventArgs)
        LoadReport()
    End Sub

    Private Sub btnLoad_Click(sender As Object, e As EventArgs)
        LoadReport()
    End Sub

    Private Sub LoadReport()
        Try
            Using conn As New SqlConnection(_connString)
                ' Flexible sales report query with fallbacks
                Dim sql As String = "IF OBJECT_ID('dbo.v_Retail_SalesReport','V') IS NOT NULL " & _
                                    "SELECT TransactionDate, ProductName, Quantity, UnitPrice, LineTotal, BranchName FROM dbo.v_Retail_SalesReport " & _
                                    "WHERE TransactionDate BETWEEN @from AND @to AND (@bid IS NULL OR BranchID = @bid) ORDER BY TransactionDate DESC " & _
                                    "ELSE IF OBJECT_ID('dbo.Retail_SalesTransactions','U') IS NOT NULL " & _
                                    "SELECT st.TransactionDate, ISNULL(p.Name, 'Unknown Product') AS ProductName, st.Quantity, st.UnitPrice, st.LineTotal, ISNULL(b.BranchName, 'Unknown Branch') AS BranchName " & _
                                    "FROM dbo.Retail_SalesTransactions st " & _
                                    "LEFT JOIN dbo.Retail_Product p ON p.ProductID = st.ProductID " & _
                                    "LEFT JOIN dbo.Branches b ON b.BranchID = st.BranchID " & _
                                    "WHERE st.TransactionDate BETWEEN @from AND @to AND (@bid IS NULL OR st.BranchID = @bid) ORDER BY st.TransactionDate DESC " & _
                                    "ELSE SELECT CAST('1900-01-01' AS DATE) AS TransactionDate, CAST('No sales data available' AS NVARCHAR(200)) AS ProductName, CAST(0 AS DECIMAL(18,2)) AS Quantity, CAST(0 AS DECIMAL(18,2)) AS UnitPrice, CAST(0 AS DECIMAL(18,2)) AS LineTotal, CAST('N/A' AS NVARCHAR(100)) AS BranchName WHERE 1=0;"
                
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
                    If dgv.Columns.Contains("UnitPrice") Then dgv.Columns("UnitPrice").DefaultCellStyle.Format = "C2"
                    If dgv.Columns.Contains("LineTotal") Then dgv.Columns("LineTotal").DefaultCellStyle.Format = "C2"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading sales report: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
