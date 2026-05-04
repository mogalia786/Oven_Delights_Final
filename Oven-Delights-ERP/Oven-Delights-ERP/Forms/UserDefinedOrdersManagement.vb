Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Text
Imports System.Windows.Forms

Public Class UserDefinedOrdersManagement
    Inherits Form

    Private _connectionString As String
    Private _currentBranchID As Integer
    Private _currentUserID As Integer

    ' UI Controls
    Private dgvOrders As DataGridView
    Private dtpFromDate As DateTimePicker
    Private dtpToDate As DateTimePicker
    Private cmbStatus As ComboBox
    Private cmbBranch As ComboBox
    Private btnRefresh As Button
    Private btnViewOrder As Button
    Private btnSetCompleted As Button
    Private btnClose As Button

    Public Sub New(currentBranchID As Integer, currentUserID As Integer)
        MyBase.New()
        _currentBranchID = currentBranchID
        _currentUserID = currentUserID
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        InitializeComponent()
        LoadBranches()
        LoadOrders()
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "User Defined Orders Management"
        Me.Size = New Size(1400, 800)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.White

        Dim yPos As Integer = 20

        ' Header
        Dim lblHeader As New Label With {
            .Text = "USER DEFINED ORDERS MANAGEMENT",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#E67E22"),
            .Location = New Point(20, yPos),
            .Size = New Size(1350, 40),
            .TextAlign = ContentAlignment.MiddleCenter
        }
        Me.Controls.Add(lblHeader)
        yPos += 60

        ' Filters panel
        Dim pnlFilters As New Panel With {
            .Location = New Point(20, yPos),
            .Size = New Size(1350, 60),
            .BorderStyle = BorderStyle.FixedSingle
        }

        ' From Date
        Dim lblFromDate As New Label With {
            .Text = "From Date:",
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .Location = New Point(10, 18),
            .Size = New Size(80, 25)
        }
        dtpFromDate = New DateTimePicker With {
            .Font = New Font("Segoe UI", 9),
            .Location = New Point(95, 15),
            .Size = New Size(150, 25),
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Today.AddDays(-30)
        }

        ' To Date
        Dim lblToDate As New Label With {
            .Text = "To Date:",
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .Location = New Point(260, 18),
            .Size = New Size(60, 25)
        }
        dtpToDate = New DateTimePicker With {
            .Font = New Font("Segoe UI", 9),
            .Location = New Point(325, 15),
            .Size = New Size(150, 25),
            .Format = DateTimePickerFormat.Short,
            .Value = DateTime.Today
        }

        ' Status filter
        Dim lblStatus As New Label With {
            .Text = "Status:",
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .Location = New Point(490, 18),
            .Size = New Size(50, 25)
        }
        cmbStatus = New ComboBox With {
            .Font = New Font("Segoe UI", 9),
            .Location = New Point(545, 15),
            .Size = New Size(150, 25),
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        cmbStatus.Items.AddRange(New String() {"All", "Created", "Completed", "PickedUp"})
        cmbStatus.SelectedIndex = 0

        ' Branch filter
        Dim lblBranch As New Label With {
            .Text = "Branch:",
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .Location = New Point(710, 18),
            .Size = New Size(60, 25)
        }
        cmbBranch = New ComboBox With {
            .Font = New Font("Segoe UI", 9),
            .Location = New Point(775, 15),
            .Size = New Size(200, 25),
            .DropDownStyle = ComboBoxStyle.DropDownList
        }

        ' Refresh button
        btnRefresh = New Button With {
            .Text = "Refresh",
            .Font = New Font("Segoe UI", 9, FontStyle.Bold),
            .Size = New Size(100, 30),
            .Location = New Point(990, 13),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnRefresh.FlatAppearance.BorderSize = 0
        AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click

        pnlFilters.Controls.AddRange({lblFromDate, dtpFromDate, lblToDate, dtpToDate, lblStatus, cmbStatus, lblBranch, cmbBranch, btnRefresh})
        Me.Controls.Add(pnlFilters)
        yPos += 70

        ' DataGridView
        dgvOrders = New DataGridView With {
            .Location = New Point(20, yPos),
            .Size = New Size(1350, 550),
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.Fixed3D
        }
        AddHandler dgvOrders.CellDoubleClick, AddressOf DgvOrders_CellDoubleClick
        Me.Controls.Add(dgvOrders)
        yPos += 560

        ' Action buttons
        btnViewOrder = New Button With {
            .Text = "View Order",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(150, 40),
            .Location = New Point(400, yPos),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnViewOrder.FlatAppearance.BorderSize = 0
        AddHandler btnViewOrder.Click, AddressOf BtnViewOrder_Click

        btnSetCompleted = New Button With {
            .Text = "Set Completed",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(150, 40),
            .Location = New Point(570, yPos),
            .BackColor = ColorTranslator.FromHtml("#27AE60"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnSetCompleted.FlatAppearance.BorderSize = 0
        AddHandler btnSetCompleted.Click, AddressOf BtnSetCompleted_Click

        btnClose = New Button With {
            .Text = "Close",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(150, 40),
            .Location = New Point(740, yPos),
            .BackColor = ColorTranslator.FromHtml("#E74C3C"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, AddressOf BtnClose_Click

        Me.Controls.AddRange({btnViewOrder, btnSetCompleted, btnClose})
    End Sub

    Private Sub LoadBranches()
        Try
            cmbBranch.Items.Clear()

            Using conn As New SqlConnection(_connectionString)
                conn.Open()

                ' Check if user is at Head Office (BranchID = 0)
                If _currentBranchID = 0 Then
                    ' Head Office - show all branches
                    cmbBranch.Items.Add("All Branches")

                    Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                    Using cmd As New SqlCommand(sql, conn)
                        Using reader = cmd.ExecuteReader()
                            While reader.Read()
                                cmbBranch.Items.Add(New With {
                                    .Text = reader("BranchName").ToString(),
                                    .Value = CInt(reader("BranchID"))
                                })
                            End While
                        End Using
                    End Using

                    cmbBranch.DisplayMember = "Text"
                    cmbBranch.ValueMember = "Value"
                    cmbBranch.SelectedIndex = 0
                Else
                    ' Specific branch - lock to current branch
                    Dim sql = "SELECT BranchName FROM Branches WHERE BranchID = @BranchID"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                        Dim branchName = cmd.ExecuteScalar()?.ToString()
                        If Not String.IsNullOrEmpty(branchName) Then
                            cmbBranch.Items.Add(New With {
                                .Text = branchName,
                                .Value = _currentBranchID
                            })
                            cmbBranch.DisplayMember = "Text"
                            cmbBranch.ValueMember = "Value"
                            cmbBranch.SelectedIndex = 0
                            cmbBranch.Enabled = False
                        End If
                    End Using
                End If
            End Using

        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadOrders()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()

                Dim sql As New StringBuilder()
                sql.AppendLine("SELECT ")
                sql.AppendLine("    UserDefinedOrderID,")
                sql.AppendLine("    OrderNumber AS [Order Number],")
                sql.AppendLine("    CONVERT(VARCHAR(10), OrderDate, 103) AS [Date Created],")
                sql.AppendLine("    CustomerName + ' ' + ISNULL(CustomerSurname, '') AS [Customer],")
                sql.AppendLine("    CustomerCellNumber AS [Phone],")
                sql.AppendLine("    CONVERT(VARCHAR(10), CollectionDate, 103) AS [Collection Date],")
                sql.AppendLine("    CONVERT(VARCHAR(5), CollectionTime, 108) AS [Collection Time],")
                sql.AppendLine("    Status,")
                sql.AppendLine("    'R ' + CAST(TotalAmount AS VARCHAR(20)) AS [Total Amount],")
                sql.AppendLine("    BranchName AS [Branch]")
                sql.AppendLine("FROM POS_UserDefinedOrders")
                sql.AppendLine("WHERE OrderDate BETWEEN @FromDate AND @ToDate")

                ' Status filter
                If cmbStatus.SelectedItem?.ToString() <> "All" Then
                    sql.AppendLine("AND Status = @Status")
                End If

                ' Branch filter
                If _currentBranchID = 0 Then
                    ' Head Office - check if specific branch selected
                    If cmbBranch.SelectedIndex > 0 Then
                        Dim selectedBranch = CType(cmbBranch.SelectedItem, Object)
                        Dim branchID = CInt(selectedBranch.Value)
                        sql.AppendLine("AND BranchID = @BranchID")
                    End If
                Else
                    ' Specific branch
                    sql.AppendLine("AND BranchID = @BranchID")
                End If

                sql.AppendLine("ORDER BY OrderDate DESC, OrderTime DESC")

                Using cmd As New SqlCommand(sql.ToString(), conn)
                    cmd.Parameters.AddWithValue("@FromDate", dtpFromDate.Value.Date)
                    cmd.Parameters.AddWithValue("@ToDate", dtpToDate.Value.Date)

                    If cmbStatus.SelectedItem?.ToString() <> "All" Then
                        cmd.Parameters.AddWithValue("@Status", cmbStatus.SelectedItem.ToString())
                    End If

                    If _currentBranchID = 0 AndAlso cmbBranch.SelectedIndex > 0 Then
                        Dim selectedBranch = CType(cmbBranch.SelectedItem, Object)
                        cmd.Parameters.AddWithValue("@BranchID", CInt(selectedBranch.Value))
                    ElseIf _currentBranchID > 0 Then
                        cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                    End If

                    Dim adapter As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)

                    dgvOrders.DataSource = dt

                    ' Hide UserDefinedOrderID column
                    If dgvOrders.Columns.Contains("UserDefinedOrderID") Then
                        dgvOrders.Columns("UserDefinedOrderID").Visible = False
                    End If

                    ' Color code by status
                    For Each row As DataGridViewRow In dgvOrders.Rows
                        Dim status = row.Cells("Status").Value.ToString()
                        Select Case status
                            Case "Created"
                                row.DefaultCellStyle.BackColor = Color.LightYellow
                            Case "Completed"
                                row.DefaultCellStyle.BackColor = Color.LightGreen
                            Case "PickedUp"
                                row.DefaultCellStyle.BackColor = Color.LightGray
                        End Select
                    Next
                End Using
            End Using

        Catch ex As Exception
            MessageBox.Show($"Error loading orders: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
        LoadOrders()
    End Sub

    Private Sub DgvOrders_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex >= 0 Then
            ViewSelectedOrder()
        End If
    End Sub

    Private Sub BtnViewOrder_Click(sender As Object, e As EventArgs)
        ViewSelectedOrder()
    End Sub

    Private Sub ViewSelectedOrder()
        Try
            If dgvOrders.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select an order to view.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim orderID = CInt(dgvOrders.SelectedRows(0).Cells("UserDefinedOrderID").Value)

            ' Open order details dialog
            Dim dialog As New UserDefinedOrderDetailsDialog(_connectionString, orderID)
            dialog.ShowDialog()

            ' Refresh grid after dialog closes
            LoadOrders()

        Catch ex As Exception
            MessageBox.Show($"Error viewing order: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnSetCompleted_Click(sender As Object, e As EventArgs)
        Try
            If dgvOrders.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select an order to mark as completed.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim orderID = CInt(dgvOrders.SelectedRows(0).Cells("UserDefinedOrderID").Value)
            Dim orderNumber = dgvOrders.SelectedRows(0).Cells("Order Number").Value.ToString()
            Dim currentStatus = dgvOrders.SelectedRows(0).Cells("Status").Value.ToString()

            If currentStatus = "Completed" Then
                MessageBox.Show("Order is already marked as Completed.", "Already Completed", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            If currentStatus = "PickedUp" Then
                MessageBox.Show("Order has already been picked up.", "Already Picked Up", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            ' Confirm
            Dim result = MessageBox.Show($"Mark order {orderNumber} as Completed?{vbCrLf}This will allow the customer to collect the order.", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result = DialogResult.No Then Return

            ' Update status
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim sql = "UPDATE POS_UserDefinedOrders SET Status = 'Completed', CompletedDate = GETDATE(), CompletedBy = @CompletedBy WHERE UserDefinedOrderID = @OrderID"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@CompletedBy", $"User {_currentUserID}")
                    cmd.Parameters.AddWithValue("@OrderID", orderID)
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            MessageBox.Show($"Order {orderNumber} marked as Completed!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)

            ' Refresh grid
            LoadOrders()

        Catch ex As Exception
            MessageBox.Show($"Error updating order status: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BtnClose_Click(sender As Object, e As EventArgs)
        Me.Close()
    End Sub
End Class
