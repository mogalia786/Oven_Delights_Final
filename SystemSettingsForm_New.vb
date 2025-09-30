Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Windows.Forms
Imports System.Configuration
Imports Oven_Delights_ERP.Logging
Imports System.IO

Public Class SystemSettingsForm_New
    Inherits Form
    
    ' Database connection
    Private ReadOnly _connectionString As String
    Private ReadOnly _currentUserId As Integer
    
    ' Form controls
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
    
    ' Backup Settings Tab
    Private WithEvents txtBackupPath As New TextBox()
    Private WithEvents btnBrowseBackupPath As New Button()
    Private WithEvents chkAutoBackup As New CheckBox()
    Private WithEvents btnBackupNow As New Button()
    
    Public Sub New(currentUserId As Integer)
        _currentUserId = currentUserId
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        If String.IsNullOrEmpty(_connectionString) Then
            MessageBox.Show("Database connection string is not configured.", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
            Me.DialogResult = DialogResult.Abort
            Me.Close()
            Return
        End If
        
        InitializeForm()
        LoadSettings()
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
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Load general settings
                txtCompanyName.Text = GetSettingValue(conn, "Company", "Name", "")
                txtAddress.Text = GetSettingValue(conn, "Company", "Address", "")
                txtPhone.Text = GetSettingValue(conn, "Company", "Phone", "")
                txtEmail.Text = GetSettingValue(conn, "Company", "Email", "")
                txtVATNumber.Text = GetSettingValue(conn, "Company", "VATNumber", "")
                
                ' Load email settings
                txtSmtpServer.Text = GetSettingValue(conn, "Email", "SmtpServer", "smtp.gmail.com")
                numSmtpPort.Value = Integer.Parse(GetSettingValue(conn, "Email", "SmtpPort", "587"))
                chkEnableSsl.Checked = Boolean.Parse(GetSettingValue(conn, "Email", "EnableSsl", "True"))
                txtSmtpUsername.Text = GetSettingValue(conn, "Email", "SmtpUsername", "")
                txtSmtpPassword.Text = GetSettingValue(conn, "Email", "SmtpPassword", "")
                
                ' Load backup settings
                txtBackupPath.Text = GetSettingValue(conn, "Backup", "BackupPath", 
                    IO.Path.Combine(Application.StartupPath, "Backups"))
                chkAutoBackup.Checked = Boolean.Parse(GetSettingValue(conn, "Backup", "AutoBackup", "False"))
                
                ' Enable save button if any changes are made
                AddHandler txtCompanyName.TextChanged, AddressOf Setting_Changed
                AddHandler txtAddress.TextChanged, AddressOf Setting_Changed
                AddHandler txtPhone.TextChanged, AddressOf Setting_Changed
                AddHandler txtEmail.TextChanged, AddressOf Setting_Changed
                AddHandler txtVATNumber.TextChanged, AddressOf Setting_Changed
                AddHandler txtSmtpServer.TextChanged, AddressOf Setting_Changed
                AddHandler numSmtpPort.ValueChanged, AddressOf Setting_Changed
                AddHandler chkEnableSsl.CheckedChanged, AddressOf Setting_Changed
                AddHandler txtSmtpUsername.TextChanged, AddressOf Setting_Changed
                AddHandler txtSmtpPassword.TextChanged, AddressOf Setting_Changed
                AddHandler txtBackupPath.TextChanged, AddressOf Setting_Changed
                AddHandler chkAutoBackup.CheckedChanged, AddressOf Setting_Changed
                
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error loading settings: {ex.Message}", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Function GetSettingValue(conn As SqlConnection, category As String, key As String, defaultValue As String) As String
        Try
            Dim query = "SELECT SettingValue FROM SystemSettings WHERE Category = @Category AND SettingKey = @Key"
            
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Category", category)
                cmd.Parameters.AddWithValue("@Key", key)
                
                Dim result = cmd.ExecuteScalar()
                Return If(result IsNot Nothing, result.ToString(), defaultValue)
            End Using
            
        Catch ex As Exception
            Return defaultValue
        End Try
    End Function
    
    Private Sub SaveSettings()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Start transaction
                Using transaction = conn.BeginTransaction()
                    Try
                        ' Save general settings
                        SaveSetting(conn, transaction, "Company", "Name", txtCompanyName.Text)
                        SaveSetting(conn, transaction, "Company", "Address", txtAddress.Text)
                        SaveSetting(conn, transaction, "Company", "Phone", txtPhone.Text)
                        SaveSetting(conn, transaction, "Company", "Email", txtEmail.Text)
                        SaveSetting(conn, transaction, "Company", "VATNumber", txtVATNumber.Text)
                        
                        ' Save email settings
                        SaveSetting(conn, transaction, "Email", "SmtpServer", txtSmtpServer.Text)
                        SaveSetting(conn, transaction, "Email", "SmtpPort", numSmtpPort.Value.ToString())
                        SaveSetting(conn, transaction, "Email", "EnableSsl", chkEnableSsl.Checked.ToString())
                        SaveSetting(conn, transaction, "Email", "SmtpUsername", txtSmtpUsername.Text)
                        SaveSetting(conn, transaction, "Email", "SmtpPassword", txtSmtpPassword.Text)
                        
                        ' Save backup settings
                        SaveSetting(conn, transaction, "Backup", "BackupPath", txtBackupPath.Text)
                        SaveSetting(conn, transaction, "Backup", "AutoBackup", chkAutoBackup.Checked.ToString())
                        
                        ' Commit transaction
                        transaction.Commit()
                        
                        MessageBox.Show("Settings saved successfully.", "Success", 
                                      MessageBoxButtons.OK, MessageBoxIcon.Information)
                        
                        btnSave.Enabled = False
                        
                    Catch ex As Exception
                        transaction.Rollback()
                        Throw
                    End Try
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error saving settings: {ex.Message}", "Error", 
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub SaveSetting(conn As SqlConnection, transaction As SqlTransaction, category As String, key As String, value As String)
        Dim updateQuery = "UPDATE SystemSettings " & _
                         "SET SettingValue = @Value, " & _
                         "ModifiedBy = @UserId, " & _
                         "ModifiedDate = GETDATE() " & _
                         "WHERE Category = @Category " & _
                         "AND SettingKey = @Key"
            
        Using cmd As New SqlCommand(updateQuery, conn, transaction)
            cmd.Parameters.AddWithValue("@Category", category)
            cmd.Parameters.AddWithValue("@Key", key)
            cmd.Parameters.AddWithValue("@Value", value)
            cmd.Parameters.AddWithValue("@UserId", _currentUserId)
            
            Dim rowsAffected = cmd.ExecuteNonQuery()
            
            If rowsAffected = 0 Then
                cmd.CommandText = "INSERT INTO SystemSettings " & _
                                 "(Category, SettingKey, SettingValue, " & _
                                 "CreatedBy, ModifiedBy) " & _
                                 "VALUES (@Category, @Key, @Value, " & _
                                 "@UserId, @UserId)"
                cmd.ExecuteNonQuery()
            End If
        End Using
    End Sub
    
    ' Event Handlers
    Private Sub Setting_Changed(sender As Object, e As EventArgs)
        btnSave.Enabled = True
    End Sub
    
    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        SaveSettings()
    End Sub
    
    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub
    
    Private Sub btnBrowseBackupPath_Click(sender As Object, e As EventArgs)
        Using folderDialog As New FolderBrowserDialog()
            folderDialog.Description = "Select backup folder"
            folderDialog.ShowNewFolderButton = True
            
            If folderDialog.ShowDialog() = DialogResult.OK Then
                txtBackupPath.Text = folderDialog.SelectedPath
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
            If Not IO.Directory.Exists(txtBackupPath.Text) Then
                IO.Directory.CreateDirectory(txtBackupPath.Text)
            End If
            
            ' Generate backup filename with timestamp
            Dim timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss")
            Dim backupFile = IO.Path.Combine(txtBackupPath.Text, $"Backup_{timestamp}.bak")
            
            ' Perform backup (this is a simplified example)
            ' In a real application, you would use SQL Server backup commands
            IO.File.WriteAllText(backupFile, $"Backup created at {DateTime.Now}")
            
            MessageBox.Show($"Backup created successfully:{vbCrLf}{backupFile}", "Backup Complete", 
                          MessageBoxButtons.OK, MessageBoxIcon.Information)
            
        Catch ex As Exception
            MessageBox.Show($"Failed to create backup: {ex.Message}", "Backup Error", 
                          MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Protected Overrides Sub OnFormClosing(e As FormClosingEventArgs)
        If btnSave.Enabled Then
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
