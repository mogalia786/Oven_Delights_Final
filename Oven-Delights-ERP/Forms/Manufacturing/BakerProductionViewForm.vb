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
                            row.DefaultCellStyle.BackColor = Color.FromArgb(255, 243, 205) ' Yellow - waiting for stockroom
                        Case "Ready for Production"
                            row.DefaultCellStyle.BackColor = Color.FromArgb(144, 238, 144) ' Light green - ready to start
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
                    
                    ' ALWAYS ENABLE ALL BUTTONS
                    btnStartProduction.Enabled = True
                    btnCompleteProduct.Enabled = True
                    btnPrint.Enabled = True
                    btnRequestBOM.Enabled = True
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
        If currentReOrderBookID = 0 Then
            MessageBox.Show("Please select a re-order book first", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Try
            ' Get all products from re-order book
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                
                ' Get expected quantities
                Dim cmdExpected As New SqlCommand(
                    "SELECT rbl.ProductID, p.Name AS ProductName, rbl.QuantityOrdered " &
                    "FROM ReOrderBookLines rbl " &
                    "INNER JOIN Demo_Retail_Product p ON rbl.ProductID = p.ProductID " &
                    "WHERE rbl.ReOrderBookID = @ReOrderBookID", conn)
                cmdExpected.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                Dim reader = cmdExpected.ExecuteReader()
                
                Dim products As New List(Of (ProductID As Integer, ProductName As String, Expected As Decimal))
                While reader.Read()
                    products.Add((reader.GetInt32(0), reader.GetString(1), reader.GetDecimal(2)))
                End While
                reader.Close()
                
                ' Show yield input dialog
                Dim yieldForm As New Form()
                yieldForm.Text = "End Production - Enter Actual Yield"
                yieldForm.Size = New Size(600, 400)
                yieldForm.StartPosition = FormStartPosition.CenterParent
                
                Dim lblTitle As New Label()
                lblTitle.Text = "Enter actual quantities produced:"
                lblTitle.Font = New Font("Arial", 12, FontStyle.Bold)
                lblTitle.Location = New Point(20, 20)
                lblTitle.AutoSize = True
                yieldForm.Controls.Add(lblTitle)
                
                Dim yPos = 60
                Dim yieldInputs As New List(Of (ProductID As Integer, ProductName As String, Expected As Decimal, Input As NumericUpDown))
                
                For Each prod In products
                    Dim lblProd As New Label()
                    lblProd.Text = $"{prod.ProductName} (Expected: {prod.Expected})"
                    lblProd.Location = New Point(20, yPos)
                    lblProd.Width = 350
                    yieldForm.Controls.Add(lblProd)
                    
                    Dim nudActual As New NumericUpDown()
                    nudActual.Location = New Point(380, yPos)
                    nudActual.Width = 150
                    nudActual.Maximum = 10000
                    nudActual.Value = prod.Expected
                    yieldForm.Controls.Add(nudActual)
                    
                    yieldInputs.Add((prod.ProductID, prod.ProductName, prod.Expected, nudActual))
                    yPos += 35
                Next
                
                Dim btnConfirm As New Button()
                btnConfirm.Text = "Confirm & Complete"
                btnConfirm.Location = New Point(380, yPos + 20)
                btnConfirm.Size = New Size(150, 35)
                btnConfirm.DialogResult = DialogResult.OK
                yieldForm.Controls.Add(btnConfirm)
                
                If yieldForm.ShowDialog() = DialogResult.OK Then
                    Dim transaction = conn.BeginTransaction()
                    Try
                        ' Check for shortages
                        Dim hasShortage = False
                        Dim shortageReason As String = ""
                        For Each item In yieldInputs
                            If item.Input.Value < item.Expected Then
                                hasShortage = True
                                Exit For
                            End If
                        Next
                        
                        ' If shortage, require manager approval
                        If hasShortage Then
                            Dim approvalForm As New Form()
                            approvalForm.Text = "Manager Approval Required"
                            approvalForm.Size = New Size(500, 300)
                            approvalForm.StartPosition = FormStartPosition.CenterParent
                            
                            Dim lblWarning As New Label()
                            lblWarning.Text = "⚠ Yield is less than expected!" & vbCrLf & "Manager approval required."
                            lblWarning.Font = New Font("Arial", 11, FontStyle.Bold)
                            lblWarning.ForeColor = Color.Red
                            lblWarning.Location = New Point(20, 20)
                            lblWarning.AutoSize = True
                            approvalForm.Controls.Add(lblWarning)
                            
                            Dim lblUsername As New Label()
                            lblUsername.Text = "Manager Username:"
                            lblUsername.Location = New Point(20, 80)
                            lblUsername.AutoSize = True
                            approvalForm.Controls.Add(lblUsername)
                            
                            Dim txtUsername As New TextBox()
                            txtUsername.Location = New Point(150, 77)
                            txtUsername.Width = 300
                            approvalForm.Controls.Add(txtUsername)
                            
                            Dim lblPassword As New Label()
                            lblPassword.Text = "Password:"
                            lblPassword.Location = New Point(20, 115)
                            lblPassword.AutoSize = True
                            approvalForm.Controls.Add(lblPassword)
                            
                            Dim txtPassword As New TextBox()
                            txtPassword.Location = New Point(150, 112)
                            txtPassword.Width = 300
                            txtPassword.UseSystemPasswordChar = True
                            approvalForm.Controls.Add(txtPassword)
                            
                            Dim lblReason As New Label()
                            lblReason.Text = "Reason for shortage:"
                            lblReason.Location = New Point(20, 150)
                            lblReason.AutoSize = True
                            approvalForm.Controls.Add(lblReason)
                            
                            Dim txtReason As New TextBox()
                            txtReason.Location = New Point(150, 147)
                            txtReason.Width = 300
                            txtReason.Height = 60
                            txtReason.Multiline = True
                            approvalForm.Controls.Add(txtReason)
                            
                            Dim btnApprove As New Button()
                            btnApprove.Text = "Approve"
                            btnApprove.Location = New Point(300, 220)
                            btnApprove.DialogResult = DialogResult.OK
                            approvalForm.Controls.Add(btnApprove)
                            
                            If approvalForm.ShowDialog() <> DialogResult.OK Then
                                transaction.Rollback()
                                Return
                            End If
                            
                            ' Verify manager credentials
                            Dim cmdVerify As New SqlCommand(
                                "SELECT COUNT(*) FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID " &
                                "WHERE u.Username = @Username AND u.Password = @Password AND r.RoleName = 'Manufacturing Manager'", conn, transaction)
                            cmdVerify.Parameters.AddWithValue("@Username", txtUsername.Text)
                            cmdVerify.Parameters.AddWithValue("@Password", txtPassword.Text)
                            
                            If Convert.ToInt32(cmdVerify.ExecuteScalar()) = 0 Then
                                MessageBox.Show("Invalid manager credentials!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                transaction.Rollback()
                                Return
                            End If
                            
                            ' Store reason for later use
                            shortageReason = txtReason.Text
                            
                            ' Log shortage reason
                            Dim cmdLog As New SqlCommand(
                                "INSERT INTO ProductionShortageLog (ReOrderBookID, Reason, ApprovedBy, LogDate) " &
                                "VALUES (@ReOrderBookID, @Reason, @ApprovedBy, GETDATE())", conn, transaction)
                            cmdLog.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                            cmdLog.Parameters.AddWithValue("@Reason", shortageReason)
                            cmdLog.Parameters.AddWithValue("@ApprovedBy", txtUsername.Text)
                            cmdLog.ExecuteNonQuery()
                        End If
                        
                        ' Process each product
                        Dim branchId = If(AppSession.CurrentUser?.BranchID, 0)
                        
                        For Each item In yieldInputs
                            Dim actualQty = item.Input.Value
                            Dim shortage = item.Expected - actualQty
                            
                            ' Calculate cost of sales from BOM
                            Dim totalCost As Decimal = 0
                            
                            ' Get BOM and calculate costs
                            Dim cmdGetBOM As New SqlCommand(
                                "SELECT bl.ItemID, bl.Quantity, bh.BatchSize " &
                                "FROM BOM_Lines bl " &
                                "INNER JOIN BOM_Header bh ON bl.BOMID = bh.BOMID " &
                                "WHERE bh.ProductID = @ProductID AND bh.IsActive = 1", conn, transaction)
                            cmdGetBOM.Parameters.AddWithValue("@ProductID", item.ProductID)
                            
                            Dim bomData As New DataTable()
                            Using bomAdapter As New SqlDataAdapter(cmdGetBOM)
                                bomAdapter.Fill(bomData)
                            End Using
                            
                            ' Calculate total cost
                            For Each bomRow As DataRow In bomData.Rows
                                Dim itemID = Convert.ToInt32(bomRow("ItemID"))
                                Dim bomQty = Convert.ToDecimal(bomRow("Quantity"))
                                Dim batchSize = Convert.ToDecimal(bomRow("BatchSize"))
                                Dim qtyUsed = (bomQty / batchSize) * actualQty
                                
                                ' Get ingredient cost
                                Dim cmdCost As New SqlCommand(
                                    "SELECT TOP 1 ISNULL(CostPrice, 0) FROM Demo_Retail_Price " &
                                    "WHERE ProductID = @ProductID AND BranchID = @BranchID " &
                                    "ORDER BY CreatedAt DESC", conn, transaction)
                                cmdCost.Parameters.AddWithValue("@ProductID", itemID)
                                cmdCost.Parameters.AddWithValue("@BranchID", branchId)
                                Dim ingredientCost = Convert.ToDecimal(cmdCost.ExecuteScalar())
                                
                                totalCost += (ingredientCost * qtyUsed)
                            Next
                            
                            ' Calculate cost per unit
                            Dim costPerUnit = If(actualQty > 0, totalCost / actualQty, 0)
                            
                            ' Log production with all details
                            Dim cmdLog As New SqlCommand(
                                "INSERT INTO ProductionLog (ReOrderBookID, ProductID, ProductName, Baker, " &
                                "ExpectedYield, ActualYield, ShortBy, Reason, CostOfSales, ProductionDate, BranchID) " &
                                "VALUES (@ReOrderBookID, @ProductID, @ProductName, @Baker, @ExpectedYield, " &
                                "@ActualYield, @ShortBy, @Reason, @CostOfSales, GETDATE(), @BranchID)", conn, transaction)
                            cmdLog.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                            cmdLog.Parameters.AddWithValue("@ProductID", item.ProductID)
                            cmdLog.Parameters.AddWithValue("@ProductName", item.ProductName)
                            cmdLog.Parameters.AddWithValue("@Baker", bakerName)
                            cmdLog.Parameters.AddWithValue("@ExpectedYield", item.Expected)
                            cmdLog.Parameters.AddWithValue("@ActualYield", actualQty)
                            cmdLog.Parameters.AddWithValue("@ShortBy", shortage)
                            cmdLog.Parameters.AddWithValue("@Reason", If(hasShortage, shortageReason, DBNull.Value))
                            cmdLog.Parameters.AddWithValue("@CostOfSales", totalCost)
                            cmdLog.Parameters.AddWithValue("@BranchID", branchId)
                            cmdLog.ExecuteNonQuery()
                            
                            ' Update finished product stock
                            Dim cmdAddProduct As New SqlCommand(
                                "UPDATE Demo_Retail_Product " &
                                "SET CurrentStock = ISNULL(CurrentStock, 0) + @Qty " &
                                "WHERE ProductID = @ProductID AND BranchID = @BranchID", conn, transaction)
                            cmdAddProduct.Parameters.AddWithValue("@ProductID", item.ProductID)
                            cmdAddProduct.Parameters.AddWithValue("@Qty", actualQty)
                            cmdAddProduct.Parameters.AddWithValue("@BranchID", branchId)
                            cmdAddProduct.ExecuteNonQuery()
                        Next
                        
                        ' Mark re-order book as completed
                        Dim cmdComplete As New SqlCommand(
                            "UPDATE ReOrderBooks SET Status = 'Completed', CompletedDate = GETDATE(), CompletedBy = @CompletedBy " &
                            "WHERE ReOrderBookID = @ReOrderBookID", conn, transaction)
                        cmdComplete.Parameters.AddWithValue("@ReOrderBookID", currentReOrderBookID)
                        cmdComplete.Parameters.AddWithValue("@CompletedBy", bakerName)
                        cmdComplete.ExecuteNonQuery()
                        
                        transaction.Commit()
                        
                        MessageBox.Show("Production completed! Products added to retail stock.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        LoadReOrderBooks()
                        
                    Catch ex As Exception
                        transaction.Rollback()
                        Throw
                    End Try
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show("Error completing production: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
            ' Open BOM Requisition Form
            Dim requisitionForm As New BOMRequisitionForm(currentReOrderBookID)
            requisitionForm.ShowDialog()

            ' Refresh after requisition created
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
