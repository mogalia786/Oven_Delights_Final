Imports System.Data
Imports System.Configuration
Imports System.Data.SqlClient

Public Class CreditNoteService
    Private ReadOnly connectionString As String
    Private ReadOnly stockroomService As New StockroomService()

    Public Sub New()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    ' Get Credit Note for printing/display
    Public Function GetCreditNoteForPrint(creditNoteId As Integer) As CreditNotePrintData
        Using con As New SqlConnection(connectionString)
            con.Open()
            
            ' Get header information
            Dim headerSql As String = "
                SELECT cn.*, s.SupplierName, s.Address AS SupplierAddress, s.ContactPerson, s.Phone, s.Email,
                       b.BranchName, b.Address AS BranchAddress, b.Phone AS BranchPhone,
                       grv.GRVNumber, grv.ReceivedDate, grv.DeliveryNoteNumber,
                       po.PONumber, po.PODate,
                       u.FirstName + ' ' + u.LastName AS CreatedByName
                FROM CreditNotes cn
                LEFT JOIN Suppliers s ON cn.SupplierID = s.SupplierID
                LEFT JOIN Branches b ON cn.BranchID = b.BranchID
                LEFT JOIN GoodsReceivedVouchers grv ON cn.GRVID = grv.GRVID
                LEFT JOIN PurchaseOrders po ON grv.PurchaseOrderID = po.PurchaseOrderID
                LEFT JOIN Users u ON cn.CreatedBy = u.UserID
                WHERE cn.CreditNoteID = @id"
            
            Dim printData As New CreditNotePrintData()
            printData.Lines = New List(Of CreditNoteLineData)()
            
            Using cmd As New SqlCommand(headerSql, con)
                cmd.Parameters.AddWithValue("@id", creditNoteId)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        ' Header data
                        printData.CreditNoteNumber = reader("CreditNoteNumber").ToString()
                        printData.CreditDate = Convert.ToDateTime(reader("CreditDate"))
                        printData.CreditType = reader("CreditType").ToString()
                        printData.CreditReason = reader("CreditReason").ToString()
                        printData.Status = reader("Status").ToString()
                        printData.SubTotal = Convert.ToDecimal(reader("SubTotal"))
                        printData.VATAmount = Convert.ToDecimal(reader("VATAmount"))
                        printData.TotalAmount = Convert.ToDecimal(reader("TotalAmount"))
                        printData.CreatedByName = reader("CreatedByName").ToString()
                        
                        ' Supplier data
                        printData.SupplierName = reader("SupplierName").ToString()
                        printData.SupplierAddress = reader("SupplierAddress").ToString()
                        printData.SupplierContact = reader("ContactPerson").ToString()
                        printData.SupplierPhone = reader("Phone").ToString()
                        printData.SupplierEmail = reader("Email").ToString()
                        
                        ' Branch data
                        printData.BranchName = reader("BranchName").ToString()
                        printData.BranchAddress = reader("BranchAddress").ToString()
                        printData.BranchPhone = reader("BranchPhone").ToString()
                        
                        ' Reference data
                        printData.GRVNumber = reader("GRVNumber").ToString()
                        printData.GRVDate = If(IsDBNull(reader("ReceivedDate")), Nothing, Convert.ToDateTime(reader("ReceivedDate")))
                        printData.DeliveryNote = reader("DeliveryNoteNumber").ToString()
                        printData.PONumber = reader("PONumber").ToString()
                        printData.PODate = If(IsDBNull(reader("PODate")), Nothing, Convert.ToDateTime(reader("PODate")))
                    End If
                End Using
            End Using
            
            ' Get line items
            Dim linesSql As String = "
                SELECT cnl.*, 
                       COALESCE(rm.MaterialName, p.Name, sp.Name) AS ItemName,
                       COALESCE(rm.MaterialCode, p.SKU, sp.Code) AS ItemCode,
                       COALESCE(rm.Unit, p.Unit, sp.Unit) AS Unit
                FROM CreditNoteLines cnl
                LEFT JOIN RawMaterials rm ON cnl.MaterialID = rm.MaterialID
                LEFT JOIN Products p ON cnl.ProductID = p.ProductID
                LEFT JOIN Stockroom_Product sp ON cnl.ProductID = sp.ProductID
                WHERE cnl.CreditNoteID = @id
                ORDER BY cnl.CreditNoteLineID"
            
            Using cmd As New SqlCommand(linesSql, con)
                cmd.Parameters.AddWithValue("@id", creditNoteId)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim line As New CreditNoteLineData() With {
                            .ItemCode = reader("ItemCode").ToString(),
                            .ItemName = reader("ItemName").ToString(),
                            .Unit = reader("Unit").ToString(),
                            .CreditQuantity = Convert.ToDecimal(reader("CreditQuantity")),
                            .UnitCost = Convert.ToDecimal(reader("UnitCost")),
                            .LineTotal = Convert.ToDecimal(reader("LineTotal")),
                            .LineReason = reader("LineReason").ToString()
                        }
                        printData.Lines.Add(line)
                    End While
                End Using
            End Using
            
            Return printData
        End Using
    End Function

    ' Generate HTML for printing
    Public Function GenerateCreditNoteHTML(creditNoteId As Integer) As String
        Dim printData As CreditNotePrintData = GetCreditNoteForPrint(creditNoteId)
        
        Dim html As New System.Text.StringBuilder()
        
        html.AppendLine("<!DOCTYPE html>")
        html.AppendLine("<html>")
        html.AppendLine("<head>")
        html.AppendLine("<meta charset='utf-8'>")
        html.AppendLine("<title>Credit Note - " & printData.CreditNoteNumber & "</title>")
        html.AppendLine("<style>")
        html.AppendLine("body { font-family: Arial, sans-serif; font-size: 12px; margin: 20px; }")
        html.AppendLine(".header { text-align: center; margin-bottom: 30px; }")
        html.AppendLine(".company-name { font-size: 24px; font-weight: bold; color: #d32f2f; }")
        html.AppendLine(".document-title { font-size: 18px; font-weight: bold; margin-top: 10px; }")
        html.AppendLine(".info-section { margin-bottom: 20px; }")
        html.AppendLine(".info-row { display: flex; margin-bottom: 5px; }")
        html.AppendLine(".info-label { font-weight: bold; width: 150px; }")
        html.AppendLine(".supplier-info { border: 1px solid #ccc; padding: 15px; margin-bottom: 20px; }")
        html.AppendLine(".supplier-title { font-weight: bold; font-size: 14px; margin-bottom: 10px; }")
        html.AppendLine("table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }")
        html.AppendLine("th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }")
        html.AppendLine("th { background-color: #f5f5f5; font-weight: bold; }")
        html.AppendLine(".number-cell { text-align: right; }")
        html.AppendLine(".totals-section { float: right; width: 300px; }")
        html.AppendLine(".totals-table { width: 100%; }")
        html.AppendLine(".totals-table td { border: 1px solid #ccc; padding: 5px; }")
        html.AppendLine(".total-row { font-weight: bold; background-color: #f0f0f0; }")
        html.AppendLine(".reason-section { margin-top: 30px; clear: both; }")
        html.AppendLine(".signature-section { margin-top: 50px; }")
        html.AppendLine(".signature-box { border-top: 1px solid #000; width: 200px; text-align: center; padding-top: 5px; }")
        html.AppendLine("@media print { body { margin: 0; } }")
        html.AppendLine("</style>")
        html.AppendLine("</head>")
        html.AppendLine("<body>")
        
        ' Header
        html.AppendLine("<div class='header'>")
        html.AppendLine("<div class='company-name'>OVEN DELIGHTS</div>")
        html.AppendLine("<div class='document-title'>CREDIT NOTE</div>")
        html.AppendLine("</div>")
        
        ' Credit Note Info
        html.AppendLine("<div class='info-section'>")
        html.AppendLine("<div class='info-row'>")
        html.AppendLine("<span class='info-label'>Credit Note No:</span>")
        html.AppendLine("<span>" & printData.CreditNoteNumber & "</span>")
        html.AppendLine("</div>")
        html.AppendLine("<div class='info-row'>")
        html.AppendLine("<span class='info-label'>Date:</span>")
        html.AppendLine("<span>" & printData.CreditDate.ToString("dd/MM/yyyy") & "</span>")
        html.AppendLine("</div>")
        html.AppendLine("<div class='info-row'>")
        html.AppendLine("<span class='info-label'>Type:</span>")
        html.AppendLine("<span>" & printData.CreditType & "</span>")
        html.AppendLine("</div>")
        html.AppendLine("<div class='info-row'>")
        html.AppendLine("<span class='info-label'>GRV Reference:</span>")
        html.AppendLine("<span>" & printData.GRVNumber & "</span>")
        html.AppendLine("</div>")
        If Not String.IsNullOrEmpty(printData.PONumber) Then
            html.AppendLine("<div class='info-row'>")
            html.AppendLine("<span class='info-label'>PO Reference:</span>")
            html.AppendLine("<span>" & printData.PONumber & "</span>")
            html.AppendLine("</div>")
        End If
        If Not String.IsNullOrEmpty(printData.DeliveryNote) Then
            html.AppendLine("<div class='info-row'>")
            html.AppendLine("<span class='info-label'>Delivery Note:</span>")
            html.AppendLine("<span>" & printData.DeliveryNote & "</span>")
            html.AppendLine("</div>")
        End If
        html.AppendLine("</div>")
        
        ' Supplier Information
        html.AppendLine("<div class='supplier-info'>")
        html.AppendLine("<div class='supplier-title'>SUPPLIER DETAILS</div>")
        html.AppendLine("<strong>" & printData.SupplierName & "</strong><br>")
        If Not String.IsNullOrEmpty(printData.SupplierAddress) Then
            html.AppendLine(printData.SupplierAddress.Replace(vbCrLf, "<br>") & "<br>")
        End If
        If Not String.IsNullOrEmpty(printData.SupplierContact) Then
            html.AppendLine("Contact: " & printData.SupplierContact & "<br>")
        End If
        If Not String.IsNullOrEmpty(printData.SupplierPhone) Then
            html.AppendLine("Phone: " & printData.SupplierPhone & "<br>")
        End If
        If Not String.IsNullOrEmpty(printData.SupplierEmail) Then
            html.AppendLine("Email: " & printData.SupplierEmail & "<br>")
        End If
        html.AppendLine("</div>")
        
        ' Line Items Table
        html.AppendLine("<table>")
        html.AppendLine("<thead>")
        html.AppendLine("<tr>")
        html.AppendLine("<th>Item Code</th>")
        html.AppendLine("<th>Description</th>")
        html.AppendLine("<th>Unit</th>")
        html.AppendLine("<th class='number-cell'>Quantity</th>")
        html.AppendLine("<th class='number-cell'>Unit Cost</th>")
        html.AppendLine("<th class='number-cell'>Total</th>")
        html.AppendLine("<th>Reason</th>")
        html.AppendLine("</tr>")
        html.AppendLine("</thead>")
        html.AppendLine("<tbody>")
        
        For Each line As CreditNoteLineData In printData.Lines
            html.AppendLine("<tr>")
            html.AppendLine("<td>" & line.ItemCode & "</td>")
            html.AppendLine("<td>" & line.ItemName & "</td>")
            html.AppendLine("<td>" & line.Unit & "</td>")
            html.AppendLine("<td class='number-cell'>" & line.CreditQuantity.ToString("N2") & "</td>")
            html.AppendLine("<td class='number-cell'>" & line.UnitCost.ToString("C2") & "</td>")
            html.AppendLine("<td class='number-cell'>" & line.LineTotal.ToString("C2") & "</td>")
            html.AppendLine("<td>" & line.LineReason & "</td>")
            html.AppendLine("</tr>")
        Next
        
        html.AppendLine("</tbody>")
        html.AppendLine("</table>")
        
        ' Totals
        html.AppendLine("<div class='totals-section'>")
        html.AppendLine("<table class='totals-table'>")
        html.AppendLine("<tr>")
        html.AppendLine("<td>Sub Total:</td>")
        html.AppendLine("<td class='number-cell'>" & printData.SubTotal.ToString("C2") & "</td>")
        html.AppendLine("</tr>")
        html.AppendLine("<tr>")
        html.AppendLine("<td>VAT (15%):</td>")
        html.AppendLine("<td class='number-cell'>" & printData.VATAmount.ToString("C2") & "</td>")
        html.AppendLine("</tr>")
        html.AppendLine("<tr class='total-row'>")
        html.AppendLine("<td>TOTAL CREDIT:</td>")
        html.AppendLine("<td class='number-cell'>" & printData.TotalAmount.ToString("C2") & "</td>")
        html.AppendLine("</tr>")
        html.AppendLine("</table>")
        html.AppendLine("</div>")
        
        ' Reason Section
        html.AppendLine("<div class='reason-section'>")
        html.AppendLine("<strong>Credit Reason:</strong><br>")
        html.AppendLine(printData.CreditReason.Replace(vbCrLf, "<br>"))
        html.AppendLine("</div>")
        
        ' Signature Section
        html.AppendLine("<div class='signature-section'>")
        html.AppendLine("<div style='float: left;'>")
        html.AppendLine("<div class='signature-box'>Authorized Signature</div>")
        html.AppendLine("<div style='margin-top: 10px; font-size: 10px;'>")
        html.AppendLine("Prepared by: " & printData.CreatedByName & "<br>")
        html.AppendLine("Date: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm"))
        html.AppendLine("</div>")
        html.AppendLine("</div>")
        html.AppendLine("<div style='float: right;'>")
        html.AppendLine("<div class='signature-box'>Supplier Acknowledgment</div>")
        html.AppendLine("<div style='margin-top: 10px; font-size: 10px;'>")
        html.AppendLine("Date: _______________")
        html.AppendLine("</div>")
        html.AppendLine("</div>")
        html.AppendLine("<div style='clear: both;'></div>")
        html.AppendLine("</div>")
        
        html.AppendLine("</body>")
        html.AppendLine("</html>")
        
        Return html.ToString()
    End Function
End Class
