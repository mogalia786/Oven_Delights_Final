Imports System.Windows.Forms
Imports System.Data
Imports System.Configuration
Imports Microsoft.Data.SqlClient

Public Class IssueToManufacturingForm
    Inherits Form

    Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private service As New StockroomService()
    Private currentBranchId As Integer
    
    Public Sub New()
        InitializeComponent()
        currentBranchId = AppSession.CurrentBranchID
        Me.Text = "Issue Materials to Manufacturing"
        Me.WindowState = FormWindowState.Maximized
        LoadMaterials()
    End Sub

    Private Sub LoadMaterials()
        Try
            Using con As New SqlConnection(connectionString)
                Dim sql = "SELECT rm.MaterialID, rm.MaterialCode, rm.MaterialName, " &
                         "ISNULL(rm.CurrentStock, 0) AS StockroomQty, " &
                         "ISNULL(rm.AverageCost, 0) AS UnitCost, " &
                         "rm.UnitOfMeasure " &
                         "FROM RawMaterials rm " &
                         "WHERE ISNULL(rm.IsActive, 1) = 1 " &
                         "AND ISNULL(rm.CurrentStock, 0) > 0 " &
                         "ORDER BY rm.MaterialName"
                
                Using ad As New SqlDataAdapter(sql, con)
                    Dim dt As New DataTable()
                    ad.Fill(dt)
                    dgvMaterials.DataSource = dt
                    FormatGrid()
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading materials: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub FormatGrid()
        If dgvMaterials.Columns.Count = 0 Then Return
        
        Try
            If dgvMaterials.Columns.Contains("MaterialID") Then
                dgvMaterials.Columns("MaterialID").Visible = False
            End If
            If dgvMaterials.Columns.Contains("MaterialCode") Then
                dgvMaterials.Columns("MaterialCode").HeaderText = "Code"
                dgvMaterials.Columns("MaterialCode").Width = 100
            End If
            If dgvMaterials.Columns.Contains("MaterialName") Then
                dgvMaterials.Columns("MaterialName").HeaderText = "Material Name"
                dgvMaterials.Columns("MaterialName").Width = 250
            End If
            If dgvMaterials.Columns.Contains("StockroomQty") Then
                dgvMaterials.Columns("StockroomQty").HeaderText = "Available Qty"
                dgvMaterials.Columns("StockroomQty").Width = 120
                dgvMaterials.Columns("StockroomQty").DefaultCellStyle.Format = "N2"
            End If
            If dgvMaterials.Columns.Contains("UnitCost") Then
                dgvMaterials.Columns("UnitCost").HeaderText = "Unit Cost"
                dgvMaterials.Columns("UnitCost").Width = 100
                dgvMaterials.Columns("UnitCost").DefaultCellStyle.Format = "C2"
            End If
            If dgvMaterials.Columns.Contains("UnitOfMeasure") Then
                dgvMaterials.Columns("UnitOfMeasure").HeaderText = "UoM"
                dgvMaterials.Columns("UnitOfMeasure").Width = 80
            End If
        Catch ex As Exception
            ' Silently handle column formatting errors
        End Try
        
        ' Add quantity to issue column
        If Not dgvMaterials.Columns.Contains("QtyToIssue") Then
            Dim qtyCol As New DataGridViewTextBoxColumn With {
                .Name = "QtyToIssue",
                .HeaderText = "Qty to Issue",
                .Width = 100,
                .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "N2"}
            }
            dgvMaterials.Columns.Add(qtyCol)
        End If
    End Sub

    Private Sub btnIssue_Click(sender As Object, e As EventArgs) Handles btnIssue.Click
        Try
            Dim issuedItems As New List(Of (MaterialID As Integer, Quantity As Decimal, UnitCost As Decimal))
            
            For Each row As DataGridViewRow In dgvMaterials.Rows
                If row.IsNewRow Then Continue For
                
                Dim qtyCell = row.Cells("QtyToIssue").Value
                If qtyCell Is Nothing OrElse String.IsNullOrWhiteSpace(qtyCell.ToString()) Then Continue For
                
                Dim qtyToIssue As Decimal
                If Not Decimal.TryParse(qtyCell.ToString(), qtyToIssue) OrElse qtyToIssue <= 0 Then Continue For
                
                Dim materialId As Integer = Convert.ToInt32(row.Cells("MaterialID").Value)
                Dim availableQty As Decimal = Convert.ToDecimal(row.Cells("StockroomQty").Value)
                Dim unitCost As Decimal = Convert.ToDecimal(row.Cells("UnitCost").Value)
                
                If qtyToIssue > availableQty Then
                    MessageBox.Show($"Insufficient stock for {row.Cells("MaterialName").Value}. Available: {availableQty}", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                
                issuedItems.Add((materialId, qtyToIssue, unitCost))
            Next
            
            If issuedItems.Count = 0 Then
                MessageBox.Show("Please enter quantities to issue.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Process issue
            IssueToManufacturing(issuedItems)
            
            MessageBox.Show($"Successfully issued {issuedItems.Count} materials to manufacturing.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            LoadMaterials()
            
        Catch ex As Exception
            MessageBox.Show($"Error issuing materials: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub IssueToManufacturing(items As List(Of (MaterialID As Integer, Quantity As Decimal, UnitCost As Decimal)))
        Using con As New SqlConnection(connectionString)
            con.Open()
            Using tx = con.BeginTransaction()
                Try
                    Dim issueNumber As String = $"ISS-{DateTime.Now:yyyyMMddHHmmss}"
                    
                    For Each item In items
                        ' Reduce Stockroom inventory
                        Dim updateStockroom = "UPDATE RawMaterials SET CurrentStock = CurrentStock - @Qty WHERE MaterialID = @MaterialID"
                        Using cmd As New SqlCommand(updateStockroom, con, tx)
                            cmd.Parameters.AddWithValue("@MaterialID", item.MaterialID)
                            cmd.Parameters.AddWithValue("@Qty", item.Quantity)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' Increase Manufacturing inventory
                        Dim checkMfg = "SELECT COUNT(*) FROM Manufacturing_Inventory WHERE MaterialID = @MaterialID AND BranchID = @BranchID"
                        Dim exists As Boolean = False
                        Using cmd As New SqlCommand(checkMfg, con, tx)
                            cmd.Parameters.AddWithValue("@MaterialID", item.MaterialID)
                            cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                            exists = Convert.ToInt32(cmd.ExecuteScalar()) > 0
                        End Using
                        
                        If exists Then
                            Dim updateMfg = "UPDATE Manufacturing_Inventory SET QtyOnHand = QtyOnHand + @Qty, AverageCost = @Cost, LastUpdated = GETDATE() WHERE MaterialID = @MaterialID AND BranchID = @BranchID"
                            Using cmd As New SqlCommand(updateMfg, con, tx)
                                cmd.Parameters.AddWithValue("@MaterialID", item.MaterialID)
                                cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                                cmd.Parameters.AddWithValue("@Qty", item.Quantity)
                                cmd.Parameters.AddWithValue("@Cost", item.UnitCost)
                                cmd.ExecuteNonQuery()
                            End Using
                        Else
                            Dim insertMfg = "INSERT INTO Manufacturing_Inventory (MaterialID, BranchID, QtyOnHand, AverageCost, LastUpdated, UpdatedBy) VALUES (@MaterialID, @BranchID, @Qty, @Cost, GETDATE(), @UserID)"
                            Using cmd As New SqlCommand(insertMfg, con, tx)
                                cmd.Parameters.AddWithValue("@MaterialID", item.MaterialID)
                                cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                                cmd.Parameters.AddWithValue("@Qty", item.Quantity)
                                cmd.Parameters.AddWithValue("@Cost", item.UnitCost)
                                cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
                                cmd.ExecuteNonQuery()
                            End Using
                        End If
                        
                        ' Record movement
                        Dim insertMove = "INSERT INTO Manufacturing_InventoryMovements (MaterialID, BranchID, MovementType, QtyDelta, CostPerUnit, MovementDate, Reference, CreatedBy) VALUES (@MaterialID, @BranchID, 'Issue', @Qty, @Cost, GETDATE(), @Ref, @UserID)"
                        Using cmd As New SqlCommand(insertMove, con, tx)
                            cmd.Parameters.AddWithValue("@MaterialID", item.MaterialID)
                            cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                            cmd.Parameters.AddWithValue("@Qty", item.Quantity)
                            cmd.Parameters.AddWithValue("@Cost", item.UnitCost)
                            cmd.Parameters.AddWithValue("@Ref", issueNumber)
                            cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
                            cmd.ExecuteNonQuery()
                        End Using
                    Next
                    
                    ' Create ledger entries: DR Manufacturing Inventory, CR Stockroom Inventory
                    CreateLedgerEntries(con, tx, items, issueNumber)
                    
                    tx.Commit()
                Catch
                    tx.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Private Sub CreateLedgerEntries(con As SqlConnection, tx As SqlTransaction, items As List(Of (MaterialID As Integer, Quantity As Decimal, UnitCost As Decimal)), reference As String)
        Dim totalValue As Decimal = items.Sum(Function(i) i.Quantity * i.UnitCost)
        
        ' Create journal header
        Dim journalId As Integer
        Dim jSql = "INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, IsPosted, CreatedBy, CreatedDate) OUTPUT INSERTED.JournalID VALUES (@JNum, @BranchID, GETDATE(), @Ref, @Desc, 0, @UserID, GETDATE())"
        Using cmd As New SqlCommand(jSql, con, tx)
            cmd.Parameters.AddWithValue("@JNum", $"JNL-{DateTime.Now:yyyyMMddHHmmss}")
            cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
            cmd.Parameters.AddWithValue("@Ref", reference)
            cmd.Parameters.AddWithValue("@Desc", "Issue to Manufacturing")
            cmd.Parameters.AddWithValue("@UserID", AppSession.CurrentUserID)
            journalId = Convert.ToInt32(cmd.ExecuteScalar())
        End Using
        
        ' DR Manufacturing Inventory
        Dim dSql = "INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description) VALUES (@JID, @AcctID, @Amount, 0, @Desc)"
        Using cmd As New SqlCommand(dSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", journalId)
            cmd.Parameters.AddWithValue("@AcctID", GetMfgInventoryAccountID(con, tx))
            cmd.Parameters.AddWithValue("@Amount", totalValue)
            cmd.Parameters.AddWithValue("@Desc", $"Manufacturing Inventory - {reference}")
            cmd.ExecuteNonQuery()
        End Using
        
        ' CR Stockroom Inventory
        Using cmd As New SqlCommand(dSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", journalId)
            cmd.Parameters.AddWithValue("@AcctID", GetStockroomInventoryAccountID(con, tx))
            cmd.Parameters.AddWithValue("@Amount", 0)
            cmd.Parameters.AddWithValue("@Desc", $"Stockroom Inventory - {reference}")
            cmd.Parameters("@Amount").Value = 0
            cmd.Parameters("@Desc").Value = $"Stockroom Inventory - {reference}"
            cmd.ExecuteNonQuery()
        End Using
        
        ' CR Stockroom Inventory (credit side)
        Dim cSql = "INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description) VALUES (@JID, @AcctID, 0, @Amount, @Desc)"
        Using cmd As New SqlCommand(cSql, con, tx)
            cmd.Parameters.AddWithValue("@JID", journalId)
            cmd.Parameters.AddWithValue("@AcctID", GetStockroomInventoryAccountID(con, tx))
            cmd.Parameters.AddWithValue("@Amount", totalValue)
            cmd.Parameters.AddWithValue("@Desc", $"Stockroom Inventory - {reference}")
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Function GetMfgInventoryAccountID(con As SqlConnection, tx As SqlTransaction) As Integer
        Return GetOrCreateAccountID(con, tx, "1210", "Manufacturing Inventory")
    End Function

    Private Function GetStockroomInventoryAccountID(con As SqlConnection, tx As SqlTransaction) As Integer
        Return GetOrCreateAccountID(con, tx, "1200", "Stockroom Inventory")
    End Function

    Private Function GetOrCreateAccountID(con As SqlConnection, tx As SqlTransaction, code As String, name As String) As Integer
        Dim sql = "SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = @Code"
        Using cmd As New SqlCommand(sql, con, tx)
            cmd.Parameters.AddWithValue("@Code", code)
            Dim result = cmd.ExecuteScalar()
            If result IsNot Nothing Then Return Convert.ToInt32(result)
        End Using
        
        Dim insertSql = "INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive) OUTPUT INSERTED.AccountID VALUES (@Code, @Name, 'Asset', 1)"
        Using cmd As New SqlCommand(insertSql, con, tx)
            cmd.Parameters.AddWithValue("@Code", code)
            cmd.Parameters.AddWithValue("@Name", name)
            Return Convert.ToInt32(cmd.ExecuteScalar())
        End Using
    End Function

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
