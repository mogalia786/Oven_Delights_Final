Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms

Namespace Accounting
    Partial Public Class AccountLedgerForm
        Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchID As Integer
    Private _selectedAccountCode As String
    Private _selectedAccountName As String

    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _currentBranchID = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
        
        Me.Text = "Account Ledger"
        Me.WindowState = FormWindowState.Maximized
        
        LoadAccounts()
        LoadBranches()
    End Sub

    Public Sub New(accountCode As String, accountName As String)
        Me.New()
        _selectedAccountCode = accountCode
        _selectedAccountName = accountName
        
        ' Select the account in dropdown
        For i As Integer = 0 To cboAccount.Items.Count - 1
            Dim item = TryCast(cboAccount.Items(i), ComboBoxItem)
            If item IsNot Nothing AndAlso item.Code = accountCode Then
                cboAccount.SelectedIndex = i
                Exit For
            End If
        Next
        
        LoadLedger()
    End Sub

    Private Sub LoadAccounts()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Dim sql = "SELECT AccountID, AccountCode, AccountName FROM ChartOfAccounts WHERE IsActive = 1 ORDER BY AccountCode"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        cboAccount.Items.Clear()
                        While reader.Read()
                            Dim item As New ComboBoxItem With {
                                .ID = reader.GetInt32(0),
                                .Code = reader.GetString(1),
                                .Name = reader.GetString(2),
                                .DisplayText = $"{reader.GetString(1)} - {reader.GetString(2)}"
                            }
                            cboAccount.Items.Add(item)
                        End While
                    End Using
                End Using
            End Using
            
            cboAccount.DisplayMember = "DisplayText"
            If Not String.IsNullOrEmpty(_selectedAccountCode) Then
                lblAccountName.Text = _selectedAccountName
            End If
        Catch ex As Exception
            MessageBox.Show($"Error loading accounts: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
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

    Private Sub LoadLedger()
        Dim selectedItem = TryCast(cboAccount.SelectedItem, ComboBoxItem)
        If selectedItem Is Nothing Then Return
        
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GetAccountLedger", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    
                    cmd.Parameters.AddWithValue("@AccountID", selectedItem.ID)
                    cmd.Parameters.AddWithValue("@FromDate", If(dtpFromDate.Checked, CType(dtpFromDate.Value, Object), DBNull.Value))
                    cmd.Parameters.AddWithValue("@ToDate", If(dtpToDate.Checked, CType(dtpToDate.Value, Object), DBNull.Value))
                    
                    Dim branchID As Object = If(cboBranch.SelectedValue IsNot Nothing AndAlso Not IsDBNull(cboBranch.SelectedValue), cboBranch.SelectedValue, DBNull.Value)
                    cmd.Parameters.AddWithValue("@BranchID", branchID)
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim ds As New DataSet()
                        da.Fill(ds)
                        
                        If ds.Tables.Count > 0 Then
                            dgvLedger.DataSource = ds.Tables(0)
                            FormatGrid()
                        End If
                        
                        If ds.Tables.Count > 1 AndAlso ds.Tables(1).Rows.Count > 0 Then
                            Dim summaryRow = ds.Tables(1).Rows(0)
                            lblOpeningBalance.Text = $"Opening Balance: {Convert.ToDecimal(summaryRow("OpeningBalance")):N2}"
                            lblTotalDebits.Text = $"Total Debits: {Convert.ToDecimal(summaryRow("TotalDebits")):N2}"
                            lblTotalCredits.Text = $"Total Credits: {Convert.ToDecimal(summaryRow("TotalCredits")):N2}"
                            lblClosingBalance.Text = $"Closing Balance: {Convert.ToDecimal(summaryRow("ClosingBalance")):N2}"
                            lblTransactionCount.Text = $"Transactions: {summaryRow("TransactionCount")}"
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading ledger: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub FormatGrid()
        If dgvLedger.Columns.Count = 0 Then Return
        
        dgvLedger.Columns("JournalDate").HeaderText = "Date"
        dgvLedger.Columns("JournalDate").Width = 100
        dgvLedger.Columns("JournalDate").DefaultCellStyle.Format = "dd/MM/yyyy"
        
        dgvLedger.Columns("JournalNumber").HeaderText = "Journal #"
        dgvLedger.Columns("JournalNumber").Width = 150
        
        dgvLedger.Columns("Reference").HeaderText = "Reference"
        dgvLedger.Columns("Reference").Width = 120
        
        dgvLedger.Columns("Description").HeaderText = "Description"
        dgvLedger.Columns("Description").Width = 250
        
        dgvLedger.Columns("Debit").HeaderText = "Debit"
        dgvLedger.Columns("Debit").DefaultCellStyle.Format = "N2"
        dgvLedger.Columns("Debit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        dgvLedger.Columns("Debit").Width = 120
        
        dgvLedger.Columns("Credit").HeaderText = "Credit"
        dgvLedger.Columns("Credit").DefaultCellStyle.Format = "N2"
        dgvLedger.Columns("Credit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        dgvLedger.Columns("Credit").Width = 120
        
        dgvLedger.Columns("RunningBalance").HeaderText = "Balance"
        dgvLedger.Columns("RunningBalance").DefaultCellStyle.Format = "N2"
        dgvLedger.Columns("RunningBalance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        dgvLedger.Columns("RunningBalance").Width = 120
        
        If dgvLedger.Columns.Contains("JournalID") Then
            dgvLedger.Columns("JournalID").Visible = False
        End If
        If dgvLedger.Columns.Contains("BranchID") Then
            dgvLedger.Columns("BranchID").Visible = False
        End If
        If dgvLedger.Columns.Contains("LineDescription") Then
            dgvLedger.Columns("LineDescription").Visible = False
        End If
        
        dgvLedger.AlternatingRowsDefaultCellStyle.BackColor = Color.LightGray
        dgvLedger.EnableHeadersVisualStyles = False
        dgvLedger.ColumnHeadersDefaultCellStyle.BackColor = Color.Navy
        dgvLedger.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvLedger.ColumnHeadersDefaultCellStyle.Font = New Font(dgvLedger.Font, FontStyle.Bold)
    End Sub

    Private Sub cboAccount_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboAccount.SelectedIndexChanged
        Dim selectedItem = TryCast(cboAccount.SelectedItem, ComboBoxItem)
        If selectedItem IsNot Nothing Then
            lblAccountName.Text = selectedItem.Name
        End If
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadLedger()
    End Sub

    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Try
            Dim sfd As New SaveFileDialog()
            sfd.Filter = "Excel Files|*.xlsx"
            sfd.FileName = $"AccountLedger_{DateTime.Now:yyyyMMdd}.xlsx"
            
            If sfd.ShowDialog() = DialogResult.OK Then
                ExportToExcel(sfd.FileName)
                MessageBox.Show("Account Ledger exported successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error exporting: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ExportToExcel(filePath As String)
        Using sw As New System.IO.StreamWriter(filePath)
            ' Header
            sw.WriteLine("Date,Journal #,Reference,Description,Debit,Credit,Balance")
            
            ' Data
            For Each row As DataGridViewRow In dgvLedger.Rows
                If Not row.IsNewRow Then
                    sw.WriteLine($"{row.Cells("JournalDate").Value},{row.Cells("JournalNumber").Value},{row.Cells("Reference").Value},{row.Cells("Description").Value},{row.Cells("Debit").Value},{row.Cells("Credit").Value},{row.Cells("RunningBalance").Value}")
                End If
            Next
        End Using
    End Sub

    Private Sub dgvLedger_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvLedger.CellDoubleClick
        If e.RowIndex >= 0 Then
            Try
                Dim journalID = Convert.ToInt32(dgvLedger.Rows(e.RowIndex).Cells("JournalID").Value)
                
                ' Open Journal Entry Viewer
                Dim journalForm As New JournalEntryViewerForm(journalID)
                journalForm.ShowDialog()
            Catch ex As Exception
                MessageBox.Show($"Error opening journal entry: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub

    Private Class ComboBoxItem
        Public Property ID As Integer
        Public Property Code As String
        Public Property Name As String
        Public Property DisplayText As String
    End Class
    End Class
End Namespace
