Imports System.Windows.Forms
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.IO
Imports System.Drawing

Partial Class UserProfileForm
    Inherits Form

    Private connectionString As String
    Private currentID As Integer
    Private photoChanged As Boolean = False

    Public Sub New(ID As Integer)
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        currentID = ID
        LoadUserProfile()
        LoadUserPreferences()
    End Sub

    Private Sub LoadUserProfile()
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT Username, Email, FirstName, LastName, RoleID, CreatedDate, LastLogin FROM Users WHERE UserID = @UserID", conn)
                cmd.Parameters.AddWithValue("@UserID", currentID)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    txtUsername.Text = reader("Username").ToString()
                    txtEmail.Text = reader("Email").ToString()
                    txtFirstName.Text = reader("FirstName").ToString()
                    txtLastName.Text = reader("LastName").ToString()
                    ' Get RoleID and look up RoleName from Roles table
                    Dim roleID As Integer = Convert.ToInt32(reader("RoleID"))
                    Dim roleName As String = GetRoleName(roleID)
                    lblRole.Text = "Role: " & roleName
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
                Dim cmd As New SqlCommand("SELECT PreferenceName, PreferenceValue FROM UserPreferences WHERE UserID = @UserID", conn)
                cmd.Parameters.AddWithValue("@UserID", currentID)
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
                        Case "BranchID"
                            
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
                Dim cmd As New SqlCommand("UPDATE Users SET Email=@email, FirstName=@firstName, LastName=@lastName WHERE UserID=@UserID", conn)
                cmd.Parameters.AddWithValue("@UserID", currentID)
                cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim())
                cmd.Parameters.AddWithValue("@firstName", txtFirstName.Text.Trim())
                cmd.Parameters.AddWithValue("@lastName", txtLastName.Text.Trim())
                cmd.ExecuteNonQuery()
                LogAuditAction("ProfileUpdated", "Users", currentID, "User updated their profile")
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
                    Dim cmd As New SqlCommand("IF EXISTS (SELECT 1 FROM UserPreferences WHERE UserID = @UserID AND PreferenceName = @prefName) " &
                                            "UPDATE UserPreferences SET PreferenceValue = @prefValue, LastUpdated = GETDATE() WHERE UserID = @UserID AND PreferenceName = @prefName " &
                                            "ELSE INSERT INTO UserPreferences (UserID, PreferenceName, PreferenceValue, LastUpdated) VALUES (@UserID, @prefName, @prefValue, GETDATE())", conn)
                    cmd.Parameters.AddWithValue("@UserID", currentID)
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
                Dim photoPath As String = IO.Path.Combine(Application.StartupPath, "Photos", $"user_{currentID}.jpg")
                IO.Directory.CreateDirectory(IO.Path.GetDirectoryName(photoPath))
                picProfilePhoto.Image.Save(photoPath, System.Drawing.Imaging.ImageFormat.Jpeg)
            Catch ex As Exception
                MessageBox.Show("Error saving profile photo: " & ex.Message, "Photo Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End Try
        End If
    End Sub

    Private Sub btnChangePassword_Click(sender As Object, e As EventArgs) Handles btnChangePassword.Click
        Dim passwordForm As New PasswordChangeForm(currentID)
        passwordForm.ShowDialog()
    End Sub

    Private Function GetRoleName(roleID As Integer) As String
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT RoleName FROM Roles WHERE RoleID = @RoleID", conn)
                cmd.Parameters.AddWithValue("@RoleID", roleID)
                Dim result = cmd.ExecuteScalar()
                Return If(result IsNot Nothing, result.ToString(), "Unknown Role")
            Catch ex As Exception
                MessageBox.Show("Error retrieving role name: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return "Unknown Role"
            End Try
        End Using
    End Function

    Private Sub LogAuditAction(action As String, tableName As String, recordID As Integer, details As String)
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Details, Timestamp) VALUES (@UserID, @action, @tableName, @recordID, @details, GETDATE())", conn)
                cmd.Parameters.AddWithValue("@UserID", currentID)
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
