Imports System.Windows.Forms
Imports System.Drawing
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class JournalViewerForm
    Inherits Form

    Private ReadOnly dtFrom As New DateTimePicker() With {.Format = DateTimePickerFormat.Short}
    Private ReadOnly dtTo As New DateTimePicker() With {.Format = DateTimePickerFormat.Short}
    Private ReadOnly cboBranch As New ComboBox() With {.DropDownStyle = ComboBoxStyle.DropDownList}
    Private ReadOnly cboType As New ComboBox() With {.DropDownStyle = ComboBoxStyle.DropDownList}
    Private ReadOnly chkAllBranches As New CheckBox() With {.Text = "All branches"}
    Private ReadOnly chkPosted As New CheckBox() With {.Text = "Posted only"}
    Private ReadOnly txtSearch As New TextBox()
    Private ReadOnly btnSearch As New Button() With {.Text = "Search"}
    Private ReadOnly btnLast50 As New Button() With {.Text = "Recent 40"}
    Private ReadOnly lblStatus As New Label() With {.Dock = DockStyle.Top, .Height = 24, .TextAlign = ContentAlignment.MiddleLeft, .Padding = New Padding(8, 0, 0, 0), .ForeColor = Color.FromArgb(90,90,90)}

    Private ReadOnly grdHeaders As New DataGridView() With {.Dock = DockStyle.Fill, .ReadOnly = True, .AllowUserToAddRows = False}
    Private ReadOnly grdDetails As New DataGridView() With {.Dock = DockStyle.Fill, .ReadOnly = True, .AllowUserToAddRows = False}

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Public Sub New()
        Me.Text = "Journals Viewer"
        Me.Width = 1100
        Me.Height = 720
        Me.BackColor = Color.White

        ' Root layout: filter (AutoSize) + status (AutoSize) + grids (Fill)
        Dim root As New TableLayoutPanel() With {.Dock = DockStyle.Fill, .BackColor = Me.BackColor, .ColumnCount = 1, .RowCount = 3}
        root.ColumnStyles.Add(New ColumnStyle(SizeType.Percent, 100))
        root.RowStyles.Add(New RowStyle(SizeType.AutoSize))
        root.RowStyles.Add(New RowStyle(SizeType.AutoSize))
        root.RowStyles.Add(New RowStyle(SizeType.Percent, 100))

        Dim filterPanel As New FlowLayoutPanel() With {.AutoSize = True, .AutoSizeMode = AutoSizeMode.GrowAndShrink, .Dock = DockStyle.Fill, .Padding = New Padding(8, 8, 8, 8), .WrapContents = False}
        cboType.Items.AddRange(New Object() {"All", "General", "Sales", "Purchases", "Cash Receipts", "Cash Payments", "Payroll"})
        cboType.SelectedIndex = 0
        filterPanel.Controls.Add(New Label() With {.Text = "From:", .AutoSize = True, .Margin = New Padding(6, 10, 6, 0)})
        filterPanel.Controls.Add(dtFrom)
        filterPanel.Controls.Add(New Label() With {.Text = "To:", .AutoSize = True, .Margin = New Padding(6, 10, 6, 0)})
        filterPanel.Controls.Add(dtTo)
        filterPanel.Controls.Add(New Label() With {.Text = "Branch:", .AutoSize = True, .Margin = New Padding(12, 10, 6, 0)})
        filterPanel.Controls.Add(cboBranch)
        filterPanel.Controls.Add(chkAllBranches)
        filterPanel.Controls.Add(New Label() With {.Text = "Type:", .AutoSize = True, .Margin = New Padding(12, 10, 6, 0)})
        filterPanel.Controls.Add(cboType)
        filterPanel.Controls.Add(chkPosted)
        filterPanel.Controls.Add(txtSearch)
        filterPanel.Controls.Add(btnSearch)
        filterPanel.Controls.Add(btnLast50)
        root.Controls.Add(filterPanel, 0, 0)
        root.Controls.Add(lblStatus, 0, 1)

        Dim split As New SplitContainer() With {.Dock = DockStyle.Fill, .Orientation = Orientation.Horizontal, .SplitterDistance = CInt(Me.Height * 0.55)}
        split.Panel1.Padding = New Padding(8)
        split.Panel2.Padding = New Padding(8)
        split.Panel1.Controls.Add(grdHeaders)
        split.Panel2.Controls.Add(grdDetails)
        root.Controls.Add(split, 0, 2)
        Controls.Add(root)

        ' No banner; layout managed by TableLayoutPanel

        AddHandler btnSearch.Click, AddressOf OnSearch
        AddHandler btnLast50.Click, AddressOf OnShowLast50
        AddHandler grdHeaders.SelectionChanged, AddressOf OnHeaderSelected
        AddHandler grdHeaders.CellClick, AddressOf OnHeaderSelected

        ' Minimal columns and styling
        grdHeaders.AutoGenerateColumns = True
        grdDetails.AutoGenerateColumns = True
        grdHeaders.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        grdDetails.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        grdHeaders.RowHeadersVisible = False
        grdDetails.RowHeadersVisible = False
        grdHeaders.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        grdDetails.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        grdHeaders.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 248, 255)
        grdDetails.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 248, 255)

        ' Defaults
        dtFrom.Value = New DateTime(Date.Today.Year, Date.Today.Month, 1)
        dtTo.Value = Date.Today

        ' Load branches
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

            ' Role-based branch scoping: only Super Administrator can see All branches
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

        ' Initial status; also auto-run a search for convenience
        lblStatus.Text = "Use filters and click Search."
        grdHeaders.DataSource = Nothing
        grdDetails.DataSource = Nothing
        grdHeaders.ClearSelection()
        ' Adjust splitter after form is shown (ensures visible space for headers grid) and auto-search
        AddHandler Me.Shown, Sub(sender As Object, e As EventArgs)
                                 Try
                                     split.SplitterDistance = CInt(Me.ClientSize.Height * 0.58)
                                     OnSearch(Nothing, EventArgs.Empty)
                                 Catch
                                 End Try
                             End Sub
        ' Refresh when Posted-only toggles
        AddHandler chkPosted.CheckedChanged, Sub() OnSearch(Nothing, EventArgs.Empty)

    End Sub

    Private Function IsSuperAdmin() As Boolean
        Try
            Return String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        Catch
            Return False
        End Try
    End Function

    Private Sub OnSearch(sender As Object, e As EventArgs)
        Try
            Using con As New SqlConnection(connectionString)
                con.Open()
                Dim sql As String = "SELECT h.JournalID, h.JournalNumber, h.JournalDate, h.Reference, h.Description, h.IsPosted, h.BranchID " & _
                                    "FROM JournalHeaders h " & _
                                    "WHERE h.JournalDate BETWEEN @d1 AND @d2 "

                If IncludeBranchFilter() Then sql &= "AND h.BranchID = @branchId "

                If chkPosted.Checked Then
                    sql &= "AND h.IsPosted = 1 "
                End If

                If Not String.IsNullOrWhiteSpace(txtSearch.Text) Then
                    sql &= "AND (h.JournalNumber LIKE @q OR h.Reference LIKE @q OR h.Description LIKE @q) "
                End If

                sql &= "ORDER BY h.JournalDate DESC, h.JournalID DESC"

                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@d1", dtFrom.Value.Date)
                    cmd.Parameters.AddWithValue("@d2", dtTo.Value.Date)
                    If IncludeBranchFilter() Then cmd.Parameters.AddWithValue("@branchId", GetEffectiveBranchId())
                    If Not String.IsNullOrWhiteSpace(txtSearch.Text) Then
                        cmd.Parameters.AddWithValue("@q", "%" & txtSearch.Text.Trim() & "%")
                    End If

                    Dim dt As New DataTable()
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                    grdHeaders.DataSource = dt
                    grdDetails.DataSource = Nothing
                    Dim branchText As String = If(IncludeBranchFilter(), $"BranchID={GetEffectiveBranchId()}", "Branch=All")
                    lblStatus.Text = $"Results: {dt.Rows.Count} | {branchText} | From {dtFrom.Value:d} To {dtTo.Value:d}"
                    If grdHeaders.Rows.Count > 0 Then
                        Try
                            grdHeaders.FirstDisplayedScrollingRowIndex = 0
                            grdHeaders.ClearSelection()
                            grdHeaders.Rows(0).Selected = True
                            grdHeaders.CurrentCell = grdHeaders.Rows(0).Cells(0)
                            OnHeaderSelected(Nothing, EventArgs.Empty)
                        Catch
                        End Try
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading journals: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OnShowLast50(sender As Object, e As EventArgs)
        Try
            Using con As New SqlConnection(connectionString)
                con.Open()
                Dim sql As String = "SELECT TOP 40 h.JournalID, h.JournalNumber, h.JournalDate, h.Reference, h.Description, h.IsPosted, h.BranchID FROM JournalHeaders h " & _
                                    If(IncludeBranchFilter(), "WHERE h.BranchID = @branchId ", "") & _
                                    "ORDER BY h.JournalDate DESC, h.JournalID DESC"
                Using cmd As New SqlCommand(sql, con)
                    If IncludeBranchFilter() Then cmd.Parameters.AddWithValue("@branchId", GetEffectiveBranchId())
                    Dim dt As New DataTable()
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                    grdHeaders.DataSource = dt
                    grdDetails.DataSource = Nothing
                    Dim branchText As String = If(IncludeBranchFilter(), $"BranchID={GetEffectiveBranchId()}", "Branch=All")
                    lblStatus.Text = $"Showing last {dt.Rows.Count} headers | {branchText}"
                    ' Do not auto-select; keep details empty until user selects a header
                    If grdHeaders.Rows.Count > 0 Then
                        grdHeaders.ClearSelection()
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading last journals: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function IncludeBranchFilter() As Boolean
        ' Super Administrator may choose All branches; everyone else is forced to their branch
        If IsSuperAdmin() Then
            Return Not chkAllBranches.Checked
        End If
        Return True
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

    Private Sub OnHeaderSelected(sender As Object, e As EventArgs)
        Try
            ' Resolve selected row reliably
            Dim row As DataGridViewRow = grdHeaders.CurrentRow
            If row Is Nothing AndAlso grdHeaders.SelectedRows IsNot Nothing AndAlso grdHeaders.SelectedRows.Count > 0 Then
                row = grdHeaders.SelectedRows(0)
            End If
            If row Is Nothing Then Return

            Dim journalId As Integer = 0
            ' Prefer DataRowView when available
            Dim drv As DataRowView = TryCast(row.DataBoundItem, DataRowView)
            If drv IsNot Nothing AndAlso drv.Row.Table.Columns.Contains("JournalID") Then
                journalId = Convert.ToInt32(drv.Row("JournalID"))
            Else
                ' Fallback to cell by column name or index
                If row.DataGridView IsNot Nothing AndAlso row.DataGridView.Columns.Contains("JournalID") Then
                    journalId = Convert.ToInt32(row.Cells("JournalID").Value)
                ElseIf row.Cells.Count > 0 AndAlso row.Cells(0).OwningColumn IsNot Nothing AndAlso String.Equals(row.Cells(0).OwningColumn.DataPropertyName, "JournalID", StringComparison.OrdinalIgnoreCase) Then
                    journalId = Convert.ToInt32(row.Cells(0).Value)
                End If
            End If
            If journalId <= 0 Then Return

            Using con As New SqlConnection(connectionString)
                con.Open()
                Dim sql As String = "SELECT d.JournalDetailID, d.LineNumber, a.AccountNumber, a.AccountName, d.Debit, d.Credit, d.Description, d.Reference1, d.Reference2 " & _
                                    "FROM JournalDetails d INNER JOIN GLAccounts a ON a.AccountID = d.AccountID " & _
                                    "WHERE d.JournalID = @jid ORDER BY d.LineNumber"
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@jid", journalId)
                    Dim dt As New DataTable()
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                    grdDetails.DataSource = dt
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading journal details: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadBranches()
        Try
            Dim bs As New BranchService()
            Dim dt As DataTable = bs.GetAllBranches()
            cboBranch.DisplayMember = "BranchName"
            cboBranch.ValueMember = "ID"
            cboBranch.DataSource = dt
            cboBranch.SelectedIndex = -1 ' no filter by default
        Catch ex As Exception
            ' Non-fatal: leave empty if error
        End Try
    End Sub
End Class
