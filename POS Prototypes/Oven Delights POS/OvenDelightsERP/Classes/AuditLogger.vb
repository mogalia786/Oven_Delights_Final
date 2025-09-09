Imports System.Data.SqlClient
Imports System.Configuration
Imports Newtonsoft.Json

Public Class AuditLogger
    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERP").ConnectionString

    Public Sub LogEvent(userId As Integer?, action As String, tableName As String, recordId As String, 
                       oldValues As String, newValues As String, description As String, moduleName As String,
                       Optional actionType As String = "INFO", Optional severity As String = "INFO")
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "
                    INSERT INTO AuditLog (UserID, Action, TableName, RecordID, OldValues, NewValues, 
                                        Timestamp, IPAddress, UserAgent, ActionType, Severity, Description, ModuleName)
                    VALUES (@UserID, @Action, @TableName, @RecordID, @OldValues, @NewValues, 
                           GETDATE(), @IPAddress, @UserAgent, @ActionType, @Severity, @Description, @ModuleName)"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@UserID", If(userId.HasValue, CObj(userId.Value), DBNull.Value))
                    command.Parameters.AddWithValue("@Action", action)
                    command.Parameters.AddWithValue("@TableName", tableName)
                    command.Parameters.AddWithValue("@RecordID", If(String.IsNullOrEmpty(recordId), DBNull.Value, CObj(recordId)))
                    command.Parameters.AddWithValue("@OldValues", If(String.IsNullOrEmpty(oldValues), DBNull.Value, CObj(oldValues)))
                    command.Parameters.AddWithValue("@NewValues", If(String.IsNullOrEmpty(newValues), DBNull.Value, CObj(newValues)))
                    command.Parameters.AddWithValue("@IPAddress", GetClientIPAddress())
                    command.Parameters.AddWithValue("@UserAgent", GetUserAgent())
                    command.Parameters.AddWithValue("@ActionType", actionType)
                    command.Parameters.AddWithValue("@Severity", severity)
                    command.Parameters.AddWithValue("@Description", description)
                    command.Parameters.AddWithValue("@ModuleName", moduleName)
                    
                    command.ExecuteNonQuery()
                End Using
            End Using
        Catch ex As Exception
            ' Log to event log or file if database logging fails
            Console.WriteLine($"Audit logging failed: {ex.Message}")
        End Try
    End Sub

    Public Sub LogUserAction(user As User, action As String, tableName As String, recordId As String,
                            oldValues As Object, newValues As Object, description As String, moduleName As String)
        Dim oldJson As String = If(oldValues IsNot Nothing, JsonConvert.SerializeObject(oldValues), Nothing)
        Dim newJson As String = If(newValues IsNot Nothing, JsonConvert.SerializeObject(newValues), Nothing)
        
        LogEvent(user.ID, action, tableName, recordId, oldJson, newJson, description, moduleName)
    End Sub

    Public Sub LogSecurityEvent(userId As Integer?, action As String, description As String, severity As String)
        LogEvent(userId, action, "Security", Nothing, Nothing, Nothing, description, "SECURITY", "SECURITY", severity)
    End Sub

    Public Sub LogLoginAttempt(username As String, success As Boolean, ipAddress As String, reason As String)
        Dim action As String = If(success, "LOGIN_SUCCESS", "LOGIN_FAILED")
        Dim severity As String = If(success, "INFO", "WARNING")
        Dim description As String = $"Login attempt for user '{username}' from IP {ipAddress}. Reason: {reason}"
        
        LogEvent(Nothing, action, "Users", username, Nothing, Nothing, description, "AUTHENTICATION", "LOGIN", severity)
    End Sub

    Public Sub LogPasswordChange(userId As Integer, success As Boolean, reason As String)
        Dim action As String = If(success, "PASSWORD_CHANGED", "PASSWORD_CHANGE_FAILED")
        Dim severity As String = If(success, "INFO", "WARNING")
        Dim description As String = $"Password change attempt. Reason: {reason}"
        
        LogEvent(userId, action, "Users", userId.ToString(), Nothing, Nothing, description, "SECURITY", "SECURITY", severity)
    End Sub

    Public Sub LogDataAccess(userId As Integer, tableName As String, recordId As String, accessType As String)
        Dim description As String = $"Data access: {accessType} operation on {tableName}"
        LogEvent(userId, $"DATA_{accessType.ToUpper()}", tableName, recordId, Nothing, Nothing, description, "DATA_ACCESS")
    End Sub

    Public Sub LogSystemEvent(action As String, description As String, severity As String)
        LogEvent(Nothing, action, "System", Nothing, Nothing, Nothing, description, "SYSTEM", "SYSTEM", severity)
    End Sub

    Private Function GetClientIPAddress() As String
        Try
            Return System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName()).AddressList(0).ToString()
        Catch
            Return "127.0.0.1"
        End Try
    End Function

    Private Function GetUserAgent() As String
        Try
            Return $"OvenDelightsERP/1.0 ({Environment.OSVersion})"
        Catch
            Return "OvenDelightsERP/1.0"
        End Try
    End Function

    Public Function GetAuditLogs(Optional startDate As DateTime? = Nothing, Optional endDate As DateTime? = Nothing,
                                Optional userId As Integer? = Nothing, Optional actionType As String = Nothing,
                                Optional severity As String = Nothing, Optional pageSize As Integer = 100,
                                Optional pageNumber As Integer = 1) As List(Of AuditLogEntry)
        Dim auditLogs As New List(Of AuditLogEntry)
        
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim whereClause As New List(Of String)
                Dim parameters As New List(Of SqlParameter)
                
                ' Build dynamic WHERE clause
                If startDate.HasValue Then
                    whereClause.Add("a.Timestamp >= @StartDate")
                    parameters.Add(New SqlParameter("@StartDate", startDate.Value))
                End If
                
                If endDate.HasValue Then
                    whereClause.Add("a.Timestamp <= @EndDate")
                    parameters.Add(New SqlParameter("@EndDate", endDate.Value))
                End If
                
                If userId.HasValue Then
                    whereClause.Add("a.UserID = @UserID")
                    parameters.Add(New SqlParameter("@UserID", userId.Value))
                End If
                
                If Not String.IsNullOrEmpty(actionType) Then
                    whereClause.Add("a.ActionType = @ActionType")
                    parameters.Add(New SqlParameter("@ActionType", actionType))
                End If
                
                If Not String.IsNullOrEmpty(severity) Then
                    whereClause.Add("a.Severity = @Severity")
                    parameters.Add(New SqlParameter("@Severity", severity))
                End If
                
                Dim whereString As String = If(whereClause.Count > 0, "WHERE " + String.Join(" AND ", whereClause), "")
                
                Dim query As String = $"
                    SELECT 
                        a.ID, a.UserID, u.Username, a.Action, a.TableName, a.RecordID,
                        a.OldValues, a.NewValues, a.Timestamp, a.IPAddress, a.UserAgent,
                        a.ActionType, a.Severity, a.Description, a.ModuleName
                    FROM AuditLog a
                    LEFT JOIN Users u ON a.UserID = u.ID
                    {whereString}
                    ORDER BY a.Timestamp DESC
                    OFFSET {(pageNumber - 1) * pageSize} ROWS
                    FETCH NEXT {pageSize} ROWS ONLY"
                
                Using command As New SqlCommand(query, connection)
                    For Each param In parameters
                        command.Parameters.Add(param)
                    Next
                    
                    Using reader As SqlDataReader = command.ExecuteReader()
                        While reader.Read()
                            auditLogs.Add(New AuditLogEntry With {
                                .ID = CLng(reader("ID")),
                                .UserID = If(IsDBNull(reader("UserID")), Nothing, CInt(reader("UserID"))),
                                .Action = reader("Action").ToString(),
                                .TableName = reader("TableName").ToString(),
                                .RecordID = reader("RecordID").ToString(),
                                .OldValues = reader("OldValues").ToString(),
                                .NewValues = reader("NewValues").ToString(),
                                .Timestamp = CDate(reader("Timestamp")),
                                .IPAddress = reader("IPAddress").ToString(),
                                .UserAgent = reader("UserAgent").ToString(),
                                .ActionType = reader("ActionType").ToString(),
                                .Severity = reader("Severity").ToString(),
                                .Description = reader("Description").ToString(),
                                .ModuleName = reader("ModuleName").ToString()
                            })
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error getting audit logs: {ex.Message}")
        End Try
        
        Return auditLogs
    End Function

    Public Function GetAuditLogCount(Optional startDate As DateTime? = Nothing, Optional endDate As DateTime? = Nothing,
                                   Optional userId As Integer? = Nothing, Optional actionType As String = Nothing,
                                   Optional severity As String = Nothing) As Integer
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim whereClause As New List(Of String)
                Dim parameters As New List(Of SqlParameter)
                
                ' Build dynamic WHERE clause (same as GetAuditLogs)
                If startDate.HasValue Then
                    whereClause.Add("Timestamp >= @StartDate")
                    parameters.Add(New SqlParameter("@StartDate", startDate.Value))
                End If
                
                If endDate.HasValue Then
                    whereClause.Add("Timestamp <= @EndDate")
                    parameters.Add(New SqlParameter("@EndDate", endDate.Value))
                End If
                
                If userId.HasValue Then
                    whereClause.Add("UserID = @UserID")
                    parameters.Add(New SqlParameter("@UserID", userId.Value))
                End If
                
                If Not String.IsNullOrEmpty(actionType) Then
                    whereClause.Add("ActionType = @ActionType")
                    parameters.Add(New SqlParameter("@ActionType", actionType))
                End If
                
                If Not String.IsNullOrEmpty(severity) Then
                    whereClause.Add("Severity = @Severity")
                    parameters.Add(New SqlParameter("@Severity", severity))
                End If
                
                Dim whereString As String = If(whereClause.Count > 0, "WHERE " + String.Join(" AND ", whereClause), "")
                Dim query As String = $"SELECT COUNT(*) FROM AuditLog {whereString}"
                
                Using command As New SqlCommand(query, connection)
                    For Each param In parameters
                        command.Parameters.Add(param)
                    Next
                    
                    Return CInt(command.ExecuteScalar())
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error getting audit log count: {ex.Message}")
            Return 0
        End Try
    End Function

    Public Sub PurgeOldAuditLogs(daysToKeep As Integer)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "DELETE FROM AuditLog WHERE Timestamp < DATEADD(DAY, @DaysToKeep, GETDATE())"
                
                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@DaysToKeep", -Math.Abs(daysToKeep))
                    Dim deletedRows As Integer = command.ExecuteNonQuery()
                    
                    LogSystemEvent("AUDIT_PURGE", $"Purged {deletedRows} audit log entries older than {daysToKeep} days", "INFO")
                End Using
            End Using
        Catch ex As Exception
            LogSystemEvent("AUDIT_PURGE_ERROR", $"Failed to purge audit logs: {ex.Message}", "ERROR")
        End Try
    End Sub
End Class
