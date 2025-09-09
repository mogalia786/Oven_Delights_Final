Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

Namespace Retail
    Public Class RetailStockOnHandForm
        Inherits Form

        Private ReadOnly dgv As New DataGridView()
        Private ReadOnly txtSearch As New TextBox()
        Private ReadOnly lbl As New Label()
        Private ReadOnly btnClose As New Button()

        Public Sub New()
            Me.Text = "Retail - Stock on Hand"
            Me.Name = "RetailStockOnHandForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.Size = New Size(1000, 650)

            lbl.Text = "Stock on Hand (Retail Location)"
            lbl.Font = New Font("Segoe UI", 14, FontStyle.Bold)
            lbl.AutoSize = True
            lbl.Location = New Point(20, 15)

            txtSearch.PlaceholderText = "Search by SKU or Name..."
            txtSearch.Location = New Point(22, 55)
            txtSearch.Width = 320
            AddHandler txtSearch.TextChanged, AddressOf OnSearchChanged

            btnClose.Text = "Close"
            btnClose.Location = New Point(880, 15)
            AddHandler btnClose.Click, Sub() Me.Close()

            dgv.Location = New Point(20, 95)
            dgv.Size = New Size(940, 500)
            dgv.ReadOnly = True
            dgv.AllowUserToAddRows = False
            dgv.AllowUserToDeleteRows = False
            dgv.SelectionMode = DataGridViewSelectionMode.FullRowSelect
            dgv.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill

            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductID", .HeaderText = "ProductID", .Visible = False})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "SKU", .HeaderText = "SKU", .FillWeight = 20})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "ProductName", .HeaderText = "Product Name", .FillWeight = 45})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "OnHand", .HeaderText = "On Hand", .FillWeight = 15})
            dgv.Columns.Add(New DataGridViewTextBoxColumn() With {.Name = "LastMovement", .HeaderText = "Last Movement", .FillWeight = 20})

            Controls.Add(lbl)
            Controls.Add(txtSearch)
            Controls.Add(btnClose)
            Controls.Add(dgv)

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
                    Dim sql As String = ""
                    sql &= "DECLARE @BranchID INT = @pBranchID;" & vbCrLf
                    sql &= "DECLARE @RetailLoc INT = dbo.fn_GetLocationId(@BranchID, N'RETAIL');" & vbCrLf
                    sql &= "IF @RetailLoc IS NULL SET @RetailLoc = dbo.fn_GetLocationId(NULL, N'RETAIL');" & vbCrLf
                    sql &= "IF @RetailLoc IS NULL SET @RetailLoc = 0;" & vbCrLf
                    sql &= "WITH LastMove AS (" & vbCrLf
                    sql &= "  SELECT pm.ProductID, MAX(pm.ProductMovementID) AS LastMovementID" & vbCrLf
                    sql &= "  FROM dbo.ProductMovements pm" & vbCrLf
                    sql &= "  WHERE pm.ToLocationID = @RetailLoc" & vbCrLf
                    sql &= "    AND pm.BranchID = @BranchID" & vbCrLf
                    sql &= "  GROUP BY pm.ProductID" & vbCrLf
                    sql &= ")" & vbCrLf
                    sql &= "SELECT p.ProductID, p.ProductCode AS SKU, p.ProductName, ISNULL(pi.QuantityOnHand,0) AS OnHand, pm.MovementDate AS LastMovement" & vbCrLf
                    sql &= "FROM dbo.Products p" & vbCrLf
                    sql &= "LEFT JOIN dbo.ProductInventory pi ON pi.ProductID = p.ProductID AND pi.LocationID = @RetailLoc AND pi.BranchID = @BranchID" & vbCrLf
                    sql &= "LEFT JOIN LastMove lm ON lm.ProductID = p.ProductID" & vbCrLf
                    sql &= "LEFT JOIN dbo.ProductMovements pm ON pm.ProductMovementID = lm.LastMovementID" & vbCrLf
                    sql &= "WHERE (@pSearch = '' OR p.ProductCode LIKE '%' + @pSearch + '%' OR p.ProductName LIKE '%' + @pSearch + '%')" & vbCrLf
                    sql &= "ORDER BY p.ProductName;"

                    Using cmd As New SqlCommand(sql, cn)
                        Dim branchId As Integer = AppSession.CurrentBranchID
                        If branchId <= 0 Then Throw New ApplicationException("Branch is required.")
                        cmd.Parameters.AddWithValue("@pBranchID", branchId)
                        cmd.Parameters.AddWithValue("@pSearch", txtSearch.Text.Trim())
                        Using rdr = cmd.ExecuteReader()
                            While rdr.Read()
                                dgv.Rows.Add(New Object() {
                                    rdr("ProductID"),
                                    rdr("SKU").ToString(),
                                    rdr("ProductName").ToString(),
                                    Convert.ToDecimal(If(IsDBNull(rdr("OnHand")), 0D, rdr("OnHand"))),
                                    If(IsDBNull(rdr("LastMovement")), "", Convert.ToDateTime(rdr("LastMovement")).ToString("yyyy-MM-dd HH:mm"))
                                })
                            End While
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, ex.Message, "Stock on Hand", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

    End Class
End Namespace
