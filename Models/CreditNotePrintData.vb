Public Class CreditNotePrintData
    Public Property CreditNoteNumber As String
    Public Property CreditDate As DateTime
    Public Property CreditType As String
    Public Property CreditReason As String
    Public Property Status As String
    Public Property SubTotal As Decimal
    Public Property VATAmount As Decimal
    Public Property TotalAmount As Decimal
    Public Property CreatedByName As String
    Public Property SupplierName As String
    Public Property SupplierAddress As String
    Public Property SupplierEmail As String
    Public Property SupplierContact As String
    Public Property SupplierPhone As String
    Public Property BranchName As String
    Public Property BranchAddress As String
    Public Property BranchPhone As String
    Public Property GRVNumber As String
    Public Property GRVDate As DateTime?
    Public Property PODate As DateTime?
    Public Property IssueDate As DateTime
    Public Property MaterialCode As String
    Public Property MaterialName As String
    Public Property ReturnQuantity As Decimal
    Public Property UnitCost As Decimal
    Public Property Reason As String
    Public Property Comments As String
    Public Property PONumber As String
    Public Property DeliveryNote As String
    Public Property Lines As New List(Of CreditNoteLineData)
End Class

Public Class CreditNoteLineData
    Public Property ItemCode As String
    Public Property ItemName As String
    Public Property Unit As String
    Public Property CreditQuantity As Decimal
    Public Property UnitCost As Decimal
    Public Property LineTotal As Decimal
    Public Property LineReason As String
End Class