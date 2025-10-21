Imports System.ComponentModel.DataAnnotations
' Navigation properties
Public Class Inventory
    ' DB-aligned fields for Inventory table
    Public Property ID As Integer
    Public Property MaterialID As Integer
    Public Property BranchID As Integer?
    Public Property Location As String
    Public Property Batch As String
    Public Property QuantityOnHand As Decimal
    Public Property QuantityAllocated As Decimal
    Public Property QuantityAvailable As Decimal ' Calculated field (see below)
    Public Property UnitCost As Decimal
    Public Property TotalCost As Decimal ' Calculated field (see below)
    Public Property LastReceived As DateTime?
    Public Property LastIssued As DateTime?
    Public Property LastUpdated As DateTime
    Public Property ExpiryDate As DateTime?
    Public Property IsActive As Boolean
    Public Property CreatedDate As DateTime
    Public Property CreatedBy As Integer
    Public Property ModifiedDate As DateTime?
    Public Property ModifiedBy As Integer?
   
    ' Navigation properties for foreign keys
    Public Property RawMaterial As RawMaterial
    Public Property Branch As Branch
    Public Property CreatedByUser As User
    Public Property ModifiedByUser As User
    Public Property Transactions As List(Of InventoryTransaction)

    Public Sub New()
        Location = "MAIN"
        QuantityOnHand = 0
        QuantityAllocated = 0
        UnitCost = 0
        IsActive = True
        CreatedDate = DateTime.Now
        LastUpdated = DateTime.Now
        Transactions = New List(Of InventoryTransaction)()
    End Sub

    Public ReadOnly Property QuantityAvailableCalculated As Decimal
        Get
            Return QuantityOnHand - QuantityAllocated
        End Get
    End Property

    Public ReadOnly Property TotalCostCalculated As Decimal
        Get
            Return QuantityOnHand * UnitCost
        End Get
    End Property

    Public ReadOnly Property StatusText As String
        Get
            Return If(IsActive, "Active", "Inactive")
        End Get
    End Property

    Public ReadOnly Property StockStatus As String
        Get
            If QuantityOnHand = 0 Then
                Return "Out of Stock"
            ElseIf RawMaterial IsNot Nothing AndAlso QuantityOnHand <= RawMaterial.ReorderLevel Then
                Return "Reorder Required"
            ElseIf QuantityAvailableCalculated <= 0 Then
                Return "Fully Allocated"
            Else
                Return "In Stock"
            End If
        End Get
    End Property

    Public ReadOnly Property StockStatusColor As String
        Get
            Select Case StockStatus
                Case "Out of Stock"
                    Return "Red"
                Case "Reorder Required"
                    Return "Orange"
                Case "Fully Allocated"
                    Return "Yellow"
                Case "In Stock"
                    Return "Green"
                Case Else
                    Return "Black"
            End Select
        End Get
    End Property

    Public ReadOnly Property IsExpiringSoon As Boolean
        Get
            If ExpiryDate.HasValue Then
                Return ExpiryDate.Value <= DateTime.Now.AddDays(7)
            End If
            Return False
        End Get
    End Property

    Public ReadOnly Property IsExpired As Boolean
        Get
            If ExpiryDate.HasValue Then
                Return ExpiryDate.Value < DateTime.Now
            End If
            Return False
        End Get
    End Property

    Public ReadOnly Property ExpiryStatus As String
        Get
            If Not ExpiryDate.HasValue Then
                Return "No Expiry"
            ElseIf IsExpired Then
                Return "Expired"
            ElseIf IsExpiringSoon Then
                Return "Expiring Soon"
            Else
                Return "Fresh"
            End If
        End Get
    End Property

    Public ReadOnly Property DaysToExpiry As Integer?
        Get
            If ExpiryDate.HasValue Then
                Return CInt((ExpiryDate.Value - DateTime.Now).TotalDays)
            End If
            Return Nothing
        End Get
    End Property

    Public Function CanAllocate(quantity As Decimal) As Boolean
        Return quantity > 0 AndAlso (QuantityAllocated + quantity) <= QuantityOnHand
    End Function

    Public Function CanIssue(quantity As Decimal) As Boolean
        Return quantity > 0 AndAlso quantity <= QuantityAvailableCalculated
    End Function

    Public Sub UpdateCalculatedFields()
        QuantityAvailable = QuantityAvailableCalculated
        TotalCost = TotalCostCalculated
        LastUpdated = DateTime.Now
    End Sub
End Class
