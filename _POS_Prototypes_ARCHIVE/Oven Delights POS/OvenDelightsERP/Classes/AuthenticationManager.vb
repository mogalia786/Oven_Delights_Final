Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text
Imports BCrypt.Net
Imports System.IdentityModel.Tokens.Jwt
Imports Microsoft.IdentityModel.Tokens
Imports System.Security.Claims

Public Class AuthenticationManager
    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERP").ConnectionString
    Private ReadOnly jwtSecret As String = "OvenDelights_JWT_Secret_Key_2025_Super_Secure"
    Private ReadOnly tokenExpiryHours As Integer = 8

    Public Function AuthenticateUser(username As String, password As String) As LoginResult
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                ' Get user details with branch information
                Dim query As String = "
                    SELECT u.ID, u.Username, u.PasswordHash, u.Salt, u.FirstName, u.LastName, 
                           u.Email, u.Role, u.BranchID, u.IsActive, u.IsLocked, u.LockoutEnd,
                           u.FailedLoginAttempts, u.TwoFactorEnabled, u.TwoFactorSecret,
                           b.Name AS BranchName, b.BranchCode
                    FROM Users u
                    INNER JOIN Branches b ON u.BranchID = b.ID
                    WHERE u.Username = @Username AND u.IsActive = 1"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@Username", username)
                    
                    Using reader As SqlDataReader = command.ExecuteReader()
                        If reader.Read() Then
                            ' Check if account is locked
                            If CBool(reader("IsLocked")) Then
                                Dim lockoutEnd As DateTime? = If(IsDBNull(reader("LockoutEnd")), Nothing, CDate(reader("LockoutEnd")))
                                If lockoutEnd.HasValue AndAlso lockoutEnd.Value > DateTime.Now Then
                                    Return New LoginResult With {
                                        .IsSuccess = False,
                                        .ErrorMessage = $"Account is locked until {lockoutEnd.Value:yyyy-MM-dd HH:mm}"
                                    }
                                Else
                                    ' Unlock account if lockout period has expired
                                    UnlockUserAccount(CInt(reader("ID")))
                                End If
                            End If
                            
                            ' Verify password
                            Dim storedHash As String = reader("PasswordHash").ToString()
                            If BCrypt.Net.BCrypt.Verify(password, storedHash) Then
                                ' Create user object
                                Dim user As New User With {
                                    .ID = CInt(reader("ID")),
                                    .Username = reader("Username").ToString(),
                                    .FirstName = reader("FirstName").ToString(),
                                    .LastName = reader("LastName").ToString(),
                                    .Email = reader("Email").ToString(),
                                    .Role = reader("Role").ToString(),
                                    .BranchID = CInt(reader("BranchID")),
                                    .BranchName = reader("BranchName").ToString(),
                                    .BranchCode = reader("BranchCode").ToString(),
                                    .TwoFactorEnabled = CBool(reader("TwoFactorEnabled"))
                                }
                                
                                reader.Close()
                                
                                ' Reset failed login attempts
                                ResetFailedLoginAttempts(user.ID)
                                
                                ' Update last login
                                UpdateLastLogin(user.ID)
                                
                                ' Create session
                                Dim sessionToken As String = CreateUserSession(user.ID)
                                
                                ' Generate JWT token
                                Dim jwtToken As String = GenerateJWTToken(user)
                                
                                Return New LoginResult With {
                                    .IsSuccess = True,
                                    .User = user,
                                    .SessionToken = sessionToken,
                                    .JWTToken = jwtToken
                                }
                            Else
                                reader.Close()
                                ' Increment failed login attempts
                                IncrementFailedLoginAttempts(username)
                                
                                Return New LoginResult With {
                                    .IsSuccess = False,
                                    .ErrorMessage = "Invalid username or password"
                                }
                            End If
                        Else
                            Return New LoginResult With {
                                .IsSuccess = False,
                                .ErrorMessage = "Invalid username or password"
                            }
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Return New LoginResult With {
                .IsSuccess = False,
                .ErrorMessage = $"Authentication error: {ex.Message}"
            }
        End Try
    End Function

    Private Sub IncrementFailedLoginAttempts(username As String)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "
                    UPDATE Users 
                    SET FailedLoginAttempts = FailedLoginAttempts + 1,
                        LastFailedLogin = GETDATE(),
                        IsLocked = CASE WHEN FailedLoginAttempts + 1 >= 5 THEN 1 ELSE 0 END,
                        LockoutEnd = CASE WHEN FailedLoginAttempts + 1 >= 5 THEN DATEADD(MINUTE, 15, GETDATE()) ELSE NULL END
                    WHERE Username = @Username"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@Username", username)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            ' Log error but don't throw
            Console.WriteLine($"Error incrementing failed login attempts: {ex.Message}")
        End Try
    End Sub

    Private Sub ResetFailedLoginAttempts(userId As Integer)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "
                    UPDATE Users 
                    SET FailedLoginAttempts = 0,
                        LastFailedLogin = NULL,
                        IsLocked = 0,
                        LockoutEnd = NULL
                    WHERE ID = @UserID"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@UserID", userId)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error resetting failed login attempts: {ex.Message}")
        End Try
    End Sub

    Private Sub UnlockUserAccount(userId As Integer)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "
                    UPDATE Users 
                    SET IsLocked = 0,
                        LockoutEnd = NULL,
                        FailedLoginAttempts = 0
                    WHERE ID = @UserID"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@UserID", userId)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error unlocking user account: {ex.Message}")
        End Try
    End Sub

    Private Sub UpdateLastLogin(userId As Integer)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "UPDATE Users SET LastLogin = GETDATE() WHERE ID = @UserID"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@UserID", userId)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error updating last login: {ex.Message}")
        End Try
    End Sub

    Private Function CreateUserSession(userId As Integer) As String
        Try
            Dim sessionToken As String = GenerateSecureToken()
            Dim expiryTime As DateTime = DateTime.Now.AddHours(tokenExpiryHours)
            
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "
                    INSERT INTO UserSessions (UserID, SessionToken, LoginTime, ExpiryTime, IPAddress, IsActive)
                    VALUES (@UserID, @SessionToken, GETDATE(), @ExpiryTime, @IPAddress, 1)"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@UserID", userId)
                    command.Parameters.AddWithValue("@SessionToken", sessionToken)
                    command.Parameters.AddWithValue("@ExpiryTime", expiryTime)
                    command.Parameters.AddWithValue("@IPAddress", GetClientIPAddress())
                    command.ExecuteNonQuery()
                End Using
            End Using
            
            Return sessionToken
        Catch ex As Exception
            Console.WriteLine($"Error creating user session: {ex.Message}")
            Return String.Empty
        End Try
    End Function

    Private Function GenerateJWTToken(user As User) As String
        Try
            Dim tokenHandler As New JwtSecurityTokenHandler()
            Dim key As Byte() = Encoding.ASCII.GetBytes(jwtSecret)
            
            Dim claims As New List(Of Claim) From {
                New Claim(ClaimTypes.NameIdentifier, user.ID.ToString()),
                New Claim(ClaimTypes.Name, user.Username),
                New Claim(ClaimTypes.Email, user.Email),
                New Claim(ClaimTypes.Role, user.Role),
                New Claim("BranchID", user.BranchID.ToString()),
                New Claim("BranchCode", user.BranchCode),
                New Claim("FullName", $"{user.FirstName} {user.LastName}")
            }
            
            Dim tokenDescriptor As New SecurityTokenDescriptor With {
                .Subject = New ClaimsIdentity(claims),
                .Expires = DateTime.UtcNow.AddHours(tokenExpiryHours),
                .SigningCredentials = New SigningCredentials(New SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            }
            
            Dim token As SecurityToken = tokenHandler.CreateToken(tokenDescriptor)
            Return tokenHandler.WriteToken(token)
        Catch ex As Exception
            Console.WriteLine($"Error generating JWT token: {ex.Message}")
            Return String.Empty
        End Try
    End Function

    Public Function ValidateJWTToken(token As String) As ClaimsPrincipal
        Try
            Dim tokenHandler As New JwtSecurityTokenHandler()
            Dim key As Byte() = Encoding.ASCII.GetBytes(jwtSecret)
            
            Dim validationParameters As New TokenValidationParameters With {
                .ValidateIssuerSigningKey = True,
                .IssuerSigningKey = New SymmetricSecurityKey(key),
                .ValidateIssuer = False,
                .ValidateAudience = False,
                .ClockSkew = TimeSpan.Zero
            }
            
            Dim principal As ClaimsPrincipal = tokenHandler.ValidateToken(token, validationParameters, Nothing)
            Return principal
        Catch ex As Exception
            Console.WriteLine($"Error validating JWT token: {ex.Message}")
            Return Nothing
        End Try
    End Function

    Public Function ValidateSession(sessionToken As String) As Boolean
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "
                    SELECT COUNT(*) 
                    FROM UserSessions 
                    WHERE SessionToken = @SessionToken 
                    AND IsActive = 1 
                    AND ExpiryTime > GETDATE()"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@SessionToken", sessionToken)
                    Dim count As Integer = CInt(command.ExecuteScalar())
                    Return count > 0
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error validating session: {ex.Message}")
            Return False
        End Try
    End Function

    Public Sub LogoutUser(sessionToken As String)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "
                    UPDATE UserSessions 
                    SET LogoutTime = GETDATE(), IsActive = 0 
                    WHERE SessionToken = @SessionToken"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@SessionToken", sessionToken)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error logging out user: {ex.Message}")
        End Try
    End Sub

    Public Function HashPassword(password As String) As String
        Return BCrypt.Net.BCrypt.HashPassword(password, BCrypt.Net.BCrypt.GenerateSalt())
    End Function

    Public Function VerifyPassword(password As String, hash As String) As Boolean
        Return BCrypt.Net.BCrypt.Verify(password, hash)
    End Function

    Private Function GenerateSecureToken() As String
        Using rng As New RNGCryptoServiceProvider()
            Dim tokenBytes(31) As Byte
            rng.GetBytes(tokenBytes)
            Return Convert.ToBase64String(tokenBytes)
        End Using
    End Function

    Private Function GetClientIPAddress() As String
        Try
            ' Get client IP address (simplified for desktop app)
            Return System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName()).AddressList(0).ToString()
        Catch
            Return "127.0.0.1"
        End Try
    End Function

    Public Function CheckPasswordPolicy(password As String) As PasswordPolicyResult
        Dim result As New PasswordPolicyResult With {.IsValid = True, .Messages = New List(Of String)}
        
        ' Minimum length check
        If password.Length < 8 Then
            result.IsValid = False
            result.Messages.Add("Password must be at least 8 characters long")
        End If
        
        ' Uppercase letter check
        If Not System.Text.RegularExpressions.Regex.IsMatch(password, "[A-Z]") Then
            result.IsValid = False
            result.Messages.Add("Password must contain at least one uppercase letter")
        End If
        
        ' Lowercase letter check
        If Not System.Text.RegularExpressions.Regex.IsMatch(password, "[a-z]") Then
            result.IsValid = False
            result.Messages.Add("Password must contain at least one lowercase letter")
        End If
        
        ' Number check
        If Not System.Text.RegularExpressions.Regex.IsMatch(password, "[0-9]") Then
            result.IsValid = False
            result.Messages.Add("Password must contain at least one number")
        End If
        
        ' Special character check
        If Not System.Text.RegularExpressions.Regex.IsMatch(password, "[^a-zA-Z0-9]") Then
            result.IsValid = False
            result.Messages.Add("Password must contain at least one special character")
        End If
        
        Return result
    End Function
End Class

Public Class LoginResult
    Public Property IsSuccess As Boolean
    Public Property User As User
    Public Property SessionToken As String
    Public Property JWTToken As String
    Public Property ErrorMessage As String
    Public Property RequiresTwoFactor As Boolean = False
End Class

Public Class PasswordPolicyResult
    Public Property IsValid As Boolean
    Public Property Messages As List(Of String)
End Class
