Imports System.Windows.Forms
Imports System.Drawing
Imports System.Configuration

Namespace Accounting
    Public Class BeneficiaryManagementForm
        Inherits Form

        Private WithEvents dgvBeneficiaries As DataGridView
        Private WithEvents btnNew As Button
        Private WithEvents btnEdit As Button
        Private WithEvents btnDelete As Button
        Private WithEvents btnRefresh As Button
        Private txtSearch As TextBox
        Private _invoiceService As APInvoiceService

        Public Sub New()
            InitializeComponent()
            _invoiceService = New APInvoiceService()
            LoadBeneficiaries()
        End Sub

        Private Sub InitializeComponent()
            Me.Text = "Beneficiary Management"
            Me.Size = New Size(1400, 700)
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.BackColor = Color.White

            ' Header Panel
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = Color.FromArgb(52, 152, 219),
                .Padding = New Padding(20)
            }

            Dim lblTitle As New Label() With {
                .Text = "Beneficiary Management",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 15)
            }
            pnlHeader.Controls.Add(lblTitle)

            Dim lblSubtitle As New Label() With {
                .Text = "Manage supplier and vendor bank account details",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Location = New Point(20, 45)
            }
            pnlHeader.Controls.Add(lblSubtitle)

            ' Toolbar Panel
            Dim pnlToolbar As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 60,
                .BackColor = Color.FromArgb(236, 240, 241),
                .Padding = New Padding(20, 10, 20, 10)
            }

            btnNew = New Button() With {
                .Text = "➕ New Beneficiary",
                .Location = New Point(20, 15),
                .Size = New Size(150, 35),
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Font = New Font("Segoe UI", 9, FontStyle.Bold)
            }
            pnlToolbar.Controls.Add(btnNew)

            btnEdit = New Button() With {
                .Text = "✏ Edit",
                .Location = New Point(180, 15),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(52, 152, 219),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Enabled = False
            }
            pnlToolbar.Controls.Add(btnEdit)

            btnDelete = New Button() With {
                .Text = "🗑 Delete",
                .Location = New Point(290, 15),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(231, 76, 60),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand,
                .Enabled = False
            }
            pnlToolbar.Controls.Add(btnDelete)

            btnRefresh = New Button() With {
                .Text = "🔄 Refresh",
                .Location = New Point(400, 15),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(149, 165, 166),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat,
                .Cursor = Cursors.Hand
            }
            pnlToolbar.Controls.Add(btnRefresh)

            Dim lblSearch As New Label() With {
                .Text = "Search:",
                .Location = New Point(920, 22),
                .AutoSize = True
            }
            pnlToolbar.Controls.Add(lblSearch)

            txtSearch = New TextBox() With {
                .Location = New Point(980, 18),
                .Width = 200
            }
            AddHandler txtSearch.TextChanged, AddressOf OnSearchTextChanged
            pnlToolbar.Controls.Add(txtSearch)

            ' Grid Panel
            Dim pnlGrid As New Panel() With {
                .Dock = DockStyle.Fill,
                .Padding = New Padding(20)
            }

            dgvBeneficiaries = New DataGridView() With {
                .Dock = DockStyle.Fill,
                .BackgroundColor = Color.White,
                .BorderStyle = BorderStyle.None,
                .AllowUserToAddRows = False,
                .AllowUserToDeleteRows = False,
                .ReadOnly = True,
                .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                .RowHeadersVisible = False,
                .AlternatingRowsDefaultCellStyle = New DataGridViewCellStyle() With {.BackColor = Color.FromArgb(245, 245, 245)}
            }
            AddHandler dgvBeneficiaries.SelectionChanged, AddressOf OnSelectionChanged
            AddHandler dgvBeneficiaries.CellDoubleClick, AddressOf OnCellDoubleClick
            pnlGrid.Controls.Add(dgvBeneficiaries)

            Me.Controls.Add(pnlGrid)
            Me.Controls.Add(pnlToolbar)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadBeneficiaries()
            Try
                Dim dt = _invoiceService.GetBeneficiaries()
                dgvBeneficiaries.DataSource = dt

                If dgvBeneficiaries.Columns.Count > 0 Then
                    dgvBeneficiaries.Columns("BeneficiaryID").Visible = False
                    dgvBeneficiaries.Columns("BeneficiaryName").HeaderText = "Beneficiary Name"
                    dgvBeneficiaries.Columns("BeneficiaryType").HeaderText = "Type"
                    dgvBeneficiaries.Columns("BankName").HeaderText = "Bank"
                    dgvBeneficiaries.Columns("BranchCode").HeaderText = "Branch Code"
                    dgvBeneficiaries.Columns("AccountNumber").HeaderText = "Account Number"
                    dgvBeneficiaries.Columns("AccountType").HeaderText = "Account Type"
                    dgvBeneficiaries.Columns("ContactPerson").HeaderText = "Contact Person"
                    dgvBeneficiaries.Columns("Email").HeaderText = "Email"
                    dgvBeneficiaries.Columns("Phone").HeaderText = "Phone"
                    dgvBeneficiaries.Columns("DefaultCategory").HeaderText = "Default Category"
                    dgvBeneficiaries.Columns("IsActive").HeaderText = "Active"
                End If
            Catch ex As Exception
                MessageBox.Show($"Error loading beneficiaries: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnSelectionChanged(sender As Object, e As EventArgs)
            Dim hasSelection = dgvBeneficiaries.SelectedRows.Count > 0
            btnEdit.Enabled = hasSelection
            btnDelete.Enabled = hasSelection
        End Sub

        Private Sub OnCellDoubleClick(sender As Object, e As DataGridViewCellEventArgs)
            If e.RowIndex >= 0 Then
                btnEdit.PerformClick()
            End If
        End Sub

        Private Sub OnSearchTextChanged(sender As Object, e As EventArgs)
            Try
                Dim dt = CType(dgvBeneficiaries.DataSource, DataTable)
                If dt IsNot Nothing Then
                    Dim searchText = txtSearch.Text.Trim()
                    If String.IsNullOrEmpty(searchText) Then
                        dt.DefaultView.RowFilter = ""
                    Else
                        dt.DefaultView.RowFilter = $"BeneficiaryName LIKE '%{searchText}%' OR BankName LIKE '%{searchText}%' OR AccountNumber LIKE '%{searchText}%'"
                    End If
                End If
            Catch ex As Exception
            End Try
        End Sub

        Private Sub btnNew_Click(sender As Object, e As EventArgs) Handles btnNew.Click
            Using dlg As New BeneficiaryDialog(_invoiceService)
                If dlg.ShowDialog(Me) = DialogResult.OK Then
                    LoadBeneficiaries()
                End If
            End Using
        End Sub

        Private Sub btnEdit_Click(sender As Object, e As EventArgs) Handles btnEdit.Click
            If dgvBeneficiaries.SelectedRows.Count = 0 Then Return

            Dim beneficiaryId = CInt(dgvBeneficiaries.SelectedRows(0).Cells("BeneficiaryID").Value)
            Dim row = dgvBeneficiaries.SelectedRows(0)

            Using dlg As New BeneficiaryDialog(_invoiceService, beneficiaryId, row)
                If dlg.ShowDialog(Me) = DialogResult.OK Then
                    LoadBeneficiaries()
                End If
            End Using
        End Sub

        Private Sub btnDelete_Click(sender As Object, e As EventArgs) Handles btnDelete.Click
            If dgvBeneficiaries.SelectedRows.Count = 0 Then Return

            Dim result = MessageBox.Show("Are you sure you want to deactivate this beneficiary?", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result = DialogResult.Yes Then
                Try
                    Dim beneficiaryId = CInt(dgvBeneficiaries.SelectedRows(0).Cells("BeneficiaryID").Value)
                    Using conn As New SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                        conn.Open()
                        Dim cmd As New SqlClient.SqlCommand("UPDATE AP_Beneficiaries SET IsActive = 0 WHERE BeneficiaryID = @ID", conn)
                        cmd.Parameters.AddWithValue("@ID", beneficiaryId)
                        cmd.ExecuteNonQuery()
                    End Using
                    LoadBeneficiaries()
                    MessageBox.Show("Beneficiary deactivated successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Catch ex As Exception
                    MessageBox.Show($"Error deactivating beneficiary: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        End Sub

        Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
            LoadBeneficiaries()
        End Sub
    End Class

    ' ===== Beneficiary Dialog =====
    Public Class BeneficiaryDialog
        Inherits Form

        Private WithEvents btnSave As Button
        Private btnCancel As Button
        Private txtBeneficiaryName As TextBox
        Private cboType As ComboBox
        Private txtBankName As TextBox
        Private txtBranchCode As TextBox
        Private txtAccountNumber As TextBox
        Private cboAccountType As ComboBox
        Private txtContactPerson As TextBox
        Private txtEmail As TextBox
        Private txtPhone As TextBox
        Private cboDefaultCategory As ComboBox
        Private _invoiceService As APInvoiceService
        Private _beneficiaryId As Integer?
        Private _isEditMode As Boolean

        Public Sub New(invoiceService As APInvoiceService, Optional beneficiaryId As Integer? = Nothing, Optional existingRow As DataGridViewRow = Nothing)
            _invoiceService = invoiceService
            _beneficiaryId = beneficiaryId
            _isEditMode = beneficiaryId.HasValue
            InitializeComponent()
            LoadCategories()

            If _isEditMode AndAlso existingRow IsNot Nothing Then
                LoadExistingData(existingRow)
            End If
        End Sub

        Private Sub InitializeComponent()
            Me.Text = If(_isEditMode, "Edit Beneficiary", "New Beneficiary")
            Me.Size = New Size(600, 550)
            Me.StartPosition = FormStartPosition.CenterParent
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.MaximizeBox = False
            Me.MinimizeBox = False
            Me.BackColor = Color.White

            Dim yPos = 20

            ' Beneficiary Name
            Dim lblName As New Label() With {.Text = "Beneficiary Name:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblName)
            txtBeneficiaryName = New TextBox() With {.Location = New Point(160, yPos - 3), .Width = 400}
            Me.Controls.Add(txtBeneficiaryName)
            yPos += 35

            ' Type
            Dim lblType As New Label() With {.Text = "Type:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblType)
            cboType = New ComboBox() With {.Location = New Point(160, yPos - 3), .Width = 200, .DropDownStyle = ComboBoxStyle.DropDownList}
            cboType.Items.AddRange({"Individual", "Company"})
            cboType.SelectedIndex = 1
            Me.Controls.Add(cboType)
            yPos += 35

            ' Bank Name
            Dim lblBank As New Label() With {.Text = "Bank Name:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblBank)
            txtBankName = New TextBox() With {.Location = New Point(160, yPos - 3), .Width = 400}
            Me.Controls.Add(txtBankName)
            yPos += 35

            ' Branch Code
            Dim lblBranch As New Label() With {.Text = "Branch Code:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblBranch)
            txtBranchCode = New TextBox() With {.Location = New Point(160, yPos - 3), .Width = 150}
            Me.Controls.Add(txtBranchCode)
            yPos += 35

            ' Account Number
            Dim lblAccount As New Label() With {.Text = "Account Number:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblAccount)
            txtAccountNumber = New TextBox() With {.Location = New Point(160, yPos - 3), .Width = 200}
            Me.Controls.Add(txtAccountNumber)
            yPos += 35

            ' Account Type
            Dim lblAccType As New Label() With {.Text = "Account Type:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblAccType)
            cboAccountType = New ComboBox() With {.Location = New Point(160, yPos - 3), .Width = 200, .DropDownStyle = ComboBoxStyle.DropDownList}
            cboAccountType.Items.AddRange({"Cheque", "Savings", "Transmission"})
            cboAccountType.SelectedIndex = 0
            Me.Controls.Add(cboAccountType)
            yPos += 35

            ' Contact Person
            Dim lblContact As New Label() With {.Text = "Contact Person:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblContact)
            txtContactPerson = New TextBox() With {.Location = New Point(160, yPos - 3), .Width = 400}
            Me.Controls.Add(txtContactPerson)
            yPos += 35

            ' Email
            Dim lblEmail As New Label() With {.Text = "Email:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblEmail)
            txtEmail = New TextBox() With {.Location = New Point(160, yPos - 3), .Width = 400}
            Me.Controls.Add(txtEmail)
            yPos += 35

            ' Phone
            Dim lblPhone As New Label() With {.Text = "Phone:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblPhone)
            txtPhone = New TextBox() With {.Location = New Point(160, yPos - 3), .Width = 200}
            Me.Controls.Add(txtPhone)
            yPos += 35

            ' Default Category
            Dim lblCategory As New Label() With {.Text = "Default Category:", .Location = New Point(20, yPos), .AutoSize = True}
            Me.Controls.Add(lblCategory)
            cboDefaultCategory = New ComboBox() With {.Location = New Point(160, yPos - 3), .Width = 300, .DropDownStyle = ComboBoxStyle.DropDownList}
            Me.Controls.Add(cboDefaultCategory)
            yPos += 50

            ' Buttons
            btnSave = New Button() With {
                .Text = If(_isEditMode, "Update", "Save"),
                .Location = New Point(380, yPos),
                .Size = New Size(100, 35),
                .BackColor = Color.FromArgb(46, 204, 113),
                .ForeColor = Color.White,
                .FlatStyle = FlatStyle.Flat
            }
            Me.Controls.Add(btnSave)

            btnCancel = New Button() With {
                .Text = "Cancel",
                .Location = New Point(490, yPos),
                .Size = New Size(70, 35),
                .DialogResult = DialogResult.Cancel
            }
            Me.Controls.Add(btnCancel)
        End Sub

        Private Sub LoadCategories()
            Dim dt = _invoiceService.GetCategories()
            cboDefaultCategory.DisplayMember = "CategoryName"
            cboDefaultCategory.ValueMember = "CategoryID"
            cboDefaultCategory.DataSource = dt
        End Sub

        Private Sub LoadExistingData(row As DataGridViewRow)
            txtBeneficiaryName.Text = row.Cells("BeneficiaryName").Value?.ToString()
            cboType.Text = row.Cells("BeneficiaryType").Value?.ToString()
            txtBankName.Text = row.Cells("BankName").Value?.ToString()
            txtBranchCode.Text = row.Cells("BranchCode").Value?.ToString()
            txtAccountNumber.Text = row.Cells("AccountNumber").Value?.ToString()
            cboAccountType.Text = row.Cells("AccountType").Value?.ToString()
            txtContactPerson.Text = row.Cells("ContactPerson").Value?.ToString()
            txtEmail.Text = row.Cells("Email").Value?.ToString()
            txtPhone.Text = row.Cells("Phone").Value?.ToString()
        End Sub

        Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
            Try
                ' Validation
                If String.IsNullOrWhiteSpace(txtBeneficiaryName.Text) Then
                    MessageBox.Show("Please enter beneficiary name", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                If String.IsNullOrWhiteSpace(txtBankName.Text) Then
                    MessageBox.Show("Please enter bank name", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                If String.IsNullOrWhiteSpace(txtAccountNumber.Text) Then
                    MessageBox.Show("Please enter account number", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If

                Dim defaultCategoryId = If(cboDefaultCategory.SelectedValue IsNot Nothing, CInt(cboDefaultCategory.SelectedValue), CType(Nothing, Integer?))

                If _isEditMode Then
                    ' Update existing
                    _invoiceService.UpdateBeneficiary(
                        _beneficiaryId.Value,
                        txtBeneficiaryName.Text.Trim(),
                        cboType.Text,
                        txtBankName.Text.Trim(),
                        txtBranchCode.Text.Trim(),
                        txtAccountNumber.Text.Trim(),
                        cboAccountType.Text,
                        txtContactPerson.Text.Trim(),
                        txtEmail.Text.Trim(),
                        txtPhone.Text.Trim(),
                        defaultCategoryId
                    )
                    MessageBox.Show("Beneficiary updated successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Else
                    ' Create new
                    _invoiceService.CreateBeneficiary(
                        txtBeneficiaryName.Text.Trim(),
                        cboType.Text,
                        txtBankName.Text.Trim(),
                        txtBranchCode.Text.Trim(),
                        txtAccountNumber.Text.Trim(),
                        cboAccountType.Text,
                        txtContactPerson.Text.Trim(),
                        txtEmail.Text.Trim(),
                        txtPhone.Text.Trim(),
                        defaultCategoryId
                    )
                    MessageBox.Show("Beneficiary created successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If

                Me.DialogResult = DialogResult.OK
                Me.Close()
            Catch ex As Exception
                MessageBox.Show($"Error saving beneficiary: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub
    End Class
End Namespace
