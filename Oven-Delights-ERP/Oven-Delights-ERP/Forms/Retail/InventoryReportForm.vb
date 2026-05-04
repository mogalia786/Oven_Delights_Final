Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports Oven_Delights_ERP.UI

Public Class InventoryReportForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _isSuperAdmin As Boolean
    Private ReadOnly _sessionBranchId As Integer

    ' Controls
    Private pnlFilters As Panel
    Private lblBranch As Label
    Private cboBranch As ComboBox
    Private lblCategory As Label
    Private cboCategory As ComboBox
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
        LoadCategories()
        AddHandler btnLoad.Click, AddressOf btnLoad_Click
        AddHandler Me.Shown, AddressOf InventoryReportForm_Shown
        
        ' Hide branch selector for non-super admin
        If Not _isSuperAdmin Then
            If lblBranch IsNot Nothing Then lblBranch.Visible = False
            If cboBranch IsNot Nothing Then cboBranch.Visible = False
        End If
        
        Theme.Apply(Me)
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Inventory Report"
        Me.Size = New Size(1200, 700)
        Me.StartPosition = FormStartPosition.CenterParent
        
        ' Filters panel
        pnlFilters = New Panel() With {.Dock = DockStyle.Top, .Height = 60, .Padding = New Padding(8)}
        lblBranch = New Label() With {.Text = "Branch:", .AutoSize = True, .Left = 8, .Top = 16}
        cboBranch = New ComboBox() With {.Left = 60, .Top = 12, .Width = 200, .DropDownStyle = ComboBoxStyle.DropDownList}
        lblCategory = New Label() With {.Text = "Category:", .AutoSize = True, .Left = 280, .Top = 16}
        cboCategory = New ComboBox() With {.Left = 340, .Top = 12, .Width = 200, .DropDownStyle = ComboBoxStyle.DropDownList}
        btnLoad = New Button() With {.Left = 560, .Top = 12, .Width = 100, .Text = "Load Report"}
        
        pnlFilters.Controls.AddRange({lblBranch, cboBranch, lblCategory, cboCategory, btnLoad})
        
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

    Private Sub LoadCategories()
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim sql As String = "SELECT DISTINCT ISNULL(Category, 'General') AS Category FROM Demo_Retail_Product WHERE IsActive = 1 ORDER BY Category"
                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    ' Add "All Categories" option
                    Dim allRow = dt.NewRow()
                    allRow("Category") = "All Categories"
                    dt.Rows.InsertAt(allRow, 0)
                    cboCategory.DataSource = dt
                    cboCategory.DisplayMember = "Category"
                    cboCategory.ValueMember = "Category"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading categories: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub InventoryReportForm_Shown(sender As Object, e As EventArgs)
        LoadReport()
    End Sub

    Private Sub btnLoad_Click(sender As Object, e As EventArgs)
        LoadReport()
    End Sub

    Private Sub LoadReport()
        Try
            Using conn As New SqlConnection(_connString)
                ' Query Demo_Retail_Product table (where invoice capture updates stock)
                Dim sql As String = "SELECT p.ProductID, ISNULL(p.SKU, p.Code) AS SKU, p.Name AS ProductName, " & _
                                    "ISNULL(p.Category, 'General') AS Category, " & _
                                    "ISNULL(p.CurrentStock, 0) AS QtyOnHand, " & _
                                    "ISNULL(pr.CostPrice, 0) AS UnitPrice, " & _
                                    "(ISNULL(p.CurrentStock, 0) * ISNULL(pr.CostPrice, 0)) AS TotalValue, " & _
                                    "0 AS ReorderPoint, " & _
                                    "'' AS Location, " & _
                                    "ISNULL(b.BranchName, 'Unknown') AS BranchName, " & _
                                    "p.BranchID AS ActualBranchID " & _
                                    "FROM dbo.Demo_Retail_Product p " & _
                                    "LEFT JOIN dbo.Demo_Retail_Price pr ON pr.ProductID = p.ProductID AND pr.BranchID = p.BranchID " & _
                                    "LEFT JOIN dbo.Branches b ON b.BranchID = p.BranchID " & _
                                    "WHERE p.IsActive = 1 " & _
                                    "AND (@bid IS NULL OR p.BranchID = @bid) " & _
                                    "AND (@cat = 'All Categories' OR ISNULL(p.Category, 'General') = @cat) " & _
                                    "ORDER BY p.Name, p.BranchID"
                
                Using da As New SqlDataAdapter(sql, conn)
                    Dim bid As Object = GetBranchParam()
                    Dim cat As String = If(cboCategory.SelectedValue?.ToString(), "All Categories")
                    
                    ' DEBUG: Show what BranchID is being used
                    MessageBox.Show($"DEBUG: _sessionBranchId={_sessionBranchId}, _isSuperAdmin={_isSuperAdmin}, BranchParam={If(TypeOf bid Is DBNull, "NULL", bid.ToString())}", "Branch Debug", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    
                    da.SelectCommand.Parameters.AddWithValue("@bid", bid)
                    da.SelectCommand.Parameters.AddWithValue("@cat", cat)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgv.DataSource = dt
                    
                    ' Format columns
                    If dgv.Columns.Contains("QtyOnHand") Then dgv.Columns("QtyOnHand").DefaultCellStyle.Format = "N2"
                    If dgv.Columns.Contains("UnitPrice") Then dgv.Columns("UnitPrice").DefaultCellStyle.Format = "C2"
                    If dgv.Columns.Contains("TotalValue") Then dgv.Columns("TotalValue").DefaultCellStyle.Format = "C2"
                    If dgv.Columns.Contains("ReorderPoint") Then dgv.Columns("ReorderPoint").DefaultCellStyle.Format = "N0"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading inventory report: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
