Namespace Models
    Public Class BackupSettings
        Public Property LastBackup As DateTime?
        Public Property BackupPath As String
        Public Property CompressBackup As Boolean
        Public Property KeepBackupDays As Integer
        Public Property BackupFrequency As String
        Public Property AutoBackup As Boolean
    End Class
End Namespace
