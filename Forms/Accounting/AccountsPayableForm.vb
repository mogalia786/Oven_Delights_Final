Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms

Namespace Forms.Accounting
    Public Class AccountsPayableForm
        Inherits Form

        Private dgvPayables As DataGridView
        Private btnAddPayable As Button
        Private btnEditPayable As Button
        Private btnDeletePayable As Button
        Private btnProcessPayment As Button
        Private WithEvents txtSearch As TextBox
        Private lblSearch As Label
        Private _connectionString As String

        Public Sub New()
            InitializeComponent()
            _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
            LoadPayables()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Accounts Payable Management"
            Me.Size = New Size(1000, 600)
            Me.WindowState = FormWindowState.Maximized

            ' Search controls
            lblSearch = New Label() With {
                .Text = "Search:",
                .Location = New Point(10, 15),
                .Size = New Size(50, 20)
            }

            txtSearch = New TextBox() With {
                .Location = New Point(70, 12),
                .Size = New Size(200, 25)
            }

            ' Buttons
            btnAddPayable = New Button() With {
                .Text = "Add Payable",
                .Location = New Point(300, 10),
                .Size = New Size(100, 30)
            }
            AddHandler btnAddPayable.Click, AddressOf btnAddPayable_Click

            btnEditPayable = New Button() With {
                .Text = "Edit Payable",
                .Location = New Point(410, 10),
                .Size = New Size(100, 30)
            }
            AddHandler btnEditPayable.Click, AddressOf btnEditPayable_Click

            btnDeletePayable = New Button() With {
                .Text = "Delete Payable",
                .Location = New Point(520, 10),
                .Size = New Size(100, 30)
            }
            AddHandler btnDeletePayable.Click, AddressOf btnDeletePayable_Click

            btnProcessPayment = New Button() With {
                .Text = "Process Payment",
                .Location = New Point(630, 10),
                .Size = New Size(120, 30)
            }
            AddHandler btnProcessPayment.Click, AddressOf btnProcessPayment_Click

            ' DataGridView
            dgvPayables = New DataGridView() With {
                .Location = New Point(10, 50),
                .Size = New Size(Me.ClientSize.Width - 20, Me.ClientSize.Height - 60),
                .Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .MultiSelect = False,
                .ReadOnly = True
            }

            ' Add controls to form
            Me.Controls.AddRange({lblSearch, txtSearch, btnAddPayable, btnEditPayable, btnDeletePayable, btnProcessPayment, dgvPayables})
        End Sub

        Private Sub LoadPayables()
            Try
                Using conn As New SqlConnection(_connectionString)
                    Dim sql = "SELECT 
                                ap.PayableID,
                                ap.SupplierName,
                                ap.InvoiceNumber,
                                ap.InvoiceDate,
                                ap.DueDate,
                                ap.Amount,
                                ap.AmountPaid,
                                (ap.Amount - ap.AmountPaid) AS Outstanding,
                                ap.Status,
                                ap.Description
                               FROM AccountsPayable ap
                               ORDER BY ap.DueDate ASC"

                    Using adapter As New SqlDataAdapter(sql, conn)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        dgvPayables.DataSource = dt

                        ' Format columns
                        If dgvPayables.Columns.Contains("Amount") Then
                            dgvPayables.Columns("Amount").DefaultCellStyle.Format = "C2"
                        End If
                        If dgvPayables.Columns.Contains("AmountPaid") Then
                            dgvPayables.Columns("AmountPaid").DefaultCellStyle.Format = "C2"
                        End If
                        If dgvPayables.Columns.Contains("Outstanding") Then
                            dgvPayables.Columns("Outstanding").DefaultCellStyle.Format = "C2"
                        End If
                        If dgvPayables.Columns.Contains("InvoiceDate") Then
                            dgvPayables.Columns("InvoiceDate").DefaultCellStyle.Format = "d"
                        End If
                        If dgvPayables.Columns.Contains("DueDate") Then
                            dgvPayables.Columns("DueDate").DefaultCellStyle.Format = "d"
                        End If
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Error loading payables: " & ex.Message, "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub txtSearch_TextChanged(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtSearch.Text) Then
                LoadPayables()
                Return
            End If

            Try
                Using conn As New SqlConnection(_connectionString)
                    Dim sql = "SELECT 
                                ap.PayableID,
                                ap.SupplierName,
                                ap.InvoiceNumber,
                                ap.InvoiceDate,
                                ap.DueDate,
                                ap.Amount,
                                ap.AmountPaid,
                                (ap.Amount - ap.AmountPaid) AS Outstanding,
                                ap.Status,
                                ap.Description
                               FROM AccountsPayable ap
                               WHERE ap.SupplierName LIKE @search 
                                  OR ap.InvoiceNumber LIKE @search
                                  OR ap.Description LIKE @search
                               ORDER BY ap.DueDate ASC"

                    Using adapter As New SqlDataAdapter(sql, conn)
                        adapter.SelectCommand.Parameters.AddWithValue("@search", "%" & txtSearch.Text & "%")
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        dgvPayables.DataSource = dt
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show("Error searching payables: " & ex.Message, "Search Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnAddPayable_Click(sender As Object, e As EventArgs)
            Try
                Dim frm As New TestInvoiceForm()
                frm.MdiParent = Me.MdiParent
                frm.Show()
                frm.WindowState = FormWindowState.Maximized
                frm.BringToFront()
            Catch ex As Exception
                MessageBox.Show($"Error opening invoice form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnEditPayable_Click(sender As Object, e As EventArgs)
            If dgvPayables.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a payable to edit.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Dim invoiceId As Integer = Convert.ToInt32(dgvPayables.SelectedRows(0).Cells("PayableID").Value)
                Dim frm As New AccountsPayableInvoiceForm(currentUser, invoiceId)
                frm.Show()
                frm.BringToFront()
            Catch ex As Exception
                MessageBox.Show($"Error opening invoice form: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnDeletePayable_Click(sender As Object, e As EventArgs)
            If dgvPayables.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a payable to delete.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Dim invoiceNumber As String = dgvPayables.SelectedRows(0).Cells("InvoiceNumber").Value.ToString()
                Dim result As DialogResult = MessageBox.Show($"Are you sure you want to delete invoice {invoiceNumber}?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
                
                If result = DialogResult.Yes Then
                    Dim invoiceId As Integer = Convert.ToInt32(dgvPayables.SelectedRows(0).Cells("InvoiceID").Value)
                    DeleteInvoice(invoiceId)
                End If
            Catch ex As Exception
                MessageBox.Show($"Error deleting invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub btnProcessPayment_Click(sender As Object, e As EventArgs)
            If dgvPayables.SelectedRows.Count = 0 Then
                MessageBox.Show("Please select a payable to process payment for.", "Selection Required", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            MessageBox.Show("Process Payment functionality to be implemented.", "Feature", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Sub

        Private Sub DeleteInvoice(invoiceId As Integer)
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    Dim cmd As New SqlCommand("DELETE FROM APInvoices WHERE InvoiceID = @InvoiceID", conn)
                    cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                    cmd.ExecuteNonQuery()
                    ' ' LoadInvoices()
                    MessageBox.Show("Invoice deleted successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error deleting invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub MarkInvoiceAsPaid(invoiceId As Integer)
            Try
                Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                    conn.Open()
                    Dim cmd As New SqlCommand("UPDATE APInvoices SET IsPaid = 1, PaidDate = @PaidDate WHERE InvoiceID = @InvoiceID", conn)
                    cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                    cmd.Parameters.AddWithValue("@PaidDate", DateTime.Today)
                    cmd.ExecuteNonQuery()
                End Using
            Catch ex As Exception
                Throw New Exception($"Failed to mark invoice as paid: {ex.Message}")
            End Try
        End Sub
    End Class
End Namespace
