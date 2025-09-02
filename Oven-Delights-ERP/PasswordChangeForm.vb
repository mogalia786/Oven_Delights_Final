Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports BCrypt.Net

Partial Class PasswordChangeForm
    Inherits Form

    Private connectionString As String
    Private currentUserID As Integer

    Public Sub New(userID As Integer)
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        currentUserID = userID
    End Sub

    Private Sub btnChangePassword_Click(sender As Object, e As EventArgs) Handles btnChangePassword.Click
        If ValidatePasswords() Then
            If VerifyCurrentPassword() Then
                If UpdatePassword() Then
                    MessageBox.Show("Password changed successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.DialogResult = DialogResult.OK
                    Me.Close()
                End If
            Else
                MessageBox.Show("Current password is incorrect.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                txtCurrentPassword.Focus()
            End If
        End If
    End Sub

    Private Function ValidatePasswords() As Boolean
        If String.IsNullOrWhiteSpace(txtCurrentPassword.Text) Then
            MessageBox.Show("Current password is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtCurrentPassword.Focus()
            Return False
        End If

        If String.IsNullOrWhiteSpace(txtNewPassword.Text) Then
            MessageBox.Show("New password is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtNewPassword.Focus()
            Return False
        End If

        If txtNewPassword.Text.Length < 8 Then
            MessageBox.Show("New password must be at least 8 characters long.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtNewPassword.Focus()
            Return False
        End If

        If txtNewPassword.Text <> txtConfirmPassword.Text Then
            MessageBox.Show("New password and confirmation do not match.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtConfirmPassword.Focus()
            Return False
        End If

        ' Password strength validation
        If Not IsStrongPassword(txtNewPassword.Text) Then
            MessageBox.Show("Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.", "Weak Password", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtNewPassword.Focus()
            Return False
        End If

        Return True
    End Function

    Private Function IsStrongPassword(password As String) As Boolean
        Dim hasUpper As Boolean = password.Any(Function(c) Char.IsUpper(c))
        Dim hasLower As Boolean = password.Any(Function(c) Char.IsLower(c))
        Dim hasDigit As Boolean = password.Any(Function(c) Char.IsDigit(c))
        Dim hasSpecial As Boolean = password.Any(Function(c) "!@#$%^&*()_+-=[]{}|;:,.<>?".Contains(c))
        
        Return hasUpper AndAlso hasLower AndAlso hasDigit AndAlso hasSpecial
    End Function

    Private Function VerifyCurrentPassword() As Boolean
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT Password, PasswordHash FROM Users WHERE UserID = @userID", conn)
                cmd.Parameters.AddWithValue("@userID", currentUserID)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    Dim storedPasswordHash As String = reader("PasswordHash")?.ToString()
                    Dim storedPassword As String = reader("Password")?.ToString()
                    reader.Close()
                    
                    ' Try BCrypt first, then fallback to plain text for backward compatibility
                    If Not String.IsNullOrEmpty(storedPasswordHash) Then
                        Return BCrypt.Net.BCrypt.Verify(txtCurrentPassword.Text, storedPasswordHash)
                    ElseIf Not String.IsNullOrEmpty(storedPassword) Then
                        Return txtCurrentPassword.Text = storedPassword
                    End If
                End If
                reader.Close()
            Catch ex As Exception
                MessageBox.Show("Error verifying current password: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
        Return False
    End Function

    Private Function UpdatePassword() As Boolean
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                
                ' Store old password in history
                StorePasswordHistory(conn)
                
                ' Update with new password
                Dim hashedPassword As String = BCrypt.Net.BCrypt.HashPassword(txtNewPassword.Text)
                Dim cmd As New SqlCommand("UPDATE Users SET Password = @password, PasswordHash = @passwordHash, PasswordLastChanged = GETDATE() WHERE UserID = @userID", conn)
                cmd.Parameters.AddWithValue("@userID", currentUserID)
                cmd.Parameters.AddWithValue("@password", txtNewPassword.Text) ' Keep for backward compatibility
                cmd.Parameters.AddWithValue("@passwordHash", hashedPassword)
                cmd.ExecuteNonQuery()
                
                LogAuditAction("PasswordChanged", "Users", currentUserID, "User changed their password")
                Return True
            Catch ex As Exception
                MessageBox.Show("Error updating password: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Using
    End Function

    Private Sub StorePasswordHistory(conn As SqlConnection)
        Try
            ' Get current password hash
            Dim cmd As New SqlCommand("SELECT PasswordHash FROM Users WHERE UserID = @userID", conn)
            cmd.Parameters.AddWithValue("@userID", currentUserID)
            Dim currentHash As String = cmd.ExecuteScalar()?.ToString()
            
            If Not String.IsNullOrEmpty(currentHash) Then
                ' Store in password history
                cmd = New SqlCommand("INSERT INTO PasswordHistory (UserID, PasswordHash, CreatedDate) VALUES (@userID, @passwordHash, GETDATE())", conn)
                cmd.Parameters.AddWithValue("@userID", currentUserID)
                cmd.Parameters.AddWithValue("@passwordHash", currentHash)
                cmd.ExecuteNonQuery()
                
                ' Keep only last 5 passwords
                cmd = New SqlCommand("DELETE FROM PasswordHistory WHERE UserID = @userID AND ID NOT IN (SELECT TOP 5 ID FROM PasswordHistory WHERE UserID = @userID ORDER BY CreatedDate DESC)", conn)
                cmd.Parameters.AddWithValue("@userID", currentUserID)
                cmd.ExecuteNonQuery()
            End If
        Catch ex As Exception
            ' Silent fail for password history
        End Try
    End Sub

    Private Sub LogAuditAction(action As String, tableName As String, recordID As Integer, details As String)
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Details, Timestamp) VALUES (@userID, @action, @tableName, @recordID, @details, GETDATE())", conn)
                cmd.Parameters.AddWithValue("@userID", currentUserID)
                cmd.Parameters.AddWithValue("@action", action)
                cmd.Parameters.AddWithValue("@tableName", tableName)
                cmd.Parameters.AddWithValue("@recordID", recordID)
                cmd.Parameters.AddWithValue("@details", details)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                ' Silent fail for audit logging
            End Try
        End Using
    End Sub

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub txtNewPassword_TextChanged(sender As Object, e As EventArgs) Handles txtNewPassword.TextChanged
        UpdatePasswordStrength()
    End Sub

    Private Sub UpdatePasswordStrength()
        Dim password As String = txtNewPassword.Text
        Dim strength As Integer = 0
        
        If password.Length >= 8 Then strength += 1
        If password.Any(Function(c) Char.IsUpper(c)) Then strength += 1
        If password.Any(Function(c) Char.IsLower(c)) Then strength += 1
        If password.Any(Function(c) Char.IsDigit(c)) Then strength += 1
        If password.Any(Function(c) "!@#$%^&*()_+-=[]{}|;:,.<>?".Contains(c)) Then strength += 1
        
        Select Case strength
            Case 0 To 1
                lblPasswordStrength.Text = "Weak"
                lblPasswordStrength.ForeColor = Color.Red
            Case 2 To 3
                lblPasswordStrength.Text = "Medium"
                lblPasswordStrength.ForeColor = Color.Orange
            Case 4 To 5
                lblPasswordStrength.Text = "Strong"
                lblPasswordStrength.ForeColor = Color.Green
        End Select
    End Sub
End Class
