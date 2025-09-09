Public Class User
    Public Property ID As Integer
    Public Property Username As String
    Public Property Email As String
    Public Property FirstName As String
    Public Property LastName As String
    Public Property Role As String
    Public Property BranchID As Integer
    Public Property BranchName As String
    Public Property BranchCode As String
    Public Property CreatedDate As DateTime
    Public Property LastLogin As DateTime?
    Public Property IsActive As Boolean
    Public Property FailedLoginAttempts As Integer
    Public Property IsLocked As Boolean
    Public Property TwoFactorEnabled As Boolean
    Public Property ProfilePicture As String
    Public Property PhoneNumber As String
    Public Property Department As String
    Public Property JobTitle As String

    Public ReadOnly Property FullName As String
        Get
            Return $"{FirstName} {LastName}".Trim()
        End Get
    End Property

    Public ReadOnly Property DisplayRole As String
        Get
            Select Case Role.ToLower()
                Case "superadmin"
                    Return "Super Administrator"
                Case "branchadmin"
                    Return "Branch Administrator"
                Case "manager"
                    Return "Manager"
                Case "employee"
                    Return "Employee"
                Case Else
                    Return Role
            End Select
        End Get
    End Property

    Public ReadOnly Property RoleLevel As Integer
        Get
            Select Case Role.ToLower()
                Case "superadmin"
                    Return 4
                Case "branchadmin"
                    Return 3
                Case "manager"
                    Return 2
                Case "employee"
                    Return 1
                Case Else
                    Return 0
            End Select
        End Get
    End Property

    Public Function HasPermission(moduleName As String, permissionType As String) As Boolean
        ' Check if user has specific permission for a module
        ' This would typically query the UserPermissions table
        Select Case Role.ToLower()
            Case "superadmin"
                Return True ' Super admin has all permissions
            Case "branchadmin"
                Return permissionType <> "delete" ' Branch admin has most permissions except delete
            Case "manager"
                Return permissionType = "read" OrElse permissionType = "write"
            Case "employee"
                Return permissionType = "read"
            Case Else
                Return False
        End Select
    End Function

    Public Function CanAccessBranch(branchId As Integer) As Boolean
        ' Check if user can access specific branch
        If Role.ToLower() = "superadmin" Then
            Return True ' Super admin can access all branches
        Else
            Return Me.BranchID = branchId ' Others can only access their own branch
        End If
    End Function
End Class

Public Class Branch
    Public Property ID As Integer
    Public Property Name As String
    Public Property Address As String
    Public Property Phone As String
    Public Property Email As String
    Public Property Manager As String
    Public Property IsActive As Boolean
    Public Property CreatedDate As DateTime
    Public Property ModifiedDate As DateTime?
    Public Property ParentBranchID As Integer?
    Public Property BranchCode As String
    Public Property TaxNumber As String
    Public Property RegistrationNumber As String

    Public ReadOnly Property DisplayName As String
        Get
            Return $"{BranchCode} - {Name}"
        End Get
    End Property
End Class

Public Class UserSession
    Public Property ID As Integer
    Public Property UserID As Integer
    Public Property SessionToken As String
    Public Property LoginTime As DateTime
    Public Property LogoutTime As DateTime?
    Public Property IPAddress As String
    Public Property UserAgent As String
    Public Property IsActive As Boolean
    Public Property ExpiryTime As DateTime
    Public Property RefreshToken As String
    Public Property DeviceInfo As String
    Public Property Location As String
    Public Property LastActivity As DateTime

    Public ReadOnly Property SessionDuration As TimeSpan
        Get
            Dim endTime As DateTime = If(LogoutTime.HasValue, LogoutTime.Value, DateTime.Now)
            Return endTime.Subtract(LoginTime)
        End Get
    End Property

    Public ReadOnly Property IsExpired As Boolean
        Get
            Return DateTime.Now > ExpiryTime
        End Get
    End Property
End Class

Public Class AuditLogEntry
    Public Property ID As Long
    Public Property UserID As Integer?
    Public Property Action As String
    Public Property TableName As String
    Public Property RecordID As String
    Public Property OldValues As String
    Public Property NewValues As String
    Public Property Timestamp As DateTime
    Public Property IPAddress As String
    Public Property UserAgent As String
    Public Property SessionID As Integer?
    Public Property ActionType As String
    Public Property Severity As String
    Public Property Description As String
    Public Property ModuleName As String

    Public ReadOnly Property SeverityColor As Color
        Get
            Select Case Severity.ToLower()
                Case "critical"
                    Return Color.FromArgb(220, 53, 69) ' Red
                Case "error"
                    Return Color.FromArgb(255, 193, 7) ' Yellow
                Case "warning"
                    Return Color.FromArgb(255, 193, 7) ' Orange
                Case "info"
                    Return Color.FromArgb(52, 152, 219) ' Blue
                Case Else
                    Return Color.FromArgb(108, 117, 125) ' Gray
            End Select
        End Get
    End Property
End Class

Public Class UserPermission
    Public Property ID As Integer
    Public Property UserID As Integer
    Public Property ModuleName As String
    Public Property PermissionType As String
    Public Property IsGranted As Boolean
    Public Property GrantedBy As Integer
    Public Property GrantedDate As DateTime
    Public Property ExpiryDate As DateTime?

    Public ReadOnly Property IsExpired As Boolean
        Get
            Return ExpiryDate.HasValue AndAlso DateTime.Now > ExpiryDate.Value
        End Get
    End Property
End Class

Public Class SystemSetting
    Public Property ID As Integer
    Public Property SettingKey As String
    Public Property SettingValue As String
    Public Property SettingType As String
    Public Property Category As String
    Public Property Description As String
    Public Property IsEncrypted As Boolean
    Public Property ModifiedBy As Integer?
    Public Property ModifiedDate As DateTime

    Public Function GetTypedValue(Of T)() As T
        Try
            Select Case SettingType.ToLower()
                Case "int", "integer"
                    Return CType(CObj(Integer.Parse(SettingValue)), T)
                Case "bool", "boolean"
                    Return CType(CObj(Boolean.Parse(SettingValue)), T)
                Case "decimal", "double"
                    Return CType(CObj(Decimal.Parse(SettingValue)), T)
                Case "datetime", "date"
                    Return CType(CObj(DateTime.Parse(SettingValue)), T)
                Case Else
                    Return CType(CObj(SettingValue), T)
            End Select
        Catch ex As Exception
            Return Nothing
        End Try
    End Function
End Class

Public Class DashboardStats
    Public Property TotalUsers As Integer
    Public Property ActiveUsers As Integer
    Public Property InactiveUsers As Integer
    Public Property LockedUsers As Integer
    Public Property TotalBranches As Integer
    Public Property ActiveBranches As Integer
    Public Property TotalSessions As Integer
    Public Property ActiveSessions As Integer
    Public Property TodayLogins As Integer
    Public Property WeekLogins As Integer
    Public Property MonthLogins As Integer
    Public Property SecurityAlerts As Integer
    Public Property CriticalAlerts As Integer

    Public ReadOnly Property UserActivityPercentage As Double
        Get
            If TotalUsers = 0 Then Return 0
            Return Math.Round((ActiveUsers / TotalUsers) * 100, 1)
        End Get
    End Property

    Public ReadOnly Property BranchActivityPercentage As Double
        Get
            If TotalBranches = 0 Then Return 0
            Return Math.Round((ActiveBranches / TotalBranches) * 100, 1)
        End Get
    End Property
End Class
