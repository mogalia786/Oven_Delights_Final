Imports Microsoft.AspNetCore.SignalR.Client
Imports System.Threading.Tasks

Public Class SignalRService
    Private connection As HubConnection
    Private _isConnected As Boolean = False
    
    Public Event UserLoggedIn As EventHandler(Of String)
    Public Event UserLoggedOut As EventHandler(Of String)
    Public Event SecurityAlert As EventHandler(Of String)
    Public Event SystemNotification As EventHandler(Of String)
    Public Event UserStatusChanged As EventHandler(Of UserStatusEventArgs)

    Public Sub New()
        ' Initialize SignalR connection
        connection = New HubConnectionBuilder().
            WithUrl("https://localhost:5001/notificationHub").
            Build()
        
        ' Set up event handlers
        SetupEventHandlers()
    End Sub

    Private Sub SetupEventHandlers()
        ' User login notification
        connection.On(Of String)("UserLoggedIn", Sub(username)
                                                     RaiseEvent UserLoggedIn(Me, username)
                                                 End Sub)

        ' User logout notification
        connection.On(Of String)("UserLoggedOut", Sub(username)
                                                      RaiseEvent UserLoggedOut(Me, username)
                                                  End Sub)

        ' Security alert notification
        connection.On(Of String)("SecurityAlert", Sub(message)
                                                      RaiseEvent SecurityAlert(Me, message)
                                                  End Sub)

        ' System notification
        connection.On(Of String)("SystemNotification", Sub(message)
                                                           RaiseEvent SystemNotification(Me, message)
                                                       End Sub)

        ' User status change notification
        connection.On(Of String, String)("UserStatusChanged", Sub(username, status)
                                                                  RaiseEvent UserStatusChanged(Me, New UserStatusEventArgs(username, status))
                                                              End Sub)
    End Sub

    Public Async Function StartAsync() As Task
        Try
            If connection.State = HubConnectionState.Disconnected Then
                Await connection.StartAsync()
                _isConnected = True
            End If
        Catch ex As Exception
            _isConnected = False
            Throw New Exception("Failed to start SignalR connection: " & ex.Message)
        End Try
    End Function

    Public Async Function StopAsync() As Task
        Try
            If connection.State = HubConnectionState.Connected Then
                Await connection.StopAsync()
                _isConnected = False
            End If
        Catch ex As Exception
            ' Log error but don't throw
        End Try
    End Function

    Public Async Function SendUserLoginNotificationAsync(username As String) As Task
        If _isConnected Then
            Try
                Await connection.InvokeAsync("NotifyUserLogin", username)
            Catch ex As Exception
                ' Log error but don't throw
            End Try
        End If
    End Function

    Public Async Function SendUserLogoutNotificationAsync(username As String) As Task
        If _isConnected Then
            Try
                Await connection.InvokeAsync("NotifyUserLogout", username)
            Catch ex As Exception
                ' Log error but don't throw
            End Try
        End If
    End Function

    Public Async Function SendSecurityAlertAsync(message As String) As Task
        If _isConnected Then
            Try
                Await connection.InvokeAsync("SendSecurityAlert", message)
            Catch ex As Exception
                ' Log error but don't throw
            End Try
        End If
    End Function

    Public Async Function SendSystemNotificationAsync(message As String) As Task
        If _isConnected Then
            Try
                Await connection.InvokeAsync("SendSystemNotification", message)
            Catch ex As Exception
                ' Log error but don't throw
            End Try
        End If
    End Function

    Public Async Function UpdateUserStatusAsync(username As String, status As String) As Task
        If _isConnected Then
            Try
                Await connection.InvokeAsync("UpdateUserStatus", username, status)
            Catch ex As Exception
                ' Log error but don't throw
            End Try
        End If
    End Function

    Public ReadOnly Property IsConnected As Boolean
        Get
            Return _isConnected AndAlso connection.State = HubConnectionState.Connected
        End Get
    End Property

    Public Sub Dispose()
        If connection IsNot Nothing Then
            Try
                connection.DisposeAsync().AsTask().Wait()
            Catch ex As Exception
                ' Silent dispose
            End Try
        End If
    End Sub
End Class

Public Class UserStatusEventArgs
    Inherits EventArgs
    
    Public Property Username As String
    Public Property Status As String
    
    Public Sub New(username As String, status As String)
        Me.Username = username
        Me.Status = status
    End Sub
End Class
