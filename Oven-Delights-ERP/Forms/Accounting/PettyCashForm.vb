Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms

Namespace Accounting
    Partial Public Class PettyCashForm
        Inherits Form

        Private ReadOnly _connString As String
        Private _currentCashBookID As Integer
        Private _currentBranchID As Integer
        Private _openingFloat As Decimal = 0

        Public Sub New()
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            _currentBranchID = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
            
            Me.Text = "Petty Cash Management"
            Me.WindowState = FormWindowState.Maximized
            
            LoadPettyCashBook()
            LoadCategories()
            LoadTodaysVouchers()
            CalculateTotals()
        End Sub

        Private Sub LoadPettyCashBook()
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim sql = "SELECT CashBookID, CurrentBalance FROM CashBooks WHERE BranchID = @bid AND CashBookType = 'Petty' AND IsActive = 1"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@bid", _currentBranchID)
                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                _currentCashBookID = reader.GetInt32(0)
                                _openingFloat = reader.GetDecimal(1)
                                lblOpeningFloat.Text = $"Opening Float: R {_openingFloat:N2}"
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading petty cash book: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadCategories()
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim sql = "SELECT CategoryID, CategoryName FROM ExpenseCategories WHERE IsActive = 1 ORDER BY CategoryName"
                    Using da As New SqlDataAdapter(sql, conn)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        
                        cboCategory.DataSource = dt
                        cboCategory.DisplayMember = "CategoryName"
                        cboCategory.ValueMember = "CategoryID"
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading categories: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadTodaysVouchers()
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim sql = "SELECT pv.VoucherNumber, CONVERT(VARCHAR(5), pv.VoucherDate, 108) AS Time, pv.Payee, ec.CategoryName AS Category, pv.Amount, pv.ReceiptAttached FROM PettyCashVouchers pv LEFT JOIN ExpenseCategories ec ON pv.CategoryID = ec.CategoryID INNER JOIN CashBookTransactions cbt ON pv.TransactionID = cbt.TransactionID WHERE cbt.CashBookID = @cbid AND cbt.TransactionDate = @date AND cbt.IsVoid = 0 ORDER BY pv.VoucherDate DESC"
                    Using da As New SqlDataAdapter(sql, conn)
                        da.SelectCommand.Parameters.AddWithValue("@cbid", _currentCashBookID)
                        da.SelectCommand.Parameters.AddWithValue("@date", DateTime.Today)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvVouchers.DataSource = dt
                        FormatVouchersGrid()
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading vouchers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub FormatVouchersGrid()
            If dgvVouchers.Columns.Count = 0 Then Return
            
            dgvVouchers.Columns("VoucherNumber").HeaderText = "Voucher#"
            dgvVouchers.Columns("VoucherNumber").Width = 100
            dgvVouchers.Columns("Time").Width = 60
            dgvVouchers.Columns("Payee").Width = 150
            dgvVouchers.Columns("Category").Width = 120
            dgvVouchers.Columns("Amount").DefaultCellStyle.Format = "N2"
            dgvVouchers.Columns("Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            dgvVouchers.Columns("Amount").Width = 100
            dgvVouchers.Columns("ReceiptAttached").HeaderText = "✓"
            dgvVouchers.Columns("ReceiptAttached").Width = 30
        End Sub

        Private Sub CalculateTotals()
            Dim totalExpenses As Decimal = 0
            
            For Each row As DataGridViewRow In dgvVouchers.Rows
                If Not row.IsNewRow Then
                    totalExpenses += Convert.ToDecimal(row.Cells("Amount").Value)
                End If
            Next
            
            lblTotalExpenses.Text = $"Total Expenses: R {totalExpenses:N2}"
            
            Dim remainingCash = _openingFloat - totalExpenses
            lblRemainingCash.Text = $"Remaining Cash: R {remainingCash:N2}"
        End Sub

        Private Sub btnNewVoucher_Click(sender As Object, e As EventArgs) Handles btnNewVoucher.Click
            If Not ValidateVoucherInput() Then Return
            
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using tx = conn.BeginTransaction()
                        Try
                            ' Generate voucher number
                            Dim voucherNumber = GenerateVoucherNumber(conn, tx)
                            
                            ' Insert cash book transaction
                            Dim sql = "INSERT INTO CashBookTransactions (CashBookID, TransactionDate, TransactionType, ReferenceNumber, Payee, Description, Amount, CategoryID, PaymentMethod, CreatedBy, CreatedDate) OUTPUT INSERTED.TransactionID VALUES (@cbid, @date, 'Payment', @ref, @payee, @desc, @amt, @cat, 'Cash', @user, GETDATE())"
                            Dim transactionID As Integer
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@cbid", _currentCashBookID)
                                cmd.Parameters.AddWithValue("@date", DateTime.Today)
                                cmd.Parameters.AddWithValue("@ref", voucherNumber)
                                cmd.Parameters.AddWithValue("@payee", txtPayee.Text.Trim())
                                cmd.Parameters.AddWithValue("@desc", txtPurpose.Text.Trim())
                                cmd.Parameters.AddWithValue("@amt", nudAmount.Value)
                                cmd.Parameters.AddWithValue("@cat", cboCategory.SelectedValue)
                                cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                                
                                transactionID = Convert.ToInt32(cmd.ExecuteScalar())
                            End Using
                            
                            ' Insert petty cash voucher
                            sql = "INSERT INTO PettyCashVouchers (TransactionID, VoucherNumber, VoucherDate, Payee, Amount, Purpose, CategoryID, ReceiptAttached, CreatedBy, CreatedDate) VALUES (@tid, @vnum, GETDATE(), @payee, @amt, @purpose, @cat, @receipt, @user, GETDATE())"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@tid", transactionID)
                                cmd.Parameters.AddWithValue("@vnum", voucherNumber)
                                cmd.Parameters.AddWithValue("@payee", txtPayee.Text.Trim())
                                cmd.Parameters.AddWithValue("@amt", nudAmount.Value)
                                cmd.Parameters.AddWithValue("@purpose", txtPurpose.Text.Trim())
                                cmd.Parameters.AddWithValue("@cat", cboCategory.SelectedValue)
                                cmd.Parameters.AddWithValue("@receipt", chkReceiptAttached.Checked)
                                cmd.Parameters.AddWithValue("@user", AppSession.CurrentUserID)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            ' Update cash book balance
                            sql = "UPDATE CashBooks SET CurrentBalance = CurrentBalance - @amt WHERE CashBookID = @cbid"
                            Using cmd As New SqlCommand(sql, conn, tx)
                                cmd.Parameters.AddWithValue("@amt", nudAmount.Value)
                                cmd.Parameters.AddWithValue("@cbid", _currentCashBookID)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            tx.Commit()
                            
                            ' Clear form
                            txtPayee.Clear()
                            txtPurpose.Clear()
                            nudAmount.Value = 0
                            chkReceiptAttached.Checked = False
                            cboCategory.SelectedIndex = 0
                            
                            ' Reload
                            LoadPettyCashBook()
                            LoadTodaysVouchers()
                            CalculateTotals()
                            
                            MessageBox.Show($"Voucher {voucherNumber} created successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Catch ex As Exception
                            tx.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error creating voucher: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function GenerateVoucherNumber(conn As SqlConnection, tx As SqlTransaction) As String
            Dim sql = "SELECT TOP 1 VoucherNumber FROM PettyCashVouchers WHERE VoucherDate >= @startDate ORDER BY VoucherID DESC"
            Using cmd As New SqlCommand(sql, conn, tx)
                cmd.Parameters.AddWithValue("@startDate", New DateTime(DateTime.Today.Year, 1, 1))
                Dim lastVoucher = cmd.ExecuteScalar()
                
                If lastVoucher IsNot Nothing AndAlso Not IsDBNull(lastVoucher) Then
                    Dim lastNum = lastVoucher.ToString()
                    ' Format: PV-YYYY-NNN
                    Dim parts = lastNum.Split("-"c)
                    If parts.Length = 3 AndAlso Integer.TryParse(parts(2), Nothing) Then
                        Dim nextNum = Integer.Parse(parts(2)) + 1
                        Return $"PV-{DateTime.Today.Year}-{nextNum:D3}"
                    End If
                End If
                
                Return $"PV-{DateTime.Today.Year}-001"
            End Using
        End Function

        Private Function ValidateVoucherInput() As Boolean
            If String.IsNullOrWhiteSpace(txtPayee.Text) Then
                MessageBox.Show("Please enter payee name.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtPayee.Focus()
                Return False
            End If
            
            If nudAmount.Value <= 0 Then
                MessageBox.Show("Amount must be greater than zero.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                nudAmount.Focus()
                Return False
            End If
            
            If nudAmount.Value > 500 Then
                MessageBox.Show("Petty cash vouchers are limited to R500. For larger amounts, use Main Cash Book.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                nudAmount.Focus()
                Return False
            End If
            
            If String.IsNullOrWhiteSpace(txtPurpose.Text) Then
                MessageBox.Show("Please enter purpose.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtPurpose.Focus()
                Return False
            End If
            
            If cboCategory.SelectedIndex < 0 Then
                MessageBox.Show("Please select a category.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                cboCategory.Focus()
                Return False
            End If
            
            If nudAmount.Value > 50 AndAlso Not chkReceiptAttached.Checked Then
                Dim result = MessageBox.Show("Amount exceeds R50 but no receipt attached. Continue anyway?", "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
                If result = DialogResult.No Then Return False
            End If
            
            If nudAmount.Value > 100 Then
                Dim result = MessageBox.Show("Amount exceeds R100. Manager approval required. Continue?", "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
                If result = DialogResult.No Then Return False
            End If
            
            Return True
        End Function

        Private Sub btnTopUp_Click(sender As Object, e As EventArgs) Handles btnTopUp.Click
            Dim form As New PettyCashTopUpForm(_currentCashBookID)
            If form.ShowDialog() = DialogResult.OK Then
                LoadPettyCashBook()
                CalculateTotals()
            End If
        End Sub

        Private Sub btnReconcile_Click(sender As Object, e As EventArgs) Handles btnReconcile.Click
            Dim totalExpenses As Decimal = 0
            For Each row As DataGridViewRow In dgvVouchers.Rows
                If Not row.IsNewRow Then
                    totalExpenses += Convert.ToDecimal(row.Cells("Amount").Value)
                End If
            Next
            
            Dim expectedCash = _openingFloat - totalExpenses
            
            Dim form As New PettyCashReconciliationForm(_currentCashBookID, _openingFloat, totalExpenses, expectedCash)
            If form.ShowDialog() = DialogResult.OK Then
                LoadPettyCashBook()
                LoadTodaysVouchers()
                CalculateTotals()
            End If
        End Sub

        Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
            Me.Close()
        End Sub
    End Class
End Namespace
