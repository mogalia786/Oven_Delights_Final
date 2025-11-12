Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class GeneralLedgerViewerForm
    Inherits Form

    Private ReadOnly dtFrom As New DateTimePicker() With {.Format = DateTimePickerFormat.Short}
    Private ReadOnly dtTo As New DateTimePicker() With {.Format = DateTimePickerFormat.Short}
    Private ReadOnly cboBranch As New ComboBox() With {.DropDownStyle = ComboBoxStyle.DropDownList}
    Private ReadOnly txtAccountSearch As New TextBox()
    Private ReadOnly btnSearch As New Button() With {.Text = "Search"}
    Private ReadOnly chkAllBranches As New CheckBox() With {.Text = "All branches", .AutoSize = True}
    Private ReadOnly lblStatus As New Label() With {.Dock = DockStyle.Top, .Height = 24, .TextAlign = ContentAlignment.MiddleLeft, .Padding = New Padding(8, 0, 0, 0), .ForeColor = Color.FromArgb(90,90,90)}

    Private ReadOnly grdAccounts As New DataGridView() With {.Dock = DockStyle.Fill, .ReadOnly = True, .AllowUserToAddRows = False}
    Private ReadOnly grdTransactions As New DataGridView() With {.Dock = DockStyle.Fill, .ReadOnly = True, .AllowUserToAddRows = False}
    Private ReadOnly pnlTotals As New Panel() With {.Dock = DockStyle.Bottom, .Height = 32, .Padding = New Padding(12, 4, 12, 6), .BackColor = Color.FromArgb(245, 248, 255)}
    Private ReadOnly lblTotals As New Label() With {.Dock = DockStyle.Right, .AutoSize = False, .Width = 520, .TextAlign = ContentAlignment.MiddleRight, .Font = New Font("Segoe UI", 9.0F, FontStyle.Bold)}

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Public Sub New()
        Me.Text = "General Ledger Viewer"
        Me.Width = 1100
        Me.Height = 720
        Me.BackColor = Color.White

        ' Root layout: filter (AutoSize), status (AutoSize), split grids (Fill)
        Dim root As New TableLayoutPanel() With {.Dock = DockStyle.Fill, .BackColor = Me.BackColor, .ColumnCount = 1, .RowCount = 3}
        root.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 100))
        root.RowStyles.Add(New RowStyle(SizeType.AutoSize))
        root.RowStyles.Add(New RowStyle(SizeType.AutoSize))
        root.RowStyles.Add(New RowStyle(SizeType.Percent, 100))

        Dim filterPanel As New FlowLayoutPanel() With {.AutoSize = True, .AutoSizeMode = AutoSizeMode.GrowAndShrink, .Dock = DockStyle.Fill, .Padding = New Padding(12, 8, 12, 8), .WrapContents = False}
        filterPanel.Controls.Add(New Label() With {.Text = "From:", .AutoSize = True, .Margin = New Padding(6, 10, 6, 0)})
        filterPanel.Controls.Add(dtFrom)
        filterPanel.Controls.Add(New Label() With {.Text = "To:", .AutoSize = True, .Margin = New Padding(6, 10, 6, 0)})
        filterPanel.Controls.Add(dtTo)
        filterPanel.Controls.Add(New Label() With {.Text = "Branch:", .AutoSize = True, .Margin = New Padding(12, 10, 6, 0)})
        filterPanel.Controls.Add(cboBranch)
        filterPanel.Controls.Add(chkAllBranches)
        filterPanel.Controls.Add(New Label() With {.Text = "Account:", .AutoSize = True, .Margin = New Padding(12, 10, 6, 0)})
        filterPanel.Controls.Add(txtAccountSearch)
        filterPanel.Controls.Add(btnSearch)
        root.Controls.Add(filterPanel, 0, 0)
        root.Controls.Add(lblStatus, 0, 1)
        Dim split As New SplitContainer() With {.Dock = DockStyle.Fill, .Orientation = Orientation.Horizontal, .SplitterDistance = CInt(Me.Height * 0.55)}
        split.Panel1.Padding = New Padding(8)
        split.Panel2.Padding = New Padding(8)
        split.Panel1.Controls.Add(grdAccounts)
        Dim panelTrans As New Panel() With {.Dock = DockStyle.Fill}
        panelTrans.Controls.Add(grdTransactions)
        pnlTotals.Controls.Add(lblTotals)
        panelTrans.Controls.Add(pnlTotals)
        split.Panel2.Controls.Add(panelTrans)
        root.Controls.Add(split, 0, 2)
        Controls.Add(root)

        AddHandler btnSearch.Click, AddressOf OnSearch
        AddHandler grdAccounts.SelectionChanged, AddressOf OnAccountSelected
        AddHandler grdAccounts.CellClick, AddressOf OnAccountSelected
        AddHandler grdAccounts.CellDoubleClick, AddressOf OnAccountDoubleClick

        grdAccounts.AutoGenerateColumns = True
        grdTransactions.AutoGenerateColumns = True
        grdAccounts.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        grdTransactions.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        grdAccounts.RowHeadersVisible = False
        grdTransactions.RowHeadersVisible = False
        grdAccounts.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        grdTransactions.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        grdAccounts.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 248, 255)
        grdTransactions.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 248, 255)

        ' Defaults
        dtFrom.Value = New DateTime(Date.Today.Year, Date.Today.Month, 1)
        dtTo.Value = Date.Today
        Try
            LoadBranches()
            ' Default to current session branch if available
            If AppSession.CurrentBranchID > 0 AndAlso cboBranch.DataSource IsNot Nothing Then
                For i As Integer = 0 To cboBranch.Items.Count - 1
                    Dim drv As DataRowView = TryCast(cboBranch.Items(i), DataRowView)
                    If drv IsNot Nothing AndAlso Convert.ToInt32(drv.Row("ID")) = AppSession.CurrentBranchID Then
                        cboBranch.SelectedIndex = i
                        Exit For
                    End If
                Next
            End If
        Catch
        End Try
        lblStatus.Text = "Use the filters and press Search."
        ' Adjust splitter after form is shown (ensures visible space for accounts grid)
        AddHandler Me.Shown, Sub()
                                 Try
                                     split.SplitterDistance = CInt(Me.ClientSize.Height * 0.58)
                                     OnSearch(Nothing, EventArgs.Empty)
                                 Catch
                                 End Try
                             End Sub
        ' React to changes
        AddHandler chkAllBranches.CheckedChanged, Sub() OnSearch(Nothing, EventArgs.Empty)
        AddHandler cboBranch.SelectedIndexChanged, Sub() If Not chkAllBranches.Checked Then OnSearch(Nothing, EventArgs.Empty)
    End Sub

    Private Sub OnSearch(sender As Object, e As EventArgs)
        Try
            Using con As New SqlConnection(connectionString)
                con.Open()
                Dim sql As String = "SELECT a.AccountID, a.AccountNumber, a.AccountName, " & _
                                    "(a.OpeningBalance + ISNULL((SELECT SUM(d.Debit - d.Credit) " & _
                                    " FROM JournalDetails d INNER JOIN JournalHeaders h ON h.JournalID = d.JournalID " & _
                                    " WHERE d.AccountID = a.AccountID AND h.JournalDate < @d1" & _
                                    If(IncludeBranchFilter(), " AND h.BranchID = @bid", "") & _
                                    "), 0)) AS Opening, " & _
                                    "ISNULL((SELECT SUM(d.Debit) FROM JournalDetails d INNER JOIN JournalHeaders h ON h.JournalID = d.JournalID " & _
                                    " WHERE d.AccountID = a.AccountID AND h.JournalDate BETWEEN @d1 AND @d2" & _
                                    If(IncludeBranchFilter(), " AND h.BranchID = @bid", "") & "), 0) AS Debits, " & _
                                    "ISNULL((SELECT SUM(d.Credit) FROM JournalDetails d INNER JOIN JournalHeaders h ON h.JournalID = d.JournalID " & _
                                    " WHERE d.AccountID = a.AccountID AND h.JournalDate BETWEEN @d1 AND @d2" & _
                                    If(IncludeBranchFilter(), " AND h.BranchID = @bid", "") & "), 0) AS Credits " & _
                                    "FROM GLAccounts a WHERE a.IsActive = 1 ORDER BY a.AccountNumber"

                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@d1", dtFrom.Value.Date)
                    cmd.Parameters.AddWithValue("@d2", dtTo.Value.Date)
                    If IncludeBranchFilter() Then
                        cmd.Parameters.AddWithValue("@bid", GetEffectiveBranchId())
                    End If
                    Dim dt As New DataTable()
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                    ' Compute closing in memory: Opening + Debits - Credits
                    If Not dt.Columns.Contains("Closing") Then dt.Columns.Add("Closing", GetType(Decimal))
                    For Each r As DataRow In dt.Rows
                        Dim opening = Convert.ToDecimal(r("Opening"))
                        Dim debits = Convert.ToDecimal(r("Debits"))
                        Dim credits = Convert.ToDecimal(r("Credits"))
                        r("Closing") = opening + debits - credits
                    Next
                    grdAccounts.DataSource = dt
                    grdTransactions.DataSource = Nothing
                    Dim btxt As String = If(IncludeBranchFilter(), $"BranchID={GetEffectiveBranchId()}", "Branch=All")
                    lblStatus.Text = $"Accounts: {dt.Rows.Count} | {btxt} | From {dtFrom.Value:d} To {dtTo.Value:d}"
                    If grdAccounts.Rows.Count > 0 Then
                        Try
                            grdAccounts.FirstDisplayedScrollingRowIndex = 0
                            grdAccounts.ClearSelection()
                            grdAccounts.Rows(0).Selected = True
                            grdAccounts.CurrentCell = grdAccounts.Rows(0).Cells(0)
                            ' Populate bottom pane for the first account
                            OnAccountSelected(Nothing, EventArgs.Empty)
                        Catch
                        End Try
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading General Ledger: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnAccountSelected(sender As Object, e As EventArgs)
        Try
            ' Resolve selected row reliably
            Dim row As DataGridViewRow = grdAccounts.CurrentRow
            If row Is Nothing AndAlso grdAccounts.SelectedRows IsNot Nothing AndAlso grdAccounts.SelectedRows.Count > 0 Then
                row = grdAccounts.SelectedRows(0)
            End If
            If row Is Nothing Then Return

            Dim accountId As Integer = 0
            ' Prefer DataRowView when available
            Dim drv As DataRowView = TryCast(row.DataBoundItem, DataRowView)
            If drv IsNot Nothing Then
                If drv.Row.Table.Columns.Contains("AccountID") Then accountId = CInt(drv.Row("AccountID"))
            Else
                ' Fallback to cell by column name or index
                If row.DataGridView IsNot Nothing AndAlso row.DataGridView.Columns.Contains("AccountID") Then
                    accountId = Convert.ToInt32(row.Cells("AccountID").Value)
                ElseIf row.Cells.Count > 0 AndAlso row.Cells(0).OwningColumn IsNot Nothing AndAlso String.Equals(row.Cells(0).OwningColumn.DataPropertyName, "AccountID", StringComparison.OrdinalIgnoreCase) Then
                    accountId = Convert.ToInt32(row.Cells(0).Value)
                End If
            End If

            If accountId <= 0 Then Return

            Using con As New SqlConnection(connectionString)
                con.Open()
                Dim sql As String = "SELECT h.JournalDate AS [Date], h.JournalNumber, h.Reference, d.Description, d.Debit, d.Credit " & _
                                    "FROM JournalDetails d INNER JOIN JournalHeaders h ON h.JournalID = d.JournalID " & _
                                    "WHERE d.AccountID = @aid AND h.JournalDate BETWEEN @d1 AND @d2 " & _
                                    If(IncludeBranchFilter(), "AND h.BranchID = @bid ", "") & _
                                    "ORDER BY h.JournalDate, h.JournalID, d.LineNumber"
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@aid", accountId)
                    cmd.Parameters.AddWithValue("@d1", dtFrom.Value.Date)
                    cmd.Parameters.AddWithValue("@d2", dtTo.Value.Date)
                    If IncludeBranchFilter() Then cmd.Parameters.AddWithValue("@bid", GetEffectiveBranchId())
                    Dim dt As New DataTable()
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                    grdTransactions.DataSource = dt
                    If grdTransactions.Rows.Count > 0 Then
                        grdTransactions.FirstDisplayedScrollingRowIndex = 0
                        grdTransactions.ClearSelection()
                    End If
                    UpdateTotals(dt)
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading ledger transactions: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadBranches()
        Try
            Dim bs As New BranchService()
            Dim dt As DataTable = bs.GetAllBranches()
            cboBranch.DisplayMember = "BranchName"
            cboBranch.ValueMember = "ID"
            cboBranch.DataSource = dt
            cboBranch.SelectedIndex = -1 ' default: no filter

            ' Role-based branch scoping controls
            Try
                If Not IsSuperAdmin() Then
                    chkAllBranches.Checked = False
                    chkAllBranches.Enabled = False
                    cboBranch.Enabled = False
                Else
                    chkAllBranches.Enabled = True
                    cboBranch.Enabled = True
                End If
            Catch
            End Try
        Catch
            ' Non-fatal
        End Try
    End Sub

    Private Function IncludeBranchFilter() As Boolean
        ' Super Administrator may choose All branches; everyone else is forced to their branch
        If IsSuperAdmin() Then
            Return Not chkAllBranches.Checked
        End If
        Return True
    End Function

    Private Function IsSuperAdmin() As Boolean
        Try
            Return String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        Catch
            Return False
        End Try
    End Function

    Private Function GetEffectiveBranchId() As Integer
        ' Prefer selected branch; fallback to session branch
        If cboBranch.SelectedItem IsNot Nothing AndAlso TypeOf cboBranch.SelectedItem Is DataRowView Then
            Dim drv = CType(cboBranch.SelectedItem, DataRowView)
            Return CInt(drv.Row("ID"))
        End If
        If AppSession.CurrentBranchID > 0 Then Return AppSession.CurrentBranchID
        Return 0
    End Function

    Private Sub UpdateTotals(dt As DataTable)
        Try
            Dim tDebit As Decimal = 0D
            Dim tCredit As Decimal = 0D
            If dt IsNot Nothing Then
                For Each r As DataRow In dt.Rows
                    If dt.Columns.Contains("Debit") AndAlso Not IsDBNull(r("Debit")) Then tDebit += Convert.ToDecimal(r("Debit"))
                    If dt.Columns.Contains("Credit") AndAlso Not IsDBNull(r("Credit")) Then tCredit += Convert.ToDecimal(r("Credit"))
                Next
            End If
            lblTotals.Text = $"Debits: {tDebit:N2}    Credits: {tCredit:N2}    Difference: {(tDebit - tCredit):N2}"
        Catch
            lblTotals.Text = String.Empty
        End Try
    End Sub
    
    Private Sub OnAccountDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
        Try
            If e.RowIndex < 0 Then Return ' Header clicked
            
            Dim row As DataGridViewRow = grdAccounts.Rows(e.RowIndex)
            Dim drv As DataRowView = TryCast(row.DataBoundItem, DataRowView)
            
            If drv IsNot Nothing AndAlso drv.Row.Table.Columns.Contains("AccountID") Then
                Dim accountId As Integer = Convert.ToInt32(drv.Row("AccountID"))
                Dim accountNumber As String = If(drv.Row.Table.Columns.Contains("AccountNumber"), drv.Row("AccountNumber").ToString(), "")
                Dim accountName As String = If(drv.Row.Table.Columns.Contains("AccountName"), drv.Row("AccountName").ToString(), "")
                
                ' Open detailed ledger viewer
                Dim ledgerForm As New LedgerViewerForm(accountId, accountNumber, accountName)
                ledgerForm.ShowDialog(Me)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error opening ledger: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
