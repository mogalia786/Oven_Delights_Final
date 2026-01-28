Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Accounting
    Public Class EFTClearingForm
        Inherits Form

        Private WithEvents dgvUncleared As DataGridView
        Private WithEvents dgvHistory As DataGridView
        Private WithEvents btnMarkCleared As Button
        Private WithEvents btnRefresh As Button
        Private WithEvents cboBranch As ComboBox
        Private WithEvents tabControl As TabControl
        Private _connString As String
        Private _currentBranchID As Integer
        Private _currentUserID As Integer

        Public Sub New()
            InitializeComponent()
            _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            _currentBranchID = If(AppSession.CurrentBranchID > 0, AppSession.CurrentBranchID, 0)
            _currentUserID = If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 1)
            
            LoadBranches()
            LoadUnclearedEFTs()
            LoadClearingHistory()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "EFT Clearing Management"
            Me.Size = New Size(1400, 800)
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            ' Header Panel
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = Color.FromArgb(41, 128, 185),
                .Padding = New Padding(20)
            }

            Dim lblTitle As New Label() With {
                .Text = "EFT Clearing Management",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 15)
            }
            pnlHeader.Controls.Add(lblTitle)

            Dim lblSubtitle As New Label() With {
                .Text = "Clear pending EFT transactions and view clearing history",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 45)
            }
            pnlHeader.Controls.Add(lblSubtitle)

            ' Toolbar Panel
            Dim pnlToolbar As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 60,
                .BackColor = Color.FromArgb(236, 240, 241),
                .Padding = New Padding(20, 10, 20, 10)
            }

            Dim lblBranch As New Label() With {
                .Text = "Branch:",
                .Location = New Point(20, 18),
                .AutoSize = True
            }
            pnlToolbar.Controls.Add(lblBranch)

            cboBranch = New ComboBox() With {
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Location = New Point(80, 15),
                .Width = 200
            }
            pnlToolbar.Controls.Add(cboBranch)

            btnRefresh = New Button() With {
                .Text = "🔄 Refresh",
                .Location = New Point(300, 13),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            pnlToolbar.Controls.Add(btnRefresh)

            btnMarkCleared = New Button() With {
                .Text = "✓ Mark as Cleared",
                .Location = New Point(420, 13),
                .Size = New Size(140, 35),
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Enabled = False
            }
            pnlToolbar.Controls.Add(btnMarkCleared)

            ' Tab Control
            tabControl = New TabControl() With {
                .Dock = DockStyle.Fill,
                .Padding = New Point(20, 5)
            }

            ' Tab 1: Uncleared EFTs
            Dim tabUncleared As New TabPage("Uncleared EFTs") With {
                .BackColor = Color.White,
                .Padding = New Padding(10)
            }

            dgvUncleared = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {.BackColor = Color.FromArgb(245, 245, 245)}
            }
            AddHandler dgvUncleared.SelectionChanged, AddressOf OnUnclearedSelectionChanged
            tabUncleared.Controls.Add(dgvUncleared)

            ' Tab 2: Clearing History
            Dim tabHistory As New TabPage("Clearing History") With {
                .BackColor = Color.White,
                .Padding = New Padding(10)
            }

            dgvHistory = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {.BackColor = Color.FromArgb(245, 245, 245)}
            }
            tabHistory.Controls.Add(dgvHistory)

            tabControl.TabPages.Add(tabUncleared)
            tabControl.TabPages.Add(tabHistory)

            Me.Controls.Add(tabControl)
            Me.Controls.Add(pnlToolbar)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadBranches()
            Try
                cboBranch.Items.Clear()
                
                If _currentBranchID = 0 Then
                    ' Super Admin - show all branches
                    cboBranch.Items.Add(New With {.BranchID = 0, .BranchName = "All Branches"})
                    
                    Using conn As New SqlConnection(_connString)
                        conn.Open()
                        Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                        Using cmd As New SqlCommand(sql, conn)
                            Using reader = cmd.ExecuteReader()
                                While reader.Read()
                                    cboBranch.Items.Add(New With {
                                        .BranchID = reader.GetInt32(0),
                                        .BranchName = reader.GetString(1)
                                    })
                                End While
                            End Using
                        End Using
                    End Using
                Else
                    ' Regular user - locked to their branch
                    Using conn As New SqlConnection(_connString)
                        conn.Open()
                        Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE BranchID = @BranchID"
                        Using cmd As New SqlCommand(sql, conn)
                            cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                            Using reader = cmd.ExecuteReader()
                                If reader.Read() Then
                                    cboBranch.Items.Add(New With {
                                        .BranchID = reader.GetInt32(0),
                                        .BranchName = reader.GetString(1)
                                    })
                                End If
                            End Using
                        End Using
                    End Using
                    cboBranch.Enabled = False
                End If
                
                cboBranch.DisplayMember = "BranchName"
                cboBranch.ValueMember = "BranchID"
                If cboBranch.Items.Count > 0 Then cboBranch.SelectedIndex = 0
            Catch ex As Exception
                MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadUnclearedEFTs()
            Try
                Dim branchID As Integer? = Nothing
                If cboBranch.SelectedItem IsNot Nothing Then
                    Dim selectedBranch = DirectCast(cboBranch.SelectedItem, Object)
                    Dim bid = CInt(selectedBranch.BranchID)
                    If bid > 0 Then branchID = bid
                End If

                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_EFT_GetUnclearedTransactions", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        If branchID.HasValue Then
                            cmd.Parameters.AddWithValue("@BranchID", branchID.Value)
                        Else
                            cmd.Parameters.AddWithValue("@BranchID", DBNull.Value)
                        End If

                        Dim dt As New DataTable()
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(dt)
                        End Using

                        dgvUncleared.DataSource = dt

                        If dgvUncleared.Columns.Count > 0 Then
                            dgvUncleared.Columns("JournalID").Visible = False
                            dgvUncleared.Columns("BranchID").Visible = False
                            dgvUncleared.Columns("JournalNumber").HeaderText = "Journal #"
                            dgvUncleared.Columns("JournalDate").HeaderText = "Date"
                            dgvUncleared.Columns("Reference").HeaderText = "Reference"
                            dgvUncleared.Columns("Description").HeaderText = "Description"
                            dgvUncleared.Columns("BranchName").HeaderText = "Branch"
                            dgvUncleared.Columns("EFTAmount").HeaderText = "Amount"
                            dgvUncleared.Columns("EFTAmount").DefaultCellStyle.Format = "N2"
                            dgvUncleared.Columns("TransactionType").HeaderText = "Type"
                            dgvUncleared.Columns("DaysUncleared").HeaderText = "Days Pending"
                            
                            ' Highlight old EFTs
                            For Each row As DataGridViewRow In dgvUncleared.Rows
                                If Not row.IsNewRow AndAlso row.Cells("DaysUncleared").Value IsNot Nothing Then
                                    Dim days = CInt(row.Cells("DaysUncleared").Value)
                                    If days > 7 Then
                                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 230, 230)
                                    ElseIf days > 3 Then
                                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 250, 230)
                                    End If
                                End If
                            Next
                        End If
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading uncleared EFTs: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadClearingHistory()
            Try
                Dim branchID As Integer? = Nothing
                If cboBranch.SelectedItem IsNot Nothing Then
                    Dim selectedBranch = DirectCast(cboBranch.SelectedItem, Object)
                    Dim bid = CInt(selectedBranch.BranchID)
                    If bid > 0 Then branchID = bid
                End If

                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_EFT_GetClearingHistory", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        If branchID.HasValue Then
                            cmd.Parameters.AddWithValue("@BranchID", branchID.Value)
                        Else
                            cmd.Parameters.AddWithValue("@BranchID", DBNull.Value)
                        End If
                        cmd.Parameters.AddWithValue("@FromDate", DateTime.Today.AddMonths(-1))
                        cmd.Parameters.AddWithValue("@ToDate", DateTime.Today)

                        Dim dt As New DataTable()
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(dt)
                        End Using

                        dgvHistory.DataSource = dt

                        If dgvHistory.Columns.Count > 0 Then
                            dgvHistory.Columns("JournalID").Visible = False
                            dgvHistory.Columns("BranchID").Visible = False
                            dgvHistory.Columns("JournalNumber").HeaderText = "Clearing Journal #"
                            dgvHistory.Columns("ClearingDate").HeaderText = "Cleared Date"
                            dgvHistory.Columns("ClearingReference").HeaderText = "Clearing Ref"
                            dgvHistory.Columns("Description").HeaderText = "Description"
                            dgvHistory.Columns("BranchName").HeaderText = "Branch"
                            dgvHistory.Columns("ClearedAmount").HeaderText = "Amount"
                            dgvHistory.Columns("ClearedAmount").DefaultCellStyle.Format = "N2"
                            dgvHistory.Columns("OriginalReference").HeaderText = "Original Ref"
                        End If
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading clearing history: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnUnclearedSelectionChanged(sender As Object, e As EventArgs)
            btnMarkCleared.Enabled = (dgvUncleared.SelectedRows.Count > 0)
        End Sub

        Private Sub BtnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
            LoadUnclearedEFTs()
            LoadClearingHistory()
        End Sub

        Private Sub BtnMarkCleared_Click(sender As Object, e As EventArgs) Handles btnMarkCleared.Click
            If dgvUncleared.SelectedRows.Count = 0 Then Return

            Dim row = dgvUncleared.SelectedRows(0)
            Dim journalNumber = row.Cells("JournalNumber").Value.ToString()
            Dim reference = row.Cells("Reference").Value.ToString()
            Dim amount = CDec(row.Cells("EFTAmount").Value)
            Dim description = row.Cells("Description").Value.ToString()
            Dim branchID = CInt(row.Cells("BranchID").Value)
            Dim transactionType = row.Cells("TransactionType").Value.ToString()

            Dim result = MessageBox.Show(
                $"Mark this EFT as cleared?{vbCrLf}{vbCrLf}" &
                $"Journal: {journalNumber}{vbCrLf}" &
                $"Reference: {reference}{vbCrLf}" &
                $"Amount: R{amount:N2}{vbCrLf}" &
                $"Type: {transactionType}",
                "Confirm EFT Clearing",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question)

            If result = DialogResult.Yes Then
                Try
                    Using conn As New SqlConnection(_connString)
                        conn.Open()
                        
                        ' Determine which procedure to call based on transaction type
                        Dim procName As String
                        If transactionType = "POS Sale" Then
                            procName = "sp_POS_PostEFTClearingToGL"
                        Else
                            procName = "sp_AP_PostEFTClearingToGL"
                        End If

                        Using cmd As New SqlCommand(procName, conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.AddWithValue("@ClearingReference", DateTime.Now.ToString("yyyyMMdd-HHmmss"))
                            cmd.Parameters.AddWithValue("@ClearingDate", DateTime.Today)
                            cmd.Parameters.AddWithValue("@BranchID", branchID)
                            cmd.Parameters.AddWithValue("@ClearingAmount", amount)
                            cmd.Parameters.AddWithValue("@CreatedBy", _currentUserID)
                            
                            If transactionType <> "POS Sale" Then
                                ' AP clearing needs additional parameters
                                cmd.Parameters.AddWithValue("@SupplierName", description.Replace("Payment - ", ""))
                                cmd.Parameters.AddWithValue("@OriginalPaymentReference", reference)
                            End If

                            cmd.ExecuteNonQuery()
                        End Using
                    End Using

                    MessageBox.Show("EFT marked as cleared successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    LoadUnclearedEFTs()
                    LoadClearingHistory()
                Catch ex As Exception
                    MessageBox.Show($"Error clearing EFT: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        End Sub

        Private Sub CboBranch_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboBranch.SelectedIndexChanged
            LoadUnclearedEFTs()
            LoadClearingHistory()
        End Sub
    End Class
End Namespace
