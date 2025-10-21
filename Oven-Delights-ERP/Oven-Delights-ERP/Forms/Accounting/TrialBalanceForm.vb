Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms

Namespace Accounting
    Partial Public Class TrialBalanceForm
        Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchID As Integer

    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _currentBranchID = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
        
        Me.Text = "Trial Balance"
        Me.WindowState = FormWindowState.Maximized
        
        LoadAccountTypes()
        LoadBranches()
        LoadTrialBalance()
    End Sub

    Private Sub LoadAccountTypes()
        Try
            cboAccountType.Items.Clear()
            cboAccountType.Items.Add("All")
            cboAccountType.Items.Add("Asset")
            cboAccountType.Items.Add("Liability")
            cboAccountType.Items.Add("Equity")
            cboAccountType.Items.Add("Revenue")
            cboAccountType.Items.Add("Expense")
            cboAccountType.SelectedIndex = 0
        Catch ex As Exception
            MessageBox.Show($"Error loading account types: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadBranches()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                Using da As New SqlDataAdapter(sql, conn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    
                    Dim allRow = dt.NewRow()
                    allRow("BranchID") = DBNull.Value
                    allRow("BranchName") = "All Branches"
                    dt.Rows.InsertAt(allRow, 0)
                    
                    cboBranch.DataSource = dt
                    cboBranch.DisplayMember = "BranchName"
                    cboBranch.ValueMember = "BranchID"
                    
                    If _currentBranchID > 0 Then
                        cboBranch.SelectedValue = _currentBranchID
                    Else
                        cboBranch.SelectedIndex = 0
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadTrialBalance()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GetTrialBalance", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    
                    cmd.Parameters.AddWithValue("@FromDate", If(dtpFromDate.Checked, CType(dtpFromDate.Value, Object), DBNull.Value))
                    cmd.Parameters.AddWithValue("@ToDate", If(dtpToDate.Checked, CType(dtpToDate.Value, Object), DBNull.Value))
                    
                    Dim branchID As Object = If(cboBranch.SelectedValue IsNot Nothing AndAlso Not IsDBNull(cboBranch.SelectedValue), cboBranch.SelectedValue, DBNull.Value)
                    cmd.Parameters.AddWithValue("@BranchID", branchID)
                    
                    Dim accountType As String = If(cboAccountType.SelectedIndex > 0, cboAccountType.SelectedItem.ToString(), Nothing)
                    cmd.Parameters.AddWithValue("@AccountType", If(accountType, DBNull.Value))
                    cmd.Parameters.AddWithValue("@ShowZeroBalances", chkShowZero.Checked)
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        
                        dgvTrialBalance.DataSource = dt
                        FormatGrid()
                        CalculateTotals(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading trial balance: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub FormatGrid()
        If dgvTrialBalance.Columns.Count = 0 Then Return
        
        dgvTrialBalance.Columns("AccountCode").HeaderText = "Code"
        dgvTrialBalance.Columns("AccountCode").Width = 100
        
        dgvTrialBalance.Columns("AccountName").HeaderText = "Account Name"
        dgvTrialBalance.Columns("AccountName").Width = 300
        
        dgvTrialBalance.Columns("AccountType").HeaderText = "Type"
        dgvTrialBalance.Columns("AccountType").Width = 100
        
        dgvTrialBalance.Columns("TotalDebit").HeaderText = "Debit"
        dgvTrialBalance.Columns("TotalDebit").DefaultCellStyle.Format = "N2"
        dgvTrialBalance.Columns("TotalDebit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        dgvTrialBalance.Columns("TotalDebit").Width = 120
        
        dgvTrialBalance.Columns("TotalCredit").HeaderText = "Credit"
        dgvTrialBalance.Columns("TotalCredit").DefaultCellStyle.Format = "N2"
        dgvTrialBalance.Columns("TotalCredit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        dgvTrialBalance.Columns("TotalCredit").Width = 120
        
        dgvTrialBalance.Columns("NetBalance").HeaderText = "Net Balance"
        dgvTrialBalance.Columns("NetBalance").DefaultCellStyle.Format = "N2"
        dgvTrialBalance.Columns("NetBalance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        dgvTrialBalance.Columns("NetBalance").Width = 120
        
        dgvTrialBalance.Columns("TransactionCount").HeaderText = "Txns"
        dgvTrialBalance.Columns("TransactionCount").Width = 60
        
        dgvTrialBalance.AlternatingRowsDefaultCellStyle.BackColor = Color.LightGray
        dgvTrialBalance.EnableHeadersVisualStyles = False
        dgvTrialBalance.ColumnHeadersDefaultCellStyle.BackColor = Color.Navy
        dgvTrialBalance.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvTrialBalance.ColumnHeadersDefaultCellStyle.Font = New Font(dgvTrialBalance.Font, FontStyle.Bold)
    End Sub

    Private Sub CalculateTotals(dt As DataTable)
        Dim totalDebit As Decimal = 0
        Dim totalCredit As Decimal = 0
        
        For Each row As DataRow In dt.Rows
            totalDebit += Convert.ToDecimal(row("TotalDebit"))
            totalCredit += Convert.ToDecimal(row("TotalCredit"))
        Next
        
        lblTotalDebit.Text = $"Total Debit: {totalDebit:N2}"
        lblTotalCredit.Text = $"Total Credit: {totalCredit:N2}"
        lblDifference.Text = $"Difference: {Math.Abs(totalDebit - totalCredit):N2}"
        
        If Math.Abs(totalDebit - totalCredit) < 0.01 Then
            lblDifference.ForeColor = Color.Green
            lblDifference.Text &= " ✓ Balanced"
        Else
            lblDifference.ForeColor = Color.Red
            lblDifference.Text &= " ✗ Out of Balance"
        End If
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadTrialBalance()
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Try
            Dim sfd As New SaveFileDialog()
            sfd.Filter = "Excel Files|*.xlsx"
            sfd.FileName = $"TrialBalance_{DateTime.Now:yyyyMMdd}.xlsx"
            
            If sfd.ShowDialog() = DialogResult.OK Then
                ExportToExcel(sfd.FileName)
                MessageBox.Show("Trial Balance exported successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error exporting: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ExportToExcel(filePath As String)
        ' Simple CSV export (Excel compatible)
        Using sw As New System.IO.StreamWriter(filePath)
            ' Header
            sw.WriteLine("Code,Account Name,Type,Debit,Credit,Net Balance,Transactions")
            
            ' Data
            For Each row As DataGridViewRow In dgvTrialBalance.Rows
                If Not row.IsNewRow Then
                    sw.WriteLine($"{row.Cells("AccountCode").Value},{row.Cells("AccountName").Value},{row.Cells("AccountType").Value},{row.Cells("TotalDebit").Value},{row.Cells("TotalCredit").Value},{row.Cells("NetBalance").Value},{row.Cells("TransactionCount").Value}")
                End If
            Next
        End Using
    End Sub

    Private Sub dgvTrialBalance_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvTrialBalance.CellDoubleClick
        If e.RowIndex >= 0 Then
            Try
                Dim accountCode = dgvTrialBalance.Rows(e.RowIndex).Cells("AccountCode").Value.ToString()
                Dim accountName = dgvTrialBalance.Rows(e.RowIndex).Cells("AccountName").Value.ToString()
                
                ' Open Account Ledger form
                Dim ledgerForm As New AccountLedgerForm(accountCode, accountName)
                ledgerForm.ShowDialog()
            Catch ex As Exception
                MessageBox.Show($"Error opening account ledger: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
    End Class
End Namespace
