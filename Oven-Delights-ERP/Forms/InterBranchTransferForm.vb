Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Drawing.Printing

Namespace Forms

    Public Class InterBranchTransferForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        ' Logo colors matching AddProductForm
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(230, 126, 34)
        Private ReadOnly ColorDark As Color = Color.FromArgb(110, 44, 0)
        Private ReadOnly ColorLight As Color = Color.FromArgb(245, 222, 179)

        Private cmbFromBranch As ComboBox
        Private cmbToBranch As ComboBox
        Private cmbProduct As ComboBox
        Private txtQuantity As TextBox
        Private txtUnitCost As TextBox
        Private txtTotalValue As TextBox
        Private txtNotes As TextBox
        Private chkGeneratePO As CheckBox
        Private btnSave As Button
        Private btnPrint As Button
        Private btnEmail As Button
        Private btnCancel As Button

        Private _generatedPONumber As String = ""
        Private _transferId As Integer = 0
        Private _isLoading As Boolean = True

        Public Sub New()
            Me.Text = "Inter-Branch Transfer - Oven Delights"
            Me.Width = 900
            Me.Height = 750
            Me.StartPosition = FormStartPosition.CenterParent
            Me.BackColor = Color.White
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            InitializeUI()
            LoadBranches()
            LoadProducts()
            _isLoading = False
        End Sub

        Private Sub InitializeUI()
            ' Header Panel with professional styling
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 100,
                .BackColor = ColorDark
            }
            
            Dim lblHeader As New Label() With {
                .Text = "✨ Inter-Branch Transfer",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Left = 30,
                .Top = 30
            }
            
            Dim lblSubHeader As New Label() With {
                .Text = "Transfer products between branches and generate purchase orders",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorLight,
                .AutoSize = True,
                .Left = 30,
                .Top = 62
            }
            
            pnlHeader.Controls.AddRange({lblHeader, lblSubHeader})

            ' Main content panel
            Dim pnlContent As New Panel() With {
                .Left = 30,
                .Top = 120,
                .Width = 820,
                .Height = 480,
                .BackColor = Color.White
            }

            Dim labelFont As New Font("Segoe UI", 10, FontStyle.Bold)
            Dim y As Integer = 0

            ' From Branch
            Dim lblFromBranch As New Label() With {
                .Text = "From Branch (Sender) *",
                .Left = 0,
                .Top = y,
                .Width = 200,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            cmbFromBranch = New ComboBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 380,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10)
            }
            AddHandler cmbFromBranch.SelectedIndexChanged, AddressOf OnFromBranchChanged

            ' To Branch
            Dim lblToBranch As New Label() With {
                .Text = "To Branch (Receiver) *",
                .Left = 420,
                .Top = y,
                .Width = 200,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            cmbToBranch = New ComboBox() With {
                .Left = 420,
                .Top = y + 25,
                .Width = 380,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10)
            }

            y += 80

            ' Product
            Dim lblProduct As New Label() With {
                .Text = "Product *",
                .Left = 0,
                .Top = y,
                .Width = 200,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            cmbProduct = New ComboBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 800,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10)
            }
            AddHandler cmbProduct.SelectedIndexChanged, AddressOf OnProductChanged

            y += 80

            ' Quantity, Unit Cost, Total Value
            Dim lblQuantity As New Label() With {
                .Text = "Quantity *",
                .Left = 0,
                .Top = y,
                .Width = 150,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            txtQuantity = New TextBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 150,
                .Font = New Font("Segoe UI", 10)
            }
            AddHandler txtQuantity.TextChanged, AddressOf CalculateTotalValue

            Dim lblUnitCost As New Label() With {
                .Text = "Unit Cost (R)",
                .Left = 200,
                .Top = y,
                .Width = 150,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            txtUnitCost = New TextBox() With {
                .Left = 200,
                .Top = y + 25,
                .Width = 150,
                .Font = New Font("Segoe UI", 10),
                .ReadOnly = True,
                .BackColor = ColorLight
            }

            Dim lblTotalValue As New Label() With {
                .Text = "Total Value (R)",
                .Left = 400,
                .Top = y,
                .Width = 150,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            txtTotalValue = New TextBox() With {
                .Left = 400,
                .Top = y + 25,
                .Width = 150,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .ReadOnly = True,
                .BackColor = ColorLight
            }

            y += 80

            ' Notes
            Dim lblNotes As New Label() With {
                .Text = "Notes / Reference",
                .Left = 0,
                .Top = y,
                .Width = 200,
                .Font = labelFont,
                .ForeColor = ColorDark
            }
            txtNotes = New TextBox() With {
                .Left = 0,
                .Top = y + 25,
                .Width = 800,
                .Height = 80,
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .Font = New Font("Segoe UI", 10)
            }

            y += 130

            ' Generate PO checkbox
            chkGeneratePO = New CheckBox() With {
                .Text = "✓ Generate Inter-Branch Purchase Order (INT-PO)",
                .Left = 0,
                .Top = y,
                .Width = 400,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .ForeColor = ColorDark,
                .Checked = True
            }

            pnlContent.Controls.AddRange({
                lblFromBranch, cmbFromBranch, lblToBranch, cmbToBranch,
                lblProduct, cmbProduct, lblQuantity, txtQuantity,
                lblUnitCost, txtUnitCost, lblTotalValue, txtTotalValue,
                lblNotes, txtNotes, chkGeneratePO
            })

            ' Button panel
            Dim pnlButtons As New Panel() With {
                .Dock = DockStyle.Bottom,
                .Height = 80,
                .BackColor = Color.White,
                .Padding = New Padding(30, 15, 30, 15)
            }

            btnSave = New Button() With {
                .Text = "💾 Save Transfer",
                .Left = 30,
                .Top = 15,
                .Width = 150,
                .Height = 45,
                .BackColor = ColorPrimary,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnSave.FlatAppearance.BorderSize = 0
            AddHandler btnSave.Click, AddressOf BtnSave_Click

            btnPrint = New Button() With {
                .Text = "🖨 Print PO",
                .Left = 200,
                .Top = 15,
                .Width = 130,
                .Height = 45,
                .BackColor = Color.Gray,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand,
                .Enabled = False
            }
            btnPrint.FlatAppearance.BorderSize = 0
            AddHandler btnPrint.Click, AddressOf BtnPrint_Click

            btnEmail = New Button() With {
                .Text = "📧 Email PO",
                .Left = 350,
                .Top = 15,
                .Width = 130,
                .Height = 45,
                .BackColor = Color.Gray,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand,
                .Enabled = False
            }
            btnEmail.FlatAppearance.BorderSize = 0
            AddHandler btnEmail.Click, AddressOf BtnEmail_Click

            btnCancel = New Button() With {
                .Text = "✖ Cancel",
                .Left = 720,
                .Top = 15,
                .Width = 130,
                .Height = 45,
                .BackColor = Color.FromArgb(183, 58, 46),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnCancel.FlatAppearance.BorderSize = 0
            AddHandler btnCancel.Click, Sub(s, ev) Me.Close()

            pnlButtons.Controls.AddRange({btnSave, btnPrint, btnEmail, btnCancel})

            Me.Controls.Add(pnlButtons)
            Me.Controls.Add(pnlContent)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadBranches()
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql As String = "SELECT BranchID, BranchName, BranchCode FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                    Using cmd As New SqlCommand(sql, con)
                        Dim dt As New DataTable()
                        Using reader = cmd.ExecuteReader()
                            dt.Load(reader)
                        End Using

                        cmbFromBranch.DisplayMember = "BranchName"
                        cmbFromBranch.ValueMember = "BranchID"
                        cmbFromBranch.DataSource = dt.Copy()

                        cmbToBranch.DisplayMember = "BranchName"
                        cmbToBranch.ValueMember = "BranchID"
                        cmbToBranch.DataSource = dt.Copy()
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadProducts()
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql As String = "SELECT ProductID, SKU, Name FROM demo_Retail_product WHERE IsActive = 1 ORDER BY Name"
                    Using cmd As New SqlCommand(sql, con)
                        Dim dt As New DataTable()
                        Using reader = cmd.ExecuteReader()
                            dt.Load(reader)
                        End Using

                        dt.Columns.Add("DisplayText", GetType(String), "SKU + ' - ' + Name")

                        cmbProduct.DisplayMember = "DisplayText"
                        cmbProduct.ValueMember = "ProductID"
                        cmbProduct.DataSource = dt
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnFromBranchChanged(sender As Object, e As EventArgs)
            If _isLoading Then Return
            
            If cmbFromBranch.SelectedValue IsNot Nothing AndAlso cmbToBranch.SelectedValue IsNot Nothing Then
                If cmbFromBranch.SelectedValue.Equals(cmbToBranch.SelectedValue) Then
                    MessageBox.Show("From and To branches must be different!", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    cmbToBranch.SelectedIndex = -1
                End If
            End If
            
            ' Refresh product price when branch changes
            If cmbProduct.SelectedValue IsNot Nothing Then
                OnProductChanged(Nothing, Nothing)
            End If
        End Sub

        Private Sub OnProductChanged(sender As Object, e As EventArgs)
            If _isLoading Then Return
            
            If cmbProduct.SelectedValue Is Nothing Then 
                txtUnitCost.Text = "0.00"
                Return
            End If
            
            If cmbFromBranch.SelectedValue Is Nothing Then
                txtUnitCost.Text = "0.00"
                Return
            End If

            Try
                Dim productId As Integer = Convert.ToInt32(cmbProduct.SelectedValue)
                Dim branchId As Integer = Convert.ToInt32(cmbFromBranch.SelectedValue)
                
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    
                    ' Debug: Show what we're searching for
                    'MessageBox.Show($"Looking for ProductID: {productId}, BranchID: {branchId}", "Debug")
                    
                    Dim sql As String = "SELECT TOP 1 CostPrice FROM demo_Retail_price WHERE ProductID = @pid AND BranchID = @bid AND CostPrice > 0 ORDER BY EffectiveFrom DESC"
                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@pid", productId)
                        cmd.Parameters.AddWithValue("@bid", branchId)
                        Dim result = cmd.ExecuteScalar()
                        
                        If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                            Dim cost As Decimal = Convert.ToDecimal(result)
                            txtUnitCost.Text = cost.ToString("F2")
                        Else
                            ' No price found in demo_Retail_price
                            MessageBox.Show($"No cost price found for ProductID {productId} in BranchID {branchId}", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                            txtUnitCost.Text = "0.00"
                        End If
                    End Using
                End Using
                CalculateTotalValue(Nothing, Nothing)
            Catch ex As Exception
                MessageBox.Show($"Error loading cost price: {ex.Message}{vbCrLf}ProductID: {cmbProduct.SelectedValue}{vbCrLf}BranchID: {cmbFromBranch.SelectedValue}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                txtUnitCost.Text = "0.00"
            End Try
        End Sub

        Private Sub CalculateTotalValue(sender As Object, e As EventArgs)
            Try
                Dim qty As Decimal = 0
                Dim cost As Decimal = 0
                Decimal.TryParse(txtQuantity.Text, qty)
                Decimal.TryParse(txtUnitCost.Text, cost)
                txtTotalValue.Text = (qty * cost).ToString("F2")
            Catch
                txtTotalValue.Text = "0.00"
            End Try
        End Sub

        Private Sub BtnSave_Click(sender As Object, e As EventArgs)
            ' Validation
            If cmbFromBranch.SelectedValue Is Nothing Then
                MessageBox.Show("Please select From Branch.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If cmbToBranch.SelectedValue Is Nothing Then
                MessageBox.Show("Please select To Branch.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If cmbFromBranch.SelectedValue.Equals(cmbToBranch.SelectedValue) Then
                MessageBox.Show("From and To branches must be different!", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If cmbProduct.SelectedValue Is Nothing Then
                MessageBox.Show("Please select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim qty As Decimal = 0
            If Not Decimal.TryParse(txtQuantity.Text, qty) OrElse qty <= 0 Then
                MessageBox.Show("Please enter a valid quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim unitCost As Decimal = 0
            If Not Decimal.TryParse(txtUnitCost.Text, unitCost) OrElse unitCost <= 0 Then
                MessageBox.Show("Unit cost must be greater than zero.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Using tx = con.BeginTransaction()
                        Try
                            Dim fromBranchId As Integer = Convert.ToInt32(cmbFromBranch.SelectedValue)
                            Dim toBranchId As Integer = Convert.ToInt32(cmbToBranch.SelectedValue)
                            Dim productId As Integer = Convert.ToInt32(cmbProduct.SelectedValue)
                            Dim totalValue As Decimal = Convert.ToDecimal(txtTotalValue.Text)

                            ' Create transfer order with status 'Pending'
                            _transferId = CreateTransferOrder(fromBranchId, toBranchId, productId, qty, unitCost, totalValue, con, tx)
                            
                            ' Generate PO if checked
                            If chkGeneratePO.Checked Then
                                _generatedPONumber = CreateInterBranchPO(fromBranchId, toBranchId, productId, qty, unitCost, totalValue, _transferId, con, tx)
                            End If

                            tx.Commit()

                            MessageBox.Show($"Transfer created successfully with status 'Pending'!{vbCrLf}Transfer ID: {_transferId}{If(chkGeneratePO.Checked, vbCrLf & "PO Number: " & _generatedPONumber, "")}{vbCrLf}{vbCrLf}Use 'Dispatch' to set status to 'In Transit' and reduce inventory.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            
                            ' Enable print/email buttons
                            If chkGeneratePO.Checked Then
                                btnPrint.Enabled = True
                                btnEmail.Enabled = True
                                btnPrint.BackColor = ColorPrimary
                                btnEmail.BackColor = ColorPrimary
                            End If

                            btnSave.Enabled = False
                        Catch
                            tx.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error saving transfer: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function CreateTransferOrder(fromBranchId As Integer, toBranchId As Integer, productId As Integer, quantity As Decimal, unitCost As Decimal, totalValue As Decimal, con As SqlConnection, tx As SqlTransaction) As Integer
            ' Generate transfer number: BranchCode-IBT-#####
            Dim branchCode As String = GetBranchPrefix(fromBranchId, con, tx)
            
            Dim nextNumber As Integer = 1
            Using cmdNext As New SqlCommand("SELECT ISNULL(MAX(CAST(RIGHT(TransferNumber, 5) AS INT)), 0) + 1 FROM InterBranchTransfers WHERE FromBranchID = @BranchID AND TransferNumber LIKE @Pattern", con, tx)
                cmdNext.Parameters.AddWithValue("@BranchID", fromBranchId)
                cmdNext.Parameters.AddWithValue("@Pattern", branchCode + "-IBT-%")
                Dim result = cmdNext.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    nextNumber = Convert.ToInt32(result)
                End If
            End Using
            
            Dim transferNumber As String = $"{branchCode}-IBT-{nextNumber.ToString("00000")}"
            
            ' Create transfer record with status 'Pending'
            Dim sql As String = "INSERT INTO InterBranchTransfers (TransferNumber, FromBranchID, ToBranchID, ProductID, Quantity, UnitCost, TotalValue, Status, Notes, CreatedBy, CreatedDate) " &
                               "VALUES (@number, @from, @to, @product, @qty, @cost, @total, 'Pending', @notes, @user, GETDATE()); SELECT SCOPE_IDENTITY()"
            
            Dim transferId As Integer
            Using cmd As New SqlCommand(sql, con, tx)
                cmd.Parameters.AddWithValue("@number", transferNumber)
                cmd.Parameters.AddWithValue("@from", fromBranchId)
                cmd.Parameters.AddWithValue("@to", toBranchId)
                cmd.Parameters.AddWithValue("@product", productId)
                cmd.Parameters.AddWithValue("@qty", quantity)
                cmd.Parameters.AddWithValue("@cost", unitCost)
                cmd.Parameters.AddWithValue("@total", totalValue)
                cmd.Parameters.AddWithValue("@notes", If(String.IsNullOrEmpty(txtNotes.Text), DBNull.Value, CObj(txtNotes.Text)))
                cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                transferId = Convert.ToInt32(cmd.ExecuteScalar())
            End Using
            
            Return transferId
        End Function
        
        Private Function CreateInterBranchPO(fromBranchId As Integer, toBranchId As Integer, productId As Integer, quantity As Decimal, unitCost As Decimal, totalValue As Decimal, transferId As Integer, con As SqlConnection, tx As SqlTransaction) As String
            ' Generate INT-PO number: BranchPrefix-INT-PO-#####
            Dim branchPrefix As String = GetBranchPrefix(fromBranchId, con, tx)
            
            Dim nextNumber As Integer = 1
            Using cmdNext As New SqlCommand("SELECT ISNULL(MAX(CAST(RIGHT(PONumber, 5) AS INT)), 0) + 1 FROM PurchaseOrders WHERE BranchID = @BranchID AND PONumber LIKE @Pattern", con, tx)
                cmdNext.Parameters.AddWithValue("@BranchID", fromBranchId)
                cmdNext.Parameters.AddWithValue("@Pattern", branchPrefix + "-INT-PO-%")
                Dim result = cmdNext.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    nextNumber = Convert.ToInt32(result)
                End If
            End Using
            
            Dim intPONumber As String = $"{branchPrefix}-INT-PO-{nextNumber.ToString("00000")}"
            
            ' Create PO record linked to transfer
            ' Use ToBranchID as SupplierID (4 for Umhlanga, 6 for Ayesha Court)
            Dim sqlPO As String = "INSERT INTO PurchaseOrders (PONumber, SupplierID, BranchID, OrderDate, Status, CreatedBy, CreatedDate, POType, TransferID) " &
                                 "VALUES (@po, @supplier, @branch, GETDATE(), 'Pending', @user, GETDATE(), 'Inter-Branch', @transferId); SELECT SCOPE_IDENTITY()"
            
            Dim poId As Integer
            Using cmd As New SqlCommand(sqlPO, con, tx)
                cmd.Parameters.AddWithValue("@po", intPONumber)
                cmd.Parameters.AddWithValue("@supplier", toBranchId)
                cmd.Parameters.AddWithValue("@branch", fromBranchId)
                cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                cmd.Parameters.AddWithValue("@transferId", transferId)
                poId = Convert.ToInt32(cmd.ExecuteScalar())
            End Using
            
            ' NOTE: PO line items will be added when the PO is processed
            ' For now, the transfer record contains all the details needed
            ' Accounting entries will be posted when transfer is DISPATCHED, not on creation
            
            Return intPONumber
        End Function

        Private Sub PostInterBranchTransferToLedger(fromBranchId As Integer, toBranchId As Integer, productId As Integer, amount As Decimal, reference As String, con As SqlConnection, tx As SqlTransaction)
            ' Get product ledger code with i/x prefix
            Dim ledgerCode As String = GetProductLedgerCode(productId, con, tx)
            Dim transDate As DateTime = DateTime.Now
            
            ' SENDER BRANCH (From Branch):
            ' DR: Inter-Branch Debtors (Receivable from To Branch)
            ' CR: Inventory (Reduce inventory)
            
            ' Debit: Inter-Branch Debtors
            PostToJournal(fromBranchId, "Inter-Branch Debtors", ledgerCode, amount, 0, reference, "Inter-branch transfer - Debtors", transDate, con, tx)
            
            ' Credit: Inventory
            PostToJournal(fromBranchId, "Inventory", ledgerCode, 0, amount, reference, "Inter-branch transfer - Inventory reduction", transDate, con, tx)
            
            ' RECEIVER BRANCH (To Branch):
            ' DR: Inventory (Increase inventory)
            ' CR: Inter-Branch Creditors (Payable to From Branch)
            
            ' Debit: Inventory
            PostToJournal(toBranchId, "Inventory", ledgerCode, amount, 0, reference, "Inter-branch transfer - Inventory increase", transDate, con, tx)
            
            ' Credit: Inter-Branch Creditors
            PostToJournal(toBranchId, "Inter-Branch Creditors", ledgerCode, 0, amount, reference, "Inter-branch transfer - Creditors", transDate, con, tx)
        End Sub

        Private Function GetProductLedgerCode(productId As Integer, con As SqlConnection, tx As SqlTransaction) As String
            ' Get product category and return ledger code with prefix
            ' i = internal (manufactured), x = external (purchased)
            Using cmd As New SqlCommand("SELECT Category FROM demo_Retail_product WHERE ProductID = @id", con, tx)
                cmd.Parameters.AddWithValue("@id", productId)
                Dim category = cmd.ExecuteScalar()?.ToString()
                
                ' Assume biscuit category is manufactured (internal), others are external
                If category IsNot Nothing AndAlso category.ToLower().Contains("biscuit") Then
                    Return $"i-PROD-{productId}"
                Else
                    Return $"x-PROD-{productId}"
                End If
            End Using
        End Function

        Private Sub PostToJournal(branchId As Integer, accountType As String, ledgerCode As String, debit As Decimal, credit As Decimal, reference As String, description As String, transDate As DateTime, con As SqlConnection, tx As SqlTransaction)
            ' Post journal entry
            Dim sql As String = "INSERT INTO JournalEntries (BranchID, AccountType, LedgerCode, DebitAmount, CreditAmount, Reference, Description, TransactionDate, CreatedBy, CreatedDate) " &
                               "VALUES (@branch, @account, @ledger, @debit, @credit, @ref, @desc, @date, @user, GETDATE())"
            
            Using cmd As New SqlCommand(sql, con, tx)
                cmd.Parameters.AddWithValue("@branch", branchId)
                cmd.Parameters.AddWithValue("@account", accountType)
                cmd.Parameters.AddWithValue("@ledger", ledgerCode)
                cmd.Parameters.AddWithValue("@debit", debit)
                cmd.Parameters.AddWithValue("@credit", credit)
                cmd.Parameters.AddWithValue("@ref", reference)
                cmd.Parameters.AddWithValue("@desc", description)
                cmd.Parameters.AddWithValue("@date", transDate)
                cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                cmd.ExecuteNonQuery()
            End Using
        End Sub

        Private Function GetBranchPrefix(branchId As Integer, con As SqlConnection, tx As SqlTransaction) As String
            Using cmd As New SqlCommand("SELECT BranchCode FROM Branches WHERE BranchID = @id", con, tx)
                cmd.Parameters.AddWithValue("@id", branchId)
                Dim result = cmd.ExecuteScalar()
                Return If(result IsNot Nothing, result.ToString(), "UNK")
            End Using
        End Function

        Private Function GetBranchName(branchId As Integer, con As SqlConnection, tx As SqlTransaction) As String
            Using cmd As New SqlCommand("SELECT BranchName FROM Branches WHERE BranchID = @id", con, tx)
                cmd.Parameters.AddWithValue("@id", branchId)
                Dim result = cmd.ExecuteScalar()
                Return If(result IsNot Nothing, result.ToString(), "Unknown")
            End Using
        End Function

        Private Sub BtnPrint_Click(sender As Object, e As EventArgs)
            If String.IsNullOrEmpty(_generatedPONumber) Then
                MessageBox.Show("No PO generated to print.", "Print", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Dim printDoc As New PrintDocument()
                AddHandler printDoc.PrintPage, Sub(s, ev)
                    PrintPODocument(ev)
                End Sub
                
                Dim printDialog As New PrintDialog() With {.Document = printDoc}
                If printDialog.ShowDialog() = DialogResult.OK Then
                    printDoc.Print()
                    MessageBox.Show("PO sent to printer!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            Catch ex As Exception
                MessageBox.Show($"Error printing PO: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub PrintPODocument(e As PrintPageEventArgs)
            Dim font As New Font("Arial", 10)
            Dim headerFont As New Font("Arial", 16, FontStyle.Bold)
            Dim subHeaderFont As New Font("Arial", 12, FontStyle.Bold)
            Dim y As Single = 50
            
            ' Company header
            e.Graphics.DrawString("OVEN DELIGHTS", headerFont, New SolidBrush(ColorDark), 50, y)
            y += 30
            e.Graphics.DrawString("Inter-Branch Purchase Order", subHeaderFont, Brushes.Gray, 50, y)
            y += 40
            
            ' PO Details
            e.Graphics.DrawString($"PO Number: {_generatedPONumber}", New Font("Arial", 12, FontStyle.Bold), Brushes.Black, 50, y)
            y += 25
            e.Graphics.DrawString($"Date: {DateTime.Now:dd/MM/yyyy}", font, Brushes.Black, 50, y)
            y += 25
            e.Graphics.DrawString($"From Branch: {cmbFromBranch.Text}", font, Brushes.Black, 50, y)
            y += 20
            e.Graphics.DrawString($"To Branch: {cmbToBranch.Text}", font, Brushes.Black, 50, y)
            y += 40
            
            ' Line separator
            e.Graphics.DrawString(New String("-"c, 100), font, Brushes.Black, 50, y)
            y += 30
            
            ' Product details
            e.Graphics.DrawString("PRODUCT DETAILS:", New Font("Arial", 11, FontStyle.Bold), Brushes.Black, 50, y)
            y += 30
            e.Graphics.DrawString($"Product: {cmbProduct.Text}", font, Brushes.Black, 50, y)
            y += 25
            e.Graphics.DrawString($"Quantity: {txtQuantity.Text}", font, Brushes.Black, 50, y)
            y += 25
            e.Graphics.DrawString($"Unit Cost: R {txtUnitCost.Text}", font, Brushes.Black, 50, y)
            y += 25
            e.Graphics.DrawString($"Total Value: R {txtTotalValue.Text}", New Font("Arial", 11, FontStyle.Bold), Brushes.Black, 50, y)
            y += 40
            
            ' Notes
            If Not String.IsNullOrWhiteSpace(txtNotes.Text) Then
                e.Graphics.DrawString("Notes:", New Font("Arial", 10, FontStyle.Bold), Brushes.Black, 50, y)
                y += 25
                e.Graphics.DrawString(txtNotes.Text, font, Brushes.Black, 50, y)
            End If
        End Sub

        Private Sub BtnEmail_Click(sender As Object, e As EventArgs)
            If String.IsNullOrEmpty(_generatedPONumber) Then
                MessageBox.Show("No PO generated to email.", "Email", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            ' Prompt for email address
            Dim emailAddress As String = InputBox("Enter recipient email address:", "Email PO", "")
            If String.IsNullOrWhiteSpace(emailAddress) Then Return

            Try
                ' Create email body
                Dim body As New System.Text.StringBuilder()
                body.AppendLine("OVEN DELIGHTS - Inter-Branch Purchase Order")
                body.AppendLine()
                body.AppendLine($"PO Number: {_generatedPONumber}")
                body.AppendLine($"Date: {DateTime.Now:dd/MM/yyyy}")
                body.AppendLine($"From Branch: {cmbFromBranch.Text}")
                body.AppendLine($"To Branch: {cmbToBranch.Text}")
                body.AppendLine()
                body.AppendLine("PRODUCT DETAILS:")
                body.AppendLine($"Product: {cmbProduct.Text}")
                body.AppendLine($"Quantity: {txtQuantity.Text}")
                body.AppendLine($"Unit Cost: R {txtUnitCost.Text}")
                body.AppendLine($"Total Value: R {txtTotalValue.Text}")
                body.AppendLine()
                If Not String.IsNullOrWhiteSpace(txtNotes.Text) Then
                    body.AppendLine("Notes:")
                    body.AppendLine(txtNotes.Text)
                End If

                ' Show success message (actual email sending would require SMTP configuration)
                MessageBox.Show($"PO would be emailed to: {emailAddress}{vbCrLf}{vbCrLf}(Email functionality requires SMTP configuration)", "Email", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Catch ex As Exception
                MessageBox.Show($"Error preparing email: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

    End Class

End Namespace
