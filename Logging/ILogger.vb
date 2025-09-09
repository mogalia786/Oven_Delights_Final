Namespace Logging
    Public Interface ILogger
        Sub LogInformation(message As String)
        Sub LogWarning(message As String)
        Sub LogError(message As String)
        Sub LogDebug(message As String)
    End Interface
    
    Public Class DebugLogger
        Implements ILogger
        
        Public Sub LogInformation(message As String) Implements ILogger.LogInformation
            Debug.WriteLine($"[INFO] {DateTime.Now}: {message}")
        End Sub
        
        Public Sub LogWarning(message As String) Implements ILogger.LogWarning
            Debug.WriteLine($"[WARN] {DateTime.Now}: {message}")
        End Sub
        
        Public Sub LogError(message As String) Implements ILogger.LogError
            Debug.WriteLine($"[ERROR] {DateTime.Now}: {message}")
        End Sub
        
        Public Sub LogDebug(message As String) Implements ILogger.LogDebug
            Debug.WriteLine($"[DEBUG] {DateTime.Now}: {message}")
        End Sub
    End Class
End Namespace
