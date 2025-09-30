Imports System.Data

Public Class InterBranchRequestsListForm
    Private ReadOnly _svc As New InterBranchTransferService()
    Private ReadOnly stockroomService As New StockroomService()
    Private currentBranchId As Integer
    Private isSuperAdmin As Boolean

    Private Sub InterBranchRequestsListForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            ' Initialize branch and role info
            currentBranchId = stockroomService.GetCurrentUserBranchId()
            isSuperAdmin = stockroomService.IsCurrentUserSuperAdmin()
            
            lblBranch.Text = $"Branch: {GetBranchName()}"
            RefreshData()
        Catch ex As Exception
            MessageBox.Show($"Error loading requests: {ex.Message}")
        End Try
    End Sub

    Private Sub RefreshData()
        Dim dt As DataTable = _svc.ListPendingRequests(currentBranchId)
        dgvRequests.DataSource = dt
    End Sub
    
    Private Function GetBranchName() As String
        Try
            Dim branches = stockroomService.GetBranchesLookup()
            If branches IsNot Nothing Then
                Dim rows = branches.Select($"BranchID = {currentBranchId}")
                If rows.Length > 0 Then
                    Return rows(0)("BranchName").ToString()
                End If
            End If
        Catch
            ' Ignore errors
        End Try
        Return "Main Branch"
    End Function

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
