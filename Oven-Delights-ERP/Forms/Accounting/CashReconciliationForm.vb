Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms

Namespace Accounting
    Partial Public Class CashReconciliationForm
        Inherits Form

        Private ReadOnly _connString As String
        Private ReadOnly _cashBookID As Integer
        Private ReadOnly _reconciliationDate As Date
        Private ReadOnly _openingBalance As Decimal
        Private ReadOnly _totalReceipts As Decimal
        Private ReadOnly _totalPayments As Decimal
        Private ReadOnly _expectedClosing As Decimal

        Public Sub New(cashBookID As Integer, reconciliationDate As Date, openingBalance As Decimal, totalReceipts As Decimal, totalPayments As Decimal, expectedClosing As Decimal)
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            _cashBookID = cashBookID
            _reconciliationDate = reconciliationDate
            _openingBalance = openingBalance
            _totalReceipts = totalReceipts
            _totalPayments = totalPayments
            _expectedClosing = expectedClosing
            
            Me.Text = "Cash Reconciliation"
            Me.StartPosition = FormStartPosition.CenterParent
            
            DisplaySummary()
        End Sub

        Private Sub DisplaySummary()
            lblOpeningBalance.Text = $"Opening Balance: R {_openingBalance:N2}"
            lblTotalReceipts.Text = $"Add: Total Receipts: R {_totalReceipts:N2}"
            lblTotalPayments.Text = $"Less: Total Payments: R {_totalPayments:N2}"
            lblExpectedClosing.Text = $"Expected Closing: R {_expectedClosing:N2}"
        End Sub

        Private Sub CalculatePhysicalCount()
            Dim total As Decimal = 0
            
            ' Notes
            total += nud200.Value * 200
            total += nud100.Value * 100
            total += nud50.Value * 50
            total += nud20.Value * 20
            total += nud10.Value * 10
            
            ' Coins
            total += nud5.Value * 5
            total += nud2.Value * 2
            total += nud1.Value * 1
            total += nud50c.Value * 0.5D
            total += nud20c.Value * 0.2D
            total += nud10c.Value * 0.1D
            
            lblPhysicalCount.Text = $"Total Counted: R {total:N2}"
            
            ' Calculate variance
            Dim variance = total - _expectedClosing
            lblVariance.Text = $"Variance: R {Math.Abs(variance):N2}"
            
            If variance = 0 Then
                lblVariance.Text &= " ✅ Balanced"
                lblVariance.ForeColor = Color.Green
                pnlVarianceReason.Visible = False
            ElseIf variance > 0 Then
                lblVariance.Text &= " (OVER)"
                lblVariance.ForeColor = Color.Orange
                pnlVarianceReason.Visible = True
                lblVarianceNote.Text = "Cash is OVER expected. Please provide reason:"
            Else
                lblVariance.Text &= " (SHORT)"
                lblVariance.ForeColor = Color.Red
                pnlVarianceReason.Visible = True
                lblVarianceNote.Text = "Cash is SHORT. Reason is MANDATORY:"
            End If
            
            ' Enable/disable save based on variance
            If Math.Abs(variance) > 50 Then
                chkManagerApproval.Visible = True
                lblManagerNote.Visible = True
                lblManagerNote.Text = "⚠️ Variance exceeds R50 - Manager approval required"
            Else
                chkManagerApproval.Visible = False
                lblManagerNote.Visible = False
            End If
        End Sub

        Private Sub NotesCoin_ValueChanged(sender As Object, e As EventArgs) Handles nud200.ValueChanged, nud100.ValueChanged, nud50.ValueChanged, nud20.ValueChanged, nud10.ValueChanged, nud5.ValueChanged, nud2.ValueChanged, nud1.ValueChanged, nud50c.ValueChanged, nud20c.ValueChanged, nud10c.ValueChanged
            CalculatePhysicalCount()
        End Sub

        Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
            If Not ValidateReconciliation() Then Return
            
            Try
                Dim actualCount = GetPhysicalCount()
                Dim variance = actualCount - _expectedClosing
                
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using tx = conn.BeginTransaction()
                        Try
                            ' Insert reconciliation record
                            Dim sql = "INSERT INTO CashBookReconciliation (CashBookID, ReconciliationDate, OpeningBalance, TotalReceipts, TotalPayments, ExpectedClosing, ActualCount, Variance, VarianceReason, ReconciledBy, ReconciledDate, IsApproved, ApprovedBy) OUTPUT INSERTED.ReconciliationID VALUES (@cbid, @date, @open, @rec, @pay, @exp, @act, @var, @reason, @user, GETDATE(), @approved, @approver)"
                            Dim reconciliationID As Integer
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@cbid", _cashBookID)
                                cmd.Parameters.AddWithValue("@date", _reconciliationDate)
                                cmd.Parameters.AddWithValue("@open", _openingBalance)
                                cmd.Parameters.AddWithValue("@rec", _totalReceipts)
                                cmd.Parameters.AddWithValue("@pay", _totalPayments)
                                cmd.Parameters.AddWithValue("@exp", _expectedClosing)
                                cmd.Parameters.AddWithValue("@act", actualCount)
                                cmd.Parameters.AddWithValue("@var", variance)
                                cmd.Parameters.AddWithValue("@reason", If(String.IsNullOrWhiteSpace(txtVarianceReason.Text), DBNull.Value, CType(txtVarianceReason.Text.Trim(), Object)))
                                cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                                cmd.Parameters.AddWithValue("@approved", If(Math.Abs(variance) > 50, chkManagerApproval.Checked, True))
                                cmd.Parameters.AddWithValue("@approver", If(chkManagerApproval.Checked, CType(AppSession.CurrentUserID, Object), DBNull.Value))
                                
                                reconciliationID = Convert.ToInt32(cmd.ExecuteScalar())
                            End Using
                            
                            ' Post variance to GL if exists
                            If variance <> 0 Then
                                PostVarianceToGL(conn, tx, reconciliationID, variance)
                            End If
                            
                            ' Update cash book balance to actual count
                            sql = "UPDATE CashBooks SET CurrentBalance = @balance WHERE CashBookID = @cbid"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@balance", actualCount)
                                cmd.Parameters.AddWithValue("@cbid", _cashBookID)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            tx.Commit()
                            Me.DialogResult = DialogResult.OK
                            Me.Close()
                        Catch ex As Exception
                            tx.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error saving reconciliation: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function GetPhysicalCount() As Decimal
            Dim total As Decimal = 0
            total += nud200.Value * 200
            total += nud100.Value * 100
            total += nud50.Value * 50
            total += nud20.Value * 20
            total += nud10.Value * 10
            total += nud5.Value * 5
            total += nud2.Value * 2
            total += nud1.Value * 1
            total += nud50c.Value * 0.5D
            total += nud20c.Value * 0.2D
            total += nud10c.Value * 0.1D
            Return total
        End Function

        Private Sub PostVarianceToGL(conn As SqlConnection, tx As SqlTransaction, reconciliationID As Integer, variance As Decimal)
            ' Get GL accounts
            Dim cashAcctID As Integer = GetAccountID("Cash on Hand", conn, tx)
            Dim varianceAcctID As Integer = GetAccountID("Cash Over/Short", conn, tx)
            
            ' Create journal header
            Dim journalNumber = $"JNL-RECON-{reconciliationID}-{DateTime.Now:yyyyMMddHHmmss}"
            Dim journalID As Integer
            
            Dim sql = "INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, IsPosted, CreatedBy, CreatedDate, PostedBy, PostedDate) OUTPUT INSERTED.JournalID VALUES (@jnum, @bid, @date, @ref, @desc, 1, @user, GETDATE(), @user, GETDATE())"
            Using cmd As New SqlCommand(sql, conn, tx)
                cmd.Parameters.AddWithValue("@jnum", journalNumber)
                cmd.Parameters.AddWithValue("@bid", AppSession.CurrentBranchID)
                cmd.Parameters.AddWithValue("@date", _reconciliationDate)
                cmd.Parameters.AddWithValue("@ref", $"RECON-{reconciliationID}")
                cmd.Parameters.AddWithValue("@desc", $"Cash Reconciliation Variance - {_reconciliationDate:dd/MM/yyyy}")
                cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                journalID = Convert.ToInt32(cmd.ExecuteScalar())
            End Using
            
            ' Post journal details
            If variance > 0 Then
                ' Cash Over: DR Cash, CR Cash Over (Income)
                sql = "INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description) VALUES (@jid, @acct, @amt, 0, @desc)"
                Using cmd As New SqlCommand(sql, conn, tx)
                    cmd.Parameters.AddWithValue("@jid", journalID)
                    cmd.Parameters.AddWithValue("@acct", cashAcctID)
                    cmd.Parameters.AddWithValue("@amt", Math.Abs(variance))
                    cmd.Parameters.AddWithValue("@desc", "Cash over")
                    cmd.ExecuteNonQuery()
                End Using
                
                sql = "INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description) VALUES (@jid, @acct, 0, @amt, @desc)"
                Using cmd As New SqlCommand(sql, conn, tx)
                    cmd.Parameters.AddWithValue("@jid", journalID)
                    cmd.Parameters.AddWithValue("@acct", varianceAcctID)
                    cmd.Parameters.AddWithValue("@amt", Math.Abs(variance))
                    cmd.Parameters.AddWithValue("@desc", "Cash over")
                    cmd.ExecuteNonQuery()
                End Using
            Else
                ' Cash Short: DR Cash Short (Expense), CR Cash
                sql = "INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description) VALUES (@jid, @acct, @amt, 0, @desc)"
                Using cmd As New SqlCommand(sql, conn, tx)
                    cmd.Parameters.AddWithValue("@jid", journalID)
                    cmd.Parameters.AddWithValue("@acct", varianceAcctID)
                    cmd.Parameters.AddWithValue("@amt", Math.Abs(variance))
                    cmd.Parameters.AddWithValue("@desc", "Cash short")
                    cmd.ExecuteNonQuery()
                End Using
                
                sql = "INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description) VALUES (@jid, @acct, 0, @amt, @desc)"
                Using cmd As New SqlCommand(sql, conn, tx)
                    cmd.Parameters.AddWithValue("@jid", journalID)
                    cmd.Parameters.AddWithValue("@acct", cashAcctID)
                    cmd.Parameters.AddWithValue("@amt", Math.Abs(variance))
                    cmd.Parameters.AddWithValue("@desc", "Cash short")
                    cmd.ExecuteNonQuery()
                End Using
            End If
            
            ' Update reconciliation with journal ID
            sql = "UPDATE CashBookReconciliation SET JournalID = @jid WHERE ReconciliationID = @rid"
            Using cmd As New SqlCommand(sql, conn, tx)
                cmd.Parameters.AddWithValue("@jid", journalID)
                cmd.Parameters.AddWithValue("@rid", reconciliationID)
                cmd.ExecuteNonQuery()
            End Using
        End Sub

        Private Function GetAccountID(accountName As String, conn As SqlConnection, tx As SqlTransaction) As Integer
            Dim sql = "SELECT AccountID FROM ChartOfAccounts WHERE AccountName = @name"
            Using cmd As New SqlCommand(sql, conn, tx)
                cmd.Parameters.AddWithValue("@name", accountName)
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    Return Convert.ToInt32(result)
                End If
            End Using
            Throw New Exception($"Account '{accountName}' not found in Chart of Accounts")
        End Function

        Private Function ValidateReconciliation() As Boolean
            Dim actualCount = GetPhysicalCount()
            Dim variance = actualCount - _expectedClosing
            
            If variance <> 0 AndAlso String.IsNullOrWhiteSpace(txtVarianceReason.Text) Then
                MessageBox.Show("Please provide a reason for the variance.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtVarianceReason.Focus()
                Return False
            End If
            
            If Math.Abs(variance) > 50 AndAlso Not chkManagerApproval.Checked Then
                MessageBox.Show("Variance exceeds R50. Manager approval is required.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return False
            End If
            
            Return True
        End Function

        Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Sub
    End Class
End Namespace
