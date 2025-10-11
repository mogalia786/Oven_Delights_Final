Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports Oven_Delights_ERP.UI

Partial Public Class CashBookJournalForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchID As Integer
    Private ReadOnly _currentUserID As Integer
    Private ReadOnly _isSuperAdmin As Boolean

    Public Sub New()
        InitializeComponent()
        
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _currentBranchID = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 1)
        _currentUserID = If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 1)
        _isSuperAdmin = (AppSession.CurrentRoleName = "Super Administrator")
        
        LoadBranches()
        LoadCategories()
        LoadData()
        
        AddHandler btnAddReceipt.Click, AddressOf BtnAddReceipt_Click
        AddHandler btnAddPayment.Click, AddressOf BtnAddPayment_Click
        AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click
        AddHandler btnReconcile.Click, AddressOf BtnReconcile_Click
        AddHandler dtpFrom.ValueChanged, AddressOf DateFilter_Changed
        AddHandler dtpTo.ValueChanged, AddressOf DateFilter_Changed
        
        Theme.Apply(Me)
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "Cash Book Journal"
        Me.Size = New Size(1400, 800)
        Me.StartPosition = FormStartPosition.CenterScreen
        
        ' Header Panel
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 120,
            .BackColor = Color.FromArgb(0, 120, 215)
        }
        
        Dim lblTitle As New Label With {
            .Text = "CASH BOOK JOURNAL",
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.White,
            .Location = New Point(20, 20),
            .AutoSize = True
        }
        pnlHeader.Controls.Add(lblTitle)
        
        Dim lblSubtitle As New Label With {
            .Text = "Control all income and expenses | 3-Column Format: Cash | Bank | Discount",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = Color.White,
            .Location = New Point(20, 55),
            .AutoSize = True
        }
        pnlHeader.Controls.Add(lblSubtitle)
        
        ' Filters Panel
        Dim pnlFilters As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .Padding = New Padding(20, 10, 20, 10)
        }
        
        Dim lblFrom As New Label With {.Text = "From:", .Location = New Point(20, 15), .AutoSize = True}
        Me.dtpFrom = New DateTimePicker With {
            .Format = DateTimePickerFormat.Short,
            .Location = New Point(70, 12),
            .Width = 120,
            .Value = DateTime.Today.AddMonths(-1)
        }
        
        Dim lblTo As New Label With {.Text = "To:", .Location = New Point(210, 15), .AutoSize = True}
        Me.dtpTo = New DateTimePicker With {
            .Format = DateTimePickerFormat.Short,
            .Location = New Point(250, 12),
            .Width = 120,
            .Value = DateTime.Today
        }
        
        Dim lblBranch As New Label With {.Text = "Branch:", .Location = New Point(390, 15), .AutoSize = True}
        Me.cboBranch = New ComboBox With {
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Location = New Point(450, 12),
            .Width = 200
        }
        
        Me.btnRefresh = New Button With {
            .Text = "Refresh",
            .Location = New Point(670, 10),
            .Size = New Size(100, 30)
        }
        
        Me.btnAddReceipt = New Button With {
            .Text = "+ Receipt",
            .Location = New Point(790, 10),
            .Size = New Size(120, 30),
            .BackColor = Color.FromArgb(0, 150, 0),
            .ForeColor = Color.White
        }
        
        Me.btnAddPayment = New Button With {
            .Text = "- Payment",
            .Location = New Point(920, 10),
            .Size = New Size(120, 30),
            .BackColor = Color.FromArgb(200, 0, 0),
            .ForeColor = Color.White
        }
        
        Me.btnReconcile = New Button With {
            .Text = "Reconcile",
            .Location = New Point(1050, 10),
            .Size = New Size(120, 30)
        }
        
        pnlFilters.Controls.AddRange({lblFrom, dtpFrom, lblTo, dtpTo, lblBranch, cboBranch, btnRefresh, btnAddReceipt, btnAddPayment, btnReconcile})
        
        ' Summary Panel
        Dim pnlSummary As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 60,
            .Padding = New Padding(20, 10, 20, 10),
            .BackColor = Color.FromArgb(240, 240, 240)
        }
        
        Me.lblTotalReceipts = New Label With {
            .Text = "Total Receipts: R 0.00",
            .Location = New Point(20, 15),
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(0, 150, 0),
            .AutoSize = True
        }
        
        Me.lblTotalPayments = New Label With {
            .Text = "Total Payments: R 0.00",
            .Location = New Point(250, 15),
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(200, 0, 0),
            .AutoSize = True
        }
        
        Me.lblNetCash = New Label With {
            .Text = "Net Cash Flow: R 0.00",
            .Location = New Point(500, 15),
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .AutoSize = True
        }
        
        Me.lblUnreconciled = New Label With {
            .Text = "Unreconciled: 0",
            .Location = New Point(750, 15),
            .Font = New Font("Segoe UI", 11),
            .AutoSize = True
        }
        
        pnlSummary.Controls.AddRange({lblTotalReceipts, lblTotalPayments, lblNetCash, lblUnreconciled})
        
        ' DataGridView
        Me.dgvCashBook = New DataGridView With {
            .Dock = DockStyle.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .BackgroundColor = Color.White
        }
        
        Me.Controls.Add(dgvCashBook)
        Me.Controls.Add(pnlSummary)
        Me.Controls.Add(pnlFilters)
        Me.Controls.Add(pnlHeader)
    End Sub

    Private dtpFrom As DateTimePicker
    Private dtpTo As DateTimePicker
    Private cboBranch As ComboBox
    Private btnRefresh As Button
    Private btnAddReceipt As Button
    Private btnAddPayment As Button
    Private btnReconcile As Button
    Private dgvCashBook As DataGridView
    Private lblTotalReceipts As Label
    Private lblTotalPayments As Label
    Private lblNetCash As Label
    Private lblUnreconciled As Label

    Private Sub LoadBranches()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    
                    If _isSuperAdmin Then
                        Dim allRow = dt.NewRow()
                        allRow("BranchID") = DBNull.Value
                        allRow("BranchName") = "All Branches"
                        dt.Rows.InsertAt(allRow, 0)
                    End If
                    
                    cboBranch.DataSource = dt
                    cboBranch.DisplayMember = "BranchName"
                    cboBranch.ValueMember = "BranchID"
                    
                    If Not _isSuperAdmin Then
                        cboBranch.SelectedValue = _currentBranchID
                        cboBranch.Enabled = False
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading branches: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadCategories()
        ' Categories loaded when adding transactions
    End Sub

    Private Sub LoadData()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT 
                    cb.CashBookID,
                    cb.TransactionDate,
                    cb.TransactionType,
                    cb.Description,
                    cb.Amount,
                    cb.CashAmount,
                    cb.BankAmount,
                    cb.PaymentMethod,
                    CASE WHEN cb.IsReconciled = 1 THEN 'Yes' ELSE 'No' END AS Reconciled,
                    b.BranchName
                FROM CashBook cb
                LEFT JOIN Branches b ON cb.BranchID = b.BranchID
                WHERE cb.TransactionDate BETWEEN @from AND @to
                AND (@branchID IS NULL OR cb.BranchID = @branchID)
                ORDER BY cb.TransactionDate DESC, cb.CashBookID DESC"
                
                Using da As New SqlDataAdapter(sql, conn)
                    Dim branchID As Object = If(cboBranch.SelectedValue Is DBNull.Value, DBNull.Value, cboBranch.SelectedValue)
                    da.SelectCommand.Parameters.AddWithValue("@from", dtpFrom.Value.Date)
                    da.SelectCommand.Parameters.AddWithValue("@to", dtpTo.Value.Date)
                    da.SelectCommand.Parameters.AddWithValue("@branchID", branchID)
                    
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvCashBook.DataSource = dt
                    
                    ' Format columns
                    If dgvCashBook.Columns.Contains("Amount") Then
                        dgvCashBook.Columns("Amount").DefaultCellStyle.Format = "C2"
                        dgvCashBook.Columns("Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    End If
                    If dgvCashBook.Columns.Contains("CashAmount") Then
                        dgvCashBook.Columns("CashAmount").DefaultCellStyle.Format = "C2"
                        dgvCashBook.Columns("CashAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    End If
                    If dgvCashBook.Columns.Contains("BankAmount") Then
                        dgvCashBook.Columns("BankAmount").DefaultCellStyle.Format = "C2"
                        dgvCashBook.Columns("BankAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    End If
                    
                    ' Color code rows
                    For Each row As DataGridViewRow In dgvCashBook.Rows
                        If row.Cells("TransactionType").Value?.ToString() = "Receipt" Then
                            row.DefaultCellStyle.BackColor = Color.FromArgb(230, 255, 230)
                        Else
                            row.DefaultCellStyle.BackColor = Color.FromArgb(255, 230, 230)
                        End If
                    Next
                    
                    UpdateSummary(dt)
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading cash book: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub UpdateSummary(dt As DataTable)
        Try
            Dim totalReceipts As Decimal = 0
            Dim totalPayments As Decimal = 0
            Dim unreconciled As Integer = 0
            
            For Each row As DataRow In dt.Rows
                Dim amount = CDec(row("Amount"))
                If row("TransactionType").ToString() = "Receipt" Then
                    totalReceipts += amount
                Else
                    totalPayments += amount
                End If
                
                If row("Reconciled").ToString() = "No" Then
                    unreconciled += 1
                End If
            Next
            
            lblTotalReceipts.Text = $"Total Receipts: {totalReceipts:C2}"
            lblTotalPayments.Text = $"Total Payments: {totalPayments:C2}"
            
            Dim netCash = totalReceipts - totalPayments
            lblNetCash.Text = $"Net Cash Flow: {netCash:C2}"
            lblNetCash.ForeColor = If(netCash >= 0, Color.FromArgb(0, 150, 0), Color.FromArgb(200, 0, 0))
            
            lblUnreconciled.Text = $"Unreconciled: {unreconciled}"
        Catch ex As Exception
            ' Silent fail on summary
        End Try
    End Sub

    Private Sub BtnAddReceipt_Click(sender As Object, e As EventArgs)
        Using frm As New CashBookEntryForm("Receipt", _currentBranchID)
            If frm.ShowDialog() = DialogResult.OK Then
                LoadData()
            End If
        End Using
    End Sub

    Private Sub BtnAddPayment_Click(sender As Object, e As EventArgs)
        Using frm As New CashBookEntryForm("Payment", _currentBranchID)
            If frm.ShowDialog() = DialogResult.OK Then
                LoadData()
            End If
        End Using
    End Sub

    Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
        LoadData()
    End Sub

    Private Sub BtnReconcile_Click(sender As Object, e As EventArgs)
        MessageBox.Show("Bank Reconciliation feature coming soon!", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub DateFilter_Changed(sender As Object, e As EventArgs)
        LoadData()
    End Sub
End Class

' =============================================
' Cash Book Entry Dialog
' =============================================
Public Class CashBookEntryForm
    Inherits Form
    
    Private ReadOnly _transactionType As String
    Private ReadOnly _branchID As Integer
    Private ReadOnly _connString As String
    
    Private dtpDate As DateTimePicker
    Private txtDescription As TextBox
    Private txtAmount As TextBox
    Private txtCash As TextBox
    Private txtBank As TextBox
    Private cboPaymentMethod As ComboBox
    Private cboCategory As ComboBox
    Private txtReference As TextBox
    Private btnSave As Button
    Private btnCancel As Button
    
    Public Sub New(transactionType As String, branchID As Integer)
        _transactionType = transactionType
        _branchID = branchID
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        InitializeComponent()
        LoadCategories()
        
        AddHandler btnSave.Click, AddressOf BtnSave_Click
        AddHandler btnCancel.Click, AddressOf BtnCancel_Click
        AddHandler txtAmount.TextChanged, AddressOf TxtAmount_TextChanged
        
        Theme.Apply(Me)
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = $"Add {_transactionType}"
        Me.Size = New Size(500, 500)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        
        Dim y = 20
        
        ' Date
        Dim lblDate As New Label With {.Text = "Date:", .Location = New Point(20, y), .AutoSize = True}
        dtpDate = New DateTimePicker With {
            .Format = DateTimePickerFormat.Short,
            .Location = New Point(150, y - 3),
            .Width = 300
        }
        Me.Controls.AddRange({lblDate, dtpDate})
        y += 35
        
        ' Description
        Dim lblDesc As New Label With {.Text = "Description:", .Location = New Point(20, y), .AutoSize = True}
        txtDescription = New TextBox With {.Location = New Point(150, y - 3), .Width = 300}
        Me.Controls.AddRange({lblDesc, txtDescription})
        y += 35
        
        ' Category
        Dim lblCat As New Label With {.Text = "Category:", .Location = New Point(20, y), .AutoSize = True}
        cboCategory = New ComboBox With {
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Location = New Point(150, y - 3),
            .Width = 300
        }
        Me.Controls.AddRange({lblCat, cboCategory})
        y += 35
        
        ' Amount
        Dim lblAmount As New Label With {.Text = "Amount:", .Location = New Point(20, y), .AutoSize = True}
        txtAmount = New TextBox With {
            .Location = New Point(150, y - 3),
            .Width = 300,
            .TextAlign = HorizontalAlignment.Right
        }
        Me.Controls.AddRange({lblAmount, txtAmount})
        y += 35
        
        ' Cash Amount
        Dim lblCash As New Label With {.Text = "Cash Amount:", .Location = New Point(20, y), .AutoSize = True}
        txtCash = New TextBox With {
            .Location = New Point(150, y - 3),
            .Width = 300,
            .TextAlign = HorizontalAlignment.Right,
            .Text = "0.00"
        }
        Me.Controls.AddRange({lblCash, txtCash})
        y += 35
        
        ' Bank Amount
        Dim lblBank As New Label With {.Text = "Bank Amount:", .Location = New Point(20, y), .AutoSize = True}
        txtBank = New TextBox With {
            .Location = New Point(150, y - 3),
            .Width = 300,
            .TextAlign = HorizontalAlignment.Right,
            .Text = "0.00"
        }
        Me.Controls.AddRange({lblBank, txtBank})
        y += 35
        
        ' Payment Method
        Dim lblMethod As New Label With {.Text = "Payment Method:", .Location = New Point(20, y), .AutoSize = True}
        cboPaymentMethod = New ComboBox With {
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .Location = New Point(150, y - 3),
            .Width = 300
        }
        cboPaymentMethod.Items.AddRange({"Cash", "Cheque", "EFT", "Card", "Direct Deposit"})
        cboPaymentMethod.SelectedIndex = 0
        Me.Controls.AddRange({lblMethod, cboPaymentMethod})
        y += 35
        
        ' Reference
        Dim lblRef As New Label With {.Text = "Reference:", .Location = New Point(20, y), .AutoSize = True}
        txtReference = New TextBox With {.Location = New Point(150, y - 3), .Width = 300}
        Me.Controls.AddRange({lblRef, txtReference})
        y += 50
        
        ' Buttons
        btnSave = New Button With {
            .Text = "Save",
            .Location = New Point(250, y),
            .Size = New Size(100, 35),
            .DialogResult = DialogResult.OK
        }
        
        btnCancel = New Button With {
            .Text = "Cancel",
            .Location = New Point(360, y),
            .Size = New Size(90, 35),
            .DialogResult = DialogResult.Cancel
        }
        
        Me.Controls.AddRange({btnSave, btnCancel})
        Me.AcceptButton = btnSave
        Me.CancelButton = btnCancel
    End Sub
    
    Private Sub LoadCategories()
        Try
            Using conn As New SqlConnection(_connString)
                Dim tableName = If(_transactionType = "Receipt", "IncomeCategories", "ExpenseCategories")
                Dim sql = $"SELECT CategoryID, CategoryName FROM {tableName} WHERE IsActive = 1 ORDER BY CategoryName"
                
                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    cboCategory.DataSource = dt
                    cboCategory.DisplayMember = "CategoryName"
                    cboCategory.ValueMember = "CategoryID"
                End Using
            End Using
        Catch ex As Exception
            ' Silent fail - categories optional
        End Try
    End Sub
    
    Private Sub TxtAmount_TextChanged(sender As Object, e As EventArgs)
        ' Auto-populate cash/bank split
        Dim amount As Decimal
        If Decimal.TryParse(txtAmount.Text, amount) Then
            If cboPaymentMethod.SelectedItem?.ToString() = "Cash" Then
                txtCash.Text = amount.ToString("F2")
                txtBank.Text = "0.00"
            Else
                txtCash.Text = "0.00"
                txtBank.Text = amount.ToString("F2")
            End If
        End If
    End Sub
    
    Private Sub BtnSave_Click(sender As Object, e As EventArgs)
        Try
            ' Validation
            If String.IsNullOrWhiteSpace(txtDescription.Text) Then
                MessageBox.Show("Please enter a description", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            Dim amount As Decimal
            If Not Decimal.TryParse(txtAmount.Text, amount) OrElse amount <= 0 Then
                MessageBox.Show("Please enter a valid amount", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Save to database
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim sql = "INSERT INTO CashBook (TransactionDate, TransactionType, Description, Amount, CashAmount, BankAmount, PaymentMethod, BranchID, CreatedDate)
                           VALUES (@date, @type, @desc, @amount, @cash, @bank, @method, @branchID, SYSUTCDATETIME())"
                
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@date", dtpDate.Value.Date)
                    cmd.Parameters.AddWithValue("@type", _transactionType)
                    cmd.Parameters.AddWithValue("@desc", txtDescription.Text.Trim())
                    cmd.Parameters.AddWithValue("@amount", amount)
                    cmd.Parameters.AddWithValue("@cash", If(String.IsNullOrWhiteSpace(txtCash.Text), 0, CDec(txtCash.Text)))
                    cmd.Parameters.AddWithValue("@bank", If(String.IsNullOrWhiteSpace(txtBank.Text), 0, CDec(txtBank.Text)))
                    cmd.Parameters.AddWithValue("@method", cboPaymentMethod.SelectedItem?.ToString())
                    cmd.Parameters.AddWithValue("@branchID", _branchID)
                    
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            
            MessageBox.Show($"{_transactionType} saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Me.DialogResult = DialogResult.OK
            Me.Close()
            
        Catch ex As Exception
            MessageBox.Show("Error saving transaction: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub BtnCancel_Click(sender As Object, e As EventArgs)
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub
End Class
