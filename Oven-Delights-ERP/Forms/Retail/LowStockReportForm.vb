Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Partial Class LowStockReportForm
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
        LoadBranches()
        ' Hide branch selector for non-super admin
        If Not _isSuperAdmin Then
            If lblBranch IsNot Nothing Then lblBranch.Visible = False
            If cboBranch IsNot Nothing Then cboBranch.Visible = False
        End If
        ' Create "Open in Crystal" button at runtime
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
        ' Create Print/Export button at runtime (non-Crystal fallback)
        Try
            _btnPrintExport.Text = "Print / Export"
            _btnPrintExport.AutoSize = True
            _btnPrintExport.Anchor = AnchorStyles.Top Or AnchorStyles.Right
            _btnPrintExport.Top = 8
            _btnPrintExport.Left = Math.Max(8, Me.ClientSize.Width - 280)
            AddHandler Me.Resize, Sub()
                                      _btnPrintExport.Left = Math.Max(8, Me.ClientSize.Width - 280)
                                  End Sub
            AddHandler _btnPrintExport.Click, AddressOf OnPrintExport
            Me.Controls.Add(_btnPrintExport)
            _btnPrintExport.BringToFront()
        Catch
        End Try
        AddHandler Me.Shown, AddressOf LowStockReportForm_Shown
    End Sub

    Private Sub LowStockReportForm_Shown(sender As Object, e As EventArgs)
        LoadReport()
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

    Private Sub LoadReport()
        Try
            Using conn As New SqlConnection(_connString)
                ' Branch-aware low stock query
                Dim sql As String
                If _isSuperAdmin Then
                    ' Super Admin sees low stock from all branches - MUST show branch-specific stock
                    sql = "SELECT p.ProductID, p.SKU, p.ProductName AS Name, " &
                          "s.QtyOnHand, " &
                          "s.ReorderPoint, " &
                          "ISNULL(b.BranchName, 'No Branch') AS BranchName, " &
                          "s.BranchID " &
                          "FROM dbo.Retail_Stock s " &
                          "INNER JOIN dbo.Retail_Variant v ON s.VariantID = v.VariantID " &
                          "INNER JOIN dbo.Products p ON v.ProductID = p.ProductID " &
                          "LEFT JOIN dbo.Branches b ON s.BranchID = b.BranchID " &
                          "WHERE p.IsActive = 1 " &
                          "AND s.QtyOnHand <= s.ReorderPoint " &
                          "AND s.ReorderPoint > 0 " &
                          "ORDER BY b.BranchName, s.QtyOnHand ASC"
                Else
                    ' Branch user sees only their branch's low stock
                    sql = "SELECT p.ProductID, p.SKU, p.ProductName AS Name, " &
                          "s.QtyOnHand, " &
                          "s.ReorderPoint " &
                          "FROM dbo.Retail_Stock s " &
                          "INNER JOIN dbo.Retail_Variant v ON s.VariantID = v.VariantID " &
                          "INNER JOIN dbo.Products p ON v.ProductID = p.ProductID " &
                          "WHERE p.IsActive = 1 " &
                          "AND s.BranchID = @branchId " &
                          "AND s.QtyOnHand <= s.ReorderPoint " &
                          "AND s.ReorderPoint > 0 " &
                          "ORDER BY s.QtyOnHand ASC"
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
            MessageBox.Show("Error loading low stock report: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
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

    Private Function GetSelectedBranchId() As Integer
        If _isSuperAdmin Then
            Dim v = If(cboBranch IsNot Nothing, cboBranch.SelectedValue, Nothing)
            If v Is Nothing OrElse TypeOf v Is DBNull Then Return 0
            Return Convert.ToInt32(v)
        End If
        Return _sessionBranchId
    End Function

    Private Sub OnOpenInCrystal(sender As Object, e As EventArgs)
        Try
            Dim bid As Integer = GetSelectedBranchId()
            Using frm As New LowStockCrystalReportForm()
                frm.LoadFromData(bid)
                frm.ShowDialog(Me)
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to open Crystal viewer: " & ex.Message, "Low Stock", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnPrintExport(sender As Object, e As EventArgs)
        Try
            Dim html As String = BuildHtmlFromGrid("Low Stock Report")
            Dim ts As String = DateTime.Now.ToString("yyyyMMdd_HHmmss")
            Dim path As String = PdfService.SavePdfWithDocumentNumber($"LOWSTOCK_{ts}", html)
            Process.Start(New ProcessStartInfo() With { .FileName = path, .UseShellExecute = True })
        Catch ex As Exception
            MessageBox.Show("Failed to export: " & ex.Message, "Low Stock", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
