Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.IO
Imports System.Drawing

Partial Class UserProfileForm
    Inherits Form

    Private connectionString As String
    Private currentUserID As Integer
    Private photoChanged As Boolean = False

    Public Sub New(userID As Integer)
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        currentUserID = userID
        LoadUserProfile()
        LoadUserPreferences()
    End Sub

    Private Sub LoadUserProfile()
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT Username, Email, FirstName, LastName, Role, CreatedDate, LastLogin FROM Users WHERE ID = @userID", conn)
                cmd.Parameters.AddWithValue("@userID", currentUserID)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    txtUsername.Text = reader("Username").ToString()
                    txtEmail.Text = reader("Email").ToString()
                    txtFirstName.Text = reader("FirstName").ToString()
                    txtLastName.Text = reader("LastName").ToString()
                    lblRole.Text = "Role: " & reader("Role").ToString()
                    lblCreatedDate.Text = "Member Since: " & Convert.ToDateTime(reader("CreatedDate")).ToString("MMMM dd, yyyy")
                    If Not IsDBNull(reader("LastLogin")) Then
                        lblLastLogin.Text = "Last Login: " & Convert.ToDateTime(reader("LastLogin")).ToString("MMMM dd, yyyy HH:mm")
                    Else
                        lblLastLogin.Text = "Last Login: Never"
                    End If
                End If
                reader.Close()
            Catch ex As Exception
                MessageBox.Show("Error loading user profile: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
    End Sub

    Private Sub LoadUserPreferences()
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT PreferenceName, PreferenceValue FROM UserPreferences WHERE UserID = @userID", conn)
                cmd.Parameters.AddWithValue("@userID", currentUserID)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    Dim prefName As String = reader("PreferenceName").ToString()
                    Dim prefValue As String = reader("PreferenceValue").ToString()
                    
                    Select Case prefName
                        Case "Theme"
                            cboTheme.Text = prefValue
                        Case "Language"
                            cboLanguage.Text = prefValue
                        Case "EmailNotifications"
                            chkEmailNotifications.Checked = Boolean.Parse(prefValue)
                        Case "TwoFactorEnabled"
                            chkTwoFactor.Checked = Boolean.Parse(prefValue)
                    End Select
                End While
                reader.Close()
            Catch ex As Exception
                ' Default preferences if none exist
                cboTheme.SelectedIndex = 0
                cboLanguage.SelectedIndex = 0
            End Try
        End Using
    End Sub

    Private Sub btnUploadPhoto_Click(sender As Object, e As EventArgs) Handles btnUploadPhoto.Click
        Dim openDialog As New OpenFileDialog()
        openDialog.Filter = "Image files (*.jpg, *.jpeg, *.png, *.bmp)|*.jpg;*.jpeg;*.png;*.bmp"
        openDialog.Title = "Select Profile Photo"
        
        If openDialog.ShowDialog() = DialogResult.OK Then
            Try
                Dim image As Image = Image.FromFile(openDialog.FileName)
                ' Resize image to 150x150
                Dim resizedImage As New Bitmap(150, 150)
                Using g As Graphics = Graphics.FromImage(resizedImage)
                    g.DrawImage(image, 0, 0, 150, 150)
                End Using
                
                picProfilePhoto.Image = resizedImage
                photoChanged = True
                image.Dispose()
            Catch ex As Exception
                MessageBox.Show("Error loading image: " & ex.Message, "Image Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

    Private Sub btnSaveProfile_Click(sender As Object, e As EventArgs) Handles btnSaveProfile.Click
        If ValidateProfile() Then
            If UpdateProfile() Then
                SaveUserPreferences()
                If photoChanged Then
                    SaveProfilePhoto()
                End If
                MessageBox.Show("Profile updated successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Me.DialogResult = DialogResult.OK
            End If
        End If
    End Sub

    Private Function ValidateProfile() As Boolean
        If String.IsNullOrWhiteSpace(txtEmail.Text) Then
            MessageBox.Show("Email is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtEmail.Focus()
            Return False
        End If

        If String.IsNullOrWhiteSpace(txtFirstName.Text) Then
            MessageBox.Show("First Name is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtFirstName.Focus()
            Return False
        End If

        If String.IsNullOrWhiteSpace(txtLastName.Text) Then
            MessageBox.Show("Last Name is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtLastName.Focus()
            Return False
        End If

        Return True
    End Function

    Private Function UpdateProfile() As Boolean
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("UPDATE Users SET Email=@email, FirstName=@firstName, LastName=@lastName WHERE ID=@userID", conn)
                cmd.Parameters.AddWithValue("@userID", currentUserID)
                cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim())
                cmd.Parameters.AddWithValue("@firstName", txtFirstName.Text.Trim())
                cmd.Parameters.AddWithValue("@lastName", txtLastName.Text.Trim())
                cmd.ExecuteNonQuery()
                LogAuditAction("ProfileUpdated", "Users", currentUserID, "User updated their profile")
                Return True
            Catch ex As Exception
                MessageBox.Show("Error updating profile: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Using
    End Function

    Private Sub SaveUserPreferences()
        Dim preferences As New Dictionary(Of String, String) From {
            {"Theme", cboTheme.Text},
            {"Language", cboLanguage.Text},
            {"EmailNotifications", chkEmailNotifications.Checked.ToString()},
            {"TwoFactorEnabled", chkTwoFactor.Checked.ToString()}
        }

        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                For Each pref In preferences
                    Dim cmd As New SqlCommand("IF EXISTS (SELECT 1 FROM UserPreferences WHERE UserID = @userID AND PreferenceName = @prefName) " &
                                            "UPDATE UserPreferences SET PreferenceValue = @prefValue, LastUpdated = GETDATE() WHERE UserID = @userID AND PreferenceName = @prefName " &
                                            "ELSE INSERT INTO UserPreferences (UserID, PreferenceName, PreferenceValue, LastUpdated) VALUES (@userID, @prefName, @prefValue, GETDATE())", conn)
                    cmd.Parameters.AddWithValue("@userID", currentUserID)
                    cmd.Parameters.AddWithValue("@prefName", pref.Key)
                    cmd.Parameters.AddWithValue("@prefValue", pref.Value)
                    cmd.ExecuteNonQuery()
                Next
            Catch ex As Exception
                MessageBox.Show("Error saving preferences: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
    End Sub

    Private Sub SaveProfilePhoto()
        If picProfilePhoto.Image IsNot Nothing Then
            Try
                Dim photoPath As String = Path.Combine(Application.StartupPath, "Photos", $"user_{currentUserID}.jpg")
                Directory.CreateDirectory(Path.GetDirectoryName(photoPath))
                picProfilePhoto.Image.Save(photoPath, System.Drawing.Imaging.ImageFormat.Jpeg)
            Catch ex As Exception
                MessageBox.Show("Error saving profile photo: " & ex.Message, "Photo Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End Try
        End If
    End Sub

    Private Sub btnChangePassword_Click(sender As Object, e As EventArgs) Handles btnChangePassword.Click
        Dim passwordForm As New PasswordChangeForm(currentUserID)
        passwordForm.ShowDialog()
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
End Class
