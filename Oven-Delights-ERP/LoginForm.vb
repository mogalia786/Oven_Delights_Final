Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Text
Imports System.Data
Imports System.Diagnostics


Public Class LoginForm
    Private Sub LoginForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            ' Test database connection with timeout handling
            Dim connStr As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            If String.IsNullOrEmpty(connStr) Then
                MessageBox.Show("Database connection string not found in App.config", "Configuration Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Quick connection test with short timeout
            Using conn As New SqlConnection(connStr)
                ' Note: ConnectionTimeout is read-only, set in connection string instead
                conn.Open()
                conn.Close()
            End Using
            
            ' If we get here, database is accessible
            Me.Text = "Oven Delights ERP - Login (Database Connected)"
            
        Catch ex As SqlException
            MessageBox.Show($"Database connection failed: {ex.Message}{Environment.NewLine}Please check your database server is running.", "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Me.Text = "Oven Delights ERP - Login (Database Offline)"
        Catch ex As Exception
            MessageBox.Show($"Connection test failed: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Me.Text = "Oven Delights ERP - Login (Connection Error)"
        End Try
    End Sub

    Private Sub btnLogin_Click(sender As Object, e As EventArgs) Handles btnLogin.Click
        Dim username As String = txtEmail.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()

        If String.IsNullOrEmpty(username) OrElse String.IsNullOrEmpty(password) Then
            MessageBox.Show("Please enter both username and password.", "Login Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return
        End If

        Dim connStr As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Using conn As New SqlConnection(connStr)
            Try
                conn.Open()

                ' Build query to get user details with role and branch information
                Dim query As New StringBuilder()
                query.AppendLine("SELECT u.UserID, u.Username, u.Password, u.Email, u.FirstName, u.LastName,")
                query.AppendLine("       u.RoleID, u.BranchID, u.CreatedDate, u.LastLogin, u.IsActive,")
                query.AppendLine("       u.FailedLoginAttempts, u.LastFailedLogin, u.PasswordLastChanged, u.TwoFactorEnabled,")
                query.AppendLine("       r.RoleName,")
                query.AppendLine("       b.BranchName, b.Prefix")
                query.AppendLine("FROM Users u")
                query.AppendLine("LEFT JOIN Roles r ON r.RoleID = u.RoleID")
                query.AppendLine("LEFT JOIN Branches b ON b.BranchID = u.BranchID")
                query.AppendLine("WHERE u.Username = @username")

                Using cmd As New SqlCommand(query.ToString(), conn)
                    cmd.CommandType = CommandType.Text
                    cmd.Parameters.AddWithValue("@username", username)

                    ' Execute the query with a timeout
                    cmd.CommandTimeout = 30 ' 30 seconds timeout

                    Using reader As SqlDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)
                        If reader.Read() Then
                            ' Get the stored password
                            Dim storedPassword As String = If(reader("Password") IsNot DBNull.Value,
                                                           reader("Password").ToString(), String.Empty)

                            ' Verify the password (plain text comparison)
                            If password = storedPassword Then
                                ' Password is correct, log the user in
                                Dim loggedInUser As New User()
                                loggedInUser.UserID = CInt(reader("UserID"))
                                loggedInUser.Username = reader("Username").ToString()
                                loggedInUser.Email = reader("Email").ToString()
                                loggedInUser.FirstName = If(reader("FirstName") IsNot DBNull.Value,
                                                             reader("FirstName").ToString(), String.Empty)
                                loggedInUser.LastName = If(reader("LastName") IsNot DBNull.Value,
                                                            reader("LastName").ToString(), String.Empty)
                                loggedInUser.RoleID = CInt(reader("RoleID"))
                                loggedInUser.BranchID = If(reader("BranchID") IsNot DBNull.Value,
                                                             CInt(reader("BranchID")), Nothing)
                                loggedInUser.IsActive = CBool(reader("IsActive"))
                                'loggedInUser.LastLogin = If(reader("LastLogin") IsNot DBNull.Value,
                                'CDate(reader("LastLogin")), Nothing)

                                ' Reset failed login attempts on successful login
                                ResetFailedLoginAttempts(loggedInUser.UserID)

                                ' Update last login timestamp
                                UpdateLastLogin(loggedInUser.UserID)

                                ' Initialize global session for dashboard and other forms
                                Dim roleName As String = TryCast(If(reader("RoleName") IsNot DBNull.Value, reader("RoleName").ToString(), Nothing), String)
                                Dim branchName As String = TryCast(If(reader("BranchName") IsNot DBNull.Value, reader("BranchName").ToString(), Nothing), String)
                                Dim branchPrefix As String = TryCast(If(reader("Prefix") IsNot DBNull.Value, reader("Prefix").ToString(), Nothing), String)

                                AppSession.InitializeFromUser(loggedInUser, roleName, branchName, branchPrefix)

                                ' Open main dashboard with user context
                                Dim dashboard As New MainDashboard(AppSession.CurrentUser)
                                dashboard.Show()
                                Me.Hide()
                            Else
                                ' Password is incorrect, increment failed login attempts
                                Dim failedAttempts As Integer = CInt(reader("FailedLoginAttempts"))
                                HandleFailedLogin(CInt(reader("UserID")), failedAttempts + 1)

                                Dim attemptsLeft As Integer = 5 - (failedAttempts + 1)
                                If attemptsLeft > 0 Then
                                    MessageBox.Show($"Invalid username or password. {attemptsLeft} attempts remaining.",
                                                      "Login Failed", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                Else
                                    MessageBox.Show("Too many failed login attempts. Please wait before trying again.", "Login Failed", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                End If
                            End If
                        Else
                            ' User not found
                            MessageBox.Show("Invalid username or password.", "Login Failed",
                                              MessageBoxButtons.OK, MessageBoxIcon.Error)
                        End If
                    End Using
                End Using
            Catch ex As SqlException
                ' Log SQL-specific errors
                Dim errorMsg As New StringBuilder()
                errorMsg.AppendLine("SQL Error during login:")
                errorMsg.AppendLine($"Message: {ex.Message}")
                errorMsg.AppendLine($"Error Number: {ex.Number}")
                errorMsg.AppendLine($"Procedure: {ex.Procedure}")
                errorMsg.AppendLine($"Line Number: {ex.LineNumber}")

                ' Log to debug output
                Debug.WriteLine(errorMsg.ToString())

                ' Show user-friendly message
                MessageBox.Show(ex.Message,
                              "Login Error", MessageBoxButtons.OK, MessageBoxIcon.Error)

            Catch ex As Exception
                ' Log general errors
                Debug.WriteLine($"Login error: {ex.Message}")
                Debug.WriteLine(ex.StackTrace)

                ' Show user-friendly message
                MessageBox.Show(ex.Message,
                              "Login Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
    End Sub

    Private Sub HandleFailedLogin(userID As Integer, failedAttempts As Integer)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Using conn As New SqlConnection(connStr)
            Try
                conn.Open()

                ' Build the query with parameterized SQL
                Dim query As New StringBuilder()
                query.AppendLine("UPDATE Users")
                query.AppendLine("SET FailedLoginAttempts = @failedAttempts,")
                query.AppendLine("    LastFailedLogin = GETDATE()")
                query.AppendLine("WHERE UserID = @userID")

                ' Execute the update
                Using cmd As New SqlCommand(query.ToString(), conn)
                    cmd.CommandType = CommandType.Text
                    cmd.Parameters.AddWithValue("@failedAttempts", failedAttempts)
                    cmd.Parameters.AddWithValue("@userID", userID)
                    cmd.ExecuteNonQuery()
                End Using
            Catch ex As Exception
                ' Log error but don't prevent login
                Console.WriteLine($"Error updating failed login attempts: {ex.Message}")
            End Try
        End Using
    End Sub

    Private Sub ResetFailedLoginAttempts(userID As Integer)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Using conn As New SqlConnection(connStr)
            Try
                conn.Open()
                Dim query As String = "UPDATE Users " &
                                    "SET FailedLoginAttempts = 0, " &
                                    "LastFailedLogin = NULL " &
                                    "WHERE UserID = @userID"

                Using cmd As New SqlCommand(query, conn)
                    cmd.CommandType = CommandType.Text
                    cmd.Parameters.AddWithValue("@userID", userID)
                    cmd.ExecuteNonQuery()
                End Using
            Catch ex As Exception
                ' Log error but don't prevent login
                Console.WriteLine($"Error resetting failed login attempts: {ex.Message}")
            End Try
        End Using
    End Sub

    Private Sub ResetLockoutStatus(userID As Integer)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Using conn As New SqlConnection(connStr)
            Try
                conn.Open()
                ' No account locking in current schema, just update last failed login
                Dim query As String = "UPDATE Users " &
                                    "SET LastFailedLogin = NULL " &
                                    "WHERE UserID = @userID"

                Using cmd As New SqlCommand(query, conn)
                    cmd.CommandType = CommandType.Text
                    cmd.Parameters.AddWithValue("@userID", userID)
                    cmd.ExecuteNonQuery()
                End Using
            Catch ex As Exception
                ' Log error but don't prevent login
                Console.WriteLine($"Error resetting lockout status: {ex.Message}")
            End Try
        End Using
    End Sub

    Private Sub UpdateLastLogin(userID As Integer)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Using conn As New SqlConnection(connStr)
            Try
                conn.Open()
                Dim query As String = "UPDATE Users " &
                                    "SET LastLogin = GETDATE(), " &
                                    "FailedLoginAttempts = 0, " &
                                    "LastFailedLogin = NULL " &
                                    "WHERE UserID = @userID"

                Using cmd As New SqlCommand(query, conn)
                    cmd.CommandType = CommandType.Text
                    cmd.Parameters.AddWithValue("@userID", userID)
                    cmd.ExecuteNonQuery()
                End Using
            Catch ex As Exception
                ' Log error but don't prevent login
                Console.WriteLine($"Error updating last login: {ex.Message}")
            End Try
        End Using
    End Sub
End Class