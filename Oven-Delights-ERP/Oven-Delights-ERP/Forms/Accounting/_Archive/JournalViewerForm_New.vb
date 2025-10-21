Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

Public Class JournalViewerForm_New
    Inherits Form

    Private dgvJournals As DataGridView
    Private dgvDetails As DataGridView
    Private dtFrom As DateTimePicker
    Private dtTo As DateTimePicker
    Private btnLoad As Button
    Private txtSearch As TextBox
    Private lblFrom As Label
    Private lblTo As Label
    Private lblSearch As Label
    Private lblTotals As Label

    Public Sub New()
        Me.Text = "Journals Viewer"
        Me.StartPosition = FormStartPosition.CenterParent
        Me.Width = 1000
        Me.Height = 640
        InitializeUi()
        LoadJournals()
    End Sub

    Private Sub InitializeUi()
        lblFrom = New Label() With {.Left = 12, .Top = 12, .AutoSize = True, .Text = "From:"}
        dtFrom = New DateTimePicker() With {.Left = 60, .Top = 8, .Width = 140}
        dtFrom.Value = New DateTime(Date.Now.Year, 1, 1)

        lblTo = New Label() With {.Left = 220, .Top = 12, .AutoSize = True, .Text = "To:"}
        dtTo = New DateTimePicker() With {.Left = 250, .Top = 8, .Width = 140}
        dtTo.Value = Date.Today

        lblSearch = New Label() With {.Left = 410, .Top = 12, .AutoSize = True, .Text = "Search:"}
        txtSearch = New TextBox() With {.Left = 470, .Top = 8, .Width = 300}

        btnLoad = New Button() With {.Left = 780, .Top = 6, .Width = 100, .Text = "Load"}
        AddHandler btnLoad.Click, AddressOf OnLoadClick

        dgvJournals = New DataGridView() With {
            .Left = 12, .Top = 40, .Width = 960, .Height = 260,
            .ReadOnly = True, .AllowUserToAddRows = False, .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect, .MultiSelect = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }
        AddHandler dgvJournals.SelectionChanged, AddressOf OnJournalSelectionChanged

        dgvDetails = New DataGridView() With {
            .Left = 12, .Top = 312, .Width = 960, .Height = 250,
            .ReadOnly = True, .AllowUserToAddRows = False, .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect, .MultiSelect = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        }

        lblTotals = New Label() With {.Left = 12, .Top = 568, .Width = 960, .AutoSize = False, .TextAlign = ContentAlignment.MiddleRight, .Font = New Font("Segoe UI", 9.0!, FontStyle.Bold)}

        Controls.AddRange(New Control() {lblFrom, dtFrom, lblTo, dtTo, lblSearch, txtSearch, btnLoad, dgvJournals, dgvDetails, lblTotals})
    End Sub

    Private Function CnStr() As String
        Return ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Function

    Private Sub OnLoadClick(sender As Object, e As EventArgs)
        LoadJournals()
    End Sub

    Private Sub LoadJournals()
        Try
            Using cn As New SqlConnection(CnStr())
                cn.Open()
                Dim sql As String = "SELECT h.JournalID, h.JournalDate, h.JournalNumber, h.Reference, h.Description, h.BranchID, h.IsPosted " & _
                                    "FROM dbo.JournalHeaders h " & _
                                    "WHERE h.JournalDate BETWEEN @d1 AND @d2 " & _
                                    "  AND ( @q IS NULL OR @q = '' OR h.JournalNumber LIKE '%' + @q + '%' OR h.Reference LIKE '%' + @q + '%' OR h.Description LIKE '%' + @q + '%' ) " & _
                                    "ORDER BY h.JournalDate DESC, h.JournalNumber DESC;"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@d1", dtFrom.Value.Date)
                    cmd.Parameters.AddWithValue("@d2", dtTo.Value.Date)
                    Dim q As String = If(txtSearch.Text, String.Empty)
                    cmd.Parameters.AddWithValue("@q", q)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvJournals.DataSource = dt
                        If dgvJournals.Columns.Contains("JournalID") Then dgvJournals.Columns("JournalID").Visible = False
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to load journals: " & ex.Message, "Journals", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
        LoadDetailsForSelected()
    End Sub

    Private Sub OnJournalSelectionChanged(sender As Object, e As EventArgs)
        LoadDetailsForSelected()
    End Sub

    Private Function GetSelectedJournalId() As Integer
        If dgvJournals Is Nothing OrElse dgvJournals.CurrentRow Is Nothing Then Return 0
        Dim row = dgvJournals.CurrentRow
        If row Is Nothing Then Return 0
        Dim id As Integer = 0
        Try
            If row.Cells("JournalID") IsNot Nothing AndAlso row.Cells("JournalID").Value IsNot DBNull.Value Then
                id = Convert.ToInt32(row.Cells("JournalID").Value)
            End If
        Catch
        End Try
        Return id
    End Function

    Private Sub LoadDetailsForSelected()
        Dim jid As Integer = GetSelectedJournalId()
        dgvDetails.DataSource = Nothing
        If jid <= 0 Then Return
        Try
            Using cn As New SqlConnection(CnStr())
                cn.Open()
                Dim sql As String = "SELECT " & _
                                    "  h.JournalDate AS [Date], " & _
                                    "  h.JournalNumber AS [Number], " & _
                                    "  h.Reference, " & _
                                    "  h.Description, " & _
                                    "  a.AccountNumber AS [Account No], " & _
                                    "  a.AccountName AS [Account Name], " & _
                                    "  CAST(d.Debit AS decimal(18,2)) AS Debit, " & _
                                    "  CAST(d.Credit AS decimal(18,2)) AS Credit, " & _
                                    "  h.BranchID, " & _
                                    "  h.CreatedBy " & _
                                    "FROM dbo.JournalDetails d " & _
                                    "JOIN dbo.JournalHeaders h ON h.JournalID = d.JournalID " & _
                                    "JOIN dbo.GLAccounts a ON a.AccountID = d.AccountID " & _
                                    "WHERE d.JournalID = @jid " & _
                                    "ORDER BY d.LineNumber;"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@jid", jid)
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvDetails.DataSource = dt
                        ' Compute totals
                        Dim tDr As Decimal = 0D
                        Dim tCr As Decimal = 0D
                        For Each r As DataRow In dt.Rows
                            If r("Debit") IsNot DBNull.Value Then tDr += Convert.ToDecimal(r("Debit"))
                            If r("Credit") IsNot DBNull.Value Then tCr += Convert.ToDecimal(r("Credit"))
                        Next
                        lblTotals.Text = $"Totals — Debit: {tDr:N2}    Credit: {tCr:N2}    Difference: {(tDr - tCr):N2}"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Failed to load journal details: " & ex.Message, "Journals", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
