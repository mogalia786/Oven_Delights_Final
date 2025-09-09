Imports System

' Global time provider for the application
' Use AppTime.Now() everywhere instead of DateTime.Now or SQL GETDATE() derived values
' If needed, we can centralize timezone/UTC offsets here later.
Public Module AppTime
    Public Function Now() As DateTime
        ' Use local machine time by default
        Return DateTime.Now
    End Function

    Public Function UtcNow() As DateTime
        Return DateTime.UtcNow
    End Function
End Module
