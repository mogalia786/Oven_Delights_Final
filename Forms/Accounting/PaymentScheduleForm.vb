Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.IO

Public Class PaymentScheduleForm
    Inherits Form

    Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private paymentService As New PaymentDueService()
    
    Private dgvPayments As DataGridView
    Private btnRefresh As Button
    Private btnExportCSV As Button
    Private btnMarkPaid As Button
    Private lblTotal As Label
    Private lblCount As Label
    Private dtpFilterDate As DateTimePicker
    Private chkShowAll As CheckBox

    Public Sub New()
        Me.Text = "Payment Schedule Management"
        Me.Width = 1200
        Me.Height = 700
        Me.StartPosition = FormStartPosition.CenterParent
        InitializeUI()
        LoadPaymentsDue()
    End Sub

    Private Sub InitializeUI()
        ' Filter controls
        Dim lblFilter As New Label With {
            .Text = "Show payments due by:",
            .Location = New Point(10, 15),
            .Size = New Size(120, 20)
        }
        
        dtpFilterDate = New DateTimePicker With {
            .Location = New Point(135, 12),
            .Size = New Size(120, 25),
            .Value = DateTime.Today.AddDays(7)
        }
        
        chkShowAll = New CheckBox With {
            .Text = "Show all pending",
            .Location = New Point(265, 15),
            .Size = New Size(120, 20)
        }
        
        btnRefresh = New Button With {
            .Text = "Refresh",
            .Location = New Point(395, 10),
            .Size = New Size(80, 30),
            .BackColor = Color.LightBlue
        }
        
        ' Summary labels
        lblCount = New Label With {
            .Location = New Point(10, 50),
            .Size = New Size(200, 20),
            .Font = New Font("Arial", 9, FontStyle.Bold)
        }
        
        lblTotal = New Label With {
            .Location = New Point(220, 50),
            .Size = New Size(200, 20),
            .Font = New Font("Arial", 9, FontStyle.Bold),
            .ForeColor = Color.Red
        }
        
        ' Payments grid
        dgvPayments = New DataGridView With {
            .Location = New Point(10, 80),
            .Size = New Size(1160, 500),
            .AllowUserToAddRows = False,
            .AllowUserToDeleteRows = False,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
            .MultiSelect = True
        }
        
        ' Action buttons
        btnExportCSV = New Button With {
            .Text = "Export Payment List (CSV)",
            .Location = New Point(10, 600),
            .Size = New Size(180, 35),
            .BackColor = Color.LightGreen
        }
        
        btnMarkPaid = New Button With {
            .Text = "Mark Selected as Paid",
            .Location = New Point(200, 600),
            .Size = New Size(160, 35),
            .BackColor = Color.Orange
        }
        
        ' Add controls
        Me.Controls.AddRange({lblFilter, dtpFilterDate, chkShowAll, btnRefresh, lblCount, lblTotal, dgvPayments, btnExportCSV, btnMarkPaid})
        
        ' Event handlers
        AddHandler btnRefresh.Click, AddressOf OnRefresh
        AddHandler btnExportCSV.Click, AddressOf OnExportCSV
        AddHandler btnMarkPaid.Click, AddressOf OnMarkPaid
        AddHandler chkShowAll.CheckedChanged, AddressOf OnFilterChanged
        AddHandler dtpFilterDate.ValueChanged, AddressOf OnFilterChanged
    End Sub

    Private Sub LoadPaymentsDue()
        Try
            Dim dt As DataTable = paymentService.GetPaymentsDueList()
            
            ' Apply date filter if not showing all
            If Not chkShowAll.Checked Then
                Dim filteredRows = dt.Select($"DueDate <= #{dtpFilterDate.Value:yyyy-MM-dd}#")
                If filteredRows.Length > 0 Then
                    dt = filteredRows.CopyToDataTable()
                Else
                    dt.Clear()
                End If
            End If
            
            dgvPayments.DataSource = dt
            ConfigureGrid()
            UpdateSummary(dt)
            
        Catch ex As Exception
            MessageBox.Show($"Error loading payments: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ConfigureGrid()
        With dgvPayments
            .Columns("PaymentType").Width = 80
            .Columns("Reference").Width = 120
            .Columns("Payee").Width = 200
            .Columns("Amount").Width = 100
            .Columns("Amount").DefaultCellStyle.Format = "C2"
            .Columns("Amount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
            .Columns("DueDate").Width = 100
            .Columns("DueDate").DefaultCellStyle.Format = "yyyy-MM-dd"
            .Columns("DaysOverdue").Width = 80
            .Columns("Description").Width = 200
            .Columns("BankAccount").Width = 120
            .Columns("BankBranch").Width = 80
            .Columns("BankName").Width = 100
            .Columns("ReferenceID").Visible = False
        End With
        
        ' Color code overdue payments
        For Each row As DataGridViewRow In dgvPayments.Rows
            Dim daysOverdue As Integer = Convert.ToInt32(row.Cells("DaysOverdue").Value)
            If daysOverdue > 30 Then
                row.DefaultCellStyle.BackColor = Color.LightCoral
            ElseIf daysOverdue > 7 Then
                row.DefaultCellStyle.BackColor = Color.LightYellow
            End If
        Next
    End Sub

    Private Sub UpdateSummary(dt As DataTable)
        Dim count As Integer = dt.Rows.Count
        Dim total As Decimal = 0
        
        For Each row As DataRow In dt.Rows
            total += Convert.ToDecimal(row("Amount"))
        Next
        
        lblCount.Text = $"Payments Due: {count}"
        lblTotal.Text = $"Total Amount: {total:C2}"
    End Sub

    Private Sub OnRefresh(sender As Object, e As EventArgs)
        LoadPaymentsDue()
    End Sub

    Private Sub OnFilterChanged(sender As Object, e As EventArgs)
        LoadPaymentsDue()
    End Sub

    Private Sub OnExportCSV(sender As Object, e As EventArgs)
        Try
            Dim saveDialog As New SaveFileDialog With {
                .Filter = "CSV files (*.csv)|*.csv",
                .FileName = $"PaymentSchedule_{DateTime.Now:yyyyMMdd}.csv"
            }
            
            If saveDialog.ShowDialog() = DialogResult.OK Then
                ExportToCSV(saveDialog.FileName)
                MessageBox.Show($"Payment schedule exported to: {saveDialog.FileName}", "Export Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
            
        Catch ex As Exception
            MessageBox.Show($"Error exporting CSV: {ex.Message}", "Export Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ExportToCSV(fileName As String)
        Using writer As New StreamWriter(fileName)
            ' CSV Header - Bank-friendly format
            writer.WriteLine("Payment Type,Reference,Payee Name,Amount,Due Date,Days Overdue,Bank Name,Branch Code,Account Number,Description,Payment Reference")
            
            For Each row As DataGridViewRow In dgvPayments.Rows
                If Not row.IsNewRow Then
                    Dim paymentRef As String = $"{row.Cells("PaymentType").Value}_{row.Cells("Reference").Value}_{DateTime.Now:yyyyMMdd}"
                    
                    writer.WriteLine($"{row.Cells("PaymentType").Value}," &
                                   $"{row.Cells("Reference").Value}," &
                                   $"""{row.Cells("Payee").Value}""," &
                                   $"{row.Cells("Amount").Value}," &
                                   $"{Convert.ToDateTime(row.Cells("DueDate").Value):yyyy-MM-dd}," &
                                   $"{row.Cells("DaysOverdue").Value}," &
                                   $"""{row.Cells("BankName").Value}""," &
                                   $"{row.Cells("BankBranch").Value}," &
                                   $"{row.Cells("BankAccount").Value}," &
                                   $"""{row.Cells("Description").Value}""," &
                                   $"{paymentRef}")
                End If
            Next
        End Using
    End Sub

    Private Sub OnMarkPaid(sender As Object, e As EventArgs)
        If dgvPayments.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select payments to mark as paid.", "No Selection", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim paymentDialog As New PaymentConfirmationDialog()
        If paymentDialog.ShowDialog() = DialogResult.OK Then
            Try
                For Each row As DataGridViewRow In dgvPayments.SelectedRows
                    Dim paymentType As String = row.Cells("PaymentType").Value.ToString()
                    Dim referenceId As Integer = Convert.ToInt32(row.Cells("ReferenceID").Value)
                    Dim amount As Decimal = Convert.ToDecimal(row.Cells("Amount").Value)
                    
                    paymentService.MarkPaymentProcessed(paymentType, referenceId, paymentDialog.BankReference, amount, paymentDialog.PaymentDate)
                Next
                
                MessageBox.Show($"{dgvPayments.SelectedRows.Count} payments marked as paid.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                LoadPaymentsDue()
                
            Catch ex As Exception
                MessageBox.Show($"Error marking payments as paid: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

End Class

Public Class PaymentConfirmationDialog
    Inherits Form
    
    Public Property PaymentDate As Date
    Public Property BankReference As String
    
    Private dtpPaymentDate As DateTimePicker
    Private txtBankRef As TextBox
    Private btnOK As Button
    Private btnCancel As Button
    
    Public Sub New()
        Me.Text = "Confirm Payment Details"
        Me.Size = New Size(400, 200)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        
        InitializeControls()
        PaymentDate = DateTime.Today
    End Sub
    
    Private Sub InitializeControls()
        Dim lblDate As New Label With {
            .Text = "Payment Date:",
            .Location = New Point(20, 30),
            .Size = New Size(100, 20)
        }
        
        dtpPaymentDate = New DateTimePicker With {
            .Location = New Point(130, 27),
            .Size = New Size(200, 25),
            .Value = DateTime.Today
        }
        
        Dim lblRef As New Label With {
            .Text = "Bank Reference:",
            .Location = New Point(20, 70),
            .Size = New Size(100, 20)
        }
        
        txtBankRef = New TextBox With {
            .Location = New Point(130, 67),
            .Size = New Size(200, 25)
        }
        
        btnOK = New Button With {
            .Text = "OK",
            .Location = New Point(200, 120),
            .Size = New Size(75, 30),
            .DialogResult = DialogResult.OK
        }
        
        btnCancel = New Button With {
            .Text = "Cancel",
            .Location = New Point(285, 120),
            .Size = New Size(75, 30),
            .DialogResult = DialogResult.Cancel
        }
        
        Me.Controls.AddRange({lblDate, dtpPaymentDate, lblRef, txtBankRef, btnOK, btnCancel})
        
        AddHandler btnOK.Click, AddressOf OnOK
    End Sub
    
    Private Sub OnOK(sender As Object, e As EventArgs)
        PaymentDate = dtpPaymentDate.Value
        BankReference = txtBankRef.Text.Trim()
        
        If String.IsNullOrEmpty(BankReference) Then
            MessageBox.Show("Please enter a bank reference.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtBankRef.Focus()
            Return
        End If
        
        Me.DialogResult = DialogResult.OK
        Me.Close()
    End Sub
    
End Class
