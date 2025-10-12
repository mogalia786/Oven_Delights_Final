Imports System.Data
Imports System.Windows.Forms
Imports System.Configuration
Imports System.Data.SqlClient

Public Class CreditNoteCreateForm
    Inherits Form
    Private ReadOnly grvService As New GRVService()
    Private ReadOnly stockroomService As New StockroomService()
    Private ReadOnly grvId As Integer
    Private currentBranchId As Integer
    
    ' Controls are declared in Designer file
    Private lblGRVInfo As New Label()
    Private lblTotals As New Label()
    
    Private creditLinesTable As DataTable

    Public Sub New(grvId As Integer)
        Me.grvId = grvId
        currentBranchId = stockroomService.GetCurrentUserBranchId()
        InitializeComponent()
        LoadData()
    End Sub

    ' InitializeComponent is in Designer file

    Private Sub LoadData()
        Try
            ' Load GRV details
            Dim grvDetails As DataTable = grvService.GetGRVDetails(grvId)
            If grvDetails.Rows.Count > 0 Then
                Dim row As DataRow = grvDetails.Rows(0)
                lblGRVInfo.Text = $"Credit Note for GRV: {row("GRVNumber")} | Supplier: {row("SupplierName")} | Date: {Convert.ToDateTime(row("ReceivedDate")):dd/MM/yyyy}"
            End If
            
            ' Load GRV lines
            Dim grvLines As DataTable = grvService.GetGRVLines(grvId)
            dgvGRVLines.DataSource = grvLines
            FormatGRVLinesGrid()
            
            ' Initialize credit lines table
            InitializeCreditLinesTable()
            
        Catch ex As Exception
            MessageBox.Show($"Error loading data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub InitializeCreditLinesTable()
        creditLinesTable = New DataTable()
        creditLinesTable.Columns.Add("GRVLineID", GetType(Integer))
        creditLinesTable.Columns.Add("ItemName", GetType(String))
        creditLinesTable.Columns.Add("ItemCode", GetType(String))
        creditLinesTable.Columns.Add("ItemType", GetType(String))
        creditLinesTable.Columns.Add("MaterialID", GetType(Integer))
        creditLinesTable.Columns.Add("ProductID", GetType(Integer))
        creditLinesTable.Columns.Add("MaxCreditQty", GetType(Decimal))
        creditLinesTable.Columns.Add("CreditQuantity", GetType(Decimal))
        creditLinesTable.Columns.Add("UnitCost", GetType(Decimal))
        creditLinesTable.Columns.Add("LineTotal", GetType(Decimal), "CreditQuantity * UnitCost")
        creditLinesTable.Columns.Add("Reason", GetType(String))
        
        dgvCreditLines.DataSource = creditLinesTable
        FormatCreditLinesGrid()
    End Sub

    Private Sub FormatGRVLinesGrid()
        ' Hide system columns
        For Each col As String In {"GRVLineID", "GRVID", "POLineID", "MaterialID", "ProductID", 
                                  "CreatedDate", "CreatedBy", "QualityCheckedBy", "QualityCheckedDate"}
            If dgvGRVLines.Columns.Contains(col) Then
                dgvGRVLines.Columns(col).Visible = False
            End If
        Next
        
        ' Format display columns
        If dgvGRVLines.Columns.Contains("ItemName") Then dgvGRVLines.Columns("ItemName").HeaderText = "Item"
        If dgvGRVLines.Columns.Contains("ItemCode") Then dgvGRVLines.Columns("ItemCode").HeaderText = "Code"
        If dgvGRVLines.Columns.Contains("ReceivedQuantity") Then dgvGRVLines.Columns("ReceivedQuantity").HeaderText = "Received"
        If dgvGRVLines.Columns.Contains("AcceptedQuantity") Then dgvGRVLines.Columns("AcceptedQuantity").HeaderText = "Accepted"
        If dgvGRVLines.Columns.Contains("QualityStatus") Then dgvGRVLines.Columns("QualityStatus").HeaderText = "Quality"
        If dgvGRVLines.Columns.Contains("UnitCost") Then 
            dgvGRVLines.Columns("UnitCost").HeaderText = "Unit Cost"
            dgvGRVLines.Columns("UnitCost").DefaultCellStyle.Format = "C2"
        End If
    End Sub

    Private Sub FormatCreditLinesGrid()
        ' Hide system columns
        For Each col As String In {"GRVLineID", "MaterialID", "ProductID", "ItemType"}
            If dgvCreditLines.Columns.Contains(col) Then
                dgvCreditLines.Columns(col).Visible = False
            End If
        Next
        
        ' Format display columns
        If dgvCreditLines.Columns.Contains("ItemName") Then dgvCreditLines.Columns("ItemName").HeaderText = "Item"
        If dgvCreditLines.Columns.Contains("ItemCode") Then dgvCreditLines.Columns("ItemCode").HeaderText = "Code"
        If dgvCreditLines.Columns.Contains("MaxCreditQty") Then 
            dgvCreditLines.Columns("MaxCreditQty").HeaderText = "Max Credit"
            dgvCreditLines.Columns("MaxCreditQty").ReadOnly = True
        End If
        If dgvCreditLines.Columns.Contains("CreditQuantity") Then 
            dgvCreditLines.Columns("CreditQuantity").HeaderText = "Credit Qty"
            dgvCreditLines.Columns("CreditQuantity").DefaultCellStyle.BackColor = Color.LightYellow
        End If
        If dgvCreditLines.Columns.Contains("UnitCost") Then 
            dgvCreditLines.Columns("UnitCost").HeaderText = "Unit Cost"
            dgvCreditLines.Columns("UnitCost").DefaultCellStyle.Format = "C2"
            dgvCreditLines.Columns("UnitCost").ReadOnly = True
        End If
        If dgvCreditLines.Columns.Contains("LineTotal") Then 
            dgvCreditLines.Columns("LineTotal").HeaderText = "Line Total"
            dgvCreditLines.Columns("LineTotal").DefaultCellStyle.Format = "C2"
            dgvCreditLines.Columns("LineTotal").ReadOnly = True
        End If
        If dgvCreditLines.Columns.Contains("Reason") Then 
            dgvCreditLines.Columns("Reason").HeaderText = "Line Reason"
            dgvCreditLines.Columns("Reason").DefaultCellStyle.BackColor = Color.LightYellow
        End If
    End Sub

    Private Sub btnAddLine_Click(sender As Object, e As EventArgs) Handles btnAddLine.Click
        If dgvGRVLines.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select GRV items to add to the credit note.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        For Each row As DataGridViewRow In dgvGRVLines.SelectedRows
            Dim grvLineId As Integer = Convert.ToInt32(row.Cells("GRVLineID").Value)
            
            ' Check if already added
            Dim exists As Boolean = False
            For Each creditRow As DataRow In creditLinesTable.Rows
                If Convert.ToInt32(creditRow("GRVLineID")) = grvLineId Then
                    exists = True
                    Exit For
                End If
            Next
            
            If Not exists Then
                Dim newRow As DataRow = creditLinesTable.NewRow()
                newRow("GRVLineID") = grvLineId
                newRow("ItemName") = row.Cells("ItemName").Value
                newRow("ItemCode") = row.Cells("ItemCode").Value
                newRow("ItemType") = row.Cells("ItemType").Value
                newRow("MaterialID") = If(IsDBNull(row.Cells("MaterialID").Value), DBNull.Value, row.Cells("MaterialID").Value)
                newRow("ProductID") = If(IsDBNull(row.Cells("ProductID").Value), DBNull.Value, row.Cells("ProductID").Value)
                newRow("MaxCreditQty") = Convert.ToDecimal(row.Cells("AcceptedQuantity").Value)
                newRow("CreditQuantity") = 0
                newRow("UnitCost") = Convert.ToDecimal(row.Cells("UnitCost").Value)
                newRow("Reason") = ""
                
                creditLinesTable.Rows.Add(newRow)
            End If
        Next
        
        UpdateTotals()
    End Sub

    Private Sub btnRemoveLine_Click(sender As Object, e As EventArgs) Handles btnRemoveLine.Click
        If dgvCreditLines.CurrentRow IsNot Nothing Then
            dgvCreditLines.Rows.Remove(dgvCreditLines.CurrentRow)
            UpdateTotals()
        End If
    End Sub

    Private Sub dgvCreditLines_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs) Handles dgvCreditLines.CellValueChanged
        If e.RowIndex >= 0 AndAlso e.ColumnIndex >= 0 Then
            If dgvCreditLines.Columns(e.ColumnIndex).Name = "CreditQuantity" Then
                UpdateTotals()
            End If
        End If
    End Sub

    Private Sub UpdateTotals()
        Dim subTotal As Decimal = 0
        For Each row As DataRow In creditLinesTable.Rows
            Dim creditQty As Decimal = Convert.ToDecimal(row("CreditQuantity"))
            Dim unitCost As Decimal = Convert.ToDecimal(row("UnitCost"))
            subTotal += creditQty * unitCost
        Next
        
        Dim vatAmount As Decimal = subTotal * 0.15D
        Dim totalAmount As Decimal = subTotal + vatAmount
        
        lblTotals.Text = $"Sub Total: {subTotal:C2}" & vbCrLf & 
                        $"VAT (15%): {vatAmount:C2}" & vbCrLf & 
                        $"Total: {totalAmount:C2}"
        
        btnCreate.Enabled = totalAmount > 0
    End Sub

    Private Sub btnCreate_Click(sender As Object, e As EventArgs) Handles btnCreate.Click
        Try
            ' Validation
            If String.IsNullOrWhiteSpace(txtReason.Text) Then
                MessageBox.Show("Please enter a reason for the credit note.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If creditLinesTable.Rows.Count = 0 Then
                MessageBox.Show("Please add at least one credit line.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ' Validate credit quantities
            For Each row As DataRow In creditLinesTable.Rows
                Dim creditQty As Decimal = Convert.ToDecimal(row("CreditQuantity"))
                Dim maxQty As Decimal = Convert.ToDecimal(row("MaxCreditQty"))
                
                If creditQty <= 0 Then
                    MessageBox.Show($"Credit quantity must be greater than 0 for item: {row("ItemName")}", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                
                If creditQty > maxQty Then
                    MessageBox.Show($"Credit quantity cannot exceed accepted quantity for item: {row("ItemName")}", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
            Next
            
            ' Create credit note
            Dim grvDetails As DataTable = grvService.GetGRVDetails(grvId)
            Dim branchId As Integer = Convert.ToInt32(grvDetails.Rows(0)("BranchID"))
            
            Dim cnId As Integer = grvService.CreateCreditNote(
                grvId, cboCreditType.Text, txtReason.Text.Trim(),
                dtpCreditDate.Value.Date, branchId, AppSession.CurrentUserID
            )
            
            Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                con.Open()
                Using tx As SqlTransaction = con.BeginTransaction()
                    Try
                        ' Add credit note lines
                        For Each row As DataRow In creditLinesTable.Rows
                            Dim sql As String = "INSERT INTO CreditNoteLines 
                                (CreditNoteID, GRVLineID, MaterialID, ProductID, ItemType, 
                                 CreditQuantity, UnitCost, LineReason, CreatedBy)
                                VALUES (@cnId, @grvLineId, @matId, @prodId, @type, @qty, @cost, @reason, @by)"
                            
                            Using cmd As New SqlCommand(sql, con, tx)
                                cmd.Parameters.AddWithValue("@cnId", cnId)
                                cmd.Parameters.AddWithValue("@grvLineId", Convert.ToInt32(row("GRVLineID")))
                                cmd.Parameters.AddWithValue("@matId", If(IsDBNull(row("MaterialID")), DBNull.Value, row("MaterialID")))
                                cmd.Parameters.AddWithValue("@prodId", If(IsDBNull(row("ProductID")), DBNull.Value, row("ProductID")))
                                cmd.Parameters.AddWithValue("@type", Convert.ToString(row("ItemType")))
                                cmd.Parameters.AddWithValue("@qty", Convert.ToDecimal(row("CreditQuantity")))
                                cmd.Parameters.AddWithValue("@cost", Convert.ToDecimal(row("UnitCost")))
                                cmd.Parameters.AddWithValue("@reason", Convert.ToString(row("Reason")))
                                cmd.Parameters.AddWithValue("@by", AppSession.CurrentUserID)
                                
                                cmd.ExecuteNonQuery()
                            End Using
                        Next
                        
                        ' Update credit note totals
                        Dim subTotal As Decimal = 0
                        For Each row As DataRow In creditLinesTable.Rows
                            subTotal += Convert.ToDecimal(row("CreditQuantity")) * Convert.ToDecimal(row("UnitCost"))
                        Next
                        
                        Dim vatAmount As Decimal = subTotal * 0.15D
                        Dim totalAmount As Decimal = subTotal + vatAmount
                        
                        Dim sqlUpdate As String = "UPDATE CreditNotes 
                            SET SubTotal = @sub, VATAmount = @vat, TotalAmount = @total
                            WHERE CreditNoteID = @id"
                        Using cmdUpdate As New SqlCommand(sqlUpdate, con, tx)
                            cmdUpdate.Parameters.AddWithValue("@sub", subTotal)
                            cmdUpdate.Parameters.AddWithValue("@vat", vatAmount)
                            cmdUpdate.Parameters.AddWithValue("@total", totalAmount)
                            cmdUpdate.Parameters.AddWithValue("@id", cnId)
                            cmdUpdate.ExecuteNonQuery()
                        End Using
                        
                        tx.Commit()
                        
                        ' Show print/email option
                        Dim result As DialogResult = MessageBox.Show($"Credit note created successfully. Credit Note ID: {cnId}" & vbCrLf & vbCrLf &
                                                                    "Would you like to print or email this credit note to the supplier?", 
                                                                    "Credit Note Created", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
                        
                        If result = DialogResult.Yes Then
                            ' Create credit note data structure
                            Dim creditNote As New CreditNoteData()
                            creditNote.CreditNoteNumber = "CN" & cnId.ToString("D6")
                            creditNote.SupplierName = "Supplier Name" ' Get from GRV data
                            creditNote.SupplierAddress = ""
                            creditNote.SupplierEmail = ""
                            creditNote.IssueDate = DateTime.Now
                            creditNote.MaterialCode = "Material Code" ' Get from selected line
                            creditNote.MaterialName = "Material Name" ' Get from selected line
                            creditNote.ReturnQuantity = 1 ' Get from selected line
                            creditNote.UnitCost = 0 ' Get from selected line
                            creditNote.TotalAmount = 0 ' Calculate from quantity * cost
                            creditNote.Reason = txtReason.Text
                            creditNote.Comments = txtReason.Text
                            creditNote.PONumber = ""
                            creditNote.DeliveryNote = ""
                            
                            Using printForm As New CreditNotePrintForm(creditNote)
                                printForm.ShowDialog()
                            End Using
                        End If
                        
                        Me.DialogResult = DialogResult.OK
                        Me.Close()
                        
                    Catch ex As Exception
                        tx.Rollback()
                        Throw
                    End Try
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error creating credit note: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
