Imports System.ComponentModel.DataAnnotations

Public Class Supplier
    Public Property ID As Integer
    Public Property SupplierCode As String
    Public Property Name As String
    Public Property ContactPerson As String
    Public Property Email As String
    Public Property Phone As String
    Public Property AddressLine1 As String
    Public Property City As String
    Public Property Province As String
    Public Property PostalCode As String
    Public Property PaymentTerms As Integer
    Public Property CreditLimit As Decimal
    Public Property TaxNumber As String
    Public Property IsActive As Boolean
    Public Property Rating As Integer?
    Public Property Notes As String
    Public Property CreatedDate As DateTime
    Public Property CreatedBy As Integer
    Public Property ModifiedDate As DateTime?
    Public Property ModifiedBy As Integer?
    Public Property AccountsPayableAccountID As Integer?
    Public Property DefaultExpenseAccountID As Integer?

    ' Navigation properties
    Public Property CreatedByUser As User
    Public Property ModifiedByUser As User
    Public Property PurchaseOrders As List(Of PurchaseOrder)
    Public Property RawMaterials As List(Of RawMaterial)

    Public Sub New()
        IsActive = True
        PaymentTerms = 30
        CreditLimit = 0
        CreatedDate = DateTime.Now
        PurchaseOrders = New List(Of PurchaseOrder)()
        RawMaterials = New List(Of RawMaterial)()
    End Sub

    Public ReadOnly Property DisplayName As String
        Get
            Return $"{SupplierCode} - {Name}"
        End Get
    End Property

    Public ReadOnly Property FullAddress As String
        Get
            Dim address As New List(Of String)
            If Not String.IsNullOrEmpty(AddressLine1) Then address.Add(AddressLine1)
            If Not String.IsNullOrEmpty(City) Then address.Add(City)
            If Not String.IsNullOrEmpty(Province) Then address.Add(Province)
            If Not String.IsNullOrEmpty(PostalCode) Then address.Add(PostalCode)
            Return String.Join(", ", address)
        End Get
    End Property

    Public ReadOnly Property StatusText As String
        Get
            Return If(IsActive, "Active", "Inactive")
        End Get
    End Property

    Public ReadOnly Property RatingStars As String
        Get
            If Rating.HasValue Then
                Return New String("★"c, Rating.Value) & New String("☆"c, 5 - Rating.Value)
            End If
            Return "Not Rated"
        End Get
    End Property
End Class
