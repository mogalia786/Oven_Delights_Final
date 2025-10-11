Imports System.Windows.Forms
Imports System.Drawing
Imports System.Net.Mail
Imports System.Configuration

Public Class EmailCreditNoteForm
    Inherits Form

    Private ReadOnly stockroomService As New StockroomService()
    Private currentBranchId As Integer
    Private creditNoteData As CreditNoteData
    Private creditNoteText As String
    ' Controls are declared in Designer file
    Private txtTo As TextBox
    Private txtBody As RichTextBox

    Public Sub New(creditNote As CreditNoteData, noteText As String)
        creditNoteData = creditNote
        creditNoteText = noteText
        currentBranchId = stockroomService.GetCurrentUserBranchId()
        InitializeComponent()
        PopulateFields()
    End Sub

    ' InitializeComponent is in Designer file

    Private Sub PopulateFields()
        txtTo.Text = creditNoteData.SupplierEmail
        txtSubject.Text = $"Credit Note {creditNoteData.CreditNoteNumber} - {creditNoteData.SupplierName}"

        Dim emailBody As New System.Text.StringBuilder()
        emailBody.AppendLine("Dear Sir/Madam,")
        emailBody.AppendLine()
        emailBody.AppendLine($"Please find attached credit note {creditNoteData.CreditNoteNumber} for your records.")
        emailBody.AppendLine()
        emailBody.AppendLine("Credit Note Details:")
        emailBody.AppendLine($"Material: {creditNoteData.MaterialName}")
        emailBody.AppendLine($"Quantity: {creditNoteData.ReturnQuantity:N2}")
        emailBody.AppendLine($"Amount: R {creditNoteData.TotalAmount:N2}")
        emailBody.AppendLine($"Reason: {creditNoteData.Reason}")
        emailBody.AppendLine()
        emailBody.AppendLine("Please adjust your records accordingly.")
        emailBody.AppendLine()
        emailBody.AppendLine("Kind regards,")
        emailBody.AppendLine("Accounts Payable Department")
        emailBody.AppendLine("Oven Delights (Pty) Ltd")

        txtBody.Text = emailBody.ToString()
    End Sub

    Private Sub btnSend_Click(sender As Object, e As EventArgs)
        Try
            If String.IsNullOrWhiteSpace(txtTo.Text) Then
                MessageBox.Show("Please enter a recipient email address.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            MessageBox.Show("Email functionality requires SMTP configuration. Credit note details have been prepared for sending.", "Email Ready", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Me.Close()
        Catch ex As Exception
            MessageBox.Show($"Error sending email: {ex.Message}", "Email Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnCancel_Click(sender As Object, e As EventArgs)
        Me.Close()
    End Sub
End Class