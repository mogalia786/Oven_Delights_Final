Imports System.Windows.Forms
Imports System.Drawing
Imports System.Drawing.Printing
Imports System.Net.Mail
Imports System.Configuration

Public Structure CreditNoteData
    Public CreditNoteNumber As String
    Public SupplierName As String
    Public SupplierAddress As String
    Public SupplierEmail As String
    Public SupplierContact As String
    Public SupplierPhone As String
    Public CompanyName As String
    Public CompanyAddress As String
    Public CompanyPhone As String
    Public CompanyEmail As String
    Public IssueDate As DateTime
    Public MaterialCode As String
    Public MaterialName As String
    Public ReturnQuantity As Decimal
    Public UnitCost As Decimal
    Public TotalAmount As Decimal
    Public Reason As String
    Public Comments As String
    Public PONumber As String
    Public DeliveryNote As String
End Structure

Public Class CreditNotePrintForm
    Inherits Form

    Private creditNoteInfo As CreditNoteData
    Private printDocument As PrintDocument
    Private rtbCreditNote As RichTextBox

    Public Sub New(creditNote As CreditNoteData)
        InitializeComponent()
        creditNoteInfo = creditNote
        GenerateCreditNoteLetter()
    End Sub

    ' InitializeComponent is in Designer file

    Private Sub GenerateCreditNoteLetter()
        Dim letter As New System.Text.StringBuilder()

        ' Header - Company Details
        letter.AppendLine(creditNoteInfo.CompanyName)
        letter.AppendLine(creditNoteInfo.CompanyAddress)
        letter.AppendLine($"Tel: {creditNoteInfo.CompanyPhone}")
        letter.AppendLine($"Email: {creditNoteInfo.CompanyEmail}")
        letter.AppendLine()
        letter.AppendLine("".PadRight(60, "="))
        letter.AppendLine("CREDIT NOTE")
        letter.AppendLine("".PadRight(60, "="))
        letter.AppendLine()

        ' Credit Note Details
        letter.AppendLine($"Credit Note Number: {creditNoteInfo.CreditNoteNumber}")
        letter.AppendLine($"Date: {creditNoteInfo.IssueDate:dd MMMM yyyy}")
        letter.AppendLine($"PO Number: {creditNoteInfo.PONumber}")
        letter.AppendLine($"Delivery Note: {creditNoteInfo.DeliveryNote}")
        letter.AppendLine()

        ' Supplier Details
        letter.AppendLine("TO:")
        letter.AppendLine(creditNoteInfo.SupplierName)
        If Not String.IsNullOrEmpty(creditNoteInfo.SupplierAddress) Then
            letter.AppendLine(creditNoteInfo.SupplierAddress)
        End If
        If Not String.IsNullOrEmpty(creditNoteInfo.SupplierContact) Then
            letter.AppendLine($"Contact: {creditNoteInfo.SupplierContact}")
        End If
        If Not String.IsNullOrEmpty(creditNoteInfo.SupplierPhone) Then
            letter.AppendLine($"Phone: {creditNoteInfo.SupplierPhone}")
        End If
        If Not String.IsNullOrEmpty(creditNoteInfo.SupplierEmail) Then
            letter.AppendLine($"Email: {creditNoteInfo.SupplierEmail}")
        End If
        letter.AppendLine()

        ' Credit Note Body - Professional Letter
        letter.AppendLine("Dear Sir/Madam,")
        letter.AppendLine()
        letter.AppendLine("RE: CREDIT NOTE FOR RETURNED GOODS")
        letter.AppendLine()
        letter.AppendLine($"We are issuing this credit note in relation to Purchase Order {creditNoteInfo.PONumber} ")
        letter.AppendLine($"dated {creditNoteInfo.IssueDate:dd MMMM yyyy}. The reason for this credit note is: {creditNoteInfo.Reason}.")
        letter.AppendLine()
        If Not String.IsNullOrEmpty(creditNoteInfo.Comments) Then
            letter.AppendLine($"Additional Details: {creditNoteInfo.Comments}")
            letter.AppendLine()
        End If

        ' Item Details
        letter.AppendLine("ITEM DETAILS:")
        letter.AppendLine("".PadRight(60, "-"))
        letter.AppendLine($"Material Code: {creditNoteInfo.MaterialCode}")
        letter.AppendLine($"Description: {creditNoteInfo.MaterialName}")
        letter.AppendLine($"Quantity Returned: {creditNoteInfo.ReturnQuantity:N2}")
        letter.AppendLine($"Unit Cost: R {creditNoteInfo.UnitCost:N2}")
        letter.AppendLine($"Total Credit Amount: R {creditNoteInfo.TotalAmount:N2}")
        letter.AppendLine()

        ' Reason
        letter.AppendLine($"Reason for Credit: {creditNoteInfo.Reason}")
        If Not String.IsNullOrEmpty(creditNoteInfo.Comments) Then
            letter.AppendLine($"Additional Comments: {creditNoteInfo.Comments}")
        End If
        letter.AppendLine()

        ' Footer
        letter.AppendLine("Please adjust your records accordingly and issue a credit")
        letter.AppendLine("note against our account for the above amount.")
        letter.AppendLine()
        letter.AppendLine("Thank you for your cooperation.")
        letter.AppendLine()
        letter.AppendLine("Yours faithfully,")
        letter.AppendLine()
        letter.AppendLine("_________________________")
        letter.AppendLine("Accounts Payable Department")
        letter.AppendLine("Oven Delights (Pty) Ltd")
        letter.AppendLine()
        letter.AppendLine($"Generated on: {DateTime.Now:dd MMMM yyyy HH:mm}")

        rtbCreditNote.Text = letter.ToString()
    End Sub

    Private Sub btnPrint_Click(sender As Object, e As EventArgs)
        Try
            Dim printDialog As New PrintDialog()
            printDialog.Document = printDocument

            If printDialog.ShowDialog() = DialogResult.OK Then
                printDocument.Print()
                MessageBox.Show("Credit note printed successfully!", "Print Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show($"Error printing credit note: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnEmail_Click(sender As Object, e As EventArgs)
        Try
            If String.IsNullOrEmpty(creditNoteInfo.SupplierEmail) Then
                MessageBox.Show("No email address available for this supplier.", "Email Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim emailForm As New EmailCreditNoteForm(creditNoteInfo, rtbCreditNote.Text)
            emailForm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show($"Error preparing email: {ex.Message}", "Email Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs)
        Me.Close()
    End Sub

    Private Sub PrintDocument_PrintPage(sender As Object, e As PrintPageEventArgs)
        Try
            Dim font As New Font("Courier New", 10)
            Dim brush As New SolidBrush(Color.Black)
            Dim leftMargin As Single = e.MarginBounds.Left
            Dim topMargin As Single = e.MarginBounds.Top
            Dim lineHeight As Single = font.GetHeight(e.Graphics)
            Dim linesPerPage As Integer = CInt(e.MarginBounds.Height / lineHeight)

            Dim lines() As String = rtbCreditNote.Text.Split(vbLf)
            Dim currentLine As Integer = 0

            For i As Integer = 0 To Math.Min(lines.Length - 1, linesPerPage - 1)
                Dim yPosition As Single = topMargin + (currentLine * lineHeight)
                e.Graphics.DrawString(lines(i), font, brush, leftMargin, yPosition)
                currentLine += 1
            Next

            e.HasMorePages = False
        Catch ex As Exception
            MessageBox.Show($"Error during printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class