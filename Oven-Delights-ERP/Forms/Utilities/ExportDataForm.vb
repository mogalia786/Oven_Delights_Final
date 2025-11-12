Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.IO

Public Class ExportDataForm
    Inherits Form

    Private ReadOnly _connStr As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private Const VAT_RATE As Decimal = 0.15D

    Protected Overrides Sub OnLoad(e As EventArgs)
        MyBase.OnLoad(e)
        Me.Text = "Export Data (CSV)"
        Me.Size = New Size(900, 600)
        Me.StartPosition = FormStartPosition.CenterParent
        BuildUi()
    End Sub

    Private Sub BuildUi()
        Dim pnl As New Panel()
        pnl.Dock = DockStyle.Fill
        pnl.Padding = New Padding(20)
        pnl.BackColor = Color.White

        Dim y As Integer = 10

        Dim lbl As New Label()
        lbl.Text = "Select branch to export. Files will be written as UTF-8 CSV."
        lbl.AutoSize = True
        lbl.Left = 0
        lbl.Top = y
        lbl.Font = New Font("Segoe UI", 10, FontStyle.Regular)
        y += 30

        Dim btnOD200 As New Button()
        btnOD200.Text = "Export OD200 - Ayesha Centre"
        btnOD200.Left = 0
        btnOD200.Top = y
        btnOD200.Width = 300
        btnOD200.Height = 36
        AddHandler btnOD200.Click, AddressOf OnExportOD200Click
        y += 46

        Dim btnOD400 As New Button()
        btnOD400.Text = "Export OD400 - Umhlanga"
        btnOD400.Left = 0
        btnOD400.Top = y
        btnOD400.Width = 300
        btnOD400.Height = 36
        AddHandler btnOD400.Click, AddressOf OnExportOD400Click
        y += 46

        Dim status As New Label()
        status.Name = "lblStatus"
        status.Text = "Ready. Click a branch to export product data with pricing and stock."
        status.AutoSize = True
        status.Left = 0
        status.Top = y + 10
        status.ForeColor = Color.FromArgb(52, 73, 94)

        pnl.Controls.Add(lbl)
        pnl.Controls.Add(btnOD200)
        pnl.Controls.Add(btnOD400)
        pnl.Controls.Add(status)
        Me.Controls.Add(pnl)
    End Sub

    Private Sub SetStatus(msg As String, Optional ok As Boolean = True)
        Dim arr() As Control = Me.Controls.Find("lblStatus", True)
        If arr IsNot Nothing AndAlso arr.Length > 0 Then
            Dim s As Label = TryCast(arr(0), Label)
            If s IsNot Nothing Then
                s.Text = msg
                s.ForeColor = If(ok, Color.FromArgb(39, 174, 96), Color.FromArgb(192, 57, 43))
            End If
        End If
    End Sub

    Private Sub OnExportOD200Click(sender As Object, e As EventArgs)
        ExportBranch(6, "OD200_Ayesha_Centre")
    End Sub

    Private Sub OnExportOD400Click(sender As Object, e As EventArgs)
        ExportBranch(4, "OD400_Umhlanga")
    End Sub

    Private Sub ExportBranch(branchID As Integer, branchName As String)
        Try
            Dim sfd As New SaveFileDialog()
            sfd.Filter = "CSV Files|*.csv"
            sfd.FileName = branchName & "_Export.csv"
            sfd.Title = "Save Branch Export"
            If sfd.ShowDialog(Me) <> DialogResult.OK Then
                SetStatus("Export cancelled.")
                Return
            End If

            Dim outPath As String = sfd.FileName
            SetStatus("Exporting " & branchName & "...")

            Using conn As New SqlConnection(_connStr)
                conn.Open()

                Dim sql As String = "SELECT DISTINCT " &
                    "p.ProductID, " &
                    "ISNULL(p.Code, '') AS Code, " &
                    "ISNULL(p.ProductType, '') AS ProductType, " &
                    "CASE " &
                    "    WHEN p.ProductType = 'External' AND p.ExternalBarcode IS NOT NULL THEN p.ExternalBarcode " &
                    "    WHEN p.ProductType = 'Internal' AND p.Code IS NOT NULL AND p.Code <> '' THEN '2' + RIGHT('00000000' + p.Code, 8) " &
                    "    ELSE '' " &
                    "END AS Barcode, " &
                    "p.Name AS ProductName, " &
                    "p.Description, " &
                    "ISNULL(s.QtyOnHand, 0) AS QtyOnHand, " &
                    "@BranchID AS BranchID, " &
                    "ISNULL(pr.SellingPrice, 0) AS SellingPriceInclVAT, " &
                    "ISNULL(pr.SellingPrice / (1 + " & VAT_RATE.ToString("0.00") & "), 0) AS SellingPriceExclVAT, " &
                    "ISNULL(pr.CostPrice, 0) AS Cost " &
                    "FROM Demo_Retail_Product p " &
                    "LEFT JOIN ( " &
                    "    SELECT s.VariantID, SUM(s.QtyOnHand) AS QtyOnHand " &
                    "    FROM Demo_Retail_Stock s " &
                    "    INNER JOIN Demo_Retail_Variant v ON s.VariantID = v.VariantID " &
                    "    WHERE s.BranchID = @BranchID " &
                    "    GROUP BY s.VariantID, v.ProductID " &
                    ") s ON p.ProductID = (SELECT TOP 1 ProductID FROM Demo_Retail_Variant WHERE VariantID = s.VariantID) " &
                    "LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID AND pr.BranchID = @BranchID " &
                    "WHERE p.IsActive = 1 " &
                    "ORDER BY p.ProductID"

                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@BranchID", branchID)

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        Using writer As New StreamWriter(outPath, False, System.Text.Encoding.UTF8)
                            writer.WriteLine("ProductID,Code,ProductType,Barcode,ProductName,Description,BranchID,QtyOnHand,SellingPriceInclVAT,SellingPriceExclVAT,Cost")

                            While reader.Read()
                                Dim line As String = String.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8:F2},{9:F2},{10:F2}",
                                    reader("ProductID"),
                                    EscapeCsv(reader("Code").ToString()),
                                    EscapeCsv(reader("ProductType").ToString()),
                                    EscapeCsv(reader("Barcode").ToString()),
                                    EscapeCsv(reader("ProductName").ToString()),
                                    EscapeCsv(reader("Description").ToString()),
                                    reader("BranchID"),
                                    reader("QtyOnHand"),
                                    reader("SellingPriceInclVAT"),
                                    reader("SellingPriceExclVAT"),
                                    reader("Cost"))
                                writer.WriteLine(line)
                            End While
                        End Using
                    End Using
                End Using
            End Using

            SetStatus(branchName & " exported successfully to " & Path.GetFileName(outPath))
        Catch ex As Exception
            SetStatus("Export failed: " & ex.Message, False)
        End Try
    End Sub

    Private Function EscapeCsv(value As String) As String
        If String.IsNullOrEmpty(value) Then Return ""
        If value.Contains(",") OrElse value.Contains("""") OrElse value.Contains(vbCrLf) Then
            Return """" & value.Replace("""", """""") & """"
        End If
        Return value
    End Function
End Class
