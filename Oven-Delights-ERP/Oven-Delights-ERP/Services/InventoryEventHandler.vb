Imports System.Threading.Tasks

''' <summary>
''' Handles inventory-related events and triggers automatic synchronization
''' This ensures legacy inventory stays in sync with new Stockroom_Product table
''' </summary>
Public Class InventoryEventHandler
    Private Shared ReadOnly _syncService As InventorySyncService = InventorySyncService.Instance
    
    ''' <summary>
    ''' Call this method whenever RawMaterials table is modified
    ''' (INSERT, UPDATE, DELETE operations)
    ''' </summary>
    Public Shared Sub OnRawMaterialsChanged()
        Task.Run(Async Function()
                     Await _syncService.SyncLegacyInventoryAsync()
                 End Function)
    End Sub
    
    ''' <summary>
    ''' Call this method whenever Inventory table is modified
    ''' (Stock quantities, locations, batches changed)
    ''' </summary>
    Public Shared Sub OnInventoryChanged()
        Task.Run(Async Function()
                     Await _syncService.SyncLegacyInventoryAsync()
                 End Function)
    End Sub
    
    ''' <summary>
    ''' Call this method when Purchase Orders are received
    ''' (New stock arrives and needs to be synced)
    ''' </summary>
    Public Shared Sub OnPurchaseOrderReceived()
        Task.Run(Async Function()
                     Await _syncService.SyncLegacyInventoryAsync()
                 End Function)
    End Sub
    
    ''' <summary>
    ''' Call this method when stock adjustments are made
    ''' </summary>
    Public Shared Sub OnStockAdjustment()
        Task.Run(Async Function()
                     Await _syncService.SyncLegacyInventoryAsync()
                 End Function)
    End Sub
    
    ''' <summary>
    ''' Manual sync trigger for administrative purposes
    ''' </summary>
    Public Shared Function TriggerManualSync() As Boolean
        Return _syncService.SyncLegacyInventory()
    End Function
End Class
