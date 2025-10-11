Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Security.Cryptography
Imports System.Text
Imports BCrypt.Net
Imports OvenDelightsERP
Imports OvenDelightsERP.Forms

Public Class LoginForm

    Private Sub LoginForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Oven Delights ERP - Login"
        Me.StartPosition = FormStartPosition.CenterScreen

        ' Test database connection on form load
        TestDatabaseConnection()
    End Sub

    Private Sub btnLogin_Click(sender As Object, e As EventArgs) Handles btnLogin.Click
        If String.IsNullOrWhiteSpace(txtUsername.Text) Then
            MessageBox.Show("Please enter your username.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtUsername.Focus()
            Return
        End If

        If String.IsNullOrWhiteSpace(txtPassword.Text) Then
            MessageBox.Show("Please enter your password.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtPassword.Focus()
            Return
        End If

        ' Authenticate user against Azure SQL database
        AuthenticateUser(txtUsername.Text.Trim(), txtPassword.Text)
    End Sub

    Private Sub AuthenticateUser(username As String, password As String)
        Try
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERP").ConnectionString

            Using connection As New SqlConnection(connectionString)
                connection.Open()

                ' Query to get user details and verify credentials
                Dim query As String = "SELECT ID, Username, PasswordHash, Role, BranchID, IsActive, FailedLoginAttempts, IsLockedOut FROM Users WHERE Username = @Username AND IsActive = 1"

                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@Username", username)

                    Using reader As SqlDataReader = command.ExecuteReader()
                        If reader.Read() Then
                            Dim userID As Integer = reader.GetInt32("ID")
                            Dim storedPasswordHash As String = reader.GetString("PasswordHash")
                            Dim role As String = reader.GetString("Role")
                            Dim branchID As Integer = reader.GetInt32("BranchID")
                            Dim failedAttempts As Integer = reader.GetInt32("FailedLoginAttempts")
                            Dim isLockedOut As Boolean = reader.GetBoolean("IsLockedOut")

                            ' Check if account is locked
                            If isLockedOut Then
                                MessageBox.Show("Account is locked due to too many failed login attempts. Please contact administrator.", "Account Locked", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                Return
                            End If

                            ' Verify password using BCrypt (simplified hash check for now)
                            If VerifyPassword(password, storedPasswordHash) Then
                                ' Login successful
                                MessageBox.Show($"Welcome {username}!\nRole: {role}\nLogin successful!", "Login Successful", MessageBoxButtons.OK, MessageBoxIcon.Information)

                                ' Reset failed login attempts
                                ResetFailedLoginAttempts(userID)

                                ' Log successful login
                                LogLoginAttempt(userID, username, True, "Successful login")

                                ' Create user object with minimal required properties
                                Dim user As New User() With {
                                    .ID = userID,
                                    .Username = username,
                                    .Role = role,
                                    .BranchID = branchID,
                                    .FirstName = username.Split("@"c)(0), ' Extract first part of email as first name
                                    .BranchName = "Main Branch" ' Default, can be loaded from DB if needed
                                }

                                ' Open main dashboard with user object
                                Dim mainForm As New MainDashboard(user)
                                mainForm.Show()
                                Me.Hide()
                            Else
                                ' Invalid password
                                HandleFailedLogin(userID, username)
                            End If
                        Else
                            ' User not found
                            MessageBox.Show("Invalid username or password.", "Login Failed", MessageBoxButtons.OK, MessageBoxIcon.Error)
                            LogLoginAttempt(0, username, False, "User not found")
                        End If
                    End Using
                End Using
            End Using

        Catch ex As Exception
            MessageBox.Show($"Database connection error: {ex.Message}", "Connection Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function VerifyPassword(password As String, storedHash As String) As Boolean
        Try
            ' First check if the stored hash is actually a BCrypt hash
            ' This is for backward compatibility during development
            If storedHash.StartsWith("$2a$") OrElse storedHash.StartsWith("$2b$") Then
                ' This is a BCrypt hash, verify using BCrypt
                Return BCrypt.Net.BCrypt.Verify(password, storedHash)
            Else
                ' For backward compatibility during development only
                ' In production, all passwords should be hashed with BCrypt
                Return password = storedHash
            End If
        Catch ex As Exception
            ' Log the error and return false to fail securely
            System.Diagnostics.Debug.WriteLine($"Password verification error: {ex.Message}")
            Return False
        End Try
    End Function

    Private Sub HandleFailedLogin(userID As Integer, username As String)
        Try
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERP").ConnectionString

            Using connection As New SqlConnection(connectionString)
                connection.Open()

                ' Increment failed login attempts
                Dim updateQuery As String = "UPDATE Users SET FailedLoginAttempts = FailedLoginAttempts + 1, LastFailedLogin = GETDATE() WHERE ID = @UserID"

                Using command As New SqlCommand(updateQuery, connection)
                    command.Parameters.AddWithValue("@UserID", userID)
                    command.ExecuteNonQuery()
                End Using

                ' Check if account should be locked (after 5 failed attempts)
                Dim checkQuery As String = "SELECT FailedLoginAttempts FROM Users WHERE ID = @UserID"
                Using command As New SqlCommand(checkQuery, connection)
                    command.Parameters.AddWithValue("@UserID", userID)
                    Dim attempts As Integer = CInt(command.ExecuteScalar())

                    If attempts >= 5 Then
                        ' Lock the account
                        Dim lockQuery As String = "UPDATE Users SET IsLockedOut = 1 WHERE ID = @UserID"
                        Using lockCommand As New SqlCommand(lockQuery, connection)
                            lockCommand.Parameters.AddWithValue("@UserID", userID)
                            lockCommand.ExecuteNonQuery()
                        End Using

                        MessageBox.Show("Account locked due to too many failed login attempts. Please contact administrator.", "Account Locked", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Else
                        MessageBox.Show($"Invalid password. {5 - attempts} attempts remaining.", "Login Failed", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    End If
                End Using
            End Using

            ' Log failed login attempt
            LogLoginAttempt(userID, username, False, "Invalid password")

        Catch ex As Exception
            MessageBox.Show($"Error handling failed login: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ResetFailedLoginAttempts(userID As Integer)
        Try
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERP").ConnectionString

            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim query As String = "UPDATE Users SET FailedLoginAttempts = 0, IsLockedOut = 0, LastSuccessfulLogin = GETDATE() WHERE ID = @UserID"

                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@UserID", userID)
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            ' Handle silently
        End Try
    End Sub

    Private Sub LogLoginAttempt(userID As Integer, username As String, isSuccessful As Boolean, description As String)
        Try
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERP").ConnectionString
            Dim clientIP = GetClientIPAddress()
            Dim userAgent = GetUserAgent()
            Dim deviceInfo = GetDeviceInfo()

            Using connection As New SqlConnection(connectionString)
                connection.Open()

                ' Create a new session for successful logins
                Dim sessionId As Object = DBNull.Value

                If isSuccessful Then
                    ' Insert a new session record
                    Dim sessionQuery As String = "INSERT INTO UserSessions (UserID, SessionToken, IPAddress, UserAgent, IsActive, ExpiryTime, DeviceInfo) " &
                                              "VALUES (@UserID, @SessionToken, @IPAddress, @UserAgent, 1, @ExpiryTime, @DeviceInfo); SELECT SCOPE_IDENTITY();"

                    Using sessionCommand As New SqlCommand(sessionQuery, connection)
                        Dim sessionToken = System.Guid.NewGuid().ToString()
                        sessionCommand.Parameters.AddWithValue("@UserID", userID)
                        sessionCommand.Parameters.AddWithValue("@SessionToken", sessionToken)
                        sessionCommand.Parameters.AddWithValue("@IPAddress", If(String.IsNullOrEmpty(clientIP), DBNull.Value, clientIP))
                        sessionCommand.Parameters.AddWithValue("@UserAgent", If(String.IsNullOrEmpty(userAgent), DBNull.Value, userAgent))
                        sessionCommand.Parameters.AddWithValue("@ExpiryTime", DateTime.Now.AddHours(8)) ' 8-hour session
                        sessionCommand.Parameters.AddWithValue("@DeviceInfo", If(String.IsNullOrEmpty(deviceInfo), DBNull.Value, deviceInfo))

                        ' Get the new session ID
                        sessionId = sessionCommand.ExecuteScalar()
                    End Using
                End If

                ' Log the login attempt in the audit log
                Dim query As String = "INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Description, IPAddress, UserAgent, SessionID, ActionType, Severity, ModuleName, Timestamp) " &
                                    "VALUES (@UserID, @Action, @TableName, @RecordID, @Description, @IPAddress, @UserAgent, @SessionID, @ActionType, @Severity, @ModuleName, @Timestamp)"

                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@UserID", If(userID > 0, userID, DBNull.Value))
                    command.Parameters.AddWithValue("@Action", If(isSuccessful, "LOGIN_SUCCESS", "LOGIN_FAILED"))
                    command.Parameters.AddWithValue("@TableName", "Users")
                    command.Parameters.AddWithValue("@RecordID", If(userID > 0, userID.ToString(), DBNull.Value))
                    command.Parameters.AddWithValue("@Description", description)
                    command.Parameters.AddWithValue("@IPAddress", If(String.IsNullOrEmpty(clientIP), DBNull.Value, clientIP))
                    command.Parameters.AddWithValue("@UserAgent", If(String.IsNullOrEmpty(userAgent), DBNull.Value, userAgent))
                    command.Parameters.AddWithValue("@SessionID", If(isSuccessful, sessionId, DBNull.Value))
                    command.Parameters.AddWithValue("@ActionType", If(isSuccessful, "LOGIN", "SECURITY"))
                    command.Parameters.AddWithValue("@Severity", If(isSuccessful, "INFO", "WARNING"))
                    command.Parameters.AddWithValue("@ModuleName", "Authentication")
                    command.Parameters.AddWithValue("@Timestamp", DateTime.Now)

                    command.ExecuteNonQuery()
                End Using

                ' For successful logins, update the user's last login time
                If isSuccessful Then
                    Dim updateQuery As String = "UPDATE Users SET LastLogin = GETDATE() WHERE ID = @UserID"
                    Using updateCommand As New SqlCommand(updateQuery, connection)
                        updateCommand.Parameters.AddWithValue("@UserID", userID)
                        updateCommand.ExecuteNonQuery()
                    End Using
                End If
            End Using
        Catch ex As Exception
            ' Log to debug output if database logging fails
            System.Diagnostics.Debug.WriteLine($"Failed to log login attempt: {ex.Message}")
        End Try
    End Sub

    Private Function GetClientIPAddress() As String
        Try
            ' In a web application, you would use HttpContext.Current.Request.UserHostAddress
            ' For Windows Forms, we'll use Dns.GetHostEntry to get the local IP
            Dim hostName As String = System.Net.Dns.GetHostName()
            Dim hostEntry As System.Net.IPHostEntry = System.Net.Dns.GetHostEntry(hostName)

            ' Get the first non-loopback IPv4 address
            For Each ip As System.Net.IPAddress In hostEntry.AddressList
                If ip.AddressFamily = System.Net.Sockets.AddressFamily.InterNetwork Then
                    Return ip.ToString()
                End If
            Next

            Return "127.0.0.1"
        Catch
            Return "Unknown"
        End Try
    End Function

    Private Function GetUserAgent() As String
        ' In a Windows Forms app, we don't have a direct User-Agent like in web
        ' But we can include some system information
        Try
            Return $"Windows Forms App; .NET {Environment.Version}; {Environment.OSVersion}"
        Catch
            Return "Windows Forms App"
        End Try
    End Function

    Private Function GetDeviceInfo() As String
        Try
            Return $"OS: {Environment.OSVersion}, 64-bit: {Environment.Is64BitOperatingSystem}, " &
                   $"User: {Environment.UserName}, Machine: {Environment.MachineName}"
        Catch
            Return "Device info not available"
        End Try
    End Function

    Private Sub TestDatabaseConnection()
        Try
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERP").ConnectionString

            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Console.WriteLine("✅ Azure SQL Database connection successful!")

                ' Test if Users table exists
                Dim testQuery As String = "SELECT COUNT(*) FROM Users"
                Using command As New SqlCommand(testQuery, connection)
                    Dim userCount As Integer = CInt(command.ExecuteScalar())
                    Console.WriteLine($"✅ Found {userCount} users in database")
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"⚠️ Database connection failed: {ex.Message}\n\nPlease check your connection string and ensure the database is accessible.", "Database Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

End Class