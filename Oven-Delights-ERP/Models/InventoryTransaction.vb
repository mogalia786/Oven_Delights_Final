Imports System.ComponentModel.DataAnnotations

Public Class InventoryTransaction
    Public Property ID As Integer
    Public Property MaterialID As Integer
    Public Property BranchID As Integer?
    Public Property Location As String
    Public Property TransactionType As String
    Public Property TransactionDate As DateTime
    Public Property ReferenceType As String
    Public Property ReferenceID As Integer?
    Public Property ReferenceNumber As String
    Public Property Quantity As Decimal
    Public Property UnitCost As Decimal
    Public Property TotalCost As Decimal
    Public Property RunningBalance As Decimal
    Public Property Notes As String
    Public Property CreatedDate As DateTime
    Public Property CreatedBy As Integer
    Public Property JournalEntryID As Integer?
    Public Property IsPosted As Boolean
    Public Property PostedDate As DateTime?
    Public Property PostedBy As Integer?

    ' Navigation properties
    Public Property RawMaterial As RawMaterial
    Public Property Branch As Branch
    Public Property CreatedByUser As User
    Public Property PostedByUser As User

    Public Sub New()
        TransactionDate = DateTime.Now
        Quantity = 0
        UnitCost = 0
        TotalCost = 0
        RunningBalance = 0
        IsPosted = False
        CreatedDate = DateTime.Now
    End Sub

    Public ReadOnly Property TransactionTypeDisplay As String
        Get
            Select Case TransactionType.ToUpper()
                Case "RECEIPT"
                    Return "Receipt"
                Case "ISSUE"
                    Return "Issue"
                Case "TRANSFER"
                    Return "Transfer"
                Case "ADJUSTMENT"
                    Return "Adjustment"
                Case "RETURN"
                    Return "Return"
                Case Else
                    Return TransactionType
            End Select
        End Get
    End Property

    Public ReadOnly Property TransactionTypeColor As String
        Get
            Select Case TransactionType.ToUpper()
                Case "RECEIPT"
                    Return "Green"
                Case "ISSUE"
                    Return "Red"
                Case "TRANSFER"
                    Return "Blue"
                Case "ADJUSTMENT"
                    Return "Orange"
                Case "RETURN"
                    Return "Purple"
                Case Else
                    Return "Black"
            End Select
        End Get
    End Property

    Public ReadOnly Property IsInbound As Boolean
        Get
            Return TransactionType.ToUpper() = "RECEIPT" OrElse 
                   TransactionType.ToUpper() = "RETURN" OrElse
                   (TransactionType.ToUpper() = "ADJUSTMENT" AndAlso Quantity > 0)
        End Get
    End Property

    Public ReadOnly Property IsOutbound As Boolean
        Get
            Return TransactionType.ToUpper() = "ISSUE" OrElse
                   (TransactionType.ToUpper() = "ADJUSTMENT" AndAlso Quantity < 0)
        End Get
    End Property

    Public ReadOnly Property AbsoluteQuantity As Decimal
        Get
            Return Math.Abs(Quantity)
        End Get
    End Property

    Public ReadOnly Property FormattedQuantity As String
        Get
            Dim sign As String = If(Quantity >= 0, "+", "")
            Return $"{sign}{Quantity:N3}"
        End Get
    End Property

    Public ReadOnly Property ReferenceDisplay As String
        Get
            If Not String.IsNullOrEmpty(ReferenceNumber) Then
                Return $"{ReferenceType}: {ReferenceNumber}"
            ElseIf ReferenceID.HasValue Then
                Return $"{ReferenceType}: {ReferenceID.Value}"
            Else
                Return ReferenceType
            End If
        End Get
    End Property

    Public ReadOnly Property PostingStatus As String
        Get
            Return If(IsPosted, "Posted", "Unposted")
        End Get
    End Property

    Public ReadOnly Property PostingStatusColor As String
        Get
            Return If(IsPosted, "Green", "Orange")
        End Get
    End Property

    Public Function CanBePosted() As Boolean
        Return Not IsPosted AndAlso TotalCost <> 0
    End Function

    Public Function CanBeReversed() As Boolean
        Return IsPosted AndAlso TransactionType.ToUpper() <> "ADJUSTMENT"
    End Function

    Public Sub CalculateTotalCost()
        TotalCost = Math.Abs(Quantity) * UnitCost
    End Sub

    Public Shared Function CreateReceiptTransaction(materialID As Integer, quantity As Decimal, unitCost As Decimal, location As String, referenceType As String, referenceID As Integer?, referenceNumber As String, userID As Integer, Optional branchID As Integer? = Nothing) As InventoryTransaction
        Dim transaction As New InventoryTransaction() With {
            .MaterialID = materialID,
            .BranchID = branchID,
            .Location = location,
            .TransactionType = "Receipt",
            .Quantity = Math.Abs(quantity),
            .UnitCost = unitCost,
            .ReferenceType = referenceType,
            .ReferenceID = referenceID,
            .ReferenceNumber = referenceNumber,
            .CreatedBy = userID
        }
        transaction.CalculateTotalCost()
        Return transaction
    End Function

    Public Shared Function CreateIssueTransaction(materialID As Integer, quantity As Decimal, unitCost As Decimal, location As String, referenceType As String, referenceID As Integer?, referenceNumber As String, userID As Integer, Optional branchID As Integer? = Nothing) As InventoryTransaction
        Dim transaction As New InventoryTransaction() With {
            .MaterialID = materialID,
            .BranchID = branchID,
            .Location = location,
            .TransactionType = "Issue",
            .Quantity = -Math.Abs(quantity),
            .UnitCost = unitCost,
            .ReferenceType = referenceType,
            .ReferenceID = referenceID,
            .ReferenceNumber = referenceNumber,
            .CreatedBy = userID
        }
        transaction.CalculateTotalCost()
        Return transaction
    End Function

    Public Shared Function CreateAdjustmentTransaction(materialID As Integer, quantity As Decimal, unitCost As Decimal, location As String, reason As String, userID As Integer, Optional branchID As Integer? = Nothing) As InventoryTransaction
        Dim transaction As New InventoryTransaction() With {
            .MaterialID = materialID,
            .BranchID = branchID,
            .Location = location,
            .TransactionType = "Adjustment",
            .Quantity = quantity,
            .UnitCost = unitCost,
            .ReferenceType = "ADJ",
            .ReferenceNumber = reason,
            .Notes = reason,
            .CreatedBy = userID
        }
        transaction.CalculateTotalCost()
        Return transaction
    End Function
End Class
