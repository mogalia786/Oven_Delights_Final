Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Public Class InvoiceCaptureService
    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    ''' <summary>
    ''' Captures supplier invoice and routes items to correct inventory tables
    ''' External Products → Retail_Stock
    ''' Raw Materials → RawMaterials
    ''' </summary>
    Public Function CaptureInvoice(
        branchId As Integer,
        supplierId As Integer,
        purchaseOrderId As Integer,
        invoiceNumber As String,
        invoiceDate As DateTime,
        invoiceLines As DataTable,
        createdBy As Integer
    ) As Integer
        ' invoiceLines schema: ItemID, ItemSource ('RM' or 'PR'), Quantity, UnitCost
        
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    ' 1. Create Invoice Header
                    Dim invoiceId As Integer = CreateInvoiceHeader(con, tx, branchId, supplierId, purchaseOrderId, invoiceNumber, invoiceDate, invoiceLines, createdBy)
                    
                    ' 2. Process each line and route to correct inventory
                    For Each line As DataRow In invoiceLines.Rows
                        Dim itemId As Integer = Convert.ToInt32(line("ItemID"))
                        Dim itemSource As String = line("ItemSource").ToString()
                        Dim quantity As Decimal = Convert.ToDecimal(line("Quantity"))
                        Dim unitCost As Decimal = Convert.ToDecimal(line("UnitCost"))
                        
                        If itemSource = "RM" Then
                            ' Raw Material → Update RawMaterials table
                            UpdateRawMaterialInventory(con, tx, itemId, quantity, unitCost, branchId, invoiceNumber, createdBy)
                        ElseIf itemSource = "PR" Then
                            ' External Product → Update Products and Retail_Stock
                            UpdateExternalProductInventory(con, tx, itemId, branchId, quantity, unitCost, invoiceNumber, createdBy)
                        End If
                    Next
                    
                    ' 3. Update Purchase Order status
                    If purchaseOrderId > 0 Then
                        UpdatePurchaseOrderStatus(con, tx, purchaseOrderId, "Invoiced")
                    End If
                    
                    ' 4. Create Ledger Entries
                    CreateInvoiceLedgerEntries(con, tx, invoiceId, branchId, supplierId, invoiceLines, invoiceNumber, createdBy)
                    
                    tx.Commit()
                    Return invoiceId
                    
                Catch ex As Exception
                    tx.Rollback()
                    Throw New Exception($"Invoice capture failed: {ex.Message}", ex)
                End Try
            End Using
        End Using
    End Function
    
    Private Function CreateInvoiceHeader(con As SqlConnection, tx As SqlTransaction, branchId As Integer, supplierId As Integer, purchaseOrderId As Integer, invoiceNumber As String, invoiceDate As DateTime, lines As DataTable, createdBy As Integer) As Integer
        Dim subTotal As Decimal = 0D
        For Each line As DataRow In lines.Rows
            subTotal += Convert.ToDecimal(line("Quantity")) * Convert.ToDecimal(line("UnitCost"))
        Next
        
        Dim vatRate As Decimal = GetVATRate(con, tx)
        Dim vatAmount As Decimal = Math.Round(subTotal * (vatRate / 100D), 2)
        Dim totalAmount As Decimal = subTotal + vatAmount
        Dim dueDate As DateTime = invoiceDate.AddDays(30) ' Default 30 days payment terms
        
        Dim sql = "INSERT INTO SupplierInvoices (InvoiceNumber, SupplierID, BranchID, PurchaseOrderID, InvoiceDate, DueDate, SubTotal, VATAmount, TotalAmount, Status, CreatedBy) " &
                  "OUTPUT INSERTED.InvoiceID " &
                  "VALUES (@InvoiceNumber, @SupplierID, @BranchID, @POID, @InvoiceDate, @DueDate, @SubTotal, @VAT, @Total, 'Unpaid', @CreatedBy)"
        
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
            cmd.Parameters.AddWithValue("@SupplierID", supplierId)
            cmd.Parameters.AddWithValue("@BranchID", branchId)
            cmd.Parameters.AddWithValue("@POID", If(purchaseOrderId > 0, purchaseOrderId, DBNull.Value))
            cmd.Parameters.AddWithValue("@InvoiceDate", invoiceDate)
            cmd.Parameters.AddWithValue("@DueDate", dueDate)
            cmd.Parameters.AddWithValue("@SubTotal", subTotal)
            cmd.Parameters.AddWithValue("@VAT", vatAmount)
            cmd.Parameters.AddWithValue("@Total", totalAmount)
            cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
            Dim invoiceId As Integer = Convert.ToInt32(cmd.ExecuteScalar())
            
            ' Create invoice lines
            For Each line As DataRow In lines.Rows
                Dim lineSql = "INSERT INTO SupplierInvoiceLines (InvoiceID, ItemID, ItemSource, Quantity, UnitCost, LineTotal) " &
                             "VALUES (@InvoiceID, @ItemID, @ItemSource, @Qty, @Cost, @Total)"
                Using lineCmd As New SqlCommand(lineSql, con, tx)
                    lineCmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                    lineCmd.Parameters.AddWithValue("@ItemID", Convert.ToInt32(line("ItemID")))
                    lineCmd.Parameters.AddWithValue("@ItemSource", line("ItemSource").ToString())
                    lineCmd.Parameters.AddWithValue("@Qty", Convert.ToDecimal(line("Quantity")))
                    lineCmd.Parameters.AddWithValue("@Cost", Convert.ToDecimal(line("UnitCost")))
                    lineCmd.Parameters.AddWithValue("@Total", Convert.ToDecimal(line("Quantity")) * Convert.ToDecimal(line("UnitCost")))
                    lineCmd.ExecuteNonQuery()
                End Using
            Next
            
            Return invoiceId
        End Using
    End Function
    
    Private Sub UpdateRawMaterialInventory(con As SqlConnection, tx As SqlTransaction, materialId As Integer, quantity As Decimal, unitCost As Decimal, branchId As Integer, reference As String, createdBy As Integer)
        ' Update RawMaterials table (shared across branches, but track movement per branch)
        Dim sql = "UPDATE RawMaterials " &
                  "SET CurrentStock = ISNULL(CurrentStock, 0) + @Qty, " &
                  "    LastCost = @Cost, " &
                  "    LastPaidPrice = @Cost, " &
                  "    AverageCost = CASE " &
                  "        WHEN ISNULL(CurrentStock, 0) + @Qty = 0 THEN AverageCost " &
                  "        ELSE ((ISNULL(AverageCost, 0) * ISNULL(CurrentStock, 0)) + (@Cost * @Qty)) / (ISNULL(CurrentStock, 0) + @Qty) " &
                  "    END " &
                  "WHERE MaterialID = @MaterialID"
        
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@MaterialID", materialId)
            cmd.Parameters.AddWithValue("@Qty", quantity)
            cmd.Parameters.AddWithValue("@Cost", unitCost)
            cmd.ExecuteNonQuery()
        End Using
        
        ' Record movement
        Dim moveSql = "INSERT INTO RawMaterialMovements (MaterialID, BranchID, MovementType, Quantity, UnitCost, MovementDate, Reference, CreatedBy) " &
                      "VALUES (@MaterialID, @BranchID, 'Purchase', @Qty, @Cost, GETDATE(), @Ref, @CreatedBy)"
        
        Using cmd As New SqlCommand(moveSql, con, tx)
            cmd.Parameters.AddWithValue("@MaterialID", materialId)
            cmd.Parameters.AddWithValue("@BranchID", branchId)
            cmd.Parameters.AddWithValue("@Qty", quantity)
            cmd.Parameters.AddWithValue("@Cost", unitCost)
            cmd.Parameters.AddWithValue("@Ref", reference)
            cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
    Private Sub UpdateExternalProductInventory(con As SqlConnection, tx As SqlTransaction, productId As Integer, branchId As Integer, quantity As Decimal, unitCost As Decimal, reference As String, createdBy As Integer)
        ' CRITICAL: Update Products table LastPaidPrice for External products
        Dim updateProductSql = "UPDATE Products " &
                               "SET LastPaidPrice = @Cost, " &
                               "    AverageCost = @Cost " &
                               "WHERE ProductID = @ProductID AND ItemType = 'External'"
        
        Using cmd As New SqlCommand(updateProductSql, con, tx)
            cmd.Parameters.AddWithValue("@ProductID", productId)
            cmd.Parameters.AddWithValue("@Cost", unitCost)
            cmd.ExecuteNonQuery()
        End Using
        
        ' Update Retail_Stock (branch-specific inventory)
        Dim checkSql = "SELECT COUNT(*) FROM Retail_Stock WHERE VariantID = @ProductID AND BranchID = @BranchID"
        Dim exists As Boolean = False
        
        Using cmd As New SqlCommand(checkSql, con, tx)
            cmd.Parameters.AddWithValue("@ProductID", productId)
            cmd.Parameters.AddWithValue("@BranchID", branchId)
            exists = Convert.ToInt32(cmd.ExecuteScalar()) > 0
        End Using
        
        If exists Then
            ' Update existing stock
            Dim updateSql = "UPDATE Retail_Stock " &
                           "SET QtyOnHand = ISNULL(QtyOnHand, 0) + @Qty, " &
                           "    AverageCost = CASE " &
                           "        WHEN ISNULL(QtyOnHand, 0) + @Qty = 0 THEN AverageCost " &
                           "        ELSE ((ISNULL(AverageCost, 0) * ISNULL(QtyOnHand, 0)) + (@Cost * @Qty)) / (ISNULL(QtyOnHand, 0) + @Qty) " &
                           "    END, " &
                           "    UpdatedAt = GETDATE() " &
                           "WHERE VariantID = @ProductID AND BranchID = @BranchID"
            
            Using cmd As New SqlCommand(updateSql, con, tx)
                cmd.Parameters.AddWithValue("@ProductID", productId)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                cmd.Parameters.AddWithValue("@Qty", quantity)
                cmd.Parameters.AddWithValue("@Cost", unitCost)
                cmd.ExecuteNonQuery()
            End Using
        Else
            ' Insert new stock record
            Dim insertSql = "INSERT INTO Retail_Stock (VariantID, BranchID, QtyOnHand, AverageCost, UpdatedAt) " &
                           "VALUES (@ProductID, @BranchID, @Qty, @Cost, GETDATE())"
            
            Using cmd As New SqlCommand(insertSql, con, tx)
                cmd.Parameters.AddWithValue("@ProductID", productId)
                cmd.Parameters.AddWithValue("@BranchID", branchId)
                cmd.Parameters.AddWithValue("@Qty", quantity)
                cmd.Parameters.AddWithValue("@Cost", unitCost)
                cmd.ExecuteNonQuery()
            End Using
        End If
        
        ' Record stock movement
        Dim moveSql = "INSERT INTO Retail_StockMovements (VariantID, BranchID, QtyDelta, Reason, Ref1, Ref2, CreatedAt, CreatedBy) " &
                      "VALUES (@ProductID, @BranchID, @Qty, 'Purchase', @Ref, 'Invoice Capture', GETDATE(), @CreatedBy)"
        
        Using cmd As New SqlCommand(moveSql, con, tx)
            cmd.Parameters.AddWithValue("@ProductID", productId)
            cmd.Parameters.AddWithValue("@BranchID", branchId)
            cmd.Parameters.AddWithValue("@Qty", quantity)
            cmd.Parameters.AddWithValue("@Ref", reference)
            cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
    Private Sub UpdatePurchaseOrderStatus(con As SqlConnection, tx As SqlTransaction, purchaseOrderId As Integer, status As String)
        Dim sql = "UPDATE PurchaseOrders SET Status = @Status WHERE PurchaseOrderID = @POID"
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@Status", status)
            cmd.Parameters.AddWithValue("@POID", purchaseOrderId)
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
    Private Sub CreateInvoiceLedgerEntries(con As SqlConnection, tx As SqlTransaction, invoiceId As Integer, branchId As Integer, supplierId As Integer, lines As DataTable, reference As String, createdBy As Integer)
        ' Create journal header
        Dim journalId As Integer = CreateJournalHeader(con, tx, branchId, DateTime.Today, reference, "Supplier Invoice", createdBy)
        
        ' Calculate totals
        Dim subTotal As Decimal = 0D
        For Each line As DataRow In lines.Rows
            subTotal += Convert.ToDecimal(line("Quantity")) * Convert.ToDecimal(line("UnitCost"))
        Next
        
        Dim vatRate As Decimal = GetVATRate(con, tx)
        Dim vatAmount As Decimal = Math.Round(subTotal * (vatRate / 100D), 2)
        Dim totalAmount As Decimal = subTotal + vatAmount
        
        ' DR Inventory (Asset)
        CreateJournalDetail(con, tx, journalId, GetInventoryAccountID(con, tx), subTotal, 0, $"Inventory - Invoice {reference}")
        
        ' DR VAT Input (Asset)
        CreateJournalDetail(con, tx, journalId, GetVATInputAccountID(con, tx), vatAmount, 0, $"VAT Input - Invoice {reference}")
        
        ' CR Accounts Payable (Liability - Creditor)
        CreateJournalDetail(con, tx, journalId, GetAPAccountID(con, tx), 0, totalAmount, $"Accounts Payable - Supplier Invoice {reference}")
    End Sub
    
    Private Function CreateJournalHeader(con As SqlConnection, tx As SqlTransaction, branchId As Integer, journalDate As DateTime, reference As String, description As String, createdBy As Integer) As Integer
        Dim sql = "INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, IsPosted, CreatedBy, CreatedDate) " &
                  "OUTPUT INSERTED.JournalID " &
                  "VALUES (@JNumber, @BranchID, @JDate, @Ref, @Desc, 0, @CreatedBy, GETDATE())"
        
        Dim journalNumber As String = $"JNL-{DateTime.Now:yyyyMMddHHmmss}"
        
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@JNumber", journalNumber)
            cmd.Parameters.AddWithValue("@BranchID", branchId)
            cmd.Parameters.AddWithValue("@JDate", journalDate)
            cmd.Parameters.AddWithValue("@Ref", reference)
            cmd.Parameters.AddWithValue("@Desc", description)
            cmd.Parameters.AddWithValue("@CreatedBy", createdBy)
            Return Convert.ToInt32(cmd.ExecuteScalar())
        End Using
    End Function
    
    Private Sub CreateJournalDetail(con As SqlConnection, tx As SqlTransaction, journalId As Integer, accountId As Integer, debit As Decimal, credit As Decimal, description As String)
        Dim sql = "INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description) " &
                  "VALUES (@JID, @AcctID, @Debit, @Credit, @Desc)"
        
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@JID", journalId)
            cmd.Parameters.AddWithValue("@AcctID", accountId)
            cmd.Parameters.AddWithValue("@Debit", debit)
            cmd.Parameters.AddWithValue("@Credit", credit)
            cmd.Parameters.AddWithValue("@Desc", description)
            cmd.ExecuteNonQuery()
        End Using
    End Sub
    
    Private Function GetVATRate(con As SqlConnection, tx As SqlTransaction) As Decimal
        Try
            Dim sql = "SELECT SettingValue FROM SystemSettings WHERE SettingKey = 'VATRatePercent'"
            Using cmd As New SqlCommand(sql, con, tx)
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing Then
                    Return Convert.ToDecimal(result)
                End If
            End Using
        Catch
        End Try
        Return 15D ' Default
    End Function
    
    Private Function GetInventoryAccountID(con As SqlConnection, tx As SqlTransaction) As Integer
        Return GetAccountIDByCode(con, tx, "1200", "Inventory")
    End Function
    
    Private Function GetVATInputAccountID(con As SqlConnection, tx As SqlTransaction) As Integer
        Return GetAccountIDByCode(con, tx, "1300", "VAT Input")
    End Function
    
    Private Function GetAPAccountID(con As SqlConnection, tx As SqlTransaction) As Integer
        Return GetAccountIDByCode(con, tx, "2100", "Accounts Payable")
    End Function
    
    Private Function GetAccountIDByCode(con As SqlConnection, tx As SqlTransaction, accountCode As String, accountName As String) As Integer
        Dim sql = "SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = @Code"
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@Code", accountCode)
            Dim result = cmd.ExecuteScalar()
            If result IsNot Nothing Then
                Return Convert.ToInt32(result)
            End If
        End Using
        
        ' Create if not exists
        Dim insertSql = "INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive) OUTPUT INSERTED.AccountID VALUES (@Code, @Name, 'Asset', 1)"
        Using cmd As New SqlCommand(insertSql, con, tx)
            cmd.Parameters.AddWithValue("@Code", accountCode)
            cmd.Parameters.AddWithValue("@Name", accountName)
            Return Convert.ToInt32(cmd.ExecuteScalar())
        End Using
    End Function
End Class
