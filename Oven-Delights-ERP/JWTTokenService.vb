Imports System.IdentityModel.Tokens.Jwt
Imports System.Security.Claims
Imports System.Text
Imports Microsoft.IdentityModel.Tokens
Imports System.Configuration

Public Class JWTTokenService
    Private Shared ReadOnly secretKey As String = "OvenDelightsERP_SecretKey_2024_VeryLongAndSecureKey123456789"
    Private Shared ReadOnly key As SymmetricSecurityKey = New SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey))
    Private Shared ReadOnly credentials As SigningCredentials = New SigningCredentials(key, SecurityAlgorithms.HmacSha256)

    Public Shared Function GenerateToken(userID As Integer, username As String, role As String, branchID As Integer?) As String
        Try
            Dim claims As New List(Of Claim) From {
                New Claim(ClaimTypes.NameIdentifier, userID.ToString()),
                New Claim(ClaimTypes.Name, username),
                New Claim(ClaimTypes.Role, role),
                New Claim("UserID", userID.ToString()),
                New Claim("Username", username),
                New Claim("Role", role)
            }

            If branchID.HasValue Then
                claims.Add(New Claim("BranchID", branchID.Value.ToString()))
            End If

            Dim token As New JwtSecurityToken(
                issuer:="OvenDelightsERP",
                audience:="OvenDelightsERP_Users",
                claims:=claims,
                expires:=DateTime.UtcNow.AddHours(8), ' 8 hour expiration
                signingCredentials:=credentials
            )

            Return New JwtSecurityTokenHandler().WriteToken(token)
        Catch ex As Exception
            Throw New Exception("Error generating JWT token: " & ex.Message)
        End Try
    End Function

    Public Shared Function ValidateToken(token As String) As ClaimsPrincipal
        Try
            Dim tokenHandler As New JwtSecurityTokenHandler()
            Dim validationParameters As New TokenValidationParameters() With {
                .ValidateIssuer = True,
                .ValidateAudience = True,
                .ValidateLifetime = True,
                .ValidateIssuerSigningKey = True,
                .ValidIssuer = "OvenDelightsERP",
                .ValidAudience = "OvenDelightsERP_Users",
                .IssuerSigningKey = key,
                .ClockSkew = TimeSpan.Zero
            }

            Dim principal As ClaimsPrincipal = tokenHandler.ValidateToken(token, validationParameters, Nothing)
            Return principal
        Catch ex As Exception
            Throw New SecurityTokenException("Invalid token: " & ex.Message)
        End Try
    End Function

    Public Shared Function RefreshToken(oldToken As String) As String
        Try
            Dim principal As ClaimsPrincipal = ValidateToken(oldToken)
            
            Dim userID As Integer = Integer.Parse(principal.FindFirst("UserID").Value)
            Dim username As String = principal.FindFirst("Username").Value
            Dim role As String = principal.FindFirst("Role").Value
            Dim branchIDClaim = principal.FindFirst("BranchID")
            Dim branchID As Integer? = If(branchIDClaim IsNot Nothing, Integer.Parse(branchIDClaim.Value), Nothing)

            Return GenerateToken(userID, username, role, branchID)
        Catch ex As Exception
            Throw New Exception("Error refreshing token: " & ex.Message)
        End Try
    End Function

    Public Shared Function GetUserIDFromToken(token As String) As Integer
        Try
            Dim principal As ClaimsPrincipal = ValidateToken(token)
            Return Integer.Parse(principal.FindFirst("UserID").Value)
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function GetUsernameFromToken(token As String) As String
        Try
            Dim principal As ClaimsPrincipal = ValidateToken(token)
            Return principal.FindFirst("Username").Value
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Function GetRoleFromToken(token As String) As String
        Try
            Dim principal As ClaimsPrincipal = ValidateToken(token)
            Return principal.FindFirst("Role").Value
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Function IsTokenExpired(token As String) As Boolean
        Try
            Dim tokenHandler As New JwtSecurityTokenHandler()
            Dim jsonToken As JwtSecurityToken = tokenHandler.ReadJwtToken(token)
            Return jsonToken.ValidTo < DateTime.UtcNow
        Catch ex As Exception
            Return True
        End Try
    End Function
End Class
