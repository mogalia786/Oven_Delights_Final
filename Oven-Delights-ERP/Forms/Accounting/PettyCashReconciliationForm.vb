Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms

Namespace Accounting
    Partial Public Class PettyCashReconciliationForm
        Inherits Form

        Private ReadOnly _connString As String
        Private ReadOnly _cashBookID As Integer
        Private ReadOnly _openingFloat As Decimal
        Private ReadOnly _totalExpenses As Decimal
        Private ReadOnly _expectedCash As Decimal

        Public Sub New(cashBookID As Integer, openingFloat As Decimal, totalExpenses As Decimal, expectedCash As Decimal)
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            _cashBookID = cashBookID
            _openingFloat = openingFloat
            _totalExpenses = totalExpenses
            _expectedCash = expectedCash
            
            Me.Text = "Petty Cash Reconciliation"
            Me.StartPosition = FormStartPosition.CenterParent
            
            DisplaySummary()
        End Sub

        Private Sub DisplaySummary()
            lblOpeningFloat.Text = $"Opening Float: R {_openingFloat:N2}"
            lblTotalExpenses.Text = $"Less: Total Expenses: R {_totalExpenses:N2}"
            lblExpectedCash.Text = $"Expected Cash: R {_expectedCash:N2}"
        End Sub

        Private Sub nudActualCash_ValueChanged(sender As Object, e As EventArgs) Handles nudActualCash.ValueChanged
            Dim variance = nudActualCash.Value - _expectedCash
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
        End Sub

        Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
            Dim variance = nudActualCash.Value - _expectedCash
            
            If variance <> 0 AndAlso String.IsNullOrWhiteSpace(txtVarianceReason.Text) Then
                MessageBox.Show("Please provide a reason for the variance.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtVarianceReason.Focus()
                Return
            End If
            
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using tx = conn.BeginTransaction()
                        Try
                            ' Insert reconciliation record
                            Dim sql = "INSERT INTO CashBookReconciliation (CashBookID, ReconciliationDate, OpeningBalance, TotalReceipts, TotalPayments, ExpectedClosing, ActualCount, Variance, VarianceReason, ReconciledBy, ReconciledDate, IsApproved) VALUES (@cbid, @date, @open, 0, @exp, @exp, @act, @var, @reason, @user, GETDATE(), 1)"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@cbid", _cashBookID)
                                cmd.Parameters.AddWithValue("@date", DateTime.Today)
                                cmd.Parameters.AddWithValue("@open", _openingFloat)
                                cmd.Parameters.AddWithValue("@exp", _totalExpenses)
                                cmd.Parameters.AddWithValue("@act", nudActualCash.Value)
                                cmd.Parameters.AddWithValue("@var", variance)
                                cmd.Parameters.AddWithValue("@reason", If(String.IsNullOrWhiteSpace(txtVarianceReason.Text), DBNull.Value, CType(txtVarianceReason.Text.Trim(), Object)))
                                cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            ' Update cash book balance to actual count
                            sql = "UPDATE CashBooks SET CurrentBalance = @balance WHERE CashBookID = @cbid"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@balance", nudActualCash.Value)
                                cmd.Parameters.AddWithValue("@cbid", _cashBookID)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            tx.Commit()
                            MessageBox.Show("Petty Cash reconciled successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
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

        Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Sub
    End Class
End Namespace
