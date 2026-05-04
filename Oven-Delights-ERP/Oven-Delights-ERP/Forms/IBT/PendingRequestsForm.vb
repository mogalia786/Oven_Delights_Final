Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Drawing

Namespace Forms.IBT

    ''' <summary>
    ''' Form for viewing and approving/rejecting Internal Purchase Orders
    ''' Branch B views requests from Branch A
    ''' </summary>
    Public Class PendingRequestsForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private _currentBranchId As Integer
        Private _currentUserId As Integer

        ' UI Controls
        Private dgvRequests As DataGridView
        Private cboStatusFilter As ComboBox
        Private btnRefresh As Button
        Private btnApprove As Button
        Private btnReject As Button
        Private btnCreateDelivery As Button
        Private btnClose As Button

        ' Colors
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(41, 128, 185)
        Private ReadOnly ColorSuccess As Color = Color.FromArgb(39, 174, 96)
        Private ReadOnly ColorDanger As Color = Color.FromArgb(231, 76, 60)
        Private ReadOnly ColorWarning As Color = Color.FromArgb(243, 156, 18)
        Private ReadOnly ColorDark As Color = Color.FromArgb(52, 73, 94)
        Private ReadOnly ColorLight As Color = Color.FromArgb(236, 240, 241)

        Public Sub New()
            _currentBranchId = If(AppSession.CurrentUser?.BranchID, 1)
            _currentUserId = If(AppSession.CurrentUser?.UserID, 1)

            Me.Text = "Pending Internal Purchase Requests"
            Me.Width = 1400
            Me.Height = 800
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            InitializeUI()
            LoadRequests()
        End Sub

        Private Sub InitializeUI()
            ' Header Panel
            Dim pnlHeader As New Panel With {
                .Dock = DockStyle.Top,
                .Height = 100,
                .BackColor = ColorDark
            }

            Dim lblTitle As New Label With {
                .Text = "📥 Pending Purchase Requests",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(30, 20)
            }

            Dim lblSubtitle As New Label With {
                .Text = "Approve or reject requests from other branches",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorLight,
                .AutoSize = True,
                .Location = New Point(30, 55)
            }

            pnlHeader.Controls.AddRange({lblTitle, lblSubtitle})

            ' Filter Panel
            Dim pnlFilter As New Panel With {
                .Location = New Point(30, 120),
                .Size = New Size(1340, 60),
                .BackColor = ColorLight
            }

            Dim lblStatus As New Label With {
                .Text = "Status:",
                .Location = New Point(15, 18),
                .AutoSize = True,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold)
            }

            cboStatusFilter = New ComboBox With {
                .Location = New Point(80, 15),
                .Width = 200,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10)
            }
            cboStatusFilter.Items.AddRange({"All", "Pending", "Approved", "Rejected", "Fulfilled"})
            cboStatusFilter.SelectedIndex = 1 ' Default to Pending
            AddHandler cboStatusFilter.SelectedIndexChanged, AddressOf OnFilterChanged

            btnRefresh = New Button With {
                .Text = "🔄 Refresh",
                .Location = New Point(300, 10),
                .Size = New Size(120, 40),
                .BackColor = ColorPrimary,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnRefresh.FlatAppearance.BorderSize = 0
            AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click

            pnlFilter.Controls.AddRange({lblStatus, cboStatusFilter, btnRefresh})

            ' Grid
            dgvRequests = New DataGridView With {
                .Location = New Point(30, 200),
                .Size = New Size(1340, 480),
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.FixedSingle,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .RowHeadersVisible = False,
                .Font = New Font("Segoe UI", 10),
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            }

            dgvRequests.ColumnHeadersDefaultCellStyle.BackColor = ColorDark
            dgvRequests.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
            dgvRequests.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
            dgvRequests.ColumnHeadersHeight = 40
            dgvRequests.AlternatingRowsDefaultCellStyle.BackColor = ColorLight
            dgvRequests.RowTemplate.Height = 35

            ' Footer Panel
            Dim pnlFooter As New Panel With {
                .Dock = DockStyle.Bottom,
                .Height = 80,
                .BackColor = ColorLight
            }

            btnApprove = New Button With {
                .Text = "✅ Approve",
                .Location = New Point(700, 20),
                .Size = New Size(140, 40),
                .BackColor = ColorSuccess,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnApprove.FlatAppearance.BorderSize = 0
            AddHandler btnApprove.Click, AddressOf BtnApprove_Click

            btnReject = New Button With {
                .Text = "❌ Reject",
                .Location = New Point(850, 20),
                .Size = New Size(140, 40),
                .BackColor = ColorDanger,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnReject.FlatAppearance.BorderSize = 0
            AddHandler btnReject.Click, AddressOf BtnReject_Click

            btnCreateDelivery = New Button With {
                .Text = "📦 Create Delivery",
                .Location = New Point(1000, 20),
                .Size = New Size(180, 40),
                .BackColor = ColorWarning,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnCreateDelivery.FlatAppearance.BorderSize = 0
            AddHandler btnCreateDelivery.Click, AddressOf BtnCreateDelivery_Click

            btnClose = New Button With {
                .Text = "Close",
                .Location = New Point(1190, 20),
                .Size = New Size(140, 40),
                .BackColor = Color.Gray,
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .Cursor = Cursors.Hand
            }
            btnClose.FlatAppearance.BorderSize = 0
            AddHandler btnClose.Click, Sub() Me.Close()

            pnlFooter.Controls.AddRange({btnApprove, btnReject, btnCreateDelivery, btnClose})

            Me.Controls.AddRange({pnlHeader, pnlFilter, dgvRequests, pnlFooter})
        End Sub

        Private Sub LoadRequests()
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()

                    Dim statusFilter As String = If(cboStatusFilter.SelectedItem?.ToString(), "Pending")
                    Dim whereClause As String = If(statusFilter = "All", "", " AND po.Status = @Status")

                    Dim sql = $"SELECT po.InternalPOID, po.PONumber, po.RequestedDate, 
                                      rb.BranchName AS RequestingBranch, 
                                      p.Name AS ProductName, po.Quantity, 
                                      po.RequiredByDate, po.Status, po.Notes,
                                      ISNULL(u.Username, 'System') AS RequestedBy
                               FROM InternalPurchaseOrders po
                               INNER JOIN Branches rb ON po.RequestingBranchID = rb.BranchID
                               INNER JOIN Demo_Retail_Product p ON po.ProductID = p.ProductID
                               LEFT JOIN Users u ON po.CreatedBy = u.UserID
                               WHERE po.SupplyingBranchID = @BranchID{whereClause}
                               ORDER BY po.RequestedDate DESC, po.InternalPOID DESC"

                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@BranchID", _currentBranchId)
                        If statusFilter <> "All" Then
                            cmd.Parameters.AddWithValue("@Status", statusFilter)
                        End If

                        Dim dt As New DataTable()
                        Using adapter As New SqlDataAdapter(cmd)
                            adapter.Fill(dt)
                        End Using

                        dgvRequests.DataSource = dt

                        If dgvRequests.Columns.Count > 0 Then
                            dgvRequests.Columns("InternalPOID").Visible = False
                            dgvRequests.Columns("PONumber").HeaderText = "PO Number"
                            dgvRequests.Columns("RequestedDate").HeaderText = "Requested Date"
                            dgvRequests.Columns("RequestedDate").DefaultCellStyle.Format = "dd/MM/yyyy HH:mm"
                            dgvRequests.Columns("RequestingBranch").HeaderText = "From Branch"
                            dgvRequests.Columns("ProductName").HeaderText = "Product"
                            dgvRequests.Columns("Quantity").HeaderText = "Qty"
                            dgvRequests.Columns("Quantity").DefaultCellStyle.Format = "N2"
                            dgvRequests.Columns("Quantity").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                            dgvRequests.Columns("RequiredByDate").HeaderText = "Required By"
                            dgvRequests.Columns("RequiredByDate").DefaultCellStyle.Format = "dd/MM/yyyy"
                            dgvRequests.Columns("Status").HeaderText = "Status"
                            dgvRequests.Columns("Notes").HeaderText = "Notes"
                            dgvRequests.Columns("RequestedBy").HeaderText = "Requested By"

                            ' Color code status
                            For Each row As DataGridViewRow In dgvRequests.Rows
                                Dim status As String = row.Cells("Status").Value?.ToString()
                                Select Case status
                                    Case "Pending"
                                        row.Cells("Status").Style.BackColor = Color.LightYellow
                                        row.Cells("Status").Style.ForeColor = Color.DarkOrange
                                    Case "Approved"
                                        row.Cells("Status").Style.BackColor = Color.LightGreen
                                        row.Cells("Status").Style.ForeColor = Color.DarkGreen
                                    Case "Rejected"
                                        row.Cells("Status").Style.BackColor = Color.LightCoral
                                        row.Cells("Status").Style.ForeColor = Color.DarkRed
                                    Case "Fulfilled"
                                        row.Cells("Status").Style.BackColor = Color.LightBlue
                                        row.Cells("Status").Style.ForeColor = Color.DarkBlue
                                End Select
                            Next
                        End If
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading requests: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnFilterChanged(sender As Object, e As EventArgs)
            LoadRequests()
        End Sub

        Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
            LoadRequests()
        End Sub

        Private Sub BtnApprove_Click(sender As Object, e As EventArgs)
            If dgvRequests.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a request to approve.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim status As String = dgvRequests.SelectedRows(0).Cells("Status").Value?.ToString()
            If status <> "Pending" Then
                MessageBox.Show("Only pending requests can be approved.", "Invalid Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim poId As Integer = Convert.ToInt32(dgvRequests.SelectedRows(0).Cells("InternalPOID").Value)
            Dim poNumber As String = dgvRequests.SelectedRows(0).Cells("PONumber").Value?.ToString()

            If MessageBox.Show($"Approve request {poNumber}?", "Confirm Approval", MessageBoxButtons.YesNo, MessageBoxIcon.Question) <> DialogResult.Yes Then
                Return
            End If

            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql = "UPDATE InternalPurchaseOrders SET Status = 'Approved', ApprovedBy = @UserID, ApprovedDate = GETDATE() WHERE InternalPOID = @POID"
                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@POID", poId)
                        cmd.Parameters.AddWithValue("@UserID", _currentUserId)
                        cmd.ExecuteNonQuery()
                    End Using
                End Using

                MessageBox.Show($"Request {poNumber} approved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                LoadRequests()

            Catch ex As Exception
                MessageBox.Show($"Error approving request: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub BtnReject_Click(sender As Object, e As EventArgs)
            If dgvRequests.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a request to reject.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim status As String = dgvRequests.SelectedRows(0).Cells("Status").Value?.ToString()
            If status <> "Pending" Then
                MessageBox.Show("Only pending requests can be rejected.", "Invalid Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim poId As Integer = Convert.ToInt32(dgvRequests.SelectedRows(0).Cells("InternalPOID").Value)
            Dim poNumber As String = dgvRequests.SelectedRows(0).Cells("PONumber").Value?.ToString()

            Dim reason As String = InputBox("Enter rejection reason:", "Reject Request", "")
            If String.IsNullOrWhiteSpace(reason) Then
                MessageBox.Show("Rejection reason is required.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql = "UPDATE InternalPurchaseOrders SET Status = 'Rejected', RejectionReason = @Reason, ApprovedBy = @UserID, ApprovedDate = GETDATE() WHERE InternalPOID = @POID"
                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@POID", poId)
                        cmd.Parameters.AddWithValue("@Reason", reason)
                        cmd.Parameters.AddWithValue("@UserID", _currentUserId)
                        cmd.ExecuteNonQuery()
                    End Using
                End Using

                MessageBox.Show($"Request {poNumber} rejected.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                LoadRequests()

            Catch ex As Exception
                MessageBox.Show($"Error rejecting request: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub BtnCreateDelivery_Click(sender As Object, e As EventArgs)
            If dgvRequests.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select an approved request to create delivery.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            Dim status As String = dgvRequests.SelectedRows(0).Cells("Status").Value?.ToString()
            If status <> "Approved" Then
                MessageBox.Show("Only approved requests can be converted to deliveries.", "Invalid Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim poId As Integer = Convert.ToInt32(dgvRequests.SelectedRows(0).Cells("InternalPOID").Value)
            
            ' Open delivery form
            Dim deliveryForm As New CreateDeliveryNoteForm(poId)
            If deliveryForm.ShowDialog(Me) = DialogResult.OK Then
                LoadRequests()
            End If
        End Sub
    End Class
End Namespace
