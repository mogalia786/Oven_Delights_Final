Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Data
Imports System.Text
Imports BCrypt.Net
Imports System.Security.Cryptography
Imports System.Diagnostics

''' <summary>
''' Service class for handling user-related operations in the Oven Delights ERP system.
''' </summary>
Public Class UserService
    Implements IDisposable
    
    Private ReadOnly _connectionString As String
    Private ReadOnly _minPasswordLength As Integer = 8
    Private ReadOnly _maxFailedLoginAttempts As Integer = 5
    Private ReadOnly _accountLockoutMinutes As Integer = 30
    Private _disposed As Boolean = False
    Private _connection As SqlConnection = Nothing

    ''' <summary>
    ''' Initializes a new instance of the UserService class using the default connection string
    ''' </summary>
    Public Sub New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub
    
    ''' <summary>
    ''' Initializes a new instance of the UserService class with a custom connection string
    ''' </summary>
    ''' <param name="connectionString">The database connection string to use</param>
    Public Sub New(connectionString As String)
        _connectionString = connectionString
    End Sub

    #Region "Public Methods"

    ''' <summary>
    ''' Retrieves all users from the database with their role and branch information
    ''' </summary>
    ''' <returns>DataTable containing all users with related information</returns>
    Public Function GetAllUsers() As DataTable
        Dim dt As New DataTable()
        
        Using conn As New SqlConnection(_connectionString)
            Try
                conn.Open()
                
                ' Use stored procedure to get all users
                Using cmd As New SqlCommand("sp_User_GetAll", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
                
                ' Format date columns and handle NULL values
                For Each row As DataRow In dt.Rows
                    ' Format dates
                    For Each col As DataColumn In dt.Columns
                        If col.DataType Is GetType(DateTime) AndAlso Not row.IsNull(col) Then
                            row(col) = Convert.ToDateTime(row(col)).ToString("g")
                        End If
                        
                        ' Convert DBNull to appropriate .NET null for nullable fields
                        If row.IsNull(col) Then
                            If col.DataType Is GetType(String) Then
                                row(col) = String.Empty
                            ElseIf col.DataType Is GetType(Boolean) Then
                                row(col) = False
                            End If
                        End If
                    Next
                    
                    ' Set default values for critical fields
                    If row.Table.Columns.Contains("IsActive") AndAlso row.IsNull("IsActive") Then row("IsActive") = True
                    If row.Table.Columns.Contains("TwoFactorEnabled") AndAlso row.IsNull("TwoFactorEnabled") Then row("TwoFactorEnabled") = False
                Next
                
                Return dt
                
            Catch ex As Exception
                ' Log detailed error information
                Dim errorDetails As New StringBuilder()
                errorDetails.AppendLine($"Error in GetAllUsers: {ex.Message}")
                errorDetails.AppendLine($"Stack Trace: {ex.StackTrace}")
                
                ' Log inner exception if it exists
                If ex.InnerException IsNot Nothing Then
                    errorDetails.AppendLine($"Inner Exception: {ex.InnerException.Message}")
                    errorDetails.AppendLine($"Inner Stack Trace: {ex.InnerException.StackTrace}")
                End If
                
                ' Log to debug output
                Debug.WriteLine(errorDetails.ToString())
                
                ' Log to audit log if possible
                Try
                    LogAuditAction(Nothing, "Error", "Users", Nothing, errorDetails.ToString())
                Catch logEx As Exception
                    Debug.WriteLine($"Failed to log audit action: {logEx.Message}")
                End Try
                
                ' Return empty DataTable with error information in ExtendedProperties
                Dim errorTable As New DataTable()
                errorTable.ExtendedProperties.Add("Error", errorDetails.ToString())
                Return errorTable
            End Try
        End Using
    End Function

    ''' <summary>
    ''' Inline SQL version to retrieve all users with RoleName and BranchName, independent of stored procedures.
    ''' </summary>
    Public Function GetAllUsersInline() As DataTable
        Dim dt As New DataTable()
        Using conn As New SqlConnection(_connectionString)
            conn.Open()

            Dim sb As New StringBuilder()
            sb.AppendLine("SELECT u.UserID, u.Username, u.Email, u.FirstName, u.LastName, u.RoleID, u.BranchID,")
            sb.AppendLine("       u.IsActive, u.TwoFactorEnabled, u.CreatedDate, u.LastLogin, u.FailedLoginAttempts, u.LastFailedLogin, u.PasswordLastChanged,")
            sb.AppendLine("       r.RoleName, b.BranchName, b.Prefix AS BranchPrefix")
            sb.AppendLine("FROM Users u")
            sb.AppendLine("LEFT JOIN Roles r ON r.RoleID = u.RoleID")
            sb.AppendLine("LEFT JOIN Branches b ON b.BranchID = u.BranchID")
            sb.AppendLine("ORDER BY r.RoleName, b.BranchName, u.LastName, u.FirstName")

            Using cmd As New SqlCommand(sb.ToString(), conn)
                cmd.CommandType = CommandType.Text
                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    ''' <summary>
    ''' Inline SQL search across common fields.
    ''' </summary>
    Public Function SearchUsersInline(searchTerm As String) As DataTable
        Dim dt As New DataTable()
        Using conn As New SqlConnection(_connectionString)
            conn.Open()

            Dim sb As New StringBuilder()
            sb.AppendLine("SELECT u.UserID, u.Username, u.Email, u.FirstName, u.LastName, u.RoleID, u.BranchID,")
            sb.AppendLine("       u.IsActive, u.TwoFactorEnabled, u.CreatedDate, u.LastLogin, u.FailedLoginAttempts, u.LastFailedLogin, u.PasswordLastChanged,")
            sb.AppendLine("       r.RoleName, b.BranchName, b.Prefix AS BranchPrefix")
            sb.AppendLine("FROM Users u")
            sb.AppendLine("LEFT JOIN Roles r ON r.RoleID = u.RoleID")
            sb.AppendLine("LEFT JOIN Branches b ON b.BranchID = u.BranchID")
            sb.AppendLine("WHERE (u.Username LIKE @q OR u.Email LIKE @q OR u.FirstName LIKE @q OR u.LastName LIKE @q OR r.RoleName LIKE @q OR b.BranchName LIKE @q)")
            sb.AppendLine("ORDER BY r.RoleName, b.BranchName, u.LastName, u.FirstName")

            Using cmd As New SqlCommand(sb.ToString(), conn)
                cmd.CommandType = CommandType.Text
                cmd.Parameters.AddWithValue("@q", "%" & searchTerm & "%")
                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    ''' <summary>
    ''' Inline create user that adapts to schema (PasswordHash or Password only).
    ''' </summary>
    Public Function CreateUserInline(username As String, password As String, email As String, firstName As String, lastName As String, roleID As Integer, branchID As Integer?, isActive As Boolean, Optional twoFactorEnabled As Boolean = False) As Boolean
        If String.IsNullOrWhiteSpace(username) Then Throw New ArgumentException("Username is required.")
        If String.IsNullOrWhiteSpace(password) Then Throw New ArgumentException("Password is required.")
        If password.Length < _minPasswordLength Then Throw New ArgumentException($"Password must be at least {_minPasswordLength} characters.")

        Dim hashed = BCrypt.Net.BCrypt.EnhancedHashPassword(password, 12)
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            ' detect columns
            Dim hasPasswordHash As Boolean
            Using cmdCheck As New SqlCommand("SELECT COUNT(1) FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'PasswordHash'", conn)
                hasPasswordHash = (Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0)
            End Using

            Dim sql As New StringBuilder()
            If hasPasswordHash Then
                sql.AppendLine("INSERT INTO Users (Username, Email, PasswordHash, Password, FirstName, LastName, RoleID, BranchID, IsActive, TwoFactorEnabled)")
                sql.AppendLine("VALUES (@Username, @Email, @PasswordHash, @PasswordPlain, @FirstName, @LastName, @RoleID, @BranchID, @IsActive, @TwoFactorEnabled)")
            Else
                sql.AppendLine("INSERT INTO Users (Username, Email, Password, FirstName, LastName, RoleID, BranchID, IsActive, TwoFactorEnabled)")
                sql.AppendLine("VALUES (@Username, @Email, @PasswordPlain, @FirstName, @LastName, @RoleID, @BranchID, @IsActive, @TwoFactorEnabled)")
            End If

            Using cmd As New SqlCommand(sql.ToString(), conn)
                cmd.Parameters.AddWithValue("@Username", username.Trim())
                cmd.Parameters.AddWithValue("@Email", email.Trim())
                If hasPasswordHash Then cmd.Parameters.AddWithValue("@PasswordHash", hashed)
                cmd.Parameters.AddWithValue("@PasswordPlain", password)
                cmd.Parameters.AddWithValue("@FirstName", firstName.Trim())
                cmd.Parameters.AddWithValue("@LastName", lastName.Trim())
                cmd.Parameters.AddWithValue("@RoleID", roleID)
                cmd.Parameters.AddWithValue("@BranchID", If(branchID.HasValue, branchID.Value, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@IsActive", isActive)
                cmd.Parameters.AddWithValue("@TwoFactorEnabled", twoFactorEnabled)
                Return cmd.ExecuteNonQuery() = 1
            End Using
        End Using
    End Function

    ''' <summary>
    ''' Inline update user basic fields including role/branch and status.
    ''' </summary>
    Public Function UpdateUserInline(userID As Integer, username As String, email As String, firstName As String, lastName As String, roleID As Integer, branchID As Integer?, isActive As Boolean, Optional twoFactorEnabled As Boolean = False) As Boolean
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Dim sql As String = "UPDATE Users SET Username=@Username, Email=@Email, FirstName=@FirstName, LastName=@LastName, RoleID=@RoleID, BranchID=@BranchID, IsActive=@IsActive, TwoFactorEnabled=@TwoFactorEnabled WHERE UserID=@UserID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@UserID", userID)
                cmd.Parameters.AddWithValue("@Username", username.Trim())
                cmd.Parameters.AddWithValue("@Email", email.Trim())
                cmd.Parameters.AddWithValue("@FirstName", firstName.Trim())
                cmd.Parameters.AddWithValue("@LastName", lastName.Trim())
                cmd.Parameters.AddWithValue("@RoleID", roleID)
                cmd.Parameters.AddWithValue("@BranchID", If(branchID.HasValue, branchID.Value, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@IsActive", isActive)
                cmd.Parameters.AddWithValue("@TwoFactorEnabled", twoFactorEnabled)
                Return cmd.ExecuteNonQuery() = 1
            End Using
        End Using
    End Function

    ''' <summary>
    ''' Inline soft delete (deactivate) user.
    ''' </summary>
    Public Function DeleteUserInline(userID As Integer) As Boolean
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using cmd As New SqlCommand("UPDATE Users SET IsActive = 0 WHERE UserID = @UserID", conn)
                cmd.Parameters.AddWithValue("@UserID", userID)
                Return cmd.ExecuteNonQuery() = 1
            End Using
        End Using
    End Function

    ''' <summary>
    ''' Searches for users based on the provided search term across multiple fields
    ''' </summary>
    ''' <param name="searchTerm">The term to search for in username, email, first name, last name, or phone</param>
    ''' <returns>DataTable containing matching users with related information</returns>
    Public Function SearchUsers(searchTerm As String) As DataTable
        If String.IsNullOrWhiteSpace(searchTerm) Then
            Return GetAllUsers()
        End If
        
        Dim dt As New DataTable()
        
        Using conn As New SqlConnection(_connectionString)
            Try
                conn.Open()
                
                ' Use stored procedure for searching users
                Using cmd As New SqlCommand("sp_User_Search", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@SearchTerm", searchTerm)
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                End Using
                
                ' Format date columns and handle NULL values
                For Each row As DataRow In dt.Rows
                    ' Format dates
                    For Each col As DataColumn In dt.Columns
                        If col.DataType Is GetType(DateTime) AndAlso Not row.IsNull(col) Then
                            row(col) = Convert.ToDateTime(row(col)).ToString("g")
                        End If
                        
                        ' Convert DBNull to appropriate .NET null for nullable fields
                        If row.IsNull(col) Then
                            If col.DataType Is GetType(String) Then
                                row(col) = String.Empty
                            ElseIf col.DataType Is GetType(Boolean) Then
                                row(col) = False
                            End If
                        End If
                    Next
                    
                    ' Set default values for critical fields
                    If row.Table.Columns.Contains("IsActive") AndAlso row.IsNull("IsActive") Then row("IsActive") = True
                    If row.Table.Columns.Contains("TwoFactorEnabled") AndAlso row.IsNull("TwoFactorEnabled") Then row("TwoFactorEnabled") = False
                Next
                
                Return dt
                
            Catch ex As Exception
                ' Log the error
                Debug.WriteLine($"Error in SearchUsers: {ex.Message}")
                Debug.WriteLine(ex.StackTrace)
                
                ' Return empty DataTable on error
                Return New DataTable()
            End Try
        End Using
    End Function
    
    ''' <summary>
    ''' Creates a new user account with the specified details
    ''' </summary>
    ''' <param name="username">Unique username for the new user</param>
    ''' <param name="password">Password for the new user (will be hashed)</param>
    ''' <param name="email">User's email address</param>
    ''' <param name="firstName">User's first name</param>
    ''' <param name="lastName">User's last name</param>
    ''' <param name="roleID">ID of the role to assign to the user</param>
    ''' <param name="branchID">Optional ID of the branch the user belongs to</param>
    ''' <param name="isActive">Whether the user account is active</param>
    ''' <param name="twoFactorEnabled">Whether two-factor authentication is enabled</param>
    ''' <param name="phoneNumber">User's phone number (optional)</param>
    ''' <param name="profilePicture">Path to user's profile picture (optional)</param>
    ''' <returns>True if user creation was successful</returns>
    Public Function CreateUser(
        username As String, 
        password As String, 
        email As String, 
        firstName As String, 
        lastName As String, 
        roleID As Integer, 
        branchID As Integer?, 
        isActive As Boolean, 
        Optional twoFactorEnabled As Boolean = False,
        Optional phoneNumber As String = Nothing,
        Optional profilePicture As String = Nothing) As Boolean
        
        ' Input validation
        If String.IsNullOrWhiteSpace(username) Then
            Throw New ArgumentException("Username is required.", NameOf(username))
        End If
        
        If String.IsNullOrWhiteSpace(password) Then
            Throw New ArgumentException("Password is required.", NameOf(password))
        End If
        
        If password.Length < _minPasswordLength Then
            Throw New ArgumentException($"Password must be at least {_minPasswordLength} characters long.", NameOf(password))
        End If
        
        ' Hash the password using bcrypt with work factor of 12
        Dim hashedPassword = BCrypt.Net.BCrypt.EnhancedHashPassword(password, 12)
        
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            
            ' Create command for stored procedure
            Using cmd As New SqlCommand("sp_User_Create", conn)
                cmd.CommandType = CommandType.StoredProcedure
                
                ' Add parameters
                cmd.Parameters.AddWithValue("@Username", username.Trim())
                cmd.Parameters.AddWithValue("@Email", email.Trim())
                cmd.Parameters.AddWithValue("@FirstName", firstName.Trim())
                cmd.Parameters.AddWithValue("@LastName", lastName.Trim())
                cmd.Parameters.AddWithValue("@RoleID", roleID)
                
                ' Handle nullable branchID
                If branchID.HasValue Then
                    cmd.Parameters.AddWithValue("@BranchID", branchID.Value)
                Else
                    cmd.Parameters.AddWithValue("@BranchID", DBNull.Value)
                End If
                
                cmd.Parameters.AddWithValue("@Password", hashedPassword)
                cmd.Parameters.AddWithValue("@IsActive", isActive)
                cmd.Parameters.AddWithValue("@TwoFactorEnabled", twoFactorEnabled)
                
                ' Handle optional parameters
                If Not String.IsNullOrWhiteSpace(phoneNumber) Then
                    cmd.Parameters.AddWithValue("@PhoneNumber", phoneNumber.Trim())
                Else
                    cmd.Parameters.AddWithValue("@PhoneNumber", DBNull.Value)
                End If
                
                If Not String.IsNullOrWhiteSpace(profilePicture) Then
                    cmd.Parameters.AddWithValue("@ProfilePicture", profilePicture.Trim())
                Else
                    cmd.Parameters.AddWithValue("@ProfilePicture", DBNull.Value)
                End If
                
                ' Add output parameter for UserID
                Dim userIdParam = New SqlParameter("@UserID", SqlDbType.Int)
                userIdParam.Direction = ParameterDirection.Output
                cmd.Parameters.Add(userIdParam)
                
                Try
                    ' Execute the stored procedure
                    cmd.ExecuteNonQuery()
                    
                    ' Get the new user ID from the output parameter
                    Dim newUserId As Integer = Convert.ToInt32(userIdParam.Value)
                    
                    ' Log the successful user creation
                    LogAuditAction(newUserId, "Create", "Users", newUserId, 
                                 $"User account created successfully: {username} (ID: {newUserId})")
                    
                    Return True
                    
                Catch ex As SqlException
                    ' Handle SQL-specific exceptions
                    Dim errorMsg = $"SQL Error in CreateUser: {ex.Message}"
                    Debug.WriteLine(errorMsg)
                    LogAuditAction(Nothing, "Error", "Users", Nothing, $"Failed to create user: {errorMsg}")
                    
                    ' Re-throw with a more user-friendly message if needed
                    If ex.Number = 50001 Then ' Username exists
                        Throw New InvalidOperationException("A user with this username already exists.", ex)
                    ElseIf ex.Number = 50002 Then ' Email exists
                        Throw New InvalidOperationException("A user with this email already exists.", ex)
                    Else
                        Throw New Exception("An error occurred while creating the user. Please try again.", ex)
                    End If
                    
                Catch ex As Exception
                    ' Handle other exceptions
                    Debug.WriteLine($"Error in CreateUser: {ex.Message}")
                    LogAuditAction(Nothing, "Error", "Users", Nothing, $"Failed to create user: {ex.Message}")
                    
                    ' Provide more user-friendly error messages for common issues
                    If TypeOf ex Is InvalidOperationException Then
                        Throw ' Re-throw validation exceptions as-is
                    Else
                        Throw New Exception("An error occurred while creating the user account. Please try again.", ex)
                    End If
                End Try
            End Using
        End Using
    End Function
    
    ''' <summary>
    ''' Updates an existing user's information with comprehensive validation and error handling
    ''' </summary>
    ''' <param name="userID">ID of the user to update</param>
    ''' <param name="username">New username</param>
    ''' <param name="email">User's email address</param>
    ''' <param name="firstName">User's first name</param>
    ''' <param name="lastName">User's last name</param>
    ''' <param name="roleID">ID of the role to assign to the user</param>
    ''' <param name="branchID">Optional ID of the branch the user belongs to</param>
    ''' <param name="isActive">Whether the user account is active</param>
    ''' <param name="twoFactorEnabled">Whether two-factor authentication is enabled</param>
    ''' <param name="phoneNumber">User's phone number (optional)</param>
    ''' <param name="profilePicture">Path to user's profile picture (optional)</param>
    ''' <param name="currentUserId">ID of the user performing the update (for audit logging)</param>
    ''' <returns>True if the update was successful</returns>
    Public Function UpdateUser(
        userID As Integer, 
        username As String, 
        email As String, 
        firstName As String, 
        lastName As String, 
        roleID As Integer, 
        branchID As Integer?, 
        isActive As Boolean, 
        Optional twoFactorEnabled As Boolean = False,
        Optional phoneNumber As String = Nothing,
        Optional profilePicture As String = Nothing,
        Optional currentUserId As Integer? = Nothing) As Boolean
        
        ' Input validation
        If userID <= 0 Then
            Throw New ArgumentException("Invalid user ID.", NameOf(userID))
        End If
        
        If String.IsNullOrWhiteSpace(username) Then
            Throw New ArgumentException("Username is required.", NameOf(username))
        End If
        
        If String.IsNullOrWhiteSpace(email) Then
            Throw New ArgumentException("Email is required.", NameOf(email))
        End If
        
        If String.IsNullOrWhiteSpace(firstName) Then
            Throw New ArgumentException("First name is required.", NameOf(firstName))
        End If
        
        If String.IsNullOrWhiteSpace(lastName) Then
            Throw New ArgumentException("Last name is required.", NameOf(lastName))
        End If
        
        ' Clean input
        username = username.Trim()
        email = email.Trim()
        firstName = firstName.Trim()
        lastName = lastName.Trim()
        phoneNumber = phoneNumber?.Trim()
        profilePicture = profilePicture?.Trim()
        
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Get the current user data for audit logging
                Dim originalUserData As New Dictionary(Of String, Object)
                
                ' First, get the current user data for comparison
                Using cmdGet As New SqlCommand("SELECT * FROM Users WHERE UserID = @UserID", conn)
                    cmdGet.CommandType = CommandType.Text
                    cmdGet.Parameters.AddWithValue("@UserID", userID)
                    
                    Using reader = cmdGet.ExecuteReader()
                        If reader.Read() Then
                            For i As Integer = 0 To reader.FieldCount - 1
                                Dim fieldName = reader.GetName(i)
                                originalUserData(fieldName) = If(reader.IsDBNull(i), Nothing, reader(i))
                            Next
                        Else
                            Throw New KeyNotFoundException($"User with ID {userID} not found.")
                        End If
                    End Using
                End Using
                
                ' Now update the user using the stored procedure
                Using cmd As New SqlCommand("sp_User_Update", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    
                    ' Add parameters
                    cmd.Parameters.AddWithValue("@UserID", userID)
                    cmd.Parameters.AddWithValue("@Username", username)
                    cmd.Parameters.AddWithValue("@Email", email)
                    cmd.Parameters.AddWithValue("@FirstName", firstName)
                    cmd.Parameters.AddWithValue("@LastName", lastName)
                    cmd.Parameters.AddWithValue("@RoleID", roleID)
                    cmd.Parameters.AddWithValue("@IsActive", isActive)
                    cmd.Parameters.AddWithValue("@TwoFactorEnabled", twoFactorEnabled)
                    
                    ' Handle nullable branchID
                    If branchID.HasValue Then
                        cmd.Parameters.AddWithValue("@BranchID", branchID.Value)
                    Else
                        cmd.Parameters.AddWithValue("@BranchID", DBNull.Value)
                    End If
                    
                    ' Handle optional parameters
                    If Not String.IsNullOrWhiteSpace(phoneNumber) Then
                        cmd.Parameters.AddWithValue("@PhoneNumber", phoneNumber)
                    Else
                        cmd.Parameters.AddWithValue("@PhoneNumber", DBNull.Value)
                    End If
                    
                    If Not String.IsNullOrWhiteSpace(profilePicture) Then
                        cmd.Parameters.AddWithValue("@ProfilePicture", profilePicture)
                    Else
                        cmd.Parameters.AddWithValue("@ProfilePicture", DBNull.Value)
                    End If
                    
                    ' Add ModifiedBy parameter if provided
                    If currentUserId.HasValue Then
                        cmd.Parameters.AddWithValue("@ModifiedBy", currentUserId.Value)
                    Else
                        cmd.Parameters.AddWithValue("@ModifiedBy", DBNull.Value)
                    End If
                    
                    ' Execute the stored procedure
                    Dim rowsAffected = cmd.ExecuteNonQuery()
                    
                    If rowsAffected = 0 Then
                        Throw New KeyNotFoundException($"User with ID {userID} not found or no changes were made.")
                    End If
                    
                    ' Log the changes for audit
                    Dim changes As New List(Of String)
                    
                    ' Compare and log changes
                    If originalUserData.ContainsKey("Username") AndAlso Convert.ToString(originalUserData("Username")) <> username Then
                        changes.Add($"Username: {originalUserData("Username")} → {username}")
                    End If
                    
                    If originalUserData.ContainsKey("Email") AndAlso Convert.ToString(originalUserData("Email")) <> email Then
                        changes.Add($"Email: {originalUserData("Email")} → {email}")
                    End If
                    
                    If originalUserData.ContainsKey("FirstName") AndAlso Convert.ToString(originalUserData("FirstName")) <> firstName Then
                        changes.Add($"First Name: {originalUserData("FirstName")} → {firstName}")
                    End If
                    
                    If originalUserData.ContainsKey("LastName") AndAlso Convert.ToString(originalUserData("LastName")) <> lastName Then
                        changes.Add($"Last Name: {originalUserData("LastName")} → {lastName}")
                    End If
                    
                    If originalUserData.ContainsKey("RoleID") AndAlso Convert.ToInt32(originalUserData("RoleID")) <> roleID Then
                        changes.Add($"Role: {originalUserData("RoleID")} → {roleID}")
                    End If
                    
                    ' Handle nullable branch comparison
                    Dim currentBranchID As Integer? = Nothing
                    If originalUserData.ContainsKey("BranchID") AndAlso originalUserData("BranchID") IsNot Nothing AndAlso Not IsDBNull(originalUserData("BranchID")) Then
                        currentBranchID = Convert.ToInt32(originalUserData("BranchID"))
                    End If
                    
                    If currentBranchID <> branchID Then
                        changes.Add($"Branch: {currentBranchID} → {branchID}")
                    End If
                    
                    If originalUserData.ContainsKey("IsActive") AndAlso Convert.ToBoolean(originalUserData("IsActive")) <> isActive Then
                        changes.Add($"Status: {originalUserData("IsActive")} → {isActive}")
                    End If
                    
                    If originalUserData.ContainsKey("TwoFactorEnabled") AndAlso Convert.ToBoolean(originalUserData("TwoFactorEnabled")) <> twoFactorEnabled Then
                        changes.Add($"Two-Factor Auth: {originalUserData("TwoFactorEnabled")} → {twoFactorEnabled}")
                    End If
                    
                    ' Log the changes if any
                    If changes.Count > 0 Then
                        Dim changeDetails = $"Updated user {username} (ID: {userID}). Changes: {String.Join("; ", changes)}"
                        LogAuditAction(If(currentUserId, -1), "Update", "Users", userID, changeDetails)
                    End If
                    
                    Return True
                End Using
            End Using
            
        Catch ex As SqlException
            ' Handle SQL-specific exceptions
            Debug.WriteLine($"SQL Error in UpdateUser: {ex.Message}")
            LogAuditAction(If(currentUserId, -1), "Error", "Users", userID, $"SQL error updating user: {ex.Message}")
            
            ' Handle specific SQL errors
            If ex.Number = 50001 Then ' Username exists
                Throw New InvalidOperationException("A user with this username already exists.", ex)
            ElseIf ex.Number = 50002 Then ' Email exists
                Throw New InvalidOperationException("A user with this email already exists.", ex)
            ElseIf ex.Number = 2601 OrElse ex.Number = 2627 Then
                Throw New InvalidOperationException("A user with this username or email already exists.", ex)
            Else
                Throw New Exception("A database error occurred while updating the user. Please try again.", ex)
            End If
            
        Catch ex As KeyNotFoundException
            ' Re-throw with a more specific message
            Debug.WriteLine($"Key not found in UpdateUser: {ex.Message}")
            LogAuditAction(If(currentUserId, -1), "Error", "Users", userID, $"Key not found: {ex.Message}")
            Throw
            
        Catch ex As InvalidOperationException
            ' Re-throw validation exceptions as-is
            Debug.WriteLine($"Validation error in UpdateUser: {ex.Message}")
            LogAuditAction(If(currentUserId, -1), "Error", "Users", userID, $"Validation error: {ex.Message}")
            Throw
            
        Catch ex As Exception
            ' Handle other exceptions
            Debug.WriteLine($"Error in UpdateUser: {ex.Message}")
            LogAuditAction(If(currentUserId, -1), "Error", "Users", userID, $"Failed to update user: {ex.Message}")
            
            ' Re-throw with a user-friendly message
            Throw New Exception("An error occurred while updating the user. Please try again.", ex)
        End Try
    End Function
    
    ''' <summary>
    ''' Deactivates a user by setting IsActive to 0 (soft delete)
    ''' </summary>
    ''' <param name="userID">ID of the user to deactivate</param>
    ''' <param name="currentUserId">ID of the user performing the deactivation (for audit logging)</param>
    ''' <returns>True if deactivation was successful, False if user was not found or already deactivated</returns>
    Public Function DeleteUser(userID As Integer, Optional currentUserId As Integer? = Nothing) As Boolean
        ' Input validation
        If userID <= 0 Then
            Throw New ArgumentException("Invalid user ID.", NameOf(userID))
        End If
        
        Using conn As New SqlConnection(_connectionString)
            Try
                conn.Open()
                
                ' Start a transaction
                Using transaction = conn.BeginTransaction()
                    Try
                        ' First, get the user's current data for audit logging
                        Dim originalUserData As New Dictionary(Of String, Object)
                        Dim getCurrentDataQuery = "SELECT * FROM Users WHERE UserID = @userID"
                        
                        Using cmdGet As New SqlCommand(getCurrentDataQuery, conn, transaction)
                            cmdGet.Parameters.AddWithValue("@userID", userID)
                            
                            Using reader = cmdGet.ExecuteReader()
                                If reader.Read() Then
                                    For i As Integer = 0 To reader.FieldCount - 1
                                        originalUserData(reader.GetName(i)) = If(reader.IsDBNull(i), DBNull.Value, reader(i))
                                    Next
                                End If
                            End Using
                        End Using
                        
                        ' Check if user exists and is currently active
                        If Not originalUserData.Any() Then
                            Throw New InvalidOperationException("User not found.")
                        End If
                        
                        Dim isCurrentlyActive = Convert.ToBoolean(originalUserData("IsActive"))
                        
                        If Not isCurrentlyActive Then
                            ' User is already deactivated, no action needed
                            Return False
                        End If
                        
                        ' Soft delete by setting IsActive to 0
                        Dim query As String = """
                            UPDATE Users 
                            SET 
                                IsActive = 0,
                                ModifiedDate = GETDATE(),
                                ModifiedBy = @modifiedBy
                            WHERE UserID = @userID
                            AND IsActive = 1  -- Only update if currently active
                        """
                        
                        Using cmd As New SqlCommand(query, conn, transaction)
                            cmd.Parameters.AddWithValue("@userID", userID)
                            cmd.Parameters.AddWithValue("@modifiedBy", If(currentUserId.HasValue, currentUserId.Value, DBNull.Value))
                            
                            Dim rowsAffected = cmd.ExecuteNonQuery()
                            
                            If rowsAffected > 0 Then
                                ' Log the deactivation with user details
                                Dim username = Convert.ToString(originalUserData("Username"))
                                Dim deactivatedBy = If(currentUserId.HasValue, $" by user ID {currentUserId}", "")
                                Dim auditMessage = $"User deactivated: {username} (ID: {userID}){deactivatedBy}"
                                
                                LogAuditAction(currentUserId, "UserDeactivated", "Users", userID, auditMessage)
                                transaction.Commit()
                                Return True
                            End If
                            
                            ' No rows affected - user was not active or not found
                            transaction.Rollback()
                            Return False
                        End Using
                        
                    Catch ex As Exception
                        ' Rollback the transaction on error
                        Try
                            transaction.Rollback()
                        Catch rollbackEx As Exception
                            ' Log rollback errors but don't mask the original exception
                            Debug.WriteLine($"Error during transaction rollback: {rollbackEx.Message}")
                        End Try
                        
                        ' Re-throw with additional context if needed
                        If TypeOf ex Is InvalidOperationException Then
                            Throw ' Re-throw validation exceptions as-is
                        ElseIf TypeOf ex Is SqlException Then
                            Dim sqlEx = DirectCast(ex, SqlException)
                            ' Handle specific SQL errors if needed
                            Throw New Exception("A database error occurred while deactivating the user.", sqlEx)
                        End If
                        
                        Throw
                    End Try
                End Using
                
            Catch ex As Exception
                Dim errorMsg = $"Error in DeleteUser: {ex.Message}"
                Debug.WriteLine(errorMsg)
                LogAuditAction(currentUserId, "Error", "Users", userID, $"Failed to deactivate user: {errorMsg}")
                
                ' Provide more user-friendly error messages for common issues
                If TypeOf ex Is ArgumentException OrElse TypeOf ex Is InvalidOperationException Then
                    Throw ' Re-throw validation exceptions as-is
                Else
                    Throw New Exception("An error occurred while deactivating the user. Please try again.", ex)
                End If
            End Try
        End Using
    End Function
    
    ''' <summary>
    ''' Authenticates a user's credentials
    ''' </summary>
    Public Function Authenticate(username As String, password As String) As (IsAuthenticated As Boolean, UserID As Integer, RoleID As Integer, Message As String)
        Using conn As New SqlConnection(_connectionString)
            Try
                conn.Open()
                
                ' Get user by username with proper column names
                Dim query = """
                    SELECT 
                        ID, 
                        Username, 
                        Password, 
                        IsActive, 
                        FailedLoginAttempts, 
                        LastFailedLogin,
                        IsLocked,
                        LockoutEndDate,
                        RoleID,
                        BranchID,
                        FirstName,
                        LastName,
                        Email
                    FROM Users 
                    WHERE Username = @username
                """
                
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@username", username)
                    
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            Dim userId = Convert.ToInt32(reader("ID"))
                            Dim failedAttempts = Convert.ToInt32(reader("FailedLoginAttempts"))
                            Dim lastFailedLogin As DateTime? = If(reader("LastFailedLogin") Is DBNull.Value, 
                                                              DirectCast(Nothing, DateTime?), 
                                                              Convert.ToDateTime(reader("LastFailedLogin")))
                            
                            ' Check if account is locked
                            Dim isLocked = Convert.ToBoolean(reader("IsLocked"))
                            Dim lockoutEndDate As DateTime? = If(reader("LockoutEndDate") Is DBNull.Value, 
                                                              DirectCast(Nothing, DateTime?), 
                                                              Convert.ToDateTime(reader("LockoutEndDate")))
                            
                            ' Log the login attempt
                            LogAuditAction(Nothing, "LoginAttempt", "Users", userId, $"Login attempt for user: {username}")
                            
                            If isLocked AndAlso lockoutEndDate.HasValue AndAlso lockoutEndDate > DateTime.Now Then
                                LogAuditAction(Nothing, "AccountLockedAttempt", "Users", userId, $"Login attempt while account locked until {lockoutEndDate.Value:g}")
                                Return (False, -1, -1, $"Account is locked until {lockoutEndDate.Value:g}. Please try again later.")
                            ElseIf isLocked Then
                                ' Reset lock if lockout period has passed
                                ResetAccountLock(userId)
                            End If
                            
                            ' Check if account is active
                            If Not Convert.ToBoolean(reader("IsActive")) Then
                                LogAuditAction(Nothing, "InactiveAccountAttempt", "Users", userId, "Login attempt to inactive account")
                                Return (False, -1, -1, "Account is inactive. Please contact your administrator.")
                            End If
                            
                            ' Verify password
                            Dim storedHash = reader("Password").ToString()
                            If BCrypt.Net.BCrypt.Verify(password, storedHash) Then
                                ' Log successful authentication
                                LogAuditAction(userId, "LoginSuccess", "Users", userId, "User authenticated successfully")
                                
                                ' Password is correct, reset failed attempts
                                ResetFailedLoginAttempts(userId)
                                
                                ' Update last login
                                UpdateLastLogin(userId)
                                
                                ' Get branch ID (nullable)
                                Dim branchIdObj = reader("BranchID")
                                Dim branchId As Integer? = If(branchIdObj Is DBNull.Value, Nothing, Convert.ToInt32(branchIdObj))
                                
                                Return (True, 
                                       userId, 
                                       Convert.ToInt32(reader("RoleID")), 
                                       "Authentication successful")
                            Else
                                ' Password is incorrect, increment failed attempts
                                Dim newFailedAttempts = failedAttempts + 1
                                
                                ' Log failed attempt
                                LogAuditAction(Nothing, "LoginFailed", "Users", userId, $"Failed login attempt ({newFailedAttempts}/{_maxFailedLoginAttempts})")
                                
                                If newFailedAttempts >= _maxFailedLoginAttempts Then
                                    ' Lock the account
                                    LockUserAccount(userId, DateTime.Now.AddMinutes(_accountLockoutMinutes))
                                    LogAuditAction(Nothing, "AccountAutoLocked", "Users", userId, $"Account locked after {_maxFailedLoginAttempts} failed attempts")
                                    Return (False, -1, -1, "Account has been locked due to too many failed login attempts. Please try again later.")
                                Else
                                    ' Just increment failed attempts
                                    IncrementFailedLoginAttempts(userId, newFailedAttempts)
                                    Dim remainingAttempts = _maxFailedLoginAttempts - newFailedAttempts
                                    Return (False, -1, -1, $"Invalid username or password. {remainingAttempts} attempts remaining.")
                                End If
                            End If
                        Else
                            ' User not found - log the attempt with a placeholder user ID
                            LogAuditAction(Nothing, "LoginFailed", "Users", -1, $"Failed login attempt - user not found: {username}")
                            Return (False, -1, -1, "Invalid username or password.")
                        End If
                    End Using
                End Using
                
            Catch ex As Exception
                Dim errorMsg = $"Error in Authenticate: {ex.Message}"
                Debug.WriteLine(errorMsg)
                LogAuditAction(Nothing, "LoginError", "Users", -1, $"Authentication error: {ex.Message}")
                Throw New Exception("An error occurred during authentication.", ex)
            End Try
        End Using
    End Function
    
    #End Region
    
    #Region "Private Helper Methods"
    
    Private Function UserNameOrEmailExists(conn As SqlConnection, transaction As SqlTransaction, userId As Integer, username As String, email As String) As Boolean
        Dim query = "SELECT COUNT(*) FROM Users WHERE (Username = @Username OR Email = @Email) AND UserID <> @UserID"
        
        Using cmd As New SqlCommand(query, conn, transaction)
            cmd.Parameters.AddWithValue("@Username", username)
            cmd.Parameters.AddWithValue("@Email", email)
            cmd.Parameters.AddWithValue("@UserID", userId)
            
            Dim count = Convert.ToInt32(cmd.ExecuteScalar())
            Return count > 0
        End Using
    End Function
    
    Private Function LockUserAccount(userId As Integer, lockoutEndDate As DateTime) As Boolean
        Using conn As New SqlConnection(_connectionString)
            Dim query = "UPDATE Users SET IsLocked = 1, LockoutEndDate = @LockoutEndDate, FailedLoginAttempts = FailedLoginAttempts + 1, LastFailedLogin = GETDATE() WHERE UserID = @UserID"
            
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@UserID", userId)
                cmd.Parameters.AddWithValue("@LockoutEndDate", lockoutEndDate)
                
                conn.Open()
                Return cmd.ExecuteNonQuery() > 0
            End Using
        End Using
    End Function
    
    Private Function IsPasswordStrong(password As String) As Boolean
        ' Minimum 8 characters, at least one uppercase letter, one lowercase letter, one number and one special character
        Dim pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z\d]).{8,}$"
        Return System.Text.RegularExpressions.Regex.IsMatch(password, pattern)
    End Function
    
    
    ''' <summary>
    ''' Checks if a username or email already exists in the database
    ''' </summary>
    Private Function UserExists(conn As SqlConnection, transaction As SqlTransaction, username As String, email As String) As Boolean
        Dim query = """
            SELECT COUNT(*) 
            FROM Users 
            WHERE Username = @username OR Email = @email
        """
        
        Using cmd As New SqlCommand(query, conn, transaction)
            cmd.Parameters.AddWithValue("@username", username)
            cmd.Parameters.AddWithValue("@email", email)
            
            Dim count = Convert.ToInt32(cmd.ExecuteScalar())
            Return count > 0
        End Using
    End Function
    
    ''' <summary>
    ''' Checks if an account is locked based on failed login attempts
    ''' </summary>
    Private Function IsAccountLocked(failedAttempts As Integer, lastFailedLogin As DateTime?) As Boolean
        If failedAttempts < _maxFailedLoginAttempts Then
            Return False
        End If
        
        ' If we don't have a last failed login time, assume it's locked
        If Not lastFailedLogin.HasValue Then
            Return True
        End If
        
        ' Check if the lockout period has passed
        Dim lockoutEndTime = lastFailedLogin.Value.AddMinutes(_accountLockoutMinutes)
        Return DateTime.Now < lockoutEndTime
    End Function
    
    ''' <summary>
    ''' Resets the failed login attempts counter for a user
    ''' </summary>
    Private Sub ResetFailedLoginAttempts(userID As Integer)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim query = """
                    UPDATE Users 
                    SET 
                        FailedLoginAttempts = 0,
                        LastFailedLogin = NULL
                    WHERE UserID = @userID
                """
                
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@userID", userID)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            Debug.WriteLine($"Error in ResetFailedLoginAttempts: {ex.Message}")
            ' Don't throw, as this is a non-critical operation
        End Try
    End Sub
    
    ''' <summary>
    ''' Increments the failed login attempts counter for a user and updates the last failed login timestamp
    ''' </summary>
    Private Sub IncrementFailedLoginAttempts(userID As Integer, newAttemptCount As Integer)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Start a transaction to ensure atomicity
                Using transaction = conn.BeginTransaction()
                    Try
                        ' Call the stored procedure to update failed login attempts
                        Using cmd As New SqlCommand("sp_User_UpdateFailedLoginAttempts", conn, transaction)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.AddWithValue("@UserID", userID)
                            cmd.Parameters.AddWithValue("@AttemptCount", newAttemptCount)
                            
                            ' Add output parameter to check if account was locked
                            Dim accountLockedParam = cmd.Parameters.Add("@AccountLocked", SqlDbType.Bit)
                            accountLockedParam.Direction = ParameterDirection.Output
                            
                            cmd.ExecuteNonQuery()
                            
                            ' Check if the account was locked by the stored procedure
                            Dim wasLocked = Convert.ToBoolean(accountLockedParam.Value)
                            
                            If wasLocked Then
                                ' Log the account lockout
                                LogAuditAction(userID, "AccountLocked", "Users", userID, 
                                             $"Account locked due to {newAttemptCount} failed login attempts. Lockout expires in {_accountLockoutMinutes} minutes.")
                            End If
                            
                            ' Commit the transaction
                            transaction.Commit()
                        End Using
                        
                    Catch ex As Exception
                        ' Rollback the transaction on error
                        Try
                            transaction.Rollback()
                        Catch rollbackEx As Exception
                            ' Log rollback errors but don't mask the original exception
                            Debug.WriteLine($"Error during transaction rollback: {rollbackEx.Message}")
                        End Try
                        
                        ' Re-throw the original exception
                        Throw
                    End Try
                End Using
            End Using
        Catch ex As Exception
            Debug.WriteLine($"Error in IncrementFailedLoginAttempts: {ex.Message}")
            ' Don't throw, as this is a non-critical operation
        End Try
    End Sub
    
    ''' <summary>
    ''' Updates the last login timestamp for a user
    ''' </summary>
    ''' <summary>
    ''' Updates the last login timestamp for a user and resets failed login attempts
    ''' </summary>
    Private Sub UpdateLastLogin(userID As Integer)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Using cmd As New SqlCommand("sp_User_UpdateLastLogin", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@UserID", userID)
                    cmd.ExecuteNonQuery()
                End Using
                
                ' Log the successful login
                LogAuditAction(userID, "Login", "Users", userID, "User logged in successfully")
            End Using
        Catch ex As Exception
            Debug.WriteLine($"Error in UpdateLastLogin: {ex.Message}")
            ' Don't throw, as this is a non-critical operation
        End Try
    End Sub
    
    ''' <summary>
    ''' Resets a user's password with comprehensive validation and audit logging
    ''' </summary>
    ''' <param name="userID">ID of the user whose password is being reset</param>
    ''' <param name="newPassword">The new password to set</param>
    ''' <param name="currentUserId">ID of the user performing the reset (for audit logging)</param>
    ''' <param name="isAdminReset">Indicates if this is an administrator-initiated password reset</param>
    ''' <returns>True if the password was successfully reset, False otherwise</returns>
    Public Function ResetPassword(userID As Integer, newPassword As String, Optional currentUserId As Integer? = Nothing, Optional isAdminReset As Boolean = False) As Boolean
        ' Input validation
        If userID <= 0 Then
            Throw New ArgumentException("Invalid user ID.", NameOf(userID))
        End If
        
        If String.IsNullOrWhiteSpace(newPassword) Then
            Throw New ArgumentException("New password cannot be empty.", NameOf(newPassword))
        End If
        
        ' Validate password strength
        If Not IsPasswordStrong(newPassword) Then
            Throw New ArgumentException("Password does not meet complexity requirements. " & _
                                     "Passwords must be at least 8 characters long and include " & _
                                     "uppercase letters, lowercase letters, numbers, and special characters.")
        End If
        
        ' Hash the new password
        Dim hashedPassword = BCrypt.Net.BCrypt.HashPassword(newPassword)
        
        Using conn As New SqlConnection(_connectionString)
            Try
                conn.Open()
                
                ' Start a transaction
                Using transaction = conn.BeginTransaction()
                    Try
                        ' Get the user's current data for audit logging
                        Dim originalUserData As New Dictionary(Of String, Object)
                        
                        Using cmdGet As New SqlCommand("sp_User_GetByID", conn, transaction)
                            cmdGet.CommandType = CommandType.StoredProcedure
                            cmdGet.Parameters.AddWithValue("@UserID", userID)
                            
                            Using reader = cmdGet.ExecuteReader()
                                If reader.Read() Then
                                    For i As Integer = 0 To reader.FieldCount - 1
                                        originalUserData(reader.GetName(i)) = If(reader.IsDBNull(i), DBNull.Value, reader(i))
                                    Next
                                Else
                                    Throw New InvalidOperationException("User not found.")
                                End If
                            End Using
                        End Using
                        
                        ' Check if the account is locked
                        If Convert.ToBoolean(originalUserData("IsLocked")) Then
                            Throw New InvalidOperationException("Cannot reset password for a locked account. Please unlock the account first.")
                        End If
                        
                        ' Call the stored procedure to reset the password
                        Using cmd As New SqlCommand("sp_User_ResetPassword", conn, transaction)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.AddWithValue("@UserID", userID)
                            cmd.Parameters.AddWithValue("@NewPassword", hashedPassword)
                            cmd.Parameters.AddWithValue("@ModifiedBy", If(currentUserId.HasValue, currentUserId.Value, DBNull.Value))
                            
                            ' Add output parameter for success status
                            Dim successParam = cmd.Parameters.Add("@Success", SqlDbType.Bit)
                            successParam.Direction = ParameterDirection.Output
                            
                            cmd.ExecuteNonQuery()
                            
                            Dim success = Convert.ToBoolean(successParam.Value)
                            
                            If success Then
                                ' Log the password reset with details
                                Dim resetBy = If(currentUserId.HasValue, $" by user ID {currentUserId}", "")
                                Dim resetType = If(isAdminReset, "admin-initiated", "user-initiated")
                                Dim lastChanged = If(originalUserData("PasswordLastChanged") Is DBNull.Value, 
                                                   "never", 
                                                   $"last changed on {Convert.ToDateTime(originalUserData("PasswordLastChanged")):g}")
                                
                                Dim auditMessage = $"Password reset for user {originalUserData("Username")} (ID: {userID}){resetBy}. " & _
                                                 $"Password was {lastChanged}. Reset type: {resetType}."
                                
                                LogAuditAction(currentUserId, "PasswordReset", "Users", userID, auditMessage)
                                
                                ' Commit the transaction
                                transaction.Commit()
                                Return True
                            Else
                                ' No rows affected - user not found or no changes made
                                transaction.Rollback()
                                Return False
                            End If
                        End Using
                        
                    Catch ex As Exception
                        ' Rollback the transaction on error
                        Try
                            transaction.Rollback()
                        Catch rollbackEx As Exception
                            ' Log rollback errors but don't mask the original exception
                            Debug.WriteLine($"Error during transaction rollback: {rollbackEx.Message}")
                        End Try
                        
                        ' Re-throw with additional context if needed
                        If TypeOf ex Is SqlException Then
                            Dim sqlEx = DirectCast(ex, SqlException)
                            ' Handle specific SQL errors if needed
                            If sqlEx.Number = 547 Then  ' FK constraint violation
                                Throw New InvalidOperationException("Invalid user or related data.", sqlEx)
                            End If
                            Throw New Exception("A database error occurred while resetting the password.", sqlEx)
                        ElseIf TypeOf ex Is ArgumentException OrElse TypeOf ex Is InvalidOperationException Then
                            Throw ' Re-throw validation exceptions as-is
                        End If
                        
                        Throw
                    End Try
                End Using
                
            Catch ex As Exception
                Dim errorMsg = $"Error in ResetPassword: {ex.Message}"
                Debug.WriteLine(errorMsg)
                LogAuditAction(currentUserId, "Error", "Users", userID, $"Failed to reset password: {errorMsg}")
                
                ' Provide more user-friendly error messages for common issues
                If TypeOf ex Is ArgumentException OrElse TypeOf ex Is InvalidOperationException Then
                    Throw ' Re-throw validation exceptions as-is
                Else
                    Throw New Exception("An error occurred while resetting the password. Please try again.", ex)
                End If
            End Try
        End Using
    End Function
    
    ''' <summary>
    ''' Resets the account lock for a user by setting IsLocked to 0 and clearing LockoutEndDate
    ''' </summary>
    ''' <summary>
    ''' Resets the lock on a user account
    ''' </summary>
    ''' <param name="userID">ID of the user to unlock</param>
    ''' <param name="currentUserId">ID of the user performing the unlock (for audit logging)</param>
    ''' <returns>True if the account was successfully unlocked, False if no changes were made</returns>
    Public Function ResetAccountLock(userID As Integer, Optional currentUserId As Integer? = Nothing) As Boolean
        ' Input validation
        If userID <= 0 Then
            Throw New ArgumentException("Invalid user ID.", NameOf(userID))
        End If
        
        Using conn As New SqlConnection(_connectionString)
            Try
                conn.Open()
                
                ' Start a transaction
                Using transaction = conn.BeginTransaction()
                    Try
                        ' First, get the user's current lock status for audit logging
                        Dim originalIsLocked As Boolean = False
                        Dim originalLockoutEndDate As DateTime? = Nothing
                        Dim username As String = String.Empty
                        
                        ' Get current lock status using stored procedure
                        Using cmdGet As New SqlCommand("sp_User_GetByID", conn, transaction)
                            cmdGet.CommandType = CommandType.StoredProcedure
                            cmdGet.Parameters.AddWithValue("@UserID", userID)
                            
                            Using reader = cmdGet.ExecuteReader()
                                If reader.Read() Then
                                    username = reader("Username").ToString()
                                    originalIsLocked = Convert.ToBoolean(reader("IsLocked"))
                                    originalLockoutEndDate = If(reader("LockoutEndDate") Is DBNull.Value, 
                                                              DirectCast(Nothing, DateTime?), 
                                                              Convert.ToDateTime(reader("LockoutEndDate")))
                                Else
                                    Throw New InvalidOperationException("User not found.")
                                End If
                            End Using
                        End Using
                        
                        ' If account is not locked, nothing to do
                        If Not originalIsLocked AndAlso (Not originalLockoutEndDate.HasValue OrElse originalLockoutEndDate.Value <= DateTime.UtcNow) Then
                            Debug.WriteLine("Account is not locked. No action taken.")
                            transaction.Commit()
                            Return True
                        End If
                        
                        ' Call the stored procedure to reset the account lock
                        Using cmd As New SqlCommand("sp_User_ResetAccountLock", conn, transaction)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.AddWithValue("@UserID", userID)
                            cmd.Parameters.AddWithValue("@ModifiedBy", If(currentUserId.HasValue, currentUserId.Value, DBNull.Value))
                            
                            ' Add output parameter for success status
                            Dim successParam = cmd.Parameters.Add("@Success", SqlDbType.Bit)
                            successParam.Direction = ParameterDirection.Output
                            
                            ' Add output parameter for rows affected
                            Dim rowsAffectedParam = cmd.Parameters.Add("@RowsAffected", SqlDbType.Int)
                            rowsAffectedParam.Direction = ParameterDirection.Output
                            
                            cmd.ExecuteNonQuery()
                            
                            Dim success = Convert.ToBoolean(successParam.Value)
                            Dim rowsAffected = Convert.ToInt32(rowsAffectedParam.Value)
                            
                            If success AndAlso rowsAffected > 0 Then
                                ' Log the unlock action
                                Dim lockoutInfo = If(originalLockoutEndDate.HasValue, 
                                                  $" (was locked until {originalLockoutEndDate.Value:g} UTC)", 
                                                  " (was locked)")
                                
                                Dim auditMessage = $"Account unlocked for user {username} (ID: {userID}){lockoutInfo}"
                                LogAuditAction(currentUserId, "AccountUnlocked", "Users", userID, auditMessage)
                                
                                ' Commit the transaction
                                transaction.Commit()
                                Return True
                            Else
                                ' No rows affected - user not found or no changes made
                                transaction.Rollback()
                                Return False
                            End If
                        End Using
                        
                    Catch ex As Exception
                        ' Rollback the transaction on error
                        Try
                            transaction.Rollback()
                        Catch rollbackEx As Exception
                            ' Log rollback errors but don't mask the original exception
                            Debug.WriteLine($"Error during transaction rollback: {rollbackEx.Message}")
                        End Try
                        
                        ' Re-throw with additional context if needed
                        If TypeOf ex Is SqlException Then
                            Dim sqlEx = DirectCast(ex, SqlException)
                            ' Handle specific SQL errors if needed
                            If sqlEx.Number = 547 Then  ' FK constraint violation
                                Throw New InvalidOperationException("Invalid user or related data.", sqlEx)
                            End If
                            Throw New Exception("A database error occurred while unlocking the account.", sqlEx)
                        End If
                        
                        Throw
                    End Try
                End Using
                
            Catch ex As Exception
                Dim errorMsg = $"Error in ResetAccountLock: {ex.Message}"
                Debug.WriteLine(errorMsg)
                LogAuditAction(currentUserId, "Error", "Users", userID, $"Failed to unlock account: {errorMsg}")
                
                ' Provide more user-friendly error messages for common issues
                If TypeOf ex Is ArgumentException OrElse TypeOf ex Is InvalidOperationException Then
                    Throw ' Re-throw validation exceptions as-is
                Else
                    Throw New Exception("An error occurred while unlocking the account. Please try again.", ex)
                End If
            End Try
        End Using
    End Function
    
    ''' <summary>
    ''' Logs an audit action to the database
    ''' </summary>
    ''' <param name="userID">ID of the user performing the action (nullable)</param>
    ''' <param name="action">The action being performed (e.g., Create, Update, Delete)</param>
    ''' <param name="tableName">Name of the table being affected</param>
    ''' <param name="recordID">ID of the record being affected (nullable)</param>
    ''' <param name="details">Additional details about the action</param>
    ''' <param name="oldValues">JSON string of old values (for updates/deletes)</param>
    ''' <param name="newValues">JSON string of new values (for creates/updates)</param>
    ''' <param name="ipAddress">IP address of the client (optional)</param>
    Private Sub LogAuditAction(userID As Integer?, action As String, tableName As String, 
                             recordID As Integer?, details As String, 
                             Optional oldValues As String = Nothing, 
                             Optional newValues As String = Nothing,
                             Optional ipAddress As String = Nothing)
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                Dim query = """
                    INSERT INTO AuditLog (
                        UserID, 
                        Action, 
                        TableName, 
                        RecordID, 
                        OldValues,
                        NewValues,
                        Details, 
                        Timestamp,
                        IPAddress
                    ) VALUES (
                        @userID, 
                        @action, 
                        @tableName, 
                        @recordID, 
                        @oldValues,
                        @newValues,
                        @details, 
                        GETDATE(),
                        @ipAddress
                    )
                """
                
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@userID", If(userID.HasValue, userID.Value, DBNull.Value))
                    cmd.Parameters.AddWithValue("@action", action)
                    cmd.Parameters.AddWithValue("@tableName", tableName)
                    cmd.Parameters.AddWithValue("@recordID", If(recordID.HasValue, recordID.Value, DBNull.Value))
                    cmd.Parameters.AddWithValue("@oldValues", If(String.IsNullOrEmpty(oldValues), DBNull.Value, oldValues))
                    cmd.Parameters.AddWithValue("@newValues", If(String.IsNullOrEmpty(newValues), DBNull.Value, newValues))
                    cmd.Parameters.AddWithValue("@details", If(String.IsNullOrEmpty(details), DBNull.Value, details))
                    cmd.Parameters.AddWithValue("@ipAddress", If(String.IsNullOrEmpty(ipAddress), DBNull.Value, ipAddress))
                    
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            Debug.WriteLine($"Error in LogAuditAction: {ex.Message}")
            ' Don't throw, as we don't want to interrupt the main operation
        End Try
    End Sub
    
    #End Region
    
    #Region "IDisposable Implementation"
    
    Protected Overridable Sub Dispose(disposing As Boolean)
        If Not _disposed Then
            If disposing Then
                ' Dispose managed resources
                If _connection IsNot Nothing Then
                    _connection.Dispose()
                    _connection = Nothing
                End If
            End If
            
            _disposed = True
        End If
    End Sub
    
    Public Sub Dispose() Implements IDisposable.Dispose
        Dispose(True)
        GC.SuppressFinalize(Me)
    End Sub
    
    Protected Overrides Sub Finalize()
        Dispose(False)
    End Sub
    
    #End Region
    
End Class
