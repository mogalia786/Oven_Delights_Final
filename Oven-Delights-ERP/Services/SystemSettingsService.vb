Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Collections.Generic
Imports System.Data
Imports Oven_Delights_ERP.Models

Public Class SystemSettingsService
    Implements IDisposable
    
    Private ReadOnly _connectionString As String
    
    Public Sub New()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub
    
    Public Function GetSystemSettings(category As String) As DataTable
        Dim dt As New DataTable()
        
        Using conn As New SqlConnection(_connectionString)
            Dim query = """
                SELECT SettingID, SettingName, SettingValue, DataType, Category, 
                       Description, IsEncrypted, ModifiedBy, ModifiedDate
                FROM SystemSettings
                WHERE Category = @Category
                ORDER BY DisplayOrder, SettingName
            """
            
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Category", category)
                
                Try
                    conn.Open()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                Catch ex As Exception
                    ' Log error
                    Throw New Exception($"Error loading system settings for category '{category}': {ex.Message}", ex)
                End Try
            End Using
        End Using
        
        Return dt
    End Function
    
    Public Function GetSystemSettingValue(settingName As String, Optional defaultValue As String = "") As String
        Using conn As New SqlConnection(_connectionString)
            Dim query = "SELECT SettingValue FROM SystemSettings WHERE SettingName = @SettingName"
            
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@SettingName", settingName)
                
                Try
                    conn.Open()
                    Dim result = cmd.ExecuteScalar()
                    Return If(result IsNot Nothing AndAlso Not IsDBNull(result), result.ToString(), defaultValue)
                Catch ex As Exception
                    ' Log error
                    Debug.WriteLine($"Error getting system setting '{settingName}': {ex.Message}")
                    Return defaultValue
                End Try
            End Using
        End Using
    End Function
    
    Public Function SaveSystemSettings(settings As Dictionary(Of String, String), category As String, userId As Integer) As Boolean
        Using conn As New SqlConnection(_connectionString)
            conn.Open()
            Using transaction = conn.BeginTransaction()
                Try
                    Dim query = """
                        IF EXISTS (SELECT 1 FROM SystemSettings WHERE SettingName = @SettingName)
                            UPDATE SystemSettings 
                            SET SettingValue = @SettingValue,
                                ModifiedBy = @ModifiedBy,
                                ModifiedDate = GETDATE()
                            WHERE SettingName = @SettingName
                        ELSE
                            INSERT INTO SystemSettings 
                                (SettingName, SettingValue, DataType, Category, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
                            VALUES 
                                (@SettingName, @SettingValue, 'String', @Category, @ModifiedBy, GETDATE(), @ModifiedBy, GETDATE())
                    """
                    
                    Using cmd As New SqlCommand(query, conn, transaction)
                        cmd.Parameters.Add("@SettingName", SqlDbType.NVarChar, 100)
                        cmd.Parameters.Add("@SettingValue", SqlDbType.NVarChar, -1)
                        cmd.Parameters.Add("@Category", SqlDbType.NVarChar, 50)
                        cmd.Parameters.Add("@ModifiedBy", SqlDbType.Int)
                        
                        cmd.Parameters("@Category").Value = category
                        cmd.Parameters("@ModifiedBy").Value = userId
                        
                        For Each setting In settings
                            cmd.Parameters("@SettingName").Value = setting.Key
                            cmd.Parameters("@SettingValue").Value = If(setting.Value, DBNull.Value)
                            cmd.ExecuteNonQuery()
                        Next
                        
                        transaction.Commit()
                        Return True
                    End Using
                Catch ex As Exception
                    transaction.Rollback()
                    ' Log error
                    Throw New Exception($"Error saving system settings: {ex.Message}", ex)
                End Try
            End Using
        End Using
    End Function
    
    Public Function GetSystemSettingsAsDictionary(category As String) As Dictionary(Of String, String)
        Dim settings = New Dictionary(Of String, String)(StringComparer.OrdinalIgnoreCase)
        
        Using dt = GetSystemSettings(category)
            For Each row As DataRow In dt.Rows
                settings(row("SettingName").ToString()) = row("SettingValue").ToString()
            Next
        End Using
        
        Return settings
    End Function
    
    Public Function GetBackupSettings() As BackupSettings
        Dim settings = GetSystemSettingsAsDictionary("Backup")
        
        Return New BackupSettings With {
            .AutoBackup = Boolean.Parse(GetSettingValue(settings, "AutoBackup", "False")),
            .BackupFrequency = GetSettingValue(settings, "BackupFrequency", "Daily"),
            .BackupPath = GetSettingValue(settings, "BackupPath", String.Empty),
            .KeepBackupDays = Integer.Parse(GetSettingValue(settings, "KeepBackupDays", "30")),
            .CompressBackup = Boolean.Parse(GetSettingValue(settings, "CompressBackup", "True")),
            .LastBackup = If(DateTime.TryParse(GetSettingValue(settings, "LastBackup", String.Empty), Nothing), 
                           DateTime.Parse(settings("LastBackup")), 
                           DirectCast(Nothing, DateTime?))
        }
    End Function
    
    Public Function GetSecuritySettings() As SecuritySettings
        Dim settings = GetSystemSettingsAsDictionary("Security")
        
        Return New SecuritySettings With {
            .SessionTimeout = Integer.Parse(GetSettingValue(settings, "SessionTimeout", "30")),
            .MaxLoginAttempts = Integer.Parse(GetSettingValue(settings, "MaxLoginAttempts", "5")),
            .PasswordExpiryDays = Integer.Parse(GetSettingValue(settings, "PasswordExpiryDays", "90")),
            .TwoFactorRequired = Boolean.Parse(GetSettingValue(settings, "TwoFactorRequired", "False")),
            .IPWhitelistingEnabled = Boolean.Parse(GetSettingValue(settings, "IPWhitelistingEnabled", "False")),
            .PasswordComplexity = Integer.Parse(GetSettingValue(settings, "PasswordComplexity", "2")),
            .InactiveSessionTimeout = Integer.Parse(GetSettingValue(settings, "InactiveSessionTimeout", "15"))
        }
    End Function
    
    Public Function GetEmailSettings() As EmailSettings
        Dim settings = GetSystemSettingsAsDictionary("Email")
        
        Return New EmailSettings With {
            .SmtpServer = GetSettingValue(settings, "SmtpServer", String.Empty),
            .SmtpPort = Integer.Parse(GetSettingValue(settings, "SmtpPort", "587")),
            .SmtpUsername = GetSettingValue(settings, "SmtpUsername", String.Empty),
            .SmtpPassword = GetSettingValue(settings, "SmtpPassword", String.Empty),
            .EnableSsl = Boolean.Parse(GetSettingValue(settings, "EnableSsl", "True")),
            .FromEmail = GetSettingValue(settings, "FromEmail", String.Empty),
            .FromName = GetSettingValue(settings, "FromName", "Oven Delights ERP")
        }
    End Function
    
    Public Function GetGeneralSettings() As GeneralSettings
        Dim settings = GetSystemSettingsAsDictionary("General")
        
        Return New GeneralSettings With {
            .CompanyName = GetSettingValue(settings, "CompanyName", "Oven Delights"),
            .DefaultBranchId = Integer.Parse(GetSettingValue(settings, "DefaultBranchId", "1")),
            .DefaultCurrency = GetSettingValue(settings, "DefaultCurrency", "ZAR"),
            .DateFormat = GetSettingValue(settings, "DateFormat", "yyyy-MM-dd"),
            .TimeFormat = GetSettingValue(settings, "TimeFormat", "HH:mm"),
            .ItemsPerPage = Integer.Parse(GetSettingValue(settings, "ItemsPerPage", "50")),
            .EnableAuditLog = Boolean.Parse(GetSettingValue(settings, "EnableAuditLog", "True")),
            .AuditLogRetentionDays = Integer.Parse(GetSettingValue(settings, "AuditLogRetentionDays", "365"))
        }
    End Function
    
    Private Function GetSettingValue(settings As Dictionary(Of String, String), key As String, defaultValue As String) As String
        Return If(settings.ContainsKey(key), settings(key), defaultValue)
    End Function
    
    Public Sub Dispose() Implements IDisposable.Dispose
        ' Cleanup if needed
    End Sub
End Class

Public Class SecuritySettings
    Public Property SessionTimeout As Integer ' in minutes
    Public Property MaxLoginAttempts As Integer
    Public Property PasswordExpiryDays As Integer
    Public Property TwoFactorRequired As Boolean
    Public Property IPWhitelistingEnabled As Boolean
    Public Property PasswordComplexity As Integer ' 1=Low, 2=Medium, 3=High
    Public Property InactiveSessionTimeout As Integer ' in minutes
End Class

Public Class BackupSettings
    Public Property AutoBackup As Boolean
    Public Property BackupFrequency As String ' Daily, Weekly, Monthly
    Public Property BackupPath As String
    Public Property KeepBackupDays As Integer
    Public Property CompressBackup As Boolean
    Public Property LastBackup As DateTime?
End Class

Public Class EmailSettings
    Public Property SmtpServer As String
    Public Property SmtpPort As Integer
    Public Property SmtpUsername As String
    Public Property SmtpPassword As String
    Public Property EnableSsl As Boolean
    Public Property FromEmail As String
    Public Property FromName As String
End Class

Public Class GeneralSettings
    Public Property CompanyName As String
    Public Property DefaultBranchId As Integer
    Public Property DefaultCurrency As String
    Public Property DateFormat As String
    Public Property TimeFormat As String
    Public Property ItemsPerPage As Integer
    Public Property EnableAuditLog As Boolean
    Public Property AuditLogRetentionDays As Integer
End Class
