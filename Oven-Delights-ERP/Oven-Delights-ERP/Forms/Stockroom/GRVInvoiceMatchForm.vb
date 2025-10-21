Imports System.Data
Imports System.Windows.Forms
Imports System.Configuration
Imports System.Data.SqlClient

Public Class GRVInvoiceMatchForm
    Inherits Form
    Private ReadOnly grvService As New GRVService()
    Private ReadOnly stockroomService As New StockroomService()
    Private ReadOnly grvId As Integer
    Private currentBranchId As Integer
    
    ' Controls are declared in Designer file
    Private WithEvents cboInvoice As ComboBox
    Private WithEvents btnAutoMatch As Button
    Private WithEvents btnManualMatch As Button
    Private WithEvents btnSaveMatching As Button
    Private WithEvents dgvMatching As DataGridView
    Private lblVarianceSummary As Label
    
    Private matchingTable As DataTable

    Public Sub New(grvId As Integer)
        Me.grvId = grvId
        currentBranchId = stockroomService.GetCurrentUserBranchId()
        InitializeComponent()
        LoadData()
    End Sub

    ' InitializeComponent is in Designer file

    Private Sub InitializeMatchingTable()
        matchingTable = New DataTable()
        matchingTable.Columns.Add("GRVLineID", GetType(Integer))
        matchingTable.Columns.Add("InvoiceLineID", GetType(Integer))
        matchingTable.Columns.Add("ItemName", GetType(String))
        matchingTable.Columns.Add("GRVQuantity", GetType(Decimal))
        matchingTable.Columns.Add("InvoiceQuantity", GetType(Decimal))
        matchingTable.Columns.Add("MatchedQuantity", GetType(Decimal))
        matchingTable.Columns.Add("GRVAmount", GetType(Decimal))
        matchingTable.Columns.Add("InvoiceAmount", GetType(Decimal))
        matchingTable.Columns.Add("MatchedAmount", GetType(Decimal))
        matchingTable.Columns.Add("QuantityVariance", GetType(Decimal), "MatchedQuantity - GRVQuantity")
        matchingTable.Columns.Add("AmountVariance", GetType(Decimal), "MatchedAmount - GRVAmount")
        matchingTable.Columns.Add("Status", GetType(String))
        matchingTable.Columns.Add("VarianceReason", GetType(String))
        
        dgvMatching.DataSource = matchingTable
        FormatMatchingGrid()
    End Sub

    Private Sub LoadData()
        Try
            ' Load GRV details
            Dim grvDetails As DataTable = grvService.GetGRVDetails(grvId)
            If grvDetails.Rows.Count > 0 Then
                Dim row As DataRow = grvDetails.Rows(0)
                lblGRVInfo.Text = $"Matching GRV: {row("GRVNumber")} | Supplier: {row("SupplierName")} | Total: {Convert.ToDecimal(row("TotalAmount")):C2}"
            End If
            
            ' Load GRV lines
            Dim grvLines As DataTable = grvService.GetGRVLines(grvId)
            dgvGRVLines.DataSource = grvLines
            FormatGRVLinesGrid()
            
            ' Load available invoices for the same supplier
            LoadInvoices()
            
        Catch ex As Exception
            MessageBox.Show($"Error loading data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadInvoices()
        Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            Dim sql As String = "
                SELECT i.InvoiceID, i.InvoiceNumber + ' - ' + FORMAT(i.InvoiceDate, 'dd/MM/yyyy') + ' - ' + FORMAT(i.TotalAmount, 'C2') AS InvoiceDisplay
                FROM Invoices i
                INNER JOIN GoodsReceivedNotes grv ON i.SupplierID = grv.SupplierID
                WHERE grv.GRNID = @grvId 
                AND i.Status IN ('Pending', 'Approved')
                AND i.InvoiceID NOT IN (
                    SELECT DISTINCT InvoiceID 
                    FROM GRVInvoiceMatching 
                    WHERE GRVID = @grvId
                )
                ORDER BY i.InvoiceDate DESC"
            Using da As New SqlDataAdapter(sql, con)
                da.SelectCommand.Parameters.AddWithValue("@grvId", grvId)
                Dim dt As New DataTable()
                da.Fill(dt)
                
                cboInvoice.DataSource = dt
                cboInvoice.DisplayMember = "InvoiceDisplay"
                cboInvoice.ValueMember = "InvoiceID"
                
                If dt.Rows.Count > 0 Then
                    cboInvoice.SelectedIndex = 0
                End If
            End Using
        End Using
    End Sub

    Private Sub LoadInvoiceLines()
        If cboInvoice.SelectedValue Is Nothing Then
            dgvInvoiceLines.DataSource = Nothing
            Return
        End If
        
        Dim invoiceId As Integer = Convert.ToInt32(cboInvoice.SelectedValue)
        
        Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            Dim sql As String = "
                SELECT il.InvoiceLineID, il.POLineID,
                       COALESCE(rm.MaterialName, p.Name, sp.Name) AS ItemName,
                       COALESCE(rm.MaterialCode, p.SKU, sp.Code) AS ItemCode,
                       il.Quantity, il.UnitPrice, il.LineTotal,
                       CASE WHEN il.MaterialID IS NOT NULL THEN 'Raw Material' ELSE 'Product' END AS ItemType
                FROM InvoiceLines il
                LEFT JOIN RawMaterials rm ON il.MaterialID = rm.MaterialID
                LEFT JOIN Products p ON il.ProductID = p.ProductID
                LEFT JOIN Stockroom_Product sp ON il.ProductID = sp.ProductID
                WHERE il.InvoiceID = @invoiceId
                ORDER BY il.LineNumber"
            Using da As New SqlDataAdapter(sql, con)
                da.SelectCommand.Parameters.AddWithValue("@invoiceId", invoiceId)
                Dim dt As New DataTable()
                da.Fill(dt)
                
                dgvInvoiceLines.DataSource = dt
                FormatInvoiceLinesGrid()
            End Using
        End Using
    End Sub

    Private Sub FormatGRVLinesGrid()
        ' Hide system columns
        For Each col As String In {"GRVLineID", "GRVID", "POLineID", "MaterialID", "ProductID"}
            If dgvGRVLines.Columns.Contains(col) Then
                dgvGRVLines.Columns(col).Visible = False
            End If
        Next
        
        If dgvGRVLines.Columns.Contains("ItemName") Then dgvGRVLines.Columns("ItemName").HeaderText = "Item"
        If dgvGRVLines.Columns.Contains("AcceptedQuantity") Then dgvGRVLines.Columns("AcceptedQuantity").HeaderText = "Accepted Qty"
        If dgvGRVLines.Columns.Contains("UnitCost") Then 
            dgvGRVLines.Columns("UnitCost").HeaderText = "Unit Cost"
            dgvGRVLines.Columns("UnitCost").DefaultCellStyle.Format = "C2"
        End If
        If dgvGRVLines.Columns.Contains("LineTotal") Then 
            dgvGRVLines.Columns("LineTotal").HeaderText = "Line Total"
            dgvGRVLines.Columns("LineTotal").DefaultCellStyle.Format = "C2"
        End If
    End Sub

    Private Sub FormatInvoiceLinesGrid()
        ' Hide system columns
        For Each col As String In {"InvoiceLineID", "POLineID"}
            If dgvInvoiceLines.Columns.Contains(col) Then
                dgvInvoiceLines.Columns(col).Visible = False
            End If
        Next
        
        If dgvInvoiceLines.Columns.Contains("ItemName") Then dgvInvoiceLines.Columns("ItemName").HeaderText = "Item"
        If dgvInvoiceLines.Columns.Contains("Quantity") Then dgvInvoiceLines.Columns("Quantity").HeaderText = "Invoice Qty"
        If dgvInvoiceLines.Columns.Contains("UnitPrice") Then 
            dgvInvoiceLines.Columns("UnitPrice").HeaderText = "Unit Price"
            dgvInvoiceLines.Columns("UnitPrice").DefaultCellStyle.Format = "C2"
        End If
        If dgvInvoiceLines.Columns.Contains("LineTotal") Then 
            dgvInvoiceLines.Columns("LineTotal").HeaderText = "Line Total"
            dgvInvoiceLines.Columns("LineTotal").DefaultCellStyle.Format = "C2"
        End If
    End Sub

    Private Sub FormatMatchingGrid()
        ' Hide system columns
        For Each col As String In {"GRVLineID", "InvoiceLineID"}
            If dgvMatching.Columns.Contains(col) Then
                dgvMatching.Columns(col).Visible = False
            End If
        Next
        
        If dgvMatching.Columns.Contains("ItemName") Then dgvMatching.Columns("ItemName").HeaderText = "Item"
        If dgvMatching.Columns.Contains("GRVQuantity") Then dgvMatching.Columns("GRVQuantity").HeaderText = "GRV Qty"
        If dgvMatching.Columns.Contains("InvoiceQuantity") Then dgvMatching.Columns("InvoiceQuantity").HeaderText = "Invoice Qty"
        If dgvMatching.Columns.Contains("MatchedQuantity") Then 
            dgvMatching.Columns("MatchedQuantity").HeaderText = "Matched Qty"
            dgvMatching.Columns("MatchedQuantity").DefaultCellStyle.BackColor = Color.LightYellow
        End If
        If dgvMatching.Columns.Contains("GRVAmount") Then 
            dgvMatching.Columns("GRVAmount").HeaderText = "GRV Amount"
            dgvMatching.Columns("GRVAmount").DefaultCellStyle.Format = "C2"
        End If
        If dgvMatching.Columns.Contains("InvoiceAmount") Then 
            dgvMatching.Columns("InvoiceAmount").HeaderText = "Invoice Amount"
            dgvMatching.Columns("InvoiceAmount").DefaultCellStyle.Format = "C2"
        End If
        If dgvMatching.Columns.Contains("MatchedAmount") Then 
            dgvMatching.Columns("MatchedAmount").HeaderText = "Matched Amount"
            dgvMatching.Columns("MatchedAmount").DefaultCellStyle.Format = "C2"
            dgvMatching.Columns("MatchedAmount").DefaultCellStyle.BackColor = Color.LightYellow
        End If
        If dgvMatching.Columns.Contains("QuantityVariance") Then 
            dgvMatching.Columns("QuantityVariance").HeaderText = "Qty Variance"
            dgvMatching.Columns("QuantityVariance").DefaultCellStyle.BackColor = Color.LightPink
        End If
        If dgvMatching.Columns.Contains("AmountVariance") Then 
            dgvMatching.Columns("AmountVariance").HeaderText = "Amount Variance"
            dgvMatching.Columns("AmountVariance").DefaultCellStyle.Format = "C2"
            dgvMatching.Columns("AmountVariance").DefaultCellStyle.BackColor = Color.LightPink
        End If
        If dgvMatching.Columns.Contains("Status") Then dgvMatching.Columns("Status").HeaderText = "Status"
        If dgvMatching.Columns.Contains("VarianceReason") Then 
            dgvMatching.Columns("VarianceReason").HeaderText = "Variance Reason"
            dgvMatching.Columns("VarianceReason").DefaultCellStyle.BackColor = Color.LightYellow
        End If
    End Sub

    Private Sub cboInvoice_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboInvoice.SelectedIndexChanged
        LoadInvoiceLines()
        matchingTable.Clear()
        UpdateVarianceSummary()
    End Sub

    Private Sub btnAutoMatch_Click(sender As Object, e As EventArgs) Handles btnAutoMatch.Click
        If cboInvoice.SelectedValue Is Nothing Then
            MessageBox.Show("Please select an invoice first.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        Try
            matchingTable.Clear()
            
            Dim grvData As DataTable = DirectCast(dgvGRVLines.DataSource, DataTable)
            Dim invoiceData As DataTable = DirectCast(dgvInvoiceLines.DataSource, DataTable)
            
            ' Auto-match by POLineID
            For Each grvRow As DataRow In grvData.Rows
                Dim poLineId As Integer = Convert.ToInt32(grvRow("POLineID"))
                
                ' Find matching invoice line
                Dim matchingInvoiceRows() As DataRow = invoiceData.Select($"POLineID = {poLineId}")
                
                If matchingInvoiceRows.Length > 0 Then
                    Dim invRow As DataRow = matchingInvoiceRows(0)
                    
                    Dim newRow As DataRow = matchingTable.NewRow()
                    newRow("GRVLineID") = grvRow("GRVLineID")
                    newRow("InvoiceLineID") = invRow("InvoiceLineID")
                    newRow("ItemName") = grvRow("ItemName")
                    newRow("GRVQuantity") = Convert.ToDecimal(grvRow("AcceptedQuantity"))
                    newRow("InvoiceQuantity") = Convert.ToDecimal(invRow("Quantity"))
                    newRow("MatchedQuantity") = Math.Min(Convert.ToDecimal(grvRow("AcceptedQuantity")), Convert.ToDecimal(invRow("Quantity")))
                    newRow("GRVAmount") = Convert.ToDecimal(grvRow("LineTotal"))
                    newRow("InvoiceAmount") = Convert.ToDecimal(invRow("LineTotal"))
                    newRow("MatchedAmount") = Convert.ToDecimal(newRow("MatchedQuantity")) * Convert.ToDecimal(invRow("UnitPrice"))
                    
                    ' Determine status
                    Dim qtyVariance As Decimal = Convert.ToDecimal(newRow("QuantityVariance"))
                    Dim amtVariance As Decimal = Convert.ToDecimal(newRow("AmountVariance"))
                    
                    If Math.Abs(qtyVariance) > 0.01 OrElse Math.Abs(amtVariance) > 0.01 Then
                        newRow("Status") = "Variance"
                        newRow("VarianceReason") = "Quantity or amount difference detected"
                    Else
                        newRow("Status") = "Matched"
                        newRow("VarianceReason") = ""
                    End If
                    
                    matchingTable.Rows.Add(newRow)
                End If
            Next
            
            UpdateVarianceSummary()
            btnSaveMatching.Enabled = matchingTable.Rows.Count > 0
            
            MessageBox.Show($"Auto-matching completed. {matchingTable.Rows.Count} items matched.", "Auto Match", MessageBoxButtons.OK, MessageBoxIcon.Information)
            
        Catch ex As Exception
            MessageBox.Show($"Error during auto-matching: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnManualMatch_Click(sender As Object, e As EventArgs) Handles btnManualMatch.Click
        If dgvGRVLines.CurrentRow Is Nothing OrElse dgvInvoiceLines.CurrentRow Is Nothing Then
            MessageBox.Show("Please select both a GRV line and an Invoice line to match.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        Try
            Dim grvRow As DataGridViewRow = dgvGRVLines.CurrentRow
            Dim invRow As DataGridViewRow = dgvInvoiceLines.CurrentRow
            
            ' Check if already matched
            Dim grvLineId As Integer = Convert.ToInt32(grvRow.Cells("GRVLineID").Value)
            Dim invLineId As Integer = Convert.ToInt32(invRow.Cells("InvoiceLineID").Value)
            
            For Each row As DataRow In matchingTable.Rows
                If Convert.ToInt32(row("GRVLineID")) = grvLineId OrElse Convert.ToInt32(row("InvoiceLineID")) = invLineId Then
                    MessageBox.Show("One or both of these lines are already matched.", "Already Matched", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
            Next
            
            Dim newRow As DataRow = matchingTable.NewRow()
            newRow("GRVLineID") = grvLineId
            newRow("InvoiceLineID") = invLineId
            newRow("ItemName") = grvRow.Cells("ItemName").Value
            newRow("GRVQuantity") = Convert.ToDecimal(grvRow.Cells("AcceptedQuantity").Value)
            newRow("InvoiceQuantity") = Convert.ToDecimal(invRow.Cells("Quantity").Value)
            newRow("MatchedQuantity") = Math.Min(Convert.ToDecimal(grvRow.Cells("AcceptedQuantity").Value), Convert.ToDecimal(invRow.Cells("Quantity").Value))
            newRow("GRVAmount") = Convert.ToDecimal(grvRow.Cells("LineTotal").Value)
            newRow("InvoiceAmount") = Convert.ToDecimal(invRow.Cells("LineTotal").Value)
            newRow("MatchedAmount") = Convert.ToDecimal(newRow("MatchedQuantity")) * Convert.ToDecimal(invRow.Cells("UnitPrice").Value)
            
            ' Determine status
            Dim qtyVariance As Decimal = Convert.ToDecimal(newRow("QuantityVariance"))
            Dim amtVariance As Decimal = Convert.ToDecimal(newRow("AmountVariance"))
            
            If Math.Abs(qtyVariance) > 0.01 OrElse Math.Abs(amtVariance) > 0.01 Then
                newRow("Status") = "Variance"
                newRow("VarianceReason") = "Manual match with variance"
            Else
                newRow("Status") = "Matched"
                newRow("VarianceReason") = ""
            End If
            
            matchingTable.Rows.Add(newRow)
            UpdateVarianceSummary()
            btnSaveMatching.Enabled = True
            
        Catch ex As Exception
            MessageBox.Show($"Error creating manual match: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub UpdateVarianceSummary()
        Dim totalVariance As Decimal = 0
        Dim varianceCount As Integer = 0
        
        For Each row As DataRow In matchingTable.Rows
            Dim amtVariance As Decimal = Convert.ToDecimal(row("AmountVariance"))
            If Math.Abs(amtVariance) > 0.01 Then
                totalVariance += Math.Abs(amtVariance)
                varianceCount += 1
            End If
        Next
        
        If varianceCount > 0 Then
            lblVarianceSummary.Text = $"Variances: {varianceCount} items, Total: {totalVariance:C2}"
            lblVarianceSummary.ForeColor = Color.Red
        Else
            lblVarianceSummary.Text = "No variances detected"
            lblVarianceSummary.ForeColor = Color.Green
        End If
    End Sub

    Private Sub btnSaveMatching_Click(sender As Object, e As EventArgs) Handles btnSaveMatching.Click
        If matchingTable.Rows.Count = 0 Then
            MessageBox.Show("No matching data to save.", "No Data", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        Try
            Dim invoiceId As Integer = Convert.ToInt32(cboInvoice.SelectedValue)
            grvService.MatchGRVToInvoice(grvId, invoiceId, AppSession.CurrentUserID)
            
            MessageBox.Show("GRV to Invoice matching saved successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Me.DialogResult = DialogResult.OK
            Me.Close()
            
        Catch ex As Exception
            MessageBox.Show($"Error saving matching: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvMatching_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs) Handles dgvMatching.CellValueChanged
        If e.RowIndex >= 0 AndAlso e.ColumnIndex >= 0 Then
            If dgvMatching.Columns(e.ColumnIndex).Name = "MatchedQuantity" OrElse dgvMatching.Columns(e.ColumnIndex).Name = "MatchedAmount" Then
                UpdateVarianceSummary()
            End If
        End If
    End Sub
End Class
