Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms

Namespace Accounting
    Partial Public Class PettyCashTopUpForm
        Inherits Form

        Private ReadOnly _connString As String
        Private ReadOnly _pettyCashBookID As Integer

        Public Sub New(pettyCashBookID As Integer)
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            _pettyCashBookID = pettyCashBookID
            
            Me.Text = "Petty Cash Top Up"
            Me.StartPosition = FormStartPosition.CenterParent
            
            LoadCurrentBalance()
        End Sub

        Private Sub LoadCurrentBalance()
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim sql = "SELECT CurrentBalance FROM CashBooks WHERE CashBookID = @id"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@id", _pettyCashBookID)
                        Dim result = cmd.ExecuteScalar()
                        If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                            Dim balance = Convert.ToDecimal(result)
                            lblCurrentBalance.Text = $"Current Petty Cash Balance: R {balance:N2}"
                        End If
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading balance: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnTopUp_Click(sender As Object, e As EventArgs) Handles btnTopUp.Click
            If nudAmount.Value <= 0 Then
                MessageBox.Show("Please enter an amount greater than zero.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If String.IsNullOrWhiteSpace(txtReason.Text) Then
                MessageBox.Show("Please enter a reason for the top up.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtReason.Focus()
                Return
            End If
            
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using tx = conn.BeginTransaction()
                        Try
                            ' Get Main Cash Book ID
                            Dim mainCashBookID As Integer
                            Dim sql = "SELECT TOP 1 CashBookID FROM CashBooks WHERE BranchID = (SELECT BranchID FROM CashBooks WHERE CashBookID = @pcid) AND CashBookType = 'Main' AND IsActive = 1"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@pcid", _pettyCashBookID)
                                Dim result = cmd.ExecuteScalar()
                                If result Is Nothing OrElse IsDBNull(result) Then
                                    Throw New Exception("Main Cash Book not found for this branch")
                                End If
                                mainCashBookID = Convert.ToInt32(result)
                            End Using
                            
                            ' Generate reference number
                            Dim refNumber = $"TOPUP-{DateTime.Now:yyyyMMddHHmmss}"
                            
                            ' Record payment from Main Cash
                            sql = "INSERT INTO CashBookTransactions (CashBookID, TransactionDate, TransactionType, ReferenceNumber, Payee, Description, Amount, PaymentMethod, Notes, CreatedBy, CreatedDate) VALUES (@cbid, @date, 'Payment', @ref, 'Petty Cash', @desc, @amt, 'Cash', @notes, @user, GETDATE())"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@cbid", mainCashBookID)
                                cmd.Parameters.AddWithValue("@date", DateTime.Today)
                                cmd.Parameters.AddWithValue("@ref", refNumber)
                                cmd.Parameters.AddWithValue("@desc", "Top up to Petty Cash")
                                cmd.Parameters.AddWithValue("@amt", nudAmount.Value)
                                cmd.Parameters.AddWithValue("@notes", txtReason.Text.Trim())
                                cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            ' Record receipt in Petty Cash
                            sql = "INSERT INTO CashBookTransactions (CashBookID, TransactionDate, TransactionType, ReferenceNumber, Payee, Description, Amount, PaymentMethod, Notes, CreatedBy, CreatedDate) VALUES (@cbid, @date, 'Receipt', @ref, 'Main Cash', @desc, @amt, 'Cash', @notes, @user, GETDATE())"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@cbid", _pettyCashBookID)
                                cmd.Parameters.AddWithValue("@date", DateTime.Today)
                                cmd.Parameters.AddWithValue("@ref", refNumber)
                                cmd.Parameters.AddWithValue("@desc", "Top up from Main Cash")
                                cmd.Parameters.AddWithValue("@amt", nudAmount.Value)
                                cmd.Parameters.AddWithValue("@notes", txtReason.Text.Trim())
                                cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            ' Update Main Cash balance
                            sql = "UPDATE CashBooks SET CurrentBalance = CurrentBalance - @amt WHERE CashBookID = @cbid"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@amt", nudAmount.Value)
                                cmd.Parameters.AddWithValue("@cbid", mainCashBookID)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            ' Update Petty Cash balance
                            sql = "UPDATE CashBooks SET CurrentBalance = CurrentBalance + @amt WHERE CashBookID = @cbid"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@amt", nudAmount.Value)
                                cmd.Parameters.AddWithValue("@cbid", _pettyCashBookID)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            tx.Commit()
                            MessageBox.Show($"Petty Cash topped up with R{nudAmount.Value:N2}", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            Me.DialogResult = DialogResult.OK
                            Me.Close()
                        Catch ex As Exception
                            tx.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error processing top up: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Sub
    End Class
End Namespace
