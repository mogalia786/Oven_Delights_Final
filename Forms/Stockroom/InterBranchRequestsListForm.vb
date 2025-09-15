Imports System.Data

Public Class InterBranchRequestsListForm
    Private ReadOnly _svc As New InterBranchTransferService()

    Private Sub InterBranchRequestsListForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            Dim branchId As Integer = AppSession.CurrentBranchID
            lblBranch.Text = $"Branch: {branchId}"
            RefreshData()
        Catch ex As Exception
            MessageBox.Show($"Error loading requests: {ex.Message}")
        End Try
    End Sub

    Private Sub RefreshData()
        Dim branchId As Integer = AppSession.CurrentBranchID
        Dim dt As DataTable = _svc.ListPendingRequests(branchId)
        dgvRequests.DataSource = dt
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        RefreshData()
    End Sub

    Private Sub btnOpen_Click(sender As Object, e As EventArgs) Handles btnOpen.Click
        If dgvRequests.CurrentRow Is Nothing Then Return
        Dim reqIdObj = dgvRequests.CurrentRow.Cells("RequestID").Value
        If reqIdObj Is Nothing Then Return
        Dim reqId As Integer = Convert.ToInt32(reqIdObj)
        Using frm As New InterBranchFulfillForm(reqId)
            frm.ShowDialog(Me)
        End Using
        RefreshData()
    End Sub
End Class
