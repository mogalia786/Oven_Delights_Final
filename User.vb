Imports System.ComponentModel.DataAnnotations
Imports Oven_Delights_ERP.Models
    ' Navigation properties
Public Class User
    Public Property UserID As Integer
    
    <Required(ErrorMessage:="Username is required")>
    <StringLength(50, ErrorMessage:="Username cannot exceed 50 characters")>
    Public Property Username As String
    
    <Required(ErrorMessage:="Email is required")>
    Public Property Email As String
    
    Public Property PasswordHash As String
    
    <Required(ErrorMessage:="First name is required")>
    <StringLength(50, ErrorMessage:="First name cannot exceed 50 characters")>
    Public Property FirstName As String
    
    <Required(ErrorMessage:="Last name is required")>
    <StringLength(50, ErrorMessage:="Last name cannot exceed 50 characters")>
    Public Property LastName As String
    
    <StringLength(20, ErrorMessage:="Phone number cannot exceed 20 characters")>
    Public Property Phone As String
    
    Public Property IsActive As Boolean
    
    <Required(ErrorMessage:="Role is required")>
    Public Property RoleID As Integer ' FK to Roles table, integer
    
    Public Property BranchID As Integer?
    Public Property CreatedDate As DateTime
    Public Property CreatedBy As Integer
    Public Property ModifiedDate As DateTime?
    Public Property ModifiedBy As Integer?
    Public Property LastLogin As DateTime?
    Public Property FailedLoginAttempts As Integer
    Public Property IsLocked As Boolean
    Public Property LockoutEndDate As DateTime?
    
    <StringLength(255, ErrorMessage:="Profile picture path cannot exceed 255 characters")>
    Public Property ProfilePicture As String
    
    Public Property TwoFactorEnabled As Boolean
    
    <StringLength(100, ErrorMessage:="Two factor secret cannot exceed 100 characters")>
    Public Property TwoFactorSecret As String
    
    Public Property EmailVerified As Boolean
    Public Property PhoneVerified As Boolean
    
    ' Navigation properties
    ' Navigation property for Role
    ' Role navigation property removed for schema alignment
    ' Navigation property for Branch
    Public Property Branch As Branch
    
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
