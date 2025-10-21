Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Partial Class POReceivingForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _isSuperAdmin As Boolean
    Private ReadOnly _sessionBranchId As Integer
    Private WithEvents cboProduct As ComboBox

    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrWhiteSpace(_connString) Then
            MessageBox.Show("Missing connection string 'OvenDelightsERPConnectionString' in App.config.", "Config Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
        _isSuperAdmin = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        _sessionBranchId = If(AppSession.CurrentUser IsNot Nothing AndAlso AppSession.CurrentUser.BranchID.HasValue, AppSession.CurrentUser.BranchID.Value, 0)
        
        ' Create and setup product dropdown
        If txtSKU IsNot Nothing Then
            ' Load products using ProductDropdown helper
            Try
                cboProduct = UI.ProductDropdown.Create(Me, txtSKU)
            Catch
            End Try
        End If
        
        LoadBranches()
        AddHandler btnReceive.Click, AddressOf btnReceive_Click
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
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading branches: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnReceive_Click(sender As Object, e As EventArgs)
        ' Basic validation
        ' Use product dropdown instead of SKU text field
        Dim selectedProduct = TryCast(cboProduct.SelectedItem, DataRowView)
        If selectedProduct Is Nothing Then
            MessageBox.Show("Please select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If numQty.Value <= 0D Then
            MessageBox.Show("Quantity must be greater than zero.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using tx = conn.BeginTransaction()
                    Try
                        ' 1) Get ProductID from selected dropdown item
                        Dim productId As Integer = Convert.ToInt32(selectedProduct("ProductID"))

                        ' 2) Ensure Variant exists
                        Dim variantId As Integer
                        Try
                            Using cmdVar As New SqlCommand("EXEC dbo.sp_Retail_EnsureVariant @ProductID=@pid, @Barcode=NULL, @VariantID=@vid OUTPUT; SELECT @vid;", conn, tx)
                                cmdVar.Parameters.AddWithValue("@pid", productId)
                                Dim pOut As New SqlParameter("@vid", SqlDbType.Int)
                                pOut.Direction = ParameterDirection.Output
                                cmdVar.Parameters.Add(pOut)
                                variantId = Convert.ToInt32(cmdVar.ExecuteScalar())
                            End Using
                        Catch
                            Using cmdInsVar As New SqlCommand("INSERT INTO dbo.Retail_Variant(ProductID, Barcode) VALUES(@pid, NULL); SELECT CAST(SCOPE_IDENTITY() AS INT);", conn, tx)
                                cmdInsVar.Parameters.AddWithValue("@pid", productId)
                                variantId = Convert.ToInt32(cmdInsVar.ExecuteScalar())
                            End Using
                        End Try

                        ' 3) Post movement and update stock
                        Dim branchParam As Object = GetBranchParam()
                        Dim supplier As String = txtSupplier.Text.Trim()
                        Dim inv As String = txtSupplierInv.Text.Trim()
                        Dim batch As String = txtBatch.Text.Trim()
                        Dim expiry As String = If(dtpExpiry.Checked, dtpExpiry.Value.ToString("yyyy-MM-dd"), String.Empty)
                        Dim notes As String = txtNotes.Text.Trim()
                        Dim details As String = $"PO Receipt|Supplier={supplier}|Inv={inv}|Batch={batch}|Expiry={expiry}|UnitCost={numUnitCost.Value}|Notes={notes}"

                        Using cmdMov As New SqlCommand("INSERT INTO dbo.Retail_StockMovements(VariantID, BranchID, QtyDelta, Reason, CreatedAt) VALUES(@vid, @bid, @qty, @rsn, GETDATE())", conn, tx)
                            cmdMov.Parameters.AddWithValue("@vid", variantId)
                            cmdMov.Parameters.AddWithValue("@bid", branchParam)
                            cmdMov.Parameters.AddWithValue("@qty", CDec(numQty.Value))
                            cmdMov.Parameters.AddWithValue("@rsn", details)
                            cmdMov.ExecuteNonQuery()
                        End Using

                        Using upd As New SqlCommand("UPDATE s SET s.QtyOnHand = ISNULL(s.QtyOnHand,0) + @qty FROM dbo.Retail_Stock s WHERE s.VariantID = @vid AND ((@bid IS NULL AND s.BranchID IS NULL) OR s.BranchID = @bid); IF @@ROWCOUNT = 0 INSERT INTO dbo.Retail_Stock(VariantID, BranchID, QtyOnHand, ReorderPoint, Location) VALUES(@vid, @bid, @qty, 0, NULL);", conn, tx)
                            upd.Parameters.AddWithValue("@vid", variantId)
                            upd.Parameters.AddWithValue("@bid", branchParam)
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
            MessageBox.Show("PO receipt posted to Retail stock.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Error receiving PO to Retail: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
