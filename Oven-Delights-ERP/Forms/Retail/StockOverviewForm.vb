Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Partial Class StockOverviewForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _isSuperAdmin As Boolean
    Private ReadOnly _sessionBranchId As Integer

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
        AddHandler btnAdjust.Click, AddressOf btnAdjust_Click
        ' Hide branch selector for non-super admin
        If Not _isSuperAdmin Then
            If lblBranch IsNot Nothing Then lblBranch.Visible = False
            If cboBranch IsNot Nothing Then cboBranch.Visible = False
        End If
    End Sub

    Private Sub LoadBranches()
        Try
            If String.IsNullOrWhiteSpace(_connString) Then Return
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim hasBranches As Boolean
                Using cmd As New SqlCommand("SELECT COUNT(1) FROM sys.tables WHERE name='Branches'", conn)
                    hasBranches = CInt(cmd.ExecuteScalar()) > 0
                End Using
                If hasBranches Then
                    Using da As New SqlDataAdapter("SELECT BranchID, BranchName FROM dbo.Branches ORDER BY BranchName", conn)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        If _isSuperAdmin Then
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
                Else
                    Dim dt As New DataTable()
                    dt.Columns.Add("BranchID", GetType(Integer))
                    dt.Columns.Add("BranchName", GetType(String))
                    Dim row = dt.NewRow()
                    row("BranchID") = DBNull.Value
                    row("BranchName") = "(No Branch / Global)"
                    dt.Rows.Add(row)
                    cboBranch.DataSource = dt
                    cboBranch.DisplayMember = "BranchName"
                    cboBranch.ValueMember = "BranchID"
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading branches: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnLoad_Click(sender As Object, e As EventArgs)
        LoadStock()
    End Sub

    Private Sub LoadStock()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql As String = "SELECT * FROM dbo.v_Retail_StockOnHand WHERE (@bid IS NULL OR BranchID = @bid) AND (@sku IS NULL OR SKU = @sku) ORDER BY Name"
                Using da As New SqlDataAdapter(sql, conn)
                    Dim bid As Object = GetBranchParam()
                    da.SelectCommand.Parameters.AddWithValue("@bid", bid)
                    Dim sku As Object = If(String.IsNullOrWhiteSpace(txtSKU.Text), DBNull.Value, txtSKU.Text.Trim())
                    da.SelectCommand.Parameters.AddWithValue("@sku", sku)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvStock.DataSource = dt
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading stock: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnAdjust_Click(sender As Object, e As EventArgs)
        If dgvStock.DataSource Is Nothing OrElse dgvStock.CurrentRow Is Nothing Then
            MessageBox.Show("Select a row first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If numQty.Value = 0D Then
            MessageBox.Show("Enter a non-zero quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        Dim drv = TryCast(dgvStock.CurrentRow.DataBoundItem, DataRowView)
        If drv Is Nothing Then Return
        Dim variantId As Integer = 0
        Dim branchId As Object = GetBranchParam()
        If drv.Row.Table.Columns.Contains("VariantID") AndAlso Not IsDBNull(drv("VariantID")) Then
            variantId = Convert.ToInt32(drv("VariantID"))
        Else
            MessageBox.Show("VariantID not available in the selected row.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return
        End If
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using tx = conn.BeginTransaction()
                    Try
                        ' 1) Insert stock movement
                        Using cmd As New SqlCommand("INSERT INTO dbo.Retail_StockMovements(VariantID, BranchID, QtyDelta, Reason, CreatedAt) VALUES(@vid, @bid, @qty, @rsn, GETDATE())", conn, tx)
                            cmd.Parameters.AddWithValue("@vid", variantId)
                            cmd.Parameters.AddWithValue("@bid", branchId)
                            cmd.Parameters.AddWithValue("@qty", CDec(numQty.Value))
                            cmd.Parameters.AddWithValue("@rsn", If(String.IsNullOrWhiteSpace(txtReason.Text), CType(DBNull.Value, Object), txtReason.Text.Trim()))
                            cmd.ExecuteNonQuery()
                        End Using
                        ' 2) Update stock on hand for branch/variant
                        Using upd As New SqlCommand("UPDATE s SET s.QtyOnHand = ISNULL(s.QtyOnHand,0) + @qty FROM dbo.Retail_Stock s WHERE s.VariantID = @vid AND ((@bid IS NULL AND s.BranchID IS NULL) OR s.BranchID = @bid); IF @@ROWCOUNT = 0 INSERT INTO dbo.Retail_Stock(VariantID, BranchID, QtyOnHand, ReorderPoint, Location) VALUES(@vid, @bid, @qty, 0, NULL);", conn, tx)
                            upd.Parameters.AddWithValue("@vid", variantId)
                            upd.Parameters.AddWithValue("@bid", branchId)
                            upd.Parameters.AddWithValue("@qty", CDec(numQty.Value))
                            upd.ExecuteNonQuery()
                        End Using
                        tx.Commit()
                    Catch
                        tx.Rollback()
                        Throw
                    End Try
                End Using
            End Using
            LoadStock()
            MessageBox.Show("Adjustment applied.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Error applying adjustment: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function GetBranchParam() As Object
        If _isSuperAdmin Then
            Dim v = If(cboBranch IsNot Nothing, cboBranch.SelectedValue, Nothing)
            Return If(v Is Nothing, DBNull.Value, v)
        End If
        If _sessionBranchId <= 0 Then Return DBNull.Value
        Return _sessionBranchId
    End Function
End Class
