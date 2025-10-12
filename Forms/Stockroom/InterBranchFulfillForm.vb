Imports System.Data
Imports Microsoft.Data.SqlClient

Public Class InterBranchFulfillForm
    Private ReadOnly _requestId As Integer
    Private ReadOnly _svc As New InterBranchTransferService()
    Private ReadOnly stockroomService As New StockroomService()
    Private currentBranchId As Integer

    Public Sub New(requestId As Integer)
        InitializeComponent()
        _requestId = requestId
        currentBranchId = stockroomService.GetCurrentUserBranchId()
        lblHeader.Text = $"Fulfil Request #{_requestId}"
        LoadLines()
    End Sub

    Private Sub LoadLines()
        ' For now, read directly from DB to show lines for the request
        Try
            Dim connStr = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Using cn As New SqlConnection(connStr)
                Using da As New SqlDataAdapter("SELECT l.RequestLineID, l.ProductID, l.VariantID, l.Quantity FROM dbo.InterBranchTransferRequestLine l WHERE l.RequestID=@rid", cn)
                    da.SelectCommand.Parameters.AddWithValue("@rid", _requestId)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvLines.DataSource = dt
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading request lines: {ex.Message}")
        End Try
    End Sub

    Private Sub btnPost_Click(sender As Object, e As EventArgs) Handles btnPost.Click
        Try
            ' Create transfer from request, then post
            Dim transferId = _svc.CreateTransferFromRequest(_requestId, AppSession.CurrentUser?.UserID)
            Dim posted = _svc.PostTransfer(transferId, AppSession.CurrentUser?.UserID)
            MessageBox.Show($"Posted. INT PO: {posted.IntPo}  INTER INV: {posted.InterInv}")
            Me.DialogResult = DialogResult.OK
            Me.Close()
        Catch ex As Exception
            MessageBox.Show($"Error posting transfer: {ex.Message}")
        End Try
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
