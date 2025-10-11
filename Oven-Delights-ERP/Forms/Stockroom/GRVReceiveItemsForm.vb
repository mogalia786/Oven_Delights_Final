Imports System.Data
Imports System.Windows.Forms
Imports System.Configuration
Imports System.Data.SqlClient

Public Class GRVReceiveItemsForm
    Inherits Form
    Private ReadOnly grvService As New GRVService()
    Private ReadOnly stockroomService As New StockroomService()
    Private ReadOnly grvId As Integer
    Private currentBranchId As Integer
    
    ' Controls are declared in Designer file
    Private lblGRVInfo As New Label()

    Public Sub New(grvId As Integer)
        Me.grvId = grvId
        currentBranchId = stockroomService.GetCurrentUserBranchId()
        InitializeComponent()
        LoadGRVData()
    End Sub

    ' InitializeComponent is in Designer file

    Private Sub LoadGRVData()
        Try
            ' Load GRV header info
            Dim grvDetails As DataTable = grvService.GetGRVDetails(grvId)
            If grvDetails.Rows.Count > 0 Then
                Dim row As DataRow = grvDetails.Rows(0)
                lblGRVInfo.Text = $"GRV: {row("GRVNumber")} | Supplier: {row("SupplierName")} | Date: {Convert.ToDateTime(row("ReceivedDate")):dd/MM/yyyy}"
            End If
            
            ' Load GRV lines
            Dim dt As DataTable = grvService.GetGRVLines(grvId)
            
            ' Add editable columns for receiving
            If Not dt.Columns.Contains("NewReceivedQty") Then
                dt.Columns.Add("NewReceivedQty", GetType(Decimal))
                dt.Columns.Add("NewRejectedQty", GetType(Decimal))
                dt.Columns.Add("NewQualityStatus", GetType(String))
                dt.Columns.Add("NewQualityNotes", GetType(String))
            End If
            
            ' Initialize with current values
            For Each row As DataRow In dt.Rows
                row("NewReceivedQty") = row("ReceivedQuantity")
                row("NewRejectedQty") = row("RejectedQuantity")
                row("NewQualityStatus") = row("QualityStatus")
                row("NewQualityNotes") = If(IsDBNull(row("QualityNotes")), "", row("QualityNotes"))
            Next
            
            dgvItems.DataSource = dt
            FormatGrid()
            
        Catch ex As Exception
            MessageBox.Show($"Error loading GRV data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub FormatGrid()
        ' Hide system columns
        For Each col As String In {"GRVLineID", "GRVID", "POLineID", "MaterialID", "ProductID", 
                                  "CreatedDate", "CreatedBy", "QualityCheckedBy", "QualityCheckedDate"}
            If dgvItems.Columns.Contains(col) Then
                dgvItems.Columns(col).Visible = False
            End If
        Next
        
        ' Format display columns
        If dgvItems.Columns.Contains("ItemName") Then dgvItems.Columns("ItemName").HeaderText = "Item"
        If dgvItems.Columns.Contains("ItemCode") Then dgvItems.Columns("ItemCode").HeaderText = "Code"
        If dgvItems.Columns.Contains("OrderedQuantity") Then 
            dgvItems.Columns("OrderedQuantity").HeaderText = "Ordered"
            dgvItems.Columns("OrderedQuantity").ReadOnly = True
        End If
        If dgvItems.Columns.Contains("UnitCost") Then 
            dgvItems.Columns("UnitCost").HeaderText = "Unit Cost"
            dgvItems.Columns("UnitCost").DefaultCellStyle.Format = "C2"
            dgvItems.Columns("UnitCost").ReadOnly = True
        End If
        
        ' Current values (read-only)
        If dgvItems.Columns.Contains("ReceivedQuantity") Then 
            dgvItems.Columns("ReceivedQuantity").HeaderText = "Current Received"
            dgvItems.Columns("ReceivedQuantity").ReadOnly = True
            dgvItems.Columns("ReceivedQuantity").DefaultCellStyle.BackColor = Color.LightGray
        End If
        If dgvItems.Columns.Contains("RejectedQuantity") Then 
            dgvItems.Columns("RejectedQuantity").HeaderText = "Current Rejected"
            dgvItems.Columns("RejectedQuantity").ReadOnly = True
            dgvItems.Columns("RejectedQuantity").DefaultCellStyle.BackColor = Color.LightGray
        End If
        If dgvItems.Columns.Contains("QualityStatus") Then 
            dgvItems.Columns("QualityStatus").HeaderText = "Current Quality"
            dgvItems.Columns("QualityStatus").ReadOnly = True
            dgvItems.Columns("QualityStatus").DefaultCellStyle.BackColor = Color.LightGray
        End If
        
        ' New editable columns
        If dgvItems.Columns.Contains("NewReceivedQty") Then 
            dgvItems.Columns("NewReceivedQty").HeaderText = "Received Qty"
            dgvItems.Columns("NewReceivedQty").DefaultCellStyle.BackColor = Color.LightYellow
        End If
        If dgvItems.Columns.Contains("NewRejectedQty") Then 
            dgvItems.Columns("NewRejectedQty").HeaderText = "Rejected Qty"
            dgvItems.Columns("NewRejectedQty").DefaultCellStyle.BackColor = Color.LightYellow
        End If
        
        ' Quality Status dropdown
        If dgvItems.Columns.Contains("NewQualityStatus") Then 
            dgvItems.Columns("NewQualityStatus").HeaderText = "Quality Status"
            dgvItems.Columns("NewQualityStatus").DefaultCellStyle.BackColor = Color.LightYellow
            
            Dim cboQuality As New DataGridViewComboBoxColumn()
            cboQuality.Name = "NewQualityStatus"
            cboQuality.HeaderText = "Quality Status"
            cboQuality.Items.AddRange({"Pending", "Passed", "Failed", "Partial"})
            cboQuality.DefaultCellStyle.BackColor = Color.LightYellow
            
            dgvItems.Columns.Remove("NewQualityStatus")
            dgvItems.Columns.Add(cboQuality)
        End If
        
        If dgvItems.Columns.Contains("NewQualityNotes") Then 
            dgvItems.Columns("NewQualityNotes").HeaderText = "Quality Notes"
            dgvItems.Columns("NewQualityNotes").DefaultCellStyle.BackColor = Color.LightYellow
        End If
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Try
            Dim dt As DataTable = DirectCast(dgvItems.DataSource, DataTable)
            Dim hasChanges As Boolean = False
            
            For Each row As DataRow In dt.Rows
                Dim grvLineId As Integer = Convert.ToInt32(row("GRVLineID"))
                Dim newReceived As Decimal = Convert.ToDecimal(row("NewReceivedQty"))
                Dim newRejected As Decimal = Convert.ToDecimal(row("NewRejectedQty"))
                Dim newQualityStatus As String = Convert.ToString(row("NewQualityStatus"))
                Dim newQualityNotes As String = Convert.ToString(row("NewQualityNotes"))
                
                ' Validation
                If newReceived < 0 Then
                    MessageBox.Show("Received quantity cannot be negative.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                
                If newRejected < 0 OrElse newRejected > newReceived Then
                    MessageBox.Show("Rejected quantity cannot be negative or greater than received quantity.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                
                ' Check if changed
                Dim currentReceived As Decimal = Convert.ToDecimal(row("ReceivedQuantity"))
                Dim currentRejected As Decimal = Convert.ToDecimal(row("RejectedQuantity"))
                Dim currentQuality As String = Convert.ToString(row("QualityStatus"))
                
                If newReceived <> currentReceived OrElse newRejected <> currentRejected OrElse newQualityStatus <> currentQuality Then
                    grvService.UpdateGRVLine(grvLineId, newReceived, newRejected, newQualityStatus, newQualityNotes, AppSession.CurrentUserID)
                    hasChanges = True
                End If
            Next
            
            If hasChanges Then
                MessageBox.Show("Items received successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Me.DialogResult = DialogResult.OK
                Me.Close()
            Else
                MessageBox.Show("No changes were made.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error saving received items: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvItems_CellValidating(sender As Object, e As DataGridViewCellValidatingEventArgs) Handles dgvItems.CellValidating
        If dgvItems.Columns(e.ColumnIndex).Name = "NewReceivedQty" OrElse dgvItems.Columns(e.ColumnIndex).Name = "NewRejectedQty" Then
            Dim value As Decimal
            If Not Decimal.TryParse(e.FormattedValue.ToString(), value) OrElse value < 0 Then
                e.Cancel = True
                MessageBox.Show("Please enter a valid positive number.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End If
        End If
    End Sub
End Class
