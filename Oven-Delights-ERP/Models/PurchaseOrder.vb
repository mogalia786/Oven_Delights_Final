Imports System.ComponentModel.DataAnnotations

Public Class PurchaseOrder
    Public Property ID As Integer
    Public Property OrderNumber As String
    Public Property SupplierID As Integer
    Public Property BranchID As Integer?
    Public Property OrderDate As DateTime
    Public Property RequiredDate As DateTime?
    Public Property ExpectedDeliveryDate As DateTime?
    Public Property Status As String
    Public Property SubTotal As Decimal
    Public Property DiscountPercentage As Decimal
    Public Property DiscountAmount As Decimal
    Public Property TaxPercentage As Decimal
    Public Property TaxAmount As Decimal
    Public Property Total As Decimal
    Public Property Notes As String
    Public Property PaymentTerms As Integer?
    Public Property ApprovedBy As Integer?
    Public Property ApprovedDate As DateTime?
    Public Property CreatedDate As DateTime
    Public Property CreatedBy As Integer
    Public Property ModifiedDate As DateTime?
    Public Property ModifiedBy As Integer?
    Public Property JournalEntryID As Integer?
    Public Property IsPosted As Boolean
    Public Property PostedDate As DateTime?
    Public Property PostedBy As Integer?

    ' Navigation properties
    Public Property Supplier As Supplier
    Public Property Branch As Branch
    Public Property CreatedByUser As User
    Public Property ModifiedByUser As User
    Public Property ApprovedByUser As User
    Public Property PostedByUser As User
    Public Property Items As List(Of PurchaseOrderItem)

    Public Sub New()
        Status = "Draft"
        OrderDate = DateTime.Now
        SubTotal = 0
        DiscountPercentage = 0
        DiscountAmount = 0
        TaxPercentage = 15 ' Default VAT for South Africa
        TaxAmount = 0
        Total = 0
        IsPosted = False
        CreatedDate = DateTime.Now
        Items = New List(Of PurchaseOrderItem)()
    End Sub

    Public ReadOnly Property StatusColor As String
        Get
            Select Case Status.ToUpper()
                Case "DRAFT"
                    Return "Gray"
                Case "SENT"
                    Return "Blue"
                Case "CONFIRMED"
                    Return "Green"
                Case "PARTIALLYRECEIVED"
                    Return "Orange"
                Case "RECEIVED"
                    Return "DarkGreen"
                Case "CANCELLED"
                    Return "Red"
                Case "CLOSED"
                    Return "DarkBlue"
                Case Else
                    Return "Black"
            End Select
        End Get
    End Property

    Public ReadOnly Property DisplayStatus As String
        Get
            Select Case Status.ToUpper()
                Case "PARTIALLYRECEIVED"
                    Return "Partially Received"
                Case Else
                    Return Status
            End Select
        End Get
    End Property

    Public ReadOnly Property TotalItems As Integer
        Get
            Return If(Items?.Count, 0)
        End Get
    End Property

    Public ReadOnly Property TotalQuantity As Decimal
        Get
            Return If(Items?.Sum(Function(i) i.QuantityOrdered), 0)
        End Get
    End Property

    Public ReadOnly Property IsOverdue As Boolean
        Get
            Return RequiredDate.HasValue AndAlso RequiredDate.Value < DateTime.Now AndAlso Status <> "Received" AndAlso Status <> "Cancelled" AndAlso Status <> "Closed"
        End Get
    End Property

    Public Sub CalculateTotals()
        If Items IsNot Nothing AndAlso Items.Count > 0 Then
            SubTotal = Items.Sum(Function(i) i.LineTotal)
            TaxAmount = (SubTotal - DiscountAmount) * (TaxPercentage / 100)
            Total = SubTotal - DiscountAmount + TaxAmount
        Else
            SubTotal = 0
            TaxAmount = 0
            Total = 0
        End If
    End Sub

    Public Function CanBeEdited() As Boolean
        Return Status = "Draft"
    End Function

    Public Function CanBeApproved() As Boolean
        Return Status = "Draft" AndAlso Total > 0
    End Function

    Public Function CanBeSent() As Boolean
        Return (Status = "Draft" OrElse Status = "Approved") AndAlso Total > 0
    End Function

    Public Function CanBeCancelled() As Boolean
        Return Status <> "Received" AndAlso Status <> "Cancelled" AndAlso Status <> "Closed"
    End Function
End Class
