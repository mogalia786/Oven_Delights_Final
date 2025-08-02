Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.IO

Partial Class SystemSettingsForm
    Inherits Form

    Private connectionString As String

    Public Sub New()
        InitializeComponent()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        LoadSystemSettings()
    End Sub

    Private Sub LoadSystemSettings()
        LoadSecuritySettings()
        LoadNotificationSettings()
        LoadBackupSettings()
        LoadGeneralSettings()
    End Sub

    Private Sub LoadSecuritySettings()
        ' Load security configuration
        txtSessionTimeout.Text = "30" ' Default 30 minutes
        txtMaxLoginAttempts.Text = "5" ' Default 5 attempts
        txtPasswordExpiry.Text = "90" ' Default 90 days
        chkTwoFactorRequired.Checked = False
        chkIPWhitelisting.Checked = False
        
        ' Load from database if settings exist
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT SettingName, SettingValue FROM SystemSettings WHERE Category = 'Security'", conn)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    Dim settingName As String = reader("SettingName").ToString()
                    Dim settingValue As String = reader("SettingValue").ToString()
                    
                    Select Case settingName
                        Case "SessionTimeout"
                            txtSessionTimeout.Text = settingValue
                        Case "MaxLoginAttempts"
                            txtMaxLoginAttempts.Text = settingValue
                        Case "PasswordExpiry"
                            txtPasswordExpiry.Text = settingValue
                        Case "TwoFactorRequired"
                            chkTwoFactorRequired.Checked = Boolean.Parse(settingValue)
                        Case "IPWhitelisting"
                            chkIPWhitelisting.Checked = Boolean.Parse(settingValue)
                    End Select
                End While
                reader.Close()
            Catch ex As Exception
                ' Use default values if settings don't exist
            End Try
        End Using
    End Sub

    Private Sub LoadNotificationSettings()
        ' Load notification configuration
        chkEmailNotifications.Checked = True
        chkSMSNotifications.Checked = False
        txtSMTPServer.Text = "smtp.gmail.com"
        txtSMTPPort.Text = "587"
        chkSMTPSSL.Checked = True
        
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT SettingName, SettingValue FROM SystemSettings WHERE Category = 'Notifications'", conn)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    Dim settingName As String = reader("SettingName").ToString()
                    Dim settingValue As String = reader("SettingValue").ToString()
                    
                    Select Case settingName
                        Case "EmailNotifications"
                            chkEmailNotifications.Checked = Boolean.Parse(settingValue)
                        Case "SMSNotifications"
                            chkSMSNotifications.Checked = Boolean.Parse(settingValue)
                        Case "SMTPServer"
                            txtSMTPServer.Text = settingValue
                        Case "SMTPPort"
                            txtSMTPPort.Text = settingValue
                        Case "SMTPSSL"
                            chkSMTPSSL.Checked = Boolean.Parse(settingValue)
                    End Select
                End While
                reader.Close()
            Catch ex As Exception
                ' Use default values
            End Try
        End Using
    End Sub

    Private Sub LoadBackupSettings()
        ' Load backup configuration
        chkAutoBackup.Checked = True
        cboBackupFrequency.SelectedIndex = 0 ' Daily
        txtBackupPath.Text = Path.Combine(Application.StartupPath, "Backups")
        txtBackupRetention.Text = "30" ' Keep for 30 days
        
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT SettingName, SettingValue FROM SystemSettings WHERE Category = 'Backup'", conn)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    Dim settingName As String = reader("SettingName").ToString()
                    Dim settingValue As String = reader("SettingValue").ToString()
                    
                    Select Case settingName
                        Case "AutoBackup"
                            chkAutoBackup.Checked = Boolean.Parse(settingValue)
                        Case "BackupFrequency"
                            cboBackupFrequency.Text = settingValue
                        Case "BackupPath"
                            txtBackupPath.Text = settingValue
                        Case "BackupRetention"
                            txtBackupRetention.Text = settingValue
                    End Select
                End While
                reader.Close()
            Catch ex As Exception
                ' Use default values
            End Try
        End Using
    End Sub

    Private Sub LoadGeneralSettings()
        ' Load general configuration
        txtCompanyName.Text = "Oven Delights ERP"
        cboDefaultLanguage.SelectedIndex = 0 ' English
        cboDefaultTheme.SelectedIndex = 0 ' Light
        chkMaintenanceMode.Checked = False
        
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("SELECT SettingName, SettingValue FROM SystemSettings WHERE Category = 'General'", conn)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    Dim settingName As String = reader("SettingName").ToString()
                    Dim settingValue As String = reader("SettingValue").ToString()
                    
                    Select Case settingName
                        Case "CompanyName"
                            txtCompanyName.Text = settingValue
                        Case "DefaultLanguage"
                            cboDefaultLanguage.Text = settingValue
                        Case "DefaultTheme"
                            cboDefaultTheme.Text = settingValue
                        Case "MaintenanceMode"
                            chkMaintenanceMode.Checked = Boolean.Parse(settingValue)
                    End Select
                End While
                reader.Close()
            Catch ex As Exception
                ' Use default values
            End Try
        End Using
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If ValidateSettings() Then
            If SaveAllSettings() Then
                MessageBox.Show("System settings saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Me.DialogResult = DialogResult.OK
            End If
        End If
    End Sub

    Private Function ValidateSettings() As Boolean
        ' Validate session timeout
        Dim sessionTimeout As Integer
        If Not Integer.TryParse(txtSessionTimeout.Text, sessionTimeout) OrElse sessionTimeout < 5 OrElse sessionTimeout > 480 Then
            MessageBox.Show("Session timeout must be between 5 and 480 minutes.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtSessionTimeout.Focus()
            Return False
        End If

        ' Validate max login attempts
        Dim maxAttempts As Integer
        If Not Integer.TryParse(txtMaxLoginAttempts.Text, maxAttempts) OrElse maxAttempts < 3 OrElse maxAttempts > 10 Then
            MessageBox.Show("Max login attempts must be between 3 and 10.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtMaxLoginAttempts.Focus()
            Return False
        End If

        ' Validate SMTP port
        Dim smtpPort As Integer
        If Not Integer.TryParse(txtSMTPPort.Text, smtpPort) OrElse smtpPort < 1 OrElse smtpPort > 65535 Then
            MessageBox.Show("SMTP port must be between 1 and 65535.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtSMTPPort.Focus()
            Return False
        End If

        Return True
    End Function

    Private Function SaveAllSettings() As Boolean
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                
                ' Create SystemSettings table if it doesn't exist
                CreateSystemSettingsTable(conn)
                
                ' Save all settings
                SaveSetting(conn, "Security", "SessionTimeout", txtSessionTimeout.Text)
                SaveSetting(conn, "Security", "MaxLoginAttempts", txtMaxLoginAttempts.Text)
                SaveSetting(conn, "Security", "PasswordExpiry", txtPasswordExpiry.Text)
                SaveSetting(conn, "Security", "TwoFactorRequired", chkTwoFactorRequired.Checked.ToString())
                SaveSetting(conn, "Security", "IPWhitelisting", chkIPWhitelisting.Checked.ToString())
                
                SaveSetting(conn, "Notifications", "EmailNotifications", chkEmailNotifications.Checked.ToString())
                SaveSetting(conn, "Notifications", "SMSNotifications", chkSMSNotifications.Checked.ToString())
                SaveSetting(conn, "Notifications", "SMTPServer", txtSMTPServer.Text)
                SaveSetting(conn, "Notifications", "SMTPPort", txtSMTPPort.Text)
                SaveSetting(conn, "Notifications", "SMTPSSL", chkSMTPSSL.Checked.ToString())
                
                SaveSetting(conn, "Backup", "AutoBackup", chkAutoBackup.Checked.ToString())
                SaveSetting(conn, "Backup", "BackupFrequency", cboBackupFrequency.Text)
                SaveSetting(conn, "Backup", "BackupPath", txtBackupPath.Text)
                SaveSetting(conn, "Backup", "BackupRetention", txtBackupRetention.Text)
                
                SaveSetting(conn, "General", "CompanyName", txtCompanyName.Text)
                SaveSetting(conn, "General", "DefaultLanguage", cboDefaultLanguage.Text)
                SaveSetting(conn, "General", "DefaultTheme", cboDefaultTheme.Text)
                SaveSetting(conn, "General", "MaintenanceMode", chkMaintenanceMode.Checked.ToString())
                
                LogAuditAction("SystemSettingsUpdated", "SystemSettings", Nothing, "System settings updated")
                Return True
            Catch ex As Exception
                MessageBox.Show("Error saving system settings: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End Try
        End Using
    End Function

    Private Sub CreateSystemSettingsTable(conn As SqlConnection)
        Try
            Dim cmd As New SqlCommand("IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SystemSettings' AND xtype='U') " &
                                    "CREATE TABLE SystemSettings (ID int IDENTITY(1,1) PRIMARY KEY, Category nvarchar(50), SettingName nvarchar(100), SettingValue nvarchar(500), LastUpdated datetime DEFAULT GETDATE())", conn)
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            ' Table might already exist
        End Try
    End Sub

    Private Sub SaveSetting(conn As SqlConnection, category As String, settingName As String, settingValue As String)
        Dim cmd As New SqlCommand("IF EXISTS (SELECT 1 FROM SystemSettings WHERE Category = @category AND SettingName = @settingName) " &
                                "UPDATE SystemSettings SET SettingValue = @settingValue, LastUpdated = GETDATE() WHERE Category = @category AND SettingName = @settingName " &
                                "ELSE INSERT INTO SystemSettings (Category, SettingName, SettingValue, LastUpdated) VALUES (@category, @settingName, @settingValue, GETDATE())", conn)
        cmd.Parameters.AddWithValue("@category", category)
        cmd.Parameters.AddWithValue("@settingName", settingName)
        cmd.Parameters.AddWithValue("@settingValue", settingValue)
        cmd.ExecuteNonQuery()
    End Sub

    Private Sub LogAuditAction(action As String, tableName As String, recordID As Integer?, details As String)
        Using conn As New SqlConnection(connectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand("INSERT INTO AuditLog (UserID, Action, TableName, RecordID, Details, Timestamp) VALUES (NULL, @action, @tableName, @recordID, @details, GETDATE())", conn)
                cmd.Parameters.AddWithValue("@action", action)
                cmd.Parameters.AddWithValue("@tableName", tableName)
                cmd.Parameters.AddWithValue("@recordID", If(recordID.HasValue, recordID.Value, DBNull.Value))
                cmd.Parameters.AddWithValue("@details", details)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                ' Silent fail for audit logging
            End Try
        End Using
    End Sub

    Private Sub btnTestConnection_Click(sender As Object, e As EventArgs) Handles btnTestConnection.Click
        Try
            Using conn As New SqlConnection(connectionString)
                conn.Open()
                MessageBox.Show("Database connection successful!", "Connection Test", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End Using
        Catch ex As Exception
            MessageBox.Show("Database connection failed: " & ex.Message, "Connection Test", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnBrowseBackupPath_Click(sender As Object, e As EventArgs) Handles btnBrowseBackupPath.Click
        Dim folderDialog As New FolderBrowserDialog()
        folderDialog.Description = "Select backup folder"
        folderDialog.SelectedPath = txtBackupPath.Text
        
        If folderDialog.ShowDialog() = DialogResult.OK Then
            txtBackupPath.Text = folderDialog.SelectedPath
        End If
    End Sub

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub
End Class
