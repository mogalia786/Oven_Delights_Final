Imports System.Data.SqlClient
Imports System.Configuration

Public Class DashboardDataManager
    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERP").ConnectionString

    Public Function GetDashboardStats() As DashboardStats
        Dim stats As New DashboardStats()
        
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                ' Get user statistics
                GetUserStatistics(connection, stats)
                
                ' Get branch statistics
                GetBranchStatistics(connection, stats)
                
                ' Get session statistics
                GetSessionStatistics(connection, stats)
                
                ' Get login statistics
                GetLoginStatistics(connection, stats)
                
                ' Get security alerts
                GetSecurityAlerts(connection, stats)
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error getting dashboard stats: {ex.Message}")
        End Try
        
        Return stats
    End Function

    Private Sub GetUserStatistics(connection As SqlConnection, stats As DashboardStats)
        Try
            Dim query As String = "
                SELECT 
                    COUNT(*) as TotalUsers,
                    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) as ActiveUsers,
                    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END) as InactiveUsers,
                    SUM(CASE WHEN IsLocked = 1 THEN 1 ELSE 0 END) as LockedUsers
                FROM Users"
            
            Using command As New SqlCommand(query, connection)
                Using reader As SqlDataReader = command.ExecuteReader()
                    If reader.Read() Then
                        stats.TotalUsers = If(IsDBNull(reader("TotalUsers")), 0, CInt(reader("TotalUsers")))
                        stats.ActiveUsers = If(IsDBNull(reader("ActiveUsers")), 0, CInt(reader("ActiveUsers")))
                        stats.InactiveUsers = If(IsDBNull(reader("InactiveUsers")), 0, CInt(reader("InactiveUsers")))
                        stats.LockedUsers = If(IsDBNull(reader("LockedUsers")), 0, CInt(reader("LockedUsers")))
                    End If
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error getting user statistics: {ex.Message}")
        End Try
    End Sub

    Private Sub GetBranchStatistics(connection As SqlConnection, stats As DashboardStats)
        Try
            Dim query As String = "
                SELECT 
                    COUNT(*) as TotalBranches,
                    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) as ActiveBranches
                FROM Branches"
            
            Using command As New SqlCommand(query, connection)
                Using reader As SqlDataReader = command.ExecuteReader()
                    If reader.Read() Then
                        stats.TotalBranches = If(IsDBNull(reader("TotalBranches")), 0, CInt(reader("TotalBranches")))
                        stats.ActiveBranches = If(IsDBNull(reader("ActiveBranches")), 0, CInt(reader("ActiveBranches")))
                    End If
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error getting branch statistics: {ex.Message}")
        End Try
    End Sub

    Private Sub GetSessionStatistics(connection As SqlConnection, stats As DashboardStats)
        Try
            Dim query As String = "
                SELECT 
                    COUNT(*) as TotalSessions,
                    SUM(CASE WHEN IsActive = 1 AND ExpiryTime > GETDATE() THEN 1 ELSE 0 END) as ActiveSessions
                FROM UserSessions"
            
            Using command As New SqlCommand(query, connection)
                Using reader As SqlDataReader = command.ExecuteReader()
                    If reader.Read() Then
                        stats.TotalSessions = If(IsDBNull(reader("TotalSessions")), 0, CInt(reader("TotalSessions")))
                        stats.ActiveSessions = If(IsDBNull(reader("ActiveSessions")), 0, CInt(reader("ActiveSessions")))
                    End If
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error getting session statistics: {ex.Message}")
        End Try
    End Sub

    Private Sub GetLoginStatistics(connection As SqlConnection, stats As DashboardStats)
        Try
            Dim query As String = "
                SELECT 
                    SUM(CASE WHEN CAST(LoginTime AS DATE) = CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) as TodayLogins,
                    SUM(CASE WHEN LoginTime >= DATEADD(DAY, -7, GETDATE()) THEN 1 ELSE 0 END) as WeekLogins,
                    SUM(CASE WHEN LoginTime >= DATEADD(MONTH, -1, GETDATE()) THEN 1 ELSE 0 END) as MonthLogins
                FROM UserSessions"
            
            Using command As New SqlCommand(query, connection)
                Using reader As SqlDataReader = command.ExecuteReader()
                    If reader.Read() Then
                        stats.TodayLogins = If(IsDBNull(reader("TodayLogins")), 0, CInt(reader("TodayLogins")))
                        stats.WeekLogins = If(IsDBNull(reader("WeekLogins")), 0, CInt(reader("WeekLogins")))
                        stats.MonthLogins = If(IsDBNull(reader("MonthLogins")), 0, CInt(reader("MonthLogins")))
                    End If
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error getting login statistics: {ex.Message}")
        End Try
    End Sub

    Private Sub GetSecurityAlerts(connection As SqlConnection, stats As DashboardStats)
        Try
            Dim query As String = "
                SELECT 
                    COUNT(*) as SecurityAlerts,
                    SUM(CASE WHEN Severity = 'CRITICAL' THEN 1 ELSE 0 END) as CriticalAlerts
                FROM AuditLog 
                WHERE ActionType = 'SECURITY' 
                AND Timestamp >= DATEADD(DAY, -7, GETDATE())"
            
            Using command As New SqlCommand(query, connection)
                Using reader As SqlDataReader = command.ExecuteReader()
                    If reader.Read() Then
                        stats.SecurityAlerts = If(IsDBNull(reader("SecurityAlerts")), 0, CInt(reader("SecurityAlerts")))
                        stats.CriticalAlerts = If(IsDBNull(reader("CriticalAlerts")), 0, CInt(reader("CriticalAlerts")))
                    End If
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error getting security alerts: {ex.Message}")
        End Try
    End Sub

    Public Function GetUserActivityData() As List(Of UserActivityData)
        Dim activityData As New List(Of UserActivityData)
        
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "
                    SELECT 
                        u.ID,
                        u.Username,
                        u.FirstName + ' ' + u.LastName as FullName,
                        u.LastLogin,
                        u.IsActive,
                        COUNT(s.ID) as SessionCount,
                        MAX(s.LoginTime) as LastSessionTime
                    FROM Users u
                    LEFT JOIN UserSessions s ON u.ID = s.UserID AND s.LoginTime >= DATEADD(DAY, -30, GETDATE())
                    GROUP BY u.ID, u.Username, u.FirstName, u.LastName, u.LastLogin, u.IsActive
                    ORDER BY u.LastLogin DESC"
                
                Using command As New SqlCommand(query, connection)
                    Using reader As SqlDataReader = command.ExecuteReader()
                        While reader.Read()
                            activityData.Add(New UserActivityData With {
                                .UserID = CInt(reader("ID")),
                                .Username = reader("Username").ToString(),
                                .FullName = reader("FullName").ToString(),
                                .LastLogin = If(IsDBNull(reader("LastLogin")), Nothing, CDate(reader("LastLogin"))),
                                .IsActive = CBool(reader("IsActive")),
                                .SessionCount = If(IsDBNull(reader("SessionCount")), 0, CInt(reader("SessionCount"))),
                                .LastSessionTime = If(IsDBNull(reader("LastSessionTime")), Nothing, CDate(reader("LastSessionTime")))
                            })
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error getting user activity data: {ex.Message}")
        End Try
        
        Return activityData
    End Function

    Public Function GetBranchData() As List(Of BranchData)
        Dim branchData As New List(Of BranchData)
        
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = "
                    SELECT 
                        b.ID,
                        b.Name,
                        b.BranchCode,
                        b.IsActive,
                        COUNT(u.ID) as UserCount,
                        SUM(CASE WHEN u.IsActive = 1 THEN 1 ELSE 0 END) as ActiveUserCount
                    FROM Branches b
                    LEFT JOIN Users u ON b.ID = u.BranchID
                    GROUP BY b.ID, b.Name, b.BranchCode, b.IsActive
                    ORDER BY b.Name"
                
                Using command As New SqlCommand(query, connection)
                    Using reader As SqlDataReader = command.ExecuteReader()
                        While reader.Read()
                            branchData.Add(New BranchData With {
                                .BranchID = CInt(reader("ID")),
                                .BranchName = reader("Name").ToString(),
                                .BranchCode = reader("BranchCode").ToString(),
                                .IsActive = CBool(reader("IsActive")),
                                .UserCount = If(IsDBNull(reader("UserCount")), 0, CInt(reader("UserCount"))),
                                .ActiveUserCount = If(IsDBNull(reader("ActiveUserCount")), 0, CInt(reader("ActiveUserCount")))
                            })
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Console.WriteLine($"Error getting branch data: {ex.Message}")
        End Try
        
        Return branchData
    End Function

    Public Function GetRecentAuditLogs(limit As Integer) As List(Of AuditLogEntry)
        Dim auditLogs As New List(Of AuditLogEntry)
        
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Dim query As String = $"
                    SELECT TOP {limit}
                        a.ID,
                        a.UserID,
                        u.Username,
                        a.Action,
                        a.TableName,
                        a.RecordID,
                        a.Timestamp,
                        a.IPAddress,
                        a.ActionType,
                        a.Severity,
                        a.Description,
                        a.ModuleName
                    FROM AuditLog a
                    LEFT JOIN Users u ON a.UserID = u.ID
                    ORDER BY a.Timestamp DESC"
                
                Using command As New SqlCommand(query, connection)
                    Using reader As SqlDataReader = command.ExecuteReader()
                        While reader.Read()
                            auditLogs.Add(New AuditLogEntry With {
                                .ID = CLng(reader("ID")),
                                .UserID = If(IsDBNull(reader("UserID")), Nothing, CInt(reader("UserID"))),
                                .Action = reader("Action").ToString(),
                                .TableName = reader("TableName").ToString(),
                                .RecordID = reader("RecordID").ToString(),
                                .Timestamp = CDate(reader("Timestamp")),
                                .IPAddress = reader("IPAddress").ToString(),
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
            Console.WriteLine($"Error getting recent audit logs: {ex.Message}")
        End Try
        
        Return auditLogs
    End Function

    Public Function GetSystemHealth() As SystemHealthData
        Dim healthData As New SystemHealthData()
        
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                ' Check database connectivity
                healthData.DatabaseConnected = True
                
                ' Get database size
                Dim sizeQuery As String = "
                    SELECT 
                        SUM(size * 8.0 / 1024) as DatabaseSizeMB
                    FROM sys.master_files 
                    WHERE database_id = DB_ID()"
                
                Using command As New SqlCommand(sizeQuery, connection)
                    Dim result = command.ExecuteScalar()
                    healthData.DatabaseSizeMB = If(IsDBNull(result), 0, CDbl(result))
                End Using
                
                ' Get active connections
                Dim connectionsQuery As String = "SELECT COUNT(*) FROM sys.dm_exec_sessions WHERE is_user_process = 1"
                Using command As New SqlCommand(connectionsQuery, connection)
                    healthData.ActiveConnections = CInt(command.ExecuteScalar())
                End Using
                
                ' Get server uptime (simplified)
                healthData.ServerUptimeHours = Environment.TickCount / (1000 * 60 * 60)
                
                ' Calculate overall health score
                healthData.OverallHealthScore = CalculateHealthScore(healthData)
            End Using
        Catch ex As Exception
            healthData.DatabaseConnected = False
            healthData.OverallHealthScore = 0
            Console.WriteLine($"Error getting system health: {ex.Message}")
        End Try
        
        Return healthData
    End Function

    Private Function CalculateHealthScore(healthData As SystemHealthData) As Integer
        Dim score As Integer = 0
        
        ' Database connectivity (40 points)
        If healthData.DatabaseConnected Then score += 40
        
        ' Database size (20 points - penalize if too large)
        If healthData.DatabaseSizeMB < 1000 Then
            score += 20
        ElseIf healthData.DatabaseSizeMB < 5000 Then
            score += 15
        Else
            score += 10
        End If
        
        ' Active connections (20 points - penalize if too many)
        If healthData.ActiveConnections < 50 Then
            score += 20
        ElseIf healthData.ActiveConnections < 100 Then
            score += 15
        Else
            score += 10
        End If
        
        ' Server uptime (20 points)
        If healthData.ServerUptimeHours > 24 Then
            score += 20
        ElseIf healthData.ServerUptimeHours > 1 Then
            score += 15
        Else
            score += 10
        End If
        
        Return Math.Min(score, 100)
    End Function
End Class

Public Class UserActivityData
    Public Property UserID As Integer
    Public Property Username As String
    Public Property FullName As String
    Public Property LastLogin As DateTime?
    Public Property IsActive As Boolean
    Public Property SessionCount As Integer
    Public Property LastSessionTime As DateTime?
End Class

Public Class BranchData
    Public Property BranchID As Integer
    Public Property BranchName As String
    Public Property BranchCode As String
    Public Property IsActive As Boolean
    Public Property UserCount As Integer
    Public Property ActiveUserCount As Integer
End Class

Public Class SystemHealthData
    Public Property DatabaseConnected As Boolean
    Public Property DatabaseSizeMB As Double
    Public Property ActiveConnections As Integer
    Public Property ServerUptimeHours As Double
    Public Property OverallHealthScore As Integer
End Class
