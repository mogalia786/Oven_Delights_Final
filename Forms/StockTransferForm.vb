Imports System.Windows.Forms
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class StockTransferForm
    Inherits Form

    Private currentUser As User
    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private service As New StockroomService()
    
    Private cboFromBranch As ComboBox
    Private cboToBranch As ComboBox
    Private cboProduct As ComboBox
    Private txtQuantity As TextBox
    Private txtReference As TextBox
    Private dtpTransferDate As DateTimePicker
    Private btnCreateTransfer As Button

    ' Parameterless constructor for design-time support
    Public Sub New()
        InitializeComponent()
        InitializeCustomControls()
        LoadBranches()
        LoadProducts()
        LoadTransfers()
    End Sub

    Public Sub New(user As User)
        InitializeComponent()
        currentUser = user
        InitializeCustomControls()
        LoadBranches()
        LoadProducts()
        LoadTransfers()
    End Sub

    Private Sub InitializeCustomControls()
        Me.Text = "Inter-Branch Stock Transfer"
        Me.WindowState = FormWindowState.Maximized
        
        ' Header panel
        Dim headerPanel As New Panel With {.Dock = DockStyle.Top, .Height = 200, .Padding = New Padding(12), .BackColor = Color.FromArgb(240, 240, 240)}
        
        ' From Branch
        Dim lblFromBranch As New Label With {.Text = "From Branch:", .Top = 12, .Left = 12, .AutoSize = True}
        cboFromBranch = New ComboBox With {.Top = 30, .Left = 12, .Width = 250, .DropDownStyle = ComboBoxStyle.DropDownList}
        
        ' To Branch
        Dim lblToBranch As New Label With {.Text = "To Branch:", .Top = 12, .Left = 280, .AutoSize = True}
        cboToBranch = New ComboBox With {.Top = 30, .Left = 280, .Width = 250, .DropDownStyle = ComboBoxStyle.DropDownList}
        
        ' Product
        Dim lblProduct As New Label With {.Text = "Product:", .Top = 70, .Left = 12, .AutoSize = True}
        cboProduct = New ComboBox With {.Top = 88, .Left = 12, .Width = 400, .DropDownStyle = ComboBoxStyle.DropDownList}
        
        ' Quantity
        Dim lblQuantity As New Label With {.Text = "Quantity:", .Top = 70, .Left = 430, .AutoSize = True}
        txtQuantity = New TextBox With {.Top = 88, .Left = 430, .Width = 100}
        
        ' Transfer Date
        Dim lblDate As New Label With {.Text = "Transfer Date:", .Top = 130, .Left = 12, .AutoSize = True}
        dtpTransferDate = New DateTimePicker With {.Top = 148, .Left = 12, .Width = 200, .Format = DateTimePickerFormat.Short}
        dtpTransferDate.Value = DateTime.Today
        
        ' Reference
        Dim lblReference As New Label With {.Text = "Reference:", .Top = 130, .Left = 230, .AutoSize = True}
        txtReference = New TextBox With {.Top = 148, .Left = 230, .Width = 300}
        
        ' Create Transfer Button
        btnCreateTransfer = New Button With {.Text = "Create Transfer", .Top = 148, .Left = 550, .Width = 150, .Height = 30, .BackColor = Color.FromArgb(46, 204, 113), .ForeColor = Color.White, .FlatStyle = FlatStyle.Flat}
        AddHandler btnCreateTransfer.Click, AddressOf btnCreateTransfer_Click
        
        headerPanel.Controls.AddRange({lblFromBranch, cboFromBranch, lblToBranch, cboToBranch, lblProduct, cboProduct, lblQuantity, txtQuantity, lblDate, dtpTransferDate, lblReference, txtReference, btnCreateTransfer})
        
        ' Use existing grid from Designer and configure it
        dgvTransfers.Dock = DockStyle.Fill
        dgvTransfers.AllowUserToAddRows = False
        dgvTransfers.AllowUserToDeleteRows = False
        dgvTransfers.ReadOnly = True
        dgvTransfers.AutoGenerateColumns = True
        
        ' Add header panel to form (it will dock to top, grid stays below)
        Me.Controls.Add(headerPanel)
        headerPanel.BringToFront()
    End Sub

    Private Sub LoadBranches()
        Try
            Dim branches = service.GetBranchesLookup()
            If branches IsNot Nothing AndAlso branches.Rows.Count > 0 Then
                cboFromBranch.DataSource = branches.Copy()
                cboFromBranch.DisplayMember = "BranchName"
                cboFromBranch.ValueMember = "BranchID"
                
                cboToBranch.DataSource = branches.Copy()
                cboToBranch.DisplayMember = "BranchName"
                cboToBranch.ValueMember = "BranchID"
                
                ' Check if user is Super Administrator
                Dim isSuperAdmin As Boolean = (AppSession.CurrentRoleName = "Super Administrator")
                
                ' If not Super Admin, lock From Branch to current user's branch
                If Not isSuperAdmin AndAlso AppSession.CurrentBranchID > 0 Then
                    ' Set From Branch to current user's branch and disable
                    cboFromBranch.SelectedValue = AppSession.CurrentBranchID
                    cboFromBranch.Enabled = False
                End If
            End If
        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadProducts()
        Try
            Using con As New SqlConnection(connectionString)
                Dim sql = "SELECT ProductID, ProductCode, ProductName FROM Products WHERE ISNULL(IsActive, 1) = 1 ORDER BY ProductName"
                Using ad As New SqlDataAdapter(sql, con)
                    Dim dt As New DataTable()
                    ad.Fill(dt)
                    cboProduct.DataSource = dt
                    cboProduct.DisplayMember = "ProductName"
                    cboProduct.ValueMember = "ProductID"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadTransfers()
        Try
            Using con As New SqlConnection(connectionString)
                Dim sql = "SELECT TOP 100 TransferID, TransferNumber, FromBranchID, ToBranchID, TransferDate, Status, CreatedDate FROM InterBranchTransfers ORDER BY TransferID DESC"
                Using ad As New SqlDataAdapter(sql, con)
                    Dim dt As New DataTable()
                    ad.Fill(dt)
                    dgvTransfers.DataSource = dt
                End Using
            End Using
        Catch ex As Exception
            ' Table might not exist yet
            dgvTransfers.DataSource = Nothing
        End Try
    End Sub

    Private Sub btnCreateTransfer_Click(sender As Object, e As EventArgs)
        Try
            If cboFromBranch.SelectedValue Is Nothing OrElse cboToBranch.SelectedValue Is Nothing Then
                MessageBox.Show("Please select both From and To branches.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim fromBranchId As Integer = Convert.ToInt32(cboFromBranch.SelectedValue)
            Dim toBranchId As Integer = Convert.ToInt32(cboToBranch.SelectedValue)
            
            If fromBranchId = toBranchId Then
                MessageBox.Show("From and To branches must be different.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If cboProduct.SelectedValue Is Nothing Then
                MessageBox.Show("Please select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim qty As Decimal
            If Not Decimal.TryParse(txtQuantity.Text, qty) OrElse qty <= 0 Then
                MessageBox.Show("Please enter a valid quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim productId As Integer = Convert.ToInt32(cboProduct.SelectedValue)
            
            ' Create transfer
            CreateInterBranchTransfer(fromBranchId, toBranchId, productId, qty, dtpTransferDate.Value, txtReference.Text.Trim())
            
            MessageBox.Show("Inter-branch transfer created successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            
            LoadTransfers()
            ClearForm()
            
        Catch ex As Exception
            MessageBox.Show($"Error creating transfer: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub CreateInterBranchTransfer(fromBranchId As Integer, toBranchId As Integer, productId As Integer, quantity As Decimal, transferDate As DateTime, reference As String)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Generate transfer number
                    Dim fromBranchCode As String = GetBranchCode(fromBranchId, con, tx)
                    Dim transferNumber As String = $"{fromBranchCode}-iTrans-{DateTime.Now:yyyyMMddHHmmss}"
                    
                    ' Get product cost
                    Dim productCost As Decimal = GetProductCost(productId, fromBranchId, con, tx)
                    Dim totalValue As Decimal = quantity * productCost
                    
                    ' Create transfer record
                    Dim transferId As Integer
                    Using cmd As New SqlCommand("INSERT INTO InterBranchTransfers (TransferNumber, FromBranchID, ToBranchID, ProductID, Quantity, UnitCost, TotalValue, TransferDate, Reference, Status, CreatedBy) OUTPUT INSERTED.TransferID VALUES (@num, @from, @to, @prod, @qty, @cost, @total, @date, @ref, 'Pending', @user)", con, tx)
                        cmd.Parameters.AddWithValue("@num", transferNumber)
                        cmd.Parameters.AddWithValue("@from", fromBranchId)
                        cmd.Parameters.AddWithValue("@to", toBranchId)
                        cmd.Parameters.AddWithValue("@prod", productId)
                        cmd.Parameters.AddWithValue("@qty", quantity)
                        cmd.Parameters.AddWithValue("@cost", productCost)
                        cmd.Parameters.AddWithValue("@total", totalValue)
                        cmd.Parameters.AddWithValue("@date", transferDate)
                        cmd.Parameters.AddWithValue("@ref", If(String.IsNullOrWhiteSpace(reference), DBNull.Value, reference))
                        cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                        transferId = Convert.ToInt32(cmd.ExecuteScalar())
                    End Using
                    
                    ' Reduce inventory at sender branch
                    UpdateRetailStock(productId, fromBranchId, -quantity, con, tx)
                    
                    ' Increase inventory at receiver branch
                    UpdateRetailStock(productId, toBranchId, quantity, con, tx)
                    
                    ' Create journal entries
                    CreateInterBranchJournalEntries(fromBranchId, toBranchId, totalValue, transferNumber, con, tx)
                    
                    tx.Commit()
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Private Function GetBranchCode(branchId As Integer, con As SqlConnection, tx As SqlTransaction) As String
        Using cmd As New SqlCommand("SELECT TOP 1 BranchCode FROM Branches WHERE BranchID = @id", con, tx)
            cmd.Parameters.AddWithValue("@id", branchId)
            Dim result = cmd.ExecuteScalar()
            Return If(result IsNot Nothing, result.ToString(), "BR")
        End Using
    End Function

    Private Function GetProductCost(productId As Integer, branchId As Integer, con As SqlConnection, tx As SqlTransaction) As Decimal
        Using cmd As New SqlCommand("SELECT TOP 1 ISNULL(rs.AverageCost, 0) FROM Retail_Stock rs INNER JOIN Retail_Variant rv ON rs.VariantID = rv.VariantID WHERE rv.ProductID = @prod AND rs.BranchID = @branch", con, tx)
            cmd.Parameters.AddWithValue("@prod", productId)
            cmd.Parameters.AddWithValue("@branch", branchId)
            Dim result = cmd.ExecuteScalar()
            Return If(result IsNot Nothing AndAlso Not IsDBNull(result), Convert.ToDecimal(result), 0D)
        End Using
    End Function

    Private Sub UpdateRetailStock(productId As Integer, branchId As Integer, qtyDelta As Decimal, con As SqlConnection, tx As SqlTransaction)
        ' Check if stock record exists
        Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Retail_Stock rs INNER JOIN Retail_Variant rv ON rs.VariantID = rv.VariantID WHERE rv.ProductID = @prod AND rs.BranchID = @branch", con, tx)
            cmdCheck.Parameters.AddWithValue("@prod", productId)
            cmdCheck.Parameters.AddWithValue("@branch", branchId)
            Dim exists As Integer = Convert.ToInt32(cmdCheck.ExecuteScalar())
            
            If exists > 0 Then
                Using cmdUpdate As New SqlCommand("UPDATE rs SET rs.QtyOnHand = rs.QtyOnHand + @delta FROM Retail_Stock rs INNER JOIN Retail_Variant rv ON rs.VariantID = rv.VariantID WHERE rv.ProductID = @prod AND rs.BranchID = @branch", con, tx)
                    cmdUpdate.Parameters.AddWithValue("@delta", qtyDelta)
                    cmdUpdate.Parameters.AddWithValue("@prod", productId)
                    cmdUpdate.Parameters.AddWithValue("@branch", branchId)
                    cmdUpdate.ExecuteNonQuery()
                End Using
            Else
                Using cmdInsert As New SqlCommand("INSERT INTO Retail_Stock (VariantID, BranchID, QtyOnHand, AverageCost) SELECT TOP 1 rv.VariantID, @branch, @qty, 0 FROM Retail_Variant rv WHERE rv.ProductID = @prod", con, tx)
                    cmdInsert.Parameters.AddWithValue("@prod", productId)
                    cmdInsert.Parameters.AddWithValue("@branch", branchId)
                    cmdInsert.Parameters.AddWithValue("@qty", Math.Max(0, qtyDelta))
                    cmdInsert.ExecuteNonQuery()
                End Using
            End If
        End Using
    End Sub

    Private Sub CreateInterBranchJournalEntries(fromBranchId As Integer, toBranchId As Integer, amount As Decimal, reference As String, con As SqlConnection, tx As SqlTransaction)
        ' Get fiscal period
        Dim fiscalPeriodId As Integer = 0
        Using cmdFP As New SqlCommand("SELECT TOP 1 PeriodID FROM dbo.FiscalPeriods WHERE GETDATE() BETWEEN StartDate AND EndDate AND IsClosed = 0 ORDER BY StartDate DESC", con, tx)
            Dim fpResult = cmdFP.ExecuteScalar()
            If fpResult IsNot Nothing AndAlso Not IsDBNull(fpResult) Then
                fiscalPeriodId = Convert.ToInt32(fpResult)
            End If
        End Using
        
        If fiscalPeriodId <= 0 Then
            Throw New Exception("No open fiscal period found. Please create a fiscal period before creating transfers.")
        End If
        
        ' Create journal header for sender branch
        Dim senderJournalId As Integer
        Dim jSql = "INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy) OUTPUT INSERTED.JournalID VALUES (@JNum, @BranchID, GETDATE(), @Ref, @Desc, @FP, 0, @UserID)"
        Using cmd As New SqlCommand(jSql, con, tx)
            cmd.Parameters.AddWithValue("@JNum", $"JNL-{DateTime.Now:yyyyMMddHHmmss}-S")
            cmd.Parameters.AddWithValue("@BranchID", fromBranchId)
            cmd.Parameters.AddWithValue("@Ref", reference)
            cmd.Parameters.AddWithValue("@Desc", "Inter-Branch Transfer - Sender")
            cmd.Parameters.AddWithValue("@FP", fiscalPeriodId)
            cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
            senderJournalId = Convert.ToInt32(cmd.ExecuteScalar())
        End Using
        
        ' Sender: DR Inter-Branch Debtors (Asset - Receivable)
        Dim dSql = "INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description) VALUES (@JID, @LineNum, @AcctID, @Amount, 0, @Desc)"
        Using cmd As New SqlCommand(dSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", senderJournalId)
            cmd.Parameters.AddWithValue("@LineNum", 1)
            cmd.Parameters.AddWithValue("@AcctID", GetInterBranchDebtorsAccountID(con, tx))
            cmd.Parameters.AddWithValue("@Amount", amount)
            cmd.Parameters.AddWithValue("@Desc", $"Inter-Branch Debtors - {reference}")
            cmd.ExecuteNonQuery()
        End Using
        
        ' Sender: CR Inventory (Reduce asset)
        Dim cSql = "INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description) VALUES (@JID, @LineNum, @AcctID, 0, @Amount, @Desc)"
        Using cmd As New SqlCommand(cSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", senderJournalId)
            cmd.Parameters.AddWithValue("@LineNum", 2)
            cmd.Parameters.AddWithValue("@AcctID", GetInventoryAccountID(con, tx))
            cmd.Parameters.AddWithValue("@Amount", amount)
            cmd.Parameters.AddWithValue("@Desc", $"Inventory - {reference}")
            cmd.ExecuteNonQuery()
        End Using
        
        ' Create journal header for receiver branch
        Dim receiverJournalId As Integer
        Using cmd As New SqlCommand(jSql, con, tx)
            cmd.Parameters.AddWithValue("@JNum", $"JNL-{DateTime.Now:yyyyMMddHHmmss}-R")
            cmd.Parameters.AddWithValue("@BranchID", toBranchId)
            cmd.Parameters.AddWithValue("@Ref", reference)
            cmd.Parameters.AddWithValue("@Desc", "Inter-Branch Transfer - Receiver")
            cmd.Parameters.AddWithValue("@FP", fiscalPeriodId)
            cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
            receiverJournalId = Convert.ToInt32(cmd.ExecuteScalar())
        End Using
        
        ' Receiver: DR Inventory (Increase asset)
        Using cmd As New SqlCommand(dSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", receiverJournalId)
            cmd.Parameters.AddWithValue("@LineNum", 1)
            cmd.Parameters.AddWithValue("@AcctID", GetInventoryAccountID(con, tx))
            cmd.Parameters.AddWithValue("@Amount", amount)
            cmd.Parameters.AddWithValue("@Desc", $"Inventory - {reference}")
            cmd.ExecuteNonQuery()
        End Using
        
        ' Receiver: CR Inter-Branch Creditors (Liability - Payable)
        Using cmd As New SqlCommand(cSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", receiverJournalId)
            cmd.Parameters.AddWithValue("@LineNum", 2)
            cmd.Parameters.AddWithValue("@AcctID", GetInterBranchCreditorsAccountID(con, tx))
            cmd.Parameters.AddWithValue("@Amount", amount)
            cmd.Parameters.AddWithValue("@Desc", $"Inter-Branch Creditors - {reference}")
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
    Private Function GetInterBranchDebtorsAccountID(con As SqlConnection, tx As SqlTransaction) As Integer
        Return GetOrCreateAccountID(con, tx, "1400", "Inter-Branch Debtors", "Asset")
    End Function
    
    Private Function GetInterBranchCreditorsAccountID(con As SqlConnection, tx As SqlTransaction) As Integer
        Return GetOrCreateAccountID(con, tx, "2200", "Inter-Branch Creditors", "Liability")
    End Function
    
    Private Function GetInventoryAccountID(con As SqlConnection, tx As SqlTransaction) As Integer
        Return GetOrCreateAccountID(con, tx, "1200", "Inventory", "Asset")
    End Function
    
    Private Function GetOrCreateAccountID(con As SqlConnection, tx As SqlTransaction, code As String, name As String, accountType As String) As Integer
        Dim sql = "SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = @Code"
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@Code", code)
            Dim result = cmd.ExecuteScalar()
            If result IsNot Nothing Then Return Convert.ToInt32(result)
        End Using
        
        Dim insertSql = "INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive) OUTPUT INSERTED.AccountID VALUES (@Code, @Name, @Type, 1)"
        Using cmd As New SqlCommand(insertSql, con, tx)
            cmd.Parameters.AddWithValue("@Code", code)
            cmd.Parameters.AddWithValue("@Name", name)
            cmd.Parameters.AddWithValue("@Type", accountType)
            Return Convert.ToInt32(cmd.ExecuteScalar())
        End Using
    End Function

    Private Sub ClearForm()
        If cboFromBranch.Items.Count > 0 Then cboFromBranch.SelectedIndex = 0
        If cboToBranch.Items.Count > 0 Then cboToBranch.SelectedIndex = 0
        If cboProduct.Items.Count > 0 Then cboProduct.SelectedIndex = 0
        txtQuantity.Clear()
        txtReference.Clear()
        dtpTransferDate.Value = DateTime.Today
    End Sub

    Private Sub StockTransferForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        ' Already initialized in constructor
    End Sub
End Class
