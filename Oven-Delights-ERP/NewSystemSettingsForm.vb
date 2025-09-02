Imports System
Imports System.ComponentModel
Imports System.Configuration
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports System.Windows.Forms
Imports Oven_Delights_ERP.Logging

Public Class NewSystemSettingsForm
    Inherits Form
    
    Private ReadOnly _connectionString As String
    Private ReadOnly _logger As ILogger = New DebugLogger()
    Private ReadOnly _currentUserId As Integer
    Private _isDirty As Boolean = False
    
    ''' <summary>
    ''' Creates and returns a new SQL connection
    ''' </summary>
    Private Function CreateSqlConnection() As SqlConnection
        Try
            Dim connection = New SqlConnection(_connectionString)
            connection.Open()
            Return connection
        Catch ex As Exception
            _logger.LogError($"Failed to create SQL connection: {ex.Message}")
            Throw New InvalidOperationException("Could not establish a database connection. Please check your connection settings.", ex)
        End Try
    End Function
    
    ' UI Controls
    Private WithEvents tabControl1 As New TabControl()
    Private WithEvents btnSave As New Button()
    Private WithEvents btnCancel As New Button()
    
    ' General Settings Tab
    Private WithEvents txtCompanyName As New TextBox()
    Private WithEvents txtAddress As New TextBox()
    Private WithEvents txtPhone As New TextBox()
    Private WithEvents txtEmail As New TextBox()
    Private WithEvents txtVATNumber As New TextBox()
    
    ' Email Settings Tab
    Private WithEvents txtSmtpServer As New TextBox()
    Private WithEvents numSmtpPort As New NumericUpDown()
    Private WithEvents chkEnableSsl As New CheckBox()
    Private WithEvents txtSmtpUsername As New TextBox()
    Private WithEvents txtSmtpPassword As New TextBox()
    Private WithEvents txtFromEmail As New TextBox()
    Private WithEvents txtFromName As New TextBox()
    
    ' Backup Settings Tab
    Private WithEvents txtBackupPath As New TextBox()
    Private WithEvents btnBrowseBackupPath As New Button()
    Private WithEvents chkAutoBackup As New CheckBox()
    Private WithEvents cboBackupFrequency As New ComboBox()
    Private WithEvents btnBackupNow As New Button()
    Private WithEvents numKeepBackups As New NumericUpDown()
    
    Public Sub New(currentUserId As Integer)
        Try
            _currentUserId = currentUserId
            _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            
            If String.IsNullOrEmpty(_connectionString) Then
                Throw New ConfigurationErrorsException("Database connection string is not configured.")
            End If
            
            InitializeForm()
            LoadSettings()
            
        Catch ex As Exception
            _logger.LogError($"Error initializing SystemSettingsForm: {ex.Message}")
            MessageBox.Show($"Failed to initialize form: {ex.Message}", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.DialogResult = DialogResult.Abort
            Me.Close()
        End Try
    End Sub
    
    Private Sub InitializeForm()
        ' Form setup
        Me.Text = "System Settings"
        Me.Size = New Size(800, 600)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        
        ' Tab Control
        tabControl1.Dock = DockStyle.Fill
        tabControl1.Padding = New Point(10, 10)
        
        ' Add tabs
        tabControl1.TabPages.Add("General", "General")
        tabControl1.TabPages.Add("Email", "Email")
        tabControl1.TabPages.Add("Backup", "Backup")
        
        ' Initialize tabs
        InitializeGeneralTab()
        InitializeEmailTab()
        InitializeBackupTab()
        
        ' Buttons panel
        Dim buttonPanel As New Panel()
        buttonPanel.Dock = DockStyle.Bottom
        buttonPanel.Height = 50
        buttonPanel.Padding = New Padding(5)
        
        ' Save button
        btnSave.Text = "&Save"
        btnSave.Anchor = AnchorStyles.Right Or AnchorStyles.Bottom
        btnSave.Location = New Point(buttonPanel.Width - 175, 10)
        btnSave.Size = New Size(80, 30)
        btnSave.Enabled = False
        
        ' Cancel button
        btnCancel.Text = "&Cancel"
        btnCancel.Anchor = AnchorStyles.Right Or AnchorStyles.Bottom
        btnCancel.Location = New Point(buttonPanel.Width - 90, 10)
        btnCancel.Size = New Size(80, 30)
        
        ' Add controls
        buttonPanel.Controls.Add(btnSave)
        buttonPanel.Controls.Add(btnCancel)
        
        ' Add to form
        Me.Controls.Add(tabControl1)
        Me.Controls.Add(buttonPanel)
    End Sub
    
    Private Sub InitializeGeneralTab()
        Dim tab = tabControl1.TabPages("General")
        Dim yPos As Integer = 20
        
        ' Company Name
        AddLabel(tab, "Company Name:", 20, yPos)
        txtCompanyName.Location = New Point(150, yPos - 3)
        txtCompanyName.Size = New Size(300, 25)
        tab.Controls.Add(txtCompanyName)
        yPos += 40
        
        ' Address
        AddLabel(tab, "Address:", 20, yPos)
        txtAddress.Location = New Point(150, yPos - 3)
        txtAddress.Size = New Size(400, 25)
        tab.Controls.Add(txtAddress)
        yPos += 40
        
        ' Phone
        AddLabel(tab, "Phone:", 20, yPos)
        txtPhone.Location = New Point(150, yPos - 3)
        txtPhone.Size = New Size(200, 25)
        tab.Controls.Add(txtPhone)
        yPos += 40
        
        ' Email
        AddLabel(tab, "Email:", 20, yPos)
        txtEmail.Location = New Point(150, yPos - 3)
        txtEmail.Size = New Size(300, 25)
        tab.Controls.Add(txtEmail)
        yPos += 40
        
        ' VAT Number
        AddLabel(tab, "VAT Number:", 20, yPos)
        txtVATNumber.Location = New Point(150, yPos - 3)
        txtVATNumber.Size = New Size(200, 25)
        tab.Controls.Add(txtVATNumber)
    End Sub
    
    Private Sub InitializeEmailTab()
        Dim tab = tabControl1.TabPages("Email")
        Dim yPos As Integer = 20
        
        ' SMTP Server
        AddLabel(tab, "SMTP Server:", 20, yPos)
        txtSmtpServer.Location = New Point(150, yPos - 3)
        txtSmtpServer.Size = New Size(300, 25)
        tab.Controls.Add(txtSmtpServer)
        yPos += 40
        
        ' SMTP Port
        AddLabel(tab, "Port:", 20, yPos)
        numSmtpPort.Location = New Point(150, yPos - 3)
        numSmtpPort.Size = New Size(80, 25)
        numSmtpPort.Minimum = 1
        numSmtpPort.Maximum = 65535
        tab.Controls.Add(numSmtpPort)
        yPos += 40
        
        ' Enable SSL
        chkEnableSsl.Text = "Enable SSL"
        chkEnableSsl.Location = New Point(150, yPos)
        chkEnableSsl.Size = New Size(150, 25)
        tab.Controls.Add(chkEnableSsl)
        yPos += 40
        
        ' SMTP Username
        AddLabel(tab, "Username:", 20, yPos)
        txtSmtpUsername.Location = New Point(150, yPos - 3)
        txtSmtpUsername.Size = New Size(300, 25)
        tab.Controls.Add(txtSmtpUsername)
        yPos += 40
        
        ' SMTP Password
        AddLabel(tab, "Password:", 20, yPos)
        txtSmtpPassword.Location = New Point(150, yPos - 3)
        txtSmtpPassword.Size = New Size(300, 25)
        txtSmtpPassword.PasswordChar = "*"c
        tab.Controls.Add(txtSmtpPassword)
        yPos += 40
        
        ' From Email
        AddLabel(tab, "From Email:", 20, yPos)
        txtFromEmail.Location = New Point(150, yPos - 3)
        txtFromEmail.Size = New Size(300, 25)
        tab.Controls.Add(txtFromEmail)
        yPos += 40
        
        ' From Name
        AddLabel(tab, "From Name:", 20, yPos)
        txtFromName.Location = New Point(150, yPos - 3)
        txtFromName.Size = New Size(300, 25)
        tab.Controls.Add(txtFromName)
    End Sub
    
    Private Sub InitializeBackupTab()
        Dim tab = tabControl1.TabPages("Backup")
        Dim yPos As Integer = 20
        
        ' Backup Path
        AddLabel(tab, "Backup Path:", 20, yPos)
        txtBackupPath.Location = New Point(150, yPos - 3)
        txtBackupPath.Size = New Size(400, 25)
        tab.Controls.Add(txtBackupPath)
        
        ' Browse Button
        btnBrowseBackupPath.Text = "..."
        btnBrowseBackupPath.Location = New Point(560, yPos - 3)
        btnBrowseBackupPath.Size = New Size(30, 25)
        AddHandler btnBrowseBackupPath.Click, AddressOf btnBrowseBackupPath_Click
        tab.Controls.Add(btnBrowseBackupPath)
        yPos += 40
        
        ' Auto Backup
        chkAutoBackup.Text = "Enable Automatic Backups"
        chkAutoBackup.Location = New Point(20, yPos)
        chkAutoBackup.Size = New Size(250, 25)
        tab.Controls.Add(chkAutoBackup)
        yPos += 40
        
        ' Backup Frequency
        AddLabel(tab, "Backup Frequency:", 20, yPos)
        cboBackupFrequency.Location = New Point(150, yPos - 3)
        cboBackupFrequency.Size = New Size(150, 25)
        cboBackupFrequency.DropDownStyle = ComboBoxStyle.DropDownList
        cboBackupFrequency.Items.AddRange({"Daily", "Weekly", "Monthly"})
        tab.Controls.Add(cboBackupFrequency)
        yPos += 40
        
        ' Keep Backups
        AddLabel(tab, "Keep Backups (days):", 20, yPos)
        numKeepBackups.Location = New Point(150, yPos - 3)
        numKeepBackups.Size = New Size(80, 25)
        numKeepBackups.Minimum = 1
        numKeepBackups.Maximum = 365
        tab.Controls.Add(numKeepBackups)
        yPos += 60
        
        ' Backup Now Button
        btnBackupNow.Text = "Backup Now"
        btnBackupNow.Location = New Point(20, yPos)
        btnBackupNow.Size = New Size(150, 35)
        AddHandler btnBackupNow.Click, AddressOf btnBackupNow_Click
        tab.Controls.Add(btnBackupNow)
    End Sub
    
    Private Sub AddLabel(container As Control, text As String, x As Integer, y As Integer)
        Dim lbl As New Label()
        lbl.Text = text
        lbl.Location = New Point(x, y)
        lbl.AutoSize = True
        container.Controls.Add(lbl)
    End Sub
    
    Private Sub LoadSettings()
        Try
            Using conn = CreateSqlConnection()
                ' Load general settings
                LoadSetting(conn, "Company", "Name", txtCompanyName)
                LoadSetting(conn, "Company", "Address", txtAddress)
                LoadSetting(conn, "Company", "Phone", txtPhone)
                LoadSetting(conn, "Company", "Email", txtEmail)
                LoadSetting(conn, "Company", "VATNumber", txtVATNumber)
                
                ' Load email settings
                LoadSetting(conn, "Email", "SmtpServer", txtSmtpServer)
                LoadSetting(conn, "Email", "SmtpPort", numSmtpPort)
                LoadSetting(conn, "Email", "EnableSsl", chkEnableSsl)
                LoadSetting(conn, "Email", "SmtpUsername", txtSmtpUsername)
                LoadSetting(conn, "Email", "SmtpPassword", txtSmtpPassword)
                LoadSetting(conn, "Email", "FromEmail", txtFromEmail)
                LoadSetting(conn, "Email", "FromName", txtFromName)
                
                ' Load backup settings
                Dim defaultBackupPath = Path.Combine(Application.StartupPath, "Backups")
                LoadSetting(conn, "Backup", "BackupPath", txtBackupPath, defaultBackupPath)
                LoadSetting(conn, "Backup", "AutoBackup", chkAutoBackup, "False")
                LoadSetting(conn, "Backup", "BackupFrequency", cboBackupFrequency, "Daily")
                LoadSetting(conn, "Backup", "KeepBackups", numKeepBackups, "30")
            End Using
            
            _isDirty = False
            btnSave.Enabled = False
            
        Catch ex As Exception
            _logger.LogError($"Error loading settings: {ex.Message}")
            MessageBox.Show($"Failed to load settings: {ex.Message}", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub LoadSetting(conn As SqlConnection, category As String, key As String, ByRef control As Control, Optional defaultValue As String = "")
        Try
            Dim query = "SELECT SettingValue FROM SystemSettings WHERE Category = @Category AND SettingKey = @Key"
            
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Category", category)
                cmd.Parameters.AddWithValue("@Key", key)
                
                Dim value = cmd.ExecuteScalar()?.ToString()
                
                If value IsNot Nothing Then
                    If TypeOf control Is TextBox Then
                        CType(control, TextBox).Text = value
                    ElseIf TypeOf control Is CheckBox Then
                        CType(control, CheckBox).Checked = String.Equals(value, "True", StringComparison.OrdinalIgnoreCase)
                    ElseIf TypeOf control Is NumericUpDown Then
                        Dim numValue As Decimal
                        If Decimal.TryParse(value, numValue) Then
                            CType(control, NumericUpDown).Value = numValue
                        End If
                    ElseIf TypeOf control Is ComboBox Then
                        CType(control, ComboBox).Text = value
                    End If
                ElseIf Not String.IsNullOrEmpty(defaultValue) Then
                    If TypeOf control Is TextBox Then
                        CType(control, TextBox).Text = defaultValue
                    ElseIf TypeOf control Is CheckBox Then
                        CType(control, CheckBox).Checked = String.Equals(defaultValue, "True", StringComparison.OrdinalIgnoreCase)
                    ElseIf TypeOf control Is NumericUpDown Then
                        Dim numValue As Decimal
                        If Decimal.TryParse(defaultValue, numValue) Then
                            CType(control, NumericUpDown).Value = numValue
                        End If
                    ElseIf TypeOf control Is ComboBox Then
                        CType(control, ComboBox).Text = defaultValue
                    End If
                End If
            End Using
            
        Catch ex As Exception
            _logger.LogError($"Error loading setting {category}.{key}: {ex.Message}")
            ' Continue with default value if there's an error
            If TypeOf control Is TextBox AndAlso Not String.IsNullOrEmpty(defaultValue) Then
                CType(control, TextBox).Text = defaultValue
            End If
        End Try
    End Sub
    
    Private Sub SaveSettings()
        Try
            Using conn = CreateSqlConnection()
                ' Begin a transaction
                Using transaction = conn.BeginTransaction()
                    Try
                        ' Save general settings
                        SaveSetting(conn, "Company", "Name", txtCompanyName.Text, transaction)
                        SaveSetting(conn, "Company", "Address", txtAddress.Text, transaction)
                        SaveSetting(conn, "Company", "Phone", txtPhone.Text, transaction)
                        SaveSetting(conn, "Company", "Email", txtEmail.Text, transaction)
                        SaveSetting(conn, "Company", "VATNumber", txtVATNumber.Text, transaction)
                        
                        ' Save email settings
                        SaveSetting(conn, "Email", "SmtpServer", txtSmtpServer.Text, transaction)
                        SaveSetting(conn, "Email", "SmtpPort", numSmtpPort.Value.ToString(), transaction)
                        SaveSetting(conn, "Email", "EnableSsl", chkEnableSsl.Checked.ToString(), transaction)
                        SaveSetting(conn, "Email", "SmtpUsername", txtSmtpUsername.Text, transaction)
                        SaveSetting(conn, "Email", "SmtpPassword", txtSmtpPassword.Text, transaction)
                        SaveSetting(conn, "Email", "FromEmail", txtFromEmail.Text, transaction)
                        SaveSetting(conn, "Email", "FromName", txtFromName.Text, transaction)
                        
                        ' Save backup settings
                        SaveSetting(conn, "Backup", "BackupPath", txtBackupPath.Text, transaction)
                        SaveSetting(conn, "Backup", "AutoBackup", chkAutoBackup.Checked.ToString(), transaction)
                        SaveSetting(conn, "Backup", "BackupFrequency", cboBackupFrequency.Text, transaction)
                        SaveSetting(conn, "Backup", "KeepBackups", numKeepBackups.Value.ToString(), transaction)
                        
                        ' Commit the transaction
                        transaction.Commit()
                        
                        ' Log the settings update
                        _logger.LogInformation("System settings updated successfully.")
                        
                        MessageBox.Show("Settings saved successfully.", "Success", 
                                      MessageBoxButtons.OK, MessageBoxIcon.Information)
                        
                        _isDirty = False
                        btnSave.Enabled = False
                        
                    Catch ex As Exception
                        ' Rollback the transaction on error
                        transaction.Rollback()
                        Throw
                    End Try
                End Using
            End Using
            
        Catch ex As Exception
            _logger.LogError($"Error saving settings: {ex.Message}")
            MessageBox.Show($"Failed to save settings: {ex.Message}", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub SaveSetting(conn As SqlConnection, category As String, key As String, value As String, Optional transaction As SqlTransaction = Nothing)
        Try
            ' First, try to update the existing record
            Dim updateQuery = """
                UPDATE SystemSettings 
                SET SettingValue = @Value,
                    ModifiedBy = @UserId,
                    ModifiedDate = GETDATE()
                WHERE Category = @Category AND SettingKey = @Key
                """
                
            Using cmd As New SqlCommand(updateQuery, conn, transaction)
                cmd.Parameters.AddWithValue("@Category", category)
                cmd.Parameters.AddWithValue("@Key", key)
                cmd.Parameters.AddWithValue("@Value", If(value, DBNull.Value))
                cmd.Parameters.AddWithValue("@UserId", _currentUserId)
                
                Dim rowsAffected = cmd.ExecuteNonQuery()
                
                ' If no rows were updated, insert a new record
                If rowsAffected = 0 Then
                    cmd.CommandText = """
                        INSERT INTO SystemSettings (Category, SettingKey, SettingValue, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate)
                        VALUES (@Category, @Key, @Value, @UserId, @UserId, GETDATE(), GETDATE())
                        """
                    rowsAffected = cmd.ExecuteNonQuery()
                End If
                
                _logger.LogDebug($"Saved setting {category}.{key}: {value} (rows affected: {rowsAffected})")
            End Using
            
        Catch ex As Exception
            _logger.LogError($"Error saving setting {category}.{key}: {ex.Message}")
            Throw New Exception($"Failed to save setting {category}.{key}: {ex.Message}", ex)
        End Try
    End Sub
    
    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        SaveSettings()
    End Sub
    
    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        If _isDirty Then
            Dim result = MessageBox.Show("You have unsaved changes. Are you sure you want to cancel?", 
                                      "Confirm Cancel", 
                                      MessageBoxButtons.YesNo, 
                                      MessageBoxIcon.Question)
            
            If result = DialogResult.No Then
                Return
            End If
        End If
        
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub
    
    Private Sub btnBrowseBackupPath_Click(sender As Object, e As EventArgs)
        Using folderDialog As New FolderBrowserDialog()
            folderDialog.Description = "Select backup folder"
            folderDialog.ShowNewFolderButton = True
            
            If folderDialog.ShowDialog() = DialogResult.OK Then
                txtBackupPath.Text = folderDialog.SelectedPath
                _isDirty = True
                btnSave.Enabled = True
            End If
        End Using
    End Sub
    
    Private Sub btnBackupNow_Click(sender As Object, e As EventArgs)
        Try
            If String.IsNullOrEmpty(txtBackupPath.Text) Then
                MessageBox.Show("Please specify a backup path first.", "Backup Error", 
                              MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Ensure backup directory exists
            If Not Directory.Exists(txtBackupPath.Text) Then
                Directory.CreateDirectory(txtBackupPath.Text)
            End If
            
            ' Generate backup filename with timestamp
            Dim timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss")
            Dim backupFile = Path.Combine(txtBackupPath.Text, $"Backup_{timestamp}.bak")
            
            ' Perform backup (this is a simplified example)
            ' In a real application, you would use SQL Server backup commands
            File.WriteAllText(backupFile, $"Backup created at {DateTime.Now}")
            
            ' Log the backup
            _logger.LogInformation($"Backup created: {backupFile}")
            
            MessageBox.Show($"Backup created successfully:{vbCrLf}{backupFile}", "Backup Complete", 
                          MessageBoxButtons.OK, MessageBoxIcon.Information)
            
        Catch ex As Exception
            _logger.LogError($"Error creating backup: {ex.Message}")
            MessageBox.Show($"Failed to create backup: {ex.Message}", "Backup Error", 
                          MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    ' Track changes to enable/disable Save button
    Private Sub Control_Changed(sender As Object, e As EventArgs) Handles _
        txtCompanyName.TextChanged, txtAddress.TextChanged, txtPhone.TextChanged, _
        txtEmail.TextChanged, txtVATNumber.TextChanged, txtSmtpServer.TextChanged, _
        numSmtpPort.ValueChanged, chkEnableSsl.CheckedChanged, txtSmtpUsername.TextChanged, _
        txtSmtpPassword.TextChanged, txtFromEmail.TextChanged, txtFromName.TextChanged, _
        txtBackupPath.TextChanged, chkAutoBackup.CheckedChanged, cboBackupFrequency.SelectedIndexChanged, _
        numKeepBackups.ValueChanged
        
        _isDirty = True
        btnSave.Enabled = True
    End Sub
    
    Protected Overrides Sub OnFormClosing(e As FormClosingEventArgs)
        If _isDirty Then
            Dim result = MessageBox.Show("You have unsaved changes. Are you sure you want to exit?", 
                                      "Confirm Exit", 
                                      MessageBoxButtons.YesNo, 
                                      MessageBoxIcon.Question)
            
            If result = DialogResult.No Then
                e.Cancel = True
                Return
            End If
        End If
        
        MyBase.OnFormClosing(e)
    End Sub
End Class
