Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms

Namespace Accounting
    Partial Public Class JournalEntryViewerForm
        Inherits Form

        Private ReadOnly _connString As String
        Private ReadOnly _journalID As Integer

        Public Sub New(journalID As Integer)
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            _journalID = journalID
            
            Me.Text = "Journal Entry Viewer"
            Me.StartPosition = FormStartPosition.CenterParent
            
            LoadJournalEntry()
        End Sub

        Private Sub LoadJournalEntry()
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_GetJournalEntryDetail", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@JournalID", _journalID)
                        
                        Using da As New SqlDataAdapter(cmd)
                            Dim ds As New DataSet()
                            da.Fill(ds)
                            
                            ' Header
                            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                                Dim row = ds.Tables(0).Rows(0)
                                lblJournalNumber.Text = $"Journal #: {row("JournalNumber")}"
                                lblJournalDate.Text = $"Date: {Convert.ToDateTime(row("JournalDate")):dd/MM/yyyy}"
                                lblReference.Text = $"Reference: {row("Reference")}"
                                lblDescription.Text = $"Description: {row("Description")}"
                                lblBranch.Text = $"Branch: {row("BranchName")}"
                                lblStatus.Text = If(Convert.ToBoolean(row("IsPosted")), "Status: Posted", "Status: Draft")
                                lblStatus.ForeColor = If(Convert.ToBoolean(row("IsPosted")), Color.Green, Color.Orange)
                            End If
                            
                            ' Lines
                            If ds.Tables.Count > 1 Then
                                dgvLines.DataSource = ds.Tables(1)
                                FormatGrid()
                            End If
                            
                            ' Totals
                            If ds.Tables.Count > 2 AndAlso ds.Tables(2).Rows.Count > 0 Then
                                Dim totRow = ds.Tables(2).Rows(0)
                                lblTotalDebit.Text = $"Total Debit: R {Convert.ToDecimal(totRow("TotalDebit")):N2}"
                                lblTotalCredit.Text = $"Total Credit: R {Convert.ToDecimal(totRow("TotalCredit")):N2}"
                                
                                Dim isBalanced = Convert.ToBoolean(totRow("IsBalanced"))
                                lblBalanced.Text = If(isBalanced, "✓ Balanced", "✗ Out of Balance")
                                lblBalanced.ForeColor = If(isBalanced, Color.Green, Color.Red)
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading journal entry: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub FormatGrid()
            If dgvLines.Columns.Count = 0 Then Return
            
            dgvLines.Columns("JournalDetailID").Visible = False
            dgvLines.Columns("AccountID").Visible = False
            
            dgvLines.Columns("AccountCode").HeaderText = "Account Code"
            dgvLines.Columns("AccountCode").Width = 100
            
            dgvLines.Columns("AccountName").HeaderText = "Account Name"
            dgvLines.Columns("AccountName").Width = 250
            
            dgvLines.Columns("AccountType").HeaderText = "Type"
            dgvLines.Columns("AccountType").Width = 80
            
            dgvLines.Columns("Debit").DefaultCellStyle.Format = "N2"
            dgvLines.Columns("Debit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            dgvLines.Columns("Debit").Width = 120
            
            dgvLines.Columns("Credit").DefaultCellStyle.Format = "N2"
            dgvLines.Columns("Credit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            dgvLines.Columns("Credit").Width = 120
            
            dgvLines.Columns("Description").Width = 200
            
            dgvLines.AlternatingRowsDefaultCellStyle.BackColor = Color.LightGray
        End Sub

        Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
            Me.Close()
        End Sub

        Private Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click
            MessageBox.Show("Print functionality not yet implemented.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub
    End Class
End Namespace
