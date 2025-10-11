Imports System.IO
Imports System.Text

Public Class PdfService
    Private Shared Function HtmlEncode(input As String) As String
        If String.IsNullOrEmpty(input) Then Return String.Empty
        Dim s = input.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;")
        ' Replace a double quote using VB string escape """"
        s = s.Replace("""", "&quot;").Replace("'", "&#39;")
        Return s
    End Function
    Private Shared Function SanitizeToken(input As String) As String
        If String.IsNullOrWhiteSpace(input) Then Return String.Empty
        Dim invalid = IO.Path.GetInvalidFileNameChars()
        Dim sb As New StringBuilder(input.Length)
        For Each ch In input
            If invalid.Contains(ch) Then
                sb.Append("_")
            Else
                sb.Append(ch)
            End If
        Next
        Return sb.ToString()
    End Function
    Private Shared Function EnsureOutputFolder() As String
        ' Store PDFs next to the executable in a single "Documents" folder
        Dim basePath As String = System.Windows.Forms.Application.StartupPath
        Dim folder As String = IO.Path.Combine(basePath, "Documents")
        If Not Directory.Exists(folder) Then Directory.CreateDirectory(folder)
        Return folder
    End Function

    Private Shared Function BuildHtmlDocument(title As String, sections As IEnumerable(Of String)) As String
        Dim sb As New StringBuilder()
        sb.AppendLine("<!DOCTYPE html>")
        sb.AppendLine("<html><head><meta charset='utf-8'>")
        sb.AppendLine("<style> body{font-family:Segoe UI, Arial, sans-serif;margin:24px;} h1{font-size:20px;margin:0 0 8px;} h2{font-size:16px;margin:16px 0 6px;} table{width:100%;border-collapse:collapse;margin-top:8px;} th,td{border:1px solid #ddd;padding:6px;text-align:left;} th{background:#f6f6f6;} .meta{color:#666;margin-bottom:8px;} </style>")
        sb.AppendLine("</head><body>")
        sb.AppendLine($"<h1>{title}</h1>")
        sb.AppendLine($"<div class='meta'>Generated: {DateTime.Now:yyyy-MM-dd HH:mm:ss}</div>")
        For Each s In sections
            sb.AppendLine(s)
        Next
        sb.AppendLine("</body></html>")
        Return sb.ToString()
    End Function

    Private Shared Function WriteAsPseudoPdf(html As String, baseFileName As String) As String
        ' For now, write HTML alongside a .pdf filename for downstream email/sharing
        Dim folder = EnsureOutputFolder()
        Dim pdfPath = IO.Path.Combine(folder, baseFileName & ".pdf")
        Dim htmlPath = IO.Path.Combine(folder, baseFileName & ".html")
        IO.File.WriteAllText(htmlPath, html, Encoding.UTF8)
        ' Copy to .pdf extension so email clients accept it; replace if exists
        IO.File.Copy(htmlPath, pdfPath, True)
        Return pdfPath
    End Function

    ' Save with an exact document number (e.g., "GRV-000123") as the filename
    Public Shared Function SavePdfWithDocumentNumber(docNumber As String, html As String) As String
        Dim safeName As String = SanitizeToken(docNumber)
        Dim folder = EnsureOutputFolder()
        Dim pdfPath = IO.Path.Combine(folder, safeName & ".pdf")
        Dim htmlPath = IO.Path.Combine(folder, safeName & ".html")
        IO.File.WriteAllText(htmlPath, html, Encoding.UTF8)
        IO.File.Copy(htmlPath, pdfPath, True)
        Return pdfPath
    End Function

    Public Function GenerateGrvPdf(grnId As Integer, supplierName As String, poNumber As String, receivedDate As DateTime, deliveryNote As String, lines As DataTable, subTotal As Decimal, vat As Decimal, total As Decimal) As String
        Dim title = $"Goods Received Voucher (GRV)"
        Dim hdr As String = $"<h2>Header</h2><p><strong>GRN ID:</strong> {grnId}<br/><strong>Supplier:</strong> {supplierName}<br/><strong>PO:</strong> {poNumber}<br/><strong>Received:</strong> {receivedDate:yyyy-MM-dd}<br/><strong>Delivery Note:</strong> {deliveryNote}</p>"
        Dim tbl As New StringBuilder()
        tbl.AppendLine("<h2>Lines</h2><table><tr><th>Material</th><th>Ordered</th><th>Rec TD</th><th>Receive Now</th><th>Unit Cost</th><th>Line Total</th></tr>")
        If lines IsNot Nothing Then
            For Each r As DataRow In lines.Rows
                Dim material = Convert.ToString(r("MaterialName"))
                Dim ordered = Convert.ToDecimal(If(r.Table.Columns.Contains("OrderedQuantity"), r("OrderedQuantity"), 0D))
                Dim recTd = Convert.ToDecimal(If(r.Table.Columns.Contains("ReceivedQuantityToDate"), r("ReceivedQuantityToDate"), 0D))
                Dim recvNow = Convert.ToDecimal(If(r.Table.Columns.Contains("ReceiveNow"), r("ReceiveNow"), 0D))
                Dim unit = Convert.ToDecimal(If(r.Table.Columns.Contains("UnitCost"), r("UnitCost"), 0D))
                Dim lineTot = Math.Round(recvNow * unit, 2)
                tbl.AppendLine($"<tr><td>{material}</td><td>{ordered:N2}</td><td>{recTd:N2}</td><td>{recvNow:N2}</td><td>{unit:N2}</td><td>{lineTot:N2}</td></tr>")
            Next
        End If
        tbl.AppendLine("</table>")
        Dim ftr As String = $"<h2>Totals</h2><p><strong>SubTotal:</strong> {subTotal:N2} &nbsp; <strong>VAT:</strong> {vat:N2} &nbsp; <strong>Total:</strong> {total:N2}</p>"
        Dim html = BuildHtmlDocument(title, {hdr, tbl.ToString(), ftr})
        Dim suffix As String = ""
        If Not String.IsNullOrWhiteSpace(poNumber) Then suffix = "_" & SanitizeToken(poNumber)
        Return WriteAsPseudoPdf(html, $"GRV_{grnId}{suffix}")
    End Function

    Public Function GenerateCreditNotePdf(crnId As Integer, supplierName As String, creditDate As DateTime, reason As String, lines As DataTable) As String
        Dim title = "Supplier Credit Note"
        Dim hdr As String = $"<h2>Header</h2><p><strong>Credit Note ID:</strong> {crnId}<br/><strong>Supplier:</strong> {supplierName}<br/><strong>Date:</strong> {creditDate:yyyy-MM-dd}<br/><strong>Reason:</strong> {reason}</p>"
        Dim tbl As New StringBuilder()
        tbl.AppendLine("<h2>Lines</h2><table><tr><th>Material</th><th>Return Qty</th><th>Unit Cost</th><th>Amount</th><th>Comments</th></tr>")
        Dim total As Decimal = 0D
        If lines IsNot Nothing Then
            For Each r As DataRow In lines.Rows
                Dim material = Convert.ToString(If(lines.Columns.Contains("MaterialName"), r("MaterialName"), r("MaterialID").ToString()))
                Dim ret = Convert.ToDecimal(r("ReturnQuantity"))
                Dim unit = Convert.ToDecimal(r("UnitCost"))
                Dim amt = Math.Round(ret * unit, 2)
                total += amt
                Dim comments = Convert.ToString(If(lines.Columns.Contains("Comments"), r("Comments"), ""))
                tbl.AppendLine($"<tr><td>{material}</td><td>{ret:N2}</td><td>{unit:N2}</td><td>{amt:N2}</td><td>{HtmlEncode(comments)}</td></tr>")
            Next
        End If
        tbl.AppendLine("</table>")
        Dim ftr As String = $"<h2>Total</h2><p><strong>Total:</strong> {total:N2}</p>"
        Dim html = BuildHtmlDocument(title, {hdr, tbl.ToString(), ftr})
        Return WriteAsPseudoPdf(html, $"CRN_{crnId}")
    End Function

    Public Function GenerateInvoicePdf(invoiceId As Integer, supplierName As String, invoiceDate As DateTime, lines As DataTable, subTotal As Decimal, vat As Decimal, total As Decimal, Optional poNumber As String = Nothing) As String
        Dim title = "Supplier Invoice"
        Dim hdr As String = $"<h2>Header</h2><p><strong>Invoice ID:</strong> {invoiceId}<br/><strong>Supplier:</strong> {supplierName}<br/><strong>Date:</strong> {invoiceDate:yyyy-MM-dd}</p>"
        Dim tbl As New StringBuilder()
        tbl.AppendLine("<h2>Lines</h2><table><tr><th>Material</th><th>Qty</th><th>Unit Cost</th><th>Line Total</th></tr>")
        If lines IsNot Nothing Then
            For Each r As DataRow In lines.Rows
                Dim material = Convert.ToString(If(lines.Columns.Contains("MaterialName"), r("MaterialName"), r("MaterialID").ToString()))
                Dim qty = Convert.ToDecimal(If(lines.Columns.Contains("Quantity"), r("Quantity"), 0D))
                Dim unit = Convert.ToDecimal(If(lines.Columns.Contains("UnitCost"), r("UnitCost"), 0D))
                Dim lineTot = Math.Round(qty * unit, 2)
                tbl.AppendLine($"<tr><td>{material}</td><td>{qty:N2}</td><td>{unit:N2}</td><td>{lineTot:N2}</td></tr>")
            Next
        End If
        tbl.AppendLine("</table>")
        Dim ftr As String = $"<h2>Totals</h2><p><strong>SubTotal:</strong> {subTotal:N2} &nbsp; <strong>VAT:</strong> {vat:N2} &nbsp; <strong>Total:</strong> {total:N2}</p>"
        Dim html = BuildHtmlDocument(title, {hdr, tbl.ToString(), ftr})
        Dim suffix As String = ""
        If Not String.IsNullOrWhiteSpace(poNumber) Then suffix = "_" & SanitizeToken(poNumber)
        Return WriteAsPseudoPdf(html, $"INV_{invoiceId}{suffix}")
    End Function

    ' Generic: export any DataGridView to printable HTML-backed PDF and return the saved path
    Public Shared Function SaveDataGridViewAsPdf(dgv As System.Windows.Forms.DataGridView, title As String, baseFileName As String) As String
        If dgv Is Nothing Then Throw New ArgumentNullException(NameOf(dgv))
        Dim sb As New StringBuilder()
        sb.AppendLine("<!DOCTYPE html><html><head><meta charset='utf-8'>")
        sb.AppendLine("<style> body{font-family:Segoe UI,Arial,sans-serif;margin:24px;} h1{font-size:20px;margin:0 0 8px;} table{width:100%;border-collapse:collapse;} th,td{border:1px solid #ddd;padding:6px;text-align:left;} th{background:#f6f6f6;} .meta{color:#666;margin-bottom:8px;} </style>")
        sb.AppendLine("</head><body>")
        sb.AppendLine($"<h1>{HtmlEncode(title)}</h1>")
        sb.AppendLine($"<div class='meta'>Generated: {DateTime.Now:yyyy-MM-dd HH:mm}</div>")
        sb.AppendLine("<table><thead><tr>")
        For Each col As System.Windows.Forms.DataGridViewColumn In dgv.Columns
            If col.Visible Then sb.Append("<th>").Append(HtmlEncode(col.HeaderText)).Append("</th>")
        Next
        sb.AppendLine("</tr></thead><tbody>")
        For Each row As System.Windows.Forms.DataGridViewRow In dgv.Rows
            If row.IsNewRow Then Continue For
            sb.Append("<tr>")
            For Each col As System.Windows.Forms.DataGridViewColumn In dgv.Columns
                If Not col.Visible Then Continue For
                Dim val = row.Cells(col.Index).Value
                Dim cellText As String = If(val Is Nothing, "", val.ToString())
                sb.Append("<td>").Append(HtmlEncode(cellText)).Append("</td>")
            Next
            sb.AppendLine("</tr>")
        Next
        sb.AppendLine("</tbody></table></body></html>")
        Return WriteAsPseudoPdf(sb.ToString(), SanitizeToken(baseFileName))
    End Function
End Class
