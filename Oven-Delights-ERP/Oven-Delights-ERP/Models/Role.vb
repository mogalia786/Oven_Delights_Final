Imports System.ComponentModel.DataAnnotations

Public Class Role
    Public Property RoleID As Integer ' PK
    Public Property RoleName As String ' Role name (Admin, Stockroom, Manufacturing, Retail, etc)
    Public Property Description As String
    Public Property IsActive As Boolean
    Public Property CreatedDate As DateTime
    Public Property CreatedBy As Integer
    Public Property ModifiedDate As DateTime?
    Public Property ModifiedBy As Integer?

    ' Navigation property for Users
    Public Property Users As List(Of User)

    Public Sub New()
        IsActive = True
        CreatedDate = DateTime.Now
        Users = New List(Of User)()
    End Sub

    Public ReadOnly Property DisplayName As String
        Get
            Return RoleName
        End Get
    End Property
End Class
