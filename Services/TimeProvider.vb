Imports System

Namespace Services
    ' Global time provider for Johannesburg, South Africa time across the app
    Public NotInheritable Class TimeProvider
        Private Sub New()
        End Sub

        Private Shared _saZone As TimeZoneInfo
        Public Shared ReadOnly Property SouthAfricaZone As TimeZoneInfo
            Get
                If _saZone Is Nothing Then
                    Try
                        _saZone = TimeZoneInfo.FindSystemTimeZoneById("South Africa Standard Time")
                    Catch
                        ' Fallback: use local time zone if SA zone is unavailable on host
                        _saZone = TimeZoneInfo.Local
                    End Try
                End If
                Return _saZone
            End Get
        End Property

        ' Returns current time in Johannesburg
        Public Shared Function [Now]() As DateTime
            Return TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, SouthAfricaZone)
        End Function

        ' Returns current date in Johannesburg
        Public Shared Function Today() As Date
            Return [Now]().Date
        End Function

        ' Converts a UTC DateTime to Johannesburg time
        Public Shared Function ToJoburg(utc As DateTime) As DateTime
            If utc.Kind = DateTimeKind.Unspecified Then
                ' treat as UTC if unspecified
                utc = DateTime.SpecifyKind(utc, DateTimeKind.Utc)
            ElseIf utc.Kind = DateTimeKind.Local Then
                utc = utc.ToUniversalTime()
            End If
            Return TimeZoneInfo.ConvertTimeFromUtc(utc, SouthAfricaZone)
        End Function

        ' Converts a local/unspecified DateTime (assumed local) to Johannesburg time
        Public Shared Function FromLocal(local As DateTime) As DateTime
            Dim utc = local.ToUniversalTime()
            Return TimeZoneInfo.ConvertTimeFromUtc(utc, SouthAfricaZone)
        End Function
    End Class
End Namespace
