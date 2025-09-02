Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Text.RegularExpressions
Imports System.Net
Imports System.Security.Cryptography

Public Class SecurityService
    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private Shared ReadOnly allowedIPs As New List(Of String) From {"127.0.0.1", "::1"}
    
    ' Password Policy Enforcement
    Public Function ValidatePasswordPolicy(password As String) As (IsValid As Boolean, Message As String)
        If String.IsNullOrEmpty(password) Then
            Return (False, "Password cannot be empty")
        End If
        
        If password.Length < 8 Then
            Return (False, "Password must be at least 8 characters long")
        End If
        
        If Not Regex.IsMatch(password, "[A-Z]") Then
            Return (False, "Password must contain at least one uppercase letter")
        End If
        
        If Not Regex.IsMatch(password, "[a-z]") Then
            Return (False, "Password must contain at least one lowercase letter")
        End If
        
        If Not Regex.IsMatch(password, "[0-9]") Then
            Return (False, "Password must contain at least one number")
        End If
        
        If Not Regex.IsMatch(password, "[!@#$%^&*(),.?{}|<>]") Then
            Return (False, "Password must contain at least one special character")
        End If
        
        Return (True, "Password meets all requirements")
    End Function
    
    ' Failed Login Attempt Tracking
    Public Function TrackFailedLogin(username As String, ipAddress As String) As Boolean
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                ' Get current failed attempts
                Dim getAttemptsQuery As String = "SELECT FailedLoginAttempts, IsLocked FROM Users WHERE Username = @Username"
                Using command As New SqlCommand(getAttemptsQuery, connection)
                    command.Parameters.AddWithValue("@Username", username)
                    Using reader As SqlDataReader = command.ExecuteReader()
                        If reader.Read() Then
                            Dim currentAttempts As Integer = CInt(reader("FailedLoginAttempts"))
                            Dim isLocked As Boolean = CBool(reader("IsLocked"))
                            reader.Close()
                            
                            ' Increment failed attempts
                            currentAttempts += 1
                            Dim shouldLock As Boolean = currentAttempts >= GetMaxLoginAttempts()
                            
                            ' Update user record
                            Dim updateQuery As String = "UPDATE Users SET FailedLoginAttempts = @Attempts, IsLocked = @IsLocked, LockoutEndDate = @LockoutEnd WHERE Username = @Username"
                            
                            Using updateCommand As New SqlCommand(updateQuery, connection)
                                updateCommand.Parameters.AddWithValue("@Attempts", currentAttempts)
                                updateCommand.Parameters.AddWithValue("@IsLocked", shouldLock)
                                updateCommand.Parameters.AddWithValue("@LockoutEnd", If(shouldLock, DateTime.Now.AddMinutes(30), DBNull.Value))
                                updateCommand.Parameters.AddWithValue("@Username", username)
                                updateCommand.ExecuteNonQuery()
                            End Using
                            
                            ' Log security event
                            LogSecurityEvent("FAILED_LOGIN", username, ipAddress, String.Format("Failed login attempt #{0}", currentAttempts))
                            
                            Return shouldLock
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            LogSecurityEvent("SECURITY_ERROR", username, ipAddress, String.Format("Error tracking failed login: {0}", ex.Message))
        End Try
        Return False
    End Function
    
    ' IP Whitelisting
    Public Function IsIPAllowed(ipAddress As String) As Boolean
        If Not IsIPWhitelistingEnabled() Then Return True
        
        Try
            ' Check if IP is in allowed list
            If allowedIPs.Contains(ipAddress) Then Return True
            
            ' Check database for additional allowed IPs
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim query As String = "SELECT COUNT(*) FROM SystemSettings WHERE SettingName = 'ALLOWED_IP_' + @IP AND SettingValue = 'true'"
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@IP", ipAddress.Replace(".", "_"))
                    Dim count As Integer = CInt(command.ExecuteScalar())
                    Return count > 0
                End Using
            End Using
        Catch ex As Exception
            ' If error checking, allow access (fail open for availability)
            Return True
        End Try
    End Function
    
    ' Session Timeout Management
    Public Function IsSessionValid(sessionToken As String) As Boolean
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim query As String = "SELECT LastActivity, IsActive FROM UserSessions WHERE SessionToken = @Token AND IsActive = 1"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@Token", sessionToken)
                    Using reader As SqlDataReader = command.ExecuteReader()
                        If reader.Read() Then
                            Dim lastActivity As DateTime = CDate(reader("LastActivity"))
                            Dim timeoutMinutes As Integer = GetSessionTimeout()
                            
                            If DateTime.Now.Subtract(lastActivity).TotalMinutes > timeoutMinutes Then
                                reader.Close()
                                ' Session expired - mark as inactive
                                InvalidateSession(sessionToken)
                                Return False
                            End If
                            Return True
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function
    
    ' Two-Factor Authentication
    Public Function GenerateTwoFactorSecret() As String
        Dim secretBytes(19) As Byte
        RandomNumberGenerator.Fill(secretBytes)
        Return secretBytes.ToBase32String()
    End Function
    
    Public Function ValidateTwoFactorCode(secret As String, code As String) As Boolean
        Try
            ' Simple TOTP validation (30-second window)
            Dim unixTime As Long = DateTimeOffset.UtcNow.ToUnixTimeSeconds()
            Dim timeStep As Long = unixTime \ 30
            
            ' Check current and previous time steps for clock drift
            For i As Integer = -1 To 1
                Dim testTimeStep As Long = timeStep + i
                Dim expectedCode As String = GenerateTOTP(secret, testTimeStep)
                If code = expectedCode Then Return True
            Next
            
            Return False
        Catch ex As Exception
            Return False
        End Try
    End Function
    
    ' Data Encryption
    Public Function EncryptSensitiveData(data As String) As String
        Try
            Using aes As Aes = Aes.Create()
                aes.Key = GetEncryptionKey()
                aes.GenerateIV()
                
                Using encryptor As ICryptoTransform = aes.CreateEncryptor()
                    Dim dataBytes As Byte() = System.Text.Encoding.UTF8.GetBytes(data)
                    Dim encryptedBytes As Byte() = encryptor.TransformFinalBlock(dataBytes, 0, dataBytes.Length)
                    
                    ' Combine IV and encrypted data
                    Dim result(aes.IV.Length + encryptedBytes.Length - 1) As Byte
                    Array.Copy(aes.IV, 0, result, 0, aes.IV.Length)
                    Array.Copy(encryptedBytes, 0, result, aes.IV.Length, encryptedBytes.Length)
                    
                    Return Convert.ToBase64String(result)
                End Using
            End Using
        Catch ex As Exception
            Return data ' Return original if encryption fails
        End Try
    End Function
    
    Public Function DecryptSensitiveData(encryptedData As String) As String
        Try
            Dim dataBytes As Byte() = Convert.FromBase64String(encryptedData)
            
            Using aes As Aes = Aes.Create()
                aes.Key = GetEncryptionKey()
                
                ' Extract IV
                Dim iv(15) As Byte
                Array.Copy(dataBytes, 0, iv, 0, 16)
                aes.IV = iv
                
                ' Extract encrypted data
                Dim encryptedBytes(dataBytes.Length - 17) As Byte
                Array.Copy(dataBytes, 16, encryptedBytes, 0, encryptedBytes.Length)
                
                Using decryptor As ICryptoTransform = aes.CreateDecryptor()
                    Dim decryptedBytes As Byte() = decryptor.TransformFinalBlock(encryptedBytes, 0, encryptedBytes.Length)
                    Return System.Text.Encoding.UTF8.GetString(decryptedBytes)
                End Using
            End Using
        Catch ex As Exception
            Return encryptedData ' Return original if decryption fails
        End Try
    End Function
    
    ' RoleID-Based Menu Visibility
    Public Function GetUserPermissions(userUserID As Integer) As List(Of String)
        Dim permissions As New List(Of String)
        
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim query As String = "SELECT DISTINCT p.PermissionName FROM Users u " & _
                                    "INNER JOIN RolePermissions rp ON u.RoleID = rp.RoleID " & _
                                    "INNER JOIN Permissions p ON rp.PermissionID = p.PermissionID " & _
                                    "WHERE u.UserID = @UserID AND p.IsActive = 1"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@UserID", userUserID)
                    Using reader As SqlDataReader = command.ExecuteReader()
                        While reader.Read()
                            permissions.Add(reader("PermissionName").ToString())
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception
            ' Return empty list on error
        End Try
        
        Return permissions
    End Function
    
    ' Security Event Logging
    Public Sub LogSecurityEvent(eventType As String, username As String, ipAddress As String, description As String)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim query As String = "INSERT INTO AuditLog (Action, TableName, OldValues, Timestamp, IPAddress) VALUES (@Action, @TableName, @Description, GETDATE(), @IPAddress)"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@Action", eventType)
                    command.Parameters.AddWithValue("@TableName", "Security")
                    command.Parameters.AddWithValue("@Description", String.Format("{0}: {1}", username, description))
                    command.Parameters.AddWithValue("@IPAddress", ipAddress)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            ' Silent logging failure
        End Try
    End Sub
    
    ' Helper Methods
    Private Function GetMaxLoginAttempts() As Integer
        Return GetSystemSetting("MAX_LOGIN_ATTEMPTS", 5)
    End Function
    
    Private Function GetSessionTimeout() As Integer
        Return GetSystemSetting("SESSION_TIMEOUT", 480)
    End Function
    
    Private Function IsIPWhitelistingEnabled() As Boolean
        Return GetSystemSetting("IP_WHITELISTING_ENABLED", False)
    End Function
    
    Private Function GetSystemSetting(Of T)(settingName As String, defaultValue As T) As T
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim query As String = "SELECT SettingValue FROM SystemSettings WHERE SettingName = @Name"
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@Name", settingName)
                    Dim result = command.ExecuteScalar()
                    If result IsNot Nothing Then
                        Return CType(Convert.ChangeType(result, GetType(T)), T)
                    End If
                End Using
            End Using
        Catch ex As Exception
            ' Return default on error
        End Try
        Return defaultValue
    End Function
    
    Private Sub InvalidateSession(sessionToken As String)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim query As String = "UPDATE UserSessions SET IsActive = 0, LogoutTime = GETDATE() WHERE SessionToken = @Token"
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@Token", sessionToken)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            ' Silent failure
        End Try
    End Sub
    
    Private Function GetEncryptionKey() As Byte()
        ' In production, this should come from secure key management
        Dim keyString As String = "OvenDelightsERP_EncryptionKey_32Chars!"
        Return System.Text.Encoding.UTF8.GetBytes(keyString)
    End Function
    
    Private Function GenerateTOTP(secret As String, timeStep As Long) As String
        ' Simplified TOTP implementation
        Dim secretBytes As Byte() = secret.FromBase32String()
        Dim timeBytes As Byte() = BitConverter.GetBytes(timeStep)
        If BitConverter.IsLittleEndian Then Array.Reverse(timeBytes)
        
        Using hmac As New System.Security.Cryptography.HMACSHA1(secretBytes)
            Dim hash As Byte() = hmac.ComputeHash(timeBytes)
            Dim offset As Integer = hash(hash.Length - 1) And &HF
            Dim code As Integer = ((hash(offset) And &H7F) << 24) Or
                                 ((hash(offset + 1) And &HFF) << 16) Or
                                 ((hash(offset + 2) And &HFF) << 8) Or
                                 (hash(offset + 3) And &HFF)
            Return (code Mod 1000000).ToString("D6")
        End Using
    End Function
End Class

' Extension method for Base32 encoding
Public Module Base32Extensions
    Private ReadOnly base32Chars As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
    
    <System.Runtime.CompilerServices.Extension>
    Public Function ToBase32String(bytes As Byte()) As String
        If bytes Is Nothing OrElse bytes.Length = 0 Then Return String.Empty
        
        Dim result As New System.Text.StringBuilder()
        Dim buffer As Integer = 0
        Dim bitsLeft As Integer = 0
        
        For Each b As Byte In bytes
            buffer = (buffer << 8) Or b
            bitsLeft += 8
            
            While bitsLeft >= 5
                result.Append(base32Chars((buffer >> (bitsLeft - 5)) And 31))
                bitsLeft -= 5
            End While
        Next
        
        If bitsLeft > 0 Then
            result.Append(base32Chars((buffer << (5 - bitsLeft)) And 31))
        End If
        
        Return result.ToString()
    End Function
    
    <System.Runtime.CompilerServices.Extension>
    Public Function FromBase32String(base32 As String) As Byte()
        If String.IsNullOrEmpty(base32) Then Return New Byte() {}
        
        Dim result As New List(Of Byte)()
        Dim buffer As Integer = 0
        Dim bitsLeft As Integer = 0
        
        For Each c As Char In base32.ToUpper()
            Dim value As Integer = base32Chars.IndexOf(c)
            If value < 0 Then Continue For
            
            buffer = (buffer << 5) Or value
            bitsLeft += 5
            
            If bitsLeft >= 8 Then
                result.Add(CByte((buffer >> (bitsLeft - 8)) And 255))
                bitsLeft -= 8
            End If
        Next
        
        Return result.ToArray()
    End Function
End Module
