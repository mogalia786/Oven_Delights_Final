Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

Public Class GeneralLedgerViewerForm_New
    Inherits Form

    Private dgvAccounts As DataGridView
    Private dgvEntries As DataGridView
    Private dtFrom As DateTimePicker
    Private dtTo As DateTimePicker
    Private btnLoad As Button
    Private txtSearch As TextBox
    Private lblFrom As Label
    Private lblTo As Label
    Private lblSearch As Label

    Public Sub New()
        Me.Text = "General Ledger Viewer"
        Me.StartPosition = FormStartPosition.CenterParent
        Me.Width = 1100
        Me.Height = 680
        InitializeUi()
        LoadAccounts()
    End Sub

    Private Sub InitializeUi()
        lblFrom = New Label() With {.Left = 12, .Top = 12, .AutoSize = True, .Text = "From:"}
        dtFrom = New DateTimePicker() With {.Left = 60, .Top = 8, .Width = 140}
        dtFrom.Value = New DateTime(Date.Now.Year, 1, 1)

        lblTo = New Label() With {.Left = 220, .Top = 12, .AutoSize = True, .Text = "To:"}
        dtTo = New DateTimePicker() With {.Left = 250, .Top = 8, .Width = 140}
        dtTo.Value = Date.Today

        lblSearch = New Label() With {.Left = 410, .Top = 12, .AutoSize = True, .Text = "Search:"}
        txtSearch = New TextBox() With {.Left = 470, .Top = 8, .Width = 320}

        btnLoad = New Button() With {.Left = 800, .Top = 6, .Width = 100, .Text = "Load"}
        AddHandler btnLoad.Click, AddressOf OnLoadClick

        dgvAccounts = New DataGridView() With {
            .Left = 12, .Top = 40, .Width = 1060, .Height = 280,
            .ReadOnly = True, .AllowUserToAddRows = False, .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect, .MultiSelect = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }
        AddHandler dgvAccounts.SelectionChanged, AddressOf OnAccountSelectionChanged

        dgvEntries = New DataGridView() With {
            .Left = 12, .Top = 332, .Width = 1060, .Height = 300,
            .ReadOnly = True, .AllowUserToAddRows = False, .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect, .MultiSelect = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }

        Controls.AddRange(New Control() {lblFrom, dtFrom, lblTo, dtTo, lblSearch, txtSearch, btnLoad, dgvAccounts, dgvEntries})
    End Sub

    Private Function CnStr() As String
        Return ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Function

    Private Sub OnLoadClick(sender As Object, e As EventArgs)
        LoadAccounts()
    End Sub

    Private Sub LoadAccounts()
        Try
            Using cn As New SqlConnection(CnStr())
                cn.Open()
                ' Summarize by account within date range
                Dim sql As String = "WITH J AS ( " & _
                                    "  SELECT d.AccountID, SUM(d.Debit) AS Debit, SUM(d.Credit) AS Credit " & _
                                    "  FROM dbo.JournalDetails d " & _
                                    "  JOIN dbo.JournalHeaders h ON h.JournalID = d.JournalID " & _
                                    "  WHERE h.JournalDate BETWEEN @d1 AND @d2 " & _
                                    "  GROUP BY d.AccountID " & _
                                    ") " & _
                                    "SELECT a.AccountID, a.AccountNumber, a.AccountName, " & _
                                    "       CAST(COALESCE(j.Debit,0) AS decimal(18,2)) AS TotalDebit, " & _
                                    "       CAST(COALESCE(j.Credit,0) AS decimal(18,2)) AS TotalCredit " & _
                                    "FROM dbo.GLAccounts a " & _
                                    "LEFT JOIN J j ON j.AccountID = a.AccountID " & _
                                    "WHERE (@q IS NULL OR @q = '' OR a.AccountNumber LIKE '%' + @q + '%' OR a.AccountName LIKE '%' + @q + '%') " & _
                                    "ORDER BY a.AccountNumber;"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@d1", dtFrom.Value.Date)
                    cmd.Parameters.AddWithValue("@d2", dtTo.Value.Date)
                    Dim q As String = If(txtSearch.Text, String.Empty)
                    cmd.Parameters.AddWithValue("@q", q)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvAccounts.DataSource = dt
                        If dgvAccounts.Columns.Contains("AccountID") Then dgvAccounts.Columns("AccountID").Visible = False
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to load accounts: " & ex.Message, "General Ledger", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
        LoadEntriesForSelected()
    End Sub

    Private Function GetSelectedAccountId() As Integer
        If dgvAccounts Is Nothing OrElse dgvAccounts.CurrentRow Is Nothing Then Return 0
        Dim row = dgvAccounts.CurrentRow
        If row Is Nothing Then Return 0
        Dim id As Integer = 0
        Try
            If row.Cells("AccountID") IsNot Nothing AndAlso row.Cells("AccountID").Value IsNot DBNull.Value Then
                id = Convert.ToInt32(row.Cells("AccountID").Value)
            End If
        Catch
        End Try
        Return id
    End Function

    Private Sub OnAccountSelectionChanged(sender As Object, e As EventArgs)
        LoadEntriesForSelected()
    End Sub

    Private Sub LoadEntriesForSelected()
        dgvEntries.DataSource = Nothing
        Dim accId As Integer = GetSelectedAccountId()
        If accId <= 0 Then Return
        Try
            Using cn As New SqlConnection(CnStr())
                cn.Open()
                Dim sql As String = "SELECT " & _
                                    "  h.JournalDate AS [Date], " & _
                                    "  h.JournalNumber AS [Journal No], " & _
                                    "  h.Reference, " & _
                                    "  h.Description, " & _
                                    "  CAST(d.Debit AS decimal(18,2)) AS Debit, " & _
                                    "  CAST(d.Credit AS decimal(18,2)) AS Credit, " & _
                                    "  h.BranchID, " & _
                                    "  h.CreatedBy " & _
                                    "FROM dbo.JournalDetails d " & _
                                    "JOIN dbo.JournalHeaders h ON h.JournalID = d.JournalID " & _
                                    "WHERE d.AccountID = @aid AND h.JournalDate BETWEEN @d1 AND @d2 " & _
                                    "ORDER BY h.JournalDate, h.JournalNumber, d.LineNumber;"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@aid", accId)
                    cmd.Parameters.AddWithValue("@d1", dtFrom.Value.Date)
                    cmd.Parameters.AddWithValue("@d2", dtTo.Value.Date)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvEntries.DataSource = dt
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to load entries: " & ex.Message, "General Ledger", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
