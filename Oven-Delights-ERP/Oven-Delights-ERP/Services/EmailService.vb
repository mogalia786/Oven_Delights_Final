Imports System.Net
Imports System.Net.Mail
Imports System.Configuration
Imports System.Linq

Public Class EmailService
    Private ReadOnly smtpHost As String = ConfigurationManager.AppSettings("SmtpHost")
    Private ReadOnly smtpPort As Integer = Integer.Parse(ConfigurationManager.AppSettings("SmtpPort"))
    Private ReadOnly smtpUser As String = ConfigurationManager.AppSettings("SmtpUser")
    Private ReadOnly smtpPassword As String = ConfigurationManager.AppSettings("SmtpPassword")
    Private ReadOnly smtpFrom As String = ConfigurationManager.AppSettings("SmtpFrom")
    Private ReadOnly smtpUseSsl As Boolean = Boolean.Parse(ConfigurationManager.AppSettings("SmtpUseSsl"))

    Public Sub SendCreditNoteEmail(creditNoteId As Integer, supplierName As String, creditNoteNumber As String, creditDate As DateTime, totalAmount As Decimal, Optional additionalRecipientsCsv As String = Nothing, Optional attachmentPath As String = Nothing)
        ' Build message
        Dim subject As String = $"Supplier Credit Note {creditNoteNumber} - {supplierName}"
        Dim body As String = $"" & _
            $"<h3>Supplier Credit Note</h3>" & _
            $"<p><strong>Supplier:</strong> {supplierName}<br/>" & _
            $"<strong>Credit Note #:</strong> {creditNoteNumber}<br/>" & _
            $"<strong>Date:</strong> {creditDate:yyyy-MM-dd}<br/>" & _
            $"<strong>Total:</strong> {totalAmount:N2}</p>" & _
            $"<p>Credit Note ID: {creditNoteId}</p>"

        Dim toList As New List(Of String)()
        Dim defaults = ConfigurationManager.AppSettings("CreditNoteEmailTo")
        If Not String.IsNullOrWhiteSpace(defaults) Then
            toList.AddRange(defaults.Split({","c, ";"c}, StringSplitOptions.RemoveEmptyEntries).Select(Function(s) s.Trim()))
        End If
        If Not String.IsNullOrWhiteSpace(additionalRecipientsCsv) Then
            toList.AddRange(additionalRecipientsCsv.Split({","c, ";"c}, StringSplitOptions.RemoveEmptyEntries).Select(Function(s) s.Trim()))
        End If
        toList = toList.Distinct(StringComparer.OrdinalIgnoreCase).ToList()
        If toList.Count = 0 Then Return ' Nothing to send

        Using msg As New MailMessage()
            msg.From = New MailAddress(smtpFrom)
            For Each r In toList
                msg.To.Add(New MailAddress(r))
            Next
            msg.Subject = subject
            msg.IsBodyHtml = True
            msg.Body = body
            ' Optional attachment (e.g., PDF credit note)
            Try
                If Not String.IsNullOrWhiteSpace(attachmentPath) AndAlso IO.File.Exists(attachmentPath) Then
                    msg.Attachments.Add(New Attachment(attachmentPath))
                End If
            Catch
                ' Ignore attachment issues to avoid blocking email
            End Try

            Using client As New SmtpClient(smtpHost, smtpPort)
                client.EnableSsl = smtpUseSsl
                client.Credentials = New NetworkCredential(smtpUser, smtpPassword)
                client.Send(msg)
            End Using
        End Using
    End Sub
End Class
