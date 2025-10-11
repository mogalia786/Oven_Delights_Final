Imports System.Windows.Forms
Imports System.IO
Imports System.Data
Imports Oven_Delights_ERP

Public Class BankStatementImportForm
    Private _csvPath As String
    Private ReadOnly _svc As New BankStatementImportService()

    Private Sub BankStatementImportForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Bank Statement Import"
    End Sub

    Private Sub btnBrowse_Click(sender As Object, e As EventArgs) Handles btnBrowse.Click
        Using ofd As New OpenFileDialog()
            ofd.Title = "Select bank statement (CSV)"
            ofd.Filter = "CSV Statements (*.csv)|*.csv|All files (*.*)|*.*"
            If ofd.ShowDialog(Me) = DialogResult.OK Then
                _csvPath = ofd.FileName
                txtFile.Text = _csvPath
                If Not _csvPath.EndsWith(".csv", StringComparison.OrdinalIgnoreCase) Then
                    MessageBox.Show("Current version supports CSV only. Please select a .csv file.", "Bank Import", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Return
                End If
                PreviewUsingService(_csvPath)
            End If
        End Using
    End Sub

    Private Sub PreviewUsingService(path As String)
        Try
            Dim dt As DataTable = _svc.ParseCsv(path)
            EnsureColumns(dt)
            dgvPreview.DataSource = dt
        Catch ex As Exception
            MessageBox.Show("Failed to load statement: " & ex.Message, "Bank Import", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnValidate_Click(sender As Object, e As EventArgs) Handles btnValidate.Click
        Dim dt = TryCast(dgvPreview.DataSource, DataTable)
        If dt Is Nothing Then
            MessageBox.Show("Load a file first.")
            Return
        End If
        EnsureColumns(dt)
        Dim ok = True
        ' clear highlights
        For Each row As DataGridViewRow In dgvPreview.Rows
            row.DefaultCellStyle.BackColor = Drawing.Color.White
        Next
        For i As Integer = 0 To dt.Rows.Count - 1
            Dim r = dt.Rows(i)
            Dim mark As Boolean = False
            If String.IsNullOrWhiteSpace(Convert.ToString(r("Date"))) Then mark = True
            If String.IsNullOrWhiteSpace(Convert.ToString(r("Description"))) Then mark = True
            Dim amt As Decimal = 0D
            Decimal.TryParse(Convert.ToString(r("Amount")), amt)
            If amt = 0D Then mark = True
            If mark Then
                ok = False
                If i < dgvPreview.Rows.Count Then dgvPreview.Rows(i).DefaultCellStyle.BackColor = Drawing.Color.MistyRose
            End If
        Next
        MessageBox.Show(If(ok, "Validation passed.", "Validation failed. Highlighted rows need attention."))
    End Sub

    Private Sub btnApplyRules_Click(sender As Object, e As EventArgs) Handles btnApplyRules.Click
        Dim dt = TryCast(dgvPreview.DataSource, DataTable)
        If dt Is Nothing Then
            MessageBox.Show("Load a file first.")
            Return
        End If
        EnsureColumns(dt)
        Dim result = _svc.ApplyRules(dt)
        dgvPreview.DataSource = result
        dgvPreview.Refresh()
    End Sub

    Private Sub btnMap_Click(sender As Object, e As EventArgs) Handles btnMap.Click
        Dim dt = TryCast(dgvPreview.DataSource, DataTable)
        If dt Is Nothing Then
            MessageBox.Show("Load a file first.")
            Return
        End If
        EnsureColumns(dt)
        Dim mapped = _svc.MapToLedgers(dt)
        dgvPreview.DataSource = mapped
        dgvPreview.Refresh()
    End Sub

    Private Sub btnPost_Click(sender As Object, e As EventArgs) Handles btnPost.Click
        Dim dt = TryCast(dgvPreview.DataSource, DataTable)
        If dt Is Nothing Then
            MessageBox.Show("Load a file first.")
            Return
        End If
        If Not chkApproved.Checked Then
            MessageBox.Show("Posting requires 'Approved by Accountant' to be checked.")
            Return
        End If
        Try
            EnsureColumns(dt)
            Dim ok = _svc.PostToLedgers(dt, AppSession.CurrentUserID)
            Dim countPosted As Integer = If(dt IsNot Nothing, dt.Rows.Count, 0)
            MessageBox.Show(If(ok, $"Posted {countPosted} line(s).", "Nothing to post."))
        Catch ex As Exception
            MessageBox.Show("Failed to post: " & ex.Message)
        End Try
    End Sub

    Private Sub EnsureColumns(dt As DataTable)
        If dt Is Nothing Then Exit Sub
        If Not dt.Columns.Contains("Date") Then dt.Columns.Add("Date")
        If Not dt.Columns.Contains("Description") Then dt.Columns.Add("Description")
        If Not dt.Columns.Contains("Amount") Then dt.Columns.Add("Amount", GetType(Decimal))
        If Not dt.Columns.Contains("Target") Then dt.Columns.Add("Target")
    End Sub
End Class
