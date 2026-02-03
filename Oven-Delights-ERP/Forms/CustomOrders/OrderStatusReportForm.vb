Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Drawing
Imports System.Windows.Forms

Public Class OrderStatusReportForm
    Inherits Form
    
    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchID As Integer
    Private dtpReadyDate As DateTimePicker
    Private cmbBranch As ComboBox
    Private cmbStatus As ComboBox
    Private dgvOrders As DataGridView
    Private btnGenerate As Button
    Private btnPrint As Button
    Private btnExport As Button
    Private btnClose As Button
    Private lblTitle As Label
    Private lblSummary As Label
    Private pnlTop As Panel
    Private pnlFilters As Panel
    
    Public Sub New(branchID As Integer)
        MyBase.New()
        _currentBranchID = branchID
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        InitializeComponent()
        LoadBranches()
        LoadStatuses()
    End Sub
    
    Private Sub InitializeComponent()
        Me.Text = "Order Status Report"
        Me.Size = New Size(1400, 800)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.White
        
        ' Top Panel
        pnlTop = New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#8E44AD")
        }
        
        lblTitle = New Label With {
            .Text = "📋 ORDER STATUS REPORT",
            .Font = New Font("Segoe UI", 24, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = False,
            .Size = New Size(800, 50),
            .Location = New Point(20, 15),
            .TextAlign = ContentAlignment.MiddleLeft
        }
        pnlTop.Controls.Add(lblTitle)
        
        ' Filters Panel
        pnlFilters = New Panel With {
            .Dock = DockStyle.Top,
            .Height = 80,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1"),
            .Padding = New Padding(20, 15, 20, 15)
        }
        
        Dim lblDate As New Label With {
            .Text = "Ready Date:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(20, 25),
            .AutoSize = True
        }
        pnlFilters.Controls.Add(lblDate)
        
        dtpReadyDate = New DateTimePicker With {
            .Font = New Font("Segoe UI", 10),
            .Location = New Point(120, 22),
            .Size = New Size(200, 25),
            .Format = DateTimePickerFormat.Short
        }
        pnlFilters.Controls.Add(dtpReadyDate)
        
        Dim lblBranch As New Label With {
            .Text = "Branch:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(350, 25),
            .AutoSize = True
        }
        pnlFilters.Controls.Add(lblBranch)
        
        cmbBranch = New ComboBox With {
            .Font = New Font("Segoe UI", 10),
            .Location = New Point(420, 22),
            .Size = New Size(250, 25),
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        pnlFilters.Controls.Add(cmbBranch)
        
        Dim lblStatus As New Label With {
            .Text = "Status:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(700, 25),
            .AutoSize = True
        }
        pnlFilters.Controls.Add(lblStatus)
        
        cmbStatus = New ComboBox With {
            .Font = New Font("Segoe UI", 10),
            .Location = New Point(760, 22),
            .Size = New Size(200, 25),
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        pnlFilters.Controls.Add(cmbStatus)
        
        btnGenerate = New Button With {
            .Text = "📊 GENERATE",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(990, 18),
            .Size = New Size(150, 35),
            .BackColor = ColorTranslator.FromHtml("#27AE60"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnGenerate.FlatAppearance.BorderSize = 0
        AddHandler btnGenerate.Click, AddressOf btnGenerate_Click
        pnlFilters.Controls.Add(btnGenerate)
        
        ' Summary Label
        lblSummary = New Label With {
            .Text = "Select date and click Generate to view order status report",
            .Font = New Font("Segoe UI", 10),
            .ForeColor = ColorTranslator.FromHtml("#7F8C8D"),
            .Location = New Point(20, 10),
            .AutoSize = True,
            .Dock = DockStyle.Top,
            .Padding = New Padding(20, 10, 20, 10)
        }
        
        ' DataGridView
        dgvOrders = New DataGridView With {
            .Dock = DockStyle.Fill,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .ReadOnly = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.None,
            .RowHeadersVisible = False,
            .Font = New Font("Segoe UI", 10),
            .ColumnHeadersHeight = 40
        }
        
        dgvOrders.ColumnHeadersDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#34495E")
        dgvOrders.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvOrders.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        dgvOrders.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
        dgvOrders.EnableHeadersVisualStyles = False
        dgvOrders.AlternatingRowsDefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F8F9FA")
        dgvOrders.RowTemplate.Height = 35
        
        ' Bottom Panel with buttons
        Dim pnlBottom As New Panel With {
            .Dock = DockStyle.Bottom,
            .Height = 70,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1")
        }
        
        btnPrint = New Button With {
            .Text = "🖨️ PRINT",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(20, 15),
            .Size = New Size(150, 40),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnPrint.FlatAppearance.BorderSize = 0
        AddHandler btnPrint.Click, AddressOf btnPrint_Click
        pnlBottom.Controls.Add(btnPrint)
        
        btnExport = New Button With {
            .Text = "📤 EXPORT",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(190, 15),
            .Size = New Size(150, 40),
            .BackColor = ColorTranslator.FromHtml("#9B59B6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnExport.FlatAppearance.BorderSize = 0
        AddHandler btnExport.Click, AddressOf btnExport_Click
        pnlBottom.Controls.Add(btnExport)
        
        btnClose = New Button With {
            .Text = "❌ CLOSE",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(1220, 15),
            .Size = New Size(150, 40),
            .BackColor = ColorTranslator.FromHtml("#E74C3C"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, AddressOf btnClose_Click
        pnlBottom.Controls.Add(btnClose)
        
        ' Add controls to form
        Me.Controls.Add(dgvOrders)
        Me.Controls.Add(lblSummary)
        Me.Controls.Add(pnlFilters)
        Me.Controls.Add(pnlTop)
        Me.Controls.Add(pnlBottom)
    End Sub
    
    Private Sub LoadBranches()
        Try
            cmbBranch.Items.Clear()
            cmbBranch.DisplayMember = "BranchName"
            cmbBranch.ValueMember = "BranchID"
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                ' Add "All Branches" option
                cmbBranch.Items.Add(New With {.BranchID = 0, .BranchName = "All Branches"})
                
                ' Load all active branches
                Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            cmbBranch.Items.Add(New With {
                                .BranchID = CInt(reader("BranchID")),
                                .BranchName = reader("BranchName").ToString()
                            })
                        End While
                    End Using
                End Using
            End Using
            
            ' Set default selection - always show "All Branches" first
            If cmbBranch.Items.Count > 0 Then
                cmbBranch.SelectedIndex = 0
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub LoadStatuses()
        cmbStatus.Items.Clear()
        cmbStatus.Items.Add(New With {.Value = "", .Display = "All Statuses"})
        cmbStatus.Items.Add(New With {.Value = "New", .Display = "Processing (New)"})
        cmbStatus.Items.Add(New With {.Value = "InProgress", .Display = "Processing (In Progress)"})
        cmbStatus.Items.Add(New With {.Value = "Completed", .Display = "Completed"})
        cmbStatus.Items.Add(New With {.Value = "PickedUp", .Display = "Completed & Picked Up"})
        cmbStatus.DisplayMember = "Display"
        cmbStatus.ValueMember = "Value"
        cmbStatus.SelectedIndex = 0
    End Sub
    
    Private Sub btnGenerate_Click(sender As Object, e As EventArgs)
        Try
            Dim selectedBranchID As Integer? = Nothing
            If cmbBranch.SelectedItem IsNot Nothing Then
                Dim branchId As Integer = CInt(cmbBranch.SelectedItem.GetType().GetProperty("BranchID").GetValue(cmbBranch.SelectedItem, Nothing))
                If branchId > 0 Then selectedBranchID = branchId
            End If
            
            Dim selectedStatus As String = Nothing
            If cmbStatus.SelectedItem IsNot Nothing Then
                Dim statusValue As String = cmbStatus.SelectedItem.GetType().GetProperty("Value").GetValue(cmbStatus.SelectedItem, Nothing).ToString()
                If Not String.IsNullOrEmpty(statusValue) Then selectedStatus = statusValue
            End If
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Using cmd As New SqlCommand("sp_GetOrderStatusReport", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ReadyDate", dtpReadyDate.Value.Date)
                    cmd.Parameters.AddWithValue("@BranchID", If(selectedBranchID, DBNull.Value))
                    cmd.Parameters.AddWithValue("@OrderStatus", If(selectedStatus, DBNull.Value))
                    
                    Using da As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        dgvOrders.DataSource = dt
                        
                        FormatGrid()
                        
                        ' Update summary
                        Dim totalOrders As Integer = dt.Rows.Count
                        Dim processingCount As Integer = dt.Select("OrderStatus IN ('New', 'InProgress')").Length
                        Dim completedCount As Integer = dt.Select("OrderStatus = 'Completed'").Length
                        Dim pickedUpCount As Integer = dt.Select("OrderStatus = 'PickedUp'").Length
                        
                        lblSummary.Text = $"Orders for {dtpReadyDate.Value:dd MMM yyyy} - Total: {totalOrders} | Processing: {processingCount} | Completed: {completedCount} | Picked Up: {pickedUpCount}"
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error generating report: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub FormatGrid()
        ' Hide internal columns
        If dgvOrders.Columns.Contains("OrderID") Then dgvOrders.Columns("OrderID").Visible = False
        If dgvOrders.Columns.Contains("BranchID") Then dgvOrders.Columns("BranchID").Visible = False
        If dgvOrders.Columns.Contains("OrderStatus") Then dgvOrders.Columns("OrderStatus").Visible = False
        If dgvOrders.Columns.Contains("ItemCount") Then dgvOrders.Columns("ItemCount").Visible = False
        
        ' Format visible columns
        If dgvOrders.Columns.Contains("OrderNumber") Then
            dgvOrders.Columns("OrderNumber").HeaderText = "Order #"
            dgvOrders.Columns("OrderNumber").Width = 120
            dgvOrders.Columns("OrderNumber").DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        End If
        
        If dgvOrders.Columns.Contains("CollectionPoint") Then
            dgvOrders.Columns("CollectionPoint").HeaderText = "Branch"
            dgvOrders.Columns("CollectionPoint").Width = 120
        End If
        
        If dgvOrders.Columns.Contains("CustomerName") Then
            dgvOrders.Columns("CustomerName").HeaderText = "Customer"
            dgvOrders.Columns("CustomerName").Width = 150
        End If
        
        If dgvOrders.Columns.Contains("CustomerPhone") Then
            dgvOrders.Columns("CustomerPhone").HeaderText = "Phone"
            dgvOrders.Columns("CustomerPhone").Width = 120
        End If
        
        If dgvOrders.Columns.Contains("ReadyDate") Then
            dgvOrders.Columns("ReadyDate").HeaderText = "Ready Date"
            dgvOrders.Columns("ReadyDate").Width = 100
            dgvOrders.Columns("ReadyDate").DefaultCellStyle.Format = "dd MMM yyyy"
        End If
        
        If dgvOrders.Columns.Contains("ReadyTime") Then
            dgvOrders.Columns("ReadyTime").HeaderText = "Time"
            dgvOrders.Columns("ReadyTime").Width = 80
            dgvOrders.Columns("ReadyTime").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
        End If
        
        If dgvOrders.Columns.Contains("StatusDisplay") Then
            dgvOrders.Columns("StatusDisplay").HeaderText = "Status"
            dgvOrders.Columns("StatusDisplay").Width = 150
            dgvOrders.Columns("StatusDisplay").DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        End If
        
        If dgvOrders.Columns.Contains("DateOrdered") Then
            dgvOrders.Columns("DateOrdered").HeaderText = "Date Ordered"
            dgvOrders.Columns("DateOrdered").Width = 140
            dgvOrders.Columns("DateOrdered").DefaultCellStyle.Format = "dd MMM yyyy HH:mm"
        End If
        
        If dgvOrders.Columns.Contains("DateTimeCreated") Then
            dgvOrders.Columns("DateTimeCreated").HeaderText = "Created"
            dgvOrders.Columns("DateTimeCreated").Width = 140
            dgvOrders.Columns("DateTimeCreated").DefaultCellStyle.Format = "dd MMM yyyy HH:mm"
            dgvOrders.Columns("DateTimeCreated").DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#E8F8F5")
        End If
        
        If dgvOrders.Columns.Contains("DateTimeModified") Then
            dgvOrders.Columns("DateTimeModified").HeaderText = "Last Modified"
            dgvOrders.Columns("DateTimeModified").Width = 140
            dgvOrders.Columns("DateTimeModified").DefaultCellStyle.Format = "dd MMM yyyy HH:mm"
            dgvOrders.Columns("DateTimeModified").DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#FEF9E7")
        End If
        
        If dgvOrders.Columns.Contains("TotalAmount") Then
            dgvOrders.Columns("TotalAmount").HeaderText = "Total"
            dgvOrders.Columns("TotalAmount").Width = 90
            dgvOrders.Columns("TotalAmount").DefaultCellStyle.Format = "C2"
            dgvOrders.Columns("TotalAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        End If
        
        If dgvOrders.Columns.Contains("DepositPaid") Then
            dgvOrders.Columns("DepositPaid").HeaderText = "Deposit"
            dgvOrders.Columns("DepositPaid").Width = 90
            dgvOrders.Columns("DepositPaid").DefaultCellStyle.Format = "C2"
            dgvOrders.Columns("DepositPaid").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        End If
        
        If dgvOrders.Columns.Contains("BalanceDue") Then
            dgvOrders.Columns("BalanceDue").HeaderText = "Balance"
            dgvOrders.Columns("BalanceDue").Width = 90
            dgvOrders.Columns("BalanceDue").DefaultCellStyle.Format = "C2"
            dgvOrders.Columns("BalanceDue").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            dgvOrders.Columns("BalanceDue").DefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        End If
        
        If dgvOrders.Columns.Contains("ItemSummary") Then
            dgvOrders.Columns("ItemSummary").HeaderText = "Items"
            dgvOrders.Columns("ItemSummary").Width = 250
        End If
        
        If dgvOrders.Columns.Contains("SpecialInstructions") Then
            dgvOrders.Columns("SpecialInstructions").HeaderText = "Special Instructions"
            dgvOrders.Columns("SpecialInstructions").Width = 200
        End If
        
        ' Color code rows by status
        For Each row As DataGridViewRow In dgvOrders.Rows
            If row.Cells("OrderStatus").Value IsNot Nothing Then
                Dim status As String = row.Cells("OrderStatus").Value.ToString()
                Select Case status
                    Case "New", "InProgress"
                        row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#FFF3CD")
                    Case "Completed"
                        row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#D1ECF1")
                    Case "PickedUp"
                        row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#D4EDDA")
                End Select
            End If
        Next
    End Sub
    
    Private Sub btnPrint_Click(sender As Object, e As EventArgs)
        Try
            MessageBox.Show("Print functionality will be implemented", "Print", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnExport_Click(sender As Object, e As EventArgs)
        Try
            MessageBox.Show("Export functionality will be implemented", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"Error exporting: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnClose_Click(sender As Object, e As EventArgs)
        Me.Close()
    End Sub
End Class
