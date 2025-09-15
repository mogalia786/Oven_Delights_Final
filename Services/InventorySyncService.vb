Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient
Imports System.Threading.Tasks

Public Class InventorySyncService
    Private ReadOnly _connString As String
    Private Shared ReadOnly _instance As New Lazy(Of InventorySyncService)(Function() New InventorySyncService())
    
    Public Shared ReadOnly Property Instance As InventorySyncService
        Get
            Return _instance.Value
        End Get
    End Property

    Private Sub New()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        If String.IsNullOrWhiteSpace(_connString) Then
            Throw New InvalidOperationException("Missing connection string 'OvenDelightsERPConnectionString' in App.config.")
        End If
    End Sub

    ''' <summary>
    ''' Synchronizes legacy inventory data with new Stockroom_Product table
    ''' This should be called whenever inventory changes occur
    ''' </summary>
    Public Async Function SyncLegacyInventoryAsync() As Task(Of Boolean)
        Try
            Using conn As New SqlConnection(_connString)
                Await conn.OpenAsync()
                
                Using cmd As New SqlCommand("EXEC sp_SyncLegacyInventoryToStockroom", conn)
                    cmd.CommandTimeout = 120 ' 2 minutes timeout for sync operation
                    Await cmd.ExecuteNonQueryAsync()
                End Using
            End Using
            
            ' Log successful sync
            Console.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] Legacy inventory sync completed successfully")
            Return True
            
        Catch ex As Exception
            ' Log error
            Console.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] Legacy inventory sync failed: {ex.Message}")
            Return False
        End Try
    End Function

    ''' <summary>
    ''' Synchronous version of legacy inventory sync
    ''' </summary>
    Public Function SyncLegacyInventory() As Boolean
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Using cmd As New SqlCommand("EXEC sp_SyncLegacyInventoryToStockroom", conn)
                    cmd.CommandTimeout = 120
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            
            Console.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] Legacy inventory sync completed successfully")
            Return True
            
        Catch ex As Exception
            Console.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] Legacy inventory sync failed: {ex.Message}")
            Return False
        End Try
    End Function

    ''' <summary>
    ''' Creates a Bill of Materials request for Manufacturing or Retail modules
    ''' </summary>
    Public Function CreateBOMRequest(requestingModule As String, branchID As Integer, requestedBy As Integer) As DataTable
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Using cmd As New SqlCommand("sp_CreateBOMRequest", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@RequestingModule", requestingModule)
                    cmd.Parameters.AddWithValue("@BranchID", branchID)
                    cmd.Parameters.AddWithValue("@RequestedBy", requestedBy)
                    
                    Dim adapter As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)
                    
                    Console.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] BOM request created for {requestingModule} module")
                    Return dt
                End Using
            End Using
            
        Catch ex As Exception
            Console.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] BOM request failed: {ex.Message}")
            Return New DataTable()
        End Try
    End Function

    ''' <summary>
    ''' Gets orphaned products that need category/subcategory assignment
    ''' </summary>
    Public Function GetOrphanedProducts() As DataTable
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Using cmd As New SqlCommand("SELECT * FROM vw_OrphanedProducts WHERE ClassificationStatus LIKE '%ORPHANED%' ORDER BY ProductModule, ProductName", conn)
                    Dim adapter As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)
                    Return dt
                End Using
            End Using
            
        Catch ex As Exception
            Console.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] Failed to get orphaned products: {ex.Message}")
            Return New DataTable()
        End Try
    End Function

    ''' <summary>
    ''' Validates if a product has proper category/subcategory classification
    ''' </summary>
    Public Function ValidateProductClassification(productModule As String, productID As Integer, category As String, subcategory As String) As (IsValid As Boolean, ErrorMessage As String)
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Using cmd As New SqlCommand("sp_ValidateProductClassification", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ProductModule", productModule)
                    cmd.Parameters.AddWithValue("@ProductID", productID)
                    cmd.Parameters.AddWithValue("@Category", category)
                    cmd.Parameters.AddWithValue("@Subcategory", subcategory)
                    
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            Dim isValid As Boolean = Convert.ToBoolean(reader("IsValid"))
                            Dim errorMessage As String = reader("ErrorMessage").ToString()
                            Return (isValid, errorMessage)
                        End If
                    End Using
                End Using
            End Using
            
        Catch ex As Exception
            Return (False, $"Validation failed: {ex.Message}")
        End Try
        
        Return (False, "Unknown validation error")
    End Function
End Class
