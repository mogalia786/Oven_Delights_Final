Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Data

Public Class StockroomService
    Private ReadOnly connectionString As String

    Public Sub New()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    Public Function GetAllSuppliers() As DataTable
        Dim suppliersTable As New DataTable()
        
        Using connection As New SqlConnection(connectionString)
            Dim query As String = "SELECT ID FROM Suppliers ORDER BY ID"
            
            Using adapter As New SqlDataAdapter(query, connection)
                adapter.Fill(suppliersTable)
            End Using
        End Using
        
        Return suppliersTable
    End Function

    Public Function GetAllRawMaterials() As DataTable
        Dim materialsTable As New DataTable()
        
        Using connection As New SqlConnection(connectionString)
            Dim query As String = "SELECT ID FROM RawMaterials ORDER BY ID"
            
            Using adapter As New SqlDataAdapter(query, connection)
                adapter.Fill(materialsTable)
            End Using
        End Using
        
        Return materialsTable
    End Function

    Public Function GetAllPurchaseOrders() As DataTable
        Dim ordersTable As New DataTable()
        
        Using connection As New SqlConnection(connectionString)
            Dim query As String = "SELECT ID FROM PurchaseOrders ORDER BY ID"
            
            Using adapter As New SqlDataAdapter(query, connection)
                adapter.Fill(ordersTable)
            End Using
        End Using
        
        Return ordersTable
    End Function

    Public Function GetLowStockMaterials() As DataTable
        Dim lowStockTable As New DataTable()
        
        Using connection As New SqlConnection(connectionString)
            Dim query As String = "SELECT TOP 0 ID FROM RawMaterials"
            
            Using adapter As New SqlDataAdapter(query, connection)
                adapter.Fill(lowStockTable)
            End Using
        End Using
        
        Return lowStockTable
    End Function

End Class
