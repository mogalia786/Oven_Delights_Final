Imports System.Data.SqlClient
Imports System.Configuration

Public Class RefundTenderDialog
    Private ReadOnly _refundAmount As Decimal
    Private ReadOnly _originalPaymentMethod As String
    Private _selectedRefundMethod As String = ""
    
    Public Property RefundMethod As String
        Get
            Return _selectedRefundMethod
        End Get
        Private Set(value As String)
            _selectedRefundMethod = value
        End Set
    End Property
    
    Public Sub New(refundAmount As Decimal, originalPaymentMethod As String)
        InitializeComponent()
        _refundAmount = refundAmount
        _originalPaymentMethod = originalPaymentMethod
    End Sub
    
    Private Sub RefundTenderDialog_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        lblRefundAmount.Text = _refundAmount.ToString("C2")
        lblOriginalMethod.Text = _originalPaymentMethod
        
        ' Highlight the original payment method button
        HighlightOriginalMethod()
    End Sub
    
    Private Sub HighlightOriginalMethod()
        Select Case _originalPaymentMethod.ToUpper()
            Case "CASH"
                btnCash.BackColor = Color.FromArgb(46, 204, 113)
                btnCash.Text = "💵 CASH" & vbCrLf & "(Original Method)"
            Case "CARD", "CREDIT CARD", "DEBIT CARD"
                btnCard.BackColor = Color.FromArgb(46, 204, 113)
                btnCard.Text = "💳 CARD" & vbCrLf & "(Original Method)"
            Case "EFT"
                btnEFT.BackColor = Color.FromArgb(46, 204, 113)
                btnEFT.Text = "🏦 EFT" & vbCrLf & "(Original Method)"
        End Select
    End Sub
    
    Private Sub btnCash_Click(sender As Object, e As EventArgs) Handles btnCash.Click
        _selectedRefundMethod = "Cash"
        Me.DialogResult = DialogResult.OK
        Me.Close()
    End Sub
    
    Private Sub btnCard_Click(sender As Object, e As EventArgs) Handles btnCard.Click
        _selectedRefundMethod = "Card"
        
        ' Show card refund confirmation
        Dim result = MessageBox.Show(
            $"Process card refund of {_refundAmount.ToString("C2")}?{vbCrLf}{vbCrLf}" &
            "Please ensure the card terminal is ready for refund processing.",
            "Card Refund",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question)
        
        If result = DialogResult.Yes Then
            Me.DialogResult = DialogResult.OK
            Me.Close()
        End If
    End Sub
    
    Private Sub btnEFT_Click(sender As Object, e As EventArgs) Handles btnEFT.Click
        _selectedRefundMethod = "EFT"
        
        ' Show EFT refund instructions
        MessageBox.Show(
            $"EFT Refund: {_refundAmount.ToString("C2")}{vbCrLf}{vbCrLf}" &
            "Please process the EFT refund manually and confirm when complete.",
            "EFT Refund",
            MessageBoxButtons.OK,
            MessageBoxIcon.Information)
        
        Me.DialogResult = DialogResult.OK
        Me.Close()
    End Sub
    
    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub
End Class
