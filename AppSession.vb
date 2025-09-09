' Centralized global session context for the currently authenticated user
' GOLDEN RULE: Only use where needed. Prefer passing explicit parameters in new code unless global access is required.

Public Module AppSession
    ' Core user info
    Public Property CurrentUser As User
    Public Property CurrentUserID As Integer
    Public Property CurrentUsername As String

    ' Role info
    Public Property CurrentRoleID As Integer
    Public Property CurrentRoleName As String

    ' Branch info
    Public Property CurrentBranchID As Integer
    Public Property CurrentBranchName As String
    Public Property CurrentBranchPrefix As String
    Public Property CurrentBranchAddress As String

    ' Convenience initializer (optional to use from login)
    Public Sub InitializeFromUser(user As User, Optional roleName As String = Nothing, Optional branchName As String = Nothing, Optional branchPrefix As String = Nothing, Optional branchAddress As String = Nothing)
        CurrentUser = user
        If user IsNot Nothing Then
            CurrentUserID = user.UserID
            CurrentUsername = user.Username
            CurrentRoleID = user.RoleID
            CurrentBranchID = If(user.BranchID.HasValue, user.BranchID.Value, 0)
        Else
            CurrentUserID = 0
            CurrentUsername = Nothing
            CurrentRoleID = 0
            CurrentBranchID = 0
        End If

        If roleName IsNot Nothing Then CurrentRoleName = roleName
        If branchName IsNot Nothing Then CurrentBranchName = branchName
        If branchPrefix IsNot Nothing Then CurrentBranchPrefix = branchPrefix
        If branchAddress IsNot Nothing Then CurrentBranchAddress = branchAddress
    End Sub

    ' Simple reset method to clear session on logout
    Public Sub Reset()
        CurrentUser = Nothing
        CurrentUserID = 0
        CurrentUsername = Nothing
        CurrentRoleID = 0
        CurrentRoleName = Nothing
        CurrentBranchID = 0
        CurrentBranchName = Nothing
        CurrentBranchPrefix = Nothing
        CurrentBranchAddress = Nothing
    End Sub
End Module
