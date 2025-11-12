Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing.Printing

Namespace Manufacturing
    Public Class BakerProductionViewForm
    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private bakerID As Integer = 0
    Private bakerName As String = ""
    Private currentReOrderBookID As Integer = 0
    Private printDocument As New PrintDocument()
    Private printData As DataTable

    Public Sub New(bakerUserID As Integer)
        InitializeComponent()
        Me.bakerID = bakerUserID
    End Sub

    Private Sub BakerProductionViewForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            LoadBakerInfo()
            LoadReOrderBooks()
            AddHandler printDocument.PrintPage, AddressOf PrintDocument_PrintPage
        Catch ex As Exception
            MessageBox.Show("Error loading form: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadBakerInfo()
        Try
            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("SELECT FirstName + ' ' + LastName AS FullName FROM Users WHERE UserID = @UserID", conn)
                cmd.Parameters.AddWithValue("@UserID", bakerID)
                conn.Open()
                
                bakerName = cmd.ExecuteScalar()?.ToString()
                lblBakerName.Text = $"Baker: {bakerName}"
                Me.Text = $"Production Orders - {bakerName}"
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading baker info: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadReOrderBooks()
        Try
            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("sp_GetBakerReOrderBooks", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ManufacturerUserID", bakerID)
                cmd.Parameters.AddWithValue("@OrderDate", dtpDate.Value.Date)
                cmd.Parameters.AddWithValue("@Status", DBNull.Value)
                
                conn.Open()
                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())
                
                dgvReOrderBooks.DataSource = dt
                lblOrderCount.Text = $"Orders: {dt.Rows.Count}"
                
                ' Color code by status
                For Each row As DataGridViewRow In dgvReOrderBooks.Rows
                    Dim status As String = row.Cells("Status").Value?.ToString()
                    Select Case status
                        Case "Posted"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(255, 243, 205) ' Yellow
                        Case "InProgress"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(209, 231, 221) ' Light blue
                        Case "Completed"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(212, 237, 218) ' Light green
                    End Select
                Next
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvReOrderBooks_CellClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvReOrderBooks.CellClick
        If e.RowIndex >= 0 Then
            currentReOrderBookID = CInt(dgvReOrderBooks.Rows(e.RowIndex).Cells("ReOrderBookID").Value)
            LoadProductLines(currentReOrderBookID)
        End If
    End Sub

    Private Sub LoadProductLines(reOrderBookID As Integer)
        Try
            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("sp_GetReOrderBookDetails", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ReOrderBookID", reOrderBookID)
                
                conn.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                
                ' Header
                If reader.Read() Then
                    txtReOrderNumber.Text = reader("ReOrderNumber").ToString()
                    lblStatus.Text = $"Status: {reader("Status")}"
                    lblTotalProducts.Text = $"Products: {reader("TotalProducts")}"
                    lblTotalQuantity.Text = $"Total Qty: {reader("TotalQuantity")}"
                    
                    Dim status As String = reader("Status").ToString()
                    ' Start Production only enabled when BOM is fulfilled (status = Posted)
                    btnStartProduction.Enabled = (status = "Posted")
                    btnCompleteProduct.Enabled = (status = "InProgress")
                    btnPrint.Enabled = True
                    btnRequestBOM.Enabled = (status = "Posted" Or status = "Draft")
                End If
                
                ' Product Lines
                reader.NextResult()
                Dim dtLines As New DataTable()
                dtLines.Load(reader)
                dgvProductLines.DataSource = dtLines
                
                ' Color code completed items
                For Each row As DataGridViewRow In dgvProductLines.Rows
                    If row.Cells("LineStatus").Value?.ToString() = "Completed" Then
                        row.DefaultCellStyle.BackColor = Color.FromArgb(212, 237, 218)
                        row.DefaultCellStyle.Font = New Font(dgvProductLines.Font, FontStyle.Strikeout)
                    End If
                Next
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading products: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnStartProduction_Click(sender As Object, e As EventArgs) Handles btnStartProduction.Click
        If currentReOrderBookID = 0 Then Return
        
        Dim result As DialogResult = MessageBox.Show(
            "Start production for this re-order book?",
            "Confirm Start",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question)
        
        If result = DialogResult.Yes Then
            Try
                Using conn As New SqlConnection(connectionString)
                    Dim cmd As New SqlCommand("sp_StartReOrderBook", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                    cmd.Parameters.AddWithValue("@StartedBy", bakerName)
                    
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    
                    MessageBox.Show("Production started!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    LoadReOrderBooks()
                    LoadProductLines(currentReOrderBookID)
                End Using
            Catch ex As Exception
                MessageBox.Show("Error starting production: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

    Private Sub btnCompleteProduct_Click(sender As Object, e As EventArgs) Handles btnCompleteProduct.Click
        If dgvProductLines.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select a product to complete", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim selectedRow As DataGridViewRow = dgvProductLines.SelectedRows(0)
        Dim lineID As Integer = CInt(selectedRow.Cells("ReOrderLineID").Value)
        Dim productName As String = selectedRow.Cells("ProductName").Value.ToString()
        Dim qtyOrdered As Decimal = CDec(selectedRow.Cells("QuantityOrdered").Value)
        Dim lineStatus As String = selectedRow.Cells("LineStatus").Value?.ToString()
        
        If lineStatus = "Completed" Then
            MessageBox.Show("This product is already completed", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        ' Show completion dialog
        Dim qtyCompleted As String = InputBox($"Enter quantity completed for:{vbCrLf}{productName}{vbCrLf}Ordered: {qtyOrdered}", "Complete Product", qtyOrdered.ToString())
        
        If String.IsNullOrEmpty(qtyCompleted) Then Return
        
        Dim qty As Decimal
        If Not Decimal.TryParse(qtyCompleted, qty) OrElse qty <= 0 Then
            MessageBox.Show("Invalid quantity", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Try
            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("sp_CompleteReOrderProduct", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ReOrderLineID", lineID)
                cmd.Parameters.AddWithValue("@QuantityCompleted", qty)
                cmd.Parameters.AddWithValue("@CompletedBy", bakerID)
                
                conn.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                
                Dim allCompleted As Boolean = False
                If reader.Read() Then
                    allCompleted = CBool(reader("AllCompleted"))
                End If
                
                If allCompleted Then
                    MessageBox.Show($"Product completed and added to retail stock!{vbCrLf}{vbCrLf}All products completed - Re-Order Book finished! 🎉", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Else
                    MessageBox.Show("Product completed and added to retail stock!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
                
                LoadReOrderBooks()
                LoadProductLines(currentReOrderBookID)
            End Using
        Catch ex As Exception
            MessageBox.Show("Error completing product: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click
        If currentReOrderBookID = 0 Then
            MessageBox.Show("Please select a re-order book", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Try
            ' Load print data
            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("sp_GetReOrderBookDetails", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                
                conn.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                
                ' Skip header
                reader.Read()
                
                ' Get product lines
                reader.NextResult()
                printData = New DataTable()
                printData.Load(reader)
            End Using
            
            ' Set page settings before preview
            printDocument.DefaultPageSettings.Landscape = False
            printDocument.DefaultPageSettings.PaperSize = New Printing.PaperSize("A4", 827, 1169)
            
            ' Show print preview
            Dim printPreview As New PrintPreviewDialog With {
                .Document = printDocument,
                .Width = 1200,
                .Height = 900,
                .WindowState = FormWindowState.Maximized
            }
            printPreview.ShowDialog()
            
        Catch ex As Exception
            MessageBox.Show("Error printing: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub PrintDocument_PrintPage(sender As Object, e As PrintPageEventArgs)
        Try
            Dim font As New Font("Segoe UI", 10)
            Dim fontBold As New Font("Segoe UI", 12, FontStyle.Bold)
            Dim fontTitle As New Font("Segoe UI", 16, FontStyle.Bold)
            Dim brush As New SolidBrush(Color.Black)
            
            Dim yPos As Integer = 50
            Dim leftMargin As Integer = 50
            Dim pageWidth As Integer = e.PageBounds.Width
            Dim rightMargin As Integer = pageWidth - 50
            
            ' Title
            e.Graphics.DrawString("PRODUCTION SHEET", fontTitle, brush, leftMargin, yPos)
            yPos += 40
            
            ' Header info
            e.Graphics.DrawString($"Re-Order #: {txtReOrderNumber.Text}", fontBold, brush, leftMargin, yPos)
            yPos += 25
            e.Graphics.DrawString($"Baker: {bakerName}", font, brush, leftMargin, yPos)
            yPos += 20
            e.Graphics.DrawString($"Date: {DateTime.Now:dd/MM/yyyy HH:mm}", font, brush, leftMargin, yPos)
            yPos += 20
            e.Graphics.DrawString($"{lblTotalProducts.Text} | {lblTotalQuantity.Text}", font, brush, leftMargin, yPos)
            yPos += 40
            
            ' Line
            e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
            yPos += 20
            
            ' Column headers
            e.Graphics.DrawString("#", fontBold, brush, leftMargin, yPos)
            e.Graphics.DrawString("Product", fontBold, brush, leftMargin + 40, yPos)
            e.Graphics.DrawString("Barcode", fontBold, brush, leftMargin + 300, yPos)
            e.Graphics.DrawString("Quantity", fontBold, brush, leftMargin + 500, yPos)
            e.Graphics.DrawString("Status", fontBold, brush, leftMargin + 620, yPos)
            yPos += 25
            
            e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
            yPos += 15
            
            ' Product lines
            For Each row As DataRow In printData.Rows
                If yPos > e.PageBounds.Height - 100 Then Exit For ' Page limit
                
                e.Graphics.DrawString(row("LineNumber").ToString(), font, brush, leftMargin, yPos)
                e.Graphics.DrawString(row("ProductName").ToString(), font, brush, leftMargin + 40, yPos)
                e.Graphics.DrawString(row("SKU").ToString(), font, brush, leftMargin + 300, yPos)
                e.Graphics.DrawString(row("QuantityOrdered").ToString(), font, brush, leftMargin + 500, yPos)
                
                Dim status As String = row("LineStatus").ToString()
                Dim statusText As String = If(status = "Completed", "✓ Done", "☐ Pending")
                e.Graphics.DrawString(statusText, font, brush, leftMargin + 620, yPos)
                
                yPos += 25
            Next
            
            ' Footer
            yPos += 40
            e.Graphics.DrawLine(Pens.Black, leftMargin, yPos, rightMargin, yPos)
            yPos += 20
            e.Graphics.DrawString($"Printed: {DateTime.Now:dd/MM/yyyy HH:mm}", New Font("Segoe UI", 8), brush, leftMargin, yPos)
            
        Catch ex As Exception
            MessageBox.Show("Error during print: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dtpDate_ValueChanged(sender As Object, e As EventArgs) Handles dtpDate.ValueChanged
        LoadReOrderBooks()
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadReOrderBooks()
        If currentReOrderBookID > 0 Then
            LoadProductLines(currentReOrderBookID)
        End If
    End Sub

    Private Sub btnRequestBOM_Click(sender As Object, e As EventArgs) Handles btnRequestBOM.Click
        If currentReOrderBookID = 0 Then
            MessageBox.Show("Please select a re-order book first", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Try
            ' Get product names and quantities from grid
            Dim productData As New Dictionary(Of String, Decimal)
            Dim productIDs As New List(Of Integer)
            Dim totalQty As Decimal = 0

            Using conn As New SqlConnection(connectionString)
                conn.Open()
                For Each row As DataGridViewRow In dgvProductLines.Rows
                    If Not row.IsNewRow AndAlso row.Cells("ProductName").Value IsNot Nothing Then
                        Dim prodName As String = row.Cells("ProductName").Value.ToString()
                        Dim qty As Decimal = Convert.ToDecimal(row.Cells("QuantityOrdered").Value)

                        ' Get ProductID from database
                        Dim cmd As New SqlCommand("SELECT ProductID FROM Demo_Retail_Product WHERE Name = @Name", conn)
                        cmd.Parameters.AddWithValue("@Name", prodName)
                        Dim prodID As Object = cmd.ExecuteScalar()

                        If prodID IsNot Nothing Then
                            Dim id As Integer = Convert.ToInt32(prodID)
                            If Not productIDs.Contains(id) Then
                                productIDs.Add(id)
                                productData(prodName) = qty
                                totalQty += qty
                            End If
                        End If
                    End If
                Next
            End Using

            ' Open BOM Editor with preloaded products and baker info
            Dim bomEditor As New Manufacturing.BOMEditorForm()
            bomEditor.SetMode("Create")
            ' Set requester BEFORE showing dialog so it auto-selects
            bomEditor.SetRequester(bakerID, bakerName)
            bomEditor.PreloadProducts(productIDs)
            bomEditor.SetProductionQuantity(totalQty)
            bomEditor.LockFields(True)
            ' Show dialog - baker should be auto-selected
            bomEditor.ShowDialog()

            ' Refresh after BOM created
            LoadReOrderBooks()
            If currentReOrderBookID > 0 Then
                LoadProductLines(currentReOrderBookID)
            End If
        Catch ex As Exception
            MessageBox.Show("Error opening BOM request: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
    End Class
End Namespace
