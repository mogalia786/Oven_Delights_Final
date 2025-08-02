Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class LoginForm
    Private Sub btnLogin_Click(sender As Object, e As EventArgs) Handles btnLogin.Click
        Dim username As String = txtEmail.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()

        If username = "" Or password = "" Then
            MessageBox.Show("Please enter both username and password.", "Login Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return
        End If

        Dim connStr As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Using conn As New SqlConnection(connStr)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT ID, Username, Email, FirstName, LastName, Role, BranchID, IsActive, Password FROM Users WHERE Username=@username", conn)
                cmd.Parameters.AddWithValue("@username", username)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    Dim loggedInUser As New User() With {
                        .UserID = CInt(reader("ID")),
                        .Username = reader("Username").ToString(),
                        .Email = reader("Email").ToString(),
                        .FirstName = If(reader("FirstName") IsNot DBNull.Value, reader("FirstName").ToString(), ""),
                        .LastName = If(reader("LastName") IsNot DBNull.Value, reader("LastName").ToString(), ""),
                        .Role = If(reader("Role") IsNot DBNull.Value, reader("Role").ToString(), "User"),
                        .BranchID = If(reader("BranchID") IsNot DBNull.Value, CInt(reader("BranchID")), Nothing),
                        .IsActive = CBool(reader("IsActive"))
                    }
                    
                    Dim dbPassword As String = reader("Password").ToString()
                    If password = dbPassword Then
                        ' Login successful - no dialog needed
                        
                        ' Open main dashboard with user context
                        Dim dashboard As New MainDashboard()
                        dashboard.SetCurrentUser(loggedInUser)
                        dashboard.Show()
                        Me.Hide()
                    Else
                        MessageBox.Show("Invalid username or password.", "Login Failed", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    End If
                Else
                    MessageBox.Show("Invalid username or password.", "Login Failed", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End If
            Catch ex As Exception
                MessageBox.Show("Error connecting to database: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
    End Sub
End Class