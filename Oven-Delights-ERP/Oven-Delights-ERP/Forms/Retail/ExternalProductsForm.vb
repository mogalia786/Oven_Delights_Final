Imports System
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Globalization
Imports System.Windows.Forms

Namespace Retail
    Public Class ExternalProductsForm
        Inherits Form

        Private ReadOnly dgv As New DataGridView()
        Private ReadOnly txtSearch As New TextBox()
        Private ReadOnly lblTitle As New Label()
        Private ReadOnly btnClose As New Button()
        Private ReadOnly lblSummary As New Label()

        Public Sub New()
            Me.Text = "Retail - External Products"
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.Size = New Size(1100, 700)
            Me.MinimumSize = New Size(900, 600)

            lblTitle.Text = "Retail - External Products (Purchased)"
            lblTitle.Font = New Font("Segoe UI", 16, FontStyle.Bold)
            lblTitle.AutoSize = True
            lblTitle.Location = New Point(20, 15)

            txtSearch.PlaceholderText = "Search by SKU or name..."
            txtSearch.Location = New Point(22, 60)
            txtSearch.Width = 320
            AddHandler txtSearch.TextChanged, AddressOf OnSearchChanged

            btnClose.Text = "Close"
            btnClose.Location = New Point(1000, 18)
            AddHandler btnClose.Click, Sub(sender, e) Me.Close()

            dgv.Location = New Point(20, 100)
            dgv.Size = New Size(1040, 520)
            dgv.ReadOnly = True
            dgv.AllowUserToAddRows = False
            dgv.AllowUserToDeleteRows = False
            dgv.SelectionMode = DataGridViewSelectionMode.FullRowSelect
            dgv.RowHeadersVisible = False
            dgv.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            dgv.EnableHeadersVisualStyles = False
            dgv.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(30, 30, 30)
            dgv.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgv.DefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Regular)

            Dim colPid As New DataGridViewTextBoxColumn()
            colPid.Name = "ProductID"
            colPid.HeaderText = "ProductID"
            colPid.Visible = False
            dgv.Columns.Add(colPid)

            dgv.Columns.Add("SKU", "SKU")
            dgv.Columns.Add("ProductName", "Product")
            dgv.Columns.Add("OnHand", "On Hand")
            Dim lastCol As New DataGridViewTextBoxColumn()
            lastCol.HeaderText = "Last Movement"
            lastCol.Name = "LastMovement"
            dgv.Columns.Add(lastCol)

            lblSummary.AutoSize = True
            lblSummary.Font = New Font("Segoe UI", 10, FontStyle.Italic)
            lblSummary.Location = New Point(22, 630)
            lblSummary.Text = ""

            Me.Controls.Add(lblTitle)
            Me.Controls.Add(txtSearch)
            Me.Controls.Add(btnClose)
            Me.Controls.Add(dgv)
            Me.Controls.Add(lblSummary)

            LoadData()
        End Sub

        Private Sub OnSearchChanged(sender As Object, e As EventArgs)
            LoadData()
        End Sub

        Private Sub LoadData()
            dgv.Rows.Clear()
            Try
                Dim cs As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
                Using cn As New SqlConnection(cs)
                    cn.Open()
                    Dim branchId As Integer = AppSession.CurrentBranchID
                    If branchId <= 0 Then
                        Throw New ApplicationException("Branch is required for Retail view.")
                    End If

                    Dim sql As String = ""
                    sql &= "DECLARE @BranchID INT = @pBranchID;" & vbCrLf
                    sql &= "DECLARE @RetailLoc INT = dbo.fn_GetLocationId(@BranchID, N'RETAIL');" & vbCrLf
                    sql &= "IF @RetailLoc IS NULL SET @RetailLoc = dbo.fn_GetLocationId(NULL, N'RETAIL');" & vbCrLf
                    sql &= "IF @RetailLoc IS NULL SET @RetailLoc = 0;" & vbCrLf
                    sql &= "WITH LastMove AS (" & vbCrLf
                    sql &= "  SELECT pm.ProductID, MAX(pm.ProductMovementID) AS LastMovementID" & vbCrLf
                    sql &= "  FROM dbo.ProductMovements pm" & vbCrLf
                    sql &= "  WHERE pm.ToLocationID = @RetailLoc AND pm.BranchID = @BranchID" & vbCrLf
                    sql &= "  GROUP BY pm.ProductID" & vbCrLf
                    sql &= ")" & vbCrLf
                    sql &= "SELECT TOP 1000" & vbCrLf
                    sql &= "    p.ProductID," & vbCrLf
                    sql &= "    p.ProductCode AS SKU," & vbCrLf
                    sql &= "    p.ProductName," & vbCrLf
                    sql &= "    ISNULL(SUM(rs.QtyOnHand), 0) AS OnHand," & vbCrLf
                    sql &= "    pm.MovementDate AS LastMovement" & vbCrLf
                    sql &= "FROM dbo.Products p" & vbCrLf
                    sql &= "LEFT JOIN dbo.Retail_Variant rv ON rv.ProductID = p.ProductID" & vbCrLf
                    sql &= "LEFT JOIN dbo.Retail_Stock rs ON rs.VariantID = rv.VariantID AND rs.BranchID = @BranchID" & vbCrLf
                    sql &= "LEFT JOIN LastMove lm ON lm.ProductID = p.ProductID" & vbCrLf
                    sql &= "LEFT JOIN dbo.ProductMovements pm ON pm.ProductMovementID = lm.LastMovementID" & vbCrLf
                    sql &= "WHERE p.IsActive = 1" & vbCrLf
                    ' External products: no ProductRecipe rows
                    sql &= "  AND NOT EXISTS (SELECT 1 FROM dbo.ProductRecipe r WHERE r.ProductID = p.ProductID)" & vbCrLf
                    sql &= "  AND (@pSearch = '' OR p.ProductCode LIKE '%' + @pSearch + '%' OR p.ProductName LIKE '%' + @pSearch + '%')" & vbCrLf
                    sql &= "GROUP BY p.ProductID, p.ProductCode, p.ProductName, pm.MovementDate, lm.LastMovementID" & vbCrLf
                    sql &= "ORDER BY p.ProductName;"

                    Using cmd As New SqlCommand(sql, cn)
                        cmd.Parameters.Add(New SqlParameter("@pBranchID", SqlDbType.Int) With {.Value = branchId})
                        cmd.Parameters.AddWithValue("@pSearch", If(txtSearch.Text, String.Empty))
                        Dim totalQty As Decimal = 0D
                        Dim rows As Integer = 0
                        Using rdr = cmd.ExecuteReader()
                            While rdr.Read()
                                Dim pid As Integer = Convert.ToInt32(rdr("ProductID"))
                                Dim sku As String = Convert.ToString(rdr("SKU"))
                                Dim name As String = Convert.ToString(rdr("ProductName"))
                                Dim onHand As Decimal = If(IsDBNull(rdr("OnHand")), 0D, Convert.ToDecimal(rdr("OnHand")))
                                Dim lastMove As String = If(rdr.IsDBNull(rdr.GetOrdinal("LastMovement")), "", Convert.ToDateTime(rdr("LastMovement")).ToLocalTime().ToString("yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture))
                                dgv.Rows.Add(New Object() {pid, sku, name, onHand, lastMove})
                                totalQty += onHand
                                rows += 1
                            End While
                        End Using
                        lblSummary.Text = $"Items: {rows}   Total Qty On Hand: {totalQty}"
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Failed to load external products: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
