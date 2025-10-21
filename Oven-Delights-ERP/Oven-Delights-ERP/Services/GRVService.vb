Imports System.Data
Imports System.Configuration
Imports System.Data.SqlClient

Public Class GRVService
    Private ReadOnly connectionString As String
    Private ReadOnly stockroomService As New StockroomService()

    Public Sub New()
        connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Sub

    ' Create new GRV from Purchase Order
    Public Function CreateGRVFromPO(poId As Integer, supplierId As Integer, branchId As Integer, 
                                   deliveryNoteNumber As String, deliveryDate As Date?, 
                                   receivedBy As Integer, notes As String) As Integer
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Generate GRV Number
                    Dim grvNumber As String = GetNextGRVNumber(branchId, con, tx)
                    
                    ' Create GRV Header
                    Dim cmdH As New SqlCommand("
                        INSERT INTO GoodsReceivedVouchers 
                        (GRVNumber, PurchaseOrderID, SupplierID, BranchID, DeliveryNoteNumber, 
                         DeliveryDate, ReceivedBy, Status, Notes, CreatedBy)
                        OUTPUT INSERTED.GRVID
                        VALUES (@num, @po, @sup, @br, @dn, @dd, @by, 'Draft', @notes, @by)", con, tx)
                    
                    cmdH.Parameters.AddWithValue("@num", grvNumber)
                    cmdH.Parameters.AddWithValue("@po", poId)
                    cmdH.Parameters.AddWithValue("@sup", supplierId)
                    cmdH.Parameters.AddWithValue("@br", branchId)
                    cmdH.Parameters.AddWithValue("@dn", If(String.IsNullOrEmpty(deliveryNoteNumber), DBNull.Value, deliveryNoteNumber))
                    cmdH.Parameters.AddWithValue("@dd", If(deliveryDate.HasValue, deliveryDate.Value, DBNull.Value))
                    cmdH.Parameters.AddWithValue("@by", receivedBy)
                    cmdH.Parameters.AddWithValue("@notes", If(String.IsNullOrEmpty(notes), DBNull.Value, notes))
                    
                    Dim grvId As Integer = Convert.ToInt32(cmdH.ExecuteScalar())
                    
                    ' Copy PO Lines to GRV Lines
                    Dim cmdLines As New SqlCommand("
                        INSERT INTO GRVLines 
                        (GRVID, POLineID, MaterialID, ProductID, ItemType, OrderedQuantity, 
                         ReceivedQuantity, UnitCost, CreatedBy)
                        SELECT @grvId, pol.POLineID, pol.MaterialID, pol.ProductID,
                               CASE WHEN pol.MaterialID IS NOT NULL THEN 'RM' ELSE 'PR' END,
                               pol.OrderedQuantity, 0, pol.UnitCost, @by
                        FROM PurchaseOrderLines pol
                        WHERE pol.PurchaseOrderID = @po AND pol.IsActive = 1", con, tx)
                    
                    cmdLines.Parameters.AddWithValue("@grvId", grvId)
                    cmdLines.Parameters.AddWithValue("@po", poId)
                    cmdLines.Parameters.AddWithValue("@by", receivedBy)
                    cmdLines.ExecuteNonQuery()
                    
                    tx.Commit()
                    Return grvId
                    
                Catch ex As Exception
                    tx.Rollback()
                    Throw New Exception($"Error creating GRV: {ex.Message}", ex)
                End Try
            End Using
        End Using
    End Function

    ' Update GRV Line quantities and quality status
    Public Sub UpdateGRVLine(grvLineId As Integer, receivedQty As Decimal, rejectedQty As Decimal,
                             qualityStatus As String, qualityNotes As String, qualityCheckedBy As Integer)
        Using con As New SqlConnection(connectionString)
            con.Open()
            
            Dim cmd As New SqlCommand("
                UPDATE GRVLines 
                SET ReceivedQuantity = @recv,
                    RejectedQuantity = @rej,
                    QualityStatus = @status,
                    QualityNotes = @notes,
                    QualityCheckedBy = @by,
                    QualityCheckedDate = GETDATE()
                WHERE GRVLineID = @id", con)
            
            cmd.Parameters.AddWithValue("@recv", receivedQty)
            cmd.Parameters.AddWithValue("@rej", rejectedQty)
            cmd.Parameters.AddWithValue("@status", qualityStatus)
            cmd.Parameters.AddWithValue("@notes", If(String.IsNullOrEmpty(qualityNotes), DBNull.Value, qualityNotes))
            cmd.Parameters.AddWithValue("@by", qualityCheckedBy)
            cmd.Parameters.AddWithValue("@id", grvLineId)
            
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    ' Complete GRV - mark as Received and update totals
    Public Sub CompleteGRV(grvId As Integer, userId As Integer)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Update GRV totals from lines
                    Dim cmdTotals As New SqlCommand("
                        UPDATE grv SET 
                            SubTotal = totals.SubTotal,
                            VATAmount = totals.VATAmount,
                            TotalAmount = totals.TotalAmount,
                            Status = 'Received',
                            ModifiedDate = GETDATE(),
                            ModifiedBy = @by
                        FROM GoodsReceivedVouchers grv
                        INNER JOIN (
                            SELECT GRVID,
                                   SUM(AcceptedQuantity * UnitCost) AS SubTotal,
                                   SUM(AcceptedQuantity * UnitCost) * 0.15 AS VATAmount,
                                   SUM(AcceptedQuantity * UnitCost) * 1.15 AS TotalAmount
                            FROM GRVLines 
                            WHERE GRVID = @id
                            GROUP BY GRVID
                        ) totals ON grv.GRVID = totals.GRVID
                        WHERE grv.GRVID = @id", con, tx)
                    
                    cmdTotals.Parameters.AddWithValue("@id", grvId)
                    cmdTotals.Parameters.AddWithValue("@by", userId)
                    cmdTotals.ExecuteNonQuery()
                    
                    ' Update stock levels for received items
                    UpdateStockFromGRV(grvId, con, tx)
                    
                    tx.Commit()
                    
                Catch ex As Exception
                    tx.Rollback()
                    Throw New Exception($"Error completing GRV: {ex.Message}", ex)
                End Try
            End Using
        End Using
    End Sub

    ' Match GRV to Invoice
    Public Sub MatchGRVToInvoice(grvId As Integer, invoiceId As Integer, userId As Integer)
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Create matching records for each line
                    Dim cmd As New SqlCommand("
                        INSERT INTO GRVInvoiceMatching 
                        (GRVID, InvoiceID, GRVLineID, InvoiceLineID, MatchedQuantity, MatchedAmount, 
                         VarianceQuantity, VarianceAmount, MatchingStatus, MatchedBy)
                        SELECT grv.GRVID, inv.InvoiceID, grv.GRVLineID, inv.InvoiceLineID,
                               CASE WHEN grv.AcceptedQuantity <= inv.Quantity THEN grv.AcceptedQuantity ELSE inv.Quantity END,
                               CASE WHEN grv.AcceptedQuantity <= inv.Quantity THEN grv.LineTotal ELSE inv.LineTotal END,
                               ABS(grv.AcceptedQuantity - inv.Quantity),
                               ABS(grv.LineTotal - inv.LineTotal),
                               CASE WHEN ABS(grv.AcceptedQuantity - inv.Quantity) > 0.01 OR ABS(grv.LineTotal - inv.LineTotal) > 0.01 
                                    THEN 'Variance' ELSE 'Matched' END,
                               @by
                        FROM GRVLines grv
                        INNER JOIN InvoiceLines inv ON grv.POLineID = inv.POLineID
                        WHERE grv.GRVID = @grvId AND inv.InvoiceID = @invId", con, tx)
                    
                    cmd.Parameters.AddWithValue("@grvId", grvId)
                    cmd.Parameters.AddWithValue("@invId", invoiceId)
                    cmd.Parameters.AddWithValue("@by", userId)
                    cmd.ExecuteNonQuery()
                    
                    ' Update GRV status
                    Dim cmdStatus As New SqlCommand("
                        UPDATE GoodsReceivedVouchers 
                        SET Status = 'Matched', ModifiedDate = GETDATE(), ModifiedBy = @by
                        WHERE GRVID = @id", con, tx)
                    
                    cmdStatus.Parameters.AddWithValue("@id", grvId)
                    cmdStatus.Parameters.AddWithValue("@by", userId)
                    cmdStatus.ExecuteNonQuery()
                    
                    tx.Commit()
                    
                Catch ex As Exception
                    tx.Rollback()
                    Throw New Exception($"Error matching GRV to invoice: {ex.Message}", ex)
                End Try
            End Using
        End Using
    End Sub

    ' Create Credit Note from GRV
    Public Function CreateCreditNote(grvId As Integer, creditType As String, reason As String,
                                   creditDate As Date, branchId As Integer, userId As Integer) As Integer
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' Get GRV details
                    Dim grvCmd As New SqlCommand("SELECT SupplierID FROM GoodsReceivedVouchers WHERE GRVID = @id", con, tx)
                    grvCmd.Parameters.AddWithValue("@id", grvId)
                    Dim supplierId As Integer = Convert.ToInt32(grvCmd.ExecuteScalar())
                    
                    ' Generate Credit Note Number
                    Dim cnNumber As String = GetNextCreditNoteNumber(branchId, con, tx)
                    
                    ' Create Credit Note Header
                    Dim cmdH As New SqlCommand("
                        INSERT INTO CreditNotes 
                        (CreditNoteNumber, GRVID, SupplierID, BranchID, CreditType, CreditReason,
                         CreditDate, Status, CreatedBy)
                        OUTPUT INSERTED.CreditNoteID
                        VALUES (@num, @grv, @sup, @br, @type, @reason, @date, 'Requested', @by)", con, tx)
                    
                    cmdH.Parameters.AddWithValue("@num", cnNumber)
                    cmdH.Parameters.AddWithValue("@grv", grvId)
                    cmdH.Parameters.AddWithValue("@sup", supplierId)
                    cmdH.Parameters.AddWithValue("@br", branchId)
                    cmdH.Parameters.AddWithValue("@type", creditType)
                    cmdH.Parameters.AddWithValue("@reason", reason)
                    cmdH.Parameters.AddWithValue("@date", creditDate)
                    cmdH.Parameters.AddWithValue("@by", userId)
                    
                    Dim cnId As Integer = Convert.ToInt32(cmdH.ExecuteScalar())
                    
                    tx.Commit()
                    Return cnId
                    
                Catch ex As Exception
                    tx.Rollback()
                    Throw New Exception($"Error creating credit note: {ex.Message}", ex)
                End Try
            End Using
        End Using
    End Function

    ' Get GRV Details
    Public Function GetGRVDetails(grvId As Integer) As DataTable
        Using con As New SqlConnection(connectionString)
            Dim sql As String = "
                SELECT grv.*, s.SupplierName, b.BranchName, u.FirstName + ' ' + u.LastName AS ReceivedByName
                FROM GoodsReceivedVouchers grv
                LEFT JOIN Suppliers s ON grv.SupplierID = s.SupplierID
                LEFT JOIN Branches b ON grv.BranchID = b.BranchID
                LEFT JOIN Users u ON grv.ReceivedBy = u.UserID
                WHERE grv.GRVID = @id"
            
            Using da As New SqlDataAdapter(sql, con)
                da.SelectCommand.Parameters.AddWithValue("@id", grvId)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            End Using
        End Using
    End Function

    ' Get GRV Lines
    Public Function GetGRVLines(grvId As Integer) As DataTable
        Using con As New SqlConnection(connectionString)
            Dim sql As String = "
                SELECT gl.*, 
                       COALESCE(rm.MaterialName, p.Name) AS ItemName,
                       COALESCE(rm.MaterialCode, p.SKU) AS ItemCode,
                       pol.OrderedQuantity AS POOrderedQuantity
                FROM GRVLines gl
                LEFT JOIN RawMaterials rm ON gl.MaterialID = rm.MaterialID
                LEFT JOIN Products p ON gl.ProductID = p.ProductID
                LEFT JOIN PurchaseOrderLines pol ON gl.POLineID = pol.POLineID
                WHERE gl.GRVID = @id
                ORDER BY gl.GRVLineID"
            
            Using da As New SqlDataAdapter(sql, con)
                da.SelectCommand.Parameters.AddWithValue("@id", grvId)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            End Using
        End Using
    End Function

    ' Private helper methods
    Private Function GetNextGRVNumber(branchId As Integer, con As SqlConnection, tx As SqlTransaction) As String
        Dim cmd As New SqlCommand("
            SELECT ISNULL(MAX(CAST(SUBSTRING(GRVNumber, 4, LEN(GRVNumber)-3) AS INT)), 0) + 1
            FROM GoodsReceivedVouchers 
            WHERE GRVNumber LIKE 'GRV%' AND BranchID = @branchId", con, tx)
        
        cmd.Parameters.AddWithValue("@branchId", branchId)
        Dim nextNum As Integer = Convert.ToInt32(cmd.ExecuteScalar())
        Return $"GRV{nextNum:D6}"
    End Function

    Private Function GetNextCreditNoteNumber(branchId As Integer, con As SqlConnection, tx As SqlTransaction) As String
        Dim cmd As New SqlCommand("
            SELECT ISNULL(MAX(CAST(SUBSTRING(CreditNoteNumber, 3, LEN(CreditNoteNumber)-2) AS INT)), 0) + 1
            FROM CreditNotes 
            WHERE CreditNoteNumber LIKE 'CN%' AND BranchID = @branchId", con, tx)
        
        cmd.Parameters.AddWithValue("@branchId", branchId)
        Dim nextNum As Integer = Convert.ToInt32(cmd.ExecuteScalar())
        Return $"CN{nextNum:D6}"
    End Function

    Private Sub UpdateStockFromGRV(grvId As Integer, con As SqlConnection, tx As SqlTransaction)
        ' Update Raw Materials stock
        Dim cmdRM As New SqlCommand("
            UPDATE rm SET 
                CurrentStock = ISNULL(CurrentStock, 0) + gl.AcceptedQuantity,
                LastCost = gl.UnitCost,
                AverageCost = CASE 
                    WHEN ISNULL(CurrentStock, 0) = 0 THEN gl.UnitCost
                    ELSE ((ISNULL(AverageCost, 0) * ISNULL(CurrentStock, 0)) + (gl.UnitCost * gl.AcceptedQuantity)) / 
                         (ISNULL(CurrentStock, 0) + gl.AcceptedQuantity)
                END
            FROM RawMaterials rm
            INNER JOIN GRVLines gl ON rm.MaterialID = gl.MaterialID
            WHERE gl.GRVID = @id AND gl.ItemType = 'RM'", con, tx)
        
        cmdRM.Parameters.AddWithValue("@id", grvId)
        cmdRM.ExecuteNonQuery()
        
        ' Update Product Inventory (Retail_Stock table with branch awareness)
        Dim cmdPI As New SqlCommand("
            UPDATE rs SET 
                QuantityInStock = ISNULL(QuantityInStock, 0) + gl.AcceptedQuantity,
                LastUpdated = GETDATE()
            FROM Retail_Stock rs
            INNER JOIN GRVLines gl ON rs.ProductID = gl.ProductID
            INNER JOIN GoodsReceivedVouchers grv ON gl.GRVID = grv.GRVID
            WHERE gl.GRVID = @id AND gl.ItemType = 'PR' AND rs.BranchID = grv.BranchID", con, tx)
        
        cmdPI.Parameters.AddWithValue("@id", grvId)
        cmdPI.ExecuteNonQuery()
    End Sub
End Class
