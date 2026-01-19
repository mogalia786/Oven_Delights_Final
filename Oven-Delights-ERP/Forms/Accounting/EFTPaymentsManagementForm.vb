Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Windows.Forms
Imports System.IO

Public Class EFTPaymentsManagementForm
    Inherits Form

    Private _connectionString As String
    Private _currentUserID As Integer
    Private _currentUserName As String
    Private _currentBranchID As Integer
    Private dgvPayments As DataGridView
    Private cmbBranch As ComboBox
    Private cmbStatus As ComboBox
    Private btnRefresh As Button
    Private btnMarkReflected As Button
    Private btnViewDetails As Button
    Private btnUploadProof As Button
    Private lblTotalPending As Label
    Private lblTotalReflected As Label
    Private lblTotalAmount As Label

    ' Helper class for ComboBox items
    Private Class BranchItem
        Public Property BranchID As Integer
        Public Property BranchName As String
        
        Public Overrides Function ToString() As String
            Return BranchName
        End Function
    End Class

    Public Sub New(userID As Integer, userName As String, branchID As Integer)
        MyBase.New()
        _currentUserID = userID
        _currentUserName = userName
        _currentBranchID = branchID
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        InitializeComponent()
        
        ' Load data after form is shown
        AddHandler Me.Load, AddressOf EFTPaymentsManagementForm_Load
    End Sub
    
    Private Sub EFTPaymentsManagementForm_Load(sender As Object, e As EventArgs)
        Try
            LoadBranches()
            LoadEFTPayments()
        Catch ex As Exception
            MessageBox.Show($"Error loading form: {ex.Message}{vbCrLf}{vbCrLf}Stack: {ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub InitializeComponent()
        Me.Text = "EFT Payments Management"
        Me.Size = New Size(1400, 800)
        Me.StartPosition = FormStartPosition.CenterScreen
        Me.BackColor = Color.White

        Dim yPos As Integer = 20

        ' Header
        Dim lblHeader As New Label With {
            .Text = "💳 EFT PAYMENTS MANAGEMENT",
            .Font = New Font("Segoe UI", 18, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#2C3E50"),
            .Location = New Point(20, yPos),
            .Size = New Size(600, 40)
        }
        Me.Controls.Add(lblHeader)
        yPos += 50

        ' Instructions
        Dim lblInstructions As New Label With {
            .Text = "EFT payments are marked as 'Pending' until proof of payment is confirmed. Mark as 'Reflected' to update bank ledger and journal entries.",
            .Font = New Font("Segoe UI", 9, FontStyle.Italic),
            .ForeColor = ColorTranslator.FromHtml("#7F8C8D"),
            .Location = New Point(20, yPos),
            .Size = New Size(1000, 30)
        }
        Me.Controls.Add(lblInstructions)
        yPos += 40

        ' Filter Panel
        Dim pnlFilters As New Panel With {
            .Location = New Point(20, yPos),
            .Size = New Size(1350, 60),
            .BorderStyle = BorderStyle.FixedSingle,
            .BackColor = ColorTranslator.FromHtml("#ECF0F1")
        }

        Dim lblBranch As New Label With {
            .Text = "Branch:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(10, 18),
            .Size = New Size(60, 25)
        }
        pnlFilters.Controls.Add(lblBranch)

        cmbBranch = New ComboBox With {
            .Font = New Font("Segoe UI", 10),
            .Location = New Point(80, 15),
            .Size = New Size(250, 25),
            .DropDownStyle = ComboBoxStyle.DropDownList,
            .DisplayMember = "BranchName",
            .ValueMember = "BranchID"
        }
        pnlFilters.Controls.Add(cmbBranch)

        Dim lblStatus As New Label With {
            .Text = "Status:",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Location = New Point(295, 18),
            .Size = New Size(60, 25)
        }
        pnlFilters.Controls.Add(lblStatus)

        cmbStatus = New ComboBox With {
            .Font = New Font("Segoe UI", 10),
            .Location = New Point(360, 15),
            .Size = New Size(150, 25),
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        cmbStatus.Items.AddRange({"All", "Pending", "Reflected", "Cancelled"})
        cmbStatus.SelectedIndex = 1 ' Default to Pending
        pnlFilters.Controls.Add(cmbStatus)

        btnRefresh = New Button With {
            .Text = "🔄 Refresh",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .Size = New Size(120, 35),
            .Location = New Point(530, 12),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnRefresh.FlatAppearance.BorderSize = 0
        AddHandler btnRefresh.Click, AddressOf BtnRefresh_Click
        pnlFilters.Controls.Add(btnRefresh)

        Me.Controls.Add(pnlFilters)
        yPos += 70

        ' Summary Panel
        Dim pnlSummary As New Panel With {
            .Location = New Point(20, yPos),
            .Size = New Size(1350, 50),
            .BackColor = ColorTranslator.FromHtml("#F8F9FA")
        }

        lblTotalPending = New Label With {
            .Text = "Pending: R 0.00 (0)",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#E67E22"),
            .Location = New Point(20, 15),
            .Size = New Size(300, 25)
        }
        pnlSummary.Controls.Add(lblTotalPending)

        lblTotalReflected = New Label With {
            .Text = "Reflected: R 0.00 (0)",
            .Font = New Font("Segoe UI", 10, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#27AE60"),
            .Location = New Point(340, 15),
            .Size = New Size(300, 25)
        }
        pnlSummary.Controls.Add(lblTotalReflected)

        lblTotalAmount = New Label With {
            .Text = "Total: R 0.00",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = ColorTranslator.FromHtml("#2C3E50"),
            .Location = New Point(660, 15),
            .Size = New Size(300, 25)
        }
        pnlSummary.Controls.Add(lblTotalAmount)

        Me.Controls.Add(pnlSummary)
        yPos += 60

        ' DataGridView
        dgvPayments = New DataGridView With {
            .Location = New Point(20, yPos),
            .Size = New Size(1350, 450),
            .ReadOnly = True,
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .MultiSelect = False,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .BackgroundColor = Color.White,
            .BorderStyle = BorderStyle.Fixed3D,
            .RowHeadersVisible = False
        }
        Me.Controls.Add(dgvPayments)
        yPos += 460

        ' Action Buttons
        btnMarkReflected = New Button With {
            .Text = "✓ Mark as Reflected",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(200, 45),
            .Location = New Point(20, yPos),
            .BackColor = ColorTranslator.FromHtml("#27AE60"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnMarkReflected.FlatAppearance.BorderSize = 0
        AddHandler btnMarkReflected.Click, AddressOf BtnMarkReflected_Click
        Me.Controls.Add(btnMarkReflected)

        btnUploadProof = New Button With {
            .Text = "📎 Upload Proof",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(200, 45),
            .Location = New Point(230, yPos),
            .BackColor = ColorTranslator.FromHtml("#3498DB"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnUploadProof.FlatAppearance.BorderSize = 0
        AddHandler btnUploadProof.Click, AddressOf BtnUploadProof_Click
        Me.Controls.Add(btnUploadProof)

        btnViewDetails = New Button With {
            .Text = "📋 View Details",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(200, 45),
            .Location = New Point(440, yPos),
            .BackColor = ColorTranslator.FromHtml("#9B59B6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnViewDetails.FlatAppearance.BorderSize = 0
        AddHandler btnViewDetails.Click, AddressOf BtnViewDetails_Click
        Me.Controls.Add(btnViewDetails)

        Dim btnClose As New Button With {
            .Text = "Close",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .Size = New Size(150, 45),
            .Location = New Point(1220, yPos),
            .BackColor = ColorTranslator.FromHtml("#95A5A6"),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand
        }
        btnClose.FlatAppearance.BorderSize = 0
        AddHandler btnClose.Click, Sub() Me.Close()
        Me.Controls.Add(btnClose)
    End Sub

    Private Sub LoadBranches()
        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                
                ' Add "All Branches" option if user is at Head Office (BranchID = 0)
                cmbBranch.Items.Clear()
                If _currentBranchID = 0 Then
                    cmbBranch.Items.Add(New BranchItem With {.BranchID = 0, .BranchName = "All Branches"})
                End If
                
                Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            cmbBranch.Items.Add(New BranchItem With {
                                .BranchID = CInt(reader("BranchID")),
                                .BranchName = reader("BranchName").ToString()
                            })
                        End While
                    End Using
                End Using
                
                ' Set default selection
                If _currentBranchID = 0 AndAlso cmbBranch.Items.Count > 0 Then
                    cmbBranch.SelectedIndex = 0 ' All Branches
                Else
                    ' Find and select current branch
                    For i As Integer = 0 To cmbBranch.Items.Count - 1
                        Dim item As BranchItem = TryCast(cmbBranch.Items(i), BranchItem)
                        If item IsNot Nothing AndAlso item.BranchID = _currentBranchID Then
                            cmbBranch.SelectedIndex = i
                            Exit For
                        End If
                    Next
                End If
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading branches: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadEFTPayments()
        Try
            Dim selectedBranchID As Integer? = Nothing
            If cmbBranch IsNot Nothing AndAlso cmbBranch.SelectedItem IsNot Nothing Then
                Dim branchItem As BranchItem = TryCast(cmbBranch.SelectedItem, BranchItem)
                If branchItem IsNot Nothing Then
                    selectedBranchID = branchItem.BranchID
                    If selectedBranchID = 0 Then selectedBranchID = Nothing ' All branches
                End If
            End If
            
            Dim selectedStatus As String = "Pending"
            If cmbStatus IsNot Nothing AndAlso cmbStatus.SelectedItem IsNot Nothing Then
                selectedStatus = cmbStatus.SelectedItem.ToString()
            End If
            
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using cmd As New SqlCommand("sp_GetPendingEFTPayments", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@BranchID", If(selectedBranchID, DBNull.Value))
                    cmd.Parameters.AddWithValue("@Status", selectedStatus)
                    
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using
                    
                    dgvPayments.DataSource = dt
                    FormatGrid()
                    UpdateSummary(dt)
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading EFT payments: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub FormatGrid()
        If dgvPayments.Columns.Count = 0 Then Return
        
        ' Hide unnecessary columns
        If dgvPayments.Columns.Contains("EFTPaymentID") Then dgvPayments.Columns("EFTPaymentID").Visible = False
        If dgvPayments.Columns.Contains("TransactionID") Then dgvPayments.Columns("TransactionID").Visible = False
        If dgvPayments.Columns.Contains("TillPointID") Then dgvPayments.Columns("TillPointID").Visible = False
        If dgvPayments.Columns.Contains("CashierID") Then dgvPayments.Columns("CashierID").Visible = False
        If dgvPayments.Columns.Contains("JournalEntryID") Then dgvPayments.Columns("JournalEntryID").Visible = False
        If dgvPayments.Columns.Contains("LedgerUpdated") Then dgvPayments.Columns("LedgerUpdated").Visible = False
        If dgvPayments.Columns.Contains("CreatedDate") Then dgvPayments.Columns("CreatedDate").Visible = False
        If dgvPayments.Columns.Contains("ModifiedDate") Then dgvPayments.Columns("ModifiedDate").Visible = False
        If dgvPayments.Columns.Contains("PaymentTime") Then dgvPayments.Columns("PaymentTime").Visible = False
        If dgvPayments.Columns.Contains("BankName") Then dgvPayments.Columns("BankName").Visible = False
        If dgvPayments.Columns.Contains("AccountNumber") Then dgvPayments.Columns("AccountNumber").Visible = False
        If dgvPayments.Columns.Contains("BranchCode") Then dgvPayments.Columns("BranchCode").Visible = False
        If dgvPayments.Columns.Contains("CustomerSurname") Then dgvPayments.Columns("CustomerSurname").Visible = False
        If dgvPayments.Columns.Contains("Notes") Then dgvPayments.Columns("Notes").Visible = False
        If dgvPayments.Columns.Contains("ProofOfPaymentPath") Then dgvPayments.Columns("ProofOfPaymentPath").Visible = False
        
        ' Set column headers and widths
        If dgvPayments.Columns.Contains("PaymentReference") Then 
            dgvPayments.Columns("PaymentReference").HeaderText = "Reference"
            dgvPayments.Columns("PaymentReference").AutoSizeMode = DataGridViewAutoSizeColumnMode.None
            dgvPayments.Columns("PaymentReference").Width = 180
        End If
        If dgvPayments.Columns.Contains("TransactionType") Then 
            dgvPayments.Columns("TransactionType").HeaderText = "Type"
            dgvPayments.Columns("TransactionType").Width = 80
        End If
        If dgvPayments.Columns.Contains("InvoiceNumber") Then 
            dgvPayments.Columns("InvoiceNumber").HeaderText = "Invoice #"
            dgvPayments.Columns("InvoiceNumber").Width = 100
        End If
        If dgvPayments.Columns.Contains("OrderNumber") Then 
            dgvPayments.Columns("OrderNumber").HeaderText = "Order #"
            dgvPayments.Columns("OrderNumber").Width = 80
        End If
        If dgvPayments.Columns.Contains("BranchID") Then 
            dgvPayments.Columns("BranchID").HeaderText = "BranchID"
            dgvPayments.Columns("BranchID").Width = 70
        End If
        If dgvPayments.Columns.Contains("BranchName") Then 
            dgvPayments.Columns("BranchName").HeaderText = "Branch"
            dgvPayments.Columns("BranchName").Width = 100
        End If
        If dgvPayments.Columns.Contains("CashierName") Then 
            dgvPayments.Columns("CashierName").HeaderText = "Cashier"
            dgvPayments.Columns("CashierName").Width = 100
        End If
        If dgvPayments.Columns.Contains("PaymentDate") Then 
            dgvPayments.Columns("PaymentDate").HeaderText = "Payment Date"
            dgvPayments.Columns("PaymentDate").DefaultCellStyle.Format = "dd/MM/yyyy HH:mm"
            dgvPayments.Columns("PaymentDate").Width = 130
        End If
        If dgvPayments.Columns.Contains("Amount") Then 
            dgvPayments.Columns("Amount").HeaderText = "Amount"
            dgvPayments.Columns("Amount").DefaultCellStyle.Format = "C2"
            dgvPayments.Columns("Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            dgvPayments.Columns("Amount").Width = 100
        End If
        If dgvPayments.Columns.Contains("CustomerName") Then 
            dgvPayments.Columns("CustomerName").HeaderText = "Customer"
            dgvPayments.Columns("CustomerName").Width = 120
        End If
        If dgvPayments.Columns.Contains("CustomerCell") Then 
            dgvPayments.Columns("CustomerCell").HeaderText = "Cell"
            dgvPayments.Columns("CustomerCell").Width = 100
        End If
        If dgvPayments.Columns.Contains("Status") Then 
            dgvPayments.Columns("Status").HeaderText = "Status"
            dgvPayments.Columns("Status").Width = 80
        End If
        If dgvPayments.Columns.Contains("ReflectedDate") Then 
            dgvPayments.Columns("ReflectedDate").HeaderText = "Reflected Date"
            dgvPayments.Columns("ReflectedDate").DefaultCellStyle.Format = "dd/MM/yyyy HH:mm"
            dgvPayments.Columns("ReflectedDate").Width = 130
        End If
        If dgvPayments.Columns.Contains("ReflectedBy") Then 
            dgvPayments.Columns("ReflectedBy").HeaderText = "Reflected By"
            dgvPayments.Columns("ReflectedBy").Width = 100
        End If
        If dgvPayments.Columns.Contains("DaysOutstanding") Then 
            dgvPayments.Columns("DaysOutstanding").HeaderText = "Days"
            dgvPayments.Columns("DaysOutstanding").Width = 60
        End If
        
        ' Color code status
        If dgvPayments.Columns.Contains("Status") Then
            For Each row As DataGridViewRow In dgvPayments.Rows
                If Not row.IsNewRow AndAlso row.Cells("Status") IsNot Nothing AndAlso row.Cells("Status").Value IsNot Nothing Then
                    Select Case row.Cells("Status").Value.ToString()
                        Case "Pending"
                            row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#FFF3CD")
                        Case "Reflected"
                            row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#D4EDDA")
                        Case "Cancelled"
                            row.DefaultCellStyle.BackColor = ColorTranslator.FromHtml("#F8D7DA")
                    End Select
                End If
            Next
        End If
    End Sub

    Private Sub UpdateSummary(dt As DataTable)
        Dim pendingCount As Integer = 0
        Dim pendingAmount As Decimal = 0
        Dim reflectedCount As Integer = 0
        Dim reflectedAmount As Decimal = 0
        Dim totalAmount As Decimal = 0
        
        For Each row As DataRow In dt.Rows
            Dim amount As Decimal = CDec(row("Amount"))
            totalAmount += amount
            
            Select Case row("Status").ToString()
                Case "Pending"
                    pendingCount += 1
                    pendingAmount += amount
                Case "Reflected"
                    reflectedCount += 1
                    reflectedAmount += amount
            End Select
        Next
        
        lblTotalPending.Text = $"Pending: R {pendingAmount:N2} ({pendingCount})"
        lblTotalReflected.Text = $"Reflected: R {reflectedAmount:N2} ({reflectedCount})"
        lblTotalAmount.Text = $"Total: R {totalAmount:N2}"
    End Sub

    Private Sub BtnRefresh_Click(sender As Object, e As EventArgs)
        LoadEFTPayments()
    End Sub

    Private Sub BtnMarkReflected_Click(sender As Object, e As EventArgs)
        If dgvPayments.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select an EFT payment to mark as reflected.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim selectedRow = dgvPayments.SelectedRows(0)
        Dim eftPaymentID As Integer = CInt(selectedRow.Cells("EFTPaymentID").Value)
        Dim currentStatus As String = selectedRow.Cells("Status").Value.ToString()
        Dim amount As Decimal = CDec(selectedRow.Cells("Amount").Value)
        Dim reference As String = selectedRow.Cells("PaymentReference").Value.ToString()
        
        If currentStatus = "Reflected" Then
            MessageBox.Show("This payment is already marked as Reflected.", "Already Reflected", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        Dim result = MessageBox.Show($"Mark EFT payment as REFLECTED?{vbCrLf}{vbCrLf}Reference: {reference}{vbCrLf}Amount: R {amount:N2}{vbCrLf}{vbCrLf}This will update the bank ledger and journal entries.", "Confirm Reflection", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
        
        If result = DialogResult.Yes Then
            Try
                Using conn As New SqlConnection(_connectionString)
                    conn.Open()
                    Using cmd As New SqlCommand("sp_MarkEFTPaymentReflected", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.AddWithValue("@EFTPaymentID", eftPaymentID)
                        cmd.Parameters.AddWithValue("@ReflectedBy", _currentUserName)
                        cmd.Parameters.AddWithValue("@ProofOfPaymentPath", DBNull.Value)
                        cmd.Parameters.AddWithValue("@Notes", DBNull.Value)
                        
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
                
                MessageBox.Show("EFT payment marked as Reflected successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                LoadEFTPayments()
                
            Catch ex As Exception
                MessageBox.Show($"Error marking payment as reflected: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

    Private Sub BtnUploadProof_Click(sender As Object, e As EventArgs)
        If dgvPayments.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select an EFT payment to upload proof.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        MessageBox.Show("Proof of payment upload functionality will be implemented in future update.", "Coming Soon", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub BtnViewDetails_Click(sender As Object, e As EventArgs)
        If dgvPayments.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select an EFT payment to view details.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim selectedRow = dgvPayments.SelectedRows(0)
        Dim details As New System.Text.StringBuilder()
        
        details.AppendLine("EFT PAYMENT DETAILS")
        details.AppendLine("==================")
        details.AppendLine()
        details.AppendLine($"Reference: {selectedRow.Cells("PaymentReference").Value}")
        details.AppendLine($"Type: {selectedRow.Cells("TransactionType").Value}")
        details.AppendLine($"Amount: R {CDec(selectedRow.Cells("Amount").Value):N2}")
        details.AppendLine($"Status: {selectedRow.Cells("Status").Value}")
        details.AppendLine()
        details.AppendLine($"Branch: {selectedRow.Cells("BranchName").Value}")
        details.AppendLine($"Cashier: {selectedRow.Cells("CashierName").Value}")
        details.AppendLine($"Payment Date: {CDate(selectedRow.Cells("PaymentDate").Value):dd/MM/yyyy HH:mm}")
        details.AppendLine()
        
        If Not IsDBNull(selectedRow.Cells("CustomerName").Value) Then
            details.AppendLine($"Customer: {selectedRow.Cells("CustomerName").Value} {selectedRow.Cells("CustomerSurname").Value}")
            details.AppendLine($"Cell: {selectedRow.Cells("CustomerCell").Value}")
            details.AppendLine()
        End If
        
        If selectedRow.Cells("Status").Value.ToString() = "Reflected" Then
            details.AppendLine($"Reflected Date: {CDate(selectedRow.Cells("ReflectedDate").Value):dd/MM/yyyy HH:mm}")
            details.AppendLine($"Reflected By: {selectedRow.Cells("ReflectedBy").Value}")
        End If
        
        If Not IsDBNull(selectedRow.Cells("Notes").Value) Then
            details.AppendLine()
            details.AppendLine($"Notes: {selectedRow.Cells("Notes").Value}")
        End If
        
        MessageBox.Show(details.ToString(), "Payment Details", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub
End Class
