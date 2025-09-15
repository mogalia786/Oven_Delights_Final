Imports System.Data
Imports Microsoft.Data.SqlClient

Public Class PermissionService
    Private ReadOnly _connStr As String

    Public Sub New()
        _connStr = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Public Function HasRead(roleId As Integer, featureKey As String) As Boolean
        If roleId <= 0 OrElse String.IsNullOrWhiteSpace(featureKey) Then Return False
        EnsureRolePermissionsTable()
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("SELECT TOP 1 CanRead FROM dbo.RolePermissions WHERE RoleID=@r AND FeatureKey=@f", cn)
                cmd.Parameters.AddWithValue("@r", roleId)
                cmd.Parameters.AddWithValue("@f", featureKey)
                cn.Open()
                Dim o = cmd.ExecuteScalar()
                Return o IsNot Nothing AndAlso o IsNot DBNull.Value AndAlso Convert.ToBoolean(o)
            End Using
        End Using
    End Function

    Public Function HasWrite(roleId As Integer, featureKey As String) As Boolean
        If roleId <= 0 OrElse String.IsNullOrWhiteSpace(featureKey) Then Return False
        EnsureRolePermissionsTable()
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("SELECT TOP 1 CanWrite FROM dbo.RolePermissions WHERE RoleID=@r AND FeatureKey=@f", cn)
                cmd.Parameters.AddWithValue("@r", roleId)
                cmd.Parameters.AddWithValue("@f", featureKey)
                cn.Open()
                Dim o = cmd.ExecuteScalar()
                Return o IsNot Nothing AndAlso o IsNot DBNull.Value AndAlso Convert.ToBoolean(o)
            End Using
        End Using
    End Function

    Public Function GetAllFeatures() As DataTable
        Using cn As New SqlConnection(_connStr)
            Try
                Using da As New SqlDataAdapter("SELECT FeatureKey, DisplayName, Category FROM dbo.FeatureCatalog ORDER BY Category, DisplayName", cn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    Return dt
                End Using
            Catch ex As SqlException
                ' Likely FeatureCatalog missing; create and seed minimal feature keys then retry once
                Try
                    cn.Open()
                    Using cmd As New SqlCommand("IF OBJECT_ID('dbo.FeatureCatalog','U') IS NULL BEGIN CREATE TABLE dbo.FeatureCatalog(FeatureKey NVARCHAR(100) NOT NULL PRIMARY KEY, DisplayName NVARCHAR(150) NOT NULL, Category NVARCHAR(50) NOT NULL); END;", cn)
                        cmd.ExecuteNonQuery()
                    End Using
                    ' Seed a minimal set used by UI
                    Using cmd As New SqlCommand("MERGE dbo.FeatureCatalog AS t USING (VALUES " & _
                                                "('Retail.Products.Upsert','Product Upsert','Retail')," & _
                                                "('Reporting.LowStock','Low Stock','Reporting')," & _
                                                "('Reporting.ProductCatalog','Product Catalog','Reporting')," & _
                                                "('Reporting.PriceHistory','Price History','Reporting')," & _
                                                "('Accounting.GL.View','View GL','Accounting')," & _
                                                "('Accounting.AP.Payments','AP Payments (Batch)','Accounting')," & _
                                                "('Transfers.InterBranch','Inter-Branch Transfers','Stockroom')) AS s(FeatureKey,DisplayName,Category) ON t.FeatureKey=s.FeatureKey WHEN NOT MATCHED THEN INSERT(FeatureKey,DisplayName,Category) VALUES(s.FeatureKey,s.DisplayName,s.Category);", cn)
                        cmd.ExecuteNonQuery()
                    End Using
                Catch
                    ' Swallow and try returning empty table
                Finally
                    If cn.State = ConnectionState.Open Then cn.Close()
                End Try
                ' Retry once
                Using da As New SqlDataAdapter("SELECT FeatureKey, DisplayName, Category FROM dbo.FeatureCatalog ORDER BY Category, DisplayName", cn)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    Return dt
                End Using
            End Try
        End Using
    End Function

    Public Function GetRolePermissions(roleId As Integer) As DataTable
        EnsureRolePermissionsTable()
        Using cn As New SqlConnection(_connStr)
            Using da As New SqlDataAdapter("SELECT FeatureKey, CanRead, CanWrite FROM dbo.RolePermissions WHERE RoleID=@r", cn)
                da.SelectCommand.Parameters.AddWithValue("@r", roleId)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            End Using
        End Using
    End Function

    Public Sub SaveRolePermissions(roleId As Integer, permissions As DataTable, userId As Integer)
        If permissions Is Nothing Then Return
        EnsureRolePermissionsTable()
        Using cn As New SqlConnection(_connStr)
            cn.Open()
            Using tx = cn.BeginTransaction()
                Try
                    For Each row As DataRow In permissions.Rows
                        Dim key As String = Convert.ToString(row("FeatureKey"))
                        Dim canRead As Boolean = False
                        Dim canWrite As Boolean = False
                        If Not row.IsNull("CanRead") Then canRead = Convert.ToBoolean(row("CanRead"))
                        If Not row.IsNull("CanWrite") Then canWrite = Convert.ToBoolean(row("CanWrite"))

                        Using cmd As New SqlCommand("MERGE dbo.RolePermissions AS tgt USING (SELECT @r AS RoleID, @f AS FeatureKey) AS src ON tgt.RoleID=src.RoleID AND tgt.FeatureKey=src.FeatureKey WHEN MATCHED THEN UPDATE SET CanRead=@cr, CanWrite=@cw WHEN NOT MATCHED THEN INSERT(RoleID, FeatureKey, CanRead, CanWrite, CreatedBy) VALUES(@r, @f, @cr, @cw, @u);", cn, tx)
                            cmd.Parameters.AddWithValue("@r", roleId)
                            cmd.Parameters.AddWithValue("@f", key)
                            cmd.Parameters.AddWithValue("@cr", If(canRead, 1, 0))
                            cmd.Parameters.AddWithValue("@cw", If(canWrite, 1, 0))
                            cmd.Parameters.AddWithValue("@u", If(userId > 0, userId, CType(DBNull.Value, Object)))
                            cmd.ExecuteNonQuery()
                        End Using
                    Next
                    tx.Commit()
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    ' Optional: catalog missing menu items discovered at runtime
    Public Sub UpsertFeature(featureKey As String, displayName As String, category As String)
        If String.IsNullOrWhiteSpace(featureKey) Then Return
        Using cn As New SqlConnection(_connStr)
            Using cmd As New SqlCommand("MERGE dbo.FeatureCatalog AS t USING (SELECT @k AS FeatureKey) s ON t.FeatureKey=s.FeatureKey WHEN MATCHED THEN UPDATE SET DisplayName=ISNULL(@d,t.DisplayName), Category=ISNULL(@c,t.Category) WHEN NOT MATCHED THEN INSERT(FeatureKey, DisplayName, Category) VALUES(@k, ISNULL(@d,@k), ISNULL(@c,'General'));", cn)
                cmd.Parameters.AddWithValue("@k", featureKey)
                cmd.Parameters.AddWithValue("@d", If(String.IsNullOrWhiteSpace(displayName), CType(DBNull.Value, Object), displayName))
                cmd.Parameters.AddWithValue("@c", If(String.IsNullOrWhiteSpace(category), CType(DBNull.Value, Object), category))
                cn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub EnsureRolePermissionsTable()
        Try
            Using cn As New SqlConnection(_connStr)
                cn.Open()
                Dim sql As String = "IF OBJECT_ID('dbo.RolePermissions','U') IS NULL BEGIN " & _
                                    "CREATE TABLE dbo.RolePermissions(" & _
                                    " RolePermissionID INT IDENTITY(1,1) PRIMARY KEY, " & _
                                    " RoleID INT NOT NULL, " & _
                                    " FeatureKey NVARCHAR(100) NOT NULL, " & _
                                    " CanRead BIT NOT NULL DEFAULT(0), " & _
                                    " CanWrite BIT NOT NULL DEFAULT(0), " & _
                                    " CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(), " & _
                                    " CreatedBy INT NULL); " & _
                                    "CREATE UNIQUE INDEX UX_RolePermissions_Role_Feature ON dbo.RolePermissions(RoleID, FeatureKey); END;"
                Using cmd As New SqlCommand(sql, cn)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch
            ' best-effort only
        End Try
    End Sub
End Class
