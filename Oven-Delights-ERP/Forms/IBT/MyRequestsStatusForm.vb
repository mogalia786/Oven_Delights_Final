Imports System.Data
Imports Microsoft.Data.SqlClient

Public Class MyRequestsStatusForm
    Private _connectionString As String
    Private _currentBranchId As Integer
    Private _currentUserId As Integer

    Private Sub MyRequestsStatusForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "My Requests Status - Track All Requests I Made"
        _connectionString = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _currentBranchId = AppSession.CurrentUser.BranchID
        _currentUserId = AppSession.CurrentUser.UserID

        SetupGrid()
        LoadMyRequests()
    End Sub

    Private Sub SetupGrid()
        dgvRequests.AutoGenerateColumns = False
        dgvRequests.Columns.Clear()

        dgvRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "PONumber", .HeaderText = "PO Number", .DataPropertyName = "PONumber", .Width = 150})
        dgvRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "RequestedDate", .HeaderText = "Request Date", .DataPropertyName = "RequestedDate", .Width = 120})
        dgvRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "SupplyingBranch", .HeaderText = "Requested From", .DataPropertyName = "SupplyingBranch", .Width = 150})
        dgvRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductName", .HeaderText = "Product", .DataPropertyName = "ProductName", .Width = 200})
        dgvRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Quantity", .HeaderText = "Qty", .DataPropertyName = "Quantity", .Width = 80})
        dgvRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Status", .HeaderText = "Status", .DataPropertyName = "Status", .Width = 120})
        dgvRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ApprovedDate", .HeaderText = "Approved Date", .DataPropertyName = "ApprovedDate", .Width = 120})
        dgvRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "DispatchDate", .HeaderText = "Dispatch Date", .DataPropertyName = "DispatchDate", .Width = 120})
        dgvRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ReceiveDate", .HeaderText = "Received Date", .DataPropertyName = "ReceiveDate", .Width = 120})
        dgvRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "RejectionReason", .HeaderText = "Rejection Reason", .DataPropertyName = "RejectionReason", .Width = 200})
        dgvRequests.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "DeliveryNoteNumber", .HeaderText = "Delivery Note", .DataPropertyName = "DeliveryNoteNumber", .Width = 150})

        dgvRequests.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None
        dgvRequests.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvRequests.MultiSelect = False
        dgvRequests.ReadOnly = True
        dgvRequests.AllowUserToAddRows = False
    End Sub

    Private Sub LoadMyRequests()
        Try
            Using con As New SqlConnection(_connectionString)
                con.Open()
                Dim sql = "SELECT 
                            po.PONumber,
                            po.RequestedDate,
                            sb.BranchName AS SupplyingBranch,
                            p.Name AS ProductName,
                            po.Quantity,
                            po.Status,
                            po.ApprovedDate,
                            dn.DispatchDate,
                            dn.ReceiveDate,
                            po.RejectionReason,
                            dn.DeliveryNoteNumber
                          FROM InternalPurchaseOrders po
                          INNER JOIN Branches sb ON po.SupplyingBranchID = sb.BranchID
                          INNER JOIN Demo_Retail_Product p ON po.ProductID = p.ProductID
                          LEFT JOIN InternalDeliveryNotes dn ON po.InternalPOID = dn.InternalPOID
                          WHERE po.RequestingBranchID = @BranchID
                          ORDER BY po.RequestedDate DESC"

                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@BranchID", _currentBranchId)
                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        dgvRequests.DataSource = dt

                        ' Color code by status
                        For Each row As DataGridViewRow In dgvRequests.Rows
                            Dim status As String = If(row.Cells("Status").Value IsNot Nothing, row.Cells("Status").Value.ToString(), "")
                            Select Case status
                                Case "Pending"
                                    row.DefaultCellStyle.BackColor = Color.LightYellow
                                Case "Approved"
                                    row.DefaultCellStyle.BackColor = Color.LightGreen
                                Case "Rejected"
                                    row.DefaultCellStyle.BackColor = Color.LightCoral
                                Case "Fulfilled"
                                    row.DefaultCellStyle.BackColor = Color.LightBlue
                            End Select
                        Next

                        lblTotal.Text = $"Total Requests: {dt.Rows.Count}"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading requests: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadMyRequests()
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
