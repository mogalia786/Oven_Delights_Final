Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Partial Class ProductCatalogReportForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _isSuperAdmin As Boolean
    Private ReadOnly _sessionBranchId As Integer
    Private ReadOnly _btnOpenCrystal As New Button()
    Private ReadOnly _btnPrintExport As New Button()

    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrWhiteSpace(_connString) Then
            MessageBox.Show("Missing connection string 'OvenDelightsERPConnectionString' in App.config.", "Config Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
        _isSuperAdmin = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        _sessionBranchId = If(AppSession.CurrentUser IsNot Nothing AndAlso AppSession.CurrentUser.BranchID.HasValue, AppSession.CurrentUser.BranchID.Value, 0)
        AddHandler Me.Shown, AddressOf ProductCatalogReportForm_Shown
        ' Add "Open in Crystal" button at runtime
        Try
            _btnOpenCrystal.Text = "Open in Crystal"
            _btnOpenCrystal.AutoSize = True
            _btnOpenCrystal.Anchor = AnchorStyles.Top Or AnchorStyles.Right
            _btnOpenCrystal.Top = 8
            _btnOpenCrystal.Left = Math.Max(8, Me.ClientSize.Width - 150)
            AddHandler Me.Resize, Sub()
                                      _btnOpenCrystal.Left = Math.Max(8, Me.ClientSize.Width - 150)
                                  End Sub
            AddHandler _btnOpenCrystal.Click, AddressOf OnOpenInCrystal
            Me.Controls.Add(_btnOpenCrystal)
            _btnOpenCrystal.BringToFront()
        Catch
        End Try
        ' Add Print/Export (non-Crystal) button at runtime
        Try
            _btnPrintExport.Text = "Print / Export"
            _btnPrintExport.AutoSize = True
            _btnPrintExport.Anchor = AnchorStyles.Top Or AnchorStyles.Right
            _btnPrintExport.Top = 8
            _btnPrintExport.Left = Math.Max(8, Me.ClientSize.Width - 290)
            AddHandler Me.Resize, Sub()
                                      _btnPrintExport.Left = Math.Max(8, Me.ClientSize.Width - 290)
                                  End Sub
            AddHandler _btnPrintExport.Click, AddressOf OnPrintExport
            Me.Controls.Add(_btnPrintExport)
            _btnPrintExport.BringToFront()
        Catch
        End Try
    End Sub

    Private Sub ProductCatalogReportForm_Shown(sender As Object, e As EventArgs)
        LoadReport()
    End Sub

    Private Sub LoadReport()
        Try
            Using conn As New SqlConnection(_connString)
                ' Branch-aware product catalog query
                Dim sql As String
                If _isSuperAdmin Then
                    ' Super Admin sees all products from all branches
                    sql = "SELECT p.ProductID, p.SKU, p.Name, p.Category, p.Description, " &
                          "ISNULL(pr.SellingPrice, 0) AS UnitPrice, " &
                          "ISNULL(s.QtyOnHand, 0) AS QtyOnHand, " &
                          "ISNULL(b.BranchName, 'Global') AS BranchName " &
                          "FROM dbo.Retail_Product p " &
                          "LEFT JOIN dbo.Retail_Variant v ON v.ProductID = p.ProductID " &
                          "LEFT JOIN dbo.Retail_Stock s ON s.VariantID = v.VariantID " &
                          "LEFT JOIN dbo.Branches b ON b.BranchID = s.BranchID " &
                          "LEFT JOIN dbo.Retail_Price pr ON pr.ProductID = p.ProductID AND (pr.BranchID = s.BranchID OR (pr.BranchID IS NULL AND s.BranchID IS NULL)) " &
                          "AND (pr.EffectiveTo IS NULL OR pr.EffectiveTo > GETDATE()) " &
                          "WHERE p.IsActive = 1 " &
                          "ORDER BY p.Name, b.BranchName"
                Else
                    ' Regular users see only their branch products
                    sql = "SELECT p.ProductID, p.SKU, p.Name, p.Category, p.Description, " &
                          "ISNULL(pr.SellingPrice, 0) AS UnitPrice, " &
                          "ISNULL(s.QtyOnHand, 0) AS QtyOnHand " &
                          "FROM dbo.Retail_Product p " &
                          "LEFT JOIN dbo.Retail_Variant v ON v.ProductID = p.ProductID " &
                          "LEFT JOIN dbo.Retail_Stock s ON s.VariantID = v.VariantID AND (s.BranchID = @branchId OR (@branchId = 0 AND s.BranchID IS NULL)) " &
                          "LEFT JOIN dbo.Retail_Price pr ON pr.ProductID = p.ProductID AND (pr.BranchID = @branchId OR (@branchId = 0 AND pr.BranchID IS NULL)) " &
                          "AND (pr.EffectiveTo IS NULL OR pr.EffectiveTo > GETDATE()) " &
                          "WHERE p.IsActive = 1 " &
                          "ORDER BY p.Name"
                End If
                
                Using da As New SqlDataAdapter(sql, conn)
                    If Not _isSuperAdmin Then
                        da.SelectCommand.Parameters.AddWithValue("@branchId", _sessionBranchId)
                    End If
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgv.DataSource = dt
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading product catalog: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnOpenInCrystal(sender As Object, e As EventArgs)
        Try
            Using frm As New ProductCatalogCrystalReportForm()
                frm.ShowDialog(Me)
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to open Crystal viewer: " & ex.Message, "Product Catalog", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnPrintExport(sender As Object, e As EventArgs)
        Try
            Dim html As String = BuildHtmlFromGrid("Product Catalog Report")
            Dim ts As String = DateTime.Now.ToString("yyyyMMdd_HHmmss")
            Dim path As String = PdfService.SavePdfWithDocumentNumber($"PRODCAT_{ts}", html)
            Process.Start(New ProcessStartInfo() With { .FileName = path, .UseShellExecute = True })
        Catch ex As Exception
            MessageBox.Show("Failed to export: " & ex.Message, "Product Catalog", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function BuildHtmlFromGrid(title As String) As String
        Dim sb As New Text.StringBuilder()
        sb.AppendLine("<!DOCTYPE html><html><head><meta charset='utf-8'>")
        sb.AppendLine("<style> body{font-family:Segoe UI,Arial,sans-serif;margin:24px;} h1{font-size:20px;margin:0 0 8px;} table{width:100%;border-collapse:collapse;} th,td{border:1px solid #ddd;padding:6px;text-align:left;} th{background:#f6f6f6;} </style>")
        sb.AppendLine("</head><body>")
        sb.AppendLine($"<h1>{title}</h1>")
        sb.AppendLine($"<div>Generated: {DateTime.Now:yyyy-MM-dd HH:mm}</div>")
        sb.AppendLine("<table><thead><tr>")
        For Each col As DataGridViewColumn In dgv.Columns
            sb.Append("<th>").Append(System.Web.HttpUtility.HtmlEncode(col.HeaderText)).Append("</th>")
        Next
        sb.AppendLine("</tr></thead><tbody>")
        For Each row As DataGridViewRow In dgv.Rows
            If row.IsNewRow Then Continue For
            sb.Append("<tr>")
            For Each col As DataGridViewColumn In dgv.Columns
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
