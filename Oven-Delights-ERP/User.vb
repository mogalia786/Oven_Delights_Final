Public Class User
    Public Property UserID As Integer
    Public Property Username As String
    Public Property Email As String
    Public Property PasswordHash As String
    Public Property FirstName As String
    Public Property LastName As String
    Public Property Phone As String
    Public Property IsActive As Boolean
    Public Property Role As String
    Public Property BranchID As Integer?
    Public Property CreatedDate As DateTime
    Public Property CreatedBy As Integer
    Public Property ModifiedDate As DateTime?
    Public Property ModifiedBy As Integer?
    Public Property LastLoginDate As DateTime?
    Public Property FailedLoginAttempts As Integer
    Public Property IsLocked As Boolean
    Public Property LockoutEndDate As DateTime?
    Public Property ProfilePicture As String
    Public Property TwoFactorEnabled As Boolean
    Public Property TwoFactorSecret As String
    Public Property EmailVerified As Boolean
    Public Property PhoneVerified As Boolean
    
    ' Navigation properties
    Public Property RoleName As String
    Public Property BranchName As String
    
    Public Sub New()
        ' Default constructor
        IsActive = True
        CreatedDate = DateTime.Now
        FailedLoginAttempts = 0
        IsLocked = False
        TwoFactorEnabled = False
        EmailVerified = False
        PhoneVerified = False
    End Sub
    
    Public Sub New(userID As Integer)
        Me.New()
        Me.UserID = userID
    End Sub
    
    Public ReadOnly Property FullName As String
        Get
            Return $"{FirstName} {LastName}".Trim()
        End Get
    End Property
    
    Public ReadOnly Property DisplayName As String
        Get
            If Not String.IsNullOrEmpty(FullName) Then
                Return FullName
            Else
                Return Username
            End If
        End Get
    End Property
End Class
