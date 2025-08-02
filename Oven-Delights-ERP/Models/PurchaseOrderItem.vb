Imports System.ComponentModel.DataAnnotations

Public Class PurchaseOrderItem
    Public Property ID As Integer
    Public Property OrderID As Integer
    Public Property MaterialID As Integer
    Public Property LineNumber As Integer
    Public Property QuantityOrdered As Decimal
    Public Property QuantityReceived As Decimal
    Public Property UnitOfMeasure As String
    Public Property UnitPrice As Decimal
    Public Property DiscountPercentage As Decimal
    Public Property LineTotal As Decimal
    Public Property Status As String
    Public Property RequiredDate As DateTime?
    Public Property Notes As String
    Public Property CreatedDate As DateTime
    Public Property CreatedBy As Integer
    Public Property ModifiedDate As DateTime?
    Public Property ModifiedBy As Integer?

    ' Navigation properties
    Public Property PurchaseOrder As PurchaseOrder
    Public Property RawMaterial As RawMaterial
    Public Property CreatedByUser As User
    Public Property ModifiedByUser As User

    Public Sub New()
        Status = "Ordered"
        QuantityOrdered = 0
        QuantityReceived = 0
        UnitPrice = 0
        DiscountPercentage = 0
        LineTotal = 0
        CreatedDate = DateTime.Now
    End Sub

    Public ReadOnly Property QuantityOutstanding As Decimal
        Get
            Return QuantityOrdered - QuantityReceived
        End Get
    End Property

    Public ReadOnly Property IsFullyReceived As Boolean
        Get
            Return QuantityReceived >= QuantityOrdered
        End Get
    End Property

    Public ReadOnly Property IsPartiallyReceived As Boolean
        Get
            Return QuantityReceived > 0 AndAlso QuantityReceived < QuantityOrdered
        End Get
    End Property

    Public ReadOnly Property ReceiptPercentage As Decimal
        Get
            If QuantityOrdered = 0 Then Return 0
            Return Math.Round((QuantityReceived / QuantityOrdered) * 100, 2)
        End Get
    End Property

    Public ReadOnly Property StatusColor As String
        Get
            Select Case Status.ToUpper()
                Case "ORDERED"
                    Return "Blue"
                Case "PARTIALLYRECEIVED"
                    Return "Orange"
                Case "RECEIVED"
                    Return "Green"
                Case "CANCELLED"
                    Return "Red"
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

    Public Sub CalculateLineTotal()
        Dim discountAmount As Decimal = (UnitPrice * QuantityOrdered) * (DiscountPercentage / 100)
        LineTotal = (UnitPrice * QuantityOrdered) - discountAmount
    End Sub

    Public Function CanReceiveQuantity(quantityToReceive As Decimal) As Boolean
        Return quantityToReceive > 0 AndAlso (QuantityReceived + quantityToReceive) <= QuantityOrdered
    End Function

    Public Sub UpdateReceiptStatus()
        If QuantityReceived = 0 Then
            Status = "Ordered"
        ElseIf QuantityReceived >= QuantityOrdered Then
            Status = "Received"
        Else
            Status = "PartiallyReceived"
        End If
    End Sub
End Class
