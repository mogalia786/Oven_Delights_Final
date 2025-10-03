Imports System.Data
Imports System.Windows.Forms
Imports System.Configuration
Imports System.Data.SqlClient

Public Class GRVManagementForm
    Inherits Form
    Private ReadOnly grvService As New GRVService()
    Private ReadOnly stockroomService As New StockroomService()
    Private currentBranchId As Integer
    Private isSuperAdmin As Boolean
    
    ' Controls are declared in Designer file
    Private WithEvents dgvGRVLines As New DataGridView()
    
    Private currentGRVId As Integer = 0

    Public Sub New()
        ' Initialize branch and role info
        currentBranchId = stockroomService.GetCurrentUserBranchId()
        isSuperAdmin = stockroomService.IsCurrentUserSuperAdmin()
        
        InitializeComponent()
        LoadBranches()
        LoadGRVs()
    End Sub

    ' InitializeComponent is in Designer file

    Private Sub LoadGRVs()
        Try
            Dim dt As DataTable = GetGRVList()
            dgvGRVs.DataSource = dt
            
            ' Format columns
            If dgvGRVs.Columns.Contains("GRVID") Then dgvGRVs.Columns("GRVID").Visible = False
            If dgvGRVs.Columns.Contains("GRVNumber") Then dgvGRVs.Columns("GRVNumber").HeaderText = "GRV Number"
            If dgvGRVs.Columns.Contains("SupplierName") Then dgvGRVs.Columns("SupplierName").HeaderText = "Supplier"
            If dgvGRVs.Columns.Contains("ReceivedDate") Then 
                dgvGRVs.Columns("ReceivedDate").HeaderText = "Received Date"
                dgvGRVs.Columns("ReceivedDate").DefaultCellStyle.Format = "dd/MM/yyyy"
            End If
            If dgvGRVs.Columns.Contains("TotalAmount") Then 
                dgvGRVs.Columns("TotalAmount").HeaderText = "Total Amount"
                dgvGRVs.Columns("TotalAmount").DefaultCellStyle.Format = "C2"
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error loading GRVs: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function GetGRVList() As DataTable
        Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            Dim sql As String
            If isSuperAdmin Then
                sql = "SELECT grv.GRNID AS GRVID, grv.GRNNumber AS GRVNumber, grv.ReceivedDate, grv.Status, ISNULL(grv.TotalAmount, 0) AS TotalAmount,
                       s.CompanyName AS SupplierName, po.PONumber, grv.DeliveryNoteNumber,
                       b.BranchName
                       FROM GoodsReceivedNotes grv
                       LEFT JOIN Suppliers s ON grv.SupplierID = s.SupplierID
                       LEFT JOIN PurchaseOrders po ON grv.PurchaseOrderID = po.PurchaseOrderID
                       LEFT JOIN Branches b ON grv.BranchID = b.BranchID
                       WHERE (@status = 'All' OR grv.Status = @status)
                       AND (@branchId IS NULL OR grv.BranchID = @branchId)
                       ORDER BY grv.ReceivedDate DESC"
            Else
                sql = "SELECT grv.GRNID AS GRVID, grv.GRNNumber AS GRVNumber, grv.ReceivedDate, grv.Status, ISNULL(grv.TotalAmount, 0) AS TotalAmount,
                       s.CompanyName AS SupplierName, po.PONumber, grv.DeliveryNoteNumber
                       FROM GoodsReceivedNotes grv
                       LEFT JOIN Suppliers s ON grv.SupplierID = s.SupplierID
                       LEFT JOIN PurchaseOrders po ON grv.PurchaseOrderID = po.PurchaseOrderID
                       WHERE (@status = 'All' OR grv.Status = @status)
                       AND grv.BranchID = @branchId
                       ORDER BY grv.ReceivedDate DESC"
            End If

            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@status", cboStatus.Text)
                If isSuperAdmin Then
                    cmd.Parameters.AddWithValue("@branchId", If(cboBranch.SelectedValue Is Nothing OrElse cboBranch.SelectedValue Is DBNull.Value, CType(DBNull.Value, Object), cboBranch.SelectedValue))
                Else
                    cmd.Parameters.AddWithValue("@branchId", currentBranchId)
                End If
                
                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    Return dt
                End Using
            End Using
        End Using
    End Function
    
    Private Sub LoadBranches()
        Try
            Dim branches = stockroomService.GetBranchesLookup()
            If branches IsNot Nothing AndAlso branches.Rows.Count > 0 Then
                ' Add "All Branches" option for Super Admin
                If isSuperAdmin Then
                    Dim allRow = branches.NewRow()
                    allRow("BranchID") = DBNull.Value
                    allRow("BranchName") = "All Branches"
                    branches.Rows.InsertAt(allRow, 0)
                End If
                
                cboBranch.DataSource = branches
                cboBranch.DisplayMember = "BranchName"
                cboBranch.ValueMember = "BranchID"
                
                ' Set default selection
                If Not isSuperAdmin Then
                    cboBranch.SelectedValue = currentBranchId
                End If
                
                AddHandler cboBranch.SelectedIndexChanged, AddressOf cboBranch_SelectedIndexChanged
            End If
        Catch ex As Exception
            ' Ignore branch loading errors
        End Try
    End Sub
    
    Private Sub cboBranch_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadGRVs()
    End Sub

    Private Sub LoadGRVLines()
        If currentGRVId = 0 Then
            dgvGRVLines.DataSource = Nothing
            Return
        End If

        Try
            Dim dt As DataTable = grvService.GetGRVLines(currentGRVId)
            dgvGRVLines.DataSource = dt

            ' Format columns
            If dgvGRVLines.Columns.Contains("GRVLineID") Then dgvGRVLines.Columns("GRVLineID").Visible = False
            If dgvGRVLines.Columns.Contains("ItemName") Then dgvGRVLines.Columns("ItemName").HeaderText = "Item"
            If dgvGRVLines.Columns.Contains("OrderedQuantity") Then dgvGRVLines.Columns("OrderedQuantity").HeaderText = "Ordered"
            If dgvGRVLines.Columns.Contains("ReceivedQuantity") Then dgvGRVLines.Columns("ReceivedQuantity").HeaderText = "Received"
            If dgvGRVLines.Columns.Contains("AcceptedQuantity") Then dgvGRVLines.Columns("AcceptedQuantity").HeaderText = "Accepted"
            If dgvGRVLines.Columns.Contains("QualityStatus") Then dgvGRVLines.Columns("QualityStatus").HeaderText = "Quality"

        Catch ex As Exception
            MessageBox.Show($"Error loading GRV lines: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub dgvGRVs_SelectionChanged(sender As Object, e As EventArgs) Handles dgvGRVs.SelectionChanged
        If dgvGRVs.CurrentRow IsNot Nothing AndAlso dgvGRVs.CurrentRow.Cells("GRVID").Value IsNot Nothing Then
            currentGRVId = Convert.ToInt32(dgvGRVs.CurrentRow.Cells("GRVID").Value)
            LoadGRVLines()
            UpdateButtonStates()
        End If
    End Sub

    Private Sub cboStatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboStatus.SelectedIndexChanged
        LoadGRVs()
    End Sub

    Private Sub btnCreateGRV_Click(sender As Object, e As EventArgs) Handles btnCreateGRV.Click
        Using frm As New GRVCreateForm()
            If frm.ShowDialog() = DialogResult.OK Then
                LoadGRVs()
            End If
        End Using
    End Sub

    Private Sub btnReceiveItems_Click(sender As Object, e As EventArgs) Handles btnReceiveItems.Click
        If currentGRVId = 0 Then Return

        Using frm As New GRVReceiveItemsForm(currentGRVId)
            If frm.ShowDialog() = DialogResult.OK Then
                LoadGRVLines()
            End If
        End Using
    End Sub

    Private Sub btnCompleteGRV_Click(sender As Object, e As EventArgs) Handles btnCompleteGRV.Click
        If currentGRVId = 0 Then Return

        If MessageBox.Show("Complete this GRV? This will update stock levels and mark the GRV as received.",
                          "Complete GRV", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
            Try
                grvService.CompleteGRV(currentGRVId, AppSession.CurrentUserID)
                MessageBox.Show("GRV completed successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                LoadGRVs()
                LoadGRVLines()
            Catch ex As Exception
                MessageBox.Show($"Error completing GRV: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

    Private Sub btnMatchInvoice_Click(sender As Object, e As EventArgs) Handles btnMatchInvoice.Click
        If currentGRVId = 0 Then Return

        Using frm As New GRVInvoiceMatchForm(currentGRVId)
            If frm.ShowDialog() = DialogResult.OK Then
                LoadGRVs()
            End If
        End Using
    End Sub

    Private Sub btnCreateCreditNote_Click(sender As Object, e As EventArgs) Handles btnCreateCreditNote.Click
        If currentGRVId = 0 Then Return

        Using frm As New CreditNoteCreateForm(currentGRVId)
            If frm.ShowDialog() = DialogResult.OK Then
                MessageBox.Show("Credit note created successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        End Using
    End Sub

    Private Sub UpdateButtonStates()
        Dim hasSelection As Boolean = currentGRVId > 0
        Dim status As String = ""

        If hasSelection AndAlso dgvGRVs.CurrentRow IsNot Nothing Then
            status = Convert.ToString(dgvGRVs.CurrentRow.Cells("Status").Value)
        End If

        btnReceiveItems.Enabled = hasSelection AndAlso status = "Draft"
        btnCompleteGRV.Enabled = hasSelection AndAlso status = "Draft"
        btnMatchInvoice.Enabled = hasSelection AndAlso status = "Received"
        btnCreateCreditNote.Enabled = hasSelection AndAlso (status = "Received" OrElse status = "Matched")

        ' Add View/Print Credit Notes button if credit notes exist
        If hasSelection Then
            CheckAndAddCreditNoteButtons()
        End If
    End Sub

    Private Sub CheckAndAddCreditNoteButtons()
        Try
            Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                Dim sql As String = "SELECT COUNT(*) FROM CreditNotes WHERE GRVID = @grvId"
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@grvId", currentGRVId)
                    con.Open()
                    Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    btnViewCreditNotes.Visible = count > 0
                End Using
            End Using
        Catch
            btnViewCreditNotes.Visible = False
        End Try
    End Sub

    Private Sub btnViewCreditNotes_Click(sender As Object, e As EventArgs) Handles btnViewCreditNotes.Click
        If currentGRVId = 0 Then Return
        
        Using frm As New CreditNoteListForm(currentGRVId)
            frm.ShowDialog()
        End Using
    End Sub
End Class
