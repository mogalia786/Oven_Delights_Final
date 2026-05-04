Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

''' <summary>
''' Bank Reconciliation Form - Match FNB bank statement entries with internal transactions
''' </summary>
Public Class BankReconciliationForm
    Inherits Form
    
    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchID As Integer
    Private ReadOnly _accountingService As New ExtendedAccountingService()
    
    Private dgvUnreconciled As DataGridView
    Private dgvPendingPayments As DataGridView
    Private btnReconcile As Button
    Private btnImportStatement As Button
    Private btnClose As Button
    Private lblUnreconciledCount As Label
    Private lblPendingCount As Label
    
    Public Sub New(branchID As Integer)
        _currentBranchID = branchID
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        InitializeComponent()
        LoadData()
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "Bank Reconciliation - FNB Integration"
        Me.Size = New Size(1400, 800)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.White
        
        ' Header
        Dim pnlHeader As New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#16A085")
        }
        
        Dim lblTitle As New Label With {
            .Text = "🏦 BANK RECONCILIATION",
            .Font = New Font("Segoe UI", 20, FontStyle.Bold),
            .ForeColor = Color.White,
            .Location = New Point(20, 20),
            .AutoSize = True
        }
        pnlHeader.Controls.Add(lblTitle)
        
        ' Split container for two grids
        Dim splitContainer As New SplitContainer With {
            .Dock = DockStyle.Fill,
            .Orientation = Orientation.Horizontal,
            .SplitterDistance = 350
        }
        
        ' TOP PANEL - Unreconciled Bank Transactions
        Dim pnlTop As New Panel With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(10)
        }
        
        Dim lblUnreconciled As New Label With {
            .Text = "📋 UNRECONCILED BANK STATEMENT ENTRIES",
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#16A085"),
            .Location = New Point(10, 10),
            .AutoSize = True
        }
        pnlTop.Controls.Add(lblUnreconciled)
        
        lblUnreconciledCount = New Label With {
            .Text = "0 unreconciled transactions",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = ColorTranslator.FromHtml("#E74C3C"),
            .Location = New Point(400, 13),
            .AutoSize = True
        }
        pnlTop.Controls.Add(lblUnreconciledCount)
        
        dgvUnreconciled = New DataGridView With {
            .Location = New Point(10, 40),
            .Size = New Size(1360, 280),
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.FixedSingle,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 9),
            .ColumnHeadersHeight = 35
        }
        
        dgvUnreconciled.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#16A085")
        dgvUnreconciled.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvUnreconciled.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        dgvUnreconciled.EnableHeadersVisualStyles = False
        dgvUnreconciled.AlternatingRowsDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F8F9FA")
        
        pnlTop.Controls.Add(dgvUnreconciled)
        splitContainer.Panel1.Controls.Add(pnlTop)
        
        ' BOTTOM PANEL - Pending Payments (awaiting reconciliation)
        Dim pnlBottom As New Panel With {
            .Dock = DockStyle.Fill,
            .Padding = New Padding(10)
        }
        
        Dim lblPending As New Label With {
            .Text = "⏳ PENDING PAYMENTS (Awaiting Bank Confirmation)",
            .Font = New Font("Segoe UI", 12, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#F39C12"),
            .Location = New Point(10, 10),
            .AutoSize = True
        }
        pnlBottom.Controls.Add(lblPending)
        
        lblPendingCount = New Label With {
            .Text = "0 pending payments",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = ColorTranslator.FromHtml("#F39C12"),
            .Location = New Point(500, 13),
            .AutoSize = True
        }
        pnlBottom.Controls.Add(lblPendingCount)
        
        dgvPendingPayments = New DataGridView With {
            .Location = New Point(10, 40),
            .Size = New Size(1360, 280),
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.FixedSingle,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 9),
            .ColumnHeadersHeight = 35
        }
        
        dgvPendingPayments.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F39C12")
        dgvPendingPayments.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvPendingPayments.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        dgvPendingPayments.EnableHeadersVisualStyles = False
        dgvPendingPayments.AlternatingRowsDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F8F9FA")
        
        pnlBottom.Controls.Add(dgvPendingPayments)
        splitContainer.Panel2.Controls.Add(pnlBottom)
        
        ' Footer Panel
        Dim pnlFooter As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 70,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1")
        }
        
        btnImportStatement = New Button With {
            .Text = "📥 Import FNB Statement",
            .Location = New Point(20, 15),
            .Size = New Size(200, 40),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold)
        }
        btnImportStatement.FlatAppearance.BorderSize = 0
        AddHandler btnImportStatement.Click, AddressOf btnImportStatement_Click
        pnlFooter.Controls.Add(btnImportStatement)
        
        btnReconcile = New Button With {
            .Text = "✅ Reconcile Selected",
            .Location = New Point(240, 15),
            .Size = New Size(200, 40),
            .BackColor = ColorTranslator.FromHtml("#27AE60"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold)
        }
        btnReconcile.FlatAppearance.BorderSize = 0
        AddHandler btnReconcile.Click, AddressOf btnReconcile_Click
        pnlFooter.Controls.Add(btnReconcile)
        
        btnClose = New Button With {
            .Text = "❌ Close",
            .Location = New Point(1250, 15),
            .Size = New Size(120, 40),
            .BackColor = ColorTranslator.FromHtml("#95A5A6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Font = New Font("Segoe UI", 11, FontStyle.Bold)
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, Sub() Me.Close()
        pnlFooter.Controls.Add(btnClose)
        
        Me.Controls.Add(splitContainer)
        Me.Controls.Add(pnlHeader)
        Me.Controls.Add(pnlFooter)
    End Sub
    
    Private Sub LoadData()
        LoadUnreconciledTransactions()
        LoadPendingPayments()
    End Sub
    
    Private Sub LoadUnreconciledTransactions()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim sql = "
                    SELECT 
                        ReconciliationID,
                        CONVERT(VARCHAR, StatementDate, 106) AS [Statement Date],
                        BankReference AS [Bank Reference],
                        BankDescription AS [Description],
                        TransactionType AS [Type],
                        Amount,
                        DATEDIFF(DAY, StatementDate, GETDATE()) AS [Days Unreconciled]
                    FROM BankStatementReconciliation
                    WHERE IsReconciled = 0
                    ORDER BY StatementDate DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvUnreconciled.DataSource = dt
                        
                        If dgvUnreconciled.Columns.Contains("ReconciliationID") Then
                            dgvUnreconciled.Columns("ReconciliationID").Visible = False
                        End If
                        
                        If dgvUnreconciled.Columns.Contains("Amount") Then
                            dgvUnreconciled.Columns("Amount").DefaultCellStyle.Format = "N2"
                            dgvUnreconciled.Columns("Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        End If
                        
                        lblUnreconciledCount.Text = $"{dt.Rows.Count} unreconciled transactions"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading unreconciled transactions: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub LoadPendingPayments()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim sql = "
                    SELECT 
                        PaymentID,
                        PaymentNumber AS [Payment #],
                        CONVERT(VARCHAR, PaymentDate, 106) AS [Payment Date],
                        CustomerName AS [Customer/Supplier],
                        PaymentAmount AS [Amount],
                        PaymentMethod AS [Method],
                        BankReference AS [Bank Reference],
                        'AdhocPayment' AS [Type]
                    FROM AdhocPayments
                    WHERE IsBankTransfer = 1 AND IsReconciled = 0
                    
                    UNION ALL
                    
                    SELECT 
                        PaymentID,
                        PaymentNumber AS [Payment #],
                        CONVERT(VARCHAR, PaymentDate, 106) AS [Payment Date],
                        SupplierName AS [Customer/Supplier],
                        PaymentAmount AS [Amount],
                        PaymentMethod AS [Method],
                        BankReference AS [Bank Reference],
                        'SupplierPayment' AS [Type]
                    FROM SupplierPayments
                    WHERE IsBankTransfer = 1 AND IsReconciled = 0
                    
                    ORDER BY [Payment Date] DESC"
                
                Using cmd As New SqlCommand(sql, conn)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvPendingPayments.DataSource = dt
                        
                        If dgvPendingPayments.Columns.Contains("PaymentID") Then
                            dgvPendingPayments.Columns("PaymentID").Visible = False
                        End If
                        
                        If dgvPendingPayments.Columns.Contains("Amount") Then
                            dgvPendingPayments.Columns("Amount").DefaultCellStyle.Format = "N2"
                            dgvPendingPayments.Columns("Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                        End If
                        
                        lblPendingCount.Text = $"{dt.Rows.Count} pending payments"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading pending payments: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnImportStatement_Click(sender As Object, e As EventArgs)
        MessageBox.Show("FNB Statement Import functionality coming soon!" & vbCrLf & vbCrLf &
                       "This will allow you to import CSV/Excel files from FNB and automatically populate the unreconciled transactions grid.",
                       "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub
    
    Private Sub btnReconcile_Click(sender As Object, e As EventArgs)
        If dgvUnreconciled.SelectedRows.Count = 0 OrElse dgvPendingPayments.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select one unreconciled bank transaction and one pending payment to reconcile.",
                          "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Try
            Dim reconciliationID = CInt(dgvUnreconciled.SelectedRows(0).Cells("ReconciliationID").Value)
            Dim paymentID = CInt(dgvPendingPayments.SelectedRows(0).Cells("PaymentID").Value)
            Dim reconciliationType = dgvPendingPayments.SelectedRows(0).Cells("Type").Value.ToString()
            
            Dim bankAmount = CDec(dgvUnreconciled.SelectedRows(0).Cells("Amount").Value)
            Dim paymentAmount = CDec(dgvPendingPayments.SelectedRows(0).Cells("Amount").Value)
            
            ' Verify amounts match
            If Math.Abs(bankAmount - paymentAmount) > 0.01 Then
                Dim result = MessageBox.Show($"Amounts don't match exactly!" & vbCrLf &
                                            $"Bank: R {bankAmount:N2}" & vbCrLf &
                                            $"Payment: R {paymentAmount:N2}" & vbCrLf & vbCrLf &
                                            "Continue with reconciliation?",
                                            "Amount Mismatch", MessageBoxButtons.YesNo, MessageBoxIcon.Warning)
                If result = DialogResult.No Then Return
            End If
            
            ' Perform reconciliation
            Dim userName = If(AppSession.CurrentUser IsNot Nothing, AppSession.CurrentUser.Username, "System")
            Dim success = _accountingService.ReconcilePaymentWithBankStatement(reconciliationID, paymentID, reconciliationType, userName)
            
            If success Then
                MessageBox.Show("Reconciliation completed successfully!" & vbCrLf &
                              "Bank account has been updated.",
                              "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                LoadData() ' Refresh both grids
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error during reconciliation: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
End Class
