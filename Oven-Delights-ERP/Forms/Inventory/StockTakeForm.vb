Imports System.Data.SqlClient
Imports System.Configuration
Imports System.IO
Imports ClosedXML.Excel

Public Class StockTakeForm
    Inherits Form
    Private ReadOnly connString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private currentBranchID As Integer
    Private currentBranchName As String
    Private currentUserRole As String
    
    ' Modern color scheme
    Private ReadOnly PrimaryColor As Color = Color.FromArgb(41, 128, 185)
    Private ReadOnly AccentColor As Color = Color.FromArgb(52, 152, 219)
    Private ReadOnly SuccessColor As Color = Color.FromArgb(39, 174, 96)
    Private ReadOnly WarningColor As Color = Color.FromArgb(243, 156, 18)
    Private ReadOnly DangerColor As Color = Color.FromArgb(231, 76, 60)
    Private ReadOnly DarkBg As Color = Color.FromArgb(44, 62, 80)
    Private ReadOnly LightBg As Color = Color.FromArgb(236, 240, 241)
    
    Public Sub New(branchID As Integer, userRole As String)
        InitializeComponent()
        currentBranchID = branchID
        currentUserRole = userRole
        
        ' Get branch name
        Try
            Using conn As New SqlConnection(connString)
                conn.Open()
                Dim cmd As New SqlCommand("SELECT BranchName FROM Branches WHERE BranchID = @BranchID", conn)
                cmd.Parameters.AddWithValue("@BranchID", branchID)
                Dim result = cmd.ExecuteScalar()
                currentBranchName = If(result IsNot Nothing, result.ToString(), "Unknown Branch")
            End Using
        Catch
            currentBranchName = $"Branch {branchID}"
        End Try
        
        AddHandler Me.Load, AddressOf StockTakeForm_Load
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "Stock Take Management"
        Me.Size = New Size(1400, 800)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = LightBg
        Me.Font = New Font("Segoe UI", 10)
        
        ' Header Panel
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = DarkBg,
            .Padding = New Padding(20, 10, 20, 10)
        }
        
        Dim lblTitle As New Label With {
            .Text = "📦 STOCK TAKE MANAGEMENT",
            .Font = New Font("Segoe UI", 20, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 15)
        }
        pnlHeader.Controls.Add(lblTitle)
        
        Dim lblBranch As New Label With {
            .Text = $"Branch: {currentBranchName}",
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = Color.FromArgb(243, 156, 18),
            .AutoSize = True,
            .Location = New Point(Me.Width - 300, 20)
        }
        lblBranch.Anchor = AnchorStyles.Top Or AnchorStyles.Right
        pnlHeader.Controls.Add(lblBranch)
        
        Dim lblSubtitle As New Label With {
            .Text = "Capture current stock levels, selling prices, and cost prices",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = Color.FromArgb(189, 195, 199),
            .AutoSize = True,
            .Location = New Point(20, 48)
        }
        pnlHeader.Controls.Add(lblSubtitle)
        
        ' Toolbar Panel
        Dim pnlToolbar As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 70,
            .BackColor = Color.White,
            .Padding = New Padding(20, 10, 20, 10)
        }
        
        Dim btnRefresh As New Button With {
            .Text = "🔄 Refresh",
            .Size = New Size(120, 45),
            .Location = New Point(20, 12),
            .BackColor = AccentColor,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Cursor = Cursors.Hand
        }
        btnRefresh.FlatAppearance.BorderSize = 0
        AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click
        pnlToolbar.Controls.Add(btnRefresh)
        
        Dim btnExport As New Button With {
            .Text = "📤 Export to Excel",
            .Size = New Size(150, 45),
            .Location = New Point(150, 12),
            .BackColor = SuccessColor,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Cursor = Cursors.Hand
        }
        btnExport.FlatAppearance.BorderSize = 0
        AddHandler btnExport.Click, AddressOf BtnExport_Click
        pnlToolbar.Controls.Add(btnExport)
        
        Dim btnImport As New Button With {
            .Text = "📥 Import from Excel",
            .Size = New Size(170, 45),
            .Location = New Point(310, 12),
            .BackColor = WarningColor,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Cursor = Cursors.Hand
        }
        btnImport.FlatAppearance.BorderSize = 0
        AddHandler btnImport.Click, AddressOf BtnImport_Click
        pnlToolbar.Controls.Add(btnImport)
        
        Dim btnSave As New Button With {
            .Text = "💾 Save Changes",
            .Size = New Size(150, 45),
            .Location = New Point(490, 12),
            .BackColor = PrimaryColor,
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Cursor = Cursors.Hand
        }
        btnSave.FlatAppearance.BorderSize = 0
        AddHandler btnSave.Click, AddressOf BtnSave_Click
        pnlToolbar.Controls.Add(btnSave)
        
        Dim txtSearch As New TextBox With {
            .Size = New Size(300, 30),
            .Location = New Point(Me.Width - 340, 20),
            .Font = New Font("Segoe UI", 11),
            .Anchor = AnchorStyles.Top Or AnchorStyles.Right
        }
        txtSearch.PlaceholderText = "🔍 Search products..."
        AddHandler txtSearch.TextChanged, AddressOf TxtSearch_TextChanged
        pnlToolbar.Controls.Add(txtSearch)
        
        ' DataGridView
        Dim dgv As New DataGridView With {
            .Name = "dgvStock",
            .Dock = DockStyle.Fill,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .MultiSelect = False,
            .RowHeadersVisible = False,
            .EnableHeadersVisualStyles = False,
            .Font = New Font("Segoe UI", 10),
            .RowTemplate = New DataGridViewRow With {.Height = 35}
        }
        
        dgv.ColumnHeadersDefaultCellStyle.BackColor = DarkBg
        dgv.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgv.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        dgv.ColumnHeadersDefaultCellStyle.Padding = New Padding(5)
        dgv.ColumnHeadersHeight = 40
        
        dgv.DefaultCellStyle.SelectionBackColor = AccentColor
        dgv.DefaultCellStyle.SelectionForeColor = Color.White
        dgv.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 245, 245)
        
        ' Status Bar
        Dim pnlStatus As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 35,
            .BackColor = DarkBg
        }
        
        Dim lblStatus As New Label With {
            .Name = "lblStatus",
            .Text = "Ready",
            .ForeColor = Color.White,
            .Font = New Font("Segoe UI", 9),
            .AutoSize = True,
            .Location = New Point(10, 8)
        }
        pnlStatus.Controls.Add(lblStatus)
        
        Me.Controls.Add(dgv)
        Me.Controls.Add(pnlToolbar)
        Me.Controls.Add(pnlHeader)
        Me.Controls.Add(pnlStatus)
    End Sub
    
    Private Sub StockTakeForm_Load(sender As Object, e As EventArgs)
        LoadStockData()
    End Sub
    
    Private Sub LoadStockData()
        Try
            Dim dgv As DataGridView = DirectCast(Me.Controls.Find("dgvStock", True)(0), DataGridView)
            Dim lblStatus As Label = DirectCast(Me.Controls.Find("lblStatus", True)(0), Label)
            
            lblStatus.Text = "Loading stock data..."
            Application.DoEvents()
            
            Using conn As New SqlConnection(connString)
                conn.Open()
                
                Dim sql As String = "
                    SELECT DISTINCT
                        p.ProductID,
                        p.SKU,
                        p.Name AS ProductName,
                        p.Category,
                        p.BranchID,
                        b.BranchName,
                        ISNULL((SELECT SUM(s2.QtyOnHand) 
                                FROM Demo_Retail_Variant v2 
                                INNER JOIN Demo_Retail_Stock s2 ON v2.VariantID = s2.VariantID 
                                WHERE v2.ProductID = p.ProductID AND s2.BranchID = p.BranchID), 0) AS CurrentStock,
                        ISNULL(pr.SellingPrice, 0) AS SellingPrice,
                        ISNULL(pr.CostPrice, 0) AS CostPrice,
                        p.IsActive
                    FROM Demo_Retail_Product p
                    INNER JOIN Branches b ON p.BranchID = b.BranchID
                    LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID AND pr.BranchID = p.BranchID 
                        AND pr.EffectiveFrom <= GETDATE() 
                        AND (pr.EffectiveTo IS NULL OR pr.EffectiveTo >= GETDATE())
                    WHERE p.IsActive = 1
                        AND p.BranchID = @BranchID
                    ORDER BY p.Name"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                    
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                    
                    dgv.DataSource = dt
                    
                    ' Configure columns
                    dgv.Columns("ProductID").Visible = False
                    dgv.Columns("IsActive").Visible = False
                    dgv.Columns("BranchID").Visible = False
                    
                    dgv.Columns("SKU").HeaderText = "SKU"
                    dgv.Columns("SKU").Width = 100
                    dgv.Columns("SKU").ReadOnly = True
                    
                    dgv.Columns("ProductName").HeaderText = "Product Name"
                    dgv.Columns("ProductName").Width = 250
                    dgv.Columns("ProductName").ReadOnly = True
                    
                    dgv.Columns("Category").HeaderText = "Category"
                    dgv.Columns("Category").Width = 120
                    dgv.Columns("Category").ReadOnly = True
                    
                    dgv.Columns("BranchName").HeaderText = "Branch"
                    dgv.Columns("BranchName").Width = 100
                    dgv.Columns("BranchName").ReadOnly = True
                    
                    dgv.Columns("CurrentStock").HeaderText = "Current Stock"
                    dgv.Columns("CurrentStock").Width = 100
                    dgv.Columns("CurrentStock").DefaultCellStyle.Format = "N2"
                    dgv.Columns("CurrentStock").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    
                    dgv.Columns("SellingPrice").HeaderText = "Selling Price"
                    dgv.Columns("SellingPrice").Width = 100
                    dgv.Columns("SellingPrice").DefaultCellStyle.Format = "C2"
                    dgv.Columns("SellingPrice").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    
                    dgv.Columns("CostPrice").HeaderText = "Cost Price"
                    dgv.Columns("CostPrice").Width = 100
                    dgv.Columns("CostPrice").DefaultCellStyle.Format = "C2"
                    dgv.Columns("CostPrice").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    
                    lblStatus.Text = $"Loaded {dt.Rows.Count} products"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading stock data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
        LoadStockData()
    End Sub
    
    Private Sub BtnExport_Click(sender As Object, e As EventArgs)
        Try
            Dim dgv As DataGridView = DirectCast(Me.Controls.Find("dgvStock", True)(0), DataGridView)
            
            If dgv.Rows.Count = 0 Then
                MessageBox.Show("No data to export.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            Dim sfd As New SaveFileDialog With {
                .Filter = "Excel Files|*.xlsx",
                .FileName = $"StockTake_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
            }
            
            If sfd.ShowDialog() = DialogResult.OK Then
                Using wb As New XLWorkbook()
                    Dim ws = wb.Worksheets.Add("Stock Take")
                    
                    ' Branch header
                    ws.Cell(1, 1).Value = "BRANCH:"
                    ws.Cell(1, 2).Value = currentBranchName
                    ws.Cell(1, 1).Style.Font.Bold = True
                    ws.Cell(1, 2).Style.Font.Bold = True
                    ws.Cell(1, 2).Style.Font.FontColor = XLColor.FromArgb(243, 156, 18)
                    
                    ws.Cell(2, 1).Value = "Branch ID:"
                    ws.Cell(2, 2).Value = currentBranchID
                    ws.Cell(2, 1).Style.Font.Bold = True
                    
                    ' Headers
                    ws.Cell(4, 1).Value = "SKU"
                    ws.Cell(4, 2).Value = "Product Name"
                    ws.Cell(4, 3).Value = "Category"
                    ws.Cell(4, 4).Value = "Branch"
                    ws.Cell(4, 5).Value = "Current Stock"
                    ws.Cell(4, 6).Value = "New Stock Qty"
                    ws.Cell(4, 7).Value = "Selling Price"
                    ws.Cell(4, 8).Value = "Cost Price"
                    
                    ' Style headers
                    Dim headerRange = ws.Range(4, 1, 4, 8)
                    headerRange.Style.Font.Bold = True
                    headerRange.Style.Fill.BackgroundColor = XLColor.FromArgb(44, 62, 80)
                    headerRange.Style.Font.FontColor = XLColor.White
                    headerRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center
                    
                    ' Data
                    Dim row As Integer = 5
                    For Each dr As DataGridViewRow In dgv.Rows
                        If Not dr.IsNewRow Then
                            ws.Cell(row, 1).Value = dr.Cells("SKU").Value?.ToString()
                            ws.Cell(row, 2).Value = dr.Cells("ProductName").Value?.ToString()
                            ws.Cell(row, 3).Value = dr.Cells("Category").Value?.ToString()
                            ws.Cell(row, 4).Value = dr.Cells("BranchName").Value?.ToString()
                            ws.Cell(row, 5).Value = CDbl(dr.Cells("CurrentStock").Value)
                            ws.Cell(row, 6).Value = "" ' Empty for user to fill
                            ws.Cell(row, 7).Value = CDbl(dr.Cells("SellingPrice").Value)
                            ws.Cell(row, 8).Value = CDbl(dr.Cells("CostPrice").Value)
                            row += 1
                        End If
                    Next
                    
                    ' Format columns
                    ws.Column(5).Style.NumberFormat.Format = "#,##0.00"
                    ws.Column(6).Style.NumberFormat.Format = "#,##0.00"
                    ws.Column(6).Style.Fill.BackgroundColor = XLColor.FromArgb(255, 255, 200)
                    ws.Column(7).Style.NumberFormat.Format = "R #,##0.00"
                    ws.Column(8).Style.NumberFormat.Format = "R #,##0.00"
                    
                    ws.Columns().AdjustToContents()
                    
                    wb.SaveAs(sfd.FileName)
                End Using
                
                MessageBox.Show("Stock data exported successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Process.Start(New ProcessStartInfo(sfd.FileName) With {.UseShellExecute = True})
            End If
        Catch ex As Exception
            MessageBox.Show($"Error exporting data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub BtnImport_Click(sender As Object, e As EventArgs)
        Try
            Dim ofd As New OpenFileDialog With {
                .Filter = "Excel Files|*.xlsx;*.xls",
                .Title = "Select Stock Take File"
            }
            
            If ofd.ShowDialog() = DialogResult.OK Then
                ImportStockFromExcel(ofd.FileName)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error importing data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub ImportStockFromExcel(filePath As String)
        Dim lblStatus As Label = DirectCast(Me.Controls.Find("lblStatus", True)(0), Label)
        lblStatus.Text = "Importing stock data..."
        Application.DoEvents()
        
        Dim imported As Integer = 0
        Dim errors As Integer = 0
        
        Using wb As New XLWorkbook(filePath)
            Dim ws = wb.Worksheet(1)
            Dim lastRow = ws.LastRowUsed().RowNumber()
            
            ' Verify branch ID matches
            Dim excelBranchID = ws.Cell(2, 2).GetValue(Of Integer)()
            If excelBranchID <> currentBranchID Then
                MessageBox.Show($"Branch mismatch! This file is for Branch ID {excelBranchID}, but you are logged into Branch ID {currentBranchID}.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If
            
            Using conn As New SqlConnection(connString)
                conn.Open()
                
                Dim errorLog As New System.Text.StringBuilder()
                
                For row As Integer = 5 To lastRow
                    Try
                        Dim sku = ws.Cell(row, 1).GetString()
                        Dim newStockQty = ws.Cell(row, 6).GetValue(Of String)()
                        Dim sellingPrice = ws.Cell(row, 7).GetValue(Of String)()
                        Dim costPrice = ws.Cell(row, 8).GetValue(Of String)()
                        
                        If String.IsNullOrWhiteSpace(sku) Then Continue For
                        
                        ' Update stock if provided
                        If Not String.IsNullOrWhiteSpace(newStockQty) Then
                            Dim qty As Decimal = CDec(newStockQty)
                            UpdateStock(conn, sku, qty)
                        End If
                        
                        ' Update prices if provided
                        If Not String.IsNullOrWhiteSpace(sellingPrice) OrElse Not String.IsNullOrWhiteSpace(costPrice) Then
                            Dim sp As Decimal? = If(String.IsNullOrWhiteSpace(sellingPrice), Nothing, CDec(sellingPrice))
                            Dim cp As Decimal? = If(String.IsNullOrWhiteSpace(costPrice), Nothing, CDec(costPrice))
                            UpdatePrices(conn, sku, sp, cp)
                        End If
                        
                        imported += 1
                    Catch ex As Exception
                        errors += 1
                        errorLog.AppendLine($"Row {row}: {ex.Message}")
                    End Try
                Next
                
                ' Show error details if there are errors
                If errors > 0 Then
                    Dim errorFile = IO.Path.Combine(IO.Path.GetTempPath(), "StockTakeImportErrors.txt")
                    IO.File.WriteAllText(errorFile, errorLog.ToString())
                    lblStatus.Text = $"Import complete: {imported} updated, {errors} errors"
                    MessageBox.Show($"Import completed with errors.{vbCrLf}{vbCrLf}Updated: {imported}{vbCrLf}Errors: {errors}{vbCrLf}{vbCrLf}Error log saved to:{vbCrLf}{errorFile}", "Import Complete", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Process.Start(New ProcessStartInfo(errorFile) With {.UseShellExecute = True})
                Else
                    lblStatus.Text = $"Import complete: {imported} updated"
                    MessageBox.Show($"Import complete!{vbCrLf}{vbCrLf}Updated: {imported}{vbCrLf}Errors: {errors}", "Import Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            End Using
        End Using
        
        LoadStockData()
    End Sub
    
    Private Sub UpdateStock(conn As SqlConnection, sku As String, newQty As Decimal)
        Dim sql = "
            DECLARE @ProductID INT, @VariantID INT, @OldQty DECIMAL(18,3), @QtyDelta DECIMAL(18,3), @ProductName NVARCHAR(200), @CostPrice DECIMAL(18,2)
            
            SELECT @ProductID = ProductID, @ProductName = Name FROM Demo_Retail_Product WHERE SKU = @SKU
            SELECT @VariantID = VariantID FROM Demo_Retail_Variant WHERE ProductID = @ProductID AND IsActive = 1
            
            SELECT @OldQty = ISNULL(QtyOnHand, 0) FROM Demo_Retail_Stock WHERE VariantID = @VariantID AND BranchID = @BranchID
            SELECT @CostPrice = ISNULL(CostPrice, 0) FROM Demo_Retail_Price WHERE ProductID = @ProductID AND BranchID = @BranchID AND (EffectiveTo IS NULL OR EffectiveTo >= GETDATE())
            
            SET @QtyDelta = @NewQty - ISNULL(@OldQty, 0)
            
            IF EXISTS (SELECT 1 FROM Demo_Retail_Stock WHERE VariantID = @VariantID AND BranchID = @BranchID)
                UPDATE Demo_Retail_Stock SET QtyOnHand = @NewQty, UpdatedAt = GETDATE() WHERE VariantID = @VariantID AND BranchID = @BranchID
            ELSE
                INSERT INTO Demo_Retail_Stock (VariantID, BranchID, QtyOnHand) VALUES (@VariantID, @BranchID, @NewQty)
            
            INSERT INTO Demo_Retail_StockMovements (VariantID, BranchID, QtyDelta, Reason, Ref1)
            VALUES (@VariantID, @BranchID, @QtyDelta, 'Stock Take', 'Excel Import')
            
            -- Create ledger entry for stock adjustment
            DECLARE @Amount DECIMAL(18,2) = ABS(@QtyDelta * @CostPrice)
            DECLARE @Description NVARCHAR(500) = 'Stock Take Adjustment: ' + @ProductName + ' (' + @SKU + ') - Qty: ' + CAST(@QtyDelta AS NVARCHAR(20))
            
            IF @QtyDelta <> 0 AND @Amount > 0
            BEGIN
                -- Insert journal entry
                DECLARE @JournalID INT
                INSERT INTO Journals (BranchID, JournalDate, Description, Reference, CreatedAt, CreatedBy)
                VALUES (@BranchID, GETDATE(), @Description, 'STOCK-TAKE-' + CONVERT(VARCHAR, GETDATE(), 112), GETDATE(), 1)
                
                SET @JournalID = SCOPE_IDENTITY()
                
                DECLARE @InventoryAccountID INT, @IncomeAccountID INT, @ExpenseAccountID INT
                SELECT @InventoryAccountID = AccountID FROM Accounts WHERE AccountCode = '1300'
                SELECT @IncomeAccountID = AccountID FROM Accounts WHERE AccountCode = '4900'
                SELECT @ExpenseAccountID = AccountID FROM Accounts WHERE AccountCode = '5900'
                
                IF @QtyDelta > 0
                BEGIN
                    -- Stock increase: DR Inventory, CR Stock Adjustment Income
                    INSERT INTO JournalLines (JournalID, LineNumber, AccountID, Debit, Credit, LineDescription)
                    VALUES (@JournalID, 1, @InventoryAccountID, @Amount, 0, @Description)
                    
                    INSERT INTO JournalLines (JournalID, LineNumber, AccountID, Debit, Credit, LineDescription)
                    VALUES (@JournalID, 2, @IncomeAccountID, 0, @Amount, @Description)
                END
                ELSE
                BEGIN
                    -- Stock decrease: DR Stock Adjustment Expense, CR Inventory
                    INSERT INTO JournalLines (JournalID, LineNumber, AccountID, Debit, Credit, LineDescription)
                    VALUES (@JournalID, 1, @ExpenseAccountID, @Amount, 0, @Description)
                    
                    INSERT INTO JournalLines (JournalID, LineNumber, AccountID, Debit, Credit, LineDescription)
                    VALUES (@JournalID, 2, @InventoryAccountID, 0, @Amount, @Description)
                END
            END"
        
        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@SKU", sku)
            cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
            cmd.Parameters.AddWithValue("@NewQty", newQty)
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
    Private Sub UpdatePrices(conn As SqlConnection, sku As String, sellingPrice As Decimal?, costPrice As Decimal?)
        Dim sql = "
            DECLARE @ProductID INT, @VariantID INT, @ProductName NVARCHAR(200), @OldCostPrice DECIMAL(18,2), @QtyOnHand DECIMAL(18,3)
            
            SELECT @ProductID = ProductID, @ProductName = Name FROM Demo_Retail_Product WHERE SKU = @SKU
            SELECT @VariantID = VariantID FROM Demo_Retail_Variant WHERE ProductID = @ProductID AND IsActive = 1
            SELECT @QtyOnHand = ISNULL(QtyOnHand, 0) FROM Demo_Retail_Stock WHERE VariantID = @VariantID AND BranchID = @BranchID
            
            -- Get old cost price
            SELECT @OldCostPrice = ISNULL(CostPrice, 0) FROM Demo_Retail_Price WHERE ProductID = @ProductID AND BranchID = @BranchID AND EffectiveTo IS NULL
            
            -- Update Demo_Retail_Price table
            IF EXISTS (SELECT 1 FROM Demo_Retail_Price WHERE ProductID = @ProductID AND BranchID = @BranchID AND EffectiveTo IS NULL)
            BEGIN
                UPDATE Demo_Retail_Price 
                SET SellingPrice = ISNULL(@SellingPrice, SellingPrice),
                    CostPrice = ISNULL(@CostPrice, CostPrice)
                WHERE ProductID = @ProductID AND BranchID = @BranchID AND EffectiveTo IS NULL
            END
            ELSE
            BEGIN
                INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom)
                VALUES (@ProductID, @BranchID, ISNULL(@SellingPrice, 0), @CostPrice, GETDATE())
            END
            
            -- Update LastPaidPrice in Demo_Retail_Product for cost of sales tracking
            IF @CostPrice IS NOT NULL
            BEGIN
                UPDATE Demo_Retail_Product
                SET LastPaidPrice = @CostPrice,
                    AverageCost = @CostPrice
                WHERE ProductID = @ProductID AND BranchID = @BranchID
            END
            
            -- Create ledger entry for cost price change (inventory revaluation)
            IF @CostPrice IS NOT NULL AND @CostPrice <> @OldCostPrice AND @QtyOnHand > 0
            BEGIN
                DECLARE @CostDelta DECIMAL(18,2) = (@CostPrice - @OldCostPrice) * @QtyOnHand
                DECLARE @Description NVARCHAR(500) = 'Inventory Revaluation: ' + @ProductName + ' (' + @SKU + ') - Old Cost: R' + CAST(@OldCostPrice AS NVARCHAR(20)) + ', New Cost: R' + CAST(@CostPrice AS NVARCHAR(20)) + ', Qty: ' + CAST(@QtyOnHand AS NVARCHAR(20))
                
                IF ABS(@CostDelta) > 0.01
                BEGIN
                    DECLARE @JournalID INT
                    INSERT INTO Journals (BranchID, JournalDate, Description, Reference, CreatedAt, CreatedBy)
                    VALUES (@BranchID, GETDATE(), @Description, 'REVALUE-' + CONVERT(VARCHAR, GETDATE(), 112), GETDATE(), 1)
                    
                    SET @JournalID = SCOPE_IDENTITY()
                    
                    DECLARE @InventoryAccountID INT, @RevalReserveAccountID INT
                    SELECT @InventoryAccountID = AccountID FROM Accounts WHERE AccountCode = '1300'
                    SELECT @RevalReserveAccountID = AccountID FROM Accounts WHERE AccountCode = '3500'
                    
                    IF @CostDelta > 0
                    BEGIN
                        -- Cost increase: DR Inventory, CR Inventory Revaluation Reserve
                        INSERT INTO JournalLines (JournalID, LineNumber, AccountID, Debit, Credit, LineDescription)
                        VALUES (@JournalID, 1, @InventoryAccountID, ABS(@CostDelta), 0, @Description)
                        
                        INSERT INTO JournalLines (JournalID, LineNumber, AccountID, Debit, Credit, LineDescription)
                        VALUES (@JournalID, 2, @RevalReserveAccountID, 0, ABS(@CostDelta), @Description)
                    END
                    ELSE
                    BEGIN
                        -- Cost decrease: DR Inventory Revaluation Reserve, CR Inventory
                        INSERT INTO JournalLines (JournalID, LineNumber, AccountID, Debit, Credit, LineDescription)
                        VALUES (@JournalID, 1, @RevalReserveAccountID, ABS(@CostDelta), 0, @Description)
                        
                        INSERT INTO JournalLines (JournalID, LineNumber, AccountID, Debit, Credit, LineDescription)
                        VALUES (@JournalID, 2, @InventoryAccountID, 0, ABS(@CostDelta), @Description)
                    END
                END
            END"
        
        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@SKU", sku)
            cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
            cmd.Parameters.AddWithValue("@SellingPrice", If(sellingPrice.HasValue, CObj(sellingPrice.Value), DBNull.Value))
            cmd.Parameters.AddWithValue("@CostPrice", If(costPrice.HasValue, CObj(costPrice.Value), DBNull.Value))
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
    Private Sub BtnSave_Click(sender As Object, e As EventArgs)
        Try
            Dim dgv As DataGridView = DirectCast(Me.Controls.Find("dgvStock", True)(0), DataGridView)
            Dim saved As Integer = 0
            
            Using conn As New SqlConnection(connString)
                conn.Open()
                
                For Each row As DataGridViewRow In dgv.Rows
                    If Not row.IsNewRow AndAlso row.Cells("SKU").Value IsNot Nothing Then
                        Dim sku = row.Cells("SKU").Value.ToString()
                        Dim stock = CDec(row.Cells("CurrentStock").Value)
                        Dim selling = CDec(row.Cells("SellingPrice").Value)
                        Dim cost = CDec(row.Cells("CostPrice").Value)
                        
                        UpdateStock(conn, sku, stock)
                        UpdatePrices(conn, sku, selling, cost)
                        saved += 1
                    End If
                Next
            End Using
            
            MessageBox.Show($"Successfully saved {saved} products!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            LoadStockData()
        Catch ex As Exception
            MessageBox.Show($"Error saving data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub TxtSearch_TextChanged(sender As Object, e As EventArgs)
        Dim dgv As DataGridView = DirectCast(Me.Controls.Find("dgvStock", True)(0), DataGridView)
        Dim txt As TextBox = DirectCast(sender, TextBox)
        
        If dgv.DataSource IsNot Nothing Then
            Dim dv As DataView = DirectCast(dgv.DataSource, DataTable).DefaultView
            If String.IsNullOrWhiteSpace(txt.Text) Then
                dv.RowFilter = ""
            Else
                dv.RowFilter = $"ProductName LIKE '%{txt.Text}%' OR SKU LIKE '%{txt.Text}%' OR Category LIKE '%{txt.Text}%'"
            End If
        End If
    End Sub
End Class
