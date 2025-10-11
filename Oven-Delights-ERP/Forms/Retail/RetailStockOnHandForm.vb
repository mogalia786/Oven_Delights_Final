Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms
Imports Oven_Delights_ERP.UI

Namespace Retail
    Public Class RetailStockOnHandForm
        Inherits Form

        Private ReadOnly dgv As New DataGridView()
        Private ReadOnly txtSearch As New TextBox()
        Private ReadOnly lbl As New Label()
        Private ReadOnly btnClose As New Button()
        Private ReadOnly btnPrintExport As New Button()
        Private ReadOnly _connString As String
        Private ReadOnly _isSuperAdmin As Boolean
        Private ReadOnly _sessionBranchId As Integer

        Public Sub New()
            Me.Text = "Retail - Stock on Hand"
            Me.Name = "RetailStockOnHandForm"
            Me.StartPosition = FormStartPosition.CenterParent
            Me.Size = New Size(1000, 650)
            
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            If String.IsNullOrWhiteSpace(_connString) Then
                MessageBox.Show("Missing connection string 'OvenDelightsERPConnectionString' in App.config.", "Config Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
            _isSuperAdmin = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
            _sessionBranchId = If(AppSession.CurrentUser IsNot Nothing AndAlso AppSession.CurrentUser.BranchID.HasValue, AppSession.CurrentUser.BranchID.Value, 0)

            lbl.Text = "Stock on Hand (Retail Location)"
            lbl.Font = New Font("Segoe UI", 14, FontStyle.Bold)
            lbl.AutoSize = True
            lbl.Location = New Point(20, 15)

            txtSearch.PlaceholderText = "Search by Product..."
            txtSearch.Location = New Point(22, 55)
            txtSearch.Width = 320
            AddHandler txtSearch.TextChanged, AddressOf OnSearchChanged

            btnClose.Text = "Close"
            btnClose.Location = New Point(880, 15)
            AddHandler btnClose.Click, Sub() Me.Close()

            btnPrintExport.Text = "Print / Export"
            btnPrintExport.AutoSize = True
            btnPrintExport.Anchor = AnchorStyles.Top Or AnchorStyles.Right
            btnPrintExport.Location = New Point(760, 15)
            AddHandler btnPrintExport.Click, AddressOf OnPrintExport

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
            Controls.Add(btnPrintExport)
            Controls.Add(dgv)

            ' Replace text search with product dropdown (filters by Name; sets SKU under the hood)
            Try
                txtSearch.Visible = False
                Dim cbo = ProductDropdown.Create(Me, txtSearch)
                If cbo IsNot Nothing Then
                    AddHandler cbo.SelectedValueChanged, Sub()
                                                         Try
                                                             Dim sku = TryCast(cbo.SelectedValue, String)
                                                             If sku Is Nothing Then sku = String.Empty
                                                             txtSearch.Text = sku
                                                             LoadData()
                                                         Catch
                                                         End Try
                                                     End Sub
                    ' Position where the text box was
                    cbo.Left = 22
                    cbo.Top = 55
                End If
            Catch
            End Try

            LoadData()
        End Sub

        Private Sub OnSearchChanged(sender As Object, e As EventArgs)
            LoadData()
        End Sub

        Private Sub LoadData()
            dgv.Rows.Clear()
            Try
                If String.IsNullOrWhiteSpace(_connString) Then Return
                Using cn As New SqlConnection(_connString)
                    cn.Open()
                    Dim sql As String = ""
                    
                    ' Query Retail_Stock with proper joins
                    sql = "SELECT p.ProductID, p.ProductCode, p.ProductName, " &
                          "ISNULL(rs.QtyOnHand, 0) AS OnHand, " &
                          "ISNULL(c.CategoryName, 'Uncategorized') AS Category, " &
                          "CAST(GETDATE() AS DATE) AS LastMovement " &
                          "FROM Products p " &
                          "LEFT JOIN Retail_Variant rv ON rv.ProductID = p.ProductID " &
                          "LEFT JOIN Retail_Stock rs ON rs.VariantID = rv.VariantID AND rs.BranchID = @branchId " &
                          "LEFT JOIN Categories c ON c.CategoryID = p.CategoryID " &
                          "WHERE p.IsActive = 1 " &
                          "AND (@sku IS NULL OR @sku = '' OR p.ProductCode LIKE '%' + @sku + '%' OR p.ProductName LIKE '%' + @sku + '%') " &
                          "ORDER BY p.ProductName"

                    Using cmd As New SqlCommand(sql, cn)
                        Dim searchText = txtSearch.Text.Trim()
                        cmd.Parameters.AddWithValue("@branchId", _sessionBranchId)
                        cmd.Parameters.AddWithValue("@sku", If(String.IsNullOrWhiteSpace(searchText), DBNull.Value, CObj(searchText)))
                        
                        Using rdr = cmd.ExecuteReader()
                            While rdr.Read()
                                dgv.Rows.Add(New Object() {
                                    rdr("ProductID"),
                                    rdr("ProductCode").ToString(),
                                    rdr("ProductName").ToString(),
                                    Convert.ToDecimal(If(IsDBNull(rdr("OnHand")), 0D, rdr("OnHand"))),
                                    rdr("Category").ToString(),
                                    If(IsDBNull(rdr("LastMovement")), "", Convert.ToDateTime(rdr("LastMovement")).ToString("yyyy-MM-dd"))
                                })
                            End While
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show(Me, ex.Message, "Stock on Hand", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnPrintExport(sender As Object, e As EventArgs)
            Try
                Dim html As String = BuildHtmlFromGrid("Retail - Stock on Hand")
                Dim ts As String = DateTime.Now.ToString("yyyyMMdd_HHmmss")
                Dim path As String = PdfService.SavePdfWithDocumentNumber($"SOH_{ts}", html)
                Process.Start(New ProcessStartInfo() With { .FileName = path, .UseShellExecute = True })
            Catch ex As Exception
                MessageBox.Show(Me, "Export failed: " & ex.Message, "Stock on Hand", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function BuildHtmlFromGrid(title As String) As String
            Dim sb As New System.Text.StringBuilder()
            sb.AppendLine("<!DOCTYPE html><html><head><meta charset='utf-8'>")
            sb.AppendLine("<style> body{font-family:Segoe UI,Arial,sans-serif;margin:24px;} h1{font-size:20px;margin:0 0 8px;} table{width:100%;border-collapse:collapse;} th,td{border:1px solid #ddd;padding:6px;text-align:left;} th{background:#f6f6f6;} </style>")
            sb.AppendLine("</head><body>")
            sb.AppendLine($"<h1>{title}</h1>")
            sb.AppendLine($"<div>Generated: {DateTime.Now:yyyy-MM-dd HH:mm}</div>")
            sb.AppendLine("<table><thead><tr>")
            For Each col As DataGridViewColumn In dgv.Columns
                If col.Visible Then
                    sb.Append("<th>").Append(System.Web.HttpUtility.HtmlEncode(col.HeaderText)).Append("</th>")
                End If
            Next
            sb.AppendLine("</tr></thead><tbody>")
            For Each row As DataGridViewRow In dgv.Rows
                If row.IsNewRow Then Continue For
                sb.Append("<tr>")
                For Each col As DataGridViewColumn In dgv.Columns
                    If Not col.Visible Then Continue For
                    Dim val = row.Cells(col.Index).Value
                    Dim cellText As String = If(val Is Nothing, "", val.ToString())
                    sb.Append("<td>").Append(System.Web.HttpUtility.HtmlEncode(cellText)).Append("</td>")
                Next
                sb.AppendLine("</tr>")
            Next
            sb.AppendLine("</tbody></table></body></html>")
            Return sb.ToString()
        End Function

    End Class
End Namespace
