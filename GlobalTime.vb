Imports System

Namespace Oven_Delights_ERP
    Public Module GlobalTime
        Private Const ZA_TZ_ID As String = "South Africa Standard Time" ' Windows time zone ID

        Private ReadOnly _zaTimeZone As TimeZoneInfo = InitializeZaTimeZone()

        Private Function InitializeZaTimeZone() As TimeZoneInfo
            Try
                ' Johannesburg time zone (UTC+02:00, no DST in ZA)
                Return TimeZoneInfo.FindSystemTimeZoneById(ZA_TZ_ID)
            Catch
                ' Fallback: fixed UTC+02:00 if the system does not know the ID
                Return TimeZoneInfo.CreateCustomTimeZone("ZA_Fallback", TimeSpan.FromHours(2), "South Africa Standard Time", "South Africa Standard Time")
            End Try
        End Function

        ' Returns the current local date/time for Johannesburg (ZA) regardless of server time zone.
        Public Function GetLocalDate() As DateTime
            Dim utcNow As DateTime = DateTime.UtcNow
            Return TimeZoneInfo.ConvertTimeFromUtc(utcNow, _zaTimeZone)
        End Function

        ' Optional helper: convert any UTC DateTime to ZA local time.
        Public Function ToLocalZaTime(utcTime As DateTime) As DateTime
            If utcTime.Kind = DateTimeKind.Local Then
                ' Normalize to UTC first when a local DateTime is passed accidentally
                utcTime = utcTime.ToUniversalTime()
            End If
            Return TimeZoneInfo.ConvertTimeFromUtc(utcTime, _zaTimeZone)
        End Function
    End Module
End Namespace
