Public Class Branch
        Public Property ID As Integer
        Public Property BranchCode As String
        Public Property BranchName As String
        Public Property Prefix As String
        Public Property Address As String
        Public Property City As String
        Public Property Province As String
        Public Property PostalCode As String
        Public Property Phone As String
        Public Property Email As String
        Public Property ManagerName As String
        Public Property IsActive As Boolean
        Public Property CreatedBy As Integer?
        Public Property CreatedDate As DateTime?
        Public Property ModifiedBy As Integer?
        Public Property ModifiedDate As DateTime?

        Public Sub New()
            ' Default constructor
            IsActive = True
            CreatedDate = DateTime.Now
        End Sub

        Public Sub New(branchCode As String, branchName As String, prefix As String, 
                      isActive As Boolean, createdBy As Integer)
            Me.New()
            Me.BranchCode = branchCode
            Me.BranchName = branchName
            Me.Prefix = prefix
            Me.IsActive = isActive
            Me.CreatedBy = createdBy
        End Sub

        Public Overrides Function ToString() As String
            Return $"{BranchName} ({BranchCode})"
        End Function
End Class