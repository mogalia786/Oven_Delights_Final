Imports System.ComponentModel.DataAnnotations

Public Class RawMaterial
    Public Property ID As Integer
    Public Property MaterialCode As String
    Public Property Name As String
    Public Property Description As String
    Public Property Category As String
    Public Property UnitOfMeasure As String
    Public Property ReorderLevel As Decimal
    Public Property ReorderQuantity As Decimal
    Public Property StandardCost As Decimal
    Public Property LastPurchaseCost As Decimal?
    Public Property AverageCost As Decimal
    Public Property CostingMethod As String
    Public Property ShelfLifeDays As Integer?
    Public Property PreferredSupplierID As Integer?
    Public Property IsActive As Boolean
    Public Property IsPerishable As Boolean
    Public Property CreatedDate As DateTime
    Public Property CreatedBy As Integer
    Public Property ModifiedDate As DateTime?
    Public Property ModifiedBy As Integer?
    Public Property InventoryAccountID As Integer?
    Public Property COGSAccountID As Integer?
    Public Property VarianceAccountID As Integer?

    ' Navigation properties
    ' Navigation properties for foreign keys
    Public Property PreferredSupplier As Supplier
    Public Property CreatedByUser As User
    Public Property ModifiedByUser As User
    Public Property PurchaseOrderItems As List(Of PurchaseOrderItem)
    Public Property InventoryRecords As List(Of Inventory)
    Public Property InventoryTransactions As List(Of InventoryTransaction)

    Public Sub New()
        IsActive = True
        IsPerishable = False
        CostingMethod = "FIFO"
        StandardCost = 0
        AverageCost = 0
        ReorderLevel = 0
        ReorderQuantity = 0
        CreatedDate = DateTime.Now
        PurchaseOrderItems = New List(Of PurchaseOrderItem)()
        InventoryRecords = New List(Of Inventory)()
        InventoryTransactions = New List(Of InventoryTransaction)()
    End Sub

    Public ReadOnly Property DisplayName As String
        Get
            Return $"{MaterialCode} - {Name}"
        End Get
    End Property

    Public ReadOnly Property StatusText As String
        Get
            Return If(IsActive, "Active", "Inactive")
        End Get
    End Property

    Public ReadOnly Property PerishableText As String
        Get
            Return If(IsPerishable, "Perishable", "Non-Perishable")
        End Get
    End Property

    Public ReadOnly Property ShelfLifeText As String
        Get
            If ShelfLifeDays.HasValue Then
                Return $"{ShelfLifeDays.Value} days"
            End If
            Return "N/A"
        End Get
    End Property

    Public ReadOnly Property CostSummary As String
        Get
            Return $"Std: R{StandardCost:F2} | Avg: R{AverageCost:F2} | Last: R{If(LastPurchaseCost, 0):F2}"
        End Get
    End Property

    Public Function GetCurrentStockLevel(Optional branchID As Integer? = Nothing) As Decimal
        If InventoryRecords IsNot Nothing Then
            Dim query = InventoryRecords.Where(Function(i) i.IsActive)
            If branchID.HasValue Then
                query = query.Where(Function(i) i.BranchID = branchID.Value)
            End If
            Return query.Sum(Function(i) i.QuantityOnHand)
        End If
        Return 0
    End Function

    Public Function IsReorderRequired(Optional branchID As Integer? = Nothing) As Boolean
        Return GetCurrentStockLevel(branchID) <= ReorderLevel
    End Function
End Class
