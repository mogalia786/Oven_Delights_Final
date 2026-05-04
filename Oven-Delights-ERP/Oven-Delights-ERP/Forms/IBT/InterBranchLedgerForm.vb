Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing

Namespace Forms.IBT

    ''' <summary>
    ''' Form for viewing Inter-Branch Ledger (Debtor/Creditor balances)
    ''' Shows what branches owe each other
    ''' </summary>
    Public Class InterBranchLedgerForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private _currentBranchId As Integer

        ' UI Controls
        Private dgvLedger As DataGridView
        Private cboViewType As ComboBox
        Private btnRefresh As Button
        Private btnSettle As Button
        Private btnClose As Button
        Private lblTotalOwed As Label
        Private lblTotalOwing As Label
        Private lblNetPosition As Label

        ' Colors
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(41, 128, 185)
        Private ReadOnly ColorSuccess As Color = Color.FromArgb(39, 174, 96)
        Private ReadOnly ColorDanger As Color = Color.FromArgb(231, 76, 60)
        Private ReadOnly ColorWarning As Color = Color.FromArgb(243, 156, 18)
        Private ReadOnly ColorDark As Color = Color.FromArgb(52, 73, 94)
        Private ReadOnly ColorLight As Color = Color.FromArgb(236, 240, 241)

        Public Sub New()
            _currentBranchId = If(AppSession.CurrentUser?.BranchID, 1)

            Me.Text = "Inter-Branch Ledger"
            Me.Width = 1400
            Me.Height = 800
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            InitializeUI()
            LoadLedger()
        End Sub

        Private Sub InitializeUI()
            ' Header Panel
            Dim pnlHeader As New Panel With {
                .Dock = DockStyle.Top,
                .Height = 100,
                .BackColor = ColorDark
            }

            Dim lblTitle As New Label With {
                .Text = "💰 Inter-Branch Ledger",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(30, 20)
            }

            Dim lblSubtitle As New Label With {
                .Text = "Track inter-branch debtor/creditor balances",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorLight,
                .AutoSize = True,
                .Location = New Point(30, 55)
            }

            pnlHeader.Controls.AddRange({lblTitle, lblSubtitle})

            ' Filter Panel
            Dim pnlFilter As New Panel With {
                .Location = New Point(30, 120),
                .Size = New Size(1340, 60),
                .BackColor = ColorLight
            }

            Dim lblView As New Label With {
                .Text = "View:",
                .Location = New Point(15, 18),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            cboViewType = New ComboBox With {
                .Location = New Point(70, 15),
                .Width = 250,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10)
            }
            cboViewType.Items.AddRange({"All Transactions", "Outstanding Only", "Settled Only", "We Owe Others", "Others Owe Us"})
            cboViewType.SelectedIndex = 1 ' Default to Outstanding
            AddHandler cboViewType.SelectedIndexChanged, AddressOf OnViewChanged

            btnRefresh = New Button With {
                .Text = "🔄 Refresh",
                .Location = New Point(340, 10),
                .Size = New Size(120, 40),
                .BackColor = ColorPrimary,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnRefresh.FlatAppearance.BorderSize = 0
            AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click

            pnlFilter.Controls.AddRange({lblView, cboViewType, btnRefresh})

            ' Grid
            dgvLedger = New DataGridView With {
                .Location = New Point(30, 200),
                .Size = New Size(1340, 420),
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.FixedSingle,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .RowHeadersVisible = False,
                .Font = New Font("Segoe UI", 10),
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            }

            dgvLedger.ColumnHeadersDefaultCellStyle.BackColor = ColorDark
            dgvLedger.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgvLedger.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
            dgvLedger.ColumnHeadersHeight = 40
            dgvLedger.AlternatingRowsDefaultCellStyle.BackColor = ColorLight
            dgvLedger.RowTemplate.Height = 35

            ' Summary Panel
            Dim pnlSummary As New Panel With {
                .Location = New Point(30, 640),
                .Size = New Size(1340, 60),
                .BackColor = ColorLight,
                .BorderStyle = BorderStyle.FixedSingle
            }

            lblTotalOwed = New Label With {
                .Text = "Others Owe Us: R 0.00",
                .Location = New Point(20, 15),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = ColorSuccess
            }

            lblTotalOwing = New Label With {
                .Text = "We Owe Others: R 0.00",
                .Location = New Point(300, 15),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .ForeColor = ColorDanger
            }

            lblNetPosition = New Label With {
                .Text = "Net Position: R 0.00",
                .Location = New Point(600, 15),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 12, FontStyle.Bold),
                .ForeColor = ColorPrimary
            }

            pnlSummary.Controls.AddRange({lblTotalOwed, lblTotalOwing, lblNetPosition})

            ' Footer
            Dim pnlFooter As New Panel With {
                .Dock = DockStyle.Bottom,
                .Height = 70,
                .BackColor = ColorLight
            }

            btnSettle = New Button With {
                .Text = "💳 Mark as Settled",
                .Location = New Point(1040, 15),
                .Size = New Size(180, 40),
                .BackColor = ColorSuccess,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnSettle.FlatAppearance.BorderSize = 0
            AddHandler btnSettle.Click, AddressOf BtnSettle_Click

            btnClose = New Button With {
                .Text = "Close",
                .Location = New Point(1230, 15),
                .Size = New Size(140, 40),
                .BackColor = Color.Gray,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnClose.FlatAppearance.BorderSize = 0
            AddHandler btnClose.Click, Sub() Me.Close()

            pnlFooter.Controls.AddRange({btnSettle, btnClose})

            Me.Controls.AddRange({pnlHeader, pnlFilter, dgvLedger, pnlSummary, pnlFooter})
        End Sub

        Private Sub LoadLedger()
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()

                    Dim viewType As String = If(cboViewType.SelectedItem IsNot Nothing, cboViewType.SelectedItem.ToString(), "Outstanding Only")
                    Dim whereClause As String = ""

                    Select Case viewType
                        Case "Outstanding Only"
                            whereClause = " AND l.Status = 'Outstanding'"
                        Case "Settled Only"
                            whereClause = " AND l.Status = 'Settled'"
                        Case "We Owe Others"
                            whereClause = " AND l.DebtorBranchID = @BranchID AND l.Status = 'Outstanding'"
                        Case "Others Owe Us"
                            whereClause = " AND l.CreditorBranchID = @BranchID AND l.Status = 'Outstanding'"
                    End Select

                    Dim sql = $"SELECT l.LedgerID, l.TransactionDate, 
                                      db.BranchName AS DebtorBranch, cb.BranchName AS CreditorBranch,
                                      dn.DeliveryNoteNumber, po.PONumber, p.Name AS ProductName,
                                      l.Amount, l.Status, l.SettlementDate, l.SettlementReference, l.Notes
                               FROM InterBranchLedger l
                               INNER JOIN Branches db ON l.DebtorBranchID = db.BranchID
                               INNER JOIN Branches cb ON l.CreditorBranchID = cb.BranchID
                               INNER JOIN InternalDeliveryNotes dn ON l.DeliveryNoteID = dn.DeliveryNoteID
                               INNER JOIN Demo_Retail_Product p ON dn.ProductID = p.ProductID
                               INNER JOIN InternalPurchaseOrders po ON dn.InternalPOID = po.InternalPOID
                               WHERE (l.DebtorBranchID = @BranchID OR l.CreditorBranchID = @BranchID){whereClause}
                               ORDER BY l.TransactionDate DESC"

                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@BranchID", _currentBranchId)

                        Dim dt As New DataTable()
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(dt)
                        End Using

                        dgvLedger.DataSource = dt

                        If dgvLedger.Columns.Count > 0 Then
                            dgvLedger.Columns("LedgerID").Visible = False
                            dgvLedger.Columns("TransactionDate").HeaderText = "Date"
                            dgvLedger.Columns("TransactionDate").DefaultCellStyle.Format = "dd/MM/yyyy"
                            dgvLedger.Columns("DebtorBranch").HeaderText = "Debtor (Owes)"
                            dgvLedger.Columns("CreditorBranch").HeaderText = "Creditor (Owed)"
                            dgvLedger.Columns("DeliveryNoteNumber").HeaderText = "Delivery Note"
                            dgvLedger.Columns("PONumber").HeaderText = "PO Number"
                            dgvLedger.Columns("ProductName").HeaderText = "Product"
                            dgvLedger.Columns("Amount").HeaderText = "Amount"
                            dgvLedger.Columns("Amount").DefaultCellStyle.Format = "C2"
                            dgvLedger.Columns("Status").HeaderText = "Status"
                            dgvLedger.Columns("SettlementDate").HeaderText = "Settled Date"
                            dgvLedger.Columns("SettlementDate").DefaultCellStyle.Format = "dd/MM/yyyy"
                            dgvLedger.Columns("SettlementReference").HeaderText = "Settlement Ref"
                            dgvLedger.Columns("Notes").HeaderText = "Notes"

                            ' Color code status and highlight current branch
                            For Each row As DataGridViewRow In dgvLedger.Rows
                                Dim status As String = If(row.Cells("Status").Value IsNot Nothing, row.Cells("Status").Value.ToString(), "")
                                Dim debtorBranch As String = If(row.Cells("DebtorBranch").Value IsNot Nothing, row.Cells("DebtorBranch").Value.ToString(), "")
                                
                                ' Status coloring
                                If status = "Outstanding" Then
                                    row.Cells("Status").Style.BackColor = Color.LightYellow
                                    row.Cells("Status").Style.ForeColor = Color.DarkOrange
                                Else
                                    row.Cells("Status").Style.BackColor = Color.LightGreen
                                    row.Cells("Status").Style.ForeColor = Color.DarkGreen
                                End If

                                ' Highlight if we owe
                                Dim currentBranchName As String = GetBranchName(_currentBranchId)
                                If debtorBranch = currentBranchName AndAlso status = "Outstanding" Then
                                    row.DefaultCellStyle.BackColor = Color.FromArgb(255, 230, 230) ' Light red
                                End If
                            Next
                        End If

                        ' Calculate summary
                        CalculateSummary(dt)
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading ledger: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub CalculateSummary(dt As DataTable)
            Dim totalOwed As Decimal = 0 ' Others owe us
            Dim totalOwing As Decimal = 0 ' We owe others
            Dim currentBranchName As String = GetBranchName(_currentBranchId)

            For Each row As DataRow In dt.Rows
                If row("Status").ToString() = "Outstanding" Then
                    Dim amount As Decimal = Convert.ToDecimal(row("Amount"))
                    Dim debtorBranch As String = row("DebtorBranch").ToString()
                    Dim creditorBranch As String = row("CreditorBranch").ToString()

                    If creditorBranch = currentBranchName Then
                        totalOwed += amount ' They owe us
                    ElseIf debtorBranch = currentBranchName Then
                        totalOwing += amount ' We owe them
                    End If
                End If
            Next

            Dim netPosition As Decimal = totalOwed - totalOwing

            lblTotalOwed.Text = $"Others Owe Us: R {totalOwed:N2}"
            lblTotalOwing.Text = $"We Owe Others: R {totalOwing:N2}"
            lblNetPosition.Text = $"Net Position: R {netPosition:N2}"
            lblNetPosition.ForeColor = If(netPosition >= 0, ColorSuccess, ColorDanger)
        End Sub

        Private Function GetBranchName(branchId As Integer) As String
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Using cmd As New SqlCommand("SELECT BranchName FROM Branches WHERE BranchID = @BranchID", con)
                        cmd.Parameters.AddWithValue("@BranchID", branchId)
                        Dim result = cmd.ExecuteScalar()
                        Return If(result IsNot Nothing, result.ToString(), "")
                    End Using
                End Using
            Catch
                Return ""
            End Try
        End Function

        Private Sub OnViewChanged(sender As Object, e As EventArgs)
            LoadLedger()
        End Sub

        Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
            LoadLedger()
        End Sub

        Private Sub BtnSettle_Click(sender As Object, e As EventArgs)
            If dgvLedger.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a transaction to settle.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim status As String = dgvLedger.SelectedRows(0).Cells("Status").Value?.ToString()
            If status <> "Outstanding" Then
                MessageBox.Show("Only outstanding transactions can be settled.", "Invalid Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim ledgerId As Integer = Convert.ToInt32(dgvLedger.SelectedRows(0).Cells("LedgerID").Value)
            Dim amount As Decimal = Convert.ToDecimal(dgvLedger.SelectedRows(0).Cells("Amount").Value)
            Dim debtorBranch As String = dgvLedger.SelectedRows(0).Cells("DebtorBranch").Value?.ToString()
            Dim creditorBranch As String = dgvLedger.SelectedRows(0).Cells("CreditorBranch").Value?.ToString()

            Dim reference As String = InputBox($"Enter settlement reference for R {amount:N2}:{vbCrLf}{debtorBranch} → {creditorBranch}", "Settlement Reference", $"SETTLE-{DateTime.Now:yyyyMMdd}")
            If String.IsNullOrWhiteSpace(reference) Then
                Return
            End If

            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql = "UPDATE InterBranchLedger SET Status = 'Settled', SettlementDate = GETDATE(), SettlementReference = @Reference WHERE LedgerID = @LedgerID"
                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@LedgerID", ledgerId)
                        cmd.Parameters.AddWithValue("@Reference", reference)
                        cmd.ExecuteNonQuery()
                    End Using
                End Using

                MessageBox.Show("Transaction marked as settled.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                LoadLedger()

            Catch ex As Exception
                MessageBox.Show($"Error settling transaction: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
