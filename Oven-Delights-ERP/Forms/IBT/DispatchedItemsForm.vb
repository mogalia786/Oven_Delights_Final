Imports System.Data
Imports Microsoft.Data.SqlClient

Public Class DispatchedItemsForm
    Private _connectionString As String
    Private _currentBranchId As Integer
    Private _currentUserId As Integer

    Private Sub DispatchedItemsForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "Dispatched Items - Products I Sent to Other Branches"
        _connectionString = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _currentBranchId = AppSession.CurrentUser.BranchID
        _currentUserId = AppSession.CurrentUser.UserID

        SetupGrid()
        LoadDispatchedItems()
    End Sub

    Private Sub SetupGrid()
        dgvDispatched.AutoGenerateColumns = False
        dgvDispatched.Columns.Clear()

        dgvDispatched.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "DeliveryNoteNumber", .HeaderText = "Delivery Note", .DataPropertyName = "DeliveryNoteNumber", .Width = 150})
        dgvDispatched.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "DispatchDate", .HeaderText = "Dispatch Date", .DataPropertyName = "DispatchDate", .Width = 120})
        dgvDispatched.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ToBranch", .HeaderText = "Sent To", .DataPropertyName = "ToBranch", .Width = 150})
        dgvDispatched.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductName", .HeaderText = "Product", .DataPropertyName = "ProductName", .Width = 200})
        dgvDispatched.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Quantity", .HeaderText = "Qty", .DataPropertyName = "Quantity", .Width = 80})
        dgvDispatched.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "UnitCost", .HeaderText = "Unit Cost", .DataPropertyName = "UnitCost", .Width = 100, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
        dgvDispatched.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalValue", .HeaderText = "Total Value", .DataPropertyName = "TotalValue", .Width = 120, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
        dgvDispatched.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Status", .HeaderText = "Status", .DataPropertyName = "Status", .Width = 120})
        dgvDispatched.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ReceiveDate", .HeaderText = "Received Date", .DataPropertyName = "ReceiveDate", .Width = 120})
        dgvDispatched.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "PONumber", .HeaderText = "PO Number", .DataPropertyName = "PONumber", .Width = 150})

        dgvDispatched.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None
        dgvDispatched.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvDispatched.MultiSelect = False
        dgvDispatched.ReadOnly = True
        dgvDispatched.AllowUserToAddRows = False
    End Sub

    Private Sub LoadDispatchedItems()
        Try
            Using con As New SqlConnection(_connectionString)
                con.Open()
                Dim sql = "SELECT 
                            dn.DeliveryNoteNumber,
                            dn.DispatchDate,
                            dn.ToBranchName AS ToBranch,
                            p.Name AS ProductName,
                            dn.Quantity,
                            dn.UnitCost,
                            dn.TotalValue,
                            dn.Status,
                            dn.ReceiveDate,
                            po.PONumber
                          FROM InternalDeliveryNotes dn
                          INNER JOIN InternalPurchaseOrders po ON dn.InternalPOID = po.InternalPOID
                          INNER JOIN Demo_Retail_Product p ON dn.ProductID = p.ProductID
                          WHERE dn.FromBranchID = @BranchID
                          ORDER BY dn.DispatchDate DESC"

                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@BranchID", _currentBranchId)
                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        dgvDispatched.DataSource = dt

                        ' Color code by status
                        For Each row As DataGridViewRow In dgvDispatched.Rows
                            Dim status As String = If(row.Cells("Status").Value IsNot Nothing, row.Cells("Status").Value.ToString(), "")
                            Select Case status
                                Case "In Transit"
                                    row.DefaultCellStyle.BackColor = Color.LightYellow
                                Case "Delivered"
                                    row.DefaultCellStyle.BackColor = Color.LightGreen
                            End Select
                        Next

                        lblTotal.Text = $"Total Dispatched: {dt.Rows.Count}"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading dispatched items: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadDispatchedItems()
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
