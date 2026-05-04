Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Windows.Forms
Imports System.Drawing

Public Class SupplierAddEditForm
    Inherits Form

    Private ReadOnly _connString As String
    Private ReadOnly _supplierId As Integer?
    Private ReadOnly _isEditMode As Boolean
    Private ReadOnly stockroomService As New StockroomService()

    Public Sub New(Optional supplierId As Integer? = Nothing)
        _supplierId = supplierId
        _isEditMode = supplierId.HasValue
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        InitializeComponent()
        SetupForm()
        If _isEditMode Then LoadSupplierData()
    End Sub

    Private Sub SetupForm()
        Me.Text = If(_isEditMode, "Edit Supplier", "New Supplier")
        Me.Size = New Size(900, 750)
        Me.StartPosition = FormStartPosition.CenterParent
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.BackColor = Color.White
        Me.AutoScroll = True

        ' Header Panel
        Dim pnlHeader As New Panel() With {
            .Dock = DockStyle.Top,
            .Height = 60,
            .BackColor = Color.FromArgb(52, 152, 219)
        }
        Dim lblTitle As New Label() With {
            .Text = If(_isEditMode, "Edit Supplier", "New Supplier"),
            .Font = New Font("Segoe UI", 16, FontStyle.Bold),
            .ForeColor = Color.White,
            .AutoSize = True,
            .Location = New Point(20, 15)
        }
        pnlHeader.Controls.Add(lblTitle)
        Me.Controls.Add(pnlHeader)

        ' Main Panel with scroll
        Dim pnlMain As New Panel() With {
            .Location = New Point(0, 60),
            .Size = New Size(880, 600),
            .AutoScroll = True,
            .BackColor = Color.White
        }

        Dim yPos = 20
        Dim leftCol = 20
        Dim rightCol = 450
        Dim labelWidth = 140
        Dim textWidth = 250

        ' Company Information Section
        Dim lblSection1 As New Label() With {
            .Text = "Company Information",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 152, 219),
            .Location = New Point(leftCol, yPos),
            .AutoSize = True
        }
        pnlMain.Controls.Add(lblSection1)
        yPos += 35

        ' Company Name (Required)
        AddLabel(pnlMain, "Company Name: *", leftCol, yPos)
        txtCompanyName = AddTextBox(pnlMain, leftCol + labelWidth, yPos, 400)
        yPos += 30

        ' Supplier Code
        AddLabel(pnlMain, "Supplier Code:", leftCol, yPos)
        txtSupplierCode = AddTextBox(pnlMain, leftCol + labelWidth, yPos, 150)
        yPos += 30

        ' VAT Number
        AddLabel(pnlMain, "VAT Number:", leftCol, yPos)
        txtVATNumber = AddTextBox(pnlMain, leftCol + labelWidth, yPos, 150)
        yPos += 40

        ' Contact Information Section
        Dim lblSection2 As New Label() With {
            .Text = "Contact Information",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 152, 219),
            .Location = New Point(leftCol, yPos),
            .AutoSize = True
        }
        pnlMain.Controls.Add(lblSection2)
        yPos += 35

        ' Contact Person
        AddLabel(pnlMain, "Contact Person:", leftCol, yPos)
        txtContactPerson = AddTextBox(pnlMain, leftCol + labelWidth, yPos)
        yPos += 30

        ' Email
        AddLabel(pnlMain, "Email:", leftCol, yPos)
        txtEmail = AddTextBox(pnlMain, leftCol + labelWidth, yPos)
        yPos += 30

        ' Phone
        AddLabel(pnlMain, "Phone:", leftCol, yPos)
        txtPhone = AddTextBox(pnlMain, leftCol + labelWidth, yPos, 150)
        
        AddLabel(pnlMain, "Mobile:", rightCol, yPos)
        txtMobile = AddTextBox(pnlMain, rightCol + 80, yPos, 150)
        yPos += 40

        ' Address Section
        Dim lblSection3 As New Label() With {
            .Text = "Address Information",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 152, 219),
            .Location = New Point(leftCol, yPos),
            .AutoSize = True
        }
        pnlMain.Controls.Add(lblSection3)
        yPos += 35

        ' Address
        AddLabel(pnlMain, "Address:", leftCol, yPos)
        txtAddress = AddTextBox(pnlMain, leftCol + labelWidth, yPos, 500)
        yPos += 30

        ' City
        AddLabel(pnlMain, "City:", leftCol, yPos)
        txtCity = AddTextBox(pnlMain, leftCol + labelWidth, yPos, 150)
        
        AddLabel(pnlMain, "Province:", rightCol, yPos)
        txtProvince = AddTextBox(pnlMain, rightCol + 80, yPos, 150)
        yPos += 30

        ' Postal Code
        AddLabel(pnlMain, "Postal Code:", leftCol, yPos)
        txtPostalCode = AddTextBox(pnlMain, leftCol + labelWidth, yPos, 100)
        
        AddLabel(pnlMain, "Country:", rightCol, yPos)
        txtCountry = AddTextBox(pnlMain, rightCol + 80, yPos, 150)
        yPos += 40

        ' Banking Information Section
        Dim lblSection4 As New Label() With {
            .Text = "Banking Information",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 152, 219),
            .Location = New Point(leftCol, yPos),
            .AutoSize = True
        }
        pnlMain.Controls.Add(lblSection4)
        yPos += 35

        ' Bank Name (Required)
        AddLabel(pnlMain, "Bank Name: *", leftCol, yPos)
        txtBankName = AddTextBox(pnlMain, leftCol + labelWidth, yPos)
        yPos += 30

        ' Branch Code (Required)
        AddLabel(pnlMain, "Branch Code: *", leftCol, yPos)
        txtBranchCode = AddTextBox(pnlMain, leftCol + labelWidth, yPos, 150)
        yPos += 30

        ' Account Number (Required)
        AddLabel(pnlMain, "Account Number: *", leftCol, yPos)
        txtAccountNumber = AddTextBox(pnlMain, leftCol + labelWidth, yPos)
        yPos += 30

        ' Account Type
        AddLabel(pnlMain, "Account Type:", leftCol, yPos)
        cboAccountType = New ComboBox() With {
            .Location = New Point(leftCol + labelWidth, yPos - 3),
            .Width = 150,
            .DropDownStyle = ComboBoxStyle.DropDownList
        }
        cboAccountType.Items.AddRange({"Cheque", "Savings", "Transmission"})
        cboAccountType.SelectedIndex = 0
        pnlMain.Controls.Add(cboAccountType)
        yPos += 30
        
        ' Proof of Payment Email
        AddLabel(pnlMain, "Proof Payment Email:", leftCol, yPos)
        txtProofOfPaymentEmail = AddTextBox(pnlMain, leftCol + labelWidth, yPos)
        yPos += 40

        ' Payment Terms Section
        Dim lblSection5 As New Label() With {
            .Text = "Payment Terms",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 152, 219),
            .Location = New Point(leftCol, yPos),
            .AutoSize = True
        }
        pnlMain.Controls.Add(lblSection5)
        yPos += 35

        ' Payment Terms
        AddLabel(pnlMain, "Payment Terms:", leftCol, yPos)
        txtPaymentTerms = AddTextBox(pnlMain, leftCol + labelWidth, yPos)
        yPos += 30

        ' Payment Days
        AddLabel(pnlMain, "Payment Days:", leftCol, yPos)
        txtPaymentTermsDays = AddTextBox(pnlMain, leftCol + labelWidth, yPos, 100)
        
        AddLabel(pnlMain, "Credit Limit:", rightCol, yPos)
        txtCreditLimit = AddTextBox(pnlMain, rightCol + 80, yPos, 150)
        yPos += 40

        ' Additional Information Section
        Dim lblSection6 As New Label() With {
            .Text = "Additional Information",
            .Font = New Font("Segoe UI", 11, FontStyle.Bold),
            .ForeColor = Color.FromArgb(52, 152, 219),
            .Location = New Point(leftCol, yPos),
            .AutoSize = True
        }
        pnlMain.Controls.Add(lblSection6)
        yPos += 35

        ' Notes
        AddLabel(pnlMain, "Notes:", leftCol, yPos)
        txtNotes = New TextBox() With {
            .Location = New Point(leftCol + labelWidth, yPos - 3),
            .Width = 500,
            .Height = 60,
            .Multiline = True,
            .ScrollBars = ScrollBars.Vertical
        }
        pnlMain.Controls.Add(txtNotes)
        yPos += 70

        ' Active Checkbox
        chkIsActive = New CheckBox() With {
            .Text = "Active",
            .Location = New Point(leftCol, yPos),
            .Checked = True,
            .AutoSize = True
        }
        pnlMain.Controls.Add(chkIsActive)
        yPos += 40

        Me.Controls.Add(pnlMain)

        ' Button Panel
        Dim pnlButtons As New Panel() With {
            .Dock = DockStyle.Bottom,
            .Height = 60,
            .BackColor = Color.FromArgb(236, 240, 241)
        }

        btnSave = New Button() With {
            .Text = If(_isEditMode, "Update", "Save"),
            .Location = New Point(480, 12),
            .Size = New Size(100, 35),
            .BackColor = Color.FromArgb(46, 204, 113),
            .ForeColor = Color.White,
            .FlatStyle = FlatStyle.Flat,
            .Cursor = Cursors.Hand,
            .Font = New Font("Segoe UI", 9, FontStyle.Bold)
        }
        AddHandler btnSave.Click, AddressOf btnSave_Click
        pnlButtons.Controls.Add(btnSave)

        btnCancel = New Button() With {
            .Text = "Cancel",
            .Location = New Point(590, 12),
            .Size = New Size(80, 35),
            .DialogResult = DialogResult.Cancel,
            .Cursor = Cursors.Hand
        }
        pnlButtons.Controls.Add(btnCancel)

        Me.Controls.Add(pnlButtons)
    End Sub

    Private Function AddLabel(panel As Panel, text As String, x As Integer, y As Integer) As Label
        Dim lbl As New Label() With {
            .Text = text,
            .Location = New Point(x, y),
            .AutoSize = True,
            .Font = New Font("Segoe UI", 9)
        }
        panel.Controls.Add(lbl)
        Return lbl
    End Function

    Private Function AddTextBox(panel As Panel, x As Integer, y As Integer, Optional width As Integer = 250) As TextBox
        Dim txt As New TextBox() With {
            .Location = New Point(x, y - 3),
            .Width = width
        }
        panel.Controls.Add(txt)
        Return txt
    End Function

    Private Sub LoadSupplierData()
        Try
            Using conn As New SqlConnection(_connString)
                Dim sql = "SELECT * FROM Suppliers WHERE SupplierID = @supplierId"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@supplierId", _supplierId.Value)
                    conn.Open()
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            ' Helper function to safely get string value
                            Dim GetString = Function(fieldName As String) If(IsDBNull(reader(fieldName)), "", reader(fieldName).ToString())
                            Dim GetInt = Function(fieldName As String) If(IsDBNull(reader(fieldName)), 0, Convert.ToInt32(reader(fieldName)))
                            Dim GetDecimal = Function(fieldName As String) If(IsDBNull(reader(fieldName)), 0D, Convert.ToDecimal(reader(fieldName)))
                            
                            ' Required fields
                            txtCompanyName.Text = GetString("CompanyName")
                            txtBankName.Text = GetString("BankName")
                            txtBranchCode.Text = GetString("BranchCode")
                            txtAccountNumber.Text = GetString("AccountNumber")
                            
                            ' Optional fields
                            txtContactPerson.Text = GetString("ContactPerson")
                            txtEmail.Text = GetString("Email")
                            txtPhone.Text = GetString("Phone")
                            txtMobile.Text = GetString("Mobile")
                            txtAddress.Text = GetString("Address")
                            txtCity.Text = GetString("City")
                            txtProvince.Text = GetString("Province")
                            txtPostalCode.Text = GetString("PostalCode")
                            txtCountry.Text = GetString("Country")
                            txtVATNumber.Text = GetString("VATNumber")
                            txtSupplierCode.Text = GetString("SupplierCode")
                            txtProofOfPaymentEmail.Text = GetString("ProofOfPaymentEmail")
                            txtPaymentTerms.Text = GetString("PaymentTerms")
                            txtNotes.Text = GetString("Notes")
                            
                            ' Numeric fields
                            Dim paymentDays = GetInt("PaymentTermsDays")
                            If paymentDays > 0 Then txtPaymentTermsDays.Text = paymentDays.ToString()
                            
                            Dim creditLimit = GetDecimal("CreditLimit")
                            If creditLimit > 0 Then txtCreditLimit.Text = creditLimit.ToString("N2")
                            
                            ' Account Type
                            Dim accountType = GetString("BankAccountType")
                            If Not String.IsNullOrEmpty(accountType) Then
                                Dim index = cboAccountType.FindStringExact(accountType)
                                If index >= 0 Then cboAccountType.SelectedIndex = index
                            End If
                            
                            ' Active checkbox
                            chkIsActive.Checked = If(IsDBNull(reader("IsActive")), True, Convert.ToBoolean(reader("IsActive")))
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error loading supplier data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Try
            If Not ValidateInput() Then Return

            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                ' Set QUOTED_IDENTIFIER ON for the connection
                Using setCmd As New SqlCommand("SET QUOTED_IDENTIFIER ON; SET ANSI_NULLS ON;", conn)
                    setCmd.ExecuteNonQuery()
                End Using
                
                ' Start transaction
                Using transaction = conn.BeginTransaction()
                    Try
                        If _isEditMode Then
                            UpdateSupplier(conn, transaction)
                            MessageBox.Show("Supplier updated successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Else
                            ' Check if supplier already exists
                            If SupplierExists(conn, transaction, txtCompanyName.Text.Trim()) Then
                                MessageBox.Show("A supplier with this company name already exists.", "Duplicate Supplier", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                Return
                            End If
                            
                            CreateSupplier(conn, transaction)
                            MessageBox.Show("Supplier created successfully and Chart of Accounts entry added", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        End If
                        
                        transaction.Commit()
                        Me.DialogResult = DialogResult.OK
                        Me.Close()
                    Catch ex As Exception
                        transaction.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error saving supplier: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function ValidateInput() As Boolean
        ' Company Name is required
        If String.IsNullOrWhiteSpace(txtCompanyName.Text) Then
            MessageBox.Show("Please enter a company name.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtCompanyName.Focus()
            Return False
        End If

        ' Bank details are required
        If String.IsNullOrWhiteSpace(txtBankName.Text) Then
            MessageBox.Show("Please enter a bank name.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtBankName.Focus()
            Return False
        End If

        If String.IsNullOrWhiteSpace(txtBranchCode.Text) Then
            MessageBox.Show("Please enter a branch code.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtBranchCode.Focus()
            Return False
        End If

        If String.IsNullOrWhiteSpace(txtAccountNumber.Text) Then
            MessageBox.Show("Please enter an account number.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtAccountNumber.Focus()
            Return False
        End If

        ' Email validation (if provided)
        If Not String.IsNullOrWhiteSpace(txtEmail.Text) AndAlso Not txtEmail.Text.Contains("@") Then
            MessageBox.Show("Please enter a valid email address.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            txtEmail.Focus()
            Return False
        End If

        Return True
    End Function

    Private Function SupplierExists(conn As SqlConnection, transaction As SqlTransaction, companyName As String) As Boolean
        Dim sql = "SELECT COUNT(*) FROM Suppliers WHERE UPPER(CompanyName) = UPPER(@CompanyName) AND IsActive = 1"
        Using cmd As New SqlCommand(sql, conn, transaction)
            cmd.Parameters.AddWithValue("@CompanyName", companyName)
            Return Convert.ToInt32(cmd.ExecuteScalar()) > 0
        End Using
    End Function

    Private Sub CreateSupplier(conn As SqlConnection, transaction As SqlTransaction)
        Dim newSupplierId As Integer
        
        ' Insert supplier
        Dim insertSql = "INSERT INTO Suppliers (CompanyName, ContactPerson, Email, Phone, Mobile, " &
                       "City, Province, PostalCode, Country, VATNumber, PaymentTermsDays, CreditLimit, Address, " &
                       "BankName, BranchCode, AccountNumber, PaymentTerms, Notes, SupplierCode, " &
                       "BankAccountType, ProofOfPaymentEmail, IsActive, CreatedDate, CreatedBy) " &
                       "VALUES (@CompanyName, @ContactPerson, @Email, @Phone, @Mobile, " &
                       "@City, @Province, @PostalCode, @Country, @VATNumber, @PaymentTermsDays, @CreditLimit, @Address, " &
                       "@BankName, @BranchCode, @AccountNumber, @PaymentTerms, @Notes, @SupplierCode, " &
                       "@BankAccountType, @ProofOfPaymentEmail, @IsActive, GETDATE(), @CreatedBy)"
        
        Using cmd As New SqlCommand(insertSql, conn, transaction)
            AddSupplierParameters(cmd)
            cmd.Parameters.AddWithValue("@CreatedBy", 1)
            cmd.ExecuteNonQuery()
        End Using
        
        ' Get the new supplier ID
        Using cmd As New SqlCommand("SELECT IDENT_CURRENT('Suppliers')", conn, transaction)
            newSupplierId = Convert.ToInt32(cmd.ExecuteScalar())
        End Using

        ' Note: Chart of Accounts entry is auto-created by database trigger trg_Suppliers_CreateAccount
    End Sub
    
    Private Sub UpdateSupplier(conn As SqlConnection, transaction As SqlTransaction)
        Dim sql = "UPDATE Suppliers SET CompanyName = @CompanyName, ContactPerson = @ContactPerson, " &
                  "Email = @Email, Phone = @Phone, Mobile = @Mobile, " &
                  "City = @City, Province = @Province, PostalCode = @PostalCode, Country = @Country, " &
                  "VATNumber = @VATNumber, PaymentTermsDays = @PaymentTermsDays, CreditLimit = @CreditLimit, " &
                  "Address = @Address, BankName = @BankName, BranchCode = @BranchCode, AccountNumber = @AccountNumber, " &
                  "PaymentTerms = @PaymentTerms, Notes = @Notes, SupplierCode = @SupplierCode, " &
                  "BankAccountType = @BankAccountType, " &
                  "ProofOfPaymentEmail = @ProofOfPaymentEmail, IsActive = @IsActive, " &
                  "ModifiedDate = GETDATE(), ModifiedBy = 1 " &
                  "WHERE SupplierID = @SupplierID"
        
        Using cmd As New SqlCommand(sql, conn, transaction)
            AddSupplierParameters(cmd)
            cmd.Parameters.AddWithValue("@SupplierID", _supplierId.Value)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Sub AddSupplierParameters(cmd As SqlCommand)
        cmd.Parameters.AddWithValue("@CompanyName", txtCompanyName.Text.Trim())
        cmd.Parameters.AddWithValue("@ContactPerson", If(String.IsNullOrWhiteSpace(txtContactPerson.Text), DBNull.Value, txtContactPerson.Text.Trim()))
        cmd.Parameters.AddWithValue("@Email", If(String.IsNullOrWhiteSpace(txtEmail.Text), DBNull.Value, txtEmail.Text.Trim()))
        cmd.Parameters.AddWithValue("@Phone", If(String.IsNullOrWhiteSpace(txtPhone.Text), DBNull.Value, txtPhone.Text.Trim()))
        cmd.Parameters.AddWithValue("@Mobile", If(String.IsNullOrWhiteSpace(txtMobile.Text), DBNull.Value, txtMobile.Text.Trim()))
        cmd.Parameters.AddWithValue("@City", If(String.IsNullOrWhiteSpace(txtCity.Text), DBNull.Value, txtCity.Text.Trim()))
        cmd.Parameters.AddWithValue("@Province", If(String.IsNullOrWhiteSpace(txtProvince.Text), DBNull.Value, txtProvince.Text.Trim()))
        cmd.Parameters.AddWithValue("@PostalCode", If(String.IsNullOrWhiteSpace(txtPostalCode.Text), DBNull.Value, txtPostalCode.Text.Trim()))
        cmd.Parameters.AddWithValue("@Country", If(String.IsNullOrWhiteSpace(txtCountry.Text), DBNull.Value, txtCountry.Text.Trim()))
        cmd.Parameters.AddWithValue("@VATNumber", If(String.IsNullOrWhiteSpace(txtVATNumber.Text), DBNull.Value, txtVATNumber.Text.Trim()))
        
        Dim paymentDays As Object = DBNull.Value
        If Not String.IsNullOrWhiteSpace(txtPaymentTermsDays.Text) AndAlso IsNumeric(txtPaymentTermsDays.Text) Then
            paymentDays = Convert.ToInt32(txtPaymentTermsDays.Text)
        End If
        cmd.Parameters.AddWithValue("@PaymentTermsDays", paymentDays)
        
        Dim creditLimit As Object = DBNull.Value
        If Not String.IsNullOrWhiteSpace(txtCreditLimit.Text) AndAlso IsNumeric(txtCreditLimit.Text) Then
            creditLimit = Convert.ToDecimal(txtCreditLimit.Text)
        End If
        cmd.Parameters.AddWithValue("@CreditLimit", creditLimit)
        
        cmd.Parameters.AddWithValue("@Address", If(String.IsNullOrWhiteSpace(txtAddress.Text), DBNull.Value, txtAddress.Text.Trim()))
        cmd.Parameters.AddWithValue("@BankName", txtBankName.Text.Trim())
        cmd.Parameters.AddWithValue("@BranchCode", txtBranchCode.Text.Trim())
        cmd.Parameters.AddWithValue("@AccountNumber", txtAccountNumber.Text.Trim())
        cmd.Parameters.AddWithValue("@PaymentTerms", If(String.IsNullOrWhiteSpace(txtPaymentTerms.Text), DBNull.Value, txtPaymentTerms.Text.Trim()))
        cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrWhiteSpace(txtNotes.Text), DBNull.Value, txtNotes.Text.Trim()))
        cmd.Parameters.AddWithValue("@SupplierCode", If(String.IsNullOrWhiteSpace(txtSupplierCode.Text), DBNull.Value, txtSupplierCode.Text.Trim()))
        cmd.Parameters.AddWithValue("@BankAccountType", If(cboAccountType.SelectedItem Is Nothing, DBNull.Value, cboAccountType.SelectedItem.ToString()))
        cmd.Parameters.AddWithValue("@ProofOfPaymentEmail", If(String.IsNullOrWhiteSpace(txtProofOfPaymentEmail.Text), DBNull.Value, txtProofOfPaymentEmail.Text.Trim()))
        cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked)
    End Sub

    ' Chart of Accounts entry is auto-created by database trigger trg_Suppliers_CreateAccount
    ' No manual creation needed
End Class
