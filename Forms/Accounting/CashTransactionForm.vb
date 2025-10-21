Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms

Namespace Accounting
    Partial Public Class CashTransactionForm
        Inherits Form

        Private ReadOnly _connString As String
        Private ReadOnly _cashBookID As Integer
        Private ReadOnly _transactionType As String
        Private ReadOnly _transactionDate As Date

        Public Sub New(cashBookID As Integer, transactionType As String, transactionDate As Date)
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            _cashBookID = cashBookID
            _transactionType = transactionType
            _transactionDate = transactionDate
            
            Me.Text = $"New {transactionType}"
            Me.StartPosition = FormStartPosition.CenterParent
            
            lblTitle.Text = $"Record Cash {transactionType}"
            lblPayee.Text = If(transactionType = "Receipt", "Received From:", "Paid To:")
            
            LoadCategories()
            GenerateReferenceNumber()
        End Sub

        Private Sub LoadCategories()
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim sql = "SELECT CategoryID, CategoryName FROM ExpenseCategories WHERE IsActive = 1 ORDER BY CategoryName"
                    Using da As New SqlDataAdapter(sql, conn)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        
                        Dim allRow = dt.NewRow()
                        allRow("CategoryID") = DBNull.Value
                        allRow("CategoryName") = "-- Select Category --"
                        dt.Rows.InsertAt(allRow, 0)
                        
                        cboCategory.DataSource = dt
                        cboCategory.DisplayMember = "CategoryName"
                        cboCategory.ValueMember = "CategoryID"
                        cboCategory.SelectedIndex = 0
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading categories: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub GenerateReferenceNumber()
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim prefix = If(_transactionType = "Receipt", "R", "P")
                    Dim sql = $"SELECT TOP 1 ReferenceNumber FROM CashBookTransactions WHERE CashBookID = @cbid AND TransactionType = @type AND TransactionDate = @date ORDER BY TransactionID DESC"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@cbid", _cashBookID)
                        cmd.Parameters.AddWithValue("@type", _transactionType)
                        cmd.Parameters.AddWithValue("@date", _transactionDate)
                        Dim lastRef = cmd.ExecuteScalar()
                        
                        If lastRef IsNot Nothing AndAlso Not IsDBNull(lastRef) Then
                            Dim lastRefStr = lastRef.ToString()
                            Dim numPart = lastRefStr.Substring(1)
                            If Integer.TryParse(numPart, Nothing) Then
                                Dim nextNum = Integer.Parse(numPart) + 1
                                txtReference.Text = $"{prefix}{nextNum:D3}"
                            Else
                                txtReference.Text = $"{prefix}001"
                            End If
                        Else
                            txtReference.Text = $"{prefix}001"
                        End If
                    End Using
                End Using
            Catch ex As Exception
                txtReference.Text = If(_transactionType = "Receipt", "R001", "P001")
            End Try
        End Sub

        Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
            If Not ValidateInput() Then Return
            
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using tx = conn.BeginTransaction()
                        Try
                            ' Insert transaction
                            Dim sql = "INSERT INTO CashBookTransactions (CashBookID, TransactionDate, TransactionType, ReferenceNumber, Payee, Description, Amount, CategoryID, PaymentMethod, Notes, CreatedBy, CreatedDate) VALUES (@cbid, @date, @type, @ref, @payee, @desc, @amt, @cat, @method, @notes, @user, GETDATE())"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@cbid", _cashBookID)
                                cmd.Parameters.AddWithValue("@date", _transactionDate)
                                cmd.Parameters.AddWithValue("@type", _transactionType)
                                cmd.Parameters.AddWithValue("@ref", txtReference.Text.Trim())
                                cmd.Parameters.AddWithValue("@payee", txtPayee.Text.Trim())
                                cmd.Parameters.AddWithValue("@desc", txtDescription.Text.Trim())
                                cmd.Parameters.AddWithValue("@amt", nudAmount.Value)
                                
                                Dim catID As Object = If(cboCategory.SelectedValue IsNot Nothing AndAlso Not IsDBNull(cboCategory.SelectedValue), cboCategory.SelectedValue, DBNull.Value)
                                cmd.Parameters.AddWithValue("@cat", catID)
                                cmd.Parameters.AddWithValue("@method", "Cash")
                                cmd.Parameters.AddWithValue("@notes", If(String.IsNullOrWhiteSpace(txtNotes.Text), DBNull.Value, CType(txtNotes.Text.Trim(), Object)))
                                cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                                
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            ' Update cash book balance
                            Dim balanceChange = If(_transactionType = "Receipt", nudAmount.Value, -nudAmount.Value)
                            sql = "UPDATE CashBooks SET CurrentBalance = CurrentBalance + @change WHERE CashBookID = @cbid"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@change", balanceChange)
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
                MessageBox.Show($"Error saving transaction: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function ValidateInput() As Boolean
            If String.IsNullOrWhiteSpace(txtPayee.Text) Then
                MessageBox.Show("Please enter payee/payer name.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtPayee.Focus()
                Return False
            End If
            
            If nudAmount.Value <= 0 Then
                MessageBox.Show("Amount must be greater than zero.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                nudAmount.Focus()
                Return False
            End If
            
            If String.IsNullOrWhiteSpace(txtDescription.Text) Then
                MessageBox.Show("Please enter description.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtDescription.Focus()
                Return False
            End If
            
            If _transactionType = "Payment" AndAlso nudAmount.Value > 500 Then
                Dim result = MessageBox.Show($"Payment amount is R{nudAmount.Value:N2}. Payments over R500 require manager approval. Continue?", "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
                If result = DialogResult.No Then Return False
            End If
            
            Return True
        End Function

        Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
            Me.DialogResult = DialogResult.Cancel
            Me.Close()
        End Sub
    End Class
End Namespace
