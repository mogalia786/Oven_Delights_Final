Imports System.Windows.Forms
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.ComponentModel

Public Class AccountsPayableInvoiceForm
    Private currentUser As User
    Private invoiceId As Integer = 0
    Private isEditMode As Boolean = False

    Public Sub New()
        MyBase.New()
        InitializeComponent()
        Me.SetStyle(ControlStyles.AllPaintingInWmPaint Or ControlStyles.UserPaint Or ControlStyles.DoubleBuffer, True)
        Me.WindowState = FormWindowState.Normal
        Me.Visible = True
        Me.Size = New Size(600, 550)
    End Sub

    Public Sub New(user As User)
        MyBase.New()
        InitializeComponent()
        currentUser = user
        Me.SetStyle(ControlStyles.AllPaintingInWmPaint Or ControlStyles.UserPaint Or ControlStyles.DoubleBuffer, True)
        Me.WindowState = FormWindowState.Normal
        Me.Visible = True
        Me.Size = New Size(600, 550)
    End Sub

    Public Sub New(user As User, invoiceIdToEdit As Integer)
        MyBase.New()
        InitializeComponent()
        currentUser = user
        invoiceId = invoiceIdToEdit
        isEditMode = True
        Me.SetStyle(ControlStyles.AllPaintingInWmPaint Or ControlStyles.UserPaint Or ControlStyles.DoubleBuffer, True)
        Me.WindowState = FormWindowState.Normal
        Me.Visible = True
        Me.Size = New Size(600, 550)
    End Sub

    Private Sub AccountsPayableInvoiceForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            ' Force form to be visible and on top
            Me.WindowState = FormWindowState.Normal
            Me.TopMost = True
            Me.Show()
            Me.BringToFront()
            Me.Focus()
            
            ' Initialize form data
            SetupForm()
            
            ' Load data without database calls that might fail
            Try
                LoadSuppliers()
            Catch ex As Exception
                MessageBox.Show($"Warning: Could not load suppliers: {ex.Message}", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                ' Add dummy supplier for testing
                cmbSupplier.Items.Add(New ComboBoxItem("Test Supplier", 1))
            End Try
            
            Try
                LoadGLAccounts()
            Catch ex As Exception
                MessageBox.Show($"Warning: Could not load GL accounts: {ex.Message}", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                ' Add dummy GL account for testing
                cmbGLAccount.Items.Add(New ComboBoxItem("Test Account", "TEST"))
            End Try
            
            If isEditMode AndAlso invoiceId > 0 Then
                LoadInvoiceForEdit()
            Else
                SetupNewInvoice()
            End If
            
            Me.TopMost = False
            Me.Refresh()
            
        Catch ex As Exception
            MessageBox.Show($"Critical error loading form: {ex.Message}{vbCrLf}{ex.StackTrace}", "Critical Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SetupForm()
        Me.Text = If(isEditMode, "Edit Invoice", "New Invoice")
        dtpInvoiceDate.Value = DateTime.Today
        dtpDueDate.Value = DateTime.Today.AddDays(30)
        txtInvoiceNumber.Focus()
    End Sub

    Private Sub SetupNewInvoice()
        txtInvoiceNumber.Text = GenerateInvoiceNumber()
        txtAmount.Text = "0.00"
        txtDescription.Text = ""
        chkPaid.Checked = False
        dtpPaidDate.Enabled = False
    End Sub

    Private Function GenerateInvoiceNumber() As String
        Try
            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New SqlCommand("SELECT ISNULL(MAX(CAST(SUBSTRING(InvoiceNumber, 4, LEN(InvoiceNumber)) AS INT)), 0) + 1 FROM APInvoices WHERE InvoiceNumber LIKE 'INV%'", conn)
                Dim nextNum As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                Return $"INV{nextNum:D6}"
            End Using
        Catch
            Return $"INV{DateTime.Now:yyyyMMddHHmmss}"
        End Try
    End Function

    Private Sub LoadSuppliers()
        Try
            cmbSupplier.Items.Clear()
            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New SqlCommand("SELECT SupplierID, CompanyName FROM Suppliers WHERE IsActive = 1 ORDER BY CompanyName", conn)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        cmbSupplier.Items.Add(New ComboBoxItem(reader("CompanyName").ToString(), reader("SupplierID")))
                    End While
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub LoadGLAccounts()
        Try
            cmbGLAccount.Items.Clear()
            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New SqlCommand("SELECT AccountCode, AccountName FROM GLAccounts WHERE IsActive = 1 AND AccountType IN ('Expense', 'Asset') ORDER BY AccountCode", conn)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim displayText = $"{reader("AccountCode")} - {reader("AccountName")}"
                        cmbGLAccount.Items.Add(New ComboBoxItem(displayText, reader("AccountCode").ToString()))
                    End While
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading GL accounts: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub LoadInvoiceForEdit()
        Try
            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()
                Dim cmd As New SqlCommand("SELECT * FROM APInvoices WHERE InvoiceID = @InvoiceID", conn)
                cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtInvoiceNumber.Text = reader("InvoiceNumber").ToString()
                        SelectComboBoxItem(cmbSupplier, reader("SupplierID"))
                        SelectComboBoxItem(cmbGLAccount, reader("GLAccountCode").ToString())
                        dtpInvoiceDate.Value = Convert.ToDateTime(reader("InvoiceDate"))
                        dtpDueDate.Value = Convert.ToDateTime(reader("DueDate"))
                        txtAmount.Text = Convert.ToDecimal(reader("Amount")).ToString("F2")
                        txtDescription.Text = reader("Description").ToString()
                        chkPaid.Checked = Convert.ToBoolean(reader("IsPaid"))
                        
                        If Not IsDBNull(reader("PaidDate")) Then
                            dtpPaidDate.Value = Convert.ToDateTime(reader("PaidDate"))
                            dtpPaidDate.Enabled = True
                        End If
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SelectComboBoxItem(combo As ComboBox, value As Object)
        For i As Integer = 0 To combo.Items.Count - 1
            Dim item As ComboBoxItem = TryCast(combo.Items(i), ComboBoxItem)
            If item IsNot Nothing AndAlso item.Value.ToString() = value.ToString() Then
                combo.SelectedIndex = i
                Exit For
            End If
        Next
    End Sub

    Private Sub chkPaid_CheckedChanged(sender As Object, e As EventArgs) Handles chkPaid.CheckedChanged
        dtpPaidDate.Enabled = chkPaid.Checked
        If chkPaid.Checked AndAlso dtpPaidDate.Value = DateTime.MinValue Then
            dtpPaidDate.Value = DateTime.Today
        End If
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If ValidateForm() Then
            SaveInvoice()
        End If
    End Sub

    Private Function ValidateForm() As Boolean
        If String.IsNullOrWhiteSpace(txtInvoiceNumber.Text) Then
            MessageBox.Show("Invoice number is required.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtInvoiceNumber.Focus()
            Return False
        End If

        If cmbSupplier.SelectedItem Is Nothing Then
            MessageBox.Show("Please select a supplier.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            cmbSupplier.Focus()
            Return False
        End If

        If cmbGLAccount.SelectedItem Is Nothing Then
            MessageBox.Show("Please select a GL account.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            cmbGLAccount.Focus()
            Return False
        End If

        Dim amount As Decimal
        If Not Decimal.TryParse(txtAmount.Text, amount) OrElse amount <= 0 Then
            MessageBox.Show("Please enter a valid amount greater than zero.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtAmount.Focus()
            Return False
        End If

        If dtpDueDate.Value < dtpInvoiceDate.Value Then
            MessageBox.Show("Due date cannot be earlier than invoice date.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            dtpDueDate.Focus()
            Return False
        End If

        Return True
    End Function

    Private Sub SaveInvoice()
        Try
            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()
                Using trans As SqlTransaction = conn.BeginTransaction()
                    Try
                        Dim sql As String
                        Dim cmd As SqlCommand

                        If isEditMode Then
                            sql = "UPDATE APInvoices SET InvoiceNumber = @InvoiceNumber, SupplierID = @SupplierID, " &
                                  "GLAccountCode = @GLAccountCode, InvoiceDate = @InvoiceDate, DueDate = @DueDate, " &
                                  "Amount = @Amount, Description = @Description, IsPaid = @IsPaid, PaidDate = @PaidDate, " &
                                  "ModifiedBy = @ModifiedBy, ModifiedDate = @ModifiedDate WHERE InvoiceID = @InvoiceID"
                        Else
                            sql = "INSERT INTO APInvoices (InvoiceNumber, SupplierID, GLAccountCode, InvoiceDate, DueDate, " &
                                  "Amount, Description, IsPaid, PaidDate, CreatedBy, CreatedDate) " &
                                  "VALUES (@InvoiceNumber, @SupplierID, @GLAccountCode, @InvoiceDate, @DueDate, " &
                                  "@Amount, @Description, @IsPaid, @PaidDate, @CreatedBy, @CreatedDate)"
                        End If

                        cmd = New SqlCommand(sql, conn, trans)
                        
                        cmd.Parameters.AddWithValue("@InvoiceNumber", txtInvoiceNumber.Text.Trim())
                        cmd.Parameters.AddWithValue("@SupplierID", DirectCast(cmbSupplier.SelectedItem, ComboBoxItem).Value)
                        cmd.Parameters.AddWithValue("@GLAccountCode", DirectCast(cmbGLAccount.SelectedItem, ComboBoxItem).Value)
                        cmd.Parameters.AddWithValue("@InvoiceDate", dtpInvoiceDate.Value.Date)
                        cmd.Parameters.AddWithValue("@DueDate", dtpDueDate.Value.Date)
                        cmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtAmount.Text))
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim())
                        cmd.Parameters.AddWithValue("@IsPaid", chkPaid.Checked)
                        cmd.Parameters.AddWithValue("@PaidDate", If(chkPaid.Checked, dtpPaidDate.Value.Date, DBNull.Value))

                        If isEditMode Then
                            cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                            cmd.Parameters.AddWithValue("@ModifiedBy", currentUser.UserID)
                            cmd.Parameters.AddWithValue("@ModifiedDate", DateTime.Now)
                        Else
                            cmd.Parameters.AddWithValue("@CreatedBy", currentUser.UserID)
                            cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now)
                        End If

                        cmd.ExecuteNonQuery()
                        trans.Commit()

                        MessageBox.Show($"Invoice {If(isEditMode, "updated", "created")} successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Me.DialogResult = DialogResult.OK
                        Me.Close()

                    Catch ex As Exception
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error saving invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
        Me.Close()
    End Sub

    Private Function GetConnectionString() As String
        Return ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    End Function

    Public Class ComboBoxItem
        Public Property Text As String
        Public Property Value As Object

        Public Sub New(text As String, value As Object)
            Me.Text = text
            Me.Value = value
        End Sub

        Public Overrides Function ToString() As String
            Return Text
        End Function
    End Class
End Class
