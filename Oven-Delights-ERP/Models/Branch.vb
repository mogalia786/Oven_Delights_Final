Public Class Branch
    Public Property ID As Integer
    Public Property BranchCode As String
    Public Property BranchName As String
    Public Property Address As String
    Public Property City As String
    Public Property Province As String
    Public Property PostalCode As String
    Public Property Phone As String
    Public Property Email As String
    Public Property ManagerName As String
    Public Property IsActive As Boolean
    Public Property CreatedDate As DateTime
    Public Property ModifiedDate As DateTime?

    Public Sub New()
        CreatedDate = DateTime.Now
        IsActive = True
    End Sub

    Public Sub New(branchCode As String, branchName As String)
        Me.New()
        Me.BranchCode = branchCode
        Me.BranchName = branchName
    End Sub
End Class
